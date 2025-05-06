//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Vladislav Sokolov on 10.04.2025.
//

import Foundation

final class OAuth2Service {
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    static let shared = OAuth2Service()
    private init() {}
    struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String?
        let createdAt: Int?
        
        private enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
        
    }
    
    let tokenStorage = OAuth2TokenStorage.shared
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code {
                task?.cancel()
            }
            else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        else {
            if lastCode == code {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        lastCode = code
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NetworkError.urlSessionError))
            return
        }
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                switch (data, error) {
                case (let data?, nil):
                    do {
                        let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                        self?.tokenStorage.token = tokenResponse.accessToken
                        print("Токен получен и сохранен: \(tokenResponse.accessToken)")
                        completion(.success(tokenResponse.accessToken))
                    } catch {
                        print("Ошибка декодирования: \(error)")
                        completion(.failure(error))
                    }
                case (nil, let error?):
                    print("Сетевая ошибка: \(error)")
                    completion(.failure(error))
                case (nil, nil ):
                    print("Нет данных")
                    completion(.failure(AuthServiceError.noData))
                default:
                    print("В ответе сервера содержится ошибка: \(String(describing: error))")
                }
                self?.task = nil
                self?.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        let baseURL = Constants.defaultBaseURL
        guard let url = URL(
            string: "oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&grant_type=authorization_code"
            + "&&code=\(code)",
            relativeTo: baseURL
        )
        else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.post.rawValue
        return request
    }
}

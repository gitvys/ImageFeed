//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Vladislav Sokolov on 10.04.2025.
//

import Foundation

final class OAuth2Service {
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
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NetworkError.urlSessionError))
            return
        }
        
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let success):
                do {
                    let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: success)
                    self.tokenStorage.token = tokenResponse.accessToken
                    print("Токен получен и сохранен: \(tokenResponse.accessToken)")
                    completion(.success(tokenResponse.accessToken))
                } catch {
                    print("Ошибка декодирования: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Сетевая ошибка: \(error)")
                completion(.failure(error))
            }
        }
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
        else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.post.rawValue
        return request
    }
}

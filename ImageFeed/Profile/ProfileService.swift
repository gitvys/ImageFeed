//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Vladislav Sokolov on 02.05.2025.
//

import Foundation

final class ProfileService {
    private let tokenStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    static let shared = ProfileService()
    private(set) var profile: Profile?
    
    struct ProfileResult: Codable {
        let username: String
        let firstName: String
        let lastName: String
        let bio: String?
        
        private enum CodingKeys: String, CodingKey {
            case username
            case firstName = "first_name"
            case lastName = "last_name"
            case bio
        }
    }
    
    struct Profile {
        let username: String
        let name: String
        let loginName: String
        let bio: String
    }
    
    private func makeProfileDataRequest() -> URLRequest? {
        let baseURL = Constants.appAPIBaseURL
        guard let url = URL(
            string: "/me",
            relativeTo: baseURL
        )
        else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.get.rawValue
        if let token = tokenStorage.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        else {
            assertionFailure("Token is nil")
        }
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        
        guard let request = makeProfileDataRequest() else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Ошибка при получении профиля: \(error)")
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    print("Нет данных")
                    completion(.failure(AuthServiceError.noData))
                    return
                }
                
                // Выводим данные для отладки
                        if let responseString = String(data: data, encoding: .utf8) {
                            print("Ответ сервера: \(responseString)")
                        }
                
                do {
                    let profileResult = try JSONDecoder().decode(ProfileResult.self, from: data)
                    let name = "\(profileResult.firstName) \(profileResult.lastName)"
                    let loginName = "@\(profileResult.username)"
                    let profile = Profile(username: profileResult.username, name: name, loginName: loginName, bio: profileResult.bio ?? "")
                    self.profile = profile
                    completion(.success(profile))
                }
                catch {
                    print("Ошибка декодирования: \(error)")
                    completion(.failure(error))
                }
            }
        }
        task?.resume()
    }
}

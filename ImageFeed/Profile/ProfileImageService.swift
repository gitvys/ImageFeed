//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Vladislav Sokolov on 06.05.2025.
//

import Foundation

final class ProfileImageService {
    private let profileService = ProfileService.shared
    static let shared = ProfileImageService()
    private(set) var avatarURL: String?
    private let tokenStorage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?
    
    struct ProfileImage: Codable {
        let small: String
    }
    
    struct UserResult: Codable {
        let profileImage: ProfileImage
        
        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
    }
    
    private init() {}
    
    private func makeProfileImageRequest() -> URLRequest? {
        let baseURL = Constants.appAPIBaseURL
        guard let url = URL(
            string: "/users/\(String(describing: profileService.profile?.username))",
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
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            task?.cancel()
        }
        
        guard let request = makeProfileImageRequest() else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Ошибка при получении изображения: \(error)")
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    print("Нет данных")
                    completion(.failure(AuthServiceError.noData))
                    return
                }
                
                do {
                    let profileImageResult = try JSONDecoder().decode(UserResult.self, from: data)
                    let small = "\(profileImageResult.profileImage.small))"
                    completion(.success(small))
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

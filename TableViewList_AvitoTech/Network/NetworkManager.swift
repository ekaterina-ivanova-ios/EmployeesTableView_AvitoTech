import Foundation

protocol NetworkManagerProtocol {
    func fetch(requestModel: RequestModel, completionHandler: @escaping (Result<Data, NetworkError>) -> Void)
}

final class NetworkManager: NetworkManagerProtocol {
    
    func fetch(requestModel: RequestModel, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: requestModel.url) else {
            completionHandler(.failure(.invalidUrl))
            return
        }
        var request = URLRequest(url: url,
                                cachePolicy: .useProtocolCachePolicy,
                                timeoutInterval: 60*60)
        request.httpMethod = requestModel.httpMethod.rawValue

        let session = URLSession.shared
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                    completionHandler(.success(data))
            } else {
                    completionHandler(.failure(.networkTaskError))
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidUrl, networkTaskError, decodeError
}

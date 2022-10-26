import Foundation

final class EmployeesNetworkService {
    let networkManager: NetworkManagerProtocol
    var employeesSorted: [DataEmployeesModel]?
    var employeesList: [DataEmployeesModel]?
    
    func fetchData(completionHandler: @escaping (Result<CommonData, NetworkError>) -> Void) {

        let httpMethod = HttpMethod.get
        let url = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
        let requestModel = RequestModel(httpMethod: httpMethod, url: url)
        networkManager.fetch(requestModel: requestModel) { result in
            switch result {
            case .success(let data):
                guard let decodedResponse = try? JSONDecoder().decode(CommonData.self, from: data) else {
                    completionHandler(.failure(.decodeError))
                    return
                }
                
                //конвертируем данные из структуры CommonData в структуру DataEmployeesModel
                for employee in decodedResponse.company.employees {
                    let model = DataEmployeesModel(nameCompany: decodedResponse.company.name,
                                                   nameEmployees: employee.name,
                                                   phoneEmployees: employee.phoneNumber,
                                                   skillsEmployees: employee.skills)
                    //добавляем в массив данные
                    self.employeesList?.append(model)
                }
                
                //сортируем массив с работниками по именам в алфавитном порядке
                self.employeesSorted = (self.employeesList?.sorted {
                    guard let firstName = $0.nameEmployees else { return false }
                    guard let secondName = $1.nameEmployees else { return true }
                    return firstName < secondName
                })
                
                completionHandler(.success(decodedResponse))
                
            case .failure(let error):
                completionHandler(.failure(error))
                
            }
        }
    }
    
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}



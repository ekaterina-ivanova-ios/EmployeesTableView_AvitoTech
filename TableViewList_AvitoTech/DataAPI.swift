
import Foundation

protocol DataAPIProtocol {
    static func getEmployeesList()->[DataEmployeesModel]
}

struct DataAPI: DataAPIProtocol {
    
    static func getEmployeesList() -> [DataEmployeesModel] {
        let employeesList: [DataEmployeesModel] = [
            DataEmployeesModel(nameCompany: "Avito", nameEmployees: "David", phoneEmployees: "909090", skillsEmployees: ["swift","xcode"]),
            DataEmployeesModel(nameCompany: "Avito", nameEmployees: "Kate", phoneEmployees: "038292", skillsEmployees: ["swift","xcode"]),
            DataEmployeesModel(nameCompany: "Avito", nameEmployees: "Max", phoneEmployees: "121212", skillsEmployees: ["swift","xcode"]),
            DataEmployeesModel(nameCompany: "Avito", nameEmployees: "Anna", phoneEmployees: "232323", skillsEmployees: ["swift","xcode"]),
            DataEmployeesModel(nameCompany: "Avito", nameEmployees: "Ban", phoneEmployees: "232323", skillsEmployees: ["swift","xcode","git"]),
        ]
        
     //   let employeesListWithSort = employeesList.sorted{ $0.nameEmployees! < $1.nameEmployees!}
        let employeesListWithSort = employeesList.sorted{ $0.nameEmployees ?? "nil" < $1.nameEmployees ?? "nil"}

        return employeesListWithSort
    }
}

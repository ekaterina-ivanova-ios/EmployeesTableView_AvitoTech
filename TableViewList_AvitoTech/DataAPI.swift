
import Foundation

struct DataAPI {
 
    
    static func getEmployeesList() -> [DataEmployeesModel] {
        let employeesList: [DataEmployeesModel] = [
            DataEmployeesModel(nameCompany: "Avito", nameEmployees: "David", phoneEmployees: "909090", skillsEmployees: ["swift","xcode","swift","xcode","swift","xcode"]),
            DataEmployeesModel(nameCompany: "Avito", nameEmployees: "Kamila", phoneEmployees: "038292", skillsEmployees: ["swift","xcode"]),
            DataEmployeesModel(nameCompany: "Avito", nameEmployees: "Max", phoneEmployees: "121212", skillsEmployees: ["swift","xcode"]),
            DataEmployeesModel(nameCompany: "Avito", nameEmployees: "Anna", phoneEmployees: "232323", skillsEmployees: ["swift","xcode"]),
            DataEmployeesModel(nameCompany: "Avito", nameEmployees: "Ban", phoneEmployees: "232323", skillsEmployees: ["swift","xcode","git"]),
        ]

        let employeesListWithSort = employeesList.sorted {
                    guard let firstName = $0.nameEmployees else { return false }
                    guard let secondName = $1.nameEmployees else { return true }
                    return firstName < secondName
                }

        
        return employeesListWithSort
    }
    
    
}

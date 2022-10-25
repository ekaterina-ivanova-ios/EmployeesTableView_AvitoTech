
import Foundation

 class DataEmployeesModel {
    let nameCompany: String?
    let nameEmployees: String?
    let phoneEmployees: String?
    let skillsEmployees: [String]?
     
     init(nameCompany: String?, nameEmployees: String?, phoneEmployees: String?, skillsEmployees: [String]?) {
         self.nameCompany = nameCompany
         self.nameEmployees = nameEmployees
         self.phoneEmployees = phoneEmployees
         self.skillsEmployees = skillsEmployees
     }
     
}

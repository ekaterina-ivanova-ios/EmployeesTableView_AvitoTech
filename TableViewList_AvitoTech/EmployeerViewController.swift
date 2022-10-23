
import UIKit

final class EmployeerViewController: UIViewController {
    
    //private let employees = DataAPI.getEmployeesList()
    private let employees = DataAPI.getEmployeesList()
    let employeesTableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(employeesTableView)
        
        employeesTableView.delegate = self
        employeesTableView.dataSource = self
        
        settingTableView()
        
        employeesTableView.register(EmployeesTableViewCell.self, forCellReuseIdentifier: "employeeCell")
        navigationItem.title = "EmployeesList"
    }
    
    private func settingTableView() {
        employeesTableView.translatesAutoresizingMaskIntoConstraints = false
        employeesTableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        employeesTableView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        employeesTableView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        employeesTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    }
    
}

//MARK: add extension for uitableview
extension EmployeerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as! EmployeesTableViewCell
        cell.employees = employees[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}


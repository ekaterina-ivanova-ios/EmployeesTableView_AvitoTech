
import UIKit

final class EmployeerViewController: UIViewController {
    
    private var employees = [DataEmployeesModel]()
    private var employeesSorted = [DataEmployeesModel]()
    private let employeesTableView = UITableView()
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    private let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    private let cache = Cache<String, [DataEmployeesModel]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(employeesTableView)
        view.addSubview(myActivityIndicator)
        
        employeesTableView.delegate = self
        employeesTableView.dataSource = self
        
        settingTableView()
        
        showActivityIndicator()
        
        employeesTableView.register(EmployeesTableViewCell.self, forCellReuseIdentifier: "employeeCell")
        navigationItem.title = "EmployeesList"
        
        let employeesNetworkService = EmployeesNetworkService(networkManager: NetworkManager())
        
        if cache.value(forKey: "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c") == nil {
            
            employeesNetworkService.fetchData { [weak self] res in
                self?.hideActivityIndicator()
                guard let self = self else { return }
                print(res)
                switch res {
                case .success(let value):
                    for employee in value.company.employees {
                        let employee = DataEmployeesModel(nameCompany: value.company.name,
                                                          nameEmployees: employee.name,
                                                          phoneEmployees: employee.phoneNumber,
                                                          skillsEmployees: employee.skills)
                        
                        self.employees.append(employee)
                    }
                    
                    self.employeesSorted = (self.employees.sorted {
                        guard let firstName = $0.nameEmployees else { return false }
                        guard let secondName = $1.nameEmployees else { return true }
                        return firstName < secondName
                    })
                    
                    self.cache.insert(self.employeesSorted, forKey: "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c")
                    
                    DispatchQueue.main.async {
                        self.employeesTableView.reloadData()
                    }
                    
                case .failure(let error):
                    switch error {
                    case .decodeError:
                        DispatchQueue.main.async {
                            self.showAlert(error: .decodeError)
                            print("decodeError")
                        }
                    case .invalidUrl:
                        DispatchQueue.main.async {
                            self.showAlert(error: .invalidUrl)
                            print("invalidUrl")
                        }
                    case .networkTaskError:
                        DispatchQueue.main.async {
                            self.showAlert(error: .networkTaskError)
                            print("networkTaskError")
                        }
                    }
                }
            }
        } else {
            self.employeesSorted = cache.value(forKey: "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c")!
            DispatchQueue.main.async {
                self.employeesTableView.reloadData()
            }
        }
    }
    
    //MARK: setting constraints for table view
    private func showActivityIndicator() {
        myActivityIndicator.center = view.center
        myActivityIndicator.color = .systemBlue
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.myActivityIndicator.isHidden = true
            self.myActivityIndicator.stopAnimating()
        }
    }
    
    //MARK: setting constraints for table view
    private func settingTableView() {
        employeesTableView.translatesAutoresizingMaskIntoConstraints = false
        employeesTableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        employeesTableView.leadingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        employeesTableView.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        employeesTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        employeesTableView.backgroundColor = .white
    }
    
}

//MARK: add extension for uitableview
extension EmployeerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeesSorted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as! EmployeesTableViewCell
        cell.employeesCell = employeesSorted[indexPath.row]
        cell.backgroundColor = .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

//MARK: setting alert
extension EmployeerViewController {
        func showAlert(error: NetworkError) {
            switch error {
            case .invalidUrl, .decodeError:
                let alertModel = UIAlertController(
                    title: "Internal error",
                    message: "Please, reinstall the app",
                    preferredStyle: .alert)
                let buttonCancel = UIAlertAction(
                    title: "Cancel",
                    style: .cancel,
                    handler: {_ in
                        DispatchQueue.main.async {
                            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                            Thread.sleep(forTimeInterval: 2)
                            exit(0)
                        }
                })
                alertModel.addAction(buttonCancel)
                present(alertModel, animated: true, completion: nil)
            case .networkTaskError:
                let alertModel = UIAlertController(
                    title: "No internet connection",
                    message: "Please, check your internet connection and restart your app",
                    preferredStyle: .alert)
                let buttonCancel = UIAlertAction(
                    title: "Cancel",
                    style: .cancel,
                    handler: {_ in
                        DispatchQueue.main.async {
                            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                            Thread.sleep(forTimeInterval: 2)
                            exit(0)
                        }
                })
                let buttonRetry = UIAlertAction(
                    title: "Retry",
                    style: .default,
                    handler: {_ in
                        DispatchQueue.main.async {
                            self.viewDidLoad()
                        }
                })
                alertModel.addAction(buttonCancel)
                alertModel.addAction(buttonRetry)
                present(alertModel, animated: true, completion: nil)
            }
        }
}

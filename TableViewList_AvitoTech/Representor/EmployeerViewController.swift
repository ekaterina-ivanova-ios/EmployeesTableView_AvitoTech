
import UIKit

final class EmployeerViewController: UIViewController {
    
    //создаем массив с работниками
    private var employees = [DataEmployeesModel]()
    //создаем массив с работниками, отсортированный по имени в алфавитном порядке
    private var employeesSorted = [DataEmployeesModel]()
    //создаем тэйбл вью
    private let employeesTableView = UITableView()
    //создаем индикатор загрузки
    private let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    //создаем экземпляр для хранения кэша
    private let cache = Cache<String, [DataEmployeesModel]>()
    //создаем url
    private let urlString = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
    //создаем экземпляр EmployeesNetworkService
    private let employeesNetworkService = EmployeesNetworkService(networkManager: NetworkManager())
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(employeesTableView)
        view.addSubview(myActivityIndicator)
        
        employeesTableView.delegate = self
        employeesTableView.dataSource = self
        
        //настраиваем тэйбл вью
        settingTableView()
        //запускаем индикатор
        showActivityIndicator()
        
        employeesTableView.register(EmployeesTableViewCell.self, forCellReuseIdentifier: "employeeCell")
        navigationItem.title = "EmployeesList"
        
        //проверяем, есть ли кэш
        //кэша нет
        if cache.value(forKey: urlString) == nil {
            fetchData()
        } else {
            self.employeesSorted = cache.value(forKey: urlString) ?? []
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
    
    private func fetchData() {
        employeesNetworkService.fetchData { [weak self] res in
            self?.hideActivityIndicator()
            guard let self = self else { return }
            self.handle(result: res)
        }
    }
    
    private func handle(result: Result<CommonData, NetworkError>) {
        switch result {
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
            
            self.cache.insert(self.employeesSorted, forKey: urlString)
            
            DispatchQueue.main.async {
                self.employeesTableView.reloadData()
            }
            
        case .failure(let error):
            switch error {
            case .decodeError:
                DispatchQueue.main.async {
                    self.showAlert(error: .decodeError)
                }
            case .invalidUrl:
                DispatchQueue.main.async {
                    self.showAlert(error: .invalidUrl)
                }
            case .networkTaskError:
                DispatchQueue.main.async {
                    self.showAlert(error: .networkTaskError)
                }
            }
        }
    }
}

//MARK: add extension for uitableview
extension EmployeerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeesSorted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell", for: indexPath) as? EmployeesTableViewCell
        cell?.employeesCell = employeesSorted[indexPath.row]
        cell?.backgroundColor = .white
        
        return cell ?? UITableViewCell()
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

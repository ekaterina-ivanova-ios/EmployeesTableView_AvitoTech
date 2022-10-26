
import UIKit

final class EmployeerViewController: UIViewController {
    
    //создаем массив с работниками
    var employees = [DataEmployeesModel]()
    //создаем массив с работниками, отсортированный по имени в алфавитном порядке
    var employeesSorted = [DataEmployeesModel]()
    //создаем тэйбл вью
    let employeesTableView = UITableView()
    //создаем экземпляр сеанса
    let session = URLSession.shared
    //создаем экземпляр декодера
    let decoder = JSONDecoder()
    //создаем индикатор
    let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(employeesTableView)
        view.addSubview(myActivityIndicator)
        
        employeesTableView.delegate = self
        employeesTableView.dataSource = self
        
        //настраиваем тэйбл вью
        settingTableView()
        
        //настраиваем индикатор
        showActivityIndicator()
        
        employeesTableView.register(EmployeesTableViewCell.self, forCellReuseIdentifier: "employeeCell")
        navigationItem.title = "EmployeesList"
        
        let employeesNetworkService = EmployeesNetworkService(networkManager: NetworkManager())
        employeesNetworkService.fetchData { [weak self] res in
            self?.hideActivityIndicator()
            guard let self = self else { return }
            print(res)
            switch res {
            case .success(let value):
                // здесь достаем данные из value(это ассоциированное значение, в нем передаются данные полученные с сервера)
                for employee in value.company.employees {
                    // преобразуем в подходящую модель
                    let employee = DataEmployeesModel(nameCompany: value.company.name,
                                                      nameEmployees: employee.name,
                                                      phoneEmployees: employee.phoneNumber,
                                                      skillsEmployees: employee.skills)
                    
                    
                    // добавляем в массив
                    self.employees.append(employee)
                }
                
                //сортируем массив с работниками по именам в алфавитном порядке
                self.employeesSorted = (self.employees.sorted {
                    guard let firstName = $0.nameEmployees else { return false }
                    guard let secondName = $1.nameEmployees else { return true }
                    return firstName < secondName
                })
                
                // обновляем таблицу после того как заполнили наш массив
                // здесь нужно немного почитать про многопоточность, в кратце этот блок(кложур у fetchData) выполняется не на главном потоке, а любые UI изменения(например обновление таблицы) нужно осуществлять на главном потоке, поэтому мы переведем обновление таблицы на главный поток
                DispatchQueue.main.async {
                    self.employeesTableView.reloadData()
                }
            case .failure(let error):
                // здесь получаем ошибку и можем показать алерт с этой ошибкой
                print(error)
                switch error {
                case .decodeError:
                    print("decodeError")
                case .invalidUrl:
                    print("invalidUrl")
                case .networkTaskError:
                    print("networkTaskError")
                }
            }
        }
    }
    
    //MARK: setting constraints for table view
    private func showActivityIndicator() {
        myActivityIndicator.center = view.center
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


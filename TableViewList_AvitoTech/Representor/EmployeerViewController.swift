
import UIKit

final class EmployeerViewController: UIViewController {
    
    //создаем массив с работниками
    var employees = [DataEmployeesModel]()
    //создаем массив с работниками, отсортированный по имени в алфавитном порядке
    var employeesSorted = [DataEmployeesModel]()
    //создаем тэйбл вью
    let employeesTableView = UITableView()
    //создаем экземпляр класс URLSessionConfiguration
    let sessionConfiguration = URLSessionConfiguration.default
    //создаем экземпляр сеанса
    let session = URLSession.shared
    //создаем экземпляр декодера
    let decoder = JSONDecoder()
    //url
    let url = URL(string: "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c")
    //создаем переменную для хранения кэша
    private let cache = NSCache<NSString, CommonData>()
    //создаем индикатор загрузки
    private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(employeesTableView)
        
        employeesTableView.delegate = self
        employeesTableView.dataSource = self
        
        //настраиваем тэйбл вью
        settingTableView()
        
        employeesTableView.register(EmployeesTableViewCell.self, forCellReuseIdentifier: "employeeCell")
        navigationItem.title = "EmployeesList"
        
        //загружаем данные
        //fetchData()
        
        let employeesNetworkService = EmployeesNetworkService(networkManager: NetworkManager())
        employeesNetworkService.fetchData { res in
            print(res)
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

//MARK: GET data
extension EmployeerViewController {
    
    func fetchData() {
        
        guard let url = url else {return}
        
        session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else {return}
            //проверяем, есть ли ошибка
            if error == nil, let dataNotNil = data {
                //пытаемся раcпарсить данные из json
                let responseParse = try? strongSelf.decoder.decode(CommonData.self, from: dataNotNil)
                //unwrap optional type
                guard let result = responseParse else {return}
                
                
                //конвертируем данные из структуры CommonData в структуру DataEmployeesModel
                for employee in result.company.employees {
                    let model = DataEmployeesModel(nameCompany: result.company.name,
                                                   nameEmployees: employee.name,
                                                   phoneEmployees: employee.phoneNumber,
                                                   skillsEmployees: employee.skills)
                    //добавляем в массив данные
                    self?.employees.append(model)
                }
                
                //сортируем массив с работниками по именам в алфавитном порядке
                self?.employeesSorted = (self?.employees.sorted {
                    guard let firstName = $0.nameEmployees else { return false }
                    guard let secondName = $1.nameEmployees else { return true }
                    return firstName < secondName
                } ?? [])
                //обновляем вью
                DispatchQueue.main.async {
                    self?.employeesTableView.reloadData()
                }
                
            } else {
                print("Error: Data didn't load")
            }
        }.resume()
        
    }
    
}

//extension EmployeerViewController {
//
//    func fetchData(completion: @escaping (CommonData) -> Void) {
//
//        guard let url = url else {return}
//
//        let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 60*60)
//        let dataTask = session.dataTask(with: request) { [weak self] data, response, error in
//
//            guard error == nil,
//                  data != nil,
//                  let response = response as? HTTPURLResponse,
//                  response.statusCode == 200,
//                  let self =  self else {
//                return
//            }
//
//            guard let data = CommonData(from: <#T##Decoder#>) else {return}
//
//            DispatchQueue.main.async {
//                completion(data)
//            }
//
//
//        }
//
//    }
//
//}

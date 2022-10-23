
import UIKit

final class EmployeesTableViewCell: UITableViewCell {
  
    let randomStringNumber = String(Int.random(in: 1...3))
    
    var employees: DataEmployeesModel? {
        didSet {
            guard let employeesItem = employees else {return}
            
            if let nameEmployee = employeesItem.nameEmployees {
                profileImageView.image = UIImage(named: randomStringNumber)
                nameEmployeeLabel.text = nameEmployee
            }
            if let nameCompany = employeesItem.nameCompany {
                nameCompanyLabel.text = nameCompany
            }
            if let phone = employeesItem.phoneEmployees {
                phoneLabel.text = phone
            }
            if let skills = employeesItem.skillsEmployees {
                let stringSkills = skills.joined(separator: ", ")
                skillsLabel.text = " " + stringSkills + " "
            }
        }
    }
    
    private let profileImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 35
        img.clipsToBounds = true
        return img
    }()
    
    private let nameEmployeeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let skillsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor =  .white
        label.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        label.layer.cornerRadius = 3
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameCompanyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(profileImageView)
        containerView.addSubview(nameEmployeeLabel)
        containerView.addSubview(nameCompanyLabel)
        containerView.addSubview(skillsLabel)
        containerView.addSubview(phoneLabel)
        self.contentView.addSubview(containerView)

        settingCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    private func settingCell() {
        //настройка аватарки
        profileImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant:70).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant:70).isActive = true
        
        //настройка общей плашки
        containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo:self.profileImageView.trailingAnchor, constant:10).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true
        containerView.heightAnchor.constraint(equalToConstant:40).isActive = true
        
        //настройка имени
        nameEmployeeLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
        nameEmployeeLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor, constant: 10).isActive = true
        nameEmployeeLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        
        //настройка плашки название компании
        nameCompanyLabel.bottomAnchor.constraint(equalTo:self.containerView.bottomAnchor).isActive = true
        nameCompanyLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor, constant: -10).isActive = true
        
        //настройка плашки скилы
        skillsLabel.bottomAnchor.constraint(equalTo:self.containerView.bottomAnchor).isActive = true
        skillsLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        
        //настройка плашки номер
        phoneLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
        phoneLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor, constant: -10).isActive = true

    }
}

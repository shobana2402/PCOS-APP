import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var forgotBtn: UIButton!

    var loginModel: LoginModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        userNameTF.text = "shobana"
        passwordTF.text = "12345678"
        userNameTF.delegate = self
        passwordTF.delegate = self
        passwordTF.isSecureTextEntry = true
        Didload()

        forgotBtn.addAction(for: .tap) {
            let doctorVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
            self.navigationController?.pushViewController(doctorVC, animated: true)
        }
    }

    @IBAction func loginAction(_ sender: Any) {
        self.getLoginAPI()
    }

    func getLoginAPI() {
        let userInfo: [String: String] = [
            "username": userNameTF.text ?? "",
            "password": passwordTF.text ?? ""
        ]

        APIHandler.shared.postAPIValues(type: LoginModel.self, apiUrl: ServiceAPI.loginURL, method: "POST", formData: userInfo) { result in
            switch result {
            case .success(let data):
                if !data.success! {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Alert", message: data.message, preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                } else {
                    self.loginModel = data
                    if self.loginModel?.existingUser == true {
                        DispatchQueue.main.async {
                            let patientPlanVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PatientPlanVC") as! PatientPlanVC
                            patientPlanVC.username5 = self.userNameTF.text ?? ""
                            self.navigationController?.pushViewController(patientPlanVC, animated: true)
                        }
                    } else if self.loginModel?.existingUser == false {
                        DispatchQueue.main.async {
                            self.navigateToNextScreen()
                        }
                    }
                }

            case .failure(let error):
                print(error)
            }
        }
    }

    func navigateToNextScreen() {
        if UserDefaultsManager.shared.getUserName() == "Doctor" {
            let doctorVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoctorHomeVC") as! DoctorHomeVC
            self.navigationController?.pushViewController(doctorVC, animated: true)
        } else if UserDefaultsManager.shared.getUserName() == "Patient" {
            let patientPlanVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EnterPatientDetails") as! EnterPatientDetails //EnterPatientDetails
            patientPlanVC.receivedUsername = self.userNameTF.text ?? ""
//            patientPlanVC.username2 = self.userNameTF.text ?? ""
            self.navigationController?.pushViewController(patientPlanVC, animated: true)
        }
    }

    func Didload() {
        if UserDefaultsManager.shared.getUserName() == "Doctor" {
            forgotBtn.isHidden = false
            userNameTF.placeholder = "DOCTOR ID"
            passwordTF.placeholder = "PASSWORD"
        } else if UserDefaultsManager.shared.getUserName() == "Patient" {
            forgotBtn.isHidden = false
            userNameTF.placeholder = "USERNAME"
            passwordTF.placeholder = "PASSWORD"
        }
    }
}

extension UITextField {
    func setGradient(startColor: UIColor, endColor: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.frame = self.bounds
        gradient.cornerRadius = 6
        self.layer.addSublayer(gradient)
    }
}

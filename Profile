import UIKit

class PatientProfileVC: UIViewController {
    
    @IBOutlet weak var nameTF: UILabel!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var occupationTF: UITextField!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var bmiTF: UITextField!
    @IBOutlet weak var diseaseTF: UITextField!
    @IBOutlet weak var scoreTF: UITextField!
    var shouldHideeditButton: Bool = false
    var selectedPatientName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar(title: "Profile")
        if shouldHideeditButton {
            editButton.isHidden = true
            disableUserInteractionForTextFields()
        } else {
            enableUserInteractionForTextFields()
        }
        fetchPatientDetails()
    }
    @IBOutlet weak var editButton : UIButton!
    @IBAction func editProfile(_ sender: Any) {
        self.editProfileDetails()
        self.enableUserInteractionForTextFields()
        
    }
    func disableUserInteractionForTextFields() {
        nameTF.isUserInteractionEnabled = false
        ageTF.isUserInteractionEnabled = false
        occupationTF.isUserInteractionEnabled = false
        heightTF.isUserInteractionEnabled = false
        weight.isUserInteractionEnabled = false
        bmiTF.isUserInteractionEnabled = false
        diseaseTF.isUserInteractionEnabled = false
        scoreTF.isUserInteractionEnabled = false
    }

    func enableUserInteractionForTextFields() {
        nameTF.isUserInteractionEnabled = true
        ageTF.isUserInteractionEnabled = true
        occupationTF.isUserInteractionEnabled = true
        heightTF.isUserInteractionEnabled = true
        weight.isUserInteractionEnabled = true
        bmiTF.isUserInteractionEnabled = true
        diseaseTF.isUserInteractionEnabled = true
        scoreTF.isUserInteractionEnabled = true
    }

    
    func fetchPatientDetails() {
        guard let name = selectedPatientName else {
            return
        }
        
        
        print("Patient Name:", name)
        
        let patientProfileAPIURL = "\(ServiceAPI.baseURL)profile.php?name=\(name)"
        
        APIHandler().getAPIValues(type: PatientProfileModel.self, apiUrl: patientProfileAPIURL, method: "GET") { result in
            switch result {
            case .success(let PatientProfileData):
                // Print the entire JSON response
                print("Received JSON response:", PatientProfileData)
                
                DispatchQueue.main.async {
                    self.nameTF.text = " \(PatientProfileData.patient_details?.name ?? "")"
                    self.ageTF.text = " \(PatientProfileData.patient_details?.age.map(String.init) ?? "")"
                    self.occupationTF.text = " \(PatientProfileData.patient_details?.Mobile_No ?? "")"
                    self.heightTF.text = " \(PatientProfileData.patient_details?.height ?? "")"
                    self.weight.text = " \(PatientProfileData.patient_details?.weight ?? "")"
                    self.bmiTF.text = " \(PatientProfileData.patient_details?.bmi ?? "")"
                    self.diseaseTF.text = " \(PatientProfileData.patient_details?.otherdisease ?? "")"
                    self.scoreTF.text = " \(PatientProfileData.patient_details?.obstetricscore ?? "")"
                }
                
            case .failure(let error):
                print("Error fetching patient details:", error)
            }
        }
    }
    
    func editProfileDetails() {
        let formData: [String: String] = ["name": self.nameTF.text ?? "",
                                          "age": self.ageTF.text ?? "",
                                          "height": self.heightTF.text ?? "",
                                          "weight": self.weight.text ?? "",
                                          "Mobile_No": self.occupationTF.text ?? "",
                                          "otherdisease": self.diseaseTF.text ?? "",
                                          "obstetricScore": self.scoreTF.text ?? "",
                                          "bmi": self.bmiTF.text ?? ""
        ]
        APIHandler().postAPIValues(type: EditProfileModel.self, apiUrl: ServiceAPI.editPatientprofile, method: "POST", formData: formData) { [weak self] result in
            switch result {
            case .success(let data):
                print(data)
                DispatchQueue.main.async { // Ensure UI updates are on the main thread.
                    self?.navigateToPatientPlanVC()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func navigateToPatientPlanVC() {
        // Assuming `PatientPlanVC` is in the same storyboard, replace "Main" with your storyboard name if it's different
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let patientPlanVC = storyboard.instantiateViewController(withIdentifier: "PatientPlanVC") as? PatientPlanVC {
            patientPlanVC.username5 = self.selectedPatientName ?? ""
            // If you are using navigation controller
            self.navigationController?.pushViewController(patientPlanVC, animated: true)
            
            // Or if you are presenting modally
            // self.present(patientPlanVC, animated: true, completion: nil)
        }
    }
}

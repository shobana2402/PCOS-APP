import UIKit

class EnterPatientDetails: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var receivedUsername: String = ""
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var mobile_no: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var weight: UITextField!
    @IBOutlet weak var otherdisease: UITextField!
    @IBOutlet weak var obstetricScore: UITextField!
    @IBOutlet weak var bmiTextField: UITextField!
    var username: String = ""
    var pickerView = UIPickerView()
    var options = ["Single Child", "Two Child", "more Than 2","No child","Unmarried"]
    var selectedOption: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar(title: "Enter The Details")
        pickerView.dataSource = self
        pickerView.delegate = self
        obstetricScore.inputView = pickerView
        pickerView.backgroundColor = UIColor.white
        createToolBar()

        height.addTarget(self, action: #selector(calculateBMI), for: .editingChanged)
        weight.addTarget(self, action: #selector(calculateBMI), for: .editingChanged)
        
        name.text = receivedUsername
    }
   
    func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        obstetricScore.inputAccessoryView = toolBar
    }

    @objc func donePicker() {
        obstetricScore.text = selectedOption
        obstetricScore.resignFirstResponder()
    }

    @objc func calculateBMI() {
        if let heightValue = Double(height.text ?? ""), let weightValue = Double(weight.text ?? "") {
            let bmiValue = weightValue / ((heightValue / 100) * (heightValue / 100))
            bmiTextField.text = String(format: "%.2f", bmiValue)
        } else {
            bmiTextField.text = ""
        }
    }

    @IBAction func submit(_ sender: Any) {
        if areAllFieldsFilled() {
            // Extracting details and sending to API
            getProfileAPI()
            if let enteredName = name.text {
                receivedUsername = enteredName
                        print("Username: \(receivedUsername)")
                    }
            let welcome = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomePatientVC") as! WelcomePatientVC
            welcome.username1 = receivedUsername
            self.navigationController?.pushViewController(welcome, animated: true)
        } else {
            showAlert(message: "Please fill in all fields.")
        }
    }

    func areAllFieldsFilled() -> Bool {
        return !name.text!.isEmpty &&
            !age.text!.isEmpty &&
            !mobile_no.text!.isEmpty &&
            !height.text!.isEmpty &&
            !weight.text!.isEmpty &&
            !otherdisease.text!.isEmpty
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    func getProfileAPI() {
        // Extracting the values from the text fields
        guard
            let name = name.text,
            let age = age.text,
            let mobile_no = mobile_no.text,
            let height = height.text,
            let weight = weight.text,
            let otherdisease = otherdisease.text,
            let obstetricScore = obstetricScore.text,
            let bmi = bmiTextField.text
        else {
            print("Failed to extract values from text fields.")
            return
        }

        let patientDetails = [
            "name": name,
            "age": age,
            "Mobile_No": mobile_no,
            "height": height,
            "weight": weight,
            "otherdisease": otherdisease,
            "obstetricScore": obstetricScore,
            "bmi": bmi  // Add BMI value to the parameters
        ]

        // Assuming you have an APIHandler class with a method similar to this
        APIHandler().postAPIValues(type: profileModel.self, apiUrl: ServiceAPI.profileURL, method: "POST", formData: patientDetails) { result in
            switch result {
            case .success(let profile):
                print("Profile created successfully: \(profile)")
                // Handle success as needed

            case .failure(let error):
                print("Error creating profile: \(error)")
                // Handle error as needed
            }
        }
    }

}

extension EnterPatientDetails {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOption = options[row]
        obstetricScore.text = selectedOption
    }
}

//
//  RegisterViewController.swift
//  fitink
//
//  Created by Manuel on 16/12/20.
//

import UIKit

import Alamofire

class RegisterViewController: UIViewController, UITextFieldDelegate {

    /*
     * Outlets
     */
    @IBOutlet weak var Nombre: UITextField!
    @IBOutlet weak var Telefono: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var PasswordConfirm: UITextField!
    
    @IBOutlet weak var FechaNacimiento: UIDatePicker!
    
    @IBOutlet weak var Altura: UITextField!
    @IBOutlet weak var Peso: UITextField!
    
    @IBOutlet weak var Genero: UISegmentedControl!
    
    @IBOutlet weak var ImagenComplexion: UIImageView!
    @IBOutlet weak var Complexion: UISegmentedControl!
    
    @IBOutlet weak var Frutas: UISwitch!
    @IBOutlet weak var Agua: UISwitch!
    @IBOutlet weak var CarneRoja: UISwitch!
    @IBOutlet weak var Cereales: UISwitch!
    @IBOutlet weak var CarneBlanca: UISwitch!
    @IBOutlet weak var Verduras: UISwitch!
    @IBOutlet weak var Azucares: UISwitch!
    @IBOutlet weak var Chatarra: UISwitch!
    
    @IBOutlet weak var Condicion: UISegmentedControl!
    
    @IBAction func RegistrarmeAction(_ sender: Any) {
        self.register()
    }
    
    /*
     * MARK: Funciones del sistema
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Genero.addTarget(self, action: #selector(handleGeneroSegmentedControlValueChanged(_:)), for: .valueChanged)

        Telefono.addDoneButtonToKeyboard(myAction:  #selector(Telefono.resignFirstResponder), title: "Terminar")
        Altura.addDoneButtonToKeyboard(myAction:  #selector(Altura.resignFirstResponder), title: "Terminar")
        Peso.addDoneButtonToKeyboard(myAction:  #selector(Peso.resignFirstResponder), title: "Terminar")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardObserver()
    }

}

/*
 * MARK: Funciones propias
 */
extension RegisterViewController {
    
    //Ocular teclado al presionar la tecla de retorno
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        
        return true
    }
    
    /*
     * Funcion que se ejecuta al seleccionar una opcion del segmented control
     * del genero
     *
     */
    @objc func handleGeneroSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            print("caso 0: Hombre")

            ImagenComplexion.image = UIImage(named: "complexion-h")
            
        case 1:
            print("caso 1: Mujer")
            
            ImagenComplexion.image = UIImage(named: "complexion-m")
            
        default:
            print("default")
            
            
        }
        
    }

}

/*
 * MARK: Peticiones al servidor
 */
extension RegisterViewController {
    
    /*
     * Permite al usuario crear un nuevo grupo
     */
    func register () {
        
        self.showActivityIndicator()
        
        struct OkResponse:Codable {
            let message:String
            let user:Structs.User
        }
        
        struct FailResponse:Codable {
            let error:String
        }
        
        //let token = UserDefaults.standard.string(forKey: "token")!
        
        if let url = URL(string: "https://fitink.secunet.mx/api/auth/register") {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let parameters: Parameters = [
                "name": Nombre.text!,
                "email": Email.text!,
                "password": Password.text!,
                "password_confirmation": PasswordConfirm.text!,
                "fecha_nacimiento": dateFormatter.string(from: FechaNacimiento.date),
                "telefono": Telefono.text!,
                "genero": Genero.titleForSegment(at: Genero.selectedSegmentIndex)?.lowercased() ?? "",
                "estatura": Altura.text!,
                "peso": Peso.text!,
                "complexion": Complexion.titleForSegment(at: Complexion.selectedSegmentIndex)?.lowercased() ?? "",
                "fruta": Frutas.isOn ? "1" : "0",
                "agua": Agua.isOn ? "1" : "0",
                "carne_roja": CarneRoja.isOn ? "1" : "0",
                "cereales": Cereales.isOn ? "1" : "0",
                "carne_blanca": CarneBlanca.isOn ? "1" : "0",
                "verduras": Verduras.isOn ? "1" : "0",
                "azucares": Azucares.isOn ? "1" : "0",
                "chatarra": Chatarra.isOn ? "1" : "0",
                "condicion": Condicion.titleForSegment(at: Condicion.selectedSegmentIndex)?.lowercased() ?? "",
            ]
            
            print("Registro: \(parameters)")
            
            Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.queryString).responseJSON { response in
                
                response.result.ifFailure {
                    self.hideActivityIndicator()
                }
            
                //to get JSON return value
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    print("JSON: \(JSON)")
                }
                
                //to get status code
                if let status = response.response?.statusCode {
                    
                    switch status {
                        case 0:
                            print("Status code: \(status), error al recibir la respuesta de registro")
                            self.hideActivityIndicator()
                            break
                        case 201 :
                            
                            print("Status code: \(status)")
                            
                            do {
                                let res = try JSONDecoder().decode(OkResponse.self, from: response.data!)
                                
                                DispatchQueue.main.async {
                                    self.hideActivityIndicator()
                                    
                                    let alert = UIAlertController(title: "Registro", message: "Tu registro se completo con exito!!", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {
                                        (action:UIAlertAction!) in
                                        self.performSegue(withIdentifier: "RegistroToLogin", sender: self)
                                    }))
                                    self.present(alert, animated: true)
                                }
                            } catch let error as NSError {
                                self.hideActivityIndicator()
                                print("Error al parsear el JSON de registro", error.localizedDescription)
                            }
                            
                            break
                        case 500:
                            print("Status code: 500")
                            
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Error", message: "500", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                                self.present(alert, animated: true)
                                self.hideActivityIndicator()
                            }
                            break
                        default :
                            print("Status code: \(status)")
                            
                            do {
                                let res = try JSONDecoder().decode(FailResponse.self, from: response.data!)
                                
                                DispatchQueue.main.async {
                                    self.hideActivityIndicator()
                                    let alert = UIAlertController(title: "Error", message: res.error, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
                                    self.present(alert, animated: true)
                                }
                            } catch let error as NSError {
                                self.hideActivityIndicator()
                                print("Error al parsear el JSON de registro", error.localizedDescription)
                            }
                            
                            break
                    }//switch

                }// if let status
            }//Alamofire
            
        }//if let
    }
    
}

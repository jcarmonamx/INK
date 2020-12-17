//
//  ProfileViewController.swift
//  fitink
//
//  Created by Manuel on 17/12/20.
//

import UIKit

import Alamofire

class ProfileViewController: UIViewController, UITextFieldDelegate {

    /*
     * MARK: Variables
     */
    
    /*
     * MARK: Oulets
     */
    @IBOutlet weak var Nombre: UITextField!
    @IBOutlet weak var Telefono: UITextField!
    @IBOutlet weak var Email: UITextField!
    
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
    
    @IBAction func ActualizarAction(_ sender: Any) {
        updateUserProfile()
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
        
        //llenamos los campos con la información del perfil
        loadUserProfile()
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
extension ProfileViewController {
    
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
extension ProfileViewController {
    
    /*
     * Obtiene la información del perfil del usuario
     */
    func loadUserProfile () {
        
        self.showActivityIndicator()
        
        struct OkResponse:Codable {
            let message:String
            let user:Structs.User
        }
        
        struct FailResponse:Codable {
            let error:String
        }
        
        //let token = UserDefaults.standard.string(forKey: "token")!
        
        if let url = URL(string: "https://fitink.secunet.mx/api/auth/user-profile") {
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "access_token")!)",
                "Accept": "application/json"
            ]
            
            let parameters: Parameters = [:]
            
            print("headers: \(headers)")
            
            Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).responseJSON { response in
            
                //to get status code
                if let status = response.response?.statusCode {
                    
                    //to get JSON return value
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        print("JSON: \(JSON)")
                    }
                    
                    switch status {
                        case 0:
                            print("Status code: \(status), error al obtener el perfil del usuario")
                            self.hideActivityIndicator()
                            break
                        case 200 :
                            
                            print("Status code: \(status)")
                            
                            do {
                                let res = try JSONDecoder().decode(Structs.User.self, from: response.data!)
                                
                                DispatchQueue.main.async {
                                    self.hideActivityIndicator()
                                    
                                    self.Nombre.text = ""
                                    self.Nombre.text = res.name
                                    self.Telefono.text = ""
                                    self.Telefono.text = res.telefono
                                    self.Email.text = ""
                                    self.Email.text = res.email
                                    
                                    self.FechaNacimiento.setDate(from: res.fecha_nacimiento, format: "yyyy-MM-dd")
                                    
                                    self.Altura.text = res.estatura
                                    self.Peso.text = res.peso
                                    
                                    if res.genero == "hombre" {
                                        self.Genero.selectedSegmentIndex = 0
                                        self.ImagenComplexion.image = UIImage(named: "complexion-h")
                                    } else {
                                        self.Genero.selectedSegmentIndex = 1
                                        self.ImagenComplexion.image = UIImage(named: "complexion-m")
                                    }
                                    
                                    if res.complexion == "hectomorfo" {
                                        self.Complexion.selectedSegmentIndex = 0
                                    } else if res.complexion == "mesomorfo" {
                                        self.Complexion.selectedSegmentIndex = 1
                                    } else if res.complexion == "endomorfo"{
                                        self.Complexion.selectedSegmentIndex = 2
                                    }
                                    
                                    if res.fruta == 1 {
                                        self.Frutas.setOn(true, animated: true)
                                    } else {
                                        self.Frutas.setOn(false, animated: true)
                                    }
                                    
                                    if res.agua == 1 {
                                        self.Agua.setOn(true, animated: true)
                                    } else {
                                        self.Agua.setOn(false, animated: true)
                                    }
                                    
                                    if res.carne_roja == 1 {
                                        self.CarneRoja.setOn(true, animated: true)
                                    } else {
                                        self.CarneRoja.setOn(false, animated: true)
                                    }
                                    
                                    if res.cereales == 1 {
                                        self.Cereales.setOn(true, animated: true)
                                    } else {
                                        self.Cereales.setOn(false, animated: true)
                                    }
                                    
                                    if res.carne_blanca == 1 {
                                        self.CarneBlanca.setOn(true, animated: true)
                                    } else {
                                        self.CarneBlanca.setOn(false, animated: true)
                                    }
                                    
                                    if res.verduras == 1 {
                                        self.Verduras.setOn(true, animated: true)
                                    } else {
                                        self.Verduras.setOn(false, animated: true)
                                    }
                                    
                                    if res.azucares == 1 {
                                        self.Azucares.setOn(true, animated: true)
                                    } else {
                                        self.Azucares.setOn(false, animated: true)
                                    }
                                    
                                    if res.chatarra == 1 {
                                        self.Chatarra.setOn(true, animated: true)
                                    } else {
                                        self.Chatarra.setOn(false, animated: true)
                                    }
                                    
                                    if res.condicion == "pesima" {
                                        self.Condicion.selectedSegmentIndex = 0
                                    } else if res.condicion == "mala" {
                                        self.Condicion.selectedSegmentIndex = 1
                                    }else if res.condicion == "promedio" {
                                        self.Condicion.selectedSegmentIndex = 2
                                    } else if res.condicion == "buena" {
                                        self.Condicion.selectedSegmentIndex = 3
                                    } else if res.condicion == "excelente" {
                                        self.Condicion.selectedSegmentIndex = 4
                                    }
                                    
                                }
                                
                            } catch let error as NSError {
                                print("Error al parsear el JSON de perfil de usuario", error.localizedDescription)
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
                                print("Error al parsear el JSON de perfil de usuario", error.localizedDescription)
                            }
                            
                            break
                    }//switch

                }// if let status
            }//Alamofire
            
        }//if let
    }
    
    /*
     * Actualiza la información del perfil del usuario
     */
    func updateUserProfile () {
        
        self.showActivityIndicator()
        
        struct OkResponse:Codable {
            let message:String
            let user:Structs.User
        }
        
        struct FailResponse:Codable {
            let error:String
        }
        
        //let token = UserDefaults.standard.string(forKey: "token")!
        
        if let url = URL(string: "https://fitink.secunet.mx/api/users/update") {
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "access_token")!)",
                //"Accept": "application/json"
            ]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let parameters: Parameters = [
                "name": Nombre.text!,
                "email": Email.text!,
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
            
            print("headers: \(headers)")
            
            Alamofire.request(url, method: .put, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).responseJSON { response in
            
                //to get status code
                if let status = response.response?.statusCode {
                    
                    switch status {
                        case 0:
                            print("Status code: \(status), error al actualizar usuario")
                            self.hideActivityIndicator()
                            break
                        case 204 :
                            
                            print("Status code: \(status)")
                            
                            do {
                                self.hideActivityIndicator()
                                
                                let alert = UIAlertController(title: "Actualizar Perfil", message: "Actualización exitosa!!", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                self.present(alert, animated: true)
                                
                            } catch let error as NSError {
                                print("Error al recibir respuest de actualizar usuario", error.localizedDescription)
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
                                print("Error al actualizar usuario", error.localizedDescription)
                            }
                            
                            break
                    }//switch

                }// if let status
            }//Alamofire
        }
    }
}

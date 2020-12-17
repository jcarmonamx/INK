//
//  AuthViewController.swift
//  fitink
//
//  Created by Manuel on 16/12/20.
//

import UIKit

import Alamofire

class AuthViewController: UIViewController, UITextFieldDelegate {

    /*
     * MARK: Outlets
     */
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ErrorMessage: UILabel!
    
    
    @IBAction func IniciarSesion(_ sender: Any) {
        self.login()
    }
    
    /*
     * MARK: Funciones del sistema
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardObserver()
    }
    
    /*
     * Se dispara al activar el segue
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LoginToLanding" {
            /*if let destino = segue.destination as? DetalleReporteViewController{
                destino.id = reporteSeleccionado?.id as! Int
            }*/
        }
    }
    
    @IBAction func UnwindToAuth (segue: UIStoryboardSegue) {
        
    }

}

/*
 * MARK: Funciones propias
 */
extension AuthViewController {
    
    //Ocular teclado al presionar la tecla de retorno
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        
        return true
    }
    
}

/*
 * MARK: Peticiones al servidor
 */
extension AuthViewController {
    
    /*
     * Permite al usuario crear un nuevo grupo
     */
    func login () {
        
        self.showActivityIndicator()
        
        struct OkResponse:Codable {
            let access_token:String
            let token_type:String
            let expires_in:Int
            let user:Structs.User
        }
        
        struct FailResponse:Codable {
            let error:String
        }
        
        //let token = UserDefaults.standard.string(forKey: "token")!
        //let descripcion = self.DescripcionGrupo.text!
        
        if let url = URL(string: "https://fitink.secunet.mx/api/auth/login") {
            
            let parameters: Parameters = [
                "email": Email.text!,
                "password": Password.text!
            ]
            
            //peticion get: https://stackoverflow.com/questions/56955595/1103-error-domain-nsurlerrordomain-code-1103-resource-exceeds-maximum-size-i
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
                            print("Status code: \(status), error al recibir la respuesta de login")
                            self.hideActivityIndicator()
                            break
                        case 200 :
                            
                            print("Status code: \(status)")
                            
                            do {
                                let res = try JSONDecoder().decode(OkResponse.self, from: response.data!)
                                
                                DispatchQueue.main.async {
                                    self.hideActivityIndicator()
                                    print("login OK, access_token: \(res.access_token)")
                                    
                                    UserDefaults.standard.set(res.access_token, forKey: "access_token")
                                    
                                    self.performSegue(withIdentifier: "LoginToLanding", sender: self)
                                }
                            } catch let error as NSError {
                                self.hideActivityIndicator()
                                print("Error al parsear el JSON de login", error.localizedDescription)
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
                                print("Error al parsear el JSON de login", error.localizedDescription)
                            }
                            
                            break
                    }//switch

                }// if let status
            }//Alamofire
            
        }//if let
    }
    
}

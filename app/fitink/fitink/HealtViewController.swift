//
//  HealtViewController.swift
//  fitink
//
//  Created by Manuel on 17/12/20.
//

import UIKit

import YoutubePlayer_in_WKWebView
import Alamofire

class HealtViewController: UIViewController {

    /*
     * MARK: Outlets
     */
    @IBOutlet weak var Salud: UILabel!
    @IBOutlet weak var Imc: UILabel!
    @IBOutlet weak var Alimentacion: UILabel!
    @IBOutlet weak var Ejercicio: UILabel!
    
    @IBOutlet weak var player: WKYTPlayerView!
    
    
    /*
     * MARK: Funciones del sistema
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadHealt()
    }
    

}

/*
 * MARK: Peticiones al servidor
 */
extension HealtViewController {
    
    /*
     * Obtiene la información del perfil del usuario
     */
    func loadHealt () {
        
        self.showActivityIndicator()
        
        struct OkResponse:Codable {
            let salud:String
            let peso:String
            let estatura:String
            let video:String
            let alimentacion:String
            let ejercicio:String
        }
        
        struct FailResponse:Codable {
            let error:String
        }
        
        //let token = UserDefaults.standard.string(forKey: "token")!
        
        if let url = URL(string: "https://fitink.secunet.mx/api/users/health") {
            
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
                            print("Status code: \(status), error al obtener la salud del usuario")
                            self.hideActivityIndicator()
                            break
                        case 200 :
                            
                            print("Status code: \(status)")
                            
                            do {
                                let res = try JSONDecoder().decode(OkResponse.self, from: response.data!)
                                
                                DispatchQueue.main.async {
                                    self.hideActivityIndicator()
                                    
                                    let peso = (res.peso as NSString).floatValue
                                    let estatura = (res.estatura as NSString).floatValue / 100
                                    let imc = peso / pow(Float(estatura), 2)
                                    
                                    print("peso: \(peso), estatura: \(estatura), imc: \(imc)")
                                    
                                    var nivel = ""
                                    
                                    if imc < 18.5 {
                                        nivel = "Bajo Peso"
                                    } else if imc >= 18.5 && imc < 25 {
                                        nivel = "Normal"
                                    } else if imc >= 25 && imc < 30 {
                                        nivel = "Sobre Peso"
                                    } else if imc >= 30 {
                                        nivel = "Obeso"
                                    }
                                    
                                    self.Salud.text = res.salud
                                    self.Imc.text = "Su IMC es \(String(format: "%.2f", imc)) lo que indica que su peso esta en la categoria de \(nivel) para personas de su misma estatura"
                                    
                                    self.Alimentacion.text = res.alimentacion
                                    
                                    self.Ejercicio.text = res.ejercicio
                                    
                                    self.player.load(withVideoId: res.video)
                                    
                                }
                                
                            } catch let error as NSError {
                                print("Error al parsear el JSON de salud del usuario", error.localizedDescription)
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
                                print("Error al parsear el JSON de salud del usuario", error.localizedDescription)
                            }
                            
                            break
                    }//switch

                }// if let status
            }//Alamofire
            
        }//if let
    }
    
}

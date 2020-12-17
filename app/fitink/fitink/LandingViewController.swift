//
//  LandingViewController.swift
//  fitink
//
//  Created by Manuel on 16/12/20.
//

import UIKit

class LandingViewController: UIViewController {

    /*
     * MARK: Outless
     */
    @IBAction func MiPerfilAction(_ sender: Any) {
    }
    @IBAction func ConsultarSaludAction(_ sender: Any) {
    }
    /*@IBAction func CerrarSesionAction(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        print("kkkk")
        dismiss(animated: true, completion: nil)
    }*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //oculta el navigation bar al mostrar la vista
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.setToolbarHidden(true, animated: animated)
        
    }
    
    //restaura el navigation bar al salir
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}

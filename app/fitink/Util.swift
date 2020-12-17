//
//  Util.swift
//  fitink
//
//  Created by Manuel on 16/12/20.
//

import UIKit
import Foundation

extension UIViewController {
    
    /*
     * Mostrar teclado al seleccinar TextField
     *
     * Primera forma de arreglar lo del teclado
     * https://es.stackoverflow.com/questions/92914/como-ocultar-teclado-cuando-tocas-fuera-y-dentro-de-un-textfield-cuando-tienenes/#answer-308718
     *
     * Forma actual:
     *     https://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift/#answer-56802182
     */
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardNotifications(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    func removeKeyboardObserver(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    // This method will notify when keyboard appears/ dissapears
    @objc func keyboardNotifications(notification: NSNotification) {

        var accurateY = 0.0  //Using this we will calculate the selected textFields Y Position

        if let activeTextField = UIResponder.currentFirst() as? UITextField {
            // Here we will get accurate frame of which textField is selected if there are multiple textfields
            let frame = self.view.convert(activeTextField.frame, from:activeTextField.superview)
            accurateY = Double(frame.origin.y) + Double(frame.size.height)
        }

        if let userInfo = notification.userInfo {
            // here we will get frame of keyBoard (i.e. x, y, width, height)
            let keyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let keyBoardFrameY = keyBoardFrame!.origin.y

            var newHeight: CGFloat = 0.0
            //Check keyboards Y position and according to that move view up and down
            if keyBoardFrameY >= UIScreen.main.bounds.size.height {
                newHeight = 0.0
            } else {
                if accurateY >= Double(keyBoardFrameY) { // if textfields y is greater than keyboards y then only move View to up
                    if #available(iOS 11.0, *) {
                        newHeight = -CGFloat(accurateY - Double(keyBoardFrameY)) - self.view.safeAreaInsets.bottom
                    } else {
                        newHeight = -CGFloat(accurateY - Double(keyBoardFrameY)) - 5
                    }
                }
            }
        
            //set the Y position of view
            self.view.frame.origin.y = newHeight
        }
    }//keyboardNotifications
}

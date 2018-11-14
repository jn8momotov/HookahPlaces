//
//  LoginController.swift
//  HookahPlaces
//
//  Created by Евгений on 05/11/2018.
//  Copyright © 2018 Momotov. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        addLineToView(view: emailTextField, color: .black, width: 3)
        addLineToView(view: passwordTextField, color: .black, width: 3)
    }
    
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard emailTextField.text != "", passwordTextField.text != "" else {
            showDefaultAlertController(title: "Заполните все поля", message: "Необходимо заполнить все поля", handler: nil)
            return
        }
        let spinnerView = UIViewController.displaySpinner(onView: self.view)
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            UIViewController.removeSpinner(spinner: spinnerView)
            guard error == nil else {
                self.showDefaultAlertController(title: "Ошибка", message: error!.localizedDescription, handler: nil)
                return
            }
            guard result!.user.isEmailVerified else {
                let alertController = UIAlertController(title: "Подтвердите почту", message: "На ваш адрес электронной почты \(result!.user.email!) отправлена ссылка для подтверждения", preferredStyle: .alert)
                alertController.view.tintColor = UIColor.black
                let sendMessage = UIAlertAction(title: "Отправить повторно", style: .default, handler: { (action) in
                    result?.user.sendEmailVerification(completion: { (error) in
                        if error == nil {
                            self.showDefaultAlertController(title: "Подтвердите почту", message: "На ваш адрес электронной почты \(result!.user.email!) отправлена ссылка для подтверждения", handler: nil)
                        }
                        else {
                            self.showDefaultAlertController(title: "Ошибка", message: error!.localizedDescription, handler: nil)
                        }
                    })
                })
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(sendMessage)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            Model.sharedInstance.getUserData(handler: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadTableView"), object: self)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func resetPasswordButtonPressed(_ sender: UIButton) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}

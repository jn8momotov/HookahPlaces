//
//  SignupController.swift
//  HookahPlaces
//
//  Created by Евгений on 05/11/2018.
//  Copyright © 2018 Momotov. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SignupController: UITableViewController {

    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var isPrivacyPolicy: UISwitch!
    @IBOutlet weak var signupButton: UIButton!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
    }
    
    override func viewDidLayoutSubviews() {
        addLineToView(view: nameTextField, color: .black, width: 3)
        addLineToView(view: emailTextField, color: .black, width: 3)
        addLineToView(view: phoneTextField, color: .black, width: 3)
        addLineToView(view: passwordTextField, color: .black, width: 3)
        addLineToView(view: repeatPasswordTextField, color: .black, width: 3)
    }
    
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        guard nameTextField.text != "", emailTextField.text != "", phoneTextField.text != "", passwordTextField.text != "", repeatPasswordTextField.text != "" else {
            showDefaultAlertController(title: "Заполните все поля", message: "Для успешной регистрации должны быть заполнены все поля", handler: nil)
            return
        }
        guard isPrivacyPolicy.isOn else {
            showDefaultAlertController(title: "Политика конфиденциальности", message: "Для успешной регистрации вы должны принять политику конфиденциальности", handler: nil)
            return
        }
        guard passwordTextField.text == repeatPasswordTextField.text else {
            showDefaultAlertController(title: "Пароли не совпадают", message: "Проверьте правильность введенных паролей. Они должны совпадать", handler: nil)
            return
        }
        let spinnerView = UIViewController.displaySpinner(onView: self.view)
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            UIViewController.removeSpinner(spinner: spinnerView)
            if error == nil {
                result?.user.sendEmailVerification(completion: { (error) in
                    if error == nil {
                        self.add(user: result!.user)
                        try? Auth.auth().signOut()
                        self.showDefaultAlertController(title: "Подтвердите почту", message: "На ваш адрес электронной почты \(self.emailTextField.text!) отправленно сообщение с подтверждением", handler: {
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                    else {
                        self.showDefaultAlertController(title: "Ошибка", message: error!.localizedDescription, handler: nil)
                    }
                })
            }
            else {
                self.showDefaultAlertController(title: "Ошибка", message: error!.localizedDescription, handler: nil)
            }
        }
    }
    
    func add(user: User) {
        if let image = self.imageUser.image {
            let storageRef = Storage.storage().reference()
            storageRef.child("users/\(user.uid).png").putData(image.pngData()!)
        }
        let databaseRef = Database.database().reference()
        databaseRef.child("users/\(user.uid)").setValue([
            "name": self.nameTextField.text!,
            "email": self.emailTextField.text!,
            "phone": self.phoneTextField.text!,
            "isPlace": false,
            "countPlace": 0,
            "countAssessment": 0
            ])
    }
    
    let imagePicker = UIImagePickerController()
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alertController.view.tintColor = UIColor.black
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
            let takePhotoAction = UIAlertAction(title: "Сделать фото", style: .default) { (action) in
                self.imagePicker.sourceType = .camera
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            let photoLibraryAction = UIAlertAction(title: "Открыть медиатеку", style: .default) { (alert) in
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(photoLibraryAction)
            alertController.addAction(takePhotoAction)
            if imageUser.image != nil {
                let deleteAction = UIAlertAction(title: "Удалить фото", style: .destructive) { (action) in
                    self.imageUser.image = nil
                }
                alertController.addAction(deleteAction)
            }
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func initViews() {
        imageUser.layer.cornerRadius = imageUser.frame.width / 2
        imageUser.clipsToBounds = true
        signupButton.layer.cornerRadius = 5
        signupButton.clipsToBounds = true
    }
    
}

extension SignupController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageUser.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

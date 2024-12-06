//
//  CreateEventViewController.swift
//  EventGram
//
//  Created by Srikar Nallapu on 11/29/24.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class CreateEventViewController: UIViewController {
    var delegate: EventsViewController!
    let createEventScreen = CreateEventView()
    let imagePicker = UIImagePickerController()
    let db = Firestore.firestore()
    var selectedImage: UIImage?
    
    override func loadView() {
        view = createEventScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagePicker()
        setupDateTimePickers()
        setupActions()
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupImagePicker() {
        imagePicker.delegate = self
        createEventScreen.uploadBannerButton.showsMenuAsPrimaryAction = true
        createEventScreen.uploadBannerButton.menu = getUploadImageMenu()
    }
    
    func getUploadImageMenu() -> UIMenu {
        let menuItems = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "Take Photo",
                    image: UIImage(systemName: "camera"),
                    handler: { [weak self] _ in
                self?.presentImagePicker(source: .camera)
            }),
            UIAction(title: "Choose Photo",
                    image: UIImage(systemName: "photo.on.rectangle"),
                    handler: { [weak self] _ in
                self?.presentImagePicker(source: .photoLibrary)
            })
        ])
        return menuItems
    }
    
    func setupDateTimePickers() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        createEventScreen.startDateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        let startTimePicker = UIDatePicker()
        startTimePicker.datePickerMode = .time
        startTimePicker.preferredDatePickerStyle = .wheels
        createEventScreen.startTimeTextField.inputView = startTimePicker
        startTimePicker.addTarget(self, action: #selector(startTimeChanged(_:)), for: .valueChanged)
        
        let endTimePicker = UIDatePicker()
        endTimePicker.datePickerMode = .time
        endTimePicker.preferredDatePickerStyle = .wheels
        createEventScreen.endTimeTextField.inputView = endTimePicker
        endTimePicker.addTarget(self, action: #selector(endTimeChanged(_:)), for: .valueChanged)
    }
    
    func setupActions() {
        createEventScreen.createEventButton.addTarget(self, action: #selector(createEventButtonTapped), for: .touchUpInside)
    }
    
    func presentImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        createEventScreen.startDateTextField.text = formatter.string(from: sender.date)
    }
    
    @objc func startTimeChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        createEventScreen.startTimeTextField.text = formatter.string(from: sender.date)
    }
    
    @objc func endTimeChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        createEventScreen.endTimeTextField.text = formatter.string(from: sender.date)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension CreateEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.selectedImage = selectedImage
            createEventScreen.uploadImageIcon.image = selectedImage
            createEventScreen.uploadImageIcon.contentMode = .scaleAspectFill
            createEventScreen.uploadInfoLabel.isHidden = true
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - Firebase Operations
extension CreateEventViewController {
    @objc func createEventButtonTapped() {
        guard let title = createEventScreen.eventTitleTextField.text, !title.isEmpty,
              let description = createEventScreen.eventDescriptionTextView.text, !description.isEmpty,
              let address = createEventScreen.addressTextField.text, !address.isEmpty,
              let startTime = createEventScreen.startTimeTextField.text, !startTime.isEmpty,
              let endTime = createEventScreen.endTimeTextField.text, !endTime.isEmpty,
              let startDate = createEventScreen.startDateTextField.text, !startDate.isEmpty else {
            showAlert(title: "Missing Fields", message: "Please fill in all required fields marked with *")
            return
        }
        
        if let image = selectedImage {
            uploadImage(image) { [weak self] imageUrl in
                self?.saveEvent(title: title, description: description,
                              address: address, startTime: startTime,
                              endTime: endTime, startDate: startDate,
                              imageUrl: imageUrl)
            }
        } else {
            saveEvent(title: title, description: description,
                     address: address, startTime: startTime,
                     endTime: endTime, startDate: startDate,
                     imageUrl: nil)
        }
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        
        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("event_images/\(UUID().uuidString).jpg")
        
        imageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading image: \(error)")
                completion(nil)
                return
            }
            
            imageRef.downloadURL { url, error in
                completion(url?.absoluteString)
            }
        }
    }
    
    func saveEvent(title: String, description: String, address: String,
                  startTime: String, endTime: String, startDate: String,
                  imageUrl: String?) {
        var event: [String: Any] = [
            "title": title,
            "description": description,
            "address": address,
            "startTime": startTime,
            "endTime": endTime,
            "startDate": startDate,
            "timestamp": Timestamp(date: Date())
        ]
        
        if let imageUrl = imageUrl {
            event["imageUrl"] = imageUrl
        }
        
        db.collection("events").addDocument(data: event) { [weak self] error in
            if let error = error {
                self?.showAlert(title: "Error", message: "Failed to create event: \(error.localizedDescription)")
            } else {
                self?.showAlert(title: "Success", message: "Event created successfully!")
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

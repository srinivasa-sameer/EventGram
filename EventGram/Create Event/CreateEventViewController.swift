//
//  CreateEventViewController.swift
//  EventGram
//
//  Created by Srikar Nallapu on 11/29/24.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

class CreateEventViewController: UIViewController {
    var delegate: EventsViewController!
    let createEventScreen = CreateEventView()
    let imagePicker = UIImagePickerController()
    let db = Firestore.firestore()
    var selectedImage: UIImage?

    let childProgressView = ProgressSpinnerViewController()

    override func loadView() {
        view = createEventScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagePicker()
        setupDateTimePickers()
        setupActions()

        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(
            target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    func setupImagePicker() {
        imagePicker.delegate = self
        createEventScreen.uploadBannerButton.showsMenuAsPrimaryAction = true
        createEventScreen.uploadBannerButton.menu = getUploadImageMenu()
    }

    func getUploadImageMenu() -> UIMenu {
        let menuItems = UIMenu(
            title: "", options: .displayInline,
            children: [
                UIAction(
                    title: "Take Photo",
                    image: UIImage(systemName: "camera"),
                    handler: { [weak self] _ in
                        self?.presentImagePicker(source: .camera)
                    }),
                UIAction(
                    title: "Choose Photo",
                    image: UIImage(systemName: "photo.on.rectangle"),
                    handler: { [weak self] _ in
                        self?.presentImagePicker(source: .photoLibrary)
                    }),
            ])
        return menuItems
    }

    func setupDateTimePickers() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        createEventScreen.dateTextField.inputView = datePicker
        datePicker.addTarget(
            self, action: #selector(dateChanged(_:)), for: .valueChanged)

        let startTimePicker = UIDatePicker()
        startTimePicker.datePickerMode = .time
        startTimePicker.preferredDatePickerStyle = .wheels
        createEventScreen.startTimeTextField.inputView = startTimePicker
        startTimePicker.addTarget(
            self, action: #selector(startTimeChanged(_:)), for: .valueChanged)

        let endTimePicker = UIDatePicker()
        endTimePicker.datePickerMode = .time
        endTimePicker.preferredDatePickerStyle = .wheels
        createEventScreen.endTimeTextField.inputView = endTimePicker
        endTimePicker.addTarget(
            self, action: #selector(endTimeChanged(_:)), for: .valueChanged)
    }

    func setupActions() {
        createEventScreen.createEventButton.addTarget(
            self, action: #selector(createEventButtonTapped),
            for: .touchUpInside)
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
        createEventScreen.dateTextField.text = formatter.string(
            from: sender.date)
    }

    @objc func startTimeChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        createEventScreen.startTimeTextField.text = formatter.string(
            from: sender.date)
    }

    @objc func endTimeChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        createEventScreen.endTimeTextField.text = formatter.string(
            from: sender.date)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension CreateEventViewController: UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey:
            Any]
    ) {
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
        guard let user = Auth.auth().currentUser else { return }
        let userId = user.uid
        guard let title = createEventScreen.eventTitleTextField.text,
            !title.isEmpty,
            let description = createEventScreen.eventDescriptionField.text,
            !description.isEmpty,
            let address = createEventScreen.addressTextField.text,
            !address.isEmpty,
            let startTime = createEventScreen.startTimeTextField.text,
            !startTime.isEmpty,
            let endTime = createEventScreen.endTimeTextField.text,
            !endTime.isEmpty,
            let startDate = createEventScreen.dateTextField.text,
            !startDate.isEmpty
        else {
            showAlert(
                title: "Missing Fields",
                message: "Please fill in all required fields marked with *")
            return
        }

        if let image = selectedImage {
            uploadImage(image) { [weak self] imageUrl in
                self?.saveEvent(
                    title: title, description: description,
                    address: address, startTime: startTime,
                    endTime: endTime, startDate: startDate,
                    imageUrl: imageUrl, userId: userId)
            }
        } else {
            saveEvent(
                title: title, description: description,
                address: address, startTime: startTime,
                endTime: endTime, startDate: startDate,
                imageUrl: nil, userId: userId)
        }
    }

    func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void)
    {
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

    func convertDateString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }

        return date
    }

    func saveEvent(
        title: String, description: String, address: String,
        startTime: String, endTime: String, startDate: String,
        imageUrl: String?, userId: String
    ) {

        let eventId = UUID().uuidString
        showActivityIndicator()

        guard let convertedDate = convertDateString(startDate) else {
            showAlert(title: "Error", message: "Invalid date format")
            return
        }

        var event: [String: Any] = [
            "eventId": eventId,
            "title": title,
            "description": description,
            "location": address,
            "startTime": startTime,
            "endTime": endTime,
            "date": convertedDate,
            "userId": userId,
            "timestamp": Timestamp(date: Date()),
        ]

        if let imageUrl = imageUrl {
            event["imageUrl"] = imageUrl
        }

        db.collection("events").addDocument(data: event) { [weak self] error in
            if let error = error {
                self?.hideActivityIndicator()
                self?.showAlert(
                    title: "Error",
                    message:
                        "Failed to create event: \(error.localizedDescription)")
            } else {
                self?.hideActivityIndicator()
                let alert = UIAlertController(
                    title: "Success",
                    message: "Event created successfully!",
                    preferredStyle: .alert
                )

                alert.addAction(
                    UIAlertAction(title: "OK", style: .default) { _ in
                        // Navigate to profile screen after alert is dismissed
                        let profileViewController = ProfileViewController()
                        self?.navigationController?.pushViewController(
                            profileViewController, animated: true)
                        self?.tabBarController?.selectedIndex = 2
                    })
                self?.present(alert, animated: true)

                self?.createEventScreen.eventTitleTextField.text = ""
                self?.createEventScreen.eventDescriptionField.text = ""
                self?.createEventScreen.addressTextField.text = ""
                self?.createEventScreen.startTimeTextField.text = ""
                self?.createEventScreen.endTimeTextField.text = ""
                self?.createEventScreen.dateTextField.text = ""
                self?.selectedImage = nil
            }
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension CreateEventViewController: ProgressSpinnerDelegate {
    func showActivityIndicator() {
        addChild(childProgressView)
        view.addSubview(childProgressView.view)
        childProgressView.didMove(toParent: self)
    }

    func hideActivityIndicator() {
        childProgressView.willMove(toParent: nil)
        childProgressView.view.removeFromSuperview()
        childProgressView.removeFromParent()
    }
}

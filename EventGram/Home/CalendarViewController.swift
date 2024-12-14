//
//  CalendarViewController.swift
//  EventGram
//
//  Created by Srinivasa Sameer Addepalli on 12/11/24.
//

import EventKit
import FirebaseFirestore
import UIKit

class CalendarViewController: UIViewController,
    UICalendarSelectionSingleDateDelegate
{
    let calendarView = UICalendarView()
    let eventStore = EKEventStore()
    var events: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        fetchEvents()
    }

    func setupCalendarView() {
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendarView)

        let decoration = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = decoration

        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func fetchEvents() {
        let db = Firestore.firestore()
        db.collection("events").getDocuments { [weak self] snapshot, error in
            if let documents = snapshot?.documents {
                self?.events = documents.compactMap {
                    Event(dictionary: $0.data())
                }
                self?.highlightEventDates()
            }
        }
    }

    func dateSelection(
        _ selection: UICalendarSelectionSingleDate,
        didSelectDate dateComponents: DateComponents?
    ) {
        guard let dateComponents = dateComponents,
            let selectedDate = Calendar.current.date(from: dateComponents)
        else { return }

        // Filter and show events for selected date
        let eventsOnDate = events.filter { event in
            Calendar.current.isDate(event.date, inSameDayAs: selectedDate)
        }

        if !eventsOnDate.isEmpty {
            // Show events in alert or separate view
            let eventTitles = eventsOnDate.map { $0.title }.joined(
                separator: "\n")
            showAlert(message: "Events on this date:\n\(eventTitles)")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(
            title: "List of Events",
            message: message,
            preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func highlightEventDates() {
        let eventDates = events.map { $0.date }
        // Highlight dates with decoration
        calendarView.reloadDecorations(
            forDateComponents: eventDates.map {
                Calendar.current.dateComponents(
                    [.day, .month, .year], from: $0)
            }, animated: true)
    }
}

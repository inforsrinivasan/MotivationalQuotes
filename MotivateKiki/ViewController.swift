//
//  ViewController.swift
//  MotivateKiki
//
//  Created by Srinivasan Rajendran on 2020-03-29.
//  Copyright © 2020 Srinivasan Rajendran. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var quoteImageView: UIImageView!

    let quotes = Bundle.main.decode([Quote].self, from: "quotes.json")
    let images = Bundle.main.decode([String].self, from: "pictures.json")

    var shareQuote: Quote?

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) { allowed, error in
            if allowed {
                self.configureAlerts()
            }
        }
    }

    func updateQuote() {
        guard let backgroundImageName = images.randomElement() else{
            fatalError("Unable to read an image")
        }

        backgroundImageView.image = UIImage(named: backgroundImageName)

        guard let selectedQuote = quotes.randomElement() else {
            fatalError("Unable to read a quote")
        }
        shareQuote = selectedQuote
        quoteImageView.image = renderQuote(selectedQuote: selectedQuote)
    }

    func renderQuote(selectedQuote: Quote) -> UIImage {
        let insetAmount = CGFloat(integerLiteral: 250)
        let drawBounds = quoteImageView.bounds.inset(by: UIEdgeInsets(top: insetAmount, left: insetAmount, bottom: insetAmount, right: insetAmount))
        var quoteRect = CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        var fontSize: CGFloat = 120
        var font: UIFont!

        var attrs: [NSAttributedString.Key: Any]!
        var str: NSAttributedString!

        while true {
            font = UIFont(name: "Georgia-Italic", size: fontSize)! //?? UIFont.systemFont(ofSize: fontSize)
            attrs = [NSAttributedString.Key.font: font!, .foregroundColor: UIColor.white]

            str = NSAttributedString(string: selectedQuote.text, attributes: attrs)
            quoteRect = str.boundingRect(with: CGSize(width: drawBounds.width, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)

            if quoteRect.height > drawBounds.height {
                fontSize -= 4
            } else {
                break
            }
        }

        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(bounds: quoteRect.insetBy(dx: -30, dy: -30), format: format)
        return renderer.image(actions: { ctx in
            for i in 1...5 {
                ctx.cgContext.setShadow(offset: .zero, blur: CGFloat(i) * 2, color: UIColor.black.cgColor)
                str.draw(in: quoteRect)
            }
        })
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateQuote()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateQuote()
    }

    func configureAlerts() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()

        let shuffled = quotes.shuffled()
        for i in 1...7 {
            let content = UNMutableNotificationContent()
            content.title = "Kiki Motivation"
            content.body = shuffled[i].text

            let alertDate = Date().byAdding(days: i)
            var alertComponents = Calendar.current.dateComponents([.day,.month,.year], from: alertDate)
            alertComponents.hour = 10
            //let trigger = UNCalendarNotificationTrigger(dateMatching: alertComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(i) * 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request) { error in
                if let error = error {
                    print("error \(error)")
                }
            }
        }
    }
}


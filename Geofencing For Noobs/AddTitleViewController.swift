//
//  AddTitleViewController.swift
//  Geofencing For Noobs
//
//  Created by Jesse Joseph on 19/09/19.
//  Copyright © 2019 Hilton Pintor Bezerra Leite. All rights reserved.
//

import UIKit

class AddTitleViewController: UIViewController {
    
    @IBOutlet weak var addTitleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        self.addTitleTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveTitle(_ sender: Any) {
        let defaults = UserDefaults.standard
        var nameRecordingArray = defaults.object(forKey:"nameArray") as? [String] ?? [String]()
        
        let recordingName = addTitleTextField.text ?? "Recording \(getDate())"
        print(recordingName)
        
        nameRecordingArray.append(recordingName)
        defaults.set(nameRecordingArray, forKey: "nameArray")
        
        performSegue(withIdentifier: "backToHome", sender: self)
    }
    
    func getDate()->String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd "
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let segueToAllRecord = segue.destination as? ViewController
        
        // Function to append to AllRecordViewController
        let recordingName = addTitleTextField.text ?? "Recording \(getDate())"
        
        segueToAllRecord?.addRecord(name: recordingName)
        print("success")
        segueToAllRecord?.reflectionTableView.reloadData()
        
        print("Title Added")
    }
    
}


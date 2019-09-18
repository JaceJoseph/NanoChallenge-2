//
//  OpenReflectionViewController.swift
//  Geofencing For Noobs
//
//  Created by Jesse Joseph on 17/09/19.
//  Copyright © 2019 Hilton Pintor Bezerra Leite. All rights reserved.
//

import UIKit
import AVFoundation

class OpenReflectionViewController: UIViewController {
    
    @IBOutlet weak var playbackButton: UIButton!
    
    var numberOfRecordingThatWillBeOpened: Int = 0
    var isPlaying:Bool = false
    
    var audioPlayer: AVAudioPlayer!
    var audioSession = AVAudioSession.sharedInstance()

    override func viewDidLoad() {
        loadAudio()
        print("File recording\(numberOfRecordingThatWillBeOpened).m4a opened !!")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func loadAudio(){
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(numberOfRecordingThatWillBeOpened).m4a")
        do {
//            audioSession = AVAudioSession.sharedInstance()
//            try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
               try audioPlayer = AVAudioPlayer(contentsOf: audioFilename)
        } catch {
            print("Cannot Load")
        }
    }
    
//    func configureAudioSessionToSpeaker(){
//        do {
//            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
//            try audioSession.setActive(true)
//            print("Successfully configured audio session (SPEAKER-Bottom).", "\nCurrent audio route: ",audioSession.currentRoute.outputs)
//        } catch let error as NSError {
//            print("#configureAudioSessionToSpeaker Error \(error.localizedDescription)")
//        }
//    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @IBAction func playbackRecordingButtonIsTapped(_ sender: Any) {
        
        if isPlaying == false {
            // GANTI GAMBAR BUTTON DI BAGIAN INI
            audioPlayer.play()
            isPlaying = true
            playbackButton.setTitle("Stop", for: .normal)
        } else {
            // GANTI GAMBAR BUTTON DI BAGIAN INI
            audioPlayer.stop()
            isPlaying = false
            playbackButton.setTitle("Playback", for: .normal)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

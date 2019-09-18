//
//  TestRecordViewController.swift
//  Geofencing For Noobs
//
//  Created by Jesse Joseph on 18/09/19.
//  Copyright © 2019 Hilton Pintor Bezerra Leite. All rights reserved.
//

import UIKit
import AVFoundation

class TestRecordViewController: UIViewController,AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var audioPlayer : AVAudioPlayer?
    var audioRecorder : AVAudioRecorder?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // enabling ....
        playButton.isEnabled = false
        stopButton.isEnabled = false
        
        // getting URL path for audio
        let dirPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDir = dirPath[0]
        let soundFilePath = docDir.appendingPathComponent("sound.caf")
        let soundFileURL = soundFilePath
        print(soundFilePath)
        
        //Setting for recorder
        //        let recordSettings = [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
        //            AVEncoderBitRateKey: 16,
        //            AVNumberOfChannelsKey : 2,
        //            AVSampleRateKey: 44100.0]
        
        let settings = [AVFormatIDKey : Int(kAudioFormatMPEG4AAC), ///
            AVSampleRateKey :  44100, ///
            AVNumberOfChannelsKey : 1, ///
            AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue]
        
        var error : NSError?
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(.playAndRecord)
        
        if let err = error{
            print("audioSession error: \(err.localizedDescription)")
        }
        do {
            audioRecorder = try AVAudioRecorder(url: soundFileURL, settings: settings)
        } catch {
            
        }
        
        if let err = error{
            print("audioSession error: \(err.localizedDescription)")
        }else{
            audioRecorder?.prepareToRecord()
        }
    }
    
    @IBAction func recordAudio(sender: AnyObject) {
        
        if audioRecorder?.isRecording == false{
            playButton.isEnabled = false
            stopButton.isEnabled = true
            audioRecorder?.record()
        }
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        
        stopButton.isEnabled = false
        playButton.isEnabled = true
        recordButton.isEnabled = true
        
        if audioRecorder?.isRecording == true{
            audioRecorder?.stop()
        }else{
            audioPlayer?.stop()
        }
    }
    
    @IBAction func playAudio(sender: AnyObject) {
        
        if audioRecorder?.isRecording == false{
            stopButton.isEnabled = true
            recordButton.isEnabled = false
            
            var error : NSError?
            
            //            audioPlayer = AVAudioPlayer(contentsOfURL: audioRecorder?.url, error: &error)
            
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: audioRecorder!.url)
                
                audioPlayer?.delegate = self
            }catch {
                print("error")
            }
            
            
            
            
            if let err = error{
                print("audioPlayer error: \(err.localizedDescription)")
            }else{
                audioPlayer?.play()
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
        stopButton.isEnabled = false
    }
    
    private func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        print("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder , successfully flag: Bool) {
    }
    
    private func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder , error: NSError!) {
        print("Audio Record Encode Error")
    }
    
}

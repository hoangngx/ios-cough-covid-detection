//
//  HomeViewController.swift
//  CustomLoginDemo
//
//  Created by Christopher Ching on 2019-07-22.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let s = self as NSString
        return s.appendingPathComponent(path)
    }
}

class HomeViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var importButton: UIButton!
    @IBOutlet weak var textView2: UITextView!
    
    private var audioRecorder: AVAudioRecorder!
    private var _recorderFilePath: String!
    
    private let AUDIO_LEN_IN_SECOND = 5
    private let SAMPLE_RATE = 16000
    
    private lazy var module: InferenceModule = {
        if let filePath = Bundle.main.path(forResource:
            "weights", ofType: "ptl"),
            let module = InferenceModule(fileAtPath: filePath) {
            return module
        } else {
            fatalError("Can't find the model file!")
        }
    }()
    
    @IBAction func startTapped(_ sender: Any) {
        
        AVAudioSession.sharedInstance().requestRecordPermission ({(granted: Bool)-> Void in
            if granted {
                self.startButton.setTitle("Listening...", for: .normal)
            } else{
                self.textView.text = "Record premission needs to be granted"
            }
         })
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setActive(true)
        } catch {
            textView.text = "recording exception"
            return
        }

        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: SAMPLE_RATE,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ] as [String : Any]
        
        do {
            _recorderFilePath = NSHomeDirectory().stringByAppendingPathComponent(path: "tmp").stringByAppendingPathComponent(path: "recorded_file.wav")
            audioRecorder = try AVAudioRecorder(url: NSURL.fileURL(withPath: _recorderFilePath), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record(forDuration: TimeInterval(AUDIO_LEN_IN_SECOND))
            
        } catch let error {
            textView.text = "error:" + error.localizedDescription
        }
        
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        startButton.setTitle("Recognizing...", for: .normal)
        
        if flag {
            let url = NSURL.fileURL(withPath: _recorderFilePath)
            let file = try! AVAudioFile(forReading: url)
            let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: 1, interleaved: false)

            let buf = AVAudioPCMBuffer(pcmFormat: format!, frameCapacity: AVAudioFrameCount(file.length))
            try! file.read(into: buf!)

            var floatArray = Array(UnsafeBufferPointer(start: buf?.floatChannelData![0], count:Int(buf!.frameLength)))

            DispatchQueue.global().async {
                floatArray.withUnsafeMutableBytes {
                    let result = self.module.recognize($0.baseAddress!, bufLength: Int32(self.AUDIO_LEN_IN_SECOND * self.SAMPLE_RATE))
                    DispatchQueue.main.async {
                        self.textView.text = result
                        self.startButton.setTitle("Start", for: .normal)
                    }
                }
            }
        }
        else {
            textView.text = "Recording error"
        }
    }
 
    
    @IBAction func importTapped(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.mpeg4Audio, .mp3])
        //documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .overFullScreen
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        dismiss(animated: true)

        guard url.startAccessingSecurityScopedResource() else {
            return
        }

        // Copy the file with FileManager
    }

}

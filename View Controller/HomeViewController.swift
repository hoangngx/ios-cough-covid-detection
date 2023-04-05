//
//  HomeViewController.swift
//  CustomLoginDemo
//
//  Created by Christopher Ching on 2019-07-22.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Charts
import UIKit
import AVFoundation
import MobileCoreServices
import UniformTypeIdentifiers

extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let s = self as NSString
        return s.appendingPathComponent(path)
    }
}

class HomeViewController: UIViewController, AVAudioRecorderDelegate, UIDocumentPickerDelegate {

    @IBOutlet weak var pieChart: PieChartView!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var importButton: UIButton!
    
    private var audioRecorder: AVAudioRecorder!
    private var _recorderFilePath: String!
    
    private let AUDIO_LEN_IN_SECOND = 5
    private let SAMPLE_RATE = 16000
    
    
    let labels = ["Positive", "Negative"]
    var goals = ["0", "1"]
    
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
                    DispatchQueue.main.async { [self] in
                        self.textView.text = result
                        
                        // Re-draw pie charts
                        self.goals[0] = result!
                        self.goals[1] = "\(1 - (Double(result!) ?? 0))"
                        self.startButton.setTitle("Start", for: .normal)
                        self.customizeChart(dataPoints: self.labels, values: self.goals.map{ Double($0)! })
                    }
                }
            }
        }
        else {
            textView.text = "Recording error"
        }
    }
 
    // UPLOAD AUDIO FILE

//    let cough_test_file = "HNQDTLX-coughing.mp3"
//    let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//    let fileURL = dir.appendingPathComponent(cough_test_file)
    
    
    @IBAction func importTapped(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.mp3, .pdf])

        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .overFullScreen
        documentPicker.allowsMultipleSelection = true
        present(documentPicker, animated: true)
    }
    
    internal func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        dismiss(animated: true)

        guard url.startAccessingSecurityScopedResource() else {
            return
        }

        do {
            url.stopAccessingSecurityScopedResource()
        }

        // Copy the file with FileManager
    }

    
    // DRAW CHARTS
    override func viewDidLoad() {
      super.viewDidLoad()
      customizeChart(dataPoints: labels, values: goals.map{ Double($0)! })
    }
    
    func customizeChart(dataPoints: [String], values: [Double]) {
      
      // 1. Set ChartDataEntry
      var dataEntries: [ChartDataEntry] = []
      for i in 0..<dataPoints.count {
        let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
        dataEntries.append(dataEntry)
      }
      // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
      pieChartDataSet.colors = colorsOfCharts()
      // 3. Set ChartData
      let pieChartData = PieChartData(dataSet: pieChartDataSet)
      let format = NumberFormatter()
      format.numberStyle = .none
      let formatter = DefaultValueFormatter(formatter: format)
      pieChartData.setValueFormatter(formatter)
      // 4. Assign it to the chart’s data
      pieChart.data = pieChartData
    }
    
    private func colorsOfCharts() -> [UIColor] {
      var colors: [UIColor] = []
        let positive_color = UIColor(red: CGFloat(0.86), green: CGFloat(0.08), blue: CGFloat(0.23), alpha: 1)
        let negative_color = UIColor(red: CGFloat(0.48), green: CGFloat(0.41), blue: CGFloat(0.9), alpha: 1)
      colors.append(positive_color)
      colors.append(negative_color)
      return colors
    }
}


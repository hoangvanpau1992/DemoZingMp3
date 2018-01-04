//
//  DetailViewController.swift
//  DemoZingMp3
//
//  Created by public on 12/27/17.
//  Copyright © 2017 public. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class DetailViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var repeatSwh: UISwitch!
    @IBOutlet weak var volumeSld: UISlider!
    
    @IBOutlet weak var timeSld: UISlider!
    @IBOutlet weak var totalTimeLbl: UILabel!
    @IBOutlet weak var recentTimeLbl: UILabel!
    
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    var playorpause: Bool!
    
    var song: Song?
    var urlSong = ""
    
    var timer = Timer()
    
    var audio = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let song = song {
            songNameLabel.text = song.name
        }
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: song?.name, ofType: "mp3")!)
        let playImg = UIImage(named: "play.png")
        audio = try! AVAudioPlayer(contentsOf: url)
        playButton.setImage(playImg, for: UIControlState())
        playorpause = false
        addThumbImgForSlider()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeRecent), userInfo: nil, repeats: true)
        let totalTimeMins = Int(audio.duration / 60)
        let totalTimeSeconds = Int((audio.duration - Double(totalTimeMins * 60)))
        totalTimeLbl.text = String(format: "%d:%d", totalTimeMins, totalTimeSeconds)
        timeSld.setThumbImage(UIImage(named: "duration.png"), for: UIControlState())
        timeSld.value = timeSld.minimumValue
        audio.delegate = self
        audio.play()
        playorpause = true
        playButton.setImage(UIImage(named: "pause.png"), for: UIControlState())
    }
    
    func addThumbImgForSlider() {
        volumeSld.setThumbImage(UIImage(named: "thumb.png"), for: UIControlState())
        volumeSld.setThumbImage(UIImage(named: "thumbHightLight.png"), for: .highlighted)
    }
    
    @objc func timeRecent() {
        let recentTimeMins = Int(audio.currentTime / 60)
        let recentTimeSeconds = Int((audio.currentTime - Double(recentTimeMins * 60)))
        recentTimeLbl.text = String(format: "%d:%d", recentTimeMins, recentTimeSeconds)
        
        timeSld.value = Float(audio.currentTime / audio.duration) * timeSld.maximumValue
        
    }

    @IBAction func playButtonAC(_ sender: UIButton) {
        if playorpause == false {
            audio.play()
            playorpause = true
            playButton.setImage(UIImage(named: "pause.png"), for: UIControlState())
        } else {
            audio.pause()
            playorpause = false
            playButton.setImage(UIImage(named: "play.png"), for: UIControlState())
        }
    }
    
    @IBAction func `switch`(_ sender: UISwitch) {
        if sender.isOn {
            audio.numberOfLoops = -1
        } else {
            audio.numberOfLoops = 0
        }
    }
    
    @IBAction func siderVoulme(_ sender: UISlider) {
        audio.volume = sender.value
    }
    
    @IBAction func sliderTime(_ sender: UISlider) {
        audio.currentTime = Double(sender.value / sender.maximumValue) * audio.duration
    }
    
    @IBAction func actionSheetButton(_ sender: UIBarButtonItem) {
        let playList = UIAlertController(title: nil, message: "Play List", preferredStyle: .actionSheet)
        
        let newPlayListAction = UIAlertAction(title: "New Play List", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            let addPlayList = UIAlertController(title: "Add PlayList", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {(alartAction: UIAlertAction) -> Void in
                guard let textField = addPlayList.textFields?.first?.text else {return}
                Database.shared.insertToObjectCoreDataPlaylist(namePlaylist: textField)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let playlistTableview = storyboard.instantiateViewController(withIdentifier: "NaviViewController") as! NaviViewController
                self.present(playlistTableview, animated: true, completion: nil)
                
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            addPlayList.addAction(okAction)
            addPlayList.addAction(cancelAction)
            addPlayList.addTextField(configurationHandler: {(textField: UITextField) -> Void in
                textField.placeholder = "Enter Name"
            })
            self.present(addPlayList, animated: true, completion: nil)
//            print("Hoang")
        })
        
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
        })
        playList.addAction(newPlayListAction)
        playList.addAction(deleteAction)
        playList.addAction(cancelAction)
        self.present(playList, animated: true, completion: nil)
    }
    
    @IBAction func backListSongs(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if repeatSwh.isOn == false {
            playorpause = false
            playButton.setImage(UIImage(named: "play.png"), for: UIControlState())
        }
    }
}





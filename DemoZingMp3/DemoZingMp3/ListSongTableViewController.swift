//
//  ListSongTableViewController.swift
//  DemoZingMp3
//
//  Created by public on 12/27/17.
//  Copyright © 2017 public. All rights reserved.
//

import UIKit

class ListSongTableViewController: UIViewController {
    
    
    
    // Mark: Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seachController: UIView!
    
    // Mark: Property
    
    private var songs: [Song] = []
    private let searchControllerView = UISearchController(searchResultsController: nil)
    fileprivate var resultsSearchContacts: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//       dummyData()
        setUpSearchControler()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataFromcoreData()
    }
    
    func setUpSearchControler() {
        searchControllerView.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        seachController.addSubview(searchControllerView.searchBar)
    }
    
    func isfiltering() -> Bool {
        return searchControllerView.isActive && !searchBarIsEmpty()
    }

    func searchBarIsEmpty() -> Bool {
        return searchControllerView.searchBar.text?.isEmpty ?? true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        guard let detailViewController = segue.destination as? DetailViewController else {return}
        
        guard let selectedSongCell = sender as? TableViewCell else {return}
        
        guard let indexPath = tableView.indexPath(for: selectedSongCell) else {return}
        
        let selectedSong = songs[indexPath.row]
        detailViewController.song = selectedSong
    }
    func dummyData() {
        Database.shared.insertToObjectCoreData(name: "Nơi này có anh-Sơn Tùng")
        Database.shared.insertToObjectCoreData(name: "Bien-Yanbi-T-Akayz")
        Database.shared.insertToObjectCoreData(name: "Yeu5-Rhymastic-4756973")
        Database.shared.insertToObjectCoreData(name: "MuaDongKhongLanh-AkiraPhan_ax")
        Database.shared.insertToObjectCoreData(name: "NguoiYeuKhoc-KelvinKhanhNguyenHoangTuan-4307136")
        Database.shared.insertToObjectCoreData(name: "EmYeu-UngHoangPhuc-2440895")
        Database.shared.insertToObjectCoreData(name: "AnhYeuEm-KhacViet-4813805")
       
    }
    
    func fetchDataFromcoreData() {
        let managedObjectContext = Database.shared.getContext()
        songs = try! managedObjectContext.fetch(Song.fetchRequest()) as! [Song]
        
        tableView.reloadData()
    }
    
}

extension ListSongTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.nameSongLabel.text = songs[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}





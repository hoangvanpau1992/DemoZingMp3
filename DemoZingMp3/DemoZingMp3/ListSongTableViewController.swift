//
//  ListSongTableViewController.swift
//  DemoZingMp3
//
//  Created by public on 12/27/17.
//  Copyright © 2017 public. All rights reserved.
//

import UIKit
import CoreData

class ListSongTableViewController: UIViewController {
    
    
    
    // Mark: Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var seachController: UIView!
    
    // Mark: Property
    
    private var songs: [Song] = []
    private let searchControllerView = UISearchController(searchResultsController: nil)
    fileprivate var resultsSearchSongs: [Song] = []
    
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
        searchControllerView.searchResultsUpdater = self
    }
    
    func isfiltering() -> Bool {
        return searchControllerView.isActive && !searchBarIsEmpty()
    }

    func searchBarIsEmpty() -> Bool {
        return searchControllerView.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        let managedObjectContext = Database.shared.getContext()
        let fetchRequest: NSFetchRequest<Song> = Song.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name contains[c] %@", searchText)
        resultsSearchSongs = try! managedObjectContext.fetch(fetchRequest)
        
        tableView.reloadData()
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

extension ListSongTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isfiltering() {
           return resultsSearchSongs.count
        } else {
            return songs.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        if isfiltering() {
        cell.nameSongLabel.text = resultsSearchSongs[indexPath.row].name
        } else {
        cell.nameSongLabel.text = songs[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ListSongTableViewController: UISearchResultsUpdating {
    
    // Search Controller Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}





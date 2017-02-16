//
//  EditRecordsViewController.swift
//  Monthey
//
//  Created by 钟信 on 2017/1/24.
//  Copyright © 2017年 zhongxin. All rights reserved.
//

import UIKit

class EditRecordsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //ui
    @IBOutlet weak var recordsTableView: UITableView!
    
    //let
    private let insetHeight:CGFloat = 88
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordsTableView.contentInset.bottom = insetHeight
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath)
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

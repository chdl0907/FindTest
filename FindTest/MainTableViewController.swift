//
//  MainTableViewController.swift
//  FindTest
//
//  Created by ktds 22 on 2017. 8. 31..
//  Copyright © 2017년 OliveNetworks, Inc. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    var arts:[Art]=Array()
    let maxQty=10
    let keyStr="565856534d63686437396276476855" // 인증키
    var lastPageNum=0
    
    @IBAction func getMoreData(_ sender: Any) {
        self.getData(pageNum: self.lastPageNum+1)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.getData(pageNum: 0)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text=arts[indexPath.row].title
        cell.detailTextLabel?.text=arts[indexPath.row].artist
        //cell.imageView?.image=self.getThumbImage(withURL: arts[indexPath.row].thumbImageURL!)
        
        
        if let thumbImage=arts[indexPath.row].thumbImage{
            cell.imageView?.image=thumbImage
        
        }else{//이미지가 한번도 로드되지 않은 경우
            if let thumbImageURL=arts[indexPath.row].thumbImageURL{
                // global -> Main thread와 다른 공간에 있는 thread를 할당(즉시실행해야하는 케이스에 쓴다. 실행우선순위를 높여서)
                DispatchQueue.global(qos : .userInitiated).async(execute: {
                    self.arts[indexPath.row].thumbImage=self.getThumbImage(withURL: thumbImageURL)
                    
                    guard let thumbImage=self.arts[indexPath.row].thumbImage else {
                        return
                    }
                    DispatchQueue.main.async {
                        cell.imageView?.image = thumbImage
                    }
                    
                })
                
                
            }
        }
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getData(pageNum:Int){
        let startIdx = pageNum * maxQty
        let endIdx = startIdx + maxQty - 1
        
        // 참조할 데이터 string
        let urlStr="http://openapi.seoul.go.kr:8088/\(keyStr)/json/SemaPsgudInfoEng/\(startIdx)/\(endIdx)/"
        
        let serverURL:URL! = URL(string: urlStr)
        let serverData = try! Data(contentsOf: serverURL)
        
        // serverdata를 string type으로 변경(데이터를 잘 받아오는지 log단에서 확인하기위함)
        let log=NSString(data: serverData, encoding: String.Encoding.utf8.rawValue)
        print(log)
        
        
        // 오류가 발생한 경우
        do{
            let dict=try JSONSerialization.jsonObject(with: serverData, options: []) as! NSDictionary
            let semaPsgudInfo=dict["SemaPsgudInfoEng"] as! NSDictionary
            let results=semaPsgudInfo["row"] as! NSArray
            
            for result in results{
                let resultDict=result as! NSDictionary
                let art=Art(title:resultDict["PRDCT_NM_KOREAN"] as? String,
                            artist:resultDict["WRITR_NM"] as? String,
                            thumbImageURL:resultDict["THUMB_IMAGE"] as? String)
                arts.append(art)
            }
            print(dict)
        }catch{
            print("Error")
        }
        
    }
    
    // 썸네일이미지 저장
    func getThumbImage(withURL imageURL:String)->UIImage?{
        let url:URL!=URL(string:imageURL)
        let imgData=try! Data(contentsOf: url)
        let image=UIImage(data: imgData)
        
        return image
    }

}


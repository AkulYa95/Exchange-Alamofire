//
//  TableViewController.swift
//  Exchange Alamofire
//
//  Created by Ярослав Акулов on 11.11.2021.
//

import UIKit
import Alamofire

class TableViewController: UITableViewController {
    let stringJson = "https://www.cbr-xml-daily.ru/daily_json.js"
    
    @IBOutlet weak var navigationTitleLabel: UINavigationItem!
    var course: WebsiteDescription!
    var valute: [String: ValuteDescription] = [:]
    var keys: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchData()
        fetchDataWithAlamofare()
        largeTitleEditing()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "course", for: indexPath) as! TableViewCell
        cell.cellConfigure(with: valute, keys, indexPath.row)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    // MARK: - FetchData
    func fetchData() {
        guard let url = URL(string: stringJson) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let dateForrmater = DateFormatter()
                dateForrmater.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                decoder.dateDecodingStrategy = .formatted(dateForrmater)
            self.course = try decoder.decode(WebsiteDescription.self, from: data)
                DispatchQueue.main.async {
                    guard let valute = self.course.valute else { return }
                    self.valute = valute
                    self.keys = self.getKeys(from: self.valute)
                    let title = self.createString(from: self.course.date)
                    self.navigationTitleLabel.title = title

                    for view in self.navigationController?.navigationBar.subviews ?? [] {
                         let subviews = view.subviews
                         if subviews.count > 0, let label = subviews[0] as? UILabel {
                             label.adjustsFontSizeToFitWidth = true
                         }
                    }
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
    // MARK: - FetchData with Alamofare
    
    func fetchDataWithAlamofare() {
        guard let url = URL(string: stringJson) else { return }
        AF.request(url).validate().responseJSON { dataResponse in
            
            switch dataResponse.result {
            case .success(let value):
                guard let dict = value as? [String: Any] else { return }
                guard let stringDate = dict["Date"] as? String else { return }
                let dateFormatter = ISO8601DateFormatter()
                let date = dateFormatter.date(from: stringDate)
                self.navigationTitleLabel.title = self.createString(from: date)
                guard let valutes = dict["Valute"] as? [String: Any] else { return }
                self.keys = self.getKeys(from: valutes)
                
                for key in self.keys {
                    guard let value = valutes[key] as? [String: Any] else { return }
                    let valuteDescription = ValuteDescription(
                        charCode: value["CharCode"] as? String,
                        nominal: value["Nominal"] as? Int,
                        name: value["Name"] as? String,
                        value: value["Value"] as? Double,
                        previousValue: value["Previous"] as? Double)
                    self.valute[key] = valuteDescription
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

                

            case .failure(let error):
                print(error)
            }
            }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        }
    
    func getKeys(from valute: [String: Any]) -> [String] {
        var keys:[String] = []
        for key in valute.keys {
            keys.append(key)
        }
        return keys.sorted()
    }
    
    func createString(from date: Date?) -> String {
        guard let date = date else { return "Курс ЦБ" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return "Курс ЦБ на \(dateFormatter.string(from: date))"
    }
    
    func largeTitleEditing() {
        for view in self.navigationController?.navigationBar.subviews ?? [] {
                                 let subviews = view.subviews
                                 if subviews.count > 0, let label = subviews[0] as? UILabel {
                                     label.adjustsFontSizeToFitWidth = true
                                 }
                            }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

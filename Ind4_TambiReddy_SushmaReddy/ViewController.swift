import UIKit

class ViewController: UIViewController , UITableViewDataSource {
    
    var fetchState = [States]()
    @IBOutlet var StateTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StateTableView.dataSource = self
        parseData()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchState.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StateTableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = fetchState[indexPath.row].statename
        cell?.detailTextLabel?.text = fetchState[indexPath.row].nickname
        
        return cell!
    }
    
    func parseData() {
        
        fetchState = []
        let url = "https://cs.okstate.edu/~stambir/states.php"
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = "GET"
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                print("Error")
            }
            else {
                do {
                    let fetchData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSArray
                    for eachFetchState in fetchData {
                        
                        let eachState = eachFetchState as! [String : Any]
                        let statename = eachState["statename"] as! String
                        let nickname = eachState["nickname"] as! String
                        
                        self.fetchState.append(States(statename : statename, nickname : nickname))
                    }
                    self.StateTableView.reloadData()
                }
                catch{
                    print("Error2")
                }
            }
        }
    task.resume()
}

}

class States {
    var statename : String
    var nickname : String
    
    init(statename : String , nickname : String) {
        self.statename = statename
        self.nickname = nickname
    }
}

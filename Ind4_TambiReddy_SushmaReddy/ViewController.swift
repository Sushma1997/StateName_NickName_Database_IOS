import UIKit

//adding UITableViewDataSource to display the table view in its format
class ViewController: UIViewController , UITableViewDataSource {
    
    var fetchState = [States]()
    @IBOutlet var StateTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //creating a spinner
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        
        //spinner location in the center of the screen
        myActivityIndicator.center = view.center
        
        myActivityIndicator.hidesWhenStopped = false
        // start the spinner
        myActivityIndicator.startAnimating()
              
        // adding subview for the spinner so that table view is loaded after that on the same screen
        view.addSubview(myActivityIndicator)
        
        //adding timer to the spinner
        let elapsed = Double().self
        
        var delay = 0.0
        if elapsed < 2.0 {
          delay = 2.0 - elapsed
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            //stop the spinner
          myActivityIndicator.stopAnimating()
            myActivityIndicator.isHidden = true
        }
        
        StateTableView.dataSource = self
        //calling parseData function
        parseData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //to retuen the table row count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchState.count
    }
    
    //returning the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StateTableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = fetchState[indexPath.row].statename
        cell?.detailTextLabel?.text = fetchState[indexPath.row].nickname
        
        return cell!
    }
    
    //function to read data from the database
    func parseData() {
        
        fetchState = []
        
        //url of the php file
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
                    //pulling the data of our desired format
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

//class for the table columns
class States {
    var statename : String
    var nickname : String
    
    init(statename : String , nickname : String) {
        self.statename = statename
        self.nickname = nickname
    }
}

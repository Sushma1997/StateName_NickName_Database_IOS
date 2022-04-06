import UIKit

class ViewController: UIViewController {
    
    var fetchState = [States]()

    override func viewDidLoad() {
        super.viewDidLoad()
        parseData()
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
                    print(self.fetchState)
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

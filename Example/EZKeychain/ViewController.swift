import EZKeychain

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = KeychainExample()
        _ = KeychainExampleObjc()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

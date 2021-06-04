import UIKit

class PopUpWindowController: UIViewController {
    
    private var popupView: UIView!
    private var popupTitle:UILabel!
    private var popupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = Color().colorBackground
        
        buildViews()
        addConstraints()
        
    }
    
    func buildViews() {
        view.backgroundColor = Color().colorBackground.withAlphaComponent(0.3)
        
        // Popup Background
        popupView = UIView()
        popupView.backgroundColor = Color().colorBackground
        popupView.layer.borderWidth = 8
        popupView.layer.masksToBounds = true
        popupView.layer.borderColor = UIColor.white.cgColor
        
        // Popup Title
        popupTitle = UILabel()
        popupView.addSubview(popupTitle)
        popupTitle.textColor = UIColor.white
        popupTitle.layer.masksToBounds = true
        popupTitle.clipsToBounds = true
        popupTitle.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        popupTitle.numberOfLines = 1
        popupTitle.textAlignment = .center
        popupTitle.text = "No Internet Connection!"
        
        // Popup Button
        popupButton = UIButton()
        popupView.addSubview(popupButton)
        popupButton.backgroundColor = .white.withAlphaComponent(0.5)
        popupButton.setTitle("OK", for: .normal)
        popupButton.setTitleColor(UIColor.white, for: .normal)
        popupButton.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        popupButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        view.addSubview(popupView)
    }
    
    func addConstraints() {
        
        // PopupView constraints
        popupView.autoCenterInSuperview()
        popupView.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        popupView.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        popupView.autoSetDimension(.height, toSize: 180)

        // PopupTitle constraints
        popupTitle.autoPinEdge(toSuperviewSafeArea: .top, withInset: 20)
        popupTitle.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 20)
        popupTitle.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 20)
        popupTitle.autoSetDimension(.height, toSize: 35)
        
        // PopupButton constraints
        popupButton.autoPinEdge(.top, to: .bottom, of: popupTitle, withOffset: 20)
        popupButton.autoPinEdge(toSuperviewSafeArea: .leading, withInset: 50)
        popupButton.autoPinEdge(toSuperviewSafeArea: .trailing, withInset: 50)
        popupButton.autoAlignAxis(toSuperviewAxis: .vertical)
        
    }
    
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
        
    }
    
}

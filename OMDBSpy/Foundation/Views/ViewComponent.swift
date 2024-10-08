import UIKit

@IBDesignable
class ViewComponent: UIView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.load()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.load()        
    }
    
    func load() {
        let className = self.dynamicType.simpleClassName()
        let view = NSBundle(forClass: self.dynamicType).loadNibNamed(className, owner: self, options: nil).first as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
        
}

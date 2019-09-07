import UIKit

class MovieDetailFieldView: UIView {

    convenience init(icon:UIImage, text:String?, atOrigin: CGPoint, width: CGFloat) {
        self.init(frame: CGRect(origin: atOrigin, size: CGSize(width: width, height: 72)))
        
        let imageView = UIImageView(frame: CGRect(x: 16, y: 16, width: 24, height: 24))
        imageView.image = icon
        self.addSubview(imageView)
        
        if let text = text {
            let y = CGFloat(16)
            let x = imageView.frame.origin.x + imageView.frame.width + 16
            let frame = CGRect(x: x, y: y, width: self.frame.width - 16, height: 24)
            let titleLabel = UILabel(frame: frame)
            titleLabel.numberOfLines = 0
            titleLabel.text = text
            titleLabel.font = UIFont(name: "Helvetica", size: 14.0)
            titleLabel.textColor = UIColor(red: 98, green: 98, blue: 98, alpha: 1.0)
            titleLabel.frame.origin.y = self.frame.height - titleLabel.frame.height - CGFloat(16)
            self.addSubview(titleLabel)
        }
        
    }
    
}

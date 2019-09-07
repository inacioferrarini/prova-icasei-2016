import UIKit

class MovieDetailPosterView: UIView {
    
    convenience init(title:String?, poster:String?, atOrigin: CGPoint, width: CGFloat) {
        self.init(frame: CGRect(origin: atOrigin, size: CGSize(width: width, height: 200)))
        
        if let poster = poster,
            let posterUrl = NSURL(string: poster) {
                let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                let posterImage = UIImageView(frame: frame)
                posterImage.contentMode = .ScaleToFill
                posterImage.sd_setImageWithURL(posterUrl)
                self.addSubview(posterImage)
        }
        
        if let title = title {
            let frame = CGRect(x: 16, y: 0, width: self.frame.width, height: 24)
            let titleLabel = UILabel(frame: frame)
            titleLabel.text = title
            titleLabel.font = UIFont(name: "Roboto-Regular", size: 24.0)
            titleLabel.textColor = UIColor.whiteColor()
            titleLabel.frame.origin.y = self.frame.height - titleLabel.frame.height - CGFloat(16)
            self.addSubview(titleLabel)
        }
        
    }
    
}

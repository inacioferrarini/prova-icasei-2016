import UIKit

class MovieDetailDescriptionView: UIView {
    
    convenience init(plot:String?, atOrigin: CGPoint, width: CGFloat) {
        self.init(frame: CGRect(origin: atOrigin, size: CGSize(width: width, height: 120)))
        
        let plotLabelFrame = CGRect(x: 16, y: 16, width: self.frame.width - 16, height: 24)
        let plotLabel = UILabel(frame: plotLabelFrame)
        plotLabel.text = "Sinopse:"
        plotLabel.font = UIFont(name: "Roboto-Medium", size: 14.0)
        plotLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.87)
        self.addSubview(plotLabel)
        
        if let plot = plot {
            let y = plotLabel.frame.origin.y + plotLabel.frame.size.height + 9
            let frame = CGRect(x: 16, y: y, width: self.frame.width - 16, height: 24)
            let titleLabel = UILabel(frame: frame)
            titleLabel.text = plot
            titleLabel.font = UIFont(name: "Helvetica", size: 14.0)
            titleLabel.textColor = UIColor(red: 98, green: 98, blue: 98, alpha: 1.0)
            titleLabel.frame.origin.y = self.frame.height - titleLabel.frame.height - CGFloat(16)
            self.addSubview(titleLabel)
        }
        
    }
    
}

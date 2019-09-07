import UIKit

class BubbleLayer : CALayer {
    
    // MARK: Public Properties
    
    var string: String? {
        didSet {
            if (string == nil) {
                self.opacity = 0.0
            } else {
                layerLabel.string = string
                self.opacity = 1.0
            }
            setNeedsLayout()
        }
    }
    var font: UIFont = UIFont(name: "Helvetica-Bold", size: 27.0)! {
        didSet {
            layerLabel.font = font
            layerLabel.fontSize = font.pointSize
        }
    }
    //テキストの色周り
    var textColor: UIColor = UIColor.orange {
        didSet { layerLabel.foregroundColor = textColor.cgColor }
    }
    var paddingHorizontal: CGFloat = 10.0 {
        didSet { setNeedsLayout() }
    }
    
    var paddingVertical: CGFloat = 25.0 {
        didSet { setNeedsLayout() }
    }
    
    var maxWidth: CGFloat = 250.0 {
        didSet { setNeedsLayout() }
    }

    
    
    private var layerLabel = BubbleLabelLayer()
    
    
    convenience init(string: String) {
        self.init()

        self.string = string /*+ "aa"*/

        // default values (can be changed by caller)
        //吹き出しの色
        
        backgroundColor = UIColor(displayP3Red: 0.0, green: 0.0/*120.0*/, blue: 0.0/*255.0*/, alpha: 0.0).cgColor
        borderColor = UIColor.white.cgColor
        borderWidth = 0
        //吹き出しのふち
        
        contentsScale = UIScreen.main.scale
        allowsEdgeAntialiasing = true
        
        layerLabel.string = self.string
        layerLabel.font = font
        layerLabel.fontSize = font.pointSize
        layerLabel.foregroundColor = textColor.cgColor
        layerLabel.alignmentMode = kCAAlignmentCenter
        layerLabel.contentsScale = UIScreen.main.scale
        layerLabel.allowsFontSubpixelQuantization = true
        layerLabel.isWrapped = true
        layerLabel.updatePreferredSize(maxWidth: self.maxWidth - (paddingHorizontal * 2))
        layerLabel.frame = CGRect(origin: CGPoint(x: paddingHorizontal, y: paddingVertical), size: layerLabel.preferredFrameSize())
        addSublayer(layerLabel)
        
        setNeedsLayout()
    }
    
    override func layoutSublayers() {

        layerLabel.updatePreferredSize(maxWidth: self.maxWidth - (paddingHorizontal * 2))

        let preferredSize = preferredFrameSize()
        let diffSize = CGSize(width: frame.size.width - preferredSize.width, height: frame.size.height - preferredSize.height)
        //全体の場所↓
        frame = CGRect(origin: CGPoint(x: frame.origin.x + (diffSize.width / 2), y: frame.origin.y + (diffSize.height / 2)), size: preferredSize)
        //曲率？
        cornerRadius = frame.height / 100
        //文字の場所↓
        layerLabel.frame = CGRect(x: 0, y: paddingVertical, width: frame.width, height: frame.height)

    }
    
    override func preferredFrameSize() -> CGSize {
        let layerLabelSize = layerLabel.preferredFrameSize()
        //バンドルの大きさを変える。
        return CGSize(width: layerLabelSize.width + (paddingHorizontal * 2),
                    height: layerLabelSize.height + (paddingVertical * 2))
    }
    
}

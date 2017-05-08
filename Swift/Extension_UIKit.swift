
import UIKit
extension UIWindow {
    /*
     let transition = CATransition()
     transition.type = kCATransitionFade
     window.set(rootViewController: viewController, withTransition: transition)
     */
    /// Fix for http://stackoverflow.com/a/27153956/849645
    func set(rootViewController newRootViewController: UIViewController, withTransition transition: CATransition? = nil) {
        
        let previousViewController = rootViewController
        
        if let transition = transition {
            // Add the transition
            layer.add(transition, forKey: kCATransition)
        }
        
        rootViewController = newRootViewController
        
        // Update status bar appearance using the new view controllers appearance - animate if needed
        if UIView.areAnimationsEnabled {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                newRootViewController.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            newRootViewController.setNeedsStatusBarAppearanceUpdate()
        }
        
        /// The presenting view controllers view doesn't get removed from the window as its currently transistioning and presenting a view controller
        if let transitionViewClass = NSClassFromString("UITransitionView") {
            for subview in subviews where subview.isKind(of: transitionViewClass) {
                subview.removeFromSuperview()
            }
        }
        if let previousViewController = previousViewController {
            // Allow the view controller to be deallocated
            previousViewController.dismiss(animated: false) {
                // Remove the root view in case its still showing
                previousViewController.view.removeFromSuperview()
            }
        }
    }
}
//MARK:
//MARK:  String的各种方法
//MARK:
extension String {
    
    
    func jsonStrintToDict()->Any{
        
        let jsonData=self.data(using: .utf8)
        
        let dict=try! JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments)
        
        return dict
    }
    func md5String() -> String {
        
        let str = self.cString(using: .utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen);
        
        CC_MD5(str!, strLen, result);
        
        
        let hash = NSMutableString();
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }
        result.deinitialize();
        
        return String(format: hash as String)
    }
    func fontSizeAccordingTo(height:CGFloat) -> CGFloat {
        return height/1.2
    }
    func heightAccordingTo(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return boundingBox.height
    }
    enum StringType:String{
        case number="0123456789"
        case number_point="0123456789."
        case lowercase="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        case uppercase_letter="abcdefghijklmnopqrstuvwxyz"
        case lowercase_uppercase_letter="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
        case number_letter="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        
    }
    func isKindOf(_ type:StringType) -> Bool {
        let limitString=type.rawValue
        return limitString.contains(self)
    }
    
}

//MARK:
//MARK:  UIColor 的各种方法
//MARK:
extension UIColor{
    
    var redVaule : CGFloat{
        get{
            return self.cgColor.components![0]
        }
    }
    var greenVaule : CGFloat{
        get{
            return self.cgColor.components![1]
        }
    }
    var blueVaule : CGFloat{
        get{
            return self.cgColor.components![2]
        }
    }
    var alphaVaule : CGFloat{
        get{
            return self.cgColor.components![3]
        }
    }
    
    class func random() -> UIColor{
        let redValue=CGFloat(drand48())
        let greenValue=CGFloat(drand48())
        let blueValue=CGFloat(drand48())
        
        return UIColor(red: redValue , green:greenValue ,blue:blueValue , alpha:1)
    }
    
    
    convenience init(r: Int, g: Int, b: Int,a: CGFloat) {
        assert(r >= 0 && r <= 255, "Invalid red component")
        assert(g >= 0 && g <= 255, "Invalid green component")
        assert(b >= 0 && b <= 255, "Invalid blue component")
        assert(a >= 0.0 && a <= 1.0, "Invalid blue component")
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    convenience init(r: Int, g: Int, b: Int) {
        self.init(r: r, g: g, b: b, a: 1.0)
    }
    convenience init(netHex:Int) {
        self.init(r:(netHex >> 16) & 0xff, g:(netHex >> 8) & 0xff, b:netHex & 0xff)
    }
    
    class func rbg(_ r: CGFloat,_ g: CGFloat,_ b: CGFloat) -> UIColor {
        
        return self.rbga(r, g, b, 1.0)
    }
    
    class func rbga(_ r: CGFloat,_ g: CGFloat,_ b: CGFloat ,_ a : CGFloat) -> UIColor {
        let color = UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: a)
        return color
    }
    
    
    func returnUIImage() -> UIImage {
        
        let rect=CGRect.init(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size);
        
        let context = UIGraphicsGetCurrentContext();
        
        context!.setFillColor(self.cgColor);
        
        context!.fill(rect);
        
        let  image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image!
        
    }
}

//MARK:
//MARK:  UIButton_extension:设置按钮背景
//MARK:

extension UIButton{
    
    open func setBackgroundColor(_ backgroundColor: UIColor, for state: UIControlState){
        self.setBackgroundImage(backgroundColor.returnUIImage(), for: state)
    }
    
    
}

//MARK:
//MARK:  UIImage的各种方法
//MARK:
extension UIImage{
    
    
    //MARK:
    //MARK:  base64<->UIImage
    //MARK:
    class func from(baseString:String)->UIImage{
        guard baseString.characters.count != 0 else {
            return UIImage()
        }
        let data=NSData(base64Encoded: baseString, options: .ignoreUnknownCharacters)
        return UIImage(data: data! as Data)!
    }
    func changeToBase64String () -> String{
        let imageData=UIImageJPEGRepresentation(self, 0.5)
        return (imageData?.base64EncodedString(options: .endLineWithLineFeed))!
    }
    
    
    
    class func pngFromBundle(with name:String) -> UIImage {
        return UIImage.init(contentsOfFile: Bundle.main.path(forResource: name, ofType: "png")!)!
    }
    class func jpgFromBundle(with name:String) -> UIImage {
        return UIImage.init(contentsOfFile: Bundle.main.path(forResource: name, ofType: "jpg")!)!
    }
    class func contentOfURL(link: String) -> UIImage {
        let url = URL.init(string: link)!
        var image = UIImage()
        do{
            let data = try Data.init(contentsOf: url)
            image = UIImage.init(data: data)!
        } catch _ {
            print("error downloading images")
        }
        return image
    }
    
    func stretchImage()->UIImage{
        //第一种拉伸
        /*
         return [self stretchableImageWithLeftCapWidth:self.size.width * 0.5 topCapHeight:self.size.height * 0.5];
         */
        
        //第二种拉伸
        //UIImageResizingModeTile, 平铺
        //UIImageResizingModeStretch, 拉伸
        //CapInsets 不拉伸的范围
        
        let inset=UIEdgeInsets.init(top: self.size.width * 0.5, left: self.size.height * 0.5, bottom: self.size.width * 0.5, right: self.size.height * 0.5)
        
        return self.resizableImage(withCapInsets: inset, resizingMode: UIImageResizingMode.tile)
        
    }
    
    func scaleImageWithSize(_ size:CGSize) -> UIImage {
        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
        
        let width=size.width
        let height=size.height
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false,UIScreen.main.scale);
        // 绘制改变大小的图片
        self.draw(in: CGRect.init(x: 0, y: 0, width: width, height: height))
        
        // 从当前context中创建一个改变大小后的图片
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 使当前的context出堆栈
        UIGraphicsEndImageContext();
        
        // 返回新的改变大小后的图片
        return scaledImage!;
    }
    
    class func scaleWith(imageName:String,ratio number:CGFloat,width:CGFloat?,height:CGFloat?)->UIImage{
        let size:CGSize!
        if height != nil {
            size=CGSize(width: height!*number, height: height!)
        }else if width != nil{
            size=CGSize(width: width!, height: width!/number)
        }else{
        
            let bool=(width == nil && height != nil)||(width != nil && height == nil)
            assert(bool,"有且只能其中一个有值")
            return UIImage()
        }
        let image=UIImage.pngFromBundle(with: imageName).scaleImageWithSize(size)
        return image
        
    }
    
    func rotationWithUIImageOrientation(_ orientation:UIImageOrientation) -> UIImage {
        
        
        var rotate  = 0.0;
        let rect = CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height);
        var translateX : CGFloat = 0.0;
        var translateY : CGFloat = 0.0;
        var scaleX : CGFloat = 1.0;
        var scaleY : CGFloat = 1.0;
        
        switch (orientation) {
        case UIImageOrientation.left:
            
            rotate = Double.pi/2;
            
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            
        case UIImageOrientation.right:
            rotate = 3 * Double.pi/2;
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            
        case UIImageOrientation.down:
            rotate = Double.pi;
            
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            
        default:
            rotate = 0.0;
            
            translateX = 0;
            translateY = 0;
            break;
        }
        
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext()!;
        
        //做CTM变换
        context.translateBy(x: 0.0, y: rect.size.height);
        context.scaleBy(x: 1.0, y: -1.0);
        context.rotate(by: CGFloat(rotate));
        context.translateBy(x: translateX, y: translateY);
        
        context.scaleBy(x: scaleX, y: scaleY);
        //绘制图片
        context.draw(self.cgImage!, in: rect)
        
        return UIGraphicsGetImageFromCurrentImageContext()!;
    }
    
    func condenseToJPGWithNumber(_ Number:CGFloat) -> UIImage {
        let data = UIImageJPEGRepresentation(self, Number);
        return UIImage.init(data: data!)!
    }
    
    
}


//MARK:
//MARK:  UIView
//MARK:
extension UIView{
    class func create(With nibName:String) -> Any? {
        //String.init(describing: self.self
        let view=Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first
        return view
    }
    func corner(_ radiusNumber:CGFloat)  {
        self.layer.masksToBounds=true
        self.layer.cornerRadius=radiusNumber
    }
}




extension UIView{
    
    var x : CGFloat{
        set{
            var rect = self.frame as CGRect
            
            rect.origin.x = newValue
            self.frame = rect
        }
        get{
            return self.frame.origin.x
        }
    }
    
    var y : CGFloat{
        set{
            var rect = self.frame
            
            rect.origin.y = newValue
            self.frame = rect
        }
        get{
            return self.frame.origin.y
        }
        
    }
    var centerX : CGFloat{
        set{
            var center = self.center
            center.x=newValue
            self.center=center
        }
        get{
            return self.center.x
        }
    }
    var centerY : CGFloat{
        set{
            var center = self.center
            center.y=newValue
            self.center=center
        }
        get{
            return self.center.y
        }
    }
    
    var origin : CGPoint{
        set{
            self.x=newValue.x
            self.y=newValue.y
        }
        get{
            return self.frame.origin
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var rect = self.frame;
            rect.size.width = newValue;
            self.frame = rect;
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var rect = self.frame;
            rect.size.height = newValue;
            self.frame = rect;
        }
    }
    
    var size : CGSize{
        set{
            self.width=newValue.width
            self.height=newValue.height
        }
        get{
            return self.frame.size
        }
    }
    
    var minX: CGFloat {
        return self.frame.minX
    }
    var maxX: CGFloat {
        return self.frame.maxX
    }
    var minY: CGFloat {
        return self.frame.minY
    }
    var maxY: CGFloat {
        return self.frame.maxY
    }
    var midX: CGFloat {
        return self.frame.midX
    }
    var midY: CGFloat {
        return self.frame.midY
    }
    
}

//MARK:
//MARK:  RunTime_动态方法
//MARK:
extension NSObject{
    func className() ->String  {
        
        return String(describing: type(of:self))
    }
    
    private struct Key {
        static var string = "string"
        static var integer = "integer"
        static var object = "object"
        static var bool = "bool"
    }
    
    
    var stringProperty:String{
        get{
            let result=objc_getAssociatedObject(self,&Key.string)
            guard result != nil else {
                return ""
            }
            return result as! String
        }
        set(newValue){
            objc_setAssociatedObject(self, &Key.string, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    var integerProperty:Int{
        get{
            let result=objc_getAssociatedObject(self,&Key.integer)
            if result != nil {
                return 0
            }
            return result as! Int
        }
        set(newValue){
            objc_setAssociatedObject(self, &Key.integer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    var boolProperty:Bool{
        get{
            let result=objc_getAssociatedObject(self,&Key.bool)
            guard result != nil else {
                return false
            }
            
            return result as! Bool
        }
        set(newValue){
            objc_setAssociatedObject(self, &Key.bool, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    var objectProperty:AnyObject{
        get{
            let result=objc_getAssociatedObject(self,&Key.object)
            guard result != nil else {
                return NSObject()
            }
            
            return result as AnyObject
        }
        set(newValue){
            objc_setAssociatedObject(self, &Key.object, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
        }
    }
    
    
}
import CoreImage
extension UIImage{
    class func returnQRCodeImage(with content:String) -> UIImage {
        let oriCIimage=self.creteCodeCIImage(with: content)
        
        return self.self.createUIImage(Form: oriCIimage, and: 1000)
    }
    private class func creteCodeCIImage(with info:String)->CIImage{
        let filter=CIFilter(name: "CIQRCodeGenerator")
        
        // 2.还原滤镜初始化属性
        filter?.setDefaults()
        
        let data=info.data(using: .utf8)
        filter?.setValue(data, forKey: "inputMessage")
        
        
        let outputImage=(filter?.outputImage)!
        
        return outputImage
        
    }
    private class func createUIImage(Form ciImage:CIImage,and size:CGFloat) -> UIImage {
        let extent=ciImage.extent.integral
        
        let original_W=extent.size.width
        let original_H=extent.size.height
        
        
        let scale=min(size/original_W, size/original_H)
        
        let width:size_t=Int(original_W*scale)
        let height:size_t=Int(original_H*scale)
        
        let cs=CGColorSpaceCreateDeviceGray()
        
        
        let bitmapRef=CGContext.init(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        let context=CIContext.init(options: nil)
        
        let bitmapImage=context.createCGImage(ciImage, from: extent)
        
        bitmapRef!.interpolationQuality = CGInterpolationQuality.none
        
        bitmapRef!.scaleBy(x: scale, y: scale)
        
        bitmapRef?.draw(bitmapImage!, in: extent)
        
        
        //保存图片
        let scaledImage=(bitmapRef!.makeImage())!
        
        
        
        let uiimage=UIImage(cgImage: scaledImage)
        return uiimage
    }
    
    
}
extension Date{
    static func systemDate()->Date{
        let interval=NSTimeZone.system.secondsFromGMT()
        let systemDate=Date(timeInterval: TimeInterval(interval), since: Date())
        return systemDate
        
    }
}



extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block:(Void)->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}

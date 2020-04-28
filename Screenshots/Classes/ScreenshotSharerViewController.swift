/*
 MIT License
 
 Copyright (c) 2017 Yagiz Gurgul
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit

@objc public protocol ScreenshotSharerViewControllerProtocol
{
    func screenshotSharer() -> ScreenshotSharer?
    func setScreenshotSharer(_ screenshotSharer:ScreenshotSharer)
    
    func setScreenshotImage(_ image:UIImage)
}

@objc public protocol ScreenshotSharerViewControllerTextProtocol
{
    func setShareTitleText(_ text:String)
    func setShareDescriptionText(_ text:String)
    func setShareButtonTitleText(_ text:String)
}

@objc public protocol ScreenshotSharerViewControllerFontProtocol
{
    func setShareTitleFont(_ font:UIFont)
    func setShareDescriptionFont(_ font:UIFont)
    func setShareButtonTitleFont(_ font:UIFont)
}

@objc public protocol ScreenshotSharerViewControllerColorProtocol
{
    func setShareTitleTextColor(_ color:UIColor)
    func setShareDescriptionTextColor(_ color:UIColor)
    func setShareButtonTitleColor(_ color:UIColor)
    func setShareButtonBackgroundColor(_ color:UIColor)
}

@objc open class ScreenshotSharerViewController: UIViewController, ScreenshotSharerViewControllerProtocol, ScreenshotSharerViewControllerTextProtocol, ScreenshotSharerViewControllerFontProtocol, ScreenshotSharerViewControllerColorProtocol
{
    
    open weak var screenshotSharerInstance:ScreenshotSharer?
    
    open func screenshotSharer() -> ScreenshotSharer?
    {
        return self.screenshotSharerInstance
    }
    
    open func setScreenshotSharer(_ screenshotSharer: ScreenshotSharer)
    {
        self.screenshotSharerInstance = screenshotSharer
    }
    
    open func setScreenshotImage(_ image:UIImage) {}
    
    open func setShareTitleText(_ text:String) {}
    open func setShareDescriptionText(_ text:String) {}
    open func setShareButtonTitleText(_ text:String) {}
    
    open func setShareTitleFont(_ font:UIFont) {}
    open func setShareDescriptionFont(_ font:UIFont) {}
    open func setShareButtonTitleFont(_ font:UIFont) {}
    
    open func setShareTitleTextColor(_ color:UIColor) {}
    open func setShareDescriptionTextColor(_ color:UIColor) {}
    open func setShareButtonTitleColor(_ color:UIColor) {}
    open func setShareButtonBackgroundColor(_ color:UIColor) {}
    
}


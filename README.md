# ShapeShift

## Application
ShapeShift lets you write in a PDF document and converts your handwriting into text. Ever since I was a small boy, I’ve had terrible handwriting. Using ShapeShift, I can quickly and comfortably write anything down without anyone seeing my offensive handwriting.

## Design
I tried to keep the Application as famiar and stadard to Apple's UI Guidlines as much as possible. When you open the App you are greeted with a welcome screen that talks about the features of ShapeShift. ShapeShift uses Apple's File's App to manage, open, and create PDF documents. The drawing portion of the App uses delegation to modify the given PDFKit PDF. 

## CHALLENGES
HAND WRITING RECOGNITON IS NOT EASY. I tried multiple different approches and still am not happy with any of the outcomes (but I havent given up). I first tried using Microsofts cloud based handwriting recognition, but it didn't work as well as i expected, and I really wanted to make the App not rely on an internet connection. I then attempted to train my own tensorflow model... this didn't work too well because I could not figure out how to convert the [model I found](https://towardsdatascience.com/build-a-handwritten-text-recognition-system-using-tensorflow-2326a3487cd5) to TFlite (the mobile version of tensorflow). Ultimatly I ended up using SwiftOCR a library you can train with different fonts. I tried training the model with a font created using my handwriting, but it still needs a lot of work. The red pen seems to get the best results for some reason.

## References 
For the PDF Drawing and Text insertion I consulted this beautiful tutorial by Artem Poluektov. He deserves so much credit for actually having a well published tutorial on PDF annotaion!
https://medium.com/@artempoluektov/ios-pdfkit-tutorial-text-annotations-more-d0175436b28b

I'm using SwiftOCR by Nicolas Camenisch for handwriting recognition. 
https://github.com/garnele007/SwiftOCR

The beautiful Apple inspired welcome screen is by Wilson Gramer.
https://github.com/WilsonGramer/AppleWelcomeScreen

Apple Documentation came in handy to build a document based app so quickly!
https://developer.apple.com/documentation/uikit/uidocumentbrowserviewcontroller
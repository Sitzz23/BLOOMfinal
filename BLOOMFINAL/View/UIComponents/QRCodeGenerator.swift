//
//  QRCodeGenerator.swift
//  BLOOMFINAL
//
//  Created by Inzamam on 13/06/23.
//

import SwiftUI

struct QRCodeGenerator: View {
    @State var eventName = "Devfest"
    @State var eventDate = "30-06-23"
    @State var eventTime = "11:05pm"
    @State var personsCount = 1
    var body: some View {
        HStack{
            
            if eventName != ""{
                Image(uiImage: UIImage(data: returnData(planUrl: "\(eventName)- \(eventDate)-\(eventTime)-\(personsCount) Person"))!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
            }
        }.padding()
    }
    
    func returnData(planUrl: String) -> Data {
            let filter = CIFilter(name: "CIQRCodeGenerator")
            let data = planUrl.data(using: .ascii, allowLossyConversion: false)

            filter?.setValue(data, forKey: "inputMessage")
            let qrImage = filter?.outputImage?.transformed(by: CGAffineTransform(scaleX: 5, y: 5))

            guard let ciImage = qrImage else { return Data() }

            let size = CGSize(width: 120, height: 120) // Adjust the size as needed
            UIGraphicsBeginImageContext(size)
            let context = UIGraphicsGetCurrentContext()
            context?.interpolationQuality = .none
            let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent)!
            context?.draw(cgImage, in: context!.boundingBoxOfClipPath)
            let uiImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return uiImage?.pngData() ?? Data()
        }
}

struct QRCodeGenerator_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeGenerator()
    }
}

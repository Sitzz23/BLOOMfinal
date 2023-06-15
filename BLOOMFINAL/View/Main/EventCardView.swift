//
//  EventCardView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 13/06/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct EventCardView: View {
    
    var event: Event
    var onUpdate: (Event)->()
    var onDelete: ()->()
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let rect = $0.frame(in: .named("SCROLLVIEW"))
            //        VStack(alignment: .leading){
            //            VStack(spacing: 10) {
            HStack(spacing: -25){
                VStack(alignment: .center, spacing: 6){
                                    VStack(alignment: .leading){
                                        Text(event.name)
                                            .font(.title3)
                                            .fontWeight(.semibold)
//                                        HStack{
//                                            Image(systemName: "location")
//                                                .font(.system(size: 16))
//                                                .foregroundColor(Color("accent"))
//                                            Text(event.venue)
//                                                .font(.callout)
//                                                .textSelection(.enabled)
//                                                .padding(.vertical,8)
//                                        }
//                                        HStack{
//                                            Image(systemName: "calendar")
//                                                .font(.system(size: 16))
//                                                .foregroundColor(Color("accent"))
                                            Text(event.date.formatted(date: .numeric, time: .shortened))
                                                .font(.caption)
                                                .foregroundColor(Color("primary"))
//                                        }
                    
//                                        HStack{
//                                            Image(systemName: "text.bubble")
//                                                .font(.system(size: 16))
//                                                .foregroundColor(Color("accent"))
                                            Text(event.description)
                                                .textSelection(.enabled)
                                                .font(.caption2)
                                                .padding(.vertical,8)
                    
//                                        }
                    
                    
                                    }.padding()
                }
                .frame(width: size.width/2, height: size.height * 0.8)
                .background{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
                }
                .zIndex(1)
                
               // .
                //                        VStack(alignment: .leading, spacing: 6){
                //                            Text("Hieiie")
                //                        }
                //                        .frame(width: size.width/2, height: size.height * 0.8)
                //                        .background{
                //                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                //                                .fill(.white)
                //                                .shadow(color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
                //                                .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
                //                        }
                
                ZStack{
                    if let eventImage = event.imgURL{
                        //                                GeometryReader{
                        //                                    let size1 = $0.size
                        WebImage(url: eventImage)
                            .resizable ()
                            .aspectRatio (contentMode: .fill)
                            .frame (width: size.width/2, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }.frame(height: 220)
                        
                        
                }
            }
               // .hAlign(.leading)
         
//    }
//}


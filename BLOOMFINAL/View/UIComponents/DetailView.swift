//
//  DetailView.swift
//  BLOOMFINAL
//
//  Created by Inzamam on 15/06/23.
//

import SwiftUI

struct DetailView: View {
    @Binding var show : Bool
    var animation: Namespace.ID
    var event: Event?
    
    var body: some View {
        VStack(spacing: 15){
            Button{
                withAnimation(.easeInOut(duration: 0.35)){
                    show = false
                }
            }label: {
                Image(systemName: "chevron.left")
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background{
            Rectangle()
                .fill(.background)
                ignoresSafeArea()
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

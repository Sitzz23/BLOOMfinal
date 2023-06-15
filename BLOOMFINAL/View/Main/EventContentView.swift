//
//  EventContentView.swift
//  BLOOMFINAL
//
//  Created by Sitanshu Pokalwar on 13/06/23.
//

import SwiftUI
import Firebase

struct EventContentView: View {
    
    //    var basedOnUID: Bool = false
    //    var uid: String = ""
    @Binding var events: [Event]
    @State private var isFetching: Bool = true
    @State private var paginationDoc: QueryDocumentSnapshot?
    @State private var showDetailView: Bool = false
    @State private var selectedEvent: Event?
    @Namespace private var animation
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack{
                if isFetching{
                    ProgressView()
                        .padding(.top, 30)
                }
                else{
                    if events.isEmpty{
                        Text("No events found")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding()
                    }else{
                        Events()
                    }
                }
            }
            .padding(15)
            .overlay{
                if let selectedEvent = selectedEvent, showDetailView{
                    DetailView(show: $showDetailView, animation: animation, event: selectedEvent )
                }
            }
            
            //                if let selectedEvent, showDetailView{
            //                    DetailView(show: $showDetailView ,animation: animation, event: Event?)
            //                }
            
        }
        .refreshable{
            // guard !basedOnUID else{return}
            
            isFetching = true
            events = []
            //   paginationDoc = nil
            await fetchEvents()
        }
        .task{
            guard events.isEmpty else{return}
            await fetchEvents()
        }
    }
    
    //displaying fetched events
    @ViewBuilder
    func Events()->some View{
        ForEach(events){event in
            Button{
                
            }label:{
                
                
                EventCardView(event: event){updatedEvent in
                    
                }onDelete: {
                    
                }
                .onAppear{
                    if event.id == events.last?.id && paginationDoc != nil{
                        Task{await fetchEvents()}                }
                }
                .onTapGesture {
                    withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)){
                        selectedEvent = event
                        showDetailView = true
                    }
                }
            }
            Divider()
                .padding(.top, 10)
                .padding(.bottom, 10)
        }
    }
    //fetching events
    func fetchEvents()async{
        do{
            var query: Query!
            //pagination
            if let paginationDoc{
                query = Firestore.firestore().collection("Events")
                    .order(by: "date", descending: true)
                    .start(afterDocument: paginationDoc)
                    .limit(to: 20)
            }else{
                query = Firestore.firestore().collection("Events")
                    .order(by: "date", descending: true)
                    .limit(to: 20)
            }
            //query for UID
            //            if basedOnUID{
            //                query = query.whereField("userUID", in: uid)
            //            }
            
            let docs = try await query.getDocuments()
            
            let fetchedEvents = docs.documents.compactMap{ doc -> Event? in
                try? doc.data(as: Event.self)
            }
            await MainActor.run(body:{
                events.append(contentsOf: fetchedEvents)
                paginationDoc = docs.documents.last
                isFetching = false
            })
        }catch{
            print(error.localizedDescription)
        }
    }
    
}


struct EventContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

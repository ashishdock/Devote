//
//  ContentView.swift
//  Devote
//
//  Created by Ashish Sharma on 01/02/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //MARK: - PROPERTIES
    @State var task: String = ""
    @State private var showNewTaskItem: Bool = false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    //MARK: - FETCHING DATA
    
    @Environment(\.managedObjectContext) private var viewContext //( An environment where we can manipulate Core Data objects entirely in RAM. viewContext is like scratchpade to perform CRUD operations)

    @FetchRequest(     //(Fetch request: property wrapper. It can have 4 parameters,1. Entity, 2. Sort Descriptor, 3. Predicate, 4. Animation)
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    //MARK: - FUNCTION
    
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        playSound(sound: "sound-ding", type: "mp3")
    }
    
    
    //MARK: - BODY
    
    var body: some View {
        NavigationView {
            ZStack {
                //MARK: MAIN VIEW
                VStack{
                    //MARK: HEADER
                    
                    HStack(spacing: 10){
                        //TITLE
                        Text("Devote")
                            .font(.system(.largeTitle, design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading, 4)
                        
                        Spacer()
                        //EDIT BUTTON
                        EditButton()
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 10)
                            .frame(minWidth: 70, minHeight: 24)
                            .background(Capsule().stroke(Color.white, lineWidth: 2))
                        // APPEARANCE BUTTON
                        Button {
                            //TOGGLE APPEARANCE
                            isDarkMode.toggle()
                            playSound(sound: "sound-tap", type: "mp3")
                            feedback.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.success)
                        } label: {
                            Image(systemName: isDarkMode ? "sun.max.fill" : "moon.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .font(.system(.title, design: .rounded))
                        }

                        
                    } //: HSTACK
                    .padding()
                    .foregroundColor(.white)
                    
                    Spacer(minLength: 80)
                    //: NEW TASK ITEM
                    
                    Button {
                        showNewTaskItem = true
                        playSound(sound: "sound-ding", type: "mp3")
                        feedback.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.success)
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(colors: [Color.pink, Color.blue], startPoint: .leading, endPoint: .trailing)
                            .clipShape(Capsule())
                    )
                    .shadow(color: .white.opacity(0.25), radius: 8, x: 0, y: 4)

                    
                    //: TASKS
                    
                    List {
                        ForEach(items) { item in
                            NavigationLink {
                                // This is the view to which the Navigation link will lead to.
//
                                
// This is the old view, the boave is the new view
                                VStack(alignment: .leading) {
                                    Text(item.task ?? "")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                    Text(item.completion ? "Status: Complete" : "Status: Pending")

                                    //                                Text('Completion Status: \(item.completion ? "Complete" : "Pending")')
                                } //: VSTACK List Item
                            } label: { //Navigation link to the nextview after selecting a list item
                            ListRowItemView(item: item)
//                                VStack(alignment: .leading){
//                                    Text(item.task ?? "")
//                                        .font(.headline)
//                                        .fontWeight(.bold)
//                                    Text(item.timestamp!, formatter: itemFormatter)
//                                        .font(.footnote)
//                                        .foregroundColor(.gray)
//                                }
                            } //Navigation link to the nextview after selecting a list item
                        } //: FOREACH - List all items
                        .onDelete(perform: deleteItems)
                    } //: LIST
                    .listStyle(InsetGroupedListStyle())
                    .shadow(color: .white.opacity(0.5), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                } //: VSTACK
                .blur(radius: showNewTaskItem ? 8.0 : 0, opaque: false)
                .transition(SwiftUI.AnyTransition.move(edge: Edge.bottom))
                .animation(SwiftUI.Animation.easeOut(duration: 0.5), value: showNewTaskItem)
                //: MARK NEW TASK ITEM
                if showNewTaskItem {
                    BlankView(backgroundColor: isDarkMode ? .black : .gray,
                              backgroundOpacity: isDarkMode ? 0.3 : 0.5)
                        .onTapGesture {
                            withAnimation {
                                showNewTaskItem = false
                            }
                        }
                    
                    NewTaskItemView(isShowing: $showNewTaskItem)
                }
            }//:ZSTACK
            .onAppear(perform: {
                UITableView.appearance().backgroundColor = UIColor.clear
            })
            .navigationBarTitle("Daily Tasks", displayMode: NavigationBarItem.TitleDisplayMode.large)
            .navigationBarHidden(true)
            
            .background( // it's a png and will overlap the background gradient
                BackgroundImageView()
                    .blur(radius: showNewTaskItem ? 8 : 0, opaque: false)
            )
            .background(backgroundGradient.ignoresSafeArea(.all))
        } //: NAVIGATION VIEW
        .navigationViewStyle(StackNavigationViewStyle())
    } //: BODY
}



//MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

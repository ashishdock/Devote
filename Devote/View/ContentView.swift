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
    }
    
    
    //MARK: - BODY
    
    var body: some View {
        NavigationView {
            ZStack {
                //MARK: MAIN VIEW
                VStack{
                    //MARK: HEADER
                    
                    Spacer(minLength: 80)
                    //: NEW TASK ITEM
                    
                    Button {
                        showNewTaskItem = true
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
                                VStack(alignment: .leading) {
                                    Text(item.task ?? "")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                    
                                    //                                Text('Completion Status: \(item.completion ? "Complete" : "Pending")')
                                } //: VSTACK List Item
                            } label: { //Navigation link to the nextview after selecting a list item
                                VStack(alignment: .leading){
                                    Text(item.task ?? "")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Text(item.timestamp!, formatter: itemFormatter)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            } //Navigation link to the nextview after selecting a list item
                        } //: FOREACH - List all items
                        .onDelete(perform: deleteItems)
                    } //: LIST
                    .listStyle(InsetGroupedListStyle())
                    .shadow(color: .white.opacity(0.5), radius: 12)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                } //: VSTACK
                
                //: MARK NEW TASK ITEM
                if showNewTaskItem {
                    BlankView()
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                } //: TOOLBAR ITEM
            } //: VSTACK - TOOLBAR
            .background(BackgroundImageView()) // it's a png and will overlap the background gradient
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

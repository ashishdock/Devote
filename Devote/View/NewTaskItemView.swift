//
//  NewTaskItemView.swift
//  Devote
//
//  Created by Ashish Sharma on 01/02/2023.
//

import SwiftUI


struct NewTaskItemView: View {
    //MARK: - PROPERTIES
    @State var task: String = ""
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isShowing: Bool
    
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    //MARK: - FUNCTION
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.id = UUID()
            newItem.task = task
            newItem.completion = false

            do {
                try viewContext.save()
            } catch {
                
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            task = ""
            hideKeyboard()
            isShowing = false
        }
    }

    
    
    //MARK: - BODY
    
    var body: some View {
        VStack{
            Spacer()
            VStack(spacing: 16) {
                TextField("New Task", text: $task) // Saving the text field to task varibale
                    .foregroundColor(.pink)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .padding()
                    .background(
                        Color(UIColor.systemGray6)
                    )
                    .cornerRadius(10)
                
                Button {
                    addItem()
                } label: {
                    Spacer()
                    Text("SAVE")
                        .font(.system(size: 24, design: .rounded))
                        .foregroundColor(isButtonDisabled ? Color(UIColor.systemGray2) : .white)
                        .fontWeight(isButtonDisabled ? .light : .bold)
                    Spacer()
                }
                .disabled(isButtonDisabled)
                .padding()
                .font(.headline)
                .foregroundColor(.white)
                .background(isButtonDisabled ? Color.gray : Color.pink)
                .cornerRadius(10)
                
            } //: VSTACK - NEW TASK TEXT FIELD and BUTTON
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(
                Color.white
            )
            .cornerRadius(16)
            .shadow(color: .blue.opacity(0.65), radius: 24)
            .frame(maxWidth: 640)
        }//: VSTACK
        .padding()
    }
}


//MARK: - PREVIEW

struct NewTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskItemView(isShowing: .constant(true))
    }
}

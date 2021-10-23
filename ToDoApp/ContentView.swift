//
//  ContentView.swift
//  ToDoApp
//
//  Created by macbook on 2021/10/08.
//

import SwiftUI
import CoreData

var rowHeight: CGFloat = 50

struct ContentView: View {
    //var sampleTasks = ["Task One", "Task Two", "Task Three"]
    @State var newTaskTitle = ""
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: ToDoItems.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ToDoItems.createdAt, ascending: false)], predicate: NSPredicate(format: "taskDone = %d", false))
     var fetchedItems: FetchedResults<ToDoItems>
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView{
            List {
                ForEach(fetchedItems, id: \.self){ item in
                    HStack {
                        Text(item.taskTitle ?? "Empty")
                        Spacer()
                        Button(action: {self.markTaskAsDone(at: self.fetchedItems.firstIndex(of: item)!)}, label: {
                            Image(systemName: "circle")
                                .imageScale(.large)
                                .foregroundColor(.gray)
                        })
                    }
                }.frame(height: rowHeight)
                HStack {
                    TextField("Add task...", text:$newTaskTitle, onCommit:{self.saveTask()})
                    Button(action: {self.saveTask()}, label: {
                        Image(systemName: "plus").imageScale(.large)
                    })
                }.frame(height: rowHeight)
                NavigationLink(destination: TasksDone(), label: {
                    Text("Task done")
                        .frame(height: rowHeight)
                })
            }.navigationBarTitle(Text("To-Do"))
            .listStyle(GroupedListStyle())
        }
//        List {
//            ForEach(items) { item in
//                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//            }
//            .onDelete(perform: deleteItems)
//        }
//        .toolbar {
//            #if os(iOS)
//            EditButton()
//            #endif
//
//            Button(action: addItem) {
//                Label("Add Item", systemImage: "plus")
//            }
//        }
    }
    func saveTask() {
        guard self.newTaskTitle != "" else { return }
        let newToDoItem = ToDoItems(context: self.managedObjectContext)
        newToDoItem.taskTitle = self.newTaskTitle
        newToDoItem.createdAt = Date()
        newToDoItem.taskDone = false
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
        self.newTaskTitle = ""
    }
    
    func markTaskAsDone(at index: Int){
        let item = fetchedItems[index]
        item.taskDone = true
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }

//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}
//
//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}

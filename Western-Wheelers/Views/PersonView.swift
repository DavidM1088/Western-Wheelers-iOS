import SwiftUI
import Combine
import os.log
import CloudKit

struct PersonView: View {
    @ObservedObject var model = UserModel.userModel
    @State var recordId:CKRecord.ID
    @State var userForView:User?
    
//    var body1: some View {
//        NavigationView { //but creates yet more unwanted space at top of view
//        GeometryReader { geometry in
//        Text("TEST")
//        }
//        .alignmentGuide(HorizontalAlignment.center) { _ in  0 }
//        }
//    }
    
    var body: some View {
        NavigationView { //required but creates yet more unwanted space at top of view
            //Geo reader here seems to force everything left on the screen. Seems like a SwiftUI bug?
            //GeometryReader { geometry in
                VStack() {
                    if self.userForView != nil {
                        Text("\(self.userForView!.nameFirst!) \(self.userForView!.nameLast!)").font(.title)
                        if self.userForView!.picture != nil {
                            Image(uiImage: (self.userForView!.picture)!)
                            .resizable()
                            .scaledToFit()
                        }
                        ScrollView{
                            Text(self.userForView!.info ?? "")
                            .padding()
                            // for some unknwon reason must force width, otherwise profiles with no or minimal text left justify
                            //.frame(width: geometry.size.width * 0.95)
                        }
                    }
                    else {
                        VStack {
                            ActivityIndicator().frame(width: 50, height: 50)
                        }.foregroundColor(Color.blue)
                    }
                }
            //}
        }
        .onAppear() {
            self.userForView = nil
            self.model.fetchUser(recordId: self.recordId)
        }
        .onReceive(UserModel.userModel.$fetchedIDUser) {fetchedUser in
            if fetchedUser != nil {
                self.userForView = fetchedUser
            }
        }
    }
}


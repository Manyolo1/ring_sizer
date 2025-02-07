//
//  ContentView.swift
//  final_ring_sizer
//
//  Created by MANYA on 29/09/24.
import SwiftUI

// Model for storing ring sizes
struct RingSizeHistory: Identifiable {
    let id = UUID()
    let size: CGFloat
}

struct ContentView: View {
    @State private var showSettings = false
    var body: some View {
        NavigationView {
            RingSizerView(showSettings: $showSettings)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }
    }
}

struct HistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    var history: [RingSizeHistory]

    var body: some View {
        ZStack {
            VStack {
                Spacer() // To push content upwards
                
                if history.isEmpty {
                    Text("No results saved")
                        .font(.custom("Times New Roman", size: 18))
                        .padding(.bottom, 20) // Add some padding at the bottom
                } else {
                    List(history) { item in
                        Text("Ring Size : \(item.size, specifier: "%.2f") mm")
                            .font(.custom("Times New Roman", size: 18))
                    }
                }

                Spacer() // Push the content to the top
            }
            .background(Color.white)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("History")
                        .fontWeight(.bold)
                        .font(.custom("Times New Roman", size: 18))
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            })
        }
    }
}

struct RingSizerView: View {
    @State private var ringSize: CGFloat = 100
    @State private var showingResult = false
    @State private var history: [RingSizeHistory] = []
    @Binding var showSettings: Bool

    var body: some View {
        VStack(spacing: 20) {
            TopBarView(showSettings: $showSettings, history: $history)

            Spacer()

            Text("Put the ring on the circle")
                .font(.custom("Times New Roman", size: 18))
                .fontWeight(.bold)
                .padding(.bottom, 10)

            ZStack {
                AccurateGridShape(bold: false, borderColor: .clear)
                    .stroke(lineWidth: 0.05)
                    .overlay(
                        AccurateGridShape(bold: true, borderColor: .gray)
                            .stroke(Color.gray, lineWidth: 0.8)
                    )
                    .frame(width: 250, height: 250)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15))

                Circle()
                    .fill(Color.orange)
                    .frame(width: ringSize, height: ringSize)

                HStack {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 10, height: 10)
                        .foregroundColor(.black)

                    Spacer()

                    Image(systemName: "arrow.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 10, height: 10)
                        .foregroundColor(.black)
                }
                .frame(width: ringSize + 5)
            }

            Button(action: {
                showingResult = true
                // Save the ring size to history
                history.append(RingSizeHistory(size: ringSize))
            }) {
                Text("Get the ring size         ")
                    .font(.custom("Times New Roman", size: 18))
                    .fontWeight(.semibold)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(10)
            }

            CustomSlider(ringSize: $ringSize)

            BottomBarView()
        }
        .alert(isPresented: $showingResult) {
            Alert(title: Text("Ring Size"), message: Text("Your estimated ring size is \(ringSize) mm"), dismissButton: .default(Text("OK")))
        }
        .background(
            NavigationLink(destination: SettingsView(), isActive: $showSettings) {
                EmptyView()
            }
        )
        .background(
            NavigationLink(destination: FingerSizerView()) {
                EmptyView()
            }
        )
    }
}

struct TopBarView: View {
    @Binding var showSettings: Bool
    @Binding var history: [RingSizeHistory]

    var body: some View {
        HStack {
            Button(action: {
                showSettings = true
            }) {
                Image(systemName: "gearshape")
                    .foregroundColor(.black)
                    .frame(width: 40, height: 40)
                    .background(Circle().strokeBorder(Color.gray.opacity(0.5), lineWidth: 1))
            }

            Spacer()

            NavigationLink(destination: HistoryView(history: history)) {
                Image(systemName: "arrow.counterclockwise")
                    .foregroundColor(.black)
                    .frame(width: 40, height: 40)
                    .background(Circle().strokeBorder(Color.gray.opacity(0.5), lineWidth: 1))
            }

            Button(action: {
                // Info action
            }) {
                Image(systemName: "info.circle")
                    .foregroundColor(.black)
                    .frame(width: 40, height: 40)
                    .background(Circle().strokeBorder(Color.gray.opacity(0.5), lineWidth: 1))
            }
        }
        .padding()
        .background(Color.white)
    }
}


struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCountry = "JAPAN"
    @State private var showCountryPicker = false
    @State private var showManagingSubscriptions = false
    @State private var showContactUs = false

    let countries = ["JAPAN", "USA", "SAUDI ARABIA", "UNITED KINGDOM", "AUSTRALIA", "CANADA", "MEXICO", "ITALY", "SWITZERLAND", "INDIA", "NEW ZEALAND", "SPAIN", "NETHERLANDS", "SOUTH AMERICA", "CHINA", "IRELAND", "OTHER (Millimeters)"]
    

    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                showCountryPicker = true
            }) {
                HStack {
                    Text(selectedCountry)
                        .font(.custom("Times New Roman", size: 18))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
            }
            .background(Color.white)
            .foregroundColor(.black)
            
            Divider().background(Color.orange)
            
            Button(action: {
                showManagingSubscriptions = true
            }) {
                HStack {
                    Text("Managing Subscriptions")
                        .font(.custom("Times New Roman", size: 18))
                    Spacer()
                }
                .foregroundColor(.black)
                .padding()
            }
            .background(Color.white)
            
            Divider().background(Color.orange)
            
            Button(action: {
                showContactUs = true
            }) {
                HStack {
                    Text("Contact Us")
                        .font(.custom("Times New Roman", size: 18))
                    Spacer()
                }
                .foregroundColor(.black)
                .padding()
            }
            .background(Color.white)
            
            Divider().background(Color.orange)
            
            Button(action: {
                // Action for Privacy Policy
            }) {
                HStack {
                    Text("Privacy Policy")
                        .font(.custom("Times New Roman", size: 18))
                    Spacer()
                }
                .foregroundColor(.black)
                .padding()
            }
            .background(Color.white)
            
            Divider().background(Color.orange)
            
            Button(action: {
                // Action for Terms of Use
            }) {
                HStack {
                    Text("Terms of Use")
                        .font(.custom("Times New Roman", size: 18))
                    Spacer()
                }
                .foregroundColor(.black)
                .padding()
            }
            .background(Color.white)
            
            Spacer()
        }
        .background(Color.white)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Settings")
                    .fontWeight(.bold)
                    .font(.custom("Times New Roman", size: 18))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
        })
        .sheet(isPresented: $showCountryPicker) {
            CountryPickerView(selectedCountry: $selectedCountry, isPresented: $showCountryPicker)
        }
        .background(
            NavigationLink(destination: ManagingSubscriptionsView(), isActive: $showManagingSubscriptions) {
                EmptyView()
            }
        )
        .background(
            NavigationLink(destination: ContactUsView(), isActive: $showContactUs) {
                EmptyView()
            }
        )
    }
}

struct ManagingSubscriptionsView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Spacer()
        VStack(spacing: 16) {
            ForEach(["How do i view my subscription?", "How do i cancel my subscription?", "How do I request a refund?"], id: \.self) { question in
                DisclosureGroup {
                    Text(contentFor(question))
                        .padding()
                        .font(.custom("Times New Roman", size: 16))
                } label: {
                    Text(question)
                        .font(.custom("Times New Roman", size: 18))
                        .foregroundColor(.black)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 1))
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Managing Subscriptions")
                    .fontWeight(.bold)
                    .font(.custom("Times New Roman", size: 18))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
        })
    }
    
    func contentFor(_ question: String) -> AttributedString {
        var content: AttributedString
        switch question {
        case "How do i view my subscription?":
            content = AttributedString("If you have an active subscription within the app, you can restore it. To do that, follow these steps:\n1. Open the Rings Sizer app on your device.\n2. Tap the Settings button in the top-left corner.\n3. Tap Restore Purchases.\n4. You may needed to enter your Apple ID and password OR sign in to the Rings Sizer account where the Pro Subscription was purchased.")
        case "How do i cancel my subscription?":
            content = AttributedString("You can cancel your Rings Sizer subscription anytime. To do that, follow these steps:\n1. Go to the App Store, then tap on your profile icon.\n2. Down below you will see Purchased and Subscriptions, tap on this last one.\n3. Click on Rings Sizer PRO.\n4. Tap on Cancel Subscription")
        case "How do I request a refund?":
            content = AttributedString("Please note that the app team does not participate in the refund process and you will have to appeal to Apple. You can request a refund using any device. To do that, follow these steps:\n1. Sign in to http://reportaproblem.apple.com\n2. Tap or click \"I would like to,\" then choose \"Request a refund\".\n3. Choose the reason why you want a refund, then choose Next.\n4. Choose the Rings Sizer PRO subscription, then choose Submit.")
        default:
            content = AttributedString("")
        }
        content.foregroundColor = Color(red: 0.4, green: 0.4, blue: 0.4)
        return content
    }
}


struct ContactUsView: View {
    @State private var selectedReason = "Select reason"
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @Environment(\.dismiss) var dismiss
    
    let reasons = ["How to Manage Your Subscription", "How to Cancel Your Subscription", "How to Refund Your Subscription", "Questions About the App"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Type of inquiry")
                .font(.headline)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            Menu {
                ForEach(reasons, id: \.self) { reason in
                    Button(reason) {
                        selectedReason = reason
                    }
                }
            } label: {
                HStack {
                    Text(selectedReason)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.black)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.orange, lineWidth: 1)
                )
            }
            
            Text("User")
                .font(.custom("Times New Roman", size: 18))
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.headline)
            
            TextField("Name", text: $name)
                .font(.custom("Times New Roman", size: 18))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.orange, lineWidth: 1)
                )
            
            TextField("Email", text: $email)
                .font(.custom("Times New Roman", size: 18))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.orange, lineWidth: 1)
                )
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $message)
                    .frame(height: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.orange, lineWidth: 1)
                    )
                if message.isEmpty {
                    Text("Your message to our team")
                        .font(.custom("Times New Roman", size: 18))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 8)
                }
            }
            
            Button(action: {
                // Handle send action
            }) {
                Text("Send")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.midnightBlue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Contact Us")
                    .fontWeight(.bold)
                    .font(.custom("Times New Roman", size: 18))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
        })
    }
}

extension Color {
    static let midnightBlue = Color(red: 0.15, green: 0.15, blue: 0.2)
}
struct CountryPickerView: View {
    @Binding var selectedCountry: String
    @Binding var isPresented: Bool
    
    let countries = ["USA", "SAUDI ARABIA", "UNITED KINGDOM", "AUSTRALIA", "CANADA", "MEXICO", "JAPAN","ITALY", "SWITZERLAND", "INDIA", "NEW ZEALAND", "SPAIN", "NETHERLANDS", "SOUTH AMERICA", "CHINA", "IRELAND", "OTHER (Millimeters)"]

    var body: some View {
        NavigationView {
            List {
                ForEach(countries, id: \.self) { country in
                    Button(action: {
                        selectedCountry = country
                        isPresented = false
                    }) {
                        Text(country)
                            .font(.custom("Times New Roman", size: 18))
                            .foregroundColor(country == selectedCountry ? .blue : .black)
                    }
                }
            }
            
        }
        .presentationDetents([.medium, .large])
    }
}

struct CustomSlider: View {
    @Binding var ringSize: CGFloat

    var body: some View {
        VStack {
            Text("Use the slider to choose the size")
                .font(.custom("Times New Roman", size: 18))
                .fontWeight(.bold)
                .padding(.bottom, 20)

            ZStack(alignment: .bottom) {
                HStack(spacing: 2.5) {
                    Spacer()

                    ForEach(0..<20) { tick in
                        Rectangle()
                            .fill(tick % 2 == 0 ? Color.gray : Color.gray)
                            .frame(width: 1, height: tick % 2 == 0 ? 20 : 10)
                        Spacer()
                    }

                    Spacer()
                }
                .frame(height: 20)

                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.orange)
                    .frame(width: 4, height: 35)
                    .offset(x: valueToPosition(value: ringSize), y: 0)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let newValue = positionToValue(position: gesture.location.x)
                                if newValue >= 30 && newValue <= 150 {
                                    ringSize = newValue
                                }
                            }
                    )
            }
            .frame(height: 40)
            .padding(.horizontal, 30)

            HStack {
                Button(action: {
                    ringSize = max(20, ringSize - 0.5)
                }) {
                    Text("-")
                        .font(.title)
                        .foregroundColor(.black)
                        .frame(width: 50, height: 50)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 0.5))
                }

                Text("Fine-tune")
                    .font(.custom("Times New Roman", size: 18))
                    .padding(.horizontal, 20)

                Button(action: {
                    ringSize = min(200, ringSize + 0.5)
                }) {
                    Text("+")
                        .font(.title)
                        .foregroundColor(.black)
                        .frame(width: 50, height: 50)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 0.5))
                }
            }
            .padding(.top, 20)
        }
    }

    func valueToPosition(value: CGFloat) -> CGFloat {
        let totalWidth: CGFloat = 250
        return (value - 20) * (totalWidth / 180) - totalWidth / 2
    }

    func positionToValue(position: CGFloat) -> CGFloat {
        let totalWidth: CGFloat = 250
        return (position + totalWidth / 2) / (totalWidth / 180) + 20
    }
}

struct BottomBarView: View {
    @State private var showFingerSizer = false
    
    var body: some View {
        Spacer()

        Spacer()
        HStack {
            Spacer()
            
            Spacer()
        }
        .padding()
    }
}

struct AccurateGridShape: Shape {
    var bold: Bool = false
    var borderColor: Color = .clear

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let numberOfLargeLines = 3
        let largeGridSize = rect.width / CGFloat(numberOfLargeLines)

        let numberOfSmallLines = 10
        let smallGridSize = largeGridSize / CGFloat(numberOfSmallLines)

        for i in 0..<numberOfLargeLines {
            let position = largeGridSize * CGFloat(i + 1)

            if bold {
                path.move(to: CGPoint(x: position, y: rect.minY))
                path.addLine(to: CGPoint(x: position, y: rect.maxY))

                path.move(to: CGPoint(x: rect.minX, y: position))
                path.addLine(to: CGPoint(x: rect.maxX, y: position))
            }
            else {
                for j in 0..<numberOfSmallLines {
                    let smallPosition = smallGridSize * CGFloat(j + 1)

                    path.move(to: CGPoint(x: largeGridSize * CGFloat(i) + smallPosition, y: 0))
                    path.addLine(to: CGPoint(x: largeGridSize * CGFloat(i) + smallPosition, y: rect.height))

                    path.move(to: CGPoint(x: 0, y: largeGridSize * CGFloat(i) + smallPosition))
                    path.addLine(to: CGPoint(x: rect.width, y: largeGridSize * CGFloat(i) + smallPosition))
                }
            }
        }

        if bold {
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        }

        return path
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct FingerSizerView: View {
    @State private var fingerSize: CGFloat = 100
    @State private var showingResult = false
    @State private var isSliderOnLeft = true
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 20) {
                Text("Determine ring size by\nfinger width")
                    .font(.custom("Times New Roman", size: 28))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Place your finger and adjust the slider to match its size")
                    .font(.custom("Times New Roman", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
            }
            .padding(.top, 50)
            .padding(.bottom, 30)
            
            Button(action: {
                showingResult = true
            }) {
                Text("Get the ring size")
                    .font(.custom("Times New Roman", size: 18))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: 200)
                    .background(Color(UIColor.darkText))
                    .cornerRadius(10)
            }
            .padding(.bottom, 10)
            
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    if isSliderOnLeft {
                        sliderAndButtons(geometry: geometry)
                            .frame(width: geometry.size.width * 0.2)
                        Spacer()
                    } else {
                        Spacer().frame(width: geometry.size.width * 0.2)
                    }
                    
                    // Finger representation (moved slightly to the right)
                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray.opacity(0.4))
                            .frame(height: geometry.size.height * 1.4)
                            .frame(width: geometry.size.width * 0.5)
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.orange)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .inset(by: 8)
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(height: 100)
                                    .offset(y: -geometry.size.height * 0.65)
                            )
                            .frame(width: fingerSize, height: geometry.size.height * 1.6)
                            .offset(y: geometry.size.height * 0.3)
                    }
                    .frame(width: geometry.size.width * 0.6)
                    .clipped()
                    
                    if !isSliderOnLeft {
                        Spacer()
                        sliderAndButtons(geometry: geometry)
                            .frame(width: geometry.size.width * 0.2)
                    } else {
                        Spacer().frame(width: geometry.size.width * 0.2)
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.height * 0.4)
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
        })
        .navigationBarItems(trailing: HStack(spacing: 15) {
            //Button(action: {}) {
             //   Text("3D")
              //      .foregroundColor(.black)
                //    .font(.custom("Times New Roman", size: 16))
                  //  .padding(8)
                    //.background(Circle().stroke(Color.gray, lineWidth: 1))
            //}
            Button(action: {
                isSliderOnLeft.toggle()
            }) {
                Image(systemName: "hand.raised")
                    .padding(8)
                    .foregroundColor(.black)
                    .background(Circle().stroke(Color.gray, lineWidth: 1))
            }
            Button(action: {}) {
                Image(systemName: "info.circle")
                    .padding(8)
                    .foregroundColor(.black)
                    .background(Circle().stroke(Color.gray, lineWidth: 1))
            }
        })
        .alert(isPresented: $showingResult) {
            Alert(title: Text("Ring Size"), message: Text("Your estimated ring size is \(calculateRingSize())"), dismissButton: .default(Text("OK")))
        }
    }
    
    private func sliderAndButtons(geometry: GeometryProxy) -> some View {
        VStack {
            DialSlider(value: $fingerSize, bounds: 50...geometry.size.width * 0.4)
                .frame(width: 30, height: geometry.size.height * 0.35)
                .offset(y: -geometry.size.height * 0.4)
            
            VStack {
                Button(action: { fingerSize = min(fingerSize + 5, geometry.size.width * 0.4) }) {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .frame(width: 30, height: 30)
                        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                }
                Button(action: { fingerSize = max(fingerSize - 5, 50) }) {
                    Image(systemName: "minus")
                        .foregroundColor(.black)
                        .frame(width: 30, height: 30)
                        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                }
            }
        }
    }
    
    func calculateRingSize() -> String {
        let size = Int(fingerSize / 10)
        return "\(size)"
    }
}

struct DialSlider: View {
    @Binding var value: CGFloat
    let bounds: ClosedRange<CGFloat>
    let majorTickCount: Int = 10
    let minorTicksPerMajor: Int = 5
    
    private var step: CGFloat {
        return (bounds.upperBound - bounds.lowerBound) / CGFloat(majorTickCount * minorTicksPerMajor)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // Dial scale
                VStack(spacing: 0) {
                    ForEach(0..<(majorTickCount * minorTicksPerMajor * 2), id: \.self) { index in
                        HStack {
                            if index % minorTicksPerMajor == 0 {
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 13, height: 2)
                                Spacer()
                            } else {
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 8, height: 1)
                                Spacer()
                            }
                        }
                        Spacer()
                    }
                }
                .frame(height: geometry.size.height * 2)
                .offset(y: -geometry.size.height * (value - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound))
                
                // Center line
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.orange)
                    .frame(width: geometry.size.width, height: 3)
                    .offset(y: geometry.size.height / 1)
                
                // Invisible drag area
                Color.clear
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                let dragPercentage = 1 - (gesture.location.y / geometry.size.height)
                                let newValue = bounds.lowerBound + (bounds.upperBound - bounds.lowerBound) * dragPercentage
                                value = min(max(newValue, bounds.lowerBound), bounds.upperBound)
                            }
                    )
            }
            .clipped()
        }
    }
}

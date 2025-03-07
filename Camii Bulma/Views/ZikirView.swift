import SwiftUI

struct ZikirView: View {
    @StateObject private var viewModel = ZikirViewModel()
    @State private var showingNameInput = false
    @State private var showingRecords = false
    @State private var showingTargetInput = false
    @AppStorage("zikirTarget") private var zikirTarget = 33
    @State private var selectedDhikr = DhikrType.commonDhikrs[0]
    
    var body: some View {
        ZStack {
            AppTheme.gradientBackground
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("\(viewModel.count)")
                    .font(.system(size: 120, weight: .bold))
                    .foregroundColor(.white)
                
                if zikirTarget > 0 {
                    Text("Hedef: \(zikirTarget)")
                        .font(.title2)
                        .foregroundColor(.white)
                        .opacity(0.8)
                }
                
                Spacer()
                
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        Button(action: {
                            viewModel.reset()
                        }) {
                            Text("Sıfırla")
                                .foregroundColor(.white)
                                .frame(width: 60)
                                .padding()
                                .background(AppTheme.cardBackground)
                                .cornerRadius(15)
                        }
                        
                        Button(action: {
                            showingTargetInput = true
                        }) {
                            Text("Hedef")
                                .foregroundColor(.white)
                                .frame(width: 60)
                                .padding()
                                .background(AppTheme.cardBackground)
                                .cornerRadius(15)
                        }
                        
                        Button(action: {
                            viewModel.startRecording(
                                name: selectedDhikr.turkish,
                                arabic: selectedDhikr.arabic,
                                target: zikirTarget
                            )
                        }) {
                            Text("Kaydet")
                                .foregroundColor(.white)
                                .frame(width: 60)
                                .padding()
                                .background(AppTheme.cardBackground)
                                .cornerRadius(15)
                        }
                        
                        Button(action: {
                            showingRecords = true
                        }) {
                            Text("Kayıtlar")
                                .foregroundColor(.white)
                                .frame(width: 60)
                                .padding()
                                .background(AppTheme.cardBackground)
                                .cornerRadius(15)
                        }
                    }
                    
                    Button(action: {
                        viewModel.increment()
                        if viewModel.count == zikirTarget {
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                        }
                    }) {
                        Circle()
                            .fill(AppTheme.cardBackground)
                            .frame(width: 120, height: 120)
                            .overlay(
                                Image(systemName: "hand.point.up.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            )
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .sheet(isPresented: $showingRecords) {
            NavigationView {
                ZStack {
                    AppTheme.gradientBackground
                        .ignoresSafeArea()
                    
                    VStack {
                        Text("Toplam Zikir: \(viewModel.statistics.totalCount)")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(AppTheme.cardBackground.opacity(0.3))
                            .cornerRadius(15)
                            .padding()
                        
                        List {
                            ForEach(viewModel.records) { record in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(record.name)
                                        .font(.headline)
                                    
                                    HStack {
                                        Text("\(record.count) zikir")
                                        Spacer()
                                        Text(record.date, style: .date)
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .listStyle(InsetGroupedListStyle())
                    }
                }
                .navigationTitle("Zikir Kayıtları")
                .navigationBarItems(trailing: Button("Kapat") {
                    showingRecords = false
                })
            }
        }
        .sheet(isPresented: $showingTargetInput) {
            NavigationView {
                ZStack {
                    AppTheme.gradientBackground
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        TextField("Hedef Sayı", text: .constant("\(zikirTarget)"))
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Button("Kaydet") {
                            showingTargetInput = false
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(AppTheme.cardBackground)
                        .cornerRadius(10)
                    }
                    .padding()
                }
                .navigationTitle("Hedef Belirle")
                .navigationBarItems(trailing: Button("İptal") {
                    showingTargetInput = false
                })
            }
        }
    }
}

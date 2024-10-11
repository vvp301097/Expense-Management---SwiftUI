//
//  Recents.swift
//  Expense Management
//
//  Created by Phat Vuong Vinh on 11/10/24.
//

import SwiftUI

struct RecentsView: View {
    
    // User property
    @AppStorage("userName") var userName: String = ""
    
    // View property
    @State var startDate = Date().startOfMonth
    @State var endDate = Date().endOfMonth
    @State var selectedCategory: Category = .income
    
    // For animation
    @Namespace private var animation
    
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            NavigationStack {
                ScrollView {
                    LazyVStack(spacing: 8, pinnedViews: [.sectionHeaders]) {
                        Section {
                            // Date Filter Button
                            
                            Button {
                                
                            } label: {
                                Text("\(startDate.format("dd MMM yy")) - \(endDate.format("dd MMM yy" ))")
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                            }
                            .hSpacing(.leading)
                            
                            
                            // Card view
                            
                            CardView(income: 12345, expense: 2222)
                            
                            
                            //
                            CustomSegmentControl()
                                .padding(.bottom, 8)
                            
                            
                            //
                            
                            ForEach(sampleTransactions.filter({ $0.category == selectedCategory }), id: \.id) { transaction in
                                TransactionCardView(transaction: transaction)
                            }
                            
                            
                        } header: {
                            HeaderView(size)
                        }
                    }
                    .padding(16)
                }
                .background(.gray.opacity(0.15))

            }
        }
    }
    
    @ViewBuilder
    func HeaderView(_ size: CGSize) -> some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome!")
                    .font(.title.bold())
                
                if !userName.isEmpty {
                    Text(userName)
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            }
            .visualEffect { content, geometryProxy in
                content
                    .scaleEffect(headerScale(size, proxy: geometryProxy), anchor: .topLeading)
            }
            
            Spacer()
            
            NavigationLink {
                
            } label: {
                Image(systemName: "plus")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 45, height: 45)
                    .background(appTint.gradient)
                    .clipShape(Circle())
                
            }

        }
        
        .hSpacing(.leading)
        .padding(.bottom, userName.isEmpty ? 8 : 4)
        .background {
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.ultraThinMaterial)
                Divider()
            }
            .visualEffect({ content, geometryProxy in
                content
                    .opacity(headerBGOpacity(geometryProxy))
            })
            .padding(.horizontal, -16)
            .padding(.top, -(safeArea.top + 16))
            
        }
    }
    
    
    @ViewBuilder
    func CustomSegmentControl() -> some View {
        HStack(spacing: 0) {
            ForEach(Category.allCases, id: \.rawValue) { category in
                Text(category.rawValue)
                    .hSpacing()
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background {
                        if category == selectedCategory {
                            Capsule()
                                .fill(.background)
                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                        }
                    }
                    .contentShape(.capsule)
                    .onTapGesture {
                        withAnimation {
                            selectedCategory = category

                        }
                    }
            }
        }
        .background(.gray.opacity(0.15), in: .capsule)
        .padding(.top,4)
        
        
    }
    
    nonisolated func headerScale(_ size: CGSize, proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        
        let screenHeight = size.height
        
        let progress = minY / screenHeight
        
        let scale = (min(max(progress, 0), 1)) * 0.6
        return 1 + scale
    }
    
    nonisolated func headerBGOpacity(_ proxy: GeometryProxy) -> Double {
        let minY = proxy.frame(in: .scrollView).minY + safeArea.top
        
        return minY > 0 ? 0 : (-minY / 15)
        
    }
}

#Preview {
    ContentView()
}

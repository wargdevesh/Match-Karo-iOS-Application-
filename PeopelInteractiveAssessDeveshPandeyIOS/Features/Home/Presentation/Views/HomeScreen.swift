import SwiftUI
import UIKit

struct HomeScreen: View {
    @StateObject var viewModel: HomeScreenViewModel
    @State private var currentContentOffset: CGPoint = .zero
    @State private var savedPaginationOffset: CGPoint?
    @State private var pagingScrollView: UIScrollView?

    var body: some View {
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(spacing: 18) {
                    if viewModel.isLoading && viewModel.dbUsers.isEmpty {
                        ProgressView()
                            .padding(.top, 40)
                    }
                    
                    if let errorMessage = viewModel.errorMessage, viewModel.dbUsers.isEmpty  {
                        ZStack(alignment: .center) {
                            VStack {
                                Spacer()
                                Text(errorMessage)
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 24)
                                    .padding(.top, 24)
                                
                                Image("noInternet")
                                    .resizable()
                                    .frame(width: 300, height: 300)
                                    .clipShape(RoundedRectangle(cornerRadius: 12.0, style: .continuous))
                                Button {
                                    viewModel.getMoreData()
                                } label: {
                                        
                                        Text("Retry")
                                        .underline(color: .white)
                                        .font(.title3)
                                        .foregroundStyle(.white)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 24)
                                        .padding(.top, 24)
                                }

                                
                                Spacer()
                                
                            }
                        }
                        
                    }
                    
                    ForEach(Array(viewModel.dbUsers).enumerated(),id: \.element.id) { index,user in
                        HomeUserCardView(user: user) {
                            savedPaginationOffset = currentContentOffset
                            viewModel.changeStatus(status: .accepted, user: user)
                        } onDeclineTap: {
                            savedPaginationOffset = currentContentOffset
                            viewModel.changeStatus(status: .declined, user: user)
                            
                        }
                        .onAppear {
                            if index == viewModel.dbUsers.count - 3 {
                                savedPaginationOffset = currentContentOffset
                                viewModel.getMoreData()
                            }
                        }
                        
                        //                    HomeUserCardView(user: user)
                        //                        .padding(.horizontal, 12)
                        //                        .padding(.vertical, 12)
                    }
                    
                    if viewModel.isLoading && !viewModel.dbUsers.isEmpty {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                            .padding(.vertical, 24)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
            }
            .background(Color(.black))
            .background(
                ScrollViewOffsetObserver(
                    scrollView: $pagingScrollView,
                    contentOffset: $currentContentOffset
                )
            )
            .task {
                await viewModel.fetchUsers()
            }
            .onChange(of: viewModel.dbUsers) { _ in
                restorePaginationOffset()
            }
            .onChange(of: viewModel.isLoading) { isLoading in
                if !isLoading {
                    restorePaginationOffset()
                }
            }
            .preferredColorScheme(.dark)
        
        
    }

    private func restorePaginationOffset() {
        guard let savedPaginationOffset,
              let pagingScrollView else {
            return
        }

        DispatchQueue.main.async {
            DispatchQueue.main.async {
                let minimumY = -pagingScrollView.adjustedContentInset.top
                let maximumY = max(
                    minimumY,
                    pagingScrollView.contentSize.height - pagingScrollView.bounds.height + pagingScrollView.adjustedContentInset.bottom
                )
                let restoredOffset = CGPoint(
                    x: savedPaginationOffset.x,
                    y: min(max(savedPaginationOffset.y, minimumY), maximumY)
                )

                pagingScrollView.setContentOffset(restoredOffset, animated: false)
                self.savedPaginationOffset = nil
            }
        }
    }
}

private struct ScrollViewOffsetObserver: UIViewRepresentable {
    @Binding var scrollView: UIScrollView?
    @Binding var contentOffset: CGPoint

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIView {
        UIView(frame: .zero)
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.parent = self

        DispatchQueue.main.async {
            guard let scrollView = uiView.enclosingScrollView else {
                return
            }

            context.coordinator.observe(scrollView)
            self.scrollView = scrollView
            self.contentOffset = scrollView.contentOffset
        }
    }

    final class Coordinator {
        var parent: ScrollViewOffsetObserver
        private weak var observedScrollView: UIScrollView?
        private var contentOffsetObservation: NSKeyValueObservation?

        init(parent: ScrollViewOffsetObserver) {
            self.parent = parent
        }

        func observe(_ scrollView: UIScrollView) {
            guard observedScrollView !== scrollView else {
                return
            }

            observedScrollView = scrollView
            contentOffsetObservation = scrollView.observe(
                \.contentOffset,
                 options: [.new]
            ) { [weak self] scrollView, _ in
                DispatchQueue.main.async {
                    self?.parent.contentOffset = scrollView.contentOffset
                }
            }
        }
    }
}

private extension UIView {
    var enclosingScrollView: UIScrollView? {
        if let scrollView = superview as? UIScrollView {
            return scrollView
        }

        return superview?.enclosingScrollView
    }
}

//#Preview {
//    HomeScreen(viewModel: HomeScreenViewModel(networkManager: HomeNetworkManager()))
//}

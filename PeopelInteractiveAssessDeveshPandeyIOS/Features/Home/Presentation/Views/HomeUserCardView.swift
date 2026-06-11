import SwiftUI
import SDWebImageSwiftUI

struct HomeUserCardView: View {
    let user: ProfileModel
    let onAcceptTap: () -> Void
    let onDeclineTap: () -> Void

    private var displayName: String {
        "\(user.age),\(user.name)"
    }

    private var streetAddress: String {
        user.address
    }

    var body: some View {
        VStack {
            ZStack(alignment: .bottomLeading) {
                
                    WebImage(url: URL(string:user.image)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            .padding(.horizontal,16)
                            .padding(.bottom,12)
                            .padding(.top, 20)
                    } placeholder: {
                        Image("profile")
                            .resizable()
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .padding(.horizontal,16)
                            .padding(.vertical,12)
                        //Rectangle().foregroundColor(.gray)
                    }
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    
               // .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                
                LinearGradient(
                    colors: [.clear, .black.opacity(0.82)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .padding(.horizontal, 16)
                .padding(.bottom, 12)

                VStack(alignment: .leading, spacing: 8) {
                    Text(displayName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.75)
             
                    HStack {
                        Image(systemName: "location.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .scaledToFill()
                            .foregroundStyle(.pink.opacity(0.95))
                        
                        Text(streetAddress)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.pink.opacity(0.95))
                            .lineLimit(2)
                    }
                    .padding(.bottom, 5)
//                    Label(streetAddress, systemImage: "mappin.circle.fill")
//                        .font(.system(size: 16, weight: .semibold))
//                        .foregroundStyle(.pink.opacity(0.95))
//                        .lineLimit(2)
                }
                .padding(24)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            
            getBottomView(cases: user.status)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14.0, style: .continuous))
        .shadow(color: .black.opacity(0.18), radius: 12, x: 0, y: 8)
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.2), lineWidth: 2)
        )
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
    }
    
    @ViewBuilder
    func getBottomView(cases: ProfileStatus) -> some View {
        switch cases {
        case .none:
            HStack(spacing: 36) {
                CardActionButton(systemImageName: "xmark", backgroundColor: .red){
                    onDeclineTap()
                }
                CardActionButton(systemImageName: "checkmark", backgroundColor: .green){
                    onAcceptTap()
                }
            }
            .padding(.horizontal,15)
            .padding(.bottom,20)
            
        case .accepted:
            HStack {
              Spacer()
                Text("Accepted")
                    .padding()
              Spacer()
            }
            .background(.green)
            .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .continuous))
            .padding(.horizontal,15)
            .padding(.bottom,20)
        case .declined:
            HStack {
              Spacer()
                Text("Declined")
                    .padding()
              Spacer()
            }
            .background(.red)
            .clipShape(RoundedRectangle(cornerRadius: 15.0, style: .continuous))
            .padding(.horizontal,15)
            .padding(.bottom,20)
        }
    }
}

private struct CardActionButton: View {
    let systemImageName: String
    let backgroundColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: {
            onTap()
        }) {
            Image(systemName: systemImageName)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 78, height: 78)
                .background(backgroundColor)
                .clipShape(Circle())
                .shadow(color: backgroundColor.opacity(0.35), radius: 6, x: 0, y: 4)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(systemImageName == "xmark" ? "Dismiss user" : "Accept user")
    }
}

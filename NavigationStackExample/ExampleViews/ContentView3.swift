import NavigationStack
import SwiftUI

struct ContentView3: View {
	static let navigationName = String(describing: Self.self)

	@EnvironmentObject var navigationModel: NavigationModel

	// Freezes the state of `navigationModel.isAlternativeViewShowing("ContentView2")` to prevent transition animation glitches.
	let isView2Showing: Bool

	var body: some View {
		NavigationStackView(ContentView3.navigationName) {
			HStack {
				VStack(alignment: .leading, spacing: 20) {
					Text(ContentView3.navigationName)

					// It's safe to query the `hasAlternativeViewShowing` state from the model, because it will be frozen by the button view.
					// However, to be safe we could also just pass `true` because View3 is not the root view.
					DismissTopContentButton(hasAlternativeViewShowing: navigationModel.hasAlternativeViewShowing)

					Group {
						Button(action: {
							// Example of the shortcut pop transition, which is a move transition.
							navigationModel.popContent(ContentView1.navigationName)
						}, label: {
							Text("Pop to root (View 1)")
						})

						// Using isAlternativeViewShowing from the model to show different sub-views will lead to animation glitches,
						// therefore use the frozen `isView2Showing` value.
						// if navigationModel.isAlternativeViewShowing("ContentView2") {
						if isView2Showing {
							Button(action: {
								navigationModel.popContent(ContentView2.navigationName)
							}, label: {
								Text("Pop to View 2 (w/ animation)")
							})
						}

						Button(action: {
							// Example of a simple hide transition without animation.
							navigationModel.hideView(ContentView2.navigationName)
						}, label: {
							// Using isAlternativeViewShowing from the model to show different sub-views will lead to animation glitches,
							// therefore use the frozen `isView2Showing` value.
							// if navigationModel.isAlternativeViewShowing("ContentView2") {
							if isView2Showing {
								Text("Pop to View 2 (w/o animation)")
							} else {
								Text("Pop to View 2 (not available)")
							}
						})

						Button(action: {
							navigationModel.presentContent(ContentView3.navigationName) {
								ContentView4(isPresented: navigationModel.viewShowingBinding(ContentView3.navigationName))
							}
						}, label: {
							Text("Present View 4")
						})
					}

					Spacer()
				}
				Spacer()
			}
			.padding()
			.background(Color.orange.opacity(0.3))
		}
	}
}

struct ContentView3_Previews: PreviewProvider {
	static var previews: some View {
		ContentView3(isView2Showing: true)
			.environmentObject(NavigationModel())
	}
}

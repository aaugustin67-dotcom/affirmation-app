import SwiftUI
import UserNotifications
// import GoogleMobileAds // when you add AdMob later

// Model definitions
struct Affirmation: Identifiable {
let id = UUID()
let text: String
let category: Category
}

enum Category: String, CaseIterable, Identifiable {
case beauty = "Beauty"
case health = "Health"
case success = "Success"
case love = "Love"
case confidence = "Confidence"

var id: String { rawValue }

// Color associated with each category
var color: Color {
switch self {
case .beauty: return Color(.systemPink).opacity(0.7)
case .health: return Color(.systemGreen).opacity(0.7)
case .success: return Color(.systemOrange).opacity(0.7)
case .love: return Color(.systemRed).opacity(0.7)
case .confidence: return Color(.systemPurple).opacity(0.7)
}
}

var emoji: String {
switch self {
case .beauty: return "🌸"
case .health: return "💚"
case .success: return "⭐"
case .love: return "💕"
case .confidence: return "🦋"
}
}
}

// Custom color theme
extension Color {
static let calmBlue = Color(red: 0.85, green: 0.93, blue: 1.0)
static let softPurple = Color(red: 0.92, green: 0.88, blue: 1.0)
static let gentleGreen = Color(red: 0.88, green: 0.96, blue: 0.90)
static let warmPeach = Color(red: 1.0, green: 0.94, blue: 0.88)
static let lightLavender = Color(red: 0.95, green: 0.92, blue: 0.98)
static let softMint = Color(red: 0.90, green: 0.98, blue: 0.92)

static let primaryAccent = Color(red: 0.4, green: 0.6, blue: 0.9)
static let secondaryAccent = Color(red: 0.6, green: 0.4, blue: 0.8)
}

struct IntervalOption: Identifiable {
let id = UUID()
let label: String
let minutes: Int
}

struct ContentView: View {
// Interval options in minutes
private let intervals: [IntervalOption] = [
IntervalOption(label: "1m", minutes: 1),
IntervalOption(label: "5m", minutes: 5),
IntervalOption(label: "10m", minutes: 10),
IntervalOption(label: "15m", minutes: 15),
IntervalOption(label: "30m", minutes: 30),
IntervalOption(label: "1h", minutes: 60),
IntervalOption(label: "2h", minutes: 120),
IntervalOption(label: "4h", minutes: 240),
IntervalOption(label: "8h", minutes: 480),
IntervalOption(label: "12h", minutes: 720),
IntervalOption(label: "24h", minutes: 1440)
]

@State private var affirmations: [Affirmation] = [
// Beauty affirmations
Affirmation(text: "I am beautiful inside and out", category: .beauty),
Affirmation(text: "I radiate confidence and grace", category: .beauty),
Affirmation(text: "My uniqueness makes me beautiful", category: .beauty),
Affirmation(text: "I embrace my natural beauty", category: .beauty),

// Health affirmations
Affirmation(text: "My body is strong and healthy", category: .health),
Affirmation(text: "I nourish my body with healthy choices", category: .health),
Affirmation(text: "Every day I grow stronger", category: .health),
Affirmation(text: "I am grateful for my body's wisdom", category: .health),

// Success affirmations
Affirmation(text: "I am capable of achieving my goals", category: .success),
Affirmation(text: "Success flows to me naturally", category: .success),
Affirmation(text: "I create opportunities for myself", category: .success),
Affirmation(text: "Every challenge makes me stronger", category: .success),

// Love affirmations
Affirmation(text: "I am worthy of love and happiness", category: .love),
Affirmation(text: "Love surrounds me everywhere", category: .love),
Affirmation(text: "I attract loving relationships", category: .love),
Affirmation(text: "I love and accept myself completely", category: .love),

// Confidence affirmations
Affirmation(text: "I believe in myself and my abilities", category: .confidence),
Affirmation(text: "I am confident in my decisions", category: .confidence),
Affirmation(text: "My confidence grows stronger every day", category: .confidence),
Affirmation(text: "I trust my inner wisdom", category: .confidence)
]

@State private var selectedAffirmation: Affirmation?
@State private var selectedCategory: Category = .beauty
@State private var selectedIntervalIndex = 4 // default to 30m
@State private var showingAlert = false
@State private var alertMessage = ""

var filteredAffirmations: [Affirmation] {
affirmations.filter { $0.category == selectedCategory }
}

var body: some View {
NavigationView {
ZStack {
// Gradient background
LinearGradient(
gradient: Gradient(colors: [.calmBlue, .softPurple, .gentleGreen]),
startPoint: .topLeading,
endPoint: .bottomTrailing
)
.ignoresSafeArea()

ScrollView {
VStack(spacing: 25) {
// Header
VStack(spacing: 8) {
Text("✨ Daily Affirmations ✨")
.font(.largeTitle)
.fontWeight(.bold)
.foregroundColor(.primaryAccent)
.shadow(color: .white, radius: 1, x: 0, y: 1)

Text("Nurture your mind with positive thoughts")
.font(.subheadline)
.foregroundColor(.secondaryAccent)
.italic()
}
.padding(.top, 20)

// Category Picker with enhanced styling
VStack(alignment: .leading, spacing: 12) {
HStack {
Text("\(selectedCategory.emoji) Choose Your Focus")
.font(.headline)
.foregroundColor(.primaryAccent)
Spacer()
}

ScrollView(.horizontal, showsIndicators: false) {
HStack(spacing: 12) {
ForEach(Category.allCases) { category in
CategoryButton(
category: category,
isSelected: selectedCategory == category
) {
selectedCategory = category
selectedAffirmation = nil // Reset selection when category changes
}
}
}
.padding(.horizontal)
}
}
.padding(.horizontal)

// Affirmations List
VStack(alignment: .leading, spacing: 12) {
HStack {
Text("💭 Select Your Affirmation")
.font(.headline)
.foregroundColor(.primaryAccent)
Spacer()
}
.padding(.horizontal)

LazyVStack(spacing: 10) {
ForEach(filteredAffirmations) { affirmation in
AffirmationCard(
affirmation: affirmation,
isSelected: selectedAffirmation?.id == affirmation.id,
category: selectedCategory
) {
selectedAffirmation = affirmation
}
}
}
.padding(.horizontal)
}

// Interval Selection
VStack(alignment: .leading, spacing: 12) {
HStack {
Text("⏰ Reminder Frequency")
.font(.headline)
.foregroundColor(.primaryAccent)
Spacer()
}

Menu {
ForEach(0..<intervals.count, id: \.self) { index in
Button(intervals[index].label) {
selectedIntervalIndex = index
}
}
} label: {
HStack {
Text("Every \(intervals[selectedIntervalIndex].label)")
.foregroundColor(.primaryAccent)
Spacer()
Image(systemName: "chevron.down")
.foregroundColor(.primaryAccent)
}
.padding()
.background(
RoundedRectangle(cornerRadius: 15)
.fill(.white.opacity(0.8))
.shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
)
}
}
.padding(.horizontal)

// Schedule Button
Button(action: scheduleNotifications) {
HStack {
Image(systemName: selectedAffirmation != nil ? "bell.fill" : "bell.slash")
Text(selectedAffirmation != nil ? "Schedule Affirmations" : "Select an Affirmation First")
.fontWeight(.semibold)
}
.foregroundColor(.white)
.padding(.vertical, 16)
.frame(maxWidth: .infinity)
.background(
LinearGradient(
gradient: Gradient(colors: selectedAffirmation != nil ?
[.primaryAccent, .secondaryAccent] :
[.gray.opacity(0.6), .gray.opacity(0.4)]
),
startPoint: .leading,
endPoint: .trailing
)
)
.cornerRadius(20)
.shadow(color: selectedAffirmation != nil ? .primaryAccent.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
.scaleEffect(selectedAffirmation != nil ? 1.0 : 0.95)
.animation(.easeInOut(duration: 0.2), value: selectedAffirmation != nil)
}
.disabled(selectedAffirmation == nil)
.padding(.horizontal)
.padding(.bottom, 30)
}
}
}
.navigationBarTitleDisplayMode(.inline)
.toolbar {
ToolbarItem(placement: .principal) {
Text("Affirm Me 🌟")
.font(.headline)
.fontWeight(.bold)
.foregroundColor(.primaryAccent)
}
}
.alert("Notification Status", isPresented: $showingAlert) {
Button("OK", role: .cancel) { }
} message: {
Text(alertMessage)
}
}
.onAppear(perform: requestPermission)
}

private func requestPermission() {
UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
if let error = error {
print("Permission error: \(error.localizedDescription)")
}
}
}

private func scheduleNotifications() {
guard let affirmation = selectedAffirmation else {
alertMessage = "Please select an affirmation first"
showingAlert = true
return
}

// Remove any previously scheduled notifications
UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

// Configure the notification content
let content = UNMutableNotificationContent()
content.title = "✨ Your Affirmation"
content.body = affirmation.text
content.sound = .default

// Schedule a repeating notification based on the selected interval
let intervalSeconds = TimeInterval(intervals[selectedIntervalIndex].minutes * 60)
let trigger = UNTimeIntervalNotificationTrigger(timeInterval: intervalSeconds, repeats: true)

let request = UNNotificationRequest(identifier: "affirmation_notification",
content: content,
trigger: trigger)

UNUserNotificationCenter.current().add(request) { error in
DispatchQueue.main.async {
if let error = error {
alertMessage = "Failed to schedule notifications: \(error.localizedDescription)"
} else {
alertMessage = "🌟 Affirmations scheduled every \(intervals[selectedIntervalIndex].label)! Your positive journey begins now."
}
showingAlert = true
}
}
}
}

// Custom Category Button Component
struct CategoryButton: View {
let category: Category
let isSelected: Bool
let action: () -> Void

var body: some View {
Button(action: action) {
HStack(spacing: 6) {
Text(category.emoji)
Text(category.rawValue)
.font(.system(size: 14, weight: .medium))
}
.padding(.horizontal, 16)
.padding(.vertical, 10)
.background(
RoundedRectangle(cornerRadius: 20)
.fill(isSelected ? category.color : Color.white.opacity(0.7))
.shadow(color: isSelected ? category.color.opacity(0.3) : .gray.opacity(0.2), radius: isSelected ? 8 : 4, x: 0, y: 2)
)
.foregroundColor(isSelected ? .white : .primaryAccent)
.scaleEffect(isSelected ? 1.05 : 1.0)
.animation(.easeInOut(duration: 0.2), value: isSelected)
}
}
}

// Custom Affirmation Card Component
struct AffirmationCard: View {
let affirmation: Affirmation
let isSelected: Bool
let category: Category
let action: () -> Void

var body: some View {
Button(action: action) {
HStack {
VStack(alignment: .leading, spacing: 4) {
Text(affirmation.text)
.font(.body)
.multilineTextAlignment(.leading)
.foregroundColor(isSelected ? .white : .primary)

if isSelected {
Text("Selected ✨")
.font(.caption)
.foregroundColor(.white.opacity(0.9))
.italic()
}
}

Spacer()

if isSelected {
Image(systemName: "checkmark.circle.fill")
.foregroundColor(.white)
.font(.title2)
.scaleEffect(1.2)
}
}
.padding(.horizontal, 20)
.padding(.vertical, 16)
.background(
RoundedRectangle(cornerRadius: 16)
.fill(isSelected ?
LinearGradient(
gradient: Gradient(colors: [category.color, category.color.opacity(0.8)]),
startPoint: .topLeading,
endPoint: .bottomTrailing
) :
LinearGradient(
gradient: Gradient(colors: [.white.opacity(0.9), .white.opacity(0.7)]),
startPoint: .topLeading,
endPoint: .bottomTrailing
)
)
.shadow(color: isSelected ? category.color.opacity(0.4) : .gray.opacity(0.2), radius: isSelected ? 12 : 6, x: 0, y: isSelected ? 6 : 3)
)
.scaleEffect(isSelected ? 1.02 : 1.0)
.animation(.easeInOut(duration: 0.3), value: isSelected)
}
.buttonStyle(PlainButtonStyle())
}
}

@main
struct AffirmationApp: App {
init() {
// Later, initialize AdMob here when we add ads:
// GADMobileAds.sharedInstance().start(completionHandler: nil)
}

var body: some Scene {
WindowGroup {
ContentView()
}
}
}

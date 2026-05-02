import Foundation
import Supabase

final class SupabaseManager {
    static let shared = SupabaseManager()
    
    let client = SupabaseClient(supabaseURL: URL(string: "https://pmsxuhretbhkbeqndtdh.supabase.co")!,
                                supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBtc3h1aHJldGJoa2JlcW5kdGRoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY0NTE5NTUsImV4cCI6MjA5MjAyNzk1NX0.aZHaJlwyr19H3C1y--pIhIIQTTa3Pq9Xg7yj-09V4Ms")
    
    private init() {}
}


import Foundation

final class Cache<Key: Hashable, Value> {
    private let wrapped = NSCache<NSString, DataEmployeesModel>()
    private let dateProvider: () -> Date
    private let entryLifetime: TimeInterval
    
    init(dateProvider: @escaping () -> Date = Date.init,
         entryLifetime: TimeInterval = 1 * 60 * 60) {
        self.dateProvider = dateProvider
        self.entryLifetime = entryLifetime
    }
    
}

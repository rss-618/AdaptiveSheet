import SwiftUI

/// Enum created for AdaptiveSheet display logic, allowing for dismissal completions to be used
public enum SheetDisplay: Equatable {

    case displayed
    case dismissed((() -> Void)? = nil)
    
    /// Equality function that omit the dismissal completion parameter
    /// there will not be a case where we will need to dismiss the same sheet twice in a row
    /// - Parameters:
    ///   - lhs: lhst SheetDisplay being compared
    ///   - rhs: rhs SheetDisplay being compared
    /// - Returns: The equality of the two sheets
    public static func == (lhs: SheetDisplay, rhs: SheetDisplay) -> Bool {
        return lhs.boolValue == rhs.boolValue
    }
    
    /// Bool representation of the enum
    public var boolValue: Bool {
        switch self {
        case .displayed:
            true
        case .dismissed:
            false
        }
    }
    
    /// Dismissal Completion of enum
    public var dismissCompletion: (() -> Void)? {
        switch self {
        case .displayed:
            nil
        case .dismissed(let optional):
            optional
        }
    }
    
    
    /// Conversion of a Bool to this enum
    /// - Parameter val: Bool Input
    /// - Returns: instance of SheetDisplay
    static public func parse(_ val: Bool) -> Self {
        if val {
            .displayed
        } else {
            .dismissed(nil)
        }
    }
}

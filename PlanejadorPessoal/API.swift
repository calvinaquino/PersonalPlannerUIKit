//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class ShoppingListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query ShoppingList {
      shoppingItems {
        __typename
        results {
          __typename
          id
          name
          localizedName
          price
          shoppingCategory {
            __typename
            id
            name
          }
        }
      }
    }
    """

  public let operationName: String = "ShoppingList"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("shoppingItems", type: .nonNull(.object(ShoppingItem.selections))),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(shoppingItems: ShoppingItem) {
      self.init(unsafeResultMap: ["__typename": "Query", "shoppingItems": shoppingItems.resultMap])
    }

    /// The shoppingItems query can be used to find objects of the ShoppingItem class.
    public var shoppingItems: ShoppingItem {
      get {
        return ShoppingItem(unsafeResultMap: resultMap["shoppingItems"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "shoppingItems")
      }
    }

    public struct ShoppingItem: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ShoppingItemFindResult"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("results", type: .nonNull(.list(.nonNull(.object(Result.selections))))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(results: [Result]) {
        self.init(unsafeResultMap: ["__typename": "ShoppingItemFindResult", "results": results.map { (value: Result) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// This is the objects returned by the query
      public var results: [Result] {
        get {
          return (resultMap["results"] as! [ResultMap]).map { (value: ResultMap) -> Result in Result(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: Result) -> ResultMap in value.resultMap }, forKey: "results")
        }
      }

      public struct Result: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ShoppingItem"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("localizedName", type: .scalar(String.self)),
          GraphQLField("price", type: .scalar(Double.self)),
          GraphQLField("shoppingCategory", type: .object(ShoppingCategory.selections)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String? = nil, localizedName: String? = nil, price: Double? = nil, shoppingCategory: ShoppingCategory? = nil) {
          self.init(unsafeResultMap: ["__typename": "ShoppingItem", "id": id, "name": name, "localizedName": localizedName, "price": price, "shoppingCategory": shoppingCategory.flatMap { (value: ShoppingCategory) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// This is the object id.
        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        /// This is the object name.
        public var name: String? {
          get {
            return resultMap["name"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        /// This is the object localizedName.
        public var localizedName: String? {
          get {
            return resultMap["localizedName"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "localizedName")
          }
        }

        /// This is the object price.
        public var price: Double? {
          get {
            return resultMap["price"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "price")
          }
        }

        /// This is the object shoppingCategory.
        public var shoppingCategory: ShoppingCategory? {
          get {
            return (resultMap["shoppingCategory"] as? ResultMap).flatMap { ShoppingCategory(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "shoppingCategory")
          }
        }

        public struct ShoppingCategory: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["ShoppingCategory"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("name", type: .scalar(String.self)),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, name: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "ShoppingCategory", "id": id, "name": name])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// This is the object id.
          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          /// This is the object name.
          public var name: String? {
            get {
              return resultMap["name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }
        }
      }
    }
  }
}

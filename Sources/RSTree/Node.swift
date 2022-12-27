//
//  Node.swift
//  NetNewsWire
//
//  Created by Brent Simmons on 7/21/15.
//  Copyright © 2015 Ranchero Software, LLC. All rights reserved.
//

import Foundation

// Main thread only.

/// A reference to a type that you wish to display within a tree-like context, such as a disclosable outline view.
///
/// The class includes additional information about the tree hierarchy of the nodes in order to display them as an increasingly disclosed outline view.
/// Call the methods on this class from the main thread.
public final class Node: Hashable {
    
    /// The parent of this node, if it has one.
    public weak var parent: Node?
    /// The object that this node represents.
    public let representedObject: AnyObject
    /// A Boolean value that indicates whether the node is allowed to have child nodes.
    public var canHaveChildNodes = false
    /// A Boolean value that indicates the node represents a group of items.
    public var isGroupItem = false
    /// The list of child nodes.
    public var childNodes = [Node]()
    /// The unique identifier of the node.
	public let uniqueID: Int
	private static var incrementingID = 0
    
    /// A Boolean value that indicates whether this node is the root of a tree of nodes.
	public var isRoot: Bool {
		if let _ = parent {
			return false
		}
		return true
	}
    
    /// The number of children for the node.
	public var numberOfChildNodes: Int {
		return childNodes.count
	}
    
    /// The index path from the root of a tree to this node.
	public var indexPath: IndexPath {
		if let parent = parent {
			let parentPath = parent.indexPath
			if let childIndex = parent.indexOfChild(self) {
				return parentPath.appending(childIndex)
			}
			preconditionFailure("A Node’s parent must contain it as a child.")
		}
		return IndexPath(index: 0) //root node
	}
    
    /// The depth of the node within the tree.
	public var level: Int {
		if let parent = parent {
			return parent.level + 1
		}
		return 0
	}
    
    /// A Boolean value that indicates if the node has no children.
	public var isLeaf: Bool {
		return numberOfChildNodes < 1
	}
    
    /// Creates a new node for the represented object you provide.
    /// - Parameters:
    ///   - representedObject: The object that this node represents within a tree.
    ///   - parent: The parent node if it has one; otherwise, `nil`.
	public init(representedObject: AnyObject, parent: Node?) {
		
		precondition(Thread.isMainThread)

		self.representedObject = representedObject
		self.parent = parent

		self.uniqueID = Node.incrementingID
		Node.incrementingID += 1
	}
    
    /// Creates a generic root node which doesn't relate to any specific object.
    ///
    /// The ``representedObject`` for this node is an internal empty class, and doesn't represent anything specific.
    /// - Returns: The root node for a tree.
	public class func genericRootNode() -> Node {
		
		let node = Node(representedObject: TopLevelRepresentedObject(), parent: nil)
		node.canHaveChildNodes = true
		return node
	}
    
    /// Searches for a child node that matches the object you provide, creating a new child node if the object doesn't already exist as a child.
    /// - Parameter representedObject: The object the node represents.
    /// - Returns: The node for the object you provided.
	public func existingOrNewChildNode(with representedObject: AnyObject) -> Node {

		if let node = childNodeRepresentingObject(representedObject) {
			return node
		}
		return createChildNode(representedObject)
	}
    
    /// Creates a new, disconnected, node for the object you provide.
    /// - Parameter representedObject: The object the node represents.
    /// - Returns: The node for the object you provided.
	public func createChildNode(_ representedObject: AnyObject) -> Node {

		// Just creates — doesn’t add it.
		return Node(representedObject: representedObject, parent: self)
	}
    
    /// Returns the child node at the index location you provide.
    /// - Parameter index: The index location of the child nodes.
    /// - Returns: The node, or `nil` if the index is outside the range of the child nodes.
	public func childAtIndex(_ index: Int) -> Node? {
		
		if index >= childNodes.count || index < 0 {
			return nil
		}
		return childNodes[index]
	}
    
    /// Returns the index location of the node you provide.
    /// - Parameter node: The child node.
    /// - Returns: The index within the list of child nodes, or `nil` if the node isn't in the list of child nodes.
	public func indexOfChild(_ node: Node) -> Int? {
		
		return childNodes.firstIndex{ (oneChildNode) -> Bool in
			oneChildNode === node
		}
	}
    
    /// Searches the children of this node to find the node representing the object you provide.
    /// - Parameter obj: The represented object.
    /// - Returns: The node that represents this object in the tree, or `nil` if it doesn't exist.
	public func childNodeRepresentingObject(_ obj: AnyObject) -> Node? {
		return findNodeRepresentingObject(obj, recursively: false)
	}

    /// Recursively searches from this node through the tree to find the node representing the object you provide.
    /// - Parameter obj: The represented object.
    /// - Returns: The node that represents this object in the tree, or `nil` if it doesn't exist.
	public func descendantNodeRepresentingObject(_ obj: AnyObject) -> Node? {
		return findNodeRepresentingObject(obj, recursively: true)
	}
    
    /// Recursively searches for a node that matches closure you provide.
    /// - Parameter test: A closure that evaluates the node for inclusion in a result.
    /// - Returns: The descendant node that matched, or `nil` if no nodes matched.
	public func descendantNode(where test: (Node) -> Bool) -> Node? {
		return findNode(where: test, recursively: true)
	}
    
    /// Returns a Boolean value that indicates if this node has one of the nodes you provide as a parent or ancestor.
    /// - Parameter nodes: The list of nodes to evaluate as potential ancestors.
    /// - Returns: `true` if the node is a descendant of one of the nodes from the provided list.
	public func hasAncestor(in nodes: [Node]) -> Bool {

		for node in nodes {
			if node.isAncestor(of: self) {
				return true
			}
		}
		return false
	}
    
    /// Returns a Boolean value that indicates if the node you provide is an ancestor within the tree.
    /// - Parameter node: The node to compare as a potential ancestor.
    /// - Returns: `true` if the node is a parent or ancestor, otherwise `false`.
	public func isAncestor(of node: Node) -> Bool {

		if node == self {
			return false
		}

		var nomad = node
		while true {
			guard let parent = nomad.parent else {
				return false
			}
			if parent == self {
				return true
			}
			nomad = parent
		}
	}
    
    /// Returns a dictionary of the nodes you provide, organized by common parent nodes.
    /// - Parameter nodes: The nodes to organize by parent.
	public class func nodesOrganizedByParent(_ nodes: [Node]) -> [Node: [Node]] {

		let nodesWithParents = nodes.filter { $0.parent != nil }
		return Dictionary(grouping: nodesWithParents, by: { $0.parent! })
	}
    
    /// Returns an index set of the nodes you provide, organized by common parent nodes.
    /// - Parameter nodes: The nodes to organize by parent.
    /// - Returns: <#description#>
	public class func indexSetsGroupedByParent(_ nodes: [Node]) -> [Node: IndexSet] {

		let d = nodesOrganizedByParent(nodes)
		let indexSetDictionary = d.mapValues { (nodes) -> IndexSet in

			var indexSet = IndexSet()
			if nodes.isEmpty {
				return indexSet
			}

			let parent = nodes.first!.parent!
			for node in nodes {
				if let index = parent.indexOfChild(node) {
					indexSet.insert(index)
				}
			}

			return indexSet
		}

		return indexSetDictionary
	}

	// MARK: - Hashable
    
    /// Hashes the essential components of this node by feeding them into the given hasher.
    /// - Parameter hasher: The hasher to use when combining the components of this instance.
	public func hash(into hasher: inout Hasher) {
		hasher.combine(uniqueID)
	}

	// MARK: - Equatable
    
    /// Returns a Boolean value indicating whether two nodes are equal.
    /// - Parameters:
    ///   - lhs: The first node to compare.
    ///   - rhs: The second node to compare.
	public class func ==(lhs: Node, rhs: Node) -> Bool {
		return lhs === rhs
	}
}


public extension Array where Element == Node {

	func representedObjects() -> [AnyObject] {

		return self.map{ $0.representedObject }
	}
}

private extension Node {

	func findNodeRepresentingObject(_ obj: AnyObject, recursively: Bool = false) -> Node? {

		for childNode in childNodes {
			if childNode.representedObject === obj {
				return childNode
			}
			if recursively, let foundNode = childNode.descendantNodeRepresentingObject(obj) {
				return foundNode
			}
		}

		return nil
	}

	func findNode(where test: (Node) -> Bool, recursively: Bool = false) -> Node? {

		for childNode in childNodes {
			if test(childNode) {
				return childNode
			}
			if recursively, let foundNode = childNode.findNode(where: test, recursively: recursively) {
				return foundNode
			}
		}

		return nil
	}

}

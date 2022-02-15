//
//  TreeController.swift
//  NetNewsWire
//
//  Created by Brent Simmons on 5/29/16.
//  Copyright © 2016 Ranchero Software, LLC. All rights reserved.
//

import Foundation

/// A type that provides a searchable index into a set of nodes.
///
/// Search through the nodes for which the delegate contains references.
/// You can use this to change the representation based on the kind of instance included within the node's ``RSTree/Node/representedObject`` property.
/// For example, in NetNewsWire the  [`WebFeedTreeControllerDelegate`](https://github.com/Ranchero-Software/NetNewsWire/blob/main/Shared/Tree/WebFeedTreeControllerDelegate.swift#L27-L39) returns a different set of child nodes if the provided node is a root node, a child node, or a set of filtered nodes.
public protocol TreeControllerDelegate: AnyObject {
    
    /// Returns a list of child nodes for the reference to the node you provide.
    /// - Parameters:
    ///   - treeController: The tree controller associated with this set of nodes.
    ///   - childNodesFor: The set of child nodes that correspond to the node you provide.
    /// - Returns: A list of relevant child nodes, or nil if the node doesn't have any children.
	func treeController(treeController: TreeController, childNodesFor: Node) -> [Node]?
}


/// A type that supports the visitor pattern to recursively visit nodes within a tree of nodes..
public typealias NodeVisitBlock = (_ : Node) -> Void

/// A controller used by the outlive view extension to support searching for and displaying nodes.
public final class TreeController {

    private weak var delegate: TreeControllerDelegate?
    /// The root node for the tree.
	public let rootNode: Node
    
    /// Creates a new tree controller with the tree controller delegate and root node that you provide.
    /// - Parameters:
    ///   - delegate: The delegate for the tree controller.
    ///   - rootNode: The root node for the tree.
	public init(delegate: TreeControllerDelegate, rootNode: Node) {
		
		self.delegate = delegate
		self.rootNode = rootNode
		rebuild()
	}
    
    /// Creates a new tree controller with the tree controller delegate that you provide.
    /// - Parameter delegate: The delegate for the tree controller.
    ///
    /// The root node is generated automatically as a generic root node that doesn't represent any object.
	public convenience init(delegate: TreeControllerDelegate) {
		
		self.init(delegate: delegate, rootNode: Node.genericRootNode())
	}
	
    /// Iterates through child nodes, re-ordering child nodes at each level.
    /// - Returns: `true` if the rebuild changed the ordering of any nodes.
    @discardableResult
	public func rebuild() -> Bool {

		// Rebuild and re-sort. Return true if any changes in the entire tree.
		
		return rebuildChildNodes(node: rootNode)
	}
    
    /// Iterates through all nodes in tree applying the closure you provide to each.
    /// - Parameter visitBlock: A closure that this class invokes with each node in the tree.
    ///
    /// Use this function to implement a visitor pattern across the nodes within the tree.
	public func visitNodes(_ visitBlock: NodeVisitBlock) {
		
		visitNode(rootNode, visitBlock)
	}
    
    /// Returns the node from the list you provide that matches the represented object.
    /// - Parameters:
    ///   - nodes: The nodes to compare.
    ///   - representedObject: The represented object to find within the set of nodes.
    ///   - recurse: A Boolean value that indicates whether the children of the nodes should be searched for the represented object.
    /// - Returns: The node matching the represented object, or `nil` if not found.
	public func nodeInArrayRepresentingObject(nodes: [Node], representedObject: AnyObject, recurse: Bool = false) -> Node? {
		
		for oneNode in nodes {

			if oneNode.representedObject === representedObject {
				return oneNode
			}

			if recurse, oneNode.canHaveChildNodes {
				if let foundNode = nodeInArrayRepresentingObject(nodes: oneNode.childNodes, representedObject: representedObject, recurse: recurse) {
					return foundNode
				}

			}
		}
		return nil
	}
    
    /// Recursively searches through the tree to find the node that represents the object that you provide.
    /// - Parameter representedObject: The represented object to find within the tree of nodes.
    /// - Returns: The node for the object, or `nil` if it wasn't found.
	public func nodeInTreeRepresentingObject(_ representedObject: AnyObject) -> Node? {

		return nodeInArrayRepresentingObject(nodes: [rootNode], representedObject: representedObject, recurse: true)
	}
    
    /// Returns a normalized list of nodes that removes any child nodes from parents that are in the list you provide.
    /// - Parameter nodes: The nodes to normalize.
    /// - Returns: A list of nodes without any nodes that are children of other nodes in the list.
	public func normalizedSelectedNodes(_ nodes: [Node]) -> [Node] {

		// An array of nodes might include a leaf node and its parent. Remove the leaf node.

		var normalizedNodes = [Node]()

		for node in nodes {
			if !node.hasAncestor(in: nodes) {
				normalizedNodes += [node]
			}
		}

		return normalizedNodes
	}
}

private extension TreeController {
	
	func visitNode(_ node: Node, _ visitBlock: NodeVisitBlock) {
		
		visitBlock(node)
		node.childNodes.forEach{ (oneChildNode) in
			visitNode(oneChildNode, visitBlock)
		}
	}
	
	func nodeArraysAreEqual(_ nodeArray1: [Node]?, _ nodeArray2: [Node]?) -> Bool {
		
		if nodeArray1 == nil && nodeArray2 == nil {
			return true
		}
		if nodeArray1 != nil && nodeArray2 == nil {
			return false
		}
		if nodeArray1 == nil && nodeArray2 != nil {
			return false
		}
		
		return nodeArray1! == nodeArray2!
	}
	
	func rebuildChildNodes(node: Node) -> Bool {
		
		if !node.canHaveChildNodes {
			return false
		}
		
		var childNodesDidChange = false
		
		let childNodes = delegate?.treeController(treeController: self, childNodesFor: node) ?? [Node]()
		
		childNodesDidChange = !nodeArraysAreEqual(childNodes, node.childNodes)
		if (childNodesDidChange) {
			node.childNodes = childNodes
		}
		
		childNodes.forEach{ (oneChildNode) in
			if rebuildChildNodes(node: oneChildNode) {
				childNodesDidChange = true
			}
		}

		return childNodesDidChange
	}
}

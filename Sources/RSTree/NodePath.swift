//
//  NodePath.swift
//  RSTree
//
//  Created by Brent Simmons on 9/5/16.
//  Copyright © 2016 Ranchero Software, LLC. All rights reserved.
//

import Foundation

/// An array of nodes that represents the path through a tree structure to a specific item.
public struct NodePath {
    
    /// The list of nodes that make up the path
	let components: [Node]
    
    /// Creates a new node path from the node you provide.
    /// - Parameter node: The node to identify with a node path.
	public init(node: Node) {

		var tempArray = [node]

		var nomad: Node = node
		while true {
			if let parent = nomad.parent {
				tempArray.append(parent)
				nomad = parent
			}
			else {
				break
			}
		}

		self.components = tempArray.reversed()
	}
    
    /// Creates a node path by searching through the tree of nodes within the tree controller you provide.
    ///
    /// - Parameters:
    ///   - representedObject: The represented object to find within the nodes of the tree.
    ///   - treeController: The tree controller that represents the tree of nodes to search.
    ///
    ///  Returns `nil` if the tree doesn't have the represented object within it's nodes, 
	public init?(representedObject: AnyObject, treeController: TreeController) {

		if let node = treeController.nodeInTreeRepresentingObject(representedObject) {
			self.init(node: node)
		}
		else {
			return nil
		}
	}
}

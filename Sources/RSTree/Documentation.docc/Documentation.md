# ``RSTree``

The data structures to assemble and present a tree of objects as an outline.

## Overview

RSTree provides the data structures and methods to build, collect, and selectively display a tree of objects as a disclosable outline view.
[NetNewsWire](https://netnewswire.com) uses the `RSTree` library within the [sidebar view controller](https://github.com/Ranchero-Software/NetNewsWire/blob/main/Mac/MainWindow/Sidebar/SidebarViewController.swift) to present a collection of feeds and related information, organized by the user.

The tree data structure is represented by a hierarchy of ``RSTree/Node`` instances that you create, each of which represent another `Hashable` object.
The ``RSTree/Node`` makes it easier to assemble a tree of ordered identities for objects without having to add properties directly to those objects.
An individual tree is represented by the ``RSTree/TreeController``, which provides generalized access to the nodes within the tree, and a customizable response for child nodes using ``RSTree/TreeControllerDelegate``.
This customized response allows NetNewsWire to provide virtual collections (the Smart Feeds feature) as a lens into a subset of the objects contained within the tree. 

The library includes an extension on `NSOutlineView` to search for an relevant an object within the tree data structure, disclose the path to the element, and make it the selected element within the Outline View.
`revealAndSelectNodeAtPath` takes a ``RSTree/NodePath`` as a parameter. 
`revealAndSelectRepresentedObject` searches for a object within a given ``RSTree/TreeController``.


## Topics

### Creating a Tree of Nodes 

- ``RSTree/Node``
- ``RSTree/NodePath``
- ``RSTree/NodeVisitBlock``

### Displaying the Nodes

- ``RSTree/TreeController``
- ``RSTree/TreeControllerDelegate``

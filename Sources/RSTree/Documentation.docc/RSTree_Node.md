# ``RSTree/Node``

## Topics

### Creating Nodes

- ``RSTree/Node/init(representedObject:parent:)``
- ``RSTree/Node/genericRootNode()``
- ``RSTree/Node/existingOrNewChildNode(with:)``
- ``RSTree/Node/createChildNode(_:)``

### Comparing Nodes

- ``RSTree/Node/!=(_:_:)``
- ``RSTree/Node/==(_:_:)``
- ``RSTree/Node/hash(into:)``

### Inspecting Nodes

- ``RSTree/Node/representedObject``
- ``RSTree/Node/isRoot``
- ``RSTree/Node/parent``
- ``RSTree/Node/childNodes``
- ``RSTree/Node/numberOfChildNodes``
- ``RSTree/Node/canHaveChildNodes``
- ``RSTree/Node/isLeaf``
- ``RSTree/Node/level``
- ``RSTree/Node/indexPath``
- ``RSTree/Node/uniqueID``
- ``RSTree/Node/isGroupItem``

### Searching for Descendant Nodes

- ``RSTree/Node/childNodeRepresentingObject(_:)``
- ``RSTree/Node/childAtIndex(_:)``
- ``RSTree/Node/indexOfChild(_:)``
- ``RSTree/Node/descendantNode(where:)``
- ``RSTree/Node/descendantNodeRepresentingObject(_:)``

### Searching for Ancestor Nodes

- ``RSTree/Node/hasAncestor(in:)``
- ``RSTree/Node/isAncestor(of:)``

### Grouping Nodes

- ``RSTree/Node/nodesOrganizedByParent(_:)``
- ``RSTree/Node/indexSetsGroupedByParent(_:)``




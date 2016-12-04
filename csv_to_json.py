import csv
import json
import sys

class Node(object):
    def __init__(self, name, size=None):
        self.name = name
        self.children = []
        self.size = size

    def child(self, cname, size=None):
        child_found = [c for c in self.children if c.name == cname]
        if not child_found:
            _child = Node(cname, size)
            self.children.append(_child)
        else:
            _child = child_found[0]
        return _child

    def as_dict(self):
        res = {'name': self.name}
        if self.size is None:
            res['children'] = [c.as_dict() for c in self.children]
        else:
            res['size'] = self.size
        return res


root = Node('Flare')

with open(sys.argv[1] + '.csv', 'r') as f:
    reader = csv.reader(f)
    reader.next()
    for row in reader:
        grp1, grp2, grp3, grp4, grp5, grp6, size = row
#         root.child(grp1).child(grp2).child(grp3).child(grp4).child(grp5).child(grp6, size)
#         root.child(grp2).child(grp6, size)
        root.child(grp3).child(grp6, size)

with open(sys.argv[1] + '.json', 'w') as f:
	f.write(json.dumps(root.as_dict(), indent=4))
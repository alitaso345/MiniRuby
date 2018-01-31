def preorder(tree)
  if tree[0].start_with?("節")
    preorder(tree[1])
    preorder(tree[2])
  end

  p tree[0]
end

leaf_a = ["葉A"]
leaf_b = ["葉B"]
leaf_c = ["葉C"]
leaf_d = ["葉D"]

node2 = ["節2", leaf_a, leaf_b]
node3 = ["節3", leaf_c, leaf_d]
node1 = ["節1", node2, node3]

preorder(node1)

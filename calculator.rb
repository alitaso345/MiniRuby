require 'minruby'

def evaluate(tree)
  case tree[0]
  when 'lit'
    tree[1]
  when '+'
    left = evaluate(tree[1])
    right = evaluate(tree[2])
    left + right
  when '-'
    left = evaluate(tree[1])
    right = evaluate(tree[2])
    left - right
  when '*'
    left = evaluate(tree[1])
    right = evaluate(tree[2])
    left * right
  when '/'
    left = evaluate(tree[1])
    right = evaluate(tree[2])
    left / right
  when '%'
    left = evaluate(tree[1])
    right = evaluate(tree[2])
    left % right
  when '**'
    left = evaluate(tree[1])
    right = evaluate(tree[2])
    left ** right
  when '=='
    left = evaluate(tree[1])
    right = evaluate(tree[2])
    left == right
  when '>'
    left = evaluate(tree[1])
    right = evaluate(tree[2])
    left > right
  when '<'
    left = evaluate(tree[1])
    right = evaluate(tree[2])
    left < right
  end
end

#tree->integer 木を受け取って一番大きい値の葉を返す
def max(tree)
  if tree[0] == 'lit'
    tree[1]
  else
    left = max(tree[1])
    right = max(tree[2])

    if left > right
      left
    else
      right
    end
  end
end
str = gets

tree = minruby_parse(str)

answer = evaluate(tree)
max = max(tree)

p answer
p max

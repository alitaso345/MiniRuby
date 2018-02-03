require 'minruby'

def evaluate(tree)
  case tree[0]
  when 'lit'
    tree[1]
  when '+'
    evaluate(tree[1]) + evaluate(tree[2])
  when '-'
    evaluate(tree[1]) - evaluate(tree[2])
  when '*'
    evaluate(tree[1]) * evaluate(tree[2])
  when '/'
    evaluate(tree[1]) / evaluate(tree[2])
  when '%'
    evaluate(tree[1]) % evaluate(tree[2])
  when '**'
    evaluate(tree[1]) ** evaluate(tree[2])
  when '=='
    evaluate(tree[1]) == evaluate(tree[2])
  when '>'
    evaluate(tree[1]) > evaluate(tree[2])
  when '<'
    evaluate(tree[1]) < evaluate(tree[2])
  when 'stmts' #複文の実装
    i = 1
    while tree[i] != nil
      last = evaluate(tree[i])
      i = i + 1
    end
    last
  when 'func_call' #仮の実装
    p(evaluate(tree[2]))
  end
end

#tree->integer 木を受け取って一番大きい値の葉を返す
def max(tree)
  case tree[0]
  when 'lit'
    tree[1]
  when 'func_call'
    p(max(tree[2]))
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

str = minruby_load()

tree = minruby_parse(str)

evaluate(tree)

require 'minruby'

def evaluate(tree, env)
  case tree[0]
  when 'lit'
    tree[1]
  when '+'
    evaluate(tree[1], env) + evaluate(tree[2], env)
  when '-'
    evaluate(tree[1], env) - evaluate(tree[2], env)
  when '*'
    evaluate(tree[1], env) * evaluate(tree[2], env)
  when '/'
    evaluate(tree[1], env) / evaluate(tree[2], env)
  when '%'
    evaluate(tree[1], env) % evaluate(tree[2], env)
  when '**'
    evaluate(tree[1], env) ** evaluate(tree[2], env)
  when '=='
    evaluate(tree[1], env) == evaluate(tree[2], env)
  when '>'
    evaluate(tree[1], env) > evaluate(tree[2], env)
  when '<'
    evaluate(tree[1], env) < evaluate(tree[2], env)
  when 'stmts' #複文の実装
    i = 1
    last = nil
    while tree[i]
      last = evaluate(tree[i], env)
      i = i + 1
    end
    last
  when 'var_assign' #変数代入の実装
    env[tree[1]] = evaluate(tree[2], env)
  when 'var_ref' #変数参照の実装
    env[tree[1]]
  when 'func_call' #仮の実装
    p(evaluate(tree[2], env))
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

env = {}
evaluate(tree, env)

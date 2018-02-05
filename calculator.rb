require 'minruby'

def evaluate(tree, genv, lenv)
  case tree[0]
  when 'lit'
    tree[1]
  when '+'
    lenv['plus_count'] += 1
    evaluate(tree[1], genv, lenv) + evaluate(tree[2], genv, lenv)
  when '-'
    evaluate(tree[1], genv, lenv) - evaluate(tree[2], genv, lenv)
  when '*'
    evaluate(tree[1], genv, lenv) * evaluate(tree[2], genv, lenv)
  when '/'
    evaluate(tree[1], genv, lenv) / evaluate(tree[2], genv, lenv)
  when '%'
    evaluate(tree[1], genv, lenv) % evaluate(tree[2], genv, lenv)
  when '**'
    evaluate(tree[1], genv, lenv) ** evaluate(tree[2], genv, lenv)
  when '=='
    evaluate(tree[1], genv, lenv) == evaluate(tree[2], genv, lenv)
  when '>'
    evaluate(tree[1], genv, lenv) > evaluate(tree[2], genv, lenv)
  when '<'
    evaluate(tree[1], genv, lenv) < evaluate(tree[2], genv, lenv)
  when 'stmts' #複文の実装
    i = 1
    last = nil
    while tree[i]
      last = evaluate(tree[i], genv, lenv)
      i = i + 1
    end
    last
  when 'var_assign' #変数代入の実装
    lenv[tree[1]] = evaluate(tree[2], genv, lenv)
  when 'var_ref' #変数参照の実装
    lenv[tree[1]]
  when 'if'
    if evaluate(tree[1], genv, lenv)
      evaluate(tree[2], genv, lenv)
    else
      evaluate(tree[3], genv, lenv)
    end
  when 'while'
    while evaluate(tree[1], genv, lenv)
      evaluate(tree[2], genv, lenv)
    end
  when 'while2'
    evaluate(tree[2], genv, lenv)
    while evaluate(tree[1], genv, lenv)
      evaluate(tree[2], genv, lenv)
    end
  when 'func_call' #仮の実装
    args = []
    i = 0
    while tree[i+2]
      args[i] = evaluate(tree[i+2], genv, lenv)
      i = i + 1
    end

    mhd = genv[tree[1]]
    if mhd[0] == 'builtin'
      minruby_call(mhd[1], args)
    else
    end
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

def add(x, y)
  x + y
end

str = minruby_load()

tree = minruby_parse(str)

genv = { "p" => ["builtin", "p"],
         "add" => ["builtin", "add"],
       }

lenv = { "plus_count" => 0 }

evaluate(tree, genv, lenv)

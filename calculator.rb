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
  when '<='
    evaluate(tree[1], genv, lenv) <= evaluate(tree[2], genv, lenv)
  when '>='
    evaluate(tree[1], genv, lenv) >= evaluate(tree[2], genv, lenv)
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
  when 'func_def'
    genv[tree[1]] = ["user_defined", tree[2], tree[3]]
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
      new_lenv = {}
      params = mhd[1]
      i = 0
      while params[i]
        new_lenv[params[i]] = args[i]
        i = i + 1
      end
      evaluate(mhd[2], genv, new_lenv)
    end
  when 'ary_new'
    ary = []
    i = 0
    while tree[i + 1]
      ary[i] = evaluate(tree[i + 1], genv, lenv)
      i += 1
    end
    
    ary
  when 'ary_ref'
    ary = evaluate(tree[1], genv, lenv)
    idx = evaluate(tree[2], genv, lenv)
    ary[idx]
  when 'ary_assign'
    ary = evaluate(tree[1], genv, lenv)
    idx = evaluate(tree[2], genv, lenv)
    val = evaluate(tree[3], genv, lenv)
    ary[idx] = val
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

#引数に与えられた数までのFizzBuzzを表示する
def fizzbuzz(x)
  1.upto(x) do |i|
    str = ''
    str += 'Fizz' if i%3 == 0
    str += 'Buzz' if i%5 == 0
    str = i if str.empty?

    puts str
  end
end

#フィボナッチ数列のx番目を計算する
def fib(x)
  if x <= 1
    x
  else
    fib(x-1) + fib(x-2)
  end
end

#偶数判定
def even?(n)
  if n == 0
    true
  else
    odd?(n-1)
  end
end

#奇数判定
def odd?(n)
  if n == 0
    false
  else
    even?(n-1)
  end
end

str = minruby_load()

tree = minruby_parse(str)

genv = { "p"        => ["builtin", "p"],
         "add"      => ["builtin", "add"],
         "fizzbuzz" => ["builtin", "fizzbuzz"],
         "fib"      => ["builtin", "fib"],
         "even?"    => ["builtin", "even?"],
         "odd?"     => ["builtin", "odd?"],
       }

lenv = { "plus_count" => 0 }

evaluate(tree, genv, lenv)

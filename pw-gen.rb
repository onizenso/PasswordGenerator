require 'securerandom'
require 'pry'

def rand_num(n)
  SecureRandom.random_number(n)
end

def build_word_list(fn)
  list = []
  if File.readable? fn
    File.open(fn,"r"){|f|
      f.each_line {|l|
        list.push l.strip if l.length >= 5 && l.length <= 15
      }
    }
  end
  return list
end

def list_select(list)
  rn = rand_num(list.length - 1)
  return list[rn]
end

def special_number_select(sn)
  sp = []
  3.times do
    sp.push list_select(sn)
  end
  return sp.join
end


def insert_separator(list, schars)
  new_list = []
  list.each {|bw|
    sp = special_number_select(schars) 
    c = bw.chars
    c.insert( rand_num(c.length - 1), sp )
    new_list.push c.join
  }
  return new_list
end

special_chars = "~`!@\#$%^*(()_-+={}[]:\";'<>?,./\\|".chars
numbers = (0..9).to_a
spec_num = special_chars.join.concat(numbers.join)

file_name = ENV['WORD_LIST'].to_s 
dict_list = build_word_list(file_name)

base_words = []
3.times do
  base_words.push list_select(dict_list)
end

mod_words = insert_separator(base_words, spec_num)
password = "#{mod_words[1]}#{mod_words[2]}#{mod_words[0]}"

puts password
#binding.pry

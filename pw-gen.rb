#!/usr/bin/env ruby
require 'securerandom'
require 'pry'

class PasswordGenerator
  attr_accessor :file_name 
  
  # === initialize(file_name)
  # Create a new instance of the PasswordGenerator
  # setting @file_name to file_name which should 
  # point to a wordlist dictionary file
  def initialize(file_name)
    @file_name = file_name
  end

  # === rand_num(n)
  # Syntactic sugar for SecureRandom RNG
  # Produce random number between 0 & n inclusive 
  def rand_num(n)
    SecureRandom.random_number(n)
  end
  
  # === build_word_list
  # Read words from a dictionary file
  # supplied on class initialization
  def build_word_list
    list = []
    if File.readable? @file_name 
      File.open(@file_name,"r"){|f|
        f.each_line {|l|
          list.push l.strip if l.length >= 5 && l.length <= 15
        }
      }
    end
    return list
  end
  
  # === list_select(list,count)
  # Randomly select count number of items from list
  def list_select(list, cnt=5)
    nl = []
    cnt.times do
      rn = rand_num(list.length - 1)
      nl.push list[rn]
    end
    return nl
  end

  # === insert_separator(list, spec_string)
  # For each list item, build strings of 
  # randomly chosen special characters/numbers 
  # to insert at a random offset
  def insert_separator(list, spec_string)
    new_list = []
    spec_string = spec_string.chars
    list.collect {|bw| 
      sp = list_select(spec_string)
      bw.insert(rand_num(bw.length - 1), sp.join)
    }
    return list 
  end

  # === build_spec_num
  # Build a string containing special characters
  # and numbers 0 -9
  def build_spec_num
    special_chars = "~`!@\#$%^*()_-+={}[]:\";'<>?,./\\|"
    numbers = (0..9).to_a.join
    special_chars.concat( numbers )
    return special_chars
  end
end

# == Password Generator for Modified XKCD
# Set WORD_LIST environment variable to 
# desired dictionary of words
file_name = ENV['WORD_LIST'] ? ENV['WORD_LIST'].to_s : "" 
pass_gen = PasswordGenerator.new(file_name)
dict_list = pass_gen.build_word_list

base_words = pass_gen.list_select(dict_list, 3)
spec_num = pass_gen.build_spec_num

modified_words = pass_gen.insert_separator(base_words, spec_num)
password = "#{modified_words[1]}#{modified_words[2]}#{modified_words[0]}"

puts password

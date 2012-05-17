#!/usr/bin/env ruby
require 'FileUtils'
File.open('ruby.snippets', 'w') do |snippets_file|
  snippets = {}
  File.read('tags').each_line do |line|
    next unless line.match /^\w+:/
    line =~ /^(([^:]*):([^\s]*))\s.*/
    snippet = $1
    method = $2
    args = $3
    args = args.split(":")

    snippets[snippet] = {:snippet => snippet, :method => method, :args => args}
  end

  snippets.keys.sort.each do |key|
    snippet = key
    method = snippets[key][:method]
    args = snippets[key][:args]
    named_args = ""
    last_arg = 1
    args.each_with_index do |arg, i|
      named_args += ", #{arg}: ${#{i+2}}"
      last_arg += 1
    end
    snippets_file.write("snippet #{snippet}\n\t#{method}(${1}#{named_args})${#{last_arg + 1}}\n")
  end
end


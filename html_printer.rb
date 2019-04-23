#!/usr/bin/env ruby

if !ARGV[0] || !ARGV[1]
  puts "Usage: ruby html_printer.rb infile outfile"
  exit
end

# read input file from arglist
fin = File.new(ARGV[0],"r")
contents = nil
if fin
  contents = fin.read
  fin.close
else
  puts "I/O error: file #{ARGV[0]} could not be read"
  exit
end

# split file into tokens ("<html>", "<head>", textual blocks, ...)
tokens = contents.scan(/<[^>]*>|[^<>]+/).map { |token| token.strip }

# open output file for writing
fout = File.new(ARGV[1],"w")

if fout
  fout.write("<html>\n")
  fout.write("<head>\n")
  fout.write("<title>HTML Output</title>\n")
  fout.write("</head>\n")
  fout.write("<body>\n")
  fout.write("<tt>\n")

  tab = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"

  num_indent = 0
  
  tokens.each do |token|
    line = token.gsub("<","&lt;").gsub(">","&gt;") + "<br/>\n"

    token_without_whitespace = token.gsub("\s","")
    if token[0] == "<"
      if token_without_whitespace[1] == "/"
        if num_indent > 0
          num_indent -= 1
        end
        line = tab*num_indent + line
      else
        line = tab*num_indent + line

        if !token.downcase.match(/(br)|(input)|(!--)/)
          num_indent += 1
        end
      end
    else
      line = tab*num_indent + line
    end

    fout.write(line)
  end

  fout.write("</tt>\n")
  fout.write("</body>\n")
  fout.write("</html>\n")

  fout.close
else
  puts "I/O error: file #{ARGV[1]} could not be opened for writing"
  exit
end
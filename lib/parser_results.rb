class ParserResults

    def initialize
        # @processed_results to store each line's words.
        @processed_results = {0 => []};

        # @current_line for use throughout processing to store line number.
        @current_line = 0;
    end

    def process (words)
        words.each do |word|
            # If word :starts_new_paragraph, add new lines to start new paragraph.
            if word[:starts_new_paragraph]
                add_new_paragraph();
            end

            # If current line character count is less than 80 after adding word, add to line's word array.
            # Otherwise, add new line.
            if line_char_count() <= 80 && (line_char_count() + word[:text].length) <= 80
                @processed_results[@current_line].push(word[:text]);
            else
                add_new_line();
            end
        end
        # Once all words in original text file are processed, output results.
        output_txt_file();
    end

    def increment_current_line
        @current_line  += 1;
        if !@processed_results[@current_line]
            @processed_results[@current_line] = [];
        end
    end

    def add_new_line
        increment_current_line();
        @processed_results[@current_line].push("\n");
        increment_current_line();
    end

    def add_new_paragraph
        3.times do 
            increment_current_line();
            @processed_results[@current_line].push("\n");
        end
        increment_current_line();
    end

    def line_char_count ()
        # Sums characters for each word in current line word array and accounts for spaces.
        _charCount = 0;
        _spacesCount = 0;
        @processed_results[@current_line].each do |word|
            _charCount += word.length;
            _spacesCount = _spacesCount + 1;
        end
        return _charCount + _spacesCount;
    end

    def output_txt_file
        # Output results to .txt file, text_processed.txt, in current directory.
        File.open("text_processed.txt", "w") { |file| 
           @processed_results.each do |lineNum, wordsArr| 
            file.puts wordsArr.join(" ");
          end
        }
    end
end
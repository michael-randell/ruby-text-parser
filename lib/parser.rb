require_relative "./parser_results.rb"
class Parser

    def initialize
        # @words_storage to store details for all words in file.
        @words_storage = [];
        # @last_line_type to track new lines for determining if word is start of new paragraph.
        @last_line_type = {:was_new_line => false, :succession_count => 0};
    end

    def parse_file (file_path)
        # Iterate through all lines in file.
        File.readlines(file_path).each do |line|
            parse_line(line);
        end
        process_result();
    end

    def parse_line (line) 
        # Run check to see if line is the start of a new paragraph.
        _is_new_paragraph = check_for_paragraph(line);

        # Create words array from line and store details for each word.
        _words = line.split(" ");
        _words.each_with_index do |word, idx|
            if idx === 0 && _is_new_paragraph
                @words_storage.push({:text => word.strip, :starts_new_paragraph => true});
                _is_new_paragraph = false;
            else 
                @words_storage.push({:text => word.strip, :starts_new_paragraph => false});
                _is_new_paragraph = false;
            end
        end
    end

    def check_for_paragraph (line)
        _new_paragraph = nil;

        # If preceeding 3 lines were new lines, current line is start of new paragraph.
        if  @last_line_type[:succession_count] === 3
            _new_paragraph = true;
            # Reset @last_line_type instance variable for further processing.
            @last_line_type[:was_new_line] = false;
            @last_line_type[:succession_count] = 0;
        else
            _new_paragraph = false;
        end

        # If current line is empty, store line type data in @last_line_type hash.
        if line.strip === ""
            @last_line_type[:was_new_line] = true;
            @last_line_type[:succession_count] = @last_line_type[:succession_count] + 1;
        else
            # Reset @last_line_type instance variable for further processing.
            @last_line_type[:was_new_line] = false;
            @last_line_type[:succession_count] = 0;
        end

        return _new_paragraph;
    end

    def process_result
        # Instantiate new ParserResults instance and process @words_storage.
        ParserResults.new.process(@words_storage);
    end
end

Parser.new.parse_file("./text.txt");
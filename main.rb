#!/usr/bin/env ruby
#


class TetrisBoard
    attr_accessor :matrix, :score, :cleared_lines
    def initialize(width = 10, depth = 22)
        @depth = depth
        @width = width
        @score = 0
        @cleared_lines = 0
        @active_tetramino = nil
        @tet_coords = { x: nil, y: nil }
        @rotated = false
        @matrix = Array.new(depth) { Array.new(width) }
    end
    
    TETRAMINOS = {
        I: [
            [nil, nil, nil, nil],
            ["c", "c", "c", "c"],
            [nil, nil, nil, nil],
            [nil, nil, nil, nil]
           ],
        O: [ 
            ["y", "y"],
            ["y", "y"]
           ],
        Z: [
            ["r", "r", nil],
            [nil, "r", "r"],
            [nil, nil, nil]
           ],
        S: [
            [nil, "g", "g"],
            ["g", "g", nil],
            [nil, nil, nil]
           ],
        J: [
            ["b", nil, nil],
            ["b", "b", "b"],
            [nil, nil, nil]
           ],
        L: [
            [nil, nil, "o"],
            ["o", "o", "o"],
            [nil, nil, nil]
           ],
        T: [
            [nil, "m", nil],
            ["m", "m", "m"],
            [nil, nil, nil]
           ]
    }

    def print_matrix
        @matrix.each { |row|
            row.each { |cell|
                if cell.nil?
                    print "." + " "
                else
                    print cell + " "
                end
            }
            print "\n"
        }
    end
    
    def clear_check
        @matrix.map! { |row|
            if row.include? nil
                 row
            else
                @score += 100
                @cleared_lines += 1
                Array.new(@width)
            end
        }
    end
    
    def clear_matrix
        @matrix = Array.new(@depth) { Array.new(@width) }
    end
    
    def draw_matrix
        rows = []
        ( 0..(@depth-1) ).each do |row|
            line = $stdin.readline.split(" ")
            line.map! { |ele|
                if ele == "."
                    nil
                else
                    ele
                end
            }
            rows << line
        end
        @matrix = rows
    end

    def spawn_tetramino
        @active_tetramino.each.with_index{ |row, rindex|
            row.each.with_index { |cell, cindex|
                if cell == nil
                    next
                else
                    @matrix[rindex+@tet_coords[:y]][cindex+@tet_coords[:x]] = cell.upcase
                end
            }
        }
        print_matrix
    end

    def rotate_tetramino(direction)
        @rotated = true
        if direction == "cw"
            @active_tetramino = @active_tetramino.reverse.transpose
        else
            @active_tetramino = @active_tetramino.transpose
        end
        remove_previous
    end

    def remove_previous
       @matrix.each { |row|
           row.map! { |cell|
               if cell.nil?
                   next
               else
                   nil
               end
           }
       }
    end

    def move_tetramino(direction)
        right_column = @matrix.collect { |row| row.last }
        case direction
        when "left"
            @tet_coords[:x] -= 1 if (@tet_coords[:x] > 0)
        when "right"
            @tet_coords[:x] += 1 unless right_column.uniq.count > 1
        when "down"
          @tet_coords[:y] += 1 unless (@tet_coords[:y]+@active_tetramino.length) > @depth
        end
        remove_previous
    end

    def drop_tetramino
        if @rotated == false
            until (@tet_coords[:y]+@active_tetramino.length) > @depth
                move_tetramino("down")
            end
        else
            until (@tet_coords[:y]+@active_tetramino.length) == @depth
                move_tetramino("down")
            end
        end
        remove_previous
        deactivate_tetramino
    end

    def deactivate_tetramino
        @active_tetramino.each.with_index { |row, rindex|
            row.each.with_index { |cell, cindex|
                if cell.nil?
                    next
                end
                @matrix[rindex+@tet_coords[:y]][cindex+@tet_coords[:x]] = cell.downcase
            }
        }
    end

    def activate_tetramino(tet_sym)
        @active_tetramino = TETRAMINOS[tet_sym]
        @tet_coords[:x] = if tet_sym == :O
                                           4
                                       else
                                           3
                                       end

        @tet_coords[:y] = 0
    end

    def active_tetramino()
        @active_tetramino.each { |row|
            row.each { |ele|
                if ele == nil
                    print ". "
                else
                    print ele + " "
                end
            }
            print "\n"
        }
        #Print newline after certain tetraminos
        if (@active_tetramino.inject(:+) & %w(g b o m)).empty? == false
            print "\n"
        end
    end

    def read_input(entry)
        case entry
        when "g" #Update
            draw_matrix
        when "p" #Print
            print_matrix
        when "P" #Print matrix with active tetramino
            spawn_tetramino
        when "s" #Check for lines to clear
            clear_check
        when "c" #Empty matrix
            clear_matrix

        #Tetraminos
        when "I"
            activate_tetramino(entry.to_sym)
        when "O"
            activate_tetramino(entry.to_sym)
        when "Z"
            activate_tetramino(entry.to_sym)
        when "S"
            activate_tetramino(entry.to_sym)
        when "J"
            activate_tetramino(entry.to_sym)
        when "T"
            activate_tetramino(entry.to_sym)
        when "L"
            activate_tetramino(entry.to_sym)

        #Tetramino actions
        when ")"
            rotate_tetramino("cw")
        when "("
            rotate_tetramino("ccw")
        when "<"
            move_tetramino("left")
        when ">"
            move_tetramino("right")
        when "v"
            move_tetramino("down")
        when "V"
            drop_tetramino
        when "t" #Display active tetramino
            active_tetramino()
        when "X"
            puts "#{@tet_coords[:x]}, #{@tet_coords[:y]}"


        when "?n" #Get lines cleared
            puts cleared_lines
        when "?s" #Get score
            puts score
        when "q"
            exit
        end
    end

end


@game = TetrisBoard.new
loop do
    entry = $stdin.readline.chomp
    entry.delete(";").delete(" ")
    unless entry.include? "?"
        entry.each_char { |cmd|
            @game.read_input(cmd)
        }
    else
        @game.read_input(entry)
    end
end

class BFState
  def initialize(source)
    @ary = [0]
    @data_ptr = 0
    @prog_ptr = 0
    @source = ""
    @match = Hash.new
    stack = []
    source.each_char.with_index do |ch|
      index = @source.length
      case ch
      when "+", "-", "<", ">", ".", ","
        @source << ch
      when "["
        @source << ch
        stack << index
      when "]"
        @source << ch
        matched_index = stack.pop
        raise "Unmatched brackets" if matched_index == nil
        @match[matched_index] = index
        @match[index] = matched_index
      end
    end
  end
  def step
    return false if @prog_ptr >= @source.length
    case @source[@prog_ptr]
    when "+"
      @ary[@data_ptr] += 1
    when "-"
      @ary[@data_ptr] -= 1
    when ">"
      @data_ptr += 1
      @ary << 0 if @data_ptr == @ary.length
    when "<"
      @data_ptr -= 1
      raise "Out of range" if @data_ptr < 0
    when "."
      putc @ary[@data_ptr].chr
    when ","
      @ary[@data_ptr] = gets.ord
    when "["
      @prog_ptr = @match[@prog_ptr] if @ary[@data_ptr] == 0
    when "]"
      @prog_ptr = @match[@prog_ptr] if @ary[@data_ptr] != 0
    end
    @prog_ptr += 1
    @prog_ptr < @source.length
  end
  def run
    count = 0
    count += 1 while step
    count
  end
end

raise "Source file name required" if ARGV.length < 1
filename = ARGV[0]
source = File.open(filename) {|io| io.read}
bfs = BFState.new(source)
bfs.run

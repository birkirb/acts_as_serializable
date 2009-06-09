class Version

  def initialize(version_string)
    version_string = version_string.gsub('_','.')
    @levels = version_string.split('.')

    @levels.each_with_index do |number, index|
      @levels[index] = number.to_i
    end
  end

  def major
    get_level(0)
  end

  def minor
    get_level(1)
  end

  def build
    get_level(2)
  end

  def revision
    get_level(3)
  end

  def <(rhs)
    (self <=> rhs) < 0
  end

  def >(rhs)
    (self <=> rhs) > 0
  end

  def ==(rhs)
    (self <=> rhs) == 0
  end

  def <=>(rhs)
    max_levels = @levels.size - 1
    max_levels = rhs.levels.size - 1 if rhs.levels.size > max_levels

    (0..max_levels).each do |level|
      lhs_level = @levels[level] || 0
      rhs_level = rhs.levels[level] || 0
    # puts "Comparing lhs: #{lhs_level} with rhs: #{rhs_level}"

      if lhs_level == rhs_level
        next
      else
        return lhs_level <=> rhs_level
      end
    end
    0 # Ended on an equality
  end

  def to_s
    @levels.join('.')
  end

  protected

  def levels
    @levels
  end

  private

  def get_level(level)
    if @levels.size > level
      @levels[level]
    else
      0
    end
  end

end

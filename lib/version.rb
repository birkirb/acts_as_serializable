class Version

  def initialize(version_string)
    version_string = version_string.sub('_','.')
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

  def <=>(rhs)
    max_levels = @levels.size
    max_levels = rhs.levels.size if rhs.levels.size > max_levels

    for(1..max_levels) do |level|
      lhs_level = @levels[level] || 0
      rhs_level = rhs.level[level] || 0

      if lhs_level == rhs_level
        next
      else
        return lhs_level <=> rhs_level
      end
    end
  end

  def to_s
    @levels.join('.')
  end

  private

  def levels
    @levels
  end

  def get_level(level)
    if @levels.size >= level
      @levels[level]
    else
      0
    end
  end

end

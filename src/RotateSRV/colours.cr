module RotateSRV
  class Colours
    @@green = "\u001b[32m"
    @@red = "\u001b[31m"
    @@cyan = "\u001b[36m"
    @@reset = "\u001b[0m"

    def self.green
      @@green
    end

    def self.red
      @@red
    end

    def self.cyan
      @@cyan
    end

    def self.reset
      @@reset
    end
  end
end
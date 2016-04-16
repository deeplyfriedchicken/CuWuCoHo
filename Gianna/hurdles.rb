require "rubygems"
require "rubygame"

include Rubygame

#!/usr/bin/env ruby

# Defines a class for an example object in the game that will have a
# repr esentation on screen ( a sprite)
# Defines a class for an example object in the game that will have a
# representation on screen ( a sprite)
  include Sprites::Sprite
class Meanie

  # Turn this object into a sprite
  protected
  def initialize
    # Invoking the base class constructor is important and yet easy to forget:
    super()
    # @image and @rect are expected by the Rubygame sprite code
    $click = 0
    @image = Surface.load "luigi.png"
    @rect  = @image.make_rect


    @angle = 240
  end

  # Animate this object.  "seconds_passed" contains the number of ( real-world)
  # seconds that have passed since the last time this object was updated and is
  # therefore useful for working out how far the object should move ( which
  # should be independent of the frame rate)
  def update  seconds_passed

    # This example makes the objects orbit around the center of the screen.
    # The objects make one orbit every 4 seconds
      if ($click % 2 == 0)
        @angle = @angle + 200
      else
        @angle = @angle - 200
      end
    #( @angle + 2*Math::PI / 4 * seconds_passed) % ( 2*Math::PI)
    @rect.topleft = [ 100,
                     @angle]
  end





  def draw  on_surface
    @image.blit  on_surface, @rect
  end
end

class Hurdle < Meanie

 $angle = 0
  # Turn this object into a sprite
  protected
  def initialize
    super()

    @image2 = Surface.load "ghost.png"
    @rect2 = @image2.make_rect
    $angle = 0
  end

  def update
    $angle = $angle + 50
    @rect2.topleft = [$angle, 50]
  end


end

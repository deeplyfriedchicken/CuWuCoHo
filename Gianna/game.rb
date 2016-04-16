#!/usr/bin/env ruby

require "rubygems"
require "rubygame"

include Rubygame

@screen = Screen.open [ 640, 480]



# Defines a class for an example object in the game that will have a
# representation on screen ( a sprite)
class Meanie

  # Turn this object into a sprite
  include Sprites::Sprite

  def initialize
    # Invoking the base class constructor is important and yet easy to forget:
    super()
    # @image and @rect are expected by the Rubygame sprite code
    $click = 0
    @image = Surface.load "luigi.png"
    @rect  = @image.make_rect

    @image2 = Surface.load "ghost.png"
    @rect2 = @image2.make_rect

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
    @rect2.topleft = [ @angle, 100]
    @rect.topleft = [ 100,
                     @angle]
  end





  def draw  on_surface
    @image.blit  on_surface, @rect
    @image2.blit on_surface, @rect2
  end
end


@clock = Clock.new
@clock.target_framerate = 60

# Ask Clock.tick() to return ClockTicked objects instead of the number of
# milliseconds that have passed:
@clock.enable_tick_events

# Create a new group of sprites so that all sprites in the group may be updated
# or drawn with a single method invocation.
@sprites = Sprites::Group.new
Sprites::UpdateGroup.extend_object @sprites
200.times do @sprites << Meanie.new end


# Load a background image and copy it to the screen
@background = Surface.load "background.png"
@background.blit @screen, [ 0, 0]

@event_queue = EventQueue.new
@event_queue.enable_new_style_events

should_run = true
while should_run do

  seconds_passed = @clock.tick().seconds

  @event_queue.each do |event|
    case event
    when Rubygame::Events::MousePressed
      $click = $click + 1
        @sprites.undraw @screen, @background
        @sprites.update  seconds_passed
        @sprites.draw @screen
        @screen.flip
        @sprites.undraw @screen, @background

        $click = $click + 1

        @sprites.update seconds_passed
        @sprites.draw @screen
    when Events::QuitRequested, Events::KeyReleased
        should_run = false
    end
  end

  # "undraw" all of the sprites by drawing the background image at their
  # current location ( before their location has been changed by the animation)
  # @sprites.undraw @screen, @background
  #
  # # Give all of the sprites an opportunity to move themselves to a new location
  # @sprites.update  seconds_passed
  #
  # # Draw all of the sprites
  # @sprites.draw @screen
  @screen.flip
end

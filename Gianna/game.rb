

require "rubygems"
require "rubygame"
include Rubygame

#!/usr/bin/env ruby
  include Sprites::Sprite
@screen = Screen.open [ 600, 400]

class Luigi

  # Turn this object into a sprite
  def initialize
    # Invoking the base class constructor is important and yet easy to forget:
    super()
    # @image and @rect are expected by the Rubygame sprite code
    $click = 0
    @image = Surface.load "luigi.png"
    # @image2 = Surface.load "ghost.png"
    # @rect2 = @image2.make_rect
    @rect  = @image.make_rect


    @angle = 200
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
    # @rect2.topleft = [@angle, 100]
  end


  def draw  on_surface
    @image.blit  on_surface, @rect
    # @image2.blit on_surface, @rect2
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
1.times do @sprites << Luigi.new end


# Load a background image and copy it to the screen
@background = Surface.load "background6.png"
$x = 0
$y = 0
@background.blit @screen, [ $x, $y]
  #@screen.fill [255, 255, 255]

@event_queue = EventQueue.new
@event_queue.enable_new_style_events

should_run = true
while should_run do
  @sprites.draw @screen
  seconds_passed = @clock.tick().seconds

  @event_queue.each do |event|
    case event
    # when Rubygame::Events::MousePressed
    #   $click = $click + 1
    #     @sprites.undraw @screen, @background
    #     @sprites.update  seconds_passed
    #     @sprites.draw @screen
    #     @screen.flip
    #     @sprites.undraw @screen, @background
    #
    #     $click = $click + 1
    #     @sprites.update seconds_passed
    #     @sprites.draw @screen

      when Rubygame::Events::InputFocusGained
        puts "hello i hate my life"
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
  $x = $x + 20
  if ($x > 600)
    $x = 0
  end
  @background.blit @screen, [$x, 0]

  @screen.flip()
end


class Game
  include EventHandler::HasEventHandler

  def initialize()
    make_screen
    make_clock
    make_queue
    make_event_hooks
    make_ship
  end


  # The "main loop". Repeat the #step method
  # over and over and over until the user quits.
  def go
    catch(:quit) do
      loop do
        step
      end
    end
  end


  private


  # Create a new Clock to manage the game framerate
  # so it doesn't use 100% of the CPU
  def make_clock
    @clock = Clock.new()
    @clock.target_framerate = 50
    @clock.calibrate
    @clock.enable_tick_events
  end


  # Set up the event hooks to perform actions in
  # response to certain events.
  def make_event_hooks
    hooks = {
      :escape => :quit,
      :q => :quit,
      QuitRequested => :quit
    }

    make_magic_hooks( hooks )
  end


  # Create an EventQueue to take events from the keyboard, etc.
  # The events are taken from the queue and passed to objects
  # as part of the main loop.
  def make_queue
    # Create EventQueue with new-style events (added in Rubygame 2.4)
    @queue = EventQueue.new()
    @queue.enable_new_style_events

    # Don't care about mouse movement, so let's ignore it.
    @queue.ignore = [MouseMoved]
  end


  # Create the Rubygame window.
  def make_screen
    @screen = Screen.open( [640, 480] )
    @screen.title = "Square! In! Space!"
  end


  # Create the player ship in the middle of the screen
  def make_ship
    @ship = Ship.new( @screen.w/2, @screen.h/2 )

    # Make event hook to pass all events to @ship#handle().
    make_magic_hooks_for( @ship, { YesTrigger.new() => :handle } )
  end


  # Quit the game
  def quit
    puts "Quitting!"
    throw :quit
  end


  # Do everything needed for one frame.
  def step
    # Clear the screen.
    @screen.fill( :black )

    # Fetch input events, etc. from SDL, and add them to the queue.
    @queue.fetch_sdl_events

    # Tick the clock and add the TickEvent to the queue.
    @queue << @clock.tick

    # Process all the events on the queue.
    @queue.each do |event|
      handle( event )
    end

    # Draw the ship in its new position.
    @ship.draw( @screen )

    # Refresh the screen.
    @screen.update()
  end

end


# Start the main game loop. It will repeat forever
# until the user quits the game!
Game.new.go


# Make sure everything is cleaned up properly.
Rubygame.quit()

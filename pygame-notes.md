# Pygame Notes

### Surface is a background of sorts that you can draw on - can have as many as you
* Using image.load() to create a surface that contains an image
  * Learn:
    * blit()
    * fill()
    * set_at()
    * get_at()
### Use surface convert
  * `surface = pygame.image.load(‘food.png’).convert()`
    * calling it allows the image to load a lot faster at *virtually no cost*
### Dirty Rect animation
* Three options
  * `pygame.display.update()` - updates whole window *(slow)*
  * `pygame.display.flip()` - complicated but basically same as first
  * `pygame.display.update(a rectangle or list of rectangles)` - updates the specified rectangles **(use this one)**
    * keep a running list of rectangles that change to make it easy
    * FOR EXAMPLE (sprite):
      * Blit a piece of the background over the spirte's current location
      * Append the sprite's current location rectangle to a list
      * Move the sprite
      * Draw the sprite at it's new location
      * Append the sprite's new location to the list
      * Call display.update(list)
    * __*HUGE BOOST IN SPEED*__
      * BUT, does not work in two instances
### Don't worry about hardware acceleration
<!-- ### Rectangles -->

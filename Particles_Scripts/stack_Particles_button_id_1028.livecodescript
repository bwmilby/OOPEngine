Script "stack_Particles_button_id_1028"

/*
# Name: button "GravityParticle" of card "Classes" of stack "Particles"
# ID: button id 1028 of card id 1004 of stack "Particles"
# Behavior: button id 1022 of stack "Particles"
*/


###############################################################
#
# Class: GravityParticle
# Inherits: Particle
#
# overrides "birth" and "animate" and adds a new property "gravity"

local _gravity

setProp gravity pGravity
   if pGravity is a number then
      put pGravity into _gravity
   end if
end gravity

getProp gravity
   return _gravity
end gravity

function gravity
   return _gravity
end gravity

# constructor
command GravityParticle
   # put the short name of this me && param(0) && the id of the target & cr after msg
end GravityParticle

command destructor
   local tSuperClass
   put the behavior of this me into tSuperClass
   --
   # do the local destructor tasks first
   # put the short name of this me && param(0) && the id of the target & cr after msg
   --
   # then pass up the message chain
   if tSuperClass is not empty then
      pass destructor
   end if
end destructor

command birth pX, pY, pdX, pdY, pLifeSpan, pParticleSource, pGravity
   if pGravity is empty then
      set the gravity of me to 1
   else
      set the gravity of me to pGravity
   end if
   pass birth
end birth

command animate
   set the dy of me to the dy of me + _gravity
   -- or if messages need to be locked...
   --set the dy of me to dy() + _gravity
   # Call superclass animate
   pass animate
end animate

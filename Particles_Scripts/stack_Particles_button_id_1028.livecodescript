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

--command constructor
--   put the id of the target && the id of this me && param(0) & cr after msg
--end constructor

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

on birth pX, pY, pdX, pdY, pLifeSpan, pParticleSource, pGravity
   --put the id of the target && the id of this me && param(0) & cr after msg
   if pGravity is empty then
      set the gravity of me to random(16)
   else
      set the gravity of me to pGravity
   end if
   pass birth
end birth

on animate
   --put the id of the target && the id of this me && param(0) & cr after msg
   set the dy of me to the dy of me + _gravity
   # Call superclass animate
   pass animate
end animate

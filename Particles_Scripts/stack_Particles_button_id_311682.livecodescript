Script "stack_Particles_button_id_311682"

/*
# Name: button "FuzzyGravityParticle" of card "Classes" of stack "Particles"
# ID: button id 311682 of card id 1004 of stack "Particles"
# Behavior: button id 1028 of stack "Particles"
*/


###############################################################
#
# Class: FuzzyGravity
# Inherits: GravityParticle
#
# overrides birth and animate and adds a new property "fuzziness"

local _fuzziness
local _fuzziness2

setProp fuzziness pFuzziness
   if pFuzziness is a number then
      put pFuzziness into _fuzziness
      put round(_fuzziness/2+0.5) into _fuzziness2 # Fuzziness half rounded up
   end if
end fuzziness

getProp fuzziness
   return _fuzziness
end fuzziness

on birth pX, pY, pdX, pdY, pLifeSpan, pParticleSource, pFuzziness
   --put the id of the target && the id of this me && param(0) & cr after msg
   if pfuzziness is empty then
      set the fuzziness of me to 6
   else
      set the fuzziness of me to pFuzziness
   end if
   pass birth
end birth

on animate
   --put the id of the target && the id of this me && param(0) & cr after msg
   set the dy of me to the dy of me + random(_fuzziness)-_fuzziness2
   set the dx of me to the dx of me + random(_fuzziness)-_fuzziness2
   # Call superclass
   pass animate
end animate

Script "stack_Particles_button_id_183672"

/*
# Name: button "FuzzyParticle" of card "Classes" of stack "Particles"
# ID: button id 183672 of card id 1004 of stack "Particles"
# Behavior: button id 1022 of stack "Particles"
*/


###############################################################
#
# Class: Fuzziness
# Inherits: Particle
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
   dispatch "birth" to the behavior of me with px, py, pdX, pdY, pLifeSpan, pParticleSource
   if pfuzziness is empty then
      set the fuzziness of me to 6
   else
      set the fuzziness of me to pFuzziness
   end if
end birth

on animate
   set the dy of me to the dy of me + random(_fuzziness)-_fuzziness2
   set the dx of me to the dx of me + random(_fuzziness)-_fuzziness2
   # Call superclass animate
   --dispatch "animate" to the owner of me
   dispatch "animate" to the behavior of me
end animate

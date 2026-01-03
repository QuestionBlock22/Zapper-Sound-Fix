# Play the Shock State Sound When Hit by Koopa Zappers (QB22)

# Optimized by Vega.

# Inject @
# PAL   : 806aa1ac
# NTSC-U: 806a5d24
# NTSC-J: 806a9818
# NTSC-K: 80698554

.set region, '' # Fill with P, E, J, or K in the quotes to assemble for a particular region.

.if (region == 'P' || region == 'p')     # PAL/Europe
    .set getSnd, 0x80590794
    .set floatBase, 0x808A
    .set floatArg, -0x2960
.elseif (region == 'E' || region == 'e') # NTSC-U/North America
    .set getSnd, 0x80589F70
    .set floatBase, 0x808A
    .set floatArg, -0x7030
.elseif (region == 'J' || region == 'j') # NTSC-J/Japan
    .set getSnd, 0x80590114
    .set floatBase, 0x808A
    .set floatArg, -0x3800
.elseif (region == 'K' || region == 'k') # NTSC-K/Korea
    .set getSnd, 0x8057E7EC
    .set floatBase, 0x8089
    .set floatArg, -0x4500
.else
    .err
.endif

# Set the upper bits of the function "KartObjectProxy::getSnd."
lis r12, getSnd@h

# Original instruction
stb r0, 0x9 (r30)

# Call the function.
ori r12, r12, getSnd@l
lwz r3, 0x118 (r30)
mtctr r12
bctrl

# Load the sound ID for the shock state sound effect and call the sound playback function.
lis r4, floatBase
lwz r12, 0 (r3)
lfs f1, floatArg (r4)
lwz r12, 0x00E8 (r12)
li r4, 0x117
mtctr r12
bctrl

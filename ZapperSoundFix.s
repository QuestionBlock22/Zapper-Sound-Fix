# Play the Shock State Sound When Hit by Koopa Zappers (QB22)

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
.else # Invalid Region
    .err
.endif

stb r0, 0x9 (r30)                                       # Original instruction

# Everything below is a copy of code that already exits in-game (at address 806a9d0c in the PAL version), modified for compatibility with the Gecko Code Loader. As such, documentation will be pretty sparse or inaccurate.

# Call the function "KartObjectProxy::getSnd."
lwz r3, 0x0118 (r30)                                    # Load the function argument.
mflr r14                                                # Backup the link register.
lis r15, getSnd@h
ori r15, r15, getSnd@l
mtlr r15
blrl
mtlr r14                                                # Restore the link register.

lwz r12, 0 (r3)                                         # Load base address from register 3.
lis r4, floatBase
lfs f1, floatArg (r4)

# Load the sound ID for the shock state sound effect.
li r4, 0x117

# Call the function that will playback the sound.
mfctr r14                                               # Backup the count register
lwz r12, 0x00E8 (r12)                                   # Load a pointer.
mtctr r12
bctrl
mtctr r14                                               # Restore the count register.

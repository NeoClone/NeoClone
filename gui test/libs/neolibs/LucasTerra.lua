--12.5, Report bug on Lucas Terra's Library Thread: http://forums.tibianeobot.com/showthread.php?1013
LUCAS_LIB = '12.5'
print('Lucas Terra Library Version: '..LUCAS_LIB)

-- Item Properties
ITEM_NOTROOFEDGE = 0
ITEM_TOPORDER1 = 1 --always on top
ITEM_TOPORDER2 = 2 --walktrough (doors)
ITEM_TOPORDER3 = 3 --walktrough (arcs)
ITEM_CONTAINER = 4
ITEM_STACKABLE = 5
ITEM_CORPSE = 6
ITEM_USEABLE = 7
ITEM_WRITEABLE = 8
ITEM_READABLE = 9
ITEM_FLUIDCONTAINER = 10
ITEM_SPLASH = 11
ITEM_BLOCKWALK = 12
ITEM_NOTMOVEABLE = 13
ITEM_BLOCKSHOTS = 14
ITEM_BLOCKPATHS = 15
ITEM_PICKUPABLE = 16
ITEM_HANGABLE = 17
ITEM_HORIZONTAL = 18
ITEM_VERTICAL = 19
ITEM_ROTATEABLE = 20
ITEM_LIGHTFONT = 21
ITEM_UNKNOWN = 22
ITEM_FLOORCHANGE = 23
ITEM_OFFSET = 24
ITEM_HEIGHTED = 25
ITEM_BIGSPRITE = 26
ITEM_UNEXIST = 27
ITEM_MINIMAP = 28
ITEM_ACTION = 29
ITEM_GROUND = 30
ITEM_DIAGONALBORDER,ITEM_BORDER = 31,31

-- Credits to Anonymickey, for testing the msg types
MSG_STATUS = 0 -- Status messages (In the screen).
MSG_DEFAULT = 1 -- Any player/npc message in Default channel.
MSG_WHISPER = 2 -- Any player whispering.
MSG_YELL = 3 -- Any player yelling.
MSG_NPC = 5 -- Any NPC answers in NPC channel.
MSG_PVT = 6 -- Private messages from other players.
MSG_CHANNEL = 7 -- Any player message in Game/Help/Real/Tutor/Trade channel.
MSG_RED = 15 -- Red alert messages.
MSG_RAID,MSG_ADVANCE = 16,16 -- Any white alert message.
MSG_WELCOME = 17 -- Game/Channel welcome messages.
MSG_STATUSLOG = 18 -- Status messages in Server Log.
MSG_INFO = 19 -- Green messages (like loot message) in Server Log.
MSG_SENT = 21 -- Private messages sent by you.

-- Skull Types
SKULL_NOSKULL = 0 
SKULL_YELLOW = 1
SKULL_GREEN = 2
SKULL_WHITE = 3
SKULL_RED = 4
SKULL_BLACK = 5
SKULL_ORANGE = 6

-- WarBanner Types
WAR_NOWAR = 0
WAR_GREEN = 1 --Friend
WAR_RED = 2 --Enemy
WAR_BLUE = 3 --In a War that you're not fighting

-- Party Types
PARTY_NOPARTY = 0
PARTY_INVITED_LEADER = 1 -- Leader inviting you to party
PARTY_INVITED_MEMBER = 2 -- Member invited to party
PARTY_ONPARTY_MEMBER = 3 -- Member of a party
PARTY_ONPARTY_LEADER = 4 -- Leader of the party
PARTY_EXPSHARE_OK_MEMBER = 5 -- Exp Share Working Fine, member of a party
PARTY_EXPSHARE_OK_LEADER = 6 -- Exp Share Working Fine, leader of the party
PARTY_EXPSHARE_WAIT_MEMBER = 7 -- Exp Share on standby, member of a party
PARTY_EXPSHARE_WAIT_LEADER = 8 -- Exp Share on standby, leader of the party
PARTY_EXPSHARE_OFF_MEMBER = 9 -- Exp Disabled because of a low level char or player in different floor, member of a party
PARTY_EXPSHARE_OFF_LEADER = 10 -- Exp Disabled because of a low level char or player in different floor, leader of the party

ASCII = {'', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ' ', '!', '"', '#', '$', '%', '&', "'", '(', ')', '*', '+', ',', '-', '.', '/', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ':', ';', '<', '=', '>', '?', '@', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '[', '', ']', '^', '_', '`', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '{', '|', '}', '~'}

-- Rune IDs
RUNE_SD = 3155
RUNE_UH = 3160
RUNE_IH = 3152
RUNE_HMM = 3198
RUNE_ICICLE = 3158
RUNE_STALAGMITE = 3179
RUNE_FIREBALL = 3189
RUNE_LMM = 3174
RUNE_HOLY = 3182
RUNE_MWALL = 3180
RUNE_GROWTH = 3156
RUNE_PARALYZE = 3165
RUNE_GFB = 3191
RUNE_AVALANCHE = 3161
RUNE_STONESHOWER = 3175
RUNE_THUNDERSTORM = 3202
RUNE_EXPLO = 3200
RUNE_SOULFIRE = 3195

SCREEN_LEFT = -8
SCREEN_TOP = -6
SCREEN_BOTTOM = 7
SCREEN_RIGHT = 9

GLOBAL_BALANCE = 0
GLOBAL_HUNGRY = 0

TEAM_NOTEAM = 0
TEAM_SELF = 1
TEAM_FRIEND = 2
TEAM_ENEMY = 3
TEAM_LEADER = 4

_CREATUREPROPERTIES = {'name', 'id', 'posx', 'posy', 'posz', 'dir', 'outfit', 'color1', 'color2', 'color3', 'color4', 'addons', 'mount', 'lightintensity', 'lightcolor', 'hppc', 'speed', 'updated', 'skull', 'party', 'warbanner', 'dist', 'ignored', 'ismonster', 'isplayer', 'isshootable', 'lastattacked'}
local shields = {3409, 3410, 3411, 3412, 3413, 3414, 3415, 3416, 3417, 3418, 3419, 3420, 3421, 3422, 3423, 3424, 3425, 3426, 3427, 3428, 3429, 3430, 3431, 3432, 3433, 3434, 3435, 3436, 3437, 3438, 3439, 3440, 3441, 3442, 3443, 3444, 3445, 6131, 6390, 6432, 7460, 8077, 8078, 8079, 8080, 8081, 9372, 9372, 9377, 9380, 9401, 11688}
local spellbooks = {3059, 8072, 8073, 8074, 8075, 8076, 8090, 11691}
local axes = {665, 666, 667, 668, 669, 684, 685, 686, 687, 688, 783, 785, 786, 787, 788, 801, 802, 803, 804, 805, 3266, 3268, 3269, 3274, 3275, 3276, 3293, 3302, 3303, 3306, 3313, 3314, 3315, 3316, 3317, 3318, 3319, 3320, 3323, 3328, 3329, 3331, 3335, 3342, 3344, 3346, 6553, 7380, 7388, 7389, 7411, 7412, 7413, 7419, 7420, 7433, 7434, 7435, 7436, 7453, 7454, 7455, 7456, 7773, 8096, 8097, 8098, 9384, 10388, 10406, 11657}
local clubs = {670, 671, 672, 673, 674, 689, 690, 691, 692, 693, 789, 790, 791, 792, 793, 806, 807, 808, 809, 810, 3208, 3270, 3279, 3282, 3286, 3289, 3304, 3305, 3309, 3310, 3311, 3312, 3321, 3322, 3324, 3325, 3327, 3332, 3333, 3336, 3337, 3340, 3341, 3343, 3348, 3453, 7379, 7381, 7387, 7392, 7409, 7410, 7414, 7415, 7421, 7422, 7423, 7424, 7425, 7426, 7427, 7428, 7429, 7430, 7431, 7432, 7437, 7450, 7451, 7452, 8099, 8100, 8101, 9373, 9385, 10391}
local swords = {660, 661, 662, 663, 664, 679, 680, 681, 682, 683, 779, 780, 781, 782, 783, 794, 795, 796, 797, 798, 3264, 3265, 3267, 3271, 3272, 3273, 3278, 3280, 3281, 3283, 3284, 3285, 3288, 3290, 3291, 3292, 3294, 3295, 3296, 3297, 3299, 3300, 3301, 3307, 3308, 3326, 3330, 3334, 3338, 3339, 3345, 6101, 6527, 7382, 7383, 7384, 7385, 7386, 7390, 7391, 7402, 7403, 7404, 7405, 7406, 7407, 7408, 7416, 7417, 7418, 7449, 7774, 8102, 8103, 8104, 9375, 9386, 9387, 9396, 10389, 10390, 10392, 11693}
local distone = {1781, 2992, 3277, 3287, 3298, 3347, 7366, 7367, 7368, 7378}
local bows = {3349, 3350, 5803, 5907, 7438, 8021, 8022, 8023, 8024, 8025, 8026, 8027, 8028, 8029, 8030, 9378}
local wands = {3071, 3072, 3073, 3074, 3075, 8092, 8093, 8094}
local rods = {3065, 3066, 3067, 3069, 3070, 8082, 8083, 8084}
local ammos = {761, 762, 763, 774, 3446, 3447, 3448, 3449, 3450, 6528, 7363, 7364, 7365}
local ropes = {646, 3003, 9594, 9596, 9598}
local shovels = {3457, 5710, 9594, 9596, 9598}
local machetes = {3308, 3330, 9594, 9596, 9598}
local picks = {3456, 9594, 9596, 9598}
local eatfoodids = {3577, 3578, 3579, 3580, 3581, 3582, 3583, 3584, 3585, 3586, 3587, 3588, 3589, 3590, 3591, 3592, 3593, 3594, 3595, 3596, 3597, 3598, 3599, 3600, 3601, 3602, 3606, 3607, 3723, 3724, 3725, 3726, 3727, 3728, 3729, 3730, 3731, 3732, 3910, 3911, 3912, 3913, 3914, 3915, 3916, 3917, 3918, 3919, 3920, 5678, 8010}
local foods = {{169, 108}, {836, 48}, {841, 48}, {901, 720}, {904, 180}, {3577, 180}, {3578, 144}, {3579, 120}, {3580, 204}, {3581, 48}, {3582, 360}, {3583, 720}, {3584, 60}, {3585, 72}, {3586, 156}, {3587, 96}, {3588, 12}, {3589, 216}, {3590, 12}, {3591, 24}, {3592, 108}, {3593, 240}, {3594, 204}, {3595, 60}, {3596, 72}, {3597, 108}, {3598, 24}, {3599, 24}, {3600, 120}, {3601, 36}, {3602, 96}, {3606, 72}, {3607, 108}, {3723, 108}, {3724, 48}, {3725, 264}, {3726, 360}, {3727, 108}, {3728, 72}, {3729, 144}, {3730, 36}, {3731, 432}, {3732, 60}, {5096, 48}, {5678, 96}, {6125, 96}, {6277, 120}, {6278, 180}, {6392, 144}, {6393, 180}, {6500, 240}, {6541, 72}, {6542, 72}, {6543, 72}, {6544, 72}, {6545, 72}, {6569, 12}, {6574, 60}, {7158, 300}, {7159, 180}, {7372, 24}, {7373, 24}, {7375, 24}, {7377, 24}, {8010, 120}, {8011, 60}, {8012, 12}, {8013, 12}, {8014, 84}, {8015, 60}, {8016, 12}, {8017, 60}, {8019, 132}, {8177, 88}, {8197, 60}, {10219, 120}, {10329, 180}, {10453, 36}, {11459, 240}, {11460, 120}, {11461, 96}, {11462, 108}, {11681, 660}, {11682, 216}, {11683, 24}, {12310, 240}}
local healthpots = {236, 239, 266, 7642, 7643, 7876}
local manapots = {237, 238, 268, 7642}
local rustyequips = {8891, 8892, 8893, 8894, 8895, 8896, 8897, 8898, 8899, 8900, 8901, 8902, 8903, 8904, 8905, 8906, 8907, 8908}
local closeddoorsids = {1628, 1629, 1631, 1632, 1638, 1640, 1642, 1644, 1646, 1648, 1650, 1651, 1653, 1654, 1656, 1658, 1660, 1662, 1664, 1666, 1668, 1669, 1671, 1672, 1674, 1676, 1678, 1680, 1682, 1683, 1685, 1687, 1689, 1691, 1692, 1694, 1696, 1698, 4912, 4913, 5006, 5007, 5082, 5084, 5097, 5098, 5100, 5102, 5104, 5106, 5107, 5109, 5111, 5113, 5115, 5116, 5118, 5120, 5122, 5124, 5125, 5127, 5129, 5131, 5133, 5134, 5136, 5137, 5139, 5140, 5142, 5143, 5277, 5278, 5280, 5281, 5282, 5285, 5287, 5289, 5291, 5293, 5302, 5303, 5514, 5516, 5745, 5749, 6191, 6192, 6194, 6195, 6197, 6199, 6201, 6203, 6205, 6207, 6248, 6249, 6251, 6252, 6254, 6258, 6260, 6262, 6264, 6435, 6436, 6439, 6440, 6443, 6444, 6449, 6450, 6453, 6454, 6457, 6458, 6461, 6462, 6465, 6466, 6469, 6470, 6788, 6789, 6891, 6892, 6894, 6896, 6898, 6900, 6901, 6903, 6905, 6907, 7027, 7028, 7033, 7034, 7036, 7038, 7040, 7042, 7043, 7045, 7047, 7049, 7051, 7052, 7711, 7712, 7714, 7715, 7717, 7719, 7721, 7723, 7725, 7727, 7868, 7941, 8249, 8250, 8252, 8253, 8255, 8257, 8258, 8261, 8263, 8265, 8351, 8352, 8354, 8355, 8357, 8359, 8361, 8363, 8365, 8367, 9347, 9348, 9351, 9352, 9354, 9355, 9357, 9359, 9361, 9363, 9365, 9367, 9551, 9552, 9554, 9556, 9558, 9560, 9561, 9563, 9565, 9567, 9571, 9572, 9858, 9859, 9863, 9865, 9867, 9868, 9872, 9874, 10147, 10149, 10151, 10153, 10155, 10157, 10520, 10521, 11232, 11233, 11237, 11239, 11241, 11242, 11246, 11248, 11705}
--  				   {1628, 1629, 1631, 1632, 1638, 1640, 1650, 1651, 1653, 1654, 1656, 1658, 1668, 1669, 1671, 1672, 1682, 1683, 1685, 1691, 1692, 1694, 4912, 4913, 5006, 5007, 5082, 5084, 5097, 5098, 5100, 5106, 5107, 5109, 5115, 5116, 5118, 5124, 5125, 5127, 5133, 5134, 5136, 5137, 5139, 5140, 5142, 5143, 5277, 5278, 5280, 5281, 5283, 5285, 5514, 5516, 5732, 5733, 5735, 5736, 6191, 6192, 6194, 6195, 6197, 6199, 6248, 6249, 6251, 6252, 6254, 6256, 6891, 6892, 6894, 6900, 6901, 6903, 7033, 7034, 7036, 7042, 7043, 7045, 7054, 7056, 7711, 7712, 7714, 7715, 7717, 7719, 8249, 8250, 8252, 8253, 8255, 8257, 8351, 8352, 8354, 8355, 8357, 8359, 9351, 9352, 9354, 9355, 9357, 9359, 9551, 9552, 9554, 9560, 9561, 9563, 9858, 9859, 9867, 9868, 11136, 11137, 11143, 11144, 11232, 11233, 11241, 11242, 11705, 11714, 12033, 12035, 12249, 12250}
local openeddoorsids = {1630, 1633, 1639, 1641, 1643, 1645, 1647, 1649, 1652, 1655, 1657, 1659, 1661, 1663, 1665, 1667, 1670, 1673, 1675, 1677, 1679, 1681, 1684, 1686, 1688, 1690, 1693, 1695, 1697, 1699, 2178, 2180, 4911, 4914, 5083, 5085, 5099, 5101, 5103, 5105, 5108, 5110, 5112, 5114, 5117, 5119, 5121, 5123, 5126, 5128, 5130, 5132, 5135, 5138, 5141, 5144, 5279, 5282, 5284, 5286, 5288, 5290, 5292, 5294, 5515, 5117, 5746, 5748, 6193, 6196, 6198, 6200, 6202, 6204, 6206, 6208, 6250, 6253, 6255, 6257, 6259, 6261, 6263, 6265, 6893, 6895, 6897, 6899, 6902, 6904, 6906, 6908, 7035, 7037, 7039, 7041, 7044, 7046, 7048, 7050, 7713, 7716, 7718, 7720, 7722, 7724, 7726, 7728, 7869, 8251, 8254, 8256, 8258, 8260, 8262, 8264, 8266, 8353, 8356, 8358, 8360, 8362, 8364, 8366, 8368, 9353, 9356, 9358, 9360, 9362, 9364, 9366, 9368, 9553, 9555, 9557, 9559, 9562, 9564, 9566, 9568, 9860, 9864, 9866, 9869, 9873, 9875, 11234, 11238, 11240, 11243, 11247, 11249, 11708}
--					   {1630, 1633, 1639, 1641, 1652, 1655, 1657, 1659, 1670, 1673, 1684, 1686, 1693, 1695, 4911, 4914, 5083, 5085, 5099, 5101, 5108, 5110, 5117, 5119, 5126, 5128, 5135, 5138, 5141, 5144, 5279, 5282, 5284, 5286, 5515, 5517, 5734, 5737, 6193, 6196, 6198, 6200, 6250, 6253, 6255, 6257, 6893, 6895, 6902, 6904, 7035, 7037, 7044, 7046, 7055, 7057, 7713, 7716, 7718, 7720, 8251, 8254, 8256, 8258, 8353, 8356, 8358, 8360, 9353, 9356, 9358, 9360, 9553, 9555, 9562, 9564, 9860, 9869, 11138, 11145, 11234, 11243, 11708, 11716, 12034, 12036}
local rashid = {662, 664, 667, 669, 672, 680, 681, 683, 686, 688, 691, 780, 781, 783, 786, 788, 791, 795, 796, 798, 803, 805, 808, 811, 812, 813, 814, 815, 816, 817, 818, 819, 820, 821, 822, 823, 824, 825, 826, 827, 828, 829, 830, 2991, 3002, 3006, 3007, 3008, 3010, 3016, 3017, 3018, 3019, 3025, 3055, 3063, 3290, 3314, 3315, 3326, 3327, 3328, 3330, 3332, 3333, 3334, 3339, 3340, 3342, 3344, 3356, 3360, 3364, 3366, 3386, 3397, 3404, 3408, 3414, 3420, 3421, 3435, 3436, 3440, 3441, 3442, 3550, 3554, 3556, 5461, 5710, 5741, 5810, 5917, 5918, 6095, 6096, 6131, 6299, 6553, 7379, 7381, 7382, 7383, 7384, 7386, 7387, 7388, 7389, 7402, 7403, 7404, 7408, 7414, 7415, 7418, 7419, 7422, 7424, 7425, 7426, 7427, 7430, 7432, 7437, 7449, 7452, 7456, 7457, 7460, 7461, 7462, 7463, 7464, 8022, 8027, 8045, 8049, 8050, 8052, 8061, 8063, 9013, 9014, 9017, 9302, 9304, 11674}
local greendjinn = {3048, 3051, 3052, 3053, 3054, 3065, 3066, 3067, 3069, 3070, 3078, 3084, 3085, 3097, 3098, 3214, 3281, 3297, 3299, 3307, 3318, 3322, 3324, 3369, 3370, 3371, 3373, 3383, 3384, 3428, 3429, 3432, 3434, 3574, 7407, 7411, 7413, 7419, 7421, 7428, 8082, 8083, 8084}
local bluedjinn = {674, 679, 693, 779, 793, 794, 810, 3046, 3049, 3050, 3056, 3060, 3061, 3062, 3071, 3072, 3073, 3074, 3075, 3079, 3081, 3082, 3083, 3091, 3092, 3093, 3271, 3279, 3280, 3284, 3301, 3302, 3313, 3320, 3380, 3381, 3382, 3385, 3391, 3392, 3415, 3416, 3418, 3419, 3439, 3567, 7391, 7410, 7412, 7436, 7451, 7454, 8092, 8093, 8094}
local creatureproducts = {3044, 4839, 5808, 5876, 5877, 5878, 5879, 5881, 5882, 5883, 5890, 5893, 5894, 5895, 5896, 5897, 5898, 5899, 5900, 5901, 5902, 5905, 5906, 5919, 5920, 5925, 5930, 5943, 5948, 5954, 6535, 6540, 6546, 7290, 7786, 7882, 8031, 8143, 9053, 9054, 9055, 9393, 9606, 9631, 9632, 9633, 9634, 9635, 9636, 9637, 9638, 9639, 9640, 9641, 9642, 9643, 9644, 9645, 9646, 9647, 9648, 9649, 9650, 9651, 9652, 9654, 9655, 9656, 9657, 9658, 9659, 9660, 9661, 9662, 9663, 9664, 9665, 9666, 9667, 9668, 9683, 9684, 9685, 9686, 9688, 9689, 9690, 9691, 9692, 9693, 9694, 10196, 10272, 10273, 10274, 10275, 10276, 10277, 10278, 10279, 10280, 10281, 10282, 10283, 10289, 10291, 10292, 10293, 10295, 10296, 10297, 10298, 10299, 10300, 10301, 10302, 10303, 10304, 10305, 10306, 10307, 10308, 10309, 10310, 10311, 10312, 10313, 10314, 10315, 10316, 10317, 10318, 10319, 10320, 10321, 10397, 10404, 10405, 10407, 10408, 10409, 10410, 10411, 10413, 10414, 10415, 10416, 10417, 10418, 10420, 10444, 10449, 10450, 10452, 10454, 10455, 10456, 11443, 11444, 11445, 11446, 11447, 11448, 11449, 11450, 11451, 11452, 11453, 11454, 11455, 11456, 11457, 11458, 11463, 11464, 11465, 11466, 11467, 11469, 11470, 11471, 11472, 11473, 11474, 11475, 11476, 11477, 11478, 11479, 11480, 11481, 11482, 11483, 11484, 11485, 11486, 11487, 11488, 11489, 11490, 11491, 11492, 11493, 11510, 11511, 11512, 11513, 11514, 11515, 11539, 11658, 11659, 11660, 11661, 11666, 11671, 11672, 11673, 11680, 11684, 11702, 11703, 12172, 12312, 12313, 12314, 12601, 12742, 12805}
--left: cavebear skull, draptor scales, giant crab pincer, maxilla, panther head, panther paw, coal (nuggets), demonic finger, eye of a deepling, flintstone, white deer skin
local backpackstring = {'brown backpack', 'beach backpack', 'blue backpack', 'brocade backpack', 'camouflage backpack', 'crown backpack', 'demon backpack', 'dragon backpack', 'expedition backpack', 'fur backpack', 'golden backpack', 'green backpack', 'grey backpack', 'heart backpack', 'minotaur backpack', 'moon backpack', 'orange backpack', 'pirate backpack', 'purple backpack', 'red backpack', 'santa backpack', 'yellow backpack', 'backpack of holding', 'jewelled backpack'}
local backpacks = {2854, 5949, 2869, 8860, 2872, 9605, 9601, 10326, 10324, 7342, 2871, 2865, 2870, 10202, 10327, 9604, 9602, 5926, 2868, 2867, 10346, 2866, 3253, 5801}

function swap(a,b,c)
	local t
	if type(a) == 'table' then
		t = a[b]
		a[b]=a[c]
		a[c]=t
	else
		t=a
		a=b
		b=t
	end
end

function qs1(tablename, left, right)
	if type(tablename) == 'table' then
		left = left or 1
		right = right or #tablename
		local i,j,x
		if right-left+1 <= 25 then
			for i=left+1, right do
				x=tablename[i]
				j=i-1
				while j>=left and x<tablename[j] do
					tablename[j+1]=tablename[j]
					j=j-1
				end
				tablename[j+1]=x
			end
		else
			i,j,x = left, right, tablename[math.floor((left+right)/2)]
			local temp
			repeat
				while tablename[i]<x and i < right do
					i = i+1
				end
				while tablename[j]>x and j > left do
					j = j-1
				end
				if (i <= j) then
					temp = tablename[i]
					tablename[i] = tablename[j]
					tablename[j] = temp
					i = i+1
					j = j-1
				end
			until i > j
			if (left < j) then
				qs1(tablename, left, j)
			end
			if (right > i) then
				qs1(tablename, i, right)
			end
		end
	end
end

function qs2(tablename, left, right, argument)
	if type(tablename) == 'table' then
		left = left or 1
		right = right or #tablename
		local i,j,x
		if right-left+1 <= 25 then
			for i=left+1, right do
				x=tablename[i]
				j=i-1
				while j>=left and x[argument] < tablename[j][argument] do
					tablename[j+1]=tablename[j]
					j=j-1
				end
				tablename[j+1]=x
			end
		else
			i,j,x = left, right, tablename[math.floor((left+right)/2)][argument]
			local temp
			repeat
				while tablename[i][argument]<x and i < right do
					i = i+1
				end
				while tablename[j][argument]>x and j > left do
					j = j-1
				end
				if (i <= j) then
					temp = tablename[i]
					tablename[i] = tablename[j]
					tablename[j] = temp
					i = i+1
					j = j-1
				end
			until i > j
			if (left < j) then
				qs2(tablename, left, j, argument)
			end
			if (right > i) then
				qs2(tablename, i, right, argument)
			end
		end
	end
end

function qs3(tablename, left, right)
	if type(tablename) == 'table' then
		left = left or 1
		right = right or #tablename
		local i,j,x
		if right-left+1 <= 25 then
			for i=left+1, right do
				x=tablename[i]
				j=i-1
				while j>=left and x>tablename[j] do
					tablename[j+1]=tablename[j]
					j=j-1
				end
				tablename[j+1]=x
			end
		else
			i,j,x = left, right, tablename[math.floor((left+right)/2)]
			local temp
			repeat
				while tablename[i]>x and i < right do
					i = i+1
				end
				while tablename[j]<x and j > left do
					j = j-1
				end
				if (i <= j) then
					temp = tablename[i]
					tablename[i] = tablename[j]
					tablename[j] = temp
					i = i+1
					j = j-1
				end
			until i > j
			if (left < j) then
				qs3(tablename, left, j)
			end
			if (right > i) then
				qs3(tablename, i, right)
			end
		end
	end
end

function qs4(tablename, left, right, argument)
	if type(tablename) == 'table' then
		left = left or 1
		right = right or #tablename
		local i,j,x
		if right-left+1 <= 25 then
			for i=left+1, right do
				x=tablename[i]
				j=i-1
				while j>=left and x[argument]>tablename[j][argument] do
					tablename[j+1]=tablename[j]
					j=j-1
				end
				tablename[j+1]=x
			end
		else
			i,j,x = left, right, tablename[math.floor((left+right)/2)][argument]
			local temp
			repeat
				while tablename[i][argument]>x and i < right do
					i = i+1
				end
				while tablename[j][argument]<x and j > left do
					j = j-1
				end
				if (i <= j) then
					temp = tablename[i]
					tablename[i] = tablename[j]
					tablename[j] = temp
					i = i+1
					j = j-1
				end
			until i > j
			if (left < j) then
				qs4(tablename, left, j, argument)
			end
			if (right > i) then
				qs4(tablename, i, right, argument)
			end
		end
	end
end

function bin1(tablename,value)
	if type(tablename) == 'table' then
		local left,right = 1, #tablename
		while left <= right do
			local mid = math.floor((right+left)/2)
			if tablename[mid] == value then
				return mid
			end
			if tablename[mid] > value then
				right = mid-1
			else
				left = mid+1
			end
		end
	end
	return
end

function bin2(tablename,value,argument)
	if type(tablename) == 'table' then
		local left,right = 1, #tablename
		while left <= right do
			local mid = math.floor((right+left)/2)
			if tablename[mid][argument] == value then
				return mid
			end
			if tablename[mid][argument] > value then
				right = mid-1
			else
				left = mid+1
			end
		end
	end
	return
end

function seq1(tablename,value)
	if type(tablename) == 'table' then
		for i,j in ipairs(tablename) do
			if j == value then
				return i
			end
		end
	end
	return
end

function seq2(tablename,value,argument)
	if type(tablename) == 'table' then
		for i,j in ipairs(tablename) do
			if j[argument] == value then
				return i
			end
		end
	end
	return
end

function table:newsort(argument, order) --Working
	if argument == 'asc' or argument == 'desc' then
		order = argument
		argument = false
	end
	order = order or 'asc'
	if order == 'asc' then
		if argument then
			qs2(self,1,#self,argument)
		else
			qs1(self,1,#self)
		end
	else
		if argument then
			qs4(self,1,#self,argument)
		else
			qs3(self,1,#self)
		end
	end
end

function table:find(value,argument) --Working
	if argument then
		return seq2(self,value,argument)
	end
	return seq1(self,value)
end

function table:findcreature(m,arg)
	if type(m) == 'userdata' then
		local name = m.name:lower()
		if not arg then
			for i,j in ipairs(self) do
				if name == j or m.id == j or m == j then
					return i
				end
			end
		else
			for i,j in ipairs(self) do
				if name == j[arg] or m.id == j[arg] or m == j[arg] then
					return i
				end
			end
		end
	end
end

function table:binaryfind(value,argument) --Working
	if argument then
		return bin2(self,value,argument)
	end
	return bin1(self,value)
end

function usedoor(x,y,z,a)
	x,y,z = x or $wptx, y or $wpty, z or $wptz
	if not (x and y and z and tilereachable(x,y,z)) then
		return false
	end
	reachlocation(x,y,z)
	local doorid, tileinfo = 0
	local topid = topitem(x,y,z).id
	local pos
	if not a then
		pos = table.binaryfind(closeddoorsids,topid)
		if pos then
			a = 'open'
			doorid = closeddoorsids[pos]
		else
			pos = table.binaryfind(openeddoorsids,topid)
			if pos then
				a = 'close'
				doorid = openeddoorsids[pos]
			else
				return false
			end
		end
	else
		if a == 'open' then
			pos = table.binaryfind(closeddoorsids,topid)
			if not pos then return false end
			doorid = closeddoorsids[pos]
		elseif a == 'close' then
			pos = table.binaryfind(openeddoorsids,topid)
			if not pos then return false end
			doorid = openeddoorsids[pos]
		end
	end
	if a == 'open' then
		while true do
			useitem(topid,ground(x,y,z)) waitping()
			topid = topitem(x,y,z).id
			if not (topid == 2179 or topid == 2177 or topid == doorid) then
				return true
			end
		end
	elseif a == 'close' then
		local doorpos
		tileinfo = gettile(x,y,z)
		for i=1, tileinfo.itemcount do
			if tileinfo.item[i].id == doorid then
				doorpos = i
				break
			end
		end
		while true do
			for i=tileinfo.itemcount,1,-1 do
				local infoid = tileinfo.item[i].id
				if infoid ~= 99 and not itemproperty(infoid, ITEM_NOTMOVEABLE) then
					printerror('There is an item above this door, Neobot is unable to move items above a door.')
					return false
				--elseif infoid == 99 then
				--	printerror('There is a player above this door, Neobot is unable to move players above a door.')
				--	return false
				end
			end
			useitem(topid,ground(x,y,z)) waitping()
			tileinfo = gettile(x,y,z)
			topid = tileinfo.item[doorpos].id
			if topid ~= doorid then
				return true
			end
		end
	end
end

function findweapon()
	for i,j in ipairs(axes) do
		if (j == $rhand.id) then 
			return 'rhand', $rhand
		end
		if (j == $lhand.id) then 
			return 'lhand', $lhand
		end
	end
	for i,j in ipairs(swords) do
		if (j == $rhand.id) then 
			return 'rhand', $rhand
		end
		if (j == $lhand.id) then 
			return 'lhand', $lhand
		end
	end
	for i,j in ipairs(clubs) do
		if (j == $rhand.id) then 
			return 'rhand', $rhand
		end
		if (j == $lhand.id) then 
			return 'lhand', $lhand
		end
	end
	for i,j in ipairs(distone) do
		if (j == $rhand.id) then 
			return 'rhand', $rhand
		end
		if (j == $lhand.id) then 
			return 'lhand', $lhand
		end
	end
	for i,j in ipairs(wands) do
		if (j == $rhand.id) then 
			return 'rhand', $rhand
		end
		if (j == $lhand.id) then 
			return 'lhand', $lhand
		end
	end
	for i,j in ipairs(rods) do
		if (j == $rhand.id) then 
			return 'rhand', $rhand
		end
		if (j == $lhand.id) then 
			return 'lhand', $lhand
		end
	end
	for i,j in ipairs(bows) do
		if (j == $rhand.id) then 
			return 'rhand', $rhand
		end
		if (j == $lhand.id) then 
			return 'lhand', $lhand
		end
	end
	if (0 == $rhand.id) then 
		return 'rhand', $rhand
	end
	if (0 == $lhand.id) then 
		return 'lhand', $lhand
	end
end

function findweapontouse()
	local where,id = nil,0
	if id == 0 then
		for i,j in ipairs(axes) do if itemcount(j) > 0 then id = j end end
	end
	if id == 0 then
		for i,j in ipairs(swords) do if itemcount(j) > 0 then id = j end end
	end
	if id == 0 then
		for i,j in ipairs(clubs) do if itemcount(j) > 0 then id = j end end
	end
	if clientitemhotkey(id) == 'not found' then
		if $rhand.id == id then
			where = 'rhand'
		elseif $lhand.id == id then
			where = 'lhand'
		else
			where = ''
		end
	end
	return where, id
end

function findweapontype()
	for i,j in ipairs(axes) do
		if (j == $rhand.id) or (j == $lhand.id) then return 'axe' end
	end
	for i,j in ipairs(swords) do
		if (j == $rhand.id) or (j == $lhand.id) then return 'sword' end
	end
	for i,j in ipairs(clubs) do
		if (j == $rhand.id) or (j == $lhand.id) then return 'club' end
	end
	for i,j in ipairs(wands) do
		if (j == $rhand.id) or (j == $lhand.id) then return 'wand' end
	end
	for i,j in ipairs(rods) do
		if (j == $rhand.id) or (j == $lhand.id) then return 'rod' end
	end
	for i,j in ipairs(bows) do
		if (j == $rhand.id) or (j == $lhand.id) then return 'bow' end
	end
	for i,j in ipairs(distone) do
		if (j == $rhand.id) or (j == $lhand.id) then return 'distance weapon' end
	end
	return 'no weapon'
end

function findshield()
	local hand = ''
	for i,j in ipairs(spellbooks) do
		if (j == $rhand.id) then
			return 'rhand', $rhand
		end
		if (j == $lhand.id) then
			return 'lhand', $lhand
		end
	end
	for i,j in ipairs(shields) do
		if (j == $rhand.id) then
			return 'rhand', $rhand
		end
		if (j == $lhand.id) then
			return 'lhand', $lhand
		end
	end
	if $rhand.id == 0 then
		return 'rhand', $rhand
	end
	if $lhand.id == 0 then
		return 'lhand', $lhand
	end
end

function getbestspell(name, type)
	if type == 'strong strike' then
		return beststrongstrike(name)
	else
		return beststrike(name)
	end
end

function bestruneelement(creaturename, disconsiderdamage) --credits to Hardek.
    if creaturename == '' then return nil end
    local cre = creatureinfo(creaturename)
    voc = voc or vocation()
    strongonly = strongonly or false
    local best = ''
    local max = 0
    local elements = {ice = ($level*0.2)+($mlevel*2.4)+14, fire = ($level*0.2)+($mlevel*2.4)+14, earth = ($level*0.2)+($mlevel*1.2)+7, energy = ($level*0.2)+($mlevel*1.2)+7}
	if disconsiderdamage then
		elements = {ice = 0, fire = 0, earth = 0, energy = 0}
	end
	for i,j in pairs(elements) do
        if cre[i..'mod']*j >= max then
            max = cre[i..'mod']*j
            best = i
        end
    end
    return best
end

function caststrike(a,b)
	if $attacked.id > 0 then
		local belement
		if $attacked.isplayer then
			belement = 'fire'
		else
			belement = bestelement($attacked.name, false)
		end
		a,b = a or 900, b or 1100
		if belement then
			local bspell = 'exori '..getelementword(belement)
			if cooleddown(bspell) and $mp >= 20 and $attacked.hppc > 0 and $attacked.dist <= 3 and $attacked.isshootable then
				cast(bspell)
				wait(a,b)
				return true
			end
		end
	end
	return false
end

function castultimatestrike(a,b,c)
	if $attacked.id > 0 then
		a,b,c = a or 900, b or 1100, c or 75
		local voc = vocation()
		local spell
		if voc == 'druid' then
			if $attacked.ismonster then
				local temp = creatureinfo($attacked.name)
				if temp then
					if cooleddown('ultimate ice strike') and (temp.icemod >= temp.earthmod or not cooleddown('ultimate terra strike')) and (temp.icemod >= c) then
						spell = 'exori max frigo'
					elseif cooleddown('ultimate terra strike') and (temp.earthmod >= temp.icemod or not cooleddown('ultimate ice strike')) and (temp.earthmod >= c) then
						spell = 'exori max tera'
					end
				end
			else
				if cooleddown('ultimate ice strike') then
					spell = 'exori max frigo'
				elseif cooleddown('ultimate terra strike') then
					spell = 'exori max tera'
				end
			end
		elseif voc == 'sorcerer' then
			if $attacked.ismonster then
				local temp = creatureinfo($attacked.name)
				if temp then
					if cooleddown('ultimate energy strike') and (temp.energymod >= temp.firemod or not cooleddown('ultimate flame strike')) and (temp.energymod >= c) then
						spell = 'exori max vis'
					elseif cooleddown('ultimate flame strike') and (temp.firemod >= temp.energymod or not cooleddown('ultimate energy strike')) and (temp.firemod >= c) then
						spell = 'exori max flam'
					end
				end
			else
				if cooleddown('ultimate energy strike') then
					spell = 'exori max vis'
				elseif cooleddown('ultimate flame strike') then
					spell = 'exori max flam'
				end
			end
		end
		if spell and cooleddown(spell)  and $mp >= 60 and $attacked.hppc > 0 and $attacked.dist <= 3 and $attacked.isshootable then
			cast(spell)
			wait(a,b)
			return true
		end
	end
	return false
end

function caststrongstrike(a,b,c)
	if $attacked.id > 0 then
		a,b,c = a or 900, b or 1100, c or 75
		local voc = vocation()
		local spell
		if voc == 'druid' then
			if $attacked.ismonster then
				if temp then
					local temp = creatureinfo($attacked.name)
					if cooleddown('strong ice strike') and (temp.icemod >= temp.earthmod or not cooleddown('strong terra strike')) and (temp.icemod >= c) then
						spell = 'exori gran frigo'
					elseif cooleddown('strong terra strike') and (temp.earthmod >= temp.icemod or not cooleddown('strong ice strike')) and (temp.earthmod >= c) then
						spell = 'exori gran tera'
					end
				end
			else
				if cooleddown('strong ice strike') then
					spell = 'exori gran frigo'
				elseif cooleddown('strong terra strike') then
					spell = 'exori gran tera'
				end
			end
		elseif voc == 'sorcerer' then
			if $attacked.ismonster then
				local temp = creatureinfo($attacked.name)
				if temp then
					if cooleddown('strong energy strike') and (temp.energymod >= temp.firemod or not cooleddown('strong flame strike')) and (temp.energymod >= c) then
						spell = 'exori gran vis'
					elseif cooleddown('strong flame strike') and (temp.firemod >= temp.energymod or not cooleddown('strong energy strike')) and (temp.firemod >= c) then
						spell = 'exori gran flam'
					end
				end
			else
				if cooleddown('strong energy strike') then
					spell = 'exori gran vis'
				elseif cooleddown('strong flame strike') then
					spell = 'exori gran flam'
				end
			end
		end
		if spell and cooleddown(spell)  and $mp >= 60 and $attacked.hppc > 0 and $attacked.dist <= 3 and $attacked.isshootable then
			cast(spell)
			wait(a,b)
			return true
		end
	end
	return false
end

--[[function caststrongstrike(a,b,c)
	if $attacked.name ~= '' then
		local belement, belementmod
		if $attacked.isplayer then
			local voc = vocation()
			if voc == 'druid' then
				if cooleddown('strong ice strike') then
					belement, belementmod = 'ice', 1000
				elseif cooleddown('strong terra strike') then
					belement, belementmod = 'earth', 1000
				end
			elseif voc == 'sorcerer' then
				if cooleddown('strong flame strike') then
					belement, belementmod = 'fire', 1000
				elseif cooleddown('strong energy strike') then
					belement, belementmod = 'energy', 1000
				end
			end
		else
			belement, belementmod = bestelement($attacked.name, true)
		end
		a,b = a or 900, b or 1100
		if belement and (not c or belementmod >= c) then
			local bspell = 'exori gran '..getelementword(belement)
			if cooleddown(bspell) and $mp >= 60 and $attacked.hppc > 0 and $attacked.dist <= 3 and $attacked.isshootable then
				cast(bspell)
				wait(a,b)
				return true
			end
		end
	end
	return false
end--]]

function shootbestrune(a,b,cre,disconsider)
	local runes = {energy = 3174, earth = 3179, fire = 3189, ice = 3158}
	if type(cre) == 'boolean' then
		disconsider = cre
		cre = nil
	end
	cre = cre or $attacked
	a,b = a or 900, b or 1100
	if cre.id ~= 0 then
		useoncreature(runes[bestruneelement(cre.name,disconsider)],cre)
		wait(a,b)
		return true
	end
	return false
end

function findcreature(...)
	local tofind,found = {...},{}
	table.lower(tofind)
	local i=1
	while i <= #tofind do
		local j = tofind[i]
		if type(j) == 'userdata' and j.name and j.name ~= '' then
			table.insert(found,j)
			table.remove(tofind,i)
		else
			i = i+1
		end
	end
	if #tofind > 0 then
		foreach creature p do
			if table.find(tofind,p.name:lower()) or table.find(tofind,p.id) then
				table.insert(found,p)
			end
		end
	end
	return table.unpack(found)
end

function findcreaturesonspellrange(spelltype,direction,iteratetype)
	if not iteratetype then
		iteratetype = 'f'
	end
	local found = {}
	foreach creature p iteratetype do
		if isonspellarea(p,spelltype,direction) then
			table.insert(found,p)
		end
	end
	return table.unpack(found)
end

function findplayersonspellrange(spelltype,direction)
	findcreaturesonspellrange(spelltype,direction,'pf')
end

function findmonstersonspellrange(spelltype,direction)
	findcreaturesonspellrange(spelltype,direction,'mf')
end

function findcreatureontile(x,y,z)
	if x == nil or y == nil or z == nil or math.abs($posx-x) > 8 or math.abs($posy-y) > 6 or math.abs($posz-z) > 0 then
		return
	end
	foreach creature fcre 'f' do
		if fcre.posx == x and fcre.posy == y and fcre.posz == z then
			return fcre
		end
	end
	return
end

function iscreatureontile(x,y,z,ctype)
	local creatureontileinfo = gettile(x,y,z)
	if creatureontileinfo then
		for i=2, creatureontileinfo.itemcount do
			if creatureontileinfo.item[i].id == 99 and ((not ctype or ctype == 'any') or (ctype == 'player' and creatureontileinfo.item[i].count <= 0x40000000) or (ctype == 'monster' and creatureontileinfo.item[i].count > 0x40000000)) then
				return true
			end
		end
	end
	return false
end

function iscreatureshootable(n)
	if type(n) ~= 'userdata' then
		n = findcreature(n)
	end
	if n ~= nil then
		if tileshootable(n.posx,n.posy,n.posz) then
			return true
		else
			return false
		end
	end
end

function iscreaturereachable(n)
	if type(n) ~= 'userdata' then
		n = findcreature(n)
	end
	if n ~= nil then
		if tilereachable(n.posx,n.posy,n.posz) then
			return true
		else
			return false
		end
	end
end

function refillammo()
	local ammo = {761, 762, 763, 774, 1781, 2992, 3277, 3287, 3298, 3347, 3446, 3447, 3448, 3449, 3450, 6528, 7363, 7364, 7365, 7366, 7367, 7368, 7378}
	local i = 1
	while ammo[i] do
		if $rhand.id == ammo[i] and $rhand.count < 100 then
			equipitem(ammo[i],"rhand",'0-15',100)
			waitping()
			return
		elseif $lhand.id == ammo[i] and $lhand.count < 100 then
			equipitem(ammo[i],"lhand",'0-15',100)
			waitping()
			return
		elseif $belt.id == ammo[i] and $belt.count < 100 then
			equipitem(ammo[i],"belt",'0-15',100)
			waitping()
			return
		end
		i = i+1
	end
end

function color(r,g,b,transparency)
	if type(r) ~= 'string' then
		transparency = transparency or 0
		return (math.floor(transparency*2.55)*16777216) + (r*65536) + (g*256) + b
	else
		r = r:gsub(' ','_')
		r = r:gsub('-','_')
		g = g or 0
		local colors = {amaranth = 0xE52B50, amber = 0xFFBF00, aquamarine = 0x7FFFD4, azure = 0x007FFF, baby_blue = 0x89CFF0, beige = 0xF5F5DC, black = 0x000000, blue = 0x0000FF, blue_green = 0x0095B6, blue_violet = 0x8A2BE2, bronze = 0xCD7F32, brown = 0xA52A2A, byzantium = 0x702963, barmine = 0x960018, cerise = 0xDE3163, cerulean = 0x007BA7, champagne = 0xF7E7CE, chartreuse_green = 0x7FFF00, copper = 0xB87333, coral = 0xF88379, crimson = 0xDC143C, cyan = 0x00FFFF, electric_blue = 0x7DF9FF, erin = 0x00FF3F, gold = 0xFFD700, gray = 0x808080, green = 0x00CC00, harlequin = 0x3FFF00, indigo = 0x4B0082, ivory = 0xFFFFF0, jade = 0x00A86B, lavender = 0xB57EDC, lilac = 0xC8A2C8, lime = 0xBFFF00, magenta = 0xFF00FF, magenta_rose = 0xFF00AF, maroon = 0x800000, mauve = 0xE0B0FF, navy_blue = 0x000080, olive = 0x808000, orange = 0xFFA500, orange_red = 0xFF4500, op = 0x6FFFFFF, peach = 0xFFE5B4, persian_blue = 0x1C39BB, pink = 0xFFC0CB, plum = 0x8E4585, prussian_blue = 0x003153, pen = 0x5410987, pumpkin = 0xFF7518, purple = 0x800080, raspberry = 0xE30B5C, red = 0xFF0000, red_violet = 0xC71585, rose = 0xFF007F, salmon = 0xFA8072, scarlet = 0xFF2400, silver = 0xC0C0C0, slate_gray = 0x708090, spring_green = 0x00FF7F, taupe = 0x483C32, teal = 0x008080, turquoise = 0x40E0D0, violet = 0xEE82EE, viridian = 0x40826D, white = 0xFFFFFF, yellow = 0xFFFF00}
		if colors[r] then
			return colors[r] + (math.floor(2.55*g)*16777216)
		else
			return colors.white + (math.floor(2.55*g)*16777216)
		end
	end
end

function moveitemsupto(itemname, amount, to, from)
	itemname = itemid(itemname)
	if not to or (type(to) ~= 'number' and type(to) ~= 'string') then
		to = 'backpack'
	end
	if not from or (type(from) ~= 'number' and type(from) ~= 'string') then
		from = ''
	end
	if (type(to) == 'string' and to:find('ground')) or (type(from) == 'string' and from:find('ground')) then
		return false
	end
	while itemcount(itemname, to) < amount and itemcount(itemname, from) > 0 do
		moveitems(itemname, to, from, amount-itemcount(itemname,to))
		waitping()
	end
end

function moveitemsdownto(itemname, amount, from, to)
	itemname = itemid(itemname)
	if not to or (type(to) ~= 'number' and type(to) ~= 'string') then
		to = ''
	end
	if not from or (type(from) ~= 'number' and type(from) ~= 'string') then
		from = 'backpack'
	end
	while itemcount(itemname, from) > amount do
		moveitems(itemname, to, from, amount-itemcount(itemname,from))
		waitping()
	end
end

function buyitemsupto(itemname, amount, currentamount)
	currentamount = currentamount or itemcount(itemname)
	if not $tradeopen then opentrade() end
	amount = amount-currentamount
	--[[if tradecount('buy',itemname) == 0 then itemname = itemid(itemname) end--]]
	while amount > 0 --[[and (tradecount('buy',itemname) >= amount or tradecount('buy',itemname) == 100)--]] do
		buyitems(itemname, amount)
		waitping(3,4)
		amount = amount-100
	end
end

function sellitemsdownto(itemname, amount, currentamount)
	currentamount = currentamount or itemcount(itemname)
	if not $tradeopen then opentrade() end
	currentamount = currentamount-amount
	--[[if tradecount('sell',itemname) == 0 then itemname = itemid(itemname) end--]]
	while currentamount > 0 --[[and (tradecount('sell',itemname) >= currentamount or tradecount('sell',itemname) == 100)--]] do
		sellitems(itemname, currentamount)
		waitping(3,4)
		currentamount = currentamount-100
	end
end

function buyitemstocap(itemname, captosave)
	local amount = math.floor(($cap-captosave)/itemweight(itemname))
	opentrade()
	while amount > 0 do
		buyitems(itemname,amount)
		waitping(3,4)
		amount = amount-100
	end
end

function sellflasks()
	if not $tradeopen then opentrade() end
	for i=283,285 do
		local count = tradecount('sell',i)
		while count > 0 do
			sellitems(i,count) waitping()
			count = tradecount('sell',i)
		end
	end
end

function levitate(direction,updown)
	local dir = {x = {n = 0, s = 0, w = -1, e = 1},
				 y = {n = -1, s = 1, w = 0, e = 0}}
	if direction == 'w' or direction == 'e' or direction == 'n' or direction == 's' then
		local startposz,tries,maxtries = $posz,0,math.random(4,6)
		if not updown or (updown ~= 'up' and updown ~= 'down') then
			local tile = gettile($posx+dir.x[direction],$posy+dir.y[direction],$posz)
			updown = 'up'
			if tile.itemcount == 0 or (tile.itemcount == 1 and not itemproperty(tile.item[1].id,ITEM_NOTROOFEDGE)) then
				updown = 'down'
			end
		end
		while $mp >= 50 and $level >= 12 and $posz == startposz and tries < maxtries and cooleddown('levitate') do
			while (direction ~= $self.dir) do turn(direction) waitping(1.2,1.4) end
			cast('exani hur '..updown)
			waitping()
			tries=tries+1
		end
		if $posz ~= startz then
			return true
		end
	end
	return false
end
--351~355
function pick(x,y,z,holes)
	x,y,z = x or $wptx, y or $wpty, z or $wptz
	holes = holes or {394}
	local pickid = 3456
	local k = ''
	reachlocation(x,y,z)
	if x and y and z and math.abs($posx-x) <= 7 and math.abs($posy-y) <= 5 and $posz == z and ($posx ~= x or $posy ~= y) then
		local tile = gettile(x,y,z)
		local id = topitem(x,y,z).id
		if tile.item[1].id >= 351 and tile.item[1].id <= 355 then
			for i=2, tile.itemcount do
				if itemproperty(tile.item[i].id, ITEM_NOTMOVEABLE) then
					return false
				end
			end
			while id ~= 394 do
				while id > 355 or id < 351 do
					if not itemproperty(id,ITEM_NOTMOVEABLE) then
						moveitems(id,ground($posx,$posy,$posz),ground(x,y,z),100) waitping(1,1.3) id = topitem(x,y,z).id
					else
						return false
					end
				end
				while id ~= 394 and itemproperty(id, ITEM_GROUND) do
					if iscreatureontile(x,y,z) then
						local dir, dirx, diry = wheretomoveitem(x,y,z,99)
						moveitems(99,ground(x+dirx,y+diry,z),ground(x,y,z),100) wait(1400,1600)
					elseif clientitemhotkey(pickid,'crosshair') == 'not found' and itemcount(pickid) == 0 then
						printerror('Pick not found.')
						return false
					end
					useitemon(pickid,id,ground(x,y,z),k) wait(900,1100)
					id = topitem(x,y,z).id
				end
			end
			wait(100)
			id = topitem(x,y,z).id
		end
	end
	return false
end

function openhole(x,y,z,holes)
	x,y,z = x or $wptx, y or $wpty, z or $wptz
	holes = holes or {{593,594}, {606, 607}, {608, 609}, {867, 868}}
	local shovelid = false
	for i,j in ipairs(shovels) do
		if itemcount(j) > 0 then
			shovelid = j
			break
		end
	end
	if not shovelid then
		for i,j in ipairs(shovels) do
			if clientitemhotkey(j) ~= 'not found' then
				shovelid = j
				break
			end
		end
	end
	local k = ''
	if not shovelid then return false end
	reachlocation(x,y,z)
	if x and y and z and math.abs($posx-x) <= 7 and math.abs($posy-y) <= 5 and $posz == z and ($posx ~= x or $posy ~= y) then
		local v = 1
		while v <= #holes and not isitemontile(holes[v][1],x,y,z) do
			v = v+1
		end
		if v <= #holes then
			local id = topitem(x,y,z).id
			while id ~= holes[v][2] do
				if id == holes[v][1] then
					if iscreatureontile(x,y,z) then
						local dir, dirx, diry = wheretomoveitem(x,y,z,99)
						moveitems(99,ground(x+dirx,y+diry,z),ground(x,y,z),100) wait(1400,1600)
					elseif clientitemhotkey(shovelid,'crosshair') == 'not found' and itemcount(shovelid) == 0 then
						printerror(shoveltype.. ' not found.')
						return false
					end
					useitemon(shovelid,id,ground(x,y,z),k) wait(900,1100)
				elseif not itemproperty(id,ITEM_NOTMOVEABLE) then
					moveitems(id,ground($posx,$posy,$posz),ground(x,y,z),100) waitping(1,1.3)
				else
					return false
				end
				id = topitem(x,y,z).id
			end
			return true
		end
	end
	return false
end

function opensand(x,y,z)
	return openhole(x,y,z, {{231,615}})
end

function usesewer(x,y,z,sewers)
	x,y,z = x or $wptx, y or $wpty, z or $wptz
	sewers = sewers or {435}
	reachlocation(x,y,z)
	if x and y and z and math.abs($posx-x) <= 7 and math.abs($posy-y) <= 5 and $posz == z and ($posx ~= x or $posy ~= y) then
		local v = 1
		while v <= #sewers and not isitemontile(sewers[v],x,y,z) do
			v = v+1
		end
		if v <= #sewers then
			local id = topitem(x,y,z).id
			while $posz == z do
				if id == sewers[v] then
					useitem(sewers[v],ground(x,y,z)) wait(300,500)
				elseif not itemproperty(id,ITEM_NOTMOVEABLE) then
					moveitems(id,ground($posx,$posy,$posz),ground(x,y,z),100) waitping(1,1.3)
				else
					return false
				end
				id = topitem(x,y,z).id
			end
			return true
		end
	end
	return false
end

function uselever(x,y,z,id)
	x,y,z = x or $wptx, y or $wpty, z or $wptz
	local levers = {2771, 2772}
	if id then
		levers = {id}
	end
	reachlocation(x,y,z)
	local cur = {$posx,$posy,$posz}
	if x and y and z and math.abs($posx-x) <= 7 and math.abs($posy-y) <= 5 and $posz == z and ($posx ~= x or $posy ~= y) then
		local v = 1
		while v <= #levers and not isitemontile(levers[v],x,y,z) do
			v = v+1
		end
		if v <= #levers then
			local id = topitem(x,y,z).id
			while isitemontile(levers[v],x,y,z) and (cur[1] == $posx and cur[2] == $posy and cur[3] == $posz) do
				if id == levers[v] then
					useitem(levers[v],ground(x,y,z)) wait(300,500)
				elseif not itemproperty(id,ITEM_NOTMOVEABLE) then
					moveitems(id,ground($posx,$posy,$posz),ground(x,y,z),100) waitping(1,1.3)
				else
					return false
				end
				id = topitem(x,y,z).id
			end
			return true
		end
	end
	return false
end

function breakdworcwall(x,y,z, walls)
	x,y,z = x or $wptx, y or $wpty, z or $wptz
	walls = walls or {{2295, 3146}, {2296, 3145}}
	local sneakies = {9594, 9596, 9598}
	local weaponlocation,weaponid = findweapontouse()
	if clientitemhotkey(weaponid,'crosshair') ~= 'not found' then
		weaponlocation = ''
	end
	if weaponid == 0 then
		return false
	end
	print(weaponid)
	reachlocation(x,y,z)
	if x and y and z and math.abs($posx-x) <= 7 and math.abs($posy-y) <= 5 and $posz == z and ($posx ~= x or $posy ~= y) then
		local v = 1
		while v <= #walls and not isitemontile(walls[v][1],x,y,z) do
			v = v+1
		end
		if v <= #walls then
			local id = topitem(x,y,z).id
			while id ~= walls[v][2] do
				if id == walls[v][1] then
					if iscreatureontile(x,y,z) then
						local dir, dirx, diry = wheretomoveitem(x,y,z,99)
						moveitems(99,ground(x+dirx,y+diry,z),ground(x,y,z),100) wait(1400,1600)
					elseif clientitemhotkey(weaponid,'crosshair') == 'not found' and itemcount(weaponid) == 0 then
						printerror('Weapon not found.')
						return false
					end
					useitemon(weaponid,id,ground(x,y,z),weaponlocation) wait(900,1100)
				elseif not itemproperty(id,ITEM_NOTMOVEABLE) then
					moveitems(id,ground($posx,$posy,$posz),ground(x,y,z),100) waitping(1,1.3)
				else
					return false
				end
				id = topitem(x,y,z).id
			end
			return true
		end
	end
	return false
end

function breakspidersilk(x,y,z, walls)
	x,y,z = x or $wptx, y or $wpty, z or $wptz
	walls = walls or {{182, 188}, {183, 189}}
	local weaponid,weaponlocation = 5467
	if itemcount(5467) > 0 then
		if clientitemhotkey(weaponid,'crosshair') == 'not found' then
			if $rhand.id == weaponid then
				weaponlocation = 'rhand'
			elseif $lhand.id == weaponid then
				weaponlocation = 'lhand'
			else
				weaponlocation = ''
			end
		end
	else
		weaponlocation,weaponid = findweapontouse()
		if clientitemhotkey(weaponid,'crosshair') ~= 'not found' then
			weaponlocation = ''
		end
	end
	if weaponid == 0 then
		return false
	end
	reachlocation(x,y,z)
	if x and y and z and math.abs($posx-x) <= 7 and math.abs($posy-y) <= 5 and $posz == z and ($posx ~= x or $posy ~= y) then
		local v = 1
		while v <= #walls and not isitemontile(walls[v][1],x,y,z) do
			v = v+1
		end
		if v <= #walls then
			local id = topitem(x,y,z).id
			while id ~= walls[v][2] do
				if id == walls[v][1] then
					if iscreatureontile(x,y,z) then
						local dir, dirx, diry = wheretomoveitem(x,y,z,99)
						moveitems(99,ground(x+dirx,y+diry,z),ground(x,y,z),100) wait(1400,1600)
					elseif clientitemhotkey(weaponid,'crosshair') == 'not found' and itemcount(weaponid) == 0 then
						printerror('Weapon not found.')
						return false
					end
					useitemon(weaponid,id,ground(x,y,z),weaponlocation) wait(900,1100)
				elseif not itemproperty(id,ITEM_NOTMOVEABLE) then
					moveitems(id,ground($posx,$posy,$posz),ground(x,y,z),100) waitping(1,1.3)
				else
					return false
				end
				id = topitem(x,y,z).id
			end
			return true
		end
	end
	return false
end

function cutgrass(x,y,z)
	x,y,z = x or $wptx, y or $wpty, z or $wptz
	local grasses = {{3702, 3701},{3696, 3695}}
	local weaponid,weaponlocation = false
	for i,j in ipairs(machetes) do
		if itemcount(j) > 0 then
			weaponid = j
			break
		end
	end
	if not macheteid then
		for i,j in ipairs(machetes) do
			if clientitemhotkey(j) ~= 'not found' then
				weaponid = j
				break
			end
		end
	end
	if not weaponlocation then
		if $rhand.id == weaponid then
			weaponlocation = 'rhand'
		elseif $lhand.id == weaponid then
			weaponlocation = 'lhand'
		else
			weaponlocation = ''
		end
	end
	if not weaponid then
		return false
	end
	reachlocation(x,y,z)
	if x and y and z and math.abs($posx-x) <= 7 and math.abs($posy-y) <= 5 and $posz == z and ($posx ~= x or $posy ~= y) then
		local v = 1
		while v <= #grasses and not isitemontile(grasses[v][1],x,y,z) do
			v = v+1
		end
		if v <= #grasses then
			local id = topitem(x,y,z).id
			while id ~= grasses[v][2] do
				if id == grasses[v][1] then
					if iscreatureontile(x,y,z) then
						local dir, dirx, diry = wheretomoveitem(x,y,z,99)
						moveitems(99,ground(x+dirx,y+diry,z),ground(x,y,z),100) wait(1400,1600)
					elseif clientitemhotkey(weaponid,'crosshair') == 'not found' and itemcount(weaponid) == 0 then
						printerror('Machete not found.')
						return false
					end
					useitemon(weaponid,id,ground(x,y,z),weaponlocation) wait(900,1100)
				elseif not itemproperty(id,ITEM_NOTMOVEABLE) then
					moveitems(id,ground($posx,$posy,$posz),ground(x,y,z),100) waitping(1,1.3)
				else
					return false
				end
				id = topitem(x,y,z).id
			end
			return true
		end
	end
	return false
end

function pickupitems(dir,n,amount)
	local dire = {dirs = {'c', 'n', 's', 'w', 'e', 'nw', 'ne', 'sw', 'se'},
				  x = {c = 0, n = 0, s = 0, w = -1, e = 1, nw = -1, ne = 1, sw = -1, se = 1},
				  y = {c = 0, n = -1, s = 1, w = 0, e = 0, nw = -1, ne = -1, sw = 1, se = 1}}
	if not dir or not table.find(dire.dirs,dir) then
		if type(n) == 'number' then
			amount = n
		end
		if not n then
			n = dir
		end
		dir = 'c'
	end
	if not n then
		n = ''
	end
	if not amount then
		amount = 100
	end
	local pos = {x = $posx+dire.x[dir], y = $posy+dire.y[dir], z = $posz}
	local topid = topitem(pos.x,pos.y,pos.z).id
	if topid ~= 0 and itemproperty(topid,ITEM_PICKUPABLE) then
		moveitems(topid,n,ground(pos.x,pos.y,pos.z),amount)
	end
end

--local ropeholesids = {386, 421, 7762, 12202}
local stairsids = {386, 421, 1948, 1968, 5542, 7762, 7771, 9116, 12202}
local bodies = {stakeable = {{4097, 5995, 'demon'}, {4137, 6006, 'vampire'}}, skinnable = {{4173, 6017, 'rabbit'}, {4011, 5969, 'minotaur'}, {4025, 5973, 'dragon'}, {4047, 5981, 'minotaur mage'}, {4052, 5982, 'minotaur archer'}, {4057, 5983, 'minotaur guard'}, {4062, 5984, 'dragon lord'}, {4112, 5999, 'behemoth'}, {4212, 6030, 'bonebeast'}, {4321, 4239, 'lizard templar'}, {4324, 6040, 'lizard sentinel'}, {4327, 6041, 'lizard snakecharmer'}, {10352, 10355, 'lizard high guard'}, {10356, 10359, 'lizard legionnaire'}, {10360, 10363, 'lizard dragon priest'}, {10364, 10367, 'lizard zaogun'}, {10368, 10371, 'lizard chosen'}}}

BODYLIST = {}

function BODYLIST:new(n)
	n = n or {}
	setmetatable(n, self)
	self.__index = self
	return n
end

function itemproperties(iid, ...)
	iid = itemid(iid)
	local properties = {...}
	for i,j in ipairs(properties) do
		if not itemproperty(iid, j) then
			return false
		end
	end
	return true
end

function BODYLIST:clear(n)
	self = {}
end

function BODYLIST:remove(...)
	local args = {...}
	for i,j in ipairs(args) do
		local temp = table.find(self, j, 3)
		if temp then
			table.remove(self, temp)
		end
	end
end

function BODYLIST:addid(...)
	local args = {...}
	for i,j in ipairs(args) do
		table.insert(self, {j[1], j[2], j[3]})
	end
end

function BODYLIST:__tostring()
	toprint = ''
	for i,j in ipairs(self) do
		toprint = toprint..j[3]..', '
	end
	return toprint:sub(1,#toprint-2)
end

function resetbodylists()
	SKINLIST, STAKELIST = nil, nil
	SKINLIST = BODYLIST:new({{4011, 5969, 'minotaur'}, {4025, 5973, 'dragon'}, {4047, 5981, 'minotaur mage'}, {4052, 5982, 'minotaur archer'}, {4057, 5983, 'minotaur guard'}, {4062, 5984, 'dragon lord'}, {4112, 5999, 'behemoth'}, {4212, 6030, 'bonebeast'}, {4321, 4239, 'lizard templar'}, {4324, 6040, 'lizard sentinel'}, {4327, 6041, 'lizard snakecharmer'}, {10352, 10355, 'lizard high guard'}, {10356, 10359, 'lizard legionnaire'}, {10360, 10363, 'lizard dragon priest'}, {10364, 10367, 'lizard zaogun'}, {10368, 10371, 'lizard chosen'}})
	STAKELIST = BODYLIST:new(bodies.stakeable)
end

SKINLIST = BODYLIST:new({{4011, 5969, 'minotaur'}, {4025, 5973, 'dragon'}, {4047, 5981, 'minotaur mage'}, {4052, 5982, 'minotaur archer'}, {4057, 5983, 'minotaur guard'}, {4062, 5984, 'dragon lord'}, {4112, 5999, 'behemoth'}, {4212, 6030, 'bonebeast'}, {4321, 4239, 'lizard templar'}, {4324, 6040, 'lizard sentinel'}, {4327, 6041, 'lizard snakecharmer'}, {10352, 10355, 'lizard high guard'}, {10356, 10359, 'lizard legionnaire'}, {10360, 10363, 'lizard dragon priest'}, {10364, 10367, 'lizard zaogun'}, {10368, 10371, 'lizard chosen'}})
STAKELIST = BODYLIST:new(bodies.stakeable)

function STAKELIST:add(...)
	local args = {...}
	for i,j in ipairs(args) do
		local temp = table.find(bodies.stakeable, j, 3)
		if temp and not table.find(self, j, 3) then
			table.insert(self, bodies.stakeable[temp])
		end
	end
end

function SKINLIST:add(...)
	local args = {...}
	for i,j in ipairs(args) do
		local temp = table.find(bodies.skinnable, j, 3)
		if temp and not table.find(self, j, 3) then
			table.insert(self, {table.unpack(bodies.skinnable[temp])})
		end
	end
end

function skinspotssample(dist, movebody, waitfresh, bodytable)
	movebody = movebody or false
	waitfresh = waitfresh or false
	if not dist or dist > 7 or dist < 1 then
		dist = 7
	end
	local counter = 0
	for j=-dist, dist do
		for i=-dist, dist do
			local pos = {x = $posx+i, y = $posy+j, z = $posz}
			if tilehasinfo(pos.x,pos.y,pos.z) and tilereachable(pos.x,pos.y,pos.z) then
				local tile, topid, gonextsqm = gettile(pos.x,pos.y,pos.z), topitem(pos.x,pos.y,pos.z).id, false
				local tablepos, notmoveablepos = table.find(bodytable, topid, 1)
				if waitfresh then
					tablepos = tablepos or table.find(bodytable, topid, 2)
				end
				for k=1, tile.itemcount do
					topid = tile.item[k].id
					if topid == 99 or table.find(stairsids, topid) then
						gonextsqm = true
						break
					end
					if itemproperty(topid, ITEM_NOTMOVEABLE) and not itemproperty(topid, ITEM_GROUND) then
						notmoveablepos = k
					end
					if movebody then
						for p,q in ipairs(bodytable) do
							if (q[1] == topid or (waitfresh and q[2] == topid)) and (not notmoveablepos or k < notmoveablepos) then
								counter = counter+1
							end
						end
					end
				end
				if not gonextsqm and not movebody and tablepos then
					counter = counter+1
				end
			end
		end
	end
	return counter
end

function skinspots(dist, movebody, waitfresh, bodytable)
	if type(movebody) ~= 'boolean' then
		movebody = false
	end
	if type(waitfresh) ~= 'boolean' then
		waitfresh = false
	end
	return skinspotssample(dist, movebody, waitfresh, SKINLIST)
end

function stakespots(dist, movebody, waitfresh, bodytable)
	if type(movebody) ~= 'boolean' then
		movebody = false
	end
	if type(waitfresh) ~= 'boolean' then
		waitfresh = false
	end
	return skinspotssample(dist, movebody, waitfresh, STAKELIST)
end

function skinkitchenknifespots(dist, movebody, waitfresh, bodytable)
	if type(movebody) ~= 'boolean' then
		movebody = false
	end
	if type(waitfresh) ~= 'boolean' then
		waitfresh = false
	end
	return skinspotssample(dist, movebody, waitfresh, {{4173, 6017, 'rabbit'}})
end

function skinsample(dist,movebody,waitfresh,touseid,bodytable)
	movebody = movebody or false
	waitfresh = waitfresh or false
	if not dist or dist < 1 or dist > 7 then
		dist = 7
	end
	touseid = itemid(touseid)
	local itempos = ''
	if clientitemhotkey(touseid,'crosshair') == 'not found' then
		if itemcount(touseid) == 0 then
			return false
		end
	end
	local pos = {x=nil,y=nil,z=$posz,body=nil,fresh=nil}
	local cur = {x=nil,y=nil,z=$posz,id=nil}
	local t = {}
	
	local i,j
	for a=1,dist do
		j = -a
		while j <= a do
			i = -a
			while i <= a do
				cur.x,cur.y = $posx+i,$posy+j
				if tilehasinfo(cur.x,cur.y,cur.z) and tilereachable(cur.x,cur.y,cur.z) then
					local gonextsqm, tile, tempid = false, gettile(cur.x,cur.y,cur.z), topitem(cur.x,cur.y,cur.z).id
					local tablepos, notmoveablepos = table.find(bodytable, tempid, 1)
					if waitfresh then
						tablepos = tablepos or table.find(bodytable, tempid, 2)
					end
					for k=1, tile.itemcount do
						tempid = tile.item[k].id
						if tempid == 99 or table.find(stairsids, tempid) then
							gonextsqm = true
							break
						end
						if itemproperty(tempid, ITEM_NOTMOVEABLE) and not itemproperty(tempid, ITEM_GROUND) then
							notmoveablepos = k
						end
						if movebody and not tablepos then
							for p,q in ipairs(bodytable) do
								if (q[1] == tempid or (waitfresh and q[2] == tempid)) and (not notmoveablepos or k < notmoveablepos) then
									tablepos = p
								end
							end
						end
					end
					if not gonextsqm and tablepos then
						pos.x,pos.y,pos.body,pos.fresh = cur.x,cur.y,bodytable[tablepos][1],bodytable[tablepos][2]
					end
				end
				if pos.x then break end
				if j ~= a and j ~= -a then
					i = i+a*2
				else
					i = i+1
				end
			end
			if pos.x then break end
			j = j+1
		end
		if pos.x then break end
	end
	if pos.x then
		pausewalking(20000)
		reachlocation(pos.x,pos.y,pos.z)
		local topid = topitem(pos.x,pos.y,pos.z).id
		while topid ~= pos.fresh and topid ~= pos.body and not iscreatureontile(pos.x, pos.y, pos.z) and not itemproperty(topid, ITEM_NOTMOVEABLE) do
			local dir, dirx, diry = wheretomoveitem(pos.x,pos.y,pos.z,topid)
			moveitems(topid, ground(pos.x+dirx,pos.y+diry,pos.z), ground(pos.x,pos.y,pos.z), 100) waitping()
			topid = topitem(pos.x,pos.y,pos.z).id
		end
		while topid == pos.fresh do wait(500) topid = topitem(pos.x,pos.y,pos.z).id end
		
		useitemon(touseid, pos.body, ground(pos.x,pos.y,pos.z), itempos) waitping(1.4, 1.7)
		pausewalking(0)
		return true
	end
	return false
end

function skin(dist, movebody, waitfresh)
	if type(movebody) ~= 'boolean' then
		movebody = false
	end
	if type(waitfresh) ~= 'boolean' then
		waitfresh = false
	end
	return skinsample(dist, movebody, waitfresh, 5908, SKINLIST)
end

function stake(dist, movebody, waitfresh)
	if type(movebody) ~= 'boolean' then
		movebody = false
	end
	if type(waitfresh) ~= 'boolean' then
		waitfresh = false
	end
	return skinsample(dist, movebody, waitfresh, 5942, STAKELIST)
end

function skinkitchenknife(dist, movebody, waitfresh)
	if type(movebody) ~= 'boolean' then
		movebody = false
	end
	if type(waitfresh) ~= 'boolean' then
		waitfresh = false
	end
	return skinsample(dist, movebody, waitfresh, 3469, {{4173, 6017, 'rabbit'}})
end

FISHSPOTS = {time = 0, id = 0, nonfish = {}, fish = {}}
function FISHSPOTS:update(id)
	self.time = $timems
	self.id = id
	self.nonfish = {}
	self.fish = {}
	for j=-5,5 do
		for i=-7,7 do
			local cur = {x=$posx+i,y=$posy+j,z=$posz,id=0}
			cur.id = topitem(cur.x,cur.y,cur.z).id
			if tileshootable(cur.x,cur.y,cur.z) then
				if self.id <= 100 and self.id >= 0 then
					if cur.id >= 4597 and cur.id <= 4602 then
						table.insert(self.fish, {x=cur.x,y=cur.y,z=cur.z})
					elseif cur.id >= 4609 and cur.id <= 4614 then
						table.insert(self.nonfish, {x=cur.x,y=cur.y,z=cur.z})
					end
				elseif (type(self.id) == 'number' and self.id == cur.id) or table.find(self.id,cur.id) then
					local tile = gettile(cur.x,cur.y,cur.z)
					local insert = true
					for k=1, tile.itemcount do
						local tempid = tile.item[k].id
						if tempid == 99 or table.find(stairsids,tempid) then
							insert = false
							break
						end
					end
					if insert then
						table.insert(self.fish, {x=cur.x,y=cur.y,z=cur.z})
					end
				end
			end
		end
	end
end

function FISHSPOTS:clear()
	self.time = 0
	self.id = 0
	self.nonfish = {}
	self.fish = {}
end

function comparetables(a,b)
	if #a ~= #b then
		return false
	end
	for i,j in ipairs(a) do
		if j ~= b[i] then
			return false
		end
	end
	for i,j in pairs(a) do
		if j ~= b[i] then
			return false
		end
	end
	return true
end

function fish(n)
	n = n or 0
	local rodid,rodpos = 3483
	if clientitemhotkey(rodid,'crosshair') == 'not found' then
		rodpos = ''
	end
	if $timems-FISHSPOTS.time > 100 or (type(n) == 'number' and n ~= FISHSPOTS.id) or (type(n) == 'table' and not comparetables(n, FISHSPOTS.id)) then
		FISHSPOTS:update(n)
	end
	local j = math.random(1,100)
	local tofish
	if (#FISHSPOTS.nonfish > 0 and n <= 100) and (j <= n or #FISHSPOTS.fish == 0) then
		j = math.random(1,#FISHSPOTS.nonfish)
		tofish = FISHSPOTS.nonfish[j]
	elseif #FISHSPOTS.fish > 0 and (#FISHSPOTS.nonfish == 0 or n == 0 or n > 100 or j > n) then
		j = math.random(1,#FISHSPOTS.fish)
		tofish = FISHSPOTS.fish[j]
	end
	if tofish then
		pausewalking(10000)
		useitemon(rodid,topitem(tofish.x,tofish.y,tofish.z).id,ground(tofish.x,tofish.y,tofish.z),rodpos) waitping(1.1,1.4)
		pausewalking(0)
	end
end

function fishspots(n)
	n = n or 0
	if $timems-FISHSPOTS.time > 100 or (type(n) == 'number' and n ~= FISHSPOTS.id) or (type(n) == 'table' and not comparetables(n, FISHSPOTS.id)) then
		FISHSPOTS:update(n)
	end
	return #FISHSPOTS.fish
end

function settargeting(onoff, stopattacking, t)
	if (onoff == nil) then
		return
	else
		onoff = onoff:lower()
		if (onoff == 'on') or (onoff == 'yes') then
			onoff = 'yes'
		elseif (onoff == 'off') or (onoff == 'no') then
			onoff = 'no'
		end
	end
	setsetting('Targeting/TargetingEnabled', onoff, t)
	if onoff == 'no' and stopattacking ~= false then
		stopattack()
	end
end

function setcavebot(onoff, t)
	if (onoff == nil) then
		return
	else
		onoff = onoff:lower()
		if (onoff == 'on') or (onoff == 'yes') then
			onoff = 'yes'
		elseif (onoff == 'off') or (onoff == 'no') then
			onoff = 'no'
		end
	end
	setsetting('Cavebot/CavebotEnabled', onoff, t)
end

function setlooting(onoff, t)
	if (onoff == nil) then
		return
	else
		onoff = onoff:lower()
		if (onoff == 'on') or (onoff == 'yes') then
			onoff = 'yes'
		elseif (onoff == 'off') or (onoff == 'no') then
			onoff = 'no'
		end
	end
	setsetting('Cavebot/Looting/LootingEnabled', onoff, t)
end

function sethealing(onoff, t)
	if (onoff == nil) then
		return
	else
		onoff = onoff:lower()
		if (onoff == 'on') or (onoff == 'yes') then
			onoff = 'yes'
		elseif (onoff == 'off') or (onoff == 'no') then
			onoff = 'no'
		end
	end
	setsetting('Healer/HealerEnabled', onoff, t)
end

function setmanatraining(onoff, t)
	if (onoff == nil) then
		return
	else
		onoff = onoff:lower()
		if (onoff == 'on') or (onoff == 'yes') then
			onoff = 'yes'
		elseif (onoff == 'off') or (onoff == 'no') then
			onoff = 'no'
		end
	end
	setsetting('Healer/ManaTraining/Enabled', onoff, t)
end

function setalarm(alarmtype, playsound, pausebot, logout, t)
	local alarmtypes = {'PlayerOnScreen','PlayerAttacking','DefaultMessage','PrivateMessage','GmDetected','Disconnected','CrashedFroze'}
	local alarmtypes2 = {'playeronscreen','playerattacking','defaultmessage','privatemessage','gmdetected','disconnected','crashedfroze'}
	local pos = table.find(alarmtypes2,alarmtype:lower())
	if not pos then
		return
	end
	if not playsound or playsound == 'off' or playsound == 'no' or playsound == 0 then
		playsound = 'no'
	elseif playsound == 'on' or playsound == 'yes' or playsound == 1 then
		playsound = 'yes'
	end
	if not pausebot or pausebot == 'off' or pausebot == 'no' or pausebot == 0 then
		pausebot = 'no'
	elseif pausebot == 'on' or pausebot == 'yes' or pausebot == 1 then
		pausebot = 'yes'
	end
	if not logout or logout == 'off' or logout == 'no' or logout == 0 then
		logout = 'no'
	elseif logout == 'on' or logout == 'yes' or logout == 1 then
		logout = 'yes'
	end
	setsetting('Alerts/'..alarmtypes[pos]..'/PlaySound', playsound, t)
	setsetting('Alerts/'..alarmtypes[pos]..'/FlashClient', playsound, t)
	setsetting('Alerts/'..alarmtypes[pos]..'/PauseBot', pausebot, t)
	setsetting('Alerts/'..alarmtypes[pos]..'/Disconnect', logout, t)
end

function addtosafelist(safetype, ...)
	local alarmtypes = {'PlayerOnScreen','PlayerAttacking','DefaultMessage','PrivateMessage','GmDetected','Disconnected','CrashedFroze'}
	local alarmtypes2 = {'playeronscreen','playerattacking','defaultmessage','privatemessage','gmdetected','disconnected','crashedfroze'}
	local pos = table.find(alarmtypes2,alarmtype:lower())
	if not pos then return end
	local cursafe = getsetting('Alerts/'..alarmtypes[pos]..'/SafeList'):token(nil,'\n')
	table.lower(cursafe)
	for i,j in ipairs({...}) do
		if not table.find(cursafe,j:lower()) then
			table.insert(cursafe,j)
		end
	end
	local p = ''
	for i,j in ipairs(cursafe) do
		p = p..j..'\n'
	end
	setsetting('Alerts/'..alarmtypes[pos]..'/SafeList',p)
end

function removefromsafelist(safetype, ...)
	local alarmtypes = {'PlayerOnScreen','PlayerAttacking','DefaultMessage','PrivateMessage','GmDetected','Disconnected','CrashedFroze'}
	local alarmtypes2 = {'playeronscreen','playerattacking','defaultmessage','privatemessage','gmdetected','disconnected','crashedfroze'}
	local pos = table.find(alarmtypes2,alarmtype:lower())
	if not pos then return end
	local cursafe = getsetting('Alerts/'..alarmtypes[pos]..'/SafeList'):token(nil,'\n')
	table.lower(cursafe)
	for i,j in ipairs({...}) do
		local m = table.find(cursafe,j:lower())
		if m then
			table.remove(cursafe,m)
		end
	end
	local p = ''
	for i,j in ipairs(cursafe) do
		p = p..j..'\n'
	end
	setsetting('Alerts/'..alarmtypes[pos]..'/SafeList',p)
end

function stopattack()
	keyevent(0x1B)
end

function string:token(n,delimiter)
	delimiter = delimiter or ' +'
	local result = {}
	local from = 1
	local delim_from, delim_to = self:find(delimiter,from)
	while delim_from do
		table.insert(result, self:sub(from,delim_from-1))
		from = delim_to + 1
		delim_from, delim_to = self:find(delimiter,from)
	end
	table.insert(result,self:sub(from))
	if n then
		return result[n]
	end
	return result
end

local spellsareas = {
sstrike = {centerx = 2, centery = 2, area = {
				{0,2,0},
				{3,0,4},
				{0,5,0}}},
ssmallwave = {centerx = 5, centery = 5, area = {
				{0,0,2,2,2,2,2,0,0},
				{0,0,0,2,2,2,0,0,0},
				{3,0,0,2,2,2,0,0,4},
				{3,3,3,0,2,0,4,4,4},
				{3,3,3,3,0,4,4,4,4},
				{3,3,3,0,5,0,4,4,4},
				{3,0,0,5,5,5,0,0,4},
				{0,0,0,5,5,5,0,0,0},
				{0,0,5,5,5,5,5,0,0}}},
sbigwave = {centerx = 6, centery = 6, area = {
				{0,0,0,0,2,2,2,0,0,0,0},
				{0,0,0,0,2,2,2,0,0,0,0},
				{0,0,0,0,2,2,2,0,0,0,0},
				{0,0,0,0,0,2,0,0,0,0,0},
				{3,3,3,0,0,2,0,0,4,4,4},
				{3,3,3,3,3,0,4,4,4,4,4},
				{3,3,3,0,0,5,0,0,4,4,4},
				{0,0,0,0,0,5,0,0,0,0,0},
				{0,0,0,0,5,5,5,0,0,0,0},
				{0,0,0,0,5,5,5,0,0,0,0},
				{0,0,0,0,5,5,5,0,0,0,0}}},
ssmallbeam = {centerx = 6, centery = 6, area = {
				{0,0,0,0,0,2,0,0,0,0,0},
				{0,0,0,0,0,2,0,0,0,0,0},
				{0,0,0,0,0,2,0,0,0,0,0},
				{0,0,0,0,0,2,0,0,0,0,0},
				{0,0,0,0,0,2,0,0,0,0,0},
				{3,3,3,3,3,0,4,4,4,4,4},
				{0,0,0,0,0,5,0,0,0,0,0},
				{0,0,0,0,0,5,0,0,0,0,0},
				{0,0,0,0,0,5,0,0,0,0,0},
				{0,0,0,0,0,5,0,0,0,0,0},
				{0,0,0,0,0,5,0,0,0,0,0}}},
sbigbeam = {centerx = 9, centery = 9, area = {
				{0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0},
				{3,3,3,3,3,3,3,3,0,4,4,4,4,4,4,4,4},
				{0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0},
				{0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0}}},
sfront = {centerx = 2, centery = 2, area = {
				{9,2,6},
				{3,0,4},
				{8,5,7}}},
sexplo = {centerx = 2, centery = 2, area = {
				{0,1,0},
				{1,1,1},
				{0,1,0}}},
s1x1 = {centerx = 2, centery = 2, area = {
				{1,1,1},
				{1,1,1},
				{1,1,1}}},
s2x2 = {centerx = 3, centery = 3, area = {
				{0,1,1,1,0},
				{1,1,1,1,1},
				{1,1,1,1,1},
				{1,1,1,1,1},
				{0,1,1,1,0}}},
s3x3 = {centerx = 4, centery = 4, area = {
				{0,0,1,1,1,0,0},
				{0,1,1,1,1,1,0},
				{1,1,1,1,1,1,1},
				{1,1,1,1,1,1,1},
				{1,1,1,1,1,1,1},
				{0,1,1,1,1,1,0},
				{0,0,1,1,1,0,0}}},
s5x5 = {centerx = 6, centery = 6, area = {
				{0,0,0,0,0,1,0,0,0,0,0},
				{0,0,0,1,1,1,1,1,0,0,0},
				{0,0,1,1,1,1,1,1,1,0,0},
				{0,1,1,1,1,1,1,1,1,1,0},
				{0,1,1,1,1,1,1,1,1,1,0},
				{1,1,1,1,1,1,1,1,1,1,1},
				{0,1,1,1,1,1,1,1,1,1,0},
				{0,1,1,1,1,1,1,1,1,1,0},
				{0,0,1,1,1,1,1,1,1,0,0},
				{0,0,0,1,1,1,1,1,0,0,0},
				{0,0,0,0,0,1,0,0,0,0,0}}},
s6x6 = {centerx = 7, centery = 7, area = {
				{0,0,0,0,0,0,1,0,0,0,0,0,0},
				{0,0,0,0,1,1,1,1,1,0,0,0,0},
				{0,0,0,1,1,1,1,1,1,1,0,0,0},
				{0,0,1,1,1,1,1,1,1,1,1,0,0},
				{0,1,1,1,1,1,1,1,1,1,1,1,0},
				{0,1,1,1,1,1,1,1,1,1,1,1,0},
				{1,1,1,1,1,1,1,1,1,1,1,1,1},
				{0,1,1,1,1,1,1,1,1,1,1,1,0},
				{0,1,1,1,1,1,1,1,1,1,1,1,0},
				{0,0,1,1,1,1,1,1,1,1,1,0,0},
				{0,0,0,1,1,1,1,1,1,1,0,0,0},
				{0,0,0,0,1,1,1,1,1,0,0,0,0},
				{0,0,0,0,0,0,1,0,0,0,0,0,0}}}}

function isonspellarea(mid,spelltype,spelldir,x,y)
	if not spelldir then
		spelldir = $self.dir
	end
	local directionconversion = {nil, $self.dir, 'n', 'w', 'e', 's', 'ne', 'se', 'sw', 'nw'}
	mid = findcreature(mid)
	if mid and mid.id == 0 then
		return false
	end
	local numberspelltype = tonumber(spelltype)
	if type(spelltype) == 'string' then
		spelltype = 's'..(spelltype:gsub(' ','')):lower()
	else
		return false
	end
	if not (x and y) then
		x,y = $posx,$posy
	elseif math.abs(x) <= 7 and math.abs(y) <= 5 then
		x,y = $posx+x,$posy+y
	else
		x,y = nil,nil
	end
	
	if mid and (spellsareas[spelltype] or numberspelltype) and mid.posz == $posz and x and y and mid.isshootable then
		if numberspelltype then
			if mid == $attacked and mid.dist <= numberspelltype then
				return true
			else
				return false
			end
		end
		local centerx,centery = spellsareas[spelltype].centerx,spellsareas[spelltype].centery
		local posx,posy = centerx-(x-mid.posx),centery-(y-mid.posy)
		local value
		if posx >= 1 and posx <= centerx*2-1 and posy >= 1 and posy <= centery*2-1 then
			value = directionconversion[spellsareas[spelltype].area[posy][posx]+1]
		end
		if value and (value:find(spelldir) or spelldir == 'any') then
			return true
		end
	end
	return false
end

function wheretoturn(mid,spelltype)
	local directionconversion = {nil, $self.dir, 'n', 'w', 'e', 's', 'ne', 'se', 'sw', 'nw'}
	if type(mid) == 'number' or type(mid) == 'string' then
		mid = findcreature(mid)
	end
	local numberspelltype = tonumber(spelltype)
	if numberspelltype then
		spelltype = numberspelltype
	elseif type(spelltype) == 'string' then
		spelltype = 's'..(spelltype:gsub(' ','')):lower()
	else
		return $self.dir
	end
	local x,y = $posx,$posy
	if mid and mid.id ~= 0 and mid.posz == $posz and x and y and mid.isshootable then
		local centerx,centery = spellsareas[spelltype].centerx,spellsareas[spelltype].centery
		local posx,posy = centerx-(x-mid.posx),centery-(y-mid.posy)
		local value = $self.dir
		if posx >= 1 and posx <= centerx*2-1 and posy >= 1 and posy <= centery*2-1 then
			value = directionconversion[spellsareas[spelltype].area[posy][posx] +1]
		end
		if value:find($self.dir) then
			return $self.dir
		end
		local rand = math.random(1,#value)
		return value:sub(rand,rand)
	end
	return $self.dir
end

function getarearunetile(ignoreplayers,...)
	monsters = {...}
	table.lower(monsters)
	local sqm = {tile,x,y,z,amount=0}
	for a=0,7 do
		local i,j = -a, -a
		while j <= a do
			i = -a
			while i <= a do
				if (math.abs(j) == a or math.abs(i) == a) and (tilehasinfo($posx+i, $posy+j, $posz)) then
					local posx,posy = $posx+i,$posy+j
					if tileshootable(posx,posy,$posz) then
						local tempm,tempp = 0,0
						foreach creature c 'f' do
							if c ~= $self then
								if isonspellarea(c, '3x3', false, i, j) then
									if (#monsters == 0 and (c.ismonster or ignoreplayers)) or table.find(monsters,c.name:lower()) or table.find(monsters,c.id) or table.find(monsters,c) then
										tempm = tempm+1
									elseif c.isplayer then
										tempp = tempp+1
									end
								end
							end
							if tempm > sqm.amount and (ignoreplayers or tempp == 0) then
								sqm.tile,sqm.x,sqm.y,sqm.z,sqm.amount = ground(posx,posy,$posz),posx,posy,$posz,tempm
							end
						end
					end
				end
				if math.abs(j) ~= a then
					i = i+2*a
				else
					i = i+1
				end
			end
			j = j+1
		end
	end
	return sqm
end

function shootarearune(id, amount, ignoreplayers, ...)
	id = itemid(id)
	local monsters = {...}
	if ignoreplayers then
		if type(ignoreplayers) == 'string' or (type(ignoreplayers) == 'number' and ignoreplayers > 100) then
			table.insert(monsters,ignoreplayers)
		end
		ignoreplayers = ignoreplayers == true or false
	end
	if amount then
		if type(amount) == 'string' or (type(amount) == 'number' and amount > 100) then
			table.insert(monsters,amount)
			amount = 1
		end
	end
	amount = amount or 1
	local temp = getarearunetile(ignoreplayers, table.unpack(monsters))
	if temp.amount >= amount then
		useitemon(id, topitem(temp.x,temp.y,temp.z), temp.tile)
		return true
	end
	return false
end

function cursorinfo() -- Credits to Anonymickey, for doing the calculations.
	local temp = {x,y,z,id,msg}
	if $cursor.x >= $worldwin.left and $cursor.x <= $worldwin.right and $cursor.y <= $worldwin.bottom and $cursor.y >= $worldwin.top then
		local sqmWidth = ($worldwin.bottom - $worldwin.top)/11
		temp.x, temp.y, temp.z =  $posx - 8 + math.ceil(($cursor.x - $worldwin.left)/sqmWidth), $posy - 6 + math.ceil(($cursor.y - $worldwin.top)/sqmWidth), $posz
		temp.id = topitem(temp.x, temp.y, temp.z).id
		temp.msg = temp.x..', '..temp.y..', '..temp.z..' / '..temp.id
	else
		temp.x, temp.y, temp.z, temp.id, temp.msg = 0,0,0,0,'dontlist'
	end
	return temp
end

function tobin(x, reverse)
	local bin = ''
	while x ~= 0 do
		local mod = x % 2
		if reverse then
			bin = bin .. mod
		else
			bin = mod .. bin
		end
		x = math.floor(x/2)
	end
	return bin
end

function bintonum(x)
	if type(x) == 'number' then
		x = tostring(x)
	elseif type(x) ~= 'string' then
		return
	end
	local num = 0
	for i=1,x:len() do
		num = num*2 + tonumber(x:sub(i,i))
	end
	return num
end

function table:lower(inpairs)
	if not inpairs then
		for i,j in ipairs(self) do
			if type(j) == 'string' then
				self[i] = j:lower()
			end
		end
	else
		for i,j in pairs(self) do
			if type(j) == 'string' then
				self[i] = j:lower()
			end
		end
	end
end

function table:id(inpairs)
	if not inpairs then
		local i = 1
		while i <= #self do
			if type(self[i]) == 'string' then
				local iid = itemid(self[i])
				if iid ~= 0 then
					self[i] = iid
					i = i+1
				else
					table.remove(self,i)
				end
			elseif type(self[i]) == 'number' then
				i = i+1
			else
				table.remove(self,i)
			end
		end
	else
		for i,j in pairs(self) do
			if type(j) == 'string' then
				self[i] = itemid(j)
			end
		end
	end
end

function table:spell(inpairs)
	if not inpairs then
		local i = 1
		while i <= #self do
			if type(self[i]) == 'string' then
				local iid = spellinfo(self[i])
				if iid then
					self[i] = iid
					i = i+1
				else
					table.remove(self,i)
				end
			elseif type(self[i]) == 'table' then
				i = i+1
			else
				table.remove(self,i)
			end
		end
	else
		for i,j in pairs(self) do
			if type(j) == 'string' then
				local tsinfo = spellinfo(j)
				if tsinfo then
					self[i] = tsinfo
				else
					table.remove(self,i)
				end
			end
		end
	end
end

function table:upper(inpairs)
	if not inpairs then
		for i,j in ipairs(self) do
			if type(j) == 'string' then
				self[i] = j:upper()
			end
		end
	else
		for i,j in pairs(self) do
			if type(j) == 'string' then
				self[i] = j:upper()
			end
		end
	end
end

function foodcount()
	temp = 0
	for i,j in ipairs(eatfoodids) do
		temp = temp+itemcount(j)
	end
	return temp
end

function isfood(id)
	id = itemid(id)
	return table.binaryfind(eatfoodids,id) ~= nil
end

local travelnpcs = {{'Anderson', {folda = {32046,31580,7}, vega = {32022,31692,7}, tibia = {32234,31675,7}}},
					{'Carlson', {folda = {32046,31580,7}, senja = {32126,31665,7}, tibia = {32234,31675,7}}},
					{'Svenson', {vega = {32022,31692,7}, senja = {32126,31665,7}, tibia = {32234,31675,7}}},
					{'Nielson', {folda = {32046,31580,7}, senja = {32126,31665,7}, vega = {32022,31692,7}}},
					{'Chemar', {edron = {33193,31784,3}, farmine = {32983,31539,1}, hills = {32535,31837,4}, svargrond = {32254,31097,4}}},
					{'Iyad', {edron = {33193,31784,3}, hills = {32535,31837,4}, darashia = {33269,32441,6}, farmine = {32983,31539,1}}},
					{'Pino', {darashia = {33269,32441,6}, svargrond = {32254,31097,4}, farmine = {32983,31539,1}, hills = {32535,31837,4}}},
					{'Uzon', {darashia = {33269,32441,6}, farmine = {32983,31539,1}, svargrond = {32254,31097,4}, edron = {33193,31784,3}--[[, eclipse = nil--]]}},
					{'Melian', {darashia = {33269,32441,6}, edron = {33193,31784,3}, hills = {32535,31837,4}, svargrond = {32254,31097,4}}},
					{'Brodrosch', {cormaya = {33309,31989,15}, farmine = {33024,31552,10}}},
					{'Thorgrin', {cormaya = {33309,31989,15}, kazordoon = {33309,31989,15}}},					
					{'Captain Bluebear', {abdendriel = {32733,31668,6}, carlin = {32387,31821,6}, edron = {33193,31784,3}, libertybay = {32283,32893,6}, porthope = {32530,32784,6}, svargrond = {32341,31108,6}, venore = {32954,32023,6}, yalahar = {32816,31272,6}}},
					{'Captain Breezelda', {venore = {32954,32023,6}, thais = {32312,32211,6}, carlin = {32387,31821,6}}},
					{'Captain Cookie', {libertybay = {32298,32896,6}}},
					{'Captain Fearless', {abdendriel = {32733,31668,6}, carlin = {32387,31821,6}, edron = {33175,31764,6}, darashia = {33289,32480,6}, thais = {32312,32211,6}, porthope = {32530,32784,6}, ankrahmun = {33091,32883,6}, libertybay = {32283,32893,6}, svargrond = {32341,31108,6}, yalahar = {32816,31272,6}}},
					{'Captain Greyhound', {abdendriel = {32733,31668,6}, edron = {33175,31764,6}, svargrond = {32341,31108,6}, thais = {32312,32211,6}, venore = {32954,32023,6}, yalahar = {32816,31272,6}}},
					{'Captain Seagull', {carlin = {32387,31821,6}, edron = {33175,31764,6}, thais = {32312,32211,6}, venore = {32954,32023,6}, yalahar = {32816,31272,6}}},
					{'Captain Seahorse', {abdendriel = {32733,31668,6}, ankrahmun = {33091,32883,6}, carlin = {32387,31821,6}, cormaya = {33288,31956,6}, libertybay = {32283,32893,6}, porthope = {32530,32784,6}, thais = {32312,32211,6}, venore = {32954,32023,6}}},
					{'Captain Sinbeard', {darashia = {33289,32480,6}, venore = {32954,32023,6}, libertybay = {32283,32893,6}, porthope = {32530,32784,6}, edron = {33175,31764,6}, yalahar = {32816,31272,6}}},
					{'Charles', {ankrahmun = {33091,32883,6}, darashia = {33289,32480,6}, edron = {33175,31764,6}, thais = {32312,32211,6}, venore = {32954,32023,6}, libertybay = {32283,32893,6}, yalahar = {32816,31272,6}}},
					{'Jack Fate', {ankrahmun = {33091,32883,6}, darashia = {33289,32480,6}, edron = {33175,31764,6}, porthope = {32530,32784,6}, thais = {32312,32211,6}, venore = {32954,32023,6}, yalahar = {32816,31272,6}, goroma = {32161,32558,6}, libertybay = {32283,32893,6}}},
					{'Karith', {abdendriel = {32733,31668,6}, darashia = {33289,32480,6}, venore = {32954,32023,6}, ankrahmun = {33091,32883,6}, porthope = {32530,32784,6}, thais = {32312,32211,6}, libertybay = {32283,32893,6}, carlin = {32387,31821,6}}},
					{'Petros', {ankrahmun = {33091,32883,6}, venore = {32954,32023,6}, porthope = {32530,32784,6}, libertybay = {32283,32893,6}, yalahar = {32816,31272,6}}},
					{'Captain Haba', {hunt = {31942,31047,6}, svargrond = {32339,31117,7}}},
					{'Captain Jack', {tibia = {32205,31756,6}}},
					{'Captain Max', {calassa = {31920,32710,7}, libertybay = {32298,32896,6}, yalahar = {32804,31270,6}}},
					{'Captain Waverider', {pegleg = {32346,32625,7}, libertybay = {32350,32856,7}, passage = {32132,32912,7}}},
					{'Dalbrect', {passage = {32190,31957,6}}},
					{'Gurbasch', {kazordoon = {33309,31989,15}, farmine = {33024,31552,10}}},
					{'Harlow', {vengoth = {32857,31549,7}, yalahar = {32837,31364,7}}},
					{'Maris', {mistrock = {32640,31439,7}, fenrock = {32564,31313,7}, yalahar = {32649,31292,6}}},
					{'Pemaret', {edron = {33175,31764,6}, eremo = {33315,31882,7}}},
					{'Eremo', {cormaya = {33288,31956,6}}},
					{'Sebastian', {nargor = {32025,32812,7}, libertybay = {32316,32702,7}, meriana = {32346,32625,7}}},
					{'Buddel', {okolnir = {32224,31381,7}, camp = {32153,31376,7}, tyrsung = {32333,31227,7}, helheim = {32462,31174,7}, svargrond = {32256,31197,7}}},
					{'Rapanaio', {kazordoon = {32700,31989,15}, isleofevil = {32667,31452,7}}},
					{'Imbul', {east = {32679,32777,7}, center = {32628,32771,7}--[[, mountain = --]], chor = {32968,32799,7}--[[, banuta--]]}},
					{'Old Adall', {east = {32679,32777,7}, west = {32558,32780,7}--[[, mountain = --]], chor = {32968,32799,7}--[[, banuta--]]}},
					{'Lorek', {center = {32628,32771,7}, west = {32558,32780,7}--[[, mountain = --]], chor = {32968,32799,7}--[[, banuta--]]}},
					{'Tarak', {monument = {32941,31182,7}, yalahar = {32916,31199,7}}},
					{'Barry', {magician = {32884,31156,7}, sunken = {32884,31164,7}}, 'yalaharguard'},
					{'Bruce', {alchemist = {32737,31113,7}, cemetery = {32745,31113,7}}, 'yalaharguard'},
					{'Hal', {arena = {32688,31195,7}, alchemist = {32688,31187,7}}, 'yalaharguard'},
					{'Oliver', {factory = {32895,31233,7}, sunken = {32895,31225,7}}, 'yalaharguard'},
					{'Peter', {factory = {32860,31302,7}, trade = {32853,31302,7}}, 'yalaharguard'},
					{'Reed', {cemetery = {32798,31103,7}, magician = {32806,31103,7}}, 'yalaharguard'},
					{'Tony', {arena = {32695,31253,7}, foreigner = {32695,31260,7}}, 'yalaharguard'}}

function findtravelnpc()
	for i,j in ipairs(travelnpcs) do
		npcname = j[1]
		foreach creature m 'mf' do
			if m.name == npcname then
				return m, i
			end
		end
	end
	return nil
end

function travel(destin, havering) -- Credits to botterxxx for finding all the destination positions.
	destin = destin:lower()
	if havering == nil and itemcount('dwarven ring') > 0 then
		havering = true
	end
	local destination
	local locationsconvert = {{{"ab'dendriel", "ab dendriel", "abdendriel"}, {"ab'dendriel", "abdendriel"}},
							  {{"libertybay", "liberty bay"}, {"liberty bay", "libertybay"}},
							  {{"port hope", "porthope"}, {"port hope", "porthope"}},
							  {{"pegleg", "peg leg", "meriana"}, {"peg leg", "pegleg"}},
							  {{"treasureisland", "treasure island"}, {"passage", "passage"}},
							  {{"isle of the kings", "isleofthekings"}, {"passage", "passage"}},
							  {{"sea serpent", "seaserpent", "seaserpents","sea serpents"}, {"hunt", "hunt"}},
							  {{"barbarian", "barbarian camp", "krimhorn"}, {"camp", "camp"}},
							  {{"femor", "femur", "femur hills", "femor hills", "femurhils", "femorhills"}, {"hills", "hills"}},
							  {{"darama"}, {"darashia", "darashia"}},
							  {{"monument tower", "monument", "trip"}, {"passage", "monument"}},
							  {{"isle of evil", "isleofevil"}, {"isle of evil", "isleofevil"}}}
	for i,j in ipairs(locationsconvert) do
		if table.find(j[1],destin) then
			destin = j[2][1]
			destination = j[2][2]
			break
		end
	end
	if not destination then
		destination = destin
	end
	local tries,maxtries = 0,math.random(1,4)
	local destinreached = false
	while not destinreached do
		local npcinfo,npcpos = findtravelnpc()
		if not npcinfo then
			printerror('There is no travel NPC on your screen.')
			return
		end
		if not travelnpcs[npcpos][2][destination] then
			printerror("The NPC '" ..npcinfo.name.. "' cant take you to '" ..destin.. "'.")
			return
		end
		local phrases = {destin, 'yes'}
		if travelnpcs[npcpos][3] then
			if travelnpcs[npcpos][3] == 'yalaharguard' then
				phrases = {'pass', destin}
			end
		elseif npcinfo.name == 'Captain Fearless' and destin == 'darashia' then
			phrases = {destin, 'yes', 'yes'}
		elseif npcinfo.name == 'Buddel' then
			if havering then
				phrases = {'go', destin, 'no', 'yes'}
			else
				phrases = {'go', destin, 'yes'}
			end
		end
		if not travelnpcs[npcpos][3] then
			while npcinfo.dist > 2 do
				reachcreature(npcinfo.name) waitping()
			end
		else
			while npcinfo.dist > 3 do
				reachgrounditem(8617)
				reachgrounditem(8569)
				wait(1500)
			end
		end
		if ischannel('NPCs') then
			npcsay('hi') waitping()
		else
			say('hi') wait(2000,3000)
		end
		for i,j in ipairs(phrases) do
			npcsay(j) waitping()
		end
		waitping(5,8)
		tries = tries+1
		local desttable = (travelnpcs[npcpos][2][destination])
		destinreached = (math.abs($posx-desttable[1]) <= 2 and math.abs($posy-desttable[2]) <= 2 and $posz == desttable[3])
		if not destinreached and npcinfo.name ~= 'Buddel' and tries >= maxtries then
			printerror("Unable to travel to '" ..destin.."' trought NPC '"..npcinfo.name.."'. DestinationPos: "..desttable[1]..','..desttable[2]..','..desttable[3])
			return
		end
	end
end

function collectitems(bpname,...)
	local itemids = {...}
	table.id(itemids)
	if not bpname then
		bpname = ''
	elseif type(bpname) == 'number' then
		table.insert(itemids,bpname)
		bpname = ''
	end
	for j=-1,1 do
		for i=-1,1 do
			local t = topitem($posx+i,$posy+j,$posz).id
			if itemproperty(t,ITEM_PICKUPABLE) and (#itemids == 0 or table.find(itemids,t)) then
				pausewalking(10000)
				moveitems(t,bpname,ground($posx+i,$posy+j,$posz),100)
				pausewalking(0)
				break
			end
		end
	end
end

function usegrounditem(x,y,z)
	if not x then
		return
	elseif type(x) == 'string' then
		x = itemid(x)
	end
	if not y or not z then
		useitem(x,'ground')
	else
		useitem(topitem(x,y,z).id,ground(x,y,z))
	end
	return
end

function paroundignore(dist,...)
	return paround(dist)-paround(dist,...)
end

function maroundignore(dist,...)
	return maround(dist)-maround(dist,...)
end

function enchantspear(hand)
	local locationto,weaponid,handpos
	local mana = 350
	local spell = 'exeta con'
	if (itemcount(3277) == 0) or ($mp < mana) or (spell == nil) or not cooleddown('exeta con') then
		return false
	end
	if $belt.id == 0 then
		locationto = 'belt'
	else
		locationto = 'backpack'
	end
	if (hand == nil) or (hand == 'left') or (hand == 'lhand') then
		hand = $lhand
		handpos = 'lhand'
	elseif (hand == 'right') or (hand == 'rhand') then
		hand = $rhand
		handpos = 'rhand'
	end
	weaponid = hand.id
	while (hand.id ~= 0) do
		listas('Unequipping Weapon')
		moveitems(weaponid,locationto,handpos,100)
		waitping()
	end
	while (hand.id == 0) do
		listas('Equipping Spear')
		moveitems(3277,handpos,'0-15',1)
		waitping()
	end
	while (hand.id ~= 7367) and (hand.id == 3277) do
		listas('Enchanting Spear')
		cast(spell)
		waitping()
	end
	while (hand.id ~= 0) do
		listas('Unequipping Enchanted Spear')
		moveitems(7367,locationto,handpos,100)
		waitping()
	end
	while (hand.id == 0) do
		listas('Equipping Weapon')
		moveitems(weaponid,handpos,'0-15',100)
		waitping()
	end
end

function dropitems(pos,...)
	setlifetime(180000)
	local items = {...}
	table.id(items)
	if type(pos) == 'string' and pos:token(1) ~= 'ground' then
		table.insert(items,itemid(pos))
		pos = 'ground'
	elseif type(pos) == 'number' then
		table.insert(items,pos)
		pos = 'ground'
	end
	for i,j in ipairs(items) do
		while itemcount(j,'0-15') > 0 do
			moveitems(j,pos,'0-15',100)
		end
	end
end

function itemsaround(dist,...) -- by golfinhu
	local itemlist = {...}
	table.id(itemlist)
	if not dist or dist == 0 then
		dist = 7
	elseif dist > 7 or type(dist) == 'string' then
		table.insert(itemlist,itemid(dist))
		dist = 7
	end
	local total = 0
	for a=-dist,dist do
		for b=-dist,dist do
			local itemontop = topitem($posx+a,$posy+b,$posz)
			if tilehasinfo($posx+a, $posy+b, $posz) and not itemproperty(itemontop.id,ITEM_GROUND) and (table.find(itemlist,itemontop.id) or #itemlist == 0) then
				total = total+itemontop.count
			end
		end
	end
	return total
end

function totalitems(location,...)
	local itemlist = {...}
	if type(location) == 'number' then
		if location > 15 then
			table.insert(itemlist,location)
			location = ''
		else
			location = tostring(location)
		end
	end
	local total = 0
	for i,j in ipairs(itemlist) do
		total = total+itemcount(j,location)
	end
	return total
end

function fishinice(x, y, z, pickid) -- by botterxxx
	if pickid == nil then
		pickid = 3456
	end
	if x and y and z and math.abs($posx-x) <= 7 and math.abs($posy-y) <= 5 and $posz == z then
		reachlocation(x,y,z)
		if (isitemontile(7200,x,y,z) or isitemontile(7236,x,y,z)) and not ($posx == x and $posy == y and $posz == z) then
			local id = topitem(x,y,z).id
			while id ~= 7237 do
				if id == 7200 then
					useitemon(pickid,id,ground(x,y,z))
				elseif id == 7236 then
					useitemon(3483,id,ground(x,y,z))
				elseif not itemproperty(id,ITEM_NOTMOVEABLE) then
					moveitems(id,ground($posx,$posy,$posz),ground(x,y,z),100)
				else
					return false
				end
				id = topitem(x,y,z).id
			end
			return true
		end
	end
	return false
end

--[[function movelevitate(direction,updown,times)
	local dir = {x = {n = 0, s = 0, w = -1, e = 1},
				 y = {n = -1, s = 1, w = 0, e = 0}}
	if type(times) ~= 'number' then
		times = math.random(3,5)
	end
	if direction == 'w' or direction == 'e' or direction == 'n' or direction == 's' then
		local startz = $posz
		for i=1,times do
			move(direction) waitping()
			if $posz ~= startz then
				return true
			end
		end
		return levitate(direction, updown)
	end
	return false
end--]]

function getdirpos(direction,z)
	z = z or $posz
	local dir = {x = {c = 0, n = 0, s = 0, w = -1, e = 1, nw = -1, ne = 1, sw = -1, se = 1},
				 y = {c = 0, n = -1, s = 1, w = 0, e = 0, nw = -1, ne = -1, sw = 1, se = 1}}
	if dir.x[direction] then
		return {$posx+dir.x[direction],$posy+dir.y[direction],z}
	end
end

function movelevitate(direction)
	local dir = {x = {n = 0, s = 0, w = -1, e = 1},
				 y = {n = -1, s = 1, w = 0, e = 0}}
	if not dir.x[direction] then return false end
	local x,y,z = $posx,$posy,$posz
	local p = gettile($posx+dir.x[direction],$posy+dir.y[direction],$posz)
	local updown = 'up'
	if (p.itemcount == 1 and not itemproperty(p.item[1].id, ITEM_NOTROOFEDGE)) or p.itemcount == 0 then
		x,y,z = $posx+dir.x[direction],$posy+dir.y[direction],$posz+1
		updown = 'down'
	end
	local t = gettile(x,y,z)
	local count = 0
	print($posx,$posy,$posz,x,y,z, t.itemcount)
	for i=2, t.itemcount do
		if itemproperty(t.item[i].id, ITEM_HEIGHTED) and not itemproperty(t.item[i].id, ITEM_BLOCKWALK) then
			count = count + 1
			if count >= 3 then break end
		end
	end
	if count >= 3 then
		local i = 1
		local z = $posz
		while i <= 3 and $posz == z do
			move(direction) waitping()
			i = i+1
		end
		if $posz ~= z then
			return true
		end
	else
		return levitate(direction, updown)
	end
	return false
end

sealv = movelevitate

function sio(hppc,...)
	if not cancastspell('heal friend') then
		return false
	end
	local friends,toheal = {findcreature(...)}
	for i,j in ipairs(friends) do
		if j.hppc < hppc and j.isplayer then
			toheal = j
			hppc = j.hppc
		end
	end
	if toheal then
		local msg = 'exura sio "'..toheal.name
		if clientspellhotkey(msg) ~= 'not found' then
			cast(msg) return true
		end
		if not toheal.name:find(' +') then
			msg = 'exura sio '..toheal.name
			if clientspellhotkey(msg) ~= 'not found' then
				cast(msg) return true
			end
		else
			printerror('Unable to find a hotkey for player: '..toheal.name)
		end
	end
	return false
end

function massheal(hppc,amount,considerenemies,enemylist,...)
	if not cancastspell('mass healing') then
		return false
	end
	local friends = {...}
	if type(considerenemies) ~= 'boolean' and considerenemies then
		table.insert(friends,considerenemies)
		considerenemies = nil
		if enemylist and type(enemylist) ~= 'table' then
			table.insert(friends,enemylist)
			enemylist = nil
		end
	end
	local f,e=0,0
	local creatures = {findcreaturesonspellrange('3x3','any','s')}
	for i,j in ipairs(creatures) do
		if j.hppc <= hppc and ((j.isplayer and (#friends == 0 or table.find(friends,j.name:lower()))) or (j.ismonster and table.find(friends,j.id))) then
			f = f+1
		elseif considerenemies and table.find(enemylist,j.name:lower()) then
			e = e+1
		end
	end
	if f >= amount and e == 0 then
		cast('exura gran mas res')
		return true
	end
	return false
end

function uh(hppc,...)
	local friends,toheal = {findcreature(...)}
	for i,j in ipairs(friends) do
		if j.hppc < hppc then
			toheal = j
			hppc = j.hppc
		end
	end
	if toheal then
		useoncreature(3160,toheal)
		return true
	end
	return false
end

function ih(hppc,...)
	local friends,toheal = {findcreature(...)}
	for i,j in ipairs(friends) do
		if j.hppc < hppc then
			toheal = j
			hppc = j.hppc
		end
	end
	if toheal then
		useoncreature(3152,toheal)
		return true
	end
	return false
end

function balance()
	return $balance
end

function opentrade(n, sayhi)
	if type(n) == 'boolean' then
		sayhi = n
		n = nil
	end
	n = n or math.random(3,5)
	if not ischannel('NPCs') then
		local nhi = math.random(3,5)
		local trieshi = 0
		while (not ischannel('NPCs') or sayhi) and trieshi < nhi do
			say('hi')
			local waittime = $timems+2500
			while $timems < waittime and not ischannel('NPCs') do wait(100) end
			trieshi = trieshi+1
		end
		if not ischannel('NPCs') then
			return false
		end
	end
	local tries = 0
	while not $tradeopen and tries < n do
		npcsay('trade')
		local waittime = $timems+1400
		while $timems < waittime do
			wait(100)
			if $tradeopen then
				return true
			end
		end
		tries = tries + 1
	end
	return false
end

local weapons = {
axe =  {
		name = {"Angelic Axe", "Axe", "Barbarian Axe", "Battle Axe", "Beastslayer Axe", "Butcher's Axe", "Daramanian Axe", "Daramanian Waraxe", "Demonwing Axe", "Double Axe", "Dragon Lance", "Drakinata", "Dreaded Cleaver", "Dwarven Axe", "Earth Barbarian Axe", "Earth Headchopper", "Earth Heroic Axe", "Earth Knight Axe", "Earth War Axe", "Energy Barbarian Axe", "Energy Headchopper", "Energy Heroic Axe", "Energy Knight Axe", "Energy War Axe", "Executioner", "Fiery Barbarian Axe", "Fiery Headchopper", "Fiery Heroic Axe", "Fiery Knight Axe", "Fiery War Axe", "Fire Axe", "Glorious Axe", "Golden Sickle", "Great Axe", "Guardian Halberd", "Halberd", "Hand Axe", "Hatchet", "Headchopper", "Hellforged Axe", "Heroic Axe", "Icy Barbarian Axe", "Icy Headchopper", "Icy Heroic Axe", "Icy Knight Axe", "Icy War Axe", "Impaler", "Knight Axe", "Mythril Axe", "Naginata", "Noble Axe", "Obsidian Lance", "Orcish Axe", "Ornamented Axe", "Ravager's Axe", "Ravenwing", "Reaper's Axe", "Ripper Lance", "Royal Axe", "Ruthless Axe", "Scythe of the Reaper", "Sickle", "Solar Axe", "Steel Axe", "Stonecutter Axe", "Titan Axe", "Twin Axe", "Vile Axe", "War Axe", "Zaoan Halberd"},
		id = {7436, 3274, 3317, 3266, 3344, 7412, 3329, 3328, 8098, 3275, 3302, 10388, 7419, 3323, 783, 787, 786, 785, 788, 801, 804, 803, 802, 805, 7453, 665, 668, 667, 666, 669, 3320, 7454, 3306, 3303, 3315, 3269, 3268, 3276, 7380, 8096, 7389, 684, 687, 686, 685, 688, 7435, 3318, 7455, 3314, 7456, 3313, 3316, 7411, 3331, 7433, 7420, 3346, 7434, 6553, 9384, 3293, 8097, 7773, 3319, 7413, 3335, 7388, 3342, 10406},
		atk = {44, 12, 28, 25, 35, 41, 0, 39, 53, 35, 47, 47, 40, 31, 23, 34, 35, 27, 39, 23, 34, 35, 27, 39, 51, 23, 34, 35, 27, 39, 27, 40, 13, 52, 46, 35, 10, 15, 42, 51, 44, 23, 34, 35, 27, 39, 49, 33, 48, 39, 39, 34, 23, 42, 49, 45, 46, 28, 47, 50, 16, 5, 52, 21, 50, 43, 45, 43, 48, 37}
		},
sword = {
		name = {"Assassin Dagger", "Berserker", "Blacksteel Sword", "Blade of Corruption", "Bloody Edge", "Bone Sword", "Bright Sword", "Broadsword", "Carlin Sword", "Combat Knife", "Crimson Sword", "Crystal Sword", "Dagger", "Demonrage Sword", "Djinn Blade", "Dragon Slayer", "Earth Blacksteel Sword", "Earth Dragon Slayer", "Earth Mystic Blade", "Earth Relic Sword", "Earth Spike Sword", "Emerald Sword", "Energy Blacksteel Sword", "Energy Dragon Slayer", "Energy Mystic Blade", "Energy Relic Sword", "Energy Spike Sword", "Epee", "Farmer's Avenger", "Fiery Blacksteel Sword", "Fiery Dragon Slayer", "Fiery Mystic Blade", "Fiery Relic Sword", "Fiery Spike Sword", "Fire Sword", "Giant Sword", "Haunted Blade", "Havoc Blade", "Heavy Machete", "Ice Rapier", "Icy Blacksteel Sword", "Icy Dragon Slayer", "Icy Mystic Blade", "Icy Relic Sword", "Icy Spike Sword", "Incredible Mumpiz Slayer", "Jagged Sword", "Katana", "Knife", "Longsword", "Machete", "Magic Longsword", "Magic Sword", "Mercenary Sword", "Mystic Blade", "Nightmare Blade", "Pharaoh Sword", "Poet's Fencing Quill", "Pointed Rabbitslayer", "Poison Dagger", "Rapier", "Relic Sword", "Ron the Ripper's Sabre", "Runed Sword", "Sabre", "Sais", "Scimitar", "Serpent Sword", "Short Sword", "Silver Dagger", "Spike Sword", "Sword", "Templar Scytheblade", "Thaian Sword", "The Avenger", "The Epiphany", "The Justice Seeker", "Twiceslicer", "Twin Hooks", "Two Handed Sword", "Warlord Sword", "Wyvern Fang", "Zaoan Sword"},
		id = {7404, 7403, 7406, 11693, 7416, 3338, 3295, 3301, 3283, 3292, 7385, 7449, 3267, 7382, 3339, 7402, 782, 783, 781, 780, 779, 8102, 797, 798, 796, 795, 794, 3326, 9386, 663, 664, 662, 661, 660, 3280, 3281, 7407, 7405, 3330, 3284, 682, 683, 681, 680, 679, 9396, 7774, 3300, 3291, 3285, 3308, 3278, 3288, 7386, 7384, 7418, 3334, 9387, 9375, 3299, 3272, 7383, 6101, 7417, 3273, 10389, 3307, 3297, 3294, 3290, 3271, 3264, 3345, 7391, 6527, 8103, 7390, 11657, 10392, 3265, 3296, 7408, 10390},
		atk = {40, 48, 42, 48, 43, 13, 36, 26, 15, 8, 28, 35, 8, 47, 38, 44, 35, 35, 36, 34, 20, 49, 35, 35, 36, 34, 20, 37, 17, 35, 35, 36, 34, 20, 24, 46, 40, 49, 16, 42, 35, 35, 36, 34, 20, 17, 21, 16, 5, 17, 12, 55, 48, 43, 44, 46, 41, 10, 16, 16, 10, 42, 12, 45, 12, 45, 19, 18, 11, 9, 24, 14, 23, 45, 50, 50, 47, 47, 32, 30, 53, 32, 43}
		 },
club = {
		name = {"Abyss Hammer", "Amber Staff", "Arcane Staff", "Banana Staff", "Battle Hammer", "Blessed Sceptre", "Bone Club", "Bonebreaker", "Brutetamer's Staff", "Chaos Mace", "Clerical Mace", "Club", "Club of the Fury", "Cranial Basher", "Crowbar", "Crystal Mace", "Daramanian Mace", "Dark Trinity Mace", "Demonbone", "Diamond Sceptre", "Drachaku", "Dragon Hammer", "Dragonbone Staff", "Earth Clerical Mace", "Earth Cranial Basher", "Earth Crystal Mace", "Earth Orcish Maul", "Earth War Hammer", "Enchanted Staff", "Energy Clerical Mace", "Energy Cranial Basher", "Energy Crystal Mace", "Energy Orcish Maul", "Energy War Hammer", "Fiery Clerical Mace", "Fiery Cranial Basher", "Fiery Crystal Mace", "Fiery Orcish Maul", "Fiery War Hammer", "Furry Club", "Giant Smithhammer", "Glutton's Mace", "Hammer of Prophecy", "Hammer of Wrath", "Heavy Mace", "Icy Clerical Mace", "Icy Cranial Basher", "Icy Crystal Mace", "Icy Orcish Maul", "Icy War Hammer", "Iron Hammer", "Jade Hammer", "Lich Staff", "Light Mace", "Lunar Staff", "Mace", "Mammoth Whopper", "Morning Star", "Northern Star", "Obsidian Truncheon", "Onyx Flail", "Orcish Maul", "Queen's Sceptre", "Sapphire Hammer", "Scythe", "Shadow Sceptre", "Silver Mace", "Skull Staff", "Skullcrusher", "Snake God's Sceptre", "Spiked Squelcher", "Staff", "Stale Bread of Ancientness", "Studded Club", "Taurus Mace", "The Stomper", "Thunder Hammer", "War Hammer"},
		id = {7414, 7426, 3341, 3348, 3305, 7429, 3337, 7428, 7379, 7427, 3311, 3270, 9385, 7415, 3304, 3333, 3327, 8099, 7431, 7387, 10391, 3322, 7430, 789, 791, 790, 792, 793, 3321, 806, 808, 807, 809, 810, 670, 672, 671, 673, 674, 7432, 3208, 9373, 7450, 3332, 3340, 689, 691, 690, 692, 693, 3310, 7422, 3343, 3325, 7424, 3286, 7381, 3282, 7409, 8100, 7421, 7392, 7410, 7437, 3453, 7451, 3312, 3324, 7423, 11692, 7452, 3289, 9376, 3336, 7425, 8101, 3309, 3279},
		atk = {47, 43, 50, 25, 24, 47, 12, 46, 35, 44, 28, 7, 16, 44, 5, 38, 21, 51, 48, 34, 46, 32, 35, 23, 36, 31, 35, 36, 39, 23, 36, 31, 35, 36, 23, 36, 31, 35, 36, 31, 24, 16, 0, 48, 49, 23, 36, 31, 35, 36, 18, 46, 40, 0, 40, 16, 30, 25, 0, 50, 45, 42, 43, 37, 8, 39, 41, 36, 51, 0, 41, 10, 18, 9, 30, 51, 49, 45}
		}		}

function weaponattack(id)
	local handn,hand
	if not id then
		handn, hand = findweapon()
		id = hand.id
	end
	for i,j in ipairs(weapons.axe.id) do
		if hand.id == j then
			return weapons.axe.atk[i]
		end
	end
	for i,j in ipairs(weapons.sword.id) do
		if hand.id == j then
			return weapons.sword.atk[i]
		end
	end
	for i,j in ipairs(weapons.club.id) do
		if hand.id == j then
			return weapons.club.atk[i]
		end
	end
	return 0
end

function strikespellinfo(creaturename, strong)
    if creaturename == '' then return nil end
	local swords
	local spells
	if strong then
		swords = 'exori gran '..getelementword(bestelement(creaturename, true))
		spells = {
					{name="strong ice strike", words="exori gran frigo", type="instant", level=80, mp=60, price=6000, premium=true, soul=0, mlevel=0, condition=3},
					{name="strong flame strike", words="exori gran flam", type="instant", level=70, mp=60, price=6000, premium=true, soul=0, mlevel=0, condition=3},
					{name="strong energy strike", words="exori gran vis", type="instant", level=80, mp=60, price=7500, premium=true, soul=0, mlevel=0, condition=3},
					{name="strong terra strike", words="exori gran tera", type="instant", level=70, mp=60, price=6000, premium=true, soul=0, mlevel=0, condition=3},
				 }
	else
		swords = 'exori '..getelementword(bestelement(creaturename, false))
		spells = {
					{name="death strike", words="exori mort", type="instant", level=16, mp=20, price=800, premium=true, soul=0, mlevel=0, condition=3},
					{name="physical strike", words="exori moe ico", type="instant", level=16, mp=20, price=800, premium=true, soul=0, mlevel=0, condition=3},
					{name="ice strike", words="exori frigo", type="instant", level=15, mp=20, price=800, premium=true, soul=0, mlevel=0, condition=3},
					{name="flame strike", words="exori flam", type="instant", level=14, mp=20, price=800, premium=true, soul=0, mlevel=0, condition=3},
					{name="energy strike", words="exori vis", type="instant", level=12, mp=20, price=800, premium=true, soul=0, mlevel=0, condition=3},
					{name="terra strike", words="exori tera", type="instant", level=13, mp=20, price=800, premium=true, soul=0, mlevel=0, condition=3},
				 }
	end
	local pos = table.find(spells,swords,'words')
	if not pos then
		if not noalert then printerror("Spell: \'"..name.."\' not found") end
		return
	end
	return spells[pos]
end

function cancastspell(spellname, who)
	local needarea,castspellinfo = false
	if type(spellname) == 'string' then
		spellname = spellname:lower()
		if spellname == 'strike' then
			castspellinfo = strikespellinfo(who.name)
		elseif spellname == 'strong strike' then
			castspellinfo = strikespellinfo(who.name,true)
		else
			castspellinfo = spellinfo(spellname)
		end
	elseif type(spellname) == 'table' then
		castspellinfo = spellname
	end
	who = findcreature(who)
	if castspellinfo then
		if who and who.id > 0 and (castspellinfo.condition and castspellinfo.condition ~= 'word') then
			needarea = true
			if $attacked.id == 0 and (table.find({'holy flash', 'divine missile', 'lightning', 'ice strike', 'flame strike', 'terra strike', 'energy strike', 'strong ice strike', 'strong flame strike', 'strong terra strike', 'strong energy strike', 'ultimate ice strike', 'ultimate flame strike', 'ultimate terra strike', 'ultimate energy strike', 'physical strike'}, castspellinfo.name)) then
				castspellinfo.condition = 'strike'
			end
		end
		return ($mp >= castspellinfo.mp and $level >= castspellinfo.level and $mlevel >= castspellinfo.mlevel and $soul >= castspellinfo.soul and cooleddown(castspellinfo.name) and (not needarea or isonspellarea(who,castspellinfo.condition)))
	end
	return false
end

function moveitemonground(x,y,z,a,b,c)
	moveitems(topitem(x,y,z).id,ground(a,b,c),ground(x,y,z),100)
end

function wheretomoveitemtable(x,y,z,id)
	local dire = {x = {c = 0, n = 0, s = 0, w = -1, e = 1, nw = -1, ne = 1, sw = -1, se = 1},
				  y = {c = 0, n = -1, s = 1, w = 0, e = 0, nw = -1, ne = -1, sw = 1, se = 1}}
	local dirs = {'nw', 'n', 'ne', 'w', 'e', 'sw', 's', 'se'}
	z = z or $posz
	if not (x or y) or not (x > 0 or y > 0) then
		x,y = $posx,$posy
	end
	local randmove = {}
	for _,p in ipairs(dirs) do
		local i,j = dire.x[p], dire.y[p]
		local dest = {x = x+i, y = y+j}
		local tile = gettile(dest.x, dest.y, z)
		local canmove = true
		local k=1
		if tile.itemcount > 0 then
			while (k <= tile.itemcount) and canmove do
				local itid = tile.item[k].id
				if itid > 0 and ((itemproperty(itid, ITEM_BLOCKWALK) and (not itemproperty(itid, ITEM_TOPORDER2) or not itemproperty(itid, ITEM_HEIGHTED))) or (k == 1 and not itemproperty(itid, ITEM_NOTROOFEDGE))) then
					canmove = false
				end
				k = k+1
			end
		else
			canmove = false
		end
		if canmove then
			table.insert(randmove, {p, i, j})
		end
	end
	return randmove
end

function wheretomoveitem(x,y,z,id)
	if id and id == 99 then
		return wheretomovecreature(x,y,z)
	end
	z = z or $posz
	local dir
	local randmove = wheretomoveitemtable(x,y,z,id)
	if #randmove > 0 then
		return table.unpack(randmove[math.random(1,#randmove)])
	end
	return '', 0, 0
end

function wheretomovecreaturetable(x,y,z,id)
	local dire = {x = {c = 0, n = 0, s = 0, w = -1, e = 1, nw = -1, ne = 1, sw = -1, se = 1},
				  y = {c = 0, n = -1, s = 1, w = 0, e = 0, nw = -1, ne = -1, sw = 1, se = 1}}
	local dirs = {'nw', 'n', 'ne', 'w', 'e', 'sw', 's', 'se'}
	z = z or $posz
	if not (x or y) or not (x > 0 or y > 0) then
		x,y = $posx,$posy
	end
	local randmove = {}
	for _,p in ipairs(dirs) do
		local i,j = dire.x[p], dire.y[p]
		local dest = {x = x+i, y = y+j}
		if (id ~= 99 or (dest.x ~= $posx or dest.y ~= $posy)) then
			local tile = gettile(dest.x, dest.y, z)
			local canmove = true
			local k=1
			if tile.itemcount > 0 then
				while (k <= tile.itemcount) and canmove do
					local itid = tile.item[k].id
					if itid > 0 and itemproperty(itid,ITEM_BLOCKWALK) or itemproperty(itid, ITEM_BLOCKPATHS) or itemproperty(itid, ITEM_FLOORCHANGE) or itid == 99 then
						canmove = false
					end
					k = k+1
				end
			else
				canmove = false
			end
			if canmove then
				table.insert(randmove, {p, i, j})
			end
		end
	end
	return randmove
end

function wheretomovecreature(x,y,z,dir)
	local dire = {dirs = {'c', 'n', 's', 'w', 'e', 'nw', 'ne', 'sw', 'se'},
					 x = {c = 0, n = 0, s = 0, w = -1, e = 1, nw = -1, ne = 1, sw = -1, se = 1},
					 y = {c = 0, n = -1, s = 1, w = 0, e = 0, nw = -1, ne = -1, sw = 1, se = 1}}
	local dirs = {'nw', 'n', 'ne', 'w', 'e', 'sw', 's', 'se'}
	z = z or $posz
	local randmove = {}
	if not dir then
		randmove = wheretomovecreaturetable(x,y,z)
	else
		local i,j = dire.x[dir],dire.y[dir]
		local tile = gettile(x+i,y+j,z)
		local k=1
		local canmove = true
		if tile.itemcount > 0 then
			while (k <= tile.itemcount) and canmove do
				local itid = tile.item[k].id
				if itid > 0 and itemproperty(itid,ITEM_BLOCKWALK) or itemproperty(itid, ITEM_BLOCKPATHS) or itemproperty(itid, ITEM_FLOORCHANGE) or itid == 99 then
					canmove = false
				end
				k = k+1
			end
		else
			canmove = false
		end
		if canmove then
			return dir, i, j
		else
			return '', 0, 0
		end
	end
	if #randmove > 0 then
		return table.unpack(randmove[math.random(1,#randmove)])
	end
	return '', 0, 0
end

function movecreature(who, direction)
	if who then
		who = findcreature(who)
	end
	if who.dist > 1 then return false end
	local movecreatureto = {}
	local dir,dirx,diry = wheretomovecreature(who.posx,who.posy,who.posz,direction)
	if dir ~= '' then
		local topid = topitem(who.posx,who.posy,who.posz).id
		movecreatureto = {dirx+who.posx,diry+who.posy,$posz}
		if who.posz == $posz and not (movecreatureto[1] == who.posx and movecreatureto[2] == who.posy) and not (movecreatureto[1] == $posx and movecreatureto[2] == $posy) and (itemproperty(topid,ITEM_GROUND) or itemproperty(topid, ITEM_NOTMOVEABLE)) then
			moveitems(99,ground(table.unpack(movecreatureto)),ground(who.posx,who.posy,who.posz),100) wait(1200,1500)
		end
	end
end

function maroundspell(spelltype,direction,...)
	local monsters = {...}
	local dirs = {'w', 'e', 's', 'n', 'any'}
	table.lower(monsters)
	if type(direction) == 'string' then
		if not table.find(dirs,direction) then
			table.insert(monsters,direction:lower())
			direction = $self.dir
		end
	elseif not direction then
		direction = $self.dir
	end
	local count = 0
	foreach creature m 'mf' do
		if isonspellarea(m,spelltype,direction) and (#monsters == 0 or table.findcreature(monsters,m)) then
			count = count+1
		end
	end
	return count
end

function paroundspell(spelltype,direction,...)
	local players = {...}
	local dirs = {'w', 'e', 's', 'n', 'any'}
	table.lower(players)
	if type(direction) == 'string' then
		if not table.find(dirs,direction) then
			table.insert(players,direction:lower())
			direction = $self.dir
		end
	elseif not direction then
		direction = $self.dir
	end
	local count = 0
	foreach creature p 'pf' do
		if p ~= $self and isonspellarea(p,spelltype,direction) and (#players == 0 or table.findcreature(players,p)) then
			count = count+1
		end
	end
	return count
end

function maroundspellignore(spelltype,direction,...)
	local monsters = {...}
	local dirs = {'w', 'e', 's', 'n', 'any'}
	table.lower(monsters)
	if type(direction) == 'string' then
		if not table.find(dirs,direction) then
			table.insert(monsters,direction:lower())
			direction = $self.dir
		end
	elseif not direction then
		direction = $self.dir
	end
	local count = 0
	foreach creature m 'mf' do
		if isonspellarea(m,spelltype,direction) and (#monsters == 0 or not table.findcreature(monsters,m)) then
			count = count+1
		end
	end
	return count
end

function paroundspellignore(spelltype,direction,...)
	local players = {...}
	local dirs = {'w', 'e', 's', 'n', 'any'}
	table.lower(players)
	if type(direction) == 'string' then
		if not table.find(dirs,direction) then
			table.insert(players,direction:lower())
			direction = $self.dir
		end
	elseif not direction then
		direction = $self.dir
	end
	local count = 0
	foreach creature p 'pf' do
		if p ~= $self and isonspellarea(p,spelltype,direction) and (#players == 0 or not table.findcreature(players,p)) then
			count = count+1
		end
	end
	return count
end

function potionfriend(id,pc,dist,...)
	local friends,toheal = {findcreature(...)}
	if type(id) == 'string' then
		id = itemid(id)
	elseif type(id) == 'number' and id <= 100 and id > 0 then
		table.insert(friends,1,findcreature(dist))
		dist = pc
		pc = id
		id = nil
	end
	if not id then
		local potions = {
							{id = 7643, level = 130},
							{id = 239, level = 80},
							{id = 236, level = 50},
							{id = 266, level = 0}
						}
		for i,j in ipairs(potions) do
			if itemcount(j.id) > 0 and $level >= j.level then
				id = j.id
				break
			end
		end
	end
	if type(pc) ~= 'number' or pc < 0 or pc > 100 then
		pc = 95
	end
	if type(dist) ~= 'number' or dist > 7 then
		dist = 1
	end
	table.newsort(friends,'hppc','desc')
	for i,j in ipairs(friends) do
		if j.dist <= dist then
			if j.hppc < pc or (j.hppc == pc and (not toheal or j.dist < toheal.dist)) then
				toheal = j
				pc = j.hppc
			else
				break
			end
		end
	end
	if toheal then
		useoncreature(id,toheal)
		return true
	end
	return false
end

function currenttime()
	return os.date('%X')
end

function tosec(t)
	t = t or os.date('%X')
	if type(t) ~= 'string' then
		return 0
	end
	local temp = t:token(nil,':')
	local temp2 = tonumber(temp[1])*3600+tonumber(temp[2])*60
	if temp[3] then
		temp2 = temp2+tonumber(temp[3])
	end
	return temp2
end

function allowwalk(...)
	local t = {...}
	local walk = getsetting('Cavebot/Pathfinding/WalkableIds')
	for i,j in ipairs(t) do
		walk = walk..' '..j
	end
	setsetting('Cavebot/Pathfinding/WalkableIds',walk)
end

function waitping(a,b) --credits to Hardek
	a,b=a or 1.6,b or 1.9
	local p = $pingaverage
	if p == 0 then p = 150 end
	wait(p*a,p*b)
end

function playsoundflash(p)
	playsound(p)
	flashclient()
end

function finditem(a, contstart)
	a=itemid(a)
	contstart = contstart or 0
	local wheretosearch = {{'neck', $neck}, {'head', $head}, {'back', $back}, {'rhand', $rhand}, {'chest', $chest}, {'lhand', $lhand}, {'finger', $finger}, {'feet', $feet}, {'belt', $belt}}
	if itemcount(a) == 0 then
		return
	end
	for i,j in ipairs(wheretosearch) do
		if j[2].id == a then
			return j[1], j[2]
		end
	end
	for i=contstart, 15 do
		local cont = getcontainer(i)
		for j=1, cont.itemcount do
			if cont.item[j].id == a then
				return tostring(i)
			end
		end
	end
end

function isdistance(x,y,z)
	x = x or 7
	y = y or x
	z = z or 0
	return math.abs($posx-$wptx) <= x and math.abs($posy-$wpty) <= y and math.abs($posz-$wptz) <= z
end

function islocation(x)
	x = x or 0
	return math.abs($posx-$wptx) <= x and math.abs($posy-$wpty) <= x and $posz == $wptz
end

function isrange(x,y)
	x = x or 1
	y = y or 1
	return $posx <= $wptx+x and $posx >= $wptx and $posy <= $wpty+y and $posy >= $wpty and $posz == $posz
end

function isposition(x,y,z)
	if not (x and y) then
		return false
	end
	z = z or false
	return $posx == x and $posy == y and $posz == z
end  

function waitcontainer(containername, newwindow)
	if newwindow or not containername then
		local i = $timems + 2000
		local curcount = windowcount(containername)
		while i >= $timems and windowcount(containername) == curcount do
			wait(100)
		end
	else
		local containernumber = tonumber(containername)
		if not containernumber then
			local i = $timems + 2000
			local curcount = windowcount(containername)
			while i >= $timems and windowcount(containername) == curcount do
				wait(100)
			end
		else
			local cont = {}
			copycontainer(getcontainer(containernumber),cont)
			local i = $timems+2000
			local compare = true
			while i >= $timems and compare do
				wait(200)
				compare = comparecontainers(cont, getcontainer(containernumber))
			end
		end
	end
end

function copycontainer(cont1, cont2)
	cont2 = cont2 or {}
	cont2.name = cont1.name
	cont2.itemid = cont1.itemid
	cont2.maxcount = cont1.maxcount
	cont2.itemcount = cont1.itemcount
	cont2.isopen = cont1.isopen
	cont2.hashigher = cont1.hashigher
	cont2.item = {}
	for i = 1, cont1.itemcount do
		cont2.item[i] = {id = cont1.item[i].id, count = cont1.item[i].count}
	end
end

function comparecontainers(cont1, cont2)
	if cont1.isopen and cont2.isopen then
		if cont2.itemcount ~= cont1.itemcount or cont2.itemid ~= cont1.itemid or cont2.maxcount ~= cont1.maxcount or cont2.hashigher ~= cont1.hashigher then
			return false
		end
		for i=1, cont1.itemcount do
			if cont1.item[i].id ~= cont2.item[i].id or cont1.item[i].count ~= cont2.item[i].count then
				return false
			end
		end
	else
		return 'Error'
	end
	return true
end

function num(a)
	if type(a) == 'number' then
		local sign = ''
		a=tostring(math.floor(a))
		if a:sub(1,1) == '-' then
			a = a:sub(2)
			sign = '-'
		end
		local size = a:len()
		local p = ''
		while size > 0 do
			if size-2 > 0 then
				p=a:sub(size-2,size)..','..p
			else
				p=a:sub(1,size)..','..p
			end
			size=size-3
		end
		return sign..p:sub(1,p:len()-1)
	else
		printerror('Bad argument #1 to \'num\' (number expected, got '..type(a)..')')
		return ''
	end
end

function string:attackername(returntype)
	dmg, name = self:match("You lose (%d-) .+ due to an attack by (.-)%.")
	if not name then return end
	local mtype = 'player'
	if name:sub(1,2) == 'a ' then
		name = name:sub(3)
		mtype = 'monster'
	elseif name:sub(1,3) == 'an ' then
		name = name:sub(4)
		mtype = 'monster'
	end
	if returntype then
		if returntype == 'name' then
			return name
		elseif returntype == 'type' then
			return mtype
		elseif returntype == 'dmg' then
			return tonumber(dmg)
		end
	end
	return name, mtype, tonumber(dmg)
end

function math:positive()
	if self < 0 then
		return 0
	end
	return self
end

function openbps(...)
	local bps = {...}
	for i,j in ipairs(bps) do
		openitem(j[1],j[2],j[3],j[4]) waitcontainer()
		resizewindows()
	end
end

function openbpslogin(...)
	local bps = {...}
	if not $connected then
		while not $connected do
			wait(300)
		end
		for i,j in ipairs(bps) do
			openitem(j[1],j[2],j[3],j[4]) waitcontainer()
			resizewindows()
		end
	end
end

function cooleddown(p)
	return cooldown(p) <= $pingaverage*tonumber(getsetting('Healer/Settings/PingCompensation'))/100
end

function mounting(p)
	p = p or $self
	return p.mount > 0
end

function vocation()
	local weapontype = ''
	local voc = 'unknown'
	local vocs = {mage = 5, paladin = 10, knight = 15}
	for i,j in pairs(vocs) do
		if ($maxhp-185)/($level-8) == j then
			voc = i
			break
		end
	end
	if voc == 'mage' then
		for i,j in ipairs(rods) do
			if j == $lhand.id or j == $rhand.id then
				return 'druid'
			end
		end
		for i,j in ipairs(wands) do
			if j == $lhand.id or j == $rhand.id then
				return 'sorcerer'
			end
		end
	end
	return voc
end

function bestelementweapon(creaturename) --based on Hardek's bestelement function
	local wands = {fire = {{3071, 65}, {8093, 30}, {3075, 19}}, energy = {{8092, 65}, {3073, 45}, {3074, 13}}, death = {{8094, 65}, {3072, 30}}}
	local rods = {ice = {{3067, 65}, {8083, 30}, {3070, 19}}, earth = {{8084, 65}, {3065, 45}, {3066, 13}}, death = {{8082, 65}, {3069, 30}}}
    if creaturename == '' then return 0, '' end
    local cre = creatureinfo(creaturename)
    local voc = vocation()
    if voc == 'sorcerer' then
        local best = ''
        local max = 0
		local wandsonbp = {fire = {0, 0}, energy = {0, 0}, death = {0, 0}}
		for i,j in pairs(wands) do
			for a,b in ipairs(j) do
				if itemcount(b[1]) > 0 then
					wandsonbp[i] = b
					break
				end
			end
		end
		for i,j in pairs(wandsonbp) do
			if j[1] > 0 and (cre[i..'mod']/100)*j[2] > max then
				max = cre[i..'mod']
				best = i
			end
		end
		
		return wandsonbp[best][1], best
    elseif voc == 'druid' then
        local best = ''
        local max = 0
		local wandsonbp = {ice = {0, 0}, earth = {0, 0}, death = {0, 0}}
		for i,j in pairs(rods) do
			for a,b in ipairs(j) do
				if itemcount(b[1]) > 0 then
					wandsonbp[i] = b
					break
				end
			end
		end
		for i,j in pairs(wandsonbp) do
			if j[1] > 0 and (cre[i..'mod']/100)*j[2] > max then
				max = cre[i..'mod']
				best = i
			end
		end
		
		return wandsonbp[best][1], best
    end

    return 0, ''
end

function string:concat(...)
	local words = {...}
	local ret = self
	for i=1,#words do
		ret = ret..' '..tostring(words[i])
	end
	return ret
end

function waitmessage(sender, msg, maxwaittime, exact, channel)
	sender = sender:lower()
	maxwaittime = maxwaittime or 10000
	if not exact then
		msg = msg:lower()
	end
	local time = 0
	local msgrecieved = false
	while time < maxwaittime do
		foreach newmessage m do
			if (m.sender:lower() == sender or sender == '') and (not channel or m.type == channel) then
				local mcontent = m.content
				if not exact then
					mcontent = mcontent:lower()
					if mcontent:find(msg) then
						return true
					end
				elseif msg == mcontent then
					return true
				end
			end
		end
		time = time+200
		wait(200)
	end
	return false
end

function searchcontainerincontainer(bpnumber)
	if not bpnumber then return false end
	local temp = getcontainer(bpnumber)
	for i=temp.itemcount, 1, -1 do
		if itemproperty(temp.item[i].id, ITEM_CONTAINER) then
			return temp.item[i].id
		end
	end
	return false
end

function iscontainerfull(bpnumber)
	if not bpnumber then return true end
	local temp = getcontainer(bpnumber)
	return temp.maxcount == temp.itemcount
end

function excludecontainerid(bpnumber)
	local ret = '0-15'
	if type(bpnumber) ~= 'number' then
		return ret
	end
	if bpnumber == 0 then
		ret = '1-15'
	elseif bpnumber == 1 then
		ret = '0 '..'2-15'
	elseif bpnumber == 14 then
		ret = '0-13 '..'15'
	elseif bpnumber >= 15 then
		ret = '0-14'
	else
		ret = '0-'..(bpnumber-1)..' '..(bpnumber+1)..'-15'
	end
	return ret
end

function itemcountignore(iid, bpnumber)
	local count = 0
	iid = itemid(iid)
	for i=0, 15 do
		if i ~= bpnumber then
			local cont = getcontainer(i)
			if cont.isopen then
				for j=1, cont.itemcount do
					if cont.item[j].id == iid then
						count = count+cont.item[j].count
					end
				end
			end
		end
	end
	return count
end

function totalitemsignore(location, ...)
	local itemlist = {...}
	if type(location) ~= 'string' then
		table.insert(itemlist,location)
		location = ''
	end
	local total = 0
	for i,j in ipairs(itemlist) do
		total = total+itemcountignore(j,location)
	end
	return total
end

function trueitemproperties(iid, upper)
	iid = itemid(iid)
	local properties = {ITEM_NOTROOFEDGE = 0, ITEM_TOPORDER1 = 1,ITEM_TOPORDER2 = 2,ITEM_TOPORDER3 = 3,ITEM_CONTAINER = 4,ITEM_STACKABLE = 5,ITEM_CORPSE = 6,ITEM_USEABLE = 7,ITEM_WRITEABLE = 8,ITEM_READABLE = 9,ITEM_FLUIDCONTAINER = 10,ITEM_SPLASH = 11,ITEM_BLOCKWALK = 12,ITEM_NOTMOVEABLE = 13,ITEM_BLOCKSHOTS = 14,ITEM_BLOCKPATHS = 15,ITEM_PICKUPABLE = 16,ITEM_HANGABLE = 17,ITEM_HORIZONTAL = 18,ITEM_VERTICAL = 19,ITEM_ROTATEABLE = 20,ITEM_LIGHTFONT = 21,ITEM_UNKNOWN = 22,ITEM_FLOORCHANGE = 23,ITEM_OFFSET = 24,ITEM_HEIGHTED = 25,ITEM_BIGSPRITE = 26,ITEM_UNEXIST = 27,ITEM_MINIMAP = 28,ITEM_ACTION = 29,ITEM_GROUND = 30,ITEM_BORDER = 31}
	local ret = {}
	for i,j in pairs(properties) do
		if itemproperty(iid,j) then
			if upper then
				table.insert(ret, i)
			else
				table.insert(ret, i:sub(6):lower())
			end
		end
	end
	local ret2 = ret[1]
	for i=2, #ret do
		ret2 = ret2..', '..ret[i]
	end
	return ret2
end

function sameproperties(prop,notprop)
	local properties = {}
	local p = {}
	local notproperties = notprop or {}
	if type(prop) ~= 'table' then
		prop = itemid(prop)
		for i=0, 31 do
			if itemproperty(prop, i) then
				table.insert(properties, i)
			end
		end
	else
		properties = prop
	end
	if type(notprop) == 'string' and notprop == 'all' then
		notproperties = {}
		for i=0, 31 do
			if not table.find(properties,i) then
				table.insert(notproperties, i)
			end
		end
	end
	for i=1, 15000 do
		local t = true
		for a,b in ipairs(properties) do
			if not itemproperty(i, b) then
				t = false
				break
			end
		end
		for a,b in ipairs(notproperties) do
			if itemproperty(i, b) then
				t = false
				break
			end
		end
		if t then
			table.insert(p, i)
		end
	end
	print(p)
end

function mwall(targetid, dist)
	dist = dist or 2
    local dir = {x = {n = 0, s = 0, w = -1*dist, e = 1*dist},
                 y = {n = -1*dist, s = 1*dist, w = 0, e = 0}}
	targetid = findcreature(targetid)
	if targetid.id ~= 0 then
		local pos = {targetid.posx + dir.x[targetid.dir], targetid.posy + dir.y[targetid.dir], targetid.posz}
		useitemon(3180, topitem(table.unpack(pos)).id, ground(table.unpack(pos))) wait(300)
	end
end

_MOVEITEMS = _MOVEITEMS or moveitems
function moveitems(iid, dest, from, amount)
	dest, from = dest or '', from or ''
	local temp = getsetting('Cavebot/Looting/MoveItemsQuickly')
	if amount and amount < 100 then
		setsetting('Cavebot/Looting/MoveItemsQuickly', 'no', false)
	end
	if dest == 'ground' and from:sub(1,6) == 'ground' then
		local temp = from:token()
		local pos
		if temp[2] then
			pos = {tonumber(temp[2]), tonumber(temp[3]), tonumber(temp[4])}
		else
			pos = {$posx,$posy,$posz}
		end
		local dir, dirx, diry = wheretomoveitem(pos[1],pos[2],pos[3], iid)
		if dir ~= '' then
			dest = ground(pos[1]+dirx,pos[2]+diry,pos[3])
		end
	end
	local ret = _MOVEITEMS(iid, dest, from, amount)
	setsetting('Cavebot/Looting/MoveItemsQuickly', temp, false)
	return ret
end

_EQUIPITEM = _EQUIPITEM or equipitem
function equipitem(iid, dest, from, amount)
	dest, from = dest or '', from or ''
	local temp = getsetting('Cavebot/Looting/MoveItemsQuickly')
	if amount and amount < 100 then
		setsetting('Cavebot/Looting/MoveItemsQuickly', 'no', false)
	end
	local ret = _EQUIPITEM(iid, dest, from, amount)
	setsetting('Cavebot/Looting/MoveItemsQuickly', temp, false)
	return ret
end

_GETTILE = _GETTILE or gettile
function gettile(x,y,z)
	x,y,z = x or $posx, y or $posy, z or $posz
	local dz = 2*(z-$posz)
	return _GETTILE(x+dz,y+dz,z)
end

_TOPITEM = _TOPITEM or topitem
function topitem(x,y,z)
	x,y,z = x or $posx, y or $posy, z or $posz
	local dz = 2*(z-$posz)
	local ret = _TOPITEM(x+dz,y+dz,z)
	if itemproperty(ret.id,ITEM_TOPORDER3) then
		local tileinfo = gettile(x+dz,y+dz,z)
		local pos = 1
		while pos <= tileinfo.itemcount and tileinfo.item[pos].id ~= ret.id do
			pos = pos+1
		end
		for i=pos+1, tileinfo.itemcount do
			if tileinfo.item[i].id ~= 99 then
				ret = tileinfo.item[i]
			end
		end
	end
	return ret
end

_PRINT = _PRINT or print
function print(...)
	local msgs = {...}
	local toprint = ''
	for i,j in ipairs(msgs) do
		if type(j) == 'table' then
			toprint = toprint..table.stringformat(j)..' '
		else
			toprint = toprint..tostring(j)..' '
		end
	end
	_PRINT(toprint:sub(1, #toprint-1))
end

_PRINTERROR = _PRINTERROR or printerror
function printerror(...)
	local msgs = {...}
	local toprint = ''
	for i,j in ipairs(msgs) do
		if type(j) == 'table' then
			toprint = toprint..table.stringformat(j)..' '
		else
			toprint = toprint..tostring(j)..' '
		end
	end
	_PRINTERROR(toprint:sub(1, #toprint-1))
end

_LISTAS = _LISTAS or listas
function listas(...)
	local msgs = {...}
	local toprint = ''
	for i,j in ipairs(msgs) do
		if type(j) == 'table' then
			toprint = toprint..table.stringformat(j)..' '
		else
			toprint = toprint..tostring(j)..' '
		end
	end
	_LISTAS(toprint:sub(1, #toprint-1))
end

function areitemsontile(x,y,z,considercap,considermoveable,...) --some credits to golfinhu for considermoveable
	if not (x and y and z) then
		printerror('You must give the coordinates to check for items.')
		return false
	end
	local items = {...}
	local temp = type(considercap)
	if temp == 'string' or (temp == 'number' and temp > 1000) then
		table.insert(items,temp)
	end
	if type(considermoveable) ~= 'boolean' then
		table.insert(items, considermoveable)
	end
	table.id(items)
	if x < 10 or y < 10 then
		x = $posx-x
		y = $posy-y
		z = $posz-z
	end
	table.id(items)
	local tile = gettile(x,y,z)
	for i=2, tile.itemcount do
		temp = tile.item[i].id
		if considermoveable and itemproperty(temp,ITEM_NOTMOVEABLE) and not itemproperty(temp,ITEM_SPLASH) and not itemproperty(temp,ITEM_TOPORDER1) then
			return false
		end
		if table.find(items,temp) and (not considercap or (type(considercap) == 'boolean' and $cap >= itemweight(temp)) or (type(considercap) == 'number' and $cap >= considercap)) then
			return true
		end
	end
	return false
end

function collecthiddenitems(dist,...)
	local items = {...}
	if not dist then
		dist = 10
	elseif (type(dist) == 'number' and dist > 100) or (type(dist) == 'string') then
		table.insert(items, dist)
		dist = 10
	end
	table.id(items)
	local i,j
	for a=0, dist do
		j = -a
		while j <= a do
			i = -a
			while i <= a do
				local pos = {$posx+i,$posy+j,$posz}
				if tilehasinfo(table.unpack(pos)) and tilereachable(table.unpack(pos)) then
					local tile = gettile(table.unpack(pos))
					local found = 0
					for p=1, tile.itemcount do
						if table.find(items, tile.item[p].id) and $cap >= itemweight(tile.item[p].id) then
							found = p
						end
						if itemproperty(tile.item[p].id, ITEM_NOTMOVEABLE) then
							found = 0
						end
					end
					if found > 0 then
						local topick = tile.item[found].id
						reachlocation(table.unpack(pos))
						local topid = topitem(table.unpack(pos)).id
						while topid ~= topick and isitemontile(topick, table.unpack(pos)) do
							moveitems(topid, 'ground', ground(table.unpack(pos)), 100) waitping()
							topid = topitem(table.unpack(pos)).id
						end
						moveitems(topick, '', ground(table.unpack(pos)), 100)
						return true
					end
				end
				if j ~= a and j ~= -a then
					i = i+a*2
				else
					i = i+1
				end
			end
			j = j+1
		end
	end
end
--[[
function collecthiddenitems(dist,considercap,...)
	local items = {...}
	if type(dist) ~= 'number' then
		table.insert(items, itemid(dist))
		dist = 7
	elseif dist > 10 then
		table.insert(items, dist)
		dist = 7
	end
	if type(considercap) == 'number' then
		if considercap < 1000 then
			if $cap < considercap then return false end
		else
			table.insert(items, considercap)
		end
	elseif type(considercap) == 'string' then
		table.insert(items, itemid(considercap))
	elseif type(considercap) ~= 'boolean' then
		considercap = true
	end
	table.id(items)
	for j=-dist,dist do
		for i=-dist,dist do
			local pos = {$posx+i,$posy+j,$posz}
			if tilehasinfo(table.unpack(pos)) and areitemsontile(table.unpack(pos),considercap,table.unpack(items)) and tilereachable(table.unpack(pos)) then
				local topid = topitem(table.unpack(pos)).id
				if not itemproperty(topid, ITEM_NOTMOVEABLE) then
					pausewalking(0)
					return false
				end
				pausewalking(40000)
				reachlocation(table.unpack(pos))
				repeat
					while not table.find(items,topid) do
						local temp = {wheretomoveitem(table.unpack(pos),topid)}
						moveitems(topid, ground(pos[1]+temp[2],pos[2]+temp[3],z), ground(table.unpack(pos)), 100) waitping()
						topid = topitem(table.unpack(pos)).id
					end
					moveitems(topid,'backpack',ground(table.unpack(pos)), 100) waitping()
				until not areitemsontile(table.unpack(pos),considercap,table.unpack(items))
			end
		end
	end
	pausewalking(0)
end
--]]
function returnwpt(n)
	if not $wptid then return false end
	n = n or 1
	gotolabel(math.positive($wptid-n))
end

function castspell(spellname, who)
	if type(spellname) ~= 'table' then
		spellname = spellinfo(spellname)
	end
	if cancastspell(spellname, who) then
		cast(spellname.words)
		return true
	end
	return false
end

function tilehasinfo(x,y,z)
	x = x-$posx
	y = y-$posy
	return (x <= SCREEN_RIGHT and x >= SCREEN_LEFT and y >= SCREEN_TOP and y <= SCREEN_BOTTOM and z == $posz)
end

function eatfoodfull(location, ...)
	while true do
		if not eatfood(location, ...) then
			return false
		end
		waitping()
		foreach newmessage m do
			if m.type == MSG_STATUS and m.content == 'You are full.' then
				return true
			end
		end
	end
end

function getfoodtime(id)
	id = itemid(id)
	local pos = bin2(foods, id, 1)
	if pos then
		return foods[pos][2]*1000
	end
end

function increasehungrytime(amount)
	amount = amount or 0
	if GLOBAL_HUNGRY == 0 or GLOBAL_HUNGRY < $timems then
		GLOBAL_HUNGRY = $timems + amount
	else
		GLOBAL_HUNGRY = GLOBAL_HUNGRY + amount
	end
end

function resethungrytime()
	GLOBAL_HUNGRY = 0
end

function gethungrytime()
	local temp = GLOBAL_HUNGRY-$timems
	if temp > 1200000 then
		return 1200000
	elseif temp < 0 then
		return 0
	else
		return temp
	end
end

function eatfood(location, ...)
	location = location or ''
	local foodtable = {3583, 3731, 3726, 3582, 3725, 3593, 3589, 12310, 3580, 3594, 3577, 3586, 3729, 3578, 8010, 3579, 3600, 3727, 3592, 3597, 3723, 3607, 5678, 3587, 3602, 3728, 3606, 3596, 3585, 3595, 3732, 3584, 3724, 3581, 3601, 3730, 3599, 3598, 3591, 3590, 3588}
	if (type(location) == 'number') then
		if location <= 15 then
			location = tostring(location)
		else
			foodtable = {location, ...}
			location = ''
		end
	elseif select("#", ...) > 0 then
		foodtable = {...}
	end
	if location == 'ground' then
		local foundfood = false
		for j=-1, 1 do
			for i=-1, 1 do
				local topid = topitem($posx+i, $posy+j, $posz).id
				local foodtime = getfoodtime(topid)
				if isfood(topid) and foodtime+gethungrytime() <= 1200000 then
					useitem(topid, ground($posx+i, $posy+j, $posz)) wait(100) increasehungrytime(foodtime) return true
				end
			end
		end
	elseif location:sub(1,6) == 'ground' then
		local coord = (location:sub(8)):token()
		coord[1],coord[2],coord[3] = tonumber(coord[1]),tonumber(coord[2]),tonumber(coord[3])
		local topid = topitem(table.unpack(coord)).id
		local foodtime = getfoodtime(topid)
		if isfood(topid) and foodtime+gethungrytime() <= 1200000 then
			useitem(topid, ground(table.unpack(coord))) increasehungrytime(foodtime) wait(100) return true
		end
	else
		for i,j in ipairs(foodtable) do
			local foodtime = getfoodtime(j)
			if itemcount(j, location) > 0 and foodtime+gethungrytime() <= 1200000 then
				useitem(j, location) increasehungrytime(foodtime) wait(100) return true
			end
		end
	end
	return false
end

function islocker(id)
	id = itemid(id)
	if id >= 3497 and id <= 3500 then
		return true
	end
	return false
end

function opendepot2(...)
	local itemtable = {...}
	table.id(itemtable)
	local walktrough = getsetting('Cavebot/Pathfinding/WalkThroughPlayers')
	setsetting('Cavebot/Pathfinding/WalkThroughPlayers', 'no', false)
	local tries, dppos, dpid = 0
	repeat
		for j=-6, 7 do
			for i=-8, 9 do
				local pos = {$posx+i, $posy+j, $posz}
				local topid = topitem(table.unpack(pos)).id
				if topid >= 3497 and topid <= 3500 and tilereachable(table.unpack(pos)) then
					reachlocation(table.unpack(pos))
					if math.abs(pos[1]-$posx) <= 1 and math.abs(pos[2]-$posy) <= 1 and $posz == pos[3] then
						dppos = pos
						dpid = topid
						break
					end
				end
			end
			if dpid then break end
		end
		if dpid then break end
		wait(500)
		tries = tries+1
	until tries > 5
	if not dpid then
		return false
	end
	setsetting('Cavebot/Pathfinding/WalkThroughPlayers', walktrough, false)
	tries = 0
	repeat
		openitem(dpid, ground(table.unpack(dppos))) waitcontainer('Locker')
		if windowcount('Locker') == 0 then
			local topid = topitem(table.unpack(dppos)).id
			while topid ~= dpid do
				local dir, dirx, diry = wheretomoveitem(x,y,z,topid)
				if not table.find(itemtable, topid) then
					moveitems(topid, ground($posx+dirx, $posy+diry, $posz), ground(table.unpack(dppos)), 100)
				else
					moveitems(topid, 'backpack', ground(table.unpack(dppos)), 100)
				end
				wait(100)
				topid = topitem(table.unpack(dppos)).id
			end
		else
			return true
		end
		wait(100)
		tries = tries+1
	until windowcount('Locker') > 0 or tries > 5
end

function waitandlogout()
	while $connected do
		while $battlesigned do
			foreach creature m 'ms' do
				if iscreaturereachable(m) then
					setattackmode('none', 'chase')
					attack(m)
					break
				end
			end
			pausewalking(300)
			wait(100)
		end
		logout()
		wait(100)
	end
end

function opengrounditem(id)
	if id then
		id = itemid(id)
	end
	for i=SCREEN_LEFT, SCREEN_RIGHT do
		for j=SCREEN_TOP, SCREEN_BOTTOM do
			local x,y,z = $posx+i, $posy+j, $posz
			local topid = topitem(x,y,z).id
			if tilereachable(x,y,z) and (not id and itemproperty(topid, ITEM_ISCONTAINER)) or topid == id then
				reachlocation(x,y,z)
				openitem(topid, ground(x,y,z)) waitcontainer() return true
			end
		end
	end
	return false
end

function getbpindex(bpcolor) --by golfinhu
	local bpcolors = {'beach', 'blue', 'brocade', 'brown', 'camouflage', 'crown', 'demon', 'dragon', 'expedition', 'fur', 'golden', 'green', 'grey', 'heart', 'holding', 'minotaur', 'moon', 'orange', 'pirate', 'purple', 'red', 'santa', 'yellow', 'jewelled'}
	local bpcolor = bpcolor:lower()
	if bpcolor:find('holding') then
		bpcolor = 'holding'
	elseif bpcolor:token(1) == 'backpack' then
		bpcolor = 'brown'
	end
	local color = bpcolor:token(1)
	if not table.find(bpcolors, color) then
		printerror('Bp color not valid')
		return false
	end
	local bps = {}
	for i = 0, windowcount() - 1 do
		local bpname = getcontainer(i).name:lower()
		if bpname == 'backpack of holding' then
			bpname = 'holding backpack'
		elseif bpname == 'backpack' then
			bpname = 'brown backpack'
		end
		if bpname == color..' backpack' then
			if color == 'holding' then
				table.insert(bps, 'backpack of holding '..i)
			else
				table.insert(bps, color..' backpack '..i)
			end
		end
	end
	return bps
end
 
-- get the index of the backpack name --
 
function closebpcolor(bpcolor, indexs, indexe)  --by golfinhu
	if not bpcolor then
		return false
	elseif not indexs then
		if bpcolor:find('holding') then
			return closewindows('backpack of holding')
		else
			return closewindows(bpcolor:token(1)..' backpack')
		end
	end
	local indexe = indexe or indexs
	local indexs, indexe = tonumber(indexs) + 1, tonumber(indexe) + 1
	local index = getbpindex(bpcolor)
	if table.isempty(index) or #index < indexs then return false end
	for i = indexs, math.lowest(indexe,#index) do
		closewindows(index[i])
	end
end
 
-- close the specified backpack name using index by name --

function itemcountcorpse(corpse,...) --by golfinhu
	local itemlist = {...}
	if not corpse or #itemlist == 0 then return 0 end
	corpse = corpse:lower()
	if corpse:sub(1,4) ~= 'dead' then
		corpse = 'dead '..corpse
	end
	local total = 0
	for i = 0, windowcount() - 1 do
		local container = getcontainer(i).name:lower()
		if (corpse == 'dead' and container:find('dead')) or container == corpse then
			total = total + totalitems(tostring(i),table.unpack(itemlist))
		end
	end
	return total
end

function moveitemsfromcorpse(corpse,dest,amount,...) --by golfinhu
	local itemlist = {...}
	if type(dest) == 'number' then
		table.insert(itemlist,dest)
		dest = ''
	end
	if type(amount) == 'number' and amount > 100 or type(amount) == 'string' then
		table.insert(itemlist,amount)
		amount = 100
	end	
	if not corpse or #itemlist == 0 then return false end
	local corpse = corpse:lower()
	local corpsetoken = corpse:token()
	if corpsetoken[1] ~= 'dead' then
		corpse = 'dead '..table.concat(corpsetoken, " ")
	end
	for i = 0, windowcount() - 1 do
		local container = getcontainer(i).name:lower()
		if (corpse == 'dead' and container:find('dead')) or container == corpse then
			for a,b in ipairs(itemlist) do
				if itemcount(b,i) > 0 then
					moveitems(b, dest, tostring(i), amount)
				end
			end
		end
	end
end

function string:removews() --by golfinhu
	self = self:gsub("^%s*", "")
	self = self:gsub("%s*$", "")
	return self:gsub(" +", " ")
end


function string:attackmsg()
	local ttable = {dmg = 0, dealer = {name = '', type = ''}, target = {name = '', type = ''}}
	ttable.dmg, ttable.dealer.name = self:match('You lose (%w+) .+ due to an attack by (.+)%.')
	if ttable.dmg then
		ttable.target = {name = $name, type = 'player'}
		if ttable.dealer.name:sub(1,2) == 'a ' then
			ttable.dealer = {name = ttable.dealer.name:sub(3), type = 'monster'}
		elseif ttable.dealer.name:sub(1,3) == 'an ' then
			ttable.dealer = {name = ttable.dealer.name:sub(4), type = 'monster'}
		elseif ttable.dealer.name:sub(1,4) == 'the ' then
			ttable.dealer = {name = ttable.dealer.name:sub(4), type = 'monster'}
		else
			ttable.dealer.type = 'player'
		end
		ttable.dmg = tonumber(ttable.dmg)
		return ttable
	else
		ttable.target.name, ttable.dmg = self:match('(.+) loses (%w+) .+ due to your attack%.')
		if ttable.dmg then
			ttable.dealer = {name = $name, type = 'player'}
			if ttable.target.name:sub(1,2) == 'A ' then
				ttable.target = {name = ttable.target.name:sub(3), type = 'monster'}
			elseif ttable.target.name:sub(1,3) == 'An ' then
				ttable.target = {name = ttable.target.name:sub(4), type = 'monster'}
			elseif ttable.target.name:sub(1,4) == 'The ' then
				ttable.target = {name = ttable.target.name:sub(4), type = 'monster'}
			else
				ttable.target.type = 'player'
			end
			ttable.dmg = tonumber(ttable.dmg)
			return ttable
		else
			ttable.target.name, ttable.dmg, ttable.dealer.name = self:match('(.+) loses (%w+) .+ due to an attack by (.+)%.')
			if ttable.dmg then
				if ttable.dealer.name:sub(1,2) == 'a ' then
					ttable.dealer = {name = ttable.dealer.name:sub(3), type = 'monster'}
				elseif ttable.dealer.name:sub(1,3) == 'an ' then
					ttable.dealer = {name = ttable.dealer.name:sub(4), type = 'monster'}
				elseif ttable.dealer.name:sub(1,4) == 'the ' then
					ttable.dealer = {name = ttable.dealer.name:sub(5), type = 'monster'}
				else
					ttable.dealer.type = 'player'
				end
				if ttable.target.name:sub(1,2) == 'A ' then
					ttable.target = {name = ttable.target.name:sub(3), type = 'monster'}
				elseif ttable.target.name:sub(1,3) == 'An ' then
					ttable.target = {name = ttable.target.name:sub(4), type = 'monster'}
				elseif ttable.target.name:sub(1,4) == 'The ' then
					ttable.target = {name = ttable.target.name:sub(5), type = 'monster'}
				else
					ttable.target.type = 'player'
				end
				ttable.dmg = tonumber(ttable.dmg)
				return ttable
			end
		end
	end
	return {dmg = 0, dealer = {name = '', type = ''}, target = {name = '', type = ''}}
end

function string:healmsg()
	--Lorysa healed herself for 201 hitpoints.
	local ttable = {dmg = 0, healer = '', target = ''}
	if not self:find('heal') then return {dmg = 0, healer = '', target = ''} end
	ttable.dmg = self:match('You healed yourself for (%w+) hitpoint[s]*%.')
	if ttable.dmg then
		ttable.target, ttable.healer = $name, $name
		ttable.dmg = tonumber(ttable.dmg)
		return ttable
	else
		ttable.healer, ttable.dmg = self:match('(.+) healed h[erim]+self for (%w+) hitpoint[s]*%.')
		if ttable.dmg then
			if ttable.healer:sub(1,2) == 'A ' then
				ttable.healer = tt.healer:sub(3)
			elseif ttable.healer:sub(1,3) == 'An ' then
				ttable.healer = tt.healer:sub(4)
			elseif ttable.healer:sub(1,4) == 'The ' then
				ttable.healer = tt.healer:sub(5)
			end
			ttable.target = ttable.healer
			ttable.dmg = tonumber(ttable.dmg)
			return ttable
		else
			ttable.target, ttable.dmg = self:match('You heal (.+) for (%w+) hitpoint[s]*%.')
			if ttable.dmg then
				if ttable.target:sub(1,2) == 'a ' then
					ttable.target = tt.target:sub(3)
				elseif ttable.target:sub(1,3) == 'an ' then
					ttable.target = tt.target:sub(4)
				elseif ttable.target:sub(1,4) == 'the ' then
					ttable.target = tt.target:sub(5)
				end
				ttable.healer = $name
				ttable.dmg = tonumber(ttable.dmg)
				return ttable
			else
				ttable.healer, ttable.dmg = self:match('You were healed by (.+) for (%w+) hitpoint[s]*%.')
				if ttable.dmg then
					if ttable.healer:sub(1,2) == 'a ' then
						ttable.healer = tt.healer:sub(3)
					elseif ttable.healer:sub(1,3) == 'an ' then
						ttable.healer = tt.healer:sub(4)
					elseif ttable.healer:sub(1,4) == 'the ' then
						ttable.healer = tt.healer:sub(5)
					end
					ttable.target = $name
					ttable.dmg = tonumber(ttable.dmg)
					return ttable
				else
					ttable.target, ttable.healer, ttable.dmg = self:match('(.+) was healed by (.+) for (%w+) hitpoint[s]*%.')
					if ttable.dmg then
						if ttable.target:sub(1,2) == 'A ' then
							ttable.target = tt.target:sub(3)
						elseif ttable.target:sub(1,3) == 'An ' then
							ttable.target = tt.target:sub(4)
						elseif ttable.target:sub(1,4) == 'The ' then
							ttable.target = tt.target:sub(5)
						end
						if (ttable.healer:sub(1,2)):lower() == 'a ' then
							ttable.healer = tt.healer:sub(3)
						elseif (ttable.healer:sub(1,3)):lower() == 'an ' then
							ttable.healer = tt.healer:sub(4)
						elseif (ttable.healer:sub(1,4)):lower() == 'the ' then
							ttable.healer = tt.healer:sub(5)
						end
						ttable.dmg = tonumber(ttable.dmg)
						return ttable
					end
				end
			end
		end
	end
	return {dmg = 0, healer = '', target = ''}
end

function string:lootmsg()
	local n, temp, loot = self:match('Loot of (.+): (.+)')
	local minfoodt, valuet = 5000000, 0
	if n then
		if (n:sub(1,2)):lower() == 'a ' then
			n = n:sub(3)
		elseif (n:sub(1,3)):lower() == 'an ' then
			n = n:sub(4)
		elseif (n:sub(1,4)):lower() == 'the ' then
			n = n:sub(5)
		end
		if temp ~= 'nothing' then
			temp = temp:token(nil, ', ')
			loot = {}
			for i,j in ipairs(temp) do
				local tt = j:find(' ') or #j+1
				local temp1 = j:sub(1,tt-1)
				local amount = tonumber(temp1)
				local temp2
				if amount then
					temp1 = amount
					temp2 = j:sub(tt+1, #j)
				elseif temp1 == 'a' or temp1 == 'an' then
					temp1 = 1
					temp2 = j:sub(tt+1, #j)
				else
					temp1 = 1
					temp2 = j
				end
				local pos = table.find(loot, temp2:lower(), 'name')
				setwarning(WARNING_ITEM, false)
				local iid = itemid(temp2)
				setwarning(WARNING_ITEM, true)
				if iid > 0 then
					if iid == 2995 then
						valuet = valuet+1000
					elseif iid == 6558 then
						valuet = valuet+400
					elseif isfood(iid) then
						local tempfoodtime = getfoodtime(iid)
						if tempfoodtime < minfoodt then
							minfoodt = tempfoodtime
						end
					else
						valuet = valuet+itemvalue(iid)*temp1
					end
				end
				if not pos then
					table.insert(loot, {name = temp2:lower(), count = temp1})
				else
					loot[pos].count = loot[pos].count + temp1
				end
			end
		else
			return {name = n:lower(), items = {}}
		end
	end
	n = n or ''
	loot = loot or {}
	return {name = n:lower(), items = loot, value = valuet, minfood = minfoodt}
end

function timebetween(ft,st,delay)
	local ctime,ftime,stime = tosec(),tosec(ft),tosec(st)
	delay = delay or 0
	return ctime >= ftime and ctime <= stime + delay
end

local ssmsgs = {'The server will be saved in 5 minutes, please come back in 10 minutes.'}
local inventoryfullmsgs = {'You cannot put more objects in this container.'}
local lowcapmsgs = {}

DYNAMICHUD = {aux = {x=0,y=0}, moved = {x=0,y=0}, moving = false}

function DYNAMICHUD:new()
	n = n or {aux = {x=0,y=0}, moved = {x=0,y=0}, moving = false}
	setmetatable(n, self)
	self.__index = self
	return n
end

function DYNAMICHUD:init()
	filterinput(false, true, false, false)
	function inputevents(type, v1, v2)
        if type == IEVENT_RMOUSEDOWN then
            self.moving = true
            self.aux = {x = $cursor.x-self.moved.x, y = $cursor.y-self.moved.y}
        end
        if type == IEVENT_RMOUSEUP then
            self.moving = false
        end
    end
end

function DYNAMICHUD:check()
	if self.moving then
		auto(10)
		self.moved = {x = $cursor.x-self.aux.y, y = $cursor.y-self.aux.y}
	end
end

function DYNAMICHUD:setposition(x,y)
	setposition(x+self.moved.x,self.moved.y)
end

function math:highest(b)
	if self > b then
		return self
	end
	return b
end

function math:lowest(b)
	if self < b then
		return self
	end
	return b
end

function creaturestringformat(cre)
	local ret = '{'
	for i,j in ipairs(_CREATUREPROPERTIES) do
		if type(cre[j]) == 'string' then
			ret = ret..j..' = "'..cre[j]..'"'..', '
		else
			ret = ret..j..' = '..tostring(cre[j])..', '
		end
	end
	return ret:sub(1,#ret-2)..'}'
end

function table:stringformat(tablename, separator)
	if type(self) ~= 'table' then
		return ''
	end
	separator = separator or ''
	tablename = tablename or ''
	local ret
	if tablename == '' then
		ret = '{'
	else
		ret = tablename..' = {'
	end
	local count = 0
	for i,j in ipairs(self) do
		count = count+1
		local type = type(j)
		if type == 'string' then
			ret = ret..'"'..j..'", '..separator
		elseif type == 'number' then
			ret = ret..j..', '..separator
		elseif type == 'table' then
			ret = ret..table.stringformat(j)..', '..separator
		elseif type == 'userdata' then
			if j.color1 then
				ret = ret..creaturestringformat(j)..', '..separator
			end
		end
	end
	if count == 0 then
		for i,j in pairs(self) do
			local type = type(j)
			if type == 'string' then
				ret = ret..i..' = "'..j..'", '..separator
			elseif type == 'number' then
				ret = ret..i..' = '..j..', '..separator
			elseif type == 'table' then
				ret = ret..i..' = '..table.stringformat(j)..', '..separator
			elseif type == 'userdata' then
				if j.color1 then
					ret = ret..i..' = '..creaturestringformat(j)..', '..separator
				end
			end
		end	
	end
	return ret:sub(1,#ret-2)..'}'
end

function ispk(mid)
	return mid.skull == SKULL_WHITE or mid.skull == SKULL_RED or mid.skull == SKULL_YELLOW or mid.skull == SKULL_ORANGE
end

function maroundfloor(dist,floor,...)
	local temp
	local creaturestocheck = {...}
	local count = 0
	dist = dist or 10
	if dist == 0 then
		dist = 10
	end
	if type(floor) == 'string' then
		temp = -(tonumber(floor))
		if not temp then
			table.insert(creaturestocheck, floor)
			floor = 7
		end
	elseif floor > 1000 then
		table.insert(creaturestocheck, floor)
		floor = 7
	end
	table.lower(creaturestocheck)
	if temp then
		if temp > 0 then
			foreach creature c 'm' do
				local diff = c.posz-$posz
				if diff <= temp and diff >= 0 and math.highest(math.abs(c.posx-$posx), math.abs(c.posy-$posy)) <= dist and (#creaturestocheck == 0 or table.find(creaturestocheck,c.name:lower()) or table.find(creaturestocheck,c.id) or table.find(creaturestocheck,c)) then
					count = count+1
				end
			end
		else
			foreach creature c 'm' do
				local diff = c.posz-$posz
				if diff >= temp and diff <= 0 and math.highest(math.abs(c.posx-$posx), math.abs(c.posy-$posy)) <= dist and (#creaturestocheck == 0 or table.find(creaturestocheck,c.name:lower()) or table.find(creaturestocheck,c.id) or table.find(creaturestocheck,c)) then
					count = count+1
				end
			end
		end
	else
		foreach creature c 'm' do
			local diff = c.posz-$posz
			if math.abs(diff) <= math.abs(floor) and math.highest(math.abs(c.posx-$posx), math.abs(c.posy-$posy)) <= dist and (#creaturestocheck == 0 or table.find(creaturestocheck,c.name:lower()) or table.find(creaturestocheck,c.id) or table.find(creaturestocheck,c)) then
				count = count+1
			end
		end
	end
	return count
end

function maroundfloorignore(dist,floor,...)
	local temp
	local creaturestocheck = {...}
	local count = 0
	dist = dist or 10
	if dist == 0 then
		dist = 10
	end
	if type(floor) == 'string' then
		temp = -(tonumber(floor))
		if not temp then
			table.insert(creaturestocheck, floor)
			floor = 7
		end
	elseif floor > 1000 then
		table.insert(creaturestocheck, floor)
		floor = 7
	end
	table.lower(creaturestocheck)
	if temp then
		if temp > 0 then
			foreach creature c 'm' do
				local diff = c.posz-$posz
				if diff <= temp and diff >= 0 and math.highest(math.abs(c.posx-$posx), math.abs(c.posy-$posy)) <= dist and (#creaturestocheck == 0 or (not table.find(creaturestocheck,c.name:lower()) and not table.find(creaturestocheck,c.id) and not table.find(creaturestocheck,c))) then
					count = count+1
				end
			end
		else
			foreach creature c 'm' do
				local diff = c.posz-$posz
				if diff >= temp and diff <= 0 and math.highest(math.abs(c.posx-$posx), math.abs(c.posy-$posy)) <= dist and (#creaturestocheck == 0 or (not table.find(creaturestocheck,c.name:lower()) and not table.find(creaturestocheck,c.id) and not table.find(creaturestocheck,c))) then
					count = count+1
				end
			end
		end
	else
		foreach creature c 'm' do
			local diff = c.posz-$posz
			if math.abs(diff) <= math.abs(floor) and math.highest(math.abs(c.posx-$posx), math.abs(c.posy-$posy)) <= dist and (#creaturestocheck == 0 or (not table.find(creaturestocheck,c.name:lower()) and not table.find(creaturestocheck,c.id) and not table.find(creaturestocheck,c))) then
				count = count+1
			end
		end
	end
	return count
end

function paroundfloor(dist,floor,...)
	local temp
	local creaturestocheck = {...}
	local count = 0
	dist = dist or 10
	if dist == 0 then
		dist = 10
	end
	if type(floor) == 'string' then
		temp = -(tonumber(floor))
		if not temp then
			table.insert(creaturestocheck, floor)
			floor = 7
		end
	elseif floor > 1000 then
		table.insert(creaturestocheck, floor)
		floor = 7
	end
	table.lower(creaturestocheck)
	if temp then
		if temp > 0 then
			foreach creature c 'p' do
				local diff = c.posz-$posz
				if c ~= $self and diff <= temp and math.highest(math.abs(c.posx-$posx), math.abs(c.posy-$posy)) <= dist and diff >= 0 and (#creaturestocheck == 0 or table.find(creaturestocheck,c.name:lower()) or table.find(creaturestocheck,c.id) or table.find(creaturestocheck,c)) then
					count = count+1
				end
			end
		else
			foreach creature c 'p' do
				local diff = c.posz-$posz
				if c ~= $self and diff >= temp and math.highest(math.abs(c.posx-$posx), math.abs(c.posy-$posy)) <= dist and diff <= 0 and (#creaturestocheck == 0 or table.find(creaturestocheck,c.name:lower()) or table.find(creaturestocheck,c.id) or table.find(creaturestocheck,c)) then
					count = count+1
				end
			end
		end
	else
		foreach creature c 'p' do
			local diff = c.posz-$posz
			if c ~= $self and math.abs(diff) <= math.abs(floor) and math.highest(math.abs(c.posx-$posx), math.abs(c.posy-$posy)) <= dist and (#creaturestocheck == 0 or table.find(creaturestocheck,c.name:lower()) or table.find(creaturestocheck,c.id) or table.find(creaturestocheck,c)) then
				count = count+1
			end
		end
	end
	return count
end

function paroundfloorignore(dist,floor,...)
	local temp
	local creaturestocheck = {...}
	local count = 0
	dist = dist or 10
	if dist == 0 then
		dist = 10
	end
	if type(floor) == 'string' then
		temp = -(tonumber(floor))
		if not temp then
			table.insert(creaturestocheck, floor)
			floor = 7
		end
	elseif floor > 1000 then
		table.insert(creaturestocheck, floor)
		floor = 7
	end
	table.lower(creaturestocheck)
	if temp then
		if temp > 0 then
			foreach creature c 'p' do
				local diff = c.posz-$posz
				if c ~= $self and diff <= temp and diff >= 0 and math.highest(math.abs(c.posx-$posx), math.abs(c.posy-$posy)) <= dist and (#creaturestocheck == 0 or (not table.find(creaturestocheck,c.name:lower()) and not table.find(creaturestocheck,c.id) and not table.find(creaturestocheck,c))) then
					count = count+1
				end
			end
		else
			foreach creature c 'p' do
				local diff = c.posz-$posz
				if c ~= $self and diff >= temp and diff <= 0 and math.highest(math.abs(c.posx-$posx), math.abs(c.posy-$posy)) <= dist and (#creaturestocheck == 0 or (not table.find(creaturestocheck,c.name:lower()) and not table.find(creaturestocheck,c.id) and not table.find(creaturestocheck,c))) then
					count = count+1
				end
			end
		end
	else
		foreach creature c 'p' do
			local diff = c.posz-$posz
			if c ~= $self and math.abs(diff) <= math.abs(floor) and math.highest(math.abs(c.posx-$posx), math.abs(c.posy-$posy)) <= dist and (#creaturestocheck == 0 or (not table.find(creaturestocheck,c.name:lower()) and not table.find(creaturestocheck,c.id) and not table.find(creaturestocheck,c))) then
				count = count+1
			end
		end
	end
	return count
end

function bininsert1asc(tablename,value)
	if type(tablename) == 'table' then
		local left,right = 1, #tablename
		while left <= right do
			local mid = math.floor((right+left)/2)
			if tablename[mid] == value then
				return mid
			end
			if tablename[mid] > value then
				right = mid-1
			else
				left = mid+1
			end
		end
	end
	return left
end

function bininsert2asc(tablename,value,argument,left,right)
	if type(tablename) == 'table' then
		left,right = left or 1, right or #tablename
		while left <= right do
			local mid = math.floor((right+left)/2)
			if tablename[mid][argument] == value then
				return mid
			end
			if tablename[mid][argument] > value then
				right = mid-1
			else
				left = mid+1
			end
		end
	end
	return left
end

function bininsert1desc(tablename,value)
	if type(tablename) == 'table' then
		local left,right = 1, #tablename
		while left <= right do
			local mid = math.floor((right+left)/2)
			if tablename[mid] == value then
				return mid
			end
			if tablename[mid] < value then
				right = mid-1
			else
				left = mid+1
			end
		end
	end
	return left
end

function bininsert2desc(tablename,value,argument,left,right)
	if type(tablename) == 'table' then
		local left,right = left or 1, right or #tablename
		while left <= right do
			local mid = math.floor((right+left)/2)
			if tablename[mid][argument] == value then
				return mid
			end
			if tablename[mid][argument] < value then
				right = mid-1
			else
				left = mid+1
			end
		end
	end
	return left
end

function table:insertsorted(value, argument, order, disallowduplicated)
	if type(self) == 'table' then
		if type(value) == 'userdata' or type(value) == 'table' then
			if argument then
				if type(argument) == 'table' then
					for i=1,#argument do
						if type(argument[i]) ~= 'table' then
							argument[i] = {argument[i], 'asc'}
						elseif not argument[i][2] then
							argument[i][2] = 'asc'
						end
					end
					if argument[1][2] == 'asc' then
						inssortedasc_1(self, value, argument)
					else
						inssorteddesc_1(self, value, argument)
					end
				else
					if order == true then
						disallowduplicated = true
						order = false
					end
					order = order or 'asc'
					local postoinsert
					if order == 'asc' then
						postoinsert = bininsert2asc(self, value, argument)
					else
						postoinsert = bin2insertdesc(self, value, argument)
					end
					table.insert(self, postoinsert, value)
					return true
				end
			else
				printerror('You must give some argument to order according to.')
			end
		else
			if argument then
				local temp = order
				order = argument
				disallowduplicated = temp
			end
			order = order or 'asc'
			local postoinsert
			if order == 'asc' then
				postoinsert = bin1insertasc(self, value)
			else
				postoinsert = bin1insertdesc(self, value)
			end
			table.insert(self, postoinsert, value)
			return true
		end
	end
	return false
end

function inssortedasc_1(tablename, value, argument)
	local i = #tablename
	local arg = argument[1][1]
	while i >= 1 do
		if (tablename[i][arg] > value[arg]) then
			tablename[i+1] = tablename[i]
		elseif (tablename[i][arg] == value[arg]) then
			if (#argument > 1) then
				if argument[2][2] == 'asc' then
					return inssortedasc_2(tablename, value, argument, 2, i)
				else
					return inssorteddesc_2(tablename, value, argument, 2, i)
				end
			else
				tablename[i+1] = value
				return true
			end
		else
			tablename[i+1] = value
			return true
		end
		i = i-1
	end
	tablename[i+1] = value
	return true
end

function inssortedasc_2(tablename, value, argument, argpos, right)
	local i = right
	local arg1,arg2 = argument[argpos][1], argument[argpos-1][1]
	while i >= 1 and tablename[i][arg2] == value[arg2] do
		if (tablename[i][arg1] > value[arg1]) then
			tablename[i+1] = tablename[i]
		elseif (tablename[i][arg1] == value[arg1]) then
			if (argpos < #argument) then
				if argument[argpos+1][2] == 'asc' then
					return inssortedasc_2(tablename, value, argument, argpos+1, i)
				else
					return inssorteddesc_2(tablename, value, argument, argpos+1, i)
				end
			else
				tablename[i+1] = value
				return true
			end
		else
			tablename[i+1] = value
			return true
		end
		i = i-1
	end
	tablename[i+1] = value
	return true
end

function inssorteddesc_1(tablename, value, argument)
	local i = #tablename
	local arg = argument[1][1]
	while i >= 1 do
		if (tablename[i][arg] < value[arg]) then
			tablename[i+1] = tablename[i]
		elseif (tablename[i][arg] == value[arg]) then
			if (#argument > 1) then
				if argument[2][2] == 'asc' then
					return inssortedasc_2(tablename, value, argument, 2, i)
				else
					return inssorteddesc_2(tablename, value, argument, 2, i)
				end
			else
				tablename[i+1] = value
				return true
			end
		else
			tablename[i+1] = value
			return true
		end
		i = i-1
	end
	tablename[i+1] = value
	return true
end

function inssorteddesc_2(tablename, value, argument, argpos, right)
	local i = right
	local arg1,arg2 = argument[argpos][1], argument[argpos-1][1]
	while i >= 1 and tablename[i][arg2] == value[arg2] do
		if (tablename[i][arg1] < value[arg1]) then
			tablename[i+1] = tablename[i]
		elseif (tablename[i][arg1] == value[arg1]) then
			if (argpos < #argument) then
				if argument[argpos+1][2] == 'asc' then
					return inssortedasc_2(tablename, value, argument, argpos+1, i)
				else
					return inssorteddesc_2(tablename, value, argument, argpos+1, i)
				end
			else
				tablename[i+1] = value
				return true
			end
		else
			tablename[i+1] = value
			return true
		end
		i = i-1
	end
	tablename[i+1] = value
	return true
end

function ringinuse(iid)
	local rings = {{3092, 3095}, {3091, 3094}, {3093, 3096}, {3052, 3089}, {3098, 3100}, {3097, 3099}, {3051, 3088}, {3053, 3090}, {3049, 3086}, {9593, 9593}, {9393, 9392}, {3007, 3007}, {6299, 6300}, {9585, 9585}, {3048, 3048}, {3050, 3087}, {3245, 3245}, {3006, 3006}, {349, 349}, {3004, 3004}}
	local temp = table.find(rings, itemid(iid), 1)
	if temp then
		return rings[temp][2]
	end
	return 0
end

function castspellarea(spell, amount, ignoreplayers, ...)
	if type(spell) ~= 'table' then
		spell = spellinfo(spell)
	end
	if cancastspell(spell) then
		if type(amount) ~= 'number' then
			amount = 0
		end
		local monsters = {...}
		if type(ignoreplayers) ~= 'boolean' then
			table.insert(monsters, ignoreplayers)
			ignoreplayers = false
		end
		local needdir = false
		if table.find({'front', 'bigbeam', 'smallbeam', 'bigwave', 'smallwave', 'strike'}, spell.condition) then
			needdir = true
		end
		if needdir then
			local count = {w = 0, e = 0, n = 0, s = 0}
			foreach creature m 's' do
				for i,j in pairs(count) do
					if isonspellarea(m, spell.condition, i) then
						if m.ismonster then
							if #monsters == 0 or table.find(monsters,m.name:lower()) or table.find(monsters,m.id) or table.find(monsters,m) then
								count[i] = count[i]+1
							end
						elseif not ignoreplayers and m ~= $self then
							return false
						end
					end
				end
			end
			local bestdir = $self.dir
			for i,j in pairs(count) do
				if j > count[bestdir] then
					bestdir = i
				end
			end
			if count[bestdir] >= amount then
				while $self.dir ~= bestdir do turn(bestdir) wait(50,100) end
				cast(spell.words)
				return true
			end
		else
			local count = 0
			foreach creature m 's' do
				if isonspellarea(m, spell.condition) then
					if m.ismonster then
						if #monsters == 0 or table.find(monsters,m.name:lower()) or table.find(monsters,m.id) or table.find(monsters,m) then
							count = count+1
						end
					elseif not ignoreplayers and m ~= $self then
						return false
					end
				end
			end
			if count >= amount then
				cast(spell.words)
				return true
			end
		end
	end
end

function tilewalkable(x,y,z)
	x,y,z = x or $posx, y or $posy, z or $posz
	if type(x) == 'string' then
		local dirx = {c = 0, n = 0, s = 0, w = -1, e = 1, nw = -1, ne = 1, sw = -1, se = 1}
		local diry = {c = 0, n = -1, s = 1, w = 0, e = 0, nw = -1, ne = -1, sw = 1, se = 1}
		for i,j in pairs(dirx) do
			if i == x then
				x = j
				y = diry[i]
				break
			end
		end
		z = $posz
	end
	local tile = gettile(x,y,z)
	local v = 1
	if tile.item[v].id == 0 or itemproperty(tile.item[v].id, ITEM_FLOORCHANGE) or not itemproperty(tile.item[v].id, ITEM_GROUND) then
		return false
	end
	v = 2
	if itemproperty(tile.item[v].id, ITEM_TOPORDER1) then
		v = 3
	end
	if itemproperties(tile.item[v].id, ITEM_MINIMAP, ITEM_NOTMOVEABLE) then
		if itemproperty(tile.item[v].id, ITEM_BLOCKPATHS) and not itemproperty(tile.item[v].id, ITEM_GROUND) then
			return false
		elseif itemproperty(tile.item[v].id, ITEM_TOPORDER2) and itemproperty(tile.item[v].id, ITEM_BLOCKPATHS) and (itemproperty(tile.item[v].id, ITEM_HEIGHTED) or itemproperty(tile.item[v].id, ITEM_LIGHTFONT)) then
			return false
		end
	end
	for i=1, tile.itemcount do
		if (itemproperty(tile.item[i].id, ITEM_BLOCKWALK) or (tile.item[i].id == 99 and (tile.item[i].count > 0x40000000 or getsetting('Cavebot/Pathfinding/WalkThroughPlayers') == 'no'))) then
			return false
		end
	end
	return true
end

function trapped()
	if not $cavebot or ($wpttype == 'action') or ($wptx == 0) then
		for j=-1, 1 do
			for i=-1, 1 do
				if i ~= 0 or j ~= 0 then
					if tilewalkable($posx+i,$posy+j,$posz) then
						return false
					end
				end
			end
		end
		return true
	else
		if tilereachable($wptx,$wpty,$wptz,true) then
			return false
		end
		return true
	end
end

function randomize(ttable)
	local value = 0
	if type(ttable) == 'table' then
		value = math.random(table.unpack(ttable))
	end
	return value
end

_USEITEMON = _USEITEMON or useitemon
function useitemon(fromid,toid,todest,fromdest)
	toid, todest, fromdest = toid or 0, todest or '', fromdest or ''
	if toid == 0 or not toid then
		local tableequip = {{'rhand', $rhand}, {'lhand', $lhand}, {'head', $head}, {'chest', $chest}, {'legs', $legs}, {'feet', $feet}, {'finger', $finger}, {'neck', $neck}, {'belt', $belt}, {'back', $back}}
		local temp = table.find(tableequip, todest, 1)
		if temp then
			toid = tableequip[temp][2].id
		end
	end
	return _USEITEMON(fromid,toid,todest,fromdest)
end

function getplayerteam(name)
	if name == $name then
		return TEAM_SELF
	elseif isenemy(name) then
		return TEAM_ENEMY
	elseif isfriend(name) then
		return TEAM_FRIEND
	elseif isleader(name) then
		return TEAM_LEADER
	else
		return TEAM_NOTEAM
	end
end

function string:fitcontent(sizex)
	local w = calcstringsize(self)
	local temp2 = self
	if w > sizex then
		local temp = ''
		for i=1, #self do
			temp = temp2:sub(1,i)..'...'
			w = calcstringsize(temp)
			if w < sizex then
				self = temp
			end
		end
	end
	return self
end

SYNCSPELL = {cast = false}
function SYNCSPELL:new(n)
	n = n or {cast = false}
	setmetatable(n, self)
	self.__index = self
	return n
end

function SYNCSPELL:check()
	foreach newmessage m do
		if m.type == MSG_STATUSLOG then
			local m = m.content:attackmsg()
			if m.dealer.name == $name then
				self.cast = true
			end
		end
	end
end

function SYNCSPELL:cast(spell)
	if self.cast then
		if $attacked.id > 0 and castspell(spell) then
			self.cast = false
			return true
		else
			self.cast = false
			return false
		end
	end
end

function addtextmouse(...)
	local table = {...}
	setfontstyle('Verdana', 8, 0xFFFFFF, 1)
	setbordercolor(0)
	local text = ''
	for i,j in ipairs(table) do
		text = text..j..', '
	end
	local pos = getposition()
	addtext(text:sub(1,#text-2), $cursor.x-pos.x, $cursor.y-pos.y+25)
end

ACCMANAGEMENT = {info = {}, currentchar = 0, serversave = {from = tosec('6:00'), to = tosec('6:15'), randomdelay = {0, 300}, delay = math.random(0,300)}}
function ACCMANAGEMENT:new(n)
	n = n or {info = {}, currentchar = 0, serversave = {from = tosec('6:00'), to = tosec('6:15'), randomdelay = {0, 300}, delay = math.random(0,300)}}
	setmetatable(n, self)
	self.__index = self
	return n
end

function ACCMANAGEMENT:add(acc,pass,char)
	if acc and pass and char then
		table.insert(self.info, {account = acc, password = pass, name = char})
		return true
	end
	return false
end

function ACCMANAGEMENT:remove(toremove)
	local pos = table.find(self.info, toremove, 'name') or table.find(self.info, toremove, 'account') or table.find(self.info, toremove, 'password')
	if pos then
		table.remove(self.info, pos)
		return true
	end
	return false
end

function ACCMANAGEMENT:setserversavetime(from, to, randomdelay)
	self.serversave.from = tosec(from) or tosec('6:00')
	self.serversave.to = tosec(to) or tosec('6:15')
	self.serversave.randomdelay = randomdelay or {0,300}
	self.serversave.delay = randomize(self.serversave.randomdelay) or math.random(0,300)
end

function ACCMANAGEMENT:getcurrentchar()
	if $connected then
		self.currentchar = table.find(self.info, $name, 'name') or 1
	else
		self.currentchar = 1
	end
end

function ACCMANAGEMENT:updatecurrentchar()
	if self.currentchar == 0 then
		self:getcurrentchar()
	end
end

function ACCMANAGEMENT:loginnextchar()
	local nextchar = (self.currentchar + 1)
	if nextchar > #self.info then
		nextchar = 1
	end
	waitandlogout()
	local time = tosec()
	if time < self.serversave.from or time > self.serversave.to+self.serversave.delay then
		while not $connected do
			connect(self.info[nextchar].account, self.info[nextchar].password, self.info[nextchar].name)
			local t = $timems+2000
			while $timems < t and not $connected do
				wait(100)
			end
		end
		self.currentchar = nextchar
		self.serversave.delay = randomize(self.serversave.randomdelay) or math.random(0,300)
	end
end

function ACCMANAGEMENT:reconnect()
	waitandlogout()
	local time = tosec()
	if time < self.serversave.from or time > self.serversave.to+self.serversave.delay then
		while not $connected do
			connect(self.info[self.currentchar].account, self.info[self.currentchar].password, self.info[self.currentchar].name)
			local t = $timems+2000
			while $timems < t and not $connected do
				wait(100)
			end
			self.serversave.delay = randomize(self.serversave.randomdelay) or math.random(0,300)
		end
	end
end
class PerlinNoise:
	var permutation = [ 151,160,137,91,90,15, 
			131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,	
			190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
			88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
			77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
			102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
			135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
			5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
			223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
			129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
			251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
			49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
			138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
		]
	
	var p = []
	
	func _init():
		for x in range (0, 512):
			p.append(permutation[x%256])
		
	
	func perlin(x, y, z, octaves, persistence):
		var total = 0.0
		var frequency = 1
		var amplitude = 1.0
		var maxValue = 0.0
		for i in range (0, octaves):
		    total += _perlin(x * frequency, y * frequency, z * frequency) * amplitude
		    maxValue += amplitude
		    amplitude *= persistence
		    frequency *= 2.0
		return total / maxValue
	
	func _perlin(x, y, z):
		var xi = int(floor(x)) & 255
		var yi = int(floor(y)) & 255
		var zi = int(floor(z)) & 255
		var xf = x-floor(x)
		var yf = y-floor(y)
		var zf = z-floor(z)
		var u = fade(xf)
		var v = fade(yf)
		var w = fade(zf)
		var xip1 = xi+1
		var yip1 = yi+1
		var zip1 = zi+1
		var aaa = p[p[p[xi]+yi]+zi]
		var aba = p[p[p[xi]+yip1]+zi]
		var aab = p[p[p[xi]+yip1]+zip1]
		var abb = p[p[p[xip1]+yi]+zi]
		var baa = p[p[p[xip1]+yi]+zi]
		var bba = p[p[p[xip1]+yip1]+zi]
		var bab = p[p[p[xip1]+yi]+zip1]
		var bbb = p[p[p[xip1]+yip1]+zip1]
		var x1 = lerp(grad (aaa, xf, yf, zf), grad (baa, xf-1, yf, zf),	u)
		var x2 = lerp(grad (aba, xf, yf-1, zf), grad (bba, xf-1, yf-1, zf), u)
		var y1 = lerp(x1, x2, v)
		x1 = lerp(grad (aab, xf, yf, zf-1), grad (bab, xf-1, yf  , zf-1), u)
		x2 = lerp(grad (abb, xf  , yf-1, zf-1), grad (bbb, xf-1, yf-1, zf-1), u)
		var y2 = lerp (x1, x2, v)
		return (lerp (y1, y2, w)+1.0)/2.0

#	func grad(_hash, x, y, z):
#		var h = int(_hash) & 15
#		var u = x if h < 8 else y
#
#		var v
#
#		if (h < 4):
#		    v = y
#		elif (h == 12 or h == 14):
#		    v = x
#		else:
#		    v = z
#
#		return (u if (h & 1) == 0 else -u) + (v if (h & 2) == 0 else -v)

	func grad(_hash, x, y, z):
		match (_hash & 0xF):
		    0x0: return  x + y
		    0x1: return -x + y
		    0x2: return  x - y
		    0x3: return -x - y
		    0x4: return  x + z
		    0x5: return -x + z
		    0x6: return  x - z
		    0x7: return -x - z
		    0x8: return  y + z
		    0x9: return -y + z
		    0xA: return  y - z
		    0xB: return -y - z
		    0xC: return  y + x
		    0xD: return -y + z
		    0xE: return  y - x
		    0xF: return -y - z
		    _: return 0

	
	func fade(t):
		return t * t * t * (t * (t * 6 - 15) + 10)
	
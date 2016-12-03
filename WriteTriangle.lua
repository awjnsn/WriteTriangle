--Script to generate a ASCII STL file from user defined triangles
--Written by Alex Johnson 12-3-16 to learn the Lua scripting language

io.write("ASCII STL GENERATOR:\n")
io.write("STL File Name:")
--Gets the name of the file
fileName = io.read()
--Appends .stl to the file name then opens the file
stlFile = io.open(fileName .. ".stl", "w")
--Writes the beginning of the file
stlFile:write("solid \"" .. fileName .. "\"\n")

triangleCount = 1

io.write("Example Vertext Entry - Vertext 1: 0 1 2\n")
--Repeats while the user wants to continue entering triangles
repeat
	io.write("Triangle #" .. triangleCount .. "\n")
	local verts = {}
	--Gets the the three vertices of the triangle
	for i = 1, 3 do
		io.write("Vertext " .. i .. ": ")
		local vertString = io.read()
		for vert in vertString:gmatch("%S+") do table.insert(verts, vert) end
	end
	--Checks to make sure the user enter valid vertices
	local confirm = ""
	if #verts == 9 then
		io.write("Triangle with vertices\n")
		io.write("(" .. verts[1] .. " " .. verts[2] .. " " .. verts[3] .. ")\n")
		io.write("(" .. verts[4] .. " " .. verts[5] .. " " .. verts[6] .. ")\n")
		io.write("(" .. verts[7] .. " " .. verts[8] .. " " .. verts[9] .. ")\n")
		io.write("Confirm [y/n]: ")
		confirm = io.read()
	else
		io.write("Error: Bad Triangle (Insufficient Vertices)\n")
	end
	--If the user entered valid vertices and confirms their entry
	if confirm == "y" then
		triangleCount = triangleCount + 1
		--Converts the user entries into strings in floating point format
		for i = 1,9 do verts[i] = string.format("%e", verts[i]) end
		--Calculates the two vectors that will determine the surface normal vector
		local vx = verts[4] - verts[1]
		local wx = verts[7] - verts[1]
		local vy = verts[5] - verts[2]
		local wy = verts[8] - verts[2]
		local vz = verts[6] - verts[3]
		local wz = verts[9] - verts[3]
		--Calculates and formats the surface normal vector from the determinant of vectors v and w
		local nx = string.format("%e", (vy * wz) - (vz * wy))
		local ny = string.format("%e", (vz * wx) - (vx * wz))
		local nz = string.format("%e", (vx * wy) - (vy * wx))
		--Writes the triangle's data to the file
		stlFile:write("\tfacet normal ".. nx .. " " .. ny .. " " .. nz .. "\n")
		stlFile:write("\t\touter loop\n")
		stlFile:write("\t\t\tvertex " .. verts[1] .. " " .. verts[2] .. " " .. verts[3] .. "\n")
		stlFile:write("\t\t\tvertex " .. verts[4] .. " " .. verts[5] .. " " .. verts[6] .. "\n")
		stlFile:write("\t\t\tvertex " .. verts[7] .. " " .. verts[8] .. " " .. verts[9] .. "\n")
		stlFile:write("\t\tendloop\n")
		stlFile:write("\tendfacet\n")
	end

	io.write("Continue [y/n]: ")
--Checks if the user wants to enter another triangle
until io.read() ~= "y"
--Writes the end part of the file and closes the file
stlFile:write("endsolid \"" .. fileName .. "\"")
stlFile:close()
io.write("STL file saved as " .. fileName .. ".stl\n")

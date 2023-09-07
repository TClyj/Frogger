# Frogger

Owner: **Yijia Lu**

It is a project which writing Systemverilog code in Quartus and building needed hardware to achieve the classic arcade game **"Frogger"**.

For this project, the user input is the four key button to control the movement of the frog. The
LED array will react based on the input signal. Also, the location of the frog will be updated
when the user presses the button and the crash function will determine if the user loses the
game based on when the green pixel and red pixel appear in the same LED location. 

Also, if the location of the frog (which is the green pixel) reaches a certain line in the LED array, the win
function will output a win signal, which will reset the game. The traffic flow is created by using a
slower clock to make sure the frog can be faster than the vehicle.

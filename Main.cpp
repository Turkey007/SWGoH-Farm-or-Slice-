#include <iostream>
using namespace std;

const int credits_default = 3500; //Credits:Crystals ratio
const int slice[16] = {0,0,0,0,0,0,0,0,0,0,0,0,3,4,5,6};//All possible increases for speed on a slice, equally weighted
const int first_roll[16] = {0,0,0,0,0,0,0,0,0,0,0,0,3,4,5,5};//6 starting speed is very rare, so I've replaced it with 5

class mod
{
        int speed = 0; //0-29
        int slices_left = 5; // 0 for gold, 5 for level 0 grey
        mod(const mod & to_copy);
};

float cost4speed(mod to_slice, int target_speed);

int main()
{
        //Asking the user how valuable they think credits are
        int credits = credits_default;
        cout << "How many credits are worth 1 crystal? (If unsure, enter the default value of " << credits << ") \n";
        cin >> credits;
//I decided to use constants for these arrays instead, so I commented them out
/*      int slice[16];
        for (int i = 0; i < 12; ++i)
                slice[i] = 0;
        for (int i = 0; i < 4; ++i)
                slice[i+12] = i+3;
        for (int i = 0; i < 16; ++i)
                cout << slice[i] << " ";
        int first_roll[16];
        for (int i = 0; i < 15; ++i)
                first_roll[i] = slice[i];
        first_roll[15] = 5;
*/

}

//Constructor
mod::mod(const mod & to_copy)
{
        speed = to_copy.speed;
        slices_left = to_copy.slices_left;
}

//Calculates the average crystal cost for a given mod to reach the target speed
float cost4speed(mod to_slice, int target_speed)
{
        mod combinations[16]; //Does not compile with the constructor I wrote cuz I am clueless on arrays with constructors
        for (int i = 0; i < 16; ++i)
        {
                combinations[i] = to_slice;
                combinations[i].speed = slice[i];
                --combinations[i].slices_left;
                //Call recursively for next color. I.e., blue mods will call themselves for purple
                //Need some way to eliminate the cost for combinations which are not worth it to slice further
                if(slices_left > 0)
                        cost4speed(next_tier, target_speed);
                //Find the odds of speed hitting the target
                //(combinations where speed >= target)/(total number of recursive combinations)
                //But the cost is different for each combination. Some combinations stop without slicing all the way to gold because they're not worth it

        }
}

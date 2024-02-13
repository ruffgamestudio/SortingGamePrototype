using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{

    public List<Box> levelBoxes;

    private List<Box> inactiveBoxes;
    private List<Box> activeBoxes;

    private void Awake()
    {
        if(levelBoxes.Count > 0)
        {
            inactiveBoxes = levelBoxes.FindAll(b => b.active == false);
            activeBoxes = levelBoxes.FindAll(b => b.active == true);
        }
       
    }


    

}

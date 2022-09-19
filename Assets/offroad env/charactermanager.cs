using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class charactermanager : MonoBehaviour
{
    
   
    public GameObject toppanel, characterpanel, carselectionpanel;
    public GameObject cam1, cam2, cam3;

       void Start()
    {
      


       
    }
    public void onclickcharacter()
    {
        characterpanel.SetActive(true);
        toppanel.SetActive(false);
        cam1.SetActive(false);
        cam2.SetActive(true);

    }
    public void onclickcharacterback()
    {
        characterpanel.SetActive(false);
        toppanel.SetActive(true);
        cam1.SetActive(true);
        cam2.SetActive(false);
    }
  
   


    public void onclickselect()
    {

        carselectionpanel.SetActive(true);
        characterpanel.SetActive(false);
        cam3.SetActive(true);
        cam2.SetActive(false);
    }


    public void onclickgarage()
    {

        carselectionpanel.SetActive(true);
        toppanel.SetActive(false);
        cam3.SetActive(true);
        cam1.SetActive(false);
    }
}

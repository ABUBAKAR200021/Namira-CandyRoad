using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class fuelcontainer : MonoBehaviour
{
   // RCC_CarControllerV3 rCC_CarControllerV3;
    // Start is called before the first frame update
    public void OnTriggerEnter(Collider other)
    {

        if (other.gameObject.tag == "Player")
        {
           // RCC_CarControllerV3.FuelCheck = false;
            print("fuel check false");
            this.gameObject.SetActive(false);
            HR_OptionsHandler.instance.fuelPointUI.SetActive(true);

            HR_OptionsHandler.instance.lowFueltext.SetActive(false);
            RCC_CarControllerV3.instance.fuelTank = 60;
            HR_OptionsHandler.instance.alarm.enabled = false;

            //  HR_OptionsHandler.instance.StartEngine();

        }

        }
    }

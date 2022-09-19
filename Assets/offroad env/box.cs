using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class box : MonoBehaviour
{
    public GameObject parti;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    public void OnTriggerEnter(Collider other)
    {
       if(other.gameObject.tag== "Player")
        {
            parti.SetActive(true);
            this.gameObject.SetActive(false);
            PlayerPrefs.SetInt("Currency", PlayerPrefs.GetInt("Currency") + 100);
        }
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class gem : MonoBehaviour
{
    public void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag=="Player")
        {
            this.transform.GetChild(0).gameObject.SetActive(false);
            this.transform.GetChild(1).gameObject.SetActive(true);
            this.GetComponent<AudioSource>().Play();
            PlayerPrefs.SetInt("gems", PlayerPrefs.GetInt("gems") + 100);
        }
    }
}

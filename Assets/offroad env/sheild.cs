using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class sheild : MonoBehaviour
{
    public GameObject sheid;
    // Start is called before the first frame update
    public void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {

            print(other.gameObject);
            other.gameObject.transform.GetChild(2).gameObject.SetActive(true);
           // other.gameObject.transform.GetChild(1).gameObject.SetActive(true);
            this.gameObject.transform.GetChild(0).gameObject.SetActive(false);
            this.gameObject.GetComponent<BoxCollider>().enabled = false;
           // Time.timeScale = 2.0f;
           sheid.SetActive(true);
           // Invoke("nosfalse", 10.0f);
        }
    }
}

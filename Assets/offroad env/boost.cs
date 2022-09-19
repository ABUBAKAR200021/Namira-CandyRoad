using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class boost : MonoBehaviour
{
   // public GameObject cam;
    public GameObject nos;
    GameObject player;
    // Start is called before the first frame update
    void Start()
    {
      
    }

    // Update is called once per frame
    public void OnTriggerEnter(Collider other)
    {
        if(other.gameObject.tag== "Player")
        {
            
                print(other.gameObject);
            other.gameObject.transform.GetChild(0).gameObject.SetActive(true);
            other.gameObject.transform.GetChild(1).gameObject.SetActive(true);
            this.gameObject.transform.GetChild(0).gameObject.SetActive(false);
            this.gameObject.GetComponent<BoxCollider>().enabled = false;
            Time.timeScale = 1.35f;
            nos.SetActive(true);
            Invoke("nosfalse", 10.0f);
        }
    }

    public void nosfalse()
    {
        Time.timeScale = 1.0f;
    }
   
}

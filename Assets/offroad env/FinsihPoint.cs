using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FinsihPoint : MonoBehaviour
{
    // Start is called before the first frame update
    public GameObject WinPanel, FailPanel;
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    public void FinishTriggerFn()
    {
        
    }
    public void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            WinPanel.SetActive(true);
            Time.timeScale = 0;
            if (PlayerPrefs.GetInt("CurrentLevel") >= PlayerPrefs.GetInt("UnlockLevel") )
            {
                PlayerPrefs.SetInt("CurrentLevel", PlayerPrefs.GetInt("CurrentLevel") + 1);
                PlayerPrefs.SetInt("UnlockLevel", PlayerPrefs.GetInt("UnlockLevel") + 1);
                print(PlayerPrefs.GetInt("CurrentLevel"));
                print(PlayerPrefs.GetInt("UnlockLevel"));
            }
           
        }
        else
        {
            if (other.gameObject.tag == "oppo")
            { 
            FailPanel.SetActive(true);
                Time.timeScale = 0;

            }
        
        }
    }
}

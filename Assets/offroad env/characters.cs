using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class characters : MonoBehaviour
{
    public GameObject[] player;
    // Start is called before the first frame update
    void Start()
    {
        for (int i = 0; i < player.Length; i++)
        {
            if (i == PlayerPrefs.GetInt("SelectedCar"))
            {
                player[i].gameObject.SetActive(true);

            }
            else
            {
                player[i].gameObject.SetActive(false);

            }
        }

    }

    // Update is called once per frame
    void Update()
    {
        
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnvironmentInstantiate : MonoBehaviour
{
    // Start is called before the first frame update
    public GameObject EnvPoz;
    public GameObject Environment;
    public static bool EnvBool;
    void Start()
    {
        EnvBool = true;
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    public void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            if (EnvBool)
            {
                Instantiate(Environment, EnvPoz.transform.position, Quaternion.identity);
                EnvBool = false;
            }
           

        }
    }
}

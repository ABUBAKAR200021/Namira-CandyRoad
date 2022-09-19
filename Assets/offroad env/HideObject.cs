using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HideObject : MonoBehaviour
{
    public int time=3;
    private void OnEnable()
    {
        Invoke("HideThis", time);
    }
    void HideThis()
    {
        //CancelInvoke();
        gameObject.SetActive(false);
       
    }

}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotationobj : MonoBehaviour
{
    public enum Axis{ X, Y, Z}

    [SerializeField] float speed;

    [SerializeField] Axis axis;

   
    void Update()
    {
            if (axis.Equals(Axis.X))
            {
                transform.Rotate(Time.deltaTime * speed, 0, 0, Space.Self);

            }
            else if (axis.Equals(Axis.Y))
            {
                transform.Rotate(0, Time.deltaTime * speed, 0, Space.Self);
            }
            else if (axis.Equals(Axis.Z))
            {
                transform.Rotate(0, 0, Time.deltaTime * speed, Space.Self);
            }
        
    }
}

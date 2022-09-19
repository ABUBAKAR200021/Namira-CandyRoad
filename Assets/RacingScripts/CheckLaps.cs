using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
//using UnityStandardAssets.Utility;

public class CheckLaps : MonoBehaviour
{

    public RCC_AIWaypointsContainer waypointsContainer;
    public int currentWaypoint = 0;

    public int nextWaypointPassRadius = 10;
    public int totalWaypointPassed;
    public int lap = 0;

    public int noOfLaps;

    [SerializeField] Text lapsIndicator;

    private void Start()
    {
        if (!waypointsContainer)
            waypointsContainer = FindObjectOfType(typeof(RCC_AIWaypointsContainer)) as RCC_AIWaypointsContainer;

        noOfLaps = PlayerPrefs.GetInt("Laps");
    }
    void FixedUpdate()
    {
        Vector3 nextWaypointPosition = transform.InverseTransformPoint
            (new Vector3(waypointsContainer.waypoints[currentWaypoint].transform.position.x, transform.position.y, waypointsContainer.waypoints[currentWaypoint].transform.position.z));

        if (nextWaypointPosition.magnitude < nextWaypointPassRadius)
        {

            currentWaypoint++;
            totalWaypointPassed++;

            // If all waypoints are passed, sets the current waypoint to first waypoint and increase lap.
            if (currentWaypoint >= waypointsContainer.waypoints.Count)
            {
                currentWaypoint = 0;
                lap++;
            }

        }

        lapsIndicator.text = lap.ToString("0" + "/" + noOfLaps);


    }
}

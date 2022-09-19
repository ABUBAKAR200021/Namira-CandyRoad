using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
//using UnityEngine.Experimental.PlayerLoop;
using UnityEngine.UI;

public class RaceLoader : MonoBehaviour
{
    [SerializeField] GameObject countDown;
    [SerializeField] Text countDownTimer;

    [SerializeField] GameObject failPanel, gppanel;
    [SerializeField] GameObject completePanel;
    [SerializeField] GameObject pausepanel;
    public Transform[] oppoCarPositions;
    public GameObject[] oppoCars, players;
    public RCC_AIWaypointsContainer[] wayPoints;

    public GameObject[] finish;
    public List<GameObject> oppoCarsPrefabs;


    private bool oppoWin;
    private bool playerWin;

    [Header("Level Data")]
    public List<LevelData> levelData;


    [System.Serializable]
    public class LevelData
    {
        public string levelName;

        public int oppoSpeed;
        public int noOfOpponents;
        public int noOfLaps;


        public LevelData(string name)
        {
            levelName = name;
        }
    }
    //private void CheckGame()
    //{
    //    PlayerPrefs.SetInt("Oppo", 2);
    //    PlayerPrefs.SetInt("OppoSpeed", 50);
    //    PlayerPrefs.SetInt("Laps", 4);
    //}


    private void Awake()
    {
           for (int i = 0; i < players.Length; i++)
        {
            print(PlayerPrefs.GetInt("Selectedcarno"));
            if (i == PlayerPrefs.GetInt("Selectedcarno"))
            {
                players[i].SetActive(true);
            }
            else
            {
                players[i].SetActive(false);
            }
        }
    }

    void Start()
    {

        // CheckGame();

        // Get Level Number From Main Menu
        int level = PlayerPrefs.GetInt("CurrentLevel") ;

        // Set data According to Level


        // Set No. Of Opponents
        PlayerPrefs.SetInt("Oppo", levelData[level].noOfOpponents);

        // Set No. Of Laps
        PlayerPrefs.SetInt("Laps", levelData[level].noOfLaps);

        // Set Oppo Speed
       

        for (int i = 0; i < finish.Length; i++)
        {
            if (i == PlayerPrefs.GetInt("CurrentLevel"))
            {
                finish[i].SetActive(true);
            }
            else
            {
                finish[i].SetActive(false);
            }
        }

        PlayerPrefs.SetInt("OppoSpeed", levelData[level].oppoSpeed);
      


      //  PlayerPrefs.GetInt("SelectedPlayerCarIndex", 0);

        countDown.SetActive(false);
        countDownTimer.text = "3";

   // GameObject.FindGameObjectWithTag("Player").GetComponent<RCC_CarControllerV3>().canControl = false;

        Invoke("SetCarSpeed", 1f);

        int noOfOppo = PlayerPrefs.GetInt("Oppo");
        

        for (int i = 0; i < noOfOppo; i++)
        {
            oppoCarsPrefabs.Add(Instantiate(oppoCars[Random.Range(0, oppoCars.Length)], oppoCarPositions[i].position, oppoCarPositions[i].rotation));

            oppoCarsPrefabs[i].GetComponent<RCC_AICarController>().waypointsContainer = wayPoints[i];
        }

       


        

        StartCoroutine(CountDown());
    }


    private void SetCarSpeed()
    {
        foreach (GameObject g in oppoCarsPrefabs)
        {
            g.GetComponent<RCC_AICarController>().enabled = false;
            g.GetComponent<Rigidbody>().isKinematic = true;

            g.GetComponent<RCC_AICarController>().limitSpeed = true;
            g.GetComponent<RCC_AICarController>().maximumSpeed = PlayerPrefs.GetInt("OppoSpeed");
        }
    }


    IEnumerator CheckWinFailCondition()
    {

        while(true)
        {
            yield return new WaitForSeconds(Time.timeScale * 2f);
            for (int i = 0; i < oppoCarsPrefabs.Count; i++)
            {
                if (oppoCarsPrefabs[i].GetComponent<RCC_AICarController>().lap >= PlayerPrefs.GetInt("Laps") && !playerWin && !oppoWin)
                {
                    oppoWin = true;
                    playerWin = false;
                    yield return new WaitForSeconds(Time.timeScale);
                    FindObjectOfType<CheckLaps>().GetComponent<RCC_CarControllerV3>().canControl = false;
                    yield return new WaitForSeconds(Time.timeScale);
                    Time.timeScale = 0f;
                    failPanel.SetActive(true);
                }

            }

            if (FindObjectOfType<CheckLaps>().lap >= PlayerPrefs.GetInt("Laps") && !playerWin && !oppoWin)
            {
                playerWin = true;
                oppoWin = false;
                yield return new WaitForSeconds(Time.timeScale);
                FindObjectOfType<CheckLaps>().GetComponent<RCC_CarControllerV3>().canControl = false;
                FindObjectOfType<RCC_Camera>().playerCar = null;
                yield return new WaitForSeconds(Time.timeScale * 3f);
                Time.timeScale = 0f;


                if (PlayerPrefs.GetInt("LevelID") + 1 >= PlayerPrefs.GetInt("PassedLevels_racing"))
                {
                    PlayerPrefs.SetInt("PassedLevels_racing", PlayerPrefs.GetInt("PassedLevels_racing") + 1);
                }
                completePanel.SetActive(true);
            }

            yield return new WaitForSeconds(Time.timeScale / 2f);
           
        }

       
        
    }

    //private void Update()
    //{
    //    print(PlayerPrefs.GetInt("Selectedcarno"));
    //}



    IEnumerator CountDown()
    {
        countDown.SetActive(false);
        countDownTimer.text = "3";

        yield return new WaitForSeconds(2f);
        countDown.SetActive(true);
        yield return new WaitForSeconds(1f);
        countDownTimer.color = Color.blue;
        countDownTimer.text = "2";
        yield return new WaitForSeconds(1f);
        countDownTimer.color = Color.yellow;
        countDownTimer.text = "1";
        yield return new WaitForSeconds(1f);
        countDownTimer.color = Color.red;
        countDownTimer.text = "Go!";
        yield return new WaitForSeconds(0.5f);
        countDown.SetActive(false);

        

        foreach (GameObject g in oppoCarsPrefabs)
        {
            g.GetComponent<RCC_AICarController>().enabled = true;
            g.GetComponent<Rigidbody>().isKinematic = false;
        }

        FindObjectOfType<CheckLaps>().GetComponent<RCC_CarControllerV3>().canControl = true;
        gppanel.SetActive(true);
        yield return new WaitForSeconds(Time.timeScale * 5f);

        StartCoroutine(CheckWinFailCondition());
    }
   


    public void ReloadLevel()
    {
        SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
        Time.timeScale = 1;
    }

    public void pause()
    {
        pausepanel.SetActive(true);
        Time.timeScale = 0.01f;
    }
    public void resume()
    {
        pausepanel.SetActive(false
            );
        Time.timeScale = 1f;
    }
    
    public void home()
    {
        SceneManager.LoadScene(0);
    }

}

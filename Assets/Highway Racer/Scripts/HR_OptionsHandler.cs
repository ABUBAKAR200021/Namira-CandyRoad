//----------------------------------------------
//           	   Highway Racer
//
// Copyright © 2014 - 2017 BoneCracker Games
// http://www.bonecrackergames.com
//
//----------------------------------------------

using UnityEngine;
using System.Collections;
using UnityEngine.UI;
public class HR_OptionsHandler : MonoBehaviour {
    public static HR_OptionsHandler instance;
    public GameObject pausedMenu;
	public GameObject pausedButtons;
	public GameObject optionsMenu;
	public GameObject optionsMenu_PP;
    public Text totalcash;
    public Text totalgems;
    public Slider fuelSlider;
    public GameObject fuelPointUI, lowFueltext;
    RCC_CarControllerV3 rCC_CarControllerV3;
    public AudioSource alarm;
    public void Start()
    {
        instance = this;
        Time.timeScale = 1;
    }
    void OnEnable(){

		HR_GamePlayHandler.OnPaused += OnPaused;
		HR_GamePlayHandler.OnResumed += OnResumed;

	}

	public void ResumeGame () {
		
		HR_GamePlayHandler.Instance.Paused();
		
	}

	public void RestartGame () {

		HR_GamePlayHandler.Instance.RestartGame();
	
	}

	public void MainMenu () {
		
		HR_GamePlayHandler.Instance.MainMenu();
		
	}
    public void StartEngine()
    {
        rCC_CarControllerV3.fuelTank = 60;
        rCC_CarControllerV3.StartEngine(true);
        lowFueltext.SetActive(false);
      
    }
    public void Update()
    {
        totalcash.text = PlayerPrefs.GetInt("Currency").ToString();
        totalgems.text = PlayerPrefs.GetInt("gems").ToString();
    }
    public void OptionsMenu (bool open) {

		if (HR_HighwayRacerProperties.Instance.usePostProcessingImageEffects) {

			optionsMenu.SetActive (false);
			optionsMenu_PP.SetActive (open);

		} else {

			optionsMenu.SetActive (open);
			optionsMenu_PP.SetActive (false);

		}

		if (open)
			pausedButtons.SetActive (false);
		else
			pausedButtons.SetActive (true);

	}

	void OnPaused () {

		pausedMenu.SetActive(true);
		pausedButtons.SetActive(true);

		AudioListener.pause = true;
		Time.timeScale = 0;

		
	}

	public void OnResumed () {

		pausedMenu.SetActive(false);
		pausedButtons.SetActive(false);

		AudioListener.pause = false;
		Time.timeScale = 1;

	}

	public void ChangeCamera(){

		if (GameObject.FindObjectOfType<HR_CarCamera> ())
			GameObject.FindObjectOfType<HR_CarCamera> ().ChangeCamera ();

	}

	void OnDisable(){

		HR_GamePlayHandler.OnPaused -= OnPaused;
		HR_GamePlayHandler.OnResumed -= OnResumed;

	}

}

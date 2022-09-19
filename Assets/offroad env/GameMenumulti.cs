using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameMenumulti : MonoBehaviour
{
    public GameObject modespanel,loading,levelpanel1, levelpanel2, levelpanel3
        ,shoppanel,characterpanel,powerupspanel;

    public GameObject coinsbutt, offerbutt, yellowcoin, yellowoffer;
    public void Onclickarcade()
    {
        modespanel.SetActive(true);
    }
    public void onclickcoinsbutt()
    {
        coinsbutt.SetActive(true);
        offerbutt.SetActive(false);
        yellowcoin.SetActive(true);
        yellowoffer.SetActive(false);
    }

    public void onclickofferbutt()
    {
        coinsbutt.SetActive(false);
        offerbutt.SetActive(true);
        yellowcoin.SetActive(false);
        yellowoffer.SetActive(true);
    }

    public void back ()
    {
        modespanel.SetActive(false);
    }

    public void levelsback()
    {
        modespanel.SetActive(true);
        levelpanel1.SetActive(false);
        levelpanel2.SetActive(false);
        levelpanel3.SetActive(false);
    }
    public void onclickshop()
    {
        shoppanel.SetActive(true);
    }
  
    public void onclickpowerups()
    {
        powerupspanel.SetActive(true);
    }
    public void onclickshopback()
    {
        shoppanel.SetActive(false);
    }
    public void onclickcharacterback()
    {
        characterpanel.SetActive(false);
    }
    public void onclickpowerupsbhack()
    {
        powerupspanel.SetActive(false);
    }
    public void SetCurrentLevel(int levelNo)
    {
        if (PlayerPrefs.GetInt("CurrentEnv")==0)
        {
            PlayerPrefs.SetInt("CurrentLevel", levelNo);
            loading.SetActive(true);
            levelpanel1.SetActive(false);
            Invoke("desert", 2.0f);
        }
      else if (PlayerPrefs.GetInt("CurrentEnv") == 1)
        {
            PlayerPrefs.SetInt("CurrentLevel", levelNo);
            loading.SetActive(true);
            levelpanel2.SetActive(false);
            Invoke("snow", 2.0f);
        }
        else if (PlayerPrefs.GetInt("CurrentEnv") == 2)
        {
            PlayerPrefs.SetInt("CurrentLevel", levelNo);
            loading.SetActive(true);
            levelpanel3.SetActive(false);
            Invoke("seaport", 2.0f);
            
        }


    }
    public void onclickdesert()
    {
        PlayerPrefs.SetInt("CurrentEnv", 0);
        modespanel.SetActive(false);
        levelpanel1.SetActive(true);
       
       
    }
    public void onclicksnow()
    {
        PlayerPrefs.SetInt("CurrentEnv", 1);
        modespanel.SetActive(false);
        levelpanel2.SetActive(true);
       
    }
    public void onclickseaport()
    {
        PlayerPrefs.SetInt("CurrentEnv", 2);
        modespanel.SetActive(false);
        levelpanel3.SetActive(true);
       
    }

    void desert()
    {
        SceneManager.LoadScene(3);
    }
    void snow()
    {
        SceneManager.LoadScene(4);
    }
    void seaport()
    {
        SceneManager.LoadScene(3);
    }

}

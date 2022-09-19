using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


[System.Serializable]
public class Cars
{
    public string CarName;
    public Transform Car;
    public Sprite CarProperties;
    public int carPrice;
    public bool isPurchased = false;
   

}
public class CarSelection : MonoBehaviour
{
    public static CarSelection instance;
    public Transform point1, point2;
   
    public  Image carProperties;
    public Text CarPrice;
    public Cars[] myCars;
    public bool isCarMove = false;
    public int SeclectedCarIndex=0;
    public Button buy, select;
    public Text TotalCash;
    public GameObject notEnoughCash;
    int carIndex = 0;
    private void Awake()
    {
        instance = this;
      /// PlayerPrefs.DeleteAll();
    }
    // Start is called before the first frame update
    void Start()
    {
       
        PlayerPrefs.SetInt("PurchasedCar" + 0, 1);
        SelectCar(0);
       // PlayerPrefs.SetInt("TotalCash", 50000);
        TotalCash.text = PlayerPrefs.GetInt("gems").ToString();
       
    }

    // Update is called once per frame
    void Update()
    {
       
        if (isCarMove)
        {
         //   myCars[SeclectedCarIndex].Car.transform.position = Vector3.Lerp(myCars[SeclectedCarIndex].Car.transform.position, point2.transform.position, 5 * Time.deltaTime);
            
        }
       
       
    }
    public void NextCar()
    {
        if (carIndex < myCars.Length-1)
        {
            carIndex += 1;
            SelectCar(carIndex);
            print("car Index"+carIndex);
           
        }
        else
        {
            carIndex = 0;
            SelectCar(carIndex);
        }
    }
    public void PrevCar()
    {
        if (carIndex >0)
        {
            carIndex -= 1;
            print("carIndex" + carIndex);
            SelectCar(carIndex);
           
        }
        else
        {
             carIndex = myCars.Length-1;
            SelectCar(carIndex);
        }
    }
    public void SelectCar(int index)
    {
        isCarMove = true;
        SeclectedCarIndex = index;
        for (int i = 0; i < myCars.Length; i++)
        {
            if (i == index )
            {
                myCars[i].Car.gameObject.SetActive(true);
               // myCars[i].Car.rotation = Quaternion.Euler(0,180,0); 
               
            }
            else
            {
                myCars[i].Car.gameObject.SetActive(false);
               // myCars[i].Car.position = new Vector3(myCars[i].Car.position.x,1.5f, myCars[i].Car.position.z);
              //  myCars[i].Car.rotation = Quaternion.Euler(0, 180, 0);
              
            }
        }

        CarPurChaseCheck();
    }
  
    public void CarPurChaseCheck()
    {
        if (PlayerPrefs.GetInt("PurchasedCar"+SeclectedCarIndex)==1)
        {
            select.interactable = true;
            buy.interactable = false;
            carProperties.sprite = myCars[SeclectedCarIndex].CarProperties;
            CarPrice.text = "Ready";
        }
        else
        {
            select.interactable = false;
            buy.interactable = true;
            carProperties.sprite = myCars[SeclectedCarIndex].CarProperties;
            CarPrice.text = myCars[SeclectedCarIndex].carPrice.ToString();
        }
        
    }
    public void CarMove()
    {
        isCarMove = true;
    }
    public void PurchaseCar()
    {
        if (myCars[SeclectedCarIndex].carPrice <= PlayerPrefs.GetInt("gems"))
        {
            print("Purchase");
            PlayerPrefs.SetInt("gems", PlayerPrefs.GetInt("gems", 0) - myCars[SeclectedCarIndex].carPrice);
            PlayerPrefs.SetInt("PurchasedCar"+SeclectedCarIndex, 1);
            myCars[SeclectedCarIndex].isPurchased = true;
            TotalCash.text = PlayerPrefs.GetInt("gems", 0).ToString();
            CarPurChaseCheck();
        }
        else
        {
            notEnoughCash.SetActive(true);
            Invoke("HideNoEnoughCash", 2);
        }
    }
    void HideNoEnoughCash()
    {
        notEnoughCash.SetActive(false);
        CancelInvoke("HideNoEnoughCash");
    }
    public void SelectedCar()
    {
        PlayerPrefs.SetInt("SelectedCar", SeclectedCarIndex);

    }
   
    public void AfterPurchse_UnlockAllCars()
    {
        for (int i = 0; i < 5; i++)
        {
            PlayerPrefs.SetInt("PurchasedCar" + i, 1);
        }
        CarPurChaseCheck();
    }
   
    public void After_WatchVideo()
    {
        PlayerPrefs.SetInt("coin", 1);
        PlayerPrefs.SetInt("gems", PlayerPrefs.GetInt("gems", 0) +500);
        TotalCash.text = PlayerPrefs.GetInt("gems", 0).ToString();
    }


}

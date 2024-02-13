using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour
{

    public Box first;
    public Box second;

    private Camera mainCamera;

    // Start is called before the first frame update
    void Start()
    {
        mainCamera = Camera.main;
    }

    // Update is called once per frame
    void Update()
    {
        HandleTouch();
    }

    private void HandleTouch()
    {
        if(Input.touchCount <= 0)
        {
            return;
        }

        Touch touch = Input.GetTouch(0);

        Ray ray = mainCamera.ScreenPointToRay(new Vector3(touch.position.x,touch.position.y,0));

        if (Physics.Raycast(ray,out var hit,float.MaxValue))
        {

            if (touch.phase == TouchPhase.Began)
            {

                if (hit.transform.TryGetComponent(out Box clickedBox))
                {

                    //print("Clicked on " + box.gameObject.name);

                    if(first is null && clickedBox.items.Count > 0)
                    {
                        first = clickedBox;
                        second = null;

                        first.Highlight();

                    }else if(first is not null && second is null && first != clickedBox)
                    {
                        second = clickedBox;
                        first.SendHighlightListTo(second);

                        first = null;
                        second = null;
                    }
                }
                else
                {
                    if(first is not null)
                    {
                        first.ResetHighlight();
                        first = null;
                        second = null;
                    }
                }

            }

        }


    }

}

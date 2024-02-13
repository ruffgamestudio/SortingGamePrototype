using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class Box : MonoBehaviour
{

    public List<Transform> slots;
    public List<Item> items;
    public Dictionary<Transform, Item> slotItemMap = new Dictionary<Transform, Item>();
    public List<Item> highlightList;
    public List<Transform> emptySlots;

    public bool active;

    private BoxCollider boxCollider;

    private Box target;

    public List<Box> inactiveBoxQueue;

    public int lockCount;

    private void Awake()
    {
        slots = new List<Transform>();
        emptySlots = new List<Transform>();
        items = new List<Item>();

        for (int i=0;i<transform.childCount;i++)
        {
            Transform child = transform.GetChild(i);

            if (child.CompareTag("Slot"))
            {
                slots.Add(child);

                if (child.childCount > 0)
                {
                    Item item = child.GetChild(0).GetComponent<Item>();
                    item.transform.localPosition = Vector3.zero;
                    items.Add(item);
                    slotItemMap.TryAdd(child, item);
                }
                else
                {
                    emptySlots.Add(child);
                }

            }

        }

        boxCollider = GetComponent<BoxCollider>();

        string layerName = "Default";

        if (active)
        {
            layerName = "LightOn";
        }
        else
        {
            boxCollider.enabled = false;
        }
        

        SetLayer(layerName);


    }

    public ItemType MostRightItemType()
    {
        return items[^1].itemType;
    }

    public void SetLayer(string layerName)
    {
        int l = LayerMask.NameToLayer(layerName);

        gameObject.layer = l;

        for (int i = 0; i < transform.childCount; i++)
        {
            Transform child = transform.GetChild(i);

            child.gameObject.layer = l;

        }

        foreach (var i in items)
        {

            i.gameObject.layer = l;

        }

    }

    public void Highlight()
    {

        if (items.Count == 0) { return; }

        ItemType mostRightType = items[^1].itemType;

        highlightList = new List<Item>(items.FindAll(i=>i.itemType == mostRightType));
        highlightList.Reverse();

        float delayCounter = 0;

        foreach (var i in highlightList)
        {

            i.transform.DOMoveY(i.transform.position.y + 0.25f,0.5f).SetEase(Ease.OutBack).SetDelay(delayCounter);
            delayCounter += 0.1f;

        }


    }

    public void ResetHighlight()
    {
        float delayCounter = 0;

        foreach (var i in highlightList)
        {

            i.transform.DOLocalMoveY(0, 0.5f).SetEase(Ease.OutBack).SetDelay(delayCounter);
            delayCounter += 0.1f;

        }

        highlightList.Clear();
    }

    public void SendHighlightListTo(Box target)
    {
        if (!target.active) return;

        if(highlightList.Count == 0) { return; }

        if (target.items.Count > 0 && target.MostRightItemType() != highlightList[0].itemType)
        {
            ResetHighlight();
            return;
        }

        this.target = target;

        float delayCounter = 0;

        List<Item> temp = new List<Item>(highlightList);

        target.boxCollider.enabled = false;

        foreach (var item in temp)
        {
            if (target.AreThereAnyEmptySlot())
            {
                Transform targetSlot = target.GetEmptySlot();
                item.transform.parent = targetSlot;
                target.items.Add(item);
                items.Remove(item);
                highlightList.Remove(item);

                item.transform.DOLocalJump(Vector3.zero,2,1,0.5f).SetEase(Ease.InOutSine).SetDelay(delayCounter).OnComplete(()=>
                {
                    item.transform.localPosition = Vector3.zero;
                });
                delayCounter += 0.1f;

            }
            else
            {
                ResetHighlight();
                break;
            }


        }


        UpdateEmptySlots();
        Invoke(nameof(CheckBoom),delayCounter + 0.5f);


    }

    private void CheckBoom()
    {

        EnableCollider();

        ItemType type = target.items[0].itemType;

        if (target.items.FindAll(i=>i.itemType == type).Count == 4)
        {

            print("Boom");

            var targetItems = new List<Item>(target.items);

            target.items.Clear();
            target.emptySlots = new List<Transform>(target.slots);

            foreach (var item in targetItems)
            {
                item.transform.parent = null;
                item.transform.DOPunchScale(Vector3.one / 4,0.25f).OnComplete(()=> {
                    Destroy(item.gameObject);
                });
            }


            Invoke(nameof(ActivateABoxInvoker),0.3f);

        }
        else
        {
            target = null;
        }


        


    }

    private void ActivateABoxInvoker()
    {
        target.ActivateABox();

        target.transform.DOScale(Vector3.zero,0.25f).OnComplete(()=> {

            Destroy(target.gameObject);
            target = null;

        });

        if (emptySlots.Count == slots.Count)
        {
            transform.DOScale(Vector3.zero, 0.25f).OnComplete(() => {
                Destroyer();
                ActivateABox();

            });


        }


    }

    private void EnableCollider()
    {
        target.boxCollider.enabled = true;
    }

    public Transform GetEmptySlot()
    {
        Transform slot = emptySlots[0];
        emptySlots.Remove(slot);
        return slot;
    }

    public bool AreThereAnyEmptySlot()
    {
        return emptySlots.Count > 0;
    }

    private void UpdateEmptySlots()
    {
        emptySlots = new List<Transform>();
        foreach (var slot in slots)
        {
            if (slot.childCount == 0)
            {
                emptySlots.Add(slot);
            }
        }

    }

    private void Destroyer()
    {
        Destroy(gameObject);
    }

    private void ActivateABox()
    {

        if (inactiveBoxQueue.Count == 0 || !active) return;

        foreach (var box in inactiveBoxQueue)
        {
            box.lockCount--;
        }

        var inactives = new List<Box>(inactiveBoxQueue);

        foreach (var box in inactives)
        {
            if(box.lockCount == 0)
            {

                inactiveBoxQueue.Remove(box);

                box.SetLayer("LightOn");
                box.active = true;
                box.boxCollider.enabled = true;
                box.transform.DOMoveZ(0, 0.25f);
            }
        }


       

    }

}

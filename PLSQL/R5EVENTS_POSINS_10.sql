DECLARE
    vWoCode       r5events.evt_code%TYPE;
    vEquipCode    r5events.evt_object%TYPE;
    vWoOrg        r5events.evt_org%TYPE;
    vEvtObjectOrg r5events.evt_object_org%TYPE;
    vPriority     r5events.evt_priority%TYPE;
    vType         r5events.evt_jobtype%TYPE;

    vBCG          r5objects.obj_criticality%TYPE;

BEGIN

    SELECT evt_code,
           evt_object,
           evt_org,
           evt_object_org,
           evt_priority,
           evt_jobtype
      INTO vWoCode,
           vEquipCode,
           vWoOrg,
           vEvtObjectOrg,
           vPriority,
           vType
      FROM r5events
     WHERE rowid = :ROWID;

    SELECT obj_criticality
      INTO vBCG
      FROM r5objects
     WHERE obj_code = vEquipCode
           AND obj_org = vEvtObjectOrg;

    --Raise_Application_Error(-20020,'vBCG' ||  vBCG);
    --Raise_Application_Error(-20020,'vPriority' ||  vPriority);

    IF vType = 'BRKD' THEN

      IF vBCG <> vPriority  THEN
      --Raise_Application_Error(-20020,'updating...!!');
        UPDATE r5events
          SET evt_priority = vBCG
        WHERE evt_code = vWoCode
              AND evt_object = evt_object
              AND evt_org = vWoOrg
              AND evt_object_org = vEvtObjectOrg
              AND evt_priority <> vBCG;
      END IF;

      IF (vBCG IS NOT NULL) AND (vPriority IS NULL) THEN 
        UPDATE r5events
          SET evt_priority = vBCG
        WHERE evt_code = vWoCode
              AND evt_object = evt_object
              AND evt_org = vWoOrg
              AND evt_object_org = vEvtObjectOrg;
      END IF;

    END IF;

END;
DECLARE
    vWoCode       r5events.evt_code%TYPE;
    vEquipCode    r5events.evt_object%TYPE;
    vWoOrg        r5events.evt_org%TYPE;
    vWoStatus     r5events.evt_status%TYPE;
    vChgRsn        r5events.evt_udfchar04%TYPE;

BEGIN
    SELECT  evt_code,
            evt_object,
            evt_org,
            evt_status,
            evt_udfchar04
    INTO    vWoCode,
            vEquipCode,
            vWoOrg,
            vWoStatus,
            vChgRsn
    FROM    r5events
    WHERE   rowid = :ROWID;

    IF (vWoStatus = 'EXTN'
        AND vChgRsn IS NULL) THEN
        Raise_Application_Error(-20020,
        'Please enter Extension Reason'
    );
    END IF;    
END;




CREATE OR REPLACE PACKAGE BODY "XXEV_APEX"."XXTEST_RMS_REQUESTS_PKG" AS

    PROCEDURE request_is_inserted is
        l_ws_id         NUMBER;
        l_app_id        NUMBER := 100;
        l_session_id    NUMBER := apex_custom_auth.get_next_session_id;
        l_seq           NUMBER;
        l_req_title     VARCHAR2(100);
        l_count         NUMBER;

    BEGIN
        --First we create an APEX session
        SELECT workspace_id 
          INTO l_ws_id 
          FROM apex_workspaces;

        wwv_flow_api.set_security_group_id(l_ws_id);
        wwv_flow.g_flow_id := l_app_id;
        wwv_flow.g_instance := l_session_id;

        apex_custom_auth.post_login(p_uname      => 'XXEV_APEX'
                                   ,p_session_id => l_session_id
                                   ,p_app_page   => '100:1');      

        --Then we create the collection
        IF NOT apex_collection.collection_exists(p_collection_name => 'RESOURCE_REQUEST') THEN
            apex_collection.create_collection (p_collection_name => 'RESOURCE_REQUEST');
        END IF;

        --Now we populate the collection
        l_req_title := 'UNIT TEST - '||TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS');
        l_seq := apex_collection.add_member(p_collection_name => 'RESOURCE_REQUEST'
                                           ,p_c001            => l_req_title
                                           ,p_c002            => 'CAAS'
                                           ,p_c003            => 'N');

        --Afterwards, we invoke the request creation function
        xx_rms_requests_pkg.create_request;

        --Finally, we delete the collection
        apex_collection.delete_collection (p_collection_name => 'RESOURCE_REQUEST');

        --We check if the request is created
        SELECT COUNT(*)
          INTO l_count
          FROM xx_rms_requests xrr
         WHERE     1 = 1
               AND xrr.request_title = l_req_title;
        ROLLBACK;

        ut.expect(l_count).to_equal(1);
    END request_is_inserted;

    PROCEDURE request_has_correct_mapping IS
        l_ws_id         NUMBER;
        l_app_id        NUMBER := 100;
        l_session_id    NUMBER := apex_custom_auth.get_next_session_id;
        l_seq           NUMBER;
        l_req_title     VARCHAR2(100);
        l_count         NUMBER;
    BEGIN
        --First we create an APEX session
        SELECT workspace_id 
          INTO l_ws_id 
          FROM apex_workspaces;

        wwv_flow_api.set_security_group_id(l_ws_id);
        wwv_flow.g_flow_id := l_app_id;
        wwv_flow.g_instance := l_session_id;

        apex_custom_auth.post_login(p_uname      => 'XXEV_APEX'
                                   ,p_session_id => l_session_id
                                   ,p_app_page   => '100:1');      

        --Then we create the collection
        IF NOT apex_collection.collection_exists(p_collection_name => 'RESOURCE_REQUEST') THEN
            apex_collection.create_collection (p_collection_name => 'RESOURCE_REQUEST');
        END IF;

        --Now we populate the collection
        l_req_title := 'UNIT TEST - '||TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS');
        l_seq := apex_collection.add_member(p_collection_name => 'RESOURCE_REQUEST'
                                           ,p_c001            => l_req_title
                                           ,p_c002            => 'CAAS'
                                           ,p_c003            => 'N');

        --Afterwards, we invoke the request creation function
        xx_rms_requests_pkg.create_request;

        --Finally, we delete the collection
        apex_collection.delete_collection (p_collection_name => 'RESOURCE_REQUEST');

        --We check if the request is created
        SELECT COUNT(*)
          INTO l_count
          FROM xx_rms_requests xrr
         WHERE     1 = 1
               AND xrr.request_title = l_req_title
               AND xrr.resource_type = 'CAAS'
               AND xrr.billable_flag = 'N';
        ROLLBACK;

        ut.expect(l_count).to_equal(1);
    END request_has_correct_mapping;

END xxtest_rms_requests_pkg;

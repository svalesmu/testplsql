CREATE OR REPLACE PACKAGE "XXEV_APEX"."XXTEST_RMS_REQUESTS_PKG" AS

  --%suite(Requests Creation Process)

  --%test(Request is inserted in the XX_RMS_REQUESTS table)
  PROCEDURE request_is_inserted;

  --%test(Created Request has correct field mapping)
  PROCEDURE request_has_correct_mapping;

END xxtest_rms_requests_pkg;

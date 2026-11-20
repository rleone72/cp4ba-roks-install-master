# Oracle to DB2 Database Scripts Conversion Documentation

## Overview

This document describes the conversion of IBM Cloud Pak for Business Automation (CP4BA) database scripts from Oracle to DB2 format for the DRVRHOS environment.

## Converted Files

| Original Oracle File | Converted DB2 File | Description | Schemas |
|---------------------|-------------------|-------------|---------|
| AAE.sql | AAE_DB2.sql | Application Engine Object Store | M_AAE01 |
| BAS.sql | BAS_DB2.sql | Business Automation Studio | M_BAS01 |
| BAWDOCS.sql | BAWDOCS_DB2.sql | BAW Document Object Store | M_BAWDOC01 |
| FNP8.sql | FNP8_DB2.sql | FileNet P8 Components | M_FNGCD, M_FNOS01, M_ICNCFG01, M_ICMCHS01 |

## Key Conversion Changes

### 1. Tablespace Creation

**Oracle Syntax:**
```sql
CREATE BIGFILE TABLESPACE "TS_AAE01_DATA"
DATAFILE SIZE 200M AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED
LOGGING
EXTENT MANAGEMENT LOCAL
SEGMENT SPACE MANAGEMENT AUTO
```

**DB2 Syntax:**
```sql
CREATE TABLESPACE TS_AAE01_DATA
    PAGESIZE 32 K
    MANAGED BY AUTOMATIC STORAGE
    EXTENTSIZE 32
    PREFETCHSIZE 32
    BUFFERPOOL IBMDEFAULTBP;
```

**Changes:**
- Removed `BIGFILE` keyword (not used in DB2)
- Replaced manual size management with `MANAGED BY AUTOMATIC STORAGE`
- Added `PAGESIZE 32 K` for optimal performance
- Added `EXTENTSIZE` and `PREFETCHSIZE` parameters
- Specified `BUFFERPOOL` (using default, can be customized)
- Removed Oracle-specific `EXTENT MANAGEMENT` and `SEGMENT SPACE MANAGEMENT`

### 2. Temporary Tablespace Creation

**Oracle Syntax:**
```sql
CREATE BIGFILE TEMPORARY TABLESPACE TS_AAE01_TEMP
TEMPFILE SIZE 1G AUTOEXTEND ON NEXT 1G MAXSIZE UNLIMITED
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1048576;
```

**DB2 Syntax:**
```sql
CREATE USER TEMPORARY TABLESPACE TS_AAE01_TEMP
    PAGESIZE 32 K
    MANAGED BY AUTOMATIC STORAGE
    EXTENTSIZE 32
    PREFETCHSIZE 32
    BUFFERPOOL IBMDEFAULTBP;
```

**Changes:**
- Changed to `CREATE USER TEMPORARY TABLESPACE`
- Removed manual size specifications
- Uses automatic storage management

### 3. User/Schema Creation

**Oracle Syntax:**
```sql
CREATE USER M_AAE01
IDENTIFIED BY REPLACE_WITH_PASSWORT
DEFAULT TABLESPACE TS_AAE01_DATA
TEMPORARY TABLESPACE TS_AAE01_TEMP
PROFILE M_USER
ACCOUNT UNLOCK;
```

**DB2 Syntax:**
```sql
CREATE USER M_AAE01 USING 'REPLACE_WITH_PASSWORD';
```

**Changes:**
- Simplified syntax: `CREATE USER ... USING`
- Removed `PROFILE` (not applicable in DB2)
- Removed `ACCOUNT UNLOCK` (DB2 accounts are unlocked by default)
- Tablespace assignment done via `GRANT USE OF TABLESPACE`

### 4. Tablespace Quota

**Oracle Syntax:**
```sql
ALTER USER M_AAE01 QUOTA UNLIMITED ON TS_AAE01_DATA;
```

**DB2 Syntax:**
```sql
GRANT USE OF TABLESPACE TS_AAE01_DATA TO USER M_AAE01;
```

**Changes:**
- DB2 uses `GRANT USE OF TABLESPACE` instead of quota management
- No size limits specified (managed by automatic storage)

### 5. System Privileges

**Oracle Privileges (Removed):**
```sql
grant SELECT on sys.pending_trans$ to M_AAE01;
grant SELECT on sys.dba_2pc_pending to M_AAE01;
grant SELECT on sys.dba_pending_transactions to M_AAE01;
grant SELECT on sys.product_component_version to M_AAE01;
grant EXECUTE on dbms_xa to M_AAE01;
```

**DB2 Privileges (Added):**
```sql
GRANT CONNECT ON DATABASE TO USER M_AAE01;
GRANT CREATETAB ON DATABASE TO USER M_AAE01;
GRANT CREATE_NOT_FENCED ON DATABASE TO USER M_AAE01;
GRANT IMPLICIT_SCHEMA ON DATABASE TO USER M_AAE01;
GRANT LOAD ON DATABASE TO USER M_AAE01;
GRANT CREATE_EXTERNAL_ROUTINE ON DATABASE TO USER M_AAE01;
GRANT QUIESCE_CONNECT ON DATABASE TO USER M_AAE01;
GRANT DBADM ON DATABASE TO USER M_AAE01;
```

**Changes:**
- Removed Oracle-specific system table grants (not needed in DB2)
- Removed XA grants (XA support is built into DB2)
- Added DB2-specific database-level privileges
- `DBADM` provides full administrative control (equivalent to Oracle's DBA role)

### 6. Role Management

**Oracle Syntax:**
```sql
grant m_allg to M_AAE01;
ALTER USER M_AAE01 DEFAULT ROLE ALL;
```

**DB2 Approach:**
- DB2 handles privileges directly without explicit role activation
- All granted privileges are automatically available
- No need for `DEFAULT ROLE` statement

### 7. Statement Terminators

**Oracle:** Uses `/` as statement terminator for DDL
**DB2:** Uses `;` (semicolon) as standard statement terminator

### 8. Schema Authority

**DB2 Addition:**
```sql
UPDATE SYSIBM.SYSDBAUTH SET SCHEMAAUTH = 'Y' WHERE GRANTEE = 'M_AAE01';
```

This grants schema creation authority to the user.

## Database Structure Summary

### AAE_DB2.sql - Application Engine Object Store
- **Schema:** M_AAE01
- **Tablespaces:** 
  - TS_AAE01_DATA (data)
  - TS_AAE01_TEMP (temporary)

### BAS_DB2.sql - Business Automation Studio
- **Schema:** M_BAS01
- **Tablespaces:**
  - TS_BAS01_DATA (data)
  - TS_BAS01_TEMP (temporary)
- **Special Note:** Includes lock management privileges

### BAWDOCS_DB2.sql - BAW Document Object Store
- **Schema:** M_BAWDOC01
- **Tablespaces:**
  - TS_BAWDOC01_DATA (data)
  - TS_BAWDOC01_INDEX (indexes)
  - TS_BAWDOC01_LOB (large objects)
  - TS_BAWDOC01_TEMP (temporary)

### FNP8_DB2.sql - FileNet P8 Components (4 Databases)

#### 1. M_FNGCD - Global Configuration Database
- **Tablespaces:**
  - TS_FNGCD_DATA (data)
  - TS_FNGCD_TEMP (temporary)

#### 2. M_FNOS01 - Object Store
- **Tablespaces:**
  - TS_FNOS01_DATA (data)
  - TS_FNOS01_INDEX (indexes)
  - TS_FNOS01_LOB (large objects)
  - TS_FNOS01VW_DATA (view data)
  - TS_FNOS01VW_INDEX (view indexes)
  - TS_FNOS01VW_LOB (view large objects)
  - TS_FNOS01_TEMP (temporary)

#### 3. M_ICNCFG01 - Content Navigator Configuration Database
- **Tablespaces:**
  - TS_ICNCFG01_DATA (data)
  - TS_ICNCFG01_TEMP (temporary)

#### 4. M_ICMCHS01 - Case History Store
- **Tablespaces:**
  - TS_ICMCHS01_DATA (data)
  - TS_ICMCHS01_INDEX (indexes)
  - TS_ICMCHS01_LOB (large objects)
  - TS_ICMCHS01_TEMP (temporary)

## Implementation Notes

### Before Running Scripts

1. **Database Connection:** Uncomment and update the `CONNECT TO DBNAME;` statement with your actual database name
2. **Passwords:** Replace all `REPLACE_WITH_PASSWORD` placeholders with actual secure passwords
3. **User Creation:** Ensure users exist at OS level or in your authentication system (LDAP/AD)
4. **Permissions:** Run scripts with appropriate DB2 administrative privileges

### Performance Tuning Considerations

1. **Page Size:** Default is 32K, suitable for most CP4BA workloads
   - Consider 8K for smaller tables
   - Consider 32K for tables with large rows or LOBs

2. **Buffer Pools:** Scripts use `IBMDEFAULTBP`
   - For production, create dedicated buffer pools for better performance
   - Example: Create separate buffer pools for data, index, and LOB tablespaces

3. **Automatic Storage:** DB2 manages space automatically
   - Ensure sufficient disk space in storage paths
   - Monitor storage growth and adjust as needed

4. **Extent Size:** Set to 32 pages
   - Adjust based on table size and growth patterns
   - Larger extent sizes reduce fragmentation for large tables

### Security Considerations

1. **DBADM Authority:** Scripts grant full administrative control
   - Review and adjust based on security requirements
   - Consider using more restrictive privileges for production

2. **Password Management:** 
   - Use strong passwords
   - Store passwords securely (vault, encrypted configuration)
   - Rotate passwords regularly

3. **User Authentication:**
   - Integrate with enterprise authentication (LDAP/AD)
   - Implement proper access controls

## Differences from Oracle

| Feature | Oracle | DB2 |
|---------|--------|-----|
| Storage Management | Manual (DATAFILE, SIZE, AUTOEXTEND) | Automatic (MANAGED BY AUTOMATIC STORAGE) |
| Tablespace Types | BIGFILE/SMALLFILE | Regular/Large |
| User Profiles | Supported | Not applicable |
| XA Transactions | Requires explicit grants | Built-in support |
| System Tables | sys.* tables | SYSIBM.* tables |
| Role Management | Explicit role activation | Automatic privilege availability |
| Statement Terminator | `/` for DDL | `;` for all statements |

## Testing Recommendations

1. **Verify Tablespace Creation:**
   ```sql
   SELECT TBSPACE, TBSPACETYPE, PAGESIZE, DATATYPE 
   FROM SYSCAT.TABLESPACES 
   WHERE TBSPACE LIKE 'TS_%';
   ```

2. **Verify User Privileges:**
   ```sql
   SELECT * FROM SYSCAT.DBAUTH WHERE GRANTEE = 'M_AAE01';
   ```

3. **Test Connectivity:**
   - Connect as each user
   - Create test tables
   - Verify tablespace usage

4. **Performance Testing:**
   - Monitor buffer pool hit ratios
   - Check tablespace utilization
   - Analyze query performance

## Troubleshooting

### Common Issues

1. **User Already Exists:**
   - Drop and recreate: `DROP USER M_AAE01;`
   - Or use existing user and just grant privileges

2. **Tablespace Already Exists:**
   - Drop and recreate: `DROP TABLESPACE TS_AAE01_DATA;`
   - Or skip creation and proceed with grants

3. **Insufficient Privileges:**
   - Ensure you're connected with SYSADM or DBADM authority
   - Check database configuration parameters

4. **Storage Issues:**
   - Verify automatic storage paths: `SELECT * FROM SYSCAT.STOGROUPS;`
   - Ensure sufficient disk space

## References

- [IBM FileNet P8 Platform Documentation](https://www.ibm.com/docs/en/filenet-p8-platform/5.5.11)
- [IBM Cloud Pak for Business Automation Documentation](https://www.ibm.com/docs/en/cloud-paks/cp-biz-automation/23.0.2)
- [DB2 Database Administration Guide](https://www.ibm.com/docs/en/db2/11.5)

## Version History

| Date | Version | Changes |
|------|---------|---------|
| 2026-02-27 | 1.0 | Initial conversion from Oracle to DB2 |

---

**Note:** This conversion was performed for the DRVRHOS environment. Adjust configurations based on your specific requirements and environment.
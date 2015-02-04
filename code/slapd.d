dn: cn=config
objectClass: olcGlobal
cn: config
olcConfigFile: slapd.conf
olcConfigDir: slapd.d
olcArgsFile: /var/run/openldap/slapd.args
olcAttributeOptions: lang-
olcAuthzPolicy: none
olcConcurrency: 0
olcConnMaxPending: 100
olcConnMaxPendingAuth: 1000
olcGentleHUP: FALSE
olcIdleTimeout: 0
olcIndexSubstrIfMaxLen: 4
olcIndexSubstrIfMinLen: 2
olcIndexSubstrAnyLen: 4
olcIndexSubstrAnyStep: 2
olcIndexIntLen: 4
olcLocalSSF: 71
olcLogLevel: Stats
olcPidFile: /var/run/openldap/slapd.pid
olcReadOnly: FALSE
olcSaslSecProps: noplain,noanonymous
olcServerID: 2
olcSockbufMaxIncoming: 262143
olcSockbufMaxIncomingAuth: 16777215
olcThreads: 16
olcTLSCACertificateFile: /usr/local/etc/ssl/star.servers.domain.com.pem
olcTLSCertificateFile: /usr/local/etc/ssl/star.servers.domain.com.pem
olcTLSCertificateKeyFile: /usr/local/etc/ssl/star.servers.domain.com.pem
olcTLSCipherSuite: HIGH:MEDIUM:-SSLv2
olcTLSCRLCheck: none
olcTLSVerifyClient: never
olcToolThreads: 1
olcWriteTimeout: 0


dn: cn={5}aixclient,cn=schema,cn=config
objectClass: olcSchemaConfig
cn: {5}aixclient

olcAttributeTypes: {0}( 1.3.18.0.2.4.810 NAME 'adminGroupNames' DESC 'list of groups a user adminstrates' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {1}( 1.3.18.0.2.4.756 NAME 'AIXAdminGroupId' DESC 'AIX new admin group id storage' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {2}( 1.3.18.0.2.4.776 NAME 'AIXAdminUserId' DESC 'AIX new admin user id storage' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {3}( 1.3.18.0.2.4.793 NAME 'AIXDefaultMACLevel' DESC 'AIX default level mac' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {4}( 1.3.18.0.2.4.766 NAME 'AIXFuncMode' DESC 'AIX smit aclfunction modes' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {5}( 1.3.18.0.2.4.768 NAME 'AIXGroupAdminList' DESC 'list of administrators' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )

olcAttributeTypes: {6}( 1.3.18.0.2.4.782 NAME 'AIXGroupID' DESC 'AIX new group id storage' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {7}( 1.3.18.0.2.4.797 NAME 'AIXisDCEExport' DESC 'DCE integration flag' SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )

olcAttributeTypes: {8}( 1.3.18.0.2.4.778 NAME 'AIXLowMACLevel' DESC 'AIX low level mac' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {9}( 1.3.18.0.2.4.777 NAME 'AIXPromptMAC' DESC 'prompt MAC, Mandatory Access Control, or not' SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )

olcAttributeTypes: {10}( 1.3.18.0.2.4.752 NAME 'AIXScreens' DESC 'AIX  SMIT screen access list' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {11}( 1.3.18.0.2.4.746 NAME 'AIXUpperMACLevel' DESC 'AIX upper level mac' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {12}( 1.3.18.0.2.4.770 NAME 'AIXUserID' DESC 'Aix new user id storage attribute' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {13}( 1.2.840.113556.1.4.867 NAME 'altSecurityIdentities' DESC 'Alternate security identities.  A Kerberos identity must be defined in the format kerberos:<principal>@<realm>; for example, kerberos:alice@austin.ibm.com.  This attribute is defined on Active Directory.' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )

olcAttributeTypes: {14}( 1.3.18.0.2.4.812 NAME 'auditClasses' DESC 'classes, events, a user will be audited on' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {15}( 1.3.18.0.2.4.762 NAME 'authMethod1' DESC 'the primary method for authenticating a user' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {16}( 1.3.18.0.2.4.780 NAME 'authMethod2' DESC 'secondary method for authenticating a user' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {17}( 1.3.18.0.2.4.755 NAME 'authorizationLevel' DESC 'authorization level associated with a role' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {18}( 1.3.18.0.2.4.145 NAME 'capability' DESC 'Indicates the capabilities this GSO Target Service Type allows.' SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )

olcAttributeTypes: {19}( 1.3.18.0.2.4.751 NAME 'coreSizeLimit' DESC 'core filesize limit' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {20}( 1.3.18.0.2.4.798 NAME 'coreSizeLimitHard' DESC 'hard core file size limit' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {21}( 1.3.18.0.2.4.805 NAME 'cpuSize' DESC 'limit of system units a process can use' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {22}( 1.3.18.0.2.4.789 NAME 'cpuSizeHard' DESC 'largest amount of system time process can use' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {23}( 1.3.18.0.2.4.763 NAME 'dataSegSize' DESC 'size for data segment' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {24}( 1.3.18.0.2.4.758 NAME 'dataSegSizeHard' DESC 'largest size of data segment' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {25}( 1.3.18.0.2.4.757 NAME 'filePermMask' DESC 'mask to set file permission' EQUALITY octetStringMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.40 SINGLE-VALUE )

olcAttributeTypes: {26}( 1.3.18.0.2.4.785 NAME 'fileSizeLimit' DESC 'file size limit' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {27}( 1.3.18.0.2.4.779 NAME 'fileSizeLimitHard' DESC 'file size limit' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {28}( 1.3.18.0.2.4.803 NAME 'groupList' DESC 'list of groups a user or role can belong to' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {29}( 1.3.18.0.2.4.765 NAME 'groupPassword' DESC 'Group Password' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {30}( 1.3.18.0.2.4.773 NAME 'groupSwitchUserAllowed' DESC 'list of groups that can switch user to this user' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {31}( 1.3.18.0.2.4.787 NAME 'hostLastLogin' DESC 'host name of the last successful login' SUP host EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {32}( 1.3.18.0.2.4.748 NAME 'hostLastUnsuccessfulLogin' DESC 'host name of last unsuccessful login' SUP host EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {33}( 1.3.18.0.2.4.2321 NAME 'hostsAllowedLogin' DESC 'The names or addresses of computer systems or networks to which a user is allowedto login.' EQUALITY caseIgnoreMatch ORDERING caseIgnoreOrderingMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )

olcAttributeTypes: {34}( 1.3.18.0.2.4.2322 NAME 'hostsDeniedLogin' DESC 'The names or addresses of a computer systems or networks to which a user is not allowed to login.' EQUALITY caseIgnoreMatch ORDERING caseIgnoreOrderingMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )

olcAttributeTypes: {35}( 1.3.18.0.2.4.3359 NAME 'ibm-accessAuths' DESC 'Access authorizations' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )

olcAttributeTypes: {36}( 1.3.18.0.2.4.3233 NAME 'ibm-aixAdminPolicyEntry' DESC 'Advanced accounting, admin policy rule' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )

olcAttributeTypes: {37}( 1.3.18.0.2.4.3234 NAME 'ibm-aixAdminPolicyName' DESC 'Advanced accounting, name of admin policy' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {38}( 1.3.18.0.2.4.3340 NAME 'ibm-aixpertLabel' DESC 'An unique label for a XML file' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 SINGLE-VALUE )

olcAttributeTypes: {39}( 1.3.18.0.2.4.3341 NAME 'ibm-aixpertXmlConfigFile' DESC 'Aixpert XML configuration file' SYNTAX 1.3.6.1.4.1.1466.115.121.1.5 SINGLE-VALUE )

olcAttributeTypes: {40}( 1.3.18.0.2.4.3235 NAME 'ibm-aixProjectDefinition' DESC 'Advanced accounting, project definition entry' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )

olcAttributeTypes: {41}( 1.3.18.0.2.4.3236 NAME 'ibm-aixProjectName' DESC 'Advanced accounting, name of project definition file' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {42}( 1.3.18.0.2.4.3237 NAME 'ibm-aixProjectNameList' DESC 'Advanced accounting, list of project names' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )

olcAttributeTypes: {43}( 1.3.18.0.2.4.3363 NAME 'ibm-authorizationID' DESC 'authorization numeric ID' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {44}( 1.3.18.0.2.4.3350 NAME 'ibm-authorizations' DESC 'authorization names' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )

olcAttributeTypes: {45}( 1.3.18.0.2.4.3354 NAME 'ibm-authPrivs' DESC 'Authorized privieges' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )

olcAttributeTypes: {46}( 1.3.18.0.2.4.3336 NAME 'ibm-coreCompressionEnable' DESC 'Enable or disable corefile compression' EQUALITY caseIgnoreMatch ORDERING caseIgnoreOrderingMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {47}( 1.3.18.0.2.4.3337 NAME 'ibm-coreNamingPolicy' DESC 'Specifies core file naming policy' EQUALITY caseIgnoreMatch ORDERING caseIgnoreOrderingMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {48}( 1.3.18.0.2.4.3338 NAME 'ibm-corePathEnable' DESC 'Enable or disable core file path specification.' EQUALITY caseIgnoreMatch ORDERING caseIgnoreOrderingMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {49}( 1.3.18.0.2.4.3339 NAME 'ibm-corePathName' DESC 'Specifies a location for core files' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 SINGLE-VALUE )

olcAttributeTypes: {50}( 1.3.18.0.2.4.3349 NAME 'ibm-defaultRoles' DESC 'List of default roles' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )

olcAttributeTypes: {51}( 1.3.18.0.2.4.3367 NAME 'ibm-defIntegrityLabel' DESC 'Default integrity clearance label, the effective integrity level assigned to a user' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {52}( 1.3.18.0.2.4.3372 NAME 'ibm-defSensitivityLabel' DESC 'Default sensitivity clearance label, the effective sensitivity level assigned to a user.' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {53}( 1.3.18.0.2.4.3361 NAME 'ibm-egid' DESC 'The effective group id' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {54}( 1.3.18.0.2.4.3362 NAME 'ibm-euid' DESC 'The effective user id' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {55}( 1.3.18.0.2.4.3365 NAME 'ibm-inheritPrivs' DESC 'Inheritable privileges' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )

olcAttributeTypes: {56}( 1.3.18.0.2.4.3358 NAME 'ibm-innatePrivs' DESC 'Innate privileges' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )

olcAttributeTypes: {57}( 1.3.18.0.2.4.3370 NAME 'ibm-maxIntegrityLabel' DESC 'Maximum integrity clearance label, the highest integrity level that can be assigned to a user on the system.' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {58}( 1.3.18.0.2.4.3369 NAME 'ibm-maxSensitivityLabel' DESC 'Maximum sensitivity clearance label, the highest sensitivity level that can be assigned to a user on the system.' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {59}( 1.3.18.0.2.4.3371 NAME 'ibm-minIntegrityLabel' DESC 'Minimum integrity clearance label, the lowest integrity level that can be assigned to a user on the system.' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {60}( 1.3.18.0.2.4.3368 NAME 'ibm-minSensitivityLabel' DESC 'Minimum sensitivity clearance label, the lowest sensitivity level that can be assigned to a user on the system.' EQUALITY caseIgnoreMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {61}( 1.3.18.0.2.4.3364 NAME 'ibm-msgSet' DESC 'Message set' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {62}( 1.3.18.0.2.4.3353 NAME 'ibm-readAuths' DESC 'Authorizations required to read an object' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )

olcAttributeTypes: {63}( 1.3.18.0.2.4.3356 NAME 'ibm-readPrivs' DESC 'Privileges required to read an object' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )

olcAttributeTypes: {64}( 1.3.18.0.2.4.3351 NAME 'ibm-roleAuthMode' DESC 'Authentication method for assuming a role' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 SINGLE-VALUE )

olcAttributeTypes: {65}( 1.3.18.0.2.4.3360 NAME 'ibm-roleID' DESC 'Role ID' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {66}( 1.3.18.0.2.4.3357 NAME 'ibm-secFlags' DESC 'Security flags' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )

olcAttributeTypes: {67}( 1.3.18.0.2.4.3366 NAME 'ibm-threadsPerProcess' DESC 'Maximum number of threads per process allowed' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {68}( 1.3.18.0.2.4.3352 NAME 'ibm-writeAuths' DESC 'Authorizations requried to write to an object' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )

olcAttributeTypes: {69}( 1.3.18.0.2.4.3355 NAME 'ibm-writePrivs' DESC 'Privileges required to write to an object' EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )

olcAttributeTypes: {70}( 1.3.18.0.2.4.726 NAME 'isAccountEnabled' DESC 'indicates whether users are allowed to login using an account true or not false' SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )
olcAttributeTypes: {71}( 1.3.18.0.2.4.728 NAME 'isAdministrator' DESC 'indicates whether an account has administrative authority' SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )

olcAttributeTypes: {72}( 1.3.18.0.2.4.761 NAME 'isDaemon' DESC 'AIX indicator whether a user can run programs under cron or src' SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )

olcAttributeTypes: {73}( 1.3.18.0.2.4.743 NAME 'isLoginAllowed' DESC 'indicate wheter a user can login' SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )

olcAttributeTypes: {74}( 1.3.18.0.2.4.799 NAME 'isRemoteAccessAllowed' DESC 'permits access from a remote system' SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )

olcAttributeTypes: {75}( 1.3.18.0.2.4.808 NAME 'isSwitchUserAllowed' DESC 'indicate whether a user can switch to this users account' SYNTAX 1.3.6.1.4.1.1466.115.121.1.7 SINGLE-VALUE )

olcAttributeTypes: {76}( 1.3.18.0.2.4.771 NAME 'ixTimeLastLogin' DESC 'time of users last login' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {77}( 1.3.18.0.2.4.749 NAME 'ixTimeLastUnsuccessfulLogin' DESC 'user time of last unsuccessful' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {78}( 1.3.18.0.2.4.801 NAME 'loginTimes' DESC 'valid times a user is allowed to login' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {79}( 1.3.18.0.2.4.710 NAME 'maxFailedLogins' DESC '  ' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 )

olcAttributeTypes: {80}( 1.3.18.0.2.4.807 NAME 'maxLogin' DESC 'maximum number of logins' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {81}( 1.3.18.0.2.4.332 NAME 'msgFileName' DESC 'This attribute is used to indicate a message file name which contains displayable/translatable strings for those attributes which are displayable.' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {82}( 1.3.18.0.2.4.774 NAME 'msgNumber' DESC 'index into a message catalog' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {83}( 1.3.18.0.2.4.781 NAME 'openFileLimit' DESC 'limit for number of open files' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {84}( 1.3.18.0.2.4.784 NAME 'openFileLimitHard' DESC 'maximun number of open files' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {85}( 1.3.18.0.2.4.802 NAME 'passwordChar' DESC 'password existance character' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {86}( 2.16.840.1.113730.3.1.99 NAME 'passwordMinLength' DESC 'Specifies the minimum number of characters required for a users password.' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 )

olcAttributeTypes: {87}( 1.3.18.0.2.4.458 NAME 'passwordCheckMethods' DESC 'Methods for checking passwords.' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )

olcAttributeTypes: {88}( 1.3.18.0.2.4.463 NAME 'passwordDictFiles' DESC 'Password dictionary files.' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 )

olcAttributeTypes: {89}( 1.3.18.0.2.4.485 NAME 'passwordExpireTime' DESC 'Defines, in YYYYMMDDHHMMSS format, the date and time when a user password expires.' SYNTAX 1.3.6.1.4.1.1466.115.121.1.24 )

olcAttributeTypes: {90}( 1.3.18.0.2.4.753 NAME 'passwordFlags' DESC 'password flags' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {91}( 1.3.18.0.2.4.2504 NAME 'passwordHistExpire' DESC 'defines the period of time in weeks that a user cannot reuse a password' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {92}( 1.3.18.0.2.4.1101 NAME 'passwordHistList' DESC 'list of user passwords' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {93}( 1.3.18.0.2.4.772 NAME 'passwordHistSize' DESC 'number of previous passwords that can be stored in password history' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {94}( 1.3.18.0.2.4.3396 NAME 'passwordMaxConsecutiveRepeatedChars' DESC 'Attribute used to impose the maximum number of consecutive repeated characters in the password field.' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 )

olcAttributeTypes: {95}( 1.3.18.0.2.4.454 NAME 'passwordMaxRepeatedChars' DESC '  ' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 )

olcAttributeTypes: {96}( 1.3.18.0.2.4.473 NAME 'passwordMinAlphaChars' DESC 'Specifies the minimum number of characters required for a users password.' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 )

olcAttributeTypes: {97}( 1.3.18.0.2.4.499 NAME 'passwordMinDiffChars' DESC 'Specifies the minimum number of different unique characters required for a users password.' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 )

olcAttributeTypes: {98}( 1.3.18.0.2.4.469 NAME 'passwordMinOtherChars' DESC ' ' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 )

olcAttributeTypes: {99}( 1.3.18.0.2.4.790 NAME 'physicalMemLimit' DESC 'limit for the amount fo physical memory that can be allocated' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {100}( 1.3.18.0.2.4.744 NAME 'physicalMemLimitHard' DESC 'largest amount of physical memory that can be allocated' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {101}( 1.3.18.0.2.4.3107 NAME 'rcmds' DESC 'allow, deny, hostlogincontrol. Specifies whether a user is allowed to run remote commands.' EQUALITY caseIgnoreMatch SUBSTR caseIgnoreSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {102}( 1.3.18.0.2.4.786 NAME 'roleList' DESC 'list of roles a user or role may belong to' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {103}( 1.3.18.0.2.4.745 NAME 'roleName' DESC 'role name' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {104}( 1.3.18.0.2.4.794 NAME 'roleVisibility' DESC 'role visibility to the system' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {105}( 1.3.18.0.2.4.759 NAME 'stackSizeLimit' DESC 'size limit for process stack' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {106}( 1.3.18.0.2.4.754 NAME 'stackSizeLimitHard' DESC 'largest stack segment for a process' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {107}( 1.3.18.0.2.4.804 NAME 'systemEnvironment' DESC 'protect environment' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {108}( 1.3.18.0.2.4.809 NAME 'terminalAccess' DESC 'list of terminals that can access users account' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {109}( 1.3.18.0.2.4.767 NAME 'terminalLastLogin' DESC 'terminal users last successfully login' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {110}( 1.3.18.0.2.4.769 NAME 'terminalLastUnsuccessfulLogin' DESC 'terminal of users last unsuccessful login' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {111}( 1.3.18.0.2.4.806 NAME 'timeExpiredLogout' DESC 'inactivity time out' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {112}( 1.3.18.0.2.4.474 NAME 'timeExpireLockout' DESC '  ' SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 )

olcAttributeTypes: {113}( 1.3.18.0.2.4.800 NAME 'trustedPathStatus' DESC 'indicates the users trusted path status' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {114}( 1.3.18.0.2.4.811 NAME 'unsuccessfulLoginCount' DESC 'count of unsuccessful logins' EQUALITY integerMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 SINGLE-VALUE )

olcAttributeTypes: {115}( 1.3.18.0.2.4.795 NAME 'userEnvironment' DESC 'user public environment' EQUALITY caseExactMatch ORDERING caseExactOrderingMatch SUBSTR caseExactSubstringsMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcAttributeTypes: {116}( 1.2.840.113556.1.4.656 NAME 'userPrincipalName' DESC 'Primary security identity in the form <principal>@<realm>; for example, alice@austin.ibm.com.  This attribute is defined on Active Directory.' EQUALITY caseExactMatch SYNTAX 1.3.6.1.4.1.1466.115.121.1.15 SINGLE-VALUE )

olcObjectClasses: {0}( 1.3.18.0.2.6.168 NAME 'AIXAccessRoles' DESC 'AIX role information' SUP top STRUCTURAL MUST roleName MAY ( AIXScreens $ authorizationLevel $ groupList $ msgFileName $ msgNumber $ roleList $ roleVisibility $ ibm-roleID $ ibm-roleAuthMode $ ibm-msgSet $ ibm-authorizations $ description ) )

olcObjectClasses: {1}( 1.3.18.0.2.6.169 NAME 'AIXAdmin' DESC 'AIX class to store user/group administration attributes' SUP top STRUCTURAL MAY ( AIXAdminGroupId $ AIXAdminUserId $ AIXGroupID $ AIXUserID $ cn ) )

olcObjectClasses: {2}( 1.3.18.0.2.6.472 NAME 'aixAuxAccount' DESC 'Auxiliary AIX user information objectclass, for use with posixaccount and shadowaccount objectclasses' SUP top AUXILIARY MAY ( passwordChar $ adminGroupNames $ aIXDefaultMACLevel $ aIXFuncMode $ aIXisDCEExport $ aIXLowMACLevel $ aIXPromptMAC $ aIXScreens $ aIXUpperMACLevel $ auditClasses $ authMethod1 $ authMethod2 $ coreSizeLimit $ coreSizeLimitHard $ cPuSize $ cPuSizeHard $ dataSegSize $ dataSegSizeHard $ filePermMask $ fileSizeLimit $ fileSizeLimitHard $ groupList $ groupSwitchUserAllowed $ hostLastLogin $ hostLastUnsuccessfulLogin $ hostsAllowedLogin $ hostsDeniedLogin $ isAdministrator $ isAccountEnabled $ isDaemon $ isLoginAllowed $ isRemoteAccessAllowed $ isSwitchUserAllowed $ ixTimeLastLogin $ ixTimeLastUnsuccessfulLogin $ loginTimes $ maxFailedLogins $ maxLogin $ openFileLimit $ openFileLimitHard $ passwordCheckMethods $ passwordDictFiles $ passwordExpireTime $ passwordHistSize $ passwordMaxRepeatedChars $ passwordMinAlphaChars $ passwordMinDiffChars $ passwordMinLength $ passwordMinOtherChars $ physicalMemLimit $ physicalMemLimitHard $ roleList $ StackSizeLimit $ StackSizeLimitHard $ SystemEnvironment $ terminalAccess $ terminalLastLogin $ terminalLastUnsuccessfulLogin $ timeExpiredLogout $ timeExpireLockout $ trustedPathStatus $ unsuccessfulLoginCount $ userEnvironment $ passwordFlags $ capability $ passwordHistExpire $ passwordHistList $ rcmds $ ibm-aixProjectNameList $ ibm-defaultRoles $ ibm-coreNamingPolicy $ ibm-coreCompressionEnable $ibm-corePathEnable $ ibm-corePathName $ passwordMaxConsecutiveRepeatedChars  ) )

olcObjectClasses: {3}( 1.3.18.0.2.6.473 NAME 'aixAuxGroup' DESC 'Auxiliary AIX group information objectclass, for use with the posixgroup objectclass.' SUP top AUXILIARY MAY ( aIXGroupAdminList $ aIXisDCEExport $ aIXScreens $ groupPassword $ isAdministrator $ ibm-aixProjectNameList ) )

olcObjectClasses: {4}( 1.3.18.0.2.6.620 NAME 'ibm-aixAccountingAdminPolicy' DESC 'Advanced Accounting admin policy object' SUP top STRUCTURAL MUST ( ibm-aixAdminPolicyEntry $ ibm-aixAdminPolicyName ) )

olcObjectClasses: {5}( 1.3.18.0.2.6.621 NAME 'ibm-aixAccountingProject' DESC 'Advanced Accounting project defintion object' SUP top STRUCTURAL MUST ( ibm-aixProjectDefinition $ ibm-aixProjectName ) )

olcObjectClasses: {6}( 1.3.18.0.2.6.637 NAME 'ibm-aixAixpert' DESC 'For storing Aixpert specific data' SUP top STRUCTURAL MUST ( ibm-aixpertLabel $ ibm-aixpertXmlConfigFile ) )

olcObjectClasses: {7}( 1.3.18.0.2.6.640 NAME 'ibm-authorization' DESC 'Contains authorization definition' SUP top STRUCTURAL MUST ( cn $ ibm-authorizationID ) MAY ( msgFileName $ msgNumber $ ibm-msgSet $ description ) )

olcObjectClasses: {8}( 1.3.18.0.2.6.642 NAME 'ibm-privcmd' DESC 'Contains privileged command definition' SUP top STRUCTURAL MUST cn MAY ( ibm-accessAuths $ibm-authPrivs $ ibm-egid $ ibm-euid $ ibm-innatePrivs $ ibm-inheritPrivs $ ibm-secFlags $ description ) )

olcObjectClasses: {9}( 1.3.18.0.2.6.641 NAME 'ibm-privdev' DESC 'Contains privileged device definition' SUP top STRUCTURAL MUST cn MAY ( ibm-readPrivs $ ibm-writePrivs $ description ) )

olcObjectClasses: {10}( 1.3.18.0.2.6.639 NAME 'ibm-privfile' DESC 'Trusted configruation files' SUP top STRUCTURAL MUST cn MAY ( ibm-readAuths $ ibm-writeAuths $ description ) )

olcObjectClasses: {11}( 1.3.18.0.2.6.241 NAME 'ibm-SecurityIdentities' DESC 'Defines the security identities of a user.  The user could be a person or a service.' SUP top AUXILIARY MAY ( altSecurityIdentities $ userPrincipalName ) )

dn: cn={6}sudoers,cn=schema,cn=config
objectClass: olcSchemaConfig
cn: {6}sudoers
olcAttributeTypes: {0}( 1.3.6.1.4.1.15953.9.1.1   NAME 'sudoUser'   DESC 'User(s) who may  run sudo'   EQUALITY caseExactIA5Match   SUBSTR caseExactIA5SubstringsMatch   SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcAttributeTypes: {1}( 1.3.6.1.4.1.15953.9.1.2   NAME 'sudoHost'   DESC 'Host(s) who may run sudo'   EQUALITY caseExactIA5Match   SUBSTR caseExactIA5SubstringsMatch   SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcAttributeTypes: {2}( 1.3.6.1.4.1.15953.9.1.3   NAME 'sudoCommand'   DESC 'Command(s) to be executed by sudo'   EQUALITY caseExactIA5Match   SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcAttributeTypes: {3}( 1.3.6.1.4.1.15953.9.1.4   NAME 'sudoRunAs'   DESC 'User(s) impersonated by sudo (deprecated)'   EQUALITY caseExactIA5Match   SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcAttributeTypes: {4}( 1.3.6.1.4.1.15953.9.1.5   NAME 'sudoOption'   DESC 'Options(s) followed by sudo'   EQUALITY caseExactIA5Match   SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcAttributeTypes: {5}( 1.3.6.1.4.1.15953.9.1.6   NAME 'sudoRunAsUser'   DESC 'User(s) impersonated by sudo'   EQUALITY caseExactIA5Match   SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcAttributeTypes: {6}( 1.3.6.1.4.1.15953.9.1.7   NAME 'sudoRunAsGroup'   DESC 'Group(s) impersonated by sudo'   EQUALITY caseExactIA5Match   SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 )
olcAttributeTypes: {7}( 1.3.6.1.4.1.15953.9.1.8   NAME 'sudoNotBefore'   DESC 'Start of time interval for which the entry is valid'   EQUALITY generalizedTimeMatch   ORDERING generalizedTimeOrderingMatch   SYNTAX 1.3.6.1.4.1.1466.115.121.1.24 )
olcAttributeTypes: {8}( 1.3.6.1.4.1.15953.9.1.9   NAME 'sudoNotAfter'   DESC 'End of time interval for which the entry is valid'   EQUALITY generalizedTimeMatch   ORDERING generalizedTimeOrderingMatch   SYNTAX 1.3.6.1.4.1.1466.115.121.1.24 )
olcAttributeTypes: {9}( 1.3.6.1.4.1.15953.9.1.10   NAME 'sudoOrder'   DESC 'an integer to order the sudoRole entries'   EQUALITY integerMatch   ORDERING integerOrderingMatch   SYNTAX 1.3.6.1.4.1.1466.115.121.1.27 )
olcObjectClasses: {0}( 1.3.6.1.4.1.15953.9.2.1   NAME 'sudoRole'   SUP top   STRUCTURAL   DESC 'Sudoer Entries'   MUST ( cn )   MAY ( sudoUser $ sudoHost $ sudoCommand $ sudoRunAs $ sudoRunAsUser $ sudoRunAsGroup $ sudoOption $ sudoOrder $ sudoNotBefore $ sudoNotAfter $ description )   )

dn: olcDatabase={-1}frontend,cn=config
objectClass: olcDatabaseConfig
objectClass: olcFrontendConfig
olcDatabase: {-1}frontend
olcAccess: {0}to *  by dn.base="cn=replicant,ou=users,dc=servers,dc=domain,dc=com" read  by * +0 break
olcAccess: {1}to * by set="[cn=ldapadmins,ou=Groups,dc=servers,dc=domain,dc=com/memberUid] & user/uid" write by * break
olcAccess: {2}to attrs=userPassword by self =xw by dn.base="cn=aixproxy,ou=users,dc=servers,dc=domain,dc=com" =xw by anonymous auth  by * none
olcAccess: {3}to dn.children="dc=servers,dc=domain,dc=com" filter=(objectClass=aixAuxAccount) attrs=ixtimelastlogin,terminallastlogin,hostlastlogin,unsuccessfullogincount,terminallastunsuccessfullogin,ixtimelastunsuccessfullogin,hostlastunsuccessfullogin,passwordflags,shadowlastchange,passwordhistlist by dn.base="cn=aixproxy,ou=users,dc=servers,dc=domain,dc=com" write
olcAccess: {4}to * by users read  by * none
olcAddContentAcl: FALSE
olcLastMod: TRUE
olcLimits: {0}dn.base="cn=replicationuser,ou=users,dc=servers,dc=domain,dc=com"size.soft=unlimited  size.hard=unlimited  time.soft=unlimited  time.hard=unlimited
olcMaxDerefDepth: 0
olcReadOnly: FALSE
olcSchemaDN: cn=Subschema
olcSyncUseSubentry: FALSE
olcMonitoring: FALSE

dn: olcDatabase={0}config,cn=config
objectClass: olcDatabaseConfig
olcDatabase: {0}config
olcAccess: {0}to *  by * none
olcAddContentAcl: TRUE
olcLastMod: TRUE
olcMaxDerefDepth: 15
olcReadOnly: FALSE
olcRootDN: cn=admin,cn=config
olcRootPW: {SSHA}XXXXXXXXXXXXXXXXX
olcSyncUseSubentry: FALSE
olcMonitoring: FALSE

dn: olcDatabase={1}bdb,cn=config
objectClass: olcDatabaseConfig
objectClass: olcBdbConfig
olcDatabase: {1}bdb
olcDbDirectory: /var/db/openldap-data
olcSuffix: dc=servers,dc=domain,dc=com
olcAddContentAcl: FALSE
olcLastMod: TRUE
olcMaxDerefDepth: 15
olcReadOnly: FALSE
olcRootDN: cn=admin,cn=config
olcSyncUseSubentry: FALSE
olcSyncrepl: {0}rid=100 provider=ldap://sy00730a.servers.domain.com bindmethod=simple timeout=0 network-timeout=0 binddn="cn=replicationuser,ou=users,dc=ser vers,dc=domain,dc=com" credentials="password" keepalive=0:0:0 starttls=critical tls_cert="/usr/local/etc/ssl/star.servers.domain.com.pem"  tls_key="/usr/local/etc/ssl/star.servers.domain.com.pem" tls_cacert="/usr/local/etc/ssl/star.servers.domain.com.pem" tls_reqcert=demand tls_cipher_suite=HIGH:MEDIUM:-SSLv2 tls_crlcheck=none filter="(objectclass=*)" search
 base="dc=servers,dc=domain,dc=com" scope=sub schemachecking=on type=refreshAndPersist retry="60 +"
olcMirrorMode: TRUE
olcMonitoring: TRUE
olcDbCacheSize: 1000
olcDbCheckpoint: 1024 10
olcDbConfig: {0}set_cachesize 0 268435456 1
olcDbConfig: {1}set_lg_regionmax 262144
olcDbConfig: {2}set_lg_bsize 2097152
olcDbConfig: {3}set_lg_dir /var/db/openldap-data
olcDbConfig: {4}set_flags DB_LOG_AUTOREMOVE
olcDbNoSync: FALSE
olcDbDirtyRead: FALSE
olcDbIDLcacheSize: 0
olcDbIndex: objectClass eq
olcDbIndex: entryUUID eq
olcDbIndex: entryCSN eq
olcDbIndex: cn pres,eq
olcDbIndex: uid pres,eq
olcDbIndex: uidNumber eq
olcDbIndex: gidNumber eq
olcDbIndex: memberUid eq
olcDbIndex: sudoUser eq,sub
olcDbLinearIndex: FALSE
olcDbMode: 0600
olcDbSearchStack: 16
olcDbShmKey: 0
olcDbCacheFree: 1
olcDbDNcacheSize: 0

dn: olcOverlay={3}ppolicy,olcDatabase={1}bdb,cn=config
objectClass: olcOverlayConfig
objectClass: olcPPolicyConfig
olcOverlay: {3}ppolicy
olcPPolicyHashCleartext: TRUE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD6B16F0E0
	for <patches@lists.linux.dev>; Tue, 28 May 2024 13:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716902119; cv=fail; b=Lol/TpS7Sm4vhEAw03CuohgL4/TcBUJO3BwC5rQ8MJrM5wVRCDGFcMepBJX5f6mXLAEsvzGdgPETc671dDExsUgw7qglTcVD/cZ7QddWe/0FSiVhwTYBj56kYceajEsN875bjOcj1Skzt9GSI2x+aqVR2inHXsFakWEytPXDDYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716902119; c=relaxed/simple;
	bh=nPWuEFUfME5mAiGqBV0jWAwGt/pVIX5ukwqu0TjT9/E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=im4O5woUT+uKy5cHWNGGeLrADeUx6mMgPSA7RXgTna83U5UO8ZQQxiYXRz2+uclso/T2GW5GSb/GvkFcP0nuyJ4+BAcMYECyZDAS132eV4+8SM+maknjOxD7YIesSVN5Pxj9/zcVMPh2YoZp35QerbUcbK4ro8ZEUl96icHA2O4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44SBn1wI031930;
	Tue, 28 May 2024 13:14:44 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-id:content-transfer-encoding:content-type:date:fr?=
 =?UTF-8?Q?om:in-reply-to:message-id:mime-version:references:subject:to;_s?=
 =?UTF-8?Q?=3Dcorp-2023-11-20;_bh=3DnPWuEFUfME5mAiGqBV0jWAwGt/pVIX5ukwqu0T?=
 =?UTF-8?Q?jT9/E=3D;_b=3DN9naQQXlsOasPiU0daUGkB0A3SNBVxxVGqic4F/NZRb3h0Sjh?=
 =?UTF-8?Q?xAmee+bd4mXGg0blAA9_2aIWEAedt4nuFjbnh54p1aY8QIMh0qLEmU6je5USaji?=
 =?UTF-8?Q?B1I7ccH4diFwtDWpXF1HlvoZH_6V6EG4LRC53erwWOB+Oq05AY7bXQ5AP/q8ld6?=
 =?UTF-8?Q?ZG40ty0uQDdXXvvBLkGcBTmBrsPPVaQ_hCoJeSCC33E1de84lPzweanG20U19Nn?=
 =?UTF-8?Q?aL5sQnPj3CdELDOw7YCx5KJLSI5C1IheJnhWd_Uq5OCxFGZMIlEnOm0h7zt5lLD?=
 =?UTF-8?Q?BwlXowFh2rP059YMXTK9mR3JaqQ+z+icUIoJEu0wvC8_Vg=3D=3D_?=
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8g9marb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 13:14:43 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44SBmnFF009265;
	Tue, 28 May 2024 13:14:43 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yc52b3un3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 13:14:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Coun4apuUJ4vapozge9SI0xACHRCGk5D6trh6VA7sz+BGQlEWOVGHxWmLYuJ7EX6h/ftrlrqfzafgPoloik/Mtybvq96n66a9zTaSBDkh3w/+vEVLz+S5kar5hKJuDF3a1FgnhhgDttWHEBiVPAqanEniwSgR8hyPMcIZ2w+hkY+139NHyZ12zdfWeZu2qzCW5KFz25niVfw5oxqESo73RhKb8vD4176EXHCichewRiJO+yXZPHnhcqyaZS8wXNfPkESgKEqGYIXwe+SYRtQMu5iki7B+ITT6Y0GRkkdRqiFk14CT63zM/XxbSMMtFuR9pM9rHpXC2LVwlsLqB2mVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nPWuEFUfME5mAiGqBV0jWAwGt/pVIX5ukwqu0TjT9/E=;
 b=PtUTuQ50eK0b/XBuTNzPzSWZoce7uTZ+ZSfBGaMkScW8vbJIqMBQsz55TncN4Zfgf16rlT/jmhotlBChvyebjgLtZCzjVCCU3646oJhBzHQeQ0vBziIXAkRw164tD5zYLTr/p4JyQRcrL3VcgJeT0WDWum8rxmUYEeScyZirwz544wcnFlRpdFrWmUGPSqUCUs8xiRbniwXVf587S07yAkwHrD9r5WNizKTJRq9S3BGLRLnvb49zrF6tbrhDOq9nut81hkQZs5hZ+R/ZcpKs5bF8njc41RXznsUER75rT44aOIBz3Bqas9MpS/Al1IaTzL9Hfj9lzPY5y78V1KSePA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPWuEFUfME5mAiGqBV0jWAwGt/pVIX5ukwqu0TjT9/E=;
 b=qQl6PM/8SMVggstfmMpR5fFVN/+edMSQaJx3jShgshGwzTCBiPDP05Co5sQJHhbOZsvSv3yj9R8g+//8P9TqYvnq8D87AHDACeFThmI4BUfzHLyHB6iUnCRWtkAvTA9+Y6yYRGNFct30+469712M7NGEyhw9GdkOmNreAK628vY=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DS7PR10MB7323.namprd10.prod.outlook.com (2603:10b6:8:ec::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.17; Tue, 28 May 2024 13:14:41 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%4]) with mapi id 15.20.7611.025; Tue, 28 May 2024
 13:14:41 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Jon Hunter <jonathanh@nvidia.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Neil Brown
	<neilb@suse.de>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
        linux-stable <stable@vger.kernel.org>,
        "patches@lists.linux.dev"
	<patches@lists.linux.dev>,
        Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>,
        Linus Torvalds
	<torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "lkft-triage@lists.linaro.org"
	<lkft-triage@lists.linaro.org>,
        "pavel@denx.de" <pavel@denx.de>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "sudipm.mukherjee@gmail.com"
	<sudipm.mukherjee@gmail.com>,
        "srw@sladewatkins.net" <srw@sladewatkins.net>,
        "rwarsow@gmx.de" <rwarsow@gmx.de>,
        "conor@kernel.org" <conor@kernel.org>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "broonie@kernel.org"
	<broonie@kernel.org>,
        "linux-tegra@vger.kernel.org"
	<linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 00/23] 5.15.160-rc1 review
Thread-Topic: [PATCH 5.15 00/23] 5.15.160-rc1 review
Thread-Index: AQHasN4Kp5m/MZVFZ0aHe0MmQeirFLGsoDYA
Date: Tue, 28 May 2024 13:14:41 +0000
Message-ID: <968E3378-1B38-4519-BB85-5B1C45E3A16A@oracle.com>
References: <20240523130327.956341021@linuxfoundation.org>
 <8e60522f-22db-4308-bb7d-3c71a0c7d447@nvidia.com>
 <2024052541-likeness-banjo-e147@gregkh>
 <8ddb4da3-49e4-4d96-bec3-66a209bff71b@nvidia.com>
In-Reply-To: <8ddb4da3-49e4-4d96-bec3-66a209bff71b@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DS7PR10MB7323:EE_
x-ms-office365-filtering-correlation-id: 0ee63faf-c1f4-42bb-4a3f-08dc7f182253
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: 
 BCL:0;ARA:13230031|376005|366007|7416005|1800799015|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?Rk9lZ2l0M1o4a3gzRjFKOHlxeUF5T1NqK25Pa29FK29Uc25FUzFIU3M2WjIz?=
 =?utf-8?B?SlVxVTlzNUFPbCtQSnFTOXp1SHJnRE9wMXgwNVk5S0RyeDRFMjQwL0tnQmVF?=
 =?utf-8?B?dEVvdXdsRjByNERzOFRoYnIxTjlncXUvcTJzUml2cTM1aGxEUEhjWVJpYW9W?=
 =?utf-8?B?WCtiWmVMSlB0OU9UZEVhQkdaMUM0YkkxYnBBd29ZeHdCYlI0bE0rb2xBSTR0?=
 =?utf-8?B?ZkxQZStDbXpzaFo0K2ZtU0tORVNiVHpta0xTVndHUVpMajNRb0VRYnljU2Rt?=
 =?utf-8?B?RGhxL3BuQStlcGRmRG1zeVZ2SG1lRW1BRFg1ektHQXhuSEFVTDBrNXFpU3lS?=
 =?utf-8?B?Y0ZvcHkvU0RYY0orUWlqKzUxZnR3dSs5aldNdTI0NUlEcXpSSjRJNVRvYkRj?=
 =?utf-8?B?MmdtNmFGN0FKNUxTVHV4aUNYK0Z1YVp4Y2k1eExvTUJ5UTFyanhFNFlZeEdS?=
 =?utf-8?B?c3phUkJKdXd1K09GQld5OFJpcmtTbzgxMTRlQjFXOEIreklXVWZ1SGFkUWdD?=
 =?utf-8?B?SkJWVW5CeUY2WWU2TDRpQm9pVnFCd0JGVkhjS0owQ2l4T29NWHdpWE1NYlFk?=
 =?utf-8?B?U2pRK2Z0Uy9SMDVYUkJSS0pQVGd2QzhpWXBhZk10RzA2cHh0c2lkNXhqZUs4?=
 =?utf-8?B?QmhLQzFXQkNzUHNVb1VTQXhmZEhNdStaVXFqNUtKTmM4U2E0K001WlNuWVIw?=
 =?utf-8?B?SDhnbXRvUVc5VEVWaEU2LzQ3YXk0NWtCWjRBdHdSRmRmeG9McGV1RkhsWStM?=
 =?utf-8?B?SEZjU1ZyYVZ3SEJwbEZiM2VFZit3N01NbEFqbktjZjNoS0xUdHVqeFB5V0pm?=
 =?utf-8?B?eVNqRStZMWgxNXZtK2pibmI2NUxEc3FKcjRUNmllUDNSSEw4UVFJWEtVenpZ?=
 =?utf-8?B?cnltRTMwMTc1TlNvdE16M3FQZjBBWmwzR1VFZ3JhNU1EaVREQVV3Mytzb3BK?=
 =?utf-8?B?MmRjQmJoOGoyTDNURkc5aGtTYzBxZE1xQVJhNkdpaThJYnJteTdrQ08zZDho?=
 =?utf-8?B?WlBUV3JuMmxLdFd4OC9jMEJ4Q3NjMmRUdUdhSkVVZFQ5WlFPOFhDT3ViM0Fo?=
 =?utf-8?B?SW8xZTBpVWdtMFJtRUlSMVRCVlpheFYweXgzUXJLWGo0L1FOSUJIY0dsWFVi?=
 =?utf-8?B?Z2RkTkhBbDZRRldMYnVXVmE5RXNtSHU0bm83T1VBOG4yTWkwY0hGcXlSM1hR?=
 =?utf-8?B?UVFkbGdNek9BaUpNR1IvU1B2MHE1TmZiRHBqckJkWEcyOVdZOXhvZlFMQUJD?=
 =?utf-8?B?QS9EaXlVNFNCa2VVV3dFbkE4RmxmTlYyU0xkaG5aUTFHNlpTWDk2a0pjRXQ0?=
 =?utf-8?B?UEM5NStSRURmM25tYlZ6NzIrT1lLN1NOQW5tWnBwMGl5Um0wTGpFRTBUU3ph?=
 =?utf-8?B?V2R1M2V5VGdNa0k5bGVFakJua2tnVXVsWWdPeTlBLytUYVhqbTZZQWdlTTdj?=
 =?utf-8?B?dDlYV2IxWmd2OE54MHVYd2FkUmwxeE1jR1R0bFZVSk9DbStRQzYwblB2WGxq?=
 =?utf-8?B?QklEeXhmQVgvS2tNZ3JuZzBMRFB3MEFxMXM4Sk5sbFo1b0FqY3RFLzVuNzgy?=
 =?utf-8?B?WlRsRlkyWW01T0hSbWJ4SHVRMGFqeW1TcSt1TmtSNDFtdGh1cVVKYXQ4M0VL?=
 =?utf-8?B?cmZCdVpPc3ZHczJ0d1lSTnJvQk1mVTF5N2x5WFlGcU9Ka1pLMFA5RjVkVTVa?=
 =?utf-8?B?VFNORExDTDZsNGhFUi8xU3l1dFBCQ3BaUVo2emhhNEJBWW1oOUNxZ2FuR3RR?=
 =?utf-8?Q?TmOsdC6VCQ6NpD1Nns=3D?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?d0N1bGpyYnZHSk00a1V0QTkxU0VwS1JxdDh3VDl2Q0xVdFBTb1A2bTAxdGVq?=
 =?utf-8?B?ZFBna1Z5VUdtU0JIekVGRG1WZVlDMDAxQ3F4NjZNT1dmb0xmNFhOcVhFYzdG?=
 =?utf-8?B?eGx0cFFGVS9aTUVIYWlFTkJvKzhoTi9DK2VRSjBNc3dxQzRzWkZlY1BGS2pE?=
 =?utf-8?B?bnRORkVPb2o4T2IxbTJyK0lueGVlSHRHUmNUakhyOTNFaWt2bDVFblBCZE5Q?=
 =?utf-8?B?eXJOTUhOT3RCOE1zOVJqbUZvSWFqSURoVG05ZTd5N3ZMb3pNbUx6RUxOTml0?=
 =?utf-8?B?R2QzajA5L1BkTW0rT2FVSnZuMXRXZVJwNEM2TUVGa2c5enZpbHRsa1JmcFlh?=
 =?utf-8?B?bDhCUllndm9TWTBUaytjazYwUGd1d3F5NlUydXk3WXpGcUY5ZkJjRzVydmVL?=
 =?utf-8?B?NEI5VWN2U0p3RkVaNFBxN0N5WVFONzY0SysrQktlKzY5dXlXSzE0bmdWQmFa?=
 =?utf-8?B?MmRGNUpxNy9mYjlMMGVtNVZERGtrSkFCVGhZNFVEVWlpaTZra1JyZzY0cE5H?=
 =?utf-8?B?M3FGUXVsVzFhUmdPSVBtazdXUUMyWTR5c0xZMHBNV2FaM3FQS3ErZzBmY2JB?=
 =?utf-8?B?ODU3VjlSMzllekhhelQ1dEtRQ1ZFZ1hBSXVaZU9GR09pTHBVdzFNQzNDbkxX?=
 =?utf-8?B?ZGJjSE9sV1hHZGFqZEZONjBDRzdhVmZSaGlGUHZmU0pGREVaV05Ocm9jS3Ry?=
 =?utf-8?B?Yi9GaG40NEMvbVZrajM1cVl2Wi96RFdqcTdSbWhoZWVkNUlLYmlVSEl0SW9C?=
 =?utf-8?B?cUc4RjR2cHhYN0lYMFJtYzB6b0o5ekhXTld6L3lJUC9vcHpsQytwSjFxTlgr?=
 =?utf-8?B?QWRnelFqbnh1YVozREpNU05PYzlKNEQrTmlvdUVCck9TK3lqUS9hbmJvSW1G?=
 =?utf-8?B?ZXMySm0wL0RwczkxbWwzUjBaWXNOSG1YSExMUjRvdXpaT0Qyc3BEM2NLUWJS?=
 =?utf-8?B?WlBVRFEvblZYanBqc1V2UVovQUl0Z3k0eTkzLzI4WWlmYWc5TmNZUXFzQ0pw?=
 =?utf-8?B?WDUwbld4cTd0T0lNck9WMTlnWnNtUFNhWE5BLzU5dmtleDVUNFFRUFluVitl?=
 =?utf-8?B?SDc0TGZVRUFQSkhFVHVrY3p2SG8zWUpkdnNHZ1hFVnFTTk9vYmFhTXhHcU5x?=
 =?utf-8?B?UEpiUXF6RXAzQkIxbVVIMGtlcGhNL1AxWG8zSmYvU0hiYXNkMW5XNEh5eCtO?=
 =?utf-8?B?UmtabjdHd1pxYlgweEwyd3Qya21lNVlTMWpDeS9hRW5Ed2Znc0ErREYyQmRB?=
 =?utf-8?B?MGw3MnpOSmtIQVBvTk1sZzR2Y0xzOXcxTWNrZURNMWNKS2pJUHRCMzNyemhV?=
 =?utf-8?B?SWg1RmR6UnFEbkk2eGdiQ2s5OSs3cElnRGs2eVVSdjgvRW12cHNDczZvMzU3?=
 =?utf-8?B?a2k5eGorYUdsQU9Hc2o1cG9ETEVUamYwZkVPamRNL3VYU3lYZW1sWXBJY2pp?=
 =?utf-8?B?UmtYaDVTWEFRL3ZVUVFNSFRhRUhNV1JCeGY0L0o5TzNiclFtam9MYnk1WG10?=
 =?utf-8?B?V01jUnZNclB0eDc1NDd2cU9rQnpyMHdPSkRrekY5czFKVkZDRjRpa0VLdko3?=
 =?utf-8?B?SGFiS05qNFhrTTc4WnRuaUtWZFhrMDh2TGgxVmxaSzBKWDlpbExIaHBMNU1s?=
 =?utf-8?B?UzdldWRXSVpoYTVFb05BU01CQ1hZRHl1OHZJRURPbVFnZlZXRy8zMkpad1Ay?=
 =?utf-8?B?SlJMeWVjdmx6OWlDMFZEa1ZEbmNkMzJ2aDR3cS9ZSGV1eUlMM0ZZNFlFWUJQ?=
 =?utf-8?B?RTdtRnJqMFVRYUxONERQejBsVFdYeHlQb1h3VUFCQWdTNkJpVFhVMGZoNE9u?=
 =?utf-8?B?ZGlYTTRYVHl0MCtyVmttbmlUYkZpUWx0NVV1S2JKUEdSRk9FRWxieXVjc1VI?=
 =?utf-8?B?bTBmYWszZVR2OWkvNlpZNmczV2pGeUtnTVIza0JHZUxKdmZ4SnRJOCtkUmFM?=
 =?utf-8?B?YmQyczVCcVZsRmw4MERPNU9VMzJLbS8xeWxoeEtOMmk1L0JEWjF1b1hrY0wx?=
 =?utf-8?B?MmI4YkluQVBzYzZoNUNJbGJIVHJtN2Noc3p6WGdiTHlzS2cyYS9NV0F1b3gw?=
 =?utf-8?B?a0lzdXlLRks5SVRSQnllSHA2dFYwMFBqVEIyUTZ4SzZianF6STkvb1NIQUlJ?=
 =?utf-8?B?THYvcTdxK28yYXdPZ0hNbkhYNGlKOW9GenEwZnp6c2ppblZxOU4wSGZqbEY5?=
 =?utf-8?B?YWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <131968863C9B144BA2DD5534BE06968C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	le6g0F1lRGlmf87qLI5beJstwKxXLjQfXWlHyxXG0yBOZ4nSituURMpcf/IZiD0DycssJ9+jBm0TbQ4Nr1IPyY6JJSd3e13Z/D56bFAnRh3r0epBotbbpyHNNR35aOOfq/j+86eLqEySFQ8hxLrzHto9YHHtuELBDKQLO9eEHxJQiqVbGnO7XO82d6YYTBGry1ct38D2NDx46NyA/H6JK8OilImTOd8nRgE7xkLjxBQXnFJr+NdsvbPE2TM5d+lJmS74ZtUE06NVhCPimDddoPOxXTQbwzRAmxCSHDJd1hRd8Tod0Wkw5P6ALcn4DVjEetL1TKwOr8gHUDtWkGUZT4o9pne166sGAg2/mb8wPLoktfueU2xDjB/yX7uEge+mmga+a5dwbY4pJAkAQ0f+406TiusVwcGxrxdVreUOHYkGdbB2HTfNoB1M7Xs/T4uRz6QuSuC5fnWNx5RKCAQKZjew5l+W6i1nm1TsqHeZitPd54QTPftT5IVJGmQkkZ0kzFyNW+1JCgw37aj35dok45QaJ5YQRMbtlF5gX77GPSLTQIzeGVQZd5NHfan0ASha4QjvxE0s1ehg7WA+BW8dr/e7QG8MXwstkxFVkdm0uoM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ee63faf-c1f4-42bb-4a3f-08dc7f182253
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2024 13:14:41.1297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bV7acQoNYjL8Ca7EE0oF0e2/0mPDCxoB2FIKq06dSbiiowfQwDaAUabodwCf/JEY1yfH2JPsC46T0XynrQrMFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7323
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-28_09,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405280099
X-Proofpoint-GUID: brYiUFiGItagcauQjVDBdkjJgd2Vnmab
X-Proofpoint-ORIG-GUID: brYiUFiGItagcauQjVDBdkjJgd2Vnmab

DQoNCj4gT24gTWF5IDI4LCAyMDI0LCBhdCA1OjA04oCvQU0sIEpvbiBIdW50ZXIgPGpvbmF0aGFu
aEBudmlkaWEuY29tPiB3cm90ZToNCj4gDQo+IA0KPiBPbiAyNS8wNS8yMDI0IDE1OjIwLCBHcmVn
IEtyb2FoLUhhcnRtYW4gd3JvdGU6DQo+PiBPbiBTYXQsIE1heSAyNSwgMjAyNCBhdCAxMjoxMzoy
OEFNICswMTAwLCBKb24gSHVudGVyIHdyb3RlOg0KPj4+IEhpIEdyZWcsDQo+Pj4gDQo+Pj4gT24g
MjMvMDUvMjAyNCAxNDoxMiwgR3JlZyBLcm9haC1IYXJ0bWFuIHdyb3RlOg0KPj4+PiBUaGlzIGlz
IHRoZSBzdGFydCBvZiB0aGUgc3RhYmxlIHJldmlldyBjeWNsZSBmb3IgdGhlIDUuMTUuMTYwIHJl
bGVhc2UuDQo+Pj4+IFRoZXJlIGFyZSAyMyBwYXRjaGVzIGluIHRoaXMgc2VyaWVzLCBhbGwgd2ls
bCBiZSBwb3N0ZWQgYXMgYSByZXNwb25zZQ0KPj4+PiB0byB0aGlzIG9uZS4gIElmIGFueW9uZSBo
YXMgYW55IGlzc3VlcyB3aXRoIHRoZXNlIGJlaW5nIGFwcGxpZWQsIHBsZWFzZQ0KPj4+PiBsZXQg
bWUga25vdy4NCj4+Pj4gDQo+Pj4+IFJlc3BvbnNlcyBzaG91bGQgYmUgbWFkZSBieSBTYXQsIDI1
IE1heSAyMDI0IDEzOjAzOjE1ICswMDAwLg0KPj4+PiBBbnl0aGluZyByZWNlaXZlZCBhZnRlciB0
aGF0IHRpbWUgbWlnaHQgYmUgdG9vIGxhdGUuDQo+Pj4+IA0KPj4+PiBUaGUgd2hvbGUgcGF0Y2gg
c2VyaWVzIGNhbiBiZSBmb3VuZCBpbiBvbmUgcGF0Y2ggYXQ6DQo+Pj4+IGh0dHBzOi8vd3d3Lmtl
cm5lbC5vcmcvcHViL2xpbnV4L2tlcm5lbC92NS54L3N0YWJsZS1yZXZpZXcvcGF0Y2gtNS4xNS4x
NjAtcmMxLmd6DQo+Pj4+IG9yIGluIHRoZSBnaXQgdHJlZSBhbmQgYnJhbmNoIGF0Og0KPj4+PiBn
aXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvc3RhYmxlL2xpbnV4
LXN0YWJsZS1yYy5naXQgbGludXgtNS4xNS55DQo+Pj4+IGFuZCB0aGUgZGlmZnN0YXQgY2FuIGJl
IGZvdW5kIGJlbG93Lg0KPj4+PiANCj4+Pj4gdGhhbmtzLA0KPj4+PiANCj4+Pj4gZ3JlZyBrLWgN
Cj4+Pj4gDQo+Pj4+IC0tLS0tLS0tLS0tLS0NCj4+Pj4gUHNldWRvLVNob3J0bG9nIG9mIGNvbW1p
dHM6DQo+Pj4gDQo+Pj4gLi4uDQo+Pj4gDQo+Pj4+IE5laWxCcm93biA8bmVpbGJAc3VzZS5kZT4N
Cj4+Pj4gICAgICBuZnNkOiBkb24ndCBhbGxvdyBuZnNkIHRocmVhZHMgdG8gYmUgc2lnbmFsbGVk
Lg0KPj4+IA0KPj4+IA0KPj4+IEkgYW0gc2VlaW5nIGEgc3VzcGVuZCByZWdyZXNzaW9uIG9uIGEg
Y291cGxlIGJvYXJkcyBhbmQgYmlzZWN0IGlzIHBvaW50aW5nDQo+Pj4gdG8gdGhlIGFib3ZlIGNv
bW1pdC4gUmV2ZXJ0aW5nIHRoaXMgY29tbWl0IGRvZXMgZml4IHRoZSBpc3N1ZS4NCj4+IFVnaCwg
dGhhdCBmaXhlcyB0aGUgcmVwb3J0IGZyb20gb3RoZXJzLiAgQ2FuIHlvdSBjYzogZXZlcnlvbmUg
b24gdGhhdA0KPj4gYW5kIGZpZ3VyZSBvdXQgd2hhdCBpcyBnb2luZyBvbiwgYXMgdGhpcyBrZWVw
cyBnb2luZyBiYWNrIGFuZCBmb3J0aC4uLg0KPiANCj4gDQo+IEFkZGluZyBDaHVjaywgTmVpbCBh
bmQgQ2hyaXMgZnJvbSB0aGUgYnVnIHJlcG9ydCBoZXJlIFswXS4NCj4gDQo+IFdpdGggdGhlIGFi
b3ZlIGFwcGxpZWQgdG8gdjUuMTUueSwgSSBhbSBzZWVpbmcgc3VzcGVuZCBvbiAyIG9mIG91ciBi
b2FyZHMgZmFpbC4gVGhlc2UgYm9hcmRzIGFyZSB1c2luZyBORlMgYW5kIG9uIGVudHJ5IHRvIHN1
c3BlbmQgSSBhbSBub3cgc2VlaW5nIC4uLg0KPiANCj4gRnJlZXppbmcgb2YgdGFza3MgZmFpbGVk
IGFmdGVyIDIwLjAwMiBzZWNvbmRzICgxIHRhc2tzIHJlZnVzaW5nIHRvDQo+IGZyZWV6ZSwgd3Ff
YnVzeT0wKToNCj4gDQo+IFRoZSBib2FyZHMgYXBwZWFyIHRvIGhhbmcgYXQgdGhhdCBwb2ludC4g
U28gbWF5IGJlIHNvbWV0aGluZyBlbHNlIG1pc3Npbmc/DQoNCk5vdGUgdGhhdCB3ZSBkb24ndCBo
YXZlIGFjY2VzcyB0byBoYXJkd2FyZSBsaWtlIHRoaXMsIHNvDQp3ZSBoYXZlbid0IHRlc3RlZCB0
aGF0IHBhdGNoIChldmVuIHRoZSB1cHN0cmVhbSB2ZXJzaW9uKQ0Kd2l0aCBzdXNwZW5kIG9uIHRo
YXQgaGFyZHdhcmUuDQoNClNvLCBpdCBjb3VsZCBiZSBzb21ldGhpbmcgbWlzc2luZywgb3IgaXQg
Y291bGQgYmUgdGhhdA0KcGF0Y2ggaGFzIGEgcHJvYmxlbS4NCg0KSXQgd291bGQgaGVscCB1cyB0
byBrbm93IGlmIHlvdSBvYnNlcnZlIHRoZSBzYW1lIGlzc3VlDQp3aXRoIGFuIHVwc3RyZWFtIGtl
cm5lbCwgaWYgdGhhdCBpcyBwb3NzaWJsZS4NCg0KDQo+IEpvbg0KPiANCj4gWzBdIGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2xrbWwvYjM2M2UzOTQtNzU0OS00YjllLWI3MWItZDk3Y2QxM2Y5NjA3
QGFsbGllZHRlbGVzaXMuY28ubnovDQo+IA0KPiAtLSANCj4gbnZwdWJsaWMNCg0KLS0NCkNodWNr
IExldmVyDQoNCg0K

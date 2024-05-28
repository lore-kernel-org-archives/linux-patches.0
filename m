Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF592940D
	for <patches@lists.linux.dev>; Tue, 28 May 2024 23:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716939258; cv=fail; b=tNGWZKfgf/nk2LF0U3ygso3iijjGVCvJZXiTFu22wwUUJah60zoFmPINttHdgskV55bLMxGILhswfcoDiKrZZbcjIeE9zEOuxUkzGiPxRlleLNXVkjquSsfodsPlmG3d24RRmGcPt0eM1Bnin8f9iuqhyUj4JrGFyTygEz7P8xA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716939258; c=relaxed/simple;
	bh=gWjIVln9op0HihPNoHNW/uWpt4eh/eLmeisNMpM+r/4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HKTmzQSU/X705hxYUzdQ5raZzZJUgjMWuQ5eRliryaf979NLdNnptja0NjAwOullWkrRFoRnIMnO+8uibc2eohPdbgOINRRrQCrpPZwBd/kKZWrsbxp36Pl95zuzDiWf7+rbpjEU8DXXxHADW2UfNoVAwuZVmFOp2g3tkCW8c0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44SITjTP019456;
	Tue, 28 May 2024 23:33:43 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-id:content-transfer-encoding:content-type:date:fr?=
 =?UTF-8?Q?om:in-reply-to:message-id:mime-version:references:subject:to;_s?=
 =?UTF-8?Q?=3Dcorp-2023-11-20;_bh=3DgWjIVln9op0HihPNoHNW/uWpt4eh/eLmeisNMp?=
 =?UTF-8?Q?M+r/4=3D;_b=3DFlZCJiJajGnYqB+sUV+LmNmGFFLT8W1EglS9+LnEud8ZZ0i3n?=
 =?UTF-8?Q?o/IMC5/sldqx/xVpt6r_OU4ECxsmYPGjjz9PtryaUFQWqAv94Z3FMzfE4LJ2/0p?=
 =?UTF-8?Q?vVWt1q9outS3TQjlDZJKVlGRQ_h6zhf+DxEfmMROcchMulEDU4zQicq1fy76saQ?=
 =?UTF-8?Q?JREWlhdDkFwjq5aBkoOfuT3Vxb57aU7_5JmiSdfMtwvN3gLQJ6VVGe/socGH/Eg?=
 =?UTF-8?Q?4RLo79TgrNOEnWpsJAmKreZ8Uk1BWqB+H3iH3_/72hrSeWEpCPVWaQG5al5DUwx?=
 =?UTF-8?Q?IRBYLZJgF2KiZW578bkZYR+mltze8U1r1OzBfUnotrh_rw=3D=3D_?=
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yb8j85f0e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 23:33:43 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44SMkAmT024170;
	Tue, 28 May 2024 23:33:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yc52bt5v3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 May 2024 23:33:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltfZqI9vix1JguuqW4kQ/UmDzB9V1QmjW2+hfK6mebm8xtem740oR7uU/ykGEthYZ28RiXoEGHxETu7XyOhbsLdACJtd4HPFC+jxQEfH5fHij1qXYwd5SjoJeV6xwMjQEzH7g2DVTCN6fGbNl9Qc/ZYEzQRK7fBQKFWNA6c5MbahdF2dj5WzU2JexwztOF58qEeFCB210pBJrs5m9DC8D3bnFhhKPafIyxFlqCfgFxbM4INPHkxqEQr9BuvSp2WKnnllGUbOfxhkx3fbBoCt5ob8cxXHYStdjXKJ9Dpk/xgbBTdt07k8DwSB/mSeax57Lin1/U13RIjT/F6gWFIIYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gWjIVln9op0HihPNoHNW/uWpt4eh/eLmeisNMpM+r/4=;
 b=eILJL/UDkdNutfBXzO+HQnBqcYZKkJVbeWxVh95UmnhhozKQybRY1ijjoVm0fYP7l183QlTqOg7xUrmtQKwixHMcPk1q3CpdLZySH75SIp99CuQu0jv93Ocw3AU6547YAZKZGpoUX3qKRgiXRI2oTAaj7xQhVSI1sYio54Ik7mzNw/JnPqBCW197xmp49OiswvpOhd+pnVCI8aUMyZOI/Lar/CQ9ahDixkZCmgTmdPI9pqC3sjLxR8LSpSOhSTJflqO2sfm6vZ/DrC/50LnlTirT9l8ybO0zxbMm3LaGkWeZwrTtJpWMHRzpPqBpCaBlN8J5u/07FwAIIsQAHerjUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gWjIVln9op0HihPNoHNW/uWpt4eh/eLmeisNMpM+r/4=;
 b=MBPDag+XQxaEXuuXZ3SYE8iFvb67Hq4kIbVaDjqwuaxsgDmCNvejKNr1yaTzJZvvwBCeWHZfp+EETVK3mjZexlRceCZxEjFukA+P5V2IjP47AuxWxkrnqNdBhk6uxqa1ipqu28ZugGkF1vRQR2Ug2IAP5TLsYD2JP0Xk98+0hDM=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SJ0PR10MB6327.namprd10.prod.outlook.com (2603:10b6:a03:44d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Tue, 28 May
 2024 23:33:33 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%4]) with mapi id 15.20.7611.025; Tue, 28 May 2024
 23:33:32 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Neil Brown <neilb@suse.de>
CC: Jon Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>,
        Chris Packham
	<Chris.Packham@alliedtelesis.co.nz>,
        linux-stable <stable@vger.kernel.org>,
        "patches@lists.linux.dev" <patches@lists.linux.dev>,
        Linux Kernel Mailing
 List <linux-kernel@vger.kernel.org>,
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
Thread-Index: AQHasN4Kp5m/MZVFZ0aHe0MmQeirFLGsoDYAgAARwgCAAG8IgIAAElGAgAAZzIA=
Date: Tue, 28 May 2024 23:33:32 +0000
Message-ID: <9C1A047C-C8C2-413F-98EA-F8C537535D92@oracle.com>
References: <0377C58A-6E28-4007-9C90-273DE234BC44@oracle.com>
 <171693366194.27191.14418409153038406865@noble.neil.brown.name>
In-Reply-To: <171693366194.27191.14418409153038406865@noble.neil.brown.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SJ0PR10MB6327:EE_
x-ms-office365-filtering-correlation-id: de3b6675-8c8b-4ffc-00c4-08dc7f6e9681
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: 
 BCL:0;ARA:13230031|7416005|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: 
 =?utf-8?B?UTVaa0NBZHB2SW96R3RuemdRQUpLUERIZlRUUDlLTHoyUGdoeHFjUFJobkpR?=
 =?utf-8?B?ZUJSNlp4QmNyZTNGMG5zR1dhM0pIM2s5KzZaUllndGU3RjBBVVNkSDZ3SS9M?=
 =?utf-8?B?UWZ1ckl1OTVPdTltUG9EY1dEK2l0WEwrMXlhUnBlWmM2RHYxL0JNaFphMllv?=
 =?utf-8?B?WUVTNVlNTTdNc3FVU09sV2NaZjlkZ0tTRmRVOSs0YW5RVzdLeGJNV0d4QkZG?=
 =?utf-8?B?emtDdHhxNExDUGZ3LzBrKzNYcW1EUDVRNGNSVGhwbU5PWEQwVzRNOUlab20z?=
 =?utf-8?B?VWdCcmV6bi94ajBvbjBjQTM2SFIra3RLQzRKNkZvNmJjdXA3ODFydHpqWmhS?=
 =?utf-8?B?alJ3VTFRaTloUjRTRHl6MnRKOHVxZzhOSHVpWFNkSVNsc1FWVFkwaVVpQ1NS?=
 =?utf-8?B?akxPQ3czN2VVbllyNnlhVUxIVXJMekcvY1pQRzlpekYzNU9NWEx2aXRETnFH?=
 =?utf-8?B?SGdSVjNlMktBVDZQVkRZbi9mcHhxNytsMTRabHNPL0dWajRmV21RbHFqWHhI?=
 =?utf-8?B?SzlWWUdpVjcySXh5aERiT1RodHNzOEpQSzRTKzc5MmpuYjlxcXVQQmZDeUlp?=
 =?utf-8?B?TVRiUm56Q0R3UWZLdGgyQzBlK0xQWWlCeldqa0lvTjlkdUFDWFNiM2FlbUZL?=
 =?utf-8?B?SVIySGJrMTZsM2hXUDUyNDRaVktxNUVCUjlzTXhCZS9KQjByVGlBcE16am01?=
 =?utf-8?B?V2YwTUNPeEV0SnV3SXdZeXpzMHJ4NE8rMUtTb1dtM1FNaVFOREw5Y3ZNLzEw?=
 =?utf-8?B?eG80V3RLdDNFYkxoTzQ3aDZ6eUJ0ZUZjRS80djhMT0tEeDQwSm56aE1PQWRk?=
 =?utf-8?B?dTNqbUNldldzaFpkMWJUQnZyTER5ajNyM3pHRGdyWGxRa1hoVHgycnVweHJv?=
 =?utf-8?B?NU5RTGxsVFJmUlgydWVWQ0dhaVFtd04zUnBRbytPb1dMYTZZQzREWloxRkhW?=
 =?utf-8?B?NVh2dkVTbm1GNXRtejdOS3dEWGhEL3Z0Q1h6T2xxV3RBaDQzVUxpZDY4a1Qw?=
 =?utf-8?B?ak5CZ0Z5QVFURSt6WjBnVlc0NnZvc21WeGw0MWlBUFRhdDE5eDVSdi92dzU5?=
 =?utf-8?B?RWJUZUkxam96VW8yS2g4cFdxOStUVXA2bkFXQnhCaDR1N3I2QVI4VzAxc0Vy?=
 =?utf-8?B?R1pwd1RiVWVHVG1nd3RwSHZITWpQeENYd1NDaWhmNDczZUFkZ2czODhzWWVm?=
 =?utf-8?B?MDV5alNpVVBxRmdiZmpZWFlidmdJMzhRRkszQUhublNTVndtUG5nd3FhOEFj?=
 =?utf-8?B?L3BYZWoxVW8rV2RFU1o1NVY2R1lBNXJTVWV3WkpPaUZUcnpIbk83TlZyVWhN?=
 =?utf-8?B?SlplWk1mMXhvQStqZlRwQTRJSC9kRTV6Rm1zRTVBNTl0SUFrUmFDcDVCK2JY?=
 =?utf-8?B?SU1vaWVKV0ZrZVRGckJjbEZsT1ZpN0hHVEthRlUwb0JMa2lXOTdYWDFhWjZN?=
 =?utf-8?B?bGY3V01MeHY1R1RRcUNyNURvcUpETG1GcUswQ0JDZE1yYk5SdTBDRUZTaWxa?=
 =?utf-8?B?WlNXeFNZOUtha1NuL013TG1zYVpiSXhuQlJGT29GM3cvbTA4eUo3ZHNvcTE4?=
 =?utf-8?B?WkZkRVVRcnVPMkxOVG5mWUdldUkvdlgwMXJTeHNZcGRPd0cvQ3BIbEsxcWJJ?=
 =?utf-8?B?Y0VIano1RW1vN3VQZm45M2xzU2hBdmlFaERBNWMxTWhyaURSMHJSVkhPU01p?=
 =?utf-8?B?Wjd1RWcxNEFzUVptT1BQU05hamZ3L0J4OFJ5K0NWa0lYb3dSL2pmZ0ZRPT0=?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?TWk0TXQ5UEdCMzYzMmZySCtEMmhuSWlWWVBiWGw1b2hEWFpvazhSa2lJUkta?=
 =?utf-8?B?VktyN0F1ZUhjWHE0akxnN09WMmNXbnF5V0VoSlo0b3pOV0JDZGVqUW1LTm16?=
 =?utf-8?B?c1ZXR3VTNmh3NDBCWFZtSG53b0NOdTBxMDQwK2FOS05JbktDOHZUaXRDS3l0?=
 =?utf-8?B?NDVwZzI4TEJOYkhlaWpHM3htR2tSU3k4UTExb2psQkNnRnBUUENENGxqUDV4?=
 =?utf-8?B?WmE5dzl1U2M1SjJGaXdpU3pBajZQdGNwLzlUVGJqZ3ZlU3BSL1BKbjZKdGpH?=
 =?utf-8?B?ZTFhQjNpOXVyZitKZVluaHVJeHZWaElVUzZsUTZUTDhHZ3BlU2xETjI3S2hL?=
 =?utf-8?B?dWZIRkNiendPbEg0OStNTXd6N0w0WXpORSsxTFBiRHdldGZweGhZOFF4UmdZ?=
 =?utf-8?B?QTdQZkRHb3Qxa1NSc2hvbm45TStrWVk2YjNPR2d2cW1LMnErRHV4NHdCQmZI?=
 =?utf-8?B?SmJmY0hhMEtlOGV1bUR3aFEyWWZBODFZNWVJS0dPbEZZOE5Gc09Qb2JVRGlv?=
 =?utf-8?B?bFEyZC8vS21Wb0tkUVNzYlRzakRaTzBRWGdWZWtnalo2UDl6QmJmMWxwQWc5?=
 =?utf-8?B?S3Y4VVE4Mms5T0JKR0dER0xUYmVKeHdvRkdTdkJPWkxyZmhtQndKaDBocWZ4?=
 =?utf-8?B?bGhhcGQ3YkZ1c1Q1WDNXUEorUVhZS1lYRGdWWnRsU3ZqTkNtbUh0dlA2M2tt?=
 =?utf-8?B?MHFkcGJaMldWUGlsZ0x0RmVJa2pIb01wSzlQY1IweFVjc0lWWitoUzBPRno0?=
 =?utf-8?B?VDRtVkhXV3p4MmxLZ2hVSGt3RWFlTVh6eFk1cmRVV3ZJMnBhM290ZlRYelBO?=
 =?utf-8?B?NHBYMGNDcmZFVGNpMlJqOTFiZlkvd1dYWU0zSXdORnpRVVk1MEhVdllrSWlX?=
 =?utf-8?B?SUR4YmZiZWJBSjI4QmhkVWZ5bzVSWjcrVlFZSFVkR205ZUN0dStMMkJqUGFL?=
 =?utf-8?B?M2ptVEIzOERYYjAvNTBySlFINjQ0MmJYa0tJOFZhdklWeTV5bGlqUXBqUm9n?=
 =?utf-8?B?RkZUbWdFcFFxUlRYMWZqREV4NnZlbE9YTVh2OU4rWCt1Qzc1bG9Rakcvd0Fz?=
 =?utf-8?B?Uk9BcU9zQnltdHQ1Y3FEb0h5STFDMHhnbUhQWE9BYWE2aVJEMFhENEJzVGF3?=
 =?utf-8?B?Vllhb2gvZXVid1huc1QrYXhrWUtTRlBvcEhLeGtsTjdqZjBDNmQzUEt6Z1dM?=
 =?utf-8?B?Rm02bUVWb1RYNmkzOS9iNEZocHhqZWE5ZXpzcy9RYktUa1FKZDNDOUdsZHFw?=
 =?utf-8?B?OUlWdmdvd25UK01WVnkwNTB2VTZzcnV4SHdQUkVDbVRNSnJvUGtsSG9XcWxK?=
 =?utf-8?B?bU1qTTQrbWs2cDBRQVlPbnQ2RVc2QVZ3aDRMZVZGb2RMQnRzMDNMZUlnYWVH?=
 =?utf-8?B?YnZ2K3JjN2FuemU4MWxIN3RyRG4xK3libC9xTy9ubXdkSTQ3aXNIeG80STlr?=
 =?utf-8?B?TmpadmY2QjNaZ2w1enJSRjhNTDZCalVwd1hzVjg4dTJHUFFQU2U5bFB6OUFl?=
 =?utf-8?B?TGtwVU55cDBGaXVmUXQzUEphUXdnZW9wYzM1eVE5MTFYUTVxTHNMcU8xbk1j?=
 =?utf-8?B?cUxZRHp1V0t1TlZoWjN5ZUpYcHIzNFhCak1OSDRKRDJEUi9HSzlVbE52QnZQ?=
 =?utf-8?B?Mnd4dVg2WHNXeS9iQ2VxdU9xRmFkKzJ1U2UvRmNYWngvdXplQllkd0NneHZO?=
 =?utf-8?B?S1ZjZ2I0TFZyL1FvY2tmbnBZdE1VWm5DQnNLVGQ5WUtTT2hxU0hCK3d4TWFx?=
 =?utf-8?B?KzJNbUNURXpNN1g1VE01amNuM0M0ZThyS3Y1SjhRY1N1ZGg1T1dtckJvK013?=
 =?utf-8?B?Z25aUTFHeUpMaVJSRnNrZDFJeU5xVTUxL0kwTFFEbytydW9YWUFRdzg5aVBS?=
 =?utf-8?B?R2NGYmE1K1NyZmpsQmx5U2lPMzlSQ2lnWWJ3Nmd1cnN1RmRXNTN2QWFURFhz?=
 =?utf-8?B?Sjg5TG9pdUx3NjVnM2lCZ3lCb2pJUHhRdGdlcEJQYTk4bVJkK1poa090ZjVz?=
 =?utf-8?B?d250S0lvK2l1V1k1aUdkWFg5Q3lIc010dkQ5OG1ZeG9LTlhrb0dxUmkwbTVa?=
 =?utf-8?B?cXFtanFrbDVSYTdHZkQ1R2tROTZ4cmJNQmZ5VEpPbEVZTlJmV1JwdHNTdjFv?=
 =?utf-8?B?QVJBS0REZnFxL2RiZStqQlc3YkJzQWI5RXZBcGtUUGVBRWxFMFQyekh4WDNv?=
 =?utf-8?B?cEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <44CDDF72814B2C4D8A835225658354A6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	+k40cc+m0Qo9IDewXcJ/7wqGBH30iQqcatU1t9HBy5SEBksok5TsqCv89l2KnSbNn5aqHJRk+o9AFuLVCUycIbzZBoZifyoWDqBuWd+/JGtofxiQJKn1mlbVVj6mBEYc4Q9BCXTHOSXNlvBUqPOjoSvt1Af/ZwEq/ep9PY1mmThqgyqOW3WERSZuH9qIX5FbFVP2e60tHt5EXjSYx2MfpJnMPxgggIiyzjyzjLe56h4bpV9d8PzfCsFt92hEf7vN5gTql2Em0kJwOA1P9m7Qe+zAnhkshRS15fIsg9E7PhZ0XvEtT0yDaoSAv9T9BMSRpOO+JbEWMlFCcEJs1S15NFJf2M4PP7PkdV3OPdMqA+lRbuBFtyHlK4JQS6HVWnCUJpqvIaCm+EV+7IChluPx07p77RUJq9nsggailriRxuzliOwWXyAliHt0QSSHPbkMopEyVeX13eQVWxD31sfXJfHx9dUPontv/2JA0+5R4SeFG20rwULdAHkLBrG98HmFlhN0M/qJDLzSy0HgUe4oJ/HvCehXWUjGZ2fOFL2fYzHDDj1pTItlEP08eZ6y6shPlSzdrJ7YKu8ppIMbGQ/VAHDrdE9jlwsqA/rERvBpehc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de3b6675-8c8b-4ffc-00c4-08dc7f6e9681
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2024 23:33:32.7644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kqMf6vhms6EZg4O0JKCj69+7s4K+1W7Rh6gDsFh2e2qMw6DnEqeiec+VlgDH51RN1L41+dlxumZy2RfEUTMNPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6327
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-28_14,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405280174
X-Proofpoint-ORIG-GUID: vz5OkqOHF6akDzIjkP4ATbkSk7ftr3e5
X-Proofpoint-GUID: vz5OkqOHF6akDzIjkP4ATbkSk7ftr3e5

DQoNCj4gT24gTWF5IDI4LCAyMDI0LCBhdCA2OjAx4oCvUE0sIE5laWxCcm93biA8bmVpbGJAc3Vz
ZS5kZT4gd3JvdGU6DQo+IA0KPiBPbiBXZWQsIDI5IE1heSAyMDI0LCBDaHVjayBMZXZlciBJSUkg
d3JvdGU6DQo+PiANCj4+IA0KPj4+IE9uIE1heSAyOCwgMjAyNCwgYXQgMTA6MTjigK9BTSwgSm9u
IEh1bnRlciA8am9uYXRoYW5oQG52aWRpYS5jb20+IHdyb3RlOg0KPj4+IA0KPj4+IA0KPj4+IE9u
IDI4LzA1LzIwMjQgMTQ6MTQsIENodWNrIExldmVyIElJSSB3cm90ZToNCj4+Pj4+IE9uIE1heSAy
OCwgMjAyNCwgYXQgNTowNOKAr0FNLCBKb24gSHVudGVyIDxqb25hdGhhbmhAbnZpZGlhLmNvbT4g
d3JvdGU6DQo+Pj4+PiANCj4+Pj4+IA0KPj4+Pj4gT24gMjUvMDUvMjAyNCAxNToyMCwgR3JlZyBL
cm9haC1IYXJ0bWFuIHdyb3RlOg0KPj4+Pj4+IE9uIFNhdCwgTWF5IDI1LCAyMDI0IGF0IDEyOjEz
OjI4QU0gKzAxMDAsIEpvbiBIdW50ZXIgd3JvdGU6DQo+Pj4+Pj4+IEhpIEdyZWcsDQo+Pj4+Pj4+
IA0KPj4+Pj4+PiBPbiAyMy8wNS8yMDI0IDE0OjEyLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3JvdGU6
DQo+Pj4+Pj4+PiBUaGlzIGlzIHRoZSBzdGFydCBvZiB0aGUgc3RhYmxlIHJldmlldyBjeWNsZSBm
b3IgdGhlIDUuMTUuMTYwIHJlbGVhc2UuDQo+Pj4+Pj4+PiBUaGVyZSBhcmUgMjMgcGF0Y2hlcyBp
biB0aGlzIHNlcmllcywgYWxsIHdpbGwgYmUgcG9zdGVkIGFzIGEgcmVzcG9uc2UNCj4+Pj4+Pj4+
IHRvIHRoaXMgb25lLiAgSWYgYW55b25lIGhhcyBhbnkgaXNzdWVzIHdpdGggdGhlc2UgYmVpbmcg
YXBwbGllZCwgcGxlYXNlDQo+Pj4+Pj4+PiBsZXQgbWUga25vdy4NCj4+Pj4+Pj4+IA0KPj4+Pj4+
Pj4gUmVzcG9uc2VzIHNob3VsZCBiZSBtYWRlIGJ5IFNhdCwgMjUgTWF5IDIwMjQgMTM6MDM6MTUg
KzAwMDAuDQo+Pj4+Pj4+PiBBbnl0aGluZyByZWNlaXZlZCBhZnRlciB0aGF0IHRpbWUgbWlnaHQg
YmUgdG9vIGxhdGUuDQo+Pj4+Pj4+PiANCj4+Pj4+Pj4+IFRoZSB3aG9sZSBwYXRjaCBzZXJpZXMg
Y2FuIGJlIGZvdW5kIGluIG9uZSBwYXRjaCBhdDoNCj4+Pj4+Pj4+IGh0dHBzOi8vd3d3Lmtlcm5l
bC5vcmcvcHViL2xpbnV4L2tlcm5lbC92NS54L3N0YWJsZS1yZXZpZXcvcGF0Y2gtNS4xNS4xNjAt
cmMxLmd6DQo+Pj4+Pj4+PiBvciBpbiB0aGUgZ2l0IHRyZWUgYW5kIGJyYW5jaCBhdDoNCj4+Pj4+
Pj4+IGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zdGFibGUv
bGludXgtc3RhYmxlLXJjLmdpdCBsaW51eC01LjE1LnkNCj4+Pj4+Pj4+IGFuZCB0aGUgZGlmZnN0
YXQgY2FuIGJlIGZvdW5kIGJlbG93Lg0KPj4+Pj4+Pj4gDQo+Pj4+Pj4+PiB0aGFua3MsDQo+Pj4+
Pj4+PiANCj4+Pj4+Pj4+IGdyZWcgay1oDQo+Pj4+Pj4+PiANCj4+Pj4+Pj4+IC0tLS0tLS0tLS0t
LS0NCj4+Pj4+Pj4+IFBzZXVkby1TaG9ydGxvZyBvZiBjb21taXRzOg0KPj4+Pj4+PiANCj4+Pj4+
Pj4gLi4uDQo+Pj4+Pj4+IA0KPj4+Pj4+Pj4gTmVpbEJyb3duIDxuZWlsYkBzdXNlLmRlPg0KPj4+
Pj4+Pj4gICAgIG5mc2Q6IGRvbid0IGFsbG93IG5mc2QgdGhyZWFkcyB0byBiZSBzaWduYWxsZWQu
DQo+Pj4+Pj4+IA0KPj4+Pj4+PiANCj4+Pj4+Pj4gSSBhbSBzZWVpbmcgYSBzdXNwZW5kIHJlZ3Jl
c3Npb24gb24gYSBjb3VwbGUgYm9hcmRzIGFuZCBiaXNlY3QgaXMgcG9pbnRpbmcNCj4+Pj4+Pj4g
dG8gdGhlIGFib3ZlIGNvbW1pdC4gUmV2ZXJ0aW5nIHRoaXMgY29tbWl0IGRvZXMgZml4IHRoZSBp
c3N1ZS4NCj4+Pj4+PiBVZ2gsIHRoYXQgZml4ZXMgdGhlIHJlcG9ydCBmcm9tIG90aGVycy4gIENh
biB5b3UgY2M6IGV2ZXJ5b25lIG9uIHRoYXQNCj4+Pj4+PiBhbmQgZmlndXJlIG91dCB3aGF0IGlz
IGdvaW5nIG9uLCBhcyB0aGlzIGtlZXBzIGdvaW5nIGJhY2sgYW5kIGZvcnRoLi4uDQo+Pj4+PiAN
Cj4+Pj4+IA0KPj4+Pj4gQWRkaW5nIENodWNrLCBOZWlsIGFuZCBDaHJpcyBmcm9tIHRoZSBidWcg
cmVwb3J0IGhlcmUgWzBdLg0KPj4+Pj4gDQo+Pj4+PiBXaXRoIHRoZSBhYm92ZSBhcHBsaWVkIHRv
IHY1LjE1LnksIEkgYW0gc2VlaW5nIHN1c3BlbmQgb24gMiBvZiBvdXIgYm9hcmRzIGZhaWwuIFRo
ZXNlIGJvYXJkcyBhcmUgdXNpbmcgTkZTIGFuZCBvbiBlbnRyeSB0byBzdXNwZW5kIEkgYW0gbm93
IHNlZWluZyAuLi4NCj4+Pj4+IA0KPj4+Pj4gRnJlZXppbmcgb2YgdGFza3MgZmFpbGVkIGFmdGVy
IDIwLjAwMiBzZWNvbmRzICgxIHRhc2tzIHJlZnVzaW5nIHRvDQo+Pj4+PiBmcmVlemUsIHdxX2J1
c3k9MCk6DQo+Pj4+PiANCj4+Pj4+IFRoZSBib2FyZHMgYXBwZWFyIHRvIGhhbmcgYXQgdGhhdCBw
b2ludC4gU28gbWF5IGJlIHNvbWV0aGluZyBlbHNlIG1pc3Npbmc/DQo+Pj4+IE5vdGUgdGhhdCB3
ZSBkb24ndCBoYXZlIGFjY2VzcyB0byBoYXJkd2FyZSBsaWtlIHRoaXMsIHNvDQo+Pj4+IHdlIGhh
dmVuJ3QgdGVzdGVkIHRoYXQgcGF0Y2ggKGV2ZW4gdGhlIHVwc3RyZWFtIHZlcnNpb24pDQo+Pj4+
IHdpdGggc3VzcGVuZCBvbiB0aGF0IGhhcmR3YXJlLg0KPj4+IA0KPj4+IA0KPj4+IE5vIHByb2Js
ZW0sIEkgd291bGQgbm90IGV4cGVjdCB5b3UgdG8gaGF2ZSB0aGlzIHBhcnRpY3VsYXIgaGFyZHdh
cmUgOi0pDQo+Pj4gDQo+Pj4+IFNvLCBpdCBjb3VsZCBiZSBzb21ldGhpbmcgbWlzc2luZywgb3Ig
aXQgY291bGQgYmUgdGhhdA0KPj4+PiBwYXRjaCBoYXMgYSBwcm9ibGVtLg0KPj4+PiBJdCB3b3Vs
ZCBoZWxwIHVzIHRvIGtub3cgaWYgeW91IG9ic2VydmUgdGhlIHNhbWUgaXNzdWUNCj4+Pj4gd2l0
aCBhbiB1cHN0cmVhbSBrZXJuZWwsIGlmIHRoYXQgaXMgcG9zc2libGUuDQo+Pj4gDQo+Pj4gDQo+
Pj4gSSBkb24ndCBvYnNlcnZlIHRoaXMgd2l0aCBlaXRoZXIgbWFpbmxpbmUsIC1uZXh0IG9yIGFu
eSBvdGhlciBzdGFibGUgYnJhbmNoLiBTbyB0aGF0IHdvdWxkIHN1Z2dlc3QgdGhhdCBzb21ldGhp
bmcgZWxzZSBpcyBtaXNzaW5nIGZyb20gbGludXgtNS4xNS55Lg0KPj4gDQo+PiBUaGF0IGhlbHBz
LiBJdCB3b3VsZCBiZSB2ZXJ5IGhlbHBmdWwgdG8gaGF2ZSBhIHJlcHJvZHVjZXIgSSBjYW4NCj4+
IHVzZSB0byBjb25maXJtIHdlIGhhdmUgYSBmaXguIEknbSBzdXJlIHRoaXMgd2lsbCBiZSBhIHBy
b2Nlc3MNCj4+IHRoYXQgaW52b2x2ZXMgYSBub24tdHJpdmlhbCBudW1iZXIgb2YgaXRlcmF0aW9u
cy4NCj4gDQo+IE1pc3NpbmcgdXBzdHJlYW0gcGF0Y2ggaXMNCj4gDQo+IENvbW1pdCA5YmQ0MTYx
YzU5MTcgKCJTVU5SUEM6IGNoYW5nZSBzZXJ2aWNlIGlkbGUgbGlzdCB0byBiZSBhbiBsbGlzdCIp
DQo+IA0KPiBUaGlzIGNvbnRhaW5zIHNvbWUgZnJlZXplci1yZWxhdGVkIGNoYW5nZXMgd2hpY2gg
cHJvYmFibHkgc2hvdWxkDQo+IGhhdmUgYmVlbiBhIHNlcGFyYXRlIHBhdGNoLg0KDQpUaGFua3Mg
Zm9yIHRyYWNraW5nIHRoYXQgZG93bi4NCg0KDQo+IFdlIHByb2JhYmx5IGp1c3QgbmVlZCB0byBh
ZGQgInwgVEFTS19GUkVFWkFCTEUiIGluIG9uZSBvciB0d28gcGxhY2VzLg0KPiBJJ2xsIHBvc3Qg
YSBwYXRjaCBmb3IgdGVzdGluZyBpbiBhIGxpdHRsZSB3aGlsZS4NCg0KTXkgdW5kZXJzdGFuZGlu
ZyBpcyB0aGF0IHRoZSBzdGFibGUgbWFpbnRhaW5lcnMgcHJlZmVyIGEgYmFja3BvcnQNCm9mIGEg
cGF0Y2ggKG9yIHBhdGNoZXMpIHRoYXQgYXJlIGFscmVhZHkgYXBwbGllZCB0byBMaW51cycgdHJl
ZS4NCg0KDQotLQ0KQ2h1Y2sgTGV2ZXINCg0KDQo=

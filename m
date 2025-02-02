Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C012746D
	for <patches@lists.linux.dev>; Sun,  2 Feb 2025 13:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738503002; cv=fail; b=mmeKpLF7FC5ze5IU29F8BYQUovJElVXvr1pvE9LV0cg9Iq8XbDKd1hziXjPPnechDHyoy+eAqq/r2GXoR58iLyZt1anGZpv5aJj3lT64wzUiGTBiF6K28d4pIxieGfvLv0Woe7fYOaT9dS0+dIUoEuUGGhZFbV5jgMAAk5KFv70=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738503002; c=relaxed/simple;
	bh=21//brj3MBHb0kbUMBoNYxp25Xv0Qe7eivgxQMv8jJY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DmDGmSOOvXJ4xy4sND+MUbnx7iXdtWEbBgEr0/W9VsbcS8yN+DwEHXJIBPno5nlRfmj3P9aQ+17PczL6FNo/xBZyVN4u9flB7zDGrzTU2T3+F8t9enW3kVWhMZfdUjDJBGNarewZW3mcGFstNr8BaByrijrvmbB261mbvhW9F3I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nCc48S+r; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BYID04kP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nCc48S+r";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BYID04kP"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 512Ctmsl019416;
	Sun, 2 Feb 2025 13:29:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=iPQYAzh6CmsIu0QH7stmyfGG5FIa26YXnEhCuoA7tv4=; b=
	nCc48S+rxA7Hp3Abm0VLYNALnr5QXX91azI481no0T3WtXJHagnwVR5Vp9GArfue
	sFwaJR7jO4CfcI38/rkM2CO3y1Uivd/Gd6P/QPqQkroJK00Ic4TnhFCfe+MOw+4L
	QS6lwBIdDAiuqcq18cQ+WPHigZGXrZmZGO1KkBncMcTKxRKoXJ97pYTvHGs4Q9Ev
	WgKXiGSpQX1UJ1gbAMKIKCspqQtlPJMk4ZanVzU6Fm0NBDdw/3MDR9qtVpFofknI
	+CvWPrDxkwmWLBViT233hR/lvlM1sz/v6fYHdQIAqI/0XCyDBiXOYHQDMOiBkb6Y
	l3TAdxrDLTFmQBExZsvAnA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hfy8155x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Feb 2025 13:29:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 512C9kBm036141;
	Sun, 2 Feb 2025 13:29:36 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2177.outbound.protection.outlook.com [104.47.73.177])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8fj10j7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Feb 2025 13:29:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d8tJwiRFMGXh7J+t1vTcW6QoTHlDUqXtIKKph7fc+kXaZMWrbV/G989RG5NnNfsjgKMHcYU1rF0Ykt4Iau3EeAtQsRTn3GaCYDBYeTuiSbC72rZx0OBJ7ROxm8rFVkXgM2QKsUK9Ma43eu2ZSU5mWYeTvwravv01xD/qm6V82y5zI/io1LSM8HiWzwu6PeMOz4UexrzdBU8EBcR5i7Hhe1uXBJ0LT3dGb5SFbYnqQ1b0gejgPmNPeEoxm+hlzjewjexERTCbwII7CXASBTxyKpo9K6gXePNwUmmr+atyvt60tUHnpNZRAlWS6E83gza7P3oeoq6sB5YhZogaAJ6I8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iPQYAzh6CmsIu0QH7stmyfGG5FIa26YXnEhCuoA7tv4=;
 b=CtKKad+N/EJv8U3b+Kx6SPgsbe6qwYgH7vYqpgndj+9ZTBdq0G3VcnutayTmA5sSlVpbks/WoY7fvZOI8UoLtGBR/La95A+MBnNncYewENPE416YIfHda4bbbCra6ADMX5p6N9fBZ0duK6of0iIG3XtTw+8YY2B8s7PjxzmOl/b1235+DKv9Rci1P1q7v3jellnJRrT0SWNXt/eOV45cI/Q9l/Bop74LwmXbLQjjpp6fuBLmiLtb8mOM9KJKfSHDB3sHwb99VEjM+RghrB/jNdkoIVfoZF4q8fMVuAvrUhV+ypx2SqnhtCo4O2YiUp/G39QSuDJZnBY2GKYHe9djMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPQYAzh6CmsIu0QH7stmyfGG5FIa26YXnEhCuoA7tv4=;
 b=BYID04kPX2KOLgXRPWVLwApi0rKLXQaRsBc/WHgOFGtt/JSrXLXnu+AvmZRLUfX9f2lkkaqGpBAbakDUsD0d1R/YqOmx+GOZgY23UuTqlpVML8jtIvRsnzhLoTi0nsxv91uC4ftoRD7swkTvl0/fIJlTt+g1Fc8ye9AvbRKnh3g=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by IA0PR10MB7381.namprd10.prod.outlook.com (2603:10b6:208:442::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Sun, 2 Feb
 2025 13:29:33 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%5]) with mapi id 15.20.8398.021; Sun, 2 Feb 2025
 13:29:33 +0000
Message-ID: <1b1ea59c-8669-4465-8ad9-eb01b98f1ad5@oracle.com>
Date: Sun, 2 Feb 2025 18:59:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/41] 6.12.12-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20250130144136.126780286@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250130144136.126780286@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0012.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::8) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|IA0PR10MB7381:EE_
X-MS-Office365-Filtering-Correlation-Id: fe6cabd7-4b63-4559-baf3-08dd438da0fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V0tVbkJmdTMyMnZDb3h6ZWNDaXVOT1lFZDU5NUZUdGgxZlhxRlhWS2dacEJH?=
 =?utf-8?B?QXl6MW9hK2J5djhWTGxUbWt2ckpXQzF5QVg0ZzlkdW4zQnN0N0Jsak84U05s?=
 =?utf-8?B?NzVxZGtFSjBicWhXWUF5dVpTNTdzOEErd211MUhUZzRUMTlMcE1XeTVOS3VV?=
 =?utf-8?B?NUIwK2pNL0xwZUgyOWNHYUZTS1lGUVUrL2ZGR281dHRVTmgrem5zSU42U3hu?=
 =?utf-8?B?SGVMK1lROVZiWUlSZFhpOWlwTUJpVXFVUnZRVVE2R3J6ZklpeUlhbVNoWTdo?=
 =?utf-8?B?V0czNC9zbDdpdm4zN1pWamFwdVNNNHNpdHFPdFYwbmFRZlBxV09sQzR3L3d5?=
 =?utf-8?B?ZDRsTitaKzlJWGljZU5Qc0Q1N2lQUjdiQkRPQjVlcFcyL0RnQ1Z3ZlJqNVJp?=
 =?utf-8?B?MmRKTkY2cGsyd0lNNVJNUjhKVzFxWVR0TTFTekJYck1uWmkxdDRhUjhSZGhh?=
 =?utf-8?B?OUpwYjBnejROTXdTSnpid1lDa2FBT1IrenVZWXZncmZsNk9UUHRKamNQOElt?=
 =?utf-8?B?MUpwODR6QXE4YUtwUXpKekVWcXNuUXVMQW9MOGNKV003WGJNeHZCcHErTDZW?=
 =?utf-8?B?K1pWeFFqZGc5V3djV2tmSHVBY3FtZjhrdDBlWFZOWXA4cmtZM3lIRlRVN1ZZ?=
 =?utf-8?B?K3RzdnJZcUdVRFNmRlJSckliWHFkWERHdHdWbDRFUVhaOVg5T2JBK3FCclF1?=
 =?utf-8?B?RFdZdk4vMGF5MVNjbFcxaFdYMnpsQmZML0hVNER3aFBxUmMzYzBPc1JlZk1q?=
 =?utf-8?B?ekZvV1k5WGY5OG0razdPcTBoc2h2MzduajBsU2hDamNmUVRnNE1nMmhGTGtH?=
 =?utf-8?B?UlRwRjJUdUN0L0ZNQzVsazJlNVhsK0tGeGdBUnJZQ0pYdTVFekY5enA4NU81?=
 =?utf-8?B?LzFuRWxRZEZOR0kvSTgvTHV5ekNTQTFuL2p5aEhvM2IvU1NLSkQxMXpaVFFk?=
 =?utf-8?B?MVByTzhmZFhhbTZ5dGdqZGY0TWNWZndTMkMra1RMRVQxbjdKZVFRcWdmbjBU?=
 =?utf-8?B?WWdOTUVFYXJPVW1DL3hZSTVodXdYM1FMZHZYWit1THZNeEpZNnM1a1FVR2NQ?=
 =?utf-8?B?WENUaUJIbzFMWHNiNTZxcnRVd0FSdXVNNDhCUDQ0OUEyOEdQSHJFU1lBeWxI?=
 =?utf-8?B?RVc0d0Q3bStRYU0vNWVNNGxiNU4vaFVWTGwweTVVZ0NZbjAzT21HRFpBZDYr?=
 =?utf-8?B?STY5N3hQZ2dzVWxyQ0YwenRFWkVCRy9DbWxlSHNJakVQVnBkT1hEYUJ0VjZW?=
 =?utf-8?B?bmxrY01BZndFL1BBRWxhWlZXNmhJdGxyaHYxV2prd1RVQ3o5NVZmbDd5bkNU?=
 =?utf-8?B?ajZkYXFCRE9rZGs2VWRQeXdsR2Fra2tiMFJoR3d6R0d5dG9ETEttaWc4MDNp?=
 =?utf-8?B?bmYxb3JwcTZYamthS2pUcVdZenpiR0RWWDdaNTZnYk54aGRKbFBpRmZsc1F6?=
 =?utf-8?B?WHZiVG53Z3VwbTBHK2VwSHJ6WjQ4M1FXT3BQVjIrNTYwMzcrWVhXT2krZE1h?=
 =?utf-8?B?Z0ZOVkgwUVBoM1BsSnZxTGhoeTVDZ3o0eVowUnVvOHNHQ0w5WGQzcUM1Vnky?=
 =?utf-8?B?R2xGdExTZFcyY1FyZjdaNndNb2E0RUJVQ0thbnJBZVhzdUJUSFpmTzJOWW1J?=
 =?utf-8?B?aTdWZitmMDExVFR5K09XbVpLanZVVEdtU0xSQnVKbXhzUUZZbExkWStBMksv?=
 =?utf-8?B?Q2RvQmtaS00rWFpiTHpmQ0J5aDY5MldaekJ1bksvZklqNHlyZlZYbEcwS2hY?=
 =?utf-8?B?REV4WWhBeExiWTdJWVh1Q09XUlVZVkxURW5UYWY1KzZOVG5FRG9LQTBLeUdE?=
 =?utf-8?B?VVE3ai96bS85TWNpL1d1U0NEVWQyak5venhpQWh6QXNLN21QV2ptaUNMN04y?=
 =?utf-8?Q?fOGpwmYvXGyTI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WTZIOEQ0VmUwM0RKdE1TY0xVbVlGZ0xCQlpDblJKOW9nWTBPUjU0d1E0WVJN?=
 =?utf-8?B?enNLSmFuUC84NEFKWFRHUXhmOVl0T1h6VFRjWWxlUUZDU2FtNnhXMThrajVE?=
 =?utf-8?B?eS84T0dxZUczbHFkaU9tSURKUmhkcTNYSDc1dm5Zb2tuY3V2RFBDeEV4V1pj?=
 =?utf-8?B?VnhLMWVLNDRyak1ZUGluaFFEcHFIUC9CQjUvMG1FbGNpdXl3QWUyVkZYdUE4?=
 =?utf-8?B?L0lIQy9sN203V3dyOGtNRDAwV1ZCVEMxdjQ5R2JDaEUxTUw1TjVxeVkrbXVx?=
 =?utf-8?B?V3orSThRdXkwTmhrdmpNdGhFUmdONERMeTBMNzIvY0oxNkphTCtmdXFQYnl4?=
 =?utf-8?B?NGhTT1lyS3poNmw3Y2tWQTFCV2lnN3BadnRyTzZUUm1MeEVDa1N1YkpKNWdX?=
 =?utf-8?B?SkxGWWFqdE5RRFFtaklGN2JPbXFERFpEQzEvTnVUc09hSW5mYWd2ZE9abVVP?=
 =?utf-8?B?dVZ4eEZBZk4xS1ZScmJHTGJzM0kva1FaZGVWamFIUTFaUW1WaTB2TGRHdkxz?=
 =?utf-8?B?Y0RDTXV4MDZaSEVxVkdjUjFDRjRkN1JmVy9Sc0hkSXlsbWd2MUQ5WU83WDVj?=
 =?utf-8?B?NFJzdjNTWlh5cWM4L05VbkdHampSeUN4MGdmdVBXUzQzTCtnbURiNllrcDhk?=
 =?utf-8?B?aGNDNG42d1BIQ1BNREs4bkdzeEVRdWQ3TWI3OWVOWVVGVjBqWmNDOU5PZ2Rt?=
 =?utf-8?B?YjU1aFEwb21NTEhWNlZPb2pCMk53SHhkNElENmtkYXpNM3RldkorbjNaVklS?=
 =?utf-8?B?R0U1NmVWbnhkQmRpdE84aGxINUJJaU43OWs4VEROUnhpRnduNlBYdjRESmpi?=
 =?utf-8?B?N1dEOFFpS1FRZEUxVlNZMGs4M3ZWNEMxU1VkWmtmaWREUVpaOFBvUUhGQ0hq?=
 =?utf-8?B?Z3VEMHkvemFnS2dsMnpzN1YxNlJteVU3OGxXZGdWL001OWF0ay9kSHZ5cGRS?=
 =?utf-8?B?L3JrRWo5b2ZSWVNoSjhCaUEzbWZSNWVaVHVQaWpNSVhBKytOQU9CNzBXMnFC?=
 =?utf-8?B?YnBKVndpWThCTjN4dGlRWVRZMFlMTXlQMkxCYTVQOUtubXdQRlJDNDdhdzFk?=
 =?utf-8?B?S3J4V2dTRWgvRm5RRkdhVGtqTW15TkFzVHZJMjM4L29yNXYzSmFxNHBuaHJN?=
 =?utf-8?B?TDJtcnNsSSt3NmRkaml0ekxxTzd1SmpmNGVWaWFIczYrMCs0d09tcDNXSmcx?=
 =?utf-8?B?cklhb2xYcUxTSkVRQ2tJT3pJRE9XV1hPQXd0KzBKdENxZkcrd1ZPdGNyTnBi?=
 =?utf-8?B?N2VBVHZrQmF3Zm1BSUJndFZzT3dFdUlEUG5ZdzNRbG9GSHhhVGFqbTQ0OFNx?=
 =?utf-8?B?cWpRcTUrNUIyNzh2R2xrTWhEcGxWOUlNVUo5K3pMclZxUjFoRFdTS2dZWHNE?=
 =?utf-8?B?V2toZ1hVem1FSzdGazIyMmVQTHBEQUVlcnNKYlY5cHhBTWxHcWF2aTc5THdY?=
 =?utf-8?B?ZFJXS2s5THpUU1pRQ1NBUW4waFRhMm1CL01Pc1dwQjl6VlJpWHFEMFUzQmg1?=
 =?utf-8?B?WldhZVUwOVI4NlRHQ3VuaHB2NVllQTluejE0K2hCUUxqR0hKQUVkNjd2YW9t?=
 =?utf-8?B?aDh3NnRFako0dmh5VkNPWlAxYjVib0FVZW1iRDV0N3V1TDJmdDkzTFVIdE1I?=
 =?utf-8?B?bHZXZVBtVTQ3TzNTNk5YVFhmUERKNWdYL3RPcUhmeFlOR1NEWUxxam1IV056?=
 =?utf-8?B?dmZjVGxQWDFEdEVXL0wzT29jaW9NVU1hMGw0aVVLN1FjTnNQNmI4NUpaUnYw?=
 =?utf-8?B?VWFZK2NKbFBPakdiNFJBeGpjS1RJcm1IQjBTUlIyRENjQmdSKzBKemxOSWVY?=
 =?utf-8?B?WHp1Zitnb3V5Tkt5ZU45Z2xON01YaXZlTkJwclpiQm5KOXl6RHk2UkxMSG5j?=
 =?utf-8?B?b01ET2xqTXZLckJLdlVsZ0J0ZTBpU1h5UjlvUDRHbFVnaGx0N0xSWWRaUDFR?=
 =?utf-8?B?TlFZQ2dOb2RxWEVQNmZ0alpjTkdzaDRxRnBYcTF4SEFWc2ppZitLYWlGZUxx?=
 =?utf-8?B?ejJMMzI1d3JvdHlKMzYrUmFJci9vQy9rRHRCMU9hc0lqN3FzUTVuWkI4dTVE?=
 =?utf-8?B?RU81amprclB5M2gydnFBQlNqNkJiUTBVUTNoemZlWUVJSUt5Qkh6R0J2aHlt?=
 =?utf-8?B?MXpUYTBRbTlvdnNhbGJTYXJ5UGszejdHT3I5bWJMMjVublBOTGR6QVZVbXkx?=
 =?utf-8?Q?3LNfIEK3OVRyvGQgUmNruBo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MLmBw+zFK6IfASrw73D09gaLjdDDqbJ6NwR+IKKnrOZv1MU8lsjKnker4W7zLU5lBNeVDB5VFQMeRmZTl6UBjz4cRdTWrFWsRQhkVWkc1TwoxFi1FN7CjtH9z+EYCbJoXpLNULbH9Qv5KfQS68LH1LDMJKIbKbiz4DGT4VwS7Z0K429r7yEO0Qfxvvz3PLuNtD7NiHCsTNy17GElAZcIi8V1CH/Y7/Sh2eIltRCZvrZJDNoWAE56E6+v2/L1t9kUSrel1ESkMbnHcf2cGSMyT664QsjtKUHdZsOom/bYVNeHmQrHyF2o2NakcMQPJzPYLyNHRzmXhKA/KfMiXcnnYn08PCAcUtGGz4kb4eeIawx7w8ZHsaOGA5t1hp/HJZoutbcMbq+P1WaxVBPCx85nioZDRWuM/Gp31tTlLeLkGcIgJ/M/h2qhXoSPNjmbaE6Qsn04XhR7xAQY7LAhjD/dhSNYA5GJi+wO7B5CFL9cXZ09m8NF6yMfNG9P3ODeAuoueykETS8hhkieNQb8pLIKb2zXf/+C3QFtK1dbqiR3rS6DaC3xlbsb3kxTpfy3RW/rvUdGziBVPZqO1ZN5I30y2mP3gWmsjHnbn49Wxsdkf4Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe6cabd7-4b63-4559-baf3-08dd438da0fd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2025 13:29:33.0322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fD5csMWmyme+I2sRFwQ8VcleuYz0khrfnqjaR3Pdn3bqFw3Un9Ppm2mfn5CJ7n1jZlgtygwvWFj4u5SBXrx1DnSBCqcIAp8PCDfpgYXM/0lcOYzv6nsV95a7316QUckh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7381
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-02_05,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502020120
X-Proofpoint-GUID: z2mYYzzI0hpWbbQwGs3e-6PWpL5r7au0
X-Proofpoint-ORIG-GUID: z2mYYzzI0hpWbbQwGs3e-6PWpL5r7au0

Hi Greg,

On 30/01/25 20:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.12 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 14:41:19 +0000.
> Anything received after that time might be too late.
> 

Sorry for the delayed response, I thought it would be good to let you know:


No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

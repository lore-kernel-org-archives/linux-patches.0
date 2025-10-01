Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916A218DB01
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 15:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759332124; cv=fail; b=HRLMTbHIqAQuNT+cTOVMYAaM5SC0nNDyZtMYUvBBb0OUx0jBymgPBSeLZgNqsav4agCYWEXJ5BIybCLu6pDrltnmLhJPd85wwsMmsxqwmqSuRFuQ5kh12utNPmsgmPkzBBeshEwsTeXf4Gin00bCER7z3wilCgTfTYtmq+lZwU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759332124; c=relaxed/simple;
	bh=/3LPKuob5T9IVaYHHc55AU9x7chERw8d4E0jHZ734AA=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ecyfPJwTb+P6VMfVyTKRXSEKCafPjaU1/MUE3Egp4k4BHUhHtPjPEqq2u7YWeU/a5y305uZeeeFJjC3z0psDdwNMB+nStw63Mca2C4FYTCn8FvKc8iWxexFHF7ghCvHleL6hNcb5tYFGqTIPbOgnWi93WZBaS31Q7Y6DcfiEu0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VAI+IoqS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=X6LUsY5c; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VAI+IoqS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="X6LUsY5c"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 591CrEgm014306;
	Wed, 1 Oct 2025 15:21:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hei9KAlZ1uBCy2R5Pw/OKZIRZyaS152X3ijai4QbeK0=; b=
	VAI+IoqSVu2oz0rUL8kji/zWzlGv6M1hI7fCK8YMN17IYtH+uY5G8NCuPplzmOLB
	Zwv2P1nOXkt8TFNTW/h1TgmjaQ/NrkXuoMM/MoUBorwevp6wLvvaH3v5dGYKv98l
	JC8xMISAfbV4XjjmD87rpvS6+7w3OiOSo1nlbSLV7poTkepJj9IkVDgBf1OjuXAL
	aWHSEGPRu/9A5uuLUP1/H02o+Xyp41Zkl2FNUBwCCrQ0Dn+8tFPZ/xrceeUxRB06
	XFdUM6WQKEXf0bCkq+cWtpUS6IwiaaStFAKDBENNhe+2n4v1Ef1XmOkfWMNsXsF/
	5DSa8zqNMgQlJPszdA43Tg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49gmrfskrd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Oct 2025 15:21:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 591ElYEm012292;
	Wed, 1 Oct 2025 15:21:40 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012042.outbound.protection.outlook.com [52.101.48.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c9bh0h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Oct 2025 15:21:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a/kvdfltpqx/mdsmw5N+QzynYfbhGpt4iIPWhc977QufMOh7lrKN4nuBJVMa73Xx9U1uJkqGRG8kZ2JJQ/Lt71LUaPEHNf+JG6n9/QTXBmD19k8P49Jf5keiv9hQB3qOScMu6zAfhO7pJSqJPevoAve+qiSeqi+iVE/rTs3exnqVF259AratKpdxHqt27YqbXz8lDI4uEyEXzo2goEjaShpzC2b92w3L9WNszwbXFSLpdzlRClM6tG2JDjHG0PMBDebXFkHyHIfjaD8YVeAstZ7o317wdUpCGA2JjHTe+Cy0vRPKrMf8ZiDcBuuGafb6vIOZ6HH52QVLttl4y0Mghw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hei9KAlZ1uBCy2R5Pw/OKZIRZyaS152X3ijai4QbeK0=;
 b=C62V73KqhHsj3pdJa7rVipws8VUT6TCblSBq0mzf+vhM+Ly1xc2HNHIKUpHnllZ2+zAWVnHA+fR3aMK2LZJOyfGqIs4pZ/Rqg3L3RhdD4GascCK8r35F3XZyFw2AluLHB1YI0s/jUycGqc1lxACCCn2fke2eVGvShO0v/0nDA606T761yeaPRkWsn5ADd+hyA4Bs9LYYrIS3WXlcbk8dPgnZkTiBOfhhVrFl80ha7tlzrT2q4rX3eR/zQDZmcqZQiFz+TeTR2oRPWQIsmC3mDNSlTV39i2DjA+w4Mp0yhyLWhVE4lCcASBO2aL04254pwRwEjjB0lAkNkHuO0rsrQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hei9KAlZ1uBCy2R5Pw/OKZIRZyaS152X3ijai4QbeK0=;
 b=X6LUsY5cJQ4RE/vjaDqLQdyCdAGbaUNEmZ8gtlHLofe2q+11E8asU4/umqnXbSUMJx3KJOWHviV1PpjvMp+RLLF14g+DCUSdmwaY+61BppFVM+lIMEsXUcmXgYzf7D6rDDuScrAJlSMcvzhOsufX3Rs0TJ1e/k+VZgie8MLX8tU=
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com (2603:10b6:a03:3aa::8)
 by CYXPR10MB7897.namprd10.prod.outlook.com (2603:10b6:930:da::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Wed, 1 Oct
 2025 15:21:35 +0000
Received: from SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af]) by SJ0PR10MB5437.namprd10.prod.outlook.com
 ([fe80::e4e9:670b:5d8f:f2af%5]) with mapi id 15.20.9160.017; Wed, 1 Oct 2025
 15:21:35 +0000
Message-ID: <fe006b01-3d9a-40fd-93d8-50c029add094@oracle.com>
Date: Wed, 1 Oct 2025 20:51:21 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/151] 5.15.194-rc1 review
From: Vijayendra Suman <vijayendra.suman@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
        achill@achill.org
References: <20250930143827.587035735@linuxfoundation.org>
 <c2943ed5-d739-4dbe-b231-ec10d4e169c5@oracle.com>
Content-Language: en-US
In-Reply-To: <c2943ed5-d739-4dbe-b231-ec10d4e169c5@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0378.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::23) To SJ0PR10MB5437.namprd10.prod.outlook.com
 (2603:10b6:a03:3aa::8)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5437:EE_|CYXPR10MB7897:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b1f07a8-f4fb-4c9a-f899-08de00fe351b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZmtUR0xsK3JDdkJYVEgvQTJSSGRQOFBxc08xeGVvdWVIcFppUWsvQWp2dDVl?=
 =?utf-8?B?azRYRTV0MnBGY290bDdlR1Vjd0J2QUcwbDRKcHB0aGRPamVkcU9FZEJqMU93?=
 =?utf-8?B?Y2Z0ekpWazdscGpiVU9QazBIVFJMN0VIUUovempyRFdWSzlDaFlBZmlyRHVR?=
 =?utf-8?B?NjVyRThBMGZxMVJiVWoxZkdDcTZ4czgvMDl4dFpHa1JkL284NWZCcnJndDhB?=
 =?utf-8?B?RnE3RUhPVlRKVUJyb2F1c2hkMFZ0Wm9UVVBPZjVZd2J4ZlZvbWFwT3NIWnNT?=
 =?utf-8?B?VDJONndwOXBwdkl5QUFTZDVnZzNuNEFjdDlrN1NRTExGNzRxNnhWYUM4RkVk?=
 =?utf-8?B?OXpRckYyMGNDUTZyWlp5UTh2d1QyUEJvWjNnUHZLb1h6eDNWN2QvUHZveDBT?=
 =?utf-8?B?a0daVDhCNXBJMWxQVUhldjlqRTdRQjBSb0lvOXdSTlFwYUJjcVFzcGpscjA4?=
 =?utf-8?B?QXdtSmVUSXJOU2hMNlNzbDBMbFNrVm5POE1rUzRpWThTTmZHRmQ0STRMYWk3?=
 =?utf-8?B?a20vOTJ3TVpLb0x3L3ArMmVIdGVYSjR5Q1Vld0JibHVxcXBNb21KWjU2RU84?=
 =?utf-8?B?bWNtUG5TZHRXb2tLYnFaRFFwUnVQNUZ3OTR2TXVYYVE3aFlUVktZU0pOcngx?=
 =?utf-8?B?bGRVaVlUZ2pnaitodkRMeGZSeXN6MGhPNEFZdWI5RGlESE5zV0M4Z2RacG9H?=
 =?utf-8?B?SElXZm52bFVrODJSa3BrbHVrNVpHQTFYQ2NLNVdoMEloMnJ2Zm5pTEVNYm4z?=
 =?utf-8?B?YUFHb28wMUhaOWp0Uk1wVmt6YkJESVFNSEhkZ2U3UkxDVkIzR0hzTmQxdDFu?=
 =?utf-8?B?QWlBNFpJT1NlWTYyeC9JZ1Q4YkV1WVVxVi9zdWExc3U1SGRSL1hKR2tUbWZF?=
 =?utf-8?B?Z1RabXlFcnZSS2dIaFRrZlloRktJN0NUeHpKR0JCazAxMi81R0NTaFN4L3Zu?=
 =?utf-8?B?US9WK2VZTktweDgra3RxUlQ1cmJPOGY0ZHdFZFJLeHZOMnFDT0lUbncySzIz?=
 =?utf-8?B?dzdFWGdIYVVMWHlHaUo4TElYV1RHMjJ4R09XV0E0a1RVQ1ZtN1U3UmpmanZF?=
 =?utf-8?B?WitYK2QrS3dkWks3Z3ZtU2RrK0xvVG9haTV1S3drU3R0b0NVOTB0elB1ZUJ0?=
 =?utf-8?B?K0ZjTnU5Yis2NUgvQzNGSjc4NUt1Z054MUpFT2txbjIxdXV0RGU5aWZJQmlC?=
 =?utf-8?B?QWpJMUlweVRCVnU1amNRbDJZMFZsYm9tSWJwR3E5Zk5zMmRmdXZnN3FHaUNP?=
 =?utf-8?B?VDZVNXZrc1RJMXFEaWQ1WUJQbW1GbmJNWGJrQlpSdjZIdUg5UmdBVlVlNjA2?=
 =?utf-8?B?czNiZlVWOE9PMVZONVpCQ1pFeit5R1lGNFBrQldib0RCampQbSsrUnlHVjZ6?=
 =?utf-8?B?OFNxRVowNFBaYkxjQWgyTGs2MWlBdTd4WUNTekUzQmtaREl3SUc5WGlGbzNB?=
 =?utf-8?B?emtOV1U0VHZ4ejJvQ09SUFVNL2RGeHdTeVJ0clFtN3dZQXZ1VjRjTlQ1TktL?=
 =?utf-8?B?VmNMQXg3d1UzT2lVS1RmcndUN0UyTlZYdjFHRm5pSEpiY3haRDg3K0lNRVNO?=
 =?utf-8?B?TEh5ZjJheG9paWswdXdnR3JUMW93dGJENTUvTEl6VURhVmM3WHVld3l2bjU2?=
 =?utf-8?B?WDZaQW81VEEvQmxZY08yNlhSSTdUd0NlN0tlbFBiKzJtZmcxWFZ6amlpclJJ?=
 =?utf-8?B?VndDZnNJSEk0RXN4U2JUU0hPY29nUEZ4Y1BSTGtNV0Uxc0g5OGk3by9nYmlj?=
 =?utf-8?B?RDQxaUNXMmR6S1d5S3lORU5jZ1hyN3hkMDRoL2UyV21iY2poL0RDYm1LU2Jm?=
 =?utf-8?B?KzVCU2Z4U2Nla0g4MFpXaFR1QlZKYnBvYWNKMVViUDFFRU1WMUxqbU1RS2p1?=
 =?utf-8?B?dmxyNnBJNi9RakJlQTA5cURIRTVBV0c3aGJiSkRqOTZTNmltSHNmK1VjaXQ5?=
 =?utf-8?Q?7R++CD9wTpJt5ISYuooH/4fm+xmNLUmb?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB5437.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QzNmS0JvWitTV29CQ20weFJkMkptY2hTcVhQb3B4MFlmc0NmbnNHdEJRY2hn?=
 =?utf-8?B?bXIxajNEV2FLc3Y3UUtUb1ZyRGx1YkJPb2JZQ0gzcHZJSHZGS3llaVZOeFN1?=
 =?utf-8?B?TThsZVMwUWhBaUJSeWRabGFSTFphU3libWdBbWJ2UWswZGNEdGNmbElCZUJK?=
 =?utf-8?B?cG8wdVBVcGpSaVpUSEUxcTNPeWxFMGNzSS9tQ2psVitFcWxucEVlUGwva2Fo?=
 =?utf-8?B?cy9MZDB3clMxUjBmcytrVXF4Q25YZUpUdVV2V0lmQXRDWno1eGxTdko5ZUgx?=
 =?utf-8?B?bjNQMzA0b1pGOC9XWFBDcW1TRnQzZ1UxVXJRZ3U3bnRvbCtYa0tKN0NkYks0?=
 =?utf-8?B?UjhYUERzOEtzUXZBd3h6NlRkSlVHaWxZTWExNnZpa1l1Q1hZb3lNaW41RS80?=
 =?utf-8?B?aTIvM056bnpxdGFhQzFWVUY2bTBMQWZKeGVlT05tWWZmc3JFWGhVc1NpOHBx?=
 =?utf-8?B?ZnUyNVFJU1pGSEJCRGtoSDJ1Y0ljNVVONkJMcEFPY0VLNmdQUjNhd3BMNldI?=
 =?utf-8?B?dVk1ckJrTlBtbzM4YVNyOStZSVZEL1Y2OVY4VVExWDI2REFJdVlpYjZBZ3hn?=
 =?utf-8?B?TTdpQmY5Z0grb29lYS9MN2cwamtsTnNqQ3h0bzdxMXZMa0QwSzd4WDhxNzRI?=
 =?utf-8?B?N2REckFrYjJnb2RRSkF2cmRFd0Y5MXNpejNpaklOcHBnS2NJWGo2aGJkNHYr?=
 =?utf-8?B?UU5TVFNoeHlqVVZueUdGYmFsRmdTbWhwdndwTkRDWTErN1VRZlRWb2xOa0JD?=
 =?utf-8?B?dVdLMzhWOHVSQ1BaQjRsNjQ0ZldBU1VveVdjNUN5dk1JZ041NjNVdHJ4czJx?=
 =?utf-8?B?S0xXZXZvYmhjSy9TNjFSeGpCdXZzTHpSQTUyYU9EdVpZUDdHL051Unh6c1Zi?=
 =?utf-8?B?RnNKV3VoYkE4SnpIRFJwbHp6UWpwakt3cDY1aExRMjBrdVU5Q2l1TjNtdXhr?=
 =?utf-8?B?bE5iMVExWDlKOWs1bWkwMmVudmlMQUhGT2dKNFFYMlBrWEVGTUFmNUpvbUdO?=
 =?utf-8?B?bDdlb3RnVnBBVi82M2NrWm1tdmVERnkrVGpOZXZwTzF0ZzNoRmVSclcrSkNR?=
 =?utf-8?B?VStJN2RhUzd4b0U4aFlvdmJYNTFyOElXbTdxbHRNRzRuSHIxcVQ5akdSSEV5?=
 =?utf-8?B?QWtKOW9pMG5PUndldk53MkxxTS85M0RNcVRKMHZuSDlKMmhxTFN3aUxKd0ha?=
 =?utf-8?B?eE1DdkZyU1JIaEhmcUpPTUdkUmtpb2RVNjFxUEM1cXBJcm84Q2U2eDBUZWt5?=
 =?utf-8?B?VnBTYmdGVklaU3ZlbDJnbHpNZThiMFVROUV2K25yQnpHZ3ZPK0paSHpzdFNZ?=
 =?utf-8?B?bHNjckVpSHpXS3dWT0F6SngvUmpETFRCVGY3T09sanJXVHZmVmpFL0FiaXVt?=
 =?utf-8?B?b2RMU2pVY05TUEFkMTZmZEVhY0FmajJTVnpHQlVicGFTUWtLUW5XZ1pISzA4?=
 =?utf-8?B?YlJvbWlYaTl3M094SnEyUEFFb2JZdDY0RUQrenJuckx5WG5Nc3I5WUJHRmRL?=
 =?utf-8?B?VG9ROE5lbFVqSzFsTXhqWENUUHBEZFR3Q1lncXh5K3IzczlCVm5UK3c5MUZz?=
 =?utf-8?B?MlcwY1kxNmwyY21vSk9VdUR0WnpWNjhVa2NIeENJL2d3Um4yRmh0cDBQUzZX?=
 =?utf-8?B?UCtxM3dma000eWNOQWwxMUlrYTNZTnhGcGdpRWR1cE9ZeEFCZ2c3NVNpTGtH?=
 =?utf-8?B?dTVjbFRaMzhhNE16RXlBZzJvNXNEcFQxRjBiOW9YQnVNSVA0Sno5Y2VGWEd6?=
 =?utf-8?B?K0NqYmh2ay9OQk1oN0EwZVYvb09vTytoYy8yMlE5WW1yOGNRQWwvejg0aTRl?=
 =?utf-8?B?SEVUQlRhTEZrSDJHRWo3UngwTXR3LzFscDRRVEZ1S1ZvcFprdnpZbGlVQ0ZU?=
 =?utf-8?B?ZGhUTk1CSTROaktVeiswZHJjNzdVVUFHdFBETWFpNWhFbit1QXN4a1U1WE5B?=
 =?utf-8?B?c0FxdTBlTGtBVURhZHBpeEY2MTlCcnN4NlN0TkxQYndVTTc5cElEVUVFcG0r?=
 =?utf-8?B?V2owZGJSbGRFUExLVW1OalMzRHNRREx5empYTEdWOHQvQzF2VlhXeSsxeTBt?=
 =?utf-8?B?N1d6M05ycnh4T25keC9aaEdMdFlnbXExWVF3UVg2Z2QvUWZIbWdqZXFZU0V6?=
 =?utf-8?B?d1FqR21nSjVZNy9vVXYwTG53M0pqdzErd2s4WHZvYzR6Rkc4OVN2Um8rRC8z?=
 =?utf-8?B?SlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	d5Y5PbKYBao8DvBcRaPCzqXI/ExEfHIRWz2SFd+Mq3pBO4aEfTwsApUoSeoemJp70I/rn3ktBLmUFGyhAkaUKuWyFFZcodpTJ0noEs9dvfz/IKn1xaKnQ+7RfiCKM8EHxQyTOn7tfAm9q7SoQppgKFReEYrPbjaMmGDoeO5Z4JLxa8YNo3N9/tubPOJd2+9VVEk8lss0jxMQtoFXQHpGJa0b5tFaiBZYYgnNZBsu7st/DbhuO3AIGYrBFZwsXT5+2uXXZPI13DS630hWsMe/Hg2Kul3bPNYX1/mHQucnsIR/C6sABYW/+ZfONKVQnMvIXt5r2psSCFMxo8AUrG5hGwE71F5wLSv7hQHP/7/2+cYMF2GQpySzbL+su/04rDqDUFE8AswJk7rAA4FBFbqCIB3trs8SSJjbJdl1bu1O1LECnBSD2J8SExEnpkXzO1Bl5iWJKxkUdEJaecbM6T6Pf6TA3mJNu5Kzwn9PySuRayKkW+aDdgPmE8K6pgUsWlvN25Jzs0/WUSJswZe+LNG6taEwLga5yHBEmaOseMJsPB8C6cZjMrs1asrvWXPlSAK2xSZc80GYJv9VB8ORbC6jy+e3Wxp3sjZwxuiRWxGVD+c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b1f07a8-f4fb-4c9a-f899-08de00fe351b
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5437.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 15:21:35.1728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nwldU4bLE6YHft3wbmjN2rJtRkhS7NG4Dx+H9An8RiuLmpHqzWfccFdMOF5sYQchnA4NHAml5Z2kOC9P0w9sA8rwi4ahaXUcvHSmQVhkPUA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR10MB7897
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_04,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510010133
X-Proofpoint-ORIG-GUID: MfLLLMyyzrRltq5qphs8oFxVp6_U6sM5
X-Proofpoint-GUID: MfLLLMyyzrRltq5qphs8oFxVp6_U6sM5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDE3MCBTYWx0ZWRfX6qoxDaHjFoAH
 o3RoKl9JdT7Bf6+Rz7C2PrfFGS/yYWAWuH0cfCUYn0KPV4yZQ1JUwOnxZ03WJ9oDTj1jRkJ8Tev
 4QCzAKwN0gARhR+e+FdrdquNVd1znBuPn/9eEsUS4zr5iLMsVeLDggil1KM/WvGbH/BduCXBMkz
 FLghG4EflX71y1/ETt7jyPCTgIY47qBRYjRGOhGQYtSYyAOgZ6Seaa6943x3GK1XERpLDDV+4eZ
 7KlEuyUyqnhk0B3ePs5WKMvYvHrfG06F2iytfIBxdCMlM5kJlwgI44jxGGVdd/uO4d9POWSks1f
 PZ5sTQHOHea8OZVDNhznGukB4RYpHmuy/6i51tJL4qedwzU1Z3GW2yBfOiaGyK1w8zqYUitEwG+
 68M+pcNAoskOkcfg2OX4+s850pkEQi9cFhjsYIxQdcOVhPgxdIc=
X-Authority-Analysis: v=2.4 cv=VpMuwu2n c=1 sm=1 tr=0 ts=68dd4707 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=cqBTJz3nk7irSwHFp80A:9
 a=QEXdDO2ut3YA:10 a=QYH75iMubAgA:10 cc=ntf awl=host:12090

Correction, there is an extra '>' in my "Tested-by:"


On 01/10/25 3:54 pm, Vijayendra Suman wrote:
> No issues were seen on x86_64 and aarch64 platforms with our testing.
> 
> Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>>
Tested-by: Vijayendra Suman <vijayendra.suman@oracle.com>

Sorry for the noise.

Vijay

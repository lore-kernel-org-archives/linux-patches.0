Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B0D30FC21
	for <patches@lists.linux.dev>; Thu, 13 Nov 2025 18:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763058890; cv=fail; b=gfSi/wZvdfBTPUuaTPZre39a7Q5QAHYJsVy/u9bGeMu+0PQpx1Y5vpUJRT0kefSIW03XpMZsBNrbj0MFDcubLfIIa2pxuzb0hYOgwr86CV8GdY+v+4/JsHGefuO8EavN7VS5tc9B6ja2ou9Vs/dfHhsbVkHW0XViX3D944V004M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763058890; c=relaxed/simple;
	bh=vsmIFMOMa9aQEkkCDEfcgyOSibQr3YJ9ZZINEUUun8E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tm90HDFJKKXAzhzk6dYFC/fJ53jgaFC+D/byLT+WR4ZnP7y3TmFHUfJ9Pn3zrQUZBouAwUR2+o81hrQKBDXlqW8DFO8GAuzGLBPjWtLO48vvR/ngO83VK8d6z9qvrSwNPWkwTnWFM8MFc/YhlfP5Cr1KwvOi8v+ds7IG4iJepso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AgqgA6RC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rjaW3jEv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AgqgA6RC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rjaW3jEv"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADE9vZB023953;
	Thu, 13 Nov 2025 18:34:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=av2FvE5L8d5lJO+0QABCfFqjpB0ZrzYP8dZUhicJUy0=; b=
	AgqgA6RCgnZ8LjLrhkvi9F+9VO3h3K2I8dZeF6T5FmCA6gFlxvEcLlsf9xWkGbUN
	0TPEaZ93CO9BENXiORfpgMiRDo7pBuPsJWHu31pYtK4BK7PndGnAcB+PTMiO+PTA
	kVxg8HLO8y/ACgyjWTWWpA+LYRvxnkuo1K/xmA8G//ZJy5PKCEB+wyw5s5X++gl/
	O6iYf1zX6DJLn8Km8f5bBJfkFGHDD8IM1X7TMcQKozet6y7U1lOesKvF6q7V5/Kd
	fiac+pox2UCSBe90eUzWdx4sEpWde1GQokWd5tZjt5U0SoVGVUaHswf3MSbytrRl
	n27ZP1U3exDLsXF3O/XhJQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acvsstwk4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 18:34:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADHTt4B022038;
	Thu, 13 Nov 2025 18:34:24 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013041.outbound.protection.outlook.com [40.93.196.41])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vacgq4x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 18:34:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RhKuytKGu3d2guj3i+VLJq8wph5lZxcFdHztDcLATa5Wboi0mKmcKNaq7y40kNvQdHP3xv/kbYC02K7SIOnsoG1yfCGJ/HdSJD+5smDzYyOu7N73Lah3c4IWSZSxgi51oFrPf+csmYLrek26+TqiOSR/Wgsk1TJBzs0b2eSE2EXo/j00AT3oWTnXWjNbLpjCnr/yi8WMEVZndw50f+gkmCbfENt09Cp4vYTmhpFmTJki82tdTHRC+Yjoa0Ja1EBET249gd9Lp0voTPaidzvI3rKT+aA/DMqrCuxdNOa7FhE0u7tkw6dWd4TjjO/bzmZAv8MFZltz+IqHmxOVXaz/mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=av2FvE5L8d5lJO+0QABCfFqjpB0ZrzYP8dZUhicJUy0=;
 b=TnXvbh3rDH8C+VWTxvLF+hOYoVvFa0fjYUlDtsjHRTI2pJ1jaW7QULhCWGUuqd1Fn9eRVolNRVDSV97OnLq1hlmEZ94280n3dUB41Z+k+jPSDejrzBzqtMHnUzgZhTXZePiCrZ2FDtujS2US6PdujWeQqUZEWwt2/7w7ctDVpXCHO91rRAPX3BuY1Y80YiG4TfRRHDjNjqcdBJuvgYFRUUKDvWuxZT5HAnq7ekg9hbXffXGOQIpNNeCUMXF/dag9onZtan8hCg5yBO+4PCrnnf+okUKAytN3HlAl6IwjfZJ44nGZBMYU83eUTS0+wsRBtELtOXmgFAPT6rnVbNJzDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=av2FvE5L8d5lJO+0QABCfFqjpB0ZrzYP8dZUhicJUy0=;
 b=rjaW3jEvCR3wXrDURorzPoXbRkZ+Lh2jG9U66yncFyJ+OqxYAil9zH3KbOMDDELAJ+E1Cz1zfktZj7AKL8pfMsoP4H9C3A6Og35uyQq6w5ZBpO2aGmQGKmXogmj+Ofj4Ckf9qBPDoTOHnbWwMDVqJ00cTUZ9b3/fqIU2yoaUKpc=
Received: from PH3PPF558EA2A2C.namprd10.prod.outlook.com
 (2603:10b6:518:1::7a2) by SA1PR10MB7754.namprd10.prod.outlook.com
 (2603:10b6:806:3a7::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 18:34:21 +0000
Received: from PH3PPF558EA2A2C.namprd10.prod.outlook.com
 ([fe80::7995:75aa:768:e262]) by PH3PPF558EA2A2C.namprd10.prod.outlook.com
 ([fe80::7995:75aa:768:e262%4]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 18:34:21 +0000
Message-ID: <1bcfd057-e9f7-4bf0-a753-ef1d5183d089@oracle.com>
Date: Fri, 14 Nov 2025 00:04:08 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/562] 6.12.58-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, achill@achill.org, sr@sladewatkins.com,
        Alan Maguire <alan.maguire@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20251111012348.571643096@linuxfoundation.org>
 <5b13fb12-66ac-4502-a93b-d79692cc7b81@oracle.com>
 <2025111355-confound-anyplace-6719@gregkh>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <2025111355-confound-anyplace-6719@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0112.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::9) To PH3PPF558EA2A2C.namprd10.prod.outlook.com
 (2603:10b6:518:1::7a2)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF558EA2A2C:EE_|SA1PR10MB7754:EE_
X-MS-Office365-Filtering-Correlation-Id: 47e655b1-bd9b-4df5-79da-08de22e34306
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ekR1SHFNNEZBT1llVTRFTGpIWWJ0ckp4S09paUtJb25Wb1poR0VHaVZqNU5R?=
 =?utf-8?B?Zy9OQndpTkxRUkhFeG1NdXg3OXJIUDlUWGdtYW9lVGttMkh0NzF6WTJXY0JL?=
 =?utf-8?B?L1BjVGcyaG5aYm1QQlRGT1J6bzRoMkdkQUJHR0VFTjZ0ZDRydjBFM1B3bTB0?=
 =?utf-8?B?S0FYWTIxcktrbE8za1ZWNVBRSTdmc2pnMU1WNytzTm10RHZqd0FrQ3F1Q2lU?=
 =?utf-8?B?RTl5Ukx5SHJUZDNBUWg1c085UlhOd2gwbjYzRGJzakZhSm51Qi8rWDJlUklw?=
 =?utf-8?B?VXVLTytLN3QyVE9iU2FzaklKWHRIWVZzd3R0cmtSUkNBR1dGcWppdld1WnR6?=
 =?utf-8?B?ZkY0VU5WT0dhbjJ0Q1ZFNUk0eHRjamR5U2gvbFpHT1JjVnZlbGtNWWhxSTNU?=
 =?utf-8?B?VFJHU0trWEdMZ0I5TGp1MHlFMFVDUjBvTjRwQTl5VjZ5OVR5UllwUnh6bmdn?=
 =?utf-8?B?WG5BbWxWUUViVkZ1ZnlWRW5ibSszdTMxNThmanZ6dnhGTkdWblk5Y3Nkb0o5?=
 =?utf-8?B?UG5PTGRENXFZZHhocFNrU3ZaVjNjOW8xSVFLdEorMTI5dWw1bGlqUDUxUGU2?=
 =?utf-8?B?b3FMeWZBZmovNk1jQmdJU09zNzFIQ21rSmdBL3UxK3hRWHFpTzBoaXZjWVJV?=
 =?utf-8?B?U2hXcnRVb1dWYVo0cHVZbFNNNTRZSHJobHZUUDlBdy95cTFwbDJRekdxRFlX?=
 =?utf-8?B?N2dHTHN6cVdUS0QzVStkS3EwbTR2U1VNTlRBUU9kcVVMekJWS05RV1owdjUw?=
 =?utf-8?B?Q2xsNTlYV2dFNE1zMTByallpMzVkY0VwbUs1b0R3TUFVcTFrVzZSWE5Ydm10?=
 =?utf-8?B?M3MyWjBYY1YyRDdhUVZTZHZ0cnoxQmdGKzR0V0pYb1R5bDZFeFdNVGZ4cjN4?=
 =?utf-8?B?TEVPRWtaQW5XSHFpdzdEUEd0M3ErTXFuVThTSXY2QUtzUHdBZTNLTi9hUWRm?=
 =?utf-8?B?LzBaYmdaV29rYkhEV2tJTVRBL2U4blNtN29FTFA5SXh4T1J3dC9YK0JKMldm?=
 =?utf-8?B?d1NERDY2MklkRmlIQU9kei9EMWJzZnBXRCt1OE1EeFlYM0ZsNGdEb1IyWUdT?=
 =?utf-8?B?S3M1TndOaXFPbVdVNGFTSkxheitiTURaQ3dDQW40c1AzUVEzWXdmSnd0VXpi?=
 =?utf-8?B?R3l0MFJuTkNEeEV6dVBDRWpiQUMwaW1EdlNORFkyRUU1VWdlVWQ5ci9YdlBJ?=
 =?utf-8?B?TFVFWXFoRXBtVWtQeC9JeCtBSndFV3RIZ09oVmN3L3kyZUdvMVhnM1NWZitH?=
 =?utf-8?B?a0toaURmQUdwdTJmSXMyQ09MQjdyZGk5cURtU1pVeVZrZjZUdmNFS2tqallN?=
 =?utf-8?B?Z2cya1lOL1NwNU5mVTNPaDYxVnNiWnhHZTA4clErWW5zNzV3aEhlZ3laeWNj?=
 =?utf-8?B?bDYxSXhRb0xlTVFKamNLMlcyQ0Z4NXQ3WXBuYkY1MHRVQXJrbXdYYXRGdzhN?=
 =?utf-8?B?TWZodFc3VnpnRUF5WjJGRmJQenIzeWhIMzdSRUJkR3BnQnF5aGwrcmxKNWJx?=
 =?utf-8?B?VWFlTDM0dm02cWcySm1hWk4xUzNUQVBvSEtRVmwvazVRWWY3UDRzYjlnbEti?=
 =?utf-8?B?UGxEYUROM1duY2NhMExranY3UGhKTGh5Y01OZ2lERlFhRHg0YmRvaERsc3Fq?=
 =?utf-8?B?ckdQNzNkTDl5a1RFaXMwbm9XR2dlRkZscTY4dU85anJRamlSTVpqRXBUNGV5?=
 =?utf-8?B?NmYwSEllSlJHditHclY1WWdocTE3WlVxNlFBWTVBeWVnRGZrU0lLLzZ0aG1H?=
 =?utf-8?B?VlVDWk83OGE4MDJDenN2alUrd2lZdWhTaEFoMnU0R3pRZ2ZIZHN0KzVCTlNp?=
 =?utf-8?B?NEhSMFJEVG5OVWJreEZaOXI4S2lqYzJpMTlDdHJDVi9KYTJtZVJqeXZmZXJy?=
 =?utf-8?B?R2hCUzR5eGJmY2NETVpDamhEdHZaTzlrSFVxNjV6aXJYVTFNZFBueGN6Mnk1?=
 =?utf-8?Q?3Vd1Og4fNZey4m+8/n2YR75vTu895xcJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF558EA2A2C.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aVRKMXV0Wmk5YWJ0NnJGRXd1MVhCV0daWk1PNXpxbjdrK0NvaGF5ZEs1S0Vs?=
 =?utf-8?B?cFh6cHlIczVXdmdwcGxyWXprTk90cCtab1pyUXduSEc1SzlXRFhyTWNQWm5I?=
 =?utf-8?B?d1Q3T1UyR3dQalFZZWpxdmlPbDNQTXNXcWNqR1FwUGU0S0xqTTJKWURveDN6?=
 =?utf-8?B?Z2l1cFptOUIrWEhBZDd5ZUlOZ2JJOGRIK2dzVVdaalM3TWhaTzBIK2ZETTgr?=
 =?utf-8?B?V2N3MndjRU81Z0EwY0dxSnJIdW1FZ3Nvd2JhNUhMY0tFcEZRaDdXUTZQdnRC?=
 =?utf-8?B?WlZnNWMzTTRVVDhzZWRsZnZ4UU5kYWNkc3pvekRlNDZTSkpxaFM2Vi9MSDRi?=
 =?utf-8?B?YlhUQnRoaXpjYTJKTmZ6OEVWVUxYelVXZGxKYm42OTRJQkp4RWdRcjI2cFU5?=
 =?utf-8?B?TmpZcENmU1VGeFZDN2FKa2xETVVaa0xzV2RFRHluYnYvUnhLNDJoeE1YNEdy?=
 =?utf-8?B?U3BVRGZ5Zm9IQy9STnMvVitaM1FtT2hKMUtOaCttdzVuOEl3aDlEV3YyVy9y?=
 =?utf-8?B?WWhnK2hkOHZjLzB6ejNVL0g3aGV5VGUvb2hkMklUMVdZbFg3WDdwc3ozRGpk?=
 =?utf-8?B?ZnRXQUFsclR3bS95Mkh6U3hoT3V0WUp1STNKM2kvdDBrczJ5ZEVqbGF5WVFu?=
 =?utf-8?B?OHdCTkVuTmJyZ0hiRXhUOVJqM09wZmVVNHhQN0x2MExpcnlJQk9FVUlTTHlm?=
 =?utf-8?B?dnNBemdQZnlPbisrblAwb3J0aHk5d0NrK1g4WjNGeUhTbmI0VDV3anpYTkU4?=
 =?utf-8?B?L2lwSlYxRC9yTEZkVXZrSmI5N1RZbktCU05QeitMUE80TDRpZEExMllLZjVz?=
 =?utf-8?B?b0VZdXVldjIzWVY4eVRxdzljY3Fwd2tRMzR1a1U0M1RFeFdwOVVtMURPT3RW?=
 =?utf-8?B?NWxzWmNZaTl5N3lsVUxMazlRT0FRSk9USWNVaVJDV09UV2swT2FTelpMV1dR?=
 =?utf-8?B?MGNFMWxNUElWemJYUjZDUnZ5YXh3LzlLQW80QURBZlV2S0ZFdjErU1Bxb3dz?=
 =?utf-8?B?bVVQMDJJSVRGK092QXdZeWNsSVYxZElZdHh1SnJGWXo1WTF5blRCTHJ0Slpo?=
 =?utf-8?B?UzJRam56RndyWENaNHFyQzgyRTRNaHp2Wm95dGs3N0hrVENxNHROSVJTY0tx?=
 =?utf-8?B?aEw4U0ViWm81VjBzZXRYbHE1T3lOb0haTzR5eDUzUkpMQm9iRGtMQ2ZqRVQr?=
 =?utf-8?B?KzhMSGhKUVdTajVkaHh1OGN6a3RMdk9TL21xYU05czZhS0tTdzY3UGI4dit0?=
 =?utf-8?B?WkQ1R01UZjB2TXdqTFhQbi9sbHg3SldWMTZPV3Z0TjVlYXoyOVIzaU81K093?=
 =?utf-8?B?YzU1ZExybjVXc0lIQnRKMm9iaWZpeFd6RUlnOFNVaXZPdU9GeFMrUHFyREZt?=
 =?utf-8?B?Z2pHQmhGMjIyYnJ2RHBIZGJFSGFDTnhQS3Q5YlcvUVp5RWxUdjZEY3YvYXJF?=
 =?utf-8?B?QUQrcko5Q0NQNWordXJYK280SWtvdEcwalJDd0F4dHlkQmlweTJjZDdXRnpV?=
 =?utf-8?B?ZndoZG1GaDRvOGdmMmY5OXYwTU5OVGtyc1VnY1VLQURMM2ZTbk1VMEEvWFJ3?=
 =?utf-8?B?NkNYbkZBTUlXOCtneFlGK2NzN2J0eHo0bHoxaVdQODhGdWtrN1YvZmZqbUdP?=
 =?utf-8?B?YzN5WG5xcm1hY3U0SmxwTkdEZTFqaUw0a01JMm5lanZOcFZyd1lFWjg0MUsy?=
 =?utf-8?B?b29CTTAzYldxTlNxVzFnRTZpN1RmUUlSRjU4aHJDaVJDSjNDaldoUFJmWDJk?=
 =?utf-8?B?akQ0Z2ZQbzFvaXhNdTkzY21WY21RMmdLRm9uTk8yTHVvUW9nbjVpbFIxSkZt?=
 =?utf-8?B?OXNJcHlqemloOExsdThUWXNVbmZKRllwZ3lKbzhuOUV5UGRyVWwzMkhhaS9l?=
 =?utf-8?B?S3JBUGQ3OWllZjFFVXRINlNuR0I3Y0c0T2czc1lhcGVDNnEya1RZUFNIQ1V1?=
 =?utf-8?B?OTBFVnJrUzB5TzRrUjIwTE1rMTk4RU1YRU9vTFRodTIrL1RJTEs4U1lEMzVw?=
 =?utf-8?B?OVFSV1FrcWt1U2lSc2RqbjI4QVFKV212emR5eGxsczRsNStBcURJcnFJSEFD?=
 =?utf-8?B?N1pmM0NvblNyK3JGczdoZjUwN2pMVVRFYS9aNHRxTFV6MG9ITzk3Z1d4Yk1i?=
 =?utf-8?B?ZGhBNVNsWVhzcXZJRWNwSlRLMnN0MlUvcDdUQjQyMHJlMkJBcTgvZHo0cTVK?=
 =?utf-8?Q?HmNRJFlT1XMSpddqX9eqF74=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	M/FFsXVozRRCHnd7eJiD8ZCX/NdKZ1OZVPuW6YRbLrIXFrfssTfJyLnssBogVgtciGL20f28TpAiHSoVBj7ch1p2TY7xkQNruOu0wv9B2wVO/w/2l0LCV1V/OBhsx3nOAnfH2L0dFEGV0IOW1Ui1T5GUpuCH8EVlRCLsk0xaiqriLTPUMYPZfVr+aCGOuV3XXmKIb3HEnkJ0VpJhu1H/Dd2xeZI7QVH6ZhizdaAQ3QKyJh9/0nY3kFYcu9OOWwaFwWtlsIGphEal9MWb2Cl7db9dhc4bpyrO8hoHcbj4/cWIMDN3IHIhjpvgJbN1OvBKLdTe7Pt1l+DzJ7yE5N5EP4sLv++JvbPBiPxh9zSAYL15ynHY5HryKut6qrlZrf24vtMpCYIkVPHha7lDXqxvbHU+w9TVFyaU5Bhb2H0YufY84pXyXqWMC9ypNhNf0ajTY567YL/S3QEJSL7FwI6s14D62UWodM6ZSUhxWQhtkmtXlPOeiHhHwo3cihfxpDvFUPFNfHJRDzUf2VyQl9n8aGvz1yVmQSLwPw6jypE08UiXrvBF3UYkXbhDhn+rBkYgwQJ6/2nNmLWSqdy03b5PZT4+Pdz/WZApLzrgM7ZS4j8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47e655b1-bd9b-4df5-79da-08de22e34306
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF558EA2A2C.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 18:34:21.4122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r0YWYSDuK+KshucmD5OTP2KQ8pG62QbBDBMDR2dh8FdlHXeIs0ieYay3a04WKkwfmBVeNz8+tHlxuPTCy6XHRfx1mobNKPV0/sJbgOiLP5Nu+Dpc7MxrVBarzRsRlz0K
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7754
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_05,2025-11-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130144
X-Authority-Analysis: v=2.4 cv=bJUb4f+Z c=1 sm=1 tr=0 ts=691624b1 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=YUgTCwlc6BZx2GEFNjQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: OWVzME-0w6sJ2JbmvXEbm0GUMCDHmc_8
X-Proofpoint-ORIG-GUID: OWVzME-0w6sJ2JbmvXEbm0GUMCDHmc_8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDEyMyBTYWx0ZWRfX4YsGyO27ZKBZ
 xXa6PKpRrHHKy300ATr0ADGOtqiy6bVFSVPU16emOlQn1ng8t2enkEeaXlnNiCu7WGEAdmhkUNS
 JbY1/VlUT55tb1LAgYrm4VJFLVc2H7bHv6IbOq6uKAvH9skILwQCSoIGyRHCh7ZIooAL256oqtW
 XmAZNnhPkOk9ssaLXjjW3Ly6e6WphBtf0VkZRNi/3VayCm6nKwwn4AM91Taq8y+V6KSlwjbezeM
 6qDByYaNJQp/H8eCWpx6UgkOzBD8My+3LIFaU3btqkQb6d25SzKXgXQfUpTi+kIbk3QYkPs704V
 LgSK4FJTTjoYqheuyFSEkCxm8tmxi+2Cn641mEZjqzZUpaHP3HAn9+oNmytUb28Lls4DCa98UlB
 I/HHFV4E16b+DeVLr+70sdbqwhfksQ==

Hi Greg,

On 13/11/25 18:52, Greg Kroah-Hartman wrote:
> On Thu, Nov 13, 2025 at 03:48:53PM +0530, Harshit Mogalapalli wrote:
>> Hi Greg,
>>
>> On 11/11/25 06:54, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.12.58 release.
>>> There are 562 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu, 13 Nov 2025 01:22:51 +0000.
>>> Anything received after that time might be too late.
>>
>> link.c: In function ‘is_x86_ibt_enabled’:
>> link.c:288:37: error: array type has incomplete element type ‘struct
>> kernel_config_option’
>>    288 |         struct kernel_config_option options[] = {
>>        |                                     ^~~~~~~
>> In file included from /u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/kernel.h:8,
>>                   from main.h:14,
>>                   from link.c:17:
>> /u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/build_bug.h:16:51:
>> error: bit-field ‘<anonymous>’ width not an integer constant
>>     16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e));
>> })))
>>        |                                                   ^
>> /u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/compiler-gcc.h:26:33:
>> note: in expansion of macro ‘BUILD_BUG_ON_ZERO’
>>     26 | #define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a),
>> &(a)[0]))
>>        |                                 ^~~~~~~~~~~~~~~~~
>> /u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/kernel.h:103:59:
>> note: in expansion of macro ‘__must_be_array’
>>    103 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +
>> __must_be_array(arr))
>>        | ^~~~~~~~~~~~~~~
>> link.c:291:22: note: in expansion of macro ‘ARRAY_SIZE’
>>    291 |         char *values[ARRAY_SIZE(options)] = { };
>>        |                      ^~~~~~~~~~
>> link.c:294:13: warning: implicit declaration of function
>> ‘read_kernel_config’ [-Wimplicit-function-declaration]
>>    294 |         if (read_kernel_config(options, ARRAY_SIZE(options), values,
>> NULL))
>>        |             ^~~~~~~~~~~~~~~~~~
>> In file included from /u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/kernel.h:8,
>>                   from main.h:14,
>>                   from link.c:17:
>> /u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/build_bug.h:16:51:
>> error: bit-field ‘<anonymous>’ width not an integer constant
>>     16 | #define BUILD_BUG_ON_ZERO(e) ((int)(sizeof(struct { int:(-!!(e));
>> })))
>>        |                                                   ^
>> /u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/compiler-gcc.h:26:33:
>> note: in expansion of macro ‘BUILD_BUG_ON_ZERO’
>>     26 | #define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a),
>> &(a)[0]))
>>        |                                 ^~~~~~~~~~~~~~~~~
>> /u01/hamogala/stable_rc_testing/linux-stable-rc/tools/include/linux/kernel.h:103:59:
>> note: in expansion of macro ‘__must_be_array’
>>    103 | #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) +
>> __must_be_array(arr))
>>        | ^~~~~~~~~~~~~~~
>> link.c:294:41: note: in expansion of macro ‘ARRAY_SIZE’
>>    294 |         if (read_kernel_config(options, ARRAY_SIZE(options), values,
>> NULL))
>>        |                                         ^~~~~~~~~~
>> link.c:291:15: warning: unused variable ‘values’ [-Wunused-variable]
>>    291 |         char *values[ARRAY_SIZE(options)] = { };
>>        |               ^~~~~~
>> link.c:288:37: warning: unused variable ‘options’ [-Wunused-variable]
>>    288 |         struct kernel_config_option options[] = {
>>        |                                     ^~~~~~~
>> make: *** [Makefile:249: link.o] Error 1
>> make: *** Waiting for unfinished jobs....
>>
>>
>> I see this with bpftool build.
>>
>> let us drop this commit ?
>>
>> commit: c8271196124a ("bpftool: Add CET-aware symbol matching for x86_64
>> architectures")
>>
> 
> Already dropped.
> 

Thanks for that!

With that:

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit


> thanks,
> 
> greg k-h


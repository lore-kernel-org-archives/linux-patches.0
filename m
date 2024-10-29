Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02022F56
	for <patches@lists.linux.dev>; Tue, 29 Oct 2024 05:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730178343; cv=fail; b=B71ZdsqnEn7APIsF+uVxCmVxy8SpPHue0mq6D3JcCkzTI37LmFQFkUeARkRiOfPUmAbJEBN62okVEGHy7qMvvJGCvCXZ1xnbWri1aRg8T+GhDgQj5/ggCUUhULM7brlJkikNKzG9IG/uxPPMLm5WTfVJv7HJ/6Pi8oLDorRR2kA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730178343; c=relaxed/simple;
	bh=HFM5l31OAxA7ehmgOWf70+N4xSy+cBwoSLV+nXnjNL8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mIY/YC12puDvk+Xik4mpqbapmpEbMirNxILMQyE61szvxgwNIqh2ShPsbxhr+mP1FKDVCnL83K4ueqKv/MjTe1N8ysSEAVJNAeMK8zcxNovyCEc0xkpgvyoFeP7pARgOrJ+kC2ElVMlKqMwlN85g+7qGpyYws7JdF02Wka7wvrM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TIJ6IkHE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gQC5QVnp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TIJ6IkHE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gQC5QVnp"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49SKtf4U010888;
	Tue, 29 Oct 2024 05:05:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=XjZS9W6dr8YdjC5UC9GVMCoB61QQutTM2EjH+DTi0Lc=; b=
	TIJ6IkHEAYukgB0/cJN4pVNxkHhEBQ2rl6lXqGYG/HEuiVygMwVueUFJeKj/RgG9
	/ZGtu7gGEJjWEK9d2MyP2PZMtjMawPg/XrP5FaVHD8lgM5Nrz/Z33/anNo///H9A
	Nlc2E4254BtxbuBmiKoelg9R1+pvc+0uhph11tc195zuZB2TMi2EqgMKOZAdO2rJ
	G5Q0t4oyYdhpFhERbSXwn2QjgY/++4vbucDrgCLyZ03kpwAsjBsrSt3sb8zcuhiW
	w3BhM2SgwA8GqTY4y/eZOyv2nRjS429rmHyHPFQy8I/MUebr5EG5VbD0tMJ0QcVQ
	HfN6hoRgl1kL3H+POU4eaQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grys4gsv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Oct 2024 05:05:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49T4o8RO034758;
	Tue, 29 Oct 2024 05:05:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hnd73jvb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Oct 2024 05:05:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ksS8JfcR6jfZRs/+W/Eqw4YDptfHNThU0rWRctkb8FzmpSJUGT9lPMYHMMiyMkSq3x137UyfSrJ3dZlMSIgi7ZKtvlCWBrfObKY1RYcebO6PvziaZfh1s4LwzslEnDoqzsPnQWITMv6ewUPG+3Ul9gIpaCCjDQH3J+rPx0fKgwxepf97lz5wgkJq7yS9Iz1Tf0DBArscNR1mOoH+CroyYZSNTD0UrAg4EwzvOMYF4RIK8mhmSj0rJIzyGRrGfEYv22PyS3ykQyYS2xPpb0oZyczpfuJOkykhwhIKWS3lxypjNZBoKdfJiALoQjhpmF2W1YzCg6H+AdmRUEQr91FDzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XjZS9W6dr8YdjC5UC9GVMCoB61QQutTM2EjH+DTi0Lc=;
 b=ihDGlQPiMWP/62816YasEBMcqFbMYNTVGGD6Ld1Hs17PnlZkEMMLPamO8ElWYu/fGlL0H2rQWGEu4FL5LqRXSoqBTsYe9+idG8tx5Pi+6wpVGawLrvD8l+I9fTLl11fyMb2lBCpEf/OLxaRHrBDMiJBaZxIMeGbGF0Lsef933wubLwT3te+Es4aS6Wf43UjnY1FIu5oJVCt/65a9m7UiqUTFUyrNYgffQKModqxrYJl95nfMq4+MdkLZ7zFwtFWAKwVDWA5eDpxxpYedpImEWHvKPhnFMuuUVCwoYMdh0hLfFETWjnJcdokR0ItK91DPf266aaQMtKU1gJeYr0YXkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjZS9W6dr8YdjC5UC9GVMCoB61QQutTM2EjH+DTi0Lc=;
 b=gQC5QVnpjCJxoaHCXVidZBs7FLErIZg5RYgv6rLXABB6/ydHKq6GmChIPT3KBQFIreYAr8SuDicljbulgk33IiB9FRGIX0oloedpiR4W3x3IGw/R7UcyZ3B0GJkZK88kp03Wp3FHLIuEoM8tnc7eHwG4MsceBnRhdoQt/iVCBBc=
Received: from CY8PR10MB6873.namprd10.prod.outlook.com (2603:10b6:930:84::15)
 by CH2PR10MB4198.namprd10.prod.outlook.com (2603:10b6:610:ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Tue, 29 Oct
 2024 05:05:21 +0000
Received: from CY8PR10MB6873.namprd10.prod.outlook.com
 ([fe80::bf52:dff8:da0b:99d0]) by CY8PR10MB6873.namprd10.prod.outlook.com
 ([fe80::bf52:dff8:da0b:99d0%5]) with mapi id 15.20.8093.021; Tue, 29 Oct 2024
 05:05:21 +0000
Message-ID: <82ba827e-bcf6-4bc8-a807-fad54df7e299@oracle.com>
Date: Tue, 29 Oct 2024 10:35:06 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/208] 6.6.59-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241028062306.649733554@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0021.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::19) To CY8PR10MB6873.namprd10.prod.outlook.com
 (2603:10b6:930:84::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB6873:EE_|CH2PR10MB4198:EE_
X-MS-Office365-Filtering-Correlation-Id: 376ac45f-dd4f-41ce-b79a-08dcf7d749ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VGVtRmVCczdZanBNS0J2d3FwREppVG5JRlZ0aVljQmxGRXQ0cjc5a25QMzM0?=
 =?utf-8?B?OGd0OEFRUVVYcUVkWkJaTHdjZEhYeWhnVExrbzB3ZURNdzlHWFlsak84cDE2?=
 =?utf-8?B?cVZSYzkwbTVWYk05MUZHc0QxZURrbmtIZDdCR3NyVHNTZVlTNFJiQUFvQ2Iw?=
 =?utf-8?B?Ujl6eW90OXQyckVUTVhHOGxjU1pqTW40Qm1HMjcxQlB5RzJJcHBPbktESU9r?=
 =?utf-8?B?V1JGRlM5TFVkN1VyNUFDcGZsMUxOb2VqdHkvMFhNUU9CT1VRZkEyRDA5dlAr?=
 =?utf-8?B?Sk5QRndpU0VEeW83R0NPb1J3T2NEdXJKWi80c21tOVNNYlZRdnIrS2Y0ZE0x?=
 =?utf-8?B?OGFENE5rdUJYbG02UDVBcWs1Z0hTM1NvNU81NjcrM28yNnd2RXJscFhZZUFX?=
 =?utf-8?B?SitaV0UzZ0hLb0lvTmw4dGgwMzR1UjZIalpJM29GRlM1eEhuQU9rUGtUWWRL?=
 =?utf-8?B?d1VnLzJGR0VBWEJXWmY0d2x4Q1NpOFkweWNWeVRWK0dJRGVhQmoxWlkxU3pV?=
 =?utf-8?B?bzVONG5EcVlhZ2s5b3N0TGdTeVBmQ2JZZHRXcTlnQi9TOGc5TFJHR1FuL2pl?=
 =?utf-8?B?REU1QUdWbVZ3V0RUSGQ0N0VSbFBSb2F0MmpuYjRmMTBGVnpVQkRyNWhtSG1V?=
 =?utf-8?B?QkJWUmllcE96MVZtOGM5anlOQ3pXWVVla1ExT2srOVRsblhObHVwZC92RzJH?=
 =?utf-8?B?OS9MdWZ2NEVMNE12RjJSb3BCb3kyRjY2N0pQckF2Z2Y5Slo4VUJRenRYYkhD?=
 =?utf-8?B?NTNhRXhNL3JLZlV6VHNHcDlQdTFGZnM3ZC9IRWoxL3FVcVBNY25laGJ0THZ5?=
 =?utf-8?B?aEtiYm9Pdi9UbitQdkg1VVEzOXd4eGRDZysrbGlaVnoxZXViZHQrajNkM05O?=
 =?utf-8?B?Y09VcHQzdGZ4VmtGYkExRW1qbUQ0ZUxDQU5nL2FVaWY1eVdXdGhSd0hCQ2Er?=
 =?utf-8?B?bGsrem8wVTN1TGlXUW0wN2I0a0FFOVUxaHRVSmt4M2RuS3NHZHU5dEY3V0ZT?=
 =?utf-8?B?TC9WdUhOSGhhY0F2d0hxaUFKTFcrbmtpbGxRU2Y5aitLRGxidTVHelM4bmxz?=
 =?utf-8?B?V2JUQ2oxVlFaeVpyRllwUDhEU0s5RWVzaEFDdXZLMERrQ2xRb2QvRnZrNkFP?=
 =?utf-8?B?TDZMM2VaUElhQVpsOW5ldlNWT0FJeVN4Yyt2dVlkbTlnTXJiNDhSZWgvZEdD?=
 =?utf-8?B?RXFzcmRMdHNmdTUrVW4xd1NUMWRuMnF2UlZxaHE3b09FenNrRUVoN0xSNDdQ?=
 =?utf-8?B?TTVLRWQvVHdQM1RyZVFWUDJIbTlIMGJXaDNWanI3aG51elY3NkJKN2dqZEFN?=
 =?utf-8?B?dUlFeUNZUmVOYWxKUWlLNHU0RkVuL1lrZTloUk5xSy9tSXN2MDZRU01ndVVV?=
 =?utf-8?B?YmhodkZPcEhwVXRGc0FqbjVnY0JRR01vVW1YZ21RWUZnVXhZczY5ZXlweDBC?=
 =?utf-8?B?clVrc1pWYUdwS0dBZ0R3Y1J1YVlwLzN2TG9lV1cxS09xWEFmaVBwS2xzUTJP?=
 =?utf-8?B?R0JWaSt5OWRZdmp6YXNBcmtMcEEyTXZuUzhUMkhnMUNYbHh5ZHJJSjRFNjNF?=
 =?utf-8?B?TW5aM3JGVTRtZVNYUllwTFdhM21vUnJ2OWJGcEhhV3NzdzNYMm84QXdTS0RC?=
 =?utf-8?B?emtkQk85ZjNwMVYyUTFwdjcrMUczeEk2dzlvVlJtbWcwWjIvejBERGdlRWtv?=
 =?utf-8?B?R09QOVhuaGxKeTRVRTZoZGVFYU5aOHBRN3kvTWcwREJiRjhoOXU2WGQzM256?=
 =?utf-8?Q?UseuBPE0mA/yvv4dSx9/E602Ya5Bq14xQnB4ERV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB6873.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UHhodFdxTWJtOFJxRWhJZHZtT0ovUXFIeTBMZHgySzZ0L1Ryb1dHZTRJT3dq?=
 =?utf-8?B?bGlEeFpqWXNWakR4UVc0eURjbTR2TFk1MTcyMjhDMmM0S2tNWXI2aTRBNGdn?=
 =?utf-8?B?L2JSaUw4K053ZitaSGdxT3JZTXhVMVNUSDVkOWhrZ3JPZ1RuQk92a3RnM0ZT?=
 =?utf-8?B?VURwb1JyYVRwSk51UHJIbmpvNVY5RndadE1uckp3NXh5M01VZXd5Tm9jckI3?=
 =?utf-8?B?SERLbHFOZGxpOXZ3QUZGR0hIYzZoVUQxbXZCZlQrVlJZYzNBQW5CUjNBVVpa?=
 =?utf-8?B?ck9FRVJoTWJtUEp6ZlRqcmtFN29yRjNPS3IwbTlzWldQWWRwRi9yN3J3SldO?=
 =?utf-8?B?SGxkZnZJNFpJbzdldUo1dkk2b1dMYlB0cVMzSnVNQ3B0REhEZkhRaVE3d0xF?=
 =?utf-8?B?TGlMWm5yZmxZcCtzVE1ja2NhcVpIWDJIRTIyalNOM3Qvc3U4N0pscTQrQzRQ?=
 =?utf-8?B?Y0lFLzJDV0xBbldMZ01qY3pDbEthZVNYT3pFVUZPZWkza0wvRVh3UVBRQUdY?=
 =?utf-8?B?WGUvTmEvdGV5ZEYzcm5yWTE2S0Ryb1lVQTcyMXg5eG5hUzZJeEszUkxyaitw?=
 =?utf-8?B?VlptVzE2K200UUJaOXpvTm5tdnJFWGY4RWMwemtLRitpcG5tR0thNkV6Mi81?=
 =?utf-8?B?RUl2dmdWcUhUQzBEMks4eEE4YmFFajRyTXdxeEYxT1RsdlFJSzhLUmRkQmkr?=
 =?utf-8?B?VmErakFsbXMyUXA3cFpKdkh5Rk44YmxaY1UrUlZWQjBycU1LWTlLNjF2ZVhv?=
 =?utf-8?B?UHJleUFSR1BIVTRBbGZneVdGdWhYQ0hqaVluWHhzZ0E4R3pBcUdIUndURXI1?=
 =?utf-8?B?RWVndUNkRTMvbFhEbkRYZlFPckJlQ2Q4WXVLTVhrZmRHUjd4Si90Tng5aWlK?=
 =?utf-8?B?SmowSWQzZjhta213QkdwbFdvVW0yRlE0aFgyMEpuR2s4RlpuTWU2THc2YzI1?=
 =?utf-8?B?OHFiMjNIVlcrYlBaemxKRVAxS3JRdHg0enVTY3VBTDV4QVJKMDQ3MEpxVnV6?=
 =?utf-8?B?bEVkbk1YVzRENTdNTTl1Q2hIKzIwTGM0RjJVcE9QblBsN2tlM2lta3BqcU4r?=
 =?utf-8?B?bXNoMHlYeTFxSS90RlREVkR5d3JXa1FOamJCLzJqOXQzYklKaUNRSjE0L21G?=
 =?utf-8?B?WndaL2NTY1JyM1lMQmhZUnlKeVJXakF4c1lhSXhhdUNiUUphK1RmK0Y2SGcz?=
 =?utf-8?B?WXIwWHRybFRnZ1g3aTI1cTRoZGhLd3ZFR2NkQ252WXhEQUhMakVsZjBIaEZo?=
 =?utf-8?B?Y3oyY1RZcktmSjZuS0NwUVdrQldhZWFFVWw5STFkVkZZaHFya3pmaXVSVVR6?=
 =?utf-8?B?QStDVDIrNC90V1lRc2I1c3Voa1JHeE9GazU2MlNpQWRISktvc0hjbkVqNkJS?=
 =?utf-8?B?SGZtOGxUTWxxUWdpLzRLR0JvRFJ0YVgxZUNmOWxIaDNwcGhrYjZ6N1dKZTh2?=
 =?utf-8?B?d2l3cDJ4TCtBMkJJS2xSRkRtMjB0TWtkWVJ1V2lETG92YjF5Qzd3VHJIc0N6?=
 =?utf-8?B?aFVpTi9YMW9VVmsydU9hQjIyUXBUUnhITzlwVHpDdWZuSmRWdFIrNFd6RjFr?=
 =?utf-8?B?ZmVlT3NrWkZlWS8xZjVzS0hVTUxGR2M3UjdvYXlhQU9UTVBoUXA2bnFuRTJl?=
 =?utf-8?B?cnd6Q0NWcllNaEpMQWlLc0VTZ3FOY2h2QzduMElEVXIzK3o0SC96QjhpclBC?=
 =?utf-8?B?ME1icmgrOUt4MEl4clZ2REdoR1RNVlJpbmptWlN0N0MvbGFuZHBuTksrQk1W?=
 =?utf-8?B?bGNGR1NwOE5KakU2MXQwcklteUIveUpadlowWHROeTZKOEFEUEcvaEc1TW13?=
 =?utf-8?B?Y1o0YUtWcEdCeDIwSjhiMVBLdWlpK1IxdHozSXBibENJbXFqUkhab051Ylkw?=
 =?utf-8?B?LzR5UVpJZ3A2dmhCL0ZpL21KdERLM0RFdTgxWUZqd3JlSUFyVWFKOER3U0Zx?=
 =?utf-8?B?OUNOK3dHWEg2ZWZqTGJTc2FKVkdTWU42NGlEYWhzMExZNlFNWVVsd2RUbTcx?=
 =?utf-8?B?QW1kSnp0UzZTNzE5UTFOOXZQZ21Ga1diWHdSOU9QL3RaRlk3ZmF1QjBwVk9l?=
 =?utf-8?B?aTR0OHBBWENQa0t6OEZrSFc0WFJ3ZnNoazFuRTUwamEvWDUrN0ZDTElWRWU4?=
 =?utf-8?B?OWYvUEp1NzhBWUdxeDJmNXpuZldQdFRNOEpQVnp2OXhMZDB6eTJKUXZ2UG9u?=
 =?utf-8?Q?Q+QdUPIp+ykhU+5ODW0pVcM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aezWesKIhNpTC++hlV/WOV7isp/OJSKg3LrvahyETXUhLQqM/QNZ1u8HynyqJgqahHP9aKslJR5mPKYT6MY4BowbcFnwRz0SEZe2G5BKDQ2xz2R9jVZTMXuPSpuolfR8GwLJWQuryPLCR8idm/ZBM8dAYUxstNHFLTDoc53odMZglT6GESFHXxL6EcV3PjdPgUK3ib1T3Z1hO4mEdDtrD7qkG76lvWM9piS3SiRvF5YXvQUXmCGZkj2aThsVHiKOWZS6r7bcmZsH5gf6EKHyxTXbpT1XunxZCXiTtkk5cEaz+hucj2lE8eqrvGHoFNjipilEzetSY0qMW84RTDgxn3V7yqOu0FOxndNikai+IdMJj1SqpzlR01m9QtVBeynHsz74UCXYy/u1eYg7p9MvWCdJ8t5pFLxBPS/N34Thj5s0tfIy3hqVDaQ1iQfkBcD5YYvUM/wEc1VYJ1N/ImkN3DiKTZWtSi7XCGjAN34rXzwefpfOZrHvulfjQySDgnK3izgq/a6NQfRcmq2vYDtwvIBt0Tp5Bw93JNJ44ZSe0nlGweoZsGPvm6vznHLWx4dMggCK7BG80aMmL2FGIfNEkw3Hup0eNS6du9GQ8lqmScw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 376ac45f-dd4f-41ce-b79a-08dcf7d749ac
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB6873.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 05:05:20.8936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xHCDEHG0vaaXPB15Jg+fgFhggw4xbyNtNwrcDWejH2whPRg0r/WDnzs8SEx3AbhKh2E2UE+NdNe3zxlJopr7hE0HoLh7HQAz+e7VD/XHYkz2XIFxdxrqd9N9jm+CQo3F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4198
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-29_02,2024-10-28_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410290038
X-Proofpoint-ORIG-GUID: 8h5d8GDqgWsYIvDW8vn2GAdRUHUSLS3n
X-Proofpoint-GUID: 8h5d8GDqgWsYIvDW8vn2GAdRUHUSLS3n

Hi Greg,

On 28/10/24 11:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.59 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

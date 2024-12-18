Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF9D13F42A
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 05:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734501027; cv=fail; b=g65lmiQa+EHs3+AV8JzN+XijpGI5hkA0HDlKWB/LXIKA3iiceNaUqy2hxnneK3pzcoY95Zc8xoTJUX363aq0EqUOsH/2SjiVGkAonVeAJZjgTgSp69v45gzW0ifY9MNY9weaLu0RqRq6l+YtkhSbbkYiGKLAVFL5ofSdc9qYXZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734501027; c=relaxed/simple;
	bh=Un4I/1JOfNUNxuCtCWTPPSDFN0T9fWNM9WdgM9yzvrc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uJNU3A4XNziBjMO8wXA9+Zlc7/inVT+mf8dVzQGJoCzJXHnnOrynxSmJ3us2SMIhcbsQU8xm61ewgrP1Ss0vGqlT9155Ik/31prjbL2XAviyi3RSq4z3QSSFodRfOJjyD3kwY27sce9TEsIozRg9GRa+ZCLEG8ZcPwt4KyqZTS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZCr3BMvh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CX3/Jrfe; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZCr3BMvh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CX3/Jrfe"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI4uEwY015884;
	Wed, 18 Dec 2024 05:50:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=pGmzsuhJntjTqu4/3NVagbrCqqvmZ9hbKhkMh1AnCIE=; b=
	ZCr3BMvhe1gx0SaBCmPqpFy2lW4GFQqTwcck2Jl1P4hEQYCguqEULbGpmAeazpKK
	Dp9HoF9TXK/zRcm5BIIqi2QC2butGUvoS9XwlPeFskxoPa6m6ttIrsoNwAohfn15
	5wwuRPsBVlXZ2uYAblLZWen8OWq+J6xf5nqONKM87ns1O/eWEkW1FMLDO4ab78vU
	Ku5u4s75qoc1j8cUCevfAkvTeB6bFh/LRP0vQ8YOS48irzZqLBknvIE+sQzGSd4q
	sAhr+o/SNaBA5oGgWlnzMspIx0vDdqtQsYLLo63TSx0kipgn3x1P0EgXEycOV7PR
	6iPX3HD1WjzNps+qXwbfbA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0m07x6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 05:50:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BI30CnB010942;
	Wed, 18 Dec 2024 05:50:09 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2043.outbound.protection.outlook.com [104.47.55.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f98vmr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Dec 2024 05:50:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jcdyf3vNb1HKwou6psil4t+vBABcu9FAMU7rFDHnQWxkQkwqJQGqjNo0gdrJc6fkatZpfC0fxCZjbECvZw6li6Wo3HsPnVwoNkdnGf6zbUzARClZqLvNPU9u2Efn7RvBMzQHnxmPIAfO7VdEfo8tIOWAw4vve1WnDiGXnWkjs2iCroGilBwg8xSPS3phoFKoR3Bn0nOgb/pc4oRO6gBqxkayRG0PSiRUCWPflh82B1L0cWFt4Ctp45RWvZdykxRnqyzOZkVdDKsLxP/d0j5YF7XEPq2+KejGf6gAe3/wzULDizGF/XNRk8a2hCkWGLnu9zizLKQznSGd+FUcLz38Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pGmzsuhJntjTqu4/3NVagbrCqqvmZ9hbKhkMh1AnCIE=;
 b=vruVI6fQEkhaVVgA2qhquzpW55VB3o2BIbBy1AyYoFxp0oMXMmlExWXfnY2YY2erp1KqtcSHSdm8LL16OFbfAfkmwKBhUP3g1OKNwpRWwjKOmYPOVdMobGrGhBL4YnXqTRwPF3wiyR5x9XYN+e+ApoE/bpKdP82UKvE38aZZdPSn07vcjkn0hQnsVbgAaCK38SSHV/vW2D/CRTZSJdHL7AKHt0NEtiVaiqugp7jiSHcR4DMCyfDuYMTxGuu09M3Z0h1w6Fu5HTc76m834aOG98wBEZwTCzb3SjCexs2ANR57dSXj5Ai4xeOrNvFt0zD+Ie41O8QtT517aAQSwWf17Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pGmzsuhJntjTqu4/3NVagbrCqqvmZ9hbKhkMh1AnCIE=;
 b=CX3/Jrfe6HVoH5RJ4kpHGcrVw3dUsTWSNYsVJOz+khZTUUvsTK0zNqRzvuMOxUCJERH34azMKW0YvfWp+aYbDoomZTiFYEH87+5pSecTAyjm9iVWh21+v/ZzMOvytYmYnqUAL+iZQ4bTZTjsZHyCUY+xGRnwUKO7IIil93LAJOc=
Received: from DM4PR10MB6886.namprd10.prod.outlook.com (2603:10b6:8:102::10)
 by SJ0PR10MB4576.namprd10.prod.outlook.com (2603:10b6:a03:2ae::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.13; Wed, 18 Dec
 2024 05:50:07 +0000
Received: from DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38]) by DM4PR10MB6886.namprd10.prod.outlook.com
 ([fe80::bdcc:98f5:ebd5:cd38%6]) with mapi id 15.20.8251.015; Wed, 18 Dec 2024
 05:50:06 +0000
Message-ID: <b2c40d56-9ee1-484c-bfbf-d1c4a45594a1@oracle.com>
Date: Wed, 18 Dec 2024 11:19:48 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/109] 6.6.67-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org, Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20241217170533.329523616@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR0401CA0033.apcprd04.prod.outlook.com
 (2603:1096:820:e::20) To DM4PR10MB6886.namprd10.prod.outlook.com
 (2603:10b6:8:102::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6886:EE_|SJ0PR10MB4576:EE_
X-MS-Office365-Filtering-Correlation-Id: f1ec90ed-b8ab-48fe-0da2-08dd1f27d33c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bE00YmdJVHpqQ3lWUGd1MTE2MmR1bU53a24vT2cxRXhKSGc1d29qbmYwcDlK?=
 =?utf-8?B?d2IwN2JlMC9seUJUT1k1SGlIMUhnU0hRTUJVWkp5alRIRm8vQ0pOTHpxa1p2?=
 =?utf-8?B?MnpoZ1RQaGw5WFJQcWtwRWkzVDhFdzBNR1pXc2NGUlpETWlxOXdmRmdhL0tk?=
 =?utf-8?B?amFYZ1AydWs3Sll2VVloTTA3Si95K1pHVDhyUmxEM0xacWNqTlMwTjFOeVlo?=
 =?utf-8?B?K2E2cStNOWh2bkpzTC9CbXczMm5DVTgvOVhDN2Y2T25tZDJYU3VleDhWa1BV?=
 =?utf-8?B?L00zVmtGemVUN0VDQ1ZiN3FOVDNkcFNOZVM2NmxKRThmMCtaSHFnbm52VGFR?=
 =?utf-8?B?UjVuM21ETFZtYjBReGk4ZXFVb2dtY3pScExoa2wyWWR5T29veHRnQjdQM3VB?=
 =?utf-8?B?WFZoZk03Vk51ZXpIaFVmRXFGQlNGbXhxVU9lSnFYNWxoRk80QldTTUV2c1B1?=
 =?utf-8?B?RTNMR1hMN1J4MDI1R1o0QVJMQWtwWXJ6N0YzQWQraTd4RGgwdjlnM2I2RllQ?=
 =?utf-8?B?ek1rbVZqbWcrbXFVM09HWWgxSVV2c3BiSUtOeTY0Z2lGYzA0K1JzUHBxNHIz?=
 =?utf-8?B?bEFPVVQ2bDVsaGdmc3F4V2xpNGtVeFNNWDlVZTR4dWczTHAzTi9ITmk2SXhS?=
 =?utf-8?B?U0FDSmk5Nkt2MjFXa25OeEFkS214bGMxZUt4YytDb1p3bTVaci84d2RrVk1K?=
 =?utf-8?B?YnowWEoreENHTDFyYlJQSXR6YVp5QWllaWErR0Mxcmx5R0hoaHdqd0d1Ni9k?=
 =?utf-8?B?eVBLWlYyZ3FMRHg2SDVBNktoTDcxVndiT0V4aXRsb0xyRFFqdWhFWTBjNWo3?=
 =?utf-8?B?NFYvVzhnc3FXM1Jxeko1UWxjNlBNRUx3NXpSN0RvQ3lFOVNGRGY5SU93RlBE?=
 =?utf-8?B?MkpzaWJVNlEraFlhNzBLVXpTT3o1bW1LUS9ZTDU0Mi96eW05QzRVcy9WMmtl?=
 =?utf-8?B?akdVbG9xb0N6VkNtMGVCSlNEaFd2N0lIUnY5MXduaGU4bnBtRExNZHU5WnRE?=
 =?utf-8?B?eEYydHByaCtRbmRUa29MRDRmaC9nN2E1NmhZNHR0MHh3d2tUWkh5TTJDNzBZ?=
 =?utf-8?B?RlRDL1pxVVNSNzNsSXJkdVNUcXRtdjdZa3hCUUFJdlRhR3NjeXI3a25MYUpR?=
 =?utf-8?B?UHRCYzhITFV4a0UzcURpdklkbjNQcVl3SjgrZE50RGJYaGQ1NllLODZPRFpH?=
 =?utf-8?B?Q0NjcElUaFpwUjFWTzk0ekJmdDREN1dCNTd2QUdKT1JEYnN4R0tJSi9HRFFZ?=
 =?utf-8?B?UDkweXE1cStvNlBnMnkrQTFKMHg3Nzk3Smt5VHpRMUg3NUE4UzdnR2JDWTJM?=
 =?utf-8?B?elB4b2tmT3pGNDByUFRaWUMxM2ZwWHdtQk43MkRQODZDemhFYjVnUFFVSHlQ?=
 =?utf-8?B?S2xrb0xBUVdKNWJOQzlWdTRzelkvcVRkeG5Xa2h0cXllNkpmeG9jaTI0dEg4?=
 =?utf-8?B?bk5VSm4wWlF2QlRWQm83dmZKL3JhVGN2VlFuRmlwWURNTEpLQ08vWFN1YjRL?=
 =?utf-8?B?eEZGRmRCSnFka0E4Uk5YbFVlbDFnR2pyS0JDalFqQ1oyYkVBNGU1NVJLYWhr?=
 =?utf-8?B?L1RaL2wvNW4reTh4TVBCNzZZb1VBMm13VnQwWGRKT0t5dGd6ck8wYnFEejFq?=
 =?utf-8?B?VVYyR3Zva3E5V1VDbGJtVFNrdzBXakJSejBhRkNCb1gvU1hVT1JNVGR2Qzh1?=
 =?utf-8?B?WEI5R3hOd3puYVNDZjhCNzhhRkVoZWV6aE1LN3NVOWhqc2RYOTkzc0JqMWJK?=
 =?utf-8?B?djJDNUpDUGlYTjQvL0UyM1hkRWs4b1p1UGJkQW5HQkVpZmJLVERwUWp1c2Qr?=
 =?utf-8?B?bjFuNWRGVGl4SDdpTHNsVzd2R1RNNWRUZXdDL1NWc3cvMVRzdm1teVdic3My?=
 =?utf-8?Q?CKTrR6kMVae4H?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6886.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?akxGR1lkRFJ6aGM1b09pb0pDdk9Oajl5Y2VKV0VsUHNzSDB5dmx6aWxub3Az?=
 =?utf-8?B?NWtjaVZJOUU0Nzl1d0EwTVRKZ29DNjgvYXZTazh4aVZ0bzZwNEtDYUdmNitX?=
 =?utf-8?B?VkNMZnltK3EvNzNCT0J2UjVnV0FIWHozUUtwaEVNQ1k0bno2K3pvcHF1VDdm?=
 =?utf-8?B?eEl3OFVUcWo3cVF5b3NkNzFBSUY2eWNaUjZhYlRmR0x1NDlTY29VWGpHUHBP?=
 =?utf-8?B?YW9DbkxSZnVTcUFIdTVkVlVqbGJjVDJQNUFlbXkwQm5mUjVJdVNMWkNuNUhQ?=
 =?utf-8?B?SWwxZFJjbklCNEhwODI0NWd3Z1RiRHo5dkpXMk5xR0Z2M09GbUZxYlo3RnBm?=
 =?utf-8?B?VEdrR0Vhbm5veFB5bXFxTG1wdmFIRmJZTUoycjhMdjJhOXBFaHdNaWhaZmtB?=
 =?utf-8?B?RWNFa3NrYlVpK0UrVGRmaDVrWlNTK3VzcEx4Q2RRb1VkZTNKQjRjOGhvYm53?=
 =?utf-8?B?ZU9vdWozRlJuemhlendhaHRjMVJwWjFHNjlTbTFsamhFL0hsUjY0Y0NtOENn?=
 =?utf-8?B?UjJFNmlLWTRuK2pzcGxUVjJLSzQ2b21NSGhmR3lqa0VlenNCVjRzOGUwSzJZ?=
 =?utf-8?B?ZnNSVG9tekUzSm81TytGc0xtTGpTUlhocklud1R2QkNITitxWVFCbXU3Ymk0?=
 =?utf-8?B?ZHRKeGN1TXBOQzZjUWphL1ozZ1FFelA5bmtVSW5DZlNTemJLeUxJUEU5OTNR?=
 =?utf-8?B?UXhRelozUlBXZlAxaU41Zm4ydkREaEhYckpLOWFJTnE3WXJNZDRPMFNaTFV2?=
 =?utf-8?B?NzQ3MDRFclQyU0JYcWZCNkg5UEVDRG5TV0pUQk5LR1doSGZvYloySWczOExK?=
 =?utf-8?B?ZThWSHZXRUVRclNmMi9VL2hMRHVxRHl6N0p2UkFtZ2I1SzNrTFpNSHEwdXRx?=
 =?utf-8?B?b1FXQmQzeCtUTFI5MVZ6R0hwZVVlY0E4cm1RaFQrcnEyR1lSRzZxRG1UK3Ro?=
 =?utf-8?B?VDdScVpVbnBRN2JNN3JveE5CdzFYbEV6NEI0aWNmK2JLMzJOT2U1ZzlzUTFm?=
 =?utf-8?B?VDQxaEphSUhBVnlIWkVLNVdaUWF6U1c1VjRQdWN6S21tdlBrMzNHUXpTMFpw?=
 =?utf-8?B?WDRUZG03a0YxaiswaC9BUmpzSUUxZzZLcWlwMGRZd0sxdGwvbmlUN3V1Ulg5?=
 =?utf-8?B?RXhUTVRHVzVNYTgyZjZvMkorMzE3RTBoMnlDQm1qdldLdFIvZ1k0aWxTZDVt?=
 =?utf-8?B?WHVBdzRqRkt1MkJCcUNoNnhYNjNSTlZzVDdXbEpZWFZCU1gyZDdNLzUxNldm?=
 =?utf-8?B?Q3ZXUWlGeTY2REkxSHl6YW4vYWdsdkJhck9OQWpvd3cyNERJdUJDeXpHdEQ3?=
 =?utf-8?B?ZnY0Y0dlVmdlL2hySndmbjRlZDVsTU1zeDR0a08zMFI3dVh6cEg2ZW9pSGE0?=
 =?utf-8?B?K2lzQ016Y3VJOFZRVkF4QlgxT3lsTitVYjFoODZKU1NZZDdHWlF6cm8veUY4?=
 =?utf-8?B?bFd3bm9ORVJWUXNqUG9RbU1MTHlEQzEwak1lZDZaQ1UxTzdBWjIrR05UNW16?=
 =?utf-8?B?U0llRjdvWkozR21VUVMvZ1Ewd2lCOENDUXZ5TGdmell6QkR5T1VVdDFFS1p6?=
 =?utf-8?B?N2V0SHdMSW1hSDlKOHo2dERXL1NBZW1Tc3RvdFZDcjJWdFRYTzUvWmR5Ykx1?=
 =?utf-8?B?dTh2VHcwOTUrS3BCRlRnZnhvMmpUY1lTcVVyTzBhMG0ya0RxVzFiOVlwYlRU?=
 =?utf-8?B?ZVNlSm5STmFURGJZSVZ0QURnck5KUEZiSXlBTVdZSTJtb2R1QUVXZkhtVWhm?=
 =?utf-8?B?aVFJZFZyS3krOHRaQTk1ekROdm0yUmtpYTZMVXRtaGxiYnJtNWxCaE8vY1Bt?=
 =?utf-8?B?dy95TkJsaXY5QzA5SzBmRzBiTXRPSk1qTGlxN3FFSjFqRVNNMlRmQjhFRE5h?=
 =?utf-8?B?Qi9LV1BJZ01NUmJSMEg1ZXBwT0lORXBFUnA0UmR6TS9PRDhxN3NKV3phNEJo?=
 =?utf-8?B?MTkwcGxkZGR0NlFtV1BQa3N1S2hTN3M1NHdRdGFuYmVwcWpwbGt5aXZRLzY0?=
 =?utf-8?B?bzA4bG5RU29tTGFVWEZ5Um9CSUlqcFF4Y2FxUXA1YjRSY1A4ZjcrbGZsUGhQ?=
 =?utf-8?B?U0FHZ0tONWY4Tk5SNFBPYzlCcDliZ2RRUU1EalBZRDZwSUlpQTg3azV4Z0JS?=
 =?utf-8?B?MCtMdU9YekxqRzVtTWxjWDNWaDQzL1FUcXQ3RWNjVUNiWDdWZWlTd2NLYVFs?=
 =?utf-8?Q?YMjanaNYKBegqgwj2Qzl87s=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	RQuXNRExWMpA/XFHPFw9BbOMLFECF9oP/gOAielm5Zusy9xWQcjxgnuqF77xLBP30OUDAHJPaCBu8QS//dNWr5XYOgTwb5wFG+HZ702QSWENYvRHJXof7HBIyH9laRmzmol4KLsAt/T8uyPANHwvjAmCeHZUOrfIpt7DkN9ft3IHVuj6LDZAna8FBYG6XKiq8naQBLQUXZ5ti1aL7cA8EI7tgj2Li8Ce78p2n0Q5qRjUWZNe4uSPts61O1k8Eb8P24FjQqKPOnpGmpiXypo2AHheRL8I24p1KlDgkSmPaYZQLDKg8SDi837AGvIqdy+MP4f6tqxo46KEEI9nH2wYxt6Dho+eDKEOrzo++/GeGsurDw78W8xy6rsEpw2EgVcofgvqtulhn9vBsNzcbp8lD93g2EwF+N3e34D8k7hKj29LXAmu8LxdumtlLNMSZU9NRjKk2s1pfV2/TyltFGGeMi24qou9pJqTXlqwaO4H13uErTKqGhv8j9G9yUtOaJnJkc0ZZZkgImovFnqOEtDkepxjp0eUP+gMZ4DO1ntWfwO22APaOinMhIDc16T/AVw8eihEcuVpJvSsbDdVIanCuSuf7SHi1FIoJRgV7l6WoaQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1ec90ed-b8ab-48fe-0da2-08dd1f27d33c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6886.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 05:50:06.8418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fSelJ2XPKo5GfReqZclEOjQk6v7vtfvh5P7GnMozLKYzVEH+7DWIRweAj/Uk4NmZGVDtOl1z/EoDVRlRc/9R2VZCT2Hcc0k1H0H1CXjX66a5IxPL8bHgcQJnklgMi7nV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4576
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-18_02,2024-12-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412180045
X-Proofpoint-GUID: bLgLnOKMN9R8_tfQ_JaV-QmYgqP60hjm
X-Proofpoint-ORIG-GUID: bLgLnOKMN9R8_tfQ_JaV-QmYgqP60hjm

Hi Greg,

On 17/12/24 22:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.67 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.

This below commit is causing perf build failure, could you please drop this:

 > James Clark <james.clark@linaro.org>
 >     libperf: evlist: Fix --cpu argument on hybrid platform

evlist.c: In function '__perf_evlist__propagate_maps':
evlist.c:55:21: error: implicit declaration of function 
'perf_cpu_map__is_empty'; did you mean 'perf_cpu_map__empty'? 
[-Werror=implicit-function-declaration]
    55 |                 if (perf_cpu_map__is_empty(evsel->cpus)) {
       |                     ^~~~~~~~~~~~~~~~~~~~~~
       |                     perf_cpu_map__empty



Thanks,
Harshit

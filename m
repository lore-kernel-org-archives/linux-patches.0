Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012066.outbound.protection.outlook.com [40.107.200.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3082E92BA
	for <patches@lists.linux.dev>; Thu, 20 Aug 2026 23:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787268999; cv=fail; b=rPwKDvA9TfX5oSNVIutEO2w6pbDG8J65Y/sZtIg0q45+ZKumSBOTiiIzWC/vxA69hNYSTJYN6uixadCSFIc8G3GBfwo3ztkDfL+YBJDNNmdGT14hiJK03/oxWPIRYItWiTE5GaVm+HQhSoXXlLrRv2tSVUuHazNSbvyRCKjk2zM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787268999; c=relaxed/simple;
	bh=u+Fk9Rwu725t7jTZE1uMRg4gHbA9ae/D92ZoNoO73b0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nsz7sCdCIqL+d1iUsak42v/DrD9XSngvEvsFkXIcXCEQ40WCtUB7JU5fiWh8fO/HC5TmEAEDJqY85nGoc2nouAFDAbnjZNnl+OZcYtAnrR275tt2ZFiIovJAJkkETmMb6AWOj/rns34E8PXzSzw0tv2wgRErytCj78CFIjTbCg8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AGj00Urq; arc=fail smtp.client-ip=40.107.200.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AGj00Urq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EJWpKRNrkY6GjeNuFnq4vO7RAOHfnrCKoY5FnsYWNPzugkG+Ozyq6tfTYJ2jVeoYT2cRWS0SerwpsLm05EWLeAR0M6fe6GeKt7T5nFiF19mHDsNvc58bjlkhCrobcO268PY1/kh0CnvXyv6klRavr8/wrIHCo3Zv8nAcR0UdmnUB3M9Cr+HLe3Ixq3HjHUhYZfmr8HnqI/1VgFXqmbQ0p/mcGM+qpCPPRJmUbHZBfz93YWCjE7DYX4uo5LtaeTbR1ac60IMuxrQLFd/gV1pZOTOosrRmJp8x6ZORj3t2wDOdrCYoAQvr8rB28QOyfs8jeOksMHbrLzMiLycVrT/DkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3++TxTQjfn/0/MeLPHSp5+hYQxEimzVwFmoTRSypIyk=;
 b=fYkntNzLatjTmcKc55dhHjdkahpd320TN150RvB40UVC6swgStpyflzAaAnUL9aeyGL+gVt+PfRMlUV/oQJxfe0THAdemPaKTad9Phw9uOQ8Ztd4qlkUW6dOdavzMIuFbyEm5jkXpqG5ZJc1Ti7mcCy8Du3h16ptQdo13ldYM2vPxc6/A9fSnBTMSEzjeZ+Ph43ry6kq6ULODqqLODE/8fTgbJX/wdjCxBBK3dtUvbtUw95eNDC46GZ4WzCvQaF70CerQxB/mWM+Ldo5M2NIG3xrGzUIxRtD3J0I81Ag6+jZSoZMLNv0ScTuME2VItCNURDyUgQrCWYQUZwleTn+ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3++TxTQjfn/0/MeLPHSp5+hYQxEimzVwFmoTRSypIyk=;
 b=AGj00UrqAmYrZlJ7oXkpREsXZ9KZDULWkXLfClbspJvzgawqKYNlXWMk3YYfpIsl8KmCZ8DkxW8p9F4s2v1IX+izyfeObGiTcYPaDGVjERUrRA3gXTcaTKJ5jAoHtwEgxvAoS9uIqub2UaQ1jThPmgi/jw7LIMv5v7YxuWP+ETcjdKXbUz1dbzIdZVJaTZ7nA3ac1IEo4p2ssoCjMFyb+8k7yVwgfgRHGcQ5ZcAYMLVHNqKsVGJG5p4/sg2E0j3gCUpV3Oe2xZdNsLi6cBDsmDngagCi8X1IXImdO0duypfkXYjWzVbTiNlWf7uNnDPgNIQ7Zn1ZFHP+5i41rYmQvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB6063.namprd12.prod.outlook.com (2603:10b6:8:b1::19) by
 SA1PR12MB6871.namprd12.prod.outlook.com (2603:10b6:806:25f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Thu, 20 Aug
 2026 23:36:31 +0000
Received: from DM4PR12MB6063.namprd12.prod.outlook.com
 ([fe80::c06b:5df:6a68:1b06]) by DM4PR12MB6063.namprd12.prod.outlook.com
 ([fe80::c06b:5df:6a68:1b06%3]) with mapi id 15.21.0339.008; Thu, 20 Aug 2026
 23:36:30 +0000
Message-ID: <ac05ec20-03ef-4fc3-9821-c79ffadb3172@nvidia.com>
Date: Fri, 21 Aug 2026 00:36:22 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/303] 6.1.184-rc1 review
To: Pavel Machek <pavel@nabladev.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20260820145253.200766705@linuxfoundation.org>
 <aodHg8XQDxFP8VDp@duo.ucw.cz>
Content-Language: en-US
From: Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <aodHg8XQDxFP8VDp@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0P309CA0027.EURP309.PROD.OUTLOOK.COM
 (2603:10a6:20b:28f::16) To SJ1PR12MB6051.namprd12.prod.outlook.com
 (2603:10b6:a03:48a::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB6063:EE_|SA1PR12MB6871:EE_
X-MS-Office365-Filtering-Correlation-Id: 849dc068-756c-40e5-09ce-08deff13dc13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|10070799003|7416014|376014|23010399003|18002099003|22082099003|10067099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	PvnLMpUPLd46hKRqGJIf2JJGh58L2KYs9t45fdCl1TjD/IH4BDentp4ETuRnKgFjY1+s1HYgNa+fT8uDLCDgbr9RdThI60SspFINggAiNdXbGicQTfN65521+8IE+cWB1NyjDT3IZ/d8PF8kdFk4/3NQ3amkRAbFU4mEfukw49NobV8EbwJZZQtU8rCSTyL51TnvoIb5tyZpWCcad/2aMjm43ChynZKcLV2GrUQ41ELGjXrjHegYZivvQBO1FUxFlmlbVBRX+GcQoR3Z8d7yHxICm0s0y1UGd3YlwRSw/pbmLTL82Gk2gBjczDK0j28OxVXgW87YhR1c1toKSXarXrs1kIlFeMMj5KwtA8E2XiSej8+x1gO8Wduc6tX0DgagrsQBKXa5IE9Kv/+JRMvdPtaShjWt52qgL5qs5BpRVzdZmuzpID8v6vhpTOZ1SkX8D8jGI4iRO8F+zX4uKtGRolfJeLUvITT1Bq77MJd3CIWfnf6dLu/GM9xm6RFBBbsftIdnVvxG4nES1oChKgYlbNdNZ3mQ7oqvZX4DVFQKUK7nG1bipqgjEh4D+aeKb0g14BR5VDq3AbqNIZNs7Hn0NGsTfjylY1vW5JO6FaqJgtuESI5HX7AmxxZufdbM/SEeiMCNs0ifg37Bej3V8fLtEkl+U50wpbuGdEywXBxcEhA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB6063.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(7416014)(376014)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aW1MemFWUEFabmJ5eTVqK29pUXZ0VTdQTHRlVFh5dFlPc0lQb3E1VEJZU09Q?=
 =?utf-8?B?YUVySG5aM0QvaVpva3h5MVBueDhZaDR0L1BCVXNkQjJuU2hUUm5CMkkyMFE4?=
 =?utf-8?B?WkRtbDBsVlJQT21rWTNDdmJrSXF3b2N3OTRSVmFsT21sLzhMYTNyOFJFU1gw?=
 =?utf-8?B?WmJtOTdQMldMZWpQM3BhMGFUeTQyRURPN0Qyc3dDdy90VEM3a3NuR0kvVmZ1?=
 =?utf-8?B?SEFDS2NKMWZaZGRRdGRrMUVUcGVsRTVrNFM4M29iWUc3NSt1K1FFQTFBdzJn?=
 =?utf-8?B?QTlWUldvRXM1Q2pNK3RvMThEYXRvYktZS0JLVG56TklqblgwL0s4eW9vQS94?=
 =?utf-8?B?aHMvK3dnL2hyTUtGRTlDbmZzVlFZYisxVGxKRTIxei9vbDF1bWhwaDZxTVF0?=
 =?utf-8?B?clNEZWpTYTRKcG5wb1pRaEY3V01kYUFacFVRVHY3TEJJeFl1dGJOU2hoLzNz?=
 =?utf-8?B?K0tvanBhc1MrWC9NVThRWHlnSDN4ZTBjcEVvUlRLMytxOXJuZ1dHZjFJY21Z?=
 =?utf-8?B?ckJHK3JSUjM0TWVnYXl4eFBnQkZ4MFE3RkROQ1NLVWNhYVBmNmpoemg0Nzho?=
 =?utf-8?B?TG83ZGZ2QWpsTlV3QjVSby80cnl0RWRVRXdBVlZmOXBaZng5OVQzVFlPREdm?=
 =?utf-8?B?M25yKzFPTzVCT1FTN0p3SFRHZDltK1l5RFJUb2htVVk0dTErcFVUclJZRlFF?=
 =?utf-8?B?Si8vWi84akliakY2dW94WEgvdVd0MU5tR0srWXN0bDJXZ3c4SE1HLzFhZXZV?=
 =?utf-8?B?VytsS1lsVCtWeGhlQi8vcnlRVGZ4VUdkN2NlbFhIUWRLekN1ZGtnTHFkWEhl?=
 =?utf-8?B?VEpHSnB6cWROYURlSVZLOU5BNlZiTk4wbktUMlJiMTE5OFFlQWlVT2dNZk5w?=
 =?utf-8?B?TzZad09lTFdkb0IxQitMaWd5Skx5YWdIU1FQNHBWRGRxMkdnY3ZuODV2dmlE?=
 =?utf-8?B?bjd3dWUza2MvN3lRTndiVytSY2ttZWFSaWJUTlc1RGhtb2JPd2QzejhmUUpR?=
 =?utf-8?B?aFFLeWoxWXNTMlRQeHBDSjJNemY4TVpwUkxiN0doTEM0Q0RYVWFkN2oyNFds?=
 =?utf-8?B?d01pUkFITG9ENnRhaHZlNlFRcC9zQUYrdFBLRW9LZ2dCRHBiZDlVdSthaEg1?=
 =?utf-8?B?NlFvR3JtUWNaa3NMTnJqaVduNXVPR0ttVTkyMFJBRXUwTDNGNFBQc1FFeVpK?=
 =?utf-8?B?d2lCam81MDZyZGZUMHJOVURlOTlhOVBJMGRTZnIycGk2cGNST0JrYWNQTjZT?=
 =?utf-8?B?SkJIdlR5WHVuSVladzI0NTFOSjhFUkdaSWVoSzNnRGFwTXN5K0dLQVUxUTZl?=
 =?utf-8?B?QWR6aDRaUEMwdEMyZFpoeHhoRGExd2tKOGN3RVNzVlNuYmtORTZicXRLNDNq?=
 =?utf-8?B?U3NIM2VNKy8yODZUdmlZR3pIZ3NyejhQOXY1eEprdiszeEk0N2IwK2VlVVBF?=
 =?utf-8?B?WDdicDJJMDRSZlZINXliRnR1a1QzNjFNTStZcVlrZFRCdW5qUVNhR205SWxV?=
 =?utf-8?B?eDFjdHlLWE9wdDVSMzBGRDg0YWdLbUlTWHFBWVNFaFEzWEdZOWd0QUNFa3pD?=
 =?utf-8?B?aTF2Z004azFGZjU1bFllVWFjSnowR0pKVVBVbXVySURaQ3ozR21NV3loOTJw?=
 =?utf-8?B?WFZxRTVEQkNMM0VIcXNMVzBhelhXR2lwclVQblArcndhSGFTS1o2TnU0RFor?=
 =?utf-8?B?Z2J6clpzb051WFptTHhvWWswSENFeFdLazY3V2lGOWVvbjFXU3RYVTE1ZU11?=
 =?utf-8?B?TllYMVpIWWtPanRoTCs3TUpVQUV2Y05WUEpOamNTZlp2dWswSGNUM2RjeXlx?=
 =?utf-8?B?WXNqOFpPcGR2dHBkZjJZSjFMT0FkZ1JuTHp2eHFhRjJ2VUN0WE92aHpOOVEw?=
 =?utf-8?B?M2ZxNThJc1ZLSXBmVmx0Q2Y1S29KaHdxOHB5T21WdEZXdmRMeDFRb3hkQXNw?=
 =?utf-8?B?Ym5ZZWpaUkVkSmNFMlFObVg0UXhRWHJqSkxyZW8yQWkrRWVwblpLaVMxbDZM?=
 =?utf-8?B?VFprQXAraDQwWHBXb2c4K2hGakhVejFRRkpoRHBwL09RWnNtclV3YkQ4Qlp0?=
 =?utf-8?B?UUY5WlBTMm5SUnQxbEpmVUZpaEwxOTlGOGthM1J1VzBWWm1YNWExN0VJQkE3?=
 =?utf-8?B?MnlwZ2E2SS9YaEpKRlBRK3hsbExwSTd4SVpyb2tBb25GOThFTkdvL3RGUm5O?=
 =?utf-8?B?b3J0bzVXQXJwajlUcEFoR3RvVWpKTy8vaGxXYWhqY0pWUXZxQm5sc1hqY2ZW?=
 =?utf-8?B?MjhDaFRid0QrUTNFSjJKRUR5ZVVOeTJlZGNHTVFRV0RGZ1NmZFgxamlZUGdN?=
 =?utf-8?B?TkNFSHJYWVM5QStoUDhJb3kwZUZEZC80eHZpYW44WHZwdldUMFJHSDFyTkE5?=
 =?utf-8?Q?sClEl7kdleYE9ik1+OABW7D1fxe4kI4rR1MgpXetdPQrG?=
X-MS-Exchange-AntiSpam-MessageData-1: 9WqfitRp2OUWFw==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 849dc068-756c-40e5-09ce-08deff13dc13
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6051.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 23:36:30.2686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lgh6FYcjs5v2nLyBEsctDTEPKuFA6//H6u+hjavE2H4F8SWNEZOSD2rfavvFTlARw7H7S5vJ5K+T7j8ukxfGLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6871



On 20/08/2026 19:29, Pavel Machek wrote:
> Hi!
> 
>> This is the start of the stable review cycle for the 6.1.184 release.
>> There are 303 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
> We see failure here, too:
> 
> drivers/mmc/host/atmel-mci.c: In function 'atmci_remove':
> 4522
> 15:52:00
> drivers/mmc/host/atmel-mci.c:2631:31: error: 'struct atmel_mci' has no member named 'bh_work'
> 4523
> 15:52:00
>   2631 |         cancel_work_sync(&host->bh_work);
> 4524
> 15:52:00
>        |                               ^~
> 4525
> 15:52:00
> make[4]: *** [scripts/Makefile.build:250: drivers/mmc/host/atmel-mci.o] Error 1
> 4526
> 15:52:00
> make[4]: *** Waiting for unfinished jobs....
> 
> ..looks same as 5.15 problem.
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2776654125

I am seeing the same failure as well for v5.10, v5.15 and v6.1 FWIW.

Jon

-- 
nvpublic


Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DAD23C513
	for <patches@lists.linux.dev>; Thu, 19 Jun 2025 06:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750315686; cv=fail; b=Tpk3OtoT8h+HnkUciL2zmsyyxrcBXmO9bn5+vpuL/SPgVBjwPKphnipu2V5umCnL1IpYPhtZrsUjMfcgOHAZm09clPi+aCDY8EWVlx4v8vxm9UlyosrOq39WX1d8EH0BEwla8gmzhhuJZ01py36rHhBGdXKoPS0oQ/Qkd9zH79g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750315686; c=relaxed/simple;
	bh=JxAqnptWLXOhO4ov+UYPapcvkG+hbW3qIISS1LKjUxc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SYIj4MtKF5lHUQqJ0NMixLn5XtwnBC4K8w64b4a/KASqKXyx+j5lmyXj5L2sRkYbCVDdpM8n60Bxr2GMucdQmdHjyju28BRnDAhh+8Ynnjiii9iueJSdFFY4i0zBO67sAPrv0PnatYVayoIbqjd6zJVk0NA9O+aR1tj0+ICeRiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EPaBQbJg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nawOt4EW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EPaBQbJg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nawOt4EW"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55J0fnTW024715;
	Thu, 19 Jun 2025 06:47:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VL2L/+jyPunsb2Ui36wVmBSweBepbf6Scc0EpTGi6js=; b=
	EPaBQbJgiEf+XNmxsXisa76ZiOJlpf2kWpUpv5cNp/4zSPas/14ah8C5+1acDXA9
	ldofm6BSSQl7V8+BQOYYUnrkLmMUf8+v6n+ymmeD7C/nBQQexh9Jmf7GAm8LXBwr
	fcA0/ZKafbu3FDorJxBi8YuamaMvsDJWE6oRKUBjz/RmeYCYhHD/GfAOqVJJ0+QR
	ovMEK+NoAS/pS1cM870s+pbbwJxc9dHy7rIX7TD5ndBxU2WUdc5XtpbLp3Wc78ky
	4WPF/F5cRKEvuNGD3q4N2yA78bLW+m+VF4AkkJd3cg/Oyb/dGxcs4DQOwefTy0D0
	T0tMt6zGJ9epK8W7AlAfRQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47b23xvub6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Jun 2025 06:47:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55J4bGNI026097;
	Thu, 19 Jun 2025 06:47:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yhhtvu8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Jun 2025 06:47:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R2pE4wa/x9B1WvOoXz823MFI6zV+avSAu9Jnqr3Xe+dETx7YtEYMg7ZzrvivqPOfQqf2MFNO/MA7bODBjAjxVSoh8Utl6GUMYc0g9gqIwe8Ow9SrBuT5ldT8uH4U2Te5cSJ8K6MeLOxUnlx8EDBm97+MTPFHwcHr+BTKQsbqXnjVjcEadWzS9dENL7dGi/3g6VrTb5vrO6rwv9h7JTeqS+Lfp6vVbjlLO6+7ESaEun4EmqA6LhmKM11slgKXFmHsf8rYNeQGyNJ3jCObz4PmTiVPFciAfZUWx/anc9gbleeuTsGOMTO/2vLKaiWIBSlwTOatCGqHBbuFLHr1nInTzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VL2L/+jyPunsb2Ui36wVmBSweBepbf6Scc0EpTGi6js=;
 b=p7vvxarUfLDnceF8ckW4ZLP0En3FEeuDZzMziN4nWH8vsQbdoxiWLYRlh5DHm6Barc9lXnMsXlvYcW/KM/Uh4MKvJht//yXxp0ItXMUcfeCDmrvRV7h5ohDUQgkcLB1H+0KcQDpdf0tqHwO8HAAZvuwNv4ouJkHhX7O9EymMkCC0FXyCFYqbVHZw3Cwmxs9qrl0i2otEPyvdOS7vZD8OLzBed+OhEawAJKe9LtN0UeRvNY7maVzAkxtA+z6sG34ShMVOFA8r+G+HLsJpMjj6GXf9sY53iVydTCilykNGiycerW1M+zp00MJZxOS0R69JBN6RJqZlb/u3ZrEvLi1emg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VL2L/+jyPunsb2Ui36wVmBSweBepbf6Scc0EpTGi6js=;
 b=nawOt4EWFHPQkkrDt0sXq1taxIaUg9ycOQAG28CPLc9b88t7NPr1iBMOZxIzFlsZEQx2fpCTftGkIZgnOpBL5258hYIhFBjFM2MnJHwh3q7xojOt21BbH5RT2/YDhq1Vmt8gG7Q1V/vdst9O4Yph/jOl6o7KYYpCManvhU9j/oA=
Received: from BY5PR10MB3828.namprd10.prod.outlook.com (2603:10b6:a03:1f8::17)
 by SA1PR10MB7700.namprd10.prod.outlook.com (2603:10b6:806:38f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.19; Thu, 19 Jun
 2025 06:47:43 +0000
Received: from BY5PR10MB3828.namprd10.prod.outlook.com
 ([fe80::bf2c:d4e4:17a9:892c]) by BY5PR10MB3828.namprd10.prod.outlook.com
 ([fe80::bf2c:d4e4:17a9:892c%4]) with mapi id 15.20.8857.016; Thu, 19 Jun 2025
 06:47:43 +0000
Message-ID: <8d7c351a-99d7-41d9-8c57-a7701d3cbbcc@oracle.com>
Date: Thu, 19 Jun 2025 12:17:33 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/512] 6.12.34-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com,
        broonie@kernel.org
References: <20250617152419.512865572@linuxfoundation.org>
Content-Language: en-US
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::11) To BY5PR10MB3828.namprd10.prod.outlook.com
 (2603:10b6:a03:1f8::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3828:EE_|SA1PR10MB7700:EE_
X-MS-Office365-Filtering-Correlation-Id: c115b4a4-56c2-4148-0dee-08ddaefd30be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WkNqb1dWa096bk5IVExBYTdBUk9ick1KYWRlY1pNSGVpMEtIUlc1cWJxcmRJ?=
 =?utf-8?B?cFRTUEpDdFJCZytmWlpkRitxbi9ub2M4aTZoRFJqclFVTHR3ZnUvK003Rk9w?=
 =?utf-8?B?ZnhzdVpwN3hJV2xQQit1cCtJOTlIN2h6anBJVUgvZTBmOUZyVmZ4TzdZZnZk?=
 =?utf-8?B?UmtXbFNqcnlkc3k2b2pOU1Zld09zQyt2em1nY3JScVB3N1pJNkJUTnZ5cmw1?=
 =?utf-8?B?bWgrMG5ZQnA1dHZsN1g2cjlnQlVnMWNRUzdSbFBncEVkTHpSdEl0cURCWDh2?=
 =?utf-8?B?ekdROXE2NGxGWEZBRjVubmgxMmRYQ21pblRvdTRZSTZZdVdDaSt1QTBVdHg5?=
 =?utf-8?B?TEhWMW5pREVXZTkxemtBdWJKaWlTUHMyZ3BBN1gyU2JaSUl0NEtveVp6ZDJy?=
 =?utf-8?B?dE9CSXFjdFBBVXJjRXRKOGxudGpESTYyWnZOYkphdkhmeVBNYlY2SGNxK01Y?=
 =?utf-8?B?dmpVZTFFQy81SGtsQ1JGblhPWmhYV2hNUzIvbnF4aG9WZW1qRlR2d2xKLzY3?=
 =?utf-8?B?WnpCUDgrbW93TCtiNHB3YnQzS0xMNmRIcUpiUVhEYk84Ky9IZ0JraXVlRTNF?=
 =?utf-8?B?MXNWaFcrbGhxV0pPeUd1dmpvZUh2YjlvTHl6N0RCdWl5ODZpMHJ1d1lMS3JD?=
 =?utf-8?B?TTBWelUrUmRidGQ0c0owaEJQdVVRMGRzNi9iVjFoM0ZENUJLandlSEw1cE9P?=
 =?utf-8?B?WEFYMXc2VnNFRkcwZE5qdXMwdlY3S3k2eUxWaTdONmEvTlYyRVFMdHVXREpH?=
 =?utf-8?B?dHM3RlpoNTNsbEJmcUsxQm9YaTE1Um9TZjJhQlZwYVF6T1d4dFFlOXhPdWY2?=
 =?utf-8?B?YnZubzdUUmhFb05zWjhHT2J3N0hPL3FKQmZDVE03bkRieCtWOXZpa1dJQUVn?=
 =?utf-8?B?SGZ1LzVsVEJleFhtS3RkS1ZrWkNjK3owT05BcEp0d3lnaWF1VWovODhwcTNr?=
 =?utf-8?B?YVp5SlczTTVLdjBTK2tkbWh0cnZyMFF1WWhYZDR3YlR0QmRGaWI3cERHdUJ0?=
 =?utf-8?B?L0V6cHpzc2J2N05rTjhsNFhEakx5a1dIaE8xeEpDWkRxS0RVYXhtYmxaakZY?=
 =?utf-8?B?UDBBU1pWSlhCcytyS3RMOUFZeDlMd3hJZHR6S2dTUmpGMjZiNEF1MGxwQUZL?=
 =?utf-8?B?cXd3U3FGdURYZ2RUV3RuNGFqYThOclR4aTlEeFFlamU1QzJScCtzYXFRVTEw?=
 =?utf-8?B?NlhPY2FqZjZ6VFBYTjFhUlNNMGp4TXE0cW9LdGFZR3dJNWRjYTJKaTRCbDBH?=
 =?utf-8?B?QmFtU0pXYnNRUUNzNXBQOVBVc2dEWlZoajRoNFBhSXUwQlRrL2JITmRwZzgw?=
 =?utf-8?B?M0lRRzBoaVc5bWo3bjREWWlIbU0yT3pmY21GNGVza3dNSytkbnlLdGxlZlZu?=
 =?utf-8?B?STFVU3B2Y2VpSHMvZUJ1a0YvRWNvbDAyM2M1d3ZyYThoendiK0lweU1VRWhU?=
 =?utf-8?B?TXlaT3lBRG0zNS9ucWVmS0VPRjNSa3Vqa1V0TEcwanJ6QnE1ZVYzaDk2dStH?=
 =?utf-8?B?dXZpUFpGbk1aVEFRRGJWL1ZwN1RUQ2t5RFlKb1U5bHRaaUo5bGhPTVZZYmhr?=
 =?utf-8?B?YzJkTHZ1QzN0NE9LYnYwYno0YjFSemNsNzY1bERpZWxFUmFWWDUzL1RCVlVM?=
 =?utf-8?B?TjB0ZHNMM1FSYXVXZU1iZjkrOXlSNE5TNVdlOUFMdWtFcVYwS2VDNmFXdGR0?=
 =?utf-8?B?cGVjOEFITytMMkw1MDlVSGVTUXprbWlPdnpTNzcrK2FrQzhPYVkyMnZRR0dw?=
 =?utf-8?B?Y2kyZzhjSjhJa1NWRmVtdVRGa3Y0dExUd3VQNkxmNmtuNW1ZTHlnVGdvUVBq?=
 =?utf-8?B?T3BIUnFPSE1najdscTVBU3FVQmxHZWZjMk5oUGJQcldMYThqK3E4Z3YzMzI4?=
 =?utf-8?B?TlNCZzZwejRUNVZ5MmxOMWFTeENpZzN4OVoveFh0MW1MVk5sTXNmV2FjQXNL?=
 =?utf-8?Q?uJ/U9OobuGw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3828.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VDJ5MWxyWWhXK3F5TXBBWEVxRVJyR1hFZU9QdnZpMnRxajR1Qkc5NHVPZndW?=
 =?utf-8?B?bGxvdW83S1VtWHFCeThMbXdiM29xQXdheGFiWEdiYTgyTkVWY2tXNUhha21a?=
 =?utf-8?B?N25FSDVDak9mMnRGMlNlam9XSnlvSnVkUnByS3poTWgyL1ZLUnJNK2pTa3hL?=
 =?utf-8?B?bUQ5UXZuL1JkOTJacWhZVmswWm1KeklOaW9PVzVoWjk5TCtTYWd1TVA5M0tp?=
 =?utf-8?B?Yyt5SjdhSmNKT045K0p1WUZ6RGt1OHhYQWtyYWhOR3JUNXVyZjluSmlGbFp4?=
 =?utf-8?B?MnBPOGtVYi9La01DZTVpTys5czhXbVlCSVFsZzFYRzdWdVdGRVMrbnBuWno1?=
 =?utf-8?B?MTRYVzQ2UWx5WmlzTlhKRUQxMFoxR0ZGV1NNdFBwRW51NStHRE9xY2NuM1JG?=
 =?utf-8?B?L0pySk4vdE1ocFJ0NzJlZUlhWFQrZzdCaFdQWE9mcEJ5TGp2K2xtcUZqbGht?=
 =?utf-8?B?eFZuYTAvcEN0dldUNzNPTGcyNGdxRDZCZlNTRTlaVTU5N3k4RlRQNFNzNm1o?=
 =?utf-8?B?T1RGR011RVJxelMzWEFLdk9najVXQUc5Y0h3NE5LNXBtNXBadmUvaWJzOGNl?=
 =?utf-8?B?aVlKd3ZiVjdUM3gxTmVBYjVkRFdqRDVvR0NPWFBTckY3SEZDWUd3eEl1QnFq?=
 =?utf-8?B?cVlkL2ZNcE5oT3BSRUpjVEFLcE85TDE2RFZCUkJaNy95MnRJTzYrVkRzNjNG?=
 =?utf-8?B?LzQ0ZXRlYU9EMGY0SHdCbEJpVVJKZjJTMnVnVWpYS1ZUN3d1N3dSSmRIV1dQ?=
 =?utf-8?B?L3ZkVkJndnJJZW9zVVlwQ2xVM0xDOGs0NzZSWlpxdFF4Sk5YYkp5ZXMxNmVY?=
 =?utf-8?B?VlNjZk9ZSTBTYUxnVEZYL2NXTkFZRFQ5N3ZUenNVQWpYSHh0WHVNMFZ2amp0?=
 =?utf-8?B?MnRvVkFMUlJrcHoyaSsxODNvMm5EUXlHbEw3VzlLSmdFRTVUMXJVcEpDcnNy?=
 =?utf-8?B?RjBudEx3b05JeElkZFR3eTNtL1ZvY0xjOUIxZ3VTSmNhSE1FTzlUNEpNRXNp?=
 =?utf-8?B?WDNVQzRXNGlYQzdvanZybGlONm1QZlhKbjBRbjJwLzRoSWJVYkxjaWV4SXNp?=
 =?utf-8?B?Y0R3dDlTTzNhL2kyRFZwYTc0MVhYVGRmaEljWkorV0NIN3c0M0ExYVJkTFA3?=
 =?utf-8?B?MXBxQi8zU3FKL0ZIc3ZlL2hsTmNSME1Ebm1YSHV5SFUxWEN5K05zUnBiaEdx?=
 =?utf-8?B?SERvb0g2a1Jmc0RwUGdINGhOOCtpaTl2OHlEL3UzcTNhaWE3WVdJMHRkczNP?=
 =?utf-8?B?VlloZWkxRnNPbzJjUXJ6WVJLYVRXUXl2QzZBVmtKdWREK1NSa1NabWJ6eThV?=
 =?utf-8?B?eEV2NU4xN2wzOEE4d3BPNFU3NCtpeEpybE1qblQ3TGdpeUQzeXVsMWdjeDFP?=
 =?utf-8?B?OWoybFg5Tk5kcWZSU0thaFU5OEc4OEt2UnhuNlNCczNCQ1htRUIwWVVHMmVw?=
 =?utf-8?B?QVJtVnl0L0w2ZUdDb2ZnaFZPRXpWSnFCamJXcjB0OFE1NUlUMzFldndXQlBN?=
 =?utf-8?B?cjRCSjBLNS9xVUZqVGR4MnluUlpsVm5DSzVxaDh4eEZCWCs3b01XaGxwZDZZ?=
 =?utf-8?B?bWNTMEs0eGp1eUZUZEFieWpvZ3MxemsvVkpOSlVXc3gvRnJxMmZrWU12Rjlo?=
 =?utf-8?B?dGVncGNoaTdVUGNmNWc5YWY0d2RoZHZQa3lHWlNOYlplMmMzRFk0VktFSkha?=
 =?utf-8?B?OTU2bmt0UUxxMEJFa0hwZ21vYTFheWtBek1Ib0VTUmVocmhVWHZ1Y0pvektT?=
 =?utf-8?B?V092VndNQXNMbHRzQ3BOLzhRTkNLVkM3OUNkVW80b05aSExVQUJqaDJCbkhv?=
 =?utf-8?B?OGYwRmlKeHozVTBhRGIxczgzTm5rS051Z2lCT0tPdzlpdC92L0lYRFBnZld2?=
 =?utf-8?B?M3V2ZDlqaVRUUTRIRU1jUlM4K015NFVJWlpzcS9Fc0k5MGRXblNZeVNENkVi?=
 =?utf-8?B?ZWhhYnBNNWhITVp0SlpxaUVXYTQzMHpxQXVoQkVicE9qNUJHVk1WVnBFMGhW?=
 =?utf-8?B?UkRGTVoxbnNIRUxDSS9kRk5RdEZnQzJzS2txUVBURXo5K2ZRcWkzbUdtM3NO?=
 =?utf-8?B?M1lUTno5L09jSjJkYmM3RDZ1LzgzaXFiRnl4cXIwbUdINi9TSUxGeVUxMnkv?=
 =?utf-8?B?dGtTRnNOSTl0clNyY2doQlFVeUlBclp6cXlxWVBZZHVQcWdpMEpJdGZYOUJn?=
 =?utf-8?Q?+GQVH14cONx3L7pZODRYgzc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VaTfRRXvla6Zzktu6br7FbfgKygiTfra2lyT5QV7T6HcizFXy77NMtzP3awrMDmJhmAXp75gPhqLs+PUrkk3qgoaNYrwP/xsLAjbmndLptNO5POf374fbMt6Go3gIGZn0yBVxtyDp5iDK/pbG+2yJah/a/HU3DVU2y+FmkhOe2JnHtxcntTBfbdC6fV6UJWoNnY3VHlNT5kLT80bI7VVGmPahwtc58SfUXxTb8usSYuNoP6WlWiuHnKiCxcA04riJ4db0ALOW1kEsAj1SPJYZksxsPK5t8Ujs2/TmysVpnDgrYrsXn5uvr2TTBaZmuBpnkFIEL7TkEEtxCMRpt3FrCJTYAVT7yAYtwhY+t3mFw2NshEFey8nXXdkxV8AiC0mrA+uoPLpzVBjVaKWscTKdIYZpUfTgjOEqOWT6FtN4wENersf8ucBufy4NwFch7djz0HlyCfIak77t9RzcU+0DIb+WdBWZcLR/8Pabq7/R38P96Enbm0llCgP9Si3JIC7JpmEH12+ZKYw05VBgUA2larkiwJktaiN+4veP8//EvpuwDvUdDen5p3AC498ZBb4yz2WwqIDCsMNw4zjLerD3lKjagR9jw9DOPVDFI8dyz4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c115b4a4-56c2-4148-0dee-08ddaefd30be
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3828.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 06:47:43.0017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ctSmJ0uY1g7e8HGjWpwEaZIPa7TcgRZRxQNwvv2WcAKon3EAeOulEh6m2zrS4e+xpU9NLO8Pj1caNTqYDWHokYzl98KbHfotyoiRvAH2t90IpftPU5NA/WXseZoc3ZUO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7700
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-19_02,2025-06-18_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506190055
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE5MDA1NSBTYWx0ZWRfX/4uYCKjEZwrQ rf47uGlgh78r8wkypYQstypIC5/7XLOCnwZDKkq1SmOrTS+McIJ/+iU/ooE1C2vsQwmz2b/4/MM e0kYXwvfHAvz8EaUaJle2WdIc8Cjf/CQBCQcGB+u6fZkgzSAa77BBuGjUliN5wAAI050J7cAFD4
 AxDp6xnzDM+3lGN4aXu1Sk+NYhWvKo/QKXtzU5wW/l8Mz+x9T4cG0MTwDVgCyDLX4AS3ecxtVyo etK+fUGUBzcvzJbHCeYsceBC1BFlWVEqSd35SMKf+eCPOcH47E7xNe6Wip1WNkOjdp2kYI+1oky kYIveWPVvTmcVsnD6FxoRKDg+zFYLDOI8N0lzkkpaH62xQ/oJzGDAlrPJVoM67cV7s8j8E97LZr
 L7wz094vrzUyw550CRKVgIXrDManvJ/V5iSiblTa6+4QGcxTXViTuIv6XcrD7WwV69/7ZPkF
X-Authority-Analysis: v=2.4 cv=DM2P4zNb c=1 sm=1 tr=0 ts=6853b293 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=9V_ThoJpMYiMRsW8ZnoA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13207
X-Proofpoint-GUID: VgttnoXSupjYE5R3QJrItT8U1nam7k_h
X-Proofpoint-ORIG-GUID: VgttnoXSupjYE5R3QJrItT8U1nam7k_h

Hi Greg,


On 17/06/25 20:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.34 release.
> There are 512 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jun 2025 15:22:45 +0000.
> Anything received after that time might be too late.

No problems seen on x86_64 and aarch64 with our testing.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

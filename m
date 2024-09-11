Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1363183CBF;
	Wed, 11 Sep 2024 09:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726047416; cv=fail; b=Bb0Y5Gdqy2FIK6m3+50AjmGGxjFCFKdlNNfX35p5q7+92M7J/ZIpJsFN5GueO++LshJ9xxKC3gICDTCbukjxHhUNbu+Dj3DNA8/942ygAkT/IgW0usK3iC66gIQjwHtdAi95d6cdjoJVBTcZ+b5gi/8UIecT9OKvnXjBFwSySrE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726047416; c=relaxed/simple;
	bh=YFEcqoj0brlzNva/I38zQxFRLC0AiDyrd1nhqnT7AGc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RQyG5yOZgfM3ZZGF/zwjOILfRdXVLuYy8+WMArSKURsjjM+zvT2YzzjyZucL1nHwAoWmdaMETRvjQgKrw3pzoFwn6bUjJZDo/LYwr3pJCDs6En0E/vyKUQZ2CvDqgO+WCXiQfHT3tKBvpW5qA/7PPfexOoyI6J3+hdC2tn4ASmU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=X2wVY7OT; arc=fail smtp.client-ip=40.107.223.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="X2wVY7OT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=goQU/eSdjzMAZPzGBd8iRvVh5cOZONo1U8SkJJGbzDogzP6RR2/MCxu2pnbOh3eafOy7okOM6rPzA8XS5It33uIwZBZ/pvFruQ78FqhbwnPDxRx4fB6PzF+tiiySEWJOFlyrKrb+JWEcnZIBUD1qwHhkeYB3MKj52Ug8gUn98BnQzxIA/J07HxYPJhDvqaTCCGkVDD+ZInuLC0HWC3a1srAnXvIKuFu62aeWNoo6v5GCrCBrt9HneOZ7wsxi2e+IAOOr8sL6fpaBDCvtsKrsGRt14Mxjlfw5m1jjI2X1jLeeVL8Q4gbcjQB1pfPOzWqnVn9uJAW9/9o81r8UD2BW/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EmjEgUyJdJXz1gF6VR/ACYqabtPY9smKnsVC30eo9DY=;
 b=GHht+Nasd5Hhh9OfnC451Fuc3RvWK2bXn7NHzucWS89bYNJdeRG7ZN+ItR1kFu5vdW+GyOO+plEmFXq5kQQXLZSJ39unMDGIFrSC+vMm+glkzFAissEG0IoMdz+dOqB7R7SreUkTY6beEOowQVQW14dyZGRBGE0xsYgqD2fdmFQtn5jr9USqu0vEAsq04JIpSOo/rKN2suxJrbdqFTjK9gJEUWkOwIRCwa31yQXYdTOiklCcq8uqW9ReRZ69cDR7Owy9vBna9aql4Zbvl+Vci4ONSdRb5BB+VXFudoir2VbrSrZZuQGuoiIEAgzCjXz1waK12Mb09fuQTDMPnUdNoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EmjEgUyJdJXz1gF6VR/ACYqabtPY9smKnsVC30eo9DY=;
 b=X2wVY7OTyJdNdB+utZJnbexoQyzmbaqrN6vJiefxvoAU0Nfb4f+4jYxDVUHez3T5pV7boKv4jdMW2zWpB2zjLCfNkHHWlrVXRRCRC58pNW1pLpWNhXDVly/5hyxAoLpWzDBuuKe2aX3mxYtymyg53Qqr7mOpgkRrKALvrc8WqTw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 LV8PR12MB9110.namprd12.prod.outlook.com (2603:10b6:408:18b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Wed, 11 Sep
 2024 09:36:52 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.7962.016; Wed, 11 Sep 2024
 09:36:52 +0000
Message-ID: <f1313605-694e-454f-8d08-e5baa6f52179@amd.com>
Date: Wed, 11 Sep 2024 15:06:44 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu/amd: Test for PAGING domains before freeing a
 domain
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Joerg Roedel <jroedel@suse.de>, patches@lists.linux.dev
References: <0-v1-ad9884ee5f5b+da-amd_iopgtbl_fix_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <0-v1-ad9884ee5f5b+da-amd_iopgtbl_fix_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0156.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:c8::9) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|LV8PR12MB9110:EE_
X-MS-Office365-Filtering-Correlation-Id: 202d8610-d96e-41df-3277-08dcd245444f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ek5NazIzNGc0bmE4SmNvRHBkazJvSkFFNDNzZmtVME0yNnVrcDk1UlVDUVRW?=
 =?utf-8?B?cHQzQ29paHQwclR1N3BaSTZtSkk4MWI3OUxDbkZhSFJtQWlZWVJObTk2a0RB?=
 =?utf-8?B?NUVnZVBqRnJDQkR1QnNLTVNlaDdPU3o0WE1vc0xBaHpsYlVXaEZhWko5SnZn?=
 =?utf-8?B?emhZVTNSdXlVVm9LeEJKL0ZxY3IraHMvaEk5UlhNdFVBcnhiekJZR2wrek9l?=
 =?utf-8?B?NXluclordW1CY3BzQUp6TGxQZW9VcEFianRsb3hFUnI4V0VuQUFYWkl5YjlY?=
 =?utf-8?B?RHh2ZjlWbk9XQ0h3L295VjlLbEhwcG9JV3NYZE8rMitDT05OVkhvNFVRSmZ1?=
 =?utf-8?B?TWVpYUxRRE9qZDZ6STZyTFhVVlRyMWsxWG94cCs2Mlp0dER1eTFpY3puMmFQ?=
 =?utf-8?B?cjNlTGxkL3h4U0p5Qk5VbVBtWnljdjRPam9HQ1ZuUk91OC9xL3JZb1pDZWpy?=
 =?utf-8?B?YUhJdVlaMUFTQzE2NHdJckg1WGpNbm9jSStURU42N00xZUR6UElBQ2wrVHpn?=
 =?utf-8?B?amNhL3lTaTdaQkFNZWJFOEdMUjZQbVZDeU15SmVGeU1VRm1OV05lMlRwV3JJ?=
 =?utf-8?B?VCtpZmVSTEFLTUZPbm1VMDRSbUNCbHZxZnFVMEx6SmtTeHN4UkFKZ3lVTmZE?=
 =?utf-8?B?eTNkL0g1RDh0S01wYTBiVEJjVWJLOXRZcWJxL0ZkclFoYkR0WmhQZ2JKeVox?=
 =?utf-8?B?UkJFNDBzeS9TZ1FZcDk5OTl3N2I5OHZFbG1kTmkzWHhPRC9kbTFKRGZiZURX?=
 =?utf-8?B?TVhzQmkzRXpFVkF6d1MwRUhEaXRPUTFhVlFSUGQ5b285cXBVbUpSTDY0ekE0?=
 =?utf-8?B?OVB6YUMzZzF1elR6NHREUUcyUnp1UzdLeFQwWG9hTzFlQ0s5b2RwREdSb2tM?=
 =?utf-8?B?UGNhSysxd1pBYTZNVzhjUTE0SE5sNDBLZlJDTHFaYUF1WDcvY0JxNzBYbVl6?=
 =?utf-8?B?blhNSXl2WkdNM0VTYTZIcjZJUDBGZld4T2c4Wm1kS1dybkcwS2lsSWtncWJF?=
 =?utf-8?B?aEt5YVc4VDhDekhPSHNWYzhMWjFkWUpieEhBdCt0elRDRHhVc2ErTEU0ZC9E?=
 =?utf-8?B?UGtZeUVRMVA1d0xmNG13N0ppYi9xQ1lsMDN6WjlUWDk4aXFPREdqRkFoaHZ0?=
 =?utf-8?B?emdGMVl1OUlzVnVRWi8rcFBkSTR2K2JKeWtHbGxMY0g2c2xKaXNESGJEOW1C?=
 =?utf-8?B?TlNJMFhRSnh4VnArR0g1cE1qOFIyWDc5L01zcGVxTFpacW1ubFB2RlI5bHNU?=
 =?utf-8?B?aHZvR1BHRjEvS1lBaS92eUhFZEJ5SVU0dEJTSk9CTkFqL1grdHBuUHJMWFdh?=
 =?utf-8?B?TktoaWhVUUtGOTc0V1NqYlNEenZVMFV0bW8yazZaeEQ4VFZPTHZWVm5OMWMr?=
 =?utf-8?B?aFFKY1o0NFhLUE1QOTlSOUh4dUk2ZTZSQkpCVEVwT205dlpDcWFYaVlwdkZk?=
 =?utf-8?B?WGVxV3lQSU9rQ3Vud3JpLzFMTTNQSmhnR0x2UTNRelpDWnNTenpEVU0wdURq?=
 =?utf-8?B?S2lMcE5SeHhJUm5Cd2NpMk5xMWtGa0NGWXNYc3lCeHhNcmttSTBsNDVYbmxn?=
 =?utf-8?B?S05HSEs1MVNqanJNeW9CRm1Tb0FZZVZTSGJnKzc5bUs4NkdIUVBjTzBza3cx?=
 =?utf-8?B?bDhFN3lsZ2RTeEJhd3ZxY1R5THoxd1lnMGw2dndaY2xIMXlLbFhQanBvakx5?=
 =?utf-8?B?MnA5Q1F4M2R2dDg0bGF4TzFEK2ZFY3hvbGh0aURkRHRtVllLVzdrdFNPZUZh?=
 =?utf-8?B?cDArRlFXaS9LU3ZsMTlzOW5zYit6VzBkMDhXUUlJQUUyN2xkYk83RmJLdG94?=
 =?utf-8?B?dzBlU1dmR2R6a0Z3K2Iwdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?emR3M0NhSng2Z2dUOE83Sys1bS9jeW5UTkVkOWkwc25ZaFpaWGlDN0Y5WDBP?=
 =?utf-8?B?cGYyNHRrbHdRTFdzRWNvU2FsVitoMEprT3pRSm8xa294SDk0WW5tbXBpUHpG?=
 =?utf-8?B?T1NhT2Y3QWFDbWNrS0RYZFpSNkRxKy9nVUZSNWRBYlgvYzQ2b1pqQmo4b3Iw?=
 =?utf-8?B?SE9CbzJ2eWpMZlZCRldrM0xlOFNQWVNJNDhYbjNic1ZIZW9qQ0lqSk9pOE5i?=
 =?utf-8?B?ME0zL3RlUVBOYnVYUjZXbnJ4ZkN2YytJUnFBcmRHTkxnSVhsRWljYkYzcmRV?=
 =?utf-8?B?Rk4zWUdKdHZ0Q2Z6aC9rZlVLQkNlc2pNUFNzVkZybXZxUnM0cjVPS3R6cSta?=
 =?utf-8?B?Z2N4SGFrRjlLdDBPVituUmVIcmhma3c5L3I1MzdZTzdXVEdOMGZ2SlE2MklI?=
 =?utf-8?B?cXdvdWQvbXByQ2U4MkttcFMxZjdseDQvODAwZzNmTGdiVy8xR0pxWGw5UEdL?=
 =?utf-8?B?ZVE3NXRwekNoYW5oc0RwMTM3a3QrR1UyTFBlcUZlNVRuKzZkM3hjZ084S0JN?=
 =?utf-8?B?K2pQK3RsRkdndmJOaWhFOURoQWhiWkQ0NGcxaVhad0l0YW5IVHdUY0ZPK0pL?=
 =?utf-8?B?MDVEbXNVd3pJdWllWkNhbWZ1aDZpaFJsZzNFTHp6SmZUcC93Q3cxb0w5Z2JQ?=
 =?utf-8?B?ajFvLzB6Mkd0dGFQcUt4NERQeW5IWU9Ya3R6SFhEVk5CSERBNW5zUzZ2MDdG?=
 =?utf-8?B?L2NHNWI2TytEeXkxcmpML0FlNndGa3dsVTVDZ09SME5nL2xpbFkwaXJTZ3Ru?=
 =?utf-8?B?bUVnVm9pMkMreTZoeE83Nnhtb3prbUpWc05BRGorTmU1Qjl3ZWhRbDVLVDZa?=
 =?utf-8?B?d0xvMkVHYVltNnF3SUVPOGpYMlo1b1FpY0VZL01yMlV6Y2xkVHhxQnd2WFoy?=
 =?utf-8?B?VExtS29jajd6bThNc0JKams3SFg2UHpBRnNEMkl1c1lsOGVTSURUdmtQbUd3?=
 =?utf-8?B?cUR1bENBdGZBcXFsVm44L1RkSE1pSEt5cWFKR0xKcTJNc0QzeHNqc0hyS3d6?=
 =?utf-8?B?ZzBGVEErZmlJb28wRFFKbzZwc2ZiTlh0TTREZFN4WVFUaFlQL29xZVQvUi9L?=
 =?utf-8?B?VXEycW5uL1ZLV2ppSVNjNHBNaVlkOCtsZjhraVFFV0pDdXluK21nb3ZEYjN5?=
 =?utf-8?B?emZmSzlUSVhLR2dIYVdCeGJQWVpIOVo4SVBEUmw4aTVnN2ZuT1lBYzhrRmY3?=
 =?utf-8?B?YmZadko0ZitCSHdIMEl1aVZUbFJSZzJpU0ZyOHVkQmExWWd2QUpNZ3cxM0xC?=
 =?utf-8?B?L3pFR0Yzd1hZSm1UNU5KNXh1RmNTYkUwN3BFamp4UEJwNWE3VjlJRTlBR1Rz?=
 =?utf-8?B?RUptb2YzdGNpOUpacU9LeVM3a1RkT2thU1hMc0VNU3h3MGcxOFVndGU2d2Zo?=
 =?utf-8?B?QitqWlVRRzN0VnF0aUkyZXVRcnJmZWhhb1ZqUTkyblJmRHZlZFArOWF4Qmps?=
 =?utf-8?B?SHNmYVE4STFaVTh6NGxEYlRSWVdKaHJlZGlkeHl1OEdLb00xZXk5QUV0MHcw?=
 =?utf-8?B?VUhxQUs1MDBpbm1lR28zbVdzamhBTTArUjlCek1UWk4vOGhISkp0L21STlZ4?=
 =?utf-8?B?WGlBZFFmTmJoRWZFbHgrdWlDU0tuYzNMb2ZPUzdOakh3UjRRRkNVZmRWWG5P?=
 =?utf-8?B?cFVPaWs3cW1pdmtNdUVhdnVaQTRDUXhGMWdDdnpTSXE2QUNZVWxCVXBobDZC?=
 =?utf-8?B?Qm9wY0pVMXlhMitDdjlVZzNpalhiSjFQbGp3VTA5NWVZdkZTL1lDemdEaEJK?=
 =?utf-8?B?N3lQSXZNL3VqSUFnRUYxRVJibDgycy9oSjJOSWRVb01jOGxKamNTNWl0TEdF?=
 =?utf-8?B?V1pMVGkvVVlSZjdYZnduLzVEaGhqVHFuUHFGVTRPeGc2U1hVUGh4czNHRXMr?=
 =?utf-8?B?UjRvczN0d1JJcHJLRStrRUhhUlRMSEFYNDFlVFBGTElyc3d4THp6eHVWVlNQ?=
 =?utf-8?B?c3k5RTRBUnpxRnpvdjArRTg5Z096emRwNm54Z1JKU3RvR2ZQMVU2czUzTThX?=
 =?utf-8?B?OHBndE1jZCszRy9WTUoxUW1xY2syZFJMS3pIdFcxcmpzQmtqaHhINTNpb0po?=
 =?utf-8?B?aURtcW5tS0M3ZWRqNVQyWGhxMTVTZHZSZlQyQ2JsRjlLSVl3UkpIdXVpb1FP?=
 =?utf-8?Q?5kOP4tyOXbwwxh7FX1JIFhgBl?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 202d8610-d96e-41df-3277-08dcd245444f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2024 09:36:52.3679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bcVGqlhLHfH/Fv/L+d45t6xlrYycHuUq3xDeABbhn3fKG34zPDF5AJkzCMH1H3drpsbcospPG/i4+KhBy3Mlig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9110



On 9/11/2024 1:30 AM, Jason Gunthorpe wrote:
> This domain free function can be called for IDENTITY and SVA domains too,
> and they don't have page tables. For now protect against this by checking
> the type. Eventually the different types should have their own free
> functions.
> 
> Fixes: 485534bfccb2 ("iommu/amd: Remove conditions from domain free paths")
> Reported-by: Vasant Hegde <vasant.hegde@amd.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>


Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant

> ---
>  drivers/iommu/amd/iommu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Joerg please pick or squash for this cycle, thanks
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 2d0a681a205211..154f90e7b98e1d 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -2257,7 +2257,8 @@ static void cleanup_domain(struct protection_domain *domain)
>  void protection_domain_free(struct protection_domain *domain)
>  {
>  	WARN_ON(!list_empty(&domain->dev_list));
> -	free_io_pgtable_ops(&domain->iop.pgtbl.ops);
> +	if (domain->domain.type & __IOMMU_DOMAIN_PAGING)
> +		free_io_pgtable_ops(&domain->iop.pgtbl.ops);
>  	domain_id_free(domain->id);
>  	kfree(domain);
>  }
> 
> base-commit: 22c91287502b4bfc2899a1006709eec8273cf052

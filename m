Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCCB21B9C1
	for <patches@lists.linux.dev>; Fri, 28 Mar 2025 14:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743171992; cv=fail; b=aJUn6nIg/VDeQBTG+qOnJbSooMHvXK3VNcHiuYdHmy1jrhPR9yXT1HTsK0fq3R+83c3xa1M7nggXtP3dG6Jms0R7dCMhreR4w03/CNLWBQpuX0dwXntwHhWTyPa2dOn7dCiQzEMEvrcOEhfudx47mdA0TVdwRq2R7WiYzjUtMqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743171992; c=relaxed/simple;
	bh=22NWf3IcbxUEJ5R5CRc8mA5bykZJsqzjrduoPNVpBwQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jFzQqm5RHNTJcEjFhv134rgZuXVf/tukkYpQwUyvYQHlP+aPxMyDZk/zWiKzlyedjfPX4x6bwlMm8WAjfjzQH3iW8/3Lw7Tg3H5YinUjLokT6jaNxEs4Z3oOl+Rj2mdxjkkjYDT7w2TVP6g7nbXpODbx1Fpb+moTcPlY0AR3MXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ua3r8LEV; arc=fail smtp.client-ip=40.107.223.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ua3r8LEV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OLqy9xykNrYxvXlkxnPilgdShZjwnul2y4FjLyyZ7b4UGHs0/t/5TiUnyjIgqUeKyCnyykadPXgfTlarNsk93f5LYfLFDHA7wIVXXakiwLwaZA3C/ZHKtTk3AT+dCNO+2ea5nmTFEMpAIispSUIP4G5K/1e/QYqa00JK4DlqwQLKiEnS5dckv7iVts9FyKfm34dGeQ8T3YyiGT1NLLl1FsaQs2LtPdqW/1wspG3CEQzCPRuaIooVsB9a5iqp51P4kmEhsMgz9XzX9Dy4jC/WHKKWVLUArflWUTCtET9iefiOjfGNrwbDssjp1X4gzCAzqvkS3wFySvXSqlbV/MMuTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2zxgAXFpjfiPuyzUQfxCdz8CXsNBytUQC6Tiv7YvDtg=;
 b=wBUVYugbTl2uwqaTyA5TLrPz4YYJ87AaHlXy+FV6fBRp0cYvd7uJhNo+t7rE9albNOznWTvLTAPsLISrswYBphp62SP5i1Z5c35oWoNgbxVOjgDCkuOAkTeeS7fv8rdzS5XUnTXVXB4s7YdgE4Jy5S/c8vV7gOhZAZ3HgC0+nYTKUxMedqADVT/X10Y6unzb9OODZGjy9sQCK0VTbheLJ/+SAkZnVMe/ENA6WvBtoXmKSeaNbcX9PnROVrxqFMPDBHspGL+MKv3xym/aKmytYM0iRWiyJ9kbB6u3KphKI3yWQkeOj50++rIEp+VPU5H+QQWfbzXmHMNLB0X4TyhdYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zxgAXFpjfiPuyzUQfxCdz8CXsNBytUQC6Tiv7YvDtg=;
 b=Ua3r8LEVF+taI5/7tb/U7OPf0uJx/92Dcmgb/lQJP66u8UFo+JZJBuCC3l8F1xQtfCKnf9Z2idhfGGARMDpJD4WHq9wBVIYSA9GvxptrhyhIzUUJvlfxXsv4cAcMSr/B7UENnGiebymGn1XTmLM8iEsnVgCkpM2VFVDEgrGG+rBI5OICCmqMg777R437twLZ/Kqox4ciUoYUJi5Xlqge/8zmf/S8UL31XS4dkh63HeGBhgjRi6IRMBPyal1nH57UY3QYs8AOw6RfyBRJaMYanaoCYZEtOk/5IrzfE2KM1UJ54AFxM/SunLO0V59CxgTjKWVW7twUdMXJlZ+xQzj2aw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by SA1PR12MB6969.namprd12.prod.outlook.com (2603:10b6:806:24c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Fri, 28 Mar
 2025 14:26:27 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%6]) with mapi id 15.20.8534.043; Fri, 28 Mar 2025
 14:26:26 +0000
Message-ID: <ec98dab7-1445-4b90-a48d-29b22fed6010@nvidia.com>
Date: Fri, 28 Mar 2025 14:26:19 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/76] 6.6.85-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250326154346.820929475@linuxfoundation.org>
 <2ee0a8e7-8945-48e2-9c11-28710708f029@drhqmail202.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <2ee0a8e7-8945-48e2-9c11-28710708f029@drhqmail202.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0073.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::6) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|SA1PR12MB6969:EE_
X-MS-Office365-Filtering-Correlation-Id: f2e5fea3-b07d-45b0-5034-08dd6e048613
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dzdBRjIySm9OMktGai9YSXpaUkJnNUpxMUpHWlNwaE9kanFIZ1lCZGRZbkls?=
 =?utf-8?B?MEdJS3JXRlBGMzd1S0dHQlVyVTlseUZaRnZlUURoZU9mbzU2cm51UDRUTzJG?=
 =?utf-8?B?R2poREpNc2wwYkxBbGRyQy83UWMwOVlBSEpEVHpNUTJTQko3RWwzclg3V2Y1?=
 =?utf-8?B?U2NZK3RnaExHL0tiU0tNcmx3SWtiUmUwQTZjQnA1ZW9wN3NRbnBZVVlzM3JF?=
 =?utf-8?B?YjlzcGNUVStlMGxpNEptcXpCR25DNTYwcTZuQ0VVcG9lQURUbkJKeG00TDBM?=
 =?utf-8?B?WXlsL3pjcjgwOGxaNnpxOEZ6U0R1TUhJUzZtbTlJcUtCZ2UwRFBTMS9tREwx?=
 =?utf-8?B?dU1Ja3VEM1ZjejBTQTBGdUtDTExoOWdwTHkwY29lL2pmSlZQeVRQQ0wwNFVl?=
 =?utf-8?B?M0J5QUU2d1dCQkV3aEVHdG9QU3RpOVY0bXNZbWpxSlNWMjQwZ2F2SWsyemJo?=
 =?utf-8?B?cG5nbWFRcHhJMDBSbnJteGpiY0J6YkZ2bEF5VTRjRzdMSExyR0cvS09CQUc3?=
 =?utf-8?B?TXlMRVAzU1pIY01NVy96OW82N3ZVSWpKNXJlMCtSS1NjOWEzcUU3MTFDMmlR?=
 =?utf-8?B?bjBWVTF6dkpQRjBSRzFNS1QzYmNMcHJhWjhDQ2hmdXphcFhBZ3RNb1J2UXBW?=
 =?utf-8?B?bEpBOHdnS2gwVUJxOVpCQm4vVnY2UEFaOGh1dzFXUmwwbjdOUzBTdVp2dms0?=
 =?utf-8?B?V2d0RGcyUTR5RjZyZEpybitKbWIzWTU3ZTZVSHVwaUxTc21QREJHMEFmL1l0?=
 =?utf-8?B?YVM4M0d1TlZaandBWUl2TTBsSXJJa1UxdnU3RXNtcStIZ0J2bytWVEg1NEJ5?=
 =?utf-8?B?cFk1Ri9JWXQvRmhQNndVK01DcHVMVzlGVzBubUJOK3NKWmRaeHp2Sm1VRit4?=
 =?utf-8?B?NXUwell5Ymw2aUN6emoxT1J0bFdkNXFpeDZzYStXajRyY2NVcElKbTFvTkwv?=
 =?utf-8?B?dkxGa2s4SnpNY0ZRRWViQUtta054YkRZYkFYaDlyOGhQS3ZpbG4zQ1JYOHpm?=
 =?utf-8?B?MWRsODdRQkgxK0cvR1dqYVpFeFIvUmxtOHlJMzU0MmJ6V3FBQktObnQwZFdR?=
 =?utf-8?B?elJEWW1WUTFySld0RnQ4Y2YxZnRTREJsb0diVkRId2lMTGs4OGYvYjRzWkdw?=
 =?utf-8?B?aFFhazdYZkZ1eWRlcVhmOTZITW03Y2g5ODUyU3lPS3V1b0hKT2RNd016SFBZ?=
 =?utf-8?B?WEdEOUVmTkM3MFdwSk1XWFRxN0dYTHViT292a3FEUnZDZEpLR1lXN3VGK0s5?=
 =?utf-8?B?Z1JFeXVhVFNtaDlWNTZNZG1zWXcwTW9kWWQvbm1CQjZwT2FXRDk4RVNxWXZ4?=
 =?utf-8?B?Wmpabk15T2dWMVZFa0RHR0RGcW5pSTN2SkQyRlN3V3U0ZndIWGcrT3ptY2g1?=
 =?utf-8?B?bnBGbXBsbmNzcWcvYjZwaUU2ZDQzNnNCSm1XVlAvQ2N3L1lZdmJwVXZsVjNq?=
 =?utf-8?B?VS9WRkNDbnp6WmZ6ZmZTVE5lb1N5Y2IxRnR0VFF6ZFQzTTQwWkJSeTZPdVlT?=
 =?utf-8?B?djBPVEFwMTJ3bitKRVh0THI3Q0tFalVBZ1MwcUM1RENsUm0vSHozTENFR2pM?=
 =?utf-8?B?bGZCSGFiM1QxSStjVktGNWp0LzJWc2ZVeStlZlRXOVA5cVlqVWl6NHNMd1FU?=
 =?utf-8?B?eHV0V0l4TkV4Q1FFbUNidk9YUWVSc3NMWUhGRXZ5VTdDMTdYSmQvVy9ETFRj?=
 =?utf-8?B?dlZSZ05uSDhVSFBadE9hT0lQSWF0L1NERHdqZ2l4RlNVbTk0eU9wMmtMVEhs?=
 =?utf-8?B?M0JONHZocTA4MTdtMlcyeDNJRFhzVFVpQ3p4NXc5VlJ6dHVraG1KNEdRY0ZT?=
 =?utf-8?B?MHNpbTJnOWkyUEM4UzZQbUFBZ21idW8zaG42SmxEYndjRlZ6Nzh6Uml2Q01q?=
 =?utf-8?Q?Ug4u2++Url41I?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NlhUVGZGcXRRRFhJREhyWFpodDdZSHBhZHJwQ3Y1VUw1NW0vVTNFTnFpeUUr?=
 =?utf-8?B?UEcxVy82QnBGY0FSeW9ETHp0aTh4Q0NuMVMyMEE3c3paaUVEYjJ0R1F0TTBr?=
 =?utf-8?B?U1BNem1Sbi9rYzFuek45UHk4bXQ3UHBwOEtoclF2R1Y2d3Fidnl6OGFRSWtl?=
 =?utf-8?B?dFNteGFDYWRQVUZRSEZYTjBzVmdOVm1nQVR6K0pVVmRwQTlueU5HbWwvRkNW?=
 =?utf-8?B?MHpaczN3UituclQ2VDNPRVRnVVRsT054aGcvV3E2MUlucU16MzU3bENPWjFn?=
 =?utf-8?B?R1QwVEM0QWhyRFY0SFlMSDVEN1RXUGJtbU1meFAwMVgwSW05eExyU1V4VTl2?=
 =?utf-8?B?dXRQQlFSZkFIMzAvb080Qk16WllnaThIajFWaU4rclFKUnNwNnR6QUxGdy9w?=
 =?utf-8?B?WENBT2puQTBuUEdBOG9WWEFQNjhJUFpFY096MjdZUnVvSlN0dTVmb1gzM0JK?=
 =?utf-8?B?TnFGcUpxbE9lUlFnRU9hTU5LYTlZQzVDcy9zY3hBTkhkeXZiOUp4eTl0c3V0?=
 =?utf-8?B?Zkc0djZ4U012VU9PU3hsYlYxKzFkSGkzS3FuVHNXTmhScDNWVElmdzNzVGp5?=
 =?utf-8?B?K0RTTWE2aERWRnYzb0NsYWI2UDRKcUJreGlHS1VJdVE3eU5wSGJzUVI2QXgv?=
 =?utf-8?B?K3kwOGErcG5wMSs1bVM1Rmc5b1dGQXIyRzdkUEc5KzgwaFR6a2FSdHpvRExi?=
 =?utf-8?B?OW5aQ3ZmTjZMY2ZDVzdjSlo5Tmo3V1p2YWErcmhPNkNEb1FLcDBZMFJDeGxk?=
 =?utf-8?B?dlpKdURIQlRqWExldmVzZlZ5R1dxbnNyZ1VObjJTV3BqQ2cvSDExYUdnN0Vi?=
 =?utf-8?B?OU1SZW5BS3UxbXZUL0VLMjVxRlg4clFVbGVPWklIMElRZk9VTUt2cFJOd3Q4?=
 =?utf-8?B?dzJxTHFXS3Q2d1FTNEFjY3VkSUdKMk8vOGVmOWdLUzRCZnlILzNQS1RKQkFY?=
 =?utf-8?B?UUhjUnVvOThpYzRKRkswenZHeXduRW5QRTliRndPWHVXQmRoaFFaM0FJc3JO?=
 =?utf-8?B?b3ZodXhlOURoUUtlZ3R3dXp0SFgwd1dPLzd5dkp4dmU2TUZ5Z3FyZ1hhQy83?=
 =?utf-8?B?U1lnYzJGcW5JRkt5bHl2bEhlZ1JWdHpBbjNDTjJTdlhVT05iODJpT3VBQlZi?=
 =?utf-8?B?bHR4MDhSK1A0TWRjdEtDTWt3SW9PL1ZZYVduU0NtSFZFR0I4eGtZV29CVUxF?=
 =?utf-8?B?NW9qNmxucFZQQXFMbklOWk5rVHBtN0NkQ3BXUHRWOXhTK0h2WnFDamhYQzd0?=
 =?utf-8?B?R2ZLdWNwN0FkbmJNNFpZQ0xoUW8zS1BrTTBjSXFOcTdUM2hsbldobHNrOThv?=
 =?utf-8?B?R1ExN3plUlg1UlJHbEhacm1lbmhvYVZXM3VLaWluSHd1bUEyZVNSK3dhZ1Y0?=
 =?utf-8?B?dGNiREVzeldQS29aK2VuZHhGZDdLQkhxdUtQL015SGxSbURPL1YzcndkbVhZ?=
 =?utf-8?B?UWlGZ0ZGa2JUUjZHaDM4aVpCQ3BTMEJIVHJKb1hsVURWaWpyV1FEMllxa0NN?=
 =?utf-8?B?SWozTjBYbDZWbzZJY1ZwOEY1YjRXNXV4cjFYMEdpVFQxTElOVkttNUJsY1Rw?=
 =?utf-8?B?cVJQTnVyY2w3dS9FSEFXc1pWSXR4RUlvOHVYRjRWSFFYTTk4NlI3aUpsUG5S?=
 =?utf-8?B?NW9lVExucnhtYW1MZE1PcEFxY3BBNFRZZkZ3SmJOVFVsQ08rNzNlVGVDTU1I?=
 =?utf-8?B?VzMwZEt3YUl2d2p5QTNydjB0bGlkdHNkem5ZT1F3YW9sZjB0Sm1IOXpSTTho?=
 =?utf-8?B?ZjRwRGJyeWpqeG52aVRQRk9uL3NGaVVyc3Z6aGEreFBNZm1MNlNDbnhJMXlT?=
 =?utf-8?B?RXFPOUM2K1M0b2dXbFJuWE9lQmJrZVg3TWp4RDJvOTNPbkFYQm1LL1kyNHdU?=
 =?utf-8?B?RlhVckV1aG5VNmRJYkRCK21LRUkyM2RoaGlyTTA4M3FsUzBBMDBLZFJzNXAw?=
 =?utf-8?B?Qzllb0x5MlpwYXVheUlZbnRkZ3hHMVlScWRJZ2tQZHkzWG5nQ1MreUM0TlNz?=
 =?utf-8?B?d2dvMk5idVBsdVpZTzQ0Z0dzN1VGR211a296Zzh6TjVYQVROTCt4NE53SzRi?=
 =?utf-8?B?alhPaFR1MUtFREoyVjMrcjY0d0xwTFZteENYMnYyREI1Y1Q1YXdHRlMxWWNm?=
 =?utf-8?B?TCtmcThuU2Y4MjVKNWIxZU5PQWkxQkIyakd5QXIvbU5TRXc1MkF3UTBnNzRG?=
 =?utf-8?Q?jtaixLF3BRnhGF/RqNUqViYye94MdUa+ETFI9IxVwlX+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2e5fea3-b07d-45b0-5034-08dd6e048613
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2025 14:26:26.8011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JSL7gPkwDIXbCsLdP5PYb1V8wZ3/BBT54SZJLM698wX3xXEl4lhyojeQ+gedZg+uFd9b7y2+yDvm/PEs3Zsctg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6969

Hi Greg,

On 27/03/2025 14:32, Jon Hunter wrote:
> On Wed, 26 Mar 2025 11:44:35 -0400, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.6.85 release.
>> There are 76 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 28 Mar 2025 15:43:33 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.85-rc2.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v6.6:
>      10 builds:	10 pass, 0 fail
>      28 boots:	28 pass, 0 fail
>      116 tests:	109 pass, 7 fail
> 
> Linux version:	6.6.85-rc2-g0bf29b955eac
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>                  tegra210-p2371-2180, tegra210-p3450-0000,
>                  tegra30-cardhu-a04
> 
> Test failures:	tegra186-p2771-0000: cpu-hotplug
>                  tegra186-p2771-0000: pm-system-suspend.sh
>                  tegra194-p2972-0000: pm-system-suspend.sh
>                  tegra210-p2371-2180: cpu-hotplug
>                  tegra210-p3450-0000: cpu-hotplug


Just to confirm, this is the same issue seen with 6.1.y.

Jon

-- 
nvpublic


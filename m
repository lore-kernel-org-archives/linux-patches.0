Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2067.outbound.protection.outlook.com [40.107.236.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4167A22CBE4
	for <patches@lists.linux.dev>; Thu,  8 May 2025 09:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746697993; cv=fail; b=H1s9wKchmjpdWUy3+0mdCCBkwCtz/WJSfjegPrLSfBQq6BF4bWlsXVNP1XUdzR36UTdMwo2tbMUp2YQ3RxtSMlS4hchA69BsBwJZqS3IxdvRSdX/IZbFGdL4OBcYM8j3ddlNlvf8eTsZL/34BfuL17za41w7NvE6edAnBTAUF8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746697993; c=relaxed/simple;
	bh=K0vbTk7w/DLhaHtUhqxg2egZO2120dTiCYctrK16+NU=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mAYsm9SVCWPcTfljVeOzCneungxZUiIXQu4HXrdtBzNS7HnSJyBoi6sQs/bQloqG5BWZeqMP6pCSZOWaJ0sN6ZcshEWgpXqJF8H5vMeAbZrPCar1G8UjH48dLqgV3o9fyGfM1ftz2kcFaQ/jmTeEbbydr1Ws2lF52yzy3Mq4KWc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FJAxWKvs; arc=fail smtp.client-ip=40.107.236.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FJAxWKvs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EGLJ2oacNF0tbeW46emfo9sD75rqjNFlvUtoiPm441sjyyVjQjbQNEFayhqtZlM4jH2UUJTEWjj48JgP4aN/YrJNJ5r7RB/SRgLom27UmwHWWVtloX+wvD4783QsVTJQ6kAsSWAk1wkQd38KpO6TW8CLcneC1aZncI1lOQDGLybOPKkxrOzX+Q1ckZIDQPbxwPHF4x/qesF2RGshfUrEfjtgfKhvBT++pejj98NpVbA2I+jJYU9U3CWKX4NVPyLTxrKfV3FWBMA3LW0NDaNi9h89cngjkiAykPE89/vOKMYEA4vEghfHrCf98j1N5Y6mNZXbJ+Dys6Bzppbhy4p2IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cnTZu2tGN43dS9DCDQ3+WGeEcWrP5jJukV7Og7PJ638=;
 b=JYNLjCkoggnZ+dUCAHKVloipfsUy43YIjWdVHBjDsFAXN6qwALZM2Y+6n3LRfXVsFCUAo3PgN/mzz1Nf/dwq7AO/7F/PkepIBfK2MUdz90Z8Z9+PTp2tj96GUTbSY3+aq1BHBO7IaxpZTVDej0VN0+/hC24CNod7fIa2enDNOXWXKvHye/WEwSH/d56n73XmeiHzEnsVF+G2s418EHgjy4IljI47NGeQYOG17SOqYi1DP1wD1Ex5JC5z2nOAWuf6lL3o6DAobrLd5FOZtsFPrJOQGk/7deWlJVmIMh/xaiC0u4itTvXgwKNrl+3MFvZxqAGm6PJVyEE3LtRX6YDTwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cnTZu2tGN43dS9DCDQ3+WGeEcWrP5jJukV7Og7PJ638=;
 b=FJAxWKvsUj71rezVmGbxPU2OHraSYChcpaJa/VAYtv4Y7aJEGKyJJ4B7yFpSuRvVN7vVKEBLeiEuTTAH+CFFLvc6H2ENNtIuUiRIqcBtadsjuF9Rr9JhFS1iKtPz3aSCeCrrkONwt7J1Irq0sT3ezSvVGlpFxnHpnIQYdc3yvke1jSqdN66QF3Ng7fbjMUnsi2jGn8XVk/zjX+JP+KOnWYtNt/yDMC2wT/bYP8yzvcDzi4ecWWpyGFbvYL7YPQMYN8kt95knF9hErInDE38MBe8CI6q4h8yTMLlc34p8H1ARzRBTl11OuiQo3uTSEibMhfEurD20m9bdNGApIu6QSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by CY1PR12MB9626.namprd12.prod.outlook.com (2603:10b6:930:106::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.23; Thu, 8 May
 2025 09:53:05 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%3]) with mapi id 15.20.8699.022; Thu, 8 May 2025
 09:53:05 +0000
Message-ID: <55d3cdaf-539f-4d5b-8bf1-a2c5f917e81d@nvidia.com>
Date: Thu, 8 May 2025 10:52:59 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/97] 6.1.138-rc1 review
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250507183806.987408728@linuxfoundation.org>
 <864a7a10-ed68-4507-a67c-60344c57753a@rnnvmail203.nvidia.com>
 <2a83d6a6-9e80-4c78-94a6-5dedd3326367@nvidia.com>
Content-Language: en-US
In-Reply-To: <2a83d6a6-9e80-4c78-94a6-5dedd3326367@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0029.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::9) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|CY1PR12MB9626:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ad17771-5370-4a87-df0f-08dd8e1620e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VklqV2FYZEtrMUN5N2pyRzhydnprSVRxV3hjS0puZDRYdDdhTnZ1MlFRalhR?=
 =?utf-8?B?VDBXdjNIMHZXQW9IaXV2YzJDRTV0dUp5NmpRbXJVYjhaMkpLY21MeWlvcklK?=
 =?utf-8?B?OWhtWFA4NzdQS2p3eSszMmp0T3JMYXVxUkZocGh3TlFiY1F6TVJid0pOOFhP?=
 =?utf-8?B?OU1SWG40MVExT0hTa09SNkR6VDZsNDYwTXA0S2txTDVsT1Ayb1hLLzNIZTMw?=
 =?utf-8?B?d3Y4QUxLUjgrbFBGZVhGdlJtaW9yZ1dFTjFUUGFmVEJJdVR1cnozeFJzRnA2?=
 =?utf-8?B?MDZZU3M0a1p2S21HRkNOUjRYdDJFR0R6em53OUVsQUpYMFc3ZUFETnNtN2xv?=
 =?utf-8?B?TU1aN3NieEtHYkU5QU9EN21Fdm01ZnozR01iczZQQmpVT2FmSjZDS1FId0wz?=
 =?utf-8?B?MGVreTVzSnhtVVhLdkRtU1dzakJCa2JmYllNcVVwSkxHZWI5bUNCSld4STRE?=
 =?utf-8?B?NzUrbTZOeWViNldSLzNSOGF6dmhFT28xYlpITVdKRXhrazJjLzBTL0xkTm9N?=
 =?utf-8?B?VW00aWxPZkRqbGxkeitxR3JhWWx4WmY1SlVTWU9wdlZFWUxNMDBobUJCRXNP?=
 =?utf-8?B?Q0duNURSYjJHbFBta21UdmxzMUN3clFsMElCWUpXL2haaE5tSVVMRFUzZSs0?=
 =?utf-8?B?R2tGUCtBdElDYy8vcSszSEFoOE1pMWg3Vjh3UmRLa2JPcUJhQStlU2xsK2FJ?=
 =?utf-8?B?eUQ5bVo4Ym1ESDQzbFBqUUVWSlkrZ3luTTRSWm5EOURKV0hlWk50Y1h5TU1Q?=
 =?utf-8?B?QTBQY3ErRnFrRGtRVnRReEg0OTMxa25PRTZRRHlZVVoxRlA1UDI3NFlHa0Z0?=
 =?utf-8?B?V2pVZ2krRUVielJqb3E2L0dFN0JoU2hXYUgyaGZTY21PNGpWUGt3SDdUdFV5?=
 =?utf-8?B?bjREb1N3am9OZnlGUHRSc0NxMGhCWTh1eE4yeEk3S09XbFJ6bW5XQ2M4MUVH?=
 =?utf-8?B?NGxlY0l1QWxRRkRWKzB6WStVb1pLYm9IdVlqOTJ0Z3FJRTd1UTZCeDhkSjd1?=
 =?utf-8?B?Smh5L3hiRVBMMWpkWFVpak5GelN0STYxbTVSbFpQNDhNVHIyRUVUM3E0a1BQ?=
 =?utf-8?B?RzBZVHlhb0pnQnJ1cjl0SjN0MnBVT21mbHBKMEVrMXBOeC8zeXBiK3BIMXlh?=
 =?utf-8?B?NDA5S2FFNy9wTEhOeWpJRjRhNnVvWXROSEhTQXdCU3ZRWG9lSklzSU9GZGQ0?=
 =?utf-8?B?aXQ2cGhnVjY2ek9GSnZHdmx6Um8yb3FGakVVR2RPZTBtekp3WnI5bkp0NXE3?=
 =?utf-8?B?QVRSVEMybzQ2d2ZwOXFJRVpTN1daVmg0NU9JY2ZJMFNVNHZRckEzUGtPajRm?=
 =?utf-8?B?cVpQcUJ6cnJQaHJOWXRiTGlzRUZHR0dod1AzeFZGakZ1Z0s4aGcrQ0hIODkr?=
 =?utf-8?B?Y0lwRVh2c0puZUVnVklOZXBpVU1nOG03ZURUK2kxWGM3ZWdoRmtUckJEMHcz?=
 =?utf-8?B?aGRuT0pDQmVSVmlvdUlvMSs5VnNDc2x5NEZWbExXR3lPK1U3ZzQrZHZxcm94?=
 =?utf-8?B?S2dLTjh1M3UvOHhSbE1ydzNXZzliZmZUcFd3NEJLMy9qb29RZVQxRVhFM0Rp?=
 =?utf-8?B?bE42SjJGK0VwUCtkN2k0cGtpMjYrWVI5U1Z1b20rUnFrQTN1REl5R0VvTUxB?=
 =?utf-8?B?YU8ybzJNYjc1aVdCQk1TMVMyL3U4OGJGaGZCcU5iNnRQRW53dmdRZ3ZqbFlN?=
 =?utf-8?B?Q3FjN1EwMWZPZHVBWWo1aE5wbGdCaXJNZStZUDd5SThySVpzWEE3RHk0M3pJ?=
 =?utf-8?B?dTRwRHd5a0tSNFQrRDhkaS93OEhGZkRQdjlBQlc3YmVkVzBTTzBFRDlwSm45?=
 =?utf-8?B?elNVQVkwZkdzL3pKUkh0eE42NDdQdnZFRmIvcXF0NksvNFVsdWZhbVk2dFZF?=
 =?utf-8?B?SnV2djlFVlhzVHVISEovaU11aWR2Sk14VmpOL3BKd2FmTkE2Y2Urc2syUnQ5?=
 =?utf-8?Q?VnJt4/VaKA0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dHJMcE1FY09KWWFMWWs3V0FUU0U0UWJYUUYyM1hEZmUxeGZLaEkxR3MyazhU?=
 =?utf-8?B?Q3hIa1JZWHlzS2dlN2haV1kvUDlRSktqdGlXSXZrM0czVnRDclVyZHVKOS9h?=
 =?utf-8?B?NE1UMXUvYVhHMUxSbGVMeFRZajFNRHZGZk1NVlVjQXYvVkprRTNpRkNTN1I4?=
 =?utf-8?B?eXVESFpsQkZwcHBrZTBVRE5sd21EeEdkRmtMYXRFQmljSHlIMXJxdk1sUnp6?=
 =?utf-8?B?MTZ1M0htanBXY1N1WDQwRGVVUUlqS0t6SjE3T0VXTUlkbW1wT1lYV3RtaE12?=
 =?utf-8?B?MUJIa28wdk1YNDZUd3kvem9yVVh3amV4VDhuQzJoRi9UTTRteW5nbE1qdTBF?=
 =?utf-8?B?V1ZPdSs5RGVWWEQ1SjUyVmp4alNSUFNuUnVhdXdQTDBzWmhmd2RVVWN4VW5u?=
 =?utf-8?B?OFRyeGlDY2xrcmpHcnN4aGVLdko3TEFldDdjaXJsdXIraW5JZFZxaDFFc1Mz?=
 =?utf-8?B?eEVnTHV6WW9PTTlmZktVN0UxeDA0R2tPODdaaFV5VjI4dnA2dlMyRXBnSURr?=
 =?utf-8?B?K25NU25HbDBBaWpTR3FOQUExWXhDRFBsWVMxZVYycTN2bW93TmZwOVlVUFVH?=
 =?utf-8?B?OXYzNTF4U0RrT2lwb3puTVRGbGpFWHVjRThiK05iVzdBamR3NS9FK1YrNk9l?=
 =?utf-8?B?c2RydTRKSU1FMTFzUkxGMzNQaGtRM3NTQk9jMXlCMWtEeElST3gwanhXSFEr?=
 =?utf-8?B?YkFkRE4rT0Q2TC9SejZ0V3RYTjNZa1lrQ1JkeDBLY3pjaVRNZlVYbUNJRlZO?=
 =?utf-8?B?TnR6NTFlLzVNR0MyWk5OMzFsK2Zyc280V0d5ckQ2Z2JGS241andIMkpnQkYz?=
 =?utf-8?B?elBjSTMwNVNXWitYTU9RT3R2Q3huNXhaY2FkNG9aZGxzcW5yVkdsaG5GT0xp?=
 =?utf-8?B?dk1NbnJ5cHpJaUNoL0dEVUI2K1ZuZnRTNFo0emhmdVdaRjJIb2hSRWtMZElY?=
 =?utf-8?B?ekdPUUJJL2VvOUphSlltUFNvWFZTNEsrYUJOMDFOUE44RytOVGR3OFhkR2Yz?=
 =?utf-8?B?emtpYlRCL3ZuNEJENGpuOXFKQ2pTcHdEcnFNbkpncXV1TUZzWURXTFBJaWFH?=
 =?utf-8?B?dTB4akNTdHdySWdsY0JDdlhCbVpQZ2R5Z2FYaDRiTUdCaDQ1b3JIMHEweVpV?=
 =?utf-8?B?bU5veTkyZXZQQUw1RDVGWXJaRXVFWFMzcFE1TmtDNXhuK292K28yRGY0NDUw?=
 =?utf-8?B?N0FPTFpYSEVLNU1WenNoZG1LV3NnQmlLVXlUWkppMlIxWDhRMldzUy9zTEN3?=
 =?utf-8?B?M1lRa3dRcHFUQUptaVMyMjJUYVlSRUxDWkROMkswa09kSUh6Szl0OVRmd2VH?=
 =?utf-8?B?TkRlRWYvN29VV1lPaXRqWFc2VVNTUjVjME9Ud3JOZVplbm1UdFpxM0hML3Bx?=
 =?utf-8?B?OEdhVm5wNDh0MW1wVFEwenNsNGM2eTBoWndDMXlBSTJ4bHlJcEZmREJRZWlC?=
 =?utf-8?B?TmhaYlpaditJZWJlUkJOaEsyQUpsVXVyZjBXTE4xL1BCL0hSOWRlTVpsRCti?=
 =?utf-8?B?MzJvdXFUVytZTERRV0VjUmhrdktlMHRPdnVDL3NmM3pRdmZqcVBJMjNvY2JX?=
 =?utf-8?B?Z2EyOFBLSGJkRlFzeURvNC9GL1A0RW1XSXR5ZFQrUUI2ODVuTlcrb2FyQ2Nm?=
 =?utf-8?B?VGNyejdDcVlVMGsxaXlTNkQ5NFFRVVBIM1RqODhDbTNCWTArZmFhSHdUdUwz?=
 =?utf-8?B?QkozY29IMjMzU3R6dEJ1TGpkd2RNWG1hRmpDcGdlcUdJcmVUUjk0ZlpGYksr?=
 =?utf-8?B?TnorZ3J0cklnbmtaS3VZMWpOWHl5N0JBdUFmcEZNNk5XNzhiT0s3Y0hZc1Fu?=
 =?utf-8?B?b1JxNVNUWjRPb0YwMTNHWUFqcmJUOUZhdEpnNjUrdUFlWDFBWTJNaVZGWXJY?=
 =?utf-8?B?RE5XZ1hZZkhTbzhZZDYvZk1uVG1sOXVSbTBoTkliWVAxdC9NVjZOcGk0Mnlm?=
 =?utf-8?B?UG00cUxmNkZpSWJUQUxrYW1YbmxtMXh0L0JFOFRWa1JwcXFxOG96bWV0dzQ0?=
 =?utf-8?B?MDJDN3ZocCs4bjZjbTk1MTFuY0pJdnBuTFFDbXRjbFVSMzIvQUFVSGV1ZUxl?=
 =?utf-8?B?WXkwSnNjQ2ZQKzk2SmhsdnVDKzROdENVZGVKNEZINUs2T01GcmRqczMzWUdz?=
 =?utf-8?B?L3c2bVBxWXhRUXRxYjB4em5jdEdlOFJpZ2lFQytUOG5HZU1QV2k4bXBZRE44?=
 =?utf-8?B?TGc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ad17771-5370-4a87-df0f-08dd8e1620e4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 09:53:05.1382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LliEz33z5NqHFYI/fhODgnfcxWB+iTF45NEwCgCQ8uL9kZvAHd/w0T+qA4zge/FhPxbEDmBTxNi8rguOlymqxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR12MB9626


On 08/05/2025 10:48, Jon Hunter wrote:
> Hi Greg,
> 
> On 08/05/2025 10:45, Jon Hunter wrote:
>> On Wed, 07 May 2025 20:38:35 +0200, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.1.138 release.
>>> There are 97 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/ 
>>> patch-6.1.138-rc1.gz
>>> or in the git tree and branch at:
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux- 
>>> stable-rc.git linux-6.1.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Failures detected for Tegra ...
>>
>> Test results for stable-v6.1:
>>      10 builds:    10 pass, 0 fail
>>      28 boots:    28 pass, 0 fail
>>      115 tests:    109 pass, 6 fail
>>
>> Linux version:    6.1.138-rc1-gca7b19b902b8
>> Boards tested:    tegra124-jetson-tk1, tegra186-p2771-0000,
>>                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>>                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>>                  tegra210-p2371-2180, tegra210-p3450-0000,
>>                  tegra30-cardhu-a04
>>
>> Test failures:    tegra186-p2771-0000: cpu-hotplug
>>                  tegra194-p2972-0000: pm-system-suspend.sh
>>                  tegra210-p2371-2180: cpu-hotplug
>>                  tegra210-p3450-0000: cpu-hotplug
> 
> 
> I am seeing some crashes like the following ...
> 
> [  212.540298] Unable to handle kernel NULL pointer dereference at 
> virtual address 0000000000000000
> [  212.549130] Mem abort info:
> [  212.552008]   ESR = 0x0000000096000004
> [  212.555822]   EC = 0x25: DABT (current EL), IL = 32 bits
> [  212.561151]   SET = 0, FnV = 0
> [  212.564213]   EA = 0, S1PTW = 0
> [  212.567361]   FSC = 0x04: level 0 translation fault
> [  212.572246] Data abort info:
> [  212.575137]   ISV = 0, ISS = 0x00000004
> [  212.578980]   CM = 0, WnR = 0
> [  212.581945] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000103824000
> [  212.588394] [0000000000000000] pgd=0000000000000000, 
> p4d=0000000000000000
> [  212.595199] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
> [  212.601465] Modules linked in: snd_soc_tegra210_mixer 
> snd_soc_tegra210_ope snd_soc_tegra186_asrc snd_soc_tegra210_adx 
> snd_soc_tegra210_amx snd_soc_tegra210_mvc snd_soc_tegra210_sfc 
> snd_soc_tegra210_admaif snd_soc_tegra186_dspk snd_soc_tegra210_dmic 
> snd_soc_tegra_pcm snd_soc_tegra210_i2s tegra_drm drm_dp_aux_bus cec 
> drm_display_helper drm_kms_helper snd_soc_tegra210_ahub tegra210_adma 
> drm snd_soc_tegra_audio_graph_card snd_soc_audio_graph_card crct10dif_ce 
> snd_soc_simple_card_utils at24 tegra_bpmp_thermal tegra_aconnect 
> snd_hda_codec_hdmi snd_hda_tegra snd_hda_codec snd_hda_core tegra_xudc 
> host1x ina3221 ip_tables x_tables ipv6
> [  212.657003] CPU: 0 PID: 44 Comm: kworker/0:1 Tainted: G 
> S                 6.1.138-rc1-gca7b19b902b8 #1
> [  212.666306] Hardware name: NVIDIA Jetson TX2 Developer Kit (DT)
> [  212.672221] Workqueue: events work_for_cpu_fn
> [  212.676588] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS 
> BTYPE=--)
> [  212.683546] pc : percpu_ref_put_many.constprop.0+0x18/0xe0
> [  212.689036] lr : percpu_ref_put_many.constprop.0+0x18/0xe0
> [  212.694520] sp : ffff80000a5fbc70
> [  212.697832] x29: ffff80000a5fbc70 x28: ffff800009ba3750 x27: 
> 0000000000000000
> [  212.704970] x26: 0000000000000001 x25: 0000000000000028 x24: 
> 0000000000000000
> [  212.712105] x23: ffff8001eb1a1000 x22: 0000000000000001 x21: 
> 0000000000000000
> [  212.719240] x20: 0000000000000000 x19: 0000000000000000 x18: 
> ffffffffffffffff
> [  212.726376] x17: 00000000000000a1 x16: 0000000000000001 x15: 
> fffffc0002017800
> [  212.733510] x14: 00000000fffffffe x13: dead000000000100 x12: 
> dead000000000122
> [  212.740645] x11: 0000000000000001 x10: 00000000f0000080 x9 : 
> 0000000000000000
> [  212.747780] x8 : ffff80000a5fbc98 x7 : 00000000ffffffff x6 : 
> ffff80000a19c410
> [  212.754914] x5 : ffff0001f4d44750 x4 : 0000000000000000 x3 : 
> 0000000000000000
> [  212.762048] x2 : ffff8001eb1a1000 x1 : ffff000080a48ec0 x0 : 
> 0000000000000001
> [  212.769184] Call trace:
> [  212.771628]  percpu_ref_put_many.constprop.0+0x18/0xe0
> [  212.776769]  memcg_hotplug_cpu_dead+0x60/0x90
> [  212.781127]  cpuhp_invoke_callback+0x118/0x230
> [  212.785574]  _cpu_down+0x180/0x3b0
> [  212.788981]  __cpu_down_maps_locked+0x18/0x30
> [  212.793339]  work_for_cpu_fn+0x1c/0x30
> [  212.797086]  process_one_work+0x1cc/0x320
> [  212.801097]  worker_thread+0x2c8/0x450
> [  212.804846]  kthread+0x10c/0x110
> [  212.808075]  ret_from_fork+0x10/0x20
> [  212.811657] Code: 910003fd f9000bf3 aa0003f3 97f9c873 (f9400260)
> [  212.817745] ---[ end trace 0000000000000000 ]---
> 
> I will kick off a bisect now.


I wonder if it is this old chestnut again ...

Shakeel Butt <shakeel.butt@linux.dev>
     memcg: drain obj stock on cpu hotplug teardown

I will try that first.

Jon

-- 
nvpublic


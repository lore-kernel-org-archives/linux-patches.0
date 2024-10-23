Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF1E19E97B
	for <patches@lists.linux.dev>; Wed, 23 Oct 2024 10:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729678705; cv=fail; b=rXW0TrMJ3PMUA1OEPLZBU3YWWKxnFv6hOR4KydOPBysIjUJV+oe2SfK3LXsXe+l73tozZFjdwAIEm3OwKvTqvmSZiQWm+/EDgIkOKeeGzv6EurtoTvrgvgSLHq7YDZheNcF0M0O73O1zBtgM9Ta3w5Bg7wIn95MA31HlaeF/Od8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729678705; c=relaxed/simple;
	bh=a7zKJhSE9GSXV7CS6soYUyD832jUSgyFqNnvDPf19sk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D5pQ1U486yWDpwFfkISC8oPUWIM3s91RLnV28R6L68xXbxfPeJ2KB8CQlB5jwavpYwuiz5aZPC/Y5Fjv/jDgie9gb785oN0hLop05C3PnwArUsEybSlOG4AsJoJ80hVRD2ITBm/I5EjPXwO1pH2zEq7wxERAbAZLP32eilecmu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=N0k4JsqF; arc=fail smtp.client-ip=40.107.244.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N0k4JsqF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vE8LaScw/PZulsips/TvM0LoOJVyuU9OLqjX6ZHgUcz61wxAQQd5LvS++oH9vb0jKEDnADyqyciKmKix2auS3ArQQzNWVDtn66KH0/zKWDuHkhoJ5dYmoXCfQr/OKm/I6cDhzhx/N42jeQdnm2fJ94i2fL9tHVox7njQmTeEmdd+w9BOhjoZ0jn4tOp5eLYxnL7ARp2eAAcxiZ7ulepCfmCOgHza9qXPk1ahTTH3BpiFZ5T+BO90n//ipiUR5dHzEvzJahqk0GoOACrf5DFvzG23caDnkbMlOihrogFfjdxq4MShYVnLUTFBQXJ8BFBsEPg7L0tMpW+KuQHQGd9lMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bUUArS6Z4RdRsBkUmCNPSKFOzpbbF1UcKxiKBjJM+KU=;
 b=E8yaEI+CQumZI31QbBd+vXX1utqscy+6ieVeDYcouO6r1E5XmCQNohSZnjO/gpygsLnnDyWFvyA+YlcmfwKDdxD9AMTD+wX/O1xBEjw9x0EwxXJMYsFRwmXs2W+NfnTgzGWgjgBVwUCLaLIQqYVPdctMXDi1mNrDBSOE7smYj2Pcc5jtQJ8qGeWlyurVnDkL0RJOJlxXyL9SZClJWnQXW+VgM720g2z6NkXzY1+V8jrhQUOiDbMRRD4PnNM99AJO0a1HCoaQe3TZr4Aw4EoATYVeftVZiW5tNkGdbfZqHl/0uG7oM4pQBMJoerV4c1B4y70edOAazeL3z7R9iheahw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bUUArS6Z4RdRsBkUmCNPSKFOzpbbF1UcKxiKBjJM+KU=;
 b=N0k4JsqF1caQUS50siffmSNoFXf99emyryJsffOUw8tcQv1A3esycFMv7GR9XcnCjq77Q6+nWNLxKVuZFsPQmm8pr53DlqrmiV3rgGgoh8hdA7oc6cTKjiFqfatBEPwooarCaWim2QIfWbwZvuf1MBqlumn0ZCzA3zH+aulY9usZ0bqGABd4YiQ5CiXdfiqLkK9fKE7jQcZ/BQyp7I+f4B3i4SD+8dmb/cBWGjEVg5pOzUhACBMUmsbtlKPNTOE5MhcAXNT9I6udgLXWnpw1cvE09NtAzoWRoHvN30LWFFfMhC2NviS3N6/XZ3k37K9BoXN3PJy2sDeHUYReCfAWdA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by SJ0PR12MB5661.namprd12.prod.outlook.com (2603:10b6:a03:422::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Wed, 23 Oct
 2024 10:18:20 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%5]) with mapi id 15.20.8093.014; Wed, 23 Oct 2024
 10:18:20 +0000
Message-ID: <7a9f9cd3-492a-429a-9837-4aede987f350@nvidia.com>
Date: Wed, 23 Oct 2024 11:18:12 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/91] 6.1.114-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20241021102249.791942892@linuxfoundation.org>
 <23d85d2c-553d-40fd-a1f5-3356e12160c1@rnnvmail205.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <23d85d2c-553d-40fd-a1f5-3356e12160c1@rnnvmail205.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0246.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::17) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|SJ0PR12MB5661:EE_
X-MS-Office365-Filtering-Correlation-Id: d80bc637-9b34-41f6-2967-08dcf34c04bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NkN0Q0FJdTRaK01vLzZ0aHI1YTB0V2VuOVVWN1NKNmp0WENEMUdOWHIvcnZi?=
 =?utf-8?B?aEFqSTE0dGFDR3BnM1IrbTByT3VXLzlMUnB1Rms4bnZLYUY1WG5TQzV4QldB?=
 =?utf-8?B?elAvb01aLzN5aWpxL0Y1bkNrcWlQd0NtbGdDeS84K2xHSHVXdTZ2ZVpscDNB?=
 =?utf-8?B?TEtibi9CNFpMenIvZHlCb3pmcGlmQkNKWG1PSm1zV3RJRFNwdjQ4dzRUanpJ?=
 =?utf-8?B?RTBxYkRreFVmRExjY0xZMzVRbjNkVWNtU3ZWaEVPRDRLQlA4ZDBQeVdReHE1?=
 =?utf-8?B?R0tLVVU1TEg5K2I4TkhGcTZRSkQ4T29hclNmSWUwaWRtU1A4dFVsMmJMVkJK?=
 =?utf-8?B?MGl6Z2dKelYvSU13TlA4c1RBTXozSnVYMFlNMTh5eXFzZmJaRGpwNnJCTlZJ?=
 =?utf-8?B?d3FoOGxIc1Q1b1VsaDlHQTRCMklmSlUyWGVVQVNJNHhzRHdnTHlpYVVpcU8v?=
 =?utf-8?B?Z2Fhd0JsMFU0dXFwQXlDc2tJMzdkWmhiMm1oQkpSdm83U0Q4WjAyRFhjNWNL?=
 =?utf-8?B?azVKb3NCc1hvUENqaEIyV0h1K1E0RGF1aG1RRW41Y2dLNk9VWU9uQlY3VEwx?=
 =?utf-8?B?MjNVN242SWxlUXVjR2hZWTN2d280MmhnR1VpUkdSQ21PajYvTWdDVHFQNnMx?=
 =?utf-8?B?ejRpY3hQanlpRkRjZzM1WWorU3lsWlNxUWlxWHpXRHkxc3BIbzQ2VXo1MmND?=
 =?utf-8?B?ajRyTWpiaU9oOGFodzlEQWIwY1Nsd0ZkTmdTNzdraVNHK2k0c1A1bEthVVJY?=
 =?utf-8?B?b0x0RGJIRjdIL3BTZE5iaHRWQ1dsQllaamhJdHRmalZMQThQWDM1Z0JUdGNE?=
 =?utf-8?B?Z2dGZVdnVEVmYjV3T283QnN6YUpnSUpmbUcweHZFeFF3Q0xZaitXRHdPZEho?=
 =?utf-8?B?STFHMXAxV1cxaHM4RWUxM1A5TEh0UFB4WktyRWo0MWJ5WDBQVVRyYmxXN3Qr?=
 =?utf-8?B?RWdxbDY5RVl5dWlFeFpQU2YxYWc1bDlBRVFsRE1oY2RydUJRVkEzVzA1SXdj?=
 =?utf-8?B?cWh6QmZNbFJaOEJYYkZjaWtTUFNkOW5PbUJDQUhNRUppdGdYUlQ2bjJzWElD?=
 =?utf-8?B?RlJULzgwc0hrQTFNSFl5K1ppdlB0OG9nQVNpVWwveHNuczJnR2xhdzR2eUlu?=
 =?utf-8?B?b2JyOEEwQ3pDM0lGNkpnZlRmOGtZU205TWlsZTdPNjJQSm1pSDZ3bWYxWnds?=
 =?utf-8?B?K3YwZ2plL2tCTERWMkVRTWNzL0VBTkNLRWVOdmZxV2J6N25pWXR3T3lGU29O?=
 =?utf-8?B?M2NGZEV2THZXdExuckQ1bjk5KzFMTG95bVRnb25yN3lZNzBDakhDRjI3eUpU?=
 =?utf-8?B?YVo4NW9kM05iMTJKUm1yK1VWVGYrVlIzQVR5TWpKeVVUYnYzRFYwT2pON1Ix?=
 =?utf-8?B?R3BhYXhxdjFsTkRsRlN4dkc2V3J6cVZ3WHEwaFp1eUVzZTZySGVqazg2Vkh3?=
 =?utf-8?B?dTB1SzVnUzVnSnB6UlZUYTdobUUyZDlYYm9STnRUR2hVeGJWaFFKOGdNc1Er?=
 =?utf-8?B?TUhuNTZWdGRyRkVLVkNUc0JlUVMxcHBYRUVqU1Z6L0UwV0M0Qy9yVWxIaEVx?=
 =?utf-8?B?WGFOd3cvUWJyYkI5dGpuZ3JoV01EUnkvb3h6YlEyQXFuc29hS0liN1pOalFw?=
 =?utf-8?B?QzFNdFhWOGVEYW0yOG9leUFEWU9TU0ROSks0OUxwZVVmRzlQbzM1QWlFUFNB?=
 =?utf-8?B?QTh2SUY4S0oxV2JSZFpGdzQ0MmtmZGo1UTNyZE1iRUdPZ1JRYnNwL3orMlJ3?=
 =?utf-8?Q?kYXJuvCCmNYZhvMZFfcMV22BTvJ2ATv6q6y2bJR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bEkvNnc0SGd0L3c0ZEJtYmhBVnR2SnBjSEt3dU5YVml4NUpLc3MxYUs1L1dt?=
 =?utf-8?B?VTAvMFNyZS80ckZPbmo4Wit2V213VjdVME9aWnUrdVpXcU1lNGUxWlJMUEh5?=
 =?utf-8?B?bDZnOXd2cUxmRmNCaDh1MHg2VHlHOW44L2lqSTVyT2piYzBqNXlnSEY5YTdk?=
 =?utf-8?B?ajNvemhMakE2Rk9UTWkxNHlheWZlNzdWdm5OWElUSmRpWkJnMlB2TUxGVEY4?=
 =?utf-8?B?TUxtSHNTV05TU0h4SHF0ME95b2JzNkFwTDZtVHZLcUdMOEptNXU5UnFXUzBu?=
 =?utf-8?B?WWFOT3NQcGlVZ2dkb29vVkprMFhuY1I1VS9DTmpPRmEzTXpsRVphK1l0SEM3?=
 =?utf-8?B?dWVyV2lEZnZybUp6WGRpR2tKdy90VVdCVVVvRHBFVWFrU3ZPTnZYbzhwZVdn?=
 =?utf-8?B?NjhlNjJZNW5ZaFAydWorcnRSek0rTU8vUjNIem5pd3IrMnBHTWFTMCtCSmZV?=
 =?utf-8?B?Nk9aL2kwSDFwTnBoeW1CTUdzT1BSMFlsZTdGL2p5U2FVMDB4NVhmNzZ1ekZ3?=
 =?utf-8?B?SmlURGwxL05HZGZOdXpEZm1aUGJseGlJZkhLT2M2R3FjT0tZRWFkMVBvTFBK?=
 =?utf-8?B?Y3U5VzBQb3VraEtyUnoyMnBxTEZVUFJSVXdETkxkOC9yd0RMeWVzbkQxVnNq?=
 =?utf-8?B?WTdUK1Jnc3RhUjJUT2psZmh3QVVFKzYxWVJUWHkyZXF4NUZ2cVU2dzdXd0Rz?=
 =?utf-8?B?d3Rmc1o4aStuL3hwQ2FHU3M0NzY0VHhVdHhoRzJOTFltOTJqam1waC9sMERB?=
 =?utf-8?B?M3RyT3JBYXBFRm1TRzQva3RCUHMyRmpWZlhwakZkTXdtVUI4QVhxQzB2MGNY?=
 =?utf-8?B?c25FUlRXSWRLZStpcVhMWnA1M1gyTjg3elFyQ2tIVHpBN3NZdERBN21LK1Jj?=
 =?utf-8?B?VWRhWmdCOXpqdHJOY1hCd0JKZkNiYlE4NWFJUjF6M2pzeVFtNDdMaXVOelpU?=
 =?utf-8?B?YnQzb21WTFBvMHNsaTR6b201YU94Wnpoc1g5eDZuWGM3UUtsRmVlckc3bVB4?=
 =?utf-8?B?Nlp3SVlaZ0tXTDQ2OGJJU2hBV2kxNGNNVUptdjdMSUlvaitCK3lmbXhONk1v?=
 =?utf-8?B?c1ZtVDQrL3BJZ3Fyc09zL1NubEVIV25CdGVVUGtDaWJMZ0pPZnZ6WFJ2SWsz?=
 =?utf-8?B?TGNzWENkMTBZeFRBMjVLVGRhQ091U1pwRWVOSkRvVm0zWmx2ZEorcWFYSCtq?=
 =?utf-8?B?amtaMGpDZTVHZDBlVnFqSUFGVDFQL1FIbVJYa3drR3hyMzgxN29aa0JiSDFW?=
 =?utf-8?B?UkV1dVY5OXhhaFVLWENtTE5lY2loUjZyUHc4eGtrNkZDS0VMdUlaNmJLMWhl?=
 =?utf-8?B?Vlk5UnpVOFRLNUJmczJjN2ZseTdDd2FlWklhbUlCVzdGWGxYYVhsMXk0V1di?=
 =?utf-8?B?Y2s5OTN4YjVPNlBCT2xNamNQNjhtcndmcW5TZm54ZlpSTkcxU3ZRcnRqZkRh?=
 =?utf-8?B?emovckZrSkwweXB0c2pLNlJkMk1EYmlTdi8vcnRPSDcwV0tRaG9Keng0Qk10?=
 =?utf-8?B?VXV3cW52ZThMMHQzOCtkQ0F1TzVUR2w2c2hNM2UrOGsrRHN3VmF5RXhaaGNS?=
 =?utf-8?B?ZXhRamtOUG1KdGZHOU1jMlpsRGxwY2pORVdYN2dvS3dEN1BIQXJCVCtWVWdR?=
 =?utf-8?B?bUN5dGtVSTFnR3ZjWFhUd0dCVW5ncVFEYjZSbEhXT2RLWkU5WG9RbURsd01h?=
 =?utf-8?B?aUVCRG83TzNyZnFBa1dlZ1liV21QRGJ1dDlqQlpaU1plVTY0N3U5ek42RW43?=
 =?utf-8?B?RHVRY2s1U3hFaUZHM2lEMGxzWU56ZTZzZUZOK1JaaU4zdjFyZFF2WGVKZk9i?=
 =?utf-8?B?aWdEOUJDODdFa29tSWwxNlNqK0JYUTQ1UXlnVDNyaWdWdFFpbGY4cjNlREZn?=
 =?utf-8?B?eW1ITmYyQ2RFTUNValNHejIyZjlVVWxyNHdNUXlvNVFPRDNNWndCczR2SU5a?=
 =?utf-8?B?VTR1Wk4zaGozRmQ0UStod0NONjFycDRiS2Y4RmJzWStCRzQ3RTVnRlFQZ0o5?=
 =?utf-8?B?UnBDMmU4QkpiZDllRXltZHo4OUJlczhORXJRUy8yOHRLOTFPY1FBUU1HT0Zt?=
 =?utf-8?B?ZG1ZU0Y2dWVkTVhMMTc5ZjBEczlqQnA5VFd1OEhkNnVWcmEzaGh1Um82Qkd4?=
 =?utf-8?B?eWtVUm1iM2p6MFFnYnd5S3lPOHlONGFFUCs4b1ZEb3BSV1pyYnFJZTZRTm5k?=
 =?utf-8?Q?0a4rLzY74m6JOqyEXj8ONcB8VONEHbsMkgfXZxgWeEqO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d80bc637-9b34-41f6-2967-08dcf34c04bb
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2024 10:18:20.4782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c8f7C0TwE91Lbt2pvaggmW23cn+sxx8s81j3c4JXIu6UVjj0MZKa3tEwfPuELN++FK/bLgWCXh4ibtVA/T/DBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5661


On 22/10/2024 18:56, Jon Hunter wrote:
> On Mon, 21 Oct 2024 12:24:14 +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.1.114 release.
>> There are 91 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.114-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v6.1:
>      10 builds:	10 pass, 0 fail
>      27 boots:	26 pass, 1 fail
>      110 tests:	110 pass, 0 fail
> 
> Linux version:	6.1.114-rc1-g6a7f9259c323
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                  tegra20-ventana, tegra210-p2371-2180,
>                  tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Boot failures:	tegra30-cardhu-a04

This appears to be a board issue. With that ...

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks
Jon

-- 
nvpublic

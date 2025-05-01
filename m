Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2058.outbound.protection.outlook.com [40.107.102.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2925D267AEA
	for <patches@lists.linux.dev>; Thu,  1 May 2025 07:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746084446; cv=fail; b=VYSgjYYOhTVM0Ts6sy3jjDd7beqHjwNC2boN530uiI8HNufOHsgQX41OHXflt5rl3npilsLNkMxrdz1+euD01F4S8Bn3pB0qSg5Z2gcToypxyAxOzUSvy9SdqgelHqTlGzYdtqqfgkbdUeo7QiXzOx/wXF9NaWzA+X7DJDmQqzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746084446; c=relaxed/simple;
	bh=4Rs/0bni1uCtfKZQsC9rCJg+1XZUXw7GhMJKg0SsXtI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=raDCBT31zfuLGH1rLSMwZO/9FKYgh0qXMm4sMeTBQaMDdwZv9MFxpKPyABtCTfQW/pKkguNiFkC6gP/d92vctraMa4SKYqyYiZODuN6dyqYLvNqKAEsYM4jGXR1gIPgY6rg/+UU7DPUBuxCL1XtlQgXV73qfQfILpTttDjFmfPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=W6wSIPOT; arc=fail smtp.client-ip=40.107.102.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="W6wSIPOT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UqvbVBY7uOwb3mZ0LgRuI2oQlfPsuXvb/9ZB0WLXqDLq+jwV0+QW5N5f+2F2hmm6x+9iTpizAWZSeyc5pMBn72Gby3JoHnIGy5nUMTH7e/XubO2xgd8NKHFZMK1PcsZs3EDK+8YkxNPOoDpzbd52RVBmJ+6I7xzy3xU1Cj9zikPZD2BGgbwnuwFNsQ97crKGl5LJVAN9pWiLcUuNKB3CeCsGbnXehmpdJ8GIC2TRWS8xsYi36D+4K1Cqqm0VSYeVlPdNf1Ihi2oFk4ET6w2ytOYcO4II9JXeIUcde4A1lMSga6M/dDMgAh6Avtj0/zM9PUJVQfWc9IG8gINHD3nsxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nZ8Fb2vTDabue3+AdwuzZnZpGgmIbAygL9lTlGSkJIU=;
 b=ZUDTERtiLNTXWOHp+McR7sWofbLSpFwz2N/trZ+/3Wt7U5u6TU0AFvsSPftLQ6vh65CWKngs7FppdQDEfkklkHdS7wwQK3sPThPcNeedGYAmf1aCWBaQ1aAnBW/p9zSH2Wu6ngy+t2hslka+eA8JMcC7aq1T6b2Qz+Sl1v9Jg3Pfmtz9eQ4fYOGHePxOYr6O6a1HmpqhRfYKgWfdI2K67EPd/E5OshWp3sCiCFNeQhhMEEFh9ZddAZE+cTR81QaSM8hBLrvZ6jLM8faoIh2ZUPQyZSK2E6RGven5fvzdqLHVLAh/SUqyoBm0iCqt6uI9eC3Yc9AGYBnqaJC+/eXKPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nZ8Fb2vTDabue3+AdwuzZnZpGgmIbAygL9lTlGSkJIU=;
 b=W6wSIPOTxIiHaFa7k2OTjtcKIL/UIHpAO5PEahFp+G2Qs4MzVbAGts3KQrc/nAFKRxcjluekT09NdUaL6/HLsJwQgjzuAZCZYqtvQARuBSi4LPrTwoot88Q0QrUylWlnz8t+0csnkDkuL5YS5yck4FaYrPKN4UOScYnxUMQJ3nMYB19jBA5XJ6g1wdw3RXlJBhWH9t5S11kbRkj+Yj9wZprW/42H8MIncAwilhiwNptFmW7L89k6FOrpe8KXZbTTiSlnfH9R6dxiysrWKa2cWnZE2HPVmhK0RY8FqxFncKKUox5I/ntD9xP65p5xF0p8ibOBVeNBGV0684ZrLhVXCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by DS0PR12MB8218.namprd12.prod.outlook.com (2603:10b6:8:f2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Thu, 1 May
 2025 07:27:20 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%3]) with mapi id 15.20.8678.028; Thu, 1 May 2025
 07:27:19 +0000
Message-ID: <1903a129-6e06-47d9-862b-ab23f72a9fea@nvidia.com>
Date: Thu, 1 May 2025 08:27:12 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/204] 6.6.89-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250429161059.396852607@linuxfoundation.org>
 <f84163ad-2e1f-42ca-8546-7e077e13f4bb@drhqmail203.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <f84163ad-2e1f-42ca-8546-7e077e13f4bb@drhqmail203.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0182.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::12) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|DS0PR12MB8218:EE_
X-MS-Office365-Filtering-Correlation-Id: a6cf151a-1e39-4b57-973a-08dd88819ae4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SVhJcUJFdHd5ZG1SL3lxc21FcjVtUkljNS9Ba0phR29HTktCZys5TnlpTmdx?=
 =?utf-8?B?eGxrT283QWhTWjlpcE9RUHprdEt6d0NSemc1RDZMWkowVjFVSEFLV29GbzhR?=
 =?utf-8?B?NkhyY0NhZ1hPZHlIenFnTW5ieERPampjd2NJUHFncW43V1BSdTNyRjJJMXNz?=
 =?utf-8?B?NS95WWYrVmdqcVA4QW1VV3ZZQWtiTGtSZTVLN2tZcm9FN1h3eE9SRkpiVHg2?=
 =?utf-8?B?N3NLbzNrS1pLWFZmYWZpSlg1M3NsY3dVS1NyVHVoTklna1RnNS9aZExQVTlE?=
 =?utf-8?B?ZmVPNVJkQVJCMWF4cUZRYWN1Y2ZNbFpMUEJrQ1ViUStTVzdISUpsTXRiUkNN?=
 =?utf-8?B?TUVaRlJ4T2g4MkdzbDhmcjdXS01sNkhpQlArZkUvSjU1YXZnNVh6dFBtUGJx?=
 =?utf-8?B?V0pCR1hzL1hTNzNLdjRLYmdMUmdtWERCUkg1RFFXQUU1SWxxYU04SFFLaExa?=
 =?utf-8?B?bW1SUHdrMzAxbUJvMzRDS0lYV2RGWmI0OUNiL3JuU3BFNElFcGkzWEtUUGVy?=
 =?utf-8?B?bk0vVTV5dmQ0dW14M0U1YjhlclpPbjlaZWxINHdreHZWYUgwZWtnRFYvKzZv?=
 =?utf-8?B?and3dHYxend4MnlZT3BWcEloODFtb2RXdExIRURpUTBvRTZ0dmhMNTc2eWk1?=
 =?utf-8?B?TDNnQW95UFdWeUNscTRFRVd2dUpPbGJRVnJpMEQ5eThjUGtMdzVyTjBGWDNh?=
 =?utf-8?B?dDg5YVEwTlFySmJHODZGbkxHUElhdFdmL2FyZE5ZRUU3RlFYdnJ0Skx2RklD?=
 =?utf-8?B?ME5vblFLT29ad2lhTytyMDlEb2l3cFIrRmR0elhUSW8zaDNPSXZ3dlhaWGhE?=
 =?utf-8?B?Qlg5WW14elBBeUVmVDFnUEJ0aWRrWnJPb1N1OVdZaEhrbW5KZEYyM21oMHNw?=
 =?utf-8?B?SFlGUE9BdXorRCtLbjNmbWJMeHpDckNiSXhPRHVZbnVmL3NGRFBFRUN6QXlv?=
 =?utf-8?B?SWlHekxEbEtCU3hkWjVyOUlpR2ozbGN2QUViS3kxR0tGVVRydFhXY01Hc01D?=
 =?utf-8?B?VnI2Z3lKc2RibW04YVhvRWxlSndmU2l0U2dWMXZQbGhwRVJIRUo0OHhqbGtB?=
 =?utf-8?B?ZW9oeHFwTzVzd1l5emVhdTJ4alRYaEhheXdORTlVYW9kdStEbVZmYjgwL2J5?=
 =?utf-8?B?c3NVbnlrTmZnc1dvaC9WcmY1SHh2NWdIUWNBSlduVlJkSWsxRzlkeE5WVFZJ?=
 =?utf-8?B?UVBKSmQ1SXBhSzI5b09RWDZnTU14cGJSMkdtdVJJVitJdFVYREZMK1RoTysr?=
 =?utf-8?B?NVoxeXoxSnNCbFdpdVVoMnEwTDQyRjU5NE9DRzVKVnpDU0JrRXBJQlU5UDc2?=
 =?utf-8?B?b3V4TFA1VlE4VnE1UWZzVzFxN1Z5dGhYbEVFZFJkclRlZm93UE1mSlN3NU5S?=
 =?utf-8?B?SUVuSy9CY1JTYlh5ckNVTEhxMTNycCtuaXhsRGFCRmFBL0RUOXE0emNCVXpP?=
 =?utf-8?B?YVlaTGZyaXJudlpWdG4yWXhnTWFuYUlhYi9qRjNOSDNUOE95QUpxdXIzWk4x?=
 =?utf-8?B?MFdBd1VEbVBtYkRGbTN4TW5kb3BJZXpQNUxpdGlUcm5MbTNIb2E2VjZ5UlpP?=
 =?utf-8?B?SnlFc3NrS3FIS1AwcTdWY2ovNVBxUVpGVENEOU1sOWZ6SG1wbVlNd3E3djY3?=
 =?utf-8?B?SFBSc3V2MFZDeDBmM2tPVnNiT3FOWnRacXpvQjQ5NFlXSFdDVmhpVDZPMGo0?=
 =?utf-8?B?V0tlamVkaFY2NW9uZmd6c0hzZEViWExkV3l0R2pScjhiRlVWbkVORm5FNk1r?=
 =?utf-8?B?b2prZ05WRVlEd3EyRkdNdlppL3AyZlhQT1p1SDJ1WlkvRWNqV0pmaEdHbndj?=
 =?utf-8?B?NGZacXpPcUFWOGVsblVZSDRSeEJUVGowblRNSUp2R3gxT1BHNUxoS0kwc2w0?=
 =?utf-8?B?b1VvTnNLWWxHcGxhWWc3Sm9PTnVKTElERU83cW1xc1c5R3BSNVB1cUUzbVpG?=
 =?utf-8?Q?wSI1zewWgOw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dVZRS0FzQXhaMktOMzNRT0RWS0YwV1IrdzcxbkdpOXVTdlpuKy9vY2tUODJD?=
 =?utf-8?B?cWVLaVJRNzhaNjNUNG1CekozVVlzcVJFZDVVUUNDSGxCN01odVJnVlgvWklK?=
 =?utf-8?B?OG5yTXBQOFFBY0tNY3YzNjJsclVjeUx6NWJsU0FrcEFwaC9WTlAxcldiK0xM?=
 =?utf-8?B?L0JuYjlSWXExMi8xV1lNTFp6QUR6TlBtckZJaGV3ZWZSc2tjc2ZPbGtUUHdV?=
 =?utf-8?B?T2FTeHBXMGhSd2ZzY1BsWnNZdGdCbjV4cWVDeVc2ZEhHaWJkOGR2SXU5bHlF?=
 =?utf-8?B?UCtVUTYxeVNBUkc2Rzc5T1JpYURmNXppcy9TT0NZWlFkM3NTTlJIUll5WE9l?=
 =?utf-8?B?TWpRVHRmcVhmVS9rUFhoV05MZmp1TFNtZEhqNzBRdHdnT1MrOFc1SlVMVk4z?=
 =?utf-8?B?MEhUSklGVVFYUXlTQS8xN1l3bzBxTnoxMnR6Vm11b3ZIREhhbWdYdSt1bzMr?=
 =?utf-8?B?dk9PVWZMb3czZGwzejcvU0hTaCtEWk05clJkWkhsMWE5OGZmRXlwZkE4bm5t?=
 =?utf-8?B?MXBtTkhJY2RabS90NE93bjdKbkxEeW44UHc3RUpRWjdHVk1uYWlnTS9GOGh6?=
 =?utf-8?B?NWhMM1ljbVJma1NmNUFIUEQxL043dEhmaWxMY0hBcjlsVnpYSGhOYWtwVzh0?=
 =?utf-8?B?ZUl6RTYyV3IvcjZkeklWWDg0M3YrQVpTZGdGSndMKzNPekdML1M2SzM0aW9C?=
 =?utf-8?B?RzRVbFJiVDFYcGVjRFFnV05NM2YyZUF5UHdYWXpQLzRyMk9haEZlbCtQTUtl?=
 =?utf-8?B?KzF0SUtGSEwrUXpYMjhFRkxtUkdzV1h4cEtsc3ZncGE2ZUsrT1dDYXQ4bHVP?=
 =?utf-8?B?SG9OUFFFdWhKZUZ5cHhKd0k4dVY4LzQ2WUlUb2xOelltZmRTT0NsUXE5b08r?=
 =?utf-8?B?NDhGbjdzdjl2WFVNaW03VzYyd2ttZVYwYlpibEJpSkpOSHA3clE1a2xRUEZm?=
 =?utf-8?B?SXFPUXdxNm44Lys1YkdTMFRuMTVwTUVjV09PSDAzLzdwVzFtT1BMTGtzNDMy?=
 =?utf-8?B?czF6T05UUnJPQWdKMDFjUi9IcS9tbGZZbEJUdFFBM09uaW9acDVOckpUN3Vs?=
 =?utf-8?B?TFZyVDVhb3dUVlpFKzE3cS81VmthNG1sdGd4NUdmS2hwV2gvRm1kemFOcnZ5?=
 =?utf-8?B?bmN1UllxZnR3ZkQyeUcvWWpJU0FwZ0J4Y1pYZlZ0ekVSaFZmVFpkZ0ZSMlJR?=
 =?utf-8?B?Y0tJK05IUStZbVY2UnYzVElaYTFhbTZ6R2p1YVlxRFVjYWVMZS9BVkNCM1BH?=
 =?utf-8?B?Zkw3WFRGZ01QM2c5djB2SnB0NGtVTWdjcWVqNEVFWnI5WiszRk4rdTBHWnZ0?=
 =?utf-8?B?RDlIL2VRcTdQRmhPOHBlQ0tzaisweU56Skh1UzRUNjRXWVMzK0o5Z1kyQkww?=
 =?utf-8?B?akE2alNkZlBHemlRZXljenBMZWU5M3JHaXF0ajNQRHVVRVoyYk1EUENSQ0Jo?=
 =?utf-8?B?d0JnS3pHRStpRjg1SXBzaVZndDREQThRMkpzcHZhQm1uR2ZRbk1xZHYrMW14?=
 =?utf-8?B?V2hsb09yaUtjWTJXVDJTa2V2Vi84c2lVeHF6M1o4K1Z0WGo2N2JzK3Q4L1kx?=
 =?utf-8?B?NG5kSnhGVzZLRlU0VzFEY254T0NvNHNFcnllU3lUcVdKSUJlUjVyWXVoL0hp?=
 =?utf-8?B?c0k3bjA1VHRRaWFMdlNrRE05YnFpNit3ZC9hWW8rUWV0Q3FsNDlBYkVmRDdL?=
 =?utf-8?B?QkExanRTbUtEbDRvaTJBQWZ1eElyekxCcGU3Q3FmNHpPcWFnczJrY2FoSnhu?=
 =?utf-8?B?VGlUQk9EU1Z1U3lzTlI5YUc3QzRlT0lxWXF4VmxBZWhLYU1jN1JCUFpXSW1T?=
 =?utf-8?B?NHMxQWQrUWxjZ3JJSmRodDh2UDJteGFvTEU4QjNNNHhpblpOWW8xeWVURzY3?=
 =?utf-8?B?cWVBVHlMVEQwQm9RSjN0MjNyZHRHd1JMblI3ZFhKbUVTTytjZlJ3NExMTEdo?=
 =?utf-8?B?b3lwRlhmZEFYZkVIdUZoS090bmFFdjg0bzRQQlp5QXh1MTZoWmM2OEp1TVZi?=
 =?utf-8?B?RHFIb0F1VFpiYmhHVk5rM056N0ZVdFdjdjR2ZVcxWHRNOVgzZGtyR3J1L3lK?=
 =?utf-8?B?REVKZWx1b3BsMEp5YnhHbkEyTVAwdGpWOFhndzBFNk56Wmd4K3lsUThvQWlR?=
 =?utf-8?B?WXBmbE5nYTkvbmZ0OHBMQlRXN2dTY015VVBWSUJ3cnZPRXNQUkM4RTg4WWc5?=
 =?utf-8?B?L1E9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6cf151a-1e39-4b57-973a-08dd88819ae4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2025 07:27:19.2495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3SuJDTeslIL+whnuE8+MKl0MywBPjWhuBef1faM2MF0NWp3pgSLMWA/3SM3xfTpqmvL0M9lLbw08mc038GAX0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8218

Hi Greg,

On 30/04/2025 16:04, Jon Hunter wrote:
> On Tue, 29 Apr 2025 18:41:28 +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.6.89 release.
>> There are 204 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.89-rc1.gz
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
>      116 tests:	104 pass, 12 fail
> 
> Linux version:	6.6.89-rc1-gcbfb000abca1
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>                  tegra210-p2371-2180, tegra210-p3450-0000,
>                  tegra30-cardhu-a04
> 
> Test failures:	tegra186-p2771-0000: cpu-hotplug
>                  tegra186-p2771-0000: pm-system-suspend.sh
>                  tegra194-p2972-0000: boot.py
>                  tegra194-p2972-0000: pm-system-suspend.sh
>                  tegra210-p2371-2180: cpu-hotplug
>                  tegra210-p2371-2180: devices
>                  tegra210-p3450-0000: cpu-hotplug
>                  tegra210-p3450-0000: devices
> 

For linux-6.6.y I needed to revert both of the following changes to fix 
the above failures ...

# first bad commit: [d908866131a314dbbdd34a205d2514f92e42bb80] memcg: 
drain obj stock on cpu hotplug teardown

# first bad commit: [4cfe77123fd1f76f7b1950c0abc6f131b90ae8bb] iommu: 
Handle race with default domain setup

Jon

-- 
nvpublic


Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2054.outbound.protection.outlook.com [40.107.212.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF56A59
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 00:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740442016; cv=fail; b=nft7RF7j7tG4hn6ijN93HkKgIPO/rz8hzIBQvzP0cpOC4ebvEhB0Abwd88U9hMzdDSC+/QMZOJdt3OAOGQ+uX0Vc3KR0ALCDU4tcNarHOt91AJ1yhVW6S75t+pHC+vfIiQ1HClKcHYnL8w7j4F4O47KjvifZouE7Hyqipdc5z1Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740442016; c=relaxed/simple;
	bh=9yMRCk/Lr5Z0JuUHpkgjmryTmMioBiyfsurt4j9hgdo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CScohh2batSMQc9Z5W85gQoN03lr382e8YiYs9+LAK7MHYTHTYrIz1bME7iKzs25UV69xU7bsuPEYGPhIVSVvOSyXSmP8LXKugBQU45rm0S+AV0uuV0J/46dpo83S2IwK4yznGqBdPh4/xaEXkx84tJPqyVg661LqKZgVRkik/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FbAYfPPa; arc=fail smtp.client-ip=40.107.212.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FbAYfPPa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hIlqAeIxRbqgjlqXUXScYhpUED3tEJcELyAtVXYbr4JUs3eK7S+OgbG/IlWQKtJyKeIfzisMBxbffazZdytxh8hF1T9SGC/klv3NDw5AEm5op2xZw/Y+5kJsHQhh1U3Eyle+bW0HRV8dsE8kql/duLVroq210tvpKnDRHPNS+wOgS9qZF6+7wZN7ZiKqMRVIzeNbNvvuedKRCnmImhrzBPzL3oRBB4eT4hNt4e8qpIeljs5TELPrDNY+g6sXWEjw5Bgto22PzaubQiYZds+l423rJaF3+NPIWFuf5N0psGJaPnSiYaqbgm/9WkrWPu/ALnvbfNl+mm9vLqvfbWNdvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J2sxH/7PE+cgFuahLerngxAJT+hwgoobDRGb7luaiR4=;
 b=n4Zd/DEjJWhqknC71sr/yBe9+hZLBj0MhY3Imfs7u66+iFrGsiXYmpOa4LP66Q6odifwPZBaaDwXsFjzGQULvsB8zdOce8AOqJvwqVWu6ggSwCBPncvLkcyoPtM3z51K6rBwSjAc2Cj4HT5YFh8CrlX19NgYd9Ly6jfAJqdfWsPOsVrb7iHcn7VGTYJk6jzmVOtWwNnZisi6jaOJFLAyGmYVQUOT1RWX/j/gYLN26mxfXQaXYELYdDQy6jbaAFLMSkD4xC5H0RVlVWUW+o1QwkUBt7uW5jyCuGsySXfDgm+toPVjHw9ULhtIQ/KwPLYkz0tHc09UY0uOAQZfAuxdjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2sxH/7PE+cgFuahLerngxAJT+hwgoobDRGb7luaiR4=;
 b=FbAYfPPadCq5fj7lqO5tQR/7JDO3bgD3sFaD/VTHnPbavoDwiG4goSrktGD4/uYSwYwjVItLM6RmEx0ZCiJRThWeRzaFOxHTlL8xuEF1NTyPTshfZFPHemaYom5sUYsvqMPEqr+H+aA/mGwy0bedBQq94dqoTagJfAysifKbMgp4r+k0u2h/Nn0jwIv4Nzu+tWlqxyaaU0L1Df/oXrv+g4eZCPc+M4rj8TwsDF7Hm4OlSINRVLfrbvQUPCqIXzqj0bZVx7FpR8tCjhGROUz6HazpnwZcFe96oqztKRvSkK8L62UMIS5Bgp1h78mdSJcsukelRAwvK2k9e5QqmvlxTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by SA5PPFCB4F033D6.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8e2) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Tue, 25 Feb
 2025 00:06:48 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%6]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 00:06:47 +0000
Message-ID: <3e5b29cd-b9c1-4509-8362-a4465e11a9f3@nvidia.com>
Date: Tue, 25 Feb 2025 00:06:32 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/154] 6.12.17-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250224142607.058226288@linuxfoundation.org>
 <a89ebd7b-4cbb-4427-9fcf-76a3737454c2@rnnvmail205.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <a89ebd7b-4cbb-4427-9fcf-76a3737454c2@rnnvmail205.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DO0P289CA0010.QATP289.PROD.OUTLOOK.COM
 (2603:1096:790:20::11) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|SA5PPFCB4F033D6:EE_
X-MS-Office365-Filtering-Correlation-Id: cdce68b0-a8fd-4b1e-624a-08dd55304bc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Uy9uYVV4andPdWdiNUgzR0U3QUdmOGJ3cTYvajIwVHZFcVA3RFlYc2M2VzR0?=
 =?utf-8?B?UHJ5VWl0dFViRUp5YzNFMXdSQk9STlNibGlsUnhLWkhQUmY1QmM0Sm5IUTRG?=
 =?utf-8?B?MUMxa1NmYUYvdGp6Kzhna0VyUElWMTl6aWVuODI5NERtYWpMQ1AreGlsWXV1?=
 =?utf-8?B?cktvT3NtZzFQT0QwUGx4YVlwbnptc2g5T0wwMHBPREpUaFRySUpZOExVd013?=
 =?utf-8?B?a3ZZVHNEZWJhY2hYK1RZRVhLc3JZQU5SUG1CV25UckQ4MzdiaTNuZWRYWUp1?=
 =?utf-8?B?eGdpdC9Ma2M0KzVyRTFuNnhHK3J4eE5PM1VuZkhoRVlEMDFlYUtmWUl6NFJB?=
 =?utf-8?B?NTlhblU1TStEbTE5MWJuWlhhR3BaV0tFelZkZ2VCbmk2UHJPWjRxQWkva0pD?=
 =?utf-8?B?Z204WG56UjhYcndCVzFPay9zRVhYaUpuOUY0MERWTUh4SDF0Z1FFZ2tzQVFm?=
 =?utf-8?B?TTloK0UyZ3U0WjZ3ZERSY01WaU1ZUkF4ZlF5VUZadm1GblplS3BNb1N1alNy?=
 =?utf-8?B?aVpqK3hpdXFaQS9NTUlURG1pcDJMWDFGNkJyL2I0eDd2azFzaFpNTmpNMjJq?=
 =?utf-8?B?anRpcHJyL1o0aFJvOUpGUHlZTjhJN0dsTzFaemRpbzU1dVhQNDNTSk9XWGo1?=
 =?utf-8?B?cklDanl5SHpTcC80Q3U0aE83dnN2Q1V0OVJENGpackVweXNPYXRzSEdsS1Ix?=
 =?utf-8?B?Sy93QzkzZnBKQTY5N1QxZTdqUGh4QisrekRpWkltY3hkdXpIL3RaUHgwaElE?=
 =?utf-8?B?K3V4cWpGSkh1Q0Y5cG1aWEtscUxCM0c2TjBSUldRRkN6dU52cFkzY1hTUTQz?=
 =?utf-8?B?cW9XY1hiZVJzS202VzBvcm5LcHgwOW50dkxYVDM4ODJGZU92cFNVdnJjZFcz?=
 =?utf-8?B?N0NXdWIzQW8zSjNzeC9FbzlCQW5GMEF3Tm1PeGxlalROVjJsY21scXhETkI3?=
 =?utf-8?B?RG1xQ002dlB3bUxoRTRYWnlkZWZ6SU9aRlRSdE1ReExkUEwrNFJGNWpWdzZN?=
 =?utf-8?B?WGoxc3MybGkxek5UYWk4NTRsMzdPTnd6UVhtY3o2TVdPN29qVjFweTFlQVdn?=
 =?utf-8?B?U0ZXK3dtU0ZKUlAzdUNpL2N0ZXJBZFlGeGhHSFBnV3BjVDcyTDVJSEgwekNp?=
 =?utf-8?B?ai9vSTVSYW04OVpCRWNhU0kxa3ExeTJjMFdyR1IrQjJJaEZ2dk9zNzNZOWRL?=
 =?utf-8?B?MEVqbDNQSjJLcXV1VFlPY29UTTR2WTRHN3ZIQUIrR21tVjRaNjY3RmEvQlNQ?=
 =?utf-8?B?bVBBSnVzS29rNVpEYU56bnRMcWdGSG42NlM1akRKUWc3UXJGemZ2Q2czM0px?=
 =?utf-8?B?MEV5NytISEg3ZFlQS2NibVZGSk5BTVJlZGZGL0wzQkdVWEUrcWwxQk82U1FV?=
 =?utf-8?B?S010RksrbXFvcVFUNFJ5Z0QvSk12clJ3WEhBc29QVk9SOGpYbHIyNVFrNDFv?=
 =?utf-8?B?NXRuWER0bW9ZVTR0QzJSaEIzUEdtemJiTDlTOC9ZaWlQWHhEVkVwUUdaUE1J?=
 =?utf-8?B?YnpSa0tOOERiZzhuNzVON0FzQ2hIMTkvTzRkQmhWUTBYWWZnWDh2VEpMTHAy?=
 =?utf-8?B?aFdYRzJmUXlDWnB5ZzhCbGVFRVFDbE1TZko5YmxhOUlOL0dEaFJ3KytXbUds?=
 =?utf-8?B?eEZBSWlGWmgySEpaWVZIejhiMlNpRGJsU0VCN05sTzAwQ0NwdXNFQ2h5MnJZ?=
 =?utf-8?B?SnUxVk1KSVlLODJiRjNQQlRTS0EwVkVpa2VIU1NVYzhvS0pidTZsak5LTUFj?=
 =?utf-8?B?UjErczRwaDFNb1NldGVVVWZFQ3IwRFBQTzJSbDFEOWNubHF1MUlodnhrRElt?=
 =?utf-8?B?V0lFQUtJQUFKVFNsZmZidk9VVEhwYkwwQ0ozR05OTUo4UFRsYkxXSWovekV2?=
 =?utf-8?Q?JAOh7V0uCIO7R?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0JvZzM4eHoyUnhQTmlmeGZ5ZDcxQXY0SDNpd1NqbDc2eWwzTkh5U1grWTRO?=
 =?utf-8?B?c0R6QWlFZjhVRVo0MG10akVtNUVpdGZCVS8zN1c0T2RTRTdSZWUzQ2lDdGxr?=
 =?utf-8?B?eTQ2MDRlMFo4aStJMWg3RVRJOHgzUkdpYmQwUkJabjZNeUs1cXc3blQzUVpq?=
 =?utf-8?B?Ri8rM0NzQmxKNCtPVS8wNHdvOVllMTZUZkE0WjRncXZQaTNhY0hvQVJFVEpw?=
 =?utf-8?B?TWtPODNBUEtSak1iUk9HUmx2dUpWZVdlMUdoRENZUVdJc004blc5WnVRWVN6?=
 =?utf-8?B?bGFFdUtETTVubGJOcTh2Y1dDL0RpR1VmaUQ0M1dHcytEVk54M0NpVDNRTmti?=
 =?utf-8?B?aHFjdlRsRDB3VHlaVWVWYmFPblZ4Q2FseDBUbXg1S0c3RHVKQjc2TkdnemdW?=
 =?utf-8?B?cGI2NjV0elhFRUEya09XenFXQndPYllQWGFDMWJpMDBVUjQ5amx3UFl0dFlo?=
 =?utf-8?B?NUE1cCtObGNBajc4MDZYT3d5dG1zWVRzV3BaM3o4QjNCS0oyNnBCbXBFMzVn?=
 =?utf-8?B?Ri9wUkc0SU5ZWVk1YXZPT24xZTRINFhGd2ViWkpJaFB6ZVlLZm5uVnRHVDY0?=
 =?utf-8?B?UTlwcHI0eWwwaGh0TnQ3MnJiV3BLcjZMSW9YOTFLTWdiTDE2OFdSMzN0WGRk?=
 =?utf-8?B?cjl1UTRvMzRBN0M4UWZyTjJFc3lrMTlyNTJ6MGVPaVN2SVNVd3VWYXdFVUlG?=
 =?utf-8?B?aElCeXVmWkIzSnZ0Ym4vUURkVWlReUpBY1VXa0xnbW5OZkNLY2xxSG5ic09Q?=
 =?utf-8?B?L293TDUyaVloQkVLNmZoYmNMOHZqQ1hYTkpFWElHclRWKzZ1R3l1czUxQ3Z4?=
 =?utf-8?B?YUhvNEhpaWYxUko5UlMrbSt3TFBQUDFUMms4Z3hBMHRUejdsOTViUUZuUHNW?=
 =?utf-8?B?QkxDbURiZ2hobFloS0RITlkySGdNbGp6MTNTVEwybHQwOE9QSktqUjVFWFNX?=
 =?utf-8?B?RkxENjZ4SGVreFNlMTArcHlYQVZjN2gwSWlXbngzQThpVVRXZnllZGRKQXIr?=
 =?utf-8?B?WXVqQmpkaUNsNTJDNlU5ZmZrRG5JajNKdFZjdmUzQnUrWWhlMkdRR0hhQWto?=
 =?utf-8?B?b09SZ2VxVGZDMC8vNTk2NXhYRU9jekR5dVlnc0hOZHlTa0RtcThIM1loTWdS?=
 =?utf-8?B?UUkyVlJoU3pqUW51QWRWbHZieW1yM0x5Y0psZXozMlZNTmdoMlZlb2ZiejVs?=
 =?utf-8?B?ZVArT2tEK1U0MkxUc0hFejRqdHdHSTROdlhETTZjOGk1d0dGSlUwUFcyQnhK?=
 =?utf-8?B?STFmdlhVNFFyTVNtU0NvWk5VeUNWcEF1dGNNTU9rVGU3aWR1UDNxVmdCNVF5?=
 =?utf-8?B?WTlIRklLMXR3MWNvREJkMm5ScWxCa1dIOWZJYVRWZTJHeGJyVlBNdytyTHQr?=
 =?utf-8?B?aENkeUIxSXZieHpaM0kvYjZwWVVFOFJDb294dk9ZK2RCQ3YrSWNCZGtpTHdv?=
 =?utf-8?B?a0ZNNUd5MWY3eTZmVTlHNlJjd01HT2pHVko4MTRpK1JQZ2FkNml6MUlyRDIz?=
 =?utf-8?B?cm00S3dHNGNJT0tnN05pdi95dnJmWjZDZTNRWGoxZ2pXZGJibmdmQnphM1ZH?=
 =?utf-8?B?V2grekw0bXp1cjRvNEJVQmduN2ppSGVXU1ROT0YrVG1OWHFscVMvYVN1V05z?=
 =?utf-8?B?ek1YOTFIOUJiYTRFWGx4bzd3eHNUMW5yTjk0Ty96cGFXSTlhMTJSbzEwTTd4?=
 =?utf-8?B?NEY4K08wRzRwSHFvV3VOR3pVdkw1RHhNN2dGbDE3Zi9zbVFMSHdaQXM3SEVs?=
 =?utf-8?B?RzF0S0IraFBuR3JhTmJKbEh1U2xmVlV0WHR5em1YekozTXBwRGVsWnljTERV?=
 =?utf-8?B?M1EyVXN4cWRDWHlGeGdFMkcvVTVJRGxnYk8yUjh1aGVGS0x5YTVxMUlWOXFN?=
 =?utf-8?B?Um4wZUNxQU04czlYdEh5SmtXSUh5NzROUElGUkdXbUJibEVNZktvcytQRnZk?=
 =?utf-8?B?dW9YbUlWTEV0SSsrMHFBeGdGVXJZeDUyTitBaFg4TnJTUnR3NE9JaTlFTjVU?=
 =?utf-8?B?NkxWQVR2Q3lxaDdHUWNQR1JXYlFRd2ZiZU4ybUNJWmJBeWcvL2R2ZHRaVjlq?=
 =?utf-8?B?dUN1L212ZDR4T0tzUTVPMVNsM2IycWo3M3ZveHRodWIvOFg3eWxqQW4wTUE2?=
 =?utf-8?B?OGhTbWV5aWxSdEl0SWJhNjZpV2toc1NMSDNpaHFVc2JQWWdFNzN1aS9ORTVp?=
 =?utf-8?B?emdoampEZlk4S2p3ZWJtaXJDeFBoazNBSzdqbERSdTRaRlR5VWlKaGdCRzVH?=
 =?utf-8?B?eExUZ3liQmdoMFF0bXhYVm9hQ29nPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdce68b0-a8fd-4b1e-624a-08dd55304bc5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 00:06:47.8242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DgwSXVWZ9uWyoOUTQsxdC881bGf7LW0hEBriT35SdUFGYJaEk/CEW9Y++Ktv8HJFESxO56lN8fx/LmZDPu1pZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFCB4F033D6


On 25/02/2025 00:03, Jon Hunter wrote:
> On Mon, 24 Feb 2025 15:33:19 +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.12.17 release.
>> There are 154 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 26 Feb 2025 14:25:29 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.17-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v6.12:
>      10 builds:	10 pass, 0 fail
>      32 boots:	26 pass, 6 fail
>      72 tests:	64 pass, 8 fail
> 
> Linux version:	6.12.17-rc1-g497e403c6ee0
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                  tegra20-ventana, tegra210-p2371-2180,
>                  tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Boot failures:	tegra124-jetson-tk1, tegra210-p2371-2180,
>                  tegra30-cardhu-a04
> 
> Test failures:	tegra20-ventana: devices
>                  tegra20-ventana: tegra-audio-boot-sanity.sh
>                  tegra210-p3450-0000: devices
>                  tegra210-p3450-0000: mmc-dd-urandom.sh


I am seeing some gpio related failures ...

[    2.524869] gpiochip_add_data_with_key: GPIOs 0..255 (tegra-gpio) failed to register, -22
[    2.533066] tegra-gpio 6000d000.gpio: probe with driver tegra-gpio failed with error -22

So I am wondering if this is the same issue Mark reported?

Jon

-- 
nvpublic


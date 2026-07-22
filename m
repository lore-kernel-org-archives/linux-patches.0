Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010014.outbound.protection.outlook.com [52.101.56.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949FB3385A1
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 13:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784726109; cv=fail; b=BcUKF8piqWcUITR9jHZn/Stp04FLTq7e7dxjm4UI9jg/3zX+7poRsWSzjHEjaaq7Wi08Q1afjdCade0JH/e5E/YJf103Nq2hKyrilyxrTDncvJ50HWBXnYNJ7/1qHBw7v+/fQsUgwKFOSv674SNm0G9mc8l86WMDO6/jwSU2jak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784726109; c=relaxed/simple;
	bh=I5AkPETrBD0W5pa5fuZ/T25af3QjBDa2xSTJLNEmwx8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PQY+e8Bfg9FDKBE5aueLG9/0X2zKj5QKp+hNUpsmXBpCivwgjtaV8CGrHEN6x+3thzqlnqBVmv9gBe6UZzS80kBVfTwvzzDa8S1gPMhRfut7MTL9fcpqBoGGlvUN8PNqr5wcuhTYWmGz2Nf4bwIjGsrE5X5aACvCrJUf8FMAheA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HRcdY37h; arc=fail smtp.client-ip=52.101.56.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HRcdY37h"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jho/k/i3THGU2aTspQ13rLXIZ6Ukuo9zzgrg900lPo6cKijgEKSh6M8Use04yZi1hFpzLjbvZufGzJ+L+adc7aYPG8RzaWORbJ2jk1cyxVAvqoj2pULfCKC7vmDXFk/LDhJh0ArW4vccWBQV12LMknmq5CrYmFaS9evkXrqMZvFgJQELu7t0V35xFaE3Y4ytHiPXdcKmNNyzWd/AwhE+ldoisJQDOPNIch9zEN9xOuW6farL3RuIq/LN6B7TqQ3hiZm3yY4DrgJlOjiAFqy++m6By5Y2zCIyCtkMOHC1YLQG6sKr+LnQks2SJS4sseEULVsiMtXKmXR0OsTacNGxpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h0gccLhPgIqfPOSpu4QdRctykMRXk+hikRNfecVk384=;
 b=bH3TapGDfIPX2x4ji+/aO6foGSX4MSGawe9Zmx5pu1fMvK0OWI2UdpHzmGag1uhyCPhIsdV6204txIJ/yyw7DQ56+qtu4WbAiUdUervIKBAhBHosfqe9O9+YROin8fcFcFg03pQ504Ho++qhq/c9fUB7sm7w87FHd8j1wHUO2lGQoeswqxPheJb50yKMUBNPZmV+o2XcbYSBfbQvc9mOlbPYIOnG14Gblrrk9kcg6zUgfX5ud9c0eZ5oIrluW19PvJz0+oZ1GnIs31KUy3MrD9CUyURENafRf4UUUe0XffK4XXZ9KtrME+FgRxxkuBB99iwYBDxSF1BQZLKtwTr6tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h0gccLhPgIqfPOSpu4QdRctykMRXk+hikRNfecVk384=;
 b=HRcdY37h1xUVMEWNdYqeRgB4vAS1y9h6KFTdcfQEfp4+nylUUn2Tq2KA5zuG2pANy3k6bXHDv6CeXoDlBIr5oZLBWPGsmn0Q1fDF/9dRpZW+KrZVuAu4umbLRJjBRUlVJf5IglumwCA/QeDp50jjRKGiL6I0Zs75t/0FRxgHuB+VIyokjYvCWozgv28lOlyT11thvx4xifHZU00kjLleY/1u0zeewmisiRhA9Eq20Asr5V9vYhdmNYi4g0eJIGwi7UfuODJRptyXRZljEb0f08gwKI3azqnTbnc3oy9VhaIIaYexzXJn6IXTdfu6VlbKQWSaNCXm1d7Xtw8o+mRBSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6051.namprd12.prod.outlook.com (2603:10b6:a03:48a::18)
 by PH0PR12MB8175.namprd12.prod.outlook.com (2603:10b6:510:291::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 13:15:00 +0000
Received: from SJ1PR12MB6051.namprd12.prod.outlook.com
 ([fe80::96e1:b300:7b78:d3a9]) by SJ1PR12MB6051.namprd12.prod.outlook.com
 ([fe80::96e1:b300:7b78:d3a9%4]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 13:15:00 +0000
Message-ID: <ecc491e1-6f06-4c7d-b7fc-099713c99a1c@nvidia.com>
Date: Wed, 22 Jul 2026 14:14:53 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 0000/2077] 7.1.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com, linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20260721152552.646164743@linuxfoundation.org>
 <4dbf52af-61a2-4767-8c85-b358cc157812@rnnvmail201.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <4dbf52af-61a2-4767-8c85-b358cc157812@rnnvmail201.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0247.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f5::10) To SJ1PR12MB6051.namprd12.prod.outlook.com
 (2603:10b6:a03:48a::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6051:EE_|PH0PR12MB8175:EE_
X-MS-Office365-Filtering-Correlation-Id: e144e939-ff6d-4ac8-53b8-08dee7f33bf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|10070799003|7416014|376014|1800799024|56012099006|4143699003|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	wfs9ruPcqmLfitERc6IVfo01X5CRd8eJVosL/IdokDGT1W43zNpSKDNcuH5h8CgvI0hfOsp29UdWRvU3HgemL/Jt+Me/wLBmcq4HalR4Km8ujoL5K6EkaibZ+iJk3TClRFmeNBc2YXyan424DEugQm+ew4XrcXK4NQN/CkPqoh8VbcYcPPvD9F6GjeWZnGasY1NM2pJ/qJAnaybRFsORcAxR3a0+15TLDNFW/9aFwrKAMM38gpDyZBaCukMELgUd9C0SGrZEkhgmf2QnTAuI73pFxsJn/q+hZkBNSTy9PJUM8ZMBE/Vkv9VZfSi9J1ZvwJeWfcXWsxEX59VWVAxZrLe0vP+Od2ZW5nsAGl2pCg9/nt3JPIizY/QAFtkICuP21bxRgwabL1tAv7IOOLfiYdy7kc7OC1C8ICA6RS0RvJJsisdn7S8Fk4+86zsu/Vhy4Wr6TW2vymR6/EbAcu5RHQic5AoSp3RcBEgkQZXnyu6n5vwc2TQ7qUV9cGigRe+sheCtNhH8ijIgdsOJvwNSGq8vyncB+XkZDLQy4VaCnW8BTmIa2SN9sYz+lyuov09L8mJmly7GLMFa1enwrIZ4FNB8qi+4VCO8ajV72kwiaaAubhBqujlb6F5Ezs4XeWrsbDDu/sEqK1n3iLUh0t7cQMVg2DZc93RcUov0rHval9U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6051.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(10070799003)(7416014)(376014)(1800799024)(56012099006)(4143699003)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?by9MK0h3YXBueGJ0ZXFsZ2h2ek5OQU1BZUF3bTJEbHJiZXk4RUMwNWJrYjYz?=
 =?utf-8?B?aTFDZFdsMEZWV0xnVXF5czZqdUdYa3FYaElxUks4cHc1aUlLUzV1MFdYSGNN?=
 =?utf-8?B?UndnS2ZUSGo5Z0JGVGlKVXE5QUxGTkZqd2pkWjZIQlNFY2VXQjFURCtzYmlE?=
 =?utf-8?B?blgrdllMVzRaTldmYUJXQytMcUR6SHYybDdXUDZNVVZMSnZIWFhvb296M2hv?=
 =?utf-8?B?dkV4V2NFZlA4aW1LVWEzb0oxbHNkTE0zdkczNUtEZXhKTkhuN094Q0I2UVFs?=
 =?utf-8?B?UWVYaU1BQldmckRESHBkK08vdzZCNFMyamhrSUxyN0t5eFJtZ3h4Z0JVbUZx?=
 =?utf-8?B?SEVHM1dxRFh5TitTTUw2cTJEdDdHK3FTWlQzVW5HVWJXMzRUYnNZdTZiL0NW?=
 =?utf-8?B?QXk4a3l4cVd2c1U0VndjN1hjeFZLNTJBYitjOHNnOFNaTHVRRGhhYjZUbFpW?=
 =?utf-8?B?U2xqOTI3NkJRQUY3T3JDd0YxQllrMjRRZ1hEaUdCUUtpS0hSWEh5REhoZU1V?=
 =?utf-8?B?N1BMREdhRmY4eFJSZ3FZRDBSWVdjcnpENWo5VVR1S0RlT2RYMjFMcWFCcFVq?=
 =?utf-8?B?TVNRRlhHTG16UlpnYXhJejlITHFLM2xMWmlpR3RpQVNBNTB1TjBqQS9CVVV3?=
 =?utf-8?B?djBCU1VxeGZFcEFFNTgzbStLVU5NMGNOOTltTVVPZXVJNU1sTGZoaS9TVFhR?=
 =?utf-8?B?ZGtWQ1FLeDFrMWpVNlhJN2dSYTl4aEdUMXBjU0RVSzBucFF3Ukx4NS9odG5D?=
 =?utf-8?B?WFE2c1dzSTFjRHNzcmFjS2hyK1dJLzVodXE3UlhHM21DM2ZhUHVPVzh0UG5a?=
 =?utf-8?B?VlQyWkpzVkp0aDV4aEYrRHRyNnhidFhWRFUvSWVXbmNhZjYvMnJlMWwxL2M5?=
 =?utf-8?B?Zm40UWJ2Ym5ZWkJjQVk3MlpaV1dDSVFKNUZwMkozdC8xUFhsY2JxRlhLZTln?=
 =?utf-8?B?RS9yRW9TRFBVTzRGR0M4OFh5M3gxMTR0OW1PNmU2MHlRSTE3cEJLUFpsL1ps?=
 =?utf-8?B?VmNpYzVVZ0xrc25VaStteDdBWE0xWU9oTlVqWHBTNXdUUFpmLzhZV083NXdv?=
 =?utf-8?B?RWwwaXljbHQxOGJOcGQvM3AwcmtaKzJWV0c4WXdCNkdPN25vZVp4VEp2ak9Z?=
 =?utf-8?B?dmFWM096VTA5Mi9GQXlMdEdyQWhFeng3ZVZUU04vdEhkMldJRjJZdVhCSmJU?=
 =?utf-8?B?eDUyNG5lSWNSVWV2UEk4SlA2UFN5SkUwNThiWEdzOVdiTE9oU3Z5YjgwaW01?=
 =?utf-8?B?bE1oQUNUWmh0eldKUld0V2hEaVI4NHkwUFZuUUJNMEo3RkM5V0U2Y1V1WmQx?=
 =?utf-8?B?cGgxSk5GZlVyQzh2d2ZvQjV0U09vZ2pQZVozSTFac0RRbjZYeko3V091Vmcy?=
 =?utf-8?B?NVljWmZ2WVJoTVVPZVM3V2FmS0dGa3g0Q1BNQUlmMDdpdVBrVjQ0MG1EakN3?=
 =?utf-8?B?MDE4L3NwVm1oTVNvandWZnJtTEVsRy9BVXd4Y1dzU2RRU2hiRXUxVVVVOFNY?=
 =?utf-8?B?a0ptcEVQRDhzaU9seGR1dzZMTXIxSzU0bDRtOVplaUljd04vWHhmNTVVbnZt?=
 =?utf-8?B?NFJZZkNKeWpoaXRhTlZrSXpGa2xYL0s1L2ZJaXdQMHgzZkNXNlp6cFltNlE1?=
 =?utf-8?B?aFoxdElUM0l5SFNxWThoVHYwZnAwb0FJV0IxaE5tcjlwKzdqbXVFR0JNVGNI?=
 =?utf-8?B?TTArVGZnQk5zYmYvT2NEOHo0dTh6Z1h5eHNXMFJtQ0hKaWhmYUlML2FXSzlI?=
 =?utf-8?B?SGpkRzkwNXZxY0pJa0ZrVi9zd2Y5VDdUNFpzaUlxUTVkM0xtWEpsdDAvTlJy?=
 =?utf-8?B?L1FiTzJtcjArSHNtL0RGQXQvZGxEYWpLejhsM2hTR0hlclp6ekFoaFhMaUtz?=
 =?utf-8?B?bm5yK0dJVGloZCtjL1lzNTI3MlVreG1TOEYzMFBMQlRIRzBHT3pHS2I2TWRQ?=
 =?utf-8?B?YXd4cFF0bURqZGFxdkg0RVRIa0NNWGJJakVyNjcwMmZGWmQrZmNseit1dmdD?=
 =?utf-8?B?UDhZQnI5ek1rbFB1UUxmUUNBT1dQZXFEOHhyWExxdlJFN3RhYStjUzR5VE1P?=
 =?utf-8?B?bjM5eDFidXFhV0RreHhvbWRnUUgzZEdKcEJDQnZhbUdLOVNlYnM4QUU3TXhv?=
 =?utf-8?B?UTF5cDBUT0VZQzFHcDAvUDVUTkc2MXJraDFqckdKa0xNa3lNNnhBNmNBSGNl?=
 =?utf-8?B?ZE5WS2N4K01NRUducXRreE1zTzJITXZKTWZRWG9qRHpQMGdXRXVwUnNRRmpL?=
 =?utf-8?B?SENKYmpsZkE1Y2ZCLytPb2tFQlV5MkxLOUZaOXZqQ2UxNGlUdC8vZXkzTVo4?=
 =?utf-8?B?aXR1TVNkWk9jT2VqS3dCUFhQOVU0eGthR28zWVBNUi9zZi9oUXR2T25uclg0?=
 =?utf-8?Q?+wtOgpa2YBQxJgNeuhUlYmAgLRu7JpMjC3BcXIX5ETXhK?=
X-MS-Exchange-AntiSpam-MessageData-1: SJ71Ztv7k9CJcw==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e144e939-ff6d-4ac8-53b8-08dee7f33bf5
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6051.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 13:15:00.5278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OPwtL7tPqygOXIaN4uelQHugMiLzUrgK/Fm9CLHja6Lc9r+wCrGt+jgV3yBlEfkQQqwwvwQ70aNRWOEa4cRieA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8175


On 22/07/2026 14:13, Jon Hunter wrote:
> On Tue, 21 Jul 2026 16:54:33 +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 7.1.5 release.
>> There are 2077 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.5-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v7.1:
>      10 builds:	10 pass, 0 fail
>      28 boots:	28 pass, 0 fail
>      158 tests:	158 pass, 0 fail
> 
> Linux version:	7.1.5-rc1-g06ed1e6c413d
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>                  tegra210-p2371-2180, tegra210-p3450-0000,
>                  tegra234-p3737-0000+p3701-0000,
>                  tegra234-p3768-0000+p3767-0005, tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Ignore this duplicate report.

Jon

-- 
nvpublic


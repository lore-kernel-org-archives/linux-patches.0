Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012023.outbound.protection.outlook.com [52.101.53.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D871F377007
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 14:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789050883; cv=fail; b=scNGhKblOv5d5ZdlFkgX93Bc4Gr6mnRqJJmbEmJ3if0RHsC4K0oWQWgTKvad8y/IFl5XE8YlehKaX3d9oq0IfLRe/jCe4SYTEXvzy/Yyd2ECzpRE39lwRGymoDlWjeFhxoA3wU+E7rgoaX5leTMezy+ckPNDMWLR8cFHMxY8fD0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789050883; c=relaxed/simple;
	bh=XIx6TbxtpMGh9kkvh1hAKtshdIJNPk4eTPeE02G5BAI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gGrVIcx9YMcWAyFYVF7NdWNMrwmJ5TOCGdmmPWXnXHvs+aiBWQMdYHxf9o0jMJgs2MBJdkQ606/gKdck7SL4pDkALdlSulCAwoYw42Xg7wdmbARUg4LfS0AxSpuDOWgyFW78QNHJq1oPa845ZmrtLOnvuxRFW5v/7SQydoAE2WI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Z4t00QGf; arc=fail smtp.client-ip=52.101.53.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Z4t00QGf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C+p1dcO8XjtZDpkLyjdYtYNSYyQgHH3MOqddV0kLtujAJiervM7DfNze5nThr1LPUyJCMbZvHg2nZtiszm4tkZVEHKGGeR058fa9hBNj70/Olf89ZtrCISFOITvxdNvFkLO0Eq4VU/GGfX1En8DCb1iGJ9I68BhM5IFs3bc6d4p+hbftxQ3pbo3IAKoRGo6UPLaiCH5vbjlsYG3C5u2VbZGMc/BWNReJJjSJPTennGh6uNvcKQ1ahY3DDARJVavxNFkDEE3HengM8Ow8LN2/feNEVGc6oz/1dt7116rWJxNuHuB7yBBCx6BKO2WRpsYYAuKQmeCuX+XW5qXf7XUL9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4wtY71bicITKpkMiU04qNpycRFQshXovprDsr7N/L8s=;
 b=O/kEZ1lSl996wb/p9H74zS0Yv59nxQfcPO6ciJKln7oqJ6rrF5foNmvyLy38SWayhldL2mokP70FPjHaHdILtoD+ipv/l034MoOcdTnXbmW/krdymmTPwpKgOxicbDOqYEqRLJ3eQS2pXV78VoFRsPYsaVBD6M5jM06BEiAxRB0RDgy3yddv2g2RVW5NKNqJB8D2Xw+BaX4iGkYEtnI4tXc3NXxufev8X0Q9kAnQ77MFKz/bXO980yQhdS1I/OlpPAm7Dx6xOV33hdZ4IAjk+2DDKPjL0G6hY22R5+lhldwoCNGLvoUnYA8x5OCuVvEILiPf8xWoV2br9kD6gFGW5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wtY71bicITKpkMiU04qNpycRFQshXovprDsr7N/L8s=;
 b=Z4t00QGf5IcnzYe6sNfAox+yyWci97RRonIflCtP/3uDLQcurDY9LgOmK+a68FTsrOKdIn8/7/KPBjnw1/uy8+y2pKw8qT9y0zSuIua9I6ZVp5Lc8NqySWDhZYgdlNgJ/LWGj/1/2Y4wdQOrmuP3Plo3Rc7FkR8QXrRJRWuNNKzjpVbuN+fqc66b/y4gL0jWKf0NA7vSAQd9NrNeg6HwUUbY3RTwVRp3CwagLDcj2DWXniZBsAgbAlT4zfdgx6cSLNz1cwUeRpOA+TAZzs0tVC9eofsXiJxcMNH3kNF4ap4xf1ZPtVNIRV1eli9rZqJKfFyO7ilCSFLJ++iZkkvD0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6051.namprd12.prod.outlook.com (2603:10b6:a03:48a::18)
 by DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 14:34:32 +0000
Received: from SJ1PR12MB6051.namprd12.prod.outlook.com
 ([fe80::96e1:b300:7b78:d3a9]) by SJ1PR12MB6051.namprd12.prod.outlook.com
 ([fe80::96e1:b300:7b78:d3a9%6]) with mapi id 15.21.0382.014; Thu, 10 Sep 2026
 14:34:32 +0000
Message-ID: <c3fa7e6e-e736-4560-9477-88cfb6c56332@nvidia.com>
Date: Thu, 10 Sep 2026 15:34:24 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/583] 6.18.51-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260909134237.773280130@linuxfoundation.org>
 <e976263f-5382-4e32-a3a6-5639c4d56abf@nvidia.com>
 <2026091059-smudgy-boogieman-5af3@gregkh>
Content-Language: en-US
From: Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <2026091059-smudgy-boogieman-5af3@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P195CA0041.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:65a::13) To SJ1PR12MB6051.namprd12.prod.outlook.com
 (2603:10b6:a03:48a::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6051:EE_|DS0PR12MB6486:EE_
X-MS-Office365-Filtering-Correlation-Id: a3291c9c-ed09-42cc-40b5-08df0f48a122
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|10067099003|22082099003|18002099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	j6TCt55Z0KWXdekFpJrx++NiWbAm+IZITidv0L2kOU5E3317V5KmLqKKk0HckJvK7sd0McEB+zUKlvRx8dPLcw190AIq16kb5YGo+fd+w02cZkdyrU9XPUmoAfAGV6xcbBhBMHBSPccS6PTma7WXo2tdHJra7x0n2SA0IA69F1CCYluOC4FpEFVC3alZAYN5GMcahwZA54V0ZGeBSKJdZxtrYeJR7Xpa831Gn4XFSEtyB1+BYZkxUSXsTY5chDWFn8wCWn4QYguHaU48IsBCQDP8TemCEqSwGNaLLlHOqbLCmnISAHNodchONSx49jGz30SFkusI2mu/+7J6rx3aUVMX+QjWhZCbLoo8KHoBou3bEtVvyDgKT6RPHqt484mAiXNiJVqg71hi5F6OZyOKGFQDO11522grSqUjrMxZQgqAtHJu2l8WSAx8UTl+uZUcpITZA17AcOiZhMUVxTvorTEtcGQrzj/2aYAs3oWxEXe6sqymys2SNBD/YVw+T39h5vqR8l/y+jTn3uiZ3SFxzQwmvNiHmMQxKs66p9mSpbGzKWvMeb3ZPKeJEH3FG2cM2awt1BOi2mqBocPigkTX1+1LrEBz7l9vMok5hIrz575hoLq9TjYD7+vy1P0ZiiM0+n1W3fcgOJ+8bl8q4oOd5UF44eWylREhqCGVITV87ic=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6051.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(10067099003)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cm9ucnI1d2s0TTZXRlNYaGFuQ0EzNGlWSmtHZWVkT29HRU5qNVZHMFN1S2pL?=
 =?utf-8?B?YlFLczhhY1ZmT0Q3ZUtkWHpzMEkrYWRxd2NHbk9FYWRpczJtazZibVRpUkpi?=
 =?utf-8?B?bkFiR1g4U2U0UkovaVlPcFMxbE9BbC9nZzNyaUxZeEdRM1UvdGZROXZ2SGpU?=
 =?utf-8?B?c3RlOTR3Q0dEYUdCdDJ2VWZZOFhRWnAxbEVXOWc4cEtOWTVHcTdXNE1FNUlq?=
 =?utf-8?B?MGkyeDlGcTJiNzloa1BqaWdDNlJCWnRFejYzRE9qc0NIUDJVY2dpc2M2YWFR?=
 =?utf-8?B?SVNYV0Z6WDV1V3AwUnQrMmUvR1RaaTl3bjhkY08rdGxwbU4zQ0dURGlZaEx5?=
 =?utf-8?B?MVBseU5ZK2x1cFRWQkp0M0llSEl6NXRrUi85TDZqSUxGaHlTTzRzWi93a1d1?=
 =?utf-8?B?Z1BlaDJkN21kemNkdjBiZ2w4SVBXZm0zRWdsNytvUUF1K3BQVEF1dnVheU4r?=
 =?utf-8?B?aDZhYy9JalA4UFc4bjZRMDBwZnNvOW93TFJ2WGxyRFVxSVZiTTMrUzdlQ3JQ?=
 =?utf-8?B?eFo2WXVYOGlIYWhxMXdyN0dvUWZscDNTRzJNaU1xT1h6ZXh1ZmdWc25PU3Bi?=
 =?utf-8?B?R3RDUlpDRWtnMmRBZjlicHFZRjNoei9sdkxOZXAyZlNIUFBXL1F4T0tLR2JE?=
 =?utf-8?B?WllaUHZuVkFlRlNqblo3TlJtY00wcStDTGNzMHUxb1kwZVF5VmxzbStSMG9W?=
 =?utf-8?B?c1pqTUVwcHkwQWJGRFExRjdvSkxVbDZMSzg5a3pMdDJmNUFDYmVLRG9CbGRC?=
 =?utf-8?B?V2xhcDFuTzdzaldQb0lzdGEydDgwQ0xFcm44QjhzMUxibHI3aUhUUDlJNEtz?=
 =?utf-8?B?YTUzU0Z1Y0hSaUF5RUZ2QVgwTThGZlM5UWdqTjdLRHZmVml1aWo3UFZZR1FL?=
 =?utf-8?B?V2w4OElVNThGOW1sQVU4ZGVEdXVDdU5DRUZsaDg3Rm5zdmUzSGxJUjlYbWxx?=
 =?utf-8?B?a0xQSjZnWXZJOEREd3hpMkZDdFNjVmNlUWU2Z0FobTlKakZIYXNoWHUzZ1Vq?=
 =?utf-8?B?c0p3eXdTd3dsTVpyMmNqejh6NXp2MTVNVDRqMEpmR2NnM0o2NnBUdUQ1VkJU?=
 =?utf-8?B?Mzk5L0JXR3NQbmR2dEl4Y0NYeWc1YUFDVFRTQjNUTTFNSW01U29zc0JuRlg5?=
 =?utf-8?B?RVdFYi92NTJhZnh3OFE1c2V0SWtxR0hQNWtKOWR5d2NrVnYybXpFK0VxS0dV?=
 =?utf-8?B?WkhpWWdkRlA1KzZabVVxdzI2ZHZiczMyMUFTeTlGOFg1bDk1eVVTaUZJNUpu?=
 =?utf-8?B?MlZxQVJwL00wajZ6M0FGZi9nRm1hRjJvajdFK0cyVGJ4a1dKK0d1bVdMNTE3?=
 =?utf-8?B?QlF0K0o0RTloSk93Z0RwcDhLUHo3T1A1MWd6alRNRkdTd1N6QnNCQ0R3VlAz?=
 =?utf-8?B?Q3BGakw5OG84K1FIcDhHWFlnTXdSdTRPMGt0ZUo0bU5jSXh1QVB6aUxPV0Jm?=
 =?utf-8?B?bGlJcEhVTW5tM2tqUDM2VWN1Rmw0RGs1TENOWDJxY212ajl2aVJ1TGlrVDhl?=
 =?utf-8?B?N2ozVzNVTHBSRWdsem9sQjRJbUFmMjBWNmd3KzZYOWlzMDZsVmN4YzdtZHht?=
 =?utf-8?B?eFlWWHFWdU9rWDQxSW9lMWhVQ2Y2NHFwcFAycWJUTjM0bGJvVDAyODB4RkZ5?=
 =?utf-8?B?TWdEUFFNSjdkdmZRWmRrODZsMFJXQnltdGRBQkt3RWw5Sm5yY0xCa0Y5dlhL?=
 =?utf-8?B?R3dhSWpRWERWMDFFcXV1VE9YVFd4cm5Fd3FibUJXRGF0WkFRTVlSTzR5ei9R?=
 =?utf-8?B?TTB4dU9GeVJaVkNnbzlZVm1uOTMxc2J5eEhVQWJvVi9MbVV3b3duQkFDTUFs?=
 =?utf-8?B?OGRacUhuZWtFenNFMEtHaXNnQ1BpVnRWNG84T1FRWlduRWNvN3lreDI4c3lI?=
 =?utf-8?B?Ukk2Mk5CV0RWZ1RKeThSSFF3ejhqQkM1WFlNT1h0RzV5SE40SDBIV1FCb3hD?=
 =?utf-8?B?N0tYbXVqQk5tOWN5UjFWMllEaHUvNEZBTlBQQ28yaHNheGRFRmczcVcxcWN1?=
 =?utf-8?B?OXRIQWRDRFNhQklJT0RudHQycStvY0pwWUwvUHMyajBpdUg4bXJZbC9NeFBm?=
 =?utf-8?B?Y1lMdHpmQ1ZiWng5cG12RW1TOGV0TUVaMDlVQ0V6bFIyVDFKOVQ0REZlb3Nq?=
 =?utf-8?B?NFZwMG5XMVBWNEpvaWlwY0hMWmpCTU8wdzRWdjc5Tk9qREx5SGRDTGxOYlo3?=
 =?utf-8?B?TzBTLzFmZS9TdVpYeVVvS1RHb2plNUJZVUN1VUpJQ1JkZ1UxMzh2ckIxaDhs?=
 =?utf-8?B?eE4vWlVXenIray84QkUzRlE4Q2VqenZsQU1nSmdxdS9rNmgvYUxyamlpTXRp?=
 =?utf-8?B?QThRY2pOMGlSZ084eDl1Y0lmNDZ2VFF6T3JickpaMDVjaHhRZzludz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3291c9c-ed09-42cc-40b5-08df0f48a122
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6051.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 14:34:32.6371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HYyRtre/TyI9mMUnk0yzwpJt/xpdgFpYsxlUaM8ui/dP6pCSm/lMlDO5099bRjMveXz+GHu51Ihlr8Pw6HqxHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6486


On 10/09/2026 07:12, Greg Kroah-Hartman wrote:

...

>> This tells me that there is some other dependency missing.
>> My intention was to only backport these for v7.2 because
>> audio is broken in that release for Tegra. Sorry if I screwed
>> up an fixes tags here.
>>
>> I see this is pulling in a bunch of other related patches, but
>> I am not sure if these should be pulled in either. Adding Peter
>> if he has any comments.
> 
> All of them had specific Fixes: tags on them, which I followed, are they
> incorrect?

No but there are some other fixes which are also needed ...

53dd1c1de851 ASoC: tegra: Fix the I2S enable default value
5442b8093a2f ASoC: tegra: Fix the MIXER enable default value

Sasha's review also caught the above. 
> I can drop all of the "sort the register table" patches if you want from
> all branches, just let me know.
Yes, I think that is best to drop them unless Peter thinks
otherwise.

Jon

-- 
nvpublic


Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010005.outbound.protection.outlook.com [52.101.193.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A0A3E49C2
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 11:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789300765; cv=fail; b=oa35l85qpiEr8JN7rvL1J4Uj1Mh6PcfWSlCEgL9BkHOT6E8W8eGpNqAM3DkjbG9N6ekAFcSN+vqelZrhnU+no5IFPXccXBro8IxqktQV2Lw17HqMS6afuo091cS8mQHIONmWPgerIuorWFcffctw8xFko7XhTeajnIy8cv6SokY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789300765; c=relaxed/simple;
	bh=3Sn/Pi5yJvbtDxDZ4eoLzSd6yUrmgN8Su+TrCTi2Eh0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=axXi6CYZuBxQmHPPdX0Sk371Hx4nAQtcDNOIbauJ9jNuyIw8MEQkD8S9smZgMLRuy2HH9bIRAkN6U6hDVMuWyoKJoRM1XKZSR6RgkwvXLOBxfmeK2Qa1uFxWWGnHyUbwm6UvnStEy+ep8RSW58o1mtbIJ6zrR6ihFRJ7IE0WULg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=K9c/tIDL; arc=fail smtp.client-ip=52.101.193.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K9c/tIDL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IA480vT4QbHhjzwNvf9Mi1jrJRQpKr9EXvgpwXe0d9UFA/Q6RAXXD57m0VAj5MvIYxfWQUveLWrkEvCLNs17izuEsiLCMBW3KQ6agT70cDXNG7N9npy3cuNDjnIoMoqEqbVpbSNNDdBCIVcQoHKMOuJ9mw7vpUiBpzq3XSL/FyMWaH0xWgunm5fLCVLqZv3OLBkGUN+4Rgq7OkJSuOWdpJpk79XiooNYisvYkRhfcTPoyeUEvnJBOCEoDpLZFF/IIvG1ITAspT2Hm7JWjziWFCu/RDk/KT4bQUZhloa8AEQh7SbAYmXCioK5NMkeOfZEDheX1IJjCBSIppSOcIAMVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TRLt3/3Bp/LXOZSnyNKYkFIDtJwRbw3eQkziDFltpo4=;
 b=As7fDIPWWJMcC8pbJDT83ta/x6v2dfOffFYSWTTVMQmU0KrkPWTSwg+65vR1gDFJkbaesz7Z1sikULLJbhspJ8esQXCowRZpUNJD89AVFd8O055VkLmS+R1t8jacWOYaqnBSyHB+d0+aZcLmaz3bxU9WfrGOTG2LOJjJF3EyapAzRkm1re7AS0LKcq5S6EmrenahP8Q2i1+0r6LQkYv1p5trIMeNW0NRxTdbIltckRQxGY39ZVk6P9G15MRvfSyoZVREdzhDbwZNGts2jl4cXdbFBjYrxORyUQ4OKRAJKZ8dDTnHmIhpWUh2uE8XMo+JzrZS2wqVPWOHAVNNuQ7A2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRLt3/3Bp/LXOZSnyNKYkFIDtJwRbw3eQkziDFltpo4=;
 b=K9c/tIDLPRTyryXgnLdNi5ivEzIymibm4WvjMlFL98ORq5fRuHzOjkZnYdrNVKkcb4DOmwrWb/CvFQL1b9Gl5grU9zv4u0LCUftjwn5SZPMOZP1xQhzA79YPFbQRTtnQ0WO42tldqCe0dXa/oSPvQfsHlsrFSPTMl7n9JiXWUzc+lHC8Yy7hljPmDvXyqfmKEZeiWBJHiJZrvh60xbDRqCsF7SniU0iYUGSci8jxYYfDgFgoyiMLAR5Xa0X23kuIAU8wB2VQqmIdEpR5tpqLpED2E1jpfY1lg8t/aMxmHA5AMn3JsInqH72vQ97/ku9SaeNvF8Y5J5GnGyrxP5jtng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH8PR12MB7110.namprd12.prod.outlook.com (2603:10b6:510:22e::11)
 by PH8PR12MB7230.namprd12.prod.outlook.com (2603:10b6:510:226::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.11; Sun, 13 Sep
 2026 11:59:18 +0000
Received: from PH8PR12MB7110.namprd12.prod.outlook.com
 ([fe80::736a:e1be:ec64:5740]) by PH8PR12MB7110.namprd12.prod.outlook.com
 ([fe80::736a:e1be:ec64:5740%6]) with mapi id 15.21.0406.007; Sun, 13 Sep 2026
 11:59:18 +0000
Message-ID: <f8e1fe51-03f1-4158-80cd-2b462624da3a@nvidia.com>
Date: Sun, 13 Sep 2026 12:59:10 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0000/1376] 6.12.110-rc1 review
To: Pavel Machek <pavel@nabladev.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260912065607.535295758@linuxfoundation.org>
 <aqWnzsSIMkyM46NV@duo.ucw.cz>
Content-Language: en-US
From: Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <aqWnzsSIMkyM46NV@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0096.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::9) To PH8PR12MB7110.namprd12.prod.outlook.com
 (2603:10b6:510:22e::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7110:EE_|PH8PR12MB7230:EE_
X-MS-Office365-Filtering-Correlation-Id: 47aa0a98-a641-42d1-1643-08df118e707c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|1800799024|23010399003|376014|7416014|10067099003|4143699003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	4b2Ui1unGGIeyrSTi8Ur7F5MRnZa0bTTckB30yqx00VYwVdOSE5YYVyuuQHjFO2Es1rSHi4QR83wRlAeE7MTlod+TGkRyCV0NT+rcym16e6VAehqg2bSm9CjgD7TvpRLsUtD/LA+2JepLnxTROTKeOIRAlQOD8KAmQ2TLttHtPTJlH3QWVIu2r6EhRAhoeleQPSZZNZXY1NVcOai1AXIKTqnz0mG6llWo1+vaMex1hNVruwSkeLr4VWgImRk6tiE27SKDahYrldkpcbrgV50mp4rIbTUfyn1oIdzw/JLSdpmJG1avzldS1LalzMHo57bGk6EGbYe0suv+WIB2gg/Aki9gVn/9JOhkd5DGlP30b6G/8/PwCKrCdiL+tDpBjhIESFUGRFQarxiRT7lu7nkE4fGpSqSy+zyiZTNgRvaN7om0AfIT8Rm6ZAFM6Xnpjs/nesLiWGnVBLkz8mpdEVwE7Bi9b/LEvb5XZYtmehzoXYZcK/VgfAG2IP2WNxlHG2rnKICFD1PoIvogOd/J16cWhV9hzV73aTvk+pBea7NuDumlwL19UwEJ3T2s//Eq4/6bXLPiqQ5UgF+acF7l6JUPhHDF/gfvBGWggV6VLLzwe1/uOxzy7esLaTO0uGYs1FqE9+5Ac6uefLWcfSSvOQAFN92wn7tuuEac1o2y2fLbBk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7110.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(23010399003)(376014)(7416014)(10067099003)(4143699003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1h0VnVjTGhYc0pFTTNNYUYwald3YURXdEgwSThwbnY5WjE4MVQyUlczZXpa?=
 =?utf-8?B?dWFVNTFkVDJBUzJKUmR4RTFMNDFnNEN3d3NJTVRYN1NoZVhxZWRZeTUwMitN?=
 =?utf-8?B?TTRwd3NESDNOcWR2blZ0Z3RCeXpRYkFXWVJKdDJVRVBZWWkyTDMzM1h2bzBD?=
 =?utf-8?B?ZlljSzJGQmdCWWZRV3ZOZzJ3M1FHeVlkTVM4ZUppZ3dMRnhpK3BKVGdJVTVl?=
 =?utf-8?B?TFQ0aHA4dWRzWEN1Z0czVmoyb0hpMTZMTlhBaEhhbHp4MzJROVN5Sk9pM1E4?=
 =?utf-8?B?SW5PTHIyU215T2xyRUVzVlYrS1hCSWhLemVhVG9IdDB6S0ltaFR2TFI3ekF1?=
 =?utf-8?B?OTJaY2kyZmFKSnpqTzA4Y1JaenBjNWk1OUEyeWlIU1RkQkpWakpMbXptWnlD?=
 =?utf-8?B?clpmdW8rUGxBdzc2SzZtSWgrbzBPa0tkN2p2Umttc2RDRUVad1YwMnhZRHNt?=
 =?utf-8?B?ZXNNeTc1K0wwWDRzQW92YXdCR0htc016STF6VWpXdDJQaDM2cStJVUZvYWtC?=
 =?utf-8?B?eGR0eWtQNHJ6czBqWVJwRmdXSmp1UWR3TWJ3S04zcm5mQnZ5Vm9xSk05SGxz?=
 =?utf-8?B?dzJmZ1NnN3lmT3FFZGpIRmowV3pmbUpreHZGK2gwd29WUE9VZ1o5a2I0MDFM?=
 =?utf-8?B?TDVjMUxHSVhMVHg0aXg5U0hYbXNvY3ZPTW9NVTVILzB1MVhwQzhXT1Z1RW94?=
 =?utf-8?B?eXUwZ211bzNXcm5JNXNMZFVYM1hyUmxLc0F2L2xpOWM4QmVZOHQvOHRtL3U5?=
 =?utf-8?B?YnpUNmRPdklGUXlRdTRGZi9oakx0NmlKRDRZV2VOcjhUK0dEM1NjR2tOVXAr?=
 =?utf-8?B?bjRjTDRBNEFWK0NOT0RnMGg4a3VrNUlrTEI5SVFkbGw0eUJ3NkJxL2hlSGRy?=
 =?utf-8?B?TjIwSXhScEI1RkFHOWwxUDlLQ2ZTckJEaSszdXRxaXhXcWhuVnJ6VUxBMklz?=
 =?utf-8?B?MGZiU2hKMXlMM3U3bjh3Y3dxR0p0Zm1rbWFqQzZIRHgyRTROeWdzaFlTUndm?=
 =?utf-8?B?U21SYmRiSklETDdVajlEemI4T3JGeFE4WVlQR1UvY1ZNR2tWczI5RE9lSnlL?=
 =?utf-8?B?ZFlDQ1N6YjlsbUxNSHJWL0JYcmJCMWUrRWEwdlBIa1QwN0pKczlOWjR6VWI2?=
 =?utf-8?B?R3RhblZ3OFdUbVB4bTBZMXpIUmtxc3c3NDFSWXpHYVlzUjEvUERWbW5wUHNZ?=
 =?utf-8?B?VG84dm96VWZjOXB6OW9uVy9RMG9HbzVzdExIRm5iTWZ1K1FsYm9Tc0IvQ3lS?=
 =?utf-8?B?S05mL1AxcVV6R09Ncm1UcGJKN1JiQm1SYkVhMmxwdFlpZU50RDA1cmlCejBk?=
 =?utf-8?B?TldKUkNCNFVQb0FSS3FJeW9ZOWNWbGJoZm5PTGk3dFJiZCtFZEcxVEZXMWVa?=
 =?utf-8?B?ajdXZkJXK3NKSjRaTVVjWlN2bE9SSXZnOFFramlDN2xIdFZzbG9FekVJdlA2?=
 =?utf-8?B?dFNhM0hRWm80a3o0WnhrT0FKdkpHT1VGMjJvOEZIUzJXMU5uZ0hRYm0vclR1?=
 =?utf-8?B?d3BpQjVKK05xVUxiOHlRbXRCNGZUUWVuaXE1Z083Sk9nYnU0ODg4TkxKZW1B?=
 =?utf-8?B?U2NaMUd0YUxGZi9oN2RDRFZQbXNmMnFOSXRpMTNrOXpNQno3R2hZSTY3OHNj?=
 =?utf-8?B?TFhrTUhocGZjaG5JQ1FsTFRZd05kZzNDTmtJbFE5cjJlZk5UL3hzQzJUR2Vz?=
 =?utf-8?B?ZVpDbWd6Wm9sTzNUY2YxdU94dnJhcU5kZlZMbG5YSWhObG00ZnBhUjRNZ1FO?=
 =?utf-8?B?dURGMHVDeURpaXNvOHlFa2Uzb2VVNEtYdlZaZU5rRFNqbkxjSnFSaDUzVXZp?=
 =?utf-8?B?YVlxQjBOZ0NlelJmNERiVHBnRkdTV0d4Y0wvTnNaaEx0RC9oTzNhQ2hMaFo3?=
 =?utf-8?B?ek9Xdml4L0FVQlNXNmdCbTVjZ1Jlb3lkNnhQYmMrUzlUaUNyOUJ3ZWR0ZVJv?=
 =?utf-8?B?WkZMSXVwM084eHN5TFNucGFhRGZaOFBQQlgrSVU4NDAxVnFsQURDaXdFR242?=
 =?utf-8?B?NnVzTWdqd1N0T2JvMXlFTzd3d2hYMHM0ODQrTUp0SmpFRlVYcFFacW5DSXZK?=
 =?utf-8?B?ajhtcjZjN1crWVBkWktCS0c1ZEE2OTlCRERzY25mR1g3bnQvbGZZUFFKZWNh?=
 =?utf-8?B?aTF0NEgwQ0xhVjhJeHpReFZRRXNPMkZWckg5S0tiV2xMYkpmcGcvZjlvYWdn?=
 =?utf-8?B?TzB2QmR6ZVJRSHFaVDJka3RGd1dneE9LZTVIM2tFVm45bkxsV3JiUHJoVStT?=
 =?utf-8?B?eGJtWWs4RndDQ0w4RDJITmtUZWFVRzI4NnNVVTZIQUpueENVRXhiTDZEalA3?=
 =?utf-8?B?V0xnL0tiSXlwRlg1RXBUaDdwKytISEF1VkQ4R2xibllORXVnMTBOMEJVbGhO?=
 =?utf-8?Q?mZuuQTvfdmQ4QhBu0IuEawdqqmYUJnmxHIQOrTMKy0Wup?=
X-MS-Exchange-AntiSpam-MessageData-1: G5kdEPAPLRAHdw==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47aa0a98-a641-42d1-1643-08df118e707c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7110.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2026 11:59:18.3146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t3KsJ6ee4IIoETjnu/CPkUwm/hTi0ZNVMQ3vK1RDVexOQ9wx9X39wYLSQEGJqTIE5Edzk31ex5Hj0pSC8wf52A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7230


On 12/09/2026 20:28, Pavel Machek wrote:
> Hi!
> 
>> This is the start of the stable review cycle for the 6.12.110 release.
>> There are 1376 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
> We get build errors in -cip testing:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2842911949
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/16461797877
> 
> drivers/soc/ti/knav_qmss_queue.c: In function 'knav_queue_probe':
> drivers/soc/ti/knav_qmss_queue.c:1874:9: error: 'knav_qdev' undeclared (first use in this function); did you mean 'knav_queue'?
I am seeing the same for 6.12 and 6.18. Appears to be this commit ...

# first bad commit: [4e91398b6ae1dde1824bcf3d19b4237773f31e68] soc: ti: knav_qmss: Remove debugfs file on teardown

Jon

-- 
nvpublic


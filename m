Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07117146588
	for <patches@lists.linux.dev>; Wed, 26 Mar 2025 15:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743003128; cv=fail; b=gWu+sXCAWEdTKoZIUkCdtee8U++Fm/Y8NQAWREeEbME/ZzB8GC+OQvhNMswYROd+hf/OQMTzfSFQsXfwi6PwXScfVbQAFs328iojf5YfIcwFFEELoPNO99lzAOnQWPUWQ0bIXeK3jtJsXouS+bhf+d2se2zdSvuxQKZuSm6y24o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743003128; c=relaxed/simple;
	bh=YXuJExJRKmnxH2ckYwhOhOKezSRcSEwFG5bsiYiE/7E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K+wHPy2eOXiqgPjjkZtfxFSrCMa0gAX9M0fQvN4hA3Iyac1/acwONj0OB4Z0sZ4L3CylfJVjm8olokGAinMkL61jOcUfIB8D6xZIm7h/IxJqvFgvfYHlOf1Nx88NEtmgPYKQjGGFxkKSymLaCqhMGleh4JECviRswE7qq30to9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dvGn2OD2; arc=fail smtp.client-ip=40.107.94.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dvGn2OD2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CwzYpbk3lJpoFSUixUZN/QSk9zeCtHB16OQuGgxw5cMSg8h7hu4B+9udP4ZNDemwBfX8jb4x/VxrCFqKCojANppfBBYoED+rW5vqBpo2s+l/k9FmZSxTJgy8kwt6BfsLLpLUVJMeV7TosAzADM5aNpf3TfAJduZV1NW46tEO/KnKvhnLNIbhqxR1G29t3QdCIknzXE/km3A9oI6NL5YhwrDbFtMt1nccBLSCOWraMlPPFAE2gIpw8cdzfNygWu8nqVcTXmB42WbA0xw8n6UcaWdpQv6EVdjYa145dTVuu+W/Dhbtt9bYFiUzE12Y8TCLfLBdJZNOWq5iqMGRTrj65Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JiVM707e14ZhE8bb0/91tNnni3zptSmdky4qdQJfD3s=;
 b=tSS4Ilpbw0BNpJXQU9lqsL7/xrI+7O3QVH1HdLfH8Moh+zkMjq2uREUWGXYmoqCLd0dDpSA0AhNkdd0xw6tlG3i5UhYy8cd8NKJNrP5yHwU7rG20RJk25qj7yfJiacUX9mjylmYP43jrSBqmDWhsNCnK7XueX/xGij1Az52rYICPf4cX21WbArSo7n4K3CpObgnecvNLX43cpbbKpZ/HaYcCZgyYH5ZUpiB7canueKxW+lQw+goPxD1Q7+eOfazhEBmqTaYIYRKuddgxVv5yUR58Bv5Wj3c9c/kKepvqpYWgQ2GwEurA0kdK5AdhnzUVRVem67jNkasRM4gBBN7MGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JiVM707e14ZhE8bb0/91tNnni3zptSmdky4qdQJfD3s=;
 b=dvGn2OD26t8cQj3Dd4QhUN+QmqCsZ//0MQ+KW50TW4v76hfyDDhTRWqw9CxYI78Lidr42Qq7jiZr/e++GrqtDJYGguv095A+DFON/iBEv9SXckvuKbh1VgugG2ONBo698IPNO57abifHWnXoe27IkBcdieEEYMR/YYmxlgD5UVC2qofGanW0vMaswngxCLGMVdTmws95b8hSE6PRKYFhKhwvvWm1uSykV9il6yk2M4JkGoBNNwkDZfPQ2jxVG+dOtgCrBNDNFwCWFbo6WIJWtCo1V7qf+bLB0u2B6plL4HOgyLYImYiZ50m5mW5omam/cET9WdU/Nt4vBRA8b39LYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by SJ0PR12MB6942.namprd12.prod.outlook.com (2603:10b6:a03:449::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Wed, 26 Mar
 2025 15:32:03 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%6]) with mapi id 15.20.8534.040; Wed, 26 Mar 2025
 15:32:03 +0000
Message-ID: <7aced4cd-b451-4b14-8bcc-92617a02a672@nvidia.com>
Date: Wed, 26 Mar 2025 15:31:55 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/198] 6.1.132-rc1 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Dan Carpenter <dan.carpenter@linaro.org>,
 Anders Roxell <anders.roxell@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
 Dragan Simic <dsimic@manjaro.org>, Heiko Stuebner <heiko@sntech.de>,
 jorn Helgaas <helgaas@kernel.org>,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20250325122156.633329074@linuxfoundation.org>
 <CA+G9fYss7RcH=ocag66EM4z26O-6o-gaq+Jo+GOUr2W773vQOw@mail.gmail.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <CA+G9fYss7RcH=ocag66EM4z26O-6o-gaq+Jo+GOUr2W773vQOw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0196.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::21) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|SJ0PR12MB6942:EE_
X-MS-Office365-Filtering-Correlation-Id: 678ebc87-86be-4b93-3c44-08dd6c7b5bb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|10070799003|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d2Uvbk91YXV6QmZnVmduNDJvajVWVDZuRDEzczVuZjlLWG1IVzZKWm5GV256?=
 =?utf-8?B?TzQwYVdDc3g3OStsZHRNOGJoaVJsNnNBREpGcFYya1ZRSGFlVVJCSEMyTU52?=
 =?utf-8?B?R2o3M0RWekxvdXpWVWVRSzBBWE1YUVNBN3E2eTFJLzd5OHM3dWlUeDdKdHhZ?=
 =?utf-8?B?NEREWDFzRXBHNTVpSllUM3k5M2VKd0VhWGhEWk0rSWYrWlR4L0F2TkdFSjNj?=
 =?utf-8?B?MnFjV09PWkdJQ1JmbU1BNUpsVnVva1UwTHlTd0RvSE1UYVowNzloSmY5dHAz?=
 =?utf-8?B?bCtBeU8zbGlkNjd1U1pVTlo3MndXaVZJaVRQa2JsenVpUGdmMGM1cEVwTjlV?=
 =?utf-8?B?cG8yRWJHMWVUVGh6aUpsL2RCYXJwTkE2VTdHUHhqREc5bTdSOHEwN05qdlRP?=
 =?utf-8?B?WjlxQVBEbEFMZ1lPaHc1bHJnZXZXT2tjbmorak9GTVB0bW9Qc1l1dzE0VVVQ?=
 =?utf-8?B?M1p3VDB1ZFpNeTZ6YTBmaUhSZ1ZudXJUcHhCVVY4Z3UzVXdLS1FCMnAyUHlK?=
 =?utf-8?B?d2lWYzRWUHU1bGlCK0NMZlRodzdKMXkrNFRDenNQbWRma212a284TUw4ZjZO?=
 =?utf-8?B?MWxJc0x3NlFORlBWczI3Vi8yZGxiVGpWNnlpWC9Bb2o0c2JRNHVHRlJTL0VH?=
 =?utf-8?B?aXdUMWZMRTVSaTBWRHNLTTVoeXE5T2FnSTZ0eUI5Z01rU1pMK0YrdUUrUXEv?=
 =?utf-8?B?VVExMG4zeHZBSzVFZjQ3eDRCTUF3RWt6VE02MlVDclFNeHRFVE53U25NdGNT?=
 =?utf-8?B?bGNLK1RCL0draDJhU2VpMU1xdmhOb0V0Uy9JSHVraS9oS0c5Q1puc3RXQ0Ns?=
 =?utf-8?B?OHB0bExmeWdBL0pFSHB0c2lyb1RQY0FUUmNKQXhySFI2L3pONUpwUE0zVGhO?=
 =?utf-8?B?TGtZajNIaGNLZkkvMnhtaE85TFNSNUVnSWVwSUVpWEtEQUdOUkh6VnJsSk91?=
 =?utf-8?B?RlpvQ2lqNHdUWnNtMndNdHExY0xPcnhQVm9CREZrY3Z6Y0xzdklLaDVXeXR2?=
 =?utf-8?B?ZVdQd2ZCci9RZ0JOcE9vRVFQWHlVQzNtRzFxNmZSeW5SUVd4VkNoa0JwbzJr?=
 =?utf-8?B?QVE3NHVLR3VydllGbjVVd21zb2IvYTl2VDVCb2xGay9CUytxQ2d4aHl1UFlz?=
 =?utf-8?B?aGRXYkZ1UU5xWnNBMEhkcWZISGljQ2N0M2VIbUJFUEgyaGV6aHdySUxWdUlP?=
 =?utf-8?B?dEgwUG1wWnB3ODE4SWw1OE1jSy9aeEptV0hlOHBCRDQwRFdQRXQzS2lIVWhW?=
 =?utf-8?B?M2RudFQ1d0Vyd1M2NkxncUllcDFHMnFRNDNGZGVPd0ZjSHk5T0xCd3V2MUh5?=
 =?utf-8?B?VlR0M0tEMXlLRE00SWVwMXNCYjhiUUY5a0JRTXl0ODRxSDVoOGxFbENkVEs4?=
 =?utf-8?B?SUl6TjMwNXBGQ0tSV2JvVFUrbmREWFpGT1BGcVgraE5BajdXSnYxYWVDVUsz?=
 =?utf-8?B?RjFhRlptMlJmT0hSNVR3Q1R6c0h1N2dPNDJncHp6UGFHSm9paXI4c2dvaXVK?=
 =?utf-8?B?aFRFMDVpZGlxeEUzRzMzaEhvazJTQ2FPcFhCUGZidnZiZnczOVJ2Y3AxZS9v?=
 =?utf-8?B?dE01dHJNYU11dDdCUTRVSU0zbmxSUXM3MWVTSi9sUDdrL05hVFU0M0s0MHdB?=
 =?utf-8?B?bDhmUFlwaU9lbXU4cEtscnpTRHpnVU91SjdtYXlkR1BqKzJ1eHJvVG5MYnUr?=
 =?utf-8?B?WVdxSDJTZ2JqNFFxOTJhS2FzNUc0dVlEaUJ2WkppekFvblVGS3JiN3JSQVA5?=
 =?utf-8?B?QVdTY2dJMTljSm96YUZvREIxU2VCcHF3YlZSRTBtUkhFQmpKMHc1QmVQL0Js?=
 =?utf-8?B?d0FlWDdBTHFtcnZpY2NtTFkzSkZ2LytIcGUvRDgweTl6TjBLMVpqS1pENk5i?=
 =?utf-8?Q?XEGO2VkBPHHGJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(10070799003)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aWlwK2xWa3hsZEZhVVdtRFRVYWRhUytWb3NadTZzVnViYjhmb3BJQkxySE9L?=
 =?utf-8?B?UzZ5aExBdjcyWnY0NmZxZTBMYjVZM0JYOE01eFpVNnI1Q2tnbmxqUkgvc1ht?=
 =?utf-8?B?OTkvZkpGeHkxQjBKWTUwS3c0VCszcFNQcHlyRS80RnFTU0I0akRxZ1QzbnBG?=
 =?utf-8?B?L0hKbWM2WkJEMVg3c0JxSFJyU2VqTENCNkxKcE1ybEFXektjVUZidDV6MXQ1?=
 =?utf-8?B?a1lPc1VvaEVaOHQ1S0hHZ2xxSmRSRmRjdUpHcmt0RXdVa21sTHVISzN2TGpi?=
 =?utf-8?B?aFZYajhGMms4MklWcTM3Rnd6SmNxOFRDazF3YWV3a3ZiVWNkeURNcy9pSmtl?=
 =?utf-8?B?VjAvMmxvT0l2VjdiWlVhR010ajU3aVBkV2tBOEtwVnA2YUFhcGV1Y01JbkxN?=
 =?utf-8?B?MFdmMHNxek5QemVINlNCQjREQ0hYMGw1aTgvL3hyM2RoNElUUzlGdkFsMnls?=
 =?utf-8?B?N2g1cmFPckloR0NVOFMxWS9aUkxVYnFwZUp1RUdWcm5rdE56NFZaVjVxNm1S?=
 =?utf-8?B?TEVlWUhCWHd5UEhZSlZiWlJYOWpLTlBmSTBhR2lWam1HVStGMjNhbEdVWUVV?=
 =?utf-8?B?S2x5ZXRHblNXR2xVUXNHYW8wWmZXeGx0TWxLK2MvSjhRN0VHZTFqb1RlVDk3?=
 =?utf-8?B?U3gwVEFqNTdLejd0cmJ3dDk2THJMZmlRK0pRcHNGSzJnWXNISGxhOWFEeWR5?=
 =?utf-8?B?cUxRNFVyQ2pYb0d3WmNyOGY4WWNjdnMreSt3bUEyRlo3R0xrYlJ1U1pWM0xK?=
 =?utf-8?B?SjJCb3RPcE9OK2UrMWJVd0hjcDhSTWthT29VSUk1VVN4T1I0d2xIMDJhbEkx?=
 =?utf-8?B?Rkt0WUlUODNMMUFvUk90TUdDQ2xPRmREZ1JLM3BuTkhRUVZkeTZ0bk5PTTBo?=
 =?utf-8?B?NGp5OVFxdkdpMmtuTTdkSW16c2VzcW5lb3hZV2hYekowb3QxMEFhM0hFS0t0?=
 =?utf-8?B?VStaaVUvWVJhdXFIRTFmWTdHdlJobVA1bFRiMDhwa1VBK3RXRll4QkNmbktL?=
 =?utf-8?B?ZGxuK3VtVm9Iak5nNG9jemQwemZ5dzlRSmFGeTFBQTliWENWb1kvaUkyVUhq?=
 =?utf-8?B?YUFsM3RBOURRaDYxLy9HcEY2ZEk2blFSVGc3R1V0Qkhid1ZlT2twS1laeGF2?=
 =?utf-8?B?YnpPUmIrdFhUL1gwMHhJN0VRTWlzR0YwSDNPZ0QrSXFSUmdTQlBFMkdpVW5S?=
 =?utf-8?B?N2F6NWs0bWpyL2pzMFZZdERQUzVBL0kzZWFlZDQ4YXBkV2grTVVBRWJxZ3Iv?=
 =?utf-8?B?YmptTHdyMVp3bFhPY0JHcy9UQlBTVG0wc0VPYXZKS3pKa3lzN3hxbUZFNWZF?=
 =?utf-8?B?dmR3UUNkeEI3bHdqcmJkVG5CcU1lMENUR1Z6UEJwZEw1TlZUaStST2FJQ1p5?=
 =?utf-8?B?Vm1ibk9xc1NINk5BOUtGeW55WURCNmxaU29aNG1abTFhYmNwKzN4R0U2aFl6?=
 =?utf-8?B?LzExQW45VzNlQzkrSVRMNkt5WkRaSkxqMUZtdDVSYWVrR2M0WmZVUlZGeCtR?=
 =?utf-8?B?d1JRT2ZxVEJ0RkllczBYbzNDQ1pPWTc5ci9DTUZ5TEtsd2NuNldrWGV2aklC?=
 =?utf-8?B?dWwvOGxmbEZKbDVKaVA3SDQ1ZUswdUFQZDh1UDU5YkF4YUxEU0tnbXE4eXF3?=
 =?utf-8?B?bUZIVHdrTjBNSVRWbVBraFc1NlF6WWU5ODVyR05BN2N4MmxYRnM2TWM1MXQ3?=
 =?utf-8?B?KzJGRmt5QjBSaUtrUzJmWVN0bHpkRGRLMFpBcTZNMURpdU81R3hIZEZTbzcx?=
 =?utf-8?B?NkhjUTNWM1hPd096dnNPSlR1VWJmS1orQ3A2Tnd1OE90WlNyejExRlAvbzJY?=
 =?utf-8?B?eDlWRTZzTUxaZ1diUGd5VFYvZVdQcHEyU2RtVmlYMXNGU2dNM0FJT2R4U0E0?=
 =?utf-8?B?YXl2dFpyM0M0czFLKzZnbkNlUUdzajNBTzhWVXByWlYvSmJsYWpxaVJ3VlB5?=
 =?utf-8?B?UEs4cUJ2UUlRN3FKQnkrbUY2WW1aMm15eVR2a0Z6WTAyeUlKWEp2eWNSSGJa?=
 =?utf-8?B?eTg4Tzl3a2tncEVHaW9HUE02VXBCVThvZG1qdjZjRW1uTm9Jajd1cklSb3Nx?=
 =?utf-8?B?ZzNqb1NMS2RZTHYyMndWOFFENktodEt5emxWVFh5bGtORXNDU0RGQzRkdXBM?=
 =?utf-8?B?N1Z1RHZQU0xBTUxzdTRyL3Voc1djM3F2cjFtZ2daczkxbkwvUFRuQXZKaW9v?=
 =?utf-8?Q?TAU/qDgBL/cTIg2WoRBHkh2P/7AL/vKih96lwjja5K3v?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 678ebc87-86be-4b93-3c44-08dd6c7b5bb9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2025 15:32:03.5313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l/jZd3Pe8FixhUpwajgVVPe8F7g3+qyB+tt78HCxhA67i43Ah/C+sBFJR0FUV6TErrgux1oyQp6nhlHYqm84gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6942


On 25/03/2025 15:22, Naresh Kamboju wrote:
> On Tue, 25 Mar 2025 at 17:55, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 6.1.132 release.
>> There are 198 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>          https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.132-rc1.gz
>> or in the git tree and branch at:
>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Regressions on arm64 rk3399 dtb builds failed with gcc-13 the
> stable-rc 6.1.132-rc1
> 
> First seen on the v6.1.131-199-gc8f0cb669e59
>   Good: v6.1.131
>   Bad: 6.1.132-rc1
> 
> * arm64, build
>    - gcc-13-defconfig
> 
> Regression Analysis:
>   - New regression? yes
>   - Reproducibility? Yes
> 
> Build regression: arm64 dtb rockchip non-existent node or label "vcca_0v9"
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ## Build log
> arch/arm64/boot/dts/rockchip/rk3399.dtsi:221.23-266.4: ERROR
> (phandle_references):
>    /pcie@f8000000: Reference to non-existent node or label "vcca_0v9"
> 
>    also defined at arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi:665.8-675.3


I am also seeing this build error for linux v6.1.y, v6.6.y and v6.12.y too.

Cheers
Jon

-- 
nvpublic


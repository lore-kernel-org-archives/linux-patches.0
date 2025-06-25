Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78714202987
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 07:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750836900; cv=fail; b=rKRVnUSdF4IJ2CdrjCTtITJdoxER1YZaBHn+8Ih3cgAKNTrcozf9O6T2RK4OBAsS8l3Kc5Pg+0PMgMOFb4jbziqi/gOjXk60yzYZj6PpwQlenit0ZBHSShUagyy6DWRJ5rf9tA9NQsokkzanOWmXPmrGbhQgkgBLcFIT1K+5Ncw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750836900; c=relaxed/simple;
	bh=6tJOP6PS3yTWyL/hY8958d+lRu8QwgBjsX8bEbMZWSg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gsMHkPXchb4Y3gBh2SHZmfNSSTnG5qIp+yutcCA2PXyjob3RAYTBRwVwrE08Ymq0/vLMPJaHDbGunrwmcCYp43fpMScBYUiPdcy4UPlmcqIt7v0Metsj55hWWM4lw2bNHsXv28SUqQtXtoHwtCYxzD/cvQdsGJFlmJ6Kv5H/CWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=THKQfL/a; arc=fail smtp.client-ip=40.107.237.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="THKQfL/a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eNGInZ50HRwxgc6HS0K4m50auL8jrLC7NM8vsdVyWasJeWQaGQN4Fz1oyyw7U7V0nXMJzDCD6k+JRHE0UsJGI33rSqwa4yFcb2ypns0x/8HEUSvP5PKhO42nSlFw27stlX/pwVfsrq5zT2DnAPXgaPOIWrq/+9wMTOKi/+xDnFGH4F9+a2i4U/vb42g1W+RtNTIPuzvolJmJyUXI0B2z6Gw6syB9uMuEQEYnDnxTAyXtRybv2fBA5rPZEl673U9iNvmN+Fg+UFdYW+ZrVi/tKwh04TZU6mIdOkOeSKdujEZ4axKYlEiFCj+FxZLbXr8WyNiAVKyGgQBaHs2D92uyPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=emUjFpNwWdXSav4Lu1dvsXAdmd6DUTGrWyfyjbbvGvs=;
 b=Rv/iR0f/82oFT93Gq6nRCKm2eXnHz1WZFAhXvSlHckwDpspBZovJiO+TqPhyBAbcqs8c6Y9HMW7ZEAyROiYywPAPjBGXdswSnL5nVroXQSv/zm6plbj8wRKhuasd8sw8wKF7xSHsMHc7PcGLsFXJwPPddl1w6uidOlb47HEr80XEoWowmKYcjnxURcq3+qeq2km5M5nBqcF+ttdRYlrq8ozqgTbnSUwgAYRGLeoIZP3gggEV++TfnPBayfOikNlJOJ+DKyz85LIVZpxiRV/SpK3dpMF0iVvliQqyABRoUcJtBQCEWEbqZqIB3hkF4x/Bt5CkQkx0RSiVsj/CdIcyXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=emUjFpNwWdXSav4Lu1dvsXAdmd6DUTGrWyfyjbbvGvs=;
 b=THKQfL/a+WSlOO9xsghMmlF67ow7Mp8ePGEdsTIPaZt0PFyScxCj7PPoXtns0V8n2Dwlx+Krp/tuJeDm6MHwj0OHZqOnDeLdsdZgKVsDv9MHM6n8omgoMr/PIrrrYeVFZ7/i1T6KErj0dGyQ/t0m+KR5O17+eEriBB8Q331Jd01T8yFtJuDBym/dZLBkuXs+3++cGwgiUwHbvFpcIl2ccJon32iVJ/rDEp1LlGhw0ZOyzUOkNkf5Tm06JZegR7a4XmY0yMj/bdJIFFFYZ2lZDGMD9epmM/MPHdlHKllUoIUIs+xK+JuNMuoHzPg/RCoXwZHiImdzPZJHrTGh6ubLoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11)
 by DM4PR12MB8449.namprd12.prod.outlook.com (2603:10b6:8:17f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 25 Jun
 2025 07:34:55 +0000
Received: from SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9]) by SJ2PR12MB8784.namprd12.prod.outlook.com
 ([fe80::1660:3173:eef6:6cd9%5]) with mapi id 15.20.8835.027; Wed, 25 Jun 2025
 07:34:55 +0000
Message-ID: <c84768f2-17d7-4edd-8f6e-d0f2a74ef559@nvidia.com>
Date: Wed, 25 Jun 2025 08:34:47 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/222] 5.4.295-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20250623130611.896514667@linuxfoundation.org>
 <cf271495-270e-4a0a-a93e-fe8c44e4eabd@rnnvmail204.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <cf271495-270e-4a0a-a93e-fe8c44e4eabd@rnnvmail204.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0168.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::11) To SJ2PR12MB8784.namprd12.prod.outlook.com
 (2603:10b6:a03:4d0::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8784:EE_|DM4PR12MB8449:EE_
X-MS-Office365-Filtering-Correlation-Id: b286eb6f-18b2-4713-2d8c-08ddb3bac773
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QWRKL1lFNVVsY1NYYi9zNVNJbUVMWkt4VWVTS0NhbDZEL3BqSUQwVFlIZDZD?=
 =?utf-8?B?dE83d012NjV3SXB3VEJwSFY5YzBBZFQwVnorcEsveEJBTlpmRjhwMVZwQlJs?=
 =?utf-8?B?MXlVT2lFZXd5MVlKOFhmT3pPdU1pUGgxSjk5QTVyeWY2ZngvVDJyeksyZkt6?=
 =?utf-8?B?UFhrZ1BmKzlvbzhsNDd3TGx1bTllRUp2bk1GdFQ1NTlTYURoczJqbGpScGRD?=
 =?utf-8?B?MDJBR3YwNjkvbFBBQ0VkYkFWdVJZL2hYdWo4VVMvYzU5MWluYlFjdnlVNE1j?=
 =?utf-8?B?RmRzRFcvb3p6QkI4UHdEMXpsU1E3cE9ITFVZa3h2aVowVHJFU3Y3UXFzMzZa?=
 =?utf-8?B?Y0s3YjZFcUxzM1M5UHdQNnBWNXBsbGc5Z2d6ZUpxT0g3RDRsQytTcWJVc0k0?=
 =?utf-8?B?RmtENENZRlliN3E1SGtqUzJGcTJhMnlsNHhkaVRBUlh1aGpkSlhvaitMSXlo?=
 =?utf-8?B?MUw2RzJyNmdPUFpHd3A1VHFUZmZkNE1aTnYyUUx0WWtCZS9BYnkzSUR6ZjRP?=
 =?utf-8?B?TGFhYWdTZ202bXJ2Mk5XWm9GcnZBS21FQjhqcCtGNlE0dmYyY0tRV3VCNjIx?=
 =?utf-8?B?VTJPQ0o5VWVSSjNuUTNiZUVaYTdpa1FRTUVHbDE3MTlRNGx0NEV2bFNhd3FP?=
 =?utf-8?B?Z3NMaElicVRmYlBsbm5qNWJkOWNLZWRQUG9BL1NMOVN2RlBCRDkwTTBieGZQ?=
 =?utf-8?B?TXdJM0hWSm1USFBZNFJIZXJ2VG5Cb1k0L0p4TmdPMHpveHVHRnhHRVZscys4?=
 =?utf-8?B?dVpESW1yd1RFVmh2Q0xmNXQ3ZitXZGhOcXFRQ3ErajNzOE80UEVRZnpNKzNB?=
 =?utf-8?B?L01IOU1uRmhKYkpsN0dhQjNLT01KWGQwZ2hUZTQ3eTM0VHcyYml3blRiN2JL?=
 =?utf-8?B?Y25jR2ptRlB2WEJZSnpHcVJ0R3QrT3dRWmsvWE1TMTRBRFdQOXNKK2RnaXBk?=
 =?utf-8?B?blNTelhuL3A5Q3F5TEVXWmpuWG9ydURGRW9QQnpROXJlZWQyTW9iYTN3ZURo?=
 =?utf-8?B?OGZvK0JBWkVXeUFYRTVuRk9MVy8yaU1IN3RveFRDM2FjRHhrMjY4ekhEZEJ3?=
 =?utf-8?B?R0JJRzZHSUxtVDB6WTljWEtXVVNkMG5QUXBSVnNVbDJnNHFIbmxjQVpSRHdr?=
 =?utf-8?B?eU0rMGdEUXd1L3Z4UUZsNkQ2TndENUdVYWFYQ3hvOW9JMVo3NVhTd0NPT2VN?=
 =?utf-8?B?ZXdzQWFmSTE0U0hPQmw1UEt6dlpjd2xKSTdaU3NHeE93NitiRnZ1dnY1Z04z?=
 =?utf-8?B?YnpxaFp1RC9KbVRTOU9EY3lFeGwxOU13Um9BZk4vMEhyd3VSWDA3U2ZqczR0?=
 =?utf-8?B?S3dDSkUwM2dZamJhZmduNitWamc3M2RUdGpuWUgvOC9GNGxNUXRLL0hDdzhm?=
 =?utf-8?B?cGxOcHYycVdRQXFBZEIweVNCSStzVjVRMDRKcFNmYTlhVjVDWmJTR2dSeDdt?=
 =?utf-8?B?TkVBZkp3NnlGRnlpUmZsYks2MENhaWcyeWR4dHBJWWJ5V3d1Rkg0QnY0eE1T?=
 =?utf-8?B?aVFwK2tqZFZxZ1R4RktoSjlGaW5JT1FQS2ZGZDBWZ0dGL0dKSWFWc0NiTkJ3?=
 =?utf-8?B?MmE4R1RTMTBWV1IxaFlocjFucFVVc1h3THp1N2o2QmRUY2kvRUd4a1RCTUhJ?=
 =?utf-8?B?d2hUbWEyS1BKYmh1VWREMU1TQ2xOZDdSaFBPNG1MdS8zc3dONk95Y3F0UzYr?=
 =?utf-8?B?RVVsOUFwUENFeUoyalArRk03VlV3SCtRVjcvOEFiekdvaEcwS0VkTzVCVDJZ?=
 =?utf-8?B?S3VuZ3dLb3l3WTFlM1JOWG1GVzgySExrdWpyM281WkFtcGQxVmFkWHhMc3Vh?=
 =?utf-8?B?UGRvWEdYblVVUTZxWldUQXpOUytXMU5HMFdjVWt5WmRhN1A4QUY5RGt6VEVB?=
 =?utf-8?B?YzNMRjk4bDBnaHd6VHp5ZW5ERjErQ2RtVy9rWXA3eHBCbmZ2QmZQVkRqZldq?=
 =?utf-8?Q?2hgyZn0Ygjs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N2xsNCtLeVlDRTB3cmRGQlV4TFZJL1hkZG5yN0ZVaHQ3TmQxMWovZWx4c3Ez?=
 =?utf-8?B?Ri9iakNIT1ZQVXdSVnQ1YUxSR1FZY25BUEZBc0MySTkxWFVGcHR3ZmhES21Y?=
 =?utf-8?B?eVJwdlBsWm5zQmlhR2tIY3QxSjRuMkF5dG5EM0hyakVGaXhaamMybmlUaktK?=
 =?utf-8?B?OW1TTUNHSVUvMkc0eHRQMThWTlRUWXZ2SjFCWU5SbG1PVklEL0NpenJtaTBq?=
 =?utf-8?B?SWFvVUc1MGJlRDRENW80Mjlxai9qcllpVUtNNnpBd2RXRXV4RFdRMERDd1B3?=
 =?utf-8?B?REJvQTdGUlhBN1hjaTVDazY3a1BWQTdrYmsxbE5pVHNHZm9ibC9xSlQvSFI3?=
 =?utf-8?B?bm1CZGl0UUI0T3VWalN5aTRhT1Q0TDJBcWlqUUlmU0hzNHpFSkhheGw3R1ps?=
 =?utf-8?B?US9naHdWL2lDWU9HQlBBdTd0NlJ3V2Y5YkI1S0pxejN1cXBYdFVkWndENzRX?=
 =?utf-8?B?K1JvM1pFeUEwL2ZDZjJFQXRBekJlcVJvS09aV2o3MzVhQm94bzVYU012eVVN?=
 =?utf-8?B?Wkpkcm9YQUoyR2pXYU1yKzUzTGIrOHQvRDc5MlRsK0ZDTlhvVFB0cFVqdWxx?=
 =?utf-8?B?NjZwaEJIR1hpNXJ6NzF4MFIxMS9BSlhSOW5COWJOS1hIOWdxTm9GZWxDMTVC?=
 =?utf-8?B?Y1FCSTNQckVWVm1mbGhqY3Q0K1FmWWtKRzNFbDNRM0JRZmFaZDVuYnNhbVBW?=
 =?utf-8?B?dklHdFFQdDlCRWxBQkNVOU9JaWlFdVpwNFJSMDFjQ0o4QzdjTW5kS213ZGVl?=
 =?utf-8?B?OHAwN3c1TDN0UXBZU3BtbVFKT3V2ZWFUK2lQSGQ4elozTDQwL2YxY0JpMUJY?=
 =?utf-8?B?Y2Y1R2dwRFR2QzBZK2hERmRNNlE4alJYWTVPaVVmK1RtdUlTZGZCelFGa0l5?=
 =?utf-8?B?di8rV2tRbkdLejJkZFI0OElBeDJyS2tzR1M5MEltN0pyc2tBUVdLMEJUM0lx?=
 =?utf-8?B?Q1dibWh3R3F4MmpkcFRxc1FJZHlpaFRNNHN5M09RSGR0SGVBdEltY2ZKL1M0?=
 =?utf-8?B?M1dTanBLVitQSVRXaURaOEUza25mK3kwVmtKV2dCWjVIVnV0a0t4N0ViVWNp?=
 =?utf-8?B?d2ZoTEZ0WXJsTzRGR2VIeVR3eU9xVnNIR0I5K2w0OERjY1JtWGlwZS9WTmpp?=
 =?utf-8?B?SnR0eE5PVndCekEzQU1DYnFxdXlZeUpTc3ZWU1dzNTJXWG9PeWU2ODhZYjdQ?=
 =?utf-8?B?WG5nN0ZPK3YvbFlkUlJlS3E4bDE1VkFxNVJwTTg0RFRSQTFlcCtKQ0Vob2Ra?=
 =?utf-8?B?UWVnb3A2NHlVbG9UV09kSmN4VlN5ZUZBOGwwSHhXUG1zVmNzMHNEN2dndTVa?=
 =?utf-8?B?OE5XODdBM1d1Y2s4Y1F4ejlsVjI5WWVTTzhHMFAvcnFYTWQ2clY2RDlvWlY2?=
 =?utf-8?B?WXZrWEg2NElmOU1LZG9xOW1Xbk80M21ic2ZWSXNOM2lyNFVGdlJYWE5ISmt6?=
 =?utf-8?B?cTBxZTFnRlA2MWdjU3pjcjlIZzE3bkszeWc4anU4TThjTmE4bnk5THBtd2Vv?=
 =?utf-8?B?eWdoQXc4WFg1ZW53Vll6dFhqczdKZUpnNkRya0pxcnliZHBoRUs2aExMOUh4?=
 =?utf-8?B?UlBuSE9hQ25Wc1R1OUxUZTlIVGJwMXJ5TWhNVitlK3k0UUp4RUVvSldvZmJi?=
 =?utf-8?B?UW5FaG0zeXFpaDlFdmxFYnJETWVQOTRMNGx4a040NXFYTDNoRXdJUkJNSTM3?=
 =?utf-8?B?TGZBdFZZd1VycVVUUHVCVDJ6b3pBREFTQlcwL3lzazJPQUY3NlJVSForMlVp?=
 =?utf-8?B?OTdnN01JY3BuZUNXanN1TmlwWHBkQTFsT0FJVnE4M2RrNUF0ZUt6TlRLREpl?=
 =?utf-8?B?M1BmNGgwNkhkZ0JDZHE1bnFIUzQvL2FZc01wd2paNTM3TmViS3lOWVY1WHZl?=
 =?utf-8?B?QStoVE9IcFBQcmhLNUdURUZ4MmhyWFRrakV2WDRvSmFtWk0xWmQzcWpBaWd2?=
 =?utf-8?B?RzFITmFNaG9lWU9hQ1JtSWRPTGdWdHJhajROV2JvaVZlUmE4cC9hM1dXdExZ?=
 =?utf-8?B?NE5XYWF6MVc2NEtuRzMrRFlBY2pmTHEwSXBPOXZ0VEdFTy9pSDRvZEpLL2Fr?=
 =?utf-8?B?REE0YnRuUjRHWEdraDVWNWRucXRlcjM0R0ZIc2lqN0hIOG9vYml2aHQvN0ZF?=
 =?utf-8?B?bXlnS3ZVdC81NjNNZXdGb3J3bHdPWVBCNGpMYUpWMnB1WDlFRkVBckdVblYr?=
 =?utf-8?Q?K3a7i8KrQqND3uTkMmUIv9nthuGkVZGramYgszzfEx2Q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b286eb6f-18b2-4713-2d8c-08ddb3bac773
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8784.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 07:34:55.0363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n9Q2+7G3zoGW02joApIfcekmNoILgFx+Vzrr00aElALYwrk840hFRc8bnX3oQid/MJ27i3UpA6GngAxisX+jiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8449

Hi Greg,

On 25/06/2025 08:16, Jon Hunter wrote:
> On Mon, 23 Jun 2025 15:05:35 +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.4.295 release.
>> There are 222 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 25 Jun 2025 13:05:50 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.295-rc1.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v5.4:
>      10 builds:	7 pass, 3 fail
>      18 boots:	18 pass, 0 fail
>      39 tests:	39 pass, 0 fail
> 
> Linux version:	5.4.295-rc1-gca8c5417d1e6
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra194-p2972-0000, tegra20-ventana,
>                  tegra210-p2371-2180, tegra210-p3450-0000,
>                  tegra30-cardhu-a04
> 
> Builds failed:	arm+multi_v7


I am seeing the following build error for ARM with the
multi_v7_defconfig on our builders ...

   CC      drivers/firmware/qcom_scm-32.o
/tmp/cc9gP1cd.s: Assembler messages:
/tmp/cc9gP1cd.s:45: Error: selected processor does not support `smc #0' in ARM mode
/tmp/cc9gP1cd.s:94: Error: selected processor does not support `smc #0' in ARM mode
/tmp/cc9gP1cd.s:160: Error: selected processor does not support `smc #0' in ARM mode
/tmp/cc9gP1cd.s:295: Error: selected processor does not support `smc #0' in ARM mode
make[3]: *** [/home/jonathanh/nvidia/mlt-linux_next/kernel/scripts/Makefile.build:262: drivers/firmware/qcom_scm-32.o] Error 1


Bisect is pointing to ...

# first bad commit: [0c23125c509b41be51f0d5acb843b079a098a40c] kbuild: Update assembler calls to use proper flags and language target

Reverting this fixes it but I also needed to revert the following due to dependencies ...

Nathan Chancellor <nathan@kernel.org>
     kbuild: Add KBUILD_CPPFLAGS to as-option invocation

Nathan Chancellor <nathan@kernel.org>
     kbuild: Add CLANG_FLAGS to as-instr

Jon

-- 
nvpublic


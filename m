Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011006.outbound.protection.outlook.com [40.93.194.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126EC3C3F48
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 10:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787740105; cv=fail; b=K3AUnggrX+Xm09YCaAtM4YAeO/7ZTtxHzt58AJq4vQzZ1qP9tKsYXPxlmqa1kmYXUGIk/OC5hlgfsNpKZqGSCrKhxUP9OIR9KX+fydTmcYiQ5ybMPJZ+29+1Nonq1w8sp1MX4LKgg5WwgiU3KcFzioH+7tAiGGbwKDb/v2M/I0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787740105; c=relaxed/simple;
	bh=RxU6uICSWDLj8Qjo8lwGsMoEFSn8Ljnm1FlDGuZvsIA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AZFvn4gf2dBcvGC/fj8OIeL2ym/N46mkR7ZUf7xKmUl0gr62+gDqnBmrD6AYzko0icXr164vvJ4gM27i+c0AZUxO3hel6Uyqy3UnOmYgqo/tCgcSBD2KDpJt6W5Ybq4L1i7HIR0plJwwNXub2/o5OSAQx+Q3xYgwUR/O9wiXZI0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WKqTZjhz; arc=fail smtp.client-ip=40.93.194.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WKqTZjhz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J9TuV5jtWpcrg+lLFHgmvuARLPwO7UtBGQHbJ6Us9/qkpKdEa8NhglscDIePdBmpLLkAwjICl0LyEALdo0gidWMeIUGcx4ql4m+X0WaOeudOdrdBaErCew5JFpBh6kCCL6YjvNpScijVnk46gUMA+fFyfF4GB2QbLaLOxxWwLlK0YI4y61bvd24iR/6VpeREW6M+k2EAurYeVwzmOohNrZiFgTubE/VdbkFmbdl5jhxnvSv27Jx/ct4ZSdilFfGjWBJbih24yiWnAzEKBIA+DaW3a8WLHYDscpJUKxBAH7tH/IJChl1h4XqRMhTSZkOg7QebVbGGP6mLTeHujEQh/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e9JoS8Q4yaUXxR+2yDfjJbwqrm2VnAILkNbyHMYOuU0=;
 b=La4ZpPUIG7Fn88SyBR/6oCQPiDn/QBL+L/MWD+NPiG6DtThtnM0iSEbR7lE6MPiMw4ttYbwQtC7cLB/72Ek8hWyvBYTk8hgLZGhw+VRGlwEhYwMtbRqnNz1ejTMiISqHcLgeiZG9tqmRo3wqzI6PNYiMxHort8sRDj7XNYtTG5Ro3W7g1CZFWsOe9BJMejGKk6Z/Admrm+Ler1NmPSAqEoE2EYNCtH9h0lcTuUfAYU0sTyvV5ltnCGmpbgYA24juIIvyrD7xPYysfKCpibp4UQi+DkJh53/xyznM83HDEvVaC/YFYr20gcfbR+dl/uJ1lUx3yrQCldoNnV/mh7ne0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e9JoS8Q4yaUXxR+2yDfjJbwqrm2VnAILkNbyHMYOuU0=;
 b=WKqTZjhzpZ7JuffU0fVbNcye8VVTEy2o12bk0dH/huAeLShAomlveOJ43IKwlAFZPCR/hpYZmRA87MLTfo9OLKNsfWyBDERkcZ2HrbfFT/xJsdzYAhjF7Mx8vf2/yE9kTSa79WozXM9HvCunFoKBrCpJU9t52aYOie0X93FGqEOIiH/8YjCfIaOO7wTdJu13bBhEyiMcoz4PEK55TTeTcBWul/ExGzHdHnO48QzUFdC7Ycpl0jDFNTr0nalPBGJIycGOOAfMbbAzgK39jGCoUNUZzcbMTyYYSxlzE756TzOSTHvop+vX3HXeskX0fxi9MDBh+jAJgqOioTIx/ztlRA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB6063.namprd12.prod.outlook.com (2603:10b6:8:b1::19) by
 CH3PR12MB7524.namprd12.prod.outlook.com (2603:10b6:610:146::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.8; Wed, 26 Aug
 2026 10:28:15 +0000
Received: from DM4PR12MB6063.namprd12.prod.outlook.com
 ([fe80::c06b:5df:6a68:1b06]) by DM4PR12MB6063.namprd12.prod.outlook.com
 ([fe80::c06b:5df:6a68:1b06%3]) with mapi id 15.21.0339.012; Wed, 26 Aug 2026
 10:28:14 +0000
Message-ID: <775e72f4-6c67-4765-bd63-bef5d520a156@nvidia.com>
Date: Wed, 26 Aug 2026 11:28:07 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/76] 5.15.218-rc1 review
To: Pavel Machek <pavel@nabladev.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20260825132541.568214149@linuxfoundation.org>
 <ao3uOPXs9_3tSs8E@duo.ucw.cz>
Content-Language: en-US
From: Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <ao3uOPXs9_3tSs8E@duo.ucw.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c8::17) To DM4PR12MB6063.namprd12.prod.outlook.com
 (2603:10b6:8:b1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB6063:EE_|CH3PR12MB7524:EE_
X-MS-Office365-Filtering-Correlation-Id: 2554da59-3a64-4aea-b9ab-08df035cbc80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|10070799003|7416014|376014|1800799024|11063799006|4143699003|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	f4GvE4/xB3dVrpJD63uF7oggV7epjRXtNViwbqL+g6xCPQM2ASPD41PH7EPupR0dfaWSgsgk7FOpKrrOm0ELmNlDjpVSyvoimFqf4kvkZwgf8RQGPSfe7lJqYfwBMLtfnj1gy8efoJjCBcixON3CZR6RV3T3k4PB45luRzcEuiiHGlOeog3ohVsLpAmY3nOYD5eUmDSNmR7yiprRbfyPkKg9wonFAasoZOAZfOU9vVmw7sxV/dTq4OZSF7NjD5pktFKVDIm2Hz9qfjj32OopktYlgcU3Ws0j2uPdWABsOXUaeY4tIunjeCSDdDvveAuWhHd3SRMmBvR4AYWsBfwTVAl6Wd2HmzlKdsYaaUkgf3EgJ/xWi7nsqSEwYq3pVpr0MefQ3m6tC0lAH8ywXgZ9MgmmaY+Hhmn7Dtdd85tW9l1/1W17ryUnfY/2Vj15z8xgPhR0QCJZTRaewcCQNkgXcORwMkRq65Jh2MQePnv0uLPLIduE1W2qsRGrZrGhgz/aGlKGqZ9PTcHy/ttLllSOndA9+yYxwiqv58tXN12MAOJK4PnhGjWMm6yoDoOn6UAi637EJCbG9fxDMCVdNmZ83xBihy9Vi2TPGxgX5RwtdCgs/0F4s5yO19lv2aJTzQhJwT4L2CPRIEcBtmZKyske+FwYryEIBjuCbU63woYO5Ec=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB6063.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(10070799003)(7416014)(376014)(1800799024)(11063799006)(4143699003)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RlFlMWlrem1BbElINXp4ODE1SVRwR2xjUlhZQ1RsWGR1NDVlVXVrVi9TUXhp?=
 =?utf-8?B?OUJjbytBMDRveEkzT0F2SUhJSThtUlcrdDdRRVVDRE5QajFlOTI2ZEpzMjF5?=
 =?utf-8?B?SFI0MmxXcklHUldyVUkxOE00SVRpK1Q1aTZlWlgwdUxGdjRMbDBlZEE4VjAy?=
 =?utf-8?B?TW5QWEo5SXJOb1BBaXBiSzFTYVZkckJaSE9qRURhOWw1K3NVVStGNlZpcXdn?=
 =?utf-8?B?KzA1b0JoSWZjUk5qaXRyV1d2SVlLUlZ5TUtxUWphRkN2Y1Q3eDJlL09aNkpk?=
 =?utf-8?B?M3BBbzNlWENCVWNHU0JBMGhJWHVTQlRiWlpxblgxQXVlTXczQ043QjJ2KytM?=
 =?utf-8?B?ZTU0eE5OOXd0Z0hHRVQ0Yk9PWHRjN3pMajUvbytBbnNhTUNZc1pnWEdWdk9t?=
 =?utf-8?B?TWFUY1B1OGpTYWVTaE5seGpNOVpDdmtJOU83ZHg0S2hqNXFOSEF1MXU1OW9R?=
 =?utf-8?B?NWlyblU2Wm9tOWNnRFhoaUdPbXcrZkVPMEU4M2MwZHY4aTgrNlRYMG90QTVl?=
 =?utf-8?B?YzlST3pET1JpdklJNXJrZUQ2eG5BREJGQjZFck5CWWU5TVNFOWkyRklrWS9F?=
 =?utf-8?B?VlJXVlhvS3NzNFdWaGhZVGI1MVdnaWtDbmpyQnRXRGM0MkpVcDFnT25HSGtr?=
 =?utf-8?B?WjhDeE8rdEt5R05jamNxb2pPTjQ1MXVrdXhmWTRqRVRSRGd6NTg2NDBtelNR?=
 =?utf-8?B?T1hXWVF2VGtqUUZ5NjJKLzArWTRuMmRwOVJEQWgzQi9UM0R0ZzE5emdObDJx?=
 =?utf-8?B?MnVFQzE4R2lCczhnQmtDWkZGdzc3VmprdHd4TzVUbHN4QVM3dmF5QkMxc0E1?=
 =?utf-8?B?Y21JS3pjMk1qT2t1YTBMT2x0UnJsbVZiQnk1VDhPRGFqc2JtTlh3S3ltK2RM?=
 =?utf-8?B?eDB4WnRnYWd6Ykxuc0hIWG40Y05IS2xCTDBDMnNka1l0UFoxeC9oV1NKeTRh?=
 =?utf-8?B?OE9DeDIrZHdPZmRWY0lCTDdXT0FSaVA0bGU2OHhZaFZVVnZvbzNuZE5zampS?=
 =?utf-8?B?MGlEZWRHcU9ZSVQydTFQOUtFak5vRWZRVkJmY2lQRmhVZC9Nc24rQTJrUU9w?=
 =?utf-8?B?ZlhGSFI4V2V2cGsrcExRbThJQStVWVZjYjNYVXFSNndFRCtUaHdsRGJ0VFZy?=
 =?utf-8?B?N21rVS8vWC9mUkxQWlY2M1lkOTlyYkM5YjJBM2YzVFVOaDNtb0pwMVVtSlAz?=
 =?utf-8?B?Q1JybFJja0lsK2lpTEM2UExpMlltRkRSSU9iSko5bTQ0cmJ5MGZtb2RRQUxE?=
 =?utf-8?B?UTlmREdVckkxZXhvV3hlSGNKT2VnMm5EZ3ZuZ1RLbmFzT0JhWm11cWtwNG9N?=
 =?utf-8?B?ODJ4Qkx5ejhlbmZYelplN2F2NURjZjdKTUlhRTZaSVhkODFjb0l3cjRPeGpU?=
 =?utf-8?B?a2FnYXZDS3cyWVA4VXR3VEN5ajhVSWJudFMxdXRmKzlHWGZNUitiaDRpa0h0?=
 =?utf-8?B?eXRJeFUraXRFRXlZUW5NQkNzcTZLWW9kTGxKODFhV1BmZVNVOG0raS94eGJO?=
 =?utf-8?B?YkhQOUtXZW9Wa1ZCbnFuVTQ3cjlDMnluU0lnN2IyUEFqdHRzOFQ2OVVhaS9p?=
 =?utf-8?B?aXJMUjh6N2FZQXVqRFVQOUU1SU5IY3ZocDFHZDlaL3o4bURwc2p1N1JURW1y?=
 =?utf-8?B?Q1owNFFGaU52Y0FNQ0ErdnNQNjE5ZjFQTi9uUmVZNDlYU3RrSXU0Qm1CRWJV?=
 =?utf-8?B?V1M5KzJ3ejRrV2ZLbmxBZ29ieUJMR214WFp5RnAvV08wZ1prRVI4a2tPSjFI?=
 =?utf-8?B?Wi9aZU1hT1lIdHpieVVKTGNkQXJHRTZEQUVRVEU5MzBLblVTOG9nVkkzYTQ4?=
 =?utf-8?B?V0twOVlDTnUyQmpLbG9aVHdsV2dMYlpTMUlKeVRsK1lyYm1obFFBSitpOTZR?=
 =?utf-8?B?TnVkM0xvcFhKamdtQmMrSjg1cWoway9KZ25LdWlyWmRNRTZOK2RwL3Fackkx?=
 =?utf-8?B?TmFnVEcvbWJGcEpxRVE2Y0VwODVHTjJpY2gzTlU5T09RZEY5eitNMTZpSGRQ?=
 =?utf-8?B?M2VNQWdlY1NVSFF0U0E1UW5vbXJhTVAwTkZpdFRDNWNCNEpGODgxZXJuc2pa?=
 =?utf-8?B?YnYvd3lDRkhkU1BaUmFBNFcwT3ZsNTMzT1g5dE4rNlZQeXppVjAwUnlhT2pR?=
 =?utf-8?B?aFdFT0poSUtOcEV5bG9qamtkcGtnb1h5bHpnbGY3U1JCckNCSXcwcVo5Z09i?=
 =?utf-8?B?bWpTams5SFZVU2VnMHQ4MWhGZlVaeVIyUkZSU3FSeTgvaGVjcmh6UjQrcmJo?=
 =?utf-8?B?WWdON294TkEvTmlWVU1iWDRvZVBIWlZYcU1BU1pjbzREYU0zcyt0RlhYZGQw?=
 =?utf-8?B?S3BHTjNja2JRdTZFd1J1QzhKM2cxM0Zlem5FV2tWMVowdS9FMjAwL1RZRHhG?=
 =?utf-8?Q?GMGH64+ra/+e9Ps/076ZdX1kPPoQWXyyUNZ13Ruousk0N?=
X-MS-Exchange-AntiSpam-MessageData-1: SNW31aiZ1JVwqA==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2554da59-3a64-4aea-b9ab-08df035cbc80
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB6063.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 10:28:14.8281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aVKosGmCE22QC2wzbvRafaCk0wjcQGgG3A/3xR83UBT3n+di3kgi6GkVeG32WW3VGK5WC08pHL8jj/gissefbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7524


On 25/08/2026 20:34, Pavel Machek wrote:
> Hi!
> 
>> This is the start of the stable review cycle for the 5.15.218 release.
>> There are 76 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 
> Build problems here, I assume it is same one as elsewhere:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/2789505612
FWIW I am seeing the same build issue for ARM with multi_v7_defconfig.
Seems to be present for v6.1 and v6.6 too.

Jon

-- 
nvpublic


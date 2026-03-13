Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012017.outbound.protection.outlook.com [40.93.195.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8223BB9E2
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 16:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773418705; cv=fail; b=X46T+Bfv1L/fpRWl7d7li1ikE4PnNgFjaoxgy/aryyADJPeDkGDQfGt3nm2mwAbdU3+/GY+gI8u9wj9ay8OuY6PWMOwHZexfSw60j4OtOwAfr2Jnc54ng0Po3N7KvhXxwgaFUF0k1BxJnsKJFltcDJ+EQ7mNcz0NpnVgpFgp4iU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773418705; c=relaxed/simple;
	bh=X7hixIqrVEcHDA414VSojWXdvyqJvSUh9bcpSZTan0c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M73MNk03Tc/uSgQvEUsAh/INNtb44PzBfVe6Ds2SroWGU5gG75gmPSdcMwCOf4RPhJWq15PzUqknZ+OEobkii8ZvhLSZvVZzlWYAQHEBuP+a+TPDX4XLAzqrZffEhUKECu9I3unvk+2sy9d6JCOVOptuxh4d6imPhTqDuQKpD3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I6exCdIS; arc=fail smtp.client-ip=40.93.195.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I6exCdIS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mQjFvnnj+Sb7xBMTzPqCu6kKQD5P13pAvd23jaKL6W2FQ0MF99L8hgwOItgsN8G4YVBD/tIAHe18P8QcKawbUhEBwH9wtXxhHYAAg/2xKLeAo1tC9DNqNyBgO4yqUu7gdzP0El3g2oJWlTa5F4ilEagAv7hqNVjhDZYLf9TeApzmLJ+9gHQOgwObmNgphYTfobug7IZOYrB77Hh3iHISkOYwoVeRGRjhJVtziqoBAfStoGXDKFO0EnLkr7vg+nHv7ke/YT50dYa1myvuIG/yII4VOc7r/o5NUNi9S4u6XwYvjlIVbECkkbfuc6XOJwjEng403l24Xle5T5+CRMTgFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wl1PAbym+fuf/S3GAYeIZKW9uB+j5kYR5/z4DeDs+qI=;
 b=WglOsOsaRDtP3m/qldCpjqG3mXBY9MB17isYUMqMHs4DMS/uyKsxCtpul9Y6UMF9nJF2Hj7O7Eq7Tbi1NBBlkBen4N/YH4rNj3WtEFIEsUv/GqAv4XwjgHc5OMFOSCMrcMf7pt/moMPWNB50IJBSiVlgcSNR5IJ3hE99sFr2JwL/rc+QnNMKfq2Dqs/p4qwy3UvwjuZ8ij6LtSWbOTvvVCiHfYktffl7PmN9w07JAe0ymT9/MjCy/Jpu9c01ajhOzYs23TmV8S/2JIUidbsWMhMGsbfN/VAKK7cn96vAZ6FwzSUBbU1ZCQX41oA+ygDN4gwEKDjJH+MYm/udlVFhvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wl1PAbym+fuf/S3GAYeIZKW9uB+j5kYR5/z4DeDs+qI=;
 b=I6exCdISpW1WSWA3WohJTEia4A6A3WacuBgmWm2cqGoTdTMxRDVbOsTaw4gczyIeblUzPFjWjVZAXuy2xK/+G+bQRLwRhaIxISD7TMBSADukFBdVrrhIb0KUTPye0z7m+vh4Xo4evaDSg0R6aOzPQjRCZaqJuPFjoi74GM5tlV/fZr3tMMgwduNZ+G0CFEg+SfixSXRb3IBt9ZD/XcvukMsYBXd3UpQ34mjamMjM/ORhjNjAt1QRzryFaWduw+f0EcI78BM2SfKFa6cdvizrb92ycskB7lJgy2j1rOVqT5vgOhBLAz4d6D2s2OmdsbHUvmh/jxdH6wF6JRcCSwRWyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS2PR12MB9750.namprd12.prod.outlook.com (2603:10b6:8:2b0::12)
 by CH2PR12MB4248.namprd12.prod.outlook.com (2603:10b6:610:7a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.8; Fri, 13 Mar
 2026 16:18:15 +0000
Received: from DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391]) by DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391%5]) with mapi id 15.20.9723.008; Fri, 13 Mar 2026
 16:18:15 +0000
Message-ID: <120f7157-4f19-4256-b3c3-139aa4e5301e@nvidia.com>
Date: Fri, 13 Mar 2026 16:18:09 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/265] 6.12.77-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com, linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20260312201018.128816016@linuxfoundation.org>
 <bddb3680-e01d-4eb6-b6b3-c7852ad1297e@rnnvmail202.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <bddb3680-e01d-4eb6-b6b3-c7852ad1297e@rnnvmail202.nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0142.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::21) To DS2PR12MB9750.namprd12.prod.outlook.com
 (2603:10b6:8:2b0::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PR12MB9750:EE_|CH2PR12MB4248:EE_
X-MS-Office365-Filtering-Correlation-Id: 78028d92-352c-4f79-709f-08de811c2160
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|10070799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	lP4SIc1gcKLO7Y6EnYOqPzkQcp8IS8tgTxrBBaYRopIa9brCX53ySsqzv4mP1bQ7clHbdJduTbNCRwqo4l8zXdB61dCrTnbenZ27Q0hToIcigALGeNvfJqFWT03GAYExBDvfuAXCt8iw/7ULWNA1rv3ucyqcY9SFtC9Wid0kWV04s3KKnuOJKk0i3mVSl2UC/Z5OafiMkeJObidXQyhq0sKmtyUwtJeUsMhgOMHoR+OhQA7jL7vqLP3bG39eMgs4ovHb/C7jN2yAdI6nbdsoTIlZNfUwX3eT6oncb5fKfnecl8nGM+6ae1msuKpF+wi3+4cRMU1Pg5IJgA9uXQCoR1drhSNU9bLCPFDgbHxjXdRaUDwYN4e6FWBtvarQ9nVssxUoz4bov4/Zqf4C94IXIg9PHID1hpk8BlWRWPa3HA+Sy9ySXXgA93QdVXMRZ3ks++tRKnS9geP7oSjSlEGGxsZz/Pvy4niXli+ABEu8L0H9gPPXXdC7hSZI1NQi3/ry3U9FngfX0WKM5ClfVB44B7H8lRWO+ye9plV1u18YPIg/QHv4O+K7Ix0aiBfZ9HvSHRBO5rP3BHvwZTisOROfbxAYCiyCXCUqurUg+MIQPEQZCpvwduwr+SRCiwQA+TJ1MzLtmiT5vbUtt7how4XzwsV1h13ZqhaMmZeCUdPyWCYmrf9PhGx0N0CDuf9dQbg/LKAy/PxRl+Pp+Wh0aRB294U54qS31ApiIIb7mpy4tzNISLNb9YeF7uITi33VKgZm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS2PR12MB9750.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(10070799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dTdIczV2VXRNelFGTENhckRIRzFMWDgzVlRrQmRZZ0RtK2lBaGRLNVhPS0Q3?=
 =?utf-8?B?UitlK2JLY0tvUjRFVG5ZODdHSVhNWGxDU0hBaVlnWGNsYWx3K0JuejNDeDl1?=
 =?utf-8?B?enAvV2RtM2g5NnhnUVZSYS94cnVmYjFOUnNnT2hMME5VYmNZaUZFK1BVUEIv?=
 =?utf-8?B?bVkvb3ZROURUNVRPZXFQdGp3c0p2alNyVWZtak1qWXkxNzRySjVaTm9ObUVC?=
 =?utf-8?B?Z3UwV0N4ZGpxUjlZKzRPdExQeXRYUThVZktyM01XbHlHWU9vU3F5YndNamxK?=
 =?utf-8?B?ZUl5VjhEQjVGNGFnaWQrWWNTdTZKKzVJUml2TnhVUzVHbmg4WW53aU1hc0lv?=
 =?utf-8?B?VVBRQWhFWGVmQjNUcE81aUhKSDhBeGVpRC81amIvWFhyL1ZXaVhSMXIyckMw?=
 =?utf-8?B?cDVsdFJsMmdZRGR5eHpadlU2eHR5Zmdua1pnbDVTOStMa21mQ0Z6QTVKVEhx?=
 =?utf-8?B?enR2dVdSMnM5bHBFZ25KL2JIRHZFMHBobXh0ZmJ4d3JENjFIT3NZOU1iLzlk?=
 =?utf-8?B?dFJRd2JGUUZScENFcTdTMVpWdWhsN2JKeWVrMkgvNlNSMVUwNXB6VHZ3VWtM?=
 =?utf-8?B?UXdBOCtPN0xYOXoxYlZoamhsSXkwRTQ5UVdWZklEUWtERHV6Mm9QL1Z3NFNK?=
 =?utf-8?B?T2dQb0tZNkoyamhNSzU3b2RGd0ZwSzh2cWlxUEdRY2xjVkhvM0tVT29SUG5L?=
 =?utf-8?B?MGR5UjE1azE4Q2U5amtyU2pVRXVsOFJ5dGxLVFZmRm9sOWVYbE1NYWhJQkEr?=
 =?utf-8?B?OEp0VHJteTNFMUlVem5WMi90MmE1ajZ0cUd4Mmw1dlZ6Z1hXcE5LVUlwK2RK?=
 =?utf-8?B?T2NBd2ZrQUoxU05VcEVYMC83d1l0djN5Qzk1elIrQkZxQzllNjZJV3F0U1Uw?=
 =?utf-8?B?UTVwL3R1UTJCNVdxU1ZaUE8zTTBYOVBtbVFCY0ZsRkxzbFVUTEVTOHJPS0hR?=
 =?utf-8?B?MFpubjhJNjNlVWRiWWE4UGk0N0Q5d01vMUFJMWxRMnhjS2hZRDBqSVdhdisr?=
 =?utf-8?B?d3A0TSs0SGJ5dThOK0txanRyNXVzR09aK0RPdWhkWFN3dlM5cjcrdWRFK1By?=
 =?utf-8?B?d2hYSUVXTTBZTU9RSVIyL3NlQUR1SHd3ZlpSOGJSVkJ4NXRIZVpsWjEwdmhw?=
 =?utf-8?B?TUllSTVwMzk3QWlYa21EUUZkZEhGR0VkS0lLRW1hN2Mxei80MFVMWHZsOElL?=
 =?utf-8?B?TXczcG1DcXVOS2hWcGNub3pYeUtRK1M2Q2Z5b0NUbFJEMGdJKzFQSHNOQ1Yw?=
 =?utf-8?B?YUQ5ajRaNDVxT1Bhb1NLSS93QVY2QXoyNUFJZGtCTmFjOGErU0s0NFJ0aXVq?=
 =?utf-8?B?QVNaVEZNcWVNZkJHVEtycjFLdmUydFpLYWk2WCs0M2VvUjU5UTJJVFUrRDV2?=
 =?utf-8?B?TzFZRnowbWpUMlhYN2d6Rm9iV253TFEwS3lSUWlMMDRrRU5EUDhwY3FYNDZR?=
 =?utf-8?B?SGVIN3k3dHFJYWdqamYrbkZLQjRTOUFvL2pSbHA0TUFwYkJ4MG4zNjN5R2tR?=
 =?utf-8?B?TlgveVdTS0ZxVWlRWm9tazl0KzJURlNrdmd0dDZkajVmYS9PM242TDFza0dY?=
 =?utf-8?B?cVJYVG9NYWZXaWVoNzdDNnpKT05WblJMNjNvMENzVDNQVzdLS2VIRWlGUy91?=
 =?utf-8?B?SXJGcDhwdDdtTmNLOW4zUUNEdW9vRFlYZlhwd2V6OFNySkU0Vkh0TDFvd0JI?=
 =?utf-8?B?MW1vakVidzVKRmdPK3BCSDNSMjI5ZmEzUy9HenpheHhvcFB1cnhUL0xQUERu?=
 =?utf-8?B?TEpMWlVvOGdxaHRWcGRaRGs5bmZVZWdza2JMSVV1UmhJSW1VRFR4cEVtT2g3?=
 =?utf-8?B?UnFFaUdGZk9iaEZFNWE2cnZkSytSTWFrRkwxdDVzNkxaVi96Tk5BbHF4Vmlu?=
 =?utf-8?B?bHZoK0lBYkZud0UwYXg5Mm8zRFczQ1NtWGFDMmU2WlhhUmo4UzBITEFRV1RJ?=
 =?utf-8?B?MzN5R25jRTZYZHZuYm9hdkcvdm9jeGhxWG1oTjJmb29BSTdkbUpjRW1xQlpq?=
 =?utf-8?B?OHRjbUZaMGhPTStKUHZEbVhqaUo5VDhHd2FUa3NIOEZRQktRdUVPeVBwQUk1?=
 =?utf-8?B?b3VkRGtMTVlZNG5ZaHJvNmgrWGRxZ01SdFU5VHV6aHFaRUFaTkNZZXZ0cHJW?=
 =?utf-8?B?VlArK0MxVmJ0UUhxQWV0N1huYjRNMnUwQ2xCSnJTenlRWFVMOHlGZG9yVGx0?=
 =?utf-8?B?azRPeHY3N2ltU3VqTVZ3RHNaSThhbTBkOEhFYlVmek5iVHZmeGtCVmtFYm00?=
 =?utf-8?B?Z3JJeTZOQjErRHBzOWdWdzlWQS9GSUs0ejlBdlRFVy92TGM5QXF2Y2ZsMTVO?=
 =?utf-8?B?L09hbFNOVkkxSnowYW1oejNUTHdXNWFzazZJTWRLWWFiZWVjZEFsYyt2bGRi?=
 =?utf-8?Q?SOUPYZl3lKCNWdGE+F1/i4hnfcexFnGaNDvO3imjajviS?=
X-MS-Exchange-AntiSpam-MessageData-1: M5Ww1dhBUmggJA==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78028d92-352c-4f79-709f-08de811c2160
X-MS-Exchange-CrossTenant-AuthSource: DS2PR12MB9750.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 16:18:15.4372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N0zdrrokZzLNQ8J5N0+wDPI0NBfZEoGzWZb3SXAK4qwcJ3X7eQThF7lQ8RfhYnWuat9hzm3RmBiwBdiedKdS8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4248


On 13/03/2026 16:16, Jon Hunter wrote:
> On Thu, 12 Mar 2026 21:06:27 +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.12.77 release.
>> There are 265 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 13 Mar 2026 20:09:29 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.77-rc1.gz
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
>      11 builds:	11 pass, 0 fail
>      28 boots:	28 pass, 0 fail
>      133 tests:	132 pass, 1 fail
> 
> Linux version:	6.12.77-rc1-g92f326b98fe0
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                  tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>                  tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>                  tegra210-p2371-2180, tegra210-p3450-0000,
>                  tegra234-p3737-0000+p3701-0000, tegra30-cardhu-a04
> 
> Test failures:	tegra194-p2972-0000: boot.py

This is the same issue that has already been reported [0].

Jon

[0] https://lore.kernel.org/lkml/1c54210a-e197-4eb9-88b5-2ed2589c7230@pobox.com/

-- 
nvpublic


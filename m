Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010024.outbound.protection.outlook.com [52.101.61.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999EB522F0E
	for <patches@lists.linux.dev>; Thu, 15 Oct 2026 13:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792070234; cv=fail; b=ataCb4NdJTqH3e/sD+mlOcyK08s8n4TRpuTco/wsPtS2u1TztrXpz9kEi1jNMvN0isORwbDrru1Rv7PBKstMWeav0OyX1+VITREO62iznbAclHOkR07aUhwgmootH8eVSlXWzv+03tehyIIzoTHI1ENbhDPkVORX1zQ5sYo9X+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792070234; c=relaxed/simple;
	bh=1YekbLDcKMiOZvviEyiCeKKxdCvzxiSSzMRqIOTyZxs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HWFBf6VVBGC4U9MiFXTKh/OQ2KsVHwN4wKYxOnscJFIjCYMiwj2v/Ahh83tqWDgvWUUQsf6ph4U+eYwjvHTKG1wiAoaKpevGSFBNeSp7nlw2E2OjdzfpSm5UqEGwCQRJZoN82CvgUQoQOz+atr4gS8FRC9kU1sbKGNC+PjO0tbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fKBtm4lO; arc=fail smtp.client-ip=52.101.61.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fKBtm4lO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uKL7dVhfhh2bOJ9bRTj/A80w36LAjnWiaYIE5n1L4XzIE7gLmkWMnvf7viOewthH4ZOiULkDBvHhd9qsrUCNzds5XOu0ZbWiHIwbkQooLXU+tnQ4Af+ZmU+kBlZ9PJVtNJQyXbaN+hviMs07genJDUfnFGkNXhzA2rZwO5QRK7RK0Jli6EkVPUURfytxE24VkzUP2uXTIj90ANPkMA3G23YclIl+dWz20uA7dgZnJJi3/F7SdvYd4okYQpyDXpebRJENgjiUmM35yJVOH8BnBiikGkw2fEq3PwPmDlVhfVqwCe8kinSCo5ilpeq3tqQxHXo0fjqGbLr2sbAoP65Uqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BcMwRtZH1blQTrFk38+4CniTCFrMHlcc7yPE73KbSZc=;
 b=wwZ62uj8YzcHcZOkTq0EqvzmoIzw3euqaMm2Rc6RljDXTBfUbiY3195xQaGQPS8cZsWbhwEhOYjZcG6rXl12ajrFh7cKYN5gz3CvPv2HuQSL0i8qwcvOi6HJcyDo7jPk25FXiT+YSbnQFaG+Jz2dQhHrYzsJtCUw77bx+SBVS82BjpV5WHIahRke3ZD7lYx75ygvBfFperykrUCvzFtzNIOv2o+W2FpdlWgsWGfTRRH3KUm8r42L6cr8BIgwbyu8gPhEJwHUnqYEMdN0AhzJrmcH98L2YJNdN1XIv5vRySdWBkjwcYb1r2r/AhMc64oDnCeBtJ/VSr+J8Cn/SGFwnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BcMwRtZH1blQTrFk38+4CniTCFrMHlcc7yPE73KbSZc=;
 b=fKBtm4lOVN3b3wbeZxus8R5GS8wA0Fy0T3VeuEpyoZ3zdZE+eoASEn3P4hs5X6/NU/0iC86e8D4XehyCT1g8IVJx0zrAZSvj2R2hw6IhdVh8YeLRVoiQsp+UCbV/opKoh+MlldexOYM3N3lJy0SWm3ntL5MhtUZf4XWMxXHxNYosXvA61C9VgtGvRxs4omPTU7//ZVSv9r812qUP5d7QRuO6IXhepDU6lSFZUOWbgEtXu/57ZtjZPY7M+GVZaEip9w9+DEfINg8HTgkxppvirWsqL9+vtWfCZJt9MhdlZNygWcGzmZLOZaa0yK5Kwo9rUmEOf77XOyY5R7LdYoM7dw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH8PR12MB7110.namprd12.prod.outlook.com (2603:10b6:510:22e::11)
 by PH7PR12MB6954.namprd12.prod.outlook.com (2603:10b6:510:1b7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Thu, 15 Oct
 2026 13:16:53 +0000
Received: from PH8PR12MB7110.namprd12.prod.outlook.com
 ([fe80::736a:e1be:ec64:5740]) by PH8PR12MB7110.namprd12.prod.outlook.com
 ([fe80::736a:e1be:ec64:5740%6]) with mapi id 15.21.0496.021; Thu, 15 Oct 2026
 13:16:52 +0000
Message-ID: <2a5adbe8-ed67-476b-bffd-169c8c50f686@nvidia.com>
Date: Thu, 15 Oct 2026 14:16:45 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/632] 6.18.57-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com, linux-tegra@vger.kernel.org, stable@vger.kernel.org
References: <20261014123820.008483134@linuxfoundation.org>
 <6d8a0529-033b-4d81-a2e8-cf735e9a4b7b@rnnvmail204.nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <6d8a0529-033b-4d81-a2e8-cf735e9a4b7b@rnnvmail204.nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7P223CA0005.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:338::7) To PH8PR12MB7110.namprd12.prod.outlook.com
 (2603:10b6:510:22e::11)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7110:EE_|PH7PR12MB6954:EE_
X-MS-Office365-Filtering-Correlation-Id: 71590b08-b3a5-4db4-d38d-08df2abe9421
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|56012099006|4143699003|11063799006|22082099003|18002099003|10067099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	th6/KDxHDvaUd7kg/9OJe2OSf18DStVOE/f6wnLk/NpksgXN696gpdss2kA1l7pWECNZAp4I7UBx7nOiRL1UloHpuXhakPWn6jWv6CtqXaqzYBddhwZVNQ2DroaV/DDi04a3Cgm3fGZcexIsCmaZI7jJVX8Z3b8DYQ3OT21gxd8vqiC0P13U4xHBLvuPqzQbfDzmlrwybz07VZQYJt0Gim4I+lchCypHLX2JmV9V1nndybby6WEBovKE40/lBLFMNJS5YT439HWk178NErDJ687y7p05r5GHSVsOQ7e9qhyjfL5aCbKdXfhXJLBG5/Wf06IT2C8K7Roh2cRrCE+H4nXPnb/Z2jx+QYusc0Bus2LauWH3xcZFn1Vqy0jX25yrw4vFn8TLZZsPegqyEewQfGwUk+urqKAh3vQ0U0uEP9NlYuIaI4il5FdNaVdQ0y7zLrq0Qne3eTkPRlH44I2BVQbnu5Fh4CJMSVLqMh5R0GhRcLvXRt23Hmal84iD/N9qHizAsp0LnwoGw1iVt/hTGIuwQ72UC3lWdAbtnXnEY9XBdHXqPR3mnj0Zf2YVwOCFLfZstSTKtd2H/06L5KB7ItuYKFbGS0y65ZD7HeluYqy6WTtCTJoBXoVefITgjTd8q+C1Wpx6u+aJl58+8Lc1XPsQNhilToDMXRNEW1y57nI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7110.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003)(10067099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0l2d0ZFRUhtWHNaWC9IK1lhT25sbnVzNFpQeEFyZlhjMzFValJDT212dGEz?=
 =?utf-8?B?MStIOW1sVnQ3dDhTN3Bwb29LSWNTNWMraEozWUJKUmoyQndvMGYxSGh2Ry9E?=
 =?utf-8?B?YUVJOWdPU3N1d2xTdDJ5Yml1YmtHa2xia1d1aWw3aUFEYkpUTkxVN3dibTZS?=
 =?utf-8?B?MHRDOEg2cTNMUmk2Q241ZHR2NVdIUE43VE9sc0JBeEZyY01WcHppNGFRUUt5?=
 =?utf-8?B?dHg0OUt6NHQzK2puWFI1Z1daWEFUdjI4K2RoR3AyNFBwTGo2SmlyZnA1ZHp2?=
 =?utf-8?B?N3JLc25GTGFQQW50TVBicXpUL2l1aExNbkxKSGxCdHE0SGNUR3pGT2tPWFpB?=
 =?utf-8?B?SWxJZ2hGeHp3Kzg4ZllTYVAwNkJLd2NtYm9YNHNPWSsrd2piVTVwMDhrOElV?=
 =?utf-8?B?dUQvVStHc3hyd0R1TStFUElMbEtyTnVycW1vWFh3dXNJZGNJS3hyL0EyWURs?=
 =?utf-8?B?dForSEllN0FsSmI0UGpXeFd0RllRVkxINWRPUldZTEw0VUMxbnNmZ0VQdkRw?=
 =?utf-8?B?ekQrOGRzL3RxUTJ6ZER1S2Y4RG5uTVlwYk9XaHJnekxsQ24vdnVRbTRkeE0v?=
 =?utf-8?B?UTU5aDFydUxadGU4cG4xMVAraWpOQnc2cGUzalBUU1FYbUJlMkFWckVWNHNo?=
 =?utf-8?B?QnJreEQ1eHdocFhpNVJYZVVXWXl4a3BuZFo0eXlXZUpRbFV0azdpSUVoa0FV?=
 =?utf-8?B?SWdlbFhkUk1WTEE4cnZsT3lEMkVsa05PcDhya3c3V2EzeW1JaWcySTVBUytB?=
 =?utf-8?B?TjZCWEZ4WVJNeHlVWmJjZ2hiRVpnNUIrcGtPZ2tudnE0NUYycUxlSTNkcmlI?=
 =?utf-8?B?N293bFRSMDBRNWtLNC9HbWxzNFROU0VtUlJaTDNBRXg1MXVTZ00yZDN1NFk0?=
 =?utf-8?B?UzUxWG5HMm40U1ZFakNleDhlb0FtczJKMVlyeERqMmpTZVRZMERSNVNLMlEr?=
 =?utf-8?B?TTB4R2lRTEFHNXdSSjVkSm1sZlUzbk5PZzhBay85bGYzUnZES0RzNTA5d2xw?=
 =?utf-8?B?VXNRb0hNT3kvci9CaDNsa1BUTW9ISzJ2MGpZRUN4alFwSXJkZ0tKVFYrNVVQ?=
 =?utf-8?B?NVFNeU9ubkYvRkFEcEJOS1N1cTFUUHJ4U0Y4VHJnVWdNQ0E2YStVZU52SnJ3?=
 =?utf-8?B?VlU5Unp4QjNEYWRQRXpZWnhhalFFTWVZTlltdzE1Tmk2V1JEZjNlNStoNE9t?=
 =?utf-8?B?Qy8rdzB4TVJwdmtQZXU4ZWtyTUQ4c3k4NDZzOU9LL0FmRlNDNEZVOWxUQzlO?=
 =?utf-8?B?UmR2WXdxazJ1NFJvc2hyQXdtVVJzUFF1c2twSUI0ZW1lMlBieVJCT3lzMzFP?=
 =?utf-8?B?MnArM3FkUHB0MXAxSm5QUk1nekttMlYwTjczcVZNZldoOHNXK3lBdkxNSWtp?=
 =?utf-8?B?WE5VYUpYTDEweG5KL0ZMekVPMEg2V2Zqand4WEkyc2VDZlk5alp3a29OQXhQ?=
 =?utf-8?B?aHdxK0tPYlJDaktHak1GUkxGaCt1Q0JoQlBxSzBiRDJuN1FxTVRSeC9IZWc1?=
 =?utf-8?B?QVVUcUtJVVpQODhyOWVrZlNNUzdEVVU3a2VLbFNsandIMnBLQkJqUkwrdjRj?=
 =?utf-8?B?Y2pSd1lzZnR1TkdyZlZFYnJ4OXlna3pIdGc3ZnVBcEdBL0VCYjlWeTB1RUhL?=
 =?utf-8?B?N3lQOE9yQzdGT3BXajJTakxIeWF1NHFESzRoMXdEcFR1VXRTZVl5MEc2TGMv?=
 =?utf-8?B?eDdrMXRWc1I2d2srQ21HNFVQUFBDbGZ4azlxc2dNWlFEWngrZ0hxNWpDeE5t?=
 =?utf-8?B?a0dQSzhJY0JkOGF5b1N4TkVGZlFwN1p6Zmkwb1UvRkd1bmo4UGRDVGdlaWVw?=
 =?utf-8?B?Vjk5UllrQ2k4aS91d0dybnpZNy82TFdjWmJoSjNPa1Z2cFQxMlFtNkxBZzVq?=
 =?utf-8?B?OFhSaE5UdEtYc2s0ZnJvaGxZUVR2RUJwMHIzOS9zQ3N1a1FqZDVYTGRYLy93?=
 =?utf-8?B?U1VOT21mSGxCbkcrMFZFMVpEK0lDQXlkallwaUNCZ3NnTndoc1dVbTgyL2Uz?=
 =?utf-8?B?N3l1ZUd1NW1YNmZQeWxpRGI4ekNybEhHSm5vTXR2RFNVcXppWWFYRWRtSWww?=
 =?utf-8?B?Z0xhek1yRU9ZR2pqc3hldWJQZTg5eEtNNlRYZXdaeFBmL0d5clg3TUNsU2pD?=
 =?utf-8?B?TWYrRjF3OHZkUHljZWR1L3hQTGl2eXBSVXJYTXZiSzJqTFNEVHRwNC92UGw1?=
 =?utf-8?B?TE9nS0Q2ZVY2aVBzNzVQeXRnemdlajdVcUlJK0RDUFFMQ2NaNENjZkF1VUx0?=
 =?utf-8?B?cXhhSlVmeU9TSHVxa2RzVXBIQktMcjJ4c1cxTTFaOE9rVnVRV200VXdiWnpz?=
 =?utf-8?B?cGR6NDFET0xYZHpvMERzMnd6Tk1WT3VaVTQvanNUMDI5Y0prbHREUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71590b08-b3a5-4db4-d38d-08df2abe9421
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7110.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 13:16:52.8366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pVkKR7gys9WCp9/6qXSGd6Vp+htx2TaDUWwMXJx9zZ8toZ6vkWMKP/d1Gzt8ZrvxP+nPrL+f6A1fdMmU1upENw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6954


On 15/10/2026 14:13, Jon Hunter wrote:
> On Wed, 14 Oct 2026 14:50:40 +0200, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.18.57 release.
>> There are 632 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri, 16 Oct 2026 12:37:22 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.57-rc2.gz
>> or in the git tree and branch at:
>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v6.18:
>     builds:	11 pass, 0 fail
>     boots:	28 pass, 0 fail
>     tests:	163 pass, 1 fail
> 
> Linux version:	6.18.57-rc2-gfea86ab6861e
> Boards tested:	tegra20-ventana
>                 tegra30-cardhu-a04
>                 tegra124-jetson-tk1
>                 tegra210-p2371-2180
>                 tegra210-p3450-0000
>                 tegra186-p2771-0000
>                 tegra186-p3509-0000+p3636-0001
>                 tegra194-p2972-0000
>                 tegra194-p3509-0000+p3668-0000
>                 tegra234-p3737-0000+p3701-0000
>                 tegra234-p3768-0000+p3767-0005
> 
> Test failures:	tegra194-p2972-0000: boot.py


This is the same kernel warning reported by Peter Schneider.

 WARNING KERN Driver 'ufs_device_wlun' needs updating - please use bus_type methods

Jon

-- 
nvpublic


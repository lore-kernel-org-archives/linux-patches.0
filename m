Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012057.outbound.protection.outlook.com [52.101.53.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0540332EA2
	for <patches@lists.linux.dev>; Thu, 21 May 2026 09:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779355142; cv=fail; b=I5XGYRcKwumyvC5chOQiLkpMioodYbfd+DYvAELbuZGKEKg4KVuB7tRgul7NNerW52+VdQ/G3bclA0WGZHi0xHsxhbWkw8CmZ4Unya7u+SRA4Qht1FsixMgVaoavMjIyTTM6M7W2BPqbLxwGrvtS4Nk+74TnyapZvpXhQ5C6htM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779355142; c=relaxed/simple;
	bh=CuCIgDibJojUjZHOfl/xEN78oYrWKT2+v6B62K4kL2w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lV5MEy169MyU5o+wPysA7WoOEwKq62XtgNz5H0oNX2AL1tgZ4ydKSSJmdqIT2qVUh99IdswWFtGH4j93rCwbWvYQtwdJebAXRUZ6rAA/9fKRqDAcqPJ0MdLjDjrgTDkftoG1FUafuHQ89PVJUUBflifXnrj0mCxgTqaf+gy7LoY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D1qgFyM7; arc=fail smtp.client-ip=52.101.53.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D1qgFyM7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a6Ee0mxBdcnZX+q2hsW9kLkx9IQM/ANWSxyfoy/Sm/hjWrZQHykq1BJOGmyyBTWBsPERm8HPbw9sJ4aOupttM+BcOCbcGBrH3Fy7GXDaqe6VTV14KVlYJmoMBwSDiMiXeNWxjb1qIAmpSaOeBFe0azzlHjZfixnnt53T+KYlOeZBQVXNTV0QwAR09Wuhp3DUnWYXnzxD1nsySN2IaJfHFSAtRjqNWtturoyjz2OzIqGbaIHDvQLC4GVZiJ1HCvQbJaGrkmpyujshA6zyzV9oRA/1ijs55BuXhV2aIyHKVwWerw6wR+LHtWZ4aRdJRxhlmhFHKdiHKpDh2iEPuZ1g1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N5TXRUS7NaBx0RdYzS85Q/0rrSyXCc4xq53bP15r/ew=;
 b=j5b2DWkv/5f+jyXwjQLdVGDyIFrlq1Sdlm1jknnbNuBDmYX6hzHF3stRt6Sidwx1R4r663a2/AFin0Jj2uaJ0ZEfRuwKE/NEba5LVJLLGgtr1w6NQrE1l2De9wNBss/ZiLe0hls5qES2OW3vd1qGycdtXx5vFl9ZDlfUVq5gLo5KN3UILcVTwtF2//7/Z4knudOe0MEMjoYoykc8OMiez2x3p27l+idfMDj9nWoIRKP8ZaY8WUrY2YrdHYxBgr4aFSmtJKAoHTjWQy8JPgKK6/Y7KzeWJ20Ouefe3YXRu5zs0EwVgb5C25y62yNLrSAW78suBy4SopAuILXPuAJVDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N5TXRUS7NaBx0RdYzS85Q/0rrSyXCc4xq53bP15r/ew=;
 b=D1qgFyM7IcbnPSV7ZVaDf6o5jYyVOI0BOcsUYMng4yfHM6dTSNuyoKZNHPG/gwdE4cPL9ZLCp+blsRukVZjG2ozZvzGRChblUyKYq1WScp3HUTCU4mudpeONcFZlS2ybMGmAlahvCWQgNfKeOMBntjdLJiUGiWsfOvlZr9vO+XJ+yqxKXrQcRyNPtKOznOofSBPOok3g60BBDzfxz9FytLReDNvagCs5SKZk7N9v4S1wTl4FcnObhhKtbnZ5zMG8R4cVgQ4Givt2NPPC9LkIhmA02phc1+hfT67+HaLCvqgOcQgxoTbzueBeyxaX1hy0LwhgCPd5KycB8j2SK0QbOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS2PR12MB9750.namprd12.prod.outlook.com (2603:10b6:8:2b0::12)
 by SJ0PR12MB6989.namprd12.prod.outlook.com (2603:10b6:a03:448::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Thu, 21 May
 2026 09:18:55 +0000
Received: from DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391]) by DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391%6]) with mapi id 15.21.0048.016; Thu, 21 May 2026
 09:18:55 +0000
Message-ID: <f0858c30-40df-457b-a2c6-820600800f76@nvidia.com>
Date: Thu, 21 May 2026 10:18:48 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/957] 6.18.32-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20260520162134.554764788@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0138.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::7) To DS2PR12MB9750.namprd12.prod.outlook.com
 (2603:10b6:8:2b0::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PR12MB9750:EE_|SJ0PR12MB6989:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bc84d85-c508-424e-209e-08deb719fb2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|56012099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	IvfS+tAcmak4T0Srr+lEwi2FekiYlh9znu7OplzwEVzt9D+WMvcjeoMqbKpdN7xIPYdKCD6NtWVkTs6dTeeBtljVOwP4ifx7mEGTLcuP1ZbWEBuR2SgX0stnjmVIGLhazy/LqD3Yexd61HMYb6+aFgCaxjIF98dlJX8aMTlw2sh14yxDtVyeXtKxc/t+uoZ3COL5FTWc0ieCqHKt9a0UH4fIfiLOoRfBFlxYq+Np9Tw2yLUfV50t8jVDkii886xJvkeawtIYMZTCIwWkNcDAwYNyMAJjISdh7cMiuMOZ5JDUmEhFsK2UT5/v5o+r+gqVNzF5VqeX1kXGOgY3tUtCulkv+YW8IcppXoMIvcUzKO1k4xFvzB59w+1FFYNOox079M97iSm51mIV/LAKhpKzvzn6EYhdwygw44JKnUYYq9jpydDcRx47NvAPleFcGOabCgXscuqgx+Xo3AavsxQZi44yeLFrkqrC7yFjalVze9K5iiavUsU3lvzIRpq2TriV3aywZIW44wwIe8FHhEdLg3HQMFPJyM6JQhwlExYq8lgB/gK3gbYZ66omDoz8aankoRQElEaESS9Wp9uXnLsV72RwSev3QwGc2ouy0ZEfvoqEx34VYcNdIKhL5cXiJAa6QDzlTc9jXD2V+aZStuRf9KjomIvGR1v88NX3EIzzKlQe5EpuVm4Hohp5Idar8R8VcS9ZebdifLa23I207zQqjA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS2PR12MB9750.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(56012099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q3NhQit1VXEvUEk2OHJONkl5UUtDSFhYUmFKZlRraVBhak5nWTFQNTR0Y0dn?=
 =?utf-8?B?SjAwbWpYSXdWc3EvTFJiaGM2OUY3ajBJeFJ1U1pXMUd5WjkrN25GcStlbHVR?=
 =?utf-8?B?TEVlZVBRQ2ZqUk41V0ZicmZLZjlXTitiS1dIaElEekNTajExUFNKRmliOHNn?=
 =?utf-8?B?TjlRNHg0cjFoVmlueWViRkdUdy9pcGJxS1RNckhYdXUwczNOUS85MG93SVVk?=
 =?utf-8?B?OU8zMVNHNkFOazczenpkWGhlQk9PaGxGY1orUWQ3L3o1QlRmZk9SMnYxWkJn?=
 =?utf-8?B?cGN2ZTFvU0VHQUp6SVp3clgzYUdVL2tDL2hPYkJaQWh1UDMvV2ZobDl0QVMw?=
 =?utf-8?B?MTlYREt1d3VQTWdZK0RYbkw5NEVkUWQ5cExpSEViaVRyd2VCK3Y1RnJ4NFRu?=
 =?utf-8?B?RG9rOHRwTEhYMnd6K1Ryb2l0UEJuWENKS0NYNWdlNkJTd0IrQnB3SjFXL2FJ?=
 =?utf-8?B?THF4T3BIMTlHNDZwNS8xQ2ZDY3RRWVF0SFBLYWM2REllcXhVRXF2MWJhQXNo?=
 =?utf-8?B?dVgvNzBMeXNpS3BFYVA5RUF2aEx0RjJqUzRDdm1VZkwweGRxSHJpZ3ZTLzRk?=
 =?utf-8?B?VjNDQklwSzlDWWdBUTZDUjVsKzBwSzhRc3dKdHQxNjR3a1NKenR6VDJDYVRn?=
 =?utf-8?B?MDBkSEpEQ2s3SVloVmVVbUFtQ3QxaUJnSkNKd2Jkc0t3VXNVUlVJSElzZ09m?=
 =?utf-8?B?WE9uTk90bzI0SkZwd1JVWXhxYmd5SEFOcXU5SWw1NFBTMi8vQllGWUZFQllX?=
 =?utf-8?B?dldKQlJDVVpYZjltUVI0UFVYMzdzNXZIa0luU0k2Y2kzNW95L1dra3BhQnlU?=
 =?utf-8?B?TVlJWGl0RG5YR1I3YndpMnI1SjFzNElMNlp3M3NXcXVUZzVxQnluWFJPWXBX?=
 =?utf-8?B?Y3lUU29rT1BvYkpjcmswYkZLZHJPUW9LK2J2YzMrNVFwSjQzNlFwb1cya1p6?=
 =?utf-8?B?dC9xM05UZ09iOHhJTG0xeVB5dENDeDhFVDBaV2ZldG1jN3Y2RDB2N2FtNGFp?=
 =?utf-8?B?Ym9VL0tuSWdRbVdrUzdIVW8rQ3FPT0dpaVQ2ZHNIZHM1VGZneGxTYnFNNnU0?=
 =?utf-8?B?YkNMaGlBNVBia290SFFSMWxDclJlSVVyMWQvZytLZG1mS0MvMURjQ1RjV3g5?=
 =?utf-8?B?ay9QR2ZjaXN1UjdYMnBmeStEY2lxL0p0d0pua01UUUY0WDhidm5UaTgxYjZ2?=
 =?utf-8?B?U0VnNmszQWtZdm9heXRwWG1OUE5GQlZuT3czMWo1ek9YUlRxdjhYd3J4dGt5?=
 =?utf-8?B?UkJ1TlpaZHI1Q1loTGt2aHRlZVpUcWo3TGdnNE16dmxFbG9Cb1dabDg4ZS82?=
 =?utf-8?B?ZlBLd0k2NE16UFU5QXhjWVIvUFFnc04xN3I1TFZPMmJKR3Uvc04wN2o0ZHl4?=
 =?utf-8?B?bG1EMUsxazZ0U05Kc09qZDNyR0lzQ0hTQTJta3JOWlpETURhb3BtdzZ3amJp?=
 =?utf-8?B?NkU5SThxc2Y1RkR4WFhtbXRiZGFnRmRUQ29XUW5jWUhXTDlMMFI2K2V5RzFw?=
 =?utf-8?B?VTg2MmM4bUY4Mno5OFlYYnM0cHpNVDdkRncwcXZ0NmMyVng4NnBrZ3ZjdW5j?=
 =?utf-8?B?cEVFOEJRU1lXZkZHbnlmY1ZmVUZVdlBlbUllZjlMa0hBQTBleFRvNDE2eHdY?=
 =?utf-8?B?Y3pxWkljdVdFbTFSSjJWZW9MZVgvd0plaDZjOXI3dTJaRGxZZS9yZ01KSzA4?=
 =?utf-8?B?WGYzUnNiekhhMXA0U3hhcUpON2x4cW5ZOFJENDg3a2JHVWlVUWs1L1E0OU5h?=
 =?utf-8?B?dUZ3SnN1NFlyVTlsTzQrUFJlT0p2ZUtzQmRlMUMyQVVUQTRHUlVUdGYvQWU2?=
 =?utf-8?B?MEFsOGpFT2FwWEU3UVZUV25uS1V5L2krdDcyeUNVRUtIWllyWW9HalpHdU9H?=
 =?utf-8?B?bjd0bmQxV3NWSm0wQWRTSkxEdFExSnhZaFR0bG13SEROWTZicTZ6OE1kMGo3?=
 =?utf-8?B?ZzZQRzlHMHRqK25ZczB2eWZlTjFnMUJtOGpzeDdrZ2lXT3dabTdSSVZKK1Fh?=
 =?utf-8?B?VVlOSHNpTHM4RkFobW5tVCtxSnVlRzdTbCt1UDlKTzZQSEdRU3RGTEVsOWNj?=
 =?utf-8?B?a3NmRlhwNHhmMHh5TWloWFFTbnVnL2Fla0YxWUFiaXZNeWRQejRwcnM5cVBp?=
 =?utf-8?B?MURWS3U2M0Y0MkcvUGI2aE1qMmgxWDliTWxmRnJiK21ZZE5QK2tWUyttYW5F?=
 =?utf-8?B?blpjVzBpRllvTHB4Zi9rS0J1dzcxY3F3VU9mcGRBMXNQTVAxaitCaUhTb3RP?=
 =?utf-8?B?SEFPYVA1SjFKMVZadFZFU1ZKTnFhUjlPZVBGaVFodkQ1MWgraHpZRVJJZkN2?=
 =?utf-8?B?VnFpWFUrWElRRVJDbUxIUEdmK1c1RHpLeUcweDdHc0hhSlArbVkwZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bc84d85-c508-424e-209e-08deb719fb2a
X-MS-Exchange-CrossTenant-AuthSource: DS2PR12MB9750.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 09:18:55.1070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a+x+ZXxH+DFxU3+iQ2HqB+Ngp8BCZ2P54pj62kak5A2JMbig6DhTU+s9hDhRy40dkFSwzWRY0bLUPuBtKijaxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6989


On 20/05/2026 17:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.32 release.
> There are 957 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 May 2026 16:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.32-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


All tests passing for Tegra ...

Test results for stable-v6.18:
     10 builds:	10 pass, 0 fail
     28 boots:	28 pass, 0 fail
     158 tests:	158 pass, 0 fail

Linux version:	6.18.32-rc1-gb7adc4ce3f26
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                 tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                 tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                 tegra210-p2371-2180, tegra210-p3450-0000,
                 tegra234-p3737-0000+p3701-0000,
                 tegra234-p3768-0000+p3767-0005, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

-- 
nvpublic


Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010050.outbound.protection.outlook.com [52.101.46.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AB338C40A
	for <patches@lists.linux.dev>; Mon, 13 Apr 2026 18:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776106345; cv=fail; b=k6hzAwQcEkSl/tkr9m0iC1Np1O/9bcD+8frSyHJm4hSX7jiJNT3VeDdA0SMV0gDCJZ4H9RtT4yFoaWarJE0eGplGVtmiuPxofpRIhR7LbAnMaHVx/8sMIyMxdvMH4ghow3k2vZWLxMurZt4jTxR+uPtTYrMPtBEdSvMBzGVf6qw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776106345; c=relaxed/simple;
	bh=jbhs6Hl546z6hQyryvJDGUy96VrIeUWnbsKY3XAP5dI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oTzTh2y6qV5lIrXBsImvdtpfl7mhfsj1wF/CXJYgzxlWFRwHJvsS4CMbUSUrd/Jdrl6ieV4WvKPCdNJHEhKKfq8QkRIqe4DCGKFtoX8zjIBEuS7uHmcK00jDK9ezBCGmSY23Pjg7MGIhFYhdwBYgtflvDwiFG7UFYinjqlPJBv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=khskZamD; arc=fail smtp.client-ip=52.101.46.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="khskZamD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SHWzIzj3UaAws044JFyj5LacIxJi/kWBrb/q4AzaVUocETcWSCe6OGn2H8ERVl3F8s8vt+nXK4n5QjJyBOkDJfeNr9W8uCqCw/2rI6y1h1kkGq90b1+GdZ07OXRus9+uSVcoSeEsfiBIdp7JSwJ5sUMPTjnii0rq3czeC66TSx24F5jvXKI6tk6sXBKt6zAUhGxYJTco0ueH/dYkULCeYdQYy3J/+hDQ4F+ngVVmzLBjR0oySFX6nrjswfL5v7DjbVz6QbecNTe0etM3zoOgU2ivOsvnv+v8Q2G1+eDyWXZJW4nVAGZh9gsBrGJXYFoZpFsib55/6MD+WIze7aMssQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZArOloJ6ltmwCVBouCu3ViVQrY87dRwxEleN1p8XPnI=;
 b=Q7g4wvnyW4ytYbLzLsscINkx5VMAVbM+pDevfpxcAlHHgGiuT/4SBmy2FvsDJ/o4oDLkPfpaX6kmAtfDWYU7eWdz642avFeBIpDqua9TAna+5IS5XElD4WHtilgv5U3pJJgq3kSQFVEuI6IyPJRKIZIIK5Z2Q1F9J219XcOXNyVkwtmYyuJlb5WUrik828mpfocAZrBdoY8BWmh1mYJZOTDv35mgfv9pxmqD8ufzGMEwAyIQYZG3pOsBW9mqidma/Zen895o/XVtRIUjV2A24DBwHAtweCfYL+9nmpcX3yHJA4yA6ZNkYRtdlpeodsJrmkYlx7GjoAcvFKhm/cRfkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZArOloJ6ltmwCVBouCu3ViVQrY87dRwxEleN1p8XPnI=;
 b=khskZamDQ/JC2GgQprFUdHQd0Qo2dxrKF6yDsYZdtfpyUW5H/L6r2zsHBs5SRbiKcn6eoCgwaucm4d8xyKmxQ8jNS21lGbgsFX+zRrDAqs6M2+QDNUkgZEV9WMYDPKthvrf45CXL+kKZnhkAh9xeehkvbkThGTxj5YUlSTgjnyhZqtEvTcoq4a1oV6TkoeVM0LzSUoOr3/WHTBo1aHds9zHhnXEy+JBYswviA1Jtfj1pF4NidbXs5V/CJOast4D7EU72gEwctuDnh/uyqlCXCFv969NjaeevoCjeuke6U5SVhTB5oW97KLgm0NveZm6D1I/8hrPVtl0ZysP8g1vEng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV5PR12MB9754.namprd12.prod.outlook.com (2603:10b6:408:305::12)
 by DS0PR12MB7654.namprd12.prod.outlook.com (2603:10b6:8:11d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Mon, 13 Apr
 2026 18:52:15 +0000
Received: from LV5PR12MB9754.namprd12.prod.outlook.com
 ([fe80::9667:3c95:27d2:73da]) by LV5PR12MB9754.namprd12.prod.outlook.com
 ([fe80::9667:3c95:27d2:73da%7]) with mapi id 15.20.9818.017; Mon, 13 Apr 2026
 18:52:15 +0000
Message-ID: <39e878af-7418-4538-9e1f-8b62de3d1e3f@nvidia.com>
Date: Mon, 13 Apr 2026 19:52:08 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/491] 5.10.253-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20260413155819.042779211@linuxfoundation.org>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PA7P264CA0169.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:36f::15) To DS2PR12MB9750.namprd12.prod.outlook.com
 (2603:10b6:8:2b0::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV5PR12MB9754:EE_|DS0PR12MB7654:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ad649d9-4541-4810-f642-08de998dc775
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|376014|7416014|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	3an+WBJBuk0Xz3IreBlZGkqDIPGlq9lSBpx7HkIXlotSztBg5DfwB5/cniuCHzyKX3pPEPq3fQrP8xNm/sDRDGBHJ00QOQH2n+H+a9/8m1kUrvX3vSvxN6O11xvIVAUIUyFeL6rB/j+5hm9jaYXduHLc5oDiWa09uTpb4eajIq96BPyLUAtQbN4AB1FM+83xGVaV/FNpG1iTo0ivoSgr0Dxfh01JluPsFL0rVctAutTn2aGmEfFVSZhKaYMjOu6S3hUs8uOd+BwN5OXDW0UaDmo8d1xjj+mnc9t2Wl1INPOGwr2ihtQAtsmgd7aJVKpAmCuRoTucPptyo+moXtQtKbqzxIK14K5HFs0vOIYMfsZHA9UmufkMRpVCYwBkpgMLYR4jlhsXFwX3MRg/s8SZxpjgAcpBfVMfoFKDnTwX9E3ZJRWkrq6q15dkcrU1OJAV/iGIxntMH/9EWeHhaJn0guhmFRdIOOIBU7PHUWEHXvmJUMfGZHEWTJKn3b1KRfQCS1HbfN3nagBuGxmtENwoINt6iKY6/n08l7KX+lEcpTsUrVVd1GIK+ELIclIjbLOdtU4m5BmEGLxIgu8nQ0fKMlgfssTQTsGwOoerh6+5zDvHNwidFGiVBTTbFqBK/MkzFc/2ifjGUfZU1OJzfczhno2H07ft++OCawsyghoHgPaTG0qlYD2tcaT1eGpFeyjByzaUJbTCAf6z2HlX6f/uDvIw3er4PUD31PDHFhrtwu8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV5PR12MB9754.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(7416014)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WTYvZi9yWXlGMi9UYThUZEhwUkZCK3NvYWhoSlFQODRnTTFDUWFha3FmM2Rh?=
 =?utf-8?B?eFBSR1VRUWFCc1M3d3ppM1l2UDRUMlFSWFZDSlBqd0ZMc29oOEpwbi9TWnAy?=
 =?utf-8?B?eE9nSnVxakpMZlVIemcwSXl1amtGdllXNmMvamh0eFUvWTZPZTQwMVZTMjNU?=
 =?utf-8?B?WG5rZFM4UmYxK2kwbzN2QmphQXE1bm1ZQUN4OEdXbHJid1FlbXliVlVwT1hs?=
 =?utf-8?B?MkliUEo2YWcxMFE0cFFEZ1pUK09McDVjdkhRU2VzeURTdU9zSXRPdDYxMkxZ?=
 =?utf-8?B?Q2VKb29GYVJwN01vTnI3TEN5eWxsVFhndmVsZWhzMDNSa0RtR04yMlM4WlRO?=
 =?utf-8?B?MGNKeUpYSFRlQ0hJWlF4LzR6ZndycmYzV0liTXlpakhmWnRkTTI4Q0ErSld2?=
 =?utf-8?B?YTNCc2paMGRjSjZveVJmWWVoOWpXVTArazhkamVUcVB4Yk03MW9DVVpZVnZV?=
 =?utf-8?B?NzZrTTFheWFqS2lwV3JxdElKbzdwNGZvdk9rOUtVS09vQ05RaTJDeCt1bVRj?=
 =?utf-8?B?QjZBOGFuY3c3c0M5S0tWQk4yMjl0dTYrUGh4RG4xNUZvbU12Z00xak1vbEgz?=
 =?utf-8?B?a3FsQjZPa3paOCt2cUdiUTZlNDdEVVpXRHpPemNMZm9ibjdzL3RzOWtqUCtP?=
 =?utf-8?B?UDhVNWJPMm94aW1KanZaVm9PazNBYWtYQjZQaEVrRWFGZVNxT3h2YXowUG42?=
 =?utf-8?B?aHN3eEVkRU8zUkc3OEtEZHlkOUpDM0pwcGVhYnpWSGRQZzRyWklNOTRSckpi?=
 =?utf-8?B?MWN6N3VTTVFWZTBteEIvdWF6OVRkTGFTMWNwY3pLclNFMyt1dlVXd0YyQ1Uz?=
 =?utf-8?B?M1N3TjlVL2dWbENTTngrcGhYRG93N3l1RE5zQmJJM0RHRTFyaHlyQ29mc0Rs?=
 =?utf-8?B?cjlLV09oSmlRbXVHYW1TMkVCem45SFJzcEQyd1B3cUNnNnh2TGcvZ3N1YTNL?=
 =?utf-8?B?VFZtTTJ4RkNuanhkNElNTGdxQlNzQWRXYnJabHdZYTZ3alVLTmc0Z3FQWXhW?=
 =?utf-8?B?OUZSU0k5TzBRNTZuaTZaU241bFVKNVNPQTVRR0x2eDVsZmpDTnZXenZhN1Bs?=
 =?utf-8?B?VkVGSXloYVpqVzV2TTJXYWJ0eU5BQk5QQ0ZQZzI0bk1xL0Y4VjdmT0lsMGFX?=
 =?utf-8?B?Z3dUMXI5T1J6bVl2cm5UeENzM0hmYm5aaWpSeGdTTFlDZ2FnTFFYbFMzUzJY?=
 =?utf-8?B?MjIvK1NSQlJmVXNTSkRTSEYzRjFUYyt3OEt2NjhuTVBya3pHZkM4NWY3TTFK?=
 =?utf-8?B?Skx2S1FrWHg1bjBGRGRTNGJ5L2ZHK0lXcU5UZ3o4ME1DNUVjT3RDKzNZRzB5?=
 =?utf-8?B?T3hSbjRoK3EvMk41b3JWYk9GTXFWakFlUnFDeTMwQS83WTZ3QXB6dncwZ3J6?=
 =?utf-8?B?TmlJUTM5UkFsRGhlWEpRTkZFLy9IZFluckVtWnl3YkNFb2lRYnN4cmNldEM4?=
 =?utf-8?B?WmtweGI5bUtBQVpSblpveWE2M3ZjaXZ2cGdTSmtSTzI0QXRMTVZBaEZoQ0F4?=
 =?utf-8?B?RVBOWmVFd1dHdlhkMFRJTzJxOThxRkV4OHQ0Wno3VnV6cDU5TyszNU55SC82?=
 =?utf-8?B?K2YzV0oyOENvMjhvTVZUTXRUd3BQdXRVa0xqQnhEcnlGVm8xcGhRNjRoSTlH?=
 =?utf-8?B?L0JsdHZsTTdHTkhCbmxNNy9McnY4K2V5K2pVMEZUTkV4V0t0YzVER2N0U25v?=
 =?utf-8?B?WS90VXVnM3ppYVQzOHVEMVpjRUJLRzNmOVM3KzhzMk5VaVZSMWdyd3VvVmR6?=
 =?utf-8?B?ZEdkRHNHejB0ODRvQ0pXeTgwWXA2emdtdTlHb2tMbW5uZnQvaVl2akVyMjBL?=
 =?utf-8?B?Y0lOVHMva2pMVWlUWDU0RkpJVU5GVm9VVExVN0xIUTJ1dFlGbGpnRC9IUWJo?=
 =?utf-8?B?QTJFL08rZkRZdjNmR3daNzg5OGE2Qk9oOUx2RFVRK2Mwb1hjLzJDUXFLZFVo?=
 =?utf-8?B?eVRKTjdvMXdQU3Q0THFJUnF1VEUxZnNOMi9icW54Zyt6VW9XOUUvQ3hHcm80?=
 =?utf-8?B?aWhhQWJ6UDVUbnVtWmtqMFBWZnovK1ZIY0VGY0hyWVBnNVZNaW5GLzB3WXhv?=
 =?utf-8?B?QjRQejRaOWJkbWlDcXR3Y21ad0FHRmF0SUtybFJWNUZNbmdERXVqVUp2V1RT?=
 =?utf-8?B?OGdtNkV0S2VYWTBxZUhUOSsyeFJXWlhoSnNWeHNUcWRJdjNXNlJrczBPYlhO?=
 =?utf-8?B?bkkxQ0F2NGt0cDlQWUVLaWthRWdFOGlSTHZVTis4bEQrVnFFRmwzdW14aThl?=
 =?utf-8?B?WU1hUitzRjVxNzJ5WUxXTGpJTDA0ZnVzOWhrUFlyV1FIVTFqbzIxVk55Y0k4?=
 =?utf-8?B?QWt6UnY0ekVJZXd2b0hFUWlQeTNBR2hPK2ZiK0NBcjFwS0xvNjlWUlJXOUkr?=
 =?utf-8?Q?P6/cdCjQ1yngpfccH8tEkUYrCtJD0eNcIJuF6UHtDVD9F?=
X-MS-Exchange-AntiSpam-MessageData-1: iM5elphlIWBf5g==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ad649d9-4541-4810-f642-08de998dc775
X-MS-Exchange-CrossTenant-AuthSource: DS2PR12MB9750.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 18:52:15.7406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rwzyQlzyMNMaTgamr3THk+FNt1xd3UtoDD6yjwzIIOip8tZiT7wXOugd/7gMW8p0dJGAYdReFSTUl7wYcOj7XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7654

Hi Greg,

On 13/04/2026 16:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.253 release.
> There are 491 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.253-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:

...
  
> Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
>      bus: omap-ocp2scp: Convert to platform remove callback returning void


I am seeing the following build error due to the above change on ARM platforms ...

drivers/bus/omap-ocp2scp.c:95:10: error: 'struct platform_driver' has no member named 'remove_new'; did you mean 'remove'?
    95 |         .remove_new     = omap_ocp2scp_remove,
       |          ^~~~~~~~~~
       |          remove
drivers/bus/omap-ocp2scp.c:95:27: error: initialization of 'int (*)(struct platform_device *)' from incompatible pointer type 'void (*)(struct platform_device *)' [-Werror=incompatible-pointer-types]
    95 |         .remove_new     = omap_ocp2scp_remove,
       |                           ^~~~~~~~~~~~~~~~~~~

Thanks
Jon

-- 
nvpublic


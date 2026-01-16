Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011049.outbound.protection.outlook.com [52.101.52.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192FF5464F
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 12:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768566361; cv=fail; b=uLdtKb5VrqHgnl3SRDC6HqyrN7DcNEzRlJ/8pBwP5H//l7huWWOCRheVQShocOrwLgny+TDNZr5wm3Zr2ybvIztpDWxJwvoAUdYj3qJ0SgVsUy1pAwZrTA4l6DWDoJ5iHOPHAhwVpKpZ55qSLnwTjN7LO34R270PPpmWtPbYwX8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768566361; c=relaxed/simple;
	bh=C9l1XM8nsobId0kJnZtnfuMOzNUAzgT0CkH/whVleTg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=CW9m9Z0wYci3nWJqca2QT1q7GdhmAVONVWuvO2TTtRSGbKnB7/F/xGzGecEb0KCm2SunKMFq9awLtNxFDPeIggczrf4oFZb3mAE/10NPpiduoPz8VzowSviFN4zu3HxzLH4mMJCZncBLr213+1JuDbrn2YpLncGwwsB8nMBGsRU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pPIUj2Ij; arc=fail smtp.client-ip=52.101.52.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pPIUj2Ij"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nQ/9by9eFyI799FA93ISB+nmBWkPdSic0rftYYavYDWxVI2vbQgTZA530lec3kvdHIPVAFffUVCdWFCBX5oYXdM5VHcP1UpI8xIcKc4A3V/h/qZvs0ST15VJ4MBmBXFT193WBMwm2zbXC/GmupX3tRqhls+F2Qnen5P+4IyY6Px1u3BDzvYMSRe76gIVB8DZVtpkcTPCKG52DrZWGNoMcIp3Aj54QsApRaPXdB09PIyf4PJSD75xX51V2/CsnDkh+5xHCYmJ6PFcXdRP5fh891477Gd41rOBNzZzj6IuOA5DJLYWk1lFQQB5VSIGO66KOhBCpCjHlVlG/kKoSkegLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2rtWhUHO9kUjpNmHhGBKB1BVDcuGAkQ1Br9Cc3s1uk=;
 b=q2fDqQl5s1mpdZmReJTGuPkx21C3dn9hlOXnbmtICvPwas4Jt0WqIZj5svdKFe+n/MzYGIfj1ntzr+WvAq5d88ZVO7b2iZHzp0PH+TLpn4M0LGZX8bsoaQb/0BSh5LCNgOjgP9DGZTuOIOFavIAjOvHKdliUNyAcnhtqyCstNZph8aiQJl39XfGMMGCF/0OkgKS5OF0yOe9WrydIkfTVGppq3+ynCLuIybMMQ3fyl1hKzC6Pq7zQZ3BMnYNWJRTOKcI4Af6aLYCQ5f2USNU9I5fCl5JSBDrEGVzhYIO38Ofr8hmhlCWR1ff9wlw6fDA4NYktExcfJ9sdJ0AcZxOzPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2rtWhUHO9kUjpNmHhGBKB1BVDcuGAkQ1Br9Cc3s1uk=;
 b=pPIUj2Ijhx3trTVZ/F2xLZ9JcTJhwqzMB7rQyhd2kPW0YF8cqOBQrDmL2JsssB31RmlkNdghJKxX/05d/uWCqsDk4ZoFbUfL8u9E0X54driVG00By/zhK+sD2PLuESYghZhoj4qpeuS3bC4PPKvhg4GHdFfNdlk9/ws/LEGsA2M8S7SuKOgC7cSWP5iXKRaS74odvfH5hGgmQ17J/HIbbDJVbcdz725eMfVRr5B9RUgtlUZMVOHrVJT0GK7P78gVPgZow52xfWCIKRUv1UWcsVH405i3CHp+oT6BJpvJaBkL+57jDbcHCVsFE6u5DfYLNtFFCJU08bRbO6p9fUiRfQ==
Received: from BL1P222CA0030.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:2c7::35)
 by CY8PR12MB7436.namprd12.prod.outlook.com (2603:10b6:930:50::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 12:25:55 +0000
Received: from BL6PEPF0001AB4B.namprd04.prod.outlook.com
 (2603:10b6:208:2c7:cafe::5a) by BL1P222CA0030.outlook.office365.com
 (2603:10b6:208:2c7::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Fri,
 16 Jan 2026 12:25:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL6PEPF0001AB4B.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Fri, 16 Jan 2026 12:25:55 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 16 Jan
 2026 04:25:34 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 16 Jan 2026 04:25:34 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 16 Jan 2026 04:25:34 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/551] 5.15.198-rc2 review
In-Reply-To: <20260116111040.672107150@linuxfoundation.org>
References: <20260116111040.672107150@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <362d4f5b-0abf-4fe1-b1f4-4b2538ebad3d@drhqmail201.nvidia.com>
Date: Fri, 16 Jan 2026 04:25:34 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4B:EE_|CY8PR12MB7436:EE_
X-MS-Office365-Filtering-Correlation-Id: ea8ecf82-6a53-46bb-149a-08de54fa6562
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QjVPckxsdUhoTW55NGt0VzhYQVEwMVcyVzJZN2NHNkZFVGFtZjRaK2RwSHFU?=
 =?utf-8?B?TjN5a0p5TDRGZWlaTVRMSzh1bkZwQ0tPckpLSHFHelR2NHNHNTRmNzhkMElu?=
 =?utf-8?B?VmpiSys1UFEvUEYyUFhtd2lvVkpRM3ErazR2NWtrejl2alVLM1hrSm1jd0pE?=
 =?utf-8?B?M2NFcW94RHpxVjdHcU5FMm0ySzcxNkRvN1ZoY2tWMTg5ekxFWndSQWQzejFh?=
 =?utf-8?B?STZuTy9JN2dSSm5XU0owOWtWUS9OYzI5Zk5TZzY5cFNjQ09HV3JvL0xKaUdO?=
 =?utf-8?B?aTdjc2pFL2NuWUNFdElib1pLc1JjS0hjQUFDOHJLT2pJbmM2RTR5Zm5jNVNr?=
 =?utf-8?B?WjhXSXV1VGJHWUNKRHRQRkgzUzZzT2JEOEFsOXJUd1h3NEs4SmlZVjJmMU5z?=
 =?utf-8?B?Lzd0R1BTRFJMYjRDaGhndVNLUkFiLzU2aE8yWEJWcVVjWHJJWXZqdXJ6ZVhX?=
 =?utf-8?B?QWh3WEtaaFVWRUVWVnVqUkJuamtITzRqdXpweFJtNDJrS0puZ0Jpa0RsNFBk?=
 =?utf-8?B?aHdFdldLT0NUYzI2cXArL2JYMWYrME16WjNtU3l3UkdXTmd6NFZrcDZSQ0d0?=
 =?utf-8?B?cjhKVDZINWxTMVA5b0JHL3QrZVFBbnpXYk5xTkRPT3hvNTBJSnpoSVZXcWRm?=
 =?utf-8?B?WHZuSU9tb3kxU2p2M21FVHF6b3ZJMm9YOUhaWWtLVzNCekY3cXVlUHFScWc3?=
 =?utf-8?B?c3hFektqdjZNUXhMTEZyMnhqMlhxdnB5bEdZM1ZOalUwcXVGaVdLNzF1ZzVi?=
 =?utf-8?B?R2NSbkhUazBNeTBWQ0FMSWRuN0lCNEh5OTVXcFBYMmVYazhINVRJUml0YVl1?=
 =?utf-8?B?UnNVYVZ6aUx6eGZPdUpTL0Z5OGZEeXFEU3NkNFd2b3J3dWhXbHR3WFhHM1pr?=
 =?utf-8?B?MUNiVzVNVkw2MkxHZHlqWDVPTTExVWlaZmtDUHREenhFeFBWWGMwQ2E4Y09s?=
 =?utf-8?B?NnMvUlhLaVRmOFJqUGpQYUVlbkJURVE3b3JHV2pHVjdjZ1J3UXFveFg2Yzhn?=
 =?utf-8?B?b3lRQjNzWDJPWDU4aDUzZ2pHVmovcjZwN1dtc0Y4a0hqNklyTjkveVcyWW5x?=
 =?utf-8?B?WjNDcVUwN0xheUI2VXJkQzFNMXl3TmE0MVY5ZjREak9vdHFudXkwck83RkZh?=
 =?utf-8?B?M3lreVlYeVJ3SHhqZ1RyUjZxcHFLTUJMcW9vMks3c3cxemJheFdjTWhuenVw?=
 =?utf-8?B?d2ZmSlgwZTVUMXc5bncvZ0gyblZJY3NnWUlLdzkvTjhRTlVPMnZCK1M1UnMw?=
 =?utf-8?B?VW9aYUIxMGdXY0ZSUmlHT09BcUJqVjFZcjArcXZTNnArNWlFcjJWUTVRd0xv?=
 =?utf-8?B?MjBINUtQTnpreC8yN216bXVIQWlHYTQ3L1pLbmtXZDNVeVB4Nll6bFgzWjF0?=
 =?utf-8?B?N1hWZ2NwcDZxczUxaFZKMHROc3k2S2tUamdROTd5aWdxZVRWSGNVcUJqMllG?=
 =?utf-8?B?VTdYeEozeG1zN1R5dkE3L1hCTzhBVmRwSXVpVGR2TEIxMzhpUnBaNmplY1dO?=
 =?utf-8?B?NTdXMU91TnZNNStaQ0czbDdOSEh2KzM3TUVoZWtQVGUzOWFheGRWQ2dWZXZN?=
 =?utf-8?B?Y2tLSnBYRnVncmpUZ21ucVgySU9oTHArTXdyUDI1U2o2RVkycmtlYnlPdHF0?=
 =?utf-8?B?N3lVRGJvQk9DbXEzRWpaUTdpdytBcG53VUpHQ1g1OERHc1JlY3VONDNVRGxJ?=
 =?utf-8?B?TzlXdjRDWlYzZFMxZG9WMVpQK3Z5L2ZRdlFnTml5OElMN01PNmxvcEM2Wnpx?=
 =?utf-8?B?V3crMVBRRDh5ZHNobko4TUo3WmRoVTZLNTFvU3FabWZ0RlVaUEdkcWdDcVVF?=
 =?utf-8?B?c0R5VEE4MUhvQVhCQ2x0T1hqUnp4bXR2eEVkZkF2c0E0T1ZIS3FnTkhvRlRH?=
 =?utf-8?B?c0h2aE1rWFlNYS8rYkY4NlgwNlhHKzhleWpyeFR5ZEUvQzdrZ3lUTWU3Snk2?=
 =?utf-8?B?Z3krZ2ZaVzRJbW14SzJJRjBGMlh5NkVubHdqeXhxdGVCK1BZSlZnY2tCKzVr?=
 =?utf-8?B?UTFaczFZWHdhOFBCeU4zV3ppVmRJWVdwTURwMURDVG8rYWdxNk1ZL1JYN3ZH?=
 =?utf-8?B?TE14eHhMNjBFS0ZNODBweW5sR3ZzQ3pRWWFXTXp6d2JJTU1LcnNnWnQ2enlo?=
 =?utf-8?B?RzZPL0JmOUpJWS8zcjNmVUROaCs5RzZmUElTWHRhaDgwR3hydVVBS1phRHo4?=
 =?utf-8?B?S1E1RXo3UVBEQnRtcjRXdzlLeU1ocUlDTHQrQTdEN0tJTHJHc3h0TjY0MTg3?=
 =?utf-8?B?RStxMEhWSmZUbUlOcFVXU0xtOGRnPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 12:25:55.1001
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea8ecf82-6a53-46bb-149a-08de54fa6562
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7436

On Fri, 16 Jan 2026 12:13:28 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.198 release.
> There are 551 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Jan 2026 11:09:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.198-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    105 tests:	105 pass, 0 fail

Linux version:	5.15.198-rc2-g2b165888db3d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

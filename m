Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2055.outbound.protection.outlook.com [40.107.212.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A573BBE0
	for <patches@lists.linux.dev>; Thu, 16 May 2024 12:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715862628; cv=fail; b=WPTjCgPL75zcQtg+zUYDCgAYAjYJGmjFgi7PlFWlgvxEBgxjAyBXg22HA7b1wZnk7k8bDC+V9nY9+9Yi7jufQGu8ceooEqHJUEs/WOTVZXJZty4nI3M4BBOqI4YH+AcHyXChmCpTozvP+uTVapSyWGm83w99ciLABcgLdsunhAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715862628; c=relaxed/simple;
	bh=yUOKefS35lRJRE7dPO6lUCrLrHWoAEfSU8O+wrun2J8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=hMPHqJLo2PTnuI6uWhNl+FvI/dL+B1OLNP1J/PmP3TKuGDc/QwntxyHg/jWZNXZ7WH63zJ5Pg7KRehdIAvse8uVeuDBnxxIKY+q1nHrQDjd+4WyaEbw3+5cXksp12Y32UrybyYpVd6WxA6SlA8X+qpwPVE1s/RFWgzbbM6jX3o8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=arYHgDGl; arc=fail smtp.client-ip=40.107.212.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="arYHgDGl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zajvx0qsBd4qWyNg8r5xtEcxy4UeveKUlZ3/qvbVWs4djhbGUSgyiRsevjnkgLHlXZau3t8qXoaTyyahoB/7HwnyW6PG0x9N4tIuiso2Sp9dhbkV95GCMTJ2AIdPVm6dlOE3FTCQj8WCAJ2RuoT7P7y/Ky8MrRNhUWRSvJXEqRYt5eRlbV1h6EcWN6jSQL7vT1905o2GENoBbg9cjT6uH9SAtB72qALGgbkDbxmgZBe8bSSBopTQ4/UTeI4BJCZOHx8DTKRIF9PYynFfz3khRz+DAbjoL1bx0fsLMWXdBcfpOH8OWJJjQ3VHO7O7FpMrGQGKchZw3HJSTpI8AmnNKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p9AJsb0fsGqfGws3aIY7AjpJn6py4UxgcMkEk3Mc0D0=;
 b=F2ExLm1nU6EgLYWo0sJFgobylCZT6OzakP4T5zOST/t7HfNAT+f8228gFxKG8ta6wXXoWxv1DJgI0nnwv3+gfDlXM3Vzo/adMiiwtgpzNs9yKZ1Xenhe41N1hF7bX8gayIFmtMQk6vfBDShIeAk6LY/vmGmhheoES/QAhBav5MF21v7QJFHQX37FPmbxpm+PtBlfNo27AhJNmGasu5cWEDYYMY4foONMA05j9Oub0o92wcmR2hYGPash2Li1tpUs3N8rVk+xwI2uLSwoLmB40sRjxzVj9Xt1GFI1QuhQsH/niNhHHVofiIbyL8kW97R7wNLqDUkdqpiLWHg4XoGGaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p9AJsb0fsGqfGws3aIY7AjpJn6py4UxgcMkEk3Mc0D0=;
 b=arYHgDGlabN0z3oxSUQVY9pNxAfGckFqvAF1Ru8OXntNzmJhGst8f+pzTMDit1u+aznqJplVq7dPCNYGtO6HxN6uOHrNEY0Hjq6RR4i9PqGpcAxmvkmTbwkHTSRnRzkqejlzlFx4lfv+rxv5bnCZxgYS6q+F0ZDvABB3UwgMjlsUPIQunCKvPTw5t5fG4mQSWIEOfpu+sgsJ0Lu/y0ZU2/7C1YWzT97r84kf2g4r144ErB2oZJABBCsSqWLuEYVdroaPPQVLpz2iZ9GqfNvlrj/81g3mxqAoj2CHnebTq4ZGqoA0bD31miwWDQZLvmEl7Bg4G2WGgYV+GQrhYgLRRg==
Received: from MN2PR03CA0016.namprd03.prod.outlook.com (2603:10b6:208:23a::21)
 by CH3PR12MB7523.namprd12.prod.outlook.com (2603:10b6:610:148::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.25; Thu, 16 May
 2024 12:30:22 +0000
Received: from MN1PEPF0000ECDA.namprd02.prod.outlook.com
 (2603:10b6:208:23a:cafe::ef) by MN2PR03CA0016.outlook.office365.com
 (2603:10b6:208:23a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55 via Frontend
 Transport; Thu, 16 May 2024 12:30:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000ECDA.mail.protection.outlook.com (10.167.242.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Thu, 16 May 2024 12:30:21 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 16 May
 2024 05:30:04 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 16 May
 2024 05:30:04 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 16 May 2024 05:30:03 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <allen.lkml@gmail.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/63] 4.19.314-rc1 review
In-Reply-To: <20240514100948.010148088@linuxfoundation.org>
References: <20240514100948.010148088@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <327b9da2-ae14-487b-a197-429454c64cf9@rnnvmail205.nvidia.com>
Date: Thu, 16 May 2024 05:30:03 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDA:EE_|CH3PR12MB7523:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bf10538-ef66-4d2e-0aee-08dc75a3f481
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|7416005|376005|82310400017|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cTNQQVVzWXBFb0NRalk1TDJGUkNGRkREU3JHUFZtZ1NzSk05d1JpZGg0NzVQ?=
 =?utf-8?B?QnBnNnlSb1J5RVdPSFBtZXFzTnhSQUJkQU9YQlR2M0RzaHZPV0dTamdWZUZj?=
 =?utf-8?B?SEMyMHYxeTl6eWkzZlJ2dE4yMlkxa2hWRFJGWG5GamNFM2JxallkWGNqOXFU?=
 =?utf-8?B?WmcwZHVrY3k3QlZkT0djMEhZb0FmYzdXeWNFWWJnS1ExVm1uZUpLcFdKUy9y?=
 =?utf-8?B?L3JqaHhJbmRRMFZRNnBadVhmMURLUDFZQWlGZGY5MEZ1eWhVZUZLZnp6Ylln?=
 =?utf-8?B?SWlESEdYT09mRlhKUmFqbDgyQ3BXbCtBQ0FoUWt3LzZYK3BUaitudytyUnVz?=
 =?utf-8?B?aWxwVGxrSGtHZ2pORlNQRDNWbjZnVEkyT0wwZnFweEd0UkRiYjhyK2Z4eC9T?=
 =?utf-8?B?SHNiSmNSYUI4R2JBOE0yWTVSdVVIZVlFeVp0VHRQeWJHbGxGYmZ4c0t3ZUkz?=
 =?utf-8?B?TkxCYW1TY2l5UGpTdWwxYmxLTWRuSmhNcmtRM0ZtQXkzaVExeGpzQUZ6aE5K?=
 =?utf-8?B?RVFuV2R6c2VkbEpvdU1lbVVLSnhFMTZCUjJlb25CeW11N2FESDJYMXNnZ3ZF?=
 =?utf-8?B?N3RYY3Z4ckNJMlZkUXp3cjVSdVg1dmlLbjZWZjlpdTl3MnFxOWFoQVB1NzJT?=
 =?utf-8?B?NzZYM2JlaTNyeWRQU0N4SDJsblpPU251cE02aGNCZ2NYeGlNWDAvS1BnQ0tp?=
 =?utf-8?B?bEk5bDRuSHM3eGZhaFExaWxoWFFqQUxXYk00SzVSbElxYk05OU9VUW95Zk16?=
 =?utf-8?B?VHFQUzVMNkVXaUpuYU5zOTNJOWhuZkhwSHpBSnJ2L3dCZ2RzWU5id0d3d1h1?=
 =?utf-8?B?U3ZIOURvSStRM0R2MWExdlF2MldsQkRnL3hhTXc2QjZIb0VMbHBobmx2aTJl?=
 =?utf-8?B?Z3o3OGZZdlhjV2FhSUxUQWxZeWlBMTJIRFpRWkNwcFBZNGlQbDNIc2RiVW1M?=
 =?utf-8?B?Q0VuRUYrbUQ1Y3E1c3FzdGJ2QXdhMzRkSHRkdWpHZXhSQ3pYUmQ1bHU4b0pO?=
 =?utf-8?B?b2VqVnRRdkx4VFpoUnVjb09nWXpUT0VyemhFM3V4ZksxNlFDWSs2eFY1eWlC?=
 =?utf-8?B?V08xUzNFMTFRU1UrcklLNTkyQzREQkFaSjVPQ3BHVXBEWDc1SVpFUS9oTzRw?=
 =?utf-8?B?dTBmc2ZpK1poQS94SlhNZklhUzZzMi8rQlo1ZTFFN1RQa1pha1RIVXF0VU52?=
 =?utf-8?B?c09DcHVtQS9pTWRhRHZrVjlRMUtnRTV0dmJ1UlpoUFJ6Qy9QMC85UHNybzFM?=
 =?utf-8?B?YWNpSEtSdjNDN1FMWDgzaXFNNitkYzBOSjR0UWhIeVM2cFlxZHZsMGxhZk8w?=
 =?utf-8?B?OE8vdTBkaEtIZGFuenRXUjAxYzNHSVkxY3diOFJkOXNFZjVWVWVReWRUWnVK?=
 =?utf-8?B?TlA1MUtUSlNRVk5EL2taUVRZZC9raW9CQVdyMEh2VUFlRTlYdHdRT2U2RkZ2?=
 =?utf-8?B?dmkxRG0xclF6b29mcnJzN0FPY2UxTUNlQkdlOTN3cXNNUWl6SmpweWN2ZWhB?=
 =?utf-8?B?MnN4SGxSN1lDR2lWaDZTcnV5VzYxeXdTV3IvQlRKSWNrZkxZMmpSUHQyUTJx?=
 =?utf-8?B?UVl5cEE5bjdQdmdhL3NBNjl0eGRnSXhHUGZHak1CMkZrSGcyOVNHb1U0SmVp?=
 =?utf-8?B?ZVdFc1VESUl4Tml6N2sveGovbmRQV3Y3WEN3U0xWUG9zWXdXRWFrSUhsc3l0?=
 =?utf-8?B?dkZtakdJMk1TRWwvYmVOd090b2JaVmhxditKOHRMaWQ1YWRuMjNMUHV5Y0My?=
 =?utf-8?B?Y05FZmNDeVpkckdYbHdTT05qVmFsNEhmSVMxbFB6YkpONmJ3V01ZRjFQZlRV?=
 =?utf-8?B?ZjIxRlRhbFZXbjBsRUl6YUZtUFRkQ204VnJXMFI5YmNmMU1MMVBReGJPT2NF?=
 =?utf-8?Q?OwFEpD9Y8h20x?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(7416005)(376005)(82310400017)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 12:30:21.9328
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf10538-ef66-4d2e-0aee-08dc75a3f481
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7523

On Tue, 14 May 2024 12:19:21 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.314 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.314-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    20 boots:	20 pass, 0 fail
    37 tests:	37 pass, 0 fail

Linux version:	4.19.314-rc1-g61b47a187ce8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

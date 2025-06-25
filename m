Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2049.outbound.protection.outlook.com [40.107.102.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC441FDE39
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 07:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750836254; cv=fail; b=htkVkpJODH8BEbbBvZGsvW6cEzf0hgGic4Xc9TXJ6daw/ufQFNbcHsp3aBNmJ3KwBelehTy6Li65X33GDmxWLr285sVt7FNehd5L/vviJVK0DRHWbDHwNHCQnBpP1wkCmOoNuZoeTRD++Tvy3A5WYCt5RA+PUPdtqMk2XRB4jNs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750836254; c=relaxed/simple;
	bh=CyPBjaCh6+rD9zj42gPYP5qNa9Bj8APB6vYNEUkk8lk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=G/TjJFvqqhCO5y/Q8OOlPA9MIV/k4UB3ERDybuZ7ROQ+GR3cDQPUb0oahgo42rc8IaCFs0Ov67PztI2+jO+BOvAL0Lt9+xWb6OrS7yOzTX/lwnKhPqYB0NNwzFsjnr/CqAfMT8FtTMbMYwxo+6IgV9m1JTM2kKITC+fb/Dx2JmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FMuZeP/6; arc=fail smtp.client-ip=40.107.102.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FMuZeP/6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BayHyVX78MQ952zhRUdbCkVrzO/WX/YWh/VyLd+HZ3RwFJk9/KanwDtA5xOgi/LoCH+iFN4oTbAWAc+7sNI7jrAeUxN4+aqf8D/uNV1wSRmUXlPFT3CUie2tS8X8rEE7ZeElCOHI+BZNhj5+aji+RP+8n/jNpqjGlmfn7iCxyCIETXdsuixS6ixJrxM4LgH4Oo0OnY8pyptPU/9iKTngXndQL6rbU/j2M7VNZjUh0t7orDzd8Lbrb3YRWQJKxLGSTbS2yvlWD0u5HZ1clA1WabhOST5+6SxHd8+jVtWnWRnbgZ1MJpvwPwJkf5NYqoIVGjhyZ4Kck60iHJV+eNx5KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FO87tgKF/Z1F3VgQKMT1s7svfI0AQw67RqsI1xnwc64=;
 b=mzdMT3gnTus+x+L/Us0Nlhr7wKA71nu6QzffjQq1TAJZijJAUR8S9CtnkysPHQuETq6Wr/C8Cl6KAfuc7//HPq0xeJeLmmLHmZFx5okhtsiURd1w7kXtulD2vRdm4Lab5IoVsdZFMRlbD1NxNpLrOJV44q2xb0HdtS8Lx5Vd4h25yJEW/EWRSDG/jBs0gVdNbeiHoOa4ejUD4lyNGDy61Unu2ZCy/iMK5YV2986NSpd50YEyWNAyRKgqjMTG/6e5AAQrpVfRdYmiOC8BKHjikkTWHlavzWM+upVKSIr97MG/XG/U+FJmaF20k18+Yrp/awRuinAoqyOufNTvFzA/aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FO87tgKF/Z1F3VgQKMT1s7svfI0AQw67RqsI1xnwc64=;
 b=FMuZeP/6+B5A3KEioCbGUSlytJjx7AQYhuqJ1AHYKzOLqL6br78T/gov522ZpcoZUy0HXVsiXgPIYIcHjfgvLL6L1TdPTtXw5FGu9WzqkAQ7yAtROy7sNLlKWHriuRUuK2g6oMoSD16+gdb8wXco8O8MNu9Afraj2D6QG9gsKPDnLtKchghYYHeLGKarvowQ01pYQZU2QlvhtNQklAQWE6L5hCBsScpXlCwgVAqxgu51n9uoyCRlyfPWgsUqQVAk+hPa21Sd/WQauhnwE+82lGh/HrtaXR8ewVHp/fK9vOpAFgbon+xg07WiqnRbr3dary07OD53oSuS1M5OpzBmMQ==
Received: from MW4PR04CA0319.namprd04.prod.outlook.com (2603:10b6:303:82::24)
 by SA1PR12MB8841.namprd12.prod.outlook.com (2603:10b6:806:376::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 25 Jun
 2025 07:24:09 +0000
Received: from SJ1PEPF000023D2.namprd02.prod.outlook.com
 (2603:10b6:303:82:cafe::92) by MW4PR04CA0319.outlook.office365.com
 (2603:10b6:303:82::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.17 via Frontend Transport; Wed,
 25 Jun 2025 07:24:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF000023D2.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8880.14 via Frontend Transport; Wed, 25 Jun 2025 07:24:08 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 25 Jun
 2025 00:23:56 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 25 Jun 2025 00:23:56 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 25 Jun 2025 00:23:56 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 000/507] 6.1.142-rc2 review
In-Reply-To: <20250624123036.124991422@linuxfoundation.org>
References: <20250624123036.124991422@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <4e6f20f6-6e94-4651-8f7b-65f0b505ccaa@drhqmail203.nvidia.com>
Date: Wed, 25 Jun 2025 00:23:56 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D2:EE_|SA1PR12MB8841:EE_
X-MS-Office365-Filtering-Correlation-Id: 3531933d-c688-4aea-f803-08ddb3b94662
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700013|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bzVCWHJEMVRTK3c4Q1hDSzYvK1F5c0NLcFNZTzFNV3RUa2w1ak53QUk1VnlJ?=
 =?utf-8?B?WlZwUzYwYTErbnRGTkprbCt3YnFCWlZLbnhyVEVWV1VFUnE3azNaVm1HRU9l?=
 =?utf-8?B?TnZ2THErU3RSc1lIM2RDdGtnVEV4NGF4bTlBNkVyem9GTTJBOTVjNU5vd1Qv?=
 =?utf-8?B?OEFyTEE3cGVQTXJMUEdEbnJCSy9iZHlOMnZFWHdxV1F5bFE3TDFQVjJqSnpM?=
 =?utf-8?B?NHFPanVjcC9Gd3Rxd0NZODNPWHJmenhmYVJOZk13MTh1Y1dMeTB3eUMzZnRE?=
 =?utf-8?B?WERJdTczYSs5d2VpdEZNVkFyeGpXOG1WanlQWTlySDd4clZ0QzNIOFZUM3lq?=
 =?utf-8?B?NjJiOGNFaXpWMXFwS1hjVjVnM0g3TzRjYUROK1BmVzBLRTNMVUJqMEJOeGxI?=
 =?utf-8?B?WXJYbG90OTNTaWdkNFJaY0YwazdNK1JXR09JQm8yeTI5VHJ3UjFOc0RCRzhM?=
 =?utf-8?B?ZlpHOUlQU1ZsT1Z0cHkyM256UC9HeDRxQi9idTBqSEpZUzhlU1FPZnloeGRx?=
 =?utf-8?B?dm9RY1FTZTAwMTRrQkZ0Y3B1NWhCZ2daQnZocnpBV3VwYjArVmVITjlKcnZh?=
 =?utf-8?B?MndmYy9HR2hNOFpKYWFTb3pNVGhzbXhocVNyNHNsUGQwSnp2Zk0wd0ZHSE5s?=
 =?utf-8?B?Ti9QS1dzNndHVDBjdlk5a293ZFFhZlI1VjVhMDBlYnlxa0paVFRLYTFLYzA2?=
 =?utf-8?B?dXVVTDNJSEZmeTBXakxtOG5tUVlyN0RkNllLYkoxbkNGMEE2Z0FEZHVwZUpS?=
 =?utf-8?B?VCtQZEdlVjNuOVlPRHRjY2djOVlZYWpkRHEzWHpWK1c4YzUrZzF5dWZPaVlJ?=
 =?utf-8?B?VjZRbHVkdWtKUFZaaG9DNTZvL1l5eVNtY2ZwOHZsK21ZUk1xYXBLcXJramhw?=
 =?utf-8?B?bW5aT0F6UUE0a2NlaVlTcG1YSFdsakl1d2dLaExTWWZyQkhzV3FzbUNUREZV?=
 =?utf-8?B?KzdPYTlVSFFuMUVIbENZN2FsR2lRRkgreXFBamJHaTJiWm92aHZzTFA5VE9j?=
 =?utf-8?B?T1d2aG8xSkF3ZzVOUCtiVjFXQTJjQVU0S0dZc29QSUFsRXRNODdXaGVFY3VW?=
 =?utf-8?B?K0MvT2Q1NnhQejV5T1BlUzlWZXV1MHhkM3lPTG9zdElKK3RPYXI0enZ3MjJO?=
 =?utf-8?B?MlZ3aU5HZ1ppVnhKWHlTem9DZDFrdVBsL2hGTFd2cno1a1hIVG9JVXNmRDJG?=
 =?utf-8?B?dXRSS25Bc0FtL1pnbUp2eklmS25iZXNHbjNjMFlOeDNkYWpEQ3hxTTJSek8y?=
 =?utf-8?B?VnBNUUFCMFFocFhpTks4N25GUlpoQk9MK2s5MTFkblM5SUI3OEFvcmpUQ0Z0?=
 =?utf-8?B?dTdLSnYyUHgvYmU5dVIzc2lMQVhWRWpNMjVRSXYxVEpJaGcvYXZmd1RWTTEr?=
 =?utf-8?B?bk4vU0VET1BNWUx6SVVkZUkxLzE0NU9sNGM0THBHMmtUOG11OWp2SHZPNWRJ?=
 =?utf-8?B?N0VGUzM0Q3I1aXU3ZHFFWTlJKzdNV1BaSTlSOUkrVVM2K1V2aUxaalVMQjcr?=
 =?utf-8?B?Y0VHMGJacklwNWZkcit2OFZBays5VnB4cGRwcndpT1huUklvekxkR1FkQnBG?=
 =?utf-8?B?a2s0Q0V6RnpRZmFkTmZpWE5lYzJDaVEwdENaWmRRN0FodDFFWTl5VDZPdCtQ?=
 =?utf-8?B?Q25mZGtaVVlNVkNUTXlSdkk0R3EvYlJ1Y0x6b3kwQ3ZPTU1nQVoyZHJ4blVM?=
 =?utf-8?B?TUhRalg5WXpVYXZPQkNvVm9BTklFTGo3d3lBT3A4R1IvTTQwYjkxalJsQy8z?=
 =?utf-8?B?L0tVS0xobDJNaHB3empZN3V6WmsxTmZYVmlCdDM5TXJuZEZkL2d3TG1mamVD?=
 =?utf-8?B?L3dPR1FsYzBVVXdCQnlQRE10dTF5OFFJYkZXS1BnNXV6YVNEQU5zOGlGSm5K?=
 =?utf-8?B?dittenBFU0lSUDEzWkRMN1hSR3hWS0g1SFZ3T2xPcTVQRjBpdUJnKzY0d1A5?=
 =?utf-8?B?dHU0ZHNzcEk4SUVIZm5pbHBlem9Ld095Vk1TUlQzTHdzQ1RYYVIvSkJVOW5i?=
 =?utf-8?B?WXFRdTFyK3NUb0UxV2hmcHdDMXBLc3M2YjJ5aFBpZzdYdnZYOVVRK09ZQTRK?=
 =?utf-8?B?Zk5QMGQyRWNENmlHczBhQ3lMV0Q5OEx2ZWhvQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700013)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 07:24:08.7510
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3531933d-c688-4aea-f803-08ddb3b94662
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8841

On Tue, 24 Jun 2025 13:31:39 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.142 release.
> There are 507 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Jun 2025 12:29:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.142-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    119 tests:	119 pass, 0 fail

Linux version:	6.1.142-rc2-g6d3c6e22f526
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

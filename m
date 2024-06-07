Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96BA14F126
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 09:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717750958; cv=fail; b=cdrultsXgTYM7dhZmWQ+zPlRSCSHB40Wox+ULjlvutD5WyhjXpl2/RZgsp77cnh1VMsxq8wxfq7HgS6duaoAsEjc6KyjMTuaF2iV46XZGc2wz69E9FZ4NkwnrqWlOnq45QVgozoyv1sNwDKXA/U0EcsFPP521XYU77MvQ5CrlOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717750958; c=relaxed/simple;
	bh=DrXHr4JcPXYCbH7wwBWLijQ0HIUQS4BZMfEl7tyQzTk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=NoVKTPKdznYmUhnJtlBq6OBB2pxMtf/a79qZqK3a8usltRHIQVgEgOeXdYdCWDh6vBoYKAAt4Tc194o8wrcaH4RwrwXRNZyYsV+wFLBf7KC+KwGWMe+F6LZQfBgfXNH54TyYXaYZBWcX4SuUPzpvU8yefGBBGss8EN02N/hbm30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=j6O2nHI6; arc=fail smtp.client-ip=40.107.220.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="j6O2nHI6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BnWpmfwF9JZwd0TQGKJWBPAzMB4YCL9JE8hGeoDG5hh2yU1sdtUj9Fgt4IXsPNf/TSynMeY9QJnEu9l4wSgcnOZIU3ck4Np3AMwFrabmtvM0DwNA5e5OgrdSMWxAjmv+LQEx5Qr8pmhtyuWT8vSSsGFT1anEdvemKXqalRYpKhSTrbfSAfja+NPz3AEbAk+9QOl57+IEpaTqjSXkZLzYX+ad8E2zgtXW+M3+sewfBRPpOHPHCq6yUu5JI8E8lvg9Cxopf8+rm3oBcHqLSV2P4zrKdDmsq0j37RhHjT15EDsEvQWE1K2J0HUxE2498ZL8Agkwg1OswNxxqR+Tyz83Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uycRh4HLJdntWD2rNrj+kpILNYNPCZ5fniarIb1U5t4=;
 b=fo7DECU7E+ab0yePS7o3Z3j9xwDnfI+pS0nMAWQndTchSlv5uOFxIC7t7JQI+ukoeaOU25CsJFY7iOaGEmV1JZRT8Sn+x0x4Fsw2S3gKKBZw61OtVeU3kPWYfgFZVXlBTCHMUuZaQoPbmpBiG8P8py3y818IhmI9riu2yOR1fZyg4amSu5CGu9SwNU3Insu+jUKIXdUzhO/YFbKgZPSy5a5EeoQOhlm3K1MpQOJ9E16FtdbUOVkSLc2szlSEEyt45LvmswvgNHETMTWbtudvni4pIszVNknoLKhGkVhzWGSgoIYqPZijd9ZEaT09TJNTSKzhZ2ift49tLySiiP96CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uycRh4HLJdntWD2rNrj+kpILNYNPCZ5fniarIb1U5t4=;
 b=j6O2nHI6ql8VYKG9NYpE2kAxPCcMDRUkXNVt2LRlOmwVxOLleQijejzTueIC0cltGKbgeLjzaQe/xoX5ybMJw3ioTvsRjCKxbLbbwDBdKtVHHDmyXWZTrLd24D7SqTeH0sPA4qQA6A7bOJYpJ1tUo+vCFCbnmFtW3FbOimvNfYdEp5LSl/2JbmqBuWNUuYtj6Z9a7U7hdWDKXVxWAGjAvLutoRbo7Y9lflJMLhH41WV/NN1TXcqun79Vzt2OAT69reGYI0tq0fP2Gr5aleW+mnDqlI5Ovv9xMWoCZCUbZgd1ufOgINHaiaPhbFL5HHRasBAXtfHsxLHsBt5EyJnTIg==
Received: from DS7PR03CA0033.namprd03.prod.outlook.com (2603:10b6:5:3b5::8) by
 MN2PR12MB4047.namprd12.prod.outlook.com (2603:10b6:208:1de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.34; Fri, 7 Jun
 2024 09:02:32 +0000
Received: from DS1PEPF00017095.namprd03.prod.outlook.com
 (2603:10b6:5:3b5:cafe::cb) by DS7PR03CA0033.outlook.office365.com
 (2603:10b6:5:3b5::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.21 via Frontend
 Transport; Fri, 7 Jun 2024 09:02:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS1PEPF00017095.mail.protection.outlook.com (10.167.17.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.15 via Frontend Transport; Fri, 7 Jun 2024 09:02:32 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 7 Jun 2024
 02:02:22 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 7 Jun 2024 02:02:22 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 7 Jun 2024 02:02:22 -0700
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
Subject: Re: [PATCH 6.6 000/744] 6.6.33-rc1 review
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <2a6d5b41-1f79-48e9-93d8-dff14e73dfc1@drhqmail201.nvidia.com>
Date: Fri, 7 Jun 2024 02:02:22 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017095:EE_|MN2PR12MB4047:EE_
X-MS-Office365-Filtering-Correlation-Id: ea8d3b9c-6fab-4fbd-96b4-08dc86d090ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|376005|7416005|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eXBuT1FMckRmcVNVVHhndEt3QmFMZm5oNjNxRENWUWRaL1FwUk9oQUg2YTBq?=
 =?utf-8?B?Yk9vdS9iVXFOaDhhUURPQ09LWFhhN1BEU1Y4WEQ4NXQ1dkRYdnBHNC9rOUNv?=
 =?utf-8?B?N1Vhc3BXT1M4SmdEVEFEQWxEOU9tVXBCQ05zQkp0cU9XWG5FMHV2TXZXd1lw?=
 =?utf-8?B?TUQ5Uks2ZTlwOHhrdjMwVVBqWlhlZW9DWWlHeDJRSnRIcGdmUFJUN2R3OFV6?=
 =?utf-8?B?NmRRTnNweXpJQ2hOV09UcE9JbHNodDZzL3h0dnNWdlJNZzRmVGxqOVBnWHV2?=
 =?utf-8?B?bFRLelgxaHFTU1ErL0FOQWExNVFVeVcvRkNqT3RvbXhWMW5QWXJDZ2lYT3Ry?=
 =?utf-8?B?ejkzckdFRXNpUnpSeUpjSXFYZjljNUZCbTMvVlRwS0J2dmd2K2xNWGtkOEUy?=
 =?utf-8?B?YTVZR0pwVGtXd0UwbEtxdDlJdHFGcWhVeXp4YWRtMlh3anl2TEVJcjJtRXRw?=
 =?utf-8?B?QVJMMEhKcytFVTIveWk1Y0hHZWN0TmZxM0orQVJwdnR3UGUxbm9vVVkzT2k3?=
 =?utf-8?B?cjBubWxHbHhqdzNBdStTd2thV2ozNDZFVG01K3VNSVBSRDFicVBJQnZSWGZa?=
 =?utf-8?B?a2pzcXdNYnl1c2VTeW5MOFZPdW80UFJ5WnFrVkt3dGd1SUlYNVRtVWErRXdY?=
 =?utf-8?B?WVFNTUNxZmZnSEtvZm50czFyOHNqOFNKb2kzc3phSkU3Vy85czFIK2wrWFFn?=
 =?utf-8?B?Q3RkTXBidWMxeURWZ2ZxRHNDZ3ZVd1BHbDFwN3NlNksyTVpRZjRJb3FJWmFE?=
 =?utf-8?B?UlROY1BaM01IOW1tWFFyNkxFZTgvOFduRTlqTkM3dWhRczIzRW92aUJsTThZ?=
 =?utf-8?B?V3lPanR0c3ZSdGZ1YTZnTmJFUzRMMTlqbEU1VjFJTE9yaXliQUhjNG9rQm42?=
 =?utf-8?B?V1VzTjd1ZFJiQVZkNVQ1U2hVa1RyNkRrTWYrQTZoYURlYnlHZmZtalpvam1y?=
 =?utf-8?B?eGs5MFFDZmdXeXR4MGI2MG9EeE95QitNZHRyNEczMFlnblliNVhReW9VY0Z2?=
 =?utf-8?B?d0cvVGVueVdxZ1VqbjB1czk5eEFqeVJhcTBNZW9rZVNobHlEaHpWTElwVFdp?=
 =?utf-8?B?b09BeXRBd0xyWDhQQ2ZVVkdEa1dJV1M5TGFna3JOR21FQzhSc0Y4bEV2WGdV?=
 =?utf-8?B?ZHdXRTdCY3VQKzQ3dkFMVGp0eDF6OUM3a2Z4NVhYOUVFMGllN0Rnc21KZUcr?=
 =?utf-8?B?ZVRLRTdVeVY2d1JuUUpiMEozYmdCSlVjcGN2L2VqZVB2TGorVkFhaU56ZHh6?=
 =?utf-8?B?SDUzZnJJcmRwN3NObUpKN0o3OEZMQW1vMG5PUUYzd0pPSnJncjRtRkxVYUNl?=
 =?utf-8?B?UWt6a0ZRYjkwcTdJVGlDQTVJUmptZkM4dkdtVWc3alQrNFMwcCtldEh6WXo0?=
 =?utf-8?B?Qkp6NHNpdkIrZFYzZ1ZmSWd1UHZQclowZW5zSGkxYlRPVG91NnpHQXNMd3Z1?=
 =?utf-8?B?WVVScWdwWjZhc1NBRnN4QVNvanVWR2xGdHdxZGxiNzFxdjUyTUltNVpJTnNE?=
 =?utf-8?B?WDZTK2syOFZuMm4ybW5tWEU4NXY0L2QvM3lBREplTEthSVpPczRvNUNWZDlY?=
 =?utf-8?B?MzVHK0Y3U2c4a3B5aEorRGl2YzBoQkp0Zmkyc0ltVTVXUnYzcXJNSDVlVE14?=
 =?utf-8?B?eDlkeDVvdjFINCtmdW5RK281QlpMVzdDaDNvT1c0R2x0VjNaU1hEaWZMb1Ez?=
 =?utf-8?B?dERubGl4OWQ4cFlDMVkycUJFMHgwMmVTTHpNdElFMjJBaVJPUFpPMHFHZXFj?=
 =?utf-8?B?VEs3TVNPcmZWcU1qVFFtc0x0dzJVMU9NSlVkL3RraHRFNGtiYTdUQlpPT05D?=
 =?utf-8?B?aXkyV2dpL0h3blcwOVpmVWZFNStDM2crMDZzTUtOSElFZzB3clNiKzB2N3hO?=
 =?utf-8?B?Rkp6MldkN1NMOS9PelpVM0I4VXdqTFM1ZkpTdzZIeVFiQlE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2024 09:02:32.2506
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ea8d3b9c-6fab-4fbd-96b4-08dc86d090ff
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017095.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4047

On Thu, 06 Jun 2024 15:54:32 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.33 release.
> There are 744 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.33-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.33-rc1-g39dd7d80cd65
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

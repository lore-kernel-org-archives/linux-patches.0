Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2082.outbound.protection.outlook.com [40.107.96.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEE0747F
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 15:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438015; cv=fail; b=XaNgOArQ1FmsSWMgPDk95e/zSpjkhvwX/SDwlQlMyh8kwjMdaqbKYDVvi0pYYlE8c9wJGPZT7AxunyAXZDRXzNDDNar7xofVkNvWnrQlv/LxZarwBlnJU8we3+2nwI2pByL/p74wDCoVJmYqdcyFRSOyi8Lo7aQuRIYh7gjCWqI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438015; c=relaxed/simple;
	bh=0UlqRJGUlF6yelFuMnvtXkQG/LcIOt7Az5P2yfFze9M=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=oaa7kyt6og/xLA9+EKYjGDmIm9YK03PpFdh2P3Ji6X7uai62FNOtvA3jzPUlkJAFF7RHgL1tMgHPicllUYB0HhLKoLURanGLNrWRs0pSg1rAZa4/u/fxIKMet47qjeynCSBmhAXTWzgAMR1puytJH9yghh4uZiofoFgqBsSxukA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DkniVtbG; arc=fail smtp.client-ip=40.107.96.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DkniVtbG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vftU208S2d7NnPtvZFGXGF77VfT6wjigBgP9jeTeQ2BgLxfYaWLY2KMWgx0IG1nOaSaPCW8pgVQweUPUy2L1uBW74DCOzl4LIn4/fltcEj4+W+oOCwk2MZYg8APgTYis9zdMSFiLAnp6KiZ1sS46Nc9lKucHpMLB8oYZEaZVOr7njrIchXm1wEj5vQlOdmSkTQhMNLCfWDbAgsgEwbcDZaqC9/1elQ6sc5AcpzfOxMaZQr+MlIAiVWEgLTrO0fk/TDSNyDT6NhxosWo/ZvD1YplkLxl2CToJVPUzQVCe4dcu7zdOt7QSj8eNgfOKFMn+NjoN6HVZkq3GOMqfsobwnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=doXqGm/6FIr9h8K1DsySdACw7xiIVU9al38vVW03gHw=;
 b=tMvFylZKtzOiFauFZEhOtVu9luh/2K2gFcQeBxVufsUOAvDnsw1hoymcHu20iGRxlhEeRSC5HbMxRmJ94wi0NRfUqGtQ14Mi13PCM+WD1tE1PqJfOoZmfN3TOPsAcAay17W5ycX7CdByodvOBYzIytHUg0qSLs+XCZkFYneYRlFMw3onyrGXT+ILKwICvSD6R8NPVnYxBhSSVwoyiozp6LRDD0YvAB/DubqTMFSrMcOuaUKlGrIqP7Zck5RPS14MHmuay570jp/QgzFb62dRX5Uvng0DFiG6Ib6djMJjHWdHJMXP+DdyFE2UNvIJiYPC69jcz6KVBFoBhqCVL8LRSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=doXqGm/6FIr9h8K1DsySdACw7xiIVU9al38vVW03gHw=;
 b=DkniVtbGAwmUW0r4YlKD4h6Xn6BU/1L7GWStiQMU4F/h0y9EB2t/HdV3RhcEjTvTcMj529+E2K4KU2qqKzY78sw8Vxz8/9J2aYLxlbEw3cXAiPsvlOrsJaFG6ljnROT8H41eV/KsFJ5xUdJq0pNQhhz+Z0LpVc+/GrDYSTu4i0GA8fGIw+IdpWS6Uhg2jwor1OY4Zi4RnUyr5O4GHsUSSxnq8KOminRa5nSYuFK9lyTql41BeCbOOP3IIY5C1eD5CHqE5K4Q6LUx4ZaaoaKyTrherFk+ifI0RQaHQOSwVgz1XpbWxnxm45A4L1ilIX6Y7G3fcgBoVu13mglUUYGRfg==
Received: from PH0P220CA0022.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:d3::21)
 by IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.26; Wed, 31 Jul
 2024 15:00:09 +0000
Received: from SN1PEPF00036F3E.namprd05.prod.outlook.com
 (2603:10b6:510:d3:cafe::5c) by PH0P220CA0022.outlook.office365.com
 (2603:10b6:510:d3::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.21 via Frontend
 Transport; Wed, 31 Jul 2024 15:00:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF00036F3E.mail.protection.outlook.com (10.167.248.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:00:08 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 31 Jul
 2024 07:59:55 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 31 Jul
 2024 07:59:55 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 31 Jul 2024 07:59:54 -0700
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
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc3 review
In-Reply-To: <20240731095022.970699670@linuxfoundation.org>
References: <20240731095022.970699670@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <7d1f6072-fd63-403e-a473-4f419f1badf1@rnnvmail205.nvidia.com>
Date: Wed, 31 Jul 2024 07:59:54 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3E:EE_|IA1PR12MB8189:EE_
X-MS-Office365-Filtering-Correlation-Id: e43cedb5-d65a-4a8a-0371-08dcb1717830
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TFRRWGREakRYVlZ3czBHMTYvaUR2MHgySjl1OGdFTElYNHlIL3NhRFY3amcv?=
 =?utf-8?B?eHhEbTFETnFuUGkxZ0twWTd5dlpwZlM4ak5ydTI3QUx3RUE5YVpJR095WXVa?=
 =?utf-8?B?VGJlRXdZQlR5YUlVeEJPbmpsenVONnNTVjBCd205R1dSTGN4UVllNkdBZlBZ?=
 =?utf-8?B?QU1KaC9Nc05GakIvMlF0WG1tK0FGQ3ZRSFdmc1ZqV0pOMzJROE9YSzcvcHRk?=
 =?utf-8?B?UU1HVGlaZ0RkRGN2VjA3eDFFcXlKallzeENnck5VQm9GNDhlSFIxNGJ3djNr?=
 =?utf-8?B?YmhhQjRFVmxyUnpMNnBOWTZOMFdVRVdTbW0rbUtKS0Vac2pMZFRuK3JZSllH?=
 =?utf-8?B?RkRabnhpaml4TDY1NmhoajNMOVM5amVtZExxcFZKTlY2L3NFT1N0VUIxeFZY?=
 =?utf-8?B?RUZUanpRbXI0SUxwcE9rRVhNZ2VwWG8xZEpXVGdGWEtndXVWbHN4SHhhYnJZ?=
 =?utf-8?B?YlRHdTVaSkdIMnErU2lKQnV2SFcxTnNZWVFwSnRKMVMvNEpnZHRjM0hWNDIy?=
 =?utf-8?B?RnYrT3ZHaHcyOFJBTHB4SGNydHVmODdyRkhSWHlFOVNCREh1NVhEYlpOZ1hs?=
 =?utf-8?B?UmpEVEFNVlp4L1lBeVJaT01FZnRBSHp6REFZQ1dEa1hUZ3crWEJMN1E5Z2xJ?=
 =?utf-8?B?ekxkdUxEUTl4ZEorRGxyeFY1VURpRDMwWXZwenJJQXh2QnhvcU5lT3YvZWN1?=
 =?utf-8?B?dXFkc2NVNHZzVGFXUmlHNW1nUlJQcEtyWGpOdHBzZmtIbEhGeVVkL3pFNVdo?=
 =?utf-8?B?aWZqM0tic2orMzBiZVBQVUdFTVNvTDVmclludzBBNlF0WnlCaUVlMUxRbmda?=
 =?utf-8?B?d1hxeEtNODdDcjZKL0pqUEJuZGJkSjE4SHlSS0RnOVRFZkRWbnpmaklicnFS?=
 =?utf-8?B?TXhxbDF3RDhoNHJpV0dEWlhVS3d1d0s4NVZyWWFiUEVYWngvMlJMR21vb1pR?=
 =?utf-8?B?RVFhb3BGWTRJS2dIeGl3YmdBOFEzN3dlUlRkaFZxYUo0QllPdWorT2tLSGVq?=
 =?utf-8?B?Q2hXVU9qUjdHQnNYSEJSK1I3ZXVJekY0Nzc5MGRJWU5DYm15Y2gwcldmblkx?=
 =?utf-8?B?ckp6NHF2WDBsWVFrbzIrRkYwdTFVYkV2S0U0WDV3SUV2bkZEWEs2TXlZYnZm?=
 =?utf-8?B?UjN4MUxyQjdyYzdGL0NWdEg2N015d1dHcFpQRWNzVTF1ODhnRzhGeE4wWmZz?=
 =?utf-8?B?dUF2Rks2Tjc4REpuWkNwT0RMR1JrY1RZaVYwU2NqVnRqaDVaNHJJMnZNeUVs?=
 =?utf-8?B?RGVmUWNTRjFQRjAvSkREdFdwZGlQdkdYUHFSRGZWYW1QV2xOOWcxSnU1akg5?=
 =?utf-8?B?MlBQOWhhZk9xUEthVHpENlcrMFo4bmsyaGtmTWd1UHVWZTBSRGVKaGZEUzJu?=
 =?utf-8?B?aHZKMkt1cHJyalhodmFRbWRZdlVpQWc0d2t4VmU2NUF3ckgzSnJVaWFiSEtt?=
 =?utf-8?B?TzIrZ2NoMUZaVkFjb05wdDNuRnoySFZ6K0hNWEl4VHpqMjZUelAwM1JMVFZx?=
 =?utf-8?B?cmhSU3BnMTNCUkQzejcxVnh3ZkhiMnBTZmh6MUNYVTRzYzNTbXdEc3ZzaUJH?=
 =?utf-8?B?UmtsZkllcnVKT3M1SVQzYmZuNDdtaU5FL3l0N2pOVTZBOHFRWTI0a0wwd1R1?=
 =?utf-8?B?R09ZeE9xRFRWRVRQaGRlQzRNS05lUXBNU1lXMnhwcVJUVlRLNFF1RDFVNjhN?=
 =?utf-8?B?VjNzbUlzY2J0ZXA5UFZwYkZvWTVhR25IT2pSeUQxUktSQ3VGMURrTnJyQjVP?=
 =?utf-8?B?VEtMMDlZVEFJV045Ny9mVmt1T1kycXJ4aUxOekFhanlaeURFNkxERlNHdDdh?=
 =?utf-8?B?U3lqdFBQalp1bFUvMWtrSXVTdGpWbXo1dWh3ZU5PcUpIQkwwQktoRTF1VzVH?=
 =?utf-8?B?WFg4b3V5b0dMTWJMQ3Y5ZWJvcGc0QytZOEY1WWZhTDdpWk9sQ0FNZ3JXMVZH?=
 =?utf-8?Q?gDLsXpcp5TgjgWXIU8X56SZNAHiQHDNo?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:00:08.4038
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e43cedb5-d65a-4a8a-0371-08dcb1717830
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8189

On Wed, 31 Jul 2024 12:03:16 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.3 release.
> There are 809 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Aug 2024 09:47:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.3-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.10.3-rc3-gdf6b86a465e8
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

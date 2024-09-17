Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1939C1C32EC
	for <patches@lists.linux.dev>; Tue, 17 Sep 2024 15:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726586402; cv=fail; b=esfRPh50lfQ5bP6MqtuA+7TUaSFtFBkKKqRMOGW9v5l2gBWFzhJ3Zr36Nj929fs561hSyGJzaRCQvST9ZR4cVtEGTTlnO6dQ2wYLH2y2OjQD29fR2xYm3+X/QlYr6gMZSsUANHhozcj6A4S0MjYk5PApV6+Ug5AI0B4mi85CfuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726586402; c=relaxed/simple;
	bh=/Su4v/j24akbPu5txyEubK+a67MnSw6DpUIwDhJy8Ro=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Glhl2IZrv6CRCeerzuU8GYPuU+ceIkHZjAqfxi7ReG7eAoQ0+aqQHaDR8UQ1caCkoi5vN478QxpJyJ9RKzI9BMZ05+TfnVhhY7Rfue16QLrxL6a/QAST4RUz4IMiPe8MZT737dml6ClNnp/heBxXVODJ/KVPNcqR2WUzZQMC4ic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hwleVkO7; arc=fail smtp.client-ip=40.107.93.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hwleVkO7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HWWmge31w5zD9PEysFV0p7Ee8akPeiurRZpM0SQgAOd/lm/tWZoLxF1d9R40HG/nS5DTgwKt7lT0djW8jbvtOHom9GEfhFiGw9NifldWuDF+pBKjh67tAZtRraPAv8aY7O2Vup/WoclvGA/My2ug0lFlwSxAHRo8k9EH41gAFgJh9S5Z45bIh1TpPZe1FpWLL4R20zV+1bEgdamK2Jy69FkOtoN3U3iqtXsbNA4aipUXqwAronNdxPsPriMjYXwh7QuQ73BEjDLD5KzVZcORmECHp1BKmF/H9cFJwUvrm71xeYR4sIjwrFwUp2iKy0DSMhJ2P2aymm5QzuqnVKxfpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6xcoGfDdKeOkpjFOxKh/hxz06DnRbwjgmKd9FMjr0Vs=;
 b=lu8uWhLtnyEKbFchBGDN7dD3N1tfX8g9gjbe6zYBCeiN3gzSeSwH54bA/gvwtQIBE/JjSDCr5gaCSV2qSiXAgguSG0hT0a+5TOiGu9JdIRZAj9IZ9qZR9R2gbVKiAaSwmeraOo9ATbjpN1RMNYPvIwV6i7JGXyalGV3pKFTkD84MAcEIfY7cGldtJmArZnowsZx2n7owRf3q+eoptfk8Dm3yXtCfCu8OGJf09MCVJiwXNfFo9aIJuawwkjW5Y2iLcD+M0XieVj6XQxd0F3sY9SGgW6w1kThA1J01FpxP7f66/lUOLzUulPuC8VcnQBNFoMkq0UASiIIxG1i1ev14uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6xcoGfDdKeOkpjFOxKh/hxz06DnRbwjgmKd9FMjr0Vs=;
 b=hwleVkO7tvKC1Ue9StU+CmyzJJVnIJVUJ7eT9qcmMxKWtFDQ17wJvsi4Pw9ObcbNV1ptLyM+ihhTRR3lHL1QqDyvTepMMjbjsi0cBDKx+bYC9/Hh5PIlX7TZBVet7Lf50UDr8cB/gBqCWjRnMZYB/APYFdqElYt1c3TrTfTl1/z+K2gKdzbo2JPqeWmb7ZRDh/mM5ubysP7+boymNccrIbKTVWGJlhPEPjOGNMAi9fFj5RHH5aZuoecGpXas15/w6iqgMLATEsrIgC88R98gVdBn3JWNHdwOiNKH7hZCrF5+Do8cp+Salfj8+7aFgsZNfuDRlBMb/BPAm52g3zHT3w==
Received: from PH8PR02CA0017.namprd02.prod.outlook.com (2603:10b6:510:2d0::20)
 by DS7PR12MB6262.namprd12.prod.outlook.com (2603:10b6:8:96::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7962.24; Tue, 17 Sep 2024 15:19:56 +0000
Received: from SA2PEPF000015C7.namprd03.prod.outlook.com
 (2603:10b6:510:2d0:cafe::5e) by PH8PR02CA0017.outlook.office365.com
 (2603:10b6:510:2d0::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.30 via Frontend
 Transport; Tue, 17 Sep 2024 15:19:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015C7.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Tue, 17 Sep 2024 15:19:55 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Sep
 2024 08:19:40 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Sep
 2024 08:19:40 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 17 Sep 2024 08:19:39 -0700
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
Subject: Re: [PATCH 6.10 000/121] 6.10.11-rc1 review
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <91b2a0f9-44d9-4f01-92de-170805f37d71@rnnvmail203.nvidia.com>
Date: Tue, 17 Sep 2024 08:19:39 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C7:EE_|DS7PR12MB6262:EE_
X-MS-Office365-Filtering-Correlation-Id: 1767a6d3-7610-42e8-9129-08dcd72c2fb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OEJZQVFDR0RpZ09QU0JCY243a0hVUVh3elRoOFdQQ211eGVsQWZzR25mWG5T?=
 =?utf-8?B?ZGJHOFVINng5VjBWZ0duRkdzNHpNNkp3SmwzRDBzOGplZ3UyTGVkcWh4SnZV?=
 =?utf-8?B?VWtEMTJqb2RXK2JTenZaR1g1eThDQ1QrNXl2M2ZnTnVsRld6c3FBdUt3OTly?=
 =?utf-8?B?Z1M4QlVGcU04YUpJajNwdzd4dWRRTTluT1lEMzZsVnZsL3Z2Wjg4MnM5blVJ?=
 =?utf-8?B?R2wvTmZzcnExU1FITHlPVnd2cVhndVBhdlJWMzcxdk14UXovRUx3amNyQUlC?=
 =?utf-8?B?K2Mzb2VCS1B4UmRvMTZiRVZEblJTbFYwTjlHWDBNcGNXakhlTG5abjJHVVQy?=
 =?utf-8?B?Vk5aWVNBZ2lneEhnNjJMcGZ0Qmh0c2JTS2dLUEg3YVFNWk1QclpMWGRLRzB3?=
 =?utf-8?B?ZlN0WXJTVHF1VHREaFg4TTJVdzdyYkMzd2V4ZzZ2eTB1cXNxMGpra2ZkOFJj?=
 =?utf-8?B?NGtBTzNuWXNRN00wYWZIdkVQdU04d245WE1Pb21xK2hVdGtDZ2hWaWwrNnlz?=
 =?utf-8?B?MzdybFR6NzkwZ1pHeXkxQk9nOUwvU1N2ZXhGY1hZSTIvSTNKWEVjMER5UFNW?=
 =?utf-8?B?VmFiRjJha0dzZS9EMzNlMVY3b1l5eGVGNURESXY0TkNwMXU0Z25ISVVQMU44?=
 =?utf-8?B?RFkzVFF3cU50ZFlJY25vVDZVdWc3VzRWWFgrNWFTdWFLWkFSb0pLREE1cUU1?=
 =?utf-8?B?dGpQOVdzL2tSaHVTV3ByeExnQjFUY0JEMGJiM3p1ZC94bEZvWWkraXFnZE9u?=
 =?utf-8?B?TFRaT2V2SmkzYmk4U0k0R3cxREdwcGpNelBURGNjeURmV3FEaFNna0l3c082?=
 =?utf-8?B?SjBxUGpxY3lFWDBkSjNpaEVKMUlULysyTjh2bS9Ka2tmdlNwUmhBVk9hZC80?=
 =?utf-8?B?RWJiaFdvcm1FdmJUUmJzU1k1c0FVMjRlOGY4VHJYUTZGVzFTbC9VUW1wN2Rl?=
 =?utf-8?B?czErZHBRWkpyZDRJanBOdFMvL0gzL1V3ZEFHSmJ2RytOaEE4NFozODlPVkpO?=
 =?utf-8?B?T2NSb01sTWtnMmo4VHhBRVJWei9DSENwQTk3Z1JPQWg0UzZRWWlMOUlpSUtn?=
 =?utf-8?B?OHNNN0JNZXBzVitEUUN1Y25BSTd4L2Y0RHlIVXNkbm9MV1E3TEROVW4wNTJW?=
 =?utf-8?B?c3RFb2tPL3dxYjBZVGNMRjB4N0xrZ3BtYnczY3grdWpvVTZxR2FxRHVXUS9N?=
 =?utf-8?B?V3FhU2tlNFZqTGtsMWJ1bkszaTJlRDlock91WVRTTEtmd2ZNNWl4bkZGWExY?=
 =?utf-8?B?MFdsSUVHZ3FERlJKZURxYlFIRWpiaERNaHFOYVBvZDVkeStha1ljakY4K0Ri?=
 =?utf-8?B?VVY2d21pMitGdDl2cWpxMGJaQUhiSVRCUkM0WCtmOG9EaGxTRStzVndvQTV6?=
 =?utf-8?B?Y0JXMGlXNHFsN1U1dGM4VFFwK3oySHQwcUN0bHVBRkQzaElack14dk12RU4r?=
 =?utf-8?B?VlZ3aWpEU2Y3MlJmWnBxWmVaQUo1d0RZdEV4Vy9RQ2d4cG83Um56dDUzS1hD?=
 =?utf-8?B?MHB4anRaS1J5T2tWRmd3SStTQkNST0FxdHQ2azlNUHBEcVpscG45TmdBOHND?=
 =?utf-8?B?VFRmQjk1MDVmZVVLSitZV0VOUnpvUkNzZlhqdDZmbTJhQUFvV3RpTE1GZnZ2?=
 =?utf-8?B?aDZJZ05GZkJ3OGtheTEwK3VMRmx5OUhSVmNLUG00U0JXYWRjQzlYQUd0VlZ3?=
 =?utf-8?B?RzE2M08ySUVLSGRuR0x0TGI2YmpZSjBqNFRzRzNnNEtuZHVwUi9MOU5WaVBB?=
 =?utf-8?B?WTV1V1Qrc21GZ2QycFdHakxic1IwUnRUbUNXYjJHNGJoMkFnc2xGUnl2QXdX?=
 =?utf-8?B?NzUzTkFXOTVRZ3RQQnBHaEo0QlpzZDVmYWRPazZZL0J1L044M1pmN2hvV3pr?=
 =?utf-8?B?NHhOUDFPSGdaNGZRMGdYRi8vaUFrclhTSVducDVzWnJYZjl3U21mTTIzYzg4?=
 =?utf-8?Q?YVUze3MrwWH+cig3HJLLpkYDMKORujdr?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2024 15:19:55.7453
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1767a6d3-7610-42e8-9129-08dcd72c2fb7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6262

On Mon, 16 Sep 2024 13:42:54 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.11 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Sep 2024 11:42:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.11-rc1.gz
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

Linux version:	6.10.11-rc1-ge9fde6b546b5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

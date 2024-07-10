Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAA68120F
	for <patches@lists.linux.dev>; Wed, 10 Jul 2024 08:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720600494; cv=fail; b=XIWc7BVdMpuedSOMRZ+MJ2bsZ3CawElAhlt4hvUmlq1hUIiIPsfe86+r/U6ebLE5l2xZtIThLPbR6pNtazCkwkPTYRzzh+GqVa3Ey9lnswJRXgGGxLLxDRTG23CDGlOuiRtN3dctk503Ur0H98DW4/0kGoVHCIllHxyqDG104xU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720600494; c=relaxed/simple;
	bh=4f6qaiU90VkP+AtGUs+fgQOwB/Ayn6ZugbtV3jReHPk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=BufKWmrycoreSFUjwy+EykHanioaYbH9JH2KyjNIto1KOZyynn5qA7gy+KG+egHYjeF7BSPipdVE68WWRllXEKnY8CdVX1tNIN6HcVRJQByXuRY9ze0NxdWAwkm8lR8Fi8C4XcbSPilwRsnpG+waNGgrW2C4Mhtl7FW1GHwsyj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GlvpgmAY; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GlvpgmAY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UfnQgqIsfosz1fDWQq5mIjFV26//dE5zdaxKYYWx//44/l4/oxYGZNFG3CVB0yi+pZEh+9xBCaK+HPSxr8si5ppYgdkTdCt8d2k+66FmTtN3zBVOrlI1TgDMiWHh/hrxAkTI0BP8uDgVv2XiB1ZmQwWDSEooCDV5hhVBUzCFiPn5lNxX1jVIlOCqOPyqBZC5gKfiv43tezxdQV2wd313BXmwAy3SXBltHqG+EYvrg1ZvMAeuZCYVe2FkmmerOLpqimDextjNiDjpCf7zMIOfhnwaVvCq5y291qPHfjIaDNqtXJ7WGQZDxut7DaHqSqZtqA9QXUblB6tMgTi5tFtWbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yLa1fvw3Qp9Znp7KUugDDlIp9gXuUTASSV+rXHfT4bc=;
 b=V2tbRNodW+UwtIQEVcrKnmpcgONyF4c5OxzdSwNFRbrIERn75SXQyisFX91XkZXT9JOeo9ydvb6ArdIK2L8oVwSzdUL+60CqhVY9FkfVWXjpeZUmt0qHN1SJhZGTQi6CB6+6pnA3FDT7TBGtVPCjfd7vdaAxjlapS/uLSy4mXBTeKUHhvA2tx1N3T5gOiPj8mOtpreiIZcgGBQpKAgbYyMNuRpdNmSmY5I0ehowws+KAxWrQT+hr0+nRg3vs0K3mm/26FeBBkS3+y8rlcyuJefIXzxRo4d8sa0lDB6EiHlqgSuMON18WXRTAGWPrEZkz1K1FM1opzIYnaFu6GNUl3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yLa1fvw3Qp9Znp7KUugDDlIp9gXuUTASSV+rXHfT4bc=;
 b=GlvpgmAYlMu9qndJJSoL5M98fLMs7J81WGuK4rfSr0Bgd59xvJ8B0Kc7Uzwz1E4UpesJemPRU1CSTMGz2h5nvnnba+94jONWt5C3vD+Da0RQYvv6q0SwHmkoYoMai82NoHGIB8ejAnKFWE8EwcDSDY8dPll6WUMmJoql2CZB1SWiXqcNQgMu3PZaXruXO74np1HsKzd6uh/TeXVL3H24MztV/NBT9bfIGn2e6MNoIxJCfhbOSRgq4UdS2gBK+45c4bVJE0V+ZC5xP0WihhR9dqCI1mxT+hpBY4/MGJ7CzN2GAS0EyhkzeAHAJ291+8M82etjhtX6MY2c6H8RRg8+iA==
Received: from BYAPR07CA0059.namprd07.prod.outlook.com (2603:10b6:a03:60::36)
 by DS7PR12MB6023.namprd12.prod.outlook.com (2603:10b6:8:85::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.35; Wed, 10 Jul 2024 08:34:48 +0000
Received: from CO1PEPF000042AC.namprd03.prod.outlook.com
 (2603:10b6:a03:60:cafe::bf) by BYAPR07CA0059.outlook.office365.com
 (2603:10b6:a03:60::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.19 via Frontend
 Transport; Wed, 10 Jul 2024 08:34:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000042AC.mail.protection.outlook.com (10.167.243.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7762.17 via Frontend Transport; Wed, 10 Jul 2024 08:34:48 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 10 Jul
 2024 01:34:43 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 10 Jul 2024 01:34:43 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 10 Jul 2024 01:34:43 -0700
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
Subject: Re: [PATCH 6.6 000/139] 6.6.39-rc1 review
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <83ef8ba5-935e-4b76-a511-2a9950ab330c@drhqmail203.nvidia.com>
Date: Wed, 10 Jul 2024 01:34:43 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AC:EE_|DS7PR12MB6023:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ffbc7fc-f32d-4fdc-3cbe-08dca0bb28c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VU9vanVrREVxZTIwQmVkRnBhZGxIZXFLU0l0U1UrbERDMHRzVzBOQ2UwbDda?=
 =?utf-8?B?L09aV0J6SXBsNnM2WE5CMFJIMDBCSlI4SnJnYkh2cEtPSFVGRUlTckp5Y21l?=
 =?utf-8?B?NVBJdU1Ub2ViNDRoT2pacDZ3SFNWc3VPUzdHTVdZZ3Vmc2pUYTZKWit5Rnh2?=
 =?utf-8?B?eXFIUlBRRkNaMVpIeWVNUnhhNmtmN21aai85Z2I0aHJGdFJKeG9xaXlpNFJl?=
 =?utf-8?B?cnI5SXA4cVd6SUluMFBDcmVCTWYwSlhhUjBlbDdDUnFiVytvN1hZQ1BLK0xG?=
 =?utf-8?B?akZjSUplUm0rMDBDdWs4MUl2WEwvU0NwZndtTnpOTUJ5QkFya2hTR3JndjF0?=
 =?utf-8?B?c3BxOWZnSmpzcEViNHo5MDlMNXZwT0c3dEJEWUFYbG1nM3hDQ3d4blk3bnJF?=
 =?utf-8?B?aVRaSEdUQ1UrQ0I4UmJibGR0SUlNMXJLbUdCRXZsRk13cVZWTnZOM01JN0lx?=
 =?utf-8?B?WFJ5SWdHd3pxV1BBc0Q0dThrb3Y0d0xNc0piRzZla29GODNHSmdab3lRdFgv?=
 =?utf-8?B?NTlTTm1Na3MxMXQzcFVZQm1yeVkxZWNhcGNZNnQ2RlkxUnpOaG4zelQrdy9F?=
 =?utf-8?B?VXQwVVRjZTM0UjNaelNKVWNZbkFjZXRva3VaUjJEaVQ3OUQ4YS9FMnZnOUtH?=
 =?utf-8?B?TDhoOUFESmlnUlNqV3JoMmFGMmZSOVQyb1MyenF6ZHU4bmUwd0FhZUpZSTZ5?=
 =?utf-8?B?K0MxenpjbEdFYkczWEN2RkVmSEhkNEFFeEU3SytIRkswd3Z6WmsrQ1BENzZ4?=
 =?utf-8?B?Y2JMWUJia01nL0hPdkxCYUpWK1MvdFZYRG81YklQVWtvS1RzcUFqRXNCa21x?=
 =?utf-8?B?bEVQbnk0WnJkdUd1Qi84SGFGT1lGSitaOGU5aG44S0NEUlpQYjFGbHl5VzdQ?=
 =?utf-8?B?aGZzQW1ISThmOEhWR2w0U1BSSUZhS3dES3J4RUpMWDFodkpVbjdvMFg1RTE3?=
 =?utf-8?B?MG5SY3FvUXM0enRLM1VsQVFWY3RCb2NqWUZhdUxOamdMVXErZXFEQm1obmJl?=
 =?utf-8?B?OUIwbmVVSXBiN0hUT3ZNNlRPQytqdmdQS3BiVDdYSXZhNjJ3dzU5OHM4c011?=
 =?utf-8?B?K1pOSHVkb3drU1pkSGlyaktldnJSZHZHWEpCSDFBcUxvaCtzMm8vRmQzMTVM?=
 =?utf-8?B?N2YrRUk2akRnTzYxdm5raU9EMkk4ZlV1WHgwUXVFOW1rMTVDa1pOakRVVnNW?=
 =?utf-8?B?WHd5MndXWnE3UEh0cmZoeEZvUzVhZDZOaGJ2VkRKcWVyZ1l2cFlHTWxFd25K?=
 =?utf-8?B?Vkk5cG5nT0xTVzVUbzgrSWFtekFkcTgyOVJRR1ZMd2kxSG1XcWg5VkxvRk5N?=
 =?utf-8?B?RTV4K1ltczN2bDRqZ0hDWDVlYnA3T3J5akVTVCtESStuVVU3dGJUVWpwM045?=
 =?utf-8?B?TGM1RWoreWtxQ1dYb1BtQ3ZUeGlsWEI0eHhRSWxpUFR4QlQrWVdjM21JRnZn?=
 =?utf-8?B?N3QrT1pId01jSG9VdTQ1bEJNS2xwNUVJNE5DVkdsRzdaZHpIUFA0aFZCZWZW?=
 =?utf-8?B?ZVlSSHdSV3h1NWVTWGJsdXNWaG5XMTlnTWtMbWdSc1VLYitqK2orNnYvajMw?=
 =?utf-8?B?ZFJ0YkI2dHZMS0U3Nm1KQldockx3bm5IQmJYMG9XVXFKRG5vZ3lBT3BmL3dr?=
 =?utf-8?B?TjdLVnhZRW8ybHpvNnVNc2ZES3YwSm9iNEMyWW9OVkJhSGFPcC9lMUx6Kzdi?=
 =?utf-8?B?NjkwZUZmdjNYeVdUTFpDNFhHTEszSjd4MFp0aENoMkJ5azJ5U2RKb0tLQStl?=
 =?utf-8?B?NEozZ3hVMnk1THcwRHl3S0s0bXA0YmFIMU5pc1RxbEd1bDlLU1JySk5EdG5K?=
 =?utf-8?B?cHpvUmUxSS94NTZ6TmE0N3R1cUI3UWFydXBqWWUwQVhPQnYxZitNZ0RSZjRE?=
 =?utf-8?B?VHZrRWRrTndYM0ZDeERya0U1UU9PcnpTK1VCcDNBNm1vQzM4N1lLLytzWGdD?=
 =?utf-8?Q?K+dyHZ2kzaYid1B3DGIQzO7ZluUTpqCw?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2024 08:34:48.1976
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ffbc7fc-f32d-4fdc-3cbe-08dca0bb28c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6023

On Tue, 09 Jul 2024 13:08:20 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.39 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.39-rc1.gz
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

Linux version:	6.6.39-rc1-g3be0ca2a17a0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

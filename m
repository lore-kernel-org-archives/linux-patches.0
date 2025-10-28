Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010060.outbound.protection.outlook.com [52.101.85.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A2930E0C5
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 11:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761650964; cv=fail; b=IJwRNoc4Yys82jIwtu3Obbc7CrNtNhLq6+PRey3T2bnhH/5A1xeDNxkxsDECHn+itiAJtf6Vv4E8to3ZpH/Uf3rJl482IZiVO4I0or6C8x2TDmNyK3bOBomh3Szvt9x+4lbJ7ps3x2iKsbwRaoOtitoNTMz4hQdIfOTMreMVj7M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761650964; c=relaxed/simple;
	bh=R7uJ9P2kdN2UMWLR9os1Hi7ZfI3sAoTV5n1MwXNGHJc=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=ktzCzupzpv9w/lHHFyzh5ORUZSLbjqgq5thTd8EUPN2I4EqIkeQZ7hZj90xWsLNFIYH7Qq9zAtpXQNcGcFLf+2Bxaovlgfh2l6gOAIe4yV/svTU5cFua6aU0bnEbIo/FqC2ScUbrQ9mOL1OWaVKWahRg4SjYBBseSJYUl5/rSP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uTGji5+w; arc=fail smtp.client-ip=52.101.85.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uTGji5+w"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rUwXcN0YU959x3SDS6sw9SLhFRthZQ2g6aHPLJRcsRcfpGz2TiCEGBx/unrS8B39jNz6S7pTJ2GqSMqM2Ujed+6Hj8uLJRn0w6f/4QI4jEDb6KlpuoHCs0DIQQthnYN/cmXYpU+M0O6u3PQo4iGo6MYOcLnvYQ1Z1wQEn2IBaKOynQ0bxCpbW8FMhnnjpLHKM6lx7ffbKJVsC6yz2X4lghbpPMlDnCT7kI3+500l9t/KZ8hAoFESl3FEPXMmNryeyA45Gmy7z8ZbdpOGsndeks5n+uoS74BSo3pZE2IgJbyGU91XfnN2FSAnrlVJuib9FBmhPV74z3nCVT3qW3IaAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ODb/ukmDu6F0QR3wwaOjOX4l9bu8VF2LlJRF0/vnVmQ=;
 b=qZ/sxMXQVvtxVJturlPeZ+CCIh36Kei7c/+ej6yaTlE9wS5ruSGxPlO5Fn9g48kQ9fv0ZH07yoKSYNhFmoea7WkwkEkGl3X5MZyqdOVdho/RmZk8hj0nSe5iZwYKza+XUsLVfPYWTG8D+7gbjuemRrhZVBsJGdVr0f7C1te3rOFJ7QloqQP128yzcl+r1v5SVf8ADbLPkcVUBHmCsB4QR6+28E9ZboHd74tWakItqJ9o2fckFN+tjpRtKjoYFfeq6GQkwdVNfZ6+3sqnv54sU7xUHY5oO2mLKb9SYxxR77JPVNx6vOKHRSuDmYaKtdvVpOeWi8WO7QExlAw0hIZCtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ODb/ukmDu6F0QR3wwaOjOX4l9bu8VF2LlJRF0/vnVmQ=;
 b=uTGji5+wV8AlG/Zyh6R4/M5Ksf45Vs0UTmBGYOT8PvkcSWXJneuXrJ8VmNvrPahWJ1UOUvaUZ2kfOWDjVmOzTDI3loDN7Dx6fuWIhnb/dQXD+GtaKHoQ0lNlrg2KdphiZxAAWqg4o+VAq/gMBvisj6deSzzOTIuXCUcGYSuCX73RYtxLUS2qfdAJnnESiFR++d2Ls486H7s5VWzoATvZSRKbz+LOx0eJ5V78D7UZkrVqjuqbnqKUUyeQixycOvFAf8v9vLd0AsD0JqmoeGwQpi93oVE1reAz1zGiOeCBu9DOHvsMHFu4G0iH8pVcSgScoWGxNebGR7xvTeatyHeIkg==
Received: from DS7PR06CA0010.namprd06.prod.outlook.com (2603:10b6:8:2a::17) by
 SA1PR12MB5658.namprd12.prod.outlook.com (2603:10b6:806:235::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.18; Tue, 28 Oct 2025 11:29:20 +0000
Received: from DS3PEPF0000C37E.namprd04.prod.outlook.com
 (2603:10b6:8:2a:cafe::d7) by DS7PR06CA0010.outlook.office365.com
 (2603:10b6:8:2a::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.12 via Frontend Transport; Tue,
 28 Oct 2025 11:29:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS3PEPF0000C37E.mail.protection.outlook.com (10.167.23.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Tue, 28 Oct 2025 11:29:20 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 28 Oct
 2025 04:29:09 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 28 Oct 2025 04:29:08 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 28 Oct 2025 04:29:08 -0700
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
Subject: Re: [PATCH 6.17 000/184] 6.17.6-rc1 review
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <d1123eb9-dd76-41fe-a775-87ff71455d4a@drhqmail203.nvidia.com>
Date: Tue, 28 Oct 2025 04:29:08 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37E:EE_|SA1PR12MB5658:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c90b625-58e7-4286-9d24-08de16153ccf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SWVTZGV0TFlZMlpkeW1VTTBpS3RvVFhlNjJBbVpHUDhKdTVOZzhsQW8xcHk2?=
 =?utf-8?B?TFFBb0dud3dScTQya1BiSzhDV2FmbVp3RW5zT3l3amx2dGMyb3hmL085bUph?=
 =?utf-8?B?aHhNeVRXL3Nkclgwc1FxblM2Z1dYVDBkcUl3QWxhSFJwc09pVWpvMkFXem9V?=
 =?utf-8?B?cDV0V3BQMWhjZjFwQnh5WGk4SVMzazZKR1FCTVR3UVlZVVl4RWlrNUxIMXMw?=
 =?utf-8?B?b05OSDRvR0tzZHZGVnVrQWtqaXdFd2s0aHR3ZUdSV2FrdUZTTDZib0hOVTk4?=
 =?utf-8?B?VHFPVVNVTmlBVVRmdTZhWGpGckRqalpkK012T3hmMHpybGhVNUFzMTJaYXQx?=
 =?utf-8?B?N2trRWlQdkROcUVPMkVYd3I2TDl2cGdSUlVpbHgzU1E0SlhidUppMFJhbG1M?=
 =?utf-8?B?VWNBclp6a040eHZCT1JzemxueVJ4ZFlPbjlzeHhFaXlPQ2RhRTVFR2pjR2NX?=
 =?utf-8?B?UVdDMS9WR2JTZm5XREh3Z1FjY1M5RzZPUE5DZG01OVI4UW9WTTYwWlBWZGQ0?=
 =?utf-8?B?WkRiNG9vcStQNWNlbWJYYTFaQWlvWGN1L3Nsa3lPYzlvU1lUL2dQcW1vZ0Z3?=
 =?utf-8?B?cyt3K2F6S2Z3bEJUTzdmbk5OWDIwd1h6ZzV4UVZjc3l6NVlJSEhMTVc1WEhv?=
 =?utf-8?B?b3RudDRlRGFIR1NtZTVxSDZwS2g1YlM4QjZaTTRnZGpOcGFYTnhhRlc3L3Nw?=
 =?utf-8?B?TGVVL2dLNHdaVEc2aGVlZHBkWlhMdENkaHNpa1RsSHJubUFiUzEwNnFTSFdn?=
 =?utf-8?B?SkhGVWsvaEhLajRQOWdjRS9IYjdObGRwMms5QWMyU056TStqRWJkWFNCMG4v?=
 =?utf-8?B?SThpSUlUemtxbFJtcmlLNkEySnZGUWYvOUR4SHBaMkFiNU5Qd204eHlNVjNK?=
 =?utf-8?B?OHVRR0dLcERJTlBMK3FYVitzVFN0UFRUeVF5c1NmZTRyZkJMMGFzRG1FSkdM?=
 =?utf-8?B?Z2ZBbUxLQ3NScDlTb3kxMjN1Z2QydG9VdGV0c0ZtQmFzZE1nb0hEblRKSFFZ?=
 =?utf-8?B?VnliMXdSdjBVb1NTMjhFMFVuRWN0WVQwQlkwN09KUk1GY0lMdEQ4ZHcxNEFn?=
 =?utf-8?B?Ly93Zlh4Ly9UNzc3clpCVXNMQnUvMTZudzQvTlM1K1NhQWVqWVdMazZHWjZJ?=
 =?utf-8?B?MVdMOWd2TVpiK2VCMmtRbUVwZUdsY2dQQ2FSS3NIaVd4Tktud1prUmFNY0Fo?=
 =?utf-8?B?clFnemMrS2JOTWQ2MXhiSko2VG1neEZZZ0pXUWlSSmZ5REx4TjhvNXVqTEVX?=
 =?utf-8?B?RnhSekZhRGpaT1hqSVV1ZFNPWGZReVRTaG9rYll4QXhiZW1sMHpYUnh1QUVJ?=
 =?utf-8?B?bEd4VWZnZzBKMktoSmhNOWdMT1haVEY2dEJyZkVGUmZoK1BBNFI3QUwwak1K?=
 =?utf-8?B?WE90OVNHMWk0emtRLzdvSmhEYUR4N0ZwaXpGbmFqWWl4eFBZdmV5YVpUWU5R?=
 =?utf-8?B?eFFiSEdZTm1KYzZrMC9RUnc5UkhJeVI3ODdVbWU3Z2tZdDFWOS93MXIweDhp?=
 =?utf-8?B?c1hYVUtJOGc2aWNCVC91YW9XdkNDQ0JKZ3lKYVlzbFcrSzNETyt2d0U1OTR4?=
 =?utf-8?B?RU1WWHFhRFk2dnFxSUF2VUtyS0JNU3d5amNnNVd6UnB2VGptYWpQU2c0bEtT?=
 =?utf-8?B?aGZjZmVNdDlKTmphbnZuNy80b0M0aEpzSFhxUWNqa0Ira1U2d3U3ZkxuT2hq?=
 =?utf-8?B?cHZRT0t1MFJMZGRUcFNLVE42U1RWaldRMjBadStXem0rejRXTHJKYXBqNmpv?=
 =?utf-8?B?ODM3OXhuVDMyYzVOd0NPTjVvZitaTHkzWnBGSk9IQVpuV05mTjRaVE9OL0R1?=
 =?utf-8?B?VmFRdGtwcGN5MXhXakF3cFhBa0JiN2dFMlNveFM1dkpPRTNRcHJRZFBCT1BL?=
 =?utf-8?B?YmduVlRxdzlpTElyQk9lSHJzMzJReTdPV2ZSY1V3S0FwNlJLeUhnVG0rTHZy?=
 =?utf-8?B?OE1GanVOamttNlRXbkNWVFZIcFlvR1FJR2V2Q1N6TXVodlovWnMvdlNDUmNn?=
 =?utf-8?B?UG1WaXZzUDVGVlN0c2VRcjg3TG9UMkxhYmxPUDFtL1dTQWlGZXVOdjJPa0Rk?=
 =?utf-8?B?Q3lSaUlHY05QTThyT0NsQVhoN1VNS2JUbGdQNjF4OHNXZTF5UC9mSVU4RlQy?=
 =?utf-8?Q?WzUo=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 11:29:20.2181
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c90b625-58e7-4286-9d24-08de16153ccf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5658

On Mon, 27 Oct 2025 19:34:42 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.6 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.17:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.17.6-rc1-g10e3f8e671f7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

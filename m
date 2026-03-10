Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011060.outbound.protection.outlook.com [52.101.57.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958A829D29D
	for <patches@lists.linux.dev>; Tue, 10 Mar 2026 14:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773152577; cv=fail; b=QIagMzOuQlSrGHoxChjvVvcTojoP3+wbv8LoJ7uBUvmgZRx3S1mJhgx8LHhzNEUvPf8lZMBrW96efiyLl6NRDFo0C8q8mr7BHIijv0pIYMcrW+OF/GXTxEQeDsOVpe2C5DSHM0BYgzRrKTZ3KFJx42oUsMCIiTJcd7VGsASAxO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773152577; c=relaxed/simple;
	bh=fLZEu1cCFbIv7GxVvfbeTOArNPMZE3KR5o3VpVMruTk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=nqtUafzjWEGz6GGwTVNgpc9pdHqWdscuyoPeIvrFPRW6TM8I98SnEmCTuiHlLhdt4YefUonci04t7noMKPzfaR7q4FRwQJFXsxNWjt43bqlQFfyrwsEHrejOThzKtoNrc/buYw+lNCMPdou5tu10/ZP/pzvYLwTTVZqgSUXaO4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FCoYknYx; arc=fail smtp.client-ip=52.101.57.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FCoYknYx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BX7ynv28NdchmohCaTwEJ+l6nRVFMZSo4OmHGCGSpoiM2wjpkhYPm1a5dJqVHGXvtxPwudIbjVxz4w5DWptMKIqoSm4bzhTlQQaHeAHmsFOX03Tq2NyrmPdL2dmheJTVyZDSxa8580LwZx+fkUkKxEV1zrWpH5uKwZDgd+2nCzb5ae23FYgAWO8tXv6FvRNIrW5K0VID1U239Vo5Utsuee2B3JZtMOGk3DUN5Le0kp5WTZpB5SVVdyglR8sUMbJT7bdsJXOlmsVJj8WvAO4UcguaxBrYzVFhjDs3XjUj58k6VzHTfIBgNayH9qncFCUlZWaRgfsRWomzN/YrsHApGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mvYjz4oKV99sDwwIOk/E79G++4EcIhdVEHfnO57XSDo=;
 b=JLss8vboOcffhD55ycVmge6/Qs/WBBDkjVAaKerYkiLBiOybXvH8x1seKTzeWIQLKJutqsNA2azu5NxaLs1lIbFHEy9kawFOWATFEVw57SJ4i/481yS8hOJB94/3G+/lgdz0UOZx7rQYfvdseaRunQmtKofGK5bqSErLDDr+6RZ4B5cIyqqQfxmFxCcWwoYqLIAEdrktrH5lhYkzPOtQ18q/95046fkNSf/ccFfCaBOtXWGSQw/6j0jy4jTjcRzJJkmsS5iGmaIPj6rrj0OiWLgKULg6vw8/7GNwqNn003OML1BOnqV2MdiMuYEHjKhV219aJbr0C9BWOj9iH8pdbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mvYjz4oKV99sDwwIOk/E79G++4EcIhdVEHfnO57XSDo=;
 b=FCoYknYxBN/wuya7hc9O1yk0CYDZdZzUJHUrwUZWvZXMRRVKbHWJgl+2Qwys9QYMLLTkHxAbf8rgzynkS4QGcETaCRqCcG+1aHHC0Hjl+3FGA4Ez5Rt0+PILIa2sOqtxjSfxG2DvudpabS8/3dBI+rFUB8hZW0Ardru+IHshBo22f6bzk/7wT0F9MNcVPvoPVrBwey8estsLajHvOaZQ0eigUg3xljuPvpsxNx3W9cRyJn2WIFSYauexg78ZCP4tK4V70ONcsFV+hFusVFSsadKdjdM82k8KZHqWbGZzmVvO8MH1qOdbIBQTz67OKzcgkbRLjfviGWdhUth5oRbdcA==
Received: from BN0PR03CA0017.namprd03.prod.outlook.com (2603:10b6:408:e6::22)
 by MN0PR12MB5955.namprd12.prod.outlook.com (2603:10b6:208:37e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 14:22:52 +0000
Received: from MN1PEPF0000ECD4.namprd02.prod.outlook.com
 (2603:10b6:408:e6:cafe::27) by BN0PR03CA0017.outlook.office365.com
 (2603:10b6:408:e6::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.25 via Frontend Transport; Tue,
 10 Mar 2026 14:22:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000ECD4.mail.protection.outlook.com (10.167.242.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.18 via Frontend Transport; Tue, 10 Mar 2026 14:22:51 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 10 Mar
 2026 07:22:25 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 10 Mar
 2026 07:22:24 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 10 Mar 2026 07:22:24 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Sasha Levin <sashal@kernel.org>
CC: Sasha Levin <sashal@kernel.org>, <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@nabladev.com>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <sr@sladewatkins.com>,
	<linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.18 000/314] 6.18.17-rc1 review
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <4814d0da-b6e5-442e-93f4-fb4f9e540bfa@rnnvmail202.nvidia.com>
Date: Tue, 10 Mar 2026 07:22:24 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD4:EE_|MN0PR12MB5955:EE_
X-MS-Office365-Filtering-Correlation-Id: f09ed3ec-7c55-4a5c-34dd-08de7eb083a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	kTVedmvoJ+KXSZt0BexkJnFGDoShjJ7lXGqbjqB+7MbUVvDfE9aR4dRHF66IyDhAaYBUy01s9GzwTeLL6EawLM/EpMGan0VYuoLqYoET03SB69pFS9r5mR6+zepGWZcS25CI+d9jBW8gWEzao9snDa1BiCE3AVD202OVsJlojlYHCX6A3pmKHOyVORzRnnfe7vFbp1SNJ4xy8rXkCQJkPxY2DPScPJF2yXFaqgOhA3/AIp+vFVH/KchCxIht/ezO0e71QplsPdL0XjoCbVNtq+VWjcihkyAtE7Ffpl/mZZB1xB9qw1qEGmqKaqWq+0/F3pCOLFOpTIHrxNDDQv1BJzNJcED4X40/GRRU/aRjiOCjXz5Ry+HTP2LeZDkUIyMXnZB3KNi1yViCgr8Xpygv2pkxJsn1uPb693vGPO3j+r1CWNfc8Gao1jA38K1/3KYmwJGBKfS19z/Tu3FhK9xh9Psq5ahaeLj6yX5eMPxISO6/znkFCcngyuCLHcVI/3DQnc/l0sqnqM0Lb9Wi1pkpwJsw+AHaV2kQjdnbD9j0nQpw1t2xQ02UNTG4QyGNXCAJxrxekybvVeJWFrJ9sQ3tOMAjOVrCQbdglDSlmX2Bj/tMo1cvpdZG/MfhNvrhdxCkp62WBHDnS9bAojGw/9AcvOz1G9uk12IQOaClRH7nUG/KPtT8Ol0LYpQqEjUqb7u+2D8YHCvKLM9Yar4xyeO3bWzC3tX0rCbW7mC6f+lq9qLgqNykj6jl8HIgS2Qse1K85QjiBAccn7N76+KpnzdMsQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eChWv5y8LpH9W22OTYJW9zdVSc/muFyrNP1SHXJ0KfYBbQGcKmsn/pA7AVacR4T/Xw6RpGfoIh1mdCBAUegbVCgMWiRkz+GsiA2G2YtC14+1Q6XVoPjrdyMciU/zRK6gOwlrwQDgtDoeJRCnLhGe2v46kAQ/coBUvO7i75tqD7hIP1kF/eef5oVLOWQgl/lKri4vFzpNNQk4/oLwlBfvS6JFR/zrBxmotZ7xq/wmOluD4TEfTpKvqAui6xyb2Uajo2KlMCqp1oCFaKsW2G/CR2mnH+A4Lcvvx3w33e5RphuCwOzjMSy//OVdkdqc0xyVx+1m8L+QViLDYMwJzmYIl60TQcpvkUvATNXmoWX0kaumz8FWFILD+czwggqxDU3ZV1yc3sFDW2N5auIQ2sEi020cAGEMLBi+GizcdC4QJlDOCu87eU2UJV6+DsPWU3/9
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 14:22:51.9139
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f09ed3ec-7c55-4a5c-34dd-08de7eb083a2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5955

On Tue, 10 Mar 2026 07:19:29 -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.18.17 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu Mar 12 11:19:16 AM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/rawdiff/?id=linux-6.18.y&id2=v6.18.16
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

All tests passing for Tegra ...

Test results for stable-v6.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.18.17-rc1-gc86e53b5f779
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

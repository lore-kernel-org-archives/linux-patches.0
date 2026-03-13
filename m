Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012028.outbound.protection.outlook.com [40.107.200.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447E33C3C10
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 16:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773418612; cv=fail; b=O5kCbvclBEkko+xuxOKkfOQC4AR/UGEQ3SyyazC/g3ySl139Ffj8149hGtk5BNEX8aqYbbM/O0YYLx8u7DGNXav7hqtrj0PNYk2veFY8f31nj/6GbmrX6aC5ddDeBh8MtuHtS+p87Fz6CKtbL6SghQjxq/YScpi8u2/0Nv8gwRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773418612; c=relaxed/simple;
	bh=zC1hUbgORzY9EBQ0XAO9FXmDvqDyrGDnaSLmWsjbRmc=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=dgdXiKm73GgXCQpBOQrqCrltMke5FNLJ2U5Xc3w8U1cpOKk4/BrtTKrtUarKOHWexpNdZPpoz4O7dSokZc08VyL/+q0MXyBaX/sPpcqQgxIS/ALXWIgZbk5HI11a8V2W97EoUn2aGnhSmbwJRKJl62pKA0hwZNtJsOAF6UXIR5w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MjpKlEnc; arc=fail smtp.client-ip=40.107.200.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MjpKlEnc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YJUbqsBksiGCFH0XfzMQcxmgMFkzJ57zE0+cNtT65yQqvrY4P+4tXWV5o0NVkCevGdoyf6nglyNtGtpulx1fCa6wPztT5I8UueWYQ29n6YwHJ2m0v0pqfZUO6/pr+3R1pE91dm/kZOzzk0Iutw3waQR6dIW567eobi4Os7LQVsbPWTP6NaVGJVj1vbEPSRw4C3I0535QJ2xJN6ePiaryGEJZeZO2WvYeoNcHtFLCXJXkDs8Lu7MA/2cSQCs0t4qRkhH38tbprTaDX8jN7nOdfiOizWixr+apNYLOKsjyeJ/rFeeqI9WXWlBGoNtHbY3I+0yALyftl1SKKre/nXGhsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9n8vLlJh6UUeFxtG+T23cNVCcHLdVs575+5UmDNhIhg=;
 b=xSHaULXjKZfSAWsM/0gDsfI24Mamjy/AkzFacVOVgEMl/kaldmoWWwMtj/MDSfbvwVsW3wnjauuEY8JhpA0CWUqW/FuU8p8DH+NkkXrHtKKPNVyZwsB7fZqPZlQdZxPDoUZmopWXkXSY0YV7N1LhbJXhMyi9zlV1M6aVQ2+XKziuapUQ3dJqc8AlwT5qNE4kVDpXOvgr6jxnR+C0mXGAHjMUl87id0EEcY195pH2x3uTjhoXYEbmzHeAKd63/GMXYlXULaKlnDy+KEvYzIV5lgUZD5gLMvRn7GDoJilAqMREuPlKn/AHIHhAXFxLoNdH36asSa9Qy9ufQ4OwO3MliA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9n8vLlJh6UUeFxtG+T23cNVCcHLdVs575+5UmDNhIhg=;
 b=MjpKlEncSSwtbUrtvHaoZbYQ8yx6oe8hB43RrGTTHJOsXb7oV5YGOWNiojrrdaxO7Wxi1m4evxoThI+kJbtrCPquePoX7WRgtf5V9mXA6DVA8bNUFtLytmnnDWwdBFP65uDMNfeP28pnSZyMBGBzoaCijhhoMLwMbdiV3VDYybUbRqEpHSIQzS48K/B7peh5xt8M+e5SJV2P30DGXqH3k/eT97KRBc5kwF+c99FAPv1OLL/uJ3EWK690BDPb8l9ZWpDGDYluictllcT5QQXqNaCEbfV0GMlpGhyjKFbHa6h1Jb0Hx+tTXRR8K1q0Z5B7TlM6A7ggisB0+HVWMg4sXw==
Received: from CH2PR12CA0006.namprd12.prod.outlook.com (2603:10b6:610:57::16)
 by BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.8; Fri, 13 Mar
 2026 16:16:45 +0000
Received: from DM2PEPF00003FC8.namprd04.prod.outlook.com
 (2603:10b6:610:57:cafe::a7) by CH2PR12CA0006.outlook.office365.com
 (2603:10b6:610:57::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9678.30 via Frontend Transport; Fri,
 13 Mar 2026 16:16:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM2PEPF00003FC8.mail.protection.outlook.com (10.167.23.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.17 via Frontend Transport; Fri, 13 Mar 2026 16:16:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 13 Mar
 2026 09:16:25 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 13 Mar
 2026 09:16:24 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 13 Mar 2026 09:16:24 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@nabladev.com>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.18 00/13] 6.18.18-rc1 review
In-Reply-To: <20260312200326.246396673@linuxfoundation.org>
References: <20260312200326.246396673@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <82137939-1afd-4806-9b0f-0d620e5edd49@rnnvmail203.nvidia.com>
Date: Fri, 13 Mar 2026 09:16:24 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM2PEPF00003FC8:EE_|BY5PR12MB4209:EE_
X-MS-Office365-Filtering-Correlation-Id: b39bcc43-1114-4d0a-18e1-08de811bebb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	z0P4T/rVCgAcE5DvIUKoNoTcm2VT74OzpePP4aHehJz1psNC7S7F8Ii65L3S7frU4TYzJXLjLFjVFi2AiIZGAI+3KevEm+kL0eUrCtbj8MAvrw2+6u4JSaVFpE+mcLs8lgYVx6W/iXUJol/ONcuQp7uTYEACC51SnkPQRZgZD0LiTBB34oQFRlx4JhNqmcyeEbN00ittzFKrYQvj57S6qG+7PWIt4io5y+cDxsOEh1gN80xWRE7peqTm6P58RnvWdAtQxh2H3PtarCnDPCkCdbq4mK6juS+sIRq9CDjrujPc7vZm+nwc0vCYPtuL2oTqXE+rgMxZKTnHPYSueniWA3SROHys2sbSJeTyILfx7YfHks5SYPe9cusGMjxUH7g1R6A0GnwlbhQQ/4YUngFs+jVdK0lgy6At+W2u0x0sFtncRyF6/jODZYqoihqS5usYeDEIuz22GxJ5DA/Sjpyoi7in0BloEfhH2kLyo0YGRnVAM8vQvsv+BXiCcnzoKERmAltOteMRsAfNa1GTv0t/Zvvj7auQzVaOefTjh4xqrt+ufNm0RML6HP4XKYg5PcobEmZCrZWI4CmmWTphgBawDg8v1TRQzZ8BKo+udw/YDVRF9BTLbjx6m/SVdonB3aZ1KXNjTvHZIIrGsZOBbSByXD4tcLppvW6MkGC45KbR4ufvTT/p4x85WN3ZvP66NDOazGhKDCO0FZQKM7Tl+zJla397WunmcA4b7Dd0znE+usVlY4J7ENXrWsujWDJhLegjDTq2X5xrPoqtBlE5afS1sQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SWclBnRhdD6VvaeloGM+zJ0oM1a6f5gGckJUlVXfjPljhymE3juUjdo/Sn8UGQlcjw8kF6QWEWG05TOgW19wSC1ezKT1mc9IJanTmPOF0BeP8ZvmOD3H0rg9jsPAr0kaHQjxG4uW3yoxV4TF2ztuEPNpx07MdgZ5y65wxZCjgH5h1Hhdvx8qHxYNC15WE4ii17Ivlh0mim4241aNmBVSDTiJlO7dc5XMsm9YJS8ZbZ0JfIYvksSsBMFLyg8IkW6heTCM2apyGGzTkFE5W2PXo4ypLlVkAu/a5lB+RsVujdKg36t3R1vt616jTOmrYr2L8fUmw3y6dZt9U8UVqSqffhNIBDFwnAJW6x6YE0muYBCu3Lr0oBBUJ9xIePhvGp52H4bD8D5cZWd/N/xkqomg6F4D6oELLFMiNOMGtzs0pXj8i2h3g5Wo2B4DrwUv7xC3
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 16:16:45.0192
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b39bcc43-1114-4d0a-18e1-08de811bebb3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM2PEPF00003FC8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4209

On Thu, 12 Mar 2026 21:03:41 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.18 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Mar 2026 20:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.18:
    11 builds:	11 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.18.18-rc1-g9885ba4f6a88
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra234-p3737-0000+p3701-0000,
                tegra234-p3768-0000+p3767-0005, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED609DDA9
	for <patches@lists.linux.dev>; Wed, 21 May 2025 08:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747816296; cv=fail; b=hyrzusTSkDo8YAFB5GjjAAFQoO7ko76zLpETZLJyK+PwGYFWe+VOW5ejij7XJuDzWckyZXr/pkddxQGtWvoL4bqXH8U3XXVmGjis7UaSoiqbw7uwPhL7ujIwBxBzRB3bv6UdT9YxeTPqdGc6NCdAtaFcvTEx3FCaenm96C0JuqQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747816296; c=relaxed/simple;
	bh=N2YkooncNO24WeRGHw52bxJHtojcndmBEjZFY9OZ4/Q=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=o/+EVYwQGUKIkJeryRcb3OCzJx3p0Hq6q3DVyPzxvhe20TLrD2QbfgTJMhxCYaRBYgHzonKeKlhC0FyvMXcwIPReeHT9XzKUj+DpQVKyjICGFqOJ4ZFUlVYjqByUzkd5YbGrRIOsA93wR59vfBDYllTn50Bpv1JsByWBmyLjhyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FHDiP93E; arc=fail smtp.client-ip=40.107.220.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FHDiP93E"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SFmyg0POmhwfAN82eyK8ByFmWvTaIIEyKXu9I38WDjejflfN8T7ER6NCnDSdqI69PQBAzTlntHuuhyDLjptcBUn/wMEHkEu1WZcR0y0WUXtfU7oJlP6Eww6ZY552gJrbGSXLvO8eKfMIPKVNng0iEIddk88Oj4bkeDt1AzwwIlw/bdHJuqPopuZ7DN4ZnY8Bklh5izUoUbt/4AySWbJSFM25ovWIjcBAjR5bW8uTIt0qmx3XctDoHH5Z2x7Y+kz3Eso868q8iIqg6Qc3e8Z4AZfy6b8ksYhiYw1unaqDEq43QE5ekj5ysthOTqw1hP5Yce5RycK/jEGQsrYSIA2CUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dv3UgkWqwfw/yJJkDEpZaELTaQ6q8PdmgCBBfegO3CA=;
 b=vMB3dtiqWuhIkk14Ibu5O/8+L5zMr72I1I9M9r3Yqiyadnx8QH/MRnJArQBPIkTG6fsEomtO+tRzTWV5vSveAARo5uT8Gey4FScSX1fgPmoWZoP96d45UnV53X6j0bL8uw7KNV/IG7IdmaF+KDzlGwaO0t/HlMz6I2InaznndIgSkkIaNrCvxp27+epcSY6ZL2NdyIL1UrokK+G6zxEpOksoFtVz2t62xD46KhSfzFD72+w8ph3VmElvHhXVfV7T4i94QrOgv6YG99AAvya5RzGeuLwburax4Gfk+ygcK/aeUfbJ5Uhxkk9vUXsjAwm3fdf/a+j1xNUYOx1lBG7Cmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dv3UgkWqwfw/yJJkDEpZaELTaQ6q8PdmgCBBfegO3CA=;
 b=FHDiP93EVXhaNEef21AhP4SoPA+dZkYxPE0COrwlkj9jwVe2jjTyIIWxjnlOihx/V8XQP7RroS2wTdr+UuJatgKsn5rZD1cb7xqPZLwH2p9qlWO2dU/ejOXtcOyZlBLrOGlFh+ik/F9F8/HFEulx1qW9vXRG3fnHpD36SYtejJFxOxJXewfxZzIfk2UqzysOQsNV7/w0+DndjC3qGsMxz557cgjQmZ/2UQLW0grRWSl2Z88A8M2I9adBuYyw3PAmx1h9yaqqHx/pdNeh23JPc88L8H7G/XP1VkYJc9xObZjpgk8Ts/D1nqKdT29Gh5jPsztZQwWtVIWrv/+2hHzWTA==
Received: from SJ0PR13CA0066.namprd13.prod.outlook.com (2603:10b6:a03:2c4::11)
 by BL3PR12MB6426.namprd12.prod.outlook.com (2603:10b6:208:3b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Wed, 21 May
 2025 08:31:30 +0000
Received: from CO1PEPF000042AE.namprd03.prod.outlook.com
 (2603:10b6:a03:2c4:cafe::d) by SJ0PR13CA0066.outlook.office365.com
 (2603:10b6:a03:2c4::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8769.14 via Frontend Transport; Wed,
 21 May 2025 08:31:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000042AE.mail.protection.outlook.com (10.167.243.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.18 via Frontend Transport; Wed, 21 May 2025 08:31:29 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 May
 2025 01:31:12 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 21 May
 2025 01:31:11 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 21 May 2025 01:31:11 -0700
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
Subject: Re: [PATCH 6.1 00/97] 6.1.140-rc1 review
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <fbbe62ef-ac7f-4dab-852a-760d00bb2567@rnnvmail203.nvidia.com>
Date: Wed, 21 May 2025 01:31:11 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AE:EE_|BL3PR12MB6426:EE_
X-MS-Office365-Filtering-Correlation-Id: ac1a8bfe-86f1-4191-de9c-08dd9841e25c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?emJ0cjNpdnBDakNnSWVpZDlWZXQraHhiajdjQzVsWVBnT1FyK05OVWd4YkdB?=
 =?utf-8?B?RkRuc3VmMVFXL2JXUTZOSjZLd1hId3B0bDZQRWNkSCsrc0tTb3dpMkJqVDM4?=
 =?utf-8?B?TS85T2pvSWFDcXdwZDJBanA0SloyUEN4UXlOWDUzZ3M0R0NHMHE0TU5vZjlJ?=
 =?utf-8?B?TDdSRXhhOERPR2hSaEVMWVNqSEhPRVVvcDFPd0o5MG1NNUhOc1lrZElUME9Q?=
 =?utf-8?B?NkJPdjI5bmRpNHovdmVYMUV2WEwzK05WQjVqMUpTSHR4ZXpLZG11TllUemQx?=
 =?utf-8?B?Mm9MSDBiYTZqRi82SzM1YVVPOS94eFRJSUJEY21BcEoxU3lnVHA5bjZ4UFl4?=
 =?utf-8?B?NnJ3cG5xNDNIb09tUEFsdDVJUG9vOXpTQ0k5SGNDSkQxbExYNjkxRUZWbFEx?=
 =?utf-8?B?UGFHWTc1cSt5T0k1M0RhU1NucldLdzJoVVNSSFJyNmNVL3ZaT0gwOSszSHc3?=
 =?utf-8?B?RGdvZ0NLaTV3WWNRL3Z2QmFDNVBueGNuZXpKSkphL2FBKzJUc3hER3IvcHAx?=
 =?utf-8?B?ZjlIQWFESytiNU5WdmhmbHpwNk5MSmR5ZUFHZ2FmdHI1OUh1ZTA5aDlHbWlI?=
 =?utf-8?B?RXRVZCs5amw2T1NHWm1MUDlUeW5OZ0owSXg4VE5pY3RSdXBWK0QzOWM2c1JI?=
 =?utf-8?B?TWJ2ZVRyU0xNWklTdGpWaHZhWEkwcUQ5NTNDS1dza3dPa2k1a0RLQVFrbkJF?=
 =?utf-8?B?WHhVL3JTMHVrVzdjcHltNmZ0QTE5S0xNTUJtelpDbEpuOGR5ekdKRDNGR1hu?=
 =?utf-8?B?N1NjU1NWUjlkWStoVytiVkRwdUJwbGVsUTJZTGtUTklOdVNtUUtFMVNwbGxC?=
 =?utf-8?B?UnU5aThOaWZNK2I3aFZWVU93VFBlQVNTOWlTejdnRlR4S0FDN3ZyN3N1UUNK?=
 =?utf-8?B?L1dmeG1zSmF5NjJ5Q1VXNGp3S1NhUjBsLzJlZ1lhK3ltdjk5WHI4Nko5WXhw?=
 =?utf-8?B?ditiTjNnZXhxdHFHSEI1b0dHd3YvcTVLeEIreUltQ3hvM0tOa1ZsUDV3dVBS?=
 =?utf-8?B?MzJIV2FXdFljeEVhVktYLy91ekNVRFJyaVNmeFRPV3RlTmpPQm5rVUQ1YkNK?=
 =?utf-8?B?RHVCVE1hb0x1cFA2MVpyQkVRbFN4a25BSW1JQ0tPbE1ZRFFxNXRDM0ZWZVZO?=
 =?utf-8?B?dUZyZFVzS2R4VVlOZk9WM0Q3TEpUanpiWllDL2JIa2xoby9xU0JhbW9QOGFr?=
 =?utf-8?B?WmRPMDN4S256aDNTYkxvWitjMXNZYWZMUFV2R3YwUzF1bnZ0UHZ3WVpKeXZp?=
 =?utf-8?B?UHFvb25oaERUK3NidHQ2NkJtYVloQkdtbnZHdFVwTnRxRGZHOTFDMWJvMk9S?=
 =?utf-8?B?MlJnWk5ER2RPTDJob3k3azVqWHBva0plQTJkalR1UmlMemN1N3NSMnBaRlJn?=
 =?utf-8?B?c3VzSDBGdkd0OWNla25Xd0tYNkIvOWJ5allHTGlmbERGczBGSnJtRWsyUkVu?=
 =?utf-8?B?dE93a2g5cHdxVW04d1FHMGxsS05zajhPWkt1MFBGOVVvUkdZSE5MUEl3R24z?=
 =?utf-8?B?L0RoOW01N051d0poOWhPSEY5dWM3NDJkbFdyblE1T1gzRkRuak9YS0pUekll?=
 =?utf-8?B?STkvRkxLY0pyZjBrZGtZaHpVRWdCS0J3YmVnRGxBVnpkVVFJY1ZreVZwcTB0?=
 =?utf-8?B?SVZQeXlhQWxORVhVTDF1MUxZekNyRWNwMnNia1BvU3cwenQ1Z2pOR2pHeGJU?=
 =?utf-8?B?OGFmQkk4SzllTGQva0hqTTBYZDhHOUZ5bHRGUHYwNTVnMEczaTJ1UDZVNnla?=
 =?utf-8?B?MjlXMnBreUtSdlRQbjE2aDZ1TlVvdUxQOFFFa01xb1k3eXVLcjN2TTdzNUNJ?=
 =?utf-8?B?K3g2cUNEZFB1OGpDN2h3UU9YRFd2NWh6RXNVWXNLTjNWRlo2YkRuQy9Ob1dz?=
 =?utf-8?B?QW1YUzI1QWVFYVQwVGExbys4Nk1Sb1Ficm1WRzRrL3lIcWVScUlQNGJXeWZB?=
 =?utf-8?B?M1pwdFU1Mm5wN3Zabi9LK1d0OTMwaVlld0E3YXZZc3JFbDhlTkpyVDBEa3BH?=
 =?utf-8?B?NjF0bmZqM0l4bzdOMExqQnpOa3pTOC9kQUFWek5PUktTMEVyZmE3Ykd6Sk5J?=
 =?utf-8?B?Q0EveWdrWnR1TTNTUVhHMHBMV1JJdHhDOGNjdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 08:31:29.3091
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac1a8bfe-86f1-4191-de9c-08dd9841e25c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6426

On Tue, 20 May 2025 15:49:25 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.140 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.140-rc1.gz
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
    115 tests:	115 pass, 0 fail

Linux version:	6.1.140-rc1-g1fb2f21fca77
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

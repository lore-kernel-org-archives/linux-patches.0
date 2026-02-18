Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012019.outbound.protection.outlook.com [40.107.200.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED0B32571D
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 08:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771402988; cv=fail; b=dMmcOIII28TtCC6ptPCKYoGeFHGruHSqXddVjBxXMczvSntIjLF3dLLRbTUK8R0mzGfMRRF7SLVIw32N0xikD3/ODeBHJgfhoI3SktpF4EOomH0yaW38RzNZ/rwcDMWyqN07SrlZoy36vra47DkPbsy4uHT9XvMz+a7ku8e8Skg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771402988; c=relaxed/simple;
	bh=kFMjs8P9gVT4koNSNYDtrgfZad1Vj2gtirdxzYjPEmw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=TSr2Svuj1kk0UDyhGpVvyRgyQBP8Dweor7CBkFw1NSHo7y28btmA5s3ubCfO9ShXWnaNxbb1hhISy27PsoJR4Y6ersk+Pb9ukLwd2+Byd1XjgSGDxXDSXVgCPko39DRrefqrdRC7blVnObTrOZaMggoXm7bkkiuyKLWBqV1X8ao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=udxPP20f; arc=fail smtp.client-ip=40.107.200.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="udxPP20f"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ouse3uDQ60lfh6Jcw4DHMfBJLVTKOaaHbU7KfpD5XZSdS2HTtkmHR+Sw1Hjvcl4OHexmp24lQXWfWlxg5I88dRFgnD2tGEYagBzWPBX72/3P1tH7zDDipugpT8TgVrKaHwvYdXFkHVXNA7302qtJs2hjX5hASsrjWVioNklwXkjn+QEExg35pBNhrbL/1QvwQHj54ptWCRyF4j6O3ji6ogo9Jhy5qk7rh6nEwgtfRyPUWRWNTKzsF8h4yjzcnZzS27MUV/+HLJzGmYq8PrHjPHFKvM3sRUicUCgVj1FLhtU6+YuQm4/5h8r2QbuiBvuXf9yj1v5pKHYAxtkALLGZAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6jpiXMicc8ZefsHEu1uFIYuCwzBl31gvmMpWgKFxVjQ=;
 b=Pumqq30ketQbXDMTS7cHYfpzi6Af72RSEus3gqSp/ruJt9xgI484QHGhWWWyJk/1cR54tavFfik+heeaq8kRMoi3SGMgS3V5K9ytaFkT7EGHLwuwLLMlSHrEstpmWsl5BCCJDHiCVsfEGMaPVNT+lpeXCQwWd6wE640aOaiPiEznJ29sIVpSu5G/FvoaNQgllhQXLDH4crPsR+tT5wQHYXEwQ4hVAcY3RLr9c8qV9Ok4agtyfOLz28ZVH0RiAnenkJzmFR9dwDk52b1UdhzYm0IJYAGaHlilYBScn7L8ypZBCFt2KEHMnzEd3hx5HAL/quiyeJ/EmXPELpaKooy8eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6jpiXMicc8ZefsHEu1uFIYuCwzBl31gvmMpWgKFxVjQ=;
 b=udxPP20fxy0QS6hH+n3/nCn95w8HUPpkkg4sRkFdQTM62yZrVyHrd4+VW2M+Mr2pt+5o5QYYW0N9t9XVsP1BpLeeY1rbrSIIh27MPKH1jrAHRI3wULkIZWZV97vYFP6QO4hLLOtZeeztB0bfNTrNv+nsuCBhq2wc6TMV4w2GwG9KAe9P3KP0/x7LDVmCNw9MX51OxhwC/1flpMXvUt73W0+E4UjzBF+5FO57Nd77HHEMgXyt5+xB69ydzCXuJg/MlMDM/aH55S2wn7fnHNiHEp4iaE7dVfvE76FXAFh3ZIkalZfoD4danYsMFT1PPXb+kkvp0KnKIbVdf4Y7i1q2mA==
Received: from BN0PR04CA0146.namprd04.prod.outlook.com (2603:10b6:408:ed::31)
 by IA0PR12MB8716.namprd12.prod.outlook.com (2603:10b6:208:485::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Wed, 18 Feb
 2026 08:23:03 +0000
Received: from BN3PEPF0000B370.namprd21.prod.outlook.com
 (2603:10b6:408:ed:cafe::f5) by BN0PR04CA0146.outlook.office365.com
 (2603:10b6:408:ed::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.14 via Frontend Transport; Wed,
 18 Feb 2026 08:23:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN3PEPF0000B370.mail.protection.outlook.com (10.167.243.167) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.0 via Frontend Transport; Wed, 18 Feb 2026 08:23:03 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 18 Feb
 2026 00:22:57 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 18 Feb 2026 00:22:57 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 18 Feb 2026 00:22:57 -0800
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
Subject: Re: [PATCH 6.12 00/42] 6.12.74-rc1 review
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>
References: <20260217200005.998240758@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <bf580c9e-a3e9-44ba-ac62-35fe25b56480@drhqmail203.nvidia.com>
Date: Wed, 18 Feb 2026 00:22:57 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B370:EE_|IA0PR12MB8716:EE_
X-MS-Office365-Filtering-Correlation-Id: 60780184-aef4-411f-6203-08de6ec6ef97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MTJmQndIRlM5Q3RNbjc0eFNqN3lhSENiTTJudGZYcVFOaUVSaGd2RHJ4bStD?=
 =?utf-8?B?c0JsWkcxRU5NVTdvYUZibmVTVVRselJ4U0FtalhJQkRqczQvMEtnTG5tV1pv?=
 =?utf-8?B?MDE3cTUya0s2ZkcwZkJ1SURGNkVNNG0vdElucHU4YmlaVUF1UTN1K2tpU3dr?=
 =?utf-8?B?OHBTUnNlWHFYM25uWFhCUjQwY2N5RlpwZEhYdDRKWjBWbDNNTG82WXJVSDd1?=
 =?utf-8?B?ZDg4Z01WNkxRd3UxZ0tvek5lUDdKcFg5dVNDNGlZamRQOHBodVNwWHpyYkhG?=
 =?utf-8?B?L3pDMFhVWjhESUFGY3l5ajhCaDNMT2hqSWNWcy9Tdm81bllTTlk4SERkbFlv?=
 =?utf-8?B?cnY5TXR2dEdrM1k5Q3E4K3ExaGJxd3RjZk01YkcrNGVDbUFESWs5QTZjdERR?=
 =?utf-8?B?dk92Vit0bk9TcytIWnYzVWVGNTNwSUsxY3dBVnFPWTF4VnNqd1QxNVNxUUlx?=
 =?utf-8?B?QUJ6L2hHSjJqaG9NSXJuakQyOC8xaWZ3eWZWS2gwUzVDbndLcDZ3Wkk5Mk9W?=
 =?utf-8?B?cXphemlxR3pRc1ZQdzNsL05pSlorZm5Jb0pYbGNvRE5aenNkUytVbTgvNHlr?=
 =?utf-8?B?dllVMi9SN3NsM3dZMmhkbFFyVlRYRjM2WDZtcXV5MWN3QTdFbHpkdTNDdmpj?=
 =?utf-8?B?R1RyNEI5bHYvRTM3YWUrdEY2MldCMnhiTXRTY0E3QVk1czdmd0RReC9kVVRG?=
 =?utf-8?B?SDlEaGpEanE2V2ZxYXNCNVNFRVdhUjF2N3FxaHF1czk1MDJkMjFmRmdHc2ZN?=
 =?utf-8?B?M1phdzBTV1J2b1hWZ3NjeWFEQjQydEsrN3JpelZMQTZmUmNSSUNUZFhicy9M?=
 =?utf-8?B?S21oMmljblkzQllhcG9CcmdUUDdDdDYva0o3MVUrcGxLNGpQclEwTlFteTc3?=
 =?utf-8?B?THl0Y0JRa1I0enM5UktMUUdxNGEwQy9QWUQrd0pCL2VYaUU3bjREUkdQSHRy?=
 =?utf-8?B?SFVKeDFWVzd6YmY0aDFCMXhKTjh2UG1wQ2NINkFaeXJIV2o3TVBZM2JCV01N?=
 =?utf-8?B?M3ptYUZBWDBGL25SQVI2cDNmaThIUmxxMVJsRjZBTVNrazJ3eklkeUJwZG9Y?=
 =?utf-8?B?c0pZR0NKWkV1TjVCRmhPTUs5eTlMUVVheGJYYkxOdkRiRlVZcDlzMDIzb3hn?=
 =?utf-8?B?c2RpSUFpU01Kc0tQUXB0aHlaVWNJamJBTTd6Vy9CM3FBamNjQ0t4TUszUnFT?=
 =?utf-8?B?UXdSY2pSVVZjZmljS2hmMFZEU2VqR0xlMTdwNXI2MU5OOGJsbG9sVVNPaXVF?=
 =?utf-8?B?YlE2Zmt6K2FMS2MwMGZPK1A3K1FyVzhZRnNjbDMrY0tqcjdEeTNPSUlqYjcz?=
 =?utf-8?B?akhUMFFZbklmMWtmKzkra0ZqcS9hb2tVU2J1bUxQOFE2UDY2NFZwQS9YWnVu?=
 =?utf-8?B?V29XVzRDRms4SXVWVTNRRUg4Q0hkYlBQR1Y3dkVYNkMzM1dMMm5RM3J6a2Vz?=
 =?utf-8?B?V3FWNnJjZm0vNWFkMUl4dCtCUld3OTQ0NHhndVlTcnR5d1ZsN08wNXBGUk84?=
 =?utf-8?B?V0F1UUwwakxkYVhxWHJvVCtSUTlQSDJNd0s5YTNJVlBKdml1cStLRWozS2Yv?=
 =?utf-8?B?Vk0vOUhJaEY3ZHRnZDZxUnprT0JYUVFoR1dJTHFVbFRQRjVCVmZPRytIVEsz?=
 =?utf-8?B?UVNGSzFMNTFTR0N5dDdVa3BSdFFVU0hMSGpIMlJMWjJzOFd0M0JnZFQ2SUd6?=
 =?utf-8?B?OGRzM1U0NkQ4OG5iZld3WHdtUGtBTmtyR0lyMkZwWVplQXFVYk01SjUxaDN5?=
 =?utf-8?B?cE01Yzg5UHBYTlVjS2taa2ZzbmpabGFkY0dacm5xa2hvUTFJZFRZTEJHTFZx?=
 =?utf-8?B?MC9MVi9maEU4T1dPUDYwN1JrajdPb21JMkJySXhmWFpHUVpNb043MzRMQk9K?=
 =?utf-8?B?b0xzeW1BWFNHOTAyN0w2dlpjNkprVFJWZ0J6UG9ka09HbnQ0bU9pajFKT1ha?=
 =?utf-8?B?bXFGMkhGTUg3SWxCVjN5Yk1wenQyRm5YV2JmK3I1UjlSQlVxMitRVHBtdUE2?=
 =?utf-8?B?ZHhVWlZid2xWNGJFa21aL3JPUVVlUWNaSFJDUGljeFF1WlhJbVNDS2dBTC90?=
 =?utf-8?B?Q3lRb2h3QmVjWnRwRlgwZkxlMzVhTU9yd0Q5ZEk5VytWTHZJcC85bUpVTnhR?=
 =?utf-8?B?cnJDcFU4cDZBaWQ5ZG5hSnJ3Q0o0Q1F1WWh0SDVCRVMrejVIbDhneFBidExj?=
 =?utf-8?B?OEI3TVh3cU5Mb2JkWjlGSWtQSy9ZMVFXQi9vcUlETk1qM0pZeWFYemlYeE1o?=
 =?utf-8?B?N2VXcXpkZkV4bEpPWGdyZWdZQ3ZBPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	foP0tszd/fu8vXfqVl6x5HM7FhsVXrhahIa6H8QelFXKSjIVd76iDuyrClbp6b/65j2Eh237/gBG+DpBEu8cP1vt0lg/8xaDCuGEq0j+Y7d4+9jxWq7Z4sDi1Vej88+MyA7WiT5Ubqm3VdTXEnf6zhnIM1d4WFS5TW6FidrjJs5DORluuLTFVAPZ6JUrDl5KC41XsYG+ZD0r2Zt4XhHHz0bNg3xh/bcV8yJ0T2bg1ecq7EPWYjvl0/Z7qIdBWyEqXlF88TgzFMbslsPPFJOIKsgBoR6+OXtGtcpJ8Qhjxxz6R7/v48vQF6PwdIIdeuhXDBEbCv8B0Dt4r7/rrJWr5juqdf8A3F+GYYofS7+peUTzSlzBVAAFVwJzA2ETOuUFpFVw0ID4PmFl7kOLBc6ftqz4ueB51CHz7K3OHxNln7svbEQ+73FYutnRs1836dTr
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 08:23:03.3609
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60780184-aef4-411f-6203-08de6ec6ef97
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8716

On Tue, 17 Feb 2026 21:31:51 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.74 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.74-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.12.74-rc1-g5d01fe87b74b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

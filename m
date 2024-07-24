Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2049.outbound.protection.outlook.com [40.107.236.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3772B61FDA
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 07:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721806551; cv=fail; b=GC08rE9UVqUd4OUsVekdDjuqXa/8GpNdjwemUW+kx9H0Grh5QssQUfquzSlh4BKdJkz9KC0SRaXudqVQQKT829WGozeQe2lKwONb4zOQkuziPbiwbOzFMfnX8kOxb2O+5+i34c2X3y3YH7aXiYZ4PJh794dG3/gdCZbQquPkvHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721806551; c=relaxed/simple;
	bh=O92d11WLpQTUBrQwuagMmgsFdrbmCzaT96R6rRqQndo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=sr07vxxgocqFQLNU503Ssn4BOxNtIE94GHmNm9T7LkHabCgjq+kegMDOnQh9Q9fhDjPuks/Nn7Y7Vq95m+5pDgq4o8OlFSKDdTIG6WUR3m9VgWSgHSdtQnZuCN42Db2iDiHgCoRlTEMM5Im41c5oPrkIlHIO6zP5hrvHCyAmw3M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=edhSOcj6; arc=fail smtp.client-ip=40.107.236.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="edhSOcj6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ahaBx9Xk81gxHtg1ZzFqGl7iQt+gSaq+kdRCICT3tTKN96brA5bNoNBf7pzQNaLcU8F5E5Zmf7HnnLbNxFNbnCDEKguo/mJancvLPlUHA/MkiZdDOMcSA5EOa95RW7abF5SD9uin9hAZ+XKjiv9Fj/mELWIqek8FqmfHmO4UINoxDygP75h2Z1W9AyivrzdpHaqjcBUSqFHg7wvuYtbQ+mDMPP67LC3/q0E8pWyoylu87UM78COLg3J+lbzEovtgCyFqq4prdNNAlESDH6qYoQRyU6amMDIn3pboMPfSK/emiZlFoNl9hIb0sOZWoh4VbZkf5VWJEePTHKyqzvoAQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K4nvJ8D8I2Zxl0Wz/E9Tt10gr4ushfdjb0CfC5ECZjU=;
 b=F/ToXjDms4Fm6nxHXut0YEQtaTUPaVOs0954v7I2/lxPJF5EnsAycUwIETvuNHpYHNQ1sdBQ75bXiujHw0M71cJ4IOdEHTtLtmuAMQQXBKS74XOllUXC8iYDOlHkM97jVjLlvK6P6PIyF02mcL0hLiYZyPE5Ac51bgLkn+Gm5ZSAr5FfsYUbPebkX9GWcGmt10T7dZPDTzTNVskwXqqKGs3qNc2HvP5mpHl2KPRhwLVmBwKPw4wHTWne+O5KsnAtFjS2faDgyPUvqQkxTdelMoQ0Ln8RMrsEElKcwJqH88a3itZWqpWXIUJgn/bVrD5ALlsxfrcxz3ko0kuvQQe8sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K4nvJ8D8I2Zxl0Wz/E9Tt10gr4ushfdjb0CfC5ECZjU=;
 b=edhSOcj6835uWKlXXAUGnSBB6v3hSqkTbIVTsr4doZLIQx/yCdQ6LsTHqKXMOTJekN6VRoIhY1Ge3X84HfVVmMf1gsvA0dDZrkPn4vfhrARfrgVDdglcWZ0P29CTA17KoAIhS4gOYMBUQP7jp+lbj2F0tWM43no2lsqO4+fEk/tbmM7neHkFZZnEWGNlTIrgPlbkTwnsAsPQ/qd32MUOKjrjsP6UWqE3DFrAwExvWPXI6dcyJMQEJ5Be59HwYX+A7hUB0YHEgvJB/TQcQc8MENfS+xnZcchs+tlefR/gFWwvN+yP+LfNxATfphTf/bi4KlUZ0Xbl/MPdU3cWm6aO+Q==
Received: from DS7P222CA0005.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::17) by
 PH7PR12MB5805.namprd12.prod.outlook.com (2603:10b6:510:1d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Wed, 24 Jul
 2024 07:35:45 +0000
Received: from DS2PEPF00003439.namprd02.prod.outlook.com
 (2603:10b6:8:2e:cafe::f3) by DS7P222CA0005.outlook.office365.com
 (2603:10b6:8:2e::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17 via Frontend
 Transport; Wed, 24 Jul 2024 07:35:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS2PEPF00003439.mail.protection.outlook.com (10.167.18.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.11 via Frontend Transport; Wed, 24 Jul 2024 07:35:45 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 24 Jul
 2024 00:35:31 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 24 Jul
 2024 00:35:31 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 24 Jul 2024 00:35:30 -0700
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
Subject: Re: [PATCH 6.1 000/105] 6.1.101-rc1 review
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <2f4fbd6b-f495-4a8e-8ad2-0c90b70618cd@rnnvmail205.nvidia.com>
Date: Wed, 24 Jul 2024 00:35:30 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003439:EE_|PH7PR12MB5805:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f1f2817-ddd9-455c-8f70-08dcabb33ad5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VkRPRjQ3UTBjZEFmNU9nbVM4MkNhSFNZSStsQTk1TkZ6bDZLc2FDQkN6WUtB?=
 =?utf-8?B?b0NrcGk3T2JsNWFBTkw3ek04Nmg2Rkt2dHk5VjNPQ2Q4dXhmSnJURUhYck1X?=
 =?utf-8?B?TXVHK2haOS9LQUJyNzkvM3dKQ01YRFRMbWxiNGFlRDcrVy9VeTVoNzliZ2FX?=
 =?utf-8?B?NEU0SXFwVG9wcVpYV3Z1YWlLZkFKenhzVTBWT3NuRE5mU2xNTC8xdEsxWXYz?=
 =?utf-8?B?OVdiK3NCL0dPQUovdkdaSERSV0YrVHA0d252NVBja3ZzN0xBNktGWXg3UUhZ?=
 =?utf-8?B?VHBCVVdlWk8vTkQ0cTVsbUU0d2U0TERhN1I4U3RPb1RyTDZpOXc3UEQ0bzU0?=
 =?utf-8?B?d3UzWHU4TkZNMURrVjd6ekxGVTVzR0MwMmFOUVNTaFZvc1k4aHZuZVMvcnJO?=
 =?utf-8?B?UGw3OExxUnZKczd5b25DZ2pyVThnaUREVnB3eFZ0aFd3YmFMZGFrUjg4YTJp?=
 =?utf-8?B?RDRNRTdkS1k1N3BrckU0L0Z2UHdNSnVGNUl0QzV0QkdxK29JZlV2ME54U3or?=
 =?utf-8?B?MFNtdldLMGlFL2p6Mll4cXlKL0Z1THNsL3loa1Bqam1QMGVvWGQ4R1d2L0xi?=
 =?utf-8?B?RTQ1WlNIY00wMVoyemc2NkhPaDlYVjFBK3NrWXpleHdKUzZGWUhOYTVsNjlp?=
 =?utf-8?B?T3BCcDVWbTUrZXBYWmQyNHlKVE5oKzg1Uy9JdXljZnBxTHlnejBIRmNKTjI3?=
 =?utf-8?B?R3dpK3F5ZHM2YkhYZVFNbTZGMWVRZmlzZlVOemUrUFRMNnRZSFFkTnJJMzVr?=
 =?utf-8?B?VWxoY3J6eUhkQ3hoZUgzZ3dCZFhXak5za1N3VW9xUk5pY0xZNjhmMWdEeS92?=
 =?utf-8?B?c2g5SE1UT1FOOEpZN3dORXoyTWpIUjhYUXNETFVLM1BmVGxpMW81UklDUWlL?=
 =?utf-8?B?UnVSZTVKN3IxVU5lNjIyckovRzU5TXpncU90UzZDa0JuOGJqY3V3ZU55RkRW?=
 =?utf-8?B?aXFkTEk1Wko1MGFpYkIxRlBmTW1jRlByTFdnTkxrRUowaitOWFJHamVuSG9U?=
 =?utf-8?B?Q2Fjemc2WGtuSlYwVmVJV3dJVGlPWXFUNnVKZnN1TENyWGxOU3dIemxhT0FJ?=
 =?utf-8?B?ZkdMWjJiT1lrTlZSN3NzY05jOWxKUk51NkYyeSsvdDVEeFF5UlphTjQ4c1lJ?=
 =?utf-8?B?cVN3a2dSZWtVcmErK0gvemYrdDlPWU9pTWFvYU4ra3ltNjlVQzdqZ2tWOWVi?=
 =?utf-8?B?NUNNSFpTSllOWUs2NWNEb0hrNnFLanFLM2FKYS9wRXBnUEwrYWc2ODlwUTdZ?=
 =?utf-8?B?MjRza2pKNXd0aitpRnUrUXMrdkI4ZUhWS1BzRDhtWE1jTUp5bzV0S05oZ2VL?=
 =?utf-8?B?ckR3b3ZYbG1NSkhnMXdvdXd1RllyYUdxRXMrWWhrTzBHNUVMb3dnbDBmSlV5?=
 =?utf-8?B?TVF3YjRiNExmTm5UaVlLNm1LR2NyS2lGbGdYYm96V0ttUU8yRjA4YWxLTDNV?=
 =?utf-8?B?TVJ1ZWY4Zlg2aHRNVnFIYm5XUUM1UUdmbllFUGduTmVueG9MckJETURjMThW?=
 =?utf-8?B?OStScURXZXpML2sweml3V1NTSEluem93M25LWHJST2VKRS9DMGp0YnlLMCtX?=
 =?utf-8?B?RUVBQjQ3d1VkV3NDdGRDUE1MSmdkVXRlcnBRaWd4eUU0RTVtaUxPNi9pUWNz?=
 =?utf-8?B?enltRm0ybmc2bkkwdjQ1SzBoY3NVUlR6N2FpMHlFTWxkNk9BTHJpOWZEdnZ2?=
 =?utf-8?B?bWJEMFFaOTFTM1ludzNZQS9KelZFZ2VoOW5JcXZMcFVnckNvSW9uU0FHRnBx?=
 =?utf-8?B?Y0hhYnUyL3BTUXYza3hXd3lBenRzYVpza1UwR09QOGt6R05kTyt0ZGpMci9T?=
 =?utf-8?B?cmVpT1FBTis0b091NiswZTBPRkFJQ2F1U2hVWlRTakIzNW1DM1Q2Wm5XUEhK?=
 =?utf-8?B?UkxGRTg4cUNQY2lEVGZOVHRkT01rVXZSSzhGbm9NR3hvdDNpZGlGdmMxd09N?=
 =?utf-8?Q?5ay644b6UkbTPyV1NqgpvlHDPkoCzYfo?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2024 07:35:45.2775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1f2817-ddd9-455c-8f70-08dcabb33ad5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003439.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5805

On Tue, 23 Jul 2024 20:22:37 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.101 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jul 2024 18:03:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.101-rc1.gz
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
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.1.101-rc1-gef20ea3e5a9f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

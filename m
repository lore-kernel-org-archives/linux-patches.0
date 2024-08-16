Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE7F8063C
	for <patches@lists.linux.dev>; Fri, 16 Aug 2024 19:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723837494; cv=fail; b=gbDPFTQrWQiCg5rn1Hk9PL5UF9XCC2rfzNTtqJIj/je4PZvbLT7gbgakkuxLzEfsI9sH9NrDu0FZ6+O6Pc4FAIamG6uCswrIMN2oYKXzBYmJ89kxhFPjFigpu6M+3WUDG7KgYFy/HHLX0cJq2zm4YX6AmW2442gc14epAOPYGiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723837494; c=relaxed/simple;
	bh=FwrHfTU03IV5txDh/jNuYAR55M2JiDvfvOCC1s1SrUk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=If2gsvNetqpzHjvBpcDiNux5jXz+sihgaWlYpCByFE0Ujeq258hVC6CfPiMwkw5MGl36qKYFhC6O4OdLUNaHGhecKPW9FSSZe75LRaFOyAiZxJ6yl8J3zwfEt1sHZHy/2q9F9lY1shg69NbVhV4I4w2gmjyIe3xkqLTbkpEaq9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nigwnPsl; arc=fail smtp.client-ip=40.107.243.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nigwnPsl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J6pl9SK/dwBJbd8ejPv2zrROFUfgPtyIfDdQHtIIW8VAG5vltQMCStXsnAXKGtADD8rAEavb0tLFdM4f+NWgnY34WXkwaCewjbzwBy+EYwhCvMoPUeGBSZZZ5SYv9fZHdsfHzjYcxi7t8j8pe6xErS2H/mp4OeUPjAMbXzUCB1hJzpZlBfbk8bI+RqUIb8qjk66V1WRgjkeaKFKumedbdOxKO+U94raZZhs+rfYC7oSLEE+n6ybrWMXMWSkGXaHhic8y9/X54LS1tyd0F3Un8si2df4BjETgr3IJqsaECeP37ZWdPtmvEnPCYjAonbs1ghK/CSqED92n7u4ZvTLqXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4hyqdyRbisPGZC3pszU+rUT12odxmzNDQInPnxmwkpA=;
 b=mJt+gfGv3HITTUEZUXKfLmAEqSI7lb4R7x/3NXKGchMP/TdTukeCR4xoj3fL/x2gxyN7z6oi1YCuBcDXFFX1n0ybQ9Oy/cnR+a5nNSx/Ohhr/kWAsrZlFhLH1Q5nsWWjM1H6nRirKmUvSLtv/tZFQ3pO9QluOha5qTXC903yqlP5tUI4tidlx+LSIqZLWLrx0ntCGEZda3SEp/0gOn7AfQABBLmtBKVmTvHHh1cBymAgzbXLQxcVwyJX9giv9AITBZNx472QjYudgoV+O1eX/rItmaMtnjGWFrL7ssQAkQ8Xn3enLxG5NvluNBGLi9SFXbXf5XChJoqbz1sbSIFO8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4hyqdyRbisPGZC3pszU+rUT12odxmzNDQInPnxmwkpA=;
 b=nigwnPslXmdGYDAeUrnVSlSU5zqjTsc7CriC0bsZIL3JvfWmVuDhCB1wdxzUsg+LgmHb3wIKupxrSKqW8N9Ukew3dGV7YlZghBGb+ViluW3MScABkOldEqVFOJLTxXcMkGbnDXJFYTb6oNUVCpM/ML+rCw33VpQDHph0LsmX5izKYO4hw3Lv1OpBddyW13uJvgQXBMFTzaQHLag9salS/qs0OHtZxOdqpuT2OlYq3qhW8Pm0OkksgrSB6TehFOZ6ExvKBFGUHIqJotLGvow7DIONZyo8ZfcEiS4QkGZ5gi4JY2kkm5iz+qiJ010eWXL+P8r6/WWSdxRJ95xv3X+p6w==
Received: from SJ2PR07CA0022.namprd07.prod.outlook.com (2603:10b6:a03:505::24)
 by SJ1PR12MB6099.namprd12.prod.outlook.com (2603:10b6:a03:45e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Fri, 16 Aug
 2024 19:44:47 +0000
Received: from CO1PEPF000075F0.namprd03.prod.outlook.com
 (2603:10b6:a03:505:cafe::3d) by SJ2PR07CA0022.outlook.office365.com
 (2603:10b6:a03:505::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.20 via Frontend
 Transport; Fri, 16 Aug 2024 19:44:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000075F0.mail.protection.outlook.com (10.167.249.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.19 via Frontend Transport; Fri, 16 Aug 2024 19:44:47 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 12:44:46 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 16 Aug 2024 12:44:46 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 16 Aug 2024 12:44:46 -0700
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
Subject: Re: [PATCH 6.1 00/38] 6.1.106-rc1 review
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
References: <20240815131832.944273699@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b4ef7712-0689-4736-a5ad-763efe3051ee@drhqmail201.nvidia.com>
Date: Fri, 16 Aug 2024 12:44:46 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F0:EE_|SJ1PR12MB6099:EE_
X-MS-Office365-Filtering-Correlation-Id: eab63e6d-0066-4de1-519b-08dcbe2be277
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M0hPQkk0ZzA5dFpjSGpyVVFualBoMU1NaUY5d2xhWVl0bERKZklDNTBxdzNS?=
 =?utf-8?B?cE44c3psTFBVZGhaZGkwSGE2VWFxa3VZNHNpeDI4ZTU2SklUUVJjMHlpRzA3?=
 =?utf-8?B?VlM3bVZyVkRxSjhCbEozengyS3J5emk3MzRHQ2VDaDZoajY4VFNQUGQwS2hU?=
 =?utf-8?B?NHVZYW0wb0dLbmVzN3lCenpnSjJjenNBVndHTWpaQUdFWlBNd1lvbHQ2ZlY0?=
 =?utf-8?B?Zlh1bWFJVDljOHN2RnZyVjdsbGlCTkt5MjJqVHQvL3VUWjVIM0ZZMHAxWlNz?=
 =?utf-8?B?VGU2QlljSG5hQUZCNFRqa2ZrSStIR2tHa2ZGVXc3V3FjSDFDWmhpWXFsMXVO?=
 =?utf-8?B?NWJ4cHF5WmMwUFRaVVFMT1MvYnhwRk1ZSjd6QjBybkt3QjNuLy9sQlVtRjE3?=
 =?utf-8?B?T0xtM2JxL3l0emlvd0xteUlyaGhLaTc2cVJWczk4M2FVSm16VTEwekVHYkVZ?=
 =?utf-8?B?dzM1SHVxM0hkZVJGMmVYRkRjNWFzMXFVNUxrdVc2ZDEvL1pNeW1WVmk4YVBR?=
 =?utf-8?B?bkV5eVVqNHFyWmtVcDh3elVmbmNWL3JONzRqS2hYRGlQelRZeHhhSi9QcEh3?=
 =?utf-8?B?aTRhb2xQTFUzbVdOcmQ0Y3VTTnVyUWorZFNXNWM1blFJVzhPTWVEMk1UZUtT?=
 =?utf-8?B?a2NBSU0vZnpSWUJTKzhHNmd4Rk5OalVCUTlNa3ZiTXQvUUhNNlM2cGVtMVhp?=
 =?utf-8?B?NEIwaG50WnpDTFpYckxkMk1xNklnLzdscTNsQ0xSM0cvSzA4VUtpUHVhbGw5?=
 =?utf-8?B?VGJWbnliakhQbzVVNjJGTndiNGpSYWlucE5EZEpGSXhoWnJaT1ZZbysvTTZC?=
 =?utf-8?B?K2VxNmloYW9wNnNCV01oTTY3RUZVdDh4VDBFUk96eGxxb04reTNPSnd4QWVJ?=
 =?utf-8?B?ZDZnVTZjS0RaU2cwaHlYWjFZZWJMODB4aWdwcTA4Wkc3NXZsMGg2SVJlWUxv?=
 =?utf-8?B?OXEvdGczUXNIM1hqTGdKVzNIektKTm1RRmdhUWNNSXI4OEdMWk5RQkc0TVRD?=
 =?utf-8?B?TTA4eHpwY2hjeDc2dkt0TXc0OHdIeHlPNTIybjlPTmV0NmkzSUd3K3A1c1VE?=
 =?utf-8?B?ak9BWGY2ZHFzV3hpbnJaKy9XblZrK0ZSNkNjSHVUcm1mNVNOcEJaREdrM1J5?=
 =?utf-8?B?RFFiS3lQQ1l0VU1mSHFsRzFjZU5md0VOaFJGQmxwUWhzRVlCaEhOTyt4L1dS?=
 =?utf-8?B?MUZwMUg4TXVEMVdEbTUwZEVEK09TYkVRMHg1bnlhZ1VFKzBKU05TMTVqcHo5?=
 =?utf-8?B?NnY5NlQ1ZHRiUG1lakxFdC82bDFYNGtyQ2ZGcFhpVXg2Y1l6eml0TFhpd1p4?=
 =?utf-8?B?a3hBZUM2SVZkRjBTYzBUT0JrRHNkN1VXK3lBYVNEVnNVSmU2dXZjL3hDZXNU?=
 =?utf-8?B?NkJmZHNQTjlGWUdPN3JYQS9WS3ErY28zWDYyeGZNTEJkcU14a2pTS0orWEFj?=
 =?utf-8?B?UnhhaHZ2T2E0Q0VyY1pPTTk1VFM4UzZHQ1NTUHlJSmZRV0NMNmxxQVF0dTdw?=
 =?utf-8?B?VU9lcXgvRXoyTWFFMUZ1L1gzZFdEOGFpWFdtUjZsYTFIWFdwY0Q2elB5akNa?=
 =?utf-8?B?cEljU3ZoYi9tTlBoVzUwRXRwajBwWkZBdld0a203SXYxcGw0eTJZVmxxVC9Q?=
 =?utf-8?B?TFhWV0M0M2tYQkxNV3hUai9BNGhpVGNoeUhKTkt2VmYxYWppVVJac0dmWXUx?=
 =?utf-8?B?N2RwMndqL0s4dWZrQWdBM0hJZWsrZ08vUTFpbENFUHdhc2hLUDcySDRPUFpV?=
 =?utf-8?B?THpTQzY4Zlhqc3k3d29ndHorRjArcDk0TFIrZ0Z6eEFQME1odEttNk43Y08v?=
 =?utf-8?B?VFZkc2RTdEUybEpJY1U3UUZtVkZON1REUnVoWGs5bzN3MzZ2Mllid0xEczJE?=
 =?utf-8?B?RTY0eVBZNXBjZHBheklBY2RoT1N1aEVXTDJkd09IZWkveVZmMVdpSUFOMmRG?=
 =?utf-8?Q?UZ5lyewqkjAzLosEYJxlZVsP87Mat0xG?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 19:44:47.1171
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eab63e6d-0066-4de1-519b-08dcbe2be277
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6099

On Thu, 15 Aug 2024 15:25:34 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.106 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.106-rc1.gz
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

Linux version:	6.1.106-rc1-g09ce23af4dbb
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2061.outbound.protection.outlook.com [40.107.244.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA7E1BE861
	for <patches@lists.linux.dev>; Fri, 16 Aug 2024 19:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723837264; cv=fail; b=cEodwCDgKemDDGPfbHXgHvpr+bXYz898uPoatawI6W6K5ssjp20uHJlp1yrT0uqbd//tIXd94IY48qJNXi//TkPkUKrvphpplEl+XPuyD7qXTD6/A7Pm6Ay4zmoeg3X8aqKymoRLGfsupXGo29sWYllbg1riYlbgp4hgoo0IVS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723837264; c=relaxed/simple;
	bh=yas+TU04J0y+4+UJyNjIdR7im+YxP5b0VHrJlqib9Io=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=cVaWritcTntNaeu6XpKhJ6+CPeqREPZJV4PQR5an7H5NRPvMgEK0LauyMbgZHhQ4KSANmfgVQXa0H75opcy9riK4PPfsNsxUgLy9A7e5kh3gSJpIFqErbFQgWwVPxgNhgocKkXgOgf/fqW45q77Qb4O4iBLgolTXVCykXd6uPec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Pkzli0Ae; arc=fail smtp.client-ip=40.107.244.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Pkzli0Ae"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AUpcUtiCEsxJm8wmCM9NiRYOmJFlT8PmZLIh4P9Hpmwsu8VPYxP1G6jAkBBaloDhY2G37m4toMdjlxxhHtCaRHkzQAXbDhW50tSr01FE97RGzK6mKOm0+U7r/sDfEPJ7TfFB+kjI+wTo/WA6K567JvheHgXLtYGVw6Ouueo1pEN5TSG6LmyYxAIEVtgqmkn4/FUrEmaQGyS+15WxajyYy3+PK8y09uChRyF/rbwmtuKrPL/pilMROK4FhIlRAMzpGSl4TCHstDEypY5Q0FHDz86KIta6tbQVsD8Q2ZGQAay/QpKB+Py/yRWvhyB2WqtKEOASqDJGikCma3HL68hLJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJs+wcAAh3+FHPxjTTJBOtMBgUD/v68T49K9aAFThFg=;
 b=ZdzU8ItMNXjpyruOpTebDGUDu4smbpVM4vOhXiO+FDVyvyoDogHCONvLSZE/iREA+DmGqtMJqbSo+pefijAf5eb+r3B2idHTqS+SYTXHAzMLOCKDeUHHGqH7pN0eknbJEb6aiGBobTQzCUa+Jr23+l9NeV7GHdPPVUK1AxPSvGi5F0m8QtWvmRZPJvk3VfNtW4fSz/885+B+o3ikeNsAewvr1ZfFRV9oRS71hQeofxjct1Zsu+OqqHTtXeDV3uvRr45yOPrThCTBfc1tSa0rBiArH6if6jrjCbtV853GSaWs2phwzA5LK9PepuDUFz1lp6fx/heAxJ2lC0NRNZ8efA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJs+wcAAh3+FHPxjTTJBOtMBgUD/v68T49K9aAFThFg=;
 b=Pkzli0AerP0hVSf05i9DkIEDdPxrj+jNFrvXSVHAIzdgsXQOq9hhNbLWBmInwM2nln75nZaF9SeOpJa/H+OyV1+YXQAMyy0OryxHM9/kpIbe+Py8k4prKwtt4a1gJNT4/ws5edPm155qCsT+iJNkwXTWuejPg8sZhw+0fckqiXvWNRtdh+MKa+0xL2BzcqDWRy8WhxmuAWfU0MQwjYY5Y7pbSSMYOlxcsOv/GGAiXAB4jIQ34thns2tvLOH9ieWC+HlC7XMLtO6wCKXfHM/acXnAr4Uv7VoymfeNstk2l47j4fSJTtU84D8srbhuuUrCnbBuSCg8UCLGLu48XFlx1w==
Received: from MW3PR05CA0008.namprd05.prod.outlook.com (2603:10b6:303:2b::13)
 by IA1PR12MB6329.namprd12.prod.outlook.com (2603:10b6:208:3e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Fri, 16 Aug
 2024 19:40:58 +0000
Received: from SJ1PEPF0000231D.namprd03.prod.outlook.com
 (2603:10b6:303:2b:cafe::ef) by MW3PR05CA0008.outlook.office365.com
 (2603:10b6:303:2b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.11 via Frontend
 Transport; Fri, 16 Aug 2024 19:40:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF0000231D.mail.protection.outlook.com (10.167.242.234) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.19 via Frontend Transport; Fri, 16 Aug 2024 19:40:57 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 16 Aug
 2024 12:40:49 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 16 Aug 2024 12:40:49 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 16 Aug 2024 12:40:49 -0700
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
Subject: Re: [PATCH 4.19 000/196] 4.19.320-rc1 review
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f52d1e6f-f15b-4d01-be73-1280c52b6198@drhqmail203.nvidia.com>
Date: Fri, 16 Aug 2024 12:40:49 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231D:EE_|IA1PR12MB6329:EE_
X-MS-Office365-Filtering-Correlation-Id: 52529c41-55e5-4463-b901-08dcbe2b5952
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OGNseHJsRDFnWEwvNFRCZy9xbzZkVDgwNzE2ZXNNcUNzbDNwSmZiaWFtcTRT?=
 =?utf-8?B?ZEQwL0tlaDNCZkNCdis4bVo1Qnptc0pwOWo3SXJtdGpES2VZQ1VhamlSM3Va?=
 =?utf-8?B?YTNTSlpEQUFYbURhekRGaVpyeDRmZVMyVGdqWlAvS0M0d0JabloraktWZzdW?=
 =?utf-8?B?K2xkZFE1SmVxcWxqNXZTajl5MkR4RkUyaEdidlNQUzRRdXBiWU5IM3NCTEE0?=
 =?utf-8?B?TENEdStYQVNWYVZwd01DSEhONG5CUXZrU0ZZQS9iUzFJSk5hVncrVGZYZTZB?=
 =?utf-8?B?TFZJRjQyc05PYXM5NXMxUTc0SCtoYkUvbTlXNVZLUW1hZ1VBOGNUZWVMbzA0?=
 =?utf-8?B?S2pTZXA5cStLS3FWSEREUzJ0d3p5UXV2NFZvTEZUSDhqNmpuYzdIaXM0REd1?=
 =?utf-8?B?dW9JT3ZYdEQrQW10WWJVeFJNeHdaY3EydzgyalQ4d2xDUDRrUVdHZWlJR1VH?=
 =?utf-8?B?bktIV1ZKcEx3ek5xU280dFUvWm0rVGo1NW12bVlxdVVmbEtNVjdYZXFtSTFr?=
 =?utf-8?B?bXJyZ3YzNUx0V25uZlNGOExXSHREQitaRmU2Q1lkUkNvNUpJdXJzcWgvbEZy?=
 =?utf-8?B?Kzh0ZjNPU3c3QlhFbGxJbWV4NGs5SVc4b01kaEFRdGVhQlZHS0hBUm1pcklS?=
 =?utf-8?B?M3l3UXk5ekJ5QVB5OGxLYmNYa1A0alNhcnhQdmNlY2xheDdNSCsyUE52eFV0?=
 =?utf-8?B?QUorb0g0cXJxU3B2QzlQdWdzU1VMdTVwekhFM1FIWXZPTlFYQmRJL3BLZGg4?=
 =?utf-8?B?WFlRU0hLblFKM3Y1YjZtalBDQWY3K2pwRlhmWFBBN1l2WHZzY2FjTUhQMVl3?=
 =?utf-8?B?NTZ1dTUxeWd3Z0ZQaWVkc1Y1cGdiTkQ0akdBcTFMbi9KZ2pXQmdUeHRhRzhO?=
 =?utf-8?B?aXB3RzZyZXV5eFdEeDYvaU01WHh3czR4K0N0YlJwQU5tME5sYlNwY0orWDgy?=
 =?utf-8?B?MGFlMk1Fdm9BWk5zZHBTbjRvc2c3ZjVMKzVpYkpkbE9iQURGYnZPMUhJWjdH?=
 =?utf-8?B?b1ZOdVpYZFNiUmorU3UySUgrTFRtdjVZaEV2WjhYRlhJNzJRT1ZvVEhQMkQz?=
 =?utf-8?B?Ly84NjVndHNCQU5FQ2dSVjlCQ2lqYm5oVjNtNVhkbWpLNWI4dWJhM0syM2o0?=
 =?utf-8?B?ZXdWSlhMRHpXOVIzc2JGZGsvbkJ5WlYzcHhEOWZDMHhubDVwTDVyME9mNTlS?=
 =?utf-8?B?ZXFaYzNpSDBmdC9JZDdPNmRhVGpLeTZ3WUZHY1g1dTA2Mm1WcTMxaU1Cb2g2?=
 =?utf-8?B?Wkp1anBpN09UdEQyZHVxaTd6RklCc3hNNGJ0T2ZSdSt1N0Vsd0lFVFdQTXNy?=
 =?utf-8?B?Z1JvTTJlM0xrU3RDNjdyVHJyTE1SU3RtVEZVdllENUZJMEM5VE0zWHNQY3J4?=
 =?utf-8?B?U0V6dFRFTWRVMkd0a1k0MlFIMnVBcTI0Z1BCdnI2U1B3VkhzTFhTcE1vTjBL?=
 =?utf-8?B?RG1UZk5yOUthTzAvUHMvczk2WHNLOXQ0NlIveGNwV05vd2dJSXE2QjFBeWFo?=
 =?utf-8?B?L0VqbERlcnJJR2hnSXFRRzNQT3lrcHpnYWkxT2xmbll2dk16UVowMUsvTDBj?=
 =?utf-8?B?NjJHeEc5N0pOTGRKL05HT1VON0RyQS8xRzZPMmhsdjNhY0txLzhnNWlSWHlq?=
 =?utf-8?B?c2FBSFBWNGxLRURnYjZILzFLcjhxUWJWRk5qcGVyK2ZJbENIWFV5MTZJWHFU?=
 =?utf-8?B?R1hmeitOUEhtR3FPSDJGN1lrQlluZjNhS2JicUVsNTZhYjdvZ0pqNXlXQ0RY?=
 =?utf-8?B?VFQ0a2h4UGtKYnorcTl2bjBBamUrZ3duZE9xeHF6Y0U0Tlg1QTc3NFRwMjJO?=
 =?utf-8?B?Y0NESDFSekdweHBLL1hkaVc0T3dtcnJqUXliSXkvWXZ5OU5zdVUxdXgxZFhX?=
 =?utf-8?B?Qm50bUoxVkdDMENxTlU0b3EwbG5Pd1NqR083MlkrWTJXZkNBaXZwdVRGUnBm?=
 =?utf-8?Q?/TG5jVku47WaRmSyufyouIboCa2JgY0A?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2024 19:40:57.0920
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52529c41-55e5-4463-b901-08dcbe2b5952
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231D.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6329

On Thu, 15 Aug 2024 15:21:57 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.320 release.
> There are 196 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.320-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    20 boots:	20 pass, 0 fail
    37 tests:	37 pass, 0 fail

Linux version:	4.19.320-rc1-ged3349953afb
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

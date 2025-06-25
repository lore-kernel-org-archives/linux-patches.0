Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB479214209
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 11:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750851375; cv=fail; b=EZgmkoi59VNI0i9iKbI58vx4ZP2MkQ3BJtwOGRv1582Y4OxCpQqKQIN1ynTl23/oxPCfjzrASSeL6iRpxjPCbtt22UTmaR5hog1Ar+70UqgCHt57l7mkIMpR3TzSMLakRQPqzeEuG8tBU7+CiVcMadSctr3hwt2I8g0HsZT3A24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750851375; c=relaxed/simple;
	bh=gR0IAnZRnUl3YE7yzAUTY40PeCA5UG1hy9mBbRo5U+o=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=nuqRmZ3QC9hCntPY+svpOiBvnMzQsWHKKL6DTTSzruTuOw3Jg/Jq4F0TmvOuUZkvROrSnOrvp3Xbv+C9SSl5VliUahF2UT93yB6O68zISHD6yqSv1gqe4G5pm7kQzBz8gSqathmEmT0P20wtpdZLzWjP1wIjBiVB0bhtAMz5UKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lxvMo0F4; arc=fail smtp.client-ip=40.107.94.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lxvMo0F4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cBjRDzMgY/qBqAfw1as/sppf/Pr0YlZ+bQghPfQqUoH8LoRed0/jfdcyg3DSzFHSnlXJ/hTmo+sKDcR4ErHTpCG6/SKLd35oqakjt8xeU3czdOXYMQvK2koHMCaKcYngZm7Hl3R5IxP+Ij6Kxl/0RFY4r6R88ux2E1nOB7UJciH3hF90s7Xjr+rnZq1BXfTnVrN/sdRgcV8W9jZE0D82l81sR20JeT6MiES7I85g49tXVvXux4wQR2uo6mjkgj/P6jU9unysQCPcG+uzB9JoCO/UP29YJE9A7y2QUOK70aOR7zdI/2aLrCKFghbCqzsH13p+suIBMbwnWaMSEf2ipQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fzw9yC9lfQLtjXfQuxchWlIzGXP0rsijf8nkMljRQU4=;
 b=AFPfJLccSDFTsGqXEz8dE7f44lJRvViw55ngIbbvavbyhAv+eSNvaXO9E0X7iWTEbjuf/pti1ya/m6ilYoeGZfWR9DSeUi3rwhqs0thkf7CY+CWTgnFE6iCHKj8h7DuVymIkqv7yXso+sg0QesEMJmmjKjApZ3Y0UtJqS4p1SBX5rEajKMQyDo0VBiPdZcgHAqQztdD1Wwgay8OgW32UaBgmSu0vS3UWRPwiW8AbD/lNZ815/ymxW4+T7HfrNtQyn5zwzFUWMe5SA/Uuf3HgrLQJpy4jXi1E1g5nboGJj9t+uceffuTysIRtffWeeZ+yYeNMMKhupH2HOXXdyPpzUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fzw9yC9lfQLtjXfQuxchWlIzGXP0rsijf8nkMljRQU4=;
 b=lxvMo0F4lTNNCqEpAWThLqXPw2O3jLrhMU1RBd2uXG6mz4gG1ojzpWwAwy1Yo/7UoS1xnTv6L2VLaRzz9sq8HslAgb/khYnvmNa1nQQ38Y0+gYA92gvzYBaesdGCENVWmwTYs95FSfcNT9W7FoJLWR2FL5Ryxd93Qk39iWzC7TEfNZjA4+D6J48eol3qPfc4tN56jms9UmPWU3lZaNCHxc9Z3mcZhg2uwFBGy3yQ4dVGu0/UNOEb/FWy0m+elDrH4+DXifvbWBTngMyfKt2cHd8AWkTiUL6c7V2uETpjraXZd4JeFU+EVxTNii2C8ijwEUh7vxyCHEFDXsvPTgYQQA==
Received: from MW4P222CA0015.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::20)
 by SJ1PR12MB6049.namprd12.prod.outlook.com (2603:10b6:a03:48c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Wed, 25 Jun
 2025 11:36:10 +0000
Received: from CO1PEPF000044EF.namprd05.prod.outlook.com
 (2603:10b6:303:114:cafe::87) by MW4P222CA0015.outlook.office365.com
 (2603:10b6:303:114::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.17 via Frontend Transport; Wed,
 25 Jun 2025 11:36:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1PEPF000044EF.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8880.14 via Frontend Transport; Wed, 25 Jun 2025 11:36:09 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 25 Jun
 2025 04:35:58 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 25 Jun 2025 04:35:58 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 25 Jun 2025 04:35:58 -0700
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
Subject: Re: [PATCH 5.4 000/215] 5.4.295-rc2 review
In-Reply-To: <20250625085227.279764371@linuxfoundation.org>
References: <20250625085227.279764371@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b9b7fb8b-9489-4150-8ab0-5267a5be2321@drhqmail203.nvidia.com>
Date: Wed, 25 Jun 2025 04:35:58 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EF:EE_|SJ1PR12MB6049:EE_
X-MS-Office365-Filtering-Correlation-Id: b988344d-3b00-4255-56a0-08ddb3dc7b50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?czNFL3B0M3kvbnYyaldNdXFNWDBQSUpETUpUVE5POHppRFJ2T3NReHM5L1FX?=
 =?utf-8?B?VXZXby9qU29BMi9nQ2ZlbTJ5S0Y2OHlNZndPTTF1TUplOThqUDRBaE14bG5r?=
 =?utf-8?B?TmhnT016ZzBweDEwZ1BRUXpIek5sY1F2TnNEcjd5Qk5uWDBmNkJvTVVFUjhE?=
 =?utf-8?B?WkVTQWRKN3dLVVpXc1RrSkpTcjBJN3dQeUI0QW5mdHZDemFsUVN1L1JPeFhu?=
 =?utf-8?B?d2xxN1JlZXdkdDg4YXlDR05iY2R3ck9IOFZXOG5IaGdHdmRkRk5pTllIcFZn?=
 =?utf-8?B?eEx5a3VIWHgvNDB4bHN5NjV5Y05sY3plRkgvbHgzOW1ObVI4RkNhMmszMmVI?=
 =?utf-8?B?UzhlTHBzR0QyUEZiQnhLcjFBeUozY3BwZzdZUkRKZ29xbDRSS0szYnYwVXJo?=
 =?utf-8?B?MHBxV2pIS2JRZEMwUE9QR2Rjbzg2R0xuekFDRjllSUNBYzNIV3VIcU4zZmdv?=
 =?utf-8?B?VVVkSXEvMnJuTUZUeVl5bmdJUnloREwySlpMUmhEeklkSmZIM0tJek1CY1o3?=
 =?utf-8?B?c3h1cUpmbXFDMXFsWXB3dXVmSzZ1bnZWVEg4b0w0eHFCN1c0NlhKSjV5Z3dP?=
 =?utf-8?B?NWtZUmR0NVk3T0ROSTBjNGNJL0NwK2JRMzU1NW9WWEEycVp1SE10TERpSmJw?=
 =?utf-8?B?Nld6K2hNYXFscWRPTVdzdFEwYm13QVRVZkxWSHJJb2tuaDNicDdDcHJsV2gv?=
 =?utf-8?B?amwvbEhnTmdJSjhHMlRKU0RlQ0s2U0RZTGt0R3lueHB1UE1kZVY0K3NFRUpE?=
 =?utf-8?B?RE4vM2E5NUhhM3AvcjE3Sm1QSFBTY0c4bEFFc3VPM3dYb0FEbVJCNSt2T3Ny?=
 =?utf-8?B?VWNXUURXd24xMEd2NFhUaElZWmlra2pxeWNXayswOWRqa3BvaVVsWk5ubUo4?=
 =?utf-8?B?aEN1ZlF6SzBETG43d2ZwYW9nbWRjUnZjZVY4RWswZkdvVDM5dG0rS0JIQ3g3?=
 =?utf-8?B?WUo3dEpxVDFwdXZ4N08rNzdXNWJxMngzMUtNNVV3cDVkT0MreVFpK1BSWlBv?=
 =?utf-8?B?YXc5enhIeW44VUpmV0hWZ3prckErdWtobHkvZE11U2l5T0M5SGdXdmdRbGhp?=
 =?utf-8?B?YkpKOWdhNHExaDVLcU9Zc2haU0V6VTg3b0EwWjV2ZGJPWlNHSTZMS09kbmlV?=
 =?utf-8?B?SHRDUTZhaGVia2xwWUJKYmtEdEM0bytSRlVidEZiVk9ZaklUbXIrZGdlN0Fw?=
 =?utf-8?B?QmJZZDRRUkJoanY3bVFXSG52SllacUNRNEdOMG9BSVlJb1JVaHBuN213QzMw?=
 =?utf-8?B?cUZ6UGlOTWRxR1BlTmJSaHVSbG1BVzJublg4Z0J0TFI3R1RqZGZBVytaaDdV?=
 =?utf-8?B?a2lDQ0NHS3loVGpvckxZV3VhVkh1d1F4c1k0ZS9EZkQxOG9Oclp1RmtiaktJ?=
 =?utf-8?B?ZWwyM3pnZzIwTFp2Q09uVmxOLzZFV3plMEY2M1RPOWN4YkNVN1B4Z3ZMN3Zq?=
 =?utf-8?B?WlRhNU0vZU5vTlVUSzVmRTJCYXVvMFBiTU8xNnNMdlJrTnJDRy9DV2o2amZq?=
 =?utf-8?B?aVRwQXNJczJPMUxvbmFFRjh1bUczelJqdFR0MUtUMDMvVVRkNGVvQ3R2MGo3?=
 =?utf-8?B?YzY5V3htOWdkMXVkYzNrZ3N1UUhPa2pNYVRuTnFNdEYxa2g2eS96MTMrTzJ4?=
 =?utf-8?B?RGlJVzduYWFENmRIU1hIb21QaEZlMVdvZUlNWVN6Zlc2WEM1Z0xmSkNxRTFl?=
 =?utf-8?B?T3Q5SEo3NHZuNWxaZ0VzK2NUYk04NEYyMGcwR2Y2cjAvaFppME9DSHlrNUNk?=
 =?utf-8?B?OGsra0M4VnNQZWJ1MXRwWVdkMHF2YlFDNVg1UnBxT3U5RUlpWGlqa1B0Um1C?=
 =?utf-8?B?OEZCMk5OQlBDMkNZUjRtVTlLdithZ1kySGpFWEpoazhvSEZ3ZTlsU1RqSytK?=
 =?utf-8?B?RU1RaXY0RmVNYkhRM2Z4VWVqZFNHQWFDSG5DdVFUMVZaL3BjdXFjTndTUTdK?=
 =?utf-8?B?OWQwOGFrSnkxcnhYeFpjS0lQWGQwVUtFVEpmKy9idVcxSFZFcU90S2FyVnZi?=
 =?utf-8?B?WUR4eVkvenNsRGY3MHhRMkxCMlkvUmQ0ZmUwUVQ2cEdka21EaWFhR2doaWNo?=
 =?utf-8?B?aHA3TXJGcFJJYlR0Y2FuenRDcXYwYlZNbFRQdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 11:36:09.8814
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b988344d-3b00-4255-56a0-08ddb3dc7b50
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6049

On Wed, 25 Jun 2025 09:53:55 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.295 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Jun 2025 08:52:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.295-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    24 boots:	24 pass, 0 fail
    54 tests:	54 pass, 0 fail

Linux version:	5.4.295-rc2-g1de5ce8d465e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010066.outbound.protection.outlook.com [52.101.85.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472A0313523
	for <patches@lists.linux.dev>; Fri,  5 Dec 2025 10:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764932317; cv=fail; b=O5u7T2BsHcJQ9/vSDES0dE1jU4vSNIgfG8NsZL8wA9U94vG/r59kwGnfPLEpHb0UKF4QPYe0YSzK/vUBg9MnFJ4Zzvo9IMnxJRaUqaKTm/RnnUIJlm51e90JvTtLOgwpVkpUOAht+/I26i0Jnu9aUGJ8rWSvHRfMbHvIqK2+ak0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764932317; c=relaxed/simple;
	bh=GTNI+FM58MIAuTiKp1R1mORPFUo6kiF6UD+o7xjkZpI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=D01U4LgoL/Vyrr3dQyMZkmOmBJgDNP7xhUtR/d3dRAHsULs2M9PO1cZENpfSZxvZcVBHLq+Tv+znRbZvzskrptqLLN/c67+oKHiff4JHp92BfuVV3DWLWjo8P+Ksz/+VTz8SOR0p7FTAiChDKKqdJzY8E4e1/L7FHGQj2HezyEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WOpRHhlQ; arc=fail smtp.client-ip=52.101.85.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WOpRHhlQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l0iof4+fB4dGNYl/6jNTV4PcWIxy24b/cefoSrc86Gz6LGTpsTmXAJeP2VBfbWuhE1LhFUZkfAPjFzCI7XIn5CoXNonRdNmOBq+KEaiWtef6XcSaNwZXPmUZ17RXMAdOb74x5zBj5rrT4Lc8f+WDbhX4UDEWs8dUX1Ew+vxe9lC3jynFKP0kIVeOOFosGmkH6eT4ky8TgfMNnA/aQWJ+Z9aSPFlzqs22Ge3xHDchVyAuiss8aiU27SQoGninRcPim1T35d5ACoBRWCTvGh+bIoRvuSH40GCkh1cTlBijzbZF/g9yO1OwK51tNcDqWdvNKdMCwI3rumj+gt+w8yJkiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tz5EUyHMlx+PT+umvFKRW5hwFKQG2JuUDsHdaCJnXF8=;
 b=CwggrJc6rmKN+I7E95BHV8VjJuCWBTB86Sb4ZXG0oNHKf2B34YEjP2MNBQwhWRT2MDs7HDL3XLuJgtwrHoatOb7v1mDLXXLX38FDuVGXyK8JE0bkpu+JoIdjyq2WSM1oCzz94STPLsbgVLaI5mgyHr9SXIiLeMzlmQOKpqFsUvErDEmbf2CmlXk9uZKUzSYbxIadrwD+Wx+iEZgRdEcpaeroq8pmiYwZ5knH+Nwh5WX8UBlVrD1bmi66vIlv/WnDeZZ1c8mptlgYtYA+Q16cnaJMk95snmYZ0kwKp34cKxga4uJfpqJIwlWwF5/12OdRysS87QQgLu64bj3nLY0EdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tz5EUyHMlx+PT+umvFKRW5hwFKQG2JuUDsHdaCJnXF8=;
 b=WOpRHhlQYUgdfcm0KW9yjgnDvYO77XS0x62zdw8+vCI77dl9p6IfB25wog2iqItqq/u90zYj6OrBTmWXdf5ub3waEb/06+t6YUYYlbgI2U50lobuZK5svPOEMidwDeyQrAp8a5HgjULTMGfpJB4PYfvoc31W2QH4hjBF/+v259pyKZLcja2hVR3+fPapDl7i4Xd8EFgfJ8Noai6maliSpOCpjfQWHXiWS7XflTg1rPQOLNmNZEEo9JaR1is6BHxXXyiKHLuuL3y7eObAzpZh0Q464BACn8bjakIUEpsKL1ZVSwnkb1g+SffRwPBDOnl3yK2O+/znlE3qC0o7XJnOdQ==
Received: from BN9PR03CA0876.namprd03.prod.outlook.com (2603:10b6:408:13c::11)
 by MN0PR12MB6152.namprd12.prod.outlook.com (2603:10b6:208:3c4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Fri, 5 Dec
 2025 10:58:26 +0000
Received: from BN2PEPF000055DF.namprd21.prod.outlook.com
 (2603:10b6:408:13c:cafe::60) by BN9PR03CA0876.outlook.office365.com
 (2603:10b6:408:13c::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.11 via Frontend Transport; Fri,
 5 Dec 2025 10:58:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN2PEPF000055DF.mail.protection.outlook.com (10.167.245.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.0 via Frontend Transport; Fri, 5 Dec 2025 10:58:26 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 5 Dec
 2025 02:58:21 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 5 Dec 2025 02:58:21 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 5 Dec 2025 02:58:21 -0800
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
Subject: Re: [PATCH 5.10 000/295] 5.10.247-rc2 review
In-Reply-To: <20251204163803.668231017@linuxfoundation.org>
References: <20251204163803.668231017@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <74222128-3d3d-4ba6-a36e-f30946377272@drhqmail201.nvidia.com>
Date: Fri, 5 Dec 2025 02:58:21 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DF:EE_|MN0PR12MB6152:EE_
X-MS-Office365-Filtering-Correlation-Id: 006440cf-33a7-4e93-e7ef-08de33ed37a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UmRkQTliWnlBQk1pMFNFd0lsc01iVzYra0grWUtlOHRmNGlrZ1NzVGVCMHdM?=
 =?utf-8?B?QzcxQ0dZUHRjbXorL3Z4S2EzQ1RSalNMN2VBdTA4R3lLL1lqNy9jOXlqUmlJ?=
 =?utf-8?B?L1dyRys0MUZqVE5TaWFGSXhtSzBaM2NIbTByUW8ybGZlbTFJc09yVzBCdWtv?=
 =?utf-8?B?M3RvUERWZWM0Y2RxeFNoV05udVR5bGhXTnZ4dkFHVEhvbEhzWjM1a0N3cXJY?=
 =?utf-8?B?ejM0Umg5aVlOZThxSDJoVEZYRGdwbG9VWXlNRkpYV3hlNnkyWWRxeUd6L3Ni?=
 =?utf-8?B?S0N1STZKb3FxS2tJbDY1UHJGUEpoU2pjNGxkaDlSTzQ3WGpONTZma3Z4d0kx?=
 =?utf-8?B?YVlmNEplZG5OdEdRbytaMmU5TzF3amVxdFZrd1dvR0drVXBXbmZPOUo4RUwr?=
 =?utf-8?B?TjYzcE92SW9peGZ0OE1NUXdYZ2gxWkRnM3BLdGlJMm11RG1nQVM2WGNlNFZR?=
 =?utf-8?B?SERrUFIxMWs5REsvNnd4ZDI5S2Q3VE5Ia2Q2b2ZkVm81d2p2cm4zdkptbU41?=
 =?utf-8?B?UWd0NXZUTGYyNVZlam9OZG9JcjA1L09mUXZHL2dzQmNsVVlwWlpVK3NZamN5?=
 =?utf-8?B?OGN3YW0zTThOeDErVzNxZllNMitzYnhheStJd0R1c2hIZDhOZmRJekt6azA2?=
 =?utf-8?B?WlRCRkgrVFlvUllabDV0eWlZOHMwQlRoTHJZYmZQRHpQSDJtWXY5TEROWncw?=
 =?utf-8?B?ODVWbnBqamE5cE5YTXk2bXBYVWs5WDEzd1MrdDdNSExOOUFGY09uUjVGZXpk?=
 =?utf-8?B?TjBMVDhwRDRvRC9SZU5UTHlzdVA1QTZWSm9rb2NIYklGUkhVem9aOGJoZUdL?=
 =?utf-8?B?VXFCTFg1ZlREbXUvbFNZTm56RzhSVEZpZzJHNDErTXhHNHJzUEpZM2lnR1B5?=
 =?utf-8?B?REx0cjVsa3RrQ3lBa1lMSEtoRGtxQ2dST3E0WEd4MDQ4bjNLbGV1SXRNMm9l?=
 =?utf-8?B?SWwvSzdCZGxMNGxWck5YWmh1dVc5MTZWSVpKb2NkNTZqZ2Y1ejlqU2FPMFgz?=
 =?utf-8?B?UkQvcC92YWJ0Z3BlQ0F5Q2wyNUR5SFB0d3pvcENWeFVIQU9JTEZ2cnpEN250?=
 =?utf-8?B?SjFWYldDS3NPNmxnS0ZtRy8rOGtROGEyYXBSV3AzcmpSSmN5aEw5ZjFzN1hV?=
 =?utf-8?B?Yy9Ld3crWjc5Rm9QZHhDdDVNTlZhaStsa3FDb3M2bnJ6aVVNRno4OVlYWjRx?=
 =?utf-8?B?NmlWa0dXQ2FMeGV3SUdwMFJlTzZRc0ZXSEs5MHpQSGhCS2F5V0NIZnE0cDB2?=
 =?utf-8?B?SDF1ZjB4VXlMZThuUEtuMFBxQjgxZDlFeE4vdmEwREx3K1puMDBJVzFsMzRS?=
 =?utf-8?B?QnpVN1NJZUJ4OGVZeEdUT1VrSFdPSmZSRGxsTGJxYThsenRqV1hiU2NJRUYz?=
 =?utf-8?B?UCszc241M0R6dmdOcndmYW54S3c2eGxtTCs5aXdqOENpMkhJWEdpamxUdGpO?=
 =?utf-8?B?bXA4citOeVRialJiVkVGV2kvUTMzWE1LNGVjUUJwbzFwVDQ5aVdEdFlneTE2?=
 =?utf-8?B?TktMVnNTTUQxeVFocytIOTBwbllrUktnM1FWNitqTkxHQVlvTFFKRmdjeXFE?=
 =?utf-8?B?L2NZZzRwUlJ4UGU5RGwwa3RoUjdzUC83Z0dpODRjQUVOb1NaYUJQN0ZZcEJw?=
 =?utf-8?B?VnhaWE96UnZzY1liT3JzVmVSUHkySm1uYWY4ckdBTTNLT0tyZ0Z1bFFZNHNW?=
 =?utf-8?B?cXlwTCtFM2g1TFgyUHc4TG5VNHRzQ1QwbWFaSDNpRVJqSWdIOEp3QmFDSzB4?=
 =?utf-8?B?U1k4TlNXYk9kSm5rRlAxV001TWR5RlJ6dFBMTVE4N1FNdUR5WTN5MnBIV1hP?=
 =?utf-8?B?M1R2YWxrYU54SldkMXJvNzdNZXNjb3pvdUlYUlpibXM2b2hTbUxxbnJ3Y3ND?=
 =?utf-8?B?dUNydktvbXpqY1dNYUYyY2RwR2xyNTV2M0l3K2lkVC9QVnpOZ2Q3ZHlLem1J?=
 =?utf-8?B?OEVpTWMvbGNtRThCRjY4dXpJeTlTbU5HNEc5bGpoZkxjek1GcTJtNDFZWHpM?=
 =?utf-8?B?cUx5U2VXdGNCSHdQMktFd1cxUVlhVExnSmNEdnBKK1Q5QjRVMTZtWEtOZGs4?=
 =?utf-8?B?UktpRDRmbjdOQUZXRVkxb2pVdTB5cW0xQXdXbWtWVzlDNWlpazhTVFFHQ005?=
 =?utf-8?Q?SNLM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2025 10:58:26.5445
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 006440cf-33a7-4e93-e7ef-08de33ed37a7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DF.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6152

On Thu, 04 Dec 2025 17:44:09 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.247 release.
> There are 295 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Dec 2025 16:37:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.247-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    67 tests:	67 pass, 0 fail

Linux version:	5.10.247-rc2-gce7ecdbcc489
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

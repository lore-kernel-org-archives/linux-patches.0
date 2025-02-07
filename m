Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25A21DED70
	for <patches@lists.linux.dev>; Fri,  7 Feb 2025 11:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738929546; cv=fail; b=ALy7t6zNO9+EC6mv2wQ9T/4CXxZGymi2UEW2dK2H7C0VD91TS0ZRjXeoi99K8JwIHqHwj27YjDcFJ0DYlAuZyMoBRFwgy3El93rU/yQ5tUjcG+7q04+769xPEEqYR+/2VpTEjsAWjFX7VZOD0VAda6Rermrm4KURNd/XHd9G9ak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738929546; c=relaxed/simple;
	bh=62afjNu+cbveFSz086JNkwT2J/osQmcHZqeB5tn1cTM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=kY3u10TBeEutu4++4/1cstj++4h+VVp4oO9cMEg9xvQg6sluZpKmyk8YUN5zSjlLO3tG9JZos8CowkGP82UaTOcY3JYg8kMp1D7hJt/2xTqsmrJzeADhdw4EXl+phWqgZPAIx/98ePeCRi0PItFwWP8wkRGKMthevTQ7pleJc5w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JWn0UAEn; arc=fail smtp.client-ip=40.107.244.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JWn0UAEn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LlBEKBKE5lF8p6T/aU5PqR34Bvr5EX84aXH5I45BnorhfTUGRMDvrKBPDVCsKTMp1U4dUoNxYf15LbT74LBc/ZO/DzuqFaDgXInwNW5nI4ImYiMgymVPPKaXvk42A82K0bRpnjKlYD+74URyIn9O/jX3QIMaWaAlTDYYx5mgnYwqgbo5i5BkBd2S53FZiMGfYUH2AfZyXDA+CWHupXdNCGV1by3+ACPTWENYF1BFIiT5oYmJQ4NTDCVsRPC0tE3EPLBkm3pjl32xCXT1uK1OG+lvyXkuTNI/rNHv34YKuiYq+5Lc6zWDQX9UERAIHpuKg1fVN5U3+ssco6/hhFK0XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YuFvJRM22yqEVehJ7OBZ4v/1VU0vjC4HO2q0yV2y0Pk=;
 b=gm4qBzgp18rMXw0KxS4xtQbHd63Jzerg3wni2g1+rh0whSXxf2EZPzUVLjU0wUiDea2z2dH7eYZPKO7erYu3tN7glmD35gj/C4+qJLKbiFOlMGo0BwttJqGlJlQPgBeWDYufT5R2rrcj/P+doOxVS8sub+0jmK6+eLkTbpjN/T6+6L0H7E5SB679inJ1FY/c5tHWZV0sNZIl3hLe+PLbkJTRIr3W0xvxPuSgKeBxTxAZxxBWGtzFBJ1UIEplxBsE/qoDGYOgcfxnp9waTswakY315kd0A0nZAs1iMD+QoXr0Qph58fWTg0VKgr4TRbWt3FAqWnaTYO79NQ1Euf7krg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YuFvJRM22yqEVehJ7OBZ4v/1VU0vjC4HO2q0yV2y0Pk=;
 b=JWn0UAEng4Ku6OAIobtzVHjZXBrqmItvIzhQq9ZMzTPXuHYsKfo5AzT8wKHredPHeHVPA/ySt0O6xiFAFnlmpEZslwQ57zoaGoZj1Q7zi2QiNmiRdw5CwpSzcX2THf4jsfoD329iA6MO6vXJrWlns760WR4m8pYF1qOe9GuvHdxLsQRXJ62AXJ8v0zTYSgYLaPq90NSy40UGRpSXfCmnNPxkTPTEHTlaIuENnV4T+vScytlA2A2TSC/Fcj87jctcF9xboKXXI5QaSL84cTwr2DyK5zDindI3ewhf1musHtk2DME4aRN8qPGszj6rIxOds5ouoKpwbfeTS+EY6dzdzQ==
Received: from BN9PR03CA0710.namprd03.prod.outlook.com (2603:10b6:408:ef::25)
 by DM3PR12MB9436.namprd12.prod.outlook.com (2603:10b6:8:1af::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.12; Fri, 7 Feb
 2025 11:59:00 +0000
Received: from BN2PEPF00004FBC.namprd04.prod.outlook.com
 (2603:10b6:408:ef:cafe::b8) by BN9PR03CA0710.outlook.office365.com
 (2603:10b6:408:ef::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.25 via Frontend Transport; Fri,
 7 Feb 2025 11:59:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN2PEPF00004FBC.mail.protection.outlook.com (10.167.243.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.14 via Frontend Transport; Fri, 7 Feb 2025 11:59:00 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 7 Feb 2025
 03:58:53 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 7 Feb 2025 03:58:52 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 7 Feb 2025 03:58:52 -0800
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
Subject: Re: [PATCH 6.12 000/583] 6.12.13-rc2 review
In-Reply-To: <20250206160711.563887287@linuxfoundation.org>
References: <20250206160711.563887287@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3e979e75-c9cc-4653-9d27-1ac595cf6d06@drhqmail201.nvidia.com>
Date: Fri, 7 Feb 2025 03:58:52 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBC:EE_|DM3PR12MB9436:EE_
X-MS-Office365-Filtering-Correlation-Id: 73715f8c-52e5-4b3d-e182-08dd476ecf49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YzZWN0dsWHBSZ2FjNFRudHJkSFNCZXRkeGdhSGF6VjloN09xc2trcTRVTW1w?=
 =?utf-8?B?eTVLdFhJN0g3N1BSZ1A4alI4eVJLM0c1ZkI2VjVrQW1QdCsweklmRDRQWVQ5?=
 =?utf-8?B?ZnBkeFlxZGJhcnh1TGd5czZWcmk5TENkV0JDUTNpekdncmZvQkVqUDNlUmt6?=
 =?utf-8?B?MTF5emRyaGVOdW8ycXJwMXFtY2JNMXorSGRkSGE4Q0UxSGJaQmlhR25FVDJ5?=
 =?utf-8?B?OGw2SVNQNW53dkFTbEV5T3MybjhuejA0OStsZ2FKdW1TdGtsbGdtVFRKUTF0?=
 =?utf-8?B?MTUyM3R3N1Nyb3RBNG9JbGZwNnk4OG1KdnN0bEg3MUE3YUVoZjN2aEsrb2d3?=
 =?utf-8?B?RFc5eGxGaFJld3pHalBMWVlMRWo5OERQbnZYMVJ1bTN3T2gyUUhRTzBlTEpF?=
 =?utf-8?B?V0ROWXA1S0s1U2JVeTRHczhoSkVlYUdJdHdhK05EQ2ZXUU9yaUEyUlZ3dzZY?=
 =?utf-8?B?OVJ5Qk41SlQvQ0VSMjl2VXNvR0l3eHk5T25DQmFVVVVETTBVWU1oekJmS2ZU?=
 =?utf-8?B?akswYittb0VSMGhScVhMWG1YU0hRalVvcU1LTWVTZ2haM2JGanFURy9ZYTJh?=
 =?utf-8?B?ZUNLbWtXTWIyRUlhZ3diL1BJYzBVZHpRcDEzWEltQ1c3ZzRrK2NzWTQ0RkNx?=
 =?utf-8?B?TXpML3orcnAzeThiZTZsdVRURG1tREE0cmF6M1pWa3lNcDBzREhTRDVxU1k2?=
 =?utf-8?B?bDExTm0zdXh6T3RmNE9iUXJFbVoyeDVCaCsrcjFDWlM1NkExT01KL2NSdExs?=
 =?utf-8?B?RnRSdmdsN2hsaHd3VEpwYmRnci92MzVOUzhWTE1ac3QvZ1hHUHYwNG5hVG1M?=
 =?utf-8?B?Y04zYUUreU9xUE1HQTlaNFZ0UUpUb3Z4THdKdjhCeWhJbC8wZXF3TnB1Ty8z?=
 =?utf-8?B?cUpoaUVORTVZZ3BLamxwdkVCZUNBVXo3UUg0Mk1hYkFJbXlxV0JrOEtEWmdY?=
 =?utf-8?B?NmRIN1NrS0JMWS92bU9NR2FUVXl2UFlnMWl3QmJ0RmR1bUhsVC9HeU5rcUc5?=
 =?utf-8?B?WDhkUkRHSHJSSzhJWWErTS80eTNnQ21kbHlNK0FLWXRpYmtuNFZyOU4vdDVn?=
 =?utf-8?B?WjB2VFpBTVU4RkR3L3ZFUUtoeERmRlByMDJCSmJDYTFBYzdFQTJyT2xYaEdk?=
 =?utf-8?B?WVhSdE1yRGxFMmRtZ1ROUUk5UUZvWGpzRitCUTZLK1h4ckwrNnlOSHlnSVVr?=
 =?utf-8?B?RDF5SnRHVXY3ei9WZnVoeVVKYmdFQm9wUTU1WDlEcUcvUElObkU0Nis1OVQ3?=
 =?utf-8?B?TG51bjB4SXBmSWZOeUluTHZqUU91TWlUOEg3akFNTnN6bHYzM2JRUGVQWmJa?=
 =?utf-8?B?TGZ3QVMvNktVQnZ4bEFqaFFKOFpVWjE1ZnZESHhYckpRc2UrWkY5Y0p0RDkv?=
 =?utf-8?B?aGR2eGxDb05RVWVYWXBqV2UvZ2VTdUhEdG9MU3B0Q3J3V0FjaDZHZWZnK3Er?=
 =?utf-8?B?dmJvdE9QdVZzTFdLdGo3SUZ6c01DNjRZSGliODdzSXJmM1BPYjJ5REd3RzQ2?=
 =?utf-8?B?Tms5Y1FTR1lVNGhRVHZSSWRxU1Z1L215UUNmTXF6UnhsdUNDL1NKdndldGcv?=
 =?utf-8?B?a1N2NHFIeWVLVmh4SDNQL2JvTEVBVWY5a3FITFhlclgydDl6Q1JVdXVCczZZ?=
 =?utf-8?B?TVhFQ2drbVhCc1B1VnJ1MkJtZ0JUUy8vdEhxemw4TkE3dXpheVNJbkpFcGRZ?=
 =?utf-8?B?Y0hsWjVDclpGbFROZlhUek1tUVdMdnYyVDNHOTd2bVc2YzhXcGFEQ0RYU3pS?=
 =?utf-8?B?bU90QTZXQkYzb29UMzdPZUFtaDdEN1VudStxaGFaTkxSRy9CTnV0TytIMTFw?=
 =?utf-8?B?T0RHeU5IQVgzdmQwVVhmVy84d21VMXNPcUdiZDhyeWhrWnRyWWhSRkxzVXZ6?=
 =?utf-8?B?WXRaUVNiVkh0cEFSYmxHb0RDM1R3cEwzdFMxT0drR2ZRZFFYcnlaT3UzQnYx?=
 =?utf-8?B?bHR1YmJLSTVDZGQrL2RFcHhrZ3JiZDJHeWtRTzljUWNINHBOdWVCazRjNTdu?=
 =?utf-8?Q?xI9K8ttHDpn7q/BtA5vF962uR6Voxo=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2025 11:59:00.4147
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73715f8c-52e5-4b3d-e182-08dd476ecf49
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9436

On Thu, 06 Feb 2025 17:11:13 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.13 release.
> There are 583 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Feb 2025 16:05:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.13-rc2.gz
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
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.12.13-rc2-gc4de2ac60676
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

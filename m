Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2073.outbound.protection.outlook.com [40.107.102.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7965719DF58
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 17:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718384656; cv=fail; b=mqRzAM+fZZ5mcjbS0fjPIKTQz5BWX+7CoDfmspHM8yZTGcO1rgQVsptEUfWMCdYrBaRpN+lArEEnJNALtAftGcyrAPDioot4aE4nJ4jBNkXulisMHWDGHH+KPFBTnWLfYQkKwuHz5ARuWBJYSJjqpc4Vi45foMtjNZCT6itt5HY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718384656; c=relaxed/simple;
	bh=M2ak/LSLb+B8I469JvviS3NsTTEk+X0B+Hf+++h1qjI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=XCgUCbWtFqiqzN67RdBoLX9KmcC7wjPnqNr/3CKRT2E1W91ceGRWvJ1utu1GRgIp94reM9W+aOgL3D2nZZV/zepqvzM8MmBSIvysHlEh5/r9zvKgIVaK1n+LL0canxulLR0g41B+Ibju3Xiie/8GlDOdKRxxm3odhGuEt3Dl2fY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cllw9NX+; arc=fail smtp.client-ip=40.107.102.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cllw9NX+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsQnPXm4TfaZdFqDX2Z7+qSZ/AFg396esxPjOxZlkgKZyO8Len4jYsM3zi2qsstClMMXohB0z5RD1oU7dRf7yRAj+j22s59NyN+2Nc9qb4M07OLimExw8OJhDNyYZQfWz0nntuWtiDxryRSpbaiesazbKFbc0S0TyZcK5a6bZUlYbozwEqskIsqmKigqyiGR+o3/gHULPKs4KJwPWYVl6Dev1WUwIdYSfnz04KnmkWaP7z86+TJlmMi0FDLGDNy6E9gKzpZ5S6Uvyh+dhSCgljVQTZHh2TyMTet6C8K8BfkM+STq3c1klmI8pbtrenvmiByekgmiPrdLzwDMQr43Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mNjtjJbgur8V6MnykxyLHqYi48L/nLAgsubQxFxS4iY=;
 b=noXu/p5cNWUwdtco0lWHLYzdX/y+xHbtfbGXPAoEyhgaesfBbLfhKdMEyLm19EyYMEvgNfYhFnSiit2qDTPiTRsvh7c+EfRYUv0NhiX4D8oL4LzHM+i+YaBc+0a5jhv2OcR7wMdEtTUJOaoCoztWMEcC8G4d0FVd0N1AHMkTmvitoshJwyXZgGZQZgqf62/EvkCb5Mtru566RFPh9CIZ76W2I3Q0lX3C6jCwuVB4sGePvp83BXp0Y0cUI9GUCx+RdALvOPs46tVP5k9KLRjZrqipWNsNWt6ZxNTtt2GGafz3VihAaFedlXxr45iurJqd9DTjSwGPpZ27C8mLLDHl8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNjtjJbgur8V6MnykxyLHqYi48L/nLAgsubQxFxS4iY=;
 b=cllw9NX+Vda9OvHJPVEAerl1lpY/cbfFN85oVGIQkFWYpCGIL97Tk2QuNVZHT/5czJMJeHmluF7PA49UVmFwrfQXxHvzoseh6gRJrcMRgFvJTQlAI4P95SaSSdOQB4ZA2gqpuGh6jm3gP4mmTWHudd1vR83+OIxgHiPu1dn/yNGN8PbPx3oVjTZ2mh0jqwLqtYtvE8xGYMpcNSlPgUXbKb5wQQU8DLyv1abyHCmRKK0y/YuSDdNSVDFtgD/3N2NMfgqx/oJSIvbu6+UlmcXto768pMBcF8EvWoK4dq82tlIQCmDSaeKOC0M2k1t/VWsXTLur1DTOvwU+5ufWXvstfg==
Received: from MN2PR05CA0037.namprd05.prod.outlook.com (2603:10b6:208:236::6)
 by MN2PR12MB4223.namprd12.prod.outlook.com (2603:10b6:208:1d3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.22; Fri, 14 Jun
 2024 17:04:11 +0000
Received: from BL6PEPF00020E62.namprd04.prod.outlook.com
 (2603:10b6:208:236:cafe::38) by MN2PR05CA0037.outlook.office365.com
 (2603:10b6:208:236::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.21 via Frontend
 Transport; Fri, 14 Jun 2024 17:04:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF00020E62.mail.protection.outlook.com (10.167.249.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Fri, 14 Jun 2024 17:04:11 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 14 Jun
 2024 10:03:58 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 14 Jun 2024 10:03:57 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 14 Jun 2024 10:03:57 -0700
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
Subject: Re: [PATCH 6.6 000/137] 6.6.34-rc1 review
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ac0e92e5-0581-4897-a679-270d6630463f@drhqmail203.nvidia.com>
Date: Fri, 14 Jun 2024 10:03:57 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E62:EE_|MN2PR12MB4223:EE_
X-MS-Office365-Filtering-Correlation-Id: d32144f7-006d-4e60-ca01-08dc8c940363
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|1800799021|82310400023|36860700010|7416011|376011;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZGpXcXYrbDN6OUMvb3FCS0ZKZ2xoZURSS25DQ0o0Wkg0T1Z1QVExYjJmYUNs?=
 =?utf-8?B?cWRVTEY2dHFnVGF5UHBSUjFkM2FlOVM1VGkzaGVhcFIzaGtYUFdrTDhZdnFO?=
 =?utf-8?B?Z1Y4TEVzR054WHRaZEhQSmdNQjR2R0FqaWpweVhYbC9qQjV5RGJhWkw4Zlc5?=
 =?utf-8?B?K3gzTnZFT0JPNG9iZXdMVG01NTA1K2lXVTlZeVoyNWRhZkRBUHNVdGpmblZN?=
 =?utf-8?B?YXpTUURqK1VXTnplRm5DdFhlS2ZoVU5qYmFvcjZvVURxRmk2b2F1VVB1SzB5?=
 =?utf-8?B?VDBlOUF1S3ovSWtZOG9wQytOM3ovdDJXVExESzhZMnJSTWFzS0JmaDZpckt6?=
 =?utf-8?B?anZVckhNc2pRUWp2M2xHeFFaNDNYbDFUU2pQQlhhTUR2NXJzZkJ1dzdFeHhS?=
 =?utf-8?B?SlVwc09HV25RejRqM2NJN0dENTVnUHJoWG45V3hkN0pZMVZvTHVoSkF6Vmhw?=
 =?utf-8?B?d0NzQ1ExTDB3RDBHZXVSOVVwL0RwbHk4YXRYa1plSThOb3lTbGVKZHkyMkRs?=
 =?utf-8?B?Wm5NUjFTenJ3MEZkL3VXdHdyZ0JEZzJSMkpoZUtYZmp2ZldQYVR4YjVaM2ZK?=
 =?utf-8?B?dTY4V0ZsN1V4Sm5xekttdXZMalFBTEc4M2lVYXB5c1FSOEErWVdRUVZZK2do?=
 =?utf-8?B?NFVXWlBuKyt4WFBvRVhRZCtxbkNmaEJNYllwSjl5REFXTGYwQ2Z0ZGVwakVx?=
 =?utf-8?B?TGJjRlEvdW9ENktJWGUwYTZqOXkrUzI1ZVoxNWxURHUzekc3Ump5NDduMElx?=
 =?utf-8?B?N1hXSUJzWmhsK1R2QUoyaUFoTXpkVFJuNG1FSnNqQmx3Qmsvcnh4c1NqbE9y?=
 =?utf-8?B?ZE1iaW9iZHcxMTBhMUt3bmkzbzNCelpFaGNpZkMrRDNkcktxaGxiQmYyWDBi?=
 =?utf-8?B?M05IT2UxUDMvRTErYm5JWTJ2b0MvY2owTVdYUVYvakhRcUxCZXVmWHZKbE9R?=
 =?utf-8?B?NitpQ1IzV1MvL0FFTmVFQ09oSW01TFB1NlZlcjVmVHdzc0hWcFkvMVM4VlNC?=
 =?utf-8?B?UTRETXZKQ3BlaWlGYVFuUk9UQ2xjL1RNK2lSUnZpWVZhSUNUZUZ2ZjhicUw0?=
 =?utf-8?B?bkt3ek1rUW1HZmV6RUExYkNrTklVSVBjWk1Dd1lZV1JUZnljUnhHSlJiZGZm?=
 =?utf-8?B?NEdrOUxBOGpyYnQrenVqdHpYb2laTUU2Z1o4UXhDdEptZWQ5TTlLZFR3eHFX?=
 =?utf-8?B?NjdPMmZ6cDhOQy9EUWNWcGxFZlVKNFBCQVUvcm1rNVFnQnZQdVFkMS9SbGtq?=
 =?utf-8?B?M3lXY0ozV0t2NUN3a0QrRC84RkZDK0VPa3lNOHFmWmRoNFJ1TVl0emFMZXcx?=
 =?utf-8?B?V2pxb0dBRFg5S1ZnbGJ1a00xTDVUVTVBQ2lQdG5HczB2NUJPdWlOTzl3cHVy?=
 =?utf-8?B?OWtScExUSmVIVFdLTEFrNStkVVRiTDN4ZzU1RHhtVGt0a3NVaEJZOXRqaWtw?=
 =?utf-8?B?VitUWkNDb3FaZjJoME1NWVZzQlg5bW5kYWxTeTNCU2FHcG5jODBEU3BMMlVQ?=
 =?utf-8?B?cGhPNXBGQ1ZZOGZZSURoMHE3cXVNM3JGNG1FR1BzaVZ6QVVQanluakZYbVRa?=
 =?utf-8?B?Qmt2QzhBTHVCU2c0VCsxLzVxbVpCRmFITXZnUFB2cEZaUXpmbktiaGVFUTVE?=
 =?utf-8?B?VFN3NUJ3clVySFlZeitwckhMNlUrMExmMHFCN2FEQkhjTVZPMXVDNGs3YTZK?=
 =?utf-8?B?V25qcUxLbHBkM292Yjl4QnBSemhmWG02YUZqQzJGbXVueHZEQlZUZGZxNHkw?=
 =?utf-8?B?VSt0bW94aHQvUEpLR0J4ZUczNHhFVDdlN00wQjVRNUZjbUZTSVI1UlRxV003?=
 =?utf-8?B?Qy9IYXVvS0dnM25ZNEk0RXhFVkpLdUxZYStqbE5xY0FLWFFBV3VET2pEMHRn?=
 =?utf-8?B?TU9Ic0dCVzFMUktybXg4TmFOaWRvYzEwZ3RFSlUxdktYN1E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230037)(1800799021)(82310400023)(36860700010)(7416011)(376011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 17:04:11.7656
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d32144f7-006d-4e60-ca01-08dc8c940363
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4223

On Thu, 13 Jun 2024 13:33:00 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.34 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.34-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.34-rc1-g8429fc3308da
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

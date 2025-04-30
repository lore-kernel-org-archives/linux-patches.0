Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF8E7405A
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 15:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025450; cv=fail; b=n60ygm+0xXkXi2hpdTwIsYdO7/GMWqdjKNH6cvUFD99NGxFma3w6wz3kNPeJo9I23z3HmWbOwIYjg7unY4UNfPJNLMt3TBQDBmRKVTqxYL7xnKmRbvhPPoS9hyX8VenlgUGYUAAY3JoDvliVUrFpOWrWdYLZGhmI5pmH57xEAVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025450; c=relaxed/simple;
	bh=5d3ipLPZ/Sl2R6KIftJiUG4HMzc8oHSIhVZDuCQv6hk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=ScUUcGhJKqSzm6KJH/kNckXKAxjBUiwa4sfXWPqT/6uIhdzChdVw0DQd9bOT+AG2klK/Ib71f4O10xk0GQ8nzzqU09xU+6DmjqOB5mLelgJmARWkimzYNZAvdSRLLr1lzrsOv0xTDOBqdtWGwVHplhsoQJ0DP7P4vvG4rjbnvFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bkWDlXMd; arc=fail smtp.client-ip=40.107.94.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bkWDlXMd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DDBrp33J0jiDX5B2/1Lq3JRZ5nbWfNQhmvG8vT11+WFdojAw/mEnrd2phqBvk0n+a0COs7J/TSJt+wcfqn5ezUTwpPO+i69Y9oMsg5OWf+6vxDY3XX3liV0NvzR1HZ4JnyphSiuZ48oVawnXZQedhvwy14MFPznPRHIe608O6Bc5fEjuj14PFaSHsgw5QGYt+E6y//A+3bysZuDWOA+iLt3kQpjQ7HlgA9IVb0SpK1lwQrC0yRIaJWtbxyErn8SCO4TiMMUo7s4OCL1I/vi/3jziyxWp0zzvusEChZZDB2nyKzfgF5KlOyd2mqEUxtlTnXWDmns1KoW0UEC7NrtMuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FWPHzZQ0UYqsuyZKqehkiaote8ZEPEjp0pkj7Iy8O08=;
 b=kE3yyYz+rzMGWalAN/KddRdwm6sTCHNiEvIhTbMEzAOZ8bukh+DVlar3AAggorTDcVgd+kqXhwMF3jKEsh/vxyYAID8Irg65FQ3B4Ej3jUOBPIhSrHFOPau/T8bysZW5R1FKfJn36A30SslSUGihAgNfGRsT1heFW0pL2v0zekUclt65fUfkhtISJdgey5RPnwW3V0ly8BgniwAK3TMC7LighJduUIYDcBbsdWRtQ3Hc9oxNFmNeDtUP1oZ+DSUfMqB29SPC7R4EtOsVhgInvQ4jwpJN5Qc7A4eG+OzBP3c1zAxFXDDZw+XVs4fun5Q9kvjkFbGdv8+YjSLcdQwNGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FWPHzZQ0UYqsuyZKqehkiaote8ZEPEjp0pkj7Iy8O08=;
 b=bkWDlXMd0GQowdfyuXu6BwrxwsbXAxiBBMa7IlIgJmsEjtH5R/aZ8V8T2u/4lCKmEcxlSMYOtb2L0MV6qEoWjJVcQ1SXZBXejwDNcUn6f7diFYNPe1XkeqlGxrDtX/JcD5Ul5mFKHosGplm3TLzU5wkh2KQXU1CVwWpvKL8T47MeEirprAKQ8bf07I3nb8OfI1TIStKu3EV4I3X4QQZR4lsEfYDGQPsQtkJ2QpTSkgB0lYfLGYsAnNPon2JhVIAJ+b+HQ1Lat0DsR0VnRLRnnVGEayMLqHZNHiDVTn1F/uFloeXfgSOKHMBYOS8qWfx5a6UJYWXA7cz3HEiRKifDDw==
Received: from MW4PR03CA0004.namprd03.prod.outlook.com (2603:10b6:303:8f::9)
 by DM4PR12MB5843.namprd12.prod.outlook.com (2603:10b6:8:66::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.21; Wed, 30 Apr
 2025 15:04:01 +0000
Received: from CY4PEPF0000EDD3.namprd03.prod.outlook.com
 (2603:10b6:303:8f:cafe::b0) by MW4PR03CA0004.outlook.office365.com
 (2603:10b6:303:8f::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.34 via Frontend Transport; Wed,
 30 Apr 2025 15:04:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EDD3.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.20 via Frontend Transport; Wed, 30 Apr 2025 15:04:01 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 30 Apr
 2025 08:03:44 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 30 Apr
 2025 08:03:44 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 30 Apr 2025 08:03:44 -0700
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
Subject: Re: [PATCH 5.10 000/286] 5.10.237-rc1 review
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <5c2e6883-040d-4d85-b89b-1bce28ba06c8@rnnvmail201.nvidia.com>
Date: Wed, 30 Apr 2025 08:03:44 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD3:EE_|DM4PR12MB5843:EE_
X-MS-Office365-Filtering-Correlation-Id: cb3e6025-d94c-42eb-d2e1-08dd87f83d99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ejBEOXFtSjJhWmE5OW8vUUxHaUwwQmNmMFRKRVhvRXkvUm9wajhXU3M0bDhq?=
 =?utf-8?B?c3pxb1VoUStDZmpIKzljaFJ6OWY0dTVGbmlyS3E0ZnBscXk1K3Zieko0amZ2?=
 =?utf-8?B?MWJtdUF2Y1JpcXZNUWRPMDNuWjkvK21NTmgvdW4vM21TQ1Z3YU51ME50SXI0?=
 =?utf-8?B?M2Q4MDNFVi92NFlsNjFiUmp6RTUyaThRTHlhS05QQk9QY1BUT0IzYXp1K2Zl?=
 =?utf-8?B?WW1qRjZiRDNBQ2YxaU5VRGJkRHFyRjFkRmxVaGJiR3BBTHc0VWRqaGxxWEZj?=
 =?utf-8?B?TjUzZ1lYWUdGR2ZmbzBsdExNSlNXV3duTWxVWGtnVEhSNUQ0QWs5SkNJQ3hr?=
 =?utf-8?B?dTBZcmY1UDRRZjVwZ3RDOFFvSDF3S3RJZzBVZWJXMm9yRWdqc1dhd3BaSWxF?=
 =?utf-8?B?N3k2cm05NkRvSisvYlpETUpQQnQxVFBtclY4SHdzSHc4OGpJbDNHSzQ4Snpr?=
 =?utf-8?B?K0ZlNTNWZW5DVUM4L1FYU0JkV2J3bFBkZ2lHTUpiRlhaOW1Va0craXF3ZUdZ?=
 =?utf-8?B?cGpvcEx3TzREMkE0M3RRLzhkUTduL0dmQVQrb2loVHRCbzdDUTQzV0NJNFVt?=
 =?utf-8?B?T0o0ZVNtN0FsWS82Z1NXYzJKMUlwQWVMR2VyaFBCUHF0bE14NkswaHFDOEZN?=
 =?utf-8?B?Q1FMNlE2aHE5bERFaDlzNHc5anVwY1J1M3RRNWFCcm9tcUF5MHp3bFJVSzRn?=
 =?utf-8?B?akNWUklidTBJNFB0U24xdnMxVXBNWFBQbHhZOVNDQm93QkxNdUZ3Ky9HZjN5?=
 =?utf-8?B?TC9Sci8wTE91UnErZ3NzU1RvUWMwdzJ1QkQwclpjdlBYbHZkdTB6RWpoeURt?=
 =?utf-8?B?UENjZXVQTFNvSFhJZXA0MWFESExobmcvN3RGdjYrdzl1SU5hWllPY083cFNv?=
 =?utf-8?B?czk0T1JVaG9ORm10WlJGUnIzRWFQTFZvNzFFNkJJV1poU2N6ZmYxaHRjN2RJ?=
 =?utf-8?B?YmU4YlFtUFRDV2lHQUxLRHVIS3Z3U0RHSXBoNWxPVFA4R2dIcnNoWDZBVVpw?=
 =?utf-8?B?bFRySWFlbTZmZmgxcmN1NUM2eENLQXc4aFV5anpHaDVablR6dWdRbkVqUVJl?=
 =?utf-8?B?U2o0cXd1ZjZIZGNRc0RtY29kcHUwMDFERFVpNjRzM2puMGJiaWxYcU1KcXdx?=
 =?utf-8?B?ZU5veTEvSmVpRlFMaXUya2Y0UW5oQ0RZd01Lc044TXpXa2JDYUwyM1M1VjZE?=
 =?utf-8?B?MDl5cG5tQUdWQWhZMjM5M2pPdm9tWUJoN1JKUVIzV3F4V2ZxZzhOU0FYUlBx?=
 =?utf-8?B?L1RaS1hFcHNsbmxHZy9LQWlrTXBVNW5HUGVBdXlCWncreWtQd25qb2RKMUN0?=
 =?utf-8?B?cGdNbHF5bEYvQ25iL3RGNzdFOVl4RlVjeTI3ak1uK1gvK3JKOUZmMUpYTTRs?=
 =?utf-8?B?NzduVFY2Q1cwQ1BYSXV4MFBYSnZTUGZ5NnA1UlM0KzJVVkVZeFNwVWVnNHZ3?=
 =?utf-8?B?U2FsVGxkNDQ5TjhhWW1zY1Q5TWlZMkRWOXBTbVZJK3lpOHVEMEx4VEF2Qllk?=
 =?utf-8?B?Y3lWUG5hU3p3WHd3RklTci9lK28yemEzZGJzSUhYWEdid1ZBbVVHZktoMmkx?=
 =?utf-8?B?UmxYM2F1SEozYXRGdTROM1JCd2piWVFUL0lxRkJtTkI3TVJSaTJCQW13TS9i?=
 =?utf-8?B?VVJqZjZ3QmpSYkRpWmpSOFBFWUpaYWR4RExGWk1ka2RObml4NmlFN3dkbWtw?=
 =?utf-8?B?MXlrV0ZGSlJGSFdqUmdOaVJuandWVEs1TTZJRnJZS1ZiU09MUHBwY2U1Kzhq?=
 =?utf-8?B?YkhMY3dNVEVRUnNFL3ZrOG9LSjBlRU5Xak9BL081Nnk2QkhVUXVTaHh1bGtU?=
 =?utf-8?B?NUcxeGNNUlNJcXZ1TldUSTBQR3dyK0piWVNqc0w4SXgwbEI5V1VDZUt3OU1i?=
 =?utf-8?B?MGR0Z3hDajVTUFhrSDVsYWtFVU5vbkVXVk5qVHg5cU1ybjE5eUlKby9DV3dE?=
 =?utf-8?B?bWs2TjN4TVQ4NlhSYnVOeTVIeE5qYnlQVTZYa3RqSzllb3RVZDRCOHpuMFA3?=
 =?utf-8?B?YTh2YTUrdkpjNWNCbC81UW0wcndqekFnT1dDOGMwR1Nka2c4STZEdTd2ZjBn?=
 =?utf-8?B?bWNDMVJiRHhtUWdTdHQrR0dtN2xaTGN6djR3Zz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2025 15:04:01.0409
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb3e6025-d94c-42eb-d2e1-08dd87f83d99
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD3.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5843

On Tue, 29 Apr 2025 18:38:24 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.237 release.
> There are 286 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.237-rc1.gz
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

Linux version:	5.10.237-rc1-gce0fd5a9f1a4
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

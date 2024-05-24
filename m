Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FE912E1DD
	for <patches@lists.linux.dev>; Fri, 24 May 2024 15:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564035; cv=fail; b=kGKb9loMi12bgexiRNf3OGT5hRjr54fgf6k60sB3cZKEaLaSGN+eEzAPvtKovE5EvETEL3v/3cu2bLtFZkA6ZXx+Qn0ZmGcf/NqjjHNmObW0lJku9OcYby0QP4cxg2jFT/H+o7VcaxylGQ/Tdj36PCJzpruBO8jCQbd3nxeXo2Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564035; c=relaxed/simple;
	bh=iAXDtPSz5P9EcBzECQ9rAvf313pU/cgC8+YQONn4KTU=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=EVLnO0DS+6BRGW4zGU5GTt7OWTn0IVToML7TjXTcsTFQnOSQ6y5d/AiNMxgOkHV6BA0A4x9RtRuXWbWInv3dgVTCSZ8CL391tfDZJkgv+48zBDY1Bm+x/BDsmM6X4MEQDrC7oJV4iHV0GlJXA1TRN0pbc92gDLknvR5iue64uIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UuDuvj/l; arc=fail smtp.client-ip=40.107.92.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UuDuvj/l"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AifHZW9yKdxFoRKTo9iJsB0EMNBY+J0bEA/5FNcoN2Pc6vRIgYZ+zODcvCglwRRqkKKPexXWtFPvhh7gZFNoKeG9Lck5yFlS1qHyWYwFEKegnuKdloOtA5xwlHV047GyKwzlik7BnAoPeDjYDIJPdDei/UReXhbAePy7E7kJUCnH7wfE3eXlbdtYPqr0WRTsQaWF/+dghY3bjkCgBLWgXsse5Rx6mTyVGFLpj8zlhtRK4GHf3crwwshgU6DbU8N/0b5uZZbW324fyqp63eOu0EuCRzOqJdHc/HVcOkS046r/rjl8UmTBV+rq0845csW2XgyZ4mXIKM6XFWN2VfnsKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F1JrZWh7WPKd7Uyyet/4cyQ0DKnMhc//7PmtVmA7D6w=;
 b=F6hW2CJhqcjrYUFUAEJls44NLVK9/GZ2jNhZ0ty2dEadjC23oHJmNLaNNPAdOQBC3CZZO2cW+njhNK2xHVsf4tvw1yJXraxYHRdE4Ep52/j2032D8cFqIeySUB3Zz5DJw5HP3dx9LnLaugOiJD98Sm/5KSUynNhTCrztSxbDfRol1JVtGVipyHJZi6TXvTFKsWSIn1syNpQKRVOfcHUo7VeXPux1oVrqX94yVVlzQR+wSAOp6K5n3SeKMnPKEIojPVfTVt6B98W/t4RjXwN3cwJcywPZ7/uIg/cWRbsat3Vnf9hTUNCylH3o2MUINNy4cPWHibzX1OlSoTPbr3xE6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F1JrZWh7WPKd7Uyyet/4cyQ0DKnMhc//7PmtVmA7D6w=;
 b=UuDuvj/l89n/vRtWtG699W9joiX0hQ4xyOgQdJsWfHKy2XfQEY0ieO2qjjyGAdJfYOa9z6hBhdICojR+FYxE7K25edzC0vL41E6uy8KSd0o2RSzNu+763M+qzaGJfsByXa4xw+X8gIVz3Pl+WaTDjM38AN+xJwvviEnmpRFx2Y14W/D+1ELD6tSgorztWBHx7ayHr7RPd2ehfSfA0hVGlY/nVk47JrZZgNtdSSpATbgipB2B3sDAy8fF10hT/NkpKuLYrfMsnTIR+tJssuDxAJDG1rabKln/ruHp9NECBiA68e0tRt4ySWzVZGLraMLfAviYeITTQUBAzDmhvRiksA==
Received: from PH8PR21CA0015.namprd21.prod.outlook.com (2603:10b6:510:2ce::12)
 by MN0PR12MB6344.namprd12.prod.outlook.com (2603:10b6:208:3d3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Fri, 24 May
 2024 15:20:28 +0000
Received: from SN1PEPF00036F3E.namprd05.prod.outlook.com
 (2603:10b6:510:2ce:cafe::a7) by PH8PR21CA0015.outlook.office365.com
 (2603:10b6:510:2ce::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.9 via Frontend
 Transport; Fri, 24 May 2024 15:20:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF00036F3E.mail.protection.outlook.com (10.167.248.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.14 via Frontend Transport; Fri, 24 May 2024 15:20:27 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 24 May
 2024 08:20:15 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 24 May
 2024 08:20:15 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 24 May 2024 08:20:15 -0700
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
Subject: Re: [PATCH 6.9 00/25] 6.9.2-rc1 review
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
References: <20240523130330.386580714@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ef1716ff-abc5-4d30-ae70-fa4f97997e84@rnnvmail202.nvidia.com>
Date: Fri, 24 May 2024 08:20:15 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3E:EE_|MN0PR12MB6344:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c53549a-ae72-4402-a50f-08dc7c050ad5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|1800799015|7416005|376005|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dFpGN3JRWTg5NUNYM1YvVit2SjJKbUVCSmpkdFhIWGNTQmkwNTFDMG8xNU9B?=
 =?utf-8?B?b3JiVWtOaDFVM0ZxdjBMTkVvOTZMaFpCdUUzdlRwUTdGRVFFd0xNeXZ5RmZU?=
 =?utf-8?B?RTQycDFKTmV6blNST1pjR2FmK3hnKytDQlhsUFpmU3pjYmFvWlYydjlhOHEx?=
 =?utf-8?B?V2hJbXpuU3Z4bmNXR2o0WENrb2xERFdIeTZHQ2trOVNPNHVPd3ZraVNtek1F?=
 =?utf-8?B?ZHNXbnZ1RUsxTFNQQ1o4VU1ld0E3aC95cktsdy9BTnFmNnYrQjMycEVKWjhs?=
 =?utf-8?B?T3NIRHpSV2Q4d2ViOXlsWk1icWROTXRneHliMmxjZmFyV3R5TVNXdUVIbVNC?=
 =?utf-8?B?ak5LeHRBRGVtQzR0RngzbzlqSEdpcE1ZdExzVHowREtXM1BrMnFQaVhCQjRP?=
 =?utf-8?B?Sml6MXVDbWJJMDhFRitSK3hSblJUbmx3UWt4bFlTWGZobGs2YWw5OGxNZzRJ?=
 =?utf-8?B?bFhHNzZ6WUswTUxWcEt4VW5BUWc2WWZhRlQ5dWw2YUVFU3B1K0dBWlcvbjNY?=
 =?utf-8?B?elpwTlljclhuSm05ZFovNXhYNGNSVDRlMkIyTitPbDk0V1hYWmJ5akl1KzNE?=
 =?utf-8?B?cXJKWkhyN2RlUkM1YXBzU3dmbVRSRThkMGtYWVNnczFNVTB0RWRGOEVzT1JX?=
 =?utf-8?B?SUd3WWp1UHQyVHRuTWFuSUorclhldXJWam81aDJKSnpmRXdDY2xkRXhsSVNZ?=
 =?utf-8?B?WDltc24yRmNWN1AwVDJnUVRHRFJPVGJGS2phekNzdjJnaGI5dGg2U3REZ2l0?=
 =?utf-8?B?TjdaMFFuY0lZNTllMjhleVVSSkttaExabGNKOGNVTjBLaE5BeUIwdzUvOFd3?=
 =?utf-8?B?SnVhOGUrK1lpWXhZNlZNVXJIVnVzR1V1TlhPdkRRQzRIbWp0b0IxcVQxNHRI?=
 =?utf-8?B?ZzJvV0tmMDZYc0RzVGhLbld0ZmZVY1JTU0U3NzVuYVNqQWhyUkFvRllqa3VV?=
 =?utf-8?B?SldFNGdReko3Yzc2Zk5KWmdXc1JkNHFGN0xCdGs0WXRvZmR3MUU1Vzg4dmdw?=
 =?utf-8?B?UGlpaHY0bTBMdXp0OXpnTWNtZkZ5YXZHblZFU3dFTnRSdXppdDZpSlV0RHAr?=
 =?utf-8?B?SDBkK1RmTFowT2V1UTZ1MzJUNC9VZmFPZEdJbnBvTUNZbGw5YmM4dm5kVTlY?=
 =?utf-8?B?aUY1Y0d3ZU4xOG5ucWtZOTUrQVh1UEg4amRJSHpYT1R6aCtzUmZmSGlFeklj?=
 =?utf-8?B?QVA1T01VYmUwL1k3RTY3Wm5jNjh3TUJwR25HR1dDOTZOYTdra1dTSTUyanZm?=
 =?utf-8?B?OFgwL3grK0VEODh3UkZRSnFDOEhLYWsrai9kcDVyQ3BMUnZ5a0tvY0VQbDQw?=
 =?utf-8?B?eWgwU3JsR2J1VlFudEkvR3NQYTJ4VWRqWnRNaldaUm9nZmg2cXpLNHFNeGZq?=
 =?utf-8?B?SDZoV2VHRk5GbzBIdTBlVTFHUDRlekRWV2ZXWWRNK2dvWlgvZDlScEt1MWVI?=
 =?utf-8?B?ZVZHR0g2aUFyR3Vhd09wQXMrY1F1ZzVFSW1IYUFWdlFLWk1adzVOTHVFOVRh?=
 =?utf-8?B?U2Fuc2ZFN3V6b3MyN0RnQkx5UjdQMkZWY2psd1daZ2tUb3VzREQrSXY3VHR5?=
 =?utf-8?B?Slp2UG50L1R0VHAzWkVscEhQczdHYzhPWlg5Q0NWV0pCeC9SeGZVRXhCdVor?=
 =?utf-8?B?dnZDL29ocFYwL3h5TUNJMmd2bDVGZ3kwRkpOSHZqSW9wZHlTOERVdkd1QVdE?=
 =?utf-8?B?dlpZT0ZLWWVWMGhSYW1kZUZEVnhhd0tTV2psUEpzUHVpSzVjampSallmdUlU?=
 =?utf-8?B?UHVjNkFINFA5T3Q0bDJLSFFxeHJoNFNuSHNYbDI4L1Mza1NZWkM0V2V1bXFF?=
 =?utf-8?B?Q2NOV1h0UlBBQkltVkI2Z0FWRjFMN1h2WkR4U0J3YWNtbGJKQmV4ejN2Q29h?=
 =?utf-8?Q?VAlzPriUlkuLs?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(1800799015)(7416005)(376005)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 15:20:27.6659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c53549a-ae72-4402-a50f-08dc7c050ad5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6344

On Thu, 23 May 2024 15:12:45 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.2 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.9:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.9.2-rc1-g6a8a28e45f4b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D912836A0
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 12:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744286908; cv=fail; b=DncRdu4RPTPZIYtHdOI2dHMOltkt9MYJbXh+rMaRF29XhtQ669VC8kIJlIErfcC2i6Plz0gV0G7Tb/U3Ri4RJOf/tzPNHRwaTqD68pqJFS0TxcbhKs+eqm66mmvmHZccQoFCaPFgkwI1FifW9n85nGUeOkoHpQutKeMVUR15HiM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744286908; c=relaxed/simple;
	bh=Tnb7u5j+ABfHPM6kXUK1Y4KcGKZkNmzGItR033FHzl8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=gg29eIceB3MtJlDBMFL2TB/rFrGvNa45+I+lgMaNj6LhebJGWR1/HFVbGO56uqYBC3+GVQaqvFXjnjZFx3PXHUaE7f1frhSw+7/Y4hsJDuthm6KANPttX88px9jeJsedYr+8eX6gBGPEJ3XUdsicWNgvu+XL6wcO4sezAXsyhN0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LnFKT8Bf; arc=fail smtp.client-ip=40.107.92.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LnFKT8Bf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pGdEubEKS28QI2e8YQ6Lr8hOqa8ONjzDi8+pAp2b/4qJLYlpORj9CxmPOMNxqdgw+7WQcCqHfIjR1ysDu0f1RMs/SCdjo/by4EVW31foXieTNoKkr/GJ1s5nkLKaKXowlQJUMsRtuNuq0BK7PkWHi8gaRu2LO42zXSy+O3ySauw/AvmU/9peWvdt9+LTwdAPKg5geZNLOmpLgJ1zmu3wK9b/ppgSHskuqW/Gvmtb6ESPPuugyuLj5FRFkfqHsaWda9cc9MIxA8P3y2CNo73SpJ8dCEswtKVxuHRawUVgX8XyUPNhC+5GtiCTg2hjDgEVpiCp9ywzEGI9UPmV0gMStQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r8td9YRpM9EFyKguQaO+1GmGB454hq34kf/D0wCS4cg=;
 b=td2WwA0StxAbaHLuEYTSLmQ4hFhs5LY5r6iNR9h7PKiLt69D9HMvy9l/CG8iS04PEGbCkxP4r8M9c8OIvl439K2ZdSHCBPfxmDrYNjHX7BUz3o9fy77xJhSUwWpp7BDlR7eOF85PNxBD8BORIfrHDOiVxBS1Ik4y6Cduzop2cjsQtvdS3MYWtY08ykrSO3NYovYO7swPtPZVebJYoPZK6CE/DTzeC+BWDFSHSgiKzvBNsJYBZx1+VJWG9oqCagAbMmVq2XT1QozcJydL9+RrAtq/NDCQVzW7uryTStUFeY8YSnhu6ATFRJOfpNDBvpAVr9Wuw8j9O1wZXGGsBFD+eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r8td9YRpM9EFyKguQaO+1GmGB454hq34kf/D0wCS4cg=;
 b=LnFKT8Bfen53KjXul2It/9IpPBl2XuGXgmXqTBV0wBkRYQOy2wICm93My8CDNksM7noMKANl5keHtMInC9cqx3gX7EhS2xFNUFcvQJiolU7fJinN6uYIXvpS7RCBSDwD4kn98LMGYwbqdjiLioJmLqHrM7ml8+f/BaihDNVH0IeKS7ea0M6NQkVRPdMyTCAR5N5uit03y5A5SD7mSB4oVU6fewwqc00SRACGwzs+yGNrEO2D+fTdTpT0fgObTnrJjguSCrQeiF39hj5kZMJdDHvnIavP6WjhrF/vZHs5by6BifZ9yogLey6UBU4LEdJ+GlMFJs1OZHLsGzk4Xbu0iw==
Received: from SJ0PR03CA0382.namprd03.prod.outlook.com (2603:10b6:a03:3a1::27)
 by SJ0PR12MB6968.namprd12.prod.outlook.com (2603:10b6:a03:47b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.29; Thu, 10 Apr
 2025 12:08:20 +0000
Received: from MWH0EPF000971E8.namprd02.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::53) by SJ0PR03CA0382.outlook.office365.com
 (2603:10b6:a03:3a1::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.24 via Frontend Transport; Thu,
 10 Apr 2025 12:08:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MWH0EPF000971E8.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.13 via Frontend Transport; Thu, 10 Apr 2025 12:08:20 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 10 Apr
 2025 05:08:10 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 10 Apr 2025 05:08:09 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 10 Apr 2025 05:08:09 -0700
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
Subject: Re: [PATCH 6.1 000/205] 6.1.134-rc2 review
In-Reply-To: <20250409115832.610030955@linuxfoundation.org>
References: <20250409115832.610030955@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e065298a-dc12-4fd4-b43f-ec1ae1642e96@drhqmail203.nvidia.com>
Date: Thu, 10 Apr 2025 05:08:09 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E8:EE_|SJ0PR12MB6968:EE_
X-MS-Office365-Filtering-Correlation-Id: 61606316-fac2-4d5a-5016-08dd78286262
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SXZZVWFTZkd4Q2l1L1FOeUVFZEZZZm92QW1Jck40SEtuSlNISEh5VDJlYWhx?=
 =?utf-8?B?ZEJCZ21qdDlxaURLVDdiQzQrb0F1MllMYWdkdU5yZWptcXNueFkrK0hyZ1Jp?=
 =?utf-8?B?OXdxZ0h5OSt4ZHYzeUdaS3E0elNKdmdSRFkvM3ljSjc3M2lpNDF2MEZGYjhK?=
 =?utf-8?B?OTZSM2tUbUpCTVFXN2c5T25MZHZxczFGVzZER1hrcVkvZDJNdG9qaGtLaVBZ?=
 =?utf-8?B?R2liSStDemhLNVU3bWpkL1NsM1NGZWlzZTBlWjNGSTlTYjNqb0dTbFVnSEMv?=
 =?utf-8?B?ZjRoNjVBbDlKK21na1NVZ2J1dkVhTEJGK0M3bG9SYm5HaHRMNVJYT0hWcGhR?=
 =?utf-8?B?aEVvaVZEVHNYV0VXbElTaHpsdXo3anJVcWhSNWNmR0FLSU1tKzY5MHdGVjZz?=
 =?utf-8?B?czhUOTVXUFBjaGxvclJCOHB1UGJ5NmZFdllTb1dJRk1XTXU2dldxUHRqY0xo?=
 =?utf-8?B?ZTVWS21JeDYzeW1hVXlwS3R5V01ZTDVLYU9mRisyd1JCc3lPRXcwY0VFRFpp?=
 =?utf-8?B?d3FFTkYxVzNWSng4NlFPRWhEMkFoZS82V1EyN0Nmb0EyV3dBZWhNejJJdDJW?=
 =?utf-8?B?WnpEaW1mcUlZR3dteC96NkJOMXVmNktPU08vYUhacmNQY2V3Snk1WmdEWUo5?=
 =?utf-8?B?SmZJbGF1VWFGY3d0ZEhNTjFKTUp5TmFmSzBXaTdTQW5BcVJIR0VMbHNPZEZt?=
 =?utf-8?B?Mmx6ZWkvSGtEaFFQdFAzVjNXazJWZTBUT3Q0Y0Q3R2J1NS9KeStMazhCUFlV?=
 =?utf-8?B?SHhoYVQxMUh6L2ViR2llaENPVGdsb0FSOERDZ3JzUG14cnZkaTVPWmxuNzV3?=
 =?utf-8?B?WEJ0UXN0MXoyRFllRnFLMWZzTmE3dFZ4YVN4dVlPRUQvUk5qeWFURERHVG1F?=
 =?utf-8?B?dENyUGI3UlNacEl4S1NjUzlkcFhtRjJzdzJHQmNrcUdrd2hIWHUyd0E2K1Z6?=
 =?utf-8?B?TlJxTmQzMzl3Y2lZVWxsZ25YUVFSUDR4Q051WWplSHpSNU9IOGwxbXhwNlBr?=
 =?utf-8?B?MHVyQ04wVkVYYXdLTnFXV3p0Y1VORnZkV3IyNWxMaGFlRUl5eVkvK1JHQTc2?=
 =?utf-8?B?eEdXbFJvblVHWXhPbHkxMGgrWHd4MHQ3cmlxRHJzY2VxWEJNcVpoZVJSNTlU?=
 =?utf-8?B?cVRlOTluY2lLUWtWNHdhVnJ3UGtCdnJEMzBuUlVDQnNER0FYUDBRZkxheklZ?=
 =?utf-8?B?WEpreEYyMk9aSTRKMk9PWnE0NGJIbk8vRXdEdlVhZGE4ODQzL1J3OW02L2s1?=
 =?utf-8?B?Sng5Y0ozcDZpNG05eGlWTHJVUDFuL1FNZHFkZndWeklTcGtWK05mMjd4bUE3?=
 =?utf-8?B?MFh2NVFhcVRuWFJxNlNneFpyVHNUNXA0QjZWUVR0WWtVYzhWdTUwbXJSaEFw?=
 =?utf-8?B?RkU3dWtvMEtkSzN1WEZUcFh6ZHhCZmNPWnVrYW1Md2MwUXNTM0dZTk1EUFVX?=
 =?utf-8?B?QUl2djRFNVZhYlhuZ1Z5Ujl5Yk9sZVpHd212NDJuckgwVGhoMldidk1PcTRa?=
 =?utf-8?B?VUo3bnRiU3dnUjRQc2ZsYm9pdURQL2FGbkJTZHVUSWVNUGFEamVmeXgvejBQ?=
 =?utf-8?B?dFJPMmo4UFVaZmduR0tBd3oyaURrUnZacVVvYlowUWxDMm91dUE1SWhwaE1r?=
 =?utf-8?B?NlNabnlqUUFFMkx2enNERnkwRno2VjgrSDhjWEN4Q3F2VkN4VzFFWlpVQkxM?=
 =?utf-8?B?YmZ2NXliVGtodHNRSGhvWDRENGFOeGpnRGdOQ3BZSWM3eWMxdU83cUc5bmRC?=
 =?utf-8?B?TVR4azBPTzlZVzBNbHphTjZjcmJSWjlCVFRtZUpBc0lFemtXcWNRc0NiVFFz?=
 =?utf-8?B?Z2NjL0lydEd1OE1yZk13UTNOZmlCdTlOd0FmelJveU10L0FHRHd5cTdqc3lV?=
 =?utf-8?B?RnF1K2FCVUV4MUV1MW9Eb0pMK1RkWjRjMk1oYlpiS2YxTlMwQzRORzJ3TkZS?=
 =?utf-8?B?b2UycDZDdXllanREK0hEbWVwdXpabnpuckFjSEhYT1JTOWg2cTB3alp1c2VD?=
 =?utf-8?B?L05EcTAva1R4MHlhbGhVZmpCNmJUT1FJN0p5azdJZ1lTaVQwRE9BUUIralY4?=
 =?utf-8?B?amVtM2FZYU5wS09icjFDbmpZYzNlc01sRkg2QT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 12:08:20.0644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 61606316-fac2-4d5a-5016-08dd78286262
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6968

On Wed, 09 Apr 2025 14:02:32 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.134 release.
> There are 205 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Apr 2025 11:58:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.134-rc2.gz
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
    28 boots:	28 pass, 0 fail
    115 tests:	115 pass, 0 fail

Linux version:	6.1.134-rc2-gb0bb7355f83e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

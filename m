Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30A825A62D
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 15:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746025493; cv=fail; b=GAV6/r7VVa5xoPkkCcXNlzsfOKM7LZx9+YpQePjadYUoi7Y7p3lWvFV5EuIpkafPENB8Vew+1HWMa2ZA9BtcsSkOrSn21aqmHZ/EegRdYZN8iF31Nhp3tYNUj3edlCOtRfSmG2ZRT6jVDxD2ACKUvaT9omf7RbbgBPSWH55IEmQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746025493; c=relaxed/simple;
	bh=+aJQixf9eEZfL/rGr7adeCHyyt1r9ixBO0e7iI/KOd8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Y55X0d49DwDtHbmJnuPLGBT0yAZiC01IoAjt3Ogv18hj2s0jp9lmghNxi+GQBfN7fMANxVgxxxrheBuwuTOCXS35HOe4+tBu0e8EcvZZJWZ6o1hm+Myq2VERn8m3HvxyYFHRtvZcgptGPXogN3OWln/6Woa3s3ZEqezEA7l4m7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KEn8Kyhm; arc=fail smtp.client-ip=40.107.223.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KEn8Kyhm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qrobVOi7wqVJYlDUIyErvrddmHzBtId+qgtP0MEEu+m2riKHLYe7SukD82dxnuy85D/P/Or1wekQDnzSS0uA75WwREzrgtPJWaOpiNITdex3s6Xb9NurnB6r95/omGMx5KTEVSU/xwEDjSg+a5CDOo3qRtcvIC8r8mSukFkBtuSGe058PU7A3oO6znSYT+N5jpyRI9/ODDc296eP9MOWDC68OGJs2nrqRJaNup/4gx8EJ4HptvrQWc1ZlYEJlO00Uk2SXMDUb+Sz9KxX07lnnPkr4uIJzxWFMox8lbXXLA2BtWTb2EA7+Z30a0JEIHw4fr6J3lvgeIFv/buh88XVOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Td8ux853PdojnRRhngflkl4t8B5WW+/rk29Ry/zfDLI=;
 b=Dxr++8z/qzyadSI/E9E+jVq6rpVsNyEXe7XFMbl0yfdLaN7pImpgxGekkf+JA12LJ9pmVjDn1RcOH/LRfZHVia/MeUJX5JuGYcWRUgCJvclVGv/EMRP+G+VT/W+I8n82BmHMtvu/2kxQBmErjUuGyYl2n8r3q2UeJAn2SyZRoRzyJiKms/1LBPmZLpdlaYb9sozZrCh89POMeaXMeBPHk9l+k5fwXxHukSI2LSWJyKHywyXKz6rHhfpf8lEWyVbzgfDIiGk+WZhBEcdeY0W84n6QvY4Y9f3U5WZ2ARD1bNhHgolSjF8H/3BJ5wVWFTDPmLSZWIrZu4fjD8j1pz+1TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Td8ux853PdojnRRhngflkl4t8B5WW+/rk29Ry/zfDLI=;
 b=KEn8KyhmYrgSbDC2yqEIMHfmxqxmBS67B5f6Y1Tico4eC5wCK0zG2xa03IyfuK3TlmeZX8rWnIZImp5Jn2+g6gMWTWkI4dwkloxNcWkBPCMKZR5QXzHUWgyUgDqtR6TA40qj4x5MEWQTenb4L3cPVFHja2A/occwi9ZYRScjb/GaXM71vhbd54FE4F9S0pvw6zZfJnDPvthg+DP+020mPO4gbyJLX2NpFnub7qwsivD2oQzB96KNfkA+ixGWbDf8wMcI075Ao9o0Xx8SLQZrkRpZSwz3eOMPxnfSx8QHMJ7ltDRnoHN/nbLc5J0RzA/exkFCQxp4T51AfiS3Wi1oXw==
Received: from SJ0PR05CA0157.namprd05.prod.outlook.com (2603:10b6:a03:339::12)
 by BN7PPF8FCE094C0.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.34; Wed, 30 Apr
 2025 15:04:48 +0000
Received: from CY4PEPF0000EDD2.namprd03.prod.outlook.com
 (2603:10b6:a03:339:cafe::7e) by SJ0PR05CA0157.outlook.office365.com
 (2603:10b6:a03:339::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.12 via Frontend Transport; Wed,
 30 Apr 2025 15:04:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EDD2.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.20 via Frontend Transport; Wed, 30 Apr 2025 15:04:48 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 30 Apr
 2025 08:04:31 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 30 Apr
 2025 08:04:31 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 30 Apr 2025 08:04:30 -0700
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
Subject: Re: [PATCH 6.14 000/311] 6.14.5-rc1 review
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <41070aa2-09af-445b-993d-a9a9c1c45418@rnnvmail202.nvidia.com>
Date: Wed, 30 Apr 2025 08:04:30 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD2:EE_|BN7PPF8FCE094C0:EE_
X-MS-Office365-Filtering-Correlation-Id: a78aa9af-7d38-4f45-fbd5-08dd87f859c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MzBSYmFLdEJrU25PdUlsMVp6UFN2L1hyNkNJR3creExNalJobXhaa1J0U0xB?=
 =?utf-8?B?bGZTME43V25YQWhZL0dyTzJvU2tCbkxvN3A1NXpnc3B1MGZhL2JBN01hSXp6?=
 =?utf-8?B?YWVMVTRpdmtEUVhQYlEvVisvOVVjZDFHWGlSd2l5MWl6NU9LOFRSUEJtaHl5?=
 =?utf-8?B?dXE3VGYzOU9uRzlZdlBoTmU0NzBNdFVMZlJwTEdwZnliTGdkMlRLL1pJd3Y0?=
 =?utf-8?B?NTY4OVJYblVBT1U1OWIySFJpOU5RU2QzcUFKa0FPQjVRVy9PMk5KVVNIVllk?=
 =?utf-8?B?b2xhNkdxYUZnRGFlZzE0aW5FOEJBS2NMYXJ4TGlnTHlvakx5bE1iU1kyVFUy?=
 =?utf-8?B?SWNTWlZlN05QUjFCTm9BMWZVSUVBaWVRVlZGeVRlN3NLTmIrd09KSWJIVUQx?=
 =?utf-8?B?SzBlWnNvdTFNWStjT1FNQ3pnVmx1U0RDT0R1ZzhuOGNlbEUrQVVYUWhNbUll?=
 =?utf-8?B?cU9YSTVCSU14cXBLaW5kSmtXYmxDUmZtWmVqb2MxbDBLQm9zdXZCbXRHVk1q?=
 =?utf-8?B?TzJYYW5xRWtsNEI4VkZCSWhIZ2x1aEN4K24raU52TGdJQjlJNHd3ZE1XbWhJ?=
 =?utf-8?B?YmdtMUxGY3U2NzF1MmxBOTF3Y3pSMGw0bVVJa1pjY2o3NEQ1ZmFWeWwxVnRq?=
 =?utf-8?B?YUVuNnlDZWtTRXFJVWE4RVQvYXFEb0xBS3V3eWEzanM0cE13REJyZ1RIRjRn?=
 =?utf-8?B?b285SVV5ZWRpYUp2dXVwY2kwd0g0UWhDTnlMeGZSMEVIcXRKL0F4UFdUM0Jj?=
 =?utf-8?B?UW05cGVyb1FheEppSTVsOHg1OUd1Zzk3R2NtRjJlWU1MWHFKdzNrbEJBUFBX?=
 =?utf-8?B?T2k5M0lrWUZ6cDBtNXpGU1VrWTA1c210RlNhYmZKM0RLbGFaTndtQmhOZ2dt?=
 =?utf-8?B?WjdTeHZsVUdxODJmTzYyVG9tZ1pKTGYvU2RraEdGMEpJWWxDbVpXSHExYjBN?=
 =?utf-8?B?Qnhrazk1Q1dZM1hsNm5KNFMrZVlsZXJOWGtvZ3I0MTNuVHpLRUN1R2tObUhT?=
 =?utf-8?B?Zjg5a01CYk5ZaFVvMk85UE1sVk9HblpDbkZvdWthNURiZGd3eFBiY3RBZ1RE?=
 =?utf-8?B?Nk0wZ1QwWGFZeUl1THI3OVQ4SkhwbnlnWGZ2YjcrK0U0TFJCTTE5WkVXNFlE?=
 =?utf-8?B?MUg2YXdLQkxZUkhZWmpRSEtkcmFCZFRzVkdGZFYweU5BN0JTMkV4R2tsVUNU?=
 =?utf-8?B?cmxuc0ovYU1RN2llbzVGdW9yWHF0KzRxVWd2M1ZxZXNtcVFXOHFIQi8rckYx?=
 =?utf-8?B?TzVxTUhGMk55NUxZTkIyZEdyYnpmRDcycW1lUE56bU85aXRaL3UxT3lKcmdw?=
 =?utf-8?B?eXlyY0YxN1JXNVZnSkIvZExiZjJjVFJ0RS9kS2ZtZDgxYkxBM2E0WGcwUHFU?=
 =?utf-8?B?REN2cVI3OVhmSFJiaFREbjhJOWFjNlQ1N2dKOGcxM1RsRFpVa0o0eExhQkxE?=
 =?utf-8?B?LzIzVWVXMDFKLzVQVUNaUkhUUVJMNjFZcHpIMEpLQ0g0d1F6SHpZeXZ5am9y?=
 =?utf-8?B?dGNack1IZGtZRFdpOWdFQXlXUGFTRVh2TG94ZGprRWtOcFFidXE4QTcybVkr?=
 =?utf-8?B?Nko4WHBVbjhxOGpNMnBvWlI5bENjRUxveUU3VFFicmd4MzkyWGNVNzJvc2cr?=
 =?utf-8?B?L0lFNHlpeVplcmtvT3VBQ0xUamxSSFk1Ym9qNTZiT05WMnlEUXAvZnFnNk9y?=
 =?utf-8?B?ZjQ1aDJUQmhZRVc3Vkx6b2U2cXhXUytzdDZXRDRNMHJvb1g3ZkZPZEYwa3ps?=
 =?utf-8?B?cWhuc3pOU0tRNlZxSTc4dGxPc21ad2M0WnQ4N3A0bG1nOVd3Y2hWclp5Qytu?=
 =?utf-8?B?Vjg2Q29zOGJWMnd1UzZqdTYvakFMQ0pRSDR5UzFmNXM2VG1KcVVreDRXdk5V?=
 =?utf-8?B?WkFGZElOSGpxa212VWhNOWNneC84U3E5dFRDb3h4SkdTL1JpM0RIN2VnWmxx?=
 =?utf-8?B?eWMraXVmcnkwK3BHa25hcmtzZ0tvdmxzVGRtWmI1TXNSYzZxOW42dWIxQm81?=
 =?utf-8?B?MjZrY051Q1E4Y3Qrc00xMlBReitteUNHdlhYVEovdWFockt6bXVMV0QrRDUv?=
 =?utf-8?B?USs2NDd1Sm53T3JxUWs4RkJienRjVjFXSk5nUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2025 15:04:48.2825
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a78aa9af-7d38-4f45-fbd5-08dd87f859c2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF8FCE094C0

On Tue, 29 Apr 2025 18:37:17 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.5 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.14:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.14.5-rc1-g25b40e24731f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

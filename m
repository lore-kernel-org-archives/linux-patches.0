Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2041.outbound.protection.outlook.com [40.107.100.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C5D1C9DEE
	for <patches@lists.linux.dev>; Tue, 22 Oct 2024 17:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729619831; cv=fail; b=bfiRS1/HeIlhfHdBdUkn7PkyiGAkkx7fb+aaGEkga4c6BHPbLX4XkExFMkxhomhH9pxNaeXXcxYtxorD01+X94Bx+u9guQZUo/vxSO2+tBgbrPH3SEhm3kY0Q7hHYhTIkmdJG3yay865K+Mlzby0Gd9mXPTz9x2muD9v4e/8dhw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729619831; c=relaxed/simple;
	bh=NgPYowTeovADvJg6Mix678sFpOKhyqZ/L7ZUblxdJF4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=bru9Z9/Vl5dotTvgSf8RbymNzVFDOHytg6uTL+BRRmkic23h0dzLhC3ujXHq4GrZEaZnn9c5nqRKsGdhtieeAyW22st8nhcKOgnXmfxevVfY6NynUQJXuMInmvM0t1slMp+XTbjA/KmcL4JwfRYnbvvCk2p8wXaRRO9j5KXK/Aw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HTrf4Sic; arc=fail smtp.client-ip=40.107.100.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HTrf4Sic"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=brb5YOGy5GSb5TXG4JCR1f0nPZIs1Aw5U4hTrnwZojWEL2Ffee6SVgPEFUty6fxHxqCA85jjJksXkdfNMtkXghfF+LGDewpU4hoEyRqumG0dOFcKe9o2GAkLr9A4jL7EE/+qXlAB9TY6WAFy3DYenXZY+0ZLKj2kO/MS/XXJLImiA4I4id5oA9EiAveB7qpctWXaH50SQG2sgM8vZzFh30ZNgtxdDj37s2vzfaCz8/7oVnMrLttmeSXjH2DIbY0stkY5FZt/b5CvseaOLU8EW6sJV25UMCqkzlykT/Jl1UX64GjAqIiRr7+qeXMtJunUJpROrAn25U1/lWY4zj/Clw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=olHEi507cUo5yGdM8TLsh0RuUSk2yAQIOf9Zns7k5Jg=;
 b=te6fgTSuVwKcml/NKNa9wdFTpFc3dR57szytWw6i8YVX1sVc3v/jaLkBV8S3CxKmyb3zpSSEivpx7EHhlOSzYKtmrgtIb0/D2HWzHf2fL8Bm1cfa6eO3rp/Lu6tlrCran4LYVQdhT+2dIp+3hU8JxAkDMiLqUXhn991xfdiFr6SO3J+iNphSMyZQzBPTvBGL5GbJRk/rSAgDG/Do/Yn/tHrFNxUuIfTxPmTS8skqCyBHZGj6XYLqa10xORcEAavTpo67sHQ9m8zCSdgYhAjwmCsEXIxH31GoKYz3Qhln1c9dpcZoOaVXoH5rFYb7aO2IWxc5RUZcV7EwHngW0PzVOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olHEi507cUo5yGdM8TLsh0RuUSk2yAQIOf9Zns7k5Jg=;
 b=HTrf4SicuNwz52jLq5lcfmDPBmoiJV5eHaMcb+F0gLztt6ZNu5J9nIwD2UDUsYw8TMWO2Glwvt1tZW5LaufprOQp3r20vCQmhGsAfbLWqFroTtQPnwU3dZPEc+ZbtKlKiVnE8aJB0hA0llJn7uZSugU0oZMjawxr72B3Li1DCap1bc2wrO2UegZXCTcyNGimgB7/CGdSbY3z43OQYUhFBnf1Fj+qEo/7j61LoYfqEUWmSfcxlF+l3eQJfH5500DuDPzFkCiC4kuoBbkj//EPA0m4MchvBkrmI51Qi+gcmE/b8gIHv9JbACrVgDFwQ6ACU8U5Zt4n9ECZwMGrY0XTtw==
Received: from CH0PR13CA0043.namprd13.prod.outlook.com (2603:10b6:610:b2::18)
 by SA1PR12MB8857.namprd12.prod.outlook.com (2603:10b6:806:38d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.21; Tue, 22 Oct
 2024 17:57:03 +0000
Received: from CH3PEPF00000011.namprd21.prod.outlook.com
 (2603:10b6:610:b2:cafe::7b) by CH0PR13CA0043.outlook.office365.com
 (2603:10b6:610:b2::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.16 via Frontend
 Transport; Tue, 22 Oct 2024 17:57:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH3PEPF00000011.mail.protection.outlook.com (10.167.244.116) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8114.2 via Frontend Transport; Tue, 22 Oct 2024 17:57:02 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 22 Oct
 2024 10:56:48 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 22 Oct 2024 10:56:47 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 22 Oct 2024 10:56:47 -0700
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
Subject: Re: [PATCH 6.6 000/124] 6.6.58-rc1 review
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <36e28c13-d9eb-4c48-82b5-55138805d29e@drhqmail203.nvidia.com>
Date: Tue, 22 Oct 2024 10:56:47 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000011:EE_|SA1PR12MB8857:EE_
X-MS-Office365-Filtering-Correlation-Id: 3544e7f2-0aee-434b-1cd9-08dcf2c2eefd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MmNsNUQ2NnpXajZBL0RJdE1JRTRvUjdjMmUwRlllU0l1UnBIYzNZbnZVTlZ1?=
 =?utf-8?B?cVltTlFrN2Rac0hoZTJBNXNuQ0lUOUQxMWJQRWQvd3VYdjNzS1E1ejJMTGEz?=
 =?utf-8?B?dEE4Nk8xaW4wMEV5Lzh4Slptc2o5WGl3emhYNklYSVkrdDRZWjFudmczSHgx?=
 =?utf-8?B?SEpHVTc4eFdONDc1dGxjQ1JiSFEwUElJSGZMM2J4Y1RJQ1JiV0xtTDFRTHpZ?=
 =?utf-8?B?OSs5VTZkdlRVUTF0MVJNY29xVlZ4K0FOampiWDZKVnJHSG4wV1hUZkFhZGZ0?=
 =?utf-8?B?NGpYUWV3QWdBQUZoU2t6SFdTcFY2SU5zS05zdHlRQ1lqVTRZYWlDUWtXNCtt?=
 =?utf-8?B?QTIvR1l3MGZvTXVJTUlWVHBjdkJoZVFtS3g2OUk0TGVvWmRsZFNQZ0cwK3Yv?=
 =?utf-8?B?TkQ1akJwVlVNNFJGMVBwVThkczh5UGpWWThWbVNtNm40SzhMNjhUS1FFNnBC?=
 =?utf-8?B?VDVRMkx2NGFOMHkzdXRYdXlaVzZDelVsTDU3MU9iWCsvc0NHZFhwbWNCcEJ3?=
 =?utf-8?B?R2ZiN3ZDZ3c1dk80a0puUFl0NmYzUWxOYWM0UzVJaGhua2trSzE3SzVEZFpz?=
 =?utf-8?B?eG4vTTVUWFpsWWdudXo5Y3FBalhJZTVuUFk5SXVLOFM3aWRPTlNSeFN1R3Ni?=
 =?utf-8?B?UndsYURhNmUrQ2ptem1ZRE5DOXdUQXI1ZWR4NTJqbk0xeW95a0xoS1BxU2V4?=
 =?utf-8?B?SEo3UFVWK21xb0RZRTZhSkNkckRKVnNrN0UwYzVjT3NpZWRwbW50RlIvL0tP?=
 =?utf-8?B?ZGtNMWZKak5DQ0JUbFZLZE0rVWg0YUlaY3dlMjVRZ21NUVhYUzVHYjJJc0NW?=
 =?utf-8?B?THBuRkdBSm9PSGs4dEFid3VsUmpEcDFOSklEQ09nUE55QTVGL0VjZEtxaFE2?=
 =?utf-8?B?U04yeUZXRTkzeW5SejJvL3BEejJteng0UWZ3L0Ezazl2UXhQTWs3Zk1ENXha?=
 =?utf-8?B?ejJTMlBQa09vVjNpZmpqcGZOelBkTitwL1pCL2htYkh1eTJaayt0MmJtaGRQ?=
 =?utf-8?B?WURUKyt2VXpVNnJxeGRPYmJBQjlLOGgzbklDQ201d2x0ZVgzRTBDdlRTQUpu?=
 =?utf-8?B?YlJ4blRBaUI1UkN0SktMakxoenhKdTB1aElQdU9reHVFQlA4LzNpQzZHUk03?=
 =?utf-8?B?dFMxMW5HVmFxVnRHVG5ia1NrcHFvK3d3NHVCSUpiUndyR2ZhM3huTlE0MUF1?=
 =?utf-8?B?UlErVEUwWTZWMjU2WDA5MHdRTytZNndCdVR5aUpYYm9YM21kZjNpZTVYdWR3?=
 =?utf-8?B?OFo3elJ0NHhrdzBnYlRQOW53NlJRVjEzYXdiTFRFTXR4ZExSTmIyVTNUOUxt?=
 =?utf-8?B?d0lkOThPd0RTSkp4SGUxc2Nma1FmM1FIUWVMRndDL0YvTVNtMER3aHJsVDky?=
 =?utf-8?B?R25UUU9NWFpXMVkvS3JidFFwcnFiaWNSRCsyYkU0WnBPYXlZUlpYK1JBS1FX?=
 =?utf-8?B?eTYrQmFZcllCWEVaeEZ5ZndzYWZJS3lraHNNeC8vZ3F4aS9PRStxOVBxeXpO?=
 =?utf-8?B?WmJ3OVNQTjBMRFhBMGVXb1dIOXpGUHdJRnNMWTdHQ3N4aFBBM3lZZE1UL0hP?=
 =?utf-8?B?TGFKQ2hBbGROSC8wem54ZUhRNlQvTjl5dGNMcnNKZTdlaHpMbXpMcG42R1hi?=
 =?utf-8?B?Q0FKSXY3bmJFRzFCV0ljcTlobzMrN0VRZE9sZ2RuZjJvUCtEY3FFSXhDeGVy?=
 =?utf-8?B?UzhwdHNQTVJwTzlodERJQWRFMGVKQ1J4L3NkK09FRm5WVGxodFNlZDNlU2pW?=
 =?utf-8?B?Y1lDcDRVQzQ0NlQ0TTZKMGo3R1I1MkgxT0k0aGR3SXNoNUQwZ2hnZENZSlIr?=
 =?utf-8?B?YnFpWGEyTW1uWFd5eGlFZnNDeFhMTmxrMkRuQUdDSndJSUFPZUIvay9iWEI4?=
 =?utf-8?B?SE9QbGdHbVVmL0w1ZENxQTI1Vzc5U00xVmhESnhxejBZZVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 17:57:02.5347
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3544e7f2-0aee-434b-1cd9-08dcf2c2eefd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000011.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8857

On Mon, 21 Oct 2024 12:23:24 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.58 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.58-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    27 boots:	26 pass, 1 fail
    111 tests:	111 pass, 0 fail

Linux version:	6.6.58-rc1-g6cb44f821fff
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Boot failures:	tegra30-cardhu-a04

Jon

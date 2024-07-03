Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20F117B419
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 13:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720013249; cv=fail; b=bW/LR3krtV+2XM/BhhnCr7PXxh60jkQ89KxGs585eKGfOsvGvTr5c6JG4tFCIgukaLiD9cxm25RBzt4sOcRmOjNQZ5rKjMEN0bj0AjzI/QJO9jHZvLHZXCXc8P542c616x7iw9xledLF74bLWI+7kWpJyFY0WNIhZKGc39bg0IQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720013249; c=relaxed/simple;
	bh=Vm8vLrHnsNfEToQxnXDaPM8XEtn3I9EfxatKsU0BBm0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=lUAKu0VXcPHa+Zm/1IEA7vcf3AbkpT09BW674tciXElL0rRZhM2a/99jg/tfPZKNbX760OaAnwQIZvr6vxbf8VIIB0wEhABaNjU3/zi67w5dZNK4GdTKLgW9T8Qvl35QRj+2vVXzmwqx3ykjOO0XgURPKnH9vY5O4hqcbMJ3Cxc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hngypEqp; arc=fail smtp.client-ip=40.107.94.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hngypEqp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ayNzmb9jERfLEj8oc7yfxM0DQG0OWm8C6nQQuPiH6nh6HI+0JIhRejQreEN/BdZJ4ZOOFfgJbhCctGRTDI2SDPwcfgdc7UdyOZOpNvvGCPnGm0xA+ClbGFaxlwIghMDRD8gp05HUiNJ11dGMFQgJcpCT8FCWI+mGYbrART0OLhKMjrsK3weJss+94sy+h7WmmPUXo0W2uEL+y84oMVZeqbEiYtdDbfLob3tk7KP/BCE9G8gDwL0DrfJCd+xpZBd5MRTpTPVii+KvggQRXzkXw9S2VSKiBbNo/Symy/RvyBwUNHHf2jMZMvXgEs6hr1GTnbqBoaMLS1HwnI4650N6kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iQ1pKlRJrvr2wL8VsRy32UO63fjsGBpf87XyaZe527U=;
 b=JrHTOoSlb0BVbkPJHwjhBpEpCeHpmd6ffV6mDDKUbaBlJOxRQvULFZTkL2e1MwyXbS0vkk134QjKma+Bz0jiUFWTEL8uVoKXFvWEj85DUtFH/oEcx+jtnkz2G4aKqzWpojNe7b10Dhihb/t5+S6bw3U1D7bc8uorR7+uBFki9xV+CU6JhWRmd1R03YuCwGGwxNYcZjm+iGA+OcxIf9UogaDr5jX02gFW2BiiFvkdC2PvHv4W4/3Q0azLr8q3ighfVDepRJJieUSC3ttfxWOoBUfnQ70ms+KURio1v1xDi/sPagCh+mUPu0Qi7V8ATGyV9Y2mud3degQd6+juiGAS6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iQ1pKlRJrvr2wL8VsRy32UO63fjsGBpf87XyaZe527U=;
 b=hngypEqpDIOnMJxOt7Wynq4wpJ9Mk7oI7pFoIIs7BjkC/nr013umwogvYDlYi8tDmbYrywfoUlx/PZEA6oMMxVlcmu3IxaBuuuR7ZmL0mo+79fKadh7IvzMiANTyHsrkzB5dCNw4Iwo98BXXpTgxiJX+KsP6iyrhHWPzxDLJTfzIcZAq5Lvxkz5nEiRJL0Ycp67Gy8cmw46xgumx0UiVO8apGHkETYMncXsAk+kwSfbcFA703PBinLoIFsGbHZoEbs7RnkK0OyTry69eqgI7Xj1rH93jYgoo6TF+JdmrO3VtlR484JjeURMf++Bpr+9n0DHh+qtnbpLX0CsocKqMZg==
Received: from PH8PR02CA0013.namprd02.prod.outlook.com (2603:10b6:510:2d0::14)
 by CY5PR12MB6431.namprd12.prod.outlook.com (2603:10b6:930:39::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.26; Wed, 3 Jul
 2024 13:27:22 +0000
Received: from CY4PEPF0000E9D0.namprd03.prod.outlook.com
 (2603:10b6:510:2d0:cafe::32) by PH8PR02CA0013.outlook.office365.com
 (2603:10b6:510:2d0::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.23 via Frontend
 Transport; Wed, 3 Jul 2024 13:27:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D0.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.18 via Frontend Transport; Wed, 3 Jul 2024 13:27:21 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 3 Jul 2024
 06:27:02 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 3 Jul 2024
 06:27:01 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 3 Jul 2024 06:27:01 -0700
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
Subject: Re: [PATCH 5.10 000/290] 5.10.221-rc1 review
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f1a3206d-4e2f-460e-bdf8-8a3769cbfc97@rnnvmail201.nvidia.com>
Date: Wed, 3 Jul 2024 06:27:01 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D0:EE_|CY5PR12MB6431:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aee8873-692a-4e0a-0ce6-08dc9b63de4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?akpRZnBOZmxMSDB5R1pQcDlnV2JKR3ZhaitsTVNyamM2RVpTbnJYcXVWYjB1?=
 =?utf-8?B?bXBuZmdlanlwaHFaQmZha2ZCanNCTlB1dkVNRE1vWkNaNEY4b2xDU00yeHBS?=
 =?utf-8?B?MG0zcDlNRjRldWRPb25pNkRQdkhNc3VzYVZhSzFiaWVSNnAwdE54MmtvdG05?=
 =?utf-8?B?cXBGaW9UbzB6ckdVSVpNN2JPeEhORzh3S3FtcnAwOTA2cWtUdDliSlp6L1NZ?=
 =?utf-8?B?Uy84SmRTK2FCd1FmZVRVL0Y5NzdrVnU2c3c3bFVZMTg4bEJ6bHFDU29qTnhr?=
 =?utf-8?B?VzMxdmVBampCMVhxQVk2bjVYWnVyZ0czUUJLVHVtRmhHY1UxbjU5Ri85SEw3?=
 =?utf-8?B?aG9yeU00L2d1NkxoNDFYVm9zYmZwZ2ZjZFd2Z0t4Wnp2ekg5bW1oUi9EVEVE?=
 =?utf-8?B?ZTdOaGphZm5RU3haYlArQ3NuWHZucnBVNzlTbXZwM2NlRWJDWkRwYmpMS09Y?=
 =?utf-8?B?ZFFtMGorK2pMb2xKSkR1V1c2Ym52QlNaZEFlak9ZaGZmcGQxMUg1T2ZSdVUx?=
 =?utf-8?B?N1J1MUZCUFdPRXRvKzhZWm0zaDVXSGFrTzNJY0JMRmlJMDhwY1phVTVrTTdQ?=
 =?utf-8?B?VGlZWEU0M3VPSlNOSjdIL09qM2tIU3ZFSHM5YjBJc0V0T25UM2JEQ3F6SHEy?=
 =?utf-8?B?WGdOVVNGVzhjQk5JbFkvRVhhK0Nlb2t1SkdseERmOHE1bXFvRytrSFJEUUlT?=
 =?utf-8?B?VGhQamlPL294S1E2K2c3ZTA0T2VQMEhuYWFYU3pHODJUa0dLdEd3d1J1ODkr?=
 =?utf-8?B?WjJIU1d6V1ZDbHNqWm5qQWhqYkVHRkdCcytFMDVrbmFadjhicitUSWlMK3By?=
 =?utf-8?B?M2dCdldqc09UQURUVlpGa0ZLR1ZEZ3VPTnFab2tKRXdtQXphNDZSVURFVjYz?=
 =?utf-8?B?eW9nTUNyVU01bWd5eHhIOVVhdzdESjhRUWZIMnJjcTZlWEFuLzVCeWh5YVJt?=
 =?utf-8?B?Nml2UVZxQy8xTWErNjZjWTVFbDdaS2dyYkNzSEVDMGZnTi9vZ0NIQ1VDUVB6?=
 =?utf-8?B?N1piRzRXVkNIc09XZGhEQzhlR3pXQUcxQ25INzQzWHpOWCtXaGQwMkRibk9C?=
 =?utf-8?B?My9xMW1yWlc3WCtBQ1hRNEtKNDU0TEtyYVozaFFBbDV2RnM5UHQ3Yy9JSWFH?=
 =?utf-8?B?N3pCbkhQUVZBMlVtRk5vd0laZkNNQjJLcEEzNFVmT0JUTGN4RXh1amNzVVBD?=
 =?utf-8?B?bmEraERHaEdUbWRmL1ZpU2M2YzFyaHVWSFRuWEhSRDB2d3ZDTTBEbmNVQ0VJ?=
 =?utf-8?B?a013ZmVFd1orcVloRVpiUnRYTXRjcXpOY0oxdXc3bWUzMW1Ca3FZMDhwOTA1?=
 =?utf-8?B?RGpBOHM5Tk5GbTBYZVNMUDdyTU1hQ28yOVBnR2NXVGtYQk9JRllLaDlXYTNJ?=
 =?utf-8?B?bC9vTEtwbmRtazZjUVFXT2JzTVRsU1FvMllESHA4RDM1R0NuTlpyTWR3U2tk?=
 =?utf-8?B?UEJYcVRWZFJkeTRnang5S3RXNEpBYXBYQU8wR05iTVBKbUh3Z0hsUlFPZVFX?=
 =?utf-8?B?cUt0NHZRbzNlOVRxalJJWmhwZVN0TlY3ZWpRMm1MLzJ5bzl2M1RjWE01cFFj?=
 =?utf-8?B?Wi9wNTlTVUZueHZPV1pGaTdYa09wMUdCRWovOVVEWUhLdmlZckJMMXlyNjM1?=
 =?utf-8?B?Z1BUdTRrbFhneWpiUUMweU9FNk02OHdLTEpCN1oyU1pIeGRKWnp2Q2tyTGc0?=
 =?utf-8?B?K21yZm1uaDA5SkdRTWpwU1lMby9OcDFqK3JGK0xRbU9UbHIvemVqdlVQQkd3?=
 =?utf-8?B?enJ5L2hkYWFFMStHOHZRdVRncFY5VFBQei91Qkh0c1EyNkNjbS9JQTJKcXox?=
 =?utf-8?B?ck8wL2QyUlFETGd3NmpFMlRZQnZrdzB6VTkzMkRoenBUcHdZcy9WQ281NTJy?=
 =?utf-8?B?WjBwSHJHUS9ZcEhpMnNTRytOMVdudUFpSElGMllTOEpZcFVqQ0N5Q1hoN2JM?=
 =?utf-8?Q?3MskVDIcuQivIixUo5uCvtWsp2kVbhpE?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2024 13:27:21.2136
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aee8873-692a-4e0a-0ce6-08dc9b63de4a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6431

On Wed, 03 Jul 2024 12:36:21 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.221 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jul 2024 10:28:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.221-rc1.gz
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
    68 tests:	68 pass, 0 fail

Linux version:	5.10.221-rc1-g4d0fada143ed
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

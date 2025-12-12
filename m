Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011032.outbound.protection.outlook.com [40.93.194.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614AE311941
	for <patches@lists.linux.dev>; Fri, 12 Dec 2025 09:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765530568; cv=fail; b=u2ZYRCvYvZPz2Auoch/MYTsaXYd2FZMf/a0gtL4JsqtlvBpY6PF/5AeMUXgl3tAQMj1VCL9eMzIbzLbyAgtq8gdazzo91BaEgVxg7RpHD4nKxH+UvS+HgpAZhC1/cInK7Jon49MzbdgGCBvutaVMNizNoBy1qjs0U6QlmfT5hK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765530568; c=relaxed/simple;
	bh=IlNK9vAHpvGaETWu92y7NAgp5biG6eWmpmP0fPFKz7A=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=A1N5WzGt2rqLiKOZYgZqVYuanQw0+Cr6omjRzbJ5yTNpgiNk4GrydEFKZfNYYg9G3zIFRvPBILAFDtiJXzC75SwE+to+kPexE53+zCISD5I8bRAj4mgkEBIvSTNdg5BaY8Gm5chee6ASlkdPgyfY/IFD7p2lyKvnYwQRwsjIbx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=o7aYuz3n; arc=fail smtp.client-ip=40.93.194.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="o7aYuz3n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=to0tZUkp0wyt+nYultcLWWMOptaihBeaeARX3FJjL1a5FJpftF6+096WILbtEpnwVWtNz78wHAlup0ZkjkbpGRCJmmRIOUQ+B0Cw9NxMNgGHVjHutG9lxYW7KvCBwWBUp5XKRaMtB4DuYfrsKBKftpwqOz2TLveFot4JhaGCz2d0qJDqN3Nxab6YjoEb8OiZWsnqr6tEm2LTxG5Ek+9hwegGPFqppX6OQJ4vF2kg5gITBnb6F+J5zhFkKDHQPmt8F/XUB8ywaLWZLlrk24PuT9ymFGbHg5DzMOHVt2LXcShVpgg+L91MWK46g6WUFECbAa6879Uph5qmmeKwlYbiww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SXdyNiN/4PEzgfPejNJHsBXgAAJpH1g5HoGk++NaToA=;
 b=o5ooH2LzfZehPZOQSj1f2M4PuSo0KpgC08IOnWHTR1AaBoGUXP7iLTJ85X/PUnfINi8d40YnJTAYIMts9h+7wBBCm+IXsnqXJ5j78dcnZ+22+Ne5GPwjqM+BW+QbPAYCqu3d+c3a/iADlM5qD+Mkr2bwe6xPeOGcQDZOSb/WM2/yuQXUc+JAfX8CQkqpg9kDR9zAEj6CcjF72pHZLv6f9VJXc7V/VZ0Or1z8X/mIMNLpGwSgQ6xHo7GSJXERElnGU/p0ATsQhl4uW9nx6D56Ti9HInow+8awbbi/jGouH5HyTJ1/w9JvuERY7c2Rxep0MW6w+tZJM07E2w1tBJ6zHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXdyNiN/4PEzgfPejNJHsBXgAAJpH1g5HoGk++NaToA=;
 b=o7aYuz3n8V9ub5PuR1JeRE860alDMCiKCIUQBM/NSpHdU3Qaaeuwmbxp6u4OuLg7WGpaYx+Uec4W8h1lx6WWmXkexxFHymc3+QKoluiBGhxqWo1cwLeoBn5/WleIhwTZKKhL/TNqsHonVRSbietsEqvR3ULboDcG5nLSI+m6TY4eo9vcs/WL28IvVCwG7k7g4UbTAXKsdYS+XGft9pVRo1WlZz5V/Gy5UR9aACZGmsLpBs9+sT8eZPK7jns4oaX5D9E7vgsbGxzvt699Iak8TYwxK43y61kEQQ4UJHZ83ThsmjolxAz2P0cC8Ep48IcubavnCDIFuK2aKf1KCiXSyQ==
Received: from DM6PR02CA0114.namprd02.prod.outlook.com (2603:10b6:5:1b4::16)
 by LV0PR12MB999068.namprd12.prod.outlook.com (2603:10b6:408:32d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Fri, 12 Dec
 2025 09:09:24 +0000
Received: from CY4PEPF0000E9D6.namprd05.prod.outlook.com
 (2603:10b6:5:1b4:cafe::53) by DM6PR02CA0114.outlook.office365.com
 (2603:10b6:5:1b4::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.8 via Frontend Transport; Fri,
 12 Dec 2025 09:09:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9D6.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Fri, 12 Dec 2025 09:09:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 12 Dec
 2025 01:09:10 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 12 Dec
 2025 01:09:09 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 12 Dec 2025 01:09:09 -0800
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
Subject: Re: [PATCH 6.17 00/60] 6.17.12-rc1 review
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <8c3dd3eb-5867-46d6-a35e-adf6b98d218d@rnnvmail205.nvidia.com>
Date: Fri, 12 Dec 2025 01:09:09 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D6:EE_|LV0PR12MB999068:EE_
X-MS-Office365-Filtering-Correlation-Id: 80ddae02-a1c7-4eee-307e-08de395e24a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bE5TV3U0bE9meHRpN1BFVDNXU1dHVFJjMlFVcVFZR01CQ2hjcG1uOFNjQ0dJ?=
 =?utf-8?B?Q3NnbXVRdG14TDRsdWRKNGFVNWltdlVqbFpxOWNQUW1teXVwUVpWVk9DWFRK?=
 =?utf-8?B?SUg4c3A0VGk1Zkp5YU93ejYzWEdoUVliVVR6ejBnVVJlTWxTbVppNzVuSlJr?=
 =?utf-8?B?dWE3dk1VMytOeDJaNC91dWc3SmdTKzE4bUdPSldmcGlPSHQ3YWNSMU9PSkFO?=
 =?utf-8?B?YjFlY05FbmUrbEpRQ0N2SDBuallCVUw1b2xGYzVLdjY5RXM5YVZXNVVQejI5?=
 =?utf-8?B?MnZQVXF0QS9oeGVxeTYwcHpHK3JJWGFhbzMzbC9TSVV0NCtuQVc5ZHpqZktp?=
 =?utf-8?B?ZmNIaDZnVE84S3h3d21SRHpuNHNUQ1F6eFlLRXMxc1Zveld5N3JrOU5KUFJ3?=
 =?utf-8?B?SlhTaGZpSUg4K2h6dTI2cFluUzVSR3M1RE1NR3NKc2tSRlJQUmxjcHVjQnl2?=
 =?utf-8?B?bEp2RHJCbnJUS3dkQ093eGFRRzdza21mbmZxVGlBN0g2Q0xFdHl0emRIQlpG?=
 =?utf-8?B?U1dKckRrenFhVnVFVy9GNjhKeXlzWHRrVE4zUzg2b1JEWDdFZE5tRHJQam5B?=
 =?utf-8?B?MmlBV0xaN1ZuMHllaGMrWkIyZE1nYUx5WEFvbXhtaEd0eGhnbGUzWE1lVlE2?=
 =?utf-8?B?RWJPV2I5V2FLYWZlcm9VaTdGdjNISWRzM3Y5ektsd1AybHJQdzhXM0Y5VzJz?=
 =?utf-8?B?cEE3dkNSNTluTkN5TTZsVEJJMzBRT0tJL0JWZlk3dkFobjBRK0swb1FtWUFl?=
 =?utf-8?B?RXltQTBJYkJXc2g1NjNSMXVDWEs1dWFnSlRUTERoZkJmSFZtbHgrMjVRdWxX?=
 =?utf-8?B?QTVUa0pmVWMzMzFNY29WMmhjb3V3L3FoUTRYaGp5cGZZeUI0L214NUtYN2s0?=
 =?utf-8?B?NnhpZXI5TkFDZmlia0dJWEg2MU5iMXdzVnEzQk9OZjRhOTZYMTFwbmVGWnBq?=
 =?utf-8?B?R2Qxam9HK3VLRnJmUUEwbTBESGN4TEhuaFF3clU4bnB6aWVDbGRQV1lZS0N2?=
 =?utf-8?B?Uk5zbFlIeEhsdXVTU3J4dXp1OHVRbmdnYnRvVjZCTnpDN0NJaGpEZHovN0FY?=
 =?utf-8?B?ZU5uNWoyUHpTcWM2SzJwTmNIdkJhbk1OSi91K1pseGVRaU1rQWhDbmtSWWgy?=
 =?utf-8?B?UTdOWW1CL0RONjB4REFUYWVkZHRMZnEzNjRHS3BRa0g3RlJObkJCU1oxRnAz?=
 =?utf-8?B?cWRNanlmbnlEc2FuMy9iZzdGL2E0RzltRC9UVjRUOFNHajFEZVpURlFnTGxZ?=
 =?utf-8?B?NmdSOFRHSEVrZEkrVldMNHhwWklHMmJRUHA5eTJOUzVQeU5pRllaSUtCR3do?=
 =?utf-8?B?alJ5RVU2L1IwS3Y1MWFsMU5zZzdGb2U1VEpoaHdJSjFURDd6LzNpS0pOQW4z?=
 =?utf-8?B?dUdvakd5YjBBSW9iTVN2RUFZaVV0b2xYaHRHS1NjMmdjODMwZkZjWS9GSndx?=
 =?utf-8?B?WWFXajZEcUlxVm1Wa2Z4MFVGdmUvVzdMalhPTG5yYlloU2xhcjg3azU3MFVN?=
 =?utf-8?B?VmQvcXpuaXV3TUVaTHZxTHV3Uys4dGhQTVpuUVBOS2F0VzRpZFBuOU1xaW9M?=
 =?utf-8?B?eUtkYWhES3hKQkFRcHk1TjM4RTRldUY3OXNHUXk4NlVVV2ptcXFXaVBZRE5r?=
 =?utf-8?B?eUdrUlgwWWYzc2FScm12aUhkUXpDdXlIVjIwc21ia2Q0WUUyR2pEeURCc1gw?=
 =?utf-8?B?UWxpNE9DZm0yVUZPWlJRME9QOFlOK3NqeTVQalhLWjdQc1Y1dkk4aXovVm45?=
 =?utf-8?B?cjY4YS81ZzhQSU9VRjg3S3JWSitTRlhpRTlLMUxpWkdySmo2a2xOWWV5MEg4?=
 =?utf-8?B?QXpoclQ4NFJLWG1vQkk0dGRTbGtCTXlvLzFjYnZYVUlQVXpmL1RrVXdoMnhV?=
 =?utf-8?B?dkM4MWpzZ2l3WGh1VFVXQ29uN3JPc3JqRk5xM1RtWWJxOS91TzA0cHBZVnJa?=
 =?utf-8?B?L2RMemQxbG5ad05Wb1RYMC96ZFRNcWNRNUFkN2Y4dTdxQWR5eVZzM0c0M1dO?=
 =?utf-8?B?MkFpemZsS3YwbmpGUWZudERkaHVWbndQYVVMREF2WkxjamdQSnFmcHV3M1FT?=
 =?utf-8?B?OEVUbnQ5U3luRUYxNi9yWjJKUjlYKzRLVyswbzZPK1d2NVhWWFBWdDEvNFZy?=
 =?utf-8?Q?1J0A=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2025 09:09:23.6326
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80ddae02-a1c7-4eee-307e-08de395e24a2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR12MB999068

On Wed, 10 Dec 2025 16:29:30 +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.12 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Dec 2025 07:29:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.17:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.17.12-rc1-ge7c0ca6d291c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

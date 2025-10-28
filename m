Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012018.outbound.protection.outlook.com [40.107.209.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F061F1E49F
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 11:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761650942; cv=fail; b=lrfGue1gniEptUiUAFHitlJooft1+v+3N2XhAfMfM2ACe6t7/yE/77qo1uiLTFfFxX2WSkX1V7DLp8t5qkY4E/L9Qmnp6qU7jP6UA2W9z9+wiHfDmyjA40VHvPr7iM1FrmPjlLMEPzdQaY0wRhmWPW57k99sBMDKCBGta5eThUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761650942; c=relaxed/simple;
	bh=0Q+nfYV2ejkfhZ0n7/i9AC987LQR3rjFd5cGP8pwpW0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=I3e6vg9cVCV9b4eVLZ2EtT3Db40WZgzfpb1CGmQoptN2giiLTVbdum6oZq7bUqBmFg2BNVe3u7zVgTuLTWUgPEHi4Jes9jUTbHinWTFKU+0/FjdPkG+gsvreFXLG1+YHfXCY0KuJrxOI5Y7Yk0GXoBmr4F8DB2cvU8/JcbePcJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=psuuob0X; arc=fail smtp.client-ip=40.107.209.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="psuuob0X"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c/FebKQ6LuCrlgo/GBZvaCBI2hbvDFPgvG0QDqdCZy5qnYyc3rYuOB/FrxvV2Usx+mr3A7JLAe4bLJvZe4yw93UXYJFwtIKte+rbbOPNQOlO47BS5ud0Oyrt0cDze10mYmpAruNhD1sQ7XRWmJGVStTvD5qo3UF3AAUb5ENdiz+fu7UtVMRgctWZft9Z1Kh/n+/3Qg9DhCLYehRGaNPo0zVfWPM5gY5ZRH+HkzZ22W4FL6TvyCF//Utrbr2HzYzjrFQuE+feI2hlTGUbZV0mHsu1a7E7k5TuKE4XAi9fw9jjHMcFMAikJNjTib3JIT+LdfazyOAlaET+lsQW8FfG7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5vxqnBHAQfCocO6b3jGeO5fxPRHxVNzV2Y5hwCLJUQI=;
 b=HyFoYRLNoOsn3nPlbdujbDLhl1X9Vj2kuuvb2d7mj1dtZ3yWHbTin2duiHJX8ZVgr0oRxK3+LVsAeilsjinsVnf1XcfFUpgrO4ZMjw7ecGQqXVt4mcfpi/enxfDxCx6fXGBYAAGBSdEdi3H2yUd7lLEdcTm46KiLjRdnucJl3l+UH6lf5du8bCbfpXVmq1IbqgDc4EFHUykiX1zDvLGJQFjTX16/mABopkCmUgo1+GTTNgkBhLLQX8pYFveB0iImLUij/bgNjDNZvbT88dFRYxz5LwCJe38X1WQ0NUrDioTAmFzy/7oeYjJQ7YC5ZqsX538hcYdgKSeto8rZ5x+bjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5vxqnBHAQfCocO6b3jGeO5fxPRHxVNzV2Y5hwCLJUQI=;
 b=psuuob0XfsYg/ZWpxrzgXvJAM0+92EOkG1GMZWD41P1yckwVWYD+Sz2Mflxw9+jCWprOX9Ea1dPN8A6Jp9cirrGQf6QdegLph+HuLB/+lItELcE+000ftX0lFjvfjqBZlkmHHNDHW2O2ChuVRk0YfKRItW9cSptgr4BN7UyWcj0NbMv4G9MgFgb87nVfLp5VP34fePzGg8Ib1va4M5zHP9IaVsXxb+yUpBNBoXF0d7mujWyWnUGhkmIdC7XCMePrfZnv7kIAM9/XVFii0EPIOS65KDgiueUM6JVbqbmwfe1iL5Iqqo/u0z6ekcGNZOY3DB7QSC/Z4tO+00mH2r3L0w==
Received: from DM5PR07CA0073.namprd07.prod.outlook.com (2603:10b6:4:ad::38) by
 DM4PR12MB7648.namprd12.prod.outlook.com (2603:10b6:8:104::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.19; Tue, 28 Oct 2025 11:28:53 +0000
Received: from CY4PEPF0000E9D6.namprd05.prod.outlook.com
 (2603:10b6:4:ad:cafe::2f) by DM5PR07CA0073.outlook.office365.com
 (2603:10b6:4:ad::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.12 via Frontend Transport; Tue,
 28 Oct 2025 11:28:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9D6.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Tue, 28 Oct 2025 11:28:53 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.34; Tue, 28 Oct
 2025 04:28:37 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 28 Oct
 2025 04:28:37 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 28 Oct 2025 04:28:37 -0700
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
Subject: Re: [PATCH 5.10 000/332] 5.10.246-rc1 review
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <0362369d-233d-4cea-9fd9-98b817f70d16@rnnvmail201.nvidia.com>
Date: Tue, 28 Oct 2025 04:28:37 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D6:EE_|DM4PR12MB7648:EE_
X-MS-Office365-Filtering-Correlation-Id: d368029b-a6be-4f45-d3d7-08de16152cd9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MEJXVXQwZFE2bnQ1U09yYUh1TnpmeThkem5kaitBY1lVb0R1aEFIcVlqZTRT?=
 =?utf-8?B?VzZSSTBiNkNhT3NGUC9NbEIzTlBzYVJnNFhaY1pIQnpJZys4SXFMZ2pacHRH?=
 =?utf-8?B?clQvc0NhZUdwcGd2a0JNUVZmWEZ1VmtsdHZ5Y2M5NnMvZjJsUDNTbU9pdThM?=
 =?utf-8?B?Nmx3ZkFiaXF2ZitGMTlaeTVTS0E4dlU1cElMVzQ4L0lzT2JQcHhuRHFGdVlJ?=
 =?utf-8?B?YU9BdFZkQTYyVzB5b1o5YjBDR21jdEU3YjN0VkRwdldvc05IUmI4L0s2bkFQ?=
 =?utf-8?B?MDlZUTlLalZGS3RvUjdiUG8vTEdvN3ZXQjVaK2tFSGtHZTBic3R1cDF6bEkw?=
 =?utf-8?B?d0dqcXk0WnNLVlJUK3ZqdWJPcnhncy9LNVI0am5MSE1YcktNd0VrUTlrbENG?=
 =?utf-8?B?ZXVRSksvanM1RTIxVCtESVFXQjM5dnExb0dtQ2k5RnJuYjlKa2c5cjRWa2I3?=
 =?utf-8?B?QWlZK2lPZGFHTXpIZ1NRN0tCOCtMWWpJWCtJdzJDU0lVSVgzb3hPaHdRTU05?=
 =?utf-8?B?d2EwL2pNTGZ1TVdBOGF0NGM5S2hka1JlVFJIYWErK2laQlRxRnBsd3FCRkth?=
 =?utf-8?B?ZWJwZGNaTFJORW9ZZ2Y1R2g2YTFGbThWQThPNFBCYmJMR25nSU9SLytDaURZ?=
 =?utf-8?B?Nm54ZzVOV1YzNUMyZFFVditVbnNDN3NhSVlYSnM4b3BoNCtUc0hCcjFDME9h?=
 =?utf-8?B?VXRQaFN5L1dNQjY3M3VnWUx5Q3hyNnF6WnNDbXduZzNhTTZMK3BNS2RHTXdF?=
 =?utf-8?B?Vm0rOUhCMVNNVjErdkdwczNEQSs5YWFFS25nRTUzaDdkdmxVRUUwNHkvMjlE?=
 =?utf-8?B?dm5wZDZYK0NiQlRqZm80QWVycFVsb3pjTEN2MUtyaXZNTTdjQk5hTVJXcm5B?=
 =?utf-8?B?QzE3UmZvNElObTZHeWVYb24zbVJlV2lRMXlYQi9lMTFFNUtKcGgwbEFjalpi?=
 =?utf-8?B?aW56Wm42NXhocHNJYVEwWTdCZ01JWjRjMG03bmtHK3FBY3hhOVNFT3hYZGF0?=
 =?utf-8?B?NytORVpWeWZBU3FwdEQzWGxpa2ErSjMvUFQzbGEvclFwcjMyVDlLVzc2cHR4?=
 =?utf-8?B?T29TSGZUbnZzOXlsV2JuQlhKVS9WTFRjc0cybXdQbzdoc255anNQYWNWWHBy?=
 =?utf-8?B?Mi9FazMwd1dGZlhwSnArOWI5VU5rd2NZSkdWb1JmQ1lzd3hiUXNkbzR3Um11?=
 =?utf-8?B?NUJUWVNyZFhnQm9sZ1ZlWnlJaGZoRHNZVUtXRjBDV1I2Y3E2bDdKem1WaXZw?=
 =?utf-8?B?RFJFYk9uRXFUSjBpS2FLTFlTWnphQitkdHhsam5aVXBZRUFGWFJBRTJVdTBE?=
 =?utf-8?B?RUFOWlFpb1FRS3FPRzA4NStsckxpZk5WWG5QRVVxUlgrc1htejJRalZGcVpj?=
 =?utf-8?B?akpuZjZLbXpSNG01Nk9OTzY3YXJ2TXhraU5Rbkc5L2gwc2E5YTNER2ErRWRk?=
 =?utf-8?B?ZmMwZUgwTXVnVmJtZ3NadTJ6a2RSYXVCWld6QVNCVE13THd3T2pXeGsza0xz?=
 =?utf-8?B?UUR0L2VJcDlTNlhIS2xpWnorZ2xOZ0RqNW1iNytTb2FIdmQ0b3AwRDl4c1dZ?=
 =?utf-8?B?bzJHT1p6MGliRWg3TTFHY1hQRjB0QTNoYVlzRW9CWml3Y2VBbjBub1Y4V2lm?=
 =?utf-8?B?eXRqb29OS0FwZnRpekVZTHM1RnFRaER6bGFib0FmOEhhQ1VNckdiSXg2NWcy?=
 =?utf-8?B?aHNPQWVwRmo3R0VjS1N3ajdDZlduZ0x4NVE2d3YvTHNnNmVqVHljTE9Wc2Y4?=
 =?utf-8?B?ZCtKY1d6bDcxbGFUaUJZVG1nRXJocXlZZFV1b1ZDOGd2bVE1Ukd6a3U2dXFJ?=
 =?utf-8?B?WGdQWUpYTktQN2czNjFvcTV4cEpIeGR0ZE1QTU4rRnUweVlzTCs1WklVY0xX?=
 =?utf-8?B?NUtwNlJBMGV6dFVRV3M0RzZiSnd4eFNkeGp0VDRsR2xDS2tEUW1ad0xQSTBF?=
 =?utf-8?B?WUZicVFiSU54SFhGalJERG42bWRyOFhBeUVLRnJ4U2p2VC9MVk1nN1JjajZo?=
 =?utf-8?B?RTZkNE16OE53VHdWZlFIRkozbys2RVZ4K3QwMUh3UEc5dXJZb2dvMEMxRTlH?=
 =?utf-8?B?Szl3c3Z1ZFdLb0tQQzF0SzkrMTdGWTBPVHBYNDB2WnZ2Uk1UaTUweVVyQ04z?=
 =?utf-8?Q?5unk=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 11:28:53.4736
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d368029b-a6be-4f45-d3d7-08de16152cd9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7648

On Mon, 27 Oct 2025 19:30:53 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.246 release.
> There are 332 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.246-rc1.gz
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

Linux version:	5.10.246-rc1-g65dbbe3ff059
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2042.outbound.protection.outlook.com [40.107.92.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2A6180A90
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 17:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718384619; cv=fail; b=oEbxghoiX7wDGSo2zOD/H/nJrbQzbsKRQu20E5xIaw/CLpDToYCtzIke+WruAg0tM/K58Iyh2ItzgifmsD82fT4+DM42VRaqg6iNYu3WbcYRLAZcnIiL1jVQP+8AIE99KaHYxPawFJDG2SHiUsByKw/Hkz+xFlJnSPw51MY6+Xg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718384619; c=relaxed/simple;
	bh=pyeO/iQJTMM0S7c6tizsDhgq5bGIX+GQuVHfDL/Glhw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Y22V0iEioAq7NSHbE3WbwC1XNi64ZQWtWE0oQajSeCSz1jKKkLPYOBPlVLYzgIDv9ttxyMg4/dts8xgw7FlU/dmSBwTAiFs2s/r7D7A+osH6O9s+UjDemeNsBMJzvsXhCjpDkULmc+cR2pKM9SeMEV/XKEHX5xa3R5vF1a4O3uI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TLeEkWAb; arc=fail smtp.client-ip=40.107.92.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TLeEkWAb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzQ2Uw9O6MrmY/f/J1UPxOXxm7wY6dfV6hRj98OUa7mhr7Zxk+JCi5sMgWqH6f/ogxg1gxFknwonHuQ4RN/kGiYJcGCf+sRF2fLZ6V+gITtq2LdVaoqIA/VnTXW/If8+JvaAOQqe5V8ZG/hqeLy3Bb65evauB0715HG+dBZYA4BY5v/LOW+OC/XnyblkmGH4Lw13eF/pOkEy26UqayZr7YZ1iwqrLKHLxdmBh0jhej/dVjWBcasIKR+aKgT+QSyp/WVnhOJrfu/ab2Hv/XxdssZLOoNUBzGkDtq0cmeMjJVIgdhuw8JEDBuZv2QJeVe2zM9SGkuQX6/CMQS/52s4/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9OK+/0JlA6b137PZcZDiR+KTnYCZrdGvMfxkv8a6FbM=;
 b=SCPjTIwlugexToXpatn8B+mJwOykO91kOeXe/F31Tpw94Vt/DRk815yvNXzbhNptN/72SjbSNvRssYQ2N98P4Y4G8dvSMIhSpIDYY4dwXtN5Vmmt1m7eo43eB0pYffU+7aCt+aoVivPbfzt3CW4Ey8Xd0RuX2PtJNDYqkfwwGKN4f8/auUhOn7KHctxjbgSFxlHRwvyGCHWXbFxSa3B9fAXJwxbW3jEgNfWyuCm/xs88iNYAZ1yDTnA03e+kOEHy2hCALDt5Llxdj8lgk/RqDbJ83knTup10XczQqQCkedpUc0aMnDhKSzbetMkC0MsR4qRA1ckx1biwOhFN06sIfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9OK+/0JlA6b137PZcZDiR+KTnYCZrdGvMfxkv8a6FbM=;
 b=TLeEkWAbObxmHBtbO17S+Jvg0b/BlbP450XhFG7UjoBBYKcwwXFXMJmfjbcaGT+2KnRUZuWki+qRT/xCkfTTYhCpz/YdI/K7b6rLKUH1O/NWBVwTZhaxH6Ut3llZXV+0zOZpuH77F1DjTXdloG6uxYa9A8HWrNaYK3duTgZhHuEqWkkyEUZy2V4YiOTUlhquIOPMa4RNqlwcXnxF4DOTldS5SWMikNDaEma5KQfuZ0QlVgHHT4L9lQxTbFGuPOaKxFEhS7o2GU3hkd/l17OosxysQ/3mAdtimi0d+rU0jOyk4sLHtZLxxWPW6cg70KDA9pEZ86HZBKsez2yEpHfgnw==
Received: from BN9PR03CA0907.namprd03.prod.outlook.com (2603:10b6:408:107::12)
 by SN7PR12MB7298.namprd12.prod.outlook.com (2603:10b6:806:2ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Fri, 14 Jun
 2024 17:03:32 +0000
Received: from BN1PEPF0000467F.namprd03.prod.outlook.com
 (2603:10b6:408:107:cafe::23) by BN9PR03CA0907.outlook.office365.com
 (2603:10b6:408:107::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.26 via Frontend
 Transport; Fri, 14 Jun 2024 17:03:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF0000467F.mail.protection.outlook.com (10.167.243.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Fri, 14 Jun 2024 17:03:32 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 14 Jun
 2024 10:03:12 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 14 Jun
 2024 10:03:12 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 14 Jun 2024 10:03:11 -0700
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
Subject: Re: [PATCH 4.19 000/213] 4.19.316-rc1 review
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <04dd1f28-d700-4be5-95d8-e61710d77842@rnnvmail201.nvidia.com>
Date: Fri, 14 Jun 2024 10:03:11 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000467F:EE_|SN7PR12MB7298:EE_
X-MS-Office365-Filtering-Correlation-Id: a08d2429-95a2-4796-b37e-08dc8c93ebec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|1800799021|82310400023|36860700010|7416011|376011;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cmtLZGdyM2x0WWxPaDEyMXhoc3JZVFk1aEphMUt2cVZoaGlJN1lQSDh1T0dT?=
 =?utf-8?B?TlZrUU9JdkRSY1pMSWFRTnB3Rkx1VWs0aUdidlh3MGRCRU96bklkRUlYNllh?=
 =?utf-8?B?OUNrSk9adXoxczROQzkzbHVnRnBPdWpQUWZQUGVDZjJwN09NaUN5amU2MzRZ?=
 =?utf-8?B?VExmc0hzUi9yOVdNZ1U2bEpRS21LZzllWVFZTzVyNnJNYWJvdjZub0EwUVcx?=
 =?utf-8?B?L09Gbjd2MXBoejk0a0psVko4S2xYZHExSXB2bnpjby9hbmluRWw4akR2eWY2?=
 =?utf-8?B?Nys1VWhPS20vYmIvajhtSHJwbGgzUG5pdWVQNE1yRUZLOTlmbkVjTnBVTXZP?=
 =?utf-8?B?OVV5aUpQTUY1VGtBcW9wVFRma3JTYmVLM29JMjNZL3kzQWxIaVVyTGxGRmVz?=
 =?utf-8?B?OERhSDhLU0w4MTFzS0VpRXpiRWZyR1dORjZneFRyM2xzamVNWnFkTWI2WDZm?=
 =?utf-8?B?emxFTEFnMVptanc1Q2hMU09JeHRxT0l6ZFhaVyt4VkI2UFJDQy9yY1hzRjZm?=
 =?utf-8?B?dEN3aXBncVlEWkg1S1M3eFdVNTBGVDlTdllwSmVvSFRidE5QS2E2UERHUXJi?=
 =?utf-8?B?NVA4MFVpa05od3BLSjBXZWlQcjlwbThKTFNFR2RYaW5lTnViVXE0Tmp6SnhU?=
 =?utf-8?B?dFU0UUp0b212a3YweTJWSlZuVFhCTDhQRFdiN2JsVXRvdGFKL0lCRVVXVHkw?=
 =?utf-8?B?Z3FIN2s4a2hqWnVQMDRMdHIrZ2tYb2FLVFBmYXVONjMwYmNMcmJ5SmhKUW1w?=
 =?utf-8?B?L2tTV0o5M3l0WG1IeHZoMjd2b2J3ajh5TWR3bUlRMzNDZWxRQnhFUy9VWTFo?=
 =?utf-8?B?UG1Ma0JMTFp3a1BkRWpad0N0MHNYMFBsdlZKWFFJYTNYSkZxNFZYc3RIOHlO?=
 =?utf-8?B?dytndlpiaklEUVpXc0VDV2hHVFRrQ1hGMEdLVVVjZUZ0MVp6bjdQbyszOG9p?=
 =?utf-8?B?U1FFcWZUQUxabU9qdk1Wcmc0V1JibDZjbnp4d3VDRk9qcG1RemFpUWNBT0x4?=
 =?utf-8?B?NldQSmtpSTRLR0VXQTJodWx5ZzVNVFAvNG56anJ3K3ZkRnlqcFJ2VmZza3J4?=
 =?utf-8?B?SEVndktCcXc3ckcrc2dJZGR2YmxER244QkpwVHFFd3hsOE05anNQZ3F2eFFI?=
 =?utf-8?B?Qm9rcEVNVkl5ekFrcTJQa1ZrYXJzN1krOUJhRjVnWFIxdkV5UVBNMFlFcUtk?=
 =?utf-8?B?MDVBcEVqaFFHdXk2WmE2emNuWldwZU5MS0NFMXNZTDdoeWVqR2kzWVJqQ0NJ?=
 =?utf-8?B?SnRYQWJzUzBKV1JxbjBDYTFzdTdrZjlobS9rRGtocnAvUzZTVjg4T3NMcGt0?=
 =?utf-8?B?OG1ud3ZubWZQRWJPaXhZZGRwNEg1Vm41aXZTekZLdWx1MXU3U084VlhvTkVX?=
 =?utf-8?B?Z2Vpc0F5U1NzNVE3ajhJN0g5WER2eGFtNzFQK0xQTWJvWE9TZEpFOGljbGdD?=
 =?utf-8?B?WGVXUlEwUVR0SDlyTEhtWDlRU3QydytoQWluVlNkNitvRTk2RmFZTC8yNWFl?=
 =?utf-8?B?QnVKUWw3UVlsZU0yTzBnWktiTng2T3h2enIwVzVrRVd4QWNTY3dxbHdJZ2dn?=
 =?utf-8?B?VEx4M0pDWVE4WVk0V081TDM1TUpZTWtLRDlGY3FreWtCRUdzRllzaDBTaHhi?=
 =?utf-8?B?bHlhVlp5eFRHWDN1WUFic0ppQ0kvSGRTY3p0eldwRFF5bm5pY0taRGp3SlQz?=
 =?utf-8?B?UnpOU3E2U0hqcldIcC9nWDk5RTNtTkd0L0t2RFM3aDdDWVFnYStaRmZaVkh2?=
 =?utf-8?B?R054K1ZOYU9VbWVFMjczamZEUUhKYnJGdWZNdkh1MDVRalRBZHF2OEorWVJv?=
 =?utf-8?B?Nzc1cTZ2RXNWemhGQ0hlazFLeVpPK0x1VkZ0dHl4U1VUSHlTc1RnNDVkRmlI?=
 =?utf-8?B?ZnlCYzhyOEJuMGN3U1FtTUxWSGxlS3B6SGd2azA3UXJNbHc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230037)(1800799021)(82310400023)(36860700010)(7416011)(376011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 17:03:32.4132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a08d2429-95a2-4796-b37e-08dc8c93ebec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000467F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7298

On Thu, 13 Jun 2024 13:30:48 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.316 release.
> There are 213 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.316-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    20 boots:	20 pass, 0 fail
    37 tests:	37 pass, 0 fail

Linux version:	4.19.316-rc1-gafbf71016269
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068B712D775
	for <patches@lists.linux.dev>; Fri, 24 May 2024 15:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716564006; cv=fail; b=l9tJIsGY+jeD8fAVtXN19zB7CzBoPI1l0IBCfGm8tWePI4XHsQSL8R2RIAQj6zfJ61aErQ42ZN26iBTh9raOGZseltQMESw9V2c6oRZpJ9QrIU8FM90qmTdJplaRE9C6v6p7ITz4EWFvnBtNM542yIK3hDjVhCfkNNBvwMoUlxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716564006; c=relaxed/simple;
	bh=plblIaJ+gAkbynWnRORwWdrOgPIHzDpTmEtU6axBDG4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=SyNSyoQoP3URkEtilmveZ814vfVxT4bI3Nm1fi2yjE84ioGf8LwYOsslIhxXpsGZgcZWZzzTB5JyrIgbfPOY0IR6+oKGmYFHBmJqOL3GbemIigb3H3opXDjwulU1MjNTMv5yJN0WT2BQGFMw8Z3xah7+ffDsH9fxYw/5WskeFDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lT7OzwNF; arc=fail smtp.client-ip=40.107.94.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lT7OzwNF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aN2XPAuUpC7eSbr6U1DFIhH7J8kYSo8PX0pT8+TRuwoBFZ2YrEOYVWycV5mpqWr3rZZtK5qNjTS+SnAKD+cWyRaVVs98WBwUKKPVwHIAz0y4rju3iD65DU5M3Qe8CU/F3tOE+/a5eQw9QPZau+HmjNwp04T3nS6tBXv86Je5cDb+dokMwWMWdF2L7jAFw+AqsniwO/0QEIe1RW4Bjzv6Dl+NE4jRyH/am2gQzGr+0+lzYMXBn+1m0uwulkdcd1zd2Q+BMZXI8awgXukvRwvO2pqq/o3qdxZQ/NXKDtEBEs6lni9dq4UlEyyz2jwIGgU8qnU5SERI8YyQMDDhLkveFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c01jdGk6imH+Vzt5J5FfaaqvzQ1NHePvmJYwctaGPBA=;
 b=TIHOPiBI1peK2ESk9IsavLZrBju9VOEtsZypzSh5DrgQxo0Jm/VBAvAW83g/n9156Wt/b8D04RWF1ZJMJQryoU+Lf4LK85JP7oplbZBME2uYVF2HUfOhha6kSDk6lIqFpyCMWaLoNH8NYRB6bTrUHKcUnTYA99QiHtu4/Iqz8DwaO3e5SDNlzqN++Gh9ERSGy9qrnnzQe1JUIotO3ICOqjoLeMBEK26NK0g/1I91v9MRfIfR4EW6H97tkZHoPb5a2aIEql2lhd60d3yzBG/YknsIGP92NJqvhMNUDHWNl8UakluyNrb/n1WyNhKfdrBp1Vn9VoMxA3Ip2lVJQDmIWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c01jdGk6imH+Vzt5J5FfaaqvzQ1NHePvmJYwctaGPBA=;
 b=lT7OzwNFACP9LsuFSpnY3K0PaxbZAFVfQNYO78wh/pfd5hmEg+FxP3aAfCn1r8Lk8/YpQS1BO+Nd5TPalrqgEjguGipKgsNLlgsK/z6gc3Xmm7ASk62OYTMBgUs/7ENE+7AVDZQ7/egHCeSuePM8Ck+GpmsLclbMO7eWUINAZhUwk55fcYHsJI3Hkokb0ciKNwJ17HT439/R0uRjuhXMsxrMNvIvqoTm69+tU+LKhCCNIGuh0Zal0GT2oNf/zHX4zIHu1I7aQPw1q10RFEZorheD8NjCIfkc92E7Xcs6V5lVIVwQasf0lY5lyLTvKadoB2hankkjwnBInKTVHRBKdQ==
Received: from SN7PR04CA0192.namprd04.prod.outlook.com (2603:10b6:806:126::17)
 by DS0PR12MB8444.namprd12.prod.outlook.com (2603:10b6:8:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Fri, 24 May
 2024 15:20:01 +0000
Received: from SN1PEPF00036F40.namprd05.prod.outlook.com
 (2603:10b6:806:126:cafe::47) by SN7PR04CA0192.outlook.office365.com
 (2603:10b6:806:126::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22 via Frontend
 Transport; Fri, 24 May 2024 15:20:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF00036F40.mail.protection.outlook.com (10.167.248.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.14 via Frontend Transport; Fri, 24 May 2024 15:20:00 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 24 May
 2024 08:19:46 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 24 May
 2024 08:19:45 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 24 May 2024 08:19:45 -0700
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
Subject: Re: [PATCH 5.4 00/16] 5.4.277-rc1 review
In-Reply-To: <20240523130325.743454852@linuxfoundation.org>
References: <20240523130325.743454852@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <c93a43a5-8b32-46bd-84a3-f6b8e8b54db1@rnnvmail205.nvidia.com>
Date: Fri, 24 May 2024 08:19:45 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F40:EE_|DS0PR12MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f3657f5-a088-4b29-e0f4-08dc7c04fac3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|376005|82310400017|1800799015|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q3FQeG0wdGFZTHBscStET25XTEYxY2J0dEFvdDNBaWhaUkRPdTNqamZrS0tB?=
 =?utf-8?B?ODhCWTZNMkFFZHhKSXhRY2E1VW1STVovTlVlbEpZQm1wOHV3aEJLbVJOZDRG?=
 =?utf-8?B?cHNDLy8wQm8vUlN0cVlFRHBoZVpXcWtCcE9QUERFanIycnVpeTRhWGRaZXNx?=
 =?utf-8?B?ZzZDeFNld0xXNTU0NzErRXJkYmVtZnd0L2VBcnVVRDBReTZHbVc1T1luZ2Y2?=
 =?utf-8?B?c29oYnI4MWNVcE1pb25UdXB3M3VoUXVxOUFUbWw3cHlOZ2h4NGYrR3JwYnZk?=
 =?utf-8?B?Q3NRSGJpdXZYTjk1cXlOY29lV0ZrNHVWdUxZZSthRi9LMEpQdS8rdkF5dGlM?=
 =?utf-8?B?YnVYV2taT1ZwTGNqdkdRSFVlemJ2U2dxMzZ6a1VDRU93NE9SYnlURTZIL2I5?=
 =?utf-8?B?R2VvZlRUSWZhWFRDMDZ3SFpCOW52THIwS3REaTU4dlJkRkNPTWM5ajF0bU44?=
 =?utf-8?B?dWpzYjY2VlVkQzh0c2JtUHdtaHppZXdhOTVHekE0L1ZDOUhxdXhuUFBGRWpy?=
 =?utf-8?B?WnRCckFpRXVwbzZlL2h6ckdrTDlITGpNYlZjNFRoOXNJQ2dBdnVHdHc2aUJr?=
 =?utf-8?B?cXhQY003cEh5Q3F2bFlNNTAveThTOWpoQUJHOVJpRHVZcUd6V3E1dUxTVWxp?=
 =?utf-8?B?cUYybWRYdjF2Z1pnaXRtWlRSZFpuUllUK3c3WlorZ0NZOWVLQmwxZCs3djAx?=
 =?utf-8?B?cXRwNit3UDBWM3RMaDRpR0tsdmdLcVlrYUFtdEFubStXR0d0YmVnaThkdTN5?=
 =?utf-8?B?S0diREYrOUNuZHNEcHVrVllmSTJxbXVRSDZueFdlVE00czZGUnVmNFA0cCtM?=
 =?utf-8?B?emNoaFhzVzEvbDlCcXhWY3RQWVR1NFQwdVZlRnYvNTdRUXpuRlNpMGtJZjYv?=
 =?utf-8?B?R3FnaGs2d1pvU1l4NFAzdG9PNklwdGkrVitLS2RoNVNUTVdmUXpOYzY4Tm5Z?=
 =?utf-8?B?ZFYxWEs0dUZlTHFXQTZERWtjTStDWkRsSFZrb01pdUhHS081QzA5dkhOZmpj?=
 =?utf-8?B?RFBvZnBSWTBYRFVtNUhEKytadVlXdFpqMGNWZ2FOL0FicGh3eVArL3V6VHQz?=
 =?utf-8?B?U2pQRzBPdHptUjdZbk1vaXJjUTdxaHA1QXRCamUvUnIvRGZ2a0hqbW9Hd2Qx?=
 =?utf-8?B?MVErZ21ZY3VOSFFhSXVxaGFtUG1pRzc5b01Sa1VKcTdtb0hpRFR2SHhLZGp0?=
 =?utf-8?B?a0FOT1N4RXVjbnNoVjZ6YzF2Unp6UHpJRnpaMzUyV3M5QlpzMWN4bWx3VW5U?=
 =?utf-8?B?L0txek45bDdjMjhFMHJSL3lDelNGMDN1bXk3SmswancwR0RONEhtNk5wNktx?=
 =?utf-8?B?U1dyKzlmUmJKeWtIQnpoeDU1NTZpUzdRQm1GK2tkdW04Nng2UzBuYlYyQ3ZV?=
 =?utf-8?B?K1lSQXVHVG5SYnlaNFZZZnJOWGFEQkkzMHU3blNlLzZEbXJNb3B1WFhIWnRO?=
 =?utf-8?B?VHJua1VkMXpYaWY0SExYZks1WnRUQkYrbkF5TGZBVm1VSWtCMFc1YndKWjNM?=
 =?utf-8?B?UFJkallIa1BWekRMakExT05QRHN3VDl0UkplNUwrVzNIdTJ3QzBKN2lyMTMr?=
 =?utf-8?B?S0FzaFVQM0ZwRlI3SWd0VFNTVUovL0xBQlV4YklhQmR3Mk9XMXJGMWZkWkVk?=
 =?utf-8?B?RDhWMUt1YVpZRGRzbWcyTExNQUNDaVY2UlVXWjV4dmJZZnczTk1KVGNwN2lo?=
 =?utf-8?B?cWxZd04ybEpyTDRXNjk2akRhMjNqQmhmd0loMDEzK0M4UFZMcFJSQ1Q4bExn?=
 =?utf-8?B?MHVOM01qalRURXFTdjN0OXU2TVdwMzRKaEdBTVN2eUtVVmY0aTI0c254Slkw?=
 =?utf-8?B?UWhOZE1VMGdJZC85M00xQUdlU3dOOUx5TVg4TkVGYkRVem5KTldKU05jZXh3?=
 =?utf-8?Q?8GSwiEm7je90o?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(7416005)(376005)(82310400017)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 15:20:00.7216
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f3657f5-a088-4b29-e0f4-08dc7c04fac3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F40.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8444

On Thu, 23 May 2024 15:12:33 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.277 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.277-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    24 boots:	24 pass, 0 fail
    54 tests:	54 pass, 0 fail

Linux version:	5.4.277-rc1-g4848ef9e7e21
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

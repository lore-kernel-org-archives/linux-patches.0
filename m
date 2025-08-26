Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B633431FD
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 17:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756230281; cv=fail; b=eaW/3IWB7+6akweEm4V3SYI17zHS21pumKcfoJ8gczu9ykqbZUOp579pER7lehMCkePsuyRWPhbsdyGlbUEbQpVhUup5AZyvjJMscOJAPPtsGtq72rDdDCyHJrHPA3aRwyIiQRg0dji3YjhhvbFgkuoR1zNaT8QgeYIrsJiGeHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756230281; c=relaxed/simple;
	bh=7R85tqBA3gkeFrE4VFqVScFgXKcdVngQgHkmWkKLAsM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=lyUIVNEJC6Xe4geQCaWHpxkQ33cjXkwguiUuywmpZuxCY2+eA4K3CS3fd+wF/2hrltsh1NWf8wO23OiVrfWa3b02+WvfBoApnXcLYlABbDg7QETIgjxyUwC+fbXZggsB5nzj2ldlM/RFPW2YtKe7m26XIH3CbPabI26eD80QcQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ALsGQmka; arc=fail smtp.client-ip=40.107.94.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ALsGQmka"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sKoSOCg5C1YkJPmzsTU7ye7SUPqMV1tjAXiGKpHcP/TpFJFq470I+/nRkPk8M5x48zRnhnzcAMh6BuYJDx56Er3IAFroZEuvdX9e42cwBQLl0+N3+dvu9aRzAyw1UlRLm9dBm22nRzReUJRvq8883+kQR1Oe4zhVthgIYPbUTYICATbrOzQOD04UOqMgS1k95bcn7/mnxpXIFf9iPJ3JyYy/wN7ziPqirk6TTh+uxhHnlsXR42MuUjyIxe62ye5gLx8N7BaA1xh3PnoLr7R/LaDMkkQpzX4syybbsTfr/jqekcJMBx+yrP0ToHkjpLqg4pfMbeRzIyTXtQRS2R+uMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XZ6XahFB6aKxT+sWI1H3tLbQ81YMiblH9zs7DPvFAiE=;
 b=X4VbX/DKWzuTZdEbzBiJvreAldtZYRqp/zn+096xkl5+hA049PLPg2E0wxugYuYs/0olPgWqNcCkz47Qciz3GhkcxkpcoIOqGqAacGkkI2CDBTBfHAJPuZ8HlETBAp6uhvHm18mcr//7dbDg4MlEqpPeXNAtEOIGCGNe5UgOKuElEVlOhMNIqKxNgkc7IUi7j97m4bCL4l01/9tVsjzAyRJKySXHL1BkeSIMPa+oMqipCVlKMmChfBTtcK2/TrdIvbP6NZ8HB2QZUThviqzEHx7s4e1h/RXC5b1MuwJLA4cvhXdLJg2IKWi9T/g2VLt6G8rVJP1Ij/0x7w7Y2SHdFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZ6XahFB6aKxT+sWI1H3tLbQ81YMiblH9zs7DPvFAiE=;
 b=ALsGQmkaieH4MS4GCRi28XBPv5YqJnKtp+F8uqwRQLsbFY76e3KFaSHe3CtOhtHRUujA78RCysqbMyuBVLz9fNYmpsPzVjRt0SvIi1rdJG1PTXc/WLm3MPR+5rhCoECt02LCHLfvh6/jCQRKJ8C5ZM4Dxh5+qe7N8w+in5qsxyd8eXbhlyvQjG/VCs61qA2QJXstXOkI5r1S4MSp5fzbplCxZw5YhV0wl0rInIpflNje1mxKyZT4P9RYsj7hFbaMGQnEIE4DiC7psBmYgcUbbGYqIlW9PCCoXMiP+ABZFwsqqrm4idgMIRsSZGvIZzlKdllIJFmpIIFP2+0YKUy7jw==
Received: from BN6PR17CA0028.namprd17.prod.outlook.com (2603:10b6:405:75::17)
 by DS7PR12MB6312.namprd12.prod.outlook.com (2603:10b6:8:93::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.14; Tue, 26 Aug 2025 17:44:32 +0000
Received: from BL6PEPF0002256E.namprd02.prod.outlook.com
 (2603:10b6:405:75:cafe::ce) by BN6PR17CA0028.outlook.office365.com
 (2603:10b6:405:75::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.13 via Frontend Transport; Tue,
 26 Aug 2025 17:44:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0002256E.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.8 via Frontend Transport; Tue, 26 Aug 2025 17:44:30 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 26 Aug
 2025 10:44:05 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 26 Aug
 2025 10:44:05 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 26 Aug 2025 10:44:04 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.12 000/322] 6.12.44-rc1 review
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <0054f149-1bda-4d29-9d41-e7406e716117@rnnvmail204.nvidia.com>
Date: Tue, 26 Aug 2025 10:44:04 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256E:EE_|DS7PR12MB6312:EE_
X-MS-Office365-Filtering-Correlation-Id: a216e260-586d-48bc-9e0b-08dde4c835ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eHlKZTJmWnA5cXN5WURjWVBSQ3JPSFQ2WVpJQlp6OTZyL3gvc1pYeVdLUHZG?=
 =?utf-8?B?akUzK05XcWI1a1Y5SXR3M2dsdmFYdHdjMkhMTEhRSldSZm9tWk5tRUhUL1R5?=
 =?utf-8?B?aW5DRFpNWFBWeFhqZnIvVVhxaXJRblVuRWw5VC9jMjhvcXhmM3V2S1E1cWw1?=
 =?utf-8?B?TXo5K2RObEMrZG1za1lxc3NWNGRTZFJjOHFzVVkvUXd4bytCSVVJNEN3ZnRl?=
 =?utf-8?B?RElQQWdrdmxJZnI0UysrWGJNVUtCOE9vSXVEVDJNU1krbTdMa3pDZlJQeUF2?=
 =?utf-8?B?MGFxR3Zuc1hLNlZpT3U4T0doMU1zcmdKQzJqQ3IvUEhNaFJ0ZFFLWGNId0gy?=
 =?utf-8?B?TVZMM2V6RG5HcWJOblFxYkxnTm1aYkpydThGYjh4K05zbk1MUmgxbHdoR0VH?=
 =?utf-8?B?SG5rcjY1UmdPQlNnU0xVbDVkdnp0QXlPdWdjcVh2NUl0bitNNVhnaS9PMk1P?=
 =?utf-8?B?WEU0U2JnUlYvUitCTnZ5eHp6WjdpaUxFbUh4TUg2L2hwTTU1YzZ0Z05NMGZv?=
 =?utf-8?B?Y2hCSjlld3d2TUsyT0ZhOHZTZGJweWt3eThhVnd2NjhIeGFzTkRXUjNna3Js?=
 =?utf-8?B?bUc3KzIvelRUUW5xK1QzV0o5SEhZYjZBc3Zic3Y4Y3ZoTk5LeWVsc0ovZ0tp?=
 =?utf-8?B?SlNpL09pcHNPUEtMUXM2TE5TRzVTL21FVm4wTlNrclhaZVppV2hyMGJEazB4?=
 =?utf-8?B?Zmk2RnpPWDQ4V1JzOHBydHRJV05kVVY2VDlIWFR3NHNiM1pjV3dWbXp5SUpn?=
 =?utf-8?B?ZXVWZzJ5NkRkcWFObFVMVE1kbDFiWVp4MURoUTlHNHl4L2duMDVIbVJoQ0Ex?=
 =?utf-8?B?MDFTVFpScDdWRGFMWDRYVW1BMHY2SldHWVd1bk5YNHlMUGk5TGwxK0ZaWWxG?=
 =?utf-8?B?cmZCUEZsSEEvcmwwWnFDak54b3FhTTRYaWY4MmdVRTMxMEdpOU1JNW5maDhM?=
 =?utf-8?B?VVNuMHJ5VHVVV0orTVJucnhCSGpTMlBaMEJOdjVDWmhnVTF6cmVRRXl0Z3gv?=
 =?utf-8?B?MVJNcHNmWG53U1JLOExnL3ZKd2xKbjdhczFhNm1naUZHcWE5OFg0aDRrdUN1?=
 =?utf-8?B?c3haeTlqR0QrRTM2dDVLN3NUNVAvNFowenRVQ05jT3BFWmJZeUtEWU1VNW5j?=
 =?utf-8?B?dkJjUTErNTJXUkQreWJtZ29XTzdyajFxNnRNL3BwU0NOR0dCRjNtZVgxV0tB?=
 =?utf-8?B?eW9hR2NOUG11Y2FERkFCb29pMkJHZDFtaUZoazRmbGtrRTNFR01ZT3UrTmJ1?=
 =?utf-8?B?YnNKKzVXam5vT2U4RVJ1M3luVkFwblkvSWxNejI5QVVEeEZXZTFJMEtnM2Za?=
 =?utf-8?B?SzNiSEJsbEVUN2pvZlA1MGdIZVdWUitVUEkrTkhnOW5YV2Q2WFFKcXAvOWc4?=
 =?utf-8?B?RGo5aGtlVkd6dE9ZR3Fyc0wwWFNwemZxelNEMWxvN0lDSG81c0VoT3JvbzZv?=
 =?utf-8?B?WkpkT3oySGxuOTBmeWFkMEhnM0NHZStQN2N1SHpCZ3VraSs2bTFnbWYycy94?=
 =?utf-8?B?RlBUR0l3dkVHL0tzd3MxWkxVWndhVkU2ZUtzdytSOGxsWnFYakpkT3BKMU1R?=
 =?utf-8?B?eVplNXhDY3NXVGRhYlFGbGNpU2p5cVJPQjJrQVZYWnhNS0FFQ3l3ZElWelpX?=
 =?utf-8?B?aUxOTlVYZjJWSzhRczJiamMxZzN5RVZXNSt1UEFJNDZHSmQvVXRWRnZOMWtw?=
 =?utf-8?B?RFZQVHY2K3ErMkM4MlFPQjZDV2g1Y2F3ck1HZkNGMXp2Tm1SQzNOTHptaG1R?=
 =?utf-8?B?czUyaDUyb0QwRHBRUHlnK1NUZkFUcDlJcERKRStJQWVSVzFSSmtxZENUZTk3?=
 =?utf-8?B?QjRUVmxaUnJ0Mk5GZkRtdE5VK0F5TmFIOHBvSDJEdjBvNHNIdGNWZkdUZHdW?=
 =?utf-8?B?S1NOdlFVdVc1ZC9tOHVOQ3BoaGNBQjFrVitJYXpkeEgwOE0wd0d0eTR2eHRo?=
 =?utf-8?B?NWtKaW1jdVVibkNSaTA2Uk9hdlFJa1hzU285cVFFMFRTZ0JtWlMyM0F6aHNp?=
 =?utf-8?B?bmthVXpMei9heXpjTWtBaFhiNzVUb2xZRjNna3J5TS9Td3poZzZtTktFMjdo?=
 =?utf-8?B?VEp5dFBRUGM2UnJma2tXTSt2VVgvZEFSak16UT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 17:44:30.1892
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a216e260-586d-48bc-9e0b-08dde4c835ce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6312

On Tue, 26 Aug 2025 13:06:55 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.44 release.
> There are 322 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Aug 2025 11:08:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.44-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.12.44-rc1-gc7e1bbb35205
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

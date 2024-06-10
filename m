Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA881DDEA
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 15:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718034901; cv=fail; b=IKXDg24WV0T1WHQruku6UyVS1llJPAYfXkQhShFzqwhLvMKffPVFePziJ4OT5g7BAXoJxsZOxlqeYO92aP1tpizWlahmaN6+4UjZoeQ9E2dvBLV1FVAJQKUITOfy8/rS93H2rg/a90KP8R1007No41V5nAgho89+iPDPIbO5zCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718034901; c=relaxed/simple;
	bh=NljLrnRFpKri0xPOW3u9lvBKPg8D1w1rMRXe9GV6puQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=gOw9vZu1D8GcH2U8SqdctgjFY8PS+j6RsD3cMcJbGB+48yL6i5jmZwb2SDBk2DYawEcrLkYAySK36M2roiCztOySa5tS8MszaoV7vYIeP+0YD/VaTCgOWvEZ3bDT+Owf8Eu8RWATARbOEqg6V1PCiWbhqEWkwSCF/i/5ouFQ+r8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CdcAlwNR; arc=fail smtp.client-ip=40.107.237.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CdcAlwNR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWFbalIT6UEWJO91Ms+HIrlqSq9yuPDLQmFp8sM93k6HvuQThVy2nOYsFBSCia05hHvZ3nBveMeznloOCnEOW60joyAmG5Uhjew7hMRGr3745QEzB8PVzMVeC2Ky4Ti7K9SiksldGajebjWLzpeB5FKtxCa+58CT3+VZT3y83BYSeOCEP7ILuVmR7U5ZG1Gx3DcSuat2Kpsn6NTxh3QbP8d9NLFVqzJT8uEQzp0jiSGufkLlQJTCZD/UxqLnDpeZxCdrXM0Hy1Vs0G9ISCZMOXSbGKMXOcMrzuStUyf00ZrgMpYQWCeY3sSZJn+o6LG6d6mmfgDA+TC/zZaq+G16yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/NbLeslT0yf5xtweBKCAYrEB6tSxhCtt/MGz/JXO+GU=;
 b=Qv0JwcFGkWnlYcxcx1KiDcQvhL2HjX8KObZM73chf4V7FQYlJG/tniV3CHPXJrAAKF3+zDO8xMs3eFEdBjD5N39J9ppAu6QiLME+cMMSwksbt0StgMpC+67MpTZkgs1nTQOJuZya3rqWsMjwGRKcXxW3KyRUGF2FKvv9BqxgGnHw72CONRQwauWoxrWpG/d6kKw6zULIPnWWWXoSMUFa4cPkm0za0cbfxM3FBSqWvCzOukxidJRCU23q2zswM6rMiJFcJQgHGaH92u6HOLJ6gz1jXQr5W1UKs46wrbMwOAbaQ/csU1prjQoa2GmbJUEyfEKPA080DJYZIZljwStSQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NbLeslT0yf5xtweBKCAYrEB6tSxhCtt/MGz/JXO+GU=;
 b=CdcAlwNRTtJF4F7nmxDUQMpqDJa4/G9acIAu44c6If0yoOXGG/mryLwixPpLsmIxqoC4WzgaPzs56Q4kRmlDddYm7ZtptFZPqE+kqAJZjxgB7K6YsTcQ95uajjajphCIi62OJaIskDO4SUTz/4/3AYBO33CQRGF5fzovBSPc/XVOB6cki40NUqbMm+TLM4rPvrPCgMBOTJvnJiVXhNPnHnyP+/PT+iP+hy0nM9CY1P5F2WFm4Jm7WMXOMQbKFyosgIXUqxzjc1vkDBtsCqLrDe8jxOOz+vgujZwDLG5PFBPqCJK66UJ5cZFXRE30AQPTcK3MpwB5IXCDoY3mxCWQcw==
Received: from PH7P220CA0046.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32b::10)
 by MN2PR12MB4407.namprd12.prod.outlook.com (2603:10b6:208:260::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 15:54:55 +0000
Received: from CY4PEPF0000E9D2.namprd03.prod.outlook.com
 (2603:10b6:510:32b:cafe::7) by PH7P220CA0046.outlook.office365.com
 (2603:10b6:510:32b::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.25 via Frontend
 Transport; Mon, 10 Jun 2024 15:54:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9D2.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Mon, 10 Jun 2024 15:54:55 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 08:54:34 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 08:54:34 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 10 Jun 2024 08:54:33 -0700
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
Subject: Re: [PATCH 6.9 000/368] 6.9.4-rc2 review
In-Reply-To: <20240609113803.338372290@linuxfoundation.org>
References: <20240609113803.338372290@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <8c1b9a4a-5b03-4da1-9b03-60adfaf87ea4@rnnvmail202.nvidia.com>
Date: Mon, 10 Jun 2024 08:54:33 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D2:EE_|MN2PR12MB4407:EE_
X-MS-Office365-Filtering-Correlation-Id: 4837bef2-d2e6-47ae-2053-08dc8965ac2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|7416005|376005|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SVNNRE4yazgrSnZnN3RwbHZIMllvYmNpTHU1Sm8yeXBJZ2R3WVlkb01sM0o4?=
 =?utf-8?B?NFU5RnFPV1dCanNDYnB6aUZlYzNpenM1aUpXSVNSZDl6S01vRlNid09RUUhU?=
 =?utf-8?B?Um11MG9XdFNNeE9YYW5GbWdDS3d0YzZ0bFhRNU1uVUo1a3F4ZzFzY3hiWDRF?=
 =?utf-8?B?TWpKWlVHcTAzVUp6OHc1WXlNZWNNZ0EwWFByVjdPbVZhczdqZWQwWm9LcE9l?=
 =?utf-8?B?Um8xcUNyOEV6aG9DenFBUzdzMTVNQzBhM1I0UzR4cks3NWp6eis3WGNROXA1?=
 =?utf-8?B?WnVtV0hJV0tqQUxqY3d3cm0yUVVHTEV5cWNvZDM5dnpSQ3JXWDVrSWEzeThR?=
 =?utf-8?B?K1l3TzM3cmlXMXRkMjh5d2FQdmFTWWFUaXJVSHZiTnFNalVFY0o2TkF3b0tq?=
 =?utf-8?B?NkNYWWtNM0c4Z1VERkpleW1MUFprZGY3ay8vUWZGKy9kOTdQOEM0UlhsMWVk?=
 =?utf-8?B?TDdaVFhVN2N5T3g2emJ2dk4xZnIxNTZjTlZ0SFQ2WXlNbWV6YUhuQ0V4M1Bt?=
 =?utf-8?B?Y3BXZmNUTUpYK2pvckZ1ZlYvdUhnck9ZNUxETHlUTmgxNnhTTWZCY0RTRHFz?=
 =?utf-8?B?emJGdjN5ZkdnY1RERmFkeGxjQ1l2QUhKc3R2QXhPNm1VRVkrNVJRODhZK3Fi?=
 =?utf-8?B?NnlQUXkzQWExWjdyM0RiMkdZN0tZWkdjaHMvYjdZZFoxRWNLTHJveWNDZ0tp?=
 =?utf-8?B?WXIyOGM2dWlaWWFXSUg3b2tDMmErNjdIbnh3TTd5KzU3eWNDVFZYOC9Ea0RW?=
 =?utf-8?B?eEZXVWZmTWlpNXpwRHZYUGVYK3Q0ekxTOG83ZEFyYU0zZmxRRVBWNTdLYUU0?=
 =?utf-8?B?d2ZWekdNemFGMHpJdFhKem52WEtmLzlZNnVSSWwwYUllVG81WlBtWTV3VEh3?=
 =?utf-8?B?cjJ0b3dwRVY2UUJDWXUwMTRiWDVrYjdoY3gvWUlQZUNDNDVhRVFPQnN4dko3?=
 =?utf-8?B?OS9sRythbTdHbG52SzJIZm5KQzE3ek9GSFJoUlFlWUFCK2dNSWxHaWh5MURL?=
 =?utf-8?B?bVRNVUhhbUs3MjNIUTliOGNPSUNhbFdsWi8wLzk2WWVKY0R6dC9Ldy9WaFRG?=
 =?utf-8?B?V2xXclJlaDJyelEyRWdaNHRuSDhzWElhMWdTWkR5ZUtpTGpVV2NBUjNrSmNk?=
 =?utf-8?B?UE01TURzRzZ5Y285V1B0b2R6RVMxTmdaeU9XWmFLMzZMV2JEZE9hWFVZWFRz?=
 =?utf-8?B?UG1sNmdFcFUybW1kSERqemRyczI4VUg2ZDlwZDYvZWNnU0VScXRFRkYvTlho?=
 =?utf-8?B?S05xMUZ3aG5YZWZKUVpuSXFDWTBtaU1HY2RhaUJjNzhTNUlvNHNVNHVIUGZJ?=
 =?utf-8?B?YjJaSWpCTDB3S0Z1ZWZUOHpZMVYyN0NndlI5WGFaN3RqVWpabmtxVndnYlAy?=
 =?utf-8?B?RXAxQTdZTGdNeEFqS05SczJ4TkVFV2FXME5MSlpONnJIMVlRU05aRXkwR1hE?=
 =?utf-8?B?YnFHUTEreEFsWVFKQ0ZMem9tcXZWWVZwd3RWN1d3b2NBZWRMQlVjeUxidEhL?=
 =?utf-8?B?WllyOXhhNXBuTWtrbEQ4TXFSenpGNkxCL1NKbjdFdHBnR0tKZnBoTDhMZWlG?=
 =?utf-8?B?NnE2WXdDL053U2t5U3N6eXg0cjJHMFAyaXo5UzR6ZXJ0RCtpTG52TmM2ME1z?=
 =?utf-8?B?bVFyREpya3ZqRHNzZHpqSGwvREhNbE5hTndYYzVtVC9qWmpnTjlYWFYrSitw?=
 =?utf-8?B?MFAydjNjWWxKVTErZWhOdGk3eCtHVkxUNHNlczRkU3RSeE8zR05QUm9sUVBz?=
 =?utf-8?B?b2lhbWtnbW93WjM0UkdoRmJBMllZZWNsNE0yM3BENWxLVGt4NkMwSUlTeFUz?=
 =?utf-8?B?dXBPWVRTTTVqZkVXNkdhV2g2OUxIZFVlV1U1RWtXYVBPajlTcjZxcVhzY0xV?=
 =?utf-8?B?VlZoTXQ1RUZOSmhDL1BMWVFyeWdPUkhEUVFRR25WK0xNRUE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 15:54:55.1505
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4837bef2-d2e6-47ae-2053-08dc8965ac2a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4407

On Sun, 09 Jun 2024 13:41:29 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.4 release.
> There are 368 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 11 Jun 2024 11:36:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.4-rc2.gz
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

Linux version:	6.9.4-rc2-g4aee3af1daf2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

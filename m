Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2084.outbound.protection.outlook.com [40.107.102.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D3728D858
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 09:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749030086; cv=fail; b=KgiZnS701YvMmoNdBCdCDsAZpKDtKAB4yEvDNPp1HI4RaF6dYt6weVFFW9+IxpeyEAoXDRjbvKS+7OeSkGQXrlMQY7PwLhFdVJ/DRn/x2J+5NJTQi/55ItDWNEwvDUNTbNF5ktoz57pd/QKIcYm1EuVMQznnBfKVOpX+AEyovEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749030086; c=relaxed/simple;
	bh=qyeeTbvPcYxea8NhVOOg3KjM6iiyozaG7FrTilmpuD4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=m4SiQAslv/HowoK5nhzHKtaA99e579uhc1hJmvSvdc23dfvLVEcGENrEXxTQ9KSCWcatpw6Hnh6ldyzrMM3rRzy8CoHxj7iZjpJ58NYe1YkR83tPz4wkqkHsH0E8D/84ohbktxaoymjK6ylRSdwVU5td6dlo87bbPfz9bpZrusg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=T89gSZqL; arc=fail smtp.client-ip=40.107.102.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="T89gSZqL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yJ3IQZXJApG64Roat6KKvyAKUGFCpKLyDxHomQwnWEir/mgQIGAF/YcDc+qbuTDkRXGsPTMlwZOxGZoBjXiCO7PihgKPvJbRUJndr4/e26fVONFCzP+Rx7TUT4VsWyDQSBHJ2Wfw6KA+BLUZoymOWFdm1QzR42BkQoBicDnYll4RkCQ6K+yfIhhar5wbRrGgEy1S+bZdDKDZq+gCL9oTlAWKKAoWDyQ+Cfg/sWuuv7EPtwlTVJ29XctkGMI7qL4uWcv/oQWd1SBtygEIMf67jky6hI02V+Kwz6Ale0qVczwnJeAbJAYQFy8Kmhu2wVhQ1gOA27USEOS3dsm0PF0cYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4a5/Ttn1vtOHDtDh6Jt5i+x83N3VMt/0ysMP31NV4/I=;
 b=WiFEJ6BZE28ry6QfeR1bSIWDrHb3atotJbh3MW1mtRithza38XO2Lg4Xs76bdduQfquyGR4lMLl34W/IokWFx8xuRhT5vP+c/duY5+k+mo3k4bURiBMjMeXL6CL1zKQFNCYECFXMzzd4h7IDXK/h6yvgIdgSE5rFfKZDlnmjPHsKXTxCg0FlgmQMqXVB9A056Wphjl4BrXotTYb9iwF64prKuNr1dpGaGqX6xIY58BVI+/1OTGDG+fLD7zoBJh6Sxmqwl22+KwFfkHz6OCFfY4z7Dp7rPCoQ38mD/xykudjtxv5SS8rbYIa9EZH28tgc0th5Pi/9vSPmlOM3dSfzRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4a5/Ttn1vtOHDtDh6Jt5i+x83N3VMt/0ysMP31NV4/I=;
 b=T89gSZqLPXioq4iE5a50xKxJ/FjLFOhJUjW4HsTwtaI8JRBodiEs0ak2gZaqrqm9emZ5VR1L8OS8Ph7gs+4SMnpzrTHaVF8tkp0CwsOk4j9U8MSxIu67ku1X7UofcYzvwhnaZHcmygjYYmOlv3HQ2td7P6Ze8e+QWLUaQZAgSW+C8P8BgXnA2Fa/HTNgA/djq9isDwnvWxaB3oNve1aiefx2fLrOTd5fUmQyrg019oitMUgVbGN+9xl+BkaCBeNr/7aL3DQRnlnGkw4gnXYIpSqoH/T/8W+efwpFkd7TyKlDDQfa2+HHwLAnA7GF39w3oo3f0/4Jo4kMn1tggMsLNg==
Received: from BY3PR04CA0018.namprd04.prod.outlook.com (2603:10b6:a03:217::23)
 by DS0PR12MB8442.namprd12.prod.outlook.com (2603:10b6:8:125::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Wed, 4 Jun
 2025 09:41:19 +0000
Received: from SJ1PEPF00001CEB.namprd03.prod.outlook.com
 (2603:10b6:a03:217:cafe::d7) by BY3PR04CA0018.outlook.office365.com
 (2603:10b6:a03:217::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.30 via Frontend Transport; Wed,
 4 Jun 2025 09:41:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00001CEB.mail.protection.outlook.com (10.167.242.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8792.29 via Frontend Transport; Wed, 4 Jun 2025 09:41:19 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 4 Jun 2025
 02:41:03 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 4 Jun
 2025 02:41:03 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 4 Jun 2025 02:41:02 -0700
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
Subject: Re: [PATCH 6.15 00/49] 6.15.1-rc1 review
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
References: <20250602134237.940995114@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ed0b9e61-a726-442a-8551-92eca4d03619@rnnvmail205.nvidia.com>
Date: Wed, 4 Jun 2025 02:41:02 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEB:EE_|DS0PR12MB8442:EE_
X-MS-Office365-Filtering-Correlation-Id: 111d5a76-66fc-4bb1-9afd-08dda34bf58a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|7416014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WmtSUHJsa3FhSU1MTE1mcGM2dkZZUy80L08ydnpnZzdCTGE5VGZ4emt1YjI0?=
 =?utf-8?B?N2FVV08vMTltVDQ1MjFtTnJCTnV2K09SeEdVcGRZYnBsNEE2MW4vNmp4ZGlR?=
 =?utf-8?B?OTNTSnQ3SENJTmRoRnBobThCaUpRZTVWSGw1akJERlVPYWFwNG5sVWNVZGp5?=
 =?utf-8?B?VWpWeWcvamlWenhob2FrV2UzTmRubWkwUmRCZWpObG1kTnRSbWFMRFFsMm9Z?=
 =?utf-8?B?N3pkZC9QYXcvWGtGZWtOVnk3Q0ZsYUtycldSYTEzSTJZL0lqbFZFQWF2Z2tP?=
 =?utf-8?B?a2laYkJ4YXlxd3Nsam1GcjBpQzd6VEJYbkJHcVFGdWVCeDRlMWhERlFBdm9I?=
 =?utf-8?B?VnJNaGZLenJQSWxRMnZFQmhXMlN6VmcyNFkzL05RbEVMQ1RZMGRGNkxBMCtE?=
 =?utf-8?B?Wk41Q1dsc0JPWUxGNVo1VE1XQkZKWWdwN1N6Z0NTaUpGV1JzcHFoQTJpLytU?=
 =?utf-8?B?MlRkQS9yU1FBaThOY0xNU2xsRDdhTGhmcmZrQklMTEtEL3kxZTcvNkZ5VEpv?=
 =?utf-8?B?Y0RuME1qS0JIVGxFa09zRUFoaWNRdTI4b281UWhuUWpaeFNoS1J4VzBPUTRo?=
 =?utf-8?B?R2h5UE5XVyt5VmFYaUozTWt0Qm1CMko5eWQydDNxcWRERGd2bVZ4TlZURFpy?=
 =?utf-8?B?ZXR6V1V0NFJLN01VWjg5QnRsZmJNQmVhRFpUV05TZW1MUFE0T2E2UFVOOHBi?=
 =?utf-8?B?Y1EyMFZBN3VnMUtPSW1oT2ppUFZNZ05FNVVuS2NYUGNPc1Y5UW1mNlNoS2NB?=
 =?utf-8?B?VzNPWVNOTS8xb1puR2FNRmNpdllvcGc1bURiT2NibFk3YTY1UzlROGNVR1kw?=
 =?utf-8?B?ZlM0MmgxWnpEaThDTjBBclAwVnFmS2tPOU9VbTQwdHk2L2NPc1p0dmllbEE0?=
 =?utf-8?B?ZTVBTXB2VTJrL01scERUZ3VOcU4xQ2RIeTNNbEhzaHNxYlQ3OG83UG9ndUdz?=
 =?utf-8?B?ZFpyOVhOZ0pMTEY4eE9jS3E4UWNnZHRiaGRoaitEdGtLTWN3TCtwcldhYVNy?=
 =?utf-8?B?NGx1aTJ6Uk1LK29DQzlUYW53SFNwaEZiZ3h3V1lIYUVPSHBpcElEamNGSUdy?=
 =?utf-8?B?QkF4NFlkcUpDaWxZWU5sblBtR2J1TVhnRFQ4YytsVGlWaVpXalBLN2NpcjNq?=
 =?utf-8?B?cGdsMTNmTE9ja0krSDI5RWMwMm1KSkdjb0ljVFRDelQ5eVlIVXFEZU80K3M0?=
 =?utf-8?B?aUNnRFZzTTJpZ0hLUVZCaXk3dXFONmRXMnhXTjExTzBJeTVYT1d5VkFpTmxG?=
 =?utf-8?B?MkNEcnUvUloyclduamdSR2JTN29CZytMb2RWeTRpbWJZQ1BJbEdCMVVNUUJu?=
 =?utf-8?B?TFVaVzA5Y1AveTdaL0hveHJFQXJlYWk5SS9pcTBGbklDZ2R5MjZyVGNDRUdB?=
 =?utf-8?B?N25Ud3hVMllvNHJtMFltNml6T3p1dFJoeDdGMEluTHU5djJkMFNLci9GNmxv?=
 =?utf-8?B?WFIxcW1HUHBTaERQcitsRlFtb1RBaU5pd2lQbFFYbFVSd0lta3NFZm9icmZU?=
 =?utf-8?B?UEdsYTQ5d1NDQXExSm9IaGlHWlhRajkxNVJiNEJua0VEaHlEZkNLSVdtbU5R?=
 =?utf-8?B?ZkU5L2dBWmE2K3BIZHhqQTFsRTQ2MG0wb0I4U1FJTnQvTkNoRURScVlRTVRy?=
 =?utf-8?B?YllGQzVNR3VKaUFKOU4rU1lPbEdaQzd0M3ZvMDdwVWhPL1pueEFLVVNWaVR5?=
 =?utf-8?B?UHJ4c2dqRkZLMmxvdWtrRW9Iajl4WklyRHZvd2hZemVjM1dDN24xcGVBVHdD?=
 =?utf-8?B?eEpQUW1LRjYwQXJtazl1NitBUVNwV3BZRHU0aGhqTytxdnkwSGtYQ1hKQTkr?=
 =?utf-8?B?S2Vock5mNmZRWU5qdkZyaFVTQnlLRDFXc1RxOGlKMC96Skd6N0ZKcEM2bjY0?=
 =?utf-8?B?aGRPRitMMkU5aFZML0hpelplZ1MrcVU1ZkNudVEvUTVNczdFMW5GZmdnQnZH?=
 =?utf-8?B?WGk1OEl0L2dndjZMVHZGVjd4Z00vQ3YvcC9taHdOMXhMZEtRMGs1dTkxWElC?=
 =?utf-8?B?UVJzK1FGT0JHMWxPZm9DMklGdmFMY2tIdGYxWm9XTmZFRFA4UGVUZjJ0MWpO?=
 =?utf-8?B?K1NZQ29xTGxZRmNWaE1uVGlrY2FWVHlob3VFUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(7416014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 09:41:19.3261
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 111d5a76-66fc-4bb1-9afd-08dda34bf58a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8442

On Mon, 02 Jun 2025 15:46:52 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.1 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.15.1-rc1-g86677b94d603
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

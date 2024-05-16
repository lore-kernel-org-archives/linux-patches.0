Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2076.outbound.protection.outlook.com [40.107.236.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BEB1E516
	for <patches@lists.linux.dev>; Thu, 16 May 2024 12:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715862889; cv=fail; b=iMHkX0z/2Ut+C042fJ4IM5ccUYCECm90ZgTVFZYcQfqf/cqxsS9RTLHSxWMCzB2APpx4DB5f5xVBTGwFLFhTaniS2MSNal7CiviAclxxEV9AT90md+JPhZXFtSBQYYEQyuIBw94NgHYnl/LvNK77Lk2PgRW7QPi9EQqAUTFW43U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715862889; c=relaxed/simple;
	bh=D1+/UVI+p2HOMd2Ta8iZLrz75Z/xu/hFgxTzRPgrkoo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=nVlXvNhppkZbSFOEqCFjH8hgU6yj5g/UlmqnkKepC9uxHKtZtJoBM8xtC1g0bzCZ/eIkLE+cAOy7PizcNR02udPFzdwmLwAA6iUIiam6L2thEyIUVpq6LpHrbrgtaM2bNVcE/twc3rFC2tt+kX2Sa6vGcFVZFx754i6I9lOaxcA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=g6uC5g+A; arc=fail smtp.client-ip=40.107.236.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="g6uC5g+A"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYHr0ceS6ukMMly6aRV8lNJ2ACo2qZQOxdmYwUYA311Nqa7ciMaJxX00toWARCHwqkRvkWd9QSIA4RSvAs9yQIOK5D9VFK2BUoeHCHJOTp11gVNJLMxZ96Lq8anlcv6QRV54EtT5ESJg2arBou+qh51+AE1H0w23WVGrXW2ixa6H90fJNNT3Y1qz5yMGXl+r9CM6EsKNmJIFOeDfVAlg9CSohB99BLrcvYTBP9kAAZjeFSgWiZ1ezPGjdIqIQ6RhGEYl6v0298ypPML1fcnarH86CxEnNLfGyhRvJup0e9jSd7EW9FovSWOeDPOoFRwJm/hm1obQ9vAAwiV44Bmadg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pzk7MfUAwr6cZenEtNlWOzH08yvNkv2NdNXL66RU+Wo=;
 b=QpvhhENN/f1BL8BcnEE/yJ74FbPVTQzorq2N+0QpjghYWP8WmlDhBsHXCornmrXVu3HcDeYVJJL3yYh6PrXV94AW0amjdo5iYmjh+mb1uiyO1cec0YVlIGILJUb4/CcXECLq4ipp2cJcNLUoWtNDWKb3d2QHcxn40+vBKAwEpHKftft/jG3c41X8XrTgiu7MT8UFTyA1S6VMXGH7dS6ZLNxyEaiThXBwTgQFBihOUNeX8CfmsbBd75UTbmryHqHPPfMEBs68aNRIwnYjalSpUyawN3Epj9RX/fiGAxkzc5nNQIn/ZFstk5NBI4h+bY9lrCjYK5LmbuSieOlDli8Mkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pzk7MfUAwr6cZenEtNlWOzH08yvNkv2NdNXL66RU+Wo=;
 b=g6uC5g+AG950AZdn2DFLsFcMaJdwkYwTiJ+EkgQ9eP7htDm104qEI9DqW5hO77pkUE+UquDdL1ZhoqjsD03ZBaDhW5wn3WZmfZ+XbmT2VJOX+0Nk9k1CKTfKb8uynqtSCVoncA8ue803v5eiIUsLt4Qe3kwLIL5LczkGDX31ZsHsf96JC0DesYpZaUyY/Mgg668sz2de1l3Ec9EDYaSSDibI7HNCkjvKtFmdYSyi1re2sACzT7RRQtbPqAsYk93oNqpUmjTs5Ji1zSq2rNcwNC3p36vHY58qB7FK4IzF3uU15qlSNmPHhCt4S0rkLoTpNb7CdHItaJwWjdOnY4l9QA==
Received: from CY5PR15CA0110.namprd15.prod.outlook.com (2603:10b6:930:7::29)
 by MN6PR12MB8543.namprd12.prod.outlook.com (2603:10b6:208:47b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Thu, 16 May
 2024 12:34:43 +0000
Received: from CY4PEPF0000EE3F.namprd03.prod.outlook.com
 (2603:10b6:930:7:cafe::43) by CY5PR15CA0110.outlook.office365.com
 (2603:10b6:930:7::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.29 via Frontend
 Transport; Thu, 16 May 2024 12:34:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE3F.mail.protection.outlook.com (10.167.242.17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Thu, 16 May 2024 12:34:43 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 16 May
 2024 05:34:23 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 16 May
 2024 05:34:23 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 16 May 2024 05:34:22 -0700
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
Subject: Re: [PATCH 6.6 000/309] 6.6.31-rc2 review
In-Reply-To: <20240515082510.431870507@linuxfoundation.org>
References: <20240515082510.431870507@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <7849f2ea-abef-415b-8b9b-223ff09c3cd1@rnnvmail203.nvidia.com>
Date: Thu, 16 May 2024 05:34:22 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3F:EE_|MN6PR12MB8543:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e06bf9d-88a8-48de-f362-08dc75a49069
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|1800799015|7416005|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?endlL29DbnhmRjJudFZrZTVzZktqcUwzbUpNWmJpaE5oNk9WcCt0cVFwMVM0?=
 =?utf-8?B?WG1mVG1tNXI5MisxOVQ3UnljWGhjdmxDblhPTzVqcmgwaWxreDkvak9sQXN2?=
 =?utf-8?B?VVVCYUF3RHA1NkMzQWc1QjZxbG9SOHpKNjVKRTFmbjJQTnB1ZU5PZVRuZjRq?=
 =?utf-8?B?U0dlL29uQUZ1bGxMckV3VGNXazdsa3BwR0VPVER3azlCV20xNkZuQWxjaStI?=
 =?utf-8?B?QUpQTHJBT1d4VkZPWkZOQVhBWWo4Umo1NEJRci9DMFRicDRTK2tjOE9YSVU5?=
 =?utf-8?B?THJQSzQ1eW52cWlsN0xTZEpXUElUa0dKTDNMZ3J5VHAxNHFUYUhMd1B5Zm94?=
 =?utf-8?B?YTM1MEhoZ2FKa1g4RWlqMm9idjdvZFhldzkyYUlZT2RpeTZndUNnc0ZCS0Q2?=
 =?utf-8?B?SzBMOXNtbmVEbXNIS3dBb2hyNWQ5eVdUWkc2QTFkZWVzcmNRUUsyOCtnbWFS?=
 =?utf-8?B?SlkwYlFlNm9ZWHpDNDJRRnJSRlVqbktyWmRIRWxyejF3Nkd3Z1V5UEo4ZWNR?=
 =?utf-8?B?MXg3bGRRcC9nelMzYzlHR0ZMbFJzZXZ4M3g2Wm5mMjhsb28yYkIxcnBVdE5h?=
 =?utf-8?B?d3l5eFBBUGttMDlMbzNKaTVTT0VlR3RDSnJtTzkxSGErZlluM010Yk5WU25l?=
 =?utf-8?B?Z0tnUlZlMjFDZ3g1Q1VBZUJETmlVZmFVQlNjaFJLakpzUlF2Vjh2aWl2MVpq?=
 =?utf-8?B?VTE5a3VXS0JMWjJOTlhjMVE1VHVRMGZyTWJSZFNHeSt5dkw4alRLMDN0d0pn?=
 =?utf-8?B?LzZqRTY0K1ZKdjhNZnBndkRKdC96ZEUrZnlUYXAvN094MG42V2lpNGZ1c1Z0?=
 =?utf-8?B?OFJWZWRaQUVRR05weWRlbk5PbFVPemtWZG5BemFOY1MxeTIzVXdMMW1scWdi?=
 =?utf-8?B?VWxyZDBYWGN4RXZzK2czcTFjQi9TQlRTQTRlenJpcTkwUXlteDh3eVh6c1Nh?=
 =?utf-8?B?NERNQTg4SmVkZldUT2R4elcycDIxdlVNR0dCeUFVRnRMTGlKdmNOeFRYa2pN?=
 =?utf-8?B?S2VsYTRDKzQyWG8wcndhUkk1ZDZ4b0cyeGZmS0NtS3NMblArVzI1NnJmWVRR?=
 =?utf-8?B?SEVsYlFGbTdUTXp3VU5mNW0yOFFUQUR2MjJRNk55bnp0UjlmKzc3UGczTm9s?=
 =?utf-8?B?RHM1VTZ5Q2ZNcXRxWnF5emRaMDllV2ZYVE0xWWh0Sk4yc2ZWVzVHNEw5bHUr?=
 =?utf-8?B?Q2M3RmRqU3lVVGlNQWl4a1pRNlR6NTRiYjRwVlpoQnc0MzBWd3ROc0h1VnZr?=
 =?utf-8?B?RTgvTnhHU1g0c0I4TjFoZnBEd1ZrdWJwN0orWXpBQnRFdVZSZjNFZko4dmxp?=
 =?utf-8?B?VHRrOWY2ZGx6NFBaS01GeXNjemcvSkFKOWYyNFUxazQ0dnF5QmR6VllMVzc1?=
 =?utf-8?B?K1J6Vk53YXhuVVEzVEVJbWorUE5kcW5xSms0SGpmVytHTEhBaXZMMm0zU2Yw?=
 =?utf-8?B?QXRsSjlEM1dHSXc1RXRRRGUySVdkUm5WNGVIOG5HTEk4aXZNcERuYlBzZkEx?=
 =?utf-8?B?Yk9VWXZ1QUhBelZTSXowT3NiVkowWHJ0cUw0eFk4TUVCTXRJbmRENnFnRWRs?=
 =?utf-8?B?VnYySGpEWXFxYitLU0hXNzR2L2hHYXpQUHNndGVQcXZXNm9Bemx1SXRwUnl5?=
 =?utf-8?B?RXgyM21MbHYxNTZOUVl6RUpVK28ySVNVcWhDdEZDRk9kR3NyVzB6MVhKVm1C?=
 =?utf-8?B?L2dGOE1HVnF0ZWZrUXJlajZFdExlOVRjYUxDU2ZTQ2NBdGsxN2hsZXBDSGJW?=
 =?utf-8?B?Q3BoSFgyZVJWTDQyUVF4Yklya2hsM1Q3WHZPM0VqbzBmYWE3Wm5tRUN3bHV0?=
 =?utf-8?B?WkwrcWFhbDZIOHN0VjcrZE16dENVVzQ5elhNYmRaMkMyYmtNODdZWXd4dEh1?=
 =?utf-8?Q?GeG78AGYqQpiX?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 12:34:43.5998
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e06bf9d-88a8-48de-f362-08dc75a49069
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8543

On Wed, 15 May 2024 10:27:02 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.31 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.31-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.31-rc2-g0b94bef0cf16
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

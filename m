Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DAA1D6DB1
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 18:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731694306; cv=fail; b=Sw3BLhSj9Jkmqd71exGKONQDzdYguU5qEWORgxbF1FOqi8pAKp6vzxkvvKqX377qc0tbSr734Qa2EiKIiYN4msbSCDJWxPZ2WlEGQitMeVT5VYd1JfWlOhWd6y6v511AaLUHSVxXa9c4zWtos51oILikgdpanhHtRs7eW5JdL3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731694306; c=relaxed/simple;
	bh=I40g/Wg6UqgHYaS2N+uqzlUL7Ya5t7lNdXirM5CFZfo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=NkFnYkgctQ7Zs7OBevCYMPIClcMD2uxpBekQmsWl1a8V4Aw5Trt0ImwLJ+axgVfJu61pibZ4Xox5H2DNBUyzqAKLaX+4iVufzqn8gs6C9TbOAOWp++d0uJvhYf/ULCtj4HQfj0H1GqgT/K9izTE+UE/ODe7N1nHrfVXDTNqpyfc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qSHFX+yH; arc=fail smtp.client-ip=40.107.223.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qSHFX+yH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TO+CUpdMls6y/HgwQy8wz3lJyog0WC4nhXxubvnnOTuP2tmXbvson5QX5LutXYMKwHTYgewdmXa1uuaHPwgPJs5+DG2DerlUDdXSaveGXVBDjIKFfsR3tX1oE9/8tENs4AseSG6+lfRuDBxm2FUzkzDqrLhLvzLF4e5u8O3Rf4mtNRMHpZNAKhnMkQ+X4jLt7UYg44dsVbJ4iS18TbPVGdaeN6gpZHLrYPuYibY5Fz0SE3STMK/Rkwxi+5ELJTrxSk1iViemsh2VoB5ejiLEJqESw9Rdg5hsgErmNBWQ/zzdbEwjbfsKQ47C2mwFuNf4LhYIFkJcMzUuw4av8uxEJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5VaUshknnn1p8zD4ompG3lsbz57LMR7mjbupCIkhWMw=;
 b=KYzH5VDmSxAzvAnr3VJ+zEudPZCfIb5yJtL6/+HAmjrXJMsF5wBjotQ5vmyWOHpvjuaAjofKrjKUQwYN/EQHK14A7Z3SbVCdcfemXn53JHk9Ctwi1sioCsD+EAtXqtGUgHN7F3NZSkMK2N3Xhi5YEZuQFIf74BQ3TrjS8u71YzM0RUTpW3IFaWaE+PV9Vyh2qCSvaGt3MEzcbys0ZQYkVg/GAWaJson99XzMvmrO4GuFmtErXqsRJhls2Y+bUVijNfQA/3TV96bZGGUj54JpIcYm15/XacuGwp+sXMGQhHyo0Ut30/t5pSBFABkFibRuPRB2uM4CzumuIw6a4SL4+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5VaUshknnn1p8zD4ompG3lsbz57LMR7mjbupCIkhWMw=;
 b=qSHFX+yHrm4A1UlZzjjEVqC2Q/zCq1AAHh7PcBYU4KIJ/8AoCUQ8fOyEFLL2FVBHvLv3mk+Tz92fEbZE6FfJQdNjP4bQLLZA2gzeEcOrAaMNxs96p3jhCXlybhQYWHQvdJR29LKdlwrCUhP9hr7MPmajyehp6fwSuAagAdCOG1eEHpjMdtGgE2+J2eqBL7f1KWa4Z4L+AAWzA1OCep40x/XkmH/vogH6uUr/HaZnQZt7r1/z4TSWwlI1VT7OXyPNcKS2aY+h9GqfDFewtSUPELpfzfYGo4C3y206Z5UBEkwEsHxy3IY+Ihtpo7LtcZFuVD0RFtUNf73UoToPGa85UQ==
Received: from BN9PR03CA0175.namprd03.prod.outlook.com (2603:10b6:408:f4::30)
 by CH3PR12MB8356.namprd12.prod.outlook.com (2603:10b6:610:130::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.31; Fri, 15 Nov
 2024 18:11:41 +0000
Received: from BN1PEPF0000468E.namprd05.prod.outlook.com
 (2603:10b6:408:f4:cafe::51) by BN9PR03CA0175.outlook.office365.com
 (2603:10b6:408:f4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17 via Frontend
 Transport; Fri, 15 Nov 2024 18:11:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN1PEPF0000468E.mail.protection.outlook.com (10.167.243.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Fri, 15 Nov 2024 18:11:40 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 15 Nov
 2024 10:11:30 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 15 Nov 2024 10:11:29 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 15 Nov 2024 10:11:29 -0800
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
Subject: Re: [PATCH 6.6 00/48] 6.6.62-rc1 review
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <bdd99b2a-a698-4462-ae13-fe7aa3519ae2@drhqmail201.nvidia.com>
Date: Fri, 15 Nov 2024 10:11:29 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468E:EE_|CH3PR12MB8356:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dfc0505-1e0d-4e66-0991-08dd05a0f468
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RTR5QUw1ZXJTbFVYc29IejdFck5qTWh3MUlYQlhvRHhyMnJNS01OQ1lOc0xE?=
 =?utf-8?B?cDdpNFV5dXJDdDNiTDhJOTg0VzM4bzhMVmJURWNYT1U5OFlUMHRDRHd6R0NO?=
 =?utf-8?B?MEN6aFBpUWxUS1lBcjlyazNyT1VOZVFhTGJyZ3dZa2ZaRTlMbWR2bEh3QU5L?=
 =?utf-8?B?cHBGcnYvMzVubmlHM3YweVB6Tm85Y2VGZXU4MHR1cnp5U2FVNW14OGZybW00?=
 =?utf-8?B?cWpEcjN1bG5iZkkrbjJtSUZadDdjTnV0c3JnZy91ekN3TUlPVWU3NUpDOWZR?=
 =?utf-8?B?S3BnekJBVVNWRmVMUXVEaXpyQVA5UEwwTWNKc3NXOTMrTTZreERqZWFRSWpy?=
 =?utf-8?B?UTFZdGphbGo2MHRXaHlMTkYvSk81Y3YxMk1abnVVY0JzL3dzOXNpSFRpTEVy?=
 =?utf-8?B?MXF0dGVYbURRRFJVUHdFeEt2ZURpcWVxM2hFb3dRc1FaMm5JTmNaMERGeUVC?=
 =?utf-8?B?dnNJa2pPWVNxeGhVdDdyM2VaYnpXMU4yOVBodlNjUTdvbkMybWJ0M2VaMUIr?=
 =?utf-8?B?dnk1cmJRVThrQUt2L0RCaWpnZ0s0NXRoeDRmYXM5SUVTQTBTbVlwam9oMW91?=
 =?utf-8?B?NFNubWpjbmQ1SEFKYjZvU1RSSGlPeWR0UDdoMThWWGpXRHJ2dmlXbDc2M1Vm?=
 =?utf-8?B?WGJycENSS1cxdUpTQUs1eGJoWGN0d2krZGtBZHZPTWdKNWM1RTc0WFFuNWhX?=
 =?utf-8?B?WWowaFZENkJEU2lrMTgzWjNmVW40OXk1UWFJdHZDVkg0OHFhTTVxQm5FdXpT?=
 =?utf-8?B?dDRuNWZGUWpicmZYYlQ0dWNYeVlRQWhlR1hYYVVSemsyUU5UandOZmFaL1lE?=
 =?utf-8?B?dFJKV0pvRjk2bmloWUtqNkdQTUFiUHJuMk52bHhMRkNjdXJHSGVydUpJK2pp?=
 =?utf-8?B?TW9aM2NoWFpVY2I3S2hlc0t3UU5hUEd6eGVNSHMwM2plTFZKQTZNQk5DWFJs?=
 =?utf-8?B?NTI3R0JxZStlbW9GOW9JWXp6QVllZ3l1dGdEcUkwaXpwZnBzRGxkYkpWMnJz?=
 =?utf-8?B?aXpRNmMzZHVYNTgvaFhDdkxEVFBZWDlPNlAvdGZmbTR2L2d6R2hzSDBCSzl5?=
 =?utf-8?B?T0xEWnNuVmluZklwUUVMdmNENlBpQjdBMVI5WWQ1c2lHaTQraldwYktKS2hG?=
 =?utf-8?B?NTR1K0VHdnk4bkxaNll0VzhIbUJPVVJScHVTZHpIeFVGUEk5OFpNSnFYTUZk?=
 =?utf-8?B?dUNxVnNCbVhmckh5TVhjdkRRY0Ixdmt1S1BZYi9kZHdWeE01citJb0FYT0dW?=
 =?utf-8?B?L3A1RDRHNW1sbk5VVzE1KzlQaThJVUhESWl2blVQZ05CbWM0UWZLdXVhQXph?=
 =?utf-8?B?d0prUTBCbjRxUU9hcUg0MFZUMXJCU29BUVY3L1ZuYm5SY3lTTDZjay9NNXo3?=
 =?utf-8?B?QUtOYmdpeHRnbHg3TzFTMmtzUGIwM2Y3ZlJHYkRodklldkZvZEFWQVRiUkN6?=
 =?utf-8?B?MGpvZThONDNHMGNTMlJhd0JvSllORkZDbEVlK1pGTWpuekxQczlJb1l0cm50?=
 =?utf-8?B?NVNFNnZXZ2hXamQ0M3pEQTU5SnJndXBQWjE0TmRteFN5OS84T2VkMCtPTjM4?=
 =?utf-8?B?R2pYb1NHd1R3WHN1bm5qTzV3TGN0NFR3TGxTQ0wvN2MrYmF3RDhnRVZtUXFF?=
 =?utf-8?B?aG1kMnVoZzJhQTdHYmtaMmVGUEs5ZVBFdWkveWZLVGNGTk9CbmNXc2NYUFdQ?=
 =?utf-8?B?YmsycFZNTldCM0xkQlhWa0VrUU9HY0MwKzZMWVhaRGpPUVQ2TU91MmIvQzBt?=
 =?utf-8?B?dllWbGpCYWtVWWpTaEhMVVNOeW56U3ozNUhjM3o1eHcrQnJPLzRadDBmL3Jj?=
 =?utf-8?B?T3JmMWNJcWo1djJOeGFiSWlwVk4wTzJkYmJkWTVTei9Cbjh1RVVIWThkM3Zp?=
 =?utf-8?B?SFRvWW5CRG5Yd3hFcmN0NkpFNkhnTWJkTkNBL01QUXhIVUE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 18:11:40.7968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dfc0505-1e0d-4e66-0991-08dd05a0f468
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8356

On Fri, 15 Nov 2024 07:37:49 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.62 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.62-rc1.gz
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

Linux version:	6.6.62-rc1-g68a649492c1f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

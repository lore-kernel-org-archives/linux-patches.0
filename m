Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED9D19B3F7
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 17:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718384621; cv=fail; b=KHuady4UJhUQ/KSzcFif9VHqAv8CB+RbEDAmzsPOTO5A4N/KpP86H+f6dH28tZRIK1nf1zxleu8cg95KIr9p27WSl6q16I58rVS5Sc8VGLMWrFO8zLfZ7IxHT8awY/fradXakGyitpOZKVEidfw5qh4StlwFK5JhV3WrSsBcJ24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718384621; c=relaxed/simple;
	bh=E6Q5KZD32lpt3186/WJ0RfMOt7ST9/2PDJVl7VmaKdo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=tBc0jgu4pIClqx4v6JCPTJn61EvAInCXW0fVAH1PEKszFB6XHr+7XUcN1tWpeYpAqK5qjVMzUHM7heXkND8FGn+/1JTjnIm+gUJw8jq3HK17ItSzmV9kb4cbo5oGDjCL+mUOTFR9dtiAMNwuubE5yYr1vivmY579lYF0bgbBxT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ph3CiywG; arc=fail smtp.client-ip=40.107.223.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ph3CiywG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDSK8Vek/h8F7aJEItUhEIjVugUT+o56xxruXGkYzEdiPJpD192elMwNI8ZO2DQ/07/v8lDaZB6rfJwyRewbPJOLWRRjKf0AKFBeR1KXFIhq6BsCJZAMAIxMhWkgvV4QG2RwGFT80uw09CkOWr7AHGX1qGgwc/OGBxPls6YBgeLqOvRm95OY4jKA7XbaLFwPdKT4CpnhpPxSmep36ofzicjgYfhlsJvdhUdXCEe4rZV24NUSqTPqpFuhalReyowDFdgD0db7ijinXVoRGwMS4XVaIlF1IS/98Zsi/zxqATfaeBGojLeeQAeRE+Y4rn5hScgT9uBYAwnTcVG4I3L23Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eWW9OhYGsjbyTmVR+y1VrakAillHfRjPIz81YiQuXGw=;
 b=I9DsXAvNpjgOeEgt8M+1a28DkguTB1MV0oX/rfy7I6W7/VhVIlv/6AGXwenwR67fD/aI9PGbfkPshDAb1tmRsHwWC71hGHUtCyCIrHUu+tnPLl9GNZpzgqMF3MzoYGirJKdJsOT7mV/dWHF2wcZGXgPmhB33JTl+WLpctYI8E23GMa1V7k03kbZr9xqLzE19xDkRb5QNugqWSZT1f6Cb+kjU4SS8e5n/hOy2sRXgXJJFlanm6rM6vQd5elB453fVxrE7Pq+tecnQ1+91avpadVkSJrtC0j4WHHUjnBaUIsN/ffvkR/y+9XFyG2sgbMGyzsUYSVozDQhzRXOH9sXiXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eWW9OhYGsjbyTmVR+y1VrakAillHfRjPIz81YiQuXGw=;
 b=Ph3CiywGi5aTPPNrJMPCRaxLKDLERF0XirzJA4U6xurvYlO1wrfXs5eby/ZdlVO4GlnFzugsk/g2HlGNxV/07coV9vT9NDMC7Dq4HdwvPqZJZcm60lp/qpsQdh1WrAm4aUgAWnAIUYJ7UdUeidLBOXIzeWO18K+Xv6/3DrLdwwJ5uLvkJ6kHGHGzfXmmg3AMV2mGz24nQAGJzjkf/NB4VX1lFX9wUjNZQ9WghXuscdZABbh3MaINwuVyBpeJK0dhyH6IVzKGsurIsjmG+fuNVedGxR7/jyl5pIEoWr+FJBoLih8stAKnt9bqOrjE7eSTD0/FcOfC6G9fPaakO6IRyQ==
Received: from BN9PR03CA0445.namprd03.prod.outlook.com (2603:10b6:408:113::30)
 by PH8PR12MB7446.namprd12.prod.outlook.com (2603:10b6:510:216::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.37; Fri, 14 Jun
 2024 17:03:34 +0000
Received: from BN1PEPF00004684.namprd03.prod.outlook.com
 (2603:10b6:408:113:cafe::a9) by BN9PR03CA0445.outlook.office365.com
 (2603:10b6:408:113::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.25 via Frontend
 Transport; Fri, 14 Jun 2024 17:03:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF00004684.mail.protection.outlook.com (10.167.243.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Fri, 14 Jun 2024 17:03:34 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 14 Jun
 2024 10:03:14 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 14 Jun
 2024 10:03:14 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 14 Jun 2024 10:03:13 -0700
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
Subject: Re: [PATCH 6.1 00/85] 6.1.94-rc1 review
In-Reply-To: <20240613113214.134806994@linuxfoundation.org>
References: <20240613113214.134806994@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <6b850a3a-061e-47e0-920f-587e96d9a79c@rnnvmail205.nvidia.com>
Date: Fri, 14 Jun 2024 10:03:13 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004684:EE_|PH8PR12MB7446:EE_
X-MS-Office365-Filtering-Correlation-Id: a8ebb2bc-a9f7-4eca-aa21-08dc8c93ecf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|376011|1800799021|7416011|36860700010|82310400023;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dWZhZWR1aFVXUHhnNXF0MVhCNGhxajY3YjZWZEM5RTJvYXpoSURGWC92czMz?=
 =?utf-8?B?ZHc0dldVWjNLem5wVnZrdEVPSEdjYTlIVVF6cUw1b2xYVEViek80MWpvS1Y4?=
 =?utf-8?B?M3NER2NrbzVtVW03UFRJMEtLcWdCeklhNHRiT3pXVkZRSEowUitneWVGTDZO?=
 =?utf-8?B?Rm8wVTlkaVBvaFRia3hMR2c3SGxqcVk1dVV1TjYrTDkvZm5FT1dXb3J2b2NX?=
 =?utf-8?B?Q3JlbU94ZXJ1T0RDTVJUVWUxYkRJUUNjbTVoenRjWlphMkJBRWIyS01ZaE9z?=
 =?utf-8?B?cGFqKzJNSkRtT2xtTUFaSE1lVm94UG9uWEZncFBQMG9ZUDl5b3h4b0VlVGRC?=
 =?utf-8?B?L1BEdG84YmQ2cmVmcGlSRDFuam9UMUZ2STZHMzgwdlVNTDBsdUlNeFhTVU56?=
 =?utf-8?B?WXBjK0xlTExIOERmOGxQUXU5NmlxenFIdlgyWjg0YTM1bmlQM0EvTG9kN2Ra?=
 =?utf-8?B?RkhJSFMwREtENnZ2RjloTGpyOFQ1cWVHcGdCQ2xLeXladStMREZOQUpjWTdS?=
 =?utf-8?B?MGc0KzQ4aVRYQzlNVWJWVEh4MXdJOEhXODdMek1iTkVlVWpnc05GUkxMdUkv?=
 =?utf-8?B?eHhMbGE3ejdtdzNQbnBnRk16OUxVTjNkWW5JcG8rVXZMa1J6NThWUU01amJC?=
 =?utf-8?B?WWt3TUErRXlSM3JSVSsvMXRxOUp1aHpRRFIyY3dCOHJnb0VpL3RyTm9CdFFJ?=
 =?utf-8?B?bnc1SlpyU1dFNGhFU3dnR01mYVdueS9SMkptTThaY0E5Q2tIS2ZEY2hzSFlM?=
 =?utf-8?B?cHF3S2dxS2R3RXVia0FFSzhvMTNnVWpDZklhaFRjdW1WYjB2TDlQbXovdWUx?=
 =?utf-8?B?NXVHL1BaVlZBc3FkVjJKUWFIZ1UrQzhEUGVQbndBay9rUVBaYUlXL1gveElp?=
 =?utf-8?B?NkpMT04rOWF1M0tjSHlJR3BLTHFvUytCSVhKQ3ptZSs1UGpjaTg2a0RlTWkv?=
 =?utf-8?B?VnBwWTNnLzdHTk1kdUp6MWRqWmF4Nks5aU1CTGI0SlVpNG14Q2FmaVVWNHdI?=
 =?utf-8?B?VjVUdmdoU0FZVkFLYXRtSWo4eWtHcmlzYlNRTTNRazMrYU4xRHdaQUVNS1J3?=
 =?utf-8?B?akI4YlArL3NpVGNrenlvQk5xSy9YUjFwb29KMU1xaDV2RlU2aEJ4R3RDWDdS?=
 =?utf-8?B?ZVliS1ladmJmSGxBZlIzV2pxdjRRSVIrczRkZzJvQkdkZ2ptL2tnbnRoUmwz?=
 =?utf-8?B?LzBpYTNGKzZOeEhlWG92RHhSNlUrVStzRjNHeFNvekZxb0ErbWhDQUlhQ2xm?=
 =?utf-8?B?VTgzRXord0VJbUxZWmZuRSs0T25NRlpjZkRnQVlGOEgrSUUzYkdjTmoyWW9X?=
 =?utf-8?B?c095b3RnRWNOR0xmSzNXTnVSM0d1SFlPb3B3bWNJMFlkVmRXQktOZS9mQUZk?=
 =?utf-8?B?WWROMXNiSno5ZVFmbDFxN0tCcS9IM2x4K0p5dDI5U2NjdzQwcHFMQ1piZHFS?=
 =?utf-8?B?QkRwdFJvbzZ2UEhoL1hieElGSndNbDBJbExJSjhDT1Q1UTdielZhbDRMdlZX?=
 =?utf-8?B?L3NRbThrWDQyektOWWQwZk13Q1JmcGY2OXFscE1odzREdjNMaUJqWUdRQmFN?=
 =?utf-8?B?YU1xMllmcDBMaFcxZ0VtK2JRVElHV1FXakhkRGtYVlZvcTh2QlZ2MmtEeGVV?=
 =?utf-8?B?L3VvSWFXVUhOcWFad2t2MW51Y2pGRzA1R05IRi9zWWdRcFpEVW1USHBDa1FC?=
 =?utf-8?B?K1hwRjRkaUhpMWZIRFRvVXN2UXdCTFloRmhVSUhxV0xucytjVFBNdTdubkYy?=
 =?utf-8?B?dGZ1NThUdW5uS3QxcngrcVV5NkdOUmZ6UjZTMzVLTlpyQ1o5ZHM3clNQTGl2?=
 =?utf-8?B?V3BOY1phblJrcHJReGxRY2tEL3dnbmd2ZTZ0ZnhHcFpOKzcvU3ZqcWZaU3VP?=
 =?utf-8?B?OXpaWjh5QXFGNnNreHdURUc3ZlduMlJHOTVDWFhRUVZ5M1E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230037)(376011)(1800799021)(7416011)(36860700010)(82310400023);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 17:03:34.1496
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8ebb2bc-a9f7-4eca-aa21-08dc8c93ecf5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004684.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7446

On Thu, 13 Jun 2024 13:34:58 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.94 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.94-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.1.94-rc1-g066936907540
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

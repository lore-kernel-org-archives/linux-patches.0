Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010070.outbound.protection.outlook.com [52.101.56.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE9C27B51C
	for <patches@lists.linux.dev>; Wed, 17 Sep 2025 20:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758139743; cv=fail; b=S3lkjE4x/BM7bwEimXVBH3XrI/DKw2LNlav9jXphh7hLf95mlwneXSzhc+Z4yn4F5G0oMvUjeOLLSVUfX2RyKcirQorl+DXM0Hvtwq7tNDLQaY+PS8kAl+M25FGlAwanYmAyPhRPT80nvawzmx77W26dHL/sBAM80O8rBq1Bnj0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758139743; c=relaxed/simple;
	bh=Kog6awMQQa5SeZGtSFd9xfbYNF7vAzqI1tobNOzzd30=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=d+gOT3insNd6sNq2rwzYIxyUtfkUbuVRMZYdt+xcqjdOrvvEtNGqFxMCBCkP55PjbHNDref+IBkNGbspQsvXGvt3OQokEyQ0ZvvAtLE3rJCF9gTrGvPhDuTyPMGKjMmG5+/9cnTpTGkTTM2kJkEzHnLQFCoCazEnAbnykmctQic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sTWnmMJ9; arc=fail smtp.client-ip=52.101.56.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sTWnmMJ9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xWZCAS3a3dS0z9okeLRoxP5LwSPv1nCKN594NonYzQqb1osMwRx3TwNk58/hoXxV72GHst4pwKWVvsit4TZv9Mbl9NjFdqA0vFJoi0vJAsBZ5hr/0gqiBNuHdW4oSCwuJ5OcUnuum2QkDrQ46k2eUk5vk9mwdhoIdVMysryTt2W9S6zZJ04syLBLvoAUsL5uCKSagimumM/8ckRXQNwEY2FVQDlQAznbr5k4z5bGqJkCtZYZfkJYY3szr45ZQHLlD+/dt+qLK7+WNCFK7NavpUwpTRd+xP6Jqol6c176PeyXE9XmpPzUS7VMTngXq3Rb84FLbtP93N6/3y5+WLbbaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ldpEocRRnOBG4i2q08UXTQfw0ChUBg2rgOd2x3mp6o8=;
 b=cOEOWcDWnFjeN8UrXWwMuZIE3Nz+B5m3xfYzWeBB9BO6hKRTpx0IguF0CDu2/pUSi6AFBOJcIen8zEawtfm4ximQTtcaDHxnbvx8pJQ07o6F6WzBmRlgLTWSP7TqjzV2/TCGMoaLO/KzU/5iqXzfOvmLx+PUow4WfbOl19C2Swbsf8PE8qphDFuBRRN5Cumg49Qbpvgc1reiZcTk+iHdyewvao1cAlHQoX9syM2IxEkqLJGghVXkWnPSOYr5k5zr67pAviM8ZktZarz9eoiV/eV9JWoEcx7NHjf/3aSKIHdcwqYJgyayQrLXfHDe1sc1FnD7UmGX/Ca1RrIMTXrbsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ldpEocRRnOBG4i2q08UXTQfw0ChUBg2rgOd2x3mp6o8=;
 b=sTWnmMJ91eXWXg6nj+l9tDK308H3PQUhBD2bDckUXS6sgwnEViEVTPx9a0WR69riDOkMbov0yRhAFGchl9dKBsplexnTNv3cJv+UnfthB8yyboqTW5e8eyJGp9LODxBiac7a/BsDzkhIFAfZE8oKsqZqT1nwx2OxIU7vVuSjemeeDb2VtjjbHc6Y1X1nUHexh3/ckguXVQzOKALW3NKlZomhehFVXgaehoihO0lpDJF8IlE1lGepfqCvm6AbZjDwmxwhy2uwhz4RHa6uEj6AtlDsv1WXvmwNo2WUlewUnCYEC9WNnjCtdee2ChkeuDbNVxhy6Jz2uxGSJDx1DxbUHA==
Received: from BYAPR02CA0002.namprd02.prod.outlook.com (2603:10b6:a02:ee::15)
 by MW4PR12MB6997.namprd12.prod.outlook.com (2603:10b6:303:20a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Wed, 17 Sep
 2025 20:08:54 +0000
Received: from CO1PEPF000042AE.namprd03.prod.outlook.com
 (2603:10b6:a02:ee:cafe::11) by BYAPR02CA0002.outlook.office365.com
 (2603:10b6:a02:ee::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.13 via Frontend Transport; Wed,
 17 Sep 2025 20:08:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000042AE.mail.protection.outlook.com (10.167.243.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Wed, 17 Sep 2025 20:08:52 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 17 Sep
 2025 13:08:29 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 17 Sep
 2025 13:08:28 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 17 Sep 2025 13:08:28 -0700
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
Subject: Re: [PATCH 6.16 000/189] 6.16.8-rc1 review
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b3c1ccd2-ee44-4f01-9094-ffe829d97eaa@rnnvmail204.nvidia.com>
Date: Wed, 17 Sep 2025 13:08:28 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AE:EE_|MW4PR12MB6997:EE_
X-MS-Office365-Filtering-Correlation-Id: 8267f929-4ae5-44f0-9f52-08ddf626063a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SFlqZndnR2dFVUxNWFJuR2RsR1U0dzJDNytFdlJRTGkrRUNCZGIyMzF0ZlVa?=
 =?utf-8?B?SkxwZkEzS2NJMWNDczZPa084anhmUUJUZ00xMS9ZZWVia2pWdDBqdFhBOU5J?=
 =?utf-8?B?SDRTMThrMVdrNzVsbHJxcnZpTkJoK1JYZnI5RzJiSFBPeHY3aUZaYjFjZjBr?=
 =?utf-8?B?ZTNJcFM3M091ZVZ5aUdsQm41NmFIcmNiS1YzQzd1TCtTWDMvRm85VW1vRzlT?=
 =?utf-8?B?NG84VllUK3J4SEpmU1A0ckc4MHRIcGVsb3ppSFBaQUFZd1NkR3VwSlJpZ0gw?=
 =?utf-8?B?Sm1maW5jMzJoa2psMHkwYjQ0ZWsvVmg2M0hWMmUwMDFUQWpCOGZXMXU3SjBP?=
 =?utf-8?B?bXMwRzVvMXI3bytxK3R4RVYrcWxrSk5NSjFURHVTMjRsM0VaL2NKVkdoMk9z?=
 =?utf-8?B?L3BJV1hoSkdxU0gyWXMxdC8zQXhCTHVYVzB6UEJkUkoxZ1R1bGdHOTZzbEJj?=
 =?utf-8?B?Y2xMaUhNc29YR2lGVjZFcy9EY1ZEV0k2SUV3NXZVTGdSTFlWSkdqbVllYzNS?=
 =?utf-8?B?a3IzY1JZelBubThGalIvVFQ2UkdJWExpcHI3Mjd4ZkgwZmZuVHJsMWpPK1Ey?=
 =?utf-8?B?Y0hGUmhpWVBlZTFCNDJSaVNHanR3c2NMSSs5VzVDbWdzc3RXZEVDc01aOVdT?=
 =?utf-8?B?OXdkRE9tSWFGYXYvbTdoYW9BNFdLSUpaam5Wd3NBcXlaaFJzS09SQ20xbk9s?=
 =?utf-8?B?OFpLcG9rUlNSM2ZJS3ZQVlhUOWFKY0k3YjhUdzMxQ0hQdUM1SnZEMEE0eE92?=
 =?utf-8?B?YTVwVlJ5UFdZamh5eENDSzRMdlIrV2RNVmdoODZMYmpZbU1rM01DM2g3VnpH?=
 =?utf-8?B?TnRZbWVRRWNMVjZJeVVFSWNsM2t2OTVMeERRSDdPRi9WdTFOSHR4c0Y2ZHpx?=
 =?utf-8?B?TVNYTE11eFZuanFxRjNxanQ5cWxycGdJMXJKazBZVGkrcksxSlAxSnRhalhq?=
 =?utf-8?B?c1lmbzdPU0cvMnM5T3dpMVVkR1R6eFJRNzRpS00xd1Q5Y1dvVDE1U0pwa2No?=
 =?utf-8?B?a2xPTjh0ZVV3bFJVUmZGUnFwRkJNbUpWcENhdFpPaE1XajJoVFUxOEVsQmJQ?=
 =?utf-8?B?M0Q5L1dYRkREUGtOUnVTMkxUejlZS0NCOExveFhVVGhiZDB1WEJReGJYMHNn?=
 =?utf-8?B?ejNpUlBIWkJEMDdGcmpNUklwcWsrUjBXME56N2ROQUZYOVRETWY2NVgwdUFk?=
 =?utf-8?B?V3E1SkdDMENpa2E0RTB4QktSSFYvaDBaNHZmSWkrMFlkRk5MWUNidm5DbjRG?=
 =?utf-8?B?RXoyY283VkhDRENDZCs5ajdyRjEwczJnQ0RVYlNNd3ZDM3JYL3J6Y0NSZ3k0?=
 =?utf-8?B?ZVVINkdtLzFtQ2F2UlpGV1NNMGFRdTc2YWdyVFBOaWRzTFZLcHZ3ejRLU3FN?=
 =?utf-8?B?T3A5UDBDK1o5V1VveFZSSE0vazFaeWNNU1ErMEtLSHVpNEsvdS84RVZjOUFx?=
 =?utf-8?B?WjQ2UGxPNkZ5cSs1bEYxT1Buc3I1SWVnVTJZUitMM2NiaDZWb09jUHBoSmdT?=
 =?utf-8?B?KzJaV2Y1NmdZZVBTQVY3RmFoSzhqbm9Qd090US9GbUFXZWE5dFVTRzJKS0cz?=
 =?utf-8?B?MHdjYjRmRnQ4SkppYkxaYisxR1UrNWZ4SkVvQTFxWGxYUTNKTnBFZ05VK0pG?=
 =?utf-8?B?aDZybzNrRGVYTk84MjhMTjFDWXdXWjVzSUp2eFVGdWVJdnZTcTB5U0t5UFU5?=
 =?utf-8?B?Y2svWmZtMExWc3RKb1pUN2NvV0JaaSsxSHNNVVBxd2dqNFVPclFDUEV3VTBm?=
 =?utf-8?B?NTgzdTlSM0JEM1Z0aWovUzh4bjVENUhMMGdGd1MyNXgrRWdNa1RWUHJldkkv?=
 =?utf-8?B?a3djUEF2MXFGanlsQkpINW84YTA2T0YrME1RWmhyVTJPckFDOHFvMXVXK1Zo?=
 =?utf-8?B?ck85cmgxbjFYRG9XMENPZmtpTzFhcXF5NHNZS2RqTEpCVjdIL2o2OHAwRFJw?=
 =?utf-8?B?dEZMRWd6NWdidmlWVDJlbmJiMTUwVkJMclJIRnh3akU3S1ZzNEorNlV3bFJ3?=
 =?utf-8?B?aVI1MUVUTlZic013WDR2LzBaN3NmRFhTVWFRV1BKV1RtT3V1WHQvRFgwOTdx?=
 =?utf-8?B?aHo0NHFvWDN3Z2ErRUkxem92cnAwNnZhaURHUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 20:08:52.8791
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8267f929-4ae5-44f0-9f52-08ddf626063a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6997

On Wed, 17 Sep 2025 14:31:50 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.8 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.16.8-rc1-gfb25a6be32b3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

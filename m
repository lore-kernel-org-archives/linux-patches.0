Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19D520C004
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 07:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750836275; cv=fail; b=chZM8pIJiY5RWf/wITA1RH3SXuOFvHIZTAcdeXwBeX1OaWTa738Ys/hWW+aoc5ovxKzkyDw6Ox81tScrzW9CqwSUHbPvgJqOfKm1Tj/X4tCGe4Rmf3Ijj5EM+lNwUwT4mTZ1uxLLvVdEj09E4Lohlv5KMTQuTsMVyi5Dew8MIlo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750836275; c=relaxed/simple;
	bh=OCmJXPxwPKgd30wCpDAl7oRXXc3Il+uJBm3Jn6hFD30=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Z7rpP+26y1xkDQOcZ3jTZp5i7vcT+5q/iBkSfw49CZ9WDDThmEitjItdoO9VF0nk5QtmceXeo4UyGv1D9+vyxFXvTh2UO9dyEPa81x3cN6+PeXqJLcy70xoIPO34X4wq6FdWbJ2WE8GThEsnnjPbcHua9q5xih0xOIti20qGzLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Mfo5U+i7; arc=fail smtp.client-ip=40.107.244.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Mfo5U+i7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=emLtnAfsosTKkAKbRZxgF/3UHmmeIbpSQQa5i+krOYjYs9NAYtvd0HppZZp2tAmCGy1nk04YojZxXHvkSvo9TTbrvI1xvHIlsNZrIJpuBpfX47WkcbPE8KqaCIMFlzomFDstG97nRsIGrLsePMlKRgOzW5ty0dkE4m0sAJQQrJlwqOidpYsw6b+jBkCBc93BQceg6pGwemFOH89gsbHITzUYbllSoVejud1T+tHQMjU2HLr0oE9jTS3yW8P/AOtg9dr3wBRX/e+NzsX8o0LDCykSpwhFXkqn0tVhjXXiaTNc6++lzFIUcXB3A56C+l/iOLOs2sQs6hv36SZDNg4dtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qSjEi8ajjVJ1ckGxRCLtwWE7lKRG4AeVJL8vm5bnCRE=;
 b=TSnxEzEL9Z9C70DcCe99IlYa4b4wh+28KFONZR34OXMqOWrHzPMhDJKaOtlxfWtR/RDmtSBkE5hVCzRUtIFj3/UID7Tiwx+eCqkgj4r8EpqcElbzD2C2Q1IPJ6wweBm8gbiYMOFDb7ofHIv/YaLCc7590QdFhHKdzrTjp0JM3+MejS7qaECkO2/MCyYNT4AZa+A0tcpgn4qsxsEeIHHbaQil/I4huoM7TzGgWhgXY5sM6JeAhcK9rhyaMnjVZ1rMTyZnTeh6tmf9KooCeXBNpRNxW/ebe0oycinoPIttLflQ9S4zWpccqOkhV3FlbLQ5myvaIggtS6ZYhxD5PPX8Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qSjEi8ajjVJ1ckGxRCLtwWE7lKRG4AeVJL8vm5bnCRE=;
 b=Mfo5U+i7VZigdQTNz7iFtYWi1UliftYFa855E6M9tvuGR4n4Ryo+uu/2VxgR6qAX1BQbkt8GWnceqwXPs+tQRjo/UDtGrNvDSUdaEXKowyWmURZ5VxvM+dRX7nuNAtKV39DwVjQQTd7A8yyj6tlBmjsfLqI/DwFsfMc6QRH/lVxcYRCQ4YH8VIkhi34EFHe1qyQycI8gIQx+zNjGhMD606AfuBGBQkjean3g0tHP/aHwCNt511XQkPQbZzuNwSkRXNW+edDfa0muCSw05VHIUKpLV9MKeEx7qgDtZXqB10+DlhjA12oKJ0P7D5E+wYoP5mb4vnD/im/Tbko7pkxAyw==
Received: from SJ0PR03CA0362.namprd03.prod.outlook.com (2603:10b6:a03:3a1::7)
 by SJ2PR12MB9240.namprd12.prod.outlook.com (2603:10b6:a03:563::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.20; Wed, 25 Jun
 2025 07:24:30 +0000
Received: from SJ1PEPF000023CD.namprd02.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::aa) by SJ0PR03CA0362.outlook.office365.com
 (2603:10b6:a03:3a1::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.30 via Frontend Transport; Wed,
 25 Jun 2025 07:24:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF000023CD.mail.protection.outlook.com (10.167.244.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8880.14 via Frontend Transport; Wed, 25 Jun 2025 07:24:29 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 25 Jun
 2025 00:24:18 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 25 Jun 2025 00:24:17 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 25 Jun 2025 00:24:17 -0700
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
Subject: Re: [PATCH 6.15 000/588] 6.15.4-rc2 review
In-Reply-To: <20250624121449.136416081@linuxfoundation.org>
References: <20250624121449.136416081@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <6a945f47-2dd7-4cf4-a3fd-d60b201b41ff@drhqmail203.nvidia.com>
Date: Wed, 25 Jun 2025 00:24:17 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CD:EE_|SJ2PR12MB9240:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ce8a8c9-6212-42f0-cb74-08ddb3b95310
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TExmeE82cm9SdUJVTTRxeEdVQTVET3M3bzhBdzBwVTc0Wm5XV21hVjNLc284?=
 =?utf-8?B?ZkVRUWxHdnZQN3liOEVZS1dQUnBvWVB4UnZFcGh6ZnY5a2FLTWw1WTJFOXJ0?=
 =?utf-8?B?NFFnSVpOWVRBYkROdmFOeGxNcnNHU2Q5S1ZZZ1ZEdHIrYXFUc0VBeE5xM1Jh?=
 =?utf-8?B?UjhoQ0o3eSs2ZDByakpNbEQzZXdWQnZwUTV0WjNJbVNsS0hlZ2JTQkdtbnBm?=
 =?utf-8?B?dDBXR3pRR1EvclpwbTNYazdUSVpmSFMxNjFaZ0paQ3h2R2RPd1VmN3FaUmZZ?=
 =?utf-8?B?YmpxakZzMkxyR0Z1L1NGY0ZkUG0vRzI2OXRiQ3hBbDZjMS82UFNtLzh4aER5?=
 =?utf-8?B?TVQxT2ZxMm5PamtVTWovTGk3R0F2elhXWUg3Rjc2NGV6Z2lWUW5vclh4aUhO?=
 =?utf-8?B?S0pXSFlMOGcvOWRvUkVGZjJveGtvRFNPa1d2SVNMSkVxTiszWVo0SkJ6aUk3?=
 =?utf-8?B?aXVlVjQxYUpTVDNpdDZpTDI0dHg2ck5qcldGMXB2R3phMVBFdittV1pFNHBT?=
 =?utf-8?B?ZDhxcUZpNmlKamM2aW41cmVGK0xtbW1KMlU1WXpYU1pRQ0hvTUZib1M0L1li?=
 =?utf-8?B?VkpKc3ZsWFJkdTBrdDlNTHg3bHVTVjk4SlNnR25tVG9telFRUy9jVHBBVmxZ?=
 =?utf-8?B?a3loNS9ka2ZMbEVLN1grMzFWY2h2REhtVysydUl6NWMzZXNmNy9zbWtCUHR2?=
 =?utf-8?B?cURxbmVDOExNcnVwMk56a1JiMlVjc1dxMUh3dWVzbkpSQndzSGRoQk1nclZu?=
 =?utf-8?B?NFJ3ZUI3bURETGFUYjg2emM1ODAybzdienZkbm1KVHhWcHRKZWZpdWx0R0h6?=
 =?utf-8?B?VE9JeWxwUldVdTZGczByaHUwZndWRjdGM1ljNjdpVHE4blQ1WGpPYXpSS1Vo?=
 =?utf-8?B?dFI1VHREOWYyVXhDOFZYaGF4NVJteUh2UGtZbkRsMUgrM05EUnYwUnRwTWRx?=
 =?utf-8?B?NkNYdFRrWWJZUVB1MXZUeTlTK0FxWkM5RmtBZy9BckM1YW5sODV3T21weUFW?=
 =?utf-8?B?UnJXY29LemNkMmpxQ1Bjb2doYko5YTR2enRpdENZV2VlZ0E0ZzJqSHRKa2JV?=
 =?utf-8?B?QWxzRmo0UHpuOTJCMnhEK2VQaFpPVVVsdmlIRHRqUGVvaEtpdlZ6V2R4RXhu?=
 =?utf-8?B?Ymk1WWZxOWl0ZWxSZWZwd0ZKTExBY2VaZU5ESldwVEk2dmQxM1pkbU9lY0x6?=
 =?utf-8?B?d2FqWUhLdllYSjQrcEFmMVV4eWxwdXljak15N1lRYVNFM0Z3UWNXcjBYRHdC?=
 =?utf-8?B?SnZ0WlBSQTZOckZzenhGNzQvTThQa2NwRldWeDluWnpZa1FDYUVvOVJMc0c1?=
 =?utf-8?B?UkZ0WWpNR3FUcDF5c2Yzd3BIVVp1SXQrOFlLWmpEcTBiZnhLakFUUGJKaGVI?=
 =?utf-8?B?OG45STEzRVpvUnJLdFl6MHRQMUNrL1NZNG9qeWRoVGNadXU4ZmNRcHd3Skhw?=
 =?utf-8?B?VjM1RG9sVTNicVdHMTR0ZUVlZGNzQ2E2S29heUtQMlFTVWtxbUR4U3BEODd1?=
 =?utf-8?B?RUhFbVZVeFlYWkVVUmVXNmJVR3d3cUhWMk5WU2dCeG1Bc2NhSHU2NTFqSjk3?=
 =?utf-8?B?aVIvL0JPbUloMEppVHBJSU9vUXM0aWZPczNDa3JSeWR4UGVyQ1Rsc2oya0Rw?=
 =?utf-8?B?UHp3dEM1LzBPK3VIM2UrN1RKK3NUNFI4bWRLSkhZclgyYnRVRE9XZkZ4L0Zq?=
 =?utf-8?B?K1ZVYVZqYnFrN085cmpiOWJoRXBSa1puaXdjVXNPcUN3SWhkOWNTb2J0TUE1?=
 =?utf-8?B?WjhoMEJheFZNME9NZWpTTVlXODBUTW1MYU94TzhvbFNTU3BOM3RmTVJ5WGZx?=
 =?utf-8?B?UGFhSURFY3Q3K1Y0RzlFOHRhRmFMSjJRMmFKc2o4OE9uZDM5TGJnVjJBVUtX?=
 =?utf-8?B?UHF0SjUxZTBXOG1CZFpOeG5jMU9LN0d2SXVMQWk3d2RKMmlKajRtNWk1Ti9Y?=
 =?utf-8?B?M1pmWXJ0anZ0VjZFSU5KamQ3T3V0SUNWYmlpZmF0MTdVM2VTaXdFRjUwS01P?=
 =?utf-8?B?SS92aytPV2tsSXBud2pvMjJGcVVTUHpkc0hCeGU0WU1GeDNsclZKOE04ZDlW?=
 =?utf-8?B?TXhEK2dCS3pKNk9JTHM5QUJZcEZRTmFwK1R6QT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 07:24:29.9920
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ce8a8c9-6212-42f0-cb74-08ddb3b95310
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CD.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9240

On Tue, 24 Jun 2025 13:30:06 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.4 release.
> There are 588 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.4-rc2.gz
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
    120 tests:	120 pass, 0 fail

Linux version:	6.15.4-rc2-g0e4c88a0cd37
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

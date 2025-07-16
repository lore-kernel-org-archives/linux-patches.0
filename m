Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2055.outbound.protection.outlook.com [40.107.244.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81432F3655
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 10:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752661001; cv=fail; b=eNWm67YMR0lQ1tFNmViDEsrJhwxpo/iV2RV9x28jKDCttD2ad+sqi7f15sYKzmn2ULXwLOxCvXOyXYjOmrXgEN0G2hXbAuMTDAZ97PuprckjVjDyEwwjg12Am7ND2LcwQhrMkEIN3BWbu8TyYm1fShOzusqlV64EzEwhmoL9XF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752661001; c=relaxed/simple;
	bh=DEg0AOomxjHfillBBk5BhfDK4Lt6Y/hYSC+F50NzVJM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=pxyFNJqMpwYbBtY108Lx2LHq/BYkqktVP7Pep5vJSoJ/r3CyK51tTdK2y/w1N3B3VXgZQvZ+x8ZxN3i4KTirWEpe+TTFraaioWsc+p5F/Kl1EKZmKvBwg2n2tkUCbhwd3QYOKCvflSfeXViPnG/nhwOZw/RT9SWFXUXLKCiBVx8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MRMaYmYN; arc=fail smtp.client-ip=40.107.244.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MRMaYmYN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x3i64LPkxBCnyK9E6xewsqKcFXF46JbOjCrWNz90ZGve3/lMn+ppYyEReUrDcBWXb4nlEwAlv32yi8sAIef1T/ibS6sruGeTwT5GD10USTXmqpOD1psGAmtQGsPgTNyV1+wPB93GCbZxilGzH2CRI9MW9VXL8F8qrHF3Za2ZFgnFboWbC8kxjE+JDu47pZ4YD5G9uB4zAEYFxPHDDKoLhtPINvLwCq8nqll9xJJg5+3sFvnHz4qU2I20yhbVszAr7seAnsGNE5CKmpS1uxFXuVZTEIB0OUYc5uJpr2zPuIYn5Ogf8JKc/XiPduvMuxilNCohrsGZYJQmoHtvoTQsqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zzCT8NP+RxQiZCohgK3LOKPaOU8Q0yvn3r4kMdJS83Y=;
 b=ZB/O8gBzxOH4jGLdyR5HT+2tq6CkL/n94TE4CAwH6KzpZUHb0SLtjJ3KROyTjv6IhyHYcpA5/ZXHJtMBh7NoI4U5TdJq7TfYB4KXyZRPPFHe7DY8qw2G7mEmcPFAyojOVLZHxuexHwFtPk4f36eIXc1hHLqma9pAh1wjGecw8blec0oVQg2Cw6Dzn4vCab/HfD62xdlyRwoNS5WupjcIEWo/rsdzpyygolzmbHzuyn7DwQxLXVbXS/+j7snKhOwKk+O069lxW13zq0m9vnihbDrFej3jWEdc74QHdafzaVk5YqLiXTQDYsCvY9jUMghmUVOd6X3PVYEeLknX57hBOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zzCT8NP+RxQiZCohgK3LOKPaOU8Q0yvn3r4kMdJS83Y=;
 b=MRMaYmYNCMj0WJe6tORgmSvbOHAEew9iDGRfovtkk9IbIqWhsiRe0yR7Gfe++j6tRfTQqYzFyMCb4sFC9BWodu4g4ZykvlxKw7V+RzraOmoRJ3RA8Mp26MhNMlVKV7MhI0PCQ2htiRAIs7wRTthVqWVSyViQ9c1e1MKnUJW7+3vDXU52DSCg1fwU9V3OO/4SdTV08S6sxgWVT8IMh5bflSOZmWZBjTWwPenAA6bECEtM+bk1pxu+2yTU71Ma6rl0v+s6WgGKX2SG4ZJZS0fuix0t3FHPjZZhyrdfFBKpmorDlux5emcOm8v3qF9oGZqcvs/jTb4OJ0KwLOXUAtNMUw==
Received: from CH5PR03CA0003.namprd03.prod.outlook.com (2603:10b6:610:1f1::19)
 by MW6PR12MB8868.namprd12.prod.outlook.com (2603:10b6:303:242::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.28; Wed, 16 Jul
 2025 10:16:35 +0000
Received: from CH2PEPF00000143.namprd02.prod.outlook.com
 (2603:10b6:610:1f1:cafe::a2) by CH5PR03CA0003.outlook.office365.com
 (2603:10b6:610:1f1::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.19 via Frontend Transport; Wed,
 16 Jul 2025 10:16:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000143.mail.protection.outlook.com (10.167.244.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.22 via Frontend Transport; Wed, 16 Jul 2025 10:16:34 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 16 Jul
 2025 03:16:21 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 16 Jul
 2025 03:16:20 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 16 Jul 2025 03:16:19 -0700
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
Subject: Re: [PATCH 6.15 000/192] 6.15.7-rc1 review
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <65e33512-3f20-441f-b376-6bf8395d16dc@rnnvmail202.nvidia.com>
Date: Wed, 16 Jul 2025 03:16:19 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000143:EE_|MW6PR12MB8868:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bb98e6d-3b80-4906-6c73-08ddc451d7c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|7416014|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NkxLbnJiR2YzbHJaeEg5Q21EVjlOSUFYc3h6c3g3YWcwQ0IwamYzaThWUjFN?=
 =?utf-8?B?RFdZY3dIbVRxMTB3MkFBTXl6YlFkaGgvRTd5T0huekZsRW1zTzRCdnAvdVdL?=
 =?utf-8?B?ZWZRakZYS0taRkpxc2tvVlQvZzhVOW52VjM1L3g5d3JvRzdJTnVNU2l2Wldi?=
 =?utf-8?B?a0hTL1MxUmJmVU1OeCtueCsvanRxUkQ1RXVsS202UTFRcXF3TGk1SUUxRXl5?=
 =?utf-8?B?U2VGMmdhS01DVTdtTE54eWlvMlM0TjIzWFVuYnBSdXAzRVFnajVSbnkxdnJS?=
 =?utf-8?B?aFY0MDVaQWlWZFg1N256QlVKQUxRMFhIVVVhbmNtcGxYc25HUWZHZUxXeXh1?=
 =?utf-8?B?M3h0QnRRZWhMM3FYd2Nrakw4bVhuMkxTTXpIMFR5UnR1bXM2QzA2c2lhekhI?=
 =?utf-8?B?Z29Fc1kveitNNjNkZmxFMHJqMEREMzBScmhrM1lxT01SUkJIdVU2dTJNZ3Y3?=
 =?utf-8?B?eTdNK1o5OTZQaUhuUXFLYzd0UVFFdWtTaitIYjB6WVhXSXBGYkZ4VHYyZnRk?=
 =?utf-8?B?bDltdStHZmhvQ0FPQWlEcEJUbElQZThCNmNUVXBOektoMFp1UjAwVC9jYmJK?=
 =?utf-8?B?Y2lIbHZIWnNLYm9xWVpKRzJGVjFrTm8zUlRpbWw3Q0N0TFJjKzFTRHRyS0o4?=
 =?utf-8?B?Wnp0SU1GWFJ4cUUweWhtQllNUVZ6WlBoWFVnaWJ5NnN3KzQ3WGVJRklhR1NZ?=
 =?utf-8?B?dmU5N09uQS8ya05icUNlRGdMUnErN0FWL3hYK0xxbXhwcm5kSXo5ZENNU0hv?=
 =?utf-8?B?K3JmL3pHRERyZm9yd2dvU2VYTDZGZTg0UWQzd0FvUTRoUTRIdmppUWwwUHdE?=
 =?utf-8?B?SldPOERPVkhwU015akp2cGZYekwwUENidm9lSXZkNFllc3NrTUYwZkdySkRv?=
 =?utf-8?B?SVV1TGNtV2NYd3ptUFY1M0JUNUVrV1FMOTBmVnFiQnJkYXJieGp6UFRmNWZq?=
 =?utf-8?B?TkpKMDBxVXh3L2hRbUdlTmR3NEh1NDhOSUFCbWxjdDJCMmJJUlRGRXRQNWFV?=
 =?utf-8?B?WFpucWo3eTdQT2lWZTJ5ZDRma2tBZVl2THI4SXR6T2ZoMWJRSWJDcFRrYnFu?=
 =?utf-8?B?a0VidGxuK1dLTU44RXhCOUYxd29lTWJ2WEpZRXJ3SlJXMXhnYU1ETTVjbml5?=
 =?utf-8?B?TzFON2pkQThNWm83VmNRZkFrVzB5NDZlK3dZbFFCbjBTYVFlcHhDaVpyQTlo?=
 =?utf-8?B?d2RYemhQTExkbXZOS0IwOWJMRGE0YmhKU0I0S1B1aUc3MjlEUVAyaUxrUzFa?=
 =?utf-8?B?dWwyWExLaFc3bVZwT05xL0tjQ2R4ZllzVDllbWpES2FDcWJZQ1NkYW9VdVBF?=
 =?utf-8?B?Z2dUa3dQVWZlWkdPcHZjdG40T2xpcXlFbEdUWlhwdHNzUm1BWk5NM1pqZkgv?=
 =?utf-8?B?LzFtTGRVblkrNmpKY0JicG56bVVadTk1TXJyaU1zRFN4bm9zN3JxdTNlVFYx?=
 =?utf-8?B?dVo4MmFtekkwMkNxd1FxOXZqRXZka1VwQmhFVGVoNXVmMDdla29WUzkwelZY?=
 =?utf-8?B?OWZUNnFMcEtVYmxweE5CM0huNHJkZ0l3NEtEYTI5NDBxU1BaNkNXMlN6cUlu?=
 =?utf-8?B?MVRvVGgySVozVVhld2k0NHpaQzZldWV5UUdxcEZXZGhTZ2JsbHBBM3NDQ1Fu?=
 =?utf-8?B?d2JIQ0cwTlVWQmpHczBuN1hHb3FpYjZSUHNYd1MwdXZkcVllKzBkYVVNYzVL?=
 =?utf-8?B?aSsyZklxWHdnK2FRaEtQTmpUKzhQZFpVaTl6L1hkYndLSDFGYmVoS0gwaWRo?=
 =?utf-8?B?YlY2TnR0c0RZWm9lSTFDTXdzMlNpRjlzSTlFRyt2K3o0dkJxOHpKUWVnY3Bk?=
 =?utf-8?B?MnJ6bWs0M1JNWGQraXdHc0lzcnRENzZvaUdUVVlWNmlkTU81Zi9keDRydlR3?=
 =?utf-8?B?REpxWmdhNnFZb0k0cnBDMGRZK1N6dWRBTzF1ZGx1bW5pME94cFFDQ3lidlBj?=
 =?utf-8?B?TVgvM3pMekNxUGlYbDh5THhXV2hXb2NoN1ZEejJGN1JxaXJxendJakZGK2dO?=
 =?utf-8?B?RUJTOU1zUjRHRmJEQWlrbTZLd29HaVZZVWt4akVhalJ5M054RVJuZjQrMEo5?=
 =?utf-8?B?L2hCVDNjUGIyNmtjL290QjZ2OUoyODU3UGhqZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(7416014)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 10:16:34.5992
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bb98e6d-3b80-4906-6c73-08ddc451d7c1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000143.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8868

On Tue, 15 Jul 2025 15:11:35 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.7 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.7-rc1.gz
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

Linux version:	6.15.7-rc1-g6b1915284e47
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

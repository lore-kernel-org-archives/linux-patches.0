Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2071.outbound.protection.outlook.com [40.107.94.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2A27D3EF
	for <patches@lists.linux.dev>; Thu, 18 Jul 2024 09:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721296347; cv=fail; b=QtLNOw6IW1ZxaHToRgniK7U48Z3ETGNj3c0dXVVM2TMY/sfbFJ5XXWZ4qxRXR589kuNR4GcBo+BqK+o+BsZiUutOnUXyejLdRKH3hiWfjEA7+/orlWvsFEVS7+ZZqjlyIX1xM2bix03Ume3TN6QRwM3Bsn6bdLs1r4R7xylvFyU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721296347; c=relaxed/simple;
	bh=yy1K6lJkjAHlwAQ2sioDYLGhOBO1M7iFZECumqGdmPc=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=oLMBiHbIJTj1D/PQnMjiYkgz1T+mDndpJo7zjHROmsQB+c10Q/TZUAtH7neQt4gtax70usrtoGP88jdOmA/nlZlEjWj0ZEruabn1ygWMcNf8gpIRwLXfQNIDd0bmoPMy0KTFm/GSgLrURgWbJV7SK7/YdICIS3bIL6dKYU849QQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EdrOqOH2; arc=fail smtp.client-ip=40.107.94.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EdrOqOH2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nmEFSpyNzEE7rnvzWaxYuTY7Oq2Vge7JzYJKnaJAqYRJFXvl4zoekUrDImmSOGMhtz6ra5mnkZNQQPy30nMLGeeBcSLnxKCYjIUAdxkZFSgHaDtXQBvnUQbBDxIXT8RUf/QukriciR5oRLK38UVgq+xDvFdWt5BykdgV2CiHSgc3HGgkRCcxXqezNRDU3bPyRS/zdpiCyme2t2ASnNwcBuZLTZKkhhvVJAciCQcZfMP7hyZSqnOjBt3inAT9CinI6ic8r9m0tHaKRa5f95dn9jCrsFgn48T3HRh5ce7ocsJLeEhzzheuJKLw7ATdAag8Qyo9m/VZRAx1vGQkJWjKqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rGtZL3chQARSrE3zKbOMYDeksmSRGLdQigQW59rr7U0=;
 b=KfjRjlQwHRMEHOee0DZ8mzlJbzM9VvLt3OCEwgBM7GnLLQaRbZwoD1V2UVyhgXYBVJHDJneD8btF84qOn8vowbbvh7+DMci5JKnMJ7tyKlAoxpwqkqya1mT3Mn0/qp9JNYbbhMG9HFvCLovOZQqhgqTJyU8a+GTlJw9xARuv4qGz2ESyViSCElG6ry2KLq3ktSIgmbdaMODTmXrm66SMTXWQZ83ZFyJEIz7pcIfrT0bzUekWqRj/QXFF7xkK6Hg3lcti/J6/AIrDYvGMzq/od+SayGEf9fJMHU6GVUzPtFSAbdf2AS3n4kENZArFUfDv1h4jbfFytiy6XY2Cm7rSvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rGtZL3chQARSrE3zKbOMYDeksmSRGLdQigQW59rr7U0=;
 b=EdrOqOH2+XqF32r8LulwR8Y0ubYoXeArpcwr1qMmS38+2qI+59LTHdeHDrxRT8Iag56AFNquvyXCpHLmYGDACznVarvfsN4i60c//Jc7mwUZoXTilkjRyDjChaaOYXipKznd/q47b1pXh/8nShcj4VyOpgE3UBJPze02iriXI6WYdec8jwPjL3JeKGE4YEaHnBK3inFmfCFF47KJJi+xhT9v56KGT2nS9XZ2uzaMnsCVsSF8mWSF8/0ykvHUMdxPQAqClzVW9tQpjmBfmaNgzCvXAY3ZmluYWuQLanjrIt51AgtGzcOgwUiMjT9Pcc5mL4HF+oiX6Kob4msORYcN1A==
Received: from BYAPR06CA0011.namprd06.prod.outlook.com (2603:10b6:a03:d4::24)
 by SA1PR12MB8117.namprd12.prod.outlook.com (2603:10b6:806:334::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.19; Thu, 18 Jul
 2024 09:52:21 +0000
Received: from CO1PEPF000044EF.namprd05.prod.outlook.com
 (2603:10b6:a03:d4:cafe::be) by BYAPR06CA0011.outlook.office365.com
 (2603:10b6:a03:d4::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29 via Frontend
 Transport; Thu, 18 Jul 2024 09:52:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000044EF.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.11 via Frontend Transport; Thu, 18 Jul 2024 09:52:20 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 18 Jul
 2024 02:52:14 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 18 Jul 2024 02:52:14 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 18 Jul 2024 02:52:14 -0700
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
Subject: Re: [PATCH 5.4 00/79] 5.4.280-rc2 review
In-Reply-To: <20240717063752.619384275@linuxfoundation.org>
References: <20240717063752.619384275@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <933b1ecd-0d57-4a2d-b80c-7dce299295b3@drhqmail202.nvidia.com>
Date: Thu, 18 Jul 2024 02:52:14 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EF:EE_|SA1PR12MB8117:EE_
X-MS-Office365-Filtering-Correlation-Id: 519677a1-1810-41a4-6a82-08dca70f5157
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cmtQOXVPaHhTdUFOZUFFK3JwbU5JUGlKSG9WNFc5SW5udEtXZ0hxendmRDJ5?=
 =?utf-8?B?dlFnY2xubTgwb2d4R3pmOWRQM1lRR0R3OWRGU2lKcmFyelBYYXJuQXRpNVZ5?=
 =?utf-8?B?aWpLTk1WM0MrOVdYMXZYS0V0c2R3VFd6TEpHd2ZGeE5TeHVFMlBNSDJZN0lP?=
 =?utf-8?B?d1J3enF5dG5mdFgxakU2V0ZFOGlCK0NLbkdwSFUyWWJsUU0vZGd0SStiOTBT?=
 =?utf-8?B?Y2ZwTS9lUVg5a3Z6bjVXQlpDTUgvR0ZmZXhwSUZlQlVHeTdHNk16VW1qWDMw?=
 =?utf-8?B?UTJYb0tVMmNSZVRBb3RJRmRoVFMwRitFOUFnTmx1U1lIWEVEQjRqOWtVZVN3?=
 =?utf-8?B?SDZseU1MYThnQ055VXJMa29Dc0dqM2JGaXY4QkJOdlhZTHArcEtkN05TbGRQ?=
 =?utf-8?B?emVFY2kwT3l0dmxCUW9xa0c3TkRwZVAzMFE0K0RVc2hsS0NzZDZEMFRUK01D?=
 =?utf-8?B?YjM0SmtDdGlUYUVDUDQwS3lySmJ6eWI0SmFtYXFndWc1TWRQanZyTmdvcFAr?=
 =?utf-8?B?T2l1Y3FpVGpadWpIdjBTTi9vNWtXK1JJS2NEQ3l5RzNoTEdncmRSZkJvb0hJ?=
 =?utf-8?B?ZlhKRk5adHdDVFdHOGR0S05MZDlYaitmMTZSSndKWUFVTkRPV20wZ0tsQkRr?=
 =?utf-8?B?VUI5YmVtbFNCZnZQaSt3YmR1YkdhckFqWm9leENYNDNoZVVNbW5ETGp5Zlds?=
 =?utf-8?B?Q010bGF3Tk1vZWxBVVpzZVRnc2pFQjV2RjRWTVBtdVRaVXRxYk13TWJyakFp?=
 =?utf-8?B?OFRwbW9SbHNUczNXWEFldWVTSGx2czA0ZXF0c29PdzV3akhTeFBCOFJ2UWE0?=
 =?utf-8?B?THFrN1p0dVMxYk83d2JFUTlyYmFINVlCbVB1aFk0MWE0SDBLZ3FZampNM3o5?=
 =?utf-8?B?YU94NGMwUmZKTFZpVVZDKzZLbi9CNkhnMlJqNE94WE55Rzg3UGRhNldoOXRS?=
 =?utf-8?B?cnNRRDFmU2RyUmJOdXRUNElJVzJIZlBjT2RlNmhLZE4wUkJISklFYTU3KzRo?=
 =?utf-8?B?UEF5WE01QjlXV1B1M3pFeDRuN1RELzY0Z2ZoeDFpSVJ3MnY0dUtlck5vcGtv?=
 =?utf-8?B?QTFFcURaYTVTRk5JRjIybXBMWksySjZuRVU0Y1lPNUlFMDN0TzA4dk5lczJ1?=
 =?utf-8?B?K3JQUkJ2eUg0M3c0MmxJUjhqeTVzRVNpc2N4dU0xZnVuN1lvbHNhcDRtQUVx?=
 =?utf-8?B?ZUVXSjRWU0ZRblZ5NnlUYnZQVml2UlhKM0N2bzBPb3k1eVpBSHhuNmQxQiti?=
 =?utf-8?B?eVplWXQrZXdTVTQwbWhCQkVtS2w2UWhJMzk2V0FxaUo2Nzc2eG54UjFqUGc5?=
 =?utf-8?B?bElCQ253WnZ1RUdPQ2c3cUEyQVZ2dlJrb00vSThYZmlBVE5INDhEKy82TlNX?=
 =?utf-8?B?QytnREZGTVRHZ3d1QUpjRE5CcExEVkdhSzUxaXdGMFNYYjM3MC8xZTZRbVdj?=
 =?utf-8?B?cjJNUW03OWZGY2xTcjdNajBDaXVCZHA4T01IL0RyQTFhRWlpcHRPY1B4VjVJ?=
 =?utf-8?B?bjJoMkVJcmR4dlZSK25NL2FMUkttem9iVmpjRFhLZVdHTnRsNnc1TFlRN25Q?=
 =?utf-8?B?VWw1SXdKL0ZqOHVNdE9EWGtWTGtnZmpiakdodFZrSnQ5bUs5Qkg2dmJKdGdm?=
 =?utf-8?B?RzVzNnVGdk1aNzk3K0pnZlRqRjh5aFZLbHZXRENjY1pOeGY5TDBBWHgyUmMy?=
 =?utf-8?B?Ry9QZWVLTTROZEpLR3JoKzl1S1dvZEdVOEJHRklWUWdKa2x4T3htazh4d24v?=
 =?utf-8?B?Z01aNEU5NlllR2VVNVZtb2JrZHlBN1BVSUE0VUZYanNDYUZLSUVqNzY5RTVK?=
 =?utf-8?B?WlY3NXlZdFZXYWZVQTFVY1NCWHJ0TVFveXdRR2hNSU1kRUYyN3dXdVA0ZXdC?=
 =?utf-8?B?d3FPR3NrcDdYd1YxbGhSTFFtVGVrYlRyQW9BanUrOHV2NE1EVmdKUXZTc3Nk?=
 =?utf-8?Q?IYd961Xkzo72OWAOuqLc4U0LND+zi1RS?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 09:52:20.9861
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 519677a1-1810-41a4-6a82-08dca70f5157
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8117

On Wed, 17 Jul 2024 08:39:08 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.280 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.280-rc2.gz
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

Linux version:	5.4.280-rc2-g4fb5a81f1046
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

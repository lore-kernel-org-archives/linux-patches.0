Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EAB381C8
	for <patches@lists.linux.dev>; Tue, 13 Aug 2024 18:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723573940; cv=fail; b=f2Biwaf7hENm9Rjz/Yl5bPMqC4D8WIwEHQ1peQvdStXtuQjwuSPlJmdzeRPC3Z3byOcmtvR4eN8jUhe40tgv/XSJ9Ckt1/wNrvc4Ns/0/VNDS2s5J8o2uOCCp1pUGDcfznsHO4jWB2BYlTvNNJkQgQuEH1+PiBdd2Z9t5D3l4hw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723573940; c=relaxed/simple;
	bh=byVigvpKkUCNojEGFvzlLLoUZEYDXWrqbbF2PJCV61c=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=aNqej0FBusevziDLeKkhRelkOF1XZYbDKQqzQWnTshJbJX3rvpF68hChCT1tb5xfrtaCru3iMpYSzA+E55Ttdt87FrXi7AIanhRGLV7C74qHLJK1feSKT+3Wwlbm6cFqi991okrTmxOltM8zJI/YxKJ0Y7jlWTG92TJr70hH9wQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FhL1Vrvr; arc=fail smtp.client-ip=40.107.220.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FhL1Vrvr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iFCXRsHFOKlLTvnqrfNRh0HfMTDpMhSM/TbcWcZRH2JZPcHeVQlY1yoACOQ+gUMh/PsAWonMt604/HLrDSm5OC24FzWqdEJmLv6ELmtPzpnc7jY1JLpD8rqGuwzMteg/Cy6dB6v2aoQRIMZNAlotiEMD3F+jwmdO6LMA5T6BK51ojdRJe6j9wq3dZh+k2WmnOyw7tKGuvZqayAo6I6za/UCMnA5Ifq6mIzIz3NIzWOdd7hSyGqgCRl8gQIQ6YeH+zxIgAiNpCtBDkafq7MKLcmtxu53PfNt3g6ITLgmQ5neS8D8L3UsjCUwWUrEWPkQWCImyroST1GubHzoXuzHAJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w1Aifkt/nL4dnK7dVNKPin9OQe6ZkMvOHnU+OnctjI4=;
 b=NqtK5NnjnzZ+2i7zAj96MA3lMZgLBI1vRHLQtRSosKn+x8Ra6INU5WFIwiU3NUHGMR7tRgRq5Q37JcwmDa30WeZxZXJaLvuzCHbQ0Y54KgTmcLTfnORu8Z1Vm9CzKH7OOeakS0W32NDgz8ujDU6sgy7Tl37NGtIZ9YURmuBQg5Z6mFnoVrNVAJVHzkhLXbcVeaFKkcsW9Gn0kcuW5D8hFJeYyuNLDyyPfMxZWSN/cT3OkBN3pNT1nmzSWNzrvCHE2yNvd4aYIUvd6jFHDRjfozYT5BxcmLvC7tHCiIQIiK97X24mKyYiA0gre4UlhWJYayFQ93arG0Z+fr1jdSfu4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w1Aifkt/nL4dnK7dVNKPin9OQe6ZkMvOHnU+OnctjI4=;
 b=FhL1VrvrTK6v68SGri1GOKtiQ8kO6ehQ6P+mxzlhxBhfmxkQcS5HOnrSueOUFG2/x4uIhuL7mKy9T3FzjSFW9Ub49CWhgMoJce3KaZt4s+zXM3eAyxaBrRlW8lznruefyCWDVTdZyWQQodjHs0OVOqlWa/OzsXcADcdAlfmr4/C4B6R7++wQVUYS7ci/YKIKJwN/50Gf+eNYcOb7tzurFC2BePPEKrMFX7vPaW3Meo0th1Jspx+088o3v7TjHywgPDo2Ts+64HaE3LSog47q9IFY0zppvbqBt5/FOpTTQ1UOpYiovzjcVIg/uLMXf+NE60ej5fej52l9hdSaWp8uhA==
Received: from SJ0PR03CA0331.namprd03.prod.outlook.com (2603:10b6:a03:39c::6)
 by SA0PR12MB4416.namprd12.prod.outlook.com (2603:10b6:806:99::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.23; Tue, 13 Aug
 2024 18:32:14 +0000
Received: from SJ1PEPF000023CD.namprd02.prod.outlook.com
 (2603:10b6:a03:39c:cafe::61) by SJ0PR03CA0331.outlook.office365.com
 (2603:10b6:a03:39c::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.33 via Frontend
 Transport; Tue, 13 Aug 2024 18:32:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000023CD.mail.protection.outlook.com (10.167.244.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7849.8 via Frontend Transport; Tue, 13 Aug 2024 18:32:13 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 13 Aug
 2024 11:31:56 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 13 Aug
 2024 11:31:56 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 13 Aug 2024 11:31:55 -0700
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
Subject: Re: [PATCH 6.1 000/149] 6.1.105-rc2 review
In-Reply-To: <20240813061957.925312455@linuxfoundation.org>
References: <20240813061957.925312455@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <8b0152c1-6e68-4ce8-a814-43871d945a3f@rnnvmail201.nvidia.com>
Date: Tue, 13 Aug 2024 11:31:55 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023CD:EE_|SA0PR12MB4416:EE_
X-MS-Office365-Filtering-Correlation-Id: 269d2f66-e2a3-494a-0771-08dcbbc64069
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dUN3bVhiMGw0SDNjM25aU1ZDUU43aThJUWNlTUU3YmY3Z3E5ZGp1dmVOVE5N?=
 =?utf-8?B?a2ZFc2VkcmpFL1AyQ1VWZEF1aVdNblZCL252TWlnMzVsN3B2WndHTStpK0Ro?=
 =?utf-8?B?THlaUjR6RzF2WXFSZGlMeUQrbHRqMURRWjNmWFlJNFZOZ2dIRGVoN2t0ZVBo?=
 =?utf-8?B?N3FjZzZCM0hIS3hFcUlFQXBwNVR6YTRNUE9KUjhqVUx1bWpHUkU1Lzk0eTlM?=
 =?utf-8?B?Y0JBYmJ0dVdJcTd1bmF1YmxFdUVwbENPZDRhb2pBRjJqVGhESTVsZFFaeFlV?=
 =?utf-8?B?WFV6cUROcVUvM3NSMmZ3VUpPWHVuQVArbXl2Um1MWWVvQ25kVWNESWZRd3dP?=
 =?utf-8?B?aDVJcEg0eHNBKzdjOFVLT0FwOWJxaUptREtiUDNvMEZUc2xRSk9kVUJPRzZa?=
 =?utf-8?B?MzRtd3dvTkQ3YXQ5ekQwczQ1UG1mRVlkV2JwM1RCd3p1QXRtcGlsQlZ0d3B6?=
 =?utf-8?B?TEQzbStQSU5jSHovTzd1MVF6RkJpKzNXNjJkdWo0UlEzK2psUzVZcENTR3Vv?=
 =?utf-8?B?T28reFVnSzBxSGEyTUxXdms2SmtxRzQ2aHNoQldFWDRwZW41RXVrVndCc2Rt?=
 =?utf-8?B?Vi9CcHBzNCt5c0ZyUncwMWZyOVQzclBFbjYzemswaEc0TmxJbHlyc2djckZ1?=
 =?utf-8?B?Tmc4UlNyczJSdVplWkdiT2F6SFFuR1B4QzlURUpKZXlXSUJxL1FpemZtZVIx?=
 =?utf-8?B?eUhGT2JIdEo1ei9iWXliY2gyNkxzYnJ3di9xSGtmbGNOZVlTek1aVDlZc0lm?=
 =?utf-8?B?RzBxNHB3aU10N0Z4ckgzbmtWeWZ0ZXkwaTI0YjRnSHQvQ0ZvZVlBYWxvK1BU?=
 =?utf-8?B?N2FHYVJwam1iM05GNjZweEdvODdDSmRLenpQK3lZRmNDaTdyUTkrN0o4RE0z?=
 =?utf-8?B?Z293OEdEYWhoOG5WU2NuNnFhdy8zZUcxWGpjRlhuU2wvKzZ1aTJzZDgyS3kz?=
 =?utf-8?B?WUo0VzlrajF5MHRBSVhyckY4U0FkRXJlbFJZTlB4TVRGeFJqUGpON2lZRU5Y?=
 =?utf-8?B?b25qVFNwRy9SMnZLalhFM1JFSGJDSFM5SnJ5cWF2TU50K0EvNWVSenExS0M1?=
 =?utf-8?B?VE4zWWRJMjk1MXB1dEIvSjdURi9XaXg0WDY4WDRnOXBueC9xYmE4QU5xMGh6?=
 =?utf-8?B?R0xLYlZ2RWlyWVo4MDVNV3BuRURYSk5Rck5mL050eDk4dEJuM1YzYU1lZVU3?=
 =?utf-8?B?UDU3clFibzBXR0k1aHI0dWtVK0h1N3FTcUxSaXR6blJOMDdVUzJySi9ZL1F5?=
 =?utf-8?B?cG10M2d4c3BtY2p3L2crNlJad3Y1YWtvUjduMm9oOGpFM2tnTVhzd3RBUmw0?=
 =?utf-8?B?blV3eE5UcWJ2OGJmdlZYaTJONE5HbStjZkhrZm96ZHhqc3E1N2QxNElLSzQr?=
 =?utf-8?B?ZGcyQVBUOEFCQUlHZnZUTkJHeEQ4ZzJvMWxDQXZzT0F2TjYvcjBzdXNqV1NQ?=
 =?utf-8?B?aUF0MmpydS9nQ1M4a1c5a24ydGFOWDE4MGNINUd3cjBNdTYxNlB6Zm5yL2V4?=
 =?utf-8?B?UitnVkF6SHhHV3NUdVJxZXFxdWpTZHNHVTVTUmFJRnZMdXJJSXBCMTZsKzg2?=
 =?utf-8?B?eGJmeHBObTJKSzZSYW5iZDU2Qk8yQmtEbFNiTmpEd0FmRUxtMHBmelhoZWhj?=
 =?utf-8?B?Tkk5aWZ4alphakVPb3pSZ2s2T0ZXREFBSVMvQkxiZnlRWlorRms2dmZYNlJp?=
 =?utf-8?B?cnhFMWJadEtCQkJ1dzZPbTJnaUhVTGpzamdRazNFcWdCQWprWXU4ZkgwVHNq?=
 =?utf-8?B?WTNua1Q2OVA3Nm9SbFg4N2pEMENvVmduZHRaRWhkYVNJb2hKdXdBNUw2WitW?=
 =?utf-8?B?WExkRzZ4b1RubVBiNGdtc2ZSLzUwRzNoalkwOTgrb3ozYnBTZ2cvamFrRmVw?=
 =?utf-8?B?alBVMlE2WUZxWEpFTjNyS3pmOHRvQXN0OEZlUmNMOTcvQU1OZk9vazM3c1ly?=
 =?utf-8?Q?zoczQtILJvqbReIuWBMz7X66lYOVt6Dq?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 18:32:13.6592
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 269d2f66-e2a3-494a-0771-08dcbbc64069
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023CD.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4416

On Tue, 13 Aug 2024 08:28:36 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.105 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Aug 2024 06:19:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.105-rc2.gz
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
    102 tests:	102 pass, 0 fail

Linux version:	6.1.105-rc2-g9bd7537a3dd0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

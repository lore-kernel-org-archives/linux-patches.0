Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2049.outbound.protection.outlook.com [40.107.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C278036D
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 00:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740441839; cv=fail; b=Q2ZI8o8ZBnwB1dtZggHyQ2IFvEBOhEJ4Q8XUIFApZITWxh1158awNer6ZjuN8rQystR6DNxVfCW2PZmYzqxJmbYbGDbFZ0grtnIci31vu9++sUKIJfMfsCPJH/9Ezj8e4T9Rqxyg8GjADlgEfa4mR5y4zLhXAnBIOnvc9AZ22O0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740441839; c=relaxed/simple;
	bh=YpnpOX7cqFkc9mAFlO+EMM+7Nhm+ep5TjrINsotCbLg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=XpVcUFLHCMefaOyCrlFA86pHNM9ZTTtRcLOQYCX9Fwpp5UYfnYFUXs/dKAa9bAmU0Kux2lbdVY2PmgGoNQlbTu27TG0ry1ZD0Rld35oK+YcNlFIGlB4PtHkFyibigyEW+rmdEFd0rJDLOyMc70gWJXQWW344CfJUX7569mVgoAo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P2KQRh87; arc=fail smtp.client-ip=40.107.220.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P2KQRh87"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l3E0OXurtv9z5IVVKxMy9CWrcXUGB3frrXvr4DQIH1rDk2Eqq0wJTNVmQqR2twPTgs9FDiumwHEjvmtq+8+ee+BbCtrbsXKzEzztsWT8zWMwJ09dSjwYElxBeko/9DJjIRuVYrFlweOonRKE/NW2HNFpSOqsOfVNqks4/O29EZPlZujFs2kzTfDwpbQnnCCco4XSl1oP5uGJCk+rgBdfM3BdWR60GxwX2fB5wvt4RSAypa3BacpwsUMMkD+RUaIUGEb07LindjlFDN7ebTKwuaoKuZwp1VeP2TneaVC5Q/kuGTFoUdTBD4XSi92lmlzRs5anF0zKtqLPphYIIk03nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gi/nE4kCH3SUtTkzHAn0xqv6JQCuPA5/lr0bp8Bleyc=;
 b=D2ql0oZdsVT4zkgS9eXcCXog0FWtT4Uvm7svl/GbulCSdW1cHPJUH5M+h5gq09Ste+DBF8A553Bl1WmEdiIIn4bvkZEpdna9kUL9XXZ0E6jPFt6RiPjQLtchJYKIwMPYnZiiBcS+XQyn+zs/WxS1frHZWoX/X2vXYHQcgLSx3TgQA6SCT31n9aANLOxef/xt83YUGgbO0V9DH5iXphedGitPLiUHBjSJHqaPzu9Qoz2q7ND4qD/OG8F9Q1G5HMqBg/p9/ehWhsw+CZqU0cSY8IfDQ8wTSDjZZ0cxKEK8oeC+Xy6KMifhJdk6SuerBFp+wprl+o7eGf/YIrSjcAdRpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gi/nE4kCH3SUtTkzHAn0xqv6JQCuPA5/lr0bp8Bleyc=;
 b=P2KQRh87GSJFyieuAAe0XrMxBTmLAMJA+IMfybWNf03+khBAzvZWUBWPOEScbRoVUk770XKhKPX4doUeyATYve0l9k8Q7RLPoOFHlpQsFdhnl5fvVjagcGWhjDEhjNycDkJrL77Sq7acWZTY7RhXbYuZr4UmKqO2DxxTx2g6PA57oxs5ufyR9cS7a3O6+GaKGK5zSthzENPDU5U50mBNS7pOkroOZ73r58ZuhnMbiD0IFRdK79B4ceRfLb9AWZLIazdYg+PGc6bvvmwRY+0VeG+VhVyxkkOpaJHQGH9pl2HAIYYiXOQs2SyN46/KLjbacYmiuHuAg+qPBsi2bw8Saw==
Received: from PH7P221CA0084.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:328::35)
 by PH7PR12MB5617.namprd12.prod.outlook.com (2603:10b6:510:133::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Tue, 25 Feb
 2025 00:03:46 +0000
Received: from SJ1PEPF000023D6.namprd21.prod.outlook.com
 (2603:10b6:510:328:cafe::72) by PH7P221CA0084.outlook.office365.com
 (2603:10b6:510:328::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Tue,
 25 Feb 2025 00:03:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF000023D6.mail.protection.outlook.com (10.167.244.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.0 via Frontend Transport; Tue, 25 Feb 2025 00:03:46 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 24 Feb
 2025 16:03:34 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 24 Feb 2025 16:03:33 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 24 Feb 2025 16:03:33 -0800
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
Subject: Re: [PATCH 6.6 000/140] 6.6.80-rc1 review
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <17ed80cf-903c-425f-add4-cbc5fb65bcca@drhqmail203.nvidia.com>
Date: Mon, 24 Feb 2025 16:03:33 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D6:EE_|PH7PR12MB5617:EE_
X-MS-Office365-Filtering-Correlation-Id: a3ef836d-061d-4281-1ad1-08dd552fdfcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UUVtS3J2OEVzRnVqRzlKTlloRVY0VTVnMGpnVTh4RERCcS9OajR0a1QzTk0z?=
 =?utf-8?B?RUZmbkt1UUljL3U5R1JKV3VqdnFrQ3VDQWhBVzB4dXFidFBpejJuVFFTZi9s?=
 =?utf-8?B?Ykc3M05mT0xyck5NQS9QZzRJSXc3L1NLVml6ZHpnWnZhSzNUcWpZN0F4RHFh?=
 =?utf-8?B?MWRIYVlncCs4R3RWL29DVFhXZ29xaytOZWNScFQvbnIvOVNVQzVVMkJwYnVr?=
 =?utf-8?B?SEhCQTlHWGNqcXliY3JSZGNUdlhBajBxV0dIOVhzOFEzOTVSQ2t6Wi8zYWdH?=
 =?utf-8?B?RTNYTzZhVmVWalVBM3dFQUUrU0lJVlA2Y1dQT2lkYkNVdXBmOE1sVUlSNVJ0?=
 =?utf-8?B?ZUNQVDRrZVRka0VOR3laUGlVS0lDZzJQbERPYWV1NlpJMmZQS1hPUDU2SUlW?=
 =?utf-8?B?aG4wdGJaaGNVa3pwcmJuSVNkbXZiY3pUQ0lObXpBOTg0RG1kaW11dmFBOTZz?=
 =?utf-8?B?eDlYSU9RZURNYmNVeXFyZHh1WmlmcUY3QzMxVDQwTTFhQ2JDWWs5aXBUU2JX?=
 =?utf-8?B?YmxZL3o1Sll5a0pDTVJUczFkUVBFTWVQS3pkVENXaDVUSm45TmpLRysyTE4y?=
 =?utf-8?B?ekNuaWx1amd0RUdyM3JTSGFyUTJ5bzBxTXhpdzJML3FCZlViVmdzMFF4Rm9D?=
 =?utf-8?B?Ry9nQVJ2dURmaHZCWVdGWjZBcDRESU0rTytaeWRNeUZ5cDBCRkdvNXFJTkd6?=
 =?utf-8?B?Z1Jva3o5aVI0VDFsbFlEMHhrTDdkM0ZsTWhHNFp4dHN2QUwzaXhwWmpFcGhE?=
 =?utf-8?B?M2N0NWl4WHlJOUI5WW0xY1NUQ21qaEN5c2ZiOVFFZW14Ky8xRmR2L2tmenhM?=
 =?utf-8?B?RDZSMjJnVGJUWkQyWDc0TW9VWU1XbmMvNlYzdWxJZEhFWlVoZmZCbTFmbFFZ?=
 =?utf-8?B?M1pvY2pPZVR5Zm1melJualdpRFh2bExGRTBLNUFVWFJITEgxL1pXYmxpbTdY?=
 =?utf-8?B?cG5XT280TU1XeFpwUFQxUVhBcE9KenFKSkZhNHR4bXpEZDU1UnhLUHFKaFFR?=
 =?utf-8?B?SGdqajZqbHFkaGlkYkpESmpKUGhGTFNsaUxQWTdrc2hWM1BLb3dRcjZNVzlq?=
 =?utf-8?B?TU8yZHQ5OXFHT3dIbm8zRVk4TXNEMWJ2NGJrZTd0eHhXd3E5emQxV0NicnY4?=
 =?utf-8?B?TUlWdHFCWWU1Mlp3UlFDWExZZnk3OE1BR040ak5LK0QxZCtXRWFjZVpIQXlh?=
 =?utf-8?B?dXFoUytNd2U2dytrdWpjMFhnNUJpc25CRnVsU2R6c3lWN0g2R3djT2Rwa05L?=
 =?utf-8?B?NEVDcThzWUZJY1N1eVRHQzgySGljUXo2MmdEM29nRVdvQzdKSjVhaHJTTUNB?=
 =?utf-8?B?dGk5NVlXdEJ1aXhDWmxPZU04bFBKQ1FabGdWYytKNXRIZ3dnMUVlbEE2QVFv?=
 =?utf-8?B?R1lxclU5MG5OVzZxS2RPWmNsQlBIRkNoQTJ1MENzMjBXWDlIUURndGRoMkxv?=
 =?utf-8?B?UVZLb056OGoxM21SV3k1azFWc0RoM3RZZUh0NThpRy93YXMrdzZ3d2xQb3Fa?=
 =?utf-8?B?RDYzYXpkUU9TTG1sNTdYN0ZPWHdPR2lEOHB1OUNpRFFsSzVDeERqdzRzN3Vx?=
 =?utf-8?B?STdLWFNpa1Uzc3ZtdDRYNklEMjdVRzFoQityR0g1bEpGckdoQXdOajRKT3Yx?=
 =?utf-8?B?K2lWT0dpRzN2WE9mYTNlNEhOeU9VWkpKNFhTVThLbzRCbmpvNVk0TWtqZ3c2?=
 =?utf-8?B?VjJmK1Z0dGRTSFdySkhtamVjTTB0cWZZQjlPemlYWHkwVW5SM3Jsb2FNeXJt?=
 =?utf-8?B?dW5EOGp1MUd5a3Jxc0JDYWpFQU9jY2dibVA0ME4wTzhaSVl1enRNU3Q5MUp6?=
 =?utf-8?B?QWpDMTFFcUw4eFFqdmZZUTlIK3BKY0JyT05ZL2Y1NVpqUGNNL1JSQ1Q4WVQw?=
 =?utf-8?B?dUF3SDJ2M1JuVXhPZmQ0azJBRnVqcCs3TC9Gci93MWhoRXhiMkR5SXM3QzJk?=
 =?utf-8?B?TEM5TWh4UmtFN1hQVC9IUHBlVTBxQjBjVlNHd2o5QXVOTyt0b0doRnZQWGtk?=
 =?utf-8?Q?fZ1uiCu8nwtSdq9vLdCzDtD+e2NX+4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 00:03:46.2841
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3ef836d-061d-4281-1ad1-08dd552fdfcc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D6.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5617

On Mon, 24 Feb 2025 15:33:19 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.80 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Feb 2025 14:25:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.80-rc1.gz
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

Linux version:	6.6.80-rc1-g6bde7e001d63
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010018.outbound.protection.outlook.com [52.101.193.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936DB3D9DC8
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 17:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775754980; cv=fail; b=sOsT7aVrPb1ckr9ddUMk8XbZgv/x4waxCp4jUswpp9M/N+LJK/pRR8lIBeZ8trmO+W1+Rt3cIVFqP6fjYebDr4ZEi6CPCIn2dcuq1zVjU/Mm/TCHxiqYqq2tTR6uIiNd1WeV0hsT/XdCgSdkqh23lVu11Mbsoh9A/RJICdr1iBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775754980; c=relaxed/simple;
	bh=zhSkhRRG6L7UqMuzvSzuqk3sVlxzIrJC+hpykK6FBSo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=imcVEtYRaPAOkXSNWONHDVq2fHdOXj1gmroan+WTeLODKYsbZB12eAccwRNpd6/iiTeZVd04prFiXBsDQkvHj+O8cXR7pJ2KuazGNj8IhAcIMN7SYLASJLxNglA3glHAbCUrrEZnNLlq3pBYnNs37Eqq0dNdkxy9VKj0bXq7EbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uF+I7hlI; arc=fail smtp.client-ip=52.101.193.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uF+I7hlI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tQxtV01ZfyJoN1Z/PzKRWIt0kxEmhdBudKWKlpGWQiEDoEVdpTP1xRPSaIOntgZtrGTxi0x+rjU3S5e80WCIhXPqUoqBPS78+7oHXB82knjk9VPCLENzgG7EXgEVk3MO82bQljYwMwaP8qwaZhRPABus1kgEwrxl8bSEcx6M5ieKGFGWxcXldm48Bt+QnzC2sthTv86am6k7qb4Fmn+S1hobBmOCMm8wh7TC9rkz3Qv3vA1Y/gXdfvNBekEDRbX5H4oH5I/qHr2yE0TmIJe5fzYHK7TjI2bqfF0xrVhD2S1CO+VO2ucRnyQ0hIXxFsXlbl2IqorWCI/n46U53maymw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tpdySZ72Hp/1nhW39261C11umUucFcCn0VtMpPYBzn8=;
 b=x3EIeugpTCLqr9DJLLU2VEMR154VH1QGBEloO1dawqHPo8V3uVHN/TiGh2Rha7dtUnU2sKOuyU+c5T9HPlh82lR8LW9rQ/tOjTOh3Mf6PMiFCVKpezOmdfLA1ceG5ofl6xTOZCUSHTzsV4xFQw4GMKnWDOfLoQtYmR2aUWceWbw1ZQK5RPgNp5h0MQ4EGBOccWGLXYTutQbDuyxf15jxsgDTv3dhxDJnW1bV93shLv0zKn+7vE2FD9lAwVVWe9dHI+bF2ajzF+GAWJyhmdnn9vXAls4TzOnMYHN2twS+YH1FUyq/JfgnzTYAL9u9F0/eLGL02bMVf4DFPg3RqvHN+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tpdySZ72Hp/1nhW39261C11umUucFcCn0VtMpPYBzn8=;
 b=uF+I7hlIRJPP9L+UPq53d4aBIZWPSccvFA2E7zfuArP029QLbnYHcjtB3b/8Ek1kBPp/H0GW4J7KUZVZ0YM4iQPpo4h2ZwhinkJml3JHxEy0SgOByDhsK+iE2zzI4PpYF2PkXpK0TKhzd0OzXsVXcqXQ4yL/CPenI7zAl3V1VJ2wmTkjp10agiCB5NLJG+AZuAcR3mBjRwTq6nNCvcuuiToLZClxxDvGUSqy55KXgrshnadT+VlQCbt9t0Q3h5H1ryuA5vrl0p0T0mf+CO/Xarc/bcD3T5Vs+bt/rFy+4mguGD7bobXGIqKSDtFyby0OKrF5Q+5+tXZ/heSzjH6sYA==
Received: from MN2PR14CA0019.namprd14.prod.outlook.com (2603:10b6:208:23e::24)
 by CH0PR12MB8580.namprd12.prod.outlook.com (2603:10b6:610:192::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.42; Thu, 9 Apr
 2026 17:16:12 +0000
Received: from BL6PEPF0001AB73.namprd02.prod.outlook.com
 (2603:10b6:208:23e:cafe::56) by MN2PR14CA0019.outlook.office365.com
 (2603:10b6:208:23e::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.41 via Frontend Transport; Thu,
 9 Apr 2026 17:16:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB73.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Thu, 9 Apr 2026 17:16:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 9 Apr
 2026 10:15:45 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 9 Apr
 2026 10:15:45 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 9 Apr 2026 10:15:44 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@nabladev.com>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.18 000/276] 6.18.22-rc2 review
In-Reply-To: <20260409092720.599045151@linuxfoundation.org>
References: <20260409092720.599045151@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <7d894afd-c3d2-4241-9bb7-269fbd277c5c@rnnvmail201.nvidia.com>
Date: Thu, 9 Apr 2026 10:15:44 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB73:EE_|CH0PR12MB8580:EE_
X-MS-Office365-Filtering-Correlation-Id: cef9b1a2-9efe-479f-246c-08de965bb33b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700016|82310400026|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	3JytkdqvsUFmtuaNkDZRN2H04nHCYvuvTZwlGpni/oHq+W6dSf0PSJguoIdyjwvrMchqrjn7ugljQA6cvR59qyMKcV0vT0STdMM93Nv8/bU1t2bgILbAD0Yh3/Xed6skNc4DuJM0IXcPB3GUtsDpxyYfeRn4ybDACr+lJLe0w5Xo4scBWAHf9kKp02PZH5Oelj4c9cdwah68MX5z2k5TdL5BaLFD04m82lQYnqQHPfA8jV7hy+m9ofrmKFE66z21EfvhlOKwacwNc9igPUAl7k0GFxp4guCAR1zOOQqe6JkVo2heuqO8G6QgghUmFId7WXfY3SrKLWlug7B/fMFeFPCsUvEs6uVdDb+QxjLMOUKQd5dqwsdZ41wBndgjqCioJekJ5FdudFdYaTfeSv5Q0IXTJZ/rmIIgOkguSVRcQZDqXb/mwNx6wzgKh7fIBuTJIhXQIg2HE1WMocyL5uEh2hXHKcqKt+UD0eyczXUMElF1+yhimWiDBhgH1SxtPI/Vbt7tgC+zpZ9Ypo04f061HlEGo19eI+r500rZ3vX5XzldC511g/qruZIytO2rj7+Lnps153AG22tDgNNl7dkihPakle0HjEZRDmnH0sQd8E3Xd3Nnm9zH/lq4uxFGdCB328RO2WUMT/+1RNfPx86WwbVI3zCoBTTjCXmCT87A4/tSnBXVPKCm3gODUX3kPI2DGrhqWkWRQ4805eaDweV7NIJIRb81POTUMYv6mAv5JwN+mL5bfLCCCeJIva9M52wo/yJW2e8NIQ0eR41nXWV79w==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700016)(82310400026)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZmmtzXNBNaE4w7VDLsO29mUOq52tctUIMSFaQCNuEjbzzNvLqknRNIx7xSv1ZVLraPYKGemTWsto2sJ8B0XlC2JUG10pm7ClmWjQptLzYdE+i+gfH2OzH/xuKlcj26SPb4BN8UgSoOTjNaieBasCft9GKePnPxoHPwG17tZbyXGbs/BlUTzGipvCP5TLlBY0Rg+tLHCcfsQ8NCruz69aCpaLjSC+g2R4RCMgdUyw1d7eJNkihZ//ikfwjTW6BUH6TQ3/iz9KiQb+hIXhp2Zy12MzWrQc/w+oMmF8+33dVydhiN0g/1yuB5MLu8x6NbUV669g6/aB2fUnJLuF+3Dl9sBJ1HzKv70GVqcAByoTzW8xFWgxVAPC41knXz1rpHwCcrqoIQdKixunQblhtDi5/MDLB6woc475OgigtF3VpVlR2c7v8FTprqEl4RW0V6j9
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 17:16:12.4502
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cef9b1a2-9efe-479f-246c-08de965bb33b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB73.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8580

On Thu, 09 Apr 2026 11:27:43 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.22 release.
> There are 276 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 11 Apr 2026 09:26:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.22-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.18:
    11 builds:	11 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.18.22-rc2-ga63e494538a2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra234-p3737-0000+p3701-0000,
                tegra234-p3768-0000+p3767-0005, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

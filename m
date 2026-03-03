Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011023.outbound.protection.outlook.com [40.93.194.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCAE35CBC4
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 14:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772547184; cv=fail; b=HG3qNk+dfUbruKQbTt5edHbBQ5zy2FvI2hIuXtTepzt4HRFhNsYTvqFvZ8bj7wB3tLP+XLaDpvX7DKjpLDRB5yjzBQ3VDJmJ8woNFPvGu/cQfbyhJyLeSQ1xwc88N1It7MY96fuO8E45XIZeRjMubQCQBMG5DxnaqTNaeNn+F3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772547184; c=relaxed/simple;
	bh=EuFygPYLGuOI/paA+vR9I+w+wo/Cc11n+KU4UeoezLY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=sZ9oa+iPC3G2IpCHUAJXw3QQWmjQu4laenPypZ+GF2xv5/BPQY6QsSMLA6OewI+V/zAMGRDcAVSo8itzXabRc1/MbSosIFsxQfhTlnnhPZ8n06vFSPWMfpmTAk0CJGvdkXbVNsQRyodqwwJdx63l9qRwvpmtb+W6BxkwfyzHIqM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cwYdm4Oe; arc=fail smtp.client-ip=40.93.194.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cwYdm4Oe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SozDtoOVbMNjhrtZvLA7a3d2nnmOXgkk3sxL0ltO74etVaMoSYhYB5kakaUxjHllve7w46d/Zx2P+nCYJV6lV4IF38CPayP6ZxDY0KyiOJ71t15m42+4WTn7q6c6SVglTWYuyUN+gNCC3P52OFWNhxSqPfTksF5AgW2XzdXm9mBjeVwW1xvr+37y8thC918qNk5LGfKeMEFm4FkR+yAkRVarosfIBEPtSXHvIZbuz8O7hAZr7EXl6+iECnSjTOmcxRiY2Ddq7vg85XMivvslKhKuNmtM25yyAj9iuFVQKKf7pTgPiyAtpNKGn6LS9p8hFtLfQfEu4USnFJ/PUuC4cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BLdi98ynXI9YPqwdcfM0A446Tj1mooW3HINnjf4X/FE=;
 b=rtTRvwsTFtnTUB3FQ0QgmSFl2qN4X/bJhjl7IL6ZHMMa3s8xH18lyqE1sr9rdWcMdajsQlZE01OeMDVVIzqv4elzkiM0OfsMMx7dmg522KsGFJg8YdE51kSKGxRDAw8VfqXs1xTkSPnShQHYu7rJneJU8/5CMtRJu7go7kEn06/0u2FdevsC02uhdoGIfcPPIQPfwPO+TNgHfI/Ej9pgzPzuyyDkpC5V6U9Tu5+89dMmTK5a2w15KNVfVqeWv94WboMdoAqJ+RM0dzEeMgx6wPhxaaBHw2Mxa06Mr/Q3c5RHI2CFUeKrqDRT07XE72r/qqbayD3kGXRquatnXl2Fwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLdi98ynXI9YPqwdcfM0A446Tj1mooW3HINnjf4X/FE=;
 b=cwYdm4Oegub/UXkY1dZooyrI/z8jxkWty2O5ehEFP8OBjlkDJxEqNmcSHor9d1dnfmF9QLTsQSQmg7SqfU64jqL0gyGHmJlBjIDOAzyYrICwlXtIHAF/uxY89lP32g9xkkFytVTz8zyO6llZaUiVjzdpAoeywOSCR9Ofql2cTDirDzfog2pKuanjMFuBkyb0KBbTq/IjqXJVWrV+M70G9cVEEa1AucdQ1HjM9mePOQyrQu6fYHCjCh088jGNd13FIskX0jAvjIkP0GZvNaS6VriQwFv6T+pJqLldQOsc4e/K8qXzIJdcZzdysLxNQeWaxBA+HTvBSXEALI0Wf5LyuA==
Received: from MN2PR18CA0030.namprd18.prod.outlook.com (2603:10b6:208:23c::35)
 by DM4PR12MB5721.namprd12.prod.outlook.com (2603:10b6:8:5c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 14:12:56 +0000
Received: from BL02EPF0001A0FF.namprd03.prod.outlook.com
 (2603:10b6:208:23c:cafe::56) by MN2PR18CA0030.outlook.office365.com
 (2603:10b6:208:23c::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Tue,
 3 Mar 2026 14:12:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0001A0FF.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Tue, 3 Mar 2026 14:12:55 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 3 Mar
 2026 06:12:34 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 3 Mar
 2026 06:12:34 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 3 Mar 2026 06:12:33 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Sasha Levin <sashal@kernel.org>
CC: Sasha Levin <sashal@kernel.org>, <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <torvalds@linux-foundation.org>,
	<akpm@linux-foundation.org>, <linux@roeck-us.net>, <shuah@kernel.org>,
	<patches@kernelci.org>, <lkft-triage@lists.linaro.org>, <pavel@nabladev.com>,
	<jonathanh@nvidia.com>, <f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <sr@sladewatkins.com>,
	<linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.18 000/757] 6.18.16-rc2 review
In-Reply-To: <20260302160853.2519610-1-sashal@kernel.org>
References: <20260302160853.2519610-1-sashal@kernel.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <86f043e2-a657-4c28-81d3-a0e21f1db519@rnnvmail205.nvidia.com>
Date: Tue, 3 Mar 2026 06:12:33 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FF:EE_|DM4PR12MB5721:EE_
X-MS-Office365-Filtering-Correlation-Id: ddf2e55e-3489-40a6-357e-08de792ef723
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	bC6fdmdSBFvVjd9PFB6vH6DIaomG5bi3PjjOknpXYfPSC1cDKTqbFbJeC447DzKOq278A3nykGYHGlQptr4G0KQbyV8h3zqjZEomCuCR2yl/tpr5YTCk4x2+fI6phD4qM1oTn6NS+3YZAoSyDPMUcKzqxmupXTJ70Zqj0jeQBIkIZ5UONbyVCt0LtcKtTVNtYvML6ZT4Cva8253ejyLx4KPxv/CZhuSV9D2Yptllz4N8DKMW5V2yFrlh2H2siJS5XWODpjuDhixHILcLjGBcP5nrr3qb9lPy7Q995xRpMIpEYPRKejOwwjvdjGf9yRxtZF2QsV4hm9sEzAdZlTj3wqMdyO3/RL0BSA3dvS/SbINdNZVk+7KQonSzlJcDOEPg/K6Q1TzDgTgV++jtlgfhBZ/QpDrk/Ot1EvBuu26wcY0KUlLxUi6LRh9jxmmZdlRYefRlu/UgCurmel4yGcyE3BH/j1F2Dm2EU9SzEWHtdbcsfxfg/K6g/NHWbgh84a+j7ZVJVntnI1j9YR4Y2uYdbtdHm23CZQVvydL9ySfH8ETG2R1iwGV/rWncc5hqeKfoJjaG32QuYa6y2HI4KOlFZJMOo4qHnrpRhMTv9a/qv380FXCe9OY9MKad++IHkzywCpmp7LE2863xfVGZ5Qq/lnkw1aZ3nYC9XPFwUcA9B4axxn4byRqtAYVpk/C7HMn2hsflmKukRKYEB1TF0KBgHxze7AQFUtZ06LaCModcuLrTiEeWH8Zsk0WFThl2/RrMBetHMWSvGhvHYkMzGmBdCW9bZJEvSQ7lfIzcI3meHTE3pWmEEnU/yHmgw9kHOUnJB+dkxwv2QnlfUWgiu064iA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uFmOdqN4ZVTxy6tCOGpgTiBJ4KdaZGJfsmyR9iqRL6xrSv0aQZZeT+sPo4e8E36mFzqFYJkFl6NVbXuQAZB668PGEcfA0WDEBycs06tXXtIWPMyPHZb7C2cImYNO/mmAr0D41FAKW7ZvpelAGJlw2xrjiGotNr5x8iQqbsqmOFfw8PSL1sHcuhSbe/graMf20CpqoKDuKzeF1TY3uC9axzd3UpRawnfUtJpsNE4OWZIPP4rtC3ncoQguIeE6opvjOkpidC3Y8DScDJsYMl2HX8FhQ3GpR2USOHwO0rvi9qGUJDbFPrHrsRDn8Ov/GVli6Nyhu9OtRdJV5RTPoYonISyRbY3gSnWi56g83LL6OEHE8gfDd8UnaZW3RpdaGDyvEBD9OCLzzKK6caTL2Eiq0JZsJ7DnildbD+PJEIBuTUFXZ2U97hhCmxS3JC5NNx7m
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 14:12:55.3709
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ddf2e55e-3489-40a6-357e-08de792ef723
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5721

On Mon, 02 Mar 2026 11:08:53 -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.18.16 release.
> There are 757 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:08:47 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.18.y&id2=v6.18.15
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

All tests passing for Tegra ...

Test results for stable-v6.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.18.16-rc2-gebe1b6cc3d83
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

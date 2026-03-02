Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010010.outbound.protection.outlook.com [52.101.193.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02713AE6E8
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 13:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772457244; cv=fail; b=PybmuTimLTrKoQ7HgOKtg6PKcOQBat5gihy4RkuAom7iBEZlHtpfkHlKJXIPQINDNsZ1GJhpvklS3n/06pYd/FxRZMxMX8p4g3QjO5KIuJbYml2bT6FfdZj8ZUfU7EXnJ0fpSWLsmPww2L+pevFPN3YTFS0CCZG0HiieVVHQxKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772457244; c=relaxed/simple;
	bh=KzhGeX4Hbw5FGQXhFmL362nBcbME+vBKyU1NhkPk5dI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=AWpZVG6x6t60b/T8/a0wrIlXoRIF3YR9fFyRAnTKai8SVzalUigsJs7J/TZX109GS8A5hvP3lDLMeDZHHRtZBLK+Z3HtGoLuu8Bmek4Uw9yi/7McEkZppHY4IHbTo89VyvHVPdiOYOxixoyLvilq5w1gRfdzAfh+/iAYZJRm2A4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=K729X8pE; arc=fail smtp.client-ip=52.101.193.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K729X8pE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KdcpXn54E2YTj5g5A5lPGUn37oPo7hvLWc9wohVemexkEMKRVythEQRtZHcdBsEhUSm99m5nM9uFwQ+flfNhCgtBX5Bb8DlT3wEeyL+t1H0621rDOVsvGgsudwl5PGO1tO53Kw1haapKcXlkwYPXnLah9gLA3SUR4iz8RfKivm9UU3xNJBbfMlPMNaCpyGUCAe8RniZjYk/JlhlXfEeqiRfTBlN0Xo44nDnjc23lbpGHWApUKsYEXKNrJwXVhPpgwOzh9YG7StSqmbcQlgnYfyp4zBbGOQZJGx43T2pbPxj+TAtXtLrkdndAoGFEL0jf6+qirwSJ652OA/quVhpukw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FdAfx+kzpen9XSzOyJ23n4G47c2T+Wr0LfLR1yDnZHM=;
 b=oo+o1JvkZtShAxy/1f2ysQXkNmAW3+zniEVZkwPtVOMrfwdVvSxZ0rktopl6bWq/z3QewgDRog+51JJIJVJ94zIB5J6FxU+YCIQzfJxMzcpxnZ640I54k6eUhduHoxXICnq6KT0xoLvxf5qR8GDc8vdH0A2fEGK+p1E3Fj1+vQsjfhQA8BRLWugljXCRvk9LSVszZ7HqnktV2tUL7NeoTMI+/S2owMbcoqi1XOi+BggGVq2vXxPC0kEzIe5Oi4G0wNE8egE6zngRRY5gJAkQpS7wHewJfjahOPn06oKFrz16zI3/cPbc29CWqarFA8PTOGUwj0UyogXJDG05xbfJgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FdAfx+kzpen9XSzOyJ23n4G47c2T+Wr0LfLR1yDnZHM=;
 b=K729X8pEXVGJSXk8VPS/+UZaCRo8DiTRBngkV877aOl06d6Mwsg/O+CQJHwyeH/7T9+biC2JLM65KnbtgXMoH9m3Qkb/RZM+Qk2I7m/eSSA/kME3CqoVNPOohSE6vagGrI9ZWB5EvzIiBHHcZRgtjHTsnEfPgamDUuB2kRXS3Yhhy2uoJUEPA+Iy4cOy7bWG7K6fJjz8QaRRo4NJFfgHL/XSYFytYNt+uAlsUTIWvzu6aeBH6VsfxR7glFw9NZA17wrNOWzy7PAJqAx7At045hukBv17StvyyjUSd7K1CWiDgOb4ZzXvkLjtqfWyP6yRaNSBrV3ZHXJrHqvwlHSQUQ==
Received: from CH5PR05CA0024.namprd05.prod.outlook.com (2603:10b6:610:1f0::29)
 by DS0PR12MB8245.namprd12.prod.outlook.com (2603:10b6:8:f2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 13:13:57 +0000
Received: from CH2PEPF00000147.namprd02.prod.outlook.com
 (2603:10b6:610:1f0:cafe::85) by CH5PR05CA0024.outlook.office365.com
 (2603:10b6:610:1f0::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Mon,
 2 Mar 2026 13:13:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000147.mail.protection.outlook.com (10.167.244.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Mon, 2 Mar 2026 13:13:57 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 2 Mar
 2026 05:13:41 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 2 Mar
 2026 05:13:41 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 2 Mar 2026 05:13:40 -0800
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
Subject: Re: [PATCH 6.6 000/283] 6.6.128-rc1 review
In-Reply-To: <20260228180659.1583364-1-sashal@kernel.org>
References: <20260228180659.1583364-1-sashal@kernel.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ec583969-31e7-482b-93f2-a7ed631781d8@rnnvmail203.nvidia.com>
Date: Mon, 2 Mar 2026 05:13:40 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000147:EE_|DS0PR12MB8245:EE_
X-MS-Office365-Filtering-Correlation-Id: f5c85435-0b25-4fbf-1ea4-08de785d8fe4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	aXOZzeNojvZx2JE+612ga6qH246/gIPDmo+EXB0ZnEduECBFthweCj24HgtfmNQeS+u+H0Yl68sNGkRNuNjJLNt59Bbv1CUG0X17HssrtizNYRfnQhUtSlV5uysWqiOGMCjukKzD2xzJLmiRvmwHWdiZw+CQykIP9T0DK5g4zjFI+KCVy81rpz+aojqAl+fh7jvLpviurbipCadyLrChukHLAhUel+zuQsqBacN2rST5Rrx36RqCnznLhS1xcqtrKjE49xhu9qjwMmBPoit0keqK62V2VUmDTHDLUHw6JLtcR12k1mfdb14FvTATLDbBn2kK1y5vjvttPwGHzUoB1lMLXSa5lLkc7e1xPerknTjQ4sD4CZJuG7v+7tvjUCep/yc+kPoYJPQ1NHTR7mw47y+dqOULl/8/DECsRM5szU1b6zWzN4L0JAB1n5k+EkaDiBImoq2+Wccg2C/oXSSQCkrhAgY+dSLLZI/v0MaVbo37vp68rLPo4g5UclyI8/A9QKKk6elHZ508+oa4JpHJ3lYQlroeMIsKh9IbFqAHVc8xhhyLrtW4FNVWbhYnu51ThCv8wsaRAVtQXWwmoRD2uw+7aJPN0Q3UeRWkagMygnArZPnb1z1y+fiBQCSUbio+qg1xw124j3xUwsnpsCgoTjdN8xXbbWrsNQqAMMMgOPM5Po/iGA+4tijaPB3R5YzXv++2qgvgzqIml4YzmUKYYOZ1R1M1+zPZES34yPbFhooZ2xeyXnZ99MhDFKuyJDcAp9S80m5k4BpadvTqpSWlNwjugqK5AEi0dw7RpFNjpMM6GgBAlIyy3B4lfpN7lOuZQsiwhNPNmcUIvsuYjz/BrA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	GwAodWjnicJHbK21KThAp0ju46v+KIEblT5vifeykZ27xKbTpkQfU6bsyDjei4dHA9JRrvEItCP16SGj3k7BuooeA+hFEVW4EK2quPg0PGHe0sq0ezJUU24jwR/zUCLjY+CQb47SReUAorTG97mkBCNzkMaa07hLQMDZCBAz08Zy6uhCgbF8m+uHG7z+zj60zNV/FEeug6WMA1a3/dLfwqm+wCDBbrvbB6p+Mbnk8Nd35VvfYNe41SV74jMgL44E/LTJrsZm7fiRzLs731lAwaIpo+pWwC+Ae9+vpVYuQQLS5OOh4IzXRVI1/mULjRA7PYUQN3mNzjWyrf59MgRO0xZgcp0Zk976Y2bVKZeaRIhHxqGL+1w6JVHSDa58v0CGUAxU+P8wNvrAj/TKy2hXByy1NSvCA1v5kuUfFNnO/36XpB2bfLW08IPixSLsF9RW
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 13:13:57.2878
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5c85435-0b25-4fbf-1ea4-08de785d8fe4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000147.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8245

On Sat, 28 Feb 2026 13:06:59 -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.6.128 release.
> There are 283 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon Mar  2 06:06:54 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.6.y&id2=v6.6.127
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.6.128-rc1-gf5d2e8593696
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

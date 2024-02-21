Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2059.outbound.protection.outlook.com [40.107.101.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FC84CB28
	for <patches@lists.linux.dev>; Wed, 21 Feb 2024 12:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708516955; cv=fail; b=Z6QPrMBai6Y75k+ROpBTfXtrxS84W1pQgWSDyxeZWrt3J+k4LD7RDHApaj3sFQUldCoYLdHDEKF7C1uPVEZ8quQv5U134tUAE1cIK2rmAHyBmidL9vx6CfqxUpem0frrHAbXj9NaDXrLFLi3rdLW1I0fgZ+EDNCkqfTPX0GPNwQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708516955; c=relaxed/simple;
	bh=+GXPs92cA1UIdiTJU9wmXAwOcAY/owZnivdhFXGXsF4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=V/neEqQ3PARlQ0vzKsBXv3ltEGpA+6DGISIsZIM115qB/zpcOp9R9/u/wQU5gtEPnFHRsESBhAHuNAtDE1dl4Rp69piazXts6/uCuDIJ1epxR2CcrdO1Uf2YfQx9qTeAoX9Q9dgy4IabTouSXYJWXF3N5bovBrVB6dYRiF5J73o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Y+xaR7B6; arc=fail smtp.client-ip=40.107.101.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y+xaR7B6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HG92z7QcHBkM2WPlM766/m/EmA6xoQQa3B1TOttoxylni70aOOJpgWBCPga0CEnsWeR2RAvAAa7YY6/Ef0CxB2hwIpAVnv2qE94ykcG1ulMvs5k0jefmbgKz4y/pZmgVU8EPcqJ1BzglucORJ5gly3FaUXAjjSCQB+HRcYWMVSC6Wy3wK74jidXkny24+fTNTowOYxYVol/xW7GR+S+RAglY9P0ECvDmZmmIJuubFJAcmqSfPXqNSaN0J/QW4zee0Kx/cZDKvTfDAN+sawkrz6eHxxaVmIWU68bKfLtdRc8n8JebJK8PwmWuZRNxsGhj6HCGInWjyRo0F2hrVytWug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=86q63W+SM9UnPw9O6XYUd10/uVR3pnGbq6FHNo4UhWw=;
 b=Q+qtKN3rhmxji53NQt9gAwuw5lfSXTrlm8mziE5MWTFuDj9IjUwyfLQrCXO0+FG0Mi/Z5UU4Mq20Iqedi7eJ8Rl2fumfi/QoxoSnMtj8xr+vWYon2rk+j8jfFsG26rJPPry5jSDGVAih62lvzKRGMC9LfYk0M/LHaITAClj/ac7X/34wFHvdCfu/bED4j5hgYvpWgFvxy+ddnv29AEY9LsFM0drfGiRDgw6I5N0PvnPVSo37ZfSCOQ5A5QEBsZ+SLWBcihc0J17tqGwoiYEhm8/i1AFNYl+5/AloBA2Uc4pvO0NqseaMS0SYXsJVYFh+ohn2HwvXzMCD8oZcdh6TWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=86q63W+SM9UnPw9O6XYUd10/uVR3pnGbq6FHNo4UhWw=;
 b=Y+xaR7B603tYZjPlmY/m7zqGGf4oIQnCaVZnOmIXx6ps4xCxCrPuCr+cnNnrmSTR++G3J+ql/PDKRr9W93tNaS67T22Pv/fOKhZ+QAzOnPdVVWtmftHBl50f9LLrFRwcssxshYfmR6hcAQKSg6ui6ACnP7vD2VxdmUVawWwP1zHeuL0NVzsJfAAgsmQ/IuNStf9pWQBrz2ikGj9zB+pQWBBX3mX9nV5PmpQWljuPZpqu4u4yHLRijfhrYqVN9vjtjjfNkd8aCptWdsIMPc40zCRH2AOWwTAwVKJ8mLFqWgGwv6f0xcdz2KiyCcVgDZgBBBtG659sQ6HlbSCqxYITjQ==
Received: from BL0PR0102CA0065.prod.exchangelabs.com (2603:10b6:208:25::42) by
 SJ0PR12MB5471.namprd12.prod.outlook.com (2603:10b6:a03:300::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.20; Wed, 21 Feb
 2024 12:02:31 +0000
Received: from BL02EPF0001A108.namprd05.prod.outlook.com
 (2603:10b6:208:25:cafe::32) by BL0PR0102CA0065.outlook.office365.com
 (2603:10b6:208:25::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.40 via Frontend
 Transport; Wed, 21 Feb 2024 12:02:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0001A108.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Wed, 21 Feb 2024 12:02:30 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 21 Feb
 2024 04:02:09 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Wed, 21 Feb
 2024 04:02:08 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Wed, 21 Feb 2024 04:02:08 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <allen.lkml@gmail.com>,
	<linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.1 000/197] 6.1.79-rc1 review
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <0d1c6455-c20a-4ee4-9e28-a0a9220e1f30@rnnvmail205.nvidia.com>
Date: Wed, 21 Feb 2024 04:02:08 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A108:EE_|SJ0PR12MB5471:EE_
X-MS-Office365-Filtering-Correlation-Id: dddac339-7198-462e-d8af-08dc32d4fadd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YQVEFIgTgNcLqzS8hu4EJJROuVpZNdT+BMa1M8szLaYpcgVXUiFpCV7QtrkRACgxse7z58z/tLk/z3DRg9cCoI86G1s+BQdqa6MBomkkbO4ms9NvVeVK5gsZNeFRa/MJz6OfxUH4rjuJ+oCA3rwJft36Zi9MEmvkLomfYLjrM747slIKEt97ADEAqPS3mjMb35p3dcTSop/P8LQ47tlfY/vCmTZS4X+RWLTNjKXVuo4PzoKj2HcGo5i3YgKeig2oLDl/Cuxipc/8wrVOXSW3GRUdd5w6Z8kEacUBlrapz8o9pA4BtoZzMXK1gxqEYf5GwscvPQXqHiz/v0BxP8MBKshPSIzH0as6pwLjevFSBsXm8YVC9ejeTp1xX1FM9B0+I732Y5wkdvH8dPQ+FtnxDYgfRbkkt69L2jB/cvGx8ZwKdrqeZ+AnlUiaUQ5s+9VgviYUzgqhq8vP/engBuBBDyuGIm/2A5a3HBr0wnba5DmY8qofvWDICBegSw2CHyPejclcblSbqUystyN/+1j6okWSjJ8iQiOYmtFPloKPKXFKKH8QAU7pYLcvPAo/6vLK6/lgf73FisNnFcbn1+52HyzqSqFhbhGUnxo+Uf25PK8kXjyaWhFcJW1hrUdup3WMufXD9BxzeGpW57Pt7J0e/25wGIw60MWCcGsUUicvqyAV0XIkCCS0pZVngrn1AC2lfjNvZfkwcz71YkB6rQfAHQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(46966006)(40470700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2024 12:02:30.0410
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dddac339-7198-462e-d8af-08dc32d4fadd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A108.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5471

On Tue, 20 Feb 2024 21:49:19 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.79 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 Feb 2024 20:48:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.79-rc1.gz
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

Linux version:	6.1.79-rc1-gcc64836e147d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

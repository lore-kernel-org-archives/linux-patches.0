Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011001.outbound.protection.outlook.com [52.101.52.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090DD35CBC4
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 14:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772547177; cv=fail; b=WbAL4TNZaxtm5I3E0zW1V/9qxOBy3R1oMRh4oXEQ4Ns1L0wTUX9M1W7lf526MmcofhaWY13eQGETEGNfTJnjUO/gvcOcY5tteoEIqcpsb1GzoUrTfsG7g3rDpvY56y5/D4LlioMl4zm5xtffacAcoOIDgwYW519HRTMAgjvoGZs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772547177; c=relaxed/simple;
	bh=qMvv1UJJf4BUpcAskeiBf/Ca1WtXlRitlFl058V/bcY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Tbpa+DhOqr0miCOwBicPIOtyA23uUMJ+FPRsl5OPIZyAsjmw8xW4JZPLaNEscDquastXpf0AHWmW+86ZgKSzi7sR3SIbQtGbtrBcUyHhAu30ktlo7q2Vuvg3eTlhwusmh8jY8PifcIXsUIit9xNmogYurQvVcaUMOUQR2KZ7+eA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rbrIZMWJ; arc=fail smtp.client-ip=52.101.52.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rbrIZMWJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CuIiZl8nVVpBhHtG55+0Wmgv4qQTS6Co9ne4r4yU5zRsiM5ZRuHcAfNRzQie4ZNgTJG6Um9OOroelXr4v7Yn+4XdO/8434iBGu/cnPKx6EHzgAeITPHHY6O7Y9eZ2NoevNf8OtTDc/uSfc4Ik1fAOk0AOpyqCjzPBadMs7J9hTYJ9Y+mgstpzRA5BZnGWgg2wRybbHrL1i+QrHqyYjLaiSN/AYWLi2VW/X0AVur4nXoljvvi6RNTe+c7K9QBkvJW/ujVku419hveVLFRbEFciETxcG1y8GV2lPvHSCEmeGOqOwrAfGT9iCvxBeNNi8w581QG8Wlmlld4QcqGMCPxdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EfcCPt5jTOKY90cnBPyVNRVgZs+UQL+7songJTxmfgo=;
 b=PHY86ry1vlyNqVbgbKoDU9R+Q6obEbU8e+vBXE7eipcM+tEUSpqajK8gSKXSgR1ybxbXbND+YluE3TuI0O1q/3iPKiGHfFL8Ke3WvYs10JUAU//NFTVfG4J98DxHKiD0qt3cC+e1QLA6xN0u6oCyrohIkdh8wl28hAm1mSIFstDvrC1s97mX51Xit2NUTWTKd9k+oCmPaazRzokIY8iXLhPVqcLbEHcD0uf0LgkvOTwMYuxZRtWUrWGkgE+2r+zKjfY6z+sFAtIksYCqoxStplJDtHnOSw7oyQJxtREhhXyFg3Q0fLUT4A+eMpH5Ihi4sSQcKWCwKhILlLZrMT4WpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EfcCPt5jTOKY90cnBPyVNRVgZs+UQL+7songJTxmfgo=;
 b=rbrIZMWJnNiQIZeSmNUJ9JDtgdQ+VqVfIy1Obx5mi7XA1Y740OCg6gaxO8vfXZNZ3z9jLv4NS0HhYFpNQcFaH5gnBkJvC7/TgwPmBIanw7OZWsPWACMtLJinjQbFZppgBDewLicgwjSnjS7MztfHW0+7RPHsxgi2vozpdcgzNJcJSFUdCAql4bmv+OTRgioRJCVZrCWr8J+Wzv4GfzMhRyMuFrsURzJt7KQgzUDYz6rsa/Ql9BxGtZyCIwZpckL4B/fg/hjSj6KkLbpZMIU0qQcpLZSYekXMK+ZLEqnlGFiPSwQ5PgAlZTCv0y5lDypdJPGeeKjN9eAh7x6GOZh64Q==
Received: from CH5P221CA0019.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1f2::26)
 by IA0PR12MB7649.namprd12.prod.outlook.com (2603:10b6:208:437::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 14:12:45 +0000
Received: from DS2PEPF000061C8.namprd02.prod.outlook.com
 (2603:10b6:610:1f2:cafe::a3) by CH5P221CA0019.outlook.office365.com
 (2603:10b6:610:1f2::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.22 via Frontend Transport; Tue,
 3 Mar 2026 14:12:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DS2PEPF000061C8.mail.protection.outlook.com (10.167.23.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Tue, 3 Mar 2026 14:12:45 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 3 Mar
 2026 06:12:37 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 3 Mar 2026 06:12:37 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 3 Mar 2026 06:12:37 -0800
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
Subject: Re: [PATCH 6.19 000/850] 6.19.6-rc2 review
In-Reply-To: <20260302160834.2518716-1-sashal@kernel.org>
References: <20260302160834.2518716-1-sashal@kernel.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <0a5aa8f2-4649-4367-bcf4-fe0befb4c9be@drhqmail202.nvidia.com>
Date: Tue, 3 Mar 2026 06:12:37 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C8:EE_|IA0PR12MB7649:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ba6e8bf-a981-4945-b0e9-08de792ef128
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|82310400026|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	wzs/LNmeomD3et+z7MUUyNWjY5u7dZdmx0C1AvobY3gBBUwUT9ACT5K7K45mSBqgOYT5a834zwcCcm52JmVN9/1LDzVPHhO2jQXTP4gUIAF2cm0dgdTes0NWOTQ4nHXoo080Fz9kIjGq9L5GVb0BKO11YP/KGC+w3v5i0Rn6QNoJjoBACTqOXUseL79ymkZj5pAehq4RsSvEu9zChtzNGdMhbXfqLnoTFoeH92O6OjQqXTkNiEQzmvdLS/gnW66rzq9oHuk6to/FGMuL3v825H1jemGm+SPoQUvXpgzsexJvYawibY+lnlYsFv7P86yblUFXOisXGrEv1kf4Wh1r2KYzOee6xwnkEP3AQjXWLk8qxwOiSDh02UE43G5w9rbrBPW8W1cQbFYng5ShCmjhlrducFJFGQ6SMzV4aC8i9sIXcjOtqBoxtGfKZrvyCI1xAPPlB+urDX5ms8Eqp99qONv+unvhj+CwOMBSjwsK49mlbC1FuoNpXcPd9LO096LpJOpmBkC+TqT28iM/+KsIcAptvHxP04tEwnn3bRMr4Q1sO7edgA4M49Mfmh6tD+1/FXcfu69F8FbM4+ienBpG3NyG4sHqtruRmFEoQjeud5gbvHXRmuCpJyPu0TmQ+BKDazZ7e6kMz7CC3o5RG93szaftGBtjO0F/JkwtJcvc+/u8zdqMOkzoh2H6+DqZh/YKBDF6Xl5UfnouPAYnChznH7YGXWG3wGA8KwYxidaNbsamEiI+MxFz93BE8jktG9NCOP+NtHb6flDtiETdtyiILQSBCI3T3qFjmgKXIByVPoVXXCjocZs38NNsvTyAiW4+AZBUia1Ec3E7S3ENgg0OQQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(82310400026)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	IklIsLbSsdWgKAk90Us2sz10GPYq/VbdVtcRfd4MLhr5J1SZylacQNsvJDdIIAklQLkbL7/jr8cv1Zs6cNmPVl0kIcOG9kBazE/3PzFkMuIwOv3vd4a22esEH2pgfAB3fEz9H/5TizSsJ44fNr7OALtwvD2QiUUuWi1XcdGGNwf/6rgeRD9mHbX6vqWYBqqbyeLW8uVsHDc51nVFvN4M6CMDPsnBwoJE86lneWEJ4Kobj1d0Dvbja0ASa9IClQXC9SmvezrIzAfqQZJcbJOjJgWLEGnoonTpN5wWROJC1FyDpl0MjOvvaXGaQg63jZl0NW+giSvw+in7InInBihuZKVlTkqBr7MYWDNDsLs8e15gucxWznQBLgzD+tnSxnCciWfsTsGOsj5xHfLP2qOnJ1+zg0YRBpODRwgNu0M/3huxzF8Ri7UapuP0Go5cncLI
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 14:12:45.3391
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ba6e8bf-a981-4945-b0e9-08de792ef128
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7649

On Mon, 02 Mar 2026 11:08:34 -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.19.6 release.
> There are 850 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:07:42 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.19.y&id2=v6.19.5
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

All tests passing for Tegra ...

Test results for stable-v6.19:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.19.6-rc2-g6e57a110e7e0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

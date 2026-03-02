Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013061.outbound.protection.outlook.com [40.107.201.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3423366DB7
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 13:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772457237; cv=fail; b=Uxymb1QIrBFe21FwU4qgYZn2h32Pvun1Af7T8SWXxsjXNGASLKVfsgBbDxxKhmjJbO7sawMNHpeK8tTYj23i1gcIhUDEq0msU45oXWrhgUEHlRbbwpq1rQdEprdC7ny/7ZLdqZpXgSTZ9OUblnzYR9crZaTKuPlqjMJh4eC+ELc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772457237; c=relaxed/simple;
	bh=C7Xkjc+M1Lp4PxHDZ+zzew89ThuW6pKcYrzFC8abA6E=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Fq4D8bCBgoC0vW4HBYtGKR/ei8DNOwXONV72K7qPSMek274wNk+hl5gvM2djDEz9jxBp+DAyS6eHBc1YTAO2r0JEGoXxDYxm6z5awYLE+eWrKcWVCnRBB0nrjj75aiLd1RVJU5Uqes60EYbyDNdS8X5XjQ5+Uy9T2mOzjvqQZKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GAcW6Rob; arc=fail smtp.client-ip=40.107.201.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GAcW6Rob"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J/DPfnYc04VO7CMEfsMxDP66ysQlZjW/w5sKpEqqvtQ9jK5LvghuQ6zDkKX9RiXFW1yWKQ+ezECFdy21wjJc31L8YtcQnFieg6UC6xTm92gF23Lu2l+czzEqJ/JWFKiTrTCVLfx01n0QaSSS/K06Z1+KCKqxP+vUbI5Ep6zTd5PTJjr4nzV4dmoT62FAbLi2RRZvC4RFy0qUWsk+N6By9xmbFvvZXmFLySnz2zkSg6uJQuYPynBW13kYVjOY4fiwbqp+sbRnjG38YR6IUmcMdrJkNRO01F1rnwlonnSnH7xaZFDh1mLvV2KurScS5LSF46xIdKrK8CsK7pvlfyp6ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DaXYEais+x5SoDpMd+NnrQINu8g2y5yjfnR0aYHXFeM=;
 b=yCj5c8rcn4JrKVQrbSqmMoaQZf3YgrK8zehgExUJYBl5tZZI2oBt/eoz4sCmi8AaQX5KfvB821WBSOKYcgu1daLoLpJ6PIqLmdDizq+HrWxKeTkMfDTKkoNpDiiVebDqCRgJI0OV8QJ/1r5eqL0LWcop3JFFVYSb01wGG+TuK92jFlwOBLgvub61hZdMl9gca/aRjT/IdDAWTZ854Ct9wTU2MLbQvicWskYuO1BGqJg2kosDe8flZBDlTxBfhMLB1AvLib9nnyTLYAvrZzSa1WJajbp8iooV0G+sDU1qS72yvy2UlxesdCLgAZBCwHWHKdHPVFC8UE9aMlPFO0HuEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DaXYEais+x5SoDpMd+NnrQINu8g2y5yjfnR0aYHXFeM=;
 b=GAcW6RobXEZavdsabCCaGi42QdSkmLAY+1znN5unVsVFRvdaBEqREuZphhzQJSTgjs7bjXf3FDiOsxYAQslqbHYeps+s2A8CZ43PEuMABoo4F2wSOJBNAb3dmJ9r2loWyQWoJUoYDHx4QYnrEmV5LEDRywEqUlAG7WS7hzq7aEl6vP4WwknTiWsAWR0T9+Blv1l1pnSI5xkDqkiV04Lk+GQfSrps4uMLgiDKz9ACPjsde1J7L2DzXtBQVvbbk4iOiA8wvyIJmwI8uPdVZiziEdA/6EOQOvIgBsgmIteDV88f1EVvH9pXC9FCHOIYp36KAXxm5B6fEEaq8mObn9y+qg==
Received: from CYZPR05CA0028.namprd05.prod.outlook.com (2603:10b6:930:a3::12)
 by SA1PR12MB5615.namprd12.prod.outlook.com (2603:10b6:806:229::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.20; Mon, 2 Mar
 2026 13:13:44 +0000
Received: from CY4PEPF0000EE3F.namprd03.prod.outlook.com
 (2603:10b6:930:a3:cafe::f0) by CYZPR05CA0028.outlook.office365.com
 (2603:10b6:930:a3::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Mon,
 2 Mar 2026 13:13:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EE3F.mail.protection.outlook.com (10.167.242.17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.16 via Frontend Transport; Mon, 2 Mar 2026 13:13:44 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 2 Mar
 2026 05:13:32 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 2 Mar 2026 05:13:31 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 2 Mar 2026 05:13:31 -0800
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
Subject: Re: [PATCH 5.10 000/147] 5.10.252-rc1 review
In-Reply-To: <20260228181731.1605473-1-sashal@kernel.org>
References: <20260228181731.1605473-1-sashal@kernel.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <d76b50a3-0403-41f8-917d-4b88ebb6a6df@drhqmail202.nvidia.com>
Date: Mon, 2 Mar 2026 05:13:31 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3F:EE_|SA1PR12MB5615:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e5c0f33-78d3-4a31-1bb0-08de785d8824
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	efx0GzXLcg+pSTXC5JfwRhzn8mDKhmS1kVHqYQfXB1Q1/3ecYxPnJLFdHoUNMEav17VwdZr16pHWmSTb4/lUpSlMsa8dcp8hZAYXAVTFy19Dg+ZxD8LWJt0NYRlBE31zR6IXT+cQBa/UP/d+QRY1VWnIiFLkz9askpteqxUP1qSNIBQMoObzQ1osMfgzJTZPl8dKahqDEoOrzC2Cp7BdNCLBuUTbrQnuz9vQytbPS4F7AgXtZAIte8oLQTZAKX9MxUumgnc5AJtp3W9JwMuEYg/fak4crgDx43g1+A5eTnv4XVe4/D+8CMxpeW9CofxDhzhIQIbURnbcgttNz21SbPJTWVj2JG4OtulvB1Sru+eQ+a845EEh0xD2pz7psvo2MuSwQc3T/6+WWErO9+7dYj9ksVN+dLWmnxuI03HKuLw9xLvHLR7jmsezlCYhYBBLx+sszQF0ychyZNoUcyvyZiIRJF6XCsznYkRcpgajnVc8ddORJONGXZBPGZuJO7pDj7qiorJh2PpezSP2e73D+9bSl5/yz+GIsiSUzlqVYrTN0fzDNP04R5NRIFUk4U7BdvFBHpuUdnZ9V8MffsNR/j0FnbHbBoOTgvyfTmefNVsT1UIM187kWhdCVAvkbaIS5J9flogKRJs5Jh/qxAeIH7kY4an8dGgPdQAu24+uOD4pgmsltfe2JiOB9E+HfZvzJJBoYPaQiOxNZIy0+KTzG/+o9W/VNN4FTq105Mq4lDteoww0fK3/0JwLfGdKgN8nz68qhNGIikNuV/yx8xET1Hs16O6plzeuFsDJz/xMQUIAeVRhMTyo3tkPwylWV5vNfzyo64roUv1fY4t9re8dHg==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lxHm8r4kt6n/IM8ezmYNlsUhIRnvwxwfFqAMWaNw7TgTjtPz4ao7a/0G1e1WezfnQMQ7X5JAaSRszw19GdeQyHJ8CYSZpFvsRzB1dp+NEkvbisrgKy79ohZ9DZeVw0xnKxvj2utiEukcQ3QNwql8dwuZY+kHIGeF+yReGEPtTLZk5PHueIF2/nUC/bgh0VwDQDOo8r6q2OzhzgzFyGKv1Nb1+EEaIgZ1PucfWwWDf/rj8bJ5AyaxuXojG+74TxONGUmN3/nBtyBYQLkicwp9frQVpgWwQxaNAmNf2E9UNwADZon+FHLy1JjWMV8V9hFi4zh3y1ORFsyksReJab3VLntUA7Q2clcBth2u5kpD1BXP1zXCnJ50LrpdS5bQ+MuI5uclI39y6zjumZJJz432KvgyTStFblm/eGUL++iOia5zPlDc1TYPVnSmhspvfVuR
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 13:13:44.3142
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e5c0f33-78d3-4a31-1bb0-08de785d8824
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5615

On Sat, 28 Feb 2026 13:17:31 -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.10.252 release.
> There are 147 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon Mar  2 06:17:30 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.10.y&id2=v5.10.251
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    80 tests:	80 pass, 0 fail

Linux version:	5.10.252-rc1-g403b311f5d6e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

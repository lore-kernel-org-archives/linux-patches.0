Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8947628CF7B
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 09:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749030068; cv=fail; b=pXe7tQ53imWDAZ41aMfuK8j8/FcrFf2mqUEeYVPSi5PUniXywz5JRuJ4Bks8LgagcASjIexR9mewcaeRal2d/kS3ynWwP6itsCrnMeXcfuFXL08rmnSe9OJdqw2r1jmH+7pC+Bx5ukOgNcL7PQMgT6gBObtFCFyGRTaEdvGjQTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749030068; c=relaxed/simple;
	bh=dphFQuIiKtSxKfNgcdYHoX5xP7ZPeYM1BGUIzvIlWcg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=njcQWpFPSbqCRejgKkECt3mPRLsSWKV76xlXwNl3e7S2UalQ9cYWqnGiIdokxlkwmeSv95GwD7Fia60IIHJvWh0ZBhTX92UNpEEqj/AKx3jQYmUZ0FkbNo+KhRjgGniUkKtFSu8O96yJ1t+3fANwzroSzOvZHghAy4ktFrdF9nE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=neYawByt; arc=fail smtp.client-ip=40.107.93.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="neYawByt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qag6hMkJ/lY4oFexcf+N+FTP+lewuPDsvWc+Dgb5heobcEKdCNu9wLcuOK9zkARdJ60HK5RY3BgXL8sZZmH//OLUnFdUXmdpcLNi1Tr09ZA1sdw8PPhf8iccCQJf9u1bwEdGSZYVy6zVo7fZXF8j4C5VYBz3Syqlp338wHfwinaznUSdW/RrL2SkLt8YDtAUU19hPIw6NPBgbhyztNPLPDjAi9W8Q95mx4amPKJSchESeW+lzWF3khuy30QxOv8zrXe1LmYQiORXOlIjbHTzOMf1APLPzNgc0co1u72yq4idtbXXXd1c59FIk5E15039DD1vicpjUEcPIRy5F9zyoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aNQ7QWfQx/Z8mvhYIYFwwl51XjlvSkb/dYRXJGM9pzU=;
 b=FKzJg/3eCo1D4ah9mNdEUCYoLbtqCrkfeJcc0SwTCRZ6DrHCxl/NwoUMPNFtVir06qL4XRapm0fcog7an46cmt+H9nE67DSXm5XCd6PyCzQAcB0OqNk5XOh6OxVZT5XY/PyY6aoi0WiYUxIkYBLyCM/dkvrShoo5K5J7MLcx0CFZn6tsiJ5fope2zZyi4JId231rg0AnvjdyweoxBAoDYHppGm4X3Fdrrar/GedQUvl0o8hPbG39XoRsmdsFfrgwQ1XH5cCl2x2e0NLz6fvoAXt1D+W+Ko3QqHfpM2xKnzVz7bq8omD+knT0oltU6AnOn7nrt/On796Dd+UrB9oxsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNQ7QWfQx/Z8mvhYIYFwwl51XjlvSkb/dYRXJGM9pzU=;
 b=neYawByttUfB+W096+1zZdQ2V0RpAI8yIHZUacclRDK6tFcepIyWhZMgTu6UJzOUw71FofphCNG1pin1cQ/Qy9sYabowRQ/9fUeroy8tGiqq+4PM3lWptjVourwAcwF4mmyY4Zniyff8Ues3QBIdnO4WBvzUptGRS5DMmAWmPq1QfiktMrX3VQjDKN1jMrN0GTAL2GxBHnvKY4XomroUwlrqW0ErVwO46grgkYIqF/2mA3CDzczYelj4C3pXHu6Gh9IAcLYsGOeArrHszZDUX71KuVTyAVBpv2Cf1G0bB/p00/nyfkUCV6b7D4ZebjJSSLezmyXivfmnfIlrORGm1g==
Received: from BL0PR02CA0012.namprd02.prod.outlook.com (2603:10b6:207:3c::25)
 by SJ2PR12MB8692.namprd12.prod.outlook.com (2603:10b6:a03:543::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 4 Jun
 2025 09:41:02 +0000
Received: from MN1PEPF0000ECDA.namprd02.prod.outlook.com
 (2603:10b6:207:3c:cafe::3b) by BL0PR02CA0012.outlook.office365.com
 (2603:10b6:207:3c::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.24 via Frontend Transport; Wed,
 4 Jun 2025 09:41:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000ECDA.mail.protection.outlook.com (10.167.242.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8792.29 via Frontend Transport; Wed, 4 Jun 2025 09:41:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 4 Jun 2025
 02:40:45 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 4 Jun
 2025 02:40:44 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 4 Jun 2025 02:40:44 -0700
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
Subject: Re: [PATCH 6.14 000/783] 6.14.9-rc1 review
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ac00d222-6ee5-436d-8b24-2155a689f030@rnnvmail205.nvidia.com>
Date: Wed, 4 Jun 2025 02:40:44 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDA:EE_|SJ2PR12MB8692:EE_
X-MS-Office365-Filtering-Correlation-Id: 94033f3b-2534-472d-afd3-08dda34beb5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?THVLNUh3WVl0YVNaVkp0bXhQekFNbzVWRlBaZHl1enVZR3ZkVGpLNjJzUnFI?=
 =?utf-8?B?RURTaU8zY3J2R3FFdWFvQnBSMWJ0Uk53dHVRZ1IwdkR3Z3dVOXQ5SzNQNjVj?=
 =?utf-8?B?UHZRNGRrUzFyeGZHNCtoQyt2alJTRzdoMGxMT1l6bjdmL3RPSzNtNlRzcXIy?=
 =?utf-8?B?ZGFLckthTzlXaGd1bkZMUmVoKy9idXZOa1JKREk3eXJaclpObVhNNGFxVTV3?=
 =?utf-8?B?Umd0QmYwcW1QeEpOR01TSVZJQ0cxUkdtUS9uRFMzSHpiamxKVCt4c1FDMURM?=
 =?utf-8?B?QTYxZDZJRlBGcUo5M1h5WHdCa2ljc1Q5aUs4ZGxHRDBHTVp1SEdXS3pVbXBp?=
 =?utf-8?B?bTBGbWl3U2JTZWNOL3QzZEpiOE1tYjFpQ3hQOGI4TUdCQ3VNYVg5SGdZQTM4?=
 =?utf-8?B?ejI5SWtWUDhaUWtFM0h4SHRkVjlQeUpSaUR5S01ab1EycW1mTTNvTjJLL3ZH?=
 =?utf-8?B?c0hxOTNTcFFzTXlUTEdhelFCUVJaMTVyVi9uVUdZd252TGRZSXJEOU1KR3pN?=
 =?utf-8?B?NU9rd25ZWndrcS9OdVRPYklPallGZEIxNmo0ckFvNmpCZXRacnM0TzI0MHM0?=
 =?utf-8?B?S25memF4OUdCWXpXZWpPc1V2OWYyYi93OG9SSTVVL3VCdVdkZkltbUtwOEw4?=
 =?utf-8?B?T0tiQTNtS3pqd284NXpZQ0U4UjBEYkxUSitzWmZWT1VoaTcyMWRIaUFBVkNV?=
 =?utf-8?B?RFM3OTk0MzZuRER2Q2JRbWY1MkU2bE9CN0x6MGkwV05PQzRUY3FHYVpNemEw?=
 =?utf-8?B?cit4UGxDcDJlWmFUNndjMzAzelhNbXFOYWtFUlRZajBwQ3EwRmdaZ1ZQZzQ3?=
 =?utf-8?B?SEpLMTR4VTVGSjFQYktTRmVNTkZONzNKb0poOXZYeWRPTWxpc3lSMzdhQXdQ?=
 =?utf-8?B?T05mRXBoWDFCdEpjc0xYR2F4MXBZS3l5a0Ntd0NhdlBVcG9ldFpGekFia1la?=
 =?utf-8?B?VlVVVU55M1k2dzZwZUJlcjNTaTBwSUx3b0d5Q0xLdjFJeVlMUEpVbDcvZk1r?=
 =?utf-8?B?VG1uYmlqeGgxMjh6TFBRaHBvbUFjOEZjc1Q4RWNDV2RPdCtaQXhOMS9KVkJ0?=
 =?utf-8?B?TWt1S2RhQnR1SnFmR0N6WlA4M3d1bVAxNnNDUWJKS0I0UC9IdnBIOWx3WXFV?=
 =?utf-8?B?UmxTWEdFeXZvOGc2WE5KdFJ2NWJZUjRqc1ZLMDI5RWJHTG0xeHQ4NUxmdHU0?=
 =?utf-8?B?R2FiVFp1NDdIRmVlQS9Ub01jcG9JQ01mQkNEb1FteTd1OHRaOHErTFYrNEtX?=
 =?utf-8?B?cGtvYUZRRVZxQUFUNXpSa3BEMmg3OStBazFrNWZBVTBZRlRIVDFpeE1mMk5y?=
 =?utf-8?B?em1RU0JSVzMxTUh1bms1NlBHeW5peHhBREdudUZRS2VoVmk1MkJYdnFyZDd0?=
 =?utf-8?B?bmlIai92aC9EUG8yVlNJaWlVcm5wVVZJcmpMZWcxSnhMWFk5MnNyS1pMMzA4?=
 =?utf-8?B?SUZzVFNJb3FUS0lSNUZrY0kyN1piRkdLQmNlNVh3aGwvcVZWZHhPNjBLK2ND?=
 =?utf-8?B?VXdISnpXK1JKN3ZEbG5od3hrQ281Tmx0eG44b0ZRMzVjQ3h4U1FiQmxEZ0ls?=
 =?utf-8?B?eDhsYW1wN1pSeXcxZm1SR3JVemIvdXlFZjYyUVJyQUl2RTBKNFZQUDZYM2xw?=
 =?utf-8?B?MlNsMXlrKzBSUHNSVGRQS2VoNnFmeUJNbksxeU4zZFhmc3kzdWhQMXRqMUJr?=
 =?utf-8?B?WkVwRHB1bkFUMzRMQnl6RlBBZ0ZSTlN0MStPc2t0M3h0cGg3N0Ruc1B3Q01z?=
 =?utf-8?B?QUY0MUJKbUxwNVJCNkVsZlZ1dE13Sy9vNGNnbUhWWGpDdFpyeXcyNWZQR1V6?=
 =?utf-8?B?d2ZCL3N2SzVHczNxZUU2UWZBcDFXbTM4L2xXNlUyWmZrTHdwWnNYZ3F2Qm9r?=
 =?utf-8?B?Tm9Xck5KanA5SlZ3bTRJYTJYeWs5WU9FNVhIQmx3TkJOdjVpUUd2eXdQYmFk?=
 =?utf-8?B?dkpYb1RXYjEyZnRRbFdXSG5iOG83cm9wZnNEVnAzK281d2VsMmVpbXovZTRo?=
 =?utf-8?B?eFZmTzFSdCtKZmw1ZlYydUhyY1VDMHZJUnJBSks2cnd2WWR5d1N5RHZDRnJG?=
 =?utf-8?B?eStqcEdJYU14WjI1RTEzZ2VuNVE4VER4NzFiUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 09:41:02.1042
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94033f3b-2534-472d-afd3-08dda34beb5a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDA.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8692

On Tue, 27 May 2025 18:16:37 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.9 release.
> There are 783 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 May 2025 16:22:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.14.9-rc1-g10804dbee7fa
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

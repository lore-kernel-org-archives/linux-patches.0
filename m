Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010021.outbound.protection.outlook.com [52.101.56.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5420F336EC1
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 20:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767816825; cv=fail; b=g2R1vTWTTBQ05QI2LuGZ/BwAAz0Sy1hHeXUJazRkQiYk2ZRm/pDyyfY8bibnVZpCYrigYZLaQOETvCvGj6IlfpWOewKieZH5/+YKZ31dUCt+icIsXhd3u0QVd2cUTFnDY6atOMpthJg2ZFz2DzpqEsgf488HWyM5raLDebs5sZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767816825; c=relaxed/simple;
	bh=Z7fvMDmOhSeGvJCNc3HL39wrm20xsMBqNiAINFXgfL8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Ax/tUsNSRU7PEKyh9XeXuXhted4Tp/r5ooV3ia9SdEoP39fePsJy3ToejKf2Fj4dT9+pBOgTWiCeccPnK2gn7MjImlpUp4H5LN8LmcGrtWgaDXp9r+6ZYYO6BFPhGjxQzbCUI0HCaU+BbID003qg2SKYRqSeS5hYzKhAZAy43nk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RxlUrPnS; arc=fail smtp.client-ip=52.101.56.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RxlUrPnS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MEucZbs91DPljGhj89mpHGeR6uHFJLokVWaIK6jN5rZVDX5HEkHXXbVEYloqyI2KqsBmJ6nrTU9eLsAjHtmaxGPS9ojRnmtNkigMQCf8x3AdWBO/3NwNK6pGqiUg8MnXmED3rpbhuwvTbX4RAAkgEHsUcB4iW+Of0U4coIYFALTbucRue5kL+r5qsjcus1IRYP3bYvapKEhLGxPstBPk6HbEsUHgaqeXTCrqgyixvssCd6hJ6kVpJIRYj+Oeu4POCAYG/IIjU7clnaWSj+WWE4okAgvQQWfAHm39F1EcHK/VGyYGO+grOka3RMTrv1d1h3ccCvWRA/7VE397g1a5MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQkontHZ0i2NPxy49duE2rl+pZKOPz075uKXaYwDrkw=;
 b=c56DjDGcy/HTGG0R7SQwcLosuSiAVZ1AX9Its9ReLSCdWzqH9El8kaJoWm+0kVoXgsdawe1dBUPI7iweRqYdtnkSpnGqJwsALmD8urHW8aYg6kAWOXYBfcIaibmJp7OscbDZJn/EeTrxmbBfzTZ4iWijYgLDgMt9hGBaBq2S99nSpRuFC6TKHNZfivDAb7aZ2MO72BSSq1vlX/5OF/9GSYHCrQnLrXp+2OLnft5E8V9khlzXPfvSBQQsOh83A7VXD82BhfJEQdfevf73apaUz3CJfYjrymPIBvgyMVnhedvpmFMgAiPjIqM8lHxq+9FR2nB8K3YRr41FWMab7CYb1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQkontHZ0i2NPxy49duE2rl+pZKOPz075uKXaYwDrkw=;
 b=RxlUrPnSxSUv+jMmkxg+d8tbESwtZYU0fwTv+2lqZTCWJGWtUBZmrSoxhevxuSyYwxa080cFSzg4LIx+AcxrkZDE+AXBD4K7oTEWft0RU70jITyckMxwJHQRDyV+NJgw2mef18LBjyXVyOkTjdzdgGuXzccx694FJ2WpUyvsEGYWTRoYW30oO4E0Xq08/z47h2FYus0kseSvnllroDHflSjZforJQOXvajsLNJhExbDVEdeDlRkWDXfR6JOu0Tywzu8xuJ0buZbeaHcLrNwzR4ekX/qZb3kocFlls89KgPzduaSmibAjGWHKzfUaZm9CMpuhtgj4nh1gRgCwL70IOA==
Received: from BLAPR05CA0005.namprd05.prod.outlook.com (2603:10b6:208:36e::14)
 by LV8PR12MB9112.namprd12.prod.outlook.com (2603:10b6:408:184::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 7 Jan
 2026 20:13:32 +0000
Received: from BL02EPF0001A0F9.namprd03.prod.outlook.com
 (2603:10b6:208:36e:cafe::3d) by BLAPR05CA0005.outlook.office365.com
 (2603:10b6:208:36e::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.0 via Frontend Transport; Wed, 7
 Jan 2026 20:13:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A0F9.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1 via Frontend Transport; Wed, 7 Jan 2026 20:13:32 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 7 Jan
 2026 12:13:14 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 7 Jan
 2026 12:13:14 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 7 Jan 2026 12:13:13 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.18 000/312] 6.18.4-rc1 review
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3337cdea-63f0-44e4-82f4-0c76a208ca82@rnnvmail203.nvidia.com>
Date: Wed, 7 Jan 2026 12:13:13 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0F9:EE_|LV8PR12MB9112:EE_
X-MS-Office365-Filtering-Correlation-Id: 85263db0-2a61-4586-2e43-08de4e293afa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|7416014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NVRHaThMcFZ1T0VUaVliUG5oTWVlaHpTNng1ZWZXdnMydWl4Rm1Id0MzMmNk?=
 =?utf-8?B?MkxiWmNBSGFxVy9OWFlNbHZ6WEsycmZxU2wrOEdyeEVsREtPazlsV2FoNnhE?=
 =?utf-8?B?bkcxSnJiRXNTdlYyWFF1Mmp4YmpheUZROHVtdXhEMUFtQ21ZM0ZhZDQ5Nnhi?=
 =?utf-8?B?SndyWXZaNWlMQzF0bjRhdWV1eFJ3Y0ZxZGdzQllkdFJkTmx2YkhaRGJwdDJV?=
 =?utf-8?B?OEV4VWRNemhZQ1U5N0FPWFlwYTVKRFRoSlpqektmNytKQy9NV3B2eVc0WTFX?=
 =?utf-8?B?cmwvYTBpUTJrZmpuK1d4OURzZHNoZkd2aHh5UnFTcElFd1VoNXhqNlVpRitp?=
 =?utf-8?B?d3RPSU9FeW50cVVIa0txZlNhYTQwa0QrYTlhSkpIcGdweEtnT2tPNXdnSFVp?=
 =?utf-8?B?Z2dzY2FtSUtPRkFCL2RQeTNKVUcwdHduQ2R6UzBmSXgwQTJhSUtja1ZVNmtl?=
 =?utf-8?B?WWl4OHpWSllBckdleHdMeWlLWUR3RzAzQlFDcTNBUjVtc3h6cHkvWGU5ZVQ4?=
 =?utf-8?B?QzVjVXdHeDBnSnhUajZXT1JWUk9NeFNNSjdFWUhrNld0M1pKYmh5ZDdIZlVv?=
 =?utf-8?B?anBhbElGdmdNOEdzaDVPMXhCOXZKWXVaNjVGZlhZWTExZjN5NHA5dlE2TTBz?=
 =?utf-8?B?T2s5cXZ5TktiMEV3QVJEYzJXWnJGelZ2NTVFMEFZYXpTTDRnYkxWZ05JdW1E?=
 =?utf-8?B?ejdESDBJYUlHNU8wT2FVNVVPcmpGOEh4ejBPL0VxcW9ZUXZUYWZ2TVBMWWgv?=
 =?utf-8?B?WGllOWh2bjZFMnd1ZU55bHpmUTFWZnRwM3hodE1UbFR1WTdLdDNWeTREcWFC?=
 =?utf-8?B?aGkzRXVtNGdVS0hOQXpNdW9jRjErQzVkamhYcytnU3dqZmN1NXlyUmF6eXhO?=
 =?utf-8?B?YU0rU2ZtS3R2aE9xc3VtVFlqdzJKeGlxYUZlVzVmUWVTNmhmUG9HZ2VoOEdI?=
 =?utf-8?B?RXpaOWltUUt1K2dhbStLWjB2OEtXNnJTZ0l5Vy9Vcm1tY0hKS1VPL3hxSHR2?=
 =?utf-8?B?UldyNHhydnFiN05pR0dNcUx5YUNjTzZkN0ZMdXMydmRwT0VFQVpGS3B1enhK?=
 =?utf-8?B?Q09DMVFEdmhMRkhGQWl4aThrUTdZUWoxVFF0MmlHSnZnMVhMRzNLTHVIWm5W?=
 =?utf-8?B?OFlMWitBQkUrcnVLdSt0cGVqVFNjTW9yMkU1Vmw4dEZYYlpSQmlyNDlzOWto?=
 =?utf-8?B?bUdyTS9FdWpNRTNRbEtBQTdRM2tKUTBZa3liQ1JhcXZodFYveDFRN04xdVEw?=
 =?utf-8?B?L3ZwMlZNbzFqcnFYVStmWlg5RDFST2hkK0V3ZndUT2xIT1BaNklhcmxlZm93?=
 =?utf-8?B?YURzMXhMZDVYQ2lCMTIwY0EzcEZVakxKY3RwYlIvb2FpWm85M2kzV3hXME5P?=
 =?utf-8?B?WEZ0alo1T21SbWx1enhpRmNIWTIzRlBBc3JXakt5UW9aR3Y3Tkxvc0hSRGp2?=
 =?utf-8?B?aC90S2FQNEwwdEgzWG9HRlVSNWI5R0MyU1BzK1d1bHpvZDZ4VHgvcmZENnI0?=
 =?utf-8?B?MHJvSTNGU3pXWlgwdXN1VFVDS3cxc1RGbW4vVTVvQ1RhUjdQZWQ2aWQ5MFJY?=
 =?utf-8?B?c2d1NVg2NFVkRkE1SEtUMDY2aW9Hc0ZaeU90TzRTTTBmL3grck1qekppczFV?=
 =?utf-8?B?MmhkbVNCdVFlSjFMTmFuTWpxQzYwZzJPMDJZY01iVWFrMG1xeVhPSkQ5dWNn?=
 =?utf-8?B?cFZvOGROWFNaa3l4ZnlTanpzTk9OWnpKaTBjNkJNOSthWXJ5KzV1RkJGNnh2?=
 =?utf-8?B?M0pPZnhIQ1hCNjdwaHRiMlNUQWdEK3h2V05acThNL29RaUplUlFhZWpTTWZz?=
 =?utf-8?B?cTNVOWg0bTEvempXSytNZEg4dlIyeGdBMjdVcXY3elgyWEF3WXBqTDZRbm5h?=
 =?utf-8?B?bUVIZWNZYWtrKzRMR3FLS3gxZnVyME55NkJTYThLRWZncmxKRThLUGpOdUxR?=
 =?utf-8?B?b2M2bktkMTQySmI2d21UeU82M09qelJUOFNlQnlOQ3VDRks3OWljRkR4OU1B?=
 =?utf-8?B?OURzQjNBbThpa3N3dDk5VUd0WG11QkFRME45NGcvS205V0M5eWpMRW9xOHBC?=
 =?utf-8?B?WUkzMVZJd2JRcmt4WmUzQnljWkdxYU9iU0d3WHZ5cnUybmNSbWQzbTRuYXd3?=
 =?utf-8?Q?yDJQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(7416014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 20:13:32.1456
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85263db0-2a61-4586-2e43-08de4e293afa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0F9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9112

On Tue, 06 Jan 2026 18:01:14 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.4 release.
> There are 312 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Jan 2026 17:04:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.18.4-rc1-gdc7c4cd6ae5e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

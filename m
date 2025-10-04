Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010027.outbound.protection.outlook.com [52.101.193.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F581E51E1
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 13:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759583192; cv=fail; b=n6ml5pgUOsXfg48sfZFMGKlMT5LV+ido+on/R3eX1Eb1+MHNt/nWVmftA23Qa8waJI/pCAiLS2TT1jUVhnMj9FocO9wIkaLav3LbV/ZDYIKzS0ub/z91+RXMm5dYTg59E7Fgn4GlzWkMOAmu4m7Z+M/cwudmoEBgsdRjHFHq1vQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759583192; c=relaxed/simple;
	bh=riE+6ob29BL8uUyqaP0n6xMfi51a1X1t1MHroukiaaQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=oYAr4Mi1p/w5GsecEDmzr7+69bcJJLrH5+WzT/FN5TFqB2UxtyostnnsU4l1oTYWUmFMLB97KRr9zwLJfgDydyQCjEnBvbg405QJEtNksX27aQUImWfoeeO5UaLILWJpjN7FFZJHbWjlgWqb4IvjyXhhcGe7avgDl4I+0793ypY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FF6egcB5; arc=fail smtp.client-ip=52.101.193.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FF6egcB5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rOVtK5iGWw8KKxUrGGexq9UOtmdz0HeQKTfu3fRt1tNOj3ATKX9OYBI0ySgIZJGr1wUMG9koSIbmFMG/GTGSTeSLB3hL3F5OpcOAw5jhqujVvEC6JGmOZGDX9s6qSMTD38M2mXL1KUwNQGoOvZpNCbVHRFVDhne90en/1eOw80cz8OtR6HsW8CqNyJMHx7L7+l4Ehcem0cmu37EKcgN4dlBZ5CTcnw4po4mCwUNK9/UCQQPE5Hl+0tUMppIH0cruKIPZTndjVh0Xg2F5awCWXIuXofraHh0l6ktMSgJrpUvUxEvar8G4c7Bx3FVhWkWV+i6FnKTziO9JWS7LI00RNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y2Eys5r0D4vVLNvYGc5ZWGkBrqRi5ItKDBF177USAqY=;
 b=Q8SMofF58fgOg/v20zrw3KGFvc1WD7U5BCcrKvsu2fy9ZaCN7xG5fwRmFSeKsNDTW0dIQG5YeRjDrCByZcGc4ikyOr4VEA0L0xVvdU+oPlbcqd50S7Nt6eB1eyDNcELLyl3Gnl9DG62X6Ay+fM/t2D6Ur+yBSHIOhcYHpoSev7r5GqHtFwxPVoG2kh238uxv4fQxU3Ak8W1PhGzHiWInJWNipRivkjSKG/CvY7im34peBKY5b97//LRRH3+Z4l6BG0PuLVIn0JdbKyVl+VKFZ6mbkK1p9zHadpynG58FNwCy9Ko1S/Jki+e0EpNyIdmPvj1J5dpytPhCYJQMosR6JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2Eys5r0D4vVLNvYGc5ZWGkBrqRi5ItKDBF177USAqY=;
 b=FF6egcB52apm0aMlGgwSR1SyNCqX2mGdziG75kFrcBC8HOFJ6H7utiV16h8hkdztPhU3lDzry+qwViBYEflMhAb72YKVekRkuqxClzld1tx93p04C4GUJ7x9kXBTrSBKrl9PYzYQDr2nOZEyD8K2W1GsahZkVrAMXff1POxjycay4OUwwu/g2Mw/r4FwMnC+NdMqa+0mG/YO4A6gc9rC6Qr8PpMobw2fl4FksrKuvBl9iJA6qC7MWA0aqJvxSx5yWgLKsWQQj/pxgQG5917ExkRzISiyRoiWdjDl3R2zz7i17zqoQfI7gtlzOFNfaNqVmp3RdRFEqlL8cgLK28pFow==
Received: from MN2PR01CA0054.prod.exchangelabs.com (2603:10b6:208:23f::23) by
 BY5PR12MB4241.namprd12.prod.outlook.com (2603:10b6:a03:20c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.17; Sat, 4 Oct 2025 13:06:23 +0000
Received: from BL6PEPF0001AB53.namprd02.prod.outlook.com
 (2603:10b6:208:23f:cafe::80) by MN2PR01CA0054.outlook.office365.com
 (2603:10b6:208:23f::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.16 via Frontend Transport; Sat,
 4 Oct 2025 13:06:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB53.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.15 via Frontend Transport; Sat, 4 Oct 2025 13:06:22 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sat, 4 Oct
 2025 06:06:10 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sat, 4 Oct
 2025 06:06:09 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Sat, 4 Oct 2025 06:06:08 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.16 00/14] 6.16.11-rc1 review
In-Reply-To: <20251003160352.713189598@linuxfoundation.org>
References: <20251003160352.713189598@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <9699b5a3-83a3-414a-aa5d-abadd7dbcd24@rnnvmail202.nvidia.com>
Date: Sat, 4 Oct 2025 06:06:08 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB53:EE_|BY5PR12MB4241:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e69c0d7-7fa4-4ed1-566a-08de0346d164
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MFdKZXhERUtzWE4wa042emI0dUpLTWhidFZYVExyeUFpNUVVRmJ6ZXdjOCtK?=
 =?utf-8?B?a2lIaGx3ai8zZUxZTEo5ZmZWS1FYd0xEQWhHRGhxZ3VhSjIzRHc2NmpKL1E2?=
 =?utf-8?B?RHNxWVcyV1p5UTNyZC9yT0ZqTnlwWGpFeEFwQkpKamd3NHJKbjZkaDNHRklD?=
 =?utf-8?B?eTZDVzJQNWY4YjQxUzhiT01OaDJ2K1NRQzNXUlk2eWRobjgzRVZwNk1zTzNK?=
 =?utf-8?B?VUlGaStyUC8ydTZOTG1TSjM4bkxXZlVFc1M1Z2trQWxxQ09MeUxvTmZ6OUEz?=
 =?utf-8?B?U1FseTFFUTZmaWk0VzAzMDdwTjFrMXJIcmNUYWJJbU0vc2YrNWFwSTlaVkxX?=
 =?utf-8?B?c2lucVorZXM5T3RaVnlocHRXUFFjc29TOFRiQUFlaFpMMVBXUWtVR25seE5U?=
 =?utf-8?B?aFQvYlJQaS9Fdi8zQmk3dzgySTFDWFY2RzRTalFKTjIvSjA5R2IwdGdkdVBO?=
 =?utf-8?B?R3ZDaStLR2lXUHdKaTh2ZXduZytKSmpwVkUwZ20vZU0vZGdrNVA2cHhBNzlK?=
 =?utf-8?B?dHA4cnQ4VG5uYU5RK1docDAxSW5qV1A4VDV3TjhSU2hMU0MwRngvV21pejVw?=
 =?utf-8?B?R3ExRTNyQ1phWExURGZyQ2l0YlBsNWRUU243Um5WMUhZWUJ3QktnblFVWlkz?=
 =?utf-8?B?QTc3MFp2MXE1VGs5bUV3cEh6bUtuOEFkZmJUeVFERjVIdUpwTnFHU1lvSXRx?=
 =?utf-8?B?SjdQYS9xVExUcWMvWWc2RUZMajdDd08wZ0sxOWxhMXM0OEQ5MjAwMGJ6T3lO?=
 =?utf-8?B?YklYRzBLdkZTMU9TZkJCK25oWFFnc2lMbE82NzN3RURiK0xVc1BSUWx0a1Nu?=
 =?utf-8?B?WXk4bkYxdHVSSWRJa2RMZVRtZDhGSGc3WW14T1Z6Q0R4WWlXTXhlWkVCNTg4?=
 =?utf-8?B?TlBHK3NIUmdZVngreG9sKzVzRW1WcTJWeFV0OTM1LzgzVHF0eGxpaHFBZ1V3?=
 =?utf-8?B?c0NoSEhMZWVFV3RFTGh5U0JTWlArUXI2ZFc1VXZ6bGc2a3JEbDljZzVxWWpi?=
 =?utf-8?B?T3FZb1ZIR2IzQzI0S3pTa1ZULzJNbThGT2ZuYUgwQkJTdmRoUmJubEd4aDlU?=
 =?utf-8?B?Y1lQWkVtZWl4OXJqN1BPSzlURnNpSU1Ea3d3OVZHTTMzZEV5R0d0SnJXUm5j?=
 =?utf-8?B?cTNocFpuRXFxOWV0d3FoNk16NEVyMUNpeFZSeVJ5VGQ0QUFRRitvdVhLUUNI?=
 =?utf-8?B?NDcwelYrbTIwb1FRZjlVY01NYUJxdU9EQld5NkowM1JPSnZqOFprTFlBTWpq?=
 =?utf-8?B?NlNLQklyamltUC9oKzlKeGxYbGp6ditkQTFOOVM4QzB5UVFSdWM2ZlRkZm03?=
 =?utf-8?B?MHZuQXJiSmJseGloQnhnSmFBQlRNVjlOZDRpNU0zaEo3b0YydkNWYWZKaWdJ?=
 =?utf-8?B?MmkrakkrWERvYSt5WGc0OFdYTHNCTEpjc1Rmb0I4VXoxMDBFNFNhYUlSaW5i?=
 =?utf-8?B?ZDlKNWF3VklKT2hqYk9hTHowU0x0eGdmaldjNnd6UzRMaGRaYUh2QzU3NHE3?=
 =?utf-8?B?OHVEUzBmV3FpUXVCRUkxdEl1K0VPWmVZZ1QyZENmU1VYMlFOK21UVHRIUy9q?=
 =?utf-8?B?SmlVcThlcTRCNHRSUzFJeHhEZVpwT1ZaMlcrT0pYeWlNSFdtbXJ4ZzNkVHJT?=
 =?utf-8?B?WXAyUHJnSThwcmNJVUNlWVB3Rjh3ZFhTS2h5L1lFWElLV2FJak9RRlBCV2xl?=
 =?utf-8?B?RjhqV1dGRm1xdTNseE56QnNoOXhINHlvMnJaeEk3bXZDU2tteWVOVVZGdjRo?=
 =?utf-8?B?d0k1WnFlVXFVNS8vQ0FiUkRxd1FEM3RXRDdBeERnVFFOQkhFNkdvK2tzbHR3?=
 =?utf-8?B?cHRZQ3IzNGMzNUs3Zi9yREdBMkVDdWFVeTdxWlZKMy9HNkdZek5nalljT29E?=
 =?utf-8?B?QURaL2JrZmRXVy9MV1lyTll5aE1sbEl0aGt5SmhFSlFzZnFxSTR1S1BwbHBu?=
 =?utf-8?B?MHA4eHc2Z2xUdTZMUTFyRk5iaXFkOHVvUVFSbzRacXpWYmQzUTdEcms0SjJJ?=
 =?utf-8?B?dDg4bWlONkljZWNiTWVrcE11Yk9WRzZ3QWxxYU9LZ2R4RllxNHUwdHRlVmcx?=
 =?utf-8?B?UDlXeFllNjBKZ2lqalBJUGhtVGs5cURSRGFwYW84b0p3SDh5NlJBQ0lFemNv?=
 =?utf-8?Q?+jzA=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2025 13:06:22.6795
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e69c0d7-7fa4-4ed1-566a-08de0346d164
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB53.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4241

On Fri, 03 Oct 2025 18:05:34 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.11 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.16.11-rc1-g13cc90c947b1
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

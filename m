Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012054.outbound.protection.outlook.com [52.101.48.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5E422D7A5
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 11:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761650934; cv=fail; b=T+DYqggTfGNV15JQwilAw5a8hrsXlIJcrypR1lXSMXe7B5iLndYvihvjDvyy8VDIrGCe+1bIOe+xgOxi8x93Cz4XAaWB1HrFASE3PAyLV3vzD6MRAbkPs46pxkGIk0jMifGPvOhDHpZjd5IokQye2+PTPP1swkHn+L9M51SEp0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761650934; c=relaxed/simple;
	bh=zuM+XvbfNgBJKImzruVG0B1eUVKqWIb6B+HluC2R7uw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=YvDLiOP4HI41LOM2Dti1BsEluzjcVo383aLuxrohCAvNhp2L0MmMEbNORA3NX3jmszUAC6NNHwuKB0F4+zcfa9ykahMi2I2z+TUa01vsW6IjWmIXESr0Fp1yYkIsLwQoETQa3P8d/H4UhpADnlPoFNo8bfcbUFloWxVcoC5iEfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QJNbxjjC; arc=fail smtp.client-ip=52.101.48.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QJNbxjjC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ypfykaX4XsIR04AebE4RXXtyvFlkScCkJ5/YhcBVHxOm1HO9OW8/cc2yt5Z1Xjq22iBtYxNIEyi1zWt6eyi4yHr6VgwhBjvA9s1JYtqHa/mZVWkhEtcE8ueYo1cVdrTXRI1I7wTaMnJzXgFJVixj0fK+Mv3EWqy0kjwRaXHNQz5CDT9wh0A5RAh7Jcm7L+I3ee8Pv6eYdkJohVS5jrQFoMtRRiN6D+VvoAjsYK0d2uwa1OASbJ6Kj1KbES8Ss/IQQSCtJphc+KG2FdO5+jENloYgMwpvKfK3BqU8PKgdKOAmhfCZTBlVyL76oJ6f/yvDVothEfoMkCL7prNXnTzpaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zY5Z2NthXl3woqT6SJ6/sqsizO6EzucLjmfMde2bkVU=;
 b=tapl3uXTnxvjIUIuj0vixKyhdN4IUVBwXuYClp107yLg0heD3GHkW42dQHSjFlrpAiaqR+86C9wQ2AJ3sYAE7wgzd6y8rXOaKCQTxN2UCDt+Mq7tt4msxgKERSfFGRyK/p31Somn5S6TNIJ9OP+QGbyQb9SWXRsN64XAUI4zdPAQq9hFLifQjqDFtXTCfjPWY5f/uvzsCrIHzrd+RU89FoMQqG+34vZrisDekZb0CanRtJNk3h/faj9tjMo+wbBIwJSpWtGT3kWDDZ3x+PK6gX496R7mW4L9pD0aUcMLGyFi6SSdD0Oo7QteLe7BZMOC644OgMhJK08TLp0lSwGnOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zY5Z2NthXl3woqT6SJ6/sqsizO6EzucLjmfMde2bkVU=;
 b=QJNbxjjCM1KNKJDesSi1XvZp+X7KFQ9C/S9n++ZyJfjqovTtYH2b4oXYn99D+eW+JBTH82NapBP+cSIE1xRpm5GbnP6QHbV3CWzkKz/JTNZHetYFM4K3AHoiGgF0zhjlUqCH+46qzsoxkAU3l9XH6OkuZIX6f8eAJQ1YVcDsR0+sd94A0jXm9zGyf4OjQV/xPNEK0iYRkzKebfS2qVjDCG9ExOZjbS3zp7ybaa9VLFqVAMBHPnjLb+TKbR1FWPVKEU0/+mmdhFBhYIXva8IBuhmhDSA5z+5aWXmkSfmoOVqjxWfVFKV0gYggMiWaOX8GyrqMGa2pCDeSPy//5CQ6Rw==
Received: from BYAPR07CA0067.namprd07.prod.outlook.com (2603:10b6:a03:60::44)
 by MN0PR12MB6004.namprd12.prod.outlook.com (2603:10b6:208:380::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Tue, 28 Oct
 2025 11:28:47 +0000
Received: from SJ5PEPF000001C9.namprd05.prod.outlook.com
 (2603:10b6:a03:60:cafe::10) by BYAPR07CA0067.outlook.office365.com
 (2603:10b6:a03:60::44) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.19 via Frontend Transport; Tue,
 28 Oct 2025 11:28:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001C9.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Tue, 28 Oct 2025 11:28:45 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 28 Oct
 2025 04:28:29 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 28 Oct
 2025 04:28:29 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 28 Oct 2025 04:28:28 -0700
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
Subject: Re: [PATCH 5.4 000/224] 5.4.301-rc1 review
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ec4ea3f4-b160-496b-8d43-10c4cdde133f@rnnvmail201.nvidia.com>
Date: Tue, 28 Oct 2025 04:28:28 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C9:EE_|MN0PR12MB6004:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a001f3d-cc86-4544-d2a9-08de16152815
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZkVNUE5XYytub2I0cjZua0J6YkNjMjNHRlhXcVhJTWFxUnV2LzNaTHRrdzBi?=
 =?utf-8?B?aG9PcFV0NXlHbU9nNXZKMkxoQWpsaGZMUHYvclNBVVE4NU5TSmJ4TG5HTEYx?=
 =?utf-8?B?L3ZYeTMrTEJuUHFnaU04ZGRKY0xtbEtIa3lhQ0ZGQ0JSSXBQbHhIMVJyTmdx?=
 =?utf-8?B?Njd5RGxhUjFQNStYQVErMThLMXdTaVd1Vi9xYnk0c2gwb2VCM3U1aXlibkEz?=
 =?utf-8?B?dmFUZFRkeUxOVzJpRUtJMDVLL0kzRHI0R1V0TG44NjExNTVieTVHWjA1dnIr?=
 =?utf-8?B?YlhyQysrb3dKT3REUXFjTmd2RFFBVXB6MFA1bC9FaDQxOHlOZVRYNXZ3Tm83?=
 =?utf-8?B?Y0orbW1ndERJT2lLM1FVNXBGcDBNTmZ6eDJhN2FvdlZidTNEWlBaeitwdnlG?=
 =?utf-8?B?bXUva2p0TUFKYW5HNWluUjhuUWJhdFRLQ1pnZmtNbmUwNytNS2UyS2p5amxM?=
 =?utf-8?B?YkVNSEtreG1oTE94S3ZRdnNiWEdhVlQ1NWZqckQ5MXhmQk95SW5DdkwxWTh0?=
 =?utf-8?B?a2VETi9RYVdEOHNnVk1mOWZyUk5QYjA1ckcwM1ZzS2NiYWhrYThtYzZySDJs?=
 =?utf-8?B?VktQT2YrWnkycVhLZkpyOWYxenpzTktIdDJ4cFNoQXFtL0ZBNlh4aUh2T05p?=
 =?utf-8?B?aVhzMTgvRE1VQUlXc0ZxNjlzeVFnRUVFRDlyMDJBV3hJcnlkMmM0SzY0VnRk?=
 =?utf-8?B?blJwbi9aN1Vsb1RDM3NUQk0rWmRTU0Z6MmVMMUVlOERHUVNNUFJoNURrTHBs?=
 =?utf-8?B?Ym1DS0E4bXQvd01VeDF0SE1VTk42V09nYkEyU2lVOGJ6ZGdzR05jenFTWFRC?=
 =?utf-8?B?eDU5YlovVHplSXFhSGIyWk1id0JOR0ZoTkw5aEM4NTNTck40OEc2NG9tUHFo?=
 =?utf-8?B?b2pkdjQrdUQzQlV4WDdCVWFaSHlaK0hoRmVyRDBNQ2NXZzh1NW5OdHJCai93?=
 =?utf-8?B?bkhNNzNpMjdjbFltTGRZY0c2QzRNVXlUVEZOakVQSHN0QVpPNzZUMTRob25a?=
 =?utf-8?B?bVFueTNBbVZTY2liTkg1eGN2VUhEcEd2a1kzazM3RGJhOGdVUFpHMjJpemNl?=
 =?utf-8?B?MEZuODFLajRYa2J3RGk2NVN6MDVJVk1NWWtoODlxNTcxWTB6WE9lTU5uS29N?=
 =?utf-8?B?dFhqeWQ1M3ZNaWx3QUFEVFlNWm0zZ013WjJac2VreE1lMGNReXNscjZNQW91?=
 =?utf-8?B?U1FwNjZaVythM3JSU1FQWld0K1ZXclFqSDRXQTBRRkVwc2tiWGxwcXVmV284?=
 =?utf-8?B?RE8vUm5paUVDOG1CSG1QVjBKQUN0ZWhiblZJYW91dU1nQktzbUYxdjFWMEZH?=
 =?utf-8?B?d2M4WWVvTTZEL1VPZnBKc2tObzJNV0hKWE45Z1hOSjNua2VyR0JKODhCaEJV?=
 =?utf-8?B?ZlZsOVZXOGtGMzJQNVkwRjIxdEY1TTNwNXBDV0ZCc2UzWDNzaERQOGJnbkZQ?=
 =?utf-8?B?YTN4dENVOXJBK1BUSmw2UjlmSVQwem53UmZVOHZ3M1BWczE2M0FpVmMyZ3dj?=
 =?utf-8?B?d1BBMVQxUCtlTjN6NGhyMW1lTXNRYVRMNUh1SGg5dm05MjVsN1FWNThrUlRr?=
 =?utf-8?B?QlRzdUFJSEo3Zkd4Ylh3ZkdHWXFCV28vV0FPbW1TbmNMekR3emFacGVBcVZv?=
 =?utf-8?B?cU5Qb1lLRXpyUURZZVM1MWpzcXczWS9oZFh4TTB4eFAzZjlBcllwcXMxaUZB?=
 =?utf-8?B?OGlGUDRYd2M3UHdsQUgzeHltczRrcWJ2V1hRNFJTbXJLZXVsVUN3MzJzSjZP?=
 =?utf-8?B?K1Q2RmNIdnhwVHFSaXNuWWt3VnBrL3FtZUl0UjIrdHdTejRJdWEwZGxuTHFq?=
 =?utf-8?B?MHZuVXNKcm5DZCtQSGJQZWVVcitiOU5XSXF0SzgrK3ZrMTgweU4waW0zTUUr?=
 =?utf-8?B?RFNodnI0Z0ZNbDN2aVRObStqTUJRWmNIaFVxeFlkK2VZck1jaG14MmE3RkJx?=
 =?utf-8?B?Ykx4TnRuZWdVekwwaTdOajUvTWdiZUErOWJTamJLdFdoTCtYZkloY0ZtRW1F?=
 =?utf-8?B?MmlLQ3BzZEo3bFY0dlppSW5keGJNSStVY1JZSHhCUzRQYisxYkhmWGU2YnEz?=
 =?utf-8?B?YTZHQWdQaWdPa3Iza2VvSkxRTGtXMTFRaHFmNkc3WHVTL1dsenhHcmtOWERu?=
 =?utf-8?Q?/Q3U=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 11:28:45.5474
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a001f3d-cc86-4544-d2a9-08de16152815
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6004

On Mon, 27 Oct 2025 19:32:26 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.301 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.301-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    24 boots:	24 pass, 0 fail
    54 tests:	54 pass, 0 fail

Linux version:	5.4.301-rc1-g4e89a6191515
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

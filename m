Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012029.outbound.protection.outlook.com [40.107.209.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECF13314DE
	for <patches@lists.linux.dev>; Fri,  6 Feb 2026 10:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770375577; cv=fail; b=mqlXPeTuCfU1CWuOyLggWDn+uprKR2ZMTODIsxhUdM+RaMqwb0a1YSRzCwF43YNdqq5bDPEp4hnUStigB/OqQFhLeHhfvehBUC4pG437J5oTNBpodCYtfCgjsFJUvsCf+606EKh57NgcC5ju9qREzqtHv8gsh16EM+dheb98kTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770375577; c=relaxed/simple;
	bh=sHgu9jxKOhpYuFFU+hsNKgOt85QJh4C9FJ33YhJ41no=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Vyh6J0pkvaGZwVfEX6DDL6lWadfntOjhuFHBJqt4q7dJ+43qu7rsbVoCj/2+a4bUA7Os5KrC53mFPU85oQzMyqjNxZY9/4ts5X55150PZc7P1PXUwamKrQTA6SK6ke2shZv+bM8maJQtMkO0vsetf8CBgtH75aR/A9ue2d6VCwI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=b+uyInZo; arc=fail smtp.client-ip=40.107.209.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="b+uyInZo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YZlL2Zwpbyi4yjwSDFmHijWMQafKOPoIMCgmzHDZnRGAb6t2aVI9DDY6/PToFiT7akprYph5aD0tI9Eqhq+e/hzW3AA9kOV8bzTlu+4m1itz8SH77f4mYPb4LTskI4edKu2QL2t9NCugZ49nqiWgZOYVxV9izyIeqgaHkVNhkUWjXJeYZCM3LOXj4NRC9T094Tag6L8Txoy+bUbLMs5h+w9qWzydmm4LveEhY3JTggr03Hh815O/JmgAvxSOYbxP/ry8G/JETQ/zTezUklnP+5w+V2pRUC3QpM4ANGy6qTVh5rqYWXHwvViLw+W5KNsuXkrD04G+VWnhJx8H4buW9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uDhmtk3ZwP2hN8wkFd0ZrPWBm+bwqVAhnp3Sg5FpbGo=;
 b=p/ckstHfe9hwGrQ7Rz5KRwKsrDLkvaxK1VrR4ynFtOvM7V0dmX6NuXz2w9imTbfY250l1UayApAoV9l4s+kZFPlKi6V7F4J25XCkG68piGI3m5s9ylFZOnQQDDbd7/xK8dBFlGKdqLgcVpPzfsCRI+26d21B9EnDYA7UUK0SbTuAPnhNr0IVfXeRUMhIVs1OYQI7laf7dawsQNEmkPE9RuoNa5WIg/JSvFb7BPl719HHvQhj51gNqItFTu5Ac8W84TkL9WAT2NYBNhHiTbYdWor8lwsU2U634oeUZaAz7COGav/qTStSU8JF41YjY5azTsTS7CDmP8imVDWLGEzjsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uDhmtk3ZwP2hN8wkFd0ZrPWBm+bwqVAhnp3Sg5FpbGo=;
 b=b+uyInZol5N3N/2zVnRW5mGwb5fMH1qjR6njwEfOzO79E9FO4Oz587BpNj1ZY7/PGL3/msLZHs5Zg7g8WapSBoBhKdYFCLUsrAQmbcPYHIr25dSX+iNiyBvs+ed01WYZf6dzRGq7dM6rlwC/R/MM9YBuAn0p63Hxl5fNBsaG+viAorrt4k1YcICnJV6TO7XAQpJd4I7Oz0JNZRpEX0wgvIaUS96qIMbHrrmVTVeGaE0eb1XCbmm/6+VcJOJAmJF8XgKHKPZUrZc2DyCogbDWFs0MyxM75WNQWcXi8doFag+J1cd5m8YdC/zkeBcSMpmt35o+xQcmxVrJnQ/5XYa5/Q==
Received: from CH0PR04CA0035.namprd04.prod.outlook.com (2603:10b6:610:77::10)
 by DM4PR12MB5745.namprd12.prod.outlook.com (2603:10b6:8:5c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.13; Fri, 6 Feb 2026 10:59:31 +0000
Received: from DS2PEPF0000343A.namprd02.prod.outlook.com
 (2603:10b6:610:77:cafe::7b) by CH0PR04CA0035.outlook.office365.com
 (2603:10b6:610:77::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.16 via Frontend Transport; Fri,
 6 Feb 2026 10:59:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS2PEPF0000343A.mail.protection.outlook.com (10.167.18.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Fri, 6 Feb 2026 10:59:31 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 6 Feb
 2026 02:59:21 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Fri, 6 Feb 2026 02:59:20 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 6 Feb 2026 02:59:20 -0800
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
Subject: Re: [PATCH 5.15 000/203] 5.15.199-rc2 review
In-Reply-To: <20260205143441.536029503@linuxfoundation.org>
References: <20260205143441.536029503@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e837eacc-14df-44bc-ad57-05c1253eee0e@drhqmail201.nvidia.com>
Date: Fri, 6 Feb 2026 02:59:20 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343A:EE_|DM4PR12MB5745:EE_
X-MS-Office365-Filtering-Correlation-Id: d2e21197-f8eb-4989-a6f0-08de656ece43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?KzhJN0ZGNlFLQUUxYWI4RUJwbDg3L0FKNkFubmNvOUxHOTdUNWh2TmVFU0pR?=
 =?utf-8?B?RC9Sc3Z0QXdCSTE2SWNzS1dlbXM0ekU3UTNvaVJMai9NckZxNVhKMXZ6WjZl?=
 =?utf-8?B?MjZwQlVUZHFGZkt1Qk5zOXZBcmM5WnF2eFdwWGVqMzNucVdFSTRVbEROakxm?=
 =?utf-8?B?Zk5zWWliekNiNHZwOENXSDZoSDBUTVB0V2QrTi96b01tbStiN3pmK3dFY3lJ?=
 =?utf-8?B?eFphbDRPby83bzRmSXlOSmlPZ1U2bml2K3E1d1VZV0llemw2Nkh0cjczTmNa?=
 =?utf-8?B?d0prTHU5UzlaRzk2Rkt1TmRCOSt5ZlVaT3RibUh4NE5PZTlUREk3SU55NzA3?=
 =?utf-8?B?SmVhSnA1THRobUJDaEJhQVE4cnF6c2FzYWo4dS9tdmV0cEhYYTNqbDMrdkR5?=
 =?utf-8?B?RnNvUGV6YWlGVTM5bHZTNFdPb213VjBnQ2dIMjZCT3puVWtPTkdETDE0UW9D?=
 =?utf-8?B?QUcwaEtPaW5reDhWVGprcW9JczVQRld5dll1d2w0ckhteFNWcGtKVS9pN2Rw?=
 =?utf-8?B?TFRDaC95aGdXZDVOcmtNMEZPL0RNdW4vNjVOZWNmTzVVcDN4VXoyVmh5eENP?=
 =?utf-8?B?bnRIM3FKQk1nWjlQclArRXU4ZldsTUhDQ3gvc0l6angrQTlwR0Z5MG5Pc0RW?=
 =?utf-8?B?ajVsVHlEYUk5dWQ5aEFTWEpQdGw2S2RyYnZhVXVFbDVSN3U1empjbHNabHRh?=
 =?utf-8?B?eWFHSzBCdy9mMWEyZ1hlNnhtMVVzTENpZGNnZnNobE5XM2YrNnBBZkEyTXdF?=
 =?utf-8?B?aVY1anYyeWJ4SFM3UVFvUjZoaXh3UHRkL2psMDYyMVl6cEJ4Ylo3TDMwdks2?=
 =?utf-8?B?OEVnazlhRDR0N2NUVDFTbTd2a2dKKzUrNHdBekVzZ1B0SjRHM3hHcjE2K1k4?=
 =?utf-8?B?ODJ2NkhUV21wWGx6VVhRS25yTlNMdldKNUVOZlk5MEhaeGFQMGo3aW1ubzEx?=
 =?utf-8?B?WUhFbDh1WUNIWENVOEZ1bktIeDVqdUJ6U2VNK1VWc0tzL3M4cldETWJza2pK?=
 =?utf-8?B?T1dPRXQ3RGlndnFiMkduOEY5Tm9lR25lMThIYWpFL2lTWXFCVk0vYk5oUWEv?=
 =?utf-8?B?NmFYMDV3NzhGbVRYR3NPbFFHZmF1QVp0L3J3WG1kVXYybDN6enpCV1lnQ2FH?=
 =?utf-8?B?eUdDSlVPWnRiNHQyUUJOK0I3aDJ2czBqRTZ1TFZXejdCeitNMnRtcWs0Tmwx?=
 =?utf-8?B?RHlSMDdSMXZpamNGTDdCZGxqWXdhYmRESVpxYmoxWVRvV2d6Z0JEbEFtZUpR?=
 =?utf-8?B?ODlPdzFISXQyRUZhOEd2RUlWMVZTVzREUDdNUHhRU0Z5aEtwb3lNQmd1UkJq?=
 =?utf-8?B?aUNGUW5HbTh3bUlDd29vM3I1WU5RL0pWcXhwZHhwbGJCVUF0TVZqRmZNNzRK?=
 =?utf-8?B?MDV4eWxqWGV6T1lXbjQ2TnRsZDhsUjZiaUw1Zk5WMnJ2QzlVbU9OK09kNStq?=
 =?utf-8?B?R3RiR0FxWTdOVW12SEpZUmFPaHFONi9lQ0RMRURtbkV3MGxmTXNRVVhqdnA5?=
 =?utf-8?B?WXNFRzlvY1FJOW9KczdFWEVjd1VmeENZNzd6UlZtUUNrVFpOcHNQVUtsbEp4?=
 =?utf-8?B?alk5T1o0YjRoTll3WnM4SkxBcjlFZk1ZZldzREhFeUd6TzhpK2RvVGRHUWs1?=
 =?utf-8?B?cVNkU3VlZjBZQm9leFFQMXdMYWNuWW5vN2NGaStuOE0rYmo2MkpiRmtsZll0?=
 =?utf-8?B?S0dnSm1xc3kzbldBOWlUQmpFS0J6YlIvRVM3RlRwRGh1bklNR1AydE11UTBy?=
 =?utf-8?B?dG9VWEpXNzBNNFVNcFVublpYQnJKOVRyMXZpd25ERndXWFhoY1hQRTdDRGFs?=
 =?utf-8?B?UFNFQVZGSzBPVFJuMy9EU3A0WmpCSTZpT290R0lkUlFLc3M3eXRkWDJoZzEv?=
 =?utf-8?B?OXc2WnMrRnVrQXFUT1FHMTUrcGxZVUtsVmZSZFFlaFNFSTFZRmRrWksxVm5K?=
 =?utf-8?B?TlljZVYzUzJCaCt3ZXo0OGEzcnRuK3R3L2RoZDBBRFdxNVVjT0FUYmY5NEpz?=
 =?utf-8?B?VWx5bEN3cUV6bElNQ1MyMG12L2xidy9tZDFWR1FBcEd2MFhuUTQ4Q0dsSVc0?=
 =?utf-8?B?Y01SNUJWOGZHYlFDbmdLSktlUnJDcW56cXA2OU1ObmxoUW9yaXRSNEp0VXZw?=
 =?utf-8?B?NTg5Mkt0RGI1MDI0TWpXeEdFREozYUxUWkVMN0toWmhGQnVnVkdnTUR5eUI1?=
 =?utf-8?B?SkVaU3puZHk1aWFsdGVRcUdpM1ErMjJkdjJXeml5VUgrOVRGTjN0S0ZCT0Rw?=
 =?utf-8?B?a3N2VVphTkROZjFsNjNlVTNxRmlBPT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	d3WXVd9m5fhn6Czhz8UePI4ToPmM5cKsSlbjvBR+aysZcpmycMu1IBZHEIQGgL2PgIEhwdIFSfckE04rOlxwaRazU6U7AxKg+5pCNH0nYUR3NnMZH4imbp7py16l/Ia21oSjkbZ32Rgnz7V1XLOVh0AQiIPXI6kg2UlCrMXW7J+v9DZQXTCYo+fOhh48W5Q+PRUu6WRAgwUQ9N7pXcbvWnvL3slS6zRH1Tl6uOE3Flw/O2V9r/iYlCqOyzHIXkNwqTU5wljinZuTZJU01S1Y+zN1bvdxyKGjD2i/tD5hMlbpwQ5cu5dChi94nmb+VtSIlPbiBFrX8SeQX24knXqmVCgZSHaeeLNICQb2QLAEDW+7z8VEbiYjFOzgqaDBzIRcCWe7AH2WUytpBqEvh+xFgSRbC+eMPwG7dZyyyThnIh0taCs7hwEQM6tOHQYDdlrc
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 10:59:31.3291
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2e21197-f8eb-4989-a6f0-08de656ece43
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5745

On Thu, 05 Feb 2026 15:44:29 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.199 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 07 Feb 2026 14:34:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.199-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    118 tests:	118 pass, 0 fail

Linux version:	5.15.199-rc2-gf8f685541ea3
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

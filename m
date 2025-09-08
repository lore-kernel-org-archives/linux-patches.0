Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D6F30DEA6
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 15:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757343744; cv=fail; b=qP7ND74H5ulapHBRKnToX2jGAlCA9RA+3dwhxaavrNsTolcicvxRprw4mrc9yl7RAJPspGY0eNfHCeaK178tlT2zhV8XezhAl7m79LqlKLBoDNvujjR+CakO/VqKY/CNixgSI104yhYZRacns4cUptM88TTV7EUgznH4ffqEghw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757343744; c=relaxed/simple;
	bh=ntBBYcn9d37b9/6qtPyV/56NMHUe67WJRRQqiYfNbuo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=ITXeZ9GgmeSjG6i+NEA8ytmhyzi9cHoWcrwA/8e4vLipa5GaPO5TmbM93I/9HsQnTF9f5tOY+RoVLy1IVq+vvfLu8gtjlHbBFW+DL6duRanAe7aaoC6P5cxB5/Ef/FBSiaC/2q+pr4IXi8g/kD/pnPMOkqPOuKF49c+kFOtThAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=s6gNu4Uw; arc=fail smtp.client-ip=40.107.92.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="s6gNu4Uw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XpvTzaWXiXPdQkdBLxYHSF1HS0EzIPeVDW69TcOl07eujePpKBQVNSqZR+XJwLIz7s6R6WUDTAQ3//qOiTCWZH4iGX3yjuhnYjb+NQlmPlXc3BOXa3mNYh/J+kGwiHKTRzFxrEhK04/NRu2ZJ49yov5gF6oqEmQmo8tBrG85qFn7gQdzSKau3phagTTAnZh5Zl4gqNI4/LH76rKcSPFQE0uWA0kCHikqmPSYqmKuPkUKqvLe86y9UiQNnISvU3en/oIJZy5T5DrdBnuVyieWdmMnYsrC+x+xZVdvy9qJDzweuVKF3q6kG6jQH6ZI3qLv6mQil5vm6bc/LQ3sjDVdWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VBL/kWSNsF2bnmeFApyxDM23pDt+M0HqiuXfol2nd4M=;
 b=PccXoYD2j3ZMxH5RRyO1R6uL+J806AZAeFdNcR6F1wGrRrntSwaYH6l9i7a9ANXpj9qjGwYNhfx/AbujdSpMXZjGJWZNo96Mmmb++6JksQoW2/s1E3Eyerw5J6sbLURmO33nAJZQpciUSQHhtUj6WsHIRDDw9MBNNXL8M7euTxfN9unjBHZBZinLKc9UJzMKarn0xksNFYtzk8f9crVNAovJJVNYwx1p8iSN7jVO4Ym0gmaUJdVGNH7e0o4VhnOUrW5QYukSNXJOQI6oZORcvuby4vObyPKOVryBf0Q+6vCCuQmlxjl1JxkAWYwwGCXn3ZWbaEh9e3ViVDqmWv1zLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VBL/kWSNsF2bnmeFApyxDM23pDt+M0HqiuXfol2nd4M=;
 b=s6gNu4Uwg/qJ+twhheW5XdplKIQkdKMUxproIKwQ6fktwJoefRl3znNLx94aT4A20vxkPCtVwbyD9+yUT1qL+KRT92SnahUyqM6Iza/cQglKjW18NBQQdeVssycSjCY4bcUqWUKHQJUeJ8qv4ZBKHeBnkIepJN0FZdUNZLbCQirk0pc2cqZzgGU7tgmdvGv79k8ImpY5mX15PCNPxl75nYNcn3RUulJfUSi7rECUpK0R3ubiMfohL4WubghY2DVOjtaSW7MK5N2QAnJ8gPMLvl/IHQ5llp8d7EYdXlFTX4cMwQ06hqRme+mG/VtH4fbUcMkBEemIqELW1sEFLsau8A==
Received: from BN9PR03CA0116.namprd03.prod.outlook.com (2603:10b6:408:fd::31)
 by LV2PR12MB5871.namprd12.prod.outlook.com (2603:10b6:408:174::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 15:02:18 +0000
Received: from BL02EPF0002992A.namprd02.prod.outlook.com
 (2603:10b6:408:fd:cafe::62) by BN9PR03CA0116.outlook.office365.com
 (2603:10b6:408:fd::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.17 via Frontend Transport; Mon,
 8 Sep 2025 15:02:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0002992A.mail.protection.outlook.com (10.167.249.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 15:02:17 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 08:01:55 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 8 Sep 2025 08:01:54 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 8 Sep 2025 08:01:54 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.12 000/175] 6.12.46-rc1 review
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <743b2b79-2be2-4a66-91a9-c6aa5cd24e49@drhqmail202.nvidia.com>
Date: Mon, 8 Sep 2025 08:01:54 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992A:EE_|LV2PR12MB5871:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b52c2bf-b4a2-463c-af06-08ddeee8b3ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VnN4VFcvUG1TSm01N0xnMW5tOE5DYURSbEdXZ2tFYnFKME5HRXFHUXFRMzU3?=
 =?utf-8?B?ZGdnNm1QOXg3NG1JanRTK3pZaThDdDk5QXJlR3h1dDV2ck5XSnVGMzQyMXdF?=
 =?utf-8?B?OXQwZU5BbkQ2d0R5RVJaanNXZjMrU0VUNG1TVmtIaitlTFlzL1dqNnVBaFg2?=
 =?utf-8?B?YS9KaUtTbW8rZG9jQmRCazJJd3UrbTNmS01vcmlldmdrdzFtL2NLT0djTE9o?=
 =?utf-8?B?ZHRsQlJaelpUNjg5Y2J4Ni9JOXVjMHV1M3hSSmZVRXJ3MWtINTJEVlE2K09M?=
 =?utf-8?B?VlhGS2JYOWpWcVVkamdZZ25rdXJ0ZlJ6aWR6WFY3MG1MZTZHby9RdWM4SWxR?=
 =?utf-8?B?MkFqVXIvTlhkUVVzRWZZQkNZZXJPOVU4T2FPWUZTbHFQbm1iMWI4aWZ1M3pP?=
 =?utf-8?B?R0EwK0w2eGN6UmU5KzcwUEp6U2JpaXM0VlRsNy8vY3FjUnphaitmUllQUGNi?=
 =?utf-8?B?a0VueTRpWFQ1NWRORzZvUmNlWldwSkdMSmY1dVpKL2dVelFYLzl6TU5qbjJs?=
 =?utf-8?B?aUMxVXFNUE13NW5XcFpiTjNWTUtOSUdEVmJYclZKQU52cXRFN2VSbEFYc25Q?=
 =?utf-8?B?ZEprUEhFV2hkYzgwOUdNTk5RYWNGbGsrMHFlWnlXNUduVmhaVXcyMHFSMitF?=
 =?utf-8?B?ZWlPR1pNQkdhNWVtc0d1L3lEQkFNYnJveXFvb0VFZUw5Q2RZeGUyYytwcDZ6?=
 =?utf-8?B?S2Z1aWlySk4rVXo4bURtZXFLb2s0cmZDbGFubjNLNEcxakgyeG9TU0RKQ1Jj?=
 =?utf-8?B?eVhIR1B2d3RpbC9VNG1Mb3BWRWdhM01PdHIxY3d4N0ZBSGd1RFQwblN3dDlQ?=
 =?utf-8?B?ajQzbEc2dGRoai9mMlVCL1hDZUY1L3lhV0R1L2RGNThjOUsxbW01T3EzdVVx?=
 =?utf-8?B?ZGlqS2t2YTM3dnVXMW5jWUhkeTkyN09qdTZsYVkzcDkyc1hNYzl2dmZhS0RY?=
 =?utf-8?B?OEtMdVBhcmp2cTFjcmRUdWQyYjdyb2hBaysrREUzSTNCa0pGY2JmR1lwY3Qr?=
 =?utf-8?B?Yk1mZExzb1pFWG5EY1lxUmN4MjFiOWIwVXo2U2l6THk2SHNWNndLQ3NFazBt?=
 =?utf-8?B?UDI3Q2YxME5STnRjWWg0QkttQ2R4V1NsRDlXb3YwVGJGNzkvRGZNeE4wSzlO?=
 =?utf-8?B?Uy9FbzcrZ09sZ2NhaXQrU2lIOTRjdkpkNkQxN3cxZEQ4c3ByK2MxM0xkNGFT?=
 =?utf-8?B?WThZYXNwSVpBcFFRSFRGeWtpWGpPb09rS3V5NzVaQkJwUUJaSlhCMkkza3li?=
 =?utf-8?B?cnRhZk0zUURZcjZRZGpNWVpsTFc0N3pIbzFvVktvRkIxMkxqWkpVUVFQQmFi?=
 =?utf-8?B?R0NnTzRyRzdFNUQ4WnZtWTh5YzNabjJaekVmNnBDdVJjWWVqMGY2UWtqVkNW?=
 =?utf-8?B?akkwS3c4eE96T0FMY0ZJeVh6SFUySC9LZG9YMW94UVlrWkk0cGZiT25JU2pJ?=
 =?utf-8?B?K0diMEFUZDhlUTZidXZ1NmxHREkwMlROcUd5cm5MakRGSnMwdk56RHk1U0Qy?=
 =?utf-8?B?bHhZUEQ1NGRrUGZDdk9udWZnc0ZKN2haSXd0R0gxdHFJVWw4WFN1ajhkeG05?=
 =?utf-8?B?bTRheHl3dEJvTkcvTSt6N1I1Ti9rcXpCTlZuUlhZOU9PUnR3MEh6WTBNL2tm?=
 =?utf-8?B?SFlUMGJuSnp3ZkprRVJONHhJWWR5RGpWeDREMkt2TVpMU3VIVDc0NFJCT1Ri?=
 =?utf-8?B?RWU0Z2JYL0ZnRXVjOTdzWnhSV3V3aExpbUJUS1FqVjdPWkhOTzlKUEFvQ0F6?=
 =?utf-8?B?SDgvRThJUWhqeThya0hadDhWa09NbklETTZ3T2l5em96aHIwL0pBYzgwYy9i?=
 =?utf-8?B?M0JNRERYNE9ETGZHa3J2V2FPSlVZOGlVa3pIQ2ZRWHFJSzhvTEhVWVN2QXFv?=
 =?utf-8?B?akdIb3dhV2oyNGdEb21ZZlFEK0YyTCsxNU1GZXlnc2tnaUpwdmJFbENUMWYv?=
 =?utf-8?B?akxib0JjVzA4dXo1bFAvU0xQK2paQkRndnNBdWxhcit0Yk9kOTN0M2VsTDJQ?=
 =?utf-8?B?UnM1d0VKaHVMYVFHTHc1SXJxZG9nOGtqK0ZlQkVLR1JVdG1RRjRiNmxFMWVI?=
 =?utf-8?B?cmtsQzJrYjNKMkQ1ZWJ1OXovVHpoSThzSWZYdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 15:02:17.3841
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b52c2bf-b4a2-463c-af06-08ddeee8b3ef
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5871

On Sun, 07 Sep 2025 21:56:35 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.46 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.46-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.12:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.12.46-rc1-gc208f5890488
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

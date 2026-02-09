Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012034.outbound.protection.outlook.com [40.107.200.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347B6330339
	for <patches@lists.linux.dev>; Mon,  9 Feb 2026 20:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770670567; cv=fail; b=VnFZt+tVLf1gd4s/D+YUQ55FdOj6pflMRPMz0ID4SiraRNEP/ZLQSPRU1Km6ZK9OrQFs7HWMQHeUm2ErXwUdUbnuil+CITZdMB3csbAp147V3UkL6A/m0q23LhqcZIwtlNqJVt4ulrhmvcW94CM/v7FRUUu99fSHx1PDgi0skV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770670567; c=relaxed/simple;
	bh=uxDbT7JjMsouLieg+k1+MLl3czpM9EMKKTlEq7oKXbI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=oyyNd45yvtNSdyCN3otLX1euFOlDYXRtkvJDbM2xCx0gvaBRh8aCAjImsL+UhwBbDGuAZjpe50fGmj6znTB/PSDJlsMihumHxONLCIdIHO222tBoPLpVdP8YRZXTz1kAERehK3kkufL/TkxPqXNmwMlZ6otz+pNRD42RM2epL6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WZTNAv9D; arc=fail smtp.client-ip=40.107.200.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WZTNAv9D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gjlhC7OOIT2y8yaPpWxqazf0CVPialdj7Vsp/+XA9HD7kz6kgQNaiev8ueeF+O9hO6D9daLsNa43cSMXfChiPVysfI7KXvT1e6PvZD95jt60vU1mG/b+D9NmBlNx17FLNh57rDvPwRw+EzB6etr5N7Vjsvck1oIVeuyWi5p/DIA20WJ92vuuW6iLOtd2FWSsk1p22HiSJnOpmlrP3SBsmVXXl5xpT59iUSsTp+RpjHPyXMFmq94eBU/vzBeUXyE3kehfRLlfWpA+wYItjAihZEjcw6GnNXIAVb6yZ6F4DdNw3ySz5CgbzX4kOFN1MKQ5h8BC59HULH8fs9T+qqn13g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZQPdnGJp53lTzpWT10hWof2sltCuZBTt7l2DhG5BVqs=;
 b=HeBZDWmJNT7Jc/lKTL7V7euwXRYdFl8S6jeFh1ieNFqivuO1e3mPAeU1r/x3gu0a8B4Q4P37sJ5U7o/1V02GIdSjNYnVa6sjdYsPiF+m1X75sxGUMdTnoggeIvyCiF7NiJDcnjK0F7izuPpiJgcyC+S12VvsZ5mYmnCJM77Jyi8wcUuGnES3YoQzUXPRulKSRJfzHZaMyyhLxZ7Pt+2+ujZ8eVUbA1VwLGeulMv6Lne4TXI2TN/SRpNGSglIcNLTAIishKp3WFdAREg9Di0YlLguD0XDlbEe00xO6rdQE0WqS5MJC1iVAtxGbigDRvUdX+J2y2ptI4B5iRQHGDcFCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQPdnGJp53lTzpWT10hWof2sltCuZBTt7l2DhG5BVqs=;
 b=WZTNAv9D3+WD7O74McqCh6lXao5ZHXT0rqfnoA4Coa3laJBRLglz7FykH2xlQdqIuD9bw1w9qYex9qlPV52QFDh/Y73dQgrAqqeoOWPtPU40pHzfI46lLOWRcWAjmvVIXudmGQT2tIOj1vWh73wAZSbe8xBlKnmDwdQbS7Ml6TzswJKrr3m3RFsnjSaQIu6V8j9wX/+9jQmSylXnNc+W1GsEYU4TOlgLhSqSOrqf8EySxSzICtS+eQdlDuhFQnqqLh85RuBPhGIwfJ0ehzwMhrVLhJ+Rb+v6GQWpC11RZDYeuDQng5Rfu1OcaZ9WU1sMtFsRTXwi/cD9r9N4TnsQXQ==
Received: from SJ0PR13CA0008.namprd13.prod.outlook.com (2603:10b6:a03:2c0::13)
 by MW4PR12MB7360.namprd12.prod.outlook.com (2603:10b6:303:21a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Mon, 9 Feb
 2026 20:55:57 +0000
Received: from MWH0EPF000A672E.namprd04.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::75) by SJ0PR13CA0008.outlook.office365.com
 (2603:10b6:a03:2c0::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.6 via Frontend Transport; Mon, 9
 Feb 2026 20:55:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000A672E.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Mon, 9 Feb 2026 20:55:57 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 9 Feb
 2026 12:55:28 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 9 Feb
 2026 12:55:27 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 9 Feb 2026 12:55:27 -0800
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
Subject: Re: [PATCH 6.12 000/113] 6.12.70-rc1 review
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <0e69a30a-0c9d-4ca7-9b0f-c24d1b314576@rnnvmail205.nvidia.com>
Date: Mon, 9 Feb 2026 12:55:27 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672E:EE_|MW4PR12MB7360:EE_
X-MS-Office365-Filtering-Correlation-Id: de8a600d-cfa9-4a7e-3007-08de681d9fb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|7416014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NzJFZWsrZmVZdThHNnh2OG1KbzZuc3FadDdWR0RvMGxTZWZjN21KZjRJUElG?=
 =?utf-8?B?R0xUbUJrc3hSOGd6a0Y2am9sZHIwU2JWQU42MXdsVDFQenA3dGVzMEIwWEpk?=
 =?utf-8?B?YUliRC9WZlpsdG1GVllqUXFYTm8rUmszK095MlNxY3R6ZmFJVWViQW1HNStE?=
 =?utf-8?B?NEpPZy82czJ2cFY0L2NvRXp3Q3Z4RGFqNXJobWp6YlNZb0wrY2cwQlBzK0ZE?=
 =?utf-8?B?VVNJRlBRdU4zekZQZzNUMFZ2cDBDd2MrTjNwZ1BQOSs0eURwWVF2ZlZ4c21L?=
 =?utf-8?B?dWlHZEVyK2xIRHFIRTZsR0NIandNQWRzeGs2UmN5dVh4bmJGaUV0QWo1TFRX?=
 =?utf-8?B?Y2xnSDdDUVUzZUY2UmtjZ21NOVdJa2pvbnV4ZWFjdktLVFYvSE1XeWR0eDlk?=
 =?utf-8?B?YTlyVndGN1BpUUR3M2dCMVVGbk42aGVUbURFaGFmM2VucVFrck9VZSt5Y0ZY?=
 =?utf-8?B?YnI3WG9MR0xiVDZxTEplUUhDcUxkVlQxejVrcXhYSFFKYWtJMmNtQnJhekdE?=
 =?utf-8?B?MFgwa296d0dDbncxLzNHK2pYYU1IOVYvR1JCaHpuc2toL1hacENTZHlJajJJ?=
 =?utf-8?B?QVlRaVVub25QcllPa2NXRXFITmIwNlhTVG13ZHNhYllUeW10V0lPbDE5WnE4?=
 =?utf-8?B?M041WWt3WGREbkVoTmlocXNpL1k5S2o2eStXK0dTRWU4cmxzdloyYldySnVv?=
 =?utf-8?B?QWVyaVFjSlM1bFRKYU5VaUlFTFFWWXc1Y2FJNXRKcXBHYytkam45WnpPYnFI?=
 =?utf-8?B?LytxOHhLOHNUVlJROUJEZC9qcktyWWw3MWpNVWdIZnBFd1Fta0JjeXhGVUNy?=
 =?utf-8?B?ZENqN2o5Kzk5RTRBT3JIRE1OWTQyMWcxSFFzWGl5aEFEekpZbVFiUnVEN1RX?=
 =?utf-8?B?ckJVR0dKZkI4SVFvQUNGMXpjbjB0cjlrZkkvMEFDaHlxL0w4QmtZbExRc0xI?=
 =?utf-8?B?YU9DbmZmM08vbWI5OWpIRTlwM1M5YXZHOUt2UDYzWHBDNFdROUpTWENjd05S?=
 =?utf-8?B?eUJzdVhvRTF3dkIrK0NPQ2d1N1JQT3RhdjhOY3ljZUlzWTFEMzQrU1dzUGVi?=
 =?utf-8?B?TkZiWFMvSWpYOUdFVWVrRE1NbG5QVFVTTzQwcnIxOHk4a2lnTjEzWmZkQ0ZV?=
 =?utf-8?B?bzFYc1RrdkRLQUhkRmFwdVFYNG1XcFlveUFyM1NvdlpNa01Sa3hud3piUjQ0?=
 =?utf-8?B?Nys4cWkwTGY4K0MrYnJsVFROM1hSdGdoaUcwcTlRZG1XdGgxeFIrSHQyOURU?=
 =?utf-8?B?cGJ4NnZJdDhEUG9sSU8yNWV6MDV0V0djU1hFbE9iUTV2UUI1WThCUmpHcERm?=
 =?utf-8?B?elBnTHZlOFNBQ2FUTGJ2U3JQbE9pSnl6WlN1NmVkVXhKL042OFd6d2tISFJi?=
 =?utf-8?B?cFdGUUV0bDJjTHFRYzAxN0NJVDNEM3poclM1Qlh6R2ZaekNlQi8wZ09HYzBO?=
 =?utf-8?B?TlUrUXBSR0hoSmJYbkhuRnhhWGJ2TmVHWUlhREhPV1gyNFRHcHhZdHcxR3hP?=
 =?utf-8?B?cUxZTG9KaHoySWQzQ1JEUzEzY3lqWTNGa3dLTW1vZm9jUUNNQllhVzdsOXVP?=
 =?utf-8?B?clV3bDZsZ0dxUHkreWZhUXIzVC9HL001ZU45R3ZiMHRmTDZPQWdEbVF4V1Rz?=
 =?utf-8?B?QWNkdTk5MDRnSGtWNHIxR2xEQlMxZ241ckpYU0ozZEtkbjdhc0F2RUYzUjkv?=
 =?utf-8?B?STNIaktPRy8vSmpmNjNUMHVjbXNtejVOMlA1R2FscFlabXp1eHVuVHIzeVBz?=
 =?utf-8?B?UHg3V3l4ZUtjZ2M3dzJKUGVkSUxhSkUva2cyZFRoQmRySEhFMTN2TVlIaFlV?=
 =?utf-8?B?VzFBTXh4aU1TNzduTzExbGxyamNOZFFadUJwblcvZlB4VUNuSkEzYm1QOTFD?=
 =?utf-8?B?UVhDMTU1b0N1d3NHTFdsbVNhV1R1bXhwR1p2UmgrWXYvSGNLdHM0YmlhN3k2?=
 =?utf-8?B?L2oxNzNzSEY4Z1JFOUtsWWlkOVREM1NBa0F2Z3dCK3o1STJHb2krL2w3dU1t?=
 =?utf-8?B?aldMZm1DZkZyUW1DY3BnQUh1VS9ZY05RTDY2OHpNNVRZSVlvM2xsZFBNZ3Ba?=
 =?utf-8?B?YmlmTi9uZjNKTVFOV2dzZGF3WWhVVDJ1WnB4Y01xOFVpMFpkQ3JuSldHUzg4?=
 =?utf-8?B?TUw0SWRZc3NXSlhtdkNVQWxMc0IzQkYzY2I5SUt3d0owNTFENFR5cGZYMDh2?=
 =?utf-8?B?b2kxU0pVWDFtSEVQR1pZU2QzeGxYR0pkdWlmTWpJWHhjK0FaWmc5TE40T1VG?=
 =?utf-8?B?Q21HeUZPM0lEVlNkUHIzSk56UUV3PT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(7416014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+XMpF7dHrbV/i3JU4WpsFsfe2qsSaYZV2lHiogtwayD8BKA46b2xgZc08Q+Lzk2g9F8lLnzJloUedXHfKm8QgCguxbH8JsAtb2mZZJv8MLSKT1GgjgXKexO8uSxNUjAH2ipEvnEJn8HFB4dZufUMBIOcVDtSR31ocgoMRZv7x4try+GDTvqyX8u5bmq+6PwM93pGImR7TAkkn082g6hGNLCCOFmhIZYlLXoxCVY2n4N2n9asCnuAj+/sV4R7W7UEB2njbky/awtc+OTS68h6U/KMdsCAlUeKRAxiEsy/qbW6WytH7bIOqVpHA3BVwDIH9vlyfGIZ/3gV1kSW4KAiDSUN6JES0y/AVpPAPSgMDSsMm8DeE3CHNewTXZw4Aj9bfWk/ADkcJ6izp8zrxkqLhS04iI11YZuMvaPNYG4u/+z5JqDpn4eHn01gaw8aC/l9
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 20:55:57.4645
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de8a600d-cfa9-4a7e-3007-08de681d9fb6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7360

On Mon, 09 Feb 2026 15:22:29 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.70 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.70-rc1.gz
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
    133 tests:	133 pass, 0 fail

Linux version:	6.12.70-rc1-g59b78c63efbf
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

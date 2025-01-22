Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5A9212D6F
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 13:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737552223; cv=fail; b=KySzIilunBWRKhplBxcDRWjc5cbiCN0BC9oDK40iN+JJNugglcce1lvfvxj4zvkKq1b6/byamA1URPHaqXir8jF38BWzM7k7V/OqkhqC8A9kir1/pq95NG9ZLM8CqXn+ec5l6jHydp6xX2IHSNWdTlnbHKd+5SgQzXsTf+D9xIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737552223; c=relaxed/simple;
	bh=kUIFdcBCm/uP0eoeravthcl7PPv7/XFU9TgeHYPq+tw=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=oh+Wu3zqw+TXtLHjtLqTq8Y8LlGlmJLZlTXcbP5CzpIGw5K88/MjLQVrfbX7We7zkFktjYSbi12BY2kFIGj/LzF2HFKHX1tyq8XM4F4YkmP271Z91WD16pKDzQgrTUBR5a976e6k+FlSZqVryxTABvCNn1+KDHBUfKNeiqst5Gc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=q3ZDGVom; arc=fail smtp.client-ip=40.107.244.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="q3ZDGVom"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cUAqT0OvmVeS+W8OtYysbaXSr66qvoYha7yWlSr8bj0YE97y8uMcEVnGTR1dw8Q9p2vyxgjOeA+jYdM4yj50bCxRLtnXVmwTVG1TcHVuBf3sAArVK0ktaBjFkwOSbaaHSsxEU3mw2VpTaXqrWPwKW1QQq0rbA51r+d9o84noqFo4HJ5bVx5nQ4yUC++AMpqibkj3RjREBIHIRYIHknJx2r/fBwbklvxzS279vhsILNwY/LPLL5Ic999AbzJGq0U9enHv3tQNPgzfOipvPl86+v0jr3J8n85JTB+9D2l5Qd2pkeUvzUXg6wiPY+/tUmT0RdbqCb4W3LJqO7nMo7xtLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Jnk8NrUWw8YbWjKGq4QzZIBrhxjb0n6s1ylNkM6HWc=;
 b=IFEvkD4wMHOsr2T0LKzoZfiKL1fPnxnb2h69fopA80sOuHxfngdA31+zav2ef2cSeQbXuta8FP9RIO9n/ghKCpTWRRMmk6xFmH6JLHCUwDycim/53UepRiIOXJgZIFznwD6hDib5kPlCDzPedR/QzHsp2vO/tBcGgUnScSfN9433AlpCVH80c7VISEba5gy2wOh+QFi23lA84OdbUT7VpQvYYlJKHNBqjon3Oz/N5njmd2yDaODl8auabSe5gGqa9dIOHQqIiBXrnwIxuJpcO5Q3hcF58UGo6VhJvk8ZCv3WiMSCcNt+nQIhGFK/8s8AQmkUPrwY3sJff8gdAi0isA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Jnk8NrUWw8YbWjKGq4QzZIBrhxjb0n6s1ylNkM6HWc=;
 b=q3ZDGVomqGU0lKfgUQb4SX/l1a4Z2hGTTt5LqlV2lHwRgFevtCbabMTGAM56Dy1Lazgff/dVw6MGQsnPn5f7k1J0smeYqk5kciUWmp3+FT97ON6l3EUKLWj7n7i/WpYuh45q1EDck+jtPSFA2FbqfSzjUyckIJuFMU4rTyCZ1LGgCzX6rdtn7HuhbxfS6egoMbRY2bzxFNKGwXinUbDwQ2zFCv0YYqcnxvXRp0y/vkT+pNH4pNRVpY53gS9cIBdAFHxdIzhLycyiooAHnWl6MoJjEJyijfctp6/2kBorkEHrpM1aAXDVYDSsIB5MmBPiwmtgBdt1XzPhVjxmaUOcsQ==
Received: from DS7PR03CA0230.namprd03.prod.outlook.com (2603:10b6:5:3ba::25)
 by SA3PR12MB8440.namprd12.prod.outlook.com (2603:10b6:806:2f8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 22 Jan
 2025 13:23:38 +0000
Received: from CY4PEPF0000EDD4.namprd03.prod.outlook.com
 (2603:10b6:5:3ba:cafe::ac) by DS7PR03CA0230.outlook.office365.com
 (2603:10b6:5:3ba::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8377.14 via Frontend Transport; Wed,
 22 Jan 2025 13:23:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000EDD4.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8377.8 via Frontend Transport; Wed, 22 Jan 2025 13:23:38 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 22 Jan
 2025 05:23:25 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 22 Jan 2025 05:23:25 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 22 Jan 2025 05:23:25 -0800
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
Subject: Re: [PATCH 6.6 00/72] 6.6.74-rc1 review
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <b57c30ba-ec01-4d89-b8df-707f7450cfc4@drhqmail201.nvidia.com>
Date: Wed, 22 Jan 2025 05:23:25 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD4:EE_|SA3PR12MB8440:EE_
X-MS-Office365-Filtering-Correlation-Id: 186880d0-bd83-4669-aa61-08dd3ae7fb59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|7416014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bVBMeHcvRW45MkczZmtPbEV1ZExiOEpFTkYvK2lTbWVncnpMQnJOaG1XbTIy?=
 =?utf-8?B?dDRYOTRBRXBTMUtCcWgrUTBnQnBZZCtPV0dnQm94aUYzeC91cUk2Q3M1SHYz?=
 =?utf-8?B?UC9SN2lNaUc4YTJ0YkdndGo4eWwwVkp1eHNhblRsVGdmQVllaVQ4K1RyMFBa?=
 =?utf-8?B?cTJrVzZpTVBXLy9kZ0hLUk83MTVjemU3Q2ZVMzVHS0RNUFhPWmIxZDdGWVFC?=
 =?utf-8?B?dE5iNGE5T1UveGRrRnVhdDNkQ01mdHlmR056SjdCVmVJTzRzbHV0M2lXTkhj?=
 =?utf-8?B?N0hzMThNYTlxUzYxSStMSjMwNW1hWE90bG40dTU5Y2ZjRERvZlNmMkRWNGVv?=
 =?utf-8?B?Mmp4VUFNT2RjQWJna1NPS0luYndCbFpJQTN5L1Azb05FcEpSdDU3RzJScUlr?=
 =?utf-8?B?NVgwWlA0UkZIcTRmUEUwUXhZUFRkU3dBRnBINjl0YVc4eWZZMCtuT29tVk41?=
 =?utf-8?B?b1dPcVJjUkZQcWZLdDBqdXlpTXduTHIxYVRvTkV4M3VrR09XNWNYY1BGcDVo?=
 =?utf-8?B?eFhTRlRRWmYrRWJiaklwNHdmN3ErOVBWa2lSdU00SUQvR0JTQVpEbkg4RDVF?=
 =?utf-8?B?RjU0aElwaGVkQ2E0M1AwdlkrS2dPVkgvWGNNbFVDTCs1Rm5KenhrZE15V3cr?=
 =?utf-8?B?R3JvRTE1Y0phRFN6ZDl1RGZVSERUKzFZV3M3V2U5RkxlQUdyVHhsYXZ3Njcw?=
 =?utf-8?B?cWtIUXpwYVhTbW00dG93eWFiYmdrNzQ0NVpWNHMrUVdkUXlhRXoyL21QdnRG?=
 =?utf-8?B?YUFYNWpkTnQwUTE0N0hsdGl4RDdPdUdOYTE3OVAvUDBhNnlqS1NERHY2SklG?=
 =?utf-8?B?WXhYM0JEbUo4eFIxNCtYc09NU1NjZ0FvZkEzREZFd3IvSUEveG5YOGZCUWNY?=
 =?utf-8?B?VDVraUF1UkEyT3pIUDcwV2J6ZEpDb0hDaDk0RnlRVXFsUm8zL1V4ellkVnc5?=
 =?utf-8?B?ZDIzNzJCWmluSU4wYUFHQXNEc2luL05hQ29FMDZWZVM5ZGNDU0xSRVpWcFpB?=
 =?utf-8?B?aFNQS1J5RklTODVsa2Nra2hrVXBOZVk3Qk8zZnRLSmZOUEVpSVJRUnNNM1dr?=
 =?utf-8?B?UTVJbXBrTlBMR0xFcVhLTm8zdkNNVEZBN0xhVHJKMlc3dDNrNmJCYUpjMGtn?=
 =?utf-8?B?R25JcWxqSXBTa3FRQVF0WExRbHJqNno4RkswZlVhT2p2c2RCdWFqeUUvcnow?=
 =?utf-8?B?M2RpL3Vka3F6TWZnVXBNbnhheGlha0dqMWg3dUcvNlR0bUxIYTVlSVBGVGw4?=
 =?utf-8?B?NlA4YmpSTCtnTDZlb0tCbS9NSmdFQnBEZUhCcjJMakVjYmE0cDEzMkJFVmhk?=
 =?utf-8?B?bTUzQ2lLWDFXK3d6NkRuZ0ZNSG1iak5PZzJ1UlNReS9xQW9LVzR0S0k0SzI1?=
 =?utf-8?B?WkNZaUF3ampGYUVKNjJoTlVLWEl3RFoyVWNZOXRYSkw5MEFER0Nzd3pNNHdI?=
 =?utf-8?B?SXhnY0FZcHZzQWx5d3RwbnhZSWZkbzVsOUVvbnlKOEZ1TzlJRGFaNHlaeFEz?=
 =?utf-8?B?YkYvZ0RQd3BWeFY1MXBmSjhnWlJ6cDVQa3ExYlhPZjFiSHNoM3dMekRyZUdu?=
 =?utf-8?B?WjNxUldKRlNkK0NPNEFuam9UVzJsUmF0S21od1M5WWVIRXFwSm9qR0JXWEZI?=
 =?utf-8?B?ZkxLcGh6V2xPclF0b1FLN21EOGRJTUJSWUNqT0phdlpBckNtM212Ylk1Q0Fp?=
 =?utf-8?B?SFlwdEQ2SmxpbzRkVWk2anpWbi9ZVGFDR0Q5QTZXNllDaDVXam9nQWJ3R2N6?=
 =?utf-8?B?OG52TVNNNGR3WWI1VVRoZ1JpZXQ2S1J6YTZhdzREKzZab25qWTlSaStuempk?=
 =?utf-8?B?d0xsUzN4VS8zUG9reGN1aEduMzBKMGJ3cllialRMZ1l6RHBnWk5neVdab3JW?=
 =?utf-8?B?VFJBSXZMZ3RGekJaTTRnZzZJa1Zid0RiM3BvRTVqYVY0dXlXeGQ3TWViVDJw?=
 =?utf-8?B?SWFPaHoxYzhZOHlpUWMwQ3cyUk45TDYzSjZaaUpkQ3dhSHVBRFBMVk4zTWgv?=
 =?utf-8?Q?WdQR1i4atFCq8/jYffExciMZ/DHBN4=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(7416014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 13:23:38.4198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 186880d0-bd83-4669-aa61-08dd3ae7fb59
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8440

On Tue, 21 Jan 2025 18:51:26 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.74 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jan 2025 17:45:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.74-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.74-rc1-g429148729681
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

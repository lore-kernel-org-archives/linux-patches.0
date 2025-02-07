Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6331DC9B4
	for <patches@lists.linux.dev>; Fri,  7 Feb 2025 11:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738929533; cv=fail; b=Np8je0TWwdVr0OZpPnP1oR/2Q7klYrkA/eluVKyJgeLt7nN/ZeKFHXr6GIn9+pAdlTNLUn7gQV+0h4IV8iqv7nDKhsTtiHLGTcTQBiwjHjtcV+FfQrKe1+y+gFFlMnRHo0H21hiZ2WEO3tqZyb9GgrYkQKBeAaXKDEC3UVowuiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738929533; c=relaxed/simple;
	bh=f5SJwJqbkz/0BednBu44BDxJb9Ts7M9lYIugsbBkXm8=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=HwZmXTOxNgX6RX9KvnjWCmJCuCZOhn0txwaoOMBXO0pmN2FV9j2+vPDxpSHpSoM5zO/v4JAMXyhUJQME/Q2gkhSVP4phRGka1pRS5QcFOUYAR2vGD77/qL86n53RZZDfpQgOA6oy5uzrC4k4FlB5F57gA6u0sO1QS01AoeFH35M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nVHsot6Z; arc=fail smtp.client-ip=40.107.243.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nVHsot6Z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sFMYEkXvg5x7y1aS5QZvc3lhGzM3KFoMsggrZD/bIRswJb3YpPY+8F2MzrCSrWEQzXX4Vpy+OR/ecxhIko9aGkKXU4f50/U3WiS5EcH3h1C6SbhMree/xt9qtfhpi+QCilQo1jTKzX3hxVWrpW9QvkhzS0hhS9GRzpl7uL7dE5GQI5qDbrcfDT6Z2vMTEQaWG34ALLi/V5lRWB9FUQF2DKpQL6r2KnlegV7SumDQSKf7qom/n9FvYbqiaYMgfbiH5qLWqGpAHb9ENW54CZTrCW4H34ECnPHySfWmibTZlsdwuFZGcRAqN4dbXEFt5QYX1WdVAe/nmkrqwLzoucvEPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HsEeNdZDNNfnwFkB3GBsSjzssa+f/GY5EldYCxJ7QXg=;
 b=hIipH/Sq0oWfUDN6PNcBU9OoGTvE61EVkSIRgAcHDTQwMACVmWZyfnxgNiFHz7ASDPrClnI5OdY9C0t0Zr3gRzt+1ovJNnenEt62MFApGSYrwFe2asoM5hi8uCrElh7dU57/iUybEDmYl7uBlC8dmtOaMaiDOB9V0XOHbYv5/VtORfywxImGIMY0mWiqpD9H0i6XNnxlIbpQZx8WDCDkZC8x2vC8IOFU1xkjO7dieWFkBWyc90FRRvt7IjBqzY9WqZtAG9cYxDNVXMFfe/Y4Icr1kpYzDSJSTbLKH8Fyuh2fhWkQI2O//aVj4LIYSqwIXjfr5KZatCosQAE5lljUKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HsEeNdZDNNfnwFkB3GBsSjzssa+f/GY5EldYCxJ7QXg=;
 b=nVHsot6ZOdv6YArTMyjt7SsyxCJVMOiKtGiSZiwd/U22v3JzCxgs2bxI7GAdsYko8QsNxvc5bCs5fEiLSZ3fQI5LUlawEqlCLgwImGqWhdz7GhfCdvkPhC6NMwoxHi8IY519jNA3sgu7xH4Qt+Klq2kVpE/2MkM7nCEa5catFH7hZN+lwA5ceUj+yKK6YEjPkDX0y/5PKDtem50tlV9MzxgKqfYhucmp09ZFcoYRDkJQWbUR49YxSYJ5CXKCggEP3pPGYuRUagk8GbAIBPbVHoZQ1mKAFmTCBBVcTKEMEG784xIz6u0uEkDNB79roQ7I/l+WKNTM6ieplGn/XILjEQ==
Received: from CH2PR10CA0013.namprd10.prod.outlook.com (2603:10b6:610:4c::23)
 by SJ0PR12MB6712.namprd12.prod.outlook.com (2603:10b6:a03:44e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.14; Fri, 7 Feb
 2025 11:58:47 +0000
Received: from CH3PEPF00000012.namprd21.prod.outlook.com
 (2603:10b6:610:4c:cafe::a4) by CH2PR10CA0013.outlook.office365.com
 (2603:10b6:610:4c::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.29 via Frontend Transport; Fri,
 7 Feb 2025 11:58:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF00000012.mail.protection.outlook.com (10.167.244.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.2 via Frontend Transport; Fri, 7 Feb 2025 11:58:45 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 7 Feb 2025
 03:58:27 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 7 Feb
 2025 03:58:27 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 7 Feb 2025 03:58:26 -0800
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
Subject: Re: [PATCH 6.6 000/389] 6.6.76-rc2 review
In-Reply-To: <20250206155234.095034647@linuxfoundation.org>
References: <20250206155234.095034647@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <c23083aa-2c79-4e9a-8c30-35f4e2c0451e@rnnvmail203.nvidia.com>
Date: Fri, 7 Feb 2025 03:58:26 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000012:EE_|SJ0PR12MB6712:EE_
X-MS-Office365-Filtering-Correlation-Id: 165d0c45-c582-4db7-fc53-08dd476ec6a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YzRjaWNjeWx0T3hNUGh1V28zaXFTcDR3ZnVHbDVsSjM1OGpucHNMWkpVM3No?=
 =?utf-8?B?KzJoRzNnZ1pBUUR4SnMyOUVZNzBCdDF3QmdOYVhtSGlmZTJKbDVteVdYUEZj?=
 =?utf-8?B?WStWTFY2VWtWWWFpelBScWJwQ2hkRmtkL3RQc3puY0pwLzBjd01wRksyYWJa?=
 =?utf-8?B?eXFWNmh1K0xPQUNFbU55aWc2aWh0Ulh6cEt5UVdVdEwxZ1crcXFNaHYwcENZ?=
 =?utf-8?B?KzFyWmxVZTVTTXg1VWM5SkhlREhwc1N5a1Z2UExqVkdUZDJoSlBwTWdjTVJL?=
 =?utf-8?B?WFlueGRySnJFOWt1SSttcjdpMmF1bWlWakNncGttVmRKdUo4OWREeUN0VDNZ?=
 =?utf-8?B?V1VDb0I3MkIwb0NFdjZ5K3BvakxXVzVNekp5MWV5UFFYNk1XbnBnZ2thdHlV?=
 =?utf-8?B?NXB0cmxXZExIVk1WcXkraHNvbFRPOWdiRDRsYm13bERsMHU1MWVBL05CMG5V?=
 =?utf-8?B?Lzhkc3haNmF1SWNjZGZTT2pINVhzS1ZHcVNVSkFkU3JKTG52T0h2YmZCdEZO?=
 =?utf-8?B?V3lKU1NZU29DYzkwbFQ1ZCtrYWM1QXJPQ2RIS1RtWlFMNHlLQ296T2VQOVpI?=
 =?utf-8?B?bTgvOEtFVWxNQVhjZGtiTWluOFdiWnpNcStMOUxUa0tpUm5reDhoUXpNZngz?=
 =?utf-8?B?QUFINVM2OUpEdjIrSmw2ZTBLbUdZdG84SHM5Qi9NMy9rOEcrUWRsTjRwVnRI?=
 =?utf-8?B?am9OdDVDUG5HYWcwV1RxUll6Mit0RE9mYmJiNEdtVnFtNVI4Q1ExS0IveEM3?=
 =?utf-8?B?YU1VM2VXd2xqcFFCME1PT2I0dm1HRjRwZXlCZnFSOHM0YWowcmNBV0NKUkZm?=
 =?utf-8?B?UG5ZWHhxNndYaDlUTGY1MW5RZXhBOCtPTnF5N0tLbnJ1YTRiT0JHQnVnbndh?=
 =?utf-8?B?NXZLSnUrZGVxck02TEFXbjJyRysxdENsVUs2TVB2dWxTTGlmWmUvRk1yeEps?=
 =?utf-8?B?aDRHMnpLSS8xejdVdkNXL2hHTkZ2SGd6UFJVM280L25KWDVyc2dVcGpCOTRQ?=
 =?utf-8?B?N0t2ZEpaT3JWQ2NORCtZd1RBQ3VTK0lUdVgvZlFRblFUcEIzQkpaN1ZzZ1ho?=
 =?utf-8?B?QU5JekpGUjc3dFY2STlUb015bC9BNFJuamgyeWtmWVJDcEorK2R3d3d0SEEr?=
 =?utf-8?B?UnVqOXRlSUdlYmJHZkdBamE1TGNoTCt4eDAweDcxdERlbGJ3Uzd2YkdlV2tt?=
 =?utf-8?B?SDFISThOcXZxNSt5eS84TEh6SHZtT0hnelZMa3FhdzRORU5uUC9hdmV1V3BP?=
 =?utf-8?B?SlRQT3p4VjVLZzBqZTlKa2Y5UzBxUWx5QmpoTzRETENqM3pYeTdlUkRSSlU5?=
 =?utf-8?B?cXBRekY3L1BGQVhVNStOc3JYMFZGSkp4aVpSYVpmUkhuVUVBY0o2MEtldWFw?=
 =?utf-8?B?VHk5Rzc1QVpzRkh3K3Q0MjVnUUhVVllYVXl4OVl3Z2I2TmFnNU8yZndpVC9k?=
 =?utf-8?B?UDhSZ2kxNnJpS0ppcko2MnVTUENiNVBqUjQ4WHQycFR3bFFZUVZkejlua041?=
 =?utf-8?B?MkpjSkRnd3ppdVBQUjJ5c3A5QTFma1RheVZJTzJ3Tmo5cUoyRkFPTWVJQW9N?=
 =?utf-8?B?NURPOC9XYllBZVg0aHN5QjZnQ0wvTlR0Z053eWhLOEN2K0VaeGpKMjREZ1Jp?=
 =?utf-8?B?K2JyMllHY0R2a200RWJRYUVTaDJEM3pNL3hzQ1prRHpDWlZ0anNkUXFQanZa?=
 =?utf-8?B?YjhHQlVMd0dUcGEyajNOdU5CMmFLU0hralVOU1ZQRExxamh3VTVkN1dqRnc0?=
 =?utf-8?B?Z1BiR3dza0xVb3pEU1BpNUNENm11NDNDZlVhRzRlelNueElSTlZnTXA4UTRu?=
 =?utf-8?B?eTErOC9PZHFUZjhYNGJMUDhoWTAyVkRxQ2ZabTNUeFl3YkdldEdheGhmN2ZG?=
 =?utf-8?B?SkYvRFNIcmhBd2lWa1grdE1aTzgrYTZkK0I1d1FXSUdPa3A3NWVaOElvZ2dH?=
 =?utf-8?B?SVNnZS9sZW9PWWZRd01tdzI5UDJXU0FWNkk2K3VzUEJJekVOcDI1ZUJTQmZl?=
 =?utf-8?Q?6hfeEQmL/9Sqk2zwaPI1DpsDSpnurE=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2025 11:58:45.9566
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 165d0c45-c582-4db7-fc53-08dd476ec6a6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000012.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6712

On Thu, 06 Feb 2025 17:06:18 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.76 release.
> There are 389 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Feb 2025 15:51:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.76-rc2.gz
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

Linux version:	6.6.76-rc2-ge5534ef3ba23
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

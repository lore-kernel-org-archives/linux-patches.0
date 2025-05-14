Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E882379DA
	for <patches@lists.linux.dev>; Wed, 14 May 2025 15:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747236914; cv=fail; b=PWemxPLUSlIoeXeGWvQsWeoD4CRjnGa8S/s5+6Z5s/OnJcFYv+iUFyiKn7M9agUylYZR8a2dS3Pop4/A3f1ljYaLYOa/9zYvrfxiUKegEBwh9KG5IdN/ZgC+tNR3CJ42yLX6hJI3lPe8mUlBHtvDvuViIoIz6lhv1HC4NaeT4Sc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747236914; c=relaxed/simple;
	bh=9FrrW7DnGk+XahtaPZOGfIstvzXcNudQrgM7zaew5l4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=BF/QLU827YCKp46SWaCe7Mp//u3eJPFRaRtOYNynGJNiB7VFs+qhumK6XhkpH+z+l60xwSyxyt6HOvwiScECQ5P2oxw8Wj6EgBK6hfCGxU50OY25seFp3eLMEGKnrv//W0IT730anwTtcm32Gf+ygEtfod1Dp9yjfHGwyE8Yi4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jzJS1j1X; arc=fail smtp.client-ip=40.107.237.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jzJS1j1X"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FxdevZI54FqVNfOnS2ObhR76PLOs56qh6G005Pak5JhnRccFtNzY+S6oyHGis8g0x5EW7QE5AtKFxzXRpwdztL9EmuQqShlvDu6FcggVc3XuUaY1jlr8nQbmZydPUDwQh0DZvFQFPL1LR0l62XkbJi4PKKetLALKAGcZt/G2InoS8T8uQOpF8qRIfWWrv/6WMwiJhmOjdWXPhPc0SIJsYyajshbEAQL7GK0zmEN4KSABt6Z5FT7ZaRzYdoanoRTdj+U6zaUhiIligPe+jNANPo+CUUuvbzihYFDzJoi4+sB6fJ8JzdaoubOduB3fbnG4qFJk9cqJczpCzOU4nJdA2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Voekl9DWjV98tY2ClOTpQjtB7FqhQdDkfjs11eH8B1M=;
 b=bvNQ9IKVE0+GYx94knhh3N2a7yVHB28Tdcm+6d079EiVsNqY4fPUKy+c6G4jQKuBnGab81gLFgzVTBWar6J3G/49PV86uCjm+0y7RPhM4Z488rWmpESr+kSona0cy5wbt9V+EhTKx4kPrCj4XuIjXOrfUODGvOVr9CuUmY5gZ7Qhl0+RHZRaWTeWUck6wFWKNBc6QhN/VDDeR9BY5L1mG5Hym4K51N41WQRutgsy3rHjc0uEdyu/Z15kFARiM1L2AFaMrJA5q9zsQ9VEioFuwTSTiksKosopjCktiQ3hwAalSmZkVkLvVx1a8xhOUPg3urKZ1LMqWxxWhHIBITkesg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Voekl9DWjV98tY2ClOTpQjtB7FqhQdDkfjs11eH8B1M=;
 b=jzJS1j1XgGsGu/NFGi4AzonYuQXdDHM6KZx7MGhypfU5Oeeyybr+JG6ybZZp6LuqvaBiqhue7B4iLC3MDljW+GsUFRtny0BPkqB0Ze9JVGjGGk+78eX3SoHKDLWHceiWhsaFt+5nQQ2zUt/+LvJPEko1aP0OYWqG5DTFHHQc9ub0kve06i+c/RL/6wSm5AEdJ4Yo9D+DDr401MBZLjCj8KyGQlQt1c27bmg6eh98izEZ5lkR7M28sPz/DhygmBU3nR87Ft6JeOTJVTt4DyxfOFZAdGN6zJgBMWzynA6SlFRtm4MJqZaVXS//JuWDycB37AdBfQ/s84vCbLR1opqb+A==
Received: from CH5PR02CA0005.namprd02.prod.outlook.com (2603:10b6:610:1ed::7)
 by BL1PR12MB5705.namprd12.prod.outlook.com (2603:10b6:208:384::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 15:35:08 +0000
Received: from CH2PEPF00000141.namprd02.prod.outlook.com
 (2603:10b6:610:1ed:cafe::d1) by CH5PR02CA0005.outlook.office365.com
 (2603:10b6:610:1ed::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.16 via Frontend Transport; Wed,
 14 May 2025 15:35:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF00000141.mail.protection.outlook.com (10.167.244.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 15:35:08 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 14 May
 2025 08:34:53 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 14 May
 2025 08:34:53 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 14 May 2025 08:34:52 -0700
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
Subject: Re: [PATCH 6.1 00/96] 6.1.139-rc2 review
In-Reply-To: <20250514125614.705014741@linuxfoundation.org>
References: <20250514125614.705014741@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <daf309a1-ea1e-4123-a6a1-6c75492815d9@rnnvmail202.nvidia.com>
Date: Wed, 14 May 2025 08:34:52 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000141:EE_|BL1PR12MB5705:EE_
X-MS-Office365-Filtering-Correlation-Id: e6202c3a-6238-4b40-0eab-08dd92fce88b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M051UjN5NHYrVXZoRk5JOTVwYXBPN2JNVU8rWlh2SHFiUEhiaC9DNkV3cEY1?=
 =?utf-8?B?MFJzeERKNWI4MmkwTXZuSTBUMVNxVXgrV2o5cGNKanZVWHRReGdHajRqMk9F?=
 =?utf-8?B?UjZZYmN3QUtiMHVJMzd6SGcyd0VRcWZPOEFZWG5idnkrWmkrMVlKN1I4Q1p2?=
 =?utf-8?B?N2o3RW5SSTh2S1pwQit1QjZVNjd1Y3VsYWUzZnJmR1VzVW9RSEQ2cURkbGI2?=
 =?utf-8?B?bTJkTFlVV2NCVlJ3eUlYQngwWEtLckdTYkV5REt0ZUUvR1ZjdUdzZUx0K3pZ?=
 =?utf-8?B?WDV2a1FlZnFtVVFlYjVLYTl4OEJmWXFZZHQ3cUJVTzR0RU9RRTMwOE5XWCs4?=
 =?utf-8?B?Z3ZueC9xN0twSjNNM1pGSXluTnNjNk4yanAwTXR5RkgxZGNMNlhudWlKeHlY?=
 =?utf-8?B?aWJxOVpFWHhEYSsvVWxRN2V5b1ZKbStWbXFLVXVWODhiTCtYUy90U0FORGxK?=
 =?utf-8?B?d0Vud05iZmdCT2J3SDdDNThYbC9oTis2OER6MlJlcGFWczloQS9mVEV3b1Jr?=
 =?utf-8?B?Y2xmZURDOGdwK2J2M0VrODBqc0p4WFFKQU03NTZhYnhlbTU1T240NytJbXJu?=
 =?utf-8?B?cnlubE1oU29mWnNJcDUyNnUwVG1XWEdmTllDeUxSc0NPSGlqMGM2L255OTA0?=
 =?utf-8?B?U1pGRjRKUzB5algrSGxRQ0lEMnltMUpyNHZ1K3RMM2FpdERJblVVVXVLUFJU?=
 =?utf-8?B?UXdITi9pdlhmbmxSSDJtREFhcVJEU01raWRIT3d6d0RVYzk2WHhMUHZ5U3dq?=
 =?utf-8?B?QjA3Qk9KSXg5YnZCLzFwTUtFMmVLOGJHUEp5TkpjSzVkWFhQT21ReWNWaXpF?=
 =?utf-8?B?bTZxa3pEa1BEcW5OZENpQmd4dWtJcnllakFCM3h3QTFPTUg4TmZtYmlsU2Fo?=
 =?utf-8?B?Tm1PS0lTZndTeldLTmZBeHR5MEoyNUk2Q05SdXR3dkdEeEtiTDlmNE1wTmhJ?=
 =?utf-8?B?Q3l2bmlmQzRJaXlodzRSMUhzN2U5YmxpZkMraWtyNHFjOTNmdHVqcm1hb0Rz?=
 =?utf-8?B?Q2VpdU5CSWtZS2l6dCt1amhLeEYyVEJUZXd1QUE1OXl0RXZRckZXU0kybzNB?=
 =?utf-8?B?THlrSElxbTl4Ukl2TWlIWEE1R1paNVc2Y0dxa3piYUV6VE1RSytwK21hUWRK?=
 =?utf-8?B?c0R5TWxJYk5PanRzZEk5WkRMczZDQ3Y5S0k0YXRLTWk2eUVWbGsrV1BRb0Fy?=
 =?utf-8?B?aG5YSXNhNGxKZnRoMUtsTXF6bU1EcDREUmpkdGJOdVlZQTBESVVzazI3Q2Vk?=
 =?utf-8?B?V0orUG0yRHh2blM4cDZjUFprWVlvdWVWS0dTMHkvWUtwZndBUEgybHd2c1k4?=
 =?utf-8?B?cXNxM0xwckhJQkxrUWVoT1IzV2hhazdOY0dhTGhhTG1ETjlWMzNweU56N3Ji?=
 =?utf-8?B?WitNdXl4RG5OM1BSU0IxNUUrQURsR0M3VHdpTnJ1ZUZ1ekxyMHJVRFpnaEww?=
 =?utf-8?B?U2NDcm1mL2pLcFBGOVR2TDUzanEzVzRNYkY4YXRxL0N3aWR1SmJhSWFlemUz?=
 =?utf-8?B?Z1c3KzBQalN1Z0U4Q1J0MDliUCtrVE5iS0hIZzVEdnlOQUZ3MHRaNXlIaTND?=
 =?utf-8?B?ZDdNWGVFeU5PUEs4TUpVTlB4ejFOUnhBZjZ5MnYzZ3B4SmNhMEVCUFdZcFhu?=
 =?utf-8?B?UXM5dksrZWkyRk1sbVR5WlRKalE0Y3JxQ2QrUE1tdFJDS1RmMUQvUkw0QkMx?=
 =?utf-8?B?VEtseG4rTjVyRDRIV2NoQWhNNVZqN3l0cTZYWDBiazlhdEZlK21NSWRKUWky?=
 =?utf-8?B?V3dKWlBaQVo5NjhTWC9WNno5VytJaWN0NWYwcitCaHFDUWEzS08xRFV2SEhY?=
 =?utf-8?B?ckdxeTBqQXNxZ0tVeXUrV2xFcHd0YUJwMWRHK0RGYlkyUkd3dXlwTXQ0Ukwx?=
 =?utf-8?B?WnJoNFFDMjVkMzZOTldCUzZ1V3YyZUE4TFZkandEOFVsV2pqbXRKS2ltMXNz?=
 =?utf-8?B?MXJNOHlGbGRSbXRpT1pTOGp1WWZhOGdQWTZLcWhsclBLMThFZjF4czk0UEsw?=
 =?utf-8?B?RTZUcHBkNlhOMzVDK3N2Qmw5RER4RTA5TVAzZjZPaFdMUStYVGNXcTZFc3hj?=
 =?utf-8?B?dWlzWlBSVGxMUmZQZ2tja3djQllDOUEwdG5udz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 15:35:08.5733
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e6202c3a-6238-4b40-0eab-08dd92fce88b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000141.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5705

On Wed, 14 May 2025 15:03:45 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.139 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.139-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    115 tests:	115 pass, 0 fail

Linux version:	6.1.139-rc2-g03bf4e168bff
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6B174BE1
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 07:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721806552; cv=fail; b=ql+xpKjka8Nw01ljYzsRE/jMEXgQymr3YHQ3cBO951swBZHqNaGM75FbxuZ7SGKJhfPL2mIRV0ZAE2wNtORyA0bshoznuSIQXUaMCr0IThXqLgomAwzEp+JVu0LPR5utcjc6SA3VZ/EXkjoVmtAL5njKATA4xyc4khbaQP5kk9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721806552; c=relaxed/simple;
	bh=h6YY+EjL1no+tziMYXWiw7PpYfqvG6Yi0zKLvxZyN5U=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=kdqBB2CuN4q/BJgqGiU6saOIKST/WrHnZqgBYnzkaxyxOzOKmI+EEJpJ+4UEFNQuG9Czbn0At4X8fGJb0QQEfqDOQqYBsVMojG5NsrnmFBIc2xCzDjlcuQKPCTeZsS4i2eFu2PdpNu7/qwsRiQHTvVsyrF2b2quuAolEZLaqlZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FuGNfPrI; arc=fail smtp.client-ip=40.107.243.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FuGNfPrI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eqVJHnSeMtZUkWa7K3k2Hywfq+2nG7JaSV/38MDmKqL29y9wVgWsjV5N6ZGLKiTAIc5oWkzo7/yh9U9JiVJaN49a1VU3JwMco2ObDL31uxfLlYQfpgLQsixoAu9+esbySOL76AtAwATdam7oQmTae0PjP4Qi7via4bOD347fT4rh/ziw2G+bUbZXjdIjaQ/rD197WvDTNCUTZJxBoYYqTn0iJkfFx6s2esJH2wq2SSGwcZuALYq2Oo1XkR+ErzKiRcOpkCRI8ow7vRc8qv36UA5PHw4d+sIGrDCkoB448zyxxVmj65MahgAA3dsXEMIRYHlcbBCqrwz84KUXh3yEsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7G6sZLjMtJ1YC3wTHNG2OOyBNL120i+QzjUHctEoEMs=;
 b=aZ71Q8v5uwwUbmlk6OxDM3cDyzyGspnn1Yp4e2Y+qscnM4OofcgBKTD/zGqs52+srN1EPEBzcel87TH6Qq+srosyZMACFk+/VDK++n7Zv1BKHkZuuBRi83ezId/0RZJnaexD/RFTpGYOgQqEQUFq724eqNDVC89Ay8KR2YMs5KVne4oc3MJAIK4F3JHlmZ0p285cW6xUh+dhFxe38wE9u3zZRgni2/0SQHNqCjHU6WuXXPezOWoOYIydHfECzd1/MbQi2uAQu5zK2+E8vY7RNjh0afTrma0q+rnKPqYyoccC4j4bD7IDKhsafgiK2EzRYCRQOCDiWoRjqqdkJk12yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7G6sZLjMtJ1YC3wTHNG2OOyBNL120i+QzjUHctEoEMs=;
 b=FuGNfPrIsD9ZsWbrpDM3O8tIT724FK6VzQ6I2+6MvZ6gvzy5uXTdSz25bxTgmylQIz0VTNGN5GvayLgFV6VLcy/jzcoKAE8xERaBtlFPom6ivzvMx+zaIxUMWZ99rdhNkf2xp/FnaHvshktovYdKPPQFgkHUY0hmI9v14ZUL04VQy8tLJ9GIN9Rm/UJSxfHp2OZIeyOhJKoVkSIeLa3FnvRX8U5lL1gR0cmNtOowp+oGe881d833F8+m5W9qBjGh7ImHxfleCtubd9yeomAUZLhcAGtTbR2RhhVXWV01bjJNKAUHg2nBda+lhSL7KSCOiMjKtrDVSOGApp6gG2iCxQ==
Received: from BL1PR13CA0320.namprd13.prod.outlook.com (2603:10b6:208:2c1::25)
 by MW6PR12MB8758.namprd12.prod.outlook.com (2603:10b6:303:23d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17; Wed, 24 Jul
 2024 07:35:46 +0000
Received: from BL6PEPF0001AB4F.namprd04.prod.outlook.com
 (2603:10b6:208:2c1:cafe::b1) by BL1PR13CA0320.outlook.office365.com
 (2603:10b6:208:2c1::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20 via Frontend
 Transport; Wed, 24 Jul 2024 07:35:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF0001AB4F.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.11 via Frontend Transport; Wed, 24 Jul 2024 07:35:45 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 24 Jul
 2024 00:35:36 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 24 Jul 2024 00:35:36 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 24 Jul 2024 00:35:36 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <allen.lkml@gmail.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.6 000/129] 6.6.42-rc1 review
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e25f43cf-148a-4d0b-a503-54f66381a8c8@drhqmail202.nvidia.com>
Date: Wed, 24 Jul 2024 00:35:36 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4F:EE_|MW6PR12MB8758:EE_
X-MS-Office365-Filtering-Correlation-Id: 58f9f4c9-dc7a-42aa-7764-08dcabb33ad4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YmNWZ1l6aXQ1KzI0TjJ1YnZ6R3F3QkZtc1BJTnozSVF2QXFTS25aM3RKRmVK?=
 =?utf-8?B?Ly9IdjBiR1ZTVmVDc0M4VnNZem9vZEtEK2lJaTJzcUZUQlRpUDl0OVVVMjRQ?=
 =?utf-8?B?WGF2anpPdkZ6ZW4wRVFjMTdsTjlwbVFuTzJWc1QwWW42THFWQWloSTAwZWZz?=
 =?utf-8?B?WVRQc0xjUXFweHdEd0xGdjF2bGtFSUFkL3dua2tiTEdDQVAxSUNPalNpajlx?=
 =?utf-8?B?UzlleFNHZzB3SlNobGFmVUkraW9ESGdiaThabncwZlYrUGRHMlU5bUpPcDV6?=
 =?utf-8?B?TXEwS050enJKcFpheXJ5M2xyQlBWUXZkZHN4bDc3V3I1aFJNUFpJUVlHRldw?=
 =?utf-8?B?cHRYOTJweVRLZ04zbEZjOGhQaTZscDJzNTBJTENvZktmRlk1UktWamtvL3cr?=
 =?utf-8?B?NXJXemN5YVZGSHhhQWtacGZBMm5rQldlbWQ1UzQ2VmowdkhMWGppa3VycmlF?=
 =?utf-8?B?T01MK3dNdHBPaDRDWUhSWFVxajNaWCtaQkk5UEdoUUFRUzZlakFMSFUvNExz?=
 =?utf-8?B?S0syY0paNUpuK1BTZEQvY1I5M1BraFhjblczKzFUdThOTlRIQWxTdGRQVnZl?=
 =?utf-8?B?N2ZIdmNqakZEQktNUnkzQlh3RStIQWdMTVBFU01OR1Zybk0wNHJuSGJpaHh5?=
 =?utf-8?B?WVZpakpJU29tcUZTWnJBbFJhblhITE1salhPL1lDK3Q3MndJQitCL0hqMHg5?=
 =?utf-8?B?eXNZNk15K2U2RW1lWUJCUTVydi9Nc0I5OXpsQnM2OXYzbUhJRmlONHVUN0xX?=
 =?utf-8?B?L3N4blpjNExWYUdUWElpaDdubG5lVCtwcVFwZDRMNTRCbkdaN3g4U2MxT29l?=
 =?utf-8?B?SnJyTDJjWmJ6MHAxTWpwNjV1TEFwTWhUdnpuQ2VGVGxWajNXM1JMV3pUcUhy?=
 =?utf-8?B?aUdHM0ZXZ0R5cTNTY21La0VNVEQvaUdXM2QvMERiTGovUmt5b245Y3NUV3BE?=
 =?utf-8?B?bDU3YlpMQVJkODFKdDlHNm1Td3NWSmw5SFJsenhoL3hRNlFLWE1YTi9BZmlE?=
 =?utf-8?B?VFFqbkZRZndVVjBna1NSdGZWcW5iRmtjVmpnL1FvUXJ6TjhoVWpETDRZMFlE?=
 =?utf-8?B?ajFXU2wzNGZTRmJOd3RVNE0wSWxCWVU3alhpVTFnNWowMG5ZZHZuRGhZQWNB?=
 =?utf-8?B?NHpRNUowcWZBWjZhM2M1TGczdVpNMDV0dk1sT3d4MktCREpVdEEza29SRTdx?=
 =?utf-8?B?NktyQ1cvRElGdHR5UUhPYU9RNGRwT2djMFVPSythOWlUZUswakpFajZJRW1x?=
 =?utf-8?B?VkdLR214dzVKSEZOcHQvblpjaTNGbkdmclBndlFPanJKakRWZ0xLbXdFVG45?=
 =?utf-8?B?Q2RaNE5NR2RSS0lOWGlXeERHYzRVcGw2YTU0blZDLy9PeldwYS9kWDN2STI1?=
 =?utf-8?B?NnhyZERVaEFFWnVlM1I2SHhEaVkrVEp1RzYzcC9RSlE1eFBySEJGMjJHUnh2?=
 =?utf-8?B?aC92ZStZZVRIbDl4SkxHNFBObkNPRUZQK3B2TXJpcFFsQk5GREFyK2kyblNl?=
 =?utf-8?B?OWIwTkswdXlaSEhlbjkwT3lLYXVOTi9ZK0UzZGxPd0Zna29jN3AzdmNScU9G?=
 =?utf-8?B?WFYrZHhzcTJXbmk3N2Z6KzhwSzFTelowVS83dk5WMndTQUNXcGJIVnp6VFRV?=
 =?utf-8?B?SEoxQkt3MzB5V2h6cGhwN1d2MEgxMll6MytYYktsZ05pYU12Z0dqVkVuU0dB?=
 =?utf-8?B?S2VzRXA5TG1zYkVSQjRDVXBLTkRwbGU4dEYwWkxKUDZ6dlZib3YrOHh5clFH?=
 =?utf-8?B?NVV6bUU1RWgybVNHNTFYeWg3SFZtelpyM1JqYTJPQ3hoR25wZTdLTG5JcWFs?=
 =?utf-8?B?UktreDlpQm5VWGQ1c0JUbmpUYnN4TDFlN0hXNGV2K1R3WGVra0QwZ2VkdW5h?=
 =?utf-8?B?WDVjYkJBMktDUGwyL1R2RE9Cd3RjVWl3MUg4aUV4aVVHVHNNSTdib2plRUsy?=
 =?utf-8?Q?5NAVvce7zmARyln1p4s6/EKsgRwYITBH?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2024 07:35:45.2391
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58f9f4c9-dc7a-42aa-7764-08dcabb33ad4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8758

On Tue, 23 Jul 2024 20:22:28 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.42 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jul 2024 18:03:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.42-rc1.gz
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

Linux version:	6.6.42-rc1-gc74fd6c58fb1
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

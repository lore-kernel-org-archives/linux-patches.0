Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C38E12FB3B
	for <patches@lists.linux.dev>; Thu, 18 Jul 2024 09:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721296354; cv=fail; b=QtuW9GA0jSYOyd9RYkHEUTlqUQ8OyZJgmncK4ubj6FKy1Xlp0kmWHhwd7gk2U3rR6qrHlONRQh+7tIYD+x+Yg9ofZaoT6BpWm7HdGnjojDAK1yhlLVcKbkUzbA0b2LD6YXNwotSgcny4LwPqfbvJ9iwNiYoDPG3SxRvBYFD1xmk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721296354; c=relaxed/simple;
	bh=uj+8m4bOajN3V0VTvmM8TygQoegGfJq9OtGu+x5FP1s=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Y5wJH/8S10uR6KbswYtSQzg2aYu19B7OmSkkm5gT13kj7bAAZdbyWQkWX80s0Dmk3HIWphG17jCE5ZGh1uzjfvG+08mKNllob43PAWyqfjQ3ppTx4x1Tl+A8hdGo9PLznqirdM22NORvRuLlhlkOm0m7z6CKfQ6nCut2pVu8rAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IOZcclxX; arc=fail smtp.client-ip=40.107.93.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IOZcclxX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E76KahrMr2GDaONRZeip4NehICls/PzXcPKyUPQwDRFNRHixKo9juFT+c49gSeJjBVLxvf/4TD8zT2ui4t5DmYEgx2iq2ul2qF661F+HRmgIUwT5r9OuT5lXHvCEOi/B3pxfA7RLURoGQjsRaAqawNdFPDsoq3X03SYGyTaEuQrLT4Pgf7cANVO/WQsKQoqiploY5z/Qt1Sy1JWXxV74yjBKO6wh425SyHy0uvVy8LEGACdOeeKOY4cJGs6Pvlj0VvXdIjfQXsFJrfbO/yjZWWDtxI57NUlnr2Uep2LPHeu7xVGcjod0CSvDwiHZSVMI4+GtBcJ46/FRpsP7M/8mGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1AIKkiTQJtxn770zjwY1Th2biWIRxQ98ztbfwymlUUw=;
 b=dAc6UJPnQjgRa6DYkskpTIZbsqEwVJpl2v2W15kkR4XhFH6BZdUeZf99XmRsj3oKpZA00axqKsdHH9Ly7D6L0YR61kCf6lJ/ZKWLWLFSExzdjxwroVgCIW92Km2kUUWs5Lq0lrpaDlJ1ODTw/avEYXgZQz+e1NXKLevygE4AORPIdvfMWc+m27QB9gU0GaNDDLarARQ0Ntc8uw2T03E5mIzrzcVjjTKdHQ7oIQ/GS8UHPnWt9EwBgDMAup6x9TVDYk//ewcVpXCqVzhLB0kkL9U7Bk9HThhZc4tZ0XGjWXIMeOy7B2wEqinFyZCECRqEIlUXCY2RG8dvXKL3vSQSug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1AIKkiTQJtxn770zjwY1Th2biWIRxQ98ztbfwymlUUw=;
 b=IOZcclxXCXmIJTeWsaRud9ldzZD0nuV3t7WRSTi0yRlSsk1lpMfTEDA3ElnGmmnDyOSBkfsj/8RiTCSAefcNVZoBLliJ+XNVjAIcfkDOv6qaqyesSNjoU9Q9c/8btxo8Klw72emyTdOfOluZJDfu8x598jSVWVLcZY2UDdz3/I8i5ImQK3uokzdldmxu3HHG2XWn3axGTZ3Y0Wtzwm0FJQjmQ9IK51iRBHuncmIaH1qpkdeY8zEKaAfUbPMC0cd1ExUMLygIl0qHibnHKMRmTtc2kJUT57NfwXVLDskVOtKyJnqDGTIzkCZ42pU9Dj/amkwRNmMKOORZPBKWOscl5Q==
Received: from PH7PR17CA0065.namprd17.prod.outlook.com (2603:10b6:510:325::9)
 by SA1PR12MB8119.namprd12.prod.outlook.com (2603:10b6:806:337::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.19; Thu, 18 Jul
 2024 09:52:28 +0000
Received: from CY4PEPF0000FCC0.namprd03.prod.outlook.com
 (2603:10b6:510:325:cafe::49) by PH7PR17CA0065.outlook.office365.com
 (2603:10b6:510:325::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17 via Frontend
 Transport; Thu, 18 Jul 2024 09:52:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000FCC0.mail.protection.outlook.com (10.167.242.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.11 via Frontend Transport; Thu, 18 Jul 2024 09:52:27 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 18 Jul
 2024 02:52:19 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 18 Jul 2024 02:52:18 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 18 Jul 2024 02:52:18 -0700
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
Subject: Re: [PATCH 6.9 000/142] 6.9.10-rc2 review
In-Reply-To: <20240717063806.741977243@linuxfoundation.org>
References: <20240717063806.741977243@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <01cb32eb-86e4-499b-8e56-5e1585918102@drhqmail201.nvidia.com>
Date: Thu, 18 Jul 2024 02:52:18 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC0:EE_|SA1PR12MB8119:EE_
X-MS-Office365-Filtering-Correlation-Id: 87ac507c-773c-41a5-f3c4-08dca70f5552
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Y1Z2Nnp4bTMwTDllMHZTWjBCNXN5THFES0pkVVh1NmJNMFZMNkw2eVRBbEFI?=
 =?utf-8?B?UDVBQ0RkdEZ1eHM5bWhUV0ZDWHAvazB1TzZHNDlBS1FENTE4U3EyLzNrclpk?=
 =?utf-8?B?M2cwc1FwNjZzVzRPZ1pJVFF6UVhKcEI1WmY5OU1Jdlh4eVdZY09idVhLVkI0?=
 =?utf-8?B?dU5MbTBNUEdMQzRmSWJjNGJCL2Q3am8vaXF4QnV6eXlzelhYVGMvdjRFS1M4?=
 =?utf-8?B?QWxaUUJjOUV5c0ZCOGRUMFRJTkc2dEkxaUU1aG9SYjJ0czMvNHlJZmQ4a0FU?=
 =?utf-8?B?bkFNQU0vOEx4Um4rcnpBL0M2ai9BZzFaUXQ3RDY3L21COS90K3NGbWpXRlJD?=
 =?utf-8?B?NmM5WGV0c2pPL2VacmhmaE9ORUhZRG1vNU05d0NDczd4QzkzSUoxK0RVSktC?=
 =?utf-8?B?WHFQd3ZTU3BNbjhZT0FLa3lCQ3VicmNqdWw5cjVKVXZTejNlSVRCRUJZK3gw?=
 =?utf-8?B?VDZ5dmlhZDcya01oQnNqZ21jUlVhSXdqNTd5RTY0aGJFamx4MFdDaC9GTnNZ?=
 =?utf-8?B?NW1iOU8reEZpMU1jTXZkVG5xNzNPZDFSVzMxNE9YQk5zMjJ0UGUwTFh4eXNG?=
 =?utf-8?B?b1crWGhJeHRMR1ZQVFB5M3ZSU3dEMS9HN3BLMW8zYWJWWE4yN2pTcE9paHdp?=
 =?utf-8?B?eW8vcCsxU2dCV0dWcnRvVVVMVDRrMXRNc0YzeWdhUWlGTmJCLzIyMUZpdGlN?=
 =?utf-8?B?VVVGQmhpb0sxTUhMLzhpV1AvdXpoNDc0dnNQdEpKZVlsUjVydFlaeTUveXAy?=
 =?utf-8?B?QUtrN2p2THlCdEVTQzluU0s2ekxmMWJpcHN6RjIyeExDcWpEVW5maTRPRkU0?=
 =?utf-8?B?d3pWbjNLS3A5OXhnSHduZXVxMHVWZVI4bnM0RGxoRnNUZkpPaXQ5MGdyQlNa?=
 =?utf-8?B?VklSdmVSREV1YjFWeGtwbjNnbUJrVDdMenMzays4ekt4azQzRVhsU1UrM0Fi?=
 =?utf-8?B?cjl2S0RTbTMvbys0S1ZrNzFOTU82TEpZditwa2pVdk8xMFp2R2xENktsTHdR?=
 =?utf-8?B?NUtiM0Q4QUk5VFBaZ2RpZWhuT2VBSGhPVGZ3WUZkTkZZUmxiT2JEbGR3MmVV?=
 =?utf-8?B?TFEzSDVIc2dnUWNKS2lXSndHekkvTkxqRzk2SThERERnSEdsL1pvQ01pQzEx?=
 =?utf-8?B?NFJ5cTZOSG56K0ViaUJvamZRaWZCcGFhajNYejczTDJHSmxmeXNMa2NZaTJ3?=
 =?utf-8?B?YWUxdTRneExpS3hTZFRxMVNnUTNWRFB6M2gzRjh4UDd4OWxBbVdQV09jaStv?=
 =?utf-8?B?V3FBOUEvMHk2R0xnS0xxZUlBTVBXQjNMZ0lqRThuUWk5aVBnVDM5dmsrZXpL?=
 =?utf-8?B?Yllzdk94NGRyTGFVUFFsSUZjSEh2dll1WU9UVkM0WFNJMW5wQWRQUEFqZytJ?=
 =?utf-8?B?b3Zib3ZZbjIxaWtIMVlqK1R4WmRYRFpEQTByTGRhaGZmWDQxMmg0MFBQdWg5?=
 =?utf-8?B?Q1hleFd5UTRJSUF6c3pJQzFkUjU2ampVb3FSSXZhMkhBTnNvbXlhNW0vT3Jo?=
 =?utf-8?B?OHRWZVZiQVRhbC9iaUFsUld5dStSTmhUY0d5NHV0QVdXMTk0cDI1RXhEaWpB?=
 =?utf-8?B?bkxJRUJFK00zMkdMU3RkS3FOckIrMC8zcm41L2gwUmEwQVg2bUVuSFpmVW5o?=
 =?utf-8?B?Mm5hM09Ea2IxU0Y3UlVZTFJadkJaV0pLL1U4dGNVR3NqY2ljcWhhbTZPZEQy?=
 =?utf-8?B?SjZjMllsSFVMcVp0Q3VzSDJlVE1pamRhOUNDN3licGhmL2I5cVYyTVQ3bXZj?=
 =?utf-8?B?anlXaW95WTRvbGIxcHhGQ0tSL3NUWko1NFFwODdmTStFT0ZvaEh3OVcwMGtL?=
 =?utf-8?B?VVU3MXFWdnd4VHNvN0JhQ204eldTVUFBT3l6TXdjVllod3hBVkhsMlVacXRp?=
 =?utf-8?B?VW1xSXpPSlVkTEc3TmlUVjZWdXRhMXpRZkZRYWNZMUx4a0xnQlNHYWl0aEx0?=
 =?utf-8?Q?1HS8vGFkiWzWkxFS2z8RiQ4K+XKZzXpc?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 09:52:27.6521
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87ac507c-773c-41a5-f3c4-08dca70f5552
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8119

On Wed, 17 Jul 2024 08:40:00 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.10 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.10-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.9:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.9.10-rc2-g61dff5687633
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

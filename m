Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1939019FA6A
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 17:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718384660; cv=fail; b=G/sTsDKS35RcoJ43tWxOqYi2uKDMKFMLvgZEPGTtfBMQ4eQfuGPhBawkgm9F8E2BdoM9+nBxBKhnyvfTdfHb/3WAOP00h6dwdN7W7nDCXE6IrXFxrJz70DGscRMXjXNtw6ijn3glJTFCibN8J9GLFZ6rHAArZycTCu8C/5DIyiw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718384660; c=relaxed/simple;
	bh=Y3Ofl+DX8ETExQHKhazFG3/Jj3CfGkuSpHNhrUyESjY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=jgAOZPLnP23J+MHmsY5l/tamE+qdkITNEW7+r0m4fl6FExepgNuUibN6c8OEigpQT3nvcYaeUFvM3aFKt+7mp50Yok/XBouqYz2axXguCC174yPXbz96ciXlei6VgdzRkHvJnC0Wn8IadBN7Js/PksMb2gDZmHM5LKwcLfpySZo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SycVjG1a; arc=fail smtp.client-ip=40.107.94.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SycVjG1a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JXk771GUUYjxRsrLdadCNNmBtF4jXJCr8H50iIw+LnD+j7rKAZ81vvM6+PS1qrolwkEAn+G4zF6Y4vJOYtTLYA0rHRAYAG5kV62WsWITW/GqEmIJGsrGX0F7PDrPQ3PC2UKiKyiBt4XEss9bg1NYN4GLCNONU2WB/0xy/ncNtmKYlqeV6To2ECbVRN8uzZWVlLm2QuLYZl1dlR0RzHAKcm/Q8dBbSlqSlRCzbCpzE8JZiokHFKLEpdBHOIaJiHPuwA7wCN5rjYzeZ6uh3cDIU2FlmiI73IXoEe/HexZoQDzEmvkRlMGhxuFod392vrrnvUWVZbFTdrLByZaOsSIIkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XDRkggbZgyT/kaqDOXaAd8QCYJh8udFZRUj2yGTtt0M=;
 b=BJ+GF1mV38wdmpbzGACSIFvyCFB5hsT4cojOhk5xCsLd7I6/AmLT/sOg9XjO9dfhJG1D3CYjFOzaXhFqSkb55EPO9R615WkVIF/Nn6Hmog9l1mq5C3znwE7kTlzUYsqBMGfnbm13cI/MyKqEB3B9ddYUPs+VgXuihauDPKjKKmWy+UHYeFeWntW6iwOAl3t8MW32ygIoZ1YCXl3xjPaiqgyY7nErw02wKhv//V0grUidBF72xUltT9OSFzpShlZ6t8g+9OT6EI7rC+DcGFO+3q5iwLGenl5c1JssEMXGU3iwhLkyeeytDh0HlIx+qtT14RBGdEDiXRVJDTav02GuyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XDRkggbZgyT/kaqDOXaAd8QCYJh8udFZRUj2yGTtt0M=;
 b=SycVjG1a5I8JJ0YtECfZJOrWHL2ygXiE0gP4diDxUEO9go5dcbd93E2TpDyDIMIRDZkDLSjZa6c0LyuSZmCReaag1QxFm97wWS1FBqwbNq5oa77NmWjWBWV6ablKeTclJaetF1kvQiTG+KD3RfsMX1B3EUvu3Xprg7gK2MS5sVgSJVLqm5ADkuWV4mCA3VEHbb2e/uNjSmDJFA9C1i1sBJo9bfrdKJRjEmwr/A8UsEc0bC+SXYSo35ugK1c0UIeWCkWeGtYdRl33mENL/7Ym/14cJe0ECQwgv1Dw9z7zor47bVHz9TL/QutDqW3ZSdNmx4GD86FBZgVpM4xLJLKhxw==
Received: from MN2PR05CA0041.namprd05.prod.outlook.com (2603:10b6:208:236::10)
 by DS0PR12MB6536.namprd12.prod.outlook.com (2603:10b6:8:d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Fri, 14 Jun
 2024 17:04:14 +0000
Received: from BL6PEPF00020E62.namprd04.prod.outlook.com
 (2603:10b6:208:236:cafe::f8) by MN2PR05CA0041.outlook.office365.com
 (2603:10b6:208:236::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.25 via Frontend
 Transport; Fri, 14 Jun 2024 17:04:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF00020E62.mail.protection.outlook.com (10.167.249.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Fri, 14 Jun 2024 17:04:14 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 14 Jun
 2024 10:04:02 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 14 Jun 2024 10:04:02 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 14 Jun 2024 10:04:02 -0700
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
Subject: Re: [PATCH 6.9 000/157] 6.9.5-rc1 review
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f14a64dd-1e6a-412e-be91-cb9827187633@drhqmail203.nvidia.com>
Date: Fri, 14 Jun 2024 10:04:02 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E62:EE_|DS0PR12MB6536:EE_
X-MS-Office365-Filtering-Correlation-Id: 28d800a2-c285-4412-de5d-08dc8c9404fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|1800799021|82310400023|36860700010|7416011|376011;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SW0xUUI4K2lSYzNLbkVPM3BXdFhpdlk0eVY5RU5MajAxd3Y1NlYxTWlscG5E?=
 =?utf-8?B?VTdMbkpSZkdTNHM2QllyMG9Ub0Z0cm9XeGxWditsaXVIcUh1dm0vNUNBOVZW?=
 =?utf-8?B?SmRrYUFnMTB5Ky9CSUlLbjR3TUp1cVBjTm80ZUFYSGJueUU1Qjg2c28ya1FX?=
 =?utf-8?B?aXE3VlFhcmVORzNTUlpMWTNVTlBWb0hFMXFpNk54bjA5TjFjdzNkNW8yN3Fx?=
 =?utf-8?B?UFRKUCt5ei82UVlxOVlkcTNxRTNNejN6bERLVTZ2a0tpQlU0RS9GQXlKc2k2?=
 =?utf-8?B?MnRCQ1hrdHpMQjlITUpGRWRUazJ6MXBtT3pYMFpERlAyc2dNNDI3c3Q3eFl4?=
 =?utf-8?B?V2FuMzNya1hGQ0Y3OUNEUlNxRDFHamxTUE55aUxVbHZ1eklweWFPQnN4RjZy?=
 =?utf-8?B?RFY1OFNyNWxYSm10bTQxL25lOWlSd291NGc2ZUFNNXhQOU1HUjlHdWFWRVJl?=
 =?utf-8?B?R3dUcFJPejlQMjRBWXNjZ1c0OWhCMzFhbWVSQmYweGNDWWFteWxNaGhOelNJ?=
 =?utf-8?B?QzJiRnUyaDY5VVJLZ2ZEeEtnbytwYXZnTFpRU2dMcEJGNW5lRUxneGtLQ1U2?=
 =?utf-8?B?ang0S256dGdzRVRReU5yN29mRkhDczhBZUFwVFErZkhFWXJ2M2lnanJRNTlM?=
 =?utf-8?B?RTBRWlVGa1kwRlNlQ3FWZVY0dy8vL2ptWk1TT2ZtTE4vQldIaGt5dEltV3Zl?=
 =?utf-8?B?UXRkaWtlZVFwb2xZQTVtWC9OTDJVR2Fob1VaOFZob3YzVnZsenZCVDQ3VTBZ?=
 =?utf-8?B?QncwQ2VaVnZpQkpuTTZKeDhUM3lLOEx6czB5WlRpSThtS2V0ZlM4UXRWL0FW?=
 =?utf-8?B?WTlxbjZ4ckwwTm0ydE8xRS95cC9OTUlteGRIU2I0ZG1wcGh2c1pianBNaXla?=
 =?utf-8?B?L3ZqWkRYNTdSWHY2OHI4K2ZSYUtzSC9jRGFGaktIRTRrc0c5ZkxKRDY5SElB?=
 =?utf-8?B?MUQrRVYzZnVmcHFvVFkvV1Zya0tiRE8ydXBPWm1OdWRkVWwvMk9FdU4vVW1i?=
 =?utf-8?B?RVhycFpKRzN6T3FUWkMxb3pBaDZzelVZLzhHRURzZmxuLzI5Ty9ucDdxZ3BI?=
 =?utf-8?B?ZTJnQnFOUnR6ZGtlbTBEdHNwT2ZsUnFIQzllMWlUcHovNEtUNkhScGIzUE94?=
 =?utf-8?B?UTlLWmdocDMwZnZsaEFSdTJkemZLcFlIMjcydkV2OE1XVmluU0NUVzRTZDQ5?=
 =?utf-8?B?TjZ6UVZjWUZhZE90cmk0M2htU1ZzSldpaFB4L1ZjOGZ2Z2RPdUMyL2ZpOFgy?=
 =?utf-8?B?Mk1nVFNJMkM4YjZCSll4bWYyMldYdVQrODlESzJrQ0hyOTVRbWZCaFZSbEov?=
 =?utf-8?B?cmlZbnlUS0RacWIyVC9DMm5nVFp0cmRRdUdrYk43T0xFcElsUmNVOElRV3hD?=
 =?utf-8?B?cG84bVlIWkY4M09nU09BV3hLd2RJMWVueElTRnl3THMwV0xoMld0SzFkVWtp?=
 =?utf-8?B?aWxDV0YwYitGUzFDKzhrYzV3YzJGZE5IajhkNE53bVBjdytKaXJ6MUQxSzB2?=
 =?utf-8?B?R1RuZjF1TE9QUHZha0RxZDdtU0RkQ3ZYQzNvQ25RaG9WckRCekxqSks0N3By?=
 =?utf-8?B?a0hHVjdNMmFvV1NWUjR3NW04NUYxb3c2T012eGtPN09oSUxrQUsrK01TRjNE?=
 =?utf-8?B?aUNsRldIWHhscDdLSWxsaGY3UExtVjNYVHFyb1UvNjNVZC85OUJsdXArdVBR?=
 =?utf-8?B?QW5vTDVreXpIeUtCQkJzQzdYRHhCeExhQ2NpRXJ2MERJSDNINGs5ZWRIZlN3?=
 =?utf-8?B?RjBmNndWc29DTFJ3RmUvZWxrbkprWitXMmJzZDhIeitSL2JyVk1mWVR1MFls?=
 =?utf-8?B?NjBlTEdBamc1U1lTOG1PcmlBTC9BOUhjU1F5R2ZSUy85dS9UWkVqUlB0Z0JP?=
 =?utf-8?B?RGJQL1R5bHVySnZOWHdibXhuQnRSRUNLM3lTL1o0WkVvaWc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230037)(1800799021)(82310400023)(36860700010)(7416011)(376011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 17:04:14.4687
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28d800a2-c285-4412-de5d-08dc8c9404fd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E62.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6536

On Thu, 13 Jun 2024 13:32:05 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.5 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.5-rc1.gz
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

Linux version:	6.9.5-rc1-g3fc8ec8cbfb6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

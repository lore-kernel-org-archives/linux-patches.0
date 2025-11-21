Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012064.outbound.protection.outlook.com [40.107.209.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF902DEA89
	for <patches@lists.linux.dev>; Fri, 21 Nov 2025 16:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763742524; cv=fail; b=a8B0wQG2c9VVK5zvE0240PUFnGDiMsWC330d1Pxbnge3OJ31TLdMYYWSwhh7D8DtkNtcFGSDfn1ftl/RU4IbvU40N1KpbgEugDkDB1J1sQl2MWcsiRslzMykxyf8WwONbGZJzfqWcZrxRk87H/gXvmphIRZMlZJ8/yqUM4DVsEY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763742524; c=relaxed/simple;
	bh=ktW2jo5Bu1qecAPWv/frjh1jMOJ+SiI+Yx4XltDPutg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=IhWNGafgFkwNZRLUQN36GDsaN4K2L3jtyoLV57Vgkl1F2IHjkgCQo7MB7HpY700aYr75t7uAVbIdnlqLiFbz5GpbvWx/IDghMA6I0WLPKAMpfCSBaOMXHDATn4+Ld1V4xELmVyw9HxMeBzm/p1F5MZVoy49+Wey9yLAy5/5XHQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=D0x12DrX; arc=fail smtp.client-ip=40.107.209.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="D0x12DrX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HiB1zw9WW7oqHliKSmesXhyYH72QOkhIsA+iqTvZGxcEsrOk/m+Wu9aZJQKLn32U1KMRgEhfXw0b2h+WSwMR71fvhaSGqetGmMIe+yFWT15ouPUtvvp6PSMP48pX3bRJUpOCm0+VXYVjKtLWzWLwGKegtSjLFQkD3W1ay2XTztuQJIKTLNyY3CwhMIscGwcgGr9dmeuS3xZN8z5clQfBh2l5GALOSZZlR7yUEax1VFWK4SGxLcmr1RUaAujJtoshBcSZYR19gTVTSsOVTZ7MWVqoK2Os+j86s+RLuWr/4jhA+F00k84n1X+qjnNnrQWuBOQQ1PdUV8CQmLToHopmDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a9zPtpQf/Fq488MUDqbHd4mWt9LSFoWkxKGYAF4F6bA=;
 b=AgTyPyp5QIUkrBQbgOlctm8kDP3/0o4SyJX9X4vtGdC7YpnR0ziWQY8KixtdsRjbYf2leVGbFrtQvS1qp2dQ7vwayh8UAwgPM5tC5wOq9N+0Hjm8ZifhRj/JjMJrhlE+ff0LIHqNNsYJTrxkpoK0XdugOLpRKsFobagV1QzCt4KhHzN+zD41Rq28/+oCFL2kCpOwxqvsPEfLiuUx46ntZsBu6TOhMehLpfP5Ye9ZyPu2dbrN2TrLVYS6jt16yl9N4OTHDPM5n5zKQjInrIv2J1inovFtes1n9SNO9t90QtB3tluwknkXFp1Hu2Crsp07uStd3Bk1oEOKsizUQ+DFJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9zPtpQf/Fq488MUDqbHd4mWt9LSFoWkxKGYAF4F6bA=;
 b=D0x12DrX421yEoFwUYjPvliZzoIlW4JZKIMitcAYUg2R7RHlimGVvfSokIEkhH0SwgUR+ioJEI08dzIu3JdH1KnUpk2A8G7he4AQ1RRA03zjB5/5ksDM37b9Df252uy2YJC2w1lvEex6usMHSmzLR+NW3QbQEnwYKcAH4zNy9bfBcJ+PgRkzm4HR6xsjVisTxOkt3eeMoPUnZPc7sSCrs49/mXx341bvqSGs/qTYQqd7IgMd34tgLMWf9wo3gBDZpr5qwdBeajtU2scIuH8+dPW5NG9IgbrPqrd6+twTgm2ddw/Ps96MN/2mdQsZnjOnBB3lTvN9IGZZshaJeNNmsA==
Received: from PH8PR05CA0010.namprd05.prod.outlook.com (2603:10b6:510:2cc::15)
 by IA1PR12MB6388.namprd12.prod.outlook.com (2603:10b6:208:388::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 16:28:35 +0000
Received: from SN1PEPF0002529E.namprd05.prod.outlook.com
 (2603:10b6:510:2cc:cafe::48) by PH8PR05CA0010.outlook.office365.com
 (2603:10b6:510:2cc::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.6 via Frontend Transport; Fri,
 21 Nov 2025 16:28:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF0002529E.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 16:28:34 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 08:28:14 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 21 Nov
 2025 08:28:14 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 21 Nov 2025 08:28:14 -0800
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
Subject: Re: [PATCH 6.12 000/185] 6.12.59-rc1 review
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <7cf4af05-f573-4569-af85-2689d112a602@rnnvmail205.nvidia.com>
Date: Fri, 21 Nov 2025 08:28:14 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529E:EE_|IA1PR12MB6388:EE_
X-MS-Office365-Filtering-Correlation-Id: f4e204e9-0bd2-4bd7-8b8f-08de291b0494
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MEVyZlk1YjRZMnBhWUt3bHZWYXZtclRGK0FaTEYzaXhMNm9KdWtqS0JKUXpr?=
 =?utf-8?B?NFNDWEMwL1NKSkNMNE8yNmF5TS9pcHRKckhrdDBEem53cmgrcEVYNkk3L3VN?=
 =?utf-8?B?RGhlL2psS1dQcGFRNXpOS0ZpVjJYWjM0SGorSVpLZXBxMkN6SnN1NjhWOG8z?=
 =?utf-8?B?MGdqS1M0aXVsdXNTYWQ0M0x2cTFVeG1OUTFqc3pRM1dvRmJvTVhnTks4ZU13?=
 =?utf-8?B?M0N5bVhmb1lRWHJxR3BxMWR3d2s4NVlaRjl0U3lmRGFEYy9TQjM1UndENFZ0?=
 =?utf-8?B?WTBXY1Z4N3lzK1lhT0QrRERRUWFXVXpnaWNqSk14Q09jWHJ3bEowUHA4OENV?=
 =?utf-8?B?VlM1Z1dJSTUrWlJPWCtkSytYZ2lTUUtETnZhU2FLaHlQZE5sckdxZmNZN0lN?=
 =?utf-8?B?TUVRdXg2MEllNVJPcHZzWEFXeE12RUxoNlhPYkdIcTI2cUlwaCtVUEpKbFIw?=
 =?utf-8?B?dHNiQ0JBT1cvQmVUdkRyUW1iZFVMNUk1TlhKRWZYOWZKVWVGODcxSEVDVmhr?=
 =?utf-8?B?YkUxYW5VMEVaRnJxSGNHZWN4ZlFjR25HN0hqVmswelA5QkpPRmlML1JLQXNQ?=
 =?utf-8?B?N3MrQUVmSUxkNkNXZGtoL0VuWkJkVDZ6Mjl3aGVSeXYvdFhGTnVudVhYME5K?=
 =?utf-8?B?UUtJZm1GTVNTeGZ2Wml4RGtobkhTK3d6VjhYdFgxMVI1Y3cwMUFidVRaVWxQ?=
 =?utf-8?B?VE9vTHNkVFBXamZpeGkwTGNmRW50MWFzSFY0L25tQndTNWhoamRCbUk0M2Jy?=
 =?utf-8?B?RFVEdjRGTm04a25wNHJ1cG8xTmEvZkQ4RERTbm1sVGx1aEFQb3RKSC9nb0lS?=
 =?utf-8?B?TDA5VEZIT2gxQVFIdXN4cnFDWUdYeTZEY1NveUZwMUdGU3BTSkZZbnl1U0dN?=
 =?utf-8?B?YTVCSW1NUmFQK2VkRWVtaVpPRURIeGYwVUJYWkR6WUNUTGY1eDh2cjhLQ1BS?=
 =?utf-8?B?NzhtdUxFaHR0dmZZdzEwSTRXN250T09rQ25tUkJKbTh3SmdRbGdjYzhmL2FR?=
 =?utf-8?B?cmd3UUtwM3dWY3RlcW8xbjlDWEpIYXNCSGZBTy92TVRITjV2M2k5VXBuSWxI?=
 =?utf-8?B?Ry9qbUNDdEVJUVVTUjdVV3gvS09sdGRMZmd0dVoxSmR1TW9EVGVkaGRHSnFB?=
 =?utf-8?B?cWFCQ3lpZzlnN2x0Wks1dWl6cTFCUHRVaEpnS0VTa0hBaHNMK1dxdFA2eVdr?=
 =?utf-8?B?eUxvMHBpZHpMSktNNVdSbTZRaVMxa2JQbDQ0SjhpRm5IL2tIVDdsWjF6c0kw?=
 =?utf-8?B?M1lNVUVYSmdpbjJHUFB5NDdyWFU4N0xBUFk3UThQM1R1MCtJKzRSeTB5MEx4?=
 =?utf-8?B?R2xIK29WeTBadFFHQmdQWm5XbHYzbjlOTzhoS1pldXdVdUJ5TGpqTmtBekJz?=
 =?utf-8?B?WHBZd0JRTDZGT3AvQ0VacWlPaFk1Q096aVUvWG9KS1I4OGNSdUlFUlUrVXQv?=
 =?utf-8?B?b09QSHNodmdyanJiY0hOZXhuT3pzN3QrYUtrYVRmQnZRK2FmZGJGOHVxMDNG?=
 =?utf-8?B?VGxEWjZ2U2E0Q0l2RHFDa1FibmpmaGlLc0w5dk5WR2ZhMU11aEVHanQ1OVIz?=
 =?utf-8?B?b2VMVy9TdUQ1WjkxQ1Rmbm5GZTJqNVhGQmRnNnI5ZytETjZac1JxZWNlaUlz?=
 =?utf-8?B?K0ZHdC96bVlqUXg4NFVIKzlaNkxlNzdZTytrSit3ZUpyUWRXVlBmWkNpUU13?=
 =?utf-8?B?VzJTd0RsbFNSd1dXYWhSN2FTV2cyK2NHZjhOR0JvSFBNSVhSdkZnWGo1S0Z3?=
 =?utf-8?B?bE0raFBzNGVwOTFuZ0VhQmtFT0xrbmVSamg3eVY4L2RmLzQwSHZBb2h0Q2gx?=
 =?utf-8?B?QlZDSE5OMHlMYXIzSE9UaXllLzhhVE53NmIvL3BSdjVGUFBVNGFYU3hwT0E0?=
 =?utf-8?B?NXJ4Q3gzN2VxdnZxK1ZCeUY1YTFJajMzSFlUdTVDYTN4SnVvUlBpWi8xTWdv?=
 =?utf-8?B?byt3SUlvMUZsWENubGJPNnUyUldxVk1EQnNERmpWQTRFQTFXQXgwZ2s3SHc4?=
 =?utf-8?B?V0ZWeXBxNHk0UWRaNHZHM0pDdkJoVlE5c3R4REpSOWVWSUNWb1gwdjZueUxV?=
 =?utf-8?B?ZVlzM0J3UWVIS21KZEtxZlYyZVJhNWhyR2ZwbEd1MVVtTTJKVU5od3kyRVB2?=
 =?utf-8?Q?4FvM=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 16:28:34.9507
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4e204e9-0bd2-4bd7-8b8f-08de291b0494
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6388

On Fri, 21 Nov 2025 14:10:27 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.59 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Nov 2025 13:01:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.59-rc1.gz
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

Linux version:	6.12.59-rc1-g92f6b4140c17
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

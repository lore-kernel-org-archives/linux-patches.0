Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010062.outbound.protection.outlook.com [52.101.56.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689382FDC2C
	for <patches@lists.linux.dev>; Mon, 24 Nov 2025 11:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763984593; cv=fail; b=hNqUIvDrUQUcBF/zXKkmM2l9ZQqCcuff4mJoBGyqOuv/TYWAla+ItGvu6hgjTzEQtqXEZS2nh82iPcTDjOhAJykx94R5JWbg7zU/H+S+Oo2CRFRJxffOxI4dHAadZ5cQ39zv72Tazo2VRhbWA3kitwOP9RlkfANWrKS+JQawMgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763984593; c=relaxed/simple;
	bh=1fiAABrtVzTDuQy6yvYwP1MTP7NxkChiBtpCF26UkNU=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Wgk00eMczG8tgO5jR3n6VO09fGSR7zXOYlxViRfb4L7afE0NPal0Fd+ud9ibhGm0ENvDVQMgylDe3uRxnLM+naqQxuCH7l0qH4zQ86CNGJhD9Lt8ClXIBrKXn4Uycbqzr/FS9SN3yOAgOKzduSF+lagaJzKuLuxc95GFXjlhfyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YOY4WCw9; arc=fail smtp.client-ip=52.101.56.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YOY4WCw9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iN0H5Z7gGlKswCu45/hecTTpstP4clUehMcqHxp0Cx6fnYL4nZWcicW3lMnuJ8UVJGCBFKmIQd7qfeDoM30WW1UH4mFY1Yp5s9t9MsTf+I64D+E+9flrPa2i2PsBbXQd1+gfqqkrjTVVDX1Qb/fzf8K4VbhYYz+/SnHB3gCq43NV72outoA4dxuPI/waMXkOyHCRHYOCYDIPlmZUNRJdVzCsymJ3PH8bmT1KORExshrbUM6utj8BKhtvTmhpe41F1DBfYA4hrDEGIGq0+qTH+Smw/UjqBMUKOlDrfTL3p+2DIVtaQIODCbW/aObJgvPA4pyQvXQFIEIjxoytNzexcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nGjy5lSxH9mXtBFNuV0aFdG2FdqfojFf3bU4SQ78lrI=;
 b=eunCJvJ0jhgnSZ6n/Z33N8W7/WBCiWyEvX/ztULg2nABXLdYoJwoHoxAyEcERceox2OswCDvgPGMUVFIsK2ZHlQpDaj/A4wZUtXOYs9q+IgpyC9Mf8GgXZK4ZTsdNhdFKrIG+IMEOUXTXm7qsjh32Z+Q0HZIALitaB4BygzW8OznTqVZOdZSL0aDndcu1iraiW+TtueI0tnM72A6QS2uDOC/x0Zo8SJuy+d5OOgiCtYErbbI0tmRW9Qsgb9SsMJTGb0q3oDqLeuclGKcboutTAf2rhSCBtTqDUoEMp7seJN9WXxAq8E98qjSsCbiW4HeeM6QFZ/stVdDWvv6DBB0KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nGjy5lSxH9mXtBFNuV0aFdG2FdqfojFf3bU4SQ78lrI=;
 b=YOY4WCw9+FTI+pH8r04OFjlYhLedeCh4U78qcj/MvkRheu8uZfJz8iCwC1d0v74JZfFb6pFQrrZJorpT90Z+hJbveDFgud1Ms6d9Bk50PBly0jJCD3kMiCJ02C6OMzSwyKt7TlVOQCyPrxcIWlzYk0u69onkK91XKNKGHfTlAzSfAG8xZcJIz+i5ewZx1mk0MpujbiyaTx3zQnesJczumrY1c1QuAsM5FaVX38/s383SBPk27vctVTlLvtaTuRNSjfNTSg06Whn8j8ZGfQSgPz8Ze1ZLht932c2eNDWgtomJ2HwypZNkM6/7helnbpTpB/ijIMnNsyHhvmq51cROMQ==
Received: from BL1PR13CA0432.namprd13.prod.outlook.com (2603:10b6:208:2c3::17)
 by SJ0PR12MB6687.namprd12.prod.outlook.com (2603:10b6:a03:47a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 11:43:07 +0000
Received: from BL6PEPF00020E5F.namprd04.prod.outlook.com
 (2603:10b6:208:2c3:cafe::b8) by BL1PR13CA0432.outlook.office365.com
 (2603:10b6:208:2c3::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.10 via Frontend Transport; Mon,
 24 Nov 2025 11:43:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF00020E5F.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Mon, 24 Nov 2025 11:43:06 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 24 Nov
 2025 03:42:52 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 24 Nov 2025 03:42:52 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 24 Nov 2025 03:42:52 -0800
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
Subject: Re: [PATCH 6.17 000/244] 6.17.9-rc2 review
In-Reply-To: <20251121160640.254872094@linuxfoundation.org>
References: <20251121160640.254872094@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <40f86e49-5817-476b-b2e2-2a470a06aee2@drhqmail203.nvidia.com>
Date: Mon, 24 Nov 2025 03:42:52 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E5F:EE_|SJ0PR12MB6687:EE_
X-MS-Office365-Filtering-Correlation-Id: 8122436d-00d1-4d0c-7c4f-08de2b4ea253
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RE5UemMxOEZ1WVhFQnV6REFhNnJVaFhLQm4zY3QvT3EzdlFveEtGUmR1M2w5?=
 =?utf-8?B?S1RFWXpDWVBIR2krcGpGbFRGeHBRQTZmeUlQN0NNMnJKMkhxT29BckMzWWJr?=
 =?utf-8?B?V3F2dWhwSnF1b1BoN3lreUllZHgvVXg1Mi9LSVZJL3FkSzVxNzJTVE9Rdlli?=
 =?utf-8?B?MU1VYXM4NFRWS2NWWHUxajZUaTVPSFFJUkdZdWRIbDFZdmgwdEJ3QmxHM3ha?=
 =?utf-8?B?OHBHdm9HczE1WjRoVmFZeDNlaDRMUm8xTUs1U3RWUDRiQWZMTFdreXhoYjkx?=
 =?utf-8?B?UDVXaFpNci9TdGZtZHlIWnkxZ05zcklYMHJaTEdCVlQwOVorYW5pMk1zNjhG?=
 =?utf-8?B?c3EyNEJuNlRNMGM4WUlqSzJJTHc4eVpWanY1MytTeUlaNUc5TW1OTlRGQ0Ex?=
 =?utf-8?B?bmFFa0VRdjdDRkN1a3pkZ3VzSHRzRXkraVlMNWlFSi92K05sdkJSSVZRV29p?=
 =?utf-8?B?bE55T3BROW1GeXBOSVZCald2c1ZJUis2L2VOOXZRUk8vVVdNTHRSN0xuM0hP?=
 =?utf-8?B?eGdkdzdxcUpKVnVtQm9SWXY3NGpwS3lnZFhreE5vSlpUWWpvdy9WMy9jKytn?=
 =?utf-8?B?NXFrT3BUakNvdFBYdHB1N1kxU3hod3FsTFBsNEVLOFNCck94NzlRdHNKMjRP?=
 =?utf-8?B?VGt3NE9DRUpEU3c3MDROVFJ5ZmFyN1g3MFVkU2VxQXdhcm1uNDBSTXREWGNm?=
 =?utf-8?B?ZGt4dnlMSzc2ZUNJMGF0TWNUeFlkRGMwTEFOTkNKTHJwZnlqUXEwZS9yaWdK?=
 =?utf-8?B?QXozMlhUNkRobG83Z2wwbnJBZGRFU2NEck50QU15UmFVTmlVMlR4bWpmVVBJ?=
 =?utf-8?B?RExVOGd6Qi9EZVo4WlNjNkZDN3dXazdLRGc4MzlIYnVGd2FISmpNOCtTK0oz?=
 =?utf-8?B?L1JzWkdMeGl4QzZBS25uS0dMUk5RQzNDWHp3YXd5ZHVJN29pS3pqMnJJR1dK?=
 =?utf-8?B?ZW1KK3pSOUNRZXVjSUFuaS94eE9wbFhMeXd3Smk4V2lLb0ZyR3E5d0dIKzZM?=
 =?utf-8?B?ejJxR1U1YTlNYmEvTjJRNUJaU2hZdTUrK1FaU2NSYVFRSElTaTI3RTBQcW9o?=
 =?utf-8?B?VGdSWHl4SXViRjhVYzVJbnRvVXJYRDNJcDF5ajBiL0pVWHhDcklJYytTbFdF?=
 =?utf-8?B?QmdubnhFR0NVNlA3VzZEVVRFalBENCs5MUNPVWtxWmtzWnRGUTNLUVc2Vlhx?=
 =?utf-8?B?SjlWSWhPQXVDQ1NUUzVKQXhscDdqb2ZaQ1FDUFVGTXJ1RUp4SE9zQ0VVUzQ0?=
 =?utf-8?B?RW1ZWjdlZmRkOUpKOXRsMXRMOUV4VG03VXYyc2FJS2ZqVTM3blpXMjhuNWZR?=
 =?utf-8?B?dEJGOExRNklCeDhDTUhKYk5KM2NLcDluSzhxaEhBZ00xY25xa2RnTG5mZFdu?=
 =?utf-8?B?V0ZGRHRZQWxESDZieDFjMTRnc0ljZDJ6M0JwYUdNZzZ1QTdhNXVRUUhvNkJT?=
 =?utf-8?B?TzlIWVBubDViV3MrNE9UQ1IyTEFobHhzRm9tQ1dvczNLUEZLRDNoR2FOdlhC?=
 =?utf-8?B?NVdOUG9RejF4eXFBTzlUNlE0T0N6UThaNWlLdGNSU0NwVTE0TUwvdHRmY0x0?=
 =?utf-8?B?RWl1NjZraG9sWjQwMW1hTGcybUFOYTVEeGN3MEJsYkhQdGcyS3hJRkc4NUVR?=
 =?utf-8?B?NW1xMDlJM1YxNzNKNlYrZ1ZycklabncwWjNNMFJFd3lReTJsRkI0aXJJeFlo?=
 =?utf-8?B?QVgrU0JDSWxmak9wVXozNWZKY0h5VnJWMmhMcGtlZThuY29QS1lJTnJHWDJz?=
 =?utf-8?B?Y0w2Nk4vR2tETmFxSE1zaFJ4aFc5d1JlVnloTmNRdWwxNENueDczdDBkTlY3?=
 =?utf-8?B?cjJkYjBKSXhURy93OTQrWmpMZ1ovdno4dTcwRm9ZRUZnU1VKMWtTR0RQd0xn?=
 =?utf-8?B?MGFRT1orei9yVWF3cmJQQnJlanhWNXZRSlpaVG1yTm0rS042Z1lGcitVSUpz?=
 =?utf-8?B?MFM3QVZnY3VQc2VxbWtkWFBoVGE5Q3E0OWRGS2szQ3B2S0tPZWpDQ1ZqUDZ5?=
 =?utf-8?B?Zy9sZWVlVXBLRzlWdTlYSW9QVUw4aXd2NFVMRm42TkhDeVhwSUhIemQ0a1BC?=
 =?utf-8?B?WHJtbVFvUXFQOG1mbFlNK2JzZC9ITXNzSHNaOVM5RXVTRkFHaGFSK0RUNlRq?=
 =?utf-8?Q?LeoE=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 11:43:06.2258
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8122436d-00d1-4d0c-7c4f-08de2b4ea253
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E5F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6687

On Fri, 21 Nov 2025 17:07:19 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.9 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Nov 2025 16:05:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.9-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.17:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.17.9-rc2-gddfe918dc24b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

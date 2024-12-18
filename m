Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2080.outbound.protection.outlook.com [40.107.95.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782D91FA140
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 17:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734542447; cv=fail; b=CTIzB6jlLSe5UFBUz3F0g/yYqFenUwdgTQ7+lVQlC0mHpYDSIdpv3y6SbyiGKPPIFccpDZxbIWFvB8UReSSWYzdGXGrlm7BzkL8KjWTAYCyXoiMAqCXvRPEHWySHcFCui+gotWZPGNETCS4pEL2FF+VrFbOfz33/OsEX6kd+mk8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734542447; c=relaxed/simple;
	bh=5wOPes6EZr54GF3aK+gFbeWDqqimKD73JA9dECpmCTM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=GeoHwxpvVZZGOPkIO36qAInTYgXzvtJ44p/WPZwdTmtIfMQxyzc3WX8i9GwMDI7Mjak1izytkmPiwio2YZ/S8tuaRa8nZ9AJVS1D3AdUHz+fjRFMuz7i8eD4gcyJNZoUIjSVZH5JItGgYq4XLSA5jX4ifeuhoNZWvn27FCbkIoY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QTi8A6J1; arc=fail smtp.client-ip=40.107.95.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QTi8A6J1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zHObqWM1N5hPJUq/DPSYSK8y1d0zmPG78h/v8zN9nReCLS6sDqR1GNegX/IJAdDufJoGwAnLrKSKt1CT+8WpAv4qRELvTLKXHXMoKLAVNjDFNnvNNTK0nEMvS9kP5gkuQ0i6pyX0+X5W3fZiC77L/7rT1yFPsCkyD91q1opsS1LEb2nAI7RA8f8jLi/dlyQKHivubkKI+DG/weSahewysHeqBppcC9SrkQsR9BXZOyNU18A2Gs55NVR9EOBf0GvxHOt0c1ByPJx0vg3eHIcJdntpM3f2sxps03RW3vWAhE5nVxpKMJiSQ5BYWtQwh9g4jcyB7u3OsHm//PHLxtyjzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o09AX15zx+1jfUdh1oaQYp4INT35yKSL8NicKisGXpM=;
 b=mv8C2oMWyIF57y921Vth8seuGyNBUiYRl2UK70Q8eSP/MeRL+OBmT46PA7K+L+XZL2SHS4AE7d6A1oBH7p0G3o/Sx5oq/c6auDYniZbgIWRtLNCFQNevARPO8V3dSZdZNZ9xpm74j7zlhfH3JWuADwV7bP9xYsJlu542UT+Jjl3WWY7Ak/hFRDUa3Ak+fIKrXsMd3yOlr/dOA347ouGdAEbMbJPNUmpXzKg4+5djjfkpdVXNon4i74iLhIdlZ52zNIcPyhOT7ifoGNS4aFdz0+mJ19jRfQwp38/Hn+qIEKXF4yVrRN5pGd+1GNUY5OpIfJmYipx4bJI/tpg0MQDshA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o09AX15zx+1jfUdh1oaQYp4INT35yKSL8NicKisGXpM=;
 b=QTi8A6J1UvYY2neRLZ498ltzABxmak+JVvXUK9ssoQ3ZSYoOoSrlM//3wi7s5r2UAwj+YZQFCbWYvoL0r8tY5WOUHS05wR99iS3/UWCUTKLl2tfZaOeuWHVEnQRShLOzq0M9+f2Z0IbRf8SBniAIuxKQ1dCBLMx/PP8JpQ2DLT3395GRh3b1OVx/NYVnfwQH+VER/5F0q4dKHiOne96V90lnTwo9Uuy7VSJmhv8oE6gc+NXkvz2u7Kjtjq13/zk+1RNtCvrKsT69CwERoxK9XbO+xHh08yrgEJS0mY3EImdwzzu+hiBQgxsy5kGAkBAJEBoCKAViaR5nysoroAZXqA==
Received: from PH7PR02CA0004.namprd02.prod.outlook.com (2603:10b6:510:33d::7)
 by DS0PR12MB8272.namprd12.prod.outlook.com (2603:10b6:8:fc::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8272.13; Wed, 18 Dec 2024 17:20:40 +0000
Received: from SN1PEPF000252A4.namprd05.prod.outlook.com
 (2603:10b6:510:33d:cafe::72) by PH7PR02CA0004.outlook.office365.com
 (2603:10b6:510:33d::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.23 via Frontend Transport; Wed,
 18 Dec 2024 17:20:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SN1PEPF000252A4.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.15 via Frontend Transport; Wed, 18 Dec 2024 17:20:40 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 18 Dec
 2024 09:20:28 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 18 Dec 2024 09:20:28 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 18 Dec 2024 09:20:28 -0800
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
Subject: Re: [PATCH 5.4 00/24] 5.4.288-rc1 review
In-Reply-To: <20241217170519.006786596@linuxfoundation.org>
References: <20241217170519.006786596@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <3bce8da8-b79f-4ffa-ac80-6014639af721@drhqmail203.nvidia.com>
Date: Wed, 18 Dec 2024 09:20:28 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A4:EE_|DS0PR12MB8272:EE_
X-MS-Office365-Filtering-Correlation-Id: 288bd12f-2dcb-43df-9c06-08dd1f884bd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eXVtbVJEM0F2ZWU1dmVwcEswR29oMUYwcXFsMFR0ZXJmQU5Oa3h5eHdoZ3cy?=
 =?utf-8?B?N3JRRjlOdFBWR2crT3lKU0tqRnRmODVVZFNTN2wxMCtqVEVLWFFDODJja0hx?=
 =?utf-8?B?YmJmM25TNXVlVEYvamd2NkVzbGduMTM2dWZocmN5YTh0dnYxdCtqRXZFL2kz?=
 =?utf-8?B?SG9zVEhnVTl6L3pUcUZhSHlvUXZrcVk2REtUbXF4NkdBdlhhUVhobnlaQ3pP?=
 =?utf-8?B?VUpVcC80a3dUbUhGRFJYL0NpVkJrRVcxdS81aFZlVzRHbDU1Wk1FS2ZTamJh?=
 =?utf-8?B?aVN5aXZmYVFqYXZudER0eG1heXJTMm5VUDllcmIwdnV0Rkloby9wNHJ4QU9C?=
 =?utf-8?B?RVhpZzdmeXZzT0dsOUZZdjZNbUdXUUZmRklNdXZDYnU3d2dmVGVFc3BwOEY4?=
 =?utf-8?B?U3VMMlJTczZFTHVJdjlNTzdEZi8yRzFqT2oyTjdYQjRkWHNCYmJuWlNQc3Er?=
 =?utf-8?B?eCtydkRDODdBejR2RWVla2VEcXRUdGREM0tYcCszU0E5VHF2dXN2cHAyU3I0?=
 =?utf-8?B?NXR3M0hFcUNIWGNVWDZBUjBVVmxPbklWRGxHekRoUWdvTUd4RVpqa3RDbWNX?=
 =?utf-8?B?c21hRUd4NjY0L1h2K0ZKRCthUGs4NXd6UHRTSzNuOVdoTGJQWllWam9rbUM5?=
 =?utf-8?B?emhtbVQ1amFTSWJQTXFsTjVQQUgxWTQrVnkxU1hvK1lNZmJKcEFEcTN2aHRk?=
 =?utf-8?B?TUVqbFU5eUpTS0xHVG5jcHNPVDNMRk1WK0M2R1ZLK0hwVjdSUDFiV1RqZzhy?=
 =?utf-8?B?OWthQlh0V01hdWovWkp5K1BnVGFCK0IrUTcwVEM3emJXZ21BcVM4YzVGTnBw?=
 =?utf-8?B?L1c0YlpIaEp6N0NpVUZ2WEZBNlRBT2pIdGY3MnptQVhqQnBWWWhEMzFMck1a?=
 =?utf-8?B?UVZGRHNpYytlbFZMVUxSbERYdVVSaG1YYkR1M0MzaHB4OERZbklWbFUvVVpK?=
 =?utf-8?B?QklGMlpiUkVPOFhsb2t5OFFyMkZQNGJSaHVoL2dueUYvbWE1cE5UNHJqT1d3?=
 =?utf-8?B?NmtPM0h0WVZuQVg5KzdBcEdYWW5wT3hTTnBGQlE1Z3pnb0haUkROYXBhZ0tX?=
 =?utf-8?B?SU5SdTZKNDB4NDJhakJxbVhvQTB4SCtiUFBHb0xKcmxRNzgvYmkxbmk1SHBy?=
 =?utf-8?B?L3QwQVhxdnNqZDNNci9nbGU2TTlLajZLL2VlRWtYb2crTVBWMXdVb1FUdHdy?=
 =?utf-8?B?MzAyd1IwalkxUk9JbSs0a3V5cXFFQXBWMmRnT2pxbHNyMjE0TlZDdWdJaCtN?=
 =?utf-8?B?S2lhWkxPc1FGWUNVUHAyaUNuK0tObGQzelR6V0c4VXRGMGJBZGNjbUJnVVN1?=
 =?utf-8?B?VmlUaWo3aEdyQUMyTnlxdzY3THJuaURXZzF2RDBCd0p2NUxJV1Jva0NSN2JT?=
 =?utf-8?B?TmdZWm11aWdVei9LSmY3aEtVV2dyUlQxdE5wd0FScnlJR0ZvMHE2aWtmQ1JR?=
 =?utf-8?B?a0wvejVvYVFlUzZ0Z0tpZnQ0U2M3N2FCVXZvWWVMUkZXbTB2US9PNUZSNWJS?=
 =?utf-8?B?WGRLM1RnYnBzUWo0QllxNjROSHpiQzg5bXFtOFNDZGJ2YS92OCtZNnJteE5T?=
 =?utf-8?B?MHBmN2RRTGcrTlFWSUcvSnl2dlk0azhBcWtoUENLN09FQy9jTStYR0x5QVZ1?=
 =?utf-8?B?TlRwYU10aGcwZ3oxV0tlNU9GcnNENlpocU12bytLdFh2NTNzd3lJY2h0Qjln?=
 =?utf-8?B?YVJqd2FOcHNmS004MjJJa2ttdU80cmJCRHJCUzBCMVc0cmhPbm80cUJ5TkFu?=
 =?utf-8?B?MkJPdUplVmVWQlAzaEhoZGFkSjd5ZXlLdzgraHowSkdENGs5VE1RcDNROCt4?=
 =?utf-8?B?OFQ1U2FINVBBVHQ0NE9yWTJkc1JETlN6RzlXeVMvdENrZkR2bEhkMnY2K3Ja?=
 =?utf-8?B?UHpaak4wT1NxcFcwZ1Fremhxc0ZrQVRxNWM1UXJ6SkxmQ3BWRGtUYmlqUHB4?=
 =?utf-8?B?YTc2RlRxZEYraDJJYjdXa09YQWpNc1lJM2JOK2lQV2UyZkRuRElRSmV6b3FJ?=
 =?utf-8?Q?smNPcZJw+6YbOFshBolLMUOrMi4WpI=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 17:20:40.3532
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 288bd12f-2dcb-43df-9c06-08dd1f884bd5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8272

On Tue, 17 Dec 2024 18:06:58 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.288 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.288-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    24 boots:	24 pass, 0 fail
    54 tests:	54 pass, 0 fail

Linux version:	5.4.288-rc1-gb66d75b25fae
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

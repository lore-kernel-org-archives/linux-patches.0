Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05AA28641D
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 17:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755105983; cv=fail; b=E4XM0dOOylNX3WXJzUVXGs4hGeeUsXMBr7iA4ohANT4SVfcmZB1phoGiCNgRKEOc294wqXk64+QtricH5VrFzF8PTYUtOV7X/nCpEM8gage/vs85AXRkEsmFSlVRSy39A4ws55Bd8Po8G9arv5EcOu6+0YG8VtgaDPlp+IKYvVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755105983; c=relaxed/simple;
	bh=LX0gjbAnq3yG3YbkslCDmpggg4KN5Xoxg4W97eWeBYc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NFiB140/waVYCnwC9ZWJQzzGWZjTK0WBWqDEIl9pcyXEv7KvaQxfXK0yByDVwxfbRb9o7mHlj34k8Bb+tJDofqZ0nYVBES5iQugLmT72AqVOi05yxYQ+34kWrFlGCLdTvoVkQX9ZWgMyNL/BpI76/Qmgqzp7EZF3z1WoKDJ9IPg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IUh85PQd; arc=fail smtp.client-ip=40.107.92.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IUh85PQd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iz0iZeR/ygr7SKWRekK0xDYaF3G5MCiRQxC5NJbWzLJY4b6dOzBzBIEOL6dspuCn56ZJbgqUOWuS3eGKVk/D7TarPgRRatgWSzZssIHkKQx/jdZG78kf9qMkaEaEw5H5n/PTr1ZrUa1YSf42UxvcoqFPzcbf9lIw1M4ROo+GoLDcKrtkkTO8KNp1zMK63aJHnJhOt/L3BRp5XKus/FOiInaZ1rOAHRqetluWz2UaV6x576zo6CBVKL1SHUwtE99OnYJ9aFELBN4pb5jrqOXDSnITzy1uQp1yD6hCZjaiMKO6B2yVmKFqTOFHeA0TWRzVqoeoUYNrxABDpY37DcF92A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7JZhjS1O9/CpBJfPrrIDamvDas+pCPUq7yndzhOwPNo=;
 b=OSszc4o107qqlYBhgs4J+r7YcIHqPqYEaqv7tNOOcSl+2Wy10E3a9vcvzkcOwT4h4jqhKV/pQLPkHxwNHXFnJcGx5tMfVO60+QE5Orrh6WPNd5M8FbiX4zyV02Gua7St9p1k+Z/fL+LtUzgRiObl29cLkK+7seYQn8Er5tLp89FbzOMhZUBLFbOR2bneW3DTy+mNozbjKSJTYFuvN6YBjpv42SHAWqjM+wBDbyw5hEBc6rkpv6rmlWlN5rarckc9alDkRZhWrIkcMWDBBKwRdp4ki2xax9Ug/m2KpNOeXlAw62DbSBwpyf9rJHF9TL9Y7K9Qw8tl4pK0G6vYMXjwbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7JZhjS1O9/CpBJfPrrIDamvDas+pCPUq7yndzhOwPNo=;
 b=IUh85PQdzJBVtrr8PkPmKwSdSl0YfKLMK0pgu7DA0nP5lE2LFDn5bRwDWFjUbNAV8PhR7SvNV/PPKOdqGuuZxoMBGE9WBaD6ZbB0fCyj54M7Kol+DRYRSkL5EA4ypjgorYukQiRJeXMcyW244vLlQ06KCb/6mXpIpRqCRRxcgsAQE54V98xL83WPQxPdkmqb0voZF/3TncMqFZVIIdBcrhUXD6Ow6HHexiWnmtE4kqQ1euN281MfMTIJYpYbBlt1Y49TzGvDTEVz0GpUx9YRlIydveHLyr+u9X4SfmyW07c/XSzs73BFSRUlY9vO2XuebeLLCRp1tvBegR8j+Mtu2A==
Received: from BN9PR03CA0844.namprd03.prod.outlook.com (2603:10b6:408:13d::9)
 by DS0PR12MB8218.namprd12.prod.outlook.com (2603:10b6:8:f2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Wed, 13 Aug
 2025 17:26:12 +0000
Received: from BN2PEPF000055DD.namprd21.prod.outlook.com
 (2603:10b6:408:13d:cafe::f6) by BN9PR03CA0844.outlook.office365.com
 (2603:10b6:408:13d::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.16 via Frontend Transport; Wed,
 13 Aug 2025 17:26:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000055DD.mail.protection.outlook.com (10.167.245.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.0 via Frontend Transport; Wed, 13 Aug 2025 17:26:11 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 10:25:50 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 10:25:50 -0700
Received: from thunderball.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 13 Aug 2025 10:25:46 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: <jonathanh@nvidia.com>
CC: <achill@achill.org>, <akpm@linux-foundation.org>, <broonie@kernel.org>,
	<conor@kernel.org>, <f.fainelli@gmail.com>, <gregkh@linuxfoundation.org>,
	<hargar@microsoft.com>, <linux-kernel@vger.kernel.org>,
	<linux-tegra@vger.kernel.org>, <linux@roeck-us.net>,
	<lkft-triage@lists.linaro.org>, <patches@kernelci.org>,
	<patches@lists.linux.dev>, <pavel@denx.de>, <rwarsow@gmx.de>,
	<shuah@kernel.org>, <srw@sladewatkins.net>, <stable@vger.kernel.org>,
	<sudipm.mukherjee@gmail.com>, <torvalds@linux-foundation.org>
Subject:
Date: Wed, 13 Aug 2025 18:25:32 +0100
Message-ID: <20250813172545.310023-1-jonathanh@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <b892ae8b-c784-4e8c-a5aa-006e0a9c9362@rnnvmail205.nvidia.com>
References: <b892ae8b-c784-4e8c-a5aa-006e0a9c9362@rnnvmail205.nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="y"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DD:EE_|DS0PR12MB8218:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c55414b-2943-4d32-6b4e-08ddda8e7f93
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V/dMFrssRVICQGGk5gy6aYFS0Vy017RZ8gE8ifZRy1WDfOqJ2VADUBp16KJ3?=
 =?us-ascii?Q?sbte2/vOyAqkLJo0e6LqRf/Vjt61nuW0x9M9Dmi4E+eEN/0yWRmW02+l8IXC?=
 =?us-ascii?Q?SbP4Vup7RSvzMEVdt2URO71eyXn+FruYnkQESJ+1kD7SOuXMF1pgaGI7uSxb?=
 =?us-ascii?Q?huxH71Duveo4/5qUhM32VQLkk+B2GVoj+G7WmvHSzMQn2syIlMnkK8YIuHcr?=
 =?us-ascii?Q?Eo1/oS7eT6eLtAxZkZH+0yN4Vrh+mqyauZph9N5+S5+ZGcYp1jSb3VhoSCWz?=
 =?us-ascii?Q?hZRi0AOSIwYs0vgMvWeU1201Lvzm4NKfpbTLuHFeS4rqZLh/MOS/CVSFKHyn?=
 =?us-ascii?Q?d5LxMFKUX21ZGECqAID6Va33pzeU4Qp3Y4NYqprFQ+9jRblCS7sl5QWboknl?=
 =?us-ascii?Q?PbytZFFhy11A/dkFZtzg00G8+MqR/rB2IjoBYG/qO8nlTQTX15VWLgRVCnOz?=
 =?us-ascii?Q?vJ8tZO6bmtLOlsWpQyXyigRPvxBN6jX4yLXi8+C8n/ZFtHVTv52IlzWpSSaR?=
 =?us-ascii?Q?YEujD4CF7cNOPv/IlzKelJxyOd3weqjb2UDs/5Suy9Bk0QFw2bqWecbluHZi?=
 =?us-ascii?Q?W6pblmNjfrdbCzQAmFWH/IAQ2xfd5Ttn5qbTVX16PkZ82f5VvRiSNk+rPObN?=
 =?us-ascii?Q?1CX73sBpJblREJyb3ZtNJmRcslbeAyHcrLkHT9c1TrJD+wcj9pVoFy0ltlIX?=
 =?us-ascii?Q?Dwt9GuAwdy++omaI3GL38ui5O7lWWuDw1NiOpHpI6EBdf1Uuekdx78AIQSGt?=
 =?us-ascii?Q?/XBCw5kXh2wXGLOm2pGO4vfahVrbp3aXha+n4DR2oe6HQmBVD+DI0+1C6SUD?=
 =?us-ascii?Q?Z0PMnJX2eflx4WzmgPdgMcieFvJN4XAGQ3pA3SQ/4wuVNDD7YvM9CjFxvqlz?=
 =?us-ascii?Q?w0OLcZpC/OGm1gIsP2iB52TPxVq2PA4sXSy5LwfvZir1tBwN+cVoZbK+kdXc?=
 =?us-ascii?Q?LH4h1T9KltM8FluGtdN5ZjS5eFcem+jATjZaZpCsiQvzM9aCE864p06C4RtC?=
 =?us-ascii?Q?zBwfZauMfCoc2JpU8uDu6V+fIHkAg3BOoegvXUOKmxLzfkmmAqZKnL6V4KlN?=
 =?us-ascii?Q?bBoGcxK/MUBzdeKFfLnpZ1QHSedRt5TcmvGexPlfhruIvUC1BO6cGXbxEUTu?=
 =?us-ascii?Q?czcXjrV02o7UpJ0b9LJ/Yg6eqCbU+IxGPc+sfDG25kxaebuItpaMh2YwfULU?=
 =?us-ascii?Q?m1GpoQbVhmn9TPlec1VcvVm8MCCB0UMLbQhwgTn7edayBEeO2/8OxrWMe2Hx?=
 =?us-ascii?Q?tMOw+OGTFt6Cove7v/QidMpd9TyNSkxCH0M/iEc7UVcUWDh5lmgwXG9R60VM?=
 =?us-ascii?Q?Fa77CmG9aNW6HNg1GXTao/GCSHIBd/YQlJvqOqr9mn4l9g7nbgRrE/6TAFM+?=
 =?us-ascii?Q?oOzOPU8XLTLZEDDMJWeKoLitJP10h+oXbLyi7jHBNczOfUBVk2iAW6n5TdTg?=
 =?us-ascii?Q?QEVbl2NVOXI0i2i21O5+C3fXEhkzPsv/xKOaQ37rg0AZyyVP/DsR+NvvAvol?=
 =?us-ascii?Q?Uer9gLZ9dQRaqUyXW24inhJ/gEB8VYcLoUrj11zleSi8oZmG9AefKPKPtQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 17:26:11.5050
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c55414b-2943-4d32-6b4e-08ddda8e7f93
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8218

From: Jon Hunter <jonathanh@nvidia.com>
Date: Wed, 13 Aug 2025 18:18:01 +0100
Subject: Re: [PATCH 6.15 000/480] 6.15.10-rc1 review
X-NVConfidentiality: public

On Wed, Aug 13, 2025 at 08:48:28AM -0700, Jon Hunter wrote:
> On Tue, 12 Aug 2025 19:43:28 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.15.10 release.
> > There are 480 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 14 Aug 2025 17:42:20 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.10-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Failures detected for Tegra ...
> 
> Test results for stable-v6.15:
>     10 builds:	10 pass, 0 fail
>     28 boots:	28 pass, 0 fail
>     120 tests:	119 pass, 1 fail
> 
> Linux version:	6.15.10-rc1-g2510f67e2e34
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
>                 tegra194-p3509-0000+p3668-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Test failures:	tegra194-p2972-0000: boot.py

I am seeing the following kernel warning for both linux-6.15.y and linux-6.16.y …

 WARNING KERN sched: DL replenish lagged too much

I believe that this is introduced by …

Peter Zijlstra <peterz@infradead.org>
    sched/deadline: Less agressive dl_server handling

This has been reported here: https://lore.kernel.org/all/CAMuHMdXn4z1pioTtBGMfQM0jsLviqS2jwysaWXpoLxWYoGa82w@mail.gmail.com/

Jon

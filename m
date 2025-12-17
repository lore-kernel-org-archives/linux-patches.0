Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011031.outbound.protection.outlook.com [40.93.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBE823314B
	for <patches@lists.linux.dev>; Thu, 18 Dec 2025 03:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766027696; cv=fail; b=WCz+ftZlrUpdglbrga94Yp4bLmibk5OeW0/C5qs55C+/W5DoblXuio6Y6QDAIJWn8oZb5ir35S3I5CTwQF3f6m39tf38uf1FN+Oy8aml39X9NCfoyqtiqyDJsinW/5DL9ItgJxcIzwwt6iXP8iObMByFVJTXeXpPyZ6mpvdVDfw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766027696; c=relaxed/simple;
	bh=Xiv06ExJ3zS61A3L7V67ZcpUFBcJOdjju7YkWZZL8D4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=G44r4Und4zOMsULAB1AgXfAGgEj/RO4F8CstZJqUHQddcihGbbKMGVAHSTwQv5FXQVCLDzwxn9r7tWCJAJV5mM7ZjGTvHSteXLh/qLD5kU3sFmV3V+6lGxXVnb6PHvuHQyesGoCrf3cjG/8dSu/xh+C/Xp/eA3DGYMHmpXLJW7I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=strrEUKl; arc=fail smtp.client-ip=40.93.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="strrEUKl"
Received: from BL4PR12MB9721.namprd12.prod.outlook.com (2603:10b6:208:4ed::12)
 by SJ2PR12MB8649.namprd12.prod.outlook.com (2603:10b6:a03:53c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Thu, 18 Dec
 2025 00:42:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zE8ENzs9uGuEzdJsU1OxhgAoITpSQQUJMuqnDoTgj1m64gM2iRgVo8Gct4+d/z+8J6wrM+waodj6nk2zHpdvjPQjYUNY3ZkRFwut9UfLXdWlee1FsCx40pmlCyUQRIqJins3pj6hzd7K389R5hgsUJDZURevpmB9o8/F9QAS6pFrs4RyZJyM5TAb8/AaEpziAKWiLnOpvKLN0LS0/lIf0JKnlFe5qeHum9OvJ0ZB3Wg5tH5Jg+7HAzPP91CoNZQMBAX3I9Jnaaugwdqbx1cqkyq28IaPhlxtOJKxZot7YZT8D08Y8VUPVLqy+Kyqj7E2TM9PysBaRMoL9WcJyzGtaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L8qi/7uLxRqrQjnPyH8P5+ZvmCzcVeWlh322vfKkInE=;
 b=lhYtWxjK6bmR47GeZPkjG343UcngQonYcK3hVApG+Fhvug7xiE6itXBEbY8Nm4OgQvNhd4KYgU55fYLI0nYvznWtZrnoOa4By4BnisXCMayU49QNaQv3RpqTYX0ekv3Ut6LG4kijvNplfbbKaDnmo7eEiH4FiYaNh10lTWP6qxexLeYke89ZlLP3BbAbLa7P9sszH+ZmB9VKhHDKzwxmry8+pgdf6zx3MOhs2u26qVJAget9xsAxoEsMrY25/I/aTLA2NlOHWMfi1CbSM+tDdlcAtZp96jkdvLl3GF31cqMTKJw7cgyLjjlAZu3PrrJU1LalbvWze+wIAbgRLayv9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8qi/7uLxRqrQjnPyH8P5+ZvmCzcVeWlh322vfKkInE=;
 b=strrEUKlxqJllcJCKxhbBsKnzpW4mxaiVwlirt+L/wdGbWq6EAZUViZcKhlZ5fXOBIdp/oWup1k5ceNNE4fvZ5krMhKzRkCf79Zf779OBOzY9qqBTj2YguB6biiH0438rDE5ucuYSSAWSr/eGeU+vBqyB883ueMptz6WRdMkKSwj4MOkQlM1vxVnlHU1TA7OqyPnItfSpIcjYGKqmBPcfJmB134GZ/m6djBq1WqWXhIf3MHGrczIRiiZuhgQQz1tGd2B8N/vBOHg2naqONWjOBzd9bH0pqQ+XVz+qF+dNHD0WiPTZlDvCIPCKUd8vlYP7e0KulmzFNy7ITWEOXYu1g==
Received: from CY5PR15CA0079.namprd15.prod.outlook.com (2603:10b6:930:18::15)
 by BL4PR12MB9721.namprd12.prod.outlook.com (2603:10b6:208:4ed::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Wed, 17 Dec
 2025 13:41:14 +0000
Received: from CY4PEPF0000EE34.namprd05.prod.outlook.com
 (2603:10b6:930:18:cafe::f7) by CY5PR15CA0079.outlook.office365.com
 (2603:10b6:930:18::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.7 via Frontend Transport; Wed,
 17 Dec 2025 13:41:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000EE34.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Wed, 17 Dec 2025 13:41:13 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 17 Dec
 2025 05:41:01 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 17 Dec 2025 05:41:00 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 17 Dec 2025 05:41:00 -0800
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
Subject: Re: [PATCH 6.12 000/354] 6.12.63-rc1 review
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ed36cfe8-8c30-43d8-b0ba-8545127ab587@drhqmail201.nvidia.com>
Date: Wed, 17 Dec 2025 05:41:00 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
 CY4PEPF0000EE34:EE_|BL4PR12MB9721:EE_|SJ2PR12MB8649:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bfb574e-7ed9-4d4d-a5d9-08de3d71f255
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?UU53MStFblNEcmdMa1A3UTNKMDd6Y3NoUElXRGVlQUUzNnlSTnJFL3V3N2d5?=
 =?utf-8?B?SklzWFJGZkdwclBnV1ZVTG42cWhDZGtDS3U3REl1K0FhaDNacW13YmgrK1Qv?=
 =?utf-8?B?Yi9FMXN0TkgxeTJQb2c0KzlvcHdzRFhPcFozUjZxejVramV6QWZ6YjdKV293?=
 =?utf-8?B?aEo0bjdPb09zRUxCbUVsRUpHYStyYS90UDJxY0R5RjdZU014SnhpNTBBaWVS?=
 =?utf-8?B?akVielBJdUsyVEVjNGZibG4yeElZT3BaNndDQXdORWlWQjdOVUNmZVdJOWpR?=
 =?utf-8?B?cGhmRjd0YWI2QktNVHdURFBuSGlJWHkvb2ovZ2hjVFhjaC9iRFRxMiszRGRp?=
 =?utf-8?B?UWVVVkpZVFhzN21ya1F4ckxlQXBpam40U2JGcXZVaDVXczJ5WEVFVmkyTDdO?=
 =?utf-8?B?R1dkdE5jZGVsTWFlTUhmWkxTWlhnb3FHa0t1TlBXUFQ4aEcxVDBlaHlkSmEz?=
 =?utf-8?B?cFlBSVR6b2psNEFSWVlkVjQxMktvUG9rOXd5YnZNbEV6dmJKK3BacStvWlpj?=
 =?utf-8?B?d0QwcHIrSWhXYXZrZmhtQmx3WGtrdldkK0xXRWV4d1NieW9zaTVpNWQ5eHVK?=
 =?utf-8?B?M3dTYmdFT2hxU0RTdzNHNUx5ZXNMbUxoaG5GK0hWNGYvZU00NGlKdTRjSENO?=
 =?utf-8?B?MnBkTmp2ZDhacEpkMzBGZ01LUDViTHByZDNrZ2hmUmJYcmk4d1luYVVwdGJy?=
 =?utf-8?B?a2JlU004QVRoR25EQ084cTBkd3Y3OUlzWWxCL0FOTDlDTEVDWEZTZ05Qb0Zy?=
 =?utf-8?B?ZGQrc3R1WXVlaTVjaFludmowUVBhS1hrSHZqSnljdHc2SjFWSGhZY0VJQmd2?=
 =?utf-8?B?ak15Rmx6cjZ3TEtxUHd5WStnd1p4dWswbXNIa2ZTaXdyMmdFSHc0S2pFVEsx?=
 =?utf-8?B?UFhjYUJZYXZRU1c5V1AwRGJxdmVjNnlmcHRLOTcwS21sdUhpZEd3a2czcnJh?=
 =?utf-8?B?cUc3OThtSFp1cG5MYWl5cXZSSFQvbTlCRCt2dGptWFFEN281b0pHbklpNG5T?=
 =?utf-8?B?bFhnK2wvMTJPalBzaVBRS0haampmV2lLQm55Mk5TYU4yZ21xSjAvZ0QzOTJh?=
 =?utf-8?B?cTJya3R2TU9odW90S3VMVE1yT3lqald2Tnd2dSt1TGJxVzJHTXl2Z0g4VkxP?=
 =?utf-8?B?c0ZYL0dVZFZ2UURCbk9JTU9MVHY5R09vUGVuT25zT2YxZGpLT0ZORU1HZEt1?=
 =?utf-8?B?bkplMlJUMmx2RlZJM2RRdjZ6UUlySkhnQzk2NW0ycWhydjhxbTdWaVJhWW01?=
 =?utf-8?B?QUIwVW1lVkozbXJPTWRtc1haNzVJSXg3NUxOQnd4OXFYWnRKSnBDbndCaUxl?=
 =?utf-8?B?Y1IzZFNESStkM3R1RVNaVGZLTDc4L2NqZnNsQS81NnFoZEtaWVR2ak1LOXBz?=
 =?utf-8?B?Qjg0VmlWeURjVjFwMzdxbEN3SXJQZ3dwY3VYUDlrNnBhbDJKbGorRFBreGNR?=
 =?utf-8?B?VkNaRnd6UGNhV1hvSlk2R0IyL01jR0habXpZZGNMVXdaMC91SjhybHJhZGtp?=
 =?utf-8?B?RzdhSGpLaXRic3dCNHdsalJxLzdPd01QMFBXU3Y3V3RoSHJLZklhTjZFUWdN?=
 =?utf-8?B?Y3lNMDVHZm1vck8vaWpsWDJkWkF0ZVFrV0JsVzF4bEZaVUJWWmtYNFV6VExx?=
 =?utf-8?B?UzJkajR5bjhBZU1DMFlITXBjVDR6M0N4bUxNNjczQkhVbktzQkJYOVRRRzhH?=
 =?utf-8?B?YlMzYUxQMHRqQ1dYek5USTFkcGJ3U1BnTFJHVVdVSlBPSHZQSTVZSkhQUVdy?=
 =?utf-8?B?cXdHSTdCenVnY3NUUHdnZm5SM3N3aU1BeXlhRmViUXphbjBCMEVhQWRwcGFN?=
 =?utf-8?B?RjZ3RWpMTDdrU0hleElIRGQ2NEYvVTlxdGpnOWhGL2FRYUdsQVRRbFRNR01u?=
 =?utf-8?B?NVYvS0M0cmVRMks3Q09mLytENVBDVk1STm9nK1d2RnpGVTRtQzJwK1FKVnFH?=
 =?utf-8?B?RnNVV2xHSVI3eXZvTnNsMElGdlVNRWJkU0U1eFZYd0JSZW5jWDVRdmVrc0o3?=
 =?utf-8?B?WHg5a096alc4QVlvcWF0RDVnS1B0aklQRXlXRkIwQkoxRzUySVFiTnB6ekF0?=
 =?utf-8?B?WmcvK0tMM25CYlJGdmNPUGRiYnhmODRFSTVYWkpJeGk0cFM5cEtrL0l1bGpv?=
 =?utf-8?Q?Efm0=3D?=
X-Forefront-Antispam-Report:
 CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2025 13:41:13.8511
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bfb574e-7ed9-4d4d-a5d9-08de3d71f255
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
 CY4PEPF0000EE34.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9721
X-OriginatorOrg: Nvidia.com

On Tue, 16 Dec 2025 12:09:27 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.63 release.
> There are 354 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Dec 2025 11:12:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.63-rc1.gz
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

Linux version:	6.12.63-rc1-gf8100cfd690d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

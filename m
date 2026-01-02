Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013006.outbound.protection.outlook.com [40.93.196.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD182D3733
	for <patches@lists.linux.dev>; Fri,  2 Jan 2026 10:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767348828; cv=fail; b=ONxo5zSCmosR3pF1mvT+DkzJyKjwLvhg8mISyM6owW3w4aKyHBqva5+JcnKIHP2KKH/nKBHH0xhBfdegmue7B7o8iLivlcXHlSfxZJmphUBksfgFye6fJcmep9qbdO5XqtWCLtDsxMYNVmoDE9jKEhroZYjrCPhJBbr8GMm4/nQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767348828; c=relaxed/simple;
	bh=AgIm1mN1VsYhJzsSx4a0BpqTJHfolUr4aTUeIMithyM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=qlbC/RLitjkH/7XxmrEKdoCmqyjb1erHYQzk/B5ogU085uFbHnaz1xIAG0hZ//2LnDo4YDPK1xIESpoYnEb9vP0ILCVxYGFAclU8O5mfjIsSUkIHFWf4KeM0FboXu+N5FWlvO836x4xletDxyLkEvPA+6blVsg0Iv3uF1SVnvrM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=B69ESZgC; arc=fail smtp.client-ip=40.93.196.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="B69ESZgC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BSYvalczJtNyuH6iLdbpNUujVmOJ6Nqmj7SDg+146lTH7pCN/sXnt+0p6FuDxuM3VoBLnr22W3BiReCwbUxdsjOnnHQP3IKvd5NsTNIZYeAA58ZK0pYuiucN3rAEsu9xLWzzDVBkK8Mmzn3T4e75se2LvS68WoGfdQ2Fj7NjKNUI7t35rB7ABidJkiYi3djSr8Ikh8ptSeQfvFXtVby+pERqZstANBw7IdaBYGl7P/KPidLbkI5xt14erIuBihMjg8P2WB3p3BZ7j5OfVey5QlUYkDMRAsYI53wlDR+AyP6PQsqsvPtuPlHC9cn58YBXQ4G7qNq3mj8WcJVRhSW+mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=78FNABX3zdwUtUWdTqU4BVh+Hv4QCwUdw2wNGSK7Rgw=;
 b=cn9scDlbEUtSOROjXkrhrQqvPuKPpI7SBKlHIAXdiYaxBEhnDVOcDFceVyw59CNs3iZjDGaUp2JK8mrFCC9HsAs8nuFp+GYAN5jm8kEiebznvhiA7BHpQhl4AP2N/nwFt8j0uNgn0XStwx2DfO8UbKgTrRtjU0hlP4woLZKwW5Z+WbsiW13jykkdxDQs+y4wfs5yLONh2ESoVooIdniyEDUwPldlS6JjsZHOFJkB4N7tNB6J1Oh0fjNBq9D+d4Z0hCYSdttDpfx4/iWZ30vmLGZoZSPP1gJMK59dZ2KBb9O48BYGbAqGcRkpcluHHAuUr5D+B+pV946NANyvMdjqSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78FNABX3zdwUtUWdTqU4BVh+Hv4QCwUdw2wNGSK7Rgw=;
 b=B69ESZgCedefLIzz1Y1PJKy4rK3NusOT9uj+r9vMLhKIxS3wPUL29Rzei1qXZtc4hfGB0hfupZzpEI6y/pX0Ikix5vXmK3Lt40CCUV2K6JUFConIcmdUTHA+o2pMU16vYWU/H4KhdBniuWwwdTnrEIgzcoPQP23x/s5EP1UoqQW+mzgYXebFZP/zociD8xFzrHWK9idelUSVBBb7lcD4ofN6RQjDypxlIf2IzqZ3cbLHkn3jXGTRcUfw/Ukhl3s82McqlWaVCxgBKvEWu6mZoCoMgYRbiLau6ZolvhAoh12EqSg3LTJX1DbjTkxSg9FNPREEc7RZ2ZsPrAPCoJ4Yug==
Received: from BN9P222CA0001.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::6)
 by CH1PPF5EBD457EF.namprd12.prod.outlook.com (2603:10b6:61f:fc00::610) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 2 Jan
 2026 10:13:42 +0000
Received: from BN3PEPF0000B069.namprd21.prod.outlook.com
 (2603:10b6:408:10c:cafe::8e) by BN9P222CA0001.outlook.office365.com
 (2603:10b6:408:10c::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Fri, 2
 Jan 2026 10:13:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B069.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.0 via Frontend Transport; Fri, 2 Jan 2026 10:13:42 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 2 Jan
 2026 02:13:34 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 2 Jan
 2026 02:13:34 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 2 Jan 2026 02:13:33 -0800
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
Subject: Re: [PATCH 6.18 000/430] 6.18.3-rc1 review
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <34f7cd37-304a-4b2b-8a78-811091f811bf@rnnvmail205.nvidia.com>
Date: Fri, 2 Jan 2026 02:13:33 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B069:EE_|CH1PPF5EBD457EF:EE_
X-MS-Office365-Filtering-Correlation-Id: bba1e204-ef0e-49cb-23cf-08de49e79b38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Wk9yNXFKNGhLbktUVnp1eENzUldEVFhZQ1JZN2FYVUE0eTR5OGozTEpLdFRh?=
 =?utf-8?B?dndqbjg5Wk9iV05ITlBmWnpwNzVSb2c5dHBXWHY2VmlXbEpvMlhQRkV6enRF?=
 =?utf-8?B?NzhxbTAzTkd0N3dmOHJMTFpKaGVBVU5lZ3A2QlZqNmxhZWgyZU5zQWVuRkJL?=
 =?utf-8?B?NVFjRFhtQndUOFdiek5QRzEwNXpvVHU4ZndLcTZmZ3dqSVZDVzMxRWFEYUlv?=
 =?utf-8?B?LzZRdDBET2ErT0VGVXBxcmdmV29pRGhXaEVIRjRmOUdyWjF0UFBuQXVxeVZm?=
 =?utf-8?B?ekZWYi9hL0UxQ3FjL1QrOTNVU1FWa0hkZDVlRDRQUVU1VnZMd3poVnRHcXBu?=
 =?utf-8?B?WjFWUWpJRzR3WWZVWlo4NmZYSzBlc0VRWFpaUGJPbjA2K2VHbVFFRFJBZ25z?=
 =?utf-8?B?UXpwYjB1Y1hIV1MrRmVndnBUT2N2SUFYVGd6ZlNvNGtSRk1RcjVlL2FyR3dR?=
 =?utf-8?B?K3Q0WFNkZUpkditLWnJkdnVTRm45VnREWG1xMkxxemFiVVkya3orWDBMRmpl?=
 =?utf-8?B?bEpYMVNuR1hhSnREaW8ybkJPZXlVSHNqcU02ZE9KNjhDR2FvZTF4RURWUlBG?=
 =?utf-8?B?a3M2bGV1VHJJWmNxakc2RENFY2hjRCt1UnRRZDBheVZ3WTg5a20yb1g0aXlN?=
 =?utf-8?B?Z3ZIYmJ6d3k5d0lXM2swaVphaEJJWkVTODI1UjJyZGswalFKNkdGallicHJi?=
 =?utf-8?B?N01SZDFpZ3R6TTVEUjBreHcvS1FUejBTVFNXaGhCeUtkUE5FQmdvdmdIdzlP?=
 =?utf-8?B?cnJvODdMTEpHbTZrTEhUTkVPc3hnSUw5UzR5TURBQk40K1NGVDExeUY2MzNN?=
 =?utf-8?B?MUpxckFFL2pPdWhRbXlzVjI4R0pQN2dGUHFjVndIUVJ6Vm95SzNRUjhiYkhU?=
 =?utf-8?B?cWtOQmdodFpjQ2ZHOGN3cFcxYzBzYmM2VURxZ1B5ZUF3aDZrRDQxRUZ2dVdp?=
 =?utf-8?B?SzdGNkVVbHp5c2hrVHBEVTRPMEI5V0JqVWRsU0pGN0FnSHh5Q3JCa1U4V0Vr?=
 =?utf-8?B?VlZMempzcEtTeVI1WHF6TlpYdFh0dWYrM2pRMU8zdWtxRVFDRWZwTFF1TXZI?=
 =?utf-8?B?eWw4WHh3TnFTWlVIVXpQRFBqTEk0SjA3SVBKMWxUNVpkSEk0OGRjZERadUY1?=
 =?utf-8?B?bmtTVnZHTGlzSERudzFGWFh3WldkT1RZdDYxcGdaN3k4S3Q3Y2xDREpncnNT?=
 =?utf-8?B?aFFKT1ZxOFcyd0hGdjBXWmdaRVBaUVM5cTdaQWpQZXJJRHQ1dG1xKy9nV29v?=
 =?utf-8?B?R1lYK1Z3TUZRdFJwa1pzOStEOHNkMlFMRkZiZmhJWVE4NVlNZ1owR2xqRGs4?=
 =?utf-8?B?aGN2WVNtMmNSVWlYaGR1c25wSzNtVjgzTkNWbzlzVHBBVWpCS0J0VTRTTlVz?=
 =?utf-8?B?NUtxamJlYVNsa01tK3d5dTh6aXQ2YllEenZONE5NdjF0ajVHTnBDazJhaklx?=
 =?utf-8?B?YjVzTDZpeGRBdmJaYmtNVlAxUnV0dFVhWk5HTFdUZysvSjBKRzdaYW1DTGg4?=
 =?utf-8?B?WEJyMW5CdllKME9OdWQ3SFJ0RHYvTE9YUTZvcEVyNDBOelJDdy9WOEJSaCtr?=
 =?utf-8?B?dSthNEpqbnJHZ1hXdnBjWDBjY1hidUE0QnRLaUVnZFBBYjd1T0grUHRpckFq?=
 =?utf-8?B?RVpMNW82UnV2eFduSXJ2OTE4TitraVljSnJOMWg1N2x6WExtUk1EQ2psY1Fj?=
 =?utf-8?B?c0pEdmpjdGR5STdpZUpqY2dZZUowdjQwZk5vSzc0L2MrUVRDb1FNa3JuUlFQ?=
 =?utf-8?B?dVJUck41bk5CRk5laWpLK0tEZEE5MW1RczA1ZWVYTlZCblhSS1VxeXVXRXY2?=
 =?utf-8?B?ZitqdlFobm1VcXI2V3dOMjczOGlJbTNmdVRaZXdXUjZkcUJ2NUpUaXJuZWc5?=
 =?utf-8?B?Z2hKRlJxNWUwVndROXBtcFp2NXROQ1IyVnhBelVUeVBtc0ZreU4ybmRQQlla?=
 =?utf-8?B?d1R0RnV2ODlCdzNVUGNoQUwzMDc2QzBCS3hlS2dQVm44VUdlcFJZYTNFMHJw?=
 =?utf-8?B?bUZ0LytLWFViOE9DTjZjSGZEZTBuZnFyTHI3aEtjRmJnd2RZRHM3V284eW8x?=
 =?utf-8?B?TWFVRUxjMURQNDN0dk1KQW05b2NhY2tibUZ0b3pmZVhqRVRRYVFwRlAwWC82?=
 =?utf-8?Q?R41E=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 10:13:42.1750
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bba1e204-ef0e-49cb-23cf-08de49e79b38
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B069.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF5EBD457EF

On Mon, 29 Dec 2025 17:06:42 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.3 release.
> There are 430 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Dec 2025 16:06:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.18:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.18.3-rc1-g685a8a2ad649
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

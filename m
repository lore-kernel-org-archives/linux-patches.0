Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2048.outbound.protection.outlook.com [40.107.92.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2591F790F
	for <patches@lists.linux.dev>; Wed, 18 Jun 2025 06:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750228926; cv=fail; b=IX341HSwvqmijDYnF6OiK/EjTPv8RBAuAyjWcqK7rUvBUZ1qFMLWCmxeRAQbLP+OeAc/0Nl1JtA2j+GT3vnMe8XLYzY7y8gWY49xEakWDFx5TazN/b7FAx7b8/dXJPCaEvWsFb0KHP+tE86PytZWwlLVOwLlIet/Eh1thMkwPRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750228926; c=relaxed/simple;
	bh=rD+Da0+hjby30PwIDjKQAel002LtEmwMXq9HRuxBUiQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=HrYLOen32NbBOHD8CIif5Jyx31v++wi2BoUgktJI6FAXtULGVj3LpgXXw2m4r7I0dLUNDT0TqhiKhv3Hpu3y7qsGODsKbPawrJi26gagjGX+qzik97lan/oQ8vDHYHGwF9T6BbZeciWIH3YnF/t7SyBAkMePLXHQqPUy6i3vB1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=elTaoz13; arc=fail smtp.client-ip=40.107.92.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="elTaoz13"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bd8l/Y6rT5ylC07b5YaAT02B8sJQNi3GQjoYXOar0Cgezd2KzGTIGI5urNV4SSkp2EqERcq3gJzk/pREaxDk8ttBpU5RcnoEd8eTS5iq3m8Te3QNYXdu1wHFi+lBzEwBLm14bJrO6I7C29sgu0Ef1aGhtKKPYUqgjXx6nLPfb2tErYZmzrmu8PgGpJ4OJBnp3oJ1p4v+ep3OAHMIjAgAK3Af//GtTwcP3H/efiLz612H5uWe1EYznir0DjsTG91BkNKc4Do1HI97iNtANThKMbZbxOMqMO8WLXU7pZj4zwc41L7n06PDsJj2XZzwGBgpntEEBWDoGBX+RboEBSLUzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WWDmDilhmFNkZtoVxXs30vvX6UTyJs+R3+elO0Aafrg=;
 b=CiO82cs4/ap7UZwZoapt99qPjRCIR2plvHvQmF1p1vS0lEuFRWwqWtvKdipPg5MWAZht4L809G8cdtA90nM1mPbUOtxS/U4aRAscDAyLZBNdyzxzx2tfUrFHH+yO7ciEJHFcXLsdlv/vQSbvhlXf6Uo7e7oBGwtGnmIFeG5iLGLg2DcImX6RFTIiG8PZkVcQAC5oKuUj4J/t7lwc5gOHbyUVGbWCN//Xyw8S/rvBptcmNjSvgSK2eGpmSBvlHVbvTDRYXEoLUHarxx++SdYzwAUOBnQNfixvu1rEX5JpQcatuRGzcI4ntx7shehMMoICccVX02RWLtQDQimbfR9xew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WWDmDilhmFNkZtoVxXs30vvX6UTyJs+R3+elO0Aafrg=;
 b=elTaoz13rU6lss9V+ef7BPX/GXALKqKni0fqzAWpPpe/dRfR5zROwBLL+D4E1Y4SFtmz0TQgprNmTzNzeJ7A0BojjAyGvFddbsZBMapkx+/owVOds7i4meaJKOtZl1mN9EPQUWcV1mho3p90KSOIgVX5bvBF2XXJIuzhK67BS1yXOdgqhC1qbpyUtIWV6jvm2rv1LTPRpToireuXN4SXLqJvRTX44koP/pB4Vk6mFnfhHf/i9410zoIUoPUplRO0YgfpkPTQ1F72ilLF9yi38MKSid3lsbPu5R/wXCbAbGwXS1cEJ/5XG0zcv70fNW7bMXPlmwRtcmiXirrFCBYeyg==
Received: from BL1PR13CA0301.namprd13.prod.outlook.com (2603:10b6:208:2c1::6)
 by DM6PR12MB4354.namprd12.prod.outlook.com (2603:10b6:5:28f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.20; Wed, 18 Jun
 2025 06:41:59 +0000
Received: from BL6PEPF0001AB75.namprd02.prod.outlook.com
 (2603:10b6:208:2c1:cafe::ee) by BL1PR13CA0301.outlook.office365.com
 (2603:10b6:208:2c1::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.23 via Frontend Transport; Wed,
 18 Jun 2025 06:41:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF0001AB75.mail.protection.outlook.com (10.167.242.168) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.21 via Frontend Transport; Wed, 18 Jun 2025 06:41:59 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 17 Jun
 2025 23:41:43 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 17 Jun 2025 23:41:43 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 17 Jun 2025 23:41:43 -0700
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
Subject: Re: [PATCH 6.6 000/356] 6.6.94-rc1 review
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <deb43f08-b92a-4481-845f-d8b87e052b0e@drhqmail203.nvidia.com>
Date: Tue, 17 Jun 2025 23:41:43 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB75:EE_|DM6PR12MB4354:EE_
X-MS-Office365-Filtering-Correlation-Id: c9d46a8b-bbeb-4e53-072d-08ddae3339d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VUVwR2FmS25YTEdjb2c3ZVh0RW94c1FHeDV0emF3b2RtT2tuRTk5enRyNVE3?=
 =?utf-8?B?UkFEdkM0VTNBdmEzUTY3QWkwRUhieXRvY0tjNjd1R0g3OE5SMnUvUkVaakZl?=
 =?utf-8?B?ZnAra3JPV1JjVEFpTWlUY1JvL0NxenY3anpGQ0NxWUljMXo5cDVtdmxwZ3F5?=
 =?utf-8?B?RFUzU3cvd0w0K0h5bWlQY2w3REs1SHViMTEwdElhMzNRRk5QM1lwckdrbm53?=
 =?utf-8?B?RDJDRlNnNXBjcWgveGF2OUNYN1dxb0NLQ0ZBZFZoSlVKV25WYnhIUXhsWmRS?=
 =?utf-8?B?ODl5R3lOSzFNQVIwanpTd1BHK0tHUm15YWUyd1pTamgzaFZ2S2xUcWt2b3No?=
 =?utf-8?B?Z0RJQUNBc09vbFA4MjdaVEJQK2x4bXlZQ1I2eVRWTGNBQXlhV3ZMT2d1YWpW?=
 =?utf-8?B?U09jT0FlcEdIWDJQZlZJSms4Q1pSR0dJVWVYMDRVaHFyeUIxWStqajJEdnU1?=
 =?utf-8?B?Q3pSS01sQjM5WlZMQi9mM2daY3ZQcXQvYmpCeTZDRVBTTTJIbzRBWEJ0ZVhz?=
 =?utf-8?B?dFZoM1d4QmFxSXRFUG1UdXpOcWhQR2FCVnpCSS9IMFVvbDB0eHRJdTRGTEhT?=
 =?utf-8?B?UmdTVGpEdGpRR2pkeGgwb3JveGxCdmlEbmYvZ29sUmdzV3lpUFJKSi8wL3RB?=
 =?utf-8?B?enI1V0NXT21tRnAvT240azVzN0NsY05zbVJpMm8wV0hoNGtSRnBxQzVjNUJY?=
 =?utf-8?B?YUNheTNSRzVPNzVsbU5GeVN5WTcvekN3dzZVdlFTOXJ0VG50bHdDaFJ1dlRJ?=
 =?utf-8?B?UUhEUjBwVFdRTU1UZTVhUUx4clBvMlNlNnZBZy9UTGxoZUZxY2RlclBwUkxv?=
 =?utf-8?B?UmRncG1ETkx2M2RlR2E3UUowTkhoRXF0WFFTL2U3Vm9tTlNtTkQzRGVkR1ZC?=
 =?utf-8?B?bWV4WXFidHkrOXBrSVZoRm1HdzREREp5WEkyZXlaeklUZkpsOURXR3QyN2VL?=
 =?utf-8?B?UlRsa1Zlb2U2VWtsbmVqTGhiQzNoRURWbkhYaUpPTXVFSDIwSjNPK1NNWkNp?=
 =?utf-8?B?RGcwUjdlZ3B1QUlyeWpRZ3RxU2doVm95Wk1CTElla24vTmU2ZGpMdk9nZWFT?=
 =?utf-8?B?WDJOQjZ6c2FtOVRsV2JadHkrSWJGc1ltd0RXekVKbzRHbTl6Z0NjT2szTDJF?=
 =?utf-8?B?ZUZJY1lWOXgzeXIvYitGVWxjdkM0ZkcyQVUvL1pVUHJZWGVzY3hCb01jc0pL?=
 =?utf-8?B?V3pOaWZyUWNVOWVoaDVlRS9Tbzd0L3UyRVR6bVZxNTNWVGxpcEVNclk5R2RJ?=
 =?utf-8?B?UXNRVzFXeXlnemQxdExERmhRTGVOU0tWcE5uUzJUM25FMlJuOHJLUWtaejZw?=
 =?utf-8?B?YkNSUFZiZVE0S2Y5eUZUSTNWMlpaaGhMS3F4dnJDN09iVzZydGltcE9FREw4?=
 =?utf-8?B?ZVFjQjdGcVpNakZSQnZqekRORWVMd0xtZ3hsTnU0S3h5ZEZscXFCYkEwSXgx?=
 =?utf-8?B?LzFQdEU1QWFrRFNMWFpJNW12YnpTWnR5ajJYUUlzbzRpWDB4ZWlpZnI4YVph?=
 =?utf-8?B?TExuallnSkQ5UkhoQW1Cc1A5L1pxaGlNUENmN0FMVFRJaXRnREZneUdrYStn?=
 =?utf-8?B?ajB6Q2FZZWhoSlk3dTBGTFVDZUE0dWtHN0YwU2NFc2lySThrQ251WG1ITlFa?=
 =?utf-8?B?Y24xd3BIUGo2aytuMTBrekJJWDVCMFpLTE9zZ0E4T0swcnVUVUhYNWNWYjd3?=
 =?utf-8?B?UkIxcWVJWHNjNzFHM0V5cUhacmE2a1pJSkNoVlNEVEdjWjlFU0duZVp6cWM1?=
 =?utf-8?B?RktMTGJYdkRnRHlhVkgzT3U2WDlHUVFXRElxNDlRdGhRM2g1d2diZEFwbFI3?=
 =?utf-8?B?WEVEOHVUNlV6TGFiUGJwUytKdlgwYmV3SVRDenpraTMvMndTZXJUSVRYZWF6?=
 =?utf-8?B?K3Ftek1SR3FFalQ0ejBmMXFoVjZxTmk0Zi9EQnFMTmx1QXVjMkJvaWZYc3Fp?=
 =?utf-8?B?MHh5cUhsaXV6VFV5ZHRhVHhKZnVjK0VLdEF4ZUFocWhIb25WRkdndHM1RWZ1?=
 =?utf-8?B?YldqelM3Vzh2WXRhdUlJeitWWkpEZnJmZUZYejFxd1dHUGNOOGtUOEJHbHdW?=
 =?utf-8?B?NTZVbEJvMzJNWTRLeEI0d01ScmpFM2tUVlFXUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 06:41:59.1148
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9d46a8b-bbeb-4e53-072d-08ddae3339d2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB75.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4354

On Tue, 17 Jun 2025 17:21:55 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.94 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jun 2025 15:22:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.94-rc1.gz
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
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.6.94-rc1-g7ef12da06319
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

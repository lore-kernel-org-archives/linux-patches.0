Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011059.outbound.protection.outlook.com [40.93.194.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56895345CAF
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 17:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761671057; cv=fail; b=jZDIZACN5YeaU9FcEWKDhbGt2UU66JuHS2y2h5rOIrXRbji9INhsEYSLgkJReyhKyWN2Zh/anz6uVXnCC68gH3drGL4kpAvgXI4st/MpR/Pf2FC2hAVmaJGUCcAV1/uouJex2gh02UlwdCXc+dRcuwX98X64+0qFyJPieG5ELUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761671057; c=relaxed/simple;
	bh=LQ8UH5iTp/9mtdZEAhKbEuwp8RwCx/S3xZpzX1AYNYo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Dcr1rBE0LinWTgHQwUgvLzm/63Qrc+BpSglzY5tc6pRtazDLqinRuCGH026Jb2mE/DGsDPwSh6t4Or/zB4apzMy7shbCOGnEFss2wPbYzbKBs+wb1scxip6i2xKzXuDFZhOxOKgdc4R6eVA4w2q5fTvegqGuD3HLvrBLLb3O0d4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FXpEb+rJ; arc=fail smtp.client-ip=40.93.194.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FXpEb+rJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fgLKWzsnJLeTqsdJqGs5RoNNKew5xmDxlTmvwJeDNAi/0XyJEZmdq4zNA9n/sA9UfBLUCD1udyQX4jDChWG5QLUkj7gjwHQmF7rXr4goPpkJVN4YePfp9lpVBGYrUn0amajD8LMTtMWcdKPLx7Zy9qd57rC1FSr0Spi5qfueZckW/aHkgSVXSB9HNw5xf+0V+SV4KITXnySkdV60wERYIr3iXFFp50v+i+c5zcDIuDHmI2eAPiVcWhFmNq3ZrdVugvuF2m+kvgZixeh588WhTa+/FSWyr8Vp7vTBBiiWYW0U7hfAiCqEpEakavk32fjzp6kif9mcMTWP+oD+8kL/DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0u3czfAibSpoOeYqx+R3NIaFIUC67/nZTE10J4+W3lk=;
 b=k1jSy7CyDSWQf4pHxAjE9kpGU9J8bEPAbQdIb0OVhsbQ9iCPXa4j0FXWoC0lN5/ZFFvs1bG8etwrbJamtbqLGRnOx8Ys7B9CE6YAeu43PSm6jx6sWlsknaL0tr0J2a+/tKB0nL3Et+L5f++oOowH1bLZHXnUdsKMKLuSxpbl6w3fzz6RG8PqlTuMk8Gd48KhcSGQdKtaeXDT9b5IJ0tTUHwjrU4dCk4D/evdQCv3d0TvUGdcUvhGQv0tEkvAnf5pWXS2xahxunpPy9tAmxF0XSxIfBtDkjXazvaZtFNa9+1C0g8sM/sH7TzeWGoy/WzGtIeC0vfA3uFXvRe7vWOeDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0u3czfAibSpoOeYqx+R3NIaFIUC67/nZTE10J4+W3lk=;
 b=FXpEb+rJiCAooL02fK8+poHZ2Rd+ue/YK+Xxwo18qMIdfJHyTpMJ1rRgiy6KcBKLoDRQHIBp6HV3oLhKXRBq+5hBemIUC09i5jStpVicQw17rNFYLae8jbG3jUWcHKDJjZJEHzyH0q88Xh3B+0CMKatIp37OWoz6440BskT2cgaY5DUcesaZDTE98YhIiWNHU8yyfqLcaIZ6UuSxef61rlCoZsWv+7BFo4zL6wTZsTeG19dxkEDaWG9vLW/4EUwKymDixyTsJER8ZNVWNiAheJmG/+PGgwU4uJa39GzMXcP/8tsV/Z/O060MdQUH2KfXAha6974oRfoVdVxfOvmUbw==
Received: from DS7PR07CA0019.namprd07.prod.outlook.com (2603:10b6:5:3af::7) by
 MN0PR12MB6003.namprd12.prod.outlook.com (2603:10b6:208:37f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Tue, 28 Oct
 2025 17:04:11 +0000
Received: from CH3PEPF00000018.namprd21.prod.outlook.com
 (2603:10b6:5:3af:cafe::79) by DS7PR07CA0019.outlook.office365.com
 (2603:10b6:5:3af::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9275.12 via Frontend Transport; Tue,
 28 Oct 2025 17:04:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF00000018.mail.protection.outlook.com (10.167.244.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.0 via Frontend Transport; Tue, 28 Oct 2025 17:04:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.34; Tue, 28 Oct
 2025 10:03:45 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 28 Oct
 2025 10:03:45 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 28 Oct 2025 10:03:44 -0700
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
Subject: Re: [PATCH 5.15 000/117] 5.15.196-rc2 review
In-Reply-To: <20251028092823.507383588@linuxfoundation.org>
References: <20251028092823.507383588@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <7efcf088-319a-4ca8-8338-ac936de85045@rnnvmail202.nvidia.com>
Date: Tue, 28 Oct 2025 10:03:44 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000018:EE_|MN0PR12MB6003:EE_
X-MS-Office365-Filtering-Correlation-Id: b2726146-ae4c-4308-c013-08de164403fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bkVDSUVPWERsbnpQUWNuTTJzMzFWTFJ3enFKNVdiVmtBUnBmZGE0WUFTbTl5?=
 =?utf-8?B?TEs4QzIrdFJ3L29scExjQ0lOZXB3VDR6SGxQa2RDMlhCRElnVWw1azluNThY?=
 =?utf-8?B?MzBrakpNVU9WOWJKYjVGQy95SzZHMjgvR1RTUkVFazNadUw4b3NZd3NrdmRF?=
 =?utf-8?B?blRKbDB2UFNpK1FsODFBODh3RUlwejcyNUQ2NkxOWmZZMjBjWmYya3RhWXB0?=
 =?utf-8?B?Z0UxVDBmc0NneVZIS3IxT0lreGR2WmFJNW5hYU9lbWE2U09WRWh0VUUzTXJh?=
 =?utf-8?B?S1lYVUpSRHBEQ1hrRHJEanNkVUNSVVFmakhQQ2NuSklJK3NPMlYvb1Bmdzg5?=
 =?utf-8?B?Y0h0aUhjSDZwSndrb0JxTUlBRENMaHUxalVWVGdvMlJJK1llYzJrcFFHL2tF?=
 =?utf-8?B?SVpqcGlzMnRNNmt4azA0TURTbzZIeDF3TXlxR3UwRFpIZy9IZVYxNTNCeDFr?=
 =?utf-8?B?U2ZNcXBPRC9ZWkk4NTJ3dldJSTVGWEVpbFpJYXVJaENmRlpOTjY1c0JKOEpt?=
 =?utf-8?B?ZW1oUVVSTUwydnNYczVwemg5anpzUFp5ZFZWRk5YKzJmc0pxU3pQSHFkS0ZC?=
 =?utf-8?B?S0JRVkRyWmJadzdQRUNGZU5ZY0pNa1h2R3hYeGtEK1dYT1ZaYUZ4djV2d3hM?=
 =?utf-8?B?RjBZSVBWbkxQNGVhVWdrVUF0dGlCM3FkbWxRSnNUTGJNT0lVTU5jSU9WdndQ?=
 =?utf-8?B?cWZWY0JtVkpDTVAxWTdzNUY3L2IvZ0tUK1pUQjlaNnRXZmJLYWZUV3JuWTVs?=
 =?utf-8?B?Mm04clJmdjUvNG4xK2ZINlk3NlZ1VnBkR1l5VFgzMjVVM0dWdFZQTlNzTFpO?=
 =?utf-8?B?czV3Q2k3WlQ3N3A0WE9OK2pMMDgyTndvbm5qUWJlenhmN3A0c2JGcWIvd0NI?=
 =?utf-8?B?Kzcvdkh2UUY4blN1VEZLUUNyU3dzRno3bUliSUI1bWhPanZMTW03TUtaNUFl?=
 =?utf-8?B?enh4YUx6NmlFYUZtY3RMTDl3UGk2Mm9aQlNVV0xWZG53SS9CbUVFNHFSZzdE?=
 =?utf-8?B?SHQxWlA0N3ZvOGhhWGNaZ0RTL05mQkpYYUl5c3FWYTJUT3pyR3lkRjdzOTht?=
 =?utf-8?B?Qlo0U2tGZ1V0L2F5Q3VmVFRnTG9RdWwva2I4WXpSdXhlU0E5c20zM0F4U3JS?=
 =?utf-8?B?eDhjbGFwY0lENjc4Mjk2NFo1MlR4Z0hGeW84WHBxRk1DNWptTlZOYlFVVDFP?=
 =?utf-8?B?ZFczSzFia2pTOGh3WVN1KzhXMThORkVBcisrMVI1NkxnTjdvMTV1VzNRS2xF?=
 =?utf-8?B?aGhTZzhCbFBVdnl0SVpkVGI3RDVOYUg3cmNJWE8wSTMxWFpsaU5sbHA1azlR?=
 =?utf-8?B?aU15alVsZ1VXZkZOdXc1RGhSZDVHc0JxSUNsYWJ0OHlHVkhGZWM5ek5GUjBS?=
 =?utf-8?B?dEZHZkNSbnh2RS83enBhLzhMVTFYTm5qQVB3eENzU2hSRTFGdWNXLy8wQURt?=
 =?utf-8?B?T3kxUkNpbktMQ0s1Mk9qbFE1SGZhZzB6elBkMFVhdlhESVowM0xHL3dib0Nm?=
 =?utf-8?B?cHJ0OGR2TEEramx5ZjNHSDVVYThkRjdKSCtDUTZKWThqSlJoV0N4QXJieUhm?=
 =?utf-8?B?V1pSVitrdm5oUHJUdTdaN2RCK1RJaDg4bDZkWWZHc0VqTEUxenNvYTF4MVIz?=
 =?utf-8?B?ZUFNYjFwVy9BMTc0SHBFQVJKeTNWM0wyb0pTR2tkQzN1VDgxUmdHMEgrdEx5?=
 =?utf-8?B?NDlpS1ZjYk9uUHZIak5uZmZQUzVMUzNINjRnTS9PREFxU05kWlgvQ2I3OXNt?=
 =?utf-8?B?V3dlTjM3L3o4Ryt0SklrOE13SzhQakhTelZDOTNMdVFoS0NBV0xIT3gzMjlK?=
 =?utf-8?B?UGpaQTltQkpjMllrUU1jSldsU0ZjZ1RmZmY1S1RTaS80OGkwSXZEZm45YTNQ?=
 =?utf-8?B?UDRsK2o1NHhxQ3ArMnlLYUZxUW52VE90TmZLWmxSTEV4NjJtaGNCcnByUGk0?=
 =?utf-8?B?VEV0VmFVR1ZhTW5oRGpzMlV6bExGMjIxUjBxQy9USnc0dFcvYm1VK3hzZ3Q0?=
 =?utf-8?B?ZDBwNFUwWjNIUVZPZFdVclBMMktQMDBaeU9TeVlLa3N4KzJ0TnREOWtYVVdh?=
 =?utf-8?B?RE9LbldSK0hZUzQzM1d0djFPd3VCbm1uMU9uT1NCVVFPd1U3ZUdZckxYZTVn?=
 =?utf-8?Q?mnEE=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 17:04:11.2070
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b2726146-ae4c-4308-c013-08de164403fb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000018.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6003

On Tue, 28 Oct 2025 10:29:12 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.196 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Oct 2025 09:28:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.196-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    105 tests:	105 pass, 0 fail

Linux version:	5.15.196-rc2-g59a59821e6b5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2079.outbound.protection.outlook.com [40.107.101.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBC11F869E
	for <patches@lists.linux.dev>; Wed, 21 May 2025 08:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747816312; cv=fail; b=jQEZOueHnSZ8rnC3HGQV74lHlryWElVqlqiyuNy7+/+KBloL8ysee/u3FdvIm25v/uQCwB6ZfPx31s4z6ctJHlwIY8AZlhkMxrvlEunc+HhOVMvZ5JCZ4p3La6QUwLFxJHrbpVM0Lm1VtD5dlhFZFfvTI+t2lWe5RY/h15da86k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747816312; c=relaxed/simple;
	bh=ge2VDSlOybYGgIUCeyJAQez6xxaiwsROvC3QF75Ofso=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=A/VrhqmlMs8GLAqOblmUClYeqb1bBRRnN1aMmbuIzFYtaYQKLKqOBdtAI34qoJ1zHdRw7ocOHBaiCkU1yR5psFtu1ipFHPn75td3EWl1xoIODHAoojqZNGvGHys/2zJIj0yhhACmE25/kpoNe0fDtFvrBCaX9WsI1EDET7srjvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h48pvD6n; arc=fail smtp.client-ip=40.107.101.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h48pvD6n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=csQFehf6oxAfidyvQOOBEUFf53JYHCdykPApUxsgZzE3aduvF1achxmnc5IkklJqVCa3pzIY5kt13HEP1YrND22KP3ZPGYCY1ad0mwrCPYa2w0cvNci0bB5AHUEg23nZp7N8KxQA1cQ+m1m84cfw1x8ph6FpQ4SnA7Kkb4S+vVyHYjf0+24yuK/BQgETueNvcUnAYOytynehkZS5jqpOp8xWRWTroNpPXZqCawaipAE8XqnMeVs+bP0c5OdpUey0W7e6W/6PisBcsloPkAaENeCcZvAe/kQ3YRVtn5miGDDXbVIGoTc8MUADnQDuwnYd0s6+6PoVpuq0byP6UCgkzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CA8k2vV1OIyvnsU9B2e8NgQPJ5i2cbZnT+fJRiSrEYU=;
 b=f9FuDQodrTOC3Vpi6JwaqKPkUC+xBvTI4PUqVTmyBpppIHSJ3TjtIw8C903MywagxNTjo6tMW5CnK6QJrOtaUq16Q1jDqdpkXbIyXDQZFgBAROsHQwjB1YutsUo8OsNRarJLULAQ4R4NDkVARjHUnX6QUr5Utxwh8tiWQgkTN/aizqqQ7RqDVodxo1NvQB7Vt+pgBZLZ0mcIeBs/0sHUWI7Dpnm9PPBtaV3Q0zoBQKYU7LpTHQCcPQz5DLbT99OBx57AfLeefw/NqnhVVqf9aI7Tzc2GHwHO33h20nsI8PFpuBuSWhiG1GSNjsTG79G6xkmUrosCSWy7h2bNBxOWyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CA8k2vV1OIyvnsU9B2e8NgQPJ5i2cbZnT+fJRiSrEYU=;
 b=h48pvD6nsOsK+EJ/w623yEu6pbqLIJGT0Kgn+OKNqvritTuGPOYNKtcXV0+z4cPeRBHd2pFjLo94I0CkkrA9b/1dZUXijDaxSF3ZYjSj9QoS+f7Jl8aPUXWYX5sJ3KjsivTbkJbmPph4KlSXw8E+/lCiWL3AHVPCGuCO4/oA4VZ5Ja0xgSi9OLersQbZ/jS+OAt44WDL+AFV6nxJhnP5Hm+yNi30C/DqFCrybqohjzEZO6OqglUkGQcgbOC8QsqUH0l1Kd2BCiHa/MfX+yXEFrPBjfW9P3QfzOeVInOl98+Ea63F/tR1FVvnsFa/lz1UmLrhNnx71EYkEcvNlMV46A==
Received: from BN9PR03CA0732.namprd03.prod.outlook.com (2603:10b6:408:110::17)
 by MN2PR12MB4189.namprd12.prod.outlook.com (2603:10b6:208:1d8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Wed, 21 May
 2025 08:31:46 +0000
Received: from BN1PEPF0000468B.namprd05.prod.outlook.com
 (2603:10b6:408:110:cafe::e5) by BN9PR03CA0732.outlook.office365.com
 (2603:10b6:408:110::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.29 via Frontend Transport; Wed,
 21 May 2025 08:31:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF0000468B.mail.protection.outlook.com (10.167.243.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.18 via Frontend Transport; Wed, 21 May 2025 08:31:46 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 21 May
 2025 01:31:31 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 21 May
 2025 01:31:31 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 21 May 2025 01:31:31 -0700
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
Subject: Re: [PATCH 6.6 000/117] 6.6.92-rc1 review
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <6a304f08-8c38-47a0-a5f7-4c127d02004e@rnnvmail205.nvidia.com>
Date: Wed, 21 May 2025 01:31:31 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468B:EE_|MN2PR12MB4189:EE_
X-MS-Office365-Filtering-Correlation-Id: 6448eb69-20af-447b-478f-08dd9841ec83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?alBhRVA1dURCSk1LNWx3V1dKQW5laUk5cTdJR2FDOHIrdkd4YXFheTBSc1Zm?=
 =?utf-8?B?OXFQVVpKbXN6bDR4WGxsTjNvckZMMy9HNEIxdFhkUWhpOWxBT083UWtoNVVm?=
 =?utf-8?B?TXpaYyt5ZnZjT09WK2lZNlBTem1CWXFCcHJDVnlVNHkvSkQzUnQ3QVQ4NEp6?=
 =?utf-8?B?RGFsVmVyYlF6SElXQkJIQU9VTGcrSFlPZGxldUl0UjVzd3E2VDJ0Yk1CUmtY?=
 =?utf-8?B?MFhuRExJZnI3M1laWFBoNTNoOGp4VW9TNEFmTkg2RXdpSm5BWCtnZFFYMVZR?=
 =?utf-8?B?WkN5RnM3QlJ4TERvc2xTa2M2THNvK3B4cENJU1RWc0hCbWlJUGJTUVNreGxN?=
 =?utf-8?B?K2dnZ1lUVkhJWlV3QnUrcGZNcERNU0grYkdTWG9NOFcvRkFqYW9sTVdoY0Fh?=
 =?utf-8?B?eTFvaGhhZjNIRnp1MFB6elZDb1pXZHJNb1RiRjB5ZkJEQ1Z1dnpVSW1HV1FM?=
 =?utf-8?B?STlqTzNPTmsxYmQ5UWZ2V0pJM0haUjJKSkhHQ2hSdmJKRmNWMDVkSHRsU0Fy?=
 =?utf-8?B?eWdXQVJIM2tkZXhzTkNzQlhwd0ZtUjRBOGs1WkFVMHJ6RUl0YkU0TkdlOFE3?=
 =?utf-8?B?OE5YYU5hZVVpaXAySTB2NkVvV3RkRHdhd09QVXdvYmxEeVRIWUhadmlHTjFm?=
 =?utf-8?B?M1o2ajdzM2s4cmUwYW1zZlBqL09pbDJjc01rbnNielpNdDV1azVESHUzaW1M?=
 =?utf-8?B?OVVBSHdDa1JuNm51VWphcFN6NUk3Rk9IdmNrTDF3WnZUck1neTQ5cnl6azRi?=
 =?utf-8?B?NWVtSWZ4SUJwb092WVVyUUFDY2FMbGlpSjAwTEZ6N2J4WVRrRCt2eTdiY1Rm?=
 =?utf-8?B?QzcwZ25nMTBUangzNTRuOFlZZzMzYklTeHRid094a0JWaFpSdTRTOVRMeFVX?=
 =?utf-8?B?OW9oZ3M5SGpaNnR0azAyMDhySDVUZE1Ob2cvcGxUUjg1Z2FBVDN0cFJ3b0Ux?=
 =?utf-8?B?T21ycHg3RGtoMm8rVm9aYnQvZU1RNEJrUjk2TlZYckg0UG9PUXMzZTArQXhz?=
 =?utf-8?B?aUR6Z3g1Nk1rNEpTNFFYc1QwbHdvQnd1Vy9WSG9iYW1seXRrMGtKbnljcHdr?=
 =?utf-8?B?Q3BjTnJuVmFsWlNKd1d2OUJLKzR6SStyU3NJM1R2dDlQVVd2bUhEU1dmYmtj?=
 =?utf-8?B?YkQrVUpFRG5HcHJvYXRSVVdiOWtnTUwyWXlyQWp0Y1Uyd2EvSllrdktLR3NV?=
 =?utf-8?B?VVlDY29zVllmeFRTQWFvMlU2a1FSSi8yUEs5bzBlTFFIZDcyTy9STWtPUmFC?=
 =?utf-8?B?RUV1SFdvdjFKN2hxR2FDR1ZzUlRlTEFlVDRHRGN4UkJBTkdxL21GZGhqQ0E1?=
 =?utf-8?B?QmJVZDNkRTFGakJDTVZNekJRemhOb0RjWTRqQ3FzNFI1TGpkRXUzQ3FWdUkv?=
 =?utf-8?B?RTE1NnlGdDlxUlNUamMyajhRSFpGWGF0Z3VDNWQ2b1dMWm9zcXg3eTVpUnNv?=
 =?utf-8?B?YlNUcHlIeDQ0RVVldlZCMkJuMWtKamFXT1BRZk5OTzlUMm9nV2tsbDRMUito?=
 =?utf-8?B?Vzd1TGdCVE9lTXl2R1N1T2RKWEhKUS9yUkhiWHJRbkFJSTVjU0g0d08yVWRh?=
 =?utf-8?B?c0JrMEVtYmVzek5kaC9mem1IdHhGWTlQREdLMng0Snc3ZGh2VWhhTFd1TGQv?=
 =?utf-8?B?MExVdjdjc0VvTDZXRXpHNzd0eEFPV1V1RUtheDdmZkhNZm5KQ3FkVlJHK0hF?=
 =?utf-8?B?WkR2T05QMCtrZThlV2xDdG16bXk5dmhTbWlSMHhNT3lpa25zZnIybVhJSnFN?=
 =?utf-8?B?MG8wbW9rMmtobWZLM240eWxvYllxY3J4QjRTUkt3VlB1am5LeE4zazFhZ3dS?=
 =?utf-8?B?U1hGSkdlTHY0VE9rdmwxYndBMnFxR2cwNmQxanNnZFR1aTFORlN1UjRyenNp?=
 =?utf-8?B?ZkVoZ2l0bXZPT2k4bk9KT2dRSDhtK25vVXdRSVltNUtzRXJuWE5HNWNpcXBO?=
 =?utf-8?B?bUczQXFtZzdSVUJMQ2tGd3kzZU5nb3BDa3FtbUdxcEVzcU5tOUNVT0o3ekU1?=
 =?utf-8?B?SDRxRUZZOVhJQnFSMlpYMUExTjRWZUVKdnRmcm50cXZhRjV1OEtUc0x6UVFt?=
 =?utf-8?B?ZkdhYWtaUFRqRS9rbTJtM3dwL2xxandCNjMxZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2025 08:31:46.2760
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6448eb69-20af-447b-478f-08dd9841ec83
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4189

On Tue, 20 May 2025 15:49:25 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.92 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.92-rc1.gz
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
    116 tests:	116 pass, 0 fail

Linux version:	6.6.92-rc1-g18952a1fc4ac
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

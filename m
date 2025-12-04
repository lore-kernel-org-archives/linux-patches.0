Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011058.outbound.protection.outlook.com [40.93.194.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD9E2D6E75
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 10:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764842471; cv=fail; b=aO+sdDwBZE67+FcuyUJ3G928nwm0VytuJJ3zpV5BbVv8fWqMgm4RHwda+agQgF6B2VLKkMTLF0be4G+wk0sTC+i3LWgf0ZR4fzwv4D7yrTwpCehZC0QVFDZ8v9/O9jx2B7WL9FIKG49USXfXK5IO6UAxG0HZVPk0rfZEsr349nk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764842471; c=relaxed/simple;
	bh=Ok6bz3x99EAJrsV7XXnUN0wArvYDfS4U5FzMSazC1LY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=HWnkC+JT6ZpmWtfVQunnczePIhJm9HsJqLIqjvFJVCkFjHjpSnxg64bceIkQD3dvrqeGZ08teJ3QAls9iWy4YFysKp8/32aW3+M23+ID3pvwnhFzlpZ+VIV909lfOO2OxDTuvOJJsGeI2kJzUqwDMHQEUUa1ifXR52LkLn8RCAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h62hDACC; arc=fail smtp.client-ip=40.93.194.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h62hDACC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pYPMsYT6cOzNJTzlk9Mp4pDXJoJTcx5RinHrD2StU/zgXlyvYetyPCK6VxPqwkcBoJnVd5JnW7nYZU90dwLVgyIwzuuJ8U2A109gHuvWJHIGTrgFDAxe1tvdfc1csKh4evsKyH3q8ytzi/uJVf0PbHfd374nzJTmH6gS1cIvmeOFFGzWetnQMd7v9Rz0xmg4KW8zDSw1fDoINgpR49ssR6MbPM4bgTrY7hfys+HhyxF7heJdaJFthyH/Eqs8izo66GvxVpzEp46avvs2uAuj/mkqoSvYccjB4fhn2e1Z3Fx7Zq/jLBY5q6j/kxjQVm3wMRFRNgEbPX3TTUMTFrUWQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xQ1odrrO7CbpfnHJOsY4emvPDNeuRlVSBqGItlvnBck=;
 b=brAB68sHmk3ktcswmQKdiFu8h2Id0v47dqTj0a94V/utFO+pHxkSvvQzu7gXtyOzyr/G+DgZPhJSfHY5LrLWB8z92WEOiTnluAQC69IVS1DKrv5WLOtFntHkARe0e/YKfW6KPfWs6mfc17ySYP3kLJr9G60oO65rsuHN5Q/eoxH9lgqqXhqZkXAcDl9b6zrdjmdrnSnBW9pEZrvFjT0ZqeIdcvmWgBU+Qk1RYK2kUnXSZtogpYhDYy+qxWa1Xhj0chUfnrFN0jWVKxlSF4WmEzq8V+fgi86tRkB+z3i/NEfteepnfW0ks45lQAeMv9YrPQvifm3rPogZKDnA/2BzMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQ1odrrO7CbpfnHJOsY4emvPDNeuRlVSBqGItlvnBck=;
 b=h62hDACCzd/7s6uMnn5FN3OCjZeETjmqTNKtuJ4Bx/lA2IOLTqTlyYjSGGIsUHsZg07rD1H+/pKJv2RONC8lNEziy7oK0Cu7zSz9uaWvZw6q9HDZxvSmPw9F5qhk68a6h6Wg5BpX7d6G1GYak5qGC+lEvbIBV2ac/reYuPYAk1TL42qMMYgYCwUY6Offt+b/AEBveapuulkHmxq6cgMAokTyMWSa5zICkp1ANwNaKPSdcZjXHQZ8VKyxPq+xlAEDOUN5zwbRNDWMgm2fo9GOgrA5UcTL22UFxaIw1oWH0aYJOc/cuKu1x8sYPtjCjXPOtkcxFPCQ1aWWjGv0RJBFWA==
Received: from BN9PR03CA0492.namprd03.prod.outlook.com (2603:10b6:408:130::17)
 by BY5PR12MB4211.namprd12.prod.outlook.com (2603:10b6:a03:20f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Thu, 4 Dec
 2025 10:01:06 +0000
Received: from BN2PEPF000055DD.namprd21.prod.outlook.com
 (2603:10b6:408:130:cafe::bb) by BN9PR03CA0492.outlook.office365.com
 (2603:10b6:408:130::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.9 via Frontend Transport; Thu, 4
 Dec 2025 10:01:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF000055DD.mail.protection.outlook.com (10.167.245.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.0 via Frontend Transport; Thu, 4 Dec 2025 10:01:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 4 Dec
 2025 02:00:47 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 4 Dec
 2025 02:00:47 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 4 Dec 2025 02:00:46 -0800
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
Subject: Re: [PATCH 6.6 00/93] 6.6.119-rc1 review
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <cdd15351-d6f2-40f4-b872-042de88012f3@rnnvmail201.nvidia.com>
Date: Thu, 4 Dec 2025 02:00:46 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DD:EE_|BY5PR12MB4211:EE_
X-MS-Office365-Filtering-Correlation-Id: aed8ff5c-36f0-4752-2724-08de331c0a4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cldyVU9LNWN3T0V0WFJtK0xEQlMzR2lJVGJ1NWRRU2tXdXFWazY3YUJodWJW?=
 =?utf-8?B?ZXFPUCtWdGtJTThObVpGdVdLZVV3UStsMi9FK290YlBlNm82cERhZVZqT2c5?=
 =?utf-8?B?Y3dsQ1pCQ2pzZGg0aWNQUUxmN3B5S2lEcGEzY3U3RFVlNkcrSUxFNE1yVGNi?=
 =?utf-8?B?SFpGSmFPR0Erd21HQUVLbWV4TmJRL09IeUFOaGNaRUhTVHc3bmdQR0JYQ3dN?=
 =?utf-8?B?aTN4NUhjd2I3ZHRWUTFEUTZGQkpTalFPcnFiNS9IeHNpanRPMWdlVkQvSThl?=
 =?utf-8?B?bFdvS3NYanlUM0hSZ0hJWm5jRVp5d2QySVRSMXdBYkIycDVJemE5TWRqbHBt?=
 =?utf-8?B?QS9UbDQxaGpqb3ZwZDNYbGt6SWk2ZG9HSlRTNTFJSDQ3L3RmZmZOV1Z6dzhI?=
 =?utf-8?B?SHl4MjVhbHVoV25NMVZpVHdNU1RGVkNoQytGdjFQS3VNMFgwNlVUSUtJT0FM?=
 =?utf-8?B?SHZTNUEyRENrMDFjUjdpWUFraFFxSCs5elgrang3ZGxJUncwbGsrVER4R2NK?=
 =?utf-8?B?ZnBock9pSlRLQnlIaXY2bjFpN0RIRmJIUmVFWXVQYjlld3NYVTNWaGVNcUZ5?=
 =?utf-8?B?RDFLUDdHQ1dySVhBZHpMSkJ6ZUsveWJ4STNuT3dERzZOdndiaVJXRkhCN3lJ?=
 =?utf-8?B?cDJsWnJkOWdXRmFDeTdndzhoeC93VE9JQlZoeXY4Zk91WDhZb0FuTVRCVy9v?=
 =?utf-8?B?SWtVTzN0ZHNEeTJjeXJWQVBHbytaNXlKbkJ0VzFtU2NpZWhmYjlBamZaSW9K?=
 =?utf-8?B?SUlaZXAxNU81OHFIWkY0SVgwS09vcytrR0kxSzJqTlM4OElsczRvOGpLVStZ?=
 =?utf-8?B?bE9pUFdnUnYxWTY5MFd5Z2IwcXJLNk1WRjlKQldxUG5ldGpwSGtGNWsxTXpz?=
 =?utf-8?B?T09NRTBJZ0Q3dTY1ZHU0b3g5Mm4zZTU0SUdGWkU4dHRlcHd5dDg0WVAyOEhu?=
 =?utf-8?B?NTEwdldKd2RoaGxWSlRVZEpzMG5JTng1QTFtZ0MxdDloUlFwRVo2aVVGdXh2?=
 =?utf-8?B?OHppRTBrNWxqZitMUFNYREU3Mk82OW9sdGJIOCtNYVA2QkxSV2tBRlZiYllR?=
 =?utf-8?B?NTNBQTBQbGFpdWpzZDc1V0tkRFBHblNacldsTmRac0FaanFUdVRmcnlyemVh?=
 =?utf-8?B?MHIxdGV5K1BkbEh4NkhHQ2lTYVU3bm1CT0tYakcya1Q1aDRNaS9mUGNaZ1hs?=
 =?utf-8?B?RU9UR0o3Z09HRk5HQ0ZMR0cvVVdBcjA2YkxZN2VOMGkyQTU1RUF6V2kzcjNL?=
 =?utf-8?B?UmdnQmV1TmY5N25HZDhHd09iQ1lqb2tNbHcvQ2VnZ1VSdWFTVjArNEhiU0tT?=
 =?utf-8?B?Q2tTNFRHMnQrYTNsUE5pTzVqRUR3SlN5ZEVqT0ZrUDBweFJMTTBMSWhUMEU5?=
 =?utf-8?B?eWxIWlk3TGhCUGVGV1BJVklDRTVBNXB0UVpEYXpRNFJvMFRJQmgwUnF0MHZs?=
 =?utf-8?B?cUMyMUZ1WE8wU3ZvazlDU3Z1Tk4rbFViM3hrZVdVb2pBQUlsOWl5N2pwU2lZ?=
 =?utf-8?B?ZCsrdTlSNlk5aUFWVFV2aHhjakN5NTR6TWlXODVrM1luOVQ2M2xzb2RseXJD?=
 =?utf-8?B?dld2dHhyajVWSlpCUWh5NU9oTzNabXpVeUIyeHdRYi82MkZTdDk5Wm5FWEhD?=
 =?utf-8?B?bHRVS3ljRGk4N1lFeFpoUFhOcllON1BReW91MXVoQTc2ZUJOR21nb0FHN09y?=
 =?utf-8?B?VkhjQ3B6dU5kYThRZXQ3UzMrYTFDNzNIbGYyNTNyN0Q1eEVFRWgwRnNac2ZT?=
 =?utf-8?B?K2h0MWxwNkpxZy9OcDhCOEpyY2dWK1FzMTBkbmVMODFwM2liSEZyMFd4Y1B4?=
 =?utf-8?B?MU92aU9BMk9OZUpwbjBrWFZlSE54NzVZSGhIYnZTanZRWlRjMmY0TU9JSkZ1?=
 =?utf-8?B?QTVsTDY1bGtzTmhYOUN6Q2lVdGtubU5kRnIwcmdmVWZUaFRmWVJJY1hNRVNF?=
 =?utf-8?B?V2w1c1lPVE5aeGZjM2VpYk9Lcnp4TGpWOTdyWjN2d1FHRk85enZ6c3hQdlJi?=
 =?utf-8?B?NHkxN0kvSWpSRnpzY3FZYzY2dHVmU0J4aDZqZk54SVJlaTNCSEZQanZZWmhI?=
 =?utf-8?B?RWFjbElHQXJQUnJ3U1N6RGp4eFgwWlZPT1A2Qjk1RXdZUHhwc3VSME9IZ2Z0?=
 =?utf-8?Q?wTaU=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2025 10:01:05.6270
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aed8ff5c-36f0-4752-2724-08de331c0a4f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DD.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4211

On Wed, 03 Dec 2025 16:28:53 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.119 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.119-rc1.gz
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

Linux version:	6.6.119-rc1-gcca93798e4cd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

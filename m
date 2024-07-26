Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F149711C83
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 17:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722014331; cv=fail; b=cYj7JBFitzzMaTFm9qKOCUw6Cj9sw7PJrE/J2AtwiWcaIjJX9KSn3MT+kLunAasROvun1qr+bi3hVYiGXZttYkUCbDcmzKN45j7sVN2clW/3kvEuzMO1KXHFgecncoqSPViXArbqnuPZrUCd1+GNXfQaRvwIpwcpPhOaE9Hf00o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722014331; c=relaxed/simple;
	bh=1ipvj9yjmUaxmJfuACkFYMCrCwpBZsygGp1IqxsJupc=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=pveBhBj/j9fKTvroRacinNGYR3AfmiZQ5RBVBcDiCbCz5JhsubAfEgAV5exoOkmajZb2UqLPPpvESNBx61NDKuMclVkubmexPcbGhb7HnnTY5aHlmHzu+QEcTFlPCp76hCIvXXI7x4SLO4cDjzTeXJofiiaP7O97B0AQU2nhObg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QN4AKYu7; arc=fail smtp.client-ip=40.107.244.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QN4AKYu7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P6LiI97t4AT2WKLk6baL2kV7X4ZCZxMWGdJ4OZjzJ/cl8tMxZi6k3TTeRgi0KFo+oKOqetRxpoHxVIEYgUYEbO0sXfnrh1YjbDy/Kysdp+BqKwVeLG9SRduDuczG18SgVop0E3Rsi/jiuzDk8/hC+ZYZK4AdU5LZkb1uLtkvHq78p5lojv6znLkGfpD5SWWleNUqv7aWwm4twZpEgoofTdIpXFn+I6Dh0R9c7woMRKpcXFKmSrRtFOxlrQS4/9mC174J/BpEVC+FXbhb0ChvEKLtd6BUA85oxwyVhuqXlTUsO1d2FV6KWIu6JH6QvHXJT2048zzdEarU0qs1lrI2ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pVdyTWcwpbIsqEbfqwCRa5mRv8wWruj51GlK7UeBHV4=;
 b=slZVYupnKtvV1KEot5t+MT7B+y+hcVmO0VzH/Iem6oNeU66vhy4+DyNnh83XtFMq/xSKLzIwyULIrbd9nUouSsvrRGMqWIO4xyY6FUxVKeN4GcE/2ZzXw68GhkE9JaaiLTmCMqfjOUFqsovolZIqr0wFPuwWWGyte+aNQRq8PBCh9CeWWuDKWRZsqI5ykNgcH0CH5k1H4R5YEG/qpSZX8G0XqlCDTZL2VHFWeTktojZcIMlnz7x3f1/muLAuYS6U75e1kUcQWAcXE74nwA1K8UUAOpPxfS1JZTyJwu3HHq5N9ZaD0yia9mWz4CAcz4aZqxxzunXARIjhNDKxYqhj2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pVdyTWcwpbIsqEbfqwCRa5mRv8wWruj51GlK7UeBHV4=;
 b=QN4AKYu7GvCwE+hrU2soncBBPDBB9e5q4sS4MzbElDGQXrbrvYpIDXDLCYkGuenQqKVOuoeITD+1NfQilf9QxJBfAU6wFY0O5eAsdbpdp+SCLTtE14bjF7d4hxc87AP6gX8eTkWZ7/6Vp4HbXLr8A9oFUB+1WSBvOkitbaP/sCgFILccTSqCWMHhECKz7trSVkB+nzxUf2E7TZAYuS3a+vWyDBkJUZWK1lZgxAyti9gjsejpO7ny9x8O9kxNR5k5I1JD48PAUZvpLLP+kr1oMVRaZMO/22etgyARMFZ5MOJZt8NCM6Lp1hn7Vw8ZYpTfeQ4IldcUND20OppChSUBfA==
Received: from MW4PR03CA0007.namprd03.prod.outlook.com (2603:10b6:303:8f::12)
 by CY8PR12MB7413.namprd12.prod.outlook.com (2603:10b6:930:5f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.25; Fri, 26 Jul
 2024 17:18:47 +0000
Received: from CO1PEPF000044F3.namprd05.prod.outlook.com
 (2603:10b6:303:8f:cafe::89) by MW4PR03CA0007.outlook.office365.com
 (2603:10b6:303:8f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.28 via Frontend
 Transport; Fri, 26 Jul 2024 17:18:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000044F3.mail.protection.outlook.com (10.167.241.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.11 via Frontend Transport; Fri, 26 Jul 2024 17:18:46 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 26 Jul
 2024 10:18:27 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 26 Jul
 2024 10:18:27 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 26 Jul 2024 10:18:26 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <allen.lkml@gmail.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.9 00/29] 6.9.12-rc1 review
In-Reply-To: <20240725142731.678993846@linuxfoundation.org>
References: <20240725142731.678993846@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <8a2f2ed1-d3ec-47ea-9f32-854a52b5c3e6@rnnvmail204.nvidia.com>
Date: Fri, 26 Jul 2024 10:18:26 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F3:EE_|CY8PR12MB7413:EE_
X-MS-Office365-Filtering-Correlation-Id: caba60f2-1112-4f5e-5281-08dcad97023f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a0M0ZnNEYTQ1VXBqRGZseEVSdlBScnh3MkRqUjN6YzJ0MVhsOFl6aWpLbTQ5?=
 =?utf-8?B?VXBHUS9ueVZranRid0NGOUxQZ3JIRXpiOHVEWWlhK2Fsd0VoTVh1QUZPOWEx?=
 =?utf-8?B?NjdjNHltdHNYZTFENGdraXRpMmtTTnExVDA0ZzJjajVZaERXTlBQdVFpajl6?=
 =?utf-8?B?OGNnM1dIV0lQcEZRdlBBOE1VRjNrSGQrdVNXbUNWcjh4a3MwYXlWaU1jT0N6?=
 =?utf-8?B?bmdTeGRIRWs4dHppcm9BQW1EaGJXWGNjODJxemNrTzhFaytRYkpFV3NUbE1B?=
 =?utf-8?B?ZWQxWGJIT0xSZmRhUzhqR0kvMk1NK1F5Y2g1bkxaRGpkTjcwRU9VMEVibUJN?=
 =?utf-8?B?L2pKV1NwU2ErdEYrckhQakQvQWNveWlrc2JVVVNEaGw4UlhZbmhOR29nLzJa?=
 =?utf-8?B?cEtHNFVKV0dKd0F3YU9kNlhtVHcrd1E1M2xJeTZtNlNQOWlWbmkxM253MVQ2?=
 =?utf-8?B?MHhwd0Q2dlFpM3dXY2hIcHlNZzhsVFhMekpjaEFXZVpZWjR5NHJXYk5nMzBF?=
 =?utf-8?B?QUdLTjJtTDJVS2k5b200bHAycXlrMUJHa0cxOFFPSjdZcmJRd3cwUmlMN2pJ?=
 =?utf-8?B?d3hEZDhSTTljaTkyY2ZWakVXeGsxSE5DSm0rQ2dOcnZzTnNKTTN4aEhOUFZQ?=
 =?utf-8?B?SUEvbEYrczRhMFo1a1R5QU9SOHNMUXlvVUJXajF6YVFsNFdTQW5DUTU0WVlC?=
 =?utf-8?B?aVNkcC9QVU55NTFGMkRlVUlTVkRLN2tQU1M0UmF0bjZxekJwRnVmWnh2T2sv?=
 =?utf-8?B?bkx5a3FhcnJGcHo1R2ttMXRnWldJOXg4QWJzTThEb3N6dTRJeElqbDhQY1hp?=
 =?utf-8?B?dHdDQ1ZOQ29jMkRMTWEzeGNWYk83UklUUFh3dmdiU0wzS24zUzlpS1AyZjJn?=
 =?utf-8?B?UVMzTFNSalY3NDB4ZFZJdzdudTQwaTRsMUVkL09rcnN4OWs1V0swdkVPT2ti?=
 =?utf-8?B?aDhFc2hZbzczTGdSbEJkUWwxL1I0Wm1DbkJrUDBwcjh1djd2K1BKVEphN3lh?=
 =?utf-8?B?VktJSURNUWVDRDNTbnBIVnpCbkIzcUxXMmI0WTU4UzNYVkt4WDZOVzRJVk9K?=
 =?utf-8?B?RDRrTHhlczB3V0loK0ZhTXdMVDlTcmZDbGdlU2E3NmNJc25NQTJXTG9BNjd2?=
 =?utf-8?B?MGZSTnR5cEpwM25YdjJGazc1OVprd1BXUTZGekNvSGtmQjBQMEtiMGdsbUNz?=
 =?utf-8?B?YnZkU21rd1gyV3lIV3BWMU5SeDYvT0ljaTd2WDJZZXdodkpwWHo5eWdSTVJB?=
 =?utf-8?B?Nmwza2ZCVCtEVEppTmRnRGc1cE5NRUYxR3Rkd0UrRC9PTTd5WWRYT1JMajUr?=
 =?utf-8?B?VHZjY0xSempZOHRXV3NIeDU0azFaWTk3em80aFpMWU5tdDAwMGY5cGRrNUpn?=
 =?utf-8?B?dWhZVUhIL1JlL0h5TWdHcTJqOEErdlBTL3FyV203NzlDV3pEbmdvL1R3WFJ5?=
 =?utf-8?B?NCtBRUVWWll0Zm12U3c4YWhnMGZUa3R4UnBIV1Jra3RrYnprdUFvSHJmYkk1?=
 =?utf-8?B?NEF1aGppREpNcnpKYmVyMTZxREdIMTd0NmliNGYvRmh2YTFwb1ZsVjgzTkdm?=
 =?utf-8?B?MWxGOHRRMk9COERFWTRQaXRtVEw2MytwRVNjWUlkS3V6dit0NDRnbWlGUHRm?=
 =?utf-8?B?YXQ4bHpFWHg3SGFjVzhrSjBjS2pFYzkyaGZ2ajRpaXhQM1pwQ1NXYVR4U1lP?=
 =?utf-8?B?ZmRTei9ERmhtbGo3c2Y0RmFsTnpCS1pCYVBIOEFWNWlEQXVVZzJYbHFTS2d1?=
 =?utf-8?B?TTMzWkdZU1k4QWFkTXdzdFBWaGRSWnJVUERKRmNMNXFyMlhSZHpNWmUrNzI0?=
 =?utf-8?B?bERudjAzdk0vZGo1V2hJNDZmZlM3d0pCL2lWUDNWVjJ1M0dPV1lyRFJYS1ZR?=
 =?utf-8?B?VnB3eGF5NDF6dWZPVENYRnA1clVDa1FxR0hGMHcxL05BczZUamQyZ1h6NE0v?=
 =?utf-8?Q?VBobtTv5GJ6mppFEG/OrD7VKepHxxnUh?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 17:18:46.8357
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: caba60f2-1112-4f5e-5281-08dcad97023f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7413

On Thu, 25 Jul 2024 16:37:10 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.12 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.9:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.9.12-rc1-g692f6ed6607e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

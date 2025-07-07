Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E464A944F
	for <patches@lists.linux.dev>; Mon,  7 Jul 2025 08:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751877836; cv=fail; b=T1qPYqzySt0FlojvVmxrmT8XKVL+LPpFVJlqNuTKYBgJgewlYW5nPWTKe7/F5aWVpqwRXmnsnsaOsnuVqVS8pWN3wshpvOe5ByM4pjZQoX4ptONAxH8d0glD0jDvRXx9Y1sUyvpp/gU9Hsrjh+SCLI0RQtBJ+chqdAi06weWfvE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751877836; c=relaxed/simple;
	bh=60hG64iz9yESosXqgo94JQjEH+ZqJbLbHdqaKU0lnPQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=ggZZ9sX+OD69dGMMBGyYpkBbZeRWqFwLnmD2yzpjbK+4e2n4EwBxlPPucmj+2x9OnutsdOE07FKgSWFQKVXZ54zmJEwQMeY9Ic3iVJ3TrFH2pAEc75SqLJSdg+8oGntDiyMpQ+Q2i278MY9VWj++QEjsGEwvTDjhfutOfALwEVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gBmGxbcW; arc=fail smtp.client-ip=40.107.93.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gBmGxbcW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PSn3AxRORP4K9sWCz4hqjngLOrK7ChswDi2g4315CUN0cxelKtws+oilzjoQ2PAPeQbXPMVZzBEbW5eGvJLRPeEnASUmV5FAHwwXrC5jUXeZH5Od7+F2QCs8LrqTGKDkQz+RGbSMecZEZUUidEMwOY/xjVzSRipfsxhchcquqNya48RAzj6b95XrDnNud/01sH+1zWykrLXMci6SyLWA/iXae3/mwje1f7YBZoN6YxBt5JogRHb/fBepcXVywK+5Bn02gGucGFyYZTF9KEH0SMyhyMUuhIbYyn60Odig0qqPzwzRuw4p0TzUJp3giqBpXt4ImFRjFRDjehz6Qc0v8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VCsVp1GRIR8AMUlh4pRUydEsQ2VcrU3RHyx0ZX80Oe8=;
 b=uElku54uCHbPc2TNg/4ZKPyTad+XU41UuNOGAmxMwtM+j6OEKyh8GWKsEMSDckA7WJ6a6eisMe6iBIbfkUlqsr7Pqxr61gE3zOa+z2RALutuDEGfaFZ0wLakHrpQppOynxo8JrungnAuJ+H3TczhCyRO3M/sjOeZy5TTMzuJxX3og8rA6vxSvAUHRSNk0PB8m7RyDkluXHAb8nkknuQMb6/+TgSJkS2YnNaYfDXe0Dliol/bVLNXXxwjfTiC3eeOsNDqJ8UHOxvrFtyGEDMXL/XTJ3zLcZrXG8UbQeZ8RRvPZ2hrJj/IDQDUDc7g5J66HRep0N5iYGJf/o2YBd3AaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCsVp1GRIR8AMUlh4pRUydEsQ2VcrU3RHyx0ZX80Oe8=;
 b=gBmGxbcWetU/xs1dJz1vfzluIa6SdegnU/lPkYJZtGFXbxpY3C5D5JlI7fPzsnaTPsl0RfsWI4WyHr9/pWrw/YTCb/xlRh9te5YZtvgEdaeRkIiu0uZUlU/qEBjcT0k1WuIv3jtB8MfUshMUQ+6rNKuskLUNaEeSf+Ml8lXlNf/7+lGs7RI4SYGJZF475BYx0PkVbwGUTw7PXsY/92GM7wp4SCnPflBhDvxH80gdtHJKE209SwxYloV8znI7vYayQhxSfRTXvWnYMv0SsuTM4bIymQMsPFziO0yxXd2aBAswtLWBTIMzMfAC+ACtgzduNnXdsK4F62oFvxOVRwworw==
Received: from SN7P220CA0025.NAMP220.PROD.OUTLOOK.COM (2603:10b6:806:123::30)
 by MW3PR12MB4410.namprd12.prod.outlook.com (2603:10b6:303:5b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Mon, 7 Jul
 2025 08:43:49 +0000
Received: from SN1PEPF000397AE.namprd05.prod.outlook.com
 (2603:10b6:806:123:cafe::4e) by SN7P220CA0025.outlook.office365.com
 (2603:10b6:806:123::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.27 via Frontend Transport; Mon,
 7 Jul 2025 08:43:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF000397AE.mail.protection.outlook.com (10.167.248.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.15 via Frontend Transport; Mon, 7 Jul 2025 08:43:49 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 7 Jul 2025
 01:43:32 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 7 Jul 2025 01:43:32 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 7 Jul 2025 01:43:32 -0700
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
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc2 review
In-Reply-To: <20250704125604.759558342@linuxfoundation.org>
References: <20250704125604.759558342@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <19d2e833-547d-4712-a68d-b64cb3438999@drhqmail203.nvidia.com>
Date: Mon, 7 Jul 2025 01:43:32 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397AE:EE_|MW3PR12MB4410:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ade600c-e53c-42f2-f55f-08ddbd3264a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V2ZFTkRPM3BpNUxCL2lpblZZVmR4aURBZ2ppZFBTK1djVGxHN2ZLWUE3NWtq?=
 =?utf-8?B?cUY3N2xtQ0FGSVhhd25ueUlJc1JPSURFVkNxQm5hYTZLOHd0aVJ4clVGMWZD?=
 =?utf-8?B?MWR4RGZ1SXY4bkdSbmY5bTNHSTBwZHYwSit6bFU1b3NxQ0Z3MnNBOWExd2w5?=
 =?utf-8?B?bVhHaVBaZWhCS2NveVQrVDVTcm9rc2gyc2ZrMFQ3aXpMY0dSR1p6MTFrdE94?=
 =?utf-8?B?NHNzK3NKTkp2RU8zMnE0TVhCdExmYmVEYkJtTFd3NkEwKzhua3BhRU9jTS84?=
 =?utf-8?B?VGp5NmJKRU1yS21iNG00TTFFMXphQ1BNdVJINGRRZEIxeDRPcWlDSGo2SjJl?=
 =?utf-8?B?RlNUVnJrZE5iQVVZZEtWYWh3MVlDMFU0MitVVHZwVkViWUI1ZUw3WnczM0l5?=
 =?utf-8?B?REZpK3dHMkZMbVNzVEJvNjJlNjRZMkVHQzNwMjZDTkdIaFVxTWxiRkhiRVhr?=
 =?utf-8?B?UnZ1dmo3a3M4L2xwamYyUUhWcG1tUVBWQmRxZUhqVFY0cm8yVS81L1loeWsx?=
 =?utf-8?B?QU95U1NGUmlQdUg2ZzhueUJMcWVMazhxVWx2Wk11VHJSNlgreWwzUWJUWmpj?=
 =?utf-8?B?WnVvUFkvcTFHcDFQSWVuRzJKb1J4WjR2YXQ3cW9qNWJmVjRjYW5jSW9yVmwy?=
 =?utf-8?B?OEM4VzJON2EzaE9uYlZUZk8xUm1MVUdNTmtLRlV1RzhiREhyUnFnSU51Y1d4?=
 =?utf-8?B?Y1VycEhGVUo5TVExeFlUOHB5UjBiNzM4Rk5RNThJdmlIemh2YXZYU1ZCSTdR?=
 =?utf-8?B?a0RvUkR2cWp0emlvTkRVN0pRRVdvK3J6Y1ZXcFNRcSt2dlNkTjhqOGdvZWtB?=
 =?utf-8?B?K2V1NlNXK2MxTjdmKy94cVVwK3BOaFowc3ZhcSs5NU1ySTVRUlhyQTIwTU1M?=
 =?utf-8?B?ZkNmRVJSR3A2MGVlajlBNTNkY2JXdTNCeUVxclkxaFo3RUNUT1VLZWg1V0R2?=
 =?utf-8?B?dGJnekFrckNQQVN3R1crbFZKOS9WMUlOYnk4VEFId2FhL2lnMkd6RXZtRE9y?=
 =?utf-8?B?elQzTDVwb2lucjVHNkNGTy83RG4rWjFHMStwa2s1UnVLVTlPbklIdjlpQ0o5?=
 =?utf-8?B?OFBtcE9RUGVCejhlTTYrS0ZvTHRnWjdWYkw2Yk96TU9zT0tpd1pyK0wyTGpy?=
 =?utf-8?B?L0NYenlBS25lcGhNWjUwRVoxL0NJWW5wbjdCbmtGQm1tMGduOGp1bEs1SkRR?=
 =?utf-8?B?N1ZpdGRHUmd5QmxqOHZ6N3ROZ3ordU0wMnJFOHRPcTFOc3I1Z1UyQ1YzaGN5?=
 =?utf-8?B?VVd5UWxta254SWcxbVh1REJXRkp4YWIzY3JJT2pzUDRtZkp5cHVkNllRRk9z?=
 =?utf-8?B?YVVKZ2VhaGVIQloxaXVrYm9xdG50WFlsazJRTElVUnlaQVRsNDErY2xQVTUy?=
 =?utf-8?B?Q21NMDF0UVdwT2xJaUIvdEtRd3BYNndEbHYvdnJyeXV6R3NlektncE5Db00x?=
 =?utf-8?B?ZUFJNURDY2tBcG9OUHZJQ1h3Z2N5MXZjRHJJbGN5MDltWk5mUHAzbXltZWhH?=
 =?utf-8?B?VlliMVBXYU5sNlN3Ym1Bbi9sUmpqRTlzeU9PdC9PVUE0NmloRE1iVldoVTl0?=
 =?utf-8?B?ZGd3UDYrZERWcEMvZk01MU9Qei9tMDVXLzFXYmZBR2kzZCtPeDJIdURPcXdU?=
 =?utf-8?B?VnNIcXBjck0xRmN1Q3VMWERIQ1dXT0hEd3RXeHhncG05eC9xbnhSZ2J6cTJ4?=
 =?utf-8?B?cGIxUEVxOVkrSzEzcER1WWgwK3l0YXVpTUtmNGdBWDYzZlB6bkZBbWVTbTFt?=
 =?utf-8?B?alBUbjBIRy9qczNxNjc5bGg5bXhkUW13Q0NMS2djSkYvODRaSjh4aFpZODRK?=
 =?utf-8?B?RWwrSDFQalhHV2hYeFpPUTBMZ2ZZaTF0QkJxTzdIWmFrSDc1QmZKUlFpRVpn?=
 =?utf-8?B?TTFhRndKaTl3c1lCbjZaWXpncjY4My9Ha0s1SGdrL0dsOEFJVHBucmFyeUd4?=
 =?utf-8?B?NGhJaTQ4VG9jWkxSTC9MSTd2aE9ZZ1ZEUmRPMGhFWXlUQjRtN2ZjanR4STE1?=
 =?utf-8?B?ZWg1Zm54bDF2clZwcldMRTVSa216OEhjN1c5SEp4YlBWTXJ1YXFlSFpXTW4x?=
 =?utf-8?B?L0h5c1hFL2RibnlCdjFsclN4Qzl1S3ZSRU5VQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 08:43:49.0037
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ade600c-e53c-42f2-f55f-08ddbd3264a9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397AE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4410

On Fri, 04 Jul 2025 16:44:42 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Jul 2025 12:55:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.5-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.15.5-rc2-gf6977c36decb
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

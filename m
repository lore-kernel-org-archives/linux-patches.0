Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B5019004E
	for <patches@lists.linux.dev>; Thu, 29 Aug 2024 10:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724927255; cv=fail; b=LMGIDSRatded1+hzAMXqye1Ts3xWb3ezhKip9sNw/+be8ICcFpv0Jq947dwt0DbT/y68RlCQQ6AG1gzewSixJ+/pbjQyv/bOpQ8SRp0y6Fb8nVtmXMdlrhpxxt4az8Rz5IcxstTdYi01RPyXEtLj7D0Ekpsn/iWmhN003jdKgRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724927255; c=relaxed/simple;
	bh=wgtet7DxbyRMskDOZZ7FjTBNxsEr2D8nw9q6YwrmgJI=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=IDyxujWuTVa8cOfesTH5gc5r+QNP6xVpAYx06CURWRV0EMJnmavLH3B4/3y5gB+MC7yOHBG/AWExjRrS9XfKxOgakaSgrlxWrN5Pm5trU/u4CkAAGFsKyoeRWfEqrrZnFX7Hj/v9BE02XnDAUe+oAYr4x/1WvUlbcX4npAbzNb8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kNqNEMLf; arc=fail smtp.client-ip=40.107.223.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kNqNEMLf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GXmeqjGGliLXqRmSPk4sA4FZSchEm701pr1EiCWcSLGDywRPG7PraI68XUJgm/LotxoZxUI/lrFv3lsL1YvI0/hpQZ9k6+ncZLQCO9Xg/WZj1fg77tzPeKQsA6HCI+7DmSJftt1XS5h8OLkN5OLdM/q0+GiMy1WOt4+cwQzcounVaY5FvDkbEsb9LYnkDS8bj0PKTnOrWleudTW3bryThtOQvzVu2oRiQiW4IMfY0IsFvpIniP+76ZV1RHZWTRWJdfpapqLBMnEZdamwxCaLIJXiQYD3a+AShCmUsYRurW1twf7+rOFHhBdc8jrqvSooR/Oyfo5IlAdJ4kwGa0xDcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YSiOb0OpaRDZkcYEMq13fi3DDG0i1eQ2HTTzKXKXorw=;
 b=D5OK81Nmk7IndyWONQczrpzKAYn0XGjEpCUnj2hTD9QE7w06S5mPlkN7rFyf6DZmhgkwifHrT7d+cbywQdPvWpbTEAImfCmpWEwBpTmZ+AuTTr6d+CvFW6CqUmVuBCQsw+TsVfPp86Rz8EDUFFNhh++TbJQz8jscdwDZfAk5Q7wC0gWR3HuXER1iUivUNgIUL9rtufCxz8z0tsohOyaObsuR/zdiZ8sw0nHZktX6r40Yl3hnlOyLJto3RpxEWyMRYAN6Hqf+ozc6x2RGYFCVgO9igjCmnDqNOJPddgGRjX8306XqpcNAeUhnbZnpjA1wHoWmNHX80tdGPSnUOc9dNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSiOb0OpaRDZkcYEMq13fi3DDG0i1eQ2HTTzKXKXorw=;
 b=kNqNEMLf9s5S7YjO+C4YYj3XuWfPbX027ym3sJIq0eumiJ14VAutCR9rbSQeP8VqWefbMEP9bRZyW2oLzpYoulA9Ni6aewe3YVSyIf7fhATU6H2v6YiNTMN+7PI8lEQf6mOVd1hBNkv2iZoUBOyFNbR5lzVQ1e2l+la3/ieq9mXMDWVhDej4T6VghKDnAqHdTYjzGza9xApwuA5FmdUBAv+Nf520FZmNz6SVR0Rdifi9+tqcz/PzsfNJ7dfjknZ6GeZGSlYciagbu2syvqyJT8h9nUqXptQvdpW/IWaSBSV7+uRvhRguWDnyU7MmA8Lx+R4U+jZy0Ke63jsiEP6cSg==
Received: from BN9PR03CA0353.namprd03.prod.outlook.com (2603:10b6:408:f6::28)
 by MW6PR12MB8999.namprd12.prod.outlook.com (2603:10b6:303:247::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Thu, 29 Aug
 2024 10:27:27 +0000
Received: from BN1PEPF00004686.namprd03.prod.outlook.com
 (2603:10b6:408:f6:cafe::f2) by BN9PR03CA0353.outlook.office365.com
 (2603:10b6:408:f6::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26 via Frontend
 Transport; Thu, 29 Aug 2024 10:27:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN1PEPF00004686.mail.protection.outlook.com (10.167.243.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Thu, 29 Aug 2024 10:27:26 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 29 Aug
 2024 03:27:16 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 29 Aug
 2024 03:27:15 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 29 Aug 2024 03:27:15 -0700
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
Subject: Re: [PATCH 6.10 000/273] 6.10.7-rc1 review
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ac8405d6-a39a-4164-ac2d-71397d397ef6@rnnvmail204.nvidia.com>
Date: Thu, 29 Aug 2024 03:27:15 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004686:EE_|MW6PR12MB8999:EE_
X-MS-Office365-Filtering-Correlation-Id: c2de306e-31af-4f6e-d1ee-08dcc8152dd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eG5RSE9GVCtTdFFiWndETXdyWFdPaSt3dHBFV1gwbG1CbWpIeWxzUEhoNlV0?=
 =?utf-8?B?T29rYjV5Z1VBSy9McjI3b1JnTUlYZEFkVUY1RXF5UXNJMHBkZE1Cbk5PVklr?=
 =?utf-8?B?UUJJcHhUbkE2dG9mRkx6T2JEOTVhcmExY3JpL2w4ZVpQTll3WnVHS3Y2V0Z1?=
 =?utf-8?B?d1FpVUphYi9FdW1Vbzd5NXZVNldJVWd2TkFxUVI0bU5KL3gvQ20vc2pZay9H?=
 =?utf-8?B?SDQxZkhZdkRjRGMwcUdOSXUxTW5KNWs1a0ErWXZGb2k5V0dBZUZYR3RnK0VV?=
 =?utf-8?B?YVo5ZTk3SWlUVCttZ2k4YU1MbExyVTFYaXplbHo3c3FnS2VldlNTQzdGSU8v?=
 =?utf-8?B?bHlRVjdzR1BRRktOWldmaGozUm43N3BGaGFMYnBrWkFLWnArdjRYWnhUQnJ0?=
 =?utf-8?B?ZjRocmpJbHFLaGxuME1DTzlOcXBBTTdMZjErY0tSZGQxVEdpL0c2dG9Dc3Yx?=
 =?utf-8?B?MWdja3JJVzl1TElreExNZjVCQjR0SHJ6ZXNIcXpFM25uVVhwYktqa3I3bmJx?=
 =?utf-8?B?NjFRNlA4MGhwQWhhUTBmQkhGOEpuRmZBM0tMalpsVDJwdGlScEZrSWp3dHky?=
 =?utf-8?B?ZHZHaXJ3T245N3ZhMkd1WVl4WGtDM1JEWEhuQjBtVHA3N0pUZHlrTk90N2V0?=
 =?utf-8?B?K3ByR3Evd1dtZlIwYkZvR2M1alJZTi9JNlBZVjgxL2JtcTlMTXJSV2lpN1pU?=
 =?utf-8?B?dDQ1cy9HbjJyT0ZaaEp0d3ZTUnIyaVFYQm5OUFI3V1V4MjJ3L0l1MUZvVFlG?=
 =?utf-8?B?aW15RVBVTkgvWlRqNGd4bzhkdVQ1SGczMTlYdnNvZkNoaHVrWFB2R2ptQ1pM?=
 =?utf-8?B?TWVXSXVDTVRXbHpLNlUwWVZ0M3liaHZTd3NlVEtZUWlDUVp1NFI4ZUIxcnJx?=
 =?utf-8?B?blo5UUhTOGNHMmlHcko5RHhiMUx1T2xvVHVBckxENWUzTWlyQkViNjRyK2My?=
 =?utf-8?B?Z2lZMnowQmZ2WTd5Ykl2Rm9lb2dxNUpSa2w5QXBjVWxCQ21uQkRZR254a01n?=
 =?utf-8?B?ckRJd2tUWDdQeWJoVUVKVW1qcUpNR09jcDVOM1hoUys2T2dHcFJIRWszY2dk?=
 =?utf-8?B?MjdVZ21hRURHVjVMQ2pHY1FoUFJFTkUwU1VWdHBkT3NFWFNJUmZzWDhCbDhu?=
 =?utf-8?B?UkI1UHlIakRvWmhTbnpieDl1c2Q1ZS9DbU5nOExnOStJQVhNNHM4aDFnN2Fi?=
 =?utf-8?B?T1ExblFDSVZrQy9UekUvRVlzVUZ1NTRIWGRzMjdabkNqUWpjRGJDYVpaYWxG?=
 =?utf-8?B?YUg4dkpBUFcwa1F0Y0tQUVpqYWdQOG5JSUJnbXRvMVNKZjlucE9nbmVEeHhq?=
 =?utf-8?B?NVJjamdkd2tBQmlQZGRsbnZveHROdTVaT01WZlRybk9BU1dqd1pGUTgza0hh?=
 =?utf-8?B?ZDlOSTNIZUlmT1RFajd0UVpGRjJtc0l1WlR6YWM1bHg2WUdrdE81d0gvQ2Ix?=
 =?utf-8?B?bVNQN3c4MFk5dHNndVlLTXZtSTNXTFgrZjNBRy9VcTNPczJTdFlrbXQvWUo3?=
 =?utf-8?B?L1dxRVovVWZJNjRET0xGNjZGQVZvVS80UkdhOVphSVNtYlN0eU5la3k5WXNG?=
 =?utf-8?B?VDkwZVpVZkJuNW9HQ2VWZG1pNy8zazdJQkM5aWhmZDFYVEZ2c1hpTW1SdFJh?=
 =?utf-8?B?TEVvbitkRHNBZ1gwdG0rMElrOG9MZ0lHem1FTzNhcEdIajZGV0lVelJiMHJN?=
 =?utf-8?B?QkM2eFVBRHBmQmdjU0F4WHhjZ1VlOHB1M1RDWGp6RlN2c0hDR1JnNnBRaDNs?=
 =?utf-8?B?SXl2YmlBOUdxU0FuTTIvSmJQNlhXdXhCN1RaZHRGUng4TFNtUkYrMU5tbEpn?=
 =?utf-8?B?ZGJaWWNFR245SDdKcDBHSEYySWN1WnMyamFsRzE2cm9rbmZmdUNuem5yMUIr?=
 =?utf-8?B?WEQ0eGkveHg3R3dMc1NLbWhxcjV6OEZneHJtaEV6TklDTHRlWFVXQWxhbHNO?=
 =?utf-8?Q?JYSQBG5uCBgxdNvKYrFjuETYLqM/XXsQ?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 10:27:26.6108
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c2de306e-31af-4f6e-d1ee-08dcc8152dd0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004686.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8999

On Tue, 27 Aug 2024 16:35:24 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.7 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.10.7-rc1-gaa78b3c4e7ee
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

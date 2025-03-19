Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482A52135AD
	for <patches@lists.linux.dev>; Wed, 19 Mar 2025 19:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742412946; cv=fail; b=Uj7QDNJmoll4jqHe3fk7+PCwgiHaEuwUzIA20ivHn2DAeMCvz0ICPrFTP/5wjDkyjWrs5ghKoi2A0F4INe9gcAuL57/iQ9qtM9aLPyWKXB6npO6yOixLBMx9u+CFaGxxyV8jpgy1irMHw8IY7WLtz0WpSQ9+qC27haa6Nkol2/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742412946; c=relaxed/simple;
	bh=ZBd9jqA5o0KpUMU5sQOjIzCmt62yLNNsO54Nv/i+Fe4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=hVLESUwZ9gDL9zV36l13x0FYl1do80X6BoVf/MgIW4xzk8O1wVccObgCASZTY0YoI+sJZNoO4wVAgz1nX0VDJoaa+cDv6TwQuokfJOTasRpx1db2h/jldV6m5F3ymgHfsmTtCSEnCkmpbdIHlfWjx+H7Ie3Mrjucllk+u2VE61I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AqjqFWZ8; arc=fail smtp.client-ip=40.107.93.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AqjqFWZ8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zH8Q8VGo+WDvciOxbW3QlDrKvy2dI+oZFAKUNcmVnTqvzt1m5/0pfil1oF/78EIZBgC1C5KTRZYPFJ4CubbrdLA7amymsesh+ugUFwJwrJ/gSIdSzp2cdK47UMNx4JlewWCp+G2b5jF+zXq9tEunQEgpYVK0XsBbgDGRVB7jTJLRbc8jKLZusLoRZwTa4phHGrqtuJy7F7zapjpGcD2LQJ7zMvbgoymX0JnLhjP8+kmjhgtusSArpbPnrume6/iyp2hGWcZ9Hj6UwhJj0dEOSqQgosESW1cbJ4YndkHmZMt/NIc8Q8B1xNCpbtgAM8TKkn/pAQOe3cjHfc3Y7YbyTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MgVx8hH3V9/NExeeVVwIgTm/crMvFwv9aABhh+SbYkc=;
 b=V+IgjyTbBmX59KFBsEYA9xeOlhhYdyswSwNuVOIuup3H04F1ZXBEsLMnofqckcVoS+FMF7VDat8ptGkRCRyrsbG2wNd5BpHBwyfyrHst+qjntYsyatvlpb8rRu4WHOhuyTU2p6t+epU2eItOjBlNe75g1c3Iu0IOrX9Jf2ph3GFGDZXGGuS93en1GznMKbDR9S8sdsVic7WFaxmKIdGUBDjmqBo3jkTMHKcAg/rOAsz0xeIQ2t7qeFHUD8lgjGvKVdRtVcH+NKDMAWvPXvruIorSiqg+TqAOHUrbrI8FaH8FNkQmxOUWZI6Ht4g8bhIp4mOGaQOEdSydm4wiA4+AKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MgVx8hH3V9/NExeeVVwIgTm/crMvFwv9aABhh+SbYkc=;
 b=AqjqFWZ8StbCbIE5WZo8NdN6mt8ohLHcVq8v9p2RzSPcssIdi2pgWroS7lajONNGRZNS2R44c5oKbAmPXbKBSkMRvAKRx2fMjgKXrAYUxm50rMWVCnAvjXiThMu6ejp+qqO8u5GwbiCska8ZsLpBywTBj4gqWwhWp/Sdp6jKN5Dxx6ASMUTLZUVolT595ON8p+fScg/Tby3apbz41WdxEaLFEc1qEDSv2BQ5vYwFPfcAGWhrq6TprGJWKMRkURVo55H6JtHSmuEn75aCYZYNGnh/C07pjlTuiig1RKWblVjM3PwvHMEFJjrxRXSMGk86vfbxEOBp4Sx0gyLJmtgeYQ==
Received: from BN1PR10CA0013.namprd10.prod.outlook.com (2603:10b6:408:e0::18)
 by DS0PR12MB8270.namprd12.prod.outlook.com (2603:10b6:8:fe::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Wed, 19 Mar
 2025 19:35:40 +0000
Received: from BN1PEPF0000468C.namprd05.prod.outlook.com
 (2603:10b6:408:e0:cafe::a7) by BN1PR10CA0013.outlook.office365.com
 (2603:10b6:408:e0::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.34 via Frontend Transport; Wed,
 19 Mar 2025 19:35:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF0000468C.mail.protection.outlook.com (10.167.243.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Wed, 19 Mar 2025 19:35:39 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 19 Mar
 2025 12:35:22 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 19 Mar
 2025 12:35:21 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 19 Mar 2025 12:35:21 -0700
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
Subject: Re: [PATCH 6.12 000/231] 6.12.20-rc1 review
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e129f73c-a4c8-480f-86ad-49e0d6f05643@rnnvmail204.nvidia.com>
Date: Wed, 19 Mar 2025 12:35:21 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468C:EE_|DS0PR12MB8270:EE_
X-MS-Office365-Filtering-Correlation-Id: ae96e899-3733-4628-f9e7-08dd671d3b0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VjNIZkNUZXA0WDRvTURiZmZMTVloNTdkQnFzYUhVcXg5bUdDendsTUd4a3Qx?=
 =?utf-8?B?eTlCYkY4WlEzdng1eWk1OXUrRWF6ZVpRZ051ZWhtS3FzaDhlaHRjNjVySWlQ?=
 =?utf-8?B?ZTlwblF4UDBPSWZNUjM1ODdJcHV4aGU4a3EwczVHUHZUaWtDbGxSSFRZT1VS?=
 =?utf-8?B?L2ZMNzNkTXp3Z1pzeFhqR3dNVUpkNXA0cXIrWDhSdmQycDZDcWFtYjllNzdy?=
 =?utf-8?B?cUVIRTZrME5DUWxKQllyYXJwbXllVGp4aUdDb3JOVVZRUzQ3UThycTYrQTNh?=
 =?utf-8?B?cVJ5QzdTSFZGZWU3VDNGTmtzMnNJUCt5ZmdlT2g4VHVsdVo1SjJyYTZhbk52?=
 =?utf-8?B?NHpSMURwMFU3T0Z4dnFyVElhOWpONmNyTGF1WCtMTFJXck9XRTJkSUp6Z1Jq?=
 =?utf-8?B?aVp4MFJIejlDeDlrQlVyZ3gxbi9BYm9qQUNVNG13NUFOcGdjVnM3dkprT3cz?=
 =?utf-8?B?STVxY2RGS2wyeHRmZTJ6QlE2YlVLT1l2V3pkczV4L2JkMk04TlhJTzJxN21W?=
 =?utf-8?B?TnFmSEdFcmZ2REZVY3I1RTE2M1EzOGVFa0hJUFRkdExpRlkvem5oZVZySlpM?=
 =?utf-8?B?ZUt3b1orbU9WSXpmUFRrR3MyL1RwcjBFN2ZrZW54SlhxNzlZNjNEeXp2MG9z?=
 =?utf-8?B?RjRMVjM5dldFYnpleE1aekhpbTF6TFJFTkY2YkI5K0dKbkZEN2hPU1lsMWhn?=
 =?utf-8?B?MkFORkh1dmtRMVc0ZjRIQ0hsTlU5UkcrTE1qVnl6VGZhZ0RMeS9rZjA1eHk5?=
 =?utf-8?B?ZGtzdmxiU0owVmFreDRZbml4V0FjMFJMTjF6MUlOb1lHSllCcC9tRUtiKzli?=
 =?utf-8?B?YWNwQ2dUTlNrVW50WXRQNUw5aG5naklBbVQ5Rk5rdU56WXRtb3k1NnFvTmJI?=
 =?utf-8?B?QjhGUHYwOHpYTnZENVR0RlkrVnVLNWkvZHNzOGFhZFlNYlc5K0FWbHhsT1do?=
 =?utf-8?B?TnA4Q3p0QUJ5SUxpdXkwN09DTGtjejVWUDBxdE1Hd2IwRXJxRU9EVmJpSlJs?=
 =?utf-8?B?UHc1TWVVU2VsN24xY21FdVpGQ2tHbUdqdXl6V2IzWjN2eHRMbHBnd3FWcE94?=
 =?utf-8?B?cHFZZVZnNFBrL0RTWEM4b0x3QkQrRzNvSU9qSmJxQXRKOFljMDYyZFZIQURu?=
 =?utf-8?B?VjRQQzNFQVFkOGw4NjllYTVhNSs5ZGtsSUxTY0IwL0QvRmkrYUVRQ0Y1eFE1?=
 =?utf-8?B?b2xYYTNWYzVrdFlqcGNkRE9SMSt3MGpFdkZlWGplclVKd0V6TlpxT1lhQWVa?=
 =?utf-8?B?ZStHT0Z4ZzQrKzVpU2lXVEhCR0t2RW8wVDZRU1NrSTB5aWRDZXIwcjIrYTFV?=
 =?utf-8?B?Y2RNL3hRRTc2aWh1aXZQNjV6bks0S0VHemlqVXd3UnZoNTVXY2pETkJIRmFY?=
 =?utf-8?B?dGtvcytOaUJGdzlHc2FGWHF2S0hnbjc2ekxoRDJ3bm1IWmE3L3NxbmxTZ2tM?=
 =?utf-8?B?eEZKb3AvTVB3M2Z2TmhldmpTQVBuZVdIR05tMCsvMkl5Q0d6VU15VjhOY2JF?=
 =?utf-8?B?MmJick5aWFlEa2I4QkJpZ0dlR0ZnY0FkQUFRWWVpamdHZHEyUzNGRG11dzZv?=
 =?utf-8?B?L21ET3VORUZhU2xKUDJKajZ1ZzMrNnJ3NW9IZFZvaU1aYUFOdUxKWFRreUxz?=
 =?utf-8?B?ckQyRXFNaUlaWjN4WjVjb1VjTnBzcVpFNTdxMTk5STdGbEROb1o3WWtYSWd6?=
 =?utf-8?B?cmd3dlloa0Nnelc5YTVtalhpLzhWQzJjejA0L1JHSGR4K3RVaTFtTEd4cmpE?=
 =?utf-8?B?VkZPbnViTHNXZHZVUGk3MkNBLzlxdXhSL2hRZzlSWXlaQ095YW56aUJ4SGZz?=
 =?utf-8?B?NGZNTXV0cTBmd1pIeFptQlJjUkZQdWliUmVTbU9SZThpK01CVFlVZk5IOFIv?=
 =?utf-8?B?NlE5ak12SGFpS1dPN1p5czl1cjF2QlNEUmNHd013UjhTdXBjUWIvS0xBRmtV?=
 =?utf-8?B?OGRoWXVkdGJ3b2pJVDVjTUo1aFdiQ0VTNis1RVhaU1E2TUZqZFFZVkhtSDkw?=
 =?utf-8?Q?Nhj1VqTaCIXAw7WFyMG8tsw3vanias=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2025 19:35:39.6956
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ae96e899-3733-4628-f9e7-08dd671d3b0b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8270

On Wed, 19 Mar 2025 07:28:13 -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.20 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Mar 2025 14:29:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.20-rc1.gz
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
    116 tests:	116 pass, 0 fail

Linux version:	6.12.20-rc1-g981e6790e185
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

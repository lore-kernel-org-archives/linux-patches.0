Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2058.outbound.protection.outlook.com [40.107.236.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950BE2E2F0E
	for <patches@lists.linux.dev>; Thu, 21 Aug 2025 14:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755788202; cv=fail; b=OU8SQCHHssoUdEYfnXcHDG/itZxRcc7wC7r0tstlaA0ZyIck5D62mCYmc5n6bu70V54QiBRyvxWs/AoFNED+8EgZsVrAEVxa3bZ3LRUKOCvE4RRIQ17krdbDBf/1XsttysREWzOz/Y464u+bgP9OPIs/6uiuw160hDuz8SKtoWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755788202; c=relaxed/simple;
	bh=ld6/ecGJiEZydo3OCtJYzhDHHos4sc/GcXF/B3VVpCc=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Z+tXe9Fgx+ITsqFfPKhg6auZcsSTNs85uer/zT/+nLVWhGrfCCW5nMjtC5RvXii0eqCCTZZAFTTyd2+nBFoamIWGKtRs5sX/dW4m500MXVzbC2udNg4E3NhXJ7U0sTdDZ+LbRT6gFlabOdKtdUJOr3OZseXYKTXuldZWErQR2/s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lXGqo0Rq; arc=fail smtp.client-ip=40.107.236.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lXGqo0Rq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t0LY+WbQEPmpPCsSQZp6Jf1vPdji/pusEwEo8nOtT60W9fvHR3hf3w/Anqsg+xwZZWLBGE9wJoHa9CldbKujcMrD3dz4jojy24U9MjJEMgWvxZJFqPuU9yY95qJtLRn/OFIcIy+gQrfuei4p8MczZcBfAJA7vByvKZEOHjRHGIayJHr3jOqSLScZzEH1uin8N6kmAhJ2axM8Lt8TtBT/lklUaEWY02MC5jp5aeNz+MZJOoV9hBYy67CjGu7zSrE5mELiHiq8H+3ujTWTTUautZ18omeD1eLsr/kime9/zGFbFK3G6m1HrYqnqkaYM1bHUH+i+WlXiFb3OmKelGSyRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNQrTXiPOZnNjwH69s0hfm4YTYncHFrwb6nTx1zq+p4=;
 b=xvBWtWJbi8EipVnkPsgdcSdAxNK6QJdMq2LpBvNALa8r6a0w0XEOvnn9LdlCZgms1a31y+F9yAcHnYN2/oDEruo9xiGKxk3SJlpJjxdakFy3Ffd30/Kphoxigk8Ko4oa+41i+DA4qGu+3CGe0alWYr6irU7ArZ5FIlNLJMO7cpmYf/zImq0xhbZ3nW9MYq8SbxgRal4n46Sv40oUZnHKMZA9WwY9Fz0VBxF0HjVG+dMGTbVSYD7ilawAm21J8R1pewTs9LfXe4Jdgw7KiVqvV1vS7a/5DxtQPwwR49ep0XkRAIIl1ceMNT5WxbCABjXjBZ+f3GtDZJzocgT+gil95w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oNQrTXiPOZnNjwH69s0hfm4YTYncHFrwb6nTx1zq+p4=;
 b=lXGqo0RqqtQTDxcnPG+u6cl63q/m2fhzYqtSDdtT1JRI4CDcv7gKZbGyrWzb9jXlQBeBm5Xu//DjqhjTaGe5iGpEO4+twcIvaWezdSKDPtHDTOSu4waIxIw5bB4KcYdux9ayem/iDoEv9ogMwV8cAoB82y5ZQ9VN2j88dfs2nTrM0Bpi1s4b/rGVi3cc2n4fTa29DhVnlCWmu9yKWLzumYF7Icga1VlNHxceICbj8ftQt329TW7KcthAgHxTgCxqndxsLkbRfBc5pMDwIOhnz4yv4qUWyNZFQkgOcOKyeSMC0YgXpXmxmnhlLsHBcd6qNbnSJhdOyVhoQ88Vp+SdaA==
Received: from PH8PR20CA0020.namprd20.prod.outlook.com (2603:10b6:510:23c::21)
 by PH0PR12MB8775.namprd12.prod.outlook.com (2603:10b6:510:28e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Thu, 21 Aug
 2025 14:56:36 +0000
Received: from SN1PEPF000252A2.namprd05.prod.outlook.com
 (2603:10b6:510:23c:cafe::1) by PH8PR20CA0020.outlook.office365.com
 (2603:10b6:510:23c::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.16 via Frontend Transport; Thu,
 21 Aug 2025 14:56:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF000252A2.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.8 via Frontend Transport; Thu, 21 Aug 2025 14:56:36 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 21 Aug
 2025 07:56:15 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 21 Aug
 2025 07:56:14 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 21 Aug 2025 07:56:14 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hargar@microsoft.com>,
	<broonie@kernel.org>, <achill@achill.org>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.15 000/509] 6.15.11-rc2 review
In-Reply-To: <20250819122834.836683687@linuxfoundation.org>
References: <20250819122834.836683687@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f4249250-73f4-4b80-83f0-61e4f8f951f3@rnnvmail203.nvidia.com>
Date: Thu, 21 Aug 2025 07:56:14 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A2:EE_|PH0PR12MB8775:EE_
X-MS-Office365-Filtering-Correlation-Id: 1223a45b-d484-4458-aa9e-08dde0c2ed07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bXFMeTZhZWtHTnpyQ21PS1VQZVpHUHBXeEdmSnlyZ0ZLNk1MamR0WlJYTDcr?=
 =?utf-8?B?ZzVkMVZwK2o5cUhhZDNkL3VpS0I2RzkzaEVVYVFKbDZqa0JrczVTYkdDby9k?=
 =?utf-8?B?YUJib0R2YzJnU3RwcEhLWGplWmx3ZXZHblY5MFpWMDIydmpuVEhEWm1qREVo?=
 =?utf-8?B?R0tkZ0RaV0ZVZnpkcEVVcnFRaUE4VVh5bmN6OEIvOGxtWGpzV2twUGFlbnVF?=
 =?utf-8?B?VTN3YytOM2dIdnRuRldtQkhhbU9ldDZSdTl4NjVRQml0VWgzT3RDZzg1T2JI?=
 =?utf-8?B?b2txa1dIdldUVnpGbWVKa21QQXJ6RDd5N3gxV0IxTXJVRTVWL2lEdnh2ajM4?=
 =?utf-8?B?cUR4ZGs3UmM2dDFKWU5pcUpuV00ycXkyc1VxWCtkMFdzNjh3VmJqT1YrMGZB?=
 =?utf-8?B?SFFlVUhMeFd0TEdWNWdOVUJxM084MTVLQkEwWFRMS0tRdDNoZEYyTVR3cUFT?=
 =?utf-8?B?Sm5pWEphaXhIUVE1OWNGSHljYVZFV1gxOVd2OHhqcUJMS2owcWpKTDlFVEo0?=
 =?utf-8?B?bEFvY0p3VnAwdDh6aEtCRk9McEtLczh3b0JzbmZETUFRYUJpSUM5Mldoc3FM?=
 =?utf-8?B?ZDBFemJlWk5EN1lFazFkWkpXbFlJTTZvNU1DOG9mQ0cxdmt4L3kyZ1hOQjdS?=
 =?utf-8?B?M3NXelBDbEpiVFcyK0JxR3hvaHB2NEh4dExEekNYK2lONTJlektqczQ0YXY5?=
 =?utf-8?B?SGpTZDd3RGpDOHJpV0pxMkxSaXU0SFB2dnFMcHFISnd6UFVzb2s1TEJSay9w?=
 =?utf-8?B?ME9QcXUvZzlHdHVYYlBIRUVQam1xMkF5ZlVzWkRqZUV0NkZicFUrOFNYeU8x?=
 =?utf-8?B?V0h1bkVSYWgvTHpOUWtNRU9XcW04SzViMWM1QjRTRWNhQnBZaTZFNENPRUVi?=
 =?utf-8?B?ek01RDVlQ25RQTAxdk01VzErZm80RDJLUWdCWEVSVThkZFozaUpCUUNKUG1Z?=
 =?utf-8?B?bnl2SlFJb2xNNXNqeUpLdEVYWXhBQVpGYlZ2V1RFMEZZUERENUd5QmhoTStT?=
 =?utf-8?B?UGw3aFlDWGdTVWlwM1JHbjFDVVVNUUdqNmFXMzBJNGFMWmJxQzFlZUFjUHhp?=
 =?utf-8?B?dW9US0x3ZmcrSlNHbXZQWlJHT2ZSbURXc3NkMVYvNlBmS0Z0YjZPWVhpTHBF?=
 =?utf-8?B?bVhndWRNZ1RjWG9JMlBGclJidUJYRXllYmVFT3RNNkQwbTc0dDNYTjVYUG1Z?=
 =?utf-8?B?YmVxTi9CVXJWZEhDRGVBY3YwOGFyMlpBUlBXYWd4UVVaL0ZuZklORnZZcHBQ?=
 =?utf-8?B?bUtNQ0NJL1pYamw2VlNUNWxNWVh3bTRUcmFJcmlqSmhwdXlrT2dpWGZnbGxp?=
 =?utf-8?B?bXAwNGZWZnBEQmtsQTc1ekVUY2dZRVppZ0NFSHNBUzU0cXhjQ0V2VjlUTmZw?=
 =?utf-8?B?eEoxMW5LME42SUhnd1h6bFAzSXh3UEl5L3l6QksySyt6bDZ3clZ6T0NJZWxp?=
 =?utf-8?B?TSsvZU9QQWVscFdldytXeFZiVDhiN05TMGoyTEZzQnQ4dUJROHhGQ0J5Q1g2?=
 =?utf-8?B?UnU3dTFMUGo1V3UrNE9DaXlBcCs0MG1mdUdOOUZSZ2NsM2ZRbSttMDhpMmty?=
 =?utf-8?B?aEVqNjJoa2hHUVNGWjJxUUtpaVdmckZ3ZVU0bXBmaWF1Si85SkNMYkxWVGll?=
 =?utf-8?B?WitEbmhEUHJkYURWdUZpdThIeXpQTWRTdGhDcFFaNDFlVGRYamJabUNxY3lm?=
 =?utf-8?B?dW93clRtNWx6SnoxQk92NFBuQ3FTTXlaWjRqV0hRMFIyK1Y5MmdJYlg2VFJq?=
 =?utf-8?B?ODhqMGJkamQwY0NOTEpabUZpV3Q2dVpxNlBNdXR3bm9DRDNhM1JrT2xNbTk4?=
 =?utf-8?B?V2dwL0ZYTXFpUjh0Y28vTEtlTk9FVCsxbjBHczkxSEkxWEV1NEVsNFVXcFJO?=
 =?utf-8?B?Wm80QVlITlRoclJudEtUSjNRVGhZNVRTTExiRHdieUQ4cGlrODBQSm9WV01G?=
 =?utf-8?B?Qm01VmYzN051L2RnNndyRkFmY2NGMjBQVXlOZnBNZHhCaVVoYnQ5VU94RmRP?=
 =?utf-8?B?VWc3dWd3N0dGYnRBNmk0V0dCWW5NdTR2WXNJb0E2d3o2U3BPTWRxaCtneWpz?=
 =?utf-8?B?a3RabEh0OVkwRnora3VaTUdNVUYyLzBWSERWZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 14:56:36.0006
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1223a45b-d484-4458-aa9e-08dde0c2ed07
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8775

On Tue, 19 Aug 2025 14:31:36 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.11 release.
> There are 509 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Aug 2025 12:27:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.11-rc2.gz
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

Linux version:	6.15.11-rc2-gcf068471031d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

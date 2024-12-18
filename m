Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B731FA240
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 17:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734542492; cv=fail; b=fOTuOFNh4S93BydzgM1x4zpYqwTRFGWMaoICHgjsU6eh4IlG9UmBvdsqaY10dtrBBQ95CnjAufCcLMnaUNhRRN4v1CAujVHEeeGWHX93rFdd0R+FMfgaNQhRhF8etWKewuCmqG8IuEBigHkpeHNvBOYsceBTTXXwC0KXN4SRhWQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734542492; c=relaxed/simple;
	bh=EiWQDieLfkNk8kXjewYVZU67y/QCTW/DyKd/3uMi/pY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=POm81/0nlUlo1dAdRtrmyjLYs618drly6+aNmXnmINyGC4T/glddPbREqmulD2ckmlHvtHK5T2Vfogs9bmgN7hr/UoAsIsjaNSeUjBQ4Gka2EaUYSSZrMX/OXek+NuSaCADkWR83RO/Bts1nBmUfRfQwrHV/d6Ds9ad8NdSbcrY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=N577dMap; arc=fail smtp.client-ip=40.107.243.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N577dMap"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vj95xSNqJHY5GRUQ8xLbXedxIa3r6qGfqmwl5U//1Ah5SW0dCqBCxdAQ3WaE1/s+6uvAaI90OWOzgal1RU31iQNFYdnSMWKAQ04dOoMeQ2F388ljAhssU2gvo2ChCwHtNFHUgbK0xyJTSEcY/7geSvAdi9ZPwHtuyxsYZ0RP0JFtlf+MTHenYytXJNN2FpPfnctUyJnv+8jriK6qHhXq7GBQIpCOhANePk27oEGA9S/oicy8db0ru7VB4gHCRWLMJ6vR5HuqCDtKW18+m665ODMLCx+KC3X2QxC5FfJe8Kl5JTehiDuChkAncVWqQGEMXCkJjIDG5QDBPMBohzhyMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ecc+zBE4mVbKNBjSiyfZV5A2vjJbA7yMnRbWInZbcCw=;
 b=QgAtbvXMBJDHo/4ijjqTKrC58dcJFgF9pj0y25t+c/hoD9AjlumoCz4ZR/tetKzX6AZUGqALPDs855rlpEVA5djZrveV2Dq1zYmr3+HKeUvCfiLaNoUqfoEOFDgy2ifFBeDF7RpnQRhetbl1JBRt2yIEvGVhuZFZYe3PahdLOqMQ1wxTaxqZ7s2smqOy4rN0Jy8hOJ0BjPVTR6m9QJG+0D0oIunfHUFP33TloaIdw21uXvyYvcczzZhFbUXE4cA9ZAJK9zt22sTjI2ahZCqyOEC7l5MxyQiZWvhtMObdBhKy96OzvrLHlGh2LrxWrt7MTW1ZuRcTg2suafgd7+aquA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ecc+zBE4mVbKNBjSiyfZV5A2vjJbA7yMnRbWInZbcCw=;
 b=N577dMap9EOUCNs3o2LwcVIFfv++39jXSbayo1RWxfE1VJa6w1/9kzTnx2t+aWPYxvHhb4ovlEo3XNtXVj05CC6wCirJCrmeiDQPUzIchrZFE6pzINP90AJea2VDOW25AY+K9RhOpLGUj5K6kyku+lNNzheIBKuRhfplx2SNLG65DybgQb3U5iStBeyyhadK4buKfyJM8G7Btw9aAK2EUqQmp6rVTO9wLfBqgWfB3+m1E0E4qiUmU77hA05WcBuxs20hhq9WaxNItW4IiJWpTQFULFoNO265bOIYGlDv5MoN7agxM2lDwk6TYEazmovBTEjRdDcPwQi+3eY2NN0ipQ==
Received: from MN0PR05CA0023.namprd05.prod.outlook.com (2603:10b6:208:52c::14)
 by SA1PR12MB7367.namprd12.prod.outlook.com (2603:10b6:806:2b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.13; Wed, 18 Dec
 2024 17:21:27 +0000
Received: from BL6PEPF00020E65.namprd04.prod.outlook.com
 (2603:10b6:208:52c:cafe::58) by MN0PR05CA0023.outlook.office365.com
 (2603:10b6:208:52c::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.21 via Frontend Transport; Wed,
 18 Dec 2024 17:21:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF00020E65.mail.protection.outlook.com (10.167.249.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.15 via Frontend Transport; Wed, 18 Dec 2024 17:21:27 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 18 Dec
 2024 09:21:09 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 18 Dec
 2024 09:21:08 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 18 Dec 2024 09:21:08 -0800
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
Subject: Re: [PATCH 6.1 00/76] 6.1.121-rc1 review
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e3d7dd7e-0ea9-42a9-90dc-f95b4bdb7765@rnnvmail202.nvidia.com>
Date: Wed, 18 Dec 2024 09:21:08 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E65:EE_|SA1PR12MB7367:EE_
X-MS-Office365-Filtering-Correlation-Id: b2c97ac9-7574-4e41-2f3d-08dd1f8867e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MnptQ3B3QWtBUUFQaVdpbU1XN2tZeEdrRjBwQ0REWkNuMlJjb3YzSmFzOTVV?=
 =?utf-8?B?REUzV2haTGRxR3ZxTllOdUpmd1A5cTlZU1UxSHNlMU5hMUZxR1JNZmQ5dTBa?=
 =?utf-8?B?N3YrOTJlYnlSQXZWRjNiV292T0w3NW00eGZlSDBqOVZ4eVhkaEpxWGJCeWZl?=
 =?utf-8?B?NjFDMCtHZmpaWDdxb2o0TTVmM0VqQmNyYWJITnBLMCtleU9sTWxXTXpSQzR2?=
 =?utf-8?B?NTEyYlk1QjVhaDJkdkJhd1N5RUpCTk5RU2NnZm96WjVuWXVjRFoweUxHRExy?=
 =?utf-8?B?YlBtTWlVSnBxZnRCYTRVVERvdlJFY3RZNFh2Q1VFS1RDRzJhL2NxekhudXZn?=
 =?utf-8?B?UzhtUm5YZlYzVkRnSzVsYVQ0Unl6YmFxdnVwbUhtdHRTTnozTjlidXdSOVRF?=
 =?utf-8?B?SENjbUw5T0d0YjNRdW5DVWdMZ0VwSUNSZWZIVU1oNGxpRnlKMmtYYUNzckJK?=
 =?utf-8?B?OFV5VFZNdzJxc3JxZzZyS2k3Uy9lN1U2alk1R0hPRitHNDZuNUwyUzBHSHZE?=
 =?utf-8?B?SXowS0hRYjE0Y2E5ekdoWkVkTG1FaWdzUUVubHh4T25HcHp2OVNqOHZ4VnNp?=
 =?utf-8?B?OWluRXdDWXUrd2xCai9UVnZiLzRJTTRyQ0NNZytpVkt6Q2xVU2NpbmxpRlZi?=
 =?utf-8?B?bkpaY2xuSU5zK2NPQVZnbndwbFg4cGhsSkhTM09taUVhN05QZmttWnlMMi9X?=
 =?utf-8?B?Tmx2ODlHeFJ6YWU0czJYS09WaSsvQ3MrMklDLzArN013QkZBTFJUODNueFFR?=
 =?utf-8?B?TVlNNGl6QnQzUDRYekJCUStNSkhnUEE3bVEvTmh2UzViM0VMcGgzS0JBNWUz?=
 =?utf-8?B?Q05YaEZvbzFwZ3JMWmxJMGU0WERlc2kzRTQ0MnpUa0F6M2c5TFBCSkRIZnYz?=
 =?utf-8?B?K09uTUhRVmptamQ3anM4b2U1ZHE4aWZXbjlVeGJjUm5sc1VsaFJmejR1QXdt?=
 =?utf-8?B?VTZ2WmlQd1drM0R4MWltZ1FXQ2F1M1RoNFYzdnNCSWU4cVZZZjZjeU1OdnBr?=
 =?utf-8?B?NkxkbHlxd3ZRNTFpakcrT1M4aXg3REt5UVd4RnVnUjRQS3cxNjVVWS9GSDVm?=
 =?utf-8?B?Z2JqY2NBUC83VWxwNzJrbGoybSsvUkpSa2NTVUl4MHE5ekdyRGNPSzJBK2w4?=
 =?utf-8?B?aTQ5T2NOSG0xSlVocU5aaDVtbERyb1JUNTZsODRNZGRDRVJ3YzNwL0JvTVlq?=
 =?utf-8?B?WExVbUprYVRNU2VUaEk3OEM2K2E3NTlmNS8rNXF5VjVJVVR3bm4xZWFzWnZ2?=
 =?utf-8?B?ditQTVJwMFBXUVBNL0V0bE9SdFZpdEZ4SlMyYkZ4NkJMMHp6TW9NY0h0MStV?=
 =?utf-8?B?RmNZL3ZadGk1VTlPL3lLblVQdVZDb0hJMTFHY1ljZG1wa29VZ2I1dUZrOFhz?=
 =?utf-8?B?cXA0REhYVWV4a0ZwbnRPc2F6SlB1YW8ydEI0SGl5cVNmVkhkNFloMXU5ZVFH?=
 =?utf-8?B?clhSZTJqUDZQUFllVk96bGxlanVPVkYvSVdlc1pkdHRnMUZZTmgvK0NsK3Zv?=
 =?utf-8?B?ZjNBRVV0STl5eUY0QUJqQThxei9uM1lLbEUwSXdidlJSTzBya2Z6N2dTVStI?=
 =?utf-8?B?K1lnNVYwM0lvcklveGt4QmJ1TGFtV3Y0cHNIWTBOMVBCOFI0SForY0N0aTZt?=
 =?utf-8?B?TXJxZU1yY2wzVmFMKy8yZWFvZGxWVjhjaC8wbklSR3NLUWVSSU9lTW56ajFm?=
 =?utf-8?B?eUVBMHdBbS9odlZxb2IybzEzZ3RXZkkzemVpZ1RvYzlHOXpTRTdMU0xZQW82?=
 =?utf-8?B?QzhyS3k2TlE0VzlYM01WYWd6ajdFRy95b1pXUVhwZ2hkdW9HZWpOYSs2U2FP?=
 =?utf-8?B?ZXltMnFTazhtOUR1aHpWOTRYQ09VSUZ1Zkh3L0xoZWZEdDN5blpoazVJSEk3?=
 =?utf-8?B?cXZxUzhDK2lTTTVSemJXMnV4VWVYV0oxV1pUNW1tN0NSdExXTmVtL05UYldt?=
 =?utf-8?B?VHIxdkQzWmFSdGNidXVvQ0NGeDJUcUEyMDEzcWRzS0VhYjltT0pNSTVXclB3?=
 =?utf-8?Q?Z5oxi9AcjV98PvCo5oROVJVJNCqTrw=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 17:21:27.3533
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b2c97ac9-7574-4e41-2f3d-08dd1f8867e5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E65.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7367

On Tue, 17 Dec 2024 18:06:40 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.121 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.121-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    115 tests:	115 pass, 0 fail

Linux version:	6.1.121-rc1-g1855e5062cab
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1C8131E2D
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 08:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725353112; cv=fail; b=crX2fY6gfOheao8/keWGbUiTHNVVbUAvso0nu38kzVUNz42PZp1eRdTdXbmrZvgh+rlFjAurczou4iuiH9Yn9xSo+rQhMZ2ewpWPNQgLh7CF+nH2ticYJO8aNvH7rqo0s+eKUp3DOrnxo5HUQoocJfq8jEKdimNaQVDj/Kwhsgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725353112; c=relaxed/simple;
	bh=QgHSqWjtpdTPY7iCJp6IN0maAJXSyQZB33/6h8qyhXA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=f4qFbdbKt1g9llksKFrMWZe38C2mI+UI3faf5n+B2rQ2pTjp3THOqnCwv/0VxygjBwWg4OnaZLkkl2LK+0EP0zDYzdG9Juvq9rcKdcjJDdynz56BI/rgcytzdJMnHl/i5g0Wg2BVXk2nwmjdiEexaJg3nikD7ahlCvE8DBN8NGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZX6/xien; arc=fail smtp.client-ip=40.107.237.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZX6/xien"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OTNlg6jc4rD8cX4oZSJXQibM7mbAaA/bRqJ3Nz59n9lFZFO+wgKo2lXvmPBFOEee2aYdnCIX2cJmgk5NPhMrGvqtXvqG+WDTDtRsITryIbuP0ThD1NPOJYQeaLP3JUps6pjArrSIk4kn32azrDJlQczPDpG2OsA/tRAB8IpjwGVc5TxoVasFOH4KOUmzb2Mia5XfrvkULEX96W3Hur4Sk50RFMY/GXbD5cP7x7tNl68IurEyNG1X8ts8tP4L4s5cxtRTj5s516CqfggPzsmgK1qrob5jaF9G8N4sfyuIfkQILZPNthBNiaeZSVDXOAxkNcxQzm55qwfWvtkf48emEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOA/lpsH5BebeNGcpb2VySqlMsGK/TMrXGNxjMctgQY=;
 b=FN86rIWJ1mialD4eMsRBNOPMw3ZRq6v/2TsJW08n2YL2v2o9VUeNWMOgLe9RS1icaD1KgkeCYeeT3BaSRqPrpzXZYzW0J0xECzB8LWf+7UpQg7QlzIRfbN/kSrRm8CpXAb6uQ1fnXlYG30Fkr8Wb7VJeDs6IAgYcMIksF/yqyKH70otNnA4MbIKWYLOYjUW2GbNEDSdbMVnzC4nca0XYeMEjZlY5SaviY4n3U09DAu1IPJnRiWLckmD+oeHCJI8Pg3+NOZkZRLJcwi3r7o2p82RO/518ddaC+0RxwylqH38FMP2BLkPJh3y2gU2yTebSJA1OxV3Day/ZEZ/RSByEGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOA/lpsH5BebeNGcpb2VySqlMsGK/TMrXGNxjMctgQY=;
 b=ZX6/xien9wsdv4LQPhZN83uzY6xpI+ZC+p01sF0O/dR/FLS6Oo7susCvNMVKvHLA02674+gFbR+da2dXuI808OMiQE4b0u3kRThfNtgEUR8UY7w4fuv8Ai04MXyp2QJUsN91i4CIyMzpay89d1Or6wVlw08KOpfmCEVGuP16gTcPwnW+10wOmn0PbvelwudkbuXuRGJ3lcAn9aBeXzXqeUHWI3DqjAw/njoTyG8xU5gKge/xTFjHR0qIDCY2h2ZJew48zbWV44xS/x6pG/4aX3jnwL9iYwnUNpizXbAC2Ihcc2Re9nZc1ao2OtWL4RWXcLtg//ky5IM/JXsIOVbV7w==
Received: from CY5PR13CA0073.namprd13.prod.outlook.com (2603:10b6:930:a::33)
 by DS7PR12MB6336.namprd12.prod.outlook.com (2603:10b6:8:93::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.24; Tue, 3 Sep 2024 08:45:02 +0000
Received: from CY4PEPF0000EDD5.namprd03.prod.outlook.com
 (2603:10b6:930:a:cafe::81) by CY5PR13CA0073.outlook.office365.com
 (2603:10b6:930:a::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.12 via Frontend
 Transport; Tue, 3 Sep 2024 08:45:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EDD5.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Tue, 3 Sep 2024 08:45:02 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 3 Sep 2024
 01:44:44 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 3 Sep 2024
 01:44:43 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 3 Sep 2024 01:44:43 -0700
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
Subject: Re: [PATCH 6.1 00/71] 6.1.108-rc1 review
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <59d40b19-abf1-4dc1-b8d2-3f6df0182e88@rnnvmail204.nvidia.com>
Date: Tue, 3 Sep 2024 01:44:43 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD5:EE_|DS7PR12MB6336:EE_
X-MS-Office365-Filtering-Correlation-Id: 982ff67a-cb22-46c6-38f8-08dccbf4b37f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cVY5ZFRYYm03eC96dENnek94ZktIVm5XZzRIbHBVZUlQbE5mMnFaRE0wSjg2?=
 =?utf-8?B?bVN6TTAzTFJrbHNtRElnNlFrbTI0UWpvcml2WFF1MEN3ZFFXMlhyVjJ0bEV6?=
 =?utf-8?B?M3ZQdVg4dW13YkN0OWRNVjR1VVYyN3pzQ0dHcEQ3a3kyYzdCam9GL29reERE?=
 =?utf-8?B?VXlnVmZmVjZrRXg4ZFk3YTF0cEdZTjBydUtpTHJVVTVlVEI0dEpKcmtwNGha?=
 =?utf-8?B?RjdpRW9QTEtvU0VSSTU0K1I5ZFQ4dFh4Vm80Z3VPRnhrK2d1c0ZHa0czSGRG?=
 =?utf-8?B?czZkWlk0MGdtaElVNHFvajdQRDVnNWttV2dsQnNOakcxai8zejk2WnZPNm1F?=
 =?utf-8?B?WllIOHh6YVpsbHJtbG93S0xwaEhGZGorcVFJeGYyUzkzbklkdGxlSWpxcGJT?=
 =?utf-8?B?Y1JId0kvVytBM0I1VllKRmJFV0ViUnI2eXpZZGx4Ty9NcHBobXJhdTlDYnk4?=
 =?utf-8?B?cDZwUEI2b3VWMDlOc0tpd3I2K1dyVmZIcHJ2TURMR2Z5SmhOdGcwb0h1L3pu?=
 =?utf-8?B?eVN2NDFSYktlYnJ0NkFIZ01UWm1XaXBHV0FWVDBITUdrZmdkaCtWWkg4WTJQ?=
 =?utf-8?B?MHZQL1dxMTBYc0FwckIvUnFueUM1SnFVME5GYzBacmp6ZXZRQTRzMFE5SGhn?=
 =?utf-8?B?MkpVMjYvSnhMYzhudEFJbzdxY0swOE56MEZkb21JZUNYMkhrWWU5U1NHTXNP?=
 =?utf-8?B?YVYyNEdpZWpuTndaczBrZitYWEFkYStRR0xwN0M4dnFQZnpZTnlGeFpQM01T?=
 =?utf-8?B?S0lIelFBeHBZOHpudnhadzlkZTE1cFRJVjdlK3A4OWhsV2tnaXNYN1VSY2pW?=
 =?utf-8?B?cml5STZDMXRXV0o3Z2wvbFF5MVIzMGFNaDZ2TWRQSHF4SUdPTnYvNjNWZEVm?=
 =?utf-8?B?MUlKZm9QY29WQUt4dmhZekI1RGJaUW1hb2d3NCt0QTdiZ2lhZk1sNFlTZm5q?=
 =?utf-8?B?Q21VZmZiNHpjaHY1WnF2Tm1EUVdjcUY0Wk11aTlWNUp1dVJXRmdFWEgxZXNC?=
 =?utf-8?B?Z01MeFpDSUh6UHRPSlM2ZEhTWEdOaVBCR1lrc3UvSEdiejJPWlRqK0RBSENH?=
 =?utf-8?B?NHBWL0JpRFpmUXFvUTQwRmFZN0c4aDFkZDNjVlBROTA2S0hneXRaUkIvUUNJ?=
 =?utf-8?B?dlMrTkhpZHp4Nk1aU3l2S1J6cmlvTkN3ZXFkSWZ2S3VOaVhOWlhwRmdycmZQ?=
 =?utf-8?B?MmR0L2JMVEZBTXVUOXBuenBCTVZUL0t5d3U5VXFqUE1xaDIwZ2Q4YWRiT1V0?=
 =?utf-8?B?L2hiU3lpemk3ZmR5eXBjUFM4bTE4b08yOFFIV2FtRWRBakhybUJQTXNDdzBw?=
 =?utf-8?B?YldkMU9HWXQyVElJSGI4aHZwSks0ZDRLL0xBbXFNVS9PTFo3b2N1T21MeGRR?=
 =?utf-8?B?QVliTVQ4dVppR2pqYitOdlFTb3d5Z1E4VE91MEpDQnlNRzM4S2VrVkZwWnp4?=
 =?utf-8?B?NE9GSXRjYVhZWGlFNHJ5UkMxU3VXWXlEMCtWbVFQTFREWlZqc0M2cDZJcm9V?=
 =?utf-8?B?UWVlSklEMnVwbkFoQWFidFhtQVBnZm9HSEZ5dGdpSTZWYmZrRTlwcm9ZTEdv?=
 =?utf-8?B?Z1BpbklvWkt0L3BoQ25JRDh2TGgxMGhmTUlBK2s2Um5yM2xDQldnRFdaVGxZ?=
 =?utf-8?B?RWdNRlE3L3ZrUitDNGlNOTFXZTNtemlNVitUbDVaSGpsbSs5VlBqU0FITjVx?=
 =?utf-8?B?OThqSlVHUytIR2w3TVlOTXNuSGVDNVZsS3IyQTc4RVd6SUhRRFhiTFgrS2lz?=
 =?utf-8?B?M0hraVhHQzhIbDUvb3czbHg2cVFnUTFkMTNrOWF5OWtLT0Q4V1p0NmluQ3dI?=
 =?utf-8?B?SGx6Q21HSGJHT1F4MHZ5R1plQS8xZUduaGxjVHBaOVU0VFNpa01oeDlZbCtu?=
 =?utf-8?B?RUZEQVRWRGtvNmZOUDJXQUZRM2NqendSZlZEamoza2JxUnFyZk5MNU15a0tF?=
 =?utf-8?Q?NHRjEtv0AjHKpEqpZaXLZb1D8QKDVJNG?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 08:45:02.2123
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 982ff67a-cb22-46c6-38f8-08dccbf4b37f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6336

On Sun, 01 Sep 2024 18:17:05 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.108 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.108-rc1.gz
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

Linux version:	6.1.108-rc1-gde2d512f4921
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

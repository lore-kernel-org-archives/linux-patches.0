Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2083.outbound.protection.outlook.com [40.107.236.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E24D21E092
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 19:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795039; cv=fail; b=p59nDtmRdxfX+a9L6PXOSYSu5GDb5opbhXT6j5LnlGdzFngHAmMpJVIVpxMTP/yAr2zjEcnUIfh1hORkZ38Kq7VdUAfrd7xQghN9yJeXf0EsOzB5BWXADtiM2DpnBxVS/d57q7z+rA07bbwSZHPhwsqJIUHtculMQGCR4eBIVcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795039; c=relaxed/simple;
	bh=riXgsi11JS5I22GY7qQgH+gxWm160ORKOB0zav8juxM=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=ApNYX/+WcLZbU599SgtU6tvj9dC72w8JtraZhJ5ZguOsyunsedqb3OlXhvHfKUyGlwqCQlktS4eLN1SdB9b8JX3Q+E2ffpzJAZ7SMcHHctdlG00HLYrd8y7M0iwAAmzQnBDe4wJX5X1VMOAjcC6BMy0TOm1q2i8HbJAupMdjwPc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eozuayhv; arc=fail smtp.client-ip=40.107.236.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eozuayhv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cRt8Jm+9MaAxpA0ok0/l4dc4ZvdwaTgikHZbhaIVgW6CvDBEto9HiiXM/Fu1GiQ1VrlDlOKE01FnAFcE/2b1qvuuSc4PcqzhDzcuhKbypSL+Ob6cfJywSa2fxqhg6l8yxAfGSQpIhBTQnehkwr5+EchE36SR90mfYMsH0VC3X1rtP29Z7f38yv2yy0ftDUcqAYGVM3goaYMwhun4UK61Axzz5f0n3dvTY22HR56i/AtnVEn8Eq0Q25fod8Q4/Ec0HoFpvIPwGPaPEjuwfE8L9/ri8HEYiTRzZqpVZca7apoATv2gt+PZF3Nxxvfm1yEhdHFehLurJYOo0ofLLlCX1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D6Lqo63LHBR7M4K0PllN1TExDp8ShcHIJ+9BzEGKgnE=;
 b=fsNlu14iT5WaIHt+4mPj2gGAz08pORi8AMoCsIlVf47+UfjItNmOfvHfeyf8XnqK0e+YoEVXWNWwl62OoUlzt4nJVrePa6TKrB00jV++NiuXSGmgOsWDKQcILdcSMwFckq7wZN6cUwGqXx2zF+Fi1/Bf8zywJoy2CkRk0yfXEhcSLGSuLLsR7e0mx9Y4x+zfcAdvwfVMNtW59TBXwxa1cuC5U+OB2nyVhIRx1kEfo05+S2wdiHXjuxYDfazfcYgHAGCHtAChIokhSFTF7Uj1VdFA679u1IwFnAiJhAEnytg9L/lxFHG76qk6x+ZVDkL4oirNiWKZZHl1lKevkKuRXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D6Lqo63LHBR7M4K0PllN1TExDp8ShcHIJ+9BzEGKgnE=;
 b=eozuayhvx+1w2AFDsSGFjP3TdVCXXJSbkKFZa8h1nPlIvjw/w3s7RoY7BFWiRCH7BQSrTSb67uJujHaf06nqM5DT54FqOYvlLriMbIQGeIrOxrkvBsoT5YO5hmwBnPAfUlue+uvy4L0fh+jK+xung4sMhH7LcWeV2OuBFaKj/TRT0Srt0wJwSXcGmSrnLPO+Zz9VVMOEKqtHwfOaTTvMKp8/dsWmQwIWJ6DdTYol7fIBb0FvmI3tWUXf8rRE+i9JOIXnsS41f84wrDY0/6K5pbK+/ZN7T8kn8XE/nq2CbkLk/Rpj6nieDOOE5X/lBDs2WCEsi9IjLOyKvZjVR/3eyA==
Received: from PH7P223CA0011.NAMP223.PROD.OUTLOOK.COM (2603:10b6:510:338::17)
 by PH0PR12MB8031.namprd12.prod.outlook.com (2603:10b6:510:28e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Fri, 4 Apr
 2025 19:30:30 +0000
Received: from SA2PEPF000015CA.namprd03.prod.outlook.com
 (2603:10b6:510:338:cafe::2c) by PH7P223CA0011.outlook.office365.com
 (2603:10b6:510:338::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8606.27 via Frontend Transport; Fri,
 4 Apr 2025 19:30:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF000015CA.mail.protection.outlook.com (10.167.241.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.22 via Frontend Transport; Fri, 4 Apr 2025 19:30:30 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 4 Apr 2025
 12:30:11 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 4 Apr
 2025 12:30:11 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 4 Apr 2025 12:30:11 -0700
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
Subject: Re: [PATCH 6.12 00/22] 6.12.22-rc1 review
In-Reply-To: <20250403151622.055059925@linuxfoundation.org>
References: <20250403151622.055059925@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e4f81e3b-acb1-4a20-8331-f86734763f8e@rnnvmail203.nvidia.com>
Date: Fri, 4 Apr 2025 12:30:11 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CA:EE_|PH0PR12MB8031:EE_
X-MS-Office365-Filtering-Correlation-Id: c7df58db-0d0d-42af-c894-08dd73af292b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WTVCbjNMenRxcG0yK2dlUnIxdnhMSVRQL0J1aC94Um16YVFDT0dUaXRRZTB3?=
 =?utf-8?B?UlViU0xydVhFa0JnRm5Bc0FyNktCQ3VpUDVJNnNMMHBXUzBaei80MUx6NjRL?=
 =?utf-8?B?TDRZeERUT2VDM0RjQVVrWVlaTVNEOStyRW1zTDFoSUVvbHdMMEtCVDRHS3F3?=
 =?utf-8?B?eWdKZFppT0FwVzE0K0VvMUtqVWZPb0ptWklNaU5LWTlPeEhTK2dPTVdFWWZC?=
 =?utf-8?B?aHpYWnJydDRIMldJNUg1dlcwVldCRzQ3M3NmNDVObzdIdzdTcTVmV3JXUE91?=
 =?utf-8?B?TkpJbnpKVVZkZzk4T052MzZNMFU3Q1J3cHV5WVZoOFNQenk3V2FCTDI5UXFO?=
 =?utf-8?B?em1tQ2dIWCt3UnAzTmxjL2dFZkFybFlZTDMxbTRzL3kyU1pMTk1aU09WY05S?=
 =?utf-8?B?Zjh2RHR6VElBa1pZUkNHZXMyczlIWWNTOER2Tjh6R0pRZVgzM1ZORUVabFBV?=
 =?utf-8?B?bkQ4Y0VOSGdOTlE3S1p5WktBM0ZnRU4zSTkvWE9BdGY0VndrandPN0p5VUlJ?=
 =?utf-8?B?MjZjNmZVcG5ydWNKSGZhS3UyUk9hck1vYTBDZzFLNXpvaG1SdFJwVnpOdkhs?=
 =?utf-8?B?djFIWCtsNkZjZWt2ZGE2VGlJT2dJYkZmeGtRMVNKYVlLRmtvNjltVHVvaVJY?=
 =?utf-8?B?UUNBMmoxVm9sa3h0c2Mya05MUnA0WjBWWFQxWlI4RUlrd05LbHZ2SDFHdGlI?=
 =?utf-8?B?TGR0SnNzOFMxMk4wZzV4UHk0L3dYQWNwMTU2TWZyb0NiSzlPN1Z6NThOUmcy?=
 =?utf-8?B?UGxDZ25JRENISE9iQTRyenQyYy9aRnQrWStoS0NQaXg4YzBoSG9UVWZjRHdh?=
 =?utf-8?B?L1ZSUXc5Nys3blpOcmhxVGFCeWVxMXlUdy9ldjRvbkNFcnUrb3hrc3JjRnly?=
 =?utf-8?B?bjAraHExbEh0MFozbkJ2b0NNNUU0MXF3a25kcWRQNHd0Rmc1Yy9nKytxRTA0?=
 =?utf-8?B?dC9vQ2VWbU1nRGhVbHN6VElmV0h5SzJhbVVYVXRZUUNiZjRTcHkyUWtrbWtB?=
 =?utf-8?B?VWVIcFM5Tnd6YXVBazJ3UUpGYVA3WG4rSml1bUw2S3FjWjVPTVRVbGVCQ1BO?=
 =?utf-8?B?ZUxOL2xaRUppeUdSTmhLUUNWK2UyZndheHRHUmxncFZkY1VqSHU1c1JSR1VR?=
 =?utf-8?B?Mm1oaTc1SzBoNEJUOWkyN09nUVJaL1JtWkV3VVRoUDFLemMvRC9uTmZ6eUpX?=
 =?utf-8?B?U04wcjN4VDR3S1Z1NnpDZHV3OWlTb0d2Q0FwNkFocjNubEVZOHRNNjU0ZkZX?=
 =?utf-8?B?RG44UllRTnhDcDBTRlowa2FnZGk0QmRQYmpWY1FmV1h2RXRxY3ltVGhmS3RW?=
 =?utf-8?B?b09jeTlIN01xdDFNZFNVdno1cnluMVJDOUdSN0ZjMGVzbXpzVXJoeFVzaU10?=
 =?utf-8?B?SWtwMEJ3ZU10VzFyTXZmdE1NRlB5Mnl0NVFHSlRQK3NxdllhTWtJMzR5Smpu?=
 =?utf-8?B?WFBwTnpyck9HTGJwSUY4VlFFSGJyV290NUtsTjYrby9nNGMrZVRod3JoR0ZF?=
 =?utf-8?B?UlpybXRIZloyZlQ0UzltblBXUTVlYlNhT3lRd0ZMbW9QcFpFbFRoM1lPYWwr?=
 =?utf-8?B?cFNjQWNtSnoyVHc4WXhreGtQWitTUmdESFM3VFNoNVBmMGJncmh5b0djSjlQ?=
 =?utf-8?B?T1JFQzBwWTFydU94cHJKUndUOGwxS2t1d2hSMXkzYno5eis4ejh0RnJzUGNW?=
 =?utf-8?B?N3FyaWZBeWtCUlJmZ2lDaS9EelUwYkl4Vzl1YitQcHhHOEFKcnIwQ3BCV2dY?=
 =?utf-8?B?QmhBTk1CY21Ybm45aUk2UG1EZzBqM1ZiRG9XUFlyZ0ZtS0p1L0s4Ull2TmVk?=
 =?utf-8?B?T3hYSENLMm9WeEhHZGU5VE5abXljekZMWERDSlp0WWZQdTRPSnNxR0Iydjcr?=
 =?utf-8?B?Z1pyc3drSDVDU1cyRkJvdVU5c3lsTEVXTGpZVjU3SW5jRmUvYzlPNUpTRXRD?=
 =?utf-8?B?cVJ2ZDA4RzNzUWN4ak5VU2FDdDNDNUpzaFlpREtTZjY1b2FOY2hveWl1MGZt?=
 =?utf-8?Q?UbFAZ4A4JoJPRakrZi8+4LYDtl54sk=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2025 19:30:30.2122
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7df58db-0d0d-42af-c894-08dd73af292b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CA.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8031

On Thu, 03 Apr 2025 16:20:10 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.22 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.22-rc1.gz
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

Linux version:	6.12.22-rc1-g03f13769310a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

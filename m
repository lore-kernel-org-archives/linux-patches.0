Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2089.outbound.protection.outlook.com [40.107.236.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9951F75A6
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 07:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750835826; cv=fail; b=jlgDfu7H5P0offgHUwdyxlfV9xzF7q0s/DRneHiYnq5EJpymwyuym3qM9itLhADGl0YVOkRScMltj8STnHQxLBGNVMBZcpdcDRfaLmSNWOFhi9YYPvnwRu2DepJPxhQ8HIAyD7SwBUhp3wxs6MlPWNfrWgykM8lRRtGlKTIkuyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750835826; c=relaxed/simple;
	bh=6aMICP93uYHA8I0PUWz0RI693keLJMzI5nKFDESiUHE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=J59K15Ch9mKRsa+oPAEYDH21X1yYXB8uxP4kWbYTGtYRowpJw8e1tSd7v6Tr5CzlIaGz7K0v3apkTwdQzUmhnA2mAlSs2v6o9qlic08+JUWdMgAzUNgZVXZ6dR5XtQCKZeWtKIo9zPYUBfl4bp1QAZoOHjSyChpxIZ0vw8EyXF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BUgvAhkr; arc=fail smtp.client-ip=40.107.236.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BUgvAhkr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=icoFiR80Aac41c/yPDz9ixQL79pgJ+v3/ifsCXREW9/G3OG2BqXwxdXvrnNhb2aQ01m87ePbE8UxVlerYTPDimHpx4qPWC+TvxxFz1XkEnZqjeXJ0C/wquMgtAnRMOPD4amC7qol7YjEvGvUIISxaqZDIfqgxhaF/8R5RUec+IzISMlbBzrSND4pD9W+B8P1An78QeakTvCpBTQc0yQvtGlAg4iVtW54mfAXxZUm1gSzLtO56Tr6CKwBD21kA1hjpcOfwYY54BSfoNFo7BPfFxQdsjxuIquWC2GRTjIszj5s5/H2JsF4DDGkKvA9kYIcYVZw/o5fPSr34qkGxHlvkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dxbdBPC18Wbbbq+mCFOefM8WeBnCL2o17f2UBok1aSY=;
 b=h/Vge9gj1DEpn5z/nP5EVy3VygJy5jK1hhLM/97erW3Wx7WkMpHzOjC8AD72FlJUY7fFfXsb/e3j+5aXLUETqTG9taD/a96eZqlWMZfIRNIm8rW0J6HqHCRnUr6+QBszwdKgdwbwuIMfZ1ymf7/VLg+UXTVZKc8F24rg9aBSuBfEDA5lywFhnt3Urwm4A2hDepaI4FwZq7QZItt7i8yqf5czy+1eFK6KLdAGfaH4rNTnlKUSQrA9b8v5Q5gYi4lODvx3XfM04Cszcm/obeUPqzuwBt596J3QZs5fN2PrY4nfPg/YI8FYjbjkLCNJa9BwTYO2lFRdHGGWIeSBOzIKPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxbdBPC18Wbbbq+mCFOefM8WeBnCL2o17f2UBok1aSY=;
 b=BUgvAhkrG2wfeSzLMCZECartnJspsGpXhsgtAWBwFFJF2LiqlX4GGScmB/yYRd0au0Aw6nnEBmgWJ+Cosu6fq2dCSCQSCNZTD6hJtd2zt8+6ZuPCZgIaTsY2gTZwTEsQW8uI11R5YAQJ3eADQ//mJ7IZEnaiFUxwDORzkTjrQ5lRTzfvf7PmcsIAqmzalQna/FExsxCkRq3PQM50nkgB9aC8nfyPZ69UGerPiV6q8/fMbo2AsZTCwGWv0WFNsAm1gOCmBH4h7oIFiFIgyiV/f46i5Wm7x0yi0NA97CSIDCC1v/jF6FPOdX7eF/PZF4Pug95NpGTAKZj5fB/Qw0DlEQ==
Received: from CH2PR02CA0030.namprd02.prod.outlook.com (2603:10b6:610:4e::40)
 by IA1PR12MB6187.namprd12.prod.outlook.com (2603:10b6:208:3e5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 25 Jun
 2025 07:17:01 +0000
Received: from CH3PEPF0000000C.namprd04.prod.outlook.com
 (2603:10b6:610:4e:cafe::f9) by CH2PR02CA0030.outlook.office365.com
 (2603:10b6:610:4e::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8857.30 via Frontend Transport; Wed,
 25 Jun 2025 07:17:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF0000000C.mail.protection.outlook.com (10.167.244.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8880.14 via Frontend Transport; Wed, 25 Jun 2025 07:17:00 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 25 Jun
 2025 00:16:49 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 25 Jun
 2025 00:16:49 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 25 Jun 2025 00:16:48 -0700
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
Subject: Re: [PATCH 5.4 000/222] 5.4.295-rc1 review
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <cf271495-270e-4a0a-a93e-fe8c44e4eabd@rnnvmail204.nvidia.com>
Date: Wed, 25 Jun 2025 00:16:48 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000C:EE_|IA1PR12MB6187:EE_
X-MS-Office365-Filtering-Correlation-Id: b5b1c2a7-3c2b-4dfc-de19-08ddb3b84777
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MUJ4V0l3cW9jR29CTzc1bW5lZzludUtnVEgwS2xUUDd0MVByb29DTUFsYkFF?=
 =?utf-8?B?Yzk0TzJ1eXo0a0l2OUxHR0hSd3RMWDZQMGdYZ1k0Sml2WHJIUG44YU1ycURS?=
 =?utf-8?B?Q29yK2VJaExCZUEwMjhsZjg2VkUxaEdDbmNPcFUzaHZQS1psbVc2cGxGdzhZ?=
 =?utf-8?B?WGxWRHJzaXM3QkRqV3JJRFVndUNUeVJRWUVlVUhadTVVc0tTTVlFalAvRHFl?=
 =?utf-8?B?cjlMQ2JTWWoybkZaRUxSZGJNS1B0elNFTnlZaEZZT29IcUpTdjhxTDlxYkIz?=
 =?utf-8?B?MFFvUHJPd1k2R0NmWVFHNWRPU3B6ck9jSC8yNG9FWkNRZXRja0lCdlc3VElX?=
 =?utf-8?B?TUNYOEU2b2U1aG4yWitSdHo5YW52TWtzcDEwdUJkOHhiMmhqa0hnc2tDZ3Uw?=
 =?utf-8?B?Y0VLOGlFc0hBZDR2TTl5aTZteGw3VFpDcTF0MDlNY1Ura1ErNm1USXhDSWxQ?=
 =?utf-8?B?eDZKcmFsU1lmUnMwTUhkOXJwbll5c3lMVHlHWlEyU0J4Rm9Qd3RrRDc0YVFG?=
 =?utf-8?B?TjZXankrdWtPZjM1c1NzY2YvSXNSU0NwTUJaYVR5dWRzRzlMRitFUW4xUmtG?=
 =?utf-8?B?WklFcUs1d2llTm9pZVlpR2hZN0Q0Q2x1WVBWMTFCTkhiZDl2UFFSMXo1ZVFT?=
 =?utf-8?B?eXhTRXNqUzhJVGNmWDFzbFJvblI3NWZJR3RnSWlDelJ0QkpDZ2FmMDlUL1BO?=
 =?utf-8?B?VGo1Zk5icFhjM1l0QkZrc00zbWthY29QeXFxSjF0Qk5ET0FRVkF4N3MyOFc0?=
 =?utf-8?B?b3VaS2FBZmMyanhOVHNmcytuVXFBNE9BOHljUkk4TmRMa3Avd3JQTVd4S3lk?=
 =?utf-8?B?L1lEc09Pcnk4Z3VHT1JOWGtmQXUyM255U3lLaTNtUDFoM1IxdkQ3eGorU0d6?=
 =?utf-8?B?Y213ZHJ6NW5ndzB4SmdFMEVmb3ZRRjlpZERkOTRNNnhSVUljdzA4cE9MbjZX?=
 =?utf-8?B?V0ZMcjRITm1lNkExengxTnM2NG1NOC9QMStoVzFpb0NIekZxeUx2akhaOHVj?=
 =?utf-8?B?b1lFMjZESlA3MDA2RUZIRjlJNHh4bE94eFJ3MWJSUXFPVHFqdm1JalpVbzJK?=
 =?utf-8?B?VERFNmFJM1FWOWpNUmg0VlZPRE5LczBLSVJEYjdRV1hzN3c4ZlNsbU85cHVG?=
 =?utf-8?B?RTVmdVdqVUpqMDh5UHNZN3lLZWpWVU91K1VkOFgwWWFNaUxnNUxwdUpQRXZW?=
 =?utf-8?B?ZmZxL2NlRHhCRUJhdmdpLzVMdEpaczVPcWNCQWVqS1ZTU3lzRm5hakMwZm50?=
 =?utf-8?B?cFptTDd4ZkdSTnRmblNvYTNVOE45a1VCYkdZTUxFUDF2a1FtUkgzeXA2clVC?=
 =?utf-8?B?cGlaYXlzWVJzOGNtVlZXaHQ5M1BiNXRBN01PTFJmN1BBL3I3OVp2dlA5N25V?=
 =?utf-8?B?cG5BbVJrdWNKeXhuUmZsR2kzTHpNSDhzOUt6S1JhL3pXWWZpQXk1ZVlJYUd2?=
 =?utf-8?B?TUdoQjFDdG4vTS9kYjhkenY2U3p6ZzFPWFd3S2tocjU0UkVGcy9yN25YSUpx?=
 =?utf-8?B?NHVJOTNSOGxZV1FOSXduZ0RhcjR6Z0JJdlZCcWd6Tk04R0g3bHN6QVZkRlBw?=
 =?utf-8?B?RG9mNGxhMmo1YzIrdEdyZE1jVlZtUzUyM3dkblF6YVZWK1JWajc4bDh0eDVT?=
 =?utf-8?B?MngrUWROaThhc2NaT0MxbE43cEFIdU9RSDdCeGVjazdvZVB0d3BtMzlpMTJx?=
 =?utf-8?B?MU42Qm4xREtIUnU0b0tEdkdMTzc1UzZnVm5nbmpGaXMvME9wYXhOTjlQNHN0?=
 =?utf-8?B?WWI1SFdYVGNiNk5UczBRZ3V0Wk10VFdIUEo1Ym9oZlQ4dXB2VUZNcVM2WkVt?=
 =?utf-8?B?WHRMbzIxY1o5OE11V1QwdU8wTmRZanZ1K1FvbWEvZEgwN0VJcm9leFFnTUxx?=
 =?utf-8?B?ZFZXM3BQN2NkaTNaTWg4cUlvRDVIaCtvazNDMWY0aVpXbHlPby9JMXl5V1N3?=
 =?utf-8?B?OUx3LzFMVnhtdzB3QUFBUnZuNUNuaHlZdjRsVzR5NUNSUWFobkI2ckIvY2g0?=
 =?utf-8?B?N25wU2Zkb204VlNsRDVzbEIyZno3OGJuMG9EbUxxMk1UYjVmcU95T0RXL2Nz?=
 =?utf-8?B?bStxbHl1MUwzK3dBTWVKcTdaLzdCZitFN09wdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 07:17:00.9198
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b1c2a7-3c2b-4dfc-de19-08ddb3b84777
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6187

On Mon, 23 Jun 2025 15:05:35 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.295 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jun 2025 13:05:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.295-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v5.4:
    10 builds:	7 pass, 3 fail
    18 boots:	18 pass, 0 fail
    39 tests:	39 pass, 0 fail

Linux version:	5.4.295-rc1-gca8c5417d1e6
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Builds failed:	arm+multi_v7

Jon

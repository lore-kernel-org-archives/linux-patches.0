Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2050.outbound.protection.outlook.com [40.107.100.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AF81C7B98
	for <patches@lists.linux.dev>; Tue, 22 Oct 2024 17:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729619823; cv=fail; b=gk8kOvqdqNd6jF+FX8j2nwJH4/Ps0gODMsoW4k515utD3QqWrAeRfrnYTt+sU0ZO5MvK+qie9SDbs5+bqUn3QV3VGDnvqX9hPfvc4FcSIjC8g3PIlS3q3Kb6YVXS2EBZE7v4ZznY2wGZPnKp7TumoLdq2LK+GYh+79lQX0nI+us=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729619823; c=relaxed/simple;
	bh=gqxJf2gUZQfwdeT5oqMseqXMqd7JnjaEIdP3zl/dZJE=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=HfgWj0QvgZ5KHlt0Gcz0PiQCL7p3e68k+VRUlb0jrijE/aoR5RSmJk8Ul7WKuZAEOVrQdbIqHmeUY789Q4cgp7tPwdrObTbI2B9OIks8TGGxUwbuVixwj/mdyXBvoy1mTr35hPrOQHYhG7JSgPpH0fAcaR5beqxNs5HHmJb0CSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p57/WVj1; arc=fail smtp.client-ip=40.107.100.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p57/WVj1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fadj3cdRl5s+oglvwVklIPrMoiK+CsGi0amMzQwWoPvJbuoCZLcZcLk/dOG6+VKngSXphdRZlOHwRY3RLIoQXgUhanuDAbkk3KLNMTQMvN5FIAkin9DP5uub4L/uYsbnWOry9f4EcdMNB4KAu8veeYwUyjBgK/QH1wJx/eG+0mvgp0ervZMJcFcvQxSZT9zG0g7xc7EGvdYJHEp5WoH3UVCsfQqAEmaXyVN0/6uMkTprSgwzJlFANBIMtXwd/skGehxDh8HnRMbzHpvJ/cnYaR3pRuQmlvlJrhN0banhJA+IFlAb+aKUJJTPzQlQzViTTJRTkt2gdHnvVPYfumMpuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q1NJghqWP8oXtmM4JG8buctjPXZAUrozURIglHQoaj0=;
 b=TTLoUMYvnzlqAc4irzUkKWqALxUyuue5Qi2BM5bIYw9Wj8Ooi22j5W5tmlfuoNsQNK7O2M9J4WxjMjoo2xktz39U/FnX6Lw95n76+lf+eVrQ0pxkokPcgaubS/vEOEOkoqiI/IpZBLcZJFx/He3zjrks5EHe6U2GxEpeaRnF/JzE4gXj/YXyx8dl7P3utBhqAxLDD4zXW+ju03W8wiSZfuesSam2XzLDOGAl9CbfojUPsATZ80Tv623roul46AyqmFpERXbTD+qvSOGDJLLQPGYvo6lgckQcEssjOi0tXI90YroOEB5CXHavUwm8k9Jp88ueK7gwJ+a5cKoXzA03ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q1NJghqWP8oXtmM4JG8buctjPXZAUrozURIglHQoaj0=;
 b=p57/WVj1J0w+TsmXQvsixucUSMSdRfOBU+eOoWu6XQdsoIFSOeJSlln7K1gef2q7P5kywo6sYQzR3oXAajO++2DvCCO/1+OMdj4q4x83g7L8t3pH6LJJj5UREFeCv2JcSFr2o7tcy196tlGP0ADfPnP9XqxNj64ZUeKa6Ex3DHpw3SVVh9mpNhHosNL3StfKj1FqMnajpUqQrBkhSAy+VnDoSQpAQDnd8uoryJjCEi0t7JIxv52tFT/i10JNVrBQ7PnbqteYtjAWfD+DqblTVu0rU0s9Ubw4oBDxpr2VjXVLpOkP4G/R3cDEYHkrNi+18B5C3MAJ2nD9dWgau5gOwA==
Received: from CH2PR18CA0043.namprd18.prod.outlook.com (2603:10b6:610:55::23)
 by DS7PR12MB6095.namprd12.prod.outlook.com (2603:10b6:8:9c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.17; Tue, 22 Oct
 2024 17:56:58 +0000
Received: from CH1PEPF0000AD7F.namprd04.prod.outlook.com
 (2603:10b6:610:55:cafe::20) by CH2PR18CA0043.outlook.office365.com
 (2603:10b6:610:55::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29 via Frontend
 Transport; Tue, 22 Oct 2024 17:56:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH1PEPF0000AD7F.mail.protection.outlook.com (10.167.244.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8093.14 via Frontend Transport; Tue, 22 Oct 2024 17:56:58 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 22 Oct
 2024 10:56:40 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 22 Oct
 2024 10:56:39 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 22 Oct 2024 10:56:39 -0700
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
Subject: Re: [PATCH 6.1 00/91] 6.1.114-rc1 review
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <23d85d2c-553d-40fd-a1f5-3356e12160c1@rnnvmail205.nvidia.com>
Date: Tue, 22 Oct 2024 10:56:39 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7F:EE_|DS7PR12MB6095:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c9cac3f-fda6-4203-3a7d-08dcf2c2ec55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NktWejBsODRHTDJZQ09PNW5XQkFGcE02Uml1T2hYcmNlVXlIRitVQWwvMkIx?=
 =?utf-8?B?KzdpeDhUM0I3bEtEdTA5MmJSSy8wa0RwSU5KT3ZWOGhkRzVoNWt1NzUxdXps?=
 =?utf-8?B?dXgzazQ2dGhqOHFveWZzZHJkOUgyZFF3L2hYUHdCbHhNb1c4ZTJ6THlaUzNE?=
 =?utf-8?B?U1J3T2FEanFBSW5KbGJKT29STzdhWTJ1U2dlbGc3R3J2M25iaGxoSTdLQTV1?=
 =?utf-8?B?ajgrditjVzV0MVZGR0FSazFLQW5HdkZnSGxESjdycC8yTC9BSHFzc1g2UkYv?=
 =?utf-8?B?YjVlMlU2bFhweEpENmRDeFUrOHVubGwva1lRd3ZmdmloMDRCUWdmTmxqTzgw?=
 =?utf-8?B?eC9XZlhwRFhobDMxcS9RT2ZlZm9Qa1Vwb2FsQ1dyNzJjWi9oeW1tbUV6Q0sv?=
 =?utf-8?B?ZmxkZDY1aE9JSlg2MFlaa2YvQm92UW8yNU41RWR1dXVTUFRzMTUveTJsRVdD?=
 =?utf-8?B?SWpyTTRJMlIwL0I5WCtDNXNhaUt0WjVuUWpPUTd5TDV6aDRLTWRTUjVuQWZM?=
 =?utf-8?B?cHF5b0xkR21UMXd5c2l5dkdoZjRaczA0Sms2NG1PR2RIR0dxb05zVllxQm1Y?=
 =?utf-8?B?ay9CZkZpdlBjbU1hbFBXNXB1Y0NaQ3AzNlUrOGFRNSswOFdrUzAwbUhsVHhj?=
 =?utf-8?B?UFVCdW1LUnF2d2llZTFxRmRaUVZ1cHFVWnYrN3ZtZm5NdFhoZlpIUkFJWVBV?=
 =?utf-8?B?bXByWWYweU5TUCtxWTI1MitjeWQ0eWhrREdIeVhCSS9Ic1VVc3c5VmFqRUxv?=
 =?utf-8?B?TlAyS3dnTzdNUWZ3Z0lTNHJzM3B5b3gzbjlDMG1MMUJQaEZJNjFFc3B6Tm1J?=
 =?utf-8?B?TkNZMjlxWlFJanR4bGorTVhNL0p6NEh5R2l5U2M0amZnQThacU91VnprYmtV?=
 =?utf-8?B?OFNmMlA4TWFMbE4wd0wrWjhMblJ5b3ZzNEpPNGxlL2didHFEbWNZRXJ6RkpJ?=
 =?utf-8?B?cE0wWjNCYnZ6TEZmcHo2am1BMHJvWGpKSmswa2diU29PaC9ibXp3dE9weXBK?=
 =?utf-8?B?Mndlc2dKTlhNeDdndE9MaXgrUmorUnkrSlZSc3huYnkzS0NORjVGUk9KcXlW?=
 =?utf-8?B?a1IrQnlIbnZoTmNZVm9KNGlwSERRV0NrN20xaU1WTXhHWnRrTElUcUc3V3pW?=
 =?utf-8?B?d2Z3b2NRVnlLUThhN04yUS9ZQVB5Q2c4TVkyOHgvVU0yK2VLZzduRHFYbFRN?=
 =?utf-8?B?YktBa1MxQ040OFVZeVJiOXFiQThOd0Q2SkY2Nzk1d0RHMXowSEZNME4rZm1U?=
 =?utf-8?B?YWdtY2RsQW9qdDhUZ2pyMmpQT25DL3JTczZQSDA3TFhKQkZsalRVejdVbGEz?=
 =?utf-8?B?QjMxNk53Q0NmYWl3V0ZBd0RVSkw5Tmw0VVd6VWF6Y0t0UWs3clFtVGpQVWJR?=
 =?utf-8?B?eTVSc2Y1WjdEcithZEgwN3Q5MW9salVPbXRlN1BmaGkrQk1COTdiZmQxUlFO?=
 =?utf-8?B?dkZPSTlTajRkY2RFRUo0SFBGNTdDQVZWdUVFclgwdjdPQWc2cWtaY3JoaG90?=
 =?utf-8?B?dzBock1ES0VGdU44ejJhbm9KV1JqbEpKcXBHdFFoTTloVmtXRG9iOXVKRGhk?=
 =?utf-8?B?eS9lM3RGN0lvZit6eDVIMUpUYlJtRHZ4WE9JT1BUeC9Yd21sYTdXTDEzZERT?=
 =?utf-8?B?azJBM3k3blJ1Zk03Z3IrWVdVTVh0NG5RV0ZJT0F6c3ZmbEFWRys2QXhWd1Fz?=
 =?utf-8?B?REhlZGpRSWFxNGFyOGxmY1kvRjJzRXI5RlV3dGc3bGRlMk11dWhLcG9BM3FE?=
 =?utf-8?B?KzhBbmFRRHdFTWlhL2ZvTU5OdnJSZjZocjZyV2RKbEJXSUhIMkxBanNCK3J4?=
 =?utf-8?B?RHRvejA5VFN2OVRDMVlZK3BGWGlTWkQxQ0FOWGJHejNWTlV0bUQ3U3NJVjJl?=
 =?utf-8?B?SUtzUVd6dUUwNS91Uyt6b0x2anlGcXJqZ1RqK3owOHZieFE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 17:56:58.0634
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c9cac3f-fda6-4203-3a7d-08dcf2c2ec55
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6095

On Mon, 21 Oct 2024 12:24:14 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.114 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.114-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.1:
    10 builds:	10 pass, 0 fail
    27 boots:	26 pass, 1 fail
    110 tests:	110 pass, 0 fail

Linux version:	6.1.114-rc1-g6a7f9259c323
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Boot failures:	tegra30-cardhu-a04

Jon

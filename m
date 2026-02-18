Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010041.outbound.protection.outlook.com [52.101.56.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B36331A061
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 08:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771403013; cv=fail; b=BlN13DGY8+h40W2aUwQOfDprDpONKi7cbjLbnoWx0WXETpZNRGeduGy+rmnjtBwHYbjvNS8WMaFIf089WOeWrRyi5B0qg7TMT7+BEklYCJ/i1UPiEd6NgXZ6oVY7RbVdIvomut4hTmW3yFYKII5KRMll57R4WBFqNob4SvoyU7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771403013; c=relaxed/simple;
	bh=plnsOz3bBTrtrCN4fYhwzCKkwnv4P8ssPfYaNj3wMMs=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=GN88jeNtvD8uN+PfSV1Ri4ZCn7kbpmlB7GSZBUHJidOBvsv5kKCjJpuFJ5gX7bns/4qHodamNeco6pxtTXKbzl8/n6Pr6RhXugNYTBmW6KIkiZfQ3sXV4y7OAAyazKEkjNYx5AoNkVk+iugWWbPLkrS9tWPRmqVEcLHLh8GmRxk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fQ186h9k; arc=fail smtp.client-ip=52.101.56.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fQ186h9k"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cg+ovYjGMovwj3w/69yGMi78fqTho/EKva1+K9XYva8dZjqQkHOjc2PRwIcNZxRgHu435Bv2Q0PF/UWU5G01Nucgb74mI9Fo1LnzEK1du4sSd1IgjIXLZzLBOXv9mM2Hir7yUoYfTcgFbObK30Hwj5KJChB2Q8Olly0ErHG2Iau1Z1D1pLw/cRD/yQuHpxkg8GLj2eGUvWZR/seurAZKAzCo0auALIZKkwNs8m5xrTBZRFDxTxlnkGlXVfL1q00y93zqjllriO9sVubzJLSnechf3qaVSUK4fnKpe7I9Yo8auHO0O5QTG5bf/rCdoIzPXI7gg5smHavjIBZdzSFiNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gCCBpabmqVmgwOtbr1EctVJ4zdyzXGAF1zJ0Iv2K6VA=;
 b=tljvnillMonjOQT36FJ24ypMZlr3Bzw6Pd75sfKgexKgGUushVzl2J0fbKk1kcGgRx+t0nJbby9nywtPApcd5B25iSW6kXv8cNPJDkLP0Wyp1CYsu8tS9vpv8UbXd50wtc4VUPWsSkkgtD9EHlud5vv7NxnmweteeiKUVmvfAk2LWgxlhIj6n28jdAQAdGwTtSz+7aUHSsKdY/2MWyKLRmSnzUl6Pnl4SLawJxOPzACmQkbZ72qwUH5sTk2bFYJjY67x56S5MdBcSWtw8W/ckRFl63ekFu2ppv6YlVOBIaV664CyAfJW5jla5JulvdIf8GRYxgAXiIgBTrhfRnPZDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCCBpabmqVmgwOtbr1EctVJ4zdyzXGAF1zJ0Iv2K6VA=;
 b=fQ186h9k3UsC3W6YVeIDBzYl/8/BaDkveUYGf7v6IKqHmNOH6ciAZf/4jvyKZQC+Gcaz9tAVaqjbydoM/cpBp4x4zJ19Hq+hoioCG8uX1+6NtUi7XUgljOaw65qxenkDiZem8WlNanXHC5Exvmq1ISdAvAS9/qQCJmYIdyeitI7oMvn9dRcQ5eujZeLtNvg0Ac/YO6e2UKorbgoSywmnLYMjencK73RqfI9FWk7C+AEhIoiNLR5dWWeIOznaREEfDkQ5BHghxFeoBfbKJ4jMcR98aqG69YSGnhVaG9BRA3yyX3QRqstG3cUfpXRCfoOZoGcBCOfxR5Xa5TheZH2TTQ==
Received: from BYAPR02CA0012.namprd02.prod.outlook.com (2603:10b6:a02:ee::25)
 by DS7PR12MB8289.namprd12.prod.outlook.com (2603:10b6:8:d8::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.13; Wed, 18 Feb 2026 08:23:25 +0000
Received: from CO1PEPF000044F4.namprd05.prod.outlook.com
 (2603:10b6:a02:ee:cafe::2e) by BYAPR02CA0012.outlook.office365.com
 (2603:10b6:a02:ee::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.14 via Frontend Transport; Wed,
 18 Feb 2026 08:23:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044F4.mail.protection.outlook.com (10.167.241.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 18 Feb 2026 08:23:22 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 18 Feb
 2026 00:23:09 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 18 Feb
 2026 00:23:08 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 18 Feb 2026 00:23:08 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@nabladev.com>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <sr@sladewatkins.com>, <linux-tegra@vger.kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 6.19 00/18] 6.19.3-rc1 review
In-Reply-To: <20260217200002.683975158@linuxfoundation.org>
References: <20260217200002.683975158@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <e05ba486-e22c-4a2f-be0a-73b69840617e@rnnvmail202.nvidia.com>
Date: Wed, 18 Feb 2026 00:23:08 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F4:EE_|DS7PR12MB8289:EE_
X-MS-Office365-Filtering-Correlation-Id: a14f80ef-5188-4326-dbd4-08de6ec6fae0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NjBWNnJPeTdlS2JuQnQrYlRQRkRBdmQ1UElkMzQydzhPOUI3R3B6RFZVa2Uy?=
 =?utf-8?B?QWoyZHJ3dm15V2dNemZoTnAwRlBpVVRvcm41a3IrNkhVcDZyWHRoZnpkMXNh?=
 =?utf-8?B?b25vMjNFNnozS29FeStCOHczQWxHYVNPSDZ2YzV5MFZzU2NXdjlQY1NtMkc2?=
 =?utf-8?B?cno2ZDdNT1QrWjZvdVNvbU1MaUY3aDdRdldPaHdrSWVRRVVBb1dGcDVBb3Qz?=
 =?utf-8?B?NDVFekt2NHJUaU1IS2xoUHZCdHQ0SUZRRktpV2IwZlcxYzNwWmFlRkNuUm13?=
 =?utf-8?B?aElPS2Y4V0pZOXpHSW05SUEvNUdHWGs5RHRUKzFtbVRzU25abFJvNXRHZ08z?=
 =?utf-8?B?UFlzSkwyK3VDMCtJVDN0OXkxajRGUnh0ZStOOFRlQ0tta0M1TTdMd3lTNWt1?=
 =?utf-8?B?WWlUVktHQ3VHVUYzUkRXTnU3akxKTFFWVUhuK0tzMDlnTGJSSVdpWlB1N1ZR?=
 =?utf-8?B?M2Jodkg0RkJiL08yYUNpZDNYM21ibFJtM3BPY0lneHo3NFlZUjBoWGkyWTBV?=
 =?utf-8?B?ZisxVFJwUVRtTE5EUEJKUXlUbW5XRjBKNEdEb0g1elpzREdwVldGVHJTWlg2?=
 =?utf-8?B?RTRtOFA4bDAvK21mT1BMZmQweWVKZFR5YXdUa2xMNHFydnZxYmxmcW1DMWlW?=
 =?utf-8?B?b2FNakswenJVc0FzRFAwZFZrR0MwKzNld0pQeUplclU0N25mQ2pNRk1hb21T?=
 =?utf-8?B?S2pDQWovVkpTLzN0NEUvbEo4SFI0YmRYMmRHZEUzVlZGS2hqSDB4VW1OMW51?=
 =?utf-8?B?TVhLWG9oajJYQ0k2TnBqUk4xL0dIZmRJSEFCaHRNdFNURkhPbEQ2RXRKcXQ0?=
 =?utf-8?B?UGd4NnV1Qko1TjNGYW9jSHdDc0xVMXYyN1hBVXR2YitLdEZ3VHdiVHlZbUQy?=
 =?utf-8?B?Ky9SQVVEd2NtMzJIaUxFRTA1VlRkdVRKTmpPdzBNK2N6Y3krMW9hSS9EWlFN?=
 =?utf-8?B?d1pQK1hiK3U1UUl1dHNMOWFodmRMVDVranpBUFNRY2JxZ2t2aFpxVDVZMUVL?=
 =?utf-8?B?YmdraFE5WEFUSGFkZktKcHdyUk5mZ1JDNHhLN2lpbTBJOGYxVlk3T0h5VTBC?=
 =?utf-8?B?dUFmQUhxMEhhcDgzQUxBRFFhdzh1WnhEdStuenNuSXFTTGt5NlFJZVVRMHBw?=
 =?utf-8?B?SmhaU2djRzkvdWx6QlFacFBQYUJjaUpoeGxFQmc4dDZBSGhUY2szeUZoekd2?=
 =?utf-8?B?czlWUVhhSEVLMWxtYzFiUDVseFI5UmVSaGo4dERzQ25HZ3crTCtFajZuT0pz?=
 =?utf-8?B?NzNqWWliaEJieTlZUDFMNTdLTXBrYm8rVWZxc2FVM1JtWGordGd6V21CYlda?=
 =?utf-8?B?SXpvYURKL0lxdW15U2g2TmFUQ1l5ellpblgxN2pFWHVyc1h0Rlc5bjM0bHZi?=
 =?utf-8?B?UXhJdDA5eE51N3NYaUZVSFBiMDIvZGNwSWdmY1IwUmMvVnFyaXdjRWdZbUZt?=
 =?utf-8?B?eFBhUVlxVzhFMWNId093VENtQW8wanlaNlJobkN4MnRTZTUrYWlMLy84SGQ2?=
 =?utf-8?B?MjFFVitXRHhMZVpUTUJrakxwSEhUWUd4VGIrT0FyZ0duVXhrVThpVDgwZTJK?=
 =?utf-8?B?aXN2Vi9Ec2YvUGRBanhDNThaZno3TkhJRlJaekd4TXdneVhUL3BsYVpXMTlG?=
 =?utf-8?B?R3h6TWJGSTJTenI4QkErY3VQd1V1RVNHYWNKaDMzWldxa3BDUDVXK1BhdTh0?=
 =?utf-8?B?d2VMV3ArV1FjOVk2am1HWFg2YmxVa0RKWmp1YUVyblcwRzlWNHlqcUhmNno5?=
 =?utf-8?B?Z09kbDd5UmRSMkUyb2RtbGtwWlE2UjhTNkdGc3FCNXNSUHg4Z25VbC94LzQ5?=
 =?utf-8?B?Sll0RDNrMFc4UnlzRURiYjJQdWQ3WUlDdmNUeVR0ZC91TzlFTmdwc0t2MlY1?=
 =?utf-8?B?N0I3c3ZnVjZZWC9DdUpGNW0zNURoM2RQQTRBdmZibnZBMmkvRkw1NmxWaE9L?=
 =?utf-8?B?OXAvNGt1UVJ3MUoxdmt4NFB2NnVMaWFFZjlWS2xXT1VKTGlqak1SYmM5bkp3?=
 =?utf-8?B?Rmk3ZlR4MlluWTNiTEo4c2Y2R2UyZnFqeXVhR3hNTkdIQ3owUmNCNjZqWE1l?=
 =?utf-8?B?UnB4SmpzdE9sMit2Nmgrdm1xNDNYaWRWdWlaVEl6Q3VuZno0Y3c5RCtoQ1BK?=
 =?utf-8?B?cm1RV2RSbXRZSmQzcmEzS2JhSkVET1h0SkwrYTh0UjRMVWgrWkQ0V1pwV1B0?=
 =?utf-8?B?d01FdzVYVXNaLytDQXgrM0FObTlWRnhjdWhEVjBoWW1uYzExRTZUdXdOaUxM?=
 =?utf-8?B?SitxSkNDQWYzeGZvekxWMUNrREN3PT0=?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	L8N6BKIF0XBB1Kg4Dwjb4eO1DdpA5pcrzZBBNNzhAg/1QCJp//u4amAdXHQY7bbrxeeOOpB1/ZDjTDvfZzdRgCBpjrAyjBCC6VeEdKr4/tVLfI2AK+OFeZnFuvDIAbikK8vCmwcyPacSezG41jrE/DgozLU2a5F+vNeARme6iI2PjaKN/taVfdPxWfqi2nVaHZy+bAEeomiYEHdmHhjxaYqMRrh30g5Z/NAzER3uObpYB0UggzGuZJqGufaw1UOn/p6s7c4akDMW3UH8CdFWHRh+3HNhToPbXUxA7wnFdjz+/qU5Pz+MdFplyUBF1xyeKKznypGSTw2EVZIAbr6WRbXkU/eJyOen2qeUtFYk3mafaN3AFxcP9eZvdQgdvHsYe4sLFkwiqbaMGxw8nucaK1bCwVCQNKaE/YlNzakRLEVF5gAXYjMdXiAJ7CDUiYw3
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 08:23:22.3842
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a14f80ef-5188-4326-dbd4-08de6ec6fae0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8289

On Tue, 17 Feb 2026 21:31:56 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.3 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.19:
    9 builds:	9 pass, 0 fail
    28 boots:	28 pass, 0 fail
    133 tests:	133 pass, 0 fail

Linux version:	6.19.3-rc1-g40e4767c6df5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2077.outbound.protection.outlook.com [40.107.100.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64562101AB
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 13:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730987048; cv=fail; b=CT7D/d2GqcBVJ/B7CohSHP/sDz0kLFS4wncbjPyWBKPEYFtnqDKMqHi8vg4P/C0HDLKLAuKHFTpBt6uY5HG8E9OBQYSKCEA65eHuiUunGdFgWdvVSHpleNTI7O+vcOgJhhl6JAQsYxQShLgLq/Xf415v32p/8z48Vz7QWogzEeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730987048; c=relaxed/simple;
	bh=3Hpyqx6Ra+nie0mPUDM3Cw28x79usYgKDEKEdi0P/Cg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=VmTeZWx+LS0yT3fvL3DwYuPW1TFKsNeqLXvcW3v/Qsk1zwVHiA6Kxr8B0rKcx/XtT04g4LMMjeqgM7hGLl++P0HVcSTKDi8zp5EWAmn+pfNdAg5e1owYJ40OyWPVPf8vjRwoOG+nvH6ssN4Z6orkwmJFfFABKlkJUpFCCFxr0u0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rmvDk99G; arc=fail smtp.client-ip=40.107.100.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rmvDk99G"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hk13u8FEDsbrJmrzahtevMfIGybE8QFgehmlyvftBqhi3na+Vdg/BG0E0CAR301PJ5AuLJBJiNxFWiFw3bNqqk2ZQRtQnS/OMryj4Ja/+unpOmTVkeo6EfywZW3gW8OCEGDJ+mpmRLKK+XxMdo8YMxCepoYSf+1ww7QgCRmR0ceaqCmx/32DKXlbvxEMgJqZ+8k3f59TDxR9olcgdWmwnCKUk7zKG+CbDQnH4fYLUmVRGh7lR+2BTdN7ibTfGKeeSJubNh6Wnd1i9SIL2Taqf+weq9yvGi3REt2QAzHt1zgEmSqDFZyisDMspCxr8LEAfk/9jalGBkW1hntyVsqoQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9FDi3P9/rL6wU0tPPx2P1WUYAS4j5jHhUOaTW+84U20=;
 b=Jb/7L9RloDW81ZcBQwzBxKzNZzvjR43CSwpgewEdwFYgBY2GDvQG23S7R6JoQQ2n6VqIEeYrJilabZ1o6B4HxXP3Cy6B4kb5Wo/HXOb8zQXlFC3OQkhrHbT3M+JI1VUtRamDMcbMHn3syuKJCve5WtyUr4tDlmGJKeZdxI/aFf47+IyxOlC1NQa+TT+CvmSBjLjSnidaiV+zRqlWHJgLmd4yv8riefAoHUMDaa6reBIz80Ak8ZfSzWF/rwpbw8yAh1XPEbTwrP6RHLfhIjhZUNGdx/hWDNAF+QMDprPwkF9pZ385DXm4/Vzr5IJtjLcerUiOP37sPOPt07s1LSsPDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9FDi3P9/rL6wU0tPPx2P1WUYAS4j5jHhUOaTW+84U20=;
 b=rmvDk99GEwzeczg1lkLEMR7gLBp5n+RT9FPBKK2UM66YOZMdcpOGcEAK+Hmy4BRQ98bA36gi5W6hc6Ll65WUDqC08wldELnuLlB98LsNJ/xIITO0u1G8h/YI9qDCAzAD/HxQo+8y5vGT5zBSHUnhwrr6eScIjenJd4ix91WC+mPCOZ6PM7ZGAbHTyTYtDGIwCKHB6I0tAaYAhEOHi8xj5KpPIeMP27MIa7YZ1y8auuVDeoJkBOb2ji8wwSDb04lIil8m8lHcKHyyFuFJRPeNSwi/EaP4zox39+vUuOvUy8qiyfdMKKp9mnWD7SzO6pe007nbkigMEMFsyMqx8pLInA==
Received: from MN0P222CA0014.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:531::21)
 by DM4PR12MB7743.namprd12.prod.outlook.com (2603:10b6:8:101::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 13:43:58 +0000
Received: from BN1PEPF0000468C.namprd05.prod.outlook.com
 (2603:10b6:208:531:cafe::99) by MN0P222CA0014.outlook.office365.com
 (2603:10b6:208:531::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19 via Frontend
 Transport; Thu, 7 Nov 2024 13:43:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN1PEPF0000468C.mail.protection.outlook.com (10.167.243.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Thu, 7 Nov 2024 13:43:58 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 05:43:48 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 7 Nov 2024 05:43:48 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 7 Nov 2024 05:43:48 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hagar@microsoft.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 6.11 000/249] 6.11.7-rc2 review
In-Reply-To: <20241107064547.006019150@linuxfoundation.org>
References: <20241107064547.006019150@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <db5a1c31-bd26-46f4-ae25-12646627eb54@drhqmail203.nvidia.com>
Date: Thu, 7 Nov 2024 05:43:48 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468C:EE_|DM4PR12MB7743:EE_
X-MS-Office365-Filtering-Correlation-Id: e1e55d2b-9ff7-4ccd-936d-08dcff323b25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q3JpRlluQ1BwdmpnRFFsaE15WDAzK1EwbW1NYURQUXZTY3dIS0VBSXVBTUxB?=
 =?utf-8?B?SnhUdGV0TFVIZzB1ZDJ2RGZlN3JRWkVVRytRSEY3NXpra09TekpZdHBNT3Rp?=
 =?utf-8?B?bmRJQnFjVnlhaSthdlFSdG1Gb0kxWXRLMiszdFNwUDNYOEI5dGhBQjkzVzRn?=
 =?utf-8?B?OHdycWFHcGREUkc5aVQ3bFI3czRnNXRlVkNSeWNkWTcya0V1WlFtbzB0MW03?=
 =?utf-8?B?Z2tDVHBvZTBJMEtGSmNRNzU3Y1NWWmlSRENZMmpUdDlvQXJRTFlvZER6NCs2?=
 =?utf-8?B?ZTVYa2QxZWxJSEUzQjlXRnJJSE9lWWVhODRkTVBmWkJvT3Z4aWpMb2NzeEk3?=
 =?utf-8?B?N2JGbHJ1L1pEYUN6ZTFLRWxJSVdZZEtIYXQvMGxBRVBObmozNkFBc3JqQkND?=
 =?utf-8?B?cithZ0dPdlRFQmNaUk5VV0FyYm5hK1NrR2ZaUHZnNlNJYUVVOHcxOGZ0enlE?=
 =?utf-8?B?ZmJveTIxeU1mcDZYZ01Xb3M2b0ZMOE9XM3NkMnJkSmNoekE3cnNLTzZoU3dy?=
 =?utf-8?B?MnJXWWsvL091RCtIZmhVQUlHdmdYSldOR3ptTGErL3FvMkozOWI4ci9JVnNq?=
 =?utf-8?B?aEVLdjdyRDdFSnVKb3lMVnNmcFBCNXpncEZ5N2hsWmtsOXVpcU1uNUFXaUow?=
 =?utf-8?B?d1l4UEJ2TWQwa2hiY0JBV3hZUVYvbkFES1dqMEk5azNvMWM5eTA3eCtQZitF?=
 =?utf-8?B?TmlCcEs3KzJTK3cyMFc2citVUjJET0xpSWJMa0xadXJXQ1lMQ2ptOERJRG55?=
 =?utf-8?B?MWFiMWNYTlhnSzV6V1l6eUYrOC9pL3BnOXF4NDM1R3JRQUQxbStTNUMxRnlU?=
 =?utf-8?B?ZHpQcUJxLzFDV0RVSjJDcXFwZUFtMVpXMXFXUkk4WVdnYSs2Q2I5bzJsaTJN?=
 =?utf-8?B?cVpmSUpiRWNKcWNBMC9STWxGaUZCVXpXNXU1NHMvVzErWFVrbnI1dHpxLzdu?=
 =?utf-8?B?bzFZTzlUY0VhM0dGWG5mYTdLNWNmbW83TXUxZWdFQ3NyVzhUTGtjRTVJcW5y?=
 =?utf-8?B?UVJvMVMzQkwrWE93bkNRWjRoUGJ0Uy8reDQzM00zMmpzaUxjVlNqSGo2ZER3?=
 =?utf-8?B?Mks1bWdxQTFjTkJRQzFwUXJmaTdLTDdvakkwSHdzWWZZYzgrRGx4RjZ4TWhD?=
 =?utf-8?B?NjVLV1dHNW5oZnE5V2hFN1M5L2d5Rml1UVRmVUsyTFNOdkpscVVYT2c1V1Zh?=
 =?utf-8?B?MXFRUzNHWXdVYStwKzlwTUdpYkpzNmc3UXo1WWtBVytERDdWY3JoOUZGaFJl?=
 =?utf-8?B?eVdjbFBFb0lHSFNkdXZEYzBZRG94TjFwQmFVdmNlZjZiVlhUNUJTZjhxUnNI?=
 =?utf-8?B?cWVnQVR6dGZmT2I5V2JWdWZvZitMWGhTTU5WcVdPeXJDN3g5eTZwZ29Cdzly?=
 =?utf-8?B?aW5jTGlmK0lwMGNhT214LzNjUXdVb2J3dXFSdlBrVEJGM0J5OFZKRFprT0d2?=
 =?utf-8?B?NmlBNkl2NGdVbHJMMklkK3BycldEaUcwVU5HTzhWNGJJeDVEYTRkZTk0cVQv?=
 =?utf-8?B?eDJJTmtFME1Xa0xIamRqOHdOS25zY0NROE5RYytRZnpuL29INUZmejc1dE10?=
 =?utf-8?B?aWZ3ZTcxTmc1V3gvaWFVWm5PTld1ZWVuTm1vc3VJL2dYZStiZVlQc3N5dnVT?=
 =?utf-8?B?bWtvWVg2Z3NOTkNIWFJJOU9KaHp1MG94bUlLZTdQeDdzT3ZOZ0Q3NFZjNVdU?=
 =?utf-8?B?SVNVYmJpZW5kRjN4QlZUanJaYk9hRHl6dmpmNlRFT01VWXNrcXlGWHNUWlc2?=
 =?utf-8?B?b00xcUxFMmVKZk9KWk5hd1NVTSs1SXV0VHRZeXJtODd2Mnl1OXdqdzZ5anl0?=
 =?utf-8?B?ZkxjZWdqU2MwMTZTOU9sYUpOZHhFTnJ2YXFvVUFjbWJxQ1ZMQm9kN2tLNU4z?=
 =?utf-8?B?RFowaURLUVJmQ0FnSldPZUtKYjhMcGFHSzRGcW84K1lWZGc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 13:43:58.3502
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1e55d2b-9ff7-4ccd-936d-08dcff323b25
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7743

On Thu, 07 Nov 2024 07:47:28 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.7 release.
> There are 249 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Nov 2024 06:45:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.11:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.11.7-rc2-g504b1103618a
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

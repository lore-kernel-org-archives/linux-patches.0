Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012019.outbound.protection.outlook.com [52.101.43.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8920279789
	for <patches@lists.linux.dev>; Wed, 17 Sep 2025 20:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758139734; cv=fail; b=GIyDSgaOjgYFOYigMsuaPBVPsEazniLkvzoen4gr4ixmAv2YR+cPOWuIKjLIOl9G6ttJUhIOrTnNn/Q6Qa27rCxn2FzLAam3JhMYTQzjNyUsnaddH9XSRk9Dp1dLJgiGiau3d6wNBS2HiRoK37OPe6L5VUX16V5SDjovqG9BboA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758139734; c=relaxed/simple;
	bh=/KczLp1bP99/xY0LCJQpzAUbYSQ815IuCEje/u/F9/4=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=NK4beZYCv8o1B7WaUEhrSg+nqwEyHoGlIDepHzuEodnZrRrb6OgtxbZwYN+cF6cHKcu+eNbqJJC+cQw8aJKCjknG8dbHFlB3M44iX+kwtw9W3iyRBbAnHL+lPwvUDJboPDLVm3XKiWHIBox2t0CYEXndP4ejIGCMT6e6rx8eugo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sWrJWllH; arc=fail smtp.client-ip=52.101.43.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sWrJWllH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d706iAnXSnUJ32VmMKA4DcTUq2Bqz3XYUwAI6oXYLqgNhNfhNjIrFJmGlOjBEBylrt/jpvlWWdNE5T9vx8I8c70yRXhQIrsh0ESoEQLSUy4TynotolzpJjmt5Mme80VDmvJS5sN1Hrxp1nQ0SpIysyGbyOe33E5OiiYIiqibA4E/EzD2VGddRF76Dz4P8pzS6vg0m1qfcRsNZzgrLKQ9l+PYUbcKxE0EExmD4wRl3NO/U9RiiGfiFuuCPyYGAPB8VDLyYkXRYGab/BoN866khoaVl7+NGScPDQ4FnMC6uys6nsQHS/G6WreLBKZsnByXMhK4pgLNT6GIB6t4/q4FVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pBkTBRhlJJqjV9AmxR4jjsig7SWjDuygsJmXDL//D4Y=;
 b=P+ApAWe2rQP4Ujj9x7ZEnLbhIoQvGdu+SV2+rBkA8zuIdd6NtWEaACEe5rYB53CNXN3QRB3nIHyki9Q31z9MdI4nEwEmG5bKINd+lAD+kEmRt14RpBx2+v1PEhpe1oFbPtyP/m+bphnXtXVcu0ogU9DLZR7mFWtmdpLNXWPYKP5NcWm5P/IF4H6Rsj70sTvslyuEuyLCb5rT8hPD8XWKKtJgsVoW7gRiUs2mga6tpO6mxLunJm12nMVDQG47ALw00EgIE6nmE2w++C7XXvAnbzwm3sIRbDfxJEDFNjThvfKMlXpxDJUypwH5S+VXrlXrY8QJURmqXKX9SgFqIcKsAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pBkTBRhlJJqjV9AmxR4jjsig7SWjDuygsJmXDL//D4Y=;
 b=sWrJWllHqYuNziMbr4kxTTJnWMiO9pypJN6LB6BuSs7Rpy1DtRjwhhdBO4paYzW0fpDqscPc9ElboU4BzwNNskllm228fDVJE0Y7jkNYinEjNopvJuXn5zwZx+Ml1OPrm9pwVs5D6EvlReDbCvwlYkmx2tZHl0aJrVRvMgFerLuXd/YGXkgR8NeVJqwU1OWVgBWIeAvCHdi/8KDJEoPq4LDE7ijn/kpWiikhQVUd7ykgd25q8wLXTXm2JbKGrS1/vmd3xEF29wZ+P75Ym+hXvuOtZivo321Hv+QKySAu7ewJFdWPtiVl0h8pnH+Fsz7Ja/f26HI9jAfPtQ3kdjFqEQ==
Received: from SA1P222CA0141.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c2::8)
 by CYXPR12MB9317.namprd12.prod.outlook.com (2603:10b6:930:e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Wed, 17 Sep
 2025 20:08:46 +0000
Received: from SN1PEPF000397B5.namprd05.prod.outlook.com
 (2603:10b6:806:3c2:cafe::c1) by SA1P222CA0141.outlook.office365.com
 (2603:10b6:806:3c2::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.14 via Frontend Transport; Wed,
 17 Sep 2025 20:08:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF000397B5.mail.protection.outlook.com (10.167.248.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Wed, 17 Sep 2025 20:08:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 17 Sep
 2025 13:08:22 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 17 Sep
 2025 13:08:22 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 17 Sep 2025 13:08:21 -0700
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
Subject: Re: [PATCH 6.12 000/140] 6.12.48-rc1 review
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <66ec6e3d-4dee-4caf-b47b-4e140b789f06@rnnvmail205.nvidia.com>
Date: Wed, 17 Sep 2025 13:08:21 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B5:EE_|CYXPR12MB9317:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bc020ca-bff1-4b9e-0b0e-08ddf6260252
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OFBWdWZ1K2N5RkRaMWs0bUgrc040NVRRYzd6NGNBZ3pZYUNnVUNobWVCNWcw?=
 =?utf-8?B?TDVKdDMrTUlzVi94bnZPZ1BLQ0RFQUNxK3VPcU5lV3JPeit4dFdubmNXTDNu?=
 =?utf-8?B?bnR4Q1NmejBUUmNBUnhZSmVQQmNHUUMzNkRPbjBnUStDVlY0ZHg0OFBFcUVm?=
 =?utf-8?B?S2hvYUVkMjU4T3cvWmo5SXZHa0I4SWU3QTFrWDE0Wi94WmVHSjFlVXlhWGtO?=
 =?utf-8?B?VmdMRlVQWVdUSTM1RlBVaVVHazdjUmlRNlo0SjlOUGZxcDhhcFFmNGxmdHBD?=
 =?utf-8?B?c0R5MVVhd3ZLbVlDVjA0NUluaENnOFQ2ZTRIME5lcy9DWnNMLzFZcDFkY0lt?=
 =?utf-8?B?b0FoTERIQmhzSERCSmJIZmRnVTQwdnlzc2hjZVRscmJIS3RrZEl5T0pyWVcx?=
 =?utf-8?B?Zk9jbEFzYnRCaUFoY2Q5bUFuMVBGWUZmcGwwdnJsYjh5WmEvSlp2ZWpUQjI1?=
 =?utf-8?B?WWJCZGxKQnZoajFLcTNiVmtVWlU3UXpQRTcxcC92Q2xNVzZXc3FxV29KYmV3?=
 =?utf-8?B?UHJvWDRFaU1QeGYrcjhoaUV2L2RPNVlHWTR1enJvRmVENDlNTS8wT294eTZE?=
 =?utf-8?B?Zm9vanptdGxSaWREUW1tWVR6NzEyZE1CYWZ0MU51azVCcEllTkprNUhreFpC?=
 =?utf-8?B?eTNzVEFKS05kaEtkQjY1eVVlak83Uk94SlN0Uy9YUXY2WGRzNnNhNDJCUUZt?=
 =?utf-8?B?emsrYjdZZXMzd1dicnJGRzh5YWlhU2JwUFYvdGI3K0Z1eCt4M3l5R09oR2hw?=
 =?utf-8?B?eXd6MTdTZlFyMlZsOHVpTUlJTVoxWU9sQThDR0NscVZVcVhaZXNnczNvSnVq?=
 =?utf-8?B?ZTk4TjdYdVlZVEZoZnpKcktXYk5EL1ZSTWFic1ZCYUttdk1pdElnZzFyT3ln?=
 =?utf-8?B?NXRpeWRtMGNRcCtuZjgzSW9MWXU5cmxvT1c3K0dkSmRUdk1CSytiUnpVM0tL?=
 =?utf-8?B?WDRqeHMyUXUxQVJMZHFDenBTVGFPditFY0FZQ0N6ZXcydUpSUEdJVzhsbzJN?=
 =?utf-8?B?aU1HNDdsL0lZcmZWZFFXcXd3MmVSbEFtajhOWmpia0RCeUVBYThCaGJyZXds?=
 =?utf-8?B?QUFMRUtpQjZVZFVsZkVlb0ZNaHYraFJSTVR2NWhYdTIvbkpGNXFkeURVcmtz?=
 =?utf-8?B?RldBYWhDa0hhV1lmcUVzSzlpekdrZmtCWTZGTkdRN0N2K2lnVUVzWkxuQ3po?=
 =?utf-8?B?NGFETlh6U0dnTTY1NEs2RHVlaEF1ZVg5K0o5M29icEhIblRKZXc2aWZySkx1?=
 =?utf-8?B?VVhCYUtiZVJwOXc1RGJLRDNDYTIzREhFdVBSNDZzL3ZoYWhyUDJjYmFKMUtT?=
 =?utf-8?B?dVlOTUtvRmtJM1VKS0RpZUFhYXBhb3RSY2RLbU9BQlpvUkNjcWlWT25LTE5v?=
 =?utf-8?B?VFo2S04rd3JjM2JRZlUyc2cyZzQyR1BocS9iZTVuTmswQkd0OHhuMHNFa25m?=
 =?utf-8?B?UnFXUTZqVHVsNXpTR1RWK3E0LzRkV2dEaHhPRXFRclNMc09TMjJOdEtzci8z?=
 =?utf-8?B?eERxdys5WXFaYXp5TkhLUURGbXVjY2FRMVlYdFpjd1NzVGsyYmV1Y2svVlNl?=
 =?utf-8?B?YUxVSmZaZks1c0cwc3V6blU2NStkdGRKcVplTGJZcVBXck0ydWdPZEVpVC94?=
 =?utf-8?B?eEhWQngwWHp1QWVNQWFrcGp2VjBVc1RzREsyd3hHQmpVK1pGQzBwOVBsR3Z6?=
 =?utf-8?B?YW5CWUt2bG5hYVB4Q0hTMW04cDZqSEZ0c093QTl1V2JFR0FHVFN3Y0ZYd25X?=
 =?utf-8?B?cTMxNVBtd3oxdGE4TE92dGFZellCR003WEN5NVhXb0xxWGxEak96NUt5bDR1?=
 =?utf-8?B?cHRwZUtwYlJIbVhrK2NJK1lVVVYrbjcvVW1MZUNiL1BObmJIaStnL1IxTmdy?=
 =?utf-8?B?aGk3bVNhV09SN2k1ZXFtYWdxOVVaWGxEUkljZVRBSlEwTWg1djNhL3IzMlhK?=
 =?utf-8?B?SXFtcEVEQlhrbWVqaHRQT1B0QWlod2ZxVzBJeitMSWRsbzQrZlRwWThHSlF1?=
 =?utf-8?B?b28rQk9Tamp2N2NvN1Uvemx5RGs2WC9WQW0zY3NOMm4xVSs3MXV5a0ZWM0du?=
 =?utf-8?B?RE56MERReEJmU3BVQ3U2MEZoVU9PT3JCcG5KUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 20:08:46.3073
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bc020ca-bff1-4b9e-0b0e-08ddf6260252
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9317

On Wed, 17 Sep 2025 14:32:52 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.48 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.48-rc1.gz
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
    120 tests:	120 pass, 0 fail

Linux version:	6.12.48-rc1-g6281f90c1450
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

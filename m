Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8D1214813
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 10:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745492053; cv=fail; b=PmoFHDXbFf+PecbTTu4hObb/3l1TZSc3pcECmYC14PbFEdf2TxFBnTa7UDH1vA02+MyFAgBdF6NnlwZQHBJ29GYeyQ2jWIyLyA1DDl9Yo+FfekgepZsrZYBzWRTVw72fmN09dYNUsAbm0DJ/0RxZA6IjbqiZStP1wFz9H0LWaC4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745492053; c=relaxed/simple;
	bh=U4shXHHT/gRqAfUEXijM/AtL/4ZTZZIyQ4BvQFjPF/M=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=jRDa1k0BSdhxnVVtV7hfXeRobqIe56cxw+jR+7AJY8/5s5SDls7A7X1ztkWh1BPQmzwlAH1lXKipRVhsaeJ+5X5MSMtDBywPTMlTpLo8iNuewWcKH2ofqPeVDfH+3ePI+lfmEG99DVBMVKATVVjA2AlHfcN8REp4Z1deyVZcEuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AITNz/z7; arc=fail smtp.client-ip=40.107.243.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AITNz/z7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IH/YOdWOWhhrHA4c42fsy+JXZOCm4Tlpk4grnY47jAguiffo+WsBwf8yy0XBDvik6LpAO2y9uX9pjF/E/AiA78W5cZexHdqhu1knqRsNYvExQg3GyMxB7Xi81HoIUBDlJRZ36xHX/Nl9zCBwb2TgGUCGGzFhpJhliCPr1C/EqKXbkOo52Ujti3pyJ4u8zQ8Az9XnKp9y8EElEFlpgK2xE4Emu5oNO7X64UUgJ1pKnHrmueRYEElhh/AVC061/1U7wFmeh+tLYV1mEbIdkeF7D33tdci2AD5Hmo0aHaOjDnOO3rR20fmqct7j3xwN2uq1x7R3n3gvCJTlySt5OYa6fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+iYwuLyXechhvu881e/jGsSyoSteCgRuEyjvcUAZAg=;
 b=eLdPimEhxkBlasyp1orVL/YzAsEigim2Pj5OViRNLbkAbBYEkZNu18Vh7Q8EL+Uy08X/6PsMTutpff6RWF90uTkreLGQs74GaPBKdcorncsrPcd3I0IvYmOdK/30V0IB2eh7J/drnbf6s+OsHxP7PNYMyYbZRpctoM2EkFs5vq2u1AVh+drAZz//1A/B6oWMrSp/NtIAvAQeS7Ogg2Z9+qN7QBtz5UhVl/w2M6JAKFou5l2Fw36+09lFlpZCGJUpIquXbp4OLehELqCFxrzUR0kP9iN1JUVePRwyu7cnhYFxCJD462qk9Py5jatgX86xzUNNDQPHTKTUnFuHgZc48Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+iYwuLyXechhvu881e/jGsSyoSteCgRuEyjvcUAZAg=;
 b=AITNz/z7OZ/QHyx27pvAJyQrWStSGNqcnfgEqyvdQHR+hampBN6bZtTtAc9G8X02PDtzbBmIbYbu71CTfx9Q7NyvD0jc0bDtnycdUSGCmGHGBbUHXS8v5KHReI7xJGV/1O5IG0hhwlQbniqI9GVSxOQYxwVD1Mm+WoXqsG90YYajvwsQnNvyKFMTCwnHv2Xcex01fMhr21SQ7nWzf0Bhxj06Zn7CDr+Nsty4bsyteIUIsaS7TMB32yACHOwe9npcb1oq5ueXyVcObmTicBSAj4m2MK1DRL/hafHK8OrH2Xf1duAp3HgmgP8wYZeeYJCZPBhSY6WMfkttzHfubCfBcw==
Received: from BY3PR04CA0021.namprd04.prod.outlook.com (2603:10b6:a03:217::26)
 by DM4PR12MB7576.namprd12.prod.outlook.com (2603:10b6:8:10c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.36; Thu, 24 Apr
 2025 10:54:06 +0000
Received: from SJ1PEPF00002319.namprd03.prod.outlook.com
 (2603:10b6:a03:217:cafe::f5) by BY3PR04CA0021.outlook.office365.com
 (2603:10b6:a03:217::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.35 via Frontend Transport; Thu,
 24 Apr 2025 10:54:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF00002319.mail.protection.outlook.com (10.167.242.229) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8655.12 via Frontend Transport; Thu, 24 Apr 2025 10:54:06 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 24 Apr
 2025 03:53:59 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 24 Apr 2025 03:53:58 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 24 Apr 2025 03:53:58 -0700
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
Subject: Re: [PATCH 6.1 000/291] 6.1.135-rc1 review
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <375b7af4-0946-4dda-9ace-e94eb1285093@drhqmail201.nvidia.com>
Date: Thu, 24 Apr 2025 03:53:58 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002319:EE_|DM4PR12MB7576:EE_
X-MS-Office365-Filtering-Correlation-Id: 36f9928c-1871-4801-6165-08dd831e5586
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V0ZLTTJOTGNYNnViZjJRR3hQb1paRTBBZ0tUNFIrbURLM2hNRWdBYTZwOVhG?=
 =?utf-8?B?VExiSnFld2tRcUhuMGl2b2ZvVG9YNXhSbCtYOEZWSGVTOFhxdGhVTmxtYVlt?=
 =?utf-8?B?bkRPZk10Ti9IVGZmRCtIb2VKZFJrTWMzQ2k4VzNGeGk5a3d2WDZrOHExVTJF?=
 =?utf-8?B?eWJITmhOUEgzQnJHRnRURE1LNldKTTNFOEV0c25hTm9lc0lvWDFjSWJwOHRD?=
 =?utf-8?B?ZE5MYXlpeGxoWVoreWFjcTZYZmE5MzlaU0JtOVo0czVSZG9Ub2s0b0VibjlE?=
 =?utf-8?B?VVpCbFhCRjVKTUdBa0YrU0ZhMVZqQW5YZHNzRHEwb1YzVXRGaGM0N1lxWFRp?=
 =?utf-8?B?N0p1Tnk2VHFUS0pYelFtWlZSR1RiVGk5cURyWW5oTEZTUFlCR2RWdGJOWGZ3?=
 =?utf-8?B?bkFwenNmQ0xmNXFnMHIzZTR4UXFGVVU3Um9KTEx1MFJKN0lwYVIwcnlSaVFs?=
 =?utf-8?B?cThIVS9yZTRXS0x5eGJQWE9PK2hnNldtcWJad2FaUDlzNWVGK1dLVlhMczh5?=
 =?utf-8?B?TnpiTTJKWFZlUStmUmYwVnk1ellBNkZ5MjZjbVQxbHdTTk9jek1aZ3g4SU5K?=
 =?utf-8?B?cmRwdVdmc3R4RmFjTjRuK25pQXQ0SkRUZnNRRHlFMGtxM0FTb2VmOVUybm5Z?=
 =?utf-8?B?S2t3bnNjejhZTEFZbkhtVGo1U0tBWEIvT3pqQWJqY3RWQmhiQXJ2ZEMvVkhJ?=
 =?utf-8?B?U1JNbGlONVZTdHZScXBjK28yUVVEUXFvU2Y4SGtaTHRmNyt0VFlUSjg5OVIz?=
 =?utf-8?B?WmlsKzMvMEg3My9pYjFsSndFMk9IMXc2ZVU3ajU4SmZtVWhwNk5ZcnVPWEFD?=
 =?utf-8?B?UWJwOXp2NHArbGdVQzJuYjdNMDBqeGdGUnF1YkhwUm5lL3U2V0xDcHIxTjJp?=
 =?utf-8?B?VGNSLzcyU0JaamQ4QWlTK3N1am1aQWh6UGh1T3pEMlBuRHd4OWVGaGFCUEQ3?=
 =?utf-8?B?K3h0cHdKcmUwM1pTOStydjlFSE9Ob2pZbHc5WjVJZFFFUUoyR044aG1ZSVRT?=
 =?utf-8?B?M1I3dDIvL1d5ZElLOUpoZStRWTZWbXFMQVF3di95dkQ1QVFBbVM1VVQzSys2?=
 =?utf-8?B?QVNic1hySHZPalhTOW5DN1BHUVkySzlQMkVqa2dvV1ZtaVo2WDY1d0RSdzM0?=
 =?utf-8?B?U3ROcDYxRTJMaE5pL3BXQVNtTjZORDRhQVJFbE1ESkFjbHZsWVZUUnhPbk1Q?=
 =?utf-8?B?djJmaXRjREhYb29IUmowcDJaMkpMVzZmY3QxWXJRM3B1dnVVRmswMmNBK0k2?=
 =?utf-8?B?Q2ViUE9pUTFUbm5BOFZDaUtOR1BxNGtmQ0krYUZrdGZvVXU5QXJCSTlSVWpL?=
 =?utf-8?B?V0hWWnN4N3lzbWErbFpCZlBMZDFjVEg5WUlpckdIZmI0NUtHbWRxS2Nyd2tL?=
 =?utf-8?B?bkNTY09YK2JVbnY1QWFoMlMvVHRBRGFaRWUxMmMxMXkxUTlVdlFMV3IvN1g3?=
 =?utf-8?B?RVdUVHgyTXZ4MS9CWlpBR0Jwc3ZpSTBSTWo1RmlldFFpVzlXT0ROVTZTeEZS?=
 =?utf-8?B?RXZuclRmZ1JwZkNTL1pPZWJCdHljOWh6b2ZrNzJPaWxGaWNsUkJwWW56b0Fl?=
 =?utf-8?B?ajlwK1Q5Mnk5YStwQXpseTJWM1k4c2I5U2ZkREdNQUZZTGhpR2dQekhSOUVX?=
 =?utf-8?B?ckVjVDVxeEU3cFByZDlTZnF2SDVDM1NHL2cwa3NuaDRsSjI1TUhpNTVQVUpL?=
 =?utf-8?B?V21JNkZ2ZW5ONktoYVRzS3owaEdaeUJFbktqUkdHZ2F2YTZTamV5UHhLY2Zl?=
 =?utf-8?B?MXZWdWVkMG1xTVZNSUxUUEl3TVJiZ1ZJWlc1cEt1cW1yUTJ1eUQya1E2aTlH?=
 =?utf-8?B?RTVHNkw0UG0xcW1wZVpaa2Q2aGRnYzFRQWZxOHorampRc1NYem5QWE5Ga3R2?=
 =?utf-8?B?S3poWFRzeWtUa3BQeVZkYXhzR3QyM2Zsa1dyME5pWm1SamRsVU1CRDZmNm45?=
 =?utf-8?B?TjEzbjFBRTBmbTB6WDRJai9qZHMwVUJGSkNiL1lCY1pNcEFJdE9uSVhocmpu?=
 =?utf-8?B?Z3AwYW1zWkdVNUg4WE1UYlRsanVieGlDanZ4RWJtKzh1SFRJWnE0R09Uell4?=
 =?utf-8?Q?vZlt8E?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 10:54:06.3449
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36f9928c-1871-4801-6165-08dd831e5586
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002319.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7576

On Wed, 23 Apr 2025 16:39:49 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.135 release.
> There are 291 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.135-rc1.gz
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
    28 boots:	28 pass, 0 fail
    115 tests:	115 pass, 0 fail

Linux version:	6.1.135-rc1-gb8b5da130779
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

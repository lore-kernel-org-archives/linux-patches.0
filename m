Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2065.outbound.protection.outlook.com [40.107.96.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19A31E516
	for <patches@lists.linux.dev>; Thu, 16 May 2024 12:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715862859; cv=fail; b=Lga35L25TUGUI8gbQInqHxVIaUZDkOrS1D5R6r+8y88gS2kdXOelrkomdrQ6hYumwuHqAGl4WewwoMyPdZaew1pXn3d5MyL3X5TTBfazQ5WNecFmbttPvCx19gAH99oanD8r1qJAu/HeCXOk03JF/kjV/+oOz9ADqjckd3iUp0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715862859; c=relaxed/simple;
	bh=/wDg3ZUvcy7j6Olksqjc79yBWG9LZ2HoOOmXw8dggMg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=qwCrSWyfV3hVjAUGwQ8MoUZwbmmgbSrwT/XbJ5eSKsAOFG6MK4eXJ8iCXbUle2EY8XwJYU9Ea5/GioGXav7wZenu7AuqpYwEeUU1BPTeYPjBf4qiqo3Bv5xNF5is82tHrxogcD9WoBS/Ru46tO22bL24B4s5c0Gy7ZX+Zui+xno=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LSwGb4Nu; arc=fail smtp.client-ip=40.107.96.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LSwGb4Nu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h0LIkJ5KShSxImSLTi7A9QTiiEnpeY7ykcrBTeZ1x7CYb4ki1JBMYa6et5UA/6In47dYj1Rfku37JJTlIfsuv3v0fZmNi7ozetVRLtJKwUk5lXvYk3g7cx2HmKtFKY2pCeTXNc32muIHaRlRhJNU+DkbtCwtJNtyLCJV9YRNUgIyRLqbEDRQrW9DbQ48FSGc75bkEOP1Zn2xSnYf54WzahegnvD1mDLd/BWTNCVGNVH4n3zHceD1HoBVcnRlpjWXCvosjJx4bJqDQxMRdNFC9lzmW+CGFh8WOAUgjUxPv2PsvTYH2NwzEDmoYtqkygXnqwVqSsMcUrfNSKRay2nFGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PkHz/+Fwn0HYskzjsWSSDctmdfmQxTbzJxtZhlBOzgg=;
 b=M7NpHl4YGTtLvgGuDtgAYhmN4+Wvq4DT4jRoAakWiiJOIZOOKl7KpuTqNGzZHoi9ej7SusZ2cZVXkRnaYPWQghK5F2MTKSWvcGcxuMF8PLqLcu1E3ILShxW5s0NuVJ5mS0I+yLSVYjOoI3hjJ5VYmwwq03LGs0MeFxCWuJNW2CrvhgxAK3FbziuyVPCCUZqd9d4/Trr1lxAPlx3vrI3b1A8jDExEw2pjCyJBCUnbrgzQa9BlegmvhQD9exbL/OBM5FJZekU/IbRN2SUaEjU+WnC/UktccCpASYWhMe0HX2l0uKLmDAOxqDCUr+tkdiNhD0/JA7x42F2xd839xCsaBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PkHz/+Fwn0HYskzjsWSSDctmdfmQxTbzJxtZhlBOzgg=;
 b=LSwGb4Nue7QiyB34DFBAJBIvGXdZi2U+M7np9eguAJ6AgZMIhHj/Y2MYcqhztK7wWTAK7zXbMD2AXrum3DurXTj/KQa8lXacWTIPJu+czZLQuKt5/w2JhkWYJtpImVgVlKZm3djBFAcCFaX/AaxZiA1RDS2Qmd9qRj4N+Ipji2Bc57t+BhVR4AFn6Xp0qPKTbT1fS0tgWDJxJ4SCC99hM5OzGkGv7K/mFsYFdt5XQcoEAAN2ErJEnkPJhRzZ5HgTvPKiGZU4VWfQGhs7QEbsy7u9OypXeRkkBRoudcUVV4/Rm1GGFnbUAkOa54RPE/B9bCaxu3Z1rf53p3YyIUQRkA==
Received: from MN2PR02CA0014.namprd02.prod.outlook.com (2603:10b6:208:fc::27)
 by PH8PR12MB7158.namprd12.prod.outlook.com (2603:10b6:510:22a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.30; Thu, 16 May
 2024 12:34:12 +0000
Received: from BN2PEPF00004FBC.namprd04.prod.outlook.com
 (2603:10b6:208:fc:cafe::92) by MN2PR02CA0014.outlook.office365.com
 (2603:10b6:208:fc::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28 via Frontend
 Transport; Thu, 16 May 2024 12:34:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF00004FBC.mail.protection.outlook.com (10.167.243.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Thu, 16 May 2024 12:34:12 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 16 May
 2024 05:33:53 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 16 May
 2024 05:33:53 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 16 May 2024 05:33:53 -0700
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
Subject: Re: [PATCH 6.1 000/244] 6.1.91-rc3 review
In-Reply-To: <20240516091232.619851361@linuxfoundation.org>
References: <20240516091232.619851361@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <87ae8cf2-b7ee-4d47-b3c8-08412026bf76@rnnvmail205.nvidia.com>
Date: Thu, 16 May 2024 05:33:53 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBC:EE_|PH8PR12MB7158:EE_
X-MS-Office365-Filtering-Correlation-Id: 58a42b90-af5c-4195-a3ed-08dc75a47dd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|82310400017|7416005|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UFp0T1FtRUg5cGp3QnQxMDdHZW9lKzArMUtjMVNCTVh6SkN1dmVzNGxOaHpX?=
 =?utf-8?B?am1vZ25QaVJTNTdyVUJQVG9lTURiTUNOTlkzOXQwcjZDMmJtcStZQzY2YXFI?=
 =?utf-8?B?aUtQcVJNQTR6cDEwZGdrSzlWZ2lRSzBVa2E4U1RDV1VpcFdjTGwvSkl0UDNK?=
 =?utf-8?B?R2p5azVOTDdaVndDOTB3ZS9WNDVIc1JsQ3gzRXdXNTdhOTFBOVZnSjdLc1ox?=
 =?utf-8?B?V1k5K2FiSVkvRHhZYnB4QkdJQms1aVoyZ1Bsc2ZlOWgrYTF0QUdKYmU1SExL?=
 =?utf-8?B?cHBwdzF4bU9IVUpmSDNkbHNXbjg0RXVXVkN3aHl4cG1ITmh1YXErbXZzV0tB?=
 =?utf-8?B?OUJpekpoZEhadFEvOU5ZTmZmRklORllwc0RCa2xGUTcrT2I2c3daMUlRV29Z?=
 =?utf-8?B?dytsQjZxalllM3FpcXpkRzdjU0xuNURvR2ZCam5rcXhhWXJJcFFoOEN5YURB?=
 =?utf-8?B?dDByUlprZTVwdCtqYUtNQk1NZ2lNNmtYT0l6d2Raejg5SmZsc1ZZdGpNbjU4?=
 =?utf-8?B?SXNsOW5CcGo1RTN6ZGxoTDVpdlI1cUlaYmdQR08yT2xxa3F0Y1h1OGlDaTlV?=
 =?utf-8?B?RHBNcU1PcDVvVTBZWENkVi80disrNldTUHV1WGNLOU1mdmozU0huU09MTC9w?=
 =?utf-8?B?Mm1WU0ZxUnc3Si9HSXBDNS9YMnF6dkRiZmc4TzJFdER2dWxBTEtXMWFOREpv?=
 =?utf-8?B?UDl1TjZXSFB3bUNsdUpYMWU2bDlnaHVUcSt0ZUU5RUlPMG9Kbi9HTnVYOUYz?=
 =?utf-8?B?SkRMQlBsMjRGOVYzTWhDQjVuWTJ6a3hXVnkzZTNMRFRXZ09FNWNpNFRzNlFk?=
 =?utf-8?B?clBMalFQNkowOVVMZ1lJZmtncGhXY0RDb2hONDl2clBIZXd3cCtLWDRZaVhK?=
 =?utf-8?B?RjhFT244RFZxRzBzdGxmcnh3Z1A0Q09TTHFuVWlRSDJPZ3NLZnQ3TkY1ZHJ0?=
 =?utf-8?B?ME9KcTRsWDlLZGh1bW54REZzUFViY0JmTHFrMGZxOFVHVzlZd0FiYlcxMnVP?=
 =?utf-8?B?dEpXeXJUM0JXNWxtT09YUXhNd291NXNPaHBiRGVBL3ZBREJLS2plcEJUaUtt?=
 =?utf-8?B?Z0Y1em1IUjJ5RUxhUWd6V0ZDaTY5K2hvdkhJUVBFaTdEazU0V2ZGK2lROVd5?=
 =?utf-8?B?c0pabGg0VVRlOUNMVXZmc3BtMWkrYXpPaWZWNjBTbUJpZHpvU1lGOFNFODRt?=
 =?utf-8?B?RlJGcVR4UEIxY05hQWhxeXh4am9QTE0wREF0bnFyMmFWT3ByRVpMSW9ZQTUz?=
 =?utf-8?B?NERHU3F3ODZydmNsZ3FHKzh0M3FyamFxRlE0cTBDMUliZ3pLZk9zc1FxTXYw?=
 =?utf-8?B?OXhJQTI4MmIyaG5LVEFPTVJDQXdYOGg0YkMxU201VngwQzIyL1pna0hlQjk4?=
 =?utf-8?B?UnpHK0JaUVhCc3BxemZLYVlWUWlHYzlsQnVzc3J6UEdJRCs2Sk1Db0pqb2JP?=
 =?utf-8?B?UG91Y3VpVE8zVzNjZXF1aVJzVXU0Z29sMWkyYU51WmluM0t3SkdobjRhTkc1?=
 =?utf-8?B?L1FaL0xIKzZXNWtXUWZ5ck5Kd3o4ZFZsSUZ6dzY3Mi9CTjc5UTczOHowNTZW?=
 =?utf-8?B?TW94NWhDZ1YzZHpTTnRZVGk5TFM4aHZPVm5pVmE0R0dNeS9aMTJGcUoybjRE?=
 =?utf-8?B?S2l4dEdRYmdoWGRxNVQ4cmUrQWtSTjB3Zkpwc1VsZ0YyV091NWRPZXZpUi9U?=
 =?utf-8?B?b20xd0xOZW5BNXN0OTBvcnMyNkUrUVVtYXQ1cXN1ZUIwb0ZVMlhwQm5lTzFU?=
 =?utf-8?B?bkFpQ2lidmowNEV0Z09tcVpBTk5TRE9zSmhMSDNCeEI4dW4zbmdrMGxhejNC?=
 =?utf-8?B?QU5NZ01INHo5V2o4NmNMVWJUUjRtd0tHYSttekk0NnBFV0xnK1hYemxSOGhh?=
 =?utf-8?Q?gWQe31WfhijIu?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(82310400017)(7416005)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 12:34:12.3910
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58a42b90-af5c-4195-a3ed-08dc75a47dd4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7158

On Thu, 16 May 2024 11:13:37 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.91 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 May 2024 09:11:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.91-rc3.gz
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
    116 tests:	116 pass, 0 fail

Linux version:	6.1.91-rc3-g68f58d77e671
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

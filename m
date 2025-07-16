Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2054.outbound.protection.outlook.com [40.107.95.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1291D79BE
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 15:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752680593; cv=fail; b=LVDprq4iTrT9P9x+KAHPzhwKvXnHCIAlgP2Sk0yyxBOHmILHEDbjm9ZClgljGCfUtbEIrH34iSqgTySxsmj7+AMwZShOorSddVlb9vDbWS8Sw7JQQ4JvZb4CFnSMNY6VMar8Ios/rmn6F4E3z6NSZQwuffqY87sAhD0L5/mPpnw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752680593; c=relaxed/simple;
	bh=pMbceGTmyuaBj9KEPJg2EMheG84uFNimd+xrXjRU8To=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Cn3QWUsYZqIqwWvN5QaP68LK0YQzMevu4OtPi7pDZFCnvRPMVH4liaMdoSVrxEycEnqWsCIS+7Vuwz05fIR7Af9gQtpui9n3mRN7/va1Jjy/SbPt/tBlcCNJA2z1ACQ4Gg29xLNpXGNdcsBJEfEws4robkxJvb+ee3tKy/10kco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kiLvyIor; arc=fail smtp.client-ip=40.107.95.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kiLvyIor"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BwTqP9wErHISZaXbAZBwQ+bDJBZrxmaqizVfNiWY3+ASRQunUcvfgQnc+YXVXtiP+BU3tWOCNutTx/DVousaLra7afcS2eQJfP1pGQO5BW2SbHzaBcaFrfRe+QMBgLSPm3+uUhIf2C6P5DfdL6+AvmCGZXWi62wHkSQVRL9xlqLcF/9YQoDUHbmnflMO0HqW4nQmMSvrDr/j8ciSj/vnFwlzmjk/NSNR48Mcq2AMEs5FELuqkednEtqS5jtbUxw/g5m/yPa2OupQFEhNBOBHkxtoMFANCVzx4k+Jc/irO+XXpQKYZ31Bru+T+DEld9gHiKjzcCIgdwZkmtJZTvIriw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7C24a5NQxuwr0Q9XaUWTJozsvizQgGr+MZIvZS5MJLw=;
 b=MTgBlhpKdg99jCXiZSB3or/0/cXjXvHzvHYxKJ7kGbdffIhdVDBroWtvZHJq+QVnAvELSej8Q9L9tqfV0CQxwQBV8k8C6zqvQuyYLLT/huRs5kMowUiJd06EFqeGUoRWwXPiCqNiyLbGI11mOhqvwAva4F7x1vxQMeRqCqPGMNYxW7IxPG7HwJI1T72/wSZgMEmZnVOM1oJTle334CGPM+kP4JCFVJKXoUf4GCOIxoYke1f3HU7hgYkz/tU5MseXtPMniV2OZZUsT4FSe8U+f98L0k07Z91DhKcZKL5kky2ua6/AHdEm15AIIuGcjhNcDhj1qdtXyN2tDhRPeKMvuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7C24a5NQxuwr0Q9XaUWTJozsvizQgGr+MZIvZS5MJLw=;
 b=kiLvyIor9oKHmK+/5ZnCHTxkycWMwZFcCNc3L4OZ6K+TsBVsBwQfb5100ByPwnWncak8WzLXpAYLmZoWW4ab0Emuyd7YcPBIya5nvpwPq3flwsdb80j+INgU/5MdXshfrHKvzJAEWKe1wdgwHhPPcLkmF/TKJZliT/0w0zsVPm+6ZMwsuzvm7RKTGMmxcRczDUUxrE5pYBPu0fGZkzwOLDwzpyF+Z20DqDFrwweQP45LB4+PCmCzFzIO0D8vKa12TmPhsIfx78WMlZoWqLnEw3joIN1TLgnKXkZo2w8mFHwYDkQtJjDapswfOJRiHduyPf9/YBNvYQDV/80Ou1Haqw==
Received: from SJ0PR13CA0034.namprd13.prod.outlook.com (2603:10b6:a03:2c2::9)
 by IA4PR12MB9834.namprd12.prod.outlook.com (2603:10b6:208:5d3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Wed, 16 Jul
 2025 15:43:09 +0000
Received: from CO1PEPF000042A8.namprd03.prod.outlook.com
 (2603:10b6:a03:2c2:cafe::1e) by SJ0PR13CA0034.outlook.office365.com
 (2603:10b6:a03:2c2::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.16 via Frontend Transport; Wed,
 16 Jul 2025 15:43:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000042A8.mail.protection.outlook.com (10.167.243.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.22 via Frontend Transport; Wed, 16 Jul 2025 15:43:09 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 16 Jul
 2025 08:42:51 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 16 Jul
 2025 08:42:50 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 16 Jul 2025 08:42:50 -0700
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
Subject: Re: [PATCH 5.4 000/144] 5.4.296-rc2 review
In-Reply-To: <20250716141302.507854168@linuxfoundation.org>
References: <20250716141302.507854168@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <36661855-6678-4fdf-81e0-55d86ae40009@rnnvmail205.nvidia.com>
Date: Wed, 16 Jul 2025 08:42:50 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A8:EE_|IA4PR12MB9834:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b633e72-e266-4fa0-22f2-08ddc47f76fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZzZ3d1JYTnEzNUhEaFBtNy9QTDVMSDNIdG9jSFM0cGZJR25pTlU2d3lESjU4?=
 =?utf-8?B?emloMDloU2JUUENYbmpoem1PYVBld2IvTE4wcXRnOGNlbGQ4Y2F2dDRLY3Jo?=
 =?utf-8?B?ODRTdE9hUDZLT3pVdVdMY2dLS1c4Wk1zQzdENTZzendUZXJWeUhXUm9tSTZm?=
 =?utf-8?B?RkVBWC91VzFVMjFpVXc5aVBVWGNtSStCYVNyMHN4R29rQk9WNlFReElydCtD?=
 =?utf-8?B?N1UyZ3M0M1FkOFVzdE1xdnlzbVBxSUJRTDRXOFJHcDhQaU5FaGltaHlnT2Vl?=
 =?utf-8?B?K2FoL3Y1c3RONzRoNHhtUWpSTEdJZ3MzY0xwZ1p1ZC82VDNLc0FOU1A5N0hY?=
 =?utf-8?B?MUJmbVJGT0QrZlI3V0dOYnlXSnVWb3U0SzFhRFlvOHVza2s3Um4wRnQ2c1Rt?=
 =?utf-8?B?a1dzaS85RDR2SEtNa21DZGpDOXNkWVF5TGVwdlJJcVJtSGxOWDUxbkRLY25y?=
 =?utf-8?B?cHMwRHVnYVVJdDBSZWFTMlZscjdLVEVqd28zV1A5OGJOMlNNZkdFZ2h3ZVhj?=
 =?utf-8?B?aVlheVB6MXpqUGtRdVBqN3VPdDI4S25VYkdEaTdOTW1qNmozU0JpOXFXRFBk?=
 =?utf-8?B?b3k0TXF1eUdtZTUxK3VYUU42VmtDM2d6K1RpWTJFN1BSWXdyd3VGeDFFdW1n?=
 =?utf-8?B?UktWdVVkSFBUOUpOS0I0aks2OXNaNDVUWWFtUFRhbUNtRlpVaDAyUDBIT0Jk?=
 =?utf-8?B?a3ovdUpDRGtsWGFXQ1pGa3JEanhtQ3VNNG5UNW0wWEhvMVZiVy9DaDFkNVhz?=
 =?utf-8?B?dnpva3ZjQ0VWc0FsMXpFdTdESG9JWXhWWHppMVUzbzhWbVZTL1RlcjdITWNL?=
 =?utf-8?B?djd1K3pPdU8yYlpDeGhEcS9MNkxYY1N0V1NtMWlMclIvTlZaRnRGWjQzQ1Nx?=
 =?utf-8?B?YktMZ2pIWDhFSW4vczh2U1pjcGEwTTdDWW1DTDNMS0NJSU9zNE80TmNXa0Qz?=
 =?utf-8?B?eVVCNEllSi92Wnl4bHVabHJaRWpSeVBoT2ZhQjh2TEs0b212dEd5QndTTkJK?=
 =?utf-8?B?S1ozVFN5VHdmVDBDZzhxM3JaR05BVUI4MXZMdmh4b2M5aWpKQ1NLSy91emJH?=
 =?utf-8?B?b3U4L0Ftbkw3Y3FzQ2xITTFTSk1qQzI2cXd6Q0dmT0QzMHpnVXk4TXNyblFp?=
 =?utf-8?B?NDJwbmZYemdJZEozK1dpYTdnMDFDVHErTXY4MnhLRmlseWl4WjN2Z3V6czVR?=
 =?utf-8?B?dG01SDJzOXIrK1hteWptQTZ3UEVMc1hPeXFuc2ZGczBCelliQW85SWZwUUE1?=
 =?utf-8?B?R29LRCsxdTdvY0d3MnpmTzFmeTR1cmJRenNMZVE1OXdCV2twdG8rT0Y2elFu?=
 =?utf-8?B?UWNGT1ZWMVRPeWpvQVN6SWhOejM0dTV5TkNsS1hxaFk4bkg1N0V4U3FqZVN2?=
 =?utf-8?B?NkhJUXFDQktMbjlwOWM4RGNvY0pKKzlCMTFzeE4rUkJFN0daNUoyd0FJcnA1?=
 =?utf-8?B?QTVXVnlOamlNVDZ2Qit2TWFPOCsrNENUdUtLZ3JVY1ErRlB2ZnIrcndCWU9p?=
 =?utf-8?B?dkE3Qm5YZWJONnpIcHlxY3NaaS9xNFlIV2F5M2dlNmRLc3NBdmh5cVlPNXJa?=
 =?utf-8?B?SFpDajhweWlkbWd5MGxoYVZYbUNseTR1d0U4RkRRbC96Vkh2alJ3bmtzdjgx?=
 =?utf-8?B?YjhGbDZXZTR4Snd4bVlwRWVLRWUxbVJuRWoxdjVLSkF4VkE3YzNnS2lvWmw2?=
 =?utf-8?B?Uk4xMmlHN1lZa1lRTElLRUU4S1Zra3ZoQmp3Q0MvNkRpeHNRWHZlRiszQjJo?=
 =?utf-8?B?QnU3UlNnU214WUNPb2JFS2xRM3BZMEU1M0l6dHMyU29JVWRyN012eG9kYisz?=
 =?utf-8?B?YjhmMGNXNUdBSGpSeVI0TUdXK1BGTmI3cHdXbDNUWUw4T3duNDlveEFJTzJ3?=
 =?utf-8?B?VlBGRi9jd1l5UktqcXFwcndKQmgvTnlLVmRNQ2s2cFRYZ2NUejFBY2dmWEpX?=
 =?utf-8?B?ZE9Jd0gwM2JuckJaRGp5WFhpcmZydFk0Wm9MNytNWXRkZE9wZ0NSR3M1MEF2?=
 =?utf-8?B?YUJFd28xYjVQOVdMaFZyNEs2MXM4VlFmbzZsSGNUN0pISUpkUGtHQUJEREdE?=
 =?utf-8?B?ek8wa0pCWW1QYkpxYjZvelQvSXNaQS91cjRYUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 15:43:09.1043
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b633e72-e266-4fa0-22f2-08ddc47f76fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042A8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9834

On Wed, 16 Jul 2025 16:14:18 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.296 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 18 Jul 2025 14:12:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.296-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    24 boots:	24 pass, 0 fail
    54 tests:	54 pass, 0 fail

Linux version:	5.4.296-rc2-g6d1abaaa322e
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

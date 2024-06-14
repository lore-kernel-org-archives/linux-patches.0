Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16F819DF61
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 17:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718384668; cv=fail; b=KKTizGv50COjj5+CQD1psKPtiKgeRGtmGxt7AnPSxaIaKF/bTIyu+OlXuJwNzbJ78T5Q6KVyMunLB1mw+eBiV52Ql76DhHnHZpodzx0epxXDJxd22PmU4inUf4++ov/v1+YZFIig76XQgrsbm9g9iVtMmybhnHz/Ym7kcrHJOA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718384668; c=relaxed/simple;
	bh=cmZdXCMCSE3iYx4vy3SBmdRnGMgktEuwvrHQ0exIPDU=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=Oa4Ch7Rr0zvOR43OKJVn+5Fih/AijCxID2BrSooQB5LI3oiBrnkP2FUdMm4lx5zhgUl0lRg1RUuQpcEYg0zkgNGwJSlrDKN1WzFVSYRA6AIf+xOJRo+52EPLwDkZFyyomKD/9ziWZFiwtA2/5YLiVA+SGkOcV6ow7swkGJwutGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AZDawylm; arc=fail smtp.client-ip=40.107.94.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AZDawylm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vfn3k91UtO+LRnhJ20v4yMHr5o4A4rc9w1qxMdWubo9mOOH2H7Wszjsqo47DTn4yJN99eDPG36V22mUVZoBSr1l6Ifgc6IRXdKK3GNqagMW/W4W3iZribfKpdYUinq3Vpni1NXz/yqLUZsivYi1ys+RtRCXmR1iiqJDRRZ2SxzeOA2is5Fm7XJNG6wObORC0IUJlfrdMRti+vpF4Y8rSXhF1zuuJql4UAkXlAghS0JatDEkhJFuz0vnkFBlB0C2BW/oYX0lNpkRYjZDO9xH2Hx47VRrY/I9QF2rNHpZZxXbmiE5TKkPUg1XXJojGkAGmmz8ozyYXg0X/laCI4QNq7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eueTEevKWcgeBvPu5k/hyxGpkjZnGqyk/N0iJfAsVjo=;
 b=V8MxqMfWweFy6K27maG8qe+8s13+NbdN3QZkmjU/HX5992O8G4QvZvJjDw7M8z0mEfTf7A4Dg1skdAcXjxVZkpJLsuGyl0Y+rR99m8LmZNKPXfJFshZDvPiqbZl60iNnI1VzCXAfDcLPZXqdQOh7xwp74Ksr5jBbZYP+NSLHSzwavx95o/9PXhbo4284+/BVfCn37ExEETJN7GkkcaDvciRYVPf8afdc2kAVvvl7m4sxrfJiHh7HHv1/iGRp2EzewL/dXYx6nldkJp3RVlDrnEUx6pbDecbeDhaI8Ddzp6bYx4e8DNJaAN1UFQWIf8oErd0fFxj8iwGk5WWdrn2JVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eueTEevKWcgeBvPu5k/hyxGpkjZnGqyk/N0iJfAsVjo=;
 b=AZDawylmbEeEtmK0gsZVbVoYsDLchJy8EfEQK/RXiUftMgaRJ80/KyhhOOklLl2Ob/Ixomkl1trDTkLSj8V4VDkkpHbvFlJdJlZ8MTSMrk8Y8eyK2/951yDd90QkEBcFaYg4xuyjC0LrM99hiXcROY+8aE4nqymXcSMygzpsEM/LyTSYkRuGMqLROpZ5sgG3pN+3D8ZxNTI0coaY0d1FjRNip7nkYI1uHOjOX80xfNi8hTlFOnmviVVDRYDuXtUHju5Z3u/X3lYnxCDYqK5ggLQhSyPl56L5tvCy8ARyp1JV9zkHQd/rvEtSHUPCjLNzps7qqxAJQxAlg8XLPhG/FQ==
Received: from BN9PR03CA0562.namprd03.prod.outlook.com (2603:10b6:408:138::27)
 by PH0PR12MB7840.namprd12.prod.outlook.com (2603:10b6:510:28a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.25; Fri, 14 Jun
 2024 17:04:23 +0000
Received: from BN1PEPF00004686.namprd03.prod.outlook.com
 (2603:10b6:408:138:cafe::f4) by BN9PR03CA0562.outlook.office365.com
 (2603:10b6:408:138::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.25 via Frontend
 Transport; Fri, 14 Jun 2024 17:04:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF00004686.mail.protection.outlook.com (10.167.243.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Fri, 14 Jun 2024 17:04:22 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 14 Jun
 2024 10:04:01 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 14 Jun
 2024 10:04:01 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 14 Jun 2024 10:04:00 -0700
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
Subject: Re: [PATCH 5.10 000/317] 5.10.219-rc1 review
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <2944a4ee-4078-4384-953c-31a7519d0864@rnnvmail204.nvidia.com>
Date: Fri, 14 Jun 2024 10:04:00 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004686:EE_|PH0PR12MB7840:EE_
X-MS-Office365-Filtering-Correlation-Id: 55cd334f-8aea-49f4-8f1a-08dc8c9409e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|1800799021|82310400023|36860700010|7416011|376011;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VlNTT21RaTltdmhwa1VMRU9WZW9BRnd6RTE3VmdKQjc3MkNHQVRQM01QRTg0?=
 =?utf-8?B?bkdvdkpvdG1sWElmNzQ1MUdvZzlQL3kzcG1FendJYmcrUndZdDc2aTVEMWd0?=
 =?utf-8?B?UTJZMmhXZzBaUFk4YTNzZ3dSWmVjQkdjRWMzeE5YZ3YwS01WRUNkQWU1QmVx?=
 =?utf-8?B?NU5yTWVLOTJsb3V2cUYzK1M5OVhtZ3J0dFhGbWNPRnR0R3pGS080YnhGU0RF?=
 =?utf-8?B?aFo5SGFsZ2ZSQUtwMDg2RkY0bDFTM0lSVW1Ld3ZmUEhWVXJBUWtsQkZKZVBN?=
 =?utf-8?B?bzFIcUUzVUNNdU1lLzhaa25MNXNlWWp0UVV2RWxpVE12REw1R1dXTHBteW9X?=
 =?utf-8?B?bEtpaWQrTi9PQlVIVEJkSjllQmRZci8rOGxuNkMxU3FnczJ5bW5KNnFnbVlG?=
 =?utf-8?B?aEhtUWJJdXNPYnBZQmVwL3R4bGVubDhMVkwyT1pjVGw2WGpEZzBHQ2RFSXp1?=
 =?utf-8?B?c2pvSDhTTXhkS2RXR0ZMVTNHeDc3ME82NktjeWkwVnZuZVZ1R1FuZEYzZ3BG?=
 =?utf-8?B?Zkw5U3pZb1RSQ2VNMW8zSlF5cjc0emRRd0xXZm9IV2wrWFBnaTlKYzlWSlQy?=
 =?utf-8?B?azhveDVyT0RsM2EyOXNRaXJZRTJzT1FyNFA1NjhlaXpiQVVDdmdXQi92RXow?=
 =?utf-8?B?UG1HS0hOem0wZ2c5UEdFLzNhQzM2YU5KN2xLRVlERHhaU1V1SWdxcXE5TWNR?=
 =?utf-8?B?cmV1SkIwVVEyWlQrZWUzWk5jcll6R3BuQS9DVmtnR1VvUkFwYW5rT3dUUlBV?=
 =?utf-8?B?TGpzVU0xTG01Y0ppaG9BM29QMWhqRklmMFN3bUl0WU1zVnRoQ2FqVTFIMkR6?=
 =?utf-8?B?Qy9ldWZDclo3RitxVE8vd29BelV3RG9VcXU1b2J1Q25GL1Bya1dzZnRrU0Vq?=
 =?utf-8?B?SEE0dG1aVkZwRkJJWkdWOE95VXY3Z0VXZkUxb0pjbWRRU1pjUzNkY1F4VnlP?=
 =?utf-8?B?cU5hV2o5REE1YjFQKzNmeWk1L2hTU29kQkIyY0wxOE1kbkJYNEkxL0ZBNVlB?=
 =?utf-8?B?Ulg0YSt1blZCdFlSRzVmb3NtMWhEUGt5Z0lFQUVjZjVOcXFoUnVCRXlRUTBO?=
 =?utf-8?B?MEJxbDJnNnJvS1RYbzUyK0lnN09zRmRIMmJZcmlqUEFYTjBuNkttbWlGOG1o?=
 =?utf-8?B?aW1aczQwS2RULzhJb2g4djlaSDdYZVRhSUo2WHVDYXc1YWRhT0EwWFh5SUdu?=
 =?utf-8?B?bmEwV2tEV1N0cFR2YlVoQmZicW1ldDRCODlsSEszQVJjUXRUODFURGx2VllM?=
 =?utf-8?B?eEdWY3ZST3BwdG80SFIvT3c1Wi9tbzl0ZjRoaFh5QTVCRWpFaTgyOEU2UExk?=
 =?utf-8?B?NHVHR3grOFcxMnJhNEN4QmZ6WDFTR0Jka2pDQWY3OVErUWhoUUR6aDcrZE5G?=
 =?utf-8?B?M21ueG56c1I4Rk9hWVliekpRQnZoMEtKME40b29xdkcxeWd1VjZJRldZRlox?=
 =?utf-8?B?cjV1aFA2WVR6QXZmb1ZybmxKRFF3RjN3bld6c3Z3OGwyL2dYQWpza1Q0b2Va?=
 =?utf-8?B?Tlowb1NOR3NJZCtEbFdJNG8xSi8rTWVGcG5KVzJON2JhNmtrbVcwOG1aVjQ1?=
 =?utf-8?B?MVl0dHl6am90ZXdLc2RFMXZ0TXMvZHdCQXJOeTZYN2ZiUnR2ancvUE5URUt4?=
 =?utf-8?B?Qm9BSnY1RFlCakFUdkVJZmdMUEl0WHBTNlJiMUNKQUFhR0ZTKzJPbW8zVU9t?=
 =?utf-8?B?bG00TlBjWWlFNUhvMEdXWXA1cFpnMVVPdzFUZ2NDWTNucGptTzlxZlJmS08w?=
 =?utf-8?B?QUVjcDZGeUxOUVNhWkI3TGhEaU1lRG1ROVMyL1VvbEgwL0J4Y2RnOTlhWGRv?=
 =?utf-8?B?cU9JR1AzS3lBenRSS254dUQ5ZWdZSDBxU2pVVW1HZkU1NlJiV0Q4Mkxsb21N?=
 =?utf-8?B?MGpKQks3Y3A5TUx5SmJMYWY5WjRNdlB6L1NQWml2MHlOV0E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230037)(1800799021)(82310400023)(36860700010)(7416011)(376011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2024 17:04:22.6668
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 55cd334f-8aea-49f4-8f1a-08dc8c9409e5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004686.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7840

On Thu, 13 Jun 2024 13:30:18 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.219 release.
> There are 317 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.219-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.10:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    68 tests:	68 pass, 0 fail

Linux version:	5.10.219-rc1-g853b71b570fb
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

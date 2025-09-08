Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2089.outbound.protection.outlook.com [40.107.94.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CF2306B34
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 15:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757343749; cv=fail; b=Rl5y42/KcEo+rWFNcwMKyDL/A2cCuz1WeTBqLsUNHgD22fI81UYGOX0cLX90GITO1wf5gwcCmBMRKXpu/23qweQKatewYRRuSAPi+ftVfZHzR4PSLDsprpP2ACbi6mzG4s9+LNSQf38cAC10ehUNPdv6Tg+G35x24lbzOufd8v0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757343749; c=relaxed/simple;
	bh=v1QjsLi/S3hMjuvJAGF19KjHFkwYm79BBw4yvl+vRWg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=boSzAaBk6DV40150taf2zW5ELiRoONTClYnNy8dMI5sw8+KpCu82N+qAzs8BL8poJOzQX2kXV4d738T0oYXx8VDHJm/mVaKz+eaJ+tRes7msqoQFmKp+DHIUyhjP+b7xtl3wsGPjMVKJQRkvg4prbwJKokAuCx3e6Wv+/xi92L4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DgoA/R49; arc=fail smtp.client-ip=40.107.94.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DgoA/R49"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DA69N8IelAoZgG2lVl/kLC/yZqtIXZFrceu9bi3ud158EDEZn5sS+RVTyN39N7R8od1e8WP/Yp7PpykB9Xl0KcSntExSHmsXybfAsL1G+1pp7uZfhkt6Ed6JH+h5ZjLpZZ94gpuV1clQVuzn5LT3Pl4VJTzubQbfAas/8dzwZ1kTcJmBU4M4RL8c8xu3dahxBpwqmiV9HBQXc6GW9CvTRU3mdT2yqUClHvC8FsjyBMWYDDTAhxYXUlvyjPnFJcZZprpq5Gn5LULCg8/POHFohJvKSeqeqp98CpUnNXEnMWpMaU6qwtYpjs6tGY70ky33rj0qorxymBSAcsZ8JhK2NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BIAcnPmn+Dh/nsUfRZv9L2fAbd+gtiHJdBzSZS4WZlw=;
 b=nMA7UETDetIe73cbGTOefG3R21q8cQqP+2B0iWXS09Au7zdCP5TbePk8egVMmRc7bqxpnIpsRrKmRe+nJdHZtE1wFLMTmbHS+M/PsK7paqfYCpxmdV1RKZZR1QT5/445A0OIPGx1JJlKOAlK2/L+nssC11UNNwW3U8t20kZ+qUKAUGUOogIc2a8RnHmRoI0f/CvPmEeIzXYx8389hr6yFOMHVI/fcglSgaiJ/KpLJblBXccWjcYJ4MXmpumO76WOvFD2mDmKkTeMSQh2FBSnH4PbqIMTd3FtAvAY0u9EEtptQ4//LQ1o4njVff3VBeuheQ01vodjMONnpfWl4R+Bgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=temperror action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BIAcnPmn+Dh/nsUfRZv9L2fAbd+gtiHJdBzSZS4WZlw=;
 b=DgoA/R49MOpYbvf9ENKdjDtGd7elMQ9Ve9MddF4Zmd1A5xQi3TlTDEUC0dGi+l/tWelYaGoRKhNwJINgVyxcGPU2zMVRqPADDY/Cn4ekYf8uf2ob0x4dDghEmwMuDqvZJaCTu2falhecClfS8opbtBPrLiSAbfdTRVK28EIYvS7J/+wQ8VGoPJ4mx1jqiE5do/m2KaZbvnJiUQ8DJ7C2JFMLbNKygEAkgYUmuhvvzO39oW87Q30V1+NuF8NogaSaPVH7jEErCBj8+lvSZTO3d5bt3FwPaoyzgxo9pMegT5ThzmhrxuJKHvQ9CKBcthueeyf+EWjszl3ETFNYrYkeOQ==
Received: from SA1P222CA0197.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c4::6)
 by DS0PR12MB8416.namprd12.prod.outlook.com (2603:10b6:8:ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 15:02:21 +0000
Received: from SN1PEPF00026369.namprd02.prod.outlook.com
 (2603:10b6:806:3c4:cafe::4a) by SA1P222CA0197.outlook.office365.com
 (2603:10b6:806:3c4::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.22 via Frontend Transport; Mon,
 8 Sep 2025 15:02:21 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=nvidia.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of nvidia.com: DNS Timeout)
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF00026369.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 15:02:20 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 08:01:52 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 08:01:50 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 8 Sep 2025 08:01:50 -0700
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
Subject: Re: [PATCH 6.6 000/121] 6.6.105-rc1 review
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <eb90de01-bf91-46fb-ad7f-ffcbc542c431@rnnvmail204.nvidia.com>
Date: Mon, 8 Sep 2025 08:01:50 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026369:EE_|DS0PR12MB8416:EE_
X-MS-Office365-Filtering-Correlation-Id: bddee1a4-72af-4b1c-c01b-08ddeee8b5b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MkExdndQTnhxSk51WFY3YmIvVXF4dFZiV3pPdVU0NU5WSEVLRDhwRG8wSFdr?=
 =?utf-8?B?ZTdmdkRpUXBxTGdJQXQxQ2pPdDVTVGV6OVVWbnlpUENQNUI4dmF2bUpvQXZa?=
 =?utf-8?B?YVQwdHJpQTh3cXpua0M2S2lIalNRYVZtaUc4RjI0cFRDeUtVaHU0aWJSZjRn?=
 =?utf-8?B?ejdFbFVVSnJmY0E1Wmx0QWMwRnlzM2dXZm1XYmg3NGFXUlpBeWtFVG9OR0hh?=
 =?utf-8?B?bHh4R0FIczdta1ozOFlMOU5hUDdodXJ1eVVwallIdmMxdXpLWlR4U3p6ZmRN?=
 =?utf-8?B?SEl5QkEvUGlJRXRjbnlsSzl0bkFJbkhzRVFSWGMvUGdPb1dqOXdjOW1OU0xn?=
 =?utf-8?B?REJ2MTZCN21PL0dKSzNKSmxBRnFFa05CNmVmWHZRUDh0U2xGSnBlb1J4Mk94?=
 =?utf-8?B?bUIyYTZHc3lJa1JHSElKemErOTVzWU9CazVIUWJmdjRReTNUY09ZMTkyNFpU?=
 =?utf-8?B?MGRHY2FZTTI4KzRyYTR1MGpWL3FzdngrcGllNFdyTHQxNFExbjl6eGEvZ0Ft?=
 =?utf-8?B?T2hjV3M3SXJRN0tZdmxkMDBDMVltRXlTWUhNNnE2T0d1Y2plYnplMklFaTZI?=
 =?utf-8?B?UkN2RTgzOU5XQWg1cENrcW5CVlNFYmk2ZlpIVlpqNHZ4OFJlMDByUm1mWndR?=
 =?utf-8?B?TkNsQU5kMTRZLzlBdDA2MG5HSTlWcHpyRjlWRHFrQjVETnIwS0lSY2g1RXZp?=
 =?utf-8?B?WlpGUm1BcjI1emNUeXRpYlVDRkRzNUpNeDY0cWpzMkREeHA3blNuR1ptdFF5?=
 =?utf-8?B?TDJlR2xsNmsvWEtLS1RKQ3hQYU1yZnNDb0lrelhQWjVTZ1YxNTllS3FDRWM2?=
 =?utf-8?B?OVhIR2ZKY2NwY01aYWhiRGM3cms3RUQ3MXNSODZPc3EwZjZpZFN4ekxuUGxB?=
 =?utf-8?B?dkRxcForNlVnaHJibnBPMzI1dUppVHZ4dnFyZ3VXU054Sm55WDRRUmFtOURh?=
 =?utf-8?B?VFBVeWJZbVlreVlzVU02dkcrbnBYMWJOaytsS1h3TlByRnZJSjZBZjN2OGU2?=
 =?utf-8?B?OWprRmVURkNFL01Ib2cvZHBBVnZiTTB1SUt5MWVONzdJZWhpUUxVL2FlOXR2?=
 =?utf-8?B?ZEozRGFpbVhnNWhnSy95YVExYzBkQmlZZjBOdlZtR3VnODlHaUxpMHhUc1NI?=
 =?utf-8?B?UDZMYmVsUXZIVzVnZ1p6S2ZwYWx5T2k2OE9Od2thdVNlTlZLcXVzU0VONE4z?=
 =?utf-8?B?Vk5xbGxpMUIxSEd6c2pVazhMaUZxaHNyWmZqNlR3SzI0T0JRRHV3TjlRWTht?=
 =?utf-8?B?bU0rcG5lVDVNU0ZueWxxbm9zdWRneWw0ZlA4STVIYlk4VmFWOUd5WjJjU015?=
 =?utf-8?B?TVNsSGVOQm96OGJwMHlMT1hGWmxhaTlZaDg4VjJXcWxDS1dnQVZpNjl5V3BG?=
 =?utf-8?B?aHRzcWMzTWxIWm1EdVhlSDVQWm9yM2t2YXJCcUREUmJsN1hzd2t1SnZhRFJV?=
 =?utf-8?B?NnpZVWYrQ3NxT3RqNnlnNFV2c1JYcnJQaGZBcEZKT3E2Sk9PYk9GSmx2V2JY?=
 =?utf-8?B?bi84QVN2VTRDZldrZmwrNExpRWc5c2RYa1ROdEpObDZlVS95dEQ4K0o2WC90?=
 =?utf-8?B?REw1bU5Dc1hqRkluQXIzM2xBRFJpS0tzY2p1S1lCV3Q3ZTZYUjBNN1ZDbnhI?=
 =?utf-8?B?SHpXOGdZK1FMbzhMK25rbzdneDhtakNnOVNQaWNPWGQ2OFBTTmF3a3hPQm1p?=
 =?utf-8?B?cGkxcTZPS3ZJdTJwQ1dPcUJGKzNMU3BCL1VSRmwxMlFhUmdkeXcyUjVwSkls?=
 =?utf-8?B?VXB3alQzaVM0Sm1xZlh4VWVlTjJWQk9XRS85RXBpZGxtR2VKcm9GaUYyK1pR?=
 =?utf-8?B?c3dyYlc5a1Z4VTludWFvYndzZU5yRHdhRHk5bEZ6Qk5kYTl5bG5hdm9DOEh4?=
 =?utf-8?B?Q1F3ZTFWR3cvTkZFNXp2L0tONGVSQU5welZBTWRRYVd4MmJ6ZVl2NnM4dHd5?=
 =?utf-8?B?WjZXWDhvbTdJa1c1UUF6T2Nkd1llMFQxZDlmU0o2Qng3ak9pUnlGcFhWaHdv?=
 =?utf-8?B?T1M0RDdjWDFiQlg1Q1ZXYkIyZ0tSN29JcTFGYzBkUklrR2VlWUpuSDNTZXFB?=
 =?utf-8?B?NXpXTGFCN25yN1EwazBRZTU2WStzSE9wUklwUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 15:02:20.1991
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bddee1a4-72af-4b1c-c01b-08ddeee8b5b2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026369.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8416

On Sun, 07 Sep 2025 21:57:16 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.105 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.105-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Failures detected for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	111 pass, 9 fail

Linux version:	6.6.105-rc1-g235604b18bff
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Test failures:	tegra186-p2771-0000: cpu-hotplug
                tegra186-p2771-0000: pm-system-suspend.sh
                tegra194-p2972-0000: pm-system-suspend.sh
                tegra210-p2371-2180: cpu-hotplug
                tegra210-p2371-2180: pm-system-suspend.sh
                tegra210-p3450-0000: cpu-hotplug


Jon

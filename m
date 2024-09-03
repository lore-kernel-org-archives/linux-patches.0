Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5ED61C7675
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 08:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725353093; cv=fail; b=GObPC7GpT9HKLn9PaM37hmSwV/tOzVIxdfSpAHsWAsWqXVH0nQrqDAzuHrSmxH0YrYI8fR6YX7BIo3IklXTK4ubkyXIfoAC+VrIZuuQHOyPYVWorAYIgzLVAP38heup/raj8ExlgQAXoguO5sa1P9mm9RpSVgQG7OjjfRUfNdO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725353093; c=relaxed/simple;
	bh=5U0asvKSHDN9G+nvOZFx2ur7tpLtFn8UYB7tVytMWsQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=aAVd5xoidAaeY+FWqbqNxay9GfK+uiDQVIJiqQeF7rZDO7WI4bZwgfXRopwHQmKcoVnu/Ttr56BgecW5mwPu+Q9L9cTG2XNnchbvPPhnLxK+E1DzBPZrEBlyxjzhYBZM4/HjIlrCUA9Jsg0cDMJV1hUg4FUUK9oWkfZGtOuoSbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M6hISJue; arc=fail smtp.client-ip=40.107.243.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M6hISJue"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cwX0DLiqF3fHPjvrCeDksdgnuQDfo4Hk0fTUyXecTrwPG8pDobQ2ftddvu9mvsKA6o/L9FiGuQYPiNuJ/FExw1zP9eG3wDEcT3T0vOlB+fllMDJfPlZt58WRRupGxyhDKAZWgidMWE0qobktdCl24KNtrEssxC2s0DPw9yxMEVG3cspAQt6WTkwoM18ko2q9ajvEsh2FLAhgTasI+hlaJkjPQJEq6bFwU2LJqfGSpCofv43VhwkvKpbUPU5LzOiS4EolKv6V4iXQSL9joYtF1ZnfLCtqCI/pb3t/SwF7pV7ZJWfdUv/i1oMXIchinPmJ6ezDYQteAAx9AooskuiN3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C2APEfJ6VPy9GzQsVDfnsuB6hQzpNqes0R0YlV9av2w=;
 b=wi7LvAfON7LC8QoV19qQdmgjlk1caySvUNiBtHA8PY5VDkeoNl5SWuRUKTHeXl47g+6n10QLere5msBzZXAZYSpxmZY+C4EweBmt5gupCn0psu1i+bfwu9kVH9OPs2FveucSGDsVq7xdXK6xDQj3P+gHd4Zl4VWwUIOzlV8khXa9bh36ajNgd+CFNkP4O9WGocVw8Df0n5LXDEtCazkFAaVQ1q+TFkUkNV4ZN61kgOgtqG7iO4tliCDknHtVHpvtyAHxDvzAJbsINzuv2idA4e7LAbup6mioFlCOw/i8tuDgMqhqxd7/eRqNiNFWY/fXvczpQGGLR+EZhMc2/tHxYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C2APEfJ6VPy9GzQsVDfnsuB6hQzpNqes0R0YlV9av2w=;
 b=M6hISJueR2tJV50CtgVv7Ud+T40zUkw2q5lqg9JvX5oukLdUYMNABNHNDYACXCVaiGkg1kEzbyC/kt77Ubj5gy9zEgfi5weBq60aoJ2YtpYCubQALqMDkWPChbwAkDYG4B/xnI6mHLlX5o9bISukPMsRfQ9ccoNQBcjmVhzq3LBcWr1aupfTR2rX1zux9uMRORT73uBb/62IxM+P6Zdk1ukIuZyOWuu7Aw0cdp7Mp6yFLWrL2gmBLnfne3t+UbDj85dlVdYjcTAErmD4TapWep8pW61YvmW6FHLkJoDbK6V1eOCR7sVjXbtishiSSQd6xau8CeL6H0v+sDwff8zUZw==
Received: from PH0P220CA0007.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:d3::31)
 by CYYPR12MB8655.namprd12.prod.outlook.com (2603:10b6:930:c4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.22; Tue, 3 Sep
 2024 08:44:47 +0000
Received: from CY4PEPF0000EDD1.namprd03.prod.outlook.com
 (2603:10b6:510:d3:cafe::b1) by PH0P220CA0007.outlook.office365.com
 (2603:10b6:510:d3::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27 via Frontend
 Transport; Tue, 3 Sep 2024 08:44:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EDD1.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Tue, 3 Sep 2024 08:44:47 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 3 Sep 2024
 01:44:31 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 3 Sep 2024
 01:44:30 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 3 Sep 2024 01:44:30 -0700
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
Subject: Re: [PATCH 5.15 000/215] 5.15.166-rc1 review
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f4f9d16d-87e2-4b64-bd62-2abcf75c7df2@rnnvmail203.nvidia.com>
Date: Tue, 3 Sep 2024 01:44:30 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD1:EE_|CYYPR12MB8655:EE_
X-MS-Office365-Filtering-Correlation-Id: 73308db6-7de0-48b1-08bf-08dccbf4aaa9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SGwyeFAwZjJhTk5oT1RLKzJNU2QyK0JibWpjOEhBd3JBdVdJZFhTTUtkMlFo?=
 =?utf-8?B?QTNSRFpya1IvV1A0ZXVEUlNPKzJMS2M4Rm5vdUh5RlFGOThGa0pJKzZucExP?=
 =?utf-8?B?clMvL0Vma0tBaUEyR1pmUkIycjdjZzFGM0xFU3piSmJaTUtlM2FYL1UvZ3Zh?=
 =?utf-8?B?cVArMUVVem80N2F5dTFOMENXU1A4bTg0WFp3MTM1NGRvVDcvay90YVA5a3Qv?=
 =?utf-8?B?NG5nVlY0Y3hIVU1XZVd6SnN0d3JXc0prWXVnUzFGa3hnQVJLdUR1R0FjSi9T?=
 =?utf-8?B?dEMwbWZMVWw5eWVTV2JjL2pKbWVYa3pUcUdaTkdZblRRSU1Hd1hFWjczNENq?=
 =?utf-8?B?RU1qZUFBdVQ1dk5qRG5DYmxaSGUzWGtHWlFZSnZxdjU4aUpFUWlTUG5Gcm1p?=
 =?utf-8?B?TU44STFDSTAwOEpHUVV1T0ZCTVBGWjk2WFJoYlRmU2xFQW11bkdRd09Fc28w?=
 =?utf-8?B?VGxHZzJDSFNtRk93VEdWZDJyakhDRFhaeU4xU09TRTFROHpYR0poWGtSSlUy?=
 =?utf-8?B?MnQ0MTVEQy9YN0ZEbHFTQXVqaUhNYnNXNDFNbFk5R2NZY3R2YTd5elYrK2Za?=
 =?utf-8?B?Y2FCSjVEMlUwUmdWM1MzNEZORURhN3FCVDFKQU5VbHRpR2VEeklYNXljZkxy?=
 =?utf-8?B?eHQ4dWU4ZG1KcHJyVDZlM3hrb0lUZDJrcmN0a1FiZndqWE5pQVNUWEJDT2JJ?=
 =?utf-8?B?dE1YSTJ2TGVmM09neFN2U3RVbFB0TGhNSUQ0NDBndU1uOHAyeUNLUUQvMi9r?=
 =?utf-8?B?dU1MTW1XdVJBZDJqejhRUm5RVkoxVE8zck8ya2RMeFZSTWl2T3UyK1ljRUR2?=
 =?utf-8?B?SEgzQjVtZ3BHNGNlNUlaeGlxQU14bU5uZGJoZmh2MUgzajcvZHRxMDVNVzRj?=
 =?utf-8?B?Ny8vdjk1TlNVV2I5alVMWjBrbER2VHBGYzlTOGUvaDVzTkpGRWZqZFZGVnZ1?=
 =?utf-8?B?cDFkYXBUMHI3bW1HQ1RqNjRXVjg0bHJvYmtjbEt0Rng1VklWbTl0UGxrK09F?=
 =?utf-8?B?bS9Gb01wSW1MdlcyV05XelIxNzRXZGZ0dHgwOTBKWC8rVW9hQUI5UjFZWEQv?=
 =?utf-8?B?ZVpFT0owVHFTdEwvTTRVVnhlL245NXNoTC9qQ29IR2FhdC8wdVZhV0ZmbnJD?=
 =?utf-8?B?dmlDRWErWnNCRWRHbEVOZ2hkWmZ1QkNkSUpRTUtua3hOaWhRQ3lFYTY5QmxI?=
 =?utf-8?B?aFF6WHF5WHBMVlpPS1dMdGs2UWVEcTRGMDhjcUs1RVZBRzZTZmpsNTVKdlEx?=
 =?utf-8?B?RFZBZXZwZEk0QTJHK2FDMUp0djBtVTBVaTNSbjRSTlpxRGtGQ3VLUHYwWlBZ?=
 =?utf-8?B?djRyelBJN0JaWGQwNHlYelhHS3VNRmtpeGNrbWU1aFNOd0JoSEdqam1uOCtV?=
 =?utf-8?B?ajMxMFkzS1pUK2NIMnN6R1BiajI5aUtDN0U3ZEF1R0JOM0Z5Uy9WOGI2dHgr?=
 =?utf-8?B?TkN0L2QzY203YVN4OWdaVzNYNlU5NkhkbUJ6aTE5QThJQkNPNjA5NEpFYjdS?=
 =?utf-8?B?U1BBZDhiK2x0UUNTMEQ3Unc4TTFEUk1tTjVVbjMwZHdRZ2UzeGMvcmpXYzY5?=
 =?utf-8?B?SFNmY1RDanFGZ0t3SlIyL3k2T0tHditoaCs3UVdVd2U2dVJmNVZGNlU0V2du?=
 =?utf-8?B?WUR2TTRrRU95c3FRbk03dTZSYXhpbUpXRFRwWDFXbThPZTBmNXpmRzV6cjla?=
 =?utf-8?B?MkZaSS9LYkN3eEUzNjV4MTVJWWNqMk9OZWNsODNBdCtlWEJZbmZVU0NsZktN?=
 =?utf-8?B?SHRONGliRkVTZmEvZVRhbGNDOGM0MkMrZm0rMmxJK2k2bXhneVduY3FSclN2?=
 =?utf-8?B?eXhMaDB6OWlmZTRqVUJ2VEE1bEdEQUQwYkV2eUEzY1RzUmpmY0hmZjViM2NN?=
 =?utf-8?B?SFFPVytwUStZOE40UUpHcWJWdVl5d0dHbFg3eTlKdlhRTWVyRHZ3aCsvamhz?=
 =?utf-8?Q?yqgEchtu1bVZePzEsZ9Da2osFq/Y1ais?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 08:44:47.4024
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 73308db6-7de0-48b1-08bf-08dccbf4aaa9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8655

On Sun, 01 Sep 2024 18:15:12 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.166 release.
> There are 215 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.166-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    101 tests:	101 pass, 0 fail

Linux version:	5.15.166-rc1-g36422b23d6d0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

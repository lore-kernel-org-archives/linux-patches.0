Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71BF2D5C73
	for <patches@lists.linux.dev>; Wed, 30 Jul 2025 14:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753884588; cv=fail; b=nUed9UzOzJ7k7FWCT17GHkvHpOUWj8pXgizUIwtP5OrHmLXOlENcH85jyEqxe/Vc0AUsrmzACtNkstoVpzsHg3TC5R40dQTo1OIlGtQY7T79K/g5BHrnpnDfjsduHkv0xXrnT9tBed1ca33ETd6gNfsEu6t7mxeLIbKqGdTZqgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753884588; c=relaxed/simple;
	bh=xM8OvMw+pbqrclaxvNInt9jxqnC4qE7xuep+RCqiW/Q=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=TTXLqPbndb8Y7ouunFEZrI2KBxhWRlAZcaC090XPy9mQ/rvHsuXdvabvou2BDrB/kFEn5fhcjeBpyiUsjjD2ucLXbVu0tLtg5nYbmR4RsoYafKJqaDrCxS9sSVLJQfhB25YIB3/DM0VahbeSY5kNzm1z18yTk9nkL/1wudVWiZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dvZlVMC5; arc=fail smtp.client-ip=40.107.92.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dvZlVMC5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TJHopkSQWY4a7Zbf4Jb2Te58pCO0kzWqn7iUeboWFMTTbwRWB4taNXB+y3/fRrdbRrYX+MQyM0UfWeVnNbuI/nlGjDoIlcuobxdUnQLbzkSx8rZeOPeOMrQN5JWvZEs0OLxdG5MX9HM0zHej4fRAJc90zYxe9oBXWbHSLi3aYL8GC/rBF/Nn379UCgYuk7k16Sr/OS3Pv7JtDe3mUxrORDA6/PoQFjqyJMgy9xqkBtNwljx8u2mqJjUclB21zLNsNpJy0/54sKji7ljROl5M3td3UcLJH5m8AF591mF7szFYPnyf26A0o2DivSQ0x+1SuSQ8PLz4nTDIw1Ub078QqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yf6M5tbHS+gppiq8q2KzFysDmcsSMuT2hGxnnqOM4+Y=;
 b=PD9J8r0i8qpi7tXUQFReTMxIWljjK/mpbID9AHi3sG2pqeck/HbwX1RRyS092e1y/qIjLnKLPqFyRG1Yr7A1jkNDRevRAkYhljsWC8INDwI32f6zbxI5vqY3TnzSBslOahD8Z7++kWFGIqj9jmQtrxqTRkdAshCjVHcky0XknqtaQflLoIWkAnAQoo1IHAWgA6GA4K0JxQvjBjPoyOnIHmS5FvWtzuQELss1vHpFeNP5WIaY7T7xrc57DxvuZrqQIoY/0b+DfgaRInESC8JUEqV0nrFTzZHSN6HCBAaGHebgP0qhZIQOi8pPXMH1EwYVq87MBCqr7czBL4+ieWlFcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yf6M5tbHS+gppiq8q2KzFysDmcsSMuT2hGxnnqOM4+Y=;
 b=dvZlVMC5AqlkKtDO0Y1flDUTMLVN17cor+JmRKSmHwXu911CbfRffnWQOi7Eh8mfW17eY/TbafDYZXM17MjVNJtuyBhDdD77dnHKP6IJBD+jrObLYWCBNo2np6L/7wbfErdNltBYrNa+UaNk3u9i92OibRYYyCmva/1i86QoO4atmFkAFRwqY9ZKLmVUy6H7yFJyxlTiL80vnn+ohj4UusK0/VSluPzOOtafr+dgxPluNPI2bihxrgvDyzEkdiKnyVB+W7gT4kEIvQ6HdxF5q0U7wvj2+2MmAtK/1epMZp3kWB/JgpHNHcma7TQrtStBKyIkZy6dhVOf7dXULDmZhQ==
Received: from CH0PR08CA0019.namprd08.prod.outlook.com (2603:10b6:610:33::24)
 by PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Wed, 30 Jul
 2025 14:09:42 +0000
Received: from CH3PEPF0000000E.namprd04.prod.outlook.com
 (2603:10b6:610:33:cafe::b) by CH0PR08CA0019.outlook.office365.com
 (2603:10b6:610:33::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.12 via Frontend Transport; Wed,
 30 Jul 2025 14:09:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH3PEPF0000000E.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.10 via Frontend Transport; Wed, 30 Jul 2025 14:09:42 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 30 Jul
 2025 07:09:23 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 30 Jul 2025 07:09:23 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 30 Jul 2025 07:09:23 -0700
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
Subject: Re: [PATCH 6.12 000/117] 6.12.41-rc1 review
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <8998052c-d33f-41e9-8e63-24c29f8902cd@drhqmail201.nvidia.com>
Date: Wed, 30 Jul 2025 07:09:23 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000E:EE_|PH7PR12MB5757:EE_
X-MS-Office365-Filtering-Correlation-Id: 2351fb77-923b-4131-abe8-08ddcf72bae1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V3FzQjg4cXlzYldSNWJqdDJxY29JOG1UanFIeUZlOWxIb0haOGwyaU9OWGUv?=
 =?utf-8?B?MDZIMjZRZzR5enJENjA3OGhoeXZvNFZhVnU1Ryt6UCtwTElnK3Fha3FxcFh2?=
 =?utf-8?B?SFZ5d3V0WVVSWkljUjhIZUVLYmZaQ0pzN2N5bHMzMEtQQzJkTTY5anJ2VTc0?=
 =?utf-8?B?L3VBNnpaV3dRRmtRNkNUejJFZ20rL25JYXo5RkRlV0V2aTZVVFNvK0xZUG9i?=
 =?utf-8?B?K2tLbkZ0SGI2d3hVd3FJQzllZ0JpSkhaUytYNWFuQ29PMmQvcnRvWWdkd2Fs?=
 =?utf-8?B?NnVmajdPTEd1dnZKZDZ6S2Z3M2ZTMHBSUmhOdHEzUzg5WHUxZXRiMXZ5SVhy?=
 =?utf-8?B?Ky95Z2JwWTFNSEpZUTBFRG1FelRmM2U3ZTFFMTZ6MVpLV0FLbktlZ0MyZnRU?=
 =?utf-8?B?SEtwT0NYT2xKVmM5U3cxZUR6eXY3czZLQlRXSjROcDluNU9PZGxuekpPSmFT?=
 =?utf-8?B?NXRXNnZEVGE3Z2FMSVYrWmw1c01PRC9BMFBmQkwxTzZmTUhad1pCTVRLNWUw?=
 =?utf-8?B?aGJhVzMyZDNXMWlzVFNIdnZPM0hrdTdGQUdBVnFENmpydVdmdDE2RGRwNVlN?=
 =?utf-8?B?azl3YXFzcnhla1o4MnFla25ZWU80MnB4REtjL1drMjJWZ1hOR0xxbmgyb0VQ?=
 =?utf-8?B?Lyt3dkJQV0p2R1p3RlVXY2RRYVdRNGFtTThtSi84Y0FXK25GdEhxNTV0aVVG?=
 =?utf-8?B?Qk00YTkvZDk0d01Nb2wxbjdnVVRKTXhBVHhUdkxjL2pNckpJeFU2TkluOWNS?=
 =?utf-8?B?UGZ5d2ZwZ09xRzVsZW9hOTk3L0FFUUhrRExBbUgzOUxlb25nUWxka2RLOHp2?=
 =?utf-8?B?S0FSbmdXNlYycW1wWmVhWFNnQlc3Z2ZLRXhoSk02STgvT3FsNGpEdk05ZEFF?=
 =?utf-8?B?ZCtWdU1sL1RxdDczK3N1ZGw2QStmNXZPbkJRRzJxNUpleFh0TW5lNDJjbkoz?=
 =?utf-8?B?Vjdza1IxbUQxWVpqNnRpK0hUa3RudXRJdFdhYWpxcHFzTUtwczJWOVFkcito?=
 =?utf-8?B?dWFMOHByVHhkWEVUSUFKTEtOYVROcUVadjQvMUY2UUtyZEFhQ1A3S3gvUHE5?=
 =?utf-8?B?Zys4R2lybVRuaExhS0VKMUFRRGMvU0RZYVNTdkdlcnJNSlV6dThCTW9CLzBq?=
 =?utf-8?B?MjBDQjl5WGdMS3hyMStaZXVmSFV5U05jREdkbnBIeGRnbGJGK1VZQ2RKVEw5?=
 =?utf-8?B?cnl6WDBFQ3lTRzFScDA2M1A2RWYzMUN1clowYkNrYkJSaU5UQUh2bjVLY1Mv?=
 =?utf-8?B?d1VWOTY3Vkt3bG1helcydVNkbW5jb01nRHR3dFVNV2RKWHlkVDFJWVJqZUtV?=
 =?utf-8?B?cnhNdks3VFdRUmI4eEl6VHA5Wk85dTRuWE1wak5ZcG1HeXM5NzZ2VVdXR3ZD?=
 =?utf-8?B?ZVNJUUdMZGpSekVYWVMrZmQ1eFY2TjFqVXBEV3dBYjdYVXNQWnZ5MVVIaHNT?=
 =?utf-8?B?RXlnaHFEcUdpVlY0YXBUVzNRdVQwNWtmN3dyakVOdWczeEthL01YaDhqSVlG?=
 =?utf-8?B?SUllR1EreXNHWmh2bENleUl3Uk9Hc1RscTQyUGsvQkMxMXVDcHZoMUIveVZJ?=
 =?utf-8?B?TFM2SklaK1lpemt2SncwbWpQeW5zemZQWWJtNDRFSUlLYjlLMS9KMUdPR0d0?=
 =?utf-8?B?MmtHYlN4ZVNOaEI3Yi8vb3Fia2ZIMUoreXhTL3BYRGRoQ3hTZE5pYTArNktO?=
 =?utf-8?B?aHUwRk9lcjByREZxbjM5cXUrMEczMm5YdkF5ME5rNnNDdGduM1BhZnZBSkpa?=
 =?utf-8?B?RjIxd1ZVZ2l2MUVmUTdiRHkzREJjczdFSFJMWmQ4QUI0VzlVZVZ6SFI1ZXVH?=
 =?utf-8?B?ZDB1QzZJb2t5VVB0aGxabGJvMnVTclZWemJ4QStpTEFySnpFT0JmeGxZeTNW?=
 =?utf-8?B?UUFqSmJ5YkUyMW9NdTZ6UVY1M1dXTXRmODc4aG54KzBCb0RySG5KeU5PYTVQ?=
 =?utf-8?B?RXF1R1ZTZjhVNlNmOTdkUnBJQkRrb0tXSVpoblRsckN5cmt6UWJlUGFDaHBN?=
 =?utf-8?B?ZEdEK1VXamhwNGxxNW12NHNTQ0pnRFZ5dVlBVWdXMmNmYzRqME9yMW9qR2xD?=
 =?utf-8?B?b0NKQ0FQN0RrbWV0Ykx5Zi9XK2ovNHdZbVltQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 14:09:42.3673
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2351fb77-923b-4131-abe8-08ddcf72bae1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5757

On Wed, 30 Jul 2025 11:34:29 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.41 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.41-rc1.gz
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

Linux version:	6.12.41-rc1-g487cdbecb4dc
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

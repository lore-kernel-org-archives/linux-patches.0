Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEA020CCFA
	for <patches@lists.linux.dev>; Fri,  7 Mar 2025 09:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741340854; cv=fail; b=SMTPyKDZjjVI8Cx1R121Af0iOa7bJfHsZKE3ANBbajI5uX60t8A8/tg78vAX14gF+6EMXzWBgL76uvqXmvB+Q+37Og1x6auBaiWIZksF7VhPTm9vt9Quo3Bv7ssyNJNMpetUX8kUSz4SAVAYbUPfr6Ukgi2qmI5XWao6J6xtqis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741340854; c=relaxed/simple;
	bh=rP2BaeL5qW2NNzONu0S78IEVsIqCEBq5PassXhz5Dh0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=nDQfXoFVGEtDk3KGNQed9rkfxgfFPotxKANmBqVM4Tlvd3aN97XFfG95baUb7B+L+Wrog1nXNlRir7LzirUMSTc6HUUO91kbNvlSdADcfysckJ11rpWyvNniwDWgEbuz1aOZK6Kt6F6+U1vR6d+aO92R4b4XRjVLlXCgobx9aAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qOCaP6zs; arc=fail smtp.client-ip=40.107.237.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qOCaP6zs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EKRQd7bDk0no4p1uxMfdtDVMBLaWE1Sln2tnz2OcA0E2fNZjoyPi8jrMgqmlSEWOp9xCJsOALcTQl6JBP0/X6qnc/04IEaOOjo0FhNCUiZkKHNDSpKjvWAhocOLJg6EOSdqe2DdeIlSg/BqhbO3bclp9ctis1aT8n736bsy88YGQS8/3Avg0hRbGs5bVW7ampXOtn8I6s9LzifNhA5x7vKg4ALDIuaYYVyuTMM0+VU7V+t7LBzFOE+Tu769w2dgPnzVigJQs/9mQnhRNhTn3x24FYrjEFOTzGGuGWb+osTgKZoLmYfXh3iy12twQ6JiWzl3NahH+RE89w9WcGz/L1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=llnO6lyrk/pYlpq+cYyRDMUY/1zgCX+YKG5ruHw88Tc=;
 b=C+EVaCMt+WNunHx7gqsW8sTXzjO32EP/Zc3jgNmfWwSUGJXAA4Lb8UZHsNe/QptG35LG/hHfzwhUJm11LKTESVZ++ESk7aqBUWNyvqLo3THlVYiS3eeLDrwVYnEneLg3gH8QfgIJuzU/eeAkdVN/AAYWb8f/bjpcNkJIEUXDnqFUiDeVK/WUi7jiM94W0qvViiC67I8KSKKOR3xWw8mRU5rw7oTXdPGQGAzsK6TcuwHItBqH8mGif9o7GqnveX9ZQn5474b5R46eT9R2zGZAco54zdYSm/VTT2GuvK5NXYHPDA7k4+Qk1vb8pF3tGYSMJhyT40720XQwQSe91iy+ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=llnO6lyrk/pYlpq+cYyRDMUY/1zgCX+YKG5ruHw88Tc=;
 b=qOCaP6zs9feKyg8LE/07nVmPvtuvkDJjrXIRIxOPhrrG4QuL45PJC2yImmKiMuKs8bEwSt3tZImIHPr4u/MlPiBnrAYNf1Pmvq2WI/6KDmvlvZL/DVZY6THSyMako30IdZYW2TWRlPTqHXBMCV/iF64XrhYduLpKzrGULG2+d1gHv01X+cVUcVwV6dKZMSKoikN6HPc0Wk35LrVRn+ls2UDKWb3xyX84N4CjRe09IT4VD3Uk6tqGKeb9Wcg+60bYEuNsn3Bx/IIMArLeu5fG/CwxBHkVf4jqSs2hfqvz0g+4M/ymJL9aqGkTcjyoz/bJ9A6L5RnJHAiMfnPzgZBfKg==
Received: from CH2PR20CA0029.namprd20.prod.outlook.com (2603:10b6:610:58::39)
 by DM6PR12MB4042.namprd12.prod.outlook.com (2603:10b6:5:215::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.19; Fri, 7 Mar
 2025 09:47:29 +0000
Received: from CH1PEPF0000AD7E.namprd04.prod.outlook.com
 (2603:10b6:610:58:cafe::8b) by CH2PR20CA0029.outlook.office365.com
 (2603:10b6:610:58::39) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.19 via Frontend Transport; Fri,
 7 Mar 2025 09:47:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH1PEPF0000AD7E.mail.protection.outlook.com (10.167.244.87) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.15 via Frontend Transport; Fri, 7 Mar 2025 09:47:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 7 Mar 2025
 01:47:15 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 7 Mar
 2025 01:47:15 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 7 Mar 2025 01:47:15 -0800
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
Subject: Re: [PATCH 6.6 000/147] 6.6.81-rc2 review
In-Reply-To: <20250306151412.957725234@linuxfoundation.org>
References: <20250306151412.957725234@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <93216c0a-6e6a-4dda-885b-932f62cef7a1@rnnvmail204.nvidia.com>
Date: Fri, 7 Mar 2025 01:47:15 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7E:EE_|DM6PR12MB4042:EE_
X-MS-Office365-Filtering-Correlation-Id: 890ea6ae-bfc1-4df2-4dfd-08dd5d5d1360
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TjN6SEdvcmxkRUYrd3Mrc3c5T2JjT1J5dmp5L3BnT2RDakswZXdOSkdOVklj?=
 =?utf-8?B?d1BoaGlEMzlJdFd5WjBKNVBkbG5BU1FuZk5lTkNDTXZ4SSs0NXl1VHYraE9a?=
 =?utf-8?B?U05lZCtQZDU4T0pOYzIvWFF3QzZVenEyZXQ3ZHlYTDJmeFRqNU5LOUNYSXNn?=
 =?utf-8?B?S0dId0ZaeS84SU1ZaGlKUWx6Q0o3ZXgvMGFRaXFzYzl1OGYyRCtTOXVqV3lj?=
 =?utf-8?B?OEh1MWFwVmFzdzlRUTFYWnREMGJxRmhwVkZmSDE3RWp2Tm5PNUREZWJtYWZ2?=
 =?utf-8?B?L2kvOE5xRHJBbzBXVTZLN3RRS2RRRTNSd1pJUC9jOGZCV3ozclQxZmFER0pn?=
 =?utf-8?B?RVdpY000WXRmQURUSWtHemNpUHNVa3Z3TnZtS0Fvc0xUK296U2MwWitmeUxF?=
 =?utf-8?B?RHQ5alBoVld1bkZMZDlkUndLWHFNMG43ZmJlTkNBZndMb2VjaDJhREhRZ0Fm?=
 =?utf-8?B?THg5YmVnckozK2FNS1EvUVVDNW9HR2ZVMUpQN1kwSnhmdTFjekJvQkNKUzli?=
 =?utf-8?B?bWVXeXpHKzJRdjExSHBhNVJiVVdIYktQUi9CVythUUJ0YW8yWE9SL0VlRVhq?=
 =?utf-8?B?SkoySndwNTBVOXdmeE5QcDBxZDFoa2pOMUJIVHVxNnJBOTZoNDZVenpDSWQx?=
 =?utf-8?B?QWJCZWIwamRvanpENEtHY3JzZGtHaElUdUJSWm10ZktkZEd4S1NDQmduYTR6?=
 =?utf-8?B?U3R3cDlscmJHQUdZNEpVeGF4L0RDcSt5RTBPRlJpWDRqVmZhOWdTWVFEVm4y?=
 =?utf-8?B?MlpIM3hBMmwzQUFkKzB0RS8yUE5zM1BJb1NBb3UyWGpXWHRKb1JpQW9iVEZp?=
 =?utf-8?B?M0xGSm1GNDVUODFGQS9UWVkvSVBCOHJPS0k3K1dRa3hHZTdFRXFrVE8zWmtk?=
 =?utf-8?B?ejVZWjZuenJ6S1VyZGxJVnhpajJZM0FCamVKQVVma1czT2NzN2RrL3dZdHNX?=
 =?utf-8?B?bHRUb29kQXl5Mmp1VmlSaEl2SjZaZWdVMFpYV0RTSVpLaEtXYUhYWnZ5N3J2?=
 =?utf-8?B?czRqZjNHd2dJaFNNa0doMXVYcXoySFJWa2dORDV0dk5hM0dMM2hkOG9mNXU2?=
 =?utf-8?B?YnoxVTU3MldSb2hPKzZJMVhldVFVK3dpeUw1dVZvNSt4eUZwOGowRXAvSzM0?=
 =?utf-8?B?YndNMXJQZGo4aEt1UjhVaWt4czZOL1lickdkS041Wm1PcExmcm1uS0dhZmJp?=
 =?utf-8?B?bFB6K3pRaDlZNWVzcFRuWk9VK0RNUG5pcGcvWTdicnora1VCeG1mU2RxcWhS?=
 =?utf-8?B?N09yRCszL3BBU0E1TU50bHQzOVFZaHBvcXNkL0xoS0hLeHJGdzNFeGRJb3Fr?=
 =?utf-8?B?Mk5UckRkMUVhZU00WVUrb2J3V2R0SHVCNkZNRFkrOHRXYk41UVVxU1BHVDFs?=
 =?utf-8?B?TzVCU2RnN2RCdUhZMFpwK0ZJakwyd2loZGVJYWN5d1I5Mmd0RHl5Ylg5S0g2?=
 =?utf-8?B?MGd6TGJwNjlOL0xmbFJ2S3pWNnRTL3NHbkMzUWhac0pUK3AzbDlVR0Voc0tp?=
 =?utf-8?B?WUFod2plb0cwUk5CaklXaGliRDBtNG9yNVVGbjE0cmozQjdaVHhaWUE1SmFP?=
 =?utf-8?B?VzA4akNpcFhSWTdPeU1Dai9sYzdFNVpaRlU4WXl2YWliK1AxUk5MYXBiZHJB?=
 =?utf-8?B?YXlZY3F2QXZFdVpmdy9NVm4wUm9UKy9MODhocTF4Ymw0SEM4NVNvYlhvS2V3?=
 =?utf-8?B?SVdlaDdSc0pEbDgzUm56akNWUmc2aHhZRmNyZzlLZnZnTnVUQkgvVExrczNK?=
 =?utf-8?B?Z21uTUdJRW8rdnpvOUpDS0xDTXRpcE1SMDlyamtxZVBwMnVZc3JqTDNLaUli?=
 =?utf-8?B?STNWQ2RKSUtmcVNuVGpkZVNQdDFnSVV2b0Z0Szl3UytMWVd5bkZuNExMZ3Jh?=
 =?utf-8?B?TEs3RU1FamorYmM3eit3N1d4LzRkeUhxeFJsVHVJVXpxU1I4OWh2SHN2SVQx?=
 =?utf-8?B?TUoxMEpIQVVZTjlGV2tEYStTajlLUWlER3NibFpvSWtmK3hzQ0VmamtObU94?=
 =?utf-8?Q?pXHTeuRtQaiALnqZDu3qB4cWqKmLTw=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 09:47:29.3336
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 890ea6ae-bfc1-4df2-4dfd-08dd5d5d1360
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4042

On Thu, 06 Mar 2025 16:20:44 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.81 release.
> There are 147 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.81-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.6:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.81-rc2-g8f0527d547fe
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

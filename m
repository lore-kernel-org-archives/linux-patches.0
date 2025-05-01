Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2995A801
	for <patches@lists.linux.dev>; Thu,  1 May 2025 11:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746097664; cv=fail; b=Nq0Ab4LvrsOynzE/897iWWOC2xwuSpddGi3swLlbosM9uGn2ZUkTeZK2Q/YMQYDBrnklhOjX1tmCu99VdSwmPgVLyc4v/cofvnP1ZwawIs9WJYN8vy1ba2/uG8zHumaVmhDOEPctpyjYdoNjK6eG4XTjOHBhPCG9QD/XQDGPNKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746097664; c=relaxed/simple;
	bh=u4Qnkc5xhc7qktzWG17yodREsRWWTnp9GepfqZfdf7U=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=qF9yRhuDiF3RaDih/p3WMUUNio86LOSY0AnaPAMi/ZX8ipsDGaWgBnCM8RULf0WYblSJcBvL+xJiGHPxD6eRntZ/Lw8/fB8dCqsQID0l9+d5PiXJ1Ku66FVIWA/IM016S3WK7kUOg+7HSH3p16Wz6YG2r5KjJJz9NcljocPOywo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RTcKpbZ0; arc=fail smtp.client-ip=40.107.236.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RTcKpbZ0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PC7NVOOF/vyqfcuCS44UqOvi05o9ikl0V5z9qN6Bw7sj5EUHKocYwTwY2osb7+OPUW4ApvkkL0s2b792xi7Dfampd5TpyXtDHqSysDNjW8mQsPIxrfafuzRmg/QpQUApVl6zhK+gcznF2+1+OldicLzqsjO5jIBkIfOSj0ax4qMeosyjmHxh5K5BrtY4JLx2UyRU8vOEJIABHlqCgSYU0jFuM6LFXu6t1KLfIObB7PkRVGE0TgcvjUwzV6QN8CloXPF4vAmJFnJWIZgdlxe4bqEjb8TNpE4f8lVVVKiptGwNSOOfmnu41bHSCzmIvRR973kF8w4/2G9BvSBi41yQSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZpkF8QDvo2udUEX3/90UL7ias8DN8xmY0t4l7JeNRqo=;
 b=YPLmHhho06vkXPbA8sjOm4mB2E9ZZL531F+abcTyI7JOglTMNMaIZ1lnDfSHImunSPQmFB6Da97dsmj/fqNjNg2ZsADgijTVEWcgZ6xIiqhBZIVKQ12EroBGkdfvGXfQVn/SeAkXpRlncSTJTM/qUA1z1suf7rAOBR+S46FnYzpOKhjwXk9VjOEfxGnhzj+JNWoYxHF+08xbMk0PfKH5bBCl9207AVS7eWuOFl+o+YuIcqFeS/1LCT3oZ6p3yVHJjk3Iakle/ypQxjhwYSpaaxfHjYewP9kXFfrOE6z6UEnWGA0pCPJnrbvNThBbLXMDKZmzTeKvxkUW2aXW6k/pSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpkF8QDvo2udUEX3/90UL7ias8DN8xmY0t4l7JeNRqo=;
 b=RTcKpbZ0GetC3MrA3vNK4jp68YaN2O7hHQ5coRbDvnb47cEfUc1/KQfZ1MtZKsHpSMyRKimpP7NhYtCtAY3gSeS8diN7/7CtZZsDNPGxt9Lw5jPdoDR68gpliYrAwemaeLpt/2sBIG6r7cYV3YqtzzfAOlKFaob/ginbL6y2TfYOpgMWKiA7fzyEuqsG35wWTl1v7VSfDYFGhjTk/SXgZJXgFxVT8np0a11i316MIrHg8M7ja01kgZI6nf+Ez1YlVGW+0QdfyKrFA+rutd76fndWXF1CecowSeZlGsWza+j37RtSYo8u+DCQjs620XSLlHcRVZAZehAqId7ui85g6g==
Received: from SJ0PR05CA0157.namprd05.prod.outlook.com (2603:10b6:a03:339::12)
 by SA5PPF6407DD448.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8ce) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.20; Thu, 1 May
 2025 11:07:37 +0000
Received: from SJ1PEPF0000231C.namprd03.prod.outlook.com
 (2603:10b6:a03:339:cafe::e1) by SJ0PR05CA0157.outlook.office365.com
 (2603:10b6:a03:339::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.12 via Frontend Transport; Thu,
 1 May 2025 11:07:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF0000231C.mail.protection.outlook.com (10.167.242.233) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.20 via Frontend Transport; Thu, 1 May 2025 11:07:37 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 1 May 2025
 04:07:28 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 1 May
 2025 04:07:27 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 1 May 2025 04:07:27 -0700
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
Subject: Re: [PATCH 5.15 000/368] 5.15.181-rc2 review
In-Reply-To: <20250501081459.064070563@linuxfoundation.org>
References: <20250501081459.064070563@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <76ee0569-5d39-4bb4-a3c2-f222ca17c0f7@rnnvmail203.nvidia.com>
Date: Thu, 1 May 2025 04:07:27 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231C:EE_|SA5PPF6407DD448:EE_
X-MS-Office365-Filtering-Correlation-Id: 606b2324-771b-4c8f-fff9-08dd88a061e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bFRyeUQvcGJlL2pxQVpqYk1pQVp0L3pMTkN4aHJjMWxLYWxyME1aSzBScjBV?=
 =?utf-8?B?dFFRbTFQYU05dWpjTml6dExIM2VlWmkveGFCWEhhMTBVNXBRaDg1a21sc0FH?=
 =?utf-8?B?KzBvZHVUWkRYaFRYR0IrMXE4MHhCTWJHdXlheElJLzZwbTlZajZ1eEpYSFc1?=
 =?utf-8?B?REVIS0ZiMDkrQkZsVzVsckRORzlETi9pNmxsMFFjRkJaYjh3N0pHY05FcUxu?=
 =?utf-8?B?Y0xRUmN6NDB6USt5WTl4N2lxZG1ERmlIWjJXMmFtbHlMQ0QzUnJmelMydXBU?=
 =?utf-8?B?Mm5LOXg2cGJEWm5ONlluMGNTUTNFZUFiTENvcFdGYmc0Qzg0UGRaNEsvb1Vr?=
 =?utf-8?B?UnRXWlJiWm4zNHhaSlp1cmZnMTFPN1VwNWNIT05BdnNrQzMyTkFOOWgwTDhm?=
 =?utf-8?B?cExDNVZ1MHcxeVFTK1p4ZzNLazJBNjEzYmFkM0w2UmVUZHlrU3ZTTXhGNDJ2?=
 =?utf-8?B?bnBqVXZYS0VRb2Jidk1TT3BsR05xWDM2RzUyMVJtVERJVTh6RC90VHF3RlpG?=
 =?utf-8?B?SUxjeVFVdXA5Y3g1NnlKOEJBMGpQb2xYVE81c0R0Z0dGSXAzd3dmTktHbDR1?=
 =?utf-8?B?c3hSbys0R0g0Vndjb0JFY3ZDd0JPL0YzWDZsazN3dWdNRjVYd3V4MmJ0QXZP?=
 =?utf-8?B?UzEycGJBMGdxeXhEa1g0cEs0Q3pXdFZZZzhVZjBUZjFVT25xam1CME1vejVN?=
 =?utf-8?B?UXdHZHVxejNOQUVRSE9BQjVEWWxPODY2MW13aXg2Y0ZQVGQrNmZsWFd3eHhS?=
 =?utf-8?B?Vlo2aWlrSlNLbjVpbFNOMjAybkxnZE5GeTljc0pwUWNBWWQvdHZzcmZvbFBG?=
 =?utf-8?B?ZmduWHVUdC91YkdXM2FsUzd0Z0paQ0ZMd3B3T1lkV21zekEwVTNlQ1NYbDR5?=
 =?utf-8?B?aWtBUDNZTm0ybHNDTFhXb3BLS3VYNVAzWmlhRE1UTlZxbkxpTUxwYVo2bXN2?=
 =?utf-8?B?SVBpcXdpWlRZSHpJaHF6UXlyQjVHL1l2Qk94dmdFQ0Z6RytxWkVDVlRXUEQ4?=
 =?utf-8?B?aTFTQUpxdDkyei8yZWwrYnVGR0ZOaHhLd2g5V2pUZUJjdzRNRHJTVnFmc3dx?=
 =?utf-8?B?L0xsVTNxTUthOEVzRVc1U3lUZUwvSzlrYnBqT09QY2pVTDE0VURtN3FzOTNn?=
 =?utf-8?B?dy9DTm1CUWZPQnpNby9wTXRRVDlzWWVZZ2hsRlovdDh4Y0FlaVRJWmpqcUhU?=
 =?utf-8?B?ZVFCb05pRzRLeDFKNlg2d1dkMzNpQ0tOQWg2QTIrZmFiOU13Tm1Wb3RiODFu?=
 =?utf-8?B?WmhvcjF2UWoxWXRTL1RjS1hra2d0bVBDWkxTdjVKRE5FSXk0aHloQ2dnakJV?=
 =?utf-8?B?T2J1TlpxM09RY2ltbm5zdjJMWDFwZVp3dWdENHVhdWpBSEdhY1pwM1JuYTRn?=
 =?utf-8?B?aUhjZ25CWEJGVW5ZNnRNa0dqK1p5WmhESEl4aTl3SjBZWUE4VitXalg4NUQ0?=
 =?utf-8?B?S2NqVnQ3c09OMW9pZjhPNGYxQ1IrUUNOemFVUE5yOHQzZklYNFc2SGJpcHJm?=
 =?utf-8?B?TFhTeEZDa0srME5VSW1PSE14ZXA5OVlsRUx2aGtYZXV1Z2hjOC9iMmROTytV?=
 =?utf-8?B?MFNXYk9xM2trb3dFdDRJQVdOcUkxMTFQd1RwOFJKbXN3NXlPeW5lcXpsWFcr?=
 =?utf-8?B?b1pPdjNReGtqWjUyUWNvMXd4RmcwN1o1TytmUlY1VUtQUExhbFpSajE5aFdh?=
 =?utf-8?B?eFh2YXk5OEs4d0Vyc2lTaTdPalFwV3g3RlRCYTVSblFnbXN6YzRkaWJVNlN0?=
 =?utf-8?B?WmR0RER5QlZLZFFjQ3hvcGJZSlVZdmZsdG9MU2kyU1VWNVNvZ0lOTVpKYVN2?=
 =?utf-8?B?d1NOL1BCNUZKU0djb1BuTGdaV3k1Y25KNk1sOU0wYXN5UFh1eUpKTUtNV21w?=
 =?utf-8?B?VTdVSlo3SUhWSjZQVGR4T016MEVZeWx5cHgyL3htVnF3NCt4S3F5VEs5MDBw?=
 =?utf-8?B?NWZmblgzYk5sMkNWaUtPQmNEaWZjOEhpeGlOZWR2S1lXMlZMODFXQ2tpLy9R?=
 =?utf-8?B?N2ZvRXJWUGZzNUp4UjI5Ui96djRqY05PQ1NuK3AwWDc4SWQxa3VwVzBDcTEv?=
 =?utf-8?B?aDloYTBiNU91NGoyMHJMY0RQbnQrMTVBQklMUT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2025 11:07:37.4884
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 606b2324-771b-4c8f-fff9-08dd88a061e6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF6407DD448

On Thu, 01 May 2025 10:18:10 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.181 release.
> There are 368 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 May 2025 08:13:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.181-rc2.gz
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
    28 boots:	28 pass, 0 fail
    101 tests:	101 pass, 0 fail

Linux version:	5.15.181-rc2-g85e697938eb0
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2085.outbound.protection.outlook.com [40.107.236.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCA8226D0F
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 15:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757343743; cv=fail; b=Qx0HnI7qQH3PB6De0ePg6+uRLL/a8d6spXxmA1Kso5JmfO0EUUTPf1f1BJw/If2aXcOyte/g8PkwGJmD5O5TzIF2ko1UJf/CxyQz1gYZF5G1t2u2Pf3AQ4XObhRdCRJuffEM/nQgkKSUTutqH4eq5QyjW8fF9bXGLQTMC+rKqBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757343743; c=relaxed/simple;
	bh=imhR+gshpqMaWRcE58jC1nZbl6738fiNFE7jUx7Rqak=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=std0C1aCITjG05pwvJbQtIrKPIy4mRZEBDMMi2poUI+2ykNxYSu6C9xC2qKZUJliFJXPRIWe5q94HUGpyTIYatEy6vDtiR7Rvg+h+WauWVEg54uBysnQwL6/0LGKSMAzz57tCRTNIGYuB3q9MZnCstWGgY6b6aPeNc0NvnN6ri4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=n6ZQGx8s; arc=fail smtp.client-ip=40.107.236.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="n6ZQGx8s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aZnutn3hf1OygiK3q42GjzPZZX9K0nwCMvXprYjVLewg143BL2FtDKm8QR7fdkpzeeCwBuaIa05hGWlbtc7ECpoHVZsg5KXoN++EpCC4qnj+a7qhXXgX2wz2wnzCATzR7Z0ghkSklqw/XUKSfFZZiA7h+aue+yCmHPZE22oxIH3P7UmDZ3ZcnLMlQg7tnwqKXLcPJjUZt0EuKFP48zHx0CuRsRmwrUsxzwRWxVQ1U00mNFEgoWmyEdo0uZUdVbGV6gRLjm54HnXHue6ZWmEVaE3t34NwIycr5tOTkL7xSUFJbY2UjQOWxzsUIspARXCtQsq683W1T6V/tRYx72dJmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+wjFTZJhFvB6c3dXAnknUFQao+Zx0xsFx96JMYfjcWQ=;
 b=ePtPwc121ictUhpS8N+VkPN/iLM0UjXYNQ+TRjL53GQAzmH1/RaPPCKcXAYDXRDfOUAjSrM//SZdcvO3yg6mpjfXW421VLK6YZCI3RTcJrO4RT6BwM4ol2NK96eZZBEK01UjZYZSg5mRqak0BKTLXK1EWIljHwsPfJ8bsRd///Kx7LMN2wFuIHX94DBB7jkZ8JWb7aR2ArOJrU1qv6b1ZBwUJmNmiyUvssSYoKzPvecv3/h8IgPw6Q2+l08JZWnMp9eGdv6d3CRKtTD0TlWs0yOaXuy6OftheQFHe44lmoUR324T6txA/BccdcpjvieK5dZs1aa0Fhw+WRZizjR8zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+wjFTZJhFvB6c3dXAnknUFQao+Zx0xsFx96JMYfjcWQ=;
 b=n6ZQGx8sLsjEjHvf2VW8FIIuXfzd+bT8kiHcNUBY21n2EEX/zBbLLhmik9RQZKu0Rtn75SIwY6fmIycFHahsYrLB6SxSM6StpL1Sr7RrYPrAyA0iDYdtdWmwcCvBv5FIpDA0v0UbkoBSZNQUBBZEpZoB6mecjtcqjbM9tMmR1u6qF5Tb30iqG4ATrN0QbxffkRjdoTERR9nZh7Mi2payIEnI1hlTfPILPHI4JZ6Wx1HwMvMKGnC6e463OSniPNEs9rdn0C/TsN4B/6HLQVXbXvjTl+ROSBryIGKOqsdhVZkOGHGgus3KHYFd+fywBXbBZXT5kWcUmx/k1oTrwumkUQ==
Received: from BN9P220CA0023.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::28)
 by PH8PR12MB6699.namprd12.prod.outlook.com (2603:10b6:510:1ce::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Mon, 8 Sep
 2025 15:02:16 +0000
Received: from BL02EPF0002992C.namprd02.prod.outlook.com
 (2603:10b6:408:13e:cafe::75) by BN9P220CA0023.outlook.office365.com
 (2603:10b6:408:13e::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.22 via Frontend Transport; Mon,
 8 Sep 2025 15:02:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL02EPF0002992C.mail.protection.outlook.com (10.167.249.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Mon, 8 Sep 2025 15:02:15 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 08:02:02 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 8 Sep 2025 08:02:01 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 8 Sep 2025 08:02:01 -0700
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
Subject: Re: [PATCH 6.16 000/183] 6.16.6-rc1 review
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <13078314-5463-4a35-bdf4-1453fa26fe02@drhqmail202.nvidia.com>
Date: Mon, 8 Sep 2025 08:02:01 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992C:EE_|PH8PR12MB6699:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e8cf1d8-3996-412a-3c54-08ddeee8b30c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SnNYd3RORk1SS1BWd3lLbVU0YzQwcEpzMjc5QkZBaGo2R2JYVm5xR0NyWHdw?=
 =?utf-8?B?Q2NIb2ZHRnZDYnpPdDVZbTRVQkFRbCswcHd0bzZmcndFN1ZmY3dvcVVxYVQ4?=
 =?utf-8?B?dGR6c21aNmgxV2FGWElNS0hsOVRwMUFBYzBDMVhnQVV1MFB4Zm9SRmQ2Nklx?=
 =?utf-8?B?S3Z2YkVacEREemg3cHQvcmgzY3kzeVhmamx2K2xYNDlrUk5QOFU2cWVwb3Qy?=
 =?utf-8?B?cmVIYTlWcktzR2tDNFpscE1BMWU5LytxWGdwU2hNYkVqYzhmbWErTWJLZkFS?=
 =?utf-8?B?Y05vUXdJK1RIdzlZNkx4bGNlS2hUdmppb25TVUtxNEEvb2xqbm1TSndTejdu?=
 =?utf-8?B?YjIza1RFd0RQYit2QzE2SzdXZEcxZHNscTJ5Y3dPaUpqM2UvUzUwZFFLWi8r?=
 =?utf-8?B?czYzUTJrSllIVnBrbSswUkppejVkR3JsQ2YzRXFZVTVmY0VBYWo0c1FTYmsy?=
 =?utf-8?B?dFdqOTdUMDEyMW8yK1dtcVZKUEtMbGxtTFgzOVJ0YTQrTDFXTFprQlU1RHU2?=
 =?utf-8?B?clpUQkZwZmRVYWdDWXdTVUtYZytUUGZJQXF1SVFLZEVMWGZlaVRxemJNUUNS?=
 =?utf-8?B?U2RxeG5TRnRuWlRENTZLekpxeC8yWW9FSlRpQVYxeWlyRDh4Tlc1K2MxcXhk?=
 =?utf-8?B?V3MrOUFtZlJnWHRacVNuZnJOK1BJWm9obGI4aEVvbzZ5a0szRjRQMmUvTzVR?=
 =?utf-8?B?a05hY01Mc0FwNWlJMFJGUEdXTHhtL0M3UmU5N1h6TE04U3RDMnFYMDZQRmZ3?=
 =?utf-8?B?MnNOaFJHZjNyQVZyRmppeFcvMkZNUmpDejZSNE84LzF4ODE4aGxTcW14SHVm?=
 =?utf-8?B?ZGdsSXE5UE5lRHJzT1N2UWlDMGF5SGNnOTNNV1Q2Y0NXVVkwKzhqZXZDdFdO?=
 =?utf-8?B?aXlEVjJFSGd2L3Y3R2hwQjk1UlVXZnBiUkhZQXd2VW9OZFhWR2FMMzk1OFpU?=
 =?utf-8?B?bzZYTFNlQzRkN1VyLzlaZWdtT0haOVRua3kzWEdzcEtkejV3ZmFoaWpmVzBL?=
 =?utf-8?B?amRrUFBqcW1PMFJaR0t3a2Y3ejMyRTlkYUhLaGFoQzlnL0lJOUFuZWZTaWJH?=
 =?utf-8?B?Uk9ldGd4V0ZRdTN6Qm1EZjM5MFNpWEQzdWlMSzUzM1duM2xiZEtTeGc0OEJm?=
 =?utf-8?B?eWZGajlKcUxGOHA4Q3JsV2ZHTkpmMWNTcmtKSS9id3NYZ3hyWVZIdW1RSmJj?=
 =?utf-8?B?QzZ2WXBKZjdaVDh6aXl3TXdYREhSTGdndXozKzhFaFRBYTgrTTlRWjI1ODlV?=
 =?utf-8?B?YXNCMVRVREdBWEl3Z1BRcEFLQTlUOUNjeExrSzU3SW9mOGJ1SFRBK0dtdzRz?=
 =?utf-8?B?aWI3Sk9NbGdFeXJ5aVpDVXNOVUplcmFEN0QxTnFtbVlub3ZXb0Qvc0ZnMUtK?=
 =?utf-8?B?N1hqVzNLL1pFMHF5OXVOWkhpY2NsOUZpWCs5SGs3MnFoWkIzaForcU91MTYy?=
 =?utf-8?B?bEkxQi9XOEo5N2F0K0l2YmRyWno4SSt1UURXM09SN1FkTEYxK0lxNEplUmJE?=
 =?utf-8?B?a1JJYXorTUcrUjR2Y2tNaFI1dmRiSGE1OEhjL1lRZEd1ckdtQWVGbnUycUV3?=
 =?utf-8?B?TlBFN0llR0RwYlhBSnZnVnFGaWQ0MmlqUlhHaWVjWGxraVFPdlVQOFF4NUJC?=
 =?utf-8?B?amFCTFI0bGE4Rm9JVEhJeFBWbVU1ZmI1Z21yUU51YzRVRmxKY1o0bmpTSXpP?=
 =?utf-8?B?cFBjWDZKTHhVa0NOSVNxMGVkb3ZVeUN0U01iUEwwZXJFNmtxMi9BVmJKMGhY?=
 =?utf-8?B?UlAxQTh1ZWdHaHZ1VUQvaEVVd0FMdW80bitLSzJCTHptWEhRdjRvOXI0K0VH?=
 =?utf-8?B?eUpuckxzeWVsK1F0YUlZSzZFZkIybE9wNld6ZmNmYXl0cWZZcTJDL3psQVhv?=
 =?utf-8?B?ajlLSnY1Y01TZ2QveGptYkJyTFF6UHdoNkdPUE1jRHdQQ3VIemNJSkErSXdn?=
 =?utf-8?B?cCtJWkJHM3Q4blJXR1FpNVBvN0R6eHJZOXhDVllGWWFPVG1DbE9SS2FFYjBI?=
 =?utf-8?B?SHUzRERoQi9yd1orSHZLR1VqM2Q5cUtVMktjVWpjNWtrSC9qcVRNWUVDUnd0?=
 =?utf-8?B?KzdOVk03RHlMZVRjd0t4T3FNWHNaWHhzS1VaQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 15:02:15.8525
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e8cf1d8-3996-412a-3c54-08ddeee8b30c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6699

On Sun, 07 Sep 2025 21:57:07 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.6 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.16:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    120 tests:	120 pass, 0 fail

Linux version:	6.16.6-rc1-g665877a17a1b
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

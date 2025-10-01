Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013047.outbound.protection.outlook.com [40.93.196.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B502D9EC4
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 09:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759309921; cv=fail; b=C42z6CVs3MYN51YLUXGqUJgUMDXWy1LDv2uqYHRtz686GVKk4K/hlfwLEtrgc0iQsxMmjftI/OtrZht8BLOFwYOjgN+tWuvkJPR3BeGjOC+jzLZTrTxInwjn3+LnHesBj5FnMQlFyICzIrIOgMkC4e+BdPdELMc55clxKx1/r90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759309921; c=relaxed/simple;
	bh=3FBlB/8RZV8nfuGUHjDad7O7b+0dwBXVI6uNAPc0QFc=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=EE8ENe5Y+KKfMiMYMRZOJVHl10R3e2jTry9V7hR2C8Y/5rqMgotBywbgYTIlRM6J6zJ6ay1RcCPZNQxuxeRgGunhsEhx8sydq5xtD6564DurksxFYVNmJBTVEBAzhWkb3e7ZNwTA2UNIHDf8HEZfPPp3Cms2JNnN2ZB1442jrbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GhYSG5Zg; arc=fail smtp.client-ip=40.93.196.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GhYSG5Zg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wpoD2hjUXM8QBL+oexs5hxho8Yra3bNZN0ZcmeSoivmqSaQLdzOvCkneSMOqbr/k5i41yP2dJINHOfKq0tM7+whXb6JeL4wKR2Kdam2Jol4VdRSomgUR5zfH85gmneCLx1KKJuaZF1ZGS/rGRNjw4QDjxAle4GcB2qZgQ7JdaJa2mvg2qxdvndwX5RZv13ZceMWINssiF+X4kNAHd2xYKb6XKI56GsZsX6JDIK5tqY9t8Rc177lL0X+pj2Iq2/zz99AhsEJeQMzALw3meinwPSEONzCHuzm/eH7h1osXXYJnD1m6w+DFfCn9YKaqXPahJA22mhjPAoHrWg2S/K1Aiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tIwjOMiI6Vi7Dn8faP7ovHFkL+qRsAhb1v8EtGHL7E8=;
 b=ap3X391al5gHDtmrQwlgNqfhB1ZZLecmAKqLE9euWfC/0sw8joR6MiGVt8woFfxrVqiqzPFfI7qJUlv8vAO/GCSkB3yOarq4fjK00qeKIb2WRrd7VUyCyVW1vnCk2iN4t3/JcTIbYnMDU54IiI0lymsFKKj0JmayEavq2y7T2hs3e7+QYhoEbA1KTBdt3ixI7akFydf5Zz0gML0WroYCtT6LX/n8syU7Ckacgk7fNbNXC623CzcZkPJWzHBUjLnB3rGdUEhPotF4dF0a2DeTbnR5rT2jC1xmAsdYJWQe5sAcl7cyILJUk9QyN/iWa0vmY2Ub3+Z1Wtk4hmxGUvjwTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tIwjOMiI6Vi7Dn8faP7ovHFkL+qRsAhb1v8EtGHL7E8=;
 b=GhYSG5ZgMAZOAt89I+C1IWsJzQsumVNDhh2KdyioaD2zPLMp9t0TJVYJ1DPcU0icvZ5/5Q5Gwo1f9ZrGIVU2zILLm0Q/cFZpmQA3H+VE/3ChsaVoeX0QKjOjwwlzHwYo2g77+2dLJWkiNT47zctLTPDUuY/FVm9bpci3LBf0u4qaycxAh/VAYEcwqiPJMFEk78zin2a/cYIkEFjrlppFTHZ9RAU+DHLWu8ZGUB1SbspOBKv538bzW9zG0Ad1Rw0us7bqrTafiRRTzHA9ZAYZhseRwULijfeyhyPn0HMuTNazgWMva2SaxV9EM3DkL1QOe5ZmDTwPAaXz7Ep6Yj+odQ==
Received: from SA1P222CA0035.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2d0::10)
 by CY8PR12MB8409.namprd12.prod.outlook.com (2603:10b6:930:7f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Wed, 1 Oct
 2025 09:11:54 +0000
Received: from SA2PEPF00003AE9.namprd02.prod.outlook.com
 (2603:10b6:806:2d0:cafe::83) by SA1P222CA0035.outlook.office365.com
 (2603:10b6:806:2d0::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9182.15 via Frontend Transport; Wed,
 1 Oct 2025 09:11:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00003AE9.mail.protection.outlook.com (10.167.248.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9182.15 via Frontend Transport; Wed, 1 Oct 2025 09:11:53 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 1 Oct
 2025 02:11:39 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 1 Oct
 2025 02:11:38 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 1 Oct 2025 02:11:38 -0700
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <rwarsow@gmx.de>,
	<conor@kernel.org>, <hargar@microsoft.com>, <broonie@kernel.org>,
	<achill@achill.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 5.10 000/122] 5.10.245-rc1 review
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <c86bfc31-1cd2-4400-a28e-8732969a47c6@rnnvmail201.nvidia.com>
Date: Wed, 1 Oct 2025 02:11:38 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE9:EE_|CY8PR12MB8409:EE_
X-MS-Office365-Filtering-Correlation-Id: 83be3820-97f9-4168-c593-08de00ca9076
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|36860700013|376014|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Ujh3aVZtZkhnYVJ5dE5xZmp4OEJ2SlNBUEFzaCtrK0ZtRFMvNnpuZGE3M3l2?=
 =?utf-8?B?R09VWk85NWJMRG5XeTh3dFA4Q2llTzBaWVByazZtWFhMZ2swbUdLWUhkSnVR?=
 =?utf-8?B?bnhXNnNJQXFZY3Q2MGg3UGdza1crQU5kRjlnYStoc1c4R3FqbVk5SnJ5ZENj?=
 =?utf-8?B?TkVIS25UOWRnendlWSt4SndRbGduQVdSWnZmU0VmSHV1NmZsZzExWURKbWpx?=
 =?utf-8?B?SVQzMnVuYjRsVHBjUFJXVGF1OE54QXlUUUhDSGZpYy9DYTN4ME1EMUtuM3py?=
 =?utf-8?B?NWFIMUU0QXhzcDB2cVNUaW5ab0NTTFZUeVNFdmVxL1pTNDhBOW44bVZ2ZVd3?=
 =?utf-8?B?cVhSbnNGYkkrNHpVblU2dGIzaWlxT1ptMFN1bncxdWNtcFpPZWd5ZGtMcTJM?=
 =?utf-8?B?ajZlN1VnemEraGpaQTBDdkNVUjQwWlZ6TS9EWjA4Z21kbHZ4a0lBdTUwUFlk?=
 =?utf-8?B?NUJDcWpKb09nQVErbHUrK0kvMWdOSE1nSDNJbkJmdlhLaXhrTlhKTlVxamgr?=
 =?utf-8?B?OFNneUdROVM3N1Y0TGs0eGN3Y203dVlKWEp3T1Rqb2NSMkdxZitjSnJVaWlz?=
 =?utf-8?B?V01FUWpyVXRoMk90ekthZjBzQnF3YjFkNUpuUTdMZ1ZVOXlIQ3ZQRVV6emcy?=
 =?utf-8?B?WnppN3pGVXFMNmo2WkJHazhxVXJYMjJOYW9Hd01JaUJDb0g1cENBL01LRU5E?=
 =?utf-8?B?d3A5anhjM3BFLytlRE9DQ1hpQnZOM25Rbk5qYitRbW5uQ3N1aHoyY3hwMGUr?=
 =?utf-8?B?azI2cjdZUHBhNFFpdHdZNXA3bG5KUnV2Z3Z6Z3gvOHlFdk52WWJhZVVlbHEw?=
 =?utf-8?B?N0NSU2gwTjFKOTNFVEhIYzN2SThyN09QMDI2VGRlaHppZGVrVmhHdjJqc21J?=
 =?utf-8?B?NldkdW03aVM3L2dNbEJIK1JDM3oxcWdvVkY0REhKS2JFWFlMUUMvUkhsMzVL?=
 =?utf-8?B?UEh4Z3hPWmJDdnVGOTlSUDhIc0NudkxpWC82ZnZOeVFyenl3RlVqSUxRQW5D?=
 =?utf-8?B?NUQrU3V4NWlMVXJoelI2VlUvVU5sN1hjRGpvSVUzZnJzNFZFYTdzNE9pTjJt?=
 =?utf-8?B?SGRveE1makorUTY1RkNLN2JlNXRUTWhtYnprVzdHdEhYZlhUWE9PT1RjRSsr?=
 =?utf-8?B?MDE1ZGN1MFFuWXRMZGkxZHpKbndzeU1Ca0hDSEU1M0xHOXBCZkQ0WU5jTjAz?=
 =?utf-8?B?cWt6UmZqUXpWcXRBVGwyc2VOUjNMTXkyM1lET2lURUltb3RHNFk3Y2pKenJD?=
 =?utf-8?B?K1RHN2NZOFNYN1hqUDd6NDhIajZIMTkvb3RncUxzaDBwM3pLQ1cxbUdGYmYv?=
 =?utf-8?B?ekpnN1RWdGtsdlFqWHpqUllyVnc3SFpWdGpOMElYNmhtZVd5YzBlRTl1MVBl?=
 =?utf-8?B?WHk3Z0U2Y09xbFg1N3lLMTVVcVRUZUQxYjZNUXZjeFFXQVhBSlZvbm5jSXBG?=
 =?utf-8?B?VUlOQjZyTzVySHBZaXFOL2FIN0ZXcjVJa0xvVzlCa2hVa0RIR1FmTUhua1JX?=
 =?utf-8?B?RU9TVnRMRUNGc205bWw1WEZvY011cjR4djQzbGhsWDE0aDRWT1p3amlhWmtE?=
 =?utf-8?B?Q2xiSzNGWkp0WUQ3d0RaNU9Dd3ZZUlN4dEtjeGdwRlBZZ1BkWC9FZ290endt?=
 =?utf-8?B?YTgya1lCeGFyY1UvS0NuR1VOb2kwcDR3RXpaUmJCbzNLRm1zVmxYSVNPVjdY?=
 =?utf-8?B?Rkt4TnVlYWFNaFh6eEN2b1hVOWlnQzFuZjBCSHhWS1BEM1ltSU00RDNMMzBH?=
 =?utf-8?B?VERTbG5FVzJTNUVtejFSNEszQVJWVVU1aDF2SzFIY2pRWFl4c2ovak84RHkw?=
 =?utf-8?B?alFTYUV3aVRrNkVja0JFOFdyU2ZtWkxiZTRNdlkyY0lhNEpSalV6V2ovTlJF?=
 =?utf-8?B?Tk8vbmVGMld3eFl3Si9QOW1WbUlrQnY2SUF4NndyRnJ6ZzdicDQ5aVJxSU1P?=
 =?utf-8?B?Y2Z2ejhTRkJNdGJZaVhRMk13NUNoV01FT2NKZUpzZlB5cmZFUU9VSWVQOWF0?=
 =?utf-8?B?S0pjY2dtWGdyQnNxajJWRUFsRGF0YnpJeTlqZ2wxbFBvLzhicXdCSzZNL3F4?=
 =?utf-8?B?Z0lVOVllQ2xWSXMwc0lEdEYvcHo3WCt1N29HTnJ5MSt0WWpjbWkxK1E4aVc3?=
 =?utf-8?Q?xy+U=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(36860700013)(376014)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2025 09:11:53.8879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83be3820-97f9-4168-c593-08de00ca9076
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8409

On Tue, 30 Sep 2025 16:45:31 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.245 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.245-rc1.gz
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
    67 tests:	67 pass, 0 fail

Linux version:	5.10.245-rc1-g9abf794d1d5c
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

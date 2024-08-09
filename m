Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3032518DF60
	for <patches@lists.linux.dev>; Fri,  9 Aug 2024 10:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723200713; cv=fail; b=Zq2bwbRHpYEFzzHZPp+85zatB92s/BQVD1qzXaxCjSMPrPiPjKkRppX3pObxFFKju6r1X4u7C3xp6FaIGUcclvyf0qaddNK+HL+j+feiFZAgZ9cSihmP2tn51t+TPe4SRprOsP7ULHTfbukTjPP/HCOuZxTU87cv3RbRMM8KaDI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723200713; c=relaxed/simple;
	bh=bq+EK/X3/XaKaZrZFx45GmY2IMOt+Ds9gJwseh1bnvQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=bSyzCMyiTvaXOEMXbDs7IJZyjKMMmMhKzOuhtwng7YnkCwYqQ7rkCVerc98/tnuptlvZ0EY3uUvO5Q0kKb7NCGf1hDyktyIWqoRi1j/R33y+pjQHVg/olbSg2mnG2s/J0ilqP86YVZiliMOSRzY7d1TqERsXpJyN7mIgvciVNY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eBf3VgIg; arc=fail smtp.client-ip=40.107.220.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eBf3VgIg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bTS8i1xqHkUBURg3nAZcI4nbH2QFgU1FrmmjDhPSbVz9ii6erJndPLUzCBh3DGfiaJfywkCNQwsYMcThLnJ3KYNeujXF94KGDuzmGFkGRQyBS/q2kBbkGo97TJqhcXWd6rbEtd2pkIbxsoN2Cb7ywPTdKJ4EnlNRrQx+VzhFVuT4OZa0BuK1H8vhuW+2LQHAFcHG8T/fVJbimJucUsdDMheohkC3DzluJWzZdp117Nz1YTlAOL1uVbHhCTyduaWprQX0nRrfpiXgPPLsaauIoUZOAKN8oRHb12JUbuXJlPPGaNYqWfQwb+syF9fna7Ey/j5AF+OY0eSjx4SUhB1i9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hafN6TFFsvHX8fbanmhgz1CO5guAJ8JwFy35ix1KC3M=;
 b=uHJPmLJ5KZx2fDlKYLyWDqkUP9dXgzgkxIyxmKCmcICZGN1j2PI6eNZptJ15a97bkAHKzH/zRFuz42vrRXn6cSkkz/GN69WDS6OiG4/lIdxl2JElyG7XQ580MCm7ciHXos7c1IRmPFgJTLy0hrFfzs7LJix+emi6Q1fliNw5jrxLJFKVKf8kTScbb8Yqp+N+fTNnnUlDvFBmeO1iNqR9QqyjP7d+cE+0oSUyp3z2wr0aS69lcAiZ9ssUfHukBZBv3H44URQMZv2ALRyM3IwZyZhaytFzw762P189mlqMOAFrEmVJai0ZTCI1wYD7NO54/PiyzFGyvFUM+xLx0kRm/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hafN6TFFsvHX8fbanmhgz1CO5guAJ8JwFy35ix1KC3M=;
 b=eBf3VgIg4IxObHOMfJHcsLrZ0tqBHYL3yJsi24Cnd4tRWbgGuEHaENzIz4yWgP0MrDCo6XG2UMPW3OSZdS1PnDZIjmHKNg0Ird26jPgalh0x8Pt80t5D1u8eaevGXrtIZOi2hyu0vh5mXNoITz14E3NgcwfUAR3URbgBFsbh783r1vxO0mzJXKkoNP96GXEkYgNOw983bM5i3UCCMQPrNSflFqOxCQoiLSVZu1lSRDuvwwBhpqinKWlclUrsJc6QYKdv6F/nMmt0a0fcG2GvQQV7KFk1EuajTYpWvs3GCyPkQAfj1HYWRpnWrKzfYtbpQ8ZET0pxPsMQ5D59mDC/7A==
Received: from PH7P223CA0018.NAMP223.PROD.OUTLOOK.COM (2603:10b6:510:338::35)
 by DS0PR12MB6605.namprd12.prod.outlook.com (2603:10b6:8:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.13; Fri, 9 Aug
 2024 10:51:48 +0000
Received: from SA2PEPF000015C6.namprd03.prod.outlook.com
 (2603:10b6:510:338:cafe::6a) by PH7P223CA0018.outlook.office365.com
 (2603:10b6:510:338::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.17 via Frontend
 Transport; Fri, 9 Aug 2024 10:51:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015C6.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7828.19 via Frontend Transport; Fri, 9 Aug 2024 10:51:47 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 9 Aug 2024
 03:51:34 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 9 Aug 2024
 03:51:34 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 9 Aug 2024 03:51:33 -0700
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
Subject: Re: [PATCH 6.1 00/86] 6.1.104-rc2 review
In-Reply-To: <20240808091131.014292134@linuxfoundation.org>
References: <20240808091131.014292134@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <ec279728-5d36-4b01-b46c-5eefecb9198b@rnnvmail201.nvidia.com>
Date: Fri, 9 Aug 2024 03:51:33 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C6:EE_|DS0PR12MB6605:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f6d1d8a-522c-48f1-d4c8-08dcb861443b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cGpqTml1SFJ1R1VPK0JtYkRpaWtRUkVVQkJkVlhJMmwvM3ZjNUtMZXd1VDJE?=
 =?utf-8?B?ODVnS3pSVldaSzJNTWNrWXE5NFIyQlNRMjB3Y05PVFhUOXFxVDVmUFppY1lt?=
 =?utf-8?B?dTh0WmhUb1hXNzhQK0RPV1FHaXE1RURmTjMyL3A2Tm1JQzFsTmJjUm9TMEw2?=
 =?utf-8?B?eXNlR25TVmVYdUxQQjlVZ3lzVFdiSVRoZnhzeXAzc2VYbFZzc1hUZ0VEYitD?=
 =?utf-8?B?YWx2VGNIenJDbmxmcDl6WjltZ0FKc2tyd25kYWozL0lEV2hYVHhrTUUwaVNl?=
 =?utf-8?B?MzZhZjUxejJEZ2g1WWdoMkJoVFJPWHIxbTRHODFhNk1ZUXl1Nmw5MEJzR1pG?=
 =?utf-8?B?V3VLZC95Y0QzWWZ1Zm4yOHpnVnFtT0pLZG9uUlZ1TCtqdlBjSUtSME5QOEd5?=
 =?utf-8?B?ZTdFVVNYMWxIdm5NZWRWRWpLbHo2bDBuck1xdzlHUGYzZnJ0RFdiUVJJT1Zn?=
 =?utf-8?B?bENwcCs0NHRHNnhOMzNpTDlSUXFkM3hKd2F6WDNpNk85dHc5SDZ6ZmQ3YjNk?=
 =?utf-8?B?NEwxTk9WUjdVVDNCVkNHamhzTHFKOEZvZDNWd2JoUkpvVm5qSHNjdkRwSzhz?=
 =?utf-8?B?MEtmV2JkbE5seURlWk0ySmE5aHg3V1J0cCtsUVJOR1BPemNQYmU3WnltUVA0?=
 =?utf-8?B?cHBjbW40L0xiYjFsY3lVdmpubDhvYnlyQUQzTnhLMzhqbjFNazNxQnZkTTU2?=
 =?utf-8?B?RU1Vc2sxV05jdmdUMDAzbWFENStEUWRPMnVhWW42cmo3SnY2T2w4MFZvNW9r?=
 =?utf-8?B?bFZwOWN3K1FvQWRCS28xUU5qSi9UOG1wOTdaRlh0MCtEd1JBSWQxNVZocFlO?=
 =?utf-8?B?NjluR01EeEE4SDdHTThudHBPUyt0SkR1MURvWm4xaFRMbnMzTE5aNXV5NDFr?=
 =?utf-8?B?RWtERm51Ym9rMDhzd1VlZ3RBZEVJNGF1RmZNN0VYTk9aYlhyVHUyQkI2TlVh?=
 =?utf-8?B?R2JyNkZDUzRHTkFCMXlqdDdnMlVRMnE0dllIdU5oVGk4SWRMZzJPcVFvQWho?=
 =?utf-8?B?aVNGTlBhMzNoM1pWcVBsZzV5UmhUK2lVOWduYmY5MVYyQ1NUU0JJc2dRRzAz?=
 =?utf-8?B?SWdkTmZJN1ZMekJNVHdaYmpTRFVZZnZCb0N4V0xhK3lNMWc4aDgrcmtwYSs3?=
 =?utf-8?B?VjdEMkFEMTJta3lUTWhQS1RwY2psV1k5UlJIWGtLSHEveExuemVwcUQya2kr?=
 =?utf-8?B?RmNWVXVZbUNUUWJnSlJCRkxJbmdMWTVJbnBYNElmbElOZXRUbW1teGxDKzBS?=
 =?utf-8?B?b3RxQ0IyVzBhN0VVZVYwNzVzVG5qYnV0Q2ZoMGx2WlA1Q0RMRlE2RHlIcmNy?=
 =?utf-8?B?UENDVFFBdUxVaEFhdENEV29OVVpyTDlVcXpXUUI0TEdpaGpvd1BTVE1NcDdB?=
 =?utf-8?B?cW5YL0h6UzdtS1BRcVUxTXh1Uk5ITWMrQUh0N3lYRVRLMjZCd2tPaEZ5dTlH?=
 =?utf-8?B?L2NmMTk1TW0rYXdQbnVxNGhJM2dPMVMyTmRSU0hTYXB5TlVEakl0UncxUWxr?=
 =?utf-8?B?QUt1WGRMMjNmQUZYUnpEaEVEZmlOQWE4b0ZZemNqUVV6MDBqdnpDQ096QVcr?=
 =?utf-8?B?WWhLZDhCeXBFcDdNbmgwNkhBelVVL25qYTFHbHNQMjU0R3VvVEgySDFJdnoz?=
 =?utf-8?B?Y1M2dmVVN0Z5U0tmUFNKdTBCNDRGUnVzSytDYWQ4OWR2eXdpa2s4Rkk1amZU?=
 =?utf-8?B?eDBCSTVCc0MwSTRQMlF3elRvNlM2NUZSSFdYeDY5Y3Y5NDhXR21LcEFZNGRq?=
 =?utf-8?B?WW42UGxIYTE3SkRlYzV2bmhCSitXalFiaUdFc2tyZTRabXNqTzNkVGE2dm1X?=
 =?utf-8?B?eWVjSFFsbm9vOTdQeSswZ0pKK1NYejdpcS9adm9jQ08zNk9qM3JZM21wSjBR?=
 =?utf-8?B?RFpwL3kxOFY5TlhlVFQ2WG9LU0VGN0hUKzIzeURUdU5HeDhMUnR2Qy9RV2tr?=
 =?utf-8?Q?poz8RUWNLrj78PSTTd1Orv323rX9uw0b?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2024 10:51:47.4315
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f6d1d8a-522c-48f1-d4c8-08dcb861443b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6605

On Thu, 08 Aug 2024 11:11:49 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.104 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 10 Aug 2024 09:11:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.104-rc2.gz
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

Linux version:	6.1.104-rc2-g54b8e3a13b43
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

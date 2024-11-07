Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D4920FAB4
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 13:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730986934; cv=fail; b=XMYTriGRjlO8gr8kZ8vyDumY6nyIDcU/Oh3J3+q9iNHIi3szXzMoMXcb5YJfQqY8jWtefxDqlVI+J+3XUnUxlWL8MU78OEBSthp4LSxTAPqCQL4cHucnWGp7hVV2ovYQogQlpCN9jZs/VUVMPb+R1UuBZK7P3rjHBuOf/WaggcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730986934; c=relaxed/simple;
	bh=tp9WVShPB11dpIuRkhZfdZ01J71CqP2Tmd7i+Iep9tA=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=u8eGPqy65d+YgXjUFdaa45+jHkq5Am/GttQudbMPezTZed9WoP6ZJX/lSz/j8HyzE0MUyCNc/X9569qDuGxv0yLe1iWPHQGIy7bFq4BIcc4q8z5MNvENS85ZjvgYaQflNCXgZSNYw5v+935ioLzLCLspGKEJBJQgG7ZPs6+1jOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qoE6BrM3; arc=fail smtp.client-ip=40.107.94.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qoE6BrM3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tv8X9jsptWx9KEtDIrOGzwRWaRO1XyjgIyw2vES1GGso/JeKk+wTsk4nijvsHvtyvnlkG4UCWy+jvw+4FkpPv3CAjmpZpMeH/01EWBCt185e5CtYsSECYhtJ70iZJuPsq+8yrKGGTct53czphnLVq5jHtrgFYUg/0OSchTCXXCKG1Mi6Yjy0kNJS5qMZugi6eWrUO0l7LVsVNHlGkMA09HkBlpla/wz40WiY/+S7kTccRBgqy6HKfemfI1jHGJsNgLJdK3b8wawv/PRCJk4V+W2V5mRF8xEkMTM5+0X2XEujwEMMgBkclSo40Kn4sTiUYp3rUs3mOuYW8xkZhjG9Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B3zuJJXlBxHV9Q3Kxkdkhy/oLJOE0TpXw81Zx1hcA+E=;
 b=yiT6xbOKSAGFaKyufSPUGkCEDcC9jpXHGNtDZu9sTDeqHVWAXwJYn7jdvYAYkiuuoJackLd0CMp8gzCtWCkZ+3g7VEIfw4NVV5+2Jz6uVn00umjvo2XehR57FV+VArNW27CtXByFUNjb9D7wE6GJRL2VJWNz5iKPrBlJWeocjbFCzv821j43jq1oiSCN9hSrCaV2NgraaJkUE0mkno1Z6G1I721eC/tjU56WiH4HG7vpkwTkaJayUXGY1KEB/15q1T9pX9unbHRDhh7sVOyyZHHYFJtiXuCxBGfDPyr8xeFGJO27yaRVyvthN9LEFlgDSItwMJPfhE2ZyCd09McTmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B3zuJJXlBxHV9Q3Kxkdkhy/oLJOE0TpXw81Zx1hcA+E=;
 b=qoE6BrM3VObxMkRGmAGNLN771PKb2UKrLaVkiZ/Sn64ilvD+6v9JqqXghS0f0tIb/qTeqtVK/h7s/iUAz174MenMotrwEbkr1BLZCNZvmED0klOeWBF/SYMx7+PahnUZDsDGqpszjyMcRA5RGK8molm6gBtvUb03HZ37xsWOu25NXDWiNd6fXja3tYE47i2ZaoaRTOpBjcP2+cE+1jD8RQRjJV2LxTklvMN0IXL/yT+uSkLBrSuKO7ffEXSYQbJuF+5y5jykiTdQCqu1Ez3BAe99YrHZB1qe4lEu1Ya9XnAggc/fykPy+TbnP+HVs7p7NJSn45VdG/mgTpMCLCn5ZA==
Received: from SJ0PR03CA0384.namprd03.prod.outlook.com (2603:10b6:a03:3a1::29)
 by CH2PR12MB4070.namprd12.prod.outlook.com (2603:10b6:610:ae::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Thu, 7 Nov
 2024 13:42:09 +0000
Received: from SJ5PEPF000001CC.namprd05.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::78) by SJ0PR03CA0384.outlook.office365.com
 (2603:10b6:a03:3a1::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19 via Frontend
 Transport; Thu, 7 Nov 2024 13:42:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001CC.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Thu, 7 Nov 2024 13:42:09 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 05:41:57 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 05:41:57 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 7 Nov 2024 05:41:56 -0800
From: Jon Hunter <jonathanh@nvidia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	<patches@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
	<linux@roeck-us.net>, <shuah@kernel.org>, <patches@kernelci.org>,
	<lkft-triage@lists.linaro.org>, <pavel@denx.de>, <jonathanh@nvidia.com>,
	<f.fainelli@gmail.com>, <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
	<rwarsow@gmx.de>, <conor@kernel.org>, <hagar@microsoft.com>,
	<broonie@kernel.org>, <linux-tegra@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/349] 4.19.323-rc2 review
In-Reply-To: <20241107063342.964868073@linuxfoundation.org>
References: <20241107063342.964868073@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <4f582cfd-b2c9-4947-97ed-e725d48cf630@rnnvmail201.nvidia.com>
Date: Thu, 7 Nov 2024 05:41:56 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CC:EE_|CH2PR12MB4070:EE_
X-MS-Office365-Filtering-Correlation-Id: a9ecf29c-aab9-48ad-3ed9-08dcff31fa12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VTFYR1R1RHhhRFVmYnkxYk44Nzl0aERIdUNCSXE4bm5UdVF4OHVQbjNIY3hN?=
 =?utf-8?B?end2TnlBaEJVbDN0TTFQcVNMMmpOc21wcGpQc0dwU3UwY3JKSEFvUllIdWJt?=
 =?utf-8?B?b2tqMWlCSTVGK0xSY3M3dzRpZ3Rlanh5MVpCUDM1NGoveXNGOXAvMjlwQ3JW?=
 =?utf-8?B?a21BVWE5RDlvckNVc0tqVEl5ZDBKTTl5SWNTZHRRbXY2YytVVGVpaUJ3VGZq?=
 =?utf-8?B?clVKQzhyNkVIZmJzZFVvRmVFNTBmZDlYSzk0NmVGSmRUYW1PSEFTVWpHbERK?=
 =?utf-8?B?WTgyTitnZHozTHZJenJNUVkvd0o2MHdwSmtQWGcxZUV5ajdTODUzbi9uKzJq?=
 =?utf-8?B?T3FsZWFqdlh4U1VyQ0h5YVIxak5KZlB6NDhINjNFNjZBcEFYOXNOejRuTzlR?=
 =?utf-8?B?UjdkbDR0VFE5WW1HcjVrVlhwRDdTZFh4RU04RE4ycW1TMEJxOXEwd21DTmxv?=
 =?utf-8?B?d3EzdHBzNEhORElnQm50MnluOGt2UStXYXpuRWtVQUowWmx0MTBUeVhmWkEx?=
 =?utf-8?B?WWFoUGxDbzdKL29KOE5HN2xYNEEzL2NoclV6bGNwekdqMVgvam1QUFFCbThC?=
 =?utf-8?B?aDV6cnRWSVJxZTIydlppM2RWd2VKQ1hhaHBoZVFiNitHRzZVZGR5TVUwZmtT?=
 =?utf-8?B?Y0JaZlVoL1h4VHYxYzJMVzlsSVN6Qys1ZXdkT0llV3A3RnRZSmlEem9BQ3Bv?=
 =?utf-8?B?M2k0L1hyOHZ5a25xdXlDRkJURVBuNmdzaFpBK0lxTForTTY3aUk5S21xYUNz?=
 =?utf-8?B?Yi93NFZFaGF1WmowbVA4bHNiWlErbFAveFhQSitpd1B3SWVJV1Bobk5XSDdr?=
 =?utf-8?B?MWpMK0w1dGFBaStwVEdtRmEvWldkQ3lWOXJUYmRpNGh4SVZiT3NPK2FJcTEy?=
 =?utf-8?B?MFArTDhjQnJ4V2RJaTkyOW5YbFJla0FxTDlxRFozVXIyd2pJcXRpNFZFWXZX?=
 =?utf-8?B?MmJCTHVld2wxejRIanEraHVBV2EwOWRpbHNnWG9KZkZCbm9qV0xvelpFWVhn?=
 =?utf-8?B?SkxZaGZsaWJmU3psK21PeExvRHdFZDJjVXhDWFkzSXk4Zms0SGJhU25GM2F2?=
 =?utf-8?B?NVpJc0lEdXRPcW1uR3JmYk9ydTVaNG1MWXNQaVJ4amw1MWxCaHptdjZNajVE?=
 =?utf-8?B?ekM4cmZ3RnJJM0UxYy9ETDRrcTZPTDh3eE8ybDg3MzBNTGZHSlpDNWl1NEZa?=
 =?utf-8?B?d1JkYzllc1huZFFxVy9Pb2pxcFFjd3V4T1YrRFRvNDFtalN1WS8wdmRHOTM0?=
 =?utf-8?B?TGdCYk5sMDYrUTIwYk96SXFOa29ObnpER1R2c0ovdVA1WklwWkxGUllIdVc4?=
 =?utf-8?B?TXZNSy8zYWMwakcvTEJoOGdUdDN0ekpxZllWaGY4eFVTUmcxM3hDYXRmNS9N?=
 =?utf-8?B?cmVJZmRrWVR6aWVWcHh2dGpYempEYTVNVVdLSi9sKytTWklYVDdHN0pzbEdN?=
 =?utf-8?B?RnpRTEhXTTZWK2Q4bXlzMlZpWVZjOFFkU3pXZkphdkFFVmREaGE0TkJ0N3R1?=
 =?utf-8?B?NVBKS0I5KzdkNkxEejVsZkJYeXU0MUZibThndlhMblBYUzhaVHBENGQvRWt5?=
 =?utf-8?B?WEcrcnFNZmI5WktockRnMUpxYmR4aXY1eHRnMnhyVlZtMktpeDd2cTBXc21u?=
 =?utf-8?B?UWpjRGJDVUVuVzhIUzVoSXZlT29WN1NqemIxL2tIdkh4UzRreVh6ZXVhWWNI?=
 =?utf-8?B?V080OGV6ZlY2UzlGSjJlZS9EQ3ZQTjlFOTVUbUdhMk1rUHlyRENkVUZMU1VG?=
 =?utf-8?B?NGJBL2tCbHc1elJScXE2N2M4ZDFUelZZNnVxamU4cCt2bEJRaDhOTkRQWldm?=
 =?utf-8?B?bXF3V1JOTzNDUjNNcDArNnZGenBDOHhTM1JDU2pIOURkaFcraDJtaUhwd1JH?=
 =?utf-8?B?TDVqLzY5NVNST1Z2VW0rc0N3eUFGUmMyZTNKbmEvWTM0aHc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 13:42:09.3435
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ecf29c-aab9-48ad-3ed9-08dcff31fa12
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4070

On Thu, 07 Nov 2024 07:46:55 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.323 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Nov 2024 06:33:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.323-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    10 builds:	10 pass, 0 fail
    20 boots:	20 pass, 0 fail
    37 tests:	37 pass, 0 fail

Linux version:	4.19.323-rc2-g9e8e2cfe2de9
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

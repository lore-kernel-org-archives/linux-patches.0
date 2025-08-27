Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1DD3451BE
	for <patches@lists.linux.dev>; Wed, 27 Aug 2025 09:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756287306; cv=fail; b=nVvEL+/vXyYkxHW65iXV8OSwvrEpITE23r9OY6lx/QG+eVMiV+3rReq4tZ7l7aNcVkxUE9Iw9o4nfCYhRCG6Zt3JmPC/qgLAIbzF0ck/yaYHy9jyJsBtqjRKxkLROVwUcZ2VIqu6ec1qM5C+vpIoAvCazuFMHWGBKTtfjt5JApc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756287306; c=relaxed/simple;
	bh=r5kU5iDXePyfNac/HmuFUgOuGjCCPXLzSKjd1MOYcM0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=tJZ8SfbZh5Z6lfew1LkiYI9eN4qVDZ2R0wCkcdx9c5NvX5Si8ratrD6ZsbK1QwVjLU4OsZbk409R53Q15H7R/qPd36SSmi2+/6GOPmYpUPzF/uXmqCa2jJPKmold/oK2tjFeFBibeRgx0lcEcrzfAbPkkmV4xMn0/MUSiuVeVNM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ok7rHC1R; arc=fail smtp.client-ip=40.107.223.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ok7rHC1R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dfvpFR6wcn+xX8wJHx74eqlXMvwnLmpj4NjWavizAx+aHl8fj0oJt4nhk5fXlAmk/Sgfy/tzZv1LWUoWxxmm3lK1m37+AXl+euIpI4BgNc8xrMJ7SKrjv7e7sPantLhN0ZjUiuQHoZ6Mhcp+Vc0JgqQP6ZyIcQo2pVpCs03nXVBwbayPGp09HrRDPo0cSXQbOGtdOxW3mumyvJd4x/W/uhnopYXuJQS9MrThC56mjFNavsC15dE8M12jOdUi//H3ExR+XpX6fm9IrhKQm4urUIjZmB3f5m1xpHRo4Z7AGXJfbY36VGLcPROAVjDUX7zGYejt3zUJeaVvAmo/5G2F0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ztaWOAcT8kQjQYjkRkX9cmShNXlkcaxpVK9ct69fCJs=;
 b=LxjTw6MMNsShaxO1sY4Q4dC02XgnJr/kiFxuKP0rmlPi/zdu/bK8zo0YGlN4WC+ozIqycp8DRE2Zhl+oQJbbNDOwVEhceQKzt0Wn2RIsC8LKCgSmlJ/mFoTmeE7J7TJ0NQH0SD1Ad9xvRkRs+m4jG8I9AIFd/cQjN1vGe8obkhVIf+ctxccadNXYJjWb3KH3rq+2+f13SvxvyLybkebVWeUcAIAuOADf1tt6E3a9j72GaGRwdGJRolzy9RtJvNocXLCayHRGPhPtpY6cTGYgOVajZe57DA0gc7bfu6bVaK13s+XWJ6hCPsT24YYEC7TngmIwNH2mfASzLkBAwcsMlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ztaWOAcT8kQjQYjkRkX9cmShNXlkcaxpVK9ct69fCJs=;
 b=Ok7rHC1RFy7XgSSMgxiXfvC+TO28utqbHJr961AGg2e1HcS/GK1Obqg9FtFsDMwYxv5GFk8zkg82/8YbZIH4EAu8QBhRA7u1BzrQ5emA5tACTeWk19ZK+EgKvqfdeVlWp0CG7NtK9TzOXax26l+kSsdINTOfDCmhpS4Nxy0bXPSFuAb/eKrVs9RSbefnfGe0XlW5sqiQOH/14Yss8MVw6m2fN96d6B/DZjANmMJliHlEYjzeEyqjwXU3SRlu17NNk+eNlK1cNwMWl8xdmgjOK9L8wim+iyFZ+2lmr3Agogc3AW+KQNxoYNa8miEoBPKvz4a1V+NGB2XMW8NevFmrbQ==
Received: from DM6PR05CA0061.namprd05.prod.outlook.com (2603:10b6:5:335::30)
 by DM4PR12MB5938.namprd12.prod.outlook.com (2603:10b6:8:69::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.22; Wed, 27 Aug 2025 09:35:01 +0000
Received: from CH3PEPF00000017.namprd21.prod.outlook.com
 (2603:10b6:5:335:cafe::47) by DM6PR05CA0061.outlook.office365.com
 (2603:10b6:5:335::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.5 via Frontend Transport; Wed,
 27 Aug 2025 09:35:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH3PEPF00000017.mail.protection.outlook.com (10.167.244.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.0 via Frontend Transport; Wed, 27 Aug 2025 09:35:01 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 27 Aug
 2025 02:34:53 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 27 Aug 2025 02:34:53 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 27 Aug 2025 02:34:53 -0700
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
Subject: Re: [PATCH 5.4 000/403] 5.4.297-rc2 review
In-Reply-To: <20250827073826.377382421@linuxfoundation.org>
References: <20250827073826.377382421@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <2a2c16b4-c182-4d31-a4ad-dd9d60b2664e@drhqmail201.nvidia.com>
Date: Wed, 27 Aug 2025 02:34:53 -0700
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000017:EE_|DM4PR12MB5938:EE_
X-MS-Office365-Filtering-Correlation-Id: 682e16a7-d240-4ac9-35cb-08dde54cfeeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|82310400026|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eC80Q0NOVXZ0N0lqcUtiRmRUYWloMkdKVkFZOXdieGw5MmYwWHVyMEVUQzQw?=
 =?utf-8?B?ejQ4dkZ3VTVSdTlqVXkzMmtiL2hLUVBLUTN5ODczbGhFZU5WS1RRSW16RVRa?=
 =?utf-8?B?UHlqRUVKY1JheVA3NktIZ0FXRVY3RmpXS3FYdkNoTkN4R1d0RjEwU0JiRDN0?=
 =?utf-8?B?dndxWFVTRjQrVTIrVDM0MmNRa0FmMXk1ZzdONmpMREZNOUJ4M01UaGFreUtX?=
 =?utf-8?B?aGx2b3QvSjhNZ3ZualhQY00vQW9ZOGpxWGFxTUZ5S0dUT1VEZ01EVHF3WkRN?=
 =?utf-8?B?NkcyWVJYRHpFNzFHaE9QRGpZaExtcG5BOXNqaHU3OXhwdlpRRWFnNk8vU3lj?=
 =?utf-8?B?TTBsdmUxUnhheHdzdVlySkNTUG5xd09TSU92VVlSYll5VXBXRFJ5ODlQV1Za?=
 =?utf-8?B?U0tOcFd2NWt0VmZIazNtWkw0SHJwc1dmYzBnUHVwaGJVV2V6YXJUL1dVUjgr?=
 =?utf-8?B?M0IrbE5ORDFZQkJCaVFMQWpYeTk3d0tRKzVqR0hjdmFuZWJsQ3hJREF4QW53?=
 =?utf-8?B?bFJHMTl2MVJUakI5cWg0QnFZaFgwenVQTTFhYXRyTkpqZFZ5NklnNmR0TENO?=
 =?utf-8?B?T21GdUVWejRYYmV1MWxmOEx6VUxiL3h4emNGMDNLTUhlbHkyaGxMMzRGbDRN?=
 =?utf-8?B?dVdPRno3ZDBibzhkMnB1WFZOd2F0VDByd0NPU3MyeUNDTkZQZTZKQ3pSa2Q0?=
 =?utf-8?B?WGtOMnVLR3dWQmZ5WWVXTnhydEduZnlldHdrYTBUUGJEVVMzTDJCdW5oYmd6?=
 =?utf-8?B?MGtYWFJsSzVNM1E0Q2x0NGxxWGcwdThweGI1M2NPdWFKQVRXR2VWSWpiUlBV?=
 =?utf-8?B?MDhvV0ZYcnFSNHZQazNhQmlBclRaN3VXRjNvVnE5NS9TclZtd0dKNWVvZm8x?=
 =?utf-8?B?RU5IS05URmRpSTdVd20vUXhIRHc2NEo4K1lYNk9JbUJ4a0loTDcrcGVWeWcr?=
 =?utf-8?B?YjFqc0U0YlhGM3E2VnBJRzVTV1d2TS9xRENQRzFweVBnT1NnZjU4bnBrbitG?=
 =?utf-8?B?MTgxekpjY3h4enhEZzFKU0JMYlpmS3U2WG5XYTFQSWJ1eG83c1hId1NlNTIw?=
 =?utf-8?B?dElGNy9pM0hCVFpOdW0vdTcyZXlyTWJqT1U0S21uTGhqTjFmMmY4N3B0Snpa?=
 =?utf-8?B?ZCtiTVduQk44ZG81a3phUXRuWUU5NXk3OWFoSVUveVJhaVNDNWxSU3lwdUE3?=
 =?utf-8?B?Z2lXcks3WlNFbkZvN0VlaXYwS0xNalUwQjFRdGFtYVZ6YUlmSDRadkRXQUZy?=
 =?utf-8?B?QWs0Q3lnRW1nTFZ0ZzlRZjJWUnl5SGpBZXlFTUl1MXFPM3dRcldvYmxmTHpz?=
 =?utf-8?B?aU5CQ3JuYXcxZkNycUFvSjZQYmZzN0VYYW5saVRmTmJNQUNxRVpha1NJa0g4?=
 =?utf-8?B?bEZEK1lOTHYxc2NuaGppWTZxT1NqTVViUzAyZkZxZGFoOU9CQmUxNGtkOFpi?=
 =?utf-8?B?dnFGc3hkM3pDUEladkczV2ZiVHNIbkpQanJtUmJvSlN0NDFBY3c2c2VGOHkx?=
 =?utf-8?B?Nm9YeE9FYmZMRlZTNVJyMTVRR0tQczNnVk10RTJVM011Rkg4RThTcGxZcloy?=
 =?utf-8?B?dXVySVR2TmF4NERMWW1pcCtHYjFNLzY4K0JUeXk4V2w4VTl6T3JsUWdLUk15?=
 =?utf-8?B?bVFYdWt6eks2WWZGUHk0UFdtQ0d5cHVzRHZnYXVYNU1zOGZya0lmdGxQcU9Y?=
 =?utf-8?B?cnNreU15MDFFSGZ5VU1NdnlCdmg3QytlZ093dlpCc3FGaWh5UEgyaEJldXE4?=
 =?utf-8?B?N0NKcVd0R0VGMHhCQTRURFRTRE5nTU5hZGh4THNSNHFrenBUYU9sOWtwV25N?=
 =?utf-8?B?akFmUWlRZllIZ1NWUHZ6VHRGN1p4ZHBHSDBVb05UdHJoN3lEZTNZd3hWV2tU?=
 =?utf-8?B?QVVTdnpXMmU2TW8ybFVDb2xMV2VGcUdyVm0vZE1QTTk5dHZRT2RGQkdWTEh4?=
 =?utf-8?B?MGIzaXFmeXBpemJUcFhVWk5xWnAxSW5nemI4ZTlva3h0dnN3YzNiOTJFMDE5?=
 =?utf-8?B?T0NTazVnNnd6UzNyTEN3eGN4L2JmSkNmNE1jaVR1djczVTI3UENMTDdJU0Ex?=
 =?utf-8?B?WG0veFZyMzg0K3lYZXlReFdLMWxUWE93dTBRdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(82310400026)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 09:35:01.2174
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 682e16a7-d240-4ac9-35cb-08dde54cfeeb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000017.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5938

On Wed, 27 Aug 2025 09:44:36 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.297 release.
> There are 403 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Aug 2025 07:37:48 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.297-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    24 boots:	24 pass, 0 fail
    54 tests:	54 pass, 0 fail

Linux version:	5.4.297-rc2-ga860ce417cb1
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

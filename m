Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2068.outbound.protection.outlook.com [40.107.93.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02E61E492
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 19:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731527985; cv=fail; b=P44H7XlnxMDimQtgcITckVLhhIQXjF+1+bdQVeoOYRXyj6OFDTPOREEEMIHvrVlkBJnPn7bsooL4skcOxqLNqWnz/NdLqOoxQQ0UgBMx4FyI+kc/m9ltV6jqhbDnzEwCEYxhmve5U3yvt2KLiAKS2A+uqTT/ZyRuIINvow6ppcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731527985; c=relaxed/simple;
	bh=xz1o6+nqAgO22pcqF336o+OIV7KVsD/nf//mjbEUo30=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=DVJ+JI+dohGgsv9/xL04ZecLNgQkNHAopZwo/8OLY+IbM3j8bTF6HnSG0C20JmHbQgJ7sd10IbdjWPgvAFA2unwLu3VmQKPBwoW/WD8tLefWLU8CTqbRKQktQID3PjPD9dX5MzqI0ZoyFCBXNendJMuBtLs5LlIE7qHKbcTWZpU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZPlRQ2m9; arc=fail smtp.client-ip=40.107.93.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZPlRQ2m9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O9QdayoBVhUJVticcbNdXuRyCbkltXgi4tVz6Y1+K2mMNWv3DD2Z2DNLVOLD4m1V8z9xhrKEwZcwFt8QcgDfDWVSwERum3SdjtMTp3T6E2aP3Zk7PRr5wgT7w1LFM6xLyC+BPF8CWiaRzS9uEuPog7IlxWob3s6DcWafvdFdtLESII0OIxh0ilUPC1CPdKyma1m1/PPFGbTczih+HqbL/o9I3LO5n9XYn9A53uQraedJt9/Qcdmgd4no4uNjmt09I5tLCPZcZC8+0SBUsMhvquvZYxvJKUALTFQCT5QG0nyNGXnhc2AtbCW+zXtHhtGk67NiNhBRFNsobcCIpILFiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AzeOz/oGkv2jkEHBFHBdteC435Bq4hd8GI1uKewTiK4=;
 b=OzGw6zj0VhtTpuSIli7qCMnMSN8HApD44Bz5eA28fRlJ+OyR7JRcfB9RU4E217gQxzC5I4p5vl4rZoMW7OuvKn3TPcIuxuOROipy6WSW4pmQ8MtmLTRSwIH+XOz5foVLN81M/07Wve5gNcGO8HUtco8LqSAjm5Ev8KagmM2c9S3RsIwwjUUov1NJfpKYzzAChGQ9dpzLPl+Ve/SxMBMVt2UPedVsAtR8qgCX2HHA6t+HSIIGFUFr/iiBm4JKGDyi2h9EPnpAbr7BJglZChqVatjM1aqUfrMw+l28oMdMsaJ0oVljLwXzBrCZ3Mpv4hAvxPiMJTreCy/o/GkXLqiGwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AzeOz/oGkv2jkEHBFHBdteC435Bq4hd8GI1uKewTiK4=;
 b=ZPlRQ2m9vwl2WujGaWx/EgEErrT204Vb96TNbVwejaDX7w5itsnOPgQ/eqpjDoWnZjxbJMV4L7eubdyzeZGhRHMbawWFx9Z8EeNhpjThEqkniIAuOpgT8pw8/2tw0VxIdsyWS7tw/HTjzLCp4/zghE5xWZXhlzm1ptIMMtZ0FNp68t4R6XCnJwhxGL24dCYeXwwVT7dXhH7PmdsrNrBLKSSmT8aUicJd2HCWGRYr4XyJRoiVK0Ey01ZiQtTpe+rHCqhhRYx2+AodkY5+8W//kGsgvGRnohRAIxI6DFSUKmwkij6+mQe7nUBNDC4QCfZnGjl4GURaVztYWL9q6Lf4+g==
Received: from DM6PR02CA0128.namprd02.prod.outlook.com (2603:10b6:5:1b4::30)
 by SA0PR12MB7089.namprd12.prod.outlook.com (2603:10b6:806:2d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 19:59:35 +0000
Received: from DS3PEPF000099E1.namprd04.prod.outlook.com
 (2603:10b6:5:1b4:cafe::94) by DM6PR02CA0128.outlook.office365.com
 (2603:10b6:5:1b4::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17 via Frontend
 Transport; Wed, 13 Nov 2024 19:59:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF000099E1.mail.protection.outlook.com (10.167.17.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Wed, 13 Nov 2024 19:59:34 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 11:59:15 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 11:59:15 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 13 Nov 2024 11:59:15 -0800
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
Subject: Re: [PATCH 6.6 000/119] 6.6.61-rc1 review
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <f8be08fb-279c-48b2-90d9-7586ecd285cf@rnnvmail204.nvidia.com>
Date: Wed, 13 Nov 2024 11:59:15 -0800
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E1:EE_|SA0PR12MB7089:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f49d2c3-a6fb-4868-260d-08dd041db260
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RWIwRUVLREtyaUQxRVZnSERWaWlnM2FwNWsxUkQzWjNkYlBnVlBtMnRjeTZC?=
 =?utf-8?B?bVFNRndWZyt1KzdId0MvVXlMU05YVHFEc0F3QTNBNzlRV1JnZWlEOWh2SW5q?=
 =?utf-8?B?UXBtNGkxQzBjdUgzaEJ0WlpVek1QRy9CeTBMRUVFZmZWM3orWThUY0s2ZzAv?=
 =?utf-8?B?c1FaUmFSVUZ0T010UlJPdW5OblNmdkhkNGROWDJaOE80T1A0azBVS3J3Tng5?=
 =?utf-8?B?QnluNVc3VjlVUXBvM1JwZ3d2ZFhIYjhKbWVPVnJwMEQyODVJUWRsT05naHhC?=
 =?utf-8?B?VWVuRnJnWUt2NFY0am9SQWtBN0NEekVQTzd6cks2TnljMVF3NmR1YzdPeE9k?=
 =?utf-8?B?dzhjcjFDUElyOGZkL1B6Q21JNUVQeHBwUlBqM2VERFBKcEJLMUFuTDl6bk9B?=
 =?utf-8?B?N29LbXZVb2dkc0ZpNXBhY3hHVlJvMFlnNnJiQlc4N3lqc2sxS1V3SWtPUkt3?=
 =?utf-8?B?RklNcUdlaWZpUjYrTDgvemovUzV3T0JMWkRQNnFFRXdxRVgzcXhDdUhLOFR2?=
 =?utf-8?B?MUdocmcwNEhTa0hCc1RYRjBLMGExZHhzcW1BOS9NcjlxU1ROTFNtQzJCN3By?=
 =?utf-8?B?TkpFdXloNlpodm9YaW0wcXB6aDgzMlFQSzJVWGxKQW41WTE4ajE0LzEyUFhZ?=
 =?utf-8?B?S0JqUkdFS2RwVUtuZStkc3BYaWMrZ1N1ZGpqYzdQVjJaR0cvdDlGSHI4VjlO?=
 =?utf-8?B?bUpLMnBNUjhjVHJVT3pRWktRV01uRFdQWFJzR2UyU0Y2Mm9mQlNzMFBqa1Bo?=
 =?utf-8?B?V1NxVllsN216Uy9Kd0VHNnIvL1FmdU5WZnVrRG9kMTJaTmZrbDU0dUx0SVRD?=
 =?utf-8?B?dWcyNmV4L1lHL3F3bzdVdTZ0OGtFSjlkTHl0VTJ3cmF0Z1A3UG1rZWt5V3FB?=
 =?utf-8?B?eVFIR2Z1eGI5U3F4dzNLWlZmMVdJRy9QWUVDeUhRUy9yRnhwT3dVUWFuU0tr?=
 =?utf-8?B?Qk1NWDN5TkRxSnNOeWlDL2xuZ09VYmxRVDY1amlHWFljbGdOc1drMDhsL3JW?=
 =?utf-8?B?Mm9jemoyT3JNeFBTa3dNdGN0VUxSZ0RWbEtnMGNxc3FiZW54YXhzY3Z1SnMz?=
 =?utf-8?B?VERmMXdzS2tQUzBTZ2xwcVRyaWdCU0NrdDJYY0MvWTVjaDhSZjF5YklTOHM1?=
 =?utf-8?B?dlU0bkp6OU0yQndielY5VEJ1MjVmYzJ6blpHYnNHTEdKNTZUMTU1MCtRK0ty?=
 =?utf-8?B?U0RnWlRFeHNoczgyKzZ6SkJRMW5sdzNwRndNS1ZtUEc1OUh0TmNFZnBRMzVE?=
 =?utf-8?B?bEJzV3NEQkxlT2QzWEdieXpyWWlUNnk5TGhZVHN6RnVpeGNUakNLWVY0SGVs?=
 =?utf-8?B?MDJjamVRUnZrdmh3QzZweHdIbHpmL2IwL0hkYTJLVVZrSWtXQXJtdGdsR0sy?=
 =?utf-8?B?NFZzV1dQR0xXUUlwOENQSmYyMWFwK3lzUmFHUnBKUTZEM1k5WklFd3EydE5j?=
 =?utf-8?B?RVBEdUtYaW5Ha2U0bHdSYmtkVGgvMlkwZlJpbUdiWnNNL0RUZ1VUeXZtRVI5?=
 =?utf-8?B?WlI4WmVsQW9LdnI2Ri9hT3MwQVkrS05vTW1QaUdVT3NTdWJ0WnBvTkM2b3Ny?=
 =?utf-8?B?bVBwcTRva1ZqdW1VL2RITndYY0FqRlUzbTBwN1hOZFoyN3dUUWwwdjE4V3BC?=
 =?utf-8?B?SFY5TjZYNFpyemRmTEp3ekUxbTg2MmNVQ0dTanU3dXR0L09jT0psZHd6U0Z0?=
 =?utf-8?B?ZjRKZVdVeXkvRXR6NEJ1MEpYY3RMTGhwSlcyelNHNW5xN2R1dHBlOHRDZ2Ji?=
 =?utf-8?B?STRnazZCOEFsZzdSQ0xTVE1ySWVJOTFCOGRWc0VETC9JT2J6TDlYVEVYYVBj?=
 =?utf-8?B?b0xWQitkZm5DbUZKZU9HdzNmSUNyUnVtQ0RjbzNHeGFOMW5rbEZURjhWWlBw?=
 =?utf-8?B?UXFqWjh4Nm41dTdkWWdtY2Mwcnl3dDgxbXFYUy9mcXNvSkE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 19:59:34.8280
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f49d2c3-a6fb-4868-260d-08dd041db260
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7089

On Tue, 12 Nov 2024 11:20:08 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.61 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Nov 2024 10:18:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.61-rc1.gz
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
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.6.61-rc1-gba4164ffa865
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

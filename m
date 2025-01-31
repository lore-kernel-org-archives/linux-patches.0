Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672701C5D47
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 13:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738330628; cv=fail; b=ubRQh+BD2JQYVYp8Fio8opfvzlap2Wi1lZgkFwTiKo/TvE+2MlUtBNfQ896LKT6HhAEzGS/c84D9v61trC8rcVjHi8WFkPNPCtX0f5Q9tgX5RtqTx5rAXYhcoSyki+8BcoeSjr+ia+7WBoK1pSU39ORzCN8HjiQLLWqxG6PJ3xU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738330628; c=relaxed/simple;
	bh=GdeK8YC4X8lz+isFJNGe3W8gVFc8IuwwJvKRkCmBYq0=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=efZDvxLpftLpZWq9vVLq5EHBsl6W/c8ZzsVOjDGUA7h3AsgjytQu+LUSdHAlw9IxccqeZjEhRaQisCFeqfkVXp0MgR2vrxWiUS0x7idN7pjji6X5twUN0AHN+4+q2GcvMyxfy6ZXEHpnSoZ35vskAIDGUAX2QUd6wHi/81C/Tkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=o5dp3VK8; arc=fail smtp.client-ip=40.107.237.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="o5dp3VK8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S56cOr0qoIg2Hnylk/vUa6BZmge0WntAE5sEtUWBHWeXHTWCa/vwKvYihNGtLA+8/89yLyzJ2uSu+x9yyjpGHNHGS4Cck4UnMi4I8Al4Tu/Rfz970xP7VLNjBA7BXsH8GNLkeEhvhtkD/cxn/Io9Ulnr4shEIJyCdkGH6Opi/jXpbGQ8RTm2beXA8TH5GnGtB+1lRel4HcBBhFQn5Uiup5X7CTyQZ5xY1hNWRRO8BbZwpLNNX3zj6iZQ130FKcvGOPC1TP9VQ2mr1yqyjQgeCVs0R+HknvawpktyfILxtxu4FVBUHqAPgw+74rhWHyBAQUTl1UBnPv6nlxNxA9wuvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IvWzSlHQ0kMJ+HD4FtEbePYuY7wjQiFWeApvr1l7DCw=;
 b=ijjfczPd3rMu4bJSZv26OJm80K7jFhcXTFT43RJJQmyfb8wZMrlRQJsJS9D5xf4bCmg8n2ApMoefoztgnxJ3HPjbRSKMMFm+AZconyMfEMzYpwh+Nuyh6E95u6HSvbgJ15B/0mXbbU4FdZe5FL/KtQeMngmMgZ6fbqrrWQj9aHIr+46pQypK8HQkyx0dnpRSYkPUhz18EO3djOik+xdJO4cOt9mOAIDFRsL9A9MOBBeVvWM5J9Of3LeYAVMkEfpHMC5nIqzEanMfcf6/Qsso5IBXgit0DgYghybBt3cRLG4Dc0N2JhDg3nbOuQNQSwXMATGQEfMMPFL/+/6MY635og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IvWzSlHQ0kMJ+HD4FtEbePYuY7wjQiFWeApvr1l7DCw=;
 b=o5dp3VK8QWDf2PRv/qr5w0cXr1sa6o3hnbwasSItUkUrZDSVYTor3WZMrdiCf67cPymkiZmeWslFR9rDGNEi9V2avkX6GOLUJEQ9+P8wiwL5XKSmJfojOvKZu14GrJs6kQEd3ZwHHRlZ+w3ygsKbpXN2EfxD0sLKixjy8vso6t3AdRQl46MiTDKXyPD6c1yY0b0thUy/0wExTb2KGljD/GhA4957U7jVyTRJXn2qZ+unlbJAHU204ocr5cgUrcQd3V1SrqDCg8A74DmoqYpDje+P1pxdjtNW+2jBhKQNic7NjCpPTmJiwqP1ogMtIQEaiqsAb/eDBGa3GkD8jJY94g==
Received: from BL1PR13CA0421.namprd13.prod.outlook.com (2603:10b6:208:2c3::6)
 by DS7PR12MB8274.namprd12.prod.outlook.com (2603:10b6:8:da::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.18; Fri, 31 Jan
 2025 13:37:01 +0000
Received: from BL6PEPF00020E61.namprd04.prod.outlook.com
 (2603:10b6:208:2c3:cafe::d5) by BL1PR13CA0421.outlook.office365.com
 (2603:10b6:208:2c3::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8398.20 via Frontend Transport; Fri,
 31 Jan 2025 13:37:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF00020E61.mail.protection.outlook.com (10.167.249.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.14 via Frontend Transport; Fri, 31 Jan 2025 13:37:00 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 31 Jan
 2025 05:36:44 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 31 Jan
 2025 05:36:44 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 31 Jan 2025 05:36:43 -0800
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
Subject: Re: [PATCH 5.4 00/94] 5.4.290-rc2 review
In-Reply-To: <20250131112114.030356568@linuxfoundation.org>
References: <20250131112114.030356568@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <c104b2a9-bd67-4b71-aeca-325b6d25eaec@rnnvmail205.nvidia.com>
Date: Fri, 31 Jan 2025 05:36:43 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E61:EE_|DS7PR12MB8274:EE_
X-MS-Office365-Filtering-Correlation-Id: c9552a8f-5f19-41c4-33fc-08dd41fc5749
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZmcvQmRud1pWYkhIMkQxQU12eGQyQ0xJSHJTa2lBZjdmZ0tBYThxWGRTME5Q?=
 =?utf-8?B?amxaS2ZvbTgzY1Rnczl2QUtkUG9DNUE1VWJIWG9YTndCLzFNSXo1ZlN6LzlK?=
 =?utf-8?B?MXdIVGE5VnBrbkFQU1VjaWRXdUJnM0JnZ2FtdHN3V2M4amRZV0dMZDJ1ajlG?=
 =?utf-8?B?bHBpYkFJQTVJdStJQU9Mb1VGTXpGdENvMGpiTGk0M29tT0xVbzUvSU9NZGxF?=
 =?utf-8?B?RGNObXIwdVBwZkFPZTlmdk1jbDhEUmoyeWdwa0tNQmpiek9ab00zTzBxWlJR?=
 =?utf-8?B?SVE0SEgzbys2bXlkQkVYYkJzQWgzWXJXWUVZd1FFN0E5UHlpOG1INGV0ZVRy?=
 =?utf-8?B?WlZOYWZkQzMvYXVFSHluWGlLZkhKK1ZPcnBBVy9uc3JzV0VHczdOeDhxdUdP?=
 =?utf-8?B?bmF4bm5weUlwYlpIZ1AxdXdRTjJwUTd1WGp2MU4zcHh3SW1WN2RBcGk1eS9p?=
 =?utf-8?B?QVB2M24ybHl4TE83WDBNaEZKUnkyUitOTTUvQ3lZTG4xd29TUHhVRkNvRXpZ?=
 =?utf-8?B?SlpRL1p1TlU0Y2JpbjRHdzZ1bDFyVmVDQk9uUWhOQWNObWpwdHU4YkZwcjZx?=
 =?utf-8?B?Q04ya25GNTZ3L0IyejR5TldmVGtOUU4xL3BVbkhhUGhrTjFvR01vbWlwYmNF?=
 =?utf-8?B?WUlwQ0NWRFVFL0tSUVpDbGwzWHN5NUd6YzFFbXcwcjZWU01qUUl5cHUrUnJp?=
 =?utf-8?B?cCtHUURKWThXN1R0OS9sS05sc1dMQWtZQVV5eGcweEErQUN3NExyVFpWWkE0?=
 =?utf-8?B?QWxIaEZRc2JraEF0cnk1d1hHK1JLK2t0NS90SjlrWEFMZmpIbWVHZy9vZDhC?=
 =?utf-8?B?WkpZTThHVmU0VHhNSGx5amkvODN6WTk4Q3Azc0JmUnViVDN1RFRTZ0pReUFV?=
 =?utf-8?B?M096L0dMVnVNVCttbXZEWVFLTTNuR3o4Qld5eWlYZGlEYVExNk4vZVRzaW9R?=
 =?utf-8?B?cGhVdDh5ekVvbzVpaHpYakk5dy9WcmJqM2R5TDduSzlLZ3JyaDlqT1V6NlR2?=
 =?utf-8?B?cFdxSjJNRVJuTWtEdlBjYTlDOEJMMXVIUStoeUFiQzRaYlVCUDcwS2p2dEN6?=
 =?utf-8?B?ZlkrMnpEQlN6eDNPaE9ZOFBROTloV3NoL05SaWtjOUFXb3N6L1BXQXJ1Wkxo?=
 =?utf-8?B?OWhCVjNRelFUU1FvaEhOMFpMclFKaGkxRGJRSkVaSlh0ekZYR1hUcUFobUtO?=
 =?utf-8?B?OWJSc0lZOFFwbDR1WlBPU01RbytmWGNwNXo5a0Y2eDJ6eTdSUWZsMGw3bkZQ?=
 =?utf-8?B?KzljV3RNRGJBc2tPTVhCOTdKb2k2anhmSXJzbXpHS0NBWEZmTWp0a2F4ZE5x?=
 =?utf-8?B?RDdldHd6Q0NFQ1NoUEprTTRmMUFXdUtBUTJ3Vk1lamk3VTRVMTBoa1ZwdFFO?=
 =?utf-8?B?VjVpdkdGblIrSFJrWEpUSk1SVEJSa0JuMTlqdk5FaEFzbDlxUDBCTGJJWXZP?=
 =?utf-8?B?Y2VLYzJ1YWlSYkNhWTlId2Y0dDhWOEVKdVJWb0RxUjJVOFgwZm83SFBTU01J?=
 =?utf-8?B?K0F6QVRWSTg5M1cxS0Y4SzZldGQyMXJQZlZEbzNuVU5KSDVkdkZjb1ZROENm?=
 =?utf-8?B?Q0Q0a09FQTJ3TXJjNnM0NE9lV2NadCtxUFhIRnFISWtla3VJaHRZQ1hjdFYw?=
 =?utf-8?B?MlhSb3dXY0VIb3V1UUV5WlVycGJXcWs2OTNEUXhrYWQzeW10MjNWbmhlV1BD?=
 =?utf-8?B?ZzJqZnRJMkNGbmZHUUFXUzNOTVVySzN3RDQ3Z3VXcWNYaHBqZU4vUHVIdXBX?=
 =?utf-8?B?TW9jTXVkcmp4OXdFQitSSTRUZFprRk96cWgweVAvUHFCVXhONWpXUlNGZFdp?=
 =?utf-8?B?MjBudmNON3JzeHJ1cUpXV1JobFNsRFJnOHRyUXZheERSODdad0p0bzArSlFw?=
 =?utf-8?B?QTcyU0JEQkorNWZxQzJBejF3cnNmVmhsNmdsY0JFYXdCM3ljRVd6cytPdG5M?=
 =?utf-8?B?L25xTlB3OENzUERtS2NMNE9zbjQ4RE1HYWJjUTNNZ2NkeEVmblZLSXlLVmtH?=
 =?utf-8?Q?u5zWJGgxrGYS19tUaln1NzAEw/qPcs=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2025 13:37:00.6426
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9552a8f-5f19-41c4-33fc-08dd41fc5749
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E61.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8274

On Fri, 31 Jan 2025 12:21:41 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.290 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 Feb 2025 11:20:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.290-rc2.gz
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

Linux version:	5.4.290-rc2-gb4cc7cb40189
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

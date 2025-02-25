Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219851DC98B
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 09:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740475816; cv=fail; b=VpeNn4q6/x7cOpiFOoHS1Rm/Rc5eMltgRq60AOq+ZX3G/0NAnpzOVnp2s9AEgTJy8u3iHrzRjF4iEZCiMUicKvCOWdd6uzaA2jjs11ymIu0/ljfM+e2ji2JcwTZBu23+mYJ5NpL423HErcZLDH3T7WIbL8LJw3SfTcsUsrDVEEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740475816; c=relaxed/simple;
	bh=l4YFMJrbYV25Zen8NqforTbX5PrMzDFlNIcKkRjdxms=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=qZO3vhnDJ7xQs8+EOMleOJQHpgeRK1kyszUUISveEg1VsD20SmGxU63p/EIsLzmIUkDrZeIsCq3fnY/SBvENuCMqGRbe7jzq+lA9oGanjuzzUBlrj3ZaYTx1zxVa4edna2mDegN7mjd1yAwUfTfp3gbdO8zEd8QXij5j9b2LHUE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uTQlXQhY; arc=fail smtp.client-ip=40.107.94.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uTQlXQhY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IBoLDFnZGisJJIMswHidlDzpSNtkFHYD1KdpESWW7nteBRJFG9B3sIz0WAz6NJ5C+zIFIgrFSYuLhGF9n68qbGtYTbDjNTBnKuOw859i5x1bIfzn2yS14Ue+h6oPhOQeKSP0OkigX3Cj2+durLT2eDH1oEyphlxdDvKc16vACr2pWqtllfkEkjJMFEVYiSk9hokpPV8heXQ6Rto2rnQGPlR3yTJthg9gmwoUegOVLaFTypkIgvpKe1IoaJs+QQoRhD2RCr1cX5/w1LvhOtXwrs6Etn9nkjdEiBO6h66JuhsvEHioTIhENnUN2kRoJmeBjV2q3ENFvkRP83guAwN8LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6L+YxG49FlmRB/L50L6Ehk/R9qDvNz4+jf3SX+cWXYE=;
 b=Yzwn3QZqvJEFX6n1fHuGy0XT0EgmE1eYyzQrkoJxIZzyfo3TLziGj0jo88CsSEfn/bux6iGj7siWV/Iw93FVC4SCGZgkSJ4uPgy3Q+tQAKtKYZod5Pd2VUsAkQSmeSO1ZVfdIY6XDIKxgLQvQMGt4JGyGktf1q5cYLl5sL+KG/I0vswh9KoVFGSAu+D/FWclwfwKT7ok/fw4uV4A+vuPtljVapnLLPm8Kq+vu6H4r1O6jS/s2D1Qnzny5y/SR2mnex8bHrBUCmgtawkU+Sxc7dJPP3LkQGjYLXt9BXgIZFcb6uwOthL6oVNbbwuYhW0Oa3CN3WJQOgp0oxXzhBVD4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6L+YxG49FlmRB/L50L6Ehk/R9qDvNz4+jf3SX+cWXYE=;
 b=uTQlXQhYfflrIbwwLHiBZgS6+j1JvuAkUXk8FlU7+TmpbUpiMcs9Dq9CO5CY4aGoQqEkJwnwDwUGcmx7MQfQ5SX83YILatG/dKChZlW+JoJSH5In7aroZrUdelFeGTW38Syk87OaG7lkhKbpPbdIifR7xgMMrUlyNWf65fDXXqSQc2joE9aWsYOqI+1DkRo2/gGszI6RMkBZylc4qEz+VQLsOw41taveoTn21fcvGFDLAuYbSaUkULQ5u/UEnKQmESiKWV+M7Y0RG1TLT9X613Xa549XjNVpBcNGGUnnQZPexULBzo8c4k7w97zrz2eT8CiIgLPTUQbLi/baG8Uy1g==
Received: from PH7P221CA0023.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:32a::34)
 by DS0PR12MB8478.namprd12.prod.outlook.com (2603:10b6:8:15a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 09:30:12 +0000
Received: from CO1PEPF000044F0.namprd05.prod.outlook.com
 (2603:10b6:510:32a:cafe::ed) by PH7P221CA0023.outlook.office365.com
 (2603:10b6:510:32a::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.21 via Frontend Transport; Tue,
 25 Feb 2025 09:30:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF000044F0.mail.protection.outlook.com (10.167.241.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Tue, 25 Feb 2025 09:30:11 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 25 Feb
 2025 01:29:54 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 25 Feb
 2025 01:29:53 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 25 Feb 2025 01:29:53 -0800
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
Subject: Re: [PATCH 6.12 000/153] 6.12.17-rc2 review
In-Reply-To: <20250225064751.133174920@linuxfoundation.org>
References: <20250225064751.133174920@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <7bbaddb9-290e-440e-8a4d-1b09716f11b9@rnnvmail202.nvidia.com>
Date: Tue, 25 Feb 2025 01:29:53 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F0:EE_|DS0PR12MB8478:EE_
X-MS-Office365-Filtering-Correlation-Id: dbb6bfd2-1c82-42bb-e7b6-08dd557f009a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?KzlHcEZaN0JVWWFyejl1UDk1aXM5dExsVzFtTGl1SEhhaEZOdGdWL0srSTRG?=
 =?utf-8?B?WmVwZE1ManlRTlRKUFdrYnRjenBMWXZHZWZjeERBekZ1aEQreXBJUWRzZklY?=
 =?utf-8?B?dCtyUVd2TjFCRXBtbUM1YUxHeXQ4Y1B6d2wvbE1teXFLR05MaGhaSlNIZ2hC?=
 =?utf-8?B?VDhYd3VJRVRXZVFHdXVSUWRYUWkxUmxYNFpzQXNlWklOUlJXMVpROFVtL0dy?=
 =?utf-8?B?cEN0RzFUa1pkaEtkZEZIdVNDWnQwYVYwenF6d3VCNzBJLzJBV0ZZaytIWDhU?=
 =?utf-8?B?SFA2YTE0c0p5VHNmaUNyalBxRDlkRzFtQi9Vcnhnc3N3VjNrUW5oZnp1WTVM?=
 =?utf-8?B?RjZEdmt4Zmk2WWV3ZE5xMmRaYWRhSHVMQW54ZjEyRzdQUnpVRExRd25NN0Vn?=
 =?utf-8?B?dEZSUEVNVDlyR0NEaWtEbWNLdXBjN3dXVndEVU1acXFwa0E2UU1nOS85MFIw?=
 =?utf-8?B?K0ttZTBHV1c5cnFtTzhCZzhMSzVmSTRuOHFLZEQ5Zmg1ekh3U01zVDYxOW1j?=
 =?utf-8?B?VWFJTGdZWENURHp3bGtqaUNrRVFhVVMxcVNpbUdTd1kvN1NlUlM1TXI4V0Jk?=
 =?utf-8?B?bGdqNEVuY0hSci84NDJ2TXo3V1Uwc0t2TzhDOUF2QnF1cDk1cTVOeHdKT0Ex?=
 =?utf-8?B?VlI4M2NlOE16SkpBcHdkWjc0c04yT2VtY2pBN3FJMjFpczRHWXp5a3lmbEdE?=
 =?utf-8?B?Q2ZlVTAwYjFZOFovWnpzNDViVGt4VVJ2MEZQK2FYcjdqUEhIZEpzaEVoSjhU?=
 =?utf-8?B?MnVzOUQ3bWxmUmliN3RjSm5ZWHNUMU1qVVYvMU5BNmZOT2Nncno2a3lLbnZm?=
 =?utf-8?B?enRsUGY4V2N3ZnQ3YkRWQ0RGODYrNk1IUVlJZ0s1Zy9od2VQVHZVWTYzWVkv?=
 =?utf-8?B?QlRleTlxeElGZHZ1Z0dYM3FJWUJ6Q0pFV3J1enNFeEhEemR1TjJlS1J3WGZS?=
 =?utf-8?B?MHZ2NkEwTzFTYkdqWVpWMWZLKzdOeHhJdS9tTXZaMWJPalRad01NMVpkRmlS?=
 =?utf-8?B?b3pBU1JCcTJFOWRYaW9YZVZra2d3WHBPcDI3M2I4V21CVGRpUVNvc2QxakQr?=
 =?utf-8?B?UnJiUVF0ZytCQnNWNmpKd1FoaTU2VzJFQmZZa0YzUldpekMxcGdpTzdjcFhR?=
 =?utf-8?B?emcxNzdXdk8veGlsOXZRNm4va05SRThSTG9QUWlXd0JQTThpcHBJTURQUEpm?=
 =?utf-8?B?ZW5Zd1FUVXBEc2dSYnhzYkFJeXFoRzR1Ym5nZ3hwcXkvWXptQ25RUXdvMjJj?=
 =?utf-8?B?QjZiVDFGTGFFTTFZdk9xekxQMFVCcmt3YmN1WFROTlhraUx0MlhSVHI4NGVQ?=
 =?utf-8?B?OEwxeFZneFdQa2ZTVCtzUXRERjdTTW5XMDNjR3creFF4aFF0SVo4MnN0TFZS?=
 =?utf-8?B?em83YTVTVncyQnZSbUE3a3JjY3FPekVDdlExdEdpRFluYmJLVmtySFFaRU9s?=
 =?utf-8?B?K1RiZWJVdTRpc255Wlp0bHdzbnVaTUllcjVQVFpick9CR0NkTUpUSU9ybEwz?=
 =?utf-8?B?YlN1YmtZRCtwdVBENjBTaks1aGx5cnowU0dQenQvcUNsL3VMYTNKYWRVaXZQ?=
 =?utf-8?B?RnYvbmkwdHErRVM2N21aa1NiT0pKUzVvNnF6SzA3d1B3b1ZLWjAyak5BSzNZ?=
 =?utf-8?B?aXlmMm83UGoyVU1jVmw4RDd6a0c1aGsrM0ZGa1JUN05qZU1xeVptWlZRT0Yy?=
 =?utf-8?B?b1dxMCtSM25YR251SWZlMUxIRHpMRVVocXJkRTdhOUZaekFaZFdIYVN1eG8v?=
 =?utf-8?B?Q1c1dlRpcGxWalFLeDJLeTVVczI1TXFOYXZoWXNaWllqVlUzWjhXVkowVFcv?=
 =?utf-8?B?VlRXVW50NXk3ekYxYWJWSlVNdEtYNlR3NUFLaUwzT0Ivemh5MVdETmROUEoz?=
 =?utf-8?B?RU9WWHl6a0FPamlHbVJINTlRLzBrVXNtcERHcXJHUkdTQWpzckp3ZjF6UmNL?=
 =?utf-8?B?a3NlTXJRZTRqYWFJck00NlRhdjhjZGQzcTRQVmp1N2g3U0dNRllPY1JHNGx1?=
 =?utf-8?Q?cHFhGDl7DAWAuXKfXQP/sUH8Vcgf54=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 09:30:11.4275
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbb6bfd2-1c82-42bb-e7b6-08dd557f009a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8478

On Tue, 25 Feb 2025 07:49:14 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.17 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Feb 2025 06:47:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.17-rc2.gz
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
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.12.17-rc2-gf5c37852dffd
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5533B13BC02
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 05:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738301975; cv=fail; b=IY2vIxk8loBpgkzJzgmn5VhkHzAviok7ulcScCe2k7iVpN7lTMCQMdQbx8/NIHII0DQ8fExah0xtd/XW00EBFLVzOh4PRJ7rpVwTxKOSye/0VcPCqxsmGNYMRyVID4JXb1ubkMFc0alHeZZZlxaJknPxM9LR6LPmR6cueNW01OM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738301975; c=relaxed/simple;
	bh=GMmCySEGhRku3hwqVKYPSrNKZ/jJVizqI0Tks2pHynk=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=O0RQz5rwnenz98dnnARLD3AEe1+3uD84vP/sYlhOq5LxcC06+1bAKLeuO7NkyhfYgmq0MD2gggw0oItor3+vNn7xt0D86MREmXV36GrKns0nMfoWWIhnyk5ctEX8O9U/Ady8kMwIgkigb7xDl1WzJec2HfI0MePueEJFWcJE0so=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tnGwtPBF; arc=fail smtp.client-ip=40.107.94.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tnGwtPBF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pkoZCTsZatXHWg+Pb5xKLeAzPuX0TJOuXuJ2UpcFjXyrIyzpI4VM6fcxnP4tQ6oWQ1r2Of0eyOtLtGdjRRaLouOWMwDWCz0wEHNyY+cYSd8paKSLFk51CJJEo4xDhtDGJ0343xZO+KdXGel6Q5ULyu3ntPy3wCxTvklZIwBPyG8gaVLxk8qO2Ou0cfcjx1IG3x5PUQ61RPMH28eF/nP3of95SxL9+TDNdj4ODof9o2mHBIGC+ugni5C8uAyOEbxuBMe5U2qWVoSPHJVSFEUNkMWh72VAS+AAaps2+oRqXdRcvvtc+pr3wfVF+3RdUrdXxOZUozItrH6jytRpw3isYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBWF6SW6ECAPgvWTVKzL0uttg3kAkHvRXHSGF0uHyOo=;
 b=cxnVy8HBHMz31MClqyYOhfcL05sewG3ohw6kP2SQBGeGvyKJ2vfh7pMkOwLmrdVMVr+I/E803suMpVR1wHIwnaP61XUQcLzQBpEk1YR0yXwM2K6BBmbtqxc194SzcpSL0OcfsALIEF2gQT7b5Syxikyc3emCYJUwkWD/aHrlgNQ7vBNU7bQD01SEZkRN5E+upHC/me6mUGc6LFrbOtS32A10zhSuy9IcscjXtRXmQysI2RayfG++vKXUzx/g5Q/8dZ3xEDayczytvL443CgmUaNjJ8xRe/McRMZ+mwVebzuDEGp9Nb1RU1XhpYncWCGvOWh6K4PWnLlJ3l0YPnNaSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gBWF6SW6ECAPgvWTVKzL0uttg3kAkHvRXHSGF0uHyOo=;
 b=tnGwtPBF8RveSvfkRpCPYajoG1SYdz07HDi+po1/P65AnWV234AnepIOjtjQVy/NFVGD4zbsiQUQIQPEMojiy0G7zcOfco/xYJ1k9oxhmR2WjQfrEhCjvDt/J8uogWijwxfqK7naJsadBuG/tiIf8RbWjyykEFD+ITeq3RhzsOLOtDlQ6V0OrfqyE55foLl4MTgZvXFfYqqlO0P7F6A7BkOs+kaimZ/xJLoRL0iGroO/W0Teiodu5Ald2BU8v8Hhn0g/6CnqZEDXHaJp5ukcqVUFBiccxcFCwl3Sh1cRMJYvyBq2KAF57ub459TuqRpffsewgo0jWMrMTVxKAY1+xQ==
Received: from SN6PR01CA0008.prod.exchangelabs.com (2603:10b6:805:b6::21) by
 PH7PR12MB6611.namprd12.prod.outlook.com (2603:10b6:510:211::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.20; Fri, 31 Jan
 2025 05:39:30 +0000
Received: from SA2PEPF00001504.namprd04.prod.outlook.com
 (2603:10b6:805:b6:cafe::2b) by SN6PR01CA0008.outlook.office365.com
 (2603:10b6:805:b6::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8356.21 via Frontend Transport; Fri,
 31 Jan 2025 05:39:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF00001504.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8398.14 via Frontend Transport; Fri, 31 Jan 2025 05:39:30 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 30 Jan
 2025 21:39:17 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 30 Jan
 2025 21:39:17 -0800
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 30 Jan 2025 21:39:16 -0800
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
Subject: Re: [PATCH 6.13 00/25] 6.13.1-rc1 review
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
References: <20250130133456.914329400@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <96335bed-dbbf-4e5e-bf40-4476f83a268d@rnnvmail205.nvidia.com>
Date: Thu, 30 Jan 2025 21:39:16 -0800
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001504:EE_|PH7PR12MB6611:EE_
X-MS-Office365-Filtering-Correlation-Id: 890937ae-3165-4a6e-7ba4-08dd41b9a24d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|7416014|376014|1800799024|82310400026|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?clJLL0FTTStxYmRXT3dGTkg1bHJ2V3UzUUhjSkdHa0NrWXkxY1Q5UVRrTUJq?=
 =?utf-8?B?cFdVVVNHaVI4TmVkdjMxVjNZelhzZXVtWE9FL3FvT1dWRWlseHpKQ2ZWZUdO?=
 =?utf-8?B?TXpDNHJianlVc043cXVsUVoramIzaVJIRXdSejFJNGZoaFpHam5TT01TRElI?=
 =?utf-8?B?QmpKM0JEVGRLSHdRTk9UK09zODhoQVQ4cmJDeXJzNjJyMmUvTGFUM1FuUmcr?=
 =?utf-8?B?SXhXVW5UQ2NxR3hkQzloMFN0cUEwWVlpL2JlUkVsZFlpZjdpVXRXajZDZktR?=
 =?utf-8?B?L0RvNUJFYmRhZTZFSkRSWTNqeHJXL2V1RUNXelZubERlNGFST0JTWVZOWGdm?=
 =?utf-8?B?QndKNDFPWXBrRDBzOHh1NG1SU2ExcnJNQ015aTRJWWhia2dmVFpaQVpHZEJI?=
 =?utf-8?B?dTRJRUdQYU9UOEw2NVBmanNMSVdWTEFpaHppeHZuVHIrcUxTSFlGanNPNEZ2?=
 =?utf-8?B?QzBldk9FU3lIVSt6c2EwZXpleEdkVUFJc2IwZ3IyVkhBaEIzZDZackpNTzQw?=
 =?utf-8?B?TXZMMlU1RmQrT015dlRRU1h5R2E5alIwZW8wL1ZwdUZGajcvZjlNUVdNcGFM?=
 =?utf-8?B?Sk1SOVZnK3RjOWZvYXByNFE0TjNKUTcxU1JYNkRwbmRGMmpudkw1QkhFVzda?=
 =?utf-8?B?d3l3cDFYVmo3ZmFKQVEzRTFOaldrQk9QZDZ5QTdiRXFXWHQ4WUlWWFJlZnNE?=
 =?utf-8?B?T0VMNjJleTd0WGhtelRpRHFXT1RVM2hRYmFmZXJpRzgvNkUyVStMQkZOaGVR?=
 =?utf-8?B?MlF3a1owby9lbmZoWC9lVlBOSlY4VmFNYUIzZWpXQ0pLK2VFYi9leWN4Znox?=
 =?utf-8?B?Vi9hemdsVm9DRDBTK1orcjlUQ0czWW90NlZqa3RvNXdjSEV3V3BmMFhwb3BY?=
 =?utf-8?B?d3BJM3ljazJUdkJkZWtDNlVuSWhEN1ZIdlk2OEJXNDZwdlJyYVlrVXBqUDNI?=
 =?utf-8?B?aHg1YlVLd09IcFlPN3c3MmNhQ2JQZU9QUkwwR25XV3N6ZEoxeS9UTG82elFl?=
 =?utf-8?B?ODVKaENNWG1LaHBIR3doZEx1SWtTeEVycExpVDc0SXAzangwbEpiNUs2cjkx?=
 =?utf-8?B?YW5GWXZyeUh0bVNnMlVkWFFFMmVucWlLVENUbWxNUzhwL2wxTVBsTVZQN0kv?=
 =?utf-8?B?enhGbnZPb0VNYTVqVWora1JMZEFpRytDU0ZzcE1xRnRBVk9tdnBCektnenh4?=
 =?utf-8?B?bEg4QmtNcERYWFRPWE8vOFdweTBLNjE5MEhoYml4NUwxSXpsSzhBdkxqYWdG?=
 =?utf-8?B?c0dKREthYjZMcjNwbWtyY0hFSlJXNHgwK0x5UVFNdHhNL3lTV1cyUVRMMnZp?=
 =?utf-8?B?dys5cGxlZ2tKNHcvQnJQRkpoek45aTFJb1hibDF0bE90L29nc245YnM2dzVr?=
 =?utf-8?B?b3F6aHEvK2VhZmpTTHdCakkyNkE1eU5zRkF0S0hYNEw5bmFCcUloa2poOU1K?=
 =?utf-8?B?dVoreUNwTXhtVmhqN3pmdmk2Y1NJOVN6YUkvWHYzVDFVcUFXdkpySFBnU3R5?=
 =?utf-8?B?cGo1b1dlWEl4WXkyaFdVcTcrK1hXeVNNY3lURGU2cW9CakdoTlV4Wk5aaG1z?=
 =?utf-8?B?UlpiRVg2dUNnTU9LdE9SNXBMNmN1Q1doZFREeDVlbUJRZTA2VXNzRG1VYUZQ?=
 =?utf-8?B?OHROdUhiNk5pOEFuNCs5Z1Roc0lQV0d5cGlTTVJGQVNEd09iRVczaDJVZTdJ?=
 =?utf-8?B?MnNtY3U5Tkd2R3owSXlhMlZZWmFUWk5QSHd1clNORUtLcWw5UFJ4eExtcXpw?=
 =?utf-8?B?Qml6aHpKMW8yTHFiYkswTE5wOEtFbjBZMHNRaGVsdFFpTFJKOXJGT01qeGV2?=
 =?utf-8?B?eExkZnFUdFF0TkJVRWExak9NdHFCNW5JZG4wYllhTStvVFNOM1lDRSszb1J3?=
 =?utf-8?B?MXpNVjRjZUxSZm1udnJwbVI3WGxYcWVhTUxmVTVsR3NZRU5rRUh1cVFLY0lC?=
 =?utf-8?B?OGZBbkppN0ZGRE5xWVJLRjByUVljbHU2bWRxd2ZkNFlEOG12MW11YUhzajhi?=
 =?utf-8?Q?s99YanDsW0u3Y+nmuvlSTW2PjamS+Q=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(7416014)(376014)(1800799024)(82310400026)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2025 05:39:30.2814
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 890937ae-3165-4a6e-7ba4-08dd41b9a24d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001504.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6611

On Thu, 30 Jan 2025 14:58:46 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 13:34:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.13:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.13.1-rc1-g65a3016a79e2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

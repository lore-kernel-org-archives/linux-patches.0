Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2055.outbound.protection.outlook.com [40.107.237.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BE7217F35
	for <patches@lists.linux.dev>; Thu, 27 Mar 2025 14:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743085985; cv=fail; b=ooI5OpNr9ODbcjChbIO3eakSjHfjqMRvBeoT9dSz/hHi4RWxhxuilGuE/na2tAgF0QI+vLC5qUM+gOsJBCCMVjY1YTCyONhcaqJh5KtmfKK2985xLwnNdZTmvsH+UqUkezm9EheBm+B8Sk4np4QkW0R8nXu7Rf8Dn8CLWUXJcBw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743085985; c=relaxed/simple;
	bh=zl/HT62LAtP2manpiNf5Nd4vRDJVQfLnHFRzLVZ6mMo=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=g5OKMRuhBq57WgvKSiTWDKFZldfzewVgS790oZvNkIMxFJZOiK50KCIKXQwC3CPK9kgZxpgNsuOYk2GzzONo3bGvR9VOldVS5y6PrLpCUiV6eMaYFmcPfqoUsTCFMdlrMUQDxQIyrwhv94pIGDJ/5YrBJz+5hal26lvsNNJdoyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VlQsx3L3; arc=fail smtp.client-ip=40.107.237.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VlQsx3L3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dxkJKBvg4sPEBZ45De1PAXKES6HYqnWziu2PCn/q6U34sQUQpHqwUlcXz81Q9oBctoRzAx0bCLpfSES439FRCgSGJodHLugpPzVsgm2oZAq8d/pdQ05KI7a+x0/vIjk2RRc3YpDjMj0kyolPSAHKeTJlF1cCN6gJQl2jhjobpSvghNiZ3A517PvoNsxhziXiFZsCxuDMA7ZazJLi3g5J/s6sQxhqbITRFu+r4rj+0fTJB0lnWMRmKVowwSXS2UfZak/GIp6YkUPYfqpCr80olCGEg4D5rbZ6Tx5QEutYcdDnfLk/t3cbwNsvy78aEyxqNWgBFze8aX/Thedh5Nm29A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m6QRonDaFZ3lZlM7+iaukMoU6ZWuBvb9xY88CGESBKw=;
 b=ien6T8whqUOEKrigW4Jbh6FMoNMmRXqSGKoV1MrWvrHstrq3CZ7n2kn+E1+O4d1ggAcqqhxkVrlqZ6zBWDs+wyO4aHc8ZK4nmJWYhNjDL3ScTQFeWKb9XGmwjLSGtvoCtcanOY8pXsKIf/BO+h+6TNbiEqJEfNU4F99iH8QZ2ptlb8kD37MAPYo7f/ouECy0liu1EUmg8w3wE1PsG7gpS/SzGFfWqor6moQIWz5NVwTxvyNf9gvQZIUt1y6ui8tp7UYUq4Gnp+D3OwsQJM3PHWPntAbjB5qWzcgN/j9/F3YeE960/MfmQzJSSqMr+yE+0i0BYDbD/OcBWGixVQsN7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6QRonDaFZ3lZlM7+iaukMoU6ZWuBvb9xY88CGESBKw=;
 b=VlQsx3L3ySrKXCEZXlQjt2dwk0qJKY1lYIav2RlsMM951kJsgm6IXdP+/kY5hdDf57ABH2sVJgbZMmuqPiyttJ0ouUDU+hb1hwJMk8/U13RFj7/VC6SdXd+o4u5TsvFOJrLTFeg7PiShqmxXH/iUGm/NWiOlh6rIqZuFL38OBuivazLbE4VQRBdEMFIsWeHzKGccsuQaBERsTRwUzMW0aSWpcYesb+6uHG1QtPE6b0lok1frQ2CDYC9IvcYT4IM7xLrP//f43ki9Uau+3a/GZaoVdTNw9Gqj36uNJvA3QLYbkV00CUsfu2MkbQAAP4Xmt0JBUAf8QBwLxgjnF+Cdcg==
Received: from MN0PR04CA0006.namprd04.prod.outlook.com (2603:10b6:208:52d::23)
 by IA1PR12MB6458.namprd12.prod.outlook.com (2603:10b6:208:3aa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Thu, 27 Mar
 2025 14:33:00 +0000
Received: from BL02EPF0002992B.namprd02.prod.outlook.com
 (2603:10b6:208:52d:cafe::ba) by MN0PR04CA0006.outlook.office365.com
 (2603:10b6:208:52d::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.44 via Frontend Transport; Thu,
 27 Mar 2025 14:33:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BL02EPF0002992B.mail.protection.outlook.com (10.167.249.56) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Thu, 27 Mar 2025 14:33:00 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 27 Mar
 2025 07:32:57 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 27 Mar 2025 07:32:57 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 27 Mar 2025 07:32:57 -0700
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
Subject: Re: [PATCH 6.12 000/115] 6.12.21-rc2 review
In-Reply-To: <20250326154546.724728617@linuxfoundation.org>
References: <20250326154546.724728617@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <794acb21-1873-4f00-963a-f647fd11807e@drhqmail202.nvidia.com>
Date: Thu, 27 Mar 2025 07:32:57 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992B:EE_|IA1PR12MB6458:EE_
X-MS-Office365-Filtering-Correlation-Id: c640ccfa-88d9-42a1-161b-08dd6d3c465b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R1FEa1BkSFJCZ29idE92TWhQTXdja1gyTkNKSUpFbktTN3I3TXpGNGJLUVBh?=
 =?utf-8?B?dWJ3T1NMQnBhd3MwYTk1Y3c3Rk1GVVpwOUxjREpML21zMzVtWG1XU21OV0xJ?=
 =?utf-8?B?dmVXazVvSUZzcytTc3JZWnRUZmNaY2NpVjZzaFZFaU5aTVF2SWF5VkUvc09B?=
 =?utf-8?B?YUNEWnFpQzJxRUh2ZHcrK25TNWpJbTVWNVZsUXNhRW80QjBPUk5JRVRVWGww?=
 =?utf-8?B?b3pJTURJbFR6RXVxNURDOFpaaDgrN2ZtdlZENmJMRTkwekhuMStZU2FiWWFS?=
 =?utf-8?B?SDFuRFJMRitWcWZxKzlwdDRUMXNZK1VHWjdGRFA1dnZPZU5mVFI5VHphakxw?=
 =?utf-8?B?RE1FdUw1dGVET1JjYkpEVlhmWUllTEp3V1ptd1czNDNFZEdMMkN0WXZGQVVJ?=
 =?utf-8?B?bStheUVxYXc5OVgvSEExSGN3cnJ4L0lpMlRBQnBQMkF0bmdFYlhEUnFFZDhF?=
 =?utf-8?B?bEFaNnNBV0lmZlg4bzNFNzF5M29sdWoxNXZydDNJd2RMNVIrMndzcVVEZnFu?=
 =?utf-8?B?Q3MwdE5WMWI2clF5aG53MThlWmdzYW01ZTl5T3I4SFA4NHcxZ0xCUEowY2lQ?=
 =?utf-8?B?dmwyUXBtZ3hwMU5qdThvMGZSTnZ1TytvTTFxQlF1VktTcUhPSS9BWVhSZTJK?=
 =?utf-8?B?K2R4Q0J2aWFoUGg3RUR4VzFkRll3YzlUK01xYmwwZ2c3Q2YvWStUOWhnS3ds?=
 =?utf-8?B?Q3VscnN6ZDYzYUxQMmsvaHdacWpGLzFWU3lHdllUMHQ4bUhCTVlvc0pURXA2?=
 =?utf-8?B?SWRMazdqbHcrOVRTd0VQUkFqTFU4SVd2VEZXZHdRMnVlQnRUbTVpamxycWVi?=
 =?utf-8?B?a2twcGVqc2lIRUlaempuWnpFeDZWVUVGczJ4VWNncTBSV21ObnY1bU42Q3JR?=
 =?utf-8?B?b2thZTgrZjJtMGZ4Y2NXSlZxQ00rOFFGeTNwVzhrdTBhZDRWb2MyTXVUbGIr?=
 =?utf-8?B?Z3Q2SkxxNjlONElqelZTOWkybnMvcXBKejFUdWFTZk1MejZiSERLVjdPOG41?=
 =?utf-8?B?RFNqUU5tc2hhaXlhVkxIeGw2SUc1N0FIWjJYSTRLd2lWU2RpbFJ2dEdVWE5o?=
 =?utf-8?B?aVprMTY0Y1F6VXcvU2xSZUhlTXFZbzdIVlhXN2t1ZGdoUjdia2ExdGJId2Ev?=
 =?utf-8?B?NUQ3Rit1TmdSMFY2Ym5IQ2pUNFJzMHhCcEJTMGNNZDBPbVlqVzlISERIYThR?=
 =?utf-8?B?ZG15WEY1Q0N5a2Z0NjhDaE9md1NHN0VwVXN4ak40MzZVQitORDBTOUJhc0J6?=
 =?utf-8?B?ZEQ5cVZ0T1ZSODR1aUR6cm8vb3JyRU4wREU0M0tZQnU0bE5lRUY2MkMzWjZl?=
 =?utf-8?B?aGc1ZmJDVmFGSFE4S2xQQ3ZZYnJLazVIVHYzOU43czljWVpPUWhocXU4MmEx?=
 =?utf-8?B?T3Y0QksweHFrRDA0NldEZGZreWhZaVBLTGxkZHp1MEFvT29PK2R6dzdjMFov?=
 =?utf-8?B?S2ptNmh1YU02NHBnTWtxZ0dBUWE1ek9YWVZlY0x1NUVGU1dON2JTbHBmRklN?=
 =?utf-8?B?VDFmZVZjRGVIejZMVDRyb1Y2WmJ3cVU2TWQ2cXA4Zit5WTNIUk9RQ2pjQlFi?=
 =?utf-8?B?YW9PcUtNYkUxKzc3STRiN0UwL2pIVHI0N3U4M05FUzk5bTJkT2pwNVVrd1lJ?=
 =?utf-8?B?OXc0dkpYSmhkcjVFSmRIT3psVkQxS0Z3QWFxU21lVExqTWpKLzZNTDUvUC9I?=
 =?utf-8?B?TGtOc0dleXREYm8wZzhHU3RJY1ZRcUU1ZVlGWVBwUW5YQmtQdGNVOE1Sc1Yy?=
 =?utf-8?B?TnJDRTZXUTlFS3NXbkRIRk5maTZoanBtU1MyR2V3dTdBTTM5bmlhczlmdVQ1?=
 =?utf-8?B?Vnk0Y2VvV3dvWEZNVEtac0UzVzAzbWRDcjQyS2licU9aVlB5NWlBV3NyUVBl?=
 =?utf-8?B?c2hhUE55d3ozcjZZMXdMb0V5WFJaa3FVUXBHeUZCVWd0ckk5QWtxdWtjbzJK?=
 =?utf-8?B?dTBtaGRpYmFaeVgzUUM0dkUvMjhMNTIxQVIvVVAzbGVUbys4NjR3Z0pLZ3ZG?=
 =?utf-8?B?N0t5L3ZYbm81WmZXaXJTYk04MlkzelZoUG04RDdjYXVFWUxUWU5lYVd6a2hN?=
 =?utf-8?B?c2RaTjRaNlM4SkJUUXBsZjZhNUNvak5CMEhUdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2025 14:33:00.1068
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c640ccfa-88d9-42a1-161b-08dd6d3c465b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6458

On Wed, 26 Mar 2025 11:46:02 -0400, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.21 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 28 Mar 2025 15:45:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.21-rc2.gz
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
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.12.21-rc2-gf5ef0867777d
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

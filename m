Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4C0126C05
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 07:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750836239; cv=fail; b=PqubXrEsKsCylacX17AhLAvIGMVgvKoS2WUad+9rPrFigRYS+VZlOh+TkoiKJnOlpeLuBO0yWxq4ndVTg3NgU130aa1P3zG/gvOUzlMlRsUzjqSb5H7JGihoBbPGhlO/AT9/N1kPcpj9WtgIDe9ClyITi28mX46j2bZuGFJw1eM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750836239; c=relaxed/simple;
	bh=KeveAAqqO10L3MiBWuyuLfk5q6O6ff7nKzmtt8YeinY=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=TShlgd9BY/G1yVnnJCpVFweD/rhUn0l4CiC5UAzFDXdLFpxcJNrJDIJC/roufee6XNgHiVmDtU4OEIKwOefbZfZYkXWk49YvK8/rPPY2oD75Dx2zlb5jx8wQog+SObeCB9l5E3CrpQwqAcmUvXXtgiK1zMQ2ZKUuepWSBOd9lwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=siDAWyBc; arc=fail smtp.client-ip=40.107.92.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="siDAWyBc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o6gJgzIvn9sWg6oRtZI1mhUUHL0VhOY77lU94vtYMBeuW5+Ed0jiUhOa73FBqgEjlO8RrrDKBYWvfYwsG5u+zx46bBWEoaiMK+HOPJsZJKOkbWygnpgm6jiv0zUE0q8+LIzMwQHLvU8Vj/XTr02OjZuNvOswqnckTiegBzfSPhTPhvLV1q8spExBXsXhOlzPaKoTn7jc7L6CapSKtUW/7dHONLT/souECX4CjwQPC5YeXBoIFo7JVTdkMeGV/Pe5/J3J4c7/VyuW7pTCXePpou6OEY6QpzJfLcrVFtAkpN6npdFW8XOBD6gmQcb9fy48DJ5qyTVrvt3+l6s3j3PTDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eRt/6ZcAdUftAbSgK4/hgL0eToNKmavK9E27px85jYI=;
 b=vZgYV92oELblodi5z8CKrMimgN512YwRR6n0j9yeWB3EZ5fa+Vr4UUOcINCo+0T1Uc4kyCFBejAZiwINQeDDI8F8iudcCoj/+/VTCma2fKvq9ui9ONVhX+uZsX9/NfsdbcaZW0Zm7kTtcOxY47U1p3SLZ5r08Y99coq+B7XHMLEz8qWaSfh1DSUUCrluFpKsAHVJzOIrxccJLjKgjuO8f3rqpB/dT03OCU3mtZadi9WjNpbyOSfH97C1K8/WS6F43zNUFQC5N0i9w+9XCMyaERT69/0FHnPIqAMGpMQbpnVLSJLTkcGaaSix33Ed4PXf8PDhvyu6T3LKRmcZfGvboA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRt/6ZcAdUftAbSgK4/hgL0eToNKmavK9E27px85jYI=;
 b=siDAWyBcVcMU3rJtEaD8LwXeVwZ/g6AS6AayiHfk7oBw9F/P3gc4kh7SV2fkmi6AZHshInH4Zt3welJLiFOMbrv4CIta8iv/sQiGiNquo5z2TPGuI3Ala3JKWw/Kk1f/L4frZbYbw2PlABADdkGlEe24sZTRN15KOPMgvk9JognWA/G5sikaUjg6OpU34hSCOcBCUsgRsopkk5ZM9kEj/5xrxZYxALTJmzmLsNyMnj5mU+ys7iKEzG6Jd26TddPpUZZSKZ0r7TBENr175LxN0a65Aacm8pI/ptVkUIj5TQQDOEyC/k5B+918D0JFmtooiCAVouIsuI8oWiRZwYKGyQ==
Received: from MW4PR04CA0312.namprd04.prod.outlook.com (2603:10b6:303:82::17)
 by MW6PR12MB8757.namprd12.prod.outlook.com (2603:10b6:303:239::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Wed, 25 Jun
 2025 07:23:51 +0000
Received: from SJ1PEPF000023D2.namprd02.prod.outlook.com
 (2603:10b6:303:82:cafe::85) by MW4PR04CA0312.outlook.office365.com
 (2603:10b6:303:82::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8880.17 via Frontend Transport; Wed,
 25 Jun 2025 07:23:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SJ1PEPF000023D2.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8880.14 via Frontend Transport; Wed, 25 Jun 2025 07:23:51 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 25 Jun
 2025 00:23:43 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 25 Jun 2025 00:23:42 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 25 Jun 2025 00:23:42 -0700
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
Subject: Re: [PATCH 5.10 000/352] 5.10.239-rc2 review
In-Reply-To: <20250624121412.352317604@linuxfoundation.org>
References: <20250624121412.352317604@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <99402531-266a-4c0e-8181-03fc80b35794@drhqmail202.nvidia.com>
Date: Wed, 25 Jun 2025 00:23:42 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D2:EE_|MW6PR12MB8757:EE_
X-MS-Office365-Filtering-Correlation-Id: 401a2d04-a090-4089-a4d8-08ddb3b93bed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|7416014|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VTRuc3E5VTVzUTNBMEVYT0Jnams1d1VuS3EyTVpDdmtTOGU3bXk1VVVxWWF3?=
 =?utf-8?B?L29mTi9sbFhSSUQ0M0RmR1RKUEgrcC9rOHZtTnlFS3dUY1VEUCtlZjlYS3Qx?=
 =?utf-8?B?eEFaanM1eEsxVmNxdjZTMlFuSGVzck5Xa0tzNFFHcDVrdFprcGxxR2dLdEhS?=
 =?utf-8?B?UmZuT1JIa3ArczlUWjZjSlhKakFHQ1hkbFJJUUVQLzZDUVQ1UWJQYVRON3JM?=
 =?utf-8?B?U3lKZXNnTWJnVXlUZDljQ0FoNUZVQWdTMWxFOGMyK2Vib3RZNk1rR1ozNGN6?=
 =?utf-8?B?S1N1WTY3ekNuMExnRG14Mm9hTXBNeDh1OVJmTi9QMk12cnNnN1Izajg5d2tw?=
 =?utf-8?B?NDErNkdsd1lqckhuZzI1QS9PZWJ3dzZRdDk5Y3ZqNzFxdXNGc3g2QUNwMlNq?=
 =?utf-8?B?cUc2Q2dkSy8wL2UwZkljc3NDbHlrS0lHTHdHU2MyN2t6TGZrdUNnNE9kL2VU?=
 =?utf-8?B?Yy9oQlBUOEpkNEgvdHB1RS9IM1VsRnJtRU5XbEtmTGpDUXY1MU56bm5udG9T?=
 =?utf-8?B?elNXeXN3TVB2OEQzcHdrMWxBQTRlSHZ6K3Z5UWFHeHU0Y2RvZlFrOFI4ZkVq?=
 =?utf-8?B?NGpSL0t3bFBsZmZHQWlsTVJManp0Y0YxQVdxL2k5NFdrSGJzQTZvU1hGZTIw?=
 =?utf-8?B?TFRxZkZzRUNhVWJUTVVWMllYUmkzVDlHVDg1STNWcDVFbTNvYis0d1hNVUZV?=
 =?utf-8?B?QnJNdHJwL2FiREZsRkJJNzRaZmgwWkNBbmdFMGtiRzladlNubE52eHNIc1c3?=
 =?utf-8?B?ZHBqZmx5Y3JyblpBUzVJeTdHREZ5cjFxYmRwbDJBb1MxcmtMQlQyOXpRY1M5?=
 =?utf-8?B?WTh0REYxaU1Iditpa3MwbHFJaWEvOHRKMkd5NVJmdkdVZXhLSTF2bUozQkV2?=
 =?utf-8?B?M29ObVArL1RaOC9IdDd6d2dlQ3pGZTBRdG1TeHQySksrTXRPeHZMbHg5UElN?=
 =?utf-8?B?Mlc3ZkJtalovUEUzQ2hoSER2anBmOS94NWtVemd1QWh6cHZqN3Z3STlpL0Z0?=
 =?utf-8?B?L2JUeGZJSUI5RWJZcUpJWXJvMlhSejN5aHMxSHdweS9XdmF1MmM3SDN1Z0F6?=
 =?utf-8?B?RXY2dFhmVk00NlR1Vmp6TDBOc0p2eURzZG1iZEw1aEkrMUJJZ3Y3UkhqL3Jr?=
 =?utf-8?B?OTNJSzNqY1Vjc2ZvZHB4NHFMa1Q5WndYTWE0M0ZkWG9TMXV1bDBUQ2tLSi9i?=
 =?utf-8?B?d290alNaUEM3bWlYQnBRdXBNbWNxWTlEcTRlUnJXOFUxcGtUSjIxaXg4czZp?=
 =?utf-8?B?azdQUnQxaHhsRlV3anNtNTNabDlHV0R0RWsxeDQ5VzJ2QUpVb2lnWjZMUjVC?=
 =?utf-8?B?WCtKdVJnUzJoUDljYU1yUXBmQ2tLVloxczJ1QzZDSjVHM2ZiSVNQc2N5cXhs?=
 =?utf-8?B?K1piTGhWYm9EVU5sZVRTVUlDYUxMTUNSNHI1WlFIVzhTcWFnSzZBZElOcWl0?=
 =?utf-8?B?MlAvT2pKN1NnMEtLYkVlRFBMdEx4WlRNRHB5OXlYQU9NR0JGc0VTcFY1ek1Y?=
 =?utf-8?B?OFlBS0tpQ1kyZjU1d291dDg0dStRR0Z3ZkVwZ2JsSU8yMXNtY29ERS9wUS9m?=
 =?utf-8?B?WXNSUFZ3dWtwbjNSbE9KVFdQV3pCS1JIZTZjNDUzV1VMVGI3TmxxZGpUbCtt?=
 =?utf-8?B?cVFTa3hIN0M5UitnZEU2TGdzSXF3VE0reGtrNlpUSEtnY3dlSGsxbXI1Sjk1?=
 =?utf-8?B?UVJ0VHQvTVhucW1ReitvK3I0Z0habmFiTW9UTWc2RHNOZVMrS2ZMd0lGT0U0?=
 =?utf-8?B?d0JpNk9qUDJ6MnlFU3dsRkk2ZjZSUi9XTFVJUXJTaXlPbVpOajR4WEV1cEgz?=
 =?utf-8?B?c2ptOFB6cnp4SmtYdlIrZ0c0QXpuOWcwSlRnd2l1Nzh1RVlJTDl4WU1kZy8x?=
 =?utf-8?B?a2l2ckJPVGxBNEFadk5mWHdtQ3BDZGlqWlBmcXowUUt3VDB3ZENRWWdyS21i?=
 =?utf-8?B?S1JBY0NtZTYzTm16UDgvRWIzUTNGYmpwS0M5SWFIcThUOVJLRUhOZHhSZCtL?=
 =?utf-8?B?dnE3ai9tY1N6eDF0NS9Qa3ZDY1ZvSCt3cnc1c08ySG1GbzJSTG1CRG5Td3Vm?=
 =?utf-8?B?ZmNSYVpPZmZNZTNjTHVnS1dXSE9BTklVZmNqQT09?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(7416014)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 07:23:51.2040
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 401a2d04-a090-4089-a4d8-08ddb3b93bed
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8757

On Tue, 24 Jun 2025 13:28:53 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.239 release.
> There are 352 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.239-rc2.gz
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

Linux version:	5.10.239-rc2-g9dc843c66f6f
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

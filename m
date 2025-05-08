Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3709265613
	for <patches@lists.linux.dev>; Thu,  8 May 2025 09:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746697575; cv=fail; b=mgKXWcLSjqDdAIagWsPm+OMUMDTDg3NUsV3PnWk0iCbQLGUBandlSQOy2XTq7c7QPqwXPjOAxSKH8DeUxfs1vLerSBBl5fkiGgCvOoyPSK0fKno/pLRxxyv7MSRJHPT9J7BDmjosvswyl6G62W2st96l9IB27INDk1UccFVL+ps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746697575; c=relaxed/simple;
	bh=kiKsLHnuUPLqeKI/kZn/2o8LXpxrxrNxwdeGVysS1Tg=;
	h=From:To:CC:Subject:In-Reply-To:References:Content-Type:
	 MIME-Version:Message-ID:Date; b=DAzHN+7diqiJcV57RvC0vFMLyIQgdNkBD/rtGgLMnpmyZ7KgV6WV8StFQhaigpYRWgWGXWIAjQQISW3L7IkznVzrpO67nTrXTm028v3bFxV36ZsJyclTsWBGWKQqLR1QGn311hRNjEg6t17Ps8zUVE14wUKMXM8L+bfFCZisUpo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bVxobimL; arc=fail smtp.client-ip=40.107.220.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bVxobimL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SPNNEQgF2JabAhfDWFqsRqRh6F14ETnx2zi40yr686tqtZjrYH9UU3k3uoeIk2tQ/m2WwOdzbbLa24H2D83VSEzcR+A2dp3ePOtGGj6VgT3DS1i5lIlaSmX4TJh3G7dc0JllEFsqkHvqXgNZCFTQg46H6fb+C6h7NNqG1bDIoITK+/b4bJigt/DD2T5rjBIA5C3aIE36K6F09xoGDR3ljiTpLxuTJCbTcsJoYBPrpP6zW8oYJv0D9kVQCf5nWycrdG+I68/6as1mR/IdZAAogGjUXICUQ/Z1Q/0Lfwft8ZOlWuqoO+KucscQle8feUb2PHz3emuAi3Ukm8wAU8WCyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l6O0dTOFpH+vVC/n/2F5xgugAQzLsO8VnZ8eLq3xHoI=;
 b=kQYgrsvYykrLTLrSFk3/JjxRcrrUH1+KNjaiyBeL8rATI7a+jL6ssc2CSQ3iXQBiRyw/mtGExwPsyO+8LrV+s65SpEpeHJbJCTJdVjh0lGfTnvL3G4lRlDecMv/kqkit3N5pUIMAoZ1DOPA/CQ2pUuvokJcb0SeiwT1GMWushz9Xox8SyBAK1XPgTWlY0tVNVoffzrlwYKYF0BaJcRDOCP16CB5DT9kZ1FOM6z5tbA92jGCJTyG9hsc4M7Rg+eWOluvl3yDAORgHutPKMg7SZArfq6rRAm3N14nbiubJPv6EJz2J8TGVaUb5mKE2As2CyD8ge93V0qC1o8u+Hty1bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6O0dTOFpH+vVC/n/2F5xgugAQzLsO8VnZ8eLq3xHoI=;
 b=bVxobimLHzMAbRGjhnMrZDtpdoaCZUuKDsvUncJZmUVSkO5gPShsFR/H8j83Ab1L7qVpMPz1Q17XLWHOw1wY/cD6R2PpimJEtrm1QfKdDSEX/FGdfsJxlSLZPcVHLHzLKJE0D21Lu/Q7gJaLdpVIkHAfR5h99Zt9UKY9hfiEzDzNTfjUkBCaGUyDn1THZTWkwEqobmgj07t4V4KpFpmguwkh0a1PJ4h+MFKE+cVXVUiOSnD/J0/uL+gGxzN/GqXoi7eloU5gvFCCuHzyVNoUfjA2FRvtMZtw3Bvdfz+JSVyJ+sfPayA013Bnn7nt8KTsReuiB5VWiJpztmF06TCjrg==
Received: from BL0PR05CA0005.namprd05.prod.outlook.com (2603:10b6:208:91::15)
 by DM4PR12MB6495.namprd12.prod.outlook.com (2603:10b6:8:bc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.23; Thu, 8 May
 2025 09:46:09 +0000
Received: from BN3PEPF0000B06B.namprd21.prod.outlook.com
 (2603:10b6:208:91:cafe::85) by BL0PR05CA0005.outlook.office365.com
 (2603:10b6:208:91::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8722.19 via Frontend Transport; Thu,
 8 May 2025 09:46:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN3PEPF0000B06B.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.3 via Frontend Transport; Thu, 8 May 2025 09:46:09 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 8 May 2025
 02:45:44 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 8 May
 2025 02:45:44 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 8 May 2025 02:45:44 -0700
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
Subject: Re: [PATCH 6.14 000/183] 6.14.6-rc1 review
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-ID: <12145921-d8d4-4a45-af1b-79f9326a4c1a@rnnvmail201.nvidia.com>
Date: Thu, 8 May 2025 02:45:44 -0700
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06B:EE_|DM4PR12MB6495:EE_
X-MS-Office365-Filtering-Correlation-Id: 18bb7985-d6c9-462f-8992-08dd8e152943
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VzkzN1BJRUhoUlgxZFlOYVJsVFh4REVtTXlRbndLTDVHbklIS09tR1lpbDh1?=
 =?utf-8?B?MXI1V281Ymk5ZmZSMldRSmVLU05zRmMvcXhzSFNUR3hHeTZ0OHZKOHB4a0pB?=
 =?utf-8?B?UnJoQXoyNWFIaVNoK2JLZ0RiUjd1Z2ZWSXZ6S2N6QjVCSGh0TkJHc3BYYit0?=
 =?utf-8?B?U3E4UEZqM2RoaFhFelozY2ZHa01wZ09VOHJYbXdsWm1FQmdkbTA0TWplSFZ5?=
 =?utf-8?B?U0ZERVRsQ2hMZ2VEMUhqZTlKT3hQQkhRTFNKMlhlclV1VUFGcnZXQ3ZZQlhW?=
 =?utf-8?B?b2RuTDRIeTJjOHI5MjlFZWZKdnVEWGtuT1dKUGNXOXJLbmFDRUNPdWc0eHhJ?=
 =?utf-8?B?UThpc3FUc2RDRVd3NGsyQkYreGVxWGF2dklvU3IvQUpBT3duanZnbGNDRGht?=
 =?utf-8?B?dTZXeUxqSUl2T0l5UjdUcVRySTV0ZEJYcGdEWXRUdFRwM0xuR2tCQXNJcVp6?=
 =?utf-8?B?VkhjdWtLM0I2RzBZNW5QSWt5eExwbFlreHY1UUxHZ3RNLzR3VHd2Q1NYbTJr?=
 =?utf-8?B?dytRTGl1L1k3c2hBMFpSYVVFdXpOdWIvNDlmNWgwQnFVZlRDQnhZZkdGclFY?=
 =?utf-8?B?UkhFUmR4eVh5Rm9QSGNmSUpUREhReHZMVXpZbGhCSVpiWXRIRlFUeWJ4bytZ?=
 =?utf-8?B?ZWc0bG40QTBDWlVxbHQzek5EcVBFaGR0c2tod0Q4M3FTSHdPdkt0WlZOaFNG?=
 =?utf-8?B?UG12NnA4WmRQQmsvc1RhU2N2OFV3eHlmQ2JReG5VQmYxajlKMWZOcDVacTBW?=
 =?utf-8?B?MWJtVmRiTXNWR3lEZjlGSnNSL3BNK0JnUlgwOEFqeTFMVkh2Zk93ajl3c3I2?=
 =?utf-8?B?WnhtemdzWE8xMzlZbHJ5UTdGN0VoMVJseTNjVWJiUW9RRUZGclpkUE9HYnl1?=
 =?utf-8?B?SWlQYVlwVWJxOTBqNWFDbHhMNUJFSjFESjlNRkdJUGJER0MyTm1BOSt4WkxE?=
 =?utf-8?B?Y0FpNGFZZzN5alROL3ZTYjE2ejI3eWI2ZXBCV0hqNUQwc2YwdzNNemhMMTd3?=
 =?utf-8?B?eHB1b2xqbjRGWHp6SXZPMFNwNy9aSUF3SHo4MEJTcW5sZFgrNmdTdkhicjQz?=
 =?utf-8?B?YUpGUjFlR3VKUlR1ZGJmV01vTDZoMkdXWWI5a1ZudzcrWkZNUHAzVmZiWDJF?=
 =?utf-8?B?dXhmWkJQNFNnc1F3dmR6Z3padkxDdGE2allhTFhUdUJ0SWpzUWNSMmdDYnp3?=
 =?utf-8?B?eHQvR0drUG13RlgzNjdFYzJOdXpmZ1VtSTdYVmUvZnFBM1RhNExnNmZ6WGlI?=
 =?utf-8?B?WE5IM25RV2NyZURaNmxyK2R6bHNDUWNMS1VaRktYTXN2QjN5aGJhdzFuWEFs?=
 =?utf-8?B?bm1PQ3c0M2x3TnRITGI1LzcrSXBHWTBTKytoRXY3S2VTcVFOWHJzWktXbGZV?=
 =?utf-8?B?VXlDSlMwUjJRak9vMGdibEwwQ01TR29xZXB4M21vdTFnMnBEdHV6QkdqZUov?=
 =?utf-8?B?eS96S3hwOWRpUisxVVBDSFlVUGdJWENCUS91S2FTUnphM0FTQnBUZCtVZXVu?=
 =?utf-8?B?TVA1cXJCM3ViTXdUQkVkSzRuNHl5bktkNHR2OGF5STk1RldtcStTSkttZEhp?=
 =?utf-8?B?ZjB0Q0JCc1NRaWlIL2JHYXFkZXM4WUpkNGFVZXpEQjFuNlNFbDJ1M1kyRllv?=
 =?utf-8?B?VitYeGdXa1d5Y0xSVnZobEYySGcyak5CSit6OWJ3SHQyb3BzMFRjUkRFblFG?=
 =?utf-8?B?MDlpUjh4Ky91U3JjQ2JYd1hmWWYwZ2lhemVsZFFCTVY0ZzFqUktqWXVSQ0p6?=
 =?utf-8?B?WERDbUp5bGRwZnIwWUlaREc3bVE2QkxKK21pWGVKM2grT0ZoZit2NGdybHhQ?=
 =?utf-8?B?aDJsOVArcjI0VWc3Tm9reXprN2tiYTFtK0ZMMjNRc3poYUZobG5EbEZoYnJl?=
 =?utf-8?B?MFVtQmEzMHdwOVhiRUNCL1d5VUF1R3F5aUlsZDk4d1NoQ1lxMkM4TXZvcEVw?=
 =?utf-8?B?cEdJZGJMeFlBL1lNZWZKNk5xaXVKdnhmYlZtTGpLbmdPVGxhSG5QS0lra3E4?=
 =?utf-8?B?ZjBmekxLbE1IclFoRHJ1YTNuRjFhbVJLOVhFZndkVjFCUnZVdWs3WDJyeU9k?=
 =?utf-8?B?aVA4dW1pWDhmUUN3bUdTc3BEdkM0NTBFKzZlZz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 09:46:09.2253
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18bb7985-d6c9-462f-8992-08dd8e152943
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06B.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6495

On Wed, 07 May 2025 20:37:25 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.6 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v6.14:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    116 tests:	116 pass, 0 fail

Linux version:	6.14.6-rc1-ga33747967783
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra186-p3509-0000+p3636-0001, tegra194-p2972-0000,
                tegra194-p3509-0000+p3668-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon

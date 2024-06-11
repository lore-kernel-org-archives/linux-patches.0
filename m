Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2077.outbound.protection.outlook.com [40.107.237.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6004C81;
	Tue, 11 Jun 2024 00:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718067325; cv=fail; b=SUq0wUKzfTJHpnywBsn1wpDt6R2HiVdJQL0+5u6gNLOVN8XR4e8gZkVJomegXUhXFRNsSxXx34Yf1XSfbVkNuT4EuXFRS5BMwiEZYNtf+emR+CFDw0XYpSj2GbRK/QqmqhcdlTrbHfd7sJGs/Vni+t/+swdzQZ+QjsWVlBtRPoA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718067325; c=relaxed/simple;
	bh=21YXplafoBmuJw5sKlez3kdNaouD0SORZP0CA8iFvKk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eu++4YyI19A6glPMQCCK3hQ/pzLrhToT/SvxoCwo6vJU9TLVP/9+f7bqGNjYF+CyiOMNbz1lD8gh48btWKEgDUo98WHdNj7rK5dPsnN41v1N6x1ipxHYDNb72HYNkB2RBf9AF9NdlAZnlP2onbnJ0Zmky20dRTLnDA/LKq0+8+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VPzx0mxh; arc=fail smtp.client-ip=40.107.237.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VPzx0mxh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+hoR/Gf6irnvqzsbs8zQC53jcIj09dAIyh2syeKlxJS4nKvloC/EpSpbQpJWcphQkO7aOa4bzhmt8OEf+vKux8xhY9QzCxgOLPETfcoDW+9hZaCS5ZUN9IY8+bAODpCDCVJyNC6MeImsx56zfII4yGJR3kLNL7wrPtdn2h185QDjRMBNe/RZQfrRVOlz4AqiUa37Zy2JupS4rVQkXg2vJSrYaFT0DYDvjIWO9QXxocf/3x0nvOreJb1rc3GY05W6uvnjylYu7bgzqjq7NRN4+peKMGcqzbuR7aWCPlD/bkBgrgFloNfiv95z7kji7xsdoMItnQivDZvNoL9X1LbmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nbyZfyFDi5fkEUBLrU731zOikpsXx1UUDb/gQMd06LQ=;
 b=Vg3SKlqRrpEE522YYeprLiX7GjVmOqJFIHn3Z1hOLz37prjfKiEspE/dIDk2CRxOPjebokqKgTff+6wL76r+XYlCPlEAJTAabI4F3lUNOW89RlCkqit2bofTy1A3fxIUJypWLZSsBvjoidIyk5zwoNnvKbV1YPX9eRbqbnOFr3FLCEP4FRZR4lCKiqrtQFZa8BTaATpHrur5vs3/AcdRclkMbWLgYUZjbBF/KbjoWzqbELET12SqBrv5vPvzrv/sV31LpjQQGWqvQD4W7OL/cnPPlHhpBpky0aVvx4Y5id1hkXiZ9uc8w4t7JQUP8zEASEbH80iqTL8vvV01uxbkZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbyZfyFDi5fkEUBLrU731zOikpsXx1UUDb/gQMd06LQ=;
 b=VPzx0mxhii3kAQybHKAR9v7CFc+wqxclION9qCie5m5vjsEhTwpp7C0vsc1nxAFYwV9eUDDj2R3wCUPb98N8t1M06o3Mf/aOhBfrNlwybaQJqkzICKSkwk/4FkaYWJvESboNLW1MvE5ro7HuBOqjzqBhNYMr4QfkCuJ4jHwAOicIpxlIIWiVeQsm0ZeL7wwdjGvKjsVh+TzfRjgiOCu2zqHcavs5mcVrmJ/Qtw4TV4V6uAULY4Zchhn4SsTh+tfW1Z0uLOP2JyieCtEbvP2hG+BPGWcDqa5+rf57hsALUYmzMFSlzYqYZPBiteGt5eb0baQ+pG7wvLQT7Ds9U+da6A==
Received: from SJ0PR03CA0377.namprd03.prod.outlook.com (2603:10b6:a03:3a1::22)
 by PH8PR12MB7231.namprd12.prod.outlook.com (2603:10b6:510:225::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 00:55:20 +0000
Received: from SJ5PEPF000001F5.namprd05.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::15) by SJ0PR03CA0377.outlook.office365.com
 (2603:10b6:a03:3a1::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.25 via Frontend
 Transport; Tue, 11 Jun 2024 00:55:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001F5.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Tue, 11 Jun 2024 00:55:19 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 17:55:11 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 17:55:10 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 10 Jun 2024 17:55:10 -0700
Date: Mon, 10 Jun 2024 17:55:08 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v2 02/10] iommu/arm-smmu-v3: Shrink the strtab l1_desc
 array
Message-ID: <ZmegbDzD2+ePJ6bQ@Asurada-Nvidia>
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <2-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F5:EE_|PH8PR12MB7231:EE_
X-MS-Office365-Filtering-Correlation-Id: 20b7c76f-c928-47a7-7fd6-08dc89b12ace
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|82310400017|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vLN5lbsZEIdVFFl36/xO10S0tAd0REfzt1yVejorGArMM+CyMoBlY7ZzZtkV?=
 =?us-ascii?Q?UxtaNtl1283kvdPvSXQmMsG35w8P9wLQF2hnbv26ELwoB6XJb3wgEuO125qf?=
 =?us-ascii?Q?6HKtprdrWQObVD5LKtnSEO7XyNbmRjxER1lznm36bvqJIdkLztB/WJ/m+UZU?=
 =?us-ascii?Q?EnFwSJiLq5CCuOfP9PUbnX52Co3EFNIaL+NJT+2xsBbKKOTLu3apJz5REp1Z?=
 =?us-ascii?Q?ngZTn5FpmowqhyaANbo0LrOqjt/SZUwBcNk3/kn/Z0m1DEfRZrfW/Cqb3rsp?=
 =?us-ascii?Q?oU7SiZYRqZ2zqPO4a6HbCFh0E2O8LTWMxKiPENpClPHoYCvsvgJQ7bygpJTi?=
 =?us-ascii?Q?EuHbtFP/wxFRhoBP0/kHxe914ksGf4aqFGx/mFbRTvyQ/yeapRiSIE/25j1D?=
 =?us-ascii?Q?N8eP8fjbHNNPI2pPHgzrfcZN9wOjP+RPPueawhfH1QB90bzgm4GfNM82U20M?=
 =?us-ascii?Q?Eg/AbM9Ae2OAr3C7iDT/cSurbahgatT7i8PGVJXghCicm5PZO+etfc3+54Vx?=
 =?us-ascii?Q?9dLwgpspxts1ceXdwoBdTVAqD55lKb5eVpWsZMpWEaraJU6KfHr5CvrIMktS?=
 =?us-ascii?Q?PQXobA5Wa1w0Gcr4rlSW6OQHYsa3TRvmIgv3yR6HT/YhsZ5XVDn8swtwbGOY?=
 =?us-ascii?Q?Fp0Re56w4a05HasuFcA4oXr6X4QpM4cz7kzRigUBhKX2h0muQJ+H84QhMihe?=
 =?us-ascii?Q?2sSsoWH9Q76LY+NzG/AJjoDHC2Wajrv0EwJs/xS05V5FrG9HZK/pCeY+hXts?=
 =?us-ascii?Q?5cJ+0FXnlD32+s/I3pAZzcPSS3PxvQgV0DHHCxnC0Uk+Cm9aPf3LiRNFCmwA?=
 =?us-ascii?Q?fqj0z0ZErhDVysYappAV9Z2Wn5lQeynvjJS0AjjOwBXQF7Gy/N5YoJYEqy1O?=
 =?us-ascii?Q?2PyceEeV7MYLj16xXCbQyAkXm8DL44DOFQyviogCIJ1LzDlmezwVLvJ0mYm+?=
 =?us-ascii?Q?1No+zlSJZZo6nLPQ13SZqZTrMtZ3d3ROuShG7DyiwxdSd13Ff23BT8SkIvTV?=
 =?us-ascii?Q?t27A28VG08FMb4uicFN1SRS5soihGsYJSrhd9tktxcy5nJcvsFYvLfDRZNQU?=
 =?us-ascii?Q?Kfx/rBHXoGkAW9zhRDXZ8S3M1ZWba8ett1U3t/b/2zw1cPHfqYA12eevm1n9?=
 =?us-ascii?Q?kq/oztSHnQH7X4xdFgKNXAGiI8vvhWKsXx368YIEHELBJMMZ34/rj6k00tXj?=
 =?us-ascii?Q?/qIOSyt7GhSvjjXsz00mnnyVBS5KANwDkWoR8efKfdT/XIW0e+PIpf8d/Bts?=
 =?us-ascii?Q?pnG+S17DnPPE62ekxxzDN9JpiBK4SI/77eCnuWWIFiCv3NlFEKVQC/7x8J9R?=
 =?us-ascii?Q?kQDFGq7OQg1euWifWHDUrSr0lQaR4SfcrDKOK+6p8+MeMtEUJw8MD5eLTvJg?=
 =?us-ascii?Q?QPumgWQo+9N/y3o3NOVxMTZk7nnXntEhJInS7XQ4G7goAv1CjA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(82310400017)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 00:55:19.9848
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20b7c76f-c928-47a7-7fd6-08dc89b12ace
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7231

On Mon, Jun 10, 2024 at 09:31:11PM -0300, Jason Gunthorpe wrote:
> The top of the 2 level stream table is (at most) 128k entries big, and two
> high order allocations are required. One of __le64 which is programmed
> into the HW (1M), and one of struct arm_smmu_strtab_l1_desc which holds
> the CPU pointer (3M).
> 
> There is no reason to store the l2ptr_dma as nothing reads it. devm stores
> a copy of it and the DMA memory will be freed via devm mechanisms. span is
> a constant of 8+1. Remove both.
> 
> This removes 16 bytes from each arm_smmu_l1_ctx_desc and saves up to 2M of
> memory per iommu instance.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Reviewed-by: Mostafa Saleh <smostafa@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

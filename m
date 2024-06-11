Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2044.outbound.protection.outlook.com [40.107.96.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE73F9CB;
	Tue, 11 Jun 2024 00:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718067060; cv=fail; b=QiNprjs7KKp+DxHlBLNnwr2CusH7E62CpqrXBAOln/Dmy5SN7Bbo6ZQPmVugeuTcvLW3DYkARgZ/Mclf48aKmkNbXVXDaveSk9ogNG2VhEZCnzPOCT4WlOs9Bql8YZwr2Lo53oo9+DGNwNB63qT9ri69fRWYx7TDDpFPEmrOMoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718067060; c=relaxed/simple;
	bh=kVk9KTi449V2JZD0Smj5TjQTZPP4ieJlQ3nBbfgf9OE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mPJDFWy19IMbfUEgCx9cov4oeTzGiV/zrHdzoIUpk7vIbU2vmK/s18kd1gl40WWmpmQyjuqzZUMFXrz9P3BbIudsCo35Ej6veus9UYchArYWZzpJULO3488QACFuk+/p+GVYXVaPOtWezRUNDuiucamNAf9suPjAAea5UrgBV5U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EyTVVYvw; arc=fail smtp.client-ip=40.107.96.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EyTVVYvw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UwIThEAtL/09dF+FlQFPtTlisgNZSlc9xKo9bv6ppcudg5OuMUZxwUuRtLD7HkTdO5k5jUzfRsJVpFbi2fYgihMoj+FCgpAZ3io4klVQ9ee1p35SCrr23ykCsrPnu57+J/z5sPd0i4UAJw1cUn3ShGemi/2iCERk1wgIaDcebes7EQM7qDwYtbTfzmavGRoWDlJuxyT07M3Ne/Ez/WN+oGcwOoSoSvwlw5ey0xSUOQ24ijAGBN9ksJaSPbimEGGw8cax6pH4XqIqCop3xhr6WGjrcczbMZel+4ngNpcTZAzeXlo57+cBbAMtqFIl6UQIgHJ36Fulh3sQ/pi2yGbWcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRBYvuoGL0UsDfwXQV8G2Y43/OOz6wXSC5uw1g5hWow=;
 b=IghjPpqLVA6e5uEH37qKpoTGLxsHl3No6TMduUqGpVAf1hSK2aI8GZ31E44+AjDY9bxD15spIt62FeICHliD6JiGClmUPpwBGnYAF59yqOpHLgR2LoxpXMUaY/ylpzeyNU01ekTX0bxP+wOAZEwqKYFTwlhKYb5BJ7i9LvpVFGU9ak1L21/qEsAxkEzQCFlmC6ayuJ2+2+2vsLhTBZ4xQ3KCKaHI2495ZLzkZs+qILepW7ZCGchpy/lOGoLiDQIyyfrkDZ8FWACTpiO/LgwG8o4pjWd1CGCx4wu/su0kRNztVJHtmYoR8k1lhmsTHpikiIsyvvZQEWi+R0IXDTEh1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRBYvuoGL0UsDfwXQV8G2Y43/OOz6wXSC5uw1g5hWow=;
 b=EyTVVYvwFVGxe4NxpcV5YCP95QCSHQ50q2Y+mz0bC3FZ0+Uf43lhMeyfKlSioMmviqHf4qMFNKmnaD3BqEBtjzf4gACo4vRgLq8bQC0gzA0m/QTI123I6r+PXYr5rnqcd6qfRy0GiMaoKRw/5AfG6vBak74sBMgij9iX0ecY1Imj27mFOKMylMD3nh2vDEOW/3MO8H1T/IScsnJCbf38hxSKzxcsEqjq27k7IUm+6KHzZKOTIDX7esVNriJV0DBRd/zZzBDCAtIo/ffjOUpzg0I5OGhOKTA/vxdHO44+A/5l+gF+6PBc3fdyXoa82ii4m5f2FODTz4XRZX/LjyBO4Q==
Received: from BN9PR03CA0478.namprd03.prod.outlook.com (2603:10b6:408:139::33)
 by SA0PR12MB7092.namprd12.prod.outlook.com (2603:10b6:806:2d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 00:50:56 +0000
Received: from BL6PEPF00020E63.namprd04.prod.outlook.com
 (2603:10b6:408:139:cafe::5f) by BN9PR03CA0478.outlook.office365.com
 (2603:10b6:408:139::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.22 via Frontend
 Transport; Tue, 11 Jun 2024 00:50:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF00020E63.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Tue, 11 Jun 2024 00:50:55 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 17:50:37 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 17:50:36 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 10 Jun 2024 17:50:36 -0700
Date: Mon, 10 Jun 2024 17:50:34 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v2 01/10] iommu/arm-smmu-v3: Do not zero the strtab twice
Message-ID: <ZmefWubPMwggmtKW@Asurada-Nvidia>
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <1-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E63:EE_|SA0PR12MB7092:EE_
X-MS-Office365-Filtering-Correlation-Id: 05dad993-9fdb-4984-69c9-08dc89b08d6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|376005|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?W/uFWzNuntp3e6HPI7F0EL67vffD3xMaGGv6JzMd6md1qL/Y52G1yPvR023L?=
 =?us-ascii?Q?zNnLRc2G/Q7mPYGTpG0DLYb7BBprQRlRDpAU2f+jhHeuBXsGarQUBPXsUiHF?=
 =?us-ascii?Q?6MOaLgpbtHrs+0sJFoUPanNxqWB5D8ArvQTTrFclSlU8a0ybD+H6sX6djgmk?=
 =?us-ascii?Q?7zqSQnsxQ7XyJe7OMUM0elw9MIoU6U+xBfMbsc7Wt+7wavUWckiBTOtued0Y?=
 =?us-ascii?Q?hYeHyyy7XaWBs5L1XLctCT9h6Q9fcBqr7cKXEvA31uu22SO5CgkF/aT7S9Uq?=
 =?us-ascii?Q?YtDmmjOdE0ME3UyMJQUWv+NCJGxK4iFoaBNgctK8HSdjpUMFAXwY8uxUdVaq?=
 =?us-ascii?Q?3Ie2oCE9vviNGkOTM6hol0M364l/REnW7zr2dE4WmnnKZpJr5dMaiQW+zoja?=
 =?us-ascii?Q?EnZdKWz6EWLlE/JzAd6dQ7pge67ELS2bPMm8Nmt35nOPnp2N5tKQjL9cxzEh?=
 =?us-ascii?Q?1X1Yjcq/ATEMZoeSpByg5KkM46XUYQTg/A8+eU0r/oF2v0a3xv1CVaijfrhi?=
 =?us-ascii?Q?DwXAB1e/Cr3nPxsAyLwZQXmq4330NmsuNpNXeokr0u8X+ZLN2bLYt7gy2sE9?=
 =?us-ascii?Q?h8nuXWKX/4oXPVKZbcGTxbbwHAaGthVkXF96wXFBTU8USH9Ffh642myBT3Y2?=
 =?us-ascii?Q?j1TB0AeNcMOqYPQp/4QtySPmQ29e1Ua9k/bSwcQ9L7Th90L0GUn9QDBdwxYO?=
 =?us-ascii?Q?8M/NJZXrd3rTQVdDgJhQbckGSwDDDsNv5KhDpGY+2pjfIBpYCLbDXw0gCQKJ?=
 =?us-ascii?Q?4uboq5rOLuTRZdWNi+DD7+dJM91/l6ckP2qpVgVhYPZ4WhPxrdzK4iRIKerj?=
 =?us-ascii?Q?fIA++cDLbZqUSy/HJ1ijKLrh0O7BL8kJnUiHFvzURQ1sAxf77EamNQ77pIXd?=
 =?us-ascii?Q?kPQkEb2WJ1IRc7b49jb9b0+plG/RV4UGkwmJsgUBT5MWcRFtIBw9etVmonMq?=
 =?us-ascii?Q?h+hec7l/uJiVbf6dnKM5xFznt5Yc7pbPGfjOrVIorf2sT1pfSIB0bBVKlOxH?=
 =?us-ascii?Q?b0QmWtdd0WlJu/6lyh6tO372QDzj9Ki27Wz4CLffGVLSBBZjRsx7zXQpjS5D?=
 =?us-ascii?Q?t6AqJ5Nv8xYaWp74xEHMZQA+qMq5T7W8RMvDvHxsqfKnqC6krn1p5cxQmHs8?=
 =?us-ascii?Q?BmglNZ8CjqfM/VexjrmMGtmIuxrJXup+Qmo++M+sym4nSMPb8y1nRcEbyjvu?=
 =?us-ascii?Q?6m1+TWy/v47Plv3RpPWTpjTbH8eWVyKRTmzdQlrtZVtVpoFdiGrqLnRXWk06?=
 =?us-ascii?Q?Ur/ZrWXqirvcryfXtq0/VioPZWgPKGuaweoU9rMbiuRHU7BHQ3jRl+2CYUDL?=
 =?us-ascii?Q?O5RWcEU860NuuOv9hQIc729Rhyt2vh/LgAhtTcPbD0JMNbAlkdn0DrDnvUEe?=
 =?us-ascii?Q?k0pguJWB/Ropljdkgy9Eex3sl9kz+rIvAVS1xyVvfo4nX7PFkQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 00:50:55.7456
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 05dad993-9fdb-4984-69c9-08dc89b08d6b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E63.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7092

On Mon, Jun 10, 2024 at 09:31:10PM -0300, Jason Gunthorpe wrote:
> dmam_alloc_coherent() already returns zero'd memory so cfg->strtab.l1_desc
> (the list of DMA addresses for the L2 entries) is already zero'd.
> 
> arm_smmu_init_l1_strtab() goes through and calls
> arm_smmu_write_strtab_l1_desc() on the newly allocated (and zero'd) struct
> arm_smmu_strtab_l1_desc, which ends up computing 'val = 0' and zeroing it
> again.
> 
> Remove arm_smmu_init_l1_strtab() and just call devm_kcalloc() from
> arm_smmu_init_strtab_2lvl to allocate the companion struct.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Reviewed-by: Mostafa Saleh <smostafa@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
 
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

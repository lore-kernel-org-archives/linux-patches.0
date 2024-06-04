Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F403EA69;
	Tue,  4 Jun 2024 08:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717489963; cv=fail; b=kKwa7egjkcmqG9gGn3r4TBj3wx5vTvoZ6tlseZnmMUfImitZwrVBFwmIZC77RSHkSVWohhZJ+UgGG/2J1V2Fhq2a91EkYUQyCVBMkG51/R/G55Qwh5txpfLZewBuO1u5D2kJJ55sMjedr5eZPnYaSOWgDAupDqXssf7foWZHnd4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717489963; c=relaxed/simple;
	bh=X64utJBkSIEsrpv63zMywS/Ms8yG9RhNU9ykD7FIJPM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kbbuhDUYx0Fc9bQS+N+JtY5dQtW36jc0Mgl+RUolOVu28QxmGhmnQ9CrOrxI90b/MLCHelMAvNMPq5L3Rnaq/dTraJjjK4srDZRSqlxkUtpDvWUN8N0p7qXIojEjX6OxQQRZEwiRSoDcoHr6EcEHXjwbkq+S58VnMu64mX+nJjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WnkyQne/; arc=fail smtp.client-ip=40.107.244.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WnkyQne/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kuaLbBE52BDZjiDqmasryWfih4yuJqVUZn1lOtlbAePrASCTaQiJh4BZF92NxKrARHShkvrasizlKOTeRnsFKxrdkAcTHY6SNRnYmaedF+RMqrOKICFB3sWXM1tbI0Ag0if0kq/wVLdtnXs/phvwyeIU5k/evJUPn7wSSPs5PjRGSwn+9hbh8+AzpgVTAUBQnNe/nBpWBwEeSvYuyDPmNf4gc/KKub19nCP0dHd3GLiocfW/UysnmBvbkAWaoVg7IhspQhAW8n8Lx3CqiXUIwVhC225az5OzXl4sH/Da/p6VKA8T8rdGlfz/kcSWaKfqqVxvbGG08Chfj4XpfxlVnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+9Sibu6GNE4yC1pqb2y5qfcQKAcgeh8FxZv6STBZf/g=;
 b=hlqRJgkE9m0vPtNErPwTGB+Kcj0yC6BuRG5Iv+YQReGo0tUoQTPiSxkc45yRqzSRAAotB1GX/dLGXGT3yKpXGJTQBEnsrt1M/Rbi5iSPQlJWeGgCSPsMOfHv0n8oyKmszWlLcxCBZS1cbOhtG0IZamRqLdnrwI99DXBU03iSZHiN2JIlz7N2RPoIuRAqiFF8y3Gr9nfjgd4L1qqQq7GEy4lyXLbskIrHUNDvrTTASUxm00SMuTkONP0Flso9dOMcdyU3sEhuwKvMgZ0WkrR4hIDQYiZnSE0IOFmTULiIjU2jHRiY4FrTk7FvGo8yVkpnkTkruewkOWlyU0YLktcKAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+9Sibu6GNE4yC1pqb2y5qfcQKAcgeh8FxZv6STBZf/g=;
 b=WnkyQne/w+9SKWF3KdSzvPMe2VGXdcgxTyri2ltPK9DKhHblSyAyigVFZeGy3d85RhuKseskG13eP+eQJNtZ5eqCi6CyVw7PHeGEYOJHcccg2M1da6OhwRXf32F3sOjWuL0GY9oacxLvYyPqxUqF7Z4JpNTG18XY6rc21xo82wRxD8X3dIigLEPxZAuG3YTWlHAwWI7BSOhzWPHh8FmSQ1YkFkcWoO4gDHEHg7bm7ooKdaoonTLBUmVTRPSZZH2IOD6XCxORuRcFUW7MNLJrfHE1P4LvIy3EcBjrwbP+Eo/WfY3X2u5H9+/YKUyULI2Y/mUSVd1kVsbq2QQGwhwSOA==
Received: from MN2PR16CA0059.namprd16.prod.outlook.com (2603:10b6:208:234::28)
 by PH8PR12MB7134.namprd12.prod.outlook.com (2603:10b6:510:22d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.27; Tue, 4 Jun
 2024 08:32:38 +0000
Received: from BN2PEPF000044A6.namprd04.prod.outlook.com
 (2603:10b6:208:234:cafe::ff) by MN2PR16CA0059.outlook.office365.com
 (2603:10b6:208:234::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.30 via Frontend
 Transport; Tue, 4 Jun 2024 08:32:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000044A6.mail.protection.outlook.com (10.167.243.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.15 via Frontend Transport; Tue, 4 Jun 2024 08:32:37 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 4 Jun 2024
 01:32:22 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 4 Jun 2024
 01:32:22 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 4 Jun 2024 01:32:21 -0700
Date: Tue, 4 Jun 2024 01:32:20 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH 1/7] iommu/arm-smmu-v3: Split struct
 arm_smmu_strtab_cfg.strtab
Message-ID: <Zl7RFCZhAbI/DzwC@Asurada-Nvidia>
References: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <1-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A6:EE_|PH8PR12MB7134:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cc6481e-dbfe-4ceb-e478-08dc8470e439
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|376005|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ePns6gYSSBL9i77SUyrZmqrAkIzuR6qDg/vQEmz0ovWV9PsIJvaEgjQI2PbE?=
 =?us-ascii?Q?DirgpfJKSQbQAYThg6X0tTS8x6HTAgsJMQmzDwfjXrj5ARwpaOmbI3LChSnP?=
 =?us-ascii?Q?kepiXevSrQSXVvkdPzvLzCRPysS3hhPQcOPdsNZgBXmZK72cyOtvg/JGb/pf?=
 =?us-ascii?Q?K1QShQOd3D23M7LISLqTvNmVrhpiAv4UyRxJjCB+Y0M9osETDJSPxbuifS4h?=
 =?us-ascii?Q?HUk1i2l+UlD7k6LMzhzRdTbUkNyFN9w8tDLZFgcDU8ueVsjcIACB0umncthK?=
 =?us-ascii?Q?z7N1xkfz8XRVY+nhkkKkJNCTMsx23iraQ/Cj/g0gNthOvUJxjdQuUD8ogxfL?=
 =?us-ascii?Q?6F1Uliuw9+aUH+ItVN3aeUfCXMfTSuyHKvpJfZ/ihw/NgVC1ESWavw4ycmNj?=
 =?us-ascii?Q?PwbNqKygLrYCMc1NLgYVFbnPWX59hdFGKBTvYvDQHmJf9HCVRNQGTAdFw3oQ?=
 =?us-ascii?Q?ERyYhG2ul1qT8m8hht/L9o+iLowmjbEvUdsKiVOpOHrx95LprQWT2ak2P6IO?=
 =?us-ascii?Q?e4PkUx7n5q8Smt8X3sS9zqE9NEROzglSz40eHKD2qvdPzO6WfHdzgH07v2iK?=
 =?us-ascii?Q?46J//j71wnHLR2W5pdZ8n0y2X6qc+5dALLjw9Lm2FLrADopiLmEYYGa1/9Pm?=
 =?us-ascii?Q?mt4lQfCtqBX5LN/jzpsTpS8FT8qOkfkmGZcVMhtZaaYjTgZMvM/r9V1SUwM+?=
 =?us-ascii?Q?TU8eYNuACIrABcUUT0MTp3tcdP5O0SIM8s6CtD71TO+9oCoNH4u7liFUSey7?=
 =?us-ascii?Q?0G/FNucEsnJao2ioja3SgsPquWjVyabKFOs5/Xo/v1apaDQa7XMAzUr0kudF?=
 =?us-ascii?Q?O2rBgrduzDHxV0n2U3a7kfyICGAjGUwHqo1reCix6QW4dr0fJrw3A2/1PIiG?=
 =?us-ascii?Q?aD8/+e1dcjO7F4C5wX5nEaDJ4GVHent/242YKyuuaHYWZZVTPbUU1gu1o34H?=
 =?us-ascii?Q?Q3lgvIVVzJgNmwMsdNGME+GAmEGJI1Pa3ozG17HDPQJShZD4/K0HTIl2vvmZ?=
 =?us-ascii?Q?/bdPngoJLn957vBNbJsnXVC7MdAZm23q1GFloTizdTmzANUy1AVLWcam17Yb?=
 =?us-ascii?Q?UGl2wFXCgpQqeFs6DuuLgUDj0ustMv0FMSSoAmARmyuFw7Ec4MaHnIIYlE0Q?=
 =?us-ascii?Q?7yYHyPhqWRtIymudMiTZeJ8mjDDmmOHe0w1AO+KwncVi3lPT+f4nDlo5q2OS?=
 =?us-ascii?Q?Epg+lWMM3UOmcHXHODW2gRLZB4jeNtIi1UBa79ougfai709H3ZtYJodm39by?=
 =?us-ascii?Q?4ZwKbWMWLXP/MR9PJaGAqHSeoKnLUWSy2uSg1o+Ff80HfpLkJ6vjs1OIOg7P?=
 =?us-ascii?Q?P0RXs8sEPRDMGa6yG6aTLwc7udo19IruDqnhc88np0HsgzPpM1sJjwOZwbNp?=
 =?us-ascii?Q?jYSs7iQ=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 08:32:37.8095
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cc6481e-dbfe-4ceb-e478-08dc8470e439
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7134

On Mon, Jun 03, 2024 at 07:31:27PM -0300, Jason Gunthorpe wrote:

> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index 1242a086c9f948..4769780259affc 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -612,7 +610,10 @@ struct arm_smmu_s2_cfg {
>  };
>  
>  struct arm_smmu_strtab_cfg {
> -	__le64				*strtab;
> +	union {
> +		struct arm_smmu_ste *linear;
> +		__le64 *l1_desc;
> +	} strtab;
>  	dma_addr_t			strtab_dma;
>  	struct arm_smmu_strtab_l1_desc	*l1_desc;
>  	unsigned int			num_l1_ents;

It looks like we have two "l1_desc" ptrs now in the same struct:
	strtab.l1_desc	// raw level-1 descriptor memory
	l1_desc		// SW array to store level-2 descriptor memory

And it gets a bit more confusing that they even use the same error
prints in arm_smmu_init_strtab_2lvl()...

The "struct arm_smmu_strtab_l1_desc" seems to be only used at one
place in arm_smmu_init_l2_strtab(). So, how about:

struct arm_smmu_strtab_cfg {
	union {
		struct arm_smmu_ste *linear;
		__le64 *l1_desc;
	} strtab;
	dma_addr_t			strtab_dma;
	struct arm_smmu_ste		**l2ptrs;

Thanks
Nicolin

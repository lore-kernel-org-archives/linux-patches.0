Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316763612D;
	Tue,  6 Aug 2024 23:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722987100; cv=fail; b=s3orvrcL5f8OvUBBIBzGOb9TzbHBa5OBaef+IEmMAWT6DcwtZtyOVUo2W9pZc5c1Q4zhgB7UD+GDzA6pooCZWdwloAKr4IL8RVPfqX2OD5rTj3bTIrMY40QQQ2JiBNJuI14jFMPtebFy8uwJzmu1Wm04oKPKEnayite/RKg8gms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722987100; c=relaxed/simple;
	bh=Yo8uTUpcChTeE6N0+nYUvYUc1m8dAM6tuLIw8gVQssU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=h52osD4xdfeL76Eun8/blMnghK2nlBbNHUEshuyd4C0bw7zDN67xjEx7QxDx/b1f7COrvY9irzfjVy1Nn7VbU/Q70SLG4mrr49TxqqJ+IZ9FMAO4xROGURYRzUgO9iJ7TlMlvt+XljmXdghIvOa0GGW4724BfNm93f945GsAE/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OiMTT27l; arc=fail smtp.client-ip=40.107.92.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OiMTT27l"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hmjar+T33BWpoyKA+EncoZmDDQy1RlMLqLe2JAhKIACYdLbsuaPSVUktty6GKHewRGSk3ebKqcrCJm8tHCGgyXHq2s1ZIV2MrA4vH7F/6DI63LIyjJukasxRDXFejjtLXUWjL53u6i2A3FTrpwF3VHjpf/Geay3H8CJPsTjrsaFmZDVMiRdZmDfLAQ3uroKwa7AlOflLzoTU9sR6x0tDVb63GpgIO74my+NZvSG/BHwHhG/fWBjxn75Jiya8nAmb5dlNIYOX5ZXxGtK4BxhmT76jX7H3cntrPgarVy1UDMN2dF+FoqKcu1Dt0cSsRH4TI48kLbzz8EsnqYPpQ3f4RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SIkmjguZ6M+290NsPr+CxlE9c9SVlmRF/icXTrdLbh0=;
 b=hAjMQU1ajaCULbb9zxCj7P97aFSkGolzkGZn5HyU36PYU2Zgeg6GCZL4S9hzfCffwyFkygMV4TjMfMbPU1twJDUFfo3cyqOsPr3zO1BrOWQK8GstC8CK06VPeQVfAjYhO1AxXs9WS60x7MRo4IAl8zD4z2lqDAW4OMQoS1vT9mg+eUa2OOwV69SOp0F4YsG9RJr4ON4Vc3HpJ1BHbqI4URx3MQH+RQ4o7qQ6+/H5qNZPsjEtcaNccsf1goeI2A+4Pv4OEiAGYBN881yOi9KBQLBBfoYQxSk9+j6LPOqFs/x2ja8owzlW26mXLRno8HsJHYjjJCqK8KOQMULIP1vBiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SIkmjguZ6M+290NsPr+CxlE9c9SVlmRF/icXTrdLbh0=;
 b=OiMTT27lwiZfZybvKEP4TfmXPxXh3i00KVgSqmDTUWUEJ19AFXwY0F0UGT6WisC0FSgPn9ekmt+DioFLNDYsRG9shl6hogJKLGqIrZcEOQ6N4t3NeXNxbVq7T0I4kDm+4dH7kPd38woQSrGutFe0Db0qNh2tBx4t/7CI1el4bGwK9+pCtQziSTboYoK7bAE29M3g6Zd1NvOZ6Lgph5oBWoqxeUTzi6a5QOAGb/Qv5sUwQhCiw4gT4DC3oIhEkDOMiJHw5dAYkzjHrCUst7v00YaIGX4emNiOmyZ9q/Ch7MKjj+ExbDYzZPGprwV67y7wmDDgo8DXzV+iqdn8z/PEDQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH0PR12MB7839.namprd12.prod.outlook.com (2603:10b6:510:286::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Tue, 6 Aug
 2024 23:31:31 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 23:31:31 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 0/9] Tidy some minor things in the stream table/cd table area
Date: Tue,  6 Aug 2024 20:31:14 -0300
Message-ID: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0574.namprd03.prod.outlook.com
 (2603:10b6:408:10d::9) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH0PR12MB7839:EE_
X-MS-Office365-Filtering-Correlation-Id: e8928eff-a7bc-4ede-3dde-08dcb66fe391
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6rK6C8dA5LfGk3SsI0omIsjwndtrInORAG7DlLQWR6vM/MZpWCaIHrbIKiLy?=
 =?us-ascii?Q?QROwbc3rlsIiYs3HtXhSKZN/oEUk1lqxQI+ui0nrKBz2NqMm8p2SU5ErTmbO?=
 =?us-ascii?Q?G5tnAAz68joCexhYglBO+zUlGszdTi9UuCh3gSzCkrioa4ad2x7TZzVeMLE4?=
 =?us-ascii?Q?KrC9pNZxzL8oHLmgOTNnQBJ54ZVkeeoQkL3et5EQtH2E7qptH+dRlCNinu2u?=
 =?us-ascii?Q?PGcFk3pLbBQzj/3G2QCdQejO/i3qdrkYX3hJCMySbTvWppSFmR2PMZ2VV71h?=
 =?us-ascii?Q?bdlJzXmet/5LCuDOIwnJxDkr/LuNc+htLSqogOzLB4tg1JPzWTNfJUmUEeni?=
 =?us-ascii?Q?iYbvuZl+FFIxvThpN72mxfG8hG2dxJ+Xma6uAqr2YJmJHC1bzRoxDsDo3d0L?=
 =?us-ascii?Q?lzA41ZZmr6iGLLsSfcq865yOwIgB1nNRynPae4wtR9qW7jkQXW3ntnluNiOy?=
 =?us-ascii?Q?HIj7414+pO3cKtRVKCiJcEXh8gvy6vzi1Go4d+gHbAcjry797pp5vrlpqDED?=
 =?us-ascii?Q?Cuof4w3ucLz1mjy5xFqeYgRL6wdcar66qf2k1OfBx303tTmfo02iaYeGM2Bg?=
 =?us-ascii?Q?4nnEF8gk0yUbj6TMEYOYtVjDMMzvNUEJqIzpOvN59MhCB/sC1xmbiNxouJn/?=
 =?us-ascii?Q?7/3vfpA1DPEdKTZACbf1IU/qrN0mabr0/taRfTv9rTZMil/Sxti/2G+YKHRm?=
 =?us-ascii?Q?U/Ch7hBZou5dC4EXZVMQLb9/IHbTSorciA7U08cij61rE+DeqYIe8gYbsr5a?=
 =?us-ascii?Q?vM2sDP26RSXMyaO8GnwD01AMnZZDThu5QhdGVkXABvMfiK7HvgYDpDb2478u?=
 =?us-ascii?Q?4JcDn39meNn5IEByra/0j1ofPUF6q+ZxNM6iysTSDlbMwci42DBVEKOd3nlj?=
 =?us-ascii?Q?8D511+muK3N6KZIEcTbRhMLINlsMdqslmPDQwS0aY+v9Bs+xGkbWZxL6eV8t?=
 =?us-ascii?Q?38W55kOGS4fbvxn40EA/y3caQo1F7kMEEJhoK+5P3Tr3SfeK0Tg1FeL4xkNa?=
 =?us-ascii?Q?2bZezuQi6AAOZNY27AOgqb8aXmY8+apeopSMeNpsTmdg7ApD6s6iStQQiR2h?=
 =?us-ascii?Q?nNDG2NIM2grZQZnCFgSWGfv4Mp2CgY2uFwk8tTmzBHpZc+CDT5DOnSUmAK96?=
 =?us-ascii?Q?b6JrfaliJZNhYcS0P0w/wSbMZjuxhRdMf+0MTBcJeTQ/O+QesKRIbULmmFwT?=
 =?us-ascii?Q?seQcFW75vWS4bMIyvFX1i7YLBtATlV6F4cWkbSuyIy1SkR3hG9Rq4aoih1oV?=
 =?us-ascii?Q?3Sc+UNZdx5QUSjSD5W0+j4XcGdY4ARuUCCNwp46q51gU6lKIlUnOAU02vA0r?=
 =?us-ascii?Q?QAB+v5kKkUtAkJof2yZIlVNo1B7N3rCJyZU8zX7xsvkHDAK/ONTqNe+x66uC?=
 =?us-ascii?Q?90f426w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8HAPGtJrHZbMb8PYh7hJAtR+7A2BXXJP5ONUqDqjt6wqPdLfO/Ttj2A70zeR?=
 =?us-ascii?Q?XJXnkq/AySVfI49LxiwHgGlb0VW9JNzDxVZU0HGqS4e/jbIQy5coSEw2ENgQ?=
 =?us-ascii?Q?OMWEk8kanHgEad6TyDQ0K/jXWbm0vCSZJ0bJ4Vpg78wjFjXs+WhZ6BLBso49?=
 =?us-ascii?Q?RuKra8fA/PhqRDBvWmRmm80eHsjxhB0ow8T1cG5NACfO1QxrgNrfDHKDhi1J?=
 =?us-ascii?Q?d3iZgMpZ8PryxGhxLlSSOSgFIBfNRE4ftb3+yJNVccnHzR4L1KodbxdmT1MY?=
 =?us-ascii?Q?6S1JbBjF16M0lzC7SayzacUD8H159Om7RB1SsM3L7fCcSLVVS6MJCblVNElz?=
 =?us-ascii?Q?s3zXnC0kf/g41CbuVxcdNGUmBjuqzlqaMcjaNHrY22+1AVwnBMNhF8BK9h9X?=
 =?us-ascii?Q?WN6eEH62DeB/66Op0y+bXPiatiu6/ZEY9K9wr4rnaKPaI2ddL0AK+2FPW0ig?=
 =?us-ascii?Q?V87zahFR+F1qYfgB0o7cin4fO/AlkA6m0JGDowPg/02su7NcJU+Qx2JJrOuK?=
 =?us-ascii?Q?Q4IeCtkgXIIBYfoYRMrOGo+sVlRBfPKauFqmMztI8xmhSIT4fVYzNwl5bK69?=
 =?us-ascii?Q?Pu4WREiYAG5kVrBJA5AzsPKJo239npBIaLp87HuL9igQyZEx0rQVfxFqvggb?=
 =?us-ascii?Q?UNyVDa1qDri1zKPt+NdOS5rCbPaa0T8rMa/jXAk/FFsGoeydyAkqtKCW9KCa?=
 =?us-ascii?Q?WHZmrsdLHyflxb6S52f+DiHaNRauHVcuxQc5jglzT4GihwVw+uwZfS5AkheR?=
 =?us-ascii?Q?TfGHJmfXutk4cTTO2e6tmnuzIVf9f2I6R13pApDJPdx4vfsZRKiX6IMKgSX+?=
 =?us-ascii?Q?3JYb90K7xe1E60g3ncAcvI9VnP/H6UMj2bm3AMtKcaAsCj7mDXoLc8Tz4yZT?=
 =?us-ascii?Q?GQPtrD5km6weVBlRZwMWpAgtj+gnhkO2dStt9mYHb3rRjyCQWj+DO4k3aPwG?=
 =?us-ascii?Q?bjH8DlOh4B/NxeUduUO5dCAPrQGY+i/iIhgEpobWxI0m6Kae8RFiJ0hVSxVo?=
 =?us-ascii?Q?kdnW6yoQMF4w63i1ENivwKWBYy+/yKPFR5yvsTt82ji5JQLKL2RB4RyF3V6I?=
 =?us-ascii?Q?wCDFtyiN9xi5/w7EjBeDfXVzoo2AClt6I3ix4+UiP7S+ubr3eWQeIk3hm4Za?=
 =?us-ascii?Q?Vi7ITYLPL5AfhXNrhRRxLshoZ3n3gVikMC3NOYzn0Q3tClc6xBPO+8gnV21c?=
 =?us-ascii?Q?AraTgGO/g9vQM4mDIl9GECAHqILVgoXYelmC+OqMctOZo/EpeyEAfw/u2snE?=
 =?us-ascii?Q?yzwn6RVBnyNj44srFrdhCQp/Vnn7Np6z2KPKQszPGwXAfOwkvLjvgR8gLWzO?=
 =?us-ascii?Q?YwXArzgI/3sg+Jdc7jkpBZBZfGMRVIOq4rNRZBjQjFxyAg0Te5w5X/v5Cb4m?=
 =?us-ascii?Q?krQqgTZ2FW8fsEbl/cGrOSMYTKuY0E9AJ37eh2qVz9GclK91TYFeGe/TVaAm?=
 =?us-ascii?Q?8d3L8Roklh7lDNR1pGAYeiDnJpZpx6r3m9SNC2G9Z5L5q/07jp/ci/830+uX?=
 =?us-ascii?Q?kJxdcEAkHJ2xskM13Ebf1M9azi/SenXdlohqZtb1ZY2OscgrePrChXFVwof7?=
 =?us-ascii?Q?8rFbddbQkOFaQLA0hGs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8928eff-a7bc-4ede-3dde-08dcb66fe391
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 23:31:25.6211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a2MaAq6c+3yOnTYnuKuMyFaNOKAw9yNtxl94TxbCJMEiFjri55ZugrB0ojo8AMaf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7839

Will pointed out that two places referring to the CD/STE struct did not
get the new types. While auditing this code a few more oddities were
noticed. Based on a feedback from Mostafa and Nicolin a few more things
were fixed up too

- Use types for all the HW structures everywhere even for the L1
  descriptors that are just a single 8 bytes. This helps with clarity of
  what everthing is pointing at
- Use indexing helpers for the STE/CD two level calculations
- Use sizeof(struct X) instead of open coded math on constants. The sizeof
  naturally follows the type of the related variable in almost all cases
- Remove redundant dma_addr_t's and save some memory
- Remove redundant devm usage
- Use the modern rbtree API

Parts of this have been sitting in my tree for a while now, it grew a bit
since v1, but nothing is particularly profound here. Enough is merged now
that they can be cleanly based and are seperate from my other series.

v3:
 - Rebase to v6.11-rc2
 - Preserve the "2-level strtab only covers %u/%u bits of SID" without
   change
 - Vertically align some of the constants
 - Use u32 for the type of the index and sid
 - Fix missing * in le64_to_cpu() in interior patch
 - Bring back accidently lost "Use the new rb tree helpers" patch
v2: https://lore.kernel.org/r/0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com
 - Add a patch to add structs for the L1/L2 HW layouts and use their
   sizeof and type instead of constants and generic __le64 *.
 - Add a patch for L1/L2 indexing helpers for clarity
 - Reorder patches
 - Redo the union layout in the cfg for both cases
 - Fully remove some more defines
v1: https://lore.kernel.org/r/0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com

Jason Gunthorpe (9):
  iommu/arm-smmu-v3: Use the new rb tree helpers
  iommu/arm-smmu-v3: Add arm_smmu_strtab_l1/2_idx()
  iommu/arm-smmu-v3: Add types for each level of the 2 level stream
    table
  iommu/arm-smmu-v3: Reorganize struct arm_smmu_strtab_cfg
  iommu/arm-smmu-v3: Remove strtab_base/cfg
  iommu/arm-smmu-v3: Do not use devm for the cd table allocations
  iommu/arm-smmu-v3: Shrink the cdtab l1_desc array
  iommu/arm-smmu-v3: Add types for each level of the CD table
  iommu/arm-smmu-v3: Reorganize struct arm_smmu_ctx_desc_cfg

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 355 +++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 100 ++++--
 2 files changed, 232 insertions(+), 223 deletions(-)


base-commit: de9c2c66ad8e787abec7c9d7eff4f8c3cdd28aed
-- 
2.46.0


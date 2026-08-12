Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371E436308A;
	Wed, 12 Aug 2026 20:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786565376; cv=fail; b=VwmIOD8u0iBS6hnEGus1WW36pF+X75h6fxV/bHaXM9JHAeYZyumXxMrPq/kw9RsiHBHsDG0fWZBPMBWhWSD+RIXf2VXGWssWODCSYa+qHqf6/IbcQIDUmQp/XsActAdHYvlPHh+Ochvc8pQvl1DnFZIuE7EuPdVwlJe9VjfClU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786565376; c=relaxed/simple;
	bh=tLiCA3myzlp+r/zBt9gmYiXwUJSQfY/7KemJBwP4lPA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=MEETHf0lCCt36JZ8tRjT2Iab32n1BkxNS/qzX5BZqpNUR4yRn+S0XuSsKM9hWfThoPYju9QGnCqQZPvBqaGorYGEKxQ/Z7PtpXxcX/gs9KXeVgtXpEgsa/xWPe/nIJfERxmIG4h/fdmq3G++3Lb5n3OM6m3qFl/QTIbBhfO/gYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sEevlcO6; arc=fail smtp.client-ip=52.101.43.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sEevlcO6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lfl/jI1QTwWPva+Lbj6/KIS6pBe5PMaXZdslB/A8jrVX1hKMhYlXRCfke0Gwp7/HATt80kK8AWFXk91F3y3sb65NkCI2GyFw9GuoJLgmAblwNjAx19AtA+8eY7j2J3uUVQGEyLl0OGrtZXuQ7Ub/TdXRx2NamVuuVNiUXpJC7eGTElcOhmfreX851QlkY75/NZ9kDpeo14UkWtOOpIjNq/VIjUBbwlNhoTIexx7teDy+fCOKuHluSH7wg0/iJNJ84c85RiVPoWONG8peoCGu+7pH6lUGu60o+XS/uBKtpjdbQMigYTDCjKwOgW+ruy3wpSll+2RRi+XGNmdH4QAUIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jN1X7s69RcgNKPSPCkArbB9TFNKXmHPEKUkIuRBWfw8=;
 b=OI9LZRAOTNZnV1koqrYgIAU/tus2AoPWfumJq/FxZZbkSXDXDrTVUnpK6+tDO1tsSOhq4VJ9hsFSyhYRIsyYG3gmCU9Cpv1xbJgX2fhLwaidjl44CKgT2hdqdPrZcCXXS6WxKT3BKsgSeEsbALFDCYfsSjpTpRxhl6vxjk2o9ziKCFBzCuyc+nEotV1OCqY6s5/kubmm/U0iAqyMfiQJpwt0bEU0uJV7+p/LazpiHasLzdTgrLgSvHSYyOybO74ic9NTJZmDtMmyuDMBTnv0Y5sbLhCGh346OkV4r67pgs9s6R1D2KJR8WgZY+o2o2XSq8JPSJnStvnqN2uDS0eGcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jN1X7s69RcgNKPSPCkArbB9TFNKXmHPEKUkIuRBWfw8=;
 b=sEevlcO6lEtO4ivQB/dBxJ6Xe9nZz8Ars3YiAu7ltsyD8wal6mvjsSWupLAVXxCFx01mOfV/UTWg8DrKgseCt12jIkTRtjhnN84kkSJWD0jfkt8fBffOPfOSM7hXHbOwW42Q89cYqSxzp2BCO8VVufAmn+OT8GKVsyNi6Mpv+T2q6GXoZotmVI8ULruatdf1MAwsD+lF0y3cZ/1rgIis/5o6s5S9xU2yhaNk1cFXMKUtuYG8zEv5Cu214X0oya2GZnRE7rCaXBtuoQiQqsm79KlXQW8uq88H1WmxKF9Cf3UT7jqXSrJiLLbkZl4Kk/FjKLOiPRf6ZNfvSh7tHi2Leg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY3PR12MB9629.namprd12.prod.outlook.com (2603:10b6:930:101::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Wed, 12 Aug
 2026 20:09:27 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 20:09:27 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 0/9] Use the generic iommu page table for SMMUv3
Date: Wed, 12 Aug 2026 17:09:16 -0300
Message-ID: <0-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0023.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::24) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY3PR12MB9629:EE_
X-MS-Office365-Filtering-Correlation-Id: bd97fea6-71b6-41cd-7cbc-08def8ad9c31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|6133799003|13003099007|56012099006|10067099003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	v+Inq6LQx8XLwgQX3bLUeizwVN4+RQWYAmg8rV+Tq4stav2u+VPrOMerexn3bhy0c2WLkA1HQVGt6K96wIV37r77f+2VWROSQ/2xNT+1UOUPv6LlCiaG/xi12qb7aPkB9U+msv6wGZBkIbOIdlffDbRFBz7b+Eh2zg3EeiMcGy/tBuF9TUrxrnQetrGcxVD2hcdO/Z4E9tuR9EvDqpBM6qOWBbdC3ZY7sZt3pFHLoDp617lH586G1r7BCP7HJn4gAB6h6DYIJtWKalgklZmWBGPf6mK+Q58/8cj4PgDcm04cE4GC/t6AFcTEvIolYqEN5ms/g6LVr14f8syS74GTESwWnqApDL/CEQD5IvItIgyGvi8B/JH2MCm9s4fSwfvKXgGjtQvWSHS/ve0NBt7lm9NXm1vVkQ0pgRpRFU32IUVs3CS9Ah7xaxzZGOPEPquBOa7fxBE2rBbXPFk1jcxg2dcC2nuu7lYzM6P1x9Q/dkkUaRSHXdErHPcoIWdG965lZJ1/V+5dyvGFKBijAIPfaRWPKXmnwSnl+KiGWx1caiSHUZFMpmI5vMe2qs5Jyt/1XFsI7pZxCcQExi1a3VbaAB72oBd19DS7TIIZ44qVzbjJvAq0rbTlbM7K4RKVarrNjP2qrAtqUbEb6yWlq6zSbbmTwK6P1lDfYRbWuqWQLuU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(6133799003)(13003099007)(56012099006)(10067099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AStHhoKgUMKgMM+Eb821oraIEkcMl5gUdKPdkzt4G0c5SWUPjmReFOWWAUPV?=
 =?us-ascii?Q?OMjACWxrvXm+Qrj9XmpBT28FFVvKD1lZH2FrQXTHaFE17ni8bcO9TVxwqRsL?=
 =?us-ascii?Q?U3Yo7pwfQa1zE96Mp3iE3b80Dp+Q6sb0zmWhDr/nvKOcSZ7SU9z/4dVgaydd?=
 =?us-ascii?Q?JhypsZwadlsYOC95FVO8fhWrxVu1iI0MPN6+tPJeBqeq8neirXUZQDR8ofK2?=
 =?us-ascii?Q?9DjlTTHz29T4f9UHTZ0D5kf0BzSZo4EVGsTUzQVrHeKXi50MSjIMQUymDOAo?=
 =?us-ascii?Q?/BhE8EhqevAEwj8G+W+5wqFlqu41beYJytu6oCNC8/E6C1+ZQSV3bu9zSQoJ?=
 =?us-ascii?Q?qu4ayfqS3qYzK9nm4Dqy4qvHxhek0GdVPwNBpWt+weBJ4tdFLX4fiKM6aIVn?=
 =?us-ascii?Q?U3rJcFMmlrnsvKzmD6JpPiW/69MQkUjox6sPLbultebpwGnOXZ5pccIDV2m0?=
 =?us-ascii?Q?6yowLQJUiFVErV+70q9gYpNMtcX4wMxTZPpKyhccOTWpYCXKIifK33b192BQ?=
 =?us-ascii?Q?Eg69iugk5D8i6hCd5wHJJPXTZ76xc/VrMA+OMO2xxh33QkRh07zENUzREaKU?=
 =?us-ascii?Q?UFdM6E4QPQaz19iOn3HPxvQ1gO1+qWpfTl89Stv5/OFUEF1eGSQkv2KCM8q/?=
 =?us-ascii?Q?6yuRkj2oXiXYHFoFomVa0tmD1PMnCbOAkk3sEtglsyoDbnAhvku2+Ky4qz4r?=
 =?us-ascii?Q?9w9Pbz9GOZR9NUWIWPLfyo33E7u4oCw31EbYFQ9jTx1JPcMznbedAIItRrvU?=
 =?us-ascii?Q?WtuOEW4vJzI9x0uSZI8vY3+Wx7x1eLiqdq9PGyRGwf4HJtg80HUBiiCeiwWO?=
 =?us-ascii?Q?Ji4QOiLQQhdcZzm6whWDpQmfqoj4teTvUuiN1jrGd+WLbYAy1JQABn8xsg6j?=
 =?us-ascii?Q?MXuhz4ZMydjXlmzZOPC/07jcY12KYuyReArmwffJNA8R7kIePU8Nv9OntDwy?=
 =?us-ascii?Q?jhvqqydAAyJy7crPy8S0C8LWGNpX9epsesJRovxbQy7yrk8WC7tP+bu0zhYb?=
 =?us-ascii?Q?xa24q5+Xja4ACsAK/B3i3546WZtMcGWL11qfXkzRu5khpHnp5qEiM26US83o?=
 =?us-ascii?Q?u+iVRlnquZTIIQlglbr3M+PMVN/XlftZ5AQUgQUwQL/syQuvJ2ku3EaqoZgm?=
 =?us-ascii?Q?iem0zvaj05DTjDWdgEOMJLQ0ueGHN/Zaw/uwZEEKJZetcCeOiWWml3r2dG1E?=
 =?us-ascii?Q?izZDTutcghJeK4sXFXcqKj0ihBgJQvXRn/92lX7Tq4qrgMNvb7WnUMPST6sc?=
 =?us-ascii?Q?jaJ2/6FEYNP0cjkffOo8bLaRLqCdQC8as/PGnuR5SJQEtsUvRJmedpjJXptS?=
 =?us-ascii?Q?kz2Jhdbtiq1oRuYmZSs/8MTV8pUNqpWPkPxxTjN5oC3vglEe4wBI+evSXjRV?=
 =?us-ascii?Q?DT/I86mk8qjs0jrK3725EWGZVM0ZNVBAab7/EhsF4USDBaKgUNOs8eG3z/oh?=
 =?us-ascii?Q?1hF18cvzBo5bKKSM5Ayo7p35BT5c/xaWa0FanuLmwRBCjs4q6megDJLE4RUE?=
 =?us-ascii?Q?EkQBtklzhhUt4g8B4Lp7qzq/ynfRuKC4sewmwy8/syPuJGbtGu45q4AYnK/5?=
 =?us-ascii?Q?iIx+//awDaUlb68HEbUDixU+apY4pNhKPPwyBdI0IEZBQ7seuH+MFalMmppG?=
 =?us-ascii?Q?p0gmGXMwpbbYVZpqo0V/NVKWFUNI76hVGne/xV6MwtbH+ZJZcnBfCPO3fkCD?=
 =?us-ascii?Q?Kpq9IGzIKAZjYWz8Y/bqwsmD9ccm5F9xYb8W0Yk3HkrbmrMNs7oYZdRBjitY?=
 =?us-ascii?Q?DXIYTxJD+w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd97fea6-71b6-41cd-7cbc-08def8ad9c31
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 20:09:26.8983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l89aPv2h3k+7H60Gb1ykGJQ+UvmF5l/26f6RQ8iVBx5CGvagnumxfNSzVUxLHOnT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9629

[ This is the last patch to move SMMUv3 over to the generic page
  table:
1) Organize the SMMUv3 invalidation flow so iommupt can use it
  ..
2) Use the generic iommu page table for SMMUv3

It depends on #1

The whole branch is here:
   https://github.com/jgunthorpe/linux/commits/iommu_pt_arm64/
]

Introduce the generic page table for what the ARM spec calls VMSAv8-64
(ie the long 64 bit PTE page table, io-pgtable-arm.c) and use it for
SMMUv3. ARM is by far the most complex page table of all the ones
implemented, it has the most runtime behavior variations and a lot of
features.

Like the othe architectures, the page table itself is supported by a kunit
compare test that runs operations through both io-pgtable-arm.c and the
new code then checks for identical PTEs. This is on the github link above
but I don't intend to merge it.

The existing kunit tests for iommupt will automatically cover the new
format as well.

This is the final series migrating the SMMUv3 driver over to use the new
functions and remove io-pgtable-arm.c usage. In principle the other iommu
drivers that use io-pgtable-arm could be converted someday as well.

Robin once mentioned there were errata about contiguous bits, I only found
3673557 and it is mitigated in this design by always using RIL. I'm
assuming that RIL is always available in SMMUs that are effected by
3673557? I have a patch add a FEAT if for contiguous bits if that is
required.

v3:
 - Split the armv8 patch into three parts, generic, db, and iommu
 - Clarify some comments, mark some more debug things as WARN_ON
 - Use tgsz instead of granule for consistency
 - Refactor checks into armv8pt_validate_features() and add more
 - Drop PT_FEAT_ARMV8_AARCH32
 - Fix make dirty logic
 - Use arch/arm64 constants instead of copying for SVA
v2: https://patch.msgid.link/r/0-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com
 - Rename granule_lg2sz to tgsz_lg2 to represent the ARM translation granule
v1: https://patch.msgid.link/r/0-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com

Jason Gunthorpe (9):
  iommupt: Remove the sanity check for pt_num_items_lg2() at the top
    level
  iommupt/kunit: Skip test configs without supported features
  iommupt/armv8: Add the 64 bit ARMv8 page table format
  iommupt/armv8: Add DBM support
  iommupt/armv8: Implement the iommu specific components
  iommu/arm-smmu-v3: Remove io-pgtable-arm from sva.c
  iommu/arm-smmu-v3: Move the DMA API comment to flush_iotlb_all
  iommu/arm-smmu-v3: Use the generic iommu page table
  iommu: Remove pgsize from iommu_iotlb_gather

 drivers/iommu/arm/Kconfig                     |    4 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   15 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |   45 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  292 ++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   11 +-
 drivers/iommu/generic_pt/.kunitconfig         |    1 +
 drivers/iommu/generic_pt/Kconfig              |   12 +
 drivers/iommu/generic_pt/fmt/Makefile         |    2 +
 drivers/iommu/generic_pt/fmt/armv8.h          | 1072 +++++++++++++++++
 drivers/iommu/generic_pt/fmt/defs_armv8.h     |   23 +
 drivers/iommu/generic_pt/fmt/iommu_armv8.c    |   13 +
 drivers/iommu/generic_pt/iommu_pt.h           |   14 -
 drivers/iommu/generic_pt/kunit_iommu.h        |   10 +
 include/linux/generic_pt/common.h             |   38 +
 include/linux/generic_pt/iommu.h              |   72 ++
 include/linux/iommu.h                         |   62 +-
 16 files changed, 1391 insertions(+), 295 deletions(-)
 create mode 100644 drivers/iommu/generic_pt/fmt/armv8.h
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_armv8.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_armv8.c


base-commit: d8129132de326dbcbdbb0abf46580072d6fd9224
-- 
2.43.0


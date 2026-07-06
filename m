Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010036.outbound.protection.outlook.com [40.93.198.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCA937A85B;
	Mon,  6 Jul 2026 16:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783355383; cv=fail; b=ck++EMaZ4qwLEyGMma+bQRCV31in9ndYH1ilQ3rFcXeEodS5S5O1yiCAatLaCBMHxpYBftmTtXpweRyy5YVepNM/dOw0YJPaLJ6PgIwDcKg8XGiTfmjigQBVNaARDQf5CzZWHCNM9ZHBh7U/HCY4jBmrSVOjpbD5lSm/6bMjJus=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783355383; c=relaxed/simple;
	bh=7PBD2aaihrhAxni9qDwtD+WV4IXqcmo0NxKAycQ6yPU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=RQm8UKeM8Jn+g7944GbowF2RexA6asTWX9lYeCxLKJq+bwtr1liYRmQHfNWx5q95MM+k3R12PU6xu+ww37MTzu2bXpOw49ZjTElZwngJGwanlm5A3KGueB+DRoQMbO161OMbHDNbdr3gqNpAdl/ghr67mvkN/n6vr51GAWZchh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hHkNM3RH; arc=fail smtp.client-ip=40.93.198.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hHkNM3RH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EfedddQaklVc2JfdKyrGFy2VefgezMHnxl4Lc6h+a9SBOgvaLDQF/9qVHyH3T10XSp3fB7HO8bZShKkwn8VyEzdSJpYpnLMIbL8Y3fkV+eGB1c32GQqYirI38uGAOynWNWNJWcrE3ltslyGDAjbwhk2xcfJAY/W3TgHbhkgnMbRuThaL92ZqItvNiwEboeZaB9KOa3LMhxu0J+F+i++5slffECD9xt1p/Jb4ksswWAW1Mb5VggiK+cZHeh4QakHJ3E/gtNXItGiC7C7MCyXKdUhxmHp5wIUKi/Ax7ToTB27dNpE+SWfpTf6ACXKxXkoxD47Rn6DrxkYwAQx29QanAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vqsBslzm9IyF9LLM2Xkq73rbCbQkAOquIRcZ9vAtgzI=;
 b=kyH5JOBLgPs3mQ+iLnRT3UdcY6x3zVICGnOyhdsTtzdU8kNl1zkFrVhbrd39hQfMjlK72rnAGRNJZSO+0CmUp4WZ+tzuovh/L0YjEHLgTePmnRJXdSa4qOZ6sBdTx3WVtgJfTkIn3kj/7xmPiyh8phMguHb0LewsoaqfG9cVXVwjbTUUzpEPD2uiDRWGtbQknBAuGtOnJ6W1vhTZu+j3FlyVaCdq4wU+4j4WMTziRKvuTCQZALPkFXEZI3FQc8/qQ1FxdNoCXBYeD+bzeOrdnJHgqEAV1SdvG6eqySOmRF7lhB5xKsxHzWQg/x7fMh72h9TDXt9pVN02wa2BVK898w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vqsBslzm9IyF9LLM2Xkq73rbCbQkAOquIRcZ9vAtgzI=;
 b=hHkNM3RHAKAHUk6cwTPBkdyuUp6uw1tgEhJYmPkSlFYWcw5TcsqQJP3BkDnIJbiCb4wFb7WoFnAm9JEu2w23M9vIYOt6JXlMuLECiTmbO8Dr2APVCeO9/5HSrWjep6h6f1PWOfAyuTRdakKBxBYuUZNCuV35u5TCdYQm5BwjhoSlyrCIA7XtR9WpjDBMMaw38kl4jBGRqSyjesLGPEPbaDPEGGGprKJb9lhU46GYeIyyoaHQwCNJvv3Gij6W5dMczh0DrDUS7iGr8VuwO6AsJJPhEFMreaMj0pDdiS3TbiT9IT2x8IxV6U05wYAdHgnE6rLZqzmoJ19cdxq05tl//A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS0PR12MB7926.namprd12.prod.outlook.com (2603:10b6:8:14a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 16:29:19 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 16:29:19 +0000
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
Subject: [PATCH 0/7] Use the generic iommu page table for SMMUv3
Date: Mon,  6 Jul 2026 13:29:06 -0300
Message-ID: <0-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0367.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::12) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS0PR12MB7926:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ddcc1bc-4b5a-4a4a-a94c-08dedb7bb8b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|11063799006|18002099003|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	SehBbLG+buJGElqqG+0zgJZadmMbvN6h1iGvm11dbGFPeA4wIDKqiiYpeZ4Vnm21a6y6XOtN4WU/8zZEBoy1s7Y/alYQxZIe3T0uBax160QKbG9F/t8lO8c6ARO4SrZlyFn+TXnGTCb6DMGdt/qHqeUvnV7nEj1U+NNXMf8LhrHtyMmv0beayWN7LrXgWx5E+D72qsPiPetlbl7fIIvil4LOGJpVlan67swzK+0/FO13QNB/tQC9EizfJyeBl3QB380aC+4DzSlo7ghjpQfwNvODtaJ8Twcm+HF2EAyi5e1uSEs2jW/tK9AjEX2IPjsEO8suvFAEz2Elup8lkRZFqKHJU0UX3oJkO08SGM9TQH1NFBlQI+JjKTtW2anBe+KLS9A37FYU0pQTHERqzNr/hMUSWhpIrIX+OBFg0KtEZmv2ZNpymtmXL/HDPGQQWkbPm743V4S+zeRWKFMFRP77e2B/QfirNCdy0kcKw2azEWgiyrbpF+4izjGPrrFws+60E9scd7XZJlFGL8/TfZ51jPj3BjaB57hkyC6O7R/XG1rALBwvCAeVJBmH4Lc3WdxOyN/9SynAN5qbBR9CNXqr75NDud8otMAZWZ5HOXOwBAs/tnRBfS5Q2GT31mHKFrqs1HqWYlRLEHxDRUvKo2eYFtQh/2TPgvpAqw4rwz4Besg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(11063799006)(18002099003)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t/s4Vlg0pxlJFzom98ZsXR4g2Kmq81ju5k9R1r0HD1VvjvTof9XvRc0DIgkg?=
 =?us-ascii?Q?As1a6bxlcoJqBs+faOq9N4XZ+nSnMUkbgjlKVuYdUygL66tz1R14nQ9aTkkG?=
 =?us-ascii?Q?x7QQahHPQuyVIuuB8nFb4/REmR1+boXytrd0AvFlDNZu+nReDgsMy3bSqAuQ?=
 =?us-ascii?Q?77SGTqtrvqD52Rr8joGhASvrHy6jsnh6EF/1+fLpCaSEC5vHVKEWsFFDTXY6?=
 =?us-ascii?Q?TkfTeW6bVE/U9fsHgqNZ14vwH6r4NyoWpM+soCL1i4LVbTx9zhQ4ZS/xkqt4?=
 =?us-ascii?Q?Rin3gXWtjQOmHdG3TpzhryY6vyok30C9VY3gkL0upzXXbSudk/dG6hrWoxmC?=
 =?us-ascii?Q?XEvfSW5v/2pZwL25730oDrqJus7qof+VuOsW/9pSmzj6KRKNoRJsMelGWO4j?=
 =?us-ascii?Q?QnMZTpLCXXTg5MS3JO1Zn88ou8pfGfz+ehO5XFeRcVjgxMRdph1c1icfrC8v?=
 =?us-ascii?Q?dC3zuG7lj8LHjfNrJ2Y7XWKNz2MK7Ms0jSuD621MGvLfM/LI1qYPpHE/McK6?=
 =?us-ascii?Q?FWfI+JOk+LAAtGJqDKalC+JvC4hiaIBIFQp7cWp+wqg2b+wMWeuWRR7MO2Fq?=
 =?us-ascii?Q?lz3O/O1JKNGcRwEbfSD0r8ECVr7xOXoUs1453Du5MuyB4WH3f+RlF/DdpSur?=
 =?us-ascii?Q?53Q9ZLGR0eg9GqT0LPKKX1odac/MuPtI4UpzsPSHSTjaM/aftviY6XgnLd5m?=
 =?us-ascii?Q?jhKn44UeDl19iMIpew6ukcRp4U6rlPh9/kQxv2e98ugmaZ2jHhJ/176RK8El?=
 =?us-ascii?Q?0uMsE6mcYKB4iY5/3SlHcDHMil3kMWuAL+PONtsE2844u4Wfdl9poYASHcLO?=
 =?us-ascii?Q?ChGQrFqOwFwqm37ernCPuqoLT/IzKMg36avBvT54qflBc2Yisl3oVUo/NLE5?=
 =?us-ascii?Q?S/c9eRHrsVDBN31uEKXPIxlkyPJ/hf+TiOErvVh8CMkP+MwVrp3Bta0WAo+3?=
 =?us-ascii?Q?HbP8pjBYbjnSP40qi3RbhlWBkmjSFResynt09rbVp/Gfju8o+260SobzjyOh?=
 =?us-ascii?Q?Q0X8xU17wW8npaxckWpscHQkZDrUKOOGwc85PHv5uepRdfO8ieGI1NkPGBO9?=
 =?us-ascii?Q?bBDQufSXhxGuizQCY/DZ4st8QAE4QIDfIAtX1bcmVgXHrRJipafSSvc9ySfy?=
 =?us-ascii?Q?F/wfyeOpYpq4gAh+zDxrndpSnTcVpATLJ+mpUSu76gfvzWZMtquvTN6N7ZzT?=
 =?us-ascii?Q?IEoMEkGnJ+hrJ0UiJ2COaNQYpBWlxs4ucaI1O0lRjOnZNLN1hGGpF6QzT17i?=
 =?us-ascii?Q?27B8pLyZXOmSrlGSOweaN1SaLwnZd1TLhMzvzS0jRc05Xq51WponEIkhvRAg?=
 =?us-ascii?Q?jc/NL5nQLBigS8xDgLBD6bVE+6HUOPCdg+eRLQPrQb5nt3UW0bVJGsv3jjZV?=
 =?us-ascii?Q?njjB3904ceWWpqp+16oSgQWo8FEERASIoJmo9inCv6G5INfSBhS2wWEK2/MC?=
 =?us-ascii?Q?aF70csSlan+nBqmcEivKIEYA3uyleNy7Mid7trgo9JaQuDd7QbNwzUaxNQCH?=
 =?us-ascii?Q?vcTtei867NX4AMDeASHwl5v4k6VKiX+kxHItiu8MlFstwHb/io3bseZF3ndT?=
 =?us-ascii?Q?1xZFUhlazb6nLgsQq7GHAsWpIdFhQ8MB5n2J+8oKyydIYIPXep8klXkoFlPB?=
 =?us-ascii?Q?TfGjuKVm7onsXNqxDuPPFVJ/tNBdGIBj9E48vffu81EF00f1u/AE/4QSozR9?=
 =?us-ascii?Q?neWQz7N8eMSJH0HojPvnfK6vujChZzrupzNHf7Zod+PxAzaK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ddcc1bc-4b5a-4a4a-a94c-08dedb7bb8b5
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 16:29:16.2347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SBYjvNs8UtmgOBfyAQmfvpAwPD33VzYt378XYW1jm/b8Z5bxIyUONC7403rOjux1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7926

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

Jason Gunthorpe (7):
  iommupt: Remove the sanity check for pt_num_items_lg2() at the top
    level
  iommupt/kunit: Skip test configs without supported features
  iommupt: Add the 64 bit ARMv8 page table format
  iommu/arm-smmu-v3: Remove io-pgtable-arm from sva.c
  iommu/arm-smmu-v3: Move the DMA API comment to flush_iotlb_all
  iommu/arm-smmu-v3: Use the generic iommu page table
  iommu: Remove pgsize from iommu_iotlb_gather

 drivers/iommu/arm/Kconfig                     |    4 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   13 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |   45 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  287 ++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   18 +-
 drivers/iommu/generic_pt/.kunitconfig         |    1 +
 drivers/iommu/generic_pt/Kconfig              |   12 +
 drivers/iommu/generic_pt/fmt/Makefile         |    2 +
 drivers/iommu/generic_pt/fmt/armv8.h          | 1124 +++++++++++++++++
 drivers/iommu/generic_pt/fmt/defs_armv8.h     |   23 +
 drivers/iommu/generic_pt/fmt/iommu_armv8.c    |   13 +
 drivers/iommu/generic_pt/iommu_pt.h           |   14 -
 drivers/iommu/generic_pt/kunit_iommu.h        |   10 +
 include/linux/generic_pt/common.h             |   42 +
 include/linux/generic_pt/iommu.h              |   73 ++
 include/linux/iommu.h                         |   62 +-
 16 files changed, 1452 insertions(+), 291 deletions(-)
 create mode 100644 drivers/iommu/generic_pt/fmt/armv8.h
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_armv8.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_armv8.c


base-commit: 8cd13c14dcc29762766ff9ca2f67e3bae7c7cb77
-- 
2.43.0


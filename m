Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012048.outbound.protection.outlook.com [52.101.53.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB88380FF6;
	Mon, 18 May 2026 19:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779133439; cv=fail; b=HlrZEo47MYZyolnZ/BBuir7u9777EPIJqqaIcP8ravXHGHCSaCdMhbrRGQ4lY6sM01EeJiZS22MAV8O2UbjCtyLzySLvwiChdUfBh0hMMkCpb9oO0i3iR/1J/Cy+aVRDd9AZ/FI83NUlS/2lSicUk/frX2yshZIeHkVWKdgbj/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779133439; c=relaxed/simple;
	bh=5N8XXA3W1MDkPbfLBWSqcRh3aYWZjyXYGhQ6hZiajPk=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=LnsFah1pBDjayNH51QaB/dvzQmk6Pe/Ilic/PQSTRfhD77mqIlnqjKVuunPQTcEGKizAEoBBIc0c6Y8404VjMndZYH6Sh4peqksZZXwKqCXLjntrSJ9CIZcXegX/Ass9WNphS5QHCyQsw8lsAcTXWxtHt2nVn41ch+X7eyLvzZc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Vg4xRF5x; arc=fail smtp.client-ip=52.101.53.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Vg4xRF5x"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NnzdbRhoh6oVW2UweBN+Nwkwsv61hJIDwNpaTko97VwkDy1067L2K3CgUwQ9rb9yHx5krNOswyN2CCcdSXrhhkfmV1OpqY20joPh/sau8HY/lzw07YvuWPu+QQNS1VzyQ+pzOEbSAiFLs/bFCh49h+H40QxT0mG61nWueJZ3gZNzn1T2DX6BD721BsA/Y9i7itUJVVur/FH66vRBSzlRrPF3zY8z7gX3s0on9je8s1CbJgVz22h09TClUBTTg6sJEMod5a/RJH3tC8VzBPD6juS8J4WirP/cXqydO4TId2kcs24ftGPZZgj1W1FN5HSfZnES8W1cAdvCIR5Mgq5xng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EzzS909XSVTxvD/BicAff1a5gmsqLGrlNDek+e/EBs8=;
 b=lcd8Msyv+7e2CRox8c/UuayIPQ2DzM9/EsrONOJSs/SHc73llssXYumarYh9t6luW8lrqxdDVjdAayx7JM3Hztf7UKlpXah1CaZ99Z/ePZN/krre5TaiHWk2cYfc3TkccnBKdxnf1LWCs5wGKfAvyc95txbzTB7WmjE+/KCf/EZ8zehWSeuyZPDfZRQIX+KNxFejao4NLFwrjriwWO4XINQbMKOJiGnzk85/LAoxg1GuDxt1T9z7VCC88fNSYB/SC8EusukbWszdFaqdKxg1HSGiCkav0S8vzzN0IZtX0TQZxaOy3amF6YcXacZBWLXibcW37bQVbFP0y+hF0yfJQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EzzS909XSVTxvD/BicAff1a5gmsqLGrlNDek+e/EBs8=;
 b=Vg4xRF5xVZDKEkXNFTwIfPDJMp7h/nrUcPSHGgrcwyLGg+q/draSyIdQK/kjvsEZeOdnkq+L5+S8AdmoNK9RBCP3rR61w/G7szRp8W19p9EoDaErZ9hHI+ml/QqPgmjzICrdnlDYITZUVkn5hW/YqZERWX79s9xGWWsMX5LfbcFtZ2J9IFDgNYGjM4VIC7Ij3LVGRXJdpaEbP1iTBaDwtAzGoAFUK0CeqeguvPVLur5vkAVYLzxsiRo6qtOJ3gueS9CU7HuoCU1k0qKL1vAOZ2vPft/B5pYPKk+b77T67gU7+SkuvoiItQ5yPfy6CQSekRhz+kq30fglUPRhztEP+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS3PR12MB999239.namprd12.prod.outlook.com (2603:10b6:8:38c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 19:43:50 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 19:43:50 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
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
Subject: [PATCH 0/8] Organize the SMMUv3 invalidation flow so iommupt can use it
Date: Mon, 18 May 2026 16:43:37 -0300
Message-ID: <0-v1-5b1ac97a5403+6588f-smmu_tlbi_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:208:36e::19) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS3PR12MB999239:EE_
X-MS-Office365-Filtering-Correlation-Id: 409ea299-ec13-4c1e-3c43-08deb515c770
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|3023799003|11063799003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	/GOoyOHASOZK1IhD7fwRzryY64NYUJDq2ra5mShRtAyRDwIMCeHVRCphHz7Dc31QNNV0iq4GzwCNDvwpr9TAhp/5BJusF311VJ3ZrvKi7YXyihWx21QV/FYRD+4eV5I3hF3dZlx5mpzahmjYRkSw11jL2Lxcu90bP+7dlD2kwK3PMVMvlyTSXuQWVRfPRKAGe/y1DYxAL7z1EpXCRm1yyIgf8ZUFUBLX7yI4xb4z65zOANeoqSC8WaMyArC8tNxT+7APp5PlETnBPqVrq6iBZnmTlLBevwb8SC115LqTxlJ+HfGvZCfwsEbVdUh2dgomdg3qhqh0TRhbMQZFo5gHLlj/i/R3WSxhnQJwF1wXwDXZQAZjR1L6zP4P3Uj8gVyXEXMp7L8wis263o/HkGmbreWMw13Dx1UZspwm70slXCKehsb+1G0FQgTJbaisLEpkwvbaImkGY853eQVColJL4OgjtsWzLRG4+HwxxBbXnewA4ynMWvtPWc20h+iZsLlVh8LGPWLsb1bY1wXNPRPXT/USwCxGUDOnJfst7gqlgN9YqR7Ucx9w3xK193D6T9Xq0F+aOprc7DcNfPz99A7/otB7HUP99WUKaJd6Ze0FUACxBG0VABZyO1WvI+9WQhpNMn+4FkR1z4FQJb41FL4SaG2/mF8SADQ+PPiuVHioqIGa7x+YqskdDQouTDx6EnJmJZfy+EdNkvTkXlmS9qtQnQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(3023799003)(11063799003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lbVg9HlyG3HdfQNLEhhj6ozFKc0vLYjYgBMCI6oaOZ5xhtHGp9dmzBoy8PnY?=
 =?us-ascii?Q?Cu9mjKifHyAoGEozdZ+EHnjabT20qJTNTS0CD2LfE34uI2uuxpA1DdUamkuv?=
 =?us-ascii?Q?lN6GQw1ACmn1/fw6wd5/KK1I3LDOgznKOl5uPn1b1bcu4nTt8ezIOhgLdbsZ?=
 =?us-ascii?Q?V89HVcF+UQQrtxAoLEVUhVp8nJZS1ouYhRcJpvNvv7UICDkhY/DquSpqCHY7?=
 =?us-ascii?Q?acma07EhU9PXR+MnBvInbcV5ugfBItGlbMWlHNOlpeH3ZYMlXEClM9NztjO7?=
 =?us-ascii?Q?HXNAfNUNoJSPTqudWQTFK8hTH4HaxyaQbFQ/zTQ/JTqyCA+ZyaGN5Wz6V1gy?=
 =?us-ascii?Q?7afigWycD1EayReZtSp41AUe0kYD1bclcu6HTsVZk7WyIZO9aVoUCdL8SY8t?=
 =?us-ascii?Q?QSRXE8i2eyQIYXRHE3il5RwcpBFU68vBAyK1iyZGLxXeAmPC9Q37VFjG5483?=
 =?us-ascii?Q?wrMJzmdZQXm7AvxWLabyZFNBK6atCeyPP4bFsQ4A4J39UkdkkV6kyHU8K6Q1?=
 =?us-ascii?Q?QdFIMoWNxXV9g+skhICGKV3OBJdrMVYIdlPhk4/9NBw2d+CmyG1JeDHLRS9Z?=
 =?us-ascii?Q?0j7i7JJymbTYve06wNwLz/9olgklGguZz8BHsa/EkrOrnlmbLbV2siO1+WeQ?=
 =?us-ascii?Q?2fCmeMVvCFQNwxw/TKi+b8z5w0uL4USsV4ECpAe0rMjsS+DgzJcyicUXkyn3?=
 =?us-ascii?Q?GxrJtiSlfh1i+fNg5gxMwZrsRA732hUT7ohy5AU8R+PCmxZE4wQmaAGjjWUe?=
 =?us-ascii?Q?aBwDIyXAdDNWEPV102gO/yhbEELF6pqz0mm0vKRv8cRelAe3apwDJFMuDYNs?=
 =?us-ascii?Q?woc0U/Pn0I6wkmTmUrwZ8dJNR6dtKIOh4LiOC8EWbg/hO5NrR3WMOhI/7InK?=
 =?us-ascii?Q?Igqn9BMUXhqF2yi36C67qrP10uvj77H3XgJW7w12My0FK5AV1Q4VkkyoM7gU?=
 =?us-ascii?Q?q7ybuWYSvgLoD+Lx5WglWf4jc+ZdSSQGvfwcfY1Uorgw5jbx2M4EsQNQfX/P?=
 =?us-ascii?Q?XQNLwFIbgDCS/YL3S1WaOW0usel2/ZarfU6UnAalIuY1Awa7B1Rm4euUxj/d?=
 =?us-ascii?Q?VPz/fnuQ8mdewhUwMiTBKYQV3QwgEl//d6WJyNXnq29jGHIH1IZRyadj8wv1?=
 =?us-ascii?Q?lsFzmDjDLBbT+aNCCv7u7KNE9fNEkCUdPz3NGGzo1ZdsI8CyLEsxbfUdV2FX?=
 =?us-ascii?Q?Hag6aAYlDgSSo7GJL0Rkw9Pn27eFO8YBxu2VD5FJW+cAwYX8EwV9mc1mXnIS?=
 =?us-ascii?Q?nxFzbKfJe/XeKpGEjxP5O+ZcbOxbKQSV1n33e/u+j8Y043aNpNujo97Va0UU?=
 =?us-ascii?Q?H+VzGP+wPoiQOBAqRm8Nel0WcdN7yfP8NJHmHoi9ww51FxV37s0WV4GdZyiL?=
 =?us-ascii?Q?rcfgklFY1C8CBqfKv0ttOItwAFx/H4N67ijK5Rp7JAhBzeAYF5YmujArLhJv?=
 =?us-ascii?Q?K4rertHT9itLNa2Jh9kJXbrtV5/TViBb5y03CdJZ84dSUkC6Yh8t/Q9NqpCG?=
 =?us-ascii?Q?Cd/h2+ywjUxI7qC2/0KMc8v/5I9VD8/Voz/tVuk4bJj7psqeFa58kwDq8cFP?=
 =?us-ascii?Q?J9KT+0jjcEXe6f02jTyGUglnJkdDbdUpKxKlMS3fxrUYWutrSo/ojSpEozJC?=
 =?us-ascii?Q?/3zmKJn1zpu83ttXH4yzRWClvxrdHSnwLsHHITemcHo608sUjtPwrFK/P7vG?=
 =?us-ascii?Q?+sXKo19HA81JQKgEoOcT1CFYPpz1g4akvdG6sS3aY/J1/VTA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 409ea299-ec13-4c1e-3c43-08deb515c770
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 19:43:48.0875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gMYjtmT0s6t4+A4msZ8Yw6cBCD9Y5nN0dp1RZgP6PvteEu77c9dj8iFC6txBroOC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR12MB999239

[ This is part of the patch pile to move SMMUv3 over to the generic page
table:
1) Introduction of new gather items and RISCV usage
  https://patch.msgid.link/r/0-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com
2) Remove SMMUv3 struct arm_smmu_cmdq_ent
  https://patch.msgid.link/r/0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com
3) Organize the SMMUv3 invalidation flow so iommupt can use it
4) Use the generic iommu page table for SMMUv3

It depends on #2 only

The whole branch is here:
   https://github.com/jgunthorpe/linux/commits/iommu_pt_arm64/
]

iommupt has a design that focuses on building a single iommu_iotlb_gather
for arbitary batches of map/unmap operations. The gather uses the free
list and it captures invalidations of tables, leaves and supports mixed
levels.

The introduction of PT_FEAT_DETAILED_GATHER provides some additional
information that is useful for ARM: the damage bitmaps for the table and
level changes.

Prior to switching SMMUv3 over to use iommupt prepare for this by
reworking the internal invalidation to work on the same data format that
iommupt will produce. Bridge the invalidations generated by io-pgtable
into the new format. The conversion is simple enough, io-pgtable generates
invalidation operations that have only a single set bit in
table_levels_bitmap/leaf_levels_bitmap, so we can convert the io-pgtable
provided size into the proper level leaf or table bit.

When iommupt uses this mechanism it will fill in full bitmaps reflecting
the union of all invalidations contained in the gather, and this series
provides an implementation that can work this way.

Like the other drivers the general algorithm focuses on trying to issue a
single command per gather or at most 512 single invalidations. If that
isn't possible then it falls back to full invalidation. Since table and
leaf invalidation are combined together there is no waste of invaliding
tables prior to performing a full invalidation.

On its own this provides value as the invalidation has a number of
rough spots:

 - Non-leaf invalidation actually expands into a TLBI for every
   translation granule because the inner logic doesn't special case the
   walk vs leaf condition. Now that a table_levels_bitmap is used to
   describe the walk invalidation it properly generates a RIL with optimal
   TTL or only one single invalidation.

 - RIL doesn't calculate perfect hints for SVA because the SVA rules are
   different from the io-pgtable-arm rules that the RIL algorithm works
   with. SVA can now express the combined leaf and table invalidation that
   the MM callback represents and get the right TTL, with an optimization
   for the common 4k only scenario.

 - RIL didn't generate a single invalidation like VT-d and AMD do,
   instead it tries to generate an exact coverage with many
   smaller invalidations. Switch it to match the other drivers single
   range approach for performance and consistency. Since ARM has a much
   more flexible range definition the over invalidation is far smaller
   than other systems.

The approach is to introduce a new struct arm_smmu_tlbi which
describes the invalidation, pre-compute into the tlbi the single and
range commands from the start/last and bitmaps, and then apply the
correct pre-computed command to each of items in the invalidation
list.

The RIL and single calculations are revised to use the new bitmaps
and accurately generate TTL/stride/etc.

Some of this design is to support another series to remove the batch on
the stack. Now that we have the invalidation list and the tlbi it is
simple to just expand the invs list directly into commands instead of
using the temporary on-stack batch array. Eventually removing batch will
save ~1k of stack usage here.

Jason Gunthorpe (8):
  iommu/arm-smmu-v3: Pass the parameters for the invalidation in a
    struct
  iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
  iommu/arm-smmu-v3: Optimize range invalidation for latency
  iommu/arm-smmu-v3: Keep track in the arm_smmu_invs if RIL is used
  iommu/arm-smmu-v3: Precompute the invalidation commands
  iommu/arm-smmu-v3: Populate the tlbi at the top of the call chain
  iommu/arm-smmu-v3: Change how the tlbi describes the invalidation
  iommu/arm-smmu-v3: Support the DS expansion of RIL's SCALE

 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  32 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  30 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 439 ++++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  54 ++-
 4 files changed, 382 insertions(+), 173 deletions(-)


base-commit: 82440c340635733f86ab9b1ade899ea21ef9da0b
-- 
2.43.0


Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013005.outbound.protection.outlook.com [40.107.201.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA4141A92E;
	Tue, 14 Jul 2026 18:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784054779; cv=fail; b=TIZFGxTfByKDRKFyEBZ+lr6ZctT8CunqzRBox8D5iksEguWySELnZi8FOvhq+pRn0nAQsEn4SIhjEhua6zlxvmI1M4HwqBJRBzthslWyRhL5ZTrhM3rvGPdSfwcVBb/XDS1w6NvmQJEkWhCUov7qw9NpWG50qf79vdRUrU5Ucns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784054779; c=relaxed/simple;
	bh=AeLEJ/lK1Q4W8OD39SrMhlsYKMMX/L2haaqlzXxNJG8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=NEkZklkifIyiQPSEFGtIkCedqFOOcJICADujSI1XRptXBAvlKJz/hr5TryN1fmCP1CjdtX1mB8knGOGoMSjrS0FRFDkPKV1othFUntKEFuDkZCMwEIdrQstRq1oPp3yX7YbjMr/k+Qdh2L6uHrBwIu0i8SY0KL91WTBQn7YyZ6A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HonZdIql; arc=fail smtp.client-ip=40.107.201.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HonZdIql"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jksj6VaJ7HGGAuHKjhTjP1u8U9NlYTT/pCw0eOCvw6ulexcBkFJkHrH/1j+ZDshY5nF1C49qsEGFoPGeLNxTj2Yt7+jEGCeZriZE6LqcK2K3FJ09/tt9L3+A04eNyMxz6d9xO8yifgKPNcHR+zB8RSQ/uWQiOY5s/kUbgH1PwVn5I+3ouyzFxMw1mzDm9Auwr+cSNV9PyBCnt5+Fa4lueISVTzFCfRuGmWxW7QtqA6ZQ0Cgn41vp2Qpd5dauWDfT1Ef6F0DU6kuWeuyhpPZYe8+KpmHpUYxP3tcbOQmBMAgnTFh7ZjjxO6bkpJSWdi68Fm82RJDXtz8goxuYPuF9nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dhfJZ3MR/pDRkwKbbqIaePXOsbmzobCQQG0MMPYpHRs=;
 b=d1uL0ojYoMQqKFywV7PYUQGWEzd8fLNbZZWbVaztxH1aRq2yf9FL6uspTVUvjwMEcBpZoW0HwSGkwlm3zW1CcWn6JHhc1TvskOj7tP3wfvHJzzrfCDkrMPjnl9WLCctN9u8G5XZfqezAFpPDmM8ntB+uNsUEiIQjfiGrx5yGBvfQy/CLm6o70LM4qJIU2Txg6fxoOqcv1uHbhvWp8mCC7OAX1UfDdRzcN3ZWxULzDKO/ClppURQSis3PZ3xkyMNML6wCM+RdrUGGMEVo/Mc6Ru8IGi5eXfcsyp4j3zufwRLK89YYgR7x8ON1Y6xUE5zMwauBnn9wJNbbsyEWKKYUmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dhfJZ3MR/pDRkwKbbqIaePXOsbmzobCQQG0MMPYpHRs=;
 b=HonZdIql1rdkz81vmrva24NX5eIPZy6+FNgUeqelWA5TLD/niyBQ+VKf2w7KpuRRYno5lhKa4rPZH25ujKhQ8YJOWHx980DYhG0UjUPwYE72nxo2x4khMOcJowligouv27D1IS1OD53Nkll8Hth9FjrIp3RPAmBYVfCh4gTfcbU8cFE9ZZKw2+j52+PzuD43Egdkt8jYB129AP1RetOnz9DBF2APM4b87HJj0Y5HDeDmzpSNB4qnwlomb91BT9HkAmf5jpt07qUoJvrVX+suENmcQufrfR7E9H/S9fIq3hjDQXykZW/BdHaGSQMJqw4KZ2hruCYAjHat+wx2JTUAvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS7PR12MB5933.namprd12.prod.outlook.com (2603:10b6:8:7c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 18:46:11 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 18:46:11 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 0/8] Organize the SMMUv3 invalidation flow so iommupt can use it
Date: Tue, 14 Jul 2026 15:46:00 -0300
Message-ID: <0-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P221CA0009.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:408:10a::17) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB5933:EE_
X-MS-Office365-Filtering-Correlation-Id: 798145bc-fc5f-4143-d41a-08dee1d82ba5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|3023799007|56012099006|18002099003|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info:
	FifKfo2kJqjQKOxizit1Bu5uYl1e/6U+ZGWWBkNPv1HIL4in0MqDTH8RjdV29HACFDDjl8Qtot0gQBE66cLRM37HxnALHaU937e1GXtAblPdTMQ9z1sp9wHp7bQS+QmFP28/6gLIxTBzYjI8LIQUuRW3ygg/2c57J+RD6PTcylmh9TGDLZKNfuT9geYp5qIfP5f6bacY46o4tlZVTuuvEKB3kYeQbGTpl5+Jr5VHZc6TDggFkJISVUYzkOAMVK/wwE4MOhj44DEFUo7ornaDvG2rBXWxNjyWzlttRk27yO3dRrX+nz6X/lfZO8XdTtzlz6P9FPJkelcIa/xhrzn9vVwR8Eh8Qg7cCB1xpftS7r0ncI3MM3VOyQ56zPskgyXuJf3/NQTqAmfBjUiqRvp+mhLtc0zrknbT44kTgjdDxFbPCGopxwZ+4ucuQOvZQ4o4auGJHgyb6moY2h+UB8b7DnIBK89Ic6RpRwFgBXWalvNaeVx+IS7bMCGc+NBTYbiG9xDAe1zD/d5HWoAns5sS9rI4mRzgA4Ix4o2SQ31LUWKifw9DvTa4oie2EkjEUAvcp3K7AaHo46851aGjUDnldjP0CngoyBV1SUp6KZeW8eni9t0NkS9P/6d02Al5va8MlUWO3YsBF4XCnHFf/weWCufO1zOlBN/woEe4GHIF0zY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(3023799007)(56012099006)(18002099003)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aLURREUZZWlYEYx370SDHq1fuU3bzBMWSwK4cnkjh2MqK7Ttq1icGBT9BgN6?=
 =?us-ascii?Q?HLbMvhBBggMmEGhVllfKgPv81NBQ/k9IfAzSxo/2RrOZXL7HbE6n5alL9vJ2?=
 =?us-ascii?Q?h08iQdvvOUNqohMUBAEpNeyOvMMwDFFwpUNdKqhGTIHtd4kjFal5xLJEW5Pg?=
 =?us-ascii?Q?QHxiGoXB+iGwApOZOj8YHs9QkxegNvEoXzAHsAUVQJO979zR7V+dsGRlv0xU?=
 =?us-ascii?Q?DqjF+BblfkDua3gEbuQC8Che6y2ShtgqOvUeLIiQiJOgSAb4kmpnK2jlFuJ3?=
 =?us-ascii?Q?4+IKsj/t5k96huuvqUXHvU0zPa+WNyO7xSToub0PgQp1FgOUy7soZO7I+zyL?=
 =?us-ascii?Q?0mMuDTfiT3Y+t/A2i/SAi9opcjOG60ntFsXxOWs9Is2ggvzMrnw87C8ErLnn?=
 =?us-ascii?Q?b/Wz2AFgqS/gB2YRx6OZ5cJgN40S48p4IdEtY73NSfxgqZv6ofgRmE3N+q9y?=
 =?us-ascii?Q?MSDc7xC1ecAb0nMkXkoGwdUinu/CuTSoJo+fyebXh4jV71FG4owGSkmd4kE6?=
 =?us-ascii?Q?tqqSwLCel3ux0OLGOSfcBITg05ROJReOXtjEqUk4j6BDhADOrJOrWDhBm7KY?=
 =?us-ascii?Q?EyNPfIuu9BBTj/GIRSioskfnil32o/hW2hKUVMcDw+LLM2Bh97gcheQoMPv4?=
 =?us-ascii?Q?KZLBWDRgJ4eQUFl4TWCOpMnp/lvJpAm2/a+faqWJL/wztHM8yG+bU4bFASn+?=
 =?us-ascii?Q?fmHdYVg9uawPe5JfeHgqBjXldNkpYbbqKwqJ6fpGVkX1cOQquGp772wqtuoV?=
 =?us-ascii?Q?Jwe34giLdsOIga+oPi1uLActIOU1s+Cx0OpWd57OCXAEaO5T2L1vp889Adw3?=
 =?us-ascii?Q?zlQKZSEHXpG3cIxjaF7ZSTi1hkAh2CT4GV24QnBGLmD4wnAxjk91tgkqgRT/?=
 =?us-ascii?Q?VlzYYt8120gWHRaJbsMobIh3+UZC3BTULM7o42/p7E+/50sEsd/k/eIPQV//?=
 =?us-ascii?Q?CwGqUN5ORDxTGDey2oXhA6YOjCeLZ0xA6fcCYQsLCEUu0MUHoiOd0B7PQ7mS?=
 =?us-ascii?Q?OHvFOv4mokF7qA/Q7PTcXSFI0bNcy/6wLP0MQGvLXOnZ8K8wI9Onfhqy5vW9?=
 =?us-ascii?Q?oet3AsKiNhdp9A6GPT8FoWtNI7y+k72slz/EEx80Whb3Zle6pTMkonvT3SMs?=
 =?us-ascii?Q?vumQzgwcCr6VmLqw/F0Xa8Dw/0Uy3pJPKHmRnBVRcQ0MA61Ir2K/Wr+0zfgT?=
 =?us-ascii?Q?XBt3oS4Dzr6IyNtvvOx6kq+csioWRs1qfDQPv3Zey9W+d5eTR0QscridViHs?=
 =?us-ascii?Q?+kt+dfT8VRMGknRLgl+/0+3ThLMkOTgZM7ciD1PV17bV89V5rfZ0Dh7+m0aB?=
 =?us-ascii?Q?fniIk7k7nTNrlRhCbHH9asF3zXLd+TWM/eekN9q6T+nz80N5fYgE7t+J4lTC?=
 =?us-ascii?Q?DcszJ5vA387hZ0PGtXPltbAMFLfs95cn5gkGiujFvp3GAk7abdWIpaaRCNPf?=
 =?us-ascii?Q?/iNstIYTfoAYk/35iFgilI+no1AX9UVgKCEOoL0wLzxOA51qolp7gi6F7EFt?=
 =?us-ascii?Q?Q4ix1o9esC0tKwyF0O9DOATURrwoEh25hDvNVAsa8oJEhmrYfTAxtKSh3E3o?=
 =?us-ascii?Q?Kj3xYrte8e7dntG6Y6zcknRF40VJ7s+7yEzKxkqcu9gSsjxYu2EWB7V+6liM?=
 =?us-ascii?Q?3L+cZ9k6oCd7ek64Wo0bTLMbLYARY0yFVT7U/mLUuYNRXytxQWy1CXHHphU8?=
 =?us-ascii?Q?ZgyK3DIlyTVzQKjM2WGWx4IkXcasy3kxwgp78KD0av7sicp1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 798145bc-fc5f-4143-d41a-08dee1d82ba5
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 18:46:09.7131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q7FwNa0ga2wjaniKMRHp8JMBts+ZVa/C/hLLJVyKs9pa3LFMScFGeRAqq0DjwWVW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5933

[ This is part of the patch pile to move SMMUv3 over to the generic page
table, the precursor patches have been merged now:
1) Organize the SMMUv3 invalidation flow so iommupt can use it
2) Use the generic iommu page table for SMMUv3

There is a small conflict/overlap with Nicolin's series that also adds
FEAT_DS, I will respin this after it is merged.

The whole branch is here:
   https://github.com/jgunthorpe/linux/commits/iommu_pt_arm64/
]

iommupt has a design that focuses on building a single iommu_iotlb_gather
for arbitary batches of map/unmap operations. The gather uses the free
list and it captures invalidations of tables, leaves and supports mixed
levels.

The introduction of PT_FEAT_DETAILED_GATHER provides some additional
information that is useful for ARM: the damage bitmaps for the table and
leaf changes.

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

v3:
 - Carry the base translation granule in the TLBI description and pass the
   domain separately
 - Invalidate the leaves when doing a table invalidation too, corrects a
   missed invalidation but means we don't do anything about the duplicate
   invalidations.
 - Simplify the control flow in a few places
 - Clarify the TTL derivation and accomodate DS
v2: https://patch.msgid.link/r/0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com
 - Rebase to v7.2-rc1
v1: https://lore.kernel.org/all/0-v1-5b1ac97a5403+6588f-smmu_tlbi_jgg@nvidia.com/

Cc: Mostafa Saleh <smostafa@google.com>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pranjal Shrivastava <praan@google.com>
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

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
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 460 ++++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  64 ++-
 4 files changed, 413 insertions(+), 173 deletions(-)


base-commit: 4c73a6222c248384513c4f465e547df80b280a06
-- 
2.43.0


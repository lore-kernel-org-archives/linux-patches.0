Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012012.outbound.protection.outlook.com [40.107.209.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BB43E7624;
	Wed,  5 Aug 2026 19:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785957340; cv=fail; b=o3AFZg2VjwQWwsVpgNsnQFvTgCdj53R3/NuYRsAtmsGNT3cyK2Q95QupvZEunzGOWjG6vcPSyJiXd600RJplWv5YfFMqAU1zjrc7bSDaZ5cgWe5CUZeik5uAmruEmEHWz8cKrko32D/+v7MvUbFBHaGeStQ5S7DsGU63FzofBCQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785957340; c=relaxed/simple;
	bh=lBqC5yurlxZpeVL07AYDo9F2L2/JkoRHktfxGAIMl68=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=aEwl/vR55TQIFV74UE+fkqpfpYDrf5TYNO+Xu/3a4rQUC2itIFOxmkFcGMDx+Hu51gTQTuR+ubWoWcnjIAhKEvO1qH0FbQTEQ63F4vVeiPssMNMaKPMNC7+CdZD62E55ali/jnIPWXAHOrmwgwhHBxxVJ6hKVFTKtjon6pRc/b0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=m1rZnmX8; arc=fail smtp.client-ip=40.107.209.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m1rZnmX8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XEQrDWd/CTiPS0TKCyn8dZ3mE8tZeqBBYp4MpZXJ+6CA4VJLLZo7/OsJbFcnbcunw2rCeWJuONzTMFPJXIQDLdmz9UdaMPP9VUs6N0oHSCHD76oyvUt2GaBQLc7uNak9kf0wCgZv0ZsFmaCNzxNbC8OD/Nfexosoh1WHoEm/IRuEYzg0RCfUgSVHa0P2teeqi5uiCNpjJOfqxWsvLKP51Ds07gjLIsZbpXlJvr34PJOB/ufwgozkI5SDNs95J+BFlDaqtlKSQz9i1N9vMCmw5iAijYIIBOUDKI2G+EX0Gy83Jd9Ikz13znHklCqbbcPTLOlzxym5lJNnMvgy32irnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jUQtcA/o4k/yvMC/qw1EWtuf4XUy1383TFj+I3eOoWc=;
 b=ScItVC2jalqJnjodO9A57ifaPmFrrfvMHgjko4gMt4xpba2a/3/Ko6+Xt7v9UJaZdyJbOWxvPqGa/wra7OoCqXpKqldNEN76+ukHh0+oQaaCVtbU5L3jTzKIMbtNQLTnXRoe0mtVkfbePJZeR5J0ERMu8XI9ICN4x8a2kxUDZmuYgXrHc4Zusrk9Z2Wa/LtfvPI7V5lJPBrqXH0SLMn4NPd1aA/Gqt6xD0RQ1biDY3Ssn71Y4nN4VOYh5YqVbW4ZBmbFQNmnUqao/PieTKFuow9cdOSM6lCtTfVfH1/6K9Efivj9tWZPUhIO9SFuLAOVqSr31Ka7eRpPOoV2pNACtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jUQtcA/o4k/yvMC/qw1EWtuf4XUy1383TFj+I3eOoWc=;
 b=m1rZnmX8U8XfeHw2OPWIyuQhwq7prwuV0hSk3HlZyi5FfTU0HPxd6YcvBzYlXInXVOhk1ajeSHq1aBzEZ0fTFt9Tlqs0VhygWo+br398wiNCPhFpEceIPvvc2yvfuMDLRZcrYJSOvMEI1NSPB6dNpkUeb1BB2YofpFQAl+lIviegSX3V8puOOXZFcgKolGDohJFBnu4VF24P96+U2fMpSCyK3w0kDIq2GKvXZGQ0ll3CC817Xw50Jkq7h1DS06SRAt2R9iVKmsmlElHPoxhwX5GWdS+pDMRHO+vzPIqtTJ/S+x8kBTa64DVjYltCdpnyfFgfcrepbL502VbeK9MnkQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by PH8PR12MB7157.namprd12.prod.outlook.com (2603:10b6:510:22b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Wed, 5 Aug
 2026 19:15:27 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%4]) with mapi id 15.21.0270.017; Wed, 5 Aug 2026
 19:15:27 +0000
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
Subject: [PATCH v4 0/8] Organize the SMMUv3 invalidation flow so iommupt can use it
Date: Wed,  5 Aug 2026 16:15:18 -0300
Message-ID: <0-v4-1802653d8886+492-smmu_tlbi_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0056.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::13) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|PH8PR12MB7157:EE_
X-MS-Office365-Filtering-Correlation-Id: be64a3a3-69fb-495c-b797-08def325e884
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|56012099006|10067099003|11063799006|5023799004|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	lVLrrq/lXLfswRXkpFDYgQzI/0W2IJF2c7XOxqm1Bb/8u8amHxiiWs3iSvQyBbWIbdHIyvEMM+sYMaUngOT+yRMqtFyRBya1UB9BxvSvNItcwx4s0t9rGJf450Hnd9kVbNnU6J8Old1WKdEhyZgCvmY5rghfHeLlOY9LoFlaY/0b/tsW2u5W8Pd7Jy0oFrb1/8l120wOhgTW5tLDC4AGPh1umOXerRpBZibIFmSC+xc5tHg7YetsVY4jsMMKkyt/qc2eNYqsGP+ZxuAILp7K3YCVXoi5rO7LuiDWaE8jO+MjkQrFNTbznT6taoYVPeMzWpQydMcnUOaQu6jzrx0HFwJOn8exo0LdKNA03H+sbDzGk/gjnNyvFGm/aFzgLUmp0uzmzmU0n9KH2bvS9Pqxm/D2ZEgqQTCA/lze31yK9SrRH1EVKa6x5KYOUdiooqkhg0OQspdGCk1FEpBUkgEi9xH0204ycBBLty0S2QBrYFhiCp5koccboanW+vAFBEeah6w7Lb29wY2H/IufpUcvNkqf5TS+0u/8Qk+Y5HjOZ9hD5r+/Yt25ELs+WZ0q+kKSmJ7oCZfyiQ2nRbCN3fusS/0i3DAhKUX3YzMJWLVOzTk9hPw8FTobXqF6/aDTw0qPUbQHOMRtr1yyXnv2afHD2ew3HvHoobOAVxBMoQzUcRg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(56012099006)(10067099003)(11063799006)(5023799004)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yPOGhW1IrbT9mCFdV1ij3YtrQBAnzZxP+WP19ABxATqrYFKneNEhsZdCrLH5?=
 =?us-ascii?Q?sBB82nbZkoOq2ZOfz4JuOVxT6dSY4xL45yoM2Dg3mHO2Uv/FqBf5kaRtGgDe?=
 =?us-ascii?Q?9nrPnutcUEOGXCAIuJyrS1wvSsXIQWAGVu4g3b81GszJ5BF7jzC295l2902s?=
 =?us-ascii?Q?vW2yoUzGP+FTsBYp6nIXrzmJ0ylfMFZwsCDkg8Vgs3TZqlFCqV0DB3fK9Fo6?=
 =?us-ascii?Q?2BlWfzRZD5sn14c+kCyH/OAo0JqBhgzokgfD1l4qFeOiL0qsoSFAaikMijow?=
 =?us-ascii?Q?VYep1MSoSJcwpGb10S6+y4ON6wHLe2y0QzKq8TUThaXAS9iAeq1cQzGfo2EY?=
 =?us-ascii?Q?jkgaUF8pdVDwo/1+7UPto8ozmQ4kqU/QX0AEOj12huWuuy2+5pzjEb25in7T?=
 =?us-ascii?Q?61Yrxz5df/COQonAXYgegPGeyITMPuhB02FyRISVKEZfxjgzskP2xZdHirTN?=
 =?us-ascii?Q?j9AXKJKR4mqbc0C6Di2v97x2JMg0fy3WpQFIYrKHItpSP99eoDqZkrOWeCa6?=
 =?us-ascii?Q?bqhnCNuDDTnRgGwQHOeUg4Dyesj2ziSWpSYTTpNekZwqGxvCVgHfjzB5eLvu?=
 =?us-ascii?Q?rrwDID+9H9o0RYBTgNm5lMv0UHbZ5if70pc0omuBK1ZeOFJquncmgFNHWjcU?=
 =?us-ascii?Q?2mSFXW+DxyJi4h7rr6o/FSdeIQdxtI1mWrGjWTlnlok6cnwiE78yzxl2wARw?=
 =?us-ascii?Q?yJvPwEWtaZ8Eg4mkYQaU2DqQVAUXQxUgEjI1khH/vRODiNacbF6FrpLOtfS+?=
 =?us-ascii?Q?qwJl1JtXSSbHFbk03tvSd5a/+F06LON74tIAsCKYNCmOfzWQhMRpdIPBQZWf?=
 =?us-ascii?Q?tKkmDGj1gl3xemORUeGffpjiB8WQUsx+CC7WKkFXEWHx7GTBk/a4XfTdOG+E?=
 =?us-ascii?Q?AjTe2VK+zDN0ncAsYLw1pQqT6nPtd6ORXhi0UccSe95kQ7hDo2v3SWeButgD?=
 =?us-ascii?Q?5L7bBl9nEEVFanF4GWwnMcjW+iKWFMfXmBwJRMrBAq+kN8t4+jkpJJe9s/gj?=
 =?us-ascii?Q?WbTBASOkHO2fgXdi0PgNlEciUy99JWua9iIFc050g8kGmwuLId7gAbZtvHw9?=
 =?us-ascii?Q?VcUI3oyoQ+F6g72Yv03gxT11jdW2gvbQ9AFPEH5bK1c2nbIOex47875HcOVX?=
 =?us-ascii?Q?bHrkjLTRidlXApq22udFaAyb7w52wlEtsFV05qKoIHcAPAkzGcCN5cz0nA9a?=
 =?us-ascii?Q?Ho1F8BNlo1EzIkRbZBEF2wqrKdo016pvonFnvUPjA65rSz/ki/4FzqCgOCRb?=
 =?us-ascii?Q?pzdOdo7z7jSNdIBF+2F0M5K3iB5C30eJ6x8ELvNo0sve9zqjdJuXGjEmOvDC?=
 =?us-ascii?Q?I+5MJax5Me8X33TtRIVNnTtOq9DPRejFMk2kQMWdUa2dkVMKu28pLBZqKCpn?=
 =?us-ascii?Q?+XFwhgj+PGq1I5S96l5VAGfotq3hf3K1QcL6seyIM1W6mKKrju3YlZfn0Ld2?=
 =?us-ascii?Q?a1jrvVhGIBKWCTil4bj+b+IhQIAwuQuF8G/FKEpBmK9aBaH3a3fdZzcPH5Rv?=
 =?us-ascii?Q?P09FKJlyPBC1mjLfvBMp60MVhJS7YXiiyLW58+BeIYsCMRy6QAcaTWZK7czc?=
 =?us-ascii?Q?zN8hDRQ9XDI4DOE3jt43NJpprgO+ld7Q2i+BSjd9TLUmq0F2kQFLflUqcMcq?=
 =?us-ascii?Q?pWZEKMzhB3poJGk3+BfKC1ARUKjSoM1eQ/a4DWch7dCJHpOsHsZ0Uhwaru4K?=
 =?us-ascii?Q?i7bMj9doq+f9USVhfg3YOurz323MPo+yB7PmzaYyVzyUOBkPE1Aogi8EODpi?=
 =?us-ascii?Q?Ra4ioT98Gg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be64a3a3-69fb-495c-b797-08def325e884
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 19:15:27.5508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4dk6wZ/0Y/rdi22oU9Dxzt7r/raoK5nXb3BeB3jWwQvcco26MbbTGTSjndp8yWD+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7157

[ This is part of the patch pile to move SMMUv3 over to the generic page
table, the precursor patches have been merged now:
1) Organize the SMMUv3 invalidation flow so iommupt can use it
2) Use the generic iommu page table for SMMUv3

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

v4:
 - Rebase on latest smmu branch (accomodate already merged IDR5_DS changes)
 - Fix iopte_size typo in interior patches
 - Tidy arm_smmu_ttl_addr_align() some more
v3: https://patch.msgid.link/r/0-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com
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
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 464 ++++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  62 ++-
 4 files changed, 415 insertions(+), 173 deletions(-)


base-commit: 84adf510a4d031dd5b773a425dfbc8ba78300245
-- 
2.43.0


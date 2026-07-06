Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010040.outbound.protection.outlook.com [52.101.56.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042FD41D4F3;
	Mon,  6 Jul 2026 16:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783355231; cv=fail; b=T0Oy2XXBo6E4NX9du/D5yqn3V97xjZcZwz9gceJKf0Ss/IdUkr1M6gEf2pTB1ONZwPsZia8Sc0wwlV7G6qUwnbKYeKpHTE7z02EW/8qJFf0eKOl6LBdwByTu4/Cl/nx2w8zSI3uyAPUjlKDZD2G6LECy+dSFge8tCmOPkBO0u2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783355231; c=relaxed/simple;
	bh=OcwR9nb3sLdl2wQ4pMrAcJw3JA3XgOt11mvL6FOb7+8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=lw+n4lXzD0KWkGpWr8gr+iMNC+yqxZ70eHQbxReEa+fkmhqrmaRSpl1mPGxLLWGDrv4M/RSfaT1JrL3MdR+Cs5u/fdX1wWTiYt7EOgaa+eEScLRygMNeA+bIaJnP36r9vjGJhE1N8Ri6y53U+Ty2P6QCdNi3PLu7da6gokCipqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Zjsj3gCK; arc=fail smtp.client-ip=52.101.56.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Zjsj3gCK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CuFZF2oIUs16TTErlX2s4RkC+sCY/saH0Ge6JoTU4XdsQGorfksZvrH6HASbUCLaSZeDTyr1aPx1g1NhA34KgeEp+6Ycp4gbHBt947Ao9cuFrw1zZVNB0fb2adaDr5tQGW1zkKtiX+ZekoAJ3S1Z46cpwpXdC6P3MAz2MPaZsxyg6EH3txWmw+3b45z6LNEbKvQPg1NlAlXfcWftkrNWzb/13fojfuLZpO64aj9Gu5gO/KsnjQin3QqY3DR7u0mVsEZS4Pe2q8hJhE6wxn0hrdeY9wOYkEsmLvvJKKY+AySa54vraezsMC5fEKVpPIuXOR/Yws7SkzpGit9K6wM3bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v6GGu2/Kd6EUQdxBs5qBApYvfKSblw9GS/l40qXd9zI=;
 b=Ds58+W+7LbCju0kp6lMzRS/mTGNp1ux+5eVs29/wsQ3D42lLlM2hA4LyJCiOCWsnRRMqbWkWypPX4vd3dcU+QAR9Du5hkSfpQotA+Olo+yKJfTzsvTzUG+0KxEVIj5r8snO1POcgfL9e8TKWZhNH/TgF/Zd7uHr2x3rR+T2jojTfogESHzjhazwGp6IvHT6JbM5jMVjK8wtkgb3GXY3uVFx/PBvncn9j/4fYq6JNx+WOpiL/x2YxdRGqH6QqXk3d3wWGDw58Y14KO+JPxpKqKh58qEYSzmE9rqtP+S9rPK04fwupBTJANqF1Vi17ejETEztnnHM3Zj5NGKoVQl5OZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6GGu2/Kd6EUQdxBs5qBApYvfKSblw9GS/l40qXd9zI=;
 b=Zjsj3gCKXx0DYypD3XxozR9GmfXmDC/VbJibz2tI53fBkcj85WEHfhaL0Gse1ReLTKyHJ0Sd0GS0kjeXuBvJvyZwJly90FjbWvAN2sKCijWWbklGYT2dr+cffG13oOVDBCr01LFoLSfzPJbYviKPFlk8HiPHWl6CamEPpLDyN5P+CMi/+KaevoNuoLy+dwUrBT7aJeeDsf8bfctvRZWkK3FlGockUGaWQwfkqRirPX/p48tRu1AaX8asMc6xlQIK1rpEaOXZCUGh/Twc5vEeZvLxCS1q8eo8R1iudKGnydwDlWNUPeHUBgmJoRwUJ1sjHLUGlztAT3lzpFgaTYPbAA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB7956.namprd12.prod.outlook.com (2603:10b6:806:328::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 16:26:52 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 16:26:52 +0000
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
Subject: [PATCH v2 0/8] Organize the SMMUv3 invalidation flow so iommupt can use it
Date: Mon,  6 Jul 2026 13:26:37 -0300
Message-ID: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0093.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::8) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: f0bd6a95-da48-4082-9889-08dedb7b6262
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|56012099006|5023799004|11063799006|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	mhiS5QsH3ITZmoCbDNcuMxN3dTFPg6F8pWlHk4FXJWOIUm77LEBkfeqPuo7mD/AARmDGNR3+QowCHHVtwC8sneFEgBwqrevwW3o89f4btHC21BNDh2Guecc7Cg9zRH5IMyOW1u3s7kqn+0zHiyevfFEKlPXxUbpZhXjD4G1T6iv0enc3b0UP10LF5yTvUViRbPCXSnPXI+T3V9cyHt2HrT+uZLV3NCDRsgADeaaDE/IobcbatqPAcTLZfnt6DawlEGgRtXB7e1BJQDuh+7oufqGwc+Y5D9pRL0krMwGRKgFIAfDxrUph6TPhlZFBFJVVxnIGvhG8ogslohqkcNh6S/RmCgGQPDxd+CHkCmB1u3Z5J9bIylF2fC7lYb384TZhF9qZaPK/OF/+TJSLYQO468AoUn2OFqD8VueWdPdaxOs7vsrKuKRGaTT3XZB263NHXGFLUXyuNGGMy1VsQhBDr5KvTiB7NjaaNupbAa64uGcHxZdXO2v7mfaS7uiO4WGtHSUu456Etql0P06sLMZR6KzCkTiLqT1Fg5i3bYaPQDELteHqvJiYeHjECMuGcRq+G1B7ie2Q5HRb5uznkK3/jC0LJmft+hemuMLavtIKEcEKMvFKsBbB3dwrl3hbgKKNcS5FLkCSCFJhpeQwEAHrFKShVuaUlwjGhm3XKNIxWec=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(56012099006)(5023799004)(11063799006)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aWVsePGvyWdvEAZtaLU7uyo8GdD8f/6qPDaPRUjMSV8KkMcn2ViBlD2uTFmP?=
 =?us-ascii?Q?3I2x7NE4E4AXWsz2RqAfZQo8lxOo29p4yiNDmzb2GzhZnQ8oW/lfgLHS4sXQ?=
 =?us-ascii?Q?dd+FwjYwWWdoVyZbj0OozrauDDK67WA/5C7jl6RO75l5O/ZsFHX81qmwshUE?=
 =?us-ascii?Q?1oipKBTFdV0f31SNpj12Vx1pU1VVpgsHNiSWL+f6pw9lpYPSAz9iXd6XGU8B?=
 =?us-ascii?Q?/WYse6k4SsgR8oPOXT7+qLYRwTPeIL6dPyYQKItuOuUCslIU1uPP908hjhOi?=
 =?us-ascii?Q?wuwyNigeQJiWB/Ny3y/lgvYSEzN72J3WND+Xt2rZs4ErlRu+odvuT77wnBd3?=
 =?us-ascii?Q?vGnHTOaGOAsupdCeaKXKGaradO9xBhmHno5NTqaoCk62UWMrlLyD/Df77pfD?=
 =?us-ascii?Q?F8pWfaXZpn5bXqRrf8pJx/hNOR3E1YC/tnjzTSg1jX3FUCu6ITvQl1qjI+Ao?=
 =?us-ascii?Q?p6rrhUuVzL0NrX2IjVwrWE3yei11dpN9+4QFc+YyjTM3I6GuEZpHrQt+G2EL?=
 =?us-ascii?Q?qXRUZ+w/47zLKHqWrdXq2wuHMxKSgQpLDfXGe1r0pZegSNTipkpApFoBeHDQ?=
 =?us-ascii?Q?RQh31zQzGX+dV69Rxx2k9fK6dhdrFo3eHLZ6zIDZc1SxyliiPYMS2/Mw9C2/?=
 =?us-ascii?Q?VA5HYE2n96JeQtyCfwXufZzJ5AOUmb9BuU1CDnTKUFhgjfEMgtjYqCq0LmU2?=
 =?us-ascii?Q?SjgaId7V41ILvoPuWTppYp8VpgmO30ILlvrTWU1TVjkWX/0YjL39kwvfVFjk?=
 =?us-ascii?Q?qQ+/uBKlT2ywRhNf4hiULB5FbVxVS8VLq2hm6TnE0iN1dGtgnJKhe4bpPm8P?=
 =?us-ascii?Q?aBgDDcxT5nbRTfDIogJt2b19E0C77i+n5F/wCnu63oiB/zi+H8uCdeetJlH7?=
 =?us-ascii?Q?YyYKhmtwecygGovMCv5cb2HsdB0aFQE6ZYmbPSvAzNbRbPNOIjBLvRIU+gpt?=
 =?us-ascii?Q?FBimn6eWmcC/gqKDuzc1ytbOcHdnI3rPxWZwg+KcQBoAjoomuDLvckTpPoWy?=
 =?us-ascii?Q?wwsE8dyungsR/Y/6i8xctxQG92pbTvOBQ2rI96/10/ISdtjVGvH1rjtjibeN?=
 =?us-ascii?Q?okEea+gHAiWrDQyGMLzwjHOfFjX4buGIhvlPeQsmm2lEEcy5hxKxP0rJ/Xos?=
 =?us-ascii?Q?wCocpGubYQL36O/oja/4BfKk2iKbb1Al6jmhMseO5DvLcoav+0DOMASdsZ+D?=
 =?us-ascii?Q?9uDe/KWzq1dU5Pjb460laQLWpEThX7b+daHioXTkKlPh5nrwAzeNFnKKar79?=
 =?us-ascii?Q?F3PzycSgjOUpkDDEfgaQx2IJA9qPuFo5di2b5VuKLM5SVGR+ru9IxSSjGoLd?=
 =?us-ascii?Q?qCWe7LZ5ILiyJKLlBmsVnVyfAVTFs/lPgrUxlhWCiOsbZUsAn7C2a2B4N4qP?=
 =?us-ascii?Q?H31F6NVTcVW9nZczvlX/wFy+rKF++1SrX1EuJyuUvDPjX08I2aYUHzz5ploZ?=
 =?us-ascii?Q?FG8vGgtMcr1cQfK3b0F2WamwV5hnLV7oTavjT5M+jThziyvrq9X7Gr+AVyPC?=
 =?us-ascii?Q?uLV8WdOJK2O/1H+QPAs0i4fLTC4LDoSLm8SkavjyS564rDj6vhuMSRcI3PJC?=
 =?us-ascii?Q?0VfAQ3FIL1zeX3xbwSzOna+mvKxN0unI+yvh5/RySLZmOalIRwKmbMwFtAcT?=
 =?us-ascii?Q?6GKFQSHgX1sU6U5uEmcIhUrGXF9PcGWw82HWcS+6kCrKiv8+zjq/PWhSHayc?=
 =?us-ascii?Q?sneMdodcdM9nXG+pW+uEuhcno434HVnbTm1E2IYKqx3iTiwH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0bd6a95-da48-4082-9889-08dedb7b6262
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 16:26:51.4172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ONJbr5IaB/gX/IKUb4ybUbnN7lWYWlQADX9LZaMLmL7VAyF8SyxWWJVmLjzxD/Je
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7956

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

v2:
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
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 439 ++++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  54 ++-
 4 files changed, 382 insertions(+), 173 deletions(-)


base-commit: 4c73a6222c248384513c4f465e547df80b280a06
-- 
2.43.0


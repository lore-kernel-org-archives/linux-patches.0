Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFB11B2EEE;
	Wed, 21 Aug 2024 17:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724261855; cv=fail; b=eASpCZLTZ4NDcWHCdr5Xav/kgCEO3y1nEIW2V8QUVu0HSV6o5lm6mhmvFqWuTItFTK65m7+CrAJQguyufLkvaugQQHefWYENd6MlLVTWH2Nev7bjgliJf4bdk8PItiBBpav9p48uepiXcZtiD/HldWZKraR9f8mIUCoIAjVVBo4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724261855; c=relaxed/simple;
	bh=cDBVTDF8f5Z3MA6MEIdPsOCXtzEa7ELQFKNQ6hnY4Zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YSgEMUV/8s1zPR732ozCoICHp+zgetTyVn2TsdOsBH0h0u/lYxRhR4q7542lApHHp36knCCAVh9+r7rsI9FKubmFEjSoXrtx/e+LfolEnyPqYu+1fUA84Q+tkQOKI1wYg5NylkrCDXa0/cdLUlgYllOM+0hBv8ntv5AuhU4FnGQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=J22C7zJ1; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J22C7zJ1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZhJuap3TjFI6aeqLDTvcJ6wskuK+LFv7B9JoD/aDWvuleQMwasuUdRJSnH+2l/jwJ9u7oYwd/SOwQJkV30I724xQ37xsBxL8031CJkVmxy7g6jWf7KR65FWO0S92FT8JF64hVX/WMBUktAilKjjApFZIS1hhLO0WPwx7Bf/kn+iKh3sfUFZrGmzBBP1H+Fv6TPHtLN/EeEQhMYhZoip2vq0EiopZVhzWKEuFnYjqTH3yS6ceY73bLHyDVc435VZltiGpFcogcbrzeAM5Y+Mqp/VicqDttaOx9EbFKv1uffPT/Est6Nh3UTevVl9J5DamESFJtHhTgbABiR+VbZ5k3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=14eBT9IgywXa2AW1wLAtP5lpqZg45tKMYy3u1KJGBrI=;
 b=TKxebzCdB4B2/CntmP1VYX8KAoSbyaUVgUP2l8ZO9nYzzdoxDy1GluhcGVgw8g+v/Q81G1cXIF3ttjL4KZYNdMHorKbkiOhzj3S0WP7/YFwUeuu+aRfNqT4fRQznr8dbUpvzqi56h/HC7RlbHpYAdKggDhbQbo0ak8tBx1LhZV/x9JmY+3bO3j547fRCWUkQHugW5TU7NMPLxbfMv/mOlboZx8SHfOa9XIktghZJmNEbQfUZTk+RBhzM9xeKlswJY6mqQDmTLDA8aLfE0TdTIEJB/hWdKp7vFTRmVTSHe9/aeRyHMpMTggFYLv3HJETlnLRBGRaIOw0lHWo2vlcl/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14eBT9IgywXa2AW1wLAtP5lpqZg45tKMYy3u1KJGBrI=;
 b=J22C7zJ18W4GWBoGopD68kFXb81xVlUr4x3AwZXxTt39/lDjWv7CAERj8ybd6ps/xi5EgcoEM61Z5x2svnKFyfMDO1D2TwRROfFwpXLMW0T4GrjfS8jp1JyAP3wwp5YByvGk3rqp/FjrsaTAa0kLFSB/2IU+s9YiY/SiaC/2k9xLGodnCMmbwFRoWIcBBAFyIF0i04wFlN8LLLmp3HP9G4gHtB7NVcGXnb9zIl0vNOB/xAMWSWyHmgnqcmPSIogLgpwXQflHm4rxs1AJ/O6qBrU8hR+XR1wuwTlVZ2qjMPqWht+REEfODnbCgf+BzRpRW2rBpOhin15udouur4baug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CH3PR12MB9098.namprd12.prod.outlook.com (2603:10b6:610:19e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.25; Wed, 21 Aug
 2024 17:37:22 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Wed, 21 Aug 2024
 17:37:22 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH 12/14] iommu/amd: Remove the confusing dummy iommu_flush_ops tlb ops
Date: Wed, 21 Aug 2024 14:37:18 -0300
Message-ID: <12-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v1-cdaaddf80abb+14190-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:208:36e::6) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CH3PR12MB9098:EE_
X-MS-Office365-Filtering-Correlation-Id: 176475bc-9f36-444f-2d21-08dcc207e967
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?437AnUgugVgDRwJtGHnPqvzpT/hlDLNaN07PC3AVhkVJO3Qo3eE3QgbpDyr1?=
 =?us-ascii?Q?rjE7rQIzDPfAhbm4SIM9/QZowKeH8EBNJnwhhhU+8XdcmIhfzWfaNfOFNNSF?=
 =?us-ascii?Q?mAGgx6hUjgIIu04uldaRzoS209SY+nBo35prPLRj/MT7OTwkHOjcOn9fZZS3?=
 =?us-ascii?Q?35pBJfSHCkh0dIeXKqB8/3AETFmcLzv0rY393xL7HvCjYYV4XzxL3Z0+aci6?=
 =?us-ascii?Q?D9ETHHi2Rpc0oXpzZ3+6zTginN5hvHL9IS6xt8jSy5Tt1TCyvc80M4uN3frr?=
 =?us-ascii?Q?13udJDK7BCkvwx59+GnfFeUYpBLfJWDLB2razJKE24kmpUSKru24iPZifZ4d?=
 =?us-ascii?Q?ioGgvrM1pInaKhKu2056TFMumQcfixw4Q51jdqWfkdkTAGPuoa1i20q4VExa?=
 =?us-ascii?Q?GqC+jgcbgul/I1rJx8WR/DSYgKLc20/y0TZsh07hgY6lIADnXL3xMbkmPhzK?=
 =?us-ascii?Q?Y+ih1HMT4eT0abC956H3iUYs78d2SFt/Rh4psGJriIL1pbT5BjBYIJ3JAyQ9?=
 =?us-ascii?Q?exptGlZiy8CvNW76zZUHByGBEv/NfgK5sHoxc1dR5DmakjCwteBwZm1xPBdV?=
 =?us-ascii?Q?fWzXmIjugcqDGygQ8MS9lS7q/5n46EVbPa2isPN2yunuo8IOvCIZ6PKwzT3l?=
 =?us-ascii?Q?p2I8h60sXYUuqYQZsJcDNOIKZ+ORrLBHwoG/F5TRhoNZz8hvhjrKNOik3kZU?=
 =?us-ascii?Q?x8V40VtlP4vj5JGVh6XNYDfowMZfyHHnVP/p3koYRvTwQ/ncFJe3tH1j/IPp?=
 =?us-ascii?Q?+bScDbQ+0h+jX6e2i761zm00F+aMV0AtSg/or6dgueYH1hkQ+VRe1R04367o?=
 =?us-ascii?Q?Od68JkI85HD1aarEBMGQR6+hEeu+Iv/L5ZC/C4ctHKZLKo4nCZ5fO03ucBRX?=
 =?us-ascii?Q?ky9WDrv4zwwBAmqHW6nWrlU6YoEAPWzwf1FptrVc6dfZ8I6hYV0dGvjqLj9n?=
 =?us-ascii?Q?4YB5G1Xiiz3O/U1zhbvR+0iPjjVFet3yw94z3+F9Bf6vEu08DJj64yLGcwkl?=
 =?us-ascii?Q?26fn8psIlMi2EBD5Z+Lp6zeOy2NdUP9VRaNTt1olNL6PyVO+0KxsKWnr29BZ?=
 =?us-ascii?Q?1DZkxvFwWifjp3kEErmBibSOMwW7GTrj5JMQHbweAjuHIlUZsBQW85SojqkV?=
 =?us-ascii?Q?t5WdsB5fj4+GCPdd2Ii0qVDz8t9mgqsD9i+zTya7lmp59ss+3RDwAkebgn5m?=
 =?us-ascii?Q?vow7WcGvqLZZk4lN7Hc7V8h0e+uG+5WcPnDwzpo79vmFWbb3gVu204Scx2uQ?=
 =?us-ascii?Q?MS9TiJ6IYZIapq4MWi8kP/0Owglcvkyfs4SPCtV5HwS5/Fyfp1yn2Vcx276h?=
 =?us-ascii?Q?SyROK/eQGFT1ciSBrsfP8N5zWXkycbwGiGA96jRomVmHvg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fQQ0niQnIaxo2lYaMpMX3pgFkBOTaIsGWCSQCm2PsKR+lZpFTYc5eqVVyrTJ?=
 =?us-ascii?Q?14dZjwfUlfB/yex4ilUFFTQOIqQ3wvlXATbxMPnjxD+l5b1xfEOnDFbn9H8v?=
 =?us-ascii?Q?AvlQg17S5mTzQN9jgmfFZTIZyKCe1DBvhaYPWSEBoS551hVp0CDlYDRYbV2E?=
 =?us-ascii?Q?uaPha2oqzpIsVpjmJcSu5iR+Drjci1bsbRKMoLlgWedi7+fLilsXAU3K3pRB?=
 =?us-ascii?Q?bEqItvRwFsRj4ZQ4WFCNUi2B+PRiSFQNpkkbaZvO5u09oza56hU0hX/vwOSd?=
 =?us-ascii?Q?nWufz4WoQU+6CbZQaHtngER8Mor8VQPQMmAzk0Rk29Yf/EWN1K6bnIACi6xt?=
 =?us-ascii?Q?fgsUFxogO6Ud0PmZmc7k8ASVzBaHB0C612hx46qGD04NUdaFO1lFbDWolE6O?=
 =?us-ascii?Q?qoo4ZyIrLR8al0regxQ+iVynTbr/wrJIkoaTGAM6dqMR4HrWJN86EIbhyRjs?=
 =?us-ascii?Q?h1CjfOxoZJ/ti+X9YfvySppyXRlMuuE8ulAzbcp73dT85b94A3XY5CYmjm0B?=
 =?us-ascii?Q?c6pTgG6VpyNJG33tYNs4h2eab9ZNr1/WjWllVuG5uUHoTieDntl19x2J3Oop?=
 =?us-ascii?Q?4/qvqhrn/wIgb1feDc2zOaeOsySBe8DT8t87OAcvT8+wcCR/QmBG0+8zVHbm?=
 =?us-ascii?Q?Sqh9Dukir7LelSpgHVCHQNuGsm8seajkHdEEkyTtM+WqlW6Ug3cQEc0rFdes?=
 =?us-ascii?Q?CSMqFgPm1s8QerTl0oo2D93LsyIuULn/kEnB+wtaKLDJXtRfA7uTNHBZh00V?=
 =?us-ascii?Q?2vReTdHHxiKV86j3ELDIznnmjHMdS5l69jv7kNvh5yzepSemh5c+sj4eIlDC?=
 =?us-ascii?Q?8/FM4kq+FYvVyhtnHCZ8YueHMvxLjbNieFIO33AL/R9Ml2oX5v6YkMRECX0x?=
 =?us-ascii?Q?W721q4uupu4p9MDhSzNbOy356ka0+/Q00AS6huYgvW9O4CrxTYkk9zk4Tekl?=
 =?us-ascii?Q?yUOHunxPY5HdT+jj56bfywnJQo+4bO+s6bx69McckOTQuJskh4Dnx/QfFWzw?=
 =?us-ascii?Q?46GthyEhtQsYT90B2zSPcNPjUgCipWqjPgtq2Jg5Fs8cE+cgX05+SyMZsyAi?=
 =?us-ascii?Q?VRquXH2mTto1wlo1igHcWnY1uLWU5BVCpjQ6c78/229WWiUTXJQ1TxlRyRP9?=
 =?us-ascii?Q?+Cf3srr5p92COflj3ikqYQ1eqF4CFK6HuSmW2mENT5N7t0SVyK4PmnN6Uv5I?=
 =?us-ascii?Q?enBXJyISB9l86Y0FR0k44gyqi7Op7Tplrz1qFVRz6t5S/C5orzg1Athnk/Ih?=
 =?us-ascii?Q?fpcdSa9m0Y2Nh+w1Ar+/xVTNODw8uDIANxyjdq0M0VyMaV5aLl9IA9pMjOEY?=
 =?us-ascii?Q?HI4UsqlIz2uJYkUGerRFiikT/bCTQhCKEHkKLRdGQ4VFTc/4Jj5iQm3dOi6V?=
 =?us-ascii?Q?PphG28jCzGoX8Kjt/EvmBIOoOgcS5a6ISSLkDM3V8v37/vdPCXHk7DfQFDPp?=
 =?us-ascii?Q?PnEffniWsvoc5lKuC6pXyOzsmchNrCz+GPLNJykBUA/vwDG9u5njBnv60Z7N?=
 =?us-ascii?Q?l99OGimGGRkEhrTQsfoi/hLvTpH/HamxF1KLO35cl21IXI6S3P6U54Ps/XXD?=
 =?us-ascii?Q?Q+xriMWAx1jiUR5EbDY8/aQzF4SkxAYhAjNy85zg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 176475bc-9f36-444f-2d21-08dcc207e967
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2024 17:37:21.7159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qYXPhfqoXX+uSqWPfCNPQ1L5VJcjxkiq2Ve6+5oAFnBR5NsDZ1ZfrpGi04mq8dM+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9098

The iommu driver is supposed to provide these ops to its io_pgtable
implementation so that it can hook the invalidations and do the right
thing.

They are called by wrapper functions like io_pgtable_tlb_add_page() etc,
which the AMD code never calls.

Instead it directly calls the AMD IOMMU invalidation functions by casting
to the struct protection_domain. Remove it all.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/io_pgtable.c    | 22 ----------------------
 drivers/iommu/amd/io_pgtable_v2.c | 22 ----------------------
 2 files changed, 44 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index cb8f23e878028a..aaf7858a0a421d 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -24,27 +24,6 @@
 #include "amd_iommu.h"
 #include "../iommu-pages.h"
 
-static void v1_tlb_flush_all(void *cookie)
-{
-}
-
-static void v1_tlb_flush_walk(unsigned long iova, size_t size,
-				  size_t granule, void *cookie)
-{
-}
-
-static void v1_tlb_add_page(struct iommu_iotlb_gather *gather,
-					 unsigned long iova, size_t granule,
-					 void *cookie)
-{
-}
-
-static const struct iommu_flush_ops v1_flush_ops = {
-	.tlb_flush_all	= v1_tlb_flush_all,
-	.tlb_flush_walk = v1_tlb_flush_walk,
-	.tlb_add_page	= v1_tlb_add_page,
-};
-
 /*
  * Helper function to get the first pte of a large mapping
  */
@@ -572,7 +551,6 @@ static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 	cfg->pgsize_bitmap  = AMD_IOMMU_PGSIZES;
 	cfg->ias            = IOMMU_IN_ADDR_BIT_SIZE;
 	cfg->oas            = IOMMU_OUT_ADDR_BIT_SIZE;
-	cfg->tlb            = &v1_flush_ops;
 
 	pgtable->pgtbl.ops.map_pages    = iommu_v1_map_pages;
 	pgtable->pgtbl.ops.unmap_pages  = iommu_v1_unmap_pages;
diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index 910fe1879f3e41..77cc1b4a3f0225 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -326,27 +326,6 @@ static phys_addr_t iommu_v2_iova_to_phys(struct io_pgtable_ops *ops, unsigned lo
 /*
  * ----------------------------------------------------
  */
-static void v2_tlb_flush_all(void *cookie)
-{
-}
-
-static void v2_tlb_flush_walk(unsigned long iova, size_t size,
-			      size_t granule, void *cookie)
-{
-}
-
-static void v2_tlb_add_page(struct iommu_iotlb_gather *gather,
-			    unsigned long iova, size_t granule,
-			    void *cookie)
-{
-}
-
-static const struct iommu_flush_ops v2_flush_ops = {
-	.tlb_flush_all	= v2_tlb_flush_all,
-	.tlb_flush_walk = v2_tlb_flush_walk,
-	.tlb_add_page	= v2_tlb_add_page,
-};
-
 static void v2_free_pgtable(struct io_pgtable *iop)
 {
 	struct amd_io_pgtable *pgtable = container_of(iop, struct amd_io_pgtable, pgtbl);
@@ -378,7 +357,6 @@ static struct io_pgtable *v2_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 	cfg->pgsize_bitmap = AMD_IOMMU_PGSIZES_V2;
 	cfg->ias           = ias;
 	cfg->oas           = IOMMU_OUT_ADDR_BIT_SIZE;
-	cfg->tlb           = &v2_flush_ops;
 
 	return &pgtable->pgtbl;
 }
-- 
2.46.0


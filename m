Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65962572;
	Fri, 30 Aug 2024 00:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724976401; cv=fail; b=FG/WuCrD1ux8FNPh8OSQ+Zy+A8Q8tG9qepoBJ36k8/sLKVPviI4Ncm2B982yL+J73DfEq/saUZ8eaT/+doO4EfX/iAqs79ToqDH04T02ptuKumpA4fSvN7JpemoD0LrpZhKfTkpzzWuByMqw/Gj8Rs5HmRr+MiZ7MXlCFzbBeT8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724976401; c=relaxed/simple;
	bh=zOtZ21IgTco36dTpoMJLjXJBvxqN/Kk2JBHGfe2I/A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hr6ZzASAiXUf3AUxPDKYqnBhb15N/J7gsVeSDGDqdBkkarFuOeTbH59BTNMapqngqEWXu/Smuw8SoApbpJ+O8SJCfrNokRJsxn8XBx0+sDnP+0KuDlJBYH5zGJ51vByX5zcSPvMAMzLNYNmviVCugA1IoOST4QfLlv4r7em7t2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mGvRuw+Q; arc=fail smtp.client-ip=40.107.243.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mGvRuw+Q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EtsaRt9oAeqQlhzTFmU3OIOKb5NV6pxUnjs+FoheS+5YY9UKieH68N/Wsg9b0kNrgmcYtTDej7dhjywAwDguuYBRkyNbSzjSukOdSzb2XOsUNXfSiO4vH99GJz+0EQFuc88BFRiWJSu88YewdC627QvW7Bx1ByCN1KBWJ3s44ptDqbBbTXCXlPZdWyzYhD2opjtDR1MU4aVXDxu+CYvCwvLejAOvATqbodgBfQD3mfWBfWFSbzMZo1/AAwb60+xOam45Pt/GnwGOukalPynJ4mKxYVhlteRLCBNERCTL6DamEf+HHkNeE61HBgoBqYCitiTfV1MxNModFs8AjU+7Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KTWvr0K/YE2BObOagFPLPADXd3WeovaCsSjCGrozt14=;
 b=alHk3B5OQaSnKp4gVPMMRcI84RIV0Ffx/gPOayAexkh3rfi0PQ1Hezp3o8Zk5weDCsygv32zJmhRnhoPURVOmG0FcdaF1tvivIVK7ToK9RjKEbkX96n1yoE8Oyil4UKfOGVhxdZleKSUmqzrNtrL9iyCHzFugEo+ynZJTjIFwtz8zwj+EjhZWMyaLRnJYL8lDgJSxZpqX4JNqiJjoYNqDgBzH3pQUT5YBC9Y9Q6YZ9F5wFG61yQDsqoBIQ9eDQ+rc6eiQrUxaUUB9CEmXA6R8doeG5sFi4RcO3Gnt8cILqAoOoyYkUpodHHe8cUXK7m9G9p83w/P4M1tA75kSA2C3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTWvr0K/YE2BObOagFPLPADXd3WeovaCsSjCGrozt14=;
 b=mGvRuw+QR60IpRoa25COgD9ZVUpImDPtA5nJB2dFaj+Dq7PIydKEn7cQS0scXFROuHO7jyRnki+K4GBa3pGbzoRu4mrHF6rEW2kGiriLRDL6BlKQ8+d8nR7+MpI1du2cR9xGI/M92Rr81OLt4/cwfSkg0q74bBnNrFh6zJkXIw9Pi2q+h0Gq4H8TA4jnzbJ93huHTmL2nO6zRfFe2s0qSVHgTWZlMiVijwZ2Dm8WfImCpA/4YlJHXfR5jrgkPLZsKLEGmXLjmxhE+HrCghNP2arhWj8sY76OcUy3mjKPCQ8StgdirJCNO7WhD5lG1dLim3zy1sFWQ6ipkQGzZYT+JQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH8PR12MB8431.namprd12.prod.outlook.com (2603:10b6:510:25a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 00:06:31 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 00:06:31 +0000
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
Subject: [PATCH v2 12/14] iommu/amd: Remove the confusing dummy iommu_flush_ops tlb ops
Date: Thu, 29 Aug 2024 21:06:21 -0300
Message-ID: <12-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR07CA0005.namprd07.prod.outlook.com
 (2603:10b6:408:141::20) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH8PR12MB8431:EE_
X-MS-Office365-Filtering-Correlation-Id: 332da79e-800c-4e5e-dbc8-08dcc88796b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lz57WrKx+m8FxKtfDeGPhXyS8kX8M2SS36CAYewnWgqXnuBuklnvztUTpHsx?=
 =?us-ascii?Q?pTjWPr0+nREOAVM6kS2An5d4ugx3SLRruBCjMLJ4beS4s30OjIfWBcKPdA+0?=
 =?us-ascii?Q?WntD2i8QqkEYP5ZyFv4Ah8svzlO1wRvfjHud/QqxN1Im0qSZWtxdjsChQBxI?=
 =?us-ascii?Q?Hh7taICL4/td4/5jFc4FPk5vJmnrH+SDee+hhUxJTeALp58gEFAqJtsLnZIW?=
 =?us-ascii?Q?xfv7DZIvvgZdA29fN9uC/DWrIlF3Mw1dFyV4uZFiqyQGbIG1EVKFpR15NHj6?=
 =?us-ascii?Q?jCpPXJucHhd5paIqFU6JPtN70jSU0OFt4DzLyv71nijEdWajNdelv3BN+HSO?=
 =?us-ascii?Q?ZpLGbCx76KsI4xD+cA5/WNrKgCqmUKBYHDvMGSDl90fRAAehBMqtkFe1H809?=
 =?us-ascii?Q?jhYwSkjwgESUEGlpcFk/QGcjC9H/j5Hmy6fzPnnkjzFSEivqZaB5xard3xO4?=
 =?us-ascii?Q?S2EGAg1renKoOrev1O3Tm9vqTJeRxN/vmadj7G1B8ORjJnPCo6VZgzJdAQHg?=
 =?us-ascii?Q?9vW/p4jFh+vPAbQQKhiFGqFKmz7gf1lVieichenoCp8ZVmDPuklEoSl+dAXK?=
 =?us-ascii?Q?6l9Zv8N4RSCAQ9R9rneU46p8faaRWpWZP2ZP6z8F7/SKDSpVE8jYW9PrJYCm?=
 =?us-ascii?Q?HP7emh7kZpFMTYyz5N3yoS1mJcZmupmRIRCpN1FNcEPB9qa00iA6Td6ENxBA?=
 =?us-ascii?Q?zklIFbdgaZYQLwMFTMgwNeQbu5nTd87PWjbANpA8YOUBn6saPVAmph623iHI?=
 =?us-ascii?Q?ZRuesQX4uPK3uyfDsHTmkdNSrkGiAFpO35JBxXIta+gWEz8Z5wJk/yPskPX4?=
 =?us-ascii?Q?pWpoNPqY7/VZD0DLk/fUgvhCn3NcP7bFl4Qnam3EwvQBHALHvtrHFGvP8C8I?=
 =?us-ascii?Q?bLiSDQsOwGwLLMEv9p6TZJzQuDGsv0Q6Iky9ML8wzsvV3EppmUBdQVcyPmk6?=
 =?us-ascii?Q?uTdXxbgRLlqCa1/vl5pzDMI6dF2LASRrRiBauPC6PGbTGNT1NaeMSLUlf6PI?=
 =?us-ascii?Q?+oVNc9kZyYxtq4Ft7XesHOtXL0eF7R9bfglZwlEsQVvttMnCZgTACrtcp55/?=
 =?us-ascii?Q?DJftHtM9xkSe/BM3JYv+x7LA8NZxdSYZDFlLZLBF/wzUvInEi3ii7QluTTYx?=
 =?us-ascii?Q?2qeHfswoVzaPUY7Ui4u9mLbP5PC6tzgXBj7FBg7hUGF6r62RmiU4IfPRKohY?=
 =?us-ascii?Q?BDoG5Kyt1hH4L9JtfCuaEiNl5HCJDyVVQNyqlmd5Whsiiohtwd56NSqJipZF?=
 =?us-ascii?Q?U3uS/bSiF+mV6NW+9nrwV9feeppW6AnAe6NQH+QEcKlWy0QsVoU57P20ejAm?=
 =?us-ascii?Q?NtEDwnjBP8wPbOB9NTdErGn/JX7+joxVGrHFfzNaJxdKDw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fCgojUnyE0gPFPpRmRpZP1wRLaZFGDgbdfKVQAQrcYAjibA9GtyFA6ATxmTh?=
 =?us-ascii?Q?dwG49HW8GPuEVTFI1VpwuqDKFxUFM9j0+q0Odpg7IQuv0mjuUoTX4q5IG7Yc?=
 =?us-ascii?Q?uLDEwFwognaJlN1pqIlofue+MmbjJzuKx2p7DYTvpIYKycMU23l0UVYi003i?=
 =?us-ascii?Q?8h+B+/HLJfiDxoQSLwHsooCqUJceVNjNeKNMrlOnWYz3Zbj/u/wzmcDO+ys5?=
 =?us-ascii?Q?MyI+yRRXB7wbMgYEZSK8WoP4NjobpVnOdn8zurIuPTp5MvCtwvIfu8jufgQn?=
 =?us-ascii?Q?tMIdgADF4yBkTR2u352udU3HyJsyXVf9QaW516ZibUUH2rQIG3a7TUrxDDYf?=
 =?us-ascii?Q?Fhv0M2IqoBCaJ73U0nVBxPBNTdh22puKCcsPqniuamnuU5l2Zu/Xy20QPxnA?=
 =?us-ascii?Q?u60iGBo5gdfTo4wEIsVrDQCBj2Pq1DM8JdjUB8rnc7oyNlG69omaDU18QSX4?=
 =?us-ascii?Q?zTGkBRx6xZlOIJAdj1M5jF+b7ieFX1T2bsGEmOqY7ABtHAswuzSRH2LNP0Nf?=
 =?us-ascii?Q?ua/KdlY7Nh37ZPzNp7PIfNZ2ZUaXpRy+T3GZGpzp0St2UeDsEcDe67052nUQ?=
 =?us-ascii?Q?vJq7qHjWCyiPgmBZxDPe5xq2S3akMgJ3xIgvhc1QmR3bRkQPlFKzMOzwU4ZG?=
 =?us-ascii?Q?sF87FL8cnXvdS4606HhMHVt2bRq02l2nw1MmSAO/bIWrODSK4hr9EU4Z4a0C?=
 =?us-ascii?Q?9hbSX1j3gi9wdSjEbLpDVSSEkmX93gy8Feo4XrhPMgoaMVr4UTM6vE/Moj+K?=
 =?us-ascii?Q?zZQ1jMCPbkGFKepu6bzJfnGIU6LZ3cB1ElAlQRdvLFGb1d3A+LmBD/7ENvS4?=
 =?us-ascii?Q?8pYOydnMxK1ebgsP6A1HeCcLe/vM3GxoXuVPqEKLoXkNBtIV7ySDgLQDApIg?=
 =?us-ascii?Q?3U/ij4W3YwdfvETwiVX3beQo/OFPC30ZWbXPvnaBfQAsLTnm50m8BG9lpuOZ?=
 =?us-ascii?Q?KsuGKm1ky5Q+j630atbPo5L8xSlKu4VPzLNmEP+trxvBAILuxDUwwA5b3ck3?=
 =?us-ascii?Q?bWvGACiW0LW5AeBynCUKbER2bBwmI04pwfgRVQarQHt4oszsqcQa7y4F4irO?=
 =?us-ascii?Q?nDPQ0tfLUW2G/MCxuQbEnvCqlk47ljLLa79u+cb1HP5/A+JK3S2LHYxrDPCn?=
 =?us-ascii?Q?QSsFHNaFiZkJShRTKgtJNhAmFnCSx9/OnlmOnJgck0UcFhXVvsv5pWZbacDN?=
 =?us-ascii?Q?zsORLhdUCcPLwAQyK0VM5XC9S+0tGV+hNvgCUhN7o154b3m8863s17ujAPcE?=
 =?us-ascii?Q?AX2+ZQQ9PnAGg5OCaV85tHhgB1g+gl/UFTZTxXvm/waXaWKVBfatsK1N9h/J?=
 =?us-ascii?Q?rkJcgDCCDL4kwkEJ0eYVh0m3xLjqg8UQFqPTyUj3653ag1isCeCUoeZsP+t+?=
 =?us-ascii?Q?tVrhfV+/ifD2nb82nrQFWuI3XX7WhrG5vt0xEyP9TQYhYdhYdE/E2+byVen6?=
 =?us-ascii?Q?761+qx9mo6oA5KQlje76YZbYN1EWPx70dc3F38wUeV3ynwRWC+FFr+iFMLHW?=
 =?us-ascii?Q?JYzSX6KEzHn5v4Stg9psa9O2udeoWDOzduOB5d3NoYRLiFk+xeoz1hZrA86z?=
 =?us-ascii?Q?hjnItZyL1Jev1yEl66cor0IOo0JL2Kler6GVfzCE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 332da79e-800c-4e5e-dbc8-08dcc88796b0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 00:06:25.5065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2JEljLDnS/+2XYCY49UF750/JCxayVCXnZHUnOY/A+6si+eOW8tO9pumjI+il8D0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8431

The iommu driver is supposed to provide these ops to its io_pgtable
implementation so that it can hook the invalidations and do the right
thing.

They are called by wrapper functions like io_pgtable_tlb_add_page() etc,
which the AMD code never calls.

Instead it directly calls the AMD IOMMU invalidation functions by casting
to the struct protection_domain. Remove it all.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/io_pgtable.c    | 22 ----------------------
 drivers/iommu/amd/io_pgtable_v2.c | 22 ----------------------
 2 files changed, 44 deletions(-)

diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 667718db7ffde8..74d3a7b31bc091 100644
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
@@ -573,7 +552,6 @@ static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
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


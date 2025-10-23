Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012061.outbound.protection.outlook.com [52.101.43.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866E8348442;
	Thu, 23 Oct 2025 18:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761243774; cv=fail; b=YZPqxPhDiTaUybIU2ZZgTIsgKy6NW0Y8UpsGSL9YgjjVxegmajN75WwB9pOm78SlT5J9KC5MVx5VPE9L967vSuvbRKrjQxAZZIZtsJxLkrzhbecjG0Ia+eeuwjQyvbfxrpIla+i90w0sU/qTmMXKQIWXtpoIkzlrdR2FnJQYxn4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761243774; c=relaxed/simple;
	bh=jHYnxsK22Q5vMtrs8bsPKn1zUVp0CHbV4oLmf3Qbar4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UotWJUBwHT6vKNOLO3eE02dTi8ikKjHWfW21RJUu/Pba9M4k+SprC194fge6WLI8WHAc145aCF35ezu8KgSdI1s5BtdjtkVbahtl1XozB579q2R9cx43xvFLce2/MrH3hcpRamlD9grwPYHEE0PobNCLlkE/3yr+/tg9njcnBD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Wo0rgi9Z; arc=fail smtp.client-ip=52.101.43.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Wo0rgi9Z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hK53etjeSEvF7XBuvvlyMDK4uc60OW0Hk68/FqLJM+zP9I1gCC2WH8dbyl6QkdeTWOkvJcRElkJxk4y2dqZmq65w27DtIbLvNzfIEPld1ZSHN3dU5LAb9bKpsS8xPa82vNlCGibwSOGdYxZ1P8xI9fY08LKOjj8D0pbaTIasg8G1KyWSnx7n2IUXjzGRVeqzLbGooXKD0fvbb+xmNcvWC2gVxvMZOqB7IUcJFjrixy01N75QGpj0K6WUKPGwHgi67q83MKuX+2RTqSsZqoRK42JdWAtV1AQZFMxK1aIrB7mYvJGjbnNPBUUET2cLSBUGJu4x1aaif8MBR8RJp4+M/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lueKOfycF+p/LW9lINcRcc3YzmaMBg8BeLgFpEtoJ3E=;
 b=RLN9abS2eGAajXIZTdihB5b/LcnSwYBaE4jP0fj2kQlUv66BeTzT4wUBbDsxpAQY+O8HcyJwEOJTGxHUaQdXIswcUJh6McqDnRlwBsvuG+DXTBNrC/t54+Cl3KUYriNyz8HnGwcxXWJwmO4DdK0xVB21XcWeJVjNnyow4ideV0y9Us7INm4uoOlMBhWGGL2UUYXgQnKFZ23JxIF0k+njfI2SnQ6jc2Do+cbt/ndmisZ7Wfklv2HMDH0+P2bmmjPKcb/Ymikjgvh/omCv/c6DxX1tlWSqnxiw3b94TmZej1lC1S6QnmrIEDLtXum1L8wB3G+E4L82HuQtB6Exslwjlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lueKOfycF+p/LW9lINcRcc3YzmaMBg8BeLgFpEtoJ3E=;
 b=Wo0rgi9ZmI5yQS9eSOrIucv64f6HYw6BOTn8RovNum/bJ7QYFfQfxamDAsHQeSzMpE433+F4NDCA5EEznv9vEVvSCl9PFr9ZaxBP+9G9SARGFCa6rev+V2q6jIGO/ParGwh0zfLffm+GM1KlyaGkzqRr2ql2GaiXX0T/oOYMJnyAILVTLY7oZVaYhXVc9K7FyMeMqNnMB8VLnzkDzVm+4KvrQkl901Y8B/KNHdXpc16J7iibWYyBJRebBvxYisBUyDqP8RZ1cuzV3N6CJcqWVrwV89WT+arEE9ZnVunilc7w0zXLb5M2pWeKSWaLNx4trF+JBqCnZg4yPG+gTn8YXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by IA1PR12MB6164.namprd12.prod.outlook.com (2603:10b6:208:3e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 18:22:44 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 18:22:44 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v3 01/10] iommu/pages: Add support for incoherent IOMMU page table walkers
Date: Thu, 23 Oct 2025 15:22:29 -0300
Message-ID: <1-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0158.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::13) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|IA1PR12MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fab6597-3539-423e-7f00-08de12612885
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2kPc/hzGthUu1T9cJpmtaxwRmwHLoVk09H+tBM+8SaKdGWyErnWrXzSfLu77?=
 =?us-ascii?Q?BTbORSgOWcEjHuhEbtFHj+TtePMluzTUwSc4/J68cWC/NG25dfZAdIu21hB8?=
 =?us-ascii?Q?BgO+UFgSsGPS4Ns1fwhRXd9XL9W1UKY2CJdQrElHueb5Y0vEMIrNWQv4m+BG?=
 =?us-ascii?Q?2SXpOSxMg+pVnjsPdbTtHWhC01Np3j3a0lnEJzdNFmrOw1QVsJjT/IzpFCtq?=
 =?us-ascii?Q?eMqIpPbw0reD1dn2AunshIQtHdELjub50Vq4ge+F5orL3R9nbd1Gwj0RKvRD?=
 =?us-ascii?Q?XkF8A7bmdxUs2dWYQfiCfBM0Cq9SeqORoMceaa6lCUgr+S5LTBiB0iaZlJ4N?=
 =?us-ascii?Q?7J7oB/uIHdA+gzeoolhJ81DfwOh29j+Z7agGlKrE74vCtbc3GBbZDAH5+JSW?=
 =?us-ascii?Q?3+C4nd0M26cPPyotW+aV8JNeovRVFxeTKxWpub/LIDf6y+EFJ3idJVDuQnGp?=
 =?us-ascii?Q?jQ/JANe8qok5HspWeS/89J2B/T3PAagJrLHOL1CJ5o3kffoym7ZsfFcT0hfs?=
 =?us-ascii?Q?Z0a2q8fISjpU2qr/9rIO17zo1XwkQ686LdsNfDPAMFnnVY/6Yrc2OYrFiGGz?=
 =?us-ascii?Q?jmVfSZyzeoYhV7v3bgtnjJbv+r3sEJlpb/ricmKgC0Om39Ie0t9Vl2MrszKl?=
 =?us-ascii?Q?Fv06Qp5/EQyN95L6DVtvFLESbnYNEfXrRudHhQXdSvIaubs7xecQSTzZ4HhF?=
 =?us-ascii?Q?v7B9lyOVDr4u2giZgdlofTmQdNMwpGSwmOxyPWB/1Yvp3e4J7hF75AwW6CCO?=
 =?us-ascii?Q?bupPzQ3Fo+GAXdhUEEyT89qKDVuL671aj6N219tIDi7+9UtDMJMP3je6ktDc?=
 =?us-ascii?Q?2UDAUQmsBe/tpXXeRKLbQ9r+T5j6V8pvTm5GGhiyqZaSAVxdOl78o9oa0GuQ?=
 =?us-ascii?Q?tq7xJrI9pa8/hcTo2Li2KEq3XlcXhvloEpf9vTaXAfjbIITe4Pr0qDksvsrv?=
 =?us-ascii?Q?pLxq6/Svq/eTE1XeGVf2B7o+dZz6BRgre0zRql0ENuzvklyloywZJa4Yubnf?=
 =?us-ascii?Q?pccYFvUmUdWOMMcwfcryeOH54usfRKRjYGs3RIg2tHpZvV0GlT7IClQbQijq?=
 =?us-ascii?Q?0IbPIzlppxsnaOxBeQSk5+XGHv596B87uVN2eQIyTD5X1gEq8+bIx6dHJQk4?=
 =?us-ascii?Q?a7KdyTWtbaOkB/CWYDh3mig4tXOedmqzBrvAvh51/Q6tPPYpVrUkAboQiRDJ?=
 =?us-ascii?Q?ZlklAhDed7noHwR8JPXXeurS3eS5aIeq5eyt+RBDO2z8MSB+VQaD//pZHkw5?=
 =?us-ascii?Q?CObINXyp1C6L6Tgwq+3hAnbA4RT6LPgvE/hof988739Jl65RkRPO6imt985I?=
 =?us-ascii?Q?7CMfmuq7wPIj6eJJYKMfiIyS9s44Z7HhXokzhYSsJyQQKkCxuvkL9ktAobQM?=
 =?us-ascii?Q?dNkU057fEs1dDE9AR2d9WvEg/cm490V7N2duWDC20IhZowC+/LZ0zuQVePhe?=
 =?us-ascii?Q?6v3Tlx68YEYB3a/MWxVF6A5bAWjuT90D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BgMOr/jSY7AA7KWPJRsWsOF7YWNLeRPTqqBsuFT9UdkZ73xnDEvUHsX3OXaB?=
 =?us-ascii?Q?fyD/H5TpUZB86xGs3jrhooM/dxmaC4gldqgH47uu0JkaWSWd3nYLuBxaUnpf?=
 =?us-ascii?Q?oxlDP385qagE9NggHoiRYXDiLdQIB9vws/J86My75MdTi3FuqXHHeS2E/2vU?=
 =?us-ascii?Q?2lG2B5xh1pS1iv33OJVCSlMgYTMSsTppMhZuBmFRc8mtY92/zhkeDJeeOGfD?=
 =?us-ascii?Q?f/Ip4sSNMTrQmEjGtr994vaBbXavS8QN/GF07q7neK8s/YC20iudDbTuN/8w?=
 =?us-ascii?Q?pAXs55ZlVd+JnTZtbO1ZczEbb9q8NhcRQ0yLhUKX4LP06VRxxpt5cGNjrZyO?=
 =?us-ascii?Q?9fQOgxEPZWv2RZyjSqFb1nQDT/fCFBkiy4pT3NUw3Usbp7buTqmDU7xiDDU6?=
 =?us-ascii?Q?dAzsb2Sm63Q19sIIVshPDmly0VXfzs/d0jCPe+0xt6nTlAmvt/xLN0IelJQr?=
 =?us-ascii?Q?ZQd9URamj033Lhfjv6RcbCnWkaRGdj/VPOnkO8Q9TUP0yLnnzsUjttQkaiqA?=
 =?us-ascii?Q?s1QV6U9HrGpf7C49zP07Y9n3exTxcTXWIJm5OP3kNkAUyaHrHS48EdTDWwGB?=
 =?us-ascii?Q?FDWJfr0wYZF+wjjq8r0paRbB7vR671BoK/EvGDDpaJrsywXwktFoRtipUKIq?=
 =?us-ascii?Q?OcQnQZ9/qvaa8eScirkcrsOAMl2Tml125ye1jbD1fI9tFxb4ChMLWQhzFsoj?=
 =?us-ascii?Q?wibUeqPsAQyN5yO5j6XkB4uEHFA2soCp52e3wXv8fp6rEY7MVLBiCq8pJC9r?=
 =?us-ascii?Q?K8yxTbcTtuIcf5MJSnp0MUYGo7YILB7jTOOBHZ1nXHocLyoLXIMO3amGhXH5?=
 =?us-ascii?Q?1bSaxb72pKuXrw8lhxfdcLHrhL3sS7UXaOH1V9x8eCsBXpETUIoKoNjH7m3Y?=
 =?us-ascii?Q?d/NcYz/lbOKPCN6LxyZDLBQg1wbYw8xIy9QM2KFbOC66mb1qeG7VI7rgC4m0?=
 =?us-ascii?Q?hCdIIIoJiA23jUUW7z36Cy/lT7f22KOEu8GQeRVmdvFEb5RRClLq3VNFk7KD?=
 =?us-ascii?Q?CinHfIHmTu20pC19WegYo50oADEdRR+uS/cTKzfbTzv6s01zCm/y5InBbUrg?=
 =?us-ascii?Q?oJYk3yoeaZtRYAmTeUHAzBKkU39ZBoXyV+FpaIj1307uw6zGTpUwiTgEmRsB?=
 =?us-ascii?Q?MJonexD89CtzNM1MIGn4miGjf7w4QjF9MOitIzEzdEmUNep05JUhj+RecWuO?=
 =?us-ascii?Q?W7DzSvP+VdJR+vSw/H7s0drbj2+fQ4xDsXp8qBZjnhJH9X86E5PvzAjEa3M8?=
 =?us-ascii?Q?UnFVP3kgiv1X8+5ODETDNNmIAP136J3Ew0l7f+TdYanlKDnSSKieOE8wjhMs?=
 =?us-ascii?Q?YA7gAn5td8zE/KlJyQxa6Y11SwwmbDJsZPlqH66F1ikWqqPUMZ+Ds0aTf1h2?=
 =?us-ascii?Q?oXYvovIVXZ3OA8UuNI9TvQsoz5oV/F0Vq7+SfsxtPROaP+6HEvEenba+Y8tn?=
 =?us-ascii?Q?DMU626vESuOAhAUDmzIlVfUmZAo3iGBkNvTeJctjnspgwzkoDllrFRs2ytFV?=
 =?us-ascii?Q?PFrAh4h/qm7xktf8RXe3329kOoJQF9ljMcBY9U0odsdYXDUH42UQgLaN3O0O?=
 =?us-ascii?Q?2aYmHlRaq6yQI+2GgZbYP1XmRxSD4yTrrTOsktum?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fab6597-3539-423e-7f00-08de12612885
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 18:22:43.8080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bAFbbjZqfiUMZ9qSmUDbJ3/eM5PeUY5abVzKSd/qCNL+R51JCgWxMXySdymDFr9/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6164

Some IOMMU HW cannot snoop the CPU cache when it walks the IO page tables.
The CPU is required to flush the cache to make changes visible to the HW.

Provide some helpers from iommu-pages to manage this. The helpers combine
both the ARM and x86 (used in Intel VT-d) versions of the cache flushing
under a single API.

The ARM version uses the DMA API to access the cache flush on the
assumption that the iommu is using a direct mapping and is already marked
incoherent. The helpers will do the DMA API calls to set things up and
keep track of DMA mapped folios using a bit in the ioptdesc so that
unmapping on error paths is cleaner.

The Intel version just calls the arch cache flush call directly and has no
need to cleanup prior to destruction.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-pages.c | 134 ++++++++++++++++++++++++++++++++++++
 drivers/iommu/iommu-pages.h |  51 +++++++++++++-
 2 files changed, 183 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
index 238c09e5166b4d..0f2d8267abc4a4 100644
--- a/drivers/iommu/iommu-pages.c
+++ b/drivers/iommu/iommu-pages.c
@@ -4,6 +4,7 @@
  * Pasha Tatashin <pasha.tatashin@soleen.com>
  */
 #include "iommu-pages.h"
+#include <linux/dma-mapping.h>
 #include <linux/gfp.h>
 #include <linux/mm.h>
 
@@ -22,6 +23,11 @@ IOPTDESC_MATCH(memcg_data, memcg_data);
 #undef IOPTDESC_MATCH
 static_assert(sizeof(struct ioptdesc) <= sizeof(struct page));
 
+static inline size_t ioptdesc_mem_size(struct ioptdesc *desc)
+{
+	return 1UL << (folio_order(ioptdesc_folio(desc)) + PAGE_SHIFT);
+}
+
 /**
  * iommu_alloc_pages_node_sz - Allocate a zeroed page of a given size from
  *                             specific NUMA node
@@ -36,6 +42,7 @@ static_assert(sizeof(struct ioptdesc) <= sizeof(struct page));
  */
 void *iommu_alloc_pages_node_sz(int nid, gfp_t gfp, size_t size)
 {
+	struct ioptdesc *iopt;
 	unsigned long pgcnt;
 	struct folio *folio;
 	unsigned int order;
@@ -60,6 +67,9 @@ void *iommu_alloc_pages_node_sz(int nid, gfp_t gfp, size_t size)
 	if (unlikely(!folio))
 		return NULL;
 
+	iopt = folio_ioptdesc(folio);
+	iopt->incoherent = false;
+
 	/*
 	 * All page allocations that should be reported to as "iommu-pagetables"
 	 * to userspace must use one of the functions below. This includes
@@ -82,6 +92,9 @@ static void __iommu_free_desc(struct ioptdesc *iopt)
 	struct folio *folio = ioptdesc_folio(iopt);
 	const unsigned long pgcnt = 1UL << folio_order(folio);
 
+	if (IOMMU_PAGES_USE_DMA_API)
+		WARN_ON_ONCE(iopt->incoherent);
+
 	mod_node_page_state(folio_pgdat(folio), NR_IOMMU_PAGES, -pgcnt);
 	lruvec_stat_mod_folio(folio, NR_SECONDARY_PAGETABLE, -pgcnt);
 	folio_put(folio);
@@ -117,3 +130,124 @@ void iommu_put_pages_list(struct iommu_pages_list *list)
 		__iommu_free_desc(iopt);
 }
 EXPORT_SYMBOL_GPL(iommu_put_pages_list);
+
+/**
+ * iommu_pages_start_incoherent - Setup the page for cache incoherent operation
+ * @virt: The page to setup
+ * @dma_dev: The iommu device
+ *
+ * For incoherent memory this will use the DMA API to manage the cache flushing
+ * on some arches. This is a lot of complexity compared to just calling
+ * arch_sync_dma_for_device(), but it is what the existing ARM iommu drivers
+ * have been doing. The DMA API requires keeping track of the DMA map and
+ * freeing it when required. This keeps track of the dma map inside the ioptdesc
+ * so that error paths are simple for the caller.
+ */
+int iommu_pages_start_incoherent(void *virt, struct device *dma_dev)
+{
+	struct ioptdesc *iopt = virt_to_ioptdesc(virt);
+	dma_addr_t dma;
+
+	if (WARN_ON(iopt->incoherent))
+		return -EINVAL;
+
+	if (!IOMMU_PAGES_USE_DMA_API) {
+		iommu_pages_flush_incoherent(dma_dev, virt, 0,
+					     ioptdesc_mem_size(iopt));
+	} else {
+		dma = dma_map_single(dma_dev, virt, ioptdesc_mem_size(iopt),
+				     DMA_TO_DEVICE);
+		if (dma_mapping_error(dma_dev, dma))
+			return -EINVAL;
+
+		/*
+		 * The DMA API is not allowed to do anything other than DMA
+		 * direct. It would be nice to also check
+		 * dev_is_dma_coherent(dma_dev));
+		 */
+		if (WARN_ON(dma != virt_to_phys(virt))) {
+			dma_unmap_single(dma_dev, dma, ioptdesc_mem_size(iopt),
+					 DMA_TO_DEVICE);
+			return -EOPNOTSUPP;
+		}
+	}
+
+	iopt->incoherent = 1;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iommu_pages_start_incoherent);
+
+/**
+ * iommu_pages_start_incoherent_list - Make a list of pages incoherent
+ * @list: The list of pages to setup
+ * @dma_dev: The iommu device
+ *
+ * Perform iommu_pages_start_incoherent() across all of list.
+ *
+ * If this fails the caller must call iommu_pages_stop_incoherent_list().
+ */
+int iommu_pages_start_incoherent_list(struct iommu_pages_list *list,
+				      struct device *dma_dev)
+{
+	struct ioptdesc *cur;
+	int ret;
+
+	list_for_each_entry(cur, &list->pages, iopt_freelist_elm) {
+		if (WARN_ON(cur->incoherent))
+			continue;
+
+		ret = iommu_pages_start_incoherent(
+			folio_address(ioptdesc_folio(cur)), dma_dev);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iommu_pages_start_incoherent_list);
+
+/**
+ * iommu_pages_stop_incoherent_list - Undo incoherence across a list
+ * @list: The list of pages to release
+ * @dma_dev: The iommu device
+ *
+ * Revert iommu_pages_start_incoherent() across all of the list. Pages that did
+ * not call or succeed iommu_pages_start_incoherent() will be ignored.
+ */
+#if IOMMU_PAGES_USE_DMA_API
+void iommu_pages_stop_incoherent_list(struct iommu_pages_list *list,
+				      struct device *dma_dev)
+{
+	struct ioptdesc *cur;
+
+	list_for_each_entry(cur, &list->pages, iopt_freelist_elm) {
+		struct folio *folio = ioptdesc_folio(cur);
+
+		if (!cur->incoherent)
+			continue;
+		dma_unmap_single(dma_dev, virt_to_phys(folio_address(folio)),
+				 ioptdesc_mem_size(cur), DMA_TO_DEVICE);
+		cur->incoherent = 0;
+	}
+}
+EXPORT_SYMBOL_GPL(iommu_pages_stop_incoherent_list);
+
+/**
+ * iommu_pages_free_incoherent - Free an incoherent page
+ * @virt: virtual address of the page to be freed.
+ * @dma_dev: The iommu device
+ *
+ * If the page is incoherent it made coherent again then freed.
+ */
+void iommu_pages_free_incoherent(void *virt, struct device *dma_dev)
+{
+	struct ioptdesc *iopt = virt_to_ioptdesc(virt);
+
+	if (iopt->incoherent) {
+		dma_unmap_single(dma_dev, virt_to_phys(virt),
+				 ioptdesc_mem_size(iopt), DMA_TO_DEVICE);
+		iopt->incoherent = 0;
+	}
+	__iommu_free_desc(iopt);
+}
+EXPORT_SYMBOL_GPL(iommu_pages_free_incoherent);
+#endif
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index b3af2813ed0ced..ae9da4f571f614 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -21,7 +21,10 @@ struct ioptdesc {
 
 	struct list_head iopt_freelist_elm;
 	unsigned long __page_mapping;
-	pgoff_t __index;
+	union {
+		u8 incoherent;
+		pgoff_t __index;
+	};
 	void *_private;
 
 	unsigned int __page_type;
@@ -98,4 +101,48 @@ static inline void *iommu_alloc_pages_sz(gfp_t gfp, size_t size)
 	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp, size);
 }
 
-#endif	/* __IOMMU_PAGES_H */
+int iommu_pages_start_incoherent(void *virt, struct device *dma_dev);
+int iommu_pages_start_incoherent_list(struct iommu_pages_list *list,
+				      struct device *dma_dev);
+
+#ifdef CONFIG_X86
+#define IOMMU_PAGES_USE_DMA_API 0
+#include <linux/cacheflush.h>
+
+static inline void iommu_pages_flush_incoherent(struct device *dma_dev,
+						void *virt, size_t offset,
+						size_t len)
+{
+	clflush_cache_range(virt + offset, len);
+}
+static inline void
+iommu_pages_stop_incoherent_list(struct iommu_pages_list *list,
+				 struct device *dma_dev)
+{
+	/*
+	 * For performance leave the incoherent flag alone which turns this into
+	 * a NOP. For X86 the rest of the stop/free flow ignores the flag.
+	 */
+}
+static inline void iommu_pages_free_incoherent(void *virt,
+					       struct device *dma_dev)
+{
+	iommu_free_pages(virt);
+}
+#else
+#define IOMMU_PAGES_USE_DMA_API 1
+#include <linux/dma-mapping.h>
+
+static inline void iommu_pages_flush_incoherent(struct device *dma_dev,
+						void *virt, size_t offset,
+						size_t len)
+{
+	dma_sync_single_for_device(dma_dev, (uintptr_t)virt + offset, len,
+				   DMA_TO_DEVICE);
+}
+void iommu_pages_stop_incoherent_list(struct iommu_pages_list *list,
+				      struct device *dma_dev);
+void iommu_pages_free_incoherent(void *virt, struct device *dma_dev);
+#endif
+
+#endif /* __IOMMU_PAGES_H */
-- 
2.43.0


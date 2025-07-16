Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2A929E0F2;
	Wed, 16 Jul 2025 19:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752695876; cv=fail; b=C1kBTqGUP6gy3u/xTQNoa/MKyhKVDah13mPHoXFPCzcxmV6uERip2BMPTPOr9Qgl0xF89I6JlzqNoDIUhEyV707y6V+k62Jldpnfi4ZlM0VJ6dV1XWeDV+o62MRK7nyjnsoiPIRhfR6c6vAJvmGqo39dbzuO18ikbeHqeRngtk8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752695876; c=relaxed/simple;
	bh=azEi7FMkRs4ciqNdN92jGB9MOMLGlfFz7nwwiNkCARM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QQV6Ht0Jmi0T9E13TAenrbMe+Zz1RC4RUrKEcN3nfjWgYgY/0F144u2Jbkqn2Ax8FbmDE8fI1aiwulWsJ/7lN4+7ZOr65oFvVjjsrf+C4rsBKpYd0pm21LGO0adxusWslKPzmlgSJR6vpnMKZ9t7RDWT6abnummDFukPvJWy1sE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DQWEvwXE; arc=fail smtp.client-ip=40.107.237.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DQWEvwXE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q0V/80+wr0tOUD78pt4KIg5u++PSbc47hB1lf5nMCTrjR1y1PRXzx4Wmb90mi4mv3fo/7wpi+VUqrfAawMr8OMYoWsTvc6PQuxyHHt7k/aDMOhVRzKpU4hRW2IVEk1bYme3oANAkwfsjgieUbYiIrg261SOmEUVj3D+qOzRafNTFnAFBb6J//pA5PjT/TYn90IOCfNNqIxoUE9foYKxRLJAzrLyEJKUeT2pE7FCjByInKdAZ0Z8jnAs6pAz4YfkBJWJV81PZRuopOTaTrbZBu61Gs+11VbG710HSF8ft7eJ1r7qADKS8o5pg8Cmwz0QD1YGsWqeS4IOE4bH+YEeZLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NnvjNyOyiHucVQVAPGmoKKyz1zvEcRGwXOzJgPTJh+Y=;
 b=ir+ezdiBr+apHEIyTyh/FL+V4qnqY5IdbBSp0THaf/2/kDnI4Y9jwe86VxITgNG1J/Nw0NEh9BJUOq566HJe9sdeJBketuLGRS1kGCpv5tqmI81p/928tLJQNO14D40ITIjUBnWLmrVer/lTdc4xJo9ggVFBRy4N1UQrlcA3cDlHgO8cl3HQyagm9BgXQKL+5oMJ54VdUBwpOSVeF0MTCVNV0UZJjpNDpUWRHO7JRR1ipfPHaTEKj94kaAyBfcz1W7yEm7R3fwsRPrQYm+rv0CZ4pQxa3AClM2pDCPB4t1b+vrLpLShvZ3wEDTiE4SA5/WdBlhL/HaONwFLHVtYVNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NnvjNyOyiHucVQVAPGmoKKyz1zvEcRGwXOzJgPTJh+Y=;
 b=DQWEvwXElzDD4kboz/NQF2qvzOwWkMcjmt69vayJPDqkf6IJrJn8T1kIXji4etsmYjHV4UshJfAOLUFnd+dg1C8iFp9OXlUsz6qQlO7qf5JFPFJ0NP2GJUMEUJoyEfNCW7UxmKEtDC09a+QKiz/4XxdBrQTfb7dv44wLeuZmgAxx6cS3sSykRkzZ0fuoYNTD6uJS9P5e9Q+ZbF0lFkyF1b29+HMKfWeIeamBGRY9oPDKRahJahFtGXEkPl4fuR3ZVdKU06Nau3iOZaWzsHw8im9AKcu+FVYKBfHc91IRCpknZ55jLNp/mIlXNZb6e9xW9cHeSiD4n/gie+e52cndeA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6105.namprd12.prod.outlook.com (2603:10b6:930:2a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.33; Wed, 16 Jul
 2025 19:57:49 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Wed, 16 Jul 2025
 19:57:47 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH 1/9] iommu/pages: Add support for a incoherent IOMMU page walker
Date: Wed, 16 Jul 2025 16:57:37 -0300
Message-ID: <1-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0291.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::26) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6105:EE_
X-MS-Office365-Filtering-Correlation-Id: 18e9b3b3-88d5-41cd-b486-08ddc4a3096c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rRPWrzd3HoKCL9lCTQSSwPELnesdGu5NUltRcdn/bNVdzaL6jySYAjMKpIFg?=
 =?us-ascii?Q?c68MIxxbpSdTewkSWk1ERkpBQfDMlvqWgg7s4o4cCNpsl+EUgRrwdh9gC/Qx?=
 =?us-ascii?Q?HzYwmyj8bxuRhRPSbHNV1EIsyF7ZNv7GFRwwc3rfL5uAPqhztXlRiNV5xS9g?=
 =?us-ascii?Q?yfkJ7sXQjYXsmDeuEjeQKCr7yqpbnU+Mw/NzBZNGs0ARUjYTGB38L8ATrX0T?=
 =?us-ascii?Q?6/FcCQeYzAXswS63BbrM3qPNqkq2GDb1OrzhRcLdnN/6Q0Z7Hero5d2L1pXP?=
 =?us-ascii?Q?39UXe4Num/6928EyzsbqdEEG3HVPYOTLDgEFfmqmHYP5Vka7mOCr2T5BX61V?=
 =?us-ascii?Q?2p3kQ7PtQJz0QBVqVJI3zqqXZTuNmoH6/Rwr/tCQUCGy2qI88ruBvcUiTHZd?=
 =?us-ascii?Q?5Xsia7M/ZtogmaEVsIQujC/LtMD084U56r9I4aEcSxP4x+v2g8ROskH1SxuL?=
 =?us-ascii?Q?C0/RsvB6wuZgWHsrCmk6iCdyAinhWAMoP73TE5DN/T3hQiTs4M/d3BAxW5Ef?=
 =?us-ascii?Q?5cUdd0YXVErGYZssu0NFBHAj9OhVQGSz1knsArCMA08wC91bAsbpQiKkrdvm?=
 =?us-ascii?Q?jnvadDIN7b5KF8b4mXh8yEQ4eJNzAu3yRxn9gcV3wzOA8TWvz3Vr6mLGzaKD?=
 =?us-ascii?Q?7c81nJhq/nRMUe1B8Nj27JEXUzMAxkyeRHY2gFv+m7eCxH9R0An37fBAlXLS?=
 =?us-ascii?Q?jALEg2EtLN3VnSQFqSwoKgFHx5jGg+5fd/QW309ABwVGluwNi0+ScGbxZ4T8?=
 =?us-ascii?Q?+55iCRmooAIIFEafEWhWh5Yh6eg1d7X5hxK60C8M/YjK1+hhFo+84MoSnma2?=
 =?us-ascii?Q?UYMlTUppED6edXiEtNKps8qbrmyaOrxrVp384CXYrNIZfmCenDZCppNhbQZT?=
 =?us-ascii?Q?ThRPk3+ovHob2y/nWywU4iTrvIr5lDOzGbBjMDmZDOEYBjXSRvM2kmGT/e8v?=
 =?us-ascii?Q?P2m2VgUD0eOryt6spTcN7V3V02mopuVtU2OZKKQG8oZJYKFpYIEojeDmxDCP?=
 =?us-ascii?Q?/h+ovQFLlhJHlgMz/nlo0oqTJeqSjrh6V61k3tOVrcLIr3qhs+lsMYZ1ZJAv?=
 =?us-ascii?Q?fg00ep/TeGk37SdyWan2KXiA4LbAJ6Rb/6XIarZGT++swF2cH45JEVOWOmQx?=
 =?us-ascii?Q?e331J4vhTz1vWafsrCTgUcXGCzQWWJBgN1Ap7NSUYy5lZTdr1aCHB0+53ydx?=
 =?us-ascii?Q?mdGq7i2nVYhjNC2GhxufUaPgeNN6C9bY8Pdildgv1H148BrCBQIfk43cc4Zo?=
 =?us-ascii?Q?WzOFzCs6og5bncgpkLS2hHOtFYVX7oPOKSihKR/0JuecztKFQMJVr7nI5CFI?=
 =?us-ascii?Q?dzPjG9qPMLEFAaI/cpdCR72SkmTEkHZKjdSSQvCDeX4lltsQHzdvi1QwSHyh?=
 =?us-ascii?Q?I8C1aLQ/LooWzSRlsaUAPL4NFCmztVgyHn//ZprMuN3XeSyR8d83/tpx7IPo?=
 =?us-ascii?Q?t87xcEau3Rk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2aibbjEbJjX2CjyelrasPUpeLYYcvSPBFgY6zbMdKc7Lc5Du305QCIH4faNa?=
 =?us-ascii?Q?FeMC3Y8WRrMMp291bnv5i1YJkYDP4xGSB4S2W08oh7HnRL8j+uRmfwcJaMeF?=
 =?us-ascii?Q?YB1gJDc04/AoTGVHgohe45TvVA1yML2kUkeFEF/te9CUcwVL6/5+NKr+Rzh6?=
 =?us-ascii?Q?pSbMQDJQ5X/0XJN72rY1zgDsSn2tDd07qpV1F05j+W7wOVtpDrXlKZx77Y3h?=
 =?us-ascii?Q?VWqyEgibs9DrZjq7Gx8ySxyVIn4TorCKwZkrgpkzIKGniniuUFW8cn7ujyd9?=
 =?us-ascii?Q?3WMCaRxg5TBji5EiB3uOV/CKNZPo5BkX+cd43OEMSq8c/EfBlvUYEHYaoQm8?=
 =?us-ascii?Q?qTcNoda6WhGY926ZUIB2sv6S9ADkm/7HanY9qXG3duCNw4UNw9TzP6eQ5ytZ?=
 =?us-ascii?Q?7CUx5HZA4CrlekuNj5TXqjGGIiMRXeA9IBqww+Oghb9yKFSqp8ICvL0NXy/7?=
 =?us-ascii?Q?g9tx0Yg/It+ExDhCrWoQjEgiv6dCw/hs7dJX4JOHqgO17MvJHl1/R6ombKcI?=
 =?us-ascii?Q?H0Qz41FarZiVOu1f5C/HTeYjSek1wNeQashzTyYyyr4ipX5NrbOaw8hQTTPe?=
 =?us-ascii?Q?rXSLjdJvqjIdQAAjU+I5NR994Ylz0qUNvz15M4EqvI9+FxfeYnX6urKqvv8h?=
 =?us-ascii?Q?BJgBaqotEZNKfVIAp70V4IaDCRkQErfsJGsxOJsi6nxlgJZsG3FAusJ5Xeyz?=
 =?us-ascii?Q?O3lr8ezKnaCd6VbBCxg83HHhsvhtVo+TFfaH+yUxIV7+CsJTCgYKHfgEXt3B?=
 =?us-ascii?Q?YCA/YF6enqQzshoZT2LvPKR9DJZhg1SwLJy1aXWzyBDCIxdaqnf8zgAer1Mz?=
 =?us-ascii?Q?tTWwOaatvFbg0erfCoQrKAJkW9yXrfNbcEmE/Q+hjEg0tekWENAXaW9sFSwi?=
 =?us-ascii?Q?rtE4MEiDRzZAYfWIovqh5gCQoJdpme+OXSCGEy8IoLEDQyWlb1hmTNSBcXkt?=
 =?us-ascii?Q?g4uuvLTibyswbo+Phe70Upizuw+ZcMGrckL2CKB92EQRttcMn0zxos9TYsQv?=
 =?us-ascii?Q?UecrGJ1N2I8Y3bOp2aR3y7Aob8ac7ZlJm1eJQQ88SNLX8ODHx9oW7EyDV3jW?=
 =?us-ascii?Q?T+eKn9OnzfPKn9CdlyaIOrKPtBk6AG4KU1ogbb2yXW/c8+1a09a0XqrXETPf?=
 =?us-ascii?Q?QPAIJMbwPSeBiruAVXFnDMa01cBmu7A1HxH7afT6e+4COC+yR13VzQeUQYt2?=
 =?us-ascii?Q?jZzdQRp7ipZDCpqbJBfgqcykYMAr53B6wy6RgpkutKlFP9PEac8WcThqY9Wg?=
 =?us-ascii?Q?DRHPg5b5NYzdk+IItaCJSiyd6p8drEJK4cuPP/rbpo7g6cHvqm2wgNUn061p?=
 =?us-ascii?Q?gEObGwcD83l9odgZGQiBP0YAQHu/OqNaMhoP9kBKMjD/2x74FKpRD4IRsXJ0?=
 =?us-ascii?Q?EpKcxIfo7jD5KrPdE0weSJoQnJ1BBNFjK6+C6nEJaotwgeLStCFJzrJLCPqy?=
 =?us-ascii?Q?UoX1v+F3L3EaUyFBDoNn4tO+DWDFk+uUvZYtOnDYF0UjG9w/E0U0S91I8is7?=
 =?us-ascii?Q?F9zxhWYutezUVNFDYnOf6oBQQWeJyw4PDerNIetiNTlsp8eF11OSe2jrVCMU?=
 =?us-ascii?Q?CHkI1p+vvWctk3PPAL0H2MWB+QCisQnMia5KR2dn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e9b3b3-88d5-41cd-b486-08ddc4a3096c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 19:57:47.5870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9jsy6LdFeoo3ce3T6a0Ug/cuf7Q4q3NKEc3rYSqC0T3XFwO4QnNp0vDLjyAF/681
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6105

Some IOMMU HW cannot snoop the CPU cache when it walks the IO page tables.
The CPU is required to flush the cache to make changes visible to the HW.

Provide some helpers from iommu-pages to manage this. The helpers combine
both the ARM and x86 (used in Intel VT-D) versions of the cache flushing
under a single API.

The ARM version uses the DMA API to access the cache flush on the
assumption that the iommu is using a direct mapping and is already marked
incoherent. The helpers will do the DMA API calls to set things up and
keep track of DMA mapped folios using a bit in the ioptdesc so that
unmapping on error paths is cleaner.

The Intel version just calls the arch cache flush call directly and has no
need to cleanup prior to destruction.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-pages.c | 116 ++++++++++++++++++++++++++++++++++++
 drivers/iommu/iommu-pages.h |  39 +++++++++++-
 2 files changed, 153 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
index 238c09e5166b4d..dbce64c1b73871 100644
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
 
+	if (!IS_ENABLED(CONFIG_X86))
+		WARN_ON_ONCE(iopt->incoherent);
+
 	mod_node_page_state(folio_pgdat(folio), NR_IOMMU_PAGES, -pgcnt);
 	lruvec_stat_mod_folio(folio, NR_SECONDARY_PAGETABLE, -pgcnt);
 	folio_put(folio);
@@ -117,3 +130,106 @@ void iommu_put_pages_list(struct iommu_pages_list *list)
 		__iommu_free_desc(iopt);
 }
 EXPORT_SYMBOL_GPL(iommu_put_pages_list);
+
+/**
+ * iommu_pages_start_incoherent - Setup the page for cache incoherent operation
+ * @virt: The page to setup
+ * @dma_dev: The iommu device
+ *
+ * For incoherent memory we use the DMA API to manage the cache flushing. This
+ * is a lot of complexity compared to just calling arch_sync_dma_for_device(),
+ * but it is what the existing ARM iommu drivers have been doing. This keeps
+ * track of the dma map inside the ioptdesc so that error paths are simple for
+ * the caller.
+ */
+int iommu_pages_start_incoherent(void *virt, struct device *dma_dev)
+{
+	struct ioptdesc *iopt = virt_to_ioptdesc(virt);
+	dma_addr_t dma;
+
+	if (WARN_ON(iopt->incoherent))
+		return -EINVAL;
+
+	if (IS_ENABLED(CONFIG_X86)) {
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
+ * iommu_pages_start_incoherent_list
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
+		if (cur->incoherent)
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
+ * iommu_pages_stop_incoherent_list
+ * @list: The list of pages to release
+ * @dma_dev: The iommu device
+ *
+ * Revert iommu_pages_start_incoherent() across all of the list. Pages that did
+ * not call or succeed iommu_pages_start_incoherent() will be ignored.
+ */
+#ifndef CONFIG_X86
+void iommu_pages_stop_incoherent_list(struct iommu_pages_list *list,
+				      struct device *dma_dev)
+{
+	struct ioptdesc *cur;
+
+	if (IS_ENABLED(CONFIG_X86))
+		return;
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
+#endif
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index b3af2813ed0ced..e0afdc0fba4bc5 100644
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
@@ -98,4 +101,36 @@ static inline void *iommu_alloc_pages_sz(gfp_t gfp, size_t size)
 	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp, size);
 }
 
-#endif	/* __IOMMU_PAGES_H */
+int iommu_pages_start_incoherent(void *virt, struct device *dma_dev);
+int iommu_pages_start_incoherent_list(struct iommu_pages_list *list,
+                                      struct device *dma_dev);
+
+#ifdef CONFIG_X86
+#include <asm/cacheflush.h>
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
+}
+#else
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
+                                      struct device *dma_dev);
+#endif
+
+#endif /* __IOMMU_PAGES_H */
-- 
2.43.0


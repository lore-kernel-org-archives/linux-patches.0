Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011050.outbound.protection.outlook.com [40.93.194.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D0336A017;
	Fri, 27 Feb 2026 19:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772220623; cv=fail; b=BTbVdwNvHSnu9OCJissC1qij59xaX27wxYoO26Hbpvqa4op74s38JnLNfAE2LiSrURuYE78ZoW8vSd++KDPL6tVhKeIvCoM0V7y8+jFu0lNz5SbXiFyO/aViAHd2Ou06IXJ3lX54f9JK3fn3saSRI+6hS97ZS03aUWvvr2L9N74=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772220623; c=relaxed/simple;
	bh=ggzxyj3uv3HYeiovhH51SI+JIyx7vl4whEdHK8wbhuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=MGJJdTE4BQo1Il5F7DE9VN9WMxTJqV2xmApyU+LGsG29w1h2gI/D6B9VZBbP/UVpyrYRj3LbMcamaxthBE4oz38B5l64/NU2VzG7Prb/XEBWWrdGyV65WdgXbPodKmRMGBOUcyhUWGwjCb13VqtVpN1aDwDcbKawXGjzZsNAXaQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OU7vUOPH; arc=fail smtp.client-ip=40.93.194.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OU7vUOPH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ishMngvV5KVbBgO25svOPUDt2rfBNdRjKzna17+LlbsDpTw2zumABBeB+IEGyudUrPU7Lwb5+w3rs1lVrzUfrQ5SV8J2mOaMki0x47YzjWqwv1IuzrKAfnOwsW9RR3/Q3f2+ZE5aY7uw9URfdM2El/5T5+UmvLlDgqnBD366/RMhpN2qszQC/KcIl1kAE6LspzWJijO51hZZDNh0D2/kERKggsZliEmq2CgBBub1odsXu+OZQw2Xj4z3vaXyC/1+NzNZjzFPdz4KZqZIeHRZyevBCN6D+3qwrOGelxfL7RT7bi8SPo3Yv/pv55g/xxDcj/ebOVWK90ufe3gRcIE2uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cep9wpFjjjENZYo9frNOu9rE5mF4TEZOjOEPiobVHdU=;
 b=bo55Nw6wNdm5YPPdKmkT4pSgM7Zo7e/UWSv2jtNpnj2WsDdTszb4utyPsKqGEIJZOSUUTemQz33hOUF/pZCya4czi6ALT5dhLRQ8NQgCZSEWCTf0rRk0I1kqJCLuh2Ry8TSKsP/mspZv9E8N0qseIMGGjehC41IFy24g1GNnNk0LwbxWFbxfzaaIm5e3nhJws6ItTEgMiOD3lJHLRHgcTzSbpJ0Y9aSxJhMyd4ksDoqmNvh3rI3uR/m4QnNy3ThAsgrATD01tULA8LiB1uMEVn6oP38JkFb3fJMzU+7TaxIAmM4d/VhBNs2LIIDG40GS+7k15sFfYnikcANsh3xBMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cep9wpFjjjENZYo9frNOu9rE5mF4TEZOjOEPiobVHdU=;
 b=OU7vUOPH9ZV1o6TsP03AJcfGEQVuNHkaRBNjBRoxr17O3YXIQ6zxlShOZq+2mVYjXJhSX/jfVqu6rLm1kkCE1VAQSMOOP4uwr4nmaEPsDvlH73ZX7mQ/Ew2iri8T+NkiWOVzAnSaTKCXakNTh9I9MBYsPtrXih8+DNg9W38ZHG2WJbQnAD1yMmbHJPZxcAyysLZ981ccW+LGyJiLU95eoCGkIBxapFakq6vz4tXnpuijuWVKz4NVrB6oxwD+NPs48JCJK98wzw/zz4UQQ1hNZqJKStbQlCY0iQlpyMB8xDNX61hPioYXH244stqQCTKSZaPGCBhPX1WyvsPyEB9fcA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS0PR12MB8319.namprd12.prod.outlook.com (2603:10b6:8:f7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Fri, 27 Feb
 2026 19:30:12 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 19:30:12 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>
Subject: [PATCH v3 1/2] iommupt: Directly call iommupt's unmap_range()
Date: Fri, 27 Feb 2026 15:30:10 -0400
Message-ID: <1-v3-a1777ea76519+370f-iommpt_map_direct_jgg@nvidia.com>
In-Reply-To: <0-v3-a1777ea76519+370f-iommpt_map_direct_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0026.namprd14.prod.outlook.com
 (2603:10b6:208:23e::31) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS0PR12MB8319:EE_
X-MS-Office365-Filtering-Correlation-Id: dcd3b2dc-67ff-41fc-d968-08de7636a000
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	WOiHr5lvNN4BBlasoDIS5uW+ijKCoeRPpxzqWOr1wjFQO/vQJaDh1EE4VVfNYc/HhgMzuzRTFpsCfwQKtgvHEikCtZSgVuWoCE+WwM/TgSmfpXL9Sf7nOoCNgq9aoJgyrM+A6YkOu2UByq0z9ERxAQqneEuSaI3HsZYNVVwtdZAm8CX3w1C8Zybc1EI0Jb9oWVJxfASZvq89gKU61YQpyJ3I/xR/kpPCkdr3PRyK+VqfhYk/PGZIAieJX0FUmcsYruPHuppPRJvHF4olyrJ+1VQSAI0hBjvEEWSnkvTqjOAaUins3lM4gji05/ZP3F+cYl4I8lgY3edFzbojtMIeuXHsq6bcEaGSGz7yhZs9f1SKcjyztISEAWpJMkvjxuFsIbq73YR+SjPBt5efPAonwow4LUm1ycQu4f5Zh+Cje9aZeynijbhMf7t6Nb+uF2Tz7Av8vVuyzv8RpjpDmOKKp++EjnALU54Tp5sn6mLY4WHewlh4gmKW8ogzGYNK1NLaczI+bGoaxhCISuSydrCCFAj+qzp6RhNuOVGpZWLltxpeOLS/RWJQFhIBhg6xh2CksJ2HUD0yayzOUNtVVoq4v2E6hrIPtUI7TnrvQXv3SN3nYjLqMTLbWor3436a0W4W7EqU3qSP8Xv6SQobXYTw4+QQ4+e42mW6MlnAKBkcMVsY3T1fVNqm8f28aX8cEGTGnE2SrfNIiWplWEbI14SHuU/r9BJBPB/hBpehWNxu2iY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AfO+Gkx2+KwmXLlZt1JDmMVmNnZzvQPWBS/PbMdanOah6MxY+AJgDegSEhxA?=
 =?us-ascii?Q?t1ryV65aZFfcfY7lyeZ89D68JzD8H4witnSJA4kKeh2K2QoJ7skLq2MKd6fu?=
 =?us-ascii?Q?sdpSBJrJItnCqxlVpWUCHOHFIjLe8K5DsW6p6aZbasg+y/KIgaoXExAahYE2?=
 =?us-ascii?Q?kQjWQazSXc4sXk1WFTvXEq+o/3SGSARIN4n7sUWn8mRp/Q3VuuIiZpqXYlWd?=
 =?us-ascii?Q?Osto7HD/wIYkbnCwlo+YSn/HH68ACZZUsdtP+A3HLtJL6fzUlLsElTWxtm69?=
 =?us-ascii?Q?FhgYOj2ImnW4RO7uGGsRgbF1VODDS+HBoSD3wwFd91iVYPjPiENluS77KZuP?=
 =?us-ascii?Q?fCsne8QoWDvhksyq7m9zPv3S/kmlNZezpuoilwZuNL0v/4zLFZIUfq56PhOj?=
 =?us-ascii?Q?o79chM8T49h/7NJbORALkuQjVnpQamLzmMayLo8HEPrVfR9H8GBKNCYXQyXy?=
 =?us-ascii?Q?ec0o7gkTB51dV4JpmXuG3CGYHgrThH6J4WcAEAOM7Pwg7lKJj8v1jXNuPz+b?=
 =?us-ascii?Q?lQDckzcZya+okPQtcZuMt/jy09bNnXz8LlvUSkPzWuWe9/yWlziozjLCSqyi?=
 =?us-ascii?Q?uq6vXwcOwzxr2K9K7wNj5L0e8ngHzxMt3gVqAvkcl1WuGAFJyHdylP54ruWL?=
 =?us-ascii?Q?ypMDlM7GE10eCJhVtGLaf1WAwoIn34QEXd/7JvpaaotdSjxyameu1xP+Lf4i?=
 =?us-ascii?Q?I5Ht/EX4Cp5s9scrLryc/QwC90uURuuVc1uUw7jHoKfGhijQgw3RdF8qjhxa?=
 =?us-ascii?Q?syKBhwZmCH9i6Y5K/6sXJ1A4lPah8fCZzSplu01nZkULWn9MZJUDOFZYsi8h?=
 =?us-ascii?Q?kCI4jlPalEUAnPQRr/ovT+c2EOgtkFKTKo2x9wAEsFyV9dWqfQbStWWoDQOM?=
 =?us-ascii?Q?16DyXA98GiIvaIPmiQsU0RWwEGgArfNMfnX0tpUnmWWzVlFCAx5x/Q0d9Zr/?=
 =?us-ascii?Q?5JqY6BPoAj4NuQn6ym6Why7iX4ycaocW5LMUarbNvGBTnfEp3OfH+GrxSIWk?=
 =?us-ascii?Q?1pmRApcQ8MfHFyGq27d7ip0j67ZLSmwQ7/PIskMiLf5bF0i9hw/ExMnVayso?=
 =?us-ascii?Q?4UwcxFvy760Y7YuE7S2cqsSQVW/3XOyLknFVSv8SiJTXWZl1ECJme3eWdjv3?=
 =?us-ascii?Q?GN1JXzvNY+YMxwOE/PsBm2ZC4Hgz2A9l+x6BKRtKzDfwX/wEU4sJRc9nMSYU?=
 =?us-ascii?Q?wEQuWJHlGdXFR6Z/wladHyq/oBQwRP1cTenUeXZY35kn2ZtRKxfhXPd4XWiD?=
 =?us-ascii?Q?bxWug/3ZGyHW5DNyWgKGjMl8AaWaTPpc64LvXX4uFNqCmo25xPJ+xGrx+QEe?=
 =?us-ascii?Q?T5PtozpJmkiABjniljZ2VRZZr5uCZLxsIgFLosw8NmV3KmMuCBUkaWjwMnf0?=
 =?us-ascii?Q?xVlWm6kAK5p0sW9hlco4+BDVXfaKmOPA8bTJD+JfYKpgGUJMnKCcxfko4YHS?=
 =?us-ascii?Q?Idmi/2x4mPZrN5jP5w13QdJG1qJT63msvkfqTZ/uo/mTAzVOQ7iDYAHrDj8z?=
 =?us-ascii?Q?WiePSua0CU0gKJD8498eR/028MgQL8Rkgx+6nHzjnXoLOtafVah8YgJOssn+?=
 =?us-ascii?Q?1mXHwTkggp5CanZEkZKheBgPWNrBttC9p0Vu8BhvLknP6LA/DJAS5ZGiquBn?=
 =?us-ascii?Q?9lnFy7Ta1O3U2ZL8Ww2/qJ6e/4kKlC4HL+srnUEBRxVmzcq9KWDDNoWx8tCX?=
 =?us-ascii?Q?yUpPGBCt3PHQ7jgK+q75dCjynCL9gkHvc7Avpglcq1pGvgsndSX2cbVi6MoM?=
 =?us-ascii?Q?CXtko86sqA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcd3b2dc-67ff-41fc-d968-08de7636a000
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 19:30:12.2740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jswcExgcI0yTcuDHcA/ZB3O/Lj+9UOTGFSvid3DxuNlxbWl8al1uFYoDIrlx/V1y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8319

The common algorithm in iommupt does not require the iommu_pgsize()
calculations, it can directly unmap any arbitrary range. Add a new function
pointer to directly call an iommupt unmap_range op and make
__iommu_unmap() call it directly.

Gives about a 5% gain on single page unmappings.

The function pointer is run through pt_iommu_ops instead of
iommu_domain_ops to discourage using it outside iommupt. All drivers with
their own page tables should continue to use the simplified
map/unmap_pages() style interfaces.

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 29 ++++------------------
 drivers/iommu/iommu.c               | 27 ++++++++++++++++-----
 include/linux/generic_pt/iommu.h    | 37 ++++++++++++++++++++++++-----
 include/linux/iommu.h               |  1 +
 4 files changed, 57 insertions(+), 37 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 3e33fe64feab22..62d6ae2a97ba63 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -1020,34 +1020,12 @@ static __maybe_unused int __unmap_range(struct pt_range *range, void *arg,
 	return ret;
 }
 
-/**
- * unmap_pages() - Make a range of IOVA empty/not present
- * @domain: Domain to manipulate
- * @iova: IO virtual address to start
- * @pgsize: Length of each page
- * @pgcount: Length of the range in pgsize units starting from @iova
- * @iotlb_gather: Gather struct that must be flushed on return
- *
- * unmap_pages() will remove a translation created by map_pages(). It cannot
- * subdivide a mapping created by map_pages(), so it should be called with IOVA
- * ranges that match those passed to map_pages(). The IOVA range can aggregate
- * contiguous map_pages() calls so long as no individual range is split.
- *
- * Context: The caller must hold a write range lock that includes
- * the whole range.
- *
- * Returns: Number of bytes of VA unmapped. iova + res will be the point
- * unmapping stopped.
- */
-size_t DOMAIN_NS(unmap_pages)(struct iommu_domain *domain, unsigned long iova,
-			      size_t pgsize, size_t pgcount,
+static size_t NS(unmap_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
+			      dma_addr_t len,
 			      struct iommu_iotlb_gather *iotlb_gather)
 {
-	struct pt_iommu *iommu_table =
-		container_of(domain, struct pt_iommu, domain);
 	struct pt_unmap_args unmap = { .free_list = IOMMU_PAGES_LIST_INIT(
 					       unmap.free_list) };
-	pt_vaddr_t len = pgsize * pgcount;
 	struct pt_range range;
 	int ret;
 
@@ -1062,7 +1040,6 @@ size_t DOMAIN_NS(unmap_pages)(struct iommu_domain *domain, unsigned long iova,
 
 	return unmap.unmapped;
 }
-EXPORT_SYMBOL_NS_GPL(DOMAIN_NS(unmap_pages), "GENERIC_PT_IOMMU");
 
 static void NS(get_info)(struct pt_iommu *iommu_table,
 			 struct pt_iommu_info *info)
@@ -1110,6 +1087,7 @@ static void NS(deinit)(struct pt_iommu *iommu_table)
 }
 
 static const struct pt_iommu_ops NS(ops) = {
+	.unmap_range = NS(unmap_range),
 #if IS_ENABLED(CONFIG_IOMMUFD_DRIVER) && defined(pt_entry_is_write_dirty) && \
 	IS_ENABLED(CONFIG_IOMMUFD_TEST) && defined(pt_entry_make_write_dirty)
 	.set_dirty = NS(set_dirty),
@@ -1172,6 +1150,7 @@ static int pt_iommu_init_domain(struct pt_iommu *iommu_table,
 
 	domain->type = __IOMMU_DOMAIN_PAGING;
 	domain->pgsize_bitmap = info.pgsize_bitmap;
+	domain->is_iommupt = true;
 
 	if (pt_feature(common, PT_FEAT_DYNAMIC_TOP))
 		range = _pt_top_range(common,
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 35db5178095404..f68269707101a3 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -34,6 +34,7 @@
 #include <linux/sched/mm.h>
 #include <linux/msi.h>
 #include <uapi/linux/iommufd.h>
+#include <linux/generic_pt/iommu.h>
 
 #include "dma-iommu.h"
 #include "iommu-priv.h"
@@ -2666,13 +2667,12 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 }
 EXPORT_SYMBOL_GPL(iommu_map);
 
-static size_t __iommu_unmap(struct iommu_domain *domain,
-			    unsigned long iova, size_t size,
-			    struct iommu_iotlb_gather *iotlb_gather)
+static size_t
+__iommu_unmap_domain_pgtbl(struct iommu_domain *domain, unsigned long iova,
+			   size_t size, struct iommu_iotlb_gather *iotlb_gather)
 {
 	const struct iommu_domain_ops *ops = domain->ops;
 	size_t unmapped_page, unmapped = 0;
-	unsigned long orig_iova = iova;
 	unsigned int min_pagesz;
 
 	if (unlikely(!(domain->type & __IOMMU_DOMAIN_PAGING)))
@@ -2718,8 +2718,23 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
 		unmapped += unmapped_page;
 	}
 
-	trace_unmap(orig_iova, size, unmapped);
-	iommu_debug_unmap_end(domain, orig_iova, size, unmapped);
+	return unmapped;
+}
+
+static size_t __iommu_unmap(struct iommu_domain *domain, unsigned long iova,
+			    size_t size,
+			    struct iommu_iotlb_gather *iotlb_gather)
+{
+	struct pt_iommu *pt = iommupt_from_domain(domain);
+	size_t unmapped;
+
+	if (pt)
+		unmapped = pt->ops->unmap_range(pt, iova, size, iotlb_gather);
+	else
+		unmapped = __iommu_unmap_domain_pgtbl(domain, iova, size,
+						      iotlb_gather);
+	trace_unmap(iova, size, unmapped);
+	iommu_debug_unmap_end(domain, iova, size, unmapped);
 	return unmapped;
 }
 
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index 9eefbb74efd087..f094f8f44e4e8a 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -66,6 +66,13 @@ struct pt_iommu {
 	struct device *iommu_device;
 };
 
+static inline struct pt_iommu *iommupt_from_domain(struct iommu_domain *domain)
+{
+	if (!IS_ENABLED(CONFIG_IOMMU_PT) || !domain->is_iommupt)
+		return NULL;
+	return container_of(domain, struct pt_iommu, domain);
+}
+
 /**
  * struct pt_iommu_info - Details about the IOMMU page table
  *
@@ -80,6 +87,29 @@ struct pt_iommu_info {
 };
 
 struct pt_iommu_ops {
+	/**
+	 * @unmap_range: Make a range of IOVA empty/not present
+	 * @iommu_table: Table to manipulate
+	 * @iova: IO virtual address to start
+	 * @len: Length of the range starting from @iova
+	 * @iotlb_gather: Gather struct that must be flushed on return
+	 *
+	 * unmap_range() will remove a translation created by map_range(). It
+	 * cannot subdivide a mapping created by map_range(), so it should be
+	 * called with IOVA ranges that match those passed to map_pages. The
+	 * IOVA range can aggregate contiguous map_range() calls so long as no
+	 * individual range is split.
+	 *
+	 * Context: The caller must hold a write range lock that includes
+	 * the whole range.
+	 *
+	 * Returns: Number of bytes of VA unmapped. iova + res will be the
+	 * point unmapping stopped.
+	 */
+	size_t (*unmap_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
+			      dma_addr_t len,
+			      struct iommu_iotlb_gather *iotlb_gather);
+
 	/**
 	 * @set_dirty: Make the iova write dirty
 	 * @iommu_table: Table to manipulate
@@ -198,10 +228,6 @@ struct pt_iommu_cfg {
 				       unsigned long iova, phys_addr_t paddr,  \
 				       size_t pgsize, size_t pgcount,          \
 				       int prot, gfp_t gfp, size_t *mapped);   \
-	size_t pt_iommu_##fmt##_unmap_pages(                                   \
-		struct iommu_domain *domain, unsigned long iova,               \
-		size_t pgsize, size_t pgcount,                                 \
-		struct iommu_iotlb_gather *iotlb_gather);                      \
 	int pt_iommu_##fmt##_read_and_clear_dirty(                             \
 		struct iommu_domain *domain, unsigned long iova, size_t size,  \
 		unsigned long flags, struct iommu_dirty_bitmap *dirty);        \
@@ -223,8 +249,7 @@ struct pt_iommu_cfg {
  */
 #define IOMMU_PT_DOMAIN_OPS(fmt)                        \
 	.iova_to_phys = &pt_iommu_##fmt##_iova_to_phys, \
-	.map_pages = &pt_iommu_##fmt##_map_pages,       \
-	.unmap_pages = &pt_iommu_##fmt##_unmap_pages
+	.map_pages = &pt_iommu_##fmt##_map_pages
 #define IOMMU_PT_DIRTY_OPS(fmt) \
 	.read_and_clear_dirty = &pt_iommu_##fmt##_read_and_clear_dirty
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 54b8b48c762e88..7ca648c0133634 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -223,6 +223,7 @@ enum iommu_domain_cookie_type {
 struct iommu_domain {
 	unsigned type;
 	enum iommu_domain_cookie_type cookie_type;
+	bool is_iommupt;
 	const struct iommu_domain_ops *ops;
 	const struct iommu_dirty_ops *dirty_ops;
 	const struct iommu_ops *owner; /* Whose domain_alloc we came from */
-- 
2.43.0


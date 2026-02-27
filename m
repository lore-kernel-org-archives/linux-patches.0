Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013019.outbound.protection.outlook.com [40.107.201.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC85341C316;
	Fri, 27 Feb 2026 15:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772205962; cv=fail; b=nVRu0kCoJNn7+GeuPgjU8FMLDh4dSwZgaSpv7qcCrMroRZ1qPzGRvwgVNF0SwFigMZTnFL074Jjpj3xSZaqYAs+dGXWhjEhzLbah/phexvEbAlwjDX7fVjIFdSD4NuWzODIsLedX9VzbKD2be4GofvV6d0aIRxpI7YnnDWGbIKs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772205962; c=relaxed/simple;
	bh=b6LIbEu/Lug0b+yPsWMIMf433S1RNm9/zjIXlOR11kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KoKigBpp6gYzMbptrsFFbkNbSxk4vdBs2VON8CapHMlcRhKV/UiH2GDN9xOGV1fMNYS2vfl/qXvnzgIJiYNO//qmMeIUDPWuic1CUoX37ULs8TzrNmgUxcfgx05lI0d/Rcx6kPGw9w6A6kgBP+gJgejweqbp4Q9R3Gk7VneSoII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kZpFniJ7; arc=fail smtp.client-ip=40.107.201.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kZpFniJ7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DYm5mIeuwX64QKqdbzTuoxZ+lkzqTf65hot5lHqw5YW5Z27ZaT4V25gvjDU9AFHfu2UBXdjknXvaAMFo7KvI0MZLW2KEHKfDzgC+aBfoOqXay5aOVCjhzBnYOGd7hAGgGiTyIojrbctRxPEZhuTpFb4IC9VpmY8ukVP11rg30+dvYheJUokHp299nU5Q1hFxhXUQMW6jj6OCbMLXxfjxQzDVtzc8ph1BPYOPrlqvVdWOl+g5GlxjmyGh0uCg8A9MUgWnz88Op112kxzYgyvoe/gxAVaCw8MMZzFpd6xsYF3vQ4LraWYSKOXJpyAn0D7bz3ke6xzwaEadLE4PZIr8mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EPrymiiNuwdvxSFhrazH8P5ZUJsmWZ9X2HAN+qCaZnc=;
 b=udC3uubcGcbXahXhVEIKpe6j6mTpdoG2diATaiiNdG7sHVubEWL6Tyv5occ3SCkbelw85JLRvy6ECZzijKTYvgzxEHkILLTx8teGRUG3W3MkvybKdOGJpVL2/yOvGynUMoWUSlYeMdIR5+q1tYNSQcXAhDJref8Q5w+DNABreR82YyGtgzjY5Dn+6giIIzynsvCKM3/S8seE4lOkopalisfMiQ7uyTCoc9zMQvHbJfLWs4r0sXUS2V3Aosho0ZtVOf95/XwXQaE/JkZtosiOpyNnZOE9zfqmQh5Q8BqVXlK7C5Gj+isiea1I9Oiqvlb8gbKcnuaIYd/A2bGzNXXWXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EPrymiiNuwdvxSFhrazH8P5ZUJsmWZ9X2HAN+qCaZnc=;
 b=kZpFniJ72NCMtIJnPv7SplkEKSonC6oBo4/9mx6GJdgt07vDOi7vKQkzq4y+kScvovFX5o7o4noqslZs+bhcjOJYabgP2IXa86Dsdgyj5aAuaPtPpiqBOuFG+EhS6JoB5El6s5QMePEJcifSSYmAcy0FFyfJH96+t3awanUj61pqeUAcUYb8Ekt7tB5ru1pdsvWYwqOc7FJhpifbwsnHjXvuy1eJihZcLX2YSaB461XfbE526cD8U7JXe2IbEZ23jnDLyz2CpwkzsRJne5d403M8evBzU7n8nUnoeLw9aqRRSsc37/I+6NYvi0C625hiqhS+jfkyvcBQDIPZcSDS/w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY5PR12MB6156.namprd12.prod.outlook.com (2603:10b6:930:24::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.16; Fri, 27 Feb
 2026 15:25:44 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 15:25:44 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Andrew Jones <ajones@ventanamicro.com>,
	Joerg Roedel <jroedel@suse.de>,
	lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>,
	patches@lists.linux.dev,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Vincent Chen <vincent.chen@sifive.com>,
	xieyongji@bytedance.com
Subject: [PATCH v4 3/6] iommu/riscv: Use the generic iommu page table
Date: Fri, 27 Feb 2026 11:25:38 -0400
Message-ID: <3-v4-5a9ca1a9b7a5+5f2-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v4-5a9ca1a9b7a5+5f2-iommu_pt_riscv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0013.namprd08.prod.outlook.com
 (2603:10b6:208:239::18) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY5PR12MB6156:EE_
X-MS-Office365-Filtering-Correlation-Id: 26969f09-8345-4dde-740d-08de7614789d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	N6Mp/RFOf4UVkYKSP4Vvmq3a2BPWDnofxbHbDY/Umxrtrx5QoOF+d4TyQuWestIHUjLVNYoqo0o33ZuqPb9zg3Apkhsx9s81PH/DFY1eIrfOW3/Dkym5mmcErCAF6/OxUq6tBUHQYhE2pdwNjXJlO6kMjeFoplaw6VYVriSE1kqgZ0DUcd3uhGdnRfHkZpTectzSHGodeRjKiO3KhW/cfbBzayU0TLfSgTwbe2BjN8UbBZ4uOwm2KAtRsOMZQEO+q/YGaD4FEFY+HyjKIT7gIFeQOmi1vBTJcCfqEbv/zmA8iCb/Wh51M1LzbP0LaO1nYYIE6nt/Zh5kt9JW9RYMTKZgJ0kGkpM6rROBmMIkSrs/DgZeJ3eDjfqCufCKeRThGscVnDGczHZczXEXnWaDRK97b0+mp9kPWbGc9PMLloyZ/z4LREc5jRWni/45O26w1j5avpLx3HEJWmKGyaRp2wOFMdOCMUCZVUkJV7HeihqiwRtbpF6gyzOhcs7bggX8SqyTtKQWMRhaUm7TgDv/muv0K3XEPi7XzioXxpLQFYWhXsNMTXuqqsKXTLRYnLmuX9bMBlcFKynAO04DDl9PRO3lCEZiywcUpjfGx7UUprCjkt9yaCdWYFCmKciHMV7zqYZK76xSsf/+JLORPWswxggRg3cCimR+rAByDD8k1QVSGla8WXazIsh4kBBno52tAZjoWwFC0brnRei7j0ezKDdAHltWTuVczCBVo432SGk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/wRPHjsN5SQLuvd+l537bJLPzvUaIIK1LJruqCWy/SoFGXGF97Ou3subpCHq?=
 =?us-ascii?Q?BNuwSXQ1Lh1ZSw2UnLJDzU+1Qq+fsow6if3XUdsEE6PI/7lVMjejs66sMucw?=
 =?us-ascii?Q?ImbhupUmAaDeBN10BYZGT8O3eskaD/MTyDVGNraDZN2E+OY7Ruacu9kHlOIB?=
 =?us-ascii?Q?RWrzlRd8ohhUcQovzeD9u+y2jh/ogqwNlSTTB4h62x4Od/SF2OzJFVX2Sw/u?=
 =?us-ascii?Q?cLN9mDXJmXxQ+qIBLdhkpDvQGtYLv7Ot8eRQq0IN3tfkRE/1Nv1ci3gYBofv?=
 =?us-ascii?Q?DHA9RZDUaD268RBKcPqjWo7aOQsqcfEEnNjgXPv6jHvLaw2skyYcGkIXg2lL?=
 =?us-ascii?Q?XOzzdO0TtVJbVmnIWk5NFLLWt3levX0oosWAWHUFfbeTN9MfxpA6aZpCRt6R?=
 =?us-ascii?Q?A+gBU3magY8a5FWxMwTsQeCb9enFgAFSIY1l05aCIZ3bh6yZVJm8eQCZPBXH?=
 =?us-ascii?Q?XNYl2jp1WG5wsCJ3nHU3Q69z8MDSnN3Rfe7DD0mLmgCS1FD7jZ7kTOHPAXUX?=
 =?us-ascii?Q?YAjRaPOZUD3AJ4mtDfxAQhWYYAzxQFeSrAZAADO4fjtU1z3b7hKf+uVJDFZC?=
 =?us-ascii?Q?mnR96IhExI23YezoJZ1QXOvPUUGzSMGnPGJvKcYePc5MSGfcdDpmIHqHrvmc?=
 =?us-ascii?Q?j24JrVjA7ZaqULt8jGVjvYnLUEFjkwLUCS7e4aI9WxZRD0Tp7BzLUd/Cl01C?=
 =?us-ascii?Q?shrcH0sI2FYEuacpoC6F5B3mPucG+KdjPpOwRAtocM2UVZKbUJg4m6DNNg5+?=
 =?us-ascii?Q?Jp8vNX85d7E6AgRCGHFrC8NfX8V7bdB9PY7V7JPe/Pgqsd7iSgC4Hvw578DH?=
 =?us-ascii?Q?hX6lH5JZT5L+8xBSXKbpuqQLu4g+h41+yP6Nw50MnK10fqIbJcuQ50/vVRs6?=
 =?us-ascii?Q?lDSJsvEe+c2aX9qoV1t9AXfr/nzlKLB0qN92YL6ENl7qJI1Uk5ZhZxBIpzST?=
 =?us-ascii?Q?ffnELgmYd8RmdkUdWJVlQi42DMoSk/ZRoHqcxsPMS3aC3I8wlJQMZcDbmGCz?=
 =?us-ascii?Q?mdXaUZFSbgwJsDRho0U01qgeDWseYhTyJyD72XACEsccdTUaUsqTaOXz81Sq?=
 =?us-ascii?Q?z+hMQcO1g3Qbl2H7CkI2CKTFqqXOiNQswJpaMHu/ZvREyR2JhDUqzUDXKxUH?=
 =?us-ascii?Q?HuTv3IQ7xq02RSVmI6guQCgRKSY8qXS9DnJtxNgHY/g+Vpng9WUykS5AYKtV?=
 =?us-ascii?Q?moD63bfdm+YbtD+rdJD62qSmK8jwcV7nbW+Qq3v0HgDdgw+TNT3uxsuGTtXw?=
 =?us-ascii?Q?qowapxSJVqr8YLeB1W8F8QzMgvDj5boZZ82Cg9OcfsW/MFMR+9hbVYtUkhyU?=
 =?us-ascii?Q?neM0DGyKoRRX8E1GEnO/D6tAqAOpsypNqpoNlBijdpC84r2XslicgWVy+kVa?=
 =?us-ascii?Q?3Dn4e2x7FT9PgpaHD00SvfYNT02XpTcQdAHmk2FsfZtjzhchBUfzsTM4PTcv?=
 =?us-ascii?Q?WTJWcdxJ6osVAS1ZWPxiAFhV8vX9cDTHfaTgnqJC7ibaLnlEXZii2ICuoHVm?=
 =?us-ascii?Q?IYtmMonvEJTHWu+FlGJBAY/NLnvk3tS7yA2PESen0wA38gdnAxRxuEHIao1z?=
 =?us-ascii?Q?tO6EtHKwq8Dxifn+7+5e0M3C9RQZC2TSVMYpsKFHDz7j0qFQlUBvfJ1x4sCT?=
 =?us-ascii?Q?EUaWgMU3k7VcKrmczLm3hsgh3AqSLb7c4i81SdBIxN2umAs6JduWEirn953K?=
 =?us-ascii?Q?VwtGMuwKGKkxyByA2qFYKLuRKJf0hHXTjU7N/KZhNf8BaimQDXGr5FaQy6p6?=
 =?us-ascii?Q?GR7fiLCj1w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26969f09-8345-4dde-740d-08de7614789d
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 15:25:43.1490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RWOoKeof8ry6PrOAoYLnGIvmUUbKBnCDZtWYMXYiyJjoOEu8O4YGFfdx2JJ78TW1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6156

This is a fairly straightforward conversion of the RISC-V iommu driver to
use the generic iommu page table code.

Invalidation stays as it is now with the driver pretending to implement
simple range based invalidation even though the HW is more like ARM SMMUv3
than AMD where the HW implements a single-PTE based invalidation. Future
work to extend the generic invalidate mechanism to support more ARM-like
semantics would benefit this driver as well.

Delete the existing page table code.

Tested-by: Vincent Chen <vincent.chen@sifive.com>
Acked-by: Paul Walmsley <pjw@kernel.org> # arch/riscv
Reviewed-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Tested-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/Kconfig |   3 +
 drivers/iommu/riscv/iommu.c | 287 +++++-------------------------------
 2 files changed, 39 insertions(+), 251 deletions(-)

diff --git a/drivers/iommu/riscv/Kconfig b/drivers/iommu/riscv/Kconfig
index c071816f59a67b..a329ec634cf1c5 100644
--- a/drivers/iommu/riscv/Kconfig
+++ b/drivers/iommu/riscv/Kconfig
@@ -6,6 +6,9 @@ config RISCV_IOMMU
 	depends on RISCV && 64BIT
 	default y
 	select IOMMU_API
+	select GENERIC_PT
+	select IOMMU_PT
+	select IOMMU_PT_RISCV64
 	help
 	  Support for implementations of the RISC-V IOMMU architecture that
 	  complements the RISC-V MMU capabilities, providing similar address
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 0b290337247044..6ceca9bed91723 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -21,6 +21,7 @@
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/generic_pt/iommu.h>
 
 #include "../iommu-pages.h"
 #include "iommu-bits.h"
@@ -806,14 +807,15 @@ static int riscv_iommu_iodir_set_mode(struct riscv_iommu_device *iommu,
 
 /* This struct contains protection domain specific IOMMU driver data. */
 struct riscv_iommu_domain {
-	struct iommu_domain domain;
+	union {
+		struct iommu_domain domain;
+		struct pt_iommu_riscv_64 riscvpt;
+	};
 	struct list_head bonds;
 	spinlock_t lock;		/* protect bonds list updates. */
 	int pscid;
-	int numa_node;
-	unsigned int pgd_mode;
-	unsigned long *pgd_root;
 };
+PT_IOMMU_CHECK_DOMAIN(struct riscv_iommu_domain, riscvpt.iommu, domain);
 
 #define iommu_domain_to_riscv(iommu_domain) \
 	container_of(iommu_domain, struct riscv_iommu_domain, domain)
@@ -1076,156 +1078,9 @@ static void riscv_iommu_iotlb_sync(struct iommu_domain *iommu_domain,
 {
 	struct riscv_iommu_domain *domain = iommu_domain_to_riscv(iommu_domain);
 
-	riscv_iommu_iotlb_inval(domain, gather->start, gather->end);
-}
-
-#define PT_SHIFT (PAGE_SHIFT - ilog2(sizeof(pte_t)))
-
-#define _io_pte_present(pte)	((pte) & (_PAGE_PRESENT | _PAGE_PROT_NONE))
-#define _io_pte_leaf(pte)	((pte) & _PAGE_LEAF)
-#define _io_pte_none(pte)	((pte) == 0)
-#define _io_pte_entry(pn, prot)	((_PAGE_PFN_MASK & ((pn) << _PAGE_PFN_SHIFT)) | (prot))
-
-static void riscv_iommu_pte_free(struct riscv_iommu_domain *domain,
-				 unsigned long pte,
-				 struct iommu_pages_list *freelist)
-{
-	unsigned long *ptr;
-	int i;
-
-	if (!_io_pte_present(pte) || _io_pte_leaf(pte))
-		return;
-
-	ptr = (unsigned long *)pfn_to_virt(__page_val_to_pfn(pte));
-
-	/* Recursively free all sub page table pages */
-	for (i = 0; i < PTRS_PER_PTE; i++) {
-		pte = READ_ONCE(ptr[i]);
-		if (!_io_pte_none(pte) && cmpxchg_relaxed(ptr + i, pte, 0) == pte)
-			riscv_iommu_pte_free(domain, pte, freelist);
-	}
-
-	if (freelist)
-		iommu_pages_list_add(freelist, ptr);
-	else
-		iommu_free_pages(ptr);
-}
-
-static unsigned long *riscv_iommu_pte_alloc(struct riscv_iommu_domain *domain,
-					    unsigned long iova, size_t pgsize,
-					    gfp_t gfp)
-{
-	unsigned long *ptr = domain->pgd_root;
-	unsigned long pte, old;
-	int level = domain->pgd_mode - RISCV_IOMMU_DC_FSC_IOSATP_MODE_SV39 + 2;
-	void *addr;
-
-	do {
-		const int shift = PAGE_SHIFT + PT_SHIFT * level;
-
-		ptr += ((iova >> shift) & (PTRS_PER_PTE - 1));
-		/*
-		 * Note: returned entry might be a non-leaf if there was
-		 * existing mapping with smaller granularity. Up to the caller
-		 * to replace and invalidate.
-		 */
-		if (((size_t)1 << shift) == pgsize)
-			return ptr;
-pte_retry:
-		pte = READ_ONCE(*ptr);
-		/*
-		 * This is very likely incorrect as we should not be adding
-		 * new mapping with smaller granularity on top
-		 * of existing 2M/1G mapping. Fail.
-		 */
-		if (_io_pte_present(pte) && _io_pte_leaf(pte))
-			return NULL;
-		/*
-		 * Non-leaf entry is missing, allocate and try to add to the
-		 * page table. This might race with other mappings, retry.
-		 */
-		if (_io_pte_none(pte)) {
-			addr = iommu_alloc_pages_node_sz(domain->numa_node, gfp,
-							 SZ_4K);
-			if (!addr)
-				return NULL;
-			old = pte;
-			pte = _io_pte_entry(virt_to_pfn(addr), _PAGE_TABLE);
-			if (cmpxchg_relaxed(ptr, old, pte) != old) {
-				iommu_free_pages(addr);
-				goto pte_retry;
-			}
-		}
-		ptr = (unsigned long *)pfn_to_virt(__page_val_to_pfn(pte));
-	} while (level-- > 0);
-
-	return NULL;
-}
-
-static unsigned long *riscv_iommu_pte_fetch(struct riscv_iommu_domain *domain,
-					    unsigned long iova, size_t *pte_pgsize)
-{
-	unsigned long *ptr = domain->pgd_root;
-	unsigned long pte;
-	int level = domain->pgd_mode - RISCV_IOMMU_DC_FSC_IOSATP_MODE_SV39 + 2;
-
-	do {
-		const int shift = PAGE_SHIFT + PT_SHIFT * level;
-
-		ptr += ((iova >> shift) & (PTRS_PER_PTE - 1));
-		pte = READ_ONCE(*ptr);
-		if (_io_pte_present(pte) && _io_pte_leaf(pte)) {
-			*pte_pgsize = (size_t)1 << shift;
-			return ptr;
-		}
-		if (_io_pte_none(pte))
-			return NULL;
-		ptr = (unsigned long *)pfn_to_virt(__page_val_to_pfn(pte));
-	} while (level-- > 0);
-
-	return NULL;
-}
-
-static int riscv_iommu_map_pages(struct iommu_domain *iommu_domain,
-				 unsigned long iova, phys_addr_t phys,
-				 size_t pgsize, size_t pgcount, int prot,
-				 gfp_t gfp, size_t *mapped)
-{
-	struct riscv_iommu_domain *domain = iommu_domain_to_riscv(iommu_domain);
-	size_t size = 0;
-	unsigned long *ptr;
-	unsigned long pte, old, pte_prot;
-	int rc = 0;
-	struct iommu_pages_list freelist = IOMMU_PAGES_LIST_INIT(freelist);
-
-	if (!(prot & IOMMU_WRITE))
-		pte_prot = _PAGE_BASE | _PAGE_READ;
-	else
-		pte_prot = _PAGE_BASE | _PAGE_READ | _PAGE_WRITE | _PAGE_DIRTY;
-
-	while (pgcount) {
-		ptr = riscv_iommu_pte_alloc(domain, iova, pgsize, gfp);
-		if (!ptr) {
-			rc = -ENOMEM;
-			break;
-		}
-
-		old = READ_ONCE(*ptr);
-		pte = _io_pte_entry(phys_to_pfn(phys), pte_prot);
-		if (cmpxchg_relaxed(ptr, old, pte) != old)
-			continue;
-
-		riscv_iommu_pte_free(domain, old, &freelist);
-
-		size += pgsize;
-		iova += pgsize;
-		phys += pgsize;
-		--pgcount;
-	}
-
-	*mapped = size;
-
-	if (!iommu_pages_list_empty(&freelist)) {
+	if (iommu_pages_list_empty(&gather->freelist)) {
+		riscv_iommu_iotlb_inval(domain, gather->start, gather->end);
+	} else {
 		/*
 		 * In 1.0 spec version, the smallest scope we can use to
 		 * invalidate all levels of page table (i.e. leaf and non-leaf)
@@ -1234,71 +1089,20 @@ static int riscv_iommu_map_pages(struct iommu_domain *iommu_domain,
 		 * capability.NL (non-leaf) IOTINVAL command.
 		 */
 		riscv_iommu_iotlb_inval(domain, 0, ULONG_MAX);
-		iommu_put_pages_list(&freelist);
+		iommu_put_pages_list(&gather->freelist);
 	}
-
-	return rc;
-}
-
-static size_t riscv_iommu_unmap_pages(struct iommu_domain *iommu_domain,
-				      unsigned long iova, size_t pgsize,
-				      size_t pgcount,
-				      struct iommu_iotlb_gather *gather)
-{
-	struct riscv_iommu_domain *domain = iommu_domain_to_riscv(iommu_domain);
-	size_t size = pgcount << __ffs(pgsize);
-	unsigned long *ptr, old;
-	size_t unmapped = 0;
-	size_t pte_size;
-
-	while (unmapped < size) {
-		ptr = riscv_iommu_pte_fetch(domain, iova, &pte_size);
-		if (!ptr)
-			return unmapped;
-
-		/* partial unmap is not allowed, fail. */
-		if (iova & (pte_size - 1))
-			return unmapped;
-
-		old = READ_ONCE(*ptr);
-		if (cmpxchg_relaxed(ptr, old, 0) != old)
-			continue;
-
-		iommu_iotlb_gather_add_page(&domain->domain, gather, iova,
-					    pte_size);
-
-		iova += pte_size;
-		unmapped += pte_size;
-	}
-
-	return unmapped;
-}
-
-static phys_addr_t riscv_iommu_iova_to_phys(struct iommu_domain *iommu_domain,
-					    dma_addr_t iova)
-{
-	struct riscv_iommu_domain *domain = iommu_domain_to_riscv(iommu_domain);
-	size_t pte_size;
-	unsigned long *ptr;
-
-	ptr = riscv_iommu_pte_fetch(domain, iova, &pte_size);
-	if (!ptr)
-		return 0;
-
-	return pfn_to_phys(__page_val_to_pfn(*ptr)) | (iova & (pte_size - 1));
 }
 
 static void riscv_iommu_free_paging_domain(struct iommu_domain *iommu_domain)
 {
 	struct riscv_iommu_domain *domain = iommu_domain_to_riscv(iommu_domain);
-	const unsigned long pfn = virt_to_pfn(domain->pgd_root);
 
 	WARN_ON(!list_empty(&domain->bonds));
 
 	if ((int)domain->pscid > 0)
 		ida_free(&riscv_iommu_pscids, domain->pscid);
 
-	riscv_iommu_pte_free(domain, _io_pte_entry(pfn, _PAGE_TABLE), NULL);
+	pt_iommu_deinit(&domain->riscvpt.iommu);
 	kfree(domain);
 }
 
@@ -1324,13 +1128,16 @@ static int riscv_iommu_attach_paging_domain(struct iommu_domain *iommu_domain,
 	struct riscv_iommu_domain *domain = iommu_domain_to_riscv(iommu_domain);
 	struct riscv_iommu_device *iommu = dev_to_iommu(dev);
 	struct riscv_iommu_info *info = dev_iommu_priv_get(dev);
+	struct pt_iommu_riscv_64_hw_info pt_info;
 	u64 fsc, ta;
 
-	if (!riscv_iommu_pt_supported(iommu, domain->pgd_mode))
+	pt_iommu_riscv_64_hw_info(&domain->riscvpt, &pt_info);
+
+	if (!riscv_iommu_pt_supported(iommu, pt_info.fsc_iosatp_mode))
 		return -ENODEV;
 
-	fsc = FIELD_PREP(RISCV_IOMMU_PC_FSC_MODE, domain->pgd_mode) |
-	      FIELD_PREP(RISCV_IOMMU_PC_FSC_PPN, virt_to_pfn(domain->pgd_root));
+	fsc = FIELD_PREP(RISCV_IOMMU_PC_FSC_MODE, pt_info.fsc_iosatp_mode) |
+	      FIELD_PREP(RISCV_IOMMU_PC_FSC_PPN, pt_info.ppn);
 	ta = FIELD_PREP(RISCV_IOMMU_PC_TA_PSCID, domain->pscid) |
 	     RISCV_IOMMU_PC_TA_V;
 
@@ -1345,37 +1152,32 @@ static int riscv_iommu_attach_paging_domain(struct iommu_domain *iommu_domain,
 }
 
 static const struct iommu_domain_ops riscv_iommu_paging_domain_ops = {
+	IOMMU_PT_DOMAIN_OPS(riscv_64),
 	.attach_dev = riscv_iommu_attach_paging_domain,
 	.free = riscv_iommu_free_paging_domain,
-	.map_pages = riscv_iommu_map_pages,
-	.unmap_pages = riscv_iommu_unmap_pages,
-	.iova_to_phys = riscv_iommu_iova_to_phys,
 	.iotlb_sync = riscv_iommu_iotlb_sync,
 	.flush_iotlb_all = riscv_iommu_iotlb_flush_all,
 };
 
 static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 {
+	struct pt_iommu_riscv_64_cfg cfg = {};
 	struct riscv_iommu_domain *domain;
 	struct riscv_iommu_device *iommu;
-	unsigned int pgd_mode;
-	dma_addr_t va_mask;
-	int va_bits;
+	int ret;
 
 	iommu = dev_to_iommu(dev);
 	if (iommu->caps & RISCV_IOMMU_CAPABILITIES_SV57) {
-		pgd_mode = RISCV_IOMMU_DC_FSC_IOSATP_MODE_SV57;
-		va_bits = 57;
+		cfg.common.hw_max_vasz_lg2 = 57;
 	} else if (iommu->caps & RISCV_IOMMU_CAPABILITIES_SV48) {
-		pgd_mode = RISCV_IOMMU_DC_FSC_IOSATP_MODE_SV48;
-		va_bits = 48;
+		cfg.common.hw_max_vasz_lg2 = 48;
 	} else if (iommu->caps & RISCV_IOMMU_CAPABILITIES_SV39) {
-		pgd_mode = RISCV_IOMMU_DC_FSC_IOSATP_MODE_SV39;
-		va_bits = 39;
+		cfg.common.hw_max_vasz_lg2 = 39;
 	} else {
 		dev_err(dev, "cannot find supported page table mode\n");
 		return ERR_PTR(-ENODEV);
 	}
+	cfg.common.hw_max_oasz_lg2 = 56;
 
 	domain = kzalloc_obj(*domain);
 	if (!domain)
@@ -1383,42 +1185,23 @@ static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 
 	INIT_LIST_HEAD_RCU(&domain->bonds);
 	spin_lock_init(&domain->lock);
-	domain->numa_node = dev_to_node(iommu->dev);
-	domain->pgd_mode = pgd_mode;
-	domain->pgd_root = iommu_alloc_pages_node_sz(domain->numa_node,
-						     GFP_KERNEL_ACCOUNT, SZ_4K);
-	if (!domain->pgd_root) {
-		kfree(domain);
-		return ERR_PTR(-ENOMEM);
-	}
+	cfg.common.features = BIT(PT_FEAT_SIGN_EXTEND) |
+			      BIT(PT_FEAT_FLUSH_RANGE);
+	domain->riscvpt.iommu.nid = dev_to_node(iommu->dev);
+	domain->domain.ops = &riscv_iommu_paging_domain_ops;
 
 	domain->pscid = ida_alloc_range(&riscv_iommu_pscids, 1,
 					RISCV_IOMMU_MAX_PSCID, GFP_KERNEL);
 	if (domain->pscid < 0) {
-		iommu_free_pages(domain->pgd_root);
-		kfree(domain);
+		riscv_iommu_free_paging_domain(&domain->domain);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	/*
-	 * Note: RISC-V Privilege spec mandates that virtual addresses
-	 * need to be sign-extended, so if (VA_BITS - 1) is set, all
-	 * bits >= VA_BITS need to also be set or else we'll get a
-	 * page fault. However the code that creates the mappings
-	 * above us (e.g. iommu_dma_alloc_iova()) won't do that for us
-	 * for now, so we'll end up with invalid virtual addresses
-	 * to map. As a workaround until we get this sorted out
-	 * limit the available virtual addresses to VA_BITS - 1.
-	 */
-	va_mask = DMA_BIT_MASK(va_bits - 1);
-
-	domain->domain.geometry.aperture_start = 0;
-	domain->domain.geometry.aperture_end = va_mask;
-	domain->domain.geometry.force_aperture = true;
-	domain->domain.pgsize_bitmap = va_mask & (SZ_4K | SZ_2M | SZ_1G | SZ_512G);
-
-	domain->domain.ops = &riscv_iommu_paging_domain_ops;
-
+	ret = pt_iommu_riscv_64_init(&domain->riscvpt, &cfg, GFP_KERNEL);
+	if (ret) {
+		riscv_iommu_free_paging_domain(&domain->domain);
+		return ERR_PTR(ret);
+	}
 	return &domain->domain;
 }
 
@@ -1674,3 +1457,5 @@ int riscv_iommu_init(struct riscv_iommu_device *iommu)
 	riscv_iommu_queue_disable(&iommu->cmdq);
 	return rc;
 }
+
+MODULE_IMPORT_NS("GENERIC_PT_IOMMU");
-- 
2.43.0


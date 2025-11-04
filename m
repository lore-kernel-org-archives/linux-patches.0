Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012027.outbound.protection.outlook.com [40.93.195.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB51D2ED84C;
	Tue,  4 Nov 2025 19:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.27
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762282870; cv=fail; b=KQWfDcLy68I2CN7S1aUKeEyJaX9xMqgn84gphE7KOG4LYGszWPQ3xgYTCgP9SiMKLcAC2nEIN8WAh7zdnU63RwF5kvmPr3q3B8V1clq6WlF/4MViyGGyJUlgH4BTGKplrQBZ87B4msSKWst2bSIRDCVDjQKgBv1Dii9D2pcFZak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762282870; c=relaxed/simple;
	bh=ERRB5bzdCAy4PUoQ5VoBlx/d9LeGXacms5awkZukkVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aagaYQDvxZEs4xCm8p2cp8R5R8iWc3lhCjwVuuvYOok95CTeFPEmpryXLVa5t2kdrnb70r0dtfZHv9+/U7/5fbrx2Ouptx0VqLhyZweOpoqtdKY16ISU80rQbq8/9PmPcGU+CDStIiVdxSh6E06hk65iFazfCBGoXDBdw/hjFRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=G0vpUa7p; arc=fail smtp.client-ip=40.93.195.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="G0vpUa7p"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MQXATrvpZ6P/KB3WnlSmKeZpmOLxqinTVKNi1ycP+KeAvLIrFb36r6/bw28xYhgcg9Ru9gvvqQVpjh5ItR/lCn68C8bBQU3Jdl1rxZgIPfXn+Z0dzit9lBkdHQf8RuV74zDBZn3Pv4HoLGvRkQbesiWOxhcQyusXwWbg0pLVhTpnbZTy8NvmusQJOlEx6Y8SHKBly1kcvi/sgwNR9c5aCkOs1VOGtmQhMyklh51iqv+fjo0cBetmpZcWquNM1758x3RaAPHmqPYr0LyMxCitzVunhvpK8XEgiovC6BEwbO8CIGDmUnJE9j9CMhm62Fg6a09fsQvwhRszXSJT2ApdSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9/qi/FIwUMIXUQIJdEQVhgG3zXcm/gFoVK7Kx1LPuv4=;
 b=CO+tjOOHL6gu45EqgI5ovCZUsgJa9chLSu+ntOeXTPq9Y47XdSBL6BF8T7LgHMa+gdEDcvbghmYgS6qdSCmnBDxBlkfgvSguY6tfcI4KfzU+nj7TosbEzvOUfOVjMVMFbiAFycYwqPocWVTuCazEzQvGGVO3dz+tjj1SdMtF4Of5TVNyZGRa3sSle757aOGVNk+pqMjnnFaqN2PKdfwByQc6IeRYU1xVLNV2+hg8cGen79p9nY0NMzElHfdHvD3UFeBBlMzswrPK/qllowEp0EcEAZzQ/RE7PHXjBGdWbX807AW6Pmt9JwERS3A8/t98yHwOwuDDQdMRFkjnRQnE4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9/qi/FIwUMIXUQIJdEQVhgG3zXcm/gFoVK7Kx1LPuv4=;
 b=G0vpUa7p+q5JYV+5qpoNUSNr/QrVUNqjtYZU89zU7bYy8/M4wA/VjjukbJPIXzafvleCsuIPDJNcC4Xh++YL4oPB8GteSfQftCHzeoIbMxcTjECTxpX3OJj3dvK/VPr4hP1bipmtX24zCerieDEBIGRCipsP/Jr0+aH6sW3g2s6yi0jKWvNhF3Z0mPhwiYGtfKSuPILJBmzybub4SSU4Zdc3FJUim05f+qIFAJGrYBsC9bZoqjVUtks38FM5GvX42MFHQXP6fYKOk5F2M0zBkEqUhbOPPJz2OwCvKQUJ3VyPPoI05haWrIBWTa/q/MJai/Z+gf1AL55HAkpHJi458w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by MW6PR12MB7071.namprd12.prod.outlook.com (2603:10b6:303:238::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.8; Tue, 4 Nov
 2025 19:00:48 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9298.006; Tue, 4 Nov 2025
 19:00:48 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>
Cc: lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>,
	patches@lists.linux.dev,
	xieyongji@bytedance.com
Subject: [PATCH 3/5] iommu/riscv: Use the generic iommu page table
Date: Tue,  4 Nov 2025 15:00:42 -0400
Message-ID: <3-v1-d3317b0ee398+50-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v1-d3317b0ee398+50-iommu_pt_riscv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:208:335::22) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|MW6PR12MB7071:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b498b48-3140-4191-076a-08de1bd47647
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NJ8riR3N6YACspqeOHOJa8LNMpZgwSjcMJz7QwqGRSRWeYmddVqz2BiyA4sv?=
 =?us-ascii?Q?rAxeuCyxvk5pUrS+3vtCwoN+i5usEfnjUM9X8TV9Zk0l5F/5jrSDktHq6OMR?=
 =?us-ascii?Q?ISV84tnkYmLpZ4+ivxVn0JR89Hj7V8RLp92bsVoVcuiVq2UMigEVB8slMTQM?=
 =?us-ascii?Q?gxIc1SlUNP/tK4kpNCk+x1m8Tj0bfrpxX4ZX5uE1kyN3UC626KoGTmFH8hVf?=
 =?us-ascii?Q?E9nFvaMXAm/iVTQwOz/omMMSzU5Il+ApdW69IRnq7lO2SiwEWLBoev9aGYl4?=
 =?us-ascii?Q?+vINWk8IOkxd+ifxQSj41CQeMF/dosRE6C/47dYT3rxCrxGG0XzOM0fRqZ1/?=
 =?us-ascii?Q?Ll6I3umgk7WdAylkrm5MOMKeqxEDT/J9+9rtslsaZjK8fndg80+TQPItCCzy?=
 =?us-ascii?Q?qcxEiUtX/m3M/ZrdXi1Vy9TlEXkheCW5j7nQATB0ZNIV7JOoqEnSDTtGHTMb?=
 =?us-ascii?Q?OnkmTtu5vynyUdHB3wle4WqHrjjqnK71/f+mzHr7LfeVlQc0F5IqbT3UzNFA?=
 =?us-ascii?Q?mcs4oZyNf9vfkl0ewwcA7252C7NkykqsVfYYmFjkDnFXNjwHIoaTudyTILQ9?=
 =?us-ascii?Q?58xsQ/B0vk99nagoB98K0vry5Fl3nY7p2zAt0rZYGpjyKla3Covy0WjJUqkS?=
 =?us-ascii?Q?Rdl3caEgQnkBf1OyNymt98nMQZHLTdAj7oPQf3eKLtzFjtg03ZJ14I274qbH?=
 =?us-ascii?Q?R6XRgXgDL0APcu+PNjd+imXEbwdVQUCdqCNUy9ci9tEbFSItwhURppYm1kPk?=
 =?us-ascii?Q?4ounQZCYlxHnr9ZC/o9kzbtf2FHuhMoc0shfe7XC/Ha2J8U8VtWX0yjt/4yl?=
 =?us-ascii?Q?nVUscK2EpbERZgFGinqC8zqTtWAMhY9JZ66vAJG2NyYVGb4KcOuKDIWRfTRE?=
 =?us-ascii?Q?DkHxmTAWfGIrUAZzs22KZ9RJP9mzXOPlyNjiSJLOUckR5P6y3IUZ+pyDupE9?=
 =?us-ascii?Q?mHN1ji3F5iDH0ntR1cLL2S5sfGK8SkoUi2NvHxN54lsX2P8XivZHgTIlTxKy?=
 =?us-ascii?Q?rrTohQ/DRTOH3z7DfiAn7PiWy2kpjqb057Y9WeLfT1U5soRKlscq4gQ171q8?=
 =?us-ascii?Q?On6noMyvNZmqmuN1gGSrJWYHyU2MCXNizB4cNEL9mZnT7xwpdftz6o0DMoGQ?=
 =?us-ascii?Q?72B9QNzpiBFXVpHH0EnshSFLxjieJENPn9oCAsGSiNdHg6+64YkJdCuuI77f?=
 =?us-ascii?Q?ITvP7K4NL7chuRr0KLnHTg12KSjiPLNS1UNhygai/qWJfxbgc7f6lK80Xxbn?=
 =?us-ascii?Q?+lyzGahk1LaqJXIazjl0hT3AG4DldyUgOeT49CT6bIEt6shq/d/LGQCizV0J?=
 =?us-ascii?Q?8UaYsjrJT2ODeQ5GN6szwDwM8hc1hd3z1EAKFYkeeKkpfWXqX1wBxeE/eIDw?=
 =?us-ascii?Q?Bq9C1iiNE1elfleJN4FCs1wtqo8cQBZxPtfTtLcZYCoG3R6Q7Rm/tTfAZ7Zp?=
 =?us-ascii?Q?/v7NHy/BD0y3Due15acQq/pRqD87IiT5ThPHabKYHhfkKqCY+xZXESRqNYY9?=
 =?us-ascii?Q?BO2sPpBMqKW+Bbw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eHjprfaGFS3GXlExEL+jRiuCuc/QM8xZPp2bRQXTYDqBl/tZ0roBVqEiSlXK?=
 =?us-ascii?Q?X4z2o69Et/xJGo26B39jXPbkfEiPHk0JMA1tK0iK+idIArGq9m7CwpMrOOz8?=
 =?us-ascii?Q?tGW2xzUyiTyaw9iu11cwmwXGZ/n5IHs6PZoAGSCZIwJsNUffgcxMGIEhE3Ko?=
 =?us-ascii?Q?KeLmprFLhSh9qoTBXmSmJpeKJ9+he7IhEvdLzb5Z485dZ89yXWA5vkhoxuZQ?=
 =?us-ascii?Q?YUKJR6i0WBCHzTDTSJrsgUhXGvnX90iU20vsGq9uiiu4/rEjj1r+AxosQ8Rl?=
 =?us-ascii?Q?04l7F0q1hzDKrRBJLjksWT3B/jfkXbyaBrpMTiGXy0PtNcseJw36Z1XiYu3y?=
 =?us-ascii?Q?tQZ/6ZnRWWRZSlntrNhhz2wMnYhXWngsjh1w9YKRTM/Qm696x/GZv5/2In1P?=
 =?us-ascii?Q?RWpRnOAHjW2kyElEFNnwuaB/Pst9qsk3DfydePQhAdmdFwWMtmbtXikAFnkQ?=
 =?us-ascii?Q?LRc6QYaUBvLyFdoLPWkDwzYTA9EP+ntM51bhE217OkuzPAF4SQ0htQI2WFEi?=
 =?us-ascii?Q?QGErzFmHZ6ymSOAHGyU60rSq6dQofDFFVy6/LWwA9B1iF5UDC9vT0cuDiAXe?=
 =?us-ascii?Q?WxuYN287/Piyn0QRxkydiizQ5hpuZRyyaJOy2NXWAUuo0C7pdaEqxrQA4Lvm?=
 =?us-ascii?Q?ydVtuue1pAbjYk4ck1G3p/1pf21tM3DKyKuE6Y8pHiz8UCFtFNtqCNrma7IO?=
 =?us-ascii?Q?496GIRaE3nCY4cgybbf/M/NRn3JSOq5KMggeb6vdQL3lbn2QfbHz9SFfCMNu?=
 =?us-ascii?Q?5XnuzbviLFpkP9Kf83Y8jD4dHiO0eU2wZdf7YS7MyDpfwyegtc5itRLWz0nk?=
 =?us-ascii?Q?P1GsT6bFF8gNkoKf5fkeFUIv23xuURyzITEIC8hb6tJkmvPF1wI2bqL/BKp+?=
 =?us-ascii?Q?htxHaRssNYAIJoGyRx+jqZjO24QA9O1W2sIv+fDzkLRMYzGjIrwE7bJsaHBa?=
 =?us-ascii?Q?DmfKwG7gz7/WCihvaoUOOd6JuYezj0Pd+oqYNMdNpZwnW/E/ZjnzZZVyKJw8?=
 =?us-ascii?Q?3xCkCrKmOr0EZne1SkHlJtuU+YrXwVBKer0JqV/cJr/ARDdSeA0hrzMOyxVi?=
 =?us-ascii?Q?WXBWBqMp/3fCpPwgDeD2btU+WT8GnI/kGJd2Ns/lymCBsxJljjjrVla4McNR?=
 =?us-ascii?Q?St2/UA7JGjAbdTqOm1fK5QaDXAUySoHVMbMh/wgUMxsjEPZcRyRQgiOHpF2F?=
 =?us-ascii?Q?BM+Ki1EDOwrMmzXu3wKU0hu5lxG4hTrV4g0p6+xbLNR3dcCedq4nPp/illCx?=
 =?us-ascii?Q?Ig1pmN8VYwcN8YsPnu+FyAqERLyVJw4OCj2h0omMJHth8r77VXECDR0hW21r?=
 =?us-ascii?Q?HCNTFfosy/03FEOYCEONozrHbVUtCMnZSIkARwWsCAjXhlyLKstADl7hjBYA?=
 =?us-ascii?Q?QzihdRcChXnYm4INnSNuB9mKm12VCISOZfUYPvPz8NIVhrxD6h3FdgNSG5SD?=
 =?us-ascii?Q?Tglwzfz8TqeRb9XKMo/uhTmx8dW4v3MdU17td09KlM+5M+KQCJefutxP4wuN?=
 =?us-ascii?Q?InkhF0X5my6+doE3ZPu7R2fsNJWXg84e81NhbgC/klW5NON+Av5DqnmIx/h5?=
 =?us-ascii?Q?XLLhricil+3G9vKce0o=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b498b48-3140-4191-076a-08de1bd47647
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 19:00:46.5996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AZ8KYHgX6xrvVdTLv6S6kHI1vuIJc7+SzctYDx/p4ZLHAlRRchHP64/2KI5Az7Uh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7071

This is a fairly straightforward conversion of the RISC-V iommu driver to
use the generic iommu page table code.

Invalidation stays as it is now with the driver pretending to implement
simple range based invalidation even though the HW is more like ARM SMMUv3
than AMD where the HW implements a single-PTE based invalidation. Future
work to extend the generic invalidate mechanism to support more ARM-like
semantics would benefit this driver as well.

Delete the existing page table code.

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
index 3a29b31d53bbf7..8fe0031f6cb665 100644
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
 
@@ -1323,13 +1127,16 @@ static int riscv_iommu_attach_paging_domain(struct iommu_domain *iommu_domain,
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
 
@@ -1344,37 +1151,32 @@ static int riscv_iommu_attach_paging_domain(struct iommu_domain *iommu_domain,
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
 
 	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
 	if (!domain)
@@ -1382,42 +1184,23 @@ static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 
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
 
@@ -1671,3 +1454,5 @@ int riscv_iommu_init(struct riscv_iommu_device *iommu)
 	riscv_iommu_queue_disable(&iommu->cmdq);
 	return rc;
 }
+
+MODULE_IMPORT_NS("GENERIC_PT_IOMMU");
-- 
2.43.0


Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011048.outbound.protection.outlook.com [40.107.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24FF1A9F97;
	Sat, 31 Jan 2026 00:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769817663; cv=fail; b=YFH7O1bKDFex8Tf3bueYRr+c/Nw00JiDf/bV4lb/NZIovIl7lD1U9VopCqhXJPi6p7Bk4YukGoZOVKc1FSCZHIdYh4TcUTdarYFYc+nMldpOKHsm6MP2G3+1z90YFbqo/721bycudIIa+DNRMszk9wJBONxCV8cd74vMDqs5K1A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769817663; c=relaxed/simple;
	bh=TvnjcUZgC4p89PWZpE4Y/oX+5KDnymCj+4Hj2fM517M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XjYzyhEhMcbW9K53odoWneIpHT6nXIMgtrUVUoKPTK2MEdDAkdmw6/BWeg5uO/xK7HnQ3VDfQwAieNwafmX9PUg38VgH4Oh3wTk6SKTGbFy0E1h887LVh3m6UIWvSVMHJ1jg71eFbQvDJrIxleiQB8LoYm2m4zDqvOKHgU4Y0E4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UM+EJdx3; arc=fail smtp.client-ip=40.107.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UM+EJdx3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ba13AMJpsfnMwDtVPDhQQwekogepT+20dgi9ByBCXYml+1+SlGR4ic2PUIjklhc7lVU6Zqu9iP/8wjehkmya/X7NTWl6y3OTSLLBMl27xdUinXQKn0KHBpuIZONctZM80i8wA+qJ6+amxPaHR7psJhsQyUX74MAB56PZ8mi5CGlLVxqUehQbkuAWEG78ASRWWD4nCAo5WJGzMGkzkSD/srCChG9bJvQZhXga3ZCX60EOBTB6j987JDBuITNkvsyRTferOthPQjZH3+oAmpTC9ApUK2DlKh6UCFJXAgk9ZnxJWnxBcHgUW7ZFUd8vrXl3oRe6qcd6rm1LiB/c1kYEyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6luCsiumnAohP7ABEBxNbBlcrIh8VeyRBp7ueKWQ7xk=;
 b=WxWBB/n8zihd+fAWEltn58XHz72xA/vJZjU8IUd1E/zdOqnYJkVeaFA/N9n/ikqWxKYBl/+x99elH6UuWMUIO9LHVXeEaOaCoI04zKZ9FBMfbasGE+5wGJ/c9LV3qIasC3eo4wrGTkK/uZ3W6Fg/2zhhZGX0ZrKm0ndaHtGpRxr+upGUeDKvbXx5hGBpTIi2/hcS+9H4X9wggjlE/PQ+PSBU/zH/3SCb/HtvV346i+Qp4v+hhYjl4eKQloSX0KoJ+jDd5qDmCxyoKtUJD9MTyj8Dr8GFOjyhZouwB4UMBzFAxTa6fHEnXCKZq9AK8g9kd+URsmCsdztDrfcwjXJAKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6luCsiumnAohP7ABEBxNbBlcrIh8VeyRBp7ueKWQ7xk=;
 b=UM+EJdx3UNmYvC/6vAQnt3zE9l41aGDIzAHOY853R6g2EZtQP3ZMO41rZyB6R2U+29wXPPhu0iTRECFcC6LmhVdqRzAoIGBDkbwTjqi1hZzjN/xVRTUZMhYBTcmrCCLNJZXVEt2HWNTK+PN6YJsoJeeZtX13uVuUMXnKRx9Hm8UxvqknW0ffhNqGabWozNZKtXK61eEtozjtIxc+sjTZHWOhRfO6Wx7KhY/gv4b2oo1AZoih59BLEX2iPktBUycHWrJ3l9w53sua01LDSxKgbiKemJComXwL/lufgDNpnjFU6w76V0dKtOdnikNRrRjccuvZddH4kby4oocGF0ok0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH1PR12MB9672.namprd12.prod.outlook.com (2603:10b6:610:2b0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Sat, 31 Jan
 2026 00:00:49 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9564.010; Sat, 31 Jan 2026
 00:00:49 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>
Cc: lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>,
	patches@lists.linux.dev,
	Paul Walmsley <pjw@kernel.org>,
	Vincent Chen <vincent.chen@sifive.com>,
	xieyongji@bytedance.com
Subject: [PATCH v3 3/5] iommu/riscv: Use the generic iommu page table
Date: Fri, 30 Jan 2026 20:00:43 -0400
Message-ID: <3-v3-9dbf0a72a51c+302-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v3-9dbf0a72a51c+302-iommu_pt_riscv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0067.prod.exchangelabs.com
 (2603:10b6:208:25::44) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH1PR12MB9672:EE_
X-MS-Office365-Filtering-Correlation-Id: f7318b05-e1e2-41af-91d5-08de605bc9cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Hm1Utlnaljt291/8Ubbs2A0xBFAyCc9Ll1mWH719KSxf79TEUd9HR8WxfvcD?=
 =?us-ascii?Q?364XODTjV3dEg8031KiQV8H0JIoqZG2kFhio87zKyDwOEyVWPAkU1XZaOgF4?=
 =?us-ascii?Q?mUC+y+5BaqR57532cW80wMKzlfWKVnP9ozKpppdAnMPy4fjNHQWcdJTEMuK+?=
 =?us-ascii?Q?BOhITHn2L9u+cPqJp5/5VzsDiqMA8UsWjH5yxgKS+WzuYhftvSJurg7DPGxp?=
 =?us-ascii?Q?U7fCxG5trihXIGRb7sugZUhjfj+b8dEyz7jXTEqcyi2XFN05tnzQNokpO8wM?=
 =?us-ascii?Q?ZT1AHiwUnVoFeHz09UqfS6yWA0uChUyccskZ8qL5NoCFsw0jeT+ppdWigsbW?=
 =?us-ascii?Q?i9lLm2DlhAFWk3zNQmYfSL2Z6m2Usy5jCKaU+tMhl4MGt9Pp67AmBF+UnImu?=
 =?us-ascii?Q?8vncqssWshreRRU+r32JuX+0jpqGcS36RSyPrHkaFWejVXY9gSkpBcCYhfXa?=
 =?us-ascii?Q?WeN3vyKtPnRk37TXLSf6C8W+OXnTpn9GOcYQjDSNPCLZqFSA3UrjN5TA9oZv?=
 =?us-ascii?Q?xJzARYBxRuA6RtwDg3h0ay6OjLu0ZkxuJYnVpqBo7QgcSp2hehKtS6GzlieS?=
 =?us-ascii?Q?ssGh9j3fODDs2QRR+PEU2ZIvaiYy2G0IbLfsyJ2xdobUMJnA0VTOYUgMcsoD?=
 =?us-ascii?Q?l54oMpU688GVlwYm8dnk4QYSwDjh/nOLrz3zgh3NkNzuD4/83Bul130hWaLN?=
 =?us-ascii?Q?V+bXf+Gcp08C0v0u/ExOexB2fUWqA5AgofAY5/X00xZCpAahDOe2aeJXJeCi?=
 =?us-ascii?Q?C8ivmHtcsyry4KZfKm5oPkq62tMR5WdPoDW+baC3k3f23Y9E450xNl+WGvND?=
 =?us-ascii?Q?zGJWDZ0cJTzcxyQLptaEcrDHuN85JMGto7Ok+6DOxg87So9TOrmK5hyf4lxS?=
 =?us-ascii?Q?oX/zTQKWDN5dtsNzT7wdimG2kbXiPbpNxKjIA/jsVW5MN/6a2jKAHdWX9pgY?=
 =?us-ascii?Q?DJhGVXR13Cj8SmTlE6bKtf+ODSzdo+Sd5LUXtR6t8sEeQjvohVTExwJkukeE?=
 =?us-ascii?Q?DvbKNB8dtcDES25sdnoy+OZKy4RPV/RAvst5rrN2rpC8WqsU+CJbHryMtEgx?=
 =?us-ascii?Q?jwshqllBji9Vx1tH6Grf7Z4UGK8wuZ1RxxdaA84K0ZQZ8T0iypLqutrkZqci?=
 =?us-ascii?Q?FWE00p+dvJR7Q3uPWV8gRWmEdcGqrieSW79islzV1ZsMkIYrC4ELDwbEocpk?=
 =?us-ascii?Q?YcG1dQc2YCyvxpQxKO5pHYXHAKTEaQQueufc2w437I1AQvsgnbqjM4Ss4qBG?=
 =?us-ascii?Q?S1AUjMxHaKOSZdoQt+hPvrRBjulHbsWsj3Ls0xv1KVv+Y6GV1esL2Kw+CmpC?=
 =?us-ascii?Q?GzD0oEyg2e+VdfXV1pO7tKJEeX4JLsTQ+QPL8ipFTnO6X4LUInPSnfkbCHkY?=
 =?us-ascii?Q?ppk+4spYh02ZbFTQI3jaOuBD4LTMq5IYln5uluhJD9aEvoUrnBhv2bw7QMbm?=
 =?us-ascii?Q?Vd0bEIT92ET2NNtyTRqSRTGbDk/iqNkDrzPOgUQVANiyBGb2NXyVAZYTaW76?=
 =?us-ascii?Q?IcqorR9MTiFlmYL7Yd/+Uzu8WipITqVaUEYV5/Lfn6AtOU3w8UA39DCbbWBV?=
 =?us-ascii?Q?g4qTXofcupEXhzjKv7Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9aNGVj98OuTyaxFl70vsiRb8jsKy3wYmaQHwcyiFFuO2MiIH6uxcH2nfxoht?=
 =?us-ascii?Q?ycwakwFrlD/4M7aVG+IC8ufWdRpGdDaW90F5smxdXOJ6OrQsnV6+KCGCmtSb?=
 =?us-ascii?Q?ivFL/naDNU2p3ZrcNAXouFcY8WpH3wx/OB3k2j9FEOc47wve1VV6G0EbSaAV?=
 =?us-ascii?Q?oXAg2Wxz6Tt55Jw1yKIwXyAGJFu6jHr/wlNZHMcU1zfxkp6mgIHAZOwjEbpt?=
 =?us-ascii?Q?b/msAJvIsA9qAqzObbGtPNChAOsF7Wq860oJU4eqDsVldqDERz7CctG41Owg?=
 =?us-ascii?Q?07ccVe1xOi4AZHcplYjBEqEVTJyiMkBUqva8CWbfyan496zlQec55XYr+jk4?=
 =?us-ascii?Q?mKnHBrFUsK7SE8A2UrNDOfFA7o3nHLnedvV7/PYoA79SMkOm20DvwYKw0S/9?=
 =?us-ascii?Q?ZhGVum80frtcrrJzbis2B9eWhkPFPX0KcHLNYkl3K4/tgBmdtQrr2s6sTEdL?=
 =?us-ascii?Q?zTX6KZbLL3MX2jkqBRKKf0NJoWA8BBAoSFDTf7jvNlyHrpEUOOScBripNDnw?=
 =?us-ascii?Q?vBkMkMU7Pl1rIpSIaYbeb/zG6Koe56RWGIAc/XC8xvLc67IrKQ/ps9r2GRcp?=
 =?us-ascii?Q?3ES9gme7rtGpeIh6WPwWYB4R1phl5WmS9Q8cSkWggSk5tnyUNxSuJ2TcvYhk?=
 =?us-ascii?Q?CDYHajK4e4BmVFiwLH1YGGK5g2D/NNJ0S0LSN4dOD5Tty+FdsCGW5WZnNDQp?=
 =?us-ascii?Q?mXpPOPVL/+Pdy+Uk538WCCchfQcdvT+BJ6jYveldB7MAGPQA1E3Z1WofeTnM?=
 =?us-ascii?Q?SuYu6hXNYCWNtGXVESANyCTtDNb28FX7S47ngKFNA0pB0cK34asGhcrBf9in?=
 =?us-ascii?Q?zACIgb4BwiYZud/ekdxJ4cCFPIFUgktUA/JQsKBZjUOvH7wXhv7GiDCtGqYa?=
 =?us-ascii?Q?JZq1gMnGR+xHyqRUCEJ+pTqjvJDFR3o6Zw9ULccZqQhGdt/8rQUwijunuQKi?=
 =?us-ascii?Q?BGf7shHiPEWqEb3MLfPuy+J02z4dX0ixYjaICvay0G86j+X2rm0YEhNdtxpO?=
 =?us-ascii?Q?A+EzRbzOrYf+zkRnT879JChA9v34o5e9jjvY0fy3uL2b7t5Bs7ZEFw9YNHPE?=
 =?us-ascii?Q?wK1yqO+TYamI2etbXu7Qy9KvX0WGu0YFyRxNEkBw3P+o2uW9mpi6OG6Kqo56?=
 =?us-ascii?Q?t2Re9Y77wE3mxtnLVHsWXAY+1VNjiP/SN57niKAnGnqFn31W501qT9IfHEhz?=
 =?us-ascii?Q?RxI1VjAZ/fsF+Vsh4rdXzmnTDls0LsXH9ZS3k8YRiyKoB9+URRN1CxrNwbvY?=
 =?us-ascii?Q?JkxZskFOrhTxc0QpIH3yUM3KlL14ZrgiuCkmfrsqSjdbXWyzQlC5Ys0VoY+D?=
 =?us-ascii?Q?TH3rKdvMwWxZQRiZVYExlQJrV44qcm0zVGIKqtc47/Jm6P8CEl4mHnsbH6s2?=
 =?us-ascii?Q?hUqWFjdPiCB4lcVhF1zSPDWM3Mwt2dYdTKhTx9yzbXw5nefH+Dkyk9P2M6Nb?=
 =?us-ascii?Q?lOrdOO5PXg7P1U7vo3j22whY4KLyq1U5BUXVhKnRm1YbzQYixLpqhvVRFjR8?=
 =?us-ascii?Q?Af6z9JRPyxfEpxgJnJVrW82L+CRmzPg9su141sQ9O8Fmn5QXNbJEOxe+9CET?=
 =?us-ascii?Q?+KmXms3yVe9Lkbtyu2PFAuTb/8eOpWhjcuBWc+BcVDeBv/6Sq6Gh0QQCSaSg?=
 =?us-ascii?Q?0KMhwnwGS0CyipLvmzkJkECRERIrfJ1PHd6lOxh2iD17JoaIjJOnRKxdwF9I?=
 =?us-ascii?Q?kHA/1iNAevidcHuxiI8wYRlvQbBLQUKqMnSovfhJlVG/XvFE9QNOZqn4KUXq?=
 =?us-ascii?Q?St8P37bZyQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7318b05-e1e2-41af-91d5-08de605bc9cb
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2026 00:00:47.9351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ycu0b+B4ksD4zuNu3WqjPY+sHaPw48DmUZ699e+QcrGmltDzFuPpj7aicn8kCgV2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9672

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
index f57a5b457076e0..c02878f00294b5 100644
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
 
 	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
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


Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012041.outbound.protection.outlook.com [52.101.48.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE083DA5A4;
	Fri, 10 Apr 2026 15:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775836640; cv=fail; b=Ic2iO5cwlPG14gpT3A0ggTYxC80+6b605ApSvEZ+crCzumMsHtvicO1rrUTu4Q+5wnYWcub0jLs8bMwWDBWZZ5gA/lKzUqAmmIUNNMnioG4Byg3/Uyz0G9H2Yp8HJs9BwwNzZi7/vSsxTgOVeuOxeixP9kvls+UB2l1rE5avVF8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775836640; c=relaxed/simple;
	bh=MviDPqjRdwShuZIyzuHFATirsnEo7qBQx9xmwHqfuYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rlDGJohllEWigOJMGk2T13z6ZyC8bau9Y4abmnm3g/A5FNDI2MJ4gp4w4e0b3f7zsCIhAp6Y9GX0T34DH5nBo1Soxc1VU1EQhqcUt8U+U1EVNjW0dV4lFFB0k/7HdyZCXVTiCu6E2sK9XK85J39Ziaqwmx9GlXBjc7sQX3Masrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nLsTFlFV; arc=fail smtp.client-ip=52.101.48.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nLsTFlFV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C+9KhDaucGET9D2pjR7FJI1pbgyzzsGE1ZfCNEhQuqYswpKeKDMbKlIvb1TJ3vycr/hWm7tMvT4QF2lOK/4VzispkhEZ+c8MTM5YmJBv03U2ipI5O3ZiRM+4l+3wFNDBg13tZIEPi4lu5mENRPl6LTL1BTQKKRuohmtdHQXgj1zScw5Izxq9nfvvnFBzG+soK1EKekuIR++zr2VYhzIC/WQuW3R6cuVACMx/08cQQPILbv6dnvdLqEs4yb12/TpSQpaKof1mX4mEZqCZVQSzwbkMcul3Mxg1PbwtGd+wABDUtWnryOTgGkeS0JPbZZtigkdw0iSXrK1TZl7+4GFnEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QhTW5ec7RapuqBkqrk41FRakteAf6FP1vzClw6aD+8k=;
 b=m3Ct1wZDKUJrfkJQgP45dGBwKa6sDqXIB3L6ARhlyf6IDeDQ9R2S5Sx6zdV1aVPuUFJxkG+7SI67r3LlVJhjfxV3FU25rv13YTT9tIYL8eWa41evsSgt85O46G0q2JiiXuSlxZvoS84a709U26zBnQN/VHqJlWgUf3HHlTTm4EvcQiM+iiW1pdzQ4+DK2+4ShXR+/2YOyJAp40zIbVfIBcIGzBg7ujsIQXItsHn5vwGNz6MdrOTaOtvloqMZVJlg43bZlJD6oupHgXQzm9Tx7A7S0LkjVpCZ1RfhRciHhjmGj5qsueesalan4JDaIS6W/LX62Ev2OHWgi1MRgY/NPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QhTW5ec7RapuqBkqrk41FRakteAf6FP1vzClw6aD+8k=;
 b=nLsTFlFVUZ31TsgdYTMEUIzRi6GpinjyuqAGxAbDMdlslWVnWZ4DHmsC737znp6DQ1P36wbn1dLeTtsIvwCH32/emsSEmLGDeGfnv+ahJ9HnojxJAVFaOXjqLnZFATyLVflOaaqXMDw+oVBwyIizx+v3WzpuCa2oD5BmPOzKgYgy3sGhXLGuUBcWcRXPiFcebs8H2mYICn1zKKKTjhD8fDtiUdgABuiTrc/+DGF8ofKy97meeoY9sju80WavU1PbxbiDwtzedbqEbMFNSESzizZJxq7Mqi5kuIdA04hQmSkxJkFHj/jdMqvvl4JGdHbe4Tq/+I4t7ZuWqD+71uxnHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ0PR12MB5674.namprd12.prod.outlook.com (2603:10b6:a03:42c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9791.33; Fri, 10 Apr
 2026 15:57:14 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9791.032; Fri, 10 Apr 2026
 15:57:14 +0000
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
Cc: Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	patches@lists.linux.dev
Subject: [PATCH 4/7] iommu/riscv: Enable PT_FEAT_DETAILED_GATHER and pass gather to iotlb_inval
Date: Fri, 10 Apr 2026 12:57:05 -0300
Message-ID: <4-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
In-Reply-To: <0-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0085.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ0PR12MB5674:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f350d8f-4710-4eb0-242a-08de9719d369
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zWcTKJTKHdOkSTNMtohyeHodsVdXPMaEuC9qIvS6SRiCfPWMSknei6r7OuGnR1q1Glol0WVcGWnB+Bq2e1BQgB9H2kOoTnKHg8113VB04B5toY7/Mmfw8PdSjBQBTH1i515qEI5M6I7ubJb7CvcLgd/JKwJVG0YEGZkDa6rQAmm0z5rSsPuGjnkNprQG27R5kmD0v5MsXn8GAArHkAPQz78Ke7hk92Y5UTttWqJvnnEDg0s2CHiynA1vHtSiA/dIPgi/KgBHr/sxTVtHwUwAfMegQcXJXIvH7KHxKfc9hMa/4Fbocy0uuA9rJj6ZnCPrpQIjZHelqk79MFLmfsscXypVNodhZDfcLA9L9O2kbU1u9uOwVTU8akftkgVycGiEA9xa4ecdEhqCpjWRaz4/9w48Lp3Q+ZsP+iYu8XviLNx8qYZsCceikJTD9JAhHv7prz/uQxfnBKUf2sz612ra1tkbSmb8OPjuwgaZZKGaKdJgSG9xqqwU/R1mCCA7fjCJGd13xWBXVaUVIey0RSa55HdbyAssYZ5l4lhUkBCYhCwIFNQsgU3w/Sg71i9cGQK86H9XbP7LCoMG2Ijp5e3UsHoraVOFnoYqt7+1Xf10Kr7Jq+XZ68OziclcM3d7an4gmCYrHuuy8QAjUQY+CbeRIKi71Miwq9SSwcY5afGNrFCW4JhYfCjeVN+zeBDuWY21WM1dCzOb1ZBK4klaoas/i+euISOAUUrECDW2ZP525SsTDEqR4C0c3FzFYhV5O6csCCB3RtY/qgiOHVf6iAb84A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JoI3cLyVTFiUmA4mJtke31xdhoVhvGps2fnOcrL2BDUdC82yvMQe61Gtc8mi?=
 =?us-ascii?Q?+rVYe6jFf815FQDYh4GH9jdsjFfBivO7kF5E1LhVnw1bfrUspVRKU9RQDkdP?=
 =?us-ascii?Q?sHIJuNKOCpbZVbDnjdSU1rHH6JaBkg3YW+NMQ2APTeGsTQ6ajQWcBFVQOvG6?=
 =?us-ascii?Q?HR3yaWsdTmfREEQoaQV5gXXQAW69fDPrsj5G8vTU+9i1P5p1ru6xqE0rUOAF?=
 =?us-ascii?Q?bIqY1Oho1zXdCOxG+PSybAIAOAZwjP08CGuZ3a/XsRDsBIB+bQPyYwSf1T8t?=
 =?us-ascii?Q?cvIqNdIkNiwlm1PgVCAFwKpHWZWiEdCIP15pBc9lIKggkpw7hKctqRCj5fAO?=
 =?us-ascii?Q?7qM6yOxizDgt1tPX6KhYgbygRtJjnBQQ5sxnYU4vvJxg5WlNV83Gx9duT/Uq?=
 =?us-ascii?Q?sLPi6aazlpMoZZ7Sr4pqBYyfB9d6S67Fl2VTBMmUzPYLykyTuH0TAY3bPH5/?=
 =?us-ascii?Q?yEIXIg7d3f0q6rrgUl5Iesb0FRl9YCvK/4k4ueQk2OowwcNmaxmSUXQEb2Ht?=
 =?us-ascii?Q?IVbHtC4je931rRZb48CFVV0n2DKnleLD50h/8MI8qgpmER+e2UCdmMbvfbgH?=
 =?us-ascii?Q?AXZwyjxBSqjm1f1+qvZ1VewhVrrrl8AqNNpfk0YdWPTTx990+vp9cQZ3oCrH?=
 =?us-ascii?Q?vRqmRtQL0RCMlg1/jSNY4CdMLOatEaVPAMJ2tilywCo9DXClUwqjgOVuoWro?=
 =?us-ascii?Q?AtJXD38NuBDndIOVkcvpUCX9ofQUjqQV3lVxRZ5vmaDkd/WBBO1T1zquTBny?=
 =?us-ascii?Q?bKQ0yo2oJWuLjKgGGvQ5wLs2aD1i+XDcc8DObeNvm/a2lGg1dgVHmzd99zus?=
 =?us-ascii?Q?JbyPJq0B/NphF4j5Ii2TEPw+/8quL7tK36Jql4xy3JPqAYKJlWdxbsXLz6Nv?=
 =?us-ascii?Q?VZ1t/ObBm4mgQ3NKil1yQ4OPdpqDGpaQll59du3jbYMcdUKj2Tqr93NouobY?=
 =?us-ascii?Q?IOYA3N/GBPZ5AWbexGgWZgvp08ZgqgWygr+HRZDsHInwfBPrn2B+nMM/5PHh?=
 =?us-ascii?Q?tJVKYv1bCKG+jWAzfUfzYYXisayelBWOrJgBHerLQFl44B/ehKvPe3hMu4aY?=
 =?us-ascii?Q?Ovbg7ckZU+7140ewTDZIH96SRwyCrIYbl58c3yYmfuOS5LfSmE99HIMe1ePw?=
 =?us-ascii?Q?hS7Rl654KfPFraUE6lJW0vj80KlxoM+v9DdY7ndFkrC3izoeHJvPl1dAWnpy?=
 =?us-ascii?Q?00LOKpVWMMSVgmzcqLZ4fhUStSZTh8Zvy4GZS/6XjjhkQjiCTpY/QBZAu/PZ?=
 =?us-ascii?Q?sGysDxl6xZOhdC4t45TEnAP40kKf8LnqRMgU18m0KWLzd5fDExeXD01UcqYg?=
 =?us-ascii?Q?PyT01h0cf5otiDRTolhrknU4D7UkOQSRKuH1XGpLJif7oAsS6hMvTim1CGiQ?=
 =?us-ascii?Q?uPBASflYRLBUQqDa6jyc8s6NbRMSjGqIQMu9CWJ9zAAI0e9Gw3DMqRSNVbSA?=
 =?us-ascii?Q?/yPiGHBK58+AqZMC0JfjekU+soHpApededmM4oz1957X2TTS4fRNlaiRQQi/?=
 =?us-ascii?Q?qEeBXb0/3l57FfPzST4+jIyNlWNAmCbWMdzd9T5fpqLaljMxO1GYtlbqle9e?=
 =?us-ascii?Q?GgD4aZI+8lfi75l6cfnlalSwsgjzsUbLbKDhZhAdRGYd+waP3EDVQ4U4QOO8?=
 =?us-ascii?Q?qFF7b7h14gYQoqWpBvY1q3ckox71VBmC2L1H5za3XXYOeYI5h+Iw6X9C06K9?=
 =?us-ascii?Q?lEEnM34EzvbuvWaz9U4m5z+U7OzhQ+btx3442bhbtICe3Y+S?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f350d8f-4710-4eb0-242a-08de9719d369
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 15:57:11.3617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U2oy/EhmzRH9w/Deq+wX5+w17mZggT28fb6+EcR/kZU/jlgsAC3ox2PoF0ckBgkq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5674

RISC-V can use the information from PT_FEAT_DETAILED_GATHER to
compute the best stride to generate the single TLB invalidations.

Pass the gather down to the lower functions and create a full-range
gather for the flush-all callback.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/fmt/iommu_riscv64.c |  4 +-
 drivers/iommu/riscv/iommu.c                  | 44 +++++++++++++-------
 2 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/generic_pt/fmt/iommu_riscv64.c b/drivers/iommu/generic_pt/fmt/iommu_riscv64.c
index cbf60fffa9bf7d..b18fc4d109f538 100644
--- a/drivers/iommu/generic_pt/fmt/iommu_riscv64.c
+++ b/drivers/iommu/generic_pt/fmt/iommu_riscv64.c
@@ -6,6 +6,8 @@
 #define PT_FMT_VARIANT 64
 #define PT_SUPPORTED_FEATURES                                  \
 	(BIT(PT_FEAT_SIGN_EXTEND) | BIT(PT_FEAT_FLUSH_RANGE) | \
-	 BIT(PT_FEAT_RISCV_SVNAPOT_64K))
+	 BIT(PT_FEAT_RISCV_SVNAPOT_64K) |                      \
+	 BIT(PT_FEAT_DETAILED_GATHER))
+#define PT_FORCE_ENABLED_FEATURES BIT(PT_FEAT_DETAILED_GATHER)
 
 #include "iommu_template.h"
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index a31f50bbad3535..556d5dc9c58681 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -929,12 +929,28 @@ static void riscv_iommu_bond_unlink(struct riscv_iommu_domain *domain,
 #define RISCV_IOMMU_IOTLB_INVAL_LIMIT	(2 << 20)
 
 static void riscv_iommu_iotlb_inval(struct riscv_iommu_domain *domain,
-				    unsigned long start, unsigned long end)
+				    struct iommu_iotlb_gather *gather)
 {
+	unsigned long start;
+	unsigned long end;
 	struct riscv_iommu_bond *bond;
 	struct riscv_iommu_device *iommu, *prev;
 	struct riscv_iommu_command cmd;
 
+	/*
+	 * When non-leaf page table entries were changed, the base spec
+	 * requires a full PSCID invalidation (AV=0) since there is no
+	 * way to do targeted non-leaf invalidation without the NL
+	 * extension. Force global invalidation to preserve correctness.
+	 */
+	if (gather->pt.table_levels_bitmap) {
+		start = 0;
+		end = ULONG_MAX;
+	} else {
+		start = gather->start;
+		end = gather->end;
+	}
+
 	/*
 	 * For each IOMMU linked with this protection domain (via bonds->dev),
 	 * an IOTLB invaliation command will be submitted and executed.
@@ -1145,8 +1161,14 @@ static void riscv_iommu_iodir_update(struct riscv_iommu_device *iommu,
 static void riscv_iommu_iotlb_flush_all(struct iommu_domain *iommu_domain)
 {
 	struct riscv_iommu_domain *domain = iommu_domain_to_riscv(iommu_domain);
+	struct iommu_iotlb_gather gather = {
+		.start = 0,
+		.end = ULONG_MAX,
+		.pt.leaf_levels_bitmap = 0xFF,
+		.pt.table_levels_bitmap = 0xFE,
+	};
 
-	riscv_iommu_iotlb_inval(domain, 0, ULONG_MAX);
+	riscv_iommu_iotlb_inval(domain, &gather);
 }
 
 static void riscv_iommu_iotlb_sync(struct iommu_domain *iommu_domain,
@@ -1154,19 +1176,8 @@ static void riscv_iommu_iotlb_sync(struct iommu_domain *iommu_domain,
 {
 	struct riscv_iommu_domain *domain = iommu_domain_to_riscv(iommu_domain);
 
-	if (iommu_pages_list_empty(&gather->freelist)) {
-		riscv_iommu_iotlb_inval(domain, gather->start, gather->end);
-	} else {
-		/*
-		 * In 1.0 spec version, the smallest scope we can use to
-		 * invalidate all levels of page table (i.e. leaf and non-leaf)
-		 * is an invalidate-all-PSCID IOTINVAL.VMA with AV=0.
-		 * This will be updated with hardware support for
-		 * capability.NL (non-leaf) IOTINVAL command.
-		 */
-		riscv_iommu_iotlb_inval(domain, 0, ULONG_MAX);
-		iommu_put_pages_list(&gather->freelist);
-	}
+	riscv_iommu_iotlb_inval(domain, gather);
+	iommu_put_pages_list(&gather->freelist);
 }
 
 static void riscv_iommu_free_paging_domain(struct iommu_domain *iommu_domain)
@@ -1267,7 +1278,8 @@ static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 	 */
 	cfg.common.features = BIT(PT_FEAT_SIGN_EXTEND) |
 			      BIT(PT_FEAT_FLUSH_RANGE) |
-			      BIT(PT_FEAT_RISCV_SVNAPOT_64K);
+			      BIT(PT_FEAT_RISCV_SVNAPOT_64K) |
+			      BIT(PT_FEAT_DETAILED_GATHER);
 	domain->riscvpt.iommu.nid = dev_to_node(iommu->dev);
 	domain->domain.ops = &riscv_iommu_paging_domain_ops;
 
-- 
2.43.0


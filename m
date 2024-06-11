Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F811C36;
	Tue, 11 Jun 2024 00:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065891; cv=fail; b=AMtWkrO0SfuGtLpzU8tJJOBz8B1YDoh7Ie6aJylECzOp+ivH80gYro07ZDE0W3m63BHUuMp/qxU911FFg4ybDoKerwappdaYFx+Of9aIVafsX8Ht94ht+EKMcekxVILptX134W26m/tuCXeqckferMGQPAtDwGEvU/a5fdeaFkM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065891; c=relaxed/simple;
	bh=Sbn7wbEitlINJfb1DiMaAA+pAY54y1zAYxIoMBg7NP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R1Fr48+zofzla1ZeK9aa9rxh1iV/ndN+q3V8AZ2M/wYJl+ZLJp4L+6VAY+isDvcePY2+aT1xktCvKjCL3kctU7OD/x0T1u5fKfvgL1zv/jNLr+5PKLcMtfFzhNVuMHft227zVS7piH+RE5g4wZdFCk4u79YY+m/kTt+8c55R6Mg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=q8KQrOyk; arc=fail smtp.client-ip=40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="q8KQrOyk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0lwEzPgk3Tvu5Hy8wtabZB5Ps7Og+8xaYU6WfgxZSSzyLATdHLLRvTVITIH1epEyZl3+H+hqMhncBVAAxYHyguadOyMSkPPBCVj8hvsyARdnlYgGE5aiFaZ0YL1JiGNjHBx4da3PSikFiBYRfX4twy+BgoNSuN1NgzT80uPNpjq3aVbVAoqdu5CKBFTJg7BWDehZO+MqkuhM2gcI+Fo/q4jFZfhd3/o+ZMexXtP6PQmpimPIej78OnUORB5amuo/TWiHmxcKys2oMpewswi/urclmJ4o7K+0haMOtOLhID7AJXBFoUxO+h3jx/m4DhUdhn5qSEiCXC/v/YsCxJtXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=homDZW2M0t+/h1BOLIM/SoSRrMIk55R0Qwdxz9cdE50=;
 b=QarZnH3eE0dK/7DoxTvLoXmYhD3xqnEiAI4tPCY2ifRS5KinlnRmG97yAau3gRVTefs4b7j+NYVYvpCAt4EylWLfVx8AhOc5O0eg7uLqpFVvp9gk7S+d6ObfGFve/mkyH0/has2efD6Jl0/8q4Q5ukaX+WYpOlm1JaQ1MCMkeyHItGsEYDy40u3vRPYImtQ2arrgSlt5gGWyw9AdG8OnhgCK75k1gr5Cb7RzL+/TK7hBaNmqgfrL5bK/S58uY1+kV5FBZXjpT3i0NpnEYD8j4iJ1/kTWNopUf4+TpU6YbWidN5CEGtmifHWc9oqSszrGUuESkLkxkLW2/6UdWY0z8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=homDZW2M0t+/h1BOLIM/SoSRrMIk55R0Qwdxz9cdE50=;
 b=q8KQrOykhFZyfS5phoJ/3KUpaymnzq6Qe4FmP9r9i/yDnrePVcBYwtPlCNS7V+/imObgLjp9MdGhvasNJM9Vd5d/AqB8azFI0vK8JTXjdttDkpNYUwwwLIWTxFNHZCOLwHLwwe9L/nSaqBZ4xQO0KQe9Jo7F776rU0uqivmEBaqV9RVKZRZq3/dXSGpdribHs3pbHotJxl2mJPCf2G12lwQ+q2zzdsBGYUgYC8fgNsKysn/C3OfZ6+YHofBUGrTyZDXDQQqGcnmuKVncP0+70gB0ThYV/lk/9a9M/ucLKYapHMu1K3Z5NGC2eAh1VVbNO0bIkq+a9kvrTfc9Bjri5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN6PR12MB8565.namprd12.prod.outlook.com (2603:10b6:208:47d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 00:31:24 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 00:31:24 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 08/10] iommu/arm-smmu-v3: Shrink the cdtab l1_desc array
Date: Mon, 10 Jun 2024 21:31:17 -0300
Message-ID: <8-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0430.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::15) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN6PR12MB8565:EE_
X-MS-Office365-Filtering-Correlation-Id: 40d4dae7-b0aa-4f69-b320-08dc89add15f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bijEDcsa+hteKbSqkUoxCpLkQe6vbjhUOOYnNIYaUQEes6Mf3ZMDgY4Mm028?=
 =?us-ascii?Q?cBMsbK7nEySXnhJqnwFsFZdtGrYD09W+iCpPlBY75CN8Usklu5N3q6lSr0vu?=
 =?us-ascii?Q?SiSeaBck1lUjYGTxlxICnt5/y0s/hzHeXX89dgqO4njBL8ZzyCqKxV0tJ+Ig?=
 =?us-ascii?Q?eVSQ4UPOMhWo4MeWX9bRSJLhlptGkxsiaz5qEmF51qA4R4RxMON2TiMR5QCb?=
 =?us-ascii?Q?XemSJdpJIdeOk1zN4IFQpsWhcm/t8ScJM6bPn1MVgqVwW/4yRyluKqblIVYU?=
 =?us-ascii?Q?VVzmJjPROiwzADvsgNsphozRaxyxR12ZZUZdTILNHLB2IAzDn1d4QMDlbdfU?=
 =?us-ascii?Q?6it9InYtK2+nt9F2RhNQMUB66qy16OC7rEIu0FnTgUcpiJoOn8RABnaL9Ahb?=
 =?us-ascii?Q?+4kc3ZrMoySuXqlE0IPHcWMKvHsAGMId1MUzd5+mi/HZkWxslPiGRKtQqRSM?=
 =?us-ascii?Q?s9txygQU7EkSzGeSDs3UmKjgZv08WPer8Thle/fsdlFQA/kuwDKfgeOafmtp?=
 =?us-ascii?Q?xgEMewO9geX4gjDfwtdlSNzg30SJKW0/YlgS/2i7/qQJYw52YKXGmn8FYMzP?=
 =?us-ascii?Q?GEKcK4ilOWOAMwcPIwjMXDT9kt9maEqlIZYqJcYbHyKufkHM/NGFQOArLg/V?=
 =?us-ascii?Q?U8hHN91z5Qj3P/TRRHEnXhOOjbHarw4gGBpIkTmwW4NCGQssonLBwHqi0BhY?=
 =?us-ascii?Q?2aEQEmrYUuTTeD1pTYWUtdyQyYOZTLdEeIwVWNFqH2omS5ao583eKlC9e3Pt?=
 =?us-ascii?Q?TOMvY7s9ip6JawhIwfBYFBQ0o1tYMPkQX4Ow8lqcNxl/BkJxWkSL9a7cPcWP?=
 =?us-ascii?Q?VSj3jPrstOWwtITJjgajbGUz/dtGWjCqNTP6pgceVS7QToJKKqGvkPdvqkDP?=
 =?us-ascii?Q?YBmovkZdRjXl5YOB8dB0h5uSJZ5XQ1oAPMJ56P1eSl0wRsjbKdTc2FzXYfxH?=
 =?us-ascii?Q?Fp1aVulOKANlkA6HEgD2tuLk3wF4xZQWrPki+xbP786yRTAK4eWGWviu9tid?=
 =?us-ascii?Q?kBDUAVqlKdQweCTkaXNHvo8xMHKWA8LBNpHmClXtn6xdj7v+XmkwxHk2wQTp?=
 =?us-ascii?Q?+kJX2v1K+gF08HTk2K1eBJSCj1uTvEAxMew4qLVbqZqWeDf7FsrQHBGXUBPh?=
 =?us-ascii?Q?iTgwnC0jOAd9A7Z67CZccvMvoWRcO1SAF2BExfnICeO2yzMBB1f7JO8v/CYY?=
 =?us-ascii?Q?ssOcoGbLsO4S7FzdX8W/aTgg/XLG5QJJsmgwvoiwj4aazrdvq4IomQQuvk/G?=
 =?us-ascii?Q?55cJ1dbPj5zQAfrki+WjzCsEKaaTYy2Gdu9AQOsaCMt5p/W5m07i21DPXIHg?=
 =?us-ascii?Q?DCE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s9m/fVOsX0KaiohT9kGJaWkDt3r02LMMy/pxvCp2OwHXwZiJHgRGYndFcpgK?=
 =?us-ascii?Q?ZT9DHCU+z8vU8rQmnSP+2wFORYbsW71fd4CFnK3OxNIFiQIYXe4Zqpk7UZk5?=
 =?us-ascii?Q?W+WXuHQpTrU7koagNtTHy/BShceTKc/gXR0TtFfAkjozmf4ED45M5LA9pZix?=
 =?us-ascii?Q?p4+esFIeIZVT0B6n3foihTd77Pd2QuUNoQOQBz6xG109zIn8OnETgS99nW2U?=
 =?us-ascii?Q?PmHqZfhuTUiqHpxZUYv8ImhA4x4RqLP1Z2FN0mD45h+oQ18NoQ4O//jNOily?=
 =?us-ascii?Q?NYtCUdfODhMcyqt0KM3koZbVxvcI6b50EiCegvZwH+RvB/CG1vFeCy9VlzA8?=
 =?us-ascii?Q?wmZpU1vBGm6JZCRysxkm3voEASvZY8qrHNL7s7BdA4NTxkg9pN++flBBITwI?=
 =?us-ascii?Q?gbM0KWQHOcxv/s0lV4WSFZjxC8Y7IE2STYx7o79DRXlJKulWQ+9RP+T429J1?=
 =?us-ascii?Q?sxNrTzlldHO9kyzeWUKBIuXDH8Rhdt7g2Eis4+yLIxADJrwWaHIS4nV31sF8?=
 =?us-ascii?Q?8mlY6i4oVAmzTY1RvHQTztyeR+nueWpjFyF1NY92EWGsD9tQxVW4BaTQN1Qj?=
 =?us-ascii?Q?VuMSrx+NXy7C/h/0SjMSzFMiN5XKCudW1ARE6ZxYlmh35QqSo9vDrMkexwia?=
 =?us-ascii?Q?GiIBWlsxVejfAejgg4KRTP/4p0J6utoSP9gILMMt4TftBz2Q9vCdHjI4ftng?=
 =?us-ascii?Q?pPer6qRUK7TXXsi4WmFtXN86YW5+oKu4UOiCJO00YidXm3nNBvG9eh7f8vsj?=
 =?us-ascii?Q?uJtT7bo3R9CQGEIV6kVDIn2VfjvGTHCHnH2pbkJn07ZUYwq8VHJVL+6omYCh?=
 =?us-ascii?Q?u3HU7u7ITpIBQ9vTJjWI8aNE2DrTIEupSzhJIAN1tu6BWqLMXBRlEtnfiZ6P?=
 =?us-ascii?Q?axgBRaWC9TIDecZSVu7R09olQSmLkSibG1Neu+oQNLjiCa2YnJZzkwRBRn/J?=
 =?us-ascii?Q?qtyE4IhgSHbfqwA5OTtKxr5SNZC0LVt5JTbrx44EKTdv2qWmQwHBwAvsd8zw?=
 =?us-ascii?Q?yukoxU6k5OFRzkuBq0KmCGtlzqZL+tmqB7LLtHXKIPl4tb0I0euXjdj8LJUw?=
 =?us-ascii?Q?K38D3kKlBIOKYRWE0b1HAy2pKWe2/bymV1TJskaOXoOLVgUPqjGDi1dTyP5Q?=
 =?us-ascii?Q?H35cFx5XBm2ozROLEmvjyfxsUUqDbZdZnVQKE1akrdRzH2tL1w6p7KMBexsu?=
 =?us-ascii?Q?uVTk5pdvZE1QuMncVYfmbVGOlH/KLX3Igj74w+i8yr11fWTUyMbGLTweTG+2?=
 =?us-ascii?Q?gN6jkouc5HKmXOBPYp3phpt0Hm40xqsb3llEsw8fBQBChbqk1adCobNTQgxk?=
 =?us-ascii?Q?PijXpJhNAUYusdYfRVGral2zr3uGzY9a4MG3T4TDzpVSI9VBsLM/q48SitrA?=
 =?us-ascii?Q?a4D0BFKU8im4Ff2E0TxvIEkjBYs0FqXuLGb97Sosp3plmnc2Jm83wVudHxFJ?=
 =?us-ascii?Q?VQVPJu0Evfcbj7DR8tViSne60ignbaWJLKPbWzMVoGNBlGo7kVS1ge8TDFJ9?=
 =?us-ascii?Q?UybxJe7jw6+CxaQ9ZJY0QzPMVtFeab+EfW2zKfzTjXopPmdOghLUfkx3g0CG?=
 =?us-ascii?Q?84R61A1W4gd6+tP2Wjs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40d4dae7-b0aa-4f69-b320-08dc89add15f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 00:31:21.5952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: URS46DxxPQiYF7gSY/tRRZjMIa8doHCMDWnRdUIoKJRQFPJXSJTUxkOIwbJnseUA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8565

The top of the 2 level CD table is (at most) 1024 entries big, and two
high order allocations are required. One of __le64 which is programmed
into the HW (8k) and one of struct arm_smmu_l1_ctx_desc which holds the
CPU pointer (16k).

There are two copies of the l2ptr_dma, one is stored in the struct
arm_smmu_l1_ctx_desc, and another is encoded in the __le64 for the HW to
use. Instead of storing two copies just decode the value from the __le64.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 41 +++++++++------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
 2 files changed, 17 insertions(+), 25 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 6245e2558e6a6a..dd65e27aebafd4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1167,31 +1167,19 @@ static void arm_smmu_sync_cd(struct arm_smmu_master *master,
 	arm_smmu_cmdq_batch_submit(smmu, &cmds);
 }
 
-static int arm_smmu_alloc_cd_leaf_table(struct arm_smmu_device *smmu,
-					struct arm_smmu_l1_ctx_desc *l1_desc)
+static void arm_smmu_write_cd_l1_desc(__le64 *dst, dma_addr_t l2ptr_dma)
 {
-	size_t size = CTXDESC_L2_ENTRIES * (CTXDESC_CD_DWORDS << 3);
-
-	l1_desc->l2ptr = dma_alloc_coherent(smmu->dev, size,
-					    &l1_desc->l2ptr_dma, GFP_KERNEL);
-	if (!l1_desc->l2ptr) {
-		dev_warn(smmu->dev,
-			 "failed to allocate context descriptor table\n");
-		return -ENOMEM;
-	}
-	return 0;
-}
-
-static void arm_smmu_write_cd_l1_desc(__le64 *dst,
-				      struct arm_smmu_l1_ctx_desc *l1_desc)
-{
-	u64 val = (l1_desc->l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) |
-		  CTXDESC_L1_DESC_V;
+	u64 val = (l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) | CTXDESC_L1_DESC_V;
 
 	/* The HW has 64 bit atomicity with stores to the L2 CD table */
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
+static dma_addr_t arm_smmu_cd_l1_get_desc(const __le64 *src)
+{
+	return le64_to_cpu(src) & CTXDESC_L1_DESC_L2PTR_MASK;
+}
+
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid)
 {
@@ -1231,13 +1219,17 @@ struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
 
 		l1_desc = &cd_table->l1_desc[idx];
 		if (!l1_desc->l2ptr) {
-			__le64 *l1ptr;
+			dma_addr_t l2ptr_dma;
 
-			if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
+			l1_desc->l2ptr = dma_alloc_coherent(
+				smmu->dev,
+				CTXDESC_L2_ENTRIES * sizeof(struct arm_smmu_cd),
+				&l2ptr_dma, GFP_KERNEL);
+			if (!l1_desc->l2ptr)
 				return NULL;
 
-			l1ptr = cd_table->cdtab + idx * CTXDESC_L1_DESC_DWORDS;
-			arm_smmu_write_cd_l1_desc(l1ptr, l1_desc);
+			arm_smmu_write_cd_l1_desc(&cd_table->cdtab[idx],
+						  l2ptr_dma);
 			/* An invalid L1CD can be cached */
 			arm_smmu_sync_cd(master, ssid, false);
 		}
@@ -1415,7 +1407,8 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 
 			dma_free_coherent(smmu->dev, size,
 					  cd_table->l1_desc[i].l2ptr,
-					  cd_table->l1_desc[i].l2ptr_dma);
+					  arm_smmu_cd_l1_get_desc(
+						  &cd_table->cdtab[i]));
 		}
 		kfree(cd_table->l1_desc);
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 3862f6e65c770e..2f7d70d92b1f31 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -603,7 +603,6 @@ struct arm_smmu_ctx_desc {
 
 struct arm_smmu_l1_ctx_desc {
 	struct arm_smmu_cd		*l2ptr;
-	dma_addr_t			l2ptr_dma;
 };
 
 struct arm_smmu_ctx_desc_cfg {
-- 
2.45.2


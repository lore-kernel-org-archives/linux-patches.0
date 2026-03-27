Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013045.outbound.protection.outlook.com [40.107.201.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA5F33436A;
	Fri, 27 Mar 2026 15:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774625057; cv=fail; b=Yk3k7QaVMGkSlslgs88CZLZnhrvayTdKzH6koZwkHTSJRTvz27xhzHKY7t/IJZbst7BDovWpj2s59Tv7Uxtsm35KqYPKfYFXSqFa4BRa7dWvzwXoFo8YREh8BEooTwvNVw+QHqa7vHma3eeTG+TLsRIdHbNKa/eY7QtR0YsCefc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774625057; c=relaxed/simple;
	bh=WOO+Vu+r6fOhGU5yXM5hujcHXK08dZOr+bv74ZS4wEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hz7b5m0TTpoHsKVIezj/mZI0UyU6maUu6FpvtfezIIZKgJPGpKArvIrqERIGPqK8kNpfq/ix6tSxiKY/69iIb37o5jyFTicdnZfK5AsOtBmoGrIsbVfjVMWGlJfHRQmb87bG04qfb5oInr1DjkDKCTs+Vx9qHWpNuCfiMBYeNXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FKfx7h+f; arc=fail smtp.client-ip=40.107.201.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FKfx7h+f"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bxXto6/SvIDNrnbEZ3/YDWw/Vf8FxOV4koMf1REoIcKjRovxqrH6NeNebDcMuf0HcoK0qGlVP36UezW88fd4x6Uwe7MuS+vKHcJZds/Fq0fbWi+jE1++eKi+4ECvaj9zqUHpJpawT9Srd4zIq/ubw1ID1uwWYMTtp/LClKIQcwwHHU2R8RxNuP1/04z9EOgwP2nke3KdjtLhfy3v1+ELe6GjDFOXvLA2A2/PaML8cq9ZLlw8hXYHIMzvxC1RnZO1m7B26qf5atYeej+HTvW3680ZQQNngDqCjf12JCgXCBfnUYHacJHZuBftRZHUl67/TVwROYAV3Qwm8kXbBSYUsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+8flRZCEN60NX4YLEbJHMS288oXTkknqVqDhHqH4iz4=;
 b=bK1x3MqzFrWdDiWpTFurzP2U8LwjFaFmTvBXpjdsGe0zSbhjpxrL2CTLq6XhkPFpulUjJnyZ27kL2Vxm2hWCfSSKWhic1sRLP2F7xdIfaOF2ROtNHKHFobyu3gUSSrMR7I+o2pv5KL2vMqKnWGJjZ+wBi3zjg5N7iUQfo6VYtJii/TJZdDsvxxOx9sbKQuKygdTVKNUjlwFTPjE/BTltc6Z9crkQ8aaz8MoIL5ZvUIKQY42KDiFo9KP8njjxDsup2PpmuqBtc8BG9ChVsrynmYKq4WD+HLkgD5/yib53wFunU0j54CHpA64ORB1OxKa5gGUw6ffHMOiBeBNkRnGK3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8flRZCEN60NX4YLEbJHMS288oXTkknqVqDhHqH4iz4=;
 b=FKfx7h+fnSeK86YjCtOzEZyDTLIv9bOPmMxTYim9vmX/1428TdoGw+gaiw+cT1hLEp70i/W3n43NGOqBgQr/VLO1JWyuTU+dNfO8P0/paf1hrnN1uC4jggqkPoo+yKPDsIV6Y//Rdv/kZw4kfeNUNk9Dvq7Q/XKD0aaZIIuik4gQJHy8Gpy2AXZkuRkArtcX6yFvqtC1VV4BGyrwSroZrQowIbq9oFjEUztDJAB+jTxn3NpbvI1IFgPUZyetIUBzcdmAslxfdvYzDULgaLXJRNLvVODFPmxgIE0CXMv4L/JLKOucsUOtKsGowsid73jfZJtk46FOAL8pr0GjpmZMcQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH8PR12MB7182.namprd12.prod.outlook.com (2603:10b6:510:229::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 15:24:03 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.006; Fri, 27 Mar 2026
 15:24:03 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH 5/5] iommu/amd: Control INVALIDATE_IOMMU_PAGES PDE from the gather
Date: Fri, 27 Mar 2026 12:23:59 -0300
Message-ID: <5-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
In-Reply-To: <0-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR11CA0014.namprd11.prod.outlook.com
 (2603:10b6:208:23b::19) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH8PR12MB7182:EE_
X-MS-Office365-Filtering-Correlation-Id: e0465d3f-b350-416d-6624-08de8c14e080
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	rlUFrHf/iI9g6oLoK/Y31N/pvzgOdjSFY8xzoogm5zCcatbXAAGAbcAyTXvURm2F+ayxCIw9myVvs2/Mv80VxnbEsBvA+a3IiUzkcnlGRbOw0VYstolhT4IpfEVf0ayoCxC2UVM5iq4qylPYO6fmRHnMkTDXOYVAjxpT13x+mZosD2882LszuIH7lKBkqPah2F7qCcKJ7a1l43jd/UfAApFkI0RoIhkEtBJ4Zbd7dczqpYBzg9lijp8ct6h2+bKIeQmCqY1rVpqf8HAZf/bHw0gWFeehEaKbMt9dU+CJo8eWoeRIxc7HojvIn9cB4wBsGe5YbuDkhUqDiUaW4oTdAoJCw5UH20sboDUY+l051AxzawCQJUF0kDtIHsyF8wKs3EBgO90o78nM/6pVWTmRtMU5rmjd+F4C6/QudVJFJk7zmypyonY/4WZXmrv3eT2g5JDG/et6isrw55uZ6mxZYNtxoKvaQrr5KQiE1iW1VE6Qhpl0PQY5ZoMO15YC/37DLy5CD2PHeVX2wP2hXj9WsyGFcoqh59XZGM5lF+fd36Tp1BZCz1wvAHUW4UE87ktk9yzioZqVwAxVSa4QxLJujwRtUOQA1kLek03X13TLWZZAta0r2+waQGwZPyHZyQdQdlpsT5jNz2BMufb/aldj3nbWOWy/BEI/MTL+sPWSI8fHXb9yrwq3m+YXSUwjmQ9g8k2inTfkiN/0nBl0LUA0WK7JKfFF1RtcqnrussU5+KU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HbHNRiCKGUFxEOZeOYru1TJASO7aEHLZqO9K2QXLIQV2e6XJ/22vhGLIv/aW?=
 =?us-ascii?Q?7fIpCgzoVtaiMDdAMwNS/N3kH3Xmv4wEsdIuEAXhd3Lh4Cyyz1DlNppm53MV?=
 =?us-ascii?Q?LemFpvruvs+T97Sidxzc1tGvCA9mTgi3n2YebfEx4rjCNeiRf2nM+C1J2Tq5?=
 =?us-ascii?Q?akjCJAFHc/fyF48RAIW+k6urLjwSQXLaW5cUu3+pwqlwNSYbEIKtyDhConvG?=
 =?us-ascii?Q?F9yR2sO2CNXW1ASus1Jdl/mHRzMNV0T0LGUnMpMVrDiHkFXD5dBcbhi9EVkB?=
 =?us-ascii?Q?SAdxOa1655kXR4dweb/+ETASRf9slh4xtpjkgYENwYXBfhJDh9zppMTVPjxk?=
 =?us-ascii?Q?0RvQeIUOYdA7Pt1CN9BMUTRWiThR7/Bn1NIQx/ZWtlLFGIJOCnEWppqq6mcp?=
 =?us-ascii?Q?EkM4CHDVy3KyeElR6GPWB/QRecALZrefFUNSq7+S5FQFeTgG1hJFGktqT7sU?=
 =?us-ascii?Q?0uw645WL1ugBkESTqef2UxO0Fi51np+BepWLQTanhfUgIJlw3qR8O3NzfROp?=
 =?us-ascii?Q?VHTIJzpTuWxC+RxpK+o++iYZXKw2mbLjTAGhzG3t5IYwq/c2EuoadljVx/F3?=
 =?us-ascii?Q?PV5AaB+Vs924Vb+Lly+dnfSvy9sLs9rsLHlaq1gaufyFsWyLO2mQY3VdhuzT?=
 =?us-ascii?Q?XP6ka/4xeE3hmxLkS9v0BC4CdYBU1aUftHqxTnw9GggIJD5hqZXt3btig3xt?=
 =?us-ascii?Q?IjwMjTV/O7XTdn3OvKzPcoa3Q6Sp6CCKNp/2to6qXPg/uwWBZZxit/nBRYWQ?=
 =?us-ascii?Q?XeSaKhVwR36TREo5Mk6N1/kbLRWvUKOTnxkt8idqRltQhaixm9jTpB7p42r3?=
 =?us-ascii?Q?iN261Li9oi+P0CMrBfGEh8xv1eYW6WAwOHs/hgeOyyP1Lp6anwTt8ToAQQZ/?=
 =?us-ascii?Q?KqN16JnNtuQP6huIF1/5AgLvc2Ii/qQeglO3+PZmSzvlBxDIsIZ2Hz544Tyh?=
 =?us-ascii?Q?65Ay/G6ynmRWXG3EI7s+IQ0orrnuu1l6a9NEUWaIhCMt7GZTCRlqxRLufh7B?=
 =?us-ascii?Q?AU01Um0KcRFBd9W4gRvybM7A34AVAQzU87cQFK2/EBoA3uZ+HJwMdyHs7u0L?=
 =?us-ascii?Q?4YQTar7zGTx7OgoGdCqcLWfDmMneFFjDtunh1aC95sYFZ76q6O1BFSbNA518?=
 =?us-ascii?Q?ZkupqmW+ImzeFBP3KwJlvNAuuKEO+FJxKycVykp3M6X31iB2DJYGGs0NW08X?=
 =?us-ascii?Q?dtWTvlqKY5Sxz3xwFmho4MAtiOTCw+hIqhp1M3ZU5LgNtpuInkLGVE0N2/sN?=
 =?us-ascii?Q?3r5HX926M8KK3JvZAcm9RGg5KQF0xndHb1cuUhLnfqx4zAppjyKz7DFdLLwR?=
 =?us-ascii?Q?eZPhH9uR+p4jRZDmgwUcoJBxUMCTdEngyjftNsWVtRjEtAIDJWE/3OK0N05S?=
 =?us-ascii?Q?LrePrTMTYYo7DDaB4xwomvIhb9Ufibk5ONeZLXaLNkTb8rr1pz5RbksKC8M6?=
 =?us-ascii?Q?nqhLCk5hKRTzzMIQGzvuRxosEqcpWAcqTBvbj6qIfPckXKxdrnKPe+GDVJY+?=
 =?us-ascii?Q?gwSoI1dH0qkv2ieL2ROcaCtr0oNXVO/3FwQDnNwvGQe9iP4LYxz9Sl8NwSRo?=
 =?us-ascii?Q?L2h6D1ek0mLxzHF2X30NCh7pY6fMR243ZWYAuiyagp56guo9op61+snWf6PH?=
 =?us-ascii?Q?bk5wazKk9PQ+ULj3v6ElNn1T1ZHINLkitVwQxzuSIBkx2dsB9mBrjc6l5cU2?=
 =?us-ascii?Q?Mqf72IOfmrXaw/v2pehO/B2MWYY8KV3gVnbtQKIDCPODtI5H?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0465d3f-b350-416d-6624-08de8c14e080
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:24:02.9649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W/q/GVLUhw/mf4Vh/mgW4gx2WJ5qMa6zdG5cAhH3I5IT50JLcCHcUrdlvFPi0jb0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7182

Now that AMD uses iommupt, it is easy to make use of the PDE bit. If
the gather has no free list then no page directory entries were
changed.

Pass GN/PDE through the invalidation call chain in a u32 flags field
that is OR'd into data[2] and set it properly from the gather.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu.h |  2 +-
 drivers/iommu/amd/iommu.c     | 61 +++++++++++++++++++----------------
 2 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 67d4daaaf6f0ce..364878a923edd0 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -88,7 +88,7 @@ int amd_iommu_complete_ppr(struct device *dev, u32 pasid, int status, int tag);
  */
 void amd_iommu_flush_all_caches(struct amd_iommu *iommu);
 void amd_iommu_domain_flush_pages(struct protection_domain *domain,
-				  u64 address, u64 last);
+				  u64 address, u64 last, u32 flags);
 void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
 				     ioasid_t pasid, u64 address, u64 last);
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 4e057fbc20021e..95f7dc6cf67eaf 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1301,8 +1301,8 @@ static inline u64 build_inv_address(u64 address, u64 last)
 }
 
 static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
-				  u64 last, u16 domid,
-				  ioasid_t pasid, bool gn)
+				  u64 last, u16 domid, ioasid_t pasid,
+				  u32 flags)
 {
 	u64 inv_address = build_inv_address(address, last);
 
@@ -1311,12 +1311,9 @@ static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
 	cmd->data[1] |= domid;
 	cmd->data[2]  = lower_32_bits(inv_address);
 	cmd->data[3]  = upper_32_bits(inv_address);
-	/* PDE bit - we want to flush everything, not only the PTEs */
-	cmd->data[2] |= CMD_INV_IOMMU_PAGES_PDE_MASK;
-	if (gn) {
+	cmd->data[2] |= flags;
+	if (flags & CMD_INV_IOMMU_PAGES_GN_MASK)
 		cmd->data[0] |= pasid;
-		cmd->data[2] |= CMD_INV_IOMMU_PAGES_GN_MASK;
-	}
 	CMD_SET_TYPE(cmd, CMD_INV_IOMMU_PAGES);
 }
 
@@ -1523,7 +1520,8 @@ static void amd_iommu_flush_tlb_all(struct amd_iommu *iommu)
 	for (dom_id = 0; dom_id <= last_bdf; ++dom_id) {
 		struct iommu_cmd cmd;
 		build_inv_iommu_pages(&cmd, 0, U64_MAX,
-				      dom_id, IOMMU_NO_PASID, false);
+				      dom_id, IOMMU_NO_PASID,
+				      CMD_INV_IOMMU_PAGES_PDE_MASK);
 		iommu_queue_command(iommu, &cmd);
 	}
 
@@ -1535,13 +1533,15 @@ static void amd_iommu_flush_tlb_domid(struct amd_iommu *iommu, u32 dom_id)
 	struct iommu_cmd cmd;
 
 	build_inv_iommu_pages(&cmd, 0, U64_MAX,
-			      dom_id, IOMMU_NO_PASID, false);
+			      dom_id, IOMMU_NO_PASID,
+			      CMD_INV_IOMMU_PAGES_PDE_MASK);
 	iommu_queue_command(iommu, &cmd);
 
 	iommu_completion_wait(iommu);
 }
 
-static int iommu_flush_pages_v1_hdom_ids(struct protection_domain *pdom, u64 address, u64 last)
+static int iommu_flush_pages_v1_hdom_ids(struct protection_domain *pdom,
+					 u64 address, u64 last, u32 flags)
 {
 	int ret = 0;
 	struct amd_iommu_viommu *aviommu;
@@ -1559,7 +1559,7 @@ static int iommu_flush_pages_v1_hdom_ids(struct protection_domain *pdom, u64 add
 			pr_debug("%s: iommu=%#x, hdom_id=%#x\n", __func__,
 				 iommu->devid, gdom_info->hdom_id);
 			build_inv_iommu_pages(&cmd, address, last, gdom_info->hdom_id,
-					      IOMMU_NO_PASID, false);
+					      IOMMU_NO_PASID, flags);
 			ret |= iommu_queue_command(iommu, &cmd);
 		}
 		xa_unlock(&aviommu->gdomid_array);
@@ -1674,7 +1674,7 @@ static int device_flush_dte(struct iommu_dev_data *dev_data)
 }
 
 static int domain_flush_pages_v2(struct protection_domain *pdom,
-				 u64 address, u64 last)
+				 u64 address, u64 last, u32 flags)
 {
 	struct iommu_dev_data *dev_data;
 	struct iommu_cmd cmd;
@@ -1685,8 +1685,9 @@ static int domain_flush_pages_v2(struct protection_domain *pdom,
 		struct amd_iommu *iommu = get_amd_iommu_from_dev(dev_data->dev);
 		u16 domid = dev_data->gcr3_info.domid;
 
-		build_inv_iommu_pages(&cmd, address, last,
-				      domid, IOMMU_NO_PASID, true);
+		build_inv_iommu_pages(&cmd, address, last, domid,
+				      IOMMU_NO_PASID,
+				      flags | CMD_INV_IOMMU_PAGES_GN_MASK);
 
 		ret |= iommu_queue_command(iommu, &cmd);
 	}
@@ -1695,7 +1696,7 @@ static int domain_flush_pages_v2(struct protection_domain *pdom,
 }
 
 static int domain_flush_pages_v1(struct protection_domain *pdom,
-				 u64 address, u64 last)
+				 u64 address, u64 last, u32 flags)
 {
 	struct pdom_iommu_info *pdom_iommu_info;
 	struct iommu_cmd cmd;
@@ -1705,7 +1706,7 @@ static int domain_flush_pages_v1(struct protection_domain *pdom,
 	lockdep_assert_held(&pdom->lock);
 
 	build_inv_iommu_pages(&cmd, address, last,
-			      pdom->id, IOMMU_NO_PASID, false);
+			      pdom->id, IOMMU_NO_PASID, flags);
 
 	xa_for_each(&pdom->iommu_array, i, pdom_iommu_info) {
 		/*
@@ -1724,7 +1725,7 @@ static int domain_flush_pages_v1(struct protection_domain *pdom,
 	 * See drivers/iommu/amd/nested.c: amd_iommu_alloc_domain_nested()
 	 */
 	if (!list_empty(&pdom->viommu_list))
-		ret |= iommu_flush_pages_v1_hdom_ids(pdom, address, last);
+		ret |= iommu_flush_pages_v1_hdom_ids(pdom, address, last, flags);
 
 	return ret;
 }
@@ -1734,7 +1735,7 @@ static int domain_flush_pages_v1(struct protection_domain *pdom,
  * It flushes range of PTEs of the domain.
  */
 static void __domain_flush_pages(struct protection_domain *domain,
-				 u64 address, u64 last)
+				 u64 address, u64 last, u32 flags)
 {
 	struct iommu_dev_data *dev_data;
 	int ret = 0;
@@ -1745,9 +1746,9 @@ static void __domain_flush_pages(struct protection_domain *domain,
 
 	if (pdom_is_v2_pgtbl_mode(domain)) {
 		gn = true;
-		ret = domain_flush_pages_v2(domain, address, last);
+		ret = domain_flush_pages_v2(domain, address, last, flags);
 	} else {
-		ret = domain_flush_pages_v1(domain, address, last);
+		ret = domain_flush_pages_v1(domain, address, last, flags);
 	}
 
 	list_for_each_entry(dev_data, &domain->dev_list, list) {
@@ -1762,13 +1763,13 @@ static void __domain_flush_pages(struct protection_domain *domain,
 }
 
 void amd_iommu_domain_flush_pages(struct protection_domain *domain,
-				  u64 address, u64 last)
+				  u64 address, u64 last, u32 flags)
 {
 	lockdep_assert_held(&domain->lock);
 
 	if (likely(!amd_iommu_np_cache) ||
 	    unlikely(address == 0 && last == U64_MAX)) {
-		__domain_flush_pages(domain, address, last);
+		__domain_flush_pages(domain, address, last, flags);
 
 		/* Wait until IOMMU TLB and all device IOTLB flushes are complete */
 		domain_flush_complete(domain);
@@ -1794,7 +1795,7 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 			sz_lg2 = min_t(unsigned int, sz_lg2, __ffs64(address));
 
 		flush_last = address + (1ULL << sz_lg2) - 1;
-		__domain_flush_pages(domain, address, flush_last);
+		__domain_flush_pages(domain, address, flush_last, flags);
 		if (check_add_overflow(flush_last, 1, &address))
 			break;
 	}
@@ -1806,7 +1807,8 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 /* Flush the whole IO/TLB for a given protection domain - including PDE */
 static void amd_iommu_domain_flush_all(struct protection_domain *domain)
 {
-	amd_iommu_domain_flush_pages(domain, 0, U64_MAX);
+	amd_iommu_domain_flush_pages(domain, 0, U64_MAX,
+				     CMD_INV_IOMMU_PAGES_PDE_MASK);
 }
 
 void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
@@ -1816,7 +1818,9 @@ void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
 	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev_data->dev);
 
 	build_inv_iommu_pages(&cmd, address, last,
-			      dev_data->gcr3_info.domid, pasid, true);
+			      dev_data->gcr3_info.domid, pasid,
+			      CMD_INV_IOMMU_PAGES_GN_MASK |
+			      CMD_INV_IOMMU_PAGES_PDE_MASK);
 	iommu_queue_command(iommu, &cmd);
 
 	if (dev_data->ats_enabled)
@@ -2606,7 +2610,8 @@ static int amd_iommu_iotlb_sync_map(struct iommu_domain *dom,
 		return 0;
 
 	spin_lock_irqsave(&domain->lock, flags);
-	amd_iommu_domain_flush_pages(domain, iova, iova + size - 1);
+	amd_iommu_domain_flush_pages(domain, iova, iova + size - 1,
+				     CMD_INV_IOMMU_PAGES_PDE_MASK);
 	spin_unlock_irqrestore(&domain->lock, flags);
 	return 0;
 }
@@ -2628,7 +2633,9 @@ static void amd_iommu_iotlb_sync(struct iommu_domain *domain,
 	unsigned long flags;
 
 	spin_lock_irqsave(&dom->lock, flags);
-	amd_iommu_domain_flush_pages(dom, gather->start, gather->end);
+	amd_iommu_domain_flush_pages(dom, gather->start, gather->end,
+				     iommu_pages_list_empty(&gather->freelist) ?
+				     0 : CMD_INV_IOMMU_PAGES_PDE_MASK);
 	spin_unlock_irqrestore(&dom->lock, flags);
 	iommu_put_pages_list(&gather->freelist);
 }
-- 
2.43.0


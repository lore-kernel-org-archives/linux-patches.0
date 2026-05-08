Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010047.outbound.protection.outlook.com [40.93.198.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BC03F6609;
	Fri,  8 May 2026 14:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778252004; cv=fail; b=QtKh9x03/aKYN9RaLs7jZ6oz7TSHEAiL2ndms3rdwV9ep1RgEkfmSRfYkDWB4WuLSdOTdsjhvmpQYnz9IZAiby69tieq3iJUsekWhngJNSCeXUDQHGDYV1da7BCju3u1srbvdE6Lu3HX50bFb+2hULF6/myYrUdbXKbmqj77sKU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778252004; c=relaxed/simple;
	bh=Jd4GE2/jVM9K2XF/fP9I3K+XIc3I9b/bx4mRyiOBhwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Er/AIiNiNNsrV2ir+89Y3dNs2iftZ+yAaEwkOolVIPltuHAY6oVH4xdjA6jijT+GPnrt4F+WJwOhrJGo7Wz9cL0L8yzB/4n2dndcAKp44hBvu3r567ZywSgBxDpCXaqhn6JpkaJ8nD21c2ymHt+nF2ci+cIxRKVnMLgOhdhqCvU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HWNRxZhL; arc=fail smtp.client-ip=40.93.198.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HWNRxZhL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TmUIhjDlj4Gc7qNUFWVTB4MMboqFXtjejML8BVIejp0LyFA/L4mNNRd78aRAUhrNKnXE+trPvXhqY13Fd+XNmqXD/qZXpXVFYp/2OlHKkh9g4qtSrrGzB+PhNbGVvbCXqxnjZ93oJBmGjzf0Xpwoo3pKgM9TNOj1Grvc3hZreUUUY9wWaHnwiJ/VuKGqrMbTeZA9c+ODoUUckTP9R2g3JA9yQPUa8sFqNla+tPbRB1Nc+WFFC6z6u1o2SzZPqNqCOnqwDe8/SU3WFVONHwhryaXUrEPIJndQwYDa18SRDQoDvQcyP12tEizxFiKGiS9yDgCJDo9uyp4zcN2duRuU/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AGvOzuDqgEM0C3XM0omgX7/MAIf6dmX2qdaLaj9aaUg=;
 b=bKoqcLyxhVdOgruL1Wc+uMyq4OxGNnAmv/xIbC3x0oUcGu1WOyGI0HXQYhMGzJ8vxNNlW8wwnZhtZ2KWL9TZL38rqRffheOnEXEZUWO1pP1sTkvIbGlLWuxSwHj70+oAuo7O6EjFt7oH2i38e9iz+GpPC41s+LCMxp1klCD083wo4CV273MFbkxo1qUAPLKDlQ5PIlUwuu7wi1lXJpLQbBC5jq4XSBoEwAJ9TTyl26TcUOk8fEzhqZEwlakAdyVtvwyVhzdOfTT+7nWOJ4WN8uBWq06x1BDeDTaaZbbCHCTUn2WdD6UdtyueJFCyyZG/NOGAUSEhZ3e92tm0XLnKaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AGvOzuDqgEM0C3XM0omgX7/MAIf6dmX2qdaLaj9aaUg=;
 b=HWNRxZhLnwCOWWGAQUJ6lfLByMNAKiO+YaOv4eQ/tTmDwrDwYHAdsGfhQLEbXUYmKarAwUZIo32QBGcokV2ngp8FLnW3wURd9fjz0FA84efL3sJ6r+xSnRB0qx8Xul/nCxnDRCVLOAP+sULbH/Ih5Mzj69R9ndyjVZ32AFTxdIiSH2S6W0eMWTqlARGkDEPInE1yC9COswLEfE8aT1K3THEAHrVTWpQkskTqNCesImZ5+Q55ya/+KR1GlgjlujUhFiw5jAno4yvKt+ro5J/KBlVfLBLXVx2cxUSbw3hP3zasqu/200eouI3HGjIqP02Kk8DWD2f+Wk7YMKHN0WVKRw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MN0PR12MB6224.namprd12.prod.outlook.com (2603:10b6:208:3c0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.20; Fri, 8 May
 2026 14:53:09 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9891.017; Fri, 8 May 2026
 14:53:09 +0000
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
Cc: Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 6/8] iommu/riscv: Add RISCV_IOMMU_CAPABILITIES_NL
Date: Fri,  8 May 2026 11:53:05 -0300
Message-ID: <6-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
In-Reply-To: <0-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0062.namprd04.prod.outlook.com
 (2603:10b6:408:ea::7) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MN0PR12MB6224:EE_
X-MS-Office365-Filtering-Correlation-Id: 499a1480-9654-4bdd-7376-08dead11854e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|921020|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	9371rciE6Zq6ZH1JlDngWe2neH8iEdXqQYo6b7nyt62odmbf3RDilYpAu9KRc+hlq5nwH/hk/Iip7PZPl7bZ7eHrk+MVH1UohuuvdnEYBmnwb6i80tqRtOOS+aJIPMBce6zKxQ8nUZfWcn9E6a0A0fbO4bhjx18x2SrtOeGvEE03l9TyiJOwHltIrzKbLtt51bcnEy1izDdf5t3aPkq3hgjh4CCg37n9AjY4AQhBrjF3kJZhN8/lq+ZcUzFMXN/KcCNs1rXYaDNjK0kyLMN/KmCqSeDZMM5Gwib7y+JvcwSKibEG7e1vj+TjByh3F7EUZ54j2qrJ/rtVmw6ZyM+u8PKGLHNEyys2S/1cl8Ey4I2NPfI/jUPZb+iSCJyX8/X9fQQiN8p55JYGzNd+S1S/DEGQbN9pPA4MT77PjUdzNZL2Cu5I5OPebVR8dMbqyrkzlfl76yXLQYEdaZeKXZLSiXRGfMs3Y7VByC8hQR6f3190zWHuJMpcDJK/BXh3ojcbgEvmcFWD/RbShbn7yf7jsAp5KTbXBTvDLNzu8S7yKHIAzJdjHnAwMXZm+2J0pTSV91hAT4DGhgCaXd9r8cAz4KtQNyqmDwnDRI+lY+Pd9RJqgh07VoXLWg9unTSzVJPfUNKvMfCY4aKhAACbjTsmYaPmAefE+8WagUy6SYz9qjRnph/1tdA6QT9CcdhfceahTGf/ZLYG+zfo7+98AtJuPGMXiz27iR9bNJDP5hYO0Is=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(921020)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gCW0o8OnMwT5aSRd+mJkFb2e9ScsfeKbeVJmh8fGRvEZIoyd4VubMw2SwiSG?=
 =?us-ascii?Q?bNCtRaatTOgfvSqFGRoUKgWYB5ceJ83cY8zEEvnYjcnkUMqnbZmMc/4slgSZ?=
 =?us-ascii?Q?R/d7eZxZRPeD0bw+fUO85CkENz+kPQSKPckj2ZN6hJGQIobcg2sqsh0ls7oA?=
 =?us-ascii?Q?so9V1hiN/AGQpYfS3bYcfGlje8gEBMaRkP7bcVwZBMshmw/WLhrOLUvMYNES?=
 =?us-ascii?Q?GwoagWTWC4XTJ0b01uV68LbMmxmz4yJJ92BGDHNxS7RfmfgAq/DmHp3RmeIz?=
 =?us-ascii?Q?6mL+ZNDG5rm9m1g61ATEfiLMSUz1BdZ2AdCeJ9RvQUVP/XhitzuvUDhqxzdB?=
 =?us-ascii?Q?H82GNt9w0GAIFfOJwHVk5hqTiRv6QdNPC0U8rII8SV2sg4h6+YkgmrYN04vY?=
 =?us-ascii?Q?aSQqG2tpelApR7ymCBPQz5mcVFBtc7G1dyfkcJ1kTDOaZ1OQtCdyyEf7tC6x?=
 =?us-ascii?Q?+9Bs06UBP/b6adfkyLHpXMikjqGiiYV7R9bNRF10CP5k1EqRBDbF5SkEHRnd?=
 =?us-ascii?Q?9Mq6wXAI9Ql1wkcP3DiSRwddCmxP9SwYdUL3azbQvnVb/YwfdHxFeEA1VPCt?=
 =?us-ascii?Q?ZxwEYUezrd79wf4q8JcGqujYf34DXokh5YbjMeGMT5Jt2ejtcSZFb1FtK8xR?=
 =?us-ascii?Q?jSW93NUW1GQGTKtoQ2W17GGiBDJNKiCAb3RMmNHNb3cWigi8o4tofE85wKmS?=
 =?us-ascii?Q?V0Nf6hC4HORXXoTPSJeWB8LuvdBuuZ/RVUKkEZY+SXtdI61Z2MquM9sTP5Ar?=
 =?us-ascii?Q?gDQ2lAO0Ri8TgXFjT4LJXmywpAdn69SySp+vuVyXokkWs2ZgqJ+UtA0yF2rk?=
 =?us-ascii?Q?Y83sr8wezGgm14s2fZ6yvqfxlX1ujIJy6kzzqNPq5Up+fpYEhGts1C5ANqYF?=
 =?us-ascii?Q?fIGmTT1BPVUdxTSlpAbasBTvpD1coTXArI5nOLkCXh+VuMoGE2NM8R/zvfFg?=
 =?us-ascii?Q?vXpl3T4CCmfgFf0ra0Yuwy5qOKPajebdBxT9lAXZHYbZceDQBNKTxbevN2JK?=
 =?us-ascii?Q?VyZoUpCrXfKCetj6K8v/vNw+5Aui8nLnX2XpAC3cxb0IbwKWUYHyMlZTCDSH?=
 =?us-ascii?Q?k70vNH4ZjWq4L+N9TDPk6IkaPM8GiGGe+eNu1JMQlJdWL3OgP7X1N7GzQeN3?=
 =?us-ascii?Q?COzLss4n9DjdUI6IPvFPLPArMF6RDREdg/cHK1VNHTtHdfx3o3PhvwxvJJWK?=
 =?us-ascii?Q?2Lk/RzxDcJEbgMuZkeHiT7rnl99MrQROSVX+COl1ZK0V5d6fYe1Bwb3+uAUa?=
 =?us-ascii?Q?mIfVZz5R9Kb92tmLqwuE4Ke3OD3v9egCu7tEZsV9g2l4LHV39Usl/a8HKMg6?=
 =?us-ascii?Q?7gFUETJ2dv2px20mExegr4CR170FN9Gr3g/2eLeW6HMkRKkeStjM82lKn25h?=
 =?us-ascii?Q?mlUiiT3CGkfg5skCX2HauATg0ZNFbaVQ13q96eBJXtqbV0BKqCBrUBpEAhdQ?=
 =?us-ascii?Q?Ls2TlOlVZSJPRy5oCS9wioGEZhbVCGzlmVUaBVPXckiLTEt1X5ySFhfA4C6T?=
 =?us-ascii?Q?1wzBqgS+09g7uUDT7bbd7ClGEYaqjNGHUwEDSRxKg8l9Zq0ZJXlYblm4QO1w?=
 =?us-ascii?Q?qYMsUCFQEFeqwAfuuvPoTuhQmn1gKUZr4kxfVQ220ffO3GLU0hzb8p/2jjm2?=
 =?us-ascii?Q?JIADhFqzutKraiu0FTdT6TT9no5d1b2hBcv045G8/9sV7ZCn6SLBcPMkyzwp?=
 =?us-ascii?Q?URqAaMRs+6TbGd11ipZLL+BnGddDEv7AUZM60KC0CBLVyUY7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 499a1480-9654-4bdd-7376-08dead11854e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 14:53:09.7328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LAt9d7JsXrYWl00CT7+3LTKtslOdr7oqlX3lAnx+es3TTMisL2W5kejtrKXMZyci
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6224

Non-leaf invalidation allows the single invalidate command to also
clear the walk cache. If NL is available, set the NL bit if the
gather indicates tables have been changed. The stride is already
calculated properly.

Reviewed-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/iommu-bits.h |  7 +++++++
 drivers/iommu/riscv/iommu.c      | 12 +++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/riscv/iommu-bits.h b/drivers/iommu/riscv/iommu-bits.h
index 29a0040b1c32ea..f01b49ac815586 100644
--- a/drivers/iommu/riscv/iommu-bits.h
+++ b/drivers/iommu/riscv/iommu-bits.h
@@ -63,6 +63,7 @@
 #define RISCV_IOMMU_CAPABILITIES_PD8		BIT_ULL(38)
 #define RISCV_IOMMU_CAPABILITIES_PD17		BIT_ULL(39)
 #define RISCV_IOMMU_CAPABILITIES_PD20		BIT_ULL(40)
+#define RISCV_IOMMU_CAPABILITIES_NL		BIT_ULL(42)
 
 /**
  * enum riscv_iommu_igs_settings - Interrupt Generation Support Settings
@@ -473,6 +474,7 @@ struct riscv_iommu_command {
 #define RISCV_IOMMU_CMD_IOTINVAL_PSCV		BIT_ULL(32)
 #define RISCV_IOMMU_CMD_IOTINVAL_GV		BIT_ULL(33)
 #define RISCV_IOMMU_CMD_IOTINVAL_GSCID		GENMASK_ULL(59, 44)
+#define RISCV_IOMMU_CMD_IOTINVAL_NL		BIT_ULL(34)
 /* dword1[61:10] is the 4K-aligned page address */
 #define RISCV_IOMMU_CMD_IOTINVAL_ADDR		GENMASK_ULL(61, 10)
 
@@ -724,6 +726,11 @@ static inline void riscv_iommu_cmd_inval_set_addr(struct riscv_iommu_command *cm
 	cmd->dword0 |= RISCV_IOMMU_CMD_IOTINVAL_AV;
 }
 
+static inline void riscv_iommu_cmd_inval_set_nl(struct riscv_iommu_command *cmd)
+{
+	cmd->dword0 |= RISCV_IOMMU_CMD_IOTINVAL_NL;
+}
+
 static inline void riscv_iommu_cmd_inval_set_pscid(struct riscv_iommu_command *cmd,
 						   int pscid)
 {
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index fd9c5294dbc082..ea14630430451a 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -966,6 +966,8 @@ static void riscv_iommu_iotlb_inval_iommu(struct riscv_iommu_device *iommu,
 					  int pscid,
 					  struct riscv_iommu_tlbi *tlbi)
 {
+	bool use_nl = tlbi->non_leaf &&
+		      (iommu->caps & RISCV_IOMMU_CAPABILITIES_NL);
 	struct riscv_iommu_command cmd;
 	unsigned long iova;
 	unsigned int i;
@@ -974,17 +976,17 @@ static void riscv_iommu_iotlb_inval_iommu(struct riscv_iommu_device *iommu,
 	riscv_iommu_cmd_inval_set_pscid(&cmd, pscid);
 
 	/*
-	 * When non-leaf page table entries were changed, the base spec
-	 * requires a full PSCID invalidation (AV=0) since there is no
-	 * way to do targeted non-leaf invalidation without the NL
-	 * extension. Force global invalidation to preserve correctness.
+	 * If non-leaf entries were changed and the IOMMU doesn't
+	 * support NL, we must fall back to global invalidation (AV=0).
 	 */
-	if (tlbi->single.use_global || tlbi->non_leaf)
+	if (tlbi->single.use_global || (tlbi->non_leaf && !use_nl))
 		goto global;
 
 	iova = tlbi->start;
 	for (i = 0; i < tlbi->single.num; i++) {
 		riscv_iommu_cmd_inval_set_addr(&cmd, iova);
+		if (use_nl)
+			riscv_iommu_cmd_inval_set_nl(&cmd);
 		riscv_iommu_cmd_send(iommu, &cmd);
 		iova += 1ULL << tlbi->single.stride_lg2;
 	}
-- 
2.43.0


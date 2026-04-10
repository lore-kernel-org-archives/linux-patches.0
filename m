Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010029.outbound.protection.outlook.com [52.101.201.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62873DA5A6;
	Fri, 10 Apr 2026 15:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775836641; cv=fail; b=MfNQvlCGsf0eWsulXq10IYo39Gnc//G0rLLvNXx2urE0havUxD/HOCTnWebdvViekDNE2ggeFWRifwoPjIKhp+2XS4dKeB5rxoEvCWMss9YhqBcXtTE6QykwtMCsnZ/QnYvs7CXFBq/CDSesCkipophYDDtSnGlkupIW/4+A4VU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775836641; c=relaxed/simple;
	bh=xDhFVycP7uNdWw1ZRMGB1JL806SSNimxCUsbqIxpD5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nwjAz9An/W48cTr0WBBFmpDmxv7hvAkNDBBVyTlCoJWiWN+NhNoucuSO6h256ioZ9dMLtbifiln4jXYBMHe9OZrJx7d7guy1CjWTcAJgyC3ntYdJ+Au0MTv9+mGhqHI8rJL09z61OJK5vOMQQL0ut8wLT6nf3WFtIL46I8MHE2Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Mr+dvY6D; arc=fail smtp.client-ip=52.101.201.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Mr+dvY6D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CuUEiWzcBcY6u/6ru8uRbxca2ZpOKabeIc6U0S1slK1UhiVgWsD/5MTGT/p/U8ynzI5LWeCcFTaj9bn2WpsXwpCphDo0DeFnF9YoyKfBR2rwwQTTEt6HHymKKT1Y7tJUgoRnBudySeG+4wRnpyOsmCE02fouWmPEjhUiIjwYIAwkXoZtWNGcd4HCt2lPYko0VsgS+menCuDpUscYbs03HySf/cxqIjXps76eW8TYjSkkYsfsGU3D3q/T36JuNpyYzrIMrcisd+9oEmPOBcF95gI6m3zDUJpWclQh/Was3V/65PGqBqWTVY4Gy+HqJWE0TRYaTwA4M7HQNnSVo2JdZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u/EfpEYcOufuZ9RtsH3HheRL6Sey3XyJkY+Fxi15C4k=;
 b=R9GhCDQxloyzmpZPImbaBvTzBIGGw/1u3pvqchM55B9YHVc4JXiypXh200Cns5RDwClMGA8Kg8eo6lgt8jZTmWATIDQc5cLxxxcL/N/quMtAYXUXuh7FgXKBsXUik82eDDwVSA+OI2eaY537DwQmxVFpmUF9k3KQ78wtDluxBHf7tkCrkzYhyp5XqKjD/Iyvrh83IjHCTcd8p453ywx4J6V1Hz9bifDI6/qEGOaT8vKpEDAu2ukI42P3ixce3CMsylPDueMnyPSYra+/ij2MBmjPfoZEBTTJNFtb5h2KkSsbvDMQO9fy8FVB+orfMLdqFUHD+W7vUxK/vrl8CiGSJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/EfpEYcOufuZ9RtsH3HheRL6Sey3XyJkY+Fxi15C4k=;
 b=Mr+dvY6DM9IbOkgi3OJVWe3poHIUyqB9Cl30QzD2EzA2xe0z+AfxhvqMDs/q7wIFpQGH/QO+k1CdcJFtdE/1Hnkn15kJdkLdtIzzwa/OPFj7v90C9m8y1zmJDO6Ij0g43/znztbQvEMYtgzBGal44C/0J83ntrZngdEIWd/A+wW93leEc6CVnkVA9zz0ACoL1Ue5YIs5RoCKco19/j6wpOeXdpx74xKIm6AeN4PyFi6x2kxo9zSiu2SFRapTBiMkizkaEC9AtI8WLrYVD1WCusZvEufCt4ulunHCfz6H90lEYt8jWhEKroDBrs36/L8IBjYkmesXzrDFvXrSVXFSlQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MW4PR12MB7285.namprd12.prod.outlook.com (2603:10b6:303:22e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9791.34; Fri, 10 Apr
 2026 15:57:13 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9791.032; Fri, 10 Apr 2026
 15:57:12 +0000
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
Subject: [PATCH 7/7] iommu/riscv: Add NAPOT range invalidation support
Date: Fri, 10 Apr 2026 12:57:08 -0300
Message-ID: <7-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
In-Reply-To: <0-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0422.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::9) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MW4PR12MB7285:EE_
X-MS-Office365-Filtering-Correlation-Id: f18ea10a-c6ee-4aac-c572-08de9719d2cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	bWuuFu8hqNRu6fmSrqfRdkNBi0rvgUAJDH1yyFiQZ4RyxED1MLwvw+m7nWX/AQCjY7XwV3AHOGfNT8yqTFe7TtotxTvPKCTc9O80ywA52iTn+j+9Rh8f5PLTIwxuiBxVGc1W6aMknwDs8BSdjdT9BYvshZBvWAt0L83Rf2qva79CXhRqLU1jLbbf84AJWKjrlH3DhrbMPD+I3tsgJLQbU2EOqk4B06c/ksj5MibUhV3qLeeZlZEwEWOyOyO/XaSNr7xDcMYofFuin+6Dwxt5wRoXuPsrMsjw9mnBIa3javcgqt6aIFZ1kGzosGDLaXQMIdcOM/HBH09VmovWhHI1yoz98X0LsK3Pi77jOArn7sZrjpgE2cykhiMR7dXOJbuXlrS6+lZHDl6HAS5hfiQ7iPI4IJhsUTj1aehE5kdyD0TAMY+n2xmFJeh5jMowGZAGzcSo4vGm1rdsU7Mk3ZK10zIxV1r/HnPwcsjJ9qTviFQ3E4oNRWsBsKqSLkaxGceLxpWo9l7uOOFI1IuYazkhPpMcKcRTRY7UwAzhgGd0lKljDF2T0JpvT1Pfh4QNU1t0k2b5soQcaJ9yWlmDzvvYtVzjNbOge2Axz0QgXAyWpszBjuIhPUgLuegNwerT/9VFYfS3qQTd9Pxx2Q36jWrwpb8UVHkN6FSiNF4jUllqPFzvWbPtY2h2dvpOsRhbeG4RtkZ4XTHbAT3CvuGM8urlhWGtWkKJpZBhfD6x+5B1ehK5r9+p1i0hABM0SREkYYxls1rjgFOY74G5i9o5ZCuJrw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CO4rsAEyZCYyfQ6DTydTEBmqHqJ76ZQsGNrxsZyrT0Y2fHw5D9ZyrbuGK++j?=
 =?us-ascii?Q?NUeb4VIr7xpaAOabaYlQcRxpK5VyoNE7AXnwJTdwg+im6gzVMHNCL0bGU8Br?=
 =?us-ascii?Q?KwLb5kgLiCW6jyDks160Oktkoa1f1hQjWT0pPFbW7DCI6zelcYgypMaVG4uQ?=
 =?us-ascii?Q?n2A49jWgwKODJCQf0lAti2/mKMmdXttUjDdob5AVQFgiSMN6kBuQZyxlsX5d?=
 =?us-ascii?Q?A8Pxe+d1w/ec68XIiDstFG7RTz/0N9saEMGo40JyZCQzI6secyRe75jWVBqo?=
 =?us-ascii?Q?sRpxiD/Bg1ZSTFFCGJfAiygyhvfeRkrehknzbUdUMSleU4lhT2BwcpsjBOTv?=
 =?us-ascii?Q?zQ3lHgqNjMa16i8dBijoEzpreJRJxkzqqD2n3P2oj5sdysrdC6IWujReKz4w?=
 =?us-ascii?Q?e/wYK9ZjS0Tq+cLSiY1cFLt79hncjpI+MPytSf6WxZi3MRPU6r9PB/sPfY3D?=
 =?us-ascii?Q?y5ehIpxs97MtMTj8EVFmtl3kWzmLkGVczWv4TYav6f9u9W+Ww24GJ/cbJwev?=
 =?us-ascii?Q?trOjRiHr85D+CB7bHynhHsX4Bp2tarbjs0muoEUUEPiYG1Q/rvNpddJ2haHb?=
 =?us-ascii?Q?fqsVsA5QSka4rBZQNA66HkDw4qQaS7wPX3Diwh3iSs47Pn2M0mcO2vinqy2M?=
 =?us-ascii?Q?Mz97YodfLXs9EyWsiVK0cWFpClNbVd9ZY5cmGbNK8MwPFHF+eiQsglM4pUXd?=
 =?us-ascii?Q?cOi7gmFy5zWKqwqjQzvbE4PlCxvaj+yz18Rvo0MASO1TbKfElYP4u14nYx/a?=
 =?us-ascii?Q?ERL6p3tkh7Y3L0ktVh5qSMJz5AN+7myYL2pnJ/ohY9OrPyFDmAvcLMAvgncz?=
 =?us-ascii?Q?3NoQSqi4DhKQcueXS48gWc6Rm9C08H8CmCnfY+T7Xm/7Ke7NnOlEza+0uB+O?=
 =?us-ascii?Q?nu/SVzXLy9SCxz6J/S9fTvYpN518yW2yjanS/TdXAY//rwXuRGVT40eW1PiU?=
 =?us-ascii?Q?Pt0gHhdZ7NyFibWZW9jBPI1dz5G1hO8xPS3Fgcl6FWUVHlKgiPrmdU8EAcrZ?=
 =?us-ascii?Q?ywIWKxIg4okJBxeAPimbBpUTTMGQsUJZI0564GwiBowZsh+4ftvcB5/5Sgf8?=
 =?us-ascii?Q?9Xac7DHmYaYfxwQpyaAgnhr20dun+ksFsVs0JLNsoFBAW2RVR8hhfOC9s70e?=
 =?us-ascii?Q?Z7XAtjYnpNrwsQNzwNcu1Hc/XPTNWuz54dLUeocXj3H6L0gJY6RQO/wlXyno?=
 =?us-ascii?Q?jbbEa2+6va+h8Xgp9Ri7R3dx2e1rQ1XVzoL3qrLC/9AUo7PKf+MQ2C3R5/MR?=
 =?us-ascii?Q?IaCAqIkYUgCh1Jp2tmqzq9p65uvg18IHX8aksqTkCu9LgdmgjJBQ3I/V8rBp?=
 =?us-ascii?Q?05oLEt0koz0g1zqvMjbcYp20y93wIRQmECrJxCO/g0gRLt+Wm/FiO/5xe7TK?=
 =?us-ascii?Q?OwrSbmHtd6AsTuuwXpFujr3qLNDVPVWumcFR9ZnFSvx5ILABX+cV+pXNU5Dl?=
 =?us-ascii?Q?XNXFBYV331lSTDgXZYfjtwitw+/SeNm2t7M4CzKZa9ryBlvhLNTs1d7LGN43?=
 =?us-ascii?Q?39/aXAe1COAu6Kq+ncDWDBra0psm/Dqi+LWYJwqpxBUSWJ3u1ZCAGr2vuEHc?=
 =?us-ascii?Q?oJa1XqWzC1c/aAUjFyegT9OhbSBb8fOM1InbUGlgEo5c5RzJ2eNPG4l84vN2?=
 =?us-ascii?Q?vThyRy7ENgqxHVIX6KUwpPBhaJoYet5r0HawCsEY5pS1Gr8mVHi5wlfaBfTy?=
 =?us-ascii?Q?WUiIjWi67qkde4zXndxHtgoKBEuWVNCRgtHQUZxEcVTfr1Qh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f18ea10a-c6ee-4aac-c572-08de9719d2cb
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 15:57:10.5252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eLM7AeJEzIvBzQ6Yzpc28EBLofWjuYfYCtxAf6OuXLhTezu22SsQJVAABQ5EqlmR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7285

Use the RISC-V IOMMU Address Range Invalidation extension
(capabilities.S, spec section 9.3) to invalidate an IOVA range with
a single IOTINVAL.VMA command using NAPOT-encoded addressing.

One iommu_iotlb_gather maps to one NAPOT invalidation command. The
smallest power-of-two aligned range covering the gather is used since
over-invalidation is always safe.

S and NL seem to be orthogonal in the spec, so if NL is not
supported then global invalidation is probably always going to happen
as wiping a large range without a table change is not common.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/iommu-bits.h | 17 +++++++++++++
 drivers/iommu/riscv/iommu.c      | 43 +++++++++++++++++++++++++++-----
 2 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/riscv/iommu-bits.h b/drivers/iommu/riscv/iommu-bits.h
index f01b49ac815586..32b3ad3ac9ae59 100644
--- a/drivers/iommu/riscv/iommu-bits.h
+++ b/drivers/iommu/riscv/iommu-bits.h
@@ -64,6 +64,7 @@
 #define RISCV_IOMMU_CAPABILITIES_PD17		BIT_ULL(39)
 #define RISCV_IOMMU_CAPABILITIES_PD20		BIT_ULL(40)
 #define RISCV_IOMMU_CAPABILITIES_NL		BIT_ULL(42)
+#define RISCV_IOMMU_CAPABILITIES_S		BIT_ULL(43)
 
 /**
  * enum riscv_iommu_igs_settings - Interrupt Generation Support Settings
@@ -475,6 +476,7 @@ struct riscv_iommu_command {
 #define RISCV_IOMMU_CMD_IOTINVAL_GV		BIT_ULL(33)
 #define RISCV_IOMMU_CMD_IOTINVAL_GSCID		GENMASK_ULL(59, 44)
 #define RISCV_IOMMU_CMD_IOTINVAL_NL		BIT_ULL(34)
+#define RISCV_IOMMU_CMD_IOTINVAL_S		BIT_ULL(9)
 /* dword1[61:10] is the 4K-aligned page address */
 #define RISCV_IOMMU_CMD_IOTINVAL_ADDR		GENMASK_ULL(61, 10)
 
@@ -731,6 +733,21 @@ static inline void riscv_iommu_cmd_inval_set_nl(struct riscv_iommu_command *cmd)
 	cmd->dword0 |= RISCV_IOMMU_CMD_IOTINVAL_NL;
 }
 
+/*
+ * Set NAPOT-encoded address for range invalidation (S=1).
+ * sz_lg2: log2 of total range in bytes, must be >= 13 (8KiB, 2 pages).
+ * addr must be naturally aligned to 2^sz_lg2.
+ */
+static inline void riscv_iommu_cmd_inval_set_napot(
+	struct riscv_iommu_command *cmd, u64 addr, unsigned int sz_lg2)
+{
+	u64 pfn = addr >> 12;
+
+	pfn |= BIT_U64(sz_lg2 - 13) - 1;
+	cmd->dword1 = FIELD_PREP(RISCV_IOMMU_CMD_IOTINVAL_ADDR, pfn);
+	cmd->dword0 |= RISCV_IOMMU_CMD_IOTINVAL_AV | RISCV_IOMMU_CMD_IOTINVAL_S;
+}
+
 static inline void riscv_iommu_cmd_inval_set_pscid(struct riscv_iommu_command *cmd,
 						   int pscid)
 {
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index ea14630430451a..41e26e267a7fd6 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -929,6 +929,10 @@ struct riscv_iommu_tlbi {
 		u8 stride_lg2;
 		unsigned int num;
 	} single;
+	struct {
+		u8 sz_lg2;
+		u64 addr;
+	} range;
 };
 
 static void riscv_iommu_tlbi_calc(struct riscv_iommu_tlbi *tlbi,
@@ -945,9 +949,23 @@ static void riscv_iommu_tlbi_calc(struct riscv_iommu_tlbi *tlbi,
 	/* No level information available */
 	if (!combined) {
 		tlbi->single.use_global = true;
+		tlbi->range.sz_lg2 = 0;
 		return;
 	}
 
+	/*
+	 * Calculate the smallest NAPOT range containing [start, last].
+	 * NAPOT encoding requires a power-of-two sized, naturally aligned
+	 * range. Over-invalidation is always safe.
+	 */
+	tlbi->range.sz_lg2 = fls64(tlbi->start ^ tlbi->last);
+	if (unlikely(tlbi->range.sz_lg2 >= 64)) {
+		tlbi->single.use_global = true;
+		tlbi->range.sz_lg2 = 0;
+		return;
+	}
+	tlbi->range.addr = tlbi->start & ~(BIT_U64(tlbi->range.sz_lg2) - 1);
+
 	/*
 	 * Calculate stride from the lowest changed level. RISC-V uses 4KiB
 	 * granule with 9 bits per level.
@@ -969,7 +987,6 @@ static void riscv_iommu_iotlb_inval_iommu(struct riscv_iommu_device *iommu,
 	bool use_nl = tlbi->non_leaf &&
 		      (iommu->caps & RISCV_IOMMU_CAPABILITIES_NL);
 	struct riscv_iommu_command cmd;
-	unsigned long iova;
 	unsigned int i;
 
 	riscv_iommu_cmd_inval_vma(&cmd);
@@ -979,16 +996,30 @@ static void riscv_iommu_iotlb_inval_iommu(struct riscv_iommu_device *iommu,
 	 * If non-leaf entries were changed and the IOMMU doesn't
 	 * support NL, we must fall back to global invalidation (AV=0).
 	 */
-	if (tlbi->single.use_global || (tlbi->non_leaf && !use_nl))
+	if (tlbi->non_leaf && !use_nl)
 		goto global;
 
-	iova = tlbi->start;
-	for (i = 0; i < tlbi->single.num; i++) {
-		riscv_iommu_cmd_inval_set_addr(&cmd, iova);
+	if (iommu->caps & RISCV_IOMMU_CAPABILITIES_S &&
+	    tlbi->range.sz_lg2 >= 13) {
+		riscv_iommu_cmd_inval_set_napot(&cmd, tlbi->range.addr,
+						tlbi->range.sz_lg2);
 		if (use_nl)
 			riscv_iommu_cmd_inval_set_nl(&cmd);
 		riscv_iommu_cmd_send(iommu, &cmd);
-		iova += 1ULL << tlbi->single.stride_lg2;
+	} else {
+		unsigned long iova;
+
+		if (tlbi->single.use_global)
+			goto global;
+
+		iova = tlbi->start;
+		for (i = 0; i < tlbi->single.num; i++) {
+			riscv_iommu_cmd_inval_set_addr(&cmd, iova);
+			if (use_nl)
+				riscv_iommu_cmd_inval_set_nl(&cmd);
+			riscv_iommu_cmd_send(iommu, &cmd);
+			iova += 1ULL << tlbi->single.stride_lg2;
+		}
 	}
 	return;
 global:
-- 
2.43.0


Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013045.outbound.protection.outlook.com [40.107.201.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD3D32E12E;
	Fri, 27 Mar 2026 15:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774625055; cv=fail; b=LXs92e8HgFwhufw2sNthEJzampYzFGnucRcXS3Y4QAdkFdiQsAAZ4r7IHAzsiB3YZQkxZ/onn2uiJ/0Uy9yIDuM2GTxnXSmH+M/jOOk8Ames8pnMRufNYUYTbqEx7acn9wQw3rclSW69Ijt1cWk7k4ev2OExc2HPJaA8tK2u4Qw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774625055; c=relaxed/simple;
	bh=eLur69QIAQWTqlYPftyIS6NZgW/7I2eZb37tXOYC5VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sH7pGlNAcTfOINbEWKYejnt6io4to3JePkqVwmIZPANDQAJfWaU1vzwtOr+EhzPfpSW4LewFQtGoerDzwlwqIS87TV+Rm0UHxVOaSF9mnQZxvBgTpOKdYwmrbJeZQAFk15s3VsKK2kMh7VDARcYw/gGtAS/chO2SThD8jJbYKYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=t3c9/bnv; arc=fail smtp.client-ip=40.107.201.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="t3c9/bnv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ciSDDR9XCDIMpqJQpPRzHkhkKeqfP7kudhFZk2q6zUnxYcf+k4qO3ZR0caV9/XUTxXV3TV0+ftvtOV2MxHbbm92484QQdqDcAzlzyLJ6KtrDfcfIeZyH0GBiIA7MUu6t0eVdj9jUF/AxX6TRW6gcw8TSv54otqdSwBtoHV5RnHBJIYo2RB2ugem1eUWFxV2RYBgTJE/NCMLMgDsSfyczLx72K4cE6lDBZ6FNjbFr56Cz3KKMjYvSAZhh9peqUIu3+6e4KYzOZzTfV4QF/VEcvgVm3lfcxvKMVFnMbKhI4LnbwSnkxoR52l5xN5Hh0kaG92aorHDCdAgUidStS2NrOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=epiKXPlH7cJrZNqtubyvO9ZSAfO1HO8zFqBm/mmO9wY=;
 b=MIUq+/f2Y5+4ddkjT6yuQGjTiun0if4H8yXWYSsxD5b//D2nN4UisiVsesSTsXtL7ych82zMLJrOpIoQzjxl0CAyMOWjmGLwd4OE5KYe2N6SCmL+jkEOW9RTNTb3NYU2oSbcmurPaz1eYDbX8IuotfEWGaDC+nVttkxO+kRCQMLcjVzZY/DsnshEQVWNnwk1jJ9rGRIQLNyvP9mt3unq8te8VTKFDYTcPJPmPbc6yhtR3FURWxej5tsFoDdu4sIuS8TyTs0pQStB3BGWkGDhMgZFzUeR4iA6i55TQIQh5LMQY2kJkFUXJQLTkJVX6x3aRxUlUlWluKgp2S1vNGqWHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epiKXPlH7cJrZNqtubyvO9ZSAfO1HO8zFqBm/mmO9wY=;
 b=t3c9/bnvP2Tqi0nGsBBtb2urCLudsqMbsV/MQslYDRWIB5IlKFxz1KmdtOHI50dcchS/+vd3/PmS83q+EmdjlGhePh21IhgMMjjqoVaZf8MTpgTLzRM4wobC7nx+OTyAq+qs3f3l/OJwqk5cnJKY7kXGsXRssgk0wQG9fDPKJOC65rR/09vy4itd3syU3qNcv5X9upvYeVaGTKTc8aHeJnyxLHEbEZ4/Aacyx7lEwWNq0u4XrXEtRMPw8P4/uuUtFQIj5/m1gDMSzVaVYknI4xBj2kpKV9cegdCG+KQx0BXa5lk0xMHxHNLA0PATjU86w5y8t8YN12JOTdwlIkaWmA==
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
Subject: [PATCH 2/5] iommu/amd: Pass last in through to build_inv_address()
Date: Fri, 27 Mar 2026 12:23:56 -0300
Message-ID: <2-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
In-Reply-To: <0-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0040.prod.exchangelabs.com
 (2603:10b6:208:25::17) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH8PR12MB7182:EE_
X-MS-Office365-Filtering-Correlation-Id: 57126b82-6ea7-4c2e-c71b-08de8c14df8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003|22082099003|3613699012;
X-Microsoft-Antispam-Message-Info:
	CZ2gaDDmbmpS2GqGHsv234vr1JERFaR1sEsQJtUepmbhImLQjbrDNZNJ1Yp/xDaWxhZcgH2Wl2Hc4XPpxIRKO3JimDuYTFZaz5YSoZ1Vqt0JpIseZBZzofnMCw1j02/Tyqaxh3YhOYueJMCjQYmD11D0rlcygsLOe2QtQKY+hHAA9hk6p2xRdrQ25lUdNqr2dQTzI95o3sPw2bTIlJZfvPpvCS5aayd3T3HMR6XUBe9yyPd7hqPcx6rCPX8AFW9ichULe6kNjvb8+SB8u1ffEViTwnPj9Z6YdudU5tXpPCtxIv5wizU1yW+rTwVuBq8TZjxAwN2pCpd+kuy/P0Ps8t0wmTjoWkUcl2xszGFaisdgCaEvhbzRqnOrIakU5LdXH7iUP8Kw8mZrdYEIKld6vRvJpc4Iwq7riaOzQXHESWzJ+IkuHcfqv5QLkbjmWF6+KP/4MSvZMllOhlON0gF1UozA4tdNNGCEQi9tbHDlEv2XDD2LlcHrLBw93oALuxvsTKyeDg/rspgvFF1a+WwC+jPpeB4R1c1zO3wKhyK3eLdGXxNScnmGtgIeOMsKxvlifl3ScguLCUAB4wHueE9BpnNxovthm3AzAxqGBve2cZmd9SBBgoyk2VkwQQ96XxcNbBrufpU021JThC0hR4dzno6JwK6MaFL9CrKdGjCYi98Es2H+gJC+uFubZPiDNF9Ensr1BdQPNR9DYYUQY+JSmvIBHjnA4P79ILNWgx7g0x4ntm8hsGSztmpHg9UzXWWlh+gmZ96JqMv0Mivj7X+GAX4eMCqRrVf0+BavYJ16Dro=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003)(22082099003)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n8TKUIxY2bYFX7V3yIHcoG33qSglV8ri7w+4vnzvTYeRPLH6GmKeCdYu3FUN?=
 =?us-ascii?Q?hKnxbeYrWcQk/p62SFilFPnN+Nq+hhE5/hH4/praqEF/poqJ+2KMVjh9kkBF?=
 =?us-ascii?Q?BwcyCPh1M3ylt+2KnkWLrDvX+VtQByK4ow37qdKcu9H5aQwETBWXIBcReW8O?=
 =?us-ascii?Q?Z2cEXp1ZHO7/UGp8IYWsbNmWKGtPlpN39Nn1DT7lec1hfCJnvAHV60SwybIb?=
 =?us-ascii?Q?uhlt4foQ1+VQiGvE5BuXzhvhhoZnNJWtSfmiSgU257Tcd76KALkScfVCe+xT?=
 =?us-ascii?Q?4P0HqPRXYIyQE2VtcSOTKBblMEVogPY7oPSOPpadip7/Zlpu0c7lOAcis2BI?=
 =?us-ascii?Q?yiBxxX3XWtSDYdL0IrQBFkP1G8EpJlI3BjjabEPgGy3dcEXIh49PjQA5RzEN?=
 =?us-ascii?Q?w5DkqoYFY1DHfSEg1up6ZYNgAmmnRJnv2MMLIb/Ljv2a6LFhYJ8Q11w8r4n2?=
 =?us-ascii?Q?7CAC/UqtV13mIB6B9Mk1P4eSsx2R8XwzIojS4gShkIR8xWIx0M1m6iVN0oH6?=
 =?us-ascii?Q?t4rTFhDqi9vij/a4z4y4loUtpK1bfBQcAC1Ds+F/HJkthqO3hIPd+4oogX8W?=
 =?us-ascii?Q?VA2LW6dr2AkTIKBN+4zDesOWgWvtiTalNpqdFPOJyGthK/TevKpVUeF1bIfa?=
 =?us-ascii?Q?Pq5XgkI7u799OvVQoXJCuf4aKP/zjGtS/emGGgAZe0Bc3Sna/TH3HoP7nm3c?=
 =?us-ascii?Q?jw3CO7EELHciY9mzJmPeLs3EBn0WMcIj57ob5IJ/8eaeKWRaxrfn8HQi97/m?=
 =?us-ascii?Q?3R6qIcGgKAn8PGRCbxJU6vm+z+QR0VejXkj+xxxXNgUeGwmtKl/6auZkMIB6?=
 =?us-ascii?Q?kcHj5gWboMVvxn+tMucpRJGsxsoS97jDeiBLCNHp5JVuxIRCf75oXoBMieO4?=
 =?us-ascii?Q?BXmH8cX5xnLS8ANHwDAmyYCdpkinhQnHTHkF4WjYfjIpEO3ziZFluyYXrG7W?=
 =?us-ascii?Q?5w+p5XMPNhQ3VM34TSr+oYEfujHreSv1HA6j3lE7lGBDz32xtpJFAmqMqjkQ?=
 =?us-ascii?Q?nbrfDF0r/Cyr0bO68lki8XYebICbXfPBT/20OLkMQBCUf5ZSCG9MqqBSJcbG?=
 =?us-ascii?Q?4zxtowoedR+ivM1dixBxlLGh0k+6fioMmzjDfP6D1RkV0Bmn8zZORNcw1CnG?=
 =?us-ascii?Q?w731ew4cwEXMIg/2ftKWLUMXm7XKx8+XOOuUs808YsdcqQRASeeAipjQRB7Z?=
 =?us-ascii?Q?MGro3lz5tzErdV7srzNTkCH+TMt2w6TXxNx65CBG8dUXw7Fxl309E58oHXnw?=
 =?us-ascii?Q?Sq7H0qybQxSxfFB74ckIrDtzL9Q3XAvQxk0o7Ty2o99V7tF+Y3qPwnk4Omfp?=
 =?us-ascii?Q?OOFbjqvJAjwziIEOsAzvgJUKjSpYxFVt4ceQjfk/A+rTsx0nn6MQBjB+P0xz?=
 =?us-ascii?Q?Q292ScUEjcPLSsKDBSsQLkgfxGSrMQGBi/MGPOabaYFhtGTeogRWU6d2kC3l?=
 =?us-ascii?Q?kNJ1hJyYXaOQE+n6XZcYaHsySIEBZKu0n7828RLZ92ADl965RPycV6YHDWN0?=
 =?us-ascii?Q?OESJGIZ6q7q6S6gwfVyAKTkX2oq1HyOr04mP6Ts07OEwJZHEXe/AJeJ/ogEr?=
 =?us-ascii?Q?5FpNs4tWi8/YD4TiEN1qK06IfoJBcvGvFyZpBoUtecajsW5J+MjGxyvfYLtb?=
 =?us-ascii?Q?pdX7p08o9EVxzirsdHbXSLVHwvhz5lvHrvFLd3tVI/irNnhjZW2jdhXPreS3?=
 =?us-ascii?Q?0+ieKyl8eZHe3olHyitoE6zst2aSiILkHsjhJZkdrB8Rxjtp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57126b82-6ea7-4c2e-c71b-08de8c14df8f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:24:01.4136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KlTrrmIHC5nl0QtjnumH5BWHl7BpIAeg4Nx/CAgAFqEbCFLqAnclmT+vqkTYWB4m
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7182

This is the trivial call chain below amd_iommu_domain_flush_pages().

Cases that are doing a full invalidate will pass a last of U64_MAX.

This avoids converting between size and last, and type confusion with
size_t, unsigned long and u64 all being used in different places along
the driver's invalidation path. Consistently use u64 in the internals.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu.h |  2 +-
 drivers/iommu/amd/iommu.c     | 56 +++++++++++++++++------------------
 drivers/iommu/amd/pasid.c     |  2 +-
 3 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 1342e764a5486d..ef4ebecb003494 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -90,7 +90,7 @@ void amd_iommu_flush_all_caches(struct amd_iommu *iommu);
 void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 				  u64 address, size_t size);
 void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
-				     ioasid_t pasid, u64 address, size_t size);
+				     ioasid_t pasid, u64 address, u64 last);
 
 #ifdef CONFIG_IRQ_REMAP
 int amd_iommu_create_irq_domain(struct amd_iommu *iommu);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 28308759bb3e4d..caab941b531bfe 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1265,9 +1265,8 @@ static void build_inv_dte(struct iommu_cmd *cmd, u16 devid)
  * Builds an invalidation address which is suitable for one page or multiple
  * pages. Sets the size bit (S) as needed is more than one page is flushed.
  */
-static inline u64 build_inv_address(u64 address, size_t size)
+static inline u64 build_inv_address(u64 address, u64 last)
 {
-	u64 last = address + size - 1;
 	unsigned int sz_lg2;
 
 	address &= GENMASK_U64(63, 12);
@@ -1302,10 +1301,10 @@ static inline u64 build_inv_address(u64 address, size_t size)
 }
 
 static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
-				  size_t size, u16 domid,
+				  u64 last, u16 domid,
 				  ioasid_t pasid, bool gn)
 {
-	u64 inv_address = build_inv_address(address, size);
+	u64 inv_address = build_inv_address(address, last);
 
 	memset(cmd, 0, sizeof(*cmd));
 
@@ -1322,10 +1321,10 @@ static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
 }
 
 static void build_inv_iotlb_pages(struct iommu_cmd *cmd, u16 devid, int qdep,
-				  u64 address, size_t size,
+				  u64 address, u64 last,
 				  ioasid_t pasid, bool gn)
 {
-	u64 inv_address = build_inv_address(address, size);
+	u64 inv_address = build_inv_address(address, last);
 
 	memset(cmd, 0, sizeof(*cmd));
 
@@ -1523,7 +1522,7 @@ static void amd_iommu_flush_tlb_all(struct amd_iommu *iommu)
 
 	for (dom_id = 0; dom_id <= last_bdf; ++dom_id) {
 		struct iommu_cmd cmd;
-		build_inv_iommu_pages(&cmd, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
+		build_inv_iommu_pages(&cmd, 0, U64_MAX,
 				      dom_id, IOMMU_NO_PASID, false);
 		iommu_queue_command(iommu, &cmd);
 	}
@@ -1535,14 +1534,14 @@ static void amd_iommu_flush_tlb_domid(struct amd_iommu *iommu, u32 dom_id)
 {
 	struct iommu_cmd cmd;
 
-	build_inv_iommu_pages(&cmd, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
+	build_inv_iommu_pages(&cmd, 0, U64_MAX,
 			      dom_id, IOMMU_NO_PASID, false);
 	iommu_queue_command(iommu, &cmd);
 
 	iommu_completion_wait(iommu);
 }
 
-static int iommu_flush_pages_v1_hdom_ids(struct protection_domain *pdom, u64 address, size_t size)
+static int iommu_flush_pages_v1_hdom_ids(struct protection_domain *pdom, u64 address, u64 last)
 {
 	int ret = 0;
 	struct amd_iommu_viommu *aviommu;
@@ -1559,7 +1558,7 @@ static int iommu_flush_pages_v1_hdom_ids(struct protection_domain *pdom, u64 add
 
 			pr_debug("%s: iommu=%#x, hdom_id=%#x\n", __func__,
 				 iommu->devid, gdom_info->hdom_id);
-			build_inv_iommu_pages(&cmd, address, size, gdom_info->hdom_id,
+			build_inv_iommu_pages(&cmd, address, last, gdom_info->hdom_id,
 					      IOMMU_NO_PASID, false);
 			ret |= iommu_queue_command(iommu, &cmd);
 		}
@@ -1616,14 +1615,14 @@ void amd_iommu_flush_all_caches(struct amd_iommu *iommu)
  * Command send function for flushing on-device TLB
  */
 static int device_flush_iotlb(struct iommu_dev_data *dev_data, u64 address,
-			      size_t size, ioasid_t pasid, bool gn)
+			      u64 last, ioasid_t pasid, bool gn)
 {
 	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
 	struct iommu_cmd cmd;
 	int qdep = dev_data->ats_qdep;
 
 	build_inv_iotlb_pages(&cmd, dev_data->devid, qdep, address,
-			      size, pasid, gn);
+			      last, pasid, gn);
 
 	return iommu_queue_command(iommu, &cmd);
 }
@@ -1667,7 +1666,7 @@ static int device_flush_dte(struct iommu_dev_data *dev_data)
 
 	if (dev_data->ats_enabled) {
 		/* Invalidate the entire contents of an IOTLB */
-		ret = device_flush_iotlb(dev_data, 0, ~0UL,
+		ret = device_flush_iotlb(dev_data, 0, U64_MAX,
 					 IOMMU_NO_PASID, false);
 	}
 
@@ -1675,7 +1674,7 @@ static int device_flush_dte(struct iommu_dev_data *dev_data)
 }
 
 static int domain_flush_pages_v2(struct protection_domain *pdom,
-				 u64 address, size_t size)
+				 u64 address, u64 last)
 {
 	struct iommu_dev_data *dev_data;
 	struct iommu_cmd cmd;
@@ -1686,7 +1685,7 @@ static int domain_flush_pages_v2(struct protection_domain *pdom,
 		struct amd_iommu *iommu = get_amd_iommu_from_dev(dev_data->dev);
 		u16 domid = dev_data->gcr3_info.domid;
 
-		build_inv_iommu_pages(&cmd, address, size,
+		build_inv_iommu_pages(&cmd, address, last,
 				      domid, IOMMU_NO_PASID, true);
 
 		ret |= iommu_queue_command(iommu, &cmd);
@@ -1696,7 +1695,7 @@ static int domain_flush_pages_v2(struct protection_domain *pdom,
 }
 
 static int domain_flush_pages_v1(struct protection_domain *pdom,
-				 u64 address, size_t size)
+				 u64 address, u64 last)
 {
 	struct pdom_iommu_info *pdom_iommu_info;
 	struct iommu_cmd cmd;
@@ -1705,7 +1704,7 @@ static int domain_flush_pages_v1(struct protection_domain *pdom,
 
 	lockdep_assert_held(&pdom->lock);
 
-	build_inv_iommu_pages(&cmd, address, size,
+	build_inv_iommu_pages(&cmd, address, last,
 			      pdom->id, IOMMU_NO_PASID, false);
 
 	xa_for_each(&pdom->iommu_array, i, pdom_iommu_info) {
@@ -1725,7 +1724,7 @@ static int domain_flush_pages_v1(struct protection_domain *pdom,
 	 * See drivers/iommu/amd/nested.c: amd_iommu_alloc_domain_nested()
 	 */
 	if (!list_empty(&pdom->viommu_list))
-		ret |= iommu_flush_pages_v1_hdom_ids(pdom, address, size);
+		ret |= iommu_flush_pages_v1_hdom_ids(pdom, address, last);
 
 	return ret;
 }
@@ -1735,7 +1734,7 @@ static int domain_flush_pages_v1(struct protection_domain *pdom,
  * It flushes range of PTEs of the domain.
  */
 static void __domain_flush_pages(struct protection_domain *domain,
-				 u64 address, size_t size)
+				 u64 address, u64 last)
 {
 	struct iommu_dev_data *dev_data;
 	int ret = 0;
@@ -1746,9 +1745,9 @@ static void __domain_flush_pages(struct protection_domain *domain,
 
 	if (pdom_is_v2_pgtbl_mode(domain)) {
 		gn = true;
-		ret = domain_flush_pages_v2(domain, address, size);
+		ret = domain_flush_pages_v2(domain, address, last);
 	} else {
-		ret = domain_flush_pages_v1(domain, address, size);
+		ret = domain_flush_pages_v1(domain, address, last);
 	}
 
 	list_for_each_entry(dev_data, &domain->dev_list, list) {
@@ -1756,7 +1755,7 @@ static void __domain_flush_pages(struct protection_domain *domain,
 		if (!dev_data->ats_enabled)
 			continue;
 
-		ret |= device_flush_iotlb(dev_data, address, size, pasid, gn);
+		ret |= device_flush_iotlb(dev_data, address, last, pasid, gn);
 	}
 
 	WARN_ON(ret);
@@ -1768,7 +1767,7 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 	lockdep_assert_held(&domain->lock);
 
 	if (likely(!amd_iommu_np_cache)) {
-		__domain_flush_pages(domain, address, size);
+		__domain_flush_pages(domain, address, address + size - 1);
 
 		/* Wait until IOMMU TLB and all device IOTLB flushes are complete */
 		domain_flush_complete(domain);
@@ -1805,7 +1804,7 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 
 		flush_size = 1ul << min_alignment;
 
-		__domain_flush_pages(domain, address, flush_size);
+		__domain_flush_pages(domain, address, address + flush_size - 1);
 		address += flush_size;
 		size -= flush_size;
 	}
@@ -1822,17 +1821,17 @@ static void amd_iommu_domain_flush_all(struct protection_domain *domain)
 }
 
 void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
-				     ioasid_t pasid, u64 address, size_t size)
+				     ioasid_t pasid, u64 address, u64 last)
 {
 	struct iommu_cmd cmd;
 	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev_data->dev);
 
-	build_inv_iommu_pages(&cmd, address, size,
+	build_inv_iommu_pages(&cmd, address, last,
 			      dev_data->gcr3_info.domid, pasid, true);
 	iommu_queue_command(iommu, &cmd);
 
 	if (dev_data->ats_enabled)
-		device_flush_iotlb(dev_data, address, size, pasid, true);
+		device_flush_iotlb(dev_data, address, last, pasid, true);
 
 	iommu_completion_wait(iommu);
 }
@@ -1840,8 +1839,7 @@ void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
 static void dev_flush_pasid_all(struct iommu_dev_data *dev_data,
 				ioasid_t pasid)
 {
-	amd_iommu_dev_flush_pasid_pages(dev_data, pasid, 0,
-					CMD_INV_IOMMU_ALL_PAGES_ADDRESS);
+	amd_iommu_dev_flush_pasid_pages(dev_data, pasid, 0, U64_MAX);
 }
 
 int amd_iommu_complete_ppr(struct device *dev, u32 pasid, int status, int tag)
diff --git a/drivers/iommu/amd/pasid.c b/drivers/iommu/amd/pasid.c
index 67eace9809f16a..d708c6532480a4 100644
--- a/drivers/iommu/amd/pasid.c
+++ b/drivers/iommu/amd/pasid.c
@@ -71,7 +71,7 @@ static void sva_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 	for_each_pdom_dev_data(pdom_dev_data, sva_pdom) {
 		amd_iommu_dev_flush_pasid_pages(pdom_dev_data->dev_data,
 						pdom_dev_data->pasid,
-						start, end - start);
+						start, end - 1);
 	}
 
 	spin_unlock_irqrestore(&sva_pdom->lock, flags);
-- 
2.43.0


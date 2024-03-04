Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2CE7E105;
	Mon,  4 Mar 2024 23:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595876; cv=fail; b=esT3GETNIrSAK0cHmorQ8mIO80qD7uE/vo5M8Xm7XGBA3VqLXpYoRlTzLAAb6JytFEE/8XnelEY5VwI+QLJYwhQPOJmOkfo0L8HsUtU5AQN4JIrswT3IJy9otDYgGoMkifM9Zk/o+7aonzxlzxWidr9alQeuy1+O+kNJrRzDlbQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595876; c=relaxed/simple;
	bh=RvD03kMdjBbsClkTJQwgBDCDhARkh5ZfO8befmh6nvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=L9PEIIZ4aqNshlzoKnRfQsBM05dmKLFyyxtxejeXtFEWaX0hzg18aWJzeMT83ebBWZlvDeLzl3cWoiS1XK5PYZd8t/poTQULjau5+3osi7hl2XGSS/6ksey1EdylO9wSOXH6C5RoziHKkGEkd9rJ6h1WBWF2Wcnh6plXwkJ7sjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ewofBa/o; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ewofBa/o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=neuJsXm6UvyRP86ivY+d8zUgVVvNVOk/Eu1UMzrcY0bS13Iei5ECFsvw8d3ulIOBFx1ER/D+aGToBTkx6UU7AXP2M98emX01oWK0jt0QpSwPDy1vPL1Yd2NSbiUmAkiqa65Y6EFDPKgogKBFFEo4n4/XOQwve+05bYa5+DQK/3+qYJXByP+DgHQ5hRcVqeWFn8nWGjJTOoNRC51JlE8+PhqPzdsNgHShZO8BflyWlaLVLpMfb5LQE+2wYl16NqcKLMpnNxEAxekpow31hJodl5rnAh+keJ0E8B6fRLir5ONOLZxtIJDU0k8lxJb5Tn8m5j79Lxm5tLh6LF68YgBw7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6bEK3gWGY7JqV7vEnCnl86nIiN1HNcXkWKuNd1cGQmk=;
 b=XtMEWZtEmD8jmyUUecOlZFaKWRKbHC7Ak8iR+VWzI8E7ik+45i6xSjLHByVV/RtEs8cyvkq05FoswC9osYT4PNe8x3oOxkzu82UrvKXlo+r2JQra9KhdH2l+I9X6D+3/GT9AV5ovPu970JKF2zfnUA5fuFAJFRlaWUcFq3gXyg/J0Nm6bFrI6EHGhzA6ukCbEELMKrdLKblqo3E3r5fWvLD2UjNOM0STOdq3dN4Dj58eXx09/lVhTn4lk5Hgg/nCpR5fjvbaDbMB8PSYgPpG+5rLmx1TneUN6RWEhuuv/3jgJten7lfR/Aj4YGNem92HhBBHyvq9Auxg5NL9bTkO0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6bEK3gWGY7JqV7vEnCnl86nIiN1HNcXkWKuNd1cGQmk=;
 b=ewofBa/oc9vP4Wjpy4AVYpROI00eQh54RD5dv2wiMu1epyAqs/LnbtFQI7OxhHpHxeKobWXiAO+kLrVxQEHi4isnwSNrcIoDA2EQZoOsxMjB4n+VFar25OiK80gLOdzCSpvxWZ+6Vuv/aBtBstxEDhN4MFX8lYjBksy1pS6DqmuWxUNxZV8nyYhwtm5FSP0CgRtZLfqofTFkhV/Zb8bmpl3d75zf8AUiG2y/a9HhUr8cZ/UPrJJegfhcWShYjnLUGVRT9MXvO2lVdhOg2Zo+F+HmMcUnlZ+mfw1o2OUjtsAIjx3RuN0vLaQHn2gkoBx32sIyfSOOd/5uXj9/QeauGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.39; Mon, 4 Mar 2024 23:44:25 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:25 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v5 03/27] iommu/arm-smmu-v3: Add a type for the CD entry
Date: Mon,  4 Mar 2024 19:43:51 -0400
Message-ID: <3-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0016.namprd15.prod.outlook.com
 (2603:10b6:207:17::29) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: ce5cd00a-a8f5-4b39-7488-08dc3ca501c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MAo2gez3TiR3IKw74dml4/khinMowuYSGeRguZB2K1NLioeiSxKojxd1JSPLI/wAg1nMt1Q8rNerMGRJQY5s0TEPFTnDTgDpgupICkpfPuRoKz6A/JF89JPRIIzZGOcPLmmGo4dQwOeNWvJzQvfWukbJVDPwzQkrgCD+Xh3oSNzLzoruM9AQOV4U3ZOKrj2uksyOUeFTGRF+OUEfx2GIZaMDq1FvZKpPtL9qpk3aSvPR6xoTFC6+tygJFHXJ3KtKMqpsRSjviBO1rjefkhiOxg14pCcgastNylGu7X5YQ/2OW9kK5MpsPVBYAsutfk89cFT2m9Or5yfNNu9RUDJkfoImuNCaH6zGdN8EVo7aqwbU8N+FZEM2sILUhneUDSoJLb/rsZjmdtac4cOZAfvrRWOSHufXXX+Qf/hfgBuZSw0Ir2c12Y7v/9whROt/oQarfIEc/nJ48Fpz/VxurlwXZF4X2RyKTsqkH9T5w49rsj4RE7JivAiGEg3wC5PeroDbRz+061begSjFuXJfgLtb9M3UT4h3YzFqfRNhhKNDdWuh3yTt+VrldPCnPyMFT4kOENX2H70K3Qglp2h8DRrj0RAL79iNKn6n87X8DRK66ypnb7YC7x72ubshfmfGqzg06clOpqPGgwC/q4/1Ix8zBO6csuN5xI1CzxEatc+wADw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tqaoLroRkEBcJ0tIzGRcTtxLXejox48QowcakZE5LDAmlrVMGuAZdcKc1sI3?=
 =?us-ascii?Q?1PhRjnlI7MEv5A/hoAi8Gslou9G7H7KG+zfOzT98Bbo12MZOUrs9iHZc8pMD?=
 =?us-ascii?Q?InryJqFnsxug/a3k27l8jJmntYIxpE7sPoi3Sbi6O10EH1QSlOIzBh5sjTCB?=
 =?us-ascii?Q?o2bBg9HwYwmgQoy3ckwVGJe6oxP8tT+d43QvCMgUTJ2tolh2nMOnf+Siz42Y?=
 =?us-ascii?Q?PuD0XiQ0GnLeGMncdsAt153MFgkGrsWFOSBowJACEBxLoAbCblXJCW17/yE5?=
 =?us-ascii?Q?kEXE4xgmnp74uE+ddKIuiu4KG2SvBsqwlNpF7l9JsRosg7xdhyorBJbuFCEW?=
 =?us-ascii?Q?24iRSfN7CCeGAVJOQz8b7EaI7ZgMNKWCq94tN9MTEGZOvb/4omA1KOLVjnJu?=
 =?us-ascii?Q?+vsNlgVgcemlkugI/rpkhYvGqDmKc7meOYKUDarlT2CQTGVSdYrWvan1qNx9?=
 =?us-ascii?Q?frLl0+ZyFnUnoLEfw9ZnqsmC2Ik031hL171rBlqxPnRHR+1ZLxGiMcEJeKJw?=
 =?us-ascii?Q?ExtVqBkcZeATeMukYS540otbiOsLUTWGl0dmBLhGZTXnT4SZVfdG1ZBboyrK?=
 =?us-ascii?Q?QnI/kokkpySEfA7hZ1VTLsALbLGDTsx5T4roD3PqPH0x/0WgD1hCySplyyIF?=
 =?us-ascii?Q?V96GVU6aKF8zcL9FlAUwW6i3o4lxPUyIN/vUgFdglcsU06igRsviI+8QuNwo?=
 =?us-ascii?Q?N0Pr7135KblFVLfW2R+yGPw+SLCfYm9/B7aKSa/WfjVU2EJ/MGt7E8i+fHiQ?=
 =?us-ascii?Q?K62ewHHvs9BfbG++mBTBdwlqOsPLuyKAdbDnONQnuK+iypzP5R1zyiz9Hy6r?=
 =?us-ascii?Q?E/98Op5mh0VlnwNQ2/7Uh+ZoHYTkpks60jIu+RzNUv3vEKjNXC6g4CP1Kllg?=
 =?us-ascii?Q?6TaVHPuXKTiKugOGYPZ/LT8XIcyFbLIaWoEkWhRPwTcKGRS5OIfWneojtDuU?=
 =?us-ascii?Q?62kIab1IuRULtyKNOJeMv6BKGI5zD3YCG8i0nAlYma4/h9JnOQGoti4YIodB?=
 =?us-ascii?Q?SGzLZvpfgbh30qcXRs6mdHQcHMnd0p1WjoPJ3gT/0TSGqtmfNnrcqZAnasFx?=
 =?us-ascii?Q?6JsCcW9APWyvamZpUdqo/GeXwMIcDiD9BLsDgnkoMI0ur5DSfUH1/ve5FLun?=
 =?us-ascii?Q?PO1KfUukaIAxVqqpza5vYY6GkDGplmzOgIUyqKPeE6+ve4TeNXO3v1372+U2?=
 =?us-ascii?Q?MrkqL7dlnWduvPxaDhztr2CgzykVrEA8BwzCk5kgvjIB265D19oVv4OvkL1Y?=
 =?us-ascii?Q?Cuo/P8MeniKKJbJhkvBmyfy6peLzjHQWi4hazqeqCsTYVqla+wNTUYxOae8l?=
 =?us-ascii?Q?p3y475eL5cEC7VRXPa4JDLs9YoPzQE77sbW3fSvz4ddMsYkLni49ou4YsldA?=
 =?us-ascii?Q?7sKK4Y/GdUBd6gO2ftHOUXxm+g/kMvSX6Le9wJ5wRyZ+pd6tDAc55+BnqM3n?=
 =?us-ascii?Q?0H22BmLS7Cc9+pcS2aAgd5RaJ5TYcP5G9lvN7nUawegyN8ChitLMgbasg+wh?=
 =?us-ascii?Q?P0OcEDXqMdFjhQTQ72mG5o72+NIhVKQlpbuznKsJ3D3DgE+zYpSShUq3DyNT?=
 =?us-ascii?Q?KTnM8c+ZexlxKRHhrUdw5akb2wskn6J0TnNhqrEf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce5cd00a-a8f5-4b39-7488-08dc3ca501c3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:17.8048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ntIj0n3S8SaITN50lMiVJXN36j47hNNn/sqrpVDgONpUfzBEDDXso873kPhW3Li6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584

Instead of passing a naked __le16 * around to represent a CD table entry
wrap it in a "struct arm_smmu_cd" with an array of the correct size. This
makes it much clearer which functions will comprise the "CD API".

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 20 +++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  7 ++++++-
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 9e9233331c4636..c60b067c1f553e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1219,7 +1219,8 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
-static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
+static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
+					       u32 ssid)
 {
 	__le64 *l1ptr;
 	unsigned int idx;
@@ -1228,7 +1229,8 @@ static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
 	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
-		return cd_table->cdtab + ssid * CTXDESC_CD_DWORDS;
+		return (struct arm_smmu_cd *)(cd_table->cdtab +
+					      ssid * CTXDESC_CD_DWORDS);
 
 	idx = ssid >> CTXDESC_SPLIT;
 	l1_desc = &cd_table->l1_desc[idx];
@@ -1242,7 +1244,7 @@ static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
 		arm_smmu_sync_cd(master, ssid, false);
 	}
 	idx = ssid & (CTXDESC_L2_ENTRIES - 1);
-	return l1_desc->l2ptr + idx * CTXDESC_CD_DWORDS;
+	return &l1_desc->l2ptr[idx];
 }
 
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
@@ -1261,7 +1263,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	 */
 	u64 val;
 	bool cd_live;
-	__le64 *cdptr;
+	struct arm_smmu_cd *cdptr;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
 
@@ -1272,7 +1274,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	if (!cdptr)
 		return -ENOMEM;
 
-	val = le64_to_cpu(cdptr[0]);
+	val = le64_to_cpu(cdptr->data[0]);
 	cd_live = !!(val & CTXDESC_CD_0_V);
 
 	if (!cd) { /* (5) */
@@ -1289,9 +1291,9 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 		 * this substream's traffic
 		 */
 	} else { /* (1) and (2) */
-		cdptr[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
-		cdptr[2] = 0;
-		cdptr[3] = cpu_to_le64(cd->mair);
+		cdptr->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
+		cdptr->data[2] = 0;
+		cdptr->data[3] = cpu_to_le64(cd->mair);
 
 		/*
 		 * STE may be live, and the SMMU might read dwords of this CD in any
@@ -1323,7 +1325,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	 *   field within an aligned 64-bit span of a structure can be altered
 	 *   without first making the structure invalid.
 	 */
-	WRITE_ONCE(cdptr[0], cpu_to_le64(val));
+	WRITE_ONCE(cdptr->data[0], cpu_to_le64(val));
 	arm_smmu_sync_cd(master, ssid, true);
 	return 0;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 23baf117e7e4b5..7078ed569fd4d3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -282,6 +282,11 @@ struct arm_smmu_ste {
 #define CTXDESC_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 12)
 
 #define CTXDESC_CD_DWORDS		8
+
+struct arm_smmu_cd {
+	__le64 data[CTXDESC_CD_DWORDS];
+};
+
 #define CTXDESC_CD_0_TCR_T0SZ		GENMASK_ULL(5, 0)
 #define CTXDESC_CD_0_TCR_TG0		GENMASK_ULL(7, 6)
 #define CTXDESC_CD_0_TCR_IRGN0		GENMASK_ULL(9, 8)
@@ -591,7 +596,7 @@ struct arm_smmu_ctx_desc {
 };
 
 struct arm_smmu_l1_ctx_desc {
-	__le64				*l2ptr;
+	struct arm_smmu_cd		*l2ptr;
 	dma_addr_t			l2ptr_dma;
 };
 
-- 
2.43.2


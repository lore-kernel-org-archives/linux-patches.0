Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013068.outbound.protection.outlook.com [40.107.201.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44402DB791;
	Fri, 27 Mar 2026 15:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774625147; cv=fail; b=OVs3JgSJO1jFw1um9558J8ejh611PjI7daPESKPyV9dA+zd5xprlcM8X10rKXrFRNidYC7aYX0Cy+7p5BJL9ry9ndXHDXHkrPM0kvF4rl5D47yYI8NQIKVzpCAvcM5xqwueOv+zPFKnDFOwiWwo3AJuZgnEiy75aUIGyb52f4l4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774625147; c=relaxed/simple;
	bh=7ARo+2l4tdVAtrVz2QwNHTRIEIDOZORCTnkUp4dX0HM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jTyp93WuDfp/Yz5nX2K7YcldbLYpwt3kaS9zaZoluOoW4JQ6/CyCR8p1NxB/3oOs6FZS/sPN6bKHNw1LYPyxaSjDpKBGnxiErSZ2edahjUSCWPAbcVFiX4mUZZsPvzBjchcdeQX7b5jDT1/96yD5tv1xtti6OlKN6prCntt/uNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=N8lRj4DE; arc=fail smtp.client-ip=40.107.201.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N8lRj4DE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SYkqWcDU42lOqpA3FlMAZ86UIq6ui90kUD8K2DLzPNkj8pBphmTyOTjAWilcTjuOVciu0weAe9pi/pgpLTzutyhT4i7J8xgLlXdPKE9Hjrk4fhEmx9fV/OfUSimGvk/tbJhssVjIcxzafuIeqnCw5jG6bYJ5Ti1/ISy6hkxfobHyYZeTPchhgLeRdfhSXRKLvWZLAOO0qPmzrz7C9GtpTD6k//9gBbWXks5cuGxF7g53XdkfzCO+b17eJVpD90Dac30pwPRqbD9JQJDb8ohh23q0tkqFQib4gBwTl++WTTfJuxlDNY2uf1FZ5aDsDY8nxdiElMri14R4yegTaPr8RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=djB5FHZtd7xi9N5G1elm/l+EA5B7ML5rudGr6yHGyFg=;
 b=Gxjdm9t/5QJ33zOYZxDLjy/rgoAMu1BKkVamer1vGaTdsAHRh//UIlHVU8lJUvEA3sda99OUT2excsyHekv3oFIIYhkafLQtf+5JrvB4o27xMgiDjD55nzzgc6bXbaJ2Lzzs0lvIfbLl0xC9an31L6E8BHTCKyitua92Q1TE1ywJ8nWow9QFA0PZqXD/vEzmy/k0s81uPDeD6CS0ntF6iJq/pGVNVPgJUdRhEktX0VTF6CLWUa1vL291NMluVogSUYYyTCFEidugNv/K2cFdCj1Pm0gc7Pp+M6sPPJDJyJESOvLwmcZj7NfytXuLC37jWHzflGG24wm6KrP3iVt+kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djB5FHZtd7xi9N5G1elm/l+EA5B7ML5rudGr6yHGyFg=;
 b=N8lRj4DEzNbT0aH+ePBhRM2PZToHMns7wkGftGHmaYqtvhw4wu1UAPcnofsRTGxgF7bYWCCPCcaoHxc5kGfV6yKFfOYObi3n+r89a2tFKpUBO2l1AqX3UzKA/VLNGVgzN5xZbEnRP8dsuJJ7jEt/M1wSdMTb6c+0NPzbV7QgN83ZwC0YS1KxmM5xIKywNPIeKe5nTs5p1ItGDjxsAu1OzurY0V++iQ3SSNnchNqdgG6Xuv/+BbVKxdo4zYxK6rSTBvuvurhR/dDHmKVVnHq5o3IdOl2UQZ0WVM1+rR1iUU8MTuj4fZiuJiQnDQ3BFFuZO3uUEGCmWT1o14z+CA6T1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH8PR12MB7182.namprd12.prod.outlook.com (2603:10b6:510:229::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 15:25:38 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.006; Fri, 27 Mar 2026
 15:25:38 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH 1/4] iommu/intel: Split piotlb invalidation into range and all
Date: Fri, 27 Mar 2026 12:25:34 -0300
Message-ID: <1-v1-f175e27af136+11647-iommupt_inv_vtd_jgg@nvidia.com>
In-Reply-To: <0-v1-f175e27af136+11647-iommupt_inv_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0032.namprd03.prod.outlook.com
 (2603:10b6:208:32d::7) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH8PR12MB7182:EE_
X-MS-Office365-Filtering-Correlation-Id: 23337681-8906-4080-8252-08de8c151969
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	ZQTKWiM8KmBwkN2PIS+3BAEDY7GNYObxAKaYkK0+6ivHohGB75+69lXcLjKSQzmccUkDIrgW/PiH4s8GgKaty715cPcDMSxtCJVq0vdmZtUoXDO0m3hnVkMrpL7LA5HaYPQ5U4yGi29KnxKelskMPbXeDHno+2oZHB3TLdhfqYMxh1XORk+9c0dSfjhA2mWos46KVkwO2vaeHcOEjFt4w0ipJI95hRZekDzXbcFXypLg8nuj/HqFn0bMJfFvtMFnzjng8ggYJ1PfIjrV4OQCfLgG2LybBEq6ZhbCqOHBzJu+5fRtQJOf/gLzBEXV7niNWPF7dzJuBhsgTxQ188FCZ/kocj2GthOcMraOZfxRIwb1bl4BCYVLYRqQAEmkeMqsu1sWXm/2kUxPi2+RU1IxNu7DYSyYAY36MY7AMrWd3eStpfPkZJ0Z/jyb5G6tJ3qxEEhCAxAIwVrjgvqf7K4/eCrZSypjMe6gni1T3SfWq0NdIbeTc7es7rMSNgL/X0vWw86efi19jKaTI7JK08mjlhf1YL1fwNXnsCk11bJ2aCjx3eoqpZPLM6Z30I88VdxMgudhkt7834wVMtWqGjB4ANgDMzEUvq0Ja+cMP7M8WtS1QeukubSDc9Es6mcFIJXFI+3KA+LLV87Iyef2C0Cu5ioNUyx98wzpvqs5GIxjtwaZ+KmHb2gdgUGim7x2LNYcE34Cxr/5QYdVGLnnPv0ZYZZoorcCSBBuTSI/LwAKwv4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nd+6IWq8816KhzGxneRxNuwQHGL9lfMqT6aeuf1vY2HCWcP9prhtyxUHy4G0?=
 =?us-ascii?Q?0388TRr/YD/4i0gJyyrCgd5BO9/SeDvJjw4B5Ax58X970pDkTEzVs4p5/PEe?=
 =?us-ascii?Q?S/GCp7WVNxKDDsFA3jA1ShzzNLMG/RStM8M9iohOhrwzbtqtUMQA+9oXIYV2?=
 =?us-ascii?Q?+D1xfb4x87LRBr1GnXgGN/HFC+C0ucCl0hnFStilNZh119NUY3zD6NNic8eZ?=
 =?us-ascii?Q?K17nKBrB3gQmmVnMWA1L1MgYGMiIdlD4357MTEv+116As2rA+0S102Aef4bW?=
 =?us-ascii?Q?sX1wnlvXXsL6ed2uxniqCSY+l6vEwrcEK3haVRK4mNac74Ub3L7xSJ03Tlx4?=
 =?us-ascii?Q?fIyPd+9A4C+K6A6F7gmorZI3w4LBIqkCBeA/4wjPMvkK9RwqxGKGQar2Wrni?=
 =?us-ascii?Q?wmZgn7TO6o2HZlj1F3Eng7VKoIO7JSQ/tZw1HFtG45jKDsmrZ+frdNYfKz7x?=
 =?us-ascii?Q?GHNXURKSry5Rwxtx/HhcFSX5Qq31kY+tnghJlfWfYWDU7+e3tzx5DtrfOfXj?=
 =?us-ascii?Q?V91el57aHV42+I8GEwady/r1DAgcro97iof3dCKbjsRwOvVeCMQRKc/JU0JE?=
 =?us-ascii?Q?9MdAaB5MHrFXGLefOPmsdW92/kOKu09ZgANrhEgLmVSmqK10C/Uwn9tv52Sd?=
 =?us-ascii?Q?BcQDxtb6y+YVqqbzMmGNpSp8j6In8P8hzOrgABStQq3WjpFv0vKT717JO9OL?=
 =?us-ascii?Q?FEIDc+vr628TeANktDz3/n7/iqw9xrlXBuljXgkV3fVMRTFuKi7OiR1BBuCI?=
 =?us-ascii?Q?tBmtKy1s54/9d2MFU7j1x1AUYUNA3LGYZP03rG+gw5dXqRNtQ2+DMvuUbDGC?=
 =?us-ascii?Q?Wd/0IPtWmy+zq6YqQQGFZsZfem6EN2EqIF1ogypZDIvQ9fXn1iRNVVmoTXY0?=
 =?us-ascii?Q?kqM3e8ED7x0ytIcQtADZT4bi2USGmJ2d1vN3hxw5Tow2k/bXpy5KtnMtXYKA?=
 =?us-ascii?Q?ECg2AQt+lrTRLz8QBDMyrzBrs3QHBxiQ3Oc7Dx9pBQJZOnjqRnF0Lz8Z+wpL?=
 =?us-ascii?Q?9WvPjpzhgZo+V4wicGoAmobgDTXu4cgmLnQHyijXcVjjUF792EN8x9ntqXHi?=
 =?us-ascii?Q?oc8AsjCzQcyMz7Ry+ip9Mq0LV2FCaHGR7RhGn87DyUFLmFVyIePSwK+MQLLA?=
 =?us-ascii?Q?Hk2P8xN3DQ5oMfJELFBHEXmCnimIQjQTKfhdSzOGdwNqSwlzsOSsey9dyEQG?=
 =?us-ascii?Q?lgj1KxB2j/+xD2Zmc4PnVQff9sV98FJVlOJ8m6EGHDFTi2JQ25JiB83O5QvR?=
 =?us-ascii?Q?JXZngSwRi107hzorEFBWRov/sbbBpJderjhvGsOtjZXBAofsusfnHKfmEh6p?=
 =?us-ascii?Q?Li1JY7i3gvsXjZ1qzwFQGuJk1nUpRU8X4SDh1WccHe334qyTPxoRlWHGpabd?=
 =?us-ascii?Q?F3grueWpx+OD9U5bIbLXnGSRevq5vP5SD9SPUQX3Mr/c+BdpApq/W7O/GqjK?=
 =?us-ascii?Q?QLfuRSmDUn2K5y9xK+8Oks9wGdK1ja8QHn0pLc8ddwfsxcXK2tkpcHI8U96/?=
 =?us-ascii?Q?160k7PxmFKlQFobtQ2sat8btT3lYqjEIK9gq5MQ64UTXbaPJem0tHGz9uscs?=
 =?us-ascii?Q?oFDD9ItsDju5SPk06S7e+Z2pY9JFSeVyyGCJ0AjYCQ5Iu1CEk3u93CJEGcfX?=
 =?us-ascii?Q?YbgwqAgYzNYIFsCC04hSniDl7IC9KxmGpyJz4U7SiL51FFZn9R4TIL66Rruj?=
 =?us-ascii?Q?5mmOVAKcC+xTPf0NbK7N1tbaHwkaOni+43f84+8W15/Gd8cB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23337681-8906-4080-8252-08de8c151969
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:25:38.3933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: py2DCixuLmAggD9JRTaqTsHoyhIuS/JuQNnRwnIP0Wd9zSmirPFzKxa9fvc63Qu1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7182

Currently these call chains are muddled up by using npages=-1, but
only one caller has the possibility to do both options.

Simplify qi_flush_piotlb() to qi_flush_piotlb_all() since all
callers pass npages=-1.

Split qi_batch_add_piotlb() into qi_batch_add_piotlb_all() and
related helpers.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/cache.c | 20 +++++++++++++-------
 drivers/iommu/intel/dmar.c  | 19 ++++---------------
 drivers/iommu/intel/iommu.h | 37 ++++++++++++++++++-------------------
 drivers/iommu/intel/pasid.c |  6 +++---
 drivers/iommu/intel/prq.c   |  2 +-
 5 files changed, 39 insertions(+), 45 deletions(-)

diff --git a/drivers/iommu/intel/cache.c b/drivers/iommu/intel/cache.c
index 249ab5886c739f..e08253980a6ee7 100644
--- a/drivers/iommu/intel/cache.c
+++ b/drivers/iommu/intel/cache.c
@@ -330,15 +330,17 @@ static void qi_batch_add_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 pfsid
 	qi_batch_increment_index(iommu, batch);
 }
 
+static void qi_batch_add_piotlb_all(struct intel_iommu *iommu, u16 did,
+				     u32 pasid, struct qi_batch *batch)
+{
+	qi_desc_piotlb_all(did, pasid, &batch->descs[batch->index]);
+	qi_batch_increment_index(iommu, batch);
+}
+
 static void qi_batch_add_piotlb(struct intel_iommu *iommu, u16 did, u32 pasid,
 				u64 addr, unsigned long npages, bool ih,
 				struct qi_batch *batch)
 {
-	/*
-	 * npages == -1 means a PASID-selective invalidation, otherwise,
-	 * a positive value for Page-selective-within-PASID invalidation.
-	 * 0 is not a valid input.
-	 */
 	if (!npages)
 		return;
 
@@ -378,8 +380,12 @@ static void cache_tag_flush_iotlb(struct dmar_domain *domain, struct cache_tag *
 	u64 type = DMA_TLB_PSI_FLUSH;
 
 	if (intel_domain_use_piotlb(domain)) {
-		qi_batch_add_piotlb(iommu, tag->domain_id, tag->pasid, addr,
-				    pages, ih, domain->qi_batch);
+		if (pages == -1)
+			qi_batch_add_piotlb_all(iommu, tag->domain_id,
+						tag->pasid, domain->qi_batch);
+		else
+			qi_batch_add_piotlb(iommu, tag->domain_id, tag->pasid,
+					    addr, pages, ih, domain->qi_batch);
 		return;
 	}
 
diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 69222dbd2af0ea..6f496fc6a5ff1a 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1550,23 +1550,12 @@ void qi_flush_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 pfsid,
 	qi_submit_sync(iommu, &desc, 1, 0);
 }
 
-/* PASID-based IOTLB invalidation */
-void qi_flush_piotlb(struct intel_iommu *iommu, u16 did, u32 pasid, u64 addr,
-		     unsigned long npages, bool ih)
+/* PASID-selective IOTLB invalidation */
+void qi_flush_piotlb_all(struct intel_iommu *iommu, u16 did, u32 pasid)
 {
-	struct qi_desc desc = {.qw2 = 0, .qw3 = 0};
+	struct qi_desc desc = {};
 
-	/*
-	 * npages == -1 means a PASID-selective invalidation, otherwise,
-	 * a positive value for Page-selective-within-PASID invalidation.
-	 * 0 is not a valid input.
-	 */
-	if (WARN_ON(!npages)) {
-		pr_err("Invalid input npages = %ld\n", npages);
-		return;
-	}
-
-	qi_desc_piotlb(did, pasid, addr, npages, ih, &desc);
+	qi_desc_piotlb_all(did, pasid, &desc);
 	qi_submit_sync(iommu, &desc, 1, 0);
 }
 
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 599913fb65d59e..40759587729953 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1082,31 +1082,29 @@ static inline void qi_desc_dev_iotlb(u16 sid, u16 pfsid, u16 qdep, u64 addr,
 	desc->qw3 = 0;
 }
 
+/* PASID-selective IOTLB invalidation */
+static inline void qi_desc_piotlb_all(u16 did, u32 pasid, struct qi_desc *desc)
+{
+	desc->qw0 = QI_EIOTLB_PASID(pasid) | QI_EIOTLB_DID(did) |
+		    QI_EIOTLB_GRAN(QI_GRAN_NONG_PASID) | QI_EIOTLB_TYPE;
+	desc->qw1 = 0;
+}
+
+/* Page-selective-within-PASID IOTLB invalidation */
 static inline void qi_desc_piotlb(u16 did, u32 pasid, u64 addr,
 				  unsigned long npages, bool ih,
 				  struct qi_desc *desc)
 {
-	if (npages == -1) {
-		desc->qw0 = QI_EIOTLB_PASID(pasid) |
-				QI_EIOTLB_DID(did) |
-				QI_EIOTLB_GRAN(QI_GRAN_NONG_PASID) |
-				QI_EIOTLB_TYPE;
-		desc->qw1 = 0;
-	} else {
-		int mask = ilog2(__roundup_pow_of_two(npages));
-		unsigned long align = (1ULL << (VTD_PAGE_SHIFT + mask));
+	int mask = ilog2(__roundup_pow_of_two(npages));
+	unsigned long align = (1ULL << (VTD_PAGE_SHIFT + mask));
 
-		if (WARN_ON_ONCE(!IS_ALIGNED(addr, align)))
-			addr = ALIGN_DOWN(addr, align);
+	if (WARN_ON_ONCE(!IS_ALIGNED(addr, align)))
+		addr = ALIGN_DOWN(addr, align);
 
-		desc->qw0 = QI_EIOTLB_PASID(pasid) |
-				QI_EIOTLB_DID(did) |
-				QI_EIOTLB_GRAN(QI_GRAN_PSI_PASID) |
-				QI_EIOTLB_TYPE;
-		desc->qw1 = QI_EIOTLB_ADDR(addr) |
-				QI_EIOTLB_IH(ih) |
-				QI_EIOTLB_AM(mask);
-	}
+	desc->qw0 = QI_EIOTLB_PASID(pasid) | QI_EIOTLB_DID(did) |
+		    QI_EIOTLB_GRAN(QI_GRAN_PSI_PASID) | QI_EIOTLB_TYPE;
+	desc->qw1 = QI_EIOTLB_ADDR(addr) | QI_EIOTLB_IH(ih) |
+		    QI_EIOTLB_AM(mask);
 }
 
 static inline void qi_desc_dev_iotlb_pasid(u16 sid, u16 pfsid, u32 pasid,
@@ -1168,6 +1166,7 @@ void qi_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
 void qi_flush_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 pfsid,
 			u16 qdep, u64 addr, unsigned mask);
 
+void qi_flush_piotlb_all(struct intel_iommu *iommu, u16 did, u32 pasid);
 void qi_flush_piotlb(struct intel_iommu *iommu, u16 did, u32 pasid, u64 addr,
 		     unsigned long npages, bool ih);
 
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 9d30015b894057..89541b74ab8ca3 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -282,7 +282,7 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 	pasid_cache_invalidation_with_pasid(iommu, did, pasid);
 
 	if (pgtt == PASID_ENTRY_PGTT_PT || pgtt == PASID_ENTRY_PGTT_FL_ONLY)
-		qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);
+		qi_flush_piotlb_all(iommu, did, pasid);
 	else
 		iommu->flush.flush_iotlb(iommu, did, 0, 0, DMA_TLB_DSI_FLUSH);
 
@@ -308,7 +308,7 @@ static void pasid_flush_caches(struct intel_iommu *iommu,
 
 	if (cap_caching_mode(iommu->cap)) {
 		pasid_cache_invalidation_with_pasid(iommu, did, pasid);
-		qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);
+		qi_flush_piotlb_all(iommu, did, pasid);
 	} else {
 		iommu_flush_write_buffer(iommu);
 	}
@@ -342,7 +342,7 @@ static void intel_pasid_flush_present(struct intel_iommu *iommu,
 	 *      Addr[63:12]=0x7FFFFFFF_FFFFF) to affected functions
 	 */
 	pasid_cache_invalidation_with_pasid(iommu, did, pasid);
-	qi_flush_piotlb(iommu, did, pasid, 0, -1, 0);
+	qi_flush_piotlb_all(iommu, did, pasid);
 
 	devtlb_invalidation_with_pasid(iommu, dev, pasid);
 }
diff --git a/drivers/iommu/intel/prq.c b/drivers/iommu/intel/prq.c
index ff63c228e6e19d..ed98b1cb06fecf 100644
--- a/drivers/iommu/intel/prq.c
+++ b/drivers/iommu/intel/prq.c
@@ -113,7 +113,7 @@ void intel_iommu_drain_pasid_prq(struct device *dev, u32 pasid)
 		qi_desc_dev_iotlb(sid, info->pfsid, info->ats_qdep, 0,
 				  MAX_AGAW_PFN_WIDTH, &desc[2]);
 	} else {
-		qi_desc_piotlb(did, pasid, 0, -1, 0, &desc[1]);
+		qi_desc_piotlb_all(did, pasid, &desc[1]);
 		qi_desc_dev_iotlb_pasid(sid, info->pfsid, pasid, info->ats_qdep,
 					0, MAX_AGAW_PFN_WIDTH, &desc[2]);
 	}
-- 
2.43.0


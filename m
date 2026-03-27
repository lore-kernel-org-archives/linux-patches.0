Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013068.outbound.protection.outlook.com [40.107.201.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33190330B2D;
	Fri, 27 Mar 2026 15:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774625152; cv=fail; b=ceQ9upwQE4GVW/QSaOKD/uOmk6kxr6tKOtd8gcev2SubWaA1boTcDkrxPXxtltZJzu3fbvOlIM7x5sejibhM1Gq3l8MvFd69vfj/zL4b7sWV9M/RHiNPNSaxVP/F9UlfpCBCkeo0AAVEooEWFxxJMCEHcA0nbyt2mouoi5scRZ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774625152; c=relaxed/simple;
	bh=0YbaOa+vymc8y11TdtHpRGHtwEvD/7lmmajQgbcWFMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZPND6M1IPkaLj/lClqV1n0t6XFJq6HMOcfDfNElBj6VbnBAAbQkfw5jPJf+PaGYt5+/GstE5x13x1YrelCU5nLogihWxoaFybZz7vbBI09/gkG9WRuLALqoEJvoCGVzS263nE7I8seBdicAw0WvU3lu4fusN84rip3iW4XrlLuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SNRAw9zO; arc=fail smtp.client-ip=40.107.201.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SNRAw9zO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IPrklSD1ehYTYEjD/XHOfoZjgRE6tADY3RgPynRur6I3WzGeuFIMoW4J28LTarlXMh6MiWGq+ObBT3ga0H4cyO78Xoc5IIO9ycVES39ElamSAyTmHO07YCODQ3gImPeHG281CXILlkNOcfPehk53ZqJ0ueRdYFTzLIa5U4wkE2ma6bmqNqoa7+AHN7ugKxO6VQX8ro10/tsof5VW91Aympe21cZi9zDlr2QeA97sKAo/WR7FYTBCI20ogZUrLpMMtosfk6gXeYh7zOHYRTstkLW6UujhZxTbEDgIMgy3aEGa/qXqNxHY9D/D2J83bD68TIlDyfyVRjhbSMDTHbMsuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ji20cKLl0zVeA3aLvfShrwl+6qT1ELCsIIBY6DvaKUM=;
 b=ATcKy/D+HonApcraeg/4Ocv5iL2KUcF831FZpGBv9IjYc61IyT230amUhmI+ErQoaGlW2DoCy157/w4TvvwI92iXfopPgaVyKJxvSPJVrgeqDRmAH3+a5xqFijOKJ92hOI23vumc8KbE6S8WPYUGlNLGWzkivi8YIIOsq95K2njgeKEM44I4vjFrAD/8awe0xuS/6BKjtoeuRkKw+Rbj8KQLNHQ4y5reVDo9HAmio5muGBBrDv4wN1cXQuYYXz+g1U1FDTm1xRKenLkB2lBCR1IH3S+5w69uMpgJEr261YWJW2f0sgUx/BSDZpbXtwfrxmX4JOkolibbV5oJUVymOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ji20cKLl0zVeA3aLvfShrwl+6qT1ELCsIIBY6DvaKUM=;
 b=SNRAw9zO4UD52elIYnaa1ZWGXXHa7ldh0TrW4gOrEV1jkMa1WRhkqb/EJAd+MYfrSc1aShA/mPVe0XSX+7hi/8IdpB/Ki8/m9iJE9EsQrLgSw495KelGqqeuw6bjEy6cRJmIGCVo/9UHnVZ2eAVMTMdiCiW9IMivhY0ygqhv2DcpA0WtAleg6L5F8U7WDtsuMFPAlZnh3e4KjlSuuielbnc5QQqy3JxufWo3gAJjLS6ntCPgd1dq6lqwVlv8cDxX/QJcPXlKEjkg0S2WrXaGgKBpTk4V18dwh7nIOdLURKwbFHdwcYAwAB5GDyW094eDW+Gr/SeZlgSAwlDCqIKoog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH8PR12MB7182.namprd12.prod.outlook.com (2603:10b6:510:229::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 15:25:40 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.006; Fri, 27 Mar 2026
 15:25:40 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH 2/4] iommu/vtd: Pass size_order to qi_desc_piotlb() not npages
Date: Fri, 27 Mar 2026 12:25:35 -0300
Message-ID: <2-v1-f175e27af136+11647-iommupt_inv_vtd_jgg@nvidia.com>
In-Reply-To: <0-v1-f175e27af136+11647-iommupt_inv_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:408:ee::33) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH8PR12MB7182:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b46de11-9a2f-4821-e4cb-08de8c151a4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	iZTV1jbMC++kFYGIcS2iLT+UPm70wKd4vXtpJyvTvN7Y2WkQhZ1kjmhqM1f2A4TJM/m6XGGEPbU732hDMsJPPaBV3KHlBw39AAl7dOOyfDZdhlOCVUmqw+Us54B2t9BplkGQbtD/ecS2HFj/GNEqZcGGCSjG0dcUfQJ9J4/HEa/aaV9i3aw930pB+FAU3ocJb7vzg8HSX0D9IUIWXLYba6QTOUvFePrJ+1X332f2AgmpuTjss/i/4SntKx/Ok473udJeLX+hTA3+1IYm9JBqIjK4d6FRoIv3VKYB/xjgzW7Jd+2Xtfp8EOLbg1BuBXRmNIvtpkJdoVb8NTRjdlSGRhhHnNPMAxTfaanx8f17bojVP9xj/VCK62NshLDOUxs3hMazwQ6CG29X0GiS4nXfMlT2/iij7VJFtLUbIdAkIQ1CUJqyNf1s/T/4AhSpkadyqutep+3rIMaSoPMIeYGPR7flpaf1BFWoY7TJyPkFt8PrhLX/4yPcR+ekULixjvmIWQStjUQoGvWfjTRitWl0qJL6+zdNt6L5dkLaRrWuQcNWQskGvk6GGzh/t7w6+9is8WWdqlg8VA10fnrh2sCx/oAwxOXWm59GhxGv23FL8X1VyYaIR1/dY7PvMgPhph4qF1ctTmgd+YPKeYYMcvSjm50RpqsNsniABLKx8fP0tirCwx/SMO5FEfE7iQKeOKJZ3VHxtFGS8ACcqHF68saweIWUBaMTPxuAkwigrxLbKXA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TOPBml5Y3vAjuWebm1CBveD3tZ97teStVErEt3IfTp/U5aZz7jqjMwEBvCfE?=
 =?us-ascii?Q?VYuwSoiaqnTwBHTnhdt4WNf19xZMLUdXAAXpgy7vIo/yaHC54tFVgLlv8DJ8?=
 =?us-ascii?Q?0TDf7wjyBCN7q43qODym+eEqrUlZV+vdd0lZlSlU+Pztms6m0HzJk1c+YBK9?=
 =?us-ascii?Q?VZpkgOR2jDRJYZ4CdN1oy353vEQ9I6HtUuhUDJBJ2kttU4fuxm9Yxs5ZzR/S?=
 =?us-ascii?Q?/qildlAx4s1lcPGvbrgl8AYnJFCJbrAuZu2l4jsAbSeOUSDgyzcwgAhI2hqe?=
 =?us-ascii?Q?hNZ/3ZZFdNMC4jDWXWZsifDlXEPvmSpl1CN/LEKMYxYxb6rBycfec5pUk3rm?=
 =?us-ascii?Q?LuTuoHkHo10LdDLXC6xkwZ92DLW0xypNwZkRoixmm0Kgy8aUSs/AD5An3OzN?=
 =?us-ascii?Q?0stitwvb4sGsuWspmrICN6yvzwzx56Sxnlq3uQsqD/IeAla4I9WhxNlN9/R5?=
 =?us-ascii?Q?fstmbFcDyRgf6UK/evw72jlVYB40+J3beTOKqy9njpgxykJ4NbIqZuwgcTk5?=
 =?us-ascii?Q?jxK7ii3K5+JzFiW9kl1v8Mm0OJdxurJ2E7FVnyhH/OVY1OU+BjVghWk29Ux/?=
 =?us-ascii?Q?GIAxeVJj1V6KdBXH84QlrYJNql+xv3i6G5xRyQoTZT8eXFGOTU72qTM2lvAG?=
 =?us-ascii?Q?xFgJQRRul8/yx/oysoSV9gkIuqt9XThmBvGJLxKwZ1pCLXM53XiT3GBPOCHD?=
 =?us-ascii?Q?BNIzF7vABYtD7YBfI9KJ5Q6y0p91MjWf7ZKCLNhS/UnSqG1QnXWGbn3GA1kn?=
 =?us-ascii?Q?II+xCVi2oUx5ss1aemoknYS9OeYO12Gkp2sOZHMeHLFdRa0qBm8Xw/cNJu3b?=
 =?us-ascii?Q?Tac5TyiCpCe5o7u3YuAFCLOgXyHyyvvsvdi7so0qUc/li/KC4fbDbGXYiGD+?=
 =?us-ascii?Q?8Sh3uGyBO8Zd49/cC82kQMY9LPpS79KZ3Re1zpAepXQwVufQ6srDX4hwz8Lc?=
 =?us-ascii?Q?Gz6gCu8g8bXZ6ojzI6sdsAqwsgGoeinteoDMWX/lGsDzDlUuWh0waF2l+2Zk?=
 =?us-ascii?Q?o0mx1A5+b7DDZZlQMdR96HYq4PigieKyKETDifxONpR6WB1QxtJaQSVlj1BF?=
 =?us-ascii?Q?B+Ky6sODrBjnf71nExU0btnOh16NbEOHEZrlW7JKc1evUyNBuUjzENK2SIj7?=
 =?us-ascii?Q?SLPRkeDEuON2pfEbKGRhmYgZ3bJx0RTsqpQPPG1Ab/uly1QUGgAtcWQwCwjh?=
 =?us-ascii?Q?21klnfALYW5LuwKkkO5VwX/Q7uCHxJiffmDD2ykQ82LEaN+Pq0r+d/S0oPCc?=
 =?us-ascii?Q?CBbcUZr95w9eb8JY0d9JXINuMyfLQuAhkDLSdGPy7PkarLty5k3c9LdAlF7N?=
 =?us-ascii?Q?hKT1XzKShRB+nNv9mYn134uCOEey8p1WO+s7yJuDNGQgXp0sJO4Y01Bm9Y13?=
 =?us-ascii?Q?hY2fQbNXH2iqI2P5XL3XWfTeT0kgZ+Sj0uvhk2HC8jfZl8KKAnvUOqDsyepB?=
 =?us-ascii?Q?9ixbfZ0020hRVCfCc1Lh3YLfax9SeESiqW3+Ka/zy55mYoqj+HC0ap7N2dG+?=
 =?us-ascii?Q?zdNvC6cYLeCpkioooeDTEsZyEDCKzJpn7naE0m2GiC/tp/rZMdEnLNM97vY5?=
 =?us-ascii?Q?AN/AGvwUyVo6ifG2yzm/XukpqDyKFZO6umy5XBG8C/EuFoHFOkVun3/lFct5?=
 =?us-ascii?Q?aBqj1yslALN/Y579TPIp9LiQu1DY4CWTgTryf165ydwrmiL2nDxiuCIj3/Bj?=
 =?us-ascii?Q?anrPnPYW2ZaD+92qOUC6jhBTjGeIwYhmAZhdRZFjAMplC/1Z?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b46de11-9a2f-4821-e4cb-08de8c151a4c
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:25:39.7980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kgjbcx77pz84aWDIxibrMw1Kp3PC1z87rqYyMIDeY26goOnptmipOTNX6bdFmEva
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7182

It doesn't make sense for the caller to compute mask, throw it away
and then have qi_desc_piotlb() compute it again.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/cache.c | 10 ++++------
 drivers/iommu/intel/iommu.h | 16 ++++++----------
 2 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/intel/cache.c b/drivers/iommu/intel/cache.c
index e08253980a6ee7..74ee2002fb9c85 100644
--- a/drivers/iommu/intel/cache.c
+++ b/drivers/iommu/intel/cache.c
@@ -338,13 +338,11 @@ static void qi_batch_add_piotlb_all(struct intel_iommu *iommu, u16 did,
 }
 
 static void qi_batch_add_piotlb(struct intel_iommu *iommu, u16 did, u32 pasid,
-				u64 addr, unsigned long npages, bool ih,
+				u64 addr, unsigned int size_order, bool ih,
 				struct qi_batch *batch)
 {
-	if (!npages)
-		return;
-
-	qi_desc_piotlb(did, pasid, addr, npages, ih, &batch->descs[batch->index]);
+	qi_desc_piotlb(did, pasid, addr, size_order, ih,
+		       &batch->descs[batch->index]);
 	qi_batch_increment_index(iommu, batch);
 }
 
@@ -385,7 +383,7 @@ static void cache_tag_flush_iotlb(struct dmar_domain *domain, struct cache_tag *
 						tag->pasid, domain->qi_batch);
 		else
 			qi_batch_add_piotlb(iommu, tag->domain_id, tag->pasid,
-					    addr, pages, ih, domain->qi_batch);
+					    addr, mask, ih, domain->qi_batch);
 		return;
 	}
 
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 40759587729953..7a92472985ee02 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1092,19 +1092,16 @@ static inline void qi_desc_piotlb_all(u16 did, u32 pasid, struct qi_desc *desc)
 
 /* Page-selective-within-PASID IOTLB invalidation */
 static inline void qi_desc_piotlb(u16 did, u32 pasid, u64 addr,
-				  unsigned long npages, bool ih,
+				  unsigned int size_order, bool ih,
 				  struct qi_desc *desc)
 {
-	int mask = ilog2(__roundup_pow_of_two(npages));
-	unsigned long align = (1ULL << (VTD_PAGE_SHIFT + mask));
-
-	if (WARN_ON_ONCE(!IS_ALIGNED(addr, align)))
-		addr = ALIGN_DOWN(addr, align);
-
+	/*
+	 * calculate_psi_aligned_address() must be used for addr and size_order
+	 */
 	desc->qw0 = QI_EIOTLB_PASID(pasid) | QI_EIOTLB_DID(did) |
 		    QI_EIOTLB_GRAN(QI_GRAN_PSI_PASID) | QI_EIOTLB_TYPE;
 	desc->qw1 = QI_EIOTLB_ADDR(addr) | QI_EIOTLB_IH(ih) |
-		    QI_EIOTLB_AM(mask);
+		    QI_EIOTLB_AM(size_order);
 }
 
 static inline void qi_desc_dev_iotlb_pasid(u16 sid, u16 pfsid, u32 pasid,
@@ -1167,8 +1164,7 @@ void qi_flush_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 pfsid,
 			u16 qdep, u64 addr, unsigned mask);
 
 void qi_flush_piotlb_all(struct intel_iommu *iommu, u16 did, u32 pasid);
-void qi_flush_piotlb(struct intel_iommu *iommu, u16 did, u32 pasid, u64 addr,
-		     unsigned long npages, bool ih);
+
 
 void qi_flush_dev_iotlb_pasid(struct intel_iommu *iommu, u16 sid, u16 pfsid,
 			      u32 pasid, u16 qdep, u64 addr,
-- 
2.43.0


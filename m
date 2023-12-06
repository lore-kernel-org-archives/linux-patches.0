Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8C46929F;
	Wed,  6 Dec 2023 17:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MwFo6f8e"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gsPj2/oCLN1EJJHGJIqZeNaCQgblP+Z1SZi/k6zVgDp6cly+0z8exz7/Uh3/EV9ncqBHVWjuGvOWdP4dqCjnrznk3s4hGpeHBlLGAei7qrKI+EbH8EkTenet8Zn33sEgqg220Ha54sCrcwNbKZLHOnfcnj8id/FLGHSHD583Zw8iEmFAT6eo3PAJriyLC+Riub5Fr9gjUnaGa/DrGT71fyJg/eDG+n00EilLuOlD25LG9riM9TTE4vzvEX9Ow1aYbZ+6YW3gLdRSq46rCn6vfH0lJDlUfXDk04UwI0+sh2M8LCjM6AK9adT2GybmtL/NZJdcGtudgENVurrapyPQIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=elGqi4l/h6kI0SCmDoB6mF7m5MDLpscgm04YWeVuV5E=;
 b=YM74D6M559GT9vPOvR5RAjda312bGPRJv6t+S2jMp0F96aNMPvuYszvC1WJ+FYVFRklSbq8E1SzDISJdtCi99qsJXMsTHjDPKb83lhHc31D6Le2jF97J3I1FtxMJ7XXnuIq7AvBCp7HlwjfUdm5V8KMYLO0NoX2eECNbBZcGvS98mSMQde7tFTWiswqbtlhTTgMKj71Zt/bP6xxsyFDXKAhiq4sWlqPEhDIYXZpzbXV+nGEshCaoGeC1VIGewORHn0HbuCXRJdvvQIHufFA70npbgZBHJJmqxqdV8L1iZA6a1gUJVSGaxBkdaHzOzsc/DQeoiCX/34qlVIZkq6Opnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elGqi4l/h6kI0SCmDoB6mF7m5MDLpscgm04YWeVuV5E=;
 b=MwFo6f8evhujQEg1PHWYiwPDS/hwRhjnfr/Vb/NrS4fUWDAiOYJ6k5D/kF5szzcekQ+rsPQnT5m87cAIqPNDSRpQT5IEsnzHXmwvVLffNw51fkQ6z2McGzo8EzU6L3zPWpYuSPUkyUmdjLDyCric+4IxOrBMYg57+Qc5JkdTJjof+8jlno2DkvmxiLTXilRaN5KAMHxOZQl3p7JU15CU2blS3TRo0elb5S4FFYvyq0wgAYG10YJ7pYLUhfBocY4POIljPs2ygUH+DxEo92JmoypVO0yJxB6pzAuQxbVSSH+zzEawPkTwRvMIfI4Q4lNhEWysXL3oVKjq/VN0XcOYNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8360.namprd12.prod.outlook.com (2603:10b6:208:3d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 17:28:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:42 +0000
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
Subject: [PATCH v3 04/27] iommu/arm-smmu-v3: Add a type for the CD entry
Date: Wed,  6 Dec 2023 13:28:10 -0400
Message-ID: <4-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0023.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8360:EE_
X-MS-Office365-Filtering-Correlation-Id: e99b7291-7908-4a26-7c54-08dbf680c6c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	i16vf4RDaAYCAaDJH+cki4/2YZqqasxlxdY7Ld1fROmVtDNpHw0Vdf7C+yWpAf8+pmqvIvtbVXjWGMVuLibXCt8WsyUk2Es8fWOl5Lo5OyGAOpFDb7155qWiEeYcbYgeewS0dNWQNayqUL/9rdp6jL0m52L2fZ5U2pZfa6/HW15eD+RFJKLF7y3JVi+bl+R8qwPqw/tcUr2YkwjSGktA9sjQidfXOWmdeRtA5QL6reIkXlyS3WPm3emKBeIoCt39lxWC9PIIE6gNHYn/2nyX+mnWhtqRacxoT12iy2WqW2IqUiYEq78vTcsrX6ZYRgGUqEZFo83XjlzpUSNB6LyUg4ud3KySNpImHXoGSC8ivL7uR1n6vVEghL+s/ZhyP9sOiADrIWr+6rGbh4jrqD2zFFPjDtxBupYFn24BCAyN3Y4KQ6Xau73XNtZda5AWxzdzPlYFW+Li6IPQQRJaNLg38bKE0lZAp/3mpg1gpB0+fsFxmF73MkViVfd+Fet/aGDkf+HtFnnW/0HDfqtXy5tO/KwwBrDuXlvQnWlF2iEUkatz7twKQPGaPCyBQfiJotwPOeva+OtWu+YiHQD+Zf4N+JUbchg4H0MFvJTGVGqG2ednw7UXvyKFATHHBEoWCoPzOrTKW599vtG7An/7ZYq0Kg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(6666004)(6486002)(478600001)(38100700002)(83380400001)(66946007)(6512007)(2616005)(66476007)(6506007)(8676002)(2906002)(4326008)(54906003)(7416002)(5660300002)(86362001)(36756003)(41300700001)(66556008)(8936002)(316002)(110136005)(26005)(4216001)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s0kjUqqEekrJKHsTdkkG7PIW15FVGnD3faauYhiCsmwswMqcrJdFMRoi/wXX?=
 =?us-ascii?Q?2anDvlFkpltka0vzrNKhpZoSu7NFn0fLesMOxHcbjTIpJC2UryRQ2VOFhhrA?=
 =?us-ascii?Q?FoaF26szDFRkV5NQM4fOyNxrbLZnHddFawz6o0PeE/2KNihbbi+tuffB1WNL?=
 =?us-ascii?Q?pHU/6GTuT+S5ROrmiwUn3Q2uGaVlREQbVOme8Hycq+v2ofJQGvglUtRrnS5W?=
 =?us-ascii?Q?+B3//spX2p0d9YpUsVhoVGCat1gUcreRYXH/nNdhhd2W742DyxqriQPLyRtN?=
 =?us-ascii?Q?DILeaQO/Nd2GFhFTNms16N2gARoPPW+QF3G1Hxn6/3y6wYejY4MhD/7sZB0+?=
 =?us-ascii?Q?cZLHe73Vo6EznHxwUMvthFN90Xf9nuZJJZmDC4InsyVXxm1/B5mZdluEQGmB?=
 =?us-ascii?Q?yrU/XwLk+A9vXyPT4YfruzEdoTgi/ATsFuuOUu2jA3xZvPXk9Iujg7lYBkr6?=
 =?us-ascii?Q?C+dOZ6inZCUKQ3OZDtDUmNllrvdCMahqfX5o9cH4gemj/c2dxN8k5XE7MgLF?=
 =?us-ascii?Q?kb6Ckt5G4C8qyAc9/ffEw4VirvyqbaRZ3YYl5B2dtsQDfQ5Rdxb5AV9iISGP?=
 =?us-ascii?Q?f375AY2RE1heDqS8frt3ZLYLr3WWHKKmRVERPL2KVRd4JBW93hNsvNBL5jn6?=
 =?us-ascii?Q?NkQeRDXXuri5sXm+d9k7xjy0kvDPcI6qZ4pqvz88fPTAzjVJYyLw5WXk62JE?=
 =?us-ascii?Q?MxGiZ6+6VfVhw7zZy/QyK+2OSCpW+bOwQGBF9rSDrnVPvMijgi8rh/B2rXsf?=
 =?us-ascii?Q?Evz0diad9bc106ZprvAjJg4rPPbYO43efHDe8IPbRcAhZkVOybBya5xhUm25?=
 =?us-ascii?Q?/KRnpR5N9Lvbky7In0xVo7XVDp2AASqwtlArWOyfIJ+OKyLsQ7lLKIgHRg5L?=
 =?us-ascii?Q?MUcaatJ7slu91SAyIEobO4v+vrTKScZFUsXMtLpGXhPnemfRmLyVD7zcE3Ym?=
 =?us-ascii?Q?dhLnTXsvK94sHe6PdTJ2FZFSgN6/LYUg0U2s9oPSz6CogRUybyegpDsMSLUD?=
 =?us-ascii?Q?/wUiwjvqybgo8zJdkLBkGnvhHNSgvY5eG7tgRcLAarJqkVwy316+E28TruUo?=
 =?us-ascii?Q?Hadcg7ZiDFiby/DoE2RfK6t0bsCvIwz7H93kBLmFuGigJR29vkHBMJRQZ7mU?=
 =?us-ascii?Q?ktA1d/hHSktakoMvd4HjFsGF0UoV8WSef1ixBaPX1OSz3Z0Ipn/LO0yjDAAQ?=
 =?us-ascii?Q?JULw0r1vDJirFDAXPLAhgPQYKyYSs704kapGSo+fouzXHeUoDfYYZ3By1YGV?=
 =?us-ascii?Q?G31kx3PIaCfoqfZhhmWAf33fKHiLZalKxzXTxAh7p0LfVz62ovvTPDnM9593?=
 =?us-ascii?Q?t8QcNGR+2KtOYzUiFmjlvIxJ0iD3yg1REuSV1n28iVTQGkzR+ewKM1OXnRGF?=
 =?us-ascii?Q?cjnn4hLwaDKcfeQZhK5Ymgyj6dqk1yS8vSspE+pRAMegoJsjKWeEwNmWFRrK?=
 =?us-ascii?Q?KetPlh8jMZXhjPuvS3v0QYk5H3HlUeeEGbuyJ+fWgqEAp03Mo1j/IIYF6Kr7?=
 =?us-ascii?Q?0WwD2UNgVEjDc/OTMFmEqf0E38zuwogflfwkKeOpm9nmwXmSTwLLxRPtga30?=
 =?us-ascii?Q?/r6jpDMvw627c+RQPo1lGxpl90wPhHh8bPCRN64G?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e99b7291-7908-4a26-7c54-08dbf680c6c2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:35.5292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PtGleTDnioglRv/V7UzO44dYu1d9y4w+i294WLKjiyZj+T8lqI9VNZO1XZXje5+d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8360

Instead of passing a naked __le16 * around to represent a CD table entry
wrap it in a "struct arm_smmu_cd" with an array of the correct size. This
makes it much clearer which functions will comprise the "CD API".

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 20 +++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  7 ++++++-
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 39e010c838b1c2..3f77583144e649 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1118,7 +1118,8 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
-static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
+static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
+					       u32 ssid)
 {
 	__le64 *l1ptr;
 	unsigned int idx;
@@ -1127,7 +1128,8 @@ static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
 	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
-		return cd_table->cdtab + ssid * CTXDESC_CD_DWORDS;
+		return (struct arm_smmu_cd *)(cd_table->cdtab +
+					      ssid * CTXDESC_CD_DWORDS);
 
 	idx = ssid >> CTXDESC_SPLIT;
 	l1_desc = &cd_table->l1_desc[idx];
@@ -1141,7 +1143,7 @@ static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
 		arm_smmu_sync_cd(master, ssid, false);
 	}
 	idx = ssid & (CTXDESC_L2_ENTRIES - 1);
-	return l1_desc->l2ptr + idx * CTXDESC_CD_DWORDS;
+	return &l1_desc->l2ptr[idx];
 }
 
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
@@ -1160,7 +1162,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	 */
 	u64 val;
 	bool cd_live;
-	__le64 *cdptr;
+	struct arm_smmu_cd *cdptr;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
 	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
@@ -1170,7 +1172,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	if (!cdptr)
 		return -ENOMEM;
 
-	val = le64_to_cpu(cdptr[0]);
+	val = le64_to_cpu(cdptr->data[0]);
 	cd_live = !!(val & CTXDESC_CD_0_V);
 
 	if (!cd) { /* (5) */
@@ -1185,9 +1187,9 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
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
@@ -1219,7 +1221,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	 *   field within an aligned 64-bit span of a structure can be altered
 	 *   without first making the structure invalid.
 	 */
-	WRITE_ONCE(cdptr[0], cpu_to_le64(val));
+	WRITE_ONCE(cdptr->data[0], cpu_to_le64(val));
 	arm_smmu_sync_cd(master, ssid, true);
 	return 0;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 6f62184eaa2434..24a77e0a97898b 100644
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
2.43.0


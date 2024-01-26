Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CE920B11;
	Fri, 26 Jan 2024 18:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292951; cv=fail; b=otGAdlS6VUMkR8GW4syhd8/vm+6euoK3PTLryJO86oRZp2w5G2BEidLYwBt2eQXx60R1PDfxTmUaGwz9C0Th2n/ktN6WKCDahq/LRBizsTnmhOv0m1YJ3Fx3pbenQzrxtiaVjCV38RntJdtAPdleaQHcpDOJ3x4ronJlvm5HxZ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292951; c=relaxed/simple;
	bh=bgMPuLAG0DmToHf67kw60MafJ5ULcYG1hAJ+4LKbqXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XueE/RWeSr38ocyMMUWRK0vKm0Okw0TSC8jqD0IeIIqtQ5r+LYI0xeSlW/HY7/QEWceQ915xaeYL933vgqsIqUGfItYwV8YinVWuEEHhqshXBZ2OM2DDM98EbXjPbANZjGrpegtnRrhTE2a8jzBaYm5gKGPFNapyHVYbqpnL1O8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QaRF+8lc; arc=fail smtp.client-ip=40.107.93.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QaRF+8lc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aOe0K8pSoDd2zDTXyvwXXLC4q7PxdIcn++/a+/UTIqccbCKQS5fqOmcfGrtLXZnw1lWjkh+Euk9MfMK1vgalKNq5GN420Z9su9XTK0a5K1NTdI9dcL1duOb6Bi9ZOD+TOdXwemWAtb/C9KkNoka0fIP/K187e+jGC0b6reh3BRczEv2PK2+oqtt7COBUjrMPP3245osIvvYfjUh0OubVCD1EErPjMgu+zUIiYdn3EIJbmRAape3ziQEYkFS4WlDYxzGqp/qgSTVVsDIi82CRagmY0P6qBXfQAQlHnxM/bDFBdV0a50gWMZlCqluzTKS1L1KxRRDPljnEliJg+kBTNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k0zbDOBIoFk6JE6MgIKy9eXE0pi/4oPD9NUSlezPX9s=;
 b=ndWH/50wsYEv4W/ptqAEll3DrzJb88ZD4HQyh9hhlmt8nfo/+79VHXMKbwOHvMrW+PkCJTDUWGNN/50VpEQ0a7iGaCqEy/PGgn91sKm5Ohi19r+z5BR0Hk/9KECsOhAB2q9zlZDvCRdbU+y2s0AoFQKWOzqD0AlSXE6sOrHc/Z16QNCRBXJcM/AfVs5ssAEMwm3zG69kF/i5GHGgK+eJD+lM9mEpJXFh0uDEzXx+C+WV4fqWaSUuAtXM+7OLjPZQIDSobyxPJDKG52lqAFlWxONh6sR9BgHFgekiWMXAefFKng1xePZcDFSWGILTlwtSpOoTaWoqL7FcuDipcroIKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k0zbDOBIoFk6JE6MgIKy9eXE0pi/4oPD9NUSlezPX9s=;
 b=QaRF+8lcIwdrchE1bSmQIYd7mgZ8lsXGRIST/lyIel4GYvzJVNtVq7uTPkK3wsHLM41ALB+k08jY6uviEDIWFbaSAufcbBltc/njfwFR/U+qTFIWQLVfOuVFcYpildpfbSNkkfwEVddUAKdGg4nnkDVmnCF6Iy0kX/Lw2BzcAABZHAaHL0p5zVfevC1QwLz03MuvE/zZLxmwlwX4zeOMGAq16ijsBiSixo/W5uPeV3fYDuN8QSGI/q+DEg/KHS/Vz+Ku0NYLoSj8zdEO6z/CEBQwhHncXDe3+dxV4bOquN2AkhuoKiAM/Bo7tnM/KxrPRMTvpk/ODlZPwXqkcN0TmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7185.namprd12.prod.outlook.com (2603:10b6:510:201::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.29; Fri, 26 Jan
 2024 18:15:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:40 +0000
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
Subject: [PATCH v4 04/27] iommu/arm-smmu-v3: Add a type for the CD entry
Date: Fri, 26 Jan 2024 14:15:06 -0400
Message-ID: <4-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR16CA0041.namprd16.prod.outlook.com
 (2603:10b6:805:ca::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7185:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a3a7bc3-c980-4667-d6a7-08dc1e9ac947
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hRbHwqy7BIMMyXDpLUicY9zvLW99nAZqiC4UGjifw3zUYUfqFg77oeIGqEB/wpOPg4KMDirDvzyQiUyt5Zz/i0pjwhcjtkZYndfvSgRjC7/TbQ2DmIvNBfL59/p60JE8Fdxnm5h4efgd3cfNY4bKpWFzag0MGGVpYwkzEPBwgZoUK7qWscCvyrf71qKeGLmA6ldXDzTgsVXXpxYmHHeNlVNJJqicX9OAOSRGD0cPdomHSQRg6UGLnvHIffXuZcMirdfnkS4ELY+TxvIX2k+FUJTtZUXf4HUpTr4dbdWyt+AOSO+ejg6oyPcrdlnatFuR3ArgNKE96V954Gn6KycM9SSFGxjeahgn09ZYvzxG62kqM14n0HnD3Tyhx0yeGq8CfP9+cO5Ct5UXXvhBd6xsazNJHt6DuzAQqtX/jAYcuMHTzXtwovn7yeeNWleMA5ubv0KT0r0eGMNPABaGtUzFQWzZRqtfn1vwGxw2yDgegJzcn79STTbLI4g/UkrPUUvBezjb+ZLiJex6rU4zV9vrwtGq02UKwIDOq/CQCAp8W28AuUJcTbqZRx3aaxwBjqGW+Lyrs99PtzDVV7yzOe5QANsLYGbbDMkkF9dggnAbX7PKODJJrg9Di7AMyjZs5qc57xDbJUGhhaOX6n7ZDs4eig==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(39860400002)(376002)(136003)(366004)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(8676002)(5660300002)(66946007)(316002)(66476007)(478600001)(110136005)(54906003)(26005)(6486002)(6512007)(6666004)(2906002)(8936002)(7416002)(2616005)(66556008)(4326008)(6506007)(36756003)(38100700002)(83380400001)(41300700001)(86362001)(4216001)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KNodjc2femEDmITVCrQlhnS3+Ke9Y4rEoLbWaDAKzl57lhdg/3XtEV9fPxD1?=
 =?us-ascii?Q?88zwbie5Iw0pz3QU6IdlLRfrFXitD/WKQOanaJD8G+vIOFx7hjF9cUInq7qd?=
 =?us-ascii?Q?HAoM3CwNhCP1V8FcdUMm6HzctIAeKCGFNNfDXWlV/d3tPEc7JPQbCqv/2bWx?=
 =?us-ascii?Q?nuxbCMh+YPPyOo7+jacjZ3UXy3l0k7Zec3rH2MLVIPAJIinnqb4L9U2ZO8bB?=
 =?us-ascii?Q?shZy1kWHtI5e0tmhE9MVtazCFPVfqm7oyZhemL1Qwou+zqOyizBfALC6WiqB?=
 =?us-ascii?Q?M3FxDYN0ewLM+6xLEyS/wOMfX5hvyRVjSRVDPmSLKK1OqkKMyRwQ8OeJ38wu?=
 =?us-ascii?Q?0/BuiQT3M7BNN7Tx3X991ln7MzFFVAfrkiJ+JZ2T9UA3a0ib90sOETkMZC8x?=
 =?us-ascii?Q?82dHh8fSs62eA3Yt7aSQpkT7FaUXOxOFmOhGzWOJPp47TxGhp4iu6sqNrO9r?=
 =?us-ascii?Q?ZzjhNFV3xltdM+pFKjgp86X8ZiqmtSMuGfdtkAZr/k+3O5zI53v1hiBOjobH?=
 =?us-ascii?Q?+jjdKD7OJsaUheI7ULIrX1UI23FTWUSTBP8/UgKZRBI6O2LWbySEwPwE0JxH?=
 =?us-ascii?Q?SF0JjQDvXMp9rS5y55AVy8qyHXNwZOERPdHzhGMKpXyVnOlxQ8GENMjCy3y9?=
 =?us-ascii?Q?BflH0957OEPEsfnITfxO+W9/hgwz+yVjUI0AG8QQsIiYLyLQP+uQT4sn6f1Z?=
 =?us-ascii?Q?++JBY8VwMKEFzWo2P7rG1zrZtdY4Ldt0jsJ4UbcA8Vpwjv/zfQniPQkdJmC5?=
 =?us-ascii?Q?7vw6HL225GEO8y0vHJ+D+a4KydeF3yo1ryyfzZ2a7j8a+6ex8F6ds/wBTnOG?=
 =?us-ascii?Q?3vk4VbbOAFlkiWYwTANWTsquyBJY4ULLvCx4ra1hI4p1Yq3znz4AsvBVwaNX?=
 =?us-ascii?Q?DJxAEIXlCruEGzkbB2XSojRrxxjDtviBx21IQvhiYFMz3jzR61WrpvhxWeZD?=
 =?us-ascii?Q?CDkgq489Y+ZVjd50oUdP8QpfcNjZxhQ6EHWCpK6j31tw83LA7av9jnTyjb1V?=
 =?us-ascii?Q?2ugdsszqicXA7Jl5bZ62NZu4IQ7/10bVliz86JeQkv6d9KC0t4m6Xrbre0KW?=
 =?us-ascii?Q?U9k7BeNEzTH2JnUhD5ZjyLY1TAtvOIxWSl0XRYLSbKhB5alUqSdEmDhpyhk4?=
 =?us-ascii?Q?hhMAvG5rtS8NQOSWTV7/JWKUCLmRHjfVgWPLT5/yR8Ss8vMTs4aB5h4096EQ?=
 =?us-ascii?Q?Bf8ycCcKbVDUEY4rGiTZPoOf70hrzjmicZa9vPeMHnmza+j1VoIj0aZRgbF9?=
 =?us-ascii?Q?+kvu0n9H0H21rBeg8PteydvmKHGrB91s1UdrhabNKSYFjxKSBxKrr9cLwQBE?=
 =?us-ascii?Q?G4iv6U435dLHGo9LfbZolHbPDsycnT7vzu6XMFyQzwLJIXbojGQjPYcNILzG?=
 =?us-ascii?Q?XcvJS59CFkpmxhlym6IWFXt4Okde6hL1Yglh7b1QdC8En4F4/Lshzolz45YQ?=
 =?us-ascii?Q?VAfOA14GdzZV8s1KH8m0DQu36jOQrF6+cc+V1J2cmidHJP6CeqTgT9NuclRM?=
 =?us-ascii?Q?byY7eaTeg6uC4X5hlBe3P5vOicPoM/bv5JwtwCPMuNURYKM45U78cQQ2I8WI?=
 =?us-ascii?Q?mHEZcOZmDVP//s9W/+aYgFO2TxHp+wFz2ZNS6+yg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a3a7bc3-c980-4667-d6a7-08dc1e9ac947
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:33.1533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hFCRT6FvBW/nUe7UYeem31TppW8s+3NRS+crJxLrFmRNNIWjvHgsbsS3R2k0UZWE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7185

Instead of passing a naked __le16 * around to represent a CD table entry
wrap it in a "struct arm_smmu_cd" with an array of the correct size. This
makes it much clearer which functions will comprise the "CD API".

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 20 +++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  7 ++++++-
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 710016ec41af13..7798a53e14124f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1173,7 +1173,8 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
-static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
+static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
+					       u32 ssid)
 {
 	__le64 *l1ptr;
 	unsigned int idx;
@@ -1182,7 +1183,8 @@ static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
 	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
-		return cd_table->cdtab + ssid * CTXDESC_CD_DWORDS;
+		return (struct arm_smmu_cd *)(cd_table->cdtab +
+					      ssid * CTXDESC_CD_DWORDS);
 
 	idx = ssid >> CTXDESC_SPLIT;
 	l1_desc = &cd_table->l1_desc[idx];
@@ -1196,7 +1198,7 @@ static __le64 *arm_smmu_get_cd_ptr(struct arm_smmu_master *master, u32 ssid)
 		arm_smmu_sync_cd(master, ssid, false);
 	}
 	idx = ssid & (CTXDESC_L2_ENTRIES - 1);
-	return l1_desc->l2ptr + idx * CTXDESC_CD_DWORDS;
+	return &l1_desc->l2ptr[idx];
 }
 
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
@@ -1215,7 +1217,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	 */
 	u64 val;
 	bool cd_live;
-	__le64 *cdptr;
+	struct arm_smmu_cd *cdptr;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
 
@@ -1226,7 +1228,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	if (!cdptr)
 		return -ENOMEM;
 
-	val = le64_to_cpu(cdptr[0]);
+	val = le64_to_cpu(cdptr->data[0]);
 	cd_live = !!(val & CTXDESC_CD_0_V);
 
 	if (!cd) { /* (5) */
@@ -1243,9 +1245,9 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
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
@@ -1277,7 +1279,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
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
2.43.0


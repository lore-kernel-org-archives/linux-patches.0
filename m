Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B306D1C2;
	Tue,  5 Dec 2023 19:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Nl3yy8zV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IyIQh8QJuCC6R4aD5l6zh2xWolTbuaXstwVDVvqNbuOS5MhJYTHX2vb8NDjlT/1M/O73J5ecK/lp/l6mZi0HcQQRq3qGVg9JEKJ4cd3T5HYIYZqcLeNo5u2LZixOq+atzOMtSWidF7nwuk9aY8jg7kmRkRXIWoEYpVaHoR2x+A1/49USHnThD7HT1Bf69cTkELn6vrKT5upOyP/N1wRFbhY91N8E/OKUY/3gGbxqCqw53xbg3217OBp/YKB2S0bF6OgZrFwpT0EHNBin3nSDdsZVuDFDhby6PzF2B7UAPwJTsyIqzh37G9RxMy/FpMreOejhQdskKeFT6vpwmffenw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3zZEsaOEbLqewWkuUrqPJCS514Vt7rPhcCxwcmcW/dg=;
 b=Tj8Li2OmSYvPUBpryLeNeoGs8CgQ6hEx3B/1tK8oGvbS1XQRvQ0hrbrAIg8vz8UznKal1o4CyH8qO6hb0RrFva2fNPnnhlFCU6xWJH6O4aTMTiQPnervSt+4GrwWhqh+UPKb64z8Azz9TOfAqmO/OWD052ERnDZ9XIYXkD2irB+13ZV/d3ws+F4Y3kNdlq6KYO93ZYVP67mP9w3V0XxLnjjcChv/ZB0Ar9906foSFDpIENLnCnq6IUKYeOnaaZWHdkxb8m/QhcV0emq+el0YXi4gXpVti7IIPHONjkUgfEqZoomvBBTYokzrJPsh/s5UAFLRwd0iahMp586Y0ei1kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zZEsaOEbLqewWkuUrqPJCS514Vt7rPhcCxwcmcW/dg=;
 b=Nl3yy8zVk0t4f1OXkASaw0rSWF6wED0igbvM04y+etgnvuGS7vwyId3b+pWffPSSTsfh7/K04+UzJcc+xt/CrqUuA1aSo393ZRDTe8Lc4pQTk8alr2F4UwceM2+6R2zjuc1p1JzPQM/zpzOzEy5E0R28cmROAeKxbdVD4g5eHnKVZO2PgD7Xs/l5x4bXugzF0JA4aMuKG2wbqMfzjNs8Yzf1mB+vnY525wFS76Ib21wAC9yorirm2faus9LLBiNTw5FOk9/AqLRMNtTjPBInYfgRzXIorx8xkr6Pp1Rr/q9G6Qx6wEkt3Yryc/c6BScsAM2pdmbkL0XhVylK7Q/Sgg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:14:58 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:14:58 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v3 08/19] iommu/arm-smmu-v3: Build the whole STE in arm_smmu_make_s2_domain_ste()
Date: Tue,  5 Dec 2023 15:14:40 -0400
Message-ID: <8-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0050.namprd15.prod.outlook.com
 (2603:10b6:208:237::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: f7082f5f-729a-4c74-5f03-08dbf5c67591
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	meAToBFJzXE5wHT32Cx7P86SG2uEPZ7+QvPTNczrLt67GrDF3ojry4SDHfMxk7KSBe1/oAtb1fQG3gCDb9MODUgqCyo616dyrYPcVHDp97glQ4Dsk/UdXF6LntZ8RFgsCWFQsnKx2br3jJDcKjTNg5MmA37AcT4yzw9KmHozWC2RjGX+T4gtWaR6++VmjiJx82IjofqPbz8MZ/Tb+57xSKIWwzd0uvXjeDWEDN0OwKJLcJGOn1frTXaYyE69qq+JQMURzhvNB2wdZXXhaSuPHwV9wOQSWsVyMrvAY+Ru3HbIOEWFufI0CK0swXprjw5c+5xfmUVCgjWVJD6ljsSKEqh+4ToMCkPuP8c0OfHgVZiFmDZRZc5EES1OmUPdQNZW6TmECoyvyMdhlEKYqylVNeJwe7Znzad5ueXZW6ZPw1e0aFvgkIBX0bHePHPgeFSla/0+MQfYLuxt1Li0IEK/rbuFx41H1585INu96WVLCzCOJQbn+T4rNmkLdv5kdZgcHLT4bZ3/rZk6NWzo96M1JIwpRmbsFhgqBv15yTh47WC3X7N4jJRrl0M9VM3GVMkXtfvcyl/jFz2oTIEdrnCrwOeuSbXLBUQFYi9MSlo2W0E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(478600001)(6512007)(6506007)(8936002)(6486002)(2616005)(26005)(6666004)(54906003)(66476007)(110136005)(66556008)(8676002)(66946007)(4326008)(316002)(83380400001)(38100700002)(7416002)(36756003)(5660300002)(2906002)(86362001)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FQ8z9liuCnvur7FSopvmonKtwVNAt/uVigWpxBHH2rh55sEwpfIeuNEPlpHh?=
 =?us-ascii?Q?UIxfx1MgYdiHWwaJUGvs3AQiptFqQvxhK8BDO9MYyT6XbOo9u82Hpj1ZT6OP?=
 =?us-ascii?Q?OmNnFecJJxfSRfhScuh9453VzSRUXwgAKcli3zUcqcS5j7AYl670KN9QsW2p?=
 =?us-ascii?Q?+w2mz811XY6O+bOIA3+oUG/BAYgiWNqtTrAraX7ozOId/FkakCxnVhVRlzE4?=
 =?us-ascii?Q?ROpVBvrliwP2aTWM1zseE49AjUEY9b+dbyXPR9g5GApxJdXKzba80lCnpoWZ?=
 =?us-ascii?Q?KChn1IV8YNu2r1SpTf5bhhCVf/rfqyGpHAv232P9NaZ39Iuj/sn3pYjTH2x+?=
 =?us-ascii?Q?r4K9Ph6olQRpMLOyW9ykMFj2HTEyjHEQOwjGh0hLTpF378vec0IZ4OwfV+s1?=
 =?us-ascii?Q?uQdjh+7SQlxnUx2quq7GG04x7O7kn93jSGgJ18V4S7L6pf49aBTz0xgKZdg3?=
 =?us-ascii?Q?2VRl8NGomrzJ8zqgNr5ajPONi9lXB/0foiFTtgEQJx3qyW8hkUdRhDaN+Sox?=
 =?us-ascii?Q?d/973IbhLLLaxe4RkeSJG9575aDG4F5ra6AexzPexeR7hjwTlvcRQIbA/G5v?=
 =?us-ascii?Q?Rpt8sSQaIZpD8mv7BGvfIwdPxRZD5Dz7+B9DgVnO3gxyLAOTYq0qt49TiZLb?=
 =?us-ascii?Q?SniGk6rWkZFuwtgxzlvAQYgrts605Ih1BAu0LnEYS16nhVN9YVOWuCIOC0Gk?=
 =?us-ascii?Q?s33u0nGwo8KDngXNOrnRCUR1lZcbHnt1cMvc8v2E64HeW1LMWHwtjV1K7ZAH?=
 =?us-ascii?Q?Zhj+78yJcY9flNEDzEC+8IFubwpiUjPE6Ea1Y5JpwQ5W99spX+aF7WvWkOm3?=
 =?us-ascii?Q?38mtkvQsVbuiRwbkhlVANaD1ZB6k3OmF/6zavI7ADYKezSC7NPQNtz18oFEU?=
 =?us-ascii?Q?8D8563m9SSve6VPDkBSGvkU/ZON3fN2IfPqnMzPGGDNCPfBxH8jDlGMBYAst?=
 =?us-ascii?Q?r1n+HwMYy2DFqGAM+Aq8geazhQL5ZQwQEsVI45nOUtHHNNduD8vdc8XcNXli?=
 =?us-ascii?Q?5gfyZeeIJhP9xh36lThzdsZJIe0ijSHHDjLgwEkjiVjp/xMjOpBrH7jGmPE8?=
 =?us-ascii?Q?eLGdkHWi3+e0sXYloEp/9lfD6M/SUCV5OxqHICbwzCXHRuu7A087pQPzpQZt?=
 =?us-ascii?Q?8k+U+tyWmqjCkmwYvBPv4q41UhnfH362oRWJds5HrJPvyPnv+aCPX5M6PG4Q?=
 =?us-ascii?Q?XhNQjMg+rMNm2gRtifSkIUJTgTLeh+CxK4g1QBmpvKhriq9Dw+OnIdYnbEQF?=
 =?us-ascii?Q?MmMurhqM3f1XirkGGx1HLZ0wRUDlH/JT1zq6PyuQJCR6MrE6UvxvpR1AR9TF?=
 =?us-ascii?Q?AW6L24RQoOHYiTOq4Nnkqv8sLgL+Qcn4Hd9W2CBB50kw/m+hNgRgzdIWcurX?=
 =?us-ascii?Q?UylRoJeTP1gaDUwGvYFFv1/KEUrgHnGMlBS+w1rk8PifCbIrUh/1vdOe/yHn?=
 =?us-ascii?Q?0jDFmJFmRXgJsKNV+OnA+hbli/jIZ5QFBwjbtcuJ6Sx9BxiLttBqUSHrIUQm?=
 =?us-ascii?Q?+93fUCPWe25NRP9VzPtJqJsyXWtB7ZinHktyEHXIqqEce7TTYqQS2Mn9PKyA?=
 =?us-ascii?Q?Li0QXJX4mESM1vFBdVupuBnFxtPF/pAPEq2eYTw8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7082f5f-729a-4c74-5f03-08dbf5c67591
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:14:52.9278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AiLqQVXnbnkB/a3A5y42+st0k9BtbUbsTPCjXX63aJkgpOnIwOPuG63YTwVAJYHL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588

Half the code was living in arm_smmu_domain_finalise_s2(), just move it
here and take the values directly from the pgtbl_ops instead of storing
copies.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 27 ++++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 --
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b3b28c10bd042e..e2ae0081c47820 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1499,6 +1499,11 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 					struct arm_smmu_domain *smmu_domain)
 {
 	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
+	const struct io_pgtable_cfg *pgtbl_cfg =
+		&io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
+	typeof(&pgtbl_cfg->arm_lpae_s2_cfg.vtcr) vtcr =
+		&pgtbl_cfg->arm_lpae_s2_cfg.vtcr;
+	u64 vtcr_val;
 
 	memset(target, 0, sizeof(*target));
 	target->data[0] = cpu_to_le64(
@@ -1509,9 +1514,16 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 		FIELD_PREP(STRTAB_STE_1_EATS,
 			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
+	vtcr_val = FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, vtcr->tsz) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, vtcr->sl) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2IR0, vtcr->irgn) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2OR0, vtcr->orgn) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2SH0, vtcr->sh) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, vtcr->tg) |
+		   FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, vtcr->ps);
 	target->data[2] = cpu_to_le64(
 		FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
-		FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
+		FIELD_PREP(STRTAB_STE_2_VTCR, vtcr_val) |
 		STRTAB_STE_2_S2AA64 |
 #ifdef __BIG_ENDIAN
 		STRTAB_STE_2_S2ENDI |
@@ -1519,7 +1531,8 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 		STRTAB_STE_2_S2PTW |
 		STRTAB_STE_2_S2R);
 
-	target->data[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
+	target->data[3] = cpu_to_le64(pgtbl_cfg->arm_lpae_s2_cfg.vttbr &
+				      STRTAB_STE_3_S2TTB_MASK);
 }
 
 static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
@@ -2276,7 +2289,6 @@ static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
 	int vmid;
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 	struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
-	typeof(&pgtbl_cfg->arm_lpae_s2_cfg.vtcr) vtcr;
 
 	/* Reserve VMID 0 for stage-2 bypass STEs */
 	vmid = ida_alloc_range(&smmu->vmid_map, 1, (1 << smmu->vmid_bits) - 1,
@@ -2284,16 +2296,7 @@ static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
 	if (vmid < 0)
 		return vmid;
 
-	vtcr = &pgtbl_cfg->arm_lpae_s2_cfg.vtcr;
 	cfg->vmid	= (u16)vmid;
-	cfg->vttbr	= pgtbl_cfg->arm_lpae_s2_cfg.vttbr;
-	cfg->vtcr	= FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, vtcr->tsz) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, vtcr->sl) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2IR0, vtcr->irgn) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2OR0, vtcr->orgn) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2SH0, vtcr->sh) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, vtcr->tg) |
-			  FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, vtcr->ps);
 	return 0;
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 27ddf1acd12cea..1be0c1151c50c3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -609,8 +609,6 @@ struct arm_smmu_ctx_desc_cfg {
 
 struct arm_smmu_s2_cfg {
 	u16				vmid;
-	u64				vttbr;
-	u64				vtcr;
 };
 
 struct arm_smmu_strtab_cfg {
-- 
2.43.0


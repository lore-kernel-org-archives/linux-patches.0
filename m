Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252426D1B8;
	Tue,  5 Dec 2023 19:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="f9/wjwR7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wj2/bGQDSBbLjpHx+HCjJMe8h0THU4KZ0TFVQp4WE4gFZjV5+RIgdVCiB9fu8ivEWnXfJdZf35Lh/oALw0s4jdw8jjPmyEnXxbWFM1p7CbEf6PlE+Y6BQJOPEaAqTaHqvpfVIJaoeDuoxKyBUmUNdagZAEELNYeI4xK8hHRad4L7R6G2T9k019FAbLGRqZorAhnoNHb8WZVkii7NiXKZgq3SXguKk0kj0W+kOx7E3SvcFsl3O17sl6/1AA+e0HjmevnC3unl6L3G4kB8Bpv29n8c+d23FUhuvYAsjwr22ddhfmvluLkhnkE18PC70Az/s9/Kr8IsNA96PzXtOTb2Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PQwU4MN35aSOM42cTYFmZmzHd+D00v/ov4+3QGRJu4g=;
 b=WneBtyEiAMTnvv9cUwEe71iMl0BFCSwgpFddSGQ5w7joacqe/y6ZzzCoRBQqVUsETjy9mAptaYj2qtFWcqnJqjOjraYoOjaERtZIivR7RPpAtjeHcUPRFDKp3ylZdniXad52T+vM8mJq1EOnu2Tpl1iy+IRQQsO57S83nyQwpQMluECtJxnerIobfU4elBhNq9cLPLYGPSvC4sbtL4uT+tTR3JPAtOVHGZsY16YvFtpaR4HJl5hshrYQeaGxTV4PzMZ1/Tu57FI1BdQPm9a47FkmgcxE13ilQIWQY3yTyPdVxsKgQP48suJI2SiqgZpLyoAY64rKu0Cn9h1qjR7Q2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQwU4MN35aSOM42cTYFmZmzHd+D00v/ov4+3QGRJu4g=;
 b=f9/wjwR7qQgK/T0R+LhkS0GakfvtLCplfcXUN2VYU9/f8UxZjOcfGsalRrXx1cru9OLE844nh2xH0DEvJEDqYR3OdVSHy0fHvIlCwN6rdlG4b2PT+wzALttrV4mYrikehZ8ExOMuc01er2mgXFJ8+5VZW7WZ7vtjSF3DZwtTsf7qlWC8G8I8seeTdL4NOnYORPTB5PiWDm1JUdsK2PqYrTbcY3jnbZ8bKQLxP65ssM8guO3u5qWNLroeFnHGxR6oC3EobI8zkNJiuTI3/Csi+yV1ix3BA+7hqWlHLTShSwmigKdpmAFJEs4Y4Y1jztHWVNiCsZNusID7uZTzeSRyTw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:15:03 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:15:02 +0000
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
Subject: [PATCH v3 01/19] iommu/arm-smmu-v3: Add a type for the STE
Date: Tue,  5 Dec 2023 15:14:33 -0400
Message-ID: <1-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0002.namprd16.prod.outlook.com
 (2603:10b6:208:134::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4209:EE_
X-MS-Office365-Filtering-Correlation-Id: 81465e1b-a8fe-46b0-7e10-08dbf5c67652
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nItANzY7eaVgwJVVa8ntCwKmNvWVM4kCmlleuaIuIoMjqxVcp2hFzttt+vg7BnUxGXI2ODN5D1IO7j6Eu0jDQhjLuaIe0pkotaWJwNVpw6d0X18VRKDrBSxeBT1i1i4uVoz4MpVx28UH/F8fz50FwaJq/ZfYRSQaIQ0zz0YKSqPlGvYVB8SPdH4dbYuY0Bmj5z5EQEldwnSRXUGdh6DnUCg/D02YVm72dvQh+q5pZcgmgIpdYtXSYO0lLlNst2cxuMJzItaIQpRFgnp1BQivULmTOtJL4EvYSU4DzgBvypbU1/UxzfL7LdNXJ22/f9nmn63KU0PHSQhTUk1pykxzAtxzCUEF/Qo/uCcVZPzybtO9htYXWOaxXNrhiqrhtDpK5hl77mDOYWxd5z2N3ezYi/TmT/7jq5Z3NqZX4OGwCcYn1NBUXB1wMbvW+BwY3Fu/68qb90wghNvlpa5TwnBqZD/1ZHZ79jgHHGDZ63u0+V9h4CaAy10J2V1Mw7F8ih5S4PpRNTH0ps6DUr/n3ZA0ymX9XczCc+0ZKoRby9gSNpVu1CThemvjhwiy+bTk06FyWFkzMpxSWNtAsWUJQoq0xbqKGWE5rNmxstpr/GsIV5I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(366004)(396003)(136003)(346002)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(38100700002)(6512007)(6506007)(6666004)(6486002)(478600001)(110136005)(54906003)(66946007)(66556008)(66476007)(316002)(26005)(2616005)(83380400001)(8676002)(4326008)(8936002)(5660300002)(7416002)(2906002)(41300700001)(86362001)(36756003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mVT31T2MN9LwUbfljMqjTqwKTTas7iY1s2mUSGfRUlgFvnjgB8odyf9lvQGI?=
 =?us-ascii?Q?IqoNL1rkfJ31ElgueSyZPQ0xpZlQo0DCRN6iqC3iGsR5sVt46IKqFQw4EFFm?=
 =?us-ascii?Q?MNao89g7wp4BmkBaeVnT9cNuiL7C6ZXL1vV9M7YadwpzxFrJi7LX/UhagGzH?=
 =?us-ascii?Q?U+GwESaSpLmjqwCQtKKuG1WwI0qCK2zsPMBykkPABIa5NLURSOxFwGiZnDWe?=
 =?us-ascii?Q?6z/Jd274I5JuX2ZfPaijrxupojBYXRKwbM8wqYdak0DCXJ52UynmDXwqL+az?=
 =?us-ascii?Q?mULtg/9jNe15bTju3lt9/gy+WrAPUxM1VwbMFsaM4W8tnpL5iiYLFkhgMpeM?=
 =?us-ascii?Q?YYjNZlQ10CMDpyBB/1C1yJq3wZPuyr2+4JSC2WZietdCzVbiDbBmd4zrYGDI?=
 =?us-ascii?Q?618IEYw1l87z+lIAEyejfY1dgFCAeBm0UUBNlp/6Xv8E3YGY/XveVWWj/D/O?=
 =?us-ascii?Q?99ncE7xa/+atEYoHUc6pfmAgFT7k16wL3jd3lM4idNeHh7sVPd7tFCEyCTgr?=
 =?us-ascii?Q?n8X1E1tJ30oAKkrV83yFl0qY1+PWqboItoOyxj+NrTmNeFSsc5c8skKbKBWI?=
 =?us-ascii?Q?Tuiub8yYc90LXLJyNgi+YHUIkn9hW67LiqRQJvvhA26x4zre32pMQDn7dZUI?=
 =?us-ascii?Q?j15GbWwx5n8/3RQmkXN1kET2rWUOoCz29mrvSRHKIHFzLdRi23V5WHlMyUZn?=
 =?us-ascii?Q?9r6EVbQNRRNq7d5u9Xmkxl19qK1oLs84K1+gcjXeh0u9UPVhCdPv53jMg84q?=
 =?us-ascii?Q?t9ugC9m2m4egJZEZb2npijjIyQpbOAGc/WoLl9MCiFTKHML6bZH7pq2j66dS?=
 =?us-ascii?Q?Vt1r3wFtCrVnzFDF3FzzB3PkLIDTGCqGR4TwEJD+fTLlya9+3cKmRHXO1PTB?=
 =?us-ascii?Q?BMdbTghmhx+6siS7VjyduEYgz7CEQnnVzWun/0WaqPWr5fcP66A+Ky3U8VYM?=
 =?us-ascii?Q?kOEOOBV3CjY9/kz6u/392WtB5Bc86oo8KoYwOahNvSDPqKbR29y6e6OtvVHQ?=
 =?us-ascii?Q?MbhIrcqoQCfnzaiaiN/lmIRzslV4vdHmiytC8yzPX0t2ckctKwQuwb3F+Ffs?=
 =?us-ascii?Q?jQzy+RXVMt1dzqHP6dIYGPiGTJ0ovhCyqabcMOkiOwtpeKTYRW+wllooKoxw?=
 =?us-ascii?Q?KXVEJaiCmjBn98MNBzmkUN5/HwgBdNxRb5MxZq8Z2ptCKdq23J/tizGYsXfz?=
 =?us-ascii?Q?K/vd64+rPPXHeohB7NgzE5q3ZaKlC6Hl+dKymIsOjkkZqGxZkZuXf0sHgPS0?=
 =?us-ascii?Q?i23TK75G54ROx+7zHmdGjj7iBq2OnVTI6d4GZTIVpqzYFxbAWogKXt2WkeC3?=
 =?us-ascii?Q?skfApsbfa6LbT0DFMz6PIHMCLP+ms8JXcr3EggIGYgaHiqh60k8t0YruicG3?=
 =?us-ascii?Q?t/tJvberrkKKY1lRuvYapP682GLZzuqQ2Xq2nm05ISTvs8v/5BqPLKIwp+Re?=
 =?us-ascii?Q?mdA8igDvhqQDKmQyS9D6ABsZcXJ1jfYRCqaLg0RlkwQUQo7V9EvwFuYPAyUd?=
 =?us-ascii?Q?AaG+CBZeJ+EMBcx/TVuuYhg6EZ0E1MwOmQauH2z34Rlx8AzbGNNOjaNnA+hs?=
 =?us-ascii?Q?Sg6ousTJ+S6b5BzqDMw++trjDGIVYXN8NdjHDHtu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81465e1b-a8fe-46b0-7e10-08dbf5c67652
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:14:54.2163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MTH7jBG1g0GVV60bPFjzEz3PaF8FUgNvIOoIhWAI+ZpuMgbOlmKYefPbfmruh7Lp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4209

Instead of passing a naked __le16 * around to represent a STE wrap it in a
"struct arm_smmu_ste" with an array of the correct size. This makes it
much clearer which functions will comprise the "STE API".

Reviewed-by: Moritz Fischer <mdf@kernel.org>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 59 ++++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  7 ++-
 2 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 7445454c2af244..c5895f4d7d6c9d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1249,7 +1249,7 @@ static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu, u32 sid)
 }
 
 static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
-				      __le64 *dst)
+				      struct arm_smmu_ste *dst)
 {
 	/*
 	 * This is hideously complicated, but we only really care about
@@ -1267,7 +1267,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	 * 2. Write everything apart from dword 0, sync, write dword 0, sync
 	 * 3. Update Config, sync
 	 */
-	u64 val = le64_to_cpu(dst[0]);
+	u64 val = le64_to_cpu(dst->data[0]);
 	bool ste_live = false;
 	struct arm_smmu_device *smmu = NULL;
 	struct arm_smmu_ctx_desc_cfg *cd_table = NULL;
@@ -1325,10 +1325,10 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 		else
 			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
 
-		dst[0] = cpu_to_le64(val);
-		dst[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
+		dst->data[0] = cpu_to_le64(val);
+		dst->data[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
 						STRTAB_STE_1_SHCFG_INCOMING));
-		dst[2] = 0; /* Nuke the VMID */
+		dst->data[2] = 0; /* Nuke the VMID */
 		/*
 		 * The SMMU can perform negative caching, so we must sync
 		 * the STE regardless of whether the old value was live.
@@ -1343,7 +1343,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 			STRTAB_STE_1_STRW_EL2 : STRTAB_STE_1_STRW_NSEL1;
 
 		BUG_ON(ste_live);
-		dst[1] = cpu_to_le64(
+		dst->data[1] = cpu_to_le64(
 			 FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
 			 FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
 			 FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
@@ -1352,7 +1352,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 
 		if (smmu->features & ARM_SMMU_FEAT_STALLS &&
 		    !master->stall_enabled)
-			dst[1] |= cpu_to_le64(STRTAB_STE_1_S1STALLD);
+			dst->data[1] |= cpu_to_le64(STRTAB_STE_1_S1STALLD);
 
 		val |= (cd_table->cdtab_dma & STRTAB_STE_0_S1CTXPTR_MASK) |
 			FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S1_TRANS) |
@@ -1362,7 +1362,7 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 
 	if (s2_cfg) {
 		BUG_ON(ste_live);
-		dst[2] = cpu_to_le64(
+		dst->data[2] = cpu_to_le64(
 			 FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
 			 FIELD_PREP(STRTAB_STE_2_VTCR, s2_cfg->vtcr) |
 #ifdef __BIG_ENDIAN
@@ -1371,18 +1371,18 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 			 STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2AA64 |
 			 STRTAB_STE_2_S2R);
 
-		dst[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
+		dst->data[3] = cpu_to_le64(s2_cfg->vttbr & STRTAB_STE_3_S2TTB_MASK);
 
 		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS);
 	}
 
 	if (master->ats_enabled)
-		dst[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_EATS,
+		dst->data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_EATS,
 						 STRTAB_STE_1_EATS_TRANS));
 
 	arm_smmu_sync_ste_for_sid(smmu, sid);
 	/* See comment in arm_smmu_write_ctx_desc() */
-	WRITE_ONCE(dst[0], cpu_to_le64(val));
+	WRITE_ONCE(dst->data[0], cpu_to_le64(val));
 	arm_smmu_sync_ste_for_sid(smmu, sid);
 
 	/* It's likely that we'll want to use the new STE soon */
@@ -1390,7 +1390,8 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 		arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
 }
 
-static void arm_smmu_init_bypass_stes(__le64 *strtab, unsigned int nent, bool force)
+static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,
+				      unsigned int nent, bool force)
 {
 	unsigned int i;
 	u64 val = STRTAB_STE_0_V;
@@ -1401,11 +1402,11 @@ static void arm_smmu_init_bypass_stes(__le64 *strtab, unsigned int nent, bool fo
 		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
 
 	for (i = 0; i < nent; ++i) {
-		strtab[0] = cpu_to_le64(val);
-		strtab[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
-						   STRTAB_STE_1_SHCFG_INCOMING));
-		strtab[2] = 0;
-		strtab += STRTAB_STE_DWORDS;
+		strtab->data[0] = cpu_to_le64(val);
+		strtab->data[1] = cpu_to_le64(FIELD_PREP(
+			STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
+		strtab->data[2] = 0;
+		strtab++;
 	}
 }
 
@@ -2209,26 +2210,23 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain)
 	return 0;
 }
 
-static __le64 *arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
+static struct arm_smmu_ste *
+arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
 {
-	__le64 *step;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
 
 	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
-		struct arm_smmu_strtab_l1_desc *l1_desc;
-		int idx;
+		unsigned int idx1, idx2;
 
 		/* Two-level walk */
-		idx = (sid >> STRTAB_SPLIT) * STRTAB_L1_DESC_DWORDS;
-		l1_desc = &cfg->l1_desc[idx];
-		idx = (sid & ((1 << STRTAB_SPLIT) - 1)) * STRTAB_STE_DWORDS;
-		step = &l1_desc->l2ptr[idx];
+		idx1 = (sid >> STRTAB_SPLIT) * STRTAB_L1_DESC_DWORDS;
+		idx2 = sid & ((1 << STRTAB_SPLIT) - 1);
+		return &cfg->l1_desc[idx1].l2ptr[idx2];
 	} else {
 		/* Simple linear lookup */
-		step = &cfg->strtab[sid * STRTAB_STE_DWORDS];
+		return (struct arm_smmu_ste *)&cfg
+			       ->strtab[sid * STRTAB_STE_DWORDS];
 	}
-
-	return step;
 }
 
 static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master)
@@ -2238,7 +2236,8 @@ static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master)
 
 	for (i = 0; i < master->num_streams; ++i) {
 		u32 sid = master->streams[i].id;
-		__le64 *step = arm_smmu_get_step_for_sid(smmu, sid);
+		struct arm_smmu_ste *step =
+			arm_smmu_get_step_for_sid(smmu, sid);
 
 		/* Bridged PCI devices may end up with duplicated IDs */
 		for (j = 0; j < i; j++)
@@ -3769,7 +3768,7 @@ static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu)
 	iort_get_rmr_sids(dev_fwnode(smmu->dev), &rmr_list);
 
 	list_for_each_entry(e, &rmr_list, list) {
-		__le64 *step;
+		struct arm_smmu_ste *step;
 		struct iommu_iort_rmr_data *rmr;
 		int ret, i;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 961205ba86d25d..03f9e526cbd92f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -206,6 +206,11 @@
 #define STRTAB_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 6)
 
 #define STRTAB_STE_DWORDS		8
+
+struct arm_smmu_ste {
+	__le64 data[STRTAB_STE_DWORDS];
+};
+
 #define STRTAB_STE_0_V			(1UL << 0)
 #define STRTAB_STE_0_CFG		GENMASK_ULL(3, 1)
 #define STRTAB_STE_0_CFG_ABORT		0
@@ -571,7 +576,7 @@ struct arm_smmu_priq {
 struct arm_smmu_strtab_l1_desc {
 	u8				span;
 
-	__le64				*l2ptr;
+	struct arm_smmu_ste		*l2ptr;
 	dma_addr_t			l2ptr_dma;
 };
 
-- 
2.43.0


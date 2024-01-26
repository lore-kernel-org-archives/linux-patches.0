Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0B8208DA;
	Fri, 26 Jan 2024 18:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292945; cv=fail; b=mLBa5w8+Whr3h8PyWZGE4fWQcWwtyQ+9IzJ8pwA1+PSpu8rQX19XXeiblBOSADqWzMyEglG5akcUU91Wg7vwZEhD/pcGs6V/x8uRC0Y972QxhSJxYJpjRkOcLxSuhItDfjDDmlyWXwwlqjgHIaKWncOU5ebBckUfFcwurbDf9J0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292945; c=relaxed/simple;
	bh=8ZjLVriLxsMxHocRRl0fMImyR+s2fdVkF4WTLtEJ1fM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ce4il5eAXjkzweJytkJNobWFf+HOpOA2AMG/2EpiICD2jTxbkc+cNLeC9QK9OKwcRXp7rXFxmOTKl7NUQEI8gvvHKsJXJer8tTMyQxIV9IDa0EW4SUD+8UgieQqA3d0mlPz4lokKPuH3WCxJms1ZcluPwjEsigsIwnlPeSCsmMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nD7+0LKL; arc=fail smtp.client-ip=40.107.93.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nD7+0LKL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHWHyPtH/sB/IxKGrtxCjH04fO7j7ov95bn/VCUYxxENhPTqFh8ztZe57Mp8qIOO5tV34ENZUhKs+LnUFd9m9GMUmhos9TE9hCi6zU98y3LGH56CuuRSxrEFeNOL78r5e6AvRkYNZxVlDFr4Jb9qYwUggN+BXSzq7pG+xBS74Qm0BtcpdBIhMibduIT+GieVp3kr4Jj/C8CtOeXwWTBLtVlTg9GRS4b4hLRQ68hhCFzoVQKw8B4q6sqVz2szqY/2A+XveqqTVKpoqYo75D3GS8vNMXNF67nW7hPZQ7QueMkurtzwv5CRW8L8VkvHLjfSIoIoi+RC8DgOm+UDjoPHOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VikqWDayINgkNvq46QvfwkTtQZDljYcLG4ml/NN+I0I=;
 b=EuARnW87ICan+hHJOnTvIGjwJBnZRs3Icpk8rTg3PrTLY4bra8Ugvpa7m6ml9bhxyhCtcDbTyFQ1tA5F544//fddVZ3IUbgrUJwp+/2brDMFDEkpirIj+vrfjJSPwBuhHXiUn2BdguVymFqLs2aXunUwIEedQT+o0CjuE3X+0P9dVzWl8C/H5fCT5SRIKCpgMK2LK1A60P3T4DM9mnRWiN38Vx1oGhWQEa6nRnzktLQgjNnNNV4Dg0VSXMuRSNKrz89qoH5+R9iuyisKZ03o8Rkty6sJI9C9128sH3hrcW4fAgkJ5R+FHY6So6E7d9+S3TLDcqakq/b1Sg5XFgyUhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VikqWDayINgkNvq46QvfwkTtQZDljYcLG4ml/NN+I0I=;
 b=nD7+0LKLajYdDnyJfkxXabt8TIBoaz3PhILcMGkiQqJaw54NWIXeAls5idkuWadCNsbDI68zfxBxtSllvPjYkAyImYR2mH2nIPoKjTPGOn5oww5BXFiQ7GXNxF3nut4LYf/DoMofYvGioLjfnGFClF0ex46h4mvXbOkOldkvcryw4PVwQxgnsoRe3ot2uBSATxJJX0YJopNigr++EJK1D/GHfREfz8xsxjJQcsdBlJcux1fvUXPe965wx6VM5o12CXj/fDKocsefWCxfvLmbkScUN7podTf5hVOuKIwNnKDTR3/Q+GPzD2YJxHYOA+IKE84tfiFfFMopFYRPcQb8yA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7185.namprd12.prod.outlook.com (2603:10b6:510:201::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.29; Fri, 26 Jan
 2024 18:15:35 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:34 +0000
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
Subject: [PATCH v4 21/27] iommu/arm-smmu-v3: Put the SVA mmu notifier in the smmu_domain
Date: Fri, 26 Jan 2024 14:15:23 -0400
Message-ID: <21-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0147.namprd13.prod.outlook.com
 (2603:10b6:806:27::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7185:EE_
X-MS-Office365-Filtering-Correlation-Id: fe70f325-453d-414d-3698-08dc1e9ac866
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GfNgrdZk6ueIt2UFZJKqueTwNv5OElRUkuNBuOmvNQJ1xy1b5nEN8/s4GzkxThGyHGUR0fISBXHBU9ptLwUWffsnMjUrd1U7cIuQTlDmcXTtns7z0R8PfSRRgP+lNiAE6ufPtT4DdPCKdea+6KehlBj6Py9rQjyrgDr/MghVr6bIG1TNRdkX1GwWwjrcC6wlnNdKICBcq8rpKsjVvkobyMbiEIX1uAS/BhGor4z3SLp+VhcpiNiiZsn1DfBOjvA7zwGl++1lOPNB79RGBYmK1+yN9oon5a+NzTlp/mVZCjfjySUAHIQd3UfYdae6ZfjP3nI0efBOyWySigLv3ys/u3PatLqmhjXpKTPIq/eDeoldyyoLOrGUwaiEp+gr37/NjFnlXwq9HnRYFEgonAUkqDTWsY965wrZOntSXZPhGyjyEFMePnb+WwFiLdkFfaG9fsvFBUwfrQ+MFmo7ull5MYD7O/GrlXZM/BeB/rtQBY/ErBtkhf8GDFJl1hzKXl+y8yu0suk9afjeUVKfF6d0V5J0SWX6FUzeQXgtH7SKkEb8U01Gd+U87yJCb3E8YAMT
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(39860400002)(376002)(136003)(366004)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(8676002)(30864003)(5660300002)(66946007)(316002)(66476007)(478600001)(110136005)(54906003)(26005)(6486002)(6512007)(6666004)(2906002)(8936002)(7416002)(2616005)(66556008)(4326008)(6506007)(36756003)(38100700002)(83380400001)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BFOOMM8pjvflNO1sJDRiz3xesYlKhwypxXsPvW8KFaRoL49YDvC4unQ9DwQ6?=
 =?us-ascii?Q?PsoVPXnzLHe/VCRL9cGHPPvPUlhyHgYwDwMszftOcw8YNombeHsvs6famyaS?=
 =?us-ascii?Q?bWwC13D2QQoFk1z7K2m1u+9qIRDx+4BnFp9NC2Y1j2LZgUCsx+/nuJ45ACKO?=
 =?us-ascii?Q?6gtNH8eNSTUkNz9eEuNxZpJtDcD4CT+JUtdXFuzFagqknWPu9n1OwZc8V07u?=
 =?us-ascii?Q?x0Hl1C7yim3gKImP8JQdJLGcejULesQ57z25zBIoZOO9KPpS2N61buW67UTQ?=
 =?us-ascii?Q?tl/TDiqpIt5tGZRS5gMtoILKGxnoBqTEFKDp1cTTlIdo3DxyGZlnDzBg0nqU?=
 =?us-ascii?Q?/n6a8DQsVrYvQ/9m6x6I/z7HOGVzmuBfUen+vRug4NBgSpFeS1xxzSPHF8fA?=
 =?us-ascii?Q?rqWse+HsBTkpmKkB/KWMMQvKRORHpJTueDFSTheR+H/h4QnI12U+paZZRZnP?=
 =?us-ascii?Q?vRCcdl9CiJbU/+NpHQL7bF9MzsYfgcBgXcR2WUmxoQuoEOPraDK/VaLMOt1g?=
 =?us-ascii?Q?GODN+3z4iI2dr23htInLzQ5U4JOAuEki8UBGkQ1F9TUDXO+LeEVlY5vHVUKF?=
 =?us-ascii?Q?a6wz1GqF5GsueeyAGeDmzmCT990svBRSq884A0qN7WlTzT9dC7e8zHOp6k6q?=
 =?us-ascii?Q?ozriYOApw5/Cug8EnS4LgYmkX4+2ZOiWOJP5h4Ca+jxeDM30RuDNDOTGX+0t?=
 =?us-ascii?Q?Za5azjbt7UdSWgRK5qdp7+Gy3BlQeQsw/7qyZZXPSMNncr3cA+Vsq07dmTyv?=
 =?us-ascii?Q?lSZNvu2A7ExGlXRA4RGrFIAup3FEl/QPWblig57S5ZRrWMAmWskKRWheeqel?=
 =?us-ascii?Q?8EVP+ax3tskEa8gGGs5LA4+IY/mh0IyrR5GYpr/7Qf1drLtyRJCeQxsN2HYa?=
 =?us-ascii?Q?uQyN2mDBhOVMAYjRXBp7UptQRvTqRkvzTimfXhAVpRYDZNXskPvegPdJH0Fj?=
 =?us-ascii?Q?4N3vMnsbeeMKd8WxiOMR48bLlfnn04G/rtnyCEUrHBMrSW7hworyeu8aIqlU?=
 =?us-ascii?Q?yJDvjzA/EQdGgySpCAuhP4m82Nvcj9F6GrDiIFwbPYTKs3Vzhbygz41sEYOx?=
 =?us-ascii?Q?+DrPyKaHBPx7/xfrwqtPytBCucN3lK5XNxFK4nawUrV0T71CeOeYMX30sqHC?=
 =?us-ascii?Q?vBh70JTSUtgkJuBxpzuV5vVAa5Ma433fNjyPaNVylpQLboVM6qSRpR7K4mv/?=
 =?us-ascii?Q?f0l3Q0pFMok7DNUKOLsjvr1m0F+UujHaqUBJh+/V7w4eFTf3jqiAoW0u6U6l?=
 =?us-ascii?Q?H2MCnvaY6R+dK6Ihu7NkGf7cgJn79e3Pvangwx7B7Gynn5NhkOURRypK8tOP?=
 =?us-ascii?Q?vbfgRfH1jci7sVXlEExXsx+WvzXW5Mj44mjDUuz+LGqWmwd14kMajU0TKWa3?=
 =?us-ascii?Q?2T/29KGfstbk6xSS96JeGtNnkJuDvRUHrS7WSHAotGluggvu8yGIcW0AiGDF?=
 =?us-ascii?Q?aVbE4eFjhgyiFEb6ev6Lr+oq6Amd1dltyTaO96kbEk3fjDNqz15FHjivUZvG?=
 =?us-ascii?Q?+J7/bXuets+BAr2IX1cx43JlCNqbRqTJJSh8GTnWFVNDPCyjMfvxB1Ds1fgC?=
 =?us-ascii?Q?+s+/Du+hD9jg7ctTK3HKxHPIB+sorl7q329ohYFE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe70f325-453d-414d-3698-08dc1e9ac866
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:31.8291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ijC8aY3WyT4++5OYd+5+dUTP+d8pIiykIfAHnxGHOlbmlTRCNeCVeyy5PJdohUnH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7185

This removes all the notifier de-duplication logic in the driver and
relies on the core code to de-duplicate and allocate only one SVA domain
per mm per smmu instance. This naturally gives a 1:1 relationship between
SVA domain and mmu notifier.

Remove all of the previous mmu_notifier, bond, shared cd, and cd refcount
logic entirely.

For the purpose of organizing patches lightly remove BTM support. The next
patches will add it back in. BTM is a performance optimization so this is
bisection friendly functionally invisible change. Note that the current
code never even enables ARM_SMMU_FEAT_BTM so none of this code is ever
even used.

The bond/shared_cd/btm/asid allocator are tightly wound together and
changing them all at once would make this patch too big. The core issue is
that having a single SVA domain per-smmu instance conflicts with the
design of having a global ASID table that BTM currently needs, as we would
end up having to assign multiple SVA domains to the same ASID.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 389 ++++--------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  81 +---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  14 +-
 3 files changed, 101 insertions(+), 383 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 163e9acd51b204..3b35e61cf1bb49 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -13,29 +13,9 @@
 #include "../../iommu-sva.h"
 #include "../../io-pgtable-arm.h"
 
-struct arm_smmu_mmu_notifier {
-	struct mmu_notifier		mn;
-	struct arm_smmu_ctx_desc	*cd;
-	bool				cleared;
-	refcount_t			refs;
-	struct list_head		list;
-	struct arm_smmu_domain		*domain;
-};
-
-#define mn_to_smmu(mn) container_of(mn, struct arm_smmu_mmu_notifier, mn)
-
-struct arm_smmu_bond {
-	struct mm_struct		*mm;
-	struct arm_smmu_mmu_notifier	*smmu_mn;
-	struct list_head		list;
-};
-
-#define sva_to_bond(handle) \
-	container_of(handle, struct arm_smmu_bond, sva)
-
 static DEFINE_MUTEX(sva_lock);
 
-static void
+static void __maybe_unused
 arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 {
 	struct arm_smmu_master_domain *master_domain;
@@ -58,58 +38,6 @@ arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 }
 
-/*
- * Check if the CPU ASID is available on the SMMU side. If a private context
- * descriptor is using it, try to replace it.
- */
-static struct arm_smmu_ctx_desc *
-arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
-{
-	int ret;
-	u32 new_asid;
-	struct arm_smmu_ctx_desc *cd;
-	struct arm_smmu_device *smmu;
-	struct arm_smmu_domain *smmu_domain;
-
-	cd = xa_load(&arm_smmu_asid_xa, asid);
-	if (!cd)
-		return NULL;
-
-	if (cd->mm) {
-		if (WARN_ON(cd->mm != mm))
-			return ERR_PTR(-EINVAL);
-		/* All devices bound to this mm use the same cd struct. */
-		refcount_inc(&cd->refs);
-		return cd;
-	}
-
-	smmu_domain = container_of(cd, struct arm_smmu_domain, cd);
-	smmu = smmu_domain->smmu;
-
-	ret = xa_alloc(&arm_smmu_asid_xa, &new_asid, cd,
-		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
-	if (ret)
-		return ERR_PTR(-ENOSPC);
-	/*
-	 * Race with unmap: TLB invalidations will start targeting the new ASID,
-	 * which isn't assigned yet. We'll do an invalidate-all on the old ASID
-	 * later, so it doesn't matter.
-	 */
-	cd->asid = new_asid;
-	/*
-	 * Update ASID and invalidate CD in all associated masters. There will
-	 * be some overlap between use of both ASIDs, until we invalidate the
-	 * TLB.
-	 */
-	arm_smmu_update_s1_domain_cd_entry(smmu_domain);
-
-	/* Invalidate TLB entries previously associated with that context */
-	arm_smmu_tlb_inv_asid(smmu, asid);
-
-	xa_erase(&arm_smmu_asid_xa, asid);
-	return NULL;
-}
-
 static u64 page_size_to_cd(void)
 {
 	static_assert(PAGE_SIZE == SZ_4K || PAGE_SIZE == SZ_16K ||
@@ -123,7 +51,8 @@ static u64 page_size_to_cd(void)
 
 static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 				 struct arm_smmu_master *master,
-				 struct mm_struct *mm, u16 asid)
+				 struct mm_struct *mm, u16 asid,
+				 bool btm_invalidation)
 {
 	u64 par;
 
@@ -144,7 +73,7 @@ static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
 		CTXDESC_CD_0_R |
 		CTXDESC_CD_0_A |
-		CTXDESC_CD_0_ASET |
+		(btm_invalidation ? 0 : CTXDESC_CD_0_ASET) |
 		FIELD_PREP(CTXDESC_CD_0_ASID, asid));
 
 	/*
@@ -186,69 +115,6 @@ static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 	target->data[3] = cpu_to_le64(read_sysreg(mair_el1));
 }
 
-static struct arm_smmu_ctx_desc *arm_smmu_alloc_shared_cd(struct mm_struct *mm)
-{
-	u16 asid;
-	int err = 0;
-	struct arm_smmu_ctx_desc *cd;
-	struct arm_smmu_ctx_desc *ret = NULL;
-
-	/* Don't free the mm until we release the ASID */
-	mmgrab(mm);
-
-	asid = arm64_mm_context_get(mm);
-	if (!asid) {
-		err = -ESRCH;
-		goto out_drop_mm;
-	}
-
-	cd = kzalloc(sizeof(*cd), GFP_KERNEL);
-	if (!cd) {
-		err = -ENOMEM;
-		goto out_put_context;
-	}
-
-	refcount_set(&cd->refs, 1);
-
-	mutex_lock(&arm_smmu_asid_lock);
-	ret = arm_smmu_share_asid(mm, asid);
-	if (ret) {
-		mutex_unlock(&arm_smmu_asid_lock);
-		goto out_free_cd;
-	}
-
-	err = xa_insert(&arm_smmu_asid_xa, asid, cd, GFP_KERNEL);
-	mutex_unlock(&arm_smmu_asid_lock);
-
-	if (err)
-		goto out_free_asid;
-
-	cd->asid = asid;
-	cd->mm = mm;
-
-	return cd;
-
-out_free_asid:
-	arm_smmu_free_asid(cd);
-out_free_cd:
-	kfree(cd);
-out_put_context:
-	arm64_mm_context_put(mm);
-out_drop_mm:
-	mmdrop(mm);
-	return err < 0 ? ERR_PTR(err) : ret;
-}
-
-static void arm_smmu_free_shared_cd(struct arm_smmu_ctx_desc *cd)
-{
-	if (arm_smmu_free_asid(cd)) {
-		/* Unpin ASID */
-		arm64_mm_context_put(cd->mm);
-		mmdrop(cd->mm);
-		kfree(cd);
-	}
-}
-
 /*
  * Cloned from the MAX_TLBI_OPS in arch/arm64/include/asm/tlbflush.h, this
  * is used as a threshold to replace per-page TLBI commands to issue in the
@@ -263,8 +129,8 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 						unsigned long start,
 						unsigned long end)
 {
-	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
-	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
+	struct arm_smmu_domain *smmu_domain =
+		container_of(mn, struct arm_smmu_domain, mmu_notifier);
 	size_t size;
 
 	/*
@@ -281,34 +147,27 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 			size = 0;
 	}
 
-	if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_BTM)) {
+	if (!smmu_domain->btm_invalidation) {
 		if (!size)
 			arm_smmu_tlb_inv_asid(smmu_domain->smmu,
-					      smmu_mn->cd->asid);
+					      smmu_domain->cd.asid);
 		else
 			arm_smmu_tlb_inv_range_asid(start, size,
-						    smmu_mn->cd->asid,
+						    smmu_domain->cd.asid,
 						    PAGE_SIZE, false,
 						    smmu_domain);
 	}
 
-	arm_smmu_atc_inv_domain_sva(smmu_domain, mm_get_enqcmd_pasid(mm), start,
-				    size);
+	arm_smmu_atc_inv_domain(smmu_domain, start, size);
 }
 
 static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 {
-	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
-	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
+	struct arm_smmu_domain *smmu_domain =
+		container_of(mn, struct arm_smmu_domain, mmu_notifier);
 	struct arm_smmu_master_domain *master_domain;
 	unsigned long flags;
 
-	mutex_lock(&sva_lock);
-	if (smmu_mn->cleared) {
-		mutex_unlock(&sva_lock);
-		return;
-	}
-
 	/*
 	 * DMA may still be running. Keep the cd valid to avoid C_BAD_CD events,
 	 * but disable translation.
@@ -320,25 +179,27 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 		struct arm_smmu_cd target;
 		struct arm_smmu_cd *cdptr;
 
-		cdptr = arm_smmu_get_cd_ptr(master, mm_get_enqcmd_pasid(mm));
+		cdptr = arm_smmu_get_cd_ptr(master, master_domain->ssid);
 		if (WARN_ON(!cdptr))
 			continue;
-		arm_smmu_make_sva_cd(&target, master, NULL, smmu_mn->cd->asid);
-		arm_smmu_write_cd_entry(master, mm_get_enqcmd_pasid(mm), cdptr,
+		arm_smmu_make_sva_cd(&target, master, NULL,
+				     smmu_domain->cd.asid,
+				     smmu_domain->btm_invalidation);
+		arm_smmu_write_cd_entry(master, master_domain->ssid, cdptr,
 					&target);
 	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
-	arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_mn->cd->asid);
-	arm_smmu_atc_inv_domain_sva(smmu_domain, mm_get_enqcmd_pasid(mm), 0, 0);
-
-	smmu_mn->cleared = true;
-	mutex_unlock(&sva_lock);
+	arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_domain->cd.asid);
+	arm_smmu_atc_inv_domain(smmu_domain, 0, 0);
 }
 
 static void arm_smmu_mmu_notifier_free(struct mmu_notifier *mn)
 {
-	kfree(mn_to_smmu(mn));
+	struct arm_smmu_domain *smmu_domain =
+		container_of(mn, struct arm_smmu_domain, mmu_notifier);
+
+	kfree(smmu_domain);
 }
 
 static const struct mmu_notifier_ops arm_smmu_mmu_notifier_ops = {
@@ -347,113 +208,6 @@ static const struct mmu_notifier_ops arm_smmu_mmu_notifier_ops = {
 	.free_notifier			= arm_smmu_mmu_notifier_free,
 };
 
-/* Allocate or get existing MMU notifier for this {domain, mm} pair */
-static struct arm_smmu_mmu_notifier *
-arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
-			  struct mm_struct *mm)
-{
-	int ret;
-	struct arm_smmu_ctx_desc *cd;
-	struct arm_smmu_mmu_notifier *smmu_mn;
-
-	list_for_each_entry(smmu_mn, &smmu_domain->mmu_notifiers, list) {
-		if (smmu_mn->mn.mm == mm) {
-			refcount_inc(&smmu_mn->refs);
-			return smmu_mn;
-		}
-	}
-
-	cd = arm_smmu_alloc_shared_cd(mm);
-	if (IS_ERR(cd))
-		return ERR_CAST(cd);
-
-	smmu_mn = kzalloc(sizeof(*smmu_mn), GFP_KERNEL);
-	if (!smmu_mn) {
-		ret = -ENOMEM;
-		goto err_free_cd;
-	}
-
-	refcount_set(&smmu_mn->refs, 1);
-	smmu_mn->cd = cd;
-	smmu_mn->domain = smmu_domain;
-	smmu_mn->mn.ops = &arm_smmu_mmu_notifier_ops;
-
-	ret = mmu_notifier_register(&smmu_mn->mn, mm);
-	if (ret) {
-		kfree(smmu_mn);
-		goto err_free_cd;
-	}
-
-	list_add(&smmu_mn->list, &smmu_domain->mmu_notifiers);
-	return smmu_mn;
-
-err_free_cd:
-	arm_smmu_free_shared_cd(cd);
-	return ERR_PTR(ret);
-}
-
-static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
-{
-	struct mm_struct *mm = smmu_mn->mn.mm;
-	struct arm_smmu_ctx_desc *cd = smmu_mn->cd;
-	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
-
-	if (!refcount_dec_and_test(&smmu_mn->refs))
-		return;
-
-	list_del(&smmu_mn->list);
-
-	/*
-	 * If we went through clear(), we've already invalidated, and no
-	 * new TLB entry can have been formed.
-	 */
-	if (!smmu_mn->cleared) {
-		arm_smmu_tlb_inv_asid(smmu_domain->smmu, cd->asid);
-		arm_smmu_atc_inv_domain_sva(smmu_domain,
-					    mm_get_enqcmd_pasid(mm), 0, 0);
-	}
-
-	/* Frees smmu_mn */
-	mmu_notifier_put(&smmu_mn->mn);
-	arm_smmu_free_shared_cd(cd);
-}
-
-static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm,
-			       struct arm_smmu_cd *target)
-{
-	int ret;
-	struct arm_smmu_bond *bond;
-	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
-	struct arm_smmu_domain *smmu_domain;
-
-	if (!(domain->type & __IOMMU_DOMAIN_PAGING))
-		return -ENODEV;
-	smmu_domain = to_smmu_domain(iommu_get_domain_for_dev(dev));
-	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
-		return -ENODEV;
-
-	bond = kzalloc(sizeof(*bond), GFP_KERNEL);
-	if (!bond)
-		return -ENOMEM;
-
-	bond->mm = mm;
-
-	bond->smmu_mn = arm_smmu_mmu_notifier_get(smmu_domain, mm);
-	if (IS_ERR(bond->smmu_mn)) {
-		ret = PTR_ERR(bond->smmu_mn);
-		goto err_free_bond;
-	}
-
-	list_add(&bond->list, &master->bonds);
-	arm_smmu_make_sva_cd(target, master, mm, bond->smmu_mn->cd->asid);
-	return 0;
-
-err_free_bond:
-	kfree(bond);
-	return ret;
-}
-
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu)
 {
 	unsigned long reg, fld;
@@ -581,11 +335,6 @@ int arm_smmu_master_enable_sva(struct arm_smmu_master *master)
 int arm_smmu_master_disable_sva(struct arm_smmu_master *master)
 {
 	mutex_lock(&sva_lock);
-	if (!list_empty(&master->bonds)) {
-		dev_err(master->dev, "cannot disable SVA, device is bound\n");
-		mutex_unlock(&sva_lock);
-		return -EBUSY;
-	}
 	arm_smmu_master_sva_disable_iopf(master);
 	master->sva_enabled = false;
 	mutex_unlock(&sva_lock);
@@ -602,59 +351,54 @@ void arm_smmu_sva_notifier_synchronize(void)
 	mmu_notifier_synchronize();
 }
 
-void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
-				   struct device *dev, ioasid_t id)
-{
-	struct mm_struct *mm = domain->mm;
-	struct arm_smmu_bond *bond = NULL, *t;
-	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-
-	arm_smmu_remove_pasid(master, to_smmu_domain(domain), id);
-
-	mutex_lock(&sva_lock);
-	list_for_each_entry(t, &master->bonds, list) {
-		if (t->mm == mm) {
-			bond = t;
-			break;
-		}
-	}
-
-	if (!WARN_ON(!bond)) {
-		list_del(&bond->list);
-		arm_smmu_mmu_notifier_put(bond->smmu_mn);
-		kfree(bond);
-	}
-	mutex_unlock(&sva_lock);
-}
-
 static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 				      struct device *dev, ioasid_t id)
 {
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	int ret = 0;
-	struct mm_struct *mm = domain->mm;
 	struct arm_smmu_cd target;
+	int ret;
 
-	if (mm_get_enqcmd_pasid(mm) != id || !master->cd_table.used_sid)
+	/* Prevent arm_smmu_mm_release from being called while we are attaching */
+	if (!mmget_not_zero(domain->mm))
 		return -EINVAL;
 
-	if (!arm_smmu_get_cd_ptr(master, id))
-		return -ENOMEM;
+	/*
+	 * This does not need the arm_smmu_asid_lock because SVA domains never
+	 * get reassigned
+	 */
+	arm_smmu_make_sva_cd(&target, master, smmu_domain->domain.mm,
+			     smmu_domain->cd.asid,
+			     smmu_domain->btm_invalidation);
 
-	mutex_lock(&sva_lock);
-	ret = __arm_smmu_sva_bind(dev, mm, &target);
-	mutex_unlock(&sva_lock);
-	if (ret)
-		return ret;
+	ret = arm_smmu_set_pasid(master, to_smmu_domain(domain), id, &target);
 
-	/* This cannot fail since we preallocated the cdptr */
-	arm_smmu_set_pasid(master, to_smmu_domain(domain), id, &target);
-	return 0;
+	mmput(domain->mm);
+	return ret;
 }
 
 static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
 {
-	kfree(to_smmu_domain(domain));
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+
+	/*
+	 * Ensure the ASID is empty in the iommu cache before allowing reuse.
+	 */
+	arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_domain->cd.asid);
+
+	/*
+	 * Notice that the arm_smmu_mm_arch_invalidate_secondary_tlbs op can
+	 * still be called/running at this point. We allow the ASID to be
+	 * reused, and if there is a race then it just suffers harmless
+	 * unnecessary invalidation.
+	 */
+	xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
+
+	/*
+	 * Actual free is defered to the SRCU callback
+	 * arm_smmu_mmu_notifier_free()
+	 */
+	mmu_notifier_put(&smmu_domain->mmu_notifier);
 }
 
 static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
@@ -668,6 +412,8 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_domain *smmu_domain;
+	u32 asid;
+	int ret;
 
 	smmu_domain = arm_smmu_domain_alloc();
 	if (IS_ERR(smmu_domain))
@@ -677,5 +423,22 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	smmu_domain->domain.ops = &arm_smmu_sva_domain_ops;
 	smmu_domain->smmu = smmu;
 
+	ret = xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
+		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
+	if (ret)
+		goto err_free;
+
+	smmu_domain->cd.asid = asid;
+	smmu_domain->mmu_notifier.ops = &arm_smmu_mmu_notifier_ops;
+	ret = mmu_notifier_register(&smmu_domain->mmu_notifier, mm);
+	if (ret)
+		goto err_asid;
+
 	return &smmu_domain->domain;
+
+err_asid:
+	xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
+err_free:
+	kfree(smmu_domain);
+	return ERR_PTR(ret);
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 849365a5ff550d..58b4dcb6f56f99 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1396,22 +1396,6 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 	cd_table->cdtab = NULL;
 }
 
-bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd)
-{
-	bool free;
-	struct arm_smmu_ctx_desc *old_cd;
-
-	if (!cd->asid)
-		return false;
-
-	free = refcount_dec_and_test(&cd->refs);
-	if (free) {
-		old_cd = xa_erase(&arm_smmu_asid_xa, cd->asid);
-		WARN_ON(old_cd != cd);
-	}
-	return free;
-}
-
 /* Stream table manipulation functions */
 static void
 arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
@@ -2031,8 +2015,8 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_master *master,
 	return arm_smmu_cmdq_batch_submit(master->smmu, &cmds);
 }
 
-static int __arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
-				     ioasid_t ssid, unsigned long iova, size_t size)
+int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
+			    unsigned long iova, size_t size)
 {
 	struct arm_smmu_master_domain *master_domain;
 	int i;
@@ -2070,15 +2054,7 @@ static int __arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
 		if (!master->ats_enabled)
 			continue;
 
-		/*
-		 * Non-zero ssid means SVA is co-opting the S1 domain to issue
-		 * invalidations for SVA PASIDs.
-		 */
-		if (ssid != IOMMU_NO_PASID)
-			arm_smmu_atc_inv_to_cmd(ssid, iova, size, &cmd);
-		else
-			arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova, size,
-						&cmd);
+		arm_smmu_atc_inv_to_cmd(master_domain->ssid, iova, size, &cmd);
 
 		for (i = 0; i < master->num_streams; i++) {
 			cmd.atc.sid = master->streams[i].id;
@@ -2090,19 +2066,6 @@ static int __arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
 	return arm_smmu_cmdq_batch_submit(smmu_domain->smmu, &cmds);
 }
 
-static int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
-				   unsigned long iova, size_t size)
-{
-	return __arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, iova,
-					 size);
-}
-
-int arm_smmu_atc_inv_domain_sva(struct arm_smmu_domain *smmu_domain,
-				ioasid_t ssid, unsigned long iova, size_t size)
-{
-	return __arm_smmu_atc_inv_domain(smmu_domain, ssid, iova, size);
-}
-
 /* IO_PGTABLE API */
 static void arm_smmu_tlb_inv_context(void *cookie)
 {
@@ -2291,7 +2254,6 @@ struct arm_smmu_domain *arm_smmu_domain_alloc(void)
 	mutex_init(&smmu_domain->init_mutex);
 	INIT_LIST_HEAD(&smmu_domain->devices);
 	spin_lock_init(&smmu_domain->devices_lock);
-	INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
 
 	return smmu_domain;
 }
@@ -2334,7 +2296,7 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
 		/* Prevent SVA from touching the CD while we're freeing it */
 		mutex_lock(&arm_smmu_asid_lock);
-		arm_smmu_free_asid(&smmu_domain->cd);
+		xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
 		mutex_unlock(&arm_smmu_asid_lock);
 	} else {
 		struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
@@ -2352,11 +2314,9 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
 	u32 asid;
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
 
-	refcount_set(&cd->refs, 1);
-
 	/* Prevent SVA from modifying the ASID until it is written to the CD */
 	mutex_lock(&arm_smmu_asid_lock);
-	ret = xa_alloc(&arm_smmu_asid_xa, &asid, cd,
+	ret = xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
 		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
 	cd->asid	= (u16)asid;
 	mutex_unlock(&arm_smmu_asid_lock);
@@ -2808,7 +2768,11 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	struct arm_smmu_cd *cdptr;
 	int ret;
 
-	if (!arm_smmu_is_s1_domain(iommu_get_domain_for_dev(master->dev)))
+	if (smmu_domain->smmu != master->smmu)
+		return -EINVAL;
+
+	if (!arm_smmu_is_s1_domain(iommu_get_domain_for_dev(master->dev)) ||
+	    !master->cd_table.used_sid)
 		return -ENODEV;
 
 	cdptr = arm_smmu_get_cd_ptr(master, pasid);
@@ -2829,9 +2793,18 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	return ret;
 }
 
-void arm_smmu_remove_pasid(struct arm_smmu_master *master,
-			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid)
+static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 {
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_domain *smmu_domain;
+	struct iommu_domain *domain;
+
+	domain = iommu_get_domain_for_dev_pasid(dev, pasid, IOMMU_DOMAIN_SVA);
+	if (WARN_ON(IS_ERR(domain)) || !domain)
+		return;
+
+	smmu_domain = to_smmu_domain(domain);
+
 	mutex_lock(&arm_smmu_asid_lock);
 	arm_smmu_clear_cd(master, pasid);
 	if (master->ats_enabled)
@@ -3105,7 +3078,6 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 
 	master->dev = dev;
 	master->smmu = smmu;
-	INIT_LIST_HEAD(&master->bonds);
 	dev_iommu_priv_set(dev, master);
 
 	ret = arm_smmu_insert_master(smmu, master);
@@ -3286,17 +3258,6 @@ static int arm_smmu_def_domain_type(struct device *dev)
 	return 0;
 }
 
-static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
-{
-	struct iommu_domain *domain;
-
-	domain = iommu_get_domain_for_dev_pasid(dev, pasid, IOMMU_DOMAIN_SVA);
-	if (WARN_ON(IS_ERR(domain)) || !domain)
-		return;
-
-	arm_smmu_sva_remove_dev_pasid(domain, dev, pasid);
-}
-
 static struct iommu_ops arm_smmu_ops = {
 	.identity_domain	= &arm_smmu_identity_domain,
 	.blocked_domain		= &arm_smmu_blocked_domain,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 66a6a44f4895e9..2bc04802ab01bf 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -587,9 +587,6 @@ struct arm_smmu_strtab_l1_desc {
 
 struct arm_smmu_ctx_desc {
 	u16				asid;
-
-	refcount_t			refs;
-	struct mm_struct		*mm;
 };
 
 struct arm_smmu_l1_ctx_desc {
@@ -713,7 +710,6 @@ struct arm_smmu_master {
 	bool				stall_enabled;
 	bool				sva_enabled;
 	bool				iopf_enabled;
-	struct list_head		bonds;
 	unsigned int			ssid_bits;
 };
 
@@ -742,7 +738,8 @@ struct arm_smmu_domain {
 	struct list_head		devices;
 	spinlock_t			devices_lock;
 
-	struct list_head		mmu_notifiers;
+	struct mmu_notifier		mmu_notifier;
+	bool				btm_invalidation;
 };
 
 struct arm_smmu_master_domain {
@@ -781,9 +778,8 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
 				 struct arm_smmu_domain *smmu_domain);
-bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd);
-int arm_smmu_atc_inv_domain_sva(struct arm_smmu_domain *smmu_domain,
-				ioasid_t ssid, unsigned long iova, size_t size);
+int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
+			    unsigned long iova, size_t size);
 
 #ifdef CONFIG_ARM_SMMU_V3_SVA
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu);
@@ -795,8 +791,6 @@ bool arm_smmu_master_iopf_supported(struct arm_smmu_master *master);
 void arm_smmu_sva_notifier_synchronize(void);
 struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 					       struct mm_struct *mm);
-void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
-				   struct device *dev, ioasid_t id);
 #else /* CONFIG_ARM_SMMU_V3_SVA */
 static inline bool arm_smmu_sva_supported(struct arm_smmu_device *smmu)
 {
-- 
2.43.0


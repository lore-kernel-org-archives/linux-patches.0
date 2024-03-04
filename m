Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202507D06E;
	Mon,  4 Mar 2024 23:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595878; cv=fail; b=vAWa8f+AaAyTRY2vn7oYG6nywKcN3AS9nPS7YnIAGGZVyUCBFYhVr/Sf09hE8W646b0u6LQknM5XkH5hCcEwsNoBxgdWqkWpKfdo/186dR0AoldqKIL9yd/T6Uy+TXY1PvlOJPFI1tKZp4bZHbomGifPL8h3NM82zHdQTnwR0v0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595878; c=relaxed/simple;
	bh=/8lITSWxrQuTp9W7/9xTgT/XBX1mNpkpBHBFGFHTsH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PryXE4jA/usJ1/LVY3+SvaDfmkVc/JFD5Ntden20dwdJa2hq5OqzocPmaN/CEYahzPWrec8SCXZnwHZ+yHJ3G3DREfebytXSO2W+BX38ZWrL+Vck6ukazYwMJcUAAlmsfUS37Ms9P4yabdX9vCVUbsmn5Cw9+X49wKwAY+xL1+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bEvZUuoc; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bEvZUuoc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DaRIyyQi3B/Wpk3XfZqtmZM3Gh9YJcS8Z4C4OS87mgHRV7p0XrIf/6Zu4f/4fvMA2XfoFSG3LQ/i8Y/NJ3VloAr+pxxv/57WKLpcj2r4eI2W25Y6KeaLqfxPInSJewxLYeA1zlSDnT3+8jGn/OVIsQuwMdelnItVdECc9LKfb1JScn+oAj4dlwJ4FqxukjnmpwnjNPD5UUIePB97KE9NyTLmuQmQcd00R+ZB01po4B6LyZL0uaen8AdM23YYnreBVSDMG53VEy3dEt0CJXDkN7e0uv0Yg96ZiJ1Vq+/UAwL2o8gZs06Tsr3SZ8SqtDZplm7/gexgRjtQCN/GROCIOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mgI8bLot4cESfReHsMZCYgbgUuF3Cl3ALGPEj88Zm+Y=;
 b=oDz3rFoq3cwxhNzNOfqaQuR7MafPn7z8lOqJDMiRlN5wCi05djeN9kp6Xy75hx38TBrN9+5mAXZHiaar5XfbCH2a6WG0wWxl9Hx4lXedGVIL7roByHcbZpPkG2RU8tf1WEBjGXoUnvSk1PDRaIY79c7HWPEHa/H+97ccsxJIHu3uGRMPnQSa2+8SDjbH/iPkPTBvCs9INknSRpMucbOcJdG+Z27pN5DTL4oybPbVKuSvgG4r5H6IRSixzJb/TsWfkUfWctFS5eykRIFELGQlVd1CyPHHkzA8DMl91YatgCq2uBSJoKtqkfduYja+i5OHNfo/kZEbS9v7okfUCqMcag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mgI8bLot4cESfReHsMZCYgbgUuF3Cl3ALGPEj88Zm+Y=;
 b=bEvZUuoca9BEZ4MH5HEjzuM5uZQvDkIaItwQAfh4hnfExPjSrb0DsxnvoTD2rynkAqZPeVaEak1EZpyq6D+r/qlU9yQ2MxQJoUT1jgBkKzHQI23R2zIPqN9k8enHs3KvXFlTQGJKZrEMVXRZzj2YYjktdcMoWSyFLbzc7dRmzaiWLHKbrC5DYoEJcLdVFLG5ZNQKbDijTEDkWmK4cIiPNVm1FL+RDO4JTn9xek8uJ1lYj1TVPAFKjsYFhz0I8kiivZ2ojhsEBpLrZF0f6ptpMHQpSniO7C+7gg2S6zExR1/kvgLcTyqRsoGkcy7mwWEIQJEhpPBwLeE9/qQESe1ihQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.39; Mon, 4 Mar 2024 23:44:24 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:24 +0000
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
Subject: [PATCH v5 21/27] iommu/arm-smmu-v3: Put the SVA mmu notifier in the smmu_domain
Date: Mon,  4 Mar 2024 19:44:09 -0400
Message-ID: <21-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0035.namprd15.prod.outlook.com
 (2603:10b6:207:17::48) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: 383d79ca-77d4-4b06-28c0-08dc3ca50185
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qymadARiYiavidzGeV3vL5cGUeOgWz6o5iYHn+8dcrVUauitnieNarR4qjb3Du2Y6/qH7AzYzgPELegByMOTVtVoaZ85fhAVzYP4scG4htlOu7AqCdScAzN1p/OyTv3bsrTywjACXrk/lYxxu6r+u1KByyjKpgU1h9KDOVDfbW8vAg1A6g7XkpfTs89b2Z0WsVIV6Wr0XuVhPeLNwTKn48CvW+By8h/4lZptTvkcestOtR10K9sKr1cnb/MD0glEZ2IBUdTZTsQ8viTeJ43lrZ0V5YFv4jVMDK0aMZ8RhA3nfSZhx+u3TxZ581KXbEDVDMw1yDdCSA78darEXQiyeUB/M6frvlOD6gg4Dr5GNkjauJrbLeAhME0b2YWFD00XHXE0+iBknGpl2sbNR+asWTPJUwDSYGIuxhuke7nDpagpOS6A+SFN6+LpO0Eb6iGWW4BuAc67DEnUrgyxhw4rgpFz3rU0qoX8dSj7v2ytPBQcU62CgQ6lb4L6HEl9BI0Co0yrbClnoa26eiwQ8a/seQbLRPlZCYRMLEOtAUFz7hGLkEfQf+QimegYp9dDxE1lhj6NT0vALaN4KA3VQDjTyTEYcktk266J+GUCAdZDVN3I9lJZvdKGIwctmLfZlsy2FL7l+GcY0VMuKbSXayyt6QeOALHv8g+0LNf7vm1as8o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?miHSy/2iTDaL1XJ8c3mlvohxpxLQkyl0/5nroGF6+fnb7EQZzrISycEsfHAC?=
 =?us-ascii?Q?3qrfTL2ut96znRzkxUnq0DgCn5hpKQosiZfM0icfjLkcsT5BbdARBJHfBDLL?=
 =?us-ascii?Q?Lrmj/yuQbH3KPZSVLpprh+ZbWl9DtL7f9CR9hgtL2CdeEKI8JHd8OJXR0S4m?=
 =?us-ascii?Q?D5ze823WI00VPY2tvj+C4PR44EjK3spYY4fIeUczLCLFaGuBQ5WpMKOafSBY?=
 =?us-ascii?Q?+XbCcbQXK6Ei+7Xm+AzLnP+7MIARgNmwKjE6hz5ct6ZEPr9Jim4BIZYVxxrG?=
 =?us-ascii?Q?JfHStCwLzCGd2zESuFjKwcOsP5FTrq3r/6RnRQjNDWKelF9teGcv7tb9PYzH?=
 =?us-ascii?Q?qF2LDTFBTkYh3hs2f/J2B8l/MuOFEYxFnavQqtMz8pbZnToGnYA5j4d0pzuE?=
 =?us-ascii?Q?ItIBXKGFeRm1u1mlQAnOAFS6xbQAg1ZrBlid+qYiVobfiAGeCY18+8f1s7v4?=
 =?us-ascii?Q?VWl9MKS/WFw8hyDolZUzTbVJpqJtVzQR6blLMAQbMKNL3e7d7r0csx5W+ORh?=
 =?us-ascii?Q?Fr/w0UK2Y9PWMMS6REOLMbtVWB/vdE1YDh0qKQWjUi+jRILX8tuM1ECpHkib?=
 =?us-ascii?Q?c3CnvHdnL04Nl4Zu3KFWcrJLRKG32oUPg6A0aMlFPP+ncIT8/f1iSbp/1I05?=
 =?us-ascii?Q?ODVYkfQ+BdZAsDuc6C0oqg4asZHrrOAHvWsFFoNWQGS14DDaS+PwMZhi4UOn?=
 =?us-ascii?Q?42ump6ouajI531YlDACvjW8b6ZDaONFe5YQS61BBYWf1/qt+t+qVVI6UP6mm?=
 =?us-ascii?Q?RNK5IGwjr6TZG2/DvU4/3mh8/y1968Tun/YSAi9QepJ58S9lFcKPMZ12T/bt?=
 =?us-ascii?Q?cTikoUxHx9inVNikh0UMTOelprOzwIu63saFYSivk5RUTZC1DQh9IFiT2om3?=
 =?us-ascii?Q?p8ONz4Ka+pZfXaq+jh1AKxvALa5YfEiR2sSnAV6qviH2U7xWbi3Ogy350Yhf?=
 =?us-ascii?Q?rdijBe6y1zoQLRDi8s0vxzRCb53mNF2wKC3kKUW+yYCefU61qe+ExgtI5HY2?=
 =?us-ascii?Q?NKgdkADY9wwmxD7Vd250foIL9YzUbjVsjQr0fmYQRigy6DxvpIC4FVCesm/k?=
 =?us-ascii?Q?x0kYmXLMrtsgUcOEmpVhwpyvS0/qJu7KbwQV15NoG1XEwv9YYM0DUvPOgYqV?=
 =?us-ascii?Q?kreLHe20vkHUzAZW9y1NxEbl955Xmp/bnz/vf/kOhswzTbn20j4sb7lePt6q?=
 =?us-ascii?Q?FdkKPRu+nYAle5zZ8HOLxwcLCorGEZeFekeH9cmyN3qexgQuqYS92UycPVDi?=
 =?us-ascii?Q?z0xLuRc/I6xnZuyfgEe5eVtw0nV0PdcBcER4GVLiZFwAKpOteebfjceGQ7Xa?=
 =?us-ascii?Q?ufTwuTGQS8waqPZQJlL55phLqFGlGCAvntY2Clt7E2FD16xJymwebaGG3tNq?=
 =?us-ascii?Q?C8jki1ERqKhs2pFk9ldgk8jXOIHLUcE0iyyjcQ/UcXiGvbcWXUja65IdoU+Q?=
 =?us-ascii?Q?v7ZZtyVUjfNpLGmz3yDb4sU7GOrcBhtcOOwbCxHcSM0yv6yqTEMWq2cCby+c?=
 =?us-ascii?Q?YKeV+QzJdogpZgENwAtEUqqFCkU4fip8uY2lYhE8rmW/kU1ZaUGtEiXXCfX0?=
 =?us-ascii?Q?5tG5wEI5JXXAgMZzIZhxdEtjmgL2WTaSa4vWqXOA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 383d79ca-77d4-4b06-28c0-08dc3ca50185
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:17.4317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fRA+13fsIj8NWXqSzUEFqj+E+ZiH7gyB+1mgqhomT0dnmaqkyesYnZpZURnpXOV4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584

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

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 389 ++++--------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  81 +---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  14 +-
 3 files changed, 101 insertions(+), 383 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 30b1cf587efffb..cb0da4e5a5517a 100644
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
-	smmu_domain = to_smmu_domain(domain);
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
-	arm_smmu_make_sva_cd(target, master, mm, bond->smmu_mn->cd->asid);
-	list_add(&bond->list, &master->bonds);
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
+	ret = arm_smmu_set_pasid(master, smmu_domain, id, &target);
 
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
index a255a02a5fc8a9..5642321b2124d9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1436,22 +1436,6 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
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
@@ -2042,8 +2026,8 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_master *master,
 	return arm_smmu_cmdq_batch_submit(master->smmu, &cmds);
 }
 
-static int __arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
-				     ioasid_t ssid, unsigned long iova, size_t size)
+int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
+			    unsigned long iova, size_t size)
 {
 	struct arm_smmu_master_domain *master_domain;
 	int i;
@@ -2081,15 +2065,7 @@ static int __arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
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
@@ -2101,19 +2077,6 @@ static int __arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
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
@@ -2302,7 +2265,6 @@ struct arm_smmu_domain *arm_smmu_domain_alloc(void)
 	mutex_init(&smmu_domain->init_mutex);
 	INIT_LIST_HEAD(&smmu_domain->devices);
 	spin_lock_init(&smmu_domain->devices_lock);
-	INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
 
 	return smmu_domain;
 }
@@ -2345,7 +2307,7 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
 		/* Prevent SVA from touching the CD while we're freeing it */
 		mutex_lock(&arm_smmu_asid_lock);
-		arm_smmu_free_asid(&smmu_domain->cd);
+		xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
 		mutex_unlock(&arm_smmu_asid_lock);
 	} else {
 		struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
@@ -2363,11 +2325,9 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
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
@@ -2818,7 +2778,11 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
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
@@ -2839,9 +2803,18 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
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
@@ -3115,7 +3088,6 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 
 	master->dev = dev;
 	master->smmu = smmu;
-	INIT_LIST_HEAD(&master->bonds);
 	dev_iommu_priv_set(dev, master);
 
 	ret = arm_smmu_insert_master(smmu, master);
@@ -3296,17 +3268,6 @@ static int arm_smmu_def_domain_type(struct device *dev)
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
index f62bd2ef36a18d..cfae4d69cd810c 100644
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
2.43.2


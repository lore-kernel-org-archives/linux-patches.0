Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91AD14EC79;
	Wed, 27 Mar 2024 18:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562930; cv=fail; b=iKvx+eZZ5fdkyNqgqVeVEUdvpjDxXOSUWJbXHyv62BtSWV6M6hqjvclMLT0VwJpoJYQXpn9mjiPdjATqTAu83invK99uWZjPjuspRDz5kD8ZG1nXhlsy/+HuSfHg7V7aNUilKCypKw66u05c+aN0GhQNMSvAAXgzFVuKWU1QBMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562930; c=relaxed/simple;
	bh=OJGPPDmewZE7pIxfcdftjlXrXktwpUX5NjF6AJvRKec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=f8zT7zb5GaRrh1aA0MCOmMIAOxaO1uyHHU2RTzAKO3KwApMU8J+9itJIaJLz6cnweQWOhbrVAje5IlxjvzGJv3k7iJzUTDXKgfJDAmHo5ROrD0SvJrhfN9tT0Cek6anPCL5T9Ub8qnwTWaPEUstPcXitoWOi2k8TuPlbThK3rPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tH4BH694; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tH4BH694"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lEFCRLkOazLrvE09ZLjmqFm5Ufa4EYqqM067zcq4NZI+6gnZyar7dEN7kJZkqd2CghpKO9DfD1lENcIxl4UV93t4Oh07WWIdiFK1V+YEKBkE45Ue0ZaZm5iE/0CT0598JNaB5GYX5Vn4iGf5F7EmUQan10MsGV7vllbP078fXQ3MLhEK7blgmgjmjE4YBUI0u5wzlTnflKfuKmL78EQpX7pBQj4m95Yj/CiyHGiq2bxm1FtubOmBtk3YulD4feDtNZ/ZjjFk6oAwoh1JrZVOhf9TdapdqqB3oslqmEkGKPwRmjy1SA2pS2rkdPgWx1LVa1uukPGgRBeqpU+pd85A5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BtmEO240KNaODknEMwPSl9Gj5wYZzHrGdqD7hDx3g0E=;
 b=hkbe8tiO5J7I+WEYrKDPUidSi/j7yFeDTZYxDlKPpNnLEJI+y2Si1XbR6UwRS6hsFSiQuPWw8zt9+ywL5JupVSkFbpYm2hJGPhU9PBptvVPVgiQo0tmoz86rWdylsXevrdG6mL5U6r1VsxgaRXbVY6ihpV+toABNSw5z+WFn1/HqYKSbcAL3oSHesST2LrvJoAMfqgtYukA4TbdC1CTdBH2197NrAiwrBe6kysDijTdoA+73/aqj/o807NK+JCGw5hvtUTiuf81yr39VLGrxynnEZZQaxLsMkzAt7qJWl3FKZpGuCbZb3KAK+dZIW6wmxENRE6AclKMjk+4ZzQwYHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtmEO240KNaODknEMwPSl9Gj5wYZzHrGdqD7hDx3g0E=;
 b=tH4BH694SCBZCR86aJfJOq+Cvh68ayJnvRPQYJvkEEm446+i4Iwlhaxwcl5MjCIL6nx+X5Fg9QiSMlo7mtChi09YYSGKL0EzjZbFesI+2ZyOUnitWqZjYHJd0I9botgnKxEkz4+2qIBYuBNUTHn37fF/SAuXegZGMDUiAYm6a1YIBNOkJpBj24E8R2m3+lDHDR71XsHeMIqNhFFTY/nUFRC7AJxhCOY6R4DuioYbYQ2lWi3uyQz18HglAQ/hFY2e4fn7XFFweKMhKYAPJPG4wVcNP+5i+bcqMOT2fabwEANdWEF+ZgkzNo/kG16sbWOc+2VNzssEe3qvESYhkaNbqg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA1PR12MB6044.namprd12.prod.outlook.com (2603:10b6:208:3d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 18:08:34 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:34 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 23/29] iommu/arm-smmu-v3: Put the SVA mmu notifier in the smmu_domain
Date: Wed, 27 Mar 2024 15:08:09 -0300
Message-ID: <23-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0050.namprd05.prod.outlook.com
 (2603:10b6:208:236::19) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA1PR12MB6044:EE_
X-MS-Office365-Filtering-Correlation-Id: dfea69fc-c8b1-4cf2-93bf-08dc4e88e237
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	j6xdSwg4mLIxACbGa7qBF3lLoFsFBihP+uM/68k4U25DqQ9DHy6BLW4+0rKl1QgdfQT5wUj8q48a5Brpcia5icOmis2h8mfxa0ho0GRGaSKjTkIBesCGo37AAOECkx3Te4KNdhaliIyFTRVB5AWCFkGbtJGzph93nOPcscfkoNljhZ2lWGToLbTvqNLjK7x8wpUZ2hFL1Lh0AZjLMpslpLdKjycvAhnIBdVft7COkX4ZXwyZWMb7mn4F5UYFVBPMIrGkLOT7zRhpzp7X25yJLTJQNgu32TPkUXt76SdUm50+tttB0R0Yp2N6W2vVX9IhFmCST3VilD7/91l+zQm5kqeIi2RdXikETdkpAhu8W+XaxzrAz1pozPg9QWKbXKItY7CdzTMF3ABaou6d4sBxSKidDNX5u2z/AdUHrORd7S60pIJ54XviZfrOtI3Ai+tCpyx+B6bHtRNYeTNQDhyFk3tIQxaXYnC5yWnG+NgfFKiNdGSPIug1ZVf9qHiyh/7NVtCJzr13ihwc2muV1POdA93WxED8QSshwsls0iEOPL2rJKzcMS5fVWdEC/yUjm2NhTo4R1zTC9E/aMU3PwpEcDh4wCiNls/hs4qcDIs0iVJbSc1a/wU2W2/DOmxyZUP+w8liqLu1QixkjDOlnEFNMRwn2RYFncnE2vfDQqOYk7s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZpcMsG1mLc5dx0yIYVPvAjH4Viu/wRKFJmeVlZQ4Q+vGBeIP8nGElNiyOB62?=
 =?us-ascii?Q?dAFfxMrN6Fxue6tDC1x0+oC4mVGxLjjrjnTeV1ErYDEaRoC37M8LwyMAomXB?=
 =?us-ascii?Q?vIWHD0WoUuN3+R//uilulWEfAnyd/IZ9byt6jB3EDbE6pE1vTHxWUw7HmRaV?=
 =?us-ascii?Q?EL1X0kYy42G8jNsjjmxpv10Lr1tioqljX808gJkwH0BTFjorYUtiMn7zBawd?=
 =?us-ascii?Q?RSjlyKPV9/kxJAMHmj1dNBJeERTKIMTwSGPhpTUtrko8srlWu8eBsgsfPdIb?=
 =?us-ascii?Q?4cWDpVk62a6L4BwIkQpYsTpfHAyYUy4cYfA/btedb2iVcG3G7KKPAXgDcC/1?=
 =?us-ascii?Q?tsXGKVMigVV/uQ6guAdA1D1N+AyQ4wENYX+2lJVyK3Elr1mk3kLarlCF1XV3?=
 =?us-ascii?Q?eqFuPzhC/Fqzu2lySGUcUW5rd0D8Rzai/0sM+LPixvDpSRmPtnej4W9dF2D8?=
 =?us-ascii?Q?pkO/KlMl7oKjkTy/LaCjf1u3+Im4mFKjuQ4nUxrFZOJzJCcS/LTgqyHBYxiA?=
 =?us-ascii?Q?NsFZspWlFggqICVN9KNjaFsl8BvprcybhHOyDv/b84jX6MvNnfN4f6kgUEiB?=
 =?us-ascii?Q?gbJpaem92MeaJYw7aeSWcyyXy6Gfi/ObEHbg85o6/GrHoFoa1f8OZUc7VCvD?=
 =?us-ascii?Q?twuuf0vG2yK4Yhur/mU3CSbl9wyQdwUZ47QyQcaM+Ehyzmjqbfie3sIcCu6S?=
 =?us-ascii?Q?YW0vubxpfZq+AAs3baQt2WtyGNQY96sHwTkunxGT63RbmM/pwK42MqHK4bxm?=
 =?us-ascii?Q?vWHUg4EpTX0hmHkoGnuqMx6a/NJ3OHvaqnBgh01dvbtXG0ULRz9XDlQ6CXw1?=
 =?us-ascii?Q?ZTL//4SjMEGDvDgTmPBuU9gFDpSrpKJF7UIMaeAMihoBKMB9yz+ONIu3G1li?=
 =?us-ascii?Q?X/LBH8Gy+7Uk+yTRNOrSm+27gs2eq87DD1zO8VWSkgpsRKeAFfn9Qu1CCVvO?=
 =?us-ascii?Q?VB1Ezu4OYxoHX4HmG7ccfWwLyOK0/KnVXbIQp1IZFWgeNhMCo9adQAjlHpnx?=
 =?us-ascii?Q?AHEpOPNqZXdjFTRv5vbd4iYiDy7QCs1OHu/0loJ68CE6E9ELJhDFw2ClpDgB?=
 =?us-ascii?Q?NdGY9ARSVfhchIJhuMViZAgGZ423ExKB3gqlarpWYU2K/lquFlieOpW3yJ7L?=
 =?us-ascii?Q?//Wtads2iTtFeRHMkzF3Dt6csp23V0+JgdmwLhTjmiZcMuxihe/8rI+7hn+X?=
 =?us-ascii?Q?KQgWZ1nq99zOXTrrGSOgugogud4BSCYrmt133r6sHlUz/3utayeCR2OOVJ9R?=
 =?us-ascii?Q?rUseQInwBJA24lTxTgHw7IxkzGfIXGTRzYWYhtZ+Y5zEPhReDoSOfNmmifKm?=
 =?us-ascii?Q?UGwuf8KGnCyQ8dKtcEU3sMXOrOWb7f+F24q9IFf2alvrs9oT1cnzo7XFSiUs?=
 =?us-ascii?Q?9wIIKGQ7Y1uw9BEuW40SMkk9V9HPeKkLG3ayZX3KD1i2YgGhOeq8Cy6NLHBm?=
 =?us-ascii?Q?tw4DmmVsMhQepEHChI0Ej/IKgEAoHUGECjc7qdrvSkLaX0/frOKY1eyz2F3y?=
 =?us-ascii?Q?+JQ7SAuoz2Qk8NlQXpSBx8aANSwvrSG72aOQjNgWSwye1Y6L1ZVKjP1qLeYw?=
 =?us-ascii?Q?AvqlfJHbSGHO6wax36GCJbA/rXIvsavZTrowjr9o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfea69fc-c8b1-4cf2-93bf-08dc4e88e237
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:19.9845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XZu06/4ZtsXbW9fAOhDpYAO0UUzSYG/KSGWCQrnvn9mPL/VZjZhnV1f2sqL+gyC9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6044

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
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 396 ++++--------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  78 +---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  14 +-
 3 files changed, 97 insertions(+), 391 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index e337e40ac5de31..fd0b9f230f89e3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -12,29 +12,9 @@
 #include "arm-smmu-v3.h"
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
@@ -57,58 +37,6 @@ arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
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
@@ -122,7 +50,8 @@ static u64 page_size_to_cd(void)
 
 static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 				 struct arm_smmu_master *master,
-				 struct mm_struct *mm, u16 asid)
+				 struct mm_struct *mm, u16 asid,
+				 bool btm_invalidation)
 {
 	u64 par;
 
@@ -143,7 +72,7 @@ static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
 		CTXDESC_CD_0_R |
 		CTXDESC_CD_0_A |
-		CTXDESC_CD_0_ASET |
+		(btm_invalidation ? 0 : CTXDESC_CD_0_ASET) |
 		FIELD_PREP(CTXDESC_CD_0_ASID, asid));
 
 	/*
@@ -185,69 +114,6 @@ static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
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
@@ -262,8 +128,8 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 						unsigned long start,
 						unsigned long end)
 {
-	struct arm_smmu_mmu_notifier *smmu_mn = mn_to_smmu(mn);
-	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
+	struct arm_smmu_domain *smmu_domain =
+		container_of(mn, struct arm_smmu_domain, mmu_notifier);
 	size_t size;
 
 	/*
@@ -280,34 +146,27 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
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
@@ -319,25 +178,27 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
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
@@ -346,115 +207,6 @@ static const struct mmu_notifier_ops arm_smmu_mmu_notifier_ops = {
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
-static struct arm_smmu_bond *__arm_smmu_sva_bind(struct device *dev,
-						 struct mm_struct *mm)
-{
-	int ret;
-	struct arm_smmu_bond *bond;
-	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
-	struct arm_smmu_domain *smmu_domain;
-
-	if (!(domain->type & __IOMMU_DOMAIN_PAGING))
-		return ERR_PTR(-ENODEV);
-	smmu_domain = to_smmu_domain(domain);
-	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
-		return ERR_PTR(-ENODEV);
-
-	if (!master || !master->sva_enabled)
-		return ERR_PTR(-ENODEV);
-
-	bond = kzalloc(sizeof(*bond), GFP_KERNEL);
-	if (!bond)
-		return ERR_PTR(-ENOMEM);
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
-	return bond;
-
-err_free_bond:
-	kfree(bond);
-	return ERR_PTR(ret);
-}
-
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu)
 {
 	unsigned long reg, fld;
@@ -571,11 +323,6 @@ int arm_smmu_master_enable_sva(struct arm_smmu_master *master)
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
@@ -592,66 +339,52 @@ void arm_smmu_sva_notifier_synchronize(void)
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
-	struct mm_struct *mm = domain->mm;
-	struct arm_smmu_bond *bond;
 	struct arm_smmu_cd target;
 	int ret;
 
-	if (mm_get_enqcmd_pasid(mm) != id || !master->cd_table.in_ste)
+	/* Prevent arm_smmu_mm_release from being called while we are attaching */
+	if (!mmget_not_zero(domain->mm))
 		return -EINVAL;
 
-	mutex_lock(&sva_lock);
-	bond = __arm_smmu_sva_bind(dev, mm);
-	if (IS_ERR(bond)) {
-		mutex_unlock(&sva_lock);
-		return PTR_ERR(bond);
-	}
+	/*
+	 * This does not need the arm_smmu_asid_lock because SVA domains never
+	 * get reassigned
+	 */
+	arm_smmu_make_sva_cd(&target, master, domain->mm, smmu_domain->cd.asid,
+			     smmu_domain->btm_invalidation);
+	ret = arm_smmu_set_pasid(master, smmu_domain, id, &target);
 
-	arm_smmu_make_sva_cd(&target, master, mm, bond->smmu_mn->cd->asid);
-	ret = arm_smmu_set_pasid(master, to_smmu_domain(domain), id, &target);
-	if (ret) {
-		list_del(&bond->list);
-		arm_smmu_mmu_notifier_put(bond->smmu_mn);
-		kfree(bond);
-		mutex_unlock(&sva_lock);
-		return ret;
-	}
-	mutex_unlock(&sva_lock);
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
@@ -665,6 +398,8 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_domain *smmu_domain;
+	u32 asid;
+	int ret;
 
 	smmu_domain = arm_smmu_domain_alloc();
 	if (IS_ERR(smmu_domain))
@@ -674,5 +409,22 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
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
index 7b001afda17aa8..a82a5e4a13bb44 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1446,22 +1446,6 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
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
@@ -2021,8 +2005,8 @@ static int arm_smmu_atc_inv_master(struct arm_smmu_master *master,
 	return arm_smmu_cmdq_batch_submit(master->smmu, &cmds);
 }
 
-static int __arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
-				     ioasid_t ssid, unsigned long iova, size_t size)
+int arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
+			    unsigned long iova, size_t size)
 {
 	struct arm_smmu_master_domain *master_domain;
 	int i;
@@ -2060,15 +2044,7 @@ static int __arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
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
@@ -2080,19 +2056,6 @@ static int __arm_smmu_atc_inv_domain(struct arm_smmu_domain *smmu_domain,
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
@@ -2281,7 +2244,6 @@ struct arm_smmu_domain *arm_smmu_domain_alloc(void)
 	mutex_init(&smmu_domain->init_mutex);
 	INIT_LIST_HEAD(&smmu_domain->devices);
 	spin_lock_init(&smmu_domain->devices_lock);
-	INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
 
 	return smmu_domain;
 }
@@ -2324,7 +2286,7 @@ static void arm_smmu_domain_free_paging(struct iommu_domain *domain)
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
 		/* Prevent SVA from touching the CD while we're freeing it */
 		mutex_lock(&arm_smmu_asid_lock);
-		arm_smmu_free_asid(&smmu_domain->cd);
+		xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
 		mutex_unlock(&arm_smmu_asid_lock);
 	} else {
 		struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
@@ -2342,11 +2304,9 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
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
@@ -2805,6 +2765,9 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 
 	/* The core code validates pasid */
 
+	if (smmu_domain->smmu != master->smmu)
+		return -EINVAL;
+
 	if (!master->cd_table.in_ste)
 		return -ENODEV;
 
@@ -2826,9 +2789,18 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
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
@@ -3105,7 +3077,6 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 
 	master->dev = dev;
 	master->smmu = smmu;
-	INIT_LIST_HEAD(&master->bonds);
 	dev_iommu_priv_set(dev, master);
 
 	ret = arm_smmu_insert_master(smmu, master);
@@ -3287,17 +3258,6 @@ static int arm_smmu_def_domain_type(struct device *dev)
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
index 107a39f1dfe869..3516869954ea33 100644
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
@@ -711,7 +708,6 @@ struct arm_smmu_master {
 	bool				stall_enabled;
 	bool				sva_enabled;
 	bool				iopf_enabled;
-	struct list_head		bonds;
 	unsigned int			ssid_bits;
 };
 
@@ -740,7 +736,8 @@ struct arm_smmu_domain {
 	struct list_head		devices;
 	spinlock_t			devices_lock;
 
-	struct list_head		mmu_notifiers;
+	struct mmu_notifier		mmu_notifier;
+	bool				btm_invalidation;
 };
 
 struct arm_smmu_master_domain {
@@ -779,9 +776,8 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
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
@@ -793,8 +789,6 @@ bool arm_smmu_master_iopf_supported(struct arm_smmu_master *master);
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


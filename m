Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291B47D3F0;
	Mon,  4 Mar 2024 23:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595873; cv=fail; b=rSv7mAqzaqVg08lacNT/U+NTvNp28TlwG+6Ow6+3lSSup5gDX6ed8RCMBZ9kXBIuafChjjUlEOQyyKVeGHr/g8B2B3XkcHfsLqx8pfdo998EWdGs+8JvD2p1iqwIO7krEkCgPdRXGtMmTQzkwhlqc9wOTls/WQ5RnKZnXRz1cDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595873; c=relaxed/simple;
	bh=I9vo/kH7ZXjwK+7lDvqF/1f8k/Cir5Z1pk3DI2ImkDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IRJVoltZqsdSmkw4Z7PQYTMc/tnRcDKEk1KLY3UgsumDVXZXemh3ADuVqk1VHxpejUFW5s92tL++R5vFg8aJvSRBPufcqfkFyw1I+jkQDpp8HJHkmYc1hU5HoaIVo2qdGJUDdWUanK0g4pCp0SugHM1d9b5BtKgrh/yv9g7aaKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M5Oa/Mm2; arc=fail smtp.client-ip=40.107.94.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M5Oa/Mm2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFHDMUl9lwZcND4osBKxTfmkyFhu5UYtv7BGiCGL4jUOY6gBKFljqRb37iBgDJ8cIlMu6q07fs0/t7RLnqVBWLjmGDHs+hcwh8MKiabYNRmFcGueisOQoPHRu9tuGc9Y9mrEwpiwLSxDpBegtRd0abFkvL8LGAHpmAFbPv4F3jnQkZKxp9Y/qkCpFIQFNFm5w8eusSGbUT2TWAdEHOaZM7IiC66TraRJu67eDrVkLB7b182GrCeSh0lEa6fwoAdmNY37xP/jjcT1TBbWRH0EE1Z34+1lPsD2GHZtGu6Sd0rgs0bs1WDsKLj6cvt94DoP/kl5LPC6D6lt+j9/Fq8q8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tjhAzTMP8fyhstK8cwolNw8VACl66XcZCd8m5G0M9tM=;
 b=c5ByL9q831EWoAZP3E1k32P1Zdl4Xzhfnx9rePxXMOMKlTlsIq4qNw0RlOylmOQkbK+m398Ue4lcSGUXfu7/MQzN/sNQ7iloHIfHvgESWNFzUpTKsPgC+ZeUSuc5GmPXBO1kYqXnu43UVBqRY9ENAhNHSOVn5dyO/1XdB2I35NBTnlCKnHv/It0dnPFkycajU5bIR3CaLfcbXYi6TKNDfqv7Dne941fxLE6pH6FqmzHqMvEQrc1d9IcOegOwvhGPwDglJYq5Po4VVv/ooOUsIIQPCccidkxO78uNRFGjA+iyPC/K6u+zyrPoINQFNAkxoXPbsxnOAaBBpPZGky4fRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjhAzTMP8fyhstK8cwolNw8VACl66XcZCd8m5G0M9tM=;
 b=M5Oa/Mm2mbMeYG7J18rQAaiWzlDiDsDUpoCQvlvhe1drBbvnslPCzAGaigmvwUlo0cLauFfgPcqPhjcb6NwCirgMGezJ70t6lY6Bko3FYW+82I3Hv3jsieh0DdBIQ0YlhBhjKce7/9tP7UYoEwPUscMDceU2le4nhzXza/7WP03+5RFtrL5QYPpCwm6Lj+xaWA5NtwawY6DgcrBBNYzA45giRGu7ctesnYfOBdHhc6Vo/VsZ+bOHo8Tdvs5kdSQXSD1zsWetbJvigjgjKsMfGQvd9JfC2kS0wVNBw1c8fi9nATg0kIbRl1+SZdgyFdrSd9Vpu/S2B2BuWEf9RgdL2A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW6PR12MB8949.namprd12.prod.outlook.com (2603:10b6:303:248::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 23:44:20 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:20 +0000
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
Subject: [PATCH v5 24/27] iommu/arm-smmu-v3: Bring back SVA BTM support
Date: Mon,  4 Mar 2024 19:44:12 -0400
Message-ID: <24-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0042.namprd20.prod.outlook.com
 (2603:10b6:208:235::11) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW6PR12MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: f7c04290-866a-4ac0-697f-08dc3ca50106
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iaFHzQ7h70LiH1bzZycTmA0B2vk+7Sq6Bx0HsqiQSHiKxd8K8S/Q3RkUyQk73uiiBvzh3k4Vifti9ag7UKiJZacmrbdDnWstAhx+TeXioj66fVTQi2WNQVk1BWwtLhzMuud0PvDcmlrB3f83u0TxqoTwDCaVRXGes7H5Ij7OdThJWeDWgMgzmER8dR79FlK7jgEV/rzkUHRvl0ZqP7Y9t72HzBgKlPM/wGUouOTBw9NWX3qxPpI7XMwPPEOVEWx7ymiNxqdaIymqDRTnbKLOzYB1MyPPr/oX9RG12/eVJO5XqJ5uKh47yLfPa0QkCKkUoSF5azg7qgTm2NT4AI1+PnrnzBGWdy5IRn5Z+5n4O1bs5RS8rWEKfpO2TA/XZRs8DE/Ze280cGvK5FkvrtJI39dIhrIC7sB1hGEEF1ZS6wGkEhc+00zxv683VmHtzB6atAz5uJxiybb3KyCM5gWQCokW3OMKYcKMHSvvdGrjxktYZ5j2PdpdQVlT3IvoMcgFEu2Hd0xQaNnkD3/K3CbiS8mZuNoHCarp1pVcTPh0qu/FcFrqqZjacSzY0CdKr0dKKhsSUJuziA6eFxRszDVjgMu+FiUnQXQWEulL/LD/2PrPaaLNqU21pMr/EqOodV48yjf0kAK0mqL/8L3J1KZHoahU7Vfm33AdlnWdBCS9Xb0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yr0bvvY3atl2YLwPdVV3HxgkNZ8GimEqjCrLZAXqGnG2N52W5Olzz08p82S3?=
 =?us-ascii?Q?yG3TusL+F+yDdYWD7rlWEmVnnz9X/wfIq//iAeAK7gfn6B/WGmfDWgMIAbAr?=
 =?us-ascii?Q?QgcAs1p3MdEEJntY7wBy/uJvbzJ+0lk3DMdjPyvSCyY192VJ8FaPoJ7/E8US?=
 =?us-ascii?Q?cgTiW3rWmLVmLjjW1AP8oaXgEow1RZXPXjROkeLzErPrfgAz0BAAkUPg+Qcs?=
 =?us-ascii?Q?NcI/XOEWcJUGnqvh+TH0z+S8jWQYzjZslZ39DqSqte4itnzQQAE1aEIbiQpc?=
 =?us-ascii?Q?XXDsIc6UFy3P+4RAjidU67nGywfFzyKK380KHg6s6IbhYuq7nclU/D3fR5mh?=
 =?us-ascii?Q?vroU7214kqkyS2rIgmlP65Kl8QwL5scEiPpJD0XLiHBMg4MRWhTimeQwbdN9?=
 =?us-ascii?Q?mUHeF5rGuzD27meAh6ZBaxoXMzg2A+fzbIXlNBRiezM6gFkEob0KuURMZ458?=
 =?us-ascii?Q?17UVzwyh6k0mCPdX/7/gKwrprK1VfU21ogz1EIQBQlNSLZ15oSXP7RCugb3d?=
 =?us-ascii?Q?90us3k5ratECgOInjjrgysz3l1vDSa5D4hgrmwM1SF4jcDWvUfmv2xb63lDo?=
 =?us-ascii?Q?YkMtkNrrN3FPilwKzGOkApEh2IyuWJaR1g5lLfrep8M100x2RTBL+N/5jpq/?=
 =?us-ascii?Q?Sfu0QEdONzHb/e0VA/Q1NzlwGFav5e0sxPsTwJYS6EAdthRXsMwrFq6buPCv?=
 =?us-ascii?Q?FSdjdjy8UXNuhR/32uurZ8vI/Wkiikod+d7jy7kh9CzXbar4QxU02XKkk+/2?=
 =?us-ascii?Q?c/8eU61QM7y5lX2CxlCuCXX6I9+/NSWDgJCeFs95EKVaJwlPKVUG6i3fdyB4?=
 =?us-ascii?Q?uNF8iLInNpgCKBqWU+ztR2TGyrUHa0tRcPIjzzxVS5T4DHgly57+yo/UkjkB?=
 =?us-ascii?Q?g/yZ5riYDSgWTCDW2AwsHsgfsiwVGQmsrFbZKVvjak53tVekhEWZVb/za8PB?=
 =?us-ascii?Q?v6L/T19wXPRO5930XVluxX9QhOVtmu/B+kMMPiT2N7Tu9bG0tRRfuAPjpJaK?=
 =?us-ascii?Q?h0Z/oRlsX8RBaRv9cU9DT9moWRPUKcybvKE9Wpr9r8oYD/i6VVE7bijk+lkb?=
 =?us-ascii?Q?h7JLPymG5Fw7qGsNbiWAzNpvur+GGdepW34azEAJl+KzkRCaq8BQJv7jZSGz?=
 =?us-ascii?Q?DfsP/INwaLvH/EV1Fe+sl7mCSnsh2PTAAEDf7UOlZq5hLHcilKNEVmygF1+c?=
 =?us-ascii?Q?P5WSWJK6zj2UHk6PjcmSMdeG3i3F0RIavYD8X5y3FwH6EbmANNkNF3TiHR9L?=
 =?us-ascii?Q?XiXVB2L6/Ica7hURPtOUJYUkHnJkRiKp+SPqxkYVlAnKuxRjEUd8NzjwK0nI?=
 =?us-ascii?Q?7RRzbqJ2iUlI6pzhIGODSPGPwub0juP/2ssgN5kXbcmUhVIiRsRGNWh0UqHd?=
 =?us-ascii?Q?QyXqrFKSYoZvVtFc9TMUiWKRfcHeLb6EJQFyjbD2xIQnWPE7ziQEmkSPMdBo?=
 =?us-ascii?Q?7YMDxm26b9B8Z3+4XLmEzNqUhWYdwHuvnVAjZ9agz+A1e1uCb/gQRy8AbzD3?=
 =?us-ascii?Q?MqOa4f2iR71uYCbLVh7P+cJ9arAVmZm9fiLxpk5X1Ne0X4R87uwJ7CWUHZWo?=
 =?us-ascii?Q?8yc+QWKvfsPJJqMMJZ7NvPmkaYdREhia8fBIICew?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7c04290-866a-4ac0-697f-08dc3ca50106
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:16.6328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XOq9+kiqaNSq+Uyx6sQpYgCupQGHq9PwHXLr+RlV6ftoEUbL+Hz90n6qBcm9SsU8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8949

BTM support is a feature where the CPU TLB invalidation can be forwarded
to the IOMMU and also invalidate the IOTLB. For this to work the CPU and
IOMMU ASID must be the same.

Retain the prior SVA design here of keeping the ASID allocator for the
IOMMU private to SMMU and force SVA domains to set an ASID that matches
the CPU ASID.

This requires changing the ASID assigned to a S1 domain if it happens to
be overlapping with the required CPU ASID. We hold on to the CPU ASID so
long as the SVA iommu_domain exists, so SVA domain conflict is not
possible.

With the asid per-smmu we no longer have a problem that two per-smmu
iommu_domain's would need to share a CPU ASID entry in the IOMMU's xarray.

Use the same ASID move algorithm for the S1 domains as before with some
streamlining around how the xarray is being used. Do not synchronize the
ASID's if BTM mode is not supported. Just leave BTM features off
everywhere.

Audit all the places that touch cd->asid and think carefully about how the
locking works with the change to the cd->asid by the move algorithm. Use
xarray internal locking during xa_alloc() instead of double locking. Add a
note that concurrent S1 invalidation doesn't fully work.

Note that this is all still dead code, ARM_SMMU_FEAT_BTM is never set.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 133 ++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  15 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   2 +-
 3 files changed, 129 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 3acd699433b7d8..0b5aeaa3a85575 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -15,12 +15,33 @@
 
 static DEFINE_MUTEX(sva_lock);
 
-static void __maybe_unused
-arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
+static int arm_smmu_realloc_s1_domain_asid(struct arm_smmu_device *smmu,
+					   struct arm_smmu_domain *smmu_domain)
 {
 	struct arm_smmu_master_domain *master_domain;
+	u32 old_asid = smmu_domain->cd.asid;
 	struct arm_smmu_cd target_cd;
 	unsigned long flags;
+	int ret;
+
+	lockdep_assert_held(&smmu->asid_lock);
+
+	/*
+	 * FIXME: The unmap and invalidation path doesn't take any locks but
+	 * this is not fully safe. Since updating the CD tables is not atomic
+	 * there is always a hole where invalidating only one ASID of two active
+	 * ASIDs during unmap will cause the IOTLB to become stale.
+	 *
+	 * This approach is to hopefully shift the racing CPUs to the new ASID
+	 * before we start programming the HW. This increases the chance that
+	 * racing IOPTE changes will pick up an invalidation for the new ASID
+	 * and we achieve eventual consistency. For the brief period where the
+	 * old ASID is still in the CD entries it will become incoherent.
+	 */
+	ret = xa_alloc(&smmu->asid_map, &smmu_domain->cd.asid, smmu_domain,
+		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
+	if (ret)
+		return ret;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	list_for_each_entry(master_domain, &smmu_domain->devices, devices_elm) {
@@ -36,6 +57,10 @@ arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 					&target_cd);
 	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+
+	/* Clean the ASID we are about to assign to a new translation */
+	arm_smmu_tlb_inv_asid(smmu, old_asid);
+	return 0;
 }
 
 static u64 page_size_to_cd(void)
@@ -148,12 +173,12 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 	}
 
 	if (!smmu_domain->btm_invalidation) {
+		ioasid_t asid = READ_ONCE(smmu_domain->cd.asid);
+
 		if (!size)
-			arm_smmu_tlb_inv_asid(smmu_domain->smmu,
-					      smmu_domain->cd.asid);
+			arm_smmu_tlb_inv_asid(smmu_domain->smmu, asid);
 		else
-			arm_smmu_tlb_inv_range_asid(start, size,
-						    smmu_domain->cd.asid,
+			arm_smmu_tlb_inv_range_asid(start, size, asid,
 						    PAGE_SIZE, false,
 						    smmu_domain);
 	}
@@ -182,6 +207,8 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 		cdptr = arm_smmu_get_cd_ptr(master, master_domain->ssid);
 		if (WARN_ON(!cdptr))
 			continue;
+
+		/* An SVA ASID never changes, no asid_lock required */
 		arm_smmu_make_sva_cd(&target, master, NULL,
 				     smmu_domain->cd.asid,
 				     smmu_domain->btm_invalidation);
@@ -388,6 +415,8 @@ static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
 	 * unnecessary invalidation.
 	 */
 	arm_smmu_domain_free_id(smmu_domain);
+	if (smmu_domain->btm_invalidation)
+		arm64_mm_context_put(domain->mm);
 
 	/*
 	 * Actual free is defered to the SRCU callback
@@ -401,13 +430,97 @@ static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
 	.free			= arm_smmu_sva_domain_free
 };
 
+static int arm_smmu_share_asid(struct arm_smmu_device *smmu,
+			       struct arm_smmu_domain *smmu_domain,
+			       struct mm_struct *mm)
+{
+	struct arm_smmu_domain *old_s1_domain;
+	int ret;
+
+	/*
+	 * Notice that BTM is never currently enabled, this is all dead code.
+	 * The specification cautions:
+	 *
+	 * Note: Arm expects that SMMU stage 2 address spaces are generally
+	 * shared with their respective PE virtual machine stage 2
+	 * configuration. If broadcast invalidation is required to be avoided
+	 * for a particular SMMU stage 2 address space, Arm recommends that a
+	 * hypervisor configures the STE with a VMID that is not allocated for
+	 * virtual machine use on the PEs
+	 *
+	 * However, in Linux, both KVM and SMMU think they own the VMID pool.
+	 * Unfortunately the ARM design is problematic for Linux as we do not
+	 * currently share the S2 table with KVM. This creates a situation where
+	 * the S2 needs to have the same VMID as KVM in order to allow the guest
+	 * to use BTM, however we must still invalidate the S2 directly since it
+	 * is a different radix tree. What Linux would like is something like
+	 * ASET for the STE to disable BTM only for the S2.
+	 *
+	 * Arguably in a system with BTM the driver should prefer to use a S1
+	 * table in all cases execpt when explicitly asked to create a nesting
+	 * parent. Then it should use the VMID of KVM to enable BTM in the
+	 * guest. We cannot optimize away the resulting double invalidation of
+	 * the S2 :( Or we simply ignore BTM entirely as we are doing now.
+	 */
+	if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_BTM))
+		return xa_alloc(&smmu->asid_map, &smmu_domain->cd.asid,
+				smmu_domain,
+				XA_LIMIT(1, (1 << smmu->asid_bits) - 1),
+				GFP_KERNEL);
+
+	/* At this point the caller ensures we have a mmget() */
+	smmu_domain->cd.asid = arm64_mm_context_get(mm);
+
+	mutex_lock(&smmu->asid_lock);
+	old_s1_domain = xa_store(&smmu->asid_map, smmu_domain->cd.asid,
+				 smmu_domain, GFP_KERNEL);
+	if (xa_err(old_s1_domain)) {
+		ret = xa_err(old_s1_domain);
+		goto out_put_asid;
+	}
+
+	/*
+	 * In BTM mode the CPU ASID and the IOMMU ASID have to be the same.
+	 * Unfortunately we run separate allocators for this and the IOMMU
+	 * ASID can already have been assigned to a S1 domain. SVA domains
+	 * always align to their CPU ASIDs. In this case we change
+	 * the S1 domain's ASID, update the CD entry and flush the caches.
+	 *
+	 * This is a bit tricky, all the places writing to a S1 CD, reading the
+	 * S1 ASID, or doing xa_erase must hold the asid_lock or xa_lock to
+	 * avoid IOTLB incoherence.
+	 */
+	if (old_s1_domain) {
+		if (WARN_ON(old_s1_domain->domain.type == IOMMU_DOMAIN_SVA)) {
+			ret = -EINVAL;
+			goto out_restore_s1;
+		}
+		ret = arm_smmu_realloc_s1_domain_asid(smmu, old_s1_domain);
+		if (ret)
+			goto out_restore_s1;
+	}
+
+	smmu_domain->btm_invalidation = true;
+
+	ret = 0;
+	goto out_unlock;
+
+out_restore_s1:
+	xa_store(&smmu->asid_map, smmu_domain->cd.asid, old_s1_domain,
+		 GFP_KERNEL);
+out_put_asid:
+	arm64_mm_context_put(mm);
+out_unlock:
+	mutex_unlock(&smmu->asid_lock);
+	return ret;
+}
+
 struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 					       struct mm_struct *mm)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_domain *smmu_domain;
-	u32 asid;
 	int ret;
 
 	smmu_domain = arm_smmu_domain_alloc();
@@ -418,12 +531,10 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	smmu_domain->domain.ops = &arm_smmu_sva_domain_ops;
 	smmu_domain->smmu = smmu;
 
-	ret = xa_alloc(&smmu->asid_map, &asid, smmu_domain,
-		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
+	ret = arm_smmu_share_asid(smmu, smmu_domain, mm);
 	if (ret)
 		goto err_free;
 
-	smmu_domain->cd.asid = asid;
 	smmu_domain->mmu_notifier.ops = &arm_smmu_mmu_notifier_ops;
 	ret = mmu_notifier_register(&smmu_domain->mmu_notifier, mm);
 	if (ret)
@@ -433,6 +544,8 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 
 err_asid:
 	arm_smmu_domain_free_id(smmu_domain);
+	if (smmu_domain->btm_invalidation)
+		arm64_mm_context_put(mm);
 err_free:
 	kfree(smmu_domain);
 	return ERR_PTR(ret);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 1a72dd63e0ca14..01737a0fc82828 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1314,6 +1314,8 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =
 		&pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
+	lockdep_assert_held(&master->smmu->asid_lock);
+
 	memset(target, 0, sizeof(*target));
 
 	target->data[0] = cpu_to_le64(
@@ -2089,7 +2091,7 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 	 * careful, 007.
 	 */
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
-		arm_smmu_tlb_inv_asid(smmu, smmu_domain->cd.asid);
+		arm_smmu_tlb_inv_asid(smmu, READ_ONCE(smmu_domain->cd.asid));
 	} else {
 		cmd.opcode	= CMDQ_OP_TLBI_S12_VMALL;
 		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
@@ -2334,17 +2336,10 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
 static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
 				       struct arm_smmu_domain *smmu_domain)
 {
-	int ret;
-	u32 asid;
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
 
-	/* Prevent SVA from modifying the ASID until it is written to the CD */
-	mutex_lock(&smmu->asid_lock);
-	ret = xa_alloc(&smmu->asid_map, &asid, smmu_domain,
-		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
-	cd->asid	= (u16)asid;
-	mutex_unlock(&smmu->asid_lock);
-	return ret;
+	return xa_alloc(&smmu->asid_map, &cd->asid, smmu_domain,
+			XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
 }
 
 static int arm_smmu_domain_finalise_s2(struct arm_smmu_device *smmu,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 6becdbae905598..a23593f1830106 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -586,7 +586,7 @@ struct arm_smmu_strtab_l1_desc {
 };
 
 struct arm_smmu_ctx_desc {
-	u16				asid;
+	u32				asid;
 };
 
 struct arm_smmu_l1_ctx_desc {
-- 
2.43.2


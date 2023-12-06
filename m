Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843A7697A6;
	Wed,  6 Dec 2023 17:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k73kaAj9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jb/Z70oOmrwwUMKo2USTfL1gO5hlbphwNuSrxHJEW6JAdJqlMAXc+fuOe7TUGU8fGk7ibkk3k6dauqbvl7OD220kF4Kq+A9UZH4gVunC0HSFERPIZVD+1oQepxpCmMVrN2xFTD+FR/j3gAKYsFEB/TTJlNB9dzYjCnwztPgSu5fzV8d5M4ulwVvS6se9thVYygZA6YeP04Eexy4eET+jKavsCfMEdzmdvM6XSQHcNw17vZR9RKEyxcyaSd7vV7FNvL8fXyT8yvqjXKBQCn7i6BrIGR/0toQQZdpFXaoKOwVj1XHe3CaXOiTJeZOXBx+Ys3It3hSIKTX/+ybu47EOlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=71n1HqtL37oKBJQMf5vh6u3uyKKmodyLm/E0Hfw4+MQ=;
 b=dknM65pf2+lzgn6kHNSY17byZzXriRyBsgq+R+M3HEHGWA3u/h0p+ReLCep21AfEfGiu3ZLZm7cmdultfJrCr4uaq32J56nyPmzXIrknB9Hc+hhjrPJZf2Sby1UoFkpdaxDd0PngsWdxBRLtI8KB0vaVHHD4tNLZA1ACLEp0F3KNGaLsm10eLXK6HFSVZ4FtZwoRtXrTRj8IBfA9zr/VoCS3BZX4yZrlsHG310kzHICfK+ynoPDcI5qLZHEf7TfvUKiwNFebvWwqxpcSBCSbFCQdZmqo5Lhs2fWoPGxnJcF8HeRt65jHjcZOK/CJi/6VBWRumC6NddI+IbM4byYsTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71n1HqtL37oKBJQMf5vh6u3uyKKmodyLm/E0Hfw4+MQ=;
 b=k73kaAj9PKl3APzCo4wu0dqUemBpB4Pfsx6e7mvxh9TzbxEuxJIFqL84t5dfZrk8iws38O7pm2E3sWhz6enekDo9YcxUGAwACU7RqpWdBEn7ZSs3TAvKkzhqLx2tc65O2rTjNS15fsSaFyr7MwSAhLuM5MdlJ6faCwTLUXr1UrNkOhiZHUVkil2DhisRUtsHn1ykuvFQ9Lt6W6CUdJteksVfZM+FyQjp9AkQ/F2zCdkMhBP/pIFThIFfEc6Vv3JbsdO0gYZfqyXXWmO1PkTlf+n01/ymoBw5lF92qDUUMaefb7yE5cZU9dl5eQGOP0jbE9AbMvdeWrIJgfHsqs7Kxw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8360.namprd12.prod.outlook.com (2603:10b6:208:3d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 17:28:44 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:44 +0000
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
Subject: [PATCH v3 24/27] iommu/arm-smmu-v3: Bring back SVA BTM support
Date: Wed,  6 Dec 2023 13:28:30 -0400
Message-ID: <24-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0017.namprd22.prod.outlook.com
 (2603:10b6:208:238::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8360:EE_
X-MS-Office365-Filtering-Correlation-Id: 25db4a49-20b9-4c4f-c7e4-08dbf680c70e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nFq77Hm5THDw3+fd+3q/K4azB7bTpoosZ+GXzV6KiZ1KTJghtSTwuweRea6aD/7muE01Txsl4EaAenRe1vp85vtMdS1EvAqyXi7CBuDNsTtDyiYLzAWme5FRRPsFU6YUlgxncqF1BqhRlOvnw1UEDz3L5bSRb5a4USNdW/O1D2IzUGuFuVcRegtc7EfW+nStZfOcwtkKJYurUAgrDgLz0NUyOr51k1DO48SjWT7uTxQ12pBOEoWwdRMGDUX+uz+LcZRALDmSlpexUrBFWmVKdSQopVdPODQRJHQ+EjtVO5g+dFNBHM9uF8JEgjTBisf9i9IH6FJ+0FHFrF79tE4TFJ+cxuDJRWNo0clm2R9ot2VF6wfyBuVHfVNkbi6HdpnFhQiT5HjFeYG9UNeECc7+p53qXWrxjt2kMwiQG6nonCcnWJYs6SsobWSDzsu0VdE93coL+ejpv/hHr0PR75QxjFN3kkLF1qexZBT5iE1bCFHBRDcSqg6uX7rysVTvvO3gmlMjkeWa7fm9bNESv6q+HysyOjudeygzNMsZXoqjBs30828QD6Q+e4YQdXDsrN4qynUyluuy75R8j/QmTMEi/r/ZzaBjeToNwi3PfFojEHixTMoIyt+oNNk6LcMEj4PY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(230273577357003)(230173577357003)(186009)(64100799003)(1800799012)(451199024)(6666004)(6486002)(478600001)(38100700002)(83380400001)(66946007)(6512007)(2616005)(66476007)(6506007)(8676002)(2906002)(30864003)(4326008)(54906003)(7416002)(5660300002)(86362001)(36756003)(41300700001)(66556008)(8936002)(316002)(110136005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DRAHc03d65L7zNPq4fCfKGbmQC464lHy3c/xhOZu4Bw1DSVe03RRdppCUYRp?=
 =?us-ascii?Q?tEfkhZQC6Bd2xi23rHNbeIqIjEgi3OBglSXe7aW3gwilikAGw13XUsma10om?=
 =?us-ascii?Q?hXVx1LiOjrl9X7+n14Cw0ezikhoWXvbBgZAyjf59uL8iOPezRHNprXJVZOde?=
 =?us-ascii?Q?kdaXiomn/ctpmwv9Bps19V9iHLHiXduNW3zmcRgYkJMYVGLCd5X/pUrJQy+N?=
 =?us-ascii?Q?ETtPwTGp59eeo9YntL0lHrzsKEhjVmn50Mu+hH8wYBxq9PL4oO/xcVkY3NvC?=
 =?us-ascii?Q?IOTRDomV8MoPOcuOtF0Iai+Eu0reJmmTXjBLBmhiQ7191hDrus2OwEz1a+TK?=
 =?us-ascii?Q?HDO7zHoN+zbIRrjclnOPIXxB34ZCH6c/Mh8ymmFeCMBGpJ80u/+m6bEJfteZ?=
 =?us-ascii?Q?lGFBtQbV6G9acNCcksHFlVju0sJ3TZBZVgVCWGqm2B1m5dWIlvCKuYtjqVo3?=
 =?us-ascii?Q?aE+u6w3jix76kaoAeYwsB3aHi6Mw17BCYKuKwMetU6RTQ3y0zQrQZa9UKiaH?=
 =?us-ascii?Q?zk92y5gZD+kE5kwbU5ic0o1d0TVuLzFMRxQLNNH0/Qbd1gGOLhGrnEik9d2r?=
 =?us-ascii?Q?HpcyOU/6HmGpQYIgrSBObaxV/PI8LS0LheEku1r21Tr+8aCku8B9Gmd+H9ic?=
 =?us-ascii?Q?w81SHaPXvQ/aTSbM1azIDcUfKmZXm7/AkLpeOe1nTWF7E+L6Y/oM7rGRPggE?=
 =?us-ascii?Q?4h74eUEhACU0bCw0I2pGewvfDPU92Q4mlWMsa/44MTWNvaf6Udk+Zmcp1CKk?=
 =?us-ascii?Q?bjXbTE52VATMveTyavqoyNG6uKtHEMVczWgWnOxtDFqHimi9UMfAL2RDD+xX?=
 =?us-ascii?Q?GOMVvraK5B+yuNhO9GsFytFVjXFyrrxCvvECMrmMH9+E17ck1q8v9clVtnJI?=
 =?us-ascii?Q?XA6MK+5OqOHptb3vvyEu7RvFwSDkItZkPPrG0zndK3Lph+zieMLdZCPXwDw9?=
 =?us-ascii?Q?s2Y9pv8jnG1WXCUpUzi6kHEQpcnOsS1v8GUa1DfHHNRdMu+jeUmv4UKGF+3t?=
 =?us-ascii?Q?DRhZ47u9uQ0Qjv4uYSxSgSZR379rmenB/5VL98CprUDpmjJN43/j0M7dsKxY?=
 =?us-ascii?Q?maFI6P3QAJ3dZ3L8SNaiMvXFAMyD5qn6iCScgBbH5MfO7zwKJ5H+JfPxNb0S?=
 =?us-ascii?Q?OTDgNnC8zGFVHKk/Tm1vZF5DiaoVG3fLFuroo5wgXRT0qhLfF0v5DEmoufzg?=
 =?us-ascii?Q?Owfackt+NN2nkvUCjtsDmDUn54bVexCrHWUEn5I1bWDRkqEOGGjpDjPP92GE?=
 =?us-ascii?Q?RXp0PG0spqTfLLVtnQJz2cFyUAWu5syYof3qO1rWQgKNG7fTLmOtZ5g8FCuY?=
 =?us-ascii?Q?WQdw7PWxSIgY500Xazzkpk+H95pUqZ9G2xVZ4nwB54YqWSQ1BhU//zCiKLjF?=
 =?us-ascii?Q?zICG9XsccCy6f1jxvGQgvFH3bwmRw+VxGhlFz8J7C3lj4JGxe3YKtFU2bDQ+?=
 =?us-ascii?Q?wElemp9uI/MqBeNMSiT+VRIQMlrv3QAWlNF1n0WJ6ZsbT8dACX3lhNc7+JpF?=
 =?us-ascii?Q?mRH56FGukiRQnxA18suKOOXZ+2OU1OWUc58cQ5UVAzeyaj7qtLlT6eRuV1VM?=
 =?us-ascii?Q?aj/VIofyXRI+B7ETzGHKn8HuP1I1J0jzagZGF6wG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25db4a49-20b9-4c4f-c7e4-08dbf680c70e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:36.0524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O3sydVfj1GvRwlk+EcN22nLxW8JM218uMd+dmK3UlV7TxuEWG+pnUr698xW7E+aj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8360

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

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 133 ++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  15 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   2 +-
 3 files changed, 129 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index d5772ce27d48b2..e1df7dca853615 100644
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
@@ -138,12 +163,12 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
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
@@ -172,6 +197,8 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 		cdptr = arm_smmu_get_cd_ptr(master, master_domain->ssid);
 		if (WARN_ON(!cdptr))
 			continue;
+
+		/* An SVA ASID never changes, no asid_lock required */
 		arm_smmu_make_sva_cd(&target, master, NULL,
 				     smmu_domain->cd.asid,
 				     smmu_domain->btm_invalidation);
@@ -378,6 +405,8 @@ static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
 	 * unnecessary invalidation.
 	 */
 	arm_smmu_domain_free_id(smmu_domain);
+	if (smmu_domain->btm_invalidation)
+		arm64_mm_context_put(domain->mm);
 
 	/*
 	 * Actual free is defered to the SRCU callback
@@ -391,13 +420,97 @@ static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
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
@@ -408,12 +521,10 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
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
@@ -423,6 +534,8 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 
 err_asid:
 	arm_smmu_domain_free_id(smmu_domain);
+	if (smmu_domain->btm_invalidation)
+		arm64_mm_context_put(mm);
 err_free:
 	kfree(smmu_domain);
 	return ERR_PTR(ret);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e30de36044cac5..3907cf4db3efe1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1217,6 +1217,8 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =
 		&pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
+	lockdep_assert_held(&master->smmu->asid_lock);
+
 	memset(target, 0, sizeof(*target));
 
 	target->data[0] = cpu_to_le64(
@@ -2026,7 +2028,7 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 	 * careful, 007.
 	 */
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
-		arm_smmu_tlb_inv_asid(smmu, smmu_domain->cd.asid);
+		arm_smmu_tlb_inv_asid(smmu, READ_ONCE(smmu_domain->cd.asid));
 	} else {
 		cmd.opcode	= CMDQ_OP_TLBI_S12_VMALL;
 		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
@@ -2269,17 +2271,10 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
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
index efc6bc11bbb838..96b01db47b0ea5 100644
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
2.43.0


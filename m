Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2595B14D456;
	Wed, 27 Mar 2024 18:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562917; cv=fail; b=aj8/AgQvcWuVRkAV30Y0+iAqZn93pQHITq/0Hk+bK4O11tCuNUbRyx5yefSbY9TaKUQH3b2mN89TXXl7VYlPvn8tdkUKs3j1PAU7Vx2fC28WzGci+v4zbKWqZtaGyxFxvMqM4BkKReZiA6ZuEFdQtHGvf93EZ94gt+7WqRxTGQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562917; c=relaxed/simple;
	bh=x4wUUNMMXiAp+pUL8cnMcCPdbHSXY21QB4cNdb3eK+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nk0tDfRTQNDrbtKJupHmzUxpC0NefSH3BUow6+Xz3h4PibJAHYJ3Pluva3y4t11JBiq7O0DTQV+LFmXaTZEBE4wXZFFBRMaskxs4F+MfjPqtN+xA2j0ovoChKKjHLU5IFflJKRJdtfuKjpQcJAJUNnBOOBronxm0h1wfeUXx62M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SvDmpU2p; arc=fail smtp.client-ip=40.107.93.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SvDmpU2p"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MM2Ub9oxXp3bMswMENfaOtI0d/uaUDCqUdRQmxC8LsPfG74n3UP4QumvMz2MPqewo0t8FAm9T6559lkeTavPUDlhSSJ+wc5sLCyxtpzDAuitnUXyan7GyvEmsdH+GbIttV0UjUndt7cCNrK+IWbl1zrz5CTjKfy5/lmS6GNoLPXFiDMnvIQlXwKYPHnFyU93Nab/fUFqo7AX3SU46RGUTY2aFObYLKmvypuRhaJYVfrVW/m4/L8Ome0TCklAbI0YLvsN7B4e5ykWmgknimD0SCbwG0lvROjNGAygY0bOGhCXfqCupLCTyLiza8G/tZXj3rNujZaQzOCvLTG5c4sQRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3CIYtob+B1PrjFQ8McGfXGPUAIqLFU8bt9emLD10p/0=;
 b=h8LtzPZsj3M2aF1zspodiRVg2YXNu+LFF47bEkaR4VaWdF36oF9ZwPLpEqmTo3Eu9OQA6YguB9Vxfl62aEnPgEESJGc28aCVQVaEi8K4sC6JVJkQ1jgH0ENgqCZCeIflTqmg2srXxrdHDcr/r25mSeNIFjLWPZDwCtCKHalxGrF5z1vaaVGxtzXJUP91o4tyqtNDSgvmvryj/1zPwnZOJurLAhrveTo3PVrnNLFpF1Fur+MqUB3eUKCLekE2KzKxddcn9ttM6GSm7KhIjt39FNqGTZm8RnZ9/le3oBRjYlNqrxeZCIkipsBZZQVCHHOKc6yQhq/qXYxMDaqYxPoFNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CIYtob+B1PrjFQ8McGfXGPUAIqLFU8bt9emLD10p/0=;
 b=SvDmpU2pW+tti65GbCe6ejQUVfQxHAUx+vF2S6y1q/w+xcLbSoxNrvTsPEsHExS/GxYY4oFOqNrbU62QSei2NW+ODpBrkEnPVO6JgK1UY/W9JHq2Lm4S2QVzLTstCNzyt2S7/5KYZH5XFHKPz4Bt9PDDKHlqunLGze6GusRbU41YbCon5AGGHsNgkqF9fQRdLbdt31mFrGx5Ef/p/sb4RLJ9J94RZN/86rXDRRPDOU2hhjmtaoEHYp2bOesH8f1HMcwTw9I0icyaUFyzur719QBx21m9wuyfLczfXrG1+jmpTJERT3R96w2HbPlwusx64k+ViIJNQL1LpkNxlPr/hw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 18:08:27 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:27 +0000
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
Subject: [PATCH v6 16/29] iommu/arm-smmu-v3: Make changing domains be hitless for ATS
Date: Wed, 27 Mar 2024 15:08:02 -0300
Message-ID: <16-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0005.namprd05.prod.outlook.com
 (2603:10b6:208:91::15) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: ca4e096a-a6d6-4f8f-5aaa-08dc4e88e162
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4Igbtk3ZzGHsb6CvAUGzzTadCknsQ/c6JnBSzYw7e11k+QE0tKC3jDJ/BR5Cm0QSyCXWrrCsRImL2rLCExqqpj7GTm0TZ/nsw3SVjtS3rbM0reH9mzpdFfhaKZYG7FVS0qNrxGBCOj4PUVgIPCbyrnmkMsl+zym7toavX7ehl4HZkMQg+3OVQANTVAxVE7kWuvUmLF0jdBywH8dG4ABW0qsyUnnXpmVzMNqmhAHjyvy71G5dUr47VBatzqgbCvlMTkCZBc1Fqh0SNu+bol7VNxA36Dw6wG5RdB4dkA3FJQs8GChAoTEqdOHUsc7VBdc6jYhXQ85meh9pR4GOu0jQeMv8gd95BmB+s3BAYmK4OoSsCYC2nSca3s+R4JyIB7hN7AAdgcdlKHdS9J2s4X/KeM5Wthpkc94T/41yFVnMBjnNQwreADGKlbkwIXmpb9aArW5qu/BjJbM55kIzyBATfo6ztmHwCcsXZhBlS9bhDtTiIsLZVC+ap7GzxhxTeoGJkNkYyvhfZsCrMPTde2GI3+z8eJbPzfCIAsicrWOty1sQo/kqdPfMQhEiR4SHL/uAg6s02X3X2/vpWU9aJPKB1szImAghrdq37mKQ+ZXjYvWFzPaFiu6DNxDt1j88jHjzqnxHmWz8xsOqMOfljWCyOpbRk2rN3aVSPwWibuFM58w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?niVM+lN3im6bCxlJo3px+14IaPYoAZ+47zTPE84GQ+iomXBOV82XrR3+CI7O?=
 =?us-ascii?Q?5w1kqfpbFDtgln08990vkNvJ1s0uvnUbc9q9gwX0zwxUW9OR2FC/3ph+AJV0?=
 =?us-ascii?Q?zLuFG7afbNCX5nuNbNWtiIjb1ilaCCsLYWJumjPKvpwKJvJWYzySzHQPFuOp?=
 =?us-ascii?Q?9vxQ9YEdblLWr2YHfc/90g8boiNLWRoUtzJgVkqZ01j6gOp7HvHS1iIYOlJ7?=
 =?us-ascii?Q?Y14mf9civRZCPkiAlrzAjDB3QJAmKv5JFRJFCUUC7Ijr71CvAIVRneGgVAfW?=
 =?us-ascii?Q?E7E+8bEBr8e+avFWWMjynVgC9t6d8c21LiXUhwxAaKxIc6rAgEAuRNqcxa57?=
 =?us-ascii?Q?r1xZK66GpnGE6yD3Md+Y2zF+jhpz5F87hP5IDPjCH8zl/vugIkcPB557pgu0?=
 =?us-ascii?Q?0GnqB/Y5y7OzEhZW3vg0AmFOsxF4cIpttpWJ/dOZ4yOn5oYb9BXVQLsqsmRA?=
 =?us-ascii?Q?M23hKPWnJndjLE9SA3aCGU8wGLuRPR5ml5JrotRnM7wthpoXmKozt3mLVCmX?=
 =?us-ascii?Q?l2kkdgvWVR0OOlrUWaHaBTqY31pUv5OMu/3c7eaGixbWlXIBMk4NY3/4Ffhx?=
 =?us-ascii?Q?PZzs8bRBO22rMxIqMLCs1My4MmW1XFXSVHtDYSqKh/xdl4e5uMHcLcB+CWRi?=
 =?us-ascii?Q?ueZfCRcA08lnQUnD/sTSKA0Fshurmz9/ONQT+TY8samo3f1CKr8hLRZB8JjG?=
 =?us-ascii?Q?8akQ6puYbpeeg2wivXFfeU7Fcu5PDkTjj/wTXc16pLRnKISvddPgk2qOBgkq?=
 =?us-ascii?Q?dxzLQkaZLvNABW8HKbersSO1F+4zizqHNkVlbeeYHvuFf8TAGKSv/LMYt93k?=
 =?us-ascii?Q?+1vV0MMAbgrUU20QikGaCns9NwU52YxbKWAeRoXz2iGwigyvbMuy9aiHoGfX?=
 =?us-ascii?Q?9J1eHi96rb6BOaHLJlbfavFGXaEiO/A1tGKVtIwIjvPzP10MUy72Go0RlAqu?=
 =?us-ascii?Q?Ev1Nmt/fJA2tSRtlZ4LWqm6YX3FNpxzORdXfJzRONeGOj67/nTQY4C9xJv1Y?=
 =?us-ascii?Q?I54vp5UBZpc8e+fidPwMgHzCDW33ZhIzUtDFrZjHhKfkdCnIdtbAeo7sjIZp?=
 =?us-ascii?Q?cZvOL1vx5bMOmRojJ28N/HcnR+fkp2JccGZw48UH03fTUY8k9CVW2gVitZ3a?=
 =?us-ascii?Q?Opp5WDNaiCckhjCD7gIDdyXnOV+QCwhzyw+e36qMsUMwxi9+UFVAeh4v4DUr?=
 =?us-ascii?Q?Lwj6cybTncMPFc+1NkSwq+WvkFFGk69D8KCKQohiZbMjig0fNlHed1JjbKZJ?=
 =?us-ascii?Q?7dTODo6QFLqsRWWhurfWxURqSDdREfKYcxA2WjHHjyf+CiUizozTMxMBBt/L?=
 =?us-ascii?Q?bruLDnfvD3fEqqR7xMWkTUYbaLb6gli5kljuYPD+kN6a62V05o5TPuMiQYE9?=
 =?us-ascii?Q?pARS3PIkDUU9iBFegXnfU9urNd5kwgFB1MVcnknLIdhP2QJqRYaX5umHdVx3?=
 =?us-ascii?Q?fSW392+0TcUcDVVqKZYz6MHq9tSiVNuIWtgF53A3bhERl/hwGBJmXcNcxQKv?=
 =?us-ascii?Q?J0zRW+czK9EaACR+14b91ENEYx9rnIUodcETGe50iw6GLz/uXnj1JjREXrws?=
 =?us-ascii?Q?7/pD2t2LbI1Acjcte+3mTBHKgK1xmjVGxAYmxok8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca4e096a-a6d6-4f8f-5aaa-08dc4e88e162
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:18.5474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BtXW3PwmZB1P04Upic9UpHyUqJnOP21lDfLo3akeZKyJ6mZpmxqsMPGbF2HJlwCd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

The core code allows the domain to be changed on the fly without a forced
stop in BLOCKED/IDENTITY. In this flow the driver should just continually
maintain the ATS with no change while the STE is updated.

ATS relies on a linked list smmu_domain->devices to keep track of which
masters have the domain programmed, but this list is also used by
arm_smmu_share_asid(), unrelated to ats.

Create two new functions to encapsulate this combined logic:
 arm_smmu_attach_prepare()
 <caller generates and sets the STE>
 arm_smmu_attach_commit()

The two functions can sequence both enabling ATS and disabling across
the STE store. Have every update of the STE use this sequence.

Installing a S1/S2 domain always enables the ATS if the PCIe device
supports it.

The enable flow is now ordered differently to allow it to be hitless:

 1) Add the master to the new smmu_domain->devices list
 2) Program the STE
 3) Enable ATS at PCIe
 4) Remove the master from the old smmu_domain

This flow ensures that invalidations to either domain will generate an ATC
invalidation to the device while the STE is being switched. Thus we don't
need to turn off the ATS anymore for correctness.

The disable flow is the reverse:
 1) Disable ATS at PCIe
 2) Program the STE
 3) Invalidate the ATC
 4) Remove the master from the old smmu_domain

Move the nr_ats_masters adjustments to be close to the list
manipulations. It is a count of the number of ATS enabled masters
currently in the list. This is stricly before and after the STE/CD are
revised, and done under the list's spin_lock.

This is part of the bigger picture to allow changing the RID domain while
a PASID is in use. If a SVA PASID is relying on ATS to function then
changing the RID domain cannot just temporarily toggle ATS off without
also wrecking the SVA PASID. The new infrastructure here is organized so
that the PASID attach/detach flows will make use of it as well in
following patches.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 202 ++++++++++++++------
 1 file changed, 144 insertions(+), 58 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 4411706019f036..fb18d9d500aeba 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1538,7 +1538,8 @@ static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
 }
 
 static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
-				      struct arm_smmu_master *master)
+				      struct arm_smmu_master *master,
+				      bool ats_enabled)
 {
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
@@ -1561,7 +1562,7 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 			 STRTAB_STE_1_S1STALLD :
 			 0) |
 		FIELD_PREP(STRTAB_STE_1_EATS,
-			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
+			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
 	if (smmu->features & ARM_SMMU_FEAT_E2H) {
 		/*
@@ -1589,7 +1590,8 @@ static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 
 static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 					struct arm_smmu_master *master,
-					struct arm_smmu_domain *smmu_domain)
+					struct arm_smmu_domain *smmu_domain,
+					bool ats_enabled)
 {
 	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
 	const struct io_pgtable_cfg *pgtbl_cfg =
@@ -1605,7 +1607,7 @@ static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 
 	target->data[1] = cpu_to_le64(
 		FIELD_PREP(STRTAB_STE_1_EATS,
-			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0) |
+			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0) |
 		FIELD_PREP(STRTAB_STE_1_SHCFG,
 			   STRTAB_STE_1_SHCFG_INCOMING));
 
@@ -2455,22 +2457,16 @@ static bool arm_smmu_ats_supported(struct arm_smmu_master *master)
 	return dev_is_pci(dev) && pci_ats_supported(to_pci_dev(dev));
 }
 
-static void arm_smmu_enable_ats(struct arm_smmu_master *master,
-				struct arm_smmu_domain *smmu_domain)
+static void arm_smmu_enable_ats(struct arm_smmu_master *master)
 {
 	size_t stu;
 	struct pci_dev *pdev;
 	struct arm_smmu_device *smmu = master->smmu;
 
-	/* Don't enable ATS at the endpoint if it's not enabled in the STE */
-	if (!master->ats_enabled)
-		return;
-
 	/* Smallest Translation Unit: log2 of the smallest supported granule */
 	stu = __ffs(smmu->pgsize_bitmap);
 	pdev = to_pci_dev(master->dev);
 
-	atomic_inc(&smmu_domain->nr_ats_masters);
 	/*
 	 * ATC invalidation of PASID 0 causes the entire ATC to be flushed.
 	 */
@@ -2479,22 +2475,6 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master,
 		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
 }
 
-static void arm_smmu_disable_ats(struct arm_smmu_master *master,
-				 struct arm_smmu_domain *smmu_domain)
-{
-	if (!master->ats_enabled)
-		return;
-
-	pci_disable_ats(to_pci_dev(master->dev));
-	/*
-	 * Ensure ATS is disabled at the endpoint before we issue the
-	 * ATC invalidation via the SMMU.
-	 */
-	wmb();
-	arm_smmu_atc_inv_master(master);
-	atomic_dec(&smmu_domain->nr_ats_masters);
-}
-
 static int arm_smmu_enable_pasid(struct arm_smmu_master *master)
 {
 	int ret;
@@ -2558,39 +2538,147 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
 	return NULL;
 }
 
-static void arm_smmu_detach_dev(struct arm_smmu_master *master)
+/*
+ * If the domain uses the smmu_domain->devices list return the arm_smmu_domain
+ * structure, otherwise NULL. These domains track attached devices so they can
+ * issue invalidations.
+ */
+static struct arm_smmu_domain *
+to_smmu_domain_devices(struct iommu_domain *domain)
 {
-	struct iommu_domain *domain = iommu_get_domain_for_dev(master->dev);
+	/* The domain can be NULL only when processing the first attach */
+	if (!domain)
+		return NULL;
+	if (domain->type & __IOMMU_DOMAIN_PAGING)
+		return to_smmu_domain(domain);
+	return NULL;
+}
+
+static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
+					  struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain_devices(domain);
 	struct arm_smmu_master_domain *master_domain;
-	struct arm_smmu_domain *smmu_domain;
 	unsigned long flags;
 
-	if (!domain || !(domain->type & __IOMMU_DOMAIN_PAGING))
+	if (!smmu_domain)
 		return;
 
-	smmu_domain = to_smmu_domain(domain);
-	arm_smmu_disable_ats(master, smmu_domain);
-
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	master_domain = arm_smmu_find_master_domain(smmu_domain, master);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
+		if (master->ats_enabled)
+			atomic_dec(&smmu_domain->nr_ats_masters);
 	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+}
 
-	master->ats_enabled = false;
+struct attach_state {
+	bool want_ats;
+	bool disable_ats;
+	struct iommu_domain *old_domain;
+};
+
+/*
+ * Prepare to attach a domain to a master. If disable_ats is not set this will
+ * turn on ATS if supported. smmu_domain can be NULL if the domain being
+ * attached does not have a page table and does not require invalidation
+ * tracking.
+ */
+static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
+				   struct iommu_domain *domain,
+				   struct attach_state *state)
+{
+	struct arm_smmu_domain *smmu_domain =
+		to_smmu_domain_devices(domain);
+	struct arm_smmu_master_domain *master_domain;
+	unsigned long flags;
+
+	/*
+	 * arm_smmu_share_asid() must not see two domains pointing to the same
+	 * arm_smmu_master_domain contents otherwise it could randomly write one
+	 * or the other to the CD.
+	 */
+	lockdep_assert_held(&arm_smmu_asid_lock);
+
+	state->want_ats = !state->disable_ats && arm_smmu_ats_supported(master);
+
+	if (smmu_domain) {
+		master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
+		if (!master_domain)
+			return -ENOMEM;
+		master_domain->master = master;
+
+		/*
+		 * During prepare we want the current smmu_domain and new
+		 * smmu_domain to be in the devices list before we change any
+		 * HW. This ensures that both domains will send ATS
+		 * invalidations to the master until we are done.
+		 *
+		 * It is tempting to make this list only track masters that are
+		 * using ATS, but arm_smmu_share_asid() also uses this to change
+		 * the ASID of a domain, unrelated to ATS.
+		 *
+		 * Notice if we are re-attaching the same domain then the list
+		 * will have two identical entries and commit will remove only
+		 * one of them.
+		 */
+		spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+		if (state->want_ats)
+			atomic_inc(&smmu_domain->nr_ats_masters);
+		list_add(&master_domain->devices_elm, &smmu_domain->devices);
+		spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	}
+
+	if (!state->want_ats && master->ats_enabled) {
+		pci_disable_ats(to_pci_dev(master->dev));
+		/*
+		 * This is probably overkill, but the config write for disabling
+		 * ATS should complete before the STE is configured to generate
+		 * UR to avoid AER noise.
+		 */
+		wmb();
+	}
+	return 0;
+}
+
+/*
+ * Commit is done after the STE/CD are configured with the EATS setting. It
+ * completes synchronizing the PCI device's ATC and finishes manipulating the
+ * smmu_domain->devices list.
+ */
+static void arm_smmu_attach_commit(struct arm_smmu_master *master,
+				   struct attach_state *state)
+{
+	lockdep_assert_held(&arm_smmu_asid_lock);
+
+	if (state->want_ats && !master->ats_enabled) {
+		arm_smmu_enable_ats(master);
+	} else if (master->ats_enabled) {
+		/*
+		 * The translation has changed, flush the ATC. At this point the
+		 * SMMU is translating for the new domain and both the old&new
+		 * domain will issue invalidations.
+		 */
+		arm_smmu_atc_inv_master(master);
+	}
+	master->ats_enabled = state->want_ats;
+
+	arm_smmu_remove_master_domain(master, state->old_domain);
 }
 
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 {
 	int ret = 0;
-	unsigned long flags;
 	struct arm_smmu_ste target;
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	struct arm_smmu_master_domain *master_domain;
+	struct attach_state state = {
+		.old_domain = iommu_get_domain_for_dev(dev),
+	};
 	struct arm_smmu_master *master;
 	struct arm_smmu_cd *cdptr;
 
@@ -2627,11 +2715,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			return -ENOMEM;
 	}
 
-	master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
-	if (!master_domain)
-		return -ENOMEM;
-	master_domain->master = master;
-
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
 	 * of either the old or new domain while we are working on it.
@@ -2640,13 +2723,11 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	 */
 	mutex_lock(&arm_smmu_asid_lock);
 
-	arm_smmu_detach_dev(master);
-
-	master->ats_enabled = arm_smmu_ats_supported(master);
-
-	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_add(&master_domain->devices_elm, &smmu_domain->devices);
-	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	ret = arm_smmu_attach_prepare(master, domain, &state);
+	if (ret) {
+		mutex_unlock(&arm_smmu_asid_lock);
+		return ret;
+	}
 
 	switch (smmu_domain->stage) {
 	case ARM_SMMU_DOMAIN_S1: {
@@ -2655,18 +2736,19 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
 		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
 					&target_cd);
-		arm_smmu_make_cdtable_ste(&target, master);
+		arm_smmu_make_cdtable_ste(&target, master, state.want_ats);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
 	}
 	case ARM_SMMU_DOMAIN_S2:
-		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
+		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain,
+					    state.want_ats);
 		arm_smmu_install_ste_for_dev(master, &target);
 		arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 		break;
 	}
 
-	arm_smmu_enable_ats(master, smmu_domain);
+	arm_smmu_attach_commit(master, &state);
 	mutex_unlock(&arm_smmu_asid_lock);
 	return 0;
 }
@@ -2695,10 +2777,13 @@ void arm_smmu_remove_pasid(struct arm_smmu_master *master,
 	arm_smmu_clear_cd(master, pasid);
 }
 
-static int arm_smmu_attach_dev_ste(struct device *dev,
-				   struct arm_smmu_ste *ste)
+static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
+				   struct device *dev, struct arm_smmu_ste *ste)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct attach_state state = {
+		.old_domain = iommu_get_domain_for_dev(dev),
+	};
 
 	if (arm_smmu_master_sva_enabled(master))
 		return -EBUSY;
@@ -2716,9 +2801,10 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 	 * the stream (STE.EATS == 0b00), causing F_BAD_ATS_TREQ and
 	 * F_TRANSL_FORBIDDEN events (IHI0070Ea 5.2 Stream Table Entry).
 	 */
-	arm_smmu_detach_dev(master);
-
+	state.disable_ats = true;
+	arm_smmu_attach_prepare(master, domain, &state);
 	arm_smmu_install_ste_for_dev(master, ste);
+	arm_smmu_attach_commit(master, &state);
 	mutex_unlock(&arm_smmu_asid_lock);
 
 	/*
@@ -2736,7 +2822,7 @@ static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
 	struct arm_smmu_ste ste;
 
 	arm_smmu_make_bypass_ste(&ste);
-	return arm_smmu_attach_dev_ste(dev, &ste);
+	return arm_smmu_attach_dev_ste(domain, dev, &ste);
 }
 
 static const struct iommu_domain_ops arm_smmu_identity_ops = {
@@ -2754,7 +2840,7 @@ static int arm_smmu_attach_dev_blocked(struct iommu_domain *domain,
 	struct arm_smmu_ste ste;
 
 	arm_smmu_make_abort_ste(&ste);
-	return arm_smmu_attach_dev_ste(dev, &ste);
+	return arm_smmu_attach_dev_ste(domain, dev, &ste);
 }
 
 static const struct iommu_domain_ops arm_smmu_blocked_ops = {
-- 
2.43.2


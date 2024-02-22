Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA856FC7;
	Thu, 22 Feb 2024 00:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708561631; cv=fail; b=ShP3XFNt5Zs0r/jF+DTbeeU8uGAC+1xxTIQJxnH29uNpFeRun/polFpmnSfhbw5vDy10+q5P0r7zt/7uzadMXVVnw4BSJvtUhkFyigDi78pvnLg0aSscEg56nGG6lXc+jOPQvVHdobuCAjNmUKUBSeniCf5C7cFqCqVSDurKg98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708561631; c=relaxed/simple;
	bh=/E60tG2AJqO4Ttn/VkC7w840SfaLblLSYpWCsDG/Lww=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=RsHWE7MEGjnzmVaqsXYH5fLvLkf+DsgMAP9u+NqQnM+JrGQgSOh/bR40LqU2FNtWUHM0uF5BEmqL4hY7Z/RxA3zFu5unKFEJwB3IYpDn5TmxkLjQ/emg4ae3PSdNs46DvP2qdqIKbUxSXCfBNuTpJlwR77SGHw3NL/iItz8Tky0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e8lZxP9m; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e8lZxP9m"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ri23R4BNEwfs7LGsWIadpXXwSqm858BZyaDtuBpwxJp8xQ05FW33IOPv96k9YC0BGmTPAkIEG3ESwR7xu/Rqy0GDWhBYGiIF4Phx9WJYH3/fcRuhTHGKBGyRczLucDgM/QtoazNaIg4w+UFDmCBt/V+TS95Cv9iQZCLAAAAzLgn6Xs45Epw2CKAo/dKsb6Za/EEjXOCpNeIv9YEz1QVPQMK6BDSwSDtonLbt10r6qkr4xZnL+pYplcXTA4biAznwRvxGDY4b5plzqm1jS7CCPZ5lkPBYl6VfHVxIdPIltIVeDYMu0HYtfHKLemMQUJk3GQlPcDa7Gy6SECVI2g7msg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bbQcHX6iFYOlEUDoNpe8kABzMooWdIQwmdC+qvYeTqk=;
 b=JY4ihEDvCYhqjN3oPfro1kXzsCu/XLgHySbT8hZLAOeN9OX8UUeEyrgMWthaP3DUKuQmF3xKinatkEhsXETnUA7WQSeD63De8Sy55s3iQMSm+cNpT83feWWhifyUWr7V+Vvuw+HPgYoR58Wm7eiJJML3mdwc0c7yZaBzSJdaxKpe9Vnc5jL9adFE/3jeNR5XiUSFvlm9u89PEBRSqp6L4R7wYXQbFeV8488o8unVkX7WFd3QJSAfN6YLsy3N9eo2dHTfRePvlSn66pv205RWGujsjJavzKRTFaSxuYml+/xx6OZ5HAAkJu+vCMrHjJR9V3X8hlMBAXWw21Gc/qBWrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbQcHX6iFYOlEUDoNpe8kABzMooWdIQwmdC+qvYeTqk=;
 b=e8lZxP9mb47uAkUwICZMG11y/2uqbdF7UEk5/HxQiwZ1PporJMRyrt4SI6/MaRr1gXEmvjlVsMUiw44DBLZ4fofPBwzhcTwYo/Av+cAAaHZLsVf2C3siU81mPxPM89FsbmoVlIVYbkM3fU5pN0thVkz8Wwg9VIO36W1tqYAKREYrrOgWWK8Nzg16HTBtcd9+/yaMfMrY/Lo1G8Sj0/3CIVaUUQD0iFPZKzUJhqJ9oH7EtAPfxD3QEaEYdh5z454O2zX6l61ZSTLAhEG7rAf4kygdl0UkgEBejdjTXYwO9RY4AWutjVnpLOH/ikIdOICIaXZBHBkAx3O0ekUJeg9Hxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6349.namprd12.prod.outlook.com (2603:10b6:8:a4::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.32; Thu, 22 Feb 2024 00:27:03 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.023; Thu, 22 Feb 2024
 00:27:03 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>
Subject: [PATCH v3] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as spinlock
Date: Wed, 21 Feb 2024 20:27:02 -0400
Message-ID: <0-v3-11978fc67151+112-smmu_cd_atomic_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0066.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6349:EE_
X-MS-Office365-Filtering-Correlation-Id: 64aaef0d-d699-45f7-748b-08dc333cfddf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	w2F3ulMkoXH6P16jt1vZFWJVt90HjNLkym4nxuDxYhnt7lNiPYKKgdf7zZYm9xz2McxM3z3l6SpIlOjLL08zw5hGw+351YAkT5orFUBvXU9odOKeWvogua2LS2l+2TJ3A1Y5Yr19rqHMoP+AFFS3zxwKXcfDo3K9vCLZeTLX6dw0fBSTSRMZmQPfMp4JpBv9sMk09nWxvQDnYpyb6XpObw40tZFD1HkmkcerZxkygApraypR8fbp30L1/KOTbs+PeNOoiC/4qRVMxPsOQnRv102yNhAba72W4cReGskIbmTxOz/A2wY9ZSHsos8IhXhLSiAbCdxBMPl0mtupEbcq+QTVPjIvclzk2MHzDZ7V3bGNhcNYQ/AAp1G+YPTXQEffM9fR3Y92MIRig0LCMmGOnfwG1JQgHARWHqyWrLU3/B32SJHpATFOt9OCnZgCv7vh+2mnayR+i8XOPZaKFVMwxf+HOvGeQvmJDLv87c782hpSzQBwglGRVXyHhsIzBmhm9x33uhx3aw0KVmmOVKUEriQ2Qh01B/aIEYWFDpuaGx39dewE/hyBNpVsiUiVLk24+jS9+0UP0F1StF4OWLfOrQCFwLtKLyQv2WKknFdTaAY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(230273577357003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y+Q/C1f3HJOG6sB9gPj35TUA8XgPeOxukWJicml5EqT8Ad+yVxIUh5YDy5LQ?=
 =?us-ascii?Q?bb8E9bIAlZpGme72ddGNzsFie4+dgMldlWasA9KkT6Y9DsrJ5y0xMsTay6ky?=
 =?us-ascii?Q?KuHvwL70cIw8rUuGlOBRMF0N3kq9c+qR4rlh7jBhGqV1BBITeqX9y71iMg4+?=
 =?us-ascii?Q?Bt9SUlNxFpSOJm/gvdNTRtcfTZ0ouChDuaQnPkV6dmxMUWfCcWETJGxSkAoU?=
 =?us-ascii?Q?quECw4RaoGTqNNT79UueBoR2zE6bA646hXumyrkx4l6LpnLw0E7t00zDOMi0?=
 =?us-ascii?Q?oEsJxMPdZ2GTDxkbtJsnpaPeqA/qB87BqnqyGdRD8EXC/JO23muwuKlC2S0l?=
 =?us-ascii?Q?De5VrdMYauWIZzeMSjDE+MWJNty0QZkocPxD+oJJXMreH3/5XnDv8ArBenYg?=
 =?us-ascii?Q?n9qtSU4wiaaUWIWrIF+SK01Xqgwz63NFhYk4lLqeVoyq8ICl/tvT+Zr+hSTN?=
 =?us-ascii?Q?NJtwpbka4MDROVXT284CFkVNsmzazJ9Vz/pINrd89cDHRvstgyIIUvbJf5Qx?=
 =?us-ascii?Q?oH+ccX2st4nQdBVsW9omdIDFkJXjd1mxCgax2MTaFKYfBlVLcw0aJBldrQjd?=
 =?us-ascii?Q?49UNKwuXCN+Qtv8n2L8dDtVvmE2qh7bpNCZqOlbW3z9MAirOpvCac20gVnxe?=
 =?us-ascii?Q?Oh60SF6FcytHV2j3grDdkgOeL4vc8T2+BXe+lSc1sXeVYP5FcZdDVfYhGHNx?=
 =?us-ascii?Q?VyYU+LYtT6+DbWWtgnAISHOesmqxff8WN0FbbHfoLkN1c2HVqvLvmJSHdRmi?=
 =?us-ascii?Q?LsAiY+nSzMhuF+yTdIkIQ6vZHm/cpaff69Cp6AwphoEQhpSBQOPowinc08o/?=
 =?us-ascii?Q?h5hbYk/ozd0ExcYFRRyEED8PTvG/04HuynDtepcg9rHAyiOl3PeWe6vA4Hee?=
 =?us-ascii?Q?M3eX8twG4ztA+yUC0bFQ/wrhh532I7WeNQbL29tKMSoii/G4D/pzsM94Eeld?=
 =?us-ascii?Q?+1l05n/cdhvN+w8GaPMjFn5MinC+aVyzKIHNkNlOchzJFZORB3I5JhxLjkTJ?=
 =?us-ascii?Q?Z/HQTIRFdS4njb4wgLOYw4HbfxZ6vqx3bq8GWvS0wUabv5BIkiSsVvVMm39W?=
 =?us-ascii?Q?idf5j2vA6Pl2zvbXGm9+kHkwe61V6R1gzC4XJY2zgLSynOy++TlVLJl9O8r3?=
 =?us-ascii?Q?RJVJbsgMBVvkX7N3E7ye+CsE3zBWIYmcpj2akjvJrh8AoxSOJjalv9mnyOIq?=
 =?us-ascii?Q?Ym9fLNireMGhqncMEf24wHZpNMQtKToFf+sb7bgCtAOM440c8SsyGhxGT+aV?=
 =?us-ascii?Q?ptRIBqQmBxnVgIcnbSsfFh59yvnv/9mrwjzBIzuA8pH0N8cmvQpntlvngxNU?=
 =?us-ascii?Q?kGqj+6u4gn/Qq0vPVpt9pricrL71q7Of4OsxN6sJlkcC6bdclLk/dE55TFNt?=
 =?us-ascii?Q?kIszAJGBQ3OmWTRU5aRbFOAHbcLBEBc2vdwkhRhZJI31byg5XoU8ow8bwaMD?=
 =?us-ascii?Q?OMI0TQej2d1JB8gAz1Z/Ytahiq7n+pbpZ0YYD3xk9gJzNa4h2TCe5Q/NTl77?=
 =?us-ascii?Q?7cLKql4bqYa2PD4yMSFFi+R12NS1J1G9UABIV3aGdkCRYRalB7BWaYTzZFA6?=
 =?us-ascii?Q?jaYnDa+XFX7bwrebTSIemg972jT/xsGcPZYrNAP4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64aaef0d-d699-45f7-748b-08dc333cfddf
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2024 00:27:03.1153
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4JVGzB4ubGHrvao2Zy75XTKeh2T886RkUDCSp3RxwRTgRgDgUNdQC6ZMHtzJI+aa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6349

If the SMMU is configured to use a two level CD table then
arm_smmu_write_ctx_desc() allocates a CD table leaf internally using
GFP_KERNEL. Due to recent changes this is being done under a spinlock to
iterate over the device list - thus it will trigger a sleeping while
atomic warning:

  arm_smmu_sva_set_dev_pasid()
    mutex_lock(&sva_lock);
    __arm_smmu_sva_bind()
     arm_smmu_mmu_notifier_get()
      spin_lock_irqsave()
      arm_smmu_write_ctx_desc()
	arm_smmu_get_cd_ptr()
         arm_smmu_alloc_cd_leaf_table()
	  dmam_alloc_coherent(GFP_KERNEL)

This is a 64K high order allocation and really should not be done
atomically.

At the moment the rework of the SVA to follow the new API is half
finished. Recently the CD table memory was moved from the domain to the
master, however we have the confusing situation where the SVA code is
wrongly using the RID domains device's list to track which CD tables the
SVA is installed in.

Remove the logic to replicate the CD across all the domain's masters
during attach. We know which master and which CD table the PASID should be
installed in.

Right now SVA only works when dma-iommu.c is in control of the RID
translation, which means we have a single iommu_domain shared across the
entire group and that iommu_domain is not shared outside the group.

Critically this means that the iommu_group->devices list and RID's
smmu_domain->devices list describe the same set of masters.

For PCI cases the core code also insists on singleton groups so there is
only one entry in the smmu_domain->devices list that is equal to the
master being passed in to arm_smmu_sva_set_dev_pasid().

Only non-PCI cases may have multi-device groups. However, the core code
will repeat the calls to arm_smmu_sva_set_dev_pasid() across the entire
iommu_group->devices list.

Instead of having arm_smmu_mmu_notifier_get() indirectly loop over all the
devices in the group via the RID's smmu_domain, rely on
__arm_smmu_sva_bind() to be called for each device in the group and
install the repeated CD entry that way.

This avoids taking the spinlock to access the devices list and permits the
arm_smmu_write_ctx_desc() to use a sleeping allocation. Leave the
arm_smmu_mm_release() as a confusing situation, this requires tracking
attached masters inside the SVA domain.

Removing the loop allows arm_smmu_write_ctx_desc() to be called outside
the spinlock and thus is safe to use GFP_KERNEL.

Move the clearing of the CD into arm_smmu_sva_remove_dev_pasid() so that
arm_smmu_mmu_notifier_get/put() remain paired functions.

Fixes: 24503148c545 ("iommu/arm-smmu-v3: Refactor write_ctx_desc")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/4e25d161-0cf8-4050-9aa3-dfa21cd63e56@moroto.mountain/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 38 ++++++-------------
 1 file changed, 12 insertions(+), 26 deletions(-)

I suggest taking these two patches as well which will further help this code:

https://lore.kernel.org/linux-iommu/12-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com/
https://lore.kernel.org/linux-iommu/2-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com/

Michael should check it, and Nicolin or Shameer should do a quick sanity check
on their SVA HW.

v3:
  - Pull arm_smmu_write_ctx_desc() up into __arm_smmu_sva_bind() and
    arm_smmu_sva_remove_dev_pasid() to avoid the early exit in
    arm_smmu_mmu_notifier_get()
v2: https://lore.kernel.org/all/0-v2-7988c2682634+261-smmu_cd_atomic_jgg@nvidia.com/

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 05722121f00e70..4a27fbdb2d8446 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -292,10 +292,8 @@ arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
 			  struct mm_struct *mm)
 {
 	int ret;
-	unsigned long flags;
 	struct arm_smmu_ctx_desc *cd;
 	struct arm_smmu_mmu_notifier *smmu_mn;
-	struct arm_smmu_master *master;
 
 	list_for_each_entry(smmu_mn, &smmu_domain->mmu_notifiers, list) {
 		if (smmu_mn->mn.mm == mm) {
@@ -325,28 +323,9 @@ arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
 		goto err_free_cd;
 	}
 
-	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
-		ret = arm_smmu_write_ctx_desc(master, mm_get_enqcmd_pasid(mm),
-					      cd);
-		if (ret) {
-			list_for_each_entry_from_reverse(
-				master, &smmu_domain->devices, domain_head)
-				arm_smmu_write_ctx_desc(
-					master, mm_get_enqcmd_pasid(mm), NULL);
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
-	if (ret)
-		goto err_put_notifier;
-
 	list_add(&smmu_mn->list, &smmu_domain->mmu_notifiers);
 	return smmu_mn;
 
-err_put_notifier:
-	/* Frees smmu_mn */
-	mmu_notifier_put(&smmu_mn->mn);
 err_free_cd:
 	arm_smmu_free_shared_cd(cd);
 	return ERR_PTR(ret);
@@ -363,9 +342,6 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
 
 	list_del(&smmu_mn->list);
 
-	arm_smmu_update_ctx_desc_devices(smmu_domain, mm_get_enqcmd_pasid(mm),
-					 NULL);
-
 	/*
 	 * If we went through clear(), we've already invalidated, and no
 	 * new TLB entry can have been formed.
@@ -381,7 +357,8 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
 	arm_smmu_free_shared_cd(cd);
 }
 
-static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm)
+static int __arm_smmu_sva_bind(struct device *dev, ioasid_t pasid,
+			       struct mm_struct *mm)
 {
 	int ret;
 	struct arm_smmu_bond *bond;
@@ -404,9 +381,15 @@ static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm)
 		goto err_free_bond;
 	}
 
+	ret = arm_smmu_write_ctx_desc(master, pasid, bond->smmu_mn->cd);
+	if (ret)
+		goto err_put_notifier;
+
 	list_add(&bond->list, &master->bonds);
 	return 0;
 
+err_put_notifier:
+	arm_smmu_mmu_notifier_put(bond->smmu_mn);
 err_free_bond:
 	kfree(bond);
 	return ret;
@@ -568,6 +551,9 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 
 	mutex_lock(&sva_lock);
+
+	arm_smmu_write_ctx_desc(master, id, NULL);
+
 	list_for_each_entry(t, &master->bonds, list) {
 		if (t->mm == mm) {
 			bond = t;
@@ -590,7 +576,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	struct mm_struct *mm = domain->mm;
 
 	mutex_lock(&sva_lock);
-	ret = __arm_smmu_sva_bind(dev, mm);
+	ret = __arm_smmu_sva_bind(dev, id, mm);
 	mutex_unlock(&sva_lock);
 
 	return ret;

base-commit: c76c50cd425e574df5a071cd7e1805d0764aabff
-- 
2.43.2


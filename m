Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AB0132C3F;
	Thu, 15 Feb 2024 14:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708009023; cv=fail; b=qtiDMnt1xmzXjUTZC9kNapMfGMUyLTSiJjPxXbQprAa7VP84kPLZRWZz1h3TPeNQXlSnClaA8OBQi12VXDAAL1As9yuIeYYexHenxhsr5oo4/03VRQuYoBe+Khao78X7NvZmya+8R6Zxua3opr0Q66RZkMr1XYQLlspG2uzqpEo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708009023; c=relaxed/simple;
	bh=YQEAtAP8Lj3NGhKA1XZxRczwhTMvwTyraaBVQI0wX8E=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=aIOu3nuQV+bgtSJh4n9ogHu13rvV5H56xqnOh7Pcht9kTZc9MB0EkZiHajCBsCU8fUaw0qqV930yko1Sh8pkipejMgX84buLd3Oe5jGoZ7nCXe/5IYfKsZ4H/3Iw48p5Di/bmIv3SZL0IEtAhBRuSQuhrhbKMGfB5Uw4VvayaZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bM0uJajK; arc=fail smtp.client-ip=40.107.94.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bM0uJajK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eE0IAB4yiDqJ+MWpNXfeYvdrsgq+CvkGxfTNcyc/nAGjZ2BLeTu0Tw7TaIC1+ob9fmFYiZxkgfjrcyGuVcW+iz8ABZHUj0hIV+KCRhjoEH1pWEx6flVQcNJv34EfNlJ2FShIAloDr9PUT7nHFtPoy8A/QBKVE57+d3F9KJHb+D4HQeIwq2IiA6O70gPp4lP/w1kO/ELl85qT9nEq/Z3qZjEQyZ7gBEbsxv8szC4auS231j8+RFVx6kPwjj76MNjotz+sJ9IaTIS96ZwTsNx5NV97R546TbTyvpJB903ZQKmAtSCYpbTJcBvmX1A4qfXGysAUx7kl+Ng+4nwMEJkeqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e4liXxokE8wPpxZVEJrhXinIkHh63uC9OtKLFCyCz2Y=;
 b=ikcAcbAcuWMIREzgKGpqTkAxWLZdj8bjsAvk6Q86hElwMAbRSRsFZKzdMpgbQKRsRMLqcDaOz2tDea5I2MYhQOxc7kS0TM907EaIr2uHrQ+xxGzWb+kWRL11YqKymTKz/FZfiqSBModtv/JnAHBjLQkIAadnME8w4xIElR2qsp9wgmjJ1znI4zs3TuEflZNLFuq+kbgN98/ydTtPDgJsQe83yBacTUJ+KOhaXV6afe2RtUKOoBM0UCCpdMbnoqTgonG/xQvwdgrbku9MX/35gg3jASdDzjJtO1mo/4/2xFAOggU8L/b5UTf32jxGQlet5DqMNeDleS4QgKRyd+Bq+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e4liXxokE8wPpxZVEJrhXinIkHh63uC9OtKLFCyCz2Y=;
 b=bM0uJajKg7wJWaky71TW9vBFEwZ2wWFwvEbVfU9mhgGd9CbeIC2S1QUQ3treUpg8uF/k5SaGLmdwTbMrlJo9HtZfqUAEWSc8gZun2gDtkUzzFj7pnBYj+9J1dP2YTIYe2mZoZ3vNiqlYgLLdEkfC7Z20uAxyi295sFuuputNZM+qMAbmibeGKkTLtmH6YREhHGS3UMS/A6Ggoj1GtYjDUG92glEClrxNmaB7qWkQUmKYsVrd9SHTB/TUUX2m4w1isMt/fSLgviNhLOErRG0q1o3OLpndlJ4G5L5nu2ILsGmPyxL6oztksnXvSY8yUZw/fbI/lF1yDK71HEmQ/bI1CA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB7697.namprd12.prod.outlook.com (2603:10b6:208:433::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.25; Thu, 15 Feb
 2024 14:56:58 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.012; Thu, 15 Feb 2024
 14:56:58 +0000
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
Subject: [PATCH rc v2] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as spinlock
Date: Thu, 15 Feb 2024 10:56:57 -0400
Message-ID: <0-v2-7988c2682634+261-smmu_cd_atomic_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0027.namprd15.prod.outlook.com
 (2603:10b6:207:17::40) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB7697:EE_
X-MS-Office365-Filtering-Correlation-Id: cbafbaf1-3f1a-4a5a-0bc1-08dc2e365ba4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zoCRWCHbu87mX1pVs1Nch/matp/KePMrn5Euapu2K7hsaudhgdW/nI4rgBalO6VEOoe0RR4oDsxBceqoiFndM/dUtlqbEr1T8KP4TjMIsilTuFn5Mvm6L3XDbqP9wxZpbm9Bgk60jrqolFxMxcSFbSfZVW2Oca0h44tH+HOls+YNiVTwcJaY0a97iLsJgn83lNNb1Jx2JxXO1q8AJteGgw110S4QUxB13texss0Pnlf9Agl73X/m1J54Yp4A2eGl00vSLfNui2QbvqjCt24aJ/C/UE9zPsu1zR9AEGaUzgFKLBM8D3Z2QRZXOGRCSUIINSbopQVou1qeTiMGiHHRtM61+hxPtGK6I+9vosHOlIQ9qWUl7FjLE5ottZEimlQIrszg4xfmyKVjMbu1ikBbNv/aCwMaRl3tIJ/Z6c/ljLP//6dSKDjfE0BXwpc4sJdBBpn/iT/m94jcYEMdhnQUM5EYdGFpKH+nNAOciyEomoKU3NQRq/5LD27gjt3QCMwcDXu9uqhCJ22SyPHL9UulQ+rLWUOADQpa7nWQ9qdGbDkoJvqI+4ZRYmC0Km++dslVc+55enVLLqRtiVuVNadxctkd8RUp7kyFXuKDVYv6ork=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(39860400002)(396003)(366004)(346002)(230273577357003)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(66556008)(36756003)(5660300002)(2616005)(41300700001)(478600001)(8936002)(26005)(66946007)(8676002)(66476007)(4326008)(54906003)(316002)(110136005)(6512007)(6506007)(86362001)(38100700002)(83380400001)(966005)(6486002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KLkassMeevnVZ6o78uz6nM7JDD1MQjR/H7aLBUDhXLmtQlTQpXgzkGNd6LOa?=
 =?us-ascii?Q?khGN+7ZL1zUxyEClaENrtgDPnxXOZ0BmKEs+9ScgzNSv5eIk72bS/6q8bkU9?=
 =?us-ascii?Q?+ke9WQ12gFymY7GaNrIMbxqZ8KBTNSY1tJ/kE/+g69Z2QcwjbDxDkwh03O7G?=
 =?us-ascii?Q?fdkKuwBlsEMM/Ur2U2FQCc+8IafB9z0/kwn87jbbRqOBO3dADyjk5Q7vAqJ5?=
 =?us-ascii?Q?zW60VUgeQ5TgnhWQU8PIS62lnsVfwWH1m4K3hXE6FsVZtBP9GPOSQCpx0Ncu?=
 =?us-ascii?Q?myi26ZkeqVcIOB5CYYhyQOafI0qbPxV7+wdQ6aXa8jGpcIATwWz5vA1IjiMx?=
 =?us-ascii?Q?OydgAUAe6QTuThgGEvq52+JQBnC4WDy/8dobRNSHa4SXKDgslR0tDCt5qdmV?=
 =?us-ascii?Q?Ktyx9j+TLd4VLS9aCgvK4xa/k/YLSlAwdKNR6deondovG+2agPyi0iPP1Csz?=
 =?us-ascii?Q?bOzKPCWkk6idWTqKJ/h4ZC68CHTp7Qlyc6Q9Wydlqe1cmHuzGV4A6JdmRNPK?=
 =?us-ascii?Q?EAwbmoAlqFQK6GH549aOOl+qyBFdpZlBA94o0eIFRla0soHCjzeP6S0KQ3rc?=
 =?us-ascii?Q?Goe1H5N1pZ5CYn23tC5P4QI1v9rll+NCToeORnpfVZTpmEHFhr4fuIitDrE4?=
 =?us-ascii?Q?Gddx21Eb+BH6fpehw01ya6OGECvIYbuh2+uwhTsry9fwEo/TbOPlUyGNmkcY?=
 =?us-ascii?Q?tv6GINNBr9g6KeE+rBZ0z1jbYeW7S0y884Iedsr9RR/qb2Be4ui2mkPg8LH4?=
 =?us-ascii?Q?+3LJ7ggtB238j3kQeRCkrfWjj+tY4V2Ewqko8WagciSp7TsZ91IkFc/EQIdl?=
 =?us-ascii?Q?iqBk20HFYqfmmQcsSOw409OdmI9DHHgSSJoWAtlptu4RzjjTBrc9vt2dbsbo?=
 =?us-ascii?Q?BpllqlMyrfuF1o5tgFp+QFKz54/gEI+29bNHxPVcDjNUvGCAafDB1opI+nvI?=
 =?us-ascii?Q?J13kZVDqUzT79d3VJIo+KLz6mrWW3m+2nOvzrIrHH0a+2PEbe4NLdTJs1UPX?=
 =?us-ascii?Q?uHZKdirUqwSvFEkm6sS8c20YL99hX33FfLSAJy0J80r0RtnP322cG33B82PB?=
 =?us-ascii?Q?PWVoJ+MM7rpIDOmHDMh97G7UeaHWeIohlLy0hl4fnmrtFJtR592x4AFKWr/l?=
 =?us-ascii?Q?VTqfDx1o3XzSdHJvTerR351lYNPVtvJqvXt7c2jA12g4q6JvwYKjbGSO+o2Z?=
 =?us-ascii?Q?dWdj5egKxtSklQfb7KOXxwF0S5N54BwnU8iuq/AuYGJtTXZJWUyjahuBMGve?=
 =?us-ascii?Q?6yHAZBoQuJmn/oJdlQb6Gvo+ie53yQTaqaU7KYxrA5Xq8j7D6aKi53re8GsA?=
 =?us-ascii?Q?STXKt1ALF8h9eDIVjihM0xyJ2nIVMI5FnVUfMb4T5Uyg2Gu8FKyhe6AbrXqp?=
 =?us-ascii?Q?D786FN3TbPnmggz7oR4UoTVB0HDExsnWIWA1E7GqX0hkivXywok6u9+eVblR?=
 =?us-ascii?Q?Yoom/JNL4n54bPVDY/+rgyF4g5LTewtvo8PSFZkkuxkF9a6bDa7KbmHmoO8P?=
 =?us-ascii?Q?68wAcdgoE8hIReUcLsDDB2mAyEtr2qSR+L5m9Iwh0yH5jNomyQws2+3q4oNP?=
 =?us-ascii?Q?maiRT4Xh3B3gWSIgRQnkEYqvKtWiHGBMCDhKXUi7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbafbaf1-3f1a-4a5a-0bc1-08dc2e365ba4
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 14:56:58.1704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /1flXB6LTaQT9gOP4frW7vG1TwAlY465RRb1vVFWpkVb5bm2VeZPbs4OtImdkspO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7697

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

At the moment SVA is only invoked when dma-iommu.c is in control of the
RID translation, which means we have a single iommu_domain shared across
the entire group and that iommu_domain is not shared outside the group.

For PCI cases the core code also insists on singleton groups so there is
only ever one entry in the smmu_domain->domains list that is equal to the
master being passed in to arm_smmu_sva_set_dev_pasid().

Only non-PCI cases may have multi-device groups. However, the core code it
self will replicate the calls to arm_smmu_sva_set_dev_pasid() across the
entire group so we will still correctly install the CD into each group
members master.

Thus the loop here is fully redundant and can be removed.

Removing the loop allows arm_smmu_write_ctx_desc() to be called outside
the spinlock and thus is safe to use GFP_KERNEL.

Fixes: 24503148c545 ("iommu/arm-smmu-v3: Refactor write_ctx_desc")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/4e25d161-0cf8-4050-9aa3-dfa21cd63e56@moroto.mountain/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 29 +++++--------------
 1 file changed, 8 insertions(+), 21 deletions(-)

v2 - rewritten

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 05722121f00e70..64ec3f0ed8ffe0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -288,14 +288,14 @@ static const struct mmu_notifier_ops arm_smmu_mmu_notifier_ops = {
 
 /* Allocate or get existing MMU notifier for this {domain, mm} pair */
 static struct arm_smmu_mmu_notifier *
-arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
+arm_smmu_mmu_notifier_get(struct arm_smmu_master *master, ioasid_t pasid,
 			  struct mm_struct *mm)
 {
 	int ret;
-	unsigned long flags;
 	struct arm_smmu_ctx_desc *cd;
 	struct arm_smmu_mmu_notifier *smmu_mn;
-	struct arm_smmu_master *master;
+	struct iommu_domain *domain = iommu_get_domain_for_dev(master->dev);
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 
 	list_for_each_entry(smmu_mn, &smmu_domain->mmu_notifiers, list) {
 		if (smmu_mn->mn.mm == mm) {
@@ -325,19 +325,7 @@ arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
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
+	ret = arm_smmu_write_ctx_desc(master, pasid, cd);
 	if (ret)
 		goto err_put_notifier;
 
@@ -381,13 +369,12 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
 	arm_smmu_free_shared_cd(cd);
 }
 
-static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm)
+static int __arm_smmu_sva_bind(struct device *dev, ioasid_t pasid,
+			       struct mm_struct *mm)
 {
 	int ret;
 	struct arm_smmu_bond *bond;
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 
 	if (!master || !master->sva_enabled)
 		return -ENODEV;
@@ -398,7 +385,7 @@ static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm)
 
 	bond->mm = mm;
 
-	bond->smmu_mn = arm_smmu_mmu_notifier_get(smmu_domain, mm);
+	bond->smmu_mn = arm_smmu_mmu_notifier_get(master, pasid, mm);
 	if (IS_ERR(bond->smmu_mn)) {
 		ret = PTR_ERR(bond->smmu_mn);
 		goto err_free_bond;
@@ -590,7 +577,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	struct mm_struct *mm = domain->mm;
 
 	mutex_lock(&sva_lock);
-	ret = __arm_smmu_sva_bind(dev, mm);
+	ret = __arm_smmu_sva_bind(dev, id, mm);
 	mutex_unlock(&sva_lock);
 
 	return ret;

base-commit: c76c50cd425e574df5a071cd7e1805d0764aabff
-- 
2.43.0


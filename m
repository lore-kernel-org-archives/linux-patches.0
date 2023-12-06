Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FE3692AC;
	Wed,  6 Dec 2023 17:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J7R/fNYl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mP622xyar8iIqjSl5eK/ixG0TV4HanHocGHvczz6bRaIVeBuq/BuOda5TTQG1aESYV7NSg5SBZVo5v3oIq8byXGh33If+xpfUpGyv7nDTytvfapIXob78BcSs7DivNoa3uefTnL218wIvBBkjutwp3AWxE1Bq3XaACX4ey4bxpMlX7O9dvD4YCp8Y6by/CdcHZXdFaPO+cE/vGInf+Ab+5ogqMTQlI0twg5/xlmQoQBQsj90l0bc60Zhv7xkfESqr+wMLBEY3snTiRIHvhpP3zPZHu7ClGu7Bml3xhE1piNBqiLPkyX/vF7yk8ilfNPdW0XHnWe9DQ8WzpAG1J8I5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+env2I9YCegAfxYMJeXMpcHiXCL7djy9sLV+jg/N4QA=;
 b=m7c5/0TdoOhjG5GKkUSWpjm/DbsR9wgewVrrC/CVGDsmlxeqTdLcuPwfAabKmyluVFBKJdLZ+fpdW4rqozJIlL+d9YtCsY4CSPwmkqFbFmTNnIDw6lxg43ThWG++1iJixQOsdDPrJnIUBnyPHuRqQDbLjjcFAWwwqi5r6ArCgbN04qBXa50rj9+pfZNI1tgLbZzmONgu1eMbIue/bd13IX9yabSTEB+gKBR31dlIfCF1zoilRdfT4klMSYJ1Lpk1VLaneAHfngK/vJUmXGSJFELCAzvfo+B+C7mfniV63rXkQC0BX5UMEK3C5vNlsCa4eR+fWFB0BAUKSRFjQZGdzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+env2I9YCegAfxYMJeXMpcHiXCL7djy9sLV+jg/N4QA=;
 b=J7R/fNYln5WJ+qtH0F8+2Xv5h1e9pdD/s961rKfsHuE44BdBN3DfSdZZS3Rkk8IgPAl8LX8sPqTlPFOTTM0SVELN+MEHS5P0H5ccMkhmeFMq+NO/T/xB5kAD47VApNW5l3Yzxn/ZAAZjRKaLZj0zktKECPAKl/kpqRzUFI0sjVgt1W7ezrAqgQJUdWEzB3ag8uoDHSBogiMTMzUnJIB8wKuDCN/N1XIS/2d2bbmpd+nbaQPO7l45yKX+QYWCPxAIRK9Kci7QBE8uM8l/h+ev57dxZMkQkTcMKuMPMjgtod//oH2NMJp0GhMWjT4+JnFz8HvCNKbkYHWjl8mOex7etg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8360.namprd12.prod.outlook.com (2603:10b6:208:3d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 17:28:41 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:41 +0000
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
Subject: [PATCH v3 11/27] iommu/arm-smmu-v3: Lift CD programming out of the SVA notifier code
Date: Wed,  6 Dec 2023 13:28:17 -0400
Message-ID: <11-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0016.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8360:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ead0505-0c60-4315-43b2-08dbf680c689
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OkdhI8RzFM2nkGwsomY8Tikw52ssTD5ajYuaUQEI83PXBjayggqSCDHv/hRdMQsDm8gUa0/rrRv7qi/UrJrvIYjI5hxkjOQ4s+7zFu9/9fgQqQxpz7IQaIfa9MwipysyQXR/Th6DzDltEUfi5cW0cctX7/I6lcvm8aP/RuAdSDXFULJWhgoDjdK+tc2L75NDVNd2ywm/5l01AlTPKOLYdFq0XN/Bn/45Y/Shnjyy3UjqtIWpOq4l3nPjJPi/RaqoyohZCEJqthxh9ZcjzFUssG5/5SiY4vc3EyrwFIU4QaSsQuOqZiaoiSxHLr3ysQ1YwVR+Z/DcMR35BpxsYaDmdfxm9w+I/SGloMqM8QZJSiNTk8bK4xT4P2IkUSUeOD8afvm6A9a2No0mf7KfhpwrGzebk0vDOyPjb4SJAQRwXZHSN70Wn8WxVVLmUZe3PaAVqKSrI2Luooa8ObSsiAJRXlqN+CrDpSWPtpFiq8HUKAbiLcZX/hBF/WwhrMZoInMk9vE69FnoR6bZci37+d9H7/EK5qWQ6voxBT8RF0qniYyCdYX3GPbsZ7/K8shTtPi+
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(6666004)(6486002)(478600001)(38100700002)(83380400001)(66946007)(6512007)(2616005)(66476007)(6506007)(8676002)(2906002)(4326008)(54906003)(7416002)(5660300002)(86362001)(36756003)(41300700001)(66556008)(8936002)(316002)(110136005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4OBG8dZRBZoDMV1tTFcm1x1i6bKYIlKlVKGipIiYzjxzHULnCSKb53LbGYUr?=
 =?us-ascii?Q?3YJr+N/lphLeITyBQZVr7QDtr388n5MCz8WHTYCxvC2WyJZFSPVOwhNuBC1g?=
 =?us-ascii?Q?LnMTJ96EtUX8nsB9QuFd/BUJFhW9PbAbyCQYUldRHwqgeJ5pzWeA2jV9BIZL?=
 =?us-ascii?Q?4rEKakMWao7b6oOZ+ZJdRetrSMhsi1kXq/FhYfE0I4OxTrXWmqHHN+zZjN2J?=
 =?us-ascii?Q?tOD1kET06ggdD0RRBHoAfe8XKCE9C1j25tn66RQkscTcJrYw8GQlparBJI/5?=
 =?us-ascii?Q?57r30GAw7O/TlExZeA2N1Ic9VG5FYslLm+1tPWAzJllfAdXJ5pJI8QMqU2oG?=
 =?us-ascii?Q?D8oZxMCyGnmzIzzTTJRSKZak3IBn0RCHqo8ohadilVy4e2BDIAAGNLShTeyT?=
 =?us-ascii?Q?tkpEc9XuFceG2hc5fo7uOmBmS1tl9sRYYGk7TiLks03FqoqgeHvyhqp5lFY4?=
 =?us-ascii?Q?Q6PCGayrijJ3Aif9BIG+w0t9Oc3d3ylVAaCxSpr3Tv7bBJCU/PdkawaKUYap?=
 =?us-ascii?Q?LuulwCJqhavXk0qioiSsZ9aWzG/6W0ouF5ECyzKbKAtL2e+AqWHwAiOVvoXC?=
 =?us-ascii?Q?veHAPI+oz5/eEYkpljhNZj5YqVV3HoSxKzw2rqaqsf9FDTI5DCkqox79JGnk?=
 =?us-ascii?Q?yrjOBWI0dfIUfFVp74LyH5x5dAiE+0qkPu2P0VCIU4WIFAWfMFgG40fLI4Oa?=
 =?us-ascii?Q?Fr40wlaTMEQd7jyDCM4hu9NLq5QRaUE5PhB3NvtTMEXqFRUxhMX3LY7ZzmfC?=
 =?us-ascii?Q?OLdy5uJ5y2bB6djnJgAWfym072cR3gkquWvWhFcx6h9/wLDq+8oSn7viLFEv?=
 =?us-ascii?Q?GnJHDz6Y4vUxWDMzzH7XPRL/1aRGgnQH87obfkPun8Rdof+6k2RP+jagTfCG?=
 =?us-ascii?Q?F5OPVg/jRjOXHfj5NbCRECHZOL7xxTp/KoaRy78gufb5z8nBAgVYi8fTSQEm?=
 =?us-ascii?Q?DyCqKW1b2v57EHrvsgsYAXKcwkY4f2XCcrOQqbZzHl5TxpH8Pn1Ma+ppf/6z?=
 =?us-ascii?Q?2pdkPiwoVcWZVVljkaAaeZDzkTsaM/c2VmA8hfaWHRfQz8KP6ztELLbOmwGF?=
 =?us-ascii?Q?Usqpe8pALL/XyA05lWgxnsQwlyKEWtN0gOgdBHYnKRdk9rBiSM7On6VyagOM?=
 =?us-ascii?Q?6f38elEpb03NqzeVPW1DK5BaDB+Fylj+FXY09ndEnwfhlPY71YWfWv2CF6mT?=
 =?us-ascii?Q?y1sMYNiTsOw2sJ28JXnLNhnPX5yi4zA6UZdoUYNThbJhfyaILRpeCam5fUFC?=
 =?us-ascii?Q?558zfBR9u1o8d6SnacmpBWVGvdDnO+uBN21xzeL4qrjbnDNPJ2KDB96uaP1w?=
 =?us-ascii?Q?LqZStry1X4S5+N1W1VFIpogCjKyCNmtl75ExlM5TsChAHhbM6tutnMQCDfaK?=
 =?us-ascii?Q?5oGM6T8fMkaeMjKXr1tdEr1ljtLezgoNaaq7sCHFt4hPM/0JkvZ6AGtIBxZc?=
 =?us-ascii?Q?j81e313Vm9lmxR+5kk+19SMMTVPXQSIFoML2rZ6c6bS2kuvhNtA/BfP/ogrD?=
 =?us-ascii?Q?1ealuUOPhS3PDn+o6AuASVZVKxP9wZ2ItoCfAwU3LDrB5lBAwaIQAcyQCpqS?=
 =?us-ascii?Q?aGzJdIdX7YR+RG+gEJ4Jj6nHWJK8Xt5NJY2qGFzk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ead0505-0c60-4315-43b2-08dbf680c689
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:35.1802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cgFyGERNe2Btwe/ihyPRvUMgHOQMyevGbgfYIrdHdNzp9p0OldS8Kga9a5kx8JyV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8360

ops->set_dev_pasid()/ops->remove_dev_pasid() should work on a single CD
table entry, the one that was actually passed in to the function. The
current iterating over the master's list is a hold over from the prior
design where the CD table was part of the S1 domain.

Lift this code up and out so that we setup the CD only once for the
correct thing.

The SVA code "works" under a single configuration:
 - The RID domain is a S1 domain
 - The programmed PASID is the mm->pasid
 - Nothing changes while SVA is running (sva_enable)

Invalidation will still iterate over the S1 domain's master list. That
remains OK after this change, we may do harmless extra ATS invalidations
for PASIDs that don't need it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 55 ++++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 24 ++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  6 ++
 3 files changed, 48 insertions(+), 37 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 1f0940b497f3c6..29469073fc53fe 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -339,10 +339,8 @@ arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
 			  struct mm_struct *mm)
 {
 	int ret;
-	unsigned long flags;
 	struct arm_smmu_ctx_desc *cd;
 	struct arm_smmu_mmu_notifier *smmu_mn;
-	struct arm_smmu_master *master;
 
 	list_for_each_entry(smmu_mn, &smmu_domain->mmu_notifiers, list) {
 		if (smmu_mn->mn.mm == mm) {
@@ -372,32 +370,9 @@ arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
 		goto err_free_cd;
 	}
 
-	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
-		struct arm_smmu_cd target;
-		struct arm_smmu_cd *cdptr;
-
-		cdptr = arm_smmu_get_cd_ptr(master, mm->pasid);
-		if (!cdptr) {
-			ret = -ENOMEM;
-			list_for_each_entry_from_reverse(master, &smmu_domain->devices, domain_head)
-				arm_smmu_clear_cd(master, mm->pasid);
-			break;
-		}
-
-		arm_smmu_make_sva_cd(&target, master, mm, cd->asid);
-		arm_smmu_write_cd_entry(master, mm->pasid, cdptr, &target);
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
@@ -408,19 +383,12 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
 	struct mm_struct *mm = smmu_mn->mn.mm;
 	struct arm_smmu_ctx_desc *cd = smmu_mn->cd;
 	struct arm_smmu_domain *smmu_domain = smmu_mn->domain;
-	struct arm_smmu_master *master;
-	unsigned long flags;
 
 	if (!refcount_dec_and_test(&smmu_mn->refs))
 		return;
 
 	list_del(&smmu_mn->list);
 
-	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head)
-		arm_smmu_clear_cd(master, mm->pasid);
-	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
-
 	/*
 	 * If we went through clear(), we've already invalidated, and no
 	 * new TLB entry can have been formed.
@@ -435,7 +403,8 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
 	arm_smmu_free_shared_cd(cd);
 }
 
-static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm)
+static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm,
+			       struct arm_smmu_cd *target)
 {
 	int ret;
 	struct arm_smmu_bond *bond;
@@ -462,6 +431,7 @@ static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm)
 	}
 
 	list_add(&bond->list, &master->bonds);
+	arm_smmu_make_sva_cd(target, master, mm, bond->smmu_mn->cd->asid);
 	return 0;
 
 err_free_bond:
@@ -624,6 +594,8 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 	struct arm_smmu_bond *bond = NULL, *t;
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 
+	arm_smmu_remove_pasid(master, to_smmu_domain(domain), id);
+
 	mutex_lock(&sva_lock);
 	list_for_each_entry(t, &master->bonds, list) {
 		if (t->mm == mm) {
@@ -643,17 +615,26 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 				      struct device *dev, ioasid_t id)
 {
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	int ret = 0;
 	struct mm_struct *mm = domain->mm;
+	struct arm_smmu_cd target;
 
 	if (mm->pasid != id)
 		return -EINVAL;
 
-	mutex_lock(&sva_lock);
-	ret = __arm_smmu_sva_bind(dev, mm);
-	mutex_unlock(&sva_lock);
+	if (!arm_smmu_get_cd_ptr(master, id))
+		return -ENOMEM;
 
-	return ret;
+	mutex_lock(&sva_lock);
+	ret = __arm_smmu_sva_bind(dev, mm, &target);
+	mutex_unlock(&sva_lock);
+	if (ret)
+		return ret;
+
+	/* This cannot fail since we preallocated the cdptr */
+	arm_smmu_set_pasid(master, to_smmu_domain(domain), id, &target);
+	return 0;
 }
 
 static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 824e725f905d71..27c0a468958dc0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2601,6 +2601,30 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	return 0;
 }
 
+int arm_smmu_set_pasid(struct arm_smmu_master *master,
+		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
+		       const struct arm_smmu_cd *cd)
+{
+	struct arm_smmu_domain *sid_smmu_domain =
+		to_smmu_domain_safe(iommu_get_domain_for_dev(master->dev));
+	struct arm_smmu_cd *cdptr;
+
+	if (!sid_smmu_domain || sid_smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
+		return -ENODEV;
+
+	cdptr = arm_smmu_get_cd_ptr(master, pasid);
+	if (!cdptr)
+		return -ENOMEM;
+	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
+	return 0;
+}
+
+void arm_smmu_remove_pasid(struct arm_smmu_master *master,
+			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid)
+{
+	arm_smmu_clear_cd(master, pasid);
+}
+
 static int arm_smmu_attach_dev_ste(struct device *dev,
 				   struct arm_smmu_ste *ste)
 {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 6ed7645938a686..1c756803b7f963 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -770,6 +770,12 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     struct arm_smmu_cd *cdptr,
 			     const struct arm_smmu_cd *target);
 
+int arm_smmu_set_pasid(struct arm_smmu_master *master,
+		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
+		       const struct arm_smmu_cd *cd);
+void arm_smmu_remove_pasid(struct arm_smmu_master *master,
+			   struct arm_smmu_domain *smmu_domain, ioasid_t pasid);
+
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
 void arm_smmu_tlb_inv_range_asid(unsigned long iova, size_t size, int asid,
 				 size_t granule, bool leaf,
-- 
2.43.0


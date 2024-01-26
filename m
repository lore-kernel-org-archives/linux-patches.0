Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CBA208D0;
	Fri, 26 Jan 2024 18:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292946; cv=fail; b=KSVeahv7cIsg31+Kw1sIQIp0S2Yt6V5Nn2W6YMHnTKIQJkTdUS498SJazuz2RmX/oIeXc/Syzve1Z5YgHj/migutdquPKOUKzzYXhue1VNfrP06KkiCBqI2HwxSkNV2MfLtSJ1HHcXtyA1fQeNGR920Hmqq6b7G4sm/YQWDcXXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292946; c=relaxed/simple;
	bh=drO2eYceBr5M3RRO7LKSQ/foeHBNuwnUOrRJ7D+avXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IQWbC/Ob+e84E/nf2DR0S9yRawLHfk+m6wSDd8lXTu79YB7tqE3T0xYPWaV5z8AcnCvqvY5p8Gr4rzo5U8UzGQsp9KbFhUFiPd6zmWJZ6U2gnThZ1bDBviqWdIGzD2mvt/1eOuso6PYlylx1j/29i/llosvoAu+kUfGC1bko3eo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BMLTx61W; arc=fail smtp.client-ip=40.107.243.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BMLTx61W"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSgIxMPApVzFXG2baIOzSPljwHvXwqx7hiKzFQoXiAfHCfCsqG9OMM6oGCu6Kslct/kUFvPxyLvmLSe1cPDrYjBDq2J821iByNWCW5BgmXQIJYugiVr/d2xvy9bn8xjqBPNAfbeQixDyA1o3eet3MDf1wsjrXH8E5p61zwONy+ZXP+VAVx+xULOTOkmYpSjkTqwBP8OGO2ME9CHlyl0oZpL3OJgaXes30eiife0/ZncsPbxWso34tO9z4wZ3bUAWCMPgFWbNFYiVzbPB+DgYrlEolQ/E+zwRg46gaQRyoKLtIDzKpg8FhWVAc1wkFMYFwl9UIrPbVrfNjeyNJIP+Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8LipFwfAeB4jWPyQ7Kt765a/uZfB9pr1mvXt1sw3p40=;
 b=kE718JeWLubJWWei5O0UVgTSYNXYa6rW9IaVOF7bH4R/BhTIAbab494auU/5vUxapYojfro2veEfTGGTi1gDk9E8Z1eEWdubKjS8y/2P7UEgPSfxTdqT/cFfe21Nf6wuvLuOiW4gqFcvDOTEj9/wDoxPkQMKEE52+wY8VexWmypzGKHqyxe0onYdWARBvnywTOSi+egPup8jM7cTQR/x2gaVbTDgvwraiG4jiMMXCO2nLe5+7Bx3IgYqOdYp1JQ1xGtD8mga4suOFIXnr/QqqFQAG9gaMjUAe7B9sET2c4ffKgZ+QZi1fYM0qT/7Iz1sz546FKwaNHsRVZ5zmPm+8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8LipFwfAeB4jWPyQ7Kt765a/uZfB9pr1mvXt1sw3p40=;
 b=BMLTx61WxV/cFe6tjFtlNg99Kj1+8E9ZQZ14tgpufuu3JBc0GUfA6x+y8VBZwTCWbbGI4xNoYPSLLGKQOOpuTa/vyVcoWCKoZAZzL7vCDZUNHbHVVKd6abNjUozdoXigaXUoA3Jiffos2mSJeRyWhRdLmihry2ejSaYSlMOb/MAvId7TegGRYyerHIIZ3dQxTXaMJj0zj79KxOT5XYQWrAFvrMsy3ZGUoZyXCB/6zWAIHPST+LQyXH+/k4qRGWabdyVz3G+uv4dO+qmUK33svaXo4xjr6a5axBxCwqGZxmoAiZKohCs1gQGFiGX5/+3A3/ecYUzG6GlGW/iq8XkmDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8079.namprd12.prod.outlook.com (2603:10b6:208:3fb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 18:15:33 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:33 +0000
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
Subject: [PATCH v4 11/27] iommu/arm-smmu-v3: Lift CD programming out of the SVA notifier code
Date: Fri, 26 Jan 2024 14:15:13 -0400
Message-ID: <11-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0228.namprd04.prod.outlook.com
 (2603:10b6:806:127::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8079:EE_
X-MS-Office365-Filtering-Correlation-Id: 45692d0c-aa96-4cbe-b890-08dc1e9ac840
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QzLHwBpCx/oN7edZ0i4DqOuW/H5o3YDWVeoby2S0c45mtygrvsEwfSFx/AKeSZtTKqNAcMpCvdatnU+Kcnt0Q3KFdmK/ymxJ7r7KPpplTglX+Yggt8ZwIXg5wyHNdfBDH2sJZPoiRRQV7sxM4+Hqopws2matD/eE2ZZIsLQ30EE2L1wtzOQ8KcpaZwj+RfGmw/j2G4rUA+cUye9FTRLsLlcD/hESAbeH+m1o9jTf+5hbabMlUrHws7P/2mS3yCSTSoeBA2BerOGnBoErSGYTUIPwBVXY7pQO4Rtxe+FBmOh4XehxMghnUuBsGJjgA/eRwwAYaVQtMH6NXo9S1mDwrt5VI+Ty9RnVRDYqk2rTmeXi9XtebJG5gnOwRalXmcyjO0UnUZJGVhRzW2vvBBtZOL/eSFMMhI8H69Qffm0AlyiDBpUY/cIehsSmIyuS+dsJx667aakZFUHxk+//9Ahdhk3Ffe8dJuJs4xPQTptsRIOAR6Nw+3Z6ZUMVVhkXCwtClLqlVAbU57RUFOnLZUWVpCAiKCn6LCifR9z/jWcV95JNlsA6cPzrvNo96CsuLyUD
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(39860400002)(376002)(396003)(366004)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(83380400001)(6486002)(6512007)(38100700002)(54906003)(2616005)(5660300002)(8936002)(478600001)(2906002)(8676002)(4326008)(7416002)(110136005)(6666004)(6506007)(316002)(66476007)(66556008)(66946007)(36756003)(26005)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LuL+OB5aLd1RVkd46oqZai3b1++HfIRN52lnfq40Q0xiPEzHlFGnGBxVpn8s?=
 =?us-ascii?Q?YswIU3VjEHmWecYhnaRPOI1z7HcnnKn/P0cr6kpmeuYuSUVYffMrcbD7VvxO?=
 =?us-ascii?Q?yVuRILoL6ySyamxKx7lvBC7uhgXYADt06jnPGUgpkrlusp/J6aWlz7MdiDKh?=
 =?us-ascii?Q?E3mIV9z5Z3QmRGQ6cPZC3mVJ5pRoOEH288T4Z3lIbGNJNsZ0v2OIsSopur0L?=
 =?us-ascii?Q?QfF/7e/diTuDC1huJKaB9dZJdPvctzrYRnyINeBJEtauu/zIPnxwsSwfoLXY?=
 =?us-ascii?Q?k8NbZ4By8UJqVQMwHCAMp27gDIhNeoG/EmS0/QSdE4pixJGHfWFg5zCOdLyX?=
 =?us-ascii?Q?lH5rBiD3o4bnCHpCmD07T/jbDrxvBIlHg28WQQhy+wEvTcqgWuJqgpGBVyhw?=
 =?us-ascii?Q?G1NLbOFkewREIB3u8EFEF60FsUHURN0xFG3WHH5WBSmolX6ZMChsSAs1z1OJ?=
 =?us-ascii?Q?n+nWTQTDpx5V1quMX0kDqE2rYmwcsDol5xHGdqV/MBEQ4BGk76p7X7UMUFyk?=
 =?us-ascii?Q?pzi/DZsjxqxkz6/EooVrZFh9yD3F5Bz8IH7BwAwP2zmT+foAAQiMlFqriEjO?=
 =?us-ascii?Q?ptfRAdjeCulVwdwvyptcCZ4pvu02ejUC1IFgiwp1xqDOCSfh+6d0oLJHg8xp?=
 =?us-ascii?Q?70QjtJsBrCYL+M2ieLuPPw3jCX3QCTg73YHmFi4ZgjscPLRvOdc6MfxBrKkR?=
 =?us-ascii?Q?WQjV8Ig4pYIhLba1lbxya49hv9t//gF3d/Y+9JxH+tTbgJpq0VSlJRqHgAfL?=
 =?us-ascii?Q?dKjjeDXe9ZosI/GEhMBn2h5o53rAaGGt0kadiMwOn0nmhA0IezzqCSkJkxf/?=
 =?us-ascii?Q?3sLWxhBvcHOwgg1eRjFuSzhRc9l/QcfCmrOk9fikak0dXjsihBWrWyFd8TD6?=
 =?us-ascii?Q?5nEJN+0frqbYQMrsPooE92UIdiKPtPuscqx9DjFh8JAFsZRNu1YPmYItxMBn?=
 =?us-ascii?Q?VBxi9Pb0D8STWy4eUXew6yVLP3i84p439Iu1is8w6NCLrpWGMn7GMup2h8Cl?=
 =?us-ascii?Q?uTwXjKi2LCjWmrOH4z3mCY/FJsRYt7XKWaHvVs8BjfdoICumI0OTFeEwNexN?=
 =?us-ascii?Q?UXQgQ+flNlqzGBoi63dA+NzWEsbQ0mNG1X6y/MtPZIfSdY9EuhIBVwfgm/vp?=
 =?us-ascii?Q?/la+2Hvk4v6bYIq4p5LKmaTlpdtlJcCjUH06Z64MpLrEeuiL1ruvWTW62Gs9?=
 =?us-ascii?Q?PF5EBiUlS50raLxrFZI8tu1tgX+5176XaHi4peK/SnNSxD3I75gy9k3HyJxH?=
 =?us-ascii?Q?Kx0qamKXSsQLGRhcUTfCnceyo/+fGVh0ZTunaD53BquExK9jHJyMF1bNefZg?=
 =?us-ascii?Q?0lKjlzMu60hwd2fij/pUlJ5a014SYOlbh1MDDntFkf0bW1cXkNnkbfl7N+Yl?=
 =?us-ascii?Q?4Gm+/AM4hxhRWjD5+9hwGHg5BttmOZRCKgsGQnDiHHrHRErD88aasMpj28cV?=
 =?us-ascii?Q?Oq1wACt2PZH0lW/xzFgxj7LXuYnIDg8ZkDkRMzR0POntczof0Q9kvrbZNBVr?=
 =?us-ascii?Q?xDMZv/T9PYH8UXmU3SLAeckAaFDcNR7P4ugNB5Q5LYEJF8iiUpqUZO/8NOs3?=
 =?us-ascii?Q?XgYWh0APOt2X/H1WwveKnDM5iE631QGaimUpt3EZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45692d0c-aa96-4cbe-b890-08dc1e9ac840
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:31.4927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jMYyhPik0GFVBOQTC1hHSfA9WLHyQEd9vEYSsz7PRalNw0iifPM97fijMG6+6X7y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8079

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
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 58 ++++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 29 ++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  6 ++
 3 files changed, 53 insertions(+), 40 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 7039620c4b2e55..973a5219c519cd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -351,10 +351,8 @@ arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
 			  struct mm_struct *mm)
 {
 	int ret;
-	unsigned long flags;
 	struct arm_smmu_ctx_desc *cd;
 	struct arm_smmu_mmu_notifier *smmu_mn;
-	struct arm_smmu_master *master;
 
 	list_for_each_entry(smmu_mn, &smmu_domain->mmu_notifiers, list) {
 		if (smmu_mn->mn.mm == mm) {
@@ -384,35 +382,9 @@ arm_smmu_mmu_notifier_get(struct arm_smmu_domain *smmu_domain,
 		goto err_free_cd;
 	}
 
-	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
-		struct arm_smmu_cd target;
-		struct arm_smmu_cd *cdptr;
-
-		cdptr = arm_smmu_get_cd_ptr(master, mm_get_enqcmd_pasid(mm));
-		if (!cdptr) {
-			ret = -ENOMEM;
-			list_for_each_entry_from_reverse(
-				master, &smmu_domain->devices, domain_head)
-				arm_smmu_clear_cd(master,
-						  mm_get_enqcmd_pasid(mm));
-			break;
-		}
-
-		arm_smmu_make_sva_cd(&target, master, mm, cd->asid);
-		arm_smmu_write_cd_entry(master, mm_get_enqcmd_pasid(mm), cdptr,
-					&target);
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
@@ -423,19 +395,12 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
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
-		arm_smmu_clear_cd(master, mm_get_enqcmd_pasid(mm));
-	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
-
 	/*
 	 * If we went through clear(), we've already invalidated, and no
 	 * new TLB entry can have been formed.
@@ -451,7 +416,8 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
 	arm_smmu_free_shared_cd(cd);
 }
 
-static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm)
+static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm,
+			       struct arm_smmu_cd *target)
 {
 	int ret;
 	struct arm_smmu_bond *bond;
@@ -481,6 +447,7 @@ static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm)
 	}
 
 	list_add(&bond->list, &master->bonds);
+	arm_smmu_make_sva_cd(target, master, mm, bond->smmu_mn->cd->asid);
 	return 0;
 
 err_free_bond:
@@ -643,6 +610,8 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 	struct arm_smmu_bond *bond = NULL, *t;
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 
+	arm_smmu_remove_pasid(master, to_smmu_domain(domain), id);
+
 	mutex_lock(&sva_lock);
 	list_for_each_entry(t, &master->bonds, list) {
 		if (t->mm == mm) {
@@ -662,17 +631,26 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 				      struct device *dev, ioasid_t id)
 {
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	int ret = 0;
 	struct mm_struct *mm = domain->mm;
+	struct arm_smmu_cd target;
 
 	if (mm_get_enqcmd_pasid(mm) != id)
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
index 8bd072ab0f258f..712795232fcfa9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2656,6 +2656,35 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	return 0;
 }
 
+static bool arm_smmu_is_s1_domain(struct iommu_domain *domain)
+{
+	if (!domain || !(domain->type & __IOMMU_DOMAIN_PAGING))
+		return false;
+	return to_smmu_domain(domain)->stage == ARM_SMMU_DOMAIN_S1;
+}
+
+int arm_smmu_set_pasid(struct arm_smmu_master *master,
+		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
+		       const struct arm_smmu_cd *cd)
+{
+	struct arm_smmu_cd *cdptr;
+
+	if (!arm_smmu_is_s1_domain(iommu_get_domain_for_dev(master->dev)))
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
index 1f52f861281eb6..bc6fa08cc788a9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -756,6 +756,12 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
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


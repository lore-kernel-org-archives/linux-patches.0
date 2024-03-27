Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF2A14D29C;
	Wed, 27 Mar 2024 18:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562918; cv=fail; b=hY1ZpI2/3SBrO1xGJmjuMbSlkVV4iCqwR0ItIqDP46IxpWDms/TDB1V71atxJM3ikKdQIeLqSVgtTDM21OEGv58FZKpKrzsvGHTnH57qeraPDGGuExYEUxmVSh0U+i9KJ3D3ug9XUj1nog9tRccUxbc8QkftyKgG6zyNwV5cDqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562918; c=relaxed/simple;
	bh=sLaf3rQbYtG9qVax0jmvgzncugmpnfdGZBA2UbCOi8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B5P6+RU3AAkUc49XpLO+CSN62uCARnkrpXvVZpn/fSXPRO9/eD/7HWuizWrtuSPup7SkCuC0pozwBSFjIUMNfRCsHrhW3T6IKpbmf9BVMOFrDHwNIzUltsQbTf7i3lSKA+is99I2H+tWZzJbvrVFV5tsfEowqoKfGGvyom062b4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tg7mDJ63; arc=fail smtp.client-ip=40.107.93.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tg7mDJ63"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdHozNGdlY22BN9RreCR+Zbsh6kb8tJBIh68C0o+NWccMnbZfvPk+TbY9KLVDQ7W0suZUOL5jKz5B92oTpnWKkkQTXWRM4RniSpo/bjgX8db11YLlVOOU0xeEK6PKDGSUncK25gR2XWS/wbp7vstFJsSuyqsUWEorTFNu1KePB43PB8KgVjTNI2ZcuOj+9TcqqCkCn+MA/9bqR8g7J66J1sVHyWnd1ssaPWvTeeS3DejejoikMxmeFIvg8t0SSqWgY8lPgionXsOmwmCLFl0NtnaD1viI3E4qJtjW4hzsgAm4v7UH/liD4xX4MfSCJoxoCoabwh6IapjF/JxNgr92g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HiaHvS0G1kgtkjpC/cUsflX72SZnzdC3t/Ue1rEK3HI=;
 b=Oydfn4LGoTXeOcAZZbGopXZTlHEoUqcxchcvVy7d8ZlC+EUlcqMc1/ZGX0rR8O3KEoDGJ76npSPHF+/QU3uiUKyq7hg5ikOgqVKP1wnYQPX4NhxasmIv19CP1h+BxepsZeQn7s5MxmSKdAW6r0I0IMcffrMk+B+ZqB52faqmbwCfW0skbGkBIH+tfsUV8rbaMFVev87BhD6xBFkNBseP5UWmecJigheJopN2UaOGwu1007ZRoPXokKa1Tj7ruoMbxX8j42qmh9AYGe4x3PnpX5lTL2i2NOiqIutTsq8eLBBtVXF2CmwMf2N9BbwlOOe2VFN8MXiF1h65B6bjCYoNcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HiaHvS0G1kgtkjpC/cUsflX72SZnzdC3t/Ue1rEK3HI=;
 b=tg7mDJ63rbNkowGt/27DNcujwu6o2eLOm5L6q5AEWrbXDiXnb/RT7mfG8G6mQLAzmL1spIXkrsjHfeo7JjhrKqlZVs6XFHQ3T1X9qwClHMK/7x3MEStwN7X8vsUThpcg0ZFvyc+DJCAPEZQZgT1YYGNKblt7NCNkUWJ7SGvchn7rndKiYvJQXynC1oThjTIMJvBkgDr9Mw5epIMAFvuI+n0Lh3/MP4hZfneMYWC7Oo3OTbnhIvlGvSuvyK0os2bdfbXY3kdetumJxgmJQfYWBgU6IHK+DvBUyVzMenBhUDKsbROSK480lUkTMryv2gOkNTJwI5Dtnw6ZmyinkVMVZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 18:08:29 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:29 +0000
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
Subject: [PATCH v6 14/29] iommu/arm-smmu-v3: Start building a generic PASID layer
Date: Wed, 27 Mar 2024 15:08:00 -0300
Message-ID: <14-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:208:236::17) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f8606a7-d646-43fb-ad11-08dc4e88e187
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YcuuQBvjd6MXDTWQanWDLcaK1GmQnf85Ga7VtJKdrs/Oyceg8+f4qTUyQGDmDluByZKoOZwWgwiEd7AXPnGSaHi3ITvtzNhJIMSjVkCmT+WfQicv1WAdMg1kaXHJXORmI+W/8JNBSO3i2IQYtnMUu1dSEiO83LIlfNJJPlasztHLbbmC8CUssJgm0HqyMB/Loo9OkL273FUZoWyM8YfYFj04jBzVBprlZdQiuTJuiZfHAFHZYLcOWv4vhjixrueIPYBfA1AMyC24VPPJnioId2fOrKV7iJm/GuqZGzxQHrQZ8DiedVFa8HvnVHowIn4MwKMHssbCnvk6qvQnmZ2robxuuY/HwqLS27ToJk/57nkw0AirO4vtPtAghE0dYL+y48J2vnGWNQQCUcfP1ebO0BLHyTegWd1T9R+rmpZcOq8sdGaTJ1WXMuvnEJ4NtcocCYbK8Ui4G83TOI8m8eu1RrhblO1vkm9kz98mMrDnQgOtVW4bMVC9yzUDdHlPlDaiDpyPgbwhtDyXlqebPTR3/0IyuGsFwk7LdQpLEwvqTADM6v4ZfIW4J9sMVoI7DLWIUNpwb6eNa4GPq4JPkuEST8SYKGEBX1XxsTrGeiX9zNmtTBJhrHRChrfQtCV9fmKGhGABprcxVj5BShlmOGsoLV0Bndgm+ubdNMfZVJYtmnc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TPP62VnRlTHDqluNFff1WqILyMM4RSyLZ7upAiaBkYav1kpLL1oCVIRQmKOb?=
 =?us-ascii?Q?1VwY75iqEVGTLNRugkW4W6XhxJ++YaS0dwFZFp+YL1Hr18W/nRSG6+rvwrRJ?=
 =?us-ascii?Q?Zxhuz3s29Rqh2YpQ4YQTfohuBHSGOjfhyWSx+x5JQ6WMFWrsa5gto9RouS2d?=
 =?us-ascii?Q?7wIIr+XhLIfMlAazq9kL4cHs6uzxYZhQmYEO4r8rDKb0loHeusZe9kqBbAZz?=
 =?us-ascii?Q?TsXJym4ZErXBFy/oDgFKqSQqQnGNWjpxpkV6cGisY7xRjdY6hfBHCNKZhkqR?=
 =?us-ascii?Q?9b9X1jji2+qNR2ScQHGrXB+JSt0PQYOlcDaA7RM6WuScjPm2kkp2715kkrbR?=
 =?us-ascii?Q?GIlkkD7jAuxpp++CUJ1QexqGKLa8C8+/pTNrlUaQl8BANjH5zfc9S/7h/6fN?=
 =?us-ascii?Q?HQ7sTTL6r+UC+/lVY9N7Dvq7Z7VXwCWWsa2T3OOPjtMatS+dCLXJkmj/1WM7?=
 =?us-ascii?Q?4FigTIJFp9KLal/sgGu2yhNwso2XHLpjlI1qZsKq1fgSpkeDaXX9mYdePs5C?=
 =?us-ascii?Q?1L8Zk/u7qz3BTehRouOOGYvk05dFsQKYTx/OCUtMrtXL/5etxQF1ztaDX1JC?=
 =?us-ascii?Q?eNWOLOf3AAfrMhPjQ9HJUl550awDg801wrWM8oCKsmYxahOzrntG7l0OpR3s?=
 =?us-ascii?Q?NPw3XRqDm6ZQaSGGn1O05mgGUQBfJvI/x82kmswQvXlQoQ5Fg0WvkOE8BRjK?=
 =?us-ascii?Q?MMRwwp7TTDjf81/hT7yYa8n6xGeAIltxmUJcwf0lvVsBkhL0hkXg9Yiyh93P?=
 =?us-ascii?Q?ekIz3Ra373n1fRGrAHRh7THDpz+bOHAHE22jTmeRsvCVDMCupesiLyNx27pB?=
 =?us-ascii?Q?X2BlbwhHqWzPjUWStpPDFJSMfxpFd5MaANhoXW1UImVl27+vWNiYgBfSUI5l?=
 =?us-ascii?Q?M3YvL+a4DlfeOg5FCoj1MzdOCygoP1j7AbDJl8mS1aUun6o566V72eOH2wym?=
 =?us-ascii?Q?kGhvbT4seohlzObx3G8ISpw5Y/Nby2S8Hr9rN3HGu5rJkMhJ0XhjvkQ+X5MT?=
 =?us-ascii?Q?wplJPvIr8NfBset8/FBPT0qfq6n0duxnRImCKvsQd8OH+DcvwYuZpIQJTzSL?=
 =?us-ascii?Q?KHz8QdoysW9IegwhCawvclSnMb860eCcMMjvqA6Vsnv2VS01h+imZQLngzib?=
 =?us-ascii?Q?0jjj96HWeEKHe1CpQZyW6dCYf+s3A/VlXEgn9kc1aE6DyrM8OjJdgKMIJU6P?=
 =?us-ascii?Q?x/TmRPPO72Ahn37565g7vKBpW7hiZuTpJM+NdBRHEUA8gTLGJjL7kUhkCY1F?=
 =?us-ascii?Q?Y+pQ0nC80/cDlX4Ac2MtDq9sfI7LPaF0OmuC4e7l3b1Y6PVQSsdaiNR8cdWO?=
 =?us-ascii?Q?RAKpRvBAj7U/TzPbnIgc18JNqL1H4N4wC8m+VjJf1MeWuZJb4GpmEp0k09Ab?=
 =?us-ascii?Q?sQEjUmAt/YBwJAWFTSFlMPZ6y1s5I+XGJkpOeQANAQJU0JOSi31AvXvGqP/F?=
 =?us-ascii?Q?8mZ2SU40ECgGNeMdA1XlC68miFoFdwceH2+T3N2lJxSXLejhAD4xk5BGjKTn?=
 =?us-ascii?Q?D1ugpJTFK6eKuL1ZoYVezmYiVIFp66HDRWCUVr0kOlg4lyLoSqFhzsE383Fy?=
 =?us-ascii?Q?HcDF5TW/w/w51Fkn76dpjfLlxYwUXw43oUa/vWsC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f8606a7-d646-43fb-ad11-08dc4e88e187
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:18.7987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h+eioKAL+OG2/7y30XIvOKq54EWunIOZE3R3zwMZn0i+7+lRPQc5lowR5XyhMevp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

Add arm_smmu_set_pasid()/arm_smmu_remove_pasid() which are to be used by
callers that already constructed the arm_smmu_cd they wish to program.

These functions will encapsulate the shared logic to setup a CD entry that
will be shared by SVA and S1 domain cases.

Prior fixes had already moved most of this logic up into
__arm_smmu_sva_bind(), move it to it's final home.

Following patches will relieve some of the remaining SVA restrictions:

 - The RID domain is a S1 domain and has already setup the STE to point to
   the CD table
 - The programmed PASID is the mm_get_enqcmd_pasid()
 - Nothing changes while SVA is running (sva_enable)

SVA invalidation will still iterate over the S1 domain's master list,
later patches will resolve that.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 57 ++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 32 ++++++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  9 ++-
 3 files changed, 67 insertions(+), 31 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 80a7d559ef2d3f..095d11df2a1966 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -415,29 +415,27 @@ static void arm_smmu_mmu_notifier_put(struct arm_smmu_mmu_notifier *smmu_mn)
 	arm_smmu_free_shared_cd(cd);
 }
 
-static int __arm_smmu_sva_bind(struct device *dev, ioasid_t pasid,
-			       struct mm_struct *mm)
+static struct arm_smmu_bond *__arm_smmu_sva_bind(struct device *dev,
+						 struct mm_struct *mm)
 {
 	int ret;
-	struct arm_smmu_cd target;
-	struct arm_smmu_cd *cdptr;
 	struct arm_smmu_bond *bond;
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
 	struct arm_smmu_domain *smmu_domain;
 
 	if (!(domain->type & __IOMMU_DOMAIN_PAGING))
-		return -ENODEV;
+		return ERR_PTR(-ENODEV);
 	smmu_domain = to_smmu_domain(domain);
 	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
-		return -ENODEV;
+		return ERR_PTR(-ENODEV);
 
 	if (!master || !master->sva_enabled)
-		return -ENODEV;
+		return ERR_PTR(-ENODEV);
 
 	bond = kzalloc(sizeof(*bond), GFP_KERNEL);
 	if (!bond)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	bond->mm = mm;
 
@@ -447,22 +445,12 @@ static int __arm_smmu_sva_bind(struct device *dev, ioasid_t pasid,
 		goto err_free_bond;
 	}
 
-	cdptr = arm_smmu_alloc_cd_ptr(master, mm_get_enqcmd_pasid(mm));
-	if (!cdptr) {
-		ret = -ENOMEM;
-		goto err_put_notifier;
-	}
-	arm_smmu_make_sva_cd(&target, master, mm, bond->smmu_mn->cd->asid);
-	arm_smmu_write_cd_entry(master, pasid, cdptr, &target);
-
 	list_add(&bond->list, &master->bonds);
-	return 0;
+	return bond;
 
-err_put_notifier:
-	arm_smmu_mmu_notifier_put(bond->smmu_mn);
 err_free_bond:
 	kfree(bond);
-	return ret;
+	return ERR_PTR(ret);
 }
 
 bool arm_smmu_sva_supported(struct arm_smmu_device *smmu)
@@ -609,10 +597,9 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 	struct arm_smmu_bond *bond = NULL, *t;
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 
+	arm_smmu_remove_pasid(master, to_smmu_domain(domain), id);
+
 	mutex_lock(&sva_lock);
-
-	arm_smmu_clear_cd(master, id);
-
 	list_for_each_entry(t, &master->bonds, list) {
 		if (t->mm == mm) {
 			bond = t;
@@ -631,17 +618,33 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 				      struct device *dev, ioasid_t id)
 {
-	int ret = 0;
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct mm_struct *mm = domain->mm;
+	struct arm_smmu_bond *bond;
+	struct arm_smmu_cd target;
+	int ret;
 
 	if (mm_get_enqcmd_pasid(mm) != id)
 		return -EINVAL;
 
 	mutex_lock(&sva_lock);
-	ret = __arm_smmu_sva_bind(dev, id, mm);
-	mutex_unlock(&sva_lock);
+	bond = __arm_smmu_sva_bind(dev, mm);
+	if (IS_ERR(bond)) {
+		mutex_unlock(&sva_lock);
+		return PTR_ERR(bond);
+	}
 
-	return ret;
+	arm_smmu_make_sva_cd(&target, master, mm, bond->smmu_mn->cd->asid);
+	ret = arm_smmu_set_pasid(master, NULL, id, &target);
+	if (ret) {
+		list_del(&bond->list);
+		arm_smmu_mmu_notifier_put(bond->smmu_mn);
+		kfree(bond);
+		mutex_unlock(&sva_lock);
+		return ret;
+	}
+	mutex_unlock(&sva_lock);
+	return 0;
 }
 
 static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 49e51bc1a5c788..3922478799e130 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1223,8 +1223,8 @@ struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 	return &l1_desc->l2ptr[ssid % CTXDESC_L2_ENTRIES];
 }
 
-struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
-					  u32 ssid)
+static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
+						 u32 ssid)
 {
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
@@ -2417,6 +2417,10 @@ static void arm_smmu_install_ste_for_dev(struct arm_smmu_master *master,
 	int i, j;
 	struct arm_smmu_device *smmu = master->smmu;
 
+	master->cd_table.in_ste =
+		FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(target->data[0])) ==
+		STRTAB_STE_0_CFG_S1_TRANS;
+
 	for (i = 0; i < master->num_streams; ++i) {
 		u32 sid = master->streams[i].id;
 		struct arm_smmu_ste *step =
@@ -2637,6 +2641,30 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	return 0;
 }
 
+int arm_smmu_set_pasid(struct arm_smmu_master *master,
+		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
+		       const struct arm_smmu_cd *cd)
+{
+	struct arm_smmu_cd *cdptr;
+
+	/* The core code validates pasid */
+
+	if (!master->cd_table.in_ste)
+		return -ENODEV;
+
+	cdptr = arm_smmu_alloc_cd_ptr(master, pasid);
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
index 7bafec4c0c2fac..a3b94b839ee927 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -602,6 +602,7 @@ struct arm_smmu_ctx_desc_cfg {
 	dma_addr_t			cdtab_dma;
 	struct arm_smmu_l1_ctx_desc	*l1_desc;
 	unsigned int			num_l1_ents;
+	u8				in_ste;
 	u8				s1fmt;
 	/* log2 of the maximum number of CDs supported by this table */
 	u8				s1cdmax;
@@ -746,8 +747,6 @@ extern struct mutex arm_smmu_asid_lock;
 void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid);
-struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
-					  u32 ssid);
 void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 			 struct arm_smmu_master *master,
 			 struct arm_smmu_domain *smmu_domain);
@@ -755,6 +754,12 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
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
2.43.2


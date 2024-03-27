Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F192C14D456;
	Wed, 27 Mar 2024 18:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562908; cv=fail; b=sKNJImEWrywIRlHL/PRMUKJvhuXAAjUea8QLTRfZi55Sr4ZI0S+LJ8Ep5Lkx1OmtegbZHq/VfBaOUyCpSuXvAioHwjaMUv73VKipNSoFq7x5F4bxqhIF88EsNmtMmplQMPkq5Hypu3RUZfxZQRIE4a6gOf+u+JFmqeHNoaNZ6Cg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562908; c=relaxed/simple;
	bh=XasqbYiyW8pmtXQmvDY1PWcstJpGMAyGnN8AWgJ5F8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=a4Qmpey9M0dK/tOhLiVpGNGRWX4fJ4toorqcns7+75I6s+Run0ffnFI8RvdnvBAejXMUUsprwtq0bObOilh9jZuMKR/2xFWSI7fuoCrafSRpOHruvOT7X2GjuqNeRG/A2Dr8LGeg7MzrhGE+YeMlB+nKPheYKfSQ8PNG6Ymfd1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AoRyAWdL; arc=fail smtp.client-ip=40.107.93.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AoRyAWdL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l4QQZBEUiIUJkHOYZ52XIEm9WkdAqGPwQcNZ2mLgJ/XxyRWiO7kQf/6AnC9HQrrOPnZBynp/uVZu+58y+Tt0n7h8w2YWL5mEN6E5WgpwaBU2c16d9Ph5mhwgjvireoCcLTtF+L/66U0s78JF38y1djwqo6BYxdSorQodIgjWPStRF9HIeuzp/gQTJJZxKAG1MFwS22MtmEnDM0/Hbr5r3NaBsm2CGlIoDPOrP1FYNlZN+gZtneCl96BKEOuMuFnioZYJ8WlL2CJO/9nn6YL5rgBtdYe4F7khuj7RPDaeDvuX4Y+usbjS0J2TK5hPz7bf+SOqjqWima0dP5OL6yLFSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w7FRZs9o5O65w7A5fHtmKCVArx1qpU0Mag+3cPgbb/k=;
 b=fkjOrJ6BPU2g+v14gHqlrd6ylqmCS+VV36q80YAb5OtLZNzqBaJFQQ2MqWPDW0MThT4MxCehpHarw/HwzrqWQPwiCiyqpkDRNIa4wDk5TsMGXj16sP2UX97ikyyBgy9YKzgGKq3QN4T5dXoBJQWlQlvP2KiANvV9YAOGXfTINUS1CEQoj56IiXR34jNa90tefMXVnBEobNQ+Q7olmm9PmmpebWObV8bXov6QtX6JIozIR5pFHY4ATJctTi85NggJrvoxJqnm7JO6jD/wWM0fLSWf1DSeuca0co8FTijrs7U+2g8iVFN2uGdm55MuahBr8sVlTLinKkt1crPhlycRxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w7FRZs9o5O65w7A5fHtmKCVArx1qpU0Mag+3cPgbb/k=;
 b=AoRyAWdL0Q6OjX3uUPCehh3EtwfRKTaXDbehCTOTDIDQUR8Q+QFaEx3Xk10iZ8V7jwNx+WuHNERVykLb4aRwsB9khm+fd34lLrcR0kEg1Lz2SPDuq2YyO9fwlVZoXHh3V+/Xa4grXExt41yoYw1DMOnLdv0xWioLscRdZpCng8WUaS27UOs9D1F8kP+t5JPtO75qKs+ks1lQZWzjcaqae7OPHdBDA4E2XnHsGd2oeTnQJ786gLrLhs11kz9UW79jFccqGjec8QyM/xwlD9IkUIxOalfHAY8TPsa4wiOWW8merDbQB1/1GUESLMqyDREUrvzADbOZdoHLI53tAVFXZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 18:08:19 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:19 +0000
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
Subject: [PATCH v6 22/29] iommu: Add ops->domain_alloc_sva()
Date: Wed, 27 Mar 2024 15:08:08 -0300
Message-ID: <22-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0002.namprd20.prod.outlook.com
 (2603:10b6:208:e8::15) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d41a608-348b-40aa-e0d3-08dc4e88e0a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2AKnZS+74mTCOI4SpDIpJ7EJj0CejOqX0+nTggYOMzqRni/et+OwGYrFneeGuWCcE+hQ2XRzDJ3xBYeUCArfEke8AXexWKKdswNGW/kw6K6slT70lnXYO5lbwQSz8fWyhWWEnUPMmE7OLc3KZ2duGQkTj/FPP/38j/PCJ4OjYBo1nlRsuo0eBZu8JP29zkVjixbTnWVZjfpsQO4tEdoQ4phd6A5f9HKVRGaZNFocggrrXH1FdFJJgIp4I3hywOMbjJ582yOvotBlaf6F6+fyrkDmT3OcCSsSkKkWXFLSJqIjp+XJDN6HYeHoyPeXnGd+b0oBftoRmwLRVuteWmcPNI3RRyJL0Ze7QDUdHtdsVgmijx1AbDxD24ap4pdHPcgkwZBxXWfT2EBQJJZP+/ddtNAhIXXXDOemmDD+iwikq+BictmDEnEfQ5wXyjzAszvke4NCByzXnLNsP+ZhSALpOwfSOJqZPPBy8hOxCERU9J2GMGrgFpgm4AClGQ+VYiDCHdmVoPapqbw/wp0N0NuJz8YXmFMeOAr8KeYaK/VAxwrisgA2F/CWu6nS0nGjxH3QPIuWO9Zm0kglCKKH3sNqH4cOGsHhQZW283KOMRyxSiY1gZsdtn3HqnghDqjjUOmcGQmwJrFf8dv8BrUc1dvaQffX5KO//wYAsWUDeQpNh3g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EBCsPcwmwoAiPuPDF59TBGdUyeLg5cAnEkU1a3hLZXNJIAdOgGFvaT6wfADQ?=
 =?us-ascii?Q?FBPW/6CEHwd9X/6BZxWvXLOTZdqVhLB63ZkDC6ZFytiEIlGWZ8gcJshw02jJ?=
 =?us-ascii?Q?BbVCIsgheqMTtKDb/8LhYCl/L1TDFkwwbYqRjCMzv8Re+thMkeolbinXS7oV?=
 =?us-ascii?Q?Nv8/PKXxx9lls/oryZuz+bbV1Nj1S4RhKjFxtDEfGGb5l4JT/1TZPt6ZlP1R?=
 =?us-ascii?Q?FLlY6A5lFd/lCMkbc21E5L7JEtNXCpiWCxXfJjVZnMmpQz9EMZ8VuyTunqZo?=
 =?us-ascii?Q?X9Zk83oFH0G+ofUYrVlVFmgAjJS/4jq48HUc9Z6DwlxlGGVgeS4XTXvHe6E+?=
 =?us-ascii?Q?boFEXUKA+2nN4MLS7iO9/2cVkov2G2Qyd8B7pmbOtfevqxvyrcqozgPTaCit?=
 =?us-ascii?Q?QgsQAAQIbiSGajHWVz0c8dxWVxPBnnD+HDwXtQX0Wy3jkKDg4VoK1u2umkcy?=
 =?us-ascii?Q?Vfcm3t5HbGmGX2qb188HVDNhCP4jWgVdD6MpbDoPNnSHBdHxwdiJZXrYqV2/?=
 =?us-ascii?Q?OEEdTq7V+YJLtElN/0O7kS4vXAIFt7eXoE5N+AOF6WqfvqmVI8MIfAeod/Ra?=
 =?us-ascii?Q?oDZ67HA+JmRw2JuQl9EviAGzv9ZDi76GJm8exQH6EXvnkoeuM+vTTThzVRGO?=
 =?us-ascii?Q?7qCJYHWNPR49ZDe9ntAIczcN+G8BnhIjA/3Dt0q/BWkm2cuep3BTKYADGfhZ?=
 =?us-ascii?Q?pKQMecFJnZr9HNMxkqk1rbeutRW1Vlnem+Jtjo1xFyHW2F2FBR2tmrtBsjJ4?=
 =?us-ascii?Q?+ILuEdj1S+2JZJ8sRXB+8CBh7qZQXDAoaqP+3kwJ8VIVlB1gQumSNVYwbYZJ?=
 =?us-ascii?Q?IBBr7g2Mqbf70UtrxoTqKU7S8WJvQor3FQJ9dlD0inovpXsTED06+SbmI3Zo?=
 =?us-ascii?Q?agFR7ewYM7tlOnoYKBxEz9V/+0uCgFy1SRx0aMRjwWiT9GVWBRq3FnXjSsl2?=
 =?us-ascii?Q?uOLtkkdhqW3u/zN3Xa3ATT5OEHPZXrZ4jGibjdROpm5p0NHQxksU8neAYQX0?=
 =?us-ascii?Q?zgbAjwS3Xlg0gFnUYuLQmjM14m3CNigk73TLqJi2g3Dn973lU6vqu3CasCZT?=
 =?us-ascii?Q?SbgyjbQCovIXCVAYkWwAg3fh1fQ3WImsKXnWLXmNQYsLvqXkR3ZJ9APZjNBm?=
 =?us-ascii?Q?2EUFrUDTGsJHtX+jbvZNhYipwdEmsXECb8tnGj+wcqWHOL2V7W5rd6DgpYmt?=
 =?us-ascii?Q?NlFTRlXDEjNYV0G9VJfII0ItyoPVQsQ4zEn8OYmnrKStNcQ+MIwaQCdzJUcs?=
 =?us-ascii?Q?1aJsu13k4wK+V1h2C2ZkzvzcKbV/VGFWg9uj6wNKgN8a3hvAbHBmypKVhOao?=
 =?us-ascii?Q?POhcm8pOBJbbdnok9Hhs6O6P/EazIcaGszi3NpixIfjr2d7Z0YciUauU636P?=
 =?us-ascii?Q?kAvPnp9rBzBGU1agco/POeCFHUCow1Mjno3cusDMQxCr2Ho4sey/UZdMnc2D?=
 =?us-ascii?Q?cLmLVFmvwH16BfbYyEcKC2SZ6/RcC1rWkReirT9FDA4qQmve4FW+eNZWhLz7?=
 =?us-ascii?Q?5bXgpaGeY4FP1TySGMcL7AYrmx4HQMJuoG5n3DOHoncEW3tVdkQ/5Zhlpn+r?=
 =?us-ascii?Q?gVYtbaM6rcC+oRYmXNXKoK9oGLLv3JDLRlDL6gwz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d41a608-348b-40aa-e0d3-08dc4e88e0a6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:17.3534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cfM/cUhJRjO/RLvZNr+bkEdVGJwVrBYd5npSkvCb8nv1NYhUDcl640BAwjQeoH0I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

Make a new op that receives the device and the mm_struct that the SVA
domain should be created for. Unlike domain_alloc_paging() the dev
argument is never NULL here.

This allows drivers to fully initialize the SVA domain and allocate the
mmu_notifier during allocation. It allows the notifier lifetime to follow
the lifetime of the iommu_domain.

Since we have only one call site, upgrade the new op to return ERR_PTR
instead of NULL.

Change SMMUv3 to use the new op.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 11 +++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     |  6 +++++-
 drivers/iommu/iommu-sva.c                       | 16 +++++++++++-----
 include/linux/iommu.h                           |  3 +++
 5 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 3e7aad0960bfd2..e337e40ac5de31 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -659,17 +659,20 @@ static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
 	.free			= arm_smmu_sva_domain_free
 };
 
-struct iommu_domain *arm_smmu_sva_domain_alloc(unsigned type)
+struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
+					       struct mm_struct *mm)
 {
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_domain *smmu_domain;
 
-	if (type != IOMMU_DOMAIN_SVA)
-		return ERR_PTR(-EOPNOTSUPP);
-
 	smmu_domain = arm_smmu_domain_alloc();
 	if (IS_ERR(smmu_domain))
 		return ERR_CAST(smmu_domain);
+
+	smmu_domain->domain.type = IOMMU_DOMAIN_SVA;
 	smmu_domain->domain.ops = &arm_smmu_sva_domain_ops;
+	smmu_domain->smmu = smmu;
 
 	return &smmu_domain->domain;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3d9109ad60c19c..7b001afda17aa8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3302,8 +3302,8 @@ static struct iommu_ops arm_smmu_ops = {
 	.identity_domain	= &arm_smmu_identity_domain,
 	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
-	.domain_alloc		= arm_smmu_sva_domain_alloc,
 	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
+	.domain_alloc_sva       = arm_smmu_sva_domain_alloc,
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
 	.device_group		= arm_smmu_device_group,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 9db84d5940466a..107a39f1dfe869 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -791,7 +791,8 @@ int arm_smmu_master_enable_sva(struct arm_smmu_master *master);
 int arm_smmu_master_disable_sva(struct arm_smmu_master *master);
 bool arm_smmu_master_iopf_supported(struct arm_smmu_master *master);
 void arm_smmu_sva_notifier_synchronize(void);
-struct iommu_domain *arm_smmu_sva_domain_alloc(unsigned int type);
+struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
+					       struct mm_struct *mm);
 void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 				   struct device *dev, ioasid_t id);
 #else /* CONFIG_ARM_SMMU_V3_SVA */
@@ -837,5 +838,8 @@ static inline void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 						 ioasid_t id)
 {
 }
+
+#define arm_smmu_sva_domain_alloc NULL
+
 #endif /* CONFIG_ARM_SMMU_V3_SVA */
 #endif /* _ARM_SMMU_V3_H */
diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index 640acc804e8cdc..18a35e798b729c 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -108,8 +108,8 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev, struct mm_struct *mm
 
 	/* Allocate a new domain and set it on device pasid. */
 	domain = iommu_sva_domain_alloc(dev, mm);
-	if (!domain) {
-		ret = -ENOMEM;
+	if (IS_ERR(domain)) {
+		ret = PTR_ERR(domain);
 		goto out_free_handle;
 	}
 
@@ -283,9 +283,15 @@ struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
 	const struct iommu_ops *ops = dev_iommu_ops(dev);
 	struct iommu_domain *domain;
 
-	domain = ops->domain_alloc(IOMMU_DOMAIN_SVA);
-	if (!domain)
-		return NULL;
+	if (ops->domain_alloc_sva) {
+		domain = ops->domain_alloc_sva(dev, mm);
+		if (IS_ERR(domain))
+			return domain;
+	} else {
+		domain = ops->domain_alloc(IOMMU_DOMAIN_SVA);
+		if (!domain)
+			return ERR_PTR(-ENOMEM);
+	}
 
 	domain->type = IOMMU_DOMAIN_SVA;
 	mmgrab(mm);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 2e925b5eba534c..8aabe83af8f266 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -518,6 +518,7 @@ static inline int __iommu_copy_struct_from_user_array(
  *                     Upon failure, ERR_PTR must be returned.
  * @domain_alloc_paging: Allocate an iommu_domain that can be used for
  *                       UNMANAGED, DMA, and DMA_FQ domain types.
+ * @domain_alloc_sva: Allocate an iommu_domain for Shared Virtual Addressing.
  * @probe_device: Add device to iommu driver handling
  * @release_device: Remove device from iommu driver handling
  * @probe_finalize: Do final setup work after the device is added to an IOMMU
@@ -558,6 +559,8 @@ struct iommu_ops {
 		struct device *dev, u32 flags, struct iommu_domain *parent,
 		const struct iommu_user_data *user_data);
 	struct iommu_domain *(*domain_alloc_paging)(struct device *dev);
+	struct iommu_domain *(*domain_alloc_sva)(struct device *dev,
+						 struct mm_struct *mm);
 
 	struct iommu_device *(*probe_device)(struct device *dev);
 	void (*release_device)(struct device *dev);
-- 
2.43.2


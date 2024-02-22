Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97825B66E;
	Thu, 22 Feb 2024 14:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708610870; cv=fail; b=o33wzgh6FzhLIxVH1k1Tb3BVW5AaadVthvyZMFkEF0T9INMe5Cxq/QL14aN4mzAYtsJa5oP4HSLKHxHMJh+znQ/KVfQxZX43GHBktnQSqdkmUMvm/EliXM7kXLf0klHDK4YyFMRsMGsSCUjOERbHVRE7t7ec4va93Bh2eotquOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708610870; c=relaxed/simple;
	bh=Bpc0ZfQMqI1TS7Ob6C7SrtxZ80gnvcF1uczVpIlcBBU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=GSivZQzXFAB8OJ1JQX1rOmIOvvE3z+fqsT6x915sxiY5JnffBGdoeb7NjTajfInV+IN/ElFTACDk6bg5j7McJYmlSFeV1mhF4W91VjSQT5xaf/ygz6eLA8uZjM3EAY/J0Obsz09sCE1s+gm67QNcH6Ibo+R0gTPj4Zj1n8Eputo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oylYoMLT; arc=fail smtp.client-ip=40.107.220.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oylYoMLT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKX2FLAdlqJA3fMF5hQzahhwHewb/jKTJIlBxExV6h3NmsnRfbkMxHE6rBEjQTYc4p2oZBgMy25TLQFax7Q3A42+OSz68mHmx/b1Vm9bIcQHQTabKmV8q/ECYEJyvNY3+YUwCpTVhYV3TiIeMoe2fByBSCsMITWR0LRiGXNAKpsZQPTw69P/Wdmkf+BkP1vDoZB4XuVjwdgRZAiLYsxWQTjFoE8otssy8fmyZVT8J8vYuu9dyMt0mODzyz5w7u5Z3h4I2zOPnvgVeLwUN+hCkO4C4Z4T9rDL88jzcihHIah07lEAzTHFe4sdmRUxJL2ffU/aNV4uNsEO4AO3MFSyoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hg9LsdTGn1PCoHKF4KUH2ReHXPBv8VNP5IiBV6M5JeI=;
 b=U5p/v/OanI4M3Xyvkccd79Sx5XzOiYNGTAzOTOPOEMsBInKBEXQQ0NpHX4pkIRUatTXuPF5iifHJUOttWs3we3dT74VkUvlr+gljSNVyBAFU2DPyCi0j+VbWqU8v0cm6sc3rc/F9Jc90A4bDjUeeaRGW5tjyYmDMVFeySwdxI6elwmCyLSqT7Ujdk7OHJGwjWArpMmKzpPwxpq0HL7yHudPDkFvEXKL/AwWm303MmSmCvSUP2abdnmAguWCgRzoegYCV7KuJSc3OT7RhS5P/glqpDW28qRziFCUt0XjZybSY8pMy9mgqlA36AqK20gDeLurdEUosqVIknEYOfT4iVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hg9LsdTGn1PCoHKF4KUH2ReHXPBv8VNP5IiBV6M5JeI=;
 b=oylYoMLTNH8EsmZs7laRP9VcprhdQrSdPnnJtsVG9xyqPRFXvNFnQAtl7D3nFRyoyQwpcWwJfnS4Nbd/gX4uqDb+BNrejyU0JdCoa2axrPq+jErOD0wYoijOWg3aFgucUrp3SDY+dAOJ1x40CwmEOV40eGkhXHu1nTi/JlTsU3g21EXjNCsittFtp1UTleOp5npGoyXXtEiLae41BnRmwtftFBkAsDabbTsZzZYypZRIU/k1Z+w6zoc+bQgTh6IJrWlHjXZAfXT6DJ/GDLD/ZSn2JwT2CHrxvrC3IW5DXVJ8rBnwAcwmgsAuqpMp3cNLWSk+kvCIE5Ht4DARbVaAbA==
Received: from DS0PR12MB8217.namprd12.prod.outlook.com (2603:10b6:8:f1::15) by
 DM4PR12MB7648.namprd12.prod.outlook.com (2603:10b6:8:104::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7316.12; Thu, 22 Feb 2024 14:07:44 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB8217.namprd12.prod.outlook.com (2603:10b6:8:f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.24; Thu, 22 Feb
 2024 14:07:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.023; Thu, 22 Feb 2024
 14:07:41 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH rc] iommu/sva: Restore SVA handle sharing
Date: Thu, 22 Feb 2024 10:07:41 -0400
Message-ID: <0-v1-9455fc497a6f+3b4-iommu_sva_sharing_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR01CA0018.prod.exchangelabs.com (2603:10b6:208:71::31)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	LV2PR12MB5869:EE_|DS0PR12MB8217:EE_|DM4PR12MB7648:EE_
X-MS-Office365-Filtering-Correlation-Id: b2285d30-6955-4c06-2717-08dc33afa276
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6iEzLXWYXAyqKfN/nk8DjBF619M9R0tYopXHwTx8CIiMm2Ray0icFNW2ESR8yrDzKhnrEovQ6IuHlR3s2yYUe7YvIRy5KqH7x59hNlm6KQ4Y+QCp7ySslyPLHbnRPrhVEwFYltqLqqizGk749GV4LFGV5LderpbrWZ6Y1uNFdXOBa80jGIImEi/qI6nTRtALJbTgATtnixBpoM2ce7hmNnZR6hMJH0UDNXYFMzV7BKpdA7X40tjlScAvUbadwPa57+ew0DOfwTcdJpaYNK5DcPCpFS2zoPn7JLMozj5P5nlxx3Zanv1C7k7exva7HEAxSWbI5qOKErYWtbuNH2w/HwsJnengMmfyUAsd45LUUlFVMHBmogCRT5HNQ6aQdBgDL5Hdn6DxKTI98QvBmffwnweFzB9l1KMsmM90kc/FWlD64smuWll+Im23+YCHCyT2X196Wl+yHg56HtEUQsQ8UCbyuujNvOqxDOlGXucCStVUqlsIllrLgD/G1dFs2ECR3KbxMl7DTOWtWfjXzAMl5w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB8217.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?phh3DgCYWiiAkrOM1aqHWrQIIr43FEtr7HRE8Sgrd+QE8qYpwj8XdeC6U9AW?=
 =?us-ascii?Q?nzWll4STFDSEhYeGRpatk5h7NeYXH2zNdTyMRzM7lCHxqnEcldM2Rzbh9VX4?=
 =?us-ascii?Q?+ovRU2cKxKBQ/ZxpwCTPtR2C5yfdXSeTRnU/Ej5mBXYtmITVlZuQDimPulCJ?=
 =?us-ascii?Q?ph00T+7AbpYS8jIGGyMn1EesvWkCRsk4c2vR7XHuEdDB/jdCrrUIVo9QsbwO?=
 =?us-ascii?Q?abkyzgSbDtVivVzleBxVeE32h6shI1FChyBOI5M5MBL6xSowF07oqoHETc8R?=
 =?us-ascii?Q?4v2y5nkU+IeWqHd+qyhASA929dPKFnpvQSXfxNHRNDLRVH5n3ucgsnaLi13g?=
 =?us-ascii?Q?/Uk7j/gUvwupop7OOTEWWpgwEP8e05Rnhb8ILT330LkdP2bbWtqu80KrztP/?=
 =?us-ascii?Q?71VQh4Rs8MOtl7x4w0BUZkh54+zSu79KIckkMOwtIO4uql7L8Fu+uQ+ZaXv5?=
 =?us-ascii?Q?R7DBEtIQHSJVdRUqdbYII/6RKnwbwhpQ4aXT4faFVx6QxVl+Snu6ZiP6IWtZ?=
 =?us-ascii?Q?gE/yKdmR9H4OfqObCKxtZrSUO1rysyC3XHynKA5cD87yvt1zNyjLSjCKyTYG?=
 =?us-ascii?Q?u2fqGpPCL07X2F1XdJSt9jfk9h4UN9uvVNda+ZE23vXIgm6Lgi/1kXLipMOA?=
 =?us-ascii?Q?Gh02Bq84SZTUD8kFTOr9ptojA8Nr5V0KBO4fU0iU8EyblLOPo3rx6qZmsPaq?=
 =?us-ascii?Q?FlIFa1YQCth7oE0g78mcXvRRWfFJg7SuhTFqeXLT9SUiXcbf9RRaMQ0NCJqC?=
 =?us-ascii?Q?U1Ddzw+bDUpnw75avu8uk3WNWtOZO92X3AK81UYSGyghu62mJL/aYRNHOSfN?=
 =?us-ascii?Q?qwHEzfFz5ilhZ7iJfLxij/yJsN0Ifp3pZlYAca7vuvQwiz3O5vFrjm4KOlkb?=
 =?us-ascii?Q?4W/fwkFqG1ONS7Tx+LHnahFcQ6nilTtqTgsSGgNV3QuN52we+U2bce0h1jdC?=
 =?us-ascii?Q?aaof3QA4JSX3QGgIOhPidc1UqA8gE7hyiqPlkzYGON9d3nC80EY7qDGhmJDE?=
 =?us-ascii?Q?dBPhJcSoD1NOm/s0CU8dmfBUH9APesQlvlyuGfiJgJa517THrcvB8/T0qWoz?=
 =?us-ascii?Q?RRRGDv4ekc7qSBtbysrfXlcmmtzDk61LR6VLHLE31ku2KzNyvT3L9jvdDE17?=
 =?us-ascii?Q?7+RKCXVRNofVWChWXsMhZtDReADYeniv7WHLc5YkVoz/258dPw4nD61pbfMp?=
 =?us-ascii?Q?0mvq6V++UgZMbBbpQTaGEie5iAYaI6i2r+S4QVVDXnSLt1NiSl0YmhslRh8o?=
 =?us-ascii?Q?UfJu0K+OOOH7QPW4mpf/Nof8TvXk4wf54JqV/xbUc+r2MkW7TO17l1jlO1a+?=
 =?us-ascii?Q?qzlLY9hupmZNNHvGrOB70roKPaIZI7Ea8IN0OBVQnyVJIAEjFzu9He/28cu/?=
 =?us-ascii?Q?P1fNx3oWkizKAHzmavwwvVZQDE95XlgbuSE4hexkq+u7xaBQK2Va1QJ/8KYV?=
 =?us-ascii?Q?f9BqepaooCDTOgI6yAGfVt3N496uzUUjNpTmjYDDKacSllHftWouTo3P8Tth?=
 =?us-ascii?Q?3SoGEuGmMndDSFaWa7Npt1ZbExsRiBae5rWuwHPpnvqy7S6r0ajm2MP+qSh+?=
 =?us-ascii?Q?egn/fAyj0muhrYSRhgiRvxc3DPr/4tyKezn1nGE3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2285d30-6955-4c06-2717-08dc33afa276
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2024 14:07:41.8998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FfEzDtEYxqM4WZEWKRhKxTb3YrU95BwIDNWJxxZERmJC9xRcYLUHtsf5wF8lobID
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7648

Prior to commit 092edaddb660 ("iommu: Support mm PASID 1:n with sva
domains") the code allowed a SVA handle to be bound multiple times to the
same (mm, device) pair. This was alluded to in the kdoc comment, but we
had understood this to be more a remark about allowing multiple devices,
not a literal same-driver re-opening the same SVA.

It turns out uacce and idxd were both relying on the core code to handle
reference counting for same-device same-mm scenarios. As this looks hard
to resolve in the drivers bring it back to the core code.

The new design has changed the meaning of the domain->users refcount to
refer to the number of devices that are sharing that domain for the same
mm. This is part of the design to lift the SVA domain de-duplication out
of the drivers.

Return the old behavior by explicitly de-duplicating the struct iommu_sva
handle. The same (mm, device) will return the same handle pointer and the
core code will handle tracking this. The last unbind of the handle will
destroy it.

Fixes: 092edaddb660 ("iommu: Support mm PASID 1:n with sva domains")
Reported-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Closes: https://lore.kernel.org/all/20240221110658.529-1-zhangfei.gao@linaro.org/
Tested-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-sva.c | 17 +++++++++++++++++
 include/linux/iommu.h     |  3 +++
 2 files changed, 20 insertions(+)

diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index c3fc9201d0be97..7f91c8d0064b71 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -41,6 +41,7 @@ static struct iommu_mm_data *iommu_alloc_mm_data(struct mm_struct *mm, struct de
 	}
 	iommu_mm->pasid = pasid;
 	INIT_LIST_HEAD(&iommu_mm->sva_domains);
+	INIT_LIST_HEAD(&iommu_mm->sva_handles);
 	/*
 	 * Make sure the write to mm->iommu_mm is not reordered in front of
 	 * initialization to iommu_mm fields. If it does, readers may see a
@@ -82,6 +83,14 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev, struct mm_struct *mm
 		goto out_unlock;
 	}
 
+	list_for_each_entry(handle, &mm->iommu_mm->sva_handles, handle_item) {
+		if (handle->dev == dev) {
+			refcount_inc(&handle->users);
+			mutex_unlock(&iommu_sva_lock);
+			return handle;
+		}
+	}
+
 	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
 	if (!handle) {
 		ret = -ENOMEM;
@@ -108,7 +117,9 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev, struct mm_struct *mm
 	if (ret)
 		goto out_free_domain;
 	domain->users = 1;
+	refcount_set(&handle->users, 1);
 	list_add(&domain->next, &mm->iommu_mm->sva_domains);
+	list_add(&handle->handle_item, &mm->iommu_mm->sva_handles);
 
 out:
 	mutex_unlock(&iommu_sva_lock);
@@ -141,6 +152,12 @@ void iommu_sva_unbind_device(struct iommu_sva *handle)
 	struct device *dev = handle->dev;
 
 	mutex_lock(&iommu_sva_lock);
+	if (!refcount_dec_and_test(&handle->users)) {
+		mutex_unlock(&iommu_sva_lock);
+		return;
+	}
+	list_del(&handle->handle_item);
+
 	iommu_detach_device_pasid(domain, dev, iommu_mm->pasid);
 	if (--domain->users == 0) {
 		list_del(&domain->next);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 1ea2a820e1eb03..5e27cb3a3be99b 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -892,11 +892,14 @@ struct iommu_fwspec {
 struct iommu_sva {
 	struct device			*dev;
 	struct iommu_domain		*domain;
+	struct list_head		handle_item;
+	refcount_t			users;
 };
 
 struct iommu_mm_data {
 	u32			pasid;
 	struct list_head	sva_domains;
+	struct list_head	sva_handles;
 };
 
 int iommu_fwspec_init(struct device *dev, struct fwnode_handle *iommu_fwnode,

base-commit: 510325e5ac5f45c1180189d3bfc108c54bf64544
-- 
2.43.2


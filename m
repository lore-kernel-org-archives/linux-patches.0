Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2078.outbound.protection.outlook.com [40.107.236.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A0682C60;
	Tue, 23 Apr 2024 13:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713878068; cv=fail; b=qaLmMLFBCquu/49ozIo8fku7zM5YmpsKL6ih2ucxFshfCVwMFUXzmWTifECaj+GTHhRjpjM0wMkR39slGLeHESgRLMpk668XOGDczwbQKZ9/Zgc1mqb3k8MruFLGllYXnIkmuGGkbT6JhGX+sZyoH4XSCd26W0vJ+j84+BGcUSM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713878068; c=relaxed/simple;
	bh=3nzuWY4cEz5Qf+LUZUfv02QIlkM5yDUfegxBhNZIiDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W2M4pbS5EMefR0r+FH4k5zdX/JThd6x2n7JA+Mp1sOmiwo5+6uuiDWphQu303mv26dNGGTULjbP2Z3FUYxQN7gxMNV0rHNrGp/GJKt2RYp61L7mMmVxN31rYytdaQFV9wNFVO6vXKoXNnyks0BcLZ0/g8YdotHPP+iNcLjbibxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DRo07vM7; arc=fail smtp.client-ip=40.107.236.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DRo07vM7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BUsyz8I7pjsnCmuG3qhuOWq1VAEa22CcQ7FR8/YBXjxD0pvXEOhedDEntTnpS8LR7DiKtk48UXioJPNqfch9NzjK99FC/F7i4oWIl/W8mIje1MRkrIYubn3lMN5kX/hawgi0lbihf8b2wvpoIXsMxfkA8pZdFyGZjHPMwk+RMSJ2YLsNC8aAHnnvJJPjoWVZPqTevQA2cF1zgYFGEe3yXjV7QiWh395seuw1hDU7rXWSNasmbHbr5u/k6mmwFKJd8Oe095mfKqAO5cw4IlVRSskjBgsiwB0oxLN7o6dXvYvSUxwYK8+K0nMA+yBlmfi/gBMFR/59d0vVRChauT12Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HoxuEuTKO3vt7K3spL90O5PQpKLp97Iq8VUpON58p4c=;
 b=cU2PVMJAya8OFk3W2Ox/gm8e63KffHv6PXU3x2lptS3pge6o0+4++YWQpxd5Li+Pdj+PZ7rGCLk7fdsPY8HJjAYn2HphSqVib9IRt4tvZ3p4XiFQHWBpFkANfqVYPJZnkFLZlEiG0UbeyvV5f4RjOhlGB1k2DcyYF+QhdxTuds9aZ9MN4nMxpVSw/WygBG9UE066DdUsjVxOan9+s1tDAsREKvKMcGTB9KeugHMTLFjPMGkkbSqslfyd8rc7bF323v5ZvrFE5rfDuCa7/cbsnru/Oj5Xw0PDn+roABTMSa+kjAhOm4s9tol8kfuWmf40CnUcEZWfYAS/rvIhje3XKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HoxuEuTKO3vt7K3spL90O5PQpKLp97Iq8VUpON58p4c=;
 b=DRo07vM7J/e3x+nmK5CzPOP7to3feShS4IWwwJRtzIqNwWXganyQajV3kyAJ11In+LxGxB79yePdhm4VlSs/Cq31eMmGIxLZHc1t7geukKpVZknvAEToCnwYhiAvfdPfFzeJG8yWpv5YIgW+xg5I8jZ9AqSgwOFSYZvctUEaTGpReaS8fESXXLavO2qbKBNtIS3T0SxAgRQX3I51dWwBV0jf92E8jgM2VmN/yJHFpTcCSTohEKqKwkK5Ji3FfS8rNiS/DVkew0r7Rhkoao42BYK0DQyU5wo27O3Gn/e+tYytAZSgq+tIf+p9NXoX2VYD9og+7YHMyFVDdeTlDXDWaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB5672.namprd12.prod.outlook.com (2603:10b6:806:23c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 13:14:22 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 13:14:21 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v8 6/9] iommu/arm-smmu-v3: Allocate the CD table entry in advance
Date: Tue, 23 Apr 2024 10:14:11 -0300
Message-ID: <6-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0381.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::26) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB5672:EE_
X-MS-Office365-Filtering-Correlation-Id: d60c8f3d-b827-47ef-694b-08dc639746ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K/M4VwajGzlsq2B0plVqLrcrFt4+7ykzy0dwQz/QI99g1iHnViPcV/lAXLBN?=
 =?us-ascii?Q?AY1eOmFtmMFtjalzj+eP0++BPsFoZgqZrVhejXXdB6miDZYXk5lkX2+CKIX6?=
 =?us-ascii?Q?adzajlHz2I/cjMH3Qm7B0VTZKAN3UUpH8gA7O6LKxLMpYbRYr3vQVN29L/tq?=
 =?us-ascii?Q?1orvfWqI+hOFh97NF4+/6kUx6bwGljBYBJRxKyZnSoOrGupD3rLfFDk2KDod?=
 =?us-ascii?Q?CXt15stvsohtn9aD5AsEWTyGI8snoTrWjyx+HwqdDH3ur+xTPW77G9QV1Ap2?=
 =?us-ascii?Q?7hdWo03ybP/l3QxmF0R1iR5l5tJh6ie1ckrplTXUTDvJnNI3BYAKHAzV2J0M?=
 =?us-ascii?Q?03VtXmeq1OyXEo+uRnyXKnmk5J4l9jcm4yd4ouGGb9diUVvSDy7EXaPPbWB8?=
 =?us-ascii?Q?fGZbDljGwMvIUEI3beNgQpq6SR+eFG81JZhbTSHvsf0Z8lrN1OOTcbiNe9/o?=
 =?us-ascii?Q?cprY5WUTyPU2n/R8DlNqWpOC5A5phM6gOyXFvTaXyEOIV/JSqxtDlV6MnRmI?=
 =?us-ascii?Q?m+pdp+46T1yLpT07ZI0Nz5zxUiSRDMjERL3rP5Z3K/UjEvIXH3e35n6J3q3O?=
 =?us-ascii?Q?QSy46ENfDzTSsPr1O3Sp9DYhVkii2I4uDR3UDvW1S8DG+NBi+iCcs221yZLA?=
 =?us-ascii?Q?90rQH7ae2lPbDynGX2JR8Mtbcy40+Gx3z2c7Q54lseuGE2mg5uTUbT8DXYXC?=
 =?us-ascii?Q?V50mJYFohN1+3Hcldof1tif7QaOJ2lZFpLKMYhVNpc9kXs3h2zGFesevaTUA?=
 =?us-ascii?Q?JeuG8kv5fOOpi8ZsimLn1geKqBBmKaHu7LHMW+e7zxtd71/YnAOow8rCv2Fa?=
 =?us-ascii?Q?TGsj8YD+xY5f+2XHVyQrAmit6Eu93Jnh0DhPEVUexZ0HyH7kfVZkjb1ZT1Ts?=
 =?us-ascii?Q?hWD8WoWX+hQLkVUjepipms4TYE2XRtHijp+SDbsCiDUhJQlJHvJ09WY5ULKg?=
 =?us-ascii?Q?rRfjkzU4x5hO+UmV1QVbtx2T1mKClZ2ZbBbvJItAJuULqvvKRyurZatiaQnt?=
 =?us-ascii?Q?b4DiANkpMMWBBZWpjueQKXqBckLwm5U/aSDWc+5crueiS37Snz2iSms+9Iro?=
 =?us-ascii?Q?CM1HSHRMnrJo+nnYD5cacAIIgCpMT7StrJGWlOQdbxAjO0SThuvS+WZtLcwr?=
 =?us-ascii?Q?VjAIkfHbyB3RN2g7TNxmqHAobdbkpkorGTMhPF9MiMhknQgqaGDitUGKOKum?=
 =?us-ascii?Q?acQqEaWQywaPt68vsWvMXbx9kWTse3DzaEV5ZFEi1Jiqz0XuD8+Ccs1VcWzQ?=
 =?us-ascii?Q?dHLrPK9Kqp8QyRh2NjQaZuJJXhaITFQbFtPD7rWuoA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KtOG3xT2/T5n4gsrYxZbpN5fCEkzjPtipya620+CYbDeStQBkXvsXs7+Ffp1?=
 =?us-ascii?Q?qPtlHOIIzw+DM3a8FKTB71y5ApDkD158MiiP6KRXQMX8nT+JxmXo0JJKRgY2?=
 =?us-ascii?Q?o9kq3OnnScCbUVEoGqW1ghnH0cz2FgN1MkJMfYTY2Vszh6aNHbIt+OlZ0xxV?=
 =?us-ascii?Q?9NZcSG3uxYQcPok2/dmeQ0BqmZB7srCJZ84GxQwwkO7buiSshCfcp1+7wkLI?=
 =?us-ascii?Q?qVXHG5jQ7J80DtZ+coOxYBbr4wiAsToY9UI6BttP5Hhce91kTr9yrzbdEngD?=
 =?us-ascii?Q?pOtiZNYG9KPw9nhC7YykJrqTjDVakzQbf4bdIRlxQKWsgiNd4aIgblha8srS?=
 =?us-ascii?Q?wafr/OC370P2FmIOs/2XqaxSxBseRwkBQpSgSaDdoQ7XEpMSi5vnbEnV2dAe?=
 =?us-ascii?Q?IL+5wGE7+d132sLrQBaenoYbMCbDf7APqNegfHhZ9cKsgAptfcdbcAHnzl0o?=
 =?us-ascii?Q?08MyKn8giyh71ikWhNInQPDuZu92Pml1FupG4tp4A5mUbgB6AYHSf4eo3F7F?=
 =?us-ascii?Q?tJfi2ZzZZwa/L9+K1+ZfqgsJxU8MzsoCm8LtPPvQpmF+nIvY1zDoHHPd5U/V?=
 =?us-ascii?Q?O9ab9R2dCVYqILweRegDZIZ8uRiIarzWOBdU8T5auFAPqhffY12aaK+vPu1K?=
 =?us-ascii?Q?jjYxozN25chdUoEuAmUZaLZ2ya+2CZ0chqC5hCcgRem7IqateuP9xGeAbjt3?=
 =?us-ascii?Q?N2blv8tqt7oluO9FODqijCfYTjCkV6B+Kib+f4t/L4qREP8pBnnZ6kqzrj25?=
 =?us-ascii?Q?jFjVrdMxSvkxEXUvGsM9298dxmZr/bxrhFSh06MLIOrPnGhmnIAqjcSwitvH?=
 =?us-ascii?Q?uoYd23A1XJO2HSiIEQMINafEGQXSI4FBq6rRa1XITnWO5xCG1AM77ra/dHQ1?=
 =?us-ascii?Q?gHk9F+usZ+vD9JOAf7mb2hUYb7hDzDJT/Y5vWKJfg6pOteoLN+smq8OlL063?=
 =?us-ascii?Q?sNQBOfZgz46HDsSgF3eM32YvzSi1Pu8fIxUuxWrLtGuVDkaULd5Gz3XQRnqE?=
 =?us-ascii?Q?h/wZJbxtnXRQmGSOVYD0m8WZt4Vfa7TD2OQ9Ij5pne56WvXmiMxUKe1JrAuT?=
 =?us-ascii?Q?HxeSG+NqXpZ0dXvqhSs9vo1QQdIhrlPKUFjUdNJ+MyEPmscj6G3bc65CaGT/?=
 =?us-ascii?Q?dgyNi+rPg4Y6wl7JDMrYZguey611pKHoT4JZrZ7+q43oZbFjK+aXN7SEvSyD?=
 =?us-ascii?Q?8uncehY2Thzg6d2yRUpOR8/RZCuktgt+88uz/hxwmUC1cIWe6+Gp9EM3Mxjg?=
 =?us-ascii?Q?wLk7nzeUOtSIyMUkQGWi1hF7LMJMxiTF2gZeYei+jtiOltDAvpRrSGLpgIAR?=
 =?us-ascii?Q?5m23gxII71z6HxbW30y/AkiOv7a1NygHkNteT7HQVs/Zcf68flbcbtnUawqF?=
 =?us-ascii?Q?0dwTTsKOvH90+mxCuDfPItJ9BsWiQOfKh6IoTbAaC9AOpKX9ZVNE0QAGpzW0?=
 =?us-ascii?Q?okYv6KezSUiPUagRR38rch5bNtspsibz1EvlIA9eNdkUxpoH3G0uUNVfUnDG?=
 =?us-ascii?Q?zp7XlH90Rq0iO3D6GkGCc65mMEUuIh3Hhu+oTWAFRddztPBbE0xNZiOSKuOR?=
 =?us-ascii?Q?HO7iZnAeZW5lploIcftOkqYUBxs7sZiS/D2Mk6B2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d60c8f3d-b827-47ef-694b-08dc639746ab
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 13:14:15.7659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jpGIvvevUIuogj2N0CPLQeomNiwd1O58AZ06e8HSENBuPW5b5vrsv69537MQ3VJS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5672

Avoid arm_smmu_attach_dev() having to undo the changes to the
smmu_domain->devices list, acquire the cdptr earlier so we don't need to
handle that error.

Now there is a clear break in arm_smmu_attach_dev() where all the
prep-work has been done non-disruptively and we commit to making the HW
change, which cannot fail.

This completes transforming arm_smmu_attach_dev() so that it does not
disturb the HW if it fails.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 24 +++++++--------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e8da2f7763d102..3039b01e3fbe6b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2647,6 +2647,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_master *master;
+	struct arm_smmu_cd *cdptr;
 
 	if (!fwspec)
 		return -ENOENT;
@@ -2675,6 +2676,12 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	if (ret)
 		return ret;
 
+	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
+		cdptr = arm_smmu_alloc_cd_ptr(master, IOMMU_NO_PASID);
+		if (!cdptr)
+			return -ENOMEM;
+	}
+
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
 	 * of either the old or new domain while we are working on it.
@@ -2694,13 +2701,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	switch (smmu_domain->stage) {
 	case ARM_SMMU_DOMAIN_S1: {
 		struct arm_smmu_cd target_cd;
-		struct arm_smmu_cd *cdptr;
-
-		cdptr = arm_smmu_alloc_cd_ptr(master, IOMMU_NO_PASID);
-		if (!cdptr) {
-			ret = -ENOMEM;
-			goto out_list_del;
-		}
 
 		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
 		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
@@ -2717,16 +2717,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	}
 
 	arm_smmu_enable_ats(master, smmu_domain);
-	goto out_unlock;
-
-out_list_del:
-	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_del_init(&master->domain_head);
-	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
-
-out_unlock:
 	mutex_unlock(&arm_smmu_asid_lock);
-	return ret;
+	return 0;
 }
 
 static int arm_smmu_attach_dev_ste(struct device *dev,
-- 
2.43.2


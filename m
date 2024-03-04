Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EFA7D077;
	Mon,  4 Mar 2024 23:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595865; cv=fail; b=k+zzSqo4sgJqtrPF4G6w1UWkW0FoEGh72zuDXnJ5FZfUKB4xLBpWu0/Hi73+u7OT7T5YLI5IskFu5qIhogvH1vvaP0vtCeVlGNX6aqZZ3xE9Szz8Dhy5w3TxuaRQ/PM81lSfUTCA+vNADJM1gkkNTFmOQ9mprBIxmjYVpE8jePE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595865; c=relaxed/simple;
	bh=sFc/oscvQkXWxuvGl7GWrd+tk0gUOd6JDrG5FVajQv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=V7kLSoOHgFvhVZgVLv9Y38sj4xTe+GTVEv7AwHsZ6K/ZjRTZ7Lww2ifxgnMwotbGOY3DjAQqswMa0NjeuravjW6E/c/7111KWRgQnSQIt+B7qhZPZRLvBzNBGdWxy/L19NjbCtO6b0XZEcxeyc7NUMjdFFE1VkUC8LQZHPoessE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Np5JV7me; arc=fail smtp.client-ip=40.107.94.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Np5JV7me"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzAuMVYkdxsIrdBJ9FhTC+W0u63CfNvGwQfv2GAzrarX0V5ByQTAiu7dMAJ6KsYgEATcaDhPeqUTbEWk6Vv5G7I5YNOSPksz/eGFIf5XuyAlvMNY1BA3yS8/k7w/hQxrwCkgg49n6o46mzTStfbxyy5EQsT0qYHxhEkMbinsO4zVcyrEfXW7Y/DtvrKaLBnzS+hxKfRZd7ZvQRUqpbDG6sswGiLUyXAkvEZ+bxce+iWm2WVSeF/dUUXDB7i1uh1TIMOgj4EHSzOoXyagigNo9RR9KbMfZj3vvsUoDa3hadI3DmESoGOW1e1kN5VPxOqAl90U9/eJseqKzsSHoVm8/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4xKMsGXPP/UBPr/p2eAUG+hBUTxWrVhs7BRkuEQLQOA=;
 b=RnNwlCtxiD8N/K+u+pO3fGifgTI1GSoiS37ruyOnnkeDvG/3jvV3d9Z6X608MLj4EdgJWj87Lsj2kkfp/70r2TwI35UfJn19tKXzuTKXMd4orsk7DSpVNJqmhMaoGbu5Jr3Trwv6oev9Hq2bwcyVuqKUFrOiepNAGWi3YM+ylnxdyfiextipT3iOJ7fXEC1jSU6zb/nNyIr0kCz+mAQ41FHe7BwDK3Q/SBjUnE3xGnf/R39fGmThw27v7iOJl5RhkBUiLVoJ2Lg4te4Xp/cM2Ci0kbQ/RklIEKs1ybMBpsV8drwITmoOYnOEVTGQzXGqVMHfctKRO0freZ96H38HeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4xKMsGXPP/UBPr/p2eAUG+hBUTxWrVhs7BRkuEQLQOA=;
 b=Np5JV7meF1x1HgAFcwOJ7V6Vitf+V6xFr5BvagRQvJD0qVuMexyiNT16IEUn+jUfKq0tdQ1Cv5r+sXI81ynJaqWwHOX/QDEGAsLDRM5Jcvd6wtzCa6CAzLNFTvhGb5bnBQyqoxqZAbLdGjl39D/s76m2a2F0tNO0pWP41goL7ShdGm/w+0vX0avYmLZizI6gnYgEqOEOHZoFYuN1BZnTeAwd9YRH0kCkvqyA7H32iuGWAO2/vsYvweGELYB5Bnq1FLNsy6AcffFT6LbBq6Ezzzstfm37Zna7X9ZqtEfRnEBliw+tMlsNtRSuzzr7SHwdo46tjwgIMvkAYIbZUA2lXg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW6PR12MB8949.namprd12.prod.outlook.com (2603:10b6:303:248::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 23:44:17 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:17 +0000
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
Subject: [PATCH v5 09/27] iommu/arm-smmu-v3: Allocate the CD table entry in advance
Date: Mon,  4 Mar 2024 19:43:57 -0400
Message-ID: <9-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00013E06.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:7) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW6PR12MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e0c4466-9db4-4818-2be4-08dc3ca500c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ng3V8o3oojDbulpJJa6yliT1cX3YOmEOtAZJ9eo9zGdNKSgc4QwVYuXl0AMf5oPBKnYv52ikzYB/yQjn4Z6RzIGwTDf/hCMtYFM7UcfWKEv8D7T5fT84Tx4znT9PBtBwSNRoznxCMoYmZA++f0t1shSYoZ7Zss4EpzUe+Eb3XpdNLjyd4IhLcmTGHMXBvlfRMqo7DZa26WbM3ZpqZsxnsBeU+s/qrf+j2Ievd1mVVvXfNl3uhCFg5l2uFT6OHqhnHawGrgAnF7+3hLDHL+LcSmTKyhMzLyBb6eT0rwjiZtlfAvtZ772UUs5p4ZiMo0h0KnB7LSSVuzfnzbSB2ZJsE+asUzoJD/VE3h1p8gynS9/dVWUDbejHXg6tFiMUGKGJ/ASkzWb9qd/vlz2wfpHOZeE6NpU9/uYTAIjpVQwLJxRDsnN7VLq7PcY7MiBWpFdyh++Ve3QjJbnb/GL69ezKz3rXNEBVAe/3A6S0LROSqcedlw7dhm3iR8xNB0uZIS4sD6uULYbOOWZwiyCOrpFWHzwr/QYvy9GoOSZ1vgvkprzjphBQur6hzAKBZ5DeyL6x7ptWlo3s0jCb3Gd1feZP4unlODiSWY8vmE1ElTVjprLt7ctaKnn1P68OXq0pxanNAdqk4evOsv5ozLXst3h3yppw+fwlW3GXgQCeh/ba7VU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wTFcs1BukMKqUvxeS4u5f2T1NOjatjKj++TGEY75wtSCWlda5vSiLiuDU3ZQ?=
 =?us-ascii?Q?8lPnxglA6tQvk+5QsZ4qfzkt0UkdsrKl4HdwAnjYeQo0oun5NamEmd6rsbda?=
 =?us-ascii?Q?LO7UZ5zOr0TVDDXQECCqZ/7cw1jYeY8scxIUbcWvMLdl2YWB9boOsX6GLOwo?=
 =?us-ascii?Q?L2qs87WleZsh4Diuc8AoGoSrghr+6dWcjIM/HfHpMgYcD2RPNJOIHpoD3uZ3?=
 =?us-ascii?Q?fQCSmdm3k4TWwIBMp8mln+mBd2dmelr6HU2uWLrdP9CWRaI8wFNTHxOetf/V?=
 =?us-ascii?Q?UsX/YXuptX0A4PUp14T+1wA71YRnPGWjR2ExcZ3hZ7zJeujEHikcNWsPBEDF?=
 =?us-ascii?Q?qt2nZN+c90ORVHAYp9TEx3fa/ZP+VwA5GS3KacGJYY4dmI75eTbA4+d8dpTn?=
 =?us-ascii?Q?EOc4+PCf98XuEAEQXpTgSwZ0obGbSn3n8AUMGnP7MJQyagcuqsz1pycGmtpr?=
 =?us-ascii?Q?+yuGqIshBPVeOYbHBrfdatqB75ixD5brrnz7kw3sGSuxTMxyC4gN0z4VfxMH?=
 =?us-ascii?Q?4OeqABlIV8PR+tlc3WlPDcU69c9WZR7DNqSwcrYVsZbVRR6o2yJKPZx4GGZy?=
 =?us-ascii?Q?0KrpKghvw9v2boeaBgQ5Nmw5SP9YxcXn05onl4BZn9Ar2CH9bYSNsnPYnA5i?=
 =?us-ascii?Q?IRUbIXlntCnHBIHjcklKyHt0OHq6SDTGCkPKC1vnG6ls1tLIYvqyBdH+ZLd2?=
 =?us-ascii?Q?sKEiGxbiigiyLWdCkt3OrrL1WtwkY43MmMYXcm4rpVklT+OqEHMVZUj5pDUh?=
 =?us-ascii?Q?NK9xh4zYTTRX8g2v7aorlrx5s1V8yHaSkqLEhBk9XtnGeM/1eNrgkGIaCiTM?=
 =?us-ascii?Q?Yt2UOK3lVCnEi1kV3VH4janWDDofZK5e0o2MHUTBnDUNV/8E4sNNYKVX9OtP?=
 =?us-ascii?Q?4dIr6x0V55yEAJlyNVsrKq86a++W9j1mqBbg8jWBIV3SZ6uJnflziG5cO4I9?=
 =?us-ascii?Q?2sX2ZQcr2Aw60K0mLzaOi7jZasOExRKCRBbswILEBjd6jviwQ9hHbXxm/BoY?=
 =?us-ascii?Q?HSVj02Zeejhs52ZamEbtpI0pOFI5apDbuCL8aAfqSKt5WpUcutcszwv3pDtq?=
 =?us-ascii?Q?Np3KQcMB3ISi487HiRX+i9ZRetLZHhsUfjltyqAo0wkSf2GanFPvmI22PYAl?=
 =?us-ascii?Q?VpP5fBQZVh2QgxaNpLZmGXYvt8MH8IRx0l2PvsujAoi6qk0Y4Pdm+XEmpjeb?=
 =?us-ascii?Q?HqUBT0iNOPhX/FoLg9tln0P2+BxCCcFQb22eEZ9Xjk3pjSZLJOhd1B7H/9fU?=
 =?us-ascii?Q?8cJzma2MXfbNQtnB2VdsrbThjY85xUP5mNadTlnp1clEJ7MxEn+XQAclsY8P?=
 =?us-ascii?Q?3SVldFNw9Gfr0L0/AKogXvtd97VTukQU2mEe6ChT1abhiImt5yWEZaWylhNJ?=
 =?us-ascii?Q?1X8IFXgkCmNWXRUK3iuMLlvNlH6dMf2Qq7KQg+pY6xKfKIdSr1xm8YuSzgsL?=
 =?us-ascii?Q?Bzz78XzMoyB83lGITiEC49QnCRfzVIjRaUDEPk9TJMl2HBBwXwiZxlkHWoXR?=
 =?us-ascii?Q?yyNPpgy5VygJ0PmEdsG+dwQILqFF3U5/4kp6RcXVRYpZavVQSjUngg7DTKKC?=
 =?us-ascii?Q?ahLWjc7s1CKUFu6chxhUsIOEfnBp7gBdVpHc7JiT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e0c4466-9db4-4818-2be4-08dc3ca500c4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:16.0959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5aHTkWGuq9Zv1qKFvOGo1Ib+mBZZvLsHcGhVzqlNzUknLGrJpUZjarGEGHX6EUQj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8949

Avoid arm_smmu_attach_dev() having to undo the changes to the
smmu_domain->devices list, acquire the cdptr earlier so we don't need to
handle that error.

Now there is a clear break in arm_smmu_attach_dev() where all the
prep-work has been done non-disruptively and we commit to making the HW
change, which cannot fail.

This completes transforming arm_smmu_attach_dev() so that it does not
disturb the HW if it fails.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 24 +++++++--------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 2dd6cb17112e98..39081d828a2132 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2676,6 +2676,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_master *master;
+	struct arm_smmu_cd *cdptr;
 
 	if (!fwspec)
 		return -ENOENT;
@@ -2704,6 +2705,12 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	if (ret)
 		return ret;
 
+	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
+		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		if (!cdptr)
+			return -ENOMEM;
+	}
+
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
 	 * of either the old or new domain while we are working on it.
@@ -2723,13 +2730,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	switch (smmu_domain->stage) {
 	case ARM_SMMU_DOMAIN_S1: {
 		struct arm_smmu_cd target_cd;
-		struct arm_smmu_cd *cdptr;
-
-		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
-		if (!cdptr) {
-			ret = -ENOMEM;
-			goto out_list_del;
-		}
 
 		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
 		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
@@ -2746,16 +2746,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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


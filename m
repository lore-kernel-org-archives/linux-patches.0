Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6396C20B03;
	Fri, 26 Jan 2024 18:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292946; cv=fail; b=LQf6gLNdS4irTTheZcJ862Gc3OmOHucbd52FS6J437CY4n+7w0yK/Rc40fW4EVbAYAftSviMm204fJtG5/dGeb/yPezYarQ74Js81tZB2xF92dqhuGnsSg9hl1Eh8ZBdcZLg3yQdtihnVsvx6u/Kk/T164haIU+xYdYU6mexOfU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292946; c=relaxed/simple;
	bh=f0bxBy0e7Pk53f2E09IVw9EbwBBO+3RASoGE4uv6r8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qo0Gv13PtpL36mtzeX4VcZz42Ih8B2Z8BEg6WjoQSM8+zWO7vSyzoNoZSzO7X0KiKIGOOrRwmcsbqATDQNoypmdJZ4UXmUk8NHoYyJRdmJ8j7c91/GNSveHk9G/riTQArCgx89A8u1vy1iJzTyOmS7yAFBh8ircQLMrGVN21EJY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e08WORlO; arc=fail smtp.client-ip=40.107.237.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e08WORlO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iUER1WAgnNclg933HEkL9ND7TeoXx8r6SYGoN2cNrXEwVb2dH7mxJdJecltQJJpnFtNqO+oBZy3CBSv/n3UqqIwpz6iTgLm5B5Sz7J92DPG5AHFb1bwZAZbjdme6ML3fU1b6MKgFSikGVXoSSVINUM3q/8Wi1UWPkkAaI90+hMTmUp0S8c4TRzNVGVByKBf/Qiu08lB38eH4tGpOHBmjVI0t40t+bj7zoAi8ZkLsByap9CEPqV8e43FGodL9mbuZq07AQCNBfM6yoWfIf3qDngwR6mSNw4r+MGaZyMDsWFTrzyQD+ilJBPZeqK5JFcOtZisJdJSYg7RmbYYPpfpAzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RLQBkKl46ZXDARLc2F56yqEqk2Pe6CvmAAh+XAZwv+8=;
 b=Hm6Z0E6inNe4vWn9AsSwX0STqA2r3X3ThQkRo/n3qIRwqHURFshemMlwu5upEJObHK8DsdeA0ynWxaKPBtQAg06ahS+PHrkYGRXNS2aEU96bySxdQho7vyyVkkbR7uqAKidoGiDfDZejJi88TGemL1WgC4DGEnLkwD6jXMqXQswJBhafqNFfYDe5zo+rTLxwLZK+HGNnekXBx3UnjuyB01TAj06C1Iaq9s0SG6YItHw6v65XewRy2h1JrYvdmmLhSB/mnMdMEUOUcX8XpzLukM65zOh5Z6MB65KK6jgB+ZgCFzNtG1yl1qlWi+W0Wwl8dHq7N55/iZkkzLRAZm6E7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RLQBkKl46ZXDARLc2F56yqEqk2Pe6CvmAAh+XAZwv+8=;
 b=e08WORlO7ht/olTtUMR/BN+t34OgaZTgjhn7lBydUyukemmxebeqki4ge4S/mlqM6MbUPr7lcGeV5C/ch7s9bYzQ80aHiDsIbVtWReZcVbaI81pUJZ5ydt0TuBXJXXIm6pJFETe7oQpltfk5DMYtCx572zAgOvSSNhtmkYIY/3w8eLKS5e0pCee4L0FmYhcQ4+p9pHuw6N+YIhiDlOaNiqnE2FJSAPGfN7jje9v7OZLvh9psSjgUdXaTdBaUzUqxIOQagRp+brmOdujNU8h8LJa7ysNXvIwOTdqY72wQ1Lky42FyolOktJlXTsJ9ZrEiHjpSzRj0r6NLa8lsTo2gzw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5186.namprd12.prod.outlook.com (2603:10b6:610:b9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.28; Fri, 26 Jan
 2024 18:15:41 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:40 +0000
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
Subject: [PATCH v4 09/27] iommu/arm-smmu-v3: Allocate the CD table entry in advance
Date: Fri, 26 Jan 2024 14:15:11 -0400
Message-ID: <9-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0231.namprd04.prod.outlook.com
 (2603:10b6:806:127::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5186:EE_
X-MS-Office365-Filtering-Correlation-Id: e00e0a14-24ae-465f-1a6a-08dc1e9ac94d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qDa65HyG8KwKpwMpch5H/17LkZ8+JxDvA1bMHmiwKk9pjDkSjfkL/A4KdJ3uXd/RNSJWtU6hpjDxR8F2+GWSMQl2GGGwD/D5ZCMf7hRT6ZIhP3dSXOg9iO86lBCC70n4Mfi8WcnyIxlRB90MZOj9JrPcUiKw448zPVvWDRbItMQmCq5cyNRONNFeD9XlLycoeeihzU2RGeo576oyJTVBaiiOp76B56EJM8O8fVXSMhHr+0A99v3yEwqqfPc2DnC5siZGhuJIWsI1JBwkTHgRociZI7ReVCJCcX4PfR1tNM+ufO/Tj2EGa7MeutIXDrFbwRRdFgEozqjKZL45+s/LEntyW9Hszh7YdsOFXvEaicft4HKuRXrvt9KZmg4WbfU3mAOMJ626g35/3PkYnV2U+a18vZbxW7XRHgOZ4TsCianzZejZWYAPaO1ewxxAfOj+GLDlFi6+/CGwKmASl8rgFBOBpGcbhRb4mICLy7LKcZeSDJiZq5bW8YA8/Q4mBkz/Pdw5PADi1vQY3OHyfYOfGDi6v5FYRZ0fEwH36BcrBZ0PFWLFsT2sgvl+Bu0iexBtbY25DpEyk+RRQWsr9dF4/yWsYez1YLTYXjOoL+Cw/M8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(366004)(396003)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(83380400001)(36756003)(86362001)(8936002)(8676002)(4326008)(5660300002)(26005)(2616005)(38100700002)(316002)(66946007)(54906003)(110136005)(66556008)(2906002)(7416002)(41300700001)(6506007)(66476007)(6512007)(6486002)(6666004)(478600001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fFj3ob7TG3Q+so92MCCcruv21B3QTDM5TCLNbQkbGho+SyQ83ZPwxXkk3qAv?=
 =?us-ascii?Q?/R4Ivj230lkVUC67NXDZZGDXzLgViHY2Vh80PJBg4V6g0IV23LG+f1GS5VUH?=
 =?us-ascii?Q?c4vC1GpWNl+QDYR0SNs2kgL71tdu/+x4N7ZtPJ2i/Nhiyvwt2rFPiZ6xG9x7?=
 =?us-ascii?Q?KoYw7mTCm93tkwlszacJz+4u1kMHB3Vg7gSZw5ItuOeORLauldY615bb/t2D?=
 =?us-ascii?Q?XFhnPppnAnfoV62eM1azN+uZfdYN3pmpZVxVr3pECAIkhp8b6tTNQI+FnGjk?=
 =?us-ascii?Q?NkmlXy2t6noNNmpTepwBmsW9RmhvmWKFFZtDCG7F8UXXmGA2rF9xb11GJp9V?=
 =?us-ascii?Q?7uMTZ1ly8NzmKoQC1l65JMCBHAYfYjg3jCj+c2WM5OsUNoxVXRrULchc1VYa?=
 =?us-ascii?Q?Bhw+KLJMZPq/dMhgrecOZHv+Wsg0vl8HFzaKcupyUiOwn+ccbrxftZ7N8ind?=
 =?us-ascii?Q?QzJdmS/NbDoMaQJoto3eEwKfLHok/jBn1MvxHBwmUsDQkdg1AfMeC6h4zuIF?=
 =?us-ascii?Q?RgLbb5mvOW2/2aI7r3guwhb+VsrwgT9Jkv7LEEMlScpfwalR2RbqODdTSyDR?=
 =?us-ascii?Q?eqNpyY3qS1DNgMQvnom/8UXXr3poF/r4J75OZlQ3IlBy8Ml8eXqyL54ejNBW?=
 =?us-ascii?Q?OZSu3erz2d0qBDNgAykvd5Mp2xCu4CeI5bkOSsgmSSiKHdw0yt0xCg0pkls0?=
 =?us-ascii?Q?QLBJIROMCoD3uAVGE9YjkHGZJ5Zpc2yFflL8S/FQrEkR9C4jYDuhFgrw2mPa?=
 =?us-ascii?Q?FD/70CJLa/vW8IVu7wQf2zNdoxmfVrUQzR0/pVuSRgmAhodUNygjiWVFF8QE?=
 =?us-ascii?Q?XqTXO1jU74dtcxIegsVXKjfWqTLBKw12xkdulicSWZEGD5eyGt5BgHkGBoeo?=
 =?us-ascii?Q?pBDzhN5Mt1jNfCOggQPMKmynd4yNiM/UgHAfD5L5i9mTQs69JI0U5N1/Yinl?=
 =?us-ascii?Q?a6TYGAk5nyMrMj7CSq9cXNgYkDljwqdaimmobqumAV9coBz90gCoGdDvNp8s?=
 =?us-ascii?Q?TAS6tYoAl4daH1JjRBReg72vXuY6+VJ+aHWQYI4CfMO0PVjkvnd5SEFDRGHm?=
 =?us-ascii?Q?RTKVVKyv7LTL7KeOiuyy9k82rfOhzd8F7GfrA5DLCXr4unGIKKMAiISXXAAI?=
 =?us-ascii?Q?99W+/GJaLr3D2qzgG45ZdV+riyufrQbul1NW6giz6vutyLvvR/Jwx5sq+l4R?=
 =?us-ascii?Q?2M9Y4LZ7JDdRakDzR5q8lipwDGzCknFE3gQT59x2Teqjx3pKB6SRG6vzD1tv?=
 =?us-ascii?Q?k+bqI+lpwKJL+d9jH/eUhPmJu3GVkEH6NvwXwIBksrvY0FHxHUwH7iLvMErN?=
 =?us-ascii?Q?sXmcS1GH8yJgD+dwXmBh5ickxk/PzW8RoRX3LGZuDt5PTAl9NbJYfW70qU9Q?=
 =?us-ascii?Q?USFw8zVMz1Y1lRrsL2melTvJy+zWF13oJw0m3+bqIQ9aJ4wGYP+WmwZf9u24?=
 =?us-ascii?Q?WW2RTuT75jfSWYbxkdwMsXfdgcjkvFVOUG+qyJeqHdM+yxLQ4crvUvdGuBi7?=
 =?us-ascii?Q?UW0oTzx3fik1dmFz766dt0mRH0r9iHZmxPBPpZS5hyWUUzKpMk5smZMMJDOI?=
 =?us-ascii?Q?Auhg4ozIpBFjD38HSkc7R1tbuZMKZuCewuY384mA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e00e0a14-24ae-465f-1a6a-08dc1e9ac94d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:33.1959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q83rBDFbpO4WlcknuYdw2+mtxKzs6xiPJfCZj/lcl6pbP4TLFGlMmz4EGJxNEJ1C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5186

Avoid arm_smmu_attach_dev() having to undo the changes to the
smmu_domain->devices list, acquire the cdptr earlier so we don't need to
handle that error.

Now there is a clear break in arm_smmu_attach_dev() where all the
prep-work has been done non-disruptively and we commit to making the HW
change, which cannot fail.

This completes transforming arm_smmu_attach_dev() so that it does not
disturb the HW if it fails.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 24 +++++++--------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 7562d7577f3940..79d80de4c0a60f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2665,6 +2665,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_master *master;
+	struct arm_smmu_cd *cdptr;
 
 	if (!fwspec)
 		return -ENOENT;
@@ -2693,6 +2694,12 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -2712,13 +2719,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -2735,16 +2735,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
2.43.0


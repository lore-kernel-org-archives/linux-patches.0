Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5A367E96;
	Wed,  6 Dec 2023 17:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PVtzJv8V"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ddq0M1K42FMTw/2/VvcqkMAFcl12cYHhRAQjoT0lYfpNWNiNi6kfll16qJXKtUWOqijntuvVf1j2v4KkGIuKhnOJXfgm2H8SYSOKOeu4hPauWCTUt1CkcrOzB7cd7ChQ54XHGDZ1lXMqa/DS1zHwaJRVV0k0cWIXRX/xAlPsEw4i3POluAgG2cfMzBczt/h+UBffmYLNlxJV664BwJlI3jXVZThDsyqDAQYzx4cX1N6HXcb4Qv5g3+yOq6x8SKa6/UVvYlPu3mwywD5LYiQayMNYOH0R/mdR2jbfnO3mvw2QxmhzT0oaMrzfl73+q5LQL1FtvOA7QLbf+dZIHowMcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bq9A//P/Fz/X6TWAwXikaNRN+4cbmGhSjzDHwPANg3g=;
 b=DKuQuvdJYEAAoAWILpBpv2TwHGe+RNfC591HHcIAcqYYMfh/VgGNw/MHuC3q5+bUqOi2dRXMHaXv2FI/UjgDBW1a61pI5GoeFk/ksP5cUjA4CSwqcwiukiwkQ25KPzSFtE4UXtNhVHbH5Ndb7oTW3J44D6J/KL1coMjoio0HQQHdOA3ID9frZ4EGf0uFM+k+Fo0QR9x5aVUYcpgzcRrqVWy3FARlIwwterTt9vCXm7q7ZXNEsBqa6MT8qTumtxpTqA339rYLs30myumwxRAen0dzl/axEJnSQNlPVrj89uwVMxCbwQx/ETd33eGw9TqLOp7NP8NUEqL6JaJewB8tVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bq9A//P/Fz/X6TWAwXikaNRN+4cbmGhSjzDHwPANg3g=;
 b=PVtzJv8VJG3Jq3RxceMHbFO6wQ63+05IIpjA7+aqALaYQx5/0CgFystubo5UA0gFw5q+eKZRm+9Xqs8wZ3u97k7LS5Y8F3tQ1AoyMTYVW6OzT+iCAGctYfsxMbcDWYK9cySKzPfGrc4tux3XwtnSQHzAE1lWNXy9z/Hzq7/IUpSYamUPuHtIBTcenGJxV1YwuxwKQ8bfBCpKCe+ZWuLifLYp1t3fUzV1eeLU+8Ud0xrFVKLbyMwFOGrk1/GxfrbBLvVo5A+bt5wUQ4NU9Nsjjrg0VgsOMwClZFKrb0DntvbNuBlGJgBy6HNPix9baYvy1Vx/lcijZ2mIQVe9Y3kS3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7364.namprd12.prod.outlook.com (2603:10b6:930:50::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.25; Wed, 6 Dec
 2023 17:28:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:37 +0000
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
Subject: [PATCH v3 09/27] iommu/arm-smmu-v3: Allocate the CD table entry in advance
Date: Wed,  6 Dec 2023 13:28:15 -0400
Message-ID: <9-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0003.namprd15.prod.outlook.com
 (2603:10b6:207:17::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7364:EE_
X-MS-Office365-Filtering-Correlation-Id: 4340af18-e384-46f6-c116-08dbf680c5e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GcYm2GlSrQP7MJ9nxl7SsRGgK1qU9cZfCSnXZBAKl41W4s/4b4/j1Kz5qstZJuiV8php/cAWEzhdAh1VbBiaE0XfiUewjXLbvloWaaDr5FEOKHqdmK0ckuhsiJdLwugXEoVxj/xl80pu5fWQ1JHp2cA0eJAnVwbqq556iECfd+3/QOMZBrzLKKgEXt8oRg2zpemZcgCTCxQWtt0HDHP0NJNx4Y0FLhpUjiUW34L16WrZXkF2iHmicPm1EwLLTnQVucJoCaeRh0ZscFJOub7NdvK2Me0aybPxnGdvLTjZv5A5ByPEQOOAy9HQPyCOL0uRK4ztHKhqslj9bpY4kQexLO52eXgLm0SDx24p7pPNRi3iY2kk/x7niYlFUnxoyvJBwPJMWSoYCeLTg9WvD6XLUgjhSGHKaizxSAyWSrEsM6V2/GveVdmIPOf/ocuBBbrgn2gSfd3ITf7IjZ/pC3fGD7oTan/crQaJ6g1ppIH7fne3IFzi1NwblKMHbHtDY2PSDW/h2R5bSBoniOMAQbMmViYEHh6HpcUexolE904XdjaPDsPy36i4t6wRqurgqnBYN1CcysjUpfL+knJkeW6gfX6Eazx4gDUQ88uBkKs+gnE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(39860400002)(376002)(136003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(8936002)(8676002)(4326008)(2906002)(38100700002)(83380400001)(7416002)(41300700001)(36756003)(86362001)(5660300002)(6666004)(26005)(6512007)(66556008)(6486002)(478600001)(2616005)(66946007)(110136005)(54906003)(66476007)(6506007)(316002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8+fkJ0trdFO+wLYj7z7wZs4HMtFu1x2yvis9aOl5a/vBIjF13BlMQgWn/yhd?=
 =?us-ascii?Q?3TcQ8IedyS1FETpJzCnwVaM0U4Ijagwwtn1QpBjwPBV8v788I4XWGErEKwfz?=
 =?us-ascii?Q?RsdxKtSrUuLGFPSFzdNpn0JrYbtUM3LuhmXOy1w31lp1zpT988/0lsGFsjyq?=
 =?us-ascii?Q?yFkx9ysHyu/5fzhGKWLeuqFuIOeO/AqAkt4i1axh4phsM8nSaETdUMHsjvzQ?=
 =?us-ascii?Q?aWNw+fgKGdvEo7lGAqyQHZKH2/aUvmq6RyagUDwn75WCF6heMfbEfzw2qW72?=
 =?us-ascii?Q?oa8HBsf7Myjb3oelaxo8PLgTvLQHGl7+UT5X3L0B7PfNR07+fQ1hPZzqh0+8?=
 =?us-ascii?Q?F04cqG1CHZhjHYbYCZtEP/swLhfI0keGOcC6BletcpQblh+bA+Plymxv/vMB?=
 =?us-ascii?Q?z9KRrP99lksUxAUP1nHu+KV8ii2kTrJPRNzfgSnD1g5de0Un7A50kqi1c1yB?=
 =?us-ascii?Q?wXO7dl/Ko4BRKnvW93naa8zII6Qlj3YnkKLj3Qp6vV6gLWdlScABPHfHjeWb?=
 =?us-ascii?Q?EonXi/i+8ZdZcbCbCKvMTyUpuGqwN/Vi/XrwEgtw0pDbbGnR+wBzVQEU3+up?=
 =?us-ascii?Q?p4VFT51eU0zWeORIMVA4euOxI6ntln/Pz5Y1zXmjjPha9oFOI2NidqCC1hcG?=
 =?us-ascii?Q?1ASIpFFQH0Dpupn6Zj5rwE7b2S+RjqYPpM79gxnz/fmxkRTo3PyVkrJZCQ9r?=
 =?us-ascii?Q?6Hu8ikzmNJMp1bxCRMHNXQ7/S31QZIEIRqHqdwwUvPpFZyox0paee+SjIhJD?=
 =?us-ascii?Q?DmlQY/QX5dbp4LQ6JY/qadDCX2stU0BH+5z36N8LHIr2V/6akK0L15ukztQC?=
 =?us-ascii?Q?nvMq5VudjVB1qZftE1qVgRmw7rs07d4TYolwemNAM6z1aVsQQIhu+z6C6scW?=
 =?us-ascii?Q?JGfIlfvZLaIwp4fnrFiiD7LY+Un3BvV2tW96mMax10tLrJOLjGYGqOjHHxxR?=
 =?us-ascii?Q?zfXIE5HC0AAJ7YhW8nnNe/yIk+Uvf1Z787RiVG3H+qUHCyemdf9pOxe3+CYr?=
 =?us-ascii?Q?CbvM+VjT2GGeBSll5q4hyZnx2twhFX/X3LL12kBaco4wZFrFiICkUyzamH/c?=
 =?us-ascii?Q?/f1V7oaSWcpc1MzL+neIaZBBOTxeRuKiL4nj6Xzg+s2U/03hqXjDGiYxgpFw?=
 =?us-ascii?Q?OxOXylETZmMQ2dRRpIUqPx2FuLo8FKHirmSARV8k2hZgevrvSrvga8/bNjZb?=
 =?us-ascii?Q?NfEEKdWEfmKmVbD7vNn3Sn1QMzmBqnQjPCVHwKK45uF9WXT9c2liQsW5bHsH?=
 =?us-ascii?Q?QSl6mAhhyQ38zOO7U5K93HFcPpGd0m/2kwz38fviyS1Aath/2097+hSdu2TR?=
 =?us-ascii?Q?qYfVdyf/Mf5kNR3zeN95WD0+IDfBBD2Au7cVlzDL9g8/cWZZj7tTELZSKko7?=
 =?us-ascii?Q?MmejwmKnupyCFAJqdnoQVI9Gdp9Z77U5gBy0jVG6hInHztW7uZkqJnQKR8Cs?=
 =?us-ascii?Q?TrgLhXrqCuJIT7gLTJ1dp+U8BvD8KdZkg/Sriq43qB/S8g+4Wy/iRTHpN9Gn?=
 =?us-ascii?Q?AiujcT2lFqcH2AFHeqoNI1RtvArzbFi08daM41F4FAOXoYH3Kmi9Sz1JG3vK?=
 =?us-ascii?Q?KQU/1u7gUhL6TMJ5SQlxwjByT95oimUHQ5Fi7nAj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4340af18-e384-46f6-c116-08dbf680c5e4
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:34.1230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fkXHiPBwYzOjHGDACeNKQfFQB8kBrF7GpjsRVGxt60kqWwGkW9fKQzh5PGDEPC3o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7364

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
index a21589f8729176..eea561edaee908 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2596,6 +2596,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_master *master;
+	struct arm_smmu_cd *cdptr;
 
 	if (!fwspec)
 		return -ENOENT;
@@ -2624,6 +2625,12 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -2643,13 +2650,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
@@ -2666,16 +2666,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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


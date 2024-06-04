Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5859B10FF;
	Tue,  4 Jun 2024 00:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717460174; cv=fail; b=WtAgJO9pfzNRVv1JWRaidmh/IPFsknRKL74Zy1+Sc8Z5+BgwD+EWAaG/86IKa44/oVKUZG+YO6L/CgyYfZLwQfsR21XVvDrCcji2G1D5XSVHBOjhdRVGwROz406B5wCKrJRmazd4PVlgzEG71stJgJ6WA2mNE+T30t/w5pRCmVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717460174; c=relaxed/simple;
	bh=oSCBRpyVLPvcBYGvtEHg+OuDCiSpV8Xx4ynRDoNKiXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pj6VEbHK7kvxrypc6gMlIBoU0RDyDJHI1D95jBaGJk4OvP2As+Qexhrmn8uz05cvICS6JigtsKj/XyllEUKIYWyRV/pecmRVn2buuVtscg5dfUXngkHwalSVornncvdLRCXPbKp2ilc2rW92y15MBC0xSnTevHSD84sH71jixAA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X/LBbxcv; arc=fail smtp.client-ip=40.107.220.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X/LBbxcv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k79mKmvUPGuC7AbUWm3JZ32fgOIFU6U+/N3h27Af7L3ne7j1VyEJ6d5+j/MUZukFCNSgqbqJr6Kw+pbRco9TcBmtjl2mxx1y1ghgOBJxdckthreiEjtrsmy5xIDWxpGsWLcPcy75LaCPw8Xs9UdSWjwbpUTOK0Ng5kEb0HgaehPyvKAKVCGQLMoICU0NjoIJ3AutfVBJP6gM5fwpXc8fVIUvtc8fbLggB3tHupoR8I1dL9DiGcVPbRczsEVAtrec+l5rNqhr73a95WJ/tp5VA8EcvTSehWtWbrhbCawpX7ksTr3kT+2iPeiyWMOiEpcwtgPMc9dbXJuKKvNXIrJQoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TD4CyZh/RNzVohInMGcPgepXhSkiHpsmPr8IKRgtlbE=;
 b=gTj5/xYsgeEJmg48xP2tNfCwPRFLs8zpS84UOojvmImIusM2xT70nPfOZrl1osqhjybutUVYQy+JoW1Y0FeoR7pdAzrw+cKQbNSeeGAA0RrBXtvOuBhxGd9qw7jyU2n5D8Z+Wn56mZQz2BswWrEtg0d4n9GXfQQayGvDSZ+s/01BQuysyVeiRhPTwrlrdkm+p61jVeskIe2TwBGJ+ZrNx5N36EcxW4pB7/IzxiNqMChV7KW66oTGZUzve2PreS+4gaXYKnIf6ZA59w0RkvahjCTfUuqjHOlLu7cRQvEBKMxylmAS2vNWWwPirH6vgVx6xgri+N2uD3VroYPwLgNSzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TD4CyZh/RNzVohInMGcPgepXhSkiHpsmPr8IKRgtlbE=;
 b=X/LBbxcveW1ikg9HghGDHb090kxGEye3C9Gwv6FUYNdPklLZssBCG0zQDt5y6SiXJ0rRhU4xNfbI+FwC9avLTYqZk5AbRy93QND1cCudsetlumuuveUoFczfTnzsfuB27wF/cNo/4FevGMQkOppBFXEtWzf+OyphrgwA+/g9N4FlCAhxk2JTBPo3/0gsLuTwz+i1pRWTmRGUGuvghie5BbloUpZZ7Eb8cN3JxS2SunvgX4XSMotgKfqpL4L0XTXDXZ03vH4UsoE3VZ+KFNnrb4kQOYx95cYUp6xapo2l2/FcNcmTUPRhcGK0C5HRglmcEGRUhhZ0U7Dkbt9wrm95Fw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by BL3PR12MB6451.namprd12.prod.outlook.com (2603:10b6:208:3ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Tue, 4 Jun
 2024 00:16:06 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 00:16:06 +0000
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
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v8 08/14] iommu/arm-smmu-v3: Make SVA allocate a normal arm_smmu_domain
Date: Mon,  3 Jun 2024 21:15:53 -0300
Message-ID: <8-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0432.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::17) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|BL3PR12MB6451:EE_
X-MS-Office365-Filtering-Correlation-Id: 510e2541-8e00-421b-9b79-08dc842b8599
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?slopRetXtWLiu6dwe9Xy1sfvL/U415lFihT4OjaDtHkGbKDZIC+Z9OgmYlqx?=
 =?us-ascii?Q?fcQ9lyRq8oRoI3iUNVPUt1/MfhzzOH8/Mt3+BrRMjGA9ebySDaIFgVpkdY5r?=
 =?us-ascii?Q?yyF0rdNGheJcjzLupTswQD37H1d7wOJ3Ql2HaHRtSwxNba6eVG0au+/ZRPaI?=
 =?us-ascii?Q?kYgEdrrqKNlQ81lREspCbmSf8zum0Q0PW6PzC6knCyr+8AlAexgIiKLFGvkv?=
 =?us-ascii?Q?8VbVwh0fTahT3/TkH8CJc6C3RckBD7o97MXR0SbTz5d6pMbSlNMIEhr5gkGd?=
 =?us-ascii?Q?h73RfvyRcZA55N63gBgWEbmNoFlmEnzzhCzo/LU16z1w1A5U2RjFSLxSW0X+?=
 =?us-ascii?Q?b/kP/8VG+ZI6e71hnLnO7/UdNNW793BL+psqRk0LrwR0NLojLGECmfNYrBYv?=
 =?us-ascii?Q?F14uqeyVYcotIrMohpnsqSwFACDbIUDO23guchOUmw3jbrW3jbds58pvIJlI?=
 =?us-ascii?Q?G3TaNwXXh4t8XyhFuXJmcW6W/qdMi2ZemjvwIiJuDUVbEW4oJNaAwAJ8nTLW?=
 =?us-ascii?Q?Dn7wFX1oSVmtJ0MCMHlMMaMyI/TbkaHNWtCkY5Lyjl9RgCmbl6u5iSDObGoz?=
 =?us-ascii?Q?hsIBRZa0apQWVVyLnd1UFNbiJht8Wvnl4tSch80XvzpO1vTDaU6Lwmxui345?=
 =?us-ascii?Q?oOj0QA0pEielWTYHW3lGr4qkrijho4daPwNZTzRpopTXvyI0JP0NGves6d9R?=
 =?us-ascii?Q?MHCZ10YqWbRZhvs4A68gjycG1Nm+HvPoG69Cpwj5f3oUWXYmXylstUyU1VXv?=
 =?us-ascii?Q?ZOCDlCN4+domgxYrTRe9yS+LB+ahyCawpy9qPkEa7aFJnlBimDdXG9peQ+xN?=
 =?us-ascii?Q?NHtiURIWIFhpANizEYbkzOPZxp/A0coOot3N8+Pvdic7jEmcsZZtTvmxhJr2?=
 =?us-ascii?Q?/M5BFuqFUgAI+t9e1qJVOw8PdFycqjHyTwhhilY1C3QDdY7StBqvLtD/j0gA?=
 =?us-ascii?Q?bS38t8nK+0xgSsgJJhlLKYhMMOkYytm9WJe/vfnfk6TmvQ+ZvcRi33e67SEy?=
 =?us-ascii?Q?umiFMFVZNiaifXrISriUufiUksRhK/wnY90kJUyxX3IaX/0WB6dr+sX7wCNo?=
 =?us-ascii?Q?EbkTeFS8NxJg6KVod1cn/m2sTSroCdlcq8QidXNJobUI81BMhyBWZOWp1Ng/?=
 =?us-ascii?Q?kmuQFJiFR4qiaQ30f0uOlZweapMZYcuoavmI5wJ0xxd0Z1bXq5s8i1uk/+ZN?=
 =?us-ascii?Q?H9Bv0BWMPOJVyX2SzboJUKehI51hT6OSl9AVagbDf9IRBGBf3A5aQrxV2KjN?=
 =?us-ascii?Q?DQVCRIB+LSVQweKMQwPSR+QmCNGM/Z+SQYbphrDRdQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hcmzAdlXtvJKnrH/2AucSQi3oY8vtfRwlUZsSuv/wNQLUn1Xv77FWEHUL/pl?=
 =?us-ascii?Q?44949VL7UgIN4Yb6RZvua6nymnlctJBlRWJXOQjc4uQnB7V7/MTV9gTwgEa7?=
 =?us-ascii?Q?me4BFbRhGthvs7sBvqcemk6ggNT9yh91vG1/8a8+48Wf1u8CsDsVxirA6cGw?=
 =?us-ascii?Q?eVb91Rdc6Ntx6z9g2ZLQHBWShKwVrhsDvGYKThppNXI3gI6Q5kIPVOZeU0gM?=
 =?us-ascii?Q?X2mPIaSPkJcOilX7H4GMyZ7r+Ru3Zhc48+LDvjbz4Fm86jNxu867LCk4raGE?=
 =?us-ascii?Q?BzgQHAe8a+Xslk1keQqiiABJKtO7lnyfEmoRKEow5x+k6qigw27Nb4SCzQUM?=
 =?us-ascii?Q?nw4PZDALjuEjpQOkcOMlHPHxU5oytI3DNnb68eeH2O3BtiMh6f7nRcukby88?=
 =?us-ascii?Q?1h8etYvtqLBcB7iKrHm9X37g0STGgED/nPMnYtzHe4YQx24L/e9+gvQ7YAEj?=
 =?us-ascii?Q?5hUXDkqPegFXc/GQJQO9i5/vQbwcAjo0kMNQcnWG3rD74QOFa6kKvoo5W9mN?=
 =?us-ascii?Q?PzoORQhTqtqEvj9uzWVLJyRMMq/UOJ3juL/9uOnoo67txhjBO6y+W+43k+nk?=
 =?us-ascii?Q?hM0xtyxQlKzASCVlVb7PVyivfD8SYKiT440Sc3fb3Wwg1UunrV+xQN2EJotW?=
 =?us-ascii?Q?oGb/qfrOo+3VwdfPOsE/W8XIyOWqeX4XhnHQ5poIzJxn1Ou1HzwEmacLAUly?=
 =?us-ascii?Q?6BA79M6coMyeM5MmmKZzss7vuOr0e5yrhvX1TvOuCMQbB07kDCozArI5tyMJ?=
 =?us-ascii?Q?ixintBMJtgcV16AP3hCHpBfSFzH9ZPM9tlD80LZa7YCTWlqMtbn7eMyFFsTu?=
 =?us-ascii?Q?cTkVvkLA8HgbPsBEfR1Rby+JBwPZ/whM+j8P7v6W8HesPfg+fG1+jPiDv4/2?=
 =?us-ascii?Q?E1QZSszneSJ5u+P5m9ZPpn7UkTug5dZJx206dDN5ToHXiRy9OP2e5hoGDAFz?=
 =?us-ascii?Q?AwzbMHO/MwfhOyAq9+uVip9KsAAZR0mRSO9cYqrDAtNMAzKBFXBRXn2BMOiX?=
 =?us-ascii?Q?XsW0Tuy1lnbgci0IaoY7OeMu9R1QIex0CjkQAZjeYY4Iq4F5fgITdrG8FMWf?=
 =?us-ascii?Q?1W8FecdsegoM3DCrKipHZiXmgOKRSLXr+b3OwQRyilQML6rDKB/vxqKmt9EZ?=
 =?us-ascii?Q?7aEyd1j1hNFNibWd7kMNdx2Xgx6ORdiNK5fs0AFiU9fPy9IkqmM9yi8y8zQO?=
 =?us-ascii?Q?fMqkU5JETarkQyXK5Lt0hXTEOqiJsaKtIGee8u/90F2JlCRbC1Wo60Yw5beR?=
 =?us-ascii?Q?5IMLGB3IRuUsE1BQYbKSQsEtD03lg7f4sAh5ylUOi29gZ/hPA91HVPh76f20?=
 =?us-ascii?Q?dzbNSqNIx2A+AtV4qzE4VuSfE8cBXEuzH/t3xq74zhsKUyO8ilEYHEgz9PNP?=
 =?us-ascii?Q?YV2jOxWztc84QOf6BfHpcOSVdxYQzg8WWFQrPlPgKl+AsGbEOY4R2E0iaab2?=
 =?us-ascii?Q?k8wEUSaWPPmN0I2BUqmCqCdWRJ6hutqEBJZwmWQWloKzljD2sEFbWJwh01P9?=
 =?us-ascii?Q?LdXRLg8C9gbS/hV7No1B4cT72WTEDzTyPw+YEu2HSDmwi3m7WAOoo5w9gxnY?=
 =?us-ascii?Q?jtJXfp3FSHuM4EsEQJo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 510e2541-8e00-421b-9b79-08dc842b8599
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 00:16:04.0515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: egSYuTg6FS3J0nJaIwZUAvVBa3SzW5wv2+4TIxf3IdgqM2ttodtraiJEKEGh5PUF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6451

Currently the SVA domain is a naked struct iommu_domain, allocate a struct
arm_smmu_domain instead.

This is necessary to be able to use the struct arm_master_domain
mechanism.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 21 +++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 31 +++++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  2 ++
 3 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index d31caceb584984..aa033cd65adc5a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -639,7 +639,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	}
 
 	arm_smmu_make_sva_cd(&target, master, mm, bond->smmu_mn->cd->asid);
-	ret = arm_smmu_set_pasid(master, NULL, id, &target);
+	ret = arm_smmu_set_pasid(master, to_smmu_domain(domain), id, &target);
 	if (ret) {
 		list_del(&bond->list);
 		arm_smmu_mmu_notifier_put(bond->smmu_mn);
@@ -653,7 +653,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 
 static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
 {
-	kfree(domain);
+	kfree(to_smmu_domain(domain));
 }
 
 static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
@@ -664,13 +664,16 @@ static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
 struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 					       struct mm_struct *mm)
 {
-	struct iommu_domain *domain;
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_device *smmu = master->smmu;
+	struct arm_smmu_domain *smmu_domain;
 
-	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
-	if (!domain)
-		return ERR_PTR(-ENOMEM);
-	domain->type = IOMMU_DOMAIN_SVA;
-	domain->ops = &arm_smmu_sva_domain_ops;
+	smmu_domain = arm_smmu_domain_alloc();
+	if (IS_ERR(smmu_domain))
+		return ERR_CAST(smmu_domain);
+	smmu_domain->domain.type = IOMMU_DOMAIN_SVA;
+	smmu_domain->domain.ops = &arm_smmu_sva_domain_ops;
+	smmu_domain->smmu = smmu;
 
-	return domain;
+	return &smmu_domain->domain;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 56e2fe52df530d..c6dba933d2c38c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2272,6 +2272,22 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 	}
 }
 
+struct arm_smmu_domain *arm_smmu_domain_alloc(void)
+{
+	struct arm_smmu_domain *smmu_domain;
+
+	smmu_domain = kzalloc(sizeof(*smmu_domain), GFP_KERNEL);
+	if (!smmu_domain)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_init(&smmu_domain->init_mutex);
+	INIT_LIST_HEAD(&smmu_domain->devices);
+	spin_lock_init(&smmu_domain->devices_lock);
+	INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
+
+	return smmu_domain;
+}
+
 static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 {
 	struct arm_smmu_domain *smmu_domain;
@@ -2281,14 +2297,9 @@ static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 	 * We can't really do anything meaningful until we've added a
 	 * master.
 	 */
-	smmu_domain = kzalloc(sizeof(*smmu_domain), GFP_KERNEL);
-	if (!smmu_domain)
-		return ERR_PTR(-ENOMEM);
-
-	mutex_init(&smmu_domain->init_mutex);
-	INIT_LIST_HEAD(&smmu_domain->devices);
-	spin_lock_init(&smmu_domain->devices_lock);
-	INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
+	smmu_domain = arm_smmu_domain_alloc();
+	if (IS_ERR(smmu_domain))
+		return ERR_CAST(smmu_domain);
 
 	if (dev) {
 		struct arm_smmu_master *master = dev_iommu_priv_get(dev);
@@ -2303,7 +2314,7 @@ static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 	return &smmu_domain->domain;
 }
 
-static void arm_smmu_domain_free(struct iommu_domain *domain)
+static void arm_smmu_domain_free_paging(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
@@ -3306,7 +3317,7 @@ static struct iommu_ops arm_smmu_ops = {
 		.iotlb_sync		= arm_smmu_iotlb_sync,
 		.iova_to_phys		= arm_smmu_iova_to_phys,
 		.enable_nesting		= arm_smmu_enable_nesting,
-		.free			= arm_smmu_domain_free,
+		.free			= arm_smmu_domain_free_paging,
 	}
 };
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 65b75dbfd15914..212c18c70fa03e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -790,6 +790,8 @@ static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 
+struct arm_smmu_domain *arm_smmu_domain_alloc(void);
+
 void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid);
-- 
2.45.2


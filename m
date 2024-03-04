Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A087D077;
	Mon,  4 Mar 2024 23:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595875; cv=fail; b=YnoHutL28PgKi92DLYEDWKtRW0PypIwvT/saAdNZsvprDdcHkyzSObR1ESMgIy8Grg5KnPOt2T8guurR2gf1kMOl4usa572Y0+QWLM8Jexpu2vOW1Funerukdfq3n3E/SwknUfqU9GQdlUEHyu9SEDH4Gpgu609cY54AlIMoW2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595875; c=relaxed/simple;
	bh=Z4dWu97NNP7GrWmlCkLRAg8hsV5pGgffzz6pZPOzR88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Irlri2ytSAqbnQOUt7bF/ugB6CvS4yBgMSTVhnNITxzaRCWGSNcW8rirCADEki3BOpdBtmCnKUf5ZJ50eTwzkCZSNO7UMlXpkgFAd2/F8OuCMdsrkBWWxI6cvD+bSp8/qTC74k5rM2YiloaO4kRWSFDpgKgtk0J0Oz/bcPYDNQU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TgRznU/W; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TgRznU/W"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L7LGR0rh2fCpUj5KqlCNy8zNZtnV7puKxEN8ATcN8+lOqm507GhU4BXz3NyBOL65VW027sAOMfbyV/frIrK2qAq+6FBOrn7g7OcZ/amGoYdGZ0LtXxET6YNiso/uDXyPaeUalnL8PW1/QIYsr3HukXWNZwyFPu0B3TAyncqgS5uH1Py1b6EkpNh6CfKbR52q4ByOY/RMb0dKMqL6YK9YHqR/oTuUArwW/AVIwOvbssbGUxZkdoIKZrJFMgmB0i4RpDaiv5WwPFhAuo/+JJsuz62j6HKnGHpFPnUmZ+v6ZtkDscKebwuErBJ/5K79jZfrP3tKcmcn0iviC2Jk5wZniA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=btf4O+ezGIzXfytAvcnJywIDvOCH5fzF02YGRUrxWkg=;
 b=ezfDdRyvu8oT5aC7pJ7Fyi3KOkBc9KeTdpgOkb9kvtT6tunz1SNurhXvyFA1isf2ppLAPZknramEW1F3ZCE6rohLMGDFMSvPLlMXjRxmBsOMT2V3F0x0ObsIAaAftK+3QEzSr8hUkVbXH5nNVrTzgeCx92u5pbDGsTwkNZmUgY9ZoNiparsmei8hAhL7cWqTEJzcMY/e+yAgDbxQNhQD1q/109BlLeQvrWV+z8FizUJy6LzVhqvFCia9kfsdLvrgikyKvkwZAPTF4L7KaENm7NtMQpgBB+5hDeJOqDKpGP6jSz8IatJP1qQu5Mfvkj4xSUsJdFSO6bzm4ulLNdzFuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=btf4O+ezGIzXfytAvcnJywIDvOCH5fzF02YGRUrxWkg=;
 b=TgRznU/WSnfs8Yx5sV1U/ehUqbd+msbo/sZgxUFrS3/bn3PtD1qe2XkqSfRK2G0ImUCfLdrlznzjDzyXkILbuf/wacAewco4EAudY6tjZAyUZviHg4TbQhGloKBR4MTzqmFOvXHrqa47FKQzOIBsHhpMxmQ0SdPa/p1rX/0rMiXNMcNIWyHM70rXg5kQPsDQsfi2yTn6Gd016L6I0uP0ysG+caqKMjF/PXbgftTv3SwkNpG2e75ZO/j5issAdpT+ErElt0d0G8vYQ4xhMdBrDp5RIOOV45Dx/wf+rDlRWbCNKSJSl9tGAd8PB9U8VjX8afgEqtG2pzHhotziaCsqLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.39; Mon, 4 Mar 2024 23:44:24 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:24 +0000
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
Subject: [PATCH v5 02/27] iommu/arm-smmu-v3: Do not ATC invalidate the entire domain
Date: Mon,  4 Mar 2024 19:43:50 -0400
Message-ID: <2-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00013DF7.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:9) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: 22707f70-d680-4b62-c53e-08dc3ca501a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	kiybZkTD8SMZ4LWLTQqk9lnPtu+HR6Ge2T5yWbbCAwiTJBKMkYL3vYcD+ZWXpx8b9S3uRRGnJA4Iz1uwzaCpabmSmcjsVJYZKqp94yh3wDZtEkPmpArjZRNT8CV1hMuqWgHFh38J6jI1lAe5AB6uuyqHlYUxpoCqLY3SoxriNv6IEgLwEl2a12PFyZd8pR0Rt9G9txplUgobuNCem43OOhaYNkD+6dv2zSMhDI3RkjYRsQwlozoiH8V6Cdf8+s+g7+u64cuUDodpXWoGyHFjTGdYKDZ53NoAVprY9KmiWDi2q8BjXc2FP740L71r9IQ2/F7USx/bgSJnPHtWwC3jEcsezDmZQ5E9lefBSZwmZU7AE5xJmVlOMVkYdOEmrliTCABsRaDYHY8THDuFoJbCX1zgfGY9/hMZX8cYbglnrCKGo37/zEYx674HXabmiWe5rQFOb67T5SapXnElp5CDCP5Bm52TsVLeG0q1FL9BmbwZfpKiGaMxHxwvmMU638JFdN/aCQQDRNBakAIVEuVxhcqXXiUytI4k5MKFSdGLb+k5LaBuuAh39nOKSCvNknuniu959IDQYVdSAz8Hrl6ys4EAEKcf1HCgmI1RwnaARJ2HAgdQ1iZyNP2QBIoNqk0xu2d4t3FiFw4P+dydWObn11PVKkk9+AYhDoK6nF1q5EM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VPOrc/5gkmZxSpm+ln1/xqjImqeXWOeXn6uMkaCzVzbmtmpUSVxLUS0uClSm?=
 =?us-ascii?Q?CGUlPpOWGj/PY9ajEhvv3BlLboLdN1YYo0Lsmwo13KpCC9os5YPAhgRAKzez?=
 =?us-ascii?Q?IHZCpB0YWrCn38s5KFnOTmGPvbmTLMYbiurCTFnKolG5i8+HPcukWswwKkxg?=
 =?us-ascii?Q?Q8/s9vOdg5dFrC6Xk6cn4wCCTQLUmryyxPNDPlUhNS/1QgPj7K63broXnQoG?=
 =?us-ascii?Q?GymTBeo1Nm9vsQfmVO0t2rJDg2TWi5aATTiZJEFu5CqV0jQtOTutRcvQ3/HP?=
 =?us-ascii?Q?wSMgOaUbyMoYLczPX4nGWNiLQp4ddTRYyk063UIFkFzQTWvXq2ykRl0M20Ux?=
 =?us-ascii?Q?zI8+DK8dHEviRNca5zdxFs+6idJ1pmW+zqCV9ZP50wou2wgWP0pVeR2pHFqk?=
 =?us-ascii?Q?ApcltiOXeJ2xBmW//KLxRN3vF+VpCQrd+qghINQIf5cru6jaU1nLDkZ4XQ+R?=
 =?us-ascii?Q?R32JDX2gXKJUf4ECay1iCfaAPgQJzxLM0vV47yTGrxt64GRmojQwC5Pj1/Oe?=
 =?us-ascii?Q?6le+FRFbXYYuaWOnKDjDMun7u2VcVicdRBiW6byty5+JDQwVCXS1j5RC2rPN?=
 =?us-ascii?Q?KjvHSZRTTunaEP2kPqMTHxpjmq0zt9q1RJiMZ5bscR4KtcAlj7cfZi/+erao?=
 =?us-ascii?Q?FDf6jl6jcHnzQpj2LZeCdXYrrOriHuuFdCRa46oa2Ve3oJgaZB8ryOafcJCs?=
 =?us-ascii?Q?4r6eF8ZjwbnNeb1Hpns1E1svRL4SaMPapHQM9y1Dv/Ae1ooMPB59CSiwiT79?=
 =?us-ascii?Q?Z7nqz8sl/mvdTVPMY2O5fBsMwDUA1EXO+YX1wS4KiS880s+ZKNygtZ91BcmJ?=
 =?us-ascii?Q?JfQT873SuXoj3H+nJYwQjURBwlzPLQrmczsDeGwiG4j251ltEPHXVAoy9aT4?=
 =?us-ascii?Q?56aO3G6ULKRUOWbPnKWODokFbcHI9Cf02VxpLzqazMy0O4BVYwndll5tBbdh?=
 =?us-ascii?Q?ptFFjTnSSh5t/RWcTdfgkfGDTOeTu6r6f+7e3q3+Yzbr/zQWroPxUBwM2uU1?=
 =?us-ascii?Q?t+aruZAzozcbsoMAeSlP7HIBC8znCDS7rrdmShU5lC3oJqqpaqVxSN2duT0T?=
 =?us-ascii?Q?BuyokZ2smrSvWLEdBVo1hnBjQU8y/xQoUJyIuIol2HAEXl9cdxRGijaziNnN?=
 =?us-ascii?Q?dyyCTAFixJ1Hyig2BonIJWtT9z4HCjZm8WagViW4IgWk3B0tbTJPYhcm9JgK?=
 =?us-ascii?Q?HK72X66No2c/EHVWQUnq/PgzTwD1XC/BmjdMjAxzkXgCf4OJlb0VGa92AESf?=
 =?us-ascii?Q?BWtmT2ErzoW1JdC53B4gbx1bUo/1HPqeyRpENIUVgLF8mQIWOuayEHt4chYx?=
 =?us-ascii?Q?d/c0kZAtHAppFP7j3QTAfM0D5jaJgRwQxP2A5dBlsNCGOVTd0hTQ2V2c2S7O?=
 =?us-ascii?Q?d7SAKEidWRQoHFmjYGh1PE1fGe/YMUoORpcb1cWnCAaZysi5K/ZlBa7/i9rg?=
 =?us-ascii?Q?hVeTfoeFDKcCGDZvIZTIX6WL+Z3j1e9pDURFnMCCLV3w8ZOx2xJNNrA7QiUU?=
 =?us-ascii?Q?bg3W6kdTavxdJBcgwQFh9TanKsd1Hpu/f8s4xmvBLsGkwWaVU/0ciU8k3Kn9?=
 =?us-ascii?Q?ZcOr0GoPvY/U0tvdmqO3DCzeNeXr5bOkMcfW56GG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22707f70-d680-4b62-c53e-08dc3ca501a3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:17.5423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mlFaSGPUBM5kJOxYpsqMZEdWvZ4IehpcrbkrlSzokQV/9hLStgdTYz8/eGErh+Fo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584

At this point we know which master we are going to change the PCI config
on, this is the only device we need to invalidate. Switch
arm_smmu_atc_inv_domain() for arm_smmu_atc_inv_master().

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index d1bc151a5dff8c..9e9233331c4636 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2447,7 +2447,10 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master,
 	pdev = to_pci_dev(master->dev);
 
 	atomic_inc(&smmu_domain->nr_ats_masters);
-	arm_smmu_atc_inv_domain(smmu_domain, IOMMU_NO_PASID, 0, 0);
+	/*
+	 * ATC invalidation of PASID 0 causes the entire ATC to be flushed.
+	 */
+	arm_smmu_atc_inv_master(master);
 	if (pci_enable_ats(pdev, stu))
 		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
 }
-- 
2.43.2


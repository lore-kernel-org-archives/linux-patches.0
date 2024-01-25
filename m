Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349351B271;
	Thu, 25 Jan 2024 23:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706227060; cv=fail; b=P3zllCeWghT9Fi8HOvfAK04CoNANqPN20rwN0anMkcXgyEsaQhGVm5ARevDiHx7zvdQxMm3sRGpL9UAqEYrAtyZ3YRi4agJV9QKM5Ra7wTXEsaCrzo0lHneM98Q/KcRfuEm4DPtsL0Em6gy8IK2eLTRxydEEb+Qxax09gdesL2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706227060; c=relaxed/simple;
	bh=kP1U7dIf9g20ONdwcWwNMXqS5CDJ6Nc599gAz5+8Diw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DPUQfHTUqr1u3lCfQ6EIFyDfnd6VIOQc3Cvbi9HwEStDrpUS706zc/uL5JqPaEdCytIGku44zu3mKa0a9Szj+4nRurQVssaraS/to3n2FfnrNe6GFAFMo7SPTIVxfzHLRgw1zIBWM5qEwR7MVSxWkV2YhTJzMdQFkycHgvgkX2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jS10kkm+; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jS10kkm+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MXY4nykbNiPKEj5BbADN9rln6frw5ciH5JhaUKTyzsMCTT8WzxopmHh7B86Sgw242uZJ5uqfdB09aRSMaHIY6wc2FByxuM6t+YPO5l5ysito/GhP9COf9+qCh5IitQU8eiEhqGE/wCcyZ9FYs17PyMs8kYROJHNFV7zfFN0QIgoz4sDEt2tbJzzWqsiyNQmVJBO1mxhBNeTUGrI1pCLXOztldS+FswHKDEhMUDbD0uZqeOwp5uCeIZYv2bxZ/IOtEN+ZjbauXqm6gCUaJD4pBipzXFCinc9FUSVk6qDUG1q5dCiikuaWa0Zj35gVHo70jV9pRpUhFTL1rdxZmrG5kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qUIo70xMoe/CTlD43Aki+vweDYpRAfW5ag4DdmCUQUI=;
 b=e+HsScIMDu3bE8xSaKQaP9Nv/1qHcDaUVh04GAYfgUZ1CErm4zEbN7wLkE+1bEyQbe9ceKw5iT89FnBaFjca6hAnmVnjN2PJvF9nBE1YUqwncq7r2BRwCzKLfvBpuo0Zj7kWMgwUhbrd984yze4wxe+qz0bFB7Pgh0ykLZUUds+QVyOPn/gL+syOys/RF++nSSARnq1ZwPXzHrlXXUK9pN1/XC0fG0ArDHEjuW3t27snA2ZgfoDCC3LGI/qowwGL63T51J/AYE2jmbP+uGX43/7S/knaHcNjRXUM/muqbCBdlS21O3Eh3PvJJSUD/1G9jRIswfcGYTx2CcuPk5pqXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qUIo70xMoe/CTlD43Aki+vweDYpRAfW5ag4DdmCUQUI=;
 b=jS10kkm+ntaLhTok9A4+raIyv5AMgNhyerjix9XT6XsiBXfXPC5MtDNgeTdDi3FbUdjGGawICkM540ogObmpqvjIfVKZ+ieFLZFnmE0PxgkAZkb6ahKngNgaOa7ccvHdBCIT6DnqokjrFHh+80U+7gxVxJgjULwFzhFBL1y+ECAX6woxzbR5IWYamAPI007s2n0TCxnov3lsHdZ2UY0dgBAvTRfMMOIjOKpCoxaZObVEBP6Fy+hZ22v6MMBz4KAlTuVw3q9Bpv0jsl8ATYw9g/iYjXoAQ6tuLaR3Ei2vwdPPz4OxwgKMcnp7CNcSuEnxv3e4u56pruh6SY7h0YoJdg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB7038.namprd12.prod.outlook.com (2603:10b6:806:24d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Thu, 25 Jan
 2024 23:57:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Thu, 25 Jan 2024
 23:57:31 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v4 08/16] iommu/arm-smmu-v3: Do not change the STE twice during arm_smmu_attach_dev()
Date: Thu, 25 Jan 2024 19:57:18 -0400
Message-ID: <8-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0049.namprd05.prod.outlook.com
 (2603:10b6:803:41::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB7038:EE_
X-MS-Office365-Filtering-Correlation-Id: 5486c598-e209-49a1-103e-08dc1e0162f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	q5ai+KuqoZJzrdxdwLbZeE6hD3TrF+uorhnswDOgk5AmRGTc1Vo9Fizm/6cW+sbTC/Afp721pkhxRR9t05xwQI8eP7qs0g+JWRQkoyZ8/h1bTgo3r7C1RMK/STT5WwU/wqzB34MFm6ZAMwTFBoFV9s1eL3Uw4HyPDnQUQzbN01PbEsn+sBfr4INdxR8VZDCakYX05s3+htlvdRmGK06XDtPdPStROKWR3m7AJf+cK7CChS1rp0/Z9slKUBRvXCA1CUE1Tvir8HeyfRWJUPTbtF0Dho4yJp6l101uy5cliGaJJNXwQqrB9wvaMVSv1Bl0XLvLmJ3tPRYOOhEHuXIRkxGyQBQDUh8Pq9dMHcLVnTgxCH1DY2QFWQb8OCov4BXl93DYhjsexgbp5C/5j6s8HAYZdKZIj1bIVs0XP4G2J7c+s6/HHniD9Bxj5LII/nsgGplxBnVjDkF3usdRo85NkTwCpDHL/q5JiDhIyRnmZ/dQazqZtKBL1DEP0RLg77nYvo55LGea2EsHhtkDw6Ogm30EgBTzQ3VLy9gym9DRtARQSG3v5t2HAjDMD5s8nl3YWkMx58bBONeIYA2Qx4Sa1icoHjPpzP8bLZ15Rm322+c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(136003)(396003)(366004)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(66556008)(54906003)(66476007)(5660300002)(316002)(66946007)(8676002)(26005)(6666004)(4326008)(8936002)(2616005)(110136005)(7416002)(6512007)(83380400001)(2906002)(6506007)(478600001)(86362001)(36756003)(41300700001)(38100700002)(6486002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ACEu1furYA2yvt527K2Q6cn3RhPekJOewn6hSw6cIcGWl3sB+unxHEZAhquS?=
 =?us-ascii?Q?8u/AVndHcHtjK7uBZJ47NuFiBGt/R+RGpoYogF+MubWZ8YuPsaOrNUgDyXTn?=
 =?us-ascii?Q?Qfw5hHw2bWeMifPfcPc24Vys5e7Unu09Eb//WCclD7itQYx7XBA7SG/RH1Op?=
 =?us-ascii?Q?IbxsHonKf9B/3wIFnW7ZzUF+GmfqPmPEYFe/YJY0TZxqnM9kd08D+3425Pqs?=
 =?us-ascii?Q?wm05uxyh2+EfNNLD9GRKHRj9XiGl4LNJ+sZyvcEtLYh/b+5JMf37I9cEO2Vs?=
 =?us-ascii?Q?SPJqzdi7CnaqLRB8IFx/oqEFEsr/TFSBmj2RRz30oyuuNjw69VVj20XhFcvh?=
 =?us-ascii?Q?96na/nN+2WSwMxMjyu1Dsp+3CHLtuNzVII2mt5i8eICxBjlTxCIzztY8NB7j?=
 =?us-ascii?Q?vnH6nE/I60NBvhOGFcP+xuwFSfS8wnA9YroMyn1f8mx31bp4I3F3cFMGn8ew?=
 =?us-ascii?Q?yq0t99m1/Fh8FgTByFol++blKLG1zhSUGnUkJ9GqKl/V+6SSeozcvl5tZ4PZ?=
 =?us-ascii?Q?PzZrSnYUegvp9I1zEOLJVEgIipOYtlB1Y/fQgon+PepAVE3NwIPUeGFJ2GT6?=
 =?us-ascii?Q?3xt+MjDJtbHVoa36zDiCX6BF3ofIpJPJ8MTq26AXd3o9eef1ndHhZ/WiIyFa?=
 =?us-ascii?Q?gO069F96X9HKOeP2vDE4x8KEIZa3ANqnUEaSrne7ns2rI/6Cb4NbMXffQSaV?=
 =?us-ascii?Q?Fp0V/z2Pc59LRXn6x9O4wgANKsiXQEf9J0vy6sOq6T8Kb29ISKVpt5oHgvEH?=
 =?us-ascii?Q?WEAPYE0z2cdpi+/gbZB1G6t9/p84gLINsstbdkNzQk5ktuYvOJq4Q9K/MUGK?=
 =?us-ascii?Q?HqQiTAfurTp9wYOQRAoacUj3mHk+0mzmt98IXEwmmQwwX7aI4aplvPEqYnB/?=
 =?us-ascii?Q?6cmowWbLwzjAmU5iOBmnMh+wkGLgrTTnNyR5yOrc9fQ4D5Sx6GQwlr7RkXkV?=
 =?us-ascii?Q?8leGnZ4+zJT8FNcY4XczRkrLuT0pHbSvmQ7CEPTl7uy2b5ZdmiMUoDbqpJM6?=
 =?us-ascii?Q?aFPX34k+cVqzDrYdHp0RxIqxbymOUFQE2sW1LGYDbU4rHYt3KczXzVuMR+Yj?=
 =?us-ascii?Q?gwSO7XweGzRwyrbqdKqNahklu16tBJ5luo8KsnDZ1Vs8eXnLzlfGGMc8CE92?=
 =?us-ascii?Q?FSw/1trL2eSCkbqgTbDWm8Gln+/tvU7nlsSeXaWObm5YXqUYvo4/G2hqV1H2?=
 =?us-ascii?Q?SXyr8OCzItswzepVPKuOpOoSSUDWYwdxvsjvW5JPNz9IVOtkJo5+xzWpChwD?=
 =?us-ascii?Q?xTo5+1xl0voH/T7zket/Ppk/juv1hUkHsoC2By1xSfQHrIpszqFAXT2lqG9s?=
 =?us-ascii?Q?GHa9vxoc3ljK5wza3zBqhQtXLWwf7/oGSnb8IJYedoCroLSBDBqK3iThcasR?=
 =?us-ascii?Q?kw0SQTIDVNZuUj1nOWJx2dCG6+1t35jT80J9NMNjz0uyaseTwOaH4GeqNI2W?=
 =?us-ascii?Q?kxz2YKe81A7QwEgcCqCRuZ7hekSzsVXrTAiM+vKWYU7YLVBulnFy06DrbpUQ?=
 =?us-ascii?Q?jhQWwY2p2th2RqTDoaS1yALspEHdKKrOGgYJi2oV4jy/3j7zWEuPI03DTKvL?=
 =?us-ascii?Q?adr+IL3noUQxkX+UHX25ZR+xtEcoozMIch8kw21T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5486c598-e209-49a1-103e-08dc1e0162f6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 23:57:28.4817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cCHqHOUHdJJfOnjEru2d5ENOJnysoWe0cCOPQRUrZawtowOgV7NbKTXtUcrdp5aj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7038

This was needed because the STE code required the STE to be in
ABORT/BYPASS inorder to program a cdtable or S2 STE. Now that the STE code
can automatically handle all transitions we can remove this step
from the attach_dev flow.

A few small bugs exist because of this:

1) If the core code does BLOCKED -> UNMANAGED with disable_bypass=false
   then there will be a moment where the STE points at BYPASS. Since
   this can be done by VFIO/IOMMUFD it is a small security race.

2) If the core code does IDENTITY -> DMA then any IOMMU_RESV_DIRECT
   regions will temporarily become BLOCKED. We'd like drivers to
   work in a way that allows IOMMU_RESV_DIRECT to be continuously
   functional during these transitions.

Make arm_smmu_release_device() put the STE back to the correct
ABORT/BYPASS setting. Fix a bug where a IOMMU_RESV_DIRECT was ignored on
this path.

As noted before the reordering of the linked list/STE/CD changes is OK
against concurrent arm_smmu_share_asid() because of the
arm_smmu_asid_lock.

Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index cf3e348cb9abe1..bf5698643afc50 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2535,7 +2535,6 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 {
 	unsigned long flags;
-	struct arm_smmu_ste target;
 	struct arm_smmu_domain *smmu_domain = master->domain;
 
 	if (!smmu_domain)
@@ -2549,11 +2548,6 @@ static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 
 	master->domain = NULL;
 	master->ats_enabled = false;
-	if (disable_bypass)
-		arm_smmu_make_abort_ste(&target);
-	else
-		arm_smmu_make_bypass_ste(&target);
-	arm_smmu_install_ste_for_dev(master, &target);
 	/*
 	 * Clearing the CD entry isn't strictly required to detach the domain
 	 * since the table is uninstalled anyway, but it helps avoid confusion
@@ -2901,9 +2895,18 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 static void arm_smmu_release_device(struct device *dev)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_ste target;
 
 	if (WARN_ON(arm_smmu_master_sva_enabled(master)))
 		iopf_queue_remove_device(master->smmu->evtq.iopf, dev);
+
+	/* Put the STE back to what arm_smmu_init_strtab() sets */
+	if (disable_bypass && !dev->iommu->require_direct)
+		arm_smmu_make_abort_ste(&target);
+	else
+		arm_smmu_make_bypass_ste(&target);
+	arm_smmu_install_ste_for_dev(master, &target);
+
 	arm_smmu_detach_dev(master);
 	arm_smmu_disable_pasid(master);
 	arm_smmu_remove_master(master);
-- 
2.43.0


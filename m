Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830DB193;
	Fri, 30 Aug 2024 00:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724976398; cv=fail; b=fae3k+/nlVJLw6Uivlnt0miYQbNVoRgBUqtEQyzMkcWH/buFkc4haCEEXVyhgDBUUFjSnNcZuNcyhLKRMJCmfvjpbrlwyQ3saAapvvngGOuME732HZrkrEoqcfdMquAh24DDgoiXcQ+jodiPC/IIWKX3RN31Wy5zEcbzZc9rdms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724976398; c=relaxed/simple;
	bh=EAcIly/cRj9c3FNC8hO4U9aWZKp29HOn+iCIQVg0Xhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QWS0EMPZZgDPEIA92tjCpNSbDwtCZgsa6jpslIrwz9sRZKjWbjie7yQbiwd7CdVRAmN7ddbiAvpGEYuXhiA9DuMk5RnyYm4gepT1kD3g3oWFSelFMaWo31+BFiLuhBY4QctLOpr4eZi5hu4oYF629dD9kL14AklmyyTT+IubmB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JLBDrFhU; arc=fail smtp.client-ip=40.107.243.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JLBDrFhU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SInEhiRp4bu0xwfMGg9MPBkv2axXhwrT/b3wYBsmniZ9OXesz8MZ4hjeLiDoYQc7dr7RClv0iKr+Q3MmPNrkw5Y7+Cw1ztRGGH7qWJNLFqnUovqiBXoUbrTNowbC2sp1yH8wisuPcCYojXuTRIiGeFO4FzDINU3eiubbdn8G3abl5/t8eYsBo9fq75MfBv5eOKtPSMjc2EoFZMa73IYOwNiDfjbAxy3ZJ3psXRYHnRnkZvfB0ZnHvfWgCF7oQX/HCHnayIMaIz1PLrPqxUJ+VdqkejEpGQcedB3nCmlxTHt/REMmvgRv4z5gWb85Eyf9WWrotMrjRaiCnvnYbrgElg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qBdOIhOycjYzf/pwjgATyd0rXpPhi7s//Up3h73wT7c=;
 b=V0/iee4+EKtiQFLVn8wqHWApP/36BJq+U/dvYt+zi3AhW8QWxq/AryI+Ep47fX+1qa/GF/mBlpCXrMajYkwLSV8452L6XKdaaUAwK0iDxTeznCVE6FdMyN4kK1XxdrK1pLE7kgOBZcDbboifvtgUMZkROvw0oR1FUSKjmgQ9M9NW8UpIeAUNnhdwcOWZYeQ5r4hWHRvswJ8BH0pkCAcdlmLDi4Q6sUh7HsWmeE38TZc4ZfqSXITqQkulgx9k6onIw+GMto2n8w+gLobUuBeIIM/lICBMhI/HpAd6hnJrE95BFh/DL/u/YuS7FUHkhhDoXspreZfusIrnFHJ/EwvGNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qBdOIhOycjYzf/pwjgATyd0rXpPhi7s//Up3h73wT7c=;
 b=JLBDrFhUQ/fXr8AmgQM3X0olZc0wDTwh74V42/BCsEgvpXyt1MIDDXfL1m6OO7Q2MjwNN4eBmtRrhUMH8DwiMZSMvrEsxDOK5rvaGTqrwCMXMRrNj3M56QjdjC3IXXqSRZ6Hph0P6EKRsAIY3anBNqjMeMND/Ct/q+k0F9Q/vgADg1JTtVORjZJtiEolBu8nm1SxzhTlSBibSU+iKWLkBC2Gkb96LIYLCyZymUz1mp3YOumtm9mNVV4MNEUuactuVYPo8rN5kWG0FMvKw2wnd616uXbEVwSjIdVwVHIMINECWMFvc3Ek1zd0hTVjRpBc7EkYsqLXfgIh/X6lUywlAQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH8PR12MB8431.namprd12.prod.outlook.com (2603:10b6:510:25a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 00:06:29 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 00:06:29 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Joerg Roedel <jroedel@suse.de>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH v2 10/14] iommu/amd: Remove conditions from domain free paths
Date: Thu, 29 Aug 2024 21:06:19 -0300
Message-ID: <10-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
In-Reply-To: <0-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0781.namprd03.prod.outlook.com
 (2603:10b6:408:13f::6) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH8PR12MB8431:EE_
X-MS-Office365-Filtering-Correlation-Id: db057e7c-9b24-42ba-4280-08dcc8879639
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?757i7oV2Kd2s6swkS4jQ0TYobG8g+py+PpiFFjvmFKtJWT6d/qSYVSTXzxzB?=
 =?us-ascii?Q?Mj5UqztQPDScH9S5Z2lnlNGDIBn1OYqaTjeqbPs0ThZ8IqrGZ6Aa8/9lVLKp?=
 =?us-ascii?Q?nZdfFO7KddUBXdi1NOZCgDl4UdqEaH+mMvFk0Wwt1K9F6UHi7MfxVSKOTWQ6?=
 =?us-ascii?Q?nP1U8yucruRkWh3l6BjSd1xwimH78oBO5RGO9CMWVjIGtl7sYAW4a/STnmH2?=
 =?us-ascii?Q?eCV2yO1qF1BTWgDaFMtr5nFer7Au/p7LcVjvIQvcDzzmXR0xisT/S2t+oWAQ?=
 =?us-ascii?Q?612ODk0kRIU5i/xCqNOg5ZP3XhxboIIMxCAIkJRiJtsqz1OErpB6ILHsTE4q?=
 =?us-ascii?Q?ja9aie7DPVMvWGoI0bcdHKA6YOr2P/G/pVnKqpE/nx3t1mF9WfieqScPotRx?=
 =?us-ascii?Q?oiAFKAjXwFdvDzz/4eAOYftVoHTMdkSLyJoeFNGQbiz2UPHXMCP5HninfQAF?=
 =?us-ascii?Q?HCY0p8lrtEP9rhCVuBTq2uD3+/y2GOAKYauAUqaGBevgWhuMwWPrQnw1xjDd?=
 =?us-ascii?Q?HzmUGinc60FFVg051D+vtsfN7NccjCQrSkEGB2prct+lpb1jl4ueVcYAJXv+?=
 =?us-ascii?Q?3cLBYKxpTFoE1ZAeGYRgPUUmFyyA3Mr7fj0VaFSymWjfeV9YcUh9QyJSIgHc?=
 =?us-ascii?Q?PUX7VYtT9ENJZmJkP4Z1+6tTYiqBFZ/mrZaf080estBVQY5th5MkrauqP8Wl?=
 =?us-ascii?Q?00PV4pcs0TG2G/+3q/HC7zKIewY7F7Jomah9q1IiEDM/7TfEweMzRg3irdBE?=
 =?us-ascii?Q?T/38Ph05cyZtCdpc+FUgZ1C4gVuP1NXxhhjoWDHH9ckD+gdSq/uatcddtDPs?=
 =?us-ascii?Q?O3OvEQf/EkArKyPkUH+Xj+SFXc30vZbgPihbi8tp8HQzdtXER7hrT84DqY/0?=
 =?us-ascii?Q?20KWypknQQ18f4tTPVkR1aOrAAf7RRn6JIB/dAhAHh/cwL8ZjI/Tbmnmbk7r?=
 =?us-ascii?Q?q5mx0c1fhPrpIZydNXOI0VMJXDktsKzOMhxZZPHC0sG7XnLYjYfTjy2+mnlV?=
 =?us-ascii?Q?2OLcylvLBnH2lM6yZ3fqET/e66hi0XVu/XwfkgDOmM+sJJN4VGvatMHzbyj3?=
 =?us-ascii?Q?ZAeEdqfQgdkw0tCSfoJC7xRjyg7c+NLx0xcaxcctSkzh7zUDtMiiNSBBaJwO?=
 =?us-ascii?Q?3UH41L/ZYiUvGAIKxgTotMkF/CxC9W1PROLrg+phWwuDEyN1KhPPE0tEvu9S?=
 =?us-ascii?Q?sRhsHwDkuF89rIvc2kDCyoFInwrPGkpPkLacR/fFrBznc08Cjt+sYdbYts91?=
 =?us-ascii?Q?ZBIwFoEwkBCcLDP7prBMq9KcrniN9Yor4UbW+0g+IUigf8KlUMfGqAPs3kEt?=
 =?us-ascii?Q?RUUy/iXaYJZBRxN9rW3RXE2NlOTzRRF7UGixt4kvdvZx2g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n+EqZfm9UAj/ZT2f3PbZRBiGoaxqUUMcs1Qyh5SHZ9UTwns50ehmJF7bFoFg?=
 =?us-ascii?Q?vxWOPAGdzS8lQdSj/zLdEHiR46ZW0KCcdBBkFi8GOXy5ypc1SLL3OmBrJ/Al?=
 =?us-ascii?Q?HwHcxdekrJxknlZwqxGXOVcfha3vUmQtUayJf3L1yPwHH4Qjl6VGY6FebT+v?=
 =?us-ascii?Q?w5AW7sM3PpJdpkec1U9c/Lg7MmIQ+o+wvBKKZOKRKo/1DkTv3RYYIWe5lSV8?=
 =?us-ascii?Q?nmlOQqI2WksxIuh+TeqX3mQG/lYwvKWrBkMK1Zwdh3pXFmBChC8K9RN4iwJ7?=
 =?us-ascii?Q?E4owQgy66FjrxIyn435ziIY0urzmo3m92irZdKR6RS2JvUy8zHLcH69tRCn3?=
 =?us-ascii?Q?rTGH6dDSCOsZdRELV1VyYvXIRVZD8nKf21eV2GitSUv5ACFb702lQjL9uBze?=
 =?us-ascii?Q?+bagsOoupcLVlhV63colhgQ7Yhf8QWRoCszvx1vgmmjiU2FpwjS5ATfIZlue?=
 =?us-ascii?Q?clR86ag+vMcEVyh/cPICtWloIxO1NxXjo95i04u/BtvisPYSMZTrpPbmSqFx?=
 =?us-ascii?Q?CmQPvm1m6ZFlWALScEtTgoJw/svG4BlbYQKY7mWmDx6OKukfmgracerak8uJ?=
 =?us-ascii?Q?g2uGhxv5aSXWR3CICqOX5OQAGCEsXiE+PEtpTxFbpbhWeXk4H3awZ230gJLi?=
 =?us-ascii?Q?AEDxkIlRmR8KqrY9q/UqtRyBzjwVKhKwn0q+UFV7oRTr1xujL/IGKmCq0oPK?=
 =?us-ascii?Q?4vdSJMSjYUtbBJirLs+GIBnz5a2V0OfMZCp3zUv0y2tYuWZfJVhbm2+7KH+H?=
 =?us-ascii?Q?KYPQt5xgqsEF5irUcxT55qp6epDKRc7Hi7MakoBrvGA6+DmWgBD0LuL0WkCP?=
 =?us-ascii?Q?rVAVOuwoWrtKBgirYT+c2PGZqooF1z06qvBQ6eSOvcZ6vsGkXKe9jG+S+SJ9?=
 =?us-ascii?Q?8QQkVoIGnEo+x2JxOwKmHN8ZUoZpq8XrEMJmZPuyNq/uqLkh6D9wPg/9a04r?=
 =?us-ascii?Q?RKMagAyU0n0Fm+Q8oy8JQUm0p+IWxulPh/kU+r0OrtUrElCET0PDzPcfca+i?=
 =?us-ascii?Q?EiSQ2Oh8eMxrFr1trLffdl1l3N2uZxCg3EGlepf4oC5+fSV10a+bermf9QXL?=
 =?us-ascii?Q?4Hilhq1X54pXdMRrbGDI6ZVTfd4F+5LGW4vFVx+3Bs5wIfPAQf1/cycQ+Eov?=
 =?us-ascii?Q?knT2+cF9hPTyeiEgO6e6OV9dGocaLFD+S9LmOPtgXqy/ZM6R+Qe8rG5irlPu?=
 =?us-ascii?Q?TPNLo2uT2TgirDsnsH0fR8GoerrqF9cB1O7tPAnboW+3O9/mO8QrdeNTvAaD?=
 =?us-ascii?Q?zO24x213QIcQEvRJj4hWAZ35T3x7Yh5ZshjfTfC1SMO77SHU86s8CV53xnv3?=
 =?us-ascii?Q?0g4f4JtEKq0pFvwXr5BtNRj6H1g8d/0Li9n+SXF8VlAzfaTacIj//NIent4y?=
 =?us-ascii?Q?EcABOfSpuUjiu61jNlFnr3AzXTAnPVgWzXyluNCDVBPP9+Dr10rUbKvljsmE?=
 =?us-ascii?Q?UivbPQ78fwStF6rzQyAL+5F62iuKN4PPAnzo9cBuDrWjdIiTlriyfNQCv/dG?=
 =?us-ascii?Q?WjuRz/oE7HhKvXJYp0o5pzQAS1pwR07o27Ys8Ktiq9Fwm97T7Gtiy5a93X2h?=
 =?us-ascii?Q?800xPtatd/BSuHK6GRboqI8afb09acDn6zhcN6iG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db057e7c-9b24-42ba-4280-08dcc8879639
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 00:06:24.7126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: allRap+mtL9XUTTv3cgA6izOjGJkHsvsN8qObES9uhyYBz9Wk6OTHruy5qGxyaOi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8431

Don't use tlb as some flag to indicate if protection_domain_alloc()
completed. Have protection_domain_alloc() unwind itself in the normal
kernel style and require protection_domain_free() only be called on
successful results of protection_domain_alloc().

Also, the amd_iommu_domain_free() op is never called by the core code with
a NULL argument, so remove all the NULL tests as well.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 806156632bf70a..e23b7f7bf5b65d 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2258,17 +2258,9 @@ static void cleanup_domain(struct protection_domain *domain)
 
 void protection_domain_free(struct protection_domain *domain)
 {
-	if (!domain)
-		return;
-
 	WARN_ON(!list_empty(&domain->dev_list));
-
-	if (domain->iop.pgtbl.cfg.tlb)
-		free_io_pgtable_ops(&domain->iop.pgtbl.ops);
-
-	if (domain->id)
-		domain_id_free(domain->id);
-
+	free_io_pgtable_ops(&domain->iop.pgtbl.ops);
+	domain_id_free(domain->id);
 	kfree(domain);
 }
 
@@ -2284,7 +2276,7 @@ struct protection_domain *protection_domain_alloc(unsigned int type, int nid)
 
 	domain->id = domain_id_alloc();
 	if (!domain->id)
-		goto out_err;
+		goto err_free;
 
 	spin_lock_init(&domain->lock);
 	INIT_LIST_HEAD(&domain->dev_list);
@@ -2307,7 +2299,7 @@ struct protection_domain *protection_domain_alloc(unsigned int type, int nid)
 		pgtable = AMD_IOMMU_V1;
 		break;
 	default:
-		goto out_err;
+		goto err_id;
 	}
 
 	switch (pgtable) {
@@ -2318,17 +2310,19 @@ struct protection_domain *protection_domain_alloc(unsigned int type, int nid)
 		domain->pd_mode = PD_MODE_V2;
 		break;
 	default:
-		goto out_err;
+		goto err_id;
 	}
 
 	pgtbl_ops =
 		alloc_io_pgtable_ops(pgtable, &domain->iop.pgtbl.cfg, domain);
 	if (!pgtbl_ops)
-		goto out_err;
+		goto err_id;
 
 	return domain;
-out_err:
-	protection_domain_free(domain);
+err_id:
+	domain_id_free(domain->id);
+err_free:
+	kfree(domain);
 	return NULL;
 }
 
@@ -2417,9 +2411,6 @@ void amd_iommu_domain_free(struct iommu_domain *dom)
 	struct protection_domain *domain;
 	unsigned long flags;
 
-	if (!dom)
-		return;
-
 	domain = to_pdomain(dom);
 
 	spin_lock_irqsave(&domain->lock, flags);
-- 
2.46.0


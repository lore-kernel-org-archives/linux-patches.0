Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01D7442F;
	Tue, 11 Jun 2024 00:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065893; cv=fail; b=P9UXCvOHSWaRcDite+9m6CWkHLjx4Fn7FaZLR72wuCygshOgNz3NrzQTVHLQ+8uAoUBOPkgwQUfDAgWqF/5kbRghsEWsrtLJIwqw9d/Q9wGYiCXhZaoWSQITGbveUwMKKu6MCQ2/hEnvtByUPmhAa6VBMnuedXcGgNLdQHkJaXg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065893; c=relaxed/simple;
	bh=CuwYQeN/dOaQ8zWy2GC4CxXlY1TrZ3a0g7mY1Qo+arU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=l4PYR11zPE6yIP6qKFJLB/NznJUsDSpnTWe8BV+sBO9WZZmV/Im5FEvpKaG49zVyCxp0PlCENHwXKb/xk7Z313SqSH+l0SmJeaQJ8UMStIaIC1/yxhAFHk3cT9CA2MOJu741lBWvIzKcLLcrdsTs1EhFFaG9FEut2QcGkLgdXFU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Nc7UQQ4F; arc=fail smtp.client-ip=40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Nc7UQQ4F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bswq4Gf7lvVrW35i5obRzmIrj1nhAcdZbgF9Dk1xSpG4HEt6e5+vBJcFKQpJkXbWXxScJxd8gf22BfCD/FCW6BNp8r1wDUwDY2dxXA7V8/Zj6V3q6yiaLOA8r4XvCqEqBxCqZa6+pKbI5MTOrRxpFYKFq7RlGxri0mYajskxXfGa/U2BHz9V1jlE1jcrG48hePAvDKNGS0rL9JD0gzLTKH9vZFKYBdRcM4dFerCJb5ismtD5JRqAPxaD2+Fd+0pd6q3s6ePSBE/XMGSIGonShs7ttIa2Zk29PU9bMwjyBGOa6a477Df9Pf088qtOKHCwaMpRoXCdevI9vola6BgHBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oYTgEj35A0f91/EyyxlcXOxicqIPPwHiJLPWeuNG3E4=;
 b=aZOVKturi54bWsfOOJw6LaQbYgPkFcYFMVM6cSl4x7ZEt8YNkbkYPZ9fW/XlGIzRneBJ3qTRNwWhlq4ZW+nYBUxGUegxxMRAx2x9tZuNSQ1yBktguN0lkqw5LZWJnbTWaMPrIzIR1YdpDg3DqiK/iYich9aM9fAOPalz2hdOkzab6yHRDvSrjI+LR9/oZPDJGCXORLxhjzlfWrg7E0IXP9aID7tnpDjKyVvh3unFO/a1x/ZT4cX4pOQd6YQ4QS0PkwrkLbj6kYnVoIOCmX7YU+/xZQ/7jPz6D+8v4XWUfa7rSj4gOA3bGAhoAZLNygV7ld4obqC9GM7TF9M8XdTxpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oYTgEj35A0f91/EyyxlcXOxicqIPPwHiJLPWeuNG3E4=;
 b=Nc7UQQ4FgrFKuEWOee4SZnLc6+nResOLPjGeNQVlWUbhCIll4m98CTSDZlk303NukUPgEmbXNlp96vIRBV9RrNenzNJkgkhP2Me3I0qbO0xlSboZrmWcm+P4coS90ILjchM3n3yp1Om4CSQhy4GSjV9NTuMxjCqYQx9FZxmL6cDyMT7Io26PNK7WWzTjV+FT9I9VDycITi2b4k4XVQo/egDWhUToq1zOQ0/eFs33RLQxbjOgtwdFgPXh5EfbAWdSElYvOM17PqxQjnIVoWiMk6WLaLXbwIw5J5B4TqSDd8TAoZRu7YBJPdlQ0nPPw3Jvsxj+KAngfoNjvnnM+mOWzg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN6PR12MB8565.namprd12.prod.outlook.com (2603:10b6:208:47d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 00:31:25 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 00:31:25 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 01/10] iommu/arm-smmu-v3: Do not zero the strtab twice
Date: Mon, 10 Jun 2024 21:31:10 -0300
Message-ID: <1-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0449.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::34) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN6PR12MB8565:EE_
X-MS-Office365-Filtering-Correlation-Id: bb2680e8-9555-4fe0-c8e8-08dc89add16c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kpsLZ37GTlYpD1JQPy6osr7BCwcq4wGQUiFoO4btRzzh4ANUe6xME+mle8BP?=
 =?us-ascii?Q?cw2oA+b+SdV+X/T5Djy9AURYolWazT7UVwUXYl+cKMEmc1N46F4eWUB5APPR?=
 =?us-ascii?Q?+sr8FFAx/nb+ucxTXgWxtmp3tk6AmD6rW71tNaDjNiYBUv7LaGaOJoDrTil3?=
 =?us-ascii?Q?p04GdjqzlzWVVLHTed6QflUDJZ/7xi+xL5/yzI3AXs+qCuLUUpWzkp4QRBKt?=
 =?us-ascii?Q?NV0U7uYDg7WY5A3L5mdCS9emmnBtM2BU9AZy5v4kiriGwBMFv2d6dyHzCvWD?=
 =?us-ascii?Q?AG+eQdnAtot8AULrbXogsRhhfMvoAZi5mdSGYPco+E2Tcb8jqrqf8mQwLlUN?=
 =?us-ascii?Q?RTVYGkVMAXz69oLmnp9Z2UQhkFKLPZibliyiom7somUyfZBK+V3tbuYPvfuJ?=
 =?us-ascii?Q?JQNS6WfzleW+ArgIc7nrW/eAOjgfdZRFjxqPwff1HkVmkjh0cu6ryUlP8A6l?=
 =?us-ascii?Q?LTbSS5Apo4fBRRX6bg8mf6iMsQgHCBU5Rhi6QFnkS1rGIDs852atZkbrRi90?=
 =?us-ascii?Q?xw9Q+It9iKdKuy2EDfGhTTJRJYezavKyCX4D7WPtbrY8EH1xcleoDKx4wE4l?=
 =?us-ascii?Q?/z0Vn1qZdDYD/vEkREwiKw6RMQaE7ASiTUEKO4Hkg6FcNoJ3PhFWFmnoEVc1?=
 =?us-ascii?Q?CTRYymGUcvQlIERPwoQqdt6RGzpQ64KiQCKujFXQa/uFMEIercsGBU6BpC3I?=
 =?us-ascii?Q?0JIWizJyGc26h1alVHlyZSbBVoVhBwwiiRr4CsdCKjO+njPGNMyz63Cd9G0T?=
 =?us-ascii?Q?84e1GlDrrhbeDXQM+KRsRIWYQuq/RMgnyc7sYxC/wvRMcXeKS6UpimBAo7V+?=
 =?us-ascii?Q?OXVsTDJq5LGCQy0sy87Z96oQTPyKPwWM+no/pLyFlRlR2XArr3Wqyla9ffcr?=
 =?us-ascii?Q?kJNPdP86RZ2L2wQH6iYlXUphFZvW39Ix8I6bvQybpsD9/jCLR54xW8q2pOYl?=
 =?us-ascii?Q?naA+s2plqSJ+FWD4ReVHpKJDwUsxTumeWGwFpL0CzfqbECW87IrAiKfYc58q?=
 =?us-ascii?Q?4DBXHygNBhCh2M0gq7Ml3MA8/sqbq9sbsQ4WO7MmdgLvvNvh4YV4ZXAAuFyh?=
 =?us-ascii?Q?e7HFJ3ky1rPPWFoN6glUPgXTiPFDYpzoTXkcQ3r1tSSQG6Hw8Z7L/Clu+EWW?=
 =?us-ascii?Q?bd/C3ZYcW2Bq1WvESXbNTG/vuBIsrqLSP0F0hhB6H9gv3a9CdZpUnuYJ5p7A?=
 =?us-ascii?Q?WSMtJbhQagRwDnH3Dnw98vHwsTjsNkWkuWp91D99pE0EGhWrnh20OIUr3LYH?=
 =?us-ascii?Q?jhpXhQvm2utOmP/oMYTlS0h3MvH85OJIqEL1LrH9W1pYAh0Q4a4kQfLFou4c?=
 =?us-ascii?Q?S3m7vzRgGW27uUxsTmv8vI68?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t4bwxtTfByju3yksWZS0cmnaiCZPW9ulK3wFtVKMeMJMIEpQ+IBZShfImAp7?=
 =?us-ascii?Q?gpAnOI/yibJ/BuunAh4MuAknwx2qDGFRbuxttKS2m4BfASDuR8EG2KwvlYBl?=
 =?us-ascii?Q?drqaxy+7h5a9FvqL8yArfUvzLkMMJ4S765x8pI7M31o2upudopmzYYIuoL64?=
 =?us-ascii?Q?Gvf6Y2VMLe+CzNzhG0FByjTcUyxkcca5v4ULB3ARygWVqLM14TKTEHTvSLPr?=
 =?us-ascii?Q?3kXCnTJl/kXZ+zs34uX2ToFVl9au083L++DYHErZ/1bDh3azkbzWepGn+5am?=
 =?us-ascii?Q?1M8T0D4AQjI3cW2cAAAFmB87wYgjWBFNAv66CfsgKtcTFyjt4sQjLs8ozCha?=
 =?us-ascii?Q?ItzzonVSpHp99CU5RMUesHe6045ggdVmP3DqGQdhEr+GeggCYVn2AFBJUkuQ?=
 =?us-ascii?Q?F93wjuM8nt2+NpreRNTpsxxq82dKmgI+nnBjQLqbfbeUhNo8jaGcJ4FyTfkX?=
 =?us-ascii?Q?2eTaFXz2chcti45G8TXYlMI9/IM/ri0rJIukj/oikI7VraYSF3VxNvm5x6W2?=
 =?us-ascii?Q?c+g+InIM8bRnEyiv44X9VftrI0Haq5t2ySWkEmFmqCgFKhXq+ZV1PP6W2rRi?=
 =?us-ascii?Q?ujZdhfeNWGYcooj6/88TYIhqLN7HiHCDnjHWcWWh5Okd5aMIj3gO66kxWkwG?=
 =?us-ascii?Q?NwsDmFn9giwLxiC7PCgS6SR24olFq3zI0PXfXD1nk8Tf7PlBI0LSoGDDQNbE?=
 =?us-ascii?Q?dXGDz54Sq8LJZyF4Jq/C3yE4xzmvHq+CsRKox5hVOimP9Cmt7uEqP0XKl1Kr?=
 =?us-ascii?Q?O5at8YA58K2IB0pXqhzuH/x00OM1ZZocvtHFX6ntgsoauvg9+f8E/3iJryFw?=
 =?us-ascii?Q?BCUNBK2+ysxVdLPqg4PownJsO+EWmi/k+kwfOVw+gT1VG/zMz0jsaHO6rebu?=
 =?us-ascii?Q?phroDWFv9vZPQELy/Lx6pG2DXiiZ7jQF2X+O9xMg24hjAACIhaaSPoXuHLaa?=
 =?us-ascii?Q?sIwfEkideUdmNCn5fqdQgXCRabx/mxuOlcbjVvlPOWclH1QgftLKKDRRwbHO?=
 =?us-ascii?Q?gKkmVDqqqBJE017uCxdE20w2THEEN1Ci21C1o3nGkbhPHqNHV+PNaVmktoyW?=
 =?us-ascii?Q?2k9FZLJo99J5mXNZidsvSw3oG9O5qEsFROdnvyv/blLYW3sciZ8RzEqc4R0g?=
 =?us-ascii?Q?PdBcAOxMA4vTM+Ls1Zp2x2DvplseMAZQjGNmsJ48yn+yqCY86D+n6nStyeM2?=
 =?us-ascii?Q?FM7QeCJs/jJuXokjKwFuoL3KR6G1WY9v0LAEn61jP7wMRxAyknOD/mKNlHQa?=
 =?us-ascii?Q?1AOqZCaO2UrjjHl1Un0aH+bVAr2eFG3XydLFtaFUW2tDK/WJuu/TF1nfCCiO?=
 =?us-ascii?Q?dUYaSSWLcGnNU2zoXiplz0hAwsrL6X933HJ1CqF3mkpqGP4V0OfoitcQrher?=
 =?us-ascii?Q?S3XKc5vZde8EejJ/ml6hVyFiOmoPujejAyy+ZN7H6tiwBZEEpbc4qYlbUHaN?=
 =?us-ascii?Q?58fPwDN7sb3lj6j2PLsfi0UCpzyRRdML4gBFq6Db8brcX4Fs1qbkdAe4s/4X?=
 =?us-ascii?Q?+Hme/2Lz1LmuEJ0Vo00TXpCPTQRLz3N8Lr6+ZAJlGwi+eUsNdbr8JsYbx4ft?=
 =?us-ascii?Q?/dD489DsFOM3E9TbRH4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb2680e8-9555-4fe0-c8e8-08dc89add16c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 00:31:21.6679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JycvZKpOqNm9Upm5JVKUVHoSnHbu6y4EaV14Ouis4kMIvkEEPOwg3pT254Yua3mB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8565

dmam_alloc_coherent() already returns zero'd memory so cfg->strtab.l1_desc
(the list of DMA addresses for the L2 entries) is already zero'd.

arm_smmu_init_l1_strtab() goes through and calls
arm_smmu_write_strtab_l1_desc() on the newly allocated (and zero'd) struct
arm_smmu_strtab_l1_desc, which ends up computing 'val = 0' and zeroing it
again.

Remove arm_smmu_init_l1_strtab() and just call devm_kcalloc() from
arm_smmu_init_strtab_2lvl to allocate the companion struct.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 29 +++++++--------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index ec8c7b7f4cb9c1..d56e19ca6ef6c5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3215,25 +3215,6 @@ static int arm_smmu_init_queues(struct arm_smmu_device *smmu)
 				       PRIQ_ENT_DWORDS, "priq");
 }
 
-static int arm_smmu_init_l1_strtab(struct arm_smmu_device *smmu)
-{
-	unsigned int i;
-	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
-	void *strtab = smmu->strtab_cfg.strtab;
-
-	cfg->l1_desc = devm_kcalloc(smmu->dev, cfg->num_l1_ents,
-				    sizeof(*cfg->l1_desc), GFP_KERNEL);
-	if (!cfg->l1_desc)
-		return -ENOMEM;
-
-	for (i = 0; i < cfg->num_l1_ents; ++i) {
-		arm_smmu_write_strtab_l1_desc(strtab, &cfg->l1_desc[i]);
-		strtab += STRTAB_L1_DESC_DWORDS << 3;
-	}
-
-	return 0;
-}
-
 static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 {
 	void *strtab;
@@ -3269,7 +3250,15 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 	reg |= FIELD_PREP(STRTAB_BASE_CFG_SPLIT, STRTAB_SPLIT);
 	cfg->strtab_base_cfg = reg;
 
-	return arm_smmu_init_l1_strtab(smmu);
+	cfg->l1_desc = devm_kcalloc(smmu->dev, cfg->num_l1_ents,
+				    sizeof(*cfg->l1_desc), GFP_KERNEL);
+	if (!cfg->l1_desc) {
+		dev_err(smmu->dev,
+			"failed to allocate l1 stream table (%zu bytes)\n",
+			cfg->num_l1_ents * sizeof(*cfg->l1_desc));
+		return -ENOMEM;
+	}
+	return 0;
 }
 
 static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
-- 
2.45.2


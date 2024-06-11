Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2054.outbound.protection.outlook.com [40.107.94.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4302D4C8D;
	Tue, 11 Jun 2024 00:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065899; cv=fail; b=FYkT2ES5dC7iRrG3KHJYE7xxEeHfbY63D4iH3xRePnaXWlB4EbYd8UMXRSTrG8QMJV/liqSrH/+19IrAnqzkVkQn/LJFQp8sGomE/3DKq08ss0ki8e7Zr4RMagMuyOX5Dm8iLo8BMtce/ijfH4mzuoxEwQDj5jJhGby2A+9Ya1I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065899; c=relaxed/simple;
	bh=glRZ4WSzvvzsVQCtyaLp5RtYQ7VlOCKSAsPrPRH7Kg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NOu6CQ5G9bi3BjSjRN2VDRu3yW8ce1aVEg0wkyT6548KoAiBsF+aynBs7AHoXTxvorL3n7i4ax9+FyBa1801x4U142VLDvxro6vp4tdbZp5/7jWNr4Fj/FuWFywKh9MC2P5hWgU1FdxDsuAWuMnLG0/uVd1a+yEiph/zEmZ3O4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XdBLHuPi; arc=fail smtp.client-ip=40.107.94.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XdBLHuPi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hoOt9pbqOnq3wH39swlqVpNmY5M0lQetRirVWhMjPy3FxkRrQJg0kTGmtKqlSFqUZPdCCpaiXnVmXssn/h2RUCQi62b6NYdqXksXLfLFcOeV2QCKysR/tnHcN/cqpZhCv/w7x60npoRLswRZHv517vVIarNO46Uy+WmD+sr/Mnt8N8Ah5A6vvTWxSPOtwkL+XqxdzsWZsQKgFwFZhvXpxS8TP7P1k1LN+rxxA6xtWg+4ibQUHtbZy8qzFWUqbx1C1LhfVDBOR6D/JVaPG5bwdB6mBxoC7OEjO+RlE+2B8tPpIkANhKScmoIWc5mIWdjmk9TjoqlthrMWXa2P7jrDQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W5zqR40rOkpCjeTfCaaimehSVUJMapkYGghvu+9wuKU=;
 b=jphkGif1/IpBv8GwFaWd5WJIrebixXStyIltsyKr74bvjbNdpHXATLRLNOKDxfRuLAjHIUqGfwoN6C+IEzsMhlqG5R89p/IUowF6/1cXBV8sMqOhzmRYfJRLNlhNqaaKk5x2FF7/bUy+PyVShmoyeczWehgFGpA8e7YFDi5ALiAmgdpQWGnV447qfUInWl/EXl5SzoDQ36K9QQIQFPQF7g4BIRiuO97mTscV27BBEQnLivH5y9ZvAmyEw5fHUIWIzwzxuJao/ZQ/JypEHZ5av+ikP/64+74eXH5hvOGsaeQvZz2R/VC2HGEvME8qHsDkoJ3AKUVeaVnkzPcP+L9UOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W5zqR40rOkpCjeTfCaaimehSVUJMapkYGghvu+9wuKU=;
 b=XdBLHuPivrcs06p8QiNJCiX+NqYl+kByfxnsk+lDuFjLr+xWepD6p6QfKfPMsW24Ltzu6YT/ILWIusx1tXzjhTi1faf6rYmfwcLdQb5zSjzgWc3nmmyaESqAmRUudMTFzR53AeNI0q066N/0L3TpyBBcTh7FRPfsgkZj8SmVucwyBxOn3nwoHdpgsGK94GFMGZgrAFrWymtJKEV4gEAl7gbh3rq7hZ/Z4MLZgBf5gtrXXdvsO7YL2TU2jXjTkxuL14gJEYrPjeMd3/B5kljDKeGwbPPDRY5vD+SRhSe9LOcN/jg5qKLgKfkqR2IOa5vw/0CNFJFdNV0KItkJxiy4GQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN6PR12MB8565.namprd12.prod.outlook.com (2603:10b6:208:47d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 00:31:27 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 00:31:27 +0000
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
Subject: [PATCH v2 06/10] iommu/arm-smmu-v3: Remove strtab_base/cfg
Date: Mon, 10 Jun 2024 21:31:15 -0300
Message-ID: <6-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0058.namprd16.prod.outlook.com
 (2603:10b6:208:234::27) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN6PR12MB8565:EE_
X-MS-Office365-Filtering-Correlation-Id: 59295e99-40de-407d-4aa4-08dc89add263
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+iL0QyQq5CqwBBZfxvWhzHCJ0uAjS1O1t1nprnId74tOZKvh01sr2JkVnGtm?=
 =?us-ascii?Q?JfQzpzTXFyPi2DvrqPxw2iv+B2l3gih/Wakh1xCTtEJck7nmlsp4NfPedlNR?=
 =?us-ascii?Q?e6Zq573eeDACbhD4vYeWtUWjdoT3d7CIWoO44CHw/RoLgkAZvDQ7cHJkJA7E?=
 =?us-ascii?Q?OC9NSHN/jAmNgI8VUqw4Av2pyLO1Tu+e5bR3IouRSDrgMVgpMhUlAcTr/YlK?=
 =?us-ascii?Q?tzFKqfoNRaqzXN9b4CSlQwBkpMbRKQAJSNFMHj51KaGXzdqj1atVze7ZD0YF?=
 =?us-ascii?Q?NLlmNIny0Rv+27cbVN7zgHAQo2SLJsUaMmglGrH98ttRgwl7W7t3heVwNfjT?=
 =?us-ascii?Q?BMVXs59du1FjQ79apeb0fBbQHbM5QWrT/BFNm4LE7BY9U3dV2TlTup8hnx/g?=
 =?us-ascii?Q?+z92+O1kuWCvrmCm0mINuiErJV3bmRu2ID1TFJD2kcJA57LFA98Q6Ip160hv?=
 =?us-ascii?Q?MM15/szNn4I6knA/C+A+//zmj3HocBcb4Ii7xmED4Bot/+YfuQoVYmyXq6Ni?=
 =?us-ascii?Q?ysdTm6FaWAWKRMRDKyO3Ehdezo99lmVxl5fwmms2ulddCCHQbfUDqet7+nhU?=
 =?us-ascii?Q?MZyfhYqxwShAgX67QLwpXqCOMX4q3KDTodSDE3wlcKkw1bDrC74Q/TF38Ff0?=
 =?us-ascii?Q?cl+B1TJtkyAihEoM2OffVKjZ4iRBBT936IpcP6qDvcYL6vFpn9V5yiRGBpOe?=
 =?us-ascii?Q?gGqOuPH8B4i7Etw42VT3ydxOGE1gSENWDhvK1sHgbU+nDCCzF72Eitr0+cC8?=
 =?us-ascii?Q?hzgAaLA7g9XHAHRa3uuV7bCMGBmoXPCZObYS/fx7NPHqEZYSJPFisnmSjMSi?=
 =?us-ascii?Q?Gn+QFJNA5oczET4wwkYRai7TfO2Lml47/0FbbIpeTkeeVYTAqT5yqRwNa01Z?=
 =?us-ascii?Q?vyuvr3S+Tpflgix/W0SXVXuAKpO4NmmSH3mK36uccVoa/GzQbfG2j4dc9d9v?=
 =?us-ascii?Q?wU7eCHrOlhB7OcN2Nc/3cxROJnEFO0cq6n/Ai+BioiuNM6C6pM7ysCfl7mYY?=
 =?us-ascii?Q?qf9bI8daliS5L21syZ+9mL249V3Z7rQxSePubYabUQairSxHsMcvRGDJeUQu?=
 =?us-ascii?Q?hdU1gt2LX9vTtCZptHit1IWncA+rTy5FiIHFgQkjW/66VR1ecozi1slkuDVp?=
 =?us-ascii?Q?KoNpefMYKOxlaLzXsrc1fr7dsVrUUH5WgxpWg0Cp8hRjs0PGe20cvhEJPPEd?=
 =?us-ascii?Q?DbMtRth6qpO6DymwnI7A3krhhpDLf6O3okdHCfzID/AfRdbbad9GIVAd9HiX?=
 =?us-ascii?Q?6/zYHrHkndblLwo18A8xqpLjGYptGVPYpBsjntUPQP6pAkFn9u/7YVEW/EAA?=
 =?us-ascii?Q?S1ZVJKF/gXBPI5B65oQFYXcs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z4MrDX1323n+tqfBlZhoKsbHWJQ9R0hWFD/W7ie/FKxVNgfxhRm/FByfg3lV?=
 =?us-ascii?Q?0xpsnB29mR7dRCrBvicYeSqdHSDXLnT4i4sLSoXhm9B5OywvtiO/9q7pdYPY?=
 =?us-ascii?Q?4saT4gNDBrIGMOcfYWFd3Mzf2k4A6CPEmRsRnj58N4VniBQe93V2+x9xNPKC?=
 =?us-ascii?Q?ZKmoyGPxRr+XriNhuBkwJm0fJ+e80Z349+LQnpaLP/f9bEHClWgeewCCjpzJ?=
 =?us-ascii?Q?qs6XeIhesjNGNky4MgNNqcQaXuaaulqEPbBT7iOkyLvZETkrcyahAQ+B3D9c?=
 =?us-ascii?Q?JNIszHjyETHjU6fAZqtaZ8+GCv1jr55dIglWARs6616dLJMNsm0X+tf+Gphd?=
 =?us-ascii?Q?yiKiVzgj87FASN/1+ur7A3BBrsbB7PKb6CyGnjxRAQSqn55COVoFes0OfYIC?=
 =?us-ascii?Q?4+Gl7eAFSjwc7KV/KepmYMlrFZjr6R8fymSYZ/LKyHulls2vQxKN3SZb2RTL?=
 =?us-ascii?Q?lIZ5zDAPtROICpJjZ81q3WuJAHBBA6eZtmn/GONQ8t+tBfk0gRvEdHCH6UAX?=
 =?us-ascii?Q?AnS1mqXwEAC9VOlB1e9pSRMR+8LYGqex+4BxzCNBEgOqyDpfjrPvqMGMKEuG?=
 =?us-ascii?Q?A9/aNJIVFKxtXsf2MJwmt3wg82t9OYO5RgHfobCkY4jVFlytoxCcH9f047FT?=
 =?us-ascii?Q?IuZPUU2bw5ljDttI8Rvg5IOy2P0hjlB0lA9ceStYcm0U3bU2ARurmjCTSAmD?=
 =?us-ascii?Q?IThtTRITMLFZDt/3BIVnXyoBO0PLsIiJ15HmARQAcI1qmtl8Ld58+7Usmzmb?=
 =?us-ascii?Q?FT4Fz5ugGSuHiBPgGpvhzm7wujHwzeDUbm9RRWEr9NfU/qghbSUyrjo/Ipud?=
 =?us-ascii?Q?FbClTTNZUBMypI5xYH9aZhwCdZZZyoSUq90PAPtLeMgDPfx8iTSFeCa+/J2I?=
 =?us-ascii?Q?adaO5JjY8lE+YZ2au7K869oVQruTpH3BU6W4+YzHa/uGN7vRh/ZCR/vX2ffk?=
 =?us-ascii?Q?B1pi2gvO7BxJr6TRGVTvKr0N/p5bLwombQaZrRj+ubVFFyL757EzQ7dOFBKF?=
 =?us-ascii?Q?OSfId4C/s+7UYZKE5ElDN/OkTz/hCuqHzEKivW0bjNc5Q7WqURcvJjVtCycf?=
 =?us-ascii?Q?D/g812ACWMFLrjEA78WqMwquwkqBgob4t+192/UyLBYy8/ZBNU33PlDzl0J4?=
 =?us-ascii?Q?JpdpSH9MMZDHv0pLU43keqdWacT6bvQSQCih5wLGFCVN6/RfCjSSR5NwOtOE?=
 =?us-ascii?Q?k9WyulS36ZhUfICSGynLbepXA+GJwtvHDD5IBnxCul+zDQTeSBnFaA/6tXVv?=
 =?us-ascii?Q?orHTaEYBkq3xB6WE6CD2Cx5q5E6ivtjCaGYsDkKclI86psOnTyu0ha9KuIhn?=
 =?us-ascii?Q?s0FcVz/Bta/0fAnD3/BmruyV9aWVHEaBtgEp7i/mUlzi/YfF7USKaUMHxMPA?=
 =?us-ascii?Q?gp/H1Qgh6zJzUSQRt6ApP9J7n3kz3BAs2sHn2CCLL3pUhFOdoTR8l97leye/?=
 =?us-ascii?Q?lB2joSHy0qdeXtlrhcYXKrQbhq1JCulYPgnSXmpa6aoX09vSO2XBTCS7luE7?=
 =?us-ascii?Q?jcPvEVXKaIN0OBxK37f3yykiX2ozCttPS5Dy4LZMaXHbItxc6h6RrEG/Jm4W?=
 =?us-ascii?Q?OczRr+Z+IZIv4W6FZvU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59295e99-40de-407d-4aa4-08dc89add263
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 00:31:24.5452
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8hPnf8XpN7Wb2XCLPr5Jlf+/YUFH3XT8aL0qrVGiTWTIQyXY6yHUQV4dPvSlloN/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8565

These values can be computed from the other values already stored in the
config. Move the calculation to arm_smmu_write_strtab() and do it directly
before writing the registers.

This moves all the logic to calculate the two registers into one function
from three and saves an unimportant 16 bytes from the arm_smmu_device.

Suggested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 55 ++++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 -
 2 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 21e0438d09b26e..b36bf6bed67d5f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3209,7 +3209,6 @@ static int arm_smmu_init_queues(struct arm_smmu_device *smmu)
 
 static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 {
-	u64 reg;
 	u32 l1size;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
 	unsigned int last_sid_idx =
@@ -3233,13 +3232,6 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 		return -ENOMEM;
 	}
 
-	/* Configure strtab_base_cfg for 2 levels */
-	reg  = FIELD_PREP(STRTAB_BASE_CFG_FMT, STRTAB_BASE_CFG_FMT_2LVL);
-	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE,
-			  ilog2(cfg->l2.num_l1_ents) + STRTAB_SPLIT);
-	reg |= FIELD_PREP(STRTAB_BASE_CFG_SPLIT, STRTAB_SPLIT);
-	cfg->strtab_base_cfg = reg;
-
 	cfg->l2.l2ptrs = devm_kcalloc(smmu->dev, cfg->l2.num_l1_ents,
 				      sizeof(*cfg->l2.l2ptrs), GFP_KERNEL);
 	if (!cfg->l2.l2ptrs) {
@@ -3253,7 +3245,6 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 
 static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
 {
-	u64 reg;
 	u32 size;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
 
@@ -3268,34 +3259,21 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
 	}
 	cfg->linear.num_ents = 1 << smmu->sid_bits;
 
-	/* Configure strtab_base_cfg for a linear table covering all SIDs */
-	reg  = FIELD_PREP(STRTAB_BASE_CFG_FMT, STRTAB_BASE_CFG_FMT_LINEAR);
-	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, smmu->sid_bits);
-	cfg->strtab_base_cfg = reg;
-
 	arm_smmu_init_initial_stes(cfg->linear.table, cfg->linear.num_ents);
 	return 0;
 }
 
 static int arm_smmu_init_strtab(struct arm_smmu_device *smmu)
 {
-	u64 reg;
 	int ret;
 
-	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
+	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB)
 		ret = arm_smmu_init_strtab_2lvl(smmu);
-		reg = smmu->strtab_cfg.l2.l1_dma & STRTAB_BASE_ADDR_MASK;
-	} else {
+	else
 		ret = arm_smmu_init_strtab_linear(smmu);
-		reg = smmu->strtab_cfg.linear.ste_dma & STRTAB_BASE_ADDR_MASK;
-	}
 	if (ret)
 		return ret;
 
-	/* Set the strtab base address */
-	reg |= STRTAB_BASE_RA;
-	smmu->strtab_cfg.strtab_base = reg;
-
 	ida_init(&smmu->vmid_map);
 
 	return 0;
@@ -3504,6 +3482,30 @@ static int arm_smmu_device_disable(struct arm_smmu_device *smmu)
 	return ret;
 }
 
+static void arm_smmu_write_strtab(struct arm_smmu_device *smmu)
+{
+	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
+	dma_addr_t dma;
+	u32 reg;
+
+	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
+		reg = FIELD_PREP(STRTAB_BASE_CFG_FMT,
+				 STRTAB_BASE_CFG_FMT_2LVL) |
+		      FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE,
+				 ilog2(cfg->l2.num_l1_ents) + STRTAB_SPLIT) |
+		      FIELD_PREP(STRTAB_BASE_CFG_SPLIT, STRTAB_SPLIT);
+		dma = cfg->l2.l1_dma;
+	} else {
+		reg = FIELD_PREP(STRTAB_BASE_CFG_FMT,
+				 STRTAB_BASE_CFG_FMT_LINEAR) |
+		      FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, smmu->sid_bits);
+		dma = cfg->linear.ste_dma;
+	}
+	writeq_relaxed((dma & STRTAB_BASE_ADDR_MASK) | STRTAB_BASE_RA,
+		       smmu->base + ARM_SMMU_STRTAB_BASE);
+	writel_relaxed(reg, smmu->base + ARM_SMMU_STRTAB_BASE_CFG);
+}
+
 static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
 {
 	int ret;
@@ -3539,10 +3541,7 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
 	writel_relaxed(reg, smmu->base + ARM_SMMU_CR2);
 
 	/* Stream table */
-	writeq_relaxed(smmu->strtab_cfg.strtab_base,
-		       smmu->base + ARM_SMMU_STRTAB_BASE);
-	writel_relaxed(smmu->strtab_cfg.strtab_base_cfg,
-		       smmu->base + ARM_SMMU_STRTAB_BASE_CFG);
+	arm_smmu_write_strtab(smmu);
 
 	/* Command queue */
 	writeq_relaxed(smmu->cmdq.q.q_base, smmu->base + ARM_SMMU_CMDQ_BASE);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 8b58a30ebeb06b..3862f6e65c770e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -634,8 +634,6 @@ struct arm_smmu_strtab_cfg {
 			unsigned int num_l1_ents;
 		} l2;
 	};
-	u64				strtab_base;
-	u32				strtab_base_cfg;
 };
 
 /* An SMMUv3 instance */
-- 
2.45.2


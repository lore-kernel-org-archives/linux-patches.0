Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012064.outbound.protection.outlook.com [52.101.43.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6452B36492C;
	Wed, 12 Aug 2026 20:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786565380; cv=fail; b=egUHKUGmVkRNMIuwyYDgHfWAZh35zPWcJJChrZJ4I3oDSJ4055GJQ1hLT6mi6kJPdD0YYwIx/ikPDqZjSrlZdwdq60u1UglA/vAQ0jI55in+GhdB/WBIz7v1EgvCYcIUiRJjAR81hTt9AXHPva7JGJ/D2o5wVZdAS/9ZQObR0u0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786565380; c=relaxed/simple;
	bh=hubwwDNum6sLfU53sIovPm5KB9/VfoOOG+hPw1dkF2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HEtAZ1biLQMNjN+ixL/tu2m3z2xhnF4Dad8tOLKXHGyw3IRiPlTTNMSaHZhMf4gr9xMY+nRTtWcl5o/04E6dv5NGsigMqZXrb14OmoxK6irgdwZl3H2FGGcfNXkpbDeX7RAecBB80L2kEB1J38vNGCPfLdCPoHAsdf1Kl4UUR2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jCqebojT; arc=fail smtp.client-ip=52.101.43.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jCqebojT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dbDI/yjp7nO6dXiwTpYT186YcCxQrbaX76tPD2MSfNIYTJs+qZbjwcVwtrWULwCTd+Cg4mLl7+8MleUTI6HbWenZH2mdCmVA4UV+5RBEWdeZydwzbSLtPzFrgdje/GQ3xDFhwHQ6QQPs2tJjwjik+XwkqlHVTlI71On3DwudBxedN+c+X4RtlLL9nWNkinL3DbFJ4mSMf8UiaysSbM0pZ/q7RwRl5epXP7fsLwF0IWECTeOv1R1uvq5sjyAZsSsmN0l7IZsX4hEiGQlxRw64XxfJsEmRE1LvDrfo4OR0M7y//B4b1PtbBxBOHYbg0ssAftL4AER2/xvjTK12Ic785w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O7qHR7cUiimyfLVo/IwiCt2i3wWLOWYGN9WmCn5GgSw=;
 b=wESWIYHaX2OS9ucqzVF93omFK6V+7BjTggw87ZeDiK9AJHj/7pZhn2bfaDjhbxO2mZg+PygNYUYZkYxdWqpMQdGr9fhsnsyS1ox3CsbXJOzU/06Etuf2j25gUTtzqsVS6A0Efus1R1QCeXNY7hiDA4FmOpc2yOZMU+20yL88jlYdf1/cXBi+WSoWo+nCt1Rx/+TuTZAXXS9TVlEBKl4jJvHjHDelXAG8LXB4z1yrEL18Iom9LuFrCu0yUBjqd6JCut7sITRCbU1QIAOk5R7HEljEhml3L4kKLXt9b/vhP4aEIoAd4O+bMpbqqeYVHQ8vPOGbsteUT0y8xpxizb0yuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O7qHR7cUiimyfLVo/IwiCt2i3wWLOWYGN9WmCn5GgSw=;
 b=jCqebojTz3OiYLOJGK7hN/tUzjbhW+tDjyCbQS/uiqe+bPpGmBggnlOJoLm+bWt9hnu9kkFf54BTwL+s1ZV8FTNZ04GASuSU2zH3ZqwgfQALb/JfX3U1pdhPWodLf+lN8bwB14+MzyuWXQ9pF6WSYVpJR6eIZ4uXSBjMVymgX/Y5gctBaEgdvyWKmT44nqMDvvG1urPtO6yNiN/VaKBASj0IWJw1FUm9ZYCqXNuUKs273fouA94+lqXdzGYISl3AK7u6DLbGMBj0MEYGmYNF77T0lJw1EP2T5C3NDZGlJ7YB1lonWt3VlJuC29uJugD2gqrBzi9x9WX/Xmr7zGcH9g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY3PR12MB9629.namprd12.prod.outlook.com (2603:10b6:930:101::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Wed, 12 Aug
 2026 20:09:34 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 20:09:34 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 6/9] iommu/arm-smmu-v3: Remove io-pgtable-arm from sva.c
Date: Wed, 12 Aug 2026 17:09:22 -0300
Message-ID: <6-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0052.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::34) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY3PR12MB9629:EE_
X-MS-Office365-Filtering-Correlation-Id: ac1dc52e-66e7-4f37-4fc3-08def8ad9cd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|22082099003|56012099006|10067099003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	eA7AMC2G+TYV7CRvkGX0eMZxTx7EP5b7kBzYSuVmeHLur3c70qFEPpFYtB+j+qMzHBZqzWYSNyMnycqL1S6kvFJ7ILlPb1J80t5O1KiUWyPYG+5+isAy/LuWwGU3Z3VmqDIKaIqwwvSlNObUq8kfTFhMmU+j3Uz1Ye3T+xBRs7aMwe0VKeoGz8nrg1+0qSnsytJZ8h01ZYRFg9GPu+yKDqWn/RArsLWQvK2dRUK8+7LBzqeII35M1yN5zmvjOSqBcZfxMUvD6Tw7KU3/HFr/17rQTpdLTTifhgLyPV2/lXPpvXgdQRY6zb+Ckdo6EU5Vv6cAYev+sQueZxPuztBI10+o4aRUCDGpT3zqh2PgAs31ZHu8a7Ozju9I5CZ6hVlH/0AJWVwxOxD7jk2HHYKfZ4k4Ipr1D3DPq5pCNntQ27UeI+pVTI4EIn10dj2TMwb4XSzMW5zBQ5VtPVM99wpWlMVHhBf5NZqDyz3855dCB4dWd3a+mP8BpunQkIlR8GkdBzMdMq+kVL3iTOle+dfhguoy5Cnuq98IbGJoJSqySknB8iSmJ+Ocbp9vaMhBvAcRRYNKgUYnyzSi61p7PhNn4FpiCIwdacSXTaISq+VRBfuHcsaJSxInLP8fgw4Xec2sYai9vxSxJR7cwo1j6nsKehfXOVszZuk7dMwnoYAFZ/M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(22082099003)(56012099006)(10067099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QNYl694HW/dXPJBl9zJsTHgI3ZuSef5rX+xUHXqu0z8GgzLdcQWsCZp5QM5J?=
 =?us-ascii?Q?TZoQL7crE2z4/uW0V6qKMrOe2Ks3IJqlrSSTumI+wf3uPaspAz2/SkFmWw+G?=
 =?us-ascii?Q?EaHZ+MtzRM7t7FoPkzVaLSgurTloTz58YIetkTatHy6R0mmD78iw+dBLyxz8?=
 =?us-ascii?Q?2t2s5iCniS4uQE+rX/dk12jiyMGTMuvaKGW1mkt6o2qQ9Y7xlNYJNWNWuCMS?=
 =?us-ascii?Q?rriYacO+M1b7dx/qkPKFsBZjpqf202uNClkVQFlzRK1W/SfLSERg4RWcL8Pp?=
 =?us-ascii?Q?w9folMQyAyLsuacvRulogdHgGirXoyEAFuXYxLmONn9iy5QcqHMPRnsWZnXI?=
 =?us-ascii?Q?CURBsRGqkfftDO1RFWeEB2kro2BWp4hvgpKW63o6ZsyqlD1JgqeVMmyKohpd?=
 =?us-ascii?Q?TzIk+2Lu9s1rdi36orPMJEL7SFNDXEe/ZnPh6TB7qw4XS0z4oUSfLo2DxbDP?=
 =?us-ascii?Q?BncwR+2uODv0SbU9jndSPHlR4feZDYTucFUtrFrk9z93r21WDJkleVOqiubT?=
 =?us-ascii?Q?VwueGeFqW3jxevxTVWRctTgCYmvrKmg8wNcQ83BJbSfCRW2QQIpojn6P2peU?=
 =?us-ascii?Q?FcdyJ0fWBZAuq8KS4QKE/8a5TX9jrN9wMns0hzKsabP9ET/qeMOdPUdsdsgY?=
 =?us-ascii?Q?aIcpr9Uw+d3yTXmzkd23Gapayu+mRM8vBCKJ9llBNknZ9W323V90WdMzzTZo?=
 =?us-ascii?Q?lAXGvsZCKRcY/MqkbMg1tpmDIYKsZJqwAezeemRw4Kmqs3/oKDPcb2qeSTA4?=
 =?us-ascii?Q?ZXNBobwaILRv2jt11wwfbAsfnGjnyTbM6yvtdM0OZMnS5hlI2BKllj1xoum+?=
 =?us-ascii?Q?XgQbUxo/tIW0X2pAyfBHGTdj5S8hHuyOzyfgauq4aTkW7haYPoupMrnhi4m9?=
 =?us-ascii?Q?+z5bTvABVMAid41zPMpg00ONteirD5xK/HnaFIhVFKQIWx0tCPmW638n6qWs?=
 =?us-ascii?Q?SnKkvFYJpfXs253843v4vPz2NuLidvH0M99eaUnJkzkm/Pbht7AjIFLSs2kD?=
 =?us-ascii?Q?geX3pnbWENfX+GxDOF5fO83Rk6EKI9oCx6lhU+UO/B8YLDNpVtIHpmQ1gRM0?=
 =?us-ascii?Q?YwxmRdlQ8r1ANYq1skz7OzhoxXuSuusEewm27k2MzSp7nfi+akjuK4jlN5fd?=
 =?us-ascii?Q?68aW4YJ9eqe/pCEA+SFv6CQGAkqhowE09kq3K1kTM15dI6yyJFnHR5BtJVEK?=
 =?us-ascii?Q?upamnzsEg4hYTfapxbQcS/qDMqpwKEKrLA2FXrVcHUp3Qb3oPS4/jJNkKfUz?=
 =?us-ascii?Q?TYTY9h8oqLnsj5Xbkbpb/xReZ9DR3LLrOjjwN0WLstE5heYzusJsf8gwkA66?=
 =?us-ascii?Q?nKMee+b4HQXQMgTRwPx557xniO1g97K6QQFUCTeUCgfM6UuUQKz4TchSZNP5?=
 =?us-ascii?Q?avEZamvuMvZA2YocnCGz3yaLZgLhe3QZwwbX/alcM4LOFwAOaVfLvxbd0Vxk?=
 =?us-ascii?Q?uugJQt2h+hQRNWdW5GfU9eOGZkFofdtZKrS8dWeNsSu4Ia9OVD0YMC64hfmS?=
 =?us-ascii?Q?t7o+NTwqGnjX/K9Rf/A9VT6Tb+rjKLRL8RiouCSiQzla2PjOzyBwdZxA3Jv/?=
 =?us-ascii?Q?7zfmKGR++P2gZb0wH8QjwbW7hL4qmLV1idLYsvVfH2+zttACZKfwVnx79eRW?=
 =?us-ascii?Q?cFeGO5F0q8GRIOoXmXj7t0nwiw6+a7jGlFajiBa/cH+ohXvuwUejnDH6es6I?=
 =?us-ascii?Q?k1bAFvYPFwaocC/rKlrwUgDUA9/h3NhCJgIreLnV7L1SSfQ9OXQcJqUgfbbH?=
 =?us-ascii?Q?b8avSmqZhQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac1dc52e-66e7-4f37-4fc3-08def8ad9cd8
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 20:09:27.9426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mC87CDXzqQletRcdeZQsq2qLj3lkiTmyUOPTZ+JVdFyd0alAAlIQqYURjFhetosE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9629

This is only being used to get some STE constants. Use the same constants
from the arm architecture code in sysreg.h instead.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 5a17172df381d5..e7f63766630ed2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -10,8 +10,9 @@
 #include <linux/slab.h>
 #include <kunit/visibility.h>
 
+#include <asm/sysreg.h>
+
 #include "arm-smmu-v3.h"
-#include "../../io-pgtable-arm.h"
 
 static void __maybe_unused
 arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
@@ -41,10 +42,10 @@ static u64 page_size_to_cd(void)
 	static_assert(PAGE_SIZE == SZ_4K || PAGE_SIZE == SZ_16K ||
 		      PAGE_SIZE == SZ_64K);
 	if (PAGE_SIZE == SZ_64K)
-		return ARM_LPAE_TCR_TG0_64K;
+		return TCR_EL1_TG0_64K;
 	if (PAGE_SIZE == SZ_16K)
-		return ARM_LPAE_TCR_TG0_16K;
-	return ARM_LPAE_TCR_TG0_4K;
+		return TCR_EL1_TG0_16K;
+	return TCR_EL1_TG0_4K;
 }
 
 VISIBLE_IF_KUNIT
@@ -85,10 +86,10 @@ void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 				   64ULL - vabits_actual) |
 			FIELD_PREP(CTXDESC_CD_0_TCR_TG0, page_size_to_cd()) |
 			FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0,
-				   ARM_LPAE_TCR_RGN_WBWA) |
+				   TCR_EL1_IRGN0_WBWA) |
 			FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0,
-				   ARM_LPAE_TCR_RGN_WBWA) |
-			FIELD_PREP(CTXDESC_CD_0_TCR_SH0, ARM_LPAE_TCR_SH_IS));
+				   TCR_EL1_ORGN0_WBWA) |
+			FIELD_PREP(CTXDESC_CD_0_TCR_SH0, TCR_EL1_SH0_INNER));
 
 		target->data[1] = cpu_to_le64(virt_to_phys(mm->pgd) &
 					      CTXDESC_CD_1_TTB0_MASK);
-- 
2.43.0


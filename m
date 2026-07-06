Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010038.outbound.protection.outlook.com [52.101.61.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0E14314A0;
	Mon,  6 Jul 2026 16:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783355365; cv=fail; b=eJU/f0eRye2QQ90WKEDmrP+HKiPm7hcARWUManTXXTyohx+gsh/+TUwexkh79h1pqXqnrHWJA4cee9WmcwvJbChEVx43E1P3qeXazFjTgGP0R54NleuXIE8la1qTCK21Zyd/bQwtkFBNXPgMgtaWJtsrtFJSawxTDvJPngl/DnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783355365; c=relaxed/simple;
	bh=v/PnW1/6SeUFZBXPa37IM+2fC2cVfKLLc7YDkWvfg68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pSQ1FIM1dureMqpJ1waXM08MkTZfz3szY54/laD+U7aw99q0Z6RMPeFEp84PMuV1UuJSpzcuUW2LBd3uQQD5DhG5+7URnVEpdr8/RG/Q7eg8af7h9VUqFsjKnQULmQLeDj9qGj2El/2YMlj2zbzmJ+xuNgDs5ZxlldL7J4geDNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KrfhHRJr; arc=fail smtp.client-ip=52.101.61.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KrfhHRJr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wdoBOrVCZ+z2byqrnYj446qDKWpo4CmkubmeOk4kB7Rt2gDA4862ihWjNIWvCizamsVYMJFHyldOy9HpmCe8smn13aLWV8kS56IB2NaQY+BTgjC+xEN13XviicpR5P+C0gfCj3R5OrQWaskHsgwDsC8XGnfg247yJLApH1dQcO4uLOvJhSExQ09QGjY450iDv8o2ZgitF00CF+PgUdWfKsoO/dX+mzy0pInSRdQ0GRV6qr3g1Tg4Ur9zo669vW5RjQ6E6YANbn2oOOj93YPF05YaJjC29VM+U1AybGAx3svBESEozCxoY5sWceOgF1P+42hdzYu4W8pvn87+CiHx0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dubh3mzGtpVyB+80m4pgBJwf7z0LaVylY24gFMLT4Qs=;
 b=I25cT5/g29464h6uVWq08r+f5yOZw8sTvdhFutfQJJignT8jMgccr7c8tXPKjEnR9mfALXPtwOvo+B3gVNGfhYr0oKP+FKmHY0yM3dxG8IG8a4KIuYp+d8N5h/3oCQmTCGIKHeAbZrsQ4dvfKSO4BXKyicAER9yvaaoNhrV9sF009No09A7D4VSW/36+XwwEmQUCxsnCMf/E6u22cP9NXbvz6apDbbUpyNGkCN6JvH8eqSrjTq82ZshuHSHy5anquZ6smTCPtw1HOS7SxW5pdNrDKMJl7hY71B/ew2Xghyn5qodN3CdSl0fh5P9L9/vTakSbl08R057eVdUl7mvpqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dubh3mzGtpVyB+80m4pgBJwf7z0LaVylY24gFMLT4Qs=;
 b=KrfhHRJr/OFNwDq22oWk/ajA45qEhmcb49PL4qidbzf4At1CZ/q7pku+lbWA6/B3s/eueShT1xf9Wy8hThjMShjRmoY63rGNNkFTsIW7rsExAfei2wf2A1W8fbFKAv8SJ6WQJYLZMPaZEKG2SJZl5T7UdJz1xoGT8r9uyoAOj7opVc5jG2Iiib61n+Taay1Uh5l446nU7b3ROs7mYFH+9o4vxRfd/l+3lK58hUVCSEhtkfYBrry8QOOp2F/Wx+MUHOMph9UGW/+KEzJdLDWbE8239odEdZclLZje9BeCCMBeAaETRLNDY+cq9zlyc9nz1K4GD5xY5GDLH5DAQ5d1wA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB7956.namprd12.prod.outlook.com (2603:10b6:806:328::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 16:29:17 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 16:29:17 +0000
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
Subject: [PATCH 4/7] iommu/arm-smmu-v3: Remove io-pgtable-arm from sva.c
Date: Mon,  6 Jul 2026 13:29:10 -0300
Message-ID: <4-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:208:23a::9) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: 8783472c-ed20-4abc-6b22-08dedb7bb7fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	NavlgeSUlNw56j8k9xUqKpAAB32g+rVe0YzAUS0FNCjlnedhUVU0pciSOhFPkYcZZkwSMkgE8vRxB7tWLbQmIkw28WmIJY2fu6Ioeg7pwoV0FW/pvllW0IbMzjODIqwjUrBzGAtCVJ4NiVWfvoVawbux8lVTpl0PkgRfzcmxKIRwnW4J0cXBppD6WQtPlo8uif+iDZaVUwvuhwVM03nAjzh05f90985Rl2zYW3p911dLuF8ICIZjjVdOIcw5HF0CYjMHhmCsTzK2L3r3LRgnkkUVmzzWyhB5MT+xw5EVw7tGEnnYiB1n4XAVcNfYAP9M3/lmY39qv+ExgXdcMKnx78E9JszWSriISht+S4e1O2EPF06dovyOjZZwqp13HuqsXacQJ6hZ31a7qR/HCiZ/3P5shr8aTIc+aM43hKlOqxg9O3JHh2+Ndmhp5YDPEYz+nn8U0LBhcWwSos1v7RG6iVvxKOtadGaUPecQe7en4oBN3LlOHTnSJ95dIeNO2+YqUkgQoQcpeJc27fJna/2EE4h1trzhucVQKfhWoWxsVJXjANLVVAnfgJ86XHH4fdpvlKnDZPpSJ+dcEPq5mmvTgwQnfo95CBmG8eqMo2QaIdVxcFSH/TADx7PkvzJmRyOrLq1N59mupQqos0b4GuTNNem4OTjhSnynjCIKYx4xDzo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zXONfrVrvl9p81DrWuyh4sDCoXtMNtRooYvIQXL3HIh7xHyLwVgqLbtaQtoB?=
 =?us-ascii?Q?v3tNnmcXtrGgl4F+j5IYjazj58RrBhNchX9gV7BKxrBpx466Z54BpSUxSrAE?=
 =?us-ascii?Q?v18lw6ii8b4GD0MG07JWefGbAMERkUN/n667OoSeOcMeIMOczrJ5doIhtTLz?=
 =?us-ascii?Q?nnyXc9dIxPO3HAQGOAUE4VWOB5gSkUZ1nZwsZOtOnIRTpDsXRo0XvhGE+lOL?=
 =?us-ascii?Q?wswEZj5RGSHmn0d/EV593E1OLPEsE1G8IoHbkU1+mfau/nBOUaTSEH14Swtk?=
 =?us-ascii?Q?DBhC97murP62HV3zvhWJWQnW9jMh/aiYd+WVp4/sba5Ge4IYBNVY6IDDdqPs?=
 =?us-ascii?Q?9CQN+SrFQ7XTiFBKmZgRc2ZoObgKZKhJH6lXb9/D1jVCkBo0WgMuP2xoURsn?=
 =?us-ascii?Q?cSftR3xEuvXabwBgMeYcCQEx0041mRuOYAMrF5arQEdCWpkO0waqLf5dLKLB?=
 =?us-ascii?Q?zA41RkjMRMaWNMjncVH7y3IFHTp9f0YxUBT7XlK4KG6nbsr+j8HXV6Mzy0Um?=
 =?us-ascii?Q?UUFXv0wqVnQc0kWBVqgC48yy+O/LjTfy/QfuXfjgZybEbfqe4TSYq5SAPH1O?=
 =?us-ascii?Q?6uQr21IoxSorDFdcYaFzlCWFkM5PNwH5LF3tAhzgOfpY3XAHRY5Fp5+k2kFC?=
 =?us-ascii?Q?UawestexuKF/C4cH0LEqk8kb2FE230VnyHECti4ARaW6EjVp7YSzaw4D30/A?=
 =?us-ascii?Q?MYvzKolTWw169zMVtazt4Fx14IMJqqsEnheFwpfpGddH1ND7BBf0UoyYIbyI?=
 =?us-ascii?Q?jhDZAcEd5MZDbh7LjImSFfUcjGf9pS+tdWwatyQNNoIEZD5dvKiq71fjwF56?=
 =?us-ascii?Q?uD58jNpo5VKehp5m+4GUUHyERh1snXHa16VK0oYdTf1ZYWbxdUZi2XbQH03p?=
 =?us-ascii?Q?nfYwko/z/d2OErApOdGWSYKEQRTxDTgbJriwhQCr4df34cQozBYPdDgzVOuS?=
 =?us-ascii?Q?oTEeOOsekTjTNh+WXKw80bar/W8M/L1wYQVgGAUY1HhN3aenVobL4PQqVVHq?=
 =?us-ascii?Q?CisI+x1R/QubHPwVOG8FXYtYaHHFR9RgdfK0WmSB/qTvwCiZnJEPN5dVluMy?=
 =?us-ascii?Q?zUtZWo/P4BXyyJvbrtiVc8gMu9e1XSNZ++OYFC2LJB3uGU108yB2xt5SmCP9?=
 =?us-ascii?Q?VVcLsU5jsp5ELS0BgK4euKSc8G+ONOYBk4b/yXOTuiiOR6F+QdXMPO1HirDD?=
 =?us-ascii?Q?lwIlyW8VgKShvKmJtYGvYR/JkNTDufD2gONrcyLh6pSgekqvV+f1OjLU27k1?=
 =?us-ascii?Q?d4y5Gaau/2Lm/Pr9c6Aef4AI239S6HCWwXQp5wteYxzrFbAYVRgmBn4ogQ+X?=
 =?us-ascii?Q?wUeHzHfgzeOKTWbS8fT2zqwBp4EZCEJDCu79k08p+bjh6hGqKBogeN5iTCZh?=
 =?us-ascii?Q?OiMUc8TWp88Sv4ml1Ac5ECId6SUrTZSOjKOUiotclLqFsHmuXrGJ8J8hgM8q?=
 =?us-ascii?Q?ZdWNb8Ctuf9lBs4FkfjTUuguUnTUeR6tBk6+q9HCIYy9Aaf8ufpiJB4CeuFr?=
 =?us-ascii?Q?X92HI3bgT0sIVOYq2RnrLtA1UqwwFEjK6dop1Rw3RNlXt+tVnsqIqBWWSRn7?=
 =?us-ascii?Q?IBGLKcUS4JfX7Ln/uTTDPKFWxjG2v3gT3+imw9sSLQHka4aQjpwkj2X4cXI8?=
 =?us-ascii?Q?I29vTRJ+gn5E5o58C2Nj3eQmIsEKx759qQHoS05RT5WZQSIMe+RhXdS5pu0Z?=
 =?us-ascii?Q?rc0OWCwJNM4e4xklCk3mzgGaDfbiy33gY4AyN+Mf9syZenJn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8783472c-ed20-4abc-6b22-08dedb7bb7fa
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 16:29:15.0493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NbT6Z+e77JCQ/KSsrKKKbCHGjnK0lPD58HqWruVJsk36gdx1kLLGS6lI6qLPNray
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7956

This is only being used to get some STE constants. Put local
constants along side the register definitions instead.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 13 ++++++-------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     |  7 +++++++
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 0e670c92469b2f..f82a513ede09c9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -11,7 +11,6 @@
 #include <kunit/visibility.h>
 
 #include "arm-smmu-v3.h"
-#include "../../io-pgtable-arm.h"
 
 static void __maybe_unused
 arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
@@ -41,10 +40,10 @@ static u64 page_size_to_cd(void)
 	static_assert(PAGE_SIZE == SZ_4K || PAGE_SIZE == SZ_16K ||
 		      PAGE_SIZE == SZ_64K);
 	if (PAGE_SIZE == SZ_64K)
-		return ARM_LPAE_TCR_TG0_64K;
+		return ARM_SMMU_TCR_TG0_64K;
 	if (PAGE_SIZE == SZ_16K)
-		return ARM_LPAE_TCR_TG0_16K;
-	return ARM_LPAE_TCR_TG0_4K;
+		return ARM_SMMU_TCR_TG0_16K;
+	return ARM_SMMU_TCR_TG0_4K;
 }
 
 VISIBLE_IF_KUNIT
@@ -85,10 +84,10 @@ void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 				   64ULL - vabits_actual) |
 			FIELD_PREP(CTXDESC_CD_0_TCR_TG0, page_size_to_cd()) |
 			FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0,
-				   ARM_LPAE_TCR_RGN_WBWA) |
+				   ARM_SMMU_TCR_RGN_WBWA) |
 			FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0,
-				   ARM_LPAE_TCR_RGN_WBWA) |
-			FIELD_PREP(CTXDESC_CD_0_TCR_SH0, ARM_LPAE_TCR_SH_IS));
+				   ARM_SMMU_TCR_RGN_WBWA) |
+			FIELD_PREP(CTXDESC_CD_0_TCR_SH0, ARM_SMMU_TCR_SH_IS));
 
 		target->data[1] = cpu_to_le64(virt_to_phys(mm->pgd) &
 					      CTXDESC_CD_1_TTB0_MASK);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 95186cf84e9abb..99ca96db0d0401 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -203,6 +203,13 @@ struct arm_vsmmu;
 #define Q_MAX_SZ_SHIFT			(PAGE_SHIFT + MAX_PAGE_ORDER)
 #endif
 
+/* Constants used for CD TCR and STE VTCR fields */
+#define ARM_SMMU_TCR_TG0_4K	0
+#define ARM_SMMU_TCR_TG0_64K	1
+#define ARM_SMMU_TCR_TG0_16K	2
+#define ARM_SMMU_TCR_RGN_WBWA	1
+#define ARM_SMMU_TCR_SH_IS	3
+
 /*
  * Stream table.
  *
-- 
2.43.0


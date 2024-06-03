Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812C28289A;
	Mon,  3 Jun 2024 22:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717453905; cv=fail; b=LafHG1Oi3yNb4eu97B10mLMbBzq7ictEjcjlRGI0z88zCp2bXv1b01CUIgcSJ4O/vgDHguhRnOOP6j9fOSjDSy67EusAgjUlFQadAyaPA9rIM+ekkgwmoUri+bQYhFiDm16snsfYE2AZVP08m4KZKLA/qMYPnISj3Vp3xi0uZvk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717453905; c=relaxed/simple;
	bh=rt0IsguiS6AKSMyhuMQ4gefSdtIhF9Ro8sCezvTSKjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VtpdQ0HR6ubqDeDNcidJw/JEZWfB7Dov6vXzfQI4Tx/1RbkzLdGK9Hq2Ooy8na1H9Lrq5Ww7SQCIHOrFVpt9h/LW3WXLBknK5ooBWCA7mnKLb7CRz6z4AnOdc4v4rwn7vuhZoatOblt8Gvi8p7MjCYg63VJpu0JcyE3crE2btYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oHyKofr4; arc=fail smtp.client-ip=40.107.94.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oHyKofr4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BsKuNipbZAPF/lbR9nRkLOCh39wuQ5DouLipnAQVPY0l/sXZ2DQ2J2srdMZtCMWpiq48V3n3XhjR3zt9V6Wn/VIss6VYsOJEfx63t1gFlXifLQ8vQZUQJlHRZx+8P+an9zVt/X+tfyhy/LLZGk9XmEzBjTmxe/k5lbp7xcRQfAavhK1cEQtAAYEJv9qHUWZKXdMynFs+P3dTwy7fNsvSJVPVhKFhD9ZktQxMJ69l8KHpslzqay8Wa2iziEh91nrxTLhvFmLDeSjC0AEQ5/ALIJFKDctXp1EVK0iPh3m4SqNiJTtw+8IpdVEygSHrANyESmez+qnnYXzLepxPmGkmuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lphU3KQKuRLndzzM5bkWVVObagvyxuP0pAYPwpGda5w=;
 b=e5CozVQruYLuVyXWI/on6DIQrNGuU5j/OU8YyVLLjxyGqC80mDDmlmsKFhAnhLktvlKGIb7KIejD+H8swMwDJesBvZHd5cfISt86Z2F5qrmXqCBOnyExNulYfpU/ouvSXkLm31k8NXnbY9u49KsxJwxFqhlFQlcZVtAsi1E5QH25G+RU23XjxBsgEy6oQiDeC+RZJlztvTTQGDNZ/arLPmCNJ5pO6q/0V7UCriF6QNm0V2hfQKnDYWbHQt1RLYQj7uUMkk2/lY9s0L50X+rn/vHx6NATyC2WK0o/y+XiwGm45j8+I/ffSyugD/RNh2GSNldo2Apa2D448G6HOa5yQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lphU3KQKuRLndzzM5bkWVVObagvyxuP0pAYPwpGda5w=;
 b=oHyKofr4mxA2FVWhrLAayfgaEQapQlgYBTzpQYMtjrPTsNxveb7Q2O7bjVQVAXoincdI4F46JWOgllGvQgzagzUS+l5ZuQz7UdH23n/iK++3TFX2TeSk+1DYodJ/PQN6S5YkgQNYBNaB2wbUWuRWuWKKiki6CZwWIlXmm1RpnptNwHxQK04OyCOY2t1Nka59+unn7Q9wY1PIMkmt+SLoXYfSnyazhuU6PFsU7wyTF5DV3X9YIy6A5B5630ySU1Bs61+grcT+tnsoApdhoTQSzOAQdPSQ5TWm5MjX+GETsQT9ObFOiI6stl1ew7ZtRItZ4nJ8YLLLgZtvs5UesaI71g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW4PR12MB6778.namprd12.prod.outlook.com (2603:10b6:303:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Mon, 3 Jun
 2024 22:31:38 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Mon, 3 Jun 2024
 22:31:38 +0000
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
Subject: [PATCH 2/7] iommu/arm-smmu-v3: Do not zero the strtab twice
Date: Mon,  3 Jun 2024 19:31:28 -0300
Message-ID: <2-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR11CA0018.namprd11.prod.outlook.com
 (2603:10b6:208:23b::23) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW4PR12MB6778:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c36cf1d-f5ac-4821-6ee4-08dc841cedfe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aPjU2KQAwEd/3yBx7qJw25JLRBnGtEUeSDioQAOFcfwhan2CJe2LPxrZtimN?=
 =?us-ascii?Q?IS4zXCbUj2hPePKN4cy5pdGlxHs0lspdb/KRftf+qnJngV6CFuGnZll1uA3D?=
 =?us-ascii?Q?KKgK10NJN2Xo13l5WMOSw8vds5y5L/Lvr5edYxxIR7aePWHL9O9zUfhTe9iO?=
 =?us-ascii?Q?pMH53yqyXFPD77BRwYEW53AWHCT/x6NwlFfqmcbD05ALWN4H+rNxb2UO9Jgj?=
 =?us-ascii?Q?4DVvLf8OORpXg5q2vS8wSN3qZU4Q58sSjjCBr4gsVqr6AnNSRbf1nkcPrEPk?=
 =?us-ascii?Q?vIMD58KYLPcB5SPdGWBWXJLlXA5DIDbimaRGcO+PW+38iFS1EugRksVsfTpX?=
 =?us-ascii?Q?MpeZHwGFuuLnuroGD5GjbuBa5EMeNWLjghB38mUU0PTqG8aapufBfy66jWtW?=
 =?us-ascii?Q?3+uiPmbGTki8TPdkIP8mhgzsJyKU7aDLCkNPXeNVAjhNscqS3Zrc0szGhNQU?=
 =?us-ascii?Q?giUIYsQMIWTKbbOtpZVXsAeipGDW7Dx9tq2sU+VnrgWpqoS0v4iLeAU6gsKe?=
 =?us-ascii?Q?H36inogvYboduGaWZbmnOU6oQs+YFVgh2e47ZiWcKUHq1KCeR8gtO0bMrDE+?=
 =?us-ascii?Q?/w9qU93Bd7kSTrgJ0H9uZdxapR/11oU8Ro1L3FKmkzGhM049KlGcPjdW77UQ?=
 =?us-ascii?Q?zFUjA/W8OAzIsP3gVPRE8azRKm8NBcxe49IXPpurw+kD4LGLSjrph+oZLtUM?=
 =?us-ascii?Q?z93IP5Uz2XTXFb/6lBHJ58ofqKV8N67HHJZylpukvwQrk+8NFZUHoiCK6Yod?=
 =?us-ascii?Q?zWl0zUkfRGJi229p2ykFmhAEkBz7wQw1PHgyTSrbozdXvaq8wBnW65UfizUN?=
 =?us-ascii?Q?nkvcEiIFUsS3tuu0WST6cL2LIETCJazMw04p+a9df8wCxcS4j3/MDC5v0/ba?=
 =?us-ascii?Q?u2xmgUHGnUfS2q2ANMFV1qHY3chUaLXWQWIn/P97nBGeCvy3yrMcYvAXto6z?=
 =?us-ascii?Q?sQ4ivXCngR8uAj2ff+FuZk9xaLY9CWb+CeyQRIQj8XYQuMyraPILIqoIJ87H?=
 =?us-ascii?Q?xiQuVKKaw+o2waz+sXcLmOEtSDK8ou4eglP6lET6ViJOem+2j7p77TtnKQcC?=
 =?us-ascii?Q?hl0ygZoNMeKY0TOqjK41KPhxnsRJg3RwVt2vYAl1u+5IeOP+iN7hF/m8nX3e?=
 =?us-ascii?Q?nsZSAy4qnIYI6hiTGxtW5pu+Dl/Lwf4rHeueGMlhgQJe8b8uvbs7FPn0fjoq?=
 =?us-ascii?Q?GkwAI1VKPs3IGMt8bYiLvw7+C1wjKxpoLC6woKTvW4cZHnnW4bB0l9E2vmWt?=
 =?us-ascii?Q?PhWwDaT8W3yULC1AApdyLo/+r7LTzxCgHnTao1VLqw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KB1b1KOpiubw8YsIMQjq07zlH7a0pdaxtDLaCExVSNlIEQ/++T41vKPR5akk?=
 =?us-ascii?Q?m5oGUl65uUbQm1RKnZW+3jgNEoV3/HRsZ9A0BeHxSmCCmJvcidta8rUcnOWt?=
 =?us-ascii?Q?BW+qo6RVIvW8pvYNriitZu+i1yb9NiUKUYhn7Ay6/BrCgoWr4kGU2EKxaLI3?=
 =?us-ascii?Q?88lpCZx0qFiNATtaUovovL7hZPHh49PjheFtlEF0Ttsxz3qmH+5mQgSlIpQ9?=
 =?us-ascii?Q?ivx/d+Bx+sFWK1H73HbJwSgGuB9T3pmmEdbPtGyfzazHSyhEU84UE5svR2Yb?=
 =?us-ascii?Q?93zq0kj7hI1yuERAcwTrJWVztKDvLm18mz8/88hrvL/+5x0stq85L14Loz60?=
 =?us-ascii?Q?tw1ztZf0Kuoe43uhI1CeDaBYt0uLFGP0gVzKXIP76bjp3rHQ2D6d5zixrUaM?=
 =?us-ascii?Q?l2sVWu0+XCzR60gb1VPkcC7zb7nA3HCCFjWaAUHktvHMlXYkNLSt1xGaJTED?=
 =?us-ascii?Q?e1xZ7VJr8U5/icD1wtXi2PWWAQ6L9svcTBaxwd0rMsGC4wpWXnWf0TUMNGTm?=
 =?us-ascii?Q?xe64qlFcdtFKt+Q30hkcWI7hRKjFZxJjaf2AfU2IwTkeaIEaTYJZNm96Bbqw?=
 =?us-ascii?Q?+kyoFtNq0qca+aY12reJ+1cOKS1NAxU8IppjDxgIQmnVGdMecpBWm4qyDd1W?=
 =?us-ascii?Q?O/pQDaaJkAYy8mbk0nRwqxJSRR1hV2OtOPLeW6aJWxmD27j7QNhnG0//1rZ2?=
 =?us-ascii?Q?Qk4Et1J9bZpjug07SaKzC5Fc5dPydbLYRy2efFXRSnI0nMlNtUdryxW1S0qR?=
 =?us-ascii?Q?a+c9H/5kuTshnfkGzfBDyMhVgBbB1Jps3epjWfPbCUqmNSz1VIN/+N9K2meA?=
 =?us-ascii?Q?oV0tlgjsf0ejjPwbO2y3eZFLkFKKQkFVgv1qAYvZc1Pi+ikCzqVEiwaS/lpJ?=
 =?us-ascii?Q?ZJVFzXsK0M6mrq1Q+vEBjN2rVdX+7jjOOy1cbSh9IZ5trPG1D9xxHdYmg/hB?=
 =?us-ascii?Q?O4t8tgzzHcXWnIBh+bFsFWRFBXmrTi1RoWHTvXvNQzQ6Zz9Pwzhg3QM3wA4k?=
 =?us-ascii?Q?9NzW8n6qbtiFg8R9+pZzjMt28ZcyYuMwOAwh2NaYQgmeHPEiCagGDjInlRG5?=
 =?us-ascii?Q?Ewy6yktu/U6jgr7ELvcZwYQWWY9yAAkk2faWcjutJ0XPo/PyJQ7xS7E8J9Et?=
 =?us-ascii?Q?31HKMDcw+27CVqRoIy9WaJxsPX1NN9SEsPUcU7YnxOUnXzxxg5KeNNNh7tyj?=
 =?us-ascii?Q?/LBuPiy7UT0sW4b2gLPV3YQ6/63X0fSLz34eGVYp07LptG+mHmasSWm4+JKg?=
 =?us-ascii?Q?ckaVCqiDKRl492qXFWB09/6sY/jTrZnIsW2AhfhIYoqvAdI36S9jrzFv0za/?=
 =?us-ascii?Q?VEeyBa5sgxbKUWW0072a1sLMXtWJNloq7g2JMNvB+1QkhhVSotZN4WOyBwpJ?=
 =?us-ascii?Q?crCJmU/gQeEfGYzPo2P70hbodteoNeI1NL0HbNCDbvn5yy7qMeDJFcAjOUNx?=
 =?us-ascii?Q?6dz2+G9h+6AxpfIlHQ0tDsH0+5YEhIuzt3EQDoxVAMig/TNISSwFOp/mNqU4?=
 =?us-ascii?Q?R+qpd2XBnLMw3vhhA7r4FNm0BQpt2vE6t4C6UXPWu5rAboLber1fmwt20wYF?=
 =?us-ascii?Q?C9YOhCyfbMb2/MD/R5w=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c36cf1d-f5ac-4821-6ee4-08dc841cedfe
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 22:31:36.7838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ap/V1o3mHQwDEcfJ0pFOvUkoOsE/VjKX5qHU8sRXJy+cPVkJ0AbF6qw+BQqvrgMt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6778

dmam_alloc_coherent() already returns zero'd memory so cfg->strtab.l1_desc
(the list of DMA addresses for the L2 entries) is already zero'd.

arm_smmu_init_l1_strtab() goes through and calls
arm_smmu_write_strtab_l1_desc() on the newly allocated (and zero'd) struct
arm_smmu_strtab_l1_desc, which ends up computing 'val = 0' and zeroing it
again.

Remove arm_smmu_init_l1_strtab() and just call devm_kcalloc() from
arm_smmu_init_strtab_2lvl to allocate the companion struct.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 27 +++++++--------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 6b4f1a664288db..d27dd0600bf1df 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3220,23 +3220,6 @@ static int arm_smmu_init_queues(struct arm_smmu_device *smmu)
 				       PRIQ_ENT_DWORDS, "priq");
 }
 
-static int arm_smmu_init_l1_strtab(struct arm_smmu_device *smmu)
-{
-	unsigned int i;
-	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
-
-	cfg->l1_desc = devm_kcalloc(smmu->dev, cfg->num_l1_ents,
-				    sizeof(*cfg->l1_desc), GFP_KERNEL);
-	if (!cfg->l1_desc)
-		return -ENOMEM;
-
-	for (i = 0; i < cfg->num_l1_ents; ++i)
-		arm_smmu_write_strtab_l1_desc(
-			&smmu->strtab_cfg.strtab.l1_desc[i], &cfg->l1_desc[i]);
-
-	return 0;
-}
-
 static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 {
 	void *strtab;
@@ -3272,7 +3255,15 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
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


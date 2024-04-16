Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2083.outbound.protection.outlook.com [40.107.101.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F66D137C49;
	Tue, 16 Apr 2024 19:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713295722; cv=fail; b=OsWHeWKOI/U0fZmuYWnVNnMk62jotxoX0lijrnl2SznNl+7n9MQimir3UKx67t+fDRpDVTV6hEYRuRHjhwRKFyGzXAJA5YPINV3FQZj5goyoU0pj/dNEzpFl6TMpKiisNlKDmPK/u0NSjPNqcUGa97GoHm22i68C1xsBOfj9H/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713295722; c=relaxed/simple;
	bh=JT1Zpgo+5QNeSWP/qKyhESE6Po1pmpSCLJK4Qxl8ifc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z2gum4vrrzqWFcMFMPYa7E/y2zV2FkGv/dcvcvfEsoRVLrxuBpLnXrz9b1kpWG+2tCa7PmTAQMNxRZGB30iSlM8wAgzM6nmOOaMMGNwQX+vox1BeQYhFIxQpar0LOn8jC3FCaXj7aebi7jkjELGp4gqMjt1gCvpYM9kdEnl0nII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IJHEwyR2; arc=fail smtp.client-ip=40.107.101.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IJHEwyR2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UObruCvevDKE9mP9KnbrUBfFe0ab4Rk6QiysMRggsePgXh8pAkVHLh4AbG6RkSzMnu8mc2vIrSk/9eT1xX8ui2E+G0F0v1Z6qju0yKqa06EBGyQTHTRvdpURCg0u3Do6ommDZaiHqln0sqL6cL9BZ7CWP1lgPDJ6uEw2zPWPWtq66BRcJ89PrKi5NdNIh2+ZC8QFfMx2jx8sFX3wETS+ArjbfWCofuD/0UY5SDbDUVhmQ0IBW23wWnGzB7GMNVFWhmnDxyBz9IrXc+mLdVRKqnDT5+iMbRsPa3HcWNNFkFiBlx9/FxZ0oOb6RYOHnd4EFEkjr0tUDiVktcjCz0Sriw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=taoiH1AVBd3PfWHuo628rJ9YiYQvL5ZYmxibhBx3s9I=;
 b=WF6min7GGpeV2k+d8T6yn6+zV5NM8jbvI2ekMPxieQMcsGJqn6ZLP95fD4vIQUDGID5FseexmxdFhfjNNwpoafZHaxSCKwlZ2KikIACwPprtU7IOnWBEjsyT+yfrlEewbWC/ZZXWyHEKcq9258N8o7eb5zvRzQ2Q23OpiJWWkk3lkW879+HdcR1QH02Q8Jb09qrATJ4xOqTZX0pNrUYBLNaLYdu75a5M1vZFEGVtTZ9533DrajxL8lNmgoagKnWSulG3IDrwG70wXY/R4mS3NMStPnekgNyOYcjjD+zJ1dfUaVw7FxgaqywI5+nk+mt5Vm/VYLKMaIGCi5jtRjPtaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=taoiH1AVBd3PfWHuo628rJ9YiYQvL5ZYmxibhBx3s9I=;
 b=IJHEwyR2ylCtE0XXsh1v/FeRZdQzK7UBJKt+wPpA5Pm5RWPwW/TvgjxrTV2crSG1RfTZRvnKlwN/2SNayvw+jmoBnPvBCeKmtbqWwgLoXGNCgIE5SU5E0VuSV8H/mg5hyfV0fHjPKoGen+uPNGGfGL5tvAYohGljLpmQQ+8GfW0K40BVC5cXikCkHpCD4TX+0jU/LNYEm0Wd9QdztKg101RkFCk6PG1ITzELglzZHfTFmEiuG5Kw5nK/1Epkj0MHHmEO3bsNhi5SgyICyMHo+wzdGKGwy0kCWhcQEXc5EuPgjk74e2uUd41X8nHH3q5+Xes+PHXipyuCEILFkJ4zwg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB8213.namprd12.prod.outlook.com (2603:10b6:930:71::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 19:28:23 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 19:28:23 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v7 8/9] iommu/arm-smmu-v3: Build the whole CD in arm_smmu_make_s1_cd()
Date: Tue, 16 Apr 2024 16:28:19 -0300
Message-ID: <8-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR01CA0005.prod.exchangelabs.com (2603:10b6:805:b6::18)
 To DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB8213:EE_
X-MS-Office365-Filtering-Correlation-Id: be5bb160-4c0c-48af-271c-08dc5e4b6070
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	q6HyVaxCQ1neWYGkUj44hDmc+9WuY2Gr4pdKSbsvltyMfP/a/80wors4TC/7hKL6Ap364gnMegituctrp4/N3XQ18Wq42CbRPlb8PrKhw5juVhba48/oZtDywIvVIJOpRfTi1CNI5Fttlo80G3qlGo1GL1g8dGBV9zrN9ZDbdQeIM0Yv6euXPffwR+PjV2IdnWgjxQwxu8HR1RtUprIsGQDJAo9u6+9KvCQxKNnS6N4ThxZxEdpTdQLrWJ8ySzSOQ1J64SdtW7mueKHsxsWTz5Sh3UX5fyScsWdxToMnqcV+B4G0CKM3J6Lf/VpPqk8I0FxlLWZpDIr2VVkFBZP9sjnHN/tBnJPHbkFKrLlQ0KSABYBaq1HMk1C1w0gph3id9LHp8IAehQOgTi2xJu3m2wkNIfHvdDTmaZH2nPL33ACupc8DOhjD9129syOlmzn6z9KSFgVizxPzVcu6d9ZMph285w382xpw9v/DE00owFiNDOwhVCwbs9RpXF+3uvPzMfz/9ypKY9BrnThMA6hT01PVjrKwTZ1yqGEA3vhMeWB5iJRqVzYkeMv7oMuX8b+x2Cp71LBY1YfwhQZhTNNn3/1Bi6R04M4vRRJ85nTOpUo5UZoIs9uCcGQoSxWWPGxNKTnHNJCRiiDZEP2oLtPho3nm4XvuMhoAHZMvsZKlhdU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Vk0TC7SnjwnbwZNJaklygXRmNK5yZDX0aZcexyHWwfhyVfWw8N32anWjUbDy?=
 =?us-ascii?Q?iQf7iQ04N98K4yFN+g5rSKzi7dmL2/9faIOo0TpM5SCw2xdZys47u5wS6SJd?=
 =?us-ascii?Q?VBX7E7az/8jaTbPFd3Yjg6Qh4J1DG57ZZtR3q4cpCvKAcbCdX3T4RaL+E3/o?=
 =?us-ascii?Q?F4vuETih/o3fdxZ5O6hPVUESk6CMvg1tGIKKkTdWyQuLnYdYGsEmCEbuGDRV?=
 =?us-ascii?Q?3joDxA0kzQDr5+sl9rDvpg8/6eD4797m2igpEMN7mk336Ff0SGYLIAKboTWw?=
 =?us-ascii?Q?6AaRT19ZYbJMyttpzL4FC8LDKkRlNL5ttlO7yNu6ATrxNUgRzrktpAxvIW9t?=
 =?us-ascii?Q?8tPr8i5TXuh1FkLvbHzazof9lT1cfQvNJJWQs0LqwiBZvo0HG4zebf1yqp2U?=
 =?us-ascii?Q?5jMk+F4E3etoPQiSBIIZxl/L/G+7hFnVFYXVIs7i8Ujlz0glDhYi5CZ6b3Ci?=
 =?us-ascii?Q?imuuDhN8goA9NRpoAb+HA2yhjthyFoWgOm5G6CmbENqZQb4Yvvz5p1naNqOs?=
 =?us-ascii?Q?MyCq8xmmojeWiWRbMaNGsb21k8lENb5Fw6HcWJIu+Nfxfgd51Zqfp9aOSt/Q?=
 =?us-ascii?Q?IXj+5/wsM+RhL78sD+1bYYvt0nfBdKgUdQUHX1MvqVwu4ZKh4vKBtAlqI1N/?=
 =?us-ascii?Q?xZIyR1AIi80g75o3Hy7LjLvUnc0Gfj7JAOXL+FTmHVeJ/lAuWOH/ZUAwKAZN?=
 =?us-ascii?Q?LoqqRES+vLTdb5GMkW6s2/qs8IgrfiSZgt45vOi4g4O1G4BOJ7dNRod3FmVF?=
 =?us-ascii?Q?PCJy7fecqikagovUUY6zZgUo/DScLyOWqc+GTpqFSUZpW6GTuFTrDvjZZJlZ?=
 =?us-ascii?Q?09wzX5GPiKxr+wdzotJ84KucU7UQe8xsGwPpR9q+PMpqK98Rhl6Zksytn8hO?=
 =?us-ascii?Q?QGczs2mW+V3pkfl6IPti3cWmZpE/cbEkEokzVx/NuzTwcDSUcQulbOIxU6sC?=
 =?us-ascii?Q?oL0HV7QWGiCq/rSIJuOz9bj0X9h3DdvfQqGrRTlQjzblxYWE7cE5B22oaJiq?=
 =?us-ascii?Q?Rkn9J7sOd/GNvxqp6IzZ6gFAyqAlceU2QOoDDBFsDVBY/Fn7LH5g65H0NGJw?=
 =?us-ascii?Q?/cTj1r2ewx6EIerPnQHU1UcNMsql6nJ2+3XVQdRHOUkmff8eonqhvtNAAxV+?=
 =?us-ascii?Q?cBySZeMyFPHyyOmcrT6uBLdLcgBQroSF2v+DBRsXpszom0TS5tlldo662oEM?=
 =?us-ascii?Q?jVxLYzsEsmoV/qEvn4Rh2o2MNIL95GzLmaD9Xmc2Gv0oIbg4zu2GOhIwtIoL?=
 =?us-ascii?Q?0Uz8j7ok5JgDt9UiWFcNyW9RTa6TCqM0jkeF7y3X9PMA7aQra+8KsZHZHnF+?=
 =?us-ascii?Q?gQ6U5vVCJR3NKTqGuY1LX1rG5vC9YOwfdoeWq96QJgcEg/55Eoyaej2z9MQC?=
 =?us-ascii?Q?5vJrv7WqavVW13gi85IKPEZj9D3LBr5SqlBItguKniAFcUF73wmsVfl3rWus?=
 =?us-ascii?Q?OSFFhUZxshwU89JjzB9qxdUHo6dqjFzO/WqM74EktOtGBm9H+H5saUsqesTR?=
 =?us-ascii?Q?rDpo92Fg6rGH01n3gf8/tBuTyw+EK8RqFFgof1cBxu1XWFXrSLKv/P6GNATO?=
 =?us-ascii?Q?dk/OhJJtfEhIQytDAhyeDfnrBnfExVn/CiohY62w?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be5bb160-4c0c-48af-271c-08dc5e4b6070
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 19:28:22.1390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PajoM7KhWh9eX9+rkfIM7xZqsCuNvru9Xif9beobB71hNg5o44AEFCzCoZALYH3Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8213

Half the code was living in arm_smmu_domain_finalise_s1(), just move it
here and take the values directly from the pgtbl_ops instead of storing
copies.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 47 ++++++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 --
 2 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index d01b632197c0b7..72402f6a7ed4e0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1308,15 +1308,25 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 			 struct arm_smmu_domain *smmu_domain)
 {
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
+	const struct io_pgtable_cfg *pgtbl_cfg =
+		&io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
+	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =
+		&pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
 	memset(target, 0, sizeof(*target));
 
 	target->data[0] = cpu_to_le64(
-		cd->tcr |
+		FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, tcr->tsz) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_TG0, tcr->tg) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, tcr->irgn) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, tcr->orgn) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
 #ifdef __BIG_ENDIAN
 		CTXDESC_CD_0_ENDI |
 #endif
+		CTXDESC_CD_0_TCR_EPD1 |
 		CTXDESC_CD_0_V |
+		FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
 		CTXDESC_CD_0_AA64 |
 		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
 		CTXDESC_CD_0_R |
@@ -1324,9 +1334,9 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 		CTXDESC_CD_0_ASET |
 		FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
 		);
-
-	target->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
-	target->data[3] = cpu_to_le64(cd->mair);
+	target->data[1] = cpu_to_le64(pgtbl_cfg->arm_lpae_s1_cfg.ttbr &
+				      CTXDESC_CD_1_TTB0_MASK);
+	target->data[3] = cpu_to_le64(pgtbl_cfg->arm_lpae_s1_cfg.mair);
 }
 
 void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
@@ -2284,13 +2294,11 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
 }
 
 static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
-				       struct arm_smmu_domain *smmu_domain,
-				       struct io_pgtable_cfg *pgtbl_cfg)
+				       struct arm_smmu_domain *smmu_domain)
 {
 	int ret;
 	u32 asid;
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
-	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr = &pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
 	refcount_set(&cd->refs, 1);
 
@@ -2298,31 +2306,13 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
 	mutex_lock(&arm_smmu_asid_lock);
 	ret = xa_alloc(&arm_smmu_asid_xa, &asid, cd,
 		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
-	if (ret)
-		goto out_unlock;
-
 	cd->asid	= (u16)asid;
-	cd->ttbr	= pgtbl_cfg->arm_lpae_s1_cfg.ttbr;
-	cd->tcr		= FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, tcr->tsz) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_TG0, tcr->tg) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, tcr->irgn) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, tcr->orgn) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
-			  CTXDESC_CD_0_TCR_EPD1 | CTXDESC_CD_0_AA64;
-	cd->mair	= pgtbl_cfg->arm_lpae_s1_cfg.mair;
-
-	mutex_unlock(&arm_smmu_asid_lock);
-	return 0;
-
-out_unlock:
 	mutex_unlock(&arm_smmu_asid_lock);
 	return ret;
 }
 
 static int arm_smmu_domain_finalise_s2(struct arm_smmu_device *smmu,
-				       struct arm_smmu_domain *smmu_domain,
-				       struct io_pgtable_cfg *pgtbl_cfg)
+				       struct arm_smmu_domain *smmu_domain)
 {
 	int vmid;
 	struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
@@ -2346,8 +2336,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 	struct io_pgtable_cfg pgtbl_cfg;
 	struct io_pgtable_ops *pgtbl_ops;
 	int (*finalise_stage_fn)(struct arm_smmu_device *smmu,
-				 struct arm_smmu_domain *smmu_domain,
-				 struct io_pgtable_cfg *pgtbl_cfg);
+				 struct arm_smmu_domain *smmu_domain);
 
 	/* Restrict the stage to what we can actually support */
 	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1))
@@ -2390,7 +2379,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 	smmu_domain->domain.geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
 	smmu_domain->domain.geometry.force_aperture = true;
 
-	ret = finalise_stage_fn(smmu, smmu_domain, &pgtbl_cfg);
+	ret = finalise_stage_fn(smmu, smmu_domain);
 	if (ret < 0) {
 		free_io_pgtable_ops(pgtbl_ops);
 		return ret;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 8098bf8836a180..8f791f67f9f7f4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -588,9 +588,6 @@ struct arm_smmu_strtab_l1_desc {
 
 struct arm_smmu_ctx_desc {
 	u16				asid;
-	u64				ttbr;
-	u64				tcr;
-	u64				mair;
 
 	refcount_t			refs;
 	struct mm_struct		*mm;
-- 
2.43.2


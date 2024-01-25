Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB4B13B795;
	Thu, 25 Jan 2024 23:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706227071; cv=fail; b=YBJ/9Sd+X+a7ArSImjbD4IgQ9jFS6J66KsqrpWqHNUDNj/At6JmKFoju14DmhIrUpQIJVHYWcA9cwhcUV2qz/bVLV2iuO2Zr8HHYqNs/1xzkWTcQjpSnu/NoTeKqoL52C20ZOWCmupXaRdYFqAU9XrRAPFjbllvM7ubY4xznnjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706227071; c=relaxed/simple;
	bh=T0UY0PKpFZyWtL3Oz11nZuRbI4GWf3JiDcPhlfnpF3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pugz22t47JGZhkn2l+iDEQnulrTtdpEbpeztqjMDe7/H32KNOUpV5IQ9NrO+K5/mjJ8hUcNyuXrcPnyPAU7/LDWbSyPoVas4r2Cp9s7vrCpUemGjXdZTOSuEGNOeSyKPt7bskP6OYepiTdExjiE90y4KKw4TA435HSXiMQIXfQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=q5s105pl; arc=fail smtp.client-ip=40.107.244.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="q5s105pl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fliMKW6wFo3KqxhnZeLChftZCrlaD5KCOdpIEr+rdovurosTNoRrwsPQqN4hKiHlszZBDwCb3X2Opdq5F/s4PeSU9A/r6Fxu3JO/1WQr6dR2Rm6oimY13sNYigXGUbIntM+yY9xvf3FPmn9eCqpiaLsHDofBwZ0mXmHnYqq/gJuNwu//WKJ+GpHWDoqYVmdiSbaLAvICbnOBPdsaCtOOXo6KA/59hr+/eBPsLIJFZjJT6sXkTTAA6ynG2UEMcsPewx7uJYes96G6lFr/WePi4i5L70qJAc3a/57lHVr+u8uEPLFl7VrsjPRg1eoH7LiWvdgLvO7q/ZPHnVTvpocgog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EXBdG6x59BYBIEfcytUTgWGIVzbNdAceHkSaMhsELPE=;
 b=MuU4XX4ynXlAqU5sozauD4DUc2DjrelNUnUQC2C15c6D3qj9cKS9Y1OKzoAk9vqpndxtS2/QQ9WJfqtzpkgMsU4O71m+XnrOZK9dXYKaHzAN9E1VbN8vIiFQBNI4XFpg3LH1rQneVyi++F9090SHGEVR+C06DSI2vH0ExxDp/TvRwZ4TYgghBQ0yTz87SCXvnuoIcrsWwP12iJsaCd9ye4F9TYk7NxHDge4i5EYbasc1dgke5k2URLHE43aYVtY5gzpCY/Aa7kbNBwDDxOV/rYa+hKnv1hOt2cwph6KpIzyaY+4DHikvQy0TMSQ03mGMbPlb/uOm4gUw/3mLnHsvuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EXBdG6x59BYBIEfcytUTgWGIVzbNdAceHkSaMhsELPE=;
 b=q5s105plSfCm146esfLpnNVnv84cFjPgzz0DqHJjZxdd3Oxgoen5TZ2jwISv6i3A7ZbdLqh+qvXnSP0uYiVO73a7S2dw6qS14CN4dkBqOkMWKuPHR/11MHHphnEfLnyamQRISDormgo8xusWyeNRAG3eYjNSgw9vyb4sa/AB6eXP6XkAmEuX+KkqqcL5aSD/Md1dSxqjVr/dbvF0EONIStfMz/r9of0NgLu5i1UPDb1yfGF1c4/irNqd4qXtdJYPD+IsoddVEiDYs4y56ZxuRJONAiHifN4VPW5y1f33QCcRXoHDzKq3rwnZJhXkBdN6tdZc7qv/TxGljHSdGdtd8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7881.namprd12.prod.outlook.com (2603:10b6:806:34a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.24; Thu, 25 Jan
 2024 23:57:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Thu, 25 Jan 2024
 23:57:37 +0000
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
Subject: [PATCH v4 02/16] iommu/arm-smmu-v3: Consolidate the STE generation for abort/bypass
Date: Thu, 25 Jan 2024 19:57:12 -0400
Message-ID: <2-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0047.namprd11.prod.outlook.com
 (2603:10b6:806:d0::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7881:EE_
X-MS-Office365-Filtering-Correlation-Id: e7b3d1e2-420d-47b9-8c29-08dc1e01641e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DVI3vzvM1Sp2+qZNFjPRxRa8o+PbBZxzjwoAJyNG2u/C/g0/8vnR4F4Jt8vqqc7PRAka84iw++K9WXjO2Tp2UEtESCe70pwCYaI3jM6xS4AX4wzXnL0Kd4GFQQC012SPX1vYfh0N3GYrNyt/HlnkHS0oPU3c7yvXRgYQsQjoAK5PNKZlfAY8wZH+kMcb+SDacMWTzcMIfrYjA/YprwjFcxH+m6sh9EbYtJtrMKYGTxOYCnrreRKZEcWf1RcJs1h52D8GqBTzEEd5Eg7JrwhJ1Nn3LJ0Bgd48s6R6v4qOSoVg1F43yxl7GLF6b2ucGc26dvVQV0ImuPiAEOtXa4fYpmXBQ9LmlRehfcUbIdfOUPFCg2IWI7vz+WLWoFbTadUEOOs2kChSunsbl8xf1w6F1ZYkqqalT1A6QYMzCl5qxWG8DBGtOrARsrzB56RTAaUO38HKYcxn8gsh2nECuRDPxBdrGL1j8bdvbQ5wDmSiPCDCDS+2F/6vEc0ZTQBlHATr8zFXITY6eL+3SkK0UPdAneobDOvYtRpKP867rLiWlXURj92iuEJ7zYVMXxktPfcld4lHLhD+YHHUBQXEBpOVkVgpgpKyuApV/QqaeRBqR5E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(346002)(39860400002)(366004)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(83380400001)(36756003)(66556008)(86362001)(54906003)(110136005)(66946007)(66476007)(26005)(38100700002)(6512007)(2906002)(2616005)(7416002)(478600001)(6666004)(41300700001)(6506007)(6486002)(5660300002)(316002)(8676002)(4326008)(8936002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IyL/rDvnRf1u7GRWRB6Y3kMoFhi22238lOt0//pn4A96Lt3eJ6vtijkpVUBO?=
 =?us-ascii?Q?+EtcS9vyXcBnyRePsjT6tLrsHKrByT6BQFCUfZTGfuhbQhfM3T3yz1BAMyQF?=
 =?us-ascii?Q?B45heCf1xjdI6Tfd6Cw7WO+v8GI/zMkTuFE94BrtofYb+Tt7we5GsmgwxcFO?=
 =?us-ascii?Q?AZvl21Ih78nS+W0Xg/zBcmhfcTZq3YyDK2n7Z2yKurFp5Nuruinx/G8h+Gtj?=
 =?us-ascii?Q?g2YCo4nQ6lQ5RxFYiOcbbM+1jZR18xUSWRUnnz1o4W+sd2lw5zJ+oDFw2614?=
 =?us-ascii?Q?bBTNumJBrsGXcle/nuPXjBBboy80P1UnIf8/5D00eeuFhYGw2YfUq3Zu6X6/?=
 =?us-ascii?Q?8CbWtg1l8ZZypO07Ayd5TbogHTpdYudywQ9AETBH8Na74PdYQEPQS3mEkDbe?=
 =?us-ascii?Q?/tP1PPEYQ4iXo0XtY3lqsvYwNWpo36uqtRPJtpfOkjeqIhlZvw714g5EDeHp?=
 =?us-ascii?Q?ThoSBpKmiAN1lGPc5m8ghfquSZQQmD432YMCBQHf5rpKWVMLxN1OCrhUNITS?=
 =?us-ascii?Q?s1Fydix5igKwy443XhGLBT//5Nf9oBfBSvNnT1lhHvaBdZsgko1JGsAdPp3B?=
 =?us-ascii?Q?w9c/mbjQXxKOactIdxBXdeH3zOR/uDh/Nh87cpbIjFV7FDCYqoJMHeVRZ4JZ?=
 =?us-ascii?Q?JOft+ki0UMjwSX/dV/1jTfPnluAAlCZRINMtCBxQkvYTFmQPRpu+o7c852T4?=
 =?us-ascii?Q?nnERgnB60qWxRZeF83aww4f8UzHR5eCpRkqgwc2TNcgDR2qSGk3ZqN1JKzXu?=
 =?us-ascii?Q?ekj6iH7XMIEGp51d3besmjyoQ4P7NrSavHhQMZRxVjCP43CrR2f+WMr1C+dE?=
 =?us-ascii?Q?uER6fqtMD6abhuifoB7S/7c+2nh0h1hN/B+OF6YH/+lNpCtYVNDshf4o4TaB?=
 =?us-ascii?Q?TQemhRNtr2q+Vu31wFELumMg4ZP+PhsQXu8hU3NbuidgT6Ox5hLC5aEegsc2?=
 =?us-ascii?Q?YP4QL95QHakcb3EiwxKN+rXQae3TJgxTJCAVi+TYkPpnWvWjevoJy6MK/1XW?=
 =?us-ascii?Q?1cQ2aoM227W04tHfHl8UnuFdQqkMoMt7Y/cJlIADC5ZFwtlqPqABiL5gu3Z6?=
 =?us-ascii?Q?SmlQO7e4MZGxXF9bezB9i7ex9X4b/4KLYzdFGmXTTYj9vNGue6V0yowjPBkU?=
 =?us-ascii?Q?ugmfwbwJHcun//Xj28hc5mnDlzqFttSDhOdYvdx0qOJM/5xcBFhVNdZAq99N?=
 =?us-ascii?Q?vQIjkIbNFlRc6ZZVamuqksuGJkYon57Rb2TetpSCaSnCNVOqFesMXslj41fk?=
 =?us-ascii?Q?mWYLjHoxj+ey63BSLsZNlg/sgqBqsONsLhkeVkIzbZpPu8ZHWm/ag6LUt7y7?=
 =?us-ascii?Q?I5UMpUXAx50P7AFLjeAfEMbhz/lXdeKJzY0LVNgGsa+ZdA0195aizroyWwFu?=
 =?us-ascii?Q?xXtfGSlCkwDOB0Jq7ijqvfcLOzlm+h7OFO4eT/Yj/7tNQ2l5JPm3PpJ1XsV0?=
 =?us-ascii?Q?p03B+oex4okZwYniezAwPAEnFW2DxEP0E85EAGdb03dd/SRIRNm7RNOisDj2?=
 =?us-ascii?Q?YmSd3wMlACPcT2l6ROmMwdQegHSDAsu3ZXm8ypdDXj7nkW+8YBmVdeIHxWY9?=
 =?us-ascii?Q?qUe3h7hxnhTnSN3qQtqI8xKWTPrjrFRcHldF3F66?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7b3d1e2-420d-47b9-8c29-08dc1e01641e
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 23:57:30.4185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6In3mdzTNEK0HAHfFWjA6phm8l4hAyP9rqnQsbbXvBKC95GKdD9538kADwbnq3dJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7881

This allows writing the flow of arm_smmu_write_strtab_ent() around abort
and bypass domains more naturally.

Note that the core code no longer supplies NULL domains, though there is
still a flow in the driver that end up in arm_smmu_write_strtab_ent() with
NULL. A later patch will remove it.

Remove the duplicate calculation of the STE in arm_smmu_init_bypass_stes()
and remove the force parameter. arm_smmu_rmr_install_bypass_ste() can now
simply invoke arm_smmu_make_bypass_ste() directly.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 89 +++++++++++----------
 1 file changed, 47 insertions(+), 42 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 690742e8f173eb..38bcb4ed1fccc1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1496,6 +1496,24 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
 	}
 }
 
+static void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
+{
+	memset(target, 0, sizeof(*target));
+	target->data[0] = cpu_to_le64(
+		STRTAB_STE_0_V |
+		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT));
+}
+
+static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
+{
+	memset(target, 0, sizeof(*target));
+	target->data[0] = cpu_to_le64(
+		STRTAB_STE_0_V |
+		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS));
+	target->data[1] = cpu_to_le64(
+		FIELD_PREP(STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
+}
+
 static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 				      struct arm_smmu_ste *dst)
 {
@@ -1506,37 +1524,31 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	struct arm_smmu_domain *smmu_domain = master->domain;
 	struct arm_smmu_ste target = {};
 
-	if (smmu_domain) {
-		switch (smmu_domain->stage) {
-		case ARM_SMMU_DOMAIN_S1:
-			cd_table = &master->cd_table;
-			break;
-		case ARM_SMMU_DOMAIN_S2:
-			s2_cfg = &smmu_domain->s2_cfg;
-			break;
-		default:
-			break;
-		}
+	if (!smmu_domain) {
+		if (disable_bypass)
+			arm_smmu_make_abort_ste(&target);
+		else
+			arm_smmu_make_bypass_ste(&target);
+		arm_smmu_write_ste(master, sid, dst, &target);
+		return;
+	}
+
+	switch (smmu_domain->stage) {
+	case ARM_SMMU_DOMAIN_S1:
+		cd_table = &master->cd_table;
+		break;
+	case ARM_SMMU_DOMAIN_S2:
+		s2_cfg = &smmu_domain->s2_cfg;
+		break;
+	case ARM_SMMU_DOMAIN_BYPASS:
+		arm_smmu_make_bypass_ste(&target);
+		arm_smmu_write_ste(master, sid, dst, &target);
+		return;
 	}
 
 	/* Nuke the existing STE_0 value, as we're going to rewrite it */
 	val = STRTAB_STE_0_V;
 
-	/* Bypass/fault */
-	if (!smmu_domain || !(cd_table || s2_cfg)) {
-		if (!smmu_domain && disable_bypass)
-			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
-		else
-			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
-
-		target.data[0] = cpu_to_le64(val);
-		target.data[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
-						STRTAB_STE_1_SHCFG_INCOMING));
-		target.data[2] = 0; /* Nuke the VMID */
-		arm_smmu_write_ste(master, sid, dst, &target);
-		return;
-	}
-
 	if (cd_table) {
 		u64 strw = smmu->features & ARM_SMMU_FEAT_E2H ?
 			STRTAB_STE_1_STRW_EL2 : STRTAB_STE_1_STRW_NSEL1;
@@ -1582,21 +1594,15 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 }
 
 static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,
-				      unsigned int nent, bool force)
+				      unsigned int nent)
 {
 	unsigned int i;
-	u64 val = STRTAB_STE_0_V;
-
-	if (disable_bypass && !force)
-		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
-	else
-		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
 
 	for (i = 0; i < nent; ++i) {
-		strtab->data[0] = cpu_to_le64(val);
-		strtab->data[1] = cpu_to_le64(FIELD_PREP(
-			STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
-		strtab->data[2] = 0;
+		if (disable_bypass)
+			arm_smmu_make_abort_ste(strtab);
+		else
+			arm_smmu_make_bypass_ste(strtab);
 		strtab++;
 	}
 }
@@ -1624,7 +1630,7 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 		return -ENOMEM;
 	}
 
-	arm_smmu_init_bypass_stes(desc->l2ptr, 1 << STRTAB_SPLIT, false);
+	arm_smmu_init_bypass_stes(desc->l2ptr, 1 << STRTAB_SPLIT);
 	arm_smmu_write_strtab_l1_desc(strtab, desc);
 	return 0;
 }
@@ -3243,7 +3249,7 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
 	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, smmu->sid_bits);
 	cfg->strtab_base_cfg = reg;
 
-	arm_smmu_init_bypass_stes(strtab, cfg->num_l1_ents, false);
+	arm_smmu_init_bypass_stes(strtab, cfg->num_l1_ents);
 	return 0;
 }
 
@@ -3954,7 +3960,6 @@ static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu)
 	iort_get_rmr_sids(dev_fwnode(smmu->dev), &rmr_list);
 
 	list_for_each_entry(e, &rmr_list, list) {
-		struct arm_smmu_ste *step;
 		struct iommu_iort_rmr_data *rmr;
 		int ret, i;
 
@@ -3967,8 +3972,8 @@ static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu)
 				continue;
 			}
 
-			step = arm_smmu_get_step_for_sid(smmu, rmr->sids[i]);
-			arm_smmu_init_bypass_stes(step, 1, true);
+			arm_smmu_make_bypass_ste(
+				arm_smmu_get_step_for_sid(smmu, rmr->sids[i]));
 		}
 	}
 
-- 
2.43.0


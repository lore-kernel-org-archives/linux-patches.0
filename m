Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA537D080;
	Mon,  4 Mar 2024 23:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595867; cv=fail; b=c4/91kRSknYv0fnJT8y3V1M16mINILQHOlqbMhN4NpL9yGNTFsqMxHLbDemaqT7aiIn4y7m8ctqD4v2L3AOyWKrOw/4mJVbfrT5b75p5stQNo0FSFVCLYs4qh8ZvgogidqZuKaiAItV/VP3tn2u6iSmrn7CAeyu+UtgPEPJFL4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595867; c=relaxed/simple;
	bh=+AARanSzfGY+8ts4PjkywAkYDqYXdSpIGIPXuBFhKac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BRCcLEalkWmkV/YeuisDc6YisAENBJ3b8NVtVJS6AbmLsXDiL/Csoz+9uI37CG9+0nDofeC78nEKwt5CMkHhi1tGzu9FE7AJkBPUwT+L5sw59wKuuiVNyjiB7hlcafkHRgpmf63yRgn9bmdaVr7Ab7wtNeWliPoTPyAOYOhNjZg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WI9JSSy/; arc=fail smtp.client-ip=40.107.94.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WI9JSSy/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J+/1iSoZ+Raz8nNcJ9MMejIhljBKWXFIBVXOAzIYmgLsRoI78swJYpWIa22tiWYimm13p4nAj74oy57SUrd1jMNdw/Wu8W3BofV8pIqXYC1KiJE+vVJtI1IwjyQNNqsbZAFENjBWczxVHDjmwdJg+ftQXYRA4BpAN3efOwYlrMwZNvulw98r1l9cyYCbs7hmzqVBOZS2/ZsI1xfFSS1MTwlTUACkqGo6P6bx76IFDXbtomGj2jI8zBbOuS/NkZEPVIY/eukR63MIGnEqiO1mBs1jHM5N4MsrlLkwktcOFTpkOBTx93UA7gdqFm+pUb5Qy0Bxc3eD7j9zaMiy5/wulg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cJgwdoDaW47suk5Q2w2veOLO9v8O8xdVOnj4yobDwx0=;
 b=DWRLsJOoLlXiersZSdZ/AZqyOBGh7DZZaT6kzgqEH663etDeCMKeoVR92nXUXfxPC51mkGsYFzacpsy1K3I1qXn6F1eTbo7ODzNsPn0QRQyODFXyMweOpLXufE1aqXJF0CqEwv86BQqRVCgFkP84tU3LcXwMosnLhzN9zeyMy3r3OtBI6OpoJWkb39GW2Y8CHvNIWMnZAtNC3PnU+Em1/g4eyYM86IVHwjp/Ilhl4M9hi8/BCspUX4Iyuf3EmBhYwtor6JP7jo1VzrJyXcgaVpHyuZsDnO3Nml39RvT3p9OQPMj3Mm537+auFuZA7G6COtY257LrK/S864eXk4wq1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJgwdoDaW47suk5Q2w2veOLO9v8O8xdVOnj4yobDwx0=;
 b=WI9JSSy/p99RNF+dLZhG+QdAGRDIKC/R/EcB3QcogzYQd5XMP4k5rbYY+lts/SN36r+fOAbO9fGb2vOPWKlGh54EY71dK40TqlnxHV0KFMwhgeHq3vRWFyieUoAn6lRBn5F4jKYoy1oVMHWKRgaACeMu9CjpMrdyFLUwBPPBatWER5QM0z/ooyG9ErR90bBfnoObMfCMENh0pUkvIaFsS2LDFzeeHqlDqZi+JcZ56FXtr8WXsxpiS2DgCqvkQE1GgzrdtS3e3lNoostBHHWN/hRdgBQmKdEIiogbIdxZ3h38H9MUwooT6ZYrBt1y18MotNEEOstW78gFMZ+M4P1oDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW6PR12MB8949.namprd12.prod.outlook.com (2603:10b6:303:248::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Mon, 4 Mar
 2024 23:44:17 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:17 +0000
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
Subject: [PATCH v5 11/27] iommu/arm-smmu-v3: Build the whole CD in arm_smmu_make_s1_cd()
Date: Mon,  4 Mar 2024 19:43:59 -0400
Message-ID: <11-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0043.namprd20.prod.outlook.com
 (2603:10b6:208:235::12) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW6PR12MB8949:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a7b9749-2d42-4e99-1371-08dc3ca500c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9WV+yIsApOPQf5KOaQf7HWfhoct315s159Ybk7RfN1hlIyrL3NQ+IoBLRk7Vj1yonkWWCSenDEfd01LjZUJKXwVyDIuObhPZJeMOdx7Vrc0krzcN5HCv1jGj0uKBRd9PYF3dHfuoHLFsZ9o5X1zY5qdV3lzQcPGHnWwHSu5hep2ZADfBZZB/rDAuAjjuY2yyWbklLgQus4EP9we3BPbly0vKufotgihXEbDMuqoQhdIUwESBtz6BSyAxUKs2nBPITbfIbxhosiyXT8UlVYvt2WsZoidz89erGdNkRb/hufg4AG/vGy1tYvoelu8p/vTiQjrDVgDOPesHwjef/EO2yCmjOF/3eHszX0+Ojf+x1mWa6n4r94dvgejhR7g5fcH5WsEew7km6VuteCoRibBZcBSUvfNgZUSB89BqTqjbcz9Q125GziSXets61sF4pVpH3PNJ4QKD9eKhwcn8rn7QySIXB2lES1fdzZQ+1TW8rRfgvQYqGN5dlHEEqRR98xNBMoEgL885sVQF9VVsBQM6A/GFCFvtjImZZ+yJ6mJuju6UOPRWYu1OUuuLEep8SuKgl0az/tY8sYHpomZmE8tqiFrXktY6oj63uTojJLiaTo17bwUaJ6k7nmtcAyqaMmYHqwceXGKi0Cl+CrgOcvh6pJqf3JGgfWpzxM+Fc0YC/jg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r/k/ODh9SKaRwX2PrHg/DRq+P8jyS7mmxT3R7pTdUWLp7FA1M7Q/2xNYWxu4?=
 =?us-ascii?Q?ibYISDGyDcgHmmoC42k0df2MhfC17LxIH1YzajskVjbXJNGAP8f8Xp87ryFB?=
 =?us-ascii?Q?OR7+Y7S9rO1bfuVk6GW8KeIztpQpzHlDdR3j8h+yj/qSBhQrR7eyeSUjmXQ5?=
 =?us-ascii?Q?be9EKVwxgPpo5bHWxZyHNhvDaVAAX/2gE26DtIvdyWIQvggtfuLrYLg3Tyss?=
 =?us-ascii?Q?yP0D/4s5xu4n43ShHQJ6KjpMSgnC6B5+ZrjoLv46X7AfaK7056pi8A8e/2jh?=
 =?us-ascii?Q?P3gsZJ+gl5o2J+Pb9Y56F/JIJT3gOKqsz5IcT9XhHmXEQMWkQQPrpI5+eur3?=
 =?us-ascii?Q?/4PxhCXoPBSsMv3id+Q2MZwdBEU4BCWtjYxywoCDyi0INdkpMKDr2zcDxc/8?=
 =?us-ascii?Q?YbuFsvx1+33KlraCy38Sy8iSvODdv4V8wGDHpUjvSB8F8xfo7MNXQYdKCldd?=
 =?us-ascii?Q?wa7C2O7TSGbX2u5Wt4maylvD/WhM8BzF0fzSUwNc8AXloZBY+uoPZYbG7jAK?=
 =?us-ascii?Q?YAyMBXVGXhMLsqY4n1yy8+lDLoX0CpjJPVT+EhciHx5AUDumPOXOIMLUre1D?=
 =?us-ascii?Q?iBAYLP391r+u3d0lM8BpcLBTXXZGpeYqZkoK2r0ms9IUJWMKnAPRNelAHhDK?=
 =?us-ascii?Q?1DgXFBTViYcfXWjrq4M82daXEzbWtaixjRgs/CT8a0CMj5PmKpfwtcnvklX0?=
 =?us-ascii?Q?QfWhCa5QqcmbwkD+nZEQEq4jdT6JGwZy2rrVjFyFC+kTVTgTQr+1/SKgQhSD?=
 =?us-ascii?Q?8GHXowjANQwj75VStW2AHvfFXdIXMuwcWqYEe/cQijfD04zO44TV9CDyePyc?=
 =?us-ascii?Q?vmfy9vMoR8NuS7D4cxY+/EjaXzJIbYwnxetOPoUPfyDee+3xV1lKBMbprS0K?=
 =?us-ascii?Q?aOdmUTxkVDDtXghO/a5qz+FV/PM+Y9/ciJH5djRbSBfik4gJQ9ljDl3JNcex?=
 =?us-ascii?Q?nUIbv1DhnmoAaBPXfannpY4nJYyq8/oCUzMwfuul7fjL66RyUqm/6ktdcrxC?=
 =?us-ascii?Q?iUVDm/rpR4ptF01vdxhn6N3yy1+xE4gf+X+gQPND5SML3PAlLkzwGrsl/UZd?=
 =?us-ascii?Q?qc3abI1SkCylZ/2FfP+AHzaujrq0FgTshoBxRMK4CaWwJxLrAdVMVtxrV8tn?=
 =?us-ascii?Q?q0PDD4Xk4erzBps2iDyNuQ5PIGNmpzMkEf6tT+iQJuy+sIojGy+eCRrTwNXI?=
 =?us-ascii?Q?Ls6Hos22vJSZtYn0WAUWBDmMz09cPZAoYbOlVNrl3+aR79B2Z1M6I+qSlSFF?=
 =?us-ascii?Q?q+tAlp5wRNir6Phv63VJta1/M//9gUpawrW3XDnTx58Ae+ilsrlooA+1Sx47?=
 =?us-ascii?Q?LbiQgY0x2MDtj5ZxyhX2CvZJHb0vnHVgHY0KBR8bH0dbRTBWDI+U+js8YSW4?=
 =?us-ascii?Q?KCmfU4dlqMcnm3FiDW4ltBCsXhHlVOSNSyLA9N6bKzGe22RGfoTwGbHqAvDd?=
 =?us-ascii?Q?UjpBMe4qTNiM0AUmyBWO46/vSpc2VBYbJYgm06PDCTExy2YLdZ/CyZQaezGv?=
 =?us-ascii?Q?aP4klQbE4AXUqn3M8dHxTjx9Qx+W2gO6aGMCsGCE5DF4J//OXDWX/1+h9B5t?=
 =?us-ascii?Q?5lsfCok6DCLpbpKBeBgNjrqpXaoS1dJlPt57RBdT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a7b9749-2d42-4e99-1371-08dc3ca500c5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:16.1328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l+vlukmtIcPeOzrYEhnFDzwHKRkAFpNEEXHXKu2yxBz01FpFM789+D18+TDD4zkD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8949

Half the code was living in arm_smmu_domain_finalise_s1(), just move it
here and take the values directly from the pgtbl_ops instead of storing
copies.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 47 ++++++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 --
 2 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 50d17e3ce0a956..dfdd48cf217c4e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1301,15 +1301,25 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
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
+		CTXDESC_CD_0_TCR_EPD1 |
 #ifdef __BIG_ENDIAN
 		CTXDESC_CD_0_ENDI |
 #endif
 		CTXDESC_CD_0_V |
+		FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
 		CTXDESC_CD_0_AA64 |
 		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
 		CTXDESC_CD_0_R |
@@ -1317,9 +1327,9 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
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
@@ -2305,13 +2315,11 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
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
 
@@ -2319,31 +2327,13 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
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
@@ -2367,8 +2357,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 	struct io_pgtable_cfg pgtbl_cfg;
 	struct io_pgtable_ops *pgtbl_ops;
 	int (*finalise_stage_fn)(struct arm_smmu_device *smmu,
-				 struct arm_smmu_domain *smmu_domain,
-				 struct io_pgtable_cfg *pgtbl_cfg);
+				 struct arm_smmu_domain *smmu_domain);
 
 	/* Restrict the stage to what we can actually support */
 	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1))
@@ -2411,7 +2400,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 	smmu_domain->domain.geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
 	smmu_domain->domain.geometry.force_aperture = true;
 
-	ret = finalise_stage_fn(smmu, smmu_domain, &pgtbl_cfg);
+	ret = finalise_stage_fn(smmu, smmu_domain);
 	if (ret < 0) {
 		free_io_pgtable_ops(pgtbl_ops);
 		return ret;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 8eabcccb9420ba..468cd33b80ac35 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -587,9 +587,6 @@ struct arm_smmu_strtab_l1_desc {
 
 struct arm_smmu_ctx_desc {
 	u16				asid;
-	u64				ttbr;
-	u64				tcr;
-	u64				mair;
 
 	refcount_t			refs;
 	struct mm_struct		*mm;
-- 
2.43.2


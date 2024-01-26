Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B69D208BD;
	Fri, 26 Jan 2024 18:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292942; cv=fail; b=Sd/QCcMviQFR5MTj7o4qIPSPyXIP+NOGknaRitX0K4xRffe8CprFt2JHCxRQGemelsOT0dkB90DNyCbDPyyl2C1DujghfhbJIrRy4jEdIH5/D7e/ZvK1tI29P7A8mfioGQvi6vvTf09nSTM9stW4BRL2e6n/bhIKcrNcy0nXmjs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292942; c=relaxed/simple;
	bh=ZhjRhrimw3/sUbbYBRuL2ormoPciHfDpg96uhxQhmxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nzfOwHDpzzrcEO9tLoShsaxWKWcUwuMyeauv7tfry8reu4Z9qThdjAyAAwL/krwLYswAncbNqwo2fldogjbOnol/1qIf2NiezcO/8s6M8FkcDN0q30q53/sUMclCho2ZTTsCMMt1GtAJwvCwLC/iIrubKO9jUUrDFXAthwA9R2w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=T3fWv1lm; arc=fail smtp.client-ip=40.107.93.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="T3fWv1lm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EKlXhVsXKgM83O0AhSlSHQ2SBsrx7N//PozAB0aeIVzy9H0CkLotR1Z9BZszlTaoQmLx9zwmQtLq5RZIBNXL0rWkk5XNeT9WN815+IHpFX8Hr2xupcE9Xfiq53XKXQBpl+I2r8TVyFHl/yHhx3SlW9AUuYDlTz71oHw7cCamI92GxYiXy3cgSZIVpOLfWwnpHtsbZ4QPZpjwTB/tzfRaz+StKe6ls5x4fMC2ucSzM3htdH1Wd5D8Y2bwLuTAp39UPwKy7B+YTHMP8vGZQBRn046T3UzUX74YFitPQtIsXWpWjBA/Vw0XYFhH00kPT4OVsIOyILllahpWUdXIOsdUHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o9BTvMUZH5hSgv/bpXNVHGWCN+MUXvdNLoc8gNQOuRY=;
 b=Eww4s+3zkF83sfJhpqGu7REx7INBo+GyHzuh0ThjdGPey7iQRFGxyYZUztXjD3Kxpt9J8mt5NI79+3wqJMG0G9LoF4pBKXISBbzN56QocqLBhsaivZs2UYYqJvW7xUk7t/V9R48yjIa8pD/NjdY/akPBjnGMs2Buubc1KcBNJ1yNSNLtenV5TTGoOfTfeaVXPBbzXweMiztF+XkPPIVn4uF4EfdZFCt34moGd/QZa12RG3rhuAKLQO3cB0G8e7RsMay5CyT1fmiV3m2wKCOC5uyjY364LQUQs5Ww5dqHE8XcDCtx5BctH058tawMcFeKRr9ps6RvBMGhIGw6weKceg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o9BTvMUZH5hSgv/bpXNVHGWCN+MUXvdNLoc8gNQOuRY=;
 b=T3fWv1lmbqn1OSgC84oTHR1rqj29XiRNja5/iuFK0sxjK1LwlIjgOfOLwC5AaxLglDsfVFN8iWdXsFOzB5J6PZlbWEobFyau9jvoOIX9hT9uMaVMVH6w5MhdYOZ5zhEmT/CW4BPFmduSfGUZNujNnEJnxuNVf+NfYcqocSxEKiLBtXCpHVvr6LuzW0DYVEdzTPDtsMGGur4G1RPeRTXA+KRFc+NmJA3XH1ZD08Ljt4nh6jagGVCUJ2r9Z77NLUww7beNrHATY3GRfaATZP7VVYEsErwD255I0veErH1+T2Qj3jXywYCazqQgpCU8askS0PmUiExzMqBmoxVWeQvFTg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7185.namprd12.prod.outlook.com (2603:10b6:510:201::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.29; Fri, 26 Jan
 2024 18:15:36 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:36 +0000
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
Subject: [PATCH v4 23/27] iommu/arm-smmu-v3: Move the arm_smmu_asid_xa to per-smmu like vmid
Date: Fri, 26 Jan 2024 14:15:25 -0400
Message-ID: <23-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR18CA0018.namprd18.prod.outlook.com
 (2603:10b6:806:f3::10) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7185:EE_
X-MS-Office365-Filtering-Correlation-Id: 855a518a-02b1-47cc-eba3-08dc1e9ac875
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Z3/zntsMh1i/MWtqwx5iQh04k7XlazYH+gMi5fgKIulhV/t6uKsLcki+cFGC9JwQBwUm221hTkthq4wfey955n032HEpdMDhg9YLXf4wh18zh576x1w6wjUtQIRnzHBywiBpFFKCYEGgUkLSYuQ9PPqIgxcrqFnbhOtiSVMiUOm8EBUEmrZhWrs/Shsb+5UryYCiG12vbLzwwVF2UQh3EtSZmMmipRHrk5Dco56qSVjjecSYxDk5csop+u8fGL3I70pdkmVPLwExv0Ks6YzgbiM8vh59+pR3tjuO/QjmwzflnReKewLfaaL4f4AxZmOqZwFlycuxZLRh48rtx8KX9FAnhDCqleDo9ZMvyX5zm2No3lZ7lBhE/BBs9rSN2EjyoQKEX85ubRm+9S6RLgkkAy4PQBodKU5yYoCzKsTn9KHqahZkDB2SPFwpRTPAhCROE6TevwYsuLfdPB7WN0KPUlGcVjkEHlZq86KcQMdJTxZB51f+nKNBnmwrT/jMT906WEfxqJ7czbPRgWQWZpYEUhGkW7M3il+lbqW6IcHqXKlKzOiruiL8HLlsSzX7LBDw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(39860400002)(376002)(136003)(366004)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(8676002)(5660300002)(66946007)(316002)(66476007)(478600001)(110136005)(54906003)(26005)(6486002)(6512007)(6666004)(2906002)(8936002)(7416002)(2616005)(66556008)(4326008)(6506007)(36756003)(38100700002)(83380400001)(41300700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tgCrSyTT5EG/Fux3Kf+4bwSgGY/fdoQsvmYsZkN6MdrTv5CHzINwu7pig1Gs?=
 =?us-ascii?Q?wwEv1UvJJLXeAI1SVMW0GjeMfDdr1SfIg/EGcJEWiDTd2Rm2y7Y4edLLNjEk?=
 =?us-ascii?Q?8iqICtIT5MNRmjAbarRcNY3HCququXIGqbHpwSE63m+CVNX4bsBCr3mGdhqi?=
 =?us-ascii?Q?1mIMOqur7w0xmtgMRQW4+xb2FqPSeTHg47mh89qXSbaPPcqR3tXTSPty5pU1?=
 =?us-ascii?Q?ywpcaP50xR+OoXANFoe19MOfTUiTnskIGclyVFzhpJ4YW1LfiyOM4vX1mM7s?=
 =?us-ascii?Q?1A8dSWC0CULcacssdznpwmSuLsPyVKrWSQpnEjvPjXAyICdzxmBqioxACvnu?=
 =?us-ascii?Q?aWdHpLwi80JHchuhggQFMGBOCpzZMwX1j4rweqEUYycdqYscZdMx8+zBH1kP?=
 =?us-ascii?Q?fAk+YsvW9FZ+iJXAS1i8DiIhdtyCErY98oC6R5QyjG/B3H5w8qL5xW8a1GaD?=
 =?us-ascii?Q?pL+pT30XQnZ67cc5La6W9iirkVAPWLZkiE+zH6dGLBPigglSPy2ygTmvEtdl?=
 =?us-ascii?Q?bw61Bg7ro9EBKV6aQCEVQEPaWmtZcMSM/GHu1++mq2CytPaslqJeNKvu5iGw?=
 =?us-ascii?Q?q39lipnnP5Exr4R0/SQGMCZHdK8cRaghgLMMZnwPhfA/eF7nLyVJ5VaZAcYi?=
 =?us-ascii?Q?uwtngV7saAMPwyhJft5j8DlW82P9SsOFDmeUpQcEJUw1TA1uz7wZ0PU9C8dn?=
 =?us-ascii?Q?KH0Oa7koAc0yTyXCqV04Q4bjE5T/gh0AYDYXWzD7zA9yvi4tuxhw/gZMzFvB?=
 =?us-ascii?Q?eAsafb+ml3F6NwYmFysKPIgDQEvUHPa4ZVnar48ITRN4850iwJCbMpNcYhqw?=
 =?us-ascii?Q?IlNMiq2ldff1j+3zCot+XUXzz8WPhpzJVB2uuE3d5lfILUKsjjW+HbKSlAck?=
 =?us-ascii?Q?u3RCcj0EvUnEzZux0sCYZyCqEVOwDkhtQYOU+BPHlnD9LCYqeCZ/mWeJIoUZ?=
 =?us-ascii?Q?mG6OOFVKwpnuwzSvX/9JHaG/aqGzgMaKOXPpdMRJRYx3GHfem5TgrkVA776s?=
 =?us-ascii?Q?nyYicvyE3FEcbjePioj62ThfrYjMKd0N5wgGf/70Vr6os5sIhs+e+kgc+xkS?=
 =?us-ascii?Q?UdR4LjZWkCsI7zEOjUWOjiIkTS4BnfvxHxlf6Kh+QM9ztWjJkrmk++aNat77?=
 =?us-ascii?Q?BkYuEpFd2TnA+VVHuSnPsVWNxLvsHkyt+P4v6ERBAiLUcmk2MSfTsJtgsw5u?=
 =?us-ascii?Q?zZcDlOVmfGjIirKdVcLDCzhgWlBEPrMpt4c3w2UXI+mpYJMeQ4Ey5dbTfzVg?=
 =?us-ascii?Q?PFrgfXlpJ7CFj4LThbcSVzNukRcMyuEuLY5i1R4z+t/CaOXAlbtpdd/sDGv7?=
 =?us-ascii?Q?v3SQTNBuwDv6wS8Ujwt5wkUuPA37OILoJsr1EmuSw965wpuVbNZIsm0GA3J/?=
 =?us-ascii?Q?YjVkvcIKZVicrwOMQF1Sz/En8rVtd3nX+BLDqox3bxU8PYbwzzApzbvPWhv0?=
 =?us-ascii?Q?9eEKOPE9F+HH6+5Zb85QZnClYVC04JmSmgrCrAjTL6cE07EjhJlIl/ow51D3?=
 =?us-ascii?Q?hm9KxCS7hkSVoWvUwUkrOS3DKhjbQLRGgczluUPaeZvPb7mS5VL1wsqVkeA2?=
 =?us-ascii?Q?LPz2Eg98/LMt+g7WzfMxSst0q+wQIZhC9onaII2s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 855a518a-02b1-47cc-eba3-08dc1e9ac875
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:31.8789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DzphO6KTqVkotlEhJtSjgqSLvfDoBm18YMPN1iwntTdt+/1xNV+jERqPlzcLIHsc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7185

The SVA BTM and shared cd code was the only thing keeping this as a global
array. Now that is out of the way we can move it to per-smmu.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 39 +++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  5 +--
 3 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 46b4b7626a7c2d..080b84a3b78ce4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -418,7 +418,7 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	smmu_domain->domain.ops = &arm_smmu_sva_domain_ops;
 	smmu_domain->smmu = smmu;
 
-	ret = xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
+	ret = xa_alloc(&smmu->asid_map, &asid, smmu_domain,
 		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
 	if (ret)
 		goto err_free;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index fc7824c8decb50..be95f29e80df6a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -89,9 +89,6 @@ struct arm_smmu_option_prop {
 	const char *prop;
 };
 
-DEFINE_XARRAY_ALLOC1(arm_smmu_asid_xa);
-DEFINE_MUTEX(arm_smmu_asid_lock);
-
 static struct arm_smmu_option_prop arm_smmu_options[] = {
 	{ ARM_SMMU_OPT_SKIP_PREFETCH, "hisilicon,broken-prefetch-cmd" },
 	{ ARM_SMMU_OPT_PAGE0_REGS_ONLY, "cavium,cn9900-broken-page1-regspace"},
@@ -2299,9 +2296,9 @@ void arm_smmu_domain_free_id(struct arm_smmu_domain *smmu_domain)
 		arm_smmu_tlb_inv_asid(smmu, smmu_domain->cd.asid);
 
 		/* Prevent SVA from touching the CD while we're freeing it */
-		mutex_lock(&arm_smmu_asid_lock);
-		xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
-		mutex_unlock(&arm_smmu_asid_lock);
+		mutex_lock(&smmu->asid_lock);
+		xa_erase(&smmu->asid_map, smmu_domain->cd.asid);
+		mutex_unlock(&smmu->asid_lock);
 	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S2 &&
 		   smmu_domain->s2_cfg.vmid) {
 		struct arm_smmu_cmdq_ent cmd = {
@@ -2331,11 +2328,11 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
 
 	/* Prevent SVA from modifying the ASID until it is written to the CD */
-	mutex_lock(&arm_smmu_asid_lock);
-	ret = xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
+	mutex_lock(&smmu->asid_lock);
+	ret = xa_alloc(&smmu->asid_map, &asid, smmu_domain,
 		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
 	cd->asid	= (u16)asid;
-	mutex_unlock(&arm_smmu_asid_lock);
+	mutex_unlock(&smmu->asid_lock);
 	return ret;
 }
 
@@ -2622,7 +2619,7 @@ static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
 	 * arm_smmu_master_domain contents otherwise it could randomly write one
 	 * or the other to the CD.
 	 */
-	lockdep_assert_held(&arm_smmu_asid_lock);
+	lockdep_assert_held(&master->smmu->asid_lock);
 
 	state->want_ats = !state->disable_ats && arm_smmu_ats_supported(master);
 
@@ -2674,7 +2671,7 @@ static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
 static void arm_smmu_attach_commit(struct arm_smmu_master *master,
 				   struct attach_state *state)
 {
-	lockdep_assert_held(&arm_smmu_asid_lock);
+	lockdep_assert_held(&master->smmu->asid_lock);
 
 	if (state->want_ats && !master->ats_enabled) {
 		arm_smmu_enable_ats(master);
@@ -2736,11 +2733,11 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	 * This allows the STE and the smmu_domain->devices list to
 	 * be inconsistent during this routine.
 	 */
-	mutex_lock(&arm_smmu_asid_lock);
+	mutex_lock(&smmu->asid_lock);
 
 	ret = arm_smmu_attach_prepare(master, domain, &state);
 	if (ret) {
-		mutex_unlock(&arm_smmu_asid_lock);
+		mutex_unlock(&smmu->asid_lock);
 		return ret;
 	}
 
@@ -2765,7 +2762,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	}
 
 	arm_smmu_attach_commit(master, &state);
-	mutex_unlock(&arm_smmu_asid_lock);
+	mutex_unlock(&smmu->asid_lock);
 	return 0;
 }
 
@@ -2795,7 +2792,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	if (!cdptr)
 		return -ENOMEM;
 
-	mutex_lock(&arm_smmu_asid_lock);
+	mutex_lock(&master->smmu->asid_lock);
 	ret = arm_smmu_attach_prepare(master, &smmu_domain->domain, &state);
 	if (ret)
 		goto out_unlock;
@@ -2805,7 +2802,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	arm_smmu_attach_commit(master, &state);
 
 out_unlock:
-	mutex_unlock(&arm_smmu_asid_lock);
+	mutex_unlock(&master->smmu->asid_lock);
 	return ret;
 }
 
@@ -2821,12 +2818,12 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
 
 	smmu_domain = to_smmu_domain(domain);
 
-	mutex_lock(&arm_smmu_asid_lock);
+	mutex_lock(&master->smmu->asid_lock);
 	arm_smmu_clear_cd(master, pasid);
 	if (master->ats_enabled)
 		arm_smmu_atc_inv_master(master, pasid);
 	arm_smmu_remove_master_domain(master, &smmu_domain->domain, pasid);
-	mutex_unlock(&arm_smmu_asid_lock);
+	mutex_unlock(&master->smmu->asid_lock);
 }
 
 static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
@@ -2842,7 +2839,7 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	 * Do not allow any ASID to be changed while are working on the STE,
 	 * otherwise we could miss invalidations.
 	 */
-	mutex_lock(&arm_smmu_asid_lock);
+	mutex_lock(&master->smmu->asid_lock);
 
 	/*
 	 * The SMMU does not support enabling ATS with bypass/abort. When the
@@ -2855,7 +2852,7 @@ static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
 	arm_smmu_attach_prepare(master, domain, &state);
 	arm_smmu_install_ste_for_dev(master, ste);
 	arm_smmu_attach_commit(master, &state);
-	mutex_unlock(&arm_smmu_asid_lock);
+	mutex_unlock(&master->smmu->asid_lock);
 
 	/*
 	 * This has to be done after removing the master from the
@@ -3509,6 +3506,8 @@ static int arm_smmu_init_strtab(struct arm_smmu_device *smmu)
 	smmu->strtab_cfg.strtab_base = reg;
 
 	ida_init(&smmu->vmid_map);
+	xa_init_flags(&smmu->asid_map, XA_FLAGS_ALLOC1);
+	mutex_init(&smmu->asid_lock);
 
 	return 0;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 4e8806862ebeeb..e8aa78fc0b8a0e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -675,6 +675,8 @@ struct arm_smmu_device {
 
 #define ARM_SMMU_MAX_ASIDS		(1 << 16)
 	unsigned int			asid_bits;
+	struct xarray			asid_map;
+	struct mutex			asid_lock;
 
 #define ARM_SMMU_MAX_VMIDS		(1 << 16)
 	unsigned int			vmid_bits;
@@ -753,9 +755,6 @@ static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 	return container_of(dom, struct arm_smmu_domain, domain);
 }
 
-extern struct xarray arm_smmu_asid_xa;
-extern struct mutex arm_smmu_asid_lock;
-
 struct arm_smmu_domain *arm_smmu_domain_alloc(void);
 
 void arm_smmu_clear_cd(struct arm_smmu_master *master, int ssid);
-- 
2.43.0


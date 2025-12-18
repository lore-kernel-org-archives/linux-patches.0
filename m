Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010054.outbound.protection.outlook.com [52.101.46.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207092D97B7;
	Thu, 18 Dec 2025 20:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766089674; cv=fail; b=g6zlyYGi76POHWbVQbgaNPD5azOYNA05bu2ffwTjJQBddDC4KZkBCeNrPMXMk+EsLu8j3K3igjjyD/pUQUjwOGYNaRpPH9ARy4WdKFtj7rdoVB1tYALP1+FW3zaHDfZfk1O/D1/hfpLi68yowagh1dZcz6ZM1hjPuHygvuwMgOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766089674; c=relaxed/simple;
	bh=/GASm9qHhW+dKEa59bx+yWdyfBeLH9GhUhR6eBaifO0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NRxRu2HCqfBeOqrYkoWvBc9otwU7uplJBkHh4KvYujGaqOkgxGN7wSMGDOFp4yCJTd9CiHhSsrmsEe1YJrhcq0N1sVWZTBaaVReXCIwAT4nveJU2CSETUWbh3xQ0WiznBirDN3elBYWFcsPJ3tQk3pFRD3RMgp60ob1jVy2P2Dg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BnjvxAZD; arc=fail smtp.client-ip=52.101.46.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BnjvxAZD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oyvm9AlwbCm852fcasrDjJDEIv+Gq4+C/THyJihCIkWsqUVKsDT+LdsZfozpeb26eFxPhbUQ8QQWPm9tp5v9h1MY5tpevImzQVoV/LZz6C8VWAi5NlUGPzCAn/GBULoQosBJ7aREUPoHiS47wVVEdMV0h2XUpvdDE/+WlvTkgx+5E9XumNcmDVvLFI0ZK3opmt8tlkI5VqtikF+SxYiN2iDoqc+c1MhWZ6Utyp3+YFRh7ICr9JiET2HWicD90eHwVq4T2dqHB6e3FhY3yB3HpxD9oa4HG6MzyFi7d8LB+97rXwIECrF92fYWMdtbKJcCxvQsKu59dV/oDSuYDMHHug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mNLVwd/PFgZ5VnGcg4fTiIVtRP69yNj9dDPBroiCSjY=;
 b=GoYnc0Okv3eezL4tS5BQEbTIAYB3gy3175oFntrsobk8qy97ibNHdRSeMp+OQfgAzEuM2/maL3o+EL+GjRsvJcaf38hgucgud50Bj6Ew/WAcZbYgWPRJtm+DaMv/MGp60ANeqbtu2Y/estxSztvjDpjox+4q36/q/MV1ZB1unYU8tdm2akdZ9fGaNjZ5vM2rlVQr1/kgZXDmBFMJQmlRcoijHntaQ4rI4KpzL7H71EcwAZxTKyQOfTFmm4TP4T9XpI7z2wmYqvCXDcGrsSdZH1a2jDiMywhp2k1qOmWwTsZx6aHU0tfqaPmwPkuAn7NhTuAzZ3oflGmeFZVzcdXXFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mNLVwd/PFgZ5VnGcg4fTiIVtRP69yNj9dDPBroiCSjY=;
 b=BnjvxAZD3o3oGs8LzXsmpIZ55miYiQB+ra/qAg200Tzg/Xy5fWo4nxhta6ucMU8cMJy9FpW0OglkDUP1hlNEpWTQ+E11Xs5J5/JxrPaMEf9DknVDdFMeguihvqvy74pMTqkDBZRuAdEMzNBxZBX/aSk7MUhFfQEEV7+VMM6uIs+5UB52Anp7zK0mj5EXP5yuoJIxZ8WhqLqyg5ufQJU6jJh2yRmIQiVaODX++K7o2qdmjYvH5d4/kB6MfzTDWNZeIX78frz4ZFZQRvpNCZitxF1dCfCnjiwfOV5LdotIGf1K9Hjte5TPNx31ZUq1Xfr/fIrbfUnXAJHA1/nvml5BgQ==
Received: from CY5PR15CA0206.namprd15.prod.outlook.com (2603:10b6:930:82::20)
 by DM3PR12MB9326.namprd12.prod.outlook.com (2603:10b6:0:3d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Thu, 18 Dec
 2025 20:27:42 +0000
Received: from CY4PEPF0000EDD5.namprd03.prod.outlook.com
 (2603:10b6:930:82:cafe::bd) by CY5PR15CA0206.outlook.office365.com
 (2603:10b6:930:82::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Thu,
 18 Dec 2025 20:27:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EDD5.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Thu, 18 Dec 2025 20:27:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 18 Dec
 2025 12:27:19 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 18 Dec
 2025 12:27:19 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Thu, 18 Dec 2025 12:27:18 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: [PATCH v1 5/9] iommu/arm-smmu-v3: Install to CD/STE the ASID/VMID stored in the master
Date: Thu, 18 Dec 2025 12:26:51 -0800
Message-ID: <1fe65cf21f9eb6c82fde80a6591c644d7224146b.1766088962.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1766088962.git.nicolinc@nvidia.com>
References: <cover.1766088962.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD5:EE_|DM3PR12MB9326:EE_
X-MS-Office365-Filtering-Correlation-Id: 250f2417-5ff6-4bcd-5d45-08de3e73e568
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9kmPFWMf3kDPDx41M1zI5/PCStPiQoqMT4Gz1eHVaqYFTQjyWBfaMhdghSLo?=
 =?us-ascii?Q?G414iNi8AEZah37UQcXIHOkt5hoElhCtIhUviMMEUljNvSTCuLkZMAz+9Aqb?=
 =?us-ascii?Q?rNhF4YDCoWge3Dr/t5aHWb7/mRBUzcxg+5IQr0kdQnwmz7p0boDbEB94+ILI?=
 =?us-ascii?Q?r9YHyCoAucQUmWk9y4JG7IbVpATApIOmiogNlU21sCriMCzOknzh+o60ZJ3z?=
 =?us-ascii?Q?dGtDik6lbmmByNwmeU4KMX9o83rNkU7Mv9A6Gkmb7vdPanLMPvLDdihL4lQD?=
 =?us-ascii?Q?w4xAVcdkCDtj6B0eWhORaSbqv+RV74QmQ84YPhmeUaMWDnJSNQ1iQwbNn3s1?=
 =?us-ascii?Q?zkgiFgkYi6cZEAEw057YrtsLxIsKHqiM8at3yZ/K46ym+dxwu8Npzttl19w5?=
 =?us-ascii?Q?cNoH4jmfauuv8kUPQB0szbr1QMUqypFuUcwa+3W29miqjQUMygQ6Dv1FJ0sQ?=
 =?us-ascii?Q?czzHXRPwxIYs9bN2T2ekg1yrVtnPXX7/E53bHcwbDMw13jBfgfIw8PuPpufe?=
 =?us-ascii?Q?n8nLCuYCD6VzfsQDypFi2hH+xODjk6o7ZEl7ssPa25528C2liY8olb2/bwgd?=
 =?us-ascii?Q?HVHljsF+beFLDpaMutkoDxs5riiAQbMPWFRxZSJOWNhdk4EzvUxZt6Ea2yzT?=
 =?us-ascii?Q?YCYI6buXGg9N5o8z2N7CeC6QyLFkOk94n95J1m4YkldIQrGUhqDG8WP9sAOH?=
 =?us-ascii?Q?XMBUZguGhQzv+a6W2oH8lAvwE8TDNUxHdH5BKVqa0egOlZbJVnAa3VcUlJOa?=
 =?us-ascii?Q?9h9xn1OmmeDlL5F2bI2/0LTzOtsLXyBWd983jokLSY3Nhq2twns44W2jX6b/?=
 =?us-ascii?Q?OnGKb7OMQtw/IMLoC2TW1yj2n+gkNVU8OBEF6/GAsq8kj6JISBBPXWUsbCj+?=
 =?us-ascii?Q?auizcw8dYHu+5cquo2exNFMkisQ3Fzo4O+xJefoQ8bfZcpZaz4uyjcijCXdf?=
 =?us-ascii?Q?FWhBAYatgIwd853dEF9DseUiNqDKnVrKmjvPkfYBHwtlU/zaBUsjFp2OG2YR?=
 =?us-ascii?Q?k0PS18uTzHDtkNHCZVWMYa95lft/5XVNxP+BMmuDYcNC16DR/P2KAIjInXX0?=
 =?us-ascii?Q?IKVMM49p2s39N/IKeIQjLWEkANX638Q0svtpdAXd11i92q8Rx1J7FP6yJjbo?=
 =?us-ascii?Q?r1CalbVCYr8VXhillw792cblNNZGBMCbV/JSLfkqR6RUNUG4by4y7h1adkBw?=
 =?us-ascii?Q?lgOsaBUCH8hQ2Gurj93/CGijpAg9VS6Eos2aBTe5EF8NjXh9rCK9nJjEQU6I?=
 =?us-ascii?Q?8gFm/AzW7UyFdEbB0BP9FibSgWDG6hl9OEQHZvvM34/7QJoY7sOTLQvzty7R?=
 =?us-ascii?Q?5IYc+6VblDNFqY9MrgGv9Ug3OthIymjrr5gGng/7p7h1SscsMuOp6eW5A3N3?=
 =?us-ascii?Q?3XBx5xezFEINdXc/ODq+0KjptDX+zx5YlcOd9yWw0Dc9zsF/kM5udCFAKIBp?=
 =?us-ascii?Q?gCAYz44j7dwlXyDg0+7NHvP+qHjnlqLXYpwQAIWkRMQUcg+aT2zZfEl1eb21?=
 =?us-ascii?Q?/A/c+sMtrANonvsYUAwyQtp9O5IOLqK9VDm6Hnm8FMb0tD2o5X+2xhruyymP?=
 =?us-ascii?Q?1Mim9eq/UXd2YUhA+uU=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 20:27:42.3128
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 250f2417-5ff6-4bcd-5d45-08de3e73e568
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD5.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9326

Now the iotlb tag (ASID/VMID) allocated in arm_smmu_invs_merge() is stored
in the master, with a proper release and revert pathways. Replace the old
smmu_domain->cd.asid and smmu_domain->s2_cfg.vmid with the master ones.

The old asid/vmid will be depracated.

Note that the nested pathway needs vsmmu->vmid to be updated to align with
the VMID programmed in the STE as its invalidation code will overwrite the
VMID field using vsmmu->vmid.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h       |  1 +
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c   | 15 +++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  4 ++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c       | 10 ++++------
 4 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 230ab902a9b6..dac412ff0d71 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1186,6 +1186,7 @@ struct arm_vsmmu {
 	struct iommufd_viommu core;
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *s2_parent;
+	int nr_vmasters;
 	u16 vmid;
 };
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index 93fdadd07431..1c877d30f86e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -136,6 +136,19 @@ void arm_smmu_attach_commit_vmaster(struct arm_smmu_attach_state *state)
 	struct arm_smmu_master *master = state->master;
 
 	mutex_lock(&master->smmu->streams_mutex);
+
+	/* Clear the old vsmmu's VMID and set the new vsmmu's VMID */
+	if (master->vmaster && master->vmaster->vsmmu) {
+		if (--master->vmaster->vsmmu->nr_vmasters == 0)
+			master->vmaster->vsmmu->vmid = 0;
+		WARN_ON(master->vmaster->vsmmu->nr_vmasters < 0);
+	}
+	if (state->vmaster && state->vmaster->vsmmu) {
+		cmpxchg(&state->vmaster->vsmmu->vmid, 0, master->vmid);
+		WARN_ON(state->vmaster->vsmmu->vmid != master->vmid);
+		state->vmaster->vsmmu->nr_vmasters++;
+	}
+
 	kfree(master->vmaster);
 	master->vmaster = state->vmaster;
 	mutex_unlock(&master->smmu->streams_mutex);
@@ -454,8 +467,6 @@ int arm_vsmmu_init(struct iommufd_viommu *viommu,
 
 	vsmmu->smmu = smmu;
 	vsmmu->s2_parent = s2_parent;
-	/* FIXME Move VMID allocation from the S2 domain allocation to here */
-	vsmmu->vmid = s2_parent->s2_cfg.vmid;
 
 	if (viommu->type == IOMMU_VIOMMU_TYPE_ARM_SMMUV3) {
 		viommu->ops = &arm_vsmmu_ops;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index adf802f165d1..0e534f2b72e0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -164,7 +164,7 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 		if (WARN_ON(!cdptr))
 			continue;
 		arm_smmu_make_sva_cd(&target, master, NULL,
-				     smmu_domain->cd.asid);
+				     master->asid[master_domain->ssid]);
 		arm_smmu_write_cd_entry(master, master_domain->ssid, cdptr,
 					&target);
 	}
@@ -266,7 +266,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 	 * This does not need the arm_smmu_asid_lock because SVA domains never
 	 * get reassigned
 	 */
-	arm_smmu_make_sva_cd(&target, master, domain->mm, smmu_domain->cd.asid);
+	arm_smmu_make_sva_cd(&target, master, domain->mm, master->asid[id]);
 	ret = arm_smmu_set_pasid(master, smmu_domain, id, &target, old);
 
 	mmput(domain->mm);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index ec370e54b1bc..d6ae630d0de3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1661,7 +1661,6 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 			 struct arm_smmu_master *master,
 			 struct arm_smmu_domain *smmu_domain, ioasid_t ssid)
 {
-	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
 	const struct io_pgtable_cfg *pgtbl_cfg =
 		&io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
 	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =
@@ -1686,7 +1685,7 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 		CTXDESC_CD_0_R |
 		CTXDESC_CD_0_A |
 		CTXDESC_CD_0_ASET |
-		FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
+		FIELD_PREP(CTXDESC_CD_0_ASID, master->asid[ssid])
 		);
 
 	/* To enable dirty flag update, set both Access flag and dirty state update */
@@ -1945,7 +1944,6 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				 struct arm_smmu_domain *smmu_domain,
 				 bool ats_enabled)
 {
-	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
 	const struct io_pgtable_cfg *pgtbl_cfg =
 		&io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
 	typeof(&pgtbl_cfg->arm_lpae_s2_cfg.vtcr) vtcr =
@@ -1976,7 +1974,7 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 		   FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, vtcr->tg) |
 		   FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, vtcr->ps);
 	target->data[2] = cpu_to_le64(
-		FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
+		FIELD_PREP(STRTAB_STE_2_S2VMID, master->vmid) |
 		FIELD_PREP(STRTAB_STE_2_VTCR, vtcr_val) |
 		STRTAB_STE_2_S2AA64 |
 #ifdef __BIG_ENDIAN
@@ -3850,7 +3848,7 @@ static int arm_smmu_s1_set_dev_pasid(struct iommu_domain *domain,
 		return -EINVAL;
 
 	/*
-	 * We can read cd.asid outside the lock because arm_smmu_set_pasid()
+	 * We can read master.asid outside the lock because arm_smmu_set_pasid()
 	 * will fix it
 	 */
 	arm_smmu_make_s1_cd(&target_cd, master, smmu_domain, id);
@@ -3921,7 +3919,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	 */
 	cd->data[0] &= ~cpu_to_le64(CTXDESC_CD_0_ASID);
 	cd->data[0] |= cpu_to_le64(
-		FIELD_PREP(CTXDESC_CD_0_ASID, smmu_domain->cd.asid));
+		FIELD_PREP(CTXDESC_CD_0_ASID, master->asid[pasid]));
 
 	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
 	arm_smmu_update_ste(master, sid_domain, state.ats_enabled);
-- 
2.43.0


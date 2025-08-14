Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56F11DD0EF;
	Thu, 14 Aug 2025 01:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755134793; cv=fail; b=iNP0VPKTSDpobEjSVt7bY1J4QBFpYXDLohVUe+dEEU6vp9wBDGMiW7B8P1sDxkxOQn7gsFgvndUsvzsGvT1e1jE6m1Bj+5JJZSKWhvDK5Yx7GO7FuoQxh2jUUdEZBdCd7zu/nqzLKw+eokhyug7eWsvgyEkUaW5COo7A/1nJPCg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755134793; c=relaxed/simple;
	bh=n68IzJHPPZYsHEpPUoc7Tfm+zcw9E3wWbzLtQVXZf04=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kzoafPVXUn1dtuWZZVjQZSebnzM3+vwFW0I49qEw0FwHqUhwptJKY1EL0R6aZ+7h0EIA0MJnxENLizh+QvtV1EuKHINkYJdAtxMl8ThGbIrKvcsLEyI2QW9TDjJU3rOWTi+62kuZfc3ib5p93Z35dDsVQUWINAJmg9tdj1SiKBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eWPHOuW+; arc=fail smtp.client-ip=40.107.243.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eWPHOuW+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RYLmVkADWcr0FczSDQD9QtyW/HJKstZ5NbfCJLAH5x9SAMIabm3Zl6JGte4h7stQf1kCZzMpsY29ZL0Q54JoM5ZWAFRXYjUhZP42L4MBvXjeKHdGpRW6qV/kak0RnmcoIUUlLE3P7bzj7vL2jzr3TkVFOj6Lq5pNyre8Lz4WmGUUV7MbRFCLUqn5GnY5gGKExj9R4NLc00KS2Qq2jmiBnQERrWR8Tp5soluoLBgpDyhEgbu++x1p7EBzKWGXbee38+J8jxhf6JJ94WnK4PwgQaUEa7f9909mBBK3hVJO4ov2x8IXaR7LgQHW19ByUpzwyMKf6pf+pDZo8nUrg9O3vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q58sfs3tok8ob+rxiYVQH6vmTOamD0GfCbmlcVi3DK8=;
 b=ABdEMrE+btHaQgTBU/4mqI+XkewJkJa6fG0LU3Nezl86Ixmxpf60qWO2O5u3kJ6bNjHlw1ogZzXm4KZrL6xbeEc82DY9kpQ/7GT40jTHOdCLD+079Wz2O9spRJ+zgolpA5LiQ0QxjD3Tllcn0ioOIuazTXJldMehwGEn4xNumL3xJdJWZjbMCAU130mEVY4pi+Sxo6MKbmDlxUw6iUj/5HMGIVc9upBI6/kPrjhB59za0YtrOarSyGGwXoFc5b+JFZM2uGupIs/d2BZ4aXJCuiMprQTCH4NQAPljWeyXEJhYg7kVW4OkbhcfsQRDqic87YJ+AUrNTgLd2nSkqgnBbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q58sfs3tok8ob+rxiYVQH6vmTOamD0GfCbmlcVi3DK8=;
 b=eWPHOuW+rYk4qBNF7AJXppnkbk8201MYzNbQ+IKLDljFbM0aiikgXARPTv3PFx3E/yOE4OI6yvnqB7H/TYDn4U4eNVddRJz1a6pVrD54Ou7+uhyVk4mdscxw7faYlG7aRVm57QCS815q+QpKi+qMPRKAR7LOug99tHl96SLuuQPFr55f+wXIDaMpUP9T/0slDXdMnkOP5H7I5fIDVt/isTOmdg3xCtw/kLrC16SkNOmLYQpKdw27Ir6yMKj8gUyQQuHYuOydIHRPx9gMcz7sXh6Rr/KaHgjBTF0jo9qwbp4PfYE4gs53eXqKOooZUkwhqtB768ZMp20P18Eq7ORI7g==
Received: from BYAPR08CA0059.namprd08.prod.outlook.com (2603:10b6:a03:117::36)
 by IA0PR12MB8279.namprd12.prod.outlook.com (2603:10b6:208:40c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 01:26:25 +0000
Received: from SJ5PEPF000001F4.namprd05.prod.outlook.com
 (2603:10b6:a03:117:cafe::46) by BYAPR08CA0059.outlook.office365.com
 (2603:10b6:a03:117::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.16 via Frontend Transport; Thu,
 14 Aug 2025 01:26:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF000001F4.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 01:26:25 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 18:26:09 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 13 Aug
 2025 18:26:09 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Wed, 13 Aug 2025 18:26:08 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <will@kernel.org>, <robin.murphy@arm.com>
CC: <joro@8bytes.org>, <jean-philippe@linaro.org>, <miko.lenczewski@arm.com>,
	<balbirs@nvidia.com>, <peterz@infradead.org>, <smostafa@google.com>,
	<kevin.tian@intel.com>, <praan@google.com>, <zhangzekun11@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH rfcv1 6/8] iommu/arm-smmu-v3: Populate smmu_domain->invs when attaching masters
Date: Wed, 13 Aug 2025 18:25:37 -0700
Message-ID: <d4dca0a6288e4c15994d41aa6722fa7d66e3816c.1755131672.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1755131672.git.nicolinc@nvidia.com>
References: <cover.1755131672.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F4:EE_|IA0PR12MB8279:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f22efe3-a07c-4905-a58a-08dddad195ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+/XJJajsT3lm50DMZ2ic/JIdAjwxpLuICBmFbZbnRypplXY4XKZQyQULJNvx?=
 =?us-ascii?Q?5k8SSfhMtbOJiaip93anLF98FqWXQypTozDiLO/OoxoJiCqoj43dkUsMB2PR?=
 =?us-ascii?Q?nNBnwI6PKGwFFBeNN56jRcTm5sb8sriYKcSREfyV8F9+U/vzBVcz7XEf2adg?=
 =?us-ascii?Q?VGLl18kUtdeRbX9svvx1IG5kCikybY1iAmWVGhX0Tgj2DlJ2aettZgG3y3Ii?=
 =?us-ascii?Q?bEDvmdzVdANJH+DSNoQNb1ymck5AnOwlyci6/MaD0Lo3//IAIdPVyKh1dzQ2?=
 =?us-ascii?Q?Jhua2ep5NhQ/KpTV/QjOvrqho4ohkLruOsrZsGZVmT6zE8/75jxdySGkiEVm?=
 =?us-ascii?Q?jPlnyLozfG7mUdQqEOjxGoijIjzug6IT0ZNPczma/gX3B7Fc0zCP7/nEz73C?=
 =?us-ascii?Q?999yDvJTta3AbBkCw6UbzilioNLSqS9byrWnf0e+FKYuoZ2RLoQ7eHZYYmwZ?=
 =?us-ascii?Q?NrEoi623UAvRK0fhhjZKrM6TVq2t/lK9VngG6ErbweuvKtENSnmNNABIZjpo?=
 =?us-ascii?Q?CxW7Z7libBfRn3P/tL2Ix0jDKtdacy+x+PJj6WAYwYqFWLM8GZG19md17Gi7?=
 =?us-ascii?Q?zqJNxYdQ6w3rAyQUiMKVbvreNr4+pY4wkBrs+Pe1r2Pu1K54Vg0X7kyk/UO7?=
 =?us-ascii?Q?USAEE2/DHhmJ0SRXJvLFuUqe+UScb0BtkFJVdHe6HfzAJ36DrFG4WdGzyCUN?=
 =?us-ascii?Q?mi0tw2bPE7+wvRDVNn3bclZJ0sXjvBZT8wplGw91jE6e6oZ4hjjJQpHHHXt1?=
 =?us-ascii?Q?OR8YdHwdZEfd7HVtei+b/nqPudniX0dmRSVadehXfl051d14NhsVH79sDqQ8?=
 =?us-ascii?Q?SvQbLvt+TNw/4XjCI1AfI8BIcm84hAvgldTT9cC4nh2FvMdtWjzdbyz74rSO?=
 =?us-ascii?Q?O5Wcve3+kMBQq+2WjgV3YTEE1bA6ZGhtyNB5PXieezZS+fC9TWPGhBHBUv1A?=
 =?us-ascii?Q?RVDLUP6ciKztdpjNEULpLDytJ2co/Na89//Dw0/wfx4xuZ7D5pLPDJOGs/Hu?=
 =?us-ascii?Q?kg7O6FAtO2lwa85asJnhfbtW9sqZQkvu342l18mUYIbkPecCcR3Rtz7ou9Hy?=
 =?us-ascii?Q?kDtLHSZ6BFNAsjJzWZFm4oRwlndQyFzUA7MuaNU6Ir35XpL0jwpFSZ+yrPJD?=
 =?us-ascii?Q?Q+0zvP9TVYsccyJlvdEEjxBrtWiRt7kpcUJCKgxky/smjfXP9Kmj42SSdyDe?=
 =?us-ascii?Q?vE//E1c+DaJUgY5MQftbvoxtap/U7zpYkmnGNaZHF7SkQQtQD9NigArMi00v?=
 =?us-ascii?Q?Wd6yavN86K2RpWICkWd3yfuYJAeOQHCekR2K0w3cLv1Lx3EEIrD2u1KALUmM?=
 =?us-ascii?Q?9seTJI3cnHf8J5CcA6f79IRJwAmCyeIfcaDREFaGg9Ednjl+7lF6E3PXs8jS?=
 =?us-ascii?Q?8ElMP0AthLxbNokQpKTNdVYDz7+pN9tET5rW4tRQmqzX5QsQTQycQGhtEakf?=
 =?us-ascii?Q?SI74OL9zxysT4HpSz1it85Cbh4neYyDnsdELBNDe9ZdYkXjvwSNsxs/QXcRS?=
 =?us-ascii?Q?vhe+4PPDUca2/9WHoQi3mAtXDIgNWZBd20Lw?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 01:26:25.0829
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f22efe3-a07c-4905-a58a-08dddad195ba
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8279

Update the invs array with the invalidations required by each domain type
during attachment operations.

Only an SVA domain or a paging domain will have an invs array:
 a. SVA domain will add an INV_TYPE_S1_ASID per SMMU and an INV_TYPE_ATS
    per SID

 b. Non-nesting-parent paging domain with no ATS-enabled master will add
    a single INV_TYPE_S1_ASID or INV_TYPE_S2_VMID per SMMU

 c. Non-nesting-parent paging domain with ATS-enabled master(s) will do
    (b) and add an INV_TYPE_ATS per SID

 d. Nesting-parent paging domain will add an INV_TYPE_S2_VMID followed by
    an INV_TYPE_S2_VMID_S1_CLEAR per vSMMU. For an ATS-enabled master, it
    will add an INV_TYPE_ATS_FULL per SID

The per-domain invalidation is not needed, until the domain is attached to
a master, i.e. a possible translation request. Giving this clears a way to
allowing the domain to be attached to many SMMUs, and avoids any pointless
invalidation overheads during a teardown if there are no STE/CDs referring
to the domain. This also means, when the last device is detached, the old
domain must flush its ASID or VMID because any iommu_unmap() call after it
wouldn't initiate any invalidation given an empty domain invs array.

Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |   6 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 220 +++++++++++++++++++-
 2 files changed, 225 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 0330444bef45f..715179249eced 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1084,6 +1084,12 @@ struct arm_smmu_attach_state {
 	ioasid_t ssid;
 	/* Resulting state */
 	struct arm_smmu_vmaster *vmaster;
+	struct arm_smmu_invs **old_domain_invs;
+	struct arm_smmu_invs *old_domain_oinvs;
+	struct arm_smmu_invs *old_domain_ninvs;
+	struct arm_smmu_invs **new_domain_invs;
+	struct arm_smmu_invs *new_domain_oinvs;
+	struct arm_smmu_invs *new_domain_ninvs;
 	bool ats_enabled;
 };
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index fb5429d8ebb29..95615525b0ab8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3082,6 +3082,76 @@ static void arm_smmu_disable_iopf(struct arm_smmu_master *master,
 		iopf_queue_remove_device(master->smmu->evtq.iopf, master->dev);
 }
 
+typedef struct arm_smmu_invs *(*invs_fn)(struct arm_smmu_invs *old_invs,
+					 struct arm_smmu_invs *invs);
+
+static struct arm_smmu_invs *arm_smmu_build_invs(
+	struct arm_smmu_invs *old_invs, struct arm_smmu_domain *smmu_domain,
+	struct arm_smmu_master *master, bool ats, ioasid_t ssid, invs_fn fn)
+{
+	const bool e2h = master->smmu->features & ARM_SMMU_FEAT_E2H;
+	const bool nesting = smmu_domain->nest_parent;
+	struct arm_smmu_inv *cur = master->invs->inv;
+	size_t num_invs = 1;
+	size_t i;
+
+	switch (smmu_domain->stage) {
+	case ARM_SMMU_DOMAIN_SVA:
+	case ARM_SMMU_DOMAIN_S1:
+		cur->smmu = master->smmu;
+		cur->type = INV_TYPE_S1_ASID;
+		cur->id = smmu_domain->cd.asid;
+		cur->size_opcode = e2h ? CMDQ_OP_TLBI_EL2_VA :
+					 CMDQ_OP_TLBI_NH_VA;
+		cur->nsize_opcode = e2h ? CMDQ_OP_TLBI_EL2_ASID :
+					  CMDQ_OP_TLBI_NH_ASID;
+		break;
+	case ARM_SMMU_DOMAIN_S2:
+		cur->smmu = master->smmu;
+		cur->type = INV_TYPE_S2_VMID;
+		cur->id = smmu_domain->s2_cfg.vmid;
+		cur->size_opcode = CMDQ_OP_TLBI_S2_IPA;
+		cur->nsize_opcode = CMDQ_OP_TLBI_S12_VMALL;
+		break;
+	default:
+		WARN_ON(true);
+		return old_invs;
+	}
+
+	/* Range-based invalidation requires the leaf pgsize for calculation */
+	if (master->smmu->features & ARM_SMMU_FEAT_RANGE_INV)
+		cur->pgsize = __ffs(smmu_domain->domain.pgsize_bitmap);
+
+	/* All the nested S1 ASIDs have to be flushed when S2 parent changes */
+	if (nesting) {
+		cur = &master->invs->inv[num_invs++];
+		cur->smmu = master->smmu;
+		cur->type = INV_TYPE_S2_VMID_S1_CLEAR;
+		cur->id = smmu_domain->s2_cfg.vmid;
+		cur->size_opcode = CMDQ_OP_TLBI_NH_ALL;
+		cur->nsize_opcode = CMDQ_OP_TLBI_NH_ALL;
+	}
+
+	if (ats) {
+		for (i = 0, cur++; i < master->num_streams; i++) {
+			cur->smmu = master->smmu;
+			/*
+			 * If an S2 used as a nesting parent is changed we have
+			 * no option but to completely flush the ATC.
+			 */
+			cur->type = nesting ? INV_TYPE_ATS_FULL : INV_TYPE_ATS;
+			cur->id = master->streams[i].id;
+			cur->ssid = ssid;
+			cur->size_opcode = CMDQ_OP_ATC_INV;
+			cur->nsize_opcode = CMDQ_OP_ATC_INV;
+		}
+		num_invs += master->num_streams;
+	}
+
+	master->invs->num_invs = num_invs;
+	return fn(old_invs, master->invs);
+}
+
 static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 					  struct iommu_domain *domain,
 					  ioasid_t ssid)
@@ -3111,6 +3181,144 @@ static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
 	kfree(master_domain);
 }
 
+static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
+					struct arm_smmu_domain *new_smmu_domain)
+{
+	struct arm_smmu_domain *old_smmu_domain =
+		to_smmu_domain_devices(state->old_domain);
+	struct arm_smmu_master *master = state->master;
+	bool blocking = false;
+
+	/* A re-attach case doesn't need to update invs array */
+	if (new_smmu_domain == old_smmu_domain)
+		return 0;
+
+	if (new_smmu_domain) {
+		state->new_domain_oinvs = rcu_dereference_protected(
+			new_smmu_domain->invs,
+			lockdep_is_held(&arm_smmu_asid_lock));
+		state->new_domain_ninvs = arm_smmu_build_invs(
+			state->new_domain_oinvs, new_smmu_domain, master,
+			state->ats_enabled, state->ssid, arm_smmu_invs_add);
+		if (IS_ERR(state->new_domain_ninvs))
+			return PTR_ERR(state->new_domain_ninvs);
+		state->new_domain_invs = &new_smmu_domain->invs;
+		blocking = new_smmu_domain->domain.type == IOMMU_DOMAIN_BLOCKED;
+	}
+
+	if (old_smmu_domain) {
+		state->old_domain_oinvs = rcu_dereference_protected(
+			old_smmu_domain->invs,
+			lockdep_is_held(&arm_smmu_asid_lock));
+		state->old_domain_ninvs = arm_smmu_build_invs(
+			state->old_domain_oinvs, old_smmu_domain, master,
+			master->ats_enabled, state->ssid, arm_smmu_invs_del);
+		if (IS_ERR(state->old_domain_ninvs)) {
+			/* An attachment to the blocked_domain must not fail */
+			if (blocking) {
+				state->old_domain_ninvs = NULL;
+			} else {
+				kfree(state->new_domain_ninvs);
+				return PTR_ERR(state->old_domain_ninvs);
+			}
+		}
+		state->old_domain_invs = &old_smmu_domain->invs;
+		/* master->invs is retaining the del_invs for the old domain */
+	}
+
+	return 0;
+}
+
+/* Must be installed before arm_smmu_install_ste_for_dev() */
+static void
+arm_smmu_install_new_domain_invs(struct arm_smmu_attach_state *state)
+{
+	if (!state->new_domain_invs)
+		return;
+
+	rcu_assign_pointer(*state->new_domain_invs, state->new_domain_ninvs);
+	/*
+	 * Committed to updating the STE, using the new invalidation array, and
+	 * acquiring any racing IOPTE updates.
+	 */
+	smp_mb();
+	kfree_rcu(state->new_domain_oinvs, rcu);
+}
+
+/* Should be installed after arm_smmu_install_ste_for_dev() */
+static void
+arm_smmu_install_old_domain_invs(struct arm_smmu_attach_state *state)
+{
+	struct arm_smmu_invs *old_domain_oinvs = state->old_domain_oinvs;
+	struct arm_smmu_invs *old_domain_ninvs = state->old_domain_ninvs;
+	struct arm_smmu_master *master = state->master;
+	unsigned long flags;
+	size_t num_invs;
+
+	if (!state->old_domain_invs)
+		return;
+
+	/* Activate the no-fail protocol upon an allocation failure */
+	if (!old_domain_ninvs) {
+		/*
+		 * Notes:
+		 *  - The array will be edited in place while holding its rwlock
+		 *    which has a tradeoff that any concurrent invalidation will
+		 *    fail at read_trylock() until arm_smmu_invs_dec() returns.
+		 *  - arm_smmu_invs_dec() doesn't update the array's num_invs as
+		 *    if only decrease users counters. So, get num_invs from the
+		 *    returned value.
+		 *  - The master->invs retains the del_invs for the old domain.
+		 */
+		num_invs = arm_smmu_invs_dec(old_domain_oinvs, master->invs);
+	} else {
+		rcu_assign_pointer(*state->old_domain_invs, old_domain_ninvs);
+		/*
+		 * Fake an empty old array that a concurrent invalidation thread
+		 * races at. It either lets the reader quickly respin for a new
+		 * array with fewer num_invs (avoiding deleted invalidations) or
+		 * blocks the writer till the reader flushes the array (avoiding
+		 * ATC invalidation timeouts for ATS invalidations being sent to
+		 * a resetting PCI device).
+		 */
+		write_lock_irqsave(&old_domain_oinvs->rwlock, flags);
+		old_domain_oinvs->num_invs = 0;
+		write_unlock_irqrestore(&old_domain_oinvs->rwlock, flags);
+
+		kfree_rcu(old_domain_oinvs, rcu);
+		num_invs = state->old_domain_ninvs->num_invs;
+	}
+
+	/*
+	 * The domain invs array was filled when the first device attaches to it
+	 * and emptied when the last device detaches. So, the invs array doesn't
+	 * syncrhonize with iommu_unmap() calls, which might come after the last
+	 * detach and end up with a NOP. This would result in missing a critical
+	 * TLB maintanance. Thus, when the last device is detached (indicated by
+	 * an empty invs array), flush all TLBs using the removed ASID or VMID.
+	 */
+	if (!num_invs) {
+		struct arm_smmu_inv *inv = &master->invs->inv[0];
+		struct arm_smmu_cmdq_ent cmd = {
+			.opcode = inv->nsize_opcode,
+		};
+
+		switch (inv->type) {
+		case INV_TYPE_S1_ASID:
+			cmd.tlbi.asid = inv->id;
+			arm_smmu_cmdq_issue_cmd_with_sync(inv->smmu, &cmd);
+			break;
+		case INV_TYPE_S2_VMID:
+			cmd.tlbi.vmid = inv->id;
+			arm_smmu_cmdq_issue_cmd_with_sync(inv->smmu, &cmd);
+			break;
+		default:
+			WARN_ON(true);
+			break;
+		}
+	}
+}
+
 /*
  * Start the sequence to attach a domain to a master. The sequence contains three
  * steps:
@@ -3168,12 +3376,16 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 				     arm_smmu_ats_supported(master);
 	}
 
+	ret = arm_smmu_attach_prepare_invs(state, smmu_domain);
+	if (ret)
+		return ret;
+
 	if (smmu_domain) {
 		if (new_domain->type == IOMMU_DOMAIN_NESTED) {
 			ret = arm_smmu_attach_prepare_vmaster(
 				state, to_smmu_nested_domain(new_domain));
 			if (ret)
-				return ret;
+				goto err_unprepare_invs;
 		}
 
 		master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
@@ -3221,6 +3433,8 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 			atomic_inc(&smmu_domain->nr_ats_masters);
 		list_add(&master_domain->devices_elm, &smmu_domain->devices);
 		spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+
+		arm_smmu_install_new_domain_invs(state);
 	}
 
 	if (!state->ats_enabled && master->ats_enabled) {
@@ -3240,6 +3454,9 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 	kfree(master_domain);
 err_free_vmaster:
 	kfree(state->vmaster);
+err_unprepare_invs:
+	kfree(state->old_domain_ninvs);
+	kfree(state->new_domain_ninvs);
 	return ret;
 }
 
@@ -3271,6 +3488,7 @@ void arm_smmu_attach_commit(struct arm_smmu_attach_state *state)
 	}
 
 	arm_smmu_remove_master_domain(master, state->old_domain, state->ssid);
+	arm_smmu_install_old_domain_invs(state);
 	master->ats_enabled = state->ats_enabled;
 }
 
-- 
2.43.0


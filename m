Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011021.outbound.protection.outlook.com [40.107.208.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC21C3783B9;
	Mon, 23 Feb 2026 20:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771878543; cv=fail; b=nWxpffiojKZIgZQkr+VGrjVF7byGeOa6pgYd+ZOU3yCrIy0Z+f9SFXKm6NVbIFEEHJ4dXt9bh4gQvTsTEgBuhCFecmfdVJRVihvhgkdqijlPQaw9kAqa7QWLB5HFsW1tiCgxUP/hD0nnAHULHRaP0Jaoh5WZQPHxGb9lzS6Zp7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771878543; c=relaxed/simple;
	bh=kXVBJAyhbOO/2JabKa+4iiA5DxxpPkrsgOX5HjDrirg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E9w3Vu/kAkYuwbu9ss1f1H+AXYvSD+ZRXmhlKZ3nyyhAIxF1ZzzHHW1jBis08ihYq4Y/0Y546IHYVC2FakivHMGBqJI8Jcv7c7NiiA+FaLJVwHMCHkLKtt5gSBEID7StWrvLl6sWtnNzluF0CY8zU78O48rFZEkUsw/azFiqp4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JtRp4A0c; arc=fail smtp.client-ip=40.107.208.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JtRp4A0c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d4YCtAF6FXTWmznHfpN2eDtZh4B2YPMniL3m4ljqQIJgAPLgwWnXjZ58QWE9T1A/px7x1W8SmlpwRdS5+LLbwbAz9wzP6RRhLD6dmDIUtnYVsDD4GXH0ZgLRx6jPph8MRjQ3eDX0gRf3BIPPv7I8ztccreoKXWv5uxlKs1NbK38bUG/xhZJ8hvbAXpl6HDM0f69N9/uMDFFjyv6XDBOxNkdClsRa/XWj12Jr7vArCPg3445X1aUmRAkw+1xzCvVCP15WvwzKAD/nGM0GHMPcFrRjs2g+Ds+ShG7O82MnPE9nNFrx5cOe87FxQdAZ4Vfo2xZ4TDsnGhSU8BPzClXuug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yPmsCdgucf0lgEum4PoFNMafQsDz2hOEDcwxxpRORJE=;
 b=oODYN/NBwX8HO/UqD4oj/eLh2SlEgSrENvecC8HzsbxYS7i7nikfRl4IIjxibtqOKg9opsPVsIobDOukyoF/ZuQkgr9IdJgNXPKwRAJW3dfXptoZm/4tNzW9q78tiJFaeCKQOLafv6d+jnyHC8o90tkvuOlmVkNyBNSR3tj66dC+gYjluokYa8LvrrgzWWf7Z+TS9aX1SWM0NeEwQqxInoEvSI5nmN2IihIfvzGR+mR/Gl2l6NxNhtBXLANGLP3iNqmvqhYod2gQI9PJhdXIb1Tt3lEHBjegv3PdNJqhPUftEMrFDrKhtGHTL3I6ttMSssyN6jYn71WT9yQ/AKpkyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yPmsCdgucf0lgEum4PoFNMafQsDz2hOEDcwxxpRORJE=;
 b=JtRp4A0cVipG5KmDxkW+HlqJK3AiMb14VxVl5NmsLeM/RAiXtrG4fwcM8vhis1G0lpUtQPLEqbo1U14PjlItppu+oEjYJw5ASjqAYqE+O37Ljb+WEupe0cTAUO4YPrp7YZogeq6WgyMw0wsOAe+CrKwDs0wlE/3LlFjVq9/EUq8/yNGHPNeHNTBKINs7gsYFHNTNA3wF8E8XwG1FcsAlCdYpCAxH4U74JioAoEPmJQX3CfceSzOqtqDDq7lnLbOnv0QHjU/4/In2zbkwbxkjtXfusbt8z0tPMg0M7mtVDubcsn2ANEzkCF2uFPg7vlCtU9dFNyrcAD+oQzoUNxJxrQ==
Received: from SJ0PR13CA0118.namprd13.prod.outlook.com (2603:10b6:a03:2c5::33)
 by DS2PR12MB9685.namprd12.prod.outlook.com (2603:10b6:8:27a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 20:28:53 +0000
Received: from CO1PEPF00012E62.namprd05.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::e1) by SJ0PR13CA0118.outlook.office365.com
 (2603:10b6:a03:2c5::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 20:28:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF00012E62.mail.protection.outlook.com (10.167.249.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 20:28:52 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 12:28:31 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 12:28:31 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 12:28:30 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <smostafa@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH v3 10/10] iommu/arm-smmu-v3: Allow sharing domain across SMMUs
Date: Mon, 23 Feb 2026 12:27:46 -0800
Message-ID: <b7459e6833be0eecc33263723e75853efd43bcc1.1771877893.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1771877893.git.nicolinc@nvidia.com>
References: <cover.1771877893.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E62:EE_|DS2PR12MB9685:EE_
X-MS-Office365-Filtering-Correlation-Id: c7fc9b41-ccad-4ef9-53f6-08de731a2926
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5dJQoutnk98bUjqbXNEP96+vPz6ZVyRutkiTPF/ldmpuE7zKJ0hH9krXKi/x?=
 =?us-ascii?Q?617MzpFGIa766JK29y3GKvJvLvmslytMc3jfYD2N6ihA7WrYG+BwLW13Bamt?=
 =?us-ascii?Q?PjjCAGCqpiHIBFnJJUm47S7DEjl6Ic22ITJkdqN5IRvDe3CjMmF6n1V4pYnc?=
 =?us-ascii?Q?YW7uNlDj85VX4VFTNP6jI87LA0jMWjU6GVounVWFCPVUf3uJZaV7N+hjpV+E?=
 =?us-ascii?Q?qsbcuksBOyNhsWHQIQfDPkXtfclta5sir1bpdOcfih8t2n5AumbGsZ5q7FHu?=
 =?us-ascii?Q?jqB7cwINBmYW1r8ZjKeROQ+T+C5BxHiiY7sli1gr4WNQTpRbM2te7TQFysnH?=
 =?us-ascii?Q?R59IMJ+zhamq6eYWvbfeuSI+QjlTRuPCrcBisjkEPr6qwTgrSyU/yOfWqBnh?=
 =?us-ascii?Q?FabjCnAcpEGh8PIqCjbwXbUiHzPFFxmTv5BDIhkJafaYawRITDqrby0HaeOE?=
 =?us-ascii?Q?MmZ1m2VVvlR75Bqm1JQGwYV6cuIaXH6CqA49R10xSILafe0GaZSImsBpp7wf?=
 =?us-ascii?Q?WXWCsqwapRk/S489+BL3ZrAlgzc/XlL6oIS+RRoWWWNKEGKX3Byf5X9bD4FW?=
 =?us-ascii?Q?s8ts+h/w0uBqxdMH4AyfpRrGlv4szYYqvzRqf4aE5n6r0/2cOUMpKIbsWKmO?=
 =?us-ascii?Q?I5zL72WAShZ9MxTw9OpeB4Pr2I6tNEJYrq4UZsVaGdOvxt6pE9yJyf/kWxdA?=
 =?us-ascii?Q?Z9J3itjIuud/e2GaKsQ8874hIja1ebTYILEFztR2Il3+1wALpcWo1k6GdFNy?=
 =?us-ascii?Q?7pNcAChS+ryUXzYMJU9EUxbp+N+jSRSv9kJp/cYgziUfMLcjWbVrbgRWJoyQ?=
 =?us-ascii?Q?JoWoIR/1hzaFoP2crj1VPZFITYFVJc+RhgvINYfJZIMMeq/UX+ek+l8KYNZp?=
 =?us-ascii?Q?s7+6PIAU/CjE57qVykb/fAZAuQqx+Unw6Ao90x+1cdHDQnMS//YbNbgtVWzB?=
 =?us-ascii?Q?RjGioY5AZ1veflk6eUpqiFFEe6vWB5VKO4LyIylJkJLrdDOiCFBvS8F6M4ay?=
 =?us-ascii?Q?BdnCdGeGJwIyUBBlTsOrqCjNrNVVlD/vj7FKU1UiVvi/fvKzFsoKBEgI7k8D?=
 =?us-ascii?Q?cMpG1KXdPCDBR94I5E+Pw5wxligQExAEX7UqyXJhmBGFxE4tm7PGpEU+rnIU?=
 =?us-ascii?Q?NHn+MqcVBGhoG82aWYOlpoqsTwoPzQe4aHlSOOA9fWA/XNm/Uusgz684n6zH?=
 =?us-ascii?Q?9OGvy49vSD4G8jjxef3Oi9705qF2StOIqa+lV6ztaStTP++3su2j2Sokl/it?=
 =?us-ascii?Q?rQSjN2GMcACHXKEBiTDp6Xmhl4QNQNXTpOZ4t25soyIfpQi1ZuHR784h5du4?=
 =?us-ascii?Q?CL19+hPsnokR8cYe7Jo1wrHfSxoKADClYLRjTu+ZGeEINPyvV7FznokbHLB8?=
 =?us-ascii?Q?PZ0rQ3pUTSkNM8gyEastL3esAo+4bwOwNI8iog4aRAanzC6jfWXAnl+N6PNv?=
 =?us-ascii?Q?bhn2UE0XadHkXM7dDv3cisgedhP6QdAFnL44WQqIRgZnTmjKWaK6FyzNSeKS?=
 =?us-ascii?Q?sC2F2y99K0fArx+uAHMcL2Lw3oDUuagJepTn8QXKrABGe5AbuicuyPm6ATqD?=
 =?us-ascii?Q?oOByG3PJvIP77hrpevo3boiW+sum701bEMwKN+IFJrkJxYAJXtIfaZ4cJGOk?=
 =?us-ascii?Q?ufXzbjSB0vnlUOTtBhfbVrniLrIE0dTZRpcJ+l0tr89xYhm8BGAmPs7P1nI5?=
 =?us-ascii?Q?2h/hcw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+RXe8Ay3ZzpbcyFu2LjLKRpx2WLkzuQjKNM2jKXvE7cQ/sDg7bvXMKEdgSGAZjL/OZkDLiFqBodGxD/FFBk4x81We7GKDBeuQGcGn/n9h3vODGEoFNMB0HaGyBLv8S2T0BpvRk/XPZG0LQNofOHlb6ocX1Z2bqqIVnJKVmr2TTvAWFMfdCkwIj9yajnPEgxb+4Q9oGMyujRRsY95w9tDqENlPa4OJz3WGL+LlJKwDi811KZVXEqdydafVBHEdduqsLxQL7bPrE2bjWvoOkxt7qdwUzHaSPGVDYQVDAOCN3MI0TaA4sbFsAbk6RqaYPS+KYPG+aHVQNsYkm/rqgYFUVdJv4mmDnsbwRmFHWtybWZtVIjYB/0q2vA659JNKy9/usGtTQgpKDQmeehLF1mj6DCLvqXJNc44mR/MbPB+fRJaURArz0C2cJTWfvqnZSNP
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 20:28:52.8929
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7fc9b41-ccad-4ef9-53f6-08de731a2926
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E62.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9685

VMM needs a domain holding the mappings between gPA to hPA. It can be an S1
domain or an S2 nesting parent domain, depending on whether the VM is built
with a vSMMU or not.

Given that the IOAS for this gPA mapping is the same across SMMU instances,
this domain can be shared across devices even if they sit behind different
SMMUs, so long as the underlying page table is compatible between the SMMU
instances.

There is no direct information about the page table from the master device,
but a comparison can be done between the page table bits held in the domain
and the SMMU feature bits that are used to decide those page table bits.

Replace the smmu test in arm_smmu_attach_dev() and arm_vsmmu_init() with a
compatibility test for the S1 and S2 cases respectively.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 27 +++++++++++++++++++
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  3 +--
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index e0832b191a2a6..2e5981db11cd6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -9,6 +9,7 @@
 #define _ARM_SMMU_V3_H
 
 #include <linux/bitfield.h>
+#include <linux/io-pgtable.h>
 #include <linux/iommu.h>
 #include <linux/iommufd.h>
 #include <linux/kernel.h>
@@ -987,6 +988,32 @@ struct arm_smmu_nested_domain {
 	__le64 ste[2];
 };
 
+static inline bool
+arm_smmu_domain_can_share(struct arm_smmu_domain *smmu_domain,
+			  struct arm_smmu_device *new_smmu)
+{
+	struct io_pgtable *pgtbl =
+		io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops);
+
+	if (pgtbl->fmt == ARM_64_LPAE_S1 &&
+	    !(new_smmu->features & ARM_SMMU_FEAT_TRANS_S1))
+		return false;
+	if (pgtbl->fmt == ARM_64_LPAE_S2 &&
+	    !(new_smmu->features & ARM_SMMU_FEAT_TRANS_S2))
+		return false;
+	if (pgtbl->cfg.pgsize_bitmap & ~new_smmu->pgsize_bitmap)
+		return false;
+	if (pgtbl->cfg.oas > new_smmu->oas)
+		return false;
+	if (pgtbl->cfg.coherent_walk &&
+	    !(new_smmu->features & ARM_SMMU_FEAT_COHERENCY))
+		return false;
+	if ((pgtbl->cfg.quirks & IO_PGTABLE_QUIRK_ARM_S2FWB) &&
+	    !(new_smmu->features & ARM_SMMU_FEAT_S2FWB))
+		return false;
+	return true;
+}
+
 /* The following are exposed for testing purposes. */
 struct arm_smmu_entry_writer_ops;
 struct arm_smmu_entry_writer {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index dc638c38515e4..fbe5fc4e98ead 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -471,7 +471,7 @@ int arm_vsmmu_init(struct iommufd_viommu *viommu,
 	struct arm_smmu_domain *s2_parent = to_smmu_domain(parent_domain);
 	int id;
 
-	if (s2_parent->smmu != smmu)
+	if (!arm_smmu_domain_can_share(s2_parent, smmu))
 		return -EINVAL;
 
 	mutex_lock(&arm_smmu_asid_lock);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a10da6b8f64d5..af99722d3b6fc 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -16,7 +16,6 @@
 #include <linux/delay.h>
 #include <linux/err.h>
 #include <linux/interrupt.h>
-#include <linux/io-pgtable.h>
 #include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/msi.h>
@@ -3709,7 +3708,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev,
 	state.master = master = dev_iommu_priv_get(dev);
 	smmu = master->smmu;
 
-	if (smmu_domain->smmu != smmu)
+	if (!arm_smmu_domain_can_share(smmu_domain, smmu))
 		return -EINVAL;
 
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
-- 
2.43.0


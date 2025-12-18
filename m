Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012005.outbound.protection.outlook.com [52.101.43.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657AB2DC792;
	Thu, 18 Dec 2025 20:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766089680; cv=fail; b=f87Jfa/sCA3WuQ4MwkkpCxEjfMSgoIF9plTCtHW0M7FwsbNIpTI/8Ay0d7QW4GGwHVdeNiNUY3X6EN4BXnPkhVDjMYGLdS+AdWeSO5qrMEaHLXZPHjUxRy2ae/E9h4s2HJ+lsVn26sFoHx2MZNnzbYohbAd88RlqtQjM7+aEAis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766089680; c=relaxed/simple;
	bh=qvYPjBx2jEtrmb05pYja5vHtCvPwJZZ2b8RkV1v9IxU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WtQF05t79r7pDICLfL7DFaePPy5ZrMU9cMVCuezbQWby35pooE9lKwVu1RrUcs4qhijJZx/HF9vl48++3UDi1JNz7Oer+tpyvMmn/qzDA0PIpsOcQiCbD6RATQgitXN1zmTMRdiRLqtHMQ0bPKCZVE+m6Qnct+pb29T+Z+DTu/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=r2tC/sw1; arc=fail smtp.client-ip=52.101.43.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="r2tC/sw1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nuU23IEnV84ue419VxsxgH+kHytTevx8qcN4+wCjpQyUdo5hqjVWXfkLY0Fzb0gZJtdRo08qv2HdpaJbSZ4dNu6Rp8JRr9sOtzq2S5sgjCUnTNyqnWcrN1JmFest+YLp2/2GXU2IuxB9Wv95SOdebaPZaNCc/Ivih2j95ZBy67RBOCPFpsUHvra8oz/ZdSt5rBsBTS3Pq8oWtOpdVWG3JaeNUNiDGlVM8VeqOeX+3FlbyqsNsQ9iN7ZLEIzqxK/21RpGe8SG6FbhPjvETGuGsyEEtmoiAE6nkpujMUP8CDykAcbThTnzQrezD2IfkhTOqZ+JcI1TYJLivB1+C7gf+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fl/i011lztPfhcTC8jNRYhon1EJXYg9Cb5a2Y4jPQ3o=;
 b=TivtOTqUsINBUCo65zh00Yv5AmDhGFm93T4qPAbRU0XPKg0AgZKHJ9aMpiwvrHM8maKGy/4Wd0zGyv/hdFzFItoluEkoJyM/UxB134xMGXI62sfaZ+6xlNAPeZC9zoSGAtuSeTTgExhUiwg2Bp+p4QoHkNGxIbxtbeoHFB1hbq8ZL9pQqkVXPwxUme0VZsitDNp854VHcL5byEqNhIwP3AGyI+CxNyTmpyM/8saHYhM5E71QLpDgrobj9VJIVM59CuWX3L/PeXwxwfedBFjK/THP5yPiVnT228lGGDSFHfce3VfKNteJgWXYmfqV9UxKuT0xwIN/AGEu4VnHj4L1iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fl/i011lztPfhcTC8jNRYhon1EJXYg9Cb5a2Y4jPQ3o=;
 b=r2tC/sw1/yYY+W5OVWVY663UnQb6VBJaApj/A5sp8CHor3MiHEAb3hbmf1A236FQ4epyio5GPjRiTeOs36R9HLeu4FHtC1jbuMhJ9/CsgkmXDmYFvmMx3xmdIHi7JfjrNwyrzg2Vn9Z0aBbI/dN/3y9SkEt5quf4vaiTsDiZ0Cc2ejWV2PN1z4f9+EGt3OFGPiaI95V7juDkcNOupJva+h8BTIs4IJQJ4ybmaUqBuAEw24+T4vfWQJeakoP4MpdtDt8sxeIOLJaFIkVpLB0GoUTPevv7cN5vU012CzyEAI4QX6mtsX/uvLRbE6PAEL1plYeb8pNkWS96uzTaDIyUqg==
Received: from PH8PR22CA0014.namprd22.prod.outlook.com (2603:10b6:510:2d1::29)
 by SA3PR12MB7858.namprd12.prod.outlook.com (2603:10b6:806:306::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.6; Thu, 18 Dec
 2025 20:27:48 +0000
Received: from CY4PEPF0000EDD6.namprd03.prod.outlook.com
 (2603:10b6:510:2d1:cafe::3b) by PH8PR22CA0014.outlook.office365.com
 (2603:10b6:510:2d1::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9434.8 via Frontend Transport; Thu,
 18 Dec 2025 20:27:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EDD6.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Thu, 18 Dec 2025 20:27:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 18 Dec
 2025 12:27:24 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 18 Dec
 2025 12:27:24 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Thu, 18 Dec 2025 12:27:23 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: [PATCH v1 9/9] iommu/arm-smmu-v3: Allow sharing domain across SMMUs
Date: Thu, 18 Dec 2025 12:26:55 -0800
Message-ID: <1274d3dbf29ecb23dbcc8efcd56ea63f94662737.1766088963.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD6:EE_|SA3PR12MB7858:EE_
X-MS-Office365-Filtering-Correlation-Id: fa150a49-4be6-4e0c-490a-08de3e73e8fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KVpLxryPzsoXYDAw4a7o+4+mZ43MYYVbb7H5dHTJYgWsXXg9w6wuQ7uQc8cO?=
 =?us-ascii?Q?OJRmlTJUIQE9ehR4ZCcIKnG7Psl2Ha+kg/zqbH15R4Pv/5t4hfipsi0Q7vBn?=
 =?us-ascii?Q?84ou76PPjLlH+AEsnyATnaMt+Y/AU/9vrvMVxUW97dazk+Cu8vueiHWNaW4e?=
 =?us-ascii?Q?536ztMay0iye8d92DE220lIVXp3LRy4T+kFnguSWCJlqMRO0fCZ0qf6DFkXI?=
 =?us-ascii?Q?TOYGsh9GOtkucH0WuuNp6R0bpe83kKrGmpRVzQC49+qVqc3Fjbg9A9WNdbn9?=
 =?us-ascii?Q?jgWjQfIHRDqK5su27gjzJbTsyIkmTka4Kos9LryVAS6uwxcEb0mXpBPN+uIp?=
 =?us-ascii?Q?Y9P6aO0wi3DnCX0qSGCIwA9E+GbGAi2mLc4ES6kW8ggpTUiUtHpk97jKToa9?=
 =?us-ascii?Q?Dw4BWYc9QVw5P4uXs00dMpm0arqWLHisUrwmEMhoUFB89LXoce9FsxKLehiJ?=
 =?us-ascii?Q?rThk3HpPLTmEFRJMN5dgQ2CxiGjnH7euKfv+t2KstkHxJwaTT6imGL8BZygJ?=
 =?us-ascii?Q?pELShqzyThPPXWmgH0zrTAw/zOx5BbwMDVcXPArZPo1K5zbwkuUwowqvwIRF?=
 =?us-ascii?Q?ua9+SSfM81Wk+2IX2+QCl/Wj3K3yPuu0MTemy/8yH4SUi/qqAR73GnRybA8Z?=
 =?us-ascii?Q?dhCCD+jExCTZnHOYYuZcRTbJBoUzKW4fdWjrwEzASjrgxffoi6j42gPAuGnX?=
 =?us-ascii?Q?M5TqBjRbwFf6VAMQZi8AklWhcUVcvHJh0A3dmd7T8t9gb/VgxO/4E24lXzAy?=
 =?us-ascii?Q?XoOwtkUL4vpoz+YHOkPRKWZsDIoPp+s07wE2YmbhlPAs9nIxk5H/BLUyYyJX?=
 =?us-ascii?Q?UBbtSXp4kAJUhYRdiB/cqjtwSfJ1SftQYTnEtC7F+TuCQagLqzXvRU5ZObW+?=
 =?us-ascii?Q?NiE5d/jtKc7hvbmXqgsfvctZAahvimVuzD7F5rPyZ9oKAldrXsPWV5x2u3V9?=
 =?us-ascii?Q?MxctynIHgjXHUi5Vof21CwklTHzkIjf5CG3iuYK4XSlC2LpRpI11ag79/D3Z?=
 =?us-ascii?Q?unXLScrhJLG8sk6BKDfD495NJ8npq2SA/yW+Dvx8eGW+hicc0HZ80gcYyadK?=
 =?us-ascii?Q?uJaYF9vy5aDppfUo+IbFYXZWWjbSfAd/NS6o9flYPSYqn8rNG+bZj25ImzPH?=
 =?us-ascii?Q?i6cGFK/Kb/D9GfNUTTkh5p7VADgXx3FwNs9bA1ciDgQtk3we3/vl5glWsjtd?=
 =?us-ascii?Q?7baiZfGSFdJ/TlAtsN8qeXvG04KPwrjnwNQrgic3kraDh+uzhQTEUo2Unemb?=
 =?us-ascii?Q?PAC2GpViv4W3hvNJWvFBKmJxr4xq9JOEx5zcwjHfrS95VT5grwqiI0NFqOoY?=
 =?us-ascii?Q?kQaCcYgwNVwzudasg0rBEsB/lbHrRV1vxcvAvfAPoXqkiVNDcQIrFXtttSWi?=
 =?us-ascii?Q?t21FjJdNvJY9+M/qN0gmyx0iwp9eqg2emAf9xGy3TcRfl7q4AhZkauHfZv5B?=
 =?us-ascii?Q?xG5W+28G7LyCIPHq3J18OtNMuXODAoR+ZatJ+Zn5kYvXpeK6AUCLfd3f/zzH?=
 =?us-ascii?Q?yagPA+4GTLE7pcWv/0cIcSq/rjtPc15B1aKBS9zOhgxFyhGmcKD90E/C8FGa?=
 =?us-ascii?Q?ayNbzNeuRZX6XGalLQw=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 20:27:48.3125
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa150a49-4be6-4e0c-490a-08de3e73e8fa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD6.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7858

VMM needs a domain holding the mappings between gPA to hPA. It can be an S1
domain or an S2 nesting parent domain, depending on whether the VM is built
with a vSMMU or not.

Given that the IOAS for this gPA mapping is the same across SMMU instances,
this domain can be shared across devices even if they sit behind different
SMMUs, so long as the underlying page table is compatible between the SMMU
instances.

There is no direct information about the page table from the master device,
but a comparison can be done between the physical SMMU that the domain was
allocated for and the physical SMMU that the device is behind.

Replace the smmu test in arm_smmu_attach_dev() and arm_vsmmu_init() with a
compatibility test for the S1 and S2 cases respectively. The compatibility
test goes through the physical SMMU parameters that were used to decide the
page table formats.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 20 +++++++++++++++++++
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  2 +-
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 4d7b7eb52dfd..d64e4e7c162d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -992,6 +992,26 @@ struct arm_smmu_nested_domain {
 	__le64 ste[2];
 };
 
+static inline bool
+arm_smmu_domain_can_share(struct arm_smmu_domain *smmu_domain,
+			  struct arm_smmu_device *new_smmu)
+{
+	struct arm_smmu_device *base_smmu = smmu_domain->smmu;
+
+	if (base_smmu == new_smmu)
+		return true;
+	/* Only support identical SMMUs for now */
+	if (base_smmu->features != new_smmu->features)
+		return false;
+	if (base_smmu->iommu.ops != new_smmu->iommu.ops)
+		return false;
+	if (base_smmu->pgsize_bitmap != new_smmu->pgsize_bitmap)
+		return false;
+	if (base_smmu->ias > new_smmu->ias || base_smmu->oas > new_smmu->oas)
+		return false;
+	return true;
+}
+
 /* The following are exposed for testing purposes. */
 struct arm_smmu_entry_writer_ops;
 struct arm_smmu_entry_writer {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index 1c877d30f86e..f2318e31d875 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -462,7 +462,7 @@ int arm_vsmmu_init(struct iommufd_viommu *viommu,
 		container_of(viommu->iommu_dev, struct arm_smmu_device, iommu);
 	struct arm_smmu_domain *s2_parent = to_smmu_domain(parent_domain);
 
-	if (s2_parent->smmu != smmu)
+	if (!arm_smmu_domain_can_share(s2_parent, smmu))
 		return -EINVAL;
 
 	vsmmu->smmu = smmu;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 04e21af9c578..ab329614da1f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3684,7 +3684,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev,
 	state.master = master = dev_iommu_priv_get(dev);
 	smmu = master->smmu;
 
-	if (smmu_domain->smmu != smmu)
+	if (!arm_smmu_domain_can_share(smmu_domain, smmu))
 		return -EINVAL;
 
 	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
-- 
2.43.0


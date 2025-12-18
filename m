Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012064.outbound.protection.outlook.com [52.101.48.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30082C08C0;
	Thu, 18 Dec 2025 20:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766089661; cv=fail; b=d9oxn7OMzx89S9cmosShG0hfjxePy4wAGK5rnq9y4TNAO/wTKo9+q+FnkDOdHX5v5fpgDCf1ocCIOY+i9OCtejJXMEUkPbax3uVEPJUSvYZ/OpaYgCMx7Oe+Pep90V1BbB1F1yk0jAZmHX2CrfKTMi3R2zaPT27k0vSI+lXZElM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766089661; c=relaxed/simple;
	bh=YjGYrGiM6cKTpjlTuYjVnvLIqho0Xe1f7zLKh/I8vZY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jctMjNMXyYUVJNAJAIWJmLZJC6orXDVDv8PDOK21faw5e4EoibrdJXZjBBHxmwhhoveRCmYEKkF9hLWazzk5PCrOCb9jcXNRPqRb5Srz94tnMXM1HcYOPt/T8OEcuwQBnPF9Mn3QqQ61YfemIvD22OOLQPKbBZNE8Wy3LDOezrc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bsVGRKzK; arc=fail smtp.client-ip=52.101.48.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bsVGRKzK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FxaMQu72Z5NMNcFiYLp7IW67tnYvL9SX6Vyup/ezcta4X7/WcOvGLdXMzuIGzyKn63oLzr77h3eX2tIZXe4Ejsk/8szY5EZpAW0yOnoh5o/TZQ6q18U4OSuLI4nUHh54Lwjs1UhNbJmWfp/ICZZnvxQqqLiW7y0IVZcGsnRnmaiTncrEEPKc3NZgB7HyetnZQOkRlrbWK6+pLd7TUrWCxWFvt5zxbtel2EsnZNMI0R7JeSoTHYuTrlJVudSjtlhzlWJUS1atYvaBpa/z8nw+/IrE8lh83XtQaXAA1RDV0+j1oEOuiPZqAxdrHXH8rmYzuT6eodkqkYV0IkbMzLwufw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QWl6pstUTBhe830VrjvrJ+Bs36PaCJcDrAPjzgRMPYA=;
 b=ny/CSWmcqmzqVRrd2G7IXKP+Ix0mQSZNjk1qa4dxyEHt0NuqztqDZl4weRUmUBlYNSRol0R+MKOyG1jolVMeD+8Jv+VCrrPJigv2rIe1Nvg4vBBsDwblLm7rgl3ZrKEmA7wYhSyi1iuEvAMNeaBR7LZu2jn8rACjZb5Ee24SmF42XF0/Nox+TajmoHmEJPAAkkROnAlbcxvR8khDoJFSTt1fY03xK5pWb+URV/sG9XQp9u3Ycw9oRDLey86Jmko/PhFG+4Lx5vGM5L1j3c7sih7nGxFTSjlML6t1zUDztSi/xdGtipwDd+tVdtnBtRYUWdB4BjbelAUhQEuYsUv01w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QWl6pstUTBhe830VrjvrJ+Bs36PaCJcDrAPjzgRMPYA=;
 b=bsVGRKzK6ay9OO9Qhhs4hN2Lwn55D+z/py7bkcgIyu7ye4ORHapHs1vi1pTRjsYLDttn6IYUa0SQQCiI5xu/s18OOuUbNaiLAOGNycw1jMcnRurzZ2vCL77HwtH1VUtAigzj+oEG3M11F4lmvGUQcwbdVF9QR2SsDWgIpWeab//nItZWcR1IHs8iXHuJXCTTexQefBtSPwJU8I8Fh9pm+QWtPjqwdtm87tWQCs4sqwaEdnNavXH3lSnQbuAFKFUnX3tUKkW1VwE90bjwGWBwgC90QdlKHhjq5XU4whvSsuBTyifbcbRxYNT4zE/F3dmFoW4Yaadn+4/GmLThGLZaBg==
Received: from CH0PR13CA0011.namprd13.prod.outlook.com (2603:10b6:610:b1::16)
 by SN7PR12MB8772.namprd12.prod.outlook.com (2603:10b6:806:341::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.7; Thu, 18 Dec
 2025 20:27:31 +0000
Received: from DS3PEPF0000C37A.namprd04.prod.outlook.com
 (2603:10b6:610:b1:cafe::1) by CH0PR13CA0011.outlook.office365.com
 (2603:10b6:610:b1::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9456.5 via Frontend Transport; Thu,
 18 Dec 2025 20:27:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF0000C37A.mail.protection.outlook.com (10.167.23.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Thu, 18 Dec 2025 20:27:31 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 18 Dec
 2025 12:27:16 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 18 Dec
 2025 12:27:15 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Thu, 18 Dec 2025 12:27:14 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: [PATCH v1 2/9] iommu/arm-smmu-v3: Add alloc_id/free_id functions to arm_smmu_invs
Date: Thu, 18 Dec 2025 12:26:48 -0800
Message-ID: <1541ea4a9e9c935c2f907c0c5f13a4af2bdc2114.1766088962.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37A:EE_|SN7PR12MB8772:EE_
X-MS-Office365-Filtering-Correlation-Id: c1a18c0b-a9b5-4bc6-2c27-08de3e73def7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NhdFV2eXxynULxEZlaKFxkx1xCg/h/GyudZ8KdKc8FSLpH0u4a4s5Cxskvd/?=
 =?us-ascii?Q?EvwIV3BwUCXdQOKnz5Yd9pCNb9e/75WmlDIBfdRe66hgW0K1VAAHY8MOeA5b?=
 =?us-ascii?Q?xqsCe5lbaQJAiru++tbfVWN32Xy0a2ozloe4THjv4ucZW5dVNzYIUlqUlZTz?=
 =?us-ascii?Q?6+nZSTFJqH/gIgGPSycz+e7ARngZ40PZS9cBIlG9sdtbm2fq8uRv1AQBYbN5?=
 =?us-ascii?Q?jGtTvfH2r7DeUrT88bqjmaF2Q+Zn11wUZjdZc9ZnSQZ7ACxZESkhDEYGg/sh?=
 =?us-ascii?Q?k7MPUcyiCyWx78watqlyzwIxgJ7/Cf7VpimKWnlOZAD4cKEM+J/L0osNudYf?=
 =?us-ascii?Q?YivBqcj1Xqt9alhDSYPguDAegF59tkeE23vFWQrTXMH1lW1Ex+tcpM5/VG6L?=
 =?us-ascii?Q?YtkW54RwfFZAabrFJehd52nYMBdI0c/EAgSJz29twggPOOXFXTeireHtZSnE?=
 =?us-ascii?Q?+RnFcYoW0yoCf2zyOfZe5jLBfSCSu2a9ybjMcrRaDrqGPv82FKM9xMoZkTEw?=
 =?us-ascii?Q?lIPU774ZpEkMep+kCakS7dBo0cAXp6AxwCo4uE9My7WSYXQQdSGA/RPVspXc?=
 =?us-ascii?Q?+/gXGOoMmsjuvPdaka0EzY/Fupcael7yBHjUUBSYXbtbFTcMAu7JgTZhqJvL?=
 =?us-ascii?Q?tVo231WzXc1PyvJ1o+ErKlWsHCXA+8POScJDprrUew97K/DucY2DMR9DG/Bv?=
 =?us-ascii?Q?lpYz9aJIzZ6IzZADOAtHw3uodRJf/hfJsu9IxiBlNZJqv8OXQiKnMvrpI0aJ?=
 =?us-ascii?Q?uOPUOCrr9bZH6F3OOZhH3usKvjMbJDZ/1JSLAbDqK0F9P+T1dEIzlyZqGkmR?=
 =?us-ascii?Q?hQrJa/TbTQpZ4OzE8jJPCGHw4LKQRUfPmLQDVWw/K2brNqMh/7C2b+Dr4hik?=
 =?us-ascii?Q?uWUmTf05OSr4eWBqHiVwxeYfk7LXDCDrbbHcL9UcNdlUaMrqI04Jk/UDycak?=
 =?us-ascii?Q?f2C/NbURBcFTJ5O4QDcEUtexBSJSvWHHGHa8tdeRRV8zWe9JV2SZjO/ARMZ9?=
 =?us-ascii?Q?mwwjO/MqbArfoV+Z6cPqTB6+V1tlrPa0Mp1ZamBD1yiaMQewfXTe6mr0U23a?=
 =?us-ascii?Q?yGSv0tPfZ17e468hk46GhdLscPjfYvEWlR/fe/ZJWqq0DFfO8blmPrML1MWk?=
 =?us-ascii?Q?+CNCQn6K7Dm5rh1MCDm51mc3ssmYKXIuBLhptUHoERDg2ETYDvAIIRxnl720?=
 =?us-ascii?Q?KVM1TeJGDalkEalIBD/OVP6sc9xUuZnfPAS4OKH+X+SzPCsxozGucIVUokiI?=
 =?us-ascii?Q?/fQioh5ny+C8yY5QfZfRrAK8pvnmiDVsu6ErrxR62U+sW9zYwAOsaBQX7QW4?=
 =?us-ascii?Q?tS5Hhdb5XWTg6Or+MaxJ55OdYTUQdnhtCp2mbNPk2TjMdiob1Y4jYFNyTFWq?=
 =?us-ascii?Q?qMotEXyiXakpdJSVoPsJcgjIq++6nlPfFLwC8oTG/qZSUCYt+uL+qwI/JuWh?=
 =?us-ascii?Q?wyabcG8+iRJ4yUtMeiWv+Xr6+gJj9qd5cDWth9NCAbCYPqduRiTv0GxzR2fY?=
 =?us-ascii?Q?xINMwP10T/2yz/hb8wQbXuSp5dN+3wMoP1Dl4ezYNcpwwqoxccXITM1tIOvy?=
 =?us-ascii?Q?Nm2d+Ps6yw4E5s/3eV8=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 20:27:31.4898
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a18c0b-a9b5-4bc6-2c27-08de3e73def7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8772

An iotlb tag (ASID/VMID) will not be used:
1) Before being installed to CD/STE during a device attachment
2) After being removed from CD/STE during a device detachment

Both (1) and (2) exactly align with the lifecyle of the domain->invs. So,
it becomes very nature to use domain->invs to allocate/free an ASID/VMID.

Add a pair of function ops in struct arm_smmu_invs, to manage iotlb tag.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  6 ++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 93 +++++++++++++++++++++
 2 files changed, 99 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 0a5aead300b6..b275673c03ce 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -691,6 +691,9 @@ static inline bool arm_smmu_inv_is_ats(const struct arm_smmu_inv *inv)
  * @rwlock: optional rwlock to fench ATS operations
  * @has_ats: flag if the array contains an INV_TYPE_ATS or INV_TYPE_ATS_FULL
  * @rcu: rcu head for kfree_rcu()
+ * @smmu_domain: owner domain of the array
+ * @alloc_id: a callback to allocate a new iotlb tag
+ * @free_id: a callback to free an iotlb tag when its user counter reaches 0
  * @inv: flexible invalidation array
  *
  * The arm_smmu_invs is an RCU data structure. During a ->attach_dev callback,
@@ -720,6 +723,9 @@ struct arm_smmu_invs {
 	rwlock_t rwlock;
 	bool has_ats;
 	struct rcu_head rcu;
+	struct arm_smmu_domain *smmu_domain;
+	int (*alloc_id)(struct arm_smmu_inv *inv, void *data);
+	void (*free_id)(struct arm_smmu_inv *inv, bool flush);
 	struct arm_smmu_inv inv[] __counted_by(max_invs);
 };
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index bf0df16cec45..8a2b7064d29b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3117,6 +3117,94 @@ static void arm_smmu_disable_iopf(struct arm_smmu_master *master,
 		iopf_queue_remove_device(master->smmu->evtq.iopf, master->dev);
 }
 
+/*
+ * When an array entry's users count reaches zero, it means the ASID/VMID is no
+ * longer being invalidated by map/unmap and must be cleaned. The rule is that
+ * all ASIDs/VMIDs not in an invalidation array are left cleared in the IOTLB.
+ */
+static void arm_smmu_inv_free_asid(struct arm_smmu_inv *inv, bool flush)
+{
+	lockdep_assert_held(&arm_smmu_asid_lock);
+
+	if (inv->type != INV_TYPE_S1_ASID)
+		return;
+	if (refcount_read(&inv->users))
+		return;
+
+	if (flush) {
+		struct arm_smmu_cmdq_ent cmd = {
+			.opcode = inv->nsize_opcode,
+			.tlbi.asid = inv->id,
+		};
+
+		arm_smmu_cmdq_issue_cmd_with_sync(inv->smmu, &cmd);
+	}
+
+	/* Lastly, free the ASID as the last user detached */
+	xa_erase(&arm_smmu_asid_xa, inv->id);
+}
+
+static void arm_smmu_inv_free_vmid(struct arm_smmu_inv *inv, bool flush)
+{
+	lockdep_assert_held(&arm_smmu_asid_lock);
+
+	/* Note S2_VMID using nsize_opcode covers S2_VMID_S1_CLEAR already */
+	if (inv->type != INV_TYPE_S2_VMID)
+		return;
+	if (refcount_read(&inv->users))
+		return;
+
+	if (flush) {
+		struct arm_smmu_cmdq_ent cmd = {
+			.opcode = inv->nsize_opcode,
+			.tlbi.vmid = inv->id,
+		};
+
+		arm_smmu_cmdq_issue_cmd_with_sync(inv->smmu, &cmd);
+	}
+
+	/* Lastly, free the VMID as the last user detached */
+	ida_free(&inv->smmu->vmid_map, inv->id);
+}
+
+static int arm_smmu_inv_alloc_asid(struct arm_smmu_inv *inv, void *data)
+{
+	struct arm_smmu_domain *smmu_domain = data;
+	struct arm_smmu_device *smmu = inv->smmu;
+	u32 asid;
+	int ret;
+
+	lockdep_assert_held(&arm_smmu_asid_lock);
+
+	/* Allocate a new iotlb_tag.id */
+	WARN_ON(inv->type != INV_TYPE_S1_ASID);
+
+	ret = xa_alloc(&arm_smmu_asid_xa, &asid, smmu_domain,
+		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
+	if (ret)
+		return ret;
+	inv->id = asid;
+	return 0;
+}
+
+static int arm_smmu_inv_alloc_vmid(struct arm_smmu_inv *inv, void *data)
+{
+	struct arm_smmu_device *smmu = inv->smmu;
+	int vmid;
+
+	lockdep_assert_held(&arm_smmu_asid_lock);
+
+	WARN_ON(inv->type != INV_TYPE_S2_VMID);
+
+	/* Reserve VMID 0 for stage-2 bypass STEs */
+	vmid = ida_alloc_range(&smmu->vmid_map, 1, (1 << smmu->vmid_bits) - 1,
+			       GFP_KERNEL);
+	if (vmid < 0)
+		return vmid;
+	inv->id = vmid;
+	return 0;
+}
+
 static struct arm_smmu_inv *
 arm_smmu_master_build_inv(struct arm_smmu_master *master,
 			  enum arm_smmu_inv_type type, u32 id, ioasid_t ssid,
@@ -3191,12 +3279,17 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 					       smmu_domain->cd.asid,
 					       IOMMU_NO_PASID, pgsize))
 			return NULL;
+		master->build_invs->alloc_id = arm_smmu_inv_alloc_asid;
+		master->build_invs->free_id = arm_smmu_inv_free_asid;
+		master->build_invs->smmu_domain = smmu_domain;
 		break;
 	case ARM_SMMU_DOMAIN_S2:
 		if (!arm_smmu_master_build_inv(master, INV_TYPE_S2_VMID,
 					       smmu_domain->s2_cfg.vmid,
 					       IOMMU_NO_PASID, pgsize))
 			return NULL;
+		master->build_invs->alloc_id = arm_smmu_inv_alloc_vmid;
+		master->build_invs->free_id = arm_smmu_inv_free_vmid;
 		break;
 	default:
 		WARN_ON(true);
-- 
2.43.0


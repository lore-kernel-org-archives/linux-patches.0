Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010066.outbound.protection.outlook.com [52.101.46.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03363318BB3;
	Thu, 22 Jan 2026 01:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769045105; cv=fail; b=SwmNM/DX6LxOhJs4+tQ50PY7629zicJ1Yaktaq0S5JI/AgmrXDEHcPMIzw83RMunKchW9JMKBjk/E2NfN4Y98G26JxbJFusBhsbxvXQMvGtl4IXT/CCPgJSMcaY1uEYNi7Voxt+u7cwdw6GPbRuipXThvQYb0wpQBrAOd/3XF4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769045105; c=relaxed/simple;
	bh=mS+fpMMXntSspOJWthRoV8Syg6SNZk0Limts+sH/ZfU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nZKAPkGmig33hLcDbE9l2oIBKNHAk38TJzI0BVNetvL6GF2KdEdxZ3MsA+KHTqI2Dg9GFICjJ6EJERQ8l7k7IY1HxohASYIM09UMXgdO2V0iQgNNjEJN7mnHF48H7QlfEdHlTE3ZX7gFG1KutC55D4EfsoageNgb9/LzNR1k/xA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MSkqomm9; arc=fail smtp.client-ip=52.101.46.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MSkqomm9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eiSbkdwAeItsL1T4moYsW5rLDtrPfE7cxOTCRcDdWSaG1509bixj7/CjT+L2CHD/HGk5mSgOrJDvWluO/eJN5vbl7k34ps9CU1Ye9xL5LO4gs53SUBhH0rkd+63g7vKFY5pRzLtLYD13gZ9b16I13eb40nYQxCj1AcTyqKA8u8fp+yM4bG/FBKHTODhdZNClRy33YtdMFHYUb2uldft2TaUkzoULAjqyPIUXIhMrESDN329AqbPr1WwP2JqISBDcR1ZWyhd3FfLIFyaL/WYsfH+lpSSaTnNW/aT7OvteL4idQ94tOLV5ZUJifSF5D1AYgdRiBal+pMkIxnZvvcV5ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/3wZ7rELXgAmyYu7OOBxxQDLeYStnj8tuX3363rFhbc=;
 b=eNGkpDO1AUqSmdSnWwsZjT2ie1dPbo1ysWHRygJ6lL2CNe4lF7h9vHo2xMMAHt18JRZV7CXr+WEgOjHiRCcwOubQcTkRZkwf4mW2IRYlDxRoWXUNlB/I+61vEGwU7P/t7HF8UAFZeXBoAkXRqin5U3S+QiIltVNsrmOtnid852Y3qbnQG4FO3slfps2MIBCKHC4vwIwtwm3SyO3zuwZJjGQTPAkWZkJ6UA/1VWXb2Dlg/b8lFmhx2a5AwTD6e+nf1Hj9YJ462v56dsq71teNLuaqDPVYPYJwMPod4JGVXvYZpG4t7sqkN6GsRG8rXM2vjcvUPRn9PLe6nxO7d6C5mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/3wZ7rELXgAmyYu7OOBxxQDLeYStnj8tuX3363rFhbc=;
 b=MSkqomm95EbZaRBAQ2ur1FfI+BXtnQcjtppkPNtgMBXRNmPN65FXitHHlhU3nkTRQc3oCR5uCu5PO5LqyRGpLRuAlWOanZnFlk2qBF0ZiRbPeTjIOOFPi4ivHO6rqxN5eet63UVhNuVU1Jv+lbwJGwXmQV0Bo1jiZf9bqPj6IKo7gI9MJnFKJFG5EepkHvx4CEri2Bxwp//kRCJLu+5gPaYEkbxbuXBv7hQN8d9nUbpiEEFzhnuP7Mfdfx6bvSFjatg6mdzhYhBEE2+QrGmnGp2I2nSjwFuiNcHAvhziNUngUgJNtDmeNQX1mDnYi8oZd9KvKSNOgeokPSnjqK2WuA==
Received: from CH2PR19CA0013.namprd19.prod.outlook.com (2603:10b6:610:4d::23)
 by LV2PR12MB5798.namprd12.prod.outlook.com (2603:10b6:408:17a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 01:24:47 +0000
Received: from CH2PEPF00000143.namprd02.prod.outlook.com
 (2603:10b6:610:4d:cafe::d4) by CH2PR19CA0013.outlook.office365.com
 (2603:10b6:610:4d::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.10 via Frontend Transport; Thu,
 22 Jan 2026 01:24:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF00000143.mail.protection.outlook.com (10.167.244.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Thu, 22 Jan 2026 01:24:47 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 21 Jan
 2026 17:24:38 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 21 Jan 2026 17:24:37 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Wed, 21 Jan 2026 17:24:37 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: [PATCH v2 01/10] iommu/arm-smmu-v3: Store IOTLB cache tags in struct arm_smmu_attach_state
Date: Wed, 21 Jan 2026 17:24:19 -0800
Message-ID: <40ecdf7e0766004c5d3a4bd086cb22cf08254237.1769044718.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769044718.git.nicolinc@nvidia.com>
References: <cover.1769044718.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000143:EE_|LV2PR12MB5798:EE_
X-MS-Office365-Filtering-Correlation-Id: ac97e69b-0651-451f-bb22-08de595507de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DvTKF6+hc0ny8iELoLc9QbI6MNiFveg39Tobh7Nz1vhoXVTm6VzbzvhGhIT6?=
 =?us-ascii?Q?eqfiTjhEoxVGSRO1JC31pIiEwOCgMrV1O39KN//aw26hBgrSQOSj8hy5VUQr?=
 =?us-ascii?Q?f/A94+LziFnDzOO8bqJ2deIqgQf5jbWQgp0m5sKMGnUQccKvNxAXX8ZOnLyj?=
 =?us-ascii?Q?wVo9fulNgDm2oSK45fgid/WyoL9sr9OaPM62shOWlf6NDhBcmqVVOIx3mXQC?=
 =?us-ascii?Q?zx8HSyOQaLUt049U+5kG/x6htnT76yS248xYecJRUbLNKSl6XNa1UeXIE4Cz?=
 =?us-ascii?Q?ctC1c4dquQH4gQhnJ++7nmL4oBZ792DdmrwmpDttvgDlqoJRkKeDp6kScnd0?=
 =?us-ascii?Q?mI4ZdAeeL+3fRsybllNioNXqDn7aj3DPVWB6baFPGZVwYpxBjyA+QsRQBrm0?=
 =?us-ascii?Q?kBOuFa84Iq3EM3smefOYJi195sJhRZ/UK+H95ONfGbhjTN+aY9OIyKBNQf1c?=
 =?us-ascii?Q?RdPiNmOtIyyOz7yhps8Tp8bePnIocCKGKN3vUjvYibSTBJ6rvHthnfmcWrye?=
 =?us-ascii?Q?wZG6GGnGLFaERm49xIXBY8yyyipNVoHQlx20uh/L2Ypw5aqZEJFrIUialTlx?=
 =?us-ascii?Q?g6NL618yKC27ps+YBnd5g6RvGZwFJSMVGK9rNWxAkiv8oi/juCbDkrOsWFJe?=
 =?us-ascii?Q?HtInfhL/UbvO7N7WT+s8UxRUFsG2CfVrDS4m6f0OWhwjwWbgiIg1yo+r209D?=
 =?us-ascii?Q?tpE9c02kEfrxoO0/29KeMKTRt6H8/o+TksunjwW3d+0ssao1GCwZGYJMEFY2?=
 =?us-ascii?Q?TBMiDIonQfqEBd2FIMaQN7GoB+ABLzEo216JEiylBECP7HmhTWUDVNCroko9?=
 =?us-ascii?Q?u73+69MqFB/+4lJDBT7AHiZhKit1EbuSVdFIO46mVePCF8iXXnzcV7NMBFiF?=
 =?us-ascii?Q?fYWbWezMClaG/TViPbD5O3PEJ2jM8lEJ6GsgCCWWS4Gz8ff8eDHKeShM6yFh?=
 =?us-ascii?Q?h9AGiz9IM1JWcK4TwZoCf7YhBQThfiq6KW+21g9HxVATTVnS5X+YWSPifj+w?=
 =?us-ascii?Q?DgOZxTxN3FjEUZD2kUg4Yc+cyMoUn+YDZ4VXAZsAV2cxR5fsCovyW4y/gzE3?=
 =?us-ascii?Q?qyyykVM070oUcKLFiv+iPKjE+FpgOAgBsme637wviRsB5B8prQcntgz06re9?=
 =?us-ascii?Q?BntBsLwhatUytr0yHXSDGOOEbBv+35AUvSw4q8rT++LpM9zDBhC2A9v6P6KP?=
 =?us-ascii?Q?ieB93SJ3RFYQGlJu9MTEiWRrKBGE7NRA+tGyL9Mk7UIHTCJJy6TPR4fwjVvy?=
 =?us-ascii?Q?sGl5bnXEVPiqWhYFka9mAAFu1xHseu7CUX6Awfn3xfoF38HDHCPzvBXGADvG?=
 =?us-ascii?Q?kruHkld8XCYL8lnTRBcFMWnWsEtw3o3Oz36bJpAjHAU+dgMAFXDNzP1t4hV2?=
 =?us-ascii?Q?1ZkDzst2Ao6jkAFU5IPlHUiqXUdm0Fpd1oD3DSQFFwSieC+SfuajyG9Na1RB?=
 =?us-ascii?Q?EYVkVLxGk04GHmygpFaP2L41zYyK6XggiXHsC2w0LcnyJvigduWW/NAPIgtO?=
 =?us-ascii?Q?22k1eO+dt+p2ygbiq5knnTPK3NvMwWr3c20gDQcMGtWYqr5bNPHDJMfLdJjt?=
 =?us-ascii?Q?A4Sndv6TabBcy1/QZjLs0UTyPfCgPShBAMt5m/kzFtnBYkGZ7moOAw1Yy33/?=
 =?us-ascii?Q?CLciCNdvLHUoleE2LUh+QBUhylVK6jvRB3S/fgH8nSS+cJdJ0YGuID8uUN9I?=
 =?us-ascii?Q?bz0JRg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 01:24:47.1393
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac97e69b-0651-451f-bb22-08de595507de
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000143.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5798

So far, an IOTLB tag (ASID or VMID) has been stored in the arm_smmu_domain
structure. Its lifecycle is aligned with the smmu_domain.

However, an IOTLB tag (ASID/VMID) will not be used:
1) Before being installed to CD/STE during a device attachment
2) After being removed from CD/STE during a device detachment

Both (1) and (2) exactly align with the lifecycle of smmu_domain->invs.

The bigger problem is that storing the IOTLB tag in struct arm_smmu_domain
makes it difficult to share across SMMU instances, a common use case for a
nesting parent domain.

Store the IOTLB tags (old domain's and new domain's) in the state. This'll
be forwarded to CD and STE entries, to replace the references of cd->asid
and s2_cfg->vmid from the smmu_domain.

Add a new arm_smmu_domain_get_iotlb_tag() helper provisionally copying the
existing IOTLB tags from smmu_domain to fill arm_smmu_master_build_invs().
Later it will retrieve an IOTLB tag from the smmu_domain->invs or allocate
a new one for the lifecycle issue.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  6 ++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 78 ++++++++++++++-------
 2 files changed, 60 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 4f104c1baa67..73cb59c7d4b1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1111,11 +1111,13 @@ static inline bool arm_smmu_master_canwbs(struct arm_smmu_master *master)
  * @new_invs: for new domain, this is the new invs array to update domain->invs;
  *            for old domain, this is the master->build_invs to pass in as the
  *            to_unref argument to an arm_smmu_invs_unref() call
+ * @tag: IOTLB cache tag (INV_TYPE_S1_ASID or INV_TYPE_S2_VMID)
  */
 struct arm_smmu_inv_state {
 	struct arm_smmu_invs __rcu **invs_ptr;
 	struct arm_smmu_invs *old_invs;
 	struct arm_smmu_invs *new_invs;
+	struct arm_smmu_inv tag;
 };
 
 struct arm_smmu_attach_state {
@@ -1132,6 +1134,10 @@ struct arm_smmu_attach_state {
 	bool ats_enabled;
 };
 
+int arm_smmu_domain_get_iotlb_tag(struct arm_smmu_domain *smmu_domain,
+				  struct arm_smmu_device *smmu,
+				  struct arm_smmu_inv *tag);
+
 int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 			    struct iommu_domain *new_domain);
 void arm_smmu_attach_commit(struct arm_smmu_attach_state *state);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 9912262a0e3b..325eabb51c81 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3117,6 +3117,33 @@ static void arm_smmu_disable_iopf(struct arm_smmu_master *master,
 		iopf_queue_remove_device(master->smmu->evtq.iopf, master->dev);
 }
 
+int arm_smmu_domain_get_iotlb_tag(struct arm_smmu_domain *smmu_domain,
+				  struct arm_smmu_device *smmu,
+				  struct arm_smmu_inv *tag)
+{
+	/* Decide the type of the iotlb cache tag */
+	switch (smmu_domain->stage) {
+	case ARM_SMMU_DOMAIN_SVA:
+	case ARM_SMMU_DOMAIN_S1:
+		tag->type = INV_TYPE_S1_ASID;
+		break;
+	case ARM_SMMU_DOMAIN_S2:
+		tag->type = INV_TYPE_S2_VMID;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	tag->smmu = smmu;
+
+	if (tag->type == INV_TYPE_S1_ASID)
+		tag->id = smmu_domain->cd.asid;
+	else
+		tag->id = smmu_domain->s2_cfg.vmid;
+
+	return 0;
+}
+
 static struct arm_smmu_inv *
 arm_smmu_master_build_inv(struct arm_smmu_master *master,
 			  enum arm_smmu_inv_type type, u32 id, ioasid_t ssid,
@@ -3176,7 +3203,8 @@ arm_smmu_master_build_inv(struct arm_smmu_master *master,
  */
 static struct arm_smmu_invs *
 arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
-			   ioasid_t ssid, struct arm_smmu_domain *smmu_domain)
+			   ioasid_t ssid, struct arm_smmu_domain *smmu_domain,
+			   struct arm_smmu_inv *tag)
 {
 	const bool nesting = smmu_domain->nest_parent;
 	size_t pgsize = 0, i;
@@ -3189,30 +3217,15 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 	if (master->smmu->features & ARM_SMMU_FEAT_RANGE_INV)
 		pgsize = __ffs(smmu_domain->domain.pgsize_bitmap);
 
-	switch (smmu_domain->stage) {
-	case ARM_SMMU_DOMAIN_SVA:
-	case ARM_SMMU_DOMAIN_S1:
-		if (!arm_smmu_master_build_inv(master, INV_TYPE_S1_ASID,
-					       smmu_domain->cd.asid,
-					       IOMMU_NO_PASID, pgsize))
-			return NULL;
-		break;
-	case ARM_SMMU_DOMAIN_S2:
-		if (!arm_smmu_master_build_inv(master, INV_TYPE_S2_VMID,
-					       smmu_domain->s2_cfg.vmid,
-					       IOMMU_NO_PASID, pgsize))
-			return NULL;
-		break;
-	default:
-		WARN_ON(true);
+	if (!arm_smmu_master_build_inv(master, tag->type, tag->id,
+				       IOMMU_NO_PASID, pgsize))
 		return NULL;
-	}
 
 	/* All the nested S1 ASIDs have to be flushed when S2 parent changes */
 	if (nesting) {
-		if (!arm_smmu_master_build_inv(
-			    master, INV_TYPE_S2_VMID_S1_CLEAR,
-			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID, 0))
+		if (!arm_smmu_master_build_inv(master,
+					       INV_TYPE_S2_VMID_S1_CLEAR,
+					       tag->id, IOMMU_NO_PASID, 0))
 			return NULL;
 	}
 
@@ -3280,7 +3293,9 @@ static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
 	struct arm_smmu_domain *old_smmu_domain =
 		to_smmu_domain_devices(state->old_domain);
 	struct arm_smmu_master *master = state->master;
+	struct arm_smmu_device *smmu = master->smmu;
 	ioasid_t ssid = state->ssid;
+	int ret;
 
 	/*
 	 * At this point a NULL domain indicates the domain doesn't use the
@@ -3294,8 +3309,16 @@ static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
 		invst->old_invs = rcu_dereference_protected(
 			new_smmu_domain->invs,
 			lockdep_is_held(&arm_smmu_asid_lock));
-		build_invs = arm_smmu_master_build_invs(
-			master, state->ats_enabled, ssid, new_smmu_domain);
+
+		ret = arm_smmu_domain_get_iotlb_tag(new_smmu_domain, smmu,
+						    &invst->tag);
+		if (ret)
+			return ret;
+
+		build_invs = arm_smmu_master_build_invs(master,
+							state->ats_enabled,
+							ssid, new_smmu_domain,
+							&invst->tag);
 		if (!build_invs)
 			return -EINVAL;
 
@@ -3316,9 +3339,16 @@ static int arm_smmu_attach_prepare_invs(struct arm_smmu_attach_state *state,
 			invst->old_invs = rcu_dereference_protected(
 				old_smmu_domain->invs,
 				lockdep_is_held(&arm_smmu_asid_lock));
+
+		ret = arm_smmu_domain_get_iotlb_tag(old_smmu_domain, smmu,
+						    &invst->tag);
+		if (WARN_ON(ret))
+			return ret;
+
 		/* For old_smmu_domain, new_invs points to master->build_invs */
 		invst->new_invs = arm_smmu_master_build_invs(
-			master, master->ats_enabled, ssid, old_smmu_domain);
+			master, master->ats_enabled, ssid, old_smmu_domain,
+			&invst->tag);
 	}
 
 	return 0;
-- 
2.43.0


Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012055.outbound.protection.outlook.com [40.107.209.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8742526561E;
	Thu, 22 Jan 2026 01:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769045105; cv=fail; b=BpaMv7k0IVAm+goW3dHT+YhS3OyeA/MUeHEritAKNht10LIKpI86Ih9J7BBOPxcLO7bu50SHjfrJLthMsjAKpCD/R9qqzvUPc0ZOXOD8IMBRWXX7PFHyOdvvNNrLdNGGJJDfsehgXRsb8r1VSL9hmneCY2YsmYKotrTlFmLf7gA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769045105; c=relaxed/simple;
	bh=0iSI6mg4eK8sX6zdGZhl4BeLvsVdijU+yqBM6vV5jzk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oVTVgjEfAGjfK8ESafRLrjvI2Osd1adRt/ifhaI6YUiMotoCl0e2Wkogx3mtr0VFc1ht+eq/30ZqO7g1Ll3k221KG9vH3SM0QSL3io0AedlMzPDKsZgTDph6vKgz+RPygeIjPRgHLNVLCBNDO9XmnJH5QgnDyFEn9PYruUoA+4w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tTJlBuBF; arc=fail smtp.client-ip=40.107.209.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tTJlBuBF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I63vBhAhyCj1iNwmHsw5JLuhPrrCN8xCE3Yb461DYT8XYve7rOV0Pop5JYZ8md2C8wx9vA2XK3Als5oIq+LVZ8e5ORwUORVnyrWQNGtCUtc2tcXBwMldT2fFj2fHSCPnqBidp9jgoWVCHDz90Ka+nqwm5ltrb3zqVq5SgREJ1gWqoGQ+/M4BggemrOE1M4kcobx+5wG4Tm6On4wJ+Ij9UPUMfmnDtNmKx0W+bU9h6VX6s6UYiCWj6ye8C8AHRs4PNwjH5uYvD8MkD41xC7GjzhUds2ehHrrPnjBqoV27TXLWALonO70Dn1rPY/th6iRJ/SI9T7lEu8ISfPplY8vzww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SBYYSaHRPWFVhrs3khdhM/CTNs03PRxgitB79Qb3qXs=;
 b=FEiN0dq7CWGngk4cTfx2dstfdZAZPs1Omi0E2og4ZdwMfDwldmPwHPcUk0OKuFIzYsLAJbl3b3pJPcYfhDnwsiSsYFNzcffx6ojqpMOfTitMYVEyBUscQHqHqSeaC8VB/6Y6/R23uVu8InctASfttJVGVNfXQep12qVVYSMryFxTRWREx0IHaxMsrn7h2IAme5ZxjjumnUBfvjSe9htiAtKsxzCk8D1JSvo9IxfMslteXMl0EOm08YpWncRurZvXZEsu4aQ0JDuSX1syony/0cg5LKi3RmoKwAkp60LWkQVZIBwv5rrOBh2ngih357kduf8g3u9jvJuHJp8cNi0n5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBYYSaHRPWFVhrs3khdhM/CTNs03PRxgitB79Qb3qXs=;
 b=tTJlBuBFR9CHD+r6P1fkgAMT4xi+sZAZB5yF0h5z4OOcPSl84BsX/SPUQm5ATgAipCrnaENy4dYfpWs5gxi4kaHASotKqgKtlpsEz9W0eDfhKAwkXLAI7qf5LUPafQVsUQ9g4cwsWV6lXjhoTWMwsLb3x+CP8r1GrwE2fO1eqNxFQ2ZHBeGD9c/xzDNwvx6psDl9AhCqgNHcUFlj/GQNM9zq1Of2kYNCF50rcuasD3/4yUsOnCptxKBKKcQAj8PTrrlsJBf6m6EZzWAT8C4Duuyp8fsznWhwoEBcAMyNh0fxlI/jLGGw0HD0hp2leXDZiwF7YXCDQb7xS2lMMX/KOA==
Received: from SA9P221CA0016.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::21)
 by DS0PR12MB6437.namprd12.prod.outlook.com (2603:10b6:8:cb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 01:24:47 +0000
Received: from SA2PEPF000015CD.namprd03.prod.outlook.com
 (2603:10b6:806:25:cafe::75) by SA9P221CA0016.outlook.office365.com
 (2603:10b6:806:25::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.9 via Frontend Transport; Thu,
 22 Jan 2026 01:24:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SA2PEPF000015CD.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Thu, 22 Jan 2026 01:24:46 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 21 Jan
 2026 17:24:39 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 21 Jan 2026 17:24:38 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Wed, 21 Jan 2026 17:24:38 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: [PATCH v2 02/10] iommu/arm-smmu-v3: Pass in IOTLB cache tag to CD and STE
Date: Wed, 21 Jan 2026 17:24:20 -0800
Message-ID: <b151df032c200f4c1123bb184102665ded00351d.1769044718.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CD:EE_|DS0PR12MB6437:EE_
X-MS-Office365-Filtering-Correlation-Id: f4b64db0-ee0c-48a0-19f5-08de595507ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DnE5lHNVfiYiUddu6f1JQVysn2yBkbiIJAainqHFL+ICc7AxX/YhbwHO5BpI?=
 =?us-ascii?Q?X9NfxgSsyrqJe6Y2RYAlNOInga8RqE9abppaAW20tSHLvJqPCJxSI6m677hh?=
 =?us-ascii?Q?vQsz13Epcgj17xSDEp6uvik+7xQvlarBdQGq9MUvNyN+f4Ye1sBEbl+Oelff?=
 =?us-ascii?Q?2M75etJPgW1mVF6t+Ya400AXAce4MT7CkvgDX2m+lAdV/6HFwsnM9XlI5idf?=
 =?us-ascii?Q?2WksP4xN5sorMhZqrKhbh5D+2Hlha9BAt/ZoaMkCLi7ObRbllFvIALoqjJO5?=
 =?us-ascii?Q?1w8xnEBiVwPEIOgb/mT4z+Ti9t+1mchgu6NB3Zl90mEt3BuMTJrAlvItiK4T?=
 =?us-ascii?Q?/cIgBEC7wOQUIQclu0qAnlYagpoRtBzMURK2Mx0StHAxPVbzfynOva7I6HvU?=
 =?us-ascii?Q?sYRsQZXsIQyS/ywA+8TTL1YLWGfoSQSoSQgFkcls2h8OWTyYIxSx9BXPGOaE?=
 =?us-ascii?Q?iHRVjJRQ31mSQj6C+9v6kkc+CMLxavEATXkAvm7fUUgeNoSM15Oqxo/NTSDo?=
 =?us-ascii?Q?PnH6LcQNXHAhCo6LUvwfGzEWhAmNcLEJIwcpRuLpD1nuZojyzK4zyAKSUTPL?=
 =?us-ascii?Q?6YWsizHLx3eAuq3YFkfpceqUcrsdU/1vb8FyFN9JsVXiBQp3zNYsyUc50Rl+?=
 =?us-ascii?Q?zd3COKYgdxNzAEmzOLa4kAe01yVB10srUR3HuCRqh/nsaM5uJMg3bGa1ndGn?=
 =?us-ascii?Q?/U08r0i2O4yCqxA4AXq3ibTtrMYZmbgGOcwv3qwKyaavR5XujWxKBcDrl/yB?=
 =?us-ascii?Q?1LSb42Ymyt+xEXzqGmRmgEghhsFsLrKuwSXvJFHLeKyrwKpRF3czRI989OtE?=
 =?us-ascii?Q?YMjhCY8qmSW/171FZHfL0url5ncKQMgh1uAe/I3X7JWQtZxhl/FkUoPQvlz6?=
 =?us-ascii?Q?wESBwMmP2F+TwIy+sRsYTua14ZYZq6vmmbfPGnAnfH/aYkFOWL4thN1mfQKS?=
 =?us-ascii?Q?sMa+17uRnMnH+6ux3qThk5GXVoptCVu74yz7E6gThgsfCHQNRYqv/k1O1Hb8?=
 =?us-ascii?Q?leZrfQgk15bRPHBWLGNkeSHm6SMR/qQhQ0k8dLkGv1AJ67/+QItnD+h4uNaN?=
 =?us-ascii?Q?6A6kckgIy5hYAdvEym28V+Res2npmQEEQ5ET7BDxFa/Ire3vbm6CK3Z8M8VO?=
 =?us-ascii?Q?RSZ84ayOTxvlnvvUAjSR25vnKuNK2f8mSid+XMaKRhaqxi/nCQxfYa4T0pCA?=
 =?us-ascii?Q?dKZu999m2VM9piaQn1xV7MPyxr8iVK2f+45OzkKSHc1jaaAl+T8CKr/OkxWH?=
 =?us-ascii?Q?Iz/sf8KfN/+H03b4aKYL20wxXwDZPTSNMhsNh1xZtKOlhEpYvcf25bYo8SIX?=
 =?us-ascii?Q?agby5fJOS1g+BeuZoSii/EXgzS4ZRMTbdBVGuYKB9IbOCeN7PhdhIji6sIax?=
 =?us-ascii?Q?GWVbwkOM8iJ9K4gYLHDx8V3bS+icN8RK77RGWdlGlFLhHby/icvakuOGsR5n?=
 =?us-ascii?Q?ta/n2Fi/7lCDQRPZ8954g0BW03PlkmJue9pHHZPjAShaeQtEsgc+7tE9KqN+?=
 =?us-ascii?Q?6H7/H/urclhjWkOnTpif4zRwZgNNYE/Dg/coBvH9ytBTFD67Dr0IlLNBnOUx?=
 =?us-ascii?Q?kEWPPuclqh5v+UQ1P/CGK2D/S8lDhavHsvLWlpmuQSNmorhKDXLdgLf5fspT?=
 =?us-ascii?Q?oxQUuTQBS8dbiC/Sqi5Pw8JWFw1Ou+hMq6VEeKhSfFMFezO2Bnnh+zHHZ6KY?=
 =?us-ascii?Q?DPbKjA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 01:24:46.7648
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4b64db0-ee0c-48a0-19f5-08de595507ab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6437

Now, struct arm_smmu_attach_state has the IOTLB cache tags copied from the
cd->asid or s2_cfg->vmid of an smmu_domain.

Pass it down to arm_smmu_make_s1_cd() and arm_smmu_make_s2_domain_ste() to
set in the CD and STE, removing the references of smmu_domain for its asid
or vmid.

Note the two set_dev_pasid callbacks finalize CDs in arm_smmu_set_pasid().
So, it is safe for arm_smmu_make_sva_cd() and arm_smmu_make_s1_cd() to use
a dummy iotlb tag (asid=0) because arm_smmu_set_pasid() will fix it.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  5 +--
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 26 ++++++++++------
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 22 ++++++++++---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 12 +++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 31 +++++++++++--------
 5 files changed, 65 insertions(+), 31 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 73cb59c7d4b1..11879148dad0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1005,7 +1005,7 @@ void arm_smmu_make_abort_ste(struct arm_smmu_ste *target);
 void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				 struct arm_smmu_master *master,
 				 struct arm_smmu_domain *smmu_domain,
-				 bool ats_enabled);
+				 struct arm_smmu_inv *tag, bool ats_enabled);
 
 #if IS_ENABLED(CONFIG_KUNIT)
 void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits);
@@ -1070,7 +1070,8 @@ struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid);
 void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 			 struct arm_smmu_master *master,
-			 struct arm_smmu_domain *smmu_domain);
+			 struct arm_smmu_domain *smmu_domain,
+			 struct arm_smmu_inv *tag);
 void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 			     struct arm_smmu_cd *cdptr,
 			     const struct arm_smmu_cd *target);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index 93fdadd07431..34c7bd4cfd84 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -39,12 +39,15 @@ void *arm_smmu_hw_info(struct device *dev, u32 *length,
 	return info;
 }
 
-static void arm_smmu_make_nested_cd_table_ste(
-	struct arm_smmu_ste *target, struct arm_smmu_master *master,
-	struct arm_smmu_nested_domain *nested_domain, bool ats_enabled)
+static void
+arm_smmu_make_nested_cd_table_ste(struct arm_smmu_ste *target,
+				  struct arm_smmu_master *master,
+				  struct arm_smmu_nested_domain *nested_domain,
+				  struct arm_smmu_inv *tag, bool ats_enabled)
 {
-	arm_smmu_make_s2_domain_ste(
-		target, master, nested_domain->vsmmu->s2_parent, ats_enabled);
+	arm_smmu_make_s2_domain_ste(target, master,
+				    nested_domain->vsmmu->s2_parent, tag,
+				    ats_enabled);
 
 	target->data[0] = cpu_to_le64(STRTAB_STE_0_V |
 				      FIELD_PREP(STRTAB_STE_0_CFG,
@@ -64,9 +67,11 @@ static void arm_smmu_make_nested_cd_table_ste(
  * - Bypass STE (install the S2, no CD table)
  * - CD table STE (install the S2 and the userspace CD table)
  */
-static void arm_smmu_make_nested_domain_ste(
-	struct arm_smmu_ste *target, struct arm_smmu_master *master,
-	struct arm_smmu_nested_domain *nested_domain, bool ats_enabled)
+static void
+arm_smmu_make_nested_domain_ste(struct arm_smmu_ste *target,
+				struct arm_smmu_master *master,
+				struct arm_smmu_nested_domain *nested_domain,
+				struct arm_smmu_inv *tag, bool ats_enabled)
 {
 	unsigned int cfg =
 		FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(nested_domain->ste[0]));
@@ -82,12 +87,12 @@ static void arm_smmu_make_nested_domain_ste(
 	switch (cfg) {
 	case STRTAB_STE_0_CFG_S1_TRANS:
 		arm_smmu_make_nested_cd_table_ste(target, master, nested_domain,
-						  ats_enabled);
+						  tag, ats_enabled);
 		break;
 	case STRTAB_STE_0_CFG_BYPASS:
 		arm_smmu_make_s2_domain_ste(target, master,
 					    nested_domain->vsmmu->s2_parent,
-					    ats_enabled);
+					    tag, ats_enabled);
 		break;
 	case STRTAB_STE_0_CFG_ABORT:
 	default:
@@ -185,6 +190,7 @@ static int arm_smmu_attach_dev_nested(struct iommu_domain *domain,
 	}
 
 	arm_smmu_make_nested_domain_ste(&ste, master, nested_domain,
+					&state.new_domain_invst.tag,
 					state.ats_enabled);
 	arm_smmu_install_ste_for_dev(master, &ste);
 	arm_smmu_attach_commit(&state);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index f1f8e01a7e91..dff494584008 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -24,12 +24,18 @@ arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 	list_for_each_entry(master_domain, &smmu_domain->devices, devices_elm) {
 		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd *cdptr;
+		struct arm_smmu_inv tag;
 
 		cdptr = arm_smmu_get_cd_ptr(master, master_domain->ssid);
 		if (WARN_ON(!cdptr))
 			continue;
 
-		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+		if (WARN_ON(arm_smmu_domain_get_iotlb_tag(smmu_domain,
+							  master->smmu, &tag)))
+			continue;
+		if (WARN_ON(tag.type != INV_TYPE_S1_ASID))
+			continue;
+		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain, &tag);
 		arm_smmu_write_cd_entry(master, master_domain->ssid, cdptr,
 					&target_cd);
 	}
@@ -158,12 +164,18 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 		struct arm_smmu_master *master = master_domain->master;
 		struct arm_smmu_cd target;
 		struct arm_smmu_cd *cdptr;
+		struct arm_smmu_inv tag;
 
 		cdptr = arm_smmu_get_cd_ptr(master, master_domain->ssid);
 		if (WARN_ON(!cdptr))
 			continue;
-		arm_smmu_make_sva_cd(&target, master, NULL,
-				     smmu_domain->cd.asid);
+
+		if (WARN_ON(arm_smmu_domain_get_iotlb_tag(smmu_domain,
+							  master->smmu, &tag)))
+			continue;
+		if (WARN_ON(tag.type != INV_TYPE_S1_ASID))
+			continue;
+		arm_smmu_make_sva_cd(&target, master, NULL, tag.id);
 		arm_smmu_write_cd_entry(master, master_domain->ssid, cdptr,
 					&target);
 	}
@@ -262,10 +274,12 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 		return -EINVAL;
 
 	/*
+	 * Use a dummy asid and fix it in arm_smmu_set_pasid().
+	 *
 	 * This does not need the arm_smmu_asid_lock because SVA domains never
 	 * get reassigned
 	 */
-	arm_smmu_make_sva_cd(&target, master, domain->mm, smmu_domain->cd.asid);
+	arm_smmu_make_sva_cd(&target, master, domain->mm, 0);
 	ret = arm_smmu_set_pasid(master, smmu_domain, id, &target, old);
 
 	mmput(domain->mm);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index 238bfd328b5b..81551fad727b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -306,6 +306,9 @@ static void arm_smmu_test_make_s2_ste(struct arm_smmu_ste *ste,
 	struct arm_smmu_domain smmu_domain = {
 		.pgtbl_ops = &io_pgtable.ops,
 	};
+	struct arm_smmu_inv tag = {
+		.type = INV_TYPE_S2_VMID,
+	};
 
 	io_pgtable.cfg.arm_lpae_s2_cfg.vttbr = 0xdaedbeefdeadbeefULL;
 	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.ps = 1;
@@ -316,7 +319,8 @@ static void arm_smmu_test_make_s2_ste(struct arm_smmu_ste *ste,
 	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.sl = 3;
 	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.tsz = 4;
 
-	arm_smmu_make_s2_domain_ste(ste, &master, &smmu_domain, ats_enabled);
+	arm_smmu_make_s2_domain_ste(ste, &master, &smmu_domain, &tag,
+				    ats_enabled);
 }
 
 static void arm_smmu_v3_write_ste_test_s2_to_abort(struct kunit *test)
@@ -461,6 +465,10 @@ static void arm_smmu_test_make_s1_cd(struct arm_smmu_cd *cd, unsigned int asid)
 			.asid = asid,
 		},
 	};
+	struct arm_smmu_inv tag = {
+		.type = INV_TYPE_S1_ASID,
+		.id = asid,
+	};
 
 	io_pgtable.cfg.arm_lpae_s1_cfg.ttbr = 0xdaedbeefdeadbeefULL;
 	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.ips = 1;
@@ -471,7 +479,7 @@ static void arm_smmu_test_make_s1_cd(struct arm_smmu_cd *cd, unsigned int asid)
 	io_pgtable.cfg.arm_lpae_s1_cfg.tcr.tsz = 4;
 	io_pgtable.cfg.arm_lpae_s1_cfg.mair = 0xabcdef012345678ULL;
 
-	arm_smmu_make_s1_cd(cd, &master, &smmu_domain);
+	arm_smmu_make_s1_cd(cd, &master, &smmu_domain, &tag);
 }
 
 static void arm_smmu_v3_write_cd_test_s1_clear(struct kunit *test)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 325eabb51c81..cf0543f276f3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1613,14 +1613,16 @@ void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 
 void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 			 struct arm_smmu_master *master,
-			 struct arm_smmu_domain *smmu_domain)
+			 struct arm_smmu_domain *smmu_domain,
+			 struct arm_smmu_inv *tag)
 {
-	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
 	const struct io_pgtable_cfg *pgtbl_cfg =
 		&io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
 	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =
 		&pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
+	WARN_ON(tag->type != INV_TYPE_S1_ASID);
+
 	memset(target, 0, sizeof(*target));
 
 	target->data[0] = cpu_to_le64(
@@ -1640,7 +1642,7 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 		CTXDESC_CD_0_R |
 		CTXDESC_CD_0_A |
 		CTXDESC_CD_0_ASET |
-		FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
+		FIELD_PREP(CTXDESC_CD_0_ASID, tag->id)
 		);
 
 	/* To enable dirty flag update, set both Access flag and dirty state update */
@@ -1897,9 +1899,8 @@ EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_cdtable_ste);
 void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				 struct arm_smmu_master *master,
 				 struct arm_smmu_domain *smmu_domain,
-				 bool ats_enabled)
+				 struct arm_smmu_inv *tag, bool ats_enabled)
 {
-	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
 	const struct io_pgtable_cfg *pgtbl_cfg =
 		&io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
 	typeof(&pgtbl_cfg->arm_lpae_s2_cfg.vtcr) vtcr =
@@ -1907,6 +1908,8 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 	u64 vtcr_val;
 	struct arm_smmu_device *smmu = master->smmu;
 
+	WARN_ON(tag->type != INV_TYPE_S2_VMID);
+
 	memset(target, 0, sizeof(*target));
 	target->data[0] = cpu_to_le64(
 		STRTAB_STE_0_V |
@@ -1930,7 +1933,7 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 		   FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, vtcr->tg) |
 		   FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, vtcr->ps);
 	target->data[2] = cpu_to_le64(
-		FIELD_PREP(STRTAB_STE_2_S2VMID, s2_cfg->vmid) |
+		FIELD_PREP(STRTAB_STE_2_S2VMID, tag->id) |
 		FIELD_PREP(STRTAB_STE_2_VTCR, vtcr_val) |
 		STRTAB_STE_2_S2AA64 |
 #ifdef __BIG_ENDIAN
@@ -3671,7 +3674,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev,
 	case ARM_SMMU_DOMAIN_S1: {
 		struct arm_smmu_cd target_cd;
 
-		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain,
+				    &state.new_domain_invst.tag);
 		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
 					&target_cd);
 		arm_smmu_make_cdtable_ste(&target, master, state.ats_enabled,
@@ -3681,6 +3685,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev,
 	}
 	case ARM_SMMU_DOMAIN_S2:
 		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain,
+					    &state.new_domain_invst.tag,
 					    state.ats_enabled);
 		arm_smmu_install_ste_for_dev(master, &target);
 		arm_smmu_clear_cd(master, IOMMU_NO_PASID);
@@ -3702,6 +3707,9 @@ static int arm_smmu_s1_set_dev_pasid(struct iommu_domain *domain,
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct arm_smmu_device *smmu = master->smmu;
+	struct arm_smmu_inv tag = {
+		.type = INV_TYPE_S1_ASID,
+	};
 	struct arm_smmu_cd target_cd;
 
 	if (smmu_domain->smmu != smmu)
@@ -3710,11 +3718,8 @@ static int arm_smmu_s1_set_dev_pasid(struct iommu_domain *domain,
 	if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
 		return -EINVAL;
 
-	/*
-	 * We can read cd.asid outside the lock because arm_smmu_set_pasid()
-	 * will fix it
-	 */
-	arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+	/* Use a dummy asid and fix it in arm_smmu_set_pasid() */
+	arm_smmu_make_s1_cd(&target_cd, master, smmu_domain, &tag);
 	return arm_smmu_set_pasid(master, to_smmu_domain(domain), id,
 				  &target_cd, old);
 }
@@ -3782,7 +3787,7 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 	 */
 	cd->data[0] &= ~cpu_to_le64(CTXDESC_CD_0_ASID);
 	cd->data[0] |= cpu_to_le64(
-		FIELD_PREP(CTXDESC_CD_0_ASID, smmu_domain->cd.asid));
+		FIELD_PREP(CTXDESC_CD_0_ASID, state.new_domain_invst.tag.id));
 
 	arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
 	arm_smmu_update_ste(master, sid_domain, state.ats_enabled);
-- 
2.43.0


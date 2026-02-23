Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013058.outbound.protection.outlook.com [40.93.196.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B9115CD74;
	Mon, 23 Feb 2026 20:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771878541; cv=fail; b=IxWysIIzvLQuiwJNzRHYORGp7Yzey0MWvERs8ctk6JpXplrwVErTjYo05dsjih7pBVVazJ3d2mgULzyIZSRWsQq2dFKBarGKEaCQSGFGptXvW793iXA+XlT29ehnNJc2HhAOwqeRNVShfBJtqhCVOa69IjAHynarwBNi2/pVXt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771878541; c=relaxed/simple;
	bh=/SUce+9LIBI2/DZOWq0SS/Os/Y4moBG6i84LQh08Lvs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T2zLmVgjrMjkOYsgEvTUipuRP3RHoZpaXh9W9M2qQRhu+1r1DcpecZCPGbJ7sgsgg/3YtvHqf1RDk81fYM3QREGizWFeov52efRjqPiD/CBUuCoF0uwvQe8sMI/0QHtcSrE/PDdDwEA1fZosyUY1zWKex0Vi1KbJO8Q0dqDmyt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PRsn2O+E; arc=fail smtp.client-ip=40.93.196.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PRsn2O+E"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B3A/0Ul9bGnNTpbXKckOUZcnc0+k7rHSUvc4T6qGBPzdLUk5KLDFqmeVUSx2mhJbDQLcJBRL8hAwIDOyqIj3toFfDNdrq23KVITgjq0oso8vDjQkBbviV2av4TKUdbYSFgvJRlozb4RfEQLSLe9lmEEfgdAlw3VjBuPRu5S6YeoO2wDCvcCGr6C2nXwPjys939czg9lCUMDU9Sf8YUHzIj9jaRmKU42OFpvrRvnwyhu1u5SnI2MdI8HLRLyvQVawLTUuDp6LGV64j7uNTY5XQsauUUAvNSyYUB+w/knTjD0b9yTM5x80AjLPLiYklHCF4n+KWvf+SMTDPG01hyJetA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N36zEzNtPw5kO/s/ff8pFYGRzKp2lTf8AldQ4YsuJno=;
 b=i03zoDr7Q3+ciICh7EBGzJX+7lzdPNWe2VqB+Y5CHt9NTLGjVUNLK2vbY1ph4fFquTp0R+a5RZf9iSLUqWNwDXxPaZPuZOzadZPbAZhIBSHZHGPsIXG6fikHFjIlq+75bHE/tweo3G/m9w9dVcMF/l9DRX75w6bMbhGsLzjYvPjsMEdt+nPBsYKzQnUgLgVxpJesVghYMBT35Ll4eeTinqWbaJAwq434j0HRa1W7Sr+vaHNonMaZYXT0+QXQy0jDcZMXn36ZdP4oHlPiM3xEeT9hxNq1Kl6ovNznm/7+W27wZ/RCdInXa2xUBCkz6K2d3WgNGdTKi8EWXFY6S1DMYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N36zEzNtPw5kO/s/ff8pFYGRzKp2lTf8AldQ4YsuJno=;
 b=PRsn2O+EYf71sUvHF6zaLEDrvVqnTRLsZ+RYLlBk8/T2vzconLwcGKuUFweqpMH6Ax5u8YZNJSM/uRpYGq9bCErx0kPW7xbO6+1n6AvLi6Q4cB6VG08HuVAs+evH0PH6q8mzh2d/7rZ30dEzx/QQy5KmQGdtYTzbh9sIMBRvr9X7iWaqa/NaorinGqoIx4Rn6AZyVkJu9aGNPlmrf+r8qP4HM0lX36zTITSlS6hoDbmgEgoIDhZhagKYIz3bBVCARjOSPIFcHWNTmKbCt5e6bFoN2J7MYIKApluSV+hFGAy60yVJROnUjJWnE0U6mFLqEX077rMAAGFwZxi5Zng0iw==
Received: from SJ0PR03CA0211.namprd03.prod.outlook.com (2603:10b6:a03:39f::6)
 by DS0PR12MB8017.namprd12.prod.outlook.com (2603:10b6:8:146::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 20:28:48 +0000
Received: from CO1PEPF00012E61.namprd05.prod.outlook.com
 (2603:10b6:a03:39f:cafe::5c) by SJ0PR03CA0211.outlook.office365.com
 (2603:10b6:a03:39f::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.21 via Frontend Transport; Mon,
 23 Feb 2026 20:28:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1PEPF00012E61.mail.protection.outlook.com (10.167.249.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 23 Feb 2026 20:28:47 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 12:28:27 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 23 Feb
 2026 12:28:27 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Mon, 23 Feb 2026 12:28:26 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <smostafa@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: [PATCH v3 07/10] iommu/arm-smmu-v3: Allocate IOTLB cache tag if no id to reuse
Date: Mon, 23 Feb 2026 12:27:43 -0800
Message-ID: <0ddd4c123c9283150ced4e2769ca5ae482854395.1771877893.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E61:EE_|DS0PR12MB8017:EE_
X-MS-Office365-Filtering-Correlation-Id: a925a28c-6d55-46ed-d54f-08de731a2610
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6NsvlalN1m7nG6BHGvs61y5rm5c2U2INPD26KfJLbgw7D8r6R8XUVNrVwOXY?=
 =?us-ascii?Q?aYAcq1IdsMCD0kK7NGA40d3l+ariFTyDTVJsKhllDJYriNvGAbhVjrfqHEts?=
 =?us-ascii?Q?0CzIpKfjXyBZJ26hSoqMuBN2mJXE2p/pCwFgpKwvf2H2SmkWHOWRZDIIf6+q?=
 =?us-ascii?Q?T0YNx6ckO/iVd7XxlMUJ+165U97/BvRiV4bP3ZdAWXGWE5xYD3GR7SW/RdQ8?=
 =?us-ascii?Q?ep4xb7pUw9y1oYmNkWDrHtZnscpsGqnf8S/1JK0sBVUxcrG9yXfRIVb7ctJ0?=
 =?us-ascii?Q?cvXrWl/uTFiy8Pet/Lk/BNABEGRP8KWCa1Dn0xdn+26O/NR+WeWFf0PwWlc4?=
 =?us-ascii?Q?qSfcK9wN9LMJ07Guxar9Leni8s3SOLKng3vFWzDWObiVFJaNXiFTBLsGEm1V?=
 =?us-ascii?Q?5o4rxH1wLd2W+TUf9o01Ekx8iVqwXa30GUYAo+38QwoqXCQutt49bnvqSFsI?=
 =?us-ascii?Q?4cCkTZs+UcyzcT/4xCQcxnN1DJNCOdqSI8Ln9cLGEL+lTeb99+g1xjAmiXa/?=
 =?us-ascii?Q?YJjfcDCiO8wiyFVKET6aHGOue58YVWvgTsYgBplfQxHKVCnfOlniQ7kiF5d8?=
 =?us-ascii?Q?7UghSmlYKNaa4E3VNgCZAdL2xP9fIBZsMPSoEEpqtl0d5btDuyhkRTe5eUo3?=
 =?us-ascii?Q?sNEk6FwAKcFLDbrliDLwy5bCX8GRnrvTMesE4dQQ2HHfsj3pthgpAzSugHXd?=
 =?us-ascii?Q?IaMNXQa2LDBGLN5gCisbABIuaPNpoDnUoUPHLZopA+qOJNMR1Xn9k9SecSAz?=
 =?us-ascii?Q?pTpMLiXzRyRSE2tgE9sE7oKmDdUfSm6+E0/SDEM0lakZ1wKbJ42DYyr2LQ+s?=
 =?us-ascii?Q?JuwSXucetQnpLZOCqvWkv8aQtqvBF1OFZxywqqiFbEH47sU4f3aqJakfUFMJ?=
 =?us-ascii?Q?tWdcMga8I7kgYJt4mqtBl+UD15pgGKwWvamR0ABbYidHuyeUHmBw1/+p7sVK?=
 =?us-ascii?Q?0xsNPfRvBbJeV499WfLt7UT+e3xVYOoO9GAOSGqTLTSucCZ+0itfdBy3JGKR?=
 =?us-ascii?Q?11d81hPdZki4K/D9n9gqOjFmrMfg1ibtHufWKx2cFW9B7r1qi+FpCeVj1Y5y?=
 =?us-ascii?Q?rSfpwEpxhQJ5jGNkGxQt8HvgcssUB+s1Q3rURHhZy7vHKJQwTd1NDFj0Ee49?=
 =?us-ascii?Q?C9x36jJbOXm0OJ+IxZH4Mgs1nUrawlHwsKOFINW8iR3EmpBpaG1Y5p/ts4NF?=
 =?us-ascii?Q?DMGfm9mH+xCS+2MjirW1Y5htJXyRTd7jSPSiL442Ub7NTzvYA/hu5yC7fdal?=
 =?us-ascii?Q?HXBJz6WQT3mMKobcb5XZRjqOirhv6T+4Vmf9EbJbbV7ubcHd3ryrPzJpImu+?=
 =?us-ascii?Q?hz/Wd+GHl4ap5i64cYSO7LdWcGf0c1I6fR097H/NYH31dsdwT5f/6uHEVNdS?=
 =?us-ascii?Q?w4jRaKEYVFtYWkrzctowRfagQjd3DKWEscgBKv9NGCv0MTRmm+G5ZmId1kyv?=
 =?us-ascii?Q?Yrw2suZn020rg4BeOQzyq7x/CMHnH1Q3CYDN98lz08fXE7w45mp0Lf2pBV/2?=
 =?us-ascii?Q?RXadBxF/UKFCfjBR0AYNeLC8SvSpD1QYuSbN8DiROeBl6bxyvNwPXx2nNdcZ?=
 =?us-ascii?Q?waHE6oFWJjjsMl9C3PMM8QS1eXvrcNDz6LUv7uHIICSZaWYpW49kt3ygif9Y?=
 =?us-ascii?Q?cSqWvDf42I1BcpEV8Edvv6kjnyCVf4uvVSqYrjte362o/B9YhDvdsqQJ6QIO?=
 =?us-ascii?Q?Uv4HeQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cDRqlrqqqBFXMHRbYFb+4irN7DR6X7Ffl0Sg+sR2v5KA00+HSFYWozxamNe70Jtbfvd3zyzQz4BGYDzSNhgJZqTWTFAQvknFGnglMf43d155LYKQHmtGtBb8B1yAoLlkM9A1phg8jkeACqRM9hIGeI1GUodrWNL5uGVEEh7Jw7nhGCyelsvaBUHb48K5N/XmoOT2VI/kSqqsOj0oCZGBgMILZXxggFtsDecb1CiPIDPj+JGeLB2mjW7/akGT65yD4MW1Ycz5TAOiv85pA7gHIkFK2mIr8GPoSew73jbYXtnLglAemfSh4Vnq2A1tnPrIzjVTc43UAKs5okVCPRQYiI39UyXrI/RJcCD0wYbkZqvBFf0SBwv13GydiCuo0G2Y4jxvuAEaj8U1wCxxGNGuidRXecfdYVUa6fm2OJ8+uGX3zblds9GOkRyqCxLwxrof
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 20:28:47.7205
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a925a28c-6d55-46ed-d54f-08de731a2610
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E61.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8017

An IOTLB tag now is forwarded from arm_smmu_domain_get_iotlb_tag() to its
final destination (a CD or STE entry).

Thus, arm_smmu_domain_get_iotlb_tag() can safely delink its references to
the cd->asid and s2_cfg->vmid in the smmu_domain. Instead, allocate a new
IOTLB cache tag from the xarray/ida.

The old ASID and VMID in the smmu_domain will be deprecated, once VMID is
decoupled in the vSMMU use case too.

Since invst->new_invs->inv[0] and invst->tag are basically the same thing,
merge arm_smmu_inv_flush_iotlb_tag() into arm_smmu_iotlb_tag_free().

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 63 +++++++++++++--------
 1 file changed, 38 insertions(+), 25 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0755ebe1c1560..9ab904d9d142c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3276,13 +3276,44 @@ static int arm_smmu_alloc_iotlb_tag(struct iommu_domain *domain,
 		return 0;
 	}
 
-	/* FIXME replace with an actual allocation from the bitmap */
+	lockdep_assert_held(&arm_smmu_asid_lock);
+
+	if (tag->type == INV_TYPE_S1_ASID) {
+		ret = xa_alloc(&arm_smmu_asid_xa, &tag->id, smmu_domain,
+			       XA_LIMIT(1, (1 << smmu->asid_bits) - 1),
+			       GFP_KERNEL);
+	} else {
+		ret = ida_alloc_range(&smmu->vmid_map, 1,
+				      (1 << smmu->vmid_bits) - 1, GFP_KERNEL);
+		if (ret > 0) {
+			tag->id = ret; /* int is good for 16-bit VMID */
+			ret = 0;
+		}
+	}
+
+	return ret;
+}
+
+static void arm_smmu_iotlb_tag_free(struct arm_smmu_inv *tag)
+{
+	struct arm_smmu_cmdq_ent cmd = {
+		.opcode = tag->nsize_opcode,
+	};
+
+	arm_smmu_inv_assert_iotlb_tag(tag);
+
 	if (tag->type == INV_TYPE_S1_ASID)
-		tag->id = smmu_domain->cd.asid;
+		cmd.tlbi.asid = tag->id;
 	else
-		tag->id = smmu_domain->s2_cfg.vmid;
+		cmd.tlbi.vmid = tag->id;
+	arm_smmu_cmdq_issue_cmd_with_sync(tag->smmu, &cmd);
 
-	return 0;
+	if (tag->type == INV_TYPE_S1_ASID)
+		xa_erase(&arm_smmu_asid_xa, tag->id);
+	else if (tag->type == INV_TYPE_S2_VMID)
+		ida_free(&tag->smmu->vmid_map, tag->id);
+
+	/* Keep INV_TYPE_S2_VMID_VSMMU. vSMMU will free it */
 }
 
 static struct arm_smmu_inv *
@@ -3510,26 +3541,6 @@ arm_smmu_install_new_domain_invs(struct arm_smmu_attach_state *state)
 	kfree_rcu(invst->old_invs, rcu);
 }
 
-static void arm_smmu_inv_flush_iotlb_tag(struct arm_smmu_inv *inv)
-{
-	struct arm_smmu_cmdq_ent cmd = {};
-
-	switch (inv->type) {
-	case INV_TYPE_S1_ASID:
-		cmd.tlbi.asid = inv->id;
-		break;
-	case INV_TYPE_S2_VMID:
-		/* S2_VMID using nsize_opcode covers S2_VMID_S1_CLEAR */
-		cmd.tlbi.vmid = inv->id;
-		break;
-	default:
-		return;
-	}
-
-	cmd.opcode = inv->nsize_opcode;
-	arm_smmu_cmdq_issue_cmd_with_sync(inv->smmu, &cmd);
-}
-
 /* Should be installed after arm_smmu_install_ste_for_dev() */
 static void
 arm_smmu_install_old_domain_invs(struct arm_smmu_attach_state *state)
@@ -3551,7 +3562,7 @@ arm_smmu_install_old_domain_invs(struct arm_smmu_attach_state *state)
 	 * array must be left cleared in the IOTLB.
 	 */
 	if (!READ_ONCE(invst->new_invs->inv[0].users))
-		arm_smmu_inv_flush_iotlb_tag(&invst->new_invs->inv[0]);
+		arm_smmu_iotlb_tag_free(&invst->tag);
 
 	new_invs = arm_smmu_invs_purge(old_invs);
 	if (!new_invs)
@@ -3697,6 +3708,8 @@ int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
 err_free_vmaster:
 	kfree(state->vmaster);
 err_unprepare_invs:
+	if (!READ_ONCE(state->new_domain_invst.tag.users))
+		arm_smmu_iotlb_tag_free(&state->new_domain_invst.tag);
 	kfree(state->new_domain_invst.new_invs);
 	return ret;
 }
-- 
2.43.0


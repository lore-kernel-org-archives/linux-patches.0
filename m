Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012022.outbound.protection.outlook.com [52.101.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FA0126BF1;
	Thu, 22 Jan 2026 01:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769045111; cv=fail; b=ukQduQ0vWOni4Kc+4ytY8oU/+NP50MOrMLs+LABz25efZVTrsiVodEGNs6kEsO9yhzEKVEE0INX5ujvpS7wSo2//8LDxkRH/3cqRWvVoh/rAT4tjfR/dbJky/uN99LqU1yUUWQ+lJ3nwUNOlFdV83V4HFQ5ZLAcUcBRG1ZTVWY0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769045111; c=relaxed/simple;
	bh=yJpwPxh1w4HT3VbrlawxnAqt8BH6RbGe7OxJVByA75Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iu1RNqlb+/jPR5HettAL/b+LM7XuKyyUtbaZvD+tS4VM629UDL16j7zKh4/GjfWaE7soo+wCdps8bThrqDC+vADMN435Fq+SB891G33GXrqh1gXGbg1GLZRFH2F08zb5JPi+IQVWMKRTVoYZU5+DFhUEbmeL8AzhRcoMkkMnMLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hs2haP1y; arc=fail smtp.client-ip=52.101.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hs2haP1y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X//6IVyjsfXYOD3ZYWJsXvxHRLOTZo3C3KMtrhXUswSk8AzFlXBd9JguQ6+OCb+r7kc/QC8b7kvXo26N2MvEf+f/jRuBlTquhd7XBLoE5zgbgCMoHV4sOCAkVta64m3wxIbdWDoMuxPIZBWiTgerJIkcpxbtlrRgwHpYd4RNfjQdHuEXcQxcT3Er00GUlwxNTFB7dwZQsGYVDBYWsJbEEKlMjm0gPLwMXNKoSngJXDcg2KOfg59EOHRFN1ZXkUZWzYc4uQgUAly+UtkA2nnoirMOnDeJPFRIgBtAqkNzpDeq2Clt4WrN88gXg/8mDxA1U0epb6daz+ZzHiA3OV4rWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ysVfic5yACb1wJ/d5LWsOhwqtaqyIPNGCCHAaHvW/yc=;
 b=HpxEUFK8bLld/qTiYrE4yuDJokXbGRZVRi8P3B/hMt+Ks60HTAvwIz5LHzOaXugU8kmm1VBwqxIjduUujTKDW3AiE1egSjiDM2ShtJ/VxN6LOZw8em/7P6oQyHQqqmuUixeCe60g2flx24ipzJYYoypn+7OxcFM7xDGDDk79pCEd/4vNF6U7YoKQ7zb6yBmvrCQ6kkd8A/JAd7W3poCQYwXF9650KcpCY/uBHSulxAyDRGo5UNLklYqjKxO/HMfBeL+uJ6+gC5a72Fqo4YoEBPSgfLWh7uLsONn1lyKsEXIrzfXNi+QLN0eG3uhthgJqIb4W8Arpu8nfhxICgnMQpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ysVfic5yACb1wJ/d5LWsOhwqtaqyIPNGCCHAaHvW/yc=;
 b=hs2haP1y/NZ3p5NSpCGsV6bkSRmRd2NtEKQdYp/2s/nc5Knf96TidmYKzmXvpmwDRCWMHWivMvyQ9Dd7JHPnY35u5dMYZfBdRvVXAz7Q5gkAbIYX0PVwrjIImeMb7iWXE2UYuwVaZBVqe7nQhyQoFrg/6RygmUBHpS2E11HupMLMCsLLC1A6FrEBmKkfX3DlXWD8yYdtJJ7TnEt/V22PCN5bKNGSYF4pQy97/ODw2baDdnXx169wAlyRiiqwW/YS8MugMa7xFSIy+d/jafzb3Zs/M1eC/fDcUaYjHzm78BYLxqZ6BESGelTemSKgu2Ru0NZZKrixpN1CyWqV9QZwGg==
Received: from CH2PR19CA0012.namprd19.prod.outlook.com (2603:10b6:610:4d::22)
 by DS0PR12MB8814.namprd12.prod.outlook.com (2603:10b6:8:14e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Thu, 22 Jan
 2026 01:24:54 +0000
Received: from CH2PEPF00000143.namprd02.prod.outlook.com
 (2603:10b6:610:4d:cafe::a3) by CH2PR19CA0012.outlook.office365.com
 (2603:10b6:610:4d::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.10 via Frontend Transport; Thu,
 22 Jan 2026 01:24:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CH2PEPF00000143.mail.protection.outlook.com (10.167.244.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Thu, 22 Jan 2026 01:24:54 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 21 Jan
 2026 17:24:41 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 21 Jan 2026 17:24:41 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Wed, 21 Jan 2026 17:24:40 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <will@kernel.org>, <robin.murphy@arm.com>, <jgg@nvidia.com>
CC: <joro@8bytes.org>, <jpb@kernel.org>, <praan@google.com>,
	<miko.lenczewski@arm.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: [PATCH v2 05/10] iommu/arm-smmu-v3: Flush iotlb in arm_smmu_iotlb_tag_free()
Date: Wed, 21 Jan 2026 17:24:23 -0800
Message-ID: <4ee324e4f189fed601f4d947af10393b14dfb7d8.1769044718.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000143:EE_|DS0PR12MB8814:EE_
X-MS-Office365-Filtering-Correlation-Id: ef8e67fc-85ab-4eda-a1db-08de59550c2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CDgDB98T072ZXtFKVvh83+DjBcndcTKWVaXs/REYga1dv1mJrS3Ua5cql4l9?=
 =?us-ascii?Q?jrV/mMHcsr3vCKViB8M22eSlkuwCNK4u1rBmI6VaOlfWhA5OFqQGGBNxZI1D?=
 =?us-ascii?Q?IFQeS3nIWVTPcc9QYO+JTg1vGCdBDv3dQIu/rxktH9eTO8jvZaQV62W1OCKQ?=
 =?us-ascii?Q?ctUNrQmk7QZwaq5iMPTvcYpazRKUZ3+BOI9CVudJTu5np5Hc/cCiS1Fv0g8h?=
 =?us-ascii?Q?8LUfczjtgIg0AsrnJCXHSAts04I1K1uuVb8fUEw4cwv4qeZ4CiWYPo8i9c2S?=
 =?us-ascii?Q?gFfqyQMuBx2C2Q/o6ghVxhZpt60j6edqTIKptG3mtUbjrO0Xf4xcog/057fI?=
 =?us-ascii?Q?e5fi6HC/kIiLg0O+Ni5boMyk7KAZ13qOAMp41TVLoM0wK5FaX2VxAIAZNe9K?=
 =?us-ascii?Q?ypTW4gNKTjSqsymRpZXNsDtx0Re7SuAbyMRR9Kfs+gq+2YpKNj6Nwyw/+ZJ4?=
 =?us-ascii?Q?kkKXYoWneNpT2EMfZPHdzdzk5DV097mqPtrZmlRL9BHjeu5aG88zbnX+AHpn?=
 =?us-ascii?Q?jkxmFm8prjKbehsGyipaHRbnxejDJ2A/2a9cT/ECxlOfYGF87F957Ucy/vyS?=
 =?us-ascii?Q?QP983k42MQkwMEviVEQuAGVtiyT5SMUTmLqcmId00xwrGRhDjwulxhvCmyTq?=
 =?us-ascii?Q?OTAUK3+f7AQftkw3Zmon88M8jIGP+6T0qQ2kWV/g1Rsju0FdW9DGZKCsWHVX?=
 =?us-ascii?Q?5z19hfDtE2ZPZHVGgVlLqzOifNMUCAwjKBmL+mkTFQnE1biC38l9pCkW5mc8?=
 =?us-ascii?Q?HIXTi6cmIxcBcaLdBbUQY6NEOC0mgesqEy42l6iEc6ZRM3baY5ezLcPDcYaf?=
 =?us-ascii?Q?1rzlWh9mAPJ7U+P51TttZjkpZ3rB9kV41DFc7+9y/uc9i0YI9N6pYzR4dG4Z?=
 =?us-ascii?Q?FPCIdu6y+WoykNnnCcRfgvLj3l4NK5d32DWesBMh894BeDqc3j0COTMTP+wo?=
 =?us-ascii?Q?hciLqFp0UIuNNccCENh9L4ZHFr+/GUMNqzVk9eMlK66IoTo7OMBiy9RQGFP6?=
 =?us-ascii?Q?p9Mwn58W8nFb6PzRXQxs8znkNVGqZwbXhe4U6VyfO8vkQi4WbTc4n884rngW?=
 =?us-ascii?Q?K9Vlm018Bb5c1nwmX6zPedvwzoc7ciKYTkzhykjK9nu+5OQ2IEgcEfVX31cl?=
 =?us-ascii?Q?62AumLaI5oUTYuMZ1of4VSdHshImTasyyoqPJWWTZIeqKDAW2Fo90tSR90Y3?=
 =?us-ascii?Q?lb9ARQsjxc3iqjLHvwDQSso1nvmVCTgshR26Uzq5wZA0RaEdM8QbiSTIPkQc?=
 =?us-ascii?Q?APvDcZThlbjHkgva19/CmQa8CcoYBpqth7+GgNPlcbX/ZpTwG8R3fc+zYj87?=
 =?us-ascii?Q?RMMVtwp+I0pkLWXFPzChJmVHGD5cCw1Vf7QEoCWIJ/VW8ADWxi/kMGlDZJqE?=
 =?us-ascii?Q?e8Wroldcvx55mjDNqj01UgITGJ87Ga7QQtFHKj5rQ1Wb2/j6jMi3xfdnD6bk?=
 =?us-ascii?Q?PWvJeSLx2j1X9P6OOxGtNa5t1UaMAl0Cir8lmmYn9CRWPCAyWUhPkxh0Pew2?=
 =?us-ascii?Q?raSpp4LbU7jwXSxsItoO15AbDrrAB6FDcSH5KW7niIrYRFwFTVULLlb+NRII?=
 =?us-ascii?Q?8aLnwR9041eCPLI0O/g4erOlCXOpGT9Eri2h2mukQjbIPA3h93HRGuvQwZq9?=
 =?us-ascii?Q?W31KYYoyBHvHkMc7HWhawvcce1eRKgcmstH9EcK+H1XWX0T/h137XLumqB6Q?=
 =?us-ascii?Q?oYegeA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 01:24:54.3026
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef8e67fc-85ab-4eda-a1db-08de59550c2b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000143.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8814

If the IOTLB cache tag is no longer used by any device, flush the entries
tagged with the ASID/VMID, before the tag gets free-ed.

Drop the free_fn callback accordingly since it's the same thing.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  3 +-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  6 +--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 46 +++++--------------
 3 files changed, 16 insertions(+), 39 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 812314aaaa6a..696ebb89ffa3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1024,8 +1024,7 @@ void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 struct arm_smmu_invs *arm_smmu_invs_merge(struct arm_smmu_invs *invs,
 					  struct arm_smmu_invs *to_merge);
 void arm_smmu_invs_unref(struct arm_smmu_invs *invs,
-			 struct arm_smmu_invs *to_unref,
-			 void (*free_fn)(struct arm_smmu_inv *inv));
+			 struct arm_smmu_invs *to_unref);
 struct arm_smmu_invs *arm_smmu_invs_purge(struct arm_smmu_invs *invs);
 #endif
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index 81551fad727b..d66931b56b46 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -635,7 +635,7 @@ static void arm_smmu_v3_invs_test(struct kunit *test)
 				     results2[0], results2[1]);
 
 	/* Test3: unref invs2 (same array) */
-	arm_smmu_invs_unref(test_a, &invs2, NULL);
+	arm_smmu_invs_unref(test_a, &invs2);
 	arm_smmu_v3_invs_test_verify(test, test_a, ARRAY_SIZE(results3[0]),
 				     results3[0], results3[1]);
 	KUNIT_EXPECT_EQ(test, test_a->num_trashes, 0);
@@ -647,7 +647,7 @@ static void arm_smmu_v3_invs_test(struct kunit *test)
 				     results4[0], results4[1]);
 
 	/* Test5: unref invs1 (same array) */
-	arm_smmu_invs_unref(test_b, &invs1, NULL);
+	arm_smmu_invs_unref(test_b, &invs1);
 	arm_smmu_v3_invs_test_verify(test, test_b, ARRAY_SIZE(results5[0]),
 				     results5[0], results5[1]);
 	KUNIT_EXPECT_EQ(test, test_b->num_trashes, 2);
@@ -659,7 +659,7 @@ static void arm_smmu_v3_invs_test(struct kunit *test)
 				     results6[0], results6[1]);
 
 	/* Test7: unref invs3 (same array) */
-	arm_smmu_invs_unref(test_a, &invs3, NULL);
+	arm_smmu_invs_unref(test_a, &invs3);
 	KUNIT_EXPECT_EQ(test, test_a->num_invs, 0);
 	KUNIT_EXPECT_EQ(test, test_a->num_trashes, 0);
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index d10593823353..5a7032081553 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1168,8 +1168,6 @@ EXPORT_SYMBOL_IF_KUNIT(arm_smmu_invs_merge);
  *                         the user counts without deletions
  * @invs: the base invalidation array
  * @to_unref: an array of invlidations to decrease their user counts
- * @free_fn: A callback function to invoke, when an entry's user count reduces
- *           to 0
  *
  * Return: the number of trash entries in the array, for arm_smmu_invs_purge()
  *
@@ -1188,8 +1186,7 @@ EXPORT_SYMBOL_IF_KUNIT(arm_smmu_invs_merge);
  */
 VISIBLE_IF_KUNIT
 void arm_smmu_invs_unref(struct arm_smmu_invs *invs,
-			 struct arm_smmu_invs *to_unref,
-			 void (*free_fn)(struct arm_smmu_inv *inv))
+			 struct arm_smmu_invs *to_unref)
 {
 	unsigned long flags;
 	size_t num_invs = 0;
@@ -1207,9 +1204,6 @@ void arm_smmu_invs_unref(struct arm_smmu_invs *invs,
 				continue;
 			}
 
-			/* KUNIT test doesn't pass in a free_fn */
-			if (free_fn)
-				free_fn(&invs->inv[i]);
 			/* Notify the caller to free the iotlb tag */
 			refcount_set(&to_unref->inv[j].users, 0);
 			invs->num_trashes++;
@@ -3188,6 +3182,16 @@ int arm_smmu_domain_get_iotlb_tag(struct arm_smmu_domain *smmu_domain,
 
 static void arm_smmu_iotlb_tag_free(struct arm_smmu_inv *tag)
 {
+	struct arm_smmu_cmdq_ent cmd = {
+		.opcode = tag->nsize_opcode,
+	};
+
+	if (tag->type == INV_TYPE_S1_ASID)
+		cmd.tlbi.asid = tag->id;
+	else
+		cmd.tlbi.vmid = tag->id;
+	arm_smmu_cmdq_issue_cmd_with_sync(tag->smmu, &cmd);
+
 	if (tag->type == INV_TYPE_S1_ASID)
 		xa_erase(&arm_smmu_asid_xa, tag->id);
 	else if (tag->type == INV_TYPE_S2_VMID)
@@ -3437,31 +3441,6 @@ arm_smmu_install_new_domain_invs(struct arm_smmu_attach_state *state)
 	kfree_rcu(invst->old_invs, rcu);
 }
 
-/*
- * When an array entry's users count reaches zero, it means the ASID/VMID is no
- * longer being invalidated by map/unmap and must be cleaned. The rule is that
- * all ASIDs/VMIDs not in an invalidation array are left cleared in the IOTLB.
- */
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
@@ -3475,8 +3454,7 @@ arm_smmu_install_old_domain_invs(struct arm_smmu_attach_state *state)
 	if (!invst->invs_ptr)
 		return;
 
-	arm_smmu_invs_unref(old_invs, invst->new_invs,
-			    arm_smmu_inv_flush_iotlb_tag);
+	arm_smmu_invs_unref(old_invs, invst->new_invs);
 	if (!refcount_read(&invst->new_invs->inv[0].users))
 		arm_smmu_iotlb_tag_free(&invst->tag);
 
-- 
2.43.0


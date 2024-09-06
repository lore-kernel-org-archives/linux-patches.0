Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623E71D31A6;
	Fri,  6 Sep 2024 15:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725637700; cv=fail; b=CObYXppN/TipBOoXNetQ9o0rxnipTiaewWjtv7AvjwMvQgG+2wmAdjnhbX+9ewTCmdQ680gMtR+ur1papq3Ge98i5C5/nC6GTTfLtsgHG0RMLslfaluWNTWPLzp0dHheMKJ3P7afzyt0pqfSPLWhb4raryqn0xGghrnVKB/q4IM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725637700; c=relaxed/simple;
	bh=WqUSsegXBZMGDYCEGiNUemeYyBly796rFLPLq6pAQkg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=oWKbhRM8E+NPxJXlzOoHQlwmF//y52z+jQaPJR2tISJcFh+xIqJ2l6ghwVLvgEv9PEs7JiBCFLqAvQOysMbPstztPoixnkTHSmgTQaqOZQbJhLcHVZJd9hWAIXoXnlmY1ASK/ns2THwpkfKmNzTvyQAHjE5mh4awQiTooj/li7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HJ+SIJXa; arc=fail smtp.client-ip=40.107.244.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HJ+SIJXa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rkOFBl7fOlrdnTLO2OnhGkNHsfNgo+XGsKJ0MoPOD+3wFhAk1BWqN8fdjNrE5E8LTjZModpMYBigZeg1jK8D1ekDJ9/pxnFTV6tw9YQl24KjqjUuhRUVvfvf20q+RlIyAZTvxamLH4omjW7XoOaISjSsTR6y2SXCMZYLGY0R04Vt41b7KDhy/v6KQxYajLT1/bciJAAi4sLJLOD6UdsKra7m5wq2BzVev7cdnDWHNtQ6sWLzxwinOq30DAMAhC+9vTPPDccrP3f0u0UNqtFtisBWQptNYBmru9+jy05/9bE3xkJQ4EapQTGrDgY5DZzwGX2jvhE5uJck7mszGl7eMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+o0syT4FWYeUNvQkgcDuxgR4enZMo0iCAFAbXxh/w4o=;
 b=kvJKgsyjpPOimmpbZypZOsTNNTchC4UCZeMMFmwJPr/BRBtG3ImpMQwk1W/i9NA9JdvlTHQKTkCwSnRQY8x0WgKlZP8xuqKbxGexFy8a+Kr2Gi/rRzjiJfVFMQZs5JLmqBVNfsgQ5VxaQQTbg6e7qFGe5i/TU+9Pq8ROBJXIfGkrn29bm35EwYYhQBk5GOe4bmBO1Xvk5hHq8OHUqXaosXvdBDJ1QRDjWE1Jbqceoci3wUFjseTwF9Uvu0OjZEGQVWgn8dlBugD4/1HhNV4EAFBC7sGiYN1XZiwAksVk+0UZJqkV0PGszVM9B+zkXe9tc8WTp1U+apdQXyTCYmwChw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+o0syT4FWYeUNvQkgcDuxgR4enZMo0iCAFAbXxh/w4o=;
 b=HJ+SIJXaTPby7r4n480qG5Vmaues3PK4tQtWi7z4DRKnEMJfwrlsIsoEv2ZQMoG+eYY8/tpbRf4ZFzywmnYxFdxew/Ev21mSKYKy2kIPx3Pu8IvcimuWnYu0GDhfrsqSzdeF2GxupG2Tc6EgS94xGH+zmNF2UEE1dtQDbHpCO362j9LymrfV7DO4tOhvEfczlSu9rY4/kHE2/ziRmDfGRj0rg+rglGxx4XdEyvV1PhaiP+Tg3VQ8n3t/6vUTvnp8A5UtlIi346R71R6DDVwZRJMf5E6jm2STPGpkE7whETMpmRXjPx5Pk/TptMSadmHrowWUnSPsV6K0QNNos8aqxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6792.namprd12.prod.outlook.com (2603:10b6:806:267::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Fri, 6 Sep
 2024 15:48:07 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 15:48:06 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v4 0/8] Tidy some minor things in the stream table/cd table area
Date: Fri,  6 Sep 2024 12:47:47 -0300
Message-ID: <0-v4-6416877274e1+1af-smmuv3_tidy_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:208:52c::15) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6792:EE_
X-MS-Office365-Filtering-Correlation-Id: f06a5154-67d2-4506-dfa2-08dcce8b47b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FWVn9LBcNEEmuk1Y2UKACAffcBAeG17YXJOL4JLajQ65xzLoNMippl9VYibb?=
 =?us-ascii?Q?FmAS3iuWL6ajV+fIDXqHu9MkALkQ8nZt0jXVj4l4s/nDC5rdR4JeBX5pfB5o?=
 =?us-ascii?Q?1uSU8m14Zl/g/WnzJqN0yjHZ2LNWEjAst/xVQ9HVtOhN4yZ08Or3dYsjonJA?=
 =?us-ascii?Q?seJhcXbavR5253su9J06XzQWf0GmmeBdUj1Al8udx4dn+39gNIxjJeyy9XzZ?=
 =?us-ascii?Q?Rn13wKlQc/54orNYJp5tpLYdji3EH7cc3qW/5ilXsGyva2Gc3RYMMrE55nYJ?=
 =?us-ascii?Q?Y0/4T7HlsA6M2+pQR073azV0B34gHjLsUCrRsOiRDDI9k1fuw7zFSLxoYIvB?=
 =?us-ascii?Q?hTC0yrrZEG2P84E/lhowTqNRj0AHEJ+pTiBtilOW3HtnOdPoipzv2dsdKvVq?=
 =?us-ascii?Q?n1edNWw08aMPsrR1cEF6UtHUeKRdL+uHNf2tF79HEjBmyaUWYYOvAsuVEQvR?=
 =?us-ascii?Q?QfD4EoLKjZYs907VlnEMTBCf3XP9jsItCxsJlat3Xz6ZLLqSvsbYKl0mCdnp?=
 =?us-ascii?Q?ujlJ4FjKlGp5r77LX9IAhzVT6InIuqYExP2L0FI6an2TscNZRFtSbVXbhSF3?=
 =?us-ascii?Q?IDgUtsDnN5bBY583eub3Y3d0fMbCs/DssRRH3nV6V3y46lhuvmjyifCk/2z5?=
 =?us-ascii?Q?HHpQm3LHYG4N5OvQeBGCurYXxTanPw1/zb/yWXtAJ7NLrIUb288fql53DE2l?=
 =?us-ascii?Q?KBObMR8/A1J+EaqOgp18RBaWSiRiytHIniAv1iWLz2oTjW7i3aLur2XedJsy?=
 =?us-ascii?Q?cfYA/gqpQ/w6yglqa9VKlRa/CsD2TzLlht5ZecCC2tkk372oKizRnMeoytGW?=
 =?us-ascii?Q?+DPtZL9vkDyL1Xt3h9vkw2xxkRYC3XNdMd+hFJte3Hs/8RFdEm/KnSkRuhKm?=
 =?us-ascii?Q?kvuKto3CSBBeehfHqaH1GikLt8wFXft1gCJbnlLjZwuTwtL9d6MnpMaLh7AG?=
 =?us-ascii?Q?7e911x6nvhtmV5UVRQfv3r8GAKIGuuVwq4w8L94AMgunFZteL9Oyf5Fph32Y?=
 =?us-ascii?Q?oRROf2zk7ev+Pebe5ZsRMo8Qrk26nS0fa6V9b3l/kJ9u5eeSii4ouw+vDgR6?=
 =?us-ascii?Q?CdA78h9grZIn3LUA8HwdnvJKJJzwC+qRBlK5OsnTEJdMOBkJ8RQfZF9j9TdV?=
 =?us-ascii?Q?+7QFENDAxnEHi8sLqGrsmSBJfRnXapeYb4G5vyzO7l2tUz2lMH4O5RkR4Xew?=
 =?us-ascii?Q?QdVp/RUqCk2Vw5GxrxgNn4vcXW7m5tSekqGBDJSBzR/Zw67QxG7Z58LP6Wqk?=
 =?us-ascii?Q?/9ExSdXtPve1WLrtdGzq8UR5uIki+6jtY1dsZUnO+WXRW8/LGRSOei/tUEtr?=
 =?us-ascii?Q?RmYMPRk63qp1F7B+CNq+PgUfS2v/RE0fbYY6ttfOGqEQUg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L4xkrrNBe4uCHx3SdhsPh7Bl1VpMX7mS0Eqj1DtMlYF/DuH1dWavWzPF73yc?=
 =?us-ascii?Q?CDOmBZdcfcrwIrl+iksaNWjTkN5sRPlnKdHoYyKMRYxYmZsJkTQYm2rIoGkt?=
 =?us-ascii?Q?I9EUcXxFYdcqXafDabQoI7YXoIqqfkpoREN2Y2ij0h+b5dm1UC5envq0CjcG?=
 =?us-ascii?Q?sMGzNsD5Gl0rIMzr3gLDnlGwnA7sWvJzLnwrLnyVjoPHIZB7M4phlvq5OPIz?=
 =?us-ascii?Q?fafzje2oiVmPDIemqq1A9sTYTtBGlKF1NZr98XIA1UalL51lXOFsMAY1IthG?=
 =?us-ascii?Q?flALe1pYXY8IVTFaPPr8qU/9bhFSEpKOm2+BecK6uYCKxqvC9bRGFXe8ixEh?=
 =?us-ascii?Q?rG8Cc5k/M1SIVGNw4Z1TtmfY43E8X2vEQFBEoLpz77upOUF2YFE567q826Tn?=
 =?us-ascii?Q?icnaGzBaRue3JAbLppKVxbe39md951DGc1+nTJ7ABbx3icta8aPV1DJp/DML?=
 =?us-ascii?Q?909q8rEG0sfdeiSKJBE1wLd+vteZWmDVuuDWfR1ve8Y2Q0Zb7UZEUoY5W0rq?=
 =?us-ascii?Q?ll7wje7HrJUwEpow7y2VdXdluNIgJJVs6EVlD50H2WMvNBjCfIITF14pFtDt?=
 =?us-ascii?Q?NF1UHvOkZ84+zZ/SES+YXnNR+d4q7Sxv7zsPJ+ER+Ii/WYA41F4lyig40L+X?=
 =?us-ascii?Q?jfNGs/q0wwT7fUn85ur4h3IjXeTiGxE0H0dyivc60f5NgjlufGEL6G7q+PIe?=
 =?us-ascii?Q?yPZKKtno0UI+JF54u9rQ8v37H72gQTy4FwBYneourmNCGnXg/AE7oNB5Cxyw?=
 =?us-ascii?Q?3afUgdMA40nn2xs5HTjVHSkHHjOoitBVAGCPB6zUVBAKivY6uhZssUU8fgq+?=
 =?us-ascii?Q?2xMYjJbVYzK+SuM6Qu9foW18AUzU9cJ2Pb4JjXo/KIEAd/WPJ/rgdmS6dlQp?=
 =?us-ascii?Q?txvqnxjc4mifmk1i+4E5or4w5aH1eEfAqEFucbBfK4h8aClkK1pm/QGws9Ut?=
 =?us-ascii?Q?lXmAYL0c51/5Z0TjlqamSV6OS2+DQUDVu0AvYH1OZzqO/1Z+vtYHaRj3ARuW?=
 =?us-ascii?Q?i5TJTYOnu3a9+snZQXbBfFb+D0jnTZNEdeRYNibijxnh0UlxOwMkTKjmuKX7?=
 =?us-ascii?Q?8t3FxwbO3Slii5DPh9/kS8y3J9ZjGmlVvKVK57Fv29tLVpGwCbx5d3454wDY?=
 =?us-ascii?Q?YzTAZyvYDU6QZXHF4Agf7ptjcNOwqmvGLYH9qJNrjBTAG5elq5yGO3c3w6EX?=
 =?us-ascii?Q?PAoGtqW5iY5HXPZNRJhGdejyT+C6PQeOYK/MUifP1cMNP+cagCP+sOZxAuVy?=
 =?us-ascii?Q?BNb14uQzqP2/YOAngVB3qvUcaA8+FAoALf0mp9+jcqBigxALvaQMycsqB7jD?=
 =?us-ascii?Q?d01ARLn2yoJRZfGKSDoWq2F2ZXxjvR5EqFLIeeL0FJyTgEl+M9JdtAbK81bQ?=
 =?us-ascii?Q?+nzA9Ep4st6MGWwEZACl3Im6J9m/fCeSfRj54eY918kw9a3AnBApLjCyla99?=
 =?us-ascii?Q?Bzs/zoYGzDAnIDX9e20QowedjS5G2QpdRgp1R+705JPuxGPQ66s3QptCiw0R?=
 =?us-ascii?Q?95mAUpZfhW7aO0wXdIXych1cxFbQ4Xx18qcDB98vme1G1jT+7h6B16XBA83l?=
 =?us-ascii?Q?0iPtIG8+nU4bLUCuIv5Oxiu3q3UmkjNgMSoGTXFj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f06a5154-67d2-4506-dfa2-08dcce8b47b4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 15:47:58.0232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3pPadzt/RDq5uztX+aYqIR3asioR15k9UVM6MS4LXrzvycZY4ckp3V7p9F6ygK7F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6792

Will pointed out that two places referring to the CD/STE struct did not
get the new types. While auditing this code a few more oddities were
noticed. Based on a feedback from Mostafa and Nicolin a few more things
were fixed up too

- Use types for all the HW structures everywhere even for the L1
  descriptors that are just a single 8 bytes. This helps with clarity of
  what everthing is pointing at
- Use indexing helpers for the STE/CD two level calculations
- Use sizeof(struct X) instead of open coded math on constants. The sizeof
  naturally follows the type of the related variable in almost all cases
- Remove redundant dma_addr_t's and save some memory
- Remove redundant devm usage
- Use the modern rbtree API

Parts of this have been sitting in my tree for a while now, it grew a bit
since v1, but nothing is particularly profound here. Enough is merged now
that they can be cleanly based and are seperate from my other series.

v4:
 - Rebase to  v6.11-rc3 & Will's tree
 - Adjust whitespace
 - Keep goto error unwind
v3: https://patch.msgid.link/r/0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com
 - Rebase to v6.11-rc2
 - Preserve the "2-level strtab only covers %u/%u bits of SID" without
   change
 - Vertically align some of the constants
 - Use u32 for the type of the index and sid
 - Fix missing * in le64_to_cpu() in interior patch
 - Bring back accidently lost "Use the new rb tree helpers" patch
v2: https://lore.kernel.org/r/0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com
 - Add a patch to add structs for the L1/L2 HW layouts and use their
   sizeof and type instead of constants and generic __le64 *.
 - Add a patch for L1/L2 indexing helpers for clarity
 - Reorder patches
 - Redo the union layout in the cfg for both cases
 - Fully remove some more defines
v1: https://lore.kernel.org/r/0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com

Diff of all applied compared to v3 showing the white spaces I adjusted. Several
interior patches were changed too, but later patches change them some more:

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f1b6d434009f91..edc625ec261dd1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1406,6 +1406,8 @@ void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
 
 static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 {
+	int ret;
+	size_t l1size;
 	size_t max_contexts;
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
@@ -1418,9 +1420,10 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 		cd_table->s1fmt = STRTAB_STE_0_S1FMT_LINEAR;
 		cd_table->linear.num_ents = max_contexts;
 
-		cd_table->linear.table = dma_alloc_coherent(
-			smmu->dev, max_contexts * sizeof(struct arm_smmu_cd),
-			&cd_table->cdtab_dma, GFP_KERNEL);
+		l1size = max_contexts * sizeof(struct arm_smmu_cd),
+		cd_table->linear.table = dma_alloc_coherent(smmu->dev, l1size,
+							    &cd_table->cdtab_dma,
+							    GFP_KERNEL);
 		if (!cd_table->linear.table)
 			return -ENOMEM;
 	} else {
@@ -1434,18 +1437,21 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 		if (!cd_table->l2.l2ptrs)
 			return -ENOMEM;
 
-		cd_table->l2.l1tab = dma_alloc_coherent(
-			smmu->dev,
-			cd_table->l2.num_l1_ents *
-				sizeof(struct arm_smmu_cdtab_l1),
-			&cd_table->cdtab_dma, GFP_KERNEL);
-		if (!cd_table->l2.l1tab) {
-			kfree(cd_table->l2.l2ptrs);
-			cd_table->l2.l2ptrs = NULL;
-			return -ENOMEM;
+		l1size = cd_table->l2.num_l1_ents * sizeof(struct arm_smmu_cdtab_l1);
+		cd_table->l2.l1tab = dma_alloc_coherent(smmu->dev, l1size,
+							&cd_table->cdtab_dma,
+							GFP_KERNEL);
+		if (!cd_table->l2.l2ptrs) {
+			ret = -ENOMEM;
+			goto err_free_l2ptrs;
 		}
 	}
 	return 0;
+
+err_free_l2ptrs:
+	kfree(cd_table->l2.l2ptrs);
+	cd_table->l2.l2ptrs = NULL;
+	return ret;
 }
 
 static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
@@ -1462,8 +1468,7 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 			dma_free_coherent(smmu->dev,
 					  sizeof(*cd_table->l2.l2ptrs[i]),
 					  cd_table->l2.l2ptrs[i],
-					  arm_smmu_cd_l1_get_desc(
-						  &cd_table->l2.l1tab[i]));
+					  arm_smmu_cd_l1_get_desc(&cd_table->l2.l1tab[i]));
 		}
 		kfree(cd_table->l2.l2ptrs);
 
@@ -1696,9 +1701,9 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 {
 	dma_addr_t l2ptr_dma;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
-	struct arm_smmu_strtab_l2 **l2table =
-		&cfg->l2.l2ptrs[arm_smmu_strtab_l1_idx(sid)];
+	struct arm_smmu_strtab_l2 **l2table;
 
+	l2table = &cfg->l2.l2ptrs[arm_smmu_strtab_l1_idx(sid)];
 	if (*l2table)
 		return 0;
 
@@ -1713,8 +1718,8 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 
 	arm_smmu_init_initial_stes((*l2table)->stes,
 				   ARRAY_SIZE((*l2table)->stes));
-	arm_smmu_write_strtab_l1_desc(
-		&cfg->l2.l1tab[arm_smmu_strtab_l1_idx(sid)], l2ptr_dma);
+	arm_smmu_write_strtab_l1_desc(&cfg->l2.l1tab[arm_smmu_strtab_l1_idx(sid)],
+				      l2ptr_dma);
 	return 0;
 }
 
@@ -3175,8 +3180,7 @@ struct arm_smmu_device *arm_smmu_get_by_fwnode(struct fwnode_handle *fwnode)
 static bool arm_smmu_sid_in_range(struct arm_smmu_device *smmu, u32 sid)
 {
 	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB)
-		return arm_smmu_strtab_l1_idx(sid) <
-		       smmu->strtab_cfg.l2.num_l1_ents;
+		return arm_smmu_strtab_l1_idx(sid) < smmu->strtab_cfg.l2.num_l1_ents;
 	return sid < smmu->strtab_cfg.linear.num_ents;
 }
 
@@ -3649,8 +3653,9 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
 
 	size = (1 << smmu->sid_bits) * sizeof(struct arm_smmu_ste);
-	cfg->linear.table = dmam_alloc_coherent(
-		smmu->dev, size, &cfg->linear.ste_dma, GFP_KERNEL);
+	cfg->linear.table = dmam_alloc_coherent(smmu->dev, size,
+						&cfg->linear.ste_dma,
+						GFP_KERNEL);
 	if (!cfg->linear.table) {
 		dev_err(smmu->dev,
 			"failed to allocate linear stream table (%u bytes)\n",
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index dc720f57679652..1e9952ca989f87 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -209,8 +209,10 @@ struct arm_smmu_device;
 #define STRTAB_L1_DESC_SPAN		GENMASK_ULL(4, 0)
 #define STRTAB_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 6)
 
+#define STRTAB_STE_DWORDS		8
+
 struct arm_smmu_ste {
-	__le64 data[8];
+	__le64 data[STRTAB_STE_DWORDS];
 };
 
 #define STRTAB_NUM_L2_STES		(1 << STRTAB_SPLIT)
@@ -302,8 +304,10 @@ static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
 #define CTXDESC_L1_DESC_V		(1UL << 0)
 #define CTXDESC_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 12)
 
+#define CTXDESC_CD_DWORDS		8
+
 struct arm_smmu_cd {
-	__le64 data[8];
+	__le64 data[CTXDESC_CD_DWORDS];
 };
 
 struct arm_smmu_cdtab_l2 {
@@ -354,7 +358,7 @@ static inline unsigned int arm_smmu_cdtab_l2_idx(unsigned int ssid)
  * When the SMMU only supports linear context descriptor tables, pick a
  * reasonable size limit (64kB).
  */
-#define CTXDESC_LINEAR_CDMAX ilog2(SZ_64K / sizeof(struct arm_smmu_cd))
+#define CTXDESC_LINEAR_CDMAX		ilog2(SZ_64K / sizeof(struct arm_smmu_cd))
 
 /* Command queue */
 #define CMDQ_ENT_SZ_SHIFT		4


Jason Gunthorpe (8):
  iommu/arm-smmu-v3: Add arm_smmu_strtab_l1/2_idx()
  iommu/arm-smmu-v3: Add types for each level of the 2 level stream
    table
  iommu/arm-smmu-v3: Reorganize struct arm_smmu_strtab_cfg
  iommu/arm-smmu-v3: Remove strtab_base/cfg
  iommu/arm-smmu-v3: Do not use devm for the cd table allocations
  iommu/arm-smmu-v3: Shrink the cdtab l1_desc array
  iommu/arm-smmu-v3: Add types for each level of the CD table
  iommu/arm-smmu-v3: Reorganize struct arm_smmu_ctx_desc_cfg

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 284 +++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  92 +++++--
 2 files changed, 200 insertions(+), 176 deletions(-)


base-commit: a2bb820e862d61f9ca1499e500915f9f505a2655
-- 
2.46.0


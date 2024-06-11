Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5356C1C02;
	Tue, 11 Jun 2024 00:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718065889; cv=fail; b=U0kgVRDOEV8PB9WzfT4Lz1jjfzJGOhOJuLdOpzwy4DD6+J/nr3qVGzoZeUEinFEsQamet3N+rFB/+sUdEwBKQgWGtPy2g03I4xWBPTT0ntG1XyYZn6bGmOlNimp2Rja+rDVCnCez789lnzMedJ2wp+AInBXHzTmk8HPHGREd7VY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718065889; c=relaxed/simple;
	bh=F4sRq6EVKC+0UBakycT3uD2FaxUOlhUdMG2+OCFfQDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Q6CtCIA7s6CTLhQu9/FGxIlnxg1qY3Fx0XQK0dkrTv1pgyq3nEpfX9UfA2d/ARUQftQOxfZpT0cY6qZNlkuWp12qp+ApHuv0vK9eDirIOosHpdYZ3LAw38t3HDJf52/gqK8fDQlqhM8lMo6Psp2K8GZHbqNCVqS3IlVAOGaokp8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ATauL9se; arc=fail smtp.client-ip=40.107.244.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ATauL9se"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mrBLX66Zj3xrkWf5jDbmE3MyqaOTSnmaUs2JXqyMRAjnohMS9tP0LQ8V2yNlwdfYllmA6Qh6VKxtdlMrgmi80VxtzyR6xom9lGBRqb3leBNssHUWbxoaYNOChms8X7gVLyBjVCY8o67Wj+qJeKsTcta7S4wmTTz6P3BRZBG8I5wiu8GQHYu/k30a4ubqrtxT+3+yz6kcfH+M8XC6g/HTdT6I2ziLd4qe/J7SL+jyjuuYk2Kdl2Xc39NJ8XrOZvPIgQJjNoFRjY8w0yc2wW4XQU7isZP6dS66ToiF/XvuaseA6PRhaMJcgwaW4xCeD814I4D3k3RiEZ2W8itsScHOZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=egCXRcBlnMbohCVjqhJ6vFKAuzzIRmlFwYHe+rj6s8g=;
 b=VKPpLGadlHaFwjkJzMOFQw8MCs4q8hv47Ux6bxCtrDObX5ul7pu1NNA26K1ADKf1DkAt+Ws8SAEvNDBuJ8VI8aNvCsos/E3Mgn2qaK8r/IHaO7v6ExpWs0lgZIjqlXZmuwxvkVPxqpM9/1Y0WQtLYebRQt/mU5EpyYFZzOPT/XFHF515j3xnGUET2cr83Ps/LI/c2rQo7URwR4Rvpyk8zfTJJLYJMpaVDR/KglOIt8zIaBfKDieU47jcdHnO0vUWIKgjisQXJemetAnQPz6Yk6rVnKUaStbMk1bFSKEhLx3Xv4lVQHeAJmXZ8Er/N18eGLai+/KXncmROmavN1GDBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egCXRcBlnMbohCVjqhJ6vFKAuzzIRmlFwYHe+rj6s8g=;
 b=ATauL9se+g8IUf/Ss2gxmCpX7mXWY103n0JmG5vwx7AAhbHqytSPZdHaotUwUnSDTobVclDADQNZ8A5pvoVsR4zqO1D1J32ebf2g68GmyHPH11eEtry7CXNDrJDeVRDtSTEBlbM3X3mofTAVMWpQJEcEX1jUiAKeNCqV/ABQF71kkutyMIsTBSpmXQ3TR2UsGY7ZkAbzUYRg2RDiZH7Oq4Aile/I5btvrsr0Q+O+XcTX38CPJi1eOW1VDFsZKdU982YbZozuTPOjKJPLdegm6Olh3l5eOTw2bur3rFkOg1TNnWnfn2ea/N+hue3JKoAIc9lngG5pScgI+rAuGdvIjw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN6PR12MB8565.namprd12.prod.outlook.com (2603:10b6:208:47d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 00:31:23 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 00:31:23 +0000
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
Subject: [PATCH v2 10/10] iommu/arm-smmu-v3: Reorganize struct arm_smmu_ctx_desc_cfg
Date: Mon, 10 Jun 2024 21:31:19 -0300
Message-ID: <10-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0014.namprd22.prod.outlook.com
 (2603:10b6:208:238::19) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN6PR12MB8565:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f344b75-ffa2-43f5-09a1-08dc89add133
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wUxp8mdqq88Grn1+Pu1niyok+mj4fvRznl+BFxwJwz5s0z0xZW3VZLTxjTos?=
 =?us-ascii?Q?ZXNaj7U83LFIWmBNDFkJ10HG5s0sH1aV0wYUSrfL+gGZWfcui2csCmQMfAdv?=
 =?us-ascii?Q?Bq3JlI0R4yqQd+47mzhmUZBllfs0rpf2/8x7ra9M+3C/N8wa0Zs8k88r4gOV?=
 =?us-ascii?Q?1vZ/sHXhl035s7IGzQEQPmwIkDgJH7GIn3K1HVj2Uu7xSuX0lWUC2XvAoD29?=
 =?us-ascii?Q?sSogIAYrTBtbYSmbaMIzyW1BnilJj5q0nVakz7WnvVQQW83WDXm9j8w055BV?=
 =?us-ascii?Q?AlAPeKOcnZs4kSEUjeZvRFmCmgLiuheA4Qyy0wlwiIXl1B6s928b33edOveb?=
 =?us-ascii?Q?i6cyuu9Dbzkpq23n9qHccHGVTz3FNx1QDEzREjt/qrF7ky86vjjiyFpvjqKl?=
 =?us-ascii?Q?r3/3qxfavVwtD2Gv3G1k2HjUXqX6F0Tbl2bymDsVGVxRe2zxga6Rctbv8zs8?=
 =?us-ascii?Q?YCtGgu0F8xxYgZE0ln7JFG4TGc4eEEZdxasLKOlGJWYjxfp1SouD6FHUaNBn?=
 =?us-ascii?Q?DXkddvLguNMFcJK6x8aPioP+he3ij+aAVr2AFpHG8stdaAD0ZBf0+N8n5/pK?=
 =?us-ascii?Q?VJ4Ez7IJ4Qc7dmzLxutytwCel2G5QeTgUz5ClncZ3TwcYneBtjUcg9Rdsxe0?=
 =?us-ascii?Q?ubfzX8LW+5oaKKFULdvR8y8mHFr6E2Wpuven+E5d1jsNNxhrIK6+tUJuyU5V?=
 =?us-ascii?Q?82Qgl8VaH3gHGIogbokv0tZ3l7E6k5ojjeJT6qnF5qZLNlWpPrjXLofH5jF5?=
 =?us-ascii?Q?KjxaIQSHgbfVE+j6zB+95cla2aWhA4uieX/eJvN9HyW9fGDv/7a4N96spHfa?=
 =?us-ascii?Q?wUJYDVAFc9RofLk9Wo4KUzZ98DY9mwmiwebWZm4LDY7RaWJ/sU0mba7afbtS?=
 =?us-ascii?Q?LI1a1ailv+PjmxcFtKj37tPhx7oqTrM1qwCOIGKgjsPiGH+jFrBOd4aoTM+V?=
 =?us-ascii?Q?dwZQb6lZsgE7rEsxXYJhbFcoKKax2UBb8wGufFqBqrKQm9TnDxSteUSInKRZ?=
 =?us-ascii?Q?3DcBJVPG5ZbEAHX8K2BYBfPJQW7CphPUAlYVxU4J0kd8TFzIb1OW1kNEaR4i?=
 =?us-ascii?Q?3j1BbwMZKA7RM3GgDenYKS1y83x77nuNPvk6YG0TDKprQnBpEyw1XST0Ewxl?=
 =?us-ascii?Q?44sN9x6T3SdpFAnUzm2EkUg1DTA4RzQNZQLjUgSQXMyeRUW5hJBwQ+WQfTeW?=
 =?us-ascii?Q?GWMEDo36kTQulGCzwBh1b6vIu3DXm5Ve4cY7PCL1300mp/Dushn4d/N2PRLg?=
 =?us-ascii?Q?z7Sam5ZcUUcFQqcLe59uLmrPWOeOrRLBUNIkQHVK3V0YrdKdCxlwDn37JcVD?=
 =?us-ascii?Q?o6dg1jpd6GxASaPJIR9UTJ6U?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TUG1v1NfzJRYIvhELIyVx/lCDtxUwpa/IafhPpwSwxa1ys/7XEOQS8CLktU4?=
 =?us-ascii?Q?tKkKIiw4Fea9GEl2R1aK/dE0tH3fo2Bsx23nZu3mImsaokv0I8MvEyBtEVnF?=
 =?us-ascii?Q?d8hZzIpIpM3CGCe61W6yHs+AdkKtVuICTnl5EpxX7Yl6hVxJAP8X3UY0toAW?=
 =?us-ascii?Q?nGyb8r+Ca21EtfxLPfHA/UoEBfJut6F/HQy6OM5p4jX2zTBVb//WSuyarkCJ?=
 =?us-ascii?Q?Syf7xv+ldD7k9xL82eZijE0VxK2TK+oDZsIyp8AN1kLQGSO33fjftfruTMIJ?=
 =?us-ascii?Q?TbMDxTyX+Jxm8gGLd0qgY302odKmNbWGHMfB728BWZc/yF7iMXtWfM+JP6hr?=
 =?us-ascii?Q?cuXfzJqsseX3nk5387l3ZtILAyuNOzzZ9cdOsW3vcJlW/5zwOLgokhJM0eCx?=
 =?us-ascii?Q?fLyJfr8n3gtu/TvLe9+bu88i6zFbmfmK3D6tpZFr33xtT582lhTlBztA91+G?=
 =?us-ascii?Q?dTud1WBr6zoUbTY1otfNFabHc1Obgp2GnvvaIaDanbSa082BLMa4XgzcHccQ?=
 =?us-ascii?Q?kO3u3W6sAGp9Zh7uPHAkT6p3yYTUaY0fE0J6cM3SaG9K5CCvnxPwOQ8iqWPI?=
 =?us-ascii?Q?/MEV98uVXiu2g60eqyZoMWVOFc30FMHpE14k8Td7IHqd7vdS4lj8yXEAPuzS?=
 =?us-ascii?Q?kiic+TLWopyhxazCqMaqcLFGMIisUkhFC4kSUEsFlMSCcDbO8nEV2f6j5RYB?=
 =?us-ascii?Q?Q4wiE1JMrqRx2F6XHqDGzSLtbDDSoONbha4U11sYldPVFoSjQzobNcrdvpuk?=
 =?us-ascii?Q?AwpgP+O+8mfgT2C6ic5WkQ7IFwxP2Ycx6LAir2pk2YmXfSyt1sgO6RbDQ7P7?=
 =?us-ascii?Q?QM2SkJAi/vULGxuT/dRefMAYg/W+m7h5dXcoYwFGCSWwwUxCwowhcHIVvEs/?=
 =?us-ascii?Q?CEgjkeRUNFdMVB0dhnoYUvql/Sli0n8IytDVl8MpyX6Tmt1iyBiKDdAlaoEc?=
 =?us-ascii?Q?BvSSVst6fB1o6ojsz/wAJzOFIlzuTkSkDRAegLLRGUWr3ERuaQSmEw3ZK6qn?=
 =?us-ascii?Q?x6BZ0x1LFtJg0HTNY5/0+kfOMSWTXKMUT4JY8hhuUI2njup7XSN8aN+yE9uP?=
 =?us-ascii?Q?3e0wzW3IRsJHCoLEldqgty6icspL/w6WjiDyMhl8WVwtdTIQjoLduz/pD63X?=
 =?us-ascii?Q?b2FJ44GrwPBggzveAlvB9F+518Kt8iJ6jvvpPshOr9Fi8/7H94R5Ujdk7yhy?=
 =?us-ascii?Q?FNs/Ky2ktlZtGyf1bAKuQoNw24PIHxiun7Xoygrbx9/Mjyldppe1xcVoS92k?=
 =?us-ascii?Q?9uYumqg0r+rv540FfAoXt3g/JV8rDMfoZSPbV86XJ6qW1rkb21gvP8c1q/4L?=
 =?us-ascii?Q?IURqMopa21dGV5WJ8f913/yE7anJ7yhYJEs7OdVezm73zRg6PSmyXvXtNSyy?=
 =?us-ascii?Q?Q5qd+xkVi83o47TUOS2ZbIZmAZ8BEx1YOLz9YV3Dmw8Cc1h8ox8EDV2NN/5A?=
 =?us-ascii?Q?llYGFolxJeQQxJ5Frnx61V/EBAO8hozuu1tD7K7FK68gTkgO+uurFWv7fPtP?=
 =?us-ascii?Q?S6IaxAGFsUhUrpRsipsQ8P340L+n3rYhMO5fWl7maPwH+agQRlawrH6BwR2M?=
 =?us-ascii?Q?zvBezNt8FQQ5if4QBhY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f344b75-ffa2-43f5-09a1-08dc89add133
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 00:31:21.4652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GZlRxfVIz/H/h3I3ke/p0ZIhJvFmOPpFaD+WxuVbuf/5d2a8NG7LYwzpMoPKwdKe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8565

The members here are being used for both the linear and the 2 level case,
with the meaning of each item slightly different in the two cases.

Split it into a clean union where both cases have their own struct with
their own logical names and correct types.

Adjust all the users to detect linear/2lvl and use the right sub structure
and types consistently.

Remove CTXDESC_CD_DWORDS by changing the last places to use
sizeof(struct arm_smmu_cd).

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 119 +++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  24 ++--
 2 files changed, 71 insertions(+), 72 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 49e019131ef3b5..b9994c46c52f25 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1184,19 +1184,19 @@ static dma_addr_t arm_smmu_cd_l1_get_desc(const struct arm_smmu_cdtab_l1 *src)
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid)
 {
-	struct arm_smmu_l1_ctx_desc *l1_desc;
+	struct arm_smmu_cdtab_l2 *l2;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
-	if (!cd_table->cdtab)
+	if (!arm_smmu_cdtab_allocated(cd_table))
 		return NULL;
 
 	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
-		return &((struct arm_smmu_cd *)cd_table->cdtab)[ssid];
+		return &cd_table->linear.table[ssid];
 
-	l1_desc = &cd_table->l1_desc[arm_smmu_cdtab_l1_idx(ssid)];
-	if (!l1_desc->l2ptr)
+	l2 = cd_table->l2.l2ptrs[arm_smmu_cdtab_l1_idx(ssid)];
+	if (!l2)
 		return NULL;
-	return &l1_desc->l2ptr->cds[arm_smmu_cdtab_l2_idx(ssid)];
+	return &l2->cds[arm_smmu_cdtab_l2_idx(ssid)];
 }
 
 struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
@@ -1208,30 +1208,25 @@ struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
 	might_sleep();
 	iommu_group_mutex_assert(master->dev);
 
-	if (!cd_table->cdtab) {
+	if (!arm_smmu_cdtab_allocated(cd_table)) {
 		if (arm_smmu_alloc_cd_tables(master))
 			return NULL;
 	}
 
 	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_64K_L2) {
 		unsigned int idx = arm_smmu_cdtab_l1_idx(ssid);
-		struct arm_smmu_l1_ctx_desc *l1_desc;
+		struct arm_smmu_cdtab_l2 **l2ptr = &cd_table->l2.l2ptrs[idx];
 
-		l1_desc = &cd_table->l1_desc[idx];
-		if (!l1_desc->l2ptr) {
+		if (!*l2ptr) {
 			dma_addr_t l2ptr_dma;
 
-			l1_desc->l2ptr = dma_alloc_coherent(
-				smmu->dev,
-				CTXDESC_L2_ENTRIES * sizeof(struct arm_smmu_cd),
-				&l2ptr_dma, GFP_KERNEL);
-			if (!l1_desc->l2ptr)
+			*l2ptr = dma_alloc_coherent(smmu->dev, sizeof(**l2ptr),
+						    &l2ptr_dma, GFP_KERNEL);
+			if (!*l2ptr)
 				return NULL;
 
-			arm_smmu_write_cd_l1_desc(
-				&((struct arm_smmu_cdtab_l1 *)
-					  cd_table->cdtab)[idx],
-				l2ptr_dma);
+			arm_smmu_write_cd_l1_desc(&cd_table->l2.l1tab[idx],
+						  l2ptr_dma);
 			/* An invalid L1CD can be cached */
 			arm_smmu_sync_cd(master, ssid, false);
 		}
@@ -1336,7 +1331,7 @@ void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
 	struct arm_smmu_cd target = {};
 	struct arm_smmu_cd *cdptr;
 
-	if (!master->cd_table.cdtab)
+	if (!arm_smmu_cdtab_allocated(&master->cd_table))
 		return;
 	cdptr = arm_smmu_get_cd_ptr(master, ssid);
 	if (WARN_ON(!cdptr))
@@ -1346,8 +1341,6 @@ void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
 
 static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 {
-	int ret;
-	size_t l1size;
 	size_t max_contexts;
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
@@ -1358,71 +1351,67 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 	if (!(smmu->features & ARM_SMMU_FEAT_2_LVL_CDTAB) ||
 	    max_contexts <= CTXDESC_L2_ENTRIES) {
 		cd_table->s1fmt = STRTAB_STE_0_S1FMT_LINEAR;
-		cd_table->num_l1_ents = max_contexts;
+		cd_table->linear.num_ents = max_contexts;
 
-		l1size = max_contexts * sizeof(struct arm_smmu_cd);
+		cd_table->linear.table = dma_alloc_coherent(
+			smmu->dev, max_contexts * sizeof(struct arm_smmu_cd),
+			&cd_table->cdtab_dma, GFP_KERNEL);
+		if (!cd_table->linear.table)
+			return -ENOMEM;
 	} else {
 		cd_table->s1fmt = STRTAB_STE_0_S1FMT_64K_L2;
-		cd_table->num_l1_ents = DIV_ROUND_UP(max_contexts,
-						  CTXDESC_L2_ENTRIES);
+		cd_table->l2.num_l1_ents =
+			DIV_ROUND_UP(max_contexts, CTXDESC_L2_ENTRIES);
 
-		cd_table->l1_desc = kcalloc(cd_table->num_l1_ents,
-					    sizeof(*cd_table->l1_desc),
-					    GFP_KERNEL);
-		if (!cd_table->l1_desc)
+		cd_table->l2.l2ptrs = kcalloc(cd_table->l2.num_l1_ents,
+					     sizeof(*cd_table->l2.l2ptrs),
+					     GFP_KERNEL);
+		if (!cd_table->l2.l2ptrs)
 			return -ENOMEM;
 
-		l1size = cd_table->num_l1_ents *
-			 sizeof(struct arm_smmu_cdtab_l1);
+		cd_table->l2.l1tab = dma_alloc_coherent(
+			smmu->dev,
+			cd_table->l2.num_l1_ents *
+				sizeof(struct arm_smmu_cdtab_l1),
+			&cd_table->cdtab_dma, GFP_KERNEL);
+		if (!cd_table->l2.l1tab) {
+			kfree(cd_table->l2.l2ptrs);
+			cd_table->l2.l2ptrs = NULL;
+			return -ENOMEM;
+		}
 	}
-
-	cd_table->cdtab = dma_alloc_coherent(smmu->dev, l1size,
-					     &cd_table->cdtab_dma, GFP_KERNEL);
-	if (!cd_table->cdtab) {
-		dev_warn(smmu->dev, "failed to allocate context descriptor\n");
-		ret = -ENOMEM;
-		goto err_free_l1;
-	}
-
 	return 0;
-
-err_free_l1:
-	if (cd_table->l1_desc) {
-		kfree(cd_table->l1_desc);
-		cd_table->l1_desc = NULL;
-	}
-	return ret;
 }
 
 static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 {
 	int i;
-	size_t l1size;
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
-	if (cd_table->l1_desc) {
-		for (i = 0; i < cd_table->num_l1_ents; i++) {
-			if (!cd_table->l1_desc[i].l2ptr)
+	if (cd_table->s1fmt != STRTAB_STE_0_S1FMT_LINEAR) {
+		for (i = 0; i < cd_table->l2.num_l1_ents; i++) {
+			if (!cd_table->l2.l2ptrs[i])
 				continue;
 
 			dma_free_coherent(smmu->dev,
-					  sizeof(*cd_table->l1_desc[i].l2ptr),
-					  cd_table->l1_desc[i].l2ptr,
-					  arm_smmu_cd_l1_get_desc(&(
-						  (struct arm_smmu_cdtab_l1 *)
-							  cd_table->cdtab)[i]));
+					  sizeof(*cd_table->l2.l2ptrs[i]),
+					  cd_table->l2.l2ptrs[i],
+					  arm_smmu_cd_l1_get_desc(
+						  &cd_table->l2.l1tab[i]));
 		}
-		kfree(cd_table->l1_desc);
+		kfree(cd_table->l2.l2ptrs);
 
-		l1size = cd_table->num_l1_ents *
-			 sizeof(struct arm_smmu_cdtab_l1);
+		dma_free_coherent(smmu->dev,
+				  cd_table->l2.num_l1_ents *
+					  sizeof(struct arm_smmu_cdtab_l1),
+				  cd_table->l2.l1tab, cd_table->cdtab_dma);
 	} else {
-		l1size = cd_table->num_l1_ents * sizeof(struct arm_smmu_cd);
+		dma_free_coherent(smmu->dev,
+				  cd_table->linear.num_ents *
+					  sizeof(struct arm_smmu_cd),
+				  cd_table->linear.table, cd_table->cdtab_dma);
 	}
-
-	dma_free_coherent(smmu->dev, l1size, cd_table->cdtab,
-			  cd_table->cdtab_dma);
 }
 
 bool arm_smmu_free_asid(struct arm_smmu_ctx_desc *cd)
@@ -2937,7 +2926,7 @@ static void arm_smmu_release_device(struct device *dev)
 
 	arm_smmu_disable_pasid(master);
 	arm_smmu_remove_master(master);
-	if (master->cd_table.cdtab)
+	if (arm_smmu_cdtab_allocated(&master->cd_table))
 		arm_smmu_free_cd_tables(master);
 	kfree(master);
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 7ed8d53423cf56..35879064c0f725 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -616,20 +616,30 @@ struct arm_smmu_ctx_desc {
 	struct mm_struct		*mm;
 };
 
-struct arm_smmu_l1_ctx_desc {
-	struct arm_smmu_cdtab_l2	*l2ptr;
-};
-
 struct arm_smmu_ctx_desc_cfg {
-	__le64				*cdtab;
+	union {
+		struct {
+			struct arm_smmu_cd *table;
+			unsigned int num_ents;
+		} linear;
+		struct {
+			struct arm_smmu_cdtab_l1 *l1tab;
+			struct arm_smmu_cdtab_l2 **l2ptrs;
+			unsigned int num_l1_ents;
+		} l2;
+	};
 	dma_addr_t			cdtab_dma;
-	struct arm_smmu_l1_ctx_desc	*l1_desc;
-	unsigned int			num_l1_ents;
 	u8				s1fmt;
 	/* log2 of the maximum number of CDs supported by this table */
 	u8				s1cdmax;
 };
 
+static inline bool
+arm_smmu_cdtab_allocated(struct arm_smmu_ctx_desc_cfg *cfg)
+{
+	return cfg->linear.table || cfg->l2.l1tab;
+}
+
 struct arm_smmu_s2_cfg {
 	u16				vmid;
 };
-- 
2.45.2


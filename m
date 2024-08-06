Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2088.outbound.protection.outlook.com [40.107.212.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE09172BA5;
	Tue,  6 Aug 2024 23:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722987098; cv=fail; b=RFUseZEAwgC4xB40rDwqOYMMmPBbiMIRfjzx37ncTHzmxX7ld1z015J21IbyWAZNjvtdxMO4UIT+icO8lWwitnzrVr9dE4zClokWvji+Wy/Q6RfZ1SV8DEbfC5gAFE50dOjhGzKL33VorqnY1G8O0rg+/DUtfYC4fv9T084r9V0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722987098; c=relaxed/simple;
	bh=IyuyJs16Vtr2ydQv+V95JYpjhlNFbsbtUUdPfuebc78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H3LzgFUH5V5HWpkITjeWfwXRudm2Ik9TQbA0gfYdfAZKniCffCoh/eskMR5zjQm6Al9d3grrGH0KoVT8jYSQPztFu14dMm0Xw2YGQ9E1/TV9G8arN9avTwlPDZa2mRk0hlK2n4oW+aa52YW7N7hKCY7QmRUV2EwuGgKwp6evDGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HInd/qod; arc=fail smtp.client-ip=40.107.212.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HInd/qod"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ltgEMeE3eQVBWIXlVrvE+b5IQ68jBXW6A4wrKBn5cTsZFHAkX58Wq9TA4rcTPN8RiAkjTE5TvGaDhXZw35ss5ZX/8pO75wwnfOp5wmBJBTmXLVZn63Sf/dldNmK/WRgaA/3Ib1wD+1gryyRdOxaPAFtPHL30ADrOkBQw6za5Sf4BX287Q+gLoXd7rgyMxoQTifKnEPLUgUpGSeoLfa4Kg7VXLB3OTRzX4mEvChqj9hYrSNf0q80dtwX7ZBaqnUoZ3r6qydacrkbNxAexiKsI1VtoK9u/WHR9gCx4euo8VmTUl/co0T66DGt/N35rh6CBOx/k5wcS39D7RWxO5dzUdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=avacmMrQ5myRDCNuypGXcU1mUVf8sauVWQzFhQgoo4o=;
 b=MSQzFPeWFdAyZEbHiGiVrSuKDnDYalCT4Q2MfIdyfEjAegVvst7PV70Xd8cKxFJNGEvxCEkOuZczNVstWzwKBAu54j7b0icOPy9up6pnShFD4mqLBU2ncyvLo07xkqr8tNhIH7aUpRAiiqpkQs1TmGkAACMjNa7lVC5/vqLArs6/CeeMw234Iz7bLGGA9xGbr909lGa7BTWjl7DRJs1J49C52f6sObyJiiVoi23dcThqrAsTilN3ceFX3VCzQKKiw/XrJVLvuufiyC0MzZwo0HC04tlAr1DkrYiWECjpY4ntxuIiRUKTkXwM4VhuWOJsG9SastdVLIvqI79LPasR2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=avacmMrQ5myRDCNuypGXcU1mUVf8sauVWQzFhQgoo4o=;
 b=HInd/qodDRFjO2oMqtys3ulw0zU4QcHRJ8Ud3Y/a/ObmfdlGcdJagdylnmWWGkUuS1woJad5/PPFOVFKxeYJsRSWo+E049iSLYjrbYY4Wng7A54TjRP/1U+901QpYMWe43leO6eiXUcPqHgv0RhvDUDS85u+58Bnb7ZH/Ywx+Gk1h9LZqlckjDZNIcVEARJELQeIKgT6q953wvstnNodvu9h2pxmnyvdblGU8eqMQUnBekTqsq0oIVtw0G+kutoOBYOx6baRJ5MVQdR4L5hs+JUfOHLnFVAFnczrInyg4Aj6CpSnrkbrWnbmEpYK6fVSL+ZU6CV5hgQWClSYNP+jug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by MN0PR12MB6248.namprd12.prod.outlook.com (2603:10b6:208:3c0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Tue, 6 Aug
 2024 23:31:29 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 23:31:29 +0000
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
Subject: [PATCH v3 9/9] iommu/arm-smmu-v3: Reorganize struct arm_smmu_ctx_desc_cfg
Date: Tue,  6 Aug 2024 20:31:23 -0300
Message-ID: <9-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0410.namprd03.prod.outlook.com
 (2603:10b6:408:111::25) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MN0PR12MB6248:EE_
X-MS-Office365-Filtering-Correlation-Id: afca6dc3-d63f-46c6-b202-08dcb66fe342
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N4rrqHRTCglOh/bOy55zC6OepBVees8eNT3BQK3X3P5hLTFSgcnDcqX8oJ2o?=
 =?us-ascii?Q?V1siRLOBSIBCA26D8kAHfmjgceA+zQhSEmYm3Bdxuo0U7TlsSNrLClEbMbX5?=
 =?us-ascii?Q?MHb7fHDNrSJ9XfIpYehQcXtsOWYYrl6Bwk6t2/TCCIaAEThs5uTX0lRtoJT7?=
 =?us-ascii?Q?smU7WJSjlP8VEDdGahRlpp6oJmcjOS6l1Zjt8UesbgdXehcWojpCq/zNpuRG?=
 =?us-ascii?Q?b5E0Mkd+/T2+3nHtkJ9AlN2mI8qqosnB7/mgEWRYQpqdIx/lp2Qi04FpwQpe?=
 =?us-ascii?Q?N58qFas4QxxdLdMcW82qEtDptqHOY+WRcdRQQXmjJAk2/pwJVk9xiabCE3lg?=
 =?us-ascii?Q?FHVsQn29i+193dRZ7Vom6ab9BvnQZCu/nY8UhDsRCCMI/eOjP4ZdsdHz97CN?=
 =?us-ascii?Q?JUFmFquTQjLxybawTfTc9TknPf7FstYq20ym77/n8dAIsjLP1td4GmzAcwuA?=
 =?us-ascii?Q?5IQ4104lEXZtc7RQo8C37OGz7o2NqB6cZYIextsgrW6pXb/LZRok+QR3TuVk?=
 =?us-ascii?Q?Pol0WXk7nAT720oohYPrpnqz0hrndcZLQSs/YHobrPSU4tRfkFiNdbAcF4Cb?=
 =?us-ascii?Q?tAKpL/IG6GWecBJpHZkqPn54vrgfj5ivESOvPfTrcPpHd79jM16L02HwcxEm?=
 =?us-ascii?Q?JqPCwREhTAWeeUvY1XTIUwOvb8Cxv7MJdQfcgtxX7psODXLjBKuNsoufWKtG?=
 =?us-ascii?Q?RZeB9HBi2MtMA6OXQt2beOnwnMLYVTWJV5zbDEeXru+FMXpZnGXZjyMV5N1B?=
 =?us-ascii?Q?n6Yz3psZUq6v+XGDfuLhMawIaMqaxIdHJnDcp6G6J4WjQJ5H62HWyDmJUAGa?=
 =?us-ascii?Q?KQn6JH1ulCyutB4mda1DfCfWbIz0wBOhlBNXSTKIJ2B1jgvxKOP9dnKVQjuF?=
 =?us-ascii?Q?X2TL0YrLK4DveM1raB2pFULauD3NVg4WFID/KBvkGFAWTaRnHFMg8tyzIOaB?=
 =?us-ascii?Q?snG7BPV7byU2KTR0q5+pOAhQNxor8VlsVT8rYKh3R08+AmFNA0NoyFjPFzaT?=
 =?us-ascii?Q?2aRHXBGaDorgjuQL/gpNBqVbQF9D1hDuLmK512l7AwOWd8soYYwB7nbi8WcM?=
 =?us-ascii?Q?EdvoBu1YSwt4qKCfJ9xBl1u9XcKUtyJSwml/iZzc7AntJC2xVDKVNg5oOJ85?=
 =?us-ascii?Q?8+1idJlcTKJhzE6X+wLr/1dM9iG5KkTyvRsEgpuOatLhV8eOP4LsvBu0vfCk?=
 =?us-ascii?Q?ReNNqmZwhkVm1jyuGXA9e3YepFkEqm9Naf6oSRVgvb1J8s0tnfJLq8XBy79+?=
 =?us-ascii?Q?gQ9Rut2oW8H829POhvL6EcNLggDEgs5H+kdC4mePf5A2xPRj0fQLJIoXGJ2l?=
 =?us-ascii?Q?FlM4P8heN1B1JoiF0kaWmV9APOP9lEM23fSJB9Pc6T8vMg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sgfWjqYYRo1JadIcLyXxiLGEUaVh3OvcUWdGvjgIwTNuKduAnowAOjzi5K5M?=
 =?us-ascii?Q?Zv1eUv7+J6Xwnn71kgYfv3OeryHMD7LxaSgSfhFMGnlUTg0CrN83iDno0hII?=
 =?us-ascii?Q?+nQ0P9nHL2Q7Z2YilyK0kVe27SveccRFtv7GLs+Mm9tXX/crCeJ2obhQhxnB?=
 =?us-ascii?Q?Pqz0V+FpUW6aWEGbU6KxsZGrWuSi8x1fTKb0IKqPNqYGZA1FkT3CpYgLIHe8?=
 =?us-ascii?Q?HvGL3rNTmdbchiKeS6BuaKs1Qha/QSaX9FtwGvMqczIZWDDtTcDu2+UE5SkH?=
 =?us-ascii?Q?Co+h+Dr4BbleJzgvhOPhnOw5hE2uvo6xQfX/EEn/DOwqXNhemSDdbvUsLP7r?=
 =?us-ascii?Q?LTOdeshM+pWMMqwCm/CqvnJ1FgDovdSl/IXVyCTUg1KHPXmcoYtKvGco3Q8F?=
 =?us-ascii?Q?NyiIB9oBeWUICm8MMgiA2cbSsSoPIPXPLZ/k2H7P48v/PsPLcsYOMU4lO552?=
 =?us-ascii?Q?lacwXS72BXPrfxs4DLgBn78AYFSLaRjojQA7qapHT+/4aVfYFa8CREZMF7gB?=
 =?us-ascii?Q?W67aKXBC6MrRbHjqc9PVx88qx2HfYFpLhp5ILB8o2PtG+KIzkvNR+OzuAFPZ?=
 =?us-ascii?Q?N6obH48jYGSDtQa5dMOVCSBo2whyBq7D4P0aHu+GNmtYJh+MKlVIq/2LExe9?=
 =?us-ascii?Q?IVBtm4No9bp+l4yvEWesKv8h+nhj/Q1fqLHY43ikig7OA9CaVpQaGC7JnTic?=
 =?us-ascii?Q?cQy5N9zG/uQJzO4iqHPZEc2uEYngmiG4uvaxB844EXCJH/RKRAVtuhSacBPG?=
 =?us-ascii?Q?tgVXWKIechD6jCp6vwZ6CtyCe+Mrnfvs3kPfwAHiJlJ/V/pLpaMKD+7+dZe1?=
 =?us-ascii?Q?BxyNSf8of1hLjmgMVCAwTNpv0qLwpdlLEp8cHuyj3YWeo5896coz+tRkcRJq?=
 =?us-ascii?Q?RnxUOye9q9+JGlW/5iY2+uLnsnNfOQNmIiKZTVOye4a9EAkULR0Pf8PNcmrh?=
 =?us-ascii?Q?2gTLR4tdU3PdpyeBzehWpqM7Aby9yPdMAz9ZSwxXabrSmd0DXpeVGA0QNWZs?=
 =?us-ascii?Q?TmyFCgabupbfWFtr4B5w38k8in8Gd8n8hK/B/S0oNHVd9qbKkbqhk0/EQi7j?=
 =?us-ascii?Q?R15piCLnFPAwZ6lGSOdITdZVUlE/86MQ2HdZMsPX64qXECR0muLOrzpF4zER?=
 =?us-ascii?Q?S0hW2GWFRQNngJeb2DC5NknsH1P+rS4lAz4ACALHkIFgaGclfNsUcWcpTP7p?=
 =?us-ascii?Q?ZuZp6PpSU1MR6ENyzfRmHZ9UqbsZZ4ZktAgKvzKXyAWLgHl/rmnLOiMXONa8?=
 =?us-ascii?Q?nQbDXWmv4IZEfCb0MY8gpxOZGVplGzKtAOzqGCsjVUkHbPCVPjsct21+XL4Q?=
 =?us-ascii?Q?oBE2HT8bBbDqgbumqDdc23g/VbSdeNp+I9he08W0/cs8oWOQXfvs1bdqofTb?=
 =?us-ascii?Q?EEyLk0Pn9x2PO0Ptcd+XZ7Ez7fqC62dH9XGOonvTGf7dBQh6hqdldwrpM3VP?=
 =?us-ascii?Q?IfOIHlwwcj3zdilLma+8RCHYKnMGLXW187jsI/SO8/0PYwAotRaa662RVYfX?=
 =?us-ascii?Q?vPe9hTF8FdiMB9C2+61yr/HL0+SVfFDdJQDXKcGkYBj66UplWcgNXrKN7xZB?=
 =?us-ascii?Q?7OZTSg1CZvNG/J1oXm7CYpeRZrpZt7GfjSeRLjk1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afca6dc3-d63f-46c6-b202-08dcb66fe342
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 23:31:25.1948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MF9OSrz3FQdiFk9yDjKnxCpJxdxtlgLTncFNIXmTFNKuOAQXwxzzL+fQjP64wAoI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6248

The members here are being used for both the linear and the 2 level case,
with the meaning of each item slightly different in the two cases.

Split it into a clean union where both cases have their own struct with
their own logical names and correct types.

Adjust all the users to detect linear/2lvl and use the right sub structure
and types consistently.

Remove CTXDESC_CD_DWORDS by changing the last places to use
sizeof(struct arm_smmu_cd).

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 119 +++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  24 ++--
 2 files changed, 71 insertions(+), 72 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 70b37d7f0e245d..e5db5325f7eaed 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1196,19 +1196,19 @@ static dma_addr_t arm_smmu_cd_l1_get_desc(const struct arm_smmu_cdtab_l1 *src)
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
 
 static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
@@ -1220,30 +1220,25 @@ static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
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
@@ -1363,7 +1358,7 @@ void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
 	struct arm_smmu_cd target = {};
 	struct arm_smmu_cd *cdptr;
 
-	if (!master->cd_table.cdtab)
+	if (!arm_smmu_cdtab_allocated(&master->cd_table))
 		return;
 	cdptr = arm_smmu_get_cd_ptr(master, ssid);
 	if (WARN_ON(!cdptr))
@@ -1373,8 +1368,6 @@ void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
 
 static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
 {
-	int ret;
-	size_t l1size;
 	size_t max_contexts;
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
@@ -1385,71 +1378,67 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
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
 
 /* Stream table manipulation functions */
@@ -3299,7 +3288,7 @@ static void arm_smmu_release_device(struct device *dev)
 
 	arm_smmu_disable_pasid(master);
 	arm_smmu_remove_master(master);
-	if (master->cd_table.cdtab)
+	if (arm_smmu_cdtab_allocated(&master->cd_table))
 		arm_smmu_free_cd_tables(master);
 	kfree(master);
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 681804a3f86bec..8851a7abb5f0f3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -619,15 +619,19 @@ struct arm_smmu_ctx_desc {
 	u16				asid;
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
 	unsigned int			used_ssids;
 	u8				in_ste;
 	u8				s1fmt;
@@ -635,6 +639,12 @@ struct arm_smmu_ctx_desc_cfg {
 	u8				s1cdmax;
 };
 
+static inline bool
+arm_smmu_cdtab_allocated(struct arm_smmu_ctx_desc_cfg *cfg)
+{
+	return cfg->linear.table || cfg->l2.l1tab;
+}
+
 /* True if the cd table has SSIDS > 0 in use. */
 static inline bool arm_smmu_ssids_in_use(struct arm_smmu_ctx_desc_cfg *cd_table)
 {
-- 
2.46.0


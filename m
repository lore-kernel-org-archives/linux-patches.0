Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011046.outbound.protection.outlook.com [40.93.194.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C81A2D97BA;
	Thu, 17 Sep 2026 00:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789604881; cv=fail; b=Yvh0Mki1u1CJKqa6AdnHhKXCshmXOnWAmWrognR9bOBdIVCeGNCj1BOvGk+NcXeJYt6pzG0p0l+yCSWBEJHMTd9+RApCnMY9F3/h30vYXbkTLzHvSjjeYsmR+hMYW7E+4PVYre3EuxQEheV0eamGo1+tXvivRMPh94Wg8gRtQ18=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789604881; c=relaxed/simple;
	bh=ZSL1iGkQOzkIcxnXs6aUh2u9UVg9AE5NU8lPvOb9ikg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ac2kNfQLjGYMuUz5wa8K9oVjNf/Nqj5+x3ESzxXz0be2wiFcuZk2E3tVol/tIis4P4qf8sAqLNkx520JIMyyySAVZYl6b9jyMzuCxWCbVdxjXyRwBkDfr+0lmMypEAR5soq0SaBAdg90HSzeoqrXOEaghdwt1dIIqnj4yNyhgw0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DfDHpci7; arc=fail smtp.client-ip=40.93.194.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DfDHpci7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uPIZYfouwmXarsTeVC51uwxU8vbJnvxHQMHH+ekeGHqjFnOUE+106ozWbwlQMzjep3v43VqP80AGk4E7VMv2ak9gDGcoGMS4t7OP1OJRBOHHH8ElvFAsab2aUyUo7Gkki60ehzj9X7i/JAkLY9NuFHZQyMXId9xmsPiRfv3yDS3xnxbKWplWk3AJF6Cx4evdVNUfpLsZcCcwQypFyYOM36GYXq14YEH8iaFnSi1MPDXGtClIcdFk60jkgVnQ+90cVf9e9agtvIisexy+TL1b3k5e0ngzBrCLbFMbyxoXbhSKnmi5sRYx1yQJj3qvZ4OrKZUBhjDDGNSEy/+Qjd6xug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=opSitjy+dIlW8EzwWQLDMlp3lOjHkk9FGMcwQCXg5QA=;
 b=fCIqBxGnLiKNkvVu8c1+uotO6X8KqhhohOGF+dMDtwSO9HNiapcvLWNRp9JIwJ302Vr0CCi8YOwnzUGO4yJAsyNtB5sd1mu00OWz8RbUTfzWjs62qSNbkVWX4kL7Gya32itvd8OS3y4nFHGqyaSAa4seqgvL/Xv8vDkaaklS1KNIAIjCmivWVmW0IE69tut487Yz9jZwEB+uJy0aHB2+GqGLFcZuP8JB2sFJtAdSmF0zZNDw8ONQ2knCGV6dYcjEymdqBCmwLTBQaFkyGxo6sIcdunmef6n5/B62rb18BjOY9Wg0pYOSR1tn0m0mWLp+561omZhgT1CYipBiXVjm/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=opSitjy+dIlW8EzwWQLDMlp3lOjHkk9FGMcwQCXg5QA=;
 b=DfDHpci7tpn5SeTmdIw6xwLwFSc/kzOUptOUCG7m8LT08w3mqip0FZz+UYfTW8sjP4/sRDfHa5tT0khr3OvcjSr+XKLZmemgTp/SkfdpKdlsjE1c+aWd+bdmnRQAOKLgm9JTY7vW9T0HXPlGCsCxr92jn3OZSjhndd7msUxYjp2PW9pXvGHYDnED6jILPRRDK75jKl90qYP/dVeeQvsc8zpA6RU41RVsyNx+EzaXgk+1IT+Uqd+vZsrRyLxcwfOR7YWjT09uAxuujS8xLI9BfkD99fgmQR1MAQrCsv6elajtYCnn6JnKKvOqSJJ1uCRNDOmMfIq3qGsWzp/qPECGJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV3PR12MB9188.namprd12.prod.outlook.com
 (2603:10b6:408:19b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 00:27:55 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 00:27:55 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: [PATCH v6 3/9] iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
Date: Wed, 16 Sep 2026 21:27:44 -0300
Message-ID: <3-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0012.namprd14.prod.outlook.com
 (2603:10b6:208:23e::17) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV3PR12MB9188:EE_
X-MS-Office365-Filtering-Correlation-Id: 48befd1b-7c4f-4575-14e5-08df145282d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|11063799006|56012099006|22082099003|18002099003|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	3a8RatPIoQdP3iFKdc0toQYkL0zn43cWNLR3BJUOhq3ueTwnnhRKrJcGHFEbpNslLDtVThVH9ejPq73yobMOPiRaJbEn3rzev/KlUuLUYz38FdR/Bxk4jPqWQGqSY6eCkYfcS/1LnwaZpW+1lPWT7afX4ecGqm5xyFBvlmlgC0C+0e4gMz+wGYaYcpXargiKT/ncY1niIWwmxHMvtrYCf+qa/7Eq4gYF3ZqVtCjK2eaCpYIGVCMyLfqld1wGsBXF8P42wj+vzYVpSHG0VrAJwpl21tgr+A75xKD3Pvcm/x+6SbAOhxoTUMuKxCLlU/qmoQPRF78kaDusRzy1GGbfnyuJRC2oxBKsAkdLmpO0DBkrjentucaia6SFQBUCD8zIxTBKcaHPVdhEEQ/hOZwaNNdb2u+gi7zIMhe8mYSpCt2wnSefyEzEk3ggd7tNxa/pVBfi8UWAbo5jJPgc2Sh8rWoHfGcV1N13zxpye4NFnxhbZdzryZYY4uvCvXvbZ2lvMqH6MvNz9BH7slEhooSBifiym+QRin5yBCqEBuGVIs0UGsUNb+Tg6J+WehbPLB2ZQD7EBq9KGW1e8i9RR7g9ghTx/Qe3XFPgwLdGvC/YMGGE8b8Qx4rBr1FoOqjnU/cRHkbGSA60q+V2ecWgIBZX+RbeYF7liIXoh+gwV5gwviEmV/5ddK+CX0Yr7y1RPTfbYnbhzPLJ2RtovBmJOvUUCA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(11063799006)(56012099006)(22082099003)(18002099003)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SaIgoFiqYekCYUC77jeyIQhgonL6ub2gqG56pmOx3nuBPSZJx5q7OUbTEYio?=
 =?us-ascii?Q?M/oPme5WYLC/xNymDNh2n5rCz+TLyuOzj1xNreaB1gW7+TeD3TOk7pvlaJLf?=
 =?us-ascii?Q?ROGspAOqwXHnfWFO9Zgid+HyeiaQGFYOVN9MO2lZaHo3DidbwwHXVd2Ipaig?=
 =?us-ascii?Q?4m2mjCJbZ18LqYhZ928JDvO5rSYvFndYLp17eEPpnJuXxZxzCYlKIdu8xGe/?=
 =?us-ascii?Q?wkdFRV9TfXHL8IAS2Kq+BmX3TLYXtlxdRjcRlJ3XPhawBcg9CMZKeXlloz/v?=
 =?us-ascii?Q?HT+8qo9/1ah/HPVRb27DSCBKvbNkc54XtLlgof8aGViAUspluong0qMqnZlr?=
 =?us-ascii?Q?Z1pnl6XfRKz+hXYVzTQgOPsl3isUqvYOGwghAqKzcylwM7GNKZtEb2WWoX/I?=
 =?us-ascii?Q?oEPT/dl2hLoLjV9DUU1SkEPdDHYXDDnyZE4QzU8WjLbnUxL0R4GJ59K8Xkc3?=
 =?us-ascii?Q?7jVfqsmodb6M/XSJivUuBGGG4H1AyfUPuXwAeZi7ll3vqB/Y/67fWIznbcQv?=
 =?us-ascii?Q?t5/bWuu5DeGT98r6MFt1vH0yhJeVG6p+TD7qNMNe9UwoHNbTxw8GzkFyYb0b?=
 =?us-ascii?Q?uYBEjs5ZeMVP87vJ4BDa1qoiP0PWE1kXLhE00GYloP4Uoo/lNrZi/prW8OHJ?=
 =?us-ascii?Q?PkBjSpVWlcCTm+Ke9hVkzkA4KxFn2HeRAE+dgqarzlKNg5rIDwkxffhe0/y8?=
 =?us-ascii?Q?9KkF7SASjHnplWEFs4zVft7mIoqCZYBjlild+7R4ombpgs8diRM84K0w/pYK?=
 =?us-ascii?Q?XPLkmVoZzxrItZw3CIsI5uik/ZW8I/Uf9hQ3++rUCgPUWHlHJLqxDnv4cj6T?=
 =?us-ascii?Q?1YmXBgrtuhXKUxe94TTvdha/VvoD+ozLLGasW+KfxNguKhJrcbNg3Eam8Mhh?=
 =?us-ascii?Q?s6WFraUsUWUd2fY0SdljiZtqJqa1+mVLXx/25zWg+nYQoR4EttTrWtLwbwF3?=
 =?us-ascii?Q?BPPLNn2HHgSh7nPf+1G3S0SOiRjOgj2WvDbVECSbgBMFxvBjHEh88dKgr/zb?=
 =?us-ascii?Q?HfQqQ7li71mas3yXn7bMSKdZZeupb/w6ggDv/OA5ypO+gYM+fojXaI8G5VQq?=
 =?us-ascii?Q?ynl1nyifSDhdR5XXdShGUvGrMNE+CY6BDkowbW7GbCtJe0BDuCY1IsHsFX4F?=
 =?us-ascii?Q?HRHjYl8+k1YDQq8kc1mdR7OkNNQ6c6TIbHnRTzssHDu6//PqHZWcdlmRqF9u?=
 =?us-ascii?Q?AzobbMTg9ydSrq+8PnDkOO7YYK2qnTlkm/9OQTh0ULG54JsjccUmN+9RLCiM?=
 =?us-ascii?Q?p/UoRZ5TDx1iRxy7bXRJmMiOnnSImjyPORjIp+TL25vljap76PyEv+h63E+P?=
 =?us-ascii?Q?BPz/WvTBjPeFW7ezS2rNj4/6VQprA6RWhY2H6cmM/PGlPIHoATDw5GG/eWa0?=
 =?us-ascii?Q?NzRxfda5i/5ZqzdTKBLrtTk+cg/b4F0+X44b+QEkufTL+Xx3YMyqgwqzW+h/?=
 =?us-ascii?Q?/JdYDKCbpQNsOnIMTLmX+dox3457PNMj3gS9q+jKfy/0QEuWJdtz7rdTjtXk?=
 =?us-ascii?Q?rPLAKzW5+agPSGLijrowpFzd1GgSvOYSrGCG43CrB8NjIR1m/O3ANswPVF05?=
 =?us-ascii?Q?VMUKuwL/cPC/BL4lAUoe6lX8FKnSZo31/DGPTGgStB5bOhDBGVoS7uS8g/Jv?=
 =?us-ascii?Q?4L4xThhDv0kfrfsO6usBD5NbNhP0L8bUTF/Z2j1/xvw4qYThZ/oISOlF15Jp?=
 =?us-ascii?Q?rW3eA3RlZ9s4+bmfiNicocGjPnlenwP1nB3T4udgp3eOHs4x?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48befd1b-7c4f-4575-14e5-08df145282d2
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 00:27:52.5716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IhNYrgAmEVS8t4+sZJJf74RBGuPbQFrkdtZPcEbmRoaQj1gqdvaouiXG1seZSrJN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9188

pgsize is a constant property of the domain, it is the base translation
granule of the page table (4k, 16k, 64k) in log2.

Store it to the struct arm_smmu_domain based on how the page table was
created.

Pass it around in the tlbi.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 29 ++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 10 ++++---
 3 files changed, 19 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index a0c9078646fb55..7acb70d060ec4e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -345,6 +345,7 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	 * ARM_SMMU_FEAT_RANGE_INV is present
 	 */
 	smmu_domain->domain.pgsize_bitmap = PAGE_SIZE;
+	smmu_domain->tgsz_lg2 = PAGE_SHIFT;
 	smmu_domain->stage = ARM_SMMU_DOMAIN_SVA;
 	smmu_domain->smmu = smmu;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 03723bb00de412..6413eb4021ce22 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2463,14 +2463,13 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
 					  struct arm_smmu_cmd *cmd,
-					  struct arm_smmu_tlbi *tlbi,
-					  size_t pgsize)
+					  struct arm_smmu_tlbi *tlbi)
 {
 	size_t inv_range = tlbi->iopte_size;
 	unsigned long iova = tlbi->iova;
 	unsigned long end = iova + tlbi->size;
 	unsigned long num_pages = 0;
-	unsigned int tg = pgsize;
+	u8 tg = tlbi->tgsz_lg2;
 	u64 orig_data0 = cmd->data[0];
 	u8 ttl = 0, tg_enc = 0;
 
@@ -2609,12 +2608,12 @@ static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 	    (inv->smmu->options & ARM_SMMU_OPT_FULL_CONT_RIL)) {
 		if (!arm_smmu_cmdq_batch_add_ril(inv->smmu, cmds, cmd,
 						 tlbi->iova, tlbi->size,
-						 inv->pgsize))
+						 tlbi->tgsz_lg2))
 			goto full_inv;
 		return;
 	}
 
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi, inv->pgsize);
+	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi);
 	return;
 
 full_inv:
@@ -2722,6 +2721,7 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 			       unsigned int granule, bool leaf)
 {
 	struct arm_smmu_tlbi tlbi = {
+		.tgsz_lg2 = smmu_domain->tgsz_lg2,
 		.iova = iova,
 		.size = size,
 		.iopte_size = granule,
@@ -2978,6 +2978,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 		return -ENOMEM;
 
 	smmu_domain->domain.pgsize_bitmap = pgtbl_cfg.pgsize_bitmap;
+	smmu_domain->tgsz_lg2 = __ffs(pgtbl_cfg.pgsize_bitmap);
 	smmu_domain->domain.geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
 	smmu_domain->domain.geometry.force_aperture = true;
 	if (enable_dirty && smmu_domain->stage == ARM_SMMU_DOMAIN_S1)
@@ -3217,15 +3218,13 @@ static void arm_smmu_disable_iopf(struct arm_smmu_master *master,
 
 static struct arm_smmu_inv *
 arm_smmu_master_build_inv(struct arm_smmu_master *master,
-			  enum arm_smmu_inv_type type, u32 id, ioasid_t ssid,
-			  size_t pgsize)
+			  enum arm_smmu_inv_type type, u32 id, ioasid_t ssid)
 {
 	struct arm_smmu_invs *build_invs = master->build_invs;
 	struct arm_smmu_inv *cur, inv = {
 		.smmu = master->smmu,
 		.type = type,
 		.id = id,
-		.pgsize = pgsize,
 	};
 
 	if (WARN_ON(build_invs->num_invs >= build_invs->max_invs))
@@ -3277,28 +3276,24 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 			   ioasid_t ssid, struct arm_smmu_domain *smmu_domain)
 {
 	const bool nesting = smmu_domain->nest_parent;
-	size_t pgsize = 0, i;
+	size_t i;
 
 	iommu_group_mutex_assert(master->dev);
 
 	master->build_invs->num_invs = 0;
 
-	/* Range-based invalidation requires the leaf pgsize for calculation */
-	if (master->smmu->features & ARM_SMMU_FEAT_RANGE_INV)
-		pgsize = __ffs(smmu_domain->domain.pgsize_bitmap);
-
 	switch (smmu_domain->stage) {
 	case ARM_SMMU_DOMAIN_SVA:
 	case ARM_SMMU_DOMAIN_S1:
 		if (!arm_smmu_master_build_inv(master, INV_TYPE_S1_ASID,
 					       smmu_domain->cd.asid,
-					       IOMMU_NO_PASID, pgsize))
+					       IOMMU_NO_PASID))
 			return NULL;
 		break;
 	case ARM_SMMU_DOMAIN_S2:
 		if (!arm_smmu_master_build_inv(master, INV_TYPE_S2_VMID,
 					       smmu_domain->s2_cfg.vmid,
-					       IOMMU_NO_PASID, pgsize))
+					       IOMMU_NO_PASID))
 			return NULL;
 		break;
 	default:
@@ -3310,7 +3305,7 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 	if (nesting) {
 		if (!arm_smmu_master_build_inv(
 			    master, INV_TYPE_S2_VMID_S1_CLEAR,
-			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID, 0))
+			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID))
 			return NULL;
 	}
 
@@ -3321,7 +3316,7 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 		 */
 		if (!arm_smmu_master_build_inv(
 			    master, nesting ? INV_TYPE_ATS_FULL : INV_TYPE_ATS,
-			    master->streams[i].id, ssid, 0))
+			    master->streams[i].id, ssid))
 			return NULL;
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index c7d64156edbba2..f5c794728fe228 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -736,10 +736,9 @@ struct arm_smmu_inv {
 	u8 size_opcode;
 	u8 nsize_opcode;
 	u32 id; /* ASID or VMID or SID */
-	union {
-		size_t pgsize; /* ARM_SMMU_FEAT_RANGE_INV */
-		u32 ssid; /* INV_TYPE_ATS */
-	};
+
+	/* Only used by INV_TYPE_ATS */
+	u32 ssid;
 
 	int users; /* users=0 to mark as a trash to be purged */
 };
@@ -810,6 +809,8 @@ struct arm_smmu_tlbi {
 	size_t size;
 	/* page or block size of the leaf iopte */
 	unsigned int iopte_size;
+	/* Base Translation Granule of the page table */
+	u8 tgsz_lg2;
 	bool has_cont;
 	bool leaf_only;
 };
@@ -1060,6 +1061,7 @@ struct arm_smmu_domain {
 	spinlock_t			devices_lock;
 	bool				enforce_cache_coherency : 1;
 	bool				nest_parent : 1;
+	u8				tgsz_lg2;
 
 	struct mmu_notifier		mmu_notifier;
 };
-- 
2.43.0


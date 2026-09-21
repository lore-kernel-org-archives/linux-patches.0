Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011029.outbound.protection.outlook.com [40.93.194.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FDC3AEF4E;
	Mon, 21 Sep 2026 23:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790034936; cv=fail; b=ZhJyEWTH0WRWQRvZ7tBYoNbu9hWRspyiFNgCWbpbOXqD6P9pELjizMqfy5DR4mIWjRJvjWb/CgGgjnFjz2KvGdr0aORmEna85Sjo4QJl1Lwek5m/DZbFztv2xDNdBG6z+K57n0xN5p4nnwO3Y503ZQFDk0wLZPArVTXwcgBOfT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790034936; c=relaxed/simple;
	bh=mcVpzE6sS3TAwCHJH2xKCMqOEqTKM9PTnbRcB3tfRTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aIxaWuiXNeLYiWe+MjovedZlDk/Ni502wXce6x56fBEqJAx4wgu5mUoiYmQ/DtaOLE1pMTys7UXboSUHKndrWxUI9tn7Vi3aWi7TGVOcD1SdhGfYi8ImJi7dzhGXhsUxWqPKyorj3NnLY9sJ6FXp1Tg5MbD4OzA3qjeV+6N+Ekk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IcvMMC8L; arc=fail smtp.client-ip=40.93.194.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IcvMMC8L"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ojLTnDeZcG2+t2vRhwG1liwGTqdQmMVnkIzXmakE5G/ZvuoYhlyxHavuvkjZ/wqur8fFuAqjKNvz5h88wOkVrz6aRsuAQanArpjo0W2cBie9jqEToZpaYwNRHAni7keGP4PnH6D+2VRNr3fZhYIO10a8G4SCmV69JZBIboDUSJqAp5/0hdN9lZnKjBFUIBpPlgL3bVQBChh03EYMzlzhtEotODevw8oipqxcEkvUGhLTgb0vdfnIgfNAfLJYn53kqX+xonKmwMo/Qf5rtuKLVPEHsEquFiOIQtRno3vpawVcnuWZ3Gikt/nI5liKCm/K6twmn1tkrET5L7wjhJnfIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=STuTOf5SDQBAoJN3l3En4+OC5oEJz4a3K83YHtkLS5M=;
 b=McKgx33VdaWmiicXrVn7bXxw1wkgkCIYF6tMN98pgQs+efdvxtXUAbpG4hOdAtEaaCysZjmKdmTlPGmJXwNWCxJHjYyqu+oTTkpeoLxfz+Ta9QYGHHrW4PLjF/pmFhoGkOm8Wr0URrDB4AKGEe6qe2K5VIqhp5P3foP55tuKW7vjR+9BX3F4GjeWAHRPkD+qpvtTzLAgLBO0tDaZuloDeMeSXdfPEdnFUXr5s7jnoEJ7hzsuDoOZbMSpHpm/lLupTW55tl1w9aNvN6VcAh9ZgLwIZlCfEs2Ms8wvneu2Hdm27bd0popy5os1sk6mn/7fRP0aMlZPCpHLRtW0EBC6wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=STuTOf5SDQBAoJN3l3En4+OC5oEJz4a3K83YHtkLS5M=;
 b=IcvMMC8LLRxMAWutjma8HwSxQnbGUBRQDWn2fWYmaZkdioSE32FekpzktO1xvql4CxIP/Wyc+l/IrMmUzubMI+bLn8xumhC68q0bzAJDQbOy+0p2Jmv5pEVtTcahPhyqbmjugkgS0HhFTpIATq8GbTj3WgMlWvCIEe1stkDaNGrAGghcmDnmgPwpIwX8T08iEn6bT7tSDtWE17YpfgyZmLbEH47mkiA4JSKibxrnuE8210PqAY7WlwL8tZRuuRAjapcrQBYYReiGlSYlWsgjGQeqptr/Sec8pTuXAYJnpt4g3Q5G81ne3mYRWpBHWwfqoIfIGRhMZWBEpgmY7TiPsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by CH0PR12MB8487.namprd12.prod.outlook.com
 (2603:10b6:610:18c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 23:55:22 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 23:55:22 +0000
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
Subject: [PATCH v7 3/9] iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
Date: Mon, 21 Sep 2026 20:55:11 -0300
Message-ID: <3-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA1PR04CA0014.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::20) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 77020f24-4aef-425d-6900-08df183bca9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|10067099003|56012099006|11063799006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	UaGwosqAAJjUvJBmkMH/qv7x8euf634uzbqTw26cscEVaIx7oI8N1DzIuVZQOkIvlYNpimCgHvn/QO1aPPPgTeJyCwkJzs1R9OZQY1CcIoifTsJguTUZUTXLGdEq5bYQK+yZxoeKLhGE22SyJQkwUcprAy3Z0nY1NH28A6lbW82AJgPrnFGuW6cKfCiI7ekkJoF8C3AD5jeciXT0mb/FdJ4yfFI/jes2+SPXjWD/QAVBTq7P6QqQB6p7lG26Kjj2NJaFXQ8hZjIcM5J7bH65GwqM3x+g/W5TE0sKMjjUzfb3YRoBxshQkKDL3Pmerf9TItFKJ7nbGy8br2kn6fmxqqtgrTLSji1dZIdUhskBfGSPZIIqS58CoqMlRhNDB2AnwDt5GDuTLrL/vHMTYbf2jEqTO23O4WnFE0CH7kMLflFXlwmz3rtq2/Ceuc5GBREM/xfJdGxEDf9d+2yCmuBQTSgwQoOW8Iw6GDC7H17U71P78dztrZsriUgZS9g9UnhqznZDYgDsec9YjgC5pMMoiuElyKDkBia1pz42MieoCmVKvHX8aF6e3RCooA3ymMDb1jpm8Cg1y1LcXjTtSnrlhTUzGRAkuOjG84xlNLNgZeU0hXaFBiQtpQZNOJ1VV5Z7wDXuIGUZd7T0VMAZhyhbuKUXsofGIjPVZAjyzl65RWyQnzTXpx3OSeeRjVOip7gmFKwHpsC/7KoLRRDT01q6MQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gvCgZGDV2f8mPmuenAbXn4RoTWC4wnKxCl5OR4kcTKCWnPheqBi4iQ6VTJmV?=
 =?us-ascii?Q?Acd687usvzbVY7TGs7VPtLMmb1aGj9C4yJuuL+EGvb3Npl6T84EG4btl9tgr?=
 =?us-ascii?Q?sdSFTQHFmXgCwU+0S+VDPmESWmhd1a2hX465SU3pqffXbkUG6mtG3CJQBwtk?=
 =?us-ascii?Q?Co8bcv16BqGtyFTF6FIIWZqI1vsAwwO3B1et9unrrurzWb4Y+Z8qUztCe6qH?=
 =?us-ascii?Q?S7OopTdl4hONzTQ444Rpcnh63+yljfad802NMSBOFMRqwEa27EEdxZkHHADC?=
 =?us-ascii?Q?qhFBDCjSpstKr3f5A5WxNn2hIz7jGGPWX6B5KvYMF75wLGhJ0X/ZTbiNHvRC?=
 =?us-ascii?Q?+atmtJb80p5amwoFzUAo31uBLBDWS6zIbsL55VTz/lHw58wr7cHuTGxOfMIc?=
 =?us-ascii?Q?M3SBAro/V8/V5EWiCWwzubf7kZLWelOgnfFIAA5vfuqWEiF03RISvdF3fTKg?=
 =?us-ascii?Q?zczTNprT5ulHQ0LWdbO4XLOpUYBmE54Y1AFXiA68TSy+fUXjPPKbXOHMUfNs?=
 =?us-ascii?Q?pJShFlt1JaTrOq1jDMjW/pB32wGOuTgfkZsCZB/0I6635/K2bbM7CCMQkQB1?=
 =?us-ascii?Q?TTmZkAijC29Xe1tSx63SpCAYniHbXgun0/RWVqZ+x9SYoR/vCBF7VwaaP5Ib?=
 =?us-ascii?Q?6NHj7C/SYip21iNPpv4WlIVnuvVKb3+31U5Wcjw700Kk8qVcQ8ZE2dztNDen?=
 =?us-ascii?Q?j+UKku2aM5Ub9nYhjA4/5y0ULFxxt/ajm/BZK3w6e3N/gXWVb5EkXoCucApW?=
 =?us-ascii?Q?wC/fLkTgCSVe2u/60Ssr5uyNpFVQTU0/X96PHBDtkR9UY5IQKBzxqOyy1mOi?=
 =?us-ascii?Q?cNIn5o27NQ9/l2bw1TZsX3FBtn922+cFdNz5P/2+dpy/QkU3Gmrtnwzg8r4w?=
 =?us-ascii?Q?2aPYgzWGYabD2z3YyYmGjI4n/MF5jDtgOL26oVqKPGJTK4YGfVgz1VoRZaHe?=
 =?us-ascii?Q?n+o7nJwVsa+o65Eh0TtbJc8qSWfhQwKFJenemNsdyak8K9FipVp88F9ziRby?=
 =?us-ascii?Q?SnXm7bWai3slWpPbX9fuRTDxg57o78qUCdKoqEBxa79TcQf3lINnc5/oYk7V?=
 =?us-ascii?Q?jHU3tJ47XWvpCkK7wlLL7cy8h5tZq8Zi25SMIXNGNK0SV9QZknTWpqaj+Skh?=
 =?us-ascii?Q?J1lqF7Z7am/nqih/vH6KeAsHlYsRO5tR/Ou1UDdeBJsEqznafyoRGshyKrXC?=
 =?us-ascii?Q?YD/HbjBf1y2mgYMzgmG/oe0cGrM7ZsuRauksTRfpQYlEVYsE6SKy8f6cScou?=
 =?us-ascii?Q?IbYcinLqHG5qlzFdawRGcjOkzmYl07/OG+TsVQeE/kQ866iJdolsxkw+Hfdr?=
 =?us-ascii?Q?zklITNeyyrMDcUpq2dRuN9Fogsf8LnUXART+PWrJr4nPHb0UMCCNTVKAsoQ2?=
 =?us-ascii?Q?NJpLD5NAIjuBYoAKQ0uGb/BSCHHxkqBcRnJ86svgLn9v9tdp2u47B+DzKtFI?=
 =?us-ascii?Q?z+oBRJRY9u9Kl9ZxoGJOA30JelqR3ix/QtzHsFZQwhA7tBhx+6cTFeTrmm23?=
 =?us-ascii?Q?P8WIKFzk19yvx3f8GbhIrQ6kzEU9YOFfrmwL5J5tgPOcR5oV0KiBq+vWoT9o?=
 =?us-ascii?Q?osYHQ3XcHBQCK/JgROu3FNOT6V91jkBssQbF4JDJXtqIlQ1f0+GhK0JoxJ5W?=
 =?us-ascii?Q?rlHyodOmSXLyyM5EutbCtC8TZy+G8rIa5TPUwqwrvB3YD4mCaxMPm+x3OsrE?=
 =?us-ascii?Q?vffft5UlzAfd1gKlfN8XNbpm94YHi0AkUWtWsj9u5mky85gc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77020f24-4aef-425d-6900-08df183bca9a
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 23:55:19.2209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2z3oNUW6DwAOJB0FEo/RsGxVVh68yzV3oQyszgrnR3VE9taCiUqFVD/di2SHopMx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

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
index 3f50298a1c14ca..2f76f649dcf1a5 100644
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
index b2244d77d245d1..afc0f68728609d 100644
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
 
@@ -2610,12 +2609,12 @@ static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 	    (inv->smmu->options & ARM_SMMU_OPT_FULL_CONT_RANGE_INV)) {
 		if (!arm_smmu_cmdq_batch_add_range_inv(inv->smmu, cmds, cmd,
 						       tlbi->iova, tlbi->size,
-						       inv->pgsize))
+						       tlbi->tgsz_lg2))
 			goto full_inv;
 		return;
 	}
 
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi, inv->pgsize);
+	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi);
 	return;
 
 full_inv:
@@ -2723,6 +2722,7 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 			       unsigned int granule, bool leaf)
 {
 	struct arm_smmu_tlbi tlbi = {
+		.tgsz_lg2 = smmu_domain->tgsz_lg2,
 		.iova = iova,
 		.size = size,
 		.iopte_size = granule,
@@ -2979,6 +2979,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 		return -ENOMEM;
 
 	smmu_domain->domain.pgsize_bitmap = pgtbl_cfg.pgsize_bitmap;
+	smmu_domain->tgsz_lg2 = __ffs(pgtbl_cfg.pgsize_bitmap);
 	smmu_domain->domain.geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
 	smmu_domain->domain.geometry.force_aperture = true;
 	if (enable_dirty && smmu_domain->stage == ARM_SMMU_DOMAIN_S1)
@@ -3218,15 +3219,13 @@ static void arm_smmu_disable_iopf(struct arm_smmu_master *master,
 
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
@@ -3278,28 +3277,24 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
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
@@ -3311,7 +3306,7 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 	if (nesting) {
 		if (!arm_smmu_master_build_inv(
 			    master, INV_TYPE_S2_VMID_S1_CLEAR,
-			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID, 0))
+			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID))
 			return NULL;
 	}
 
@@ -3322,7 +3317,7 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 		 */
 		if (!arm_smmu_master_build_inv(
 			    master, nesting ? INV_TYPE_ATS_FULL : INV_TYPE_ATS,
-			    master->streams[i].id, ssid, 0))
+			    master->streams[i].id, ssid))
 			return NULL;
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index dc2d340c83f858..5c1c3ccb5fff0b 100644
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
@@ -1063,6 +1064,7 @@ struct arm_smmu_domain {
 	spinlock_t			devices_lock;
 	bool				enforce_cache_coherency : 1;
 	bool				nest_parent : 1;
+	u8				tgsz_lg2;
 
 	struct mmu_notifier		mmu_notifier;
 };
-- 
2.43.0


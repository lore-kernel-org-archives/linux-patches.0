Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011045.outbound.protection.outlook.com [40.93.194.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFEA3CFF49;
	Wed,  9 Sep 2026 15:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788969450; cv=fail; b=VjNe6qH26xaEw8dysU6G8wYdtmzA2r2IXgsU2hrUST1dpa6KaCQPdp5SSnpoeSSMhgSpgHNeP3M4L4RGQQt8g5mlP5zgpDCjWY/ur9iStFCev5awjjOBf179vBE5DYNfSRTniOhIKd5yAYABWVPXfhLqqgDn3JpXwaYFtzBWZgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788969450; c=relaxed/simple;
	bh=PrHpJLQM4U2dov87fOQGGzpCDySkQ7j2PIW1v2jh8Ts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XScwpQu10jwGAEnpVXNT8emEaobXjMbzChyBOme/bbL2mQGzaOS6TbfnuegVWFA/uEJd7mpvzfStuuFMYJbuQ8kTvH6esbDJqCEzQPEG/cMVvpk/AAWPOWnoNUDbbeouljdikXDKN0+JeUhSjCjLdKJAkP+bPGvOKtiSS46tC+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PDydhBNR; arc=fail smtp.client-ip=40.93.194.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PDydhBNR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z6Lell5Xt6HpI2EzVrx3ZSM3HuybqUcR1eABzmhg5yYbH0aryVgRFb9du+czia6PzKTkNXZ24hiRI4Xic7/21RFThagHr6haF+pxbWSPZ1W1DSlZSDNOWoiDQEQylDaA9VLuUEGjIen+MtBpaDfid0qVRC1BImilECBHbYhdmjlO9CTtRbXmuNtw0btHI2l9UZ8bNkN5WrAH9W9Hyh1b8g3noe9IahO2FK6wfAnWaVX3Q+hyUF1XpFILpomM+v9e50qP1EoS21Sop7ILta9FSgQsV7zTs1ag6/Cj57lJ8uuLJROkHeUdp0a8VSjjYrrH7+RRkzmhMPQ/E7iy1OaQBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EdD+6dJeH67SQb2ed6lp7JQXFigAhkuROddzTONiDuI=;
 b=XdZQEPk3C8sSqJ/16QtUHQ6QryjidqulD0Ov2ZbI02lYduKhpm1N1X2mdxCy9zmlzcebTcHP16aiJjowDkirHpKb21EC+50eJczHJmgGNiL1U2026esE0yRxC3i50TzwdGuOwPYsW+GnfCplHReMNnPY8d6vugl4Gw2YY5uO9S8uwSi2HjWewD8q4PPL359+VVos06Vqwye7AeIJmPvXp2h6KQsG53GV8CMdfzheIlXYI3hHCtXNBPXeENkpmUgxXXUFhTnDVGZKHV3fIGGLRf21tFCDsAISMw8pOfbxB5SNLWjBbg2Ub5lWb6U15/Xua/r+xdwl3Oq9m+9p42A+RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EdD+6dJeH67SQb2ed6lp7JQXFigAhkuROddzTONiDuI=;
 b=PDydhBNRJhwIBkUQ1GOi42d0BOYoPtdGZ8s3ieySd3U1a6l14vi1CogUDHKMYjb8TcW8gt2YofSg6vi7gPdhfIr88ZhlICBVUmFfwvyTzmJeDhp3XIG1baKXFicXCN20J0Ma0rU/Kn5h16WXWICNkOUG5uDFixKrYFHgmJYFaxWgyK6scUusKuKEUQeu8g0xIfRxDy/++KP0w4aYCWtEOlZZ18hswGbjWeg8NGsMSomUu6W1l56F7GmgYeec2D4C1KbjYw/EIYTWAexOv69/muAnzSa0rak8EvGtRp4PWbCPaxgjjvTwdcg3w6p6S2eXXL9HuWBGdDYOBSNH6nY1HA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB6887.namprd12.prod.outlook.com (2603:10b6:806:261::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Wed, 9 Sep 2026
 15:57:22 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0406.007; Wed, 9 Sep 2026
 15:57:22 +0000
Date: Wed, 9 Sep 2026 12:57:21 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v5 8/9] iommu/arm-smmu-v3: Change how the tlbi describes
 the invalidation
Message-ID: <20260909155721.GA4121847@nvidia.com>
References: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
 <8-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
 <ap7NcebXzWC38VVo@google.com>
 <20260907153429.GB4157646@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907153429.GB4157646@nvidia.com>
X-ClientProxiedBy: YT4P288CA0024.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::25) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB6887:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f51f949-862f-4d25-b469-08df0e8b08c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|22082099003|18002099003|11063799006|4143699003|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	sgl8Fu3ZqbgQ/9MQj3/70MenLlY2h3g3cpbqOCVCGvoO5HQykaawsvu6ArFXqUhVLSk2yVSs0BXIOcvqczAzw0qpZ+FEfUuHWVoT7MVOeTaFQjJf2B81PNwvxIKdhgC00l3aG79jXWOZmW8VI3aNXGDg0seTUzavu54cRMw7e3GsYD/jFhT/6FBTWdXlcz/SG92mkhDAma5NNvBABar2VEw+vB+WBBrmut9Ts8RSyaoFHGmZqRcDkTHtazeXcPHQiUgE8kShpSc6XjbYDDM1SmzItLk5UQ4Bgu8+mgGROztv2SRBQIKxCobbqZYkhwnijp4GLywFrmNC451NEwW3vW+YOkFzcCvK0W+6S+uiun7D6VDMLoXZl194Grie4sBlkp0mpfbj6jrXEhrpEcXINC1xU2grDilL/ArrNsnqVQcAGc+N7Tn1HAbRH6oqhiJaHGaDfj49S1mlsC/m7gPQb82ZX3q7MgZBxGvlZjsdXd3hcRRUMsbNuz+qc1JWffPqyoKGQNky+9Ey8GtLhNRYRkX0fEdZCcaWJkMukfs6hGgD94zSAo4VC+agnlMAn8qWLLbm7usiLAw3D0fYUROTgzfx1tE7uitkgBgyfM8HCvHq4opwkfKN1zfWDZY+Fpu7bkqW10vi0/qXB+NTVnHjuAOHK9zrG7nlxyNTOB0M4ew=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6khMfdo8zAiU4AnimlRp1Y3YUjuV70vrbUeSlMlE/72yEualIPFJbAhsiFuK?=
 =?us-ascii?Q?BrSbeYmGMvf647qdc4YBLxP7VduAVdWJRGeyWHE9bx2WbwYT2a8RN7op1+bl?=
 =?us-ascii?Q?BPG2kTBHnTTXs+0+aGM5czo/CrKXVlRbTIwtwHYaVcEcAnrQfZbqg+k/iUJ3?=
 =?us-ascii?Q?m5YMs/DowXZbpIZAUTYgv8GC+EvScHA5cvRjzRHZ9apDKZ75zSRIvxp5B6qg?=
 =?us-ascii?Q?VxJ1il3CJ3hNbMf7GvBJmwhCm3qtQkYOAat5x0o0Ts9gVOLG2TcTyLImDQjs?=
 =?us-ascii?Q?Zm0hACtCNFxF6LCVlCVWARZ5deU0Z8Bf7xbtqo36h920BEm2ThVJoKwN6Nup?=
 =?us-ascii?Q?eqn/oA2Qk+vDsvfl2TdpSQ0IaU+tyrQNHhQ8LvgomPlOF5if8X3p+S7CARAr?=
 =?us-ascii?Q?whkwTwgDaHOw/qR/7sYUNYHeRUUIB3pfZbtQmLtSLeL7Q25roXCDiNJq/21U?=
 =?us-ascii?Q?/tFncoM6zli7fmEA8xZOOiaHXXXkCLENthHYwKPvTSIPGC0qF+F1iao20M1M?=
 =?us-ascii?Q?xhSHsyL8fZGssTR2im96Bm2Xdt2LrtAv/OIw6Oxtt/zUFvwdTfTqTWzqHNMy?=
 =?us-ascii?Q?EWRoFKnM6a+72lln7Sgkse5WLcbZ/opN+c0GNqo9aUSONflOhSlQkMvEiYO9?=
 =?us-ascii?Q?HAqXNpJx7iyejEz05YrAT0FVulFw6T+gSa9HkSfujW6dvbiEk2mjZk1GKEuP?=
 =?us-ascii?Q?zc7tILKXTejzNZdRdy4MTF4u5pip/Go7lI6CVc9X1GnoruApCqXbaw8SyQVh?=
 =?us-ascii?Q?A/Xw8E9yPOH5oePGpJvJSky4UlEFH7ZXBl5p7usOH1Fzuj4QUVqZZv7mEy30?=
 =?us-ascii?Q?mhavRgR5j+JOoxMRTXol08+NbQqsYKBMhJv2Qu0WYd51uJ717ZBvyEfxo8/P?=
 =?us-ascii?Q?DFHTnc2fE4A4/IXv9ftThnBZYTsn4ZDBKNXSnGj915zLX9/YqN+W/+cclEgu?=
 =?us-ascii?Q?7dilbR+fkh129dqBVcxjhzBFgLCaPjs8uIrdY/h4SwYAPiy+EDHQsSLXbSN0?=
 =?us-ascii?Q?9QyjqCNuOYTmrglJuqlm7xSrNp3hIJQqvpbkiNg+4By9qY8x/7fQ1rqiTWVS?=
 =?us-ascii?Q?hDV4N2tnTRsBzPI/lS5xANfxajVpfbvsoZGqmniDHrowNb8Ccb4FQiAaYXwK?=
 =?us-ascii?Q?jtnR91ZJzEZmLYCnx9cN2xwBiwbOm7ZG12Nvb1H9X0xXqCYuvwuaK1rUdWtK?=
 =?us-ascii?Q?tNMRuy/b56coUiorXuhHazLXnIFSGj4gLF+QI4yV9TxccRrcbrc2UengHKT/?=
 =?us-ascii?Q?nadpv/d58T9j+Wl3OXBatnI0+GvC6EZxqaLrg58YBhHiRYbG+PEroz36ncOc?=
 =?us-ascii?Q?yRwWiHwVnthf06hsZY2yHzZKeIw3Oo2w34ExfysDJg2CpmNaHAYyGn87K4EH?=
 =?us-ascii?Q?54CFdmLOM9qKe/Zl0tFz5QLnwfbEIjTTMvK7+0en2tIWcpq66Xyki+TcV1NX?=
 =?us-ascii?Q?K8LteGhNKDDljsz7nQB/BaYNe9D1tyPOD6pOC2GhN9uLnCdIERKs6mg9a1zD?=
 =?us-ascii?Q?QTrQkG743cnRHh7G1OuftBnPjUsvR5Gnj4BcaR+x5+pgypc6hG9xoGiMAu/P?=
 =?us-ascii?Q?Kj7FueDR9jdbEerDkiIFvOVT1cdHzVToLebyL9A7bXrQz2RL7mehctxN5BSW?=
 =?us-ascii?Q?t6y14ONxm0Frr50OFyvYufNoWSz6oPe1h0M/6JM7gqUz68DDHqD8Rz4x1sAg?=
 =?us-ascii?Q?gB/xei4vdfDXAMU/kGm1XqVrVLbmyI67xoKrtcbNowRIcn/w?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f51f949-862f-4d25-b469-08df0e8b08c8
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 15:57:22.2889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lsrYmzQw1aap4HgHGHU263uDysNLi6JGa6sT/S+UTISBRu6bQjWnf7+Bmp2eJMdc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6887

On Mon, Sep 07, 2026 at 12:34:29PM -0300, Jason Gunthorpe wrote:

> > > +	tlbi.leaf_levels_bitmap = BIT((ilog2(gather->pgsize) - tg) / (tg - 3));
> > 
> > Having some page table macros would be helpful (and in other places in
> > this patch)
> 
> At least this one gets deleted in the next series, so I left it like
> this deliberately. Was there something else you saw that had
> duplication?

I ended up with this:

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 07ba4e7910ab84..fc9622cdbac808 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -155,7 +155,7 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 		 */
 		.table_levels_bitmap = 0xfe,
 	};
-	u8 pmd_lg2sz = (tgsz_lg2 - 3) * 1 + tgsz_lg2;
+	u8 pmd_lg2sz = arm_smmu_pt_level_to_lg2sz(tgsz_lg2, 1);
 
 	/*
 	 * If the size is small then we can infer the invalidation is PTE only
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 2a159be751891e..8dd5d30c569771 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2485,7 +2485,7 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 static bool arm_smmu_ttl_addr_aligned(u64 address, unsigned int tg,
 				      unsigned int ttl)
 {
-	unsigned int pgsz_lg2 = (tg - 3) * (3 - ttl) + tg;
+	unsigned int pgsz_lg2 = arm_smmu_pt_level_to_lg2sz(tg, 3 - ttl);
 
 	return !(address & GENMASK_U64(pgsz_lg2 - 1, 0));
 }
@@ -2497,6 +2497,16 @@ struct arm_smmu_ril_range {
 	unsigned int scale;
 };
 
+static unsigned int arm_smmu_ril_calc_scale(u64 num_tg)
+{
+	return fls64((num_tg - 1) / (CMDQ_TLBI_RANGE_NUM_MAX + 1));
+}
+
+static u64 arm_smmu_ril_calc_num(u64 num_tg, unsigned int scale)
+{
+	return DIV_ROUND_UP_ULL(num_tg, 1ULL << scale);
+}
+
 /*
  * Initialize the smallest RIL covering num_tg and ending at last_tg.
  */
@@ -2507,8 +2517,8 @@ static struct arm_smmu_ril_range arm_smmu_ril_init_end(u64 last_tg, u64 num_tg)
 	if (!num_tg)
 		return ril;
 
-	ril.scale = fls64((num_tg - 1) / 32);
-	ril.num = DIV_ROUND_UP_ULL(num_tg, 1ULL << ril.scale);
+	ril.scale = arm_smmu_ril_calc_scale(num_tg);
+	ril.num = arm_smmu_ril_calc_num(num_tg, ril.scale);
 	ril.start_tg = last_tg - ((ril.num << ril.scale) - 1);
 	return ril;
 }
@@ -2654,7 +2664,7 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 	 * Unlike other IOMMUs the spec has no alignment requirement on the
 	 * address beyond alignment to tg (so long as TTL=0).
 	 */
-	first.scale = fls64((num_tg - 1) / 32);
+	first.scale = arm_smmu_ril_calc_scale(num_tg);
 	if (first.scale > scale_max) {
 		/* Range too large for a single command do full invalidation */
 		tlbi->range.use_full_inv = true;
@@ -2666,7 +2676,7 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 		 * Produce a single invalidation by rounding up and disabling
 		 * the trailer.
 		 */
-		first.num = DIV_ROUND_UP_ULL(num_tg, 1ULL << first.scale);
+		first.num = arm_smmu_ril_calc_num(num_tg, first.scale);
 		trail.num = 0;
 	} else {
 		/*
@@ -2694,11 +2704,10 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 static u8 arm_smmu_tlbi_calc_stride(struct arm_smmu_tlbi *tlbi)
 {
 	u8 combined = tlbi->table_levels_bitmap | tlbi->leaf_levels_bitmap;
-	u8 tg_szlg2 = tlbi->tgsz_lg2;
 
 	if (WARN_ON(!combined))
 		return U8_MAX;
-	return (tg_szlg2 - 3) * __ffs(combined) + tg_szlg2;
+	return arm_smmu_pt_level_to_lg2sz(tlbi->tgsz_lg2, __ffs(combined));
 }
 
 /*
@@ -2972,7 +2981,8 @@ static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
 		.start = iova,
 		.last = iova + size - 1,
 	};
-	u8 table_levels = BIT((ilog2(size) - tgsz_lg2) / (tgsz_lg2 - 3));
+	u8 table_levels =
+		BIT(arm_smmu_pt_lg2sz_to_level(tgsz_lg2, ilog2(size)));
 
 	tlbi.table_levels_bitmap = table_levels;
 	tlbi.leaf_levels_bitmap = table_levels - 1;
@@ -4247,10 +4257,12 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
 }
 
 /*
- * Called by io-pgtable-arm.c for each run of same pgsize leaf only
- * invalidation. If it has to change to a different leaf level then it flushes
- * the gather and starts a fresh one. Thus this always targets only a single
- * leaf level.
+ * io-pgtable-arm.c calls this function either under
+ * arm_smmu_tlb_inv_page_nosync() or via the normal iommu code to flush the
+ * gather. Due to how iommu_iotlb_gather_add_page() works the gather will end up
+ * with a single uniform pgsize leaf. If it has to change to a different leaf
+ * level then it flushes the gather and starts a fresh one. Thus this always
+ * targets only a single leaf level.
  */
 static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
 				struct iommu_iotlb_gather *gather)
@@ -4266,7 +4278,8 @@ static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
 	if (WARN_ON(gather->pgsize < BIT(tg)))
 		return;
 
-	tlbi.leaf_levels_bitmap = BIT((ilog2(gather->pgsize) - tg) / (tg - 3));
+	tlbi.leaf_levels_bitmap =
+		BIT(arm_smmu_pt_lg2sz_to_level(tg, ilog2(gather->pgsize)));
 
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 8b251a188810c9..70d732a96be27f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -810,12 +810,24 @@ static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
 	return new_invs;
 }
 
+/* Generic page-table level 0 is the leaf-only level. */
+static inline unsigned int arm_smmu_pt_level_to_lg2sz(unsigned int tgsz_lg2,
+						      unsigned int level)
+{
+	return tgsz_lg2 + (tgsz_lg2 - ilog2(sizeof(u64))) * level;
+}
+
+static inline unsigned int arm_smmu_pt_lg2sz_to_level(unsigned int tgsz_lg2,
+						      unsigned int lg2sz)
+{
+	return (lg2sz - tgsz_lg2) / (tgsz_lg2 - ilog2(sizeof(u64)));
+}
+
 struct arm_smmu_tlbi {
 	unsigned long start;
 	unsigned long last;
 	/* Base Translation Granule of the page table */
 	u8 tgsz_lg2;
-	bool leaf_only;
 	/*
 	 * Level bitmaps use iommupt numbering: bit 0 is the leaf-only level
 	 * (ARM level 3), bit 1 is the next level up (ARM level 2), etc. These

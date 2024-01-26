Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2089.outbound.protection.outlook.com [40.107.237.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AE820B27;
	Fri, 26 Jan 2024 18:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292953; cv=fail; b=s/wfPH9/YMEU4seTWbIPpLAAeqlBMtlqqHKS5tlQzbkgfl2P0oU/aXWFGIHlOTfFEH0ZwYVojbIL1I3FO+to+9CJud3e4Ppny9hVR6RmEQiBoNlnQs0+kHZdZX1mX/smKuKPzb+IHifvOj7KVYHvYriOgHhPE3LycuoUbaGhoIk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292953; c=relaxed/simple;
	bh=BAK7pwvWXQ6gbZCCrRkbdMxWTCflL014Rivm1cHi0ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qAnTgfH7Uh+C5qoBemRfOMbX/DtvaO3Av+qag3OLZVej1wL9fBbzOWcVRr8PLTExOKrwG83z0mtZcmsvdUHtm01cMLcHZmXaM5A1g4DqFyePrW9SdiQlHUBxTXu58n7x8GwtvROG99uxe6+9i0skAjHoyHQ0Z9gOpouqUWgDi5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qb5d3q8D; arc=fail smtp.client-ip=40.107.237.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qb5d3q8D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2QNb0nGSZTHgvw1RUWnx6cF2VKDrOxNBMGVJlExzUcwWNyLNDzLSMtFujT530/oRcVJ9E3VXRReXy5Pc5N+J5g50q/ASxc25N+6qWZsHImWH6fXuRzlQXRJ2T8LVDfhWBk9Ji6yOr4rHt9pXJ6Pk/2thLrlLpLDodmHjs/JLME3WcFNcnpfcS4COuCd1TlFgM+bWdkwe71GByGICL2NULrWaXmpnNud/jc9jBnQP9XcFZyhSRkn+W1YWMIdv3uLnhCgeSqFYPWvc4loXyUI35AgfD6MLdAdiqiMU62HyMz/aoOEdEOjaKNnVKfr1BOwolYmvS2yje4558S4PcnYAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=65M9v5P1VRdzLfzdUpvtgeegfolb9V8k6j+NugzubhA=;
 b=LG+UjxGs11+FRNp57VBBMkW8eqyoORohk0HKn/EzWQ4ssbUnYtkEjyb4Dpx+OPLqaWVVuE7Z48zwBrnDDs00auSAoW5fliqtQGq+ezSrKZn+p9ikGeRzSitaB1wIL2Or0ZgYNUy39folvVQLaC0CsscuCMAQl6/glzJLicdEXeIfoyXiyfkKhoPbTNE3JfTxOq1Q6yyNFMr9hIRNkuTyrE7wCFzyREj0DBOinh/XI5Cv3wwS94OnwXwM29ILwGDF5+/OhHQKnGKF9OAGbw0jc8YaJ3hOWS1H/RLCrdRSnjoqgi05GqUs3DabyQ9nCI+z3AAktyC0li7kDOIpALZIhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=65M9v5P1VRdzLfzdUpvtgeegfolb9V8k6j+NugzubhA=;
 b=qb5d3q8DHFqJlkdAx8Qn8yczTJGvp0vFnRsbzFHnLqQi7MoRZTA0Kn1uIeB0vg+DA8wo10KNEALCM07wkvaeBsfBs0zRD6Q2VJoh4fewfxlD8StfFCyT/4/sAEy+6krh2Hd9ticSRlUXLP6xzgVSSQMlICDCNAsZHWtZGt3MteWUa20nzhOTKJCjqzlmhScBTQc6FQQYV8CutCVUNDSB4974xTW1+5O2980XFjuxtXIpzRYzPP57N0DIRLcJaeNHuF6nU6c5k5uXkFSFkRLUak0LPNgEPNSOQ4seJmlVc4IfYRylDRX3WKMxsYbuW+v9o8bo8OpXfM5ojzXvTfumVQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5186.namprd12.prod.outlook.com (2603:10b6:610:b9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.28; Fri, 26 Jan
 2024 18:15:43 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Fri, 26 Jan 2024
 18:15:43 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v4 07/27] iommu/arm-smmu-v3: Move the CD generation for S1 domains into a function
Date: Fri, 26 Jan 2024 14:15:09 -0400
Message-ID: <7-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0019.namprd11.prod.outlook.com
 (2603:10b6:806:6e::24) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5186:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e78e482-7dc2-467f-2de1-08dc1e9aca29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ThkCFLFtSbV6qPV+0y1Pw5Ger/4Kc/TjL2rgOpewGCiuZjyvYd1BWppbcNfWxBeBuE6xYsNXuOw71g474EzBqrAavQixlOliPTU/Ff+GrHEjaHuYRbcnZPd8Du/+NKE2uQoTROcueeaatuGejOwYzemCKGmJeww92XZyEpsHJRm/XOD30LMM/tX56L8lUFG7IT9s2xd5b/Nu+bH6CP3p3FAtXH9ghDLlRuU3sNw1a/+3fbu1KYiFtEkTkopHCRUYI+mvJbXFx5zWYAC9XK3EhjBxijL/WVo42aFshRK26V3LS3oVsZpIf1vOWe5Aaiqf1H7ghDvwVEsEvyGMZkyiFC3S0FZO14xPLL1phkErUqSt9v3c/kt+DjDPhStXKJd8iiGMD6QtO/8i54Ie/vYhMHAz77Fa8+Mh4q+fa+sVeVFtv9ycPWfGT3P1ovKyN6jDcPpRN9WupmTbqoyJFN30g7akOgrTcNawE6fNxd1/IxcYib4YBrTOOWjSPx8KLLtBi7a5a6kPIepVhDBrtr/wASUoEEVBhVFLLroCA8WSghu4G0k8DudeB6tegNorVMI23rm4mY2qIgXcbRY9/jbz9qOVAmrifY5LmSIgPk6QHbVCfJbOpGtbZX2C9dAG6dj3dHWUmITIJGhzMQ08qQ85Ow==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(346002)(366004)(396003)(376002)(230922051799003)(186009)(64100799003)(451199024)(1800799012)(83380400001)(36756003)(86362001)(8936002)(8676002)(4326008)(5660300002)(26005)(2616005)(38100700002)(316002)(66946007)(54906003)(110136005)(66556008)(2906002)(7416002)(41300700001)(6506007)(66476007)(6512007)(6486002)(6666004)(478600001)(4216001)(473944003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2mwG3RXu6LVoW40fYeo5jOVSDZ5q0nI742XOFEJEfeSUYVamPU3Ux1kkyURx?=
 =?us-ascii?Q?HjjbICLghGKmtAbny9s3ltDPl8cflslMMJK7MwpKynx77SU1dpR5zWbfUGpM?=
 =?us-ascii?Q?iq0iHAsL1WhF71Z3DXKYzQFJ5E8qMN8Z/xmoM4ge64hj8SHiB2W+5uA535Ue?=
 =?us-ascii?Q?00+asO6AHaFcgbQrA/a16Fs7MS1LWqtMXasvRfOrTchwiqpUjg0sdFK4PBVn?=
 =?us-ascii?Q?b9aw4q2PEPBoXah4Sjj+dAzgJ99Mfn0L6LR2GIWUUKOQ+8ODEYCydvAjyu+v?=
 =?us-ascii?Q?3DevFvoldUBW/rXazI29FUXz8hg/LwOZmOiXmUXjHgieDQid0krSbtF4haUl?=
 =?us-ascii?Q?1Uds0qPT6qtWGrDWVGE71Z8ELAt3Xs19p0JbBR43TqtOYD6maw5vLEsODqde?=
 =?us-ascii?Q?L0y2/c3E8mBNjAgJL7tgeEAYc6f0jv+hK2BqH5BYLULJ8qOL9I4sVfmd4Q9t?=
 =?us-ascii?Q?fJ8g5p+xxWmoVrcHejyuspGFj2qSX3MeogsL5p0vF3QSuXLdXvxnykHUvJ7X?=
 =?us-ascii?Q?icc0NubPksK70O6zDBJ45AeTy4j9q/aWh4gVV23J4xMswEzL62h1H+lKehHg?=
 =?us-ascii?Q?yoCId6gRCoF/CCFBmBcmBwvZPp1qFsK//59ZjfbznpBT0q5HwEier4Oi/UUE?=
 =?us-ascii?Q?h5gk28rahtxtdwpTvn69Thj19FfuRP+OKYh07+eqsWulbxxj57YeTswVfGrQ?=
 =?us-ascii?Q?M05PG2ZxSZSRIu+f3mj4gKrlEs523oSGKxWmSN//lmgFHnH0DUGlk768phU7?=
 =?us-ascii?Q?aWINJwW/3R1hdrzEDIm4xxJIhF/VHiTxLN+ZkAbXHQTnoAzWQLtlcysTZfH5?=
 =?us-ascii?Q?HofDalkhRHn7ue3mKDjtD3v0a9IvIFKXFzSXcS6UcmVy8LKoJSixQBFUmWkF?=
 =?us-ascii?Q?NYr8eS6Ga3+hghG2PEVJspfau8/msoBcCFXv2yCji2b8HIP3caqcA+Exp7RQ?=
 =?us-ascii?Q?Pi308WrJs2+HnboBLZYmy49w7l1J283sayL5NAm5GFXHF+wFtj3k08igEqJX?=
 =?us-ascii?Q?L6O+2S+yrJSzjd6mfYVkxhduSbb4648mkB/J0xBDfVrI+IiBsKWyJo9AgvQH?=
 =?us-ascii?Q?UUagXFbq0ByRPV6qiqebf1yM53y8w0+F6UIySfVoUfigu1sol8F/2Uy5Q/qk?=
 =?us-ascii?Q?gWqTbBsoYfk+GCn0vQzoUi4ShospRjpuTkBzVSfqhg571asl3Pj+cgXrVpjL?=
 =?us-ascii?Q?ihQ0mgEzYdS1YdxRuuL4cJ4J0dbgitVvfyj2t/jFKJ9ocph6NTIcwsgj0X14?=
 =?us-ascii?Q?apQH/OfNzcn8VQ+gjstEC00kR7Hdo4QfXhaYCfzC6mo2EyjWg1B/JqIf6IFZ?=
 =?us-ascii?Q?zkxY0hmYZRfizHJI2kI05QCY9utOZZ4A/cMs8UkRaqpqFQSLb70kQowwwuUD?=
 =?us-ascii?Q?lvi5TDXk+TYY0Hdt/zIIadzSzQlsj2iny7etXZzCZgTBNk/8Kci0jA7l7SxV?=
 =?us-ascii?Q?2mzqa+thqaJHS6dGiIjAdzP7PEX8w4WP7MVbR1prdFyCAUdr+WUe8SPevSeu?=
 =?us-ascii?Q?3bm/XaJVwKojnVa8CGnvsXVZSjQ4YG0ZBNrV57ZMVX6GwvgS0wRg8eas3ntY?=
 =?us-ascii?Q?5YXdDBX6l30TSoDaI+hpeSa86YvzgVu3qRPtVleS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e78e482-7dc2-467f-2de1-08dc1e9aca29
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 18:15:34.6718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eCIYfNt1xtBfbeldpkmK27ND+SL/lE7F4w5ugLZQPyZnsCvI+Khl2yfHWpxGFMg7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5186

Introduce arm_smmu_make_s1_cd() to build the CD from the paging S1 domain,
and reorganize all the places programming S1 domain CD table entries to
call it.

Split arm_smmu_update_s1_domain_cd_entry() from
arm_smmu_update_ctx_desc_devices() so that the S1 path has its own call
chain separate from the unrelated SVA path.

arm_smmu_update_s1_domain_cd_entry() only works on S1 domains
attached to RIDs and refreshes all their CDs.

Remove the forced clear of the CD during S1 domain attach,
arm_smmu_write_cd_entry() will do this automatically if necessary.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 25 +++++++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 60 +++++++++++++------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  8 +++
 3 files changed, 75 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 3eb32b9d4a72a3..00d5f1aecc9585 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -54,6 +54,29 @@ static void arm_smmu_update_ctx_desc_devices(struct arm_smmu_domain *smmu_domain
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 }
 
+static void
+arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
+{
+	struct arm_smmu_master *master;
+	struct arm_smmu_cd target_cd;
+	unsigned long flags;
+
+	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
+		struct arm_smmu_cd *cdptr;
+
+		/* S1 domains only support RID attachment right now */
+		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		if (WARN_ON(!cdptr))
+			continue;
+
+		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
+					&target_cd);
+	}
+	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+}
+
 /*
  * Check if the CPU ASID is available on the SMMU side. If a private context
  * descriptor is using it, try to replace it.
@@ -97,7 +120,7 @@ arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
 	 * be some overlap between use of both ASIDs, until we invalidate the
 	 * TLB.
 	 */
-	arm_smmu_update_ctx_desc_devices(smmu_domain, IOMMU_NO_PASID, cd);
+	arm_smmu_update_s1_domain_cd_entry(smmu_domain);
 
 	/* Invalidate TLB entries previously associated with that context */
 	arm_smmu_tlb_inv_asid(smmu, asid);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index ada4e85b1917fa..e4e62f598a0859 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1181,8 +1181,8 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
-static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
-					       u32 ssid)
+struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
+					u32 ssid)
 {
 	__le64 *l1ptr;
 	unsigned int idx;
@@ -1248,9 +1248,9 @@ static const struct arm_smmu_entry_writer_ops arm_smmu_cd_writer_ops = {
 	.num_entry_qwords = sizeof(struct arm_smmu_cd) / sizeof(u64),
 };
 
-static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
-				    struct arm_smmu_cd *cdptr,
-				    const struct arm_smmu_cd *target)
+void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
+			     struct arm_smmu_cd *cdptr,
+			     const struct arm_smmu_cd *target)
 {
 	struct arm_smmu_cd_writer cd_writer = {
 		.writer = {
@@ -1263,6 +1263,32 @@ static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
 	arm_smmu_write_entry(&cd_writer.writer, cdptr->data, target->data);
 }
 
+void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
+			 struct arm_smmu_master *master,
+			 struct arm_smmu_domain *smmu_domain)
+{
+	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
+
+	memset(target, 0, sizeof(*target));
+
+	target->data[0] = cpu_to_le64(
+		cd->tcr |
+#ifdef __BIG_ENDIAN
+		CTXDESC_CD_0_ENDI |
+#endif
+		CTXDESC_CD_0_V |
+		CTXDESC_CD_0_AA64 |
+		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
+		CTXDESC_CD_0_R |
+		CTXDESC_CD_0_A |
+		CTXDESC_CD_0_ASET |
+		FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
+		);
+
+	target->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
+	target->data[3] = cpu_to_le64(cd->mair);
+}
+
 void arm_smmu_clear_cd(struct arm_smmu_master *master, int ssid)
 {
 	struct arm_smmu_cd target = {};
@@ -2678,29 +2704,29 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 	switch (smmu_domain->stage) {
-	case ARM_SMMU_DOMAIN_S1:
+	case ARM_SMMU_DOMAIN_S1: {
+		struct arm_smmu_cd target_cd;
+		struct arm_smmu_cd *cdptr;
+
 		if (!master->cd_table.cdtab) {
 			ret = arm_smmu_alloc_cd_tables(master);
 			if (ret)
 				goto out_list_del;
-		} else {
-			/*
-			 * arm_smmu_write_ctx_desc() relies on the entry being
-			 * invalid to work, clear any existing entry.
-			 */
-			ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
-						      NULL);
-			if (ret)
-				goto out_list_del;
 		}
 
-		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
-		if (ret)
+		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		if (!cdptr) {
+			ret = -ENOMEM;
 			goto out_list_del;
+		}
 
+		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
+		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
+					&target_cd);
 		arm_smmu_make_cdtable_ste(&target, master, &master->cd_table);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
+	}
 	case ARM_SMMU_DOMAIN_S2:
 		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
 		arm_smmu_install_ste_for_dev(master, &target);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 1b4104e9cec3d6..ec7c906098ec1f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -750,6 +750,14 @@ extern struct mutex arm_smmu_asid_lock;
 extern struct arm_smmu_ctx_desc quiet_cd;
 
 void arm_smmu_clear_cd(struct arm_smmu_master *master, int ssid);
+struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
+					u32 ssid);
+void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
+			 struct arm_smmu_master *master,
+			 struct arm_smmu_domain *smmu_domain);
+void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
+			     struct arm_smmu_cd *cdptr,
+			     const struct arm_smmu_cd *target);
 
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *smmu_master, int ssid,
 			    struct arm_smmu_ctx_desc *cd);
-- 
2.43.0


Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012066.outbound.protection.outlook.com [52.101.53.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BBB41D4E0;
	Mon,  6 Jul 2026 16:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783355229; cv=fail; b=KFOG0jNh6txkODhFmn4qft8GyoGfeW/xUjcJG1tEtHDtWMz54eIcnWypKC0/jaAACYfVLkMmvFQOWxA0pUgh0LgjY5I9TqGeruehpP3eyEdc5yCwM0LLHKTkX1RrF8PcEYzUrx8JL8vhFJOLopksSBLVgZgsIdTV5KX8LSWWh28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783355229; c=relaxed/simple;
	bh=wM/H3wqSw/C622Ec1So+GUljAJR4wcV4GA+e6R+n6kI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KiSTGQryLggOl2v4q2PpXYtU09+t0SEq0aWsueRc4jjn1wnxGLD/Q5ieYLyGdv6Btm4/5Sn22sVWPGHBoXl2pUp0dTVLs15fba4GXOXixvO5UvQTtGddnfuTwrv7z3XkuhxvKn7TRp1st6BnxoXb9rvbuCC6dAXo11DnSCb3qj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZW/szdiT; arc=fail smtp.client-ip=52.101.53.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZW/szdiT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YXYSI5QlOgRLyLQLQPjiwEzjA3WxBNh+lyXNXX8Ex9EXNgTI2ypGtJMn8myT8GVx0uiTQ28BMIgXNr+9UTTNUH4JvArJ9kB0z7ZtnNqGyx21zt39fVod9M6EMEcOPiQGE7QyGD9JINRPnhHpktWui1KaTLTio1tbQxau3NNi0rKk3OQNe6dXlmbcQMmlCaarZ0HBFyqTrAjnSNdPHQXgGEYhwkCfmdrPBUD3f8Xhwv1IpbqwbqqcRKRU2YLCBhcV0jM/d45lkYltPU/2t896xwGPj/Mb0d/kdOU5DCZsk9WlZ8VnRGIxEBT7KcumAA9GJro+cwknbnwNeiQuA/eWWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IZQVESTLZfG8VXKZlGbfNJTNv+gWbWVmJGlVjB6j304=;
 b=tu3szqDC5NjjXRvI5xb02gAyua58c0dcZ3RrVgunGwySP+qeA6q9WjEmKGYwLQTMItTN6uFaLbzhZPhNXo8torBRp8UBRAVDq8ReHRxM6/FK5Ev9MSjrP3K8iBE/Oyl0Rhkraby1RBPlnR+37g4Gsdgc87ag14VsSdtlCPyv8b3YcaNkzRYvNRefj6q3l7ab1Vc9UPghyDo61r8AO99Z9LAGp8luvDw+szJQPxv3u/KBtuVwMobrXp+n8R3o7WxVddoMbYfmD+vmEF3qwktxxvb/6IymQCDuFdZXUq0OU5w27vdUzKJLs1xtG9NGS69z/eOp/Il8xRAbaE9DBAVZlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IZQVESTLZfG8VXKZlGbfNJTNv+gWbWVmJGlVjB6j304=;
 b=ZW/szdiTLXhnTOp/1BwSFotkxcFrLDWO6OHo5ou2HcGMzu9c3ZidN81bygsNvRRzkxtV9vPJr3JeYwcY1idDpj29Z6ahQdEkEiERP8pAE6FUrmFBCpeIhXfCNxOluW26xAV/Y4nY7MI57116frPlWPmkVUQ24dj4SfZ8uWG9IlNZ3FL/6KbfdH1opFwZsV6bZSURVg98LVNR/ijTQCkJtI64ZA7fpG7vgEyyVdWmAhtVq4iBqExeExwga3r7psBR2lGY/dP9MCqJ9J2SN7w1X1CdEYZAPz54Xs/o5kdKlsdUBRHX2TuSlHDqgfaHkgfRTHm1KML3QtYu/8O1y2+mdA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH3PR12MB8535.namprd12.prod.outlook.com (2603:10b6:610:160::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 16:26:50 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 16:26:50 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 2/8] iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
Date: Mon,  6 Jul 2026 13:26:39 -0300
Message-ID: <2-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA1P220CA0006.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::11) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH3PR12MB8535:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c4d63e0-8944-4a99-1e3d-08dedb7b6186
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	uUtLd76Jt8vu8YUENFGCIhVLr7JO+wA9KwmH4rYRrsya7WhsTy/AuR1Re4kDbVBu8lGecEigvMcpNERSuHrjwq3/chRg7YIbETQ9yweSSuo+orrUhM4LpmmBF0WA4eOg+xow8y6ETdC78VT3EE1w+sJ5XoQ9Kq3juasOa/AxdjhPoTufbGGpHls+dkfh6aF024M1P+aP5nfhPvlUk4Xq+dbOQ314NqclBgnAR5wawLz3xb/OC6kJ9kBbASOvZznirfCjBjH5g1ra6gRK6Xe6jlaC5xPpYrY0JiW28hoaVPC8Hiy54KN7CiUjFjUK/CWvMTxNgjpmRJJhzTVnKrEfPDBe5icH6EZjZCvdPESv4gSLRMG3VxcmYK8NFfckiReA1APCBgOmT7+6kQ04oHCt/c7SsAdqIvAR0u11asGn1pvHQU6XyjK3pMLDzdndsM7A4t0e+sgWHCHFZPXIkJwJclwkeX8ljl3duU4HfklHMDnmh3YJR/KOyQZshg9zuZbddj79Qp4LGcj38h5G7gnylyDmIycZ48UbTf0WoiOhdFTE3SOv8/zPH7A3fpjGQ0T6Srt7c0laUgwh+wi6LjyQhslUMSr3lU+XIlEo1nMCGh1m8Tv92Xk2lNwxsI6JeNxJgH5APm9aCByvNnRHVNtN5ND9cKLCszn+RFZmtyzZlNE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K2e8UTekY9CUMQdT24KZ/OiOAwoXK7lsxk4I/i+3xC87E6m680bB/f1FrKln?=
 =?us-ascii?Q?TW6cP96BVzhbkYCasqX7uNoqyvaNnCAwwJqHmtacPvM6HddVAE6hXxd4QjO7?=
 =?us-ascii?Q?AW7FYe1A28R2Jqfqok+CeyuGzDqVWhWWqKooBFwW9OXrAhVAwshzWj2AqXWK?=
 =?us-ascii?Q?J4JkH1V3taQvQiI15btsDFNu+T9Dhsm2hfLiIQECePXFrW9NnX/akE2yV2fL?=
 =?us-ascii?Q?QbVrYac8VMDE8/arr9xYVv14uiHIg09KcODp2ZfSQ30H9uSlTX/NLHuAHGmv?=
 =?us-ascii?Q?J9sON/GtvesAMbUISxD7iu+EljE9VoVmQI+D0e8PAn1Pqbg+p4ZIQ1PRRPED?=
 =?us-ascii?Q?M1QRqkMjnHqaqKLwHI2pAqWH3OVp2CQej4aMIEF3Pa2poUhK60+luySCQ9cK?=
 =?us-ascii?Q?kqmgZCrIeljYDylQYMXFumHDhJKnW+H2GKpchBPc+tVpq1Ufz2GDSmTNMn0v?=
 =?us-ascii?Q?CUbAoIHpI6Eyb9s6HDP+PcaRh2X8a0dBvWjFbihyBhyEAzHG3i64jjV4fOBK?=
 =?us-ascii?Q?Y3cho1nUyxceyia4h+iDhQyWZ6ionLJXHtF4w1UXSqFjTIqgTTDLB7og9lje?=
 =?us-ascii?Q?2y8Ok2cn4pa8bhBfb3B7frhjfqBzkjNejAkYtUhnS85RGiKS7le9OKMNhC/Q?=
 =?us-ascii?Q?OIKwbwFJB/9+Avyc1L26SCR4R3Rg8lWJ3bLXrci65NVN6aks5TM3AQZPnBy3?=
 =?us-ascii?Q?y6x+l8QmUxXkPJf4Kkh+Lg+MeHpZh7Ut0PJU9NAFbbG7aJQeqa7hS+KP0hga?=
 =?us-ascii?Q?mDgOZVJPW9R2HmqlU0BQh5JffhszRBCj8cEN/hXkBrkf7l0aaTIWWUOcIuBV?=
 =?us-ascii?Q?+PD9XUrNxg1/FO9SLATyqQU4EyCCos7HVm4SY2JDYm9uX0SoB22vb4uXMczN?=
 =?us-ascii?Q?oQEjb1uwpTDuuweDQRaTEmXVlHNTxoc5bME9lHRLF4Zgk8YWw4FdpgbjNz3K?=
 =?us-ascii?Q?/l+ApgRDEGtgga4E3JkMRA8D2tdYqSSjUPpBi+dZZGQRka1gAgDnH2ab8i4Y?=
 =?us-ascii?Q?UwSgQwCduP5J6U9yJX+ac5YQRx0JAaDMDSxObzeQiZJuhOSxoMWm7vRWdY8E?=
 =?us-ascii?Q?VLRYPCllfta4LOKkXvbZ/p4qinPRM4iw99w5/D5o+ePw59cXU/BC6jollEjN?=
 =?us-ascii?Q?igv99F4sRq/6dBer46itp6nmdVG6KVK7oT/lxX8Y/umHMQoEqq4btlD4xIhu?=
 =?us-ascii?Q?GacTLO+1SfSadEE4LSXKV2KmWmbihdQYedDbumxHyo9mwmE9gqw5CkpkocUH?=
 =?us-ascii?Q?pj9r9JG6h+2Ujv8P5MwkN8sOtRJqBxKpPQR/Xrb3znTnJx8B14Uo6pnfCc/V?=
 =?us-ascii?Q?sZTMXC4/2/jPObMasn/om0xt2oLAcErJLvQk6QsLzzu0qkMqRDHucOIfR8Q9?=
 =?us-ascii?Q?Mb/4gkJ4JBw8fcjjnElzqmAPGro6MslY5uS8ek6FyH6pEpOHYRWRJJvaswjn?=
 =?us-ascii?Q?hzoSPr5Np+fUDt2RrRysFibjAQ2eBodHKwrPqeRfHqILSvBxT2G7La4P4LIY?=
 =?us-ascii?Q?p2cyRT/S+4hV1KZwBSMo5cAiW/q/Oudx03lb9vRtBMo/g1sAiaym0fKDWNAJ?=
 =?us-ascii?Q?OLyUXztfDU/Ik+UxjEV1bJVzZgHtI0UWFnnP/vy9Tbyuusb8SIVCv0Kd7exf?=
 =?us-ascii?Q?kUy3RFeAoj597U5xK9Px4dHluxD/m5rl4yIa5cB9e/LqoCGo99Oa69M1npem?=
 =?us-ascii?Q?Ajp+Kwjf3tTW5B8n++YYUZY7GOprbsC/pqOfA2AxmM80AKMn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c4d63e0-8944-4a99-1e3d-08dedb7b6186
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 16:26:49.8917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7R6zZ4GY8ZcFAqyabuoW6nMmVyn43Kcg933F8sDxMTATVtu2SyskfKHKMZuau7Da
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8535

pgsize is a constant property of the domain, it is the base translation
granule of the page table (4k, 16k, 64k) in log2.

Store it to the struct arm_smmu_domain based on how the page table was created.

Add smmu_domain to the tlbi and just get tg from the domain.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 27 ++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  3 ++-
 3 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 1ed8a6f29dc445..5d4dde3d1cfe87 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -334,6 +334,7 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	 * ARM_SMMU_FEAT_RANGE_INV is present
 	 */
 	smmu_domain->domain.pgsize_bitmap = PAGE_SIZE;
+	smmu_domain->tgsz_lg2 = PAGE_SHIFT;
 	smmu_domain->stage = ARM_SMMU_DOMAIN_SVA;
 	smmu_domain->smmu = smmu;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0c875771b46d2f..d22012466e3965 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2398,14 +2398,13 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
 					  struct arm_smmu_cmd *cmd,
-					  struct arm_smmu_tlbi *tlbi,
-					  size_t pgsize)
+					  struct arm_smmu_tlbi *tlbi)
 {
 	size_t inv_range = tlbi->iopte_granule;
 	unsigned long iova = tlbi->iova;
 	unsigned long end = iova + tlbi->size;
 	unsigned long num_pages = 0;
-	unsigned int tg = pgsize;
+	unsigned int tg = tlbi->smmu_domain->tgsz_lg2;
 	u64 orig_data0 = cmd->data[0];
 	u8 ttl = 0, tg_enc = 0;
 
@@ -2513,7 +2512,7 @@ static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 		return;
 	}
 
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi, inv->pgsize);
+	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi);
 }
 
 static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
@@ -2615,6 +2614,7 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 			       unsigned int granule, bool leaf)
 {
 	struct arm_smmu_tlbi tlbi = {
+		.smmu_domain = smmu_domain,
 		.iova = iova,
 		.size = size,
 		.iopte_granule = granule,
@@ -2870,6 +2870,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 		return -ENOMEM;
 
 	smmu_domain->domain.pgsize_bitmap = pgtbl_cfg.pgsize_bitmap;
+	smmu_domain->tgsz_lg2 = __ffs(pgtbl_cfg.pgsize_bitmap);
 	smmu_domain->domain.geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
 	smmu_domain->domain.geometry.force_aperture = true;
 	if (enable_dirty && smmu_domain->stage == ARM_SMMU_DOMAIN_S1)
@@ -3104,15 +3105,13 @@ static void arm_smmu_disable_iopf(struct arm_smmu_master *master,
 
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
@@ -3164,28 +3163,24 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
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
@@ -3197,7 +3192,7 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 	if (nesting) {
 		if (!arm_smmu_master_build_inv(
 			    master, INV_TYPE_S2_VMID_S1_CLEAR,
-			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID, 0))
+			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID))
 			return NULL;
 	}
 
@@ -3208,7 +3203,7 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 		 */
 		if (!arm_smmu_master_build_inv(
 			    master, nesting ? INV_TYPE_ATS_FULL : INV_TYPE_ATS,
-			    master->streams[i].id, ssid, 0))
+			    master->streams[i].id, ssid))
 			return NULL;
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index a364d847c22a92..2fc695817671fe 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -734,7 +734,6 @@ struct arm_smmu_inv {
 	u8 nsize_opcode;
 	u32 id; /* ASID or VMID or SID */
 	union {
-		size_t pgsize; /* ARM_SMMU_FEAT_RANGE_INV */
 		u32 ssid; /* INV_TYPE_ATS */
 	};
 
@@ -803,6 +802,7 @@ static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
 }
 
 struct arm_smmu_tlbi {
+	struct arm_smmu_domain *smmu_domain;
 	unsigned long iova;
 	size_t size;
 	unsigned int iopte_granule;
@@ -1050,6 +1050,7 @@ struct arm_smmu_domain {
 	spinlock_t			devices_lock;
 	bool				enforce_cache_coherency : 1;
 	bool				nest_parent : 1;
+	u8				tgsz_lg2;
 
 	struct mmu_notifier		mmu_notifier;
 };
-- 
2.43.0


Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF44137C4E;
	Tue, 16 Apr 2024 19:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713295716; cv=fail; b=QSBvV2YbFLwS9wAN5AfatdNpYPel2OEYhTTlSwXWNlHG4XqgyEBQG9FTpgzOcCs8sZC5GuaL3JZ2CXZ06HrLKCfhLVMYQClAWof+vRbTGftoln/s5qEsz+yk5YiM+cesgr25e66lWKEVcsxda6PbcF7QvnEq/eYMS8xCa80Bvew=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713295716; c=relaxed/simple;
	bh=T4deTVyIwyI3IneTrEJq6SuRKkI6YdqLhSBJMLOfaPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QuIBgCt0PQTvpK7ESAwT4neWH4uhqMzGEPicbOwz9uipMjZsOAVwroCGkpVsX0DvRf4Ot0suHfPTQ9eV2WpyRO35VERr5Dhp4OGBzmNvAuL1oErNt5+YXsjsg+CJa9nMLGarWnha08WL1E1zb8IQf5B+Vdu0KChr2Zvwyo/ocd4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=smVfiDiO; arc=fail smtp.client-ip=40.107.244.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="smVfiDiO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NsqTNHROR82tnP1BRtJmJU9w5xINr076Jm/g6fdQZF1vMaszxWTnHJVBsMtjZtY8mnYT1Wp8DeQJO4FI1h0HYGonog3EOzD7uiteMqsTtUR5x0esxmywfIUDDHz9eiw0WC5olboC/WcZkZhxaIMSjtXCC86rd+KGZgJnLm1WkEh9wOem7NGoqBfqMHDGjf8AMFR7AnDFitmpxVjQL0S38XOw1YCL82LqdQzIEfY30xhPQmyKUt9cOzWrS8tvhJexWSG3Lo5LvHmMfmXgQliNQxKT3b9uuJq6TnyhJr/bKbh3qj2dc706fQ2j2Vyhh2hKMQAxGvdpbQQUg/lpg73ZUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p/BEQyof/JfT3/ZJEAxYARzj2enWwJXlbOMwBtgNjt0=;
 b=oAss+bqHKcGABoqmJg09V4lPp3u3jVO1VCu7k5cGEN8YnuphrlSqorotnVm7y85tnc3A3pJVfuuQXIcWBnGV6O6wp9V0TXTRKz5EXZpO4LUfpFjgYMgWmSpP3UW51i53WUCNKO4rAnakArOgaAyHtY8yFJYLuC2mgkXdmDft5G0T/z7HgwBTY6wRV1GjDEKOjiZv6FuLgHDuI28dN0aA3bnMXibo58s8Q8EfBcxykZByjoy4x5rBeqtHoyfQEb4udmGhiOABpcM8KfC9LxP9ynpApdPV6rEPX9AOvM1TAkkhhVgPh6wA68e4jlFYEA/SIra8neaI/OWEwARvOU+p0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p/BEQyof/JfT3/ZJEAxYARzj2enWwJXlbOMwBtgNjt0=;
 b=smVfiDiOVgQkYtCkHaIiKDrqcFnyPKkfzsuleBvbDWUsjQ4Mcw6at3nwR976vuAb+1PdOJCwQXGbz7zx6FDcIClcpn7x11l4NHRq4oargimPWLa3otI3kd/C6NxKWGMfUo8GLXQfkbBnqilxSDRgeonL5mSmto0Ggl22aXXXRjeXOJRYukGselaisL5hX7NsBJ9/IJQV87eK42uK/TF8u/NAWSRawCRFxQaYQUHh5YpAevZI6ifKB6S8awvE6ony4Z5lPtPptEY5EhfiHZKfev7ivR4kl13N1DzImChVZPSBFuhqZb3fzkK8rZyWY+FWKyg7BKaCqiMxcJoF99PgRA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS7PR12MB5912.namprd12.prod.outlook.com (2603:10b6:8:7d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 19:28:30 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 19:28:30 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v7 5/9] iommu/arm-smmu-v3: Make arm_smmu_alloc_cd_ptr()
Date: Tue, 16 Apr 2024 16:28:16 -0300
Message-ID: <5-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS7PR12MB5912:EE_
X-MS-Office365-Filtering-Correlation-Id: 361b3ea7-d080-456f-b7fe-08dc5e4b6272
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GUdcCpJ6HU6deQfmiOJT4nRFkSo9lpx1CcxKabR9I6FkWgrOPQmjri2UHSaAwmVOYvTj1AgH2WKzb4YrEoaNuufWWWss041KD+xRuD5JGDwrMPvs1YoTgzpcIJ+9abchj2lsxYDcHlsFj/1JFtipcCwIR9e90GVrgrmbhH5yYudRAvg89FGv1w5OWzF3w47jlIafg2zgvnXWUGGjUvJ8s76oNgqt+hKAx/B+dxuDo4xFUvBSYMgHGJ6HScFn1VPNmpStIY/jrJH7rv9CL6EaXOJV8eldOOe6OXz+v1Kp346IrIhfNfuqUergWEcrxAqsjFptQ0D49vZxjttF40StjZcfhap3m6+iF3kT9EHH7PqePWT39i63qgELmQ/yEPxR14YwinyGllKnamp3AiOPhsMdKP1ps1kV7UNkvh9nR37E0xpspj4RUX0Ysib+d+hdDZq4UAuJJcdVmS1bxO4ElSN/W6Z8pnc70/a2W4/VvIg3ASDanJ6qME/BHIfJVrXcxKnx/LOMf+p4zdBU/w7tBM1CLgTvDgYAJXHPJyVMviAh8WtfifY7wbgQJnvoF3ArDND7L98NudFs1mUbThythEiyKAGlwdCxk0m4HwBnsUffw+Oq8H43IAk8KqhKjPyqCoa2Fl2XrlgppLR+PQ9FEoIBUD7xvuvvnl80ggnFO6E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z+8zpPwlLR8VQipDjlZdR6ZLyoVhptieX0nMj1LRkPGcbskS/fxYvLs7hZXG?=
 =?us-ascii?Q?6TZvL5Svel1o1kNgD6fIne5SzkOeqv3zNphe73PqRHaFQuup+I1DYUImT2C5?=
 =?us-ascii?Q?h667beMgZPlVjo4Ebk2SIk0e0HWZIW1FA6wFUDGtmg6QALcznKiflDiTew8f?=
 =?us-ascii?Q?rcXHAdRF8SW1y3HOJsLzlCGWO6VtrH6bsCpjJkiBOUkhGRcJKd5AJtxuue5w?=
 =?us-ascii?Q?zVisYzV/Yi9/1mmxu29RiMyzASuodeJG4Da7Uw3UoZrwdB9MFY5Gp1FacmRU?=
 =?us-ascii?Q?dJzZEzkqVbRi7TcRXI1AwAb2OApRrIozho3hdKBAWU7dygP06uodHI7gvlRR?=
 =?us-ascii?Q?DeMjGurVKBlizYyMZmNQbbS1aGfmnBplW+paVPg/+5QuNc+k5oekGLpqfzdb?=
 =?us-ascii?Q?gRSAQ5ZBGMA4zD9y5cG4tQA/ejpQuQFaZ2GBUpd6WKVOhI1t7M6koz72s8eN?=
 =?us-ascii?Q?6JquM5oEXqT/L41sgwqewtSFS9V9PdhVCfC+2B6siA1Ndh6Y2jDirVlavVAY?=
 =?us-ascii?Q?Fk08unpEKMlTlmP0s+t9L+cBrAiMUWzv68c5Rt+Af1M+3ssegDaJwG/z3QXj?=
 =?us-ascii?Q?bZR1dbdKYTZxAgB8+sO3DpXEtho7F/5Zds+Y6SMHNRhCfgMzVdTeKLDPmMmy?=
 =?us-ascii?Q?oxN85Bs1A8wHRaSGs1whpzDsTiX6VtI6i3OPQTmE/oxPg6KdcToaZS4d9vO7?=
 =?us-ascii?Q?zyX1JsC6MJivSEWk+R6c3UxVU6LVnRyTNAiXfIQbHOmJahxYnbPKe0Ly5hsq?=
 =?us-ascii?Q?hWIzSRPw43GCW/wGET5PUIs7H1/819WBXq0S0vtlJdZeTRfA/gxuUqMGr55C?=
 =?us-ascii?Q?FOTzjBNtitbZZH6bVBTxZTRfibd7vBbxGx1ogtkCKiUOFe0PbCzygUeyUw2W?=
 =?us-ascii?Q?GuO1K5SOR8FyjMNKzVi4ZhKY19VjEkTJsj0tkA2AHVIAiHJVGYF5m5nri1PZ?=
 =?us-ascii?Q?HTGenbdovV2MhOWQplsUirG6mWn77/2Dd3+FiRhiopCHInRkPT/Tc/oMLtzy?=
 =?us-ascii?Q?GQHuTW6oZzupvzeRF2W5KOSf5qKxp9iKeSR/lZ76GOeIPF4o829Tfn/F3BsG?=
 =?us-ascii?Q?/v1NiGttSI5o2bRmgp9MDm4syoXVI/92iepRDVdxJ48bpuADOyPLY03Z9B5x?=
 =?us-ascii?Q?gaUeDvT7xJrj17F/knCdOi4bMBi2FOR7KIJqQ4laOb26coqtq704CvCex5k0?=
 =?us-ascii?Q?5hWk+Oz9MXUy9OxNPVKAoC6/lJveZMDkBjZSu+WvyIM9lXfCv5l2vdoC+l+o?=
 =?us-ascii?Q?z7OmpuNyjxxFd79rdOOcGLDxOR12IqzA1+JVlZpthPXARbjpANJiKVNF6nRQ?=
 =?us-ascii?Q?umjvF6b4wdlMdsVmj/3Le2+mfqDGq1UwGkqg2rBFTyHfvnwf3FJmdKKP+akI?=
 =?us-ascii?Q?Rx1Exb9iDVNDorVRtvBjsM0zcW88qopwYOqXrlGuubYpUKIk1KqYpeNmshFi?=
 =?us-ascii?Q?esXPBZv9deVElwGpU9RZ4EOKa7YodcTNEJFIE15BFsiSrt6us8fVLyM3Hz2S?=
 =?us-ascii?Q?fa9cDcIOKLIFXB9aD2oFaaKgxWz3QwEk7CI5rqtJOekdBe/eD+YlY6vITpPR?=
 =?us-ascii?Q?buXQmdn7pO91+F2lfN1VobU+Yl3+POJBHXi2vhoR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 361b3ea7-d080-456f-b7fe-08dc5e4b6272
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 19:28:24.7974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CzfBiF6Nj6vZvEZPaV0tB/vfsL+9icl030INp+Ej+Sftmt7f418ANIjhaewR4URl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5912

Only the attach callers can perform an allocation for the CD table entry,
the other callers must not do so, they do not have the correct locking and
they cannot sleep. Split up the functions so this is clear.

arm_smmu_get_cd_ptr() will return pointer to a CD table entry without
doing any kind of allocation.

arm_smmu_alloc_cd_ptr() will allocate the table and any required
leaf.

A following patch will add lockdep assertions to arm_smmu_alloc_cd_ptr()
once the restructuring is completed and arm_smmu_alloc_cd_ptr() is never
called in the wrong context.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 61 +++++++++++++--------
 1 file changed, 39 insertions(+), 22 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f3df1ec8d258dc..a0d1237272936f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -98,6 +98,7 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
 
 static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 				    struct arm_smmu_device *smmu);
+static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master);
 
 static void parse_driver_options(struct arm_smmu_device *smmu)
 {
@@ -1207,29 +1208,51 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid)
 {
-	__le64 *l1ptr;
-	unsigned int idx;
 	struct arm_smmu_l1_ctx_desc *l1_desc;
-	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
+	if (!cd_table->cdtab)
+		return NULL;
+
 	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_LINEAR)
 		return (struct arm_smmu_cd *)(cd_table->cdtab +
 					      ssid * CTXDESC_CD_DWORDS);
 
-	idx = ssid >> CTXDESC_SPLIT;
-	l1_desc = &cd_table->l1_desc[idx];
-	if (!l1_desc->l2ptr) {
-		if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
-			return NULL;
+	l1_desc = &cd_table->l1_desc[ssid / CTXDESC_L2_ENTRIES];
+	if (!l1_desc->l2ptr)
+		return NULL;
+	return &l1_desc->l2ptr[ssid % CTXDESC_L2_ENTRIES];
+}
 
-		l1ptr = cd_table->cdtab + idx * CTXDESC_L1_DESC_DWORDS;
-		arm_smmu_write_cd_l1_desc(l1ptr, l1_desc);
-		/* An invalid L1CD can be cached */
-		arm_smmu_sync_cd(master, ssid, false);
+static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
+						 u32 ssid)
+{
+	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
+	struct arm_smmu_device *smmu = master->smmu;
+
+	if (!cd_table->cdtab) {
+		if (arm_smmu_alloc_cd_tables(master))
+			return NULL;
 	}
-	idx = ssid & (CTXDESC_L2_ENTRIES - 1);
-	return &l1_desc->l2ptr[idx];
+
+	if (cd_table->s1fmt == STRTAB_STE_0_S1FMT_64K_L2) {
+		unsigned int idx = ssid >> CTXDESC_SPLIT;
+		struct arm_smmu_l1_ctx_desc *l1_desc;
+
+		l1_desc = &cd_table->l1_desc[idx];
+		if (!l1_desc->l2ptr) {
+			__le64 *l1ptr;
+
+			if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
+				return NULL;
+
+			l1ptr = cd_table->cdtab + idx * CTXDESC_L1_DESC_DWORDS;
+			arm_smmu_write_cd_l1_desc(l1ptr, l1_desc);
+			/* An invalid L1CD can be cached */
+			arm_smmu_sync_cd(master, ssid, false);
+		}
+	}
+	return arm_smmu_get_cd_ptr(master, ssid);
 }
 
 struct arm_smmu_cd_writer {
@@ -1357,7 +1380,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
 		return -E2BIG;
 
-	cd_table_entry = arm_smmu_get_cd_ptr(master, ssid);
+	cd_table_entry = arm_smmu_alloc_cd_ptr(master, ssid);
 	if (!cd_table_entry)
 		return -ENOMEM;
 
@@ -2687,13 +2710,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		struct arm_smmu_cd target_cd;
 		struct arm_smmu_cd *cdptr;
 
-		if (!master->cd_table.cdtab) {
-			ret = arm_smmu_alloc_cd_tables(master);
-			if (ret)
-				goto out_list_del;
-		}
-
-		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
+		cdptr = arm_smmu_alloc_cd_ptr(master, IOMMU_NO_PASID);
 		if (!cdptr) {
 			ret = -ENOMEM;
 			goto out_list_del;
-- 
2.43.2


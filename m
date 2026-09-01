Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011045.outbound.protection.outlook.com [40.93.194.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2466348D881;
	Tue,  1 Sep 2026 17:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788285011; cv=fail; b=t18HcN3AdhHsxYxtMDM49236O4uRvP0KVsjdumbGKXLmZMhXo822q2SZFqTqeaIFaYIlUqnuuMsZbJPLBPDl4KdMw41UF2fOnfvHuF3AeuKsu74w1wd5qnS3Nt3whHUQH3uXbtcBBtLVErfXDV37lwHuCHcVX4Z1ig45X3QM3pU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788285011; c=relaxed/simple;
	bh=NN6J7vrwjrEKwRllSc90cwzD4dNGRL3cXvIh/oGwcOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OEc6p1N770uqnw4nQgYR8pIBJuxXTNjIxeSx29noNKe9Bnr01TmCtiUfZejgT9VHDYzmVliSDIieA22vKZwyoyxID1moMfsSFsi5nmwC6qH7T7lD8ST5IQbnnlLskfCrmOsnREJpy211cIBO1Q0qJ6chdCb+jvJBg03oERyIQE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xb9+1vpF; arc=fail smtp.client-ip=40.93.194.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xb9+1vpF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MCBCCZxf6kWwHEVTUCgxq9boHrKV0cQC+WrlvzafXotN4mm9Isb7xAczioL1QtLChuEWQtQDmaZOiYpocrxkpfy1/ebaBebAJKH16qtoJYLQ4u6tFdo6odxJS0NZ+rIbpmCKAm95Dmm2muV/Te5u1DQJssu4LbAWVSTJNZZiMp68vVqGom4HrSLaSRSQNRoy4Rdu8ZZuFXr6PEn7dvOvT1lAEgTgEogAjGFiE1nDQhrEbNZ4MszbDNupzNr8muogIQGi4Jn1tFNC9X96ofaebZ8bhv/5zFaMaSPF8+Opu1P+oFkgr+PAMtgCa5xhcIoXoAjU6JdTzpUELY55D+0AiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AEZkqU+0MHSQ+B+/HlhVXTM1/jA5bWSy8OuF7c5B1JA=;
 b=ILC61oeZ8B5BKystgQWSeV4c2h21z/ZbjYh7cBsWrumismAbZWvp1mORck2vyirWb/faukNEhPmebKbq5+Vf4qmu4a5ZPCmHA6fqb9B2OXGquE0GurKVg2xhTGcMXE4qg+AENDC5eSZvyfkvRL1GVOHtWsx+td72PrSCZI/2Mzsh6PwlRVGGoEwpQ0EPklVkrlNgkl5YHmxY0VVGRk8VE55vKFCCpNji7mfI2GzrQDGPXOkNOZFnzZpf1BHM1B4PNlE6ORFr3VGQp3fz5uvoSl4AEUltdO40bFrJN7Ml/IeRaSKpPBpPh0mB0Im4FJhiCe7JD8MLKDRwiRXAVpjA/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AEZkqU+0MHSQ+B+/HlhVXTM1/jA5bWSy8OuF7c5B1JA=;
 b=Xb9+1vpFZl8mTqHfHhpvJto0qu67tPcQP4hOAAiuKaGDbv8FDVJ6qCLJ3m7qlhhTfBCybDgKhyW4j0IL5HiZq77zoEE7HViNl/X6Ft5jE6IhGT1gBRLn2lTQap07brp0+yj7fR7I/pa1OtpuYEuYaE1N8mKOfioTN/UBxdCghQI+cvbuuiNNaIIP3Q8VLLMnGG/lN68Ls5E9Km1o0/sJAcrBTiyKjbSjwhMwP2RO8zESNhGDUiqbYb/BDgnVgafn7hfmaHOJCbQLlWXO8NrOCYUa3PdH9ssDbkIx9v58nKAyUqJIe3XeqmpWtO5CZakRo6shYMjRrkw5Ssd3Y4vU6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ2PR12MB8848.namprd12.prod.outlook.com (2603:10b6:a03:537::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Tue, 1 Sep
 2026 17:50:02 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 17:50:02 +0000
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
Subject: [PATCH v5 3/9] iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
Date: Tue,  1 Sep 2026 14:49:52 -0300
Message-ID: <3-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0004.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::9) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ2PR12MB8848:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e5d62c0-71be-40ec-3bab-08df0851714f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|10067099003|11063799006|56012099006|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	l4H6orSi+vkX+or6lmMRSWH24EwDKYKXeLkZDrMLVra9aIYjz6hSfvz63ugllQJ/umNFXgsx3oKvxUiHsFDFKvaKk18RjMDLApxt6MMffTsmM4dffhv1r2w25CG0qUum+zihHw/1OXpmaOp0V/OIy7pXpP7WVpffds4DbozAMu5yu8qA3AhU/ZNInbMihJyK8wj1QgcZEwjVtlsA4Dh1U1NiCBZ74hmsyriMpKXmyjLd26YQ8iNEYgceIrJZfidxe+EtF7re48ig297ZLpbOZrbhx0W4xXxgQIOc7/kr0IdfG6xvmv4XukrX1B+IHGInTFikX9QHiwTXadWYa1Bti33UfXE3JlAAJd0A43Lkar3wcjBioJMNkkAcNpfT/7d//z9mQR2jUkFmjGj2GHADKT60ALDK5nSIfOWVClroR4+J735QQknSJkfSLREFwa3Et0B7DMIzodM9bCMMubjF+j2hEbblfJpUz9WdV3JvXXgD5qoatg3ldcMxGUAhAq4Y49X8zGZVMFh+yVotHgM3D2XeNAIAISzy6n8eTNMpqbedRECE3DYc1RyeVETR5UUg2fYzy60A5adNMxWrrKwqSNSeRbbgL9WKMeii2hoRycuVw4FldF9AElk1ErH1w0+GO2u1z6cNIXSBmdSqnblmP6gQc7KdwT+O1/wD4JcZRZhpVPBVepiUjhGJu9/KQVYWdRifuHJ9QUcPGyU8mlsBfA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(10067099003)(11063799006)(56012099006)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kBPS1WSurEoJrU+cbtCXnlmshCOMm9ajQgY30tsiMjq6QWZZ/Y/XTLajWUe7?=
 =?us-ascii?Q?XDu0VvksQsliSdtvw1cKkNkwfgK7RVpxiQNkrW9KF8du6guLf9sCtlCQVZGY?=
 =?us-ascii?Q?4tWagxdLfOk5YU/+a3Vu5eI/71C3hj+IG0p3YhTecIduH9wQBp/WyUAV8It5?=
 =?us-ascii?Q?BcmGmeKl4hsLsu3FdXtc/ajIGNRT0MV+C4bSLDhCpERTrsx+yco7GG8f9sBd?=
 =?us-ascii?Q?bFtxGyR/syZVvlvhSo4Sg8LIFY1oKvNq53gAVdNL1NAAt5P95Mehtl//5lid?=
 =?us-ascii?Q?3WbRKs0Z6l3NMM1hHiWjIWfuW7J1Hpb2F8+1P1hiRTlimrbC30zAXMx5BTRm?=
 =?us-ascii?Q?S6a7j04DH4HLGpO2AcAF8vDird7RhGLjgsigm9ARig7u1YF4j6ag9PXHOC4/?=
 =?us-ascii?Q?M0QBI8IjuLhPnHBbldDhCiy6NHL9cIgYOCIr1yZPyy3r7mEQ2OI/I8X0GbVz?=
 =?us-ascii?Q?anxU94O6Br1dfuqW+kJ4jEFVgERBwULXsbWh0VJ5/CIEBKnuXnusjz2J2Pw/?=
 =?us-ascii?Q?kl87MJh3dAXh8Pj+QJGK9vpfFUymFCY+pupswO5W3wrzNsBipLLcfQcvJgTB?=
 =?us-ascii?Q?aegwwdT/g9mpcjMJOm4zGbU7Cuz7zDpKneHOUtXldU7G/857Ph2WRpgiYt/d?=
 =?us-ascii?Q?y8zluUHFVg7OgWZXajIawCAPLNK01ke33ZlrnUV8QuHv70mvHk7wqXIgj9MT?=
 =?us-ascii?Q?9ZA5SrTp10sxCwkgl4xm07DqbyTE9shHgmCLLBKFsJ//PJ+vSrIGxqj3KlWH?=
 =?us-ascii?Q?b7qSnQd6aNSG5TL4QDLRrevzgQTvbHdQwJ8YF1i/jsyO8j7QJLG0DHQcLaXg?=
 =?us-ascii?Q?Rom3gQaSmvQJ+L2Lqzzm9Wezs8/kmZ8206zncFsChObAHK1oGw4bipPr0uIO?=
 =?us-ascii?Q?n/IoffQo80yEkov6ZB0sZvmtVmw4GpVK1bOPryR0g8CUYMG19Lc+6C6ycsis?=
 =?us-ascii?Q?EtqIIelT4DQc0cN4DC0eO1nJmCSXL2sEbspOSVFZlLb3lgZXHkNK0/dGE4Qm?=
 =?us-ascii?Q?aNQUep854TyrLr7oRqX+XW7wURNbq2up3vv5OlTQqzawKdd8Zb3LCk96d0yR?=
 =?us-ascii?Q?thOp4l+8Nvc/CiF83yaBcLANfUXiyiVfF5y2mnpSNu+NDL5UoLPqy9Fqb2vm?=
 =?us-ascii?Q?dhFRdSRDkJPjXuTX8CfWkT85NjHwP/eCVODUPvb+vVJLYOPDMmJe6Ul7Fs7n?=
 =?us-ascii?Q?bYNDiuv6IJI7K+ZI4bpRNXavJpkD3k2iSjMmSdKhaTBPjk3txClbN0s6nhlk?=
 =?us-ascii?Q?VWK8w7j9koZADjAgv3kXM2qfPeurONAGPb3QR8onSsVk+99ZYugN5PjNeGXU?=
 =?us-ascii?Q?p34nX9EqT1+TV8p/sPXE0UkgS9a8X/vuFnTW+G67YaZbXql/As2P4lVZlkOe?=
 =?us-ascii?Q?ebIWq3gf+8Z/YmweML67Ppk23x2Qayzr1w9tOKKsubzrbEqxPcT/2n/BV3Pa?=
 =?us-ascii?Q?1rleoc9J3KNMaQBp8m2Lnpz8izIaNyy5/75Sc7l7roH9ss6erP480WZXrdeY?=
 =?us-ascii?Q?lVWdz4o4nb5MxNaJUS5lv9lf3mfzgvd0fBKY4wKjaHnlzeW3rYzhZPBbMM+a?=
 =?us-ascii?Q?s2uELhMt0Gc4/Ww/8tKNvK+Q1HaAGVbjj5IAQH7tWyRZZMVA6RHdSgBdtFbg?=
 =?us-ascii?Q?UiEMzO7BHfLY1Cn12gHsVkRV/yI9Jtuqat3yIBkuQG5kA8QC6Rw00h4r7S57?=
 =?us-ascii?Q?nAJws7VY7MoB5YNsqyGez2SyPhq6wVXaKL75piI4oC4dxovl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e5d62c0-71be-40ec-3bab-08df0851714f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 17:50:00.0878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0S3jFUhTVlA5hkhgLf2bzgzjBG/SS1SD8kN6cJ3Mw+iTSDrPqr0eUN8mZljgJ5hu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8848

pgsize is a constant property of the domain, it is the base translation
granule of the page table (4k, 16k, 64k) in log2.

Store it to the struct arm_smmu_domain based on how the page table was
created.

Pass it around in the tlbi.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
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
index d3e81056f24afc..3e7f94339ab60e 100644
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


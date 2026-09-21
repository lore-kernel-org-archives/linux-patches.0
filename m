Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011029.outbound.protection.outlook.com [40.93.194.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B974825DC;
	Mon, 21 Sep 2026 23:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790034943; cv=fail; b=dNWhnXyP+tHZbEdx5v60mQ0gin+ZC6twCv82UePF20/yULh8r8xIgi3KJlOT5adZwBESmuQknP4X4SGKllnQrSCEb084blv7U1++LJkiQM+RUVLCW16+SGEyTazeZazwEzw+U9o3UVWRF1LBXpHCj46UG+dgicxIRaIdTOeL2tU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790034943; c=relaxed/simple;
	bh=ftczAY3sjrkNe3A/ECIegnMM0+xTizNvUf//eQucaJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tvBeN9SYTW/XdJ02EI5H47h44hpZOrjK9JfWqglUK58VDBdKDF+4VvIGZMPiUovV6v5ckonUxGPmpgPmlQPBBoXeIyvBAdeZrRMLXsPjTU1a5sfRXW6ORQTSWfjQY+mc5wC+hI7dzATSeS2lFnCGwaIUJ7a/BrbakmwasDygco4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oVuFjTL0; arc=fail smtp.client-ip=40.93.194.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oVuFjTL0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QgcN6L3WVMONP5xGLOKoD87IWBp5ajiNEQx3/n7eG6+PSX6FitROSo0e3j1icPuqyxsxjjeDgD+aPdI/gyogl9d5QfvA2fCAosFQUThGMoIMtarVlMLGf9HQeeg1X6Y4VAO31jIzFbnJp/UsBvshlvd+uV7KMr7Cei2nCNv6czzE28oqyH3Lfluc1ZYMh9KtnuYpuTO6Mg4sns0mS045Yp4WCp07CggDYyyhXfXpNgTquVcBx3NoS9gRyJCh4m0HFyXoBeRLM2yFqNGsYoIeGIz4ctzS3O3/NZA1taEHBUFDqDfsvSDLK8q4iNIXlQVAkw6q5SnP/EHCVga+zUTeOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aYphbBUxpsVeYN6LDgFH2q9VnfDwXI7HShAm1KmlWDQ=;
 b=Buu/qzSxx+pYGhAvFkbJWW5oGfren5oIR4X/Fj1TPwHA8nT8ry5bkf8UeW6PlAttwA/4yrHfIHv2G5Thu5Lz0MlYL2oXL3x01PJN412BijsInT/teprxyhjby5Wc9fbo5BBxdLG3NGzNcUovlkJWx2EFGEv1l9qZ49Z0XdxbQheXY0uiOgXDsesq4c+mqkxe8hLT0GCBH1T6RceXmrL0mNJ/dASZl+gLhYFs1ZP7xmec4wNp2AsKlnc0eBGefTMAbuQe+7Uq7KDvm1//f3O2zkvDSWThfg8pofY05YXlxBIZvfh7dyxPvI7I6jsAoTAYPCMrD3VO72b1zvCcC17ZzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aYphbBUxpsVeYN6LDgFH2q9VnfDwXI7HShAm1KmlWDQ=;
 b=oVuFjTL0EXh8wl/XIGYfg3RYGauTP03ZfId8FdXGcf80V2eXT1HtLaP3HiEeeXX6LS1GrmJYSv18caiFw+tYEJludEsvsuvEPwfYNJe/QEKPqePBNIq0Y8B9+IrUxf2TLnHZzaiI4iQCGMag3nkMO6Zso2dJGcA5kxJ6Wi/Bp2GnYQEjFPv721Zzho7uMexIpejxwLKoqn9oUci0KwB7mUIPaReIGQyKy7fflnzLZkGNzWszr7s+SIbOnavLVU0Bj1bDKWyM7SaGoLnnxLd36ZgDlUVbVrDG/91KBRwSE05ipi8nRVf3s44Nbz7AfUnnsRhXFmc41UcD1SqElCR/oA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by CH0PR12MB8487.namprd12.prod.outlook.com
 (2603:10b6:610:18c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 23:55:23 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 23:55:23 +0000
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
Subject: [PATCH v7 2/9] iommu/arm-smmu-v3: Pass the parameters for the invalidation in a struct
Date: Mon, 21 Sep 2026 20:55:10 -0300
Message-ID: <2-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA1PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::17) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: ff8a3361-a5ac-4e84-f98d-08df183bcb90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|10067099003|56012099006|11063799006|6133799003|3023799007|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	Qv35FpRYzsC0fSfH5yk8gVM/EPvmTnkv/1EGlBC4ZSjpC8RUwm2apyy3SR9WLAgInQWDdBd1x2BhnEb9tkXtdYiGPwql130L3zw4ocB4140D1GzDPuSwgM4uP5MKCAsue++5YvcXgHv4oEEJYC30ufvPGqKBAKvPVP8b+yijDa/Q8k/G/JhkGTFL7lG8FCt3ARpnEYgU35vLylutwvDevm99NQDBj0Xkix7ckTAqoiq/qImj9ZjZqJOX0LnblAn98aUjmPFxvVTt6cF9T8pfAJaK2Z3Xz0K0jAZVElux8SBtcV4zP6FtLuMKxviTPJdsrFrbCFkwl33AgnlLzk2VMtDcpCbSyZPERH9M3UIZXEMUzSsym/yIzBNUoGXUbZXR9EyIqjH0H4jCRrYIBtekZfZ7xF1dMuBZ4Y614gLWeH1u+B5q2NCgljATLE1xow+55k5+k0dFRwLpHF8SuFadlwZKbbXw4S2P7zPxXVlMbHPcguF5xOigSgtdUMo/TWGOBzI02wyvcSPxa9h6lfYyUkANhAfPte+wlX7wNWsqdV1CPaEpRQQU4XTIfFTLF4fL7zgczbzuFS0b4Roy8PDUVj5hxHN68T2Xqm+L53UMzpYn8KzMIfgJ5Z08AAX3FR8RiyDBvBiW3Fx5r0H5bX01kPWg9w72g/uicoBYk9KrMLAJ9BNWSCtuWTEBNm6F0ZH1rCKi6pZScEhprihaeKq0zg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(10067099003)(56012099006)(11063799006)(6133799003)(3023799007)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M6bQQRsyffyp73PbV0+EJD/8ahq7M8+yCeaqWru2nyM7zV1CTVkrxArZF5P6?=
 =?us-ascii?Q?VpcU9ccc84Vb1OerYVhqubuyBCtm59KE4yhsoQdPTNPABOghvCgU1eh/t0w/?=
 =?us-ascii?Q?uu8mq7usclqaajp/ng8jdp1V6v75zUaZ85+cT5TvzrrjV/tQPeFkfIEjErDq?=
 =?us-ascii?Q?9Hm93x+3CH1nELabL4GSUo+LtS0btCjS09MvNfCO5K+AeZB4FduabJWcqqgS?=
 =?us-ascii?Q?xnisRa8safGTGZW92u6r/i2n0M6AFTQVV+JoQZaZfe/JlKQiEl8IPx7mf4t7?=
 =?us-ascii?Q?Gdfi4YMr9mYj1J77SXlGYzeaOoFPFlA2o+CBZqH9zJHMqfziduxA4hiIfF0u?=
 =?us-ascii?Q?1rn/H50dkyQB9aw/hWymNDZ1grMNR5yPe0gvZ9Vq+YwENBq/pZRBPJid/a8H?=
 =?us-ascii?Q?pFLCv0RYQXQvOeXI5qQNbHJFPn9WhBOZ8PIICHw54Sm5nRlYaqJ06pdKmHcT?=
 =?us-ascii?Q?+NaoLz0r81yalIxQMeY78MNOn+IhOxTxVbL7tXDXtGHbkMS2Grv46exfUaL4?=
 =?us-ascii?Q?tZcsIYTt+WdNlLmhqUYQqUSNAJVT/3Hrt1ui6zKqiMgXZzW/FsOJNdWEiCQL?=
 =?us-ascii?Q?VxmJjCSvQXs01bYO7FES8ervMbMi0fDLwyuCQt22duECJ5dSBdZet7444KuH?=
 =?us-ascii?Q?a/zT3ralBLB2YDSkSJU3rbR7Ce8ED+4OpEqBZB4sSg7MVZ5ale1F1vo6EMSH?=
 =?us-ascii?Q?ISryMbZ8lV3VFXCKFaoMDkmdYnfMifUxJQIZ1D0YaTfykCEfKii0AknIDkJB?=
 =?us-ascii?Q?C6donWkxsUGvIcjTZP/KrYVLWiR8ULeXUKA3k92kG+wVxpdECStN9q4simwk?=
 =?us-ascii?Q?JZu81XLkMkTMNmYTb1q/W8/X1v1Qnijfe86smd8H3DWv0uLR0uIj84KODXmb?=
 =?us-ascii?Q?OlHzj8uwauGTq6e6b3TTtOF0ErpgUT7R5AtCrwGRPmXUz6rimIcfyEsHXgFz?=
 =?us-ascii?Q?/VZ5p2B8FEJGNo4ChfgDmOyOzy3/HVHWUzUe8gvUJCyz7TPw/89bVy3X+7wX?=
 =?us-ascii?Q?lAj3GQwBfeWTfBPJjT0KN3e46Gl88q2O90TRjAhwgQ770/JcqD+mTUD3ITXj?=
 =?us-ascii?Q?qEmkgeY8ok3uFWIRgZa8A76tYqauowashvHKZKlyqNWyfh8cbLGbAPyMSmI/?=
 =?us-ascii?Q?oclBdARtJH0VvMHLf0nvP3a9fgRyzWOh4vq1VohasDO1rODtxEHsB/HG/BBA?=
 =?us-ascii?Q?QMcaPK0ZeTsFwUPAWS1CheUX8LFj8VaA0pWJClJbQE4DN9fSbJcELr361LUf?=
 =?us-ascii?Q?hIFhPBUtouBpYcgWpKVjkGIwzd4mFaoSaRDTbmVkvKi6etCDSTwktXFVN0nM?=
 =?us-ascii?Q?lWci6KF3lcZZtH7EDRrSIKo9dHBSYIq+QEBwzWaSyJiMwBL0PDV6+jvTDrKn?=
 =?us-ascii?Q?ANeeWsYVDd+iAVXMz3dZ+/wO2iRG+jyVjN6t23I/htyfCVnOMR5UXrljutQx?=
 =?us-ascii?Q?yniNlO+HnWt7gT2nJBF2Ee7UlncMivXae/SjgCMB90SYVhFHFJWHKQvSVoDR?=
 =?us-ascii?Q?DH0mCIAD0nXpEInCyJ8A+NaGe41gkVqupS0UutFbKfhZ6fK2wUZBikOGVcQy?=
 =?us-ascii?Q?L5S+w9f1Kp0Hn2Uc8mschmirNpVfD+vG9xbQfTjsRjna90jC10XptQ7sbU6Z?=
 =?us-ascii?Q?ACH1DrvlX90NSiMIdWlqmwJe0oAKrU9jEEsnEB/guG8cIP/zVBupUmAmR+uO?=
 =?us-ascii?Q?0+1E/1dX2RiyuNGqJSk/54Oo/yxNbNZUeScaadn0bD0lTQoQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff8a3361-a5ac-4e84-f98d-08df183bcb90
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 23:55:20.8774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7EyYw8dCfoihmebdgA7bvGt20JUvKZsvIdZjYkb7MtHq+JYjaHlaLaYY6xw4Frxo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

From: Jason Gunthorpe <jgg@ziepe.ca>

These parameters go to a lot of different functions and the next patches
will add more. Put them into a struct to keep things tidy.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 90 ++++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  9 +++
 2 files changed, 53 insertions(+), 46 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index e7ce2eb686ea39..b2244d77d245d1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2363,8 +2363,8 @@ static irqreturn_t arm_smmu_combined_irq_handler(int irq, void *dev)
 	return IRQ_WAKE_THREAD;
 }
 
-static struct arm_smmu_cmd
-arm_smmu_atc_inv_to_cmd(u32 sid, int ssid, unsigned long iova, size_t size)
+static struct arm_smmu_cmd arm_smmu_atc_inv_to_cmd(u32 sid, int ssid,
+						   struct arm_smmu_tlbi *tlbi)
 {
 	size_t log2_span;
 	size_t span_mask;
@@ -2386,8 +2386,8 @@ arm_smmu_atc_inv_to_cmd(u32 sid, int ssid, unsigned long iova, size_t size)
 	 * This has the unpleasant side-effect of invalidating all PASID-tagged
 	 * ATC entries within the address range.
 	 */
-	page_start	= iova >> inval_grain_shift;
-	page_end	= (iova + size - 1) >> inval_grain_shift;
+	page_start = tlbi->iova >> inval_grain_shift;
+	page_end = (tlbi->iova + tlbi->size - 1) >> inval_grain_shift;
 
 	/*
 	 * In an ATS Invalidate Request, the address must be aligned on the
@@ -2462,20 +2462,23 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 
 static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
-					  struct arm_smmu_cmd *cmd, bool leaf,
-					  unsigned long iova, size_t size,
-					  size_t granule, size_t pgsize)
+					  struct arm_smmu_cmd *cmd,
+					  struct arm_smmu_tlbi *tlbi,
+					  size_t pgsize)
 {
-	unsigned long end = iova + size, num_pages = 0, tg = pgsize;
+	size_t inv_range = tlbi->iopte_size;
+	unsigned long iova = tlbi->iova;
+	unsigned long end = iova + tlbi->size;
+	unsigned long num_pages = 0;
+	unsigned int tg = pgsize;
 	u64 orig_data0 = cmd->data[0];
-	size_t inv_range = granule;
 	u8 ttl = 0, tg_enc = 0;
 
-	if (WARN_ON_ONCE(!size))
+	if (WARN_ON_ONCE(!tlbi->size))
 		return;
 
 	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-		num_pages = size >> tg;
+		num_pages = tlbi->size >> tg;
 
 		/* Convert page size of 12,14,16 (log2) to 1,2,3 */
 		tg_enc = (tg - 10) / 2;
@@ -2488,8 +2491,8 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		 * want to use a range command, so avoid the SVA corner case
 		 * where both scale and num could be 0 as well.
 		 */
-		if (leaf)
-			ttl = 4 - ((ilog2(granule) - 3) / (tg - 3));
+		if (tlbi->leaf_only)
+			ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tg - 3));
 		else if ((num_pages & CMDQ_TLBI_RANGE_NUM_MAX) == 1)
 			num_pages++;
 	}
@@ -2528,7 +2531,7 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		 * command and something would be very broken if iova had them
 		 * set.
 		 */
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf) |
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
 			       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
 			       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
 			       (iova & ~GENMASK_U64(11, 0));
@@ -2569,13 +2572,13 @@ static bool arm_smmu_cmdq_batch_add_range_inv(struct arm_smmu_device *smmu,
 	return true;
 }
 
-static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
-				      size_t granule)
+static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu,
+				      struct arm_smmu_tlbi *tlbi)
 {
 	size_t max_tlbi_ops;
 
 	/* 0 size means invalidate all */
-	if (!size || size == SIZE_MAX)
+	if (!tlbi->size || tlbi->size == SIZE_MAX)
 		return true;
 
 	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV)
@@ -2588,32 +2591,31 @@ static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
 	 * invalidation feature, where there can be too many per-granule TLBIs,
 	 * resulting in a soft lockup.
 	 */
-	max_tlbi_ops = 1 << (ilog2(granule) - 3);
-	return size >= max_tlbi_ops * granule;
+	max_tlbi_ops = 1 << (ilog2(tlbi->iopte_size) - 3);
+	return tlbi->size >= max_tlbi_ops * tlbi->iopte_size;
 }
 
 /* Used by non INV_TYPE_ATS* invalidations */
 static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmdq_batch *cmds,
 				       struct arm_smmu_cmd *cmd,
-				       bool single_range_inv, bool leaf,
-				       unsigned long iova, size_t size,
-				       unsigned int granule)
+				       struct arm_smmu_tlbi *tlbi)
 {
 	struct arm_smmu_cmd nsize_cmd;
 
-	if (arm_smmu_inv_size_too_big(inv->smmu, size, granule))
+	if (arm_smmu_inv_size_too_big(inv->smmu, tlbi))
 		goto full_inv;
 
-	if (single_range_inv && size > granule) {
+	if (tlbi->has_cont && tlbi->size > tlbi->iopte_size &&
+	    (inv->smmu->options & ARM_SMMU_OPT_FULL_CONT_RANGE_INV)) {
 		if (!arm_smmu_cmdq_batch_add_range_inv(inv->smmu, cmds, cmd,
-						       iova, size, inv->pgsize))
+						       tlbi->iova, tlbi->size,
+						       inv->pgsize))
 			goto full_inv;
 		return;
 	}
 
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, leaf, iova, size,
-				      granule, inv->pgsize);
+	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi, inv->pgsize);
 	return;
 
 full_inv:
@@ -2638,10 +2640,8 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
 	return false;
 }
 
-static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
-					unsigned long iova, size_t size,
-					unsigned int granule,
-					bool single_range_inv, bool leaf)
+static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
+					struct arm_smmu_invs *invs)
 {
 	struct arm_smmu_cmdq_batch cmds = {};
 	struct arm_smmu_inv *cur;
@@ -2671,20 +2671,16 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
 		case INV_TYPE_S1_ASID:
 			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
 						     cur->id, 0);
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd,
-						   single_range_inv, leaf, iova,
-						   size, granule);
+			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
 			break;
 		case INV_TYPE_S2_VMID:
 			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
 						     0, cur->id);
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd,
-						   single_range_inv, leaf, iova,
-						   size, granule);
+			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
 			break;
 		case INV_TYPE_S2_VMID_S1_CLEAR:
 			/* CMDQ_OP_TLBI_S12_VMALL already flushed S1 entries */
-			if (arm_smmu_inv_size_too_big(cur->smmu, size, granule))
+			if (arm_smmu_inv_size_too_big(cur->smmu, tlbi))
 				break;
 			arm_smmu_cmdq_batch_add_cmd(
 				smmu, &cmds,
@@ -2695,7 +2691,7 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
 			arm_smmu_cmdq_batch_add_cmd(
 				smmu, &cmds,
 				arm_smmu_atc_inv_to_cmd(cur->id, cur->ssid,
-							iova, size));
+							tlbi));
 			break;
 		case INV_TYPE_ATS_FULL:
 			arm_smmu_cmdq_batch_add_cmd(
@@ -2726,10 +2722,14 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 			       unsigned long iova, size_t size,
 			       unsigned int granule, bool leaf)
 {
+	struct arm_smmu_tlbi tlbi = {
+		.iova = iova,
+		.size = size,
+		.iopte_size = granule,
+		.has_cont = smmu_domain->stage == ARM_SMMU_DOMAIN_SVA,
+		.leaf_only = leaf,
+	};
 	struct arm_smmu_invs *invs;
-	bool single_range_inv =
-		smmu_domain->stage == ARM_SMMU_DOMAIN_SVA &&
-		(smmu_domain->smmu->options & ARM_SMMU_OPT_FULL_CONT_RANGE_INV);
 
 	/*
 	 * An invalidation request must follow some IOPTE change and then load
@@ -2769,12 +2769,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 		unsigned long flags;
 
 		read_lock_irqsave(&invs->rwlock, flags);
-		__arm_smmu_domain_inv_range(invs, iova, size, granule,
-					    single_range_inv, leaf);
+		__arm_smmu_domain_inv_range(&tlbi, invs);
 		read_unlock_irqrestore(&invs->rwlock, flags);
 	} else {
-		__arm_smmu_domain_inv_range(invs, iova, size, granule,
-					    single_range_inv, leaf);
+		__arm_smmu_domain_inv_range(&tlbi, invs);
 	}
 
 	rcu_read_unlock();
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index eb308993c810f2..dc2d340c83f858 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -805,6 +805,15 @@ static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
 	return new_invs;
 }
 
+struct arm_smmu_tlbi {
+	unsigned long iova;
+	size_t size;
+	/* page or block size of the leaf iopte */
+	unsigned int iopte_size;
+	bool has_cont;
+	bool leaf_only;
+};
+
 struct arm_smmu_evtq {
 	struct arm_smmu_queue		q;
 	struct iopf_queue		*iopf;
-- 
2.43.0


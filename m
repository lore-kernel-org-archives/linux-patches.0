Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013003.outbound.protection.outlook.com [40.107.201.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CB548F85D;
	Tue,  1 Sep 2026 17:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788285019; cv=fail; b=KUaLuz5Z7MwDE6c1AtgPcOxeKKCier76Qye3w2KseSPYjVQe+t5j+VEdmT2YNH01HtZoiRtfXmCJNCk1r3ML4Fpqh9CMDOP8nlfbxgA+ndu8DYTMtXskUiSQjaPDehIj1ME2J7NSOa7fZHQfVpnQO2uFd/1/t/nYdaCyVIgcq3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788285019; c=relaxed/simple;
	bh=oU5mmIOc8PEVXA4AiagLPXSy6EGLZMJp4Mt33WdM2jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=E4W2HrHM92zUiZYRlF7Lm/PGwIT7tRnT3quxl+ku452yCGzrY5bGeVOPDZ4EPQuEIwHdRCuzBXmQT86eyOFD6a825LLxFf62Yprl3Nt5qEUNUQpNKMzCrFMYHlCN9UAR5YyjzuzICxd5+Emj2qEI7VdBtDoHI4mIGldVjVuFmaI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bP+dbSWg; arc=fail smtp.client-ip=40.107.201.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bP+dbSWg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=myLQyw94TEnY2deTjBWv83rQnjIrHKN2h0gxvRHc1drgDlwEpY+jK9AVPT9VExrwR8gjRF25pbIgjQAeDALx82jcl92OtUE+rc7EkEg4hklQro8wxZbU5UNLCcjtfftrqkt3I3RmJ32WSGDZQRL7FIzdE2GdTRSO+tVlxJSrOn1y5As1Bquk+P2nM0rI1dxVgKqK8GnC/AMdZKNGD6pdoM9pBU11K6+b/Rq5yS3wWyjfk7dNIMg1tUisS/5X0g79vFdotd+fIdiiBnCsFYWyhxr+p5JVpzvPrRInlAFoVNK9lxIppTDW404A+nMFyRboWagv4qFtyKq+/Kx1AmN0/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CMnpuGPzJM2eTGic+jg16yg4ajaWxelhg1e+SNEJwJU=;
 b=pff+8fJ3jCRV20EmtjU7a1KStMjzNYGSa4Cj0JW6C+Y/AaUnOD+ZELrajHOJucNA6R03rqxGf8lhcLtfeFdLiDwXYuUAH+F2ZcgTGPaokztlwDAfoe8lh3LUIAkYVW0lIbLrVC6n9US8SJT3aSEY5ZqxM3Lrh+M1alTPZLqFtaSD6OUfrj/NIc9seoEonAnkBrmDaMkZyhwps/7VK2CXipb+lvxNWJVSqYWikuK3ahm7/eersiO+5qTMABtrUSV6fAtXZBL3KUuzdn/Z12Ia4Js8JhzusbjF2ikJsjWQhLYUe0gvbC5NfK/gLHdTzYsRPbq3bnEcRSO4ZHhF/P15ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMnpuGPzJM2eTGic+jg16yg4ajaWxelhg1e+SNEJwJU=;
 b=bP+dbSWgOg72EwM8C1Lhq8zgIvIK0cV8vhZHPlfItz/NP3hQp2KY51fW12IYLZ99sOc0PTb63aUm6Ge3uEkAazjQVSqtlb5C1X2xqYkSYjCmSZFWn1jWa33t5+DQ/SUNR+0eXF0WgJtiLIxqqvBlZKQGQ6eLd9vabGOKy5Rx6wmfU/Vk7/2KzLmIP7pHGwO7JyS97m+yjr3LYiDWRf82AXCSzUMhJVFyj0Svmdv29p8w7JyNY/8pRDTYtEzIOpYb38I1350wQ14n+gldN5UN/sg2l+Ijo2tA8O9+3WoASPdJ6SZTzKAut4X5AQpeq/4/43NRLRHBH2lhHLII5Xll0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ2PR12MB8848.namprd12.prod.outlook.com (2603:10b6:a03:537::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Tue, 1 Sep
 2026 17:50:03 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 17:50:03 +0000
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
Subject: [PATCH v5 9/9] iommu/arm-smmu-v3: Support the DS expansion of RIL's SCALE
Date: Tue,  1 Sep 2026 14:49:58 -0300
Message-ID: <9-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0474.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::28) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ2PR12MB8848:EE_
X-MS-Office365-Filtering-Correlation-Id: 8aa5b5a1-b2c6-4e75-78d4-08df085171f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|10067099003|11063799006|56012099006|5023799004|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	yUyd+1Ip2AREcyaygFjNxI9O3jN4VsTfhNekPdfvcGTPVYrHrfxbR3xrMzcAocLryTRbPFuHSqWcWHsfCHAspfjKHF8cI+hrT0YmwInOz+id577ikQXju0kBdRodWGv3eYGQnVZPLYJAGwy40y6eV/LcvQgT2hyifa7YRJOfEr367VAg7r+BC/HzctRd7iYZDONcxDCqrYRS924BRGTOf6uE/UiEe+bH7G+MR1831wXTPCWiK5rpcUQMotzAWDInp1v14+j2/+NuYFITejNNC8NvbFADsiwkWdyMZ7ZqeZsOrGgPwWxSwEYlpCJgCXr8aCDYrIRrqrbUdJiFJYNbloEeef1jeyPeI/PtJ+H82Vl1O0HKFU265d0tQDCOCpP5aln8HS4I68Bdjged/nGmjBKjsOeWQGcJDRW8OOvCAnFAlHTXC2lkUfDKB2p1x1u+6EbJOSqI2/l0MS9ffFi7tvx/JO2r0X2hGX5ZilnhzihwWyh/F6b5aOSa3H/HGa6mnj0L0J9Se/9Lxot4nDkpORxiZfmS7+hfWqGGtjY05LSH5lMjvq4BGFXg0YK8xkWM86Z5sOb1oMEkSJ3j4HpdfZ6xvm/TYiBRt4tFsmyQFmZXkcE8w0y/d8US+rdrM8c+qvFNAYX9AHTcFd3DiniPlf/1A+2bqJLdrzps40SnE59Ve29H8yAWSvWmK+l0YQF9owgXBZ8IqVPr2ocxSZ+M4g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(10067099003)(11063799006)(56012099006)(5023799004)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eNYrQCmdCr2MKz9gvgn0HpM+V76sp+cRAHH5yAhJ4gp3eI3+EpuWVqgEcHeG?=
 =?us-ascii?Q?lGbMXJeC9u4bwSm2Ei99PtqACiedzqudHhJ6jVV95yJwAe5VMhnIO7MEgvxx?=
 =?us-ascii?Q?Cv06DJw28j3Vd6LKIysMEFXN5AJjWc+YaaUxn05tejpJvi45rwyOiUjuchw6?=
 =?us-ascii?Q?+vw2DT3wvwMro7qGZmJJMS1IicgXe394JMR3mycYmrEkN7ijpwmRLxdtL4+F?=
 =?us-ascii?Q?zWc7C8VfNsbecPTFEF4HCqfyR3iRmnCPkbuhlYXfIYbwsrhNiE0kvYrc1TfU?=
 =?us-ascii?Q?YRbZC2lwqmtCFz+uHoqI4SK0smbSB5aiy6JT8a+kzkeOoayu25Vlhm65fkEe?=
 =?us-ascii?Q?johXiWtMR92CNlIQRpoW7FIMYXfoq2FWLwOk/hIW66VVRu+9t+lQXZWTtpII?=
 =?us-ascii?Q?nyAxSZegSWEQqdL+5v+V7lPrr/C1gid78S3q1LQREFnJNmr888yRSwj7CQ8Z?=
 =?us-ascii?Q?tOAofbhQXJVgvNUg+hMIzyj+gFnu66NloL1HWNIdHPGPWJviCl+Y8zk3iGJ8?=
 =?us-ascii?Q?kEH4V6ygZfWpd3LuZAuaowey09iKHGuIsAREhOffmIMzsqmR/jTrUGoD7OhE?=
 =?us-ascii?Q?EcGxJ5tQ5Kwf23cg6QPbBW8pcApHGhNbbfRsH14sIMjMlXaFrWCgz0uZeS4y?=
 =?us-ascii?Q?0/nJzdGjr0+xn89sg/V0iBMxRK2D40XhdMh2Z4NNgFWnj9v9drwbN4JiOMmd?=
 =?us-ascii?Q?Q4us3+oTcWgF7LjPRNFmTGCRXhNalXPYi1LGuSHLRk5XWgarpe5MQBg4D+Tw?=
 =?us-ascii?Q?/cBBYUuO7hzr9BR8mHYIXnA03uPGxkFcTwL8VPwbW49SIahJOPTtfEIyrUC+?=
 =?us-ascii?Q?e41wxNLi1kZ3q1UFRZF9IP1rT91+oNj7XTc+6+tq9morHiz9q+Dq4aHEIz0D?=
 =?us-ascii?Q?WPThVcssGXbB0iJOaK+hl2a9Z5Vwkw+xC8kysbqpw6WLKpfFI3ES6VMiryLL?=
 =?us-ascii?Q?t+sA01Ro+8kAjurrpyyqbb58XhkWNL4QiAsEKz6PmvB9mDrXVVsvi2hnwntm?=
 =?us-ascii?Q?dSOQZWj596b1/Es9V6luSCEn9B0BimlUxlQyG4oq5Da2YXzgbdq2f8znMVUe?=
 =?us-ascii?Q?Ic/be165U7W34rh1eg/G7AWtbBw78Nhjhw85EUyriKCV+0SFuDMoCtNL5YlB?=
 =?us-ascii?Q?vyzNK2L5sGOdZwLfZQnHEi4Fnd0okNkZzcdj8X21LHMTnEMDXMnJ640Hx37m?=
 =?us-ascii?Q?jisPYekVfSfMtA9jMcCexoeDitpKamX/qm9SKM+k75WboZa6zlIMbOYrQArB?=
 =?us-ascii?Q?kjc4ozZ6dYIhndGhUMdegBqlbZVZBZUuzBYL21SoKAxDlWschKl88bRT2Ysd?=
 =?us-ascii?Q?c3vHLDZIDv3dtzjQAdNWanxqUKThoDTOT5Tj+l5+2vIiGTcduXHa2ukm/4Nq?=
 =?us-ascii?Q?pperBYK3u9SPfrtTxlvYTcdzrt87dMwXDxlutQR03tfNiNWqWARe5uimX/mL?=
 =?us-ascii?Q?iSfsX5h8g5jOf576KtP0d5Y8/sshM8F5rkcUKaXqsGQUjEjjkUNHQMIdyPY2?=
 =?us-ascii?Q?Vb7bBJqvq15+IpTqvVEV3L1UWt3Kxcrq20EK5ZKjoOii8Twz8LuMIiH/Sbcm?=
 =?us-ascii?Q?GZm1Sm2H6gyWtUAMEMk7FNMe0TWnKcqeOuEOm1rx/o3CXIkhGzn+rkEyAVUY?=
 =?us-ascii?Q?pNqZPGDPP2gntfjdw7gmxf4zPYnjxk7bdKGfXL828icHSfrGoVgIukLEIEd6?=
 =?us-ascii?Q?cXfbvDxyX0ZWulsst1IW5IqVjaKfgsChRHG5239z0q2olMkj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aa5b5a1-b2c6-4e75-78d4-08df085171f1
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 17:50:01.0836
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iNOEvsFQD80vwBGc16yytP5fc2vcCzTtOtr0+L/J3cE4OcpzhdX9pzEV2+XlUpQt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8848

If DS is supported then SCALE can go up to 39. Compute a scale max that is
compatible for the entire invs list.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 15 ++++++++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 ++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b99229a5bbacca..2a159be751891e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1060,9 +1060,16 @@ static void arm_smmu_invs_update_caps(struct arm_smmu_invs *invs,
 		invs->has_ats = true;
 
 	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
+		unsigned int scale_max;
+
 		invs->has_range_inv = true;
 		if (inv->smmu->options & ARM_SMMU_OPT_FULL_CONT_RIL)
 			invs->has_full_cont_ril = true;
+
+		scale_max = (inv->smmu->features & ARM_SMMU_FEAT_DS) ? 39 : 31;
+		if (!invs->range_inv_scale_max ||
+		    scale_max < invs->range_inv_scale_max)
+			invs->range_inv_scale_max = scale_max;
 	}
 }
 
@@ -2625,7 +2632,8 @@ static unsigned int arm_smmu_compute_ttl(u8 leaf_bitmap, u8 table_bitmap,
  * covered by one command.
  */
 static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
-				     bool single_ril)
+				     bool single_ril,
+				     unsigned int scale_max)
 {
 	u8 tgsz_lg2 = tlbi->tgsz_lg2;
 	unsigned int ttl = arm_smmu_compute_ttl(
@@ -2647,7 +2655,7 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 	 * address beyond alignment to tg (so long as TTL=0).
 	 */
 	first.scale = fls64((num_tg - 1) / 32);
-	if (first.scale > 31) {
+	if (first.scale > scale_max) {
 		/* Range too large for a single command do full invalidation */
 		tlbi->range.use_full_inv = true;
 		return;
@@ -2917,7 +2925,8 @@ void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi,
 			arm_smmu_tlbi_calc_range(
 				tlbi,
 				smmu_domain->stage == ARM_SMMU_DOMAIN_SVA &&
-					invs->has_full_cont_ril);
+					invs->has_full_cont_ril,
+				invs->range_inv_scale_max);
 		}
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 6582203eb7425f..8b251a188810c9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -760,6 +760,7 @@ static inline bool arm_smmu_inv_is_ats(const struct arm_smmu_inv *inv)
  * @has_ats: flag if the array contains an INV_TYPE_ATS or INV_TYPE_ATS_FULL
  * @has_range_inv: flag if any entry's SMMU supports range invalidation
  * @has_full_cont_ril: flag if any entry's SMMU requires the CONT RIL workaround
+ * @range_inv_scale_max: max SCALE usable by all range-capable SMMUs
  * @rcu: rcu head for kfree_rcu()
  * @inv: flexible invalidation array
  *
@@ -791,6 +792,7 @@ struct arm_smmu_invs {
 	bool has_ats;
 	bool has_range_inv;
 	bool has_full_cont_ril;
+	u8 range_inv_scale_max;
 	struct rcu_head rcu;
 	struct arm_smmu_inv inv[] __counted_by(max_invs);
 };
-- 
2.43.0


Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010024.outbound.protection.outlook.com [52.101.61.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E841447ECC6;
	Mon, 21 Sep 2026 23:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790034950; cv=fail; b=TGW87xkLeCNuNkncJiq2OqlTzfLI0eoFoZZLGwhV4gjYfWZCA8o92lDk+wr6Aje56nl7ulLp4wcoCQvGu3wNyzpi/N7gCfG0frn9asfH2zt/pG0eDUl/YtL9hxyD4LBttI5O+MeiUiiAKQqEdnMUQHtRAMxPVnLQn27oFm0C/LQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790034950; c=relaxed/simple;
	bh=T3JAanfqqf+nTuJ30ZOJOS0Lhp2lXwYbGlj0PsTsw4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OMLgV+FHS9HSSIjcv5EnmG7lHdLC81E582NPwfDYQTX/yzX0HHX9urT2imlB2vjd/HGWb+n+JMQB82BaObfQORDCMHND4Epso5GzND/IU98I6lhhKYNfVYZ2B6PGZrcoWKLVmrRG42rh6E6GHzvDokoPNfYEeyosQEKAaEYnN6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h2c+jENA; arc=fail smtp.client-ip=52.101.61.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h2c+jENA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nOhl9M8CwLD1qDfJ7hj9dyW1K8sbyy+ZWGy0gsZTvy4f0RpmRQOQtcCSmY4R3y6UGTmZqz8ZbcaTMJYsun82AvUSXtihQjibU5C3AZmlPiuxVXneGMeC39mf43/T3gPW2f30Dov88ZWKhiv3agKmuh/4dIhAXV7YZMhQWG8htTjwKwS8tpWqTVVhcG08gZqX7sxDHnc6VhQWTiRNkaOtjjtbnfko1n09Ij1PWjJCvzHCsaTEP7Sjmo9tTvz1vwjxpT07bkK6dHTGBr8P9vXGBM4Iv9mlORLBFxQLKQXaMBHPo1yx9Q/5K8HjduIB5IHhah3KydtALxcq/aUry4Z+YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qamb058CqyBLEIaVknsUGv5xPSn1kE5uPbrJC3yqcDo=;
 b=v/zEY/7N1zGXPXnw6TQ2fCc9Usj0OSKATg8QumA7/r+/7H4toxIsmmrYWAIi7Pl5AbVctuF6kJcyt7i9IWE2XJdtK4zWifIDRYq1ENFWWmEHGvTB/xTrwVmRp0IYW28KRJPYvNW7AO8iCagxF/dyb8YElDbNsOrWzvFpU+gdOC/vNJtg/x0KYKYlXl4foU25ZSJnDttB0aMDMakMokZLOTzFLp8SjhTiQ+nmkMt4jWzUgqxzr7KWXYzmZn3GHnqCM5NRE2mKX2PQL2/HoB8wwFD9UjdIm4+30IyK8gKOxgvdD/nLLkGvgyMPPsf0yiOXKsrQrMXJDPc2lkuCHXrJAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qamb058CqyBLEIaVknsUGv5xPSn1kE5uPbrJC3yqcDo=;
 b=h2c+jENAmIoAq07NlGs7B2tnUIsGKMgtdiuVIJq8Eum6y5s7LaGH14BX5psoo+ABnwzJOzqOSKyAGIB62NW/8uR1dv7umm8f7fH+d5NCUiiU1fpd//FndprcuvIc5ppn54zgezLrxRAnn2gdvRoFrHrWCE0t/AKiDrBDgrn1EGk+GXu59jiCT16kSsNMAvtBfoHrwEzYtZ+fDLldBZePhXC9zJuQ6Ryga7DN5DDTiRBiM3u1MDKFIcjH6PMsYrLBr8r75w5eQuMBocIU3CYiRKO5tOqNkPBNtswzKOqV4YMg9H3zrIgPX6HjAhPP7gNlm+Nfb0iJjk9hGz6bSkqlEg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by CH0PR12MB8487.namprd12.prod.outlook.com
 (2603:10b6:610:18c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 23:55:24 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 23:55:24 +0000
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
Subject: [PATCH v7 6/9] iommu/arm-smmu-v3: Precompute the invalidation commands
Date: Mon, 21 Sep 2026 20:55:14 -0300
Message-ID: <6-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA1PR02CA0010.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::16) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 50ec11dd-a340-4220-7073-08df183bcba2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|10067099003|56012099006|11063799006|3023799007|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	jQwiuWIv5ibZYn1gmGdFcok7+korqoGl+awX3oGDEZgDNkFWqtT3tb9BJbveyiWjlmARgkS4BY2jDnKlVJoeudv+L2dgD147dtEBQ2JYWDL9poj2IKTi2YPBMC1BTfovSAWQ9tCki1La5E+dn0BmXNwW7QZv+NEgxLNLx1GBoFbUfelFzyTjKH9oFSo/TSzlfDgyYMFpe6doYt4Qi7Hnri7CjKG410l2hH4eRNLvp5ImNbSHx0Zzg7au2JBM+Zg0qbn7nSzVehYV4FJ38su5cWLVxMIQvCU+08YqQ9hQVqnqmQvdtLP1gFQY9ZJM5efRkw6kbSI2zygqaUp/DLs8Kjxp6MdtQ1JhVFbnfSQckvGdtL+1rXZi4Z+CWQEOw9Rrw3EG8McWgmJFv0JJ7xmhsLZfUIGIYHO4L1Tm6djHSgwbJZnlIHgjh++wf4R79Pn8ZBX703ObbL08x3FlW2synlgim+oaojtzteoyGuEfuobtnIj/kcuS0GE+ql0/vnZdh2kvny/96tfpObB/70aGo84V44n5YK3F2YsbUJx7VehJDxEyNqP0IuccA3k8YfGVRirQcAi2xsx11mctCtFQn0Xxdv/AkK0WgJJdI0XKpXy8K1TrwOd+QPJOHic9npgUMgLx9erp9cedBopegHlZsGOqvXHqk1DOM6JLbZ1MGvyELb8zoaXJvHnRJbc/8P2VHy09Ad9uWZV8nifw8b0JCQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(10067099003)(56012099006)(11063799006)(3023799007)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FiImSV3/2/P3L/HN+rdj2ZVqpJghRz2OJsT4s1rMuTDXfcc1y2awVGCTrz1I?=
 =?us-ascii?Q?Ngj+87J4Q5ekfIiaJ0nk+rVVVLpDlwaiICNZeSz81wmuJF0jC75NW/crZI73?=
 =?us-ascii?Q?dlCeUlFNlJ3bJF3oSad7Tcym2sxdaiQub5KkJ9dQceVBbUhixf+yC1GZaI59?=
 =?us-ascii?Q?t4HcI0/34ppyK7fyrRVVvmf0ZDdKR3mruoyXYBs/znD0XOa/fBRA9IX42+in?=
 =?us-ascii?Q?j8hrZINNANwy6wMA1CUvnvv/tQv7J/E+/gyle/MOd1eqZ81sRZ13OrYbi9zC?=
 =?us-ascii?Q?GN5RBFrWs75++TCXaCpvOgrmuaIV8DDW1h+GHgicA/nUz49+xvk0lzDWyLHZ?=
 =?us-ascii?Q?RrJ09ige9ezApIXRSogDwIHVSWPKxp6+JaJtusfGMmy1x4QY1yvNHFHag1k9?=
 =?us-ascii?Q?YToo/durFjKcMyttQTyOt6Zw16s0mRChw+gFyNp8V1VckC8HzAcXWbllaWVV?=
 =?us-ascii?Q?5EKsq/JOaa06g1qIsPinxcNQ+SQ/dVurEcLmPNKW3PtFgHGqaWxvE6KLVk6q?=
 =?us-ascii?Q?xBZwkI8Q7yFy76ZGfL1+CX6/4RlObd7/CRY4tIYYbVR+nQlGDFEPdmjFvktz?=
 =?us-ascii?Q?DN7/sq3oQ/OPS3+sli7s7e+i0R/NiEfByGIpZaxD9Zh30s5J7U23ksDMSgsc?=
 =?us-ascii?Q?BBJWKGo6UJxchJoy6eHevhqi4l3kxlk9WHrAUIKPcsWKP01BJYDYPC8By1QP?=
 =?us-ascii?Q?x/cZddab7hdBjl5gOUMht4jWlnzlguaD2neYjSRgSNu9G1FxcyVtBsSL0G3S?=
 =?us-ascii?Q?0QNmpAzTjtqCYZ6KC9SpPwOH+hQitXw5Mc/xNz2iKbSQO7wXGfMNZEwRwXwj?=
 =?us-ascii?Q?lf37EOM8iYR51akNRWo5R65GI3HIFMlMapxr2qaxcl9wStWPHXDqwr1rQUJZ?=
 =?us-ascii?Q?l8NlPB1rUg2vD8BeX8GTNuN4GbTHnMw1SSqZtfLx4P9AxCxZiS1B0aO+cNEA?=
 =?us-ascii?Q?HSaPm1WxbeNBcgXPpwBdkQHcxTydn1aEY8s/LXn7QL8yRIVy2GPNi1lxq9U0?=
 =?us-ascii?Q?PIvvFP2aAMMEonAon36Xz/LgsiFq1PxmDsMy3ikb/NDMKWMZKRroGibprgky?=
 =?us-ascii?Q?jdlA1Jl8s0MOIwmYMc2xU2HpyOlSwo2qSqnY8Ar/GbZByHstFpztTyrKoYIo?=
 =?us-ascii?Q?kQ7DHodY1iPzRyJUi+IykNC9vG1KDPtjAbhPudg8yKxgdJ31mNUU9JQuXWlQ?=
 =?us-ascii?Q?iggRz7vaM260JGC71Vv4MTkNYTExGeOcfjfOxFFZiQ84mJ5hE62MoYB4APUA?=
 =?us-ascii?Q?vk+SpaqbnAYN7CGjTwPXiLJvz0jvQVBm4nVuQ5hpR2lnAR9aCJ/779MUik8U?=
 =?us-ascii?Q?e/Nc6jvJN3UZDO1dS07ZtdnCaGdNW+9xHfgIwu9HbxMw/lBErAzil4U48eWH?=
 =?us-ascii?Q?nBWqLN+Qzc+WFG0NblMZbhjvvUxQrbqwGfR/u3dxuNMaDQGQQ0Kmk52hP6Bz?=
 =?us-ascii?Q?zR/wXZAghbAkGSaxMdr9TnaSA89MZu1ElE4f3jVLnjI0EZz3xz8iJo88lzGO?=
 =?us-ascii?Q?5a5dGGrSks6W3mhUNkdqmPiu4XmaRDv2KdkdTd4SLXoU6lbUQZWpueHR9zIQ?=
 =?us-ascii?Q?RAFkJ3EJPrkc9Qcd8dxJx8NsVsAgmFoXKAEE8Z+dhssDF0F8t07ip9KoNvNN?=
 =?us-ascii?Q?OWPtwfT1mhnci/G+4ljCAfuWJhsiFYJMwoVm2xRRhwcFjFMODMEjWT/VwiEP?=
 =?us-ascii?Q?UjRLtQ7ERyCJXus+PEhlNzfVzn6J5VFtNyIp+9/woygmOCFo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50ec11dd-a340-4220-7073-08df183bcba2
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 23:55:20.9935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fk6NY6eTPq8YLmz5iR6Qy9CnVduzK59rTHpd5zTLEnrXQnluFYFtI28o4OvMj2RJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

Store the required cmd data in the tlbi and just copy it out when
processing each item in the invs list. The cmd form only depends on if the
instance supports range invalidation or not, otherwise it is always the
same.

This avoids redundant calculations for each invs entry.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 147 +++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  12 +-
 2 files changed, 94 insertions(+), 65 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 703a4ce562eecd..b7c9cd074924e4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2518,12 +2518,12 @@ static struct arm_smmu_range_inv arm_smmu_range_inv_init_end(u64 last_tg,
 	return range_inv;
 }
 
-static void arm_smmu_cmdq_batch_add_range_inv(
-	struct arm_smmu_device *smmu, struct arm_smmu_cmdq_batch *cmds,
-	struct arm_smmu_cmd *ref_cmd, bool leaf_only,
-	const struct arm_smmu_range_inv *range_inv, u8 ttl, u8 tg_enc)
+static void
+arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
+			    const struct arm_smmu_range_inv *range_inv, u8 ttl,
+			    u8 tg_enc)
 {
-	struct arm_smmu_cmd cmd;
+	struct arm_smmu_cmd *cmd = &tlbi->range.cmds[tlbi->range.num_cmds++];
 	unsigned int tgsz_lg2 = tg_enc * 2 + 10;
 	u64 iova = range_inv->start_tg << tgsz_lg2;
 	unsigned int num = range_inv->num - 1;
@@ -2552,19 +2552,16 @@ static void arm_smmu_cmdq_batch_add_range_inv(
 	if (!num && !range_inv->scale && !ttl)
 		tg_enc = 0;
 
-	cmd.data[0] = ref_cmd->data[0] | FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
-		      FIELD_PREP(CMDQ_TLBI_0_SCALE, range_inv->scale);
-	cmd.data[1] = ref_cmd->data[1] |
-		      FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf_only) |
-		      FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
-		      FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | iova;
-	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, &cmd);
+	cmd->data[0] = FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
+		       FIELD_PREP(CMDQ_TLBI_0_SCALE, range_inv->scale);
+	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+		       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
+		       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | iova;
 }
 
 /*
- * Issue up to two range TLBI commands covering [iova, iova+size). Returns true
- * if successful, false if the range is too large to fit into range invalidation
- * commands.
+ * Generate up to two range TLBI command payloads covering [iova, iova+size).
+ * Sets use_full_inv if the range is too large to represent.
  *
  * Normally the first range invalidation is the largest representable span which
  * does not exceed the requested range. If necessary, the second range
@@ -2572,15 +2569,12 @@ static void arm_smmu_cmdq_batch_add_range_inv(
  * is anchored at the end. Any excess coverage from the second range
  * invalidation overlaps the first instead of exceeding the requested range.
  *
- * If a SVA is being invalidated and the SMMU has the
- * ARM_SMMU_OPT_FULL_CONT_RANGE_INV errata this produces only a single range
- * invalidation and overinvalidates to ensure any potential CONT is covered with
- * a single range invalidation.
+ * For SVA on an invs containing an SMMU with ARM_SMMU_OPT_FULL_CONT_RANGE_INV,
+ * produce only a single range invalidation and overinvalidate so any potential CONT is
+ * covered by one command.
  */
-static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
-					  struct arm_smmu_cmdq_batch *cmds,
-					  struct arm_smmu_cmd *cmd,
-					  struct arm_smmu_tlbi *tlbi)
+static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
+				     bool single_range_inv)
 {
 	u8 tgsz_lg2 = tlbi->tgsz_lg2;
 	struct arm_smmu_range_inv first = { .start_tg = tlbi->iova >>
@@ -2591,9 +2585,6 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 	struct arm_smmu_range_inv trail;
 	u8 ttl = 0;
 
-	if (!tlbi->size)
-		return false;
-
 	/*
 	 * Determine what level the granule is at. For non-leaf, both io-pgtable
 	 * and SVA pass a nominal last-level granule because they don't know
@@ -2614,11 +2605,11 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 	first.scale = arm_smmu_range_inv_calc_scale(num_tg);
 	if (first.scale > 31) {
 		/* Range too large for a single command do full invalidation */
-		return false;
+		tlbi->range.use_full_inv = true;
+		return;
 	}
 
-	if (tlbi->has_cont &&
-	    (smmu->options & ARM_SMMU_OPT_FULL_CONT_RANGE_INV)) {
+	if (single_range_inv) {
 		/*
 		 * Produce a single invalidation by rounding up and disabling
 		 * the trailer.
@@ -2634,40 +2625,27 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		trail = arm_smmu_range_inv_init_end(
 			last_tg, num_tg - ((u64)first.num << first.scale));
 	}
-	arm_smmu_cmdq_batch_add_range_inv(smmu, cmds, cmd, tlbi->leaf_only,
-					  &first, ttl, tg_enc);
+	arm_smmu_tlbi_add_range_cmd(tlbi, &first, ttl, tg_enc);
 
 	if (trail.num)
-		arm_smmu_cmdq_batch_add_range_inv(
-			smmu, cmds, cmd, tlbi->leaf_only, &trail, ttl, tg_enc);
-	return true;
+		arm_smmu_tlbi_add_range_cmd(tlbi, &trail, ttl, tg_enc);
 }
 
 /*
  * One TLBI command per IOTLB entry, assuming the entries are all at least
- * iopte_granule sized. Returns false if too many commands would be needed which
- * indicates too high a latency. The threshold is similar to MAX_DVM_OPS in
- * arch/arm64/include/asm/tlbflush.h for the 4k PAGE_SIZE.
+ * iopte_granule sized. Sets use_full_inv if too many commands would be needed
+ * which indicates too high a latency. The threshold is similar to MAX_DVM_OPS
+ * in arch/arm64/include/asm/tlbflush.h for the 4k PAGE_SIZE.
  */
-static bool arm_smmu_cmdq_batch_add_single(struct arm_smmu_device *smmu,
-					   struct arm_smmu_cmdq_batch *cmds,
-					   struct arm_smmu_cmd *cmd,
-					   struct arm_smmu_tlbi *tlbi)
+static void arm_smmu_tlbi_calc_single(struct arm_smmu_tlbi *tlbi)
 {
 	unsigned long num_ops = tlbi->size / tlbi->iopte_size;
-	unsigned long iova = tlbi->iova;
-	unsigned long i;
 
-	if (!num_ops || num_ops > 512)
-		return false;
-
-	for (i = 0; i < num_ops; i++) {
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
-			       (iova & ~GENMASK_U64(11, 0));
-		arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
-		iova += tlbi->iopte_size;
+	if (!num_ops || num_ops > 512) {
+		tlbi->single.use_full_inv = true;
+		return;
 	}
-	return true;
+	tlbi->single.num = num_ops;
 }
 
 static void arm_smmu_inv_all_cmd(struct arm_smmu_inv *inv,
@@ -2687,16 +2665,37 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmd *cmd,
 				       struct arm_smmu_tlbi *tlbi)
 {
+	u64 iova = tlbi->iova;
+	unsigned int i;
+
 	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-		if (arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi))
-			return false;
-	} else {
-		if (arm_smmu_cmdq_batch_add_single(inv->smmu, cmds, cmd, tlbi))
-			return false;
+		if (tlbi->range.use_full_inv) {
+			arm_smmu_inv_all_cmd(inv, cmds, cmd);
+			return true;
+		}
+		for (i = 0; i < tlbi->range.num_cmds; i++) {
+			struct arm_smmu_cmd range_cmd = tlbi->range.cmds[i];
+
+			range_cmd.data[0] |= cmd->data[0];
+			range_cmd.data[1] |= cmd->data[1];
+			arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds,
+						      &range_cmd);
+		}
+		return false;
 	}
 
-	arm_smmu_inv_all_cmd(inv, cmds, cmd);
-	return true;
+	if (tlbi->single.use_full_inv) {
+		arm_smmu_inv_all_cmd(inv, cmds, cmd);
+		return true;
+	}
+
+	for (i = 0; i < tlbi->single.num; i++) {
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+			       (iova & ~GENMASK_U64(11, 0));
+		iova += tlbi->iopte_size;
+		arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, cmd);
+	}
+	return false;
 }
 
 static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
@@ -2715,8 +2714,8 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
 	return false;
 }
 
-static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
-					struct arm_smmu_invs *invs)
+static void arm_smmu_domain_tlbi_inv(struct arm_smmu_tlbi *tlbi,
+				     struct arm_smmu_invs *invs)
 {
 	struct arm_smmu_inv *used_s12_vmall = NULL;
 	struct arm_smmu_cmdq_batch cmds = {};
@@ -2811,11 +2810,17 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 		.iova = iova,
 		.size = size,
 		.iopte_size = granule,
-		.has_cont = smmu_domain->stage == ARM_SMMU_DOMAIN_SVA,
 		.leaf_only = leaf,
 	};
 	struct arm_smmu_invs *invs;
 
+	if (!size || size == SIZE_MAX) {
+		tlbi.single.use_full_inv = true;
+		tlbi.range.use_full_inv = true;
+	} else {
+		arm_smmu_tlbi_calc_single(&tlbi);
+	}
+
 	/*
 	 * An invalidation request must follow some IOPTE change and then load
 	 * an invalidation array. In the meantime, a domain attachment mutates
@@ -2846,6 +2851,20 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 	rcu_read_lock();
 	invs = rcu_dereference(smmu_domain->invs);
 
+	/*
+	 * Only precompute range invalidation commands when they will be used.
+	 * The invs generation ensures this matches the instances being
+	 * invalidated.
+	 */
+	if (invs->has_range_inv) {
+		if (!tlbi.range.use_full_inv) {
+			arm_smmu_tlbi_calc_range(
+				&tlbi,
+				smmu_domain->stage == ARM_SMMU_DOMAIN_SVA &&
+					invs->has_full_cont_range_inv);
+		}
+	}
+
 	/*
 	 * Avoid locking unless ATS is being used. No ATC invalidation can be
 	 * going on after a domain is detached.
@@ -2854,10 +2873,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 		unsigned long flags;
 
 		read_lock_irqsave(&invs->rwlock, flags);
-		__arm_smmu_domain_inv_range(&tlbi, invs);
+		arm_smmu_domain_tlbi_inv(&tlbi, invs);
 		read_unlock_irqrestore(&invs->rwlock, flags);
 	} else {
-		__arm_smmu_domain_inv_range(&tlbi, invs);
+		arm_smmu_domain_tlbi_inv(&tlbi, invs);
 	}
 
 	rcu_read_unlock();
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 748becd41160c6..a3f052cc191680 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -829,8 +829,18 @@ struct arm_smmu_tlbi {
 	unsigned int iopte_size;
 	/* Base Translation Granule of the page table */
 	u8 tgsz_lg2;
-	bool has_cont;
 	bool leaf_only;
+
+	struct {
+		bool use_full_inv;
+		u16 num;
+	} single;
+
+	struct {
+		bool use_full_inv;
+		u8 num_cmds;
+		struct arm_smmu_cmd cmds[2];
+	} range;
 };
 
 struct arm_smmu_evtq {
-- 
2.43.0


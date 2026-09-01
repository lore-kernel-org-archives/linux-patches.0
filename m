Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013003.outbound.protection.outlook.com [40.107.201.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05EE4908A1;
	Tue,  1 Sep 2026 17:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788285021; cv=fail; b=MIKFgj1RlcWpCBILP11seQIkTRnBxUVd1mEaJnKuptvo3iXDbj4RZjPW3BY2zstkHLBNP0Bf4m4z4Z3A40A0pgx1GqG/vyjZba5//pdEWZAk+PQlpJ5cEqXsXyy9lcDi8iTgdmV9oahu6k553nvU/60SFSNjnaqrp40Mf6518ls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788285021; c=relaxed/simple;
	bh=SW242w9wpOcK50eE580vxMzEnrJAh/8YvmcTbjw/NbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rf4YvxNJpPqYc/nCcp7EkTgDQbJsn+U0Ziku0ZVuLWJG9U1Ms4pNUBZgoDx12CxYb5U7Pc66nGMwhCe2T23S+wIGLkLNZ6J00uMG3JkM8fcvaVat37fupXWjphiK/BlLDPOZF0rKitMZSrK3QiI4McAjklJ+FsDmeWAYhCX94q4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fWrP0Sno; arc=fail smtp.client-ip=40.107.201.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fWrP0Sno"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mpAt9qhV4Nt1YBioGSkuy0vJFM/VaFdAhIuvu9ZacPF8Z3z4pHsLspmbWEyuMs+lm1h3w3Y5UCQ0SuHxiXuIZX2r2TkeB9VDl33h33gn0LFJw7o/YMDkuVkhmutM7otNzIqDoa222pIcZz6+SFd/cBNk1jMsgMgS2Sgi+9bsajMbaeo4U4glT4Xc+qI35u0vNCgbW0QJHiKeaaIUYYYg9abVZ8MoP1DIXAgfXNTUs4Td6m62Qxi3IDzapZNXxpsuDBrCapCt2rZngCDJPX2d/Dq0309B4EGzbHsHZJAxUZe1kbdNuSph2UD6T5R39k2jmvB0cSm4hypmhRBmpQkrWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kUxoLCooXx9rWDp99pd1DJ0kjseQRsBtnGkC6GmpM1Q=;
 b=Zwgfwu4UgXyz+19Z1spnlKlV4fn4nRoAogCsi6WGif7nj5FYA376mspjvs7OyQzcRgGMTajlvX5T48/2rhk7GlvG4sDVUMw3JitjS51DS0z9v6PHJFtOzqAvqTH2OHkFUMemkQNQ3IrazmLt/5ZtdYKPACfCJ8zFbGA2YV/YtFICeF5/RRnEkHIrSo8MormydxhEAVJ0Mywo6DdHhJrkd5PnlSOT2tZlSNjn1zoxezld9sRa+pNa4OsUAkyQGXe6rrnq9bICXQqNHarI+9hQFTndJOY87o/3e7uJyd+A+wAsISFXzI/gbCit1NtFYOt0rdMTY5M4a6NZqB1vJzAV0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kUxoLCooXx9rWDp99pd1DJ0kjseQRsBtnGkC6GmpM1Q=;
 b=fWrP0SnoG+0fmRzjl5uwm9zZYLqG79n0MK1p3ykaKXWl9XG9M6p4ki55UVdQIoHasGhxhReNRdKn4gLzi+fJIrv7Ip1y49NeXRAJcTJKAzp+4PnI0XssWk6CuZk3YMeEvkpvR4wHxXMEFV1BvyLoodpk4M4aWQdruKv4xqP41qo+DbFDZMTrnPdrUFjDNRIhv9uM90w7TPbdrrxMSb70nkj0TQJ5OplwyghhEHe/Qr5dtLRoJJlWO8pLRenmlbAiNH13922WoID9wIA/yCnxk4o8rbJnyWT0p1C90A/tMVOwqtssXBsh08kYvnbihSh2t3w6DYqxCYoe4m+Brkl7Qw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ2PR12MB8848.namprd12.prod.outlook.com (2603:10b6:a03:537::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Tue, 1 Sep
 2026 17:50:05 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 17:50:05 +0000
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
Subject: [PATCH v5 6/9] iommu/arm-smmu-v3: Precompute the invalidation commands
Date: Tue,  1 Sep 2026 14:49:55 -0300
Message-ID: <6-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0282.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::28) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ2PR12MB8848:EE_
X-MS-Office365-Filtering-Correlation-Id: e75711d3-a911-4ded-6537-08df0851729a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|10067099003|11063799006|56012099006|3023799007|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	aZWU8DYRa1CEtbRM2X4B51QDO8UGyVxLh2E8h1r85a4iJMYZKLpQsqSsbTCG524DJnBT1DXOzVDMYjqSJKF+TgY6wHfPLWrf/oh3uHgQY358pWjr2tMLZPKh5P/kllNX9QIuM/nQsACav0z04qU4nr8p4aipTiqmCwc1jcfSPYXxupKnmdCPP4VkUmkzoM/XCUYpTze6gIcGYA0cm4JgEIM10KFALr+sgWkS8KJ156luIBcv98mbQgE9xp6mur6mAK3DR9xnzyPkeVQkApYISn6pOGJQVQrt9SmJYt7V7WCYsMJJaQld5PFozsa6MhDwDhHri/Q7x1XeoS6EaDA1YwJ8Kkg9ERgSvDP+wA9NDF3fCjVqwxkHSRWskjGi84Lun9P1P2riCaUbCtxXVsyqbDZB5bzAjtYGiQ32LtcBU/1Sw7M7bZTF+h2K9WHMILPMUq3W6IOjmW7i8vnU+levPsh7nLe1UJF6PlEDr2d0PYhzEt/JjSGV88THNYxPLXxqDidXfDDZBmzLFsWJrJ+T68Otd+CBA948ZQu6E+5FxhHu9UqIA45w7mtya1ODaKeRpAjxWMQy2OrmEvCkpMAnOCvx4/Ml+dWZ5Q+sny8m5BpL+sPx6YBg/fvx3NpqefFxxcN7/H/yCgoG49Z8O7Pjx3Ysf76A9QYGNYQplpgIZptWr5zDt8fMh0weYz7xVgnoJmkgxCRVnrD5tzaEF7WrBg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(10067099003)(11063799006)(56012099006)(3023799007)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oUUyguADhfNgnoo0yU7kJbctryI0fJ1vsZNy4nIB8aGC5+SQdpqPNShx+Lkj?=
 =?us-ascii?Q?2VagXhhgFgDTae22X2TJnKwARaDY0bsuH774js74FGhiUVtjwTlYlbtnICWv?=
 =?us-ascii?Q?bMslsvL40Ike6A3N9ges3hvV3jDOMz2RzfQVdAHlI9taLTcBqI6/rkCRmJG3?=
 =?us-ascii?Q?iLP8sAMqMPuex7EJHhEl/3BsN01wVjJkWNqF6uubb+ClUU/TK6hLFjaEnFvc?=
 =?us-ascii?Q?38hPxp7O0VJFTQqmO+Oq8gDkegqJHns2JVyszYoNzgJv+IUh3kUsKIqJyBeW?=
 =?us-ascii?Q?4lrklLG7OqE/zMxW+ItYa9bgFobP+aJ4mEbCCP3Q1quqMkcZVieE2QbDkhGL?=
 =?us-ascii?Q?Uu6/34U7I08eD2NXLzNqShwlAhhiZlEdDQDucZMaaSUE2QKIicFE9NF+Q4vC?=
 =?us-ascii?Q?J4KOlT1hHnlRhYVaTR3cTwLQhJx+aMMfUxQsR62rSmtpJyfWP27X+n4fDheW?=
 =?us-ascii?Q?SLs/iUD5d2KnY39fVpE71Kft+vL9ZEmM48IitSqvPAVskLxrQBo8PwiiMSUp?=
 =?us-ascii?Q?bdel9o55sSiF4wtyOJpVe7b81XbR+1oEzvuXZY+Lk9O0yqaE7HqaF+tyswIW?=
 =?us-ascii?Q?mpx+qlUxbWxWOkexlEM0yVRb6ulVGA4k/gYbuDULlMiM+K1xEAocpUItglSw?=
 =?us-ascii?Q?3QgYV7H9jsBwy/DMOhwBgsHRYumpRp3A+p4fVDyq9D8TgGD8a428yb3fKwvz?=
 =?us-ascii?Q?A+umobZ5eqaZb3YXiKYCOvMpKyVzYYPQDlzN1XeZBNEBJ0anGcJFEFPKrd/u?=
 =?us-ascii?Q?cMuc+CeIXB07SkMSZFsOnHJN6ii/2BxAchPUffvvMwfRRzoI+wy2gOH/ZHxO?=
 =?us-ascii?Q?6MyhrRxCxcHu3f/bR4G9lDFQ9hJgUNw9pQGKsZ/tjfcTP8HoXnu0YUjzRYe4?=
 =?us-ascii?Q?RuqJr1T1KeB4mStlj6mlBPGvNZD4y1NQnJ53c0o/sCYrtxqcfu4wSZJW5/ou?=
 =?us-ascii?Q?+hEDPi2TwtjQy8exsQ+zpvE8MhFJ9GDZDinufjr0kiV7b0ezZE6w6Ehl0uMe?=
 =?us-ascii?Q?mlNUXUAt0g+acBJYUAuNQ44LSTsSNW/iwpKQrn1eqLAV6BeTHGZZvhAc1B6P?=
 =?us-ascii?Q?oeDpIfZyZBZIJArqd4GCd/LySr7yaDafH3r70OLJZydTUHHZ4nn9vCCRJUCo?=
 =?us-ascii?Q?N838cWxz9T5hMdyu/fRcCGeoRwuloTfUqjhdfRDwG5tFrkCxHILNwYL0HBo3?=
 =?us-ascii?Q?c1K1EJ0HEtGWsl3yMMFSf/9TH5P26Ocj4huop3eaM9nlFLLZ16ZJRWs4Z80d?=
 =?us-ascii?Q?q4+RPxd19nPMjy8zc68rS71d2v4BNSS+JfHE9r1umTAxM6MMVlOZ1BuKW71P?=
 =?us-ascii?Q?Su4tKMfQ1rRklQi7WCeU/0PfAbhxkzNDKi4mWkcvq2ySizXFZzbCntdG9882?=
 =?us-ascii?Q?pZmZOthDGv2gpJB4Qo64NxQ5xQnoShuyPXCCFQ/V47KreRXWfkWl0KSGXclT?=
 =?us-ascii?Q?fdzcob3Slglvbz18GVr20P6rwsApblmJsWXrGgRZODZ5mYrTUdLVfFrzC99c?=
 =?us-ascii?Q?lO5qFv3noyHAnhFesCbbo4fPotDnA8q+IgoK9QVTXgMNA2mkYmNbXm5b6L/4?=
 =?us-ascii?Q?zRAnrIs/K6Ku9RwjGbD/grtzYr/5hGrwa64jLp1XZ5z8v3quwisXpe2Zwavr?=
 =?us-ascii?Q?Y30Xj3XflV/Qi19xYSDgad9uyC+C4TmZiEfjMHU4bNCayrhm6lGo+u3fLkyT?=
 =?us-ascii?Q?G7nZlrkTegwT4qI1bzlvHddo6zLG0DM6x1ITiaedjD1tL94l?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e75711d3-a911-4ded-6537-08df0851729a
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 17:50:02.2642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NsjxMMB6BEVguSAnPoX7OHHcInjdaLPJhlkn/OumzaSw42U2Ye1p7AGHVz/e33j9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8848

Store the required cmd data in the tlbi and just copy it out when
processing each item in the invs list. The cmd form only depends on
if the instance supports RIL or not, otherwise it is always the same.

This avoids redundant calculations for each invs entry.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 141 +++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  12 +-
 2 files changed, 91 insertions(+), 62 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 68dd7b69392737..883dfc584ed6c6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2506,14 +2506,12 @@ static struct arm_smmu_ril_range arm_smmu_ril_init_end(u64 last_tg, u64 num_tg)
 	return ril;
 }
 
-static void arm_smmu_cmdq_batch_add_ril(struct arm_smmu_device *smmu,
-					struct arm_smmu_cmdq_batch *cmds,
-					struct arm_smmu_cmd *ref_cmd,
-					bool leaf_only,
+static void arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
 					const struct arm_smmu_ril_range *ril,
 					u8 ttl, u8 tg_enc)
 {
-	struct arm_smmu_cmd cmd;
+	struct arm_smmu_cmd *cmd =
+		&tlbi->range.cmds[tlbi->range.num_cmds++];
 	unsigned int tgsz_lg2 = tg_enc * 2 + 10;
 	u64 iova = ril->start_tg << tgsz_lg2;
 	unsigned int num = ril->num - 1;
@@ -2542,18 +2540,16 @@ static void arm_smmu_cmdq_batch_add_ril(struct arm_smmu_device *smmu,
 	if (!num && !ril->scale && !ttl)
 		tg_enc = 0;
 
-	cmd.data[0] = ref_cmd->data[0] | FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
-		      FIELD_PREP(CMDQ_TLBI_0_SCALE, ril->scale);
-	cmd.data[1] = ref_cmd->data[1] |
-		      FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf_only) |
-		      FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
-		      FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | iova;
-	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, &cmd);
+	cmd->data[0] = FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
+		       FIELD_PREP(CMDQ_TLBI_0_SCALE, ril->scale);
+	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+		       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
+		       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | iova;
 }
 
 /*
- * Issue up to two range TLBI commands covering [iova, iova+size). Returns true
- * if successful, false if the range is too large to fit into RIL commands.
+ * Generate up to two range TLBI command payloads covering [iova, iova+size).
+ * Sets use_full_inv if the range is too large to represent.
  *
  * Normally the first RIL is the largest representable span which does not
  * exceed the requested range. If necessary, the second RIL is the smallest
@@ -2561,14 +2557,12 @@ static void arm_smmu_cmdq_batch_add_ril(struct arm_smmu_device *smmu,
  * excess coverage from the second RIL overlaps the first instead of exceeding
  * the requested range.
  *
- * If a SVA is being invalidated and the SMMU has the ARM_SMMU_OPT_FULL_CONT_RIL
- * errata this produces only a single RIL and overinvalidates to ensure any
- * potential CONT is covered with a single RIL.
+ * For SVA on an invs containing an SMMU with ARM_SMMU_OPT_FULL_CONT_RIL,
+ * produce only a single RIL and overinvalidate so any potential CONT is
+ * covered by one command.
  */
-static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
-					  struct arm_smmu_cmdq_batch *cmds,
-					  struct arm_smmu_cmd *cmd,
-					  struct arm_smmu_tlbi *tlbi)
+static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
+				     bool single_ril)
 {
 	u8 tgsz_lg2 = tlbi->tgsz_lg2;
 	struct arm_smmu_ril_range first = { .start_tg = tlbi->iova >>
@@ -2579,9 +2573,6 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 	struct arm_smmu_ril_range trail;
 	u8 ttl = 0;
 
-	if (!tlbi->size)
-		return false;
-
 	/*
 	 * Determine what level the granule is at. For non-leaf, both
 	 * io-pgtable and SVA pass a nominal last-level granule because they
@@ -2602,10 +2593,11 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 	first.scale = fls64((num_tg - 1) / 32);
 	if (first.scale > 31) {
 		/* Range too large for a single command do full invalidation */
-		return false;
+		tlbi->range.use_full_inv = true;
+		return;
 	}
 
-	if (tlbi->has_cont && (smmu->options & ARM_SMMU_OPT_FULL_CONT_RIL)) {
+	if (single_ril) {
 		/*
 		 * Produce a single invalidation by rounding up and disabling
 		 * the trailer.
@@ -2621,40 +2613,27 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		trail = arm_smmu_ril_init_end(
 			last_tg, num_tg - ((u64)first.num << first.scale));
 	}
-	arm_smmu_cmdq_batch_add_ril(smmu, cmds, cmd, tlbi->leaf_only, &first,
-				    ttl, tg_enc);
+	arm_smmu_tlbi_add_range_cmd(tlbi, &first, ttl, tg_enc);
 
 	if (trail.num)
-		arm_smmu_cmdq_batch_add_ril(smmu, cmds, cmd, tlbi->leaf_only,
-					    &trail, ttl, tg_enc);
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
@@ -2674,16 +2653,37 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
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
@@ -2702,8 +2702,8 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
 	return false;
 }
 
-static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
-					struct arm_smmu_invs *invs)
+static void arm_smmu_domain_tlbi_inv(struct arm_smmu_tlbi *tlbi,
+				     struct arm_smmu_invs *invs)
 {
 	struct arm_smmu_inv *used_s12_vmall = NULL;
 	struct arm_smmu_cmdq_batch cmds = {};
@@ -2798,11 +2798,17 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
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
@@ -2833,6 +2839,19 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 	rcu_read_lock();
 	invs = rcu_dereference(smmu_domain->invs);
 
+	/*
+	 * Only precalculate RIL if it will be used, invs generation ensures
+	 * this matches the instances used for invalidation.
+	 */
+	if (invs->has_range_inv) {
+		if (!tlbi.range.use_full_inv) {
+			arm_smmu_tlbi_calc_range(
+				&tlbi,
+				smmu_domain->stage == ARM_SMMU_DOMAIN_SVA &&
+					invs->has_full_cont_ril);
+		}
+	}
+
 	/*
 	 * Avoid locking unless ATS is being used. No ATC invalidation can be
 	 * going on after a domain is detached.
@@ -2841,10 +2860,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
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
index 4b9f04825eefa2..33ef99775aea87 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -815,8 +815,18 @@ struct arm_smmu_tlbi {
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


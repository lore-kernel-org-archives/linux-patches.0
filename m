Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DE213475B;
	Tue, 23 Apr 2024 13:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713878071; cv=fail; b=BbyJSdpHoeVzfqRetAeYv1rPZqfFs7r6QewPPkWOj/LlEg6ob1U+xbnLQGgorlSYy0olpw81WVdT97DrjIfQZKxfHybNTBBiUur99PICrnvG2YXUIRNIuw4J/uOtWWfmRQcBSelC8kl1nypSlmzy+UztJ4V2AGOawhVF56+8Lm8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713878071; c=relaxed/simple;
	bh=F4IDxTp26RTFCCz8kV7tGKME1MMLWawjnSd626TBHUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FDqaCmL+n/h5BAwUyybuIzu6muLKAaYE+mDuINlKlZxh/jmDkrZ1Mpx6TEwDSea0wleTPfBg9bn0vPEhEB4KRwE6xDehiD6nB9SWIy0IOo2lEuyDFAOqF0mLKPMbCOiwoPACWa8m63+aMG487qxSOikgS+rWYgldLQTRjwC2rk0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kDc6HCHc; arc=fail smtp.client-ip=40.107.223.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kDc6HCHc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmnR9NHhVSLsBT75VhqDNwFDXjmBZSyhK8qF+TmwN+vkvJOq0/J1ExWYnjU6K3CzrKJdVT2JFd2Kihn4BToPZrFILLqigXWWgoS1lOtqO5V13t0Spx0furwZEtgLjPMuRFWyadiL0tZIU4spdaxGLZFdJ3g7VrFgJR0eNvAejglYyqhrgBTfxkoV8V5TX2yK9ghiSe4SFNb1y7DhgUx03LiS9FwP4tTTJdUDGtYuhV4bGDs9JWv7dRMR3bJJ2mpjkqTzvoBf6YyPXjVrRoXb02jv8MAA4sQwCX+yLNoxOQp2ZFMYskBN6PES8NlGK7JjbVClZhclucLOAUQsnn09gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4DFXjXcl6ss7JHBoebzpfIH6ZQzLNJqPhUTOdk2wf0c=;
 b=ARp3PIsWNM392+aFePkx2fvjszCPm2WtQkuTfRY/HYHI4Wh0W9HaUi51F/F3M5pV0g0zDmwc6GUW3/pc+0oV9ugZYlNKeTxWWQQFx3uQkrSyhGOkwgrzBZh6Sx6oHNoRp2dgG/ygsE5AiMfvRDQ87Btyo6Q464XEyz6XAyZw/l/SNUpc5VWE8802V6ly5R/YxjKJ4kEbBoCcs4FU0zadMfE1p1kX0NGF3SdB5UQ075bW9941JAdL7Rn0GbeE1bx7KTCTmvBf5s2e/KDFrnWIRBZ5+LVE42Eb5M+8YrDlqV274TCcO9M1W9Q8PGMJ5zhU9UDS9QbwOpWSsxCG4iKTig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4DFXjXcl6ss7JHBoebzpfIH6ZQzLNJqPhUTOdk2wf0c=;
 b=kDc6HCHcIiNUoTagtgvH14L4hPXIsGV7ZRCRRlbPzqjUmeWKe9NCL9BSj/QHgyq5k3aqO0X3iUVFexjEAdvFvkX62vP9mkVDjEf1vqlosoj8xabdi1C+21DUiEb+LmlSECtTFndrWy8dw0I+1DH8GiKy85ZWmrJ+L3oxFMtIriJJoVH6Q8fZa3Ip4twWlDLduWO2eyMjke1hFuoW/Av/YhsAYlFElaSReJdaidmWEkF7eoB57vzJrp5560Gs8dGL8k5hqR4Qx4x/Cuu0SE0uB5ig3TIFkNX5PwumzqSOITycZ9Yb/1RRmtxwPWuxTO+VqKkXVacrML81qq48MgBcBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB5672.namprd12.prod.outlook.com (2603:10b6:806:23c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 13:14:22 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 13:14:22 +0000
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
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v8 5/9] iommu/arm-smmu-v3: Make arm_smmu_alloc_cd_ptr()
Date: Tue, 23 Apr 2024 10:14:10 -0300
Message-ID: <5-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0008.namprd14.prod.outlook.com
 (2603:10b6:208:23e::13) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB5672:EE_
X-MS-Office365-Filtering-Correlation-Id: d9c075f1-531c-4b6d-57eb-08dc639746b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7VEjj8lv1Rz0BrqVRdc3PG8MeSdGQhKGb0upfZM3CJLn7n6p4BYlmI7PXmr7?=
 =?us-ascii?Q?E+Lbl724gCDVVZ4kM7jP/eeb9w95eylhU/slXQR0rMRFuZn5+AHNsdqAsRI2?=
 =?us-ascii?Q?3xwF7126XeGVB48TzaMYG79RRr/uOfqWdSAWOFkIazKQRfAXtbewN5ewStH5?=
 =?us-ascii?Q?io/s4Q+vllTKREHVhfI7+TsQtuNSyolYGgQSsxhUXyCeoj8Mc50NWZ9NcTkt?=
 =?us-ascii?Q?0XVkf+WkvG/nlRDnLpW9f5/rHmasBvv0zPx7RcJnmgAFF8NLs7z8/BVI301+?=
 =?us-ascii?Q?yiRQipU7PvTgelOdDvUdYfRVskw14Z3L53PtHmo4Fii/ZQuI78C8l56mrZVb?=
 =?us-ascii?Q?JbWfP+U4LJ+jeSe7LAWaYAtOFg9Cine36bKC+Kn+/C/m+EL6WNzPVG+jgzZx?=
 =?us-ascii?Q?oV0zfmhr52jGS15DPCqbYIV7mdPzl5RcHlnKxCcMqUYg37K3tgKejE92ovwq?=
 =?us-ascii?Q?pvoZlXN36exHSntnx85AjbOYXUivOcgmHGUOpY2ElyyE4UQy4y+xYK6mAk7t?=
 =?us-ascii?Q?z496OBWhuKmfHeZa/qBmg2+N/DIw29f3Wwecng1H0D4imVBwEo5+oKLRxE7m?=
 =?us-ascii?Q?WGikC/w0+8nTNzx/0TIolz78XMzt2WbpnpP6gajkcG70NgzmZUEW2SD6cjtj?=
 =?us-ascii?Q?JN0Y6au7FITgfieHahSBDi9lWJT2HbmQWnguB/7WJApw97BRC+jRIcSYekIh?=
 =?us-ascii?Q?cukPUSB/KJCi6rfjCqJIgAbRJRmpEGs9i0rxnA71JmksQYypJj/kbGcGKw6F?=
 =?us-ascii?Q?0ieKOp+xpjBVrTH61LjIt+K1bE7rbaZxGZn8CRlXmSCku86v20Em+MoPLwd8?=
 =?us-ascii?Q?qcTl6+02qORhxxO/4e3yrkhbm7Nn8lnLXCMePmN6i1huvmup5mtW+mgXFqHf?=
 =?us-ascii?Q?7uVIM8qEMOzYKSkUf5E994j8uViKdzaR2jBaNs10ocUL1152IGpCgFL8RzjU?=
 =?us-ascii?Q?Mv9blIpDfywXkff825yoFfzH9Zjf47AQ2hl42AFg7UmvnmKsodsoXO0jdumi?=
 =?us-ascii?Q?ddiCsYmdRFzH/ON/LfNhfGLzuG9eO1mys++o+Aw9DBHysGtSeXeuFjCEPNXL?=
 =?us-ascii?Q?zG4KEaySZD7PpJpucA8uS2JClGHcBHQVPG76NUGeDLTbChnXZWkVIiFiwBXR?=
 =?us-ascii?Q?rFm9dz9zDEsWDZo7h0KcmjcUXHW2dRJ4xht4f4Va3KtTgbAE51fN7m52l7Uz?=
 =?us-ascii?Q?7wObqJ9e+6/h8AEpsSRM/61tL4eiyo7Iht4Mc9Dj7ZQUd1oIW8LREitskyI6?=
 =?us-ascii?Q?+3V0YAL1869oGOPSQi/kvPi+sUElspU6B+uboVGTQw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ez5ljKs6QW66ugjjJ7Ash2z/8TtgIeU4d7asC4lvRkgIQPcF1lX2ytjLwAKM?=
 =?us-ascii?Q?lVseCxc5iTVXKx06RBNUbaSwUG1p9ab9xGMfvAy2m+GBHifJGuptL3b1TtlU?=
 =?us-ascii?Q?ap55/c3UqxKkMmwdBDVvzGIL62X/ubMwFk/foz0I299t6YqNxNoCI4EM5T58?=
 =?us-ascii?Q?ZfZiv1CfLyC0SCsXsOYWhfkgDWQl7be+XbtOohWeNYK0st1ukR7WBPCxfCaJ?=
 =?us-ascii?Q?u/9Q/PjNfJVWWvM9O1sbXTRHtzN0PSkItHtCXsZxzPk20ySpd1zuxjDgWLYN?=
 =?us-ascii?Q?oU/5S2Uac8vlW1oCj/gA7zfIKu0s8PzBjAOFlsvVGVQm4/4KnnGWE3AFS46S?=
 =?us-ascii?Q?qfA1gHo5fdQER1PjVyArqYPDDca6EGS3UBQB0S1tir2J79h2b1eGNvergmQs?=
 =?us-ascii?Q?2DQHrJjlL/PiP+7xSPiOuRwULcY5t7WldQgM3nV9x4jmgK1yTBvhAbbdMQHC?=
 =?us-ascii?Q?vFuOPsEVPffesxBNF54aY/pPoS373z/TYMg/W5jamJnMzjUnn56w6+O2jsQN?=
 =?us-ascii?Q?VHNPSUwNL4qfMDJafJ92JVFw00w36oP3b1QGYe7N8h6aSODoeB9SvD5rSIxe?=
 =?us-ascii?Q?dFhsnQ4dOQRDVZBNC91xBkHPiKVUgKHlJfkxWSa4psaofbGa5NfgaF1zTf1b?=
 =?us-ascii?Q?rQj8vPlUSBFEH3CMY58kb4RfvbPtAuQUsqu/PnJGEqwDaMGJmhrNBg0Cy9be?=
 =?us-ascii?Q?g13owXguH26YYpVj2q4hWKkVBhMY3Z10kJbMRQAmIDeSXCxR79ZVyxHuKl7a?=
 =?us-ascii?Q?4aju5ZaPB9WUjS0lERNHE6fr7nMB2SYOqkpGzibo116V8L3KhFftoPh/+ffF?=
 =?us-ascii?Q?oAKhZ5L+IfxD7MyshJDJjb0x4bDqqipBZhWPZ94rg2kX8LqKmNI1FsJnyYoY?=
 =?us-ascii?Q?KAoBSCBMohmuDG9HMnVhi4MazMcIzeVYc0AEnuQ2KQT+oBGX6gKpffEa3iRM?=
 =?us-ascii?Q?CQ4kkvs+ppvGZ/RW4/wagBMCtuXlbQF3+S1OTdkJqeNfTl36u3DP7uJB7p5w?=
 =?us-ascii?Q?JOuA7dSIwOCBxUTkp3Q/PPWBblKuS3Y9/nLMLdrurTS42cQhnP4IimLmMqkz?=
 =?us-ascii?Q?eKdK0aGIH0QTqi/DtqY4gudcy4KxVd8GlTgYE7OICfvoPmtLirQZBG5x/XZi?=
 =?us-ascii?Q?6PZkBL7mO7AfudPhrgD2G/NY/qn/fe47jQPpV7+bx3c63wXGcIKqhcSvbMZj?=
 =?us-ascii?Q?SB38UxlJgoIO0mui3qsUgovoqGTFqBK2Te+CPQT9KOjLs5ytKHev3NFgbYp+?=
 =?us-ascii?Q?G5ng6PyeB9ZZZK430iYG/hJ9idW+LVZoyIKdN70LHIQftJIWjcwTNWD+NzjV?=
 =?us-ascii?Q?p/e1zdBZsOV4m9lT7MFE3q0wtMuaOh+lqmhpGoHJ4vAsd/lq8Zu/clQl/Rw+?=
 =?us-ascii?Q?PMxMzdZjuoje1L4Q/fOntHn9aBJXOITo7rHEv62E0VhMnEtYQkcRyOMJyxSr?=
 =?us-ascii?Q?rOLhVeQLHyIoi1PLx06T6vzLO6DfmCNjf3TCMTFEi54JsT9n2Cwn9uZBkmKM?=
 =?us-ascii?Q?F8R8kH2U+rlmLGRMkA+KFSqhbY4KUPlcjrYE3r5BeKglODOeeTEzeExmge0b?=
 =?us-ascii?Q?pXVj4RlZqvwPi6DsCeMjp51K6rwcDAeQpVOEG5Fk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9c075f1-531c-4b6d-57eb-08dc639746b6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 13:14:15.8414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SYFcRJXzFx2/TKfeo7jtTstwigzWV32gnSp1b5eUBDolqm74rRKd+92k6fLRiqbG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5672

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

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 61 +++++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 +-
 2 files changed, 40 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 14beba55c32ff2..e8da2f7763d102 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -97,6 +97,7 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
 
 static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 				    struct arm_smmu_device *smmu);
+static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master);
 
 static void parse_driver_options(struct arm_smmu_device *smmu)
 {
@@ -1206,29 +1207,51 @@ static void arm_smmu_write_cd_l1_desc(__le64 *dst,
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
+		unsigned int idx = ssid / CTXDESC_L2_ENTRIES;
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
@@ -1354,7 +1377,7 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
 		return -E2BIG;
 
-	cd_table_entry = arm_smmu_get_cd_ptr(master, ssid);
+	cd_table_entry = arm_smmu_alloc_cd_ptr(master, ssid);
 	if (!cd_table_entry)
 		return -ENOMEM;
 
@@ -2673,13 +2696,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 99fd6f24caa818..c5c55d3e281865 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -275,8 +275,7 @@ struct arm_smmu_ste {
  * 2lvl: at most 1024 L1 entries,
  *       1024 lazy entries per table.
  */
-#define CTXDESC_SPLIT			10
-#define CTXDESC_L2_ENTRIES		(1 << CTXDESC_SPLIT)
+#define CTXDESC_L2_ENTRIES		1024
 
 #define CTXDESC_L1_DESC_DWORDS		1
 #define CTXDESC_L1_DESC_V		(1UL << 0)
-- 
2.43.2


Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BF217BB1B;
	Tue, 30 Apr 2024 17:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714497714; cv=fail; b=snBIsAdn/Jd9s42pvgW2dit4zufJTEB1t02jeiU6mFvzNeHFivO+XeIYnWvpG2Ks26iP5ut+YN3aFzgT+UiBNqYfrj4k1XUAJhVKqEXTPy++adePh9mh8+EonvnDQUdvft6MCBuj+fV5KUuJ9QFNH7zXkxcFJA1u+NTHtvp1Ujw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714497714; c=relaxed/simple;
	bh=oxGR912Tdb5WLvN01leS04cqKxnNnHvxObSB5CNScsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=D5X+Pux94P94DqurRsR0sZq/rFkcfTqkJDw/nuM6Y5J+AKIBy1Pe+VPN5ghYXWQzJkzRi9I899FWdYhuZvZQ4Wqm7ZJdN41noYbGNi3jTb1ygiBM3DcwS7DUK4pkvhq2X7LFWzAOrkqJuD7FDrnpTKY5oR9/1mWsfhNtCC3/qmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NHNOnKoB; arc=fail smtp.client-ip=40.107.237.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NHNOnKoB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NbsnZaUM3j5q1aJ6bB0WWzYzDymC2CFHE1J1edegXZUx/A77kwhGTPKOGNU63Fsw9vMwpmZb+fq84iJsw+eNAHpAV0YVEIblOP6PQsD3v33FAchydf1dYFoM/pdnxJ5Q1HGm0AhRS4bdl0Z5c1dA8+UiebSzjQJ/gNjoWUGgEa91mZ5IlKNbYAPEpocDuEg9ivbYUQwnanXNeyJb7f+BnVy1jUbP9mc6La7Zk0tuBeemmMU26epDVqexK0ef+lfu6iSBtPnmxmE6OcSNXbsPmDBeqvHLQXdKbSroTpa9qDyIs4+KyRQuawWWmZyQUIOeQuCs54N0vum+yWutad2HMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NuOQM+tk1hBYURM7kywp08aMkUjx537isuXThrhYqWA=;
 b=Ap92EnrdsqfOUwPvlLZO4Dm5m9XM9nvyYZvqgtg5IKjTm0wM/kxU3kok6dfso/7nk37eslbS5a4ayiLm5Aa/qV4l4sbczvie98wgZbZkuxVisKAlS84DIb0jta7AgUD3pOSLg+jDDfdOEMn2Chgk3ZSlmLMJHUI9UYcW8wSdAOcFFi/vx0NsFb1aNZZ5yDQwlEtBX+nP/14R8KPhPbe2hQtp/y4ztkC9OU5RsAEK3ZU/4nXWKs0h+2YcEF9jvgMMDhG6qXysdIPlgvZL4SVa4Sd6EcpddfhTMUtgMMkWzK8LHKr9ui/WSrdsSd7UPV4vI2AEmuOW/q1co3yjF0/AYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NuOQM+tk1hBYURM7kywp08aMkUjx537isuXThrhYqWA=;
 b=NHNOnKoBdG5TVKL71VcJ/gP1IxM88C42DEzSt/8oQYC8OUVTb3X09AOzRgyUIKmiRLZbaw+Lne5zgoz1NanukODgGlr4NS7BvYpMWhYlbEX+bqGEy7RihM9IJBwTzeqyRlCEZHY7Vi7n1F18vHLClxN7qKZHZ795/LmX/28HkDB2RWCAgs8KV4LWUs2zRB5y4466iou1Aqgc0AjO0UHcebPyr9s0l3ECcHV9gHH082bfU0dshyiI595KgkCxtYEQAjEqKN/B7M2EVY+hupl4WQIic9xl7OEMptkbmEH3SiDBgdvGpJWeTFNg1BLFjz06b8XOKtTAiWhaf5f/S0uoxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM6PR12MB4172.namprd12.prod.outlook.com (2603:10b6:5:212::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Tue, 30 Apr
 2024 17:21:45 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 17:21:45 +0000
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
Subject: [PATCH v9 1/9] iommu/arm-smmu-v3: Add an ops indirection to the STE code
Date: Tue, 30 Apr 2024 14:21:33 -0300
Message-ID: <1-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v9-5040dc602008+177d7-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0139.namprd03.prod.outlook.com
 (2603:10b6:208:32e::24) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM6PR12MB4172:EE_
X-MS-Office365-Filtering-Correlation-Id: e567b83b-35f3-43e2-f655-08dc693a014b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|7416005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mJRm9jHIgJlHgv700SvHtuO6K45KnnH4C/mHrIttoojFjfU0Sw8mghP20zAL?=
 =?us-ascii?Q?tg77SfYbM2v20NgUQ3AAaDYYx2yt1GFxQzZlzrZd1QSrKV1DCsWicIpTrEPy?=
 =?us-ascii?Q?OW8VEgcdc+ftyh31mTPA3A5XsRpG2HDMd5Z9ezHyAPB7yQiVOV34UV0XmiDD?=
 =?us-ascii?Q?EokbhcRVayD+DSKbWNZKAHAOEUCS6vMFGlMOepOyWoATsZ0Lx/TEdbZSlSSm?=
 =?us-ascii?Q?lF/7ayHR+qLT5kTMWm6Mx5kA2ubZFnJf5GCtRc7n3xiF2yBuxeRj4Lcm/d6E?=
 =?us-ascii?Q?7rCUOrJHzr8FOY2NiShoSW7W7vXOleK/HgQlxebFgRniim7JCRr18jhLi73M?=
 =?us-ascii?Q?1tPMey+7sAfSMjm9afss6jmrNLX4RGU62vovdjn8UJ19y2Kj3Lko5TwCs3bG?=
 =?us-ascii?Q?d9HwcsyRjzsETwBMYaO96t823gqMJSLSuxDuoEIPETQ/vwcgpLmrfI1rYQtV?=
 =?us-ascii?Q?TlGavlCN6TNF3SfpzmdsA/TWlSSvJUE/Ugf42H7Q10qL3W/PVPI88LKGXvFU?=
 =?us-ascii?Q?KG7QYSK/FIYne0iSLzXUHjswASeqnDehjABGdzqvPAClmr+dCti+bcAs9VcP?=
 =?us-ascii?Q?Yz5DGiExpk/xrY8+ag+RANulRb8g8KJ45Sz31ECUF9GiQ1aj/okAe1vL+wUQ?=
 =?us-ascii?Q?qBmpulMk6Hf+nmy+rfpb7E3IaB+1VgWDk25BNJ4pkf3kbL3PdxBEGMRr+/m2?=
 =?us-ascii?Q?Qj/butUtr0yBBPLzfN+/ntqFtIGeJaHMwkIRMBccox3GpG0wljlPsf8B7Vc/?=
 =?us-ascii?Q?8yjqWXlDiCoScQ2qme0Oh/DNwoRf55BUW1UM961ko9nF687K0qkCj1Y87sWW?=
 =?us-ascii?Q?AofGlpnyMJo6n+N/r4NodLqb9GdHJqMbN7bRqQGoY+K8O7T+arXImWdB2is+?=
 =?us-ascii?Q?eZyk/a9T0YtTL4RTMVZR1iqsbpA39EOMsT1HeUWkEBq4JJDiOk9ZDyZwZPiG?=
 =?us-ascii?Q?0f5CgQxcvpw2UramAAjFefDT4fmuy/MKtmDcZdtaca4O6SabZ2aEqF9EgIDx?=
 =?us-ascii?Q?DySV/Aq5E27UAe403mPOtUZOBpyU0hV1V1CQuxuPMGWtoqOc34G4BKuy9LO0?=
 =?us-ascii?Q?zKQZwvhhsNgQ+v2mPX9ReDFu1M5tC0WexrftjKnhf8Q0gfih6n5cD4O8epuv?=
 =?us-ascii?Q?LnFclG57qWQ4r/lIz355Oe/WL84j7oBiuk2PIgtPwg4uWlDEaQ+nMkE8iOOw?=
 =?us-ascii?Q?bwiiGzKQT8oSBFWGm8UjDrGMG11/QZnxtkSnVrkfNSibOSjOlOx57QaC/Mcl?=
 =?us-ascii?Q?YNYbfp9Vsa6Y7E8u461tKfwNGlWMZY3m/NB9npRntA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z+OZzhbyUxpk0cI+d3FR6qSTbXIVmLD9vAsT5W6dbHDK7clEbj2ebj83V5Uz?=
 =?us-ascii?Q?BmurbCGFhLSkQERnkwZGmiKQiuUcLatd2hzTTLwaIcw5ibuFw+NkaquYyvCb?=
 =?us-ascii?Q?3X0rodo+5SQ2VQhTvcv5/7gDP2vwf9QXZ5KT4zWfuaLaIvhvboZVUYSnpRNm?=
 =?us-ascii?Q?nPE1iTHNKSno2SgUjejcmtUfBNFdDXQ5euq7ADiF05DqJ7JdNfq1j+WxO6Qs?=
 =?us-ascii?Q?leAL4ntCwOGFvt97QsVyS+5ZKu3M82Nz/WdSjcc7mP1jFN6uNR1wuv12o++G?=
 =?us-ascii?Q?X+HOiwia52yy0OBnnZIMiGNkjmrxzKL2OuGG3pLqy+w6cAJzuCfkY4NwZNLY?=
 =?us-ascii?Q?3u2vC/+AF/6W4AD3l2PsQBHe4oNto8c35qoK78uS6qlzjO1LakvnsYRsq3zN?=
 =?us-ascii?Q?ItsTZ4Qhp4O3Iip4H4OOparkRsWGCd07U2+3bkaFnJecGcNffcIhARfpH2FR?=
 =?us-ascii?Q?ze71aHBHSzaDNzHSmyf75O5wrgDRNWLb81wO4m1JHcydofgJbxFBSRB8mC3V?=
 =?us-ascii?Q?DhPAgf0pEVZWEPobWqopwCMk9upAhC4H40UDgiwmUc36pRyDDaL5mj8QbEQs?=
 =?us-ascii?Q?0lpHc+v19+eqzaIt2mhVYXxhyh3Bg6Fm0SI2eP+VUewLraezSpg3sEQpUwly?=
 =?us-ascii?Q?g+HN2OdfI7hso7HgHl7jkpLw2q4Rf1Vyjr7EjOMkWOFScwny3w+9SD7Zkp0B?=
 =?us-ascii?Q?z5ggdbSSpLfTOxs5cXK8t9Lqfr9B1q2O4hXiVTNoKMCt2pWblpPTScLjrDk1?=
 =?us-ascii?Q?rsi9p8DjXfLe6ykIIkpSbVGGUbz/kZOXn5n0xL64vbm51CdaeRyRKGLSbrG0?=
 =?us-ascii?Q?KaKKZVwTMl+qtpDpFglmMBbX1XjerPOwhkOum78QwfI3WkciDWSMma/mS+7n?=
 =?us-ascii?Q?pgrnJU/Lv3P2myy02mesowSwo9/syFUPg/uAIJ4N/RnmeRsohfr4kG4MCRFB?=
 =?us-ascii?Q?IzNCQHA1kNNNvoNkbEE1nzfEqELw2/GjImGLaCFaVdBE3C42kFc73niM4XoN?=
 =?us-ascii?Q?cs2phBj4d1fK5eH6mR873wMXxmrIKAZ0Xce9649/TFXovt0m66a7fdgmDeGO?=
 =?us-ascii?Q?nbt+DpJr1LKCNlXsqQIEvL2/uHobSNlBF5lQudtIuN/xWFM1vdb/j1lIVBh4?=
 =?us-ascii?Q?AtFPd6gN1Cy9z/V6zbN2L+php7ePkbhv04hgQEhfaBaJP+BfkZSgtRm+otGU?=
 =?us-ascii?Q?OwaaO2+LhcNNCzBIX6SkvLFAmjPsUOMVVFQbJZF4snZfoxj/Ft04yWtUKdoG?=
 =?us-ascii?Q?SG9nH+5qaQtnETMhfTpSkG0p40+2DjJ9qKiNDtcAJkV2tkXKPRgAE8fJbEZr?=
 =?us-ascii?Q?PV0DO+wAe4SwHJxl341DHoEcOJe5xBuYZ0If8250EUU4NowBeETIS6HbMuoV?=
 =?us-ascii?Q?zmVnGKARJB8KNvKQVrBCoeyAINN7dLCr+zqS6rAaiEdFgUPWoNtbxUMJ6kFl?=
 =?us-ascii?Q?V7WWQRvOnAynrAF9Sdk4/uAstNKWJpydSfxfdTEct4DVx/kzSRrO+bldCqEp?=
 =?us-ascii?Q?P3pLhoBhbl2TGjVXS49hM1eqR0Ep6jZ7JrycqO9Ijd0jFDoYVJIYkdnrf4As?=
 =?us-ascii?Q?cv/O02cGlWVmVvvlNHshRRh5tCoNg9qQCAyvVz2+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e567b83b-35f3-43e2-f655-08dc693a014b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 17:21:43.2833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oorGk7qelFH6JRcmc28o8aMBKMsYVrLfAJeqUVmhfUwk8tuSOe3ncRTzdnVy927t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4172

Prepare to put the CD code into the same mechanism. Add an ops indirection
around all the STE specific code and make the worker functions independent
of the entry content being processed.

get_used and sync ops are provided to hook the correct code.

Signed-off-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 176 ++++++++++++--------
 1 file changed, 104 insertions(+), 72 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 79c18e95dd293e..196aeaf280042c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -42,8 +42,19 @@ enum arm_smmu_msi_index {
 	ARM_SMMU_MAX_MSIS,
 };
 
-static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu,
-				      ioasid_t sid);
+struct arm_smmu_entry_writer_ops;
+struct arm_smmu_entry_writer {
+	const struct arm_smmu_entry_writer_ops *ops;
+	struct arm_smmu_master *master;
+};
+
+struct arm_smmu_entry_writer_ops {
+	void (*get_used)(const __le64 *entry, __le64 *used);
+	void (*sync)(struct arm_smmu_entry_writer *writer);
+};
+
+#define NUM_ENTRY_QWORDS 8
+static_assert(sizeof(struct arm_smmu_ste) == NUM_ENTRY_QWORDS * sizeof(u64));
 
 static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
 	[EVTQ_MSI_INDEX] = {
@@ -972,43 +983,42 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
  * would be nice if this was complete according to the spec, but minimally it
  * has to capture the bits this driver uses.
  */
-static void arm_smmu_get_ste_used(const struct arm_smmu_ste *ent,
-				  struct arm_smmu_ste *used_bits)
+static void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
 {
-	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent->data[0]));
+	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]));
 
-	used_bits->data[0] = cpu_to_le64(STRTAB_STE_0_V);
-	if (!(ent->data[0] & cpu_to_le64(STRTAB_STE_0_V)))
+	used_bits[0] = cpu_to_le64(STRTAB_STE_0_V);
+	if (!(ent[0] & cpu_to_le64(STRTAB_STE_0_V)))
 		return;
 
-	used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
+	used_bits[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
 
 	/* S1 translates */
 	if (cfg & BIT(0)) {
-		used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
-						  STRTAB_STE_0_S1CTXPTR_MASK |
-						  STRTAB_STE_0_S1CDMAX);
-		used_bits->data[1] |=
+		used_bits[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
+					    STRTAB_STE_0_S1CTXPTR_MASK |
+					    STRTAB_STE_0_S1CDMAX);
+		used_bits[1] |=
 			cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |
 				    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |
 				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW |
 				    STRTAB_STE_1_EATS);
-		used_bits->data[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
+		used_bits[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
 	}
 
 	/* S2 translates */
 	if (cfg & BIT(1)) {
-		used_bits->data[1] |=
+		used_bits[1] |=
 			cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_SHCFG);
-		used_bits->data[2] |=
+		used_bits[2] |=
 			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
 				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
 				    STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2R);
-		used_bits->data[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
+		used_bits[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
 	}
 
 	if (cfg == STRTAB_STE_0_CFG_BYPASS)
-		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
+		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
 }
 
 /*
@@ -1017,57 +1027,55 @@ static void arm_smmu_get_ste_used(const struct arm_smmu_ste *ent,
  * unused_update is an intermediate value of entry that has unused bits set to
  * their new values.
  */
-static u8 arm_smmu_entry_qword_diff(const struct arm_smmu_ste *entry,
-				    const struct arm_smmu_ste *target,
-				    struct arm_smmu_ste *unused_update)
+static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
+				    const __le64 *entry, const __le64 *target,
+				    __le64 *unused_update)
 {
-	struct arm_smmu_ste target_used = {};
-	struct arm_smmu_ste cur_used = {};
+	__le64 target_used[NUM_ENTRY_QWORDS] = {};
+	__le64 cur_used[NUM_ENTRY_QWORDS] = {};
 	u8 used_qword_diff = 0;
 	unsigned int i;
 
-	arm_smmu_get_ste_used(entry, &cur_used);
-	arm_smmu_get_ste_used(target, &target_used);
+	writer->ops->get_used(entry, cur_used);
+	writer->ops->get_used(target, target_used);
 
-	for (i = 0; i != ARRAY_SIZE(target_used.data); i++) {
+	for (i = 0; i != NUM_ENTRY_QWORDS; i++) {
 		/*
 		 * Check that masks are up to date, the make functions are not
 		 * allowed to set a bit to 1 if the used function doesn't say it
 		 * is used.
 		 */
-		WARN_ON_ONCE(target->data[i] & ~target_used.data[i]);
+		WARN_ON_ONCE(target[i] & ~target_used[i]);
 
 		/* Bits can change because they are not currently being used */
-		unused_update->data[i] = (entry->data[i] & cur_used.data[i]) |
-					 (target->data[i] & ~cur_used.data[i]);
+		unused_update[i] = (entry[i] & cur_used[i]) |
+				   (target[i] & ~cur_used[i]);
 		/*
 		 * Each bit indicates that a used bit in a qword needs to be
 		 * changed after unused_update is applied.
 		 */
-		if ((unused_update->data[i] & target_used.data[i]) !=
-		    target->data[i])
+		if ((unused_update[i] & target_used[i]) != target[i])
 			used_qword_diff |= 1 << i;
 	}
 	return used_qword_diff;
 }
 
-static bool entry_set(struct arm_smmu_device *smmu, ioasid_t sid,
-		      struct arm_smmu_ste *entry,
-		      const struct arm_smmu_ste *target, unsigned int start,
+static bool entry_set(struct arm_smmu_entry_writer *writer, __le64 *entry,
+		      const __le64 *target, unsigned int start,
 		      unsigned int len)
 {
 	bool changed = false;
 	unsigned int i;
 
 	for (i = start; len != 0; len--, i++) {
-		if (entry->data[i] != target->data[i]) {
-			WRITE_ONCE(entry->data[i], target->data[i]);
+		if (entry[i] != target[i]) {
+			WRITE_ONCE(entry[i], target[i]);
 			changed = true;
 		}
 	}
 
 	if (changed)
-		arm_smmu_sync_ste_for_sid(smmu, sid);
+		writer->ops->sync(writer);
 	return changed;
 }
 
@@ -1097,24 +1105,21 @@ static bool entry_set(struct arm_smmu_device *smmu, ioasid_t sid,
  * V=0 process. This relies on the IGNORED behavior described in the
  * specification.
  */
-static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
-			       struct arm_smmu_ste *entry,
-			       const struct arm_smmu_ste *target)
+static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
+				 __le64 *entry, const __le64 *target)
 {
-	unsigned int num_entry_qwords = ARRAY_SIZE(target->data);
-	struct arm_smmu_device *smmu = master->smmu;
-	struct arm_smmu_ste unused_update;
+	__le64 unused_update[NUM_ENTRY_QWORDS];
 	u8 used_qword_diff;
 
 	used_qword_diff =
-		arm_smmu_entry_qword_diff(entry, target, &unused_update);
+		arm_smmu_entry_qword_diff(writer, entry, target, unused_update);
 	if (hweight8(used_qword_diff) == 1) {
 		/*
 		 * Only one qword needs its used bits to be changed. This is a
-		 * hitless update, update all bits the current STE is ignoring
-		 * to their new values, then update a single "critical qword" to
-		 * change the STE and finally 0 out any bits that are now unused
-		 * in the target configuration.
+		 * hitless update, update all bits the current STE/CD is
+		 * ignoring to their new values, then update a single "critical
+		 * qword" to change the STE/CD and finally 0 out any bits that
+		 * are now unused in the target configuration.
 		 */
 		unsigned int critical_qword_index = ffs(used_qword_diff) - 1;
 
@@ -1123,22 +1128,21 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
 		 * writing it in the next step anyways. This can save a sync
 		 * when the only change is in that qword.
 		 */
-		unused_update.data[critical_qword_index] =
-			entry->data[critical_qword_index];
-		entry_set(smmu, sid, entry, &unused_update, 0, num_entry_qwords);
-		entry_set(smmu, sid, entry, target, critical_qword_index, 1);
-		entry_set(smmu, sid, entry, target, 0, num_entry_qwords);
+		unused_update[critical_qword_index] =
+			entry[critical_qword_index];
+		entry_set(writer, entry, unused_update, 0, NUM_ENTRY_QWORDS);
+		entry_set(writer, entry, target, critical_qword_index, 1);
+		entry_set(writer, entry, target, 0, NUM_ENTRY_QWORDS);
 	} else if (used_qword_diff) {
 		/*
 		 * At least two qwords need their inuse bits to be changed. This
 		 * requires a breaking update, zero the V bit, write all qwords
 		 * but 0, then set qword 0
 		 */
-		unused_update.data[0] = entry->data[0] &
-					cpu_to_le64(~STRTAB_STE_0_V);
-		entry_set(smmu, sid, entry, &unused_update, 0, 1);
-		entry_set(smmu, sid, entry, target, 1, num_entry_qwords - 1);
-		entry_set(smmu, sid, entry, target, 0, 1);
+		unused_update[0] = 0;
+		entry_set(writer, entry, unused_update, 0, 1);
+		entry_set(writer, entry, target, 1, NUM_ENTRY_QWORDS - 1);
+		entry_set(writer, entry, target, 0, 1);
 	} else {
 		/*
 		 * No inuse bit changed. Sanity check that all unused bits are 0
@@ -1146,18 +1150,7 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
 		 * compute_qword_diff().
 		 */
 		WARN_ON_ONCE(
-			entry_set(smmu, sid, entry, target, 0, num_entry_qwords));
-	}
-
-	/* It's likely that we'll want to use the new STE soon */
-	if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH)) {
-		struct arm_smmu_cmdq_ent
-			prefetch_cmd = { .opcode = CMDQ_OP_PREFETCH_CFG,
-					 .prefetch = {
-						 .sid = sid,
-					 } };
-
-		arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
+			entry_set(writer, entry, target, 0, NUM_ENTRY_QWORDS));
 	}
 }
 
@@ -1430,17 +1423,56 @@ arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
-static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu, u32 sid)
+struct arm_smmu_ste_writer {
+	struct arm_smmu_entry_writer writer;
+	u32 sid;
+};
+
+static void arm_smmu_ste_writer_sync_entry(struct arm_smmu_entry_writer *writer)
 {
+	struct arm_smmu_ste_writer *ste_writer =
+		container_of(writer, struct arm_smmu_ste_writer, writer);
 	struct arm_smmu_cmdq_ent cmd = {
 		.opcode	= CMDQ_OP_CFGI_STE,
 		.cfgi	= {
-			.sid	= sid,
+			.sid	= ste_writer->sid,
 			.leaf	= true,
 		},
 	};
 
-	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
+	arm_smmu_cmdq_issue_cmd_with_sync(writer->master->smmu, &cmd);
+}
+
+static const struct arm_smmu_entry_writer_ops arm_smmu_ste_writer_ops = {
+	.sync = arm_smmu_ste_writer_sync_entry,
+	.get_used = arm_smmu_get_ste_used,
+};
+
+static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
+			       struct arm_smmu_ste *ste,
+			       const struct arm_smmu_ste *target)
+{
+	struct arm_smmu_device *smmu = master->smmu;
+	struct arm_smmu_ste_writer ste_writer = {
+		.writer = {
+			.ops = &arm_smmu_ste_writer_ops,
+			.master = master,
+		},
+		.sid = sid,
+	};
+
+	arm_smmu_write_entry(&ste_writer.writer, ste->data, target->data);
+
+	/* It's likely that we'll want to use the new STE soon */
+	if (!(smmu->options & ARM_SMMU_OPT_SKIP_PREFETCH)) {
+		struct arm_smmu_cmdq_ent
+			prefetch_cmd = { .opcode = CMDQ_OP_PREFETCH_CFG,
+					 .prefetch = {
+						 .sid = sid,
+					 } };
+
+		arm_smmu_cmdq_issue_cmd(smmu, &prefetch_cmd);
+	}
 }
 
 static void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
-- 
2.43.2


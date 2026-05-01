Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011056.outbound.protection.outlook.com [52.101.57.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B23F3BED2D;
	Fri,  1 May 2026 14:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777645773; cv=fail; b=sEcPgj5XwNvl98LZ0+LSK0WiHUkQQLYbBUCY1ME8pe/u0ZDhIDVSuWgCW5GHOAOxhp8CD7qW/cnEgvK9udnFagWgCymY5o51hh2JAAFYwLmj9RuT/K2TVtrO8xgoU58t5HAqVpqR1vKYq4UYZutZI3VNvcT1OKfqqeeuuGzmvbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777645773; c=relaxed/simple;
	bh=LdHuelynO/sFyQZNOtyCHk7yffePllDhxLT4OHWqZdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ePlsFOBmFtwIv0gys1ApAQAY2bkTzpT4hUdZfppmAfZkIY5msu3KpBFy9YHe1n7wTkrXJWBOJ6u/SWN4p60+Zrv9BHpPYOPSDdh25AP5cMl7A6bb1JuH6ltENMXiDd+GlCxfjl27cVatcRthHd0KjR5aMKx92Y094wiA/H8o214=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qtQHefwU; arc=fail smtp.client-ip=52.101.57.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qtQHefwU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BkIM5B1aI2FUqVFXoZMVKkc6mKyo6Um0oRiNYw5mCgOhjt5JmsnanoKlr3rxzRp3Nt+cTpysM3nYffmFVlNZFdn6VeLXze26IS8gBF49LO+HzdQu3UJomIYKD2V8zvyOucZntet7i5+/21j6PE2MjLyVsiKjS4mOET4AQOQea5SnEBX0lwZhDWzRZkKyuVX9bVm3kArvNh1EeNHHk/I/PrdDWKYh+pryqK2sBSlkfCEbaTC1pxYlu+OoR0B9Jgn1jniKqNqZmYmZ163x9YkMnk0w6K5+rIb++kUukzmAdORk5MdvmltRwZhovV5BUS3ypvFD7kce0jHat8qHUz8ULQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aljdTmdMqBv3SwOrarPA4TMvl/LqgwdZX70virZqYQ0=;
 b=r4iJwnDctjFC86WjsM3UkFxgdRQM0r3d7lct9V7pgGCwISojdYtOu7/z8AHx7rdx3bii2pyUKRJRsa2MvLQ4qMymlG1WV15S9WBixnsBU0EXDXNhiDvNnTzb15M7v2S+6G39GwsOlBjyT2ydGcYTp50QWZIFDVrxBSctToClzO7VX2heZQPrNm3/DToOeiy+J05hLzOi0rSywNHim+SgLrbXiQvdz2U0d+M0QP1Z5XTcQKF+VZOjeOxp9Q3uOi7FnIk4ljvxaC8knl3ByQxPt1+yYfRFrHvN90zjW+w/swcVUpTsbTnyOFrCATYoiVb7Rh5VBg8qOiNpljwnOXYMaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aljdTmdMqBv3SwOrarPA4TMvl/LqgwdZX70virZqYQ0=;
 b=qtQHefwUcLNWElZaU0w7vogwMvyOUytTd3CF+zQdaDKw7OSPOjcDA4PYyKJYn+qNX0dwKfXpynd14qzvSKl4nyg2w/Z00Bf+/yM59u0ypayTqjrIWoI3KmHD2MQcqfGvIjP/7uGsaRs4MAkAhSU/fYiefgC7+S2DoFQiw2N9xx01evtaJXnStGzvG1eQux4qgRZj6L+/4gSmgIBZchrcFH2gYcArrRYB1FQz2ENXRMKbUeOIrL2FvtsV030T5OR47TW36LMS/TAari3VJcgKsOa+55uPzRni9xUADHSGeS5nbUrmVYy8/NSxWoBq60VbCOZm49X1MJ+9CEPdGt42+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB8096.namprd12.prod.outlook.com (2603:10b6:806:326::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.23; Fri, 1 May
 2026 14:29:22 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9870.022; Fri, 1 May 2026
 14:29:22 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH 1/9] iommu/arm-smmu-v3: Add struct arm_smmu_cmd to represent the HW format command
Date: Fri,  1 May 2026 11:29:10 -0300
Message-ID: <1-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
In-Reply-To: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0024.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::31) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB8096:EE_
X-MS-Office365-Filtering-Correlation-Id: 731384a9-9a99-4172-173f-08dea78e0860
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	pv7lP0Og7WVxQVexPNLfCSoKblxvfbevokuVcsBEeBZIM3yaUAOX9ycwrTG6zbsSTtZ1YHmCYCY/ryKlE9kOrqRVOlDK7jAdfiovcfCUoFsa3ZtHmGsV/D1JxLsCJEupRGv218HLjD6A9AwIKE2ni9YUT9CqfrEBGnZk8d4zMWBGxAqNPurS9QBnJkm82A+EyyfeHEHnho89Jmw84CyUjz6vphlEOcl7gNEBSvKL2Ucxmf4HJUgY8vVMqpeiE91UgoZ+xlzZPCcOsldtifTjyL3JphwK4qx97I9z+hYdSiEivwR0g9qyQd213Wm3QrDll5+AeIWkMlb0gO52JlI3/4rXMmsn21d5FwRhfon4wOQSqxaVg0MwCwiq2tRs31Akhn5nBUEB8ZsMuytkPZTknR3vrrRL9mdztILYlI7JVk6t84C1vtLbOHCIlQzmcVqBiWwU7ZgLi0/kjUEIdwTC4UIBrLpS0g2R+fK6LvBxjHn73rPz4T2rYks94V+2AG1b9JV9fLJG9FZPBb/9zMRidptxoptkmCmVfcR4aIDnHVW6TFrq/ihAH3om/4guEpQZ7KiQTwp1ocNhSIwkO4ZSD8TuAq8WiU3emGa4yhyh/cmLO+0SIq6MW3UH+rhj/lbjxZ2rEr483kdbSsDqEsvizrbaHSm0CSztgHomOw1yDUiys4z3eqSirdJcXSdiEaQC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1YsNkkS/JAHPvpSzL4VVkzp1UjUyTF/RHifZMm1Wayt8MO+bcRoPfUC0xstO?=
 =?us-ascii?Q?71Z2dk1fhy/+1pLmsgbXWa9IT2rT0qWucGJgHbjnBJrmgeBt4Fak7PndaYBe?=
 =?us-ascii?Q?Ju9/fH8jI2KYb/+flZUey9zKTYoswXCD1/LjYnqRBCiul60eU0hCfNFXH1yj?=
 =?us-ascii?Q?m8FQkn7mSABMr72n+kdl8NAFhhGi++BOxA9UWPbHCqRgwVVObYssli+5H/wz?=
 =?us-ascii?Q?MDP817/MpsJ/0jX60UZdKYfxGIQni24kdZpMlxNHUzHCuf77kFyCkjb/pRPB?=
 =?us-ascii?Q?p8NPHsUBgAEIVsyZEeQ5IZ2g5B08zruykmli9jIW/BiMNjgnIfVVQ3SXd5f7?=
 =?us-ascii?Q?vnHKj9wKtnRTg+AyVKZEuVvT3b1KuUGeKyBO3nt/xfB60diLgf1Q0o66ZvXQ?=
 =?us-ascii?Q?VvjZ4+6SL4RhJuVWfSTqveGLp232IaPMcyyYInQiKAKhmhbpcssBEwZPyh/J?=
 =?us-ascii?Q?JlU+jNp5dEc+ryoRFVf+uy4O244t5O6L93S11k0+v84r0Il6z+pkQYEuSbb6?=
 =?us-ascii?Q?XKxuP+k0VyJFHVxcHQiELshRZbVlaptoov/HOnAtks6hthx2xFhG2tuzQmOS?=
 =?us-ascii?Q?cRlesu5CEzkE3gh2g19XR7SCA75i6kSrIzPuxiyaa0osj9zkPwajfZ7W/YIx?=
 =?us-ascii?Q?xLRf5TxBWwvu0ZVolJgLre/6hEcdh/uqvuPZ3mzjAcS3aflvn/GzSpG0YUGn?=
 =?us-ascii?Q?ZTwQ1QkM02Ng4zcR3cFR9zGPFCdcNMlgclJOiIVBPXWyqNA8xPYVpMy0ZOqo?=
 =?us-ascii?Q?kIpbW7iLY+8kJ+0NuMEkGiNvlk+5sY8OXoWrwvk9FH5ufQ/wgrn9HDZiXrKU?=
 =?us-ascii?Q?Ghe0zGKQG35JIWikcsA1o+cUfxs0t4OEcgBFix9rOm1k7Bl3FmQhPD60X5cL?=
 =?us-ascii?Q?frqgSCFGg+E0y8z4tmjeNSIG+tM+UqVYL+AvBTVHToplzP6tROHfsKVdu/kQ?=
 =?us-ascii?Q?hIs4IECBJeo5Kj9M6oSFgpKhR4LsvZwNDzLwOxV8i6l+2Nt/QV3oymZORfvK?=
 =?us-ascii?Q?53z0jYVMxysoBhsNaqGiteJNow1AU9nN506OnFub9SrCGGwDTva2trRUnuj4?=
 =?us-ascii?Q?NJ+9ZH9gS/+X7mWEpA1OtMl3g7hl3vxCOSf0LfsuppkoVIKMpMF1RWQiY7v/?=
 =?us-ascii?Q?UxKsEjUhiKd32F7fsO4No+DdpqH1sgJNjleF/BLdvzn2KUn+Mm0CBQyijVsI?=
 =?us-ascii?Q?fQE1LU2px5opcHIOHIYEvxv+v9LCt+Np3KnCSxLwRwgXGji6tH8NUb3dgRcf?=
 =?us-ascii?Q?drArUTazsLhS9MxloTjUOtWzyth7tRoOJ/zeJyTUAfS8W84/uPr3Z5O6P1rh?=
 =?us-ascii?Q?Rn62L6QLbuxgqTcCRNzckQbp6jeN34sPt3oNJQNqWHbDB1TGL2zSpoWIXaBY?=
 =?us-ascii?Q?vI7BuSCRBq7pYMdYRM14zv/Lxv/DMPIfIF4tIwJp/UknluBtje81kSnurujL?=
 =?us-ascii?Q?kvn1XA6Hg0RQZasTy5wLw1qaFsMfC0BYLK8SxPOfH1iVxQjAcLzdO0SLOwol?=
 =?us-ascii?Q?zNZd5RsdE71f5R8QEwbf2yI8tgxhP2hqO3PTzxj4tNfBnHh8bhyRkl3RN/o2?=
 =?us-ascii?Q?O+M7u5CQ4tcrcUolRwr8IrYpAKhKdL9nwZz/NVZxDzBI/ireRIFtT7pIk+LV?=
 =?us-ascii?Q?RkXF9DKIobYnEYd+MlvO2YY1I0Y+j2gH/EZ1K42+hnPhm/LZoiuHOnqJLTKd?=
 =?us-ascii?Q?o/LGYwrqOydWBqVsS7SkuMmRmrnNBPqmLs48ocZD4q18gLex?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 731384a9-9a99-4172-173f-08dea78e0860
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2026 14:29:20.4872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UUmyuPTCKW501r5jmi1hfvXErH019qf2369QuXhNzwlec2Yd83sBjRpobQmS5AyG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8096

Like STE/CD, add a wrapper struct around the u64 array to represent the
already FIELD_PREP'd command data. Unlike the STE/CD this is a u64
because the command submission path will have the swap to le64.

This makes the API clearer when a u64 is referring to a formatted
command and makes the following changes easier to follow.

Move the command constants out of the struct and into an enum alongside
the rest of the constants defining the HW format so the entire HW format
is self contained and independent of struct arm_smmu_cmdq_ent.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 48 ++++++++++++---------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index ef42df4753ec4d..092179f689e9f1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -390,6 +390,10 @@ static inline unsigned int arm_smmu_cdtab_l2_idx(unsigned int ssid)
 
 #define CMDQ_PROD_OWNED_FLAG		Q_OVERFLOW_FLAG
 
+struct arm_smmu_cmd {
+	u64 data[CMDQ_ENT_DWORDS];
+};
+
 /*
  * This is used to size the command queue and therefore must be at least
  * BITS_PER_LONG so that the valid_map works correctly (it relies on the
@@ -426,6 +430,8 @@ static inline unsigned int arm_smmu_cdtab_l2_idx(unsigned int ssid)
 #define CMDQ_ATC_1_SIZE			GENMASK_ULL(5, 0)
 #define CMDQ_ATC_1_ADDR_MASK		GENMASK_ULL(63, 12)
 
+#define ATC_INV_SIZE_ALL 52
+
 #define CMDQ_PRI_0_SSID			GENMASK_ULL(31, 12)
 #define CMDQ_PRI_0_SID			GENMASK_ULL(63, 32)
 #define CMDQ_PRI_1_GRPID		GENMASK_ULL(8, 0)
@@ -447,6 +453,28 @@ static inline unsigned int arm_smmu_cdtab_l2_idx(unsigned int ssid)
 #define CMDQ_SYNC_0_MSIDATA		GENMASK_ULL(63, 32)
 #define CMDQ_SYNC_1_MSIADDR_MASK	GENMASK_ULL(51, 2)
 
+enum arm_smmu_cmdq_opcode {
+	CMDQ_OP_PREFETCH_CFG = 0x1,
+	CMDQ_OP_CFGI_STE = 0x3,
+	CMDQ_OP_CFGI_ALL = 0x4,
+	CMDQ_OP_CFGI_CD = 0x5,
+	CMDQ_OP_CFGI_CD_ALL = 0x6,
+	CMDQ_OP_TLBI_NH_ALL = 0x10,
+	CMDQ_OP_TLBI_NH_ASID = 0x11,
+	CMDQ_OP_TLBI_NH_VA = 0x12,
+	CMDQ_OP_TLBI_NH_VAA = 0x13,
+	CMDQ_OP_TLBI_EL2_ALL = 0x20,
+	CMDQ_OP_TLBI_EL2_ASID = 0x21,
+	CMDQ_OP_TLBI_EL2_VA = 0x22,
+	CMDQ_OP_TLBI_S12_VMALL = 0x28,
+	CMDQ_OP_TLBI_S2_IPA = 0x2a,
+	CMDQ_OP_TLBI_NSNH_ALL = 0x30,
+	CMDQ_OP_ATC_INV = 0x40,
+	CMDQ_OP_PRI_RESP = 0x41,
+	CMDQ_OP_RESUME = 0x44,
+	CMDQ_OP_CMD_SYNC = 0x46,
+};
+
 /* Event queue */
 #define EVTQ_ENT_SZ_SHIFT		5
 #define EVTQ_ENT_DWORDS			((1 << EVTQ_ENT_SZ_SHIFT) >> 3)
@@ -520,15 +548,10 @@ struct arm_smmu_cmdq_ent {
 
 	/* Command-specific fields */
 	union {
-		#define CMDQ_OP_PREFETCH_CFG	0x1
 		struct {
 			u32			sid;
 		} prefetch;
 
-		#define CMDQ_OP_CFGI_STE	0x3
-		#define CMDQ_OP_CFGI_ALL	0x4
-		#define CMDQ_OP_CFGI_CD		0x5
-		#define CMDQ_OP_CFGI_CD_ALL	0x6
 		struct {
 			u32			sid;
 			u32			ssid;
@@ -538,16 +561,6 @@ struct arm_smmu_cmdq_ent {
 			};
 		} cfgi;
 
-		#define CMDQ_OP_TLBI_NH_ALL     0x10
-		#define CMDQ_OP_TLBI_NH_ASID	0x11
-		#define CMDQ_OP_TLBI_NH_VA	0x12
-		#define CMDQ_OP_TLBI_NH_VAA	0x13
-		#define CMDQ_OP_TLBI_EL2_ALL	0x20
-		#define CMDQ_OP_TLBI_EL2_ASID	0x21
-		#define CMDQ_OP_TLBI_EL2_VA	0x22
-		#define CMDQ_OP_TLBI_S12_VMALL	0x28
-		#define CMDQ_OP_TLBI_S2_IPA	0x2a
-		#define CMDQ_OP_TLBI_NSNH_ALL	0x30
 		struct {
 			u8			num;
 			u8			scale;
@@ -559,8 +572,6 @@ struct arm_smmu_cmdq_ent {
 			u64			addr;
 		} tlbi;
 
-		#define CMDQ_OP_ATC_INV		0x40
-		#define ATC_INV_SIZE_ALL	52
 		struct {
 			u32			sid;
 			u32			ssid;
@@ -569,7 +580,6 @@ struct arm_smmu_cmdq_ent {
 			bool			global;
 		} atc;
 
-		#define CMDQ_OP_PRI_RESP	0x41
 		struct {
 			u32			sid;
 			u32			ssid;
@@ -577,14 +587,12 @@ struct arm_smmu_cmdq_ent {
 			enum pri_resp		resp;
 		} pri;
 
-		#define CMDQ_OP_RESUME		0x44
 		struct {
 			u32			sid;
 			u16			stag;
 			u8			resp;
 		} resume;
 
-		#define CMDQ_OP_CMD_SYNC	0x46
 		struct {
 			u64			msiaddr;
 		} sync;
-- 
2.43.0


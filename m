Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2083.outbound.protection.outlook.com [40.107.101.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085A2137C4B;
	Tue, 16 Apr 2024 19:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713295729; cv=fail; b=tELjkZCn0Dtao3ewnteT3rUoDz2eQU6riugf48l/7fM4q15nebQbjalNkEC9veP0ln4nYGldr3pjn+fWO+z4NCvdNkcFZgtoSwVSKnGguB1OrOSJImM/K7QfDw3v+sNGGj/A8954mQOY2j6r7zON5TFxKXYjsDz2Q5Xwmkg19/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713295729; c=relaxed/simple;
	bh=ObwPwOMpN9NfDzZSkm5E4h2SB3UvAag3ElO2SsKFhzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=l0yQIwHUe2UzuUaOUfrgnpkJlP8Av2g2GPRb4blMpaTfUJ7C99cSX3Uj6SzC3lKVCv2LPZmQnNNtjtgUfAXCrm2Q6qKtUjvjIIy5miymExo3xG7o8a1H7quW2xNWdUBwemw38n0S5fcAAhjl6c252mRxcKF7DRTT2791zMZhKmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sSOlI3xz; arc=fail smtp.client-ip=40.107.101.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sSOlI3xz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X9KPMUxnCQQeslui1ZE+tx8KQpQGQfvLeRVLiEM/VHffoH6O1A6Uq+Xjg5CiAmHKOWlQOVLQYyH8UE6PGbo1xD5aCjfAH6hKorV9igwdkQql9jFNx9m6L7ZHoAxigOuGECDN9rSxZ09GwhRwp0OpAci5uisv2Jz12hObDpRXRiqx9MgryjvlZHw/ktQ6T33GfkixyM9zZOsoHO8cJgtHnJ5prNYk7ePPURlcJIqoQfUpWZUenTMubn8LzapwOR7l9DfWQ79ATP/WZX+o5Fj8Rm+ONF6TbU5RBznIHxixAoNjr0ZrlCX3i5Yqah1AIbYwmLfHbr8VKrcVxYNlhzjPig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eWGFHURE+pRHLYw8oaFvCOhxYaRRrDiSAW44G7GBJlk=;
 b=BTEITVvrwMyItXcSBkXt+R3sEwpuIesF6K7KLYGEgoBSE7QWikgdG+Z1oJfNTKgfVJLeL7MooAIZ23QNjNf3C7f7amTk3E8b29ABK8aUvGigPJ+3g+ivJCXlIXoOGKopMrbEIi2dIXznkfAm685roDGd3qlx2XD+Y5T1PhFIOWYEGszq0iwWUqd5Zv+pVB+HQtbw8MVJEraqcJ6p16jAxltmClMjEr2wnSWfdr8VS4nBXUPC9REWdDNi1CgdIR645REuKkAftVawj6TsMzeUK804XdtQMCS361DinqD28Rwsn3eMysJqcLn0922lx8L2WS+15K6t1ezlj3FUsTHUAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eWGFHURE+pRHLYw8oaFvCOhxYaRRrDiSAW44G7GBJlk=;
 b=sSOlI3xzwt1Hcq8YdDPDGaEbbBxGQm3uY+gXjZOJsN7YJnQbiEf3mwJGCv9NoOcJ9qyehWIpCyuF2O55//YH4hE+Fk8qBgWVVTfiH8aTA5uSryOxHXPhcWJyixBl7FYbaoyQzL6njIf6xKP/S7Vf9XA0XeYj5ZGhB6D8+Sm/LZp+4Z8qZJamsw+NSm4vEyZtys88wftX3fX3Xywnpw96/xXTEWhOgfaVNDJIZXc5O0K1aKxp4gW5yR7uo5AxiIbS55dpUUP4Mu8KgbnSAJHXMcUAWcIwOvgj2rlpGabWnx8bvpvgBjwZkG5xUM9GsFL+LlRgIRPAZtANSOgJYGr2AQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB8213.namprd12.prod.outlook.com (2603:10b6:930:71::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 19:28:28 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 19:28:25 +0000
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
Subject: [PATCH v7 1/9] iommu/arm-smmu-v3: Add an ops indirection to the STE code
Date: Tue, 16 Apr 2024 16:28:12 -0300
Message-ID: <1-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0046.namprd04.prod.outlook.com
 (2603:10b6:806:120::21) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB8213:EE_
X-MS-Office365-Filtering-Correlation-Id: e45b86a9-64c9-4398-7b68-08dc5e4b61ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2EbiEiJuxaWn21SXUufxRHrI2Qsw4tt37BhWwfKButqVCZljSIINtRxkINEifTMrSQ8eOwJp8LOkVaQBqxGN8VYhKHkB0Jb9t5rOlaw+z8doetv/b7wAT6eycZlnoZSIiO7Pdz7kBSG9ObnXAQpO7gP1b5O+ZuSRIfMR3Say6QKfUqpa9eoxd37/VAnAUSs+KquaLdgPPpJb8lYmnHsQHEjS/4aVuiWKwDkIF4k5up6Ky+VUpEcNLWmMwpp5sdi1P78+IorEEViRYEweDk4/N8dyVPrTvB2rDQhBem3Y43FT7uGxdbgG29BRAyJZL+Z8bqpgK4KNcqMRp3QUdSlpvyT0MB7ktfmrijfgm+yMCuEf3nw2eEIE4ePcAJlSAV5VlOk9qlVnhuIpu/yhpcavhcSqDiLDEOjxy1uhOzE1U6X1VOADeRHu5rBQThtTHQpvt+dCOH6h4cQCDOb1NUkQO9wv4xFKjITl6H2EfmayQ1zCQsnNltzoG5fgBxomMZNd61EkdJnayyXNpDBfhWIQAF0T8lkmTQbMDwyvFdtalpN/Kt90UUtwvRrYGxQiGFzhN60eKX1JIYSx3H0Ogm8QCcGwhy35WvV0coHlBo1usoWqqaZo3W4PEG50F4wqyQWvlDocfhi3inT4CDsYEBz0HJwe+XYyOO9XVg+IgcY3zTw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ycLPMD/bLfaNSGf+uLQSuQUDKwXgaT8dKp14aCgNgn09GKw456yBa12nrRmK?=
 =?us-ascii?Q?MVnTGWHtw2mNG1dXlXx9kY+KrWHWgQ8gDv625Q0nCOwqP3TsLkw4C0yPOJDw?=
 =?us-ascii?Q?c8YIVngrWgcxXgsaQirfa2VdLvwYtOvpKKA9x3PzI3Ej3fOZowgrgQQzrdRF?=
 =?us-ascii?Q?A644M0/EkwvCpNI3u+db+kkGqGw6MA3q1YTomWnLODAVECwbhuddyAO5kpen?=
 =?us-ascii?Q?AEvevtbXALOuoRRf3ytudeRWVRc3Wenmg6vYIz5NSH7mWOYAKQ0chtKjse0l?=
 =?us-ascii?Q?cOLb1i9oWTGxUHbvdPdCe9MWeOzXeuY+FNy2G8jZCG6dE97Fr3A1pTZDVvUz?=
 =?us-ascii?Q?gcSHYLgVv5w8S6m9D9OecPIxsjVhe2BE62I4KSxJkoNRge7dioTtKYexZTfK?=
 =?us-ascii?Q?PcXefI4i38f6RSy2YSPhuLvc5r38cmMkTyBB91Lm0JecH9jIWTJCxMXAXAG2?=
 =?us-ascii?Q?fXxM0wcVTOexaSqF7cnXARKxTpnYLlImY+iIQO/hGZb7nqAar0GSPpxYsac/?=
 =?us-ascii?Q?zEsxEoxkca8nmzspcDbtYvA3njQhCKc5lnhCOHWEl+gcM5rqRhg+KgoSDuT0?=
 =?us-ascii?Q?XI6pk8LgxR1TD7W1qihHX/5rknH6qBZmD7Q0ulkE9Agvq7NTAYkzfdCyPM3j?=
 =?us-ascii?Q?VHPK6jDR4T+7mAcxn4QG0ZEpZTtB90j5ErO+FxWNBLZ+swOrtdmKXIsSTeY9?=
 =?us-ascii?Q?B/yi3ydV/O1qdz14yBQ7DOyJ2cjdVc+sU8eDiJxxYx77uzgvTmFc4ke45+5G?=
 =?us-ascii?Q?6h4dVP8p8PcGHgrNkDIU72VF+3yPk0OtleKschv1Rc4gMOlI2esM0gl/kna+?=
 =?us-ascii?Q?nEVsSM95VatssFjTfOjapthObaDb6YJPbBenYZU5m8Dj9mh3SlvfudoXNKZ2?=
 =?us-ascii?Q?upLJa8Ybp+L7TV/kSYWdlGy6sWblgSyVGDx83hYHlujNBXrxzSKhFzg2iNRd?=
 =?us-ascii?Q?NkAk2sWOcY0ob4f03spHy08e9BKuwP+SBROa6eOgdZUtLcXe9PnQxjjKRYbH?=
 =?us-ascii?Q?QS0hyCCjNHcRI9Hz4xA6VqszAWPca0+GHjp79WGv8DJf2200WwG6KdEhsZVl?=
 =?us-ascii?Q?W9mk6y+PSbm4AI+4uzCsBrCd2aLQIosC8ge4Jx+0Ml0fsG7nudiZnbpY5oG2?=
 =?us-ascii?Q?vMKfMIj2gBXBXjB6deFlSOCWu3kCbPkB+UK+y+iN2q9mOpCiaULGKuisQAYq?=
 =?us-ascii?Q?AE6kbwpsnw38KNztEZG02iCylNN2sGC49gJksTmGC8xKrtUkQwpI4OGi+0/k?=
 =?us-ascii?Q?vu1v2So65SuKuj8G8xDe2cagb3SL30E8YnffwWatnAK8x5jPwVuo71HZrc/4?=
 =?us-ascii?Q?K24OivlUjYLhYxaF3ae/MIghR/Sx2uE29jv1VbLfsLPCx2oHxeMTMfLj4F+n?=
 =?us-ascii?Q?s3RxBveNKtrKYOykeFjoKFgSacYFkUg9U0SwQH6s7aUASLyaGK0tAumPVn4n?=
 =?us-ascii?Q?/IDZmS+BxhcL8kewYmPw23Xw7zJL0S3a/A6ZSuwJmsUfapdZIJeAvho34TG5?=
 =?us-ascii?Q?3ysnu/zMmfJnDQOlGp8cgO0fPDHGMphLZEENgFFN18Gsl18OpZWWVh4sJxBa?=
 =?us-ascii?Q?QTm4EaKp6E0r/rbjBenjaRE/cXT6Y1gqI0/k3GMr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e45b86a9-64c9-4398-7b68-08dc5e4b61ba
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 19:28:23.7293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D29IjSeX8A1+2nBW3yI8ZWXHYdhynaZT8b4NfNctIiru42Ey5Ilf5447b5QPJp8i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8213

Prepare to put the CD code into the same mechanism. Add an ops indirection
around all the STE specific code and make the worker functions independent
of the entry content being processed.

get_used and sync ops are provided to hook the correct code.

Signed-off-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 178 ++++++++++++--------
 1 file changed, 106 insertions(+), 72 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 79c18e95dd293e..bf105e914d38b1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -42,8 +42,20 @@ enum arm_smmu_msi_index {
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
+	__le64 v_bit;
+	void (*get_used)(const __le64 *entry, __le64 *used);
+	void (*sync)(struct arm_smmu_entry_writer *writer);
+};
+
+#define NUM_ENTRY_QWORDS 8
+static_assert(sizeof(struct arm_smmu_ste) == NUM_ENTRY_QWORDS * sizeof(u64));
 
 static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
 	[EVTQ_MSI_INDEX] = {
@@ -972,43 +984,42 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
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
@@ -1017,57 +1028,55 @@ static void arm_smmu_get_ste_used(const struct arm_smmu_ste *ent,
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
 
@@ -1097,24 +1106,21 @@ static bool entry_set(struct arm_smmu_device *smmu, ioasid_t sid,
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
 
@@ -1123,22 +1129,21 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
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
+		unused_update[0] = entry[0] & (~writer->ops->v_bit);
+		entry_set(writer, entry, unused_update, 0, 1);
+		entry_set(writer, entry, target, 1, NUM_ENTRY_QWORDS - 1);
+		entry_set(writer, entry, target, 0, 1);
 	} else {
 		/*
 		 * No inuse bit changed. Sanity check that all unused bits are 0
@@ -1146,18 +1151,7 @@ static void arm_smmu_write_ste(struct arm_smmu_master *master, u32 sid,
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
 
@@ -1430,17 +1424,57 @@ arm_smmu_write_strtab_l1_desc(__le64 *dst, struct arm_smmu_strtab_l1_desc *desc)
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
+	.v_bit = cpu_to_le64(STRTAB_STE_0_V),
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


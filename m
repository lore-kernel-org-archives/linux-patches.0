Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163E767E96;
	Wed,  6 Dec 2023 17:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fDcZjGFZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mdq8YF4Weqv9sQNfzXEfieZY8qSYWbvaeRbmiQgy8XGJYV+gq1SmRRd1Dq04xSflUgLdsBPMeZoQlyEGd2gaLCobrn9ydiWGMowNRRXY9sv62ttscZHQneApeDv6hAWPURZNJDIBEyTadaOWA0s94lARTHob/1PCdUUkPb0pd9rdhsr943XuSnsWb4lpOX0o28xBO7ADfFjeGSaHf549VWvt+Q4w0vWVLf0T0KKmvV8Kgttd/6R27+VrZcY7U0vkFX7VxXPtBcROzqL4MdOYXYNjaNSFeg1HDHOz1jBQ1i0RWJ3QlC4eeaicqlspjwxbmBfJKWRYDA+wf/pRfLSEyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f4ZYaUJjMmsj5xs9BZufJhvIfG0beDtsdPFOiCXm/iE=;
 b=ifqIRkfmDMsumNJGov704N76xONExTeae3O19G9fM9dMKt36mrr4Cd3bK5mkK+/13G8oD8SFmDjqbueYh8oQXP7Xt4Bd9hPr0oxzu0pOyHJL2h186k1Hw7YL57vNm8kgU4+VmiZIfGNDueSCXr0I1+xHOUkGBWaKnk418MIyAT9DHERDF5ASTNZPBK4SrIAXZw4mGEBpKURz6zr4u22fjKkA1yJyX1bMzmegZmnumQ5Hg1FnJae/g7EAzHJEEQUpTrBzKj3vmIWjCJLx8BwWdzTIk/xFaYY/BoIr3B1Nix1MNK1HIdcUY9K8K1AkKb2qZs2Zx5LKucqMAzqih+vqww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4ZYaUJjMmsj5xs9BZufJhvIfG0beDtsdPFOiCXm/iE=;
 b=fDcZjGFZZNH+blFgX+qCA761HA9V+tL2WTswax5669JGSY3V8kKpd7quj7vF6wf6iOKMI5nxzardF/IorNY9Plx1ObanOUP/R6lLIn1wvTksl/BEkRG1VwkJujYo46KnFdIEYebA4SZaCNhxF1vGKV9SVxawCD/GDoe+XcpBvOBoy0z2SF/9XKfhir0LuOzh+x4RJ4XKgqVqmGWVkmbJmwSHUd5B6Hh3ojSSgXi55FaY5ofITD8XDgBHvCKyfem/YTdc4hjQBB5aTdzmO7L3bQt/DeyAp/17+xKQHOnBzuUVVS6LjpeyzvHmes+4+o8ksWDQl2SxTmvo1W7d1AcIjw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7364.namprd12.prod.outlook.com (2603:10b6:930:50::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.25; Wed, 6 Dec
 2023 17:28:36 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:36 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v3 05/27] iommu/arm-smmu-v3: Make CD programming use arm_smmu_write_entry_step()
Date: Wed,  6 Dec 2023 13:28:11 -0400
Message-ID: <5-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0011.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7364:EE_
X-MS-Office365-Filtering-Correlation-Id: 91224f27-13f7-4972-fc6e-08dbf680c5df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2HIvLDCxSYBaAZdquZmY61u46waDi0DAPOV52dO5fLmRyhQXKMDPf3P/39nnJm0WiN+n9umoxX+lkoq991e1G5W6h+dgTGglwGMrE4IlpPepVHryHTFpFPJO1to1HyRGXcXzEDCkx5PuYREeqgELv2heZdkLIALRZaHcBarTsZhbW9h2/5htcHGMiE09dlT9qk/0LtIH9FviKXjbIInPD52Sh1QOXtd84DNtvqjiEw1TXjS6W4c4yO6hkbi45meBuIOpQ3yG+CUREsxzxVhjSkjiAAFpx/e5VZ+Ar5hAMH3J15odfcTZuvcQYqGDtEAo4pY9E+jo18tBhMGKY7qIjc6YlOoh7xBj0E+vkZu8CNgVgVmxHGW/9bVqLUkT07k58RXE6Q7mkxvwXRN740lG7bVGtdkk4qqqLGmJBGGxJMjwvuc4xgmac1zFamP2jw8ct4meBrkCUEOoW8dAOUl/W3MTp7BpG8V2IdQsTvMgYJpW61mSuu9EmWTLW9/voP2PcMhk5rfrDtKLOMJ2wg71UDP3hRUzoh/0BTGpI8OWalWZSHnK2kcyeZxTgSCVKKRDaaa62NXw+byWANvd0Ub2kaZsvY3KOiAsH4Jm/zoh2qk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(39860400002)(376002)(136003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(8936002)(8676002)(4326008)(2906002)(38100700002)(83380400001)(7416002)(41300700001)(36756003)(86362001)(5660300002)(6666004)(26005)(6512007)(66556008)(6486002)(478600001)(2616005)(66946007)(110136005)(54906003)(66476007)(6506007)(316002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BWKyKEa47pn5j6jDw06KWzdZ10qj/LEN6agzvPdPphQfDJ1RzwVblUf6Ud+a?=
 =?us-ascii?Q?ZJI3CTuPQB/OEJVt7HzjW2TYKeEp0AcLkV7ktPdnfX7oMoLyTECPokk7WUDL?=
 =?us-ascii?Q?7tvrfJUplF900QY3CL+7zAotu+gFXBTBsCUx3hUHUf9gRNBgWPgcTFbUFrqU?=
 =?us-ascii?Q?m80pe/8ejW8j7gocuqqjsrQ/k6riFSld/Xdq/l5ET59Lw37ifzQsBg6+WpJO?=
 =?us-ascii?Q?OQuX55jJNIXIrdwY7s+sNQmp/i14C7vA1sXcIy2Y5TiWLht5LjarIAz140jR?=
 =?us-ascii?Q?rtgca9xI6ppE5SxxHM8qgVgde4uBnhz71MyXUOggI0ne1ExqpVFnZfsKEYYe?=
 =?us-ascii?Q?Iw+jtIljx7oXOF7NaNxxzkxRJsXvTkh9unEoqlqLu2GgaCkCoLt8ixnQ7nKc?=
 =?us-ascii?Q?B2Z3SSgIFr5P2BCeSnKYsjqKtHrv4OP5mEB/cJgctry5ZnXIPqGU4FRHvdTg?=
 =?us-ascii?Q?Gnxzug6HNd8jumAuAvVtQgliZJRroHh3xzFNfQ/svWum/pJKojDhWKlhx05f?=
 =?us-ascii?Q?CdfIbrdfzC/bQ2ZB+jZiTzio32FEueMoGkcvMvw8b0v7KuMCN1QGJopJGyDo?=
 =?us-ascii?Q?rBuVYMYADlpiAT0fbcKArD3TEuCu9VyighhyRgYJAep38za7Hxusdfi0GPo1?=
 =?us-ascii?Q?Pe9igOLYmdhc+p7p3GdFLSMy3EidPClO8iCxWPLheJM0UaHAv4xQZTq/A3mI?=
 =?us-ascii?Q?PmPRHpxXp2u+0AcJJL8ftLD3/0E0MoMJ3qxCwuRtBGg/f+iop7hboG9DWINK?=
 =?us-ascii?Q?U9rl8UQyhvz5oV8q4Vt2HBSFtqEhhyEfkoXhJ3/Fuo33fw27XqC+eDd5wh8f?=
 =?us-ascii?Q?PQFf+x5GW/5maohsdLrsbe3XYzn0HHlTL8wkPueHa3Rmlr0jSX8Rsvzf0k0y?=
 =?us-ascii?Q?KspPHY/ylU8muDwd2FpOhSkg/P1Zs100xyWKFH0S4DpD4hx8B3SsMVs2azj+?=
 =?us-ascii?Q?ionIBhk/nLwb5sEODvbe52X+S9KRv2sb0djzCg9rOVSLVgvd3he2tHqQ9/W0?=
 =?us-ascii?Q?safOPRseDpgc3mVBVFVwab1tSB3JkZJ+ukIsYusGQ15Qvch+ZZYwcXTbnXba?=
 =?us-ascii?Q?LL/GW/A/frG0PkwJARUeP3gytGAMS9kGOgPWovDGH2LtaPkLGIze4UO/l3ek?=
 =?us-ascii?Q?QC0wq/egb8LhRoznQzjEBxBaHASDQFIhZEUpRoiQVA2QIAw/MZE5wRfK+fNt?=
 =?us-ascii?Q?ZcoWPlSlxx2v0QoCu9tiOj1OUh79Lig50cWD+cx+cs56GOuiR8N4zmBKT4Bn?=
 =?us-ascii?Q?ohzaa4mkodyajwdQio+tv0B30yKiTip08cPWz31iG2bOLk26guos0v78RHXQ?=
 =?us-ascii?Q?S5/UhOfr+H1vHGy41QWlLeqyk+0weyFY6mS3h45n2SuQ9h6u+cFFcftJi8fx?=
 =?us-ascii?Q?347T3rCz4P1vl/Qo9RstKEZBb+Xc29UVoY0/cN8OnLOQiEn0VAzI89NnGwBn?=
 =?us-ascii?Q?zeha3dTEdmokP4nocp3kr9IWhNogixd+8s5/6MxHCttviDfXJJXnWiCAv2LC?=
 =?us-ascii?Q?yA5oNENQZC+DxEqB/zbk69xKqJA2ZGQKVAMbmGjHPr5rNKs1PueQjXYbs2H0?=
 =?us-ascii?Q?pbwzjPF0bFq34A0TTrJPfVqxty1RIIogfv8WvKCX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91224f27-13f7-4972-fc6e-08dbf680c5df
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:34.0873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u/iuMLY0biebi03gqT7i5PmqqK38F15GZGLvQMB2WK+6F4TdUyVmfaDJmMTzsuEs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7364

CD table entries and STE's have the same essential programming sequence,
just with different types and sizes.

Have arm_smmu_write_ctx_desc() generate a target CD and call
arm_smmu_write_entry_step() to do the programming. Due to the way the
target CD is generated by modifying the existing CD this alone is not
enough for the CD callers to be freed of the ordering requirements.

The following patches will make the rest of the CD flow mirror the STE
flow with precise CD contents generated in all cases.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 79 +++++++++++++++------
 1 file changed, 57 insertions(+), 22 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 3f77583144e649..0847ce91c5cc1a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1146,6 +1146,55 @@ static struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 	return &l1_desc->l2ptr[idx];
 }
 
+static void arm_smmu_get_cd_used(const struct arm_smmu_cd *ent,
+				 struct arm_smmu_cd *used_bits)
+{
+	memset(used_bits, 0, sizeof(*used_bits));
+
+	used_bits->data[0] = cpu_to_le64(CTXDESC_CD_0_V);
+	if (!(ent->data[0] & cpu_to_le64(CTXDESC_CD_0_V)))
+		return;
+	memset(used_bits, 0xFF, sizeof(*used_bits));
+
+	/* EPD0 means T0SZ/TG0/IR0/OR0/SH0/TTB0 are IGNORED */
+	if (ent->data[0] & cpu_to_le64(CTXDESC_CD_0_TCR_EPD0)) {
+		used_bits->data[0] &= ~cpu_to_le64(
+			CTXDESC_CD_0_TCR_T0SZ | CTXDESC_CD_0_TCR_TG0 |
+			CTXDESC_CD_0_TCR_IRGN0 | CTXDESC_CD_0_TCR_ORGN0 |
+			CTXDESC_CD_0_TCR_SH0);
+		used_bits->data[1] &= ~cpu_to_le64(CTXDESC_CD_1_TTB0_MASK);
+	}
+}
+
+static bool arm_smmu_write_cd_step(struct arm_smmu_cd *cur,
+				   const struct arm_smmu_cd *target,
+				   const struct arm_smmu_cd *target_used)
+{
+	struct arm_smmu_cd cur_used;
+	struct arm_smmu_cd step;
+
+	arm_smmu_get_cd_used(cur, &cur_used);
+	return arm_smmu_write_entry_step(cur->data, cur_used.data, target->data,
+					 target_used->data, step.data,
+					 cpu_to_le64(CTXDESC_CD_0_V),
+					 ARRAY_SIZE(cur->data));
+
+}
+
+static void arm_smmu_write_cd_entry(struct arm_smmu_master *master, int ssid,
+				    struct arm_smmu_cd *cdptr,
+				    const struct arm_smmu_cd *target)
+{
+	struct arm_smmu_cd target_used;
+
+	arm_smmu_get_cd_used(target, &target_used);
+	while (true) {
+		if (arm_smmu_write_cd_step(cdptr, target, &target_used))
+			break;
+		arm_smmu_sync_cd(master, ssid, true);
+	}
+}
+
 int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 			    struct arm_smmu_ctx_desc *cd)
 {
@@ -1162,16 +1211,19 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 	 */
 	u64 val;
 	bool cd_live;
-	struct arm_smmu_cd *cdptr;
+	struct arm_smmu_cd target;
+	struct arm_smmu_cd *cdptr = &target;
+	struct arm_smmu_cd *cd_table_entry;
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 
 	if (WARN_ON(ssid >= (1 << cd_table->s1cdmax)))
 		return -E2BIG;
 
-	cdptr = arm_smmu_get_cd_ptr(master, ssid);
-	if (!cdptr)
+	cd_table_entry = arm_smmu_get_cd_ptr(master, ssid);
+	if (!cd_table_entry)
 		return -ENOMEM;
 
+	target = *cd_table_entry;
 	val = le64_to_cpu(cdptr->data[0]);
 	cd_live = !!(val & CTXDESC_CD_0_V);
 
@@ -1191,13 +1243,6 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 		cdptr->data[2] = 0;
 		cdptr->data[3] = cpu_to_le64(cd->mair);
 
-		/*
-		 * STE may be live, and the SMMU might read dwords of this CD in any
-		 * order. Ensure that it observes valid values before reading
-		 * V=1.
-		 */
-		arm_smmu_sync_cd(master, ssid, true);
-
 		val = cd->tcr |
 #ifdef __BIG_ENDIAN
 			CTXDESC_CD_0_ENDI |
@@ -1211,18 +1256,8 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
 		if (cd_table->stall_enabled)
 			val |= CTXDESC_CD_0_S;
 	}
-
-	/*
-	 * The SMMU accesses 64-bit values atomically. See IHI0070Ca 3.21.3
-	 * "Configuration structures and configuration invalidation completion"
-	 *
-	 *   The size of single-copy atomic reads made by the SMMU is
-	 *   IMPLEMENTATION DEFINED but must be at least 64 bits. Any single
-	 *   field within an aligned 64-bit span of a structure can be altered
-	 *   without first making the structure invalid.
-	 */
-	WRITE_ONCE(cdptr->data[0], cpu_to_le64(val));
-	arm_smmu_sync_cd(master, ssid, true);
+	cdptr->data[0] = cpu_to_le64(val);
+	arm_smmu_write_cd_entry(master, ssid, cd_table_entry, &target);
 	return 0;
 }
 
-- 
2.43.0


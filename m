Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0983612D;
	Tue,  6 Aug 2024 23:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722987098; cv=fail; b=jq1nmqAOx92AaDWZwkprMNkC/XL0uJAMqmOY1gDO9Ho03lFbFhlwNg79CMQy87sc38HlIU+TK2LCtSB/pbJxbxJS72O2RlAER1idRY0K/soIkeKrctyAD3RFFReIBT68/zC4t4ny2iA9wLgHhHeUSP+J+hsUYdlox+Sr5E/Mwmo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722987098; c=relaxed/simple;
	bh=6bi4BLBx5arwYk5kX5jadgrH1GOumkI73kSHZczDsbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ua7fAvE+lg+VKNctp0MpktocZV+XN6k+22IBv/4y6fQFYtnycMvQCVNK58StHYWDKt7zzPOTi5FF7VDvQTae6TsyR03SpinHTfE68M3FEROoQ+3rNyIroU5gqnLi2i9/6w7HkOPel7TZ8+8TcuIT8K6pItasS/33rCmv63X7zVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FXcFX37d; arc=fail smtp.client-ip=40.107.92.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FXcFX37d"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LfvgOwgBGQ4wBybqY1J04NDF5tg4HKEmJh2DCZ4NrGsyRh+RwyEWDV2cSGR5iN8ANny4PaI0c1FpnzJPHxbVFEvulW71NtJSZ9dzwCcrmg98DwPXpMZWA4IHx5wiWibhbHF+a8Oo5nYaum1UjuPT4SmSWVfLzJWiCxNKxtuntJqwKPqPfbotd5q4owKX8YniZ+lwJdvlOYydF4T+zzLTA2hdC46ys+Azy9bT5jp9c9+lOTxeChJafp/MIGgTOlnRTJ7J1ZTBICd303Q7AgvkbyPwOkpEmqKltbPFZ0Lq9F/Sgm3NTGMFsX8yVvrEz+1HmfeTmrQDcdh+nNSUF3mo1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T1E03LnkCmgGfrA4V3+dB592/Pxr4UaQifcRBwkPyNI=;
 b=jJqhe5MKyyNnIewFo8RYIf1lml1DIKQN6pSEIx6N03Fiffqz4mSJbWKt0edKoRKOQA730uyXDFkN2A4rDlTbHW5OL60kAB+p7QdbRj0qMz3xkbkI1hpvX8+l2KXADlfefPXnw7mxS/soCvOSG80onoqYVd+vLJWFrYWaBs4Jg8ZoeNq82hep8rNwPtM/wsPmWDyvUIyJv1tGFDq0vz2REixvzP2V0Bx1+BJoqBMwtyhwrW0fXc9M5+icUuG1P/GltIU3+tlH13FCKYZgxqKAUIpyrPDsSlR7rPPIwo+fooDPZYae8YezK4auZuljL6dTZuof7uXuP+qnjRLmXz1v3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T1E03LnkCmgGfrA4V3+dB592/Pxr4UaQifcRBwkPyNI=;
 b=FXcFX37dTDMfhuTpTYqgXqVGKduURIvbukVq5qMphgvXqegVJaZ2WsPLmuPXUb+19M1Fci4b9JxM4HglCebXiJkMjffKhqgwhlZD29SFwtz6JKs8604z6UqGtNNp8cL3g99PwMl2XGNx1jGvmORIiKIk/KTqO+iWDB2+o7XXiOgFu5u1SY30Iak0ToSpeGr0lofE3Fnn9gEJ2iW0Aii3pbwtKPW9/oi6lZTcpCGxV/vwbUBe6KK6OVD1jnX9Re3CRwBmNDeVkcDrOWVgEFXO9V7XAFFx4FB14x9cGubRiNXjtFufyNcKDAZeLJf2eajgcE32ZDGXNKfUHfCsfvNpFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH0PR12MB7839.namprd12.prod.outlook.com (2603:10b6:510:286::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Tue, 6 Aug
 2024 23:31:31 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 23:31:31 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 2/9] iommu/arm-smmu-v3: Add arm_smmu_strtab_l1/2_idx()
Date: Tue,  6 Aug 2024 20:31:16 -0300
Message-ID: <2-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0409.namprd03.prod.outlook.com
 (2603:10b6:408:111::24) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH0PR12MB7839:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e0dc7b4-258f-4d87-44fd-08dcb66fe391
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U8cDEOgUgoYbwqfZaDGzfSK4VGKdpHRPbG0cxVgpZMKwDb6eJIknWYzPabHt?=
 =?us-ascii?Q?5T/b+Bj9/qJz9jaa3wLhlqSOXyXFxEQEdSkQI+GhuVQPQKVTGHJr9EpUZR7p?=
 =?us-ascii?Q?SCtWmUSEfgJDIAymQMyCjQYCiPO5J96Oshy4NY4me/kRFLAI6e8ZHj/0Ug8/?=
 =?us-ascii?Q?a6qubNeD1K5huqhbfoVXr3fr7TjNh0q/Srlv3bkUeCeQx0KBV1PxjlExV0Uk?=
 =?us-ascii?Q?UuJ8fAHp5989auPcxCl2OfLUY8lnPoh3bI672T1qnSMGRemXlnsSNewsZSi/?=
 =?us-ascii?Q?z4Bc796qswosTXasRKGQ5mg853d/snSTegU9tlZUUvAdE0V8br4tFDrWyf2V?=
 =?us-ascii?Q?/TRFmC/To8KO0skZKwA0kPnzjZ1vUCuMKkHmpDuWR2Y10dn3E7Ak69IMh7+9?=
 =?us-ascii?Q?07+VZ8Wd80EzAOkWR9+86owBsVe6acFRH9FjZ4joGeug6mbsVD5k7XpYUOE5?=
 =?us-ascii?Q?FeuDNncE8x59edtAR4jNPBLWGl68sT2M/m2Nb7hM1PSFILB9ycNrVU4dJFW7?=
 =?us-ascii?Q?yqqKeKOqmvBR7LZ2nk9xwqgdsJJ+IK4t6bfq29ZfPFpEdSWVMmhprYfGyZNf?=
 =?us-ascii?Q?f7eaUbhZXUDzZJN/bhrFNRuo/Zjadj0BcnBZO2zyqJPw3IP8EOi579M49//N?=
 =?us-ascii?Q?CWkUcaj7xXXtUgUtaSUtmkJl45sk2ujtftcEbB3tO2K/uDw4vHKN3JJD/FX7?=
 =?us-ascii?Q?pFvNzydAdq0/5zob2cC3liQw6st/6zfIe/jerbP87zR5KI97ZwfIRSZuNXl+?=
 =?us-ascii?Q?O48qc+8puUBszjSWrIcmcTUMiHIGtuAevoSYYweaCtVNlyI0tcPLPKZgiojK?=
 =?us-ascii?Q?Wco7Qwn1KoShBdmDCQVy/MQ3sITlWgqPzLM2cHOJOyKkvcjnuf+V21ePUyvd?=
 =?us-ascii?Q?5yQbJjckRnErB89XRLv73h5kWEnTf3qecAJAYcOSHNk6RTxYa/BXOxV7ByVG?=
 =?us-ascii?Q?uol7PYpxzWPhCHR6ds8fjgLzMbyiKy/7oEjCGwY803YFyW68OrLRYgl/jO5+?=
 =?us-ascii?Q?1TRL2m04mJcBHu/oO52AqkQq+j4F/1AoeEThb+GdT08gyEn7XUUjbUeIz3up?=
 =?us-ascii?Q?QF7SSmxMY6hY/gkfr10dETuTmqylPiT/KnyyGTngzzNbE56gV/cE5kuDduGJ?=
 =?us-ascii?Q?zOQwwllVJahzxHJAQ/EgtF0rK+Jk7PYCxaZrK52ekO9I2PLBq/M0ao0irElT?=
 =?us-ascii?Q?pPgs82cFEN3NOoekZdRuGIW9/JR9NtPTrGIZuieNbJIl/a5dKGqBUL6J/VYc?=
 =?us-ascii?Q?UVxZx8GKZ6xOQaRosKoC7l1l31n9ITcNuKfp3Psysgh4nFXRteXKvmSDpMxH?=
 =?us-ascii?Q?lhCe6lGpwzMvowpegR8x99PAONgXUXfR6EUKuY2QjvLruQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RT5S42n+eE6NRLjXfJIRfVBHegp2Wf3WihknsUz3w1AwfD8Sxr0G4S5Q+s/M?=
 =?us-ascii?Q?vQF775ZX225/S4Pyu6RNM/aWCvv08FPSDfe2xf8i4G9dMhjzkGjodcOUkhZA?=
 =?us-ascii?Q?GzRVcn9YGxZ7qfEZFjsEL6bCufIbslfHz1HambJzAvO/z/Pu0Hxuvx5NtHFl?=
 =?us-ascii?Q?8EWqy9cpehH3PbReTxyrzkd8BOAWYS3TRmF4XvfiU+pwhTaF+MqnTF4pXRxw?=
 =?us-ascii?Q?szF+Kei4Efp10y1zJP1DV9bI6CVgFxtZFd5B7o6OXt4iD+wkNmycSYoBVbVq?=
 =?us-ascii?Q?JgrquSTpeYc62yPZy/RUa19qMav8zG/JFE3uWzBdYzCCHFGkHMFDCG5WVjgz?=
 =?us-ascii?Q?xRcaEKBJZ1f+4wVMJkTXX8dT4CoOm0WaJ+LCHU7cUye/jX4J6iOP0wU128/Q?=
 =?us-ascii?Q?64bbVOKY/I823GA3e7AK85G7a/9gIpUHhsj6eEWb3WfIiGJKmpRykbbA0dT8?=
 =?us-ascii?Q?CRRZFZjhpZleTzLZnNsSfo1SDvA+vM6Bgb7G90zDYkLpNSC08en1US2NPgKq?=
 =?us-ascii?Q?NmYofQu4AQkqWvVocKJgCna9CSre+DuhHLKXJp3RdgsoAPOtAguyCDtbrn1V?=
 =?us-ascii?Q?b2xd1cOmfaM7cNK3IYiTCW1LdkaE91AmsAhcJKUKiBrCVOSoBV7VKTQccbbt?=
 =?us-ascii?Q?k5kVPBSG5u8DpYe3N1cVU+0q4JdxvSL0NXpZvvEohVTseIvftI4F1jAjljP7?=
 =?us-ascii?Q?eGOIQb6T2WtMEefHDCorLKV33zjH7JXZwWtrXuug5ef89rl3xyZ8iztrfIxJ?=
 =?us-ascii?Q?s0aF0csH4ObGRRNMWDiFOu/kkwyROdonKx8wP0odoAapNlO9481VtqatmgL2?=
 =?us-ascii?Q?z5X7l9My6gm3pUzvG3fYxkvRn8si6FYeqGZ12ekxxIoJevgpi4w7L3WDfnR7?=
 =?us-ascii?Q?5funkpBmjEL4g4bw+gvbT1qgkJ1gtiH7vSYWaiqdPUD+el6DEgowckDU0206?=
 =?us-ascii?Q?qanyqIS1QXgA1i6ZcemICI1FFx+muKgmXGGNWRuW0SaDaj/fTnva7oSloLZW?=
 =?us-ascii?Q?sOkfBNVIKAP1KyoK/bm4kmtlthYzTf/tIz3yGGEFh1wX7xmC2fIlNYv/PeHX?=
 =?us-ascii?Q?eEuJz6oNFxzX+1mcEZ1ZhFQCmQcV2OzTBb6KNmh3QrFwrjVeWfataDCwNWCE?=
 =?us-ascii?Q?0Ze0C0SfVElLZK7tdi3/+WXVSBa4HTdsJ/3hT6ki1sE5EZzxyaqJQ50Zhi1D?=
 =?us-ascii?Q?xxEqZaSwR28CslArybinmjKl6ZLaL984eqWTWzGBFjxzsDALsvaXzeeB+rZx?=
 =?us-ascii?Q?l5pFu0a9Dryv/CtmSnFXln2wEXLHfU9Hoa5XcFud7gk0jG7Iis82EBwvsDQ4?=
 =?us-ascii?Q?FPB9OKcrGAqIbuMH8LT3Wg4IfffsH3oMn3IbZMtD6v7hOZRk7enKilRL5WBP?=
 =?us-ascii?Q?JRE9/79RlNsMkswXectEHwzTYh6MbD7+smP2Cbqf5XwaeqvXo5QqT8e6uIqo?=
 =?us-ascii?Q?1VXrfZ/KZy8VcblGIhcXiTFauCJGzFykdMtLjDcG0OHJWkqMTwBxIOpzx64Z?=
 =?us-ascii?Q?RXy8WOiGskl9Sx3oZ2PiNUYyYqNSrQt3IUqinIEa8nA4xOyp5DyXEn38tF9y?=
 =?us-ascii?Q?HMOGHQVDPEalYsJNmOw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e0dc7b4-258f-4d87-44fd-08dcb66fe391
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 23:31:25.6138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hMUFlc4EIYzPq3lNHBtHPcvoaHmmj0nKlNXkYsW/an1cpzwp6ye3wa3+GQZ0UiuC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7839

Don't open code the calculations of the indexes for each level, provide
two functions to do that math and call them in all the places. Update all
the places computing indexes.

Calculate the L1 table size directly based on the max required index from
the cap. Remove STRTAB_L1_SZ_SHIFT in favour of STRTAB_NUM_L2_STES.

Use STRTAB_NUM_L2_STES to replace remaining open coded 1 << STRTAB_SPLIT.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 51 +++++++++------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 14 +++++-
 2 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b80f3359a8d12b..a695e5f8fc2880 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1670,20 +1670,17 @@ static void arm_smmu_init_initial_stes(struct arm_smmu_ste *strtab,
 
 static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 {
-	size_t size;
-	void *strtab;
 	dma_addr_t l2ptr_dma;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
-	struct arm_smmu_strtab_l1_desc *desc = &cfg->l1_desc[sid >> STRTAB_SPLIT];
+	struct arm_smmu_strtab_l1_desc *desc =
+		&cfg->l1_desc[arm_smmu_strtab_l1_idx(sid)];
 
 	if (desc->l2ptr)
 		return 0;
 
-	size = 1 << (STRTAB_SPLIT + ilog2(STRTAB_STE_DWORDS) + 3);
-	strtab = &cfg->strtab[(sid >> STRTAB_SPLIT) * STRTAB_L1_DESC_DWORDS];
-
-	desc->l2ptr = dmam_alloc_coherent(smmu->dev, size, &l2ptr_dma,
-					  GFP_KERNEL);
+	desc->l2ptr = dmam_alloc_coherent(
+		smmu->dev, STRTAB_NUM_L2_STES * sizeof(struct arm_smmu_ste),
+		&l2ptr_dma, GFP_KERNEL);
 	if (!desc->l2ptr) {
 		dev_err(smmu->dev,
 			"failed to allocate l2 stream table for SID %u\n",
@@ -1691,8 +1688,9 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 		return -ENOMEM;
 	}
 
-	arm_smmu_init_initial_stes(desc->l2ptr, 1 << STRTAB_SPLIT);
-	arm_smmu_write_strtab_l1_desc(strtab, l2ptr_dma);
+	arm_smmu_init_initial_stes(desc->l2ptr, STRTAB_NUM_L2_STES);
+	arm_smmu_write_strtab_l1_desc(&cfg->strtab[arm_smmu_strtab_l1_idx(sid)],
+				      l2ptr_dma);
 	return 0;
 }
 
@@ -2449,12 +2447,9 @@ arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
 
 	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
-		unsigned int idx1, idx2;
-
 		/* Two-level walk */
-		idx1 = (sid >> STRTAB_SPLIT) * STRTAB_L1_DESC_DWORDS;
-		idx2 = sid & ((1 << STRTAB_SPLIT) - 1);
-		return &cfg->l1_desc[idx1].l2ptr[idx2];
+		return &cfg->l1_desc[arm_smmu_strtab_l1_idx(sid)]
+				.l2ptr[arm_smmu_strtab_l2_idx(sid)];
 	} else {
 		/* Simple linear lookup */
 		return (struct arm_smmu_ste *)&cfg
@@ -3158,12 +3153,10 @@ struct arm_smmu_device *arm_smmu_get_by_fwnode(struct fwnode_handle *fwnode)
 
 static bool arm_smmu_sid_in_range(struct arm_smmu_device *smmu, u32 sid)
 {
-	unsigned long limit = smmu->strtab_cfg.num_l1_ents;
-
 	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB)
-		limit *= 1UL << STRTAB_SPLIT;
-
-	return sid < limit;
+		return arm_smmu_strtab_l1_idx(sid) <
+		       smmu->strtab_cfg.num_l1_ents;
+	return sid < smmu->strtab_cfg.num_l1_ents;
 }
 
 static int arm_smmu_init_sid_strtab(struct arm_smmu_device *smmu, u32 sid)
@@ -3602,19 +3595,18 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 {
 	void *strtab;
 	u64 reg;
-	u32 size, l1size;
+	u32 l1size;
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
+	unsigned int last_sid_idx =
+		arm_smmu_strtab_l1_idx((1 << smmu->sid_bits) - 1);
 
 	/* Calculate the L1 size, capped to the SIDSIZE. */
-	size = STRTAB_L1_SZ_SHIFT - (ilog2(STRTAB_L1_DESC_DWORDS) + 3);
-	size = min(size, smmu->sid_bits - STRTAB_SPLIT);
-	cfg->num_l1_ents = 1 << size;
-
-	size += STRTAB_SPLIT;
-	if (size < smmu->sid_bits)
+	cfg->num_l1_ents = min(last_sid_idx + 1, STRTAB_MAX_L1_ENTRIES);
+	if (cfg->num_l1_ents <= last_sid_idx)
 		dev_warn(smmu->dev,
 			 "2-level strtab only covers %u/%u bits of SID\n",
-			 size, smmu->sid_bits);
+			 ilog2(cfg->num_l1_ents * STRTAB_NUM_L2_STES),
+			 smmu->sid_bits);
 
 	l1size = cfg->num_l1_ents * (STRTAB_L1_DESC_DWORDS << 3);
 	strtab = dmam_alloc_coherent(smmu->dev, l1size, &cfg->strtab_dma,
@@ -3629,7 +3621,8 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 
 	/* Configure strtab_base_cfg for 2 levels */
 	reg  = FIELD_PREP(STRTAB_BASE_CFG_FMT, STRTAB_BASE_CFG_FMT_2LVL);
-	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, size);
+	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE,
+			  ilog2(cfg->num_l1_ents) + STRTAB_SPLIT);
 	reg |= FIELD_PREP(STRTAB_BASE_CFG_SPLIT, STRTAB_SPLIT);
 	cfg->strtab_base_cfg = reg;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 14bca41a981b43..45ec88c9aa355f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -202,7 +202,6 @@
  * 2lvl: 128k L1 entries,
  *       256 lazy entries per table (each table covers a PCI bus)
  */
-#define STRTAB_L1_SZ_SHIFT		20
 #define STRTAB_SPLIT			8
 
 #define STRTAB_L1_DESC_DWORDS		1
@@ -215,6 +214,19 @@ struct arm_smmu_ste {
 	__le64 data[STRTAB_STE_DWORDS];
 };
 
+#define STRTAB_NUM_L2_STES		(1 << STRTAB_SPLIT)
+#define STRTAB_MAX_L1_ENTRIES		(1 << 17)
+
+static inline u32 arm_smmu_strtab_l1_idx(u32 sid)
+{
+	return sid / STRTAB_NUM_L2_STES;
+}
+
+static inline u32 arm_smmu_strtab_l2_idx(u32 sid)
+{
+	return sid % STRTAB_NUM_L2_STES;
+}
+
 #define STRTAB_STE_0_V			(1UL << 0)
 #define STRTAB_STE_0_CFG		GENMASK_ULL(3, 1)
 #define STRTAB_STE_0_CFG_ABORT		0
-- 
2.46.0


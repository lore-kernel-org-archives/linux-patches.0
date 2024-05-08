Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13D912BF04;
	Wed,  8 May 2024 18:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715194655; cv=fail; b=c+IL/bmI7TUvUfAvA1BL9+lqSwtiVBVXth+CDlRrwpi/ITsFGnE5vl014PZCXBk+y4uOCYuZhywEHGP+vjQZaK8YF35aXlBFgERytepeEZGDQyT3L1ObLVLA+WS4Er+0fhc3ubfKxgmmOYtlZLR0KP/+SjQ3B6qpo8Jun7MFDBU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715194655; c=relaxed/simple;
	bh=iYxrYqIORI+398r2Qsd2lfPvi0uOfX+h+KWcpA2Xi8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QaRFlZ2j+fJX6Lvs60Sl4f+OJQX5+ucjKfRqpSreEE66q/DbSy9OPPN/PjST6ywX7ae54USyZRXhqkXWwn2J7yfF/aaQA8PH2P39oJwRJXjtghKtXa25gb1vKwOolR9Zb3fdiGqVAAC6YZsLe0/7bOSIyFFz+BdPEZelbR7RiHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TXddNuew; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TXddNuew"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4FqwE/uXkyfFg5wKaTVvx1S3BGNQBKqbkA5tJm7NTR1YtcNkisggPUFJZMEL+aZcRMPw7Lb7a5TSEakZkdspegLjhcDUz+WsPOo8BQRhqRlK8q+5egEMmgz8nGR4paAG7lHViD2YRymbeLxFmTfDprHgHCFGFOT4DMU901HM/2rKIv71+VT7T04M8SJWt4BMx+CRQh5vAJ50MEfa03MqR5DxE6ez8PvzOLsQntxtc9Ph1sDrggG26+65AwWa/DG74sxPocv487IXCWiUXnnUB75xrjpTjXirZ9wUeLDJ2oMPlqqdFcAhHHEs6Z48d/lxxu4h6XRt3XLYZz8JiL+YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xJVkKR6h/UPUFZGtWxN0hcTMSGKB62GiZmLTaZWpbcM=;
 b=JSo8mCjRjjjmTsAIBE6U4xVHqJs+/Z31CCxMkWl79d5g6L0doihLG4F/SGfuRb7eOr66Y4NjqPEFwch+xJQUhTAJpSLz9j1sbMmGtNTadOeVzTW9XvitsuY+fPQxt6WVyQLU1kSSRZ42n2dqpIssirdN7+5Wnhp/8ZnWPq1kLmdbBOWQsDNwdNkA3TaZg7mYh3RrNedDpyU4xqDq4zCB6YMIEP+4J2vNpEN42tKzDjVL34/SZXXBg3C+2Wf6UtJVd4mf0Ib0XrBPq8Uaiq43AtHD1xycmJnnq+AMAFF0NDaqU6vl+CEoZeSS/W1yMLjezDXrRvWAecvb9nG4OEVlgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJVkKR6h/UPUFZGtWxN0hcTMSGKB62GiZmLTaZWpbcM=;
 b=TXddNuew9GyDf9yjNDCQp7ACyQlJFB+Lb1qXN7HOhF5/7kMvVno/P3a6gWW76r5jdqSy0gLhqyZ6IY9Bas04CT9kD5pjFtRLPdmSVPG+xOeilRtoMC7rnUG/txmJZ2vla+j8nxyxRNykxcTxaUHadFDbBea83OBbRZvbVKB0Vu0gGETSPaSZwkkif6EuYvQoePPjcozgzKwemSE8WcYCvI1wLpTDQBhuJIxTLp+25xft67b3EUbnXarpW2ZTvJv+OPiwMYi6gE2bKFH+KzUsJYbgo+rz+Mjw9oZTjGOeiv/izLjBk3H0BtVfeeyGGkX30ydyyEUadHlQrxQEsbhKUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB7514.namprd12.prod.outlook.com (2603:10b6:930:92::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Wed, 8 May
 2024 18:57:26 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Wed, 8 May 2024
 18:57:26 +0000
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
Subject: [PATCH v7 12/14] iommu/arm-smmu-v3: Test the STE S1DSS functionality
Date: Wed,  8 May 2024 15:57:20 -0300
Message-ID: <12-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0158.namprd03.prod.outlook.com
 (2603:10b6:208:32f::24) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB7514:EE_
X-MS-Office365-Filtering-Correlation-Id: 179cffd4-feb3-4b39-56b3-08dc6f90b31e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dJ6uk1waztZGBvM7ZSp4UhbiG/fNyakJ9qZaQPYNZBmj1j1JU90BpMfhFu8S?=
 =?us-ascii?Q?pluA7ZHFtK1lEi1FUwPuZq0mvC3u4Wo51YgyPJAmRauRI4STrvo0D3mTtPt1?=
 =?us-ascii?Q?6yyiR6QGyvBi+mAjurZtCoXPLSNP2LzwWnRgxelnSDatQOAuet47KbRAjyud?=
 =?us-ascii?Q?sjqaWLQrCBpVfvs1lw1QceOIRbPF10J60cvi5jyHWO/zL/v9LnAbkMXqPu+r?=
 =?us-ascii?Q?G8DRskLCKVwCRztJyipvy8I9R9MNaA/olrLQND+9rn8rDVmbjzFuwtG2JB7s?=
 =?us-ascii?Q?V1V7woqS75928fk02aBSLFdx7m+i1VUk2XtZLrJHtWt9+KAe/cOq63LRcvB+?=
 =?us-ascii?Q?uf1O7W0ko5pW/yrPgSN0vAEQv33vsz5/2ZznjXM/F4Ujlx1LxkbfvFjsR7KD?=
 =?us-ascii?Q?92v/jcLBKkxXuYBiFTYu7ZUfgMdGUu3/ioi8L7ih7fM+swNueKrVEWzMWzQ5?=
 =?us-ascii?Q?yEqZ1g/ELmPzqLbc3L0Yp9SmT8iWdFWC/+VNtbqPj5lwSJ1Q9IXzu5nPHMlu?=
 =?us-ascii?Q?VxOfqntaK6ckpEekpXHvRFXcy3jPZv0C09tYPwmy3yVeCrRMwRu4suqXyDWQ?=
 =?us-ascii?Q?jwPmw+3kxE4ZtT+Axc4v/Bj6YIiYiS7azUNd//3C9ctXJE50TycfvtOzjSDm?=
 =?us-ascii?Q?eAjEDgqC+fzoDipH/YqU+o6DR5MulV1axYUYYELuLZFnuMMOwn+B8b0Df2a7?=
 =?us-ascii?Q?5vbTaV1zgR1zst33vhp4GyhlX7RJSg7d2XUSbAeF+gfjtuy9GOFFVYZ5zySs?=
 =?us-ascii?Q?vOdixLw614afTyflQzTDfMhHdMgdc34sPObFbi1r6MRrEkWeAIsKYbcpBQib?=
 =?us-ascii?Q?a8881L6wxy6XjP1K/io/RaCDwCSJ9ZoI1rdIyox67Wwqy+mNsoo6n1bGRR8N?=
 =?us-ascii?Q?d85v2M+Dw57TqR1PPbId27jDHGLOaIL9sly0t661df+c6ScQWx3HWYTcV5ip?=
 =?us-ascii?Q?tUSS8aVn+VPxX7Go/Y03jBPiOmhCTtFHt9cG/2lXLyX0ShRUR/TQ9ies5nZ7?=
 =?us-ascii?Q?/vMekdMNboqPcC/SSmwLMcon7lfTHItgqMuvg/9CJAQXdPYuCgwKk+xns2w/?=
 =?us-ascii?Q?un6NncBoHeirpOeNtwoczc0b//nxrRFPj/KBZQJKDRhQFWaFar2rI5JETiaH?=
 =?us-ascii?Q?h1j7YCGBEXdMCMy+uOAagD1ZWbaoNT0H/8797Z36OtErFQsCHZXhQQ/+aUik?=
 =?us-ascii?Q?uRawNYxwhBjb0xgJ7Y84AB64GFWoXCNNKORw/Q797AwAvdsvw+7ubBaoPir2?=
 =?us-ascii?Q?szrx2WlcD4P0WXB6kpt6fl+wMxMVpWOWRjTR7J6VTA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j6lEEiX+uLdX3htcjXMxYq7bqggIxKMFTW2910Bf2SGUwg6l9nTTaBjuCsny?=
 =?us-ascii?Q?6AzyH5tfRPP8NVMnKlvugvZBpDOs/61HFCNRMIee0GNZl0CMEHThtf6WOwIy?=
 =?us-ascii?Q?2jjjXojxQirIiPD66lHv1GLq4HTSbNBN4BWh3C3tlNmhSNPA/29+FMPpCTKV?=
 =?us-ascii?Q?Ug9/Ym78aHUFSXGloC/+ZNyQoGIfdaL28ROYHecRBveRVBjahNcFLePWAlOM?=
 =?us-ascii?Q?rvETMUf9zTdjgyFMFTatAfOa0+7pF7VDRNfAEyVatD4P0LbVtD9Nbly+ZE2b?=
 =?us-ascii?Q?4HAdZvzfXDyl7l3oQeaBNJ/uBxh9452W7VqjSvAK36Soa1f2xnzdWfdQiCF8?=
 =?us-ascii?Q?Ux+ydJKVHH4j26cKeJ61J14mjtGIV57e0Np2fv6ac5eNgmLYiyDJDAn9WOys?=
 =?us-ascii?Q?X/o33qKN1Y5SkDaY08BH3VHJSzlDyYsg+ClW78T0ZDy2tv3DTwcJ9Qswnxwp?=
 =?us-ascii?Q?5Ry8AKKRIFAgGTyRyYuNimhWdxqWOQ6eP4TfU0h/4b4fD2J9emxosm6ynRjB?=
 =?us-ascii?Q?ztBtMD/Kl9RZ/7pttl3a19NrUvxEB3f83JEOylhpdngrgDoYTzARR/QxIuLL?=
 =?us-ascii?Q?Q0/WRvjvTR3iPF6FxwGyINNeF8yQKq5+l7RLknjSq0qy/HDewSZR+V4Df9r+?=
 =?us-ascii?Q?rB67njutjIZW+pCFEwz8/NwT+zfb2AIZ5epr6855CTP3IvkFjG4H6rv2XCLq?=
 =?us-ascii?Q?j5N7ABDtViT9SL9yS1RD9hQ/TEKWYtDB7M+MD5E81bTy+MCA1IhsyFNnjGWe?=
 =?us-ascii?Q?4g/jpaKLiG/5EF0cW2iZ18+Pd3Sj+Kkt1fKnzpbGrhBu0higXyWcs5Ux60RT?=
 =?us-ascii?Q?FbvN7kIloqAlghzSIsCYZK+uCSlAjbtp5jiMwnTVxURydQJc/VGF4Y3x/l0P?=
 =?us-ascii?Q?zlEUI3ZJIM9nWFSoHdI8DEF/grc9esiez80BPlosKXkNBGxdoMt5sbsv8rh+?=
 =?us-ascii?Q?xgh1RJgi+b/uAuxrRQeR6fXMdmw8CJyAjkzwftoab05U/h91BrM2a4YBr2BB?=
 =?us-ascii?Q?+09DtGZup5Dcjhm4/PC/tfYdBitaKkZk3XgzeHS5aVwKLXfWcDSS/s9R11zU?=
 =?us-ascii?Q?jI+hMO7RoPpoMOMbsdANzfeZxkYYvWQFaeRpWvmMxIE7N0nXJqjvYDS/9kqb?=
 =?us-ascii?Q?RToVKnjX9P0pklZd6W+pzmP21C7a1QByPhDlHCgsPgfuG/QlrbyLrSCW2kp2?=
 =?us-ascii?Q?oDHkDSxhgR6S3/4cSE53w/SxV/89DefXVbYwVtdbQ97+O7oT5EjAdsagrSPQ?=
 =?us-ascii?Q?WbT6bEK7OP+N3Dvw/6fDQuepGiVtMBMvb792yF+E+1LtJGvYm+0FuwTc/uJ/?=
 =?us-ascii?Q?ZSFzX491NZA7r2HgiVXJgMiloIaS4Y3HJE71HWIpumiFa6M0HRfn7LKELZ+o?=
 =?us-ascii?Q?5JQLobFDViQJ7ec3NzfgUb5+8L7gw8IlbDN0EvTUdAJrepYa+TQZzZGWIauy?=
 =?us-ascii?Q?+BkJ/CJK0uUH91o8jYg3I22RKpWiUO9XpxvMcG03bYEzaXGnpIiKN1tms5vB?=
 =?us-ascii?Q?/iyBcY3LoK2LzBvodpucBOGtDogjezlbVNKpWSHDS8g3Sy/vVYeG73Zh/qg1?=
 =?us-ascii?Q?nD5/yRYNjbfx01SY9Bjre0lj8M2/wGFU2pPgUnpl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 179cffd4-feb3-4b39-56b3-08dc6f90b31e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 18:57:25.3682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TesYD40LV5znsHE0BRvlAMDObT90tmAxX03rNO1et+HQAswp2rRmqJo1FNQHqYrC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7514

S1DSS brings in quite a few new transition pairs that are
interesting. Test to/from S1DSS_BYPASS <-> S1DSS_SSID0, and
BYPASS <-> S1DSS_SSID0.

Test a contrived non-hitless flow to make sure that the logic works.

Signed-off-by: Michael Shavit <mshavit@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 113 +++++++++++++++++-
 1 file changed, 108 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index d7e022bb9df530..e0fce31eba54dd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -144,6 +144,14 @@ static void arm_smmu_v3_test_ste_expect_transition(
 	KUNIT_EXPECT_MEMEQ(test, target->data, cur_copy.data, sizeof(cur_copy));
 }
 
+static void arm_smmu_v3_test_ste_expect_non_hitless_transition(
+	struct kunit *test, const struct arm_smmu_ste *cur,
+	const struct arm_smmu_ste *target, unsigned int num_syncs_expected)
+{
+	arm_smmu_v3_test_ste_expect_transition(test, cur, target,
+					       num_syncs_expected, false);
+}
+
 static void arm_smmu_v3_test_ste_expect_hitless_transition(
 	struct kunit *test, const struct arm_smmu_ste *cur,
 	const struct arm_smmu_ste *target, unsigned int num_syncs_expected)
@@ -155,6 +163,7 @@ static void arm_smmu_v3_test_ste_expect_hitless_transition(
 static const dma_addr_t fake_cdtab_dma_addr = 0xF0F0F0F0F0F0;
 
 static void arm_smmu_test_make_cdtable_ste(struct arm_smmu_ste *ste,
+					   unsigned int s1dss,
 					   const dma_addr_t dma_addr)
 {
 	struct arm_smmu_master master = {
@@ -164,7 +173,7 @@ static void arm_smmu_test_make_cdtable_ste(struct arm_smmu_ste *ste,
 		.smmu = &smmu,
 	};
 
-	arm_smmu_make_cdtable_ste(ste, &master, true, STRTAB_STE_1_S1DSS_SSID0);
+	arm_smmu_make_cdtable_ste(ste, &master, true, s1dss);
 }
 
 static void arm_smmu_v3_write_ste_test_bypass_to_abort(struct kunit *test)
@@ -194,7 +203,8 @@ static void arm_smmu_v3_write_ste_test_cdtable_to_abort(struct kunit *test)
 {
 	struct arm_smmu_ste ste;
 
-	arm_smmu_test_make_cdtable_ste(&ste, fake_cdtab_dma_addr);
+	arm_smmu_test_make_cdtable_ste(&ste, STRTAB_STE_1_S1DSS_SSID0,
+				       fake_cdtab_dma_addr);
 	arm_smmu_v3_test_ste_expect_hitless_transition(test, &ste, &abort_ste,
 						       NUM_EXPECTED_SYNCS(2));
 }
@@ -203,7 +213,8 @@ static void arm_smmu_v3_write_ste_test_abort_to_cdtable(struct kunit *test)
 {
 	struct arm_smmu_ste ste;
 
-	arm_smmu_test_make_cdtable_ste(&ste, fake_cdtab_dma_addr);
+	arm_smmu_test_make_cdtable_ste(&ste, STRTAB_STE_1_S1DSS_SSID0,
+				       fake_cdtab_dma_addr);
 	arm_smmu_v3_test_ste_expect_hitless_transition(test, &abort_ste, &ste,
 						       NUM_EXPECTED_SYNCS(2));
 }
@@ -212,7 +223,8 @@ static void arm_smmu_v3_write_ste_test_cdtable_to_bypass(struct kunit *test)
 {
 	struct arm_smmu_ste ste;
 
-	arm_smmu_test_make_cdtable_ste(&ste, fake_cdtab_dma_addr);
+	arm_smmu_test_make_cdtable_ste(&ste, STRTAB_STE_1_S1DSS_SSID0,
+				       fake_cdtab_dma_addr);
 	arm_smmu_v3_test_ste_expect_hitless_transition(test, &ste, &bypass_ste,
 						       NUM_EXPECTED_SYNCS(3));
 }
@@ -221,11 +233,54 @@ static void arm_smmu_v3_write_ste_test_bypass_to_cdtable(struct kunit *test)
 {
 	struct arm_smmu_ste ste;
 
-	arm_smmu_test_make_cdtable_ste(&ste, fake_cdtab_dma_addr);
+	arm_smmu_test_make_cdtable_ste(&ste, STRTAB_STE_1_S1DSS_SSID0,
+				       fake_cdtab_dma_addr);
 	arm_smmu_v3_test_ste_expect_hitless_transition(test, &bypass_ste, &ste,
 						       NUM_EXPECTED_SYNCS(3));
 }
 
+static void arm_smmu_v3_write_ste_test_cdtable_s1dss_change(struct kunit *test)
+{
+	struct arm_smmu_ste ste;
+	struct arm_smmu_ste s1dss_bypass;
+
+	arm_smmu_test_make_cdtable_ste(&ste, STRTAB_STE_1_S1DSS_SSID0,
+				       fake_cdtab_dma_addr);
+	arm_smmu_test_make_cdtable_ste(&s1dss_bypass, STRTAB_STE_1_S1DSS_BYPASS,
+				       fake_cdtab_dma_addr);
+
+	/*
+	 * Flipping s1dss on a CD table STE only involves changes to the second
+	 * qword of an STE and can be done in a single write.
+	 */
+	arm_smmu_v3_test_ste_expect_hitless_transition(
+		test, &ste, &s1dss_bypass, NUM_EXPECTED_SYNCS(1));
+	arm_smmu_v3_test_ste_expect_hitless_transition(
+		test, &s1dss_bypass, &ste, NUM_EXPECTED_SYNCS(1));
+}
+
+static void
+arm_smmu_v3_write_ste_test_s1dssbypass_to_stebypass(struct kunit *test)
+{
+	struct arm_smmu_ste s1dss_bypass;
+
+	arm_smmu_test_make_cdtable_ste(&s1dss_bypass, STRTAB_STE_1_S1DSS_BYPASS,
+				       fake_cdtab_dma_addr);
+	arm_smmu_v3_test_ste_expect_hitless_transition(
+		test, &s1dss_bypass, &bypass_ste, NUM_EXPECTED_SYNCS(2));
+}
+
+static void
+arm_smmu_v3_write_ste_test_stebypass_to_s1dssbypass(struct kunit *test)
+{
+	struct arm_smmu_ste s1dss_bypass;
+
+	arm_smmu_test_make_cdtable_ste(&s1dss_bypass, STRTAB_STE_1_S1DSS_BYPASS,
+				       fake_cdtab_dma_addr);
+	arm_smmu_v3_test_ste_expect_hitless_transition(
+		test, &bypass_ste, &s1dss_bypass, NUM_EXPECTED_SYNCS(2));
+}
+
 static void arm_smmu_test_make_s2_ste(struct arm_smmu_ste *ste,
 				      bool ats_enabled)
 {
@@ -285,6 +340,48 @@ static void arm_smmu_v3_write_ste_test_bypass_to_s2(struct kunit *test)
 						       NUM_EXPECTED_SYNCS(2));
 }
 
+static void arm_smmu_v3_write_ste_test_s1_to_s2(struct kunit *test)
+{
+	struct arm_smmu_ste s1_ste;
+	struct arm_smmu_ste s2_ste;
+
+	arm_smmu_test_make_cdtable_ste(&s1_ste, STRTAB_STE_1_S1DSS_SSID0,
+				       fake_cdtab_dma_addr);
+	arm_smmu_test_make_s2_ste(&s2_ste, true);
+	arm_smmu_v3_test_ste_expect_hitless_transition(test, &s1_ste, &s2_ste,
+						       NUM_EXPECTED_SYNCS(3));
+}
+
+static void arm_smmu_v3_write_ste_test_s2_to_s1(struct kunit *test)
+{
+	struct arm_smmu_ste s1_ste;
+	struct arm_smmu_ste s2_ste;
+
+	arm_smmu_test_make_cdtable_ste(&s1_ste, STRTAB_STE_1_S1DSS_SSID0,
+				       fake_cdtab_dma_addr);
+	arm_smmu_test_make_s2_ste(&s2_ste, true);
+	arm_smmu_v3_test_ste_expect_hitless_transition(test, &s2_ste, &s1_ste,
+						       NUM_EXPECTED_SYNCS(3));
+}
+
+static void arm_smmu_v3_write_ste_test_non_hitless(struct kunit *test)
+{
+	struct arm_smmu_ste ste;
+	struct arm_smmu_ste ste_2;
+
+	/*
+	 * Although no flow resembles this in practice, one way to force an STE
+	 * update to be non-hitless is to change its CD table pointer as well as
+	 * s1 dss field in the same update.
+	 */
+	arm_smmu_test_make_cdtable_ste(&ste, STRTAB_STE_1_S1DSS_SSID0,
+				       fake_cdtab_dma_addr);
+	arm_smmu_test_make_cdtable_ste(&ste_2, STRTAB_STE_1_S1DSS_BYPASS,
+				       0x4B4B4b4B4B);
+	arm_smmu_v3_test_ste_expect_non_hitless_transition(
+		test, &ste, &ste_2, NUM_EXPECTED_SYNCS(3));
+}
+
 static void arm_smmu_v3_test_cd_expect_transition(
 	struct kunit *test, const struct arm_smmu_cd *cur,
 	const struct arm_smmu_cd *target, unsigned int num_syncs_expected,
@@ -438,10 +535,16 @@ static struct kunit_case arm_smmu_v3_test_cases[] = {
 	KUNIT_CASE(arm_smmu_v3_write_ste_test_abort_to_cdtable),
 	KUNIT_CASE(arm_smmu_v3_write_ste_test_cdtable_to_bypass),
 	KUNIT_CASE(arm_smmu_v3_write_ste_test_bypass_to_cdtable),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_cdtable_s1dss_change),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_s1dssbypass_to_stebypass),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_stebypass_to_s1dssbypass),
 	KUNIT_CASE(arm_smmu_v3_write_ste_test_s2_to_abort),
 	KUNIT_CASE(arm_smmu_v3_write_ste_test_abort_to_s2),
 	KUNIT_CASE(arm_smmu_v3_write_ste_test_s2_to_bypass),
 	KUNIT_CASE(arm_smmu_v3_write_ste_test_bypass_to_s2),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_s1_to_s2),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_s2_to_s1),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_non_hitless),
 	KUNIT_CASE(arm_smmu_v3_write_cd_test_s1_clear),
 	KUNIT_CASE(arm_smmu_v3_write_cd_test_s1_change_asid),
 	KUNIT_CASE(arm_smmu_v3_write_cd_test_sva_clear),
-- 
2.43.2


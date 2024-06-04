Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81E110F9;
	Tue,  4 Jun 2024 00:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717460174; cv=fail; b=q9bIEZU3TDiKR3Jh9/Kbl9uDd+Ul09x7m6z0kfprXVE2Ke8Tx6HP6fSk3Ntyyo1L7uCnS5fUK6lRKwoLX1hEMzD0QAxTwoD6Y7a/2xHMgl5fM+axVF4i0mBE3C97/0jyWmGEd8MA0BiKiraSAFrRCU5dZ+y+ZQv+RhYs/Z1W4uo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717460174; c=relaxed/simple;
	bh=GhVxR5bP0ynvemynxS+11/Wc0zmGVN0dU70NBidQRpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hH8gky/wAMse7zOO01Cu+VxU8BhMU330gGbkNgnCe+4UisYpGux4clc2NbqanID3bFf78AzYRPW5QafMASgSpTdE7VkF800gGptBZAO4kZqtNQEOT2BLX0Pr+7kBrPbiqBxaB5OorjX7lI1tozoYVxQHSF0qbrGAy4eIo6Mcn+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Oo9PqRK/; arc=fail smtp.client-ip=40.107.93.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Oo9PqRK/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RcfeihlrA0ggzFwiv/gFE1Ox71r+6TPYQfPI7EjEP+vYrxDrxanaN76solenG4IR+dra30k9wL2udQQavr1KT/2KehCmtZR6IEW+b39qTKFkzafyC+KA8H3ucqTCmV4aJUOOWzPgPkpS9tWEfzPti6cOKMg+9/TPbt3onY1wsFVytb7kp20eWRYNed+slObd9MEnEOrmu0UyIw1nPA4u/dkEZrP2FDdlpMw2Ou3FcKgw7YMYngmV08vMm1bBp4kQJESs/PE+SqEcE+mn+GSDr3yVi3PvYed3AjG1VAijsNfXjWGAmaykrRVOYaboUC4umaeI36YSIZqidt5n7dnSaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1UiAN3lkYuJyAD+KkD5sC9LRM53icJKfANhch8J4n2A=;
 b=XTi9N0LA65Bf/3kWGlvsoOB+YaFQTP1TPQ3YMm2RLT0NoxO140VmJVxMF/nDtqEMvCs96XV++uwMED0yDeB+asVjcA7Y8cL+BnSDeFvrFomuVPBSrJScUfEbd2Odf3S4s32lF6AQFCuw1FAIZTZIloMc8UIzFqjUkzNEMgL4wKpsOFsyc876VfCttQbeEIAp8108S8xOaRrpFT8BQ+3+89OA0bOG9QkBPPVwMU3CCmVCFg4ndplxZc1sr/tEjql1dX7OIDK7sBodweYsFTTZvyoz+sZGJScBfN2233KOg2uJqyo3VrBpoCI+iORK9Pt65Kzyj+Ih6ficsz9iozKrFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1UiAN3lkYuJyAD+KkD5sC9LRM53icJKfANhch8J4n2A=;
 b=Oo9PqRK/oDG2IJ1EhvvwCf7Fdhj/C9jQrdXlFkUggnJMP32lqJMf/0X61nO9WJbATfKsrwJqd7ZfdOh+mDMSZpW3GTf7mZ75lS1iE8qxfHG1fVvh2ZLMA5kAqtY2cVFeQsHaBl4HwsXnMbJh5uMU9fZGJAVg1pdZeQp8wZsUNTgKha30MNbfM+2BxckZJY/XL86w7LEOYmgZBIOJSp/hDNAHwZ2iNPYEvK0MBubVEWx4kbaMFikE1t8Nl4wYwMdPdAQyDkE1GbV7V11LpyDikkVj+M8E5LfqKF90ZebsPJzkBJEHfOPRGufZh5aZux/fjkW9sniu8z1h9nAwEQ/YdA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by BL3PR12MB6451.namprd12.prod.outlook.com (2603:10b6:208:3ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Tue, 4 Jun
 2024 00:16:06 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 00:16:06 +0000
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
Subject: [PATCH v8 04/14] iommu/arm-smmu-v3: Make changing domains be hitless for ATS
Date: Mon,  3 Jun 2024 21:15:49 -0300
Message-ID: <4-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::13) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|BL3PR12MB6451:EE_
X-MS-Office365-Filtering-Correlation-Id: 45977101-7236-490b-3864-08dc842b857d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LKPwrx7tdsQvOD8Xsd1r5vtwtNmQhEzkgd0dtbQXApB+jZmtmq7Y2ywV9QHX?=
 =?us-ascii?Q?hRgxv3B3eawN79GL1MBbv78lsfpQTASKKgNh8CriFeEerveAUiAls7km2ne3?=
 =?us-ascii?Q?arAgVz8ClMSMrwvilten3sPrAv510B7vMRc2wAmQLeHyHYVESJyPYsLFlqEx?=
 =?us-ascii?Q?WY4cLsW7gk5ghzqq5H9oW5dlTz2lEGFzH2apTaEWEc6P8sFb0SaYMcm6OVgJ?=
 =?us-ascii?Q?OnrKKRAvnimFEEKfJ03CNPeADMSfxBypF8L52JwcjJ7EJX0wJlmtxnTapSS6?=
 =?us-ascii?Q?Orwm+cw+AkY6gqW/mimyjjhNr/hAW4Iqd4Nu1Wtcp+xfrYqkgxXIGACkx4PM?=
 =?us-ascii?Q?uA6SF/Mytb/lz3t5wP+ljqanAUoquFptT2Jy3VCVnbQ2BXW1yOXwlBQEeUpg?=
 =?us-ascii?Q?Z0f47MAuK2mKe61NZAIHdSW/RR0MDblzUSQIsH66QzvJAoM6om4bLRGoD4HL?=
 =?us-ascii?Q?ff+X3g4lWMRncDOE/vXoe4VcHAa4KFhl4Jhjg/p25lWpMbkMpLJAfxIzX+yn?=
 =?us-ascii?Q?b52ydtAfsmtjTomKZYqB154ydZpiMRApyNgWcn52O097A5CG+zSzSi+8z5Ma?=
 =?us-ascii?Q?yp8jui5Xxu3zsBrlOUVgj+2rKj2e4ZdGhi/D+8VcIoBgCiQcRcmRKQZDnslo?=
 =?us-ascii?Q?OKBq78YMcKtnpDkIOUscbTl7hn41Y0LkDsdQrTpPBS/8I9WYatR3EXzrzv6U?=
 =?us-ascii?Q?54PKpzB9w+Epf8UNDXKSLLHLak9y4ye99vNqjU0HqhF5lrXMP2+8GF/lMRIo?=
 =?us-ascii?Q?75vKKaw2DbI60ZxNbIvAQeRjThl2BjPBRixo6eb7/ZG1OD9iE177dYJYVa5u?=
 =?us-ascii?Q?4tVKcnm+Cw2G+SSu9arUiDhAA8D5kFbBWTg2RbVzXAptg+GqyXNhcvhpZ7Qv?=
 =?us-ascii?Q?WEuqVNaJFVXMawFz294Fxf/tnQhX6zki3VOYciGCm4lPn2m0lSF26bVbN9+G?=
 =?us-ascii?Q?IopA7v+lwCR9rtLzOiLAdz3R9tpvFD2OQfCCCBA06lx0ChwwoHs6lb7m6ACe?=
 =?us-ascii?Q?bItdrK034sBJAUgzAun5T4NNZ2WnPIR3eM4nyqKs3cEgyVOY2hHH/UZL7z/k?=
 =?us-ascii?Q?ToOaHDgCi2zDQa7QwXVWUgfiNjlG/R4rVNr12NCVF9KAfJCyZyKr1mXgfQ+H?=
 =?us-ascii?Q?NEzrH30O++BXnVERxClVxMxoKB3lHispCiXvOd4QuLtk2cCbw/WO/6ZV7T2U?=
 =?us-ascii?Q?7zmTfrMWjo7GHtYU1rJsufaiP01ShqHjN+xKnoZlKvj2NWMud/jPHzMIM1ck?=
 =?us-ascii?Q?ErPLRtpsaUQ7+llBhQ/gAdj20T6Oc2e9+LFgkmMvuQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c6ccXQAe9z8ote6e1h8yWZgOuVAB9RlTo0BEx/L1iLtwPIw2EB2pe300VNWN?=
 =?us-ascii?Q?hAt9qihvdIREzmume8rSFkz1y3ndoPFsjVv5LnsVCGZfxfTLqKHHXf2BV+nC?=
 =?us-ascii?Q?idJl3DB6pu6hfQHZFPpBEVqKJ8giXrCQXn8a+GM8mlaAJxD63yeyANeVKZOY?=
 =?us-ascii?Q?woEc6rxjwaWxCClwhvK1b6ZXEM6oYki0BUKe3xuyM73m91k6CXerxVpwX6rM?=
 =?us-ascii?Q?7MGwWTie2pWT7xBlueDMfzCVRxQa6uWMkOj3lt3wFxJHzjYpHGfLx1V9+07d?=
 =?us-ascii?Q?OFJUjbWcLIB/Rks2ZqQVxb0wznEk0BhWP+PcJtcfMC0gvES7O8qLEJWCbmyB?=
 =?us-ascii?Q?WoyJDALhLsK1zMeVvPOGG4MFBVH8iiIt3VLL8Jhg4x7arERDn5WKmqRHu4es?=
 =?us-ascii?Q?w4+0FS6zMWVTm8gMw3PUfwGVRenNHazn8+kRDnaPVnlfOtxI6oA4TIPuftMD?=
 =?us-ascii?Q?S+I1t3TcDpfUb85Pq/oj4Y2Wk414p1uTzvDPHqfr7DYHEfgSEWdip9v5mhKg?=
 =?us-ascii?Q?oafkQNcZYXV58kBQnzuezg9OpTx/rNn8Dzm5DSt1NNV7xHEIay3+LnbWWS+Q?=
 =?us-ascii?Q?r4MRoYdFJtZkRpeAVMwkTlyveL5oWuA0Km0lO6vfpy9crFbj50wKDHGNpX8h?=
 =?us-ascii?Q?s1HXSugVDbzdX83s5lYs8UbLPSlyKzQGDipRblE42J6LXskl0vIj5zB672wi?=
 =?us-ascii?Q?QXIcURNbYRDMoF9gjMxwMEKL9R8zd7Rt/nM1spI4SHxKR2h8PqguCLlPOrO8?=
 =?us-ascii?Q?lXV0dPBxKJSuurwZDt+molcgi5iLL1XySfeJZBcoz1oFEo66BTPL6ixdx3xp?=
 =?us-ascii?Q?5O9o1jskX+6HN1JeFvQ4qVqx/H9GIHWpCgfuqgfey0kdrlVxpgXmd0KCYS51?=
 =?us-ascii?Q?ZxjY+8YgJWT50n/Ylif/flcJ3KjZHw6XWeoP2U8NOEHguwdc5mhOFkTYfCSp?=
 =?us-ascii?Q?b6QIOEY8m81YeRxp5mcYx5MDb+J3J1+fnRn/GFJV9zbPNoIsSE0gQBUGqSUK?=
 =?us-ascii?Q?tsLps3PK48ghSjwLaWrxNezPUN7ALtGG5OKf7El9/5X/fKTLfgxoFr18jzNK?=
 =?us-ascii?Q?3TR7UP5i9HRLJeVuH9i9WXrvNjRproy0ash7lHjNcf6/AJYqkvKWRcmnIiz7?=
 =?us-ascii?Q?Lmj8tyAoG5mK9J9JMK6u/5dmrp3lEZNISr3iUSgs2OfmvFnIQitrboSviFKu?=
 =?us-ascii?Q?pbF7pGN3VGE+6w6jrP5b9WlyhSFpRV32qlrjehrp3vS9t2lYX8iov5aKSdCh?=
 =?us-ascii?Q?W31s0AVKJs/bahEg03TofRLy+oEkixf/G3TPgMVb2OjoltS3tNMXyoO8AONz?=
 =?us-ascii?Q?a/+R7O/uyPNRlMNNVQUJAz8ASE7PjI94WAlwL45pGdovr74ypODmilb2mSKp?=
 =?us-ascii?Q?2d5shj2P1DxmIHbqgGj6W4JWzDiRu3+P7Lise5qHJ5oLFn7cmpHqwKpFdO9B?=
 =?us-ascii?Q?pmCwzAS62XnGsT3Gqk5wO1VVI/QHpQkauIKvigQYtd+K7G90pO8B7iWUtRed?=
 =?us-ascii?Q?Q+UTB9H1+/2HKpDd2qQ0QfZsK1YwtqzcrLk9SgkfkTmOrNkdiqLXAr+ROnho?=
 =?us-ascii?Q?2iaByVARMBJUKMvYX+8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45977101-7236-490b-3864-08dc842b857d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 00:16:03.9945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PPuDzCpdaKPNxCNv6hJzJr40VDP9rvYGE9NvwPJo7uTNzyrM4aTCF9u1+1vaBbVo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6451

The core code allows the domain to be changed on the fly without a forced
stop in BLOCKED/IDENTITY. In this flow the driver should just continually
maintain the ATS with no change while the STE is updated.

ATS relies on a linked list smmu_domain->devices to keep track of which
masters have the domain programmed, but this list is also used by
arm_smmu_share_asid(), unrelated to ats.

Create two new functions to encapsulate this combined logic:
 arm_smmu_attach_prepare()
 <caller generates and sets the STE>
 arm_smmu_attach_commit()

The two functions can sequence both enabling ATS and disabling across
the STE store. Have every update of the STE use this sequence.

Installing a S1/S2 domain always enables the ATS if the PCIe device
supports it.

The enable flow is now ordered differently to allow it to be hitless:

 1) Add the master to the new smmu_domain->devices list
 2) Program the STE
 3) Enable ATS at PCIe
 4) Remove the master from the old smmu_domain

This flow ensures that invalidations to either domain will generate an ATC
invalidation to the device while the STE is being switched. Thus we don't
need to turn off the ATS anymore for correctness.

The disable flow is the reverse:
 1) Disable ATS at PCIe
 2) Program the STE
 3) Invalidate the ATC
 4) Remove the master from the old smmu_domain

Move the nr_ats_masters adjustments to be close to the list
manipulations. It is a count of the number of ATS enabled masters
currently in the list. This is stricly before and after the STE/CD are
revised, and done under the list's spin_lock.

This is part of the bigger picture to allow changing the RID domain while
a PASID is in use. If a SVA PASID is relying on ATS to function then
changing the RID domain cannot just temporarily toggle ATS off without
also wrecking the SVA PASID. The new infrastructure here is organized so
that the PASID attach/detach flows will make use of it as well in
following patches.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |   5 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 238 +++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   6 +-
 3 files changed, 178 insertions(+), 71 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index 315e487fd990eb..a460b71f585789 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -164,7 +164,7 @@ static void arm_smmu_test_make_cdtable_ste(struct arm_smmu_ste *ste,
 		.smmu = &smmu,
 	};
 
-	arm_smmu_make_cdtable_ste(ste, &master);
+	arm_smmu_make_cdtable_ste(ste, &master, true);
 }
 
 static void arm_smmu_v3_write_ste_test_bypass_to_abort(struct kunit *test)
@@ -231,7 +231,6 @@ static void arm_smmu_test_make_s2_ste(struct arm_smmu_ste *ste,
 {
 	struct arm_smmu_master master = {
 		.smmu = &smmu,
-		.ats_enabled = ats_enabled,
 	};
 	struct io_pgtable io_pgtable = {};
 	struct arm_smmu_domain smmu_domain = {
@@ -247,7 +246,7 @@ static void arm_smmu_test_make_s2_ste(struct arm_smmu_ste *ste,
 	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.sl = 3;
 	io_pgtable.cfg.arm_lpae_s2_cfg.vtcr.tsz = 4;
 
-	arm_smmu_make_s2_domain_ste(ste, &master, &smmu_domain);
+	arm_smmu_make_s2_domain_ste(ste, &master, &smmu_domain, ats_enabled);
 }
 
 static void arm_smmu_v3_write_ste_test_s2_to_abort(struct kunit *test)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 532fe17f28bfe5..24f42ff39f77a9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1538,7 +1538,7 @@ EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_bypass_ste);
 
 VISIBLE_IF_KUNIT
 void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
-			       struct arm_smmu_master *master)
+			       struct arm_smmu_master *master, bool ats_enabled)
 {
 	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
 	struct arm_smmu_device *smmu = master->smmu;
@@ -1561,7 +1561,7 @@ void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
 			 STRTAB_STE_1_S1STALLD :
 			 0) |
 		FIELD_PREP(STRTAB_STE_1_EATS,
-			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
+			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
 	if (smmu->features & ARM_SMMU_FEAT_E2H) {
 		/*
@@ -1591,7 +1591,8 @@ EXPORT_SYMBOL_IF_KUNIT(arm_smmu_make_cdtable_ste);
 VISIBLE_IF_KUNIT
 void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				 struct arm_smmu_master *master,
-				 struct arm_smmu_domain *smmu_domain)
+				 struct arm_smmu_domain *smmu_domain,
+				 bool ats_enabled)
 {
 	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
 	const struct io_pgtable_cfg *pgtbl_cfg =
@@ -1608,7 +1609,7 @@ void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 
 	target->data[1] = cpu_to_le64(
 		FIELD_PREP(STRTAB_STE_1_EATS,
-			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
+			   ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0));
 
 	if (smmu->features & ARM_SMMU_FEAT_ATTR_TYPES_OVR)
 		target->data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
@@ -2450,22 +2451,16 @@ static bool arm_smmu_ats_supported(struct arm_smmu_master *master)
 	return dev_is_pci(dev) && pci_ats_supported(to_pci_dev(dev));
 }
 
-static void arm_smmu_enable_ats(struct arm_smmu_master *master,
-				struct arm_smmu_domain *smmu_domain)
+static void arm_smmu_enable_ats(struct arm_smmu_master *master)
 {
 	size_t stu;
 	struct pci_dev *pdev;
 	struct arm_smmu_device *smmu = master->smmu;
 
-	/* Don't enable ATS at the endpoint if it's not enabled in the STE */
-	if (!master->ats_enabled)
-		return;
-
 	/* Smallest Translation Unit: log2 of the smallest supported granule */
 	stu = __ffs(smmu->pgsize_bitmap);
 	pdev = to_pci_dev(master->dev);
 
-	atomic_inc(&smmu_domain->nr_ats_masters);
 	/*
 	 * ATC invalidation of PASID 0 causes the entire ATC to be flushed.
 	 */
@@ -2474,22 +2469,6 @@ static void arm_smmu_enable_ats(struct arm_smmu_master *master,
 		dev_err(master->dev, "Failed to enable ATS (STU %zu)\n", stu);
 }
 
-static void arm_smmu_disable_ats(struct arm_smmu_master *master,
-				 struct arm_smmu_domain *smmu_domain)
-{
-	if (!master->ats_enabled)
-		return;
-
-	pci_disable_ats(to_pci_dev(master->dev));
-	/*
-	 * Ensure ATS is disabled at the endpoint before we issue the
-	 * ATC invalidation via the SMMU.
-	 */
-	wmb();
-	arm_smmu_atc_inv_master(master);
-	atomic_dec(&smmu_domain->nr_ats_masters);
-}
-
 static int arm_smmu_enable_pasid(struct arm_smmu_master *master)
 {
 	int ret;
@@ -2553,46 +2532,182 @@ arm_smmu_find_master_domain(struct arm_smmu_domain *smmu_domain,
 	return NULL;
 }
 
-static void arm_smmu_detach_dev(struct arm_smmu_master *master)
+/*
+ * If the domain uses the smmu_domain->devices list return the arm_smmu_domain
+ * structure, otherwise NULL. These domains track attached devices so they can
+ * issue invalidations.
+ */
+static struct arm_smmu_domain *
+to_smmu_domain_devices(struct iommu_domain *domain)
 {
-	struct iommu_domain *domain = iommu_get_domain_for_dev(master->dev);
+	/* The domain can be NULL only when processing the first attach */
+	if (!domain)
+		return NULL;
+	if (domain->type & __IOMMU_DOMAIN_PAGING)
+		return to_smmu_domain(domain);
+	return NULL;
+}
+
+static void arm_smmu_remove_master_domain(struct arm_smmu_master *master,
+					  struct iommu_domain *domain)
+{
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain_devices(domain);
 	struct arm_smmu_master_domain *master_domain;
-	struct arm_smmu_domain *smmu_domain;
 	unsigned long flags;
 
-	if (!domain || !(domain->type & __IOMMU_DOMAIN_PAGING))
+	if (!smmu_domain)
 		return;
 
-	smmu_domain = to_smmu_domain(domain);
-	arm_smmu_disable_ats(master, smmu_domain);
-
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	master_domain = arm_smmu_find_master_domain(smmu_domain, master);
 	if (master_domain) {
 		list_del(&master_domain->devices_elm);
 		kfree(master_domain);
+		if (master->ats_enabled)
+			atomic_dec(&smmu_domain->nr_ats_masters);
 	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+}
 
-	master->ats_enabled = false;
+struct arm_smmu_attach_state {
+	/* Inputs */
+	struct iommu_domain *old_domain;
+	struct arm_smmu_master *master;
+	/* Resulting state */
+	bool ats_enabled;
+};
+
+/*
+ * Start the sequence to attach a domain to a master. The sequence contains three
+ * steps:
+ *  arm_smmu_attach_prepare()
+ *  arm_smmu_install_ste_for_dev()
+ *  arm_smmu_attach_commit()
+ *
+ * If prepare succeeds then the sequence must be completed. The STE installed
+ * must set the STE.EATS field according to state.ats_enabled.
+ *
+ * ATS is automatically enabled if the underlying device supports it.
+ * disable_ats can inhibit this to support STEs like bypass that don't allow
+ * ATS.
+ *
+ * The change of the EATS in the STE and the PCI ATS config space is managed by
+ * this sequence to be in the right order such that if PCI ATS is enabled then
+ * STE.ETAS is enabled.
+ *
+ * new_domain can be NULL if the domain being attached does not have a page
+ * table and does not require invalidation tracking, and does not support ATS.
+ */
+static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
+				   struct iommu_domain *new_domain)
+{
+	struct arm_smmu_master *master = state->master;
+	struct arm_smmu_master_domain *master_domain;
+	struct arm_smmu_domain *smmu_domain =
+		to_smmu_domain_devices(new_domain);
+	unsigned long flags;
+
+	/*
+	 * arm_smmu_share_asid() must not see two domains pointing to the same
+	 * arm_smmu_master_domain contents otherwise it could randomly write one
+	 * or the other to the CD.
+	 */
+	lockdep_assert_held(&arm_smmu_asid_lock);
+
+	if (smmu_domain) {
+		/*
+		 * The SMMU does not support enabling ATS with bypass/abort.
+		 * When the STE is in bypass (STE.Config[2:0] == 0b100), ATS
+		 * Translation Requests and Translated transactions are denied
+		 * as though ATS is disabled for the stream (STE.EATS == 0b00),
+		 * causing F_BAD_ATS_TREQ and F_TRANSL_FORBIDDEN events
+		 * (IHI0070Ea 5.2 Stream Table Entry). Thus ATS can only be
+		 * enabled if we have arm_smmu_domain, those always have page
+		 * tables.
+		 */
+		state->ats_enabled = arm_smmu_ats_supported(master);
+
+		master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
+		if (!master_domain)
+			return -ENOMEM;
+		master_domain->master = master;
+
+		/*
+		 * During prepare we want the current smmu_domain and new
+		 * smmu_domain to be in the devices list before we change any
+		 * HW. This ensures that both domains will send ATS
+		 * invalidations to the master until we are done.
+		 *
+		 * It is tempting to make this list only track masters that are
+		 * using ATS, but arm_smmu_share_asid() also uses this to change
+		 * the ASID of a domain, unrelated to ATS.
+		 *
+		 * Notice if we are re-attaching the same domain then the list
+		 * will have two identical entries and commit will remove only
+		 * one of them.
+		 */
+		spin_lock_irqsave(&smmu_domain->devices_lock, flags);
+		if (state->ats_enabled)
+			atomic_inc(&smmu_domain->nr_ats_masters);
+		list_add(&master_domain->devices_elm, &smmu_domain->devices);
+		spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	}
+
+	if (!state->ats_enabled && master->ats_enabled) {
+		pci_disable_ats(to_pci_dev(master->dev));
+		/*
+		 * This is probably overkill, but the config write for disabling
+		 * ATS should complete before the STE is configured to generate
+		 * UR to avoid AER noise.
+		 */
+		wmb();
+	}
+	return 0;
+}
+
+/*
+ * Commit is done after the STE/CD are configured with the EATS setting. It
+ * completes synchronizing the PCI device's ATC and finishes manipulating the
+ * smmu_domain->devices list.
+ */
+static void arm_smmu_attach_commit(struct arm_smmu_attach_state *state)
+{
+	struct arm_smmu_master *master = state->master;
+
+	lockdep_assert_held(&arm_smmu_asid_lock);
+
+	if (state->ats_enabled && !master->ats_enabled) {
+		arm_smmu_enable_ats(master);
+	} else if (master->ats_enabled) {
+		/*
+		 * The translation has changed, flush the ATC. At this point the
+		 * SMMU is translating for the new domain and both the old&new
+		 * domain will issue invalidations.
+		 */
+		arm_smmu_atc_inv_master(master);
+	}
+	master->ats_enabled = state->ats_enabled;
+
+	arm_smmu_remove_master_domain(master, state->old_domain);
 }
 
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 {
 	int ret = 0;
-	unsigned long flags;
 	struct arm_smmu_ste target;
 	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
 	struct arm_smmu_device *smmu;
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	struct arm_smmu_master_domain *master_domain;
+	struct arm_smmu_attach_state state = {
+		.old_domain = iommu_get_domain_for_dev(dev),
+	};
 	struct arm_smmu_master *master;
 	struct arm_smmu_cd *cdptr;
 
 	if (!fwspec)
 		return -ENOENT;
 
-	master = dev_iommu_priv_get(dev);
+	state.master = master = dev_iommu_priv_get(dev);
 	smmu = master->smmu;
 
 	/*
@@ -2622,11 +2737,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			return -ENOMEM;
 	}
 
-	master_domain = kzalloc(sizeof(*master_domain), GFP_KERNEL);
-	if (!master_domain)
-		return -ENOMEM;
-	master_domain->master = master;
-
 	/*
 	 * Prevent arm_smmu_share_asid() from trying to change the ASID
 	 * of either the old or new domain while we are working on it.
@@ -2635,13 +2745,11 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	 */
 	mutex_lock(&arm_smmu_asid_lock);
 
-	arm_smmu_detach_dev(master);
-
-	master->ats_enabled = arm_smmu_ats_supported(master);
-
-	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_add(&master_domain->devices_elm, &smmu_domain->devices);
-	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+	ret = arm_smmu_attach_prepare(&state, domain);
+	if (ret) {
+		mutex_unlock(&arm_smmu_asid_lock);
+		return ret;
+	}
 
 	switch (smmu_domain->stage) {
 	case ARM_SMMU_DOMAIN_S1: {
@@ -2650,18 +2758,19 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 		arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
 		arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
 					&target_cd);
-		arm_smmu_make_cdtable_ste(&target, master);
+		arm_smmu_make_cdtable_ste(&target, master, state.ats_enabled);
 		arm_smmu_install_ste_for_dev(master, &target);
 		break;
 	}
 	case ARM_SMMU_DOMAIN_S2:
-		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain);
+		arm_smmu_make_s2_domain_ste(&target, master, smmu_domain,
+					    state.ats_enabled);
 		arm_smmu_install_ste_for_dev(master, &target);
 		arm_smmu_clear_cd(master, IOMMU_NO_PASID);
 		break;
 	}
 
-	arm_smmu_enable_ats(master, smmu_domain);
+	arm_smmu_attach_commit(&state);
 	mutex_unlock(&arm_smmu_asid_lock);
 	return 0;
 }
@@ -2690,10 +2799,14 @@ void arm_smmu_remove_pasid(struct arm_smmu_master *master,
 	arm_smmu_clear_cd(master, pasid);
 }
 
-static int arm_smmu_attach_dev_ste(struct device *dev,
-				   struct arm_smmu_ste *ste)
+static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
+				   struct device *dev, struct arm_smmu_ste *ste)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_attach_state state = {
+		.master = master,
+		.old_domain = iommu_get_domain_for_dev(dev),
+	};
 
 	if (arm_smmu_master_sva_enabled(master))
 		return -EBUSY;
@@ -2704,16 +2817,9 @@ static int arm_smmu_attach_dev_ste(struct device *dev,
 	 */
 	mutex_lock(&arm_smmu_asid_lock);
 
-	/*
-	 * The SMMU does not support enabling ATS with bypass/abort. When the
-	 * STE is in bypass (STE.Config[2:0] == 0b100), ATS Translation Requests
-	 * and Translated transactions are denied as though ATS is disabled for
-	 * the stream (STE.EATS == 0b00), causing F_BAD_ATS_TREQ and
-	 * F_TRANSL_FORBIDDEN events (IHI0070Ea 5.2 Stream Table Entry).
-	 */
-	arm_smmu_detach_dev(master);
-
+	arm_smmu_attach_prepare(&state, domain);
 	arm_smmu_install_ste_for_dev(master, ste);
+	arm_smmu_attach_commit(&state);
 	mutex_unlock(&arm_smmu_asid_lock);
 
 	/*
@@ -2732,7 +2838,7 @@ static int arm_smmu_attach_dev_identity(struct iommu_domain *domain,
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 
 	arm_smmu_make_bypass_ste(master->smmu, &ste);
-	return arm_smmu_attach_dev_ste(dev, &ste);
+	return arm_smmu_attach_dev_ste(domain, dev, &ste);
 }
 
 static const struct iommu_domain_ops arm_smmu_identity_ops = {
@@ -2750,7 +2856,7 @@ static int arm_smmu_attach_dev_blocked(struct iommu_domain *domain,
 	struct arm_smmu_ste ste;
 
 	arm_smmu_make_abort_ste(&ste);
-	return arm_smmu_attach_dev_ste(dev, &ste);
+	return arm_smmu_attach_dev_ste(domain, dev, &ste);
 }
 
 static const struct iommu_domain_ops arm_smmu_blocked_ops = {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 01769b5286a83a..f9b4bfb2e6b723 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -758,10 +758,12 @@ void arm_smmu_make_abort_ste(struct arm_smmu_ste *target);
 void arm_smmu_make_bypass_ste(struct arm_smmu_device *smmu,
 			      struct arm_smmu_ste *target);
 void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
-			       struct arm_smmu_master *master);
+			       struct arm_smmu_master *master,
+			       bool ats_enabled);
 void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
 				 struct arm_smmu_master *master,
-				 struct arm_smmu_domain *smmu_domain);
+				 struct arm_smmu_domain *smmu_domain,
+				 bool ats_enabled);
 void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
 			  struct arm_smmu_master *master, struct mm_struct *mm,
 			  u16 asid);
-- 
2.45.2


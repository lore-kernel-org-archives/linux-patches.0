Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2050.outbound.protection.outlook.com [40.107.102.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D474A15667D;
	Tue, 25 Jun 2024 12:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719319085; cv=fail; b=ugeRB9tjOXM8IOTS4XnC50fitiR9k++oK+AVe7MOGjT9GC2A3iNdWBB3moF4CFwRPaR+lRd+TMlbx11SWjlGgG218+ooDxmuEtVcj8ZPjBNwZ0ZkPx8Cjg8oVhz2eVImba5zlCL+WgD4yzWG2Nami/va4wyl0DfeeSybMTexYYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719319085; c=relaxed/simple;
	bh=kda27o2PKoOa7oa3xik2+YgFNF9TkfD40z6R5OKJ1js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K/DDG4JWmpTqpzpYz5URSPQ6xhGvA+V/PZwtY7GGSc3/q6rl1MmIzr7pAyZ+/DAMTEbONCWIutLp1vy8zcKc0M+BJVVu/eaIHCjlRmCXqs3Owuq1PZT/u3KkDYgo9CmnV6U6ZdQixv2oxWvO2JTxSJWuP6oSO2KMCOUw54N+xgY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VBlbUXFg; arc=fail smtp.client-ip=40.107.102.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VBlbUXFg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bp+GlQ3TIBWqNzAbbvY7R/BmAwgCkKIggNR/dYU534RC7IbDUNMUYoJ6HbsfdsdsCz/OKxqGlGEYJ4F8B8VLaLcgo1BwrTz7rPGZLrGyGBsL1HX8zvE8ZURkrWQaa4/gUCwiGOWF8XdOmMze1UHG1pfRVDM5yILdPGMexQqAZoGbZSVbEP9UgLO2Hmzzrnpur2YUdUfcXBs0bFpnMHfawNrfU6ndl2xk3XNthke25L1mDglYhagT8W2/4lmJuwreW3m/uYpdZ1iHtDOnHUP1UjHCyBTO4eeI7mEKS6P5Vx21quNOd3p1F/R/8wbql9jCusBqacyVbJF+aqjQyph6sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EcCtlXWAnCRAQD3/Wh7aQFY6FWzz0V0ZSpeFpxu8ghg=;
 b=LNd0i83EYcvk2Aas8V7cjxjbkKeTGDcMitoP48QitOpbNaKkQ6lHocO320DfhsMB7nbnX/XKa16bMgY1L9KsA1O/ylwrBmJdhuL28dGoRCFhfIyyEbu7acauUCA8HQb3hY67jPbYNI6lMdmiVtR5zm85VXhLMnJ+0jWiDDOHFhKezEvGI0Cbn3Anf3OvIc+RlazQGVU2x56AS5cvXvZj7DvvlFisOONWIU4oNGidFKptBBEkCc/RXiCQ6KpMFRxiF9Zn7icWejg88qsmARRfnhZ/+SDp/qI5E5qADj9S+vB2GigayWd33JrbLEj2CUKqaVqDW5fIszSkE/4GeAqurQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EcCtlXWAnCRAQD3/Wh7aQFY6FWzz0V0ZSpeFpxu8ghg=;
 b=VBlbUXFgSpM618r6zDLpQFiftX1EjDAcIbOKDAD0IHaz/+ucqxasIz5VMStOpoUcGestz28Rb7ejlChz4UiyI5Ys7KcBrCVI5GgCuTo8oY7OTYDqDSD06rSiZM4IGYAyGgyY4UiylUtx0czaQ4wPkw9Kzf646sw5WTQqkRdvysyEauuuPFLEG29LqssI2w3Oi1JacQaae0sU4b+3HXTIGAbHoYLgawrLvUsTb7m1U/ojmQlMOfzsVKiLfD25mcl5BUEgzE5NgbWDZskuoV1OJwTQGxbKWm8nvaHeoX0CSl+SlazGyMhnT89OD3HfrYVi+jeLIXaPhMA705XJFJZZtg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB8946.namprd12.prod.outlook.com (2603:10b6:806:375::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Tue, 25 Jun
 2024 12:37:50 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 12:37:50 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v9 12/14] iommu/arm-smmu-v3: Test the STE S1DSS functionality
Date: Tue, 25 Jun 2024 09:37:43 -0300
Message-ID: <12-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:208:335::6) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB8946:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ceba571-560a-477c-3cfe-08dc95139ec8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|366013|1800799021|376011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z0ZPZd2272igaLpSpHIrhTaY4mViGJ2x6YcTAI72GroS+A//zO2x9eWU4nxt?=
 =?us-ascii?Q?2rsFfxbSGPPeZLTFNonMD/AyRfbs4+GSY3E84916SP6c5V4k/CnvxCwd17Ty?=
 =?us-ascii?Q?WMwyD0eBcXhaNeFSL1vS3sTJJZ1BeETLYwPcQlPHwmYcdmuhjch47NiR7mh5?=
 =?us-ascii?Q?8Fiu0aiofgZ8rnpaJag1BruryXDm/gXWaysBNQAmR1xLmPwgNH8xwkOFD0sX?=
 =?us-ascii?Q?CYKjjNhhgmIxlNYRnecfPyYvQK0qydQG0X8C7G6ymu8RiCzGjjMk/t4RHJlX?=
 =?us-ascii?Q?lyxWvHze59kmw3GGwMVBrkcDHUG13wYxyucJIivUEgccRJYN7CTo8Lk75RYj?=
 =?us-ascii?Q?oIUrwHc77iIyAqs/u779sH7PkY7vigXLhVARxSv/D0ogbaQrjgl2SJiytpFv?=
 =?us-ascii?Q?YmnEpgJ2/d3w3gugZ1Uvt8OhUpUNgog9E7YNl2+fYSLpaiXFmg6AXLldJExY?=
 =?us-ascii?Q?yUbihKRfPripJDnI1EgMg1/8TaUEAqymqVyq4z9t/fTsBGU6n5I3KHK1rskC?=
 =?us-ascii?Q?+EDBBfZH7HV7OWIdNE9CwDn7GeliiU2VGFqsRwBMVOOahfabmyHDejyKPzzJ?=
 =?us-ascii?Q?SsVMcWGheLlDqrKZRsqAlpfEsQ6Ogod/ClxD+PO/e++PL23SHkHqV2L/ZEyA?=
 =?us-ascii?Q?w0DIj4df9uQlvI8atl4QMgiz4rWmz+mu7WPT2nGL2fH3Y1oxhKQ6e1ZmWPqG?=
 =?us-ascii?Q?S9hYupKn+vSzHBy6RU0mjOElZQHROTwUt8bIwdF7mQ/LFqbA6z66Y5DPdFEK?=
 =?us-ascii?Q?0A3aSTy/I5yDL2/vJWzBl6mkjSdwpD8+pCcMyLvt1ZOYixpihhMAWqu1Cc4J?=
 =?us-ascii?Q?qiupfQi8qYKJ39FOJc2xbY8qiLgphBsInHffUKbHqvn/yUmWtifuLErlKaws?=
 =?us-ascii?Q?Ho7FrVGFpbcE2rw/aYY1+WsL0xqKUo21B3Jhe5NWyqe0QCuBuY5njUlyJcSf?=
 =?us-ascii?Q?hdSe20g/QavPeQzPe8P3MaKZfGnzr2uj/KndCEAKArVTu11/eJ+t6NYT/B9b?=
 =?us-ascii?Q?6J/RUPzs7mfKcOZK5EX87TK1Pjal0hh7tW8d4Zo161tOH2E9QeYTYahF7/B9?=
 =?us-ascii?Q?/yfgUCautBIty1AlPyIgiq1eSLyLEUBWD8NWdaeWEkBJCr6JsBWHJCAWktK7?=
 =?us-ascii?Q?jt9zBgWU+wsTUpD01s+6xofHGr8g4OS2QUGMN7EJmHaDQs6PW4JPD6rNBUFO?=
 =?us-ascii?Q?xEFlnCSfQBBJ8R0icKpB+rgzSZE8/DAsDjhQvxYHah46mMall8FzZJJkFYbV?=
 =?us-ascii?Q?ov9WNC4tDdCDgB3t7H+BNqC8dR6meQ7E5AuOlli8k3Ss8k2uv03A141pNh1q?=
 =?us-ascii?Q?DLq1qbaMTm/+7Blidim49OqN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(366013)(1800799021)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c/56HjAErjId7AkkYrUCstC3dXR33MbN0+KobrXFL7MUDb21rny6I2Plfcgg?=
 =?us-ascii?Q?5lopsGl39c3E182LTU78wU0wl1cIEXXOuGzM+BwKv+vdbeny5itChYjWfofO?=
 =?us-ascii?Q?G2Jy6WXBuFVg1rs+L+FYn00ig7dFFdtcRuJqAbmfR1hKtST1yPtjUmn6Hc6J?=
 =?us-ascii?Q?TgrOfRg4RJbnetEmiXkoz6HjRyi/CHCrOAMhDSaf40L5sxCzIjsAeINidFUu?=
 =?us-ascii?Q?oN9TtnmVWLogPeeSjIkyeACKehIW9fylR8Hq616psOTEWQvljfScswIO2gM0?=
 =?us-ascii?Q?SJJuX6jU4QnKUxQK/UQPMFFl59CBmKV6YXwBHq7kKCIIdfggpBcRDL3aLhLF?=
 =?us-ascii?Q?/ruxXTi300j0j82FPRF/iwDJ/zygpbaC3i/oMEuBmQk2k8xPgH2AVvTXoLZY?=
 =?us-ascii?Q?knSh8pm6gXrY/0XTT+r3d6fxc6HU3gZWeCrTdc51oI0zlRjIGVP9b2p6P64P?=
 =?us-ascii?Q?ksbb+ac5Hcke3IjsGs28WjgK73QRn1tc16r2X/k7FMBJGH5sa9yjKT4LCA6g?=
 =?us-ascii?Q?Y9IUizWoeCx0NoksWWrju5PmyqhJO9T4WikStw5ZjGQW85foDf/1QoT0vq/H?=
 =?us-ascii?Q?dsk/jMEgnEP+uJpm9Ft5Pb9CUzTEFZ1FwFUhRcdnYDSyroQqPoebhPyccu3Z?=
 =?us-ascii?Q?jUlTxfpb9JyIQv4rw5v+RpZff1ew5A9uQbJdju0C/M7wvjI1FPyHcgyFZVMd?=
 =?us-ascii?Q?CkAH2LRBv5HEWUJuFv0D4VNl3hvfjaOzqxzr71eACSPC/YNS06pamwvefAum?=
 =?us-ascii?Q?DWHENSwBEtplwNfMQN5BDC9b/+koACby6gyIdoESjJdOee5SF5ACUFsfvGAJ?=
 =?us-ascii?Q?n19r1xL6BzoUxWdZJMI4ei3lUa+883JDijKz42PO+rOd2Q3xamjfKyG3DgPC?=
 =?us-ascii?Q?Vd79H0GthgVZxthX52Co57ohVaNeJlv0fPOMMCLW/QmAnChQ4mTd7ipWBHA8?=
 =?us-ascii?Q?M1VD4cw52ETNvfemy7hJZHP9EwLmdRJ3hgjcGToBD9J37HHU4BlGrNY09oYe?=
 =?us-ascii?Q?NiciD8O83XN/TfRRGTb5OAqfFUpVhWt0R4tlcz5jfBfoMbWR/YedlVDE/NIm?=
 =?us-ascii?Q?NZxPenGIHGClJ8NRDKa1hL9E/8+Xd7KAHitVNJ8mfM0r2H+dq+7KYjrCPcvs?=
 =?us-ascii?Q?ZMKfiANDSDzpVmswjQBQIryiYZXT/fEXA0/rMz4T8Mj2Js6J3BEIiqswGYbA?=
 =?us-ascii?Q?93P9aHHd8PLGlAf1xvqv4guwptSPygOkrvzL3R17OT9G1QxYiImHcUg3hLl6?=
 =?us-ascii?Q?oafzDl52Cisut94HwtVKX5/e/1cz5qdPlRyEjgijDKzdhkGbr2bdHcnCcaoR?=
 =?us-ascii?Q?abEXHYrFTel9WLeEArQQaAG9DTxVKxQOjxaimMvpugOCK0501pjdQa858BAC?=
 =?us-ascii?Q?jvn5MWnLKNL1DKQGzUR99wcW0kJp8sUHXW8sDx8EJEoKXTRznRuf4R1mb4U0?=
 =?us-ascii?Q?ZatVp+3H7OsFMC1Z1d1INWrpsRDjQwdbH/sGW+kbbLpd/Olw3nWfaEo/8v3d?=
 =?us-ascii?Q?zTrPO1/Khu1Zzy+6zN962LSyvPImceLezrRZRx/mFzoEF0y7BOV6MVc5jKMr?=
 =?us-ascii?Q?u7ldaIvANrtSgsa4pbFvMbmKd+3zQ69NNm4pTg7t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ceba571-560a-477c-3cfe-08dc95139ec8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 12:37:48.1976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FoEz8rCf/AGS/vCNtfH4qstpYiN1GHOH02adH7tFZLbiraSaW7rtcqpnHdtrf7XL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8946

S1DSS brings in quite a few new transition pairs that are
interesting. Test to/from S1DSS_BYPASS <-> S1DSS_SSID0, and
BYPASS <-> S1DSS_SSID0.

Test a contrived non-hitless flow to make sure that the logic works.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
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
2.45.2


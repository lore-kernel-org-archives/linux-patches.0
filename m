Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011046.outbound.protection.outlook.com [40.93.194.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6983264D8;
	Thu, 17 Sep 2026 00:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789604888; cv=fail; b=qik2CHO41E2miQISl5qy2ClF1H1W9Bx0ra+xMOhjyueVuVnj8wP/kftOH8xL///5vtT90UNdRBYJuDFX6edA7jI0bcZG2fY2DYMcSIEHtEEWTnriPPfOnsouZ3Y5lFQM/DBjgx3klAuVV80V1bnCQpWkAYABwh7IZtdbpkIn64A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789604888; c=relaxed/simple;
	bh=kSAy9jkcrxA20Ck0im+8ECQuDNf5wtI87ow6ie+byVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EHtuOHZQXQHpVnW8RmUaAGURC8110HSeoXmt/f2DBptntR4JTs3ywaUWAhKhsCvUab76HsG2PmuuxJAkn2usHoZkCZ9YyUrw4fJQZEMn7AsJ/sZ+bjGEb/QObNpqKwOyu1wg1yy1gCraU+UaepF9dkPqpu9PULGXS2UVDBntoI0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NDvVycGE; arc=fail smtp.client-ip=40.93.194.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NDvVycGE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iEPbKDSJva3zb0a3wKsgAiE6l5I6mkBDegtBEczr5T1SjPOZmu4o1Tm1acSfWbfyZ4EgC7A27Gd6E/9wwGF3uw55xWFnC7kvpVQjvV903r0WyBYyD9bKTQzqYjGliF7PoLYqXeebYgceJ59yfHpHal6p1gycescR1HYfbHgKUJ2BByEZSlXLdt2nTrCXVra9zyz/AcVIDNLTyjkYKn6c2SMVS3u/VVuNQHp8zEDSXGTOVnucaK36QwdIxVNT6wy1x1qaSVCRYjdAJYtNIAx1K/0BS8fr6S0nDjhus/9Qo2b4rmpI+r8bYM6TXpP5KECd54HHKU5BBLZYu4ZRO48GFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2n6tpcpC6IC0ZuXWjaqJ+9sU6Kx/DG7x6OHehUdndUk=;
 b=MkkNtwJFqXHWvH28KrQwkgA6rxtZDmuB9EHI2/k4ZeI1xBuM5cLPrZV8ajgjgYxZ8VkGmCMzF5iaZJTP1rqz3t06yZSQ+oFjLcDDFjwapfDQeiF8u5dIVoobMm/wJgUhfXYWAIFgQiZOmvZ2O/yBwH6xL7YGfsq6MEvx18qlUFhUodbgJ9KBk4Y9Lkot0dfAl1QFnfdrU+KzxqbqhxXglHWsveP25bVigqpWAe0ILc3zoTNztUUP7cnGC3XqUhokQlircicReT4Z6zWgHrE1jRmrKJca8cvdkOXxid5o74SVGwH9I0z5WirtgGSfoC1Kpgki763ERL8yxnS7eCZ/Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2n6tpcpC6IC0ZuXWjaqJ+9sU6Kx/DG7x6OHehUdndUk=;
 b=NDvVycGEnkPIsaHNDfH5F+4OJAfEt4KcFNOsQ43vtD9csDW9OiSio4CH3atVZjxF0BNtx6rznhtFkOhVtTXqSM+pQvcwuqJvIPTxKZ8dWfe2UOkXhGcGLKyMWV0qDUy025hZGf/bJdkM5Fqk7tWe45+vWdLj3uuv85FOwnieS9h/p2fWvSoioeTOc7Dw2QVnQgSfR7GSxLHDTiI3HsmEpnZeVP2XqSmoK8rNdWynDwobghr96zsIpn2o2ptuMEoqMCiUFsS2AIhy6SQyzHKBMYS8uy11AeJpXIXWifqvPsY7f7Q7lM8m+wQBBv4V2/CZrgxskTgWK4Yrckn58CuU/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by LV3PR12MB9188.namprd12.prod.outlook.com
 (2603:10b6:408:19b::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 00:27:57 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 00:27:57 +0000
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
Subject: [PATCH v6 4/9] iommu/arm-smmu-v3: Optimize range invalidation for latency
Date: Wed, 16 Sep 2026 21:27:45 -0300
Message-ID: <4-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0005.namprd14.prod.outlook.com
 (2603:10b6:208:23e::10) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|LV3PR12MB9188:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b6d07b8-b511-469d-9939-08df14528333
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|11063799006|3023799007|56012099006|6133799003|22082099003|18002099003|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	T8TTWVcuhMW3CkIlPAc+Mw8VL3wf8J6FutjpfU1FaXjn2XjlNgK+yu8+BUV5w4Cd5aU94qGME6bRO5jawyUKTsEoQn35Na8mBSNHNuSmq3IoH2uQJ5gkqxpbTyDhyhHyXy2u0S/PsD+/8NpzOsldXxZYxM7YckitXT3JLr/T0xlWfF1BT7tNDWY8wFidjAf45woOf5gt55oMKieMks32Pdzo+RE8IRqM3J9BD0z0MixRlWz+h5r6nhy/x9pJDcnpbnQ0BvydnO7DlTir/xCuPNu0UrdLQbn2qNTY9/NzMv2JJv9agZP0GAjlCNqW8vWWrTyN1GL0DSdb10SE9HJORYlN1VL8ijIhkytIsU059qq7pwwAIPugYYlI85KasKNXro9t0gpXi5ocE4bqT4vr5CNAmmW1lCzN30IM848c+yDfhmjgXVUFIX/EwCmRuwGsdZG/w4y7i5WMtTi6F/bNoDYiLa+PGAgAey/ItWMGdsQhAT/OOunq5bIFYCQkhuTTzCjehpE4XUKuGlnGmMICxCTqFbD4j09YAF5Op9ngWyGeWq6Hi6m90L7Q4I4N3nEUT0g1MZgmaiIJRbp59xEI3QGY5ISY7RzAp9pGjWs8PjhyNlGkfVJPcpKj2x5KUcTOHbk7l/MSLZeAU02/4x4CZQHwtIUtRJciXM9IGQmeq1ZIiVGNPrcBLyRQhXtlD8azKzwhlCkir3v1+wpsI5Ew+Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(11063799006)(3023799007)(56012099006)(6133799003)(22082099003)(18002099003)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4G8v8lxgrNSEXXHNSMHZsVrGqAhtNyKZWXkB7lG0jdptf5ELJUhbd1B8X0kK?=
 =?us-ascii?Q?wO/Oi7PygJqYOKSprTHRtkpovYyvBTfptlS6WMccajaaU+2W8CFQ/CXzuPT9?=
 =?us-ascii?Q?phZr62RNzz26UALhViKY3trRTGC2LCKWFEXuvX88oOg/c2DCMGgx3D+udCBb?=
 =?us-ascii?Q?9LQrxMzw5HsJCcdWXiV8Rk84ZNN7RUtbiLKUuxJyqweQXvRSKVXLuOsblS3q?=
 =?us-ascii?Q?NoN0X3dPZ4/kiTrYJhnhX3IJsTL1Og3AwnjgCPVMIaxW9kPyUvW9ryIrYLnu?=
 =?us-ascii?Q?ZjeSo4Rd0HdYA5R8atHycEqgHf7Nae6RTPbiqCK14X8xbBpThpuaJNERT9gZ?=
 =?us-ascii?Q?N7V3R08aviB81NBfDw02EYVH8wIW7nEXni4ywnCdlwRkO+d7D8fmecvbIh7F?=
 =?us-ascii?Q?HICDOAQamyUoqvvPQpBJIPUsVllkoOAjppSb/J1cDj+k3wvVRMzOpTnBUkmp?=
 =?us-ascii?Q?inMO11ctLjGt6yW4zPi1jb/+W7M6etfq2Jp1G27KryN3ZVidhnOdN6InTSml?=
 =?us-ascii?Q?ZPn2wsa3dubBjdJgiDgW894zhhTHZDtVjVSzQIwc3z6Q4fBJck4+eBbwOZge?=
 =?us-ascii?Q?mFMiM2SeeM7me1ItV0XBNJC+SiCWzIXp2re9qtvsVn/qGlV6uSxQ5p8/hcHI?=
 =?us-ascii?Q?G4Hj/bNgJfEhchH9K1Wjc6hFKAvjGGmbs8cpOSmJpEVCWy/S7pz1hhNeI/4S?=
 =?us-ascii?Q?OzIuNTSy9bzamQHFXuJxAc6z5h894F2Zpz8fdy9CuzlDFh6GsrE6eDR3WuG1?=
 =?us-ascii?Q?FymGHkUZPN5D+jLDOXj0zd3/KQ0psEFo9/8O3SpKUBz5q5tzRic42QquFn8C?=
 =?us-ascii?Q?qFP2JhfzYUlFAm3guzAvAs+nofxaCXNJ9RsXCoAk+Sa4LbGS6znAHIeNAhZw?=
 =?us-ascii?Q?6YGQrZ5J6f1OYwzZFFjMC0ipKJOMEeeHXfjYaXAUzvb/8jitKvF6LNiGIGzC?=
 =?us-ascii?Q?e7VXFzGOZwo7H9swhwNoNy2ULAIUolt6cwFCN8sYK5HWv2+SqEmD8lBsSMZC?=
 =?us-ascii?Q?5Xk7ht1u5wyTpPVk9ouzGgC+FzSHE4TuRgEX8WfgXmTPgBHOgt4W1CnfOeJB?=
 =?us-ascii?Q?Rf43broIKF2gPp83o18EF+bIgFf321DZ9xoowa5izsYkwnzf6G2mtQo0lJeF?=
 =?us-ascii?Q?pmRMAXxsNQrzL5h1DtXQDeEpOUiGbxfaLHufcLdkYwHWfyLvGK5vZhbu8imH?=
 =?us-ascii?Q?rHJRVkwtsmBaLa2dnMjm0ywSqRYIVVbTVjJ09ISyzshCxM8mxak3xIxDCf/u?=
 =?us-ascii?Q?Xzl0vEzlvQlhVk2wRyYbdrRknE2XTr5vxvYZ3ojduNuSZFr/VAZt5wLodmx/?=
 =?us-ascii?Q?i6Ac1EvbdxiV8KVhmO2Rj/6t7qB984Gt5Xp1NJN4ImHsrFPcq/iJsBqTGf1i?=
 =?us-ascii?Q?4dyyELmUou1jgp80s/+co+IZUC+V3HAEs0Lsne2yraKFRa03OQAknV1NFlEx?=
 =?us-ascii?Q?9Db9NOzNEyRxRLarBizj5U+AziJPXNHRtNi77Ow+ilRXJ/+cnSE6v6586frk?=
 =?us-ascii?Q?EH02Jxtbd3eaGJewl7mqHBQrzBgBknDMUcaZdycVXJvQRyuX+KpAFtOL6ZBg?=
 =?us-ascii?Q?/JVBmPWlA41NdjOSiPEBVA4SewZ8VE8sXm8BTdrYY8r3eGfe9wgAED01K/wQ?=
 =?us-ascii?Q?XCsvui1C7C+u70Ss5Qy4CpezZkatH4peVFlX5kZiBOb6qrQwSZqxMv6P/L2p?=
 =?us-ascii?Q?0XAhh/qVKr4qPP8IqNvnDs9nBzQYyRM1VxrZ59dLZhEZrhQ6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b6d07b8-b511-469d-9939-08df14528333
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 00:27:53.2655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nkq9yX0jSGjPrj3whh9UxUsBsuailDjpezF/PVs3acI1N0qOW/Uk6QTploa3kPiJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9188

The server IOMMU drivers focus on invalidation latency by default,
over-invalidating if necessary, to round the invalidation range up to a
single command. I think this represents a trade off for DMA non-FQ and SVA
where stalling the operation is overall worse than re-loading the IOTLB.

For instance AMD and VT-d both round the range up to the largest aligned
power of two and invalidate that. This causes over-invalidation but that
is preferred on real HW over trying to issue a number of smaller
range invalidations.

SMMUv3 on the other hand will try to do up to 512 single invalidations,
otherwise falls back to full invalidation, or it will try to issue an
string of RIL invalidations for every 5 bits of IOVA range to perfectly
cover it.

While the RIL optimization is pretty good we can still do better and
reduce it to only 2 invalidations at maximum using the idea Robin came up
with to overlap two RILs in the middle. This preserves the exact coverage
of the current RIL and still caps the number of RILs at 2.

This works because the RIL can start at any IOVA, so we can place a RIL
forwards from the start and backwards from the end, overlapping in the
middle if the scale isn't precise enough.

In the cases where this produces 2 RILS it continues to produce RILs that
don't overlap, but the exact split point is different than the original
algorithm due to the new calculation method. In cases where the original
algorithm would produce 3 or more RILs this will produce 2 RILS with an
overlap.

The SVA under invalidation errata work around is maintained by "rounding up" to
generate a single RIL that over-covers the entire range.

Since the normal path is now the only one with a loop, split them into two
functions and fold a simplified version of arm_smmu_inv_size_too_big()
directly into the normal flow in a way that directly limits the number of
single invalidation commands generated, again focusing on controlling
latency.

The end result is any gather is converted into either:
 - One invalidate all
 - One or two range invalidate ops
 - At most 512 single invalidation ops

arm_smmu_domain_inv() is modified to always pass in the tgsz because the
new logic relies on it being valid.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 364 ++++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  16 +-
 2 files changed, 233 insertions(+), 147 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 6413eb4021ce22..4db8ad6f775a55 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2460,166 +2460,229 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 	arm_smmu_domain_inv(smmu_domain);
 }
 
-static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
+/*
+ * Check address alignment for TTL hint per SMMUv3 H.a Section 4.4.1.
+ * Address bits below the alignment must be zero, otherwise UNPREDICTABLE.
+ */
+static bool arm_smmu_ttl_addr_aligned(u64 address, unsigned int tg,
+				      unsigned int ttl)
+{
+	unsigned int pgsz_lg2 = arm_smmu_pt_level_to_lg2sz(tg, 3 - ttl);
+
+	return !(address & GENMASK_U64(pgsz_lg2 - 1, 0));
+}
+
+struct arm_smmu_ril_range {
+	u64 start_tg;
+	/* Normal integer, not encoded. 0 means 0.*/
+	u64 num;
+	unsigned int scale;
+};
+
+static unsigned int arm_smmu_ril_calc_scale(u64 num_tg)
+{
+	return fls64((num_tg - 1) / (CMDQ_TLBI_RANGE_NUM_MAX + 1));
+}
+
+static u64 arm_smmu_ril_calc_num(u64 num_tg, unsigned int scale)
+{
+	return DIV_ROUND_UP_ULL(num_tg, 1ULL << scale);
+}
+
+/*
+ * Initialize the smallest RIL covering num_tg and ending at last_tg.
+ */
+static struct arm_smmu_ril_range arm_smmu_ril_init_end(u64 last_tg, u64 num_tg)
+{
+	struct arm_smmu_ril_range ril = {};
+
+	if (!num_tg)
+		return ril;
+
+	ril.scale = arm_smmu_ril_calc_scale(num_tg);
+	ril.num = arm_smmu_ril_calc_num(num_tg, ril.scale);
+	ril.start_tg = last_tg - ((ril.num << ril.scale) - 1);
+	return ril;
+}
+
+static void arm_smmu_cmdq_batch_add_ril(struct arm_smmu_device *smmu,
+					struct arm_smmu_cmdq_batch *cmds,
+					struct arm_smmu_cmd *ref_cmd,
+					bool leaf_only,
+					const struct arm_smmu_ril_range *ril,
+					u8 ttl, u8 tg_enc)
+{
+	struct arm_smmu_cmd cmd;
+	unsigned int tgsz_lg2 = tg_enc * 2 + 10;
+	u64 iova = ril->start_tg << tgsz_lg2;
+	unsigned int num = ril->num - 1;
+
+	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
+	if (WARN_ON(tgsz_lg2 == 14 && ttl == 1))
+		ttl = 0;
+
+	/* Verify address alignment for the TTL hint */
+	if (ttl && !arm_smmu_ttl_addr_aligned(iova, tgsz_lg2, ttl))
+		ttl = 0;
+
+	/*
+	 * SMMUv3 H.a Section 4.4.1: TG!=0, NUM==0, SCALE==0, TTL==0 is Reserved
+	 * and causes CERROR_ILL. Single tg uses NUM=0, SCALE=0 with a TTL hint
+	 * to target only the exact leaf entry.
+	 *
+	 * For a single tg invalidation a 0 TTL can come from places like the
+	 * SVA path that don't have enough information to get a TTL, or as a
+	 * side of effect of the splitting.
+	 *
+	 * A single-TG invalidation cannot reach this point if it is part of a
+	 * CONT group, so it is safe to transform it into a single invalidation.
+	 * The ARM_SMMU_OPT_FULL_CONT_RIL errata does not apply.
+	 */
+	if (!num && !ril->scale && !ttl)
+		tg_enc = 0;
+
+	cmd.data[0] = ref_cmd->data[0] | FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
+		      FIELD_PREP(CMDQ_TLBI_0_SCALE, ril->scale);
+	cmd.data[1] = ref_cmd->data[1] |
+		      FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf_only) |
+		      FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
+		      FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | iova;
+	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, &cmd);
+}
+
+/*
+ * Issue up to two range TLBI commands covering [iova, iova+size). Returns true
+ * if successful, false if the range is too large to fit into RIL commands.
+ *
+ * Normally the first RIL is the largest representable span which does not
+ * exceed the requested range. If necessary, the second RIL is the smallest
+ * representable range covering the remainder and is anchored at the end. Any
+ * excess coverage from the second RIL overlaps the first instead of exceeding
+ * the requested range.
+ *
+ * If a SVA is being invalidated and the SMMU has the ARM_SMMU_OPT_FULL_CONT_RIL
+ * errata this produces only a single RIL and overinvalidates to ensure any
+ * potential CONT is covered with a single RIL.
+ */
+static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
 					  struct arm_smmu_cmd *cmd,
 					  struct arm_smmu_tlbi *tlbi)
 {
-	size_t inv_range = tlbi->iopte_size;
-	unsigned long iova = tlbi->iova;
-	unsigned long end = iova + tlbi->size;
-	unsigned long num_pages = 0;
-	u8 tg = tlbi->tgsz_lg2;
-	u64 orig_data0 = cmd->data[0];
-	u8 ttl = 0, tg_enc = 0;
+	u8 tgsz_lg2 = tlbi->tgsz_lg2;
+	struct arm_smmu_ril_range first = { .start_tg = tlbi->iova >>
+							tgsz_lg2 };
+	u64 last_tg = (tlbi->iova + tlbi->size - 1) >> tgsz_lg2;
+	u64 num_tg = last_tg - first.start_tg + 1;
+	u8 tg_enc = (tgsz_lg2 - 10) / 2;
+	struct arm_smmu_ril_range trail;
+	u8 ttl = 0;
 
-	if (WARN_ON_ONCE(!tlbi->size))
-		return;
-
-	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-		num_pages = tlbi->size >> tg;
-
-		/* Convert page size of 12,14,16 (log2) to 1,2,3 */
-		tg_enc = (tg - 10) / 2;
-
-		/*
-		 * Determine what level the granule is at. For non-leaf, both
-		 * io-pgtable and SVA pass a nominal last-level granule because
-		 * they don't know what level(s) actually apply, so ignore that
-		 * and leave TTL=0. However for various errata reasons we still
-		 * want to use a range command, so avoid the SVA corner case
-		 * where both scale and num could be 0 as well.
-		 */
-		if (tlbi->leaf_only)
-			ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tg - 3));
-		else if ((num_pages & CMDQ_TLBI_RANGE_NUM_MAX) == 1)
-			num_pages++;
-	}
-
-	while (iova < end) {
-		if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-			/*
-			 * On each iteration of the loop, the range is 5 bits
-			 * worth of the aligned size remaining.
-			 * The range in pages is:
-			 *
-			 * range = (num_pages & (0x1f << __ffs(num_pages)))
-			 */
-			unsigned long scale, num;
-
-			/* Determine the power of 2 multiple number of pages */
-			scale = __ffs(num_pages);
-
-			/* Determine how many chunks of 2^scale size we have */
-			num = (num_pages >> scale) & CMDQ_TLBI_RANGE_NUM_MAX;
-
-			/* Keep the pre-DS 5-bit truncation when scale > 31 */
-			cmd->data[0] = orig_data0 |
-				FIELD_PREP(CMDQ_TLBI_0_NUM, num - 1) |
-				FIELD_PREP(CMDQ_TLBI_0_SCALE, scale & 0x1f);
-
-			/* range is num * 2^scale * pgsize */
-			inv_range = num << (scale + tg);
-
-			/* Clear out the lower order bits for the next iteration */
-			num_pages -= num << scale;
-		}
-
-		/*
-		 * IPA has fewer bits than VA, but they are reserved in the
-		 * command and something would be very broken if iova had them
-		 * set.
-		 */
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
-			       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
-			       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
-			       (iova & ~GENMASK_U64(11, 0));
-
-		arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
-		iova += inv_range;
-	}
-}
-
-/*
- * Generate a RIL for ARM_SMMU_OPT_FULL_CONT_RIL by ensuring the entire SVA
- * requested range is covered with a single RIL command. The scale is adjusted
- * so that the RIL may extend past the end of the requested range. This ensures
- * that any CONT the MM is invalidating is covered by a single RIL. TTL and LEAF
- * are always 0 because this is only used by SVA.
- */
-static bool arm_smmu_cmdq_batch_add_ril(struct arm_smmu_device *smmu,
-					struct arm_smmu_cmdq_batch *cmds,
-					struct arm_smmu_cmd *cmd,
-					unsigned long iova, size_t size,
-					u8 tgsz_lg2)
-{
-	u64 cur_tg = iova >> tgsz_lg2;
-	u64 num_tg = ((iova + size - 1) >> tgsz_lg2) - cur_tg + 1;
-	unsigned int scale = fls64((num_tg - 1) / 32);
-
-	if (scale > 31)
-		return false;
-
-	cmd->data[0] |=
-		FIELD_PREP(CMDQ_TLBI_0_NUM,
-			   DIV_ROUND_UP_ULL(num_tg, 1ULL << scale) - 1) |
-		FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
-	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_TG, (tgsz_lg2 - 10) / 2) |
-		       (cur_tg << tgsz_lg2);
-	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
-	return true;
-}
-
-static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu,
-				      struct arm_smmu_tlbi *tlbi)
-{
-	size_t max_tlbi_ops;
-
-	/* 0 size means invalidate all */
-	if (!tlbi->size || tlbi->size == SIZE_MAX)
-		return true;
-
-	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV)
+	if (!tlbi->size)
 		return false;
 
 	/*
-	 * Borrowed from the MAX_TLBI_OPS in arch/arm64/include/asm/tlbflush.h,
-	 * this is used as a threshold to replace "size_opcode" commands with a
-	 * single "nsize_opcode" command, when SMMU doesn't implement the range
-	 * invalidation feature, where there can be too many per-granule TLBIs,
-	 * resulting in a soft lockup.
+	 * Determine what level the granule is at. For non-leaf, both
+	 * io-pgtable and SVA pass a nominal last-level granule because they
+	 * don't know what level(s) actually apply, so leave TTL=0.
 	 */
-	max_tlbi_ops = 1 << (ilog2(tlbi->iopte_size) - 3);
-	return tlbi->size >= max_tlbi_ops * tlbi->iopte_size;
+	if (tlbi->leaf_only)
+		ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tgsz_lg2 - 3));
+
+	/*
+	 * The spec defines the invalidated range as:
+	 *   Range = ((NUM+1) * 2^SCALE) * Translation_Granule_Size
+	 * NUM is 5 bits, so (NUM+1) covers 1..32 granules. Find the smallest
+	 * SCALE at which a single command could cover num_tg.
+	 *
+	 * Unlike other IOMMUs the spec has no alignment requirement on the
+	 * address beyond alignment to tg (so long as TTL=0).
+	 */
+	first.scale = arm_smmu_ril_calc_scale(num_tg);
+	if (first.scale > 31) {
+		/* Range too large for a single command do full invalidation */
+		return false;
+	}
+
+	if (tlbi->has_cont && (smmu->options & ARM_SMMU_OPT_FULL_CONT_RIL)) {
+		/*
+		 * Produce a single invalidation by rounding up and disabling
+		 * the trailer.
+		 */
+		first.num = arm_smmu_ril_calc_num(num_tg, first.scale);
+		trail.num = 0;
+	} else {
+		/*
+		 * Produce two invalidations by rounding down and adding a
+		 * second trailing RIL anchored at the end.
+		 */
+		first.num = num_tg >> first.scale;
+		trail = arm_smmu_ril_init_end(
+			last_tg, num_tg - ((u64)first.num << first.scale));
+	}
+	arm_smmu_cmdq_batch_add_ril(smmu, cmds, cmd, tlbi->leaf_only, &first,
+				    ttl, tg_enc);
+
+	if (trail.num)
+		arm_smmu_cmdq_batch_add_ril(smmu, cmds, cmd, tlbi->leaf_only,
+					    &trail, ttl, tg_enc);
+	return true;
 }
 
-/* Used by non INV_TYPE_ATS* invalidations */
-static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
+/*
+ * One TLBI command per IOTLB entry, assuming the entries are all at least
+ * iopte_granule sized. Returns false if too many commands would be needed which
+ * indicates too high a latency. The threshold is similar to MAX_DVM_OPS in
+ * arch/arm64/include/asm/tlbflush.h for the 4k PAGE_SIZE.
+ */
+static bool arm_smmu_cmdq_batch_add_single(struct arm_smmu_device *smmu,
+					   struct arm_smmu_cmdq_batch *cmds,
+					   struct arm_smmu_cmd *cmd,
+					   struct arm_smmu_tlbi *tlbi)
+{
+	unsigned long num_ops = tlbi->size / tlbi->iopte_size;
+	unsigned long iova = tlbi->iova;
+	unsigned long i;
+
+	if (!num_ops || num_ops > 512)
+		return false;
+
+	for (i = 0; i < num_ops; i++) {
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+			       (iova & ~GENMASK_U64(11, 0));
+		arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
+		iova += tlbi->iopte_size;
+	}
+	return true;
+}
+
+static void arm_smmu_inv_all_cmd(struct arm_smmu_inv *inv,
+				 struct arm_smmu_cmdq_batch *cmds,
+				 struct arm_smmu_cmd *cmd)
+{
+	u64p_replace_bits(&cmd->data[0], inv->nsize_opcode, CMDQ_0_OP);
+	arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, cmd);
+}
+
+/*
+ * Used by non INV_TYPE_ATS* invalidations. Returns true if it fell back to
+ * full invalidation using nsize_opcode.
+ */
+static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmdq_batch *cmds,
 				       struct arm_smmu_cmd *cmd,
 				       struct arm_smmu_tlbi *tlbi)
 {
-	struct arm_smmu_cmd nsize_cmd;
-
-	if (arm_smmu_inv_size_too_big(inv->smmu, tlbi))
-		goto full_inv;
-
-	if (tlbi->has_cont && tlbi->size > tlbi->iopte_size &&
-	    (inv->smmu->options & ARM_SMMU_OPT_FULL_CONT_RIL)) {
-		if (!arm_smmu_cmdq_batch_add_ril(inv->smmu, cmds, cmd,
-						 tlbi->iova, tlbi->size,
-						 tlbi->tgsz_lg2))
-			goto full_inv;
-		return;
+	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
+		if (arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi))
+			return false;
+	} else {
+		if (arm_smmu_cmdq_batch_add_single(inv->smmu, cmds, cmd, tlbi))
+			return false;
 	}
 
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi);
-	return;
-
-full_inv:
-	nsize_cmd = *cmd;
-	u64p_replace_bits(&nsize_cmd.data[0], inv->nsize_opcode, CMDQ_0_OP);
-	arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, &nsize_cmd);
+	arm_smmu_inv_all_cmd(inv, cmds, cmd);
+	return true;
 }
 
 static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
@@ -2641,6 +2704,7 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
 static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
 					struct arm_smmu_invs *invs)
 {
+	struct arm_smmu_inv *used_s12_vmall = NULL;
 	struct arm_smmu_cmdq_batch cmds = {};
 	struct arm_smmu_inv *cur;
 	struct arm_smmu_inv *end;
@@ -2674,11 +2738,19 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
 		case INV_TYPE_S2_VMID:
 			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
 						     0, cur->id);
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
+			if (arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi))
+				used_s12_vmall = cur + 1;
 			break;
 		case INV_TYPE_S2_VMID_S1_CLEAR:
-			/* CMDQ_OP_TLBI_S12_VMALL already flushed S1 entries */
-			if (arm_smmu_inv_size_too_big(cur->smmu, tlbi))
+			/*
+			 * S2_VMID used CMDQ_OP_TLBI_S12_VMALL which already
+			 * flushed S1 entries. These two types always come in
+			 * pairs and arm_smmu_inv_cmp() ensures that they are
+			 * consecutive in the list for the same SMMU. There may
+			 * be several pairings so check this is paired with the
+			 * one that did the full invalidation.
+			 */
+			if (used_s12_vmall == cur)
 				break;
 			arm_smmu_cmdq_batch_add_cmd(
 				smmu, &cmds,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index f5c794728fe228..054ca19dde0502 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -804,6 +804,19 @@ static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
 	return new_invs;
 }
 
+/* Generic page-table level 0 is the leaf-only level. */
+static inline unsigned int arm_smmu_pt_level_to_lg2sz(unsigned int tgsz_lg2,
+						      unsigned int level)
+{
+	return tgsz_lg2 + (tgsz_lg2 - ilog2(sizeof(u64))) * level;
+}
+
+static inline unsigned int arm_smmu_pt_lg2sz_to_level(unsigned int tgsz_lg2,
+						      unsigned int lg2sz)
+{
+	return (lg2sz - tgsz_lg2) / (tgsz_lg2 - ilog2(sizeof(u64)));
+}
+
 struct arm_smmu_tlbi {
 	unsigned long iova;
 	size_t size;
@@ -1173,7 +1186,8 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 
 static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
 {
-	arm_smmu_domain_inv_range(smmu_domain, 0, 0, 0, false);
+	arm_smmu_domain_inv_range(smmu_domain, 0, 0, 1 << smmu_domain->tgsz_lg2,
+				  false);
 }
 
 void __arm_smmu_cmdq_skip_err(struct arm_smmu_device *smmu,
-- 
2.43.0


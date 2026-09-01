Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013003.outbound.protection.outlook.com [40.107.201.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67D94908AD;
	Tue,  1 Sep 2026 17:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788285025; cv=fail; b=XJoKG7n3EQXpbVtC/glK6kLSHdr+Cpsbf5/PC+/zJfgyt0Ihoh4W5QCQb0E9OzxPO1W8TChy9IxlkQuq6BVXr2BRhMM7EKNa4jdFQZQUb0cKLpOiTc+8+B4wt2rdJbxrEcKvVIBOg60tOTP/s7tuGBFYlbDkRzA6JbkNzcQgyl4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788285025; c=relaxed/simple;
	bh=13CasIIKfMm22MOhfd+i7zMitI6J/gFrIrmO4/VNqpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=apB8Y8D+YVS8R5yQNHPPbhoHKo/bRVQly+KHItjO/dBFWZ5UU1p3ORk4L8YZImySjFaZoMofdt9qQbyJHZ0PquMqQgt38AdmGku+d8tnJ2x1fnDKokMYGdfBA+KJEY/Bg8Qx9HDXvk10cUMs3iWOyGmEO+qx/ZBYMLJfQAqtoBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=t6eb6+09; arc=fail smtp.client-ip=40.107.201.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="t6eb6+09"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Py46gfmwalfJDnaU1qpAtX7O3b1Ps8nF2MYjL3nK9Puog43kLFAom0Zu1f8bUd8vhy3cEMOe7xGS4EDym06vdSC0TyRFcwuWssTqSB4pfjeTQBH27/Q0F+uMTK41lAYTPta0yNMz9kcLdc1j1pjqzOiPs4NZGeIO5cEj88IyA2It82tJ0wDNUIvS9X2pUHf27lxK1wtnIRyflqSY7sIsoxArT9Mh5fRI/ZEtjxNnB/0Ez+y7GraVu4g0oT0JbFEXRVWlbaqRcocA2kyX/M/Ati1Q7U27Nfhjo1IyuoBvfmvavbSqA00Ofevks9ozYD6leA79R0gMvJHzfUNQwzTk2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LXeEeHTQfsmYOJCPIxYRjposcfjHw9GKBsoeXXvI6nQ=;
 b=XPKaSYqIW7r4t9AnGL1wdGyIWF8Xd2548QTSMlC+ytyq+02TIBAxNozksrW6E63biAoTUM+dhaiHsIDlJ+JDEo7xobS0fba+V3APMGqKuEO9jWjNxDCNLU9+AHbVTtAt1NNjQA77E/Pe1YSiOVezTtwMl+bbuWY9ZvLiurzQKlfiyzuo/8JkNSdRcqf0UMjwrr6tDCvN/a9p7JqS5RB1y02kL2y3Bk/XI3DiE9g2MQ4jrJqP1IoEJa2SoobEd3lpBFbDjfsgbndQQKX9IbMIjuD6NeQ/btvd2YpYyZ2WEJYchQjuIeHJVFXGL8DhTU5ofkY1KHXN6+WRFpEcb52vTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXeEeHTQfsmYOJCPIxYRjposcfjHw9GKBsoeXXvI6nQ=;
 b=t6eb6+09lg1vrq+HVmaLdSYB96tybQ069Gv++MpUcJ0A7Bk0PcveQk90aJlvCjbatWws21BZ99EoVkXq1K+L+ELURLe1+efWEYO6YGiYaXlgXdEdtErRHvi7bEI3h4MSrSk5L6p17JiUolwuN35Wk86bYVLsiSfdn1Ldulmxww4LZKGgC+dP6K+xlMAHTNWUKjTVaagU8VjAp/zkFCAUW5+hk2qK50JeSwQsprKke1CLI8/oMaHtvdBat6zoZqc6cwb0Bdqg0YO78K1fAuMHa9S6JlGJkItgRCO0T57pTtZwl15YJJBHiT3IbbDQDgN0+47eLLcKHp9dT89hKDWt1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ2PR12MB8848.namprd12.prod.outlook.com (2603:10b6:a03:537::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Tue, 1 Sep
 2026 17:50:08 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 17:50:08 +0000
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
Subject: [PATCH v5 4/9] iommu/arm-smmu-v3: Optimize range invalidation for latency
Date: Tue,  1 Sep 2026 14:49:53 -0300
Message-ID: <4-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0066.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::17) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ2PR12MB8848:EE_
X-MS-Office365-Filtering-Correlation-Id: 669722a1-4d53-4cac-68ff-08df08517363
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|10067099003|11063799006|56012099006|3023799007|921020|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	q3UYksxx1csIHRrTeh+G5GADvzUqtGl0FJI52pc9jVLUdWFC8YMw/saIWozP0wF9ILs/eMN3XhJuH8QgyWxLMYmvSP2fJ5SluvWk6JYIKwMhkXXsGuccGKXYKS2tl5nl/UxHQmm10FduywR1GGgdDX7lw5m2x4vYnaPaz/j+N6Ln1JIXDFsm4E1sITeHvfZTzCbtU8mgIM/kYjZbC8kT34waaipQDY4r1b+wWHTtc698eFpzViOxDWoTgqPhyvpRwOS1srigE7Q2H63li1l183z7qsS0JL07divQq0bw371Mh/Kp21gCJUPHzo0BQG9EpeN6QDR/JSgEKRVRf36bX7A25Kx8pdAMAlWmD7XdzyCVqC4bhumjtWc5MPmXoBQCW9Y22lCf82FRjs/kgMfjd8iJ92a13U6Ib8DmD9Rmc0J5xfnCSu3AsXs+eTGX94JQO+DDYbnn0mk3WKQSyAgfP7HrfZ/YivPA8GDs7gcf9QCvn9z0i+wRwr5c+CsOt0j/33MrQwsELkKCNn+wMPe4kd3UD9vrl2uFXE8gYStTjRWloPlmJBWIijClSUJ9GRzzyTfI2ntYM2N2+ElqUUBBeWiD4GPCr76C4CU+lgZJN9RKo32fMdv0C+LPXg3A68N3mtRFhBvCCNA+T4EIbIBeY+aIX/nG0t4bv8rU/0ASk7TbeUCNQEdEBuzTx7Ngt7myCU66pb5BPDiQ89ri1UEnmA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(10067099003)(11063799006)(56012099006)(3023799007)(921020)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y5CZR7nflCw/DopIUcZ4t0foYR9RmMq9zSc0/Feu+sKYGXY7QoiK+2uKDI2P?=
 =?us-ascii?Q?OXQmtC/5oCnsgnDncnq0bDNjujFFWY3OqJk/SmvHSjhafLHzY7qo4qQIGQS6?=
 =?us-ascii?Q?JECkkqpTfDjQKgBCjj6hhHBUoc2CZ8JbKU/ERz6Sew+jkOCBn5JInWcGEKp0?=
 =?us-ascii?Q?FhelmNhP9VRWOBSwTHlCnfOEFbWTtd7FuOmzEG2DNUKrG7m08u1bDXmrg3jk?=
 =?us-ascii?Q?waoQpdoH45n8zipjFH2T3JTG5F2s3TspRC/2eBoegNIqA0droon/EdkJXTtO?=
 =?us-ascii?Q?bG/8LuwKgEAZAjNdP4WUh4vzCsY8xGxTFNptrFNQU6bSXqc6chf43TaGUuwT?=
 =?us-ascii?Q?VXLyog7Q2xqHdG60VZnGTlLeIleizeBktvaizmwG8dcLUCCYkfPPHoYIo1h7?=
 =?us-ascii?Q?2++DfvVFIWeaBiFfB7tn5elAyjLtpUZoi14qj3URPNI5/ItfLPJkA7QT0oyV?=
 =?us-ascii?Q?cnFFuH7hrz7KftttiOhm2dVw+13aj2jsnUGRnLD9S8dmG7yzFqYL6RxVOJkA?=
 =?us-ascii?Q?atO8g3BcusFUsUAPH5GGXJ612ZknOmVJMJeWjYGttnyXH1HWYL4NV7t3bW3b?=
 =?us-ascii?Q?aqITAqSSKiRh7RDeTDT/4QRsehk15pgaqldR0yjUt8N53aTy5/mrFzFhtQag?=
 =?us-ascii?Q?hiTemky/eVBbBZB6DbrexKKFdQor+eEGg2Vq1qeBM5mWAXKNLXctWL0xYl5k?=
 =?us-ascii?Q?t4q38dxea2h1sLgPLSDgHf4vW31zq0ciUHIUiG9NzJbYGsJBR8gwNNGgITtK?=
 =?us-ascii?Q?hgdBBN2ReH5A5pzm9dUacOaDb9WtCXyKYaiOals1sCpkON2RGfzpmZADEwvH?=
 =?us-ascii?Q?yUQ8b0qSJ9hwOx2TzbXEdj66D0ON/Wn6HXK/VqBa/kOVOWIHvXZYeWjRQMM9?=
 =?us-ascii?Q?egh5CaJZ5ICfeNr+a2gxHBbIxUn9aGruSQcK5L5YmK1EDMLQ2YHFL7f8AodZ?=
 =?us-ascii?Q?1JXevnZDAWjmKfAbrNejA2pOU78ZxwpLH2YV9WL5ATJg1pVJFnU2sR1pz7xe?=
 =?us-ascii?Q?RfiCG22xWLWyqHvJlGp5OWh1KGgYmRfA8j6iB8O6COMzGPqExyOwuhh0eRMW?=
 =?us-ascii?Q?ryHjIJpoMOIV3SZ4paQETYCepnyCwW2sqJGsFeypN4v5d5Vxj8wyF59dQ/ix?=
 =?us-ascii?Q?oq/pinlxIe2JgZHXaJr8hS4jYHLatsD1Gxj9aYrVmuj90ZB0Vc5ua5+mVJXf?=
 =?us-ascii?Q?ttXdPZ2miDzQ6RBVBfSDD21uReYnA2k7aqx9GOFMAKfM4cxVfZfG74YW6xM3?=
 =?us-ascii?Q?x68CJBztoOSMBG9Ha+t/ZJ+i1Wfr6sQFEDQBQLP/TDE0ks+UHiUuwnx8Igdd?=
 =?us-ascii?Q?TE3nK4ZZOJ8no18XVHWDg1W8wEED08FfxCPROiFdXdLH+jzSUQ2J3CvYTyfK?=
 =?us-ascii?Q?+K3Qlre/iAQjHC9zsn5IY8SEinTmHx02E0fygqUpMKntlsTfc9mn/+Ic3eAX?=
 =?us-ascii?Q?5+jBpkN+VwkK/7UU0mkRneKkBRnqx76bgNxvv58zHQ+CMGsFw/JrsYyEHo4+?=
 =?us-ascii?Q?zlLldxcaO2cyQZslt/N3w0HqqTTctsyBP9PdN+lINyRfnRM+M6pg92KqoAje?=
 =?us-ascii?Q?75uWxbUakGaVwOUQyUqmSfnK9D8YScrAYL1v9/vgyjoo9vq+taC4TzwNL75g?=
 =?us-ascii?Q?1bVyKmX4RyXcSXBzh0WlWzntSNNka4Vq0+3OLNNgBfH3xgyaDkuhJXqbuiCB?=
 =?us-ascii?Q?0t2jY34IHSOWy2EVguUpzB/NBmVFFRwDmzXM//hMLA/B43Ja?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 669722a1-4d53-4cac-68ff-08df08517363
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 17:50:03.3548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: toNRNjvrPhtViwBpZUDPLeD8Po6t1qLFSp+Sk0tyG6mKuBlfc7D0j7ns4P/dHCCy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8848

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
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 354 ++++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |   3 +-
 2 files changed, 210 insertions(+), 147 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 6413eb4021ce22..9b79d7a5389812 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2460,166 +2460,219 @@ static void arm_smmu_tlb_inv_context(void *cookie)
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
+	unsigned int pgsz_lg2 = (tg - 3) * (3 - ttl) + tg;
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
+	ril.scale = fls64((num_tg - 1) / 32);
+	ril.num = DIV_ROUND_UP_ULL(num_tg, 1ULL << ril.scale);
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
+	first.scale = fls64((num_tg - 1) / 32);
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
+		first.num = DIV_ROUND_UP_ULL(num_tg, 1ULL << first.scale);
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
@@ -2641,6 +2694,7 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
 static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
 					struct arm_smmu_invs *invs)
 {
+	struct arm_smmu_inv *used_s12_vmall = NULL;
 	struct arm_smmu_cmdq_batch cmds = {};
 	struct arm_smmu_inv *cur;
 	struct arm_smmu_inv *end;
@@ -2674,11 +2728,19 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
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
index 3e7f94339ab60e..8b075e05d900aa 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1173,7 +1173,8 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 
 static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
 {
-	arm_smmu_domain_inv_range(smmu_domain, 0, 0, 0, false);
+	arm_smmu_domain_inv_range(smmu_domain, 0, 0, 1 << smmu_domain->tgsz_lg2,
+				  false);
 }
 
 void __arm_smmu_cmdq_skip_err(struct arm_smmu_device *smmu,
-- 
2.43.0


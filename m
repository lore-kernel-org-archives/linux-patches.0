Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794785452;
	b=J7+L0D2TY81Nmmqgxd03udQlE0lac51h4OHQSIpEAV6lb5kblSIMzRzqy/OypQSEXqI9
	 bMfy6Xrrtp0Gh08XIHe4ollcf6zJQACneH/63nTAExse8YhcoQDxW3F4TO9czYHmO5DVs
	 s/Eo7ue80ZQJOMq0i7YGDijrwBxmCI9f2u1VpeWpP3rM+oBhD7fgVfYrnVn27p46i4ji8
	 Psdsn/1WF0Ket+6QZlhYJecN686G2lsIYQcXbP6UCvynXO++WQWZcu6BL2op0e8oNlURX
	 yksm10jvTryzUG/SuPJ34pWFlzcnLVcxHIpDUe3jLItzmntbactSlCZhkk4Hw11HgGw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785452;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=DPF3R2nyDFGBd23FCUBJCvWm9MUDvz76zdHLvUpJ8sA=;
	b=gCvRLgWZsRdQCi2Bea40kr3Lje8WoRDzUn9oU6nVx3RLuGRfykkQSRRzgA/TB9oLo9I4
	 Z+5C7zhnEn6VyHba1lx+xowaC1XBhU4E2+flrqzBLLRAgRw/DYfDp08c2Yl60Jk68fLTf
	 zF39c3xAOJshk1BbcMFBR7wZzDRoiJ3hncqJX++uWgAVMJf1m+FQ2/RN3z950VoHnShLw
	 /kUQGFPA8v6biQpRgmIpCnD/JtpNiWNwGps5lJas4I4vWygQt7YkuRtZuHEUA4c2UtiSn
	 28r0Th91BZDB06t4ITT8zM/jwAa4d8GhHfoifkXVSU0xHoSCs80v0qMn7MaDwXmFo/w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=g2Bc+tgs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.51
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011051.outbound.protection.outlook.com [40.93.194.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D764C606A31F;
	Sun, 15 Nov 2026 23:30:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D764C606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=g2Bc+tgs
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UPcyeiQqILKhzTCwjf0b7qCEsWkN0qEZBUhDbAbFTgGYDfEOZfiZ/Um5zQqe1rumc+lAtT+vSRj/+AytTjeRfXjJNCdKGcVJr1lS/CGoaj9u0gdvkjdkBtXXs/Q6ZoFjJa2QiEoCHGpwXz2GqCvk4jG11K+XEPR6po99hW1Yvbc4ZvWMv6RPpDwioxUu46M16J9pHDaAta8u9aTFfl0TKCcBGzjUyT9sFPfBEaChFU91Fby6uG5Ps0aVuG+JvVk02uyrlLFa65NDijBBzoJHifIR+iZzYZCQW5w/uvr3h0l5lD4fqa256CllAQpz6HDd2ACdhwfPGbzC3RUfByT0pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DPF3R2nyDFGBd23FCUBJCvWm9MUDvz76zdHLvUpJ8sA=;
 b=yigAkuTHe1AQLWL+BoBkptmGOAEcL7XQU/lHmbesLzivibLZuu/ls/ldHwViQeD1MGdSzbYh9BxL6LHQK65nVifohS/jVOpjhfS+eXd0es4CsdyP1d2dZuTKI59DJ8kMUrOyHurg6nim9Be38tcpU3Z93Cc1u8rJr1R54/BQ+hoPTsXkq0EjgoHGgvCqJA5orRrj7koHbiuuY4k0LjToq8px7l2CiBcOEBMHikwwSLemQle/azHSgmjUVuDN4eBVEowPsMlnnTFSUKFjmWMwbH73c4S7+q9kiqalMzhnaBJF+zV7TT7kx2UrVXjmeQ2q9bymYOIUMIPJ140G4ujFTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DPF3R2nyDFGBd23FCUBJCvWm9MUDvz76zdHLvUpJ8sA=;
 b=g2Bc+tgsEiFwCgzGGsaK2nzTcg23EVy/nn6VhZccG5zGjLuBEyzh63w/yJyJHu3qrD+Rvu2tzgdStLkYLn7l8O6sc+KxaHwodnsv/lt9Jgz4NrgKN8svgD0vPIoV11Fas+dVEVtgAKYpIUh1HQ61CJ0bdbfvrb4Y0/+u39p4rS/QrHRWkMYsaHKg+oLCXtqr2OcIly5msDg2OrDABaJxDRYohGB/bF4gs/6knaJHJu4aiW4Ot056zdp/c/SbFbQEKQ1hWRa9YBbrwYUYlDs+ap4RxQ/hJgZ2nZPtFWqmkPQq0EuN4YfdlA/+NDsft+dWUAxq2erdHHCPEvOq53AUsw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS0PR12MB8815.namprd12.prod.outlook.com
 (2603:10b6:8:14f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Sun, 15 Nov
 2026 23:30:45 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Sun, 15 Nov 2026
 23:30:45 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	John Garry <john.garry@arm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 02/13] iommu/arm-smmu-v3: Support the DS expansion of range invalidation SCALE
Date: Sun, 15 Nov 2026 19:30:32 -0400
Message-ID: <2-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA4P221CA0001.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:559::16) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS0PR12MB8815:EE_
X-MS-Office365-Filtering-Correlation-Id: e9fb610e-0f90-431d-1434-08df43707861
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|5023799004|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261021135927099003|261022105027099003|261022075727099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Ojhd0EIhyGcfSVvSAjtFnduk91C67SnKs9jRzD5IQDPSJx3/KiXRmbSszDmF7yhZ+T3dPul2zfM9+Niqx2VZR3vZkH4RAYKSq3We2omdfsiU+2wTh+og513R1Dq9HypDiVyi6rZ+DgKCqtJVAWkxdLB+Rw8uyo2UpZTzY9waCX0EKCspxrRGCL85BZ1sPoLsXwe1LgLaAFfy+16d794BqcviwvegZj4p3EZdFYcEAF0E7tAwr4RxpAtVEb1fTyG4Dfs9uBMAucQH70dzxLJqwndKqwhG1BBM3HCttJtnENryzC9doujYDw7H1mcDwvMdTInmHG54xInP9ILmWRM9ml+/3ggpEwq08j+nnv2nSbEDL5/Ce7blQ8McmfzYlGn8nOGcLCsicbnK6zaGlcTOflu/bY3t8YmDheGpYPQHbKGLGdP4Lk7vhyaUAMj2MF/Vk01fSpw+/SYu0FjB0Vg75e0n8W7+lEVCVkWnFDNHwiCcKzJ8LJrYsoRu2LeB5j+eAhHUEWZrlSGu4SDP28RrkgQy2i7bMf/wY3EcMdHTVI+900tu7gFs+r5CTPC/Kv5/XumAIEFh6TIYnWsPwCON2FYf2+wkzAwU5iPjZnVTuWX7dCNWaqfJ651tpWrGe+Sjb9rcQNwS0x4eMD9P3rHFjkLBxzd/EnRW18OvGWtbF3M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(5023799004)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261021135927099003)(261022105027099003)(261022075727099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hDRoUt+TUAzgotBhYqtBXnYJi8+WlCyFei6RiNd682XimIAFNGBOWaHLEMzR?=
 =?us-ascii?Q?WHerlVRR+kjI9w/k+YoIUBcd6h+qUUB06DdMwm2jwu26ymfDsxMnySeQ8CC7?=
 =?us-ascii?Q?5Nqr72uY3F24Si43zu4Go6symnZ0xBQgHkm1giJmS/4N1lPyq4gqe6qRETTM?=
 =?us-ascii?Q?Y5F6SrtVbBHfBLJq3FpeWghRD/L+OnKl3QGCqjf0hzW5QWk04zYkh5Kokfvc?=
 =?us-ascii?Q?hsZtLob1k0aBRIgOK65KO+tdGkLLaEtMGVUq5hwWfQsPQE9ypLSxPa7qHPsQ?=
 =?us-ascii?Q?c/a6b698FUkJ0ltVG6vDky7rhmwva7tlgJ0LtmO40CByCi/t9QIZBfaBiIgW?=
 =?us-ascii?Q?Fe1YRPCrw337/G6dPWmiaF9YJZZGprtYn7q2sSlFp2U5R/y7wH82Y/ugI06g?=
 =?us-ascii?Q?dinQfY000EhHck2zsfySm+HqoTyc8Ft4fZe+y/QyVC81nVPPRcVqQK5hDWDC?=
 =?us-ascii?Q?F+nWh0K9B58knqpWJXWzVORimk/1jS6n8rZ2A5ZMZ1t64csjArguSBJehYF5?=
 =?us-ascii?Q?mqgpLQ08unLvfdY9grOwNnvI3Ka2l5IAZADf2KhBn63pU0TTf9i4Fw8EHS0K?=
 =?us-ascii?Q?ftsqN2JInymyM1LW6DexKmsQZzQRDSGfqHXFVCQ1bd3hU1vv5w89mhB1K0Mt?=
 =?us-ascii?Q?6OA2zD/euxT5o10ul1jUdTj58f2ekBe5C6me5k4vGxWXKX4dlLNMna3zNa+G?=
 =?us-ascii?Q?OiMhWc5sCct1Wg/LIZ9/gysYrI8/d7nNlkHOUjIs/g7D5JWV3mqHcOpMtwgx?=
 =?us-ascii?Q?TzPu3k02floG/m0gxv2NEYyoVVZxXvXsn35f/OkO5nrV6qikNNxbseEYmO7a?=
 =?us-ascii?Q?N+gWaNJGASBkZxZClPU4jYWro85g1FUg4xZGcAhpAwtgAt61hpyoGnCtQQ5c?=
 =?us-ascii?Q?MP/fvsSFWg8nof0KI3m2PX/Laq+MhgdZUPd31Rh0n+pGSrnHuhNG16mUEiV4?=
 =?us-ascii?Q?X69aN9LK0f74ac3z/Z7v1AmBXStdJ+znF7R591H8U0AMFnUG4f7bkkhJl6lB?=
 =?us-ascii?Q?ZDG1WtHzNDc6Erfp08TaRJc08NGR8Ej0Dh92nZEmlEL0gq0kdPrisc5GjEYL?=
 =?us-ascii?Q?Y6ti5x6mCujXEjyonc9nnVSrZfJRHtgyqiRNK76iWrdfu5OpeNrG3DWsBxrn?=
 =?us-ascii?Q?7gzCd34pyWdBWGXqFpxoDcVBqWJ2kQI4oIRvbqOPrO/lh42LbV323KTg7p5l?=
 =?us-ascii?Q?1QZHD6nM4Tms9U2z8Kskk+CO5AFR9BqCWmf2gPbmtnp5515PN4q86Fb4oRjd?=
 =?us-ascii?Q?cGjIwrSg8kLk9WhuWFRnp03yII6Zv+Pa/efGcjAbIxWKbp2B9WqOloMpCGJn?=
 =?us-ascii?Q?YbJGZeEFz39EG+g1Idgbq0RXR6vQx9akYZ1dmye24X7bqU5elLgN4ng6jEus?=
 =?us-ascii?Q?KDnrkl0UaXvukBB9YM5Ti3Q9jxJpIz9f2H4UMSujkBJYBH7OydzeVDYXYvhG?=
 =?us-ascii?Q?dnXiUeB8u+TRWuMl+5Hzqc8BLPtc3fpXZAKgtJ1lQwfohNPflqkQPoJ3SSEn?=
 =?us-ascii?Q?/WjIfloMjnTv4C6WvWuU2SALn8U4RUqLrVxQHNH9MpEPyvpMmqaU1SDuN8OV?=
 =?us-ascii?Q?eCoxladQ+5SZueHBMp4nT7sI+EFT1RDQV4aZIviIKAt/RPu6oe7pE4bZ1VX3?=
 =?us-ascii?Q?+kmOwyKyVeQ45PGf9nGJ8YJbxVcDVaknkLqg1bDV3/GY62U7uyOeHoUbMBcr?=
 =?us-ascii?Q?UtGWvxROxFdeDXEwz4QZ1rS9IH4IFhsqxKVVIwlozK1D234T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9fb610e-0f90-431d-1434-08df43707861
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 23:30:44.6066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /q5qTDkxerTcwfgVhia7+hnLi1IqHRNRwZ5U23IdI2xZGA8wKSKhIIbKAbh9Xpzf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8815

If DS is supported then SCALE can go up to 39. Compute a scale max that is
compatible for the entire invs list.

Replace the has_range_inv in the invs list with a 0 range_inv_scale_max
to mean range invalidation is unavailable.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  4 ++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 22 ++++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  5 +++--
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index 5a4e45e1512589..3a0fef761daea8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -647,7 +647,7 @@ static void arm_smmu_v3_invs_test_verify(struct kunit *test,
 {
 	KUNIT_ASSERT_EQ(test, invs->num_invs, num_invs);
 	KUNIT_EXPECT_EQ(test, invs->num_trashes, num_trashes);
-	KUNIT_EXPECT_TRUE(test, invs->has_range_inv);
+	KUNIT_EXPECT_EQ(test, invs->range_inv_scale_max, 31);
 	KUNIT_EXPECT_TRUE(test, invs->has_full_cont_range_inv);
 	while (num_invs--) {
 		KUNIT_EXPECT_EQ(test, invs->inv[num_invs].id, ids[num_invs]);
@@ -715,7 +715,7 @@ static void arm_smmu_v3_invs_test(struct kunit *test)
 	test_a = arm_smmu_invs_alloc(0);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, test_a);
 	KUNIT_EXPECT_EQ(test, test_a->num_invs, 0);
-	KUNIT_EXPECT_FALSE(test, test_a->has_range_inv);
+	KUNIT_EXPECT_EQ(test, test_a->range_inv_scale_max, 0);
 	KUNIT_EXPECT_FALSE(test, test_a->has_full_cont_range_inv);
 
 	/* Test1: merge invs1 (new array) */
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 54178af99c9407..294f9645cdc3db 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1065,9 +1065,19 @@ static void arm_smmu_invs_update_caps(struct arm_smmu_invs *invs,
 		invs->has_ats = true;
 
 	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-		invs->has_range_inv = true;
+		unsigned int scale_max;
+
 		if (inv->smmu->options & ARM_SMMU_OPT_FULL_CONT_RANGE_INV)
 			invs->has_full_cont_range_inv = true;
+
+		/*
+		 * SCALE increases to 6 bits when SMMU_IDR5.DS == 1, values
+		 * above 39 are treated as 39 (H.a 4.4.1.1)
+		 */
+		scale_max = (inv->smmu->features & ARM_SMMU_FEAT_DS) ? 39 : 31;
+		if (!invs->range_inv_scale_max ||
+		    scale_max < invs->range_inv_scale_max)
+			invs->range_inv_scale_max = scale_max;
 	}
 }
 
@@ -2659,7 +2669,8 @@ static unsigned int arm_smmu_compute_range_ttl(u8 leaf_bitmap, u8 table_bitmap,
  * CONT is covered by one command.
  */
 static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
-				     bool single_range_inv)
+				     bool single_range_inv,
+				     unsigned int scale_max)
 {
 	u8 tgsz_lg2 = tlbi->tgsz_lg2;
 	unsigned int ttl = arm_smmu_compute_range_ttl(
@@ -2681,7 +2692,7 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 	 * address beyond alignment to tg (so long as TTL=0).
 	 */
 	first.scale = arm_smmu_range_inv_calc_scale(num_tg);
-	if (first.scale > 31) {
+	if (first.scale > scale_max) {
 		/* Range too large for a single command do full invalidation */
 		tlbi->range.use_full_inv = true;
 		return;
@@ -2952,12 +2963,13 @@ void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi,
 	 * The invs generation ensures this matches the instances being
 	 * invalidated.
 	 */
-	if (invs->has_range_inv) {
+	if (invs->range_inv_scale_max) {
 		if (!tlbi->range.use_full_inv) {
 			arm_smmu_tlbi_calc_range(
 				tlbi,
 				smmu_domain->stage == ARM_SMMU_DOMAIN_SVA &&
-					invs->has_full_cont_range_inv);
+					invs->has_full_cont_range_inv,
+				invs->range_inv_scale_max);
 		}
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index b08c112875d3b6..7106bd3a8bd7f6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -765,9 +765,10 @@ static inline bool arm_smmu_inv_is_ats(const struct arm_smmu_inv *inv)
  *               Must not be greater than @num_invs
  * @rwlock: optional rwlock to fence ATS operations
  * @has_ats: flag if the array contains an INV_TYPE_ATS or INV_TYPE_ATS_FULL
- * @has_range_inv: flag if any entry's SMMU supports range invalidation
  * @has_full_cont_range_inv: flag if any entry's SMMU requires the CONT range
  *                           invalidation workaround
+ * @range_inv_scale_max: max SCALE usable by all range-capable SMMUs, or 0 if
+ *                       no SMMU supports range invalidation
  * @rcu: rcu head for kfree_rcu()
  * @inv: flexible invalidation array
  *
@@ -797,8 +798,8 @@ struct arm_smmu_invs {
 	size_t num_trashes;
 	rwlock_t rwlock;
 	bool has_ats;
-	bool has_range_inv;
 	bool has_full_cont_range_inv;
+	u8 range_inv_scale_max;
 	struct rcu_head rcu;
 	struct arm_smmu_inv inv[] __counted_by(max_invs);
 };
-- 
2.43.0


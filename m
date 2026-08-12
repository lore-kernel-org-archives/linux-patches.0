Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012064.outbound.protection.outlook.com [52.101.43.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA600367F59;
	Wed, 12 Aug 2026 20:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786565382; cv=fail; b=qcyiMT2QtN6UICNtfn7VagXJXTRnb1qxZnDRHVSB0FyE1FqroBEOtv25h0EI9W2u0nGnO76eti2NweSh4V59YFyYE2RBhjKFiqmveS0nyLKLoK/S31n5fsNtC3cUYshFFGSEWRTUOeAZPxTBWrzE2vMwtZ6voU9EI85PxrrYMvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786565382; c=relaxed/simple;
	bh=swfuJA0KYlctfn59r4ArGz1LRyRZK8uU4C1b3CtByQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BBT+qDyG3NszDI4a2Fykely9uAUjynMAtyn/BzJL/vUX92Dl51V6Gzz4lbjz77rTgB+rxSa/v7RqixWhzCYqNeJB6dVTRQJfGORj+kWatcrib08JkIJ9j5D4YnQZOLt7ZrA1wDEMYVjdgj6M0IUkgUk3El72XKRxVBb8uJlE36s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pCDkYAWG; arc=fail smtp.client-ip=52.101.43.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pCDkYAWG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sjUuAxY41dqG3Th7JbbdKczm8hPxtVJoWP77rRDdM9UULbItzZZbBUbyvNoKXpO8SW7J5hMXLOySFPyhw8rzT09MLGO27RLQEmLgWih1zG/b5yDK0tL3y0yRdCHTvzKEnkt1JduIgTp0yueXnSx3xFlIPFwikOUDyqS4O7pbVhYq4QkQYoMf+5MIvCjOldhLgc889ZbLe7o4alMkF9A5N1jFJbzyJG+OrLK1KV0niwFUISurxL308ImGPsSLCY3F24uWMr6uGkHvhNfQ2AFbhYt297KRG74cwE2Cl5UwQk8aYf9IhXAgWSLLIY7/tEVfvwtktfjEjuqvJDhJ+9TLkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=StyIco0k9cjVpsLGu5TgW1gfrpZ82Fyuhg730WwydnE=;
 b=ctJ9PEwUsBs0jJNNLth67z7vc/b6dQdqPst0E/0Vsxdawpb2sOznf95uLxRh7MUkVzUgi2+nUOF6Tz8I2UH6EgD3wqAaxPrcLNmc/EFdYyApxP2PJt2t38NSEcUeMCLpeo98Guam8gtFqjPEFbORnxS1P+K+kG/fp3CRKaE1nTypb8NJ4U3TP/J/vu3zK3nsahPlEL9QsXpvIrQDYp9J+MAMKgqrZMosqZJ/8k4zrhLwKrh4e6PCF6tmApd0ODwuHwm9Z9OiDXDh3kH6tbT2Cij3rdW6CEr9lqtpWJP4WEaevZ+AGXGLEw10i9BFZM2uuSIaqePNs0zm5r5fO5Y49w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=StyIco0k9cjVpsLGu5TgW1gfrpZ82Fyuhg730WwydnE=;
 b=pCDkYAWGqLoepBmH2cP+boO35LcTTl8wa3Ah41WLEPXZlA14nlaatrqJHzgF5Ihs/nXGYIMQ14twKBY563VUw925YfNyi6yl/kP5lDuoR1/Sjr3GlVaXD19Ffxpv+OHEB72vebl0aeesognRz1R/BoiwLMIjBfMopSX+3+ki6z6ak2Uh3QFmK7pxC3tFrY9mgFzugrqDvrNhx63XosCR7CE9vxFce8+ojyWEA6EOboHEANAdvIVNLFXuPix4SMZR/YPp/cCrmylbh8B9BFo7RB1aDIKEbT2kdGNHKveKqjMsdVLO+0tF4d0cZFoUaIRQ/JurAX9oJCirMcc/uwhtvA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY3PR12MB9629.namprd12.prod.outlook.com (2603:10b6:930:101::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Wed, 12 Aug
 2026 20:09:36 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 20:09:35 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 2/9] iommupt/kunit: Skip test configs without supported features
Date: Wed, 12 Aug 2026 17:09:18 -0300
Message-ID: <2-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0014.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::17) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY3PR12MB9629:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cb8800b-91a4-403b-7059-08def8ad9cec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|22082099003|56012099006|10067099003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info:
	eyce/v9un9N3c+dVHh4Xn5kEdKkwaPWLPnWht+yjpimx+kGqyGfwMdVCvuf8hPaGADPyq65bzlpBH51IZtuFDe/xT4UlbpYKFNYV/JDXwiyn/E3jWmCIvOKxSeQBVU98GMXvJzINkDoiS8GoMWJy9xoljE3EE56dNkI7Edrz14qSDzL42a/fHeChQLCf9Krn+6nFgWYM/4B0pwmoBYaA5L8hwu82ibG5v8AZQHzIm7o5T0Es905+wNH+kKl7saDcT7pWjOjCO1DtAkZ1D8ZKTyUsa1K7OFSHBvKPHBwtZ04b6N3lQ9pvatmNuvtDV0GvuwxOjc68AmYcpyL5kjbKvLjFfXmhTULKfidNTvjzrKmJAwIKU7Lt0IlmyKake1blN3RhGRSemnM+VzvaGn803itw9pTmV8f4G5JdiCx3mPuJX5gq0+xqDx2WhgaQ8aOVl56jSALZ7Zrj4ZG5ARJomuFtXCsw1j9iFoSbIzodjLfl7Dee3LOt0YnS9HJfag2gmX8UKuX7KFL6APbHiFJeIWLmdIWk5a8pTZA3LVzngE2wv7pSGRML4v9S61ykK3wDVi23w5I2YwIFfpc8DM/kiT4XJ5IePmHP9cxnpsMH4MAVW1P4kcZo4mEIxFfEgfDP51QEQeAERMgy6VVXjnK8o1hTTTzImrI1tI/BeMmLFsg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(22082099003)(56012099006)(10067099003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ahd84xhaN0RHIfLswtPdQD3BuZQ266UClQLGoViJS/DcFPPsRDa33cFVNPtR?=
 =?us-ascii?Q?vevTLzUj7x5PXQ2P+n/Y5YW6DMDVDLcBGwqXUWnzEbR3OpphNxQkgHZRI+l0?=
 =?us-ascii?Q?TIiLx0/ZiCoaLzJzspdgpQ0Drjlt1v66lhzZCoul+H+70pTPXAxM8aTYwMbO?=
 =?us-ascii?Q?AFOUuinLJDPzp4ScmhXCeheY68Kgfeuc/ZV5jHZ+fXpbpvuDNNfTw650ifsT?=
 =?us-ascii?Q?dJ7myyNSS4BCLbJlvX0GG9feiJr0tZ9/NOe++Dn23zhx1MhogDI6ZDNK7C3v?=
 =?us-ascii?Q?cGLy9++Iy52HJqu1Xfe+b/U5AdZ/pGQc4hBsIegyliSLgtbECHFXLNrGY5FT?=
 =?us-ascii?Q?e+RowBG6A1vn4h633o5gFJ4+vA0VsagzJSlGsh0OatvdIO6t3QHm3rJA2ubm?=
 =?us-ascii?Q?5pTo9vvI6Vh9i79IHfbBMhyL88h7HoBBJhMIV8y3wy825XPtSrAKeLDsZRTf?=
 =?us-ascii?Q?zRqs1fBqHadQOPNxD1yF3yOEQ1r2RwNuyRA6PgAWBlmVF0EeVvMOdfZihHsE?=
 =?us-ascii?Q?rhzz7AUwvhTRmhXO3eWqZUNLtJVRi6bO0BOG3E8MsL/zTyHfWPdnztQP8Kbl?=
 =?us-ascii?Q?LDD+/J/brdZVoPpzn8dRR7D0G5ob/s4gdUnXAwBCePZ4io7j6/Hp/+0GQpq9?=
 =?us-ascii?Q?CcYLtPJVcYykcKossghlfeCntpCqCHvEWzo8DXjBb+VillzJRt+mYe5EC1YE?=
 =?us-ascii?Q?qBKTTgK53j9MKPt0/OuA/yteI9WCfwgkR9j+vFfRjGrk8FhS1b5el7r0wn5h?=
 =?us-ascii?Q?1vFwj/nY8R3qMSXDvd5nL2IOd8ufSwWzWsJIngT0VH51AWtQfTgwxrANlkya?=
 =?us-ascii?Q?0HfB/W9pJ8GZ7cUNTjkP9rwC05lYbA8rB/H5PB/+w22jJ+SwqiO9QzJlsvlf?=
 =?us-ascii?Q?uAh3aUYH2Jh1lgRpUaQGpsAzfWav5ID6PsJusguSyygpmAhlT3cCuzopMwBq?=
 =?us-ascii?Q?o/GbfzX4BToFMXEzKaj0y/2BchM+8/LXiNpx8Qw8waTDRuBSLegvmSuzBmi/?=
 =?us-ascii?Q?eb3G6jWQK47y5XLCJ7ABKsLYOOoW9WOLECvsHajHn1wLYg4QsdH5JmkVkiHl?=
 =?us-ascii?Q?6xi7KEPvVFOuz+I3RnOn0NC81Vb2dmsVBTD6CHEBf6ZyfOHYS/Fjn1CyK4O1?=
 =?us-ascii?Q?t4WG3AYcve6ObtDm5M5XiCl28t5rCRzRPxns514Or9PsEppS94i6+vt+G3hs?=
 =?us-ascii?Q?3ixJ/HSSO9Qo74yZP4jb5HTExszDdBkbnu2zi+tmnQ7Ky8cPY3Y+WBAQxHN8?=
 =?us-ascii?Q?vBulEkhCAN2VYVgi6rxPlcLiBHqASlkX8Cqn/OO5av9s35ONZ5mga6djYRbo?=
 =?us-ascii?Q?ENr8Eh/u0AbM27gpVpwN+Uv+DAOwiPv7Sx3B+5sQI3b62U6R3tBVOOS21916?=
 =?us-ascii?Q?Or4X0M8eImvYI8fPFCvFR9f/B6PmIwI/AJ4y2XsCgr4o7eNLrztrwg0U+jWn?=
 =?us-ascii?Q?mn/dLzn6Hxz80xMaQpyW12+4wiQujlxuYZBay/PH7lbPFvOQjh/+TK91TIs1?=
 =?us-ascii?Q?ZQpFGO+5212KqnQLHt6Y27in+UXsp0Xsx6HavUdLQ0gDoIx9G4Qq4lJZ0m09?=
 =?us-ascii?Q?5jqOCOp2JXcJ/P/BdMRrhPbYSlvVXF8XY1A0vPs3au/DNBrM7yYYkn//NptB?=
 =?us-ascii?Q?T9F7wD1CtcBx7xaqmC5lNhg1gIYJybWjxlBCBj+VIDZwQrKknYOxlc2JlDqd?=
 =?us-ascii?Q?c5grO732VPQOpTqoScjOtZR+xgdzVlNuanqe9paVcfn3VMK8ETv/Ri7aT9ft?=
 =?us-ascii?Q?BA4jCZDuaA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cb8800b-91a4-403b-7059-08def8ad9cec
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 20:09:28.1100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mRqbO8pXH7w3pOVoVXsrgxpdqN/XholNuhbsxUFiwlDMa6Ri7ytQvyRAHs8DRflw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9629

Some of the tests configs can test features we don't currently enable,
like TTBR1 on ARMv8. Instead of blowing up, skip the test. When
CONFIG_DEBUG_GENERIC_PT is set all features are force enabled during
the build so everything can be tested. That is the normal mode for the
kunit.py runner.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/kunit_iommu.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/iommu/generic_pt/kunit_iommu.h b/drivers/iommu/generic_pt/kunit_iommu.h
index 79d7f9c8e7868f..558e161eacb05f 100644
--- a/drivers/iommu/generic_pt/kunit_iommu.h
+++ b/drivers/iommu/generic_pt/kunit_iommu.h
@@ -134,6 +134,16 @@ static int pt_kunit_priv_init(struct kunit *test, struct kunit_iommu_priv *priv)
 
 #ifdef kunit_fmt_cfgs
 	priv->cfg = kunit_fmt_cfgs[((uintptr_t)test->param_value) - 1];
+	/*
+	 * Without CONFIG_DEBUG_GENERIC_PT only the format's compiled-in
+	 * PT_SUPPORTED_FEATURES are available, so cfgs requesting bits outside
+	 * that set cannot be tested.
+	 */
+	if (priv->cfg.common.features & ~KUNIT_PT_SUPPORTED_FEATURES)
+		kunit_skip(
+			test,
+			"cfg requires features not built into this format (enable CONFIG_DEBUG_GENERIC_PT)");
+
 	/*
 	 * The format can set a list of features that the kunit_fmt_cfgs
 	 * controls, other features are default to on.
-- 
2.43.0


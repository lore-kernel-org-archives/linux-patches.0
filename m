Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011024.outbound.protection.outlook.com [40.107.208.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADF76FC3;
	Tue, 20 Jan 2026 00:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768868397; cv=fail; b=p7sst58UrRTRtMHvX8PLTjv5ngvQrlsu9Gsw+3Lds9x9bjcly1yVGot4Twj6d+H82Dy1TYF9NdJGXggUfyMxHKCqWCQMFbg40yf3t4dlZOxtU1BaOzh9Q9NAoL7XDEOgLOm1dJixIfr+gA4fMETxyC2v0xs+2AJQycFm6jqvaN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768868397; c=relaxed/simple;
	bh=KEZUCl/nLVDzGSluFMsN4Jntih3MQ6j1638DiAusfGY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Ft1tbF0vGSmaZYFX+2R5plqri2FOKId8d7AD8vPXdFnBEgKJ2htn5ZaL38GxXb4w9ZtCr+ll6HEYI2QdNnG9SwwcBwdUAW3Ce/OmB8+OF5RbeYyHklKPBrpSgBq2u2YiL4X1TuMUVDl54M9i0jNeBCVuKEdUMzJ8l8jdCLuOpjY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nO7rP7Hx; arc=fail smtp.client-ip=40.107.208.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nO7rP7Hx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OlN5P6NA9vaKEWYbLLnvII0zXb1epbi0nP2GcolFxzCkbHMiXLK9lJhrM9Va+7GCGODwrWEpwufVFiJtA/EaIiCXLUp9wsvtWlvJT/KR81HjEbWkBn2+gGiyufaF/SAB0Wo0pKDarjE+V644MmtloDkqc5KzSl2O6JxR1xUf3hF9QK9wnQKre5zQ3RX8FyShI0KFpmTFSHlYWtORVwbeH9yoYV3iHZXncpU2PIQTYQ57y/jWNEa2do6iUlAimCSCPCV3VmrnYnViHkFwJeddx2bb1KedFBGbLu8wxV62IS4GxzmM55BlUTxd9xO13UI7nb4r5moEg9Kg+5SC0I1Z8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q0AwB1UQdRIGecXaAF7HnorWL4tbJVQ+nEOvAc0npJ0=;
 b=omNNNjwUHdwTeV4WiNw1Tri0hxh4/So+pKzyidtBa8Xm9rBV1Tsn52sQc9WyG/pOHoDfpf85PcoKMO0D1/eLQg8/B3EaDKpK7lcMMYsgaZOqZDoXFHplv5gRsLCKLXUnZxTb51Ln9q5y7iUbAGWhX0GrV+Dm2771et+5+Um+PCA/RHTgLZOu4cXpqObbHJrZrq8t7BBL653LOHyN6lIUE6V0tNZgzcvFoF2SdgwIlj/P4HLTgDRbIeWuxKwEggKa8uJvdE8TuP6/lpO4BhWvm5tgHvgG1aj2Of/nmHWQ/H4r3ORSHrexRltOPaTaaDvp7hbjXxvIOy3eqRTpZ4CUwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q0AwB1UQdRIGecXaAF7HnorWL4tbJVQ+nEOvAc0npJ0=;
 b=nO7rP7HxLsHblLx1WYnXqthis5hunjrIjg4obkWH5fix52lnGZ+Mnpm0gghnY8CukuG85tOs2nqzH/fDPGz76W+itDVsTnITwiglQZ8XlEvnwhWO+uTnjQWxHib5Vx1y5qokJbcRjymkxDIt0vnJTVxYphWtTUMNk5eQIVizCl4+GylIohfJ4GtaIaX9m1hGaOD8iQHZuR2KGoOCN3Mep6COKWrL72QRr2I31PKW2sNBohpYUZr+pVOzQDPyYKkKfq+TYMZ/9yNA5kfFwGnoHcGVJKB5X/5t5CjmtaKhgjbfoOqIDFgssJK8tPmxB1EXCOiIqeujQLrDjV7W+TtMfw==
Received: from MN2PR12MB4142.namprd12.prod.outlook.com (2603:10b6:208:1dd::19)
 by CH1PR12MB9672.namprd12.prod.outlook.com (2603:10b6:610:2b0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 00:19:51 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MN2PR12MB4142.namprd12.prod.outlook.com (2603:10b6:208:1dd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 00:19:50 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 00:19:50 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Justin Stitt <justinstitt@google.com>,
	llvm@lists.linux.dev,
	Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Chunyu Hu <chuhu@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>
Subject: [PATCH rc] iommupt: Make it clearer to the compiler that pts.level == 0 for single page
Date: Mon, 19 Jan 2026 20:19:49 -0400
Message-ID: <0-v1-5b908a8b789a+838-iommpt_single_page_const_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::18) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	LV8PR12MB9620:EE_|MN2PR12MB4142:EE_|CH1PR12MB9672:EE_
X-MS-Office365-Filtering-Correlation-Id: ef01fce1-6384-4004-fe8c-08de57b9a012
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/IxrClhBeUOX6O/E2oYtlrM8cRiDZdftK+Ddkg3cLfZqtxKXwpBTaMBECpOs?=
 =?us-ascii?Q?w6gRVAIBdLWyhbdm8iTTsI/+TXGxKIzNZMxObpadzUPvU2KRNsprFOY8VyEE?=
 =?us-ascii?Q?5RPYX8vR66hZCSsjZKR1Q7W3F3EZaJKNQBRoUXeOkcCFV7bhLst8eimvNgEY?=
 =?us-ascii?Q?2G2dWjvZNyknVP2AKQgUvdS2CeUR3LQsWzTygMx//0iHnberiMViDOfOAv82?=
 =?us-ascii?Q?G3QhnmeJMTVY7ax9SnsZrg3GaBlW0Y0aUQeE6qdOjY0yNmopPIeS/8yixTt3?=
 =?us-ascii?Q?+CDYjFKx+HXxcuCIF34qjetVwGS1/RuX/f5W/6n38kiDAAHvBg8VSeSk62lT?=
 =?us-ascii?Q?Lki2RNaYwlvQmkH5dCkeJy9kIOH9j424mjW3GDVN+pFWu/8wj0FNNjUtgjra?=
 =?us-ascii?Q?xh2sAT4M3/ZVZsgsX9FMEiccvXcadUB5WQbxgNbVP/SeKjmpFTaEUxX/ZD8q?=
 =?us-ascii?Q?cM+Pju3juRDCcsO1jznO1BulVHUuMe2VjD66JMfEKVpvw/g8A/GXdaaCdxk9?=
 =?us-ascii?Q?2qaAB/u7gM30VXFdo6rVOy18xbCqR052vCgZKEpxKmmsNpTMoEr1Viz86fVs?=
 =?us-ascii?Q?n8f9nyyZVplugqRO5hQvcoKhi/C7X9qEWH1LUIOvEfKE6w/Uls8vXAbbm9Dp?=
 =?us-ascii?Q?CC2x1g46nVmNes20fctjPF58NeGuvkXGGFFfQJDFO3zo4KKGxBBNqRe4SGkT?=
 =?us-ascii?Q?ZS9D155TP4TQV+d5EIUL58ygLBdDH8vXD4ueHiB/88cWUKoW2T0V+IuDE/SW?=
 =?us-ascii?Q?L4NZnpZRDjCkQ8c1g1o9drR4C9jyzJ5331vcM5xmLzlT47ohf6BWrijet2tI?=
 =?us-ascii?Q?tIR5+xUpV3V2Z6nH3ICvXCKRX+MbdoZ+Cx7UopbAtSeWKHdOngLueZUbeJIM?=
 =?us-ascii?Q?Av9d9CmBv5/ZbhpR0PTXwJogNTg0JLZ0OtTjcAcpzDUs0+3OruYWrNNKG9P1?=
 =?us-ascii?Q?mNt4trsjwFgFJ95+s+41MvYWFrxcnMpMK9czPcpNDsLPqzf3bKSgmVsYQV0j?=
 =?us-ascii?Q?rqNSgVXfZbEObwr5NfCa35hKAf7ndK2oRWfME+/6o79EeRkec05dOl3QhAJV?=
 =?us-ascii?Q?oiiMW50EU/W1HxE1DzRTJJy69nBuxHkUWiPYjHz9x88v4A226nq5Xyh/bZOh?=
 =?us-ascii?Q?oEdgJ+a9jJQEXa4nDoDEygA+iCVuAZP0sTp6nF/jndUqWtaXfvQfVT4gF6fW?=
 =?us-ascii?Q?rbKViOj+xVoQh0kDRmB7xZxZFajjg02ade8GZUFkhNiZlwcMRLPLC3AoTN5t?=
 =?us-ascii?Q?sEiocOXZylCsm+ibixyTVa+aqBGdp+TyUvu+wvSLFUOE6DyhAZmqt19OYMj5?=
 =?us-ascii?Q?RG2sjQAWdqqcdgkyFiGTEbQlBIdm0WyB+Bv4bDmW+5ODxh8Ba9DrZQR8fs6O?=
 =?us-ascii?Q?+xV5ggJhM04rm7W+eyW3tTV1LA/qsYd+FW2KYz7bXwnansP9q5JZvlNiK6yE?=
 =?us-ascii?Q?9MJiwkdScpJEUXLP4wumy0m0OMwDxbI+WnxXRhd6mkP/B5FkwtI4cwzR7A8M?=
 =?us-ascii?Q?YSN03FsW9/lejIQ/xj72hGDuIXoDkpHUJUc58yaHCckNBe59IUpMmXlKT14q?=
 =?us-ascii?Q?eN4yJHJKM6/z8L8GWuU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4142.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sgMqEdh912rX51As+p7drhFVPoPwhx4h/czgFYw44vtoBZcqze417tOVdGD3?=
 =?us-ascii?Q?gIXix3ly9/kr5JSbkPPni5D3ny+V7ZONTkC1Q9jSXkTYUuVgjB8SdQsTcebN?=
 =?us-ascii?Q?be8gcwaBlbSfXKG+SN9giAkpWUfdr4xNKgJf6oTtJphKNpHB64wOpG2g1K95?=
 =?us-ascii?Q?8i6OEURjohpBqrRF/fu59wOCvD1RdCCZns4FmATqUc1wIwx5dQ9h3vYWgvSC?=
 =?us-ascii?Q?GcAACPdaxIgTyH78WF1UoitIaO6JY4yzrp8YNBNECY2iYp91WO07PuNr+rQr?=
 =?us-ascii?Q?vy3Trbnm2mSRIkDZJG4q6IUjhVKQGhZA+bEkKiEvHfJI8DMYjC9+S9c9+afQ?=
 =?us-ascii?Q?DhFzA8MhNrzxnmsZtQvqm8JE+HJZN0Qq7IdK6gk99UOSWiqYlmfq/JltxnXI?=
 =?us-ascii?Q?ZE0FrlrhfrSghKQKGKpvixo72HjpCTrKkOE7vpX2CrrYfeLcfjVVIEG5S8xt?=
 =?us-ascii?Q?FWW8HFRNwYYVJp/qNepNN6dedR41kkMGTCQbR93cMbC9mvq5xFgC6sfw/D2p?=
 =?us-ascii?Q?MhnT/Ut5BUdI06oIry1+ImDn1F0X/mKLl28We1kZqFY9dZjfBiDRjQknsiGM?=
 =?us-ascii?Q?3wcUHoWFuyYPV+q7CHY8+QEdG4DiFgDICxJun1IZM8KdM94Kyc6GjdUEa8Vp?=
 =?us-ascii?Q?V7a+Atyhj09GJjg8mwTx0yKNjyto0gRib57T8nEkWVndcatSmyer2NgVooXZ?=
 =?us-ascii?Q?eYYWbfSyk9YXEGq9eJSJnof/rXDUKDkbYWOnOwszQ2uDNp3l+QWXWBAwSNLr?=
 =?us-ascii?Q?tZiS1mi/Oq1ps2w1dSEOGFT9unl7Er1a8GSwIisW2Hjjobd2lmwdgN7+CTFW?=
 =?us-ascii?Q?NP3JpxAxyrbb/fDg4CQ80JPjcfFQgVbG3l2Wrr2N6UeqK6UHegWMf49Qr39S?=
 =?us-ascii?Q?VgnAHUkR+JY865b6zhU3OvTVkWB/n8fyG46du76Jkwc4MhlrVfhm2zNjBJ+g?=
 =?us-ascii?Q?P+uJC0jmL9MiPBj5502g1+z0gvCAjnqmU5uvhL0DeNbBlHz1jlMc+Tr88xxc?=
 =?us-ascii?Q?OPbyS4c7SAlzEEfLTA5qJlYWKLqo8alw0PE5nNumOYqDbgWh9GjEWlQea2bB?=
 =?us-ascii?Q?tWOdS/3ZTAw9ZTF6lYmDmyYwwC/NXmibvJ+nKLowJUPS7ZsXOgP+It+3fq7F?=
 =?us-ascii?Q?iK/mG918n0ivo7zPWkixcNUCg24zQx3nSfWeqkgPuRMPRVaV9wABQof0bsH6?=
 =?us-ascii?Q?gM1K7kfba9PUuAkoWcQi0H8bMTsoHmuLJTSAllgCr33vqsnmatc9EqAWsZkO?=
 =?us-ascii?Q?zY/i80L3UT4/0Tj/V0DbOjOtWatBJ8ii6Jcoc/C7hUAtIHpr++r6LMbNVXMy?=
 =?us-ascii?Q?ynlpUlr51T2llz9s3sKKOo89IQk+TdutJq2Y6rZLMF6qt2p+keAMm3xayFAH?=
 =?us-ascii?Q?N8DH4j60nHCzbDacoAV/DRALuSuLmDtzCv1QrDK5n5VCu+Qp76GLDnq900KY?=
 =?us-ascii?Q?IifdeHMiqoSeGSVAVna3iZqJUIUKFh7cVIZk/aXMzgjTEHuiX5qN/44z2yJ9?=
 =?us-ascii?Q?r0fbk5C/+c4fp7jOYcX2NvfIGs4Cx4LoO9qC60JFu4RVlpGXX0/M2S+DpQ85?=
 =?us-ascii?Q?uKiNdJvBcsZzuawxU89WVVwl1VJM+B43VEK8ZY8OqHaKpCrU8XVHy9Wr6qmh?=
 =?us-ascii?Q?3KJCbM2SP4sc94KKNB/oUZvSl3so98h3nhjdSzBhd+J4byUKeRx1NY1ZKNRa?=
 =?us-ascii?Q?YMm/5MkdzSus5eiHq1dex9x5iUB5JxOEy9UAflgTscEU2een9P9Mg829vb1k?=
 =?us-ascii?Q?MXtSDIUfbw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef01fce1-6384-4004-fe8c-08de57b9a012
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 00:19:50.0577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QEIv6/azcgVI0bwp9rIu41Rcv4/UivFRk5zTqjzHDKF0EgkbFzFMpbDTjya00tKe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9672

Older versions of gcc and clang sometimes get tripped up by the build time
assertion in FIELD_PREP because they can see that the argument to
FIELD_PREP is constant but can't see that the if condition protecting it
is also a constant false.

   In file included from <command-line>:
   In function 'amdv1pt_install_leaf_entry',
       inlined from '__do_map_single_page' at drivers/iommu/generic_pt/fmt/../iommu_pt.h:651:3,
       inlined from '__map_single_page0' at drivers/iommu/generic_pt/fmt/../iommu_pt.h:662:1,
       inlined from 'pt_descend' at drivers/iommu/generic_pt/fmt/../pt_iter.h:391:9,
       inlined from '__do_map_single_page' at drivers/iommu/generic_pt/fmt/../iommu_pt.h:658:10,
       inlined from '__map_single_page1.constprop' at drivers/iommu/generic_pt/fmt/../iommu_pt.h:662:1:
   ././include/linux/compiler_types.h:631:45: error: call to '__compiletime_assert_251' declared with attribute error: FIELD_PREP: value too large for the field
     631 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
	 |                                             ^
   ././include/linux/compiler_types.h:612:25: note: in definition of macro '__compiletime_assert'
     612 |                         prefix ## suffix();                             \
	 |                         ^~~~~~
   ././include/linux/compiler_types.h:631:9: note: in expansion of macro '_compiletime_assert'
     631 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
	 |         ^~~~~~~~~~~~~~~~~~~
   ./include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
	 |                                     ^~~~~~~~~~~~~~~~~~
   ./include/linux/bitfield.h:69:17: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      69 |                 BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?           \
	 |                 ^~~~~~~~~~~~~~~~
   ./include/linux/bitfield.h:90:17: note: in expansion of macro '__BF_FIELD_CHECK_MASK'
      90 |                 __BF_FIELD_CHECK_MASK(mask, val, pfx);                  \
	 |                 ^~~~~~~~~~~~~~~~~~~~~
   ./include/linux/bitfield.h:137:17: note: in expansion of macro '__FIELD_PREP'
     137 |                 __FIELD_PREP(_mask, _val, "FIELD_PREP: ");              \
	 |                 ^~~~~~~~~~~~
   drivers/iommu/generic_pt/fmt/amdv1.h:220:26: note: in expansion of macro 'FIELD_PREP'
     220 |                          FIELD_PREP(AMDV1PT_FMT_OA,
	 |                          ^~~~~~~~~~

Changing the caller to check pts.level == 0 avoids demanding a bit of
complex reasoning from the compiler that pts.level == level == 0. Instead
the compiler sees that pt_install_leaf_entry() is called with a constant
pts.level == 0 which makes it more reliable to see the constant false in
the if.

Fixes: dcd6a011a8d5 ("iommupt: Add map_pages op")
Reported-by: Chunyu Hu <chuhu@redhat.com>
Closes: https://lore.kernel.org/all/aUn9uGPCooqB-RIF@gmail.com/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 22bae5bfeb0bac..f312748a7d7a61 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -697,7 +697,7 @@ static __always_inline int __do_map_single_page(struct pt_range *range,
 	struct pt_iommu_map_args *map = arg;
 
 	pts.type = pt_load_single_entry(&pts);
-	if (level == 0) {
+	if (pts.level == 0) {
 		if (pts.type != PT_ENTRY_EMPTY)
 			return -EADDRINUSE;
 		pt_install_leaf_entry(&pts, map->oa, PAGE_SHIFT,

base-commit: 201f4a415442013279570ec8fd0540b367fa223e
-- 
2.43.0


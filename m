Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794785455;
	b=5r9VU87xuicidYSAGgDXZj8ZcOSt3YxgCV5EQGbHcuZ2epGZMA42OHDv15Qix+g9eThz
	 oPq9Ha/KpydFlaQkT/J3fcz/lqIg1d5BtH+HXmb3yi5Ff8nfv9e7WzolSjhspzUY25Nkf
	 Ukuk5h58IgVDLgcKM+W5HXlMCBDzw4EYeTNkh79Ne6wjX1SfD9HhNROWii4h6ImaTHBPl
	 DF33036/QbIC3VTwcsgMAOsAwSiEK6I1hwviIXySEi5cn9tzyBa++ZMnBttcUmdpycgkh
	 nWfXmo1LGfwLGqAnPrmUIdRW9ZMiCTxDRpqrYdVx90Q+olTfvKX6h3rHJhHpsC5lyTg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785455;
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
	bh=qa1bbWwFFYNeAkgTOT0JsTwqzI80KR2hJjoElilyyws=;
	b=b1BwFiWFq66awO64Na/L3cARtNQqcibnvBe8JMs22XSVC7gea1NUPbdfyWYsHUwRMeGp
	 crqCLz6sLTFlXU1Mvb/P295dN34rDep6/x0h8T+I56Yk5cHJGgGfUknoD88woSMev9knU
	 DC2DePl+zC40Myv9EPdXKnv5KK3+JMpLNpEay92r0P3C0BJEx1YEAE7T6pExVfiJxW7yM
	 aIHKuQQsu6js4X6j+Rh5bkLoG7q5EzyaLnIqLIUbFSza0mGOL/HzF/5hy4pfb1GrVPKxC
	 XMHJ8Eu1gwDoFiELGFsFvdkpbVfYS289vbF8sq5g/3rbaW8vEcuC2zY5viKBnLArhxg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qXumCq4d;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.51
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011051.outbound.protection.outlook.com [40.93.194.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA4B606A31F;
	Sun, 15 Nov 2026 23:30:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFA4B606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=qXumCq4d
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F0jpxT8YHPYIGbyNnXC77UJHordmG+j5DRufIfbI4BRGlI8f6GcLKt3GrN5aM92BjVLNE5HthJdIm3y56oIXSW6D+ZdpeBCEhcZTgbcwEdbwXImMh9g7Jd0QHNzdbIUNWECZUbr8rp2Oppo0Jt9JslceD0UaZQMLi41vMKAWJoK7mDCVb/pPTlqn9192T1XivtxeJXVFMQ5nP/s1/ovxdW0vv54v2nU9mVaFqeboSstY/LAUA2pk29pPzBJ3YudxK1mftPh/4I1zXWaSp9EUz4hoZVra9TBuBa5LmHLpz9QmNcr5ik90+d3SBrjqUMv2ebArrRcL2fIoRKQmNjon8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qa1bbWwFFYNeAkgTOT0JsTwqzI80KR2hJjoElilyyws=;
 b=D013Gj30KQWyVcHjnKxDkxDmclB5BmNMp/fYXzTk+WerQ5j0lGjQGr4Bq0xPv2EPCuk9S5tHS9i1clpy9UPQg14zIbeldRi8Mq0QY1vPjU8DH7icriUOmoUHeQMEtHXTjWKlw2ljoQKIBFJfjf4DoyJcyJsPgOSqi4YoholmwZQAl4W4EtTGTr2kJs5t20XUBZnY9X4xBtxo+d0M3fmMIUAwsCGU6Va7SDnfKX73OwX6NIgehrc73ZGpTfGuy73py9AI12X42OP3mvJ2pjL1ZoL3BvRGLogjH6IXoxN/Y/OoMxuVjPzF3yrWpojO/bInFBEB8VMmjQhn8R/CCRmzpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qa1bbWwFFYNeAkgTOT0JsTwqzI80KR2hJjoElilyyws=;
 b=qXumCq4delHYMvt2IRQzefDKBn41E6RFyI8FljX1wx9VM6smQXgWTyx1/BdGZ7xKoQkYWGPgMiVtzOyG9EQO2z7lBNMw4ienCk/ZCugUB+mcxb/WAyn7FcxUZyGEOELEbW60tohn+YwMlT7blgXpvBoztVOPT+CAzzgfMa5ALnbHrd/8GLNoe5hoNbJN2Vor+bxQ+v56rfZYa1kwCEEbb45g5RJdWsIpg7+zpsav0cim1ZinRuwJE+eaugKpvVSCxyaJWc4WQJYNKHWtAQqBQhibqvzsEqsmjC7cblOo2DSfCKSZkQq3tuJjfWT3UDS6ZZvoCpLt0IsQz6QR2GCfDQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS0PR12MB8815.namprd12.prod.outlook.com
 (2603:10b6:8:14f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Sun, 15 Nov
 2026 23:30:47 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Sun, 15 Nov 2026
 23:30:46 +0000
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
Subject: [PATCH v3 06/13] iommupt/armv8: Add the 64 bit ARMv8 page table format
Date: Sun, 15 Nov 2026 19:30:36 -0400
Message-ID: <6-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0421.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::6) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 4d4f728f-ebda-4293-a349-08df437078e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261022113327099003|261022105027099003|261022075727099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	zfoFJYSaDp79UG/ijIJSqmAcVvX9qD/AR05h0yXcQVVl3rMA87I+fQON9QE86cXEfI85F+ZMKEAatnIfecGKJrJJ7QX2QfZTmzG4J2PiWKqwCMT2Wto7B0xG/ETPYhW6TGMTpsYUIZbX8hRSj6l+Ai44C5YdCwdiMFdCNUgjVw1W9+vhdeFxHMH56zA8Z/NToY9GYt2IaOIxnWpfwCpk5HabvDpWPCo0umQNqxMmVBJNIZjxHNMvk5Gw7/WkNuvoHhEAltErWX6fH54spotsVaq518O+AG3LUeEr2MIGODBCDBj7x2FRqScKI/SYLgZ4Wo2d5uUWFH8h//ttoUXDsCl9luOHBDxR48mpxO2lJmbMUcuv8BVTo5ZbnAAdlnbwX/dYQwEf7jvOKWv5vIb24cixK2L03szYxI2Fwr79zn9u0nJgyyStLtlT27TBy5ZRsmTu94hPL8m9fA1av3KW6xuNLFg5IVS/OJpmYecPdScMlQxZP7hexTNfDpWY0j8iHXwRnKsTd+oVes6A+2VJ7ycRyH5wOIeRRpzEYWEqr8ENs0dyqihKleeyJUxtwCArYUufHX3MNo4B6+brKVP9oGa6rNleSAyGztdM6Rhy7l4Asm6Xpap2gbC95mqJrBZH6v36Vjm+JXS0ku6dd6iDJUyxPl3FFOB/Vgl7iX6cGx8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022113327099003)(261022105027099003)(261022075727099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?anQbwOm1gIBb1sTtSZzvP2MbW1dbm5JjHWXfOaff6hSZUUv1rU0S1BXf0Rx8?=
 =?us-ascii?Q?FNKstk1W5CoCP8D7ume3pIAB4QqMj2djqAx6p0uck/pRTGtR4ctmkBivgsTw?=
 =?us-ascii?Q?Xk/d0Tjxk+zloKV96QSfXfRKhewpcpUT741PwNhyag/MaVQ5q0kjMcqn7oxF?=
 =?us-ascii?Q?mlq4La+6ZFsofTmaDvvgEQZP4YqLIfMYKN9K4mvHwyWlrH5QnaQAhppCz+oq?=
 =?us-ascii?Q?bHsGcgxJ7FbXl/WbyOn010rzKdDnb8EtmTL5MB1w923Si4EeRqwF6XhVwYBS?=
 =?us-ascii?Q?0xP05MY/KqA4c4zCPTD4fnoRrFR5yhZoXjAR9opJTqRiytTenxfoht7Tl6K0?=
 =?us-ascii?Q?VjXmI/F49pWYSVldfseVQjSx8+caw94n4/Q7R0BaVuovozqyWAho9utFlLe/?=
 =?us-ascii?Q?n1dZostJkNASstKzOgPlW6eX8QChKHVoQas4iOddg58J4+RFi44GmQ8ng/67?=
 =?us-ascii?Q?46UEwTgKOdyJc7+Xhof+J2eRFH71UivQvRIG9AVBoc4w8uJwe0GNIUAGyn7H?=
 =?us-ascii?Q?u6kqrjR7RTm/YpbXGoAda1nYbGEFaDGqxx6OcGbYlIz8sOpnjhMUEo1qzr2x?=
 =?us-ascii?Q?3wae7p7GFJYAdsJ5ZF/hEVvcVBKwLFNjsGtobbbf27Dk/j2MZ12DWhfAFs52?=
 =?us-ascii?Q?cNBYPnrSshJXBfojH+3mdmv95Oou8LcayVHXbTLiClyk8I9C2JzdIMgBml5S?=
 =?us-ascii?Q?m7o9eT29eKG+J3dJxaHP1FwgrioSH+ns9VhHXhRS/rayEBhDoqKpfowKqfMC?=
 =?us-ascii?Q?nHRwm2vCn8n0htwG85lELAPDjiB5LVOd7hGlj8Lvvddt9UYXmYff9vSJzSBr?=
 =?us-ascii?Q?CQfkVpPxv3YUEC0MKEKK5Ulz+EnMVZWIYQZ1az2gymt05VPrOKJexWNpa24d?=
 =?us-ascii?Q?uxapi98XgjPd6J8G2t3DlXW+oCArYHMQOBQRv/nnO6xlrWYU/PbULg0NjYwt?=
 =?us-ascii?Q?cuNX16lEIfdbo+J+x9/3tBU6ONjy210PhfL+wAXV21UoFT98L+9+BTeYV7rz?=
 =?us-ascii?Q?TPaiGsMiiUl7OT2T0sEotCg+Qu4weP1Yr9VkkzmEwKqfG4BLF8fDKLEhmWkv?=
 =?us-ascii?Q?xfyOA4ftGQs/BQJK1IFbJC7bed5EXxH4Kr65tUeiB8Iatj42Sbd5hxSjiXfN?=
 =?us-ascii?Q?PXNsA4OiazsW3cgz5Jg5ROz8xSQkXwtRpkGUfVQT3R6ZbejzO9Vr9lil57TT?=
 =?us-ascii?Q?wqdBJWU6U1XftQJ2jZO4KFAhtCRDGtHC5F5hDDQvlbsQChRqY7w9QjW0rW3+?=
 =?us-ascii?Q?T9Kr7XSe5ZwATok3Sk3lueBo6CMp7XKP5lXgm3aP505OiJz0XXW3Gvm1KoFc?=
 =?us-ascii?Q?qybcOyOLlBGIxzCqvHzrzwHN5FWX2ybPknB8ThuqBc0p886rhOkYSMP3euCX?=
 =?us-ascii?Q?hLv4M7AcTLYXNMk2DZcOkMiERmP3JbXnnBmWgesMgwqA/uIG465lkiQ2ctrf?=
 =?us-ascii?Q?yWuyYaf2zPokOu/5r5d76HO4Kg8aEFUWON0r/DiXzoTaXvNYnd3fsWKf0UFV?=
 =?us-ascii?Q?gptFkZxOsE5a3vGYoqSnFREcpXR0iLce5Sy80JURHqz9bUTz5Pn8p/kdWsT6?=
 =?us-ascii?Q?D/LsIzjco86EjJUp0EoeSN67Hye/K+16BgZpUvnmPimOagSGqXSeDEO4M6dl?=
 =?us-ascii?Q?+WJXhzunooXf6fYqC0xkjRitwav7ZQetSYJLAp7h/HBdgY/bg4elrCG1LyqE?=
 =?us-ascii?Q?lpEa78OQ6VyokXhCG+53lY1R7fEpnpK5yY1QKyTx8RmfzSj1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d4f728f-ebda-4293-a349-08df437078e7
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 23:30:45.5471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QLcKqcDwX5XZ0DUSACHhXq2T6Xn28hYctyfNOSBEqTZkSI97qhFHi9WqhF0rHpob
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8815

The features, format and naming is taking from the ARMv8 VMSAv8-64
chapter. By far ARMv8 is the most complex format supported by generic page
table, with the largest number of options and configurations.

ARMv8 uses almost all the features of the common implementation:

 - Contiguous pages
 - Leaf pages at many levels
 - Variable starting top level
 - Variable size top level supporting concatenated tables with a high
   order top table allocation
 - Dirty tracking
 - Low (TTB0) or high (TTB1) starting VA
 - Software bits

Compared to the io-pgtable version this also implements the contiguous
page hint, and supports dirty readback from the S2. It always will use S2
concatenation to avoid a table walk instead of only using it when required
by the spec. This closer to the original io-pgtable version which tried to
use it sometime when not mandatory. The cost is an increased case of high
order allocations for the table top. When a S1 is supported by HW only
VFIO creates S2s so a high order allocation failure is OK. If S2 is only
supported then the iommu core will perform the S2's table top allocations
during early boot, and that is OK too.

iommupt's incoherent flushing algorithm was modeled after the ARM
io-pgtable version so there is no change here.

Additionaly it includes implementations for the LPA, LVA, and LPA2
features however they will be compiled off for the iommu build until a
driver actually needs thems. With these features it can support the "level
-1" to produce a 5 level table similar to x86, as well as all the
different placements of OA bits defined by the spec.

This is supported by a compare test that creates parallel iommupt and
io-pgtable instances with matching parameters and validates that every
tree level is the "same" across several meaningful tests. It covers the S2
concatenated pages, the recent bugs found in the io-pgtable logic and a
range of VA sizes.

Add the generic page table API component and generic definitions for
ARMv8.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/fmt/armv8.h      | 485 ++++++++++++++++++++++
 drivers/iommu/generic_pt/fmt/defs_armv8.h |  23 +
 include/linux/generic_pt/common.h         |  36 ++
 3 files changed, 544 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/fmt/armv8.h
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_armv8.h

diff --git a/drivers/iommu/generic_pt/fmt/armv8.h b/drivers/iommu/generic_pt/fmt/armv8.h
new file mode 100644
index 00000000000000..68fedda41fc198
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/armv8.h
@@ -0,0 +1,485 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024-2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * The page table format described by ARM DDI 0487 L.b, Chapter D8
+ * "The AArch64 Virtual Memory System Architecture" (VMSAv8-64).
+ * With the right cfg this will also implement the VMSAv8-32 Long
+ * Descriptor format.
+ *
+ * This was called io-pgtable-arm.c and ARM_xx_LPAE_Sx.
+ *
+ * NOTE! The level numbering is consistent with the Generic Page Table API, but
+ * is reversed from what the ARM documents use.
+ *
+ *   generic_pt | ARM | 4K TG          | 16K TG        | 64K TG
+ *   -----------+-----+----------------+---------------+----------------
+ *   0          |   3 | 4KB (64KB)     | 16KB (2MB)    | 64KB (2MB)
+ *   1          |   2 | 2MB (32MB)     | 32MB (1GB)    | 512MB (16GB)
+ *   2          |   1 | 1GB (16GB)     | 64GB       NL2| 4TB (128TB) NL1
+ *   3          |   0 | 512GB (8TB) NL2| 128TB      NL | -
+ *   4          |  -1 | 256TB       NL | -             | -
+ * Supported contiguous size in brackets. NL = no leaf, this level can only
+ * be a table, never a block/page descriptor (see armv8pt_can_have_leaf()):
+ *   NL  = never a leaf, regardless of features
+ *   NL1 = leaf only with FEAT_LPA and not FEAT_LPA2, otherwise NL
+ *   NL2 = leaf only with FEAT_LPA2, otherwise NL
+ */
+#ifndef __GENERIC_PT_FMT_ARMV8_H
+#define __GENERIC_PT_FMT_ARMV8_H
+
+#include "defs_armv8.h"
+#include "../pt_defs.h"
+
+#include <asm/page.h>
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+#include <linux/container_of.h>
+#include <linux/errno.h>
+#include <linux/limits.h>
+#include <linux/sizes.h>
+#include <linux/string.h>
+
+/*
+ * Aid for understanding how the spec numerology relates to the code. Note the
+ * expression "level > ARMLx" means any ARMLy such that level < x
+ */
+enum {
+	ARML3 = 0,
+	ARML2 = 1,
+	ARML1 = 2,
+	ARML0 = 3,
+	ARMLn1 = 4,
+};
+
+enum {
+	PT_MAX_TOP_LEVEL = PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LPA2) ? ARMLn1 :
+								      ARML0,
+	PT_ITEM_WORD_SIZE = sizeof(u64),
+};
+
+enum {
+	PT_MAX_OUTPUT_ADDRESS_LG2 =
+		(PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LPA2) |
+		 PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LPA)) ? 52 : 48,
+	/* See armv8pt_iommu_fmt_init() */
+	PT_MAX_VA_ADDRESS_LG2 =
+		(PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LPA2) |
+		 PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LVA) |
+		 PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LPA)) ? 52 : 48,
+
+	/*
+	 * D24.2.195 TTBR_ELx BADDR:
+	 *
+	 * Bits A[(x-1):0] of the stage 1 translation table base address are
+	 * zero. Address bit x is the minimum address bit required to align the
+	 * translation table to the size of the table. x is calculated based on
+	 * LOG2(StartTableSize), as described in VMSAv9-128. The smallest
+	 * permitted value of x is 5.
+	 *
+	 * R_KBLCR requires the table to be aligned to its own size.
+	 *
+	 * SMMU S2TTB additionally says: In addition, a 64-byte minimum
+	 * alignment on starting-level translation table addresses is imposed
+	 * when S2TG selects 64KB granules and the effective S2PS value
+	 * indicates 52-bit output. In this case bits [5:0] are treated as zero.
+	 */
+	PT_TOP_PHYS_MASK = GENMASK_ULL(51, 5),
+};
+
+/* Common PTE bits */
+enum {
+	ARMV8PT_FMT_VALID = BIT(0),
+	ARMV8PT_FMT_PAGE = BIT(1),
+	ARMV8PT_FMT_TABLE = BIT(1),
+	ARMV8PT_FMT_NS = BIT(5),
+	ARMV8PT_FMT_SH = GENMASK(9, 8),
+	ARMV8PT_FMT_AF = BIT(10),
+
+	/* 64K FEAT_LPA: OA[51:48] in bits[15:12], Figures D8-14/15 */
+	ARMV8PT_FMT_OA52_LPA = GENMASK_ULL(15, 12),
+	/* 4K/16K FEAT_LPA2 (DS=1): OA[51:50] in bits[9:8], Figures D8-14/15 */
+	ARMV8PT_FMT_OA52_LPA2 = GENMASK_ULL(9, 8),
+
+	ARMV8PT_FMT_CONTIG = BIT_ULL(52),
+	ARMV8PT_FMT_UXN = BIT_ULL(53),
+	ARMV8PT_FMT_PXN = BIT_ULL(54),
+	ARMV8PT_FMT_NSTABLE = BIT_ULL(63),
+};
+
+/* S1 PTE bits */
+enum {
+	ARMV8PT_FMT_ATTRINDX = GENMASK(4, 2),
+	ARMV8PT_FMT_AP = GENMASK(7, 6),
+	ARMV8PT_FMT_nG = BIT(11),
+};
+
+enum {
+	ARMV8PT_SH_IS = 3,
+	ARMV8PT_SH_OS = 2,
+
+	ARMV8PT_RGN_NC = 0,
+	ARMV8PT_RGN_WBWA = 1,
+
+	ARMV8PT_AP_UNPRIV = 1,
+	ARMV8PT_AP_RDONLY = 2,
+};
+
+enum {
+	ARMV8PT_MAIR_ITEM = GENMASK_U32(7, 0),
+
+	ARMV8PT_MAIR_ATTR_IDX_NC = 0,
+	ARMV8PT_MAIR_ATTR_IDX_CACHE = 1,
+	ARMV8PT_MAIR_ATTR_IDX_DEV = 2,
+	ARMV8PT_MAIR_ATTR_IDX_INC_OCACHE = 3,
+
+	ARMV8PT_MAIR_ATTR_NC = 0x44,
+	ARMV8PT_MAIR_ATTR_WBRWA = 0xff,
+	ARMV8PT_MAIR_ATTR_DEVICE = 0x04,
+	ARMV8PT_MAIR_ATTR_INC_OWBRWA = 0xf4,
+};
+
+/* S2 PTE bits */
+enum {
+	ARMV8PT_FMT_S2MEMATTR = GENMASK(5, 2),
+	ARMV8PT_FMT_S2AP = GENMASK(7, 6),
+};
+
+enum {
+	SZLG2_4K = 12,
+	SZLG2_16K = 14,
+	SZLG2_64K = 16,
+};
+
+enum {
+	/*
+	 * For !S2FWB these code to:
+	 *  1111 = Normal outer write back cacheable / Inner Write Back Cacheable
+	 *         Permit S1 to override
+	 *  0101 = Normal Non-cachable / Inner Non-cachable
+	 *  0001 = Device / Device-nGnRE
+	 * For S2FWB these code to:
+	 *  0110 Force Normal Write Back
+	 *  0101 Normal* is forced Normal-NC, Device unchanged
+	 *  0001 Force Device-nGnRE
+	 */
+	ARMV8PT_MEMATTR_FWB_WB = 6,
+	ARMV8PT_MEMATTR_OIWB = 0xf,
+	ARMV8PT_MEMATTR_NC = 5,
+	ARMV8PT_MEMATTR_DEV = 1,
+
+	ARMV8PT_S2AP_READ = 1,
+	ARMV8PT_S2AP_WRITE = 2,
+};
+
+#define common_to_armv8pt(common_ptr) \
+	container_of_const(common_ptr, struct pt_armv8, common)
+#define to_armv8pt(pts) common_to_armv8pt((pts)->range->common)
+
+/* Runtime granule accessors */
+static inline u8 armv8pt_tgsz_lg2(const struct pt_state *pts)
+{
+	return to_armv8pt(pts)->tgsz_lg2;
+}
+
+static inline u64 armv8pt_fmt_oa48(unsigned int tgsz_lg2)
+{
+	return GENMASK_ULL(47, tgsz_lg2);
+}
+
+/*
+ * The generic implementations cannot be used if PT_GRANULE_LG2SZ is dynamic.
+ */
+static inline unsigned int armv8pt_table_item_lg2sz(const struct pt_state *pts)
+{
+	unsigned int tgsz_lg2 = armv8pt_tgsz_lg2(pts);
+
+	return tgsz_lg2 + (tgsz_lg2 - ilog2(PT_ITEM_WORD_SIZE)) * pts->level;
+}
+#define pt_table_item_lg2sz armv8pt_table_item_lg2sz
+
+static inline unsigned int armv8pt_pgsz_lg2_to_level(struct pt_common *common,
+						     unsigned int pgsize_lg2)
+{
+	unsigned int tgsz_lg2 = common_to_armv8pt(common)->tgsz_lg2;
+
+	return (pgsize_lg2 - tgsz_lg2) / (tgsz_lg2 - ilog2(sizeof(u64)));
+}
+#define pt_pgsz_lg2_to_level armv8pt_pgsz_lg2_to_level
+
+static inline bool armv8pt_has_system_page_size(const struct pt_common *common)
+{
+	return common_to_armv8pt(common)->tgsz_lg2 == PAGE_SHIFT;
+}
+#define pt_has_system_page_size armv8pt_has_system_page_size
+
+static inline pt_oaddr_t armv8pt_oa(const struct pt_state *pts)
+{
+	unsigned int tgsz_lg2 = armv8pt_tgsz_lg2(pts);
+	u64 entry = pts->entry;
+	pt_oaddr_t oa;
+
+	if (pts_feature(pts, PT_FEAT_ARMV8_LPA2)) {
+		/* 4K/16K with DS=1: OA[49:granule] direct, OA[51:50] in [9:8] */
+		oa = entry & GENMASK_ULL(49, tgsz_lg2);
+		oa |= ((pt_oaddr_t)FIELD_GET(ARMV8PT_FMT_OA52_LPA2, entry))
+		      << 50;
+	} else {
+		oa = entry & GENMASK_ULL(47, tgsz_lg2);
+		if (PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LPA) &&
+		    tgsz_lg2 == SZLG2_64K)
+			oa |= ((pt_oaddr_t)FIELD_GET(ARMV8PT_FMT_OA52_LPA,
+						     entry))
+			      << 48;
+	}
+	return oa;
+}
+
+static inline pt_oaddr_t armv8pt_table_pa(const struct pt_state *pts)
+{
+	return armv8pt_oa(pts);
+}
+#define pt_table_pa armv8pt_table_pa
+
+/*
+ * Return a block or page entry pointing at a physical address. Returns the
+ * address adjusted for the item in a contiguous case.
+ */
+static inline pt_oaddr_t armv8pt_item_oa(const struct pt_state *pts)
+{
+	return armv8pt_oa(pts);
+}
+#define pt_item_oa armv8pt_item_oa
+
+static inline bool armv8pt_can_have_leaf(const struct pt_state *pts)
+{
+	unsigned int tgsz_lg2 = armv8pt_tgsz_lg2(pts);
+
+	/*
+	 * Tables D8-16/17 (4K), D8-26/27 (16K), D8-35/36 (64K).
+	 *
+	 * When FEAT_LPA2, one additional level gains block descriptors:
+	 *   4K:  ARM level 0 (pt 3) gains 512GB blocks
+	 *   16K: ARM level 1 (pt 2) gains 64GB blocks
+	 * ARM Level -1 (pt 4) is always table-only.
+	 */
+	if (pts_feature(pts, PT_FEAT_ARMV8_LPA2)) {
+		if (tgsz_lg2 == SZLG2_4K && pts->level > ARML0)
+			return false;
+		if (tgsz_lg2 == SZLG2_16K && pts->level > ARML1)
+			return false;
+		if (tgsz_lg2 == SZLG2_64K && pts->level > ARML2)
+			return false;
+	} else {
+		if (tgsz_lg2 == SZLG2_4K && pts->level > ARML1)
+			return false;
+		if (tgsz_lg2 == SZLG2_16K && pts->level > ARML2)
+			return false;
+		if (tgsz_lg2 == SZLG2_64K &&
+		    pts->level > (pts_feature(pts, PT_FEAT_ARMV8_LPA) ? ARML1 :
+									ARML2))
+			return false;
+	}
+	return true;
+}
+#define pt_can_have_leaf armv8pt_can_have_leaf
+
+/* Number contiguous entries that ARMV8PT_FMT_CONTIG will join at this level */
+static inline unsigned short
+armv8pt_contig_count_lg2(const struct pt_state *pts)
+{
+	unsigned int tgsz_lg2 = armv8pt_tgsz_lg2(pts);
+
+	if (tgsz_lg2 == SZLG2_4K)
+		return ilog2(16); /* 64KB, 32MB, 16GB, 8TB */
+	else if (tgsz_lg2 == SZLG2_16K && pts->level == ARML2)
+		return ilog2(32); /* 1GB */
+	else if (tgsz_lg2 == SZLG2_16K && pts->level == ARML3)
+		return ilog2(128); /* 2MB */
+	else if (tgsz_lg2 == SZLG2_64K)
+		return ilog2(32); /* 2MB, 16GB, 128TB */
+	return ilog2(1);
+}
+#define pt_contig_count_lg2 armv8pt_contig_count_lg2
+
+static inline unsigned int
+armv8pt_entry_num_contig_lg2(const struct pt_state *pts)
+{
+	if (pts->entry & ARMV8PT_FMT_CONTIG)
+		return armv8pt_contig_count_lg2(pts);
+	return ilog2(1);
+}
+#define pt_entry_num_contig_lg2 armv8pt_entry_num_contig_lg2
+
+static inline pt_vaddr_t armv8pt_full_va_prefix(const struct pt_common *common)
+{
+	if (pt_feature(common, PT_FEAT_ARMV8_TTBR1))
+		return PT_VADDR_MAX;
+	return 0;
+}
+#define pt_full_va_prefix armv8pt_full_va_prefix
+
+static inline unsigned int armv8pt_num_items_lg2(const struct pt_state *pts)
+{
+	/*
+	 * It is not allowed to call pt_num_items_lg2() at the top level, this
+	 * API restriction is specifically an optimization avoid overheads
+	 * dealing with concatenated tables here.
+	 */
+	PT_WARN_ON(pts->level == pts->range->top_level);
+	return armv8pt_tgsz_lg2(pts) - ilog2(sizeof(u64));
+}
+#define pt_num_items_lg2 armv8pt_num_items_lg2
+
+static inline enum pt_entry_type armv8pt_load_entry_raw(struct pt_state *pts)
+{
+	const u64 *tablep = pt_cur_table(pts, u64) + pts->index;
+	u64 entry;
+
+	pts->entry = entry = READ_ONCE(*tablep);
+	if (!(entry & ARMV8PT_FMT_VALID))
+		return PT_ENTRY_EMPTY;
+	/* R_RWMFF/Table D8-48: ARM level 3 has only Page descriptors */
+	if (pts->level != ARML3 && (entry & ARMV8PT_FMT_TABLE))
+		return PT_ENTRY_TABLE;
+
+	/* Must be a block or page, don't check the page bit on level 0 */
+	return PT_ENTRY_OA;
+}
+#define pt_load_entry_raw armv8pt_load_entry_raw
+
+static inline void
+armv8pt_install_leaf_entry(struct pt_state *pts, pt_oaddr_t oa,
+			   unsigned int oasz_lg2,
+			   const struct pt_write_attrs *attrs)
+{
+	unsigned int isz_lg2 = pt_table_item_lg2sz(pts);
+	u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	if (!pt_check_install_leaf_args(pts, oa, oasz_lg2))
+		return;
+
+	if (pts_feature(pts, PT_FEAT_ARMV8_LPA2))
+		entry = ARMV8PT_FMT_VALID |
+			(oa & GENMASK_ULL(49, armv8pt_tgsz_lg2(pts))) |
+			FIELD_PREP(ARMV8PT_FMT_OA52_LPA2, oa >> 50) |
+			attrs->descriptor_bits;
+	else {
+		entry = ARMV8PT_FMT_VALID |
+			(oa & GENMASK_ULL(47, armv8pt_tgsz_lg2(pts))) |
+			attrs->descriptor_bits;
+		/* 64K FEAT_LPA: OA[51:48] in [15:12] */
+		if (pts_feature(pts, PT_FEAT_ARMV8_LPA))
+			entry |= FIELD_PREP(ARMV8PT_FMT_OA52_LPA, oa >> 48);
+	}
+
+	/*
+	 * R_RWMFF/Table D8-48: at ARM level 3 the leaf is a Page descriptor
+	 * with bit[1]=1; at other levels it is a Block with bit[1]=0.
+	 */
+	if (pts->level == ARML3)
+		entry |= ARMV8PT_FMT_PAGE;
+
+	if (oasz_lg2 != isz_lg2) {
+		u64 *end;
+
+		entry |= ARMV8PT_FMT_CONTIG;
+		tablep += pts->index;
+		end = tablep + log2_to_int(armv8pt_contig_count_lg2(pts));
+		for (; tablep != end; tablep++) {
+			WRITE_ONCE(*tablep, entry);
+			entry += (u64)1 << isz_lg2;
+		}
+	} else {
+		WRITE_ONCE(tablep[pts->index], entry);
+	}
+	pts->entry = entry;
+}
+#define pt_install_leaf_entry armv8pt_install_leaf_entry
+
+static inline bool armv8pt_install_table(struct pt_state *pts,
+					 pt_oaddr_t table_pa,
+					 const struct pt_write_attrs *attrs)
+{
+	u64 entry;
+
+	if (pts_feature(pts, PT_FEAT_ARMV8_LPA2))
+		entry = ARMV8PT_FMT_VALID | ARMV8PT_FMT_TABLE |
+			(table_pa & GENMASK_ULL(49, armv8pt_tgsz_lg2(pts))) |
+			FIELD_PREP(ARMV8PT_FMT_OA52_LPA2, table_pa >> 50);
+	else {
+		entry = ARMV8PT_FMT_VALID | ARMV8PT_FMT_TABLE |
+			(table_pa & GENMASK_ULL(47, armv8pt_tgsz_lg2(pts)));
+		/* 64K FEAT_LPA: OA[51:48] in [15:12] */
+		if (pts_feature(pts, PT_FEAT_ARMV8_LPA))
+			entry |= FIELD_PREP(ARMV8PT_FMT_OA52_LPA,
+					    table_pa >> 48);
+	}
+
+	return pt_table_install64(pts, entry);
+}
+#define pt_install_table armv8pt_install_table
+
+static inline void armv8pt_attr_from_entry(const struct pt_state *pts,
+					   struct pt_write_attrs *attrs)
+{
+	u64 mask = ARMV8PT_FMT_AF | ARMV8PT_FMT_UXN | ARMV8PT_FMT_PXN |
+		   ARMV8PT_FMT_ATTRINDX | ARMV8PT_FMT_AP | ARMV8PT_FMT_nG |
+		   ARMV8PT_FMT_S2MEMATTR | ARMV8PT_FMT_S2AP;
+
+	/* Tables D8-52/53: with LPA2 bits [9:8] are OA[51:50], not SH */
+	if (!pts_feature(pts, PT_FEAT_ARMV8_LPA2))
+		mask |= ARMV8PT_FMT_SH;
+	attrs->descriptor_bits = pts->entry & mask;
+}
+#define pt_attr_from_entry armv8pt_attr_from_entry
+
+static inline void armv8pt_clear_entries(struct pt_state *pts,
+					 unsigned int num_contig_lg2)
+{
+	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
+	u64 *end = tablep + log2_to_int(num_contig_lg2);
+
+	for (; tablep != end; tablep++)
+		WRITE_ONCE(*tablep, 0);
+}
+#define pt_clear_entries armv8pt_clear_entries
+
+static inline unsigned int armv8pt_max_sw_bit(struct pt_common *common)
+{
+	/*
+	 * Stage 2 bit [55] is the NS field in Realm state (Table D8-53),
+	 * so it cannot be used as a software bit for stage 2.
+	 */
+	if (pt_feature(common, PT_FEAT_ARMV8_S2))
+		return 2;
+	return 3;
+}
+#define pt_max_sw_bit armv8pt_max_sw_bit
+
+static inline u64 armv8pt_sw_bit(unsigned int bitnr)
+{
+	if (__builtin_constant_p(bitnr) && bitnr > 3)
+		BUILD_BUG();
+
+	/*
+	 * D8.3 Tables D8-50 through D8-53: Bits marked IGNORED in Table
+	 * descriptors and "Reserved for software use" in Block and Page
+	 * descriptors.
+	 *
+	 * Bits [58:56] are safe for all descriptor types at both stage 1
+	 * and stage 2.  Bit [55] is additionally available at stage 1
+	 * (Table D8-52).
+	 */
+	switch (bitnr) {
+	case 0 ... 2:
+		return BIT_ULL(56 + bitnr);
+	case 3:
+		return BIT_ULL(55);
+	default:
+		PT_WARN_ON(true);
+		return 0;
+	}
+}
+#define pt_sw_bit armv8pt_sw_bit
diff --git a/drivers/iommu/generic_pt/fmt/defs_armv8.h b/drivers/iommu/generic_pt/fmt/defs_armv8.h
new file mode 100644
index 00000000000000..d6c74dc3b574cf
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/defs_armv8.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024-2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * VMSAv8-64 translation table in AArch64 mode
+ *
+ */
+#ifndef __GENERIC_PT_FMT_DEFS_ARMV8_H
+#define __GENERIC_PT_FMT_DEFS_ARMV8_H
+
+#include <linux/generic_pt/common.h>
+#include <linux/types.h>
+
+typedef u64 pt_vaddr_t;
+typedef u64 pt_oaddr_t;
+
+struct armv8pt_write_attrs {
+	u64 descriptor_bits;
+	gfp_t gfp;
+};
+#define pt_write_attrs armv8pt_write_attrs
+
+#endif
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
index 1b39b27f0cfa81..09f4767b4410a4 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -162,6 +162,42 @@ enum {
 	PT_FEAT_AMDV1_FORCE_COHERENCE,
 };
 
+struct pt_armv8 {
+	struct pt_common common;
+	u8 tgsz_lg2;
+};
+
+enum {
+	/* Use the upper address space instead of lower */
+	PT_FEAT_ARMV8_TTBR1 = PT_FEAT_FMT_START,
+	/*
+	 * Large Physical Address Extension (for 64k):
+	 *  - HW must support a 4TB block descriptor
+	 *  - HW must decode the additional OA in PTE bits[15:12]
+	 */
+	PT_FEAT_ARMV8_LPA,
+	/*
+	 * Large Physical Address 2 Extension (for 4/16k):
+	 *  - HW must support TSZ=12 (52 bit VA)
+	 *  - HW must support a 5 level walk (table level -1), 4k only
+	 *  - HW must support 16 entries in ARM L0, 16k only
+	 *  - HW must support a 512GB block descriptor in 4k
+	 *                       64GB block descriptor in 16k
+	 *  - HW must decode the additional OA in PTE bits[9:8]
+	 *  - HW must support DS=1
+	 */
+	PT_FEAT_ARMV8_LPA2,
+	/*
+	 * Large Virtual Address Extension (for S1 64k):
+	 *  - HW must support S1.TSZ=12 (52 bit VA)
+	 */
+	PT_FEAT_ARMV8_LVA,
+	/* Use the Stage 2 format instead of Stage 1 */
+	PT_FEAT_ARMV8_S2,
+	/* For S2 uses the Force Write Back coding of the S2MEMATTR */
+	PT_FEAT_ARMV8_S2FWB,
+};
+
 struct pt_vtdss {
 	struct pt_common common;
 };
-- 
2.43.0


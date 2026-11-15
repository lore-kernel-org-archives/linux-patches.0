Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794785456;
	b=HemnJh30H+ZVfRTUwmG2wBIlFXSY89PqKgpSZuvN82y6M38MTTy5bIg4wyCWQ3RO2hGJ
	 y85lVv33sQWy85cACxHBFRgVsUt25F4th3F84JII4TUiW4Mbq7fHV3uAPY8jHkL2EGp6D
	 WV2fQFmMAWkCwhOwCw6X2rwJ516IKajpEjzxY4fh2XcKE7fAvM95HnUdhldUHs8VVVu/L
	 sq7SdoGHr3erJnwQ5/ebXO1G0PqgPCYivCXuSOXaW/fCA3HlGp8pimzrEybzKvcGap1AY
	 VsTt4ise9kkBz+Vpf/QUppfgPwUeR2hq1VL2eVcIEn6G52xf2Yz2/kf9pZJ3JUCUhmA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785456;
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
	bh=+dafhMVimh6tyShLK6Ug8V30cAEvvhjVz6GLr12HkDM=;
	b=vOx84a0QZxUeNX5OuUsNISDB0xNL5lwqk1AWA2Oh1N7TzmbYMn6EfJg7P/UdQjgteDW0
	 RNtuz7T3z0LsfGifuwqLzF4N+THq6z1ToZtPYaffAhWTY31mgHX8DS1artSpHnTxvnsyz
	 kjB7iMk9an/aJFNUctkw/rgx8Z4ttxU1nOK/okID5LyU0cDFzvHDPsCPLc6aQ2/1wZnDd
	 Ln14qM7CWvlaP2p+mQcajIFzQ15YYEXoXqItpUKNtXWQDGP+t5EYRl1QEjAU1uWUsWhpc
	 E7SaV5t3LBAt1JhujNcsoAHO/x9S/FepBWgT5/AF7ANvg0+zZKD4pQcdGPGPjF7DdAQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="b/8lNGW+";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.51
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011051.outbound.protection.outlook.com [40.93.194.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF79606A33F;
	Sun, 15 Nov 2026 23:30:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFF79606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=b/8lNGW+
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bvRjaGuMNbENDPKKTxfDUK4WRuh+7Xm602PLdMh154crLI8b9jxAr71gptNhsIa8YqFu09w0oINbM2ia4VgSTOaTL7cn6jpAM3xvy8N78Ae0X9q7Tc1iA7Oe8vUGVpRHS/rMx2sYRMZLqffQ6L4uUCtewf9BHAMtZ5CHwt5kP9uw+wlJGEazzhZqH6K9gIPPhlvL2dLXqgN6vWyhUKVyPaJaKjOfD3OAWTAYJdUbXWxNEfzWcl98RyjZ3rCz3KONtReP/KVDuVjkNXLv/F+hLZrdoMwa4SNE7DanNVVEMw2pJorXJltxCOxtMkDnEO/srZARAMvh18r57KX3zmSkzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+dafhMVimh6tyShLK6Ug8V30cAEvvhjVz6GLr12HkDM=;
 b=CeuWWUqWn0KcwKCuw4kTZAhmkunAzyZMM9i7ctYuwhwwWs0TcfWCio1ps+BaQIa3nZhcgqKoQmm8p2OkfEotNxSyHz6WX4bx+0giS0p115OXDHiWupZFRBch4q+8ANhCvZ7VbeAsED8F+Dq/Xpzdx25yRe90KxKD3cgeuheg/KojheIR9VJFoV9flSjyXY29J6QEW+1hmJ5XD3diXVhgHdnqkpKROO/1GXMewhQ2yFzWx1aWkShGZkQEn2BIqHtYYeVpdOh0qOZGZxVOAucD+ZWql0eH+x3MBlWaYKuTnyFPFNTG42jDU50gqz2wJbNlMhhg0xM/zFQLY/VAR+dY2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dafhMVimh6tyShLK6Ug8V30cAEvvhjVz6GLr12HkDM=;
 b=b/8lNGW+I1mPq4FPoFe+NSGXuhmFYEbipvFG07Xl1lTA7qF69duM4kJ+iifWkcGfoY76H/0LZbZW5xzw70h5cJ584ebA+Z8haToI6LkEbOqSz9wEHDmK9JeOpjcwiIHg7FA3ZqkEmeVhUwhQ5e+HxVJX9flyCkaWjj8LNCssvNSJrXMHXC+IzREjhrwqKbWmEivT6HAzJZfHNUWE+xSHqHyw2qzWGX4YfXayaOiqE5kXizFuXxvqbBZs5LK9dnQmiF8LVsE0A7FuJt9B80+INOtYcWomM1GqpNJWBlImCR0yB843WXFnASNhkzVB7HWBXNzCUxp32fReaDeAfV3Eww==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS0PR12MB8815.namprd12.prod.outlook.com
 (2603:10b6:8:14f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Sun, 15 Nov
 2026 23:30:49 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Sun, 15 Nov 2026
 23:30:49 +0000
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
Subject: [PATCH v3 07/13] iommupt/armv8: Add DBM support
Date: Sun, 15 Nov 2026 19:30:37 -0400
Message-ID: <7-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0426.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::11) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-Office365-Filtering-Correlation-Id: 301400c2-2bd1-41d5-e71e-08df4370790e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|11063799006|56012099006|261026121527099003|261022075727099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	2fSRsaOsF3RDSFaEK6O6urq1qt0mXM4yuH65p7X/4bVTEDbG+C1oDBspoSjfC2+0srZodNxOPF6t4l807tDipeRu4W/fC0PQZyXmjyYkdlYA7EFmcM4l/PW0Yuo/BfqZy2c8STypQROiDzI/cxWHPlgxTcpH2tjNyRtnqgT3DiLnoNb1bEprZqjuqbP6lFgL29+NG1dOACsyLMJ+JBnWewnlb/K70XadawtIsKa4akWiCmvxLoXkYwY1it+LoIQhA5qBETodN/yBNHI99UG8GDj5hQrgQr0Jl1YNL2UpcAqf8a+CDp5rUNHDo4F9Eh+mrwKfGopsFqkQlu3O/kSxePDdqCDuSWBMsthjIjxkSCgwr7xWLhCgn7xd7DKyCLi2LLTBaJNmopG8foDc8xMVAu+XfAoMEvXBgu/k5kVf/ystHPHHE7dOBBoSxQghcclzixnin+UCGFq3h6YdIb8Wf02IsfLs5/pon4mATPn2FgWfYK6kP7/Li3GYCdlu1doC3eQqn++Bu9VgPdTZdQ5pNdynDrq9llRQRjWtzUgglkUN6h0QqUie605R75VX/V5X6nzDxTFIZakgimVmyA6P9JP1k12C0TOrvGt/Y2Ge7iJcbky9/AAWtwqhZnLCnLkN13u/Eqfp0139TTbyCL0ikw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(11063799006)(56012099006)(261026121527099003)(261022075727099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S4494D4RyCh0iEq69oNPsJKyxEb1eMcMm8gXWVVNdUj3IW4uTycir0RHgVbG?=
 =?us-ascii?Q?soJ6BLRVe807/ExifY3uVHukdNoto1AeANHpxHWJHHOwD89c/ALE5XPs1fox?=
 =?us-ascii?Q?QhJncORn3Rlb2xqEffKxzighbwaUfXC35Rv2xXs8nazg7X0G6EdqBnVqKzzf?=
 =?us-ascii?Q?uCtnWSb9hoWBq7N5NiNL8pTAd4NcsJSnBVsD5aDQvyWKnhpLterXi+f1APEK?=
 =?us-ascii?Q?QhMnYsXSjr7K9p02z3zr6l+Li2KNluBGGv/FQsSDdB+35HSGpHWtq206prIc?=
 =?us-ascii?Q?lrprZl6eT5eigagDkxF33UE2tbK1pBBeUkIS7aatj+Bo2oPr040oWAjxghra?=
 =?us-ascii?Q?We6KIxK2hGM6pVnhvs0bZUJG+cAgcV1UU/HbbIOzVbBRDA2sqmFu4eEGmkq+?=
 =?us-ascii?Q?dczfLwv4/0YrDP55NMOsw8DaYX/y4GXiij5yROpAun9smc7GiesXgBs7aSPk?=
 =?us-ascii?Q?VtZZT0/P4NwBY840YZFZJifXNb3Oqm8EsMpXDBahvcS66cgNkHO6AQglGF/l?=
 =?us-ascii?Q?tKvemhNHgzuk3mr+3PyYVn+hld7Itcencsq4r/QCXXN2HsCUrf5RLtVuS1L5?=
 =?us-ascii?Q?FiJXu1YFe+8JfJ1yy3okvIVA+WT7iMof3Qj9Zju44PZvF7CpN3OTjH9cPhgK?=
 =?us-ascii?Q?KOPZdOt2HEG4i2aGbDgd1YSbMdO6dQ68u7pCmP9MoCR0ompJm16SpdB3f3xA?=
 =?us-ascii?Q?OKcPUZts28MbsI/t5GDMTYilWvCVcEsQiWhzaCfJrISeP5/3duJfd9U0XE2T?=
 =?us-ascii?Q?l1XfZaZyxwZCA8pyHim9nH/e+nXhsrdnR7zL4kmX1FJ7dPP13uQMykHDuhr5?=
 =?us-ascii?Q?KuW730xeVyJ3MK+35kT033pEPOmzIR6sUV7w9dkKtSo+x250/OW7xW5eTb8Q?=
 =?us-ascii?Q?yAyMpy7/bzqUUX45h4nBz1W25I3HTaALkCPI4UcQN45hfKoaVTaNXzKxntrV?=
 =?us-ascii?Q?EUQ/truCfllHAKR/ZcjRAjnW0Af0B9/NlV1jSWfHVv1OAUCab2Z2w5L9FpKu?=
 =?us-ascii?Q?EkabN0aRfcL/yLqOZdWJLLPcIpKfb3FXTlk9E4ja7n0ga+kRpwdT54PvsIpG?=
 =?us-ascii?Q?8zymvMuORBb5Uo8cItf6igcYU+Vxtd5Q5cQoZDdj2eNCeW3w8mCPr6tWOblG?=
 =?us-ascii?Q?udzRr0lsGpg7tAuDi6G59gU5XZuDPoHrBBbY5rEeqWd2uzj73ujzjVvzAGyE?=
 =?us-ascii?Q?mMS48Rq24KhTFbHFX4bCrOlJUWccT7rYrE6/xNjcUL1P5y15Ps5uOtULu4li?=
 =?us-ascii?Q?lLDenQ/vJ9s844Ef1LoKUnhb1xmaYktMjJ+MWZ1dLcee8FL2/kblQzNOrF8u?=
 =?us-ascii?Q?5nYVvP3aOJSBUWPsaUGhlvfli6AyieQwkiwt4wMkUJa28hzY345eq4USeLlY?=
 =?us-ascii?Q?jG2dlFMQ9rXDXR9pA6kVtelNgtiaa8zPLR7iqOh+u0JE77KUhCB2WRTOpk4u?=
 =?us-ascii?Q?nbVgpzMXf4cLQyMmcW0cGmAy3S3rRHuIYziqfKhdUpkc2tcc52nrykrZwOeB?=
 =?us-ascii?Q?Hnn42TK/KkDEWiMIo1l6p7MCv2fGDYhAZ8SPjO8VaDTBPLJPEVEd/bWcgZbD?=
 =?us-ascii?Q?on4x0wYiMSL6W5lfQHj5WzKX9IsJR4kSTM6FwN7Bqd4eW+PjAGVxaNlWY9OA?=
 =?us-ascii?Q?2Knn7zIC6a8v/i5mgXXEn1vaMuQJ3vHdr65zxb1QVgqp62sxM39UaFw6NJ3h?=
 =?us-ascii?Q?yl+w/toFMaH0QqblAoSvp3k5ImZ2r31pJOOIxyPM9P9fiX+/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 301400c2-2bd1-41d5-e71e-08df4370790e
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 23:30:45.7206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v2L5N9qsMgkDrLmAxDWDi6pE1oifZZvhWfeqMwRwVTcjAgxiWiiQiaCWXqKduUsd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8815

Provide the functions required to do dirty tracking with variations for S1
and S2 formats. This follows the same scheme as iopgtable where the table
starts off dirty to avoid any HW updates, and once dirty tracking is
started it will be cleaned.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/fmt/armv8.h | 102 ++++++++++++++++++++++++++-
 include/linux/generic_pt/common.h    |   2 +
 2 files changed, 101 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/generic_pt/fmt/armv8.h b/drivers/iommu/generic_pt/fmt/armv8.h
index 68fedda41fc198..f204f6906bb14f 100644
--- a/drivers/iommu/generic_pt/fmt/armv8.h
+++ b/drivers/iommu/generic_pt/fmt/armv8.h
@@ -101,6 +101,7 @@ enum {
 	/* 4K/16K FEAT_LPA2 (DS=1): OA[51:50] in bits[9:8], Figures D8-14/15 */
 	ARMV8PT_FMT_OA52_LPA2 = GENMASK_ULL(9, 8),
 
+	ARMV8PT_FMT_DBM = BIT_ULL(51),
 	ARMV8PT_FMT_CONTIG = BIT_ULL(52),
 	ARMV8PT_FMT_UXN = BIT_ULL(53),
 	ARMV8PT_FMT_PXN = BIT_ULL(54),
@@ -424,9 +425,9 @@ static inline bool armv8pt_install_table(struct pt_state *pts,
 static inline void armv8pt_attr_from_entry(const struct pt_state *pts,
 					   struct pt_write_attrs *attrs)
 {
-	u64 mask = ARMV8PT_FMT_AF | ARMV8PT_FMT_UXN | ARMV8PT_FMT_PXN |
-		   ARMV8PT_FMT_ATTRINDX | ARMV8PT_FMT_AP | ARMV8PT_FMT_nG |
-		   ARMV8PT_FMT_S2MEMATTR | ARMV8PT_FMT_S2AP;
+	u64 mask = ARMV8PT_FMT_AF | ARMV8PT_FMT_DBM | ARMV8PT_FMT_UXN |
+		   ARMV8PT_FMT_PXN | ARMV8PT_FMT_ATTRINDX | ARMV8PT_FMT_AP |
+		   ARMV8PT_FMT_nG | ARMV8PT_FMT_S2MEMATTR | ARMV8PT_FMT_S2AP;
 
 	/* Tables D8-52/53: with LPA2 bits [9:8] are OA[51:50], not SH */
 	if (!pts_feature(pts, PT_FEAT_ARMV8_LPA2))
@@ -446,6 +447,101 @@ static inline void armv8pt_clear_entries(struct pt_state *pts,
 }
 #define pt_clear_entries armv8pt_clear_entries
 
+/*
+ * Call fn over all the items in an entry. If the entry is contiguous this
+ * iterates over the entire contiguous entry, including items preceding
+ * pts->va. always_inline avoids an indirect function call.
+ */
+static __always_inline bool armv8pt_reduce_contig(const struct pt_state *pts,
+						  bool (*fn)(u64 *tablep,
+							     u64 entry))
+{
+	u64 *tablep = pt_cur_table(pts, u64);
+
+	if (pts->entry & ARMV8PT_FMT_CONTIG) {
+		unsigned int num_contig_lg2 = armv8pt_contig_count_lg2(pts);
+		u64 *end;
+
+		tablep += log2_set_mod(pts->index, 0, num_contig_lg2);
+		end = tablep + log2_to_int(num_contig_lg2);
+		for (; tablep != end; tablep++)
+			if (fn(tablep, READ_ONCE(*tablep)))
+				return true;
+		return false;
+	}
+	return fn(tablep + pts->index, pts->entry);
+}
+
+static inline bool armv8pt_check_is_dirty_s1(u64 *tablep, u64 entry)
+{
+	return (entry & (ARMV8PT_FMT_DBM |
+			 FIELD_PREP(ARMV8PT_FMT_AP, ARMV8PT_AP_RDONLY))) ==
+	       ARMV8PT_FMT_DBM;
+}
+
+static bool armv8pt_clear_dirty_s1(u64 *tablep, u64 entry)
+{
+	WRITE_ONCE(*tablep,
+		   entry | FIELD_PREP(ARMV8PT_FMT_AP, ARMV8PT_AP_RDONLY));
+	return false;
+}
+
+static inline bool armv8pt_check_is_dirty_s2(u64 *tablep, u64 entry)
+{
+	const u64 DIRTY = ARMV8PT_FMT_DBM |
+			  FIELD_PREP(ARMV8PT_FMT_S2AP, ARMV8PT_S2AP_WRITE);
+
+	return (entry & DIRTY) == DIRTY;
+}
+
+static bool armv8pt_clear_dirty_s2(u64 *tablep, u64 entry)
+{
+	WRITE_ONCE(*tablep, entry & ~(u64)FIELD_PREP(ARMV8PT_FMT_S2AP,
+						     ARMV8PT_S2AP_WRITE));
+	return false;
+}
+
+static inline bool armv8pt_entry_is_write_dirty(const struct pt_state *pts)
+{
+	if (!pts_feature(pts, PT_FEAT_ARMV8_S2))
+		return armv8pt_reduce_contig(pts, armv8pt_check_is_dirty_s1);
+	else
+		return armv8pt_reduce_contig(pts, armv8pt_check_is_dirty_s2);
+}
+#define pt_entry_is_write_dirty armv8pt_entry_is_write_dirty
+
+static inline void armv8pt_entry_make_write_clean(struct pt_state *pts)
+{
+	if (!pts_feature(pts, PT_FEAT_ARMV8_S2))
+		armv8pt_reduce_contig(pts, armv8pt_clear_dirty_s1);
+	else
+		armv8pt_reduce_contig(pts, armv8pt_clear_dirty_s2);
+}
+#define pt_entry_make_write_clean armv8pt_entry_make_write_clean
+
+static inline bool armv8pt_entry_make_write_dirty(struct pt_state *pts)
+{
+	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
+	u64 new = pts->entry;
+
+	if (!(pts->entry & ARMV8PT_FMT_DBM))
+		return false;
+
+	if (!pts_feature(pts, PT_FEAT_ARMV8_S2))
+		new &= ~FIELD_PREP(ARMV8PT_FMT_AP, ARMV8PT_AP_RDONLY);
+	else
+		new |= FIELD_PREP(ARMV8PT_FMT_S2AP, ARMV8PT_S2AP_WRITE);
+
+	return try_cmpxchg64(tablep, &pts->entry, new);
+}
+#define pt_entry_make_write_dirty armv8pt_entry_make_write_dirty
+
+static inline bool armv8pt_dirty_supported(struct pt_common *common)
+{
+	return pt_feature(common, PT_FEAT_ARMV8_DBM);
+}
+#define pt_dirty_supported armv8pt_dirty_supported
+
 static inline unsigned int armv8pt_max_sw_bit(struct pt_common *common)
 {
 	/*
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
index 09f4767b4410a4..b5a551a22fbc5e 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -194,6 +194,8 @@ enum {
 	PT_FEAT_ARMV8_LVA,
 	/* Use the Stage 2 format instead of Stage 1 */
 	PT_FEAT_ARMV8_S2,
+	/* Use Dirty Bit Modifier, necessary for IOMMU dirty tracking */
+	PT_FEAT_ARMV8_DBM,
 	/* For S2 uses the Force Write Back coding of the S2MEMATTR */
 	PT_FEAT_ARMV8_S2FWB,
 };
-- 
2.43.0


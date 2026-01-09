Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010024.outbound.protection.outlook.com [52.101.193.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53D435CB97;
	Fri,  9 Jan 2026 14:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767969001; cv=fail; b=HwYOo7A4VNeJv9PW3lOiMVs6c2Hj8VP5ZutwWhsIF2tK5oHGoNNRF5aykTDHdpOPHvtbAKi6ol8koZBcuZv6AxJBGo8T7CV37vBClUi3eDVrYzqek6mWE+VjOiOMp/VP9kRZXEHKxdTe8oZIazQsUF0tRzUchiOwRxfkYJUF0x4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767969001; c=relaxed/simple;
	bh=P9c8vQA3wjnYXKDer7QE1mpWkjoCYuC6uTwIergZyB0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=GFQSeGsqZig6Zx6vLeqdekaSto4XW69soAE6ToWmpEB0OLblr5wVjHqUTygEEfVPXiQGTxKgdA1gERhPARYOHEIuQmW4oK8whJaGx2erG87WUeNCBShsIOj74ZcPEyKpWmye8+YF/2UK1hhthjCtBKDld1uFZ00vq5FqcVdhHhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=i0DVUgRU; arc=fail smtp.client-ip=52.101.193.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="i0DVUgRU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lk3um3Q+aw+J+aM1cs5nryo1u2TWSa3uWly42mFYTKh9lAq15VDTi5i4bYLqZhfdf+YqeKEq8bZ2g967I8dZbs+JvzWTDyCYdPaTpAMh9EgkYqWi6UJoqf0EirDILE47tzaTw/IHIa0v6fZMoJrdIuQuC3i4dI7GyJQQHfL9QnpArM8rcfBhcnLLIk8YXtADXWQYCTHKtgytErmox7JKW7mCKl5GE/ns0wyPPQ9rWS3FO1qCRL4VTJqzW8F0xMDq93keCX856yW9XA23LkTlXCHdqWmS9KZMvG5ok4Z5lpJxuq1hRH/enDmEfozEYTpqVOVr98eZuNfWV9DoNI+yiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xDNwW++9dmhJJ3p1bi3qzoOdM9kuY9GiPBl/BYB+04k=;
 b=nINnVEYgjRlQylroHP+lK+dkEAsSACsybFWib59rWcsDIkYPZHvWoecSmZhaWHsB+BXoeh7P3uAqc24DHwWZkKy0+6KeEumkf6TXO0Prq3u5daGzZs+Y5nDh1iiMqSBl5+4KgOFNa2w/j10/ADRsuS1k0Zz039vkfGcHls8fWN0N7U8oGKANr52BPaQrg/NkprlQV4UKwflSDMvD+M+dmZj/IHcXGtMSKlrvTr8N218YOjS65Q/jtyyC0LzqwNfft1kLOZFQG42TkHFBKGTNq0P2dtHq5Fdr1PHZwgHuqMy+dBoKRfMMAyvVgqHP4k5snhWnwbcVgz7vGIrXGtG9RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xDNwW++9dmhJJ3p1bi3qzoOdM9kuY9GiPBl/BYB+04k=;
 b=i0DVUgRUbkBgvSk5ln3nMRh0KfL4hT4Y/3hfrm22Vccqz+XRCJP2A12Pl0NE+7YTFp1fasXgch1C5DA+4/g0OGnLqiPgHtYC0mqFAjmJ4e9yjgVU85sW5WlNCytCUXT0C0/Wuh4IRBhW1A6sFvFszPQGHzTH+QhTw6nD/TCZ8jWENl/esmK07N7/3wv/VKyRrV63aEwceiQv2bfxC5R49atUYS0a70I0/Q1HYpOYY/zV6lwT0HH8deGVlMZPjuCuGEj4mu1d/DwS8NYU7EJ0dhT9t0PPX+biaGBOt8f8rOXuNJn27wwdu83Vc5MwlppYmZX27vWp8qN59sdDvZe8Rg==
Received: from SJ0PR12MB6784.namprd12.prod.outlook.com (2603:10b6:a03:44f::20)
 by MN0PR12MB6295.namprd12.prod.outlook.com (2603:10b6:208:3c0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Fri, 9 Jan
 2026 14:29:55 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ0PR12MB6784.namprd12.prod.outlook.com (2603:10b6:a03:44f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.5; Fri, 9 Jan
 2026 14:29:53 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.003; Fri, 9 Jan 2026
 14:29:53 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	kernel test robot <lkp@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>
Subject: [PATCH rc] iommupt: Make pt_feature() always_inline
Date: Fri,  9 Jan 2026 10:29:52 -0400
Message-ID: <0-v1-3a1ecb955351+244-iommupt_noswbit_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0035.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:5b6::19) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	LV8PR12MB9620:EE_|SJ0PR12MB6784:EE_|MN0PR12MB6295:EE_
X-MS-Office365-Filtering-Correlation-Id: 063486cb-45f6-4070-a7df-08de4f8b8da8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?T8NudA8ars39+AlUwWSDKLpFlYJFPK9NshailCeEIgRlV2FL/UvvPBkxiHJI?=
 =?us-ascii?Q?qhWA83yfaqwUc6guI5peu3vtdgIi2ONTWDmpoczC2HtxrUQes2vA5Zrc9pz1?=
 =?us-ascii?Q?l0jleR/tsxU2NGBI92GKXPRrxxL/2Chk44T1/csF4IzbqdcU5CrkaShgiFfl?=
 =?us-ascii?Q?FMIHH1awig1fPCIaTBJNcL9ExK2p2Krj52lOgLvf4FaVRLXddy64wyVFsjVO?=
 =?us-ascii?Q?/uUPTIOd7CyzPFCZIgZjNPxlVk65tIHEdIaNA/eLlXRVC0/9kZffA8b0xfAY?=
 =?us-ascii?Q?zwXnlkQve0B9xvF4gVlGCYGr1ZB0iq7l1Yv13wMJWdx1XPiBc+oDO+EEu4PE?=
 =?us-ascii?Q?Q9UG5BMljTbrYQEAGA7nLen5VuGfG0jWimC7lq7RFyiVowRftiJ4TalmdWpY?=
 =?us-ascii?Q?fq2+VlIAHD6e6m1D2f5R8nw8yVENIj13cbWWLkC4YDhvXjkS9MEiqxzWAZJj?=
 =?us-ascii?Q?IlcHs1+5GfZ5BJFWbgOlPeLMW83mj6JPGguWXckcdu3WLi9hRW17SLSdNTHY?=
 =?us-ascii?Q?pmjb+3+2vhWucbKEM3YzyA+SEt35jqxu251kjP1BHeDFUcSBhkgZRT9j5XVS?=
 =?us-ascii?Q?MF4NG/wu9ZgREUeRzxi+pyQ2Ja/SmYhPRqPAVzKrIo+VDHd0I/Q232wWzEvh?=
 =?us-ascii?Q?XCCIX2eLj9JFTflA0H3B11IqTum0KfbuPS+xGObkJy+hY4OBLqAcJKM+V692?=
 =?us-ascii?Q?SZCbT1LaJ3bugFK93NBtMG+u1vVAlmwwZksvfOsVIQ6Yk5voB0VUUm5L/moA?=
 =?us-ascii?Q?XPGKLPLroQu5GKWbk8gMSaY8LJA4/U0aiAcSdVW2fKIrG5lQz2Ph1KfpZV3g?=
 =?us-ascii?Q?lkRXpIGTSAtkws26SrOeFKIvGXA3J2JwV97MHvb+QrTsdr4U8i+zdqwDoX5n?=
 =?us-ascii?Q?ZbEu2N8YghM5auYFnPFWP31ByIU+Vn7KUJ0qMA+J9KuTkEN1DvzIYGqDhw4B?=
 =?us-ascii?Q?qOEee4Gkp1fIP0WIhbzlptOl7OjIKM9DmrQK2Zua7/x802/7oEYP5pwYi15o?=
 =?us-ascii?Q?xzrnPX4zm+Akjla2tKvlh3+QpTlJCmEJfKX52lJ3lLgFstSfmEpr70+6azKx?=
 =?us-ascii?Q?0X3PYPY0p6J9urItVAnXqCX+04YFhQG/yq5mVlVc0/l2XlQ+GHEbB8Fr8uPV?=
 =?us-ascii?Q?pUvaoVC1dn34v+iBC/0T6JtT+tfqfk7DVZWijYIgsE1NBwpqskaN6ig8AowM?=
 =?us-ascii?Q?s/ub63dxE8XVTPtSuUGXmSbfNGd/jTaB9q0N9hG0N2PNAV72/P7MySeCEJlh?=
 =?us-ascii?Q?SosaFKmx2rKq2+JbCzJsPDaCIkD8OA4hzo0Qzl/onKTEExI1hsvEadI04bCi?=
 =?us-ascii?Q?IHCBePOKGfBgcMu3oLKIsD3NiLrC7tr29vjfOLWY6KD+tWrd10cQMw1Rik5a?=
 =?us-ascii?Q?7YC8WwTO5p59l3AsCaTcXD8otSeG3QvU65ZTOKTsw6Sc3r9uC3wQJWbZt7zY?=
 =?us-ascii?Q?CtWcUVjUyra3fH/hwnHQws0yXAAnB8Cn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB6784.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?o3SLhkF8PwoJhClIveWxe8hoRZeHFxQxveLO6A95L7bLMs8aE9kn4RdYnEMV?=
 =?us-ascii?Q?iV1OhpMum8mdu+EdtUMmD8X4OOVQKoAuB0Bno0ck6yHGv1cRtPQgEF/CPNIg?=
 =?us-ascii?Q?p0Cxk4tqv8g+NClYUbfw3VTmRyrrb36k9ola+kq+rKl+dSjL3iTZIBfc0vjf?=
 =?us-ascii?Q?T4P5lAUrlkY7+DtmsOAfmWPH3Upzgt2573Bs7lDy38IVRG5bO0P+Vt1hxpIw?=
 =?us-ascii?Q?iVXjOAye1MWUbBazGMGblfDK4LTxcjIJOm6ekjGErK/fve22IqKvR33prheh?=
 =?us-ascii?Q?foHtYovMaVk3JeSJ3fnMWxVM26bqCMnQWcWQ8fjbnNLSxcee3UDYy0XMoq9W?=
 =?us-ascii?Q?0NR2Is0bhxr0sOU0bEH5QLq7Nq9AfYuLQMmzAg5o2vnV1eKJI7laISnECfPR?=
 =?us-ascii?Q?SgIfa5XPI4bnA5Hp+HgfVRFzvPRCVFH3ad7DKV5i3PrVydRarwQVzQvptI44?=
 =?us-ascii?Q?/KAOMvlUrKyXFTogW+ySHOzz1dz4b96xKux2HJciekGq2bOwtUzJSNPyIop7?=
 =?us-ascii?Q?KrGhBJqTqg/+u1NxQNs3SQPrdtxsUakuu9bC8JzkeUOzLXWc6j9XIiaNtZzL?=
 =?us-ascii?Q?UlFDHHHnSJk93nNDW1MCyEWw76F0TyUhlQ35hZPOnbGFIuWTjDchvvHaTnAS?=
 =?us-ascii?Q?D5890vsKJkO2XUPy2v6b0QMY9oO+hh/oGlQlkIcEt3GHkMWs83e2sMiiBQer?=
 =?us-ascii?Q?JuS7aatCTlGLGE83GkshOwtox4qxpE3I30GzSYXRRcGXp1nBzQztDZvU/tk0?=
 =?us-ascii?Q?2SeA272vmuiiK5qcK5Tydu6NWd95iC+z2YQBuZNCtkd8dN4HbD7BLqo05sYB?=
 =?us-ascii?Q?uW9pAwboEexN0igjPiKBis6DbNMIj0QXDPh/ObWz7H+lirFkUrWPuKraJLJw?=
 =?us-ascii?Q?DJAfZDOpKCHxMcbTdze76BV51fvzSpPzWDeBU7w9y8Y2C+cZeX0JEHnbovse?=
 =?us-ascii?Q?s6VcXnCbM8aWJqcIHB7a+0/Wuc+543vDiwV0BnlSK0YYJXv+LfL9QIqeCeJ8?=
 =?us-ascii?Q?4dnYs9fDIoQ9U/AlpSKctOdaCQ7zHHJ5vO8GJcj9Eanm6lwInRyENj5HkiVy?=
 =?us-ascii?Q?8GK03IkAATmGIcCLdmma4vvdBtBaa+lNxmxSl2Nr8D6+Z+fXBTNbATTRHtQC?=
 =?us-ascii?Q?d4rAu5jlXskqvREZ2B87R8tnqC0PPd6eHuU4vauAyqFfBFUnoLzlJ7UrSuuc?=
 =?us-ascii?Q?k1fb8mb9RawRdHoH8ol0XjOdwqv1A14YGkS75ES15WqQrXKaSaCU2tvvKH6y?=
 =?us-ascii?Q?xnAdkapMgNVnHcPGQMOB2IiLrJJalu3pzd0Kj3+02QRNMyGHw0lAlQzDDeiB?=
 =?us-ascii?Q?3n6A29fFdcuqrZ9DtLo7rKNDHhorpu0sbYVtrsus+0unPgSQSm3oYrtKh6+9?=
 =?us-ascii?Q?xDkPcilpz+rZlEdoBxoqVDjFymVc0LUW7Jz2C5rUjVbd9r/mH74ewtKu9Zbd?=
 =?us-ascii?Q?/scYur76jo1w5Wh1JfeisyBdVgfhW5gLUP+8lyjRiErlCiUpaYcNkMU6Mlpd?=
 =?us-ascii?Q?OymPYtmvUW/UC1n44f5vvPcbd5Kbh9eIM4YoyfLzkhbX8IPuMm+KjOAnTXy6?=
 =?us-ascii?Q?0+5w9oybduBL2O/U2Ayhi+k4Mqssf2mbGACJNt6uis1gEmPy+el2nVsPoOEV?=
 =?us-ascii?Q?glarOi7XkRqusIai8m8jCnWbfCP8gcookpkeL5s6VBhRJkqQot5r/yZixtUJ?=
 =?us-ascii?Q?6x44/yy3jkax/4SEQcA6Dj8t00kiuC3hvqfxkA2eovV0kX5fSr2YReUC/s45?=
 =?us-ascii?Q?Rxk2v3Kupg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 063486cb-45f6-4070-a7df-08de4f8b8da8
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 14:29:53.1369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vThWVGPnIKd3KqL3Xgi1ccJgyPsH/p2Nkp1JDfpsRdae4HdGKeC50tyqM4ZEPMeY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6295

gcc 8.5 on powerpc does not automatically inline these functions even
though they evaluate to constants in key cases. Since the constant
propagation is essential for some code elimination and built-time checks
this causes a build failure:

 ERROR: modpost: "__pt_no_sw_bit" [drivers/iommu/generic_pt/fmt/iommu_amdv1.ko] undefined!

Caused by this:

	if (pts_feature(&pts, PT_FEAT_DMA_INCOHERENT) &&
	    !pt_test_sw_bit_acquire(&pts,
				    SW_BIT_CACHE_FLUSH_DONE))
		flush_writes_item(&pts);

Where pts_feature() evaluates to a constant false. Mark them as
__always_inline to force it to evaluate to a constant and trigger the code
elimination.

Fixes: 7c5b184db714 ("genpt: Generic Page Table base API")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512230720.9y9DtWIo-lkp@intel.com/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/pt_defs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/generic_pt/pt_defs.h b/drivers/iommu/generic_pt/pt_defs.h
index c25544d72f979a..707b3b0282fad7 100644
--- a/drivers/iommu/generic_pt/pt_defs.h
+++ b/drivers/iommu/generic_pt/pt_defs.h
@@ -202,7 +202,7 @@ static inline bool pt_table_install32(struct pt_state *pts, u32 table_entry)
 
 #define PT_SUPPORTED_FEATURE(feature_nr) (PT_SUPPORTED_FEATURES & BIT(feature_nr))
 
-static inline bool pt_feature(const struct pt_common *common,
+static __always_inline bool pt_feature(const struct pt_common *common,
 			      unsigned int feature_nr)
 {
 	if (PT_FORCE_ENABLED_FEATURES & BIT(feature_nr))
@@ -212,7 +212,7 @@ static inline bool pt_feature(const struct pt_common *common,
 	return common->features & BIT(feature_nr);
 }
 
-static inline bool pts_feature(const struct pt_state *pts,
+static __always_inline bool pts_feature(const struct pt_state *pts,
 			       unsigned int feature_nr)
 {
 	return pt_feature(pts->range->common, feature_nr);

base-commit: 8c5fddcc046fb4f3664643750cb3c553768e0dcf
-- 
2.43.0


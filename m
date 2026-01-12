Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013003.outbound.protection.outlook.com [40.93.196.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E57A1DEFF5;
	Mon, 12 Jan 2026 14:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.3
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229356; cv=fail; b=WFcAMT1gIqfGxayrmKdsXQqlZ+yw6wCWCTm74F7NXqL02272w/a0s0hM7kB4zINItQzvTuul+p0Bfw9KpjsXQOhFEUsd3++cQx+n559O3H6gsKU5s5AYbJqL621sd5MoMj9m92Br8wly/GlwNV5YUOt4eeqgdcTDWcgI8x05HXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229356; c=relaxed/simple;
	bh=T29/V8M6/4vZefX3xvIn676AP/B2QdNNHMC/J850NBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ii6/mAqqXpsl7Ahv7LiPeJkRCi7U9uJ/+dbNYGUUe97n35156rz+F/90iUNwikR6h4uR5xUeQw3VvULKpLL3aU0YtJbJxtajYUYR/FzXWe0C2gKF7Ep/Gj4ugYJLfm61rURwZHTRXT8LxYN9wfPQrOiHBxrczDFIwN1bQ5eqy18=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IKZdfDpk; arc=fail smtp.client-ip=40.93.196.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IKZdfDpk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FaJo4GX20Bu1WzejfeE2Aay9puRpUnlZywJ4yeDhB+/C2DmY2KF4YMsHwnB6VmqK1KpsUS/ee482kuLs2v4nwU1qVq6IumD2fqaKdOK4rLJ89pu1CknzOOYZRyn6Npy2NN6hFvbWfrbGmmDpRfGuDZEliymKf7jO1JwTT4nPtdu3ycBsKUxLl5FpV/E84l3KDbqldCcuwZg1dyqVMvsFsI0QoeS07yhEXM5NWNLbIt92030LbjtfTWa9zJPpLZlJRe4CynbwUA7c0miFI+oyp0PRHhcaAoVrkfTur5FdH+wOqZ86FT5cbJ0UFxqw/QzlqyvNlG0j0ifuYjdEELnKSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9tLooa4gSjI078jQ9EHOPbpuQ+G6GNzPn3eQrVir4yo=;
 b=rHJxtguOahQe/H1dG+kdwcE0Tmddqef+pkS/x+U5q4zVPEkbpsREFWG9wJTUuJq41fV+9ygsqo9lrTHb9ScXGoXA1IWnOxDTw9dm14/vRz9iLXFWoUxIdZYVe2uJA6Fjm7C+SrbgZA22T6rX8P10YLtXEHZFOcr8NP5iO8dGSSRlVlHkP5bVjzLFtrea34Tzb8Wm4C7oXxKrRfr77HhlW6TUW5vGhRowbpheDvfDJoc7FuBehbjoQoiT7NtpQ7hoi7y3inZzX4n//22rt6+ax6sAem8cvCs8f6hFXrHMoxh+OmOnbcVD7Zl5AbNe/pAZLjgGBPnxF45H7hpnKm2QOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9tLooa4gSjI078jQ9EHOPbpuQ+G6GNzPn3eQrVir4yo=;
 b=IKZdfDpkYTLhWEjyYFXh1GZ1WVUqmDMs32nLzl3t5rhGDhVf9DuIVsehva8Jfq47gCBlfZntQNl55ujH2UgvqrYxKkAetvlei6jNHGCgd8R3wlCkLpf4X6+PMbZGsbYmEWo9XPnf/BjQO/Pt/w7ufvOwoXpoldkYLWcSjDqP2pl2kJefO/78Yshf56ZG1qZWXSVRZUdKvljvKAxkgPdCmsaz/M+C4whLDQFKQ9Nma9RoelBgYU3ezul9DlmC1fhoOTFRx4nqA6z5vNVni/TRoZ3P02inLMsSw4REh0lOD3QAfQzBLFeYuosP8h5U127CkIS+m0TL9SOmTD2GN/xtng==
Received: from LV8PR12MB9641.namprd12.prod.outlook.com (2603:10b6:408:295::18)
 by SJ0PR12MB6757.namprd12.prod.outlook.com (2603:10b6:a03:449::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 14:49:11 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by LV8PR12MB9641.namprd12.prod.outlook.com (2603:10b6:408:295::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 14:49:09 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 14:49:09 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>
Subject: [PATCH 1/3] iommupt: Make pt_feature() always_inline
Date: Mon, 12 Jan 2026 10:49:02 -0400
Message-ID: <1-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
In-Reply-To: <0-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0P221CA0018.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:52a::29) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	LV8PR12MB9620:EE_|LV8PR12MB9641:EE_|SJ0PR12MB6757:EE_
X-MS-Office365-Filtering-Correlation-Id: cdcabc65-30c3-4b3f-3459-08de51e9bc69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BaA1i3yfk0gI9xz+FMupf3mT7EKVLj2CvyVxOoQPOIYkbe/YPlgRoFU71GzG?=
 =?us-ascii?Q?1rfF0MssZJk4XJFfK1hD7+cVhW/QjtDP15eeFK/JgcACgKGKiHa2xDExcMaL?=
 =?us-ascii?Q?Kw87SsaSLZTucJKPuHsPKn0wTQtCBFxAq9GMLe/beR8yF9yEX7mf3lw9gty6?=
 =?us-ascii?Q?Y0tsoFu6Sj5DuDdkARbm5K8GFM2UKDop4pcQ7MQCNyWPqkSAk0fXPZPPScg/?=
 =?us-ascii?Q?jQ8Hw6B0vtl04R8lT2YvlLCIcH/CodA4dvXwGFfOU97p1Uw5ovLVllzbOa3N?=
 =?us-ascii?Q?8ZLvw0qbe7zC4jLBkE75ppZjM+b+b8WWdn/WMqYRvnvPNQafvCcvvKgxNyPk?=
 =?us-ascii?Q?0CcYldMC5h00oyw8qhd9ugv0q4FiSDb2JNPc8sC1wL2bY7uimo4pyvrEwxIf?=
 =?us-ascii?Q?PGT9BhQkpEt5Ozk/1i5EndaVblxq2KbcLfYUaFzGX2SJK6lBvJPMJcWxJz2k?=
 =?us-ascii?Q?6drHAYxeJXecA72v/2wc5ftmetdi4IBNRJM4wEEFHvHB2/b9bPMtQBI5lW0/?=
 =?us-ascii?Q?cp/iG6KoDzmwvK4Qj69A5PcfdHrwCGvozluU3ZL2czTMlwkaRrzB13pId9ZS?=
 =?us-ascii?Q?BAutvjPXXz/VNAQtYQnpdPK3+X1A/Ko/McsoRpmzGSiFJqTjKXe0B09GSNaZ?=
 =?us-ascii?Q?OTNR4cF3Ivl7+PRBzr9PUujr1xbO+j0mvbHuW2JSC7jD71qYHo5fRcuhXsq6?=
 =?us-ascii?Q?2/yZtB4YpHP21mDmwr1O0soaY/8Mu/C50jhLTZUBE/yy3WJsmmBd3gM9M6t0?=
 =?us-ascii?Q?uOFAU1bsU3WWKAgqNHJXzVwqLxavgic74rDvLlArEGS8ZXb705m+6RERaKw3?=
 =?us-ascii?Q?yqJ6HiU5BUQvQl/q2z9zSsQRbKSKpWQyTrFOdj4I+rZavhVgCtQfUZkWTFUa?=
 =?us-ascii?Q?njE1mdTRR027Fx3rHnfTcRXPSK8SE/mcz/ZiiEHkL2jhEY8XOye6nz4jEXGN?=
 =?us-ascii?Q?Zc2/NLE7N7wWz+KItvUAsjiLbzKXCVpa/GHVVay4QiUOvy30k1pXZsiGkiUp?=
 =?us-ascii?Q?kUh8Lz9Sn77cNVPs15PhGRR7If/vC72lygOjy8Z/AeUj+TgBPID2sD3tNHf7?=
 =?us-ascii?Q?jbMBR2CAZaa0azKYm9n9W+oEWMNnUYT54znRf5Ugvk714U0ujKtQ7XRZbVYE?=
 =?us-ascii?Q?sVl2sgpW5CqOpP7FjiSJSonACllXi6MWGUdJaF3drrBbComhzEFDVDN43Fv5?=
 =?us-ascii?Q?Zsvc1UJfEM0YR9gJz+72hf7PEnukRtkTcV/N+WfGAnSS+Un2B+sbnPnSR7/8?=
 =?us-ascii?Q?M2Q3okeHvRLXY8P/qnvrb+z87sLwgjSCLCxtMs7v2724yrWH5fLR9MVLSE1l?=
 =?us-ascii?Q?+Fo5TT8siJ74EZLlQ+zWIom6BY1IIB68BYtT5QfInGPI7EDyxQONI6LuYwMF?=
 =?us-ascii?Q?6aINHn6U1C2R/7FuNarFa+zI1bWc8SA1yrFHa+Pwa5Jc2pMLtGxhxjzYpTp3?=
 =?us-ascii?Q?4mTd892K6iKmV+duRFlaStouItKysS9N?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HtMMwGZ0C9DOroZ8LtgsDNjksTPQM9caJ/8hcfUwkE8xSv7wyEpK0+aBpH7e?=
 =?us-ascii?Q?i6JNbeQ1f+urrtDET6b2GwsiqexHcv56ZLL6Vygvr0Wm9svWpo8pRaWt7nGN?=
 =?us-ascii?Q?W3uRNo9wXABA1xFcuxTXmf5ZuoBF3mGZyVB2xw1JtQ16t9tdND2FQbxI+Mtx?=
 =?us-ascii?Q?mQl5qQa9H5ScQtGezPLg0kGeEhn748kLtZcCcyiCLY8o3FCRCINHwlZOLJS6?=
 =?us-ascii?Q?c1gr4bdwiecUyvMZ1emIeU+luRGQ/h0bZ8ZvTVZSgzvlzrwLJ5ftingH147S?=
 =?us-ascii?Q?CNvvzYUbgzMP98MiWYIuqWzkuksQi28kFxnSV3MItHPaJ+UiDnTJW421Ke7H?=
 =?us-ascii?Q?Zs7S7ugdl3c5aK6AJY4f2Ha2ORM17WzTfsAKub5V8HgDWMvZJKGPClN+x72t?=
 =?us-ascii?Q?xm8tXn/R5gK5fg8Va+uTi1+wRW6FzqR2wBuADGLMhJDw6kemkNA3tU2Yxr+2?=
 =?us-ascii?Q?KlLBLk0elkFUChABlKb4zmimNfCIN7xmG6bHsvIj6FR1vKRBznYzPpMhnHBc?=
 =?us-ascii?Q?BATXBYMFLB2H9M+fmp1LthxzwWqMFOzH2yuFz1440hVt3ndyLOVeq+Az3kE3?=
 =?us-ascii?Q?3THHtoxdO4r94Ph+8MzC1ePDT+EbG8BiP5HPeL/jm8OD/qS1JXgQoLZxUHSJ?=
 =?us-ascii?Q?vC/8RFtrEMYuLv7G0fUBGepwfpFsbSOmbCjhKRXspS/LmYKrrdxE6WyYZjZi?=
 =?us-ascii?Q?LNVNQEY18kazS7qH8cYDutaChp82M4IhUknC9tyBuzMyo8ccXJUNh3WaYzxL?=
 =?us-ascii?Q?nFlwqFfKY++VQOL+L1Vrt135rPUDNcdkus7hHStiR5+Nl/VUL/mR4rHv0rID?=
 =?us-ascii?Q?zj5A3+f0uteq6JeV/We1YzRBX0ZvP825bebmY6sLIx0yEfVYKHqyKy5gYSzV?=
 =?us-ascii?Q?RhG6lJmBviRFza2oLWNNtGixOl/S5eOe6ZthtyBmrHkoJCDuoTdBBzHrBRtq?=
 =?us-ascii?Q?V8UcHG+xEbg3iYxGwp/hBr2/msT7zUbsSPb6GAOhM255Yi9oT8MLWpMH9PHX?=
 =?us-ascii?Q?v0gt4V8mSCpJFYQBqpod6T0t9+J6cs1TX5ArI6i3SfGX0x3iBAxDZWR+jqcV?=
 =?us-ascii?Q?62y2cFfcWDxkCRviSbcTmBNIb1jZDRFIRnri8RUsJAvrFA9tUCuK9BcGtK0i?=
 =?us-ascii?Q?9NKhd6X7hxVcXBYdc8N/vv8LRdpi3bYOZrB1caiE/fY5LYVAH8OJBEiaGfjg?=
 =?us-ascii?Q?Cz2P6TReC4FUkIp007D6+BBsrvzcsgF5PmQJaog8FQDgxjyu95FknLiyekAe?=
 =?us-ascii?Q?1So7NL5NPuTjMNfKs5w0xt54H/F13HshwARquwvbdWWqVC7WdNXDiQY1pocF?=
 =?us-ascii?Q?r3P0q0LIp2+NAIx+envvUH4H6j83LfClKXLWxUy/tgvUfDfXV+Ab7KWuBw8G?=
 =?us-ascii?Q?Lo+Ghr+mOEtWeUsw7n7Nbku/3btnJufCR7nftB+QZw8eZW6KiytPNQmvV0cz?=
 =?us-ascii?Q?j+3b4wUa5MJ8DVsYn/hgD52hpu5zucabsdLMu518Z5zAEeR6QzcvZCGxTsBF?=
 =?us-ascii?Q?gYQNAaQw/WEcnF9yTviWyhKvJXbXdS2ZHJSYfCfhd7Y6ahoDoYU7IzBKCTjR?=
 =?us-ascii?Q?kkAHx465/bqea5rGScrjZdjkGFtTv5lRJI5u26o5iy/n8tqdULSePnNNuszD?=
 =?us-ascii?Q?ua0/4lKsKIfIq3U8y1b4fJ+bbnfB34z+kpByljCJjpZP0OZtGRBwPd1W/6gf?=
 =?us-ascii?Q?qVuMqzgndONesg0LvXK9Ohb607XXwHmN5g1D9BAmUUxi4Su3x8QzB37EiiaR?=
 =?us-ascii?Q?Og2oMopkDw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdcabc65-30c3-4b3f-3459-08de51e9bc69
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 14:49:06.5488
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5WOqXK7OTHpgNcPm+JOvoHg3+LmO//TY5Ia+T0ej5UAODslVAKdsfYnAMcTVGSgy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6757

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
-- 
2.43.0


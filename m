Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013069.outbound.protection.outlook.com [40.93.201.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F3E2D8797;
	Mon, 26 Jan 2026 20:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769460846; cv=fail; b=A/xUdShSBxol/9TpAO6mI7eV59SrnTkoln5n19IYPzWHxG//h/0lcmCroZn8XIjn1NexD2NhRV8p3JbaUTsSUCsZ78jcYTwJW9moI5kwKUCiRvrV+jPHgV21z76OekI3XR+Q0JI949FP8ZMcrqwqCWa6KMrTDoFT3dCpDofTnQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769460846; c=relaxed/simple;
	bh=6+/dqIip2DayP1/J4C7sR9iU6yYoXkQR4Km13jCu3Rc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FaSz+DE/v6ewWM9Zz+pekZzcwMMGgkGxN5BAGJMpA4GISWFYg7TEvxFprsGlyl/PeKe/1+cjC78L5M9Mzdddm7oBjDAk/B34aXGt0xcbYfkeZ1nZB4Pdz+9NZgljJxNNBHWfqr8UrHjdTIblrlAc+JrMgqD2vUd1zCkHCvzmYcI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SaVKxSKU; arc=fail smtp.client-ip=40.93.201.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SaVKxSKU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gpdxl2lm6Hh47pWw5rI/AHTH8XatzXQlm2XgEI9EzBXt1iglkGPGjy3QLjYZygXmIXkgMxVBV1I6ZzPLBHhayDacwzs3I0MfhM5HYUU6yDkm7RAmutfXfZ0Czs4Q7tLwkhGQIvwH2AmdtQaP159PUipp1ZmntlNs76kXU96UhBSWFuNXqvhJoVymhZ2OgXADNy7pANpd+OJsVZmvCOqQSe3zVElqClSum40qD/HbAOMsEZwUvmMLOteBfblCqa/BwwZ9eWj9BYzSlfAIOsoLZf6Ch7rUh4yAWPjDiUnAD+bJqFIgS3dV69n5Ub3e2I3sqHBf7lGEihJNckzpY6rT0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZzLO2xeWPsMQur32Xf813Zc7QojDerLjOJJ8TqO8l5U=;
 b=T1HjP0LmUsB5WnkXUtUbq9TkXG/s5wI3VqyNO/0XisBHQOs5kbOJ4cY1Ie/zdrKZNirpvYqOX/jUvZSr3vcOOzTAtVKyqlgVzijVOuHdRnGRZx9pqzVzdXbgUFA92t13z/5sRTO/MzaZnzdRkN97OeSqaO5lplxKyFNWcgYNH4Gvj80qcURojhuctnU5hYlUWmmOeFFGivFSdOfxFzvsSYId0AihSWY2MXs0lgV8OwW0MZiUapYQS8npxor2Zb7A20y7+IjaWYApCG3cu/hWHXEt2/aqket8IbQpw9HgVhBt9dUlr/KthoQzo0VRrhcv9+kfLTTlxQT28maUuyd7WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZzLO2xeWPsMQur32Xf813Zc7QojDerLjOJJ8TqO8l5U=;
 b=SaVKxSKUvyqlhOgfX6GmHvHkQhHm0aoJWLrSTlQKaCk5yK23DMCXhFl+Y4dOpPX2CTRq/x8LlswZRmwgDTY6/JcI7MOzIFB8X1vyzscGAhT/Y+mgUlwUSd5bA4hL/pzAw/1IJcxJV76FcXk3IC2r+GXj/cTEt8oSl0up+tFFVmuth2gASmVmTdAf63xM2IW7XMw625VXRM9lQsQg3Z1icK1xvJfqlCaf6ziIqkLGz9nxmXuuGTBp1avwMnEgge7Xf1UxY3oNu0hDkkPVHWD3VmMUGhatKHUPQP4gzJB/VrYvS4n8og9CElQ6dL7kJ++k4CPTDFcc1yO41IjUDPiLGA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS5PPFA3734E4BA.namprd12.prod.outlook.com (2603:10b6:f:fc00::65c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Mon, 26 Jan
 2026 20:53:59 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.015; Mon, 26 Jan 2026
 20:53:58 +0000
Date: Mon, 26 Jan 2026 16:53:58 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, jpb@kernel.org,
	praan@google.com, miko.lenczewski@arm.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 02/10] iommu/arm-smmu-v3: Pass in IOTLB cache tag to
 CD and STE
Message-ID: <20260126205358.GA2140991@nvidia.com>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <b151df032c200f4c1123bb184102665ded00351d.1769044718.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b151df032c200f4c1123bb184102665ded00351d.1769044718.git.nicolinc@nvidia.com>
X-ClientProxiedBy: BL1P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::25) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS5PPFA3734E4BA:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b842751-b0c6-4470-bbda-08de5d1d0708
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A/RWcnVnfMdjsvozgfJ6JvL+UmulTmaSqLvWNIW1i+IO9Sl8hhNXxleEeoy3?=
 =?us-ascii?Q?HzaKfqXsqjnnxpOqk+wzt3kmOeRxFaTmknejEIKjaNKj6RxsfkeGpXRWtRVc?=
 =?us-ascii?Q?6LyhKf0zXW2q4X9w55gTjS3B6t+QLKSRSvmNORR49Dii+VzX+zcVL96F+07D?=
 =?us-ascii?Q?qbB2TD4koHdLKfIzzWDao/R4WqwiaZJpOA2Dm3tD8wHQuvnNPGurvXBjA4dP?=
 =?us-ascii?Q?69VuK+8i3VNyPqFGflmWGZJYyPSo1PFToNkwy3FchpaQ0ZbR3guo+cP1Ax9C?=
 =?us-ascii?Q?gwfOQEZi94D1IiAjqimxGJ5HeeAt3LFfUbimlHjBHlNNtUWXBGw+RCnvsRU4?=
 =?us-ascii?Q?wui1YkiwM6ubGu8+iQfwFBbIQUealtdwsLLYa0OC0VQ4vPbigrXr0XCKptFR?=
 =?us-ascii?Q?VafooxEXfgaPFAnVVbool8iF3GSIGbUIxYYvpPJtrGFbBCQPDFCM0oRBnR8M?=
 =?us-ascii?Q?xpw+tE5EwxTOZQPEkby7s9Q9GkjbiNjyw0w+1Zv0tAoQwhetUm12jk1Qkn9X?=
 =?us-ascii?Q?UzXS45ZZ2Y+U0w+FTQQ24iIdPpI8mWCTD5T8FaZH/7eyMhGJGrgA/FDYTOWX?=
 =?us-ascii?Q?EMd4k23mK/2Izu8E0CRrbVg10jT3EotfjgE54N5lwNx5ITXjGcrMXNkpeDGQ?=
 =?us-ascii?Q?p85DqXJvvVxmBcJdfGWWO048ZC2HNiotFSHYnUtDDVOp/mxv0+E4f59P5IC2?=
 =?us-ascii?Q?ExO8pAo8wBvFb0lwg+wzM3WXH/fTFVcCgTF7pfql8mvHrgMjMhROr/QVkz9q?=
 =?us-ascii?Q?kvnYBN7Sbe7ZQs6v5Bcg84OCLSKBouFSvXSvB2hYsxAkVnbFIMsjx46L2wuR?=
 =?us-ascii?Q?sI5iOP+8i+1FE+x+DMIwiy2WPJ9K2wWhlcdIKnW/nhR1xI0Rijen1p5kSAZg?=
 =?us-ascii?Q?QXb65bpm/yH03G3TB4PZGccSGSOqNiLy39oqss4+Zg90pEAQuBLmVKCVZHdD?=
 =?us-ascii?Q?8qFtSzMJs0fY+BSA/JsRif6UTcatqCjYwKYRyT/y+5k7razHeJsXMAWPXr8H?=
 =?us-ascii?Q?C7xKML/ZrOYnqNwcKb5n/JSZTw/8MLG95Kk7uQDfOnBjN8YHHRZUAZw64u8i?=
 =?us-ascii?Q?Qq0G/SDoCWzXOP4TeEaXZlOqU2zQroi6EIdBoe8FWR8qjJru/vDN2gZFNui9?=
 =?us-ascii?Q?lsRmoqKdNmPmxsbNJW+dRCCw0euY7u7ITv3//euvGKm/DnVpYT5zvvR/DvnO?=
 =?us-ascii?Q?PC9F7i+qZ08MrTcvKJis5f06+fh4F42TsWiyb8l84ERgG+3kMiqjuvF2rmzG?=
 =?us-ascii?Q?fhqTMEQ5O5Bshfb9hNCCekTWv7uk6bq6vdoTVWk90Qby++w1cFeJz3EY4yAf?=
 =?us-ascii?Q?3eNGP1hm7rMuz6U9SHnNZ6zsx6O5LF8Qtl4qWAxc/JPI34NS5tSW3Beev8Rh?=
 =?us-ascii?Q?f3p2Czm1xDAI9PRqWYvsUJEd/6IBqHjjrfUxUjkk/PNGvTFPMFJCssx5lCnG?=
 =?us-ascii?Q?CeANYfP6Tp036wZBCEP034uGcGLTUG6LFvQaaovSNEKrDQtvT1r2nTxBlRMK?=
 =?us-ascii?Q?3MQFgHGIs+rq+3+VuL9MLLuFHOF9gjg/yXnLj9iJ8+2ZFWvew9xOz9SDVvQg?=
 =?us-ascii?Q?wCLvaLrVt6lWrdnm2fM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?szBuoIMri6UEUFpUkJFEbVAFfw+lDv9IncUrQ0iDf36IKlveJwGqNatWtSp+?=
 =?us-ascii?Q?qPN44kSAA0zszDth8g7T8ttsW5LtYcKBt/Bt+AJPPZY5fSjxuWr9xYPYgVKH?=
 =?us-ascii?Q?dF9CX8jYBCIRAirxeJicF7hwYdTgnQMwobgfSOVnInlN9X6X5ABbPFdskkcG?=
 =?us-ascii?Q?0ZXFPY3ozbBAFmY+M5iw7BFr1A2RNvkc21RtvTrI6LZZa3OoMxiknVL8kgOG?=
 =?us-ascii?Q?NPxBA6ELLofOPHRCNG2jPsnby7wYvJTJJ5jyNOfQKB+4edSmNAV7UIYJ9yFG?=
 =?us-ascii?Q?VlXMp+ZhL2+CqVJEdGjfXNrNb+6d/HH0Tn7QkJEkz5VhVjpORqeE3PCJCavd?=
 =?us-ascii?Q?YTLrOrIzslFmVPFC71/YkcJCeZ4uxis+BxE885LqivnLG3+yMj7eRzzLn7sP?=
 =?us-ascii?Q?+UR9YEEBuklXFDIavF/R9s+UQ42wvJ1TR3HmVFKZiQY0js4V/POnvEYSJvCF?=
 =?us-ascii?Q?/tJpINIm/JfQtoeZcr58SWwbNQJvwW5v23W4b/C3iUSBaib4QcWhY4mZx3Gy?=
 =?us-ascii?Q?hHVl8Xd51GULO7bd6JxqRfJtbj9CHWJeVUAWZZycKG1qfacehjHabcqAXZdq?=
 =?us-ascii?Q?WrdcHmJia0F6Eh1+BWuhunpAbDnkMPM+RsZ3wnfPUi2Shaxluoeh1vhWSCrN?=
 =?us-ascii?Q?MLM4/Nj2OW0vUgZRc44WInPO2f74SxC/gWk+cHofU5wShXEpiovGhk4uLZqJ?=
 =?us-ascii?Q?00T15uF4TgOACYHX4hI9P/VUMKJdLvY9oC0+mxVZciR5RUEQ2c/joEtxcoIG?=
 =?us-ascii?Q?+DrXTm9unFQ+epUen6MzF5fmWRvnuF8rUbW1YitPNVS2r8n7NbyYq9Rg1aMe?=
 =?us-ascii?Q?PPdpF2co7NSKTryB2s9S6PR1CmtQ0tofYvj5FaPfz5aHny7Di4EHi53Ir/9Y?=
 =?us-ascii?Q?PlTFtmfg0cGOAfWaPqzf+55mwZxgkfZExVSL2hZG9N5VojzC9S9J5Hq5xPNV?=
 =?us-ascii?Q?2sWVIB9OeNsyOZkPGl3l6zvAH/+oxw5TiE1KA35Bf3sVBHx/vtdol3sklXDb?=
 =?us-ascii?Q?+qk8gTZiK/9SLWYPmZze8DJHJBKMCeTqEZfxu0lLpslFKGL9q4XzWB22WgWH?=
 =?us-ascii?Q?uJ5rfLSfThQaHUXvgdPHB7Gcs8DEl2la7KvO8aC2GEPczQg6YDwvCmElg+iD?=
 =?us-ascii?Q?HPAW8R6PWhEqCw0T7ZjLs1PqRHjRhyrN8SIjwYzVZJ9qjYNLqFoVwfaMtVE+?=
 =?us-ascii?Q?zN1NfRQp6h/STxQSKctdD7eEAR8C2MaUJAEIxAqg0DJ5DEZ1R3nxKU9TSLDh?=
 =?us-ascii?Q?6lLpytehT36FYWbaU2sUycXt/SZVn2DAZSXPG5FiFs8J6LkDamCFPeP0SW4U?=
 =?us-ascii?Q?+LhooybJ3L7AoOkYsTh59wxOMUFmaz54U27nZmmUvUw4wth6VJNOgCkLDylu?=
 =?us-ascii?Q?oEarNjiC4dj62oVSKBBY3zXNVUeJxgkWKp+GyU71VAfdv4eH0s5Z2BO5kUw+?=
 =?us-ascii?Q?meJOZC1RHGvuRdLHuO+8RdkqFdEBfPB6nt9NbzUTHP9olymXjrvUC05P0T6v?=
 =?us-ascii?Q?j5dEsa7M9VSEeNgxn3A2fthzb56cpQnlKIR7zzG2W3ZXRETkdIYmLWSksptG?=
 =?us-ascii?Q?SIvcJm8q/cU5Ktctpw/S6zF5UNY3/8MwJ14/itd80fEvzhixEoTdvpz0+dDk?=
 =?us-ascii?Q?NWM3x8Si3G8qy0/m5BKE1p6Pj5F67RcUxQQn+pNl21B8mql9oycqMmmQfGuP?=
 =?us-ascii?Q?iOl4wZwOsNnVvdDPOuI1/XMLWPI5kv7dpdSp2iqj9kd5gT/NhKOHP4ygUmzw?=
 =?us-ascii?Q?31eGe3bc1g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b842751-b0c6-4470-bbda-08de5d1d0708
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 20:53:58.8700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wtxWhF2/2bqr/+AHYRhLadl21K16mgFT7VFpG6afRKVcz94FgBFUOyTBic+HGEHG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFA3734E4BA

On Wed, Jan 21, 2026 at 05:24:20PM -0800, Nicolin Chen wrote:
> Now, struct arm_smmu_attach_state has the IOTLB cache tags copied from the
> cd->asid or s2_cfg->vmid of an smmu_domain.
> 
> Pass it down to arm_smmu_make_s1_cd() and arm_smmu_make_s2_domain_ste() to
> set in the CD and STE, removing the references of smmu_domain for its asid
> or vmid.
> 
> Note the two set_dev_pasid callbacks finalize CDs in arm_smmu_set_pasid().
> So, it is safe for arm_smmu_make_sva_cd() and arm_smmu_make_s1_cd() to use
> a dummy iotlb tag (asid=0) because arm_smmu_set_pasid() will fix it.

Maybe it is time to fix that up?

I think if you make arm_smmu_set_pasid() take in a function pointer of signature:

void (*func)(struct arm_smmu_cd *target,
			 struct arm_smmu_master *master,
			 struct arm_smmu_domain *smmu_domain,
			 struct arm_smmu_inv *tag)

It can accept both arm_smmu_make_s1_cd() and arm_smmu_make_sva_cd()
then call them at the right point once the tag is finally known.

It may have been tortured like this because of the (removed) BTM
support, but when we bring that back the ASID for BTM should come from
arm_smmu_domain_get_iotlb_tag().

Otherwise this looks OK

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

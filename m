Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867C61C75E2;
	Tue, 18 Feb 2025 20:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739910110; cv=fail; b=XYCMxBVRfbVmjFwsc14l28mexHDiJayW3UOyyjcKDw/3UV/UQZNoTjkb+NU/6GbZqk04ToEdtjJfzHzUWRm2mcbKn90/4uuBpXNEK/pqc4zzu3HbIgS37zHHiqT4vQHKxzU7cQ+Pd/Z4ureRCa7yTh1zDgE3w6EcnKLQSh7xB0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739910110; c=relaxed/simple;
	bh=WB4AIr6mwrAZU0XIscD+Z634V/U3hyFnlFQRm33u+FM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cg5ndj9pq81EVq9UAN5nB+YCunrS/AO5BbF8LgWyDsSsz+4nDra+bHzyYk0nPBhVQ6IAiVuHtxarKEbKedAQoHFCjv9oFLsHb+qtbM999CIuop0qbr5XEf1fnE5Ewv1+WSJ7UNCcv0RBiDEiXf3hcQc+LZTkaV9nVEmxZfqV0HA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=a6VU9ey4; arc=fail smtp.client-ip=40.107.92.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a6VU9ey4"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mFsDqQ1rPbf7ipypzriMSOlYGFJDjH/bIkSn3VvTGxb4nByGb8XozcA5Lpwd3KQ8LhkUc725+LGpsJA3LJlUVc6PDioDr/pKFhHeeuGpEWMLtUrx2uTeWm4XqpXYcEYE8s4AHJkFmlqB1FWv+9P4s9nruXw7a9k2/ZM7/6tJbEMWGuKXA0n9u/63YnExtjGwmfBVmZP9lUKfpD6Ul+lRonW7tCO+kRLrJuWBMOWQbaEkqI22Qzkcl55haLP+q6PVM14P/6Ossn31Um1bR6qDVFKAhdGz7wfRllvTed4/I40i07A7m9wTWwgzTh2tcx8RIUG+TjdRnX5j95oky84wMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gwI2fTzhiuEPlxGmgCGkTCmcIw0EekFMHq25GTchQtw=;
 b=OlU3lLy4t/IvJl1Jd/smYtBTj+bPf2uMP+ZC+1k1GailNduZfdSZ6eLkYFI4lHCW89Sjv0YBt1AeiGS5OtpIUEllsVjN9G3u3qM/DgmljxlyLvkjXzZT7E3gOZ/T/I+3xDSoVG7JG+Pqyx9Rq5M3XHX6NAp2/fDFzErbHb5gVlpCEgHZMMJJueeMQWy7g7Stc9kGb0IWQUl/JpDqK1tG73JTVltZhw6D+fy6Ugdb6MOoLIjLCl1YwA8uQ/rXW53W03MWpm8tz8al/PfdZ9I+GXq+Ur87f6CohZdcNgZbcaHhAMFJzdw8nRbkK6U8JectFwDNifiTwIrKL5t2Y5sKuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gwI2fTzhiuEPlxGmgCGkTCmcIw0EekFMHq25GTchQtw=;
 b=a6VU9ey4EfbKvRgAlCqTDewHeIZrpHcWw/K6Yebg9qDzocv0P7Sw41AeYXbKy2GnY8Zife/yWU8bKxivhyaWC29NHiw1gQN2FEjsqYo5qJbvMgHPuYD7kinORdXKUPHEIthAYnjh1JMiYhTzDW6AGpjEIPzer1DtgXgLvWjmCvS+zuI8jq42MDvqd7C2faDFh0VRr1MHmsrBe+IioAAL2P66Ozbxdkt+G+zSij5w8PnPSJF9ulrOJihgEGUAvjpTJ1R4KyxcnXMXhiKDRKFJTffntCwHi6D5r1xqIIeQT8foEN5wcWrAjOa4Y9f4nZl5yvfjNe5u3LlDMH5bH9oZWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH3PR12MB8330.namprd12.prod.outlook.com (2603:10b6:610:12c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Tue, 18 Feb
 2025 20:21:39 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8445.019; Tue, 18 Feb 2025
 20:21:39 +0000
Date: Tue, 18 Feb 2025 16:21:37 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>, iommu@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hector Martin <marcan@marcan.st>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Holland <samuel@sholland.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sven Peter <sven@svenpeter.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Krishna Reddy <vdumpa@nvidia.com>, Chen-Yu Tsai <wens@csie.org>,
	Will Deacon <will@kernel.org>, Bagas Sanjaya <bagasdotme@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 23/23] iommu/pages: Remove iommu_alloc_pages_node()
Message-ID: <20250218202137.GK4183890@nvidia.com>
References: <23-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
 <d66e555b-8054-4f73-8077-201b51139773@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d66e555b-8054-4f73-8077-201b51139773@linux.intel.com>
X-ClientProxiedBy: MN2PR02CA0013.namprd02.prod.outlook.com
 (2603:10b6:208:fc::26) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH3PR12MB8330:EE_
X-MS-Office365-Filtering-Correlation-Id: a45c8cdb-d7ba-47fa-e94e-08dd5059d96d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dpt+4OLMxGGYLmwVB3KFc6PGP1WFUXAuKi3Zt0/N+QK5Pp6ouJwJSuYrohYW?=
 =?us-ascii?Q?0bv0bYE7w5PjrhDgYvJ+UAmwF5zI+idT3v92gPlqU/XFq0Ndk55XOA4tMlF2?=
 =?us-ascii?Q?bbDHVjQzHm+N1ITvtlfrdjiqkE3Qn+Nr0lC7zhfseyqrpsjIE0KozoIc6Dyx?=
 =?us-ascii?Q?54FFKPnH7YbNZKaEFkf/GtVfuyD76asXuG2mD6U4YgeOb4g8gL7byrtteBE7?=
 =?us-ascii?Q?VvGmZgikDmO3k0n2jGveOSYHbJ198jcQc9pcdhtBGpisJc4k4n3LL3k1V6rE?=
 =?us-ascii?Q?4sbXKwzPbD9REyEz1jPEqBtCnRVWumaYptm7gHu4q8x6Yjzx4K88pUJkYZXy?=
 =?us-ascii?Q?QJm5wHpFtw/Xx0/LLmZM3yGs81PdZfACKusLbi51JNBrHmYpBbpyo/6KLtq4?=
 =?us-ascii?Q?2cCjtUj6HH+cRDls9RZVD5HjoR6dMKLzdXDHXu+wMyNSGtIGjhd+iNJAp3dt?=
 =?us-ascii?Q?dy2DGe54AkfwdIxPVf9m3Bce7gQESr/A5rFIBULjGCylomA4EMHlj6OwrQuk?=
 =?us-ascii?Q?IonbRM7if876zizLZ0os+E2rjHy/25bDoK2ylg0no9eKyz2vsp1FoLyCvnf7?=
 =?us-ascii?Q?91neonrkgYXWDlUXbYyaZZHGZ+HipsITuB5lfW/A7fRpu6gKEhzRFeMVYIP6?=
 =?us-ascii?Q?WS/OOWX0pFzKXVVJsgKJzY+tVbWckuWCQTNa9XCnmpb88qk5LMVH4+GJzovi?=
 =?us-ascii?Q?rwSIlxDJ4dYkBXuG+6L3KqJ9ilGA2gWvvP1FyMvkQo3F5mPKE6+LDoMcDR7m?=
 =?us-ascii?Q?M0Elw+W+qyPk/bpfCXsly4Toux9nm12LI7kUGlAnVJKu3hdO5xBfGnDFxh4S?=
 =?us-ascii?Q?Y7BY6PYvWlpfGHVpZ4a04QL2l3zNulhmWDwQ+EX9PqQZH9sHwenbZMgbDIWR?=
 =?us-ascii?Q?JZayRgQCuLzBbfXXk29R0xpB+T7RnqKPyBnwWNDvZa9n1N+BuMDT54CU9BMh?=
 =?us-ascii?Q?+z2Ca6JdQBhvzhPkOPRMs4O/hoOTpLVeXl6gf/Fm1ckKEgOumpn/YucM2rWE?=
 =?us-ascii?Q?HmrD8J6W0zJ6+v7z92bFJmKB5A2DnaCHLLOJYOaP876TfvcVtcdmUxHol7YY?=
 =?us-ascii?Q?FvHfRqoUvOKCCD2nxrHg0f0hBzt87QmDhN06qmw9bvD4Jv2YdnhEZ3J06Nc0?=
 =?us-ascii?Q?u5tyfJchcFX8DU47HyodGyTCx5f1lTdtBTZvOI9X9z8diyxBzN2jC0IQzSEh?=
 =?us-ascii?Q?ohlxwr1nl/E0vcIFMxGJ90TEtlhtkj0tHNmuCsDMr+ahaGP+KU9+Jo6jF1C4?=
 =?us-ascii?Q?ynozS39lysL9pBbpAdgmO8MVlicXpAvlw32TOWwPWJc/kRSLokQ23Q4lMa+d?=
 =?us-ascii?Q?Bl/B6CB7SNrjQ86F7IPXBL/T3nSk8WcQ2QzufiRsud1G3F8FCGCD7STIonCA?=
 =?us-ascii?Q?z5sQFqcNIhFBe3+iiA2mWW0Pdwuw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nMfm9CcDTQ3v1Vok+88N3xmm6HwzmVMI7VUlBA4dOHYmJkCt8ZH9zcEpZNf3?=
 =?us-ascii?Q?IJvBzSAXEfaFyDAIgv/HrQG7ryWIx4IB3M0KKp3UltxfaPycaO373Q96cVd/?=
 =?us-ascii?Q?bDKGcAH941IBjfJS/LTrrmUmLxNxzMHNbxuij2rsur3NHCIuoeygmfzn90ul?=
 =?us-ascii?Q?lAT2Cp4EA0IZ7/XjGyEYRKrb5+uiE+RMZVzewKLfKncuufUcZAFqg/3zOYLB?=
 =?us-ascii?Q?JrRtJvcqLEvG+/VrQucY/oA2W9LC9/qvBerB1CwFyOmtSmaQ5AEDqWuVqcK8?=
 =?us-ascii?Q?Wx0cxcCzR5ZkUqp2oL7DH5geAg194HfPhYTTPke8LSzcyZS2ub2w2q+T1U6v?=
 =?us-ascii?Q?sebf+C68quenlsuI+G+sGdO57yfVhU++g3wZSyIDF3Yh1Cvn5TAT+TLkFQwv?=
 =?us-ascii?Q?NCDdErinqQzMtsA0vJV5PuA+hpyxNJ+M2h7MeZVp489UPKC1W5bzAmwRDpZp?=
 =?us-ascii?Q?aZsn6UmFTVHvIqgQTlUTmkIErLkXOHyPoIM2puhnH4KB3LAVRtS0KcOg2VXW?=
 =?us-ascii?Q?q7qAPKqjOiExJUFSv3EwOV/ZS1ANIkpPj3Lp8nulVhuIv7mcVbVIzmvXzuFL?=
 =?us-ascii?Q?vL/dhF33nGxzW3r5En4M8+O8ANEEyBCstzXfDylAjLy456SR3nC/BU3T0UGJ?=
 =?us-ascii?Q?wzIphJzbkOYj+dNKhQ7qbwyM1LyHncAHz7weGNLsCI2bcpN0oEPfLQsQ2E/c?=
 =?us-ascii?Q?hifDYdZ6YjMZHE4VK1JQxyGmerEtFR2UFWppkbUtrnvln9LRTnN0m0Sa1Xmq?=
 =?us-ascii?Q?vC8LOgxLTFaFrZte0UXX8/dslCYVIOo41Jmft69bHqcwFFK14FisYq1rA630?=
 =?us-ascii?Q?lHnZunkartzM5jQoRz22dJ+x0Pg6YU6x9KzKbp7GMLEi2iHSjoETB0TZTxRJ?=
 =?us-ascii?Q?UzhrCpS4CO8A5Jo45R0kt6QbncH48H3/9fPmcGo2fGJEmmPVv9KdvriUewWo?=
 =?us-ascii?Q?18IANkN/9ZusIzWPJwwb4o+rnvXjHKxK5XxxCgB6DLxQdZEkILfJJFS7lndp?=
 =?us-ascii?Q?ByLJhWlTJ9M+VIyKJ7kmgsL0k9/VEJpU6UC2QLHxcIUpdFaDsxWCHxtKEYik?=
 =?us-ascii?Q?9+myc9StATljYT6wrGM1gst8dvstoF6bOCIRAflJTvzhfg6xlysy/Q8ecMBe?=
 =?us-ascii?Q?fmOZMJkpCJR1y5WTnX18BvhgpTyIjVCNVr/aiFFElmzSl8ym6MAbKng/Q3v4?=
 =?us-ascii?Q?C+ertAXa9Yo0ZuZOAJJB4lhTYh+aNUGNp6hYIbhUx9vxfq2Ma5lxJxgP/rM9?=
 =?us-ascii?Q?V9mZqSwh/M4hUeE2TFxGUApgkyAspNoB5OyOMUhJDIeHGKYdj/mnueQe4V0F?=
 =?us-ascii?Q?vS5d2ftdV7CKoVu327LzyEH3IYDPqU3MpCEwsizbsoh9rYJP/PofvPWZfE0M?=
 =?us-ascii?Q?Z8iQ+EYSDuqxem3K+B28v8FlcKjoJ2EVhRNExK93nOTH9IE7Dx6lf61q7Hwa?=
 =?us-ascii?Q?P49P7OTuzBtpooXZA0WN44s3MfOP/m4fy/nxy3hqC7d1BpE8Go1dLLyPQIAM?=
 =?us-ascii?Q?V7FggbVgmwUf1amdyS0UMn3b8s6pkLJp7gy7SJy4tkOjh/DN0HkpPdW+KfZW?=
 =?us-ascii?Q?oZIDT57y42gmn8S0QQpvixtHOPTI7JZKVjHUnw5m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a45c8cdb-d7ba-47fa-e94e-08dd5059d96d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 20:21:38.9165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: egLtCSmFfs5GlFFfWIuz9++48EAP70XEeBS8xS5FLG+4qZ68f/y6OaR21r79L8mx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8330

On Sat, Feb 15, 2025 at 05:47:51PM +0800, Baolu Lu wrote:
> > --- a/drivers/iommu/intel/irq_remapping.c
> > +++ b/drivers/iommu/intel/irq_remapping.c
> > @@ -538,11 +538,10 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
> >   	if (!ir_table)
> >   		return -ENOMEM;
> > -	ir_table_base = iommu_alloc_pages_node(iommu->node, GFP_KERNEL,
> > -					       INTR_REMAP_PAGE_ORDER);
> > +	ir_table_base =
> 
> ... here?

Done

Jason

Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FB122424B;
	Wed, 26 Feb 2025 17:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740591088; cv=fail; b=rXjHPhi5V1MoJo0WdVNhUDUw6i57uR5hnLjKNHLwb1zpvh1ZJfgxECMZbjBZws8z5M/9tmxE+YWFp9ecaHKo3oqKwL47mv4oKYl6O8NfXBcdFyvi+Yv2rBZH7rUNECVpMVwLOENamQDpOaV0WqBGY7E9AhI39XGH4lBL2Iz1cB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740591088; c=relaxed/simple;
	bh=d3IYls2wKEmmgrXCQniBaKRiuAyiSVQA5auAaRzHENI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nHQ73tmTtQ/91acEXWlzcMQQRE/qWQUxGaqd/X8PLYBAYf0gF8lYaIL2touzF0D3iO/W/d0gsLowtuSEa+qgy9aMaVSd6oKRo7m0J7jsCO6uSDbFDp8t9qjrxm6QbLCh60qyeLlmegiwBmvKDwUaIQ0eo7xeRzBc/hP0LuCIz38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uCI2Ggce; arc=fail smtp.client-ip=40.107.244.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uCI2Ggce"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BdRpkyTAxt8cy9294cNCDXczftj8owXylu3PdCuccf73FRo0A5zxuyCgbY0W7ur4zEnnm+ojQ4gLY7kRlTmA2e10mTtzEbauwiU5xnVxpHcQ4EInB6rZEjKk//TWdaxKHph0gquMDNExfF1e7AhjZBx5Mo0BcmH7iXS3tCefWVPWIJRxT1YaQ/RoXDM0IiAmgVRvlJfzKv7zv5fuD0ApFnoy1UbOYfSTtw4i+mLMPmEIox1VawXJmGmzPsTT2M/yEEeu77apAtY7K3UksPUBMVGirGIOywAJNSE6uRLNk/yzqXU5YCeN/KuFmDzWeuRaNl3vesODkTPYHlJjy0pFBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jH1gbJqdnymjOjrMZc2TwOxvlhempEA0Xp3dfPhfhv4=;
 b=S13NBL71mFkpys/ZN4NpKPcN5LfnAGzYhw+iOoTmAfTi4NbggpjrESwZY3vn4BqHIXIMy05k7OkAWdw+REmYiB+KwWHLwRh3PA2EpWWFBfTiTGkD0O5OFPZF8S8DqKc8paYAWWViRx7HwkXAFTiAJAxkG8jXG6DXCzpKFTTPq92XIKFfHlYvKWCS6xMVRNFmVOXqoChxUmKFRCP1s7xAyjjnIr/wkScjbi43pCduKZ/CT9E06vL41nP7bqV6qGaEuVs0KLhgBsUB90fZBvDr27iIkglAiYiNlSNl0GZfxQ/S1+LG56rnJxmnqkW9lFyeB0TEUnPlf1wXX/5JEm0i3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jH1gbJqdnymjOjrMZc2TwOxvlhempEA0Xp3dfPhfhv4=;
 b=uCI2GgceAF65vZ2DaZBlzP+u9gwHNhc88gJ0PnhD14fYu6jRNEDZV0uacWbt4WgHgAr7J1gyH0Xo3oXGcAbqW5/un88kA4bRomkUa72nlWdA8WV+qirq1a+dNxUUofaxpBBdxIvP4fVfcaJwVSvWk97T5cps9NFSbCgdibrIDVxRRGVjOpb/7wPwswmYwlp4GmilfqBrPOxQHmRjlvlVC/YXRn2u/c01elfIaqh6oelmG2WDooeW1zyxgcDIyFfPSSb8wcRErcqaMqx1qPE5CShe7TNPa6CojZzgQ3MFkbLVdnQq42CVw2eMMXjZ4iCOmFY/bYJU3fV8zJHw8J6qPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN0PR12MB5762.namprd12.prod.outlook.com (2603:10b6:208:375::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.21; Wed, 26 Feb
 2025 17:31:22 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Wed, 26 Feb 2025
 17:31:21 +0000
Date: Wed, 26 Feb 2025 13:31:20 -0400
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
Subject: Re: [PATCH v3 09/23] iommu/pages: Formalize the freelist API
Message-ID: <20250226173120.GA37280@nvidia.com>
References: <9-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
 <6d9ceeb5-581e-48e8-a5cc-100a9699a9e8@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d9ceeb5-581e-48e8-a5cc-100a9699a9e8@linux.intel.com>
X-ClientProxiedBy: BL1PR13CA0159.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::14) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN0PR12MB5762:EE_
X-MS-Office365-Filtering-Correlation-Id: 43d944ab-c2da-48a0-2007-08dd568b62e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NXHHgZiJbrp1gMHqoEBXavAIUOF1eQl9ydqmE34+bsL/W2ny5ynsi7qllCeA?=
 =?us-ascii?Q?GtWjbjYp9R6LVeuvO1e2VQZ+JkOIQhp/YxJgb3ZMAjh2QPfpqKUphFKxvXes?=
 =?us-ascii?Q?71SwQ1apZQTydisMk/4Zm075F42Jckg2zgj52QkpHRMV1Lx+Tewq4wSTnRpo?=
 =?us-ascii?Q?tHmzCzqP72Olueh+5lqIJ24MWgdcbVReBWGidWr//e46XGCgXY6eMlaid2MW?=
 =?us-ascii?Q?0y8CCOjGwzVcGHfbLR8jNVeInKk9aRzDpSYE0GHyOFVSNWYcdpyaefuPOBsI?=
 =?us-ascii?Q?1Puj2JVq3Te8y50g6BqLSa0+WWZ5sK+BPUt+fLEwD1KqP2RwUSo6gdolLw7L?=
 =?us-ascii?Q?WhwRzr/cGPJRM0PybIRwWIBIUHz7qQnoUVFQgloIwif2Jdww9EdEUMdo4rK7?=
 =?us-ascii?Q?M2S6/I2LTu/KbDpG+Wys8PZ9gRzF1hNM9JcTI1VcRSyUU8nP5FjhleH8+AIR?=
 =?us-ascii?Q?zAmSCBYmvFAnIGPfCnFxRWDz3L5BYuAq+ZuW7IVm9O2P7kiTGLhLxrt8m/jW?=
 =?us-ascii?Q?tZkuAjhkviC/6JZrhU4JVkEH4uCCeU39iz/VT+qhwCU2rGSq7GGdNeutSkwA?=
 =?us-ascii?Q?pkIubFaBeJ/2ZjJBbK4Qy+j4GXC061aRIe/g1gsHpqMbx2/qkwC3YtXAAOCJ?=
 =?us-ascii?Q?L74pBSLI98HZOdafJUh7VEUSGaJa79DiBdFBfpYoAn+bBYbC+hC5PZaQo3+c?=
 =?us-ascii?Q?qhi+IX2doWDDa6+aZhn1x136x0LQVpaN1UmwzT4JvrHABvqdlyMyD+E7o2bG?=
 =?us-ascii?Q?t2Zq0bkkNxrGLmYUPhG0SOcXkGlWh2Hcues06UTTPIiYtvzkldKGx6Tot85d?=
 =?us-ascii?Q?386Pyo7LzkH4vB9OLqtQXYMGWVSVMPiS4QcnyURipykoEj/dJzgEXQoI14XE?=
 =?us-ascii?Q?/YVISMBriD1HQUEwxW1ctLTxYvQRD6KQQPqg4NMQx/G6X7Arc7LEeev1fmsx?=
 =?us-ascii?Q?n7mZAUGSeFxdsCQcC6IeSNHkzhQuE43GlLDvFZFcl4Nb7xGDtNVEk/nXMVz9?=
 =?us-ascii?Q?C41hizLedaE6Ga5GF9R+HdQW+GvpVanREV+xvzHlo8CA0f1MGjDQDK9O/FgR?=
 =?us-ascii?Q?K4of376yZgd3TV90No7L5e/Gh+x7P8zVas1DKRF9XuAQ/blij06HBjH6IJd5?=
 =?us-ascii?Q?rCWX7k8nuCvsi9A8orS2uNCW7DYzhyjEg6E3N3JlkMsx9oErqqH2zVc0+93a?=
 =?us-ascii?Q?1bMBc8oIYxb3wDLg6sOvz88YH15fcM5OlDF+CDtg68D8prmVIMVpNR6U5oRN?=
 =?us-ascii?Q?5L8n8qd3rqrV4PYuO7dMCrPrcamztmMAW+dEgpLewhHE5i0/ZSmbBECj7dMC?=
 =?us-ascii?Q?4c26OIH/IveHZ992TKYOUDubaLCvGLSVxKnAZCSLt31sHqN47OZinEv1LpOC?=
 =?us-ascii?Q?lU4xVSfJlJbW3LEDWZ8VqqLQaUZ8?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aN0ougez7Ze2RQ2ThsiCBuQw5RdF9ZFQ9g30OaznUov4X/frKUSPlGFZ7wYd?=
 =?us-ascii?Q?tR/5P+cIle34ejYphsimlFSXPFi4/M9WQYou9v0fuHIfcf+l+QRdCz7qrMSF?=
 =?us-ascii?Q?QcbTRC+M24nItlKBGUuLtvwCwswPmDGOVImVyyzF/Qyp149BUtlsN5mTHfY5?=
 =?us-ascii?Q?DN7YjmnPTdCCrAUUeJWf02U/ZBOLzRklY1YzXZVFLXEjks9GV1Mz3EJNdJRg?=
 =?us-ascii?Q?JczfjJdqAagBxQrynOZGcHFGt4Lwz6SOg2u+5jzkElFqbOiLXblvVB8P9Oxy?=
 =?us-ascii?Q?6sz5WlJm9rVCyJzBdD6ydwO68XozDqEIL9kZgNHyLxI5gLzciI8Y1VOzN80e?=
 =?us-ascii?Q?zCB3AeMS6S8Qwbd37XodEgfU03I4QcipvAFs18g8zLu5G3M3Aup2PNZzNGWu?=
 =?us-ascii?Q?UEGAOv80Kt1epZoJlWg7ujOr1wfX4He2eHRcuRUwA4cmnfh7tfV3fMUszM+a?=
 =?us-ascii?Q?S6XGOYMvpc8N656Xkp5gO9QqUX6QepDTuZvT4jFVb+trN+/K2NZHk9vcFAFf?=
 =?us-ascii?Q?fV845FWBb+bHHqFrUpe7mjS5NdoqVZjHD8t7VbaSKOi6LPGASBzVaEEEWOxA?=
 =?us-ascii?Q?lAA9z4Lthz97SCmfXUrufSQondt2+YDcCajXdgHIgKrAQyNab9ajzuRiGQ1Y?=
 =?us-ascii?Q?LezjoKivaNa5aVeNSSymptidXrNbYaLLXCmPS2nyWc1BYg4pALKyKboPjrEu?=
 =?us-ascii?Q?ZRaSIEkKRZB+4fA0kOcX4en3K4HbMfqj58QUEfZWPpzWE4wf0OOOGAFVQfFH?=
 =?us-ascii?Q?HCVsfOIIJJI3larWOy8tJz/fTR8o4tJ45mXd5pls/v1G8B0iiF5TBoc+OEZX?=
 =?us-ascii?Q?WC9d5MEhViCaoOb1swBYapNUvIeYV1CO29s7hfoZC1nZLyzotYtCCW+TwCHu?=
 =?us-ascii?Q?BHllmdkcMDeqyH8WO/jrgbfkr9J+nO7Bial8YUZr3ahNauBCq6CqTMX5wPnl?=
 =?us-ascii?Q?cDlIDj3Z3Q5WSQDmunhma0h6uyQ2NFNWh3XU5otu3KlQFVkbZ6SpJmmag5gF?=
 =?us-ascii?Q?G3rvLcGemUzJuljncg/U4cgL/YraQwvdnYYaa1GsXcGBz2JmPkzZpq8qruk+?=
 =?us-ascii?Q?q5f6H5kxb1AqXuJQciDcIMXC/t3fpZ9NLje/Y4jNhDwfAAlu3rJNOss3aGbj?=
 =?us-ascii?Q?zSY5yrRQf2LSLUrEnfH6cdCahMA4n/hwejKUxQBnQZMXSDVm4WUoB2Ekawwd?=
 =?us-ascii?Q?V59anBYa58F4CkZJVbu3begvnSYNDWH5dUDQrCulr0VQLvFG3H/d/BXEmihw?=
 =?us-ascii?Q?x9fk18/l2jz3Dehz8NdPIgbyfda+LUBsuWDhQ9pFViA7XY6qAaVc1M6TSTRs?=
 =?us-ascii?Q?TxoZQ447poPgjT0Tvl9DwHy0zqIdJfKiSVBXWQaSxWLYq70TaIEXuvuA4Dai?=
 =?us-ascii?Q?YGuHDqr8n7tPx6VE993tzZG9d77ws5hEm/4q3sUHlIJslVFtejWVKGDPD1fC?=
 =?us-ascii?Q?T+EOipP8I5lQY3jJvU+n4lLlrJrGIL1596IjzgHdL3UHgvT7KlHSZl4Xx/ul?=
 =?us-ascii?Q?uekdZ9tCoi4onQCVU+5xHSt68pYwVUeOjeld0b7PRhmWtz1bqPk+LC2Yfo/w?=
 =?us-ascii?Q?KKFkGZpBb05q7JtYA9oGXLqEGs99g7POH2VInV4S?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43d944ab-c2da-48a0-2007-08dd568b62e1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 17:31:21.8251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BwtldxbYbGJuzpMfqCYLz2rsybrv5Ayk1HZYrB8m6PRQI9h1ZIJPG1+rOQqDlNMq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5762

On Wed, Feb 26, 2025 at 02:56:29PM +0800, Baolu Lu wrote:
> On 2/26/25 03:39, Jason Gunthorpe wrote:
> > diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> > index 38c65e92ecd091..e414951c0af83f 100644
> > --- a/include/linux/iommu.h
> > +++ b/include/linux/iommu.h
> > @@ -326,6 +326,18 @@ typedef unsigned int ioasid_t;
> >   /* Read but do not clear any dirty bits */
> >   #define IOMMU_DIRTY_NO_CLEAR (1 << 0)
> > +/*
> > + * Pages allocated through iommu_alloc_pages_node() can be placed on this list
> > + * using iommu_pages_list_add(). Note: ONLY pages from iommu_alloc_pages_node()
> > + * can be used this way!
> > + */
> > +struct iommu_pages_list {
> > +	struct list_head pages;
> > +};
> > +
> > +#define IOMMU_PAGES_LIST_INIT(name) \
> > +	((struct iommu_pages_list){ .pages = LIST_HEAD_INIT(name.pages) })
> > +
> >   #ifdef CONFIG_IOMMU_API
> 
> Any reason why the above cannot be placed in the iommu-pages.h header
> file? My understanding is that iommu-pages is only for the iommu drivers
> and should not be accessible for external subsystems.

I wanted to do that, but the issue is the gather:

struct iommu_iotlb_gather {
	unsigned long		start;
	unsigned long		end;
	size_t			pgsize;
	struct iommu_pages_list	freelist;

The struct is inlined so it must be declared. I do not want to include
iommu-pages.h in this header.

Once the struct itself is there it made sense to include the INIT too.

FWIW I have a longstanding desire to split iommu.h into
internal-driver-facing and external-user-facing files..

Thanks,
Jason

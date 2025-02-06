Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2065.outbound.protection.outlook.com [40.107.102.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5332E18A95A;
	Thu,  6 Feb 2025 17:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738864095; cv=fail; b=IxSCHOcFyLGf88vvACIa3qQ3ad4Z5whaPAwUTeOavpY7tLZ0My4mcOK9Hp7fXVNTb89VtsOVmTOgKUnco7udYI9Fvhb7m3PTvNgAkUWZQpBbEK2X3vau9r7ne11HpErlxuffymc6n6hgfKF/c7P66lfTouXAwy5s+F0rNSrV740=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738864095; c=relaxed/simple;
	bh=S5ccqlTAB7oizqzquc7Rmw0cF9LGaL45DE49KtqVV9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r+8fhRuO9tzXD8w9jYbIYJ/EQYeyYwFzKqHIZzktnQ9CRrWh4zhJ2TGHUI7kTpTWukh169Qai22KiMNa9yOzWF+l/7p/3M2I9eTXzqYhzU7kJe3WVyr/ui1TJHx33xkuSrBmAGIR/jvnWIPpwDEwtQOe0foNNRuzPjHVVJ2D5bE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iteiJeiG; arc=fail smtp.client-ip=40.107.102.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iteiJeiG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I9NE32ZdreAZPj2MaPUSBiCkg35knqriNdeVq/qIVo84vL+iDAs+8cWYlsD598i1KWrQsJFqmAzFa3PkPrj8KbHA5ygWxFC3IzQD+m3GQICPqJFNJLrHSC15Sby0bQUuq3qvMPOI77JqrzhNbnVXJYZTuBNyESPViujKM/JWlVn2cjEnXYjvVIZ6eiYfrKnxEtBbBnSu8TW4eNZECa7vuKbmQCXy7MUdF1agLLZm4Amj6HUAe7HdIn9RAab5O/zU2Rg19k2avU71hlPpRCSSHfBzK9mFNErO6JRvUT9qfoZIaC+9h+aYbVCtdR8vhCh2WWUT4QhLmP5ejkVUqPqWzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kW8Qrz9B3P3zYKqFJs0jd++hV5Qr6xS1PmxTkhIFD5U=;
 b=hIpTqbziFrq6/Q8hgRO90CmEcxLi+7//2Y8OQ/t7GIz0mpVnO2Rcjr2ALEFJkfQhA7z5PO5vtNlYa0dhNsP5ElTFQvKRhmxNMIzS7BUZJLMdsEaVDOVrwtof/XQJsAZzAZ8JHhNxnhFAJWQkfO7+YWJdhRFWhB4V0DWJLjWjvT6KFNP6xZoTwXaqa0++1p1b8cb43V3ncqMgCdcR3T0WNtZ7x0ahWKBwKYztFZZgSy6ZMQItj9CLQi4YN+yILeO2lo72w2xLnu7xpqnF4xLm+I0wII5mZMbJjEX1iAf9A6swsS8w0uY4ZgKBVk3MCnSTTkUsmRgoJ5B5OSp59cXtnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kW8Qrz9B3P3zYKqFJs0jd++hV5Qr6xS1PmxTkhIFD5U=;
 b=iteiJeiGhPOjZf5XrS+ob/r7KEJVosDvNXV8xKulQmo1l15Opkt8MAFM9TMZbTAq/peGDUM1eh8Nc2fhK0sw2UvEUqw++88kwD9tGizyf1ZD/Ck9NYdIEgKDWzSzMWAyoP/S+VAINVmXfpmMkrNfZbHmmh/38RpblGlS0HOeh5vL//HfDOQZ03ZFdOWx62MkJiD4TTEOJMgjU1cNUUK95hsB3KGClT+KPIMm1mxRPp6+JcV/VM7NeaFKrh3ZKfNoTEClOXBm+EGHi/KLs44Fu9MbhIJwV7lTuSyAJWATD61YIQfNHi+onYufy9kk01XNEk3PnkuyrLDCKUyjUPppcA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.10; Thu, 6 Feb
 2025 17:48:09 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8398.025; Thu, 6 Feb 2025
 17:48:09 +0000
Date: Thu, 6 Feb 2025 13:48:08 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
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
Subject: Re: [PATCH 02/19] iommu/tegra: Do not use struct page as the handle
 for pts
Message-ID: <20250206174808.GH2960738@nvidia.com>
References: <2-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
 <be153973-550c-4ea8-bf65-35b5ce28ac22@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be153973-550c-4ea8-bf65-35b5ce28ac22@arm.com>
X-ClientProxiedBy: BN0PR07CA0019.namprd07.prod.outlook.com
 (2603:10b6:408:141::9) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV2PR12MB5869:EE_
X-MS-Office365-Filtering-Correlation-Id: 09ac5bac-ae03-4078-5000-08dd46d66b62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ioBuEAk4w9w6CRcD/Dy/D3qgH8AR39rMq5flXQ68Xqr6/rUYtctqKdaSLLRx?=
 =?us-ascii?Q?nirf6XQVkdNGPy0s4gbUgYWARGzDzC7svuXBqKNPud2SXTzNfPxQ9o4N/BW4?=
 =?us-ascii?Q?n/EJ6yue4ojcp/gy88b3FiZejGwGQFqO4GtBb6wqbOCOEOKjqfSec47wiqmG?=
 =?us-ascii?Q?56Gs2A7Zu3Lq9wJEjWJw0dxArVTQmSuDa0hPwZu2zHlmQqVw6NX0AymB6EfW?=
 =?us-ascii?Q?0QA2Fu4jUpVoQgo8gkOoR28dzX0/CjHCqxg3ThRXsGH++bgOpXGmoGkmCWgv?=
 =?us-ascii?Q?DW3iNbhONVimc2/QnvT//PJwT7fx8R3jxAYVHEpqYdjRCesIex+fwcZ1kzIL?=
 =?us-ascii?Q?hZMljGpIkUy9sgbDnU8SQIyoZYqpYuHuDDpApgXK/DnJYJ8fIIOPZXQDWlUo?=
 =?us-ascii?Q?reorZotZ10JR6pueW4GwYQuS6Clcb+2lpFXlb0BOYrpqKRsNedFOiItnqpr0?=
 =?us-ascii?Q?lKeNsg5saOhcF6HPcOK85aMpKeXPbqGujDuxFKhAyIJPFu8909r3Ihxsp59N?=
 =?us-ascii?Q?+tvl/FJb0gePcCZyFIxfYdiEYoSn/oRb1fxPsjeT8AsPBLMMEdtyGo4hwSYd?=
 =?us-ascii?Q?Vp33pouM/31hfmM2Fcwownhcr7lMbv0lvkyH3gZyRvz5ZUiew8yHuZfVejxr?=
 =?us-ascii?Q?XSMu6z888dMtzq1ZOYFCPRDBxNAF0FNeHpGuuhgYEi614n8H/2UoBSy6lG1x?=
 =?us-ascii?Q?QopOMXrvv5OmhcGXcarTSQP0j90nGDF3nTHfQBWzD4aDZCz8KbYkFnTg3RSE?=
 =?us-ascii?Q?wQXkERhQTH2x/5ax0puANj6BlgfMopsFI9XsK2EoUB62xekzt2q+EqJfikmS?=
 =?us-ascii?Q?uStEyqfVoNP9S5In9LxIxTdIIuQkUmNu/osl4ItRCp9qErnQKNX9MY4h4Ucr?=
 =?us-ascii?Q?b7nwUNk1eLHour0EJwDmQGwV/jYXNt4XRO8PTbGXz91lK4a7HKPjYLfytNqH?=
 =?us-ascii?Q?r+q/kLBpi9vdoFPgfHC/1gwKwT1GaxIK4G4XKs2bBR00WJoI2bvKv2fINRUo?=
 =?us-ascii?Q?fn3dFTEJwOCcEcoAimpuxMaLuciTFHK+NQPhBBDNdfYAUG9FCQF0cseAT41J?=
 =?us-ascii?Q?YuORWjqxSsaE65zPOcvm0OTFMVzkWrVtYHFDw2cf7StDqQO6p6hJSWE4l6N0?=
 =?us-ascii?Q?r+uiHtGPtPiP8vqDlC8E8Pl5C8uuktNQrYu9Qyk3zn1luDoldyMTJZAu6ySv?=
 =?us-ascii?Q?CF6fz1ORXb8AOD/YfB9i3JB1QIjx77/bMUql8kS5qvyt8/daeV/Z25Ah7Ezr?=
 =?us-ascii?Q?M1k1YC21tppUxEMBIUf+pXaTauh0M5OqGnBDT2XsYcHzleky/zRWaO9rTV0H?=
 =?us-ascii?Q?MdMsPZa5hr1QiwbNeUsWrrOxO+pgR6EAbwBGtcBFFxRNLPjeUwsNnEp9bDji?=
 =?us-ascii?Q?0PgD0WgH3UrkxPkvbllftqs36ArG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eEmoZA6l5IQUXc5atFO0LozYaYzEPUMJqsBT5kRqUlBIl3FsMKOajUnGap8o?=
 =?us-ascii?Q?mCHCv3cJh17RYdXrENT1rekh7UxNR6HbbFrYaI7OgaIuZIFmP/FoNRRiXc0/?=
 =?us-ascii?Q?c5aiYkeweo8jzHUU79/He4jmNH1zAfc+MZyn9f3tJL1YPkNsC7k+LOXHtMpy?=
 =?us-ascii?Q?wh5EAtm0JmlhMssELBCDDtsbZTk/1o//aMjRyq22V6o2A+hVqH/1aJYoQ1dC?=
 =?us-ascii?Q?UBaao0p6DKT9VyHcXielS+yPYif8nD6dBo3Dyhl/+rxNX27D8OkcXp+BqUod?=
 =?us-ascii?Q?YhXxcNCqC+BtyWWocY2Y5bljbbRHuG//0sCx3z4zC9PJByV+dX6GSuKYGvxw?=
 =?us-ascii?Q?/krPGUZPsIPq5oLGMkfGSC839m/OKilU8bWLv8wn7O8KnJzi7zF7gqm+9SdU?=
 =?us-ascii?Q?eBUgM8LnsQ6Zfu+76wPO69Mfb93Jz5Avhtfy4JF8kpLeJ8hpcpRpjQOO4ZAD?=
 =?us-ascii?Q?yXoPGH8kzxuGqkkn47LYTowXW/lmRnDjT6fSqRYMa3MdEec9GMVO6AuWI59w?=
 =?us-ascii?Q?iym5CWEybfyYCd/A4Dmij8Xh6nscEqov3WfmfvcExBkSGUznouvaQKLnJMJO?=
 =?us-ascii?Q?FW/2Ww9G+ym2c7eYYy0/yeG7FhOybhf2VHUcjq2If9gsZE+4KVL7HoiHhev2?=
 =?us-ascii?Q?4eIGsNoEx6s44EfEAJwLRYqHx2NUarcw+5IHXZp6xZvnG3Uw7Q3SJSkM3F/j?=
 =?us-ascii?Q?lzgNhVGYQoqiFjuEk1+dZLOzUQSkvTYNgRMmUyGVD+wWUDHmCpNKnFcoHt7u?=
 =?us-ascii?Q?YwWOCQVsUlbn6Qt6VtKiBbWdFLeNXdRa+iCGmj/CezVvXBI75i074L/f0Rp5?=
 =?us-ascii?Q?MiROmV1EcsOB4lpok79m2l4BrUyDMAtvx3mQNyr9m4E8puS5/QaRIyqAZ6a3?=
 =?us-ascii?Q?uKVQRMUWe/bOPCRR5v+YjEHyulszAw352fwYD/mOlQ+r2BR+nPEjuFLQsbWE?=
 =?us-ascii?Q?FyXesystTv+FByhPKdOMJElvOXpwHWpCS3VIjUroe5+T1F/n6J4QBYPhtLsV?=
 =?us-ascii?Q?S3tcXr9Y99Pd/GwP15yssAdbdJ6ltVC0EYz8Nk0MWTDfajNfedMoakChn3Xg?=
 =?us-ascii?Q?GPbjtqLC7siJFGRPEoRk/c5PcNPZ8rpdkX2wvrTqqgQ9ug7desgzBkWkTVYY?=
 =?us-ascii?Q?bCTFL6Rf6amURq92DVG9k3nGUOzaTBZceVQa4WnRdUtxClUGxIo5H67xb7Ib?=
 =?us-ascii?Q?YAgvNGYKB1yKNGEppu5Bzasa6jk5iM9QfB38rScfmGBurR/3AMDk/daEKb5O?=
 =?us-ascii?Q?wBriMXG4XXwkaZOovGe0oFvppEoSPrmMMhKk/gLlClYlN/9BTiqtCXtDNyVv?=
 =?us-ascii?Q?iwDUISb+uG5JzDL6EhPQ0eDly2QeTQSIoj4QNxzK3bfGe6TYQdP72c/KdnK2?=
 =?us-ascii?Q?4QA77c05yt+7IWuqIxhStPAFzm8WcrfzgmWZb6WB2I1b3o+X2nFRzoF82iU+?=
 =?us-ascii?Q?O9GRYI8Z0X2SQAA+997Q6WYDWm9i+r6CuS5ZhfARkhd8elBaWWJlSYKf7g1K?=
 =?us-ascii?Q?e7DjrOf2yLZDrqSU0yJ1tEzrNa525mrRTZjXA2savS8LyZ6uhMrUPQrFzEF2?=
 =?us-ascii?Q?CeNt7+wYakOOv50Hh6X5yDiYD+Ejfmnp+UH0AMPY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09ac5bac-ae03-4078-5000-08dd46d66b62
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 17:48:09.7047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aEFACmhZ7OeSY+jPMhzDSmgRrCTTTPLcdvtJPRToMtlEOt+DB1ssnobwDfUgUeWP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5869

On Wed, Feb 05, 2025 at 07:28:37PM +0000, Robin Murphy wrote:
> On 2025-02-04 6:34 pm, Jason Gunthorpe wrote:
> > Instead use the virtual address and dma_map_single() like as->pd
> > uses. Introduce a small struct tegra_pt instead of void * to have some
> > clarity what is using this API and add compile safety during the
> > conversion.
> 
> Hmm, I'm not sure it's all that clear to have a major discrepancy between
> how different levels of pagetable are referenced

Well, with a trivial conversion the pd would be u32* and the pt would
be u32**. There is 1 usage of a tegra_pd and 7 of a tegra_pt.

Spraying u32** all over the place was pretty ugly. Removing
one of the *'s was more than I wanted to do on this old driver.

So, lets a type for pd.

> > @@ -596,21 +600,21 @@ static u32 *as_get_pte(struct tegra_smmu_as *as, dma_addr_t iova,
> >   	if (!as->pts[pde]) {
> >   		dma_addr_t dma;
> > -		dma = dma_map_page(smmu->dev, page, 0, SMMU_SIZE_PT,
> > -				   DMA_TO_DEVICE);
> > +		dma = dma_map_single(smmu->dev, pt, SMMU_SIZE_PD,
> 
> SMMU_SIZE_PT (yeah they're numerically the same, but still...)

Oops, copy pasteo

> > +				     DMA_TO_DEVICE);
> >   		if (dma_mapping_error(smmu->dev, dma)) {
> > -			__iommu_free_pages(page, 0);
> > +			iommu_free_page(pt);
> >   			return NULL;
> >   		}
> >   		if (!smmu_dma_addr_valid(smmu, dma)) {
> >   			dma_unmap_page(smmu->dev, dma, SMMU_SIZE_PT,
> >   				       DMA_TO_DEVICE);
> 
> All the unmaps should be converted to _single as well (and in patch #1) -
> the APIs are not officially interchangeable.

Missed, that got it on both patches

Thanks,
Jason

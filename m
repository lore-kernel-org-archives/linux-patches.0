Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7931F1FCCE8;
	Wed,  5 Feb 2025 17:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738777317; cv=fail; b=CYaOBCzgB8bV9ax/rFcusKsr2ec3/z2hs8NGB6r1Wn9sJTT6u1r6gAr+zlmEGUT57NxFDEp+ophbQIRMVfMOOGjLOmei4b+Yf1eiwNRR/lDt3fvXEB4BxqGDHvwtM24ZiKPy+w4ELMc92jSn8l7l0Rf0kM74tTePscdIPnWu1b4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738777317; c=relaxed/simple;
	bh=6F0s1ezxM1BSNFq00j6LrtqYr/FIL9hTfEnTZ94cyu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qKGNmhlOnDE0ekCTbY4dStNVaBW9GTrs9XKqJa1yEbb8szhSsrMLsk2QVmozhb3nYo23LtONpDUsYQW1g7YlSM8RmYZVF53caybdXRlptbALwRfIw5fBgmtl66NbiMdb4jkw917KwtzV5wP+FVzf0qx3q0FGDfaId8pbSRd6Jvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VZDgpuye; arc=fail smtp.client-ip=40.107.220.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VZDgpuye"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tOb4r1eeYj3wSr1TmqvQC5WXdVkKeVgsv10t8PBuLaUmJ1zmekG3MhTJxC35q+tpjgYwaP1fcwiIW1eMb1vEUrySj3T7XhLwLEAGDo83l65wRq6GZaDXvOtqKeulq8ceOaznuxK8lThnxzk+ysDVaB8RBkOtECDWKXjOpqMXbzuqKlmI/i2kdYgteTABSehOGITFbsSb58z35NfJnZYnQeXxqZvlDMT3TJbBlGMWYYzMjHoKIBoeBC3FTwHJ/vQYtNQGHjC/LXj9kasASHgQ9YfIQNrJPkEszj/dI4BK82sl7avyWxkvIU9aOhVG3zL5vlH8s7livuAx1SkKM+9JuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2BrriejY5Gy5j9Lkn4ywEUE3sUQ6pwKMbb2jEpy4NVQ=;
 b=ZKx/A1iHfX3vrxFNup+J4ra3pUe/9bsF5p/jLsC8Jncq/JjAlHthQydwmwy3bTNHsgv6PQ+83uQeU+jMshafJ0sBbIT1x5OmPfKI0Md9TFyN4rwZO0/fFdoKRDszuFAidef1mJn/dvJYD16Uoyp3aq+GYgUqvqBHNemBfG+XOsxYr4CHlT6tFT2ZVxbC5rNBr3TL1VZSMJQ79UP6q0LhCdBlXwn0Z6uR2buXUaViiHOFUiY44x2hTYEl66kWOfD6jrzkAINdtIl+JXc3pX5VvVaxqoqJSCoPh0XDO2uSpzN8dU4q/rRkM6wY8xYdk1GFRQ9pSstblvkDM9aaXZpthA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2BrriejY5Gy5j9Lkn4ywEUE3sUQ6pwKMbb2jEpy4NVQ=;
 b=VZDgpuyeOadEhSvCW/1IS2OrTNZxUALmyaRD1FLeijoXNHvxUNH+xh+wareaN+LIqhX1zwwxXAW8lsmtr/q+a+q0Xhm5tc4dhuDOy4Q+nltpzWqtTXOLv48LB3Y3sMy8+zd80wnJOrbVawWeE5qTRfLIF7L+2c0Pye/qmgSMXA4d/0XDOSXp7ST6qmW1KzWh1aEz69NezQ9XJgGzsv+V7kL/aRsfTxSLCjRyGEC/x4n9u17gZRZBelU9XIh8L8KoQDmS3ryMYPoFQ1h0TenDO9CR0fEGfTxKpqRE5EfzwV1XwFTVLhF1eGxCMk3/yz1v8IM51hzh7RZTURImhok4Cg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA3PR12MB7783.namprd12.prod.outlook.com (2603:10b6:806:314::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.10; Wed, 5 Feb
 2025 17:41:48 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8398.025; Wed, 5 Feb 2025
 17:41:48 +0000
Date: Wed, 5 Feb 2025 13:41:47 -0400
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
Subject: Re: [PATCH 05/19] iommu/pages: Replace iommu_free_pages() with
 iommu_free_page()
Message-ID: <20250205174147.GC2960738@nvidia.com>
References: <5-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
 <ff16c183-0679-423c-939d-9906da174051@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff16c183-0679-423c-939d-9906da174051@arm.com>
X-ClientProxiedBy: BN0PR02CA0049.namprd02.prod.outlook.com
 (2603:10b6:408:e5::24) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA3PR12MB7783:EE_
X-MS-Office365-Filtering-Correlation-Id: 032bb964-bf8b-4205-b7d9-08dd460c5dc3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6cvNJ35PDCJsU9fvKS8uxqfm2dvM8EkDE5PzQQTXiVmlBTjaMul8Fejf183Y?=
 =?us-ascii?Q?oeGtcNH7RrJiKJFoa9pl9YTh3OFpD2Ribw1cSKMhH9E9eqdnTDsFZtC4HLbr?=
 =?us-ascii?Q?LH/2f6XagYiNNyj82w+TN6ChCLRNuE4xRBjhXZrsYeBtDBFjIOBGFRNYJI6s?=
 =?us-ascii?Q?BDjbpl9Wt6ZBsc2Pj266lzhE70aclV2+38Fr522tvwkqiIYT+VS76srVZubb?=
 =?us-ascii?Q?q9VJewg4yqFAv7pygzFwc5jJZRt5UVR0Zkc2PfsqbZ1+HMTONTGWErez3CsT?=
 =?us-ascii?Q?0kKSTLD4XwJSiJskxqQa7Yvznaxg19bUtibNv69+0+LoP2f5klW4tXmUftfd?=
 =?us-ascii?Q?wi0mkOvOyaOWzr4boJmMGT1KboZqTB6jo0QVhgIeCIOl1YAg1X9HDywjeT72?=
 =?us-ascii?Q?O69vtf84Z9lwTmUmYY9gpdY9EQA7LLftzaIcxWs/OnX6HyzaJNcvikZNPN19?=
 =?us-ascii?Q?oFcJ5mr8f0GoCJvFggX0Tnj0K+WWpYZeeuHLDRGpB54MwVnMzaSZ4HzeAsLo?=
 =?us-ascii?Q?m9BwyUshLifia54DiOdS6qUGgiqRB7CbzMZ7o9xtx2kWGDHHf4fL3IwPTj/E?=
 =?us-ascii?Q?W4S1ZZRD21XFKFPu9mwEW6rPuicwgZC5NeFFizibKj6nwXexokHIhGMNiM2t?=
 =?us-ascii?Q?nKhEJ0UpKbkRta4Ro93UCWUns+bOHQ/eu+51ZVCzmwXxVbpQWpVTW2t7L3w+?=
 =?us-ascii?Q?YgUAAFuYaVYEbzTCuKutInIBar+GBtPwhFIA/pTCgEiKuQtgjiJSOXq8Ktbq?=
 =?us-ascii?Q?DJOZkGJisB7yoAUv9EEOvVkWHbfK5PjiMcxePaJdrh4+TNCyGiT/M6Pg2O8W?=
 =?us-ascii?Q?nKq4lfNtJDnCXW6iGu0VSCft4jl5OgVdLz27/xKOiftbKJiI/xGv80vvEYNX?=
 =?us-ascii?Q?19ioUeWGd4Ys6VhTKyeqpNYQ7at7JQIpytEjV2//Zvn21LkAFSJgw0f8Tcl9?=
 =?us-ascii?Q?+KMw22tgYz4lTBB/DfXBXDf4whIz2oEcvxTxcOSR2t6/q27XjNnjyH3SZkAt?=
 =?us-ascii?Q?djQyJmYm5S8SL11obOpVXbu2eBqIsFaMuMuGrhSm8z8PCacfesyY7xFVqChB?=
 =?us-ascii?Q?vbSDvZgZ8pfPH50/eJWHmDNvitfPfwCHlyNJoKGey9Ku1pJIf8oP6aGNmre8?=
 =?us-ascii?Q?UVSmdlcTrI+oIw/KWFyx4CbgIzSqUkA3XY+XeNsOKwy9vmGodpFkXUfQfnmw?=
 =?us-ascii?Q?HxRxoNLmshHDd5y4REieggGm7cqpuUKaMuw3euSOld7jI/FWP+X6LJDVV+Cp?=
 =?us-ascii?Q?0Flit2/SdNxf/IEB8cSnXe9rIHXOMNvSsKDoaPHsx4pk7ed4ZHz/sqa2vH68?=
 =?us-ascii?Q?IasXSHjRmFa/SEphlJ2HRGQkXZvjFPmx9sy9KZojl2iATAk4btx9GaPeetmy?=
 =?us-ascii?Q?AUbxieayJ8fHClPFepNsl/9ymYMv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T3Ajjytf7a3EKjiRMGYFq3RGpFTQGyn1yl8qrFUtA3qeLnaHPH+UfdzjM9lR?=
 =?us-ascii?Q?IQ/7E1hsVr8s6MF8mhlfvhFl1HA5VEuIUVTgkvvuumNTa0B1bCemrblkGg+y?=
 =?us-ascii?Q?3S0Tw8iXt0qUyB4OKvYoKyIs9BJhMdKajSCyVHfC37eRsQsyafGH0Vyo1ofz?=
 =?us-ascii?Q?dIcG3R4pc+J4DG+kKvDJxg0gCnSmmIAaijpJKIx01lRBIIA5m5HzvDIwnBgu?=
 =?us-ascii?Q?ZRrSkEwnJvdkxRA+zQqr2n2q6rtr6O+TGlLvERZCeHdttkjOUSHbO8FRuH8e?=
 =?us-ascii?Q?5Nmo65Bg0Bf5lMdZz1K2CmBmpdISBzH1dlgIdSjB7xHO0PbmsZi/R+7tfqqX?=
 =?us-ascii?Q?9NWk+ksFk54y3PHsbmVcQNE5rYkbNgJ4g1u6jIvZCWPGulmq5W59AYQy+z/j?=
 =?us-ascii?Q?a3LraLxXy8vu6vJAPMTE/sb2FtaPizphiMdhrz9FPlYLgV1T+MyB29l1x8yv?=
 =?us-ascii?Q?0nCbb2JsCa56X4SoZDSc7HRCz1ds7Ku9iQqLvJMCHn9IGRstpONlngcxHG18?=
 =?us-ascii?Q?7CsUOjsCykzv7Mg4LgDVjTDbHjw1UCLkOKSH8rz4ykYUBXgu5QRd8LBll/S2?=
 =?us-ascii?Q?gg0jtL0C931B+d+NmeuZH1MS/qiu/sM0Svu7umek4i+X8XN4IUrWBaJz06mu?=
 =?us-ascii?Q?LCi/0CVmOP8NIT2/fClife6KU7QZULUcEqasAg4Xtj/p0O8wLVTGEZuXPMYz?=
 =?us-ascii?Q?xCEYYYORDQgx22zeidR9yA5EDGXikZV3+vXm2HjXnabQ28v9OlYfH/V+J+na?=
 =?us-ascii?Q?VrezRvCT9iv5Wr1reFBClUIurJ6ZMndO8z7CNWJ3eAzlfRTGc6XeL1NKmrBX?=
 =?us-ascii?Q?NKRUeBm0tzHXXv4nrgVa3KONzrY6yNbDQU3XPul8SNisycs7gMK8ASsYCNAY?=
 =?us-ascii?Q?TtR4qhpq9RBDDECMUV8EUBWYc49PHhWmH+6xhbM3qy7aMPdyPmi6l/3swy23?=
 =?us-ascii?Q?829eUkQmmDX5TZZOAZJmzDjybiaN8I25+To/hKuA/yozhHCrYCGea0DEVemS?=
 =?us-ascii?Q?ZhGONZHZsBxI12HOHZr9wC8Bwo185hTZbtsQBef8Z4c4L40BkgjUkinbSMDX?=
 =?us-ascii?Q?wt1htJrt3Mp039T1SHjjydPfAZK5b89QB9hJDZBEWgp5OeHTkC9jFlTE/LAs?=
 =?us-ascii?Q?lM7xROFudo8ypmkTBFwrLVtrs/4e9YESghNADKWW86CEMLwTO/wPDP4ZInJN?=
 =?us-ascii?Q?kRvADitBjbErWrLI2T3ancAfdniAwDO7yYv35KUG8JCp9voy57xCWWYPKQjj?=
 =?us-ascii?Q?EQdJGuiXO8Jn25KSOdXiw0lj879/Jc7Zc9BQEf5Ikn+kIpjFtxkfuQxeG4YF?=
 =?us-ascii?Q?/FGSYDsIX4iPtUDqC1zzo7DdSbDHbF5RgWpIwMrBboXAHZNaSRovCY24HsBK?=
 =?us-ascii?Q?gYj1f6ZxV8qQnW8TWIqfKyfWouMxaOG94tDtVO2vwiNQNpjXmEP/MiU5sfi/?=
 =?us-ascii?Q?PknDOVv8arQnKEgIB4vPRYGAfmIckFe+nQBBYKQvRbonujWx1nfMU9aERvD/?=
 =?us-ascii?Q?JKTLwVPpYAlJb0OfpgOmyzaytQBdki0Vu3gMHeBd3ZndBa9u//jkuU5P9Atj?=
 =?us-ascii?Q?IN3OhI/XSBH+XuK8SwW5jghO8epAnwmLsWd8EXiG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 032bb964-bf8b-4205-b7d9-08dd460c5dc3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 17:41:48.5727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KyD9E5cWunKhIxMTjE4DeTEcqMU2EfblYYMBFzzJ+5rcKyPixDmrM6po3TcnEUJ+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7783

On Wed, Feb 05, 2025 at 03:55:58PM +0000, Robin Murphy wrote:
> On 2025-02-04 6:34 pm, Jason Gunthorpe wrote:
> > Now that we have a folio under the allocation iommu_free_page() can know
> > the order of the original allocation and do the correct thing to free it.
> > 
> > Callers no longer need to pass in the allocation order to the free
> > function. Just use iommu_free_page() everywhere.
> 
> Nit: we end up left with the _alloc_pages/_free_page combo which to me looks
> slightly odd and uncomfortable - any chance we could go the other way and
> align on _free_pages for consistency?

Yes, I added an additional patch to change the remaining free_page to
pages

Jason

Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2085.outbound.protection.outlook.com [40.107.212.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64FD18DB34;
	Thu,  6 Feb 2025 13:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738847848; cv=fail; b=Mal9Zpn8gMEoG8ejpGXy9hGfPUj5EBjMmPpTZLc2R31YZmP+W5l+7nIQzinskXIaO30ah8N4F6q/hhsqSvg9Z1EUE0Ms+H8O5be5/nBFxAHTkRomveRLoaG2GOqgstY1JJF6OEXhiuZ7D1XdbU2eWWWix3BNH/Ga/nCWYk/fl0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738847848; c=relaxed/simple;
	bh=VhCLITNoxfn68E7OxSkD8ElI+X1JKcxoPv0D0mX6uRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tTD5d1nDHQVmDfrxNNQ2Vai9w6DCayTGCkqOoKSatuFha0LfzOo5JCk8HtynfNft6M7xPSV6Ji2KG55uQGOompc03tRRVY691Z1DFSfCSFkntdXDo0BnjcHmNosc7I9fOTtJ2b41ykreYfUC4VqMsSkIdxIza80OwERAV6DuDE4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cdhXOGvC; arc=fail smtp.client-ip=40.107.212.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cdhXOGvC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ixnV4QBUa8pN9kOn+mHE9LCNxca+perCs/9wrFM4gyWpgkLs1hL7kXMRKeBfzLMioQ1yje7HUYBYMNCtucfSIFYu0Hr211G1qXn/G9iPr8Gncir3nQu5qfYMWdyI+kBbJ6PlXqDWRMnakX2jtUATJ5qxPXf+goETkPArh5LUJ2Vto+tvZygcW5Jf3sez6Hlcgqx00OmB4OUxnFVXQtfZN7lI1zsSrPJFaWs4EbwjsPEJ0du4dHQOqA3AeUbnkb4XCz7LzfnwyXOsrMAOGZJxIHlZdyBLCMHBjAbrbkneQYCSQJOx3CVJqPALWYLaPrGKe01R6kX1liUIxQ3OrKa5/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bvGBtO1g0Tf10DP3Tmh3PU4BulQZrk+/hjd9Hhf3IuE=;
 b=wn0xk/Z5CapK5PD7TZMtKOTSBpG01mpS2ZPfmPLpQCED+aSi4+S4iZS4JzH7rrJT/cktsmyAuv6vN2SIXWHhS19qc/39YNlY3hN6DPh6obd/nesWdJWZQEz2+b7sJnJJ2JLoNQwFHDPmqYSGEQEk+nlCP+pTnIbnzyBDAYFBPzx531gJY0WAhSH7tVXBzBHlTU25rLozxPG3ls+7yzquz20+fKfCuwIfj5xNp/TacBbVwloH+9w0tjFEjpdZxUlx5QH3grOJeVYU2O4bpYGfFgeTgB6+siSbfLqStpJS2OMnRabMLhSZgYlzCqf3Hs0C3M1D5HJS05KNKmnOz1brng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bvGBtO1g0Tf10DP3Tmh3PU4BulQZrk+/hjd9Hhf3IuE=;
 b=cdhXOGvCShpbEy4/E+rs09HnzaRUVgpkJPomhTnpaPMFJmhr03NZElo1RBduByTopsMr2bwnHQl6NIj+qMkPAbdMblUSg0OzpcbMmglNiWJiVD/o/HC9gwOqa7JeMOP0V+9q+sy2NmtcBy8IJz6bl7jlQFI9+TPPMZvatHl53/gQvxWyoL8WxDoUeEtK2tV5aD76YKN8g0+nONaHuqa/MF6EFoASsscwJLqEPV+bso2DZN9kMr3W5kEqbCH0mfSHF+5a6VCEt5ZSjSTw4sr8tlef4Utzf1gaFoOtCiNHMfwBzglp3FI2n/ZSiWV/FBTSsjBOgZnddxoqI6VNHreN7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MW4PR12MB7239.namprd12.prod.outlook.com (2603:10b6:303:228::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Thu, 6 Feb
 2025 13:17:22 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8398.025; Thu, 6 Feb 2025
 13:17:22 +0000
Date: Thu, 6 Feb 2025 09:17:21 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Tomasz Jeznach <tjeznach@rivosinc.com>
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
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Holland <samuel@sholland.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sven Peter <sven@svenpeter.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Krishna Reddy <vdumpa@nvidia.com>, Chen-Yu Tsai <wens@csie.org>,
	Will Deacon <will@kernel.org>, Bagas Sanjaya <bagasdotme@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 17/19] iommu/riscv: Update to use
 iommu_alloc_pages_node_lg2()
Message-ID: <20250206131721.GF2960738@nvidia.com>
References: <0-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
 <17-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
 <Z6RI3ftJTrm3UxoO@tjeznach.ba.rivosinc.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6RI3ftJTrm3UxoO@tjeznach.ba.rivosinc.com>
X-ClientProxiedBy: BN0PR04CA0160.namprd04.prod.outlook.com
 (2603:10b6:408:eb::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MW4PR12MB7239:EE_
X-MS-Office365-Filtering-Correlation-Id: 241bfcde-e9cf-488a-9919-08dd46b0976b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tcoh6BLfTNYQrUurNmQX5dcHc8PRyHGEyjJmuHEYO9AjV98Xz4Xl4+f7Plrv?=
 =?us-ascii?Q?N4mFgEblZ/PD5/UwbrFZX8wL9IV7QjBa58IBfSsESybpAF5tIfKyqfWQ7YGO?=
 =?us-ascii?Q?5A3C6ryJ50nRTP9yCx/oL6JyJgRAHbVJx8Ez+TY/3SgCw3MMyPZJvi6rMcuy?=
 =?us-ascii?Q?1elziEbGk/Hxb8sm8gKIibr8xg0jN3CgcS/7Th0XfanzsIsyMGltOEnVdVnt?=
 =?us-ascii?Q?MTWIedDQylfhIeVuykIja8Ku3v5a6bc+0YekhWPzDXsaAiM/0BT8bb6TLNFO?=
 =?us-ascii?Q?C4e3ww506Q8cLDQ1WIS3CgzL5EhjCpGAEEzLHSyYHSm0GAinNBZD091odrVm?=
 =?us-ascii?Q?pZSNM1Z1t9huK9jjuns/KST3jDnzKf6S+50En1eH5xVMOBR2W0rKQaiPASPn?=
 =?us-ascii?Q?J0T1oacst8ctH7/OEq1CQhvsp5wL5QAANGz/bwMUnsIezK5YeSb0Q5hsGSM6?=
 =?us-ascii?Q?aEnTLa7tC33fkoY/l5bQkEP7E5ElIp/3J/zzLXlBECAbNHsAJDLJyebgw5ge?=
 =?us-ascii?Q?EcO4TiC82t+uhuHywKR4TWQABGqqfKXs+cvXXKBRljzvqF4SZ6xXw+3htr0Q?=
 =?us-ascii?Q?AI7QF7ShcSTjxNvT9bmSusK/4A4vIEavZ9tjXwC+5gt3xOXLWBkGQbfZZsIa?=
 =?us-ascii?Q?YFXHY4tGl+p0arpC3QgERo78wN3Dkg8BkUM7e+WQdsavZIttS94LPSh8geyM?=
 =?us-ascii?Q?lNWpOTMmQszRfXLYcdNY2stqZUQNzx3/bP55l0iTPwroTw52cfLkejbklAN8?=
 =?us-ascii?Q?JEcA0zDuei+Abe8r/hp0xk45cCLjQUT0uUBL956NWAZiaQPpEPTsGvkp9P75?=
 =?us-ascii?Q?kbq6cMORMSCfkyywL7Ff4tgAxXctoGEp2AEB25FrPAEHjTXM4pgWa6WZEneb?=
 =?us-ascii?Q?DqxIQBU8yi66VT0zr4hnijyR7jZZnM2wuHdeQkIQvMQI8Sch2Zk/7wqYq7kq?=
 =?us-ascii?Q?OmBY2AnJq2v27KZbQCYqQPDdFOR9wCdWT+O+dsUPfZniyfOEJZpVtD2yrLM/?=
 =?us-ascii?Q?4Npdrr9mpAzzF2dyiqL1uHu3olAPp92qEy/cv/wFWDDs7OLcIZqD5I+RlCmA?=
 =?us-ascii?Q?PaaXFCKbLaWZ/RyfGQuyXnVg8srb27X8ImHC3aaiM1pLcS/kbql5pu/TpeYQ?=
 =?us-ascii?Q?OVrTxJg90WFbPbXT0b9wpXqvhhj2lMtaeZ5JX5Z4CHWo086hfnnHuxgo6kP+?=
 =?us-ascii?Q?3FqugN7tK+r/qdpcP9KTqssmw5D9/0tmlVFwWjAAGQI20n+Qv7UAYnc8V8Uc?=
 =?us-ascii?Q?nQwg00aicNbZ/LT14ydJEdRKBT2v+aIv2X3ss7N4WszuJb+TAucvPqDmYC+s?=
 =?us-ascii?Q?aBSqXUk1uPOTwJhSo7E2MUQDNP+cPxKjjrLR22u0l0Gv/wIHzH/rmFTh423u?=
 =?us-ascii?Q?cKDDNVqxRymZRZDfHhuPpfAKf3me?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KRkj07ZxtVvtzA1Gc1po/3FHX8h8zowcRgPicr44lisU//1R9GYEMKwQtfRo?=
 =?us-ascii?Q?c7XCSfOzhmhGPbyL/JK5C5hp2+VZIL0CDsk6oHvWtPw2K6suI/RBkB/iasBM?=
 =?us-ascii?Q?kx2Q0lDgMNtmRcRze7/ytzDZ+3sZMX/DQVUitb4AlhtvVmj3qn7FNCpD6OCf?=
 =?us-ascii?Q?+rX9IY7hFjiVBJcqvV+0r1M2Q0viAa0C3Av3sVPvRPlhIhgZuYA0cgp/khGz?=
 =?us-ascii?Q?WdxTCghdpmaMIOQSJLrnQZKIShJSyii5sCDw+8DqvNaOOiZmYq4xiS5LSR/q?=
 =?us-ascii?Q?J3F8ZqcG0HLlMh/uM92K5hF+zlT+eKxoofZ2Tkt6Svt1zz4sCAfUiq1qWQkJ?=
 =?us-ascii?Q?83sCLVR2hsza0z/DmOY4TeBXCaFo29Ufsd1tT1j+FRaTOVUUaknXYg+7TJVY?=
 =?us-ascii?Q?+PFMc0MaueD2xEk7K0n+T78e+gGWadSNJq+WFTen8rQ0mLv2soWDyxYjBx8k?=
 =?us-ascii?Q?50huEt/9R2/q58qFvOZTz/ZpjrQx0eaB9GrFaHxa9cm4cdAUXXP5qTiBEdon?=
 =?us-ascii?Q?C1v2ZqOG3vKz8gLTFy2ZPfwq6NFOGPelf6QaVrTShuo1VioxHTiyyCgVzrt2?=
 =?us-ascii?Q?OFbLupdMFZNYz5MfFpJToGoBvvk/jpUiSFxg0WZr3sBz832VgcO3OBtzdNnb?=
 =?us-ascii?Q?NuwGcooW58nZOtpoDh862mUI5so0+NdsYalO4Mj+NmLEwnR3rIotKXtnH4WD?=
 =?us-ascii?Q?GlaRQ+tpEA9O4JyC+r1kJwkfPCnRuMIKorjhcai2PfvYv3VH6rtpzBb1sS/1?=
 =?us-ascii?Q?PWyqVXjI2IH0uQ+iWuffCFONE6NG9Qbrp8K80cxn6Uqtz40tUf/fImeIwu+d?=
 =?us-ascii?Q?Ry36rVuxoXYl1+iO6/2Lc+A5UZFsh5VkdSFITi1+iSMbdqIIGWbNCWNdP/l2?=
 =?us-ascii?Q?mkRIuZwhyyNp+6YPNrpAv1k/wKwsxyVPwcXbWqPGM+QshWQHLaLbYXN5sC/I?=
 =?us-ascii?Q?I6yTSamZctYDK7U3sbxokg76jL6oFE7Sq5Qgh3FLhRCRdp0xii7Yk+M9P3LM?=
 =?us-ascii?Q?WFbmgNmd88N+dnJQ6xhAuKYfOZhXakHuzBtY+50fEQYjsA0AIxqz87deWdF0?=
 =?us-ascii?Q?aeTZTYeepKU4qWbmrHGfZcqcEa2Y5IA03d7KIAMpQKNXaNLlCKQQlGWAf8YA?=
 =?us-ascii?Q?y4JMvsQD+3bsw39PEH1i0s3LRgw+JXQSSwKK3o3f2CampaKcCUprEMqSHKyD?=
 =?us-ascii?Q?9OUiUPaDhCUQud858eFj2dOE7LPAbj2CVY8yz7dFi0sj9qqNmjgEpKQcFd/5?=
 =?us-ascii?Q?xHmAWrfzn9e5avZp1BTe61WeIGYlC9XA84y7o3El2qAREuiodeb6piNzS+N+?=
 =?us-ascii?Q?/DzzZZcHqZphtfwdr2Ajb9wuyz6J/R8AVGzhktI+RmNpAJ85UcrY+DnEq35e?=
 =?us-ascii?Q?A/C2jD57VRDizRlMEK/3uNJ1sIAuVfmC6ISpZR25ErV/VYEWUkf8zjGFO1y9?=
 =?us-ascii?Q?Ef8FAf4t7607ztY8t4GHbdgalUZ/ZF71hToPd845HWRNkgNw9jrb6RbxSn8J?=
 =?us-ascii?Q?HHhJqzwBo4aQ1ng6tT0b2iHjpK1RNEE4Yhrrv0LUWR3Z+YZO2fXUHXYXQTff?=
 =?us-ascii?Q?IKk8bvb5IETlB8dSbD4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 241bfcde-e9cf-488a-9919-08dd46b0976b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 13:17:22.7420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: owwSbsaBEmQ+2p1T3qr2auAT11+Z8FarXRqrFwaA8vOXs0wlzvOg7JxL+2vsCzjm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7239

On Wed, Feb 05, 2025 at 09:30:05PM -0800, Tomasz Jeznach wrote:
> > @@ -161,9 +163,8 @@ static int riscv_iommu_queue_alloc(struct riscv_iommu_device *iommu,
> >  	} else {
> >  		do {
> >  			const size_t queue_size = entry_size << (logsz + 1);
> > -			const int order = get_order(queue_size);
> >  
> > -			queue->base = riscv_iommu_get_pages(iommu, order);
> > +			queue->base = riscv_iommu_get_pages(iommu, queue_size);
> >  			queue->phys = __pa(queue->base);
> 
> All allocations must be 4k aligned, including sub-page allocs.

Oh weird, so it requires 4k alignment but the HW can refuse to support
a 4k queue length?

I changed it to this:

+                       queue->base = riscv_iommu_get_pages(
+                               iommu, max(queue_size, SZ_4K));

> >  		} while (!queue->base && logsz-- > 0);
> >  	}
> > @@ -618,7 +619,7 @@ static struct riscv_iommu_dc *riscv_iommu_get_dc(struct riscv_iommu_device *iomm
> >  				break;
> >  			}
> >  
> > -			ptr = riscv_iommu_get_pages(iommu, 0);
> > +			ptr = riscv_iommu_get_pages(iommu, PAGE_SIZE);
> >  			if (!ptr)
> >  				return NULL;
> >  
> > @@ -698,7 +699,7 @@ static int riscv_iommu_iodir_alloc(struct riscv_iommu_device *iommu)
> >  	}
> >  
> >  	if (!iommu->ddt_root) {
> > -		iommu->ddt_root = riscv_iommu_get_pages(iommu, 0);
> > +		iommu->ddt_root = riscv_iommu_get_pages(iommu, PAGE_SIZE);
> >  		iommu->ddt_phys = __pa(iommu->ddt_root);
> >  	}

Should these be SZ_4K as well or PAGE_SIZE?

Thanks,
Jason

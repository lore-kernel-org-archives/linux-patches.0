Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0EA246BB7;
	Tue, 10 Jun 2025 13:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749561511; cv=fail; b=NsLLcl8WaO1HMeZm7QT+0N+Hndbj6K+81HNh6qBIZnrN1CBl/JU1DfOYToqGefo5HK8PjlWkJ49yqSJKlJ+IkRUZnFvKS/EjvMZDLYz2tqognXJcB72NDwjehFT7jz9R2tLmjmVikBn/zpM/3jvoB0KUZSwWawhT3jhBt//miMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749561511; c=relaxed/simple;
	bh=j0cUDm9yBMGKlWxl28yKdgffTv7CSdjEFqNluSknWTU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MgnZZBfOazCzhV6RYz/A2JxOMnWPfJDbc+EjccTKW7NYXe1EK/KF5IoUwQ1fnxYPA0K5z5Hia2wOMm9CgklthxkwYZx3HZYjjMdm+6b8Kww5fD0u6n9RotArfDTr6MOv816LBKi2GguZVMwhoZktmMnRRgaq/tRx0pkrCaAnHbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AHjIxU9F; arc=fail smtp.client-ip=40.107.92.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AHjIxU9F"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dkVugsLbrtlZSZpXDeOHdBvT3MJOQWKdIMO8FpvBr7e5QdwxFFjJ0/4daauPbCa9k4GafJwVNsE+7a0PU+AqcjJHuOQxywvVhnrKvrw6bWz0CspSAj1jJvMBiLNaA3WoBCN8Wuzbl1dkyrGBBC67v5fPL2Q1VKhmZdQlTwM4H4/1LXuBbi1a6RrX8oshphYjfexH9OR1XZ/IajPIrBSFWf+NQWcZ8IwgiWl8qTNjmhNTcJJUkjN/zUVFUrFXfj0ZWWLgxA2r/vCZes0gHL1O4992buMU0S2MRow21O42jedOaqN8xICqaPICYx4i7jrVnU6dwjs6MiptBa8/bcwPQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wu0kA3PNNb08GHROMEQb8UMFEcoguYRZ3sV4qxMiOJc=;
 b=NqtWnE0i8k+iLdcK+wgdgb9Q/wXUTgx0OxMBy2NX/+A5ZIu0niUuJHPdWO6MrWNYN3bWVk2hOTiIDVqOtgOYG4bDUd2MWOjFBuCwekBz6VHUX7p5rxIbAVu+hGuWtYliyGTfx+4WLQS/CJp8csYeQEZCTBJdgev3QXDBKmb8fD7A3GNS4OwotPzSDXEpJXhAVr/1cuNsAO1czTwdbIcEVnDYZml8SAKhYnMDozCxSpv2JPDLr1vQZ/KooTw6HDZ3IMraYOVyvZhlK3qzzYqd8umya023fQZJ18a2c0FQWUCQ5tZILvAIR33QrrYwN7hrD269YGXLqc31yfQCmS9q5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wu0kA3PNNb08GHROMEQb8UMFEcoguYRZ3sV4qxMiOJc=;
 b=AHjIxU9FQPgl6m7FXECTxuYAHrWXTE+b8EC+PNVz48UlhXAyvnCTF6BPFZa4c0+nEKaSuNYgPZWoOVx2MOa/7ySdOeIWJ4ViRcV0o9pOlpO2zzfa0eERkpWLZG67ioTMFJeW+EKUA6TUPGSxGV0fmqKtYOnQovUTJDkKxQQIigh8YkiZTbtZm3VF32zm+udv6xLRiThmvJsc8xoFo05N+I0Q/hXZQ0oh2TLW2hxdkzV5RCVpEebQajq7Oj8GHVhgAvxOJbdqFaZoovRWxTefg8AqvQ5lw6ict7pRB0dS0HpKJmxWYgl25xR6c+HMlH3DRAYBTp9+HDHNFOLLpvNIdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS7PR12MB8201.namprd12.prod.outlook.com (2603:10b6:8:ef::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 10 Jun
 2025 13:18:26 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Tue, 10 Jun 2025
 13:18:25 +0000
Date: Tue, 10 Jun 2025 10:18:24 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, patches@lists.linux.dev,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH 3/7] iommu/vtd: Do not wipe out the page table NID when
 devices detach
Message-ID: <20250610131824.GD543171@nvidia.com>
References: <3-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
 <06566252-25a9-4b68-8deb-e1fbd8b7a3b8@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06566252-25a9-4b68-8deb-e1fbd8b7a3b8@linux.intel.com>
X-ClientProxiedBy: YT1PR01CA0148.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::27) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS7PR12MB8201:EE_
X-MS-Office365-Filtering-Correlation-Id: f212307a-5c55-40f5-a5ec-08dda8214848
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?C3ZT5gx0amXPevK7K9ZvuAZr9UdTYyYDcjK3tePkjlwbZ3Y8V8/Z2Pt0/0rC?=
 =?us-ascii?Q?ZiM1QwB0KCTDovzyaf3TxoSV7z+v6BloyBBb/Kdu9W/asbYO54K2t2RcA7V9?=
 =?us-ascii?Q?D4BZSa66/bj8kSFiVY7FEE0aBxeEAH4RLiH+IsxO/BHoHoYvqyYBVP3VBhG1?=
 =?us-ascii?Q?WWlAoHBIBnv4cLM0A8a97H/FeQfQuglV7cVadvveczgch85wUGDbmGk0ljdu?=
 =?us-ascii?Q?ObkO4iY486KOpDqdo49fslASLxc8pyinLLJuTu15TC2v8YGXxIUHFfPIK3r7?=
 =?us-ascii?Q?h0mY3kq3KcRG+VWvF5nHWm/LVBSYjO9YKkI/hXECRMhWZh4qpxodR8mf1Tpl?=
 =?us-ascii?Q?DvVAr7/jfcN8ZErBFC5NWD19Yal90BILgNS+vNAi2FndEUcJVR+PD6uTI2hy?=
 =?us-ascii?Q?XeJyCIFiguHoMgdtg6YzjZa3sAEE2cKycH6AaYcnXByQay657GgKDuhVDPNf?=
 =?us-ascii?Q?AxrGFcJKCsWm4Uclyevx8a//7Wfa1ho2F/E9mcu2Ckmy4cOFNbrbskmF84aL?=
 =?us-ascii?Q?r/L0x7j1/ujXz+GxlRbQGONWzURLG0YexNhp0nt66ISp80Hlm2cKoquV9hlV?=
 =?us-ascii?Q?sQ7N/VsfVrGwGmSdCe1VK6MU4pwrevaFvBh4mb6AuB8cf+I8Hti30DfbEaXu?=
 =?us-ascii?Q?8xGqkqaPVPRQhmxL+Rgn+X7LG3yRkO77TVYgwf1XMJCTExppptHTDEf9U1J1?=
 =?us-ascii?Q?HQPMDgyM/eJySt0oPyhNppjBKdpMhjUmdUHgP4UrbfoB8Inhv3VYFgS8EPOn?=
 =?us-ascii?Q?tj4bnGPxYXdC5Y0jwh1m8C/n9+5P/HaVruR16Mr+WEuFC+N7oND+lgC7HHY4?=
 =?us-ascii?Q?hHzn6mqmyVu1jpoCBU9OyVRdGhuQ+tNgQ9CrtorR94UNT7BBuA65cyeTIpmT?=
 =?us-ascii?Q?YWhIvP9iNuE+Ih8fB8dvqD7VUfL9S4B6u5Lmkrqrgd5kf33RtLZ5bxu1HylN?=
 =?us-ascii?Q?qURfpI1xvcmaNlrnRiA/ag7z3PZwrOzgjQLiAm+KFoaKc8TwyK5d6337iXFP?=
 =?us-ascii?Q?mGt7bLkYyof3LFhtvlkopFq7sohIdOJSOX6nb1P3symUPHK7fnljqS1bOSwD?=
 =?us-ascii?Q?xdztrqFo5SZr7wehlth1V8d92J2uP5kAEboAwnRIs4Ap5Y1LqBF7c3QufGwl?=
 =?us-ascii?Q?atZJX72lrxqSsi9tahGVUo0jIcejn9oZ+nwGXlwWFPfuGFI2L7Wwu3Ygf9B/?=
 =?us-ascii?Q?uhRyKtbmSSZN0KfMWnc10pRkBncaRH+7Fsi5uHOhOAhbHDbnF7SQ+SSboQEP?=
 =?us-ascii?Q?/c5fRZcQrn2wNYUC27z8/7r1KzNS1igc0+flwxh3+jZor188lIQUE774pRlQ?=
 =?us-ascii?Q?WK5q5DcI2JQYHkb001p8ReurR0itKjBgV8hp4dbSrVh8V0HcALI4rNHN5eip?=
 =?us-ascii?Q?SzkAbhkwG2xT9V0ZTluPzu4OgtjmEeFr1OjPg4cuttBMX7aN9WB3lNvPAiWE?=
 =?us-ascii?Q?RoDqRbKF0Ew=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AHwi0W+YNPqpDW1OE8tflweFqls3uFriMPrxhJFxWHnA5edmmR8cw502PcpZ?=
 =?us-ascii?Q?GeNfEggfF20RdYNKGbbA7bObPgmHLMLhkCsxrzTc/OjSUZ79U6HD5mdX+yd7?=
 =?us-ascii?Q?7gvXcvLXbBDgVJL+kiwUpqz4X8PDSNRYjn3d9O41v1tITBJzTaaUYnT4/BUP?=
 =?us-ascii?Q?/yq1jM3lwNM/3adc5QPvhvxCehnccZGs76mZAXKxNyVy9kE8cjz6mheh8nj7?=
 =?us-ascii?Q?PE6RYgWjIvXMIEFxbx/xs3B9UVlJPuy4VkNUq3QBfpFROJM/RpmYGuS30hSw?=
 =?us-ascii?Q?jgqKb+nYP7+tvWa7Q8Aq+mgXcSWUQJkez5SOMTJePhxTLlPRBbrrsjFlhUhz?=
 =?us-ascii?Q?26It7jLxNnix8rJUaItoj37jBmf4GlOXpgypcGg2rpFWV15/4dsKt/fqIsGK?=
 =?us-ascii?Q?X7MEdR4mb2UbiQ9liugDw4CQzGDTQuFRu7hhMyMm2vT1kbZUIVP+Lcea8sgr?=
 =?us-ascii?Q?zyxk5wVtjQvm7KsfhbLg/S6AXaAT9rLppm2f/GmK9UNW+8dqco2c32g+k9I6?=
 =?us-ascii?Q?aiduwapIWs0pQG3Sp70iVEYI7BkpUrsyaXt1t5NK33VYRs/+ZE9A6J3r9Q+2?=
 =?us-ascii?Q?FL/IDbjHb53YMJMZfQgPPG8ASHVymEzUIARtBz10WlNMPhyePtK6b7xkMqle?=
 =?us-ascii?Q?FOgWo7NBYGGPplJ+7ZrOiVuuvhi0y4W6y8GsDEepVQUoQTbI4H4hli9jK1td?=
 =?us-ascii?Q?3OgTm/pdYeTFLDYiH0WCrHblmec3bddYtdXG1yyiSrj5+bIkkoM/e9REeIKQ?=
 =?us-ascii?Q?uqwnj2vbkGo9cGIBkSs5iWM3hkHLWr1Ds2Pz0xn8zFUgGPGXVNhiQb1XD3Rb?=
 =?us-ascii?Q?NVcCfVOweUACfp7AvsqlU94FCeiYlWWo1nGL6YZaPdcF7CYq8qT7ZpF2p72m?=
 =?us-ascii?Q?m55MCz1n2q7PO+Nah9Xc5VYi8BSaXAE0V6AymWz/GrK/bFJTfOxtkvCh8b4o?=
 =?us-ascii?Q?Xz47+atuauLJ2brrWaBDaT0mvAYM+6elrxmW00V6AJXx9RQOYOdAnYU2aYUn?=
 =?us-ascii?Q?N+cgLwJ9HtRN30+mna6CYUxN6JlLH4GsoVu2Z25Q7nnkJ2GCDDZrPP5iptRq?=
 =?us-ascii?Q?iUA3PqV1gyHin/QRSfIz9DJ8338kLMmdV59amIcvADuynjiQ9cXjaCbCZ4uX?=
 =?us-ascii?Q?oy9q2KharExFAzkdqTKXAooN4H1woIs/dRqcRqDfaILTvFf1z/5rrRo+wVu7?=
 =?us-ascii?Q?QPKLWACT/WJ1vVuV8j86xblm/2iFfgAhQpnRvaJxi66giVyg9A9mmo1Q7miD?=
 =?us-ascii?Q?Wfgac8Eu0Q8YLTCbBrIcgM2EMsga09uoLNU6lxiDat/0YOlv6tE24hP87xEb?=
 =?us-ascii?Q?clZw/epAYi1RLHdBWIuMKDA6btN0vSTuV5EY3EOIMuHC8W7eWwdXL/mbGnM9?=
 =?us-ascii?Q?O6Lw9P1ObGvA1IlhxKclFd4wGov32YO5vTN/e11Fp1gtUJWMFg7MpIAfFYvB?=
 =?us-ascii?Q?B4/URwSH0FwfufR/yZYCzIF3DZuz0W0F7E6N3EypdZOFAtYEcAehzp3bJ8q9?=
 =?us-ascii?Q?0r1fsIdXapnijp+BRgnWldFMwdNh5XsLOmizAVVO8pKOrZnzqPgErWSGOtfJ?=
 =?us-ascii?Q?5omfEgpuPzpnCzdId8+1v5f3zi5DzjX2LADp35et?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f212307a-5c55-40f5-a5ec-08dda8214848
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 13:18:25.8900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W1aq7olwtEsojvktpqiRuX1CQMSdTd51SvTn4YJtIajqppZiUSNde5uUcwWiGrNj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8201

On Tue, Jun 10, 2025 at 02:41:11PM +0800, Baolu Lu wrote:
> On 6/10/25 03:58, Jason Gunthorpe wrote:
> > The NID is used to control which NUMA node memory for the page table is
> > allocated it from. It should be a permanent property of the page table
> > when it was allocated and not change during attach/detach of devices.
> > 
> > Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
> > ---
> >   drivers/iommu/intel/iommu.c | 1 -
> >   1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> > index ceb960a796e2ba..72b0769c391008 100644
> > --- a/drivers/iommu/intel/iommu.c
> > +++ b/drivers/iommu/intel/iommu.c
> > @@ -1391,7 +1391,6 @@ void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
> >   	if (--info->refcnt == 0) {
> >   		ida_free(&iommu->domain_ida, info->did);
> >   		xa_erase(&domain->iommu_array, iommu->seq_id);
> > -		domain->nid = NUMA_NO_NODE;
> 
> It appears that this is a fix.

Hard to say, but sure it could be..

> Fixes: 7c204426b818 ("iommu/vt-d: Add domain_alloc_paging support")

Arguably it is before this, the NID should not have been cleared once
set by attach. The above only fixed things to have the NID set from
the creation side..

I'd pick:

Fixes: ba949f4cd4c3 ("iommu/vt-d: Refactor iommu information of each domain")

As the patch that introduced the NUMA_NO_NODE on the detach flow in
the first place..

But that would encourage people to back port this quite far, and I
don't think that's really a good idea since it isn't something someone
cares about, and maybe there is good reason the above had it..

So I'd leave it with no fixes line..

Thanks,
Jason

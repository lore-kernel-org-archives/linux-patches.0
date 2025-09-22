Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011001.outbound.protection.outlook.com [40.93.194.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1E722D4DD;
	Mon, 22 Sep 2025 14:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758552147; cv=fail; b=rGpx3eYqmZC9YzuMWEUOSMVtKzd/yLXz32e12WLtbyI1KDa59Ee1DWSoW9fJ8i0vdbHY/cqfpbVw/UsDkaetFBsgEJgHUswBokGzK/n1ZeFAthtAcwCZkbqMw2k3iKy464NlEP42XQykccpIQbBpcd6eBHtTYFJrhfGPTWXVSK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758552147; c=relaxed/simple;
	bh=CcJZx16Nc0QstqhdY3S20Ewg5yhJ8cSwddPo0BQvQks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=taNicj37YQX3WGGzCmEFpezjkaLRYgLlm4xQTFH349Ld2yQPO3/bxGe/iQBG+DFr5gDJev2BltxLs6QvMTvpebak0h6ylmNwkmGlkcV2rI+tLnjzh4lDpoJpyjf8vQpLDagWTKXwOSvW8ez0qQpmA/rhFinrk8wOJ66oHKtDKYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=t+Xbs0sq; arc=fail smtp.client-ip=40.93.194.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="t+Xbs0sq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U16PaS8YCo1AB0egO1/YxZqtHcL4guBqM6yuuA38N6f/kSx67BRR/flA8Y+vSQB73RNo9uTopldjL6LPtGLPJ2QC8S5YBc7hlTxr+0ouFiz/9XbSNKsbgmoFUxGfdMdOZd2USMZ7xx41F5OD56h/RSXczswg1UBdDaaJT38efoCdVHN+PAKn7IMrK/dWyq6Ta55rfNjVbD5gi3qrdaxktZHthmxag16dOSZsd+WPSSN8VwepqT6eERpZTQdKKBlnTfYihwi9dBT0orjxkO3CCKdIy6zkcY2+FAcoz9OYaxeJIcB3S4u1wouijzt/f+jcDa34loh6x+eXU3IHCewZZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wnj02Qux54+LPqNZkzBIuZddRcC0Va4qJoiOjxUEfgA=;
 b=pqIkKCX6kd68DsXpULS5ttSjz/WOP86/SD14p/ktoejlLm1mh7tV099RtZ39NTq2LJn4j6nTQYZhnUjZ4Nn4wCb303aMzALDPvOXrrNoya3bXlvC4FIq4hxDYHYV2c/zKd5V2DLZVS3p+SLlHRryzLzeyGmi+qrghChS231nxgOMEyfBrfstL7p+6xoZhpNEGZLeer/8/ZGjMOst0cRJ8XgLDstPHzqW5g49Ms2F1KRa8Ah+VjUvq2VnmJewrAHiVFkMJHO01F/GMK3yWxfDeKSgAvdtpdN2YeAreBs0dXNsDkxZE0RnFXFUBaEENIjW+Alz4Jj8REUTYmDhS9j8sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wnj02Qux54+LPqNZkzBIuZddRcC0Va4qJoiOjxUEfgA=;
 b=t+Xbs0sq8dilHQPjb0rrDSe7lBv2yq/oskE5+WR/H3muWl2KLs0UC6IoxU4e6zRUkra0R7uLCH37lT6dPxDeMlvNe83HSGsDesi7yaVeu4KH/PZm67E0//swgVvGFLrkSud3/hhIOP9OEkmN6xDREJb75PrfA6DnAMQMgAYuaIqf0sXW5RYwmHgUxMj69B7HYZBexye+J4pl1+AvdCsyuF+i+2I+upKJKlt+AZCANkNC1nCksluGqircql92l93RheJXxwV+9P3xDaXNKs1aU+csQie0/oy62BWEfWG20BpD69Eon46+RAUTRB1IbwyhCbfIUcgXVnrdhKzWl3/Ijw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DS0PR12MB9445.namprd12.prod.outlook.com (2603:10b6:8:1a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 14:42:18 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 14:42:18 +0000
Date: Mon, 22 Sep 2025 11:42:16 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v2 04/10] iommupt: Flush the CPU cache after any writes
 to the page table
Message-ID: <20250922144216.GA1391379@nvidia.com>
References: <4-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <79da2a28-3c05-4afa-90d8-dfc664f101b1@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79da2a28-3c05-4afa-90d8-dfc664f101b1@linux.intel.com>
X-ClientProxiedBy: SN6PR01CA0010.prod.exchangelabs.com (2603:10b6:805:b6::23)
 To PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DS0PR12MB9445:EE_
X-MS-Office365-Filtering-Correlation-Id: 557bc81f-3bbd-4e3a-4fdf-08ddf9e63b05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q1Iy2+oAoK293dPUbdAroL6/uMS5282/N5DgDsoBWLf/9yFl4u4UlsHFRNvA?=
 =?us-ascii?Q?ZpwiTwuI+yUaButEZFsH6QSIWEIcwnezT4gOVBW9lBC3MJ7QUl6M3XkJ7mET?=
 =?us-ascii?Q?qctYG1lLf2qeen1L3AAJ0ZkH0mZ/CejL6JY0Oy6O8s3N6xOKefOyJ4WqJ5t7?=
 =?us-ascii?Q?LbqD93fIq0Nw+oPLnEAzwM/1DDfD+PeiOwaOPrPOIYsJGF/O/eNvvHpyygUt?=
 =?us-ascii?Q?UOxv2vgZIISSVa/GGdiqI3n+LBmvRqk4mWP0ydEWRqr623FgklpG6GaFdn3N?=
 =?us-ascii?Q?RMOcrrPe/tES3hmfbn3iosG3QgXs+ICTHsF4XTsxVvUbXjWejAdT4baqsbVT?=
 =?us-ascii?Q?Ls8b0jaKa67eoipGk8W3LBewG02M2bh39buIo0OEP6twFMRnQZteyWEYZSkZ?=
 =?us-ascii?Q?RWn2uBLksgcyhGPrTTxHycb8/S+YIYOxWbxJpGI+Zy5CjXe6zZlbwFf0jXwZ?=
 =?us-ascii?Q?F10Jz+CmdoMCTcD1tESE+3ltPd2yiz9aQvxFFQuTELfaCSBaC6odxA7GA1Ld?=
 =?us-ascii?Q?Er7+aYJymbXcC1+4o2K7cO/6EV/SUItbm4Wcuykax0YgLORdT6paUMyl+orn?=
 =?us-ascii?Q?YjYTxE/5FPNXt4oFtyjFLC58fFhf7sNVApVUMcDYHqhv0IBJej/RktQTzRaj?=
 =?us-ascii?Q?TDzBdk6kXLtoyxUDglESjZPom+9DHQZnHvzGf1Ivbhjqflaxj5Ohs+VnJWOO?=
 =?us-ascii?Q?x41X0ad5H3Pmyv+bNFiNiM3OTlSNh5zQ8YVIa89Oc4uV2x3n7QU5oJEwJZnL?=
 =?us-ascii?Q?aPZ+fcQeS59aEFnCGZWEcIkWj4Wf5hDOzz3NCA3k4lbGEBdJJcE2nSzcD634?=
 =?us-ascii?Q?lx3WrtFG/hEsXDLx62nuMrHwwqy/u0XYSY2j5UsLdyPvCEJ9UjlpEooB0H8f?=
 =?us-ascii?Q?Ubq4WlxhssNnEiDp5yiYz916PAZj67VROZ+iTm9ZgVbvT9YMoE5v0UU+edqv?=
 =?us-ascii?Q?5OI1pYmmcIVX1bEJMuvg5au3UoWUoDL52Yoge6zSm0Fy/JSWu/8q4bZibaWq?=
 =?us-ascii?Q?qPtqnMwI6eDxPnza1d2c9OvK3HRMk9rR2pgxUE9xn3Scq7V+GowR3LFew6k/?=
 =?us-ascii?Q?CxceKmZprgmC0yz2LzIi/SAGxq2fQVRx9po/DqZsFtjMyRxaK26a/vriODC9?=
 =?us-ascii?Q?kZaHobl1lloNRv4G9gpVtSUrwk4qwlsOIIlZR18kqKQqi/8rErU2dUofUrIe?=
 =?us-ascii?Q?T16xRVQijLwTBpyS/GO2uouEL/2Li053V58sV6T7IYoHN2dDEOjxPO8D/Swf?=
 =?us-ascii?Q?6tLWDtoGBFVN42U2mHwoSVl2dsNugI5ixwCWpFVzZwtf+JffF32XBTFRnbLw?=
 =?us-ascii?Q?k6wb+Mw62vLWi/2BXWx6eecp7hvdCVYM7qzTbeMThgA3C2Zfo21BfYcdamQn?=
 =?us-ascii?Q?GRO0kMWci1esLBfh90KW1kj4Jy/S3s1kwxIFO0Y++bUywg8UdLzB+rB+qqxZ?=
 =?us-ascii?Q?kOQ1GJPsyw4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ANyXX5n76fRd0PTpnDu+juFIqiLfbpjS9QEMN3U2YOEPAiCjwUgP3kiwfHC0?=
 =?us-ascii?Q?hN6TAgYidiNJwMZWkIRYagR7AUasEzb+j7h3cnQ+gj9d+2shhA3clr0VCnLk?=
 =?us-ascii?Q?GFgu3tsS0uyjU3+F/ctB5Dz/yO1TgEXocWT8g64xy8jT6dLuYWWkWBz9Z8k0?=
 =?us-ascii?Q?UIYr/AYPLRJcI+licxy3MmVwFbmHKXhw82ReLpJo4NuSBNUPGI9GGI0GJO6c?=
 =?us-ascii?Q?Mvua0WXFbejEt/xr6GumYDO8QVXr3jkG29v3uGXtDRBE2Q8hqR+VgM66pqDY?=
 =?us-ascii?Q?yWp+DIaADBLMfqhsWnKFOVFroQTEOZR/o30ZG1+ou2bj6MDD/9tLMnMZffhB?=
 =?us-ascii?Q?19ZJgn5YYdGTpewg0n6FSTbtcwWpahrq8gZQtl5BbcCwyQMIftIB/NDeJLMW?=
 =?us-ascii?Q?o0eZMvGpMdDmc1fBVkX15oTdM7wGcNYu1b5u3zAHlEEjourOqGJ0a9zQmIFI?=
 =?us-ascii?Q?q44I1hziNEw7clL90NrdqJW/C/AOzUoicsD+6gqWMhUGCI/9eXI2CVKrfkwj?=
 =?us-ascii?Q?MTkiv28dhHKyt5b+qs/8PyVx4Szgx6lPdAldMG4ZXa28oO9xvTXHHgRXtBVm?=
 =?us-ascii?Q?urtbF+mYBG+IBDBlTaoFEVkUTPIDz5LwdujGYw3Buc8djmTwW6n5kFC2wAWL?=
 =?us-ascii?Q?xtQsvGoLTr14ldXvw5zlwPLPX/2QIYjEkP33BKRDDbp3s7RCRSSXft+jW5r2?=
 =?us-ascii?Q?veGTmR9S11EbzJlk+JUVFye2z5kR9ZVTwCNZoNywtEkNj6YtRQkMEqrU9yQC?=
 =?us-ascii?Q?W2Ji6UE3tBaS2cALbdMoRvlKbL8tCptHQQPNeFhGNMQB/rJhbQ1RXkVGApSm?=
 =?us-ascii?Q?e0L4/8pmzXL0U8WfrMy2fU0L7dv90S+BUUwOw73O5MXCSrZbnGmeIj8r8Pdi?=
 =?us-ascii?Q?BGgx8pQeAQZ7rnyS3dnM+aBQMyznLZctAUmgSPo8K1WbMGOHpNEG/IOj+Qjn?=
 =?us-ascii?Q?UfMyz10IinGi+WJkE9G+ld786tG0clp8nyOYTEzt775/ptYarhhvHKgHxGmL?=
 =?us-ascii?Q?S7SjhHL14UCVQS0caFLG6tdfgJBByH0uI5ufgiTSGhAbw5mgbwyfnF9m0/Bb?=
 =?us-ascii?Q?yrkaerVUcYr7nA3eoARybRWXS8W5yMaKVPyv0PbUvWS7GcAv66U66s6oeyeW?=
 =?us-ascii?Q?bQDlNlqdBzxH3HlhQWDmLz5Dg5Vtdn+SBhC+OZ3Cku9xR1WPhPZNH/qrQhkG?=
 =?us-ascii?Q?4Kd8nMPp7jycbD4BOCYqStWSKpxNs09vGtRREiFMvejqs+ENoh3DWj7JYFsR?=
 =?us-ascii?Q?8U8MFMPIFeB4rDgbovrMx9fdv3l9xnBtZ9CT29Icqg5xHS9FmO4iyRNzZZpf?=
 =?us-ascii?Q?VsjVD/EbJlcoWkUSewq/1bUmI3HBdsJ5m3oipRkDpu17+aMuBy/JdJSDFkng?=
 =?us-ascii?Q?rnCkPxzjRZyi8nZPiTSoMfZKBxkb/XkbOREe6ix9ux8Q4nccm6DkQG1Zrnq3?=
 =?us-ascii?Q?03F6eDkv1mwuQsqfteke6niE9InFVeP5rZ6Js+old1TWGzEvcgDOxIObpPWV?=
 =?us-ascii?Q?/A63vofREtLNAaZQF3vRIA8r35xvPp3WJn/Jp/NI4wPGeu48l8Qu8sMWrQvv?=
 =?us-ascii?Q?h9KX6P2bHNKVOt6BHKA1aUi9D8wTug5gB3uFBFJK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 557bc81f-3bbd-4e3a-4fdf-08ddf9e63b05
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 14:42:18.5650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JDoF+dUsC4GRXHkEhzjrOw7Khwj9z5oJBLHGiP2JDcdnUV2i2JiWAbU4bdJZkksV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9445

On Mon, Sep 22, 2025 at 10:12:15AM +0800, Baolu Lu wrote:
> On 8/27/25 01:26, Jason Gunthorpe wrote:
> > @@ -195,6 +218,10 @@ static void record_dirty(struct pt_state *pts,
> >   				dirty_len);
> >   	if (!(dirty->flags & IOMMU_DIRTY_NO_CLEAR)) {
> > +		/*
> > +		 * No write log required because DMA incoherence and atomic
> > +		 * dirty tracking bits can't work together
> > +		 */
> 
> Could you elaborate a bit on this comment? Is this a hardware or
> software requirement?

dirty tracking relies on some kind of atomic operation coherent
between the IOMMU and CPU. AFAIK this is not possible on any arch
unless the IOMMU is working coherently.

> Are there any software checks or enforcement in
> the subsystem?

I expect the iommu drivers to exclude this combination.

Jason

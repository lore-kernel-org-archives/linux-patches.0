Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010000.outbound.protection.outlook.com [52.101.85.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C1A2036ED;
	Tue, 23 Sep 2025 14:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758636827; cv=fail; b=n9eqEUMDtgYOUQBr6SpJKdVVUTDLwqxO67A7BQRLmaWfyGzknbe+xIWnGfPj8yQ4DFYxJt8zXPWyDf5Gg50VX9+LA0ksu0TSOTD4naBGUQkUsUIx03NJ9aV+QKV/IeuguxfEGJjiimGiwaFm1dyZ+KbJF2keAkTygER4cSuuL2Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758636827; c=relaxed/simple;
	bh=iWur3K6HvIoixY1Z9ojykFEc1L4xSOH8BQIMlocLRUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZCbE0/dexwtNWPSg05YF/OGpSGh5jp8rpqU6zYKAgYJUZf3ekBSMysXOU1GsHWgj7M9BlMbCKNAmmdIrvW8Euh3xFnmazu8vWLTTETNn7UKlIXDu4/dyq/kI9BBRUM+rzS416IbxUTfb+nR1MQ2wdcLCKrAVTZA4732CVDvxbPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GDxElHZ0; arc=fail smtp.client-ip=52.101.85.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GDxElHZ0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TThREpZboapVHkDq6SLUEHGsyydw1QFuTR5N8TTbFnQzXDZ/R6IW58qr5nMF7g6t1JOyrGD9h3hJc8O/QQR21odznB4VtOEj0j79ipxTHpwpnfAzTRJ0rdh48YXmKBjLbD9cc2lUzYxXzjjmaa78s+xAdppIkg4zW7m9ur06zcFAgPSjnYOIr3eRPAm9jFkhJS2CWYxSxrZ3pTZ/WK+BkziYDTVLiQMdB8xipO1QOPC07uMyaNRjkNFdcuyM+AwDghycP2nVmg5xsJPk5f9a74EpuSGOBLYqPGw2Xrkns8vx53dpLQ9Pl0puDTcgVri5lLlG3Er5/Xm/hWJs0P7vVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=alrYgJjCZW04CX9mv3mS6VnHH9c469yVjtI1m3pP5PM=;
 b=k/Ga4BagK4WalBHY7AXrbYgXXkf+gOFBNq0J2Qy2EJo4xGlCqUkJO0kaBUoJkau5kErG2jaLrYSHmjWRf7pohVZ2DiRb9KqrzT4l1LTXmA+mZmFNOlHzKX+zBZcs3ibv5HULrJc22T5k/avo1dxUbHOwMgTX0txTfQF6/5yGoo6Aja7lwdstviw9ePRsU/KyJQQh4TnHhZAQh95jiCE7zNC44bke7ZerXOT/q1/RsDD3/aibkbgNu559kUoXBemjszljefpcXPPtBN0yTE3dcOq0gQF2n5yfVjSuwdhyPoaubZBYhCRQpuN1WxJPd/tIdyBoQWxdI3J+lbI1qZj6ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=alrYgJjCZW04CX9mv3mS6VnHH9c469yVjtI1m3pP5PM=;
 b=GDxElHZ0Pq3Zvsx8JdaKPRAr8mlfqJRZs4f8btRYNC1xMFUFhxNl76nhoP2VKqJMNT60DT69b+J6oIXeW0BfYtE4x12J6IyMRJiE6fUY4yABtww4nzR5xQEcOmBVGf7MDD3fRIc50ZLRAQ1T/g/19bDOlomG/IsM1MKm/UlI6g+J9XRjRD1FwqCLOMS9CL3BXTmwsXguWP3xYfH2SQdHABXP2wgqFWz70XYM4rmBK3ZQLZMopayUe+HAT9Jgb3dbmVzwGDQEL/emKURTDxswzDuqcbuP6nQorCL8iaonWpMLHwjyT+FPJ3mN/+QHgFMY3367c53IfYWA1VX+5hRq5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DS2PR12MB9664.namprd12.prod.outlook.com (2603:10b6:8:27b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 14:13:42 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 14:13:42 +0000
Date: Tue, 23 Sep 2025 11:13:40 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v2 04/10] iommupt: Flush the CPU cache after any writes
 to the page table
Message-ID: <20250923141340.GO1391379@nvidia.com>
References: <4-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <00a3fff5-bf1e-461b-9673-14725e3cd6e4@linux.intel.com>
 <20250922144447.GB1391379@nvidia.com>
 <ba1ab9cc-327c-45ff-9982-5d11551060c3@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba1ab9cc-327c-45ff-9982-5d11551060c3@linux.intel.com>
X-ClientProxiedBy: SA1P222CA0017.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::17) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DS2PR12MB9664:EE_
X-MS-Office365-Filtering-Correlation-Id: b48a9e89-d613-4576-4e9e-08ddfaab663d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i9BFc/XEYZy9lhaoU9F5ijfiCFnGRWIW+oxf8BeWAWk2PI0q0nzID4oYdZsO?=
 =?us-ascii?Q?vpu6IIM9BqXGOxl/Dlqn+woXABtZRHjM725FPe1acsAtdZPMwvB5BNLH+DGd?=
 =?us-ascii?Q?TWyj1psBYzlstWuyOKTDxko2qRzConV8kePF4rwfBlijPG8qj87qdNCjOEPS?=
 =?us-ascii?Q?lY46/f8ApC/nVVEJT+dgPyAFDUg+UQqVb2oBQdeCk2MsPnhJjYQi9LPXr2x/?=
 =?us-ascii?Q?V9OYe4ceS8XugZDqTBgQdK4Ov4scpu2ASQriVUBieJIIXWH+6MZRNJBFhxUV?=
 =?us-ascii?Q?+ZidZu0wKLBrmwGlAebT8Ek4SKfjM6E+M9jysqdEXE62pgPlBEOZAFJnL5mt?=
 =?us-ascii?Q?VVyqLkV7rgMFwpXb5dRBUJVpq5P5IUurPtsuox0j7NxTIPAFHPpRVJs1qsU1?=
 =?us-ascii?Q?6Bl5OfqrrTyOXw2Xpau7zjY/GFcOq39i6EPP1b/7ViAX4/bmWBbxSIIteZSu?=
 =?us-ascii?Q?bjrcAwYH1FbiJ9cPg/e2eVvyH6AHV+70hl1ttZbRcBD/FutoiEx/0BywTosx?=
 =?us-ascii?Q?r0Bz7NK527lkCpHGnfLCRZgjgcS+Oo72rtVZ1b6EyMYJI4fCTHQVJOyWnA5s?=
 =?us-ascii?Q?5+w9Dj9AJxRgvdVWqMEFYTJ3EWP6pKrKO06U1RblMXNvrJhvGN67dLnRccV8?=
 =?us-ascii?Q?3wtd52JzMsnDjgm12kOitmDVM1N4fiSOQb4ZGw2uF+7vYDWb0h5T9LXZWrHL?=
 =?us-ascii?Q?PWgc0Sa3Y6UNeBvgV65BbzpEF1EKUziTUGMCyGNclb0XDe9sKqw1CwKd+10Y?=
 =?us-ascii?Q?eI4wYpksqqSe9G6D60E5Gw1GsYpDj2iPuJPXSq/829NfdYF8VJg+LTRoNIxH?=
 =?us-ascii?Q?FJD6CbVO8kOrQqpsgGnGjUWKmACZJMRwjM6dZ/lc+KutbbEJe5GbpHfzN25z?=
 =?us-ascii?Q?R+s3lKKAGJs0XXht8zOhAbbnf3+su1a06K2j4b0PP+JbYYRhGbu/k507zMfK?=
 =?us-ascii?Q?3EKjmhV9aiB8FVpxWGgPJMmkWEB927m5rj53hsmkLh//ESW31ABRrDriYrJa?=
 =?us-ascii?Q?vQ4MszZywF25Ly1RYjtPc1L+JzLY46ToYqoLAYFrO8/RM/6z9oXxviZnQaGa?=
 =?us-ascii?Q?Hm7v5MZRV17gD7VoeW6DthNdSRz5E8XXAsFTCnHxtnIO4a0f1YGEdlKws5Ou?=
 =?us-ascii?Q?p8D7gSHWBj0NBh/CbIXV5bwoCIzyUaopeSqxmmK++9I5XrDNBezP5/WscZec?=
 =?us-ascii?Q?JyvYELVBB/D+9igMxUQ55s1S72cT1l06FTBbgM3tzUegC3yB/kv06WAS7rm0?=
 =?us-ascii?Q?GuV2+gUsrieAhQqVbjqKpI+UMpXW7dNcDIyou/1Y6Ce1jUQcV1NnYNrUl8Rq?=
 =?us-ascii?Q?WKzyfhrQn0i3JEidwZCk8Clo9Lr+uyL4MC719WBhV2tb1AynZ+yfCRTqFyOB?=
 =?us-ascii?Q?mEPr+0BIgt6KPMzR49f9mAaJcGv7PunYKv959o/dxviFr6ojw2l3DVa8Gk+I?=
 =?us-ascii?Q?H93Hf2+6Uz4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m8ixsf3eHemIm29o2gXZbhWxcKXPtwrH+/HPOnYDfaHkxUYj0ooH71JYjL/R?=
 =?us-ascii?Q?zyMHZZ1L0JK3CKJ79P4xVvucspqXgmEyZfB3k6VA7FEMMLdriODwDKI2j7fC?=
 =?us-ascii?Q?Yi3n8XDmWtqUu+9hnmu5b6bSaIWG5hqsA/KNwiz3RaEoSvfJQhiMoEaEnqxu?=
 =?us-ascii?Q?Wkcn6r23xgqm6C5qHRJ/KpbXC9dti6Cqd6D/fmUMN/Yyl3a01fZkRrQhDNZX?=
 =?us-ascii?Q?EHiobbEt9lpKcx4qyIcM7p3mhB/Yu9+SI6uFaHB3QAn8xo+hTRzWP39GJo/V?=
 =?us-ascii?Q?ScWRaQbvSCeiL6hbcOr3v4GvaesEekHHBu+v7PePqgwejtcabA8N+oQNStYj?=
 =?us-ascii?Q?IezxOMEt4ARUKhCItJ7xoZOedarDamQkc52JikA5HDOpKJTsCoBv8D9xMLGY?=
 =?us-ascii?Q?mjEdK+QbqxnrQgNhYSzbbVRvvI7q1oASxAJv/WplxuoklnV5jH9kUjpG/tor?=
 =?us-ascii?Q?0IjAm1KJcF8zrdF2xqPXvXmpxW9xgpFD3ZWNnzXb4j23Tjf9s7XJ2YGZ2xHZ?=
 =?us-ascii?Q?BW106tLCSrXYMxBNDIFuQWlSWdtGc+2BNpOGQx6bfqM+pF+/ID5DHHEoMnxx?=
 =?us-ascii?Q?2vxRYIQIpnmbAU3VuAi+Xzm3O408B2Y5xua/Mjam0Xs4yo90OXTr+UHPcm9/?=
 =?us-ascii?Q?/cncZDfVmFnvOy7F4oL6VPt+tq+Aao+2ofIogyyAEcWn7bUJX6thNbLpRqen?=
 =?us-ascii?Q?chafJsFGEEOtIBc9OaZXn8CUYneYB8SCTFdgOkrqgrOj8KHLZMbNXZ6paWGW?=
 =?us-ascii?Q?WQJtz4JcfnMcGW959o9CdQHeettVs+m3rEkh79LhRMMHjt+1BuK8EdTYSckN?=
 =?us-ascii?Q?UaKARDUNFVSMuZXcV2ooDNpl0EdYj8lnvP7UXDyxcd97qUam5ZWM/Pbu0iNG?=
 =?us-ascii?Q?f1MiA5UPLzRM1svbKmrQRZVZxkiBtr/f31EpMFTc6QX11N0YrttQdUOULoH+?=
 =?us-ascii?Q?m8/zbw1m0kxSA/mw543PV5PlaEY/L7t3V45tn62mjoO8EioYNsvHq8BiKwt+?=
 =?us-ascii?Q?GTLiHtQ3rFoeU5dzjdZBwZuUCX22WsCJkkATuyQz8q/mQpuEWD26vTPu7uyl?=
 =?us-ascii?Q?yEu41LmOtirlxfOWblTWEAl6KKUKy1/rOmOJS/bbet26urgjHCvXYDU5q6w3?=
 =?us-ascii?Q?Z14Hq9dt7HnxZAMP2VXgVMb4cWfjCJBwza9XDC7zcQGIyrXhe9v37iV2hnMS?=
 =?us-ascii?Q?23bSKyWP+85jwGrDoVQwqboNz1CO+rdc+n7il9mPd6qLGcf7kM5XwIgspWWt?=
 =?us-ascii?Q?6qQVoHTjDZQXBTDJxaXvkRIH8xfqNmVyZgU8YPHxrBZB5F/WTSBSBSJMMpMk?=
 =?us-ascii?Q?anTe27QohA+NDgY1AIGql2P0fu0jE6u1Od1ncacRlicoWag0X+PGTsQC2pXg?=
 =?us-ascii?Q?YrrwGwixFcvlphZZmxDMcPMqffSUEPF4WZtfPEArC8glertf8owZVc5AGVIs?=
 =?us-ascii?Q?uEBEkrpYjOQT4YJCGft85SAwZrwxxaSuSqHWFENR59J6RtJm6w1AhY0OXiDA?=
 =?us-ascii?Q?yIZpKlr1vbozuaKewXea+8SFs0zmCNmfjnWAZxfYkq74oEM8vyJAiu2DgrKK?=
 =?us-ascii?Q?O24akmGDM28Q6a/V+4kJ8WzuzVyyoPrOXehzTMMn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b48a9e89-d613-4576-4e9e-08ddfaab663d
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 14:13:41.9882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WrAG0tYKEmaNWJq5WlHQdADL1i4oSrcAla6NrnfjsFZbcqU+m8CJLwDYHUuOLpcL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9664

On Tue, Sep 23, 2025 at 10:29:21AM +0800, Baolu Lu wrote:
> On 9/22/25 22:44, Jason Gunthorpe wrote:
> > On Mon, Sep 22, 2025 at 10:31:49AM +0800, Baolu Lu wrote:
> > > On 8/27/25 01:26, Jason Gunthorpe wrote:
> > > > @@ -585,6 +635,7 @@ static __always_inline int __do_map_single_page(struct pt_range *range,
> > > >    			return -EADDRINUSE;
> > > >    		pt_install_leaf_entry(&pts, map->oa, PAGE_SHIFT,
> > > >    				      &map->attrs);
> > > > +		/* No flush, not used when incoherent */
> > > >    		map->oa += PAGE_SIZE;
> > > >    		return 0;
> > > >    	}
> > > > @@ -811,7 +862,8 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova,
> > > >    	PT_WARN_ON(map.leaf_level > range.top_level);
> > > >    	do {
> > > > -		if (single_page) {
> > > > +		if (single_page &&
> > > > +		    !pt_feature(common, PT_FEAT_DMA_INCOHERENT)) {
> > > >    			ret = pt_walk_range(&range, __map_single_page, &map);
> > > >    			if (ret != -EAGAIN)
> > > >    				break;
> > > I don't follow the single_page logic here. Why is single_page exclusive
> > > with PT_FEAT_DMA_INCOHERENT? To my understanding, PT_FEAT_DMA_INCOHERENT
> > > has no relationship with how the page table is organized. Could you
> > > elaborate a bit?
> > It is this comment above:
> > 
> >                  /* No flush, not used when incoherent */
> > 
> > __do_map_single_page() doesn't implement the coherency logic. As an
> > agressive inline I didn't want to bloat it.
> 
> But, is that functionally correct, though? 

It is functionally correct because it is never called on incoherent
configurations :)

> In the incoherent case, even
> if a leaf page entry is changed, the cache should be flushed so that the
> hardware can see the change.

Yes, and since the code doesn't do this it isn't called in that case
otherwise it is a functional problem.

> Basically, I don't understand why
> __do_map_single_page() is "not used when incoherent". I must have
> overlooked something. :-)

Basically it is an optimization and we disable the optimization on
incoherent. It is disabled because implementing the flushing would
bloat the code undesirably.

Jason

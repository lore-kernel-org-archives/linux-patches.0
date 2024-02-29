Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2083.outbound.protection.outlook.com [40.107.95.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248B7185B;
	Thu, 29 Feb 2024 13:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709215060; cv=fail; b=XKVYyhNW4go7Mt60D/G4iig17VaOP3kv2hyv6wSE9NLiPjoHbzS0trT1mQfsp6bHitFwRLNm8/K5E7LeA4M0ih4Sgv1xfS/XO1zQvDWWXyEU5yXh4FkxFZIeORsy2ApJS2aX5VBmQpIaL0iCWN2Q5bpl8Vke1Juzl8tZHhkhe50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709215060; c=relaxed/simple;
	bh=sWb1EVit4/qIakAcveTTIZ6XnjdxPk7ATmYanH3YKdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AwUJ1PY+Rr20TKXD1wDdT+WwAbS7JsyHzjNzl4Je9HTe8TqNR635exfhu1JZ1v8LfhD48N5ikMstoncjQmUFuWRcN+2rhGBV3ORxVl3BAxAWF/w+U1wCUzqABatGMljarTtu4XJyu4fXKBoE3whZA1EbBuumK0eH6QLX9TGIQIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sH45Aj+o; arc=fail smtp.client-ip=40.107.95.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sH45Aj+o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fxKgAkgH/bonQSVP7F9tadgFcU481B4zF5VMMj7e19groJlzdxxlIi5Iwt5/bBV2707Tj70SwazGOVdQJB7YxuOe0YralZfh1XugQvaZby1Cgfl67q+8DU/bzbMtfP1BT+Yqyt3e6bWO+JTdnkPfFdY3vfVpx1BZJx0x3NJTlXJgQ9G1MaKLA6BXl4JomLYBJt9io8JLOE5k0iSeaAkRZ8XigDkixnDuzsW7HFkRcm3jlxLYFEksYFCIxDLRNRjr4xEwRyeaqGKpE6Oqu4avgKhBCnCUkHVKTxUs+f5H1GwiB4cJCJhCmEzrg+oNJ+IBz69mnw1d1Xa+ntTbi3EKcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8NWgEX7+5AD2tLHAV6JhnzQET6E8qcLgfoBKUsrpBJQ=;
 b=bc/NVrQpHOnFKi60A4BLs+1Oj8vteeLxWMXvOro+PmAm6gO0h3hqjWDRkFCWhG6KtaRPfdoWf2bTnr6jRJUdMhUISjZsbLzYoFtXb80pmglckH158DtE+kC+O9djF+VT8sOR0k+PUzqHEICBNHe5j7RG17ZFM17T+bzzASyUhsbRZlgVgQU4g8TRt5DkXIzxNtvwvQ1KVrfcv8fYi/Kl/22lH2fUjUFzy6nbCL5rHQyw2DvHe+oQ03dv3aHDXiKxC6uO2L69u9VzeDZoVoZdVUqxedVXQC9oV/AF9lFgkxSSGlVBUifOMO9E5eExtEvNREcHwL5DFnCk323rdo4fGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8NWgEX7+5AD2tLHAV6JhnzQET6E8qcLgfoBKUsrpBJQ=;
 b=sH45Aj+okXTOiwohN4Sh0bGuBrfxqYNUAtpBejYVsmSleKvMEF4Xs9WcHLBe77SgoSZiEwH4w2Vp/Ov6Lh9xQlbsW8D6VOilYpGaN5tuBeKxHx1nOT0OHuoXGuSL4kkXX5v4Tn3rzoB7g7mVswujYXoJmRpuGSR66s+MwCQYbIOKILXUZa2/crHVIey85k9ar22wT+ju1pptZJKIXGFiT4V9RV+MXR5V+JZ2+4Ysnvevelx/JfsoRJbbAvVDPwpAkU9drqGCMHREd9ccrt2cdVvXbsy9hYejvvFRgSbDJRFImL6fvw5bjRySXtFTQtYjqV2KtbBdP2vhtmZ+rO8ytg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by BL1PR12MB5828.namprd12.prod.outlook.com (2603:10b6:208:397::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.39; Thu, 29 Feb
 2024 13:57:35 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.037; Thu, 29 Feb 2024
 13:57:35 +0000
Date: Thu, 29 Feb 2024 09:57:33 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 01/17] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
Message-ID: <20240229135733.GD9179@nvidia.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <1-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <20240215134952.GA690@willie-the-truck>
 <20240215160135.GL1088888@nvidia.com>
 <20240221134923.GA7362@willie-the-truck>
 <20240221140818.GA2635804@nvidia.com>
 <20240222174346.GB9488@willie-the-truck>
 <20240223151841.GH13330@nvidia.com>
 <20240227124318.GA14089@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227124318.GA14089@willie-the-truck>
X-ClientProxiedBy: BLAPR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:208:36e::8) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|BL1PR12MB5828:EE_
X-MS-Office365-Filtering-Correlation-Id: 03804e74-4973-4dde-9366-08dc392e61b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wcJVMyNY1e+xH9eGtAGbsRmTlur2gAJTiBgcDGQNj3O6BLTXb9bvX7TD9Huo4F1ph0L4Dye9zmOPkmK0JvMeJwte0qF9oYGnJfs5o48xPtfOTMNMjDdL7IBzevg0ll9FUnjLBnL6Nqp94vw1F/HFfSElCncf/582Rnx0SCPq4zbBlPKiNdQXj7NHPcpA8xiAcvKNvJaJo0aEE+kTfk/UxTTNU/Cu10XSvgRcEbgYI8kX3nuGpIBKcNyFzi56uRi2AM9TvyMwroJwM8zINR9jK0Q5dh1/FD2lpNcRNMAB8X3tONv9yaPbrjDD1bktx0vvDaZM80G0SWO9z7g78P9uTCMSQUVqvN9+8hOIZxc9/XzA0PNnrYHqyVEV6xP/4+wQZnhdwfDsMOJ2SI+MWhhWsZmFTdLPbX4QPrx3PyQpTpZFaz33M83oHSNv79J1Mn2VdrmRi6e0esXwrMMJG0twT2Enmc6KV7P6iMb/gp27sWf8ccbYxepNBPLcXPMbA/Mn3R+vNpQmv4zeRkxRNdcg7DHyv1gGwUvVbqgeaGnZqbvRjoTsPvOtTe1fr9SXZ6sAvdY9G40To3IFwVlKRVpyaGXVPvzUVCNE/SmtLa6wQNSSzTpkUtzzb7S3RsNqo2tEXsdu0Sg0UABwis7WuweIOQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?du3lkvQBwHs8bgZz93xkI7Tf9YY0bm3870NeHDKMz1u5YYL6ZoKKhy9Y4CHb?=
 =?us-ascii?Q?aELsyujEJB0FckjM3zFLGt1RIPUt3SvX71W58I4ggmFvrDR1bJI6QzopI69V?=
 =?us-ascii?Q?QNhZ3Ry6GCixJUduFdmRNweIAGOC1rN1V3Mz2NzautdWNmXAvqYOJxZqI6Mu?=
 =?us-ascii?Q?uyJ3xb/zx0+/RUOay/S+VvWZm9sjKEnh3ZAtI8mQevcuPhXbR+NchIakS0PP?=
 =?us-ascii?Q?svbNd31MVawm1sExc/radyE2en9QtTQwfzCwgXEWh2LvGanLIVA5YgeiwiRx?=
 =?us-ascii?Q?fk/rA93U84yMXBz8U43auIlhlY9m+R5wcYEHUN9ToRZRz3X7PmEZ9VBQbAlI?=
 =?us-ascii?Q?cfIsQ6BEnrr5ll2zvfZz3x2kQ+CCtfldXmdHlVvef5yLimrQsTpgp98b4Wvt?=
 =?us-ascii?Q?nkXlpniloMNMSNZvCOvOQd68Hrs2UjyJExp7qREsCxTOJQ/S1RzG9sgN9Tdt?=
 =?us-ascii?Q?h8hId3Rp+JBxBw23SgYsZBt/gtHO1soqgE7/oOIvqyk8KPTHkHK+4OgtOfJF?=
 =?us-ascii?Q?Lkb6MQ5jz/QZB7lvHgG7lgu0aMwwmohwVpc+qSKqokB4cdnG3M7v9UcvDwR8?=
 =?us-ascii?Q?+MYiWcZAHG5B14BdeiE+A5/yW0uzWpLKeqdVcKeXkhZPEp2/2r8ARjg/rmED?=
 =?us-ascii?Q?4RU2eUy62AwFhV/3LQKptXVLUHpbJHdaRhANTJIM+/o/AeWBtbPIY0FZG6bk?=
 =?us-ascii?Q?kcsGDbeXVdlo/nAt1Z67sW3GwJxcL34XzJh792faVqtWSoncOibDDRY4yObp?=
 =?us-ascii?Q?/cBY0vgkzKS4QkrgTJBV1lPJYlpvpDWzCsk+8QXZeg563t7e8DaxGMtqNE0H?=
 =?us-ascii?Q?Y4xNvzsL98yVADzI03M+uUO1XcWUVHGnGYA3Vx7qottnJcgTlyZo62C+34lI?=
 =?us-ascii?Q?lmaM/zcYRAqBBp4Wb2qu78vxEdF6DAP3mcV7o9gC3X/hj4K4nw3kSJTIrh1f?=
 =?us-ascii?Q?2k9tLufi75A2SuM5gA+H6L821bwW+LwgapMwU0/2OmKLRobJGOhyJu793f5I?=
 =?us-ascii?Q?AlT1PjPd4Kd+ag4IcguiQzED0C9w0K3i0Zderp6g9fTghQEq+RIgokhAWOTq?=
 =?us-ascii?Q?VYubGS0ZBRQWEECek+hdy1bld1QsZYJExyR3GWUAGyOCZzgUwQE0WXvXw8LZ?=
 =?us-ascii?Q?sn+TUDPB8ffVdm6YCmwM5B5M5MP1YgdQumKaRfdjvSoavgC6KVS6jYcyGDHy?=
 =?us-ascii?Q?NOF+L8JOJsWFtRp6EyePzYpNKX4tMlNeVw0zV6qZ+3LIn6z1Yov8bo3bvsjC?=
 =?us-ascii?Q?a9MF1Lf5KAI5zQdIS1VaT8TsfwL6uupq9HFDR05/lXdRvd1a0do5iCJaPJhr?=
 =?us-ascii?Q?HdeHeiHX+5WGllY/lDpyvgfE18kY9SU7ThoTIroVfrahKsGMk99sBjHROWb9?=
 =?us-ascii?Q?+y5/BTIyAKH7u69LkkySi4W/Qs+3x4O3Odi+hGjD+eNqNem/yKxA+VwFtkdr?=
 =?us-ascii?Q?DoB/cg0cZZn3dp9tsegzSInf2xYdBp7bU0ohiYEHEg+fFcWAofKuCTT22fcA?=
 =?us-ascii?Q?4OZdgjnrvQnqy49ZoQg5tDcJPJkOstuItuUcriJi4H7e9ns/XvFbGcfHEe0n?=
 =?us-ascii?Q?sI1iZUDnoHQ8DGCROeIGO+qG19C+bsVvv3Ct4vCX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03804e74-4973-4dde-9366-08dc392e61b1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 13:57:35.1336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9mZ8Pj80uPcOAqGF3XsqlC6Cvqv8mswtpUueJQjsUa9SS6NWA+yVm+swyf1yPbkU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5828

On Tue, Feb 27, 2024 at 12:43:18PM +0000, Will Deacon wrote:
> On Fri, Feb 23, 2024 at 11:18:41AM -0400, Jason Gunthorpe wrote:
> > On Thu, Feb 22, 2024 at 05:43:46PM +0000, Will Deacon wrote:
> > > On Wed, Feb 21, 2024 at 10:08:18AM -0400, Jason Gunthorpe wrote:
> > > > On Wed, Feb 21, 2024 at 01:49:23PM +0000, Will Deacon wrote:
> > > > 
> > > > > Very roughly, yes, although I'd go further and just return a bitmap of
> > > > > used qwords instead of tracking these bits. Basically, we could have some
> > > > > #defines saying which qwords are used by which configs, 
> > > > 
> > > > I don't think this will work well for CD's EPD0 case..
> > > > 
> > > > static void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
> > > > {
> > > > 	used_bits[0] = cpu_to_le64(CTXDESC_CD_0_V);
> > > > 	if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
> > > > 		return;
> > > > 	memset(used_bits, 0xFF, sizeof(struct arm_smmu_cd));
> > > > 
> > > > 	/* EPD0 means T0SZ/TG0/IR0/OR0/SH0/TTB0 are IGNORED */
> > > > 	if (ent[0] & cpu_to_le64(CTXDESC_CD_0_TCR_EPD0)) {
> > > > 		used_bits[0] &= ~cpu_to_le64(
> > > > 			CTXDESC_CD_0_TCR_T0SZ | CTXDESC_CD_0_TCR_TG0 |
> > > > 			CTXDESC_CD_0_TCR_IRGN0 | CTXDESC_CD_0_TCR_ORGN0 |
> > > > 			CTXDESC_CD_0_TCR_SH0);
> > > > 		used_bits[1] &= ~cpu_to_le64(CTXDESC_CD_1_TTB0_MASK);
> > > > 	}
> > > > }
> > > 
> > > Please can you explain more about the issue here? I know what EPDx are,
> > > but I'm not understanding why they're problematic. This presumably
> > > involves a hitless transition to/from an aborting CD?
> > 
> > When a process using SVA exits uncleanly the MM is released so the
> > SMMU HW must stop chasing the page table pointers since all that
> > memory will be freed.
> > 
> > However, in an unclean exit we can't control the order of shutdown so
> > something like uacce or RDMA may not have quieted the DMA device yet.
> > 
> > So there is a period during shutdown where the mm has been released
> > and the device is doing DMA, the desire is that the DMA continue to be
> > handled as a PRI and the SW will return failure for all PRI requests.
> > 
> > Specifically we do not want to trigger any dmesg log events during
> > this condition.
> 
> Curious, but why is it problematic to log events? As you say, it's an
> "unclean" exit, so it doesn't seem that unreasonable to me.

Well, I would defer to Jean-Philippe, but I can understand the
logic. A user ctrl-c's their application it is not nice to get some
dmesg logs from that.

I recall he felt strongly about this, we had some discussion about it
related to the mmu notifiers back when the iommu drivers were all
updated to the new notifier API I built...

> > Jean-Philippe came up with this solution where we hitlessly use EPD0
> > in release to allow the mm to release the page table while continuing
> > to use the PRI flow.
> >
> > So it is going from a "SVA domain with a page table" to a "SVA domain
> > without a page table but EPD0 set", hitlessly.
> 
> Ok, and so the reason this adds complexity is because the set of used
> bits/qwords changes based on something other than the cfg? 

There is no cfg for CD entries? I think it is the same issue as SHCFG,
qw1 of CD is not neatly split and qw0/1 are both changing for the EPD0
case - we also zero the unused TCR/TTB.

> I think it's a pretty weak argument for field vs qwords, but it's a
> good counter-example to my naive approach of per-config masks, so
> thanks.

We could do EPD0 just by editting in place, it would be easy to code,
but the point of this design was to never edit a descriptor in place.

Jason

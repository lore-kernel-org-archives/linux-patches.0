Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2052.outbound.protection.outlook.com [40.107.243.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CE681ACB;
	Fri, 23 Feb 2024 15:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708701531; cv=fail; b=gpi14w74X7kUjhCxS8MQrWNtC4NmTCN+dLAXs/ao6BbnQVJPW/eM3zR6Hr1cuWez6KEm4RPiKUR0gKZFMHhobWlCWq1w+rmDY9AQOB4C1arUwpfdHRKMgK81B8Yh4y/Hpm14svIrNoDOQSzp2ThlENIpHmKK/dvuBE/twSsGPuA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708701531; c=relaxed/simple;
	bh=NICqvNufIfyWLPBqCQUbi7QY2UMVc5pU39VlmB+CtUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JZ+Zfk8mmHv23iJr2oYBVLyjhhBIOuAQf4zJiDbf3G5ERllZ5QLfnCb7d3HHcxfXqi9cT4uqJVaDZqErXzZxhxl2sOBv0xiFbwzeYP+srav6OvhOKm2/X6ZOXR9PVUTZjQLPQkyc5xBgNIqZaxYZXG6BaICdvsdoaptSBJ1wbnc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qr4FNgQc; arc=fail smtp.client-ip=40.107.243.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qr4FNgQc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dmdcDpiJDiJm/+LDMot3fm5pm3y8XuWo6BMkB6GfH6XWTKXYkoLDkf0TDbUoabAgGPUJjzUT+VSNkR+gj3tRx7f2m4cUHMRJL8jiu3uYfohvusBU5JBmxhaxwYvdx3vvFt1Fz5VIuSzE8Ub/wZsRcgq1aT/YL70y7nehVoZiDOygQNF3eYlPiEM5helaKm8tDMvLrPUlUhZ2qMN2iz0VsG4nVaRGkU3rKmdSA2tFb7re+mimsz0AjJqcxxjlv2q/vfOCWplbGNC2fY9LtXi4jbzTekPfu97S34PxBwmDm2Bd/shCd26tfaDtdu6eHb465hDA2DLJs+YtJddRXPo0Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LxPuyslLy1jhQLxFGbIhTaLPMmVN805l6RtApBSGYng=;
 b=GgNrZemtKddA/Xylh8et//7/fhkY9aL4atNb4GRlc9rYZAeA2qO/PS9AeIDrMENmeexwzF8jxIg1T/pHSxYXlbRo+7o2K/s5A9Vj854xiD2phGntGllbFZUAmyyv3cExkCg4WckXJmIa3AaHD4ZIc3eTAQlOkRjNGKFICRlnf6YnyaJ3vhWDmirAaVTSxlODMrfa5ztpIlu6FgnDfG+v0mjfMP6AxPimwz7R/YeoRZuItB0XJcQ6T9BcSWUmX3nfUcrgz7Fls4rb6JsFyDpxhJCxTtz9UmAi7uYePuO2mVg9bCqm9NKF0bAs0VMaKqMJ/u7QMIJwoKebgUu9dc//Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxPuyslLy1jhQLxFGbIhTaLPMmVN805l6RtApBSGYng=;
 b=qr4FNgQc5jm6iVtXMm4XZuCLg36cZlK+gAKIIxysqzgLaDCax0psx7T3skoD2Ksl2a5o7cPL/lwESfKdQD0i4o8MLpvkYHaszqiN+ZgrSaXM1y7h5jxXyD/Xm2dD/JwJ7UjIP6Sh0qo6iQwhUGBBpxB2jEdIboShfua2N6F8QmrnCL6CzoI7hA/IkZjukc/T9jL9+/HjnL0sSXiXycIoX3fr4kqiowsUEHDLf3l0s+2iGwHxRaspxl6c0PczVntdU3Gc36F6Oe4loN3Y/6atN6Mv/J2FC+zS/TIn0v4Ko0Gb3FI3Ydg8ZO3n3xcquwSD/GRjo70pZ9egolZkMb/H5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB6729.namprd12.prod.outlook.com (2603:10b6:303:1ed::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.20; Fri, 23 Feb
 2024 15:18:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.023; Fri, 23 Feb 2024
 15:18:42 +0000
Date: Fri, 23 Feb 2024 11:18:41 -0400
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
Message-ID: <20240223151841.GH13330@nvidia.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <1-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <20240215134952.GA690@willie-the-truck>
 <20240215160135.GL1088888@nvidia.com>
 <20240221134923.GA7362@willie-the-truck>
 <20240221140818.GA2635804@nvidia.com>
 <20240222174346.GB9488@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240222174346.GB9488@willie-the-truck>
X-ClientProxiedBy: BL1PR13CA0209.namprd13.prod.outlook.com
 (2603:10b6:208:2be::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB6729:EE_
X-MS-Office365-Filtering-Correlation-Id: 0881a489-96f6-4641-b8cf-08dc3482b834
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4/yMIcVT5tu4s43lbQbNpkpk95Oh6EYDnRi8ELqflku2h0Fs5FgUmiaGmk1RNb3e1aHPoVZJgvNeSGq5gXQsd/v7QmYm/miWRoS5ZAeyzhhGdFv7uLd4vshQCcQGikBtk0+oGAZU36BfIBVdocEs9QFmEM4XSHfO42yrChe4aW+6tu6nUx8syQdjJEnIiziqrysdFiPA7AQBxJvoLPYtMb6hoCA4eSgSkhtfteDm7bSMvQDFMQpJB8GkUAjwOUk/g7DVt0bQD3Qyri1+M3Msr5ru3I/7nkcLSgJAe6p2hV2VK4Un2X6qFoV6MNJxkvMB1UQidz6lfnEd/pO+fFVR0pIwDiapdQMzlxyOMmuwl7RKel1dI9R+gFjQFeLnVHYVpyN31tK5RVzdudf5a5CC+ozk225eqbb6rCdgWHIAd6lXCIAjFcJpRiHnKFOWbkNPk4P/0eJJHL+hr6mCDNtHIbryqYRh3XB4m+O9md6C9Vx9409F7h44IP2KMwm2i7CFmryXyM2PC5fCxD98uiq0xC++2SMP+9ME//MQG4pwToU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uM9xlD3KX5qnJJKQkMv8ofiYNZdzZOzHm7LmvxVQxXJOIe/1Ln8FRXJnqU5I?=
 =?us-ascii?Q?8bkmZr/3LmV3+Cu5ADahcUakCMGZbElV9tsBnGn6wfaEr8/iIUOjayo7ZAut?=
 =?us-ascii?Q?O60S3BXiP1WIWXxIN8rsH4G1zKSMhWCvtIrttW6tGv/Ye4hRs9fDAl43YIjS?=
 =?us-ascii?Q?dCToGuBfijku4iUvdPBni//dYMOQwyXZdhjbuWDAiMDX1swpBuZr1pFI2CrI?=
 =?us-ascii?Q?jZdnmMfKIOn6UBrtHnvNRzM6Z2ohFRxsCaoUlm9MqPXEilr4rlE43N7dDnUj?=
 =?us-ascii?Q?JkKZClZ9u1CXvdOPBE99ioSdTvqE7j3zDFHDoeWlYaxt4dZMMsnZVcTSnsAN?=
 =?us-ascii?Q?fXg9bDsOxH2hnf6dwJJ3XlfpypqkBq1sTepP+Wfwd791N4bJ7A899Yjn5uY/?=
 =?us-ascii?Q?gKGXUhsdWKz6cdSnGDtnwowsMou7ahjcteEa3XCzaRghUH/IjqehG7mjOZ2F?=
 =?us-ascii?Q?dtOn7yWZbbVhF7aeZz5hBY29vm2+gJpf6CKjHryMb+iWuyTyXFXofeC4K0+a?=
 =?us-ascii?Q?Zk2KkrM1aVkCCXhQcP+zzdG/q064mBM3MwActsZxbLd2/05YUVXbOUhze0Zd?=
 =?us-ascii?Q?G+YG1J/PX1yH5/+j+iTbrywpwK8ciLOwq4q0RSiP+T3L1SFAKkOCEkg/v7vV?=
 =?us-ascii?Q?B7BIJpp1j1fwBg7t5e7+EoFpgqxIAErqy1hV1MxiC8O1wrqn8rYKP9Xr2tgC?=
 =?us-ascii?Q?GaibGqA79wT/Tdt7zYSWOyJhCpSyOHNIYiVSPj/gL6JZyZN3IEbEDCScFYsY?=
 =?us-ascii?Q?89vhdvxaNmG9mehe3A+dJuVxlMgUmYuDTeq/yRyJThoKS1bDsYaUblw7u/aB?=
 =?us-ascii?Q?LIeGoYhmpXf+H5YJzOtZ2ObhYhJq1ACK1j96Sbxt4ToIcEOEKj7s4eWdZPBQ?=
 =?us-ascii?Q?7fACmi/cJ1yLppYlGasUaX182dCpsqT3h0h7Z/szE7gPebKRNWh2qxQWcDzd?=
 =?us-ascii?Q?dGSzoW7d7BlnG9V7l0mUyYZYVv120LAf8wlRXcVChAcJui4AL+go0N6ijKNy?=
 =?us-ascii?Q?TnfQVLu4ijczh/8aJVkJoWc4uM8KZl75P5We18YgQBzANcpdacN5vAoRLFhp?=
 =?us-ascii?Q?/0LYwVC/h+BVaLri/C8AacR3IJZlnFRMZp6EgEgZMXq3aBAhemTjl8QMcqCT?=
 =?us-ascii?Q?ZeFhFlnHuWHx0vWUsIUYcLf9AgL8cwUEpajdRRX79FNgjsYF+TMNl6SN5Yoh?=
 =?us-ascii?Q?rGnYuFc76Y+f1lAtgm83Z6xY02/kxZwADBM/tPckph5Nhv0aT0cLYi1FNH0T?=
 =?us-ascii?Q?BokEabxv5j5siUBjspi8xXWVD4ur2NnnFDB41EU0vovdSxwwHKYA2BzYNJL/?=
 =?us-ascii?Q?uflkfrg3XRMgTSXuetfuf0dErfAkS8uH5u59el+yWo6Xgr5AntNEVohjOHSZ?=
 =?us-ascii?Q?vdnU6ZKx9TJcPMQH/2SKLakE6pCc900SoPjoIHOQ6950ivBXtL+k3Y29sS3p?=
 =?us-ascii?Q?ATGthD/1YeaAOe00Nj9i9T70NOyhyQnR7DX7tLt8Zf1H0qvRoWERnzzut463?=
 =?us-ascii?Q?vgrElo7c+6RCEXUIwAMz/UTULiTyvBhyKQHjXXWo1u19SItcloyFIiW+w/cd?=
 =?us-ascii?Q?uPpJzvlE+dfq6jJeCsh83h7rd3/y743pgxeF/zTD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0881a489-96f6-4641-b8cf-08dc3482b834
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2024 15:18:42.1979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zFUCoRpWZUwrr3/o/I7PZlwUzEGSR5vjJhXMeMYDjGyU1KBVkcniYSxjeK9OCZeS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6729

On Thu, Feb 22, 2024 at 05:43:46PM +0000, Will Deacon wrote:
> On Wed, Feb 21, 2024 at 10:08:18AM -0400, Jason Gunthorpe wrote:
> > On Wed, Feb 21, 2024 at 01:49:23PM +0000, Will Deacon wrote:
> > 
> > > Very roughly, yes, although I'd go further and just return a bitmap of
> > > used qwords instead of tracking these bits. Basically, we could have some
> > > #defines saying which qwords are used by which configs, 
> > 
> > I don't think this will work well for CD's EPD0 case..
> > 
> > static void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
> > {
> > 	used_bits[0] = cpu_to_le64(CTXDESC_CD_0_V);
> > 	if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
> > 		return;
> > 	memset(used_bits, 0xFF, sizeof(struct arm_smmu_cd));
> > 
> > 	/* EPD0 means T0SZ/TG0/IR0/OR0/SH0/TTB0 are IGNORED */
> > 	if (ent[0] & cpu_to_le64(CTXDESC_CD_0_TCR_EPD0)) {
> > 		used_bits[0] &= ~cpu_to_le64(
> > 			CTXDESC_CD_0_TCR_T0SZ | CTXDESC_CD_0_TCR_TG0 |
> > 			CTXDESC_CD_0_TCR_IRGN0 | CTXDESC_CD_0_TCR_ORGN0 |
> > 			CTXDESC_CD_0_TCR_SH0);
> > 		used_bits[1] &= ~cpu_to_le64(CTXDESC_CD_1_TTB0_MASK);
> > 	}
> > }
> 
> Please can you explain more about the issue here? I know what EPDx are,
> but I'm not understanding why they're problematic. This presumably
> involves a hitless transition to/from an aborting CD?

When a process using SVA exits uncleanly the MM is released so the
SMMU HW must stop chasing the page table pointers since all that
memory will be freed.

However, in an unclean exit we can't control the order of shutdown so
something like uacce or RDMA may not have quieted the DMA device yet.

So there is a period during shutdown where the mm has been released
and the device is doing DMA, the desire is that the DMA continue to be
handled as a PRI and the SW will return failure for all PRI requests.

Specifically we do not want to trigger any dmesg log events during
this condition.

Jean-Philippe came up with this solution where we hitlessly use EPD0
in release to allow the mm to release the page table while continuing
to use the PRI flow.

So it is going from a "SVA domain with a page table" to a "SVA domain
without a page table but EPD0 set", hitlessly.


> I'm just trying to avoid introducing dynamic behaviours to the driver
> which aren't actually used, and per-qword tracking feels like an easier
> way to maintain the hitless updates for the cases you care about. It's
> really not about throwing away the entire logic of the design -- as I
> said, I think this is looking pretty good. I'm also absolutely open to
> being convinced that per-field makes more sense and per-qword is terrible,
> so I'd really like to understand the E0PD case more.

It is not more sense/terrible, it is more that we have to make some
trade offs. I outlined what I think would be needed to make per-qw
work in the other email:

 - get_used becomes harder to explain but shorter (we ignore the used
   qw 1 for bypass/abort)
 - arm_smmu_entry_qword_diff becomes a bit simpler, less bitwise logic,
   no unused_update
 - arm_smmu_write_entry() has the same logic but unused_update is
   replaced by target
 - We have to hack something to make SHCFG=1 - change the make
   functions or have arm_smmu_write_ste() force SHCFG=1.
 - We have to write a seperate programming logic for CD -
   always do V=0/1 for normal updates, and a special EPD0 flow.

I think it is worse over all because none of those trade offs really
make the code clearer, and I dislike the idea of open coding
CD. Especially now that we have a test suite that requires the ops
anyhow.

It is a minor decision, trust Michael and I make this choice, we both
agree now and have spent alot of time studying this.

> As an aside: is this per-field/per-qword discussion the only thing holding
> up a v6?

As far as I know, yes. I have not typed in every feedback yet, but I
hope to get that done today. I will try to post it by Monday so we can
see what it looks like with Robin's suggestion but without per-qw.

> With the rest of the feedback addressed and a version of Michael's
> selftest that exercises stage-2 translating domains, I'd like to
> think we could get it queued up soon.

I would really like this, we have so many more patches to work on, you
probably saw the HTTU stuff was re posted again, we have a clean full
BTM enablement now on the list for the first time, nesting patches,
and more. Including this, I'm tracking a work list of about 100-150
patches for SMMUv3 in the next little bit.

This is not unique to SMMUv3, AMD is on part 6 of work for their
driver, and Intel has been pushing ~10-20 patches/cycle pretty
reliably. iommufd has opened the door to actually solving alot of the
stuck problems and everyone is rushing to complete their previously
stalled HW enablement. I have to review and help design all of this
work too! :)

BTW Michael's self test won't be in part 1 because it needs the ops to
be restored in order to work (now done in part 2), and has a few other
more minor dependencies on part 2 and 3.

Thanks,
Jason

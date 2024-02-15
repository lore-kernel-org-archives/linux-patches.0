Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A6913B7A1;
	Thu, 15 Feb 2024 21:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708031866; cv=fail; b=nOpQjVMzuc1LWH7lLlDhPO/+6w41lKFxoQ6uDIR7y023v8sETdDafo40RYC5SYTXK7JNRC/bVnqPP+u0GelXTaobh9iv98lnVOGxHjYkjM4omIhZ1evBYmohY30EmC0mXO5wounmC6rvs5WCicR38rS0JonuyMj35FvUwECnMLU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708031866; c=relaxed/simple;
	bh=FzRE0j8Kh0PFGm4JpJsyX6KmnPeWM1MqmmNdJfJ4tps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DSol4bOHVnp++MvzbrTcgMddMnRv+M5gZ488jwnIM6r2yhyCtPUyYOFFUkbRmE2q3sNieepaJUU4GyPGZkUquHbKKrddwutaT63q2TVAfTPv1Fsb3vQX6d5KX7A8ja08geSyArVc2ZHqGKVgNkfmNsMN9Gpq1XjMXFaObM2adVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=snbomq2N; arc=fail smtp.client-ip=40.107.223.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="snbomq2N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6QnmPza0fKlSPduj59qgkSOeLAZNp6CENDpGG3L6reuodufCxLTL2YsClUoXB/lRBd9cmVwmAN6QaRKjhZXqg3IwYv//H7W3pYt9kQLj0mNRhXYS6qlmQJsMbVou9Dkj+nwDTAZKRP5VuIdr1KMsF2S2QAKmKfC9wrkCL06WzesP9+z4X2UupnsN2tt4Q/FZRn0hyGsFocByWMMWx4Y9W8svdJLE+ZFUuzNCLXMCkCY8P0SWAQDIm8ky/manbKpFGbY9KrXotxbT8ylkdV1/bCmMk5/xpURkBGXl3Vjzp+56E/FuiUJv+04h3ivL/lrCgc6t0265MbObyzip8DoIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=akhRRsYBeh3K07XnVvAb1WF0TiB1bQYM8vEHFb3LNQw=;
 b=imqNzurh9qThIVDBWcH/aHBQ0SANQW1bjFMYuv8VhMmTXkzCKpj+JHMS14IuCG461IAqYaz+XxYFdFHHgS3AXs35KY0MxiP1j6EJ/ISb8ruI31fJ6Q5gibxxh6vD4dbkjsqAjkRzEAdgZEcytIkGsv6rb+JoLx2GSIGk4RNfs5DyEEIoo/ey+yjTox14NKfTv2mg9rajJ38V7Iw08IEWitABmfiNAtpj1MOzZIS7tVeabDUQcIk82tnhC5yZNDW1DhfQhKJTBaQNQN9y/T3UMTObbeo/K0njM5vaUcmvrkfWoBucUXGPt3oZZW8bnjKjH2oc9A2K+OHHlaFkhZghFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akhRRsYBeh3K07XnVvAb1WF0TiB1bQYM8vEHFb3LNQw=;
 b=snbomq2NqoPW4TotodITUJKMfSfEL026BI4g26ZB1tqDBelNJIbt4B7u4u7vA3hsNqEdqt0JcKQB+wSRCPhQvMP/WKZf4pKdO0VSh4HjH8V1zQCmyXy9xB3pIBpJbGQTpRzy1yS/0rzpa1Kd54YP9dKTX0oGyU0MP0hxKfUhoukZcS/5ISj80wtZvs1tw0quGgtOTiVLNTykZS2QP6bJVd6+wZY7GQOzpIkEiH7FbHLsYbxK/N/9SfeXDuqj/SAjk2KXbROlaqgQrgL5b/oA8P5Y+oaiUjW/Nm+eoYKn+Uc7KrYXZB6TLlQapzXjuXzio9r2+PoXK2Xp/Znf7U4/Fw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH3PR12MB9219.namprd12.prod.outlook.com (2603:10b6:610:197::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.27; Thu, 15 Feb
 2024 21:17:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.012; Thu, 15 Feb 2024
 21:17:40 +0000
Date: Thu, 15 Feb 2024 17:17:39 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Will Deacon <will@kernel.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
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
Message-ID: <20240215211739.GN1088888@nvidia.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <1-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <20240215134952.GA690@willie-the-truck>
 <20240215160135.GL1088888@nvidia.com>
 <02fac0ab-07ac-448e-ae4e-26788ed4fce9@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02fac0ab-07ac-448e-ae4e-26788ed4fce9@arm.com>
X-ClientProxiedBy: BL0PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:208:2d::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH3PR12MB9219:EE_
X-MS-Office365-Filtering-Correlation-Id: b85932f3-49a5-43b3-b9b3-08dc2e6b8ab2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qqLVSz1AQIoSe9bSVNZsl5Y4uwb91z1z/0Fsub5vM7J3RLse2cNuLt5O+EDQI/em4S+DM+GtGeLwixwi8DAA7VQZHJAD+fmNSOGyCfsn8DClQK8d8WF/V8Lr5RV54Skw+yDAU6tfklEIcWhPkMK2V0lUZFteVBdj8VLPeD0D+jvbk6Ey+GMz5Lz+Egpp9cyjAqg9L0tJbaP+5dC52oTBNeBlpzUBhvMo0P54Mke4VSgF5uDK3hxUGpLNSUey6GmZhQtTweFL2r32jLHHpzdLLLvVAZRpkHq8Pfi9TA9HE7QOjici1ISqeQkNYhK56+5VDMFczGoB8Gy/c5OS5+krPnuJZzY5+U/USbkUxBBHe/gwpkt9wlknF4MeKIQHEQyWnXprIY3ZICgGxNVnqrVc1GscL1Y7vo5oHQZkr9ka22t+Lip7XaBVaTh9Vr0HtuB1KmsmsA1+KGyLbQ4thRGUDNIHT4G5PlC/jlEtMs2GBb5o0yFCjWC4X+DLirjxZtbyXahwB/t7XdJiwztv2L82EO+iHNnNYs+kY60aKGk2w5BInl7+FlJx+Deyfgf1rrS9
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(376002)(346002)(136003)(366004)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(38100700002)(33656002)(86362001)(66946007)(66556008)(66476007)(36756003)(83380400001)(26005)(2906002)(4326008)(2616005)(8676002)(1076003)(6916009)(8936002)(7416002)(41300700001)(316002)(54906003)(478600001)(5660300002)(6512007)(6486002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vB2I1J7FmaujgHcAzKh2qixUnyU1Lb6TMgaQ7j9PCp6hohItJy9i0aaQ6HXM?=
 =?us-ascii?Q?zT2v3V7Ha3QqiphnIKLJ4ixplVLif1QXEvKSE5xZk6YBy1oBvPYLoqmsCwzu?=
 =?us-ascii?Q?Lqh0JulEdxc1K3v3txqSbzcpBpr9Jhk16TEoj54iK724W/ok/GnID/bN/1Bx?=
 =?us-ascii?Q?Z8G33z3AR0n8ihXejEQ/gO6xyVRufB4dcB0RhPJWGExOHD8jMZz1ZbnBMvDN?=
 =?us-ascii?Q?QaoE3rEHHR8rhRVaGiLl9deQQHsJCYcG7fB6qfmi6oTdZr3q7lojQZDsWnDo?=
 =?us-ascii?Q?DMAXDjHcVN6dYCsO92cKkq+4Dbl2mTpI6sVgZC5LTgHniUQTlfNKuz0OVqZT?=
 =?us-ascii?Q?RcFzswL3PcFmRnmbR+xLwM3Vp4/vS34JF1QUXX/tYyU4KP67j0qdWgDnMzBm?=
 =?us-ascii?Q?WNUTjF7CWdStiFo/p9DOKYnmIhGFrlevtNCOADL79s06jeCf4p5PxjdfOUEK?=
 =?us-ascii?Q?Vo25lYZy3BKZ5PbgGfy0n2j6T+n8bMbbpHZKoUBXe63SbHIpvKY0Mc/qSb/Y?=
 =?us-ascii?Q?UV8uxHppmFQg98MobdjYrWBUlD8KFIJtYf/eoIg7ZfFTg25KVdLiEK7zCL9a?=
 =?us-ascii?Q?rru5DsfP8ol4cIGVQLLaRhhf0iBEaHPBX17CJVQBQmoM6ciI5BA32M3km8yG?=
 =?us-ascii?Q?Vez5hz9yH9Y2mI8YjeXfd9UtRinQn1ssU752Y5F87FW/ZzKI3EkVrn1lzALu?=
 =?us-ascii?Q?zFt6Ubfx1aYSfxyvYyhIRoD2LQzir5PToi7fDUqMwCwNgiQrRKIUkHL4fkQ/?=
 =?us-ascii?Q?m+iN8qaHFzbyo/BGBkc2rvwpPoYoOT9jiIdZ6Vugoa8cKn6yxZK6E+fr3yiu?=
 =?us-ascii?Q?lrviR8SPdKcE422Ycm74xaj7xAEPDxs4P3VhGYQBx8qV9y463Br6hYtyC/l3?=
 =?us-ascii?Q?pGpZygpzsYheV9uj08PPg8fnTPz2nAJNQ6PPegxbL7wK3JGV80m0V8m0at9r?=
 =?us-ascii?Q?kr+jfZzgLqDyoarS579g6n5cAtRujpFAClBtjumEJGFHYEDoR2XUyJ313qB+?=
 =?us-ascii?Q?d+YI6wvmXCQJyce/62NNSy6CysaKhSmP+H14CEo8nvH0j+rnKjDAlT4VSyTT?=
 =?us-ascii?Q?94fBKQTfRooV2eRHm7S64DeWywUr0t0BqSe4Ar67HP0/wdMiODeoJZM+g3XC?=
 =?us-ascii?Q?oPm2TqxDmC/Sn1+Wf+0kUvwrNJ36mdMXCAWkjUU7zPhUdfObOMXEpKWE3ezb?=
 =?us-ascii?Q?6DyOsLW+iTquRhMxugV6fYdlXHXGxPmCQKX9RjFHsGW2cmkJD3EA6ts4t+9l?=
 =?us-ascii?Q?vNyxH5m5IlCNRMnUn4YUZItzOOKbIYrJr4E6kVisI2gzDObYMUAMXuyB+k9y?=
 =?us-ascii?Q?5jUx4N0DXjBnHDzHdyY350emfqPXesAMa9swf8V2JT3WiyI99B0G/twwy7Ip?=
 =?us-ascii?Q?FQtYgbqTl+2GPBjBewgJL+sI3OOZp6Y2R1CszfjqXOq+uJP9TrtoGl6sCaUH?=
 =?us-ascii?Q?4cdbXx+igNGNOC/u98XzAijBaqEWOkQrpqi8Mzh9hfVMeGnQA31oqb4QAwtL?=
 =?us-ascii?Q?2QvopxRgDqOUXsNZ5Xs/dhbkIGC1kMLbRgzNYR/KmxkOuqKfVLzGPJlZ/U/N?=
 =?us-ascii?Q?kOjnS7LCBaoPPz4UdlmXcGtZdpHpWMgWpQ9FRuD0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b85932f3-49a5-43b3-b9b3-08dc2e6b8ab2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 21:17:40.4736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gUF38oVocYE9Qn6EBgOcAS5dR9i69L+dMPoLqikTj6Vdy9A4s2CYTrzHP7dl2iFl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9219

On Thu, Feb 15, 2024 at 06:42:37PM +0000, Robin Murphy wrote:

> > > > @@ -48,6 +48,21 @@ enum arm_smmu_msi_index {
> > > >   	ARM_SMMU_MAX_MSIS,
> > > >   };
> > > > +struct arm_smmu_entry_writer_ops;
> > > > +struct arm_smmu_entry_writer {
> > > > +	const struct arm_smmu_entry_writer_ops *ops;
> > > > +	struct arm_smmu_master *master;
> > > > +};
> > > > +
> > > > +struct arm_smmu_entry_writer_ops {
> > > > +	unsigned int num_entry_qwords;
> > > > +	__le64 v_bit;
> > > > +	void (*get_used)(const __le64 *entry, __le64 *used);
> > > > +	void (*sync)(struct arm_smmu_entry_writer *writer);
> > > > +};
> > > 
> > > Can we avoid the indirection for now, please? I'm sure we'll want it later
> > > when you extend this to CDs, but for the initial support it just makes it
> > > more difficult to follow the flow. Should be a trivial thing to drop, I
> > > hope.
> > 
> > We can.
> 
> Ack, the abstraction is really hard to follow, and much of that
> seems entirely self-inflicted in the amount of recalculating
> information which was in-context in a previous step but then thrown
> away.

I'm not sure I understand this can you be more specific? I don't know
what we are throwing away that you see?

> And as best I can tell I think it will still end up doing more CFGIs
> than needed.

I think we've minimized the number of steps and Michael did check it,
even pushed tests for the popular scenarios into the kunit. He found a
case where it was not optimal and it was improved.

Mostafa asked about extra syncs, and you can read my reply explaining
why. We both agreed the sync's are necessary.

The only extra thing I know of is the zeroing of fields. Perhaps we
don't have to do this, but I think we should. Operating with the STE
in a known state seems like the conservative choice.

Regardless if you have a case in mind where there are extra steps lets
try it in the kunit and check.

This is not a performance path, so I wouldn't invest too much in this
question.

> Keeping a single monolithic check-and-update function will be *so* much
> easier to understand and maintain. 

The ops are used by the kunit test suite and I think the kunit is
valuable.

Further I've been looking at the AMD driver and it has the same
problem to solve for its DTE and can use this same solution.  Intel
also has > 128 bit structures too. I already drafted an exploration of
using this algorithm in AMD.

I see a someday future where we will move this to shared core code. In
which case the driver only provides the used and sync operation which
I think is a low driver burden for solving such a tricky shared
problem. There is some more shared complexity here on x86 which needs
to use 128 bit stores if the CPU supports those instructions.

IOW this approach is nice and valuable outside ARM. I would like to
move in a direction where we simply use this shared code for all
multi-qword HW descriptors. We've certainly invested enough in
building it and none of the three drivers have anything better.

> As far as CDs go, anything we might reasonably want to change in a
> live CD is all in the first word so I don't see any value in

Changing from a S1 -> S1 requires updating two qwords in the CD and
that requires the V=0 flow that the current arm_smmu_write_ctx_desc()
doesn't do. It is not that arm_smmu_write_ctx_desc() needs to be
prettier, it needs more functionality.

> > > > +static void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
> > > >   {
> > > > +	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent[0]));
> > > > +
> > > > +	used_bits[0] = cpu_to_le64(STRTAB_STE_0_V);
> > > > +	if (!(ent[0] & cpu_to_le64(STRTAB_STE_0_V)))
> > > > +		return;
> > > > +
> > > > +	/*
> > > > +	 * See 13.5 Summary of attribute/permission configuration fields for the
> > > > +	 * SHCFG behavior. It is only used for BYPASS, including S1DSS BYPASS,
> > > > +	 * and S2 only.
> > > > +	 */
> > > > +	if (cfg == STRTAB_STE_0_CFG_BYPASS ||
> > > > +	    cfg == STRTAB_STE_0_CFG_S2_TRANS ||
> > > > +	    (cfg == STRTAB_STE_0_CFG_S1_TRANS &&
> > > > +	     FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
> > > > +		     STRTAB_STE_1_S1DSS_BYPASS))
> > > > +		used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
> > > > > > Huh, SHCFG is really getting in the way here, isn't it?
> > 
> > I wouldn't say that.. It is just a complicated bit of the spec. One of
> > the things we recently did was to audit all the cache settings and, at
> > least, we then realized that SHCFG was being subtly used by S2 as
> > well..
> 
> Yeah, that really shouldn't be subtle; incoming attributes are replaced by
> S1 translation, thus they are relevant to not-S1 configs.

That is a really nice way to summarize the spec! But my remark was
more about the code which isn't so obvious what value it intended to
have for SHCFG on the S2 case.

This doesn't really change anthing about this patch, we'd still have
the above hunk to accurately reflect the SHCFG usage, and we'd still
set SHCFG to 0 in S1 cases where it isn't used by HW, just like today.

> I think it's likely to be significantly more straightforward to give up on
> the switch statement and jump straight into the more architectural paradigm
> at this level, e.g.

I've thought about that, I can make effort to do this, the later
nesting change would probably look nicer in this style.

Thanks,
Jason

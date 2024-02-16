Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2088.outbound.protection.outlook.com [40.107.212.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E856132483;
	Fri, 16 Feb 2024 17:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708106308; cv=fail; b=kFcmfR/B7l1HOBepatqg9LO8TPhS6PUq9tf9fwXbJNg+eaPQf+fDKztmtxTPx7RwuHe4z20drvY5TVdoCn0WkJLXO6ADsPgIOosnJSuSEy59mHbmIdD52I1HbTWB9gQzztRl8YW3i68ZNTC3ygpBantjO9sOBJpeqmVI7TuO2SY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708106308; c=relaxed/simple;
	bh=smwVzDV4hXmuMKsKJVVTwABueO6I0w0lywEuiuiwBU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rjBDGXC2DKRn7pYzCethp0EXjMhDfw3j7GyPVZzpb3i/4Nqlh/QqoO5awPmi34ZuHlXf+mUH54p2bSF3eHkOJ0eMD9XoLbVBrTdhBaTRphOq4hog5T6IFggILo6ONLYRpy09Zg/1SfKCcdBYplencLVc8swaI0aC2LCOsS/kljI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mRBhqH8Q; arc=fail smtp.client-ip=40.107.212.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mRBhqH8Q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kuchdWlY5KtiwLv3SAmCUYJi9H/ouqB/nwXgVB0fhFEQhmxq/MUnh2SchUPum/zIff8GFTnqg41Cwjd9BA5UsWRKtiqxF98Sg16kvvQZlSeZVNAoQpzp4gJnS/L20fT/t/xSnQODv8CFP2+apqjO4U39IwygxsOx/5PNyN+64iAZsiMbDzsc4yqrgwR7Gp5VuwkizmkBUD3W+c/jtEIycurWrwaUkNqF4Y3IrdRGHuAUkA6NPkYX1uA7P6I39593OBL6Uw1rNUUROVOqKK/LxqBWepaP7SxOfnjGM6UDtvZSiLsH5m86Cd0oeMjSqW5sP7bPHe1stkItAoZvZY3u8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fIDObRM3gZvCAMDqYyFmxV96UNwWJu/5f+Nyju2LbTY=;
 b=Nz8a7vtX1KU3drB6JdP6taRkPy2Ou+sILmpq/GBSvd/TKYBX+ql259OPkiisoqxyQKAes5uMc+IB3Vr2pawF+ok+OW0cJ1VuV1AsT8KlHPkCLMjQNlyvgDLq0hi3iZZ49//JrvM2nxa38hUo9dMMIRC3fV/R/BvePYVlv/bE8KgO4bfT7hPk4HAlwsbT2qMadSbJIz3RrDCTm+uuBUj/fshquqyD0Vmb9dijFd5FHPFx8O1GUI7kqZhEyHfhWm2dkJ4BZu6R2iwUVKqNhJqbirxVGinRG/W5n4imyObEe7HLy5eTFC4JudTiaQ7aw3+c2cdeHTCIhEAo6bz1l0o9NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fIDObRM3gZvCAMDqYyFmxV96UNwWJu/5f+Nyju2LbTY=;
 b=mRBhqH8Qojp1Wyxx0njO3sbOYilEL/HmBhjVnvH5zA9M0jQU60aEufRyw9BrhHfhSwCa1V5MFi/OZ23RRw388acGL1sf/oa6DTTQTagcV0AikwpH/IKjTTa584KL1dJtXfZcJodypNfTyAXV3AyfoOrJ+XN18EpX///+NIEMkwhu68je/q/9AomckpLPAKvDtemAmqP4llt3RWrBz8DcmziVNdztmvEoIZQSZ1IPwgI6WrsiglQjtt11jT8hV+zXbaE+D2lCSBAi8Hok2HfhzfCO8FMjPfIuPbtPpWdgjy9tq4mxby5Ke1UU9auACKVi2xlVvBn6qkDUJJiuODlhNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4972.namprd12.prod.outlook.com (2603:10b6:610:69::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.12; Fri, 16 Feb
 2024 17:58:22 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.012; Fri, 16 Feb 2024
 17:58:22 +0000
Date: Fri, 16 Feb 2024 13:58:21 -0400
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
Subject: Re: [PATCH v5 04/17] iommu/arm-smmu-v3: Move the STE generation for
 S1 and S2 domains into functions
Message-ID: <20240216175821.GF13330@nvidia.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <4-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <20240216171217.GA102281@nvidia.com>
 <20240216173921.GA2374@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240216173921.GA2374@willie-the-truck>
X-ClientProxiedBy: MN2PR14CA0029.namprd14.prod.outlook.com
 (2603:10b6:208:23e::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4972:EE_
X-MS-Office365-Filtering-Correlation-Id: 3989da20-15d9-48e3-cf66-08dc2f18dd57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	g1nTr8q7fQwcgB4cwW5UEBS/aEF+3+8xy+E2GVKVnxm7m+H16C8S5PmmqF/oJZtSG3pQ84kL0QuqvoBGg9RJ/RrB++wciLepHdu1qBi2HCYzPXWnKwSG0cs/d2gEuEI45zxrAYFnhIwiJhPQB2OkiJ0UmQyx3+nZ/PRTFdl/+Fly5fZkwKYzMlEMu0/gwusQUZ3SNl8elAfpDpqH6jQ4KI3TesQpCnON5NvXohyOlRa8ePdibfNNsie/DcPMod/1sUU4Ap1ERj2fz1/Y2Btg3pgo6mpaTlV3g8+hh9nDpxjKb2ayO9JNOPvZUFJ5DmMEQW4lk9XSUOIdl72Em7njFTTB+sCpmVvFq7Wk75z1XdPV3THAF44qggfC+yCmNU4DOd/QpfNiyvhxpvbLQbmi4XYV/+u1vJS2RCvfRQdxclarCg4vw6oNS9mtSbGKIKA2cr1VQSoQ3TqlkFY/+ejvGfyAwHoutdVwnRPH7Xh9lvQVf1EH2gYr5KeNu6xuXRZA8VweOyuhot80P3tn7WvnrreSO/hJY13H7GaiAtEbK+bYagmO8d1fGlvrcovvEpWG
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(39860400002)(396003)(366004)(376002)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(1076003)(2616005)(41300700001)(26005)(2906002)(4326008)(8676002)(6916009)(7416002)(5660300002)(66476007)(66556008)(66946007)(478600001)(316002)(54906003)(6506007)(6512007)(8936002)(6486002)(38100700002)(33656002)(86362001)(36756003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YgMr86OU2QWVvfQOFRgERvMNXCCT8+LQT5bAI6scXxzsTyK4Z7scLC/nNEcq?=
 =?us-ascii?Q?CS6mDiGKwb4NxobG118m/b3HzPQHB+jGgnE/Z5wn/aKVMXKTd8L41e8W6RSn?=
 =?us-ascii?Q?QfW2a8lV7OcNlah27YMN76Zw75vmGI6a9TFz9Zz0AhRMv6N9S6gQlYWdWggm?=
 =?us-ascii?Q?jyUSZwhKTkO5d+Qj/SkLSby494+daJKeoPFDmKl98YARI7BizMRBpNdoZU3a?=
 =?us-ascii?Q?mVPTEjaGkpQGQ72TTsrq1WNHB5ukDl+Ot9akwrWxrnGVCry94dH5mam/mzEv?=
 =?us-ascii?Q?NVFMyV2i2DMiSvSUhOmZquX3YeEa66aMNa5UzG0/67GAKnwRcEKJg0l+hk00?=
 =?us-ascii?Q?C31sGvmTnFeQzwOrEndRT+CMYJL4bwubnE9iOdPqDojjM/YI5WyG21mgjB8R?=
 =?us-ascii?Q?ZLmS3MvXwxSpxhIcX/Zf2GfT8UkNs+wy2Ae0bDvNqk+bWMPcwEJ/mNtJT0yO?=
 =?us-ascii?Q?R9cHTbiS1ZUim3KvfHeEHPzevWx7II13uaQ1tKKg3UlEO3ZJivAKXMlSwPLG?=
 =?us-ascii?Q?14eCKTinzPFn9O7yq+oiLEvmbb7exsqQbjkLRwIrsjdFDgoaYiTIg2zfC11O?=
 =?us-ascii?Q?cg3rck16qoEYxBcv0UtlTT+LFVPGMBI49WVgpGEbNrARdxqqlpwPictlkiZ2?=
 =?us-ascii?Q?mOFAGXb3e0fCJq7qewEXklPAWlgZQuqm5Hml3146nyPMpiq9ldV89opFEKTN?=
 =?us-ascii?Q?4CQKCaNxxtVkxNkgQJwpFc5+XS6GicWXFEu7nQyRCedAg/+Ff98qW0ZCmTSv?=
 =?us-ascii?Q?KawhsSTgBdbiX8U9q5JVzxaiGcxK7pkRHPIq5VDvUCEm2YzyfUsEUr69zzLl?=
 =?us-ascii?Q?fs3yRTvIQsdSCN7IYj4B6v9vwczZOXwSE8eec7d9hWx2R1TUOWy+H1tqH2dS?=
 =?us-ascii?Q?0nNmPnMyhITn6MAApoeNvmPcMhVARjmYInrvuZHHOrlm6ShRy8jCA5MzzeLm?=
 =?us-ascii?Q?L1R0nSryC+wLpure1HXXPvWYTC1qz8ovDjC9yfZtpzybKvmNt+2gUqSg/Bi8?=
 =?us-ascii?Q?I+1vzRG1amSllPA+zr6VCG8h3nps4wphLMl4mG/M35dmAKCE7enawJATQGkG?=
 =?us-ascii?Q?1aqbXuK1mJYSSL1dLE72SUct1mJRBVCeFl7fYV5vIVEQpDa9uGT6qvcqVPWZ?=
 =?us-ascii?Q?1YzF8+hBB/1recTzPfI7G28rhO4MwWT65juQNR/a0jHDKFdpNWj2kvFwUD94?=
 =?us-ascii?Q?OrgBbiEiWiguVHrsk6yD4KSFkdoHMtCnEeNaBJ1xQ1CldzwejD3yhbw7A+Jx?=
 =?us-ascii?Q?tiDw5ISYL0+aq5OZ7ECMtSHHwFAMmNq7DYpWSrfxh/sj+mhp3iiHGcHXfoz8?=
 =?us-ascii?Q?hokX9vdqWlVsnub8rt41Q6i4og1zZE1rBaAPB1ytwIlmuMZt9PB0Orhd1MFN?=
 =?us-ascii?Q?6XIJOONQn8qQI4zQLKL29y/mMff/DZmSlqFtTjfap6fEFb3rYWU7TtLWgZLc?=
 =?us-ascii?Q?KDkEML9+teat0CvM0UuM9YuZSb7OoQqhkbc2tRh79j7UqDTLfODSfcFHJ60V?=
 =?us-ascii?Q?V0jdfkW6Z1GD01pLZFOqe+EP82UnhIdfhvqcukcso23yWZFOGA1KMKjDnhle?=
 =?us-ascii?Q?7UktNzS/UQQliEGY1/sCDnTrgMHVSi/ohIs+0lO6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3989da20-15d9-48e3-cf66-08dc2f18dd57
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2024 17:58:22.0102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ULBwa5Ny2VBpRhzAmrQBZx6ScTPi+O1ORAomadWXANx/koXXstoT4l9sc4Q2Ydm0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4972

On Fri, Feb 16, 2024 at 05:39:22PM +0000, Will Deacon wrote:
> On Fri, Feb 16, 2024 at 01:12:17PM -0400, Jason Gunthorpe wrote:
> > On Tue, Feb 06, 2024 at 11:12:41AM -0400, Jason Gunthorpe wrote:
> > > +static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
> > > +					struct arm_smmu_master *master,
> > > +					struct arm_smmu_domain *smmu_domain)
> > > +{
> > > +	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
> > > +
> > > +	memset(target, 0, sizeof(*target));
> > > +	target->data[0] = cpu_to_le64(
> > > +		STRTAB_STE_0_V |
> > > +		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS));
> > > +
> > > +	target->data[1] = cpu_to_le64(
> > > +		FIELD_PREP(STRTAB_STE_1_EATS,
> > > +			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0) |
> > > +		FIELD_PREP(STRTAB_STE_1_SHCFG,
> > > +			   STRTAB_STE_1_SHCFG_NON_SHARABLE));
> > 
> > Just so we are on the same page.. The above NON_SHARABLE is a mistake
> > here since v1.
> > 
> > It is hard to follow arm_smmu_write_strtab_ent() so we all missed that
> > the S2 ends up re-using the qword[1] that was installed by the
> > bypass/abort STE that has to be in place prior to installing the S2.
> 
> Ah! I thought you were inheriting the existing behaviour, but yeah,

Yeah, so did I..

> it's a straight-up bug which I think just makes life a little more
> difficult than it needs to be. If we can keep SHCFG as "use
> incoming" in all configurations, then I do think we can move to a
> per-qword rather than a per-field approach, as mentioned in the
> other part of the thread. I'll try to make some time next week to
> play with it.

I'm sure you can make per-qword work. I think it will be worse code
though because doing so will have to compromise some of the
underpinning logical principles:

 - Used bits reflects actual HW behavior and flows from the
   spec's IGNORED/etc language
 - Make STE functions set the bits that the HW uses and no extra bits
 - The make STE functions create a complete STE

I already tried the naive version where none of the above are
compromised and it does not work. Someone else may have an idea. IMHO
this is really not a valuable avenue to use all of our limited time
on.

I'm getting the existings remarks typed in, it is already turning into
some work, but if you feel strongly please come next week with exactly
you will accept and I will ensure whatever it is gets done if you will
commit to merge it. Even if we have to toss out Michael's version too.

I can always bring back this version for some future shared code
thing.

Thanks,
Jason

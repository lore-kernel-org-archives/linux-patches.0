Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2136.outbound.protection.outlook.com [40.107.101.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9108158851;
	Tue,  9 Apr 2024 23:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.136
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712706918; cv=fail; b=likPtUuoDE0t9EixbD1hgH/dvo6DTtIZT2vB4fEN5kZvTL28qQOaP7NuVIeEzB4H/mhPmwyuxmfejJ9AsgjNs6/jpYCrlKVKLGYpaDbBx55R/BtCkg1MBlcQWbzA/7/5y7kvsX/TeiVn5UCJg7s6nPsb9jw+3MyL/xfc2pHFhyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712706918; c=relaxed/simple;
	bh=CzQQUkwKG9Uz8tce+QZcYK1QiXvG+BABYA8yNBTQAo0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TUG/3STSPkcoZtENC78G6a9X/bpnpCGtvpfaRAinid78fH3r3PoILfj0oqfeSlmNK5qKTo49qO7s0x+szhi39R45+5gFbwxs7vCtHYu2GtGG2ougatDia9+q5nSpeSk06kBVb2WXk1aT3VldvC/y9lucLifRT2mWYD9osIQOes8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JWzr/7er; arc=fail smtp.client-ip=40.107.101.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JWzr/7er"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Glt23dBocv6icH21A2abW4wBUMWjwotFpJL00lokCAbkYiSVUuW+9Wqa0Y8SuOryteU2nWsGSgdxuLQdwpdv/tIu33u2iteZpDVwbk6jsDtpTYIVeF4YS1jv0r77OyiReu8G1fZoH1h5a3LA5mcV5uK7tEbHd8UcLMfP1iNnKeUY999UxSqgO2bi1SJFJyWIXP+tLQZNECwEui8TuBoL8TP7mL8VFOoR1LzD1P3GEJZWvzExrDdZA0Njtvwvqih42y+w4QpYLV/X1uLQKVdhS721gWpYS2tIHJUZVz+b/RgAIFe8RkcDx1pWm/YJdc5yXGRNelBLoicYsbaB64XCaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aKB3S7fO9qynBggZ2CqLbdoD1ufspL3iD71dFVHX1ZA=;
 b=O0rx5vbJw86VDKAZ7QSny2uXpybLSE6DVf7M/K7+ieO/CRT4FBVBg4I/mJN4Del6whc3gFCXmL0Q72LMCJwBJriTHY6useFE60OWDYHOjO05M0/Xw5WWcqjsoJeF+nB28wUIVox49bL8mV4miiarkcqg+2c185F8RKi+a6W/kaNg9gx19eaONM6tWkx5u64rUnRpfA2rf5eJYvbZ3QTvx58vwGSQfKES3DDBm7fhPnKcIslEesaJ15WicW0te+2RX3xn9/+77ioekqS4hMNnajRInEj/F5E8ADO26Qo7rHP8TmcG/5byx/VXP+4ulpO73AmThV8yk68cMDe2RDb2iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKB3S7fO9qynBggZ2CqLbdoD1ufspL3iD71dFVHX1ZA=;
 b=JWzr/7ernqRDTCSImUy//cbY0MjN/hKTS2xjJF7oedXEZjN9nL6wFWss2gJeNaJREOfNl3P+tFRjGScKl2JFnPfyJUp+iMgM9usqeuwflt7vJnPSauwBPFATzizYFPrcvHU1OWgdNNNHn+7EIeoFcSF6KIPrWvbo1V6Xz80yNn5b3t5gLYVbClH7EUfM/4rBke2sqPLgqSX70nwuK0AqccjmQ6SsbMMyzAuVrhdzlYrVxpXS6849w0rtu5Ddbt7iU30BJkSIdrR4Oj9n3LK3jk957JDvsBIirLB7Ioe9PM6pgwZp8pI/oSeZ/1iptSATIUG28Ml/zt5IWbdirOXJug==
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SN7PR12MB6768.namprd12.prod.outlook.com (2603:10b6:806:268::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Tue, 9 Apr
 2024 23:55:13 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.053; Tue, 9 Apr 2024
 23:55:13 +0000
Date: Tue, 9 Apr 2024 20:55:12 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>, Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>, Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v6 06/29] iommu/arm-smmu-v3: Add an ops indirection to
 the STE code
Message-ID: <20240409235512.GK5383@nvidia.com>
References: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
 <6-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
 <20240409124007.GA23088@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240409124007.GA23088@willie-the-truck>
X-ClientProxiedBy: MN2PR02CA0036.namprd02.prod.outlook.com
 (2603:10b6:208:fc::49) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SN7PR12MB6768:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iha2ONaMvoRy4+M9ATiHy3fCnBEkqTTTLm5wFl+YWvFqKWsCfMZ9KxBK3dO2Y9aNGnrdj3qdDGLAzkO74qUK7yDHl1P2nhy1wfDHTxMMmd8+U+DrHh7Nw0rTnf/cAsrvH0KuJna2OO8uxyBamAq0jZNjLrvo3LZvuMC3B25/MZq9D91b3hQPkdOEL+Agp35+S/ZltGyic3XPjP9xF4iE1CLU78+R4drYQgA6YvUSskZ7gHFpSOw5SMu5CmMdBrRzhWPgCJUnVuQUoZxt4gwZlfxutjgCA2NxGsvDu2rCRq++n5Noss6DUs2/oZcsxr9lTw/glBo9rck1NDn/jzTQdcfI/cVQWNHPVUoYopVNWB3n453ShzvVejqFUeGBXXVs3Fybrn9/Vk8xdwwJqRxzy/7BsIhLK3INCNwvXw8/prHZj4L6lL8soETuF7mHnnStzgEqw5/Ua7JHilmAFpHtEKPSXohHqSMN4AdKDtbuGjniCNKsc47lliObABZIENhIKfR9RjQoOc3Fn0LOejZfFsUt80SWnevbddNa7pejDuXCw1BmWSCSECx2iGzmEjbIyTA7roXoxJ6DDP5IrBwGozE0Lzb27gm+pfDnrYBfQtP0boPPtQZ1qQjK2hqOpFpWtI+6IcnPMl8u+nKxAknA443V7T5NZK8Cn72FF98EF7s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MDV9lA1CrWcXOuhwbYeRb2SxaDH4SqNmEC1jaMmUI4Is7dIcPAFWk7by1uQj?=
 =?us-ascii?Q?yCYA+Bi6BVnIjJvww/2D+IIBV22pHtn5TC0Op2kM2LFEVb2FrREUzY2SZSjI?=
 =?us-ascii?Q?jHDFp26W3QHyjiNdsQUzJkwLNbGxIH0MLMQudybnc8Sb4bi7PElVi01lKNwm?=
 =?us-ascii?Q?Ezn3ktcj8++jWZq0yqWh8RID8q3r6mNs3F9QzqeiiXZO/TBw02eO+HR4CvQQ?=
 =?us-ascii?Q?gkBYESy/e+Rc5aYPVHPpWYNgSIhRXukoi306Lx7SdMIu4y7POQHjBg807dAK?=
 =?us-ascii?Q?seGpf7erjchmwWF65wXvfr94afpqLVcxbQEn8bGQETgJ9ATkYjYQ5WGNUHX5?=
 =?us-ascii?Q?2p/5CrZdos37mR4BZKliZjhSMhQEYSc6YLWglR7w1Hbtz0zHcf56LVCD5C09?=
 =?us-ascii?Q?lowdDhjfbLIux/xs+DE8ATqq/e8QQ1UFzsnxd/Soemz/EAvj2VGxmoiSAyUC?=
 =?us-ascii?Q?OLNgo4EOGRclWd9Q6bm4XHrSqQ9RcT+cGoOK7lqpjLmVUDkjeO5tVFf236fd?=
 =?us-ascii?Q?oa7qlBBUec+XRRarOS8xMxD70sxT7l+atH6ty5fS0CX4/VBKYom6c3j6wXPJ?=
 =?us-ascii?Q?OW1nEn+hUv+b/QRO1s79RbGLE9x2msZIxCWD9jS7OlRlXJIfU1jXRNFZT8g4?=
 =?us-ascii?Q?UqDSThcydS0HedP5Tha8SyC9XdvJn6QpgCCDC5OJcEjiY1TDcFFL62dVvhqR?=
 =?us-ascii?Q?n777mEFgS5OioJe4CyPPuuhTv3b8my4orKfxICO67OdvSljDUFSLED5aB6ij?=
 =?us-ascii?Q?Ejgt4cUdgnT1FLqnhDxsfyifrxfyDM2l2PDN6K+fPzsq294hB1MsxwaqQKnB?=
 =?us-ascii?Q?qOKfLzEZPQmeDR2gx53THQvTGF7QRkNQROmihtTU6zs2U4vi1K2isT6/zIQ8?=
 =?us-ascii?Q?9zVYJzveIgycCxrtp77tz36T64QWkRGPLYAx8HBpUNI71S9x2fiP+Dvo2nEv?=
 =?us-ascii?Q?zcCQ+LtU7IztFc5IiLB2mV8Empe20E8F7hhA+RxkPwVhAhy0p3rt7PRaqtYm?=
 =?us-ascii?Q?ACMkboA3wP4+HCEyn8tYzi4L/hvWZZxMkOkz4b42HIPjeRNywc+ljMb9zXjb?=
 =?us-ascii?Q?IJwT70X1MsdzzfYZn/89d+eNmkBcJiYRLLglm6/EBvSskfJcj+Rg6sEVxJnF?=
 =?us-ascii?Q?o8X+cuUZ5C2MbzZrnVmC2HBxoqt5XC5rEccrA1IjHRT4K8zwRZvoZ35O/ARt?=
 =?us-ascii?Q?BWVWFLlEUoM+6ejB4stIZ2pjqlvAPzqRS5lGizu3ssIHb/PlF3YPfx+2KUh0?=
 =?us-ascii?Q?6gWLs1EkQeprHvuJHlIemcsDTIGeAhiBCkmmmXFTVXSVqvl7VBRFZRYaWuu1?=
 =?us-ascii?Q?afWqPMHKd1GCM4pHuzwBvJBZtMl1ULZxv237lIECtHFQhWWBdK/S6WHSMMNE?=
 =?us-ascii?Q?vzPmm7E+07DgGy0m5CcfA1/PPKbKt8014bAxguHSwGCZwJe8fxEgChhy89JH?=
 =?us-ascii?Q?x6wJv266XoXNsVM4o1KbabcR1UlsdawjIncOEZ59L5ySyIyJ/+vm7Xo2yZyy?=
 =?us-ascii?Q?M8yY/IqJLD5fIxMKl1Zb/fxC8xGrqOA5yyDphdj5fEpQ+DOewoOej0mQgqZD?=
 =?us-ascii?Q?lkd3vDpTv8qqO57z6tsPxWWoSoiUvLka0dguczvz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f31e57cd-3365-4c60-c661-08dc58f07f67
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2024 23:55:13.4059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IbuGLN4vzm4CkiQgl4/vi14niBne2wp8Q6Cn+MWKS1vwyTenMJYCTmfi6LgNBpig
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6768

On Tue, Apr 09, 2024 at 01:40:08PM +0100, Will Deacon wrote:
> On Wed, Mar 27, 2024 at 03:07:52PM -0300, Jason Gunthorpe wrote:
> > Prepare to put the CD code into the same mechanism. Add an ops indirection
> > around all the STE specific code and make the worker functions independent
> > of the entry content being processed.
> > 
> > get_used and sync ops are provided to hook the correct code.
> > 
> > Signed-off-by: Michael Shavit <mshavit@google.com>
> > Reviewed-by: Michael Shavit <mshavit@google.com>
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 170 ++++++++++++--------
> >  1 file changed, 102 insertions(+), 68 deletions(-)
> 
> Any chance we can pull the STE testing stuff forward from Michael once
> we have the entry writing ops indirection, please? It would be nice to
> land that before adding the CD support, I think.

Yes, I can. There is a bit more work because the CD testing is still
not finished, but I can probably do that.

How about this, I split part 2 into half and the first half ends at
"iommu/arm-smmu-v3: Build the whole CD in arm_smmu_make_s1_cd()" (it
finishes changing the CD programming to look like the STE). I'll pull
forward the selftest patch into that series. That is another 9 patches
from what you have taken so far.

The second half is all about "building a generic pasid layer".

Those 8 patches have all been looked at now, so if we pick them up
soonish we can more easially focus on the latter patches.

Agree?

> >  	used_qword_diff =
> > -		arm_smmu_entry_qword_diff(entry, target, &unused_update);
> > +		arm_smmu_entry_qword_diff(writer, entry, target, unused_update);
> >  	if (hweight8(used_qword_diff) == 1) {
> >  		/*
> >  		 * Only one qword needs its used bits to be changed. This is a
> 
> nit: This comment (lost in the diff context) refers to STEs a couple of
> times. Please update to e.g. "STE/CD".

Ok, I'll check them

Thanks,
Jason

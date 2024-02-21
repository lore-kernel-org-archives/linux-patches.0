Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2085.outbound.protection.outlook.com [40.107.95.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71943CF42;
	Wed, 21 Feb 2024 14:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524504; cv=fail; b=nvAkDPZ7yc86fZCeZF94ek7lstDsNjoTlQXCCVSO9MU0G0O9wE+knsmDnm20/mpTm8HZtWzno0bI2t9ARrL6TC96NyLZIx8dCQUasVNobkp5MSqZU2vz5u/C12fJwSMeIDiX6eHtkrgNaOjd2PfSLxuy3CCyEt6kUn8z5UHv/4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524504; c=relaxed/simple;
	bh=IsV2qS79DFpczNFc5ACA/EsoZ//PSyz8nsrcmAIb2CM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eHsCQlBrNfXn31gZ8/A05nLvdPQ7+vrZC5RHu1s5ZhN8+YlR/u/UXYn86Ob1EUb19y6vW0dKgkxVPLpUigg55HY7H64wGZc7CuJOT2beEQdJ+hY/Ido1uGohqUcj09+6N47Dcw0HZHl60RqHZpls6Kkb8Fjyu563rwG3mu3hJUI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=a/Z980R+; arc=fail smtp.client-ip=40.107.95.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a/Z980R+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I9Z7zedTrUbfu9enjIkTHb5RR+PS+XFjv8H+s2jynS8KXJjKZfmVow6T9/SafXzaaFi1gRxfiXgahuUzbDpSjAUqDkz6r2Hpz2nDuhEGcwA0KJE8t6jhU83u+VvlmzV5WA9UWA3F+AicXBj7/muQd0+DSTt1c/fIuarB4OK1VCmiC834z5e798G3p/T0UTG9yWIWNXgY9yRufa6s2FFMvTssFspL0ajbG5UznJLhBlL2SWdTxOBVGtUCZm8tCe0+A9ruwEzuNTxpRxnUNmtoPzrpIKjtjYADkW1VGhfnhNs0JH2KMnYUU3zqCWgghUoombdc6gf6kUC0abtf5zcD3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+PbyzayFDYlEW6Aa01vcvJZNBltYNN1sQDD7By/LLg=;
 b=LvDqY4gcNwoo2rXQFGd9knco0Dskxm2yLHgBZwSVVYw3G4Jmu11ft+ii0OMpopoO0Ef1uJSOggwJfnTaEo7IestVDkKkLRk24hRzR84xq+JHbcN0XxbWVLc9YQeJ9FsEtKwnGsN4tD7qxHF9jjcok+w9eYRY8ftrhMIPhVUi60WHagxHf6CVyr2d5HipPgycLpkUqfCs447KYd3cR0RqTQ7WFag6MpnI+Zun5qh+3f1ijggvMC77DPoUkJteAhcb/Xvx34cy7paw435KngGS8BrLAtB4xKvLiOpVPDFgQIvWhJ8qbO6epyJbzUoA/kuUSArkorigEVktxW9ca+ZlFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+PbyzayFDYlEW6Aa01vcvJZNBltYNN1sQDD7By/LLg=;
 b=a/Z980R+PK0+k4SrlMd1nbR7gEdGIhTyHrOVFwveHROFZ18/YADwJqpJiNu5dl2XHj0QNqTIrXGMnDMDoPQwxoVWI7lrvDKfhNiaivw4E0DQvERnh/Tf9HJ0ccPaQu+6aJ2qBAdxpIMe3N9lcXldP1q41XgIDXsIRhPZ1pw6ZFyR8KKpzVmqcsn59gl2iru0LR2087VfyRQD9wzCiiRi4WAJhdWHE8ZK3vqT9oOufP54/TRCc3p8pdsWCmPWR0bpvYT4IW3RW5XgISLprJ/KIKrsp6iMnFLmWA3rfpVXd8Vm4Lay8gxvgXRS38wNIIJFuzr1L2YuMiFgUj2LetOXfg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6328.namprd12.prod.outlook.com (2603:10b6:8:a0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.21; Wed, 21 Feb
 2024 14:08:19 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.023; Wed, 21 Feb 2024
 14:08:19 +0000
Date: Wed, 21 Feb 2024 10:08:18 -0400
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
Message-ID: <20240221140818.GA2635804@nvidia.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <1-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <20240215134952.GA690@willie-the-truck>
 <20240215160135.GL1088888@nvidia.com>
 <20240221134923.GA7362@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221134923.GA7362@willie-the-truck>
X-ClientProxiedBy: BLAPR03CA0077.namprd03.prod.outlook.com
 (2603:10b6:208:329::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6328:EE_
X-MS-Office365-Filtering-Correlation-Id: e0d8f92d-33d4-4133-6fa6-08dc32e68e32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Vtku1IyrGrAK0eqpII8FoeNeSTMVrlIXKqLkkIE+8WEQcgiBNjoQhZAKa60f6zCpTJSJ3g8LS6mOwWlfioIrgFf1kTcdrDWuprcq22LTZeXH8xDEReLlGVkdXxbjym6f3L9ry54syrPg6HcHY7/Z/Q7F7npLdy4v5HWueLuT8YFFEk2L9Hnx6ZeTL1uuVpfFH57BVOs4T7vEX1IhZz0xFqnqNnox+6C/XIQ4dfDT719K2Ciw0JTV2Fq4hSLRVTFBXmYvGtd2dg3E0IryyFdOhpIm4CUg/XzwBVAzRnJ3YmmgHY6vgLxZ4wRXTg5uUagDntk2JXPeeokVuEcvNtus9md2fjJO4o6c6F5QNK9Z/0Hz2zSdg7llaDx4GHx3sJbfOkxlUqYeMqy2fcizA6Ojy+FgAzKDlwnPSjHwanWBUF6pjZ9Uu8d2LdSNCt+wJg8X1kB0A9wWoqglMGgkZ7BF6TLTK70ZTqiEDz29pR6cvzNE7P93cqGVmEkYolQxddVn67672Y8gtx2L7b7S9MzY+s0U+tD8dQAlT7Ao2a7y4Tk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8FJKPngCzI1i6xyLUxBvB0el/3PWdG8T1juhAEAqkJi0uFHNQhhRDvxv6a5N?=
 =?us-ascii?Q?zpZ6dV5vnvulD4nt5nrWGtIsdb8m0T+kCkk8Zh+CFoxQVzucI7f7Hrap7SS+?=
 =?us-ascii?Q?L7OhbjiJaUYHeKmVfvt+oIfnxjGOKEfDKho7R9dGpTv8CeHAiA0Wehkoij5t?=
 =?us-ascii?Q?zBludBsIE4Bw/PNe1SgPZtiuGzzSCSS3RGPVw4O1hqD8AHaYo1XyZYmNmEni?=
 =?us-ascii?Q?g1gQTXbnYHBlBuO5+fpFa3n/xbDzQ97R8mdT/Gktd3giCtSrii6/lMSe4XOm?=
 =?us-ascii?Q?oFNSBZN0uatXCZ2ojUTz2p39iQAER8DTL1YutugBHZjvozW3qdAaTzIoCdFE?=
 =?us-ascii?Q?9ms3wQkqiHdQo3LgSsLWP2j9kwU12nN+EsDygQmfu5GluB+hbEdKCAdLhs/5?=
 =?us-ascii?Q?EvMfzj41I6+RCAIzIr4IQcQLqlAeMsU88IOoguRnjxZUUv7AAxEtTllHM49C?=
 =?us-ascii?Q?W9JeBm7NrAQ+5NhWqTiQ47WaN2XUTBwnMM2B990+1K7ZOznCvTq7+E0Sogk/?=
 =?us-ascii?Q?lSesu8oD1fV+ANQumH98k7i8GCemVD8f8Sm/2Z/V5dyef1DAnIESzBvvRWV7?=
 =?us-ascii?Q?9H7Rpn7ECK69zbfuGdMhRtjV8Hy7vBZxYX60q6Q2Yd0Fpd0hRrvMJ00ImJMd?=
 =?us-ascii?Q?ABrk0vAUzlWlPE+nooqida7Jc8uLgtfBuG07avj5SuUJOLWKEFKyMcMRp04a?=
 =?us-ascii?Q?k30OFFT2iDoEDrEzanREpM0oqsvxzP4VVg54xLCR52YFSU+qyk5Yp8nnKD1x?=
 =?us-ascii?Q?7Rykj3mH45QCiBjtf7hwmEA6GOzhoXxCDnMypWgERt8rWmx0UYQsAYTF+TfN?=
 =?us-ascii?Q?29YldXoUh+DhUX18lNv4MDDZvI35/8yceyxB/1Ti/0gVqoO4H04Q4uNfcsZc?=
 =?us-ascii?Q?Rnh+phzpQKakrgrjuTfGPWaE/A5m6HldUmmIoI7OMGOywu1gdVY983drbqF8?=
 =?us-ascii?Q?e61v1htPr9SlOPqkFdFQ4IwrGIL6cqZzk8LvvZ8Oa45IQDq0zh8MUcufSvvf?=
 =?us-ascii?Q?BlRLid0/8VSggUC/idWhKnpAX+8yNUNvlCWdXwqPyJGBcpvoySrXtovqzyBc?=
 =?us-ascii?Q?GHcDZKmAaKgyFjGbOIKgN7iPAyiZzgf2XPP4EplsekleTs+NRTa0QNTgkatV?=
 =?us-ascii?Q?0iJdXCC0PxEE1sm7yxJJMe5pVSsAupxOx/24C0xByoHM3B57m3Y4bP+2yE9E?=
 =?us-ascii?Q?k7YIUIiRNS+Us6Qyio/R0WdlHZadQCl+i+bHG+t9AkCc3uYp+YIifD+e0YCL?=
 =?us-ascii?Q?i3nBTN90rfiCh4qqF3t405SW1caJrwDWa1sU77HaFbwhNCQEASs1TaPYggUQ?=
 =?us-ascii?Q?d804b4BYXk03iUjj4MLxTxc1yoh2hId7vA/AAreTTzHxb6zkjRLfjNG+Of+9?=
 =?us-ascii?Q?obvbgujL8BZRY2BlqlShW2Z2Id0xq7ZyVVzrEhtcdXeLtmm7Lw6fZolFM2zv?=
 =?us-ascii?Q?RvohhrCt7vdq72L8bsvMRr/M1RoPpfk/LSoHdXpEftumVWaOFlqhF0rN29PN?=
 =?us-ascii?Q?gEXox6A31wf+BEN+swaPUGbEbJ/Wyar7EYsuytl5VMLYC0m/XSN1TVRsywPl?=
 =?us-ascii?Q?+M9Ont5totWCc8XW/C2qyZTT1rzvFeT+pvTSslHy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0d8f92d-33d4-4133-6fa6-08dc32e68e32
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2024 14:08:19.0564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vI9C7Y6xq3+DeU78fYUHpWeMUrHS38xJgWcHcKnH3gG65bek5WKnzS3n4cv9Yrud
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6328

On Wed, Feb 21, 2024 at 01:49:23PM +0000, Will Deacon wrote:

> Very roughly, yes, although I'd go further and just return a bitmap of
> used qwords instead of tracking these bits. Basically, we could have some
> #defines saying which qwords are used by which configs, 

I don't think this will work well for CD's EPD0 case..

static void arm_smmu_get_cd_used(const __le64 *ent, __le64 *used_bits)
{
	used_bits[0] = cpu_to_le64(CTXDESC_CD_0_V);
	if (!(ent[0] & cpu_to_le64(CTXDESC_CD_0_V)))
		return;
	memset(used_bits, 0xFF, sizeof(struct arm_smmu_cd));

	/* EPD0 means T0SZ/TG0/IR0/OR0/SH0/TTB0 are IGNORED */
	if (ent[0] & cpu_to_le64(CTXDESC_CD_0_TCR_EPD0)) {
		used_bits[0] &= ~cpu_to_le64(
			CTXDESC_CD_0_TCR_T0SZ | CTXDESC_CD_0_TCR_TG0 |
			CTXDESC_CD_0_TCR_IRGN0 | CTXDESC_CD_0_TCR_ORGN0 |
			CTXDESC_CD_0_TCR_SH0);
		used_bits[1] &= ~cpu_to_le64(CTXDESC_CD_1_TTB0_MASK);
	}
}

> and then we can
> simplify the algorithm while retaining the ability to reject updates
> to qwords which we're not expecting.

It is not much simplification. arm_smmu_entry_qword_diff() gets a bit
shorter (not that it is complex anyhow) and other stuff gets worse.

> > We'd have to really start doing really hacky things like remove the
> > SHCFG as a used field entirely - but I think if you do that you break
> > the entire logic of the design and also go backwards to having
> > programming that only works if STEs are constructed in certain ways.
> 
> I would actually like to remove SHCFG as a used field. If the encoding
> was less whacky (i.e. if 0b00 always meant "use incoming"), then it would
> be easy, but it shouldn't be too hard to work around that.

But why?

You throw away the entire logic of the design, go back to subtly
coupling the two parts, and *for what*? Exactly what are we trying to
achieve in return? You haven't explained why we are still discussing
this afer 7 months. It really isn't worthwhile.

Jason

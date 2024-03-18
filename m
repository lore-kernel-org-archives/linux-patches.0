Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2086.outbound.protection.outlook.com [40.107.96.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE27852F62;
	Mon, 18 Mar 2024 18:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710785196; cv=fail; b=olgZNa/NxvEJkxg7/b5ZQ0n9MTuuoGAM287+v76X3LdxdAp4jOwkBgw6FQWsEu+xiPAuUnHGM6PEibmZJfv65YDtFS4ckw3ldhMskWKagPKsIziDO1fxX8gw+cAR1Uz1JpI6AQpPt5ALBFL3ICUQFhTnA9PrX0VR6jIafvC7C0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710785196; c=relaxed/simple;
	bh=8HauQ+WMQOX9lvv4yl5VVZ/KxDUJlMR8hSTTDrzRxUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PiMKRgmZs83TclzzFC3nnvhju256rxl7HwwDEl9f/rDMVoM8N4rp/A0Gr8brKOiGKFCmgRqDTKnRAhpxB5NSHVJX/lACCDkr+bq7UEzfj9QSMivGN1gLTYFLdc4wuNj7ycedkaRSgm5MHGozrSjLY0VcgINXTQA0aMr+NjwUfAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=H1wwntDJ; arc=fail smtp.client-ip=40.107.96.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="H1wwntDJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lSdtDnMFyHbph54IU2ZDSNIxXmAYKers8hbDdPbDcoF1BSfOKuZBpQEQEd20OhoWfNPy/Jg3Sjl1EhOKoDkS5aJsWYURKSnd5XLNuvHpMPVKcykioxb0zqzL9MXLoD0B/B5GVpcjZwU+1qe1T5tVk/5Af6FLt+1HiZ/M6tCjsWYs7sUsY7JkHwgyUF5QWVoEJizYBfFgV01HFgtdE/DcA3NBJ6aVrWaN0K4OI8k9VzHNwObmC0qLlN0meyyaBwe0SIxo79NxJiTymuyjDs25Dwo4arVfRgFMvzUqOG/z68hrXcvyv9V+0dJhgeHYtyQZ9s/CQoGVzsdsFzFpnGacvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fHmzuDLE6Awzil32x8seGiiyWQ5xC1/BPt88xPZ0Krk=;
 b=oG/NNOh5UBny3SVL78BRbyNTuyB4122VAwnlEd5vu/yRxIUzy1lNCdeaAlkMC01vjUgJlmnzcZ20s8QetYUs8sgqSSW5xsPF+6+GwSZ4NO9zq69fx7QrsamuwOrUH8hBG3lZmvHbTYK3NZXyLvqp0l5asy6pBuWJAayKZ2IifTqgaBKTF9r4oIC+zxmKmwbw7UATuVHnBM4PnveAx6oZzXBxgoy6KJdJfm39g9V5YPj44pUL+zIQhkl9AN4gOsSWUq1azTiC6M50A32gWJhJIzwjZst2pnaad/oKcNKgoC5QyCqcnMDHq9uQaVUYIGG2qOBT8vTFkoonh7Zab9lxZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHmzuDLE6Awzil32x8seGiiyWQ5xC1/BPt88xPZ0Krk=;
 b=H1wwntDJA+Zuxv+mU4SAd8oVNOhyW8Vs/5UCU9P7EIeAXRm03+uHKiMevQ7YgwPwlTuiI1XSAkKSqVL0CZem3ViJhgYjk+4CXJ3BPPGdIR5xUrqGryNPQW87b0BgpxDIMO0rA16y1YZ9Gpa9MVhzel4pCMuwROjWXzzgyy2V5Dt5sIIS9udTkeeY1Qnj12qaZhkrMdsu4h2XGJr62vt0eeDxJSrDHH4byD4JtWYmuCWCKv1nOQOOmu3I8RWmx6zzDY/PxVR9Xst/vawtDcOxq1NXy3AeGn9UzXpzi1qQ6QRjRp6Wbz3VE8M4VU4hMk5Acl9tCm/CZJfNWuUmzMHTrg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27; Mon, 18 Mar
 2024 18:06:29 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7386.025; Mon, 18 Mar 2024
 18:06:29 +0000
Date: Mon, 18 Mar 2024 15:06:27 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: Michael Shavit <mshavit@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 04/27] iommu/arm-smmu-v3: Add an ops indirection to
 the STE code
Message-ID: <20240318180627.GF5825@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <4-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZfPNGPhdhcj6Mq3V@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfPNGPhdhcj6Mq3V@nvidia.com>
X-ClientProxiedBy: SA0PR11CA0109.namprd11.prod.outlook.com
 (2603:10b6:806:d1::24) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH3PR12MB7548:EE_
X-MS-Office365-Filtering-Correlation-Id: 868ab505-2c01-4d3f-e2f0-08dc4776227c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	LOLk/lSKzS7ejDJZriiGncew/cEKm4+BOsqOFKYLhyvBfPF3T0OFv4TyQnXlO58XaADat7yR4dkCFkzwLClaAc0VpfrCBHYj68ydceUoNB2ExZhVGXvPQw/A1H8lIexVpubCkYKOm0ef5NrCTacFmdrIFVKim0oJ8PiLnfQsfaE82oubWHpEO9vjEluxR5DMpWGPXur9Rsjkwxn9ZmpnClOiZb0AvxBgcF0xWlSLBMmQmc1gIUL+g4HdNHcMWkgIHI+pyCfeZOr6NQGJw5eCIAxJTbOqgnZ0wUj8Sa6MBzWJm/PhKQWz0Q+H0p0/TeKwrc8JzKAAgsWB5i58mjrNtJOuws1DANeSneWtgUvALLj0mWB7FG0p6xnU4MN3y9cl0PCeMbgmCbH+Z74jzcuMUBdP9cfaxECZN2CvjoE2qSmwto3ITKQKkL8VquAbtjzlykugHyU8maMSqWLMNaFEmqYJkzgr2ZOkqqMTisoWxjbLMmAEtkqN8xGRLaP0wLsWd3e8exPGSripm2SbzyYLLRhRi5wuBngxhpbHgE6HDOgsywFY3YHHplAycK3Lbv0RWteymephg52bZJRyraJWUiGT7fqmVXOQdWFdhpR2jsHTK6KdG73oJZurTaDux3vo+kGw3w2saRDK9mvcjCCGkuvAuQHJf9oGakYLzUf3dx0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+pkBzJoqjdD/GOtOlf+1NyttDVLEdkVbwRwdtg57YpRVlhgYpLBu1swgjDQH?=
 =?us-ascii?Q?VzYKtoWxebLJpF63UcwQPDXScpal4aG8n25ygmioWYNfxhMEwPFnB1iSfB4i?=
 =?us-ascii?Q?gaVPJGtRA/HNV3S8dv0PCLpXDPh/Gjh6pk2EZ/RGKuc5WAoKG6XPi2ckekAs?=
 =?us-ascii?Q?IDoojl7u8Y1nAj2yBXCWzWTCPRz4YlnVirMUJbU0dIvGT8FslSX0wY9/7FD3?=
 =?us-ascii?Q?2FKN9tq3d6n+PWWRt6RpGSs5LtjRBAkCLFYUvhyYeMZvTPv03/znJJv6TiOg?=
 =?us-ascii?Q?paiso69JaxRPgnZyzMfKhOMmW43TtxcsInvgmo9xl5FRLbQsQhrVpOyTHqaq?=
 =?us-ascii?Q?WU+OCOA8IxU6b9XuJWRnRRWzDzDKU4GIYB8MHwDlriq5gwo8p2QzQ8Z+GudF?=
 =?us-ascii?Q?fBR4aLWDEkGd8rEcZFg8lqo3sGLBvRWzm3bth6kbYSe6hebJoS64owgYINbS?=
 =?us-ascii?Q?oghGYjqKsFzA5jEz6PBIkT+Gss8/041hQZnIqlEyEDv+ZFaS7dn+Ue/gqFGo?=
 =?us-ascii?Q?Lf38onRpwHogDE8Qoy/oIJiQ3r/dt01MdCTqKxI37Czj7N9E4WRsB4CKA2L9?=
 =?us-ascii?Q?QRil+2jHWL4IEQYvExFT5SHOSo+GYbiODuPlp92d0t54bakjRBtFfEUtVosQ?=
 =?us-ascii?Q?zngEmibTPFnXR8OIToAuepmUbaaNcqEF7MwOhATbay0CZOdybclom65Igizn?=
 =?us-ascii?Q?SdlAVW5wksvtsEipbukTdWTieizMs0AlMfebhiNM0tr6DV4HqTDcEqlNcYNJ?=
 =?us-ascii?Q?yR9Zmvj+w6bk1+XCOtwJ7GUHw7md0Zx/mQTOhdR6jb2UZOkPUu47ouWoXpmq?=
 =?us-ascii?Q?Q5H6BSumAIg/IqiYxpkN0nnTY0WqbHbIT4t4FN5kxii3FFffOUA55JHZbxtA?=
 =?us-ascii?Q?PAPjRjU7nCTAiLUxvHj2p1IDI7XfN+H89X0Kyrqwf/SGklY/duD5sw2FuM4S?=
 =?us-ascii?Q?xyYzwpmxXwQMFW+HUqn/E8cRfTS592AM/F1Kk13ZMFDyALsQqNaN5/gBcSYI?=
 =?us-ascii?Q?1uCeV7SDG4oa+iFJr8cTaY60IUo1uhe+2bd8XzmwYvFKYMy3xyt0XFxzYid8?=
 =?us-ascii?Q?1xRMa+254hnIrfJepQpmNY2VrlMannMm4onJlceZ0skzvH/PW7S/0ppPykzn?=
 =?us-ascii?Q?FP5UW10EfyTC5pn6sg8rpXCAI2mYEeRoZ1N4aPmIYpiWqkLsvtGNjOzLDhYz?=
 =?us-ascii?Q?kJXQkUyCeemFvvDMfqJwlortbnvj+4/Rw5FwyoDoi4rBfz8IUIjq4RRz6Doi?=
 =?us-ascii?Q?P/uGKZ8NpdtKq2t9PmPzj2Fl/mp+pMGH2rLh/uBobFw5KlnsqVbe4Kik/rcn?=
 =?us-ascii?Q?lQRmpt+XmOvdl5ha18QutPeNjH99JOuKF7jVsP0aasMS/H9mP5A4G6GqRfqI?=
 =?us-ascii?Q?ItLSZIN+KNGXL/KnQGLtV+7GYDsMlFCsZS1MpghLTq9iYtOfYZwSheaVMAJO?=
 =?us-ascii?Q?attBsrhdCaDLWrO/zMMPPa8oxEVabrYwZgZ92Ga7NB1Bq7Z7sdBzGR0P0I97?=
 =?us-ascii?Q?3XXIoVeYFvgagz6tJN2xMph0uZbNa58qvffO7j051EPnBvf+osm4H5OozA5u?=
 =?us-ascii?Q?ADHsr+h78NxjLSe7D08=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 868ab505-2c01-4d3f-e2f0-08dc4776227c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2024 18:06:29.1420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W4ebe2H+VyzO7+KXB3fDeomxPX/CzO+TTLQt08c0kdquR/ZNDUcxABAlR/Oj19EQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7548

On Thu, Mar 14, 2024 at 09:22:48PM -0700, Nicolin Chen wrote:
> Hi Michael/Jason,
> 
> On Mon, Mar 04, 2024 at 07:43:52PM -0400, Jason Gunthorpe wrote:
> > Prepare to put the CD code into the same mechanism. Add an ops indirection
> > around all the STE specific code and make the worker functions independent
> > of the entry content being processed.
> > 
> > get_used and sync ops are provided to hook the correct code.
> > 
> > Signed-off-by: Michael Shavit <mshavit@google.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 172 ++++++++++++--------
> >  1 file changed, 104 insertions(+), 68 deletions(-)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index c60b067c1f553e..b7f947e36f596f 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -48,8 +48,20 @@ enum arm_smmu_msi_index {
> >  	ARM_SMMU_MAX_MSIS,
> >  };
> >  
> > -static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu,
> > -				      ioasid_t sid);
> > +struct arm_smmu_entry_writer_ops;
> > +struct arm_smmu_entry_writer {
> > +	const struct arm_smmu_entry_writer_ops *ops;
> > +	struct arm_smmu_master *master;
> > +};
> > +
> > +struct arm_smmu_entry_writer_ops {
> > +	unsigned int num_entry_qwords;
> 
> I vaguely remember some related discussion, yet can't find it
> out. So sorry for questioning this, if it's already discussed.
> Aren't CD and STE having the same num_entry_qwords in terms of
> their values? Feels like we can just use NUM_ENTRY_QWORDS?

They do, but the structs should reflect the HW and there is nothing in
the HW description that requires these to be the same.

It is true we go through some contortions to keep the sizes seperate,
and it is also true they are unlikely to ever change size.

> > +#define NUM_ENTRY_QWORDS (sizeof(struct arm_smmu_ste) / sizeof(u64))
 
> And this seems to be just a fixed "8"? Since both are defined
> straightforwardly:

Yes, again it should flow from the struct which should reflect the HW
layout. Making them the same size is a SW desire..

Jason

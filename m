Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B800A78665;
	Tue, 30 Jan 2024 23:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706658980; cv=fail; b=ZbDwC6k24e9JxA+vpCX9ZxYlFYCofQlP6RG5YIkiAQlfZ02NqlXRtdIDZa9uKYiAvOoL+T0HsxcJfZxMDx75I2Gka1HnJFE/R3o2Usvc5YYnPxAD4un67/sijYoKh3FL1j17CD0YdGImq/2I1bxM3hMHVWr+49xGru57oJ5jv3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706658980; c=relaxed/simple;
	bh=lTLZNi/NNXI7A0OAbfr+t0o1EtsO4Nbg/TlVcFO/ztI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gAHijUamVsixNw0+UBIdSD5Fj+FgKD+qz92V02KyYUwrQg17NWuLGDcsWopVXr4OWH7z8BaqpMU80YEI8ny9cX9XunyRxIYldP7OIy3L7E7pRNqiNzE6ORe8vIDbK6RdLk0HvAv8Q6TwbQ7MTkqWRXAnRFv/SZmf6CJ7f19kMw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gStAQUHD; arc=fail smtp.client-ip=40.107.220.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gStAQUHD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XbLbBL2qHLO0wbPjHp6YlfbEfRHI7MU8SROkS5na6FLMgLs9G/Y/eteO7uHDdOfgp33CGBWXfvX1/D5YHRoGB/JS5tGBYSFn/cWkQxaVU6/DBA2wiqbibY0JzY47ZPgyLD/zFDQU9Jqk4gYLNiSTBxQmQ33F0rjohv6YvQevGc2Z8dUKAhR2pbHBIDbpehl6JItlBgVDWZ7HadIpTrVOYf/+AKbr5r8BHhDvwm5shg+6srn8oT3Qa6vun34CdFjwlsUSjejsf3O7iXlRtz0zpIvH7G2amFFLmgKRr1fBdPNds8LomcXLZB1f+X9iGvS6Qs/KHsV27jUIZsaO8RsRsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TluoC0fljKvf9ZPCkx0fX2QmMLgdHXtQf4qwLnxi18o=;
 b=Qffga2FSS0iCwRx4SM9LX5ZXYo1I3GAR18vsATs7peCfW7fWLe78dHeLSbI8ryUM8uwxMQhavJnVfBczekHyOGWe9mePalBuHY4QDJ5w/mgzFkS8llVx1tu0IucN8p2P2RNRltJmrc4QmMQwJUffr8+xE8QZZTE3C9Cewx8Ja7+eQt+OxT9020OgdXmyLfExedvFmQExOCV3lctMsmRGi6M/fvWVSsAHXMoAUBY0Q2XXAnwgxm02ntdKK2rKghF2sXCkjOI/PoSt5ZY2Q/O0lmVD6RkStbzURNaEP3HNIcGUkADDOkB3uSkWegGuzfLDMaxRQvvn+bFHuIa3Asi+XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TluoC0fljKvf9ZPCkx0fX2QmMLgdHXtQf4qwLnxi18o=;
 b=gStAQUHDIEDPiei125gxQY/pjMaKepEzwUEqB7z0HVY+t6aOApVtsF22cnil6Wk8ptdTY8N0KbuaOm+Qoq4O9k6iIJsUf+sMVZlComOLkjQ5t4BB4XoBZ0/kjx9N/MyHsllwx/hO6i9qGOTHDj6536TqUXQk2KZd+rcnQSA+36a70rlB/gSI9/bTpWzsAacChdF6a2lzxoBt8l733CkyAgjjYi3YVuL+qr1GZOttnC8BhXESZEYcfwRGfNRKjdVUyVZbxXpKNxKa5BVRxAVdqL7+U8N7oTuOY0t5W8ePKp1UiGwP6ZzrGVMvqzz8lpNLanZ+Vx+09jN1Rxx4sHxF/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB7384.namprd12.prod.outlook.com (2603:10b6:303:22b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22; Tue, 30 Jan
 2024 23:56:13 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.029; Tue, 30 Jan 2024
 23:56:12 +0000
Date: Tue, 30 Jan 2024 19:56:11 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v4 01/16] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
Message-ID: <20240130235611.GF1455070@nvidia.com>
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <1-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <Zbl7RQwOGPebvv_0@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zbl7RQwOGPebvv_0@google.com>
X-ClientProxiedBy: BL0PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:208:2d::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB7384:EE_
X-MS-Office365-Filtering-Correlation-Id: 2684414d-8a52-4e99-8ec2-08dc21ef09e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4qpQQKMdeHp0m4sfuMeqV9Ewg/G3keqFMnC/WZR+zGXZMHSRDxU8QMzdzXJOqZJKjoqYW/s8eqJ6ye/sJXDPSxgpY61A9ejOuQlnzkTa2ACt5UeNvePU2sMqzaz+0ZmsTNCjmUutJWkyY004XlGjYxY3sPprQ9kRUaliZcX+cY17EynLWHBDRXsV46rtq12B1Qz3Cr5dywhaXF0Od3G8ybW1DJG7KpcN4zvV94GIZrlH1SnNA3tqcduh1Zli7bzIoazgrkL/EUoMF5shkEtgMkju7e/5B/eCOzBTZQFW6olQSxFSTeMNzBnVh5PkDfTxTWF5NXA7kOlGQ1QC896b4FeIbkAPQxmxjj65EKYUqBkAYpTEC6RmjsUIC2V5YnsjjZkGvUZF7NDIsbkvdGuIxMscKeirQLjr/OBe0mXxC1l2upPZjF1Q+PSIR9NCel6b2LrKuY0Abynhph/AmSJeHMuKeuHVdJNuaFQFiTdINmWI9hp6TUT1lQ4LUu2iWakd8t0OptBiPycVrCidXlVMQfMgEnC5ckWaCa785vMBKAoCal8RvPkkUmEE781el7OD
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(136003)(366004)(39860400002)(346002)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(478600001)(6486002)(6506007)(6512007)(6916009)(66899024)(8676002)(4326008)(8936002)(66556008)(66476007)(54906003)(66946007)(316002)(41300700001)(86362001)(83380400001)(36756003)(38100700002)(33656002)(5660300002)(7416002)(2616005)(2906002)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?elBucXVSUlB6RWMrem1PZGYrQS9VNXFNdFNWVW05M3JLazdFN2xJUnBKc3FF?=
 =?utf-8?B?YitKc3o4TnpZdFNpS3JvZ3dNOWxnOG5UMDlJQ3h5dVNXZDV2ZWlIMnlES0xv?=
 =?utf-8?B?czBkWXUvZm9LZCtYZE0xUjNSTFFKMTRpclU4c3gzd3pURXR5aDcySndlNDZz?=
 =?utf-8?B?L213MkVBOGVlWVE4aVpRLzY2NHgvTWtOVnlscGtQVjQ0QlhOMmtWdjJoOFhR?=
 =?utf-8?B?bWZiNHliV3NuVHhFWDk0YmVNcUI4SDhVaUxKSlBTaTFXcUJ2c0pnMWFwMFM0?=
 =?utf-8?B?enhWdmlUcVdNOHVVd3Z2TWJRT1U2bWtqMEdsSXFhSXBNY1A0elF2b296NFBE?=
 =?utf-8?B?TFBNTjIwb0hscTFnc0cxRUdwZzBTdUpUMi9meDdnWVQwUGtIRDVhSUpTYmRi?=
 =?utf-8?B?NU5nZlpGZ2NwZGhQR2c3ZkpxOTNPa1F3QUx6UTRuMlVWMUJ0WXBXUzhsQnN4?=
 =?utf-8?B?T0gzWWp4VGJWc3ltYzNzaTd1TUZ6YnlLbGJaT2ZrUWZMNys5U29OTGJ4WHk2?=
 =?utf-8?B?YlVXT1lkRDdaNjNBeG1rZ1JWNjBEZUpnWk12SHQydStzMVl6aCtXdHVyNU94?=
 =?utf-8?B?TVNPTGJGT2tTOFlhSWMzR1oremlmelhZWWRndnNVZU11TjFwU1owTmtaN05a?=
 =?utf-8?B?UFdXV0prUDMyaDU2a01rZjk0QXRXNzZVanM0bDNldUIyT1lRY3J1NnJwVkho?=
 =?utf-8?B?VkJaWlJjcXlJdWIrWE5mOTZHd25CODZXRXpNdW5MM2NIN0IrbVZBYUNmWmNG?=
 =?utf-8?B?VmdEQTRkUGpRWFlTNmtiWFhOa3VTNDFlNVZYWDRYTkh5VU9UMGNvaUk5LzVx?=
 =?utf-8?B?c25YZXlrTWMzZEhIQ1owZVAxYmVWWnBMTGw5MnpPQ3l1aHd0ZnZ2YTI5SkVx?=
 =?utf-8?B?L0JUZFV0LzR5MU42T3MydDNEOXUxS0tObGt3VDlCNUNneVUyUG54VVlqWVl3?=
 =?utf-8?B?NzNhVlBGeEx0Uy8wUUJVUkUwVXVxZENVNWlPbG8rOXk0TG0yb0pyb0YvTU4z?=
 =?utf-8?B?bHJLVlZ0aElBbGMzd0pKZzZzZno0bVl1blc4bVlqeStocDV5aFJVYUFGdlY4?=
 =?utf-8?B?QVExNnhCcklNNG42MFBFNFk2Q1gzTE9tNkNqc0ZOenRROEJ4bHNjc3V5cGxq?=
 =?utf-8?B?ZkM0dStuTS9zdWVGSjVuNGtGK0dSSy81ZVd5MUkzWUxYVjdMTEhqZ3JydjNP?=
 =?utf-8?B?QTZ4RGd3ckN4TFZHL0dpbFhWS3VsRFlyMEhMTC81azVjSVNwOFJWclhNckh6?=
 =?utf-8?B?YkcwclgveFZqYUJHdWtaUzFYRGRiUDQwendjZzc1UHpaRGNJdEE5dTJjNE1J?=
 =?utf-8?B?OUNjT2J2bXc4UGJxekFGVW0xZENES1JPVWs4TWNpclMrRmtuOWk2WlhKbnVp?=
 =?utf-8?B?ZnkyR1ZFaHc3RVdyL0RPQkpZa2dwUzF0WVd1T2IzbzM1ZDlEQ0tCcWFWeEVy?=
 =?utf-8?B?cnZvbVpzWHpNU01YYWpPTW5LbEpNNUc5bEMyWFpRaDFtWkhRNWwrM3RyQ3dZ?=
 =?utf-8?B?ZVRnZDlMVlVlL09xU0E1UW1KWnEyV0dReEk3VGVrQUdjWHBuZDRhR2F2b3ND?=
 =?utf-8?B?T29STE9hTTlJWVBaRUhiNGcwcWhaZm5Vai9lemxUVEczNm5BL2JNN2hkL3I3?=
 =?utf-8?B?UFJiL2ZHTVNqbnZPSUVPMmgrb1dhSjZjc1E5YUw1djIrWjk0SE5qNk84TTRE?=
 =?utf-8?B?SE45YWJ6bDBvaE8zeXZyRDI4VjBJSWhDb1BLVlRHOVVZam9zZVpxOU1QbWhB?=
 =?utf-8?B?ZFQ1S1h0bXNhWnN1ZEg0akNUQUJLM0RZTmR5ZHRwcGEzYXczTjJaM3dVU2t2?=
 =?utf-8?B?djBMVE1jeldOWWlPMktYbFNlRk5aZDNFYlBkRkx1SWxlSk93V0NZSzUyNE9K?=
 =?utf-8?B?ZHh0a1c5SWZFOXdVSUtRVjdobXZmdU9tZ0o0UHMwWDAxN2dmRTJJVFczSHkx?=
 =?utf-8?B?enliQmdIdmR6dVIzVTgyczJsMlhZVHpNTUxVZlZUM2dpY1NlMEVJeVp3QW5J?=
 =?utf-8?B?MWdWQnpKRWxWdFdINXcySGI5aXpFcVdjZFlmN1VYUjBZVlRTWVVqYms3ZFAw?=
 =?utf-8?B?MENmaVhNY1VrUEFKc001ZWFwSm96QVJHV2dxOExrZ3JZM3NNbk1BUElVcjli?=
 =?utf-8?Q?0kHvKjhXXKOSsfFPSIU2jP1NH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2684414d-8a52-4e99-8ec2-08dc21ef09e7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 23:56:12.8848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BjwZ4/JiGX19WNB3WG01vmlnPAf5RHTlNHcifDBtRlOVIBisZB9udnidYrTpi5+U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7384

On Tue, Jan 30, 2024 at 10:42:13PM +0000, Mostafa Saleh wrote:

> On Thu, Jan 25, 2024 at 07:57:11PM -0400, Jason Gunthorpe wrote:
> > As the comment in arm_smmu_write_strtab_ent() explains, this routine has
> > been limited to only work correctly in certain scenarios that the caller
> > must ensure. Generally the caller must put the STE into ABORT or BYPASS
> > before attempting to program it to something else.
> > 
> > The iommu core APIs would ideally expect the driver to do a hitless change
> > of iommu_domain in a number of cases:
> > 
> >  - RESV_DIRECT support wants IDENTITY -> DMA -> IDENTITY to be hitless
> >    for the RESV ranges
> > 
> >  - PASID upgrade has IDENTIY on the RID with no PASID then a PASID paging
> >    domain installed. The RID should not be impacted
> > 
> >  - PASID downgrade has IDENTIY on the RID and all PASID's removed.
> >    The RID should not be impacted
> > 
> >  - RID does PAGING -> BLOCKING with active PASID, PASID's should not be
> >    impacted
> > 
> >  - NESTING -> NESTING for carrying all the above hitless cases in a VM
> >    into the hypervisor. To comprehensively emulate the HW in a VM we should
> >    assume the VM OS is running logic like this and expecting hitless updates
> >    to be relayed to real HW.
> 
> From my understanding, some of these cases are not implemented (at this point).
> However, from what I see, most of these cases are related to switching from/to
> identity, which the current driver would have to block in between, is my
> understanding correct?

Basically

> As for NESTING -> NESTING,  how is that achieved? (and why?)

Through iommufd and it is necessary to reflect hitless transition from
the VM to the real HW. See VFIO_DEVICE_ATTACH_IOMMUFD_PT

> AFAICT, VFIO will do BLOCKING in between any transition, and that domain
> should never change while the a device is assigned to a VM.

It ultimately calls iommufd_device_replace() which avoids that. Old
vfio type1 users will force a blocking, but type1 will never support
nesting so it isn't relevant.

> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index 0ffb1cf17e0b2e..690742e8f173eb 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -48,6 +48,22 @@ enum arm_smmu_msi_index {
> >  	ARM_SMMU_MAX_MSIS,
> >  };
> >  
> > +struct arm_smmu_entry_writer_ops;
> > +struct arm_smmu_entry_writer {
> > +	const struct arm_smmu_entry_writer_ops *ops;
> > +	struct arm_smmu_master *master;
> 
> I see only master->smmu is used, is there a reason why we have this
> struct instead?

The CD patches in part 2 requires the master because the CD entry
memory is shared across multiple CDs so we iterate the SID list inside
the update. The STE is the opposite, each STE has its own memory so we
iterate the SID list outside the update.

> > +struct arm_smmu_entry_writer_ops {
> > +	unsigned int num_entry_qwords;
> > +	__le64 v_bit;
> > +	void (*get_used)(struct arm_smmu_entry_writer *writer, const __le64 *entry,
> > +			 __le64 *used);
> 
> *writer is not used in this series, I think it would make more sense if
> it's added in the patch that introduce using it.

Ah, I guess, I think it is used in the test bench.
 
> > +	void (*sync)(struct arm_smmu_entry_writer *writer);
> > +};
> > +
> > +#define NUM_ENTRY_QWORDS (sizeof(struct arm_smmu_ste) / sizeof(u64))
> > +
> 
> Isn't that just STRTAB_STE_DWORDS, also it makes more sense to not tie
> this to the struct but with the actual hardware description that would
> never change (but the struct can change)

The struct and the HW description are the same. The struct size cannot
change. Broadly in the series STRTAB_STE_DWORDS is being dis-favoured
for sizeof(struct arm_smmu_ste) now that we have the struct.

After part 3 there are only two references left to that constant, so I
will likely change part 3 to remove it.

> > +/*
> > + * Figure out if we can do a hitless update of entry to become target. Returns a
> > + * bit mask where 1 indicates that qword needs to be set disruptively.
> > + * unused_update is an intermediate value of entry that has unused bits set to
> > + * their new values.
> > + */
> > +static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
> > +				    const __le64 *entry, const __le64 *target,
> > +				    __le64 *unused_update)
> > +{
> > +	__le64 target_used[NUM_ENTRY_QWORDS] = {};
> > +	__le64 cur_used[NUM_ENTRY_QWORDS] = {};
> > +	u8 used_qword_diff = 0;
> > +	unsigned int i;
> > +
> > +	writer->ops->get_used(writer, entry, cur_used);
> > +	writer->ops->get_used(writer, target, target_used);
> > +
> > +	for (i = 0; i != writer->ops->num_entry_qwords; i++) {
> > +		/*
> > +		 * Check that masks are up to date, the make functions are not
> > +		 * allowed to set a bit to 1 if the used function doesn't say it
> > +		 * is used.
> > +		 */
> > +		WARN_ON_ONCE(target[i] & ~target_used[i]);
> > +
> 
> I think this should be a BUG. As we don't know the consequence for such change,
> and this should never happen in a non-development kernel.

Guidance from Linus is to never use BUG, always use WARN_ON and try to
recover. If people are running in a high-sensitivity production
environment they should set the warn on panic feature to ensure any
kernel self-detection of corruption triggers a halt.

> > +/*
> > + * Update the STE/CD to the target configuration. The transition from the
> > + * current entry to the target entry takes place over multiple steps that
> > + * attempts to make the transition hitless if possible. This function takes care
> > + * not to create a situation where the HW can perceive a corrupted entry. HW is
> > + * only required to have a 64 bit atomicity with stores from the CPU, while
> > + * entries are many 64 bit values big.
> > + *
> > + * The difference between the current value and the target value is analyzed to
> > + * determine which of three updates are required - disruptive, hitless or no
> > + * change.
> > + *
> > + * In the most general disruptive case we can make any update in three steps:
> > + *  - Disrupting the entry (V=0)
> > + *  - Fill now unused qwords, execpt qword 0 which contains V
> > + *  - Make qword 0 have the final value and valid (V=1) with a single 64
> > + *    bit store
> > + *
> > + * However this disrupts the HW while it is happening. There are several
> > + * interesting cases where a STE/CD can be updated without disturbing the HW
> > + * because only a small number of bits are changing (S1DSS, CONFIG, etc) or
> > + * because the used bits don't intersect. We can detect this by calculating how
> > + * many 64 bit values need update after adjusting the unused bits and skip the
> > + * V=0 process. This relies on the IGNORED behavior described in the
> > + * specification.
> > + */
> > +static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
> > +				 __le64 *entry, const __le64 *target)
> > +{
> > +	unsigned int num_entry_qwords = writer->ops->num_entry_qwords;
> > +	__le64 unused_update[NUM_ENTRY_QWORDS];
> > +	u8 used_qword_diff;
> > +
> > +	used_qword_diff =
> > +		arm_smmu_entry_qword_diff(writer, entry, target, unused_update);
> > +	if (hweight8(used_qword_diff) > 1) {
> > +		/*
> > +		 * At least two qwords need their inuse bits to be changed. This
> > +		 * requires a breaking update, zero the V bit, write all qwords
> > +		 * but 0, then set qword 0
> > +		 */
> > +		unused_update[0] = entry[0] & (~writer->ops->v_bit);
> > +		entry_set(writer, entry, unused_update, 0, 1);
> > +		entry_set(writer, entry, target, 1, num_entry_qwords - 1);
> > +		entry_set(writer, entry, target, 0, 1);
> > +	} else if (hweight8(used_qword_diff) == 1) {
> > +		/*
> > +		 * Only one qword needs its used bits to be changed. This is a
> > +		 * hitless update, update all bits the current STE is ignoring
> > +		 * to their new values, then update a single "critical qword" to
> > +		 * change the STE and finally 0 out any bits that are now unused
> > +		 * in the target configuration.
> > +		 */
> > +		unsigned int critical_qword_index = ffs(used_qword_diff) - 1;
> > +
> > +		/*
> > +		 * Skip writing unused bits in the critical qword since we'll be
> > +		 * writing it in the next step anyways. This can save a sync
> > +		 * when the only change is in that qword.
> > +		 */
> > +		unused_update[critical_qword_index] =
> > +			entry[critical_qword_index];
> > +		entry_set(writer, entry, unused_update, 0, num_entry_qwords);
> > +		entry_set(writer, entry, target, critical_qword_index, 1);
> > +		entry_set(writer, entry, target, 0, num_entry_qwords);
> 
> The STE is updated in 3 steps.
> 1) Update all bits from target (except the changed qword)
> 2) Update the changed qword
> 3) Remove the bits that are not used by the target STE.
> 
> In most cases we would issue a sync for 1) and 3) although the hardware ignores
> the updates, that seems necessary, am I missing something?

"seems [un]necessary", right?

All syncs are necessary because the way the SMMU HW is permitted to
cache on a qword by qword basis.

Eg with no sync after step 1 the HW cache could have:

  QW0 Not present
  QW1 Step 0 (Current)

And then instantly after step 2 updates DW0, but before it does the
sync, the HW is permited to read. Then it would have:

  QW0 Step 2
  QW1 Step 0 (Current)

Which is illegal. The HW is allowed to observe a mix of Step[n] and
Step[n+1] only. Never a mix of Step[n-1] and Step[n+1].

The sync provides a barrier that prevents this. HW can never observe
the critical qword of step 2 without also observing only new values of
step 1.

The same argument is for step 3 -> next step 1 on a future update.

Regards,
Jason

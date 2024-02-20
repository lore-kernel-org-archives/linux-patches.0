Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2058.outbound.protection.outlook.com [40.107.243.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11ACF185B;
	Tue, 20 Feb 2024 00:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708389334; cv=fail; b=Z528ivafPN6M5dWo+JBJqxDZgp6PkPOoOFevMNIAC7R1owxzPEVu/97+rssNcquaFBU8PKwFSYeLMgKzJ1t+VFv+5oT7EWF6wNb6jae7opZHNjx27rgItoCyQ5D+oy9+iWpo2RlW6Zm4/mprfWkXhy/rD4CKKTBaxa2/4BwGQco=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708389334; c=relaxed/simple;
	bh=4MwEyYW8jeckgoJlgsk3d4IQZBjML3c3yBofmH/10Q4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=q6ni5iM5GBvDrVglJFLO7yfEV3xfKvxoLt4Kw91MH4wBVuuuf7SG2TezIaxhqodibyaU2pvR/ufOB4AZN/Ys1B2Su149dL1RlFp7tuDfO9flPFNwJN/WdjcOxhhuWT/jekJ4XqPqrKSoedFOqH/2F0P21FfoKrKoVK7J9YXgNr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=K53/8CJF; arc=fail smtp.client-ip=40.107.243.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="K53/8CJF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mgxrT1j/iVT5LZ49IIdIz4vGwrpMcs+B1NHqc9BU0Yy6xNlZq/AUVXRufhrXZtUGSvUiELTrD7RBny+4FwhtJz1Q4C2sGinbMoikzgxMUX/4Ks7OE3ivj20yUa3QtgcT//vyw0Sf+d/apsWs+UkSzlFP2Gc/s3ngG44z3SidHbizbmJYX/tntcx6/CKcCoi/6G9IvCxTgbnH9FTGDeGty3foYhAxW7L+ArlsKWvNO51HxdMapVcSoLD7bYD0upS8v7ma52gs3FgCTGsgSIY++dGO/LCeLAEZD5KO+iP8VS19H2aIX+HfDb597PP0ji9k+HvJLIgNkIcU773j3SOQ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zEcwSxwhP8Twh+mBPfWnsnC7/ULR3bv41Bph2AAuzE8=;
 b=maYFxFr30Pf7CDtTOOIs8kKHo4ArjjHruFRuGQRQ89Lw4UIhuBnfT2+zc7SMgor3gabZLnNQxcdJB387KDrVZzQ5h/JxKnfPgx1JHp1k/970+CT6bgWr4jeanDSIavbfTX85Bfdk3RVBam0mTGAzBSnW8nBXPDocBHunIE3yFcoSgba8ZG2ptNQzaKw8xke85/yNIlNxjpp32AqoGrfCXu/C0F+afUmwaeM5RwWf/9iep7zMcgYV+yJQxdrLlOQ1F2OAPSt5TZF0EolqHGw9UcrV/iSXOoGgL4rdu2Ne26oymRCxi6xXQ28+UjIVyCwYmuKhb2ivXGV6Yg3hC4G21w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zEcwSxwhP8Twh+mBPfWnsnC7/ULR3bv41Bph2AAuzE8=;
 b=K53/8CJFy+NwB2QAqDZBlctgczdI5Otg5xq1ePQDES0c82/6ngL/l04VN2KvhlzUdOsGBk1bIyL/PC5Mx2IC9UrQMuO43GPztZUnrnKcxxIInBPC4j9A1OsA11m798cGtC5nPPbB+IGmqxtkQ+Z4mWLPYfeuFx6v8iSuP3D/CSme0NCTApaATu7vGVSc6R6Ldupg/Mx26OHmi3doDzGmAeGL7NIQ2gXxzgTQDQZG8+yTvb43JeQNu3rszM/xmeIaI3fEp6697H9aaElOtTXBRetbycQYbySfOX8cnRWZvft6GABv7RzjuVK9tLPkSXSA3xqeXEIVF8TniYUwAKUZyw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB8599.namprd12.prod.outlook.com (2603:10b6:806:254::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.19; Tue, 20 Feb
 2024 00:35:30 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.018; Tue, 20 Feb 2024
 00:35:29 +0000
Date: Mon, 19 Feb 2024 20:35:28 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Shavit <mshavit@google.com>
Cc: Will Deacon <will@kernel.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH rc v2] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as
 spinlock
Message-ID: <20240220003528.GK13330@nvidia.com>
References: <0-v2-7988c2682634+261-smmu_cd_atomic_jgg@nvidia.com>
 <20240216120512.GA1841@willie-the-truck>
 <20240216123606.GA13330@nvidia.com>
 <CAKHBV27eBnCrnXeaoqONWksh89tfX1b0=yvLfTkxviU_wKG_mw@mail.gmail.com>
 <20240217132446.GJ13330@nvidia.com>
 <CAKHBV26bwkvRAeyNuiUdmh0OWmvLfS7Ja8OHabT-H9nUY=SyNg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKHBV26bwkvRAeyNuiUdmh0OWmvLfS7Ja8OHabT-H9nUY=SyNg@mail.gmail.com>
X-ClientProxiedBy: BL0PR02CA0115.namprd02.prod.outlook.com
 (2603:10b6:208:35::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB8599:EE_
X-MS-Office365-Filtering-Correlation-Id: 17c1099a-890f-4dda-f779-08dc31abd6f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3eV9/vsKwTWdtOGzFvEB+AvoRvhJ45/YbM2cL3SDMjcOU5ht0D06nD+5rVrM8lllj+05s5Z2Cc3y28PQa3xdEUYs/Wu9DWuEcSS/dvBtvGgZ/TS2b9/VVfhDuZZ7123EFmgtx/tA+1od0KzBzczJQ5eUWQujaNY3WSKFVEorxzYyatM/L7GfDiCoOgnFRsK8VtiSAggVLf8g80i3fBbxnZD/RbSe+Z4IA9BNiwFMMBrIGmisGAvd+oCNp4C6oKe1JzUTgly7sIHNiU35R7Ffga7EzbkGbPxN5mMpUUDGmxoFbY9YFS+ErcN/jLHHmBs6QZPI19U2RZSlzivzSsRXGUmLHMFHqs8QFBVK/dIlGADmn9PBWFJ04NakSfIGrurgAyKU+i0E0Dk2DKHzPTPAvmL+t0m08BK+6XpaYGO1YxSNW9TL7DMroF0aQd3GKKZ+MUrxWxdK/B3eOl7o/61wAL9RHKxnjakG4WyxWQsupuosrdnvOHOZyU+EMY8qV+9xf3m6p37WcBxuMVzrlIiQFzFi/ykeSq73+AY5hVcFgwc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UTBrZVFXR0Q3QVBYMkxqSHllN3pRbTdMd3ZPS3BvSG5RR01nRENZZkxHSFd1?=
 =?utf-8?B?TStTQnJEZzF0K3p2SmNFTWJ5NEVKNTVFSTkvQlBIM1dTc3JpQnVKR0pxRUhG?=
 =?utf-8?B?dXpPOXo0L3A1QmR4SXJLb2RVcGpvdWM2Nldtbkl3Qzlld1FYN25mS3pwV2VC?=
 =?utf-8?B?RERKQVJpYXZRc0cycC9RalVoUHdnL3lrQWI1LzVMbXpBN2NWYlZKNXpwTVZ2?=
 =?utf-8?B?YWkxTGcwUHcvZWxwbFdTalBYUWRiWnljS1lRYWUrNkdSQjhlZ29XcFNBSXhI?=
 =?utf-8?B?K2U3bTM0T3hoUHVwaFRyU2Q3dk85SzhyNmJnUzdMOVpIcGpHcXRETHZsYjhT?=
 =?utf-8?B?U2VFUFlVYjc5ajZiVTNvVWx2Zjc4NHhVV01SbFpoOHBMODJwd1g5UDNmb2Fo?=
 =?utf-8?B?U2JHcGFKYjFzNEJ2ZHhXRDRGTFdiRXJlUm9qMGN2KzRHSnRjVnFEVFQ0bUV0?=
 =?utf-8?B?S0hqQy9qVUtPNWUwOVI4NmRYUWVRZTF5NllFdmQ5elVTNHpJSTJLZnd5Q2hv?=
 =?utf-8?B?TmtKdU5DYVd3cjZlWDFadUtiZmZsdTVaUU8yVG1KL0NyL2pEYURQeXdVaWdV?=
 =?utf-8?B?MG9kMlcvdXhjS09NY2IxQ0RuUUQ1MXl5L2hSa3ZubVU4T293Z1BSMzJFYjd6?=
 =?utf-8?B?UDVLNDVuS3czbUZyWVhJYkhUcUZuSkRaUWVmSDBlUkljN0tOMFowUGJ2TGxC?=
 =?utf-8?B?UXJ5bW0ybXpOYVE1OERRbXNWWm5HZnBPaFgwdXB2eTdsVDRsWm5aZGlOOUls?=
 =?utf-8?B?NDRFQ05MeHQzdDZaR0lTRW1jOWtqV0tDOVRqc3IwdlB5NDNYNzBOeHVOSEVn?=
 =?utf-8?B?N3lNYnFOWktiUDVGdGVZcTd4bFJsazhOTzVDQ2ZiZGV2ak5SN2JMWUdqYmlv?=
 =?utf-8?B?L3NiaVVQMlVyc1hDQXpHbnR0MzJSYTl1dyt4SUFaZUpLYTVibkdCS016THVP?=
 =?utf-8?B?cUVJdzd3clYzM0hQVkh2bmUzQm5HS04xWWtzMjd2b2JCVEc0b3hqbWNOclJX?=
 =?utf-8?B?QXR6NmJMUTczU2NrbGFsampOYS9lV3N0QnN2d0JtZHpaMXovekRydFAvQ0c0?=
 =?utf-8?B?enZzWUI2MGk4bWdLSkNQTG0yM1g2TGwxdjM5ZGpFNHBaZkZGWnM1cGNnSlRp?=
 =?utf-8?B?NnV6Z0lXcWRDRVFNQWw1cUVJZVdTSlhDRE9oNXVNdDFESnhQaGpVUlJWY3Nw?=
 =?utf-8?B?MXlYZVoyZWdyMDhJenNVbllvRFdTUGFSTUh4NlROTGJSelZYMU5pN0FxbVN6?=
 =?utf-8?B?NnI4WXA0ZllwSnJuZ2J1UFFUcWkzbzhBWGFIMndKM3JMMkRNL2xqb2s0Z1RD?=
 =?utf-8?B?dXp2UXdZbzZtVnVqVVU3Q0V1V2dtWXZaZWF0VVZtdFhJYmY1ZGN4WlhoL3A4?=
 =?utf-8?B?QjBwdExhM3k2bUFzS1Bkb3lMSHBqMmFZUCtHZVk2eVRBQ1pHZ3ludytOa3lz?=
 =?utf-8?B?MGFyMkU4NU5LY2o4MUFtTng1RmZhVzg1WEVyL3RUKzFaMTA3ZlIrTzJUYUYw?=
 =?utf-8?B?YVdPczhEeWNnaDdMZThXK3lLQTdsMWtmd2hZU01MUVB5WnlxS1d4aHVFK3Ex?=
 =?utf-8?B?WW9waCt4b0FNVDZ0eTM2cStjbEwxYUpjSHVGUlpBY2E1K01wVmUyaWdUbGRW?=
 =?utf-8?B?Mlo2TlFCVWxRT3hwYjAxR291djFDTVpFOGtjcVA5OHJzalZWSmU0bFJ0QTE3?=
 =?utf-8?B?ci9lcWVZdHp6dHFrWi8vcEx6dnlBZzlpL1pXV0c2bHc3UEJIYUZPdGxlWitQ?=
 =?utf-8?B?U0d0ZnhuSktjZ3hUV1BPamNhc0tWanB4cXRJM3lGaURNQTRwdG5tTFJKcUtC?=
 =?utf-8?B?Y2prYlR4RlBoK1poUEdaT1NDRVkrZDdQS3UyY3hyU045OEhJeTZIaEQ5VUo2?=
 =?utf-8?B?WGFkcDZWS3JuMU4wUmZvOUQreW45Y3J3b1BPSFg4YVVMZmZHQkxQcmlSRG92?=
 =?utf-8?B?ejRGaDRILzVRazFFR0k2cldwZFRzQ0dyUkx4UCtnUEYwN29pOUZEdmlvdEVY?=
 =?utf-8?B?S05nSFMrRFFsZ2lZOU4wci9vbDY3K2NTcHhEUFhzM1pLRjA4V2NJeTNpK2dU?=
 =?utf-8?B?amtjL3Fjc005cm1zZURpSmFVaFF1blZFSnJjRWtNd01MeHVuMTNJcXN5K1Nh?=
 =?utf-8?Q?vlzE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17c1099a-890f-4dda-f779-08dc31abd6f9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 00:35:29.6943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QqMtqN/e6bDWN0PiwJfLi/+ZGt21CO/DulbhL7gtyz9yZ6Cbpr0iHKidcPgGbBxW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8599

On Mon, Feb 19, 2024 at 04:32:40PM +0800, Michael Shavit wrote:
> On Sat, Feb 17, 2024 at 9:24 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Sat, Feb 17, 2024 at 08:25:36PM +0800, Michael Shavit wrote:
> >
> > > Calling arm_smmu_write_ctx_desc requires the CD which we get from the
> > > mmu_notifiers list...which makes it a bit more complicated than
> > > that.
> >
> > @@ -404,9 +384,15 @@ static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm)
> >                 goto err_free_bond;
> >         }
> >
> > +       ret = arm_smmu_write_ctx_desc(master, pasid, bond->smmu_mn->cd);
> > +       if (ret)
> > +               goto err_put_notifier;
> > +
> >
> Oh hey that's not much more complicated :) . I'm guessing that'll be a
> call to arm_smmu_mmu_notifier_put() rather than a goto on the error
> path?

Yes, error unwind is the goto which does put and kfree(bond)

> Speaking of... the arm_smmu_update_ctx_desc_devices call in
> arm_smmu_mmu_notifier_put might be tricky as well if it's encountered
> on the error path before all devices (in theoretical non-pci case) had
> a chance to previously call arm_smmu_write_ctx_desc.

It is hard to understand but I think it is close enough to OK..

The put will pair with the get and if this is the first member of the
group then it will do a symmetric tear down. The 

	if (!refcount_dec_and_test(&smmu_mn->refs))
		return;

Takes care of that

Otherwise the puts accumulate the refcount back down to zero which
should be hit once __iommu_remove_group_pasid() gets all the group
members removed.

IOW the CDs are not cleaned up on any devices until all the group
members have the PASID removed. Clearly it is not correct design, but
it looks like it works good enough even in error paths.

Then when it does eventually reach arm_smmu_update_ctx_desc_devices()
it wipes all the CDs of all the RID domain's masters which is the same
as the group membership.

Which will end up happening before iommu_attach_device_pasid() returns
on its error path.

(obviously this is all made to work logically and properly in part 2)

Jasson

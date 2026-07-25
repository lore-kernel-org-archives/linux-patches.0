Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010059.outbound.protection.outlook.com [52.101.193.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67282771E;
	Sat, 25 Jul 2026 00:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784940160; cv=fail; b=fBfR8Gvo3S3KpBKc9n8zRpfHdRPB6fc1PDoGGt+gL3ICLg7JxtwGRcUvZloi9Jow8XyziOyYk19N21ynCKEj+jxJw1MK/GNCIgwiGXAtdF8Xl6Hoio2uZJWbTQm4UBAOvqRdbOify6wE/MPckhEFvuI8+VNQg3IXTKXkp9+pJw4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784940160; c=relaxed/simple;
	bh=yqsm62rpXOUHbrlX5p+2yT1Tmtm3b7UFBa4kJckyhEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uMK1uR6JShiDrezIfH1rY2DpJJUmdExQVfxFYAQFcW9qsRaD7e5EO+yriAQdsKBF1LN69JOtNQjHxArERdXZ8VnOT9HjMkq2RCCXH4i8NeDyvoSZR81cdJS9OX/rTEws07GgoTKD5+6r8QuV+4vfLC2qY1UpAdF2EZzATW94RR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=V2LphTUA; arc=fail smtp.client-ip=52.101.193.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="V2LphTUA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qreJF7l2/6c6vhd+baFD8AD36E3b/mPJlzR5PazUnzUwwixRliza6JEsrcNZxAsx0YxhXDUJo5WcabdPTyx6ZhIr05Cd5iURoAWh+kmd9WTHCHWNuGyO3XrZPm9Ojp7m2esM+CSejGTNUo31SB7Nw6hMtdoFXp9+t12QEUhto4r6M+HHmOLk/O5+oUPyQwaYvYYpolJH/cTUQCrt6Fe8nj0+3ix/jKquR7Ol8oa17XvALcJRu/AQeoZllOdfPCv3NgSpebbCZ0tAF7q7PUSEug2T2OLP+Fkb57rj7TC5QQpQYXCx9sWEdlhspG0w5M3RWbK2+9g0/LKX6NCI8SqdrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4WpI0fyC0SK+83Q5UovnfEWWtCRjHvLmfmVowoRyu9E=;
 b=L6l2I574B92uvCc3Nb8f6yiGQpeYNxr2FznXFyyPLKYFNQUQWsU0CWDz7CxOi2vsnxX0LONsus3A72PYxYvUj+FMttw8Jud/hWgLVwNYkLWuHusQ/Muf2wzbx/aeny5tHuTVnV0bFmpdbo+hsy7+127fow/MH4KERpxQIZfkp1ppzBmrC5awv7PYajfEFijWbQHXA6fBYOUSRwj/PW5uPBOLH1VlRO38MwBb86B4aC6R84nWCnXm4J0DEfs5RhflKluFl96/jYi9vkP/EV/jDZTRa9LLEICv0q37KOQYyEZhw8GsfIJlfHE8PX/g95Wap/rTcGRS7x/XhaWdYMSn5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4WpI0fyC0SK+83Q5UovnfEWWtCRjHvLmfmVowoRyu9E=;
 b=V2LphTUAFO9kC++JVKPYj/+WFekCz3WlrzR9zcCBre/OubmvaOo6HYvK+BkEnarML8L5GMiCktvUBSjbXtefULevs/oP1Z9gi/pDug9w6Cg2gC+2Imyk2/DhEyueNZT0zIN7WBreVV/HHBs5dJOa/MVyK6MHit+y95MV5jwJcJYkMJgUsDNA1E2GIvaDpQz0bkXtXyOUn0qERr4oINBaOmwfDVkR8jlpGTnmnzvhghHm8EBldmIpQMNamGJBMcsAej1sX0nl6GU9sk4qRT/uSbCX8uq8aYUQUwB5qth0Qv92F1RRSBgKnGS3jNHYRw78v0jzAWAmGXjm+1oPAAWnqQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by BL3PR12MB6402.namprd12.prod.outlook.com (2603:10b6:208:3b2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Sat, 25 Jul
 2026 00:42:34 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0245.010; Sat, 25 Jul 2026
 00:42:34 +0000
Date: Fri, 24 Jul 2026 21:42:32 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH 0/7] Use the generic iommu page table for SMMUv3
Message-ID: <amQGeHirwgEEJVkf@nvidia.com>
References: <0-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
 <amO-sGlWsmtcPsDZ@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amO-sGlWsmtcPsDZ@google.com>
X-ClientProxiedBy: SJ0PR05CA0207.namprd05.prod.outlook.com
 (2603:10b6:a03:330::32) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|BL3PR12MB6402:EE_
X-MS-Office365-Filtering-Correlation-Id: afe68d33-5dbb-4a51-8d15-08dee9e59dfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|56012099006|4143699003|10067099003|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	hKod9O3Nifz3BOnCEICCb06PY/3UokQIxmIDRtvoOPWBFfaHVonfi19XVPZdKak+zg9R+OYmloSvccBgKXJb9f+jsdbYuAMi4B81I92Bzrd7Gyokwm2tK4iXjLf1FXnotl3CV4551T3zLASycH+ybN7RV5OYvql+Rq5mvBUOxM12Hv3dEkHpySor1vWFlNFspctkb8HR53DYx3cyUFiHAqx3errt7Eb62Mo5p1L9o4VL9ofghcr/rkfbe2BQfjfIqo00R7LcW8SSnJ0wXWtSEJUFshTopIiZJgPyZwFpL3iXezjW3lGRbhT7k06l335Sg9EGfR90uizx4LwxV4XNGx6B4wQL/4WfwPhh2bWDxOt2F4fKezMTztxKd5LWZi6Z7hP9PPe8T5/pY3cbFVNIajtGrrQgvb+krxFhvp9hs+2YWlx3zv1KaDn0/tzLJWiiJewqztAYg1hmsU8+zqbNYRSkhKR8KgnfoNw3EOYUxqDQw2egvEyyYPKQL0H7AAI96A+wq4bMATdo6MfZin4/BHvQOKcwCaTldwYCB8IBeaz4W8RAuN80OAjzVrtdiG6JmT1XgAhHsv2ElmdYcNDXmqWnD83xQMvzTPKjSV2XNJUEACljfSfF8qiDJGgfVhNebNKGNPIHBZPcCBDwwB4BsGU3+tuWvVJSWTrNrmLrJ/I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(56012099006)(4143699003)(10067099003)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pv/QqZM6xjD23Pt7uG99v6NH+bON3Ge47fYBnDsGY1Pd+ZGQ+WQhL7WUaByW?=
 =?us-ascii?Q?7Y7r0jLcZTpdqbTfg3503DNnvrD8oHwCXIGCxFqRO9W+ITT+eVE4f/AifgcT?=
 =?us-ascii?Q?pjDbEpBQ4W2GAXi3ixB5VWtm+hGwrJthGelmVahuPEQq4s284k4ukP4kfESM?=
 =?us-ascii?Q?A8zzu3lgLuECMpZo52zqZDq7I12Z4i2CE51ct6J7JvOH+N0jCEeGr4zhYtjz?=
 =?us-ascii?Q?oxdM7Z0iSwXYEaMd88V8OLj8WgfHC2al+TmCxY2+eiShKcy+mKcxQqdGIKZe?=
 =?us-ascii?Q?EQ8jjH68y8CU3a4mMAO+LGcJuMhuLXWh/BHy6+mTgbQO86a/qXXs4lvoWSt5?=
 =?us-ascii?Q?3fCv2hSHfT6JPBPpiu0bltaJugwEEsoAq0XzH+0P9YpoaW2m179Lw3OJbYht?=
 =?us-ascii?Q?q1VLePVfH5XMs01iPHmmdVI852+wMeTJ/jFeHM+nxgVemQqSAZbSKZ8/LA5n?=
 =?us-ascii?Q?pKLcv/Yh4iFeyaOCZt4KhO7UMRXei7bpvGj6s/ne4sEZC5NVhWh0pdFIOsR6?=
 =?us-ascii?Q?5uikiG71d8mfrYP7STQLZ1Gs8RGD8uzJwCZEbCkiccE7g8TmLZJOqgo3BZ3m?=
 =?us-ascii?Q?ACFuN9WrUjPG1muCtwRiS410YAoksPN456Cs3E006lXqxsI/a/L3Cd0ey8wv?=
 =?us-ascii?Q?feL6+Nj8TB2X3cW/AUMZ42rfjAfyY/TP+qLdlO7oixaYCa2Muuj9yNpcj3IE?=
 =?us-ascii?Q?9pAeiU/K6fnNh5r07ELob3q6DVTLNv1Ig10gzHpPkb9ghw7JSfRtR2QMgC2r?=
 =?us-ascii?Q?4EQ/2zqrdPlSlGL3/BoFSg6tMCmajrNP1DE+Y1Oj/TuB4AsYtKJEDduFe8Z9?=
 =?us-ascii?Q?R4zlt5a5nU6nSBh3T7L7+vJ+zy6cMBQ7BuuoMozysavpYaVjN1YmjmPJ4Enk?=
 =?us-ascii?Q?Dv3DwjqLCZfVAwY2rozUyGmMmlluIXsGY7F2/DaFQoUWzi7TFxVe3kYaadle?=
 =?us-ascii?Q?nDge/cV1bMw6jKYSIXIKSClW/d3v4BrZv5vFKRL5IhHxmQ17Sbf+IuluSehr?=
 =?us-ascii?Q?349yn424y/lRq1iliMRCK/syKaEaT3NzPInI0dgLx+L11g1Si5ImkAMfGX/4?=
 =?us-ascii?Q?rXRfcs1azvxjviK0lqgC4VkQsg/XTnFjpdi5N7Dn9579Y+Cx4XZqQUpetvHI?=
 =?us-ascii?Q?w1vrewvrLCeYrSvmMvAcrzLFghE7uyalQRoA/DW7PL/2fkTjIEJNB81ZVYCD?=
 =?us-ascii?Q?453YfXtbkU36vTPV5RU30MTsQTh5Ap6qoG2TjZA5z3gR8vLfpNFaWnPifOWT?=
 =?us-ascii?Q?0wVNbZTWzA405X8EUD3Iqj2D94p7g3hVlb3yjPpJ8ZntACKuAKETNBIioG93?=
 =?us-ascii?Q?CXGyXAVt8MHHpxb1PeaLqlBsOksfqawTwgU9rFPKJuOKasKJ/2ELbfY2oFb3?=
 =?us-ascii?Q?LvQ6VmOmAj5WhR43qb9sI/JAkZGqZhVPzhDwyEUOB1AilPgSmLOltaezJDu+?=
 =?us-ascii?Q?voeCxx5i+8yQfD0rjYFVuX95lPsDa72zvyxsnz99Urd+o+3N2dU0UgbQXAgk?=
 =?us-ascii?Q?bY6pXlR8yxqnz6LvHQOUnr1mCiUbSo4dW+neF1IG/DlX9piLtbuOyqMQ2eHA?=
 =?us-ascii?Q?LwlFpvddT6HFK2PVmfqKG7CSQEaFiwTiELek1PdBMIUHu6Ji6va5LE9HD3Md?=
 =?us-ascii?Q?C6emvmyc8UmiXeM3F0nDy1NYM61i9XmrTM4rMuTGaInthoTmNxBtLrPMYZo0?=
 =?us-ascii?Q?x/VxJFWN5IuOEUU/h5YOiUeNVtv/rR4EdvkuJ6F1wYAMJnPqwCKbnWuXJuPP?=
 =?us-ascii?Q?GlNrpsJUyw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afe68d33-5dbb-4a51-8d15-08dee9e59dfa
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2026 00:42:34.1961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nI1ybDEvBt4eu0cTFkI/XucOCrTe786ffpUZjVuedmUWgfzqSevftWl0ddvqeu6t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6402

On Fri, Jul 24, 2026 at 07:36:16PM +0000, Mostafa Saleh wrote:
> On Mon, Jul 06, 2026 at 01:29:06PM -0300, Jason Gunthorpe wrote:
> > [ This is the last patch to move SMMUv3 over to the generic page
> >   table:
> > 1) Organize the SMMUv3 invalidation flow so iommupt can use it
> >   ..
> > 2) Use the generic iommu page table for SMMUv3
> > 
> > It depends on #1
> > 
> > The whole branch is here:
> >    https://github.com/jgunthorpe/linux/commits/iommu_pt_arm64/
> > ]
> > 
> > Introduce the generic page table for what the ARM spec calls VMSAv8-64
> > (ie the long 64 bit PTE page table, io-pgtable-arm.c) and use it for
> > SMMUv3. ARM is by far the most complex page table of all the ones
> > implemented, it has the most runtime behavior variations and a lot of
> > features.
> > 
> > Like the othe architectures, the page table itself is supported by a kunit
> > compare test that runs operations through both io-pgtable-arm.c and the
> > new code then checks for identical PTEs. This is on the github link above
> > but I don't intend to merge it.
> > 
> > The existing kunit tests for iommupt will automatically cover the new
> > format as well.
> > 
> > This is the final series migrating the SMMUv3 driver over to use the new
> > functions and remove io-pgtable-arm.c usage. In principle the other iommu
> > drivers that use io-pgtable-arm could be converted someday as well.
> > 
> > Robin once mentioned there were errata about contiguous bits, I only found
> > 3673557 and it is mitigated in this design by always using RIL. I'm
> > assuming that RIL is always available in SMMUs that are effected by
> > 3673557? I have a patch add a FEAT if for contiguous bits if that is
> > required.
> > 
> > Jason Gunthorpe (7):
> >   iommupt: Remove the sanity check for pt_num_items_lg2() at the top
> >     level
> >   iommupt/kunit: Skip test configs without supported features
> >   iommupt: Add the 64 bit ARMv8 page table format
> >   iommu/arm-smmu-v3: Remove io-pgtable-arm from sva.c
> >   iommu/arm-smmu-v3: Move the DMA API comment to flush_iotlb_all
> >   iommu/arm-smmu-v3: Use the generic iommu page table
> >   iommu: Remove pgsize from iommu_iotlb_gather
> 
> I went through the series, it seems the arm work plug in nicely with
> the iommupt stuff, I left some comments around, but I feel that
> patches 1,2 and 5 can be sent separately.

Yeah, I can probably do that

> And patch 8 it too large to review, it would be better to split into
> 3-6 patches, I was thinking: base support, dirty tracking, contig bit
> aarch32 and kunit.

I'd rather not have patches creating unique things that don't need to
exist eg a version without contig or something like that. It is too
much busy work to go and test all of that. Clean splits like around
the kunit and dirty tracking are OK, but I didn't feel it reduces the
reviewer burden.

But yeah, arm is uniquely large because of it's complexity.

Thanks,
Jason

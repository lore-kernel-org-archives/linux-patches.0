Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2067.outbound.protection.outlook.com [40.107.92.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED161DFE0A
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 12:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744287014; cv=fail; b=SJvva1FNzi/2yzQnKhBeubjmHSb3zKm/63NDm9PUpdmCDkvrc6HzfIEQHmJJB9SFGm9o1PJ1vTwI1VK3Q8k2m9OxGPTtp5AvWm0XEKzBL+U9vLqSPGuPS+yqB3+kb3zEro1XIXZsokjcDxb7WiGWUR3yfJ4cSpOpcAcqRQc5aD0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744287014; c=relaxed/simple;
	bh=llRELljhZ8Uz/Dz+IL5xPOfNp1pm2HUUCVdxMnJ9q6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QBAIYPp4VXtBPHZNIk8IgNoC6I5p8C4L+tbiYE72noH1pFADxKbs+UGHs+BmIZJ2VN9lObmCpva/B0mtODFoMQV52LgjJ1l2X6zFiwB3sIBOaq/sI3eAcCOMNZS3zxjTN6UUm/Dac/a+AEIb91CHSedu633GUers9IBb35ncskQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M3Z2Lon6; arc=fail smtp.client-ip=40.107.92.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M3Z2Lon6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EgZ6ShNyVRkzeqqNKrjcEtzKM3xgTbx34eeksmLo3PQsQnq6xTEqDrXGR2u+RbGUua07A/KRTydgF7E4+3/w06dXhjSkOsXgtKoOWcqDXfhGC33yBezPO3UyeJ/K3/sB318lGSuuQoRH3cQgjuScuzjemjrfKDb1R5KXmF+4i3K5o+3vzU1VRYNv98MxMRCWfZO2bYs/FR841rXunOQw1fl6xAgEX2g8Ddz+XB+Z/fNS8qLHilKCFjgFsKs0QIqqrgy0LMexy9Lz+tT5MEGBD5hxgr2V2kScntadCVVtaeX1D2+A+4Mi0GIBP7ONQaRtAqYTkk0irxlNkbWnmNFpgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WP/lcNtXVIT7ity84GWaer9uAx5uquFC6EQkdIEgIxI=;
 b=XLErzhKRfvQcPuH9WzPh7U766ISPz1uAwHxKhW08ZyrZK/tU5xuMnqYeNHv2JqiM3Q8mVriuZqEgOZCvLBfJcCQZrJzJzAtcJpndo+wkcqTfdZ8Bc+cCWtLhxQ6GaQigSm7dQnrcl6S95s6Xu6QNvIfVeSLZFvHn02YMiQOs6NOe6CrNxcakwJVTk3Az3pl0CUMHgdCL/SAcQ/+SNNGdCH3IIuZZLRNhLaYxxEpnHtq0pl65Dga7Yqr5VOmexcWoPN2XSSGDqMRsRLK67Psly1WPfwwRlNasMlSKgIt7JgjKTzJ/QDZJsns+enc6BKY9nkouOXqVTfo05p2eqyDgIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WP/lcNtXVIT7ity84GWaer9uAx5uquFC6EQkdIEgIxI=;
 b=M3Z2Lon6OtceZGlp/wcu0qoADepGDrOwgDbmV/84O9YD59nWv2lX+W7LLQ59dMyrJ++EK793Kj2VBBUqbrHoajdBkk1mZDUbab7UKwFbqxoI0zCoxUkLP7rTRyhBcOn1jQhk7ox51BVyxX04TgC4XwuWbq/gVC7syo0LknR3imXfNnA7k7rJKVel8bk/0YO6Bdeqa9V/4wMymdfnoVp9IVbP8IuJrif5pvpgBl0ur/vAh8by33OzcZiZAxh2SdhA8O0KFlCy2WNg5QvDgxVWrCiBwAJO3Hx5nJ6E2tUaKDbl4YdN2uSv/1I8IYZIkUw65+JPUuXr7Y4ZYE8YA++K5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM6PR12MB4170.namprd12.prod.outlook.com (2603:10b6:5:219::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8583.46; Thu, 10 Apr
 2025 12:10:07 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Thu, 10 Apr 2025
 12:10:07 +0000
Date: Thu, 10 Apr 2025 09:10:04 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	Will Deacon <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v4 3/5] iommu/virtio: Move to domain_alloc_paging()
Message-ID: <20250410121004.GS1778492@nvidia.com>
References: <0-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
 <3-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
 <BN9PR11MB52762A98AB82CD58C41A47D58CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52762A98AB82CD58C41A47D58CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR03CA0120.namprd03.prod.outlook.com
 (2603:10b6:208:32a::35) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM6PR12MB4170:EE_
X-MS-Office365-Filtering-Correlation-Id: d8ee5790-52d1-41a0-de35-08dd7828a269
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wOudofDr/seydexMCvguXxtDY+ICTXExa90MfCMXJBtS4o84XJygh2Vgbvy+?=
 =?us-ascii?Q?RpnRh6JETNFChmtAPzDdCZ+sLLZBybpQvLi8HDas12rwIuWTx0ayOsypPWVR?=
 =?us-ascii?Q?C6i7AQXxqK9WEcor4kq4Moijrsj/786CnGT0+Q6V/MbH6AtViBhPpCwrFg0J?=
 =?us-ascii?Q?qF3xSFcN5yGASQs6IzFApMZOp9TWTWxC8kR7E/xRnKzWkMJYj1Ri60W0iDN+?=
 =?us-ascii?Q?0Cubjt9VUoU1xryCvX87nt+xVFckv2JDmYw8ALZBm1t2LzoMDb7nMRAFyBKF?=
 =?us-ascii?Q?b3+Z7/mY16vlAmwaPY+M365bjyFKbeVTtUS3mPIehPBpIbKfly1mCmqIgEad?=
 =?us-ascii?Q?1QWRGcAh2yiS10jOKfANSVJKAW/xUKeZgMSXII6WNh+HzIslc4w24h6rg4Gg?=
 =?us-ascii?Q?ZAK/DtAlGglDp2KKpkHtInd3836xDhVlnz/nJZDVbq09Zlb01+DrZ6bm+hXW?=
 =?us-ascii?Q?broiogOOiNJYlcB7uIG59y7GwslFXIMb/jw8Of7r48N1p2M8cLGL6i+yR+M4?=
 =?us-ascii?Q?TrjCe0XK8doeAmD+Z+KT7YPQ0Ile3sgtiOYsmtrBZhxJRbci0SOfILc9FrTv?=
 =?us-ascii?Q?ZB7C/xEATjgI4uO7PSKkpaNFSwvrvXh+8FctWy9RzXEyd3bNsVVi2BX0UQQ+?=
 =?us-ascii?Q?yXApYKkpjkjHpsKNiFPfDvHF9T7xDQjk2IHmxH679pJvzBTkdjCOfBXArfJm?=
 =?us-ascii?Q?VLUSDMpxj1LEIV/XS7WZ6gZ6IhRIHMbfBuTEfem4FJs0t8gPeOCwl/bj1eou?=
 =?us-ascii?Q?XmHOvEupYWlOaIM99lXnSuVF05yS++EWtBaUBb+J3UMtwJofQNSqSZkzF0xm?=
 =?us-ascii?Q?h9xvCYhHOLWAs7qQhRohQupgkHI2osO45WrC8566s0UNI9eDdHnoUXpc1act?=
 =?us-ascii?Q?FRkVE+sbfVejk+Lec+5xRAUNiKbUcu1y9TaBr/ZEYQMncnDdgztpdQF9ezXo?=
 =?us-ascii?Q?7XVkHqdb2MBmoKM6y+SVXLE3Z6tvnscojcn1XnjHjT8gVQZhe9Q9DudsJRzi?=
 =?us-ascii?Q?03Q+zS9wXCSFsdW4nAjvNQ/1suYRW53+kciVC4WOXqHNz03AHVBV2FESK0I4?=
 =?us-ascii?Q?TlDAi6A4to/CCMYwgtZsOdX3DrzrmGX53DcJuBIRwWhaFp6uzBPV3N9Z7YPp?=
 =?us-ascii?Q?7xdD+b99zQcAsvxBe4ecnUfBuQ5TQLvzsbyluwMDjOuTA+Tnd64MoynnmFKG?=
 =?us-ascii?Q?PhGvYLWswIYFUPPdFOVZcjXUNC0B2ty2dGvCz0kqU9jD8s2djT6BbjKb1Mq+?=
 =?us-ascii?Q?ef/I0RV6J6RNcfNbhk0mrJYPEpa93wiS3fLZVNjCRFVLMIcI733H/fNB8kMD?=
 =?us-ascii?Q?I+fMSTrIP6LDBRZ826o8fAY+jDhorSoJZ4pKMrPSSoY2UqXozqiUg/03b3Zu?=
 =?us-ascii?Q?YZnp3Wwa9eL14SwLEBmHG3BMQ2/uPlquxTcosDJNvvL1SRIgYaRs4bdGY76F?=
 =?us-ascii?Q?g59r7UdiV0A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GD+szb7kVzaG6t8FeNN4G7pEsrfCG2XQYlBuPZKQwF/6vUy5c2qguHHjiqAx?=
 =?us-ascii?Q?hMcZES5hSIZ6W326C7tbuE6Ni/gK21+yWAwK6V2rk7EwzoNiUvaKJGwOFAdX?=
 =?us-ascii?Q?zJnOWARl7eqtFYQLs2TS11MO5tGmpz0cLn4d3ACxTY9gr4r1u1CXhfe+ER93?=
 =?us-ascii?Q?jS5sS41d3L/FsikIrbBeWz0A/+Uh/KlnsnErestSrrpNN1w28qioHKvRg6yk?=
 =?us-ascii?Q?LrD2RbzXZpSi9A//7F7xCt7jfg2AI/OVbWSQTSpSNB1x2TRwkntaLiXgvfrq?=
 =?us-ascii?Q?6bZy9QzHR+HIgk0WeLrRG7Ue/I2+mlxX6D1tQvvHnQ83NLgzaQrR3ur3Q8j2?=
 =?us-ascii?Q?s1BxSawGcQCZshwxzscPYza29xiMyN02LT0e/72XwVvpRRR/N46H2X5CxjSE?=
 =?us-ascii?Q?d8GxddP/PW/OIBw78r0sbIwRzWJ5tAZeDSJnHaIvaKtlDtZE9z/hCT5508T6?=
 =?us-ascii?Q?OAoCP4a6ipFq1foEmtFtaVX1ZM7CGdoPjQJO+xin7CueIMahcck8eIfW3ukQ?=
 =?us-ascii?Q?hQJ77e4mWtziPx6FplufH/R+JniEcQVMWPLXKeBY8pwSpQt9t9snMK2U9zer?=
 =?us-ascii?Q?vGg5arUDblJVzgSS8ha5GzKIhqnA5G8wyjKrZ2DGPYYgiuHYCnn442Dt9TLZ?=
 =?us-ascii?Q?e8DN2GN7xvLrA2h1bFVGEAzfbpQqPq9vuDoniQ1DfETgCsxp0aAsC2g5w9BE?=
 =?us-ascii?Q?2RJz0sQqiVqjxdre8b+DQAIJ0goHzCV2D+HGlO2Z4fuXTP0Pn1JEVmNZ1r7Q?=
 =?us-ascii?Q?x0qLuvUytlY2GFIyKaBPzVUDB68zMnLv4swOwiXfy7eEdCVdR3JY9R07IZ0n?=
 =?us-ascii?Q?jVEW1UaRz7vSkYK/UqK2T1KucRbpClvSDb4uT+jR1L8EI2txh0yJFSY3FrCt?=
 =?us-ascii?Q?m5cOpYs7qY5UMola0zAkkSblhBkGoluDXyjVz3hDnZ/OjJB2Ng17Ibu7ZBAN?=
 =?us-ascii?Q?NfnbnNa0X547zniRsfOA2h9+HkygKGvdTcKgw7OI91knxloDUnjmvdek3OTR?=
 =?us-ascii?Q?qf5QOUT5+9qNVnYh20T+2QbFTyE6sV3NwcG0uK4tcy56npPGKBJQo+WiRVvc?=
 =?us-ascii?Q?AA/TBjSIq2bNnbmWQ8MS9SfdLHa2YGYDupbM+XCE2pKDoAWXs2Nymwy/6Ghx?=
 =?us-ascii?Q?fWEfprgZffZtJW2QhiRhTmFkvMww3CmWLEMdc0Ky/MzGoYi4qs9yakwxrarH?=
 =?us-ascii?Q?1Ula1gi+/zdnnWkwDgL4mnF6u9ij0oxb3OUYQloisnq0jrn8QXvuyvIuTAWZ?=
 =?us-ascii?Q?d2IDoCfjKz1Fmp3EX3y/gf4AETa/640GQIUA4N9O69VuzFdyxPNhm1+QPa7m?=
 =?us-ascii?Q?hTuathKbs7Ke4AB5umnBa5z5zzAl422qb4CaOwoZyNPsJEWIvfHBjGvnq7b0?=
 =?us-ascii?Q?4jU+GBjC03fAgvBsEQENKbzGOk7UsbvCcnF6yjni4kEAVF5RHjpaPCzVqgKr?=
 =?us-ascii?Q?aqiw3plQ/rbch7rnvaSYeSh+dtaAc858CTgDlKPb1TtJCiqwRA5190O+iptd?=
 =?us-ascii?Q?YdyZdMUcFy64vurTvXjT10tLJDtTnV6nKM+FagAEpiX2vKh1c2Dsr+KK/0bg?=
 =?us-ascii?Q?5uBVc1yPkfzEDMh02OCYzpxnXtvyrUg6RcCabyBZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8ee5790-52d1-41a0-de35-08dd7828a269
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 12:10:07.6769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MshU7+4pmBG443928KESOSeHC/911ExAbRv7akDF35bu15+sIrduRexdStnoIkb9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4170

On Thu, Apr 10, 2025 at 05:55:50AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, April 9, 2025 12:36 AM
> > 
> > +static struct iommu_domain *viommu_domain_alloc_identity(struct device
> > *dev)
> > +{
> > +	struct viommu_endpoint *vdev = dev_iommu_priv_get(dev);
> > +	struct iommu_domain *domain;
> > +	int ret;
> > +
> > +	if (virtio_has_feature(vdev->viommu->vdev,
> > +			       VIRTIO_IOMMU_F_BYPASS_CONFIG))
> > +		return &viommu_identity_domain.domain;
> > +
> 
> Does it make more sense to keep the @identity_domain field (same
> as all other drivers) 

I think having two ways to get an identity domain is more confusion as
one will never be used..

> and rename this new ops to @domain_alloc_sw_identity() so it's clear
> that the new op is only used when identity is emulated using paging?

I think no, we had some use cases to return real identity domains too,
like DART can use this op to runtime detect if the iommu supports
identity.

s390 had something similar

Thanks,
Jason

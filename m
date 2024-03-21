Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2066.outbound.protection.outlook.com [40.107.102.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1293284A20;
	Thu, 21 Mar 2024 13:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711027727; cv=fail; b=L21OYcbdgwe5yUdp6nGePeCXXqSSpoLK6Jgh0UubMY1taJjxorqlHDgYgsC2biYukH3eQczLcEmmH/0whc6dmwqdSsUdYt6EsXsLHScvHIumr64npMMi/2TooyGlAlOTcUEDloU7+dAx8UfPVLR4QJ6VlJ6wGFzO02Kz9Xc1G9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711027727; c=relaxed/simple;
	bh=uYIC/fxjbSDEe+SrDLhyBGzq1ZjjmQyE/o9wHUNSOGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ox5IEWO7Nrjr7ah0xQ5KM7sOktYEfP79x0UcV15oY+H9CSUYCv5lAgWDmzdBjjqQhWOrcMK8J+4y4VxsnrycY5q/bYroZG6AUZ70oBKWf05EEcPrec5iFH5AaHB+q0N6YL/l9R4piiyDuNVc9jFjc8ZMG36R8arP4R9ZZ6/+RJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TdtZeUr3; arc=fail smtp.client-ip=40.107.102.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TdtZeUr3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTZe46+e7NbFKHfXdyJ4YPWevivCR5em9RhjkEjdySes1SDXL348PRGrnkkvEM1yGnd2yolrtp84yk4ZolOsUhPkldbK3G/TyQrda2nilWfjlZcm8muitKyo3AFFD36XpcW3RQ1kXwkyBcXhRAy0V2LzZSLqpTP9KPyhQb3a+2XXrsEHiwNQqrjgo9x3p87j6FdpJIgFCNO09mOdQDjI/WlUyUU7sZ8Xrpts/Wn6Rr3KtArX82tOHEZnXlJYVKIzE0F9FPwHbsTwLbGUfYauRQGbf/cqrtIJ1IDCTRqIcU5PZ+GuHZ3gUQg8BG/E4KDaI7KUL0cE1cC0Msr8FEZ45A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gnq3/gCnWN7aRMmuHPsz8WiTHsuKAMYIHrh9UiFt6PI=;
 b=OsG31cObXeXCdvF7ISfY8krVmfL05iVbqoErUUKKUWE6WHoNlgwO9enItCZ4shfBx7d+LqmBcJE0NSxvjARQwqaeIBYlsEqdWiNujLhmQZUzjj9bsV25UzpCowwhA69S6JQD4H9MT1b0CpmkKKDw56EJUlr0OhEtANGznlRa4CAnxn0MVYy6A/0mgEtbFPyCYWOnxTjLwOFtQH9QltJ8C6w5Slr4Md0d53B2uPZ43mU+44mEjlQYCit1wB85OQvCXLyEA+v15SEpuDS9oP7G4o+dK7DEXen/ie0EjWND5wDuap4FtGXOwXlf0PinuE/34MK7LSvbZaEFfz/xnwZr6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gnq3/gCnWN7aRMmuHPsz8WiTHsuKAMYIHrh9UiFt6PI=;
 b=TdtZeUr3qMfkOSg7u+90v9v/o0QI5NAgA5reWBFj2MJgBjINpE8lIeynw6UIp9Q2QehXbE1GL8K3a8cIg0XzoishK6aRasWwiq8prgzIc6+c8wXOgCHRhu+LRPEB4vNJbbvWGno3tzNqBdPi+iI1eHXh0aI+LJDcu5l6Ekq6EL93nbHm7UeNrL8P8NQ45GzcyrlmUXWFqSWdROWLneGu+GkyvoeR7IecC/RZWmRxsT0UC/eUNEKbuJqf2YqB3eTt0B7PHB0HAPplPviF/pMRZN3+m8rJmAYAOn41kY7PPVuCpHbGKyjp0Xvd/L2A8xW0kc0UxJfrtJSeo0nzJgspvg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by BY5PR12MB4132.namprd12.prod.outlook.com (2603:10b6:a03:209::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Thu, 21 Mar
 2024 13:28:41 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7386.030; Thu, 21 Mar 2024
 13:28:40 +0000
Date: Thu, 21 Mar 2024 10:28:39 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Shavit <mshavit@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 14/27] iommu/arm-smmu-v3: Make changing domains be
 hitless for ATS
Message-ID: <20240321132839.GK1044235@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <14-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <CAKHBV25xx51EuDXK91-o9BnFq5TZ66TAPuZ4YEdJ1UPq8sr7ZQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKHBV25xx51EuDXK91-o9BnFq5TZ66TAPuZ4YEdJ1UPq8sr7ZQ@mail.gmail.com>
X-ClientProxiedBy: MN2PR15CA0058.namprd15.prod.outlook.com
 (2603:10b6:208:237::27) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|BY5PR12MB4132:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cbe9e6d-61f6-4951-2aad-08dc49aad2a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Hl/QRGmG8lYm4vFNyYJS+0zY+pWRie5SZ27CaId9rZIM9CCQfr0lIYkUOOvDF9D8pI4pVGkUBL+ljlNXYxQ2ATol5F4VsOSTMzkjxSkrQuwUv6ENcW1y0roWCOpv14+xU2kAk809WsRU9eLr5TFAmWIwtNwadNDny3wpUKzN2fbGdibwUSixoAV9lXAYIbp7AiGOveWn5r6FnlMKfMHjyc6XWzH7TNFgGPI2yxDbRlcJDnNqpsxtWvMX6DHzs+JN8AlwmVYu4qb++yUp/OSZUXCsH89NLM3QadGdYB24u71ukxT/2G5p9h7FhxcsGIQBr2LuhPRempfDjXdBuVi2y/qRrcVt+fId0L8mktmLBRfOUHsif5ZCaSGbSbCBuD1YK2O5uE6CnTiBtD+X16GlHRUyaKNoePjMmtoTLXkHyiKv8/AvEenyDWkJH1E0GdEhxBvfhC7BVolUttmFwA6dEtIcbhx5/jMxQZq3niW3fSlIuc9EpiJLt5pmHCPne4enIO9ZHl/BFjqMbEcL5AVmSCTq4FhSjPYZ0QlkMRna3X+RUvnSOB8KXrxtQn6Q7aEhA6NobUNDsQH/mbgMAdrkko5/G9p7s0T8//BjASZZZJSiOosB5cVq28ak2Jfu9v4qLH6h0VeNFzRQt/ZS3YbcG/z0F82lfWjagk6FTy//JWM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LHDVGiPPASowhPi8fCxAoMlqZ1XfVSC8AAyed7qWhwQALPTe8xomYPkrkGZl?=
 =?us-ascii?Q?+J4cKVvKMJ4R5VFY1At1iKnFMbh/4HWnSUZvTHTn/zZXu6Of38QNPXIFwqGq?=
 =?us-ascii?Q?zD/YpG2GrQmBy0b3s8BVICUROm3F7LuN+MaoUtpIEDWEpyicJPvIyatfDk2u?=
 =?us-ascii?Q?jmjaiWJlvOIUpy4XDnRSUBxlL4HnVDC2oehGSnIn6hUzCE0mFQ7SbHsTeT80?=
 =?us-ascii?Q?VumJ3V+Rf3nsWs4NhNhspd4ExXlmdJBhQ3JUsNqkRECp3CQoxaldlXo8c56l?=
 =?us-ascii?Q?uxHUjRhtv9DTs+P5vJHVZORtsD1zobqQIX+C34h1FuSVPKY4WvvhN43VgpZi?=
 =?us-ascii?Q?7QCRhh//qUmmzRIwGN3YsoHl08DRWcBRIXYsnkTsRj+//U2MoV0lF9z/ZCbk?=
 =?us-ascii?Q?DeHHxmR8VjZF1aaWLNQFqJZr5xWRn+tr0vapaFcqNwlTM155mOiJk1PFREVK?=
 =?us-ascii?Q?Jj2fcCku7hvZWlUhvNI9XHCyH+bghbNLrgiak4xPo93/20AtIuTYw05gGtSK?=
 =?us-ascii?Q?Wk1rFK5bs/tOm39PYcmktPPMPxJWWPGxX/kUlq4vihDGWfmnkUOT8AqIUj64?=
 =?us-ascii?Q?lR07X7Mnqc+qIguAXf6vtZruiyavad3DdciE6WYwRFQeg/1bsdfuHyXr2cnx?=
 =?us-ascii?Q?TcjYpoafIOEdwzCCzdhdR66wfs7VQPovz/Q/v0YNaUv+p7elgKNYnlXXzwqU?=
 =?us-ascii?Q?KK+ABrIkySqOPK88e5Gb0kr4T+mp0jra0Nvpbcch6cSdt3jUyczA0dxZd8hD?=
 =?us-ascii?Q?8qWkY0K8Zxs4Y8IG0DCvRDJaiMvgoMUiM3vO9XWIt74gtA/kxzSa69D+HSVw?=
 =?us-ascii?Q?+RJiGQU/R8ZkAZf8tAtNdMtz1jOkcC2RYncgQI1zoi9ODrxtKIvsV59DMOaj?=
 =?us-ascii?Q?uffLzwHMHe/Vya7DE00CCTvV6iML7arp9Jz5an6nDHnjwGm3Gw5QtBo/VRb5?=
 =?us-ascii?Q?NUf4G0cZOcyZv/DFzDotmL1sa9Y/XW5kb+bVIjms0GWWqzuuZwZmI+bndiAh?=
 =?us-ascii?Q?FlY+Pds7+eBFKBYZk1BECGajEJ+2v0kIKwVRpRzMdCCY/MCJPxX25xcucw0V?=
 =?us-ascii?Q?j32tKd5VSBiNT8RF0tnxHUX8b5zjMC/Ym6fY7vLu+DFTom1sLdo2i6u9vOOa?=
 =?us-ascii?Q?cErFkZx49hP201R1HssSsIfseA2o8iDBvNLeYNV/H2DcOQTgiq6kpiWGqPPn?=
 =?us-ascii?Q?jQSRcTZoRVf26nmIzPeIltcwXNgz5p57+/Fz3Yng2E7yXIGedRft53sfAu53?=
 =?us-ascii?Q?GQ95pC5U3AVBsXg6zXvyhWzW2ZwtWDYHwMHSNj97WpyhP8D75pEj5VWZNM75?=
 =?us-ascii?Q?LFlJ6mvv2MvXDxZN8ZQ0i7B/F1W+UV8jJx54bp+NVVkmZOXqp+VSXUBq/QK7?=
 =?us-ascii?Q?h9eEDfi3jYgUcLA/bBfZckUIElqiEVY2MP7DWHmC35WlIAXmLWiVB4iDOKv0?=
 =?us-ascii?Q?KJgdcMU9imOzIkCwFa4cQllmwXZiNed4444tla0YAGG/PbUWUzAGT3IugJ6M?=
 =?us-ascii?Q?mKmLgrp44JHCT4g6LSWeJHqV7VqdVL0TJ6FNcO3qFTEtggVIOTjk94VA27GK?=
 =?us-ascii?Q?HI/KQW4HPTlZdnBm/5azrTVTSkkpeGG8Kn9rQapp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cbe9e6d-61f6-4951-2aad-08dc49aad2a6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2024 13:28:40.8641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wlsImdI0Is8yX7dUQZQFUeueNKZVSqvyY8R7Vtu55Ryy+1if78flAdw3LsekrSf3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4132

On Thu, Mar 21, 2024 at 08:26:43PM +0800, Michael Shavit wrote:
> Overall I think the patch works, but it took me a while to really
> digest the big picture. Just to make sure I fully understand:
> 
> We're trying to satisfy the following invariants for correctness:
> 1. Devices cannot get translations from a domain that was detached
> after arm_smmu_attach_dev() returns.

Yes, regardless of ATS this is the API requirement.

> 2. Devices cannot get cached translations from a domain after
> arm_smmu_atc_inv_domain() returns, regardless of whether the domain is
> simultaneously being attached/detached from a device.

There is no simultaneously here since the group lock is held by the
core code.
 
> Apart from note point 2. above, the behaviour of translations while in
> the middle of an arm_smmu_attach_dev doesn't have well defined
> requirements:
> 1. Before this patch, devices may get translations belonging to the
> old domain, then aborts or identity translations, and then the new
> domain while arm_smmu_attach_dev() is in progress.

Yes

> 2. Ater this patch, devices may get an arbitrary mix of translations
> belonging to the old domain and the new domain while
> arm_smmu_attach_dev() is in progress.

Yes, but no aborts.

> While disabling and re-enabling ATS inside arm_smmu_attach_dev() would
> meet the same requirements as this patch, it's not optimal since the
> device may still have traffic on other pasids than the one being
> manipulated.

Yes, we can't just disable ATS due to the PASIDs. A SVA PASID might be
present and disabling ATS to change the RID domain would completely
wreck it. Today this scenario is prevented by sva_enable, which is
removed in following patches.

I added this note for context to the commit message:

 This is part of the bigger picture to allow changing the RID domain while
 a PASID is in use. If a SVA PASID is relying on ATS to function then
 changing the RID domain cannot just temporarily toggle ATS off without
 also wrecking the SVA PASID. The new infrastructure here is organized so
 that the PASID attach/detach flows will make use of it as well in
 following patches.

Thanks,
Jason

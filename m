Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E0E1EB5C1;
	Tue, 18 Feb 2025 18:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739902915; cv=fail; b=OW9CrRfuATNuHYI4K3i4Ld4RurA9wWSvnSl7HJ7VqMJpaZ/Zd+1SMVt3hfn2g5zoNuSTKX3XLJ8eT7Qtd6HkFlFune/4OjLOCxgVcVZb+Ki1A3M77LhKXNo4qtWrPsD5CqRs4nxts50u9CiJiR611Qq7LgPORWkcBRXU+hDUOss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739902915; c=relaxed/simple;
	bh=B099CReSvvynMUqwTWb8Tdl3XNRYPn5DJJuGxxOHwDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bVr+pqyRild7FfoNk79nbOu2//UykOCBSD2hPr3vhVTUGhBYyMFYfWg78dbbxuVcnY1mtPOjMjKivabvX5UXMcc5qx1QiFEwVgpj/k1OW5/w9wUEZ3X3V4KcI/UEG1prrNRE+ueLIasDpQ1fhi2+CoZxSS4jUTT5uc+F0AjoP+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gZrGvjqV; arc=fail smtp.client-ip=40.107.223.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gZrGvjqV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NDwm0Lr2JXYW9AtrcqKQvkXL1mLN1DdNqMG0/h21VkZV8BL0V2G0yFoA+pMjnUCv91aMh3bP7vxjy71pi1QjyvjVGI5+UddKIjzjaPF2jqsWD5w+HIwIeDyeullolxSmvtdkWPFkyCaxyUsCtrBKOy5qwy1BK5DfynyW6QxVUrl00AXXBeyASz23ENqrvnChBR4PDv9f6MXLRoCLtPtCR5A+f1sBMmAwaN4XQan2yJqgR1XQ/Cx4ELeB5fZvdk3tqduz7xlFxtX0BrtmYw80lTCo9k58OP7fx2Xlp9BCPRAlNKUDsK+RYcQAR6dQ2GFnefULoW/1e6Ib6JyPu+FhHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wV58xv+PnMSsq6oRx4qQ8W0OUm9ZYlFQCPrff9GOFCo=;
 b=GTXh5ms8iWQcCzD6q8sluZ8xRtZfFrha0GGeqK1G3vOF770nP1hHYdRWbF9EjrseV30f+9poFNf5W3/ZFP43w93X164tvVWrU6tnaADl+S+X6N6YCWRi3E55Ou1+XZjkV5ZmWRKHtYJd7fROgk92lLyumkb7rcvzT98KLyKIyfW9PELQSI2zMjgivCEVTHliaAuPx3wTPLraP+q3coNcBEYzt02yQu7trmHfM6zNWvUcbS7zDdk8H1TQfFdCYBDq3226DwWP7HNbIXmLEJaqITJ4BEKQYNj9sLNNf9bzVhrx/iNuwm0XWgJIzzcsp0TscMLI0WDYCcA+ZwXy6pmYyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wV58xv+PnMSsq6oRx4qQ8W0OUm9ZYlFQCPrff9GOFCo=;
 b=gZrGvjqV149daAk2H/cfzAipqaRipPb57p2Crkrah2KcJLH2gyEr+82GO7LSjYaRMABecqrYWjzRxyL9dxdsDz+7UvWAGw5lmfTh6BAKtZstywhJuOUwC+Z5e+lwE6+5pkSxpeOGH5BXtL2bxpxPNUCHzKhJSutIdMkVxwCgQMUukMH4MIyd67Nq0I7dRxfwOMWChceZAMqULpCM5DSOTl4tpNmX3JAT4XZRm0As9aQhuT/zqjInBqxFQI+GKkJW1tnSuy4kVhqCkbfJhzz7kPmZhSSHstJtAC+hP6dEBVAe8I3COUDKUwMApZFeRZCb27WBqc4rA67Jgji2XQw13A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN2PR12MB4454.namprd12.prod.outlook.com (2603:10b6:208:26c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Tue, 18 Feb
 2025 18:21:51 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8445.019; Tue, 18 Feb 2025
 18:21:51 +0000
Date: Tue, 18 Feb 2025 14:21:50 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jacob Pan <jacob.pan@linux.microsoft.com>
Cc: iommu@lists.linux.dev, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, patches@lists.linux.dev
Subject: Re: [PATCH 1/5] iommu/virtio: Break out bypass identity support into
 a global static
Message-ID: <20250218182150.GJ4099685@nvidia.com>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <1-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <20250211164355.5a1c1647@DESKTOP-0403QTC.>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211164355.5a1c1647@DESKTOP-0403QTC.>
X-ClientProxiedBy: BL6PEPF0001640E.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN2PR12MB4454:EE_
X-MS-Office365-Filtering-Correlation-Id: cc073aa9-cb70-4dcd-e401-08dd50491d2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+4r2NEy0L0kzng/NGyfecoYlZKIMuYTobVDY5O3/edp0GALxFNQI9RJaOrix?=
 =?us-ascii?Q?6H3BNbWEAzwZdhICZY9a4/U2RXEDg6mMzngt0rxdKrWm7tLi/Wpr5GQOtjAs?=
 =?us-ascii?Q?S4o6EbOS67Urj8mE8ovV5VwFHPpxwATD9nhmhQ58ADYTTmXfjR128zS38TWQ?=
 =?us-ascii?Q?Wb0kAGnVGvQwkMdLXGZQxU56f6OSreTDL7v6caIsfIbHTvGaajRq3CZoq/Rc?=
 =?us-ascii?Q?aDP95mewjTvZgVDaGshxth8BgT5p2IkV28tQOX5M0/Dw8hXQby06FHrCCtDO?=
 =?us-ascii?Q?FwhQNgzagfZ+8H8LO3bQoiiCn8LBFK01uo9cDLviJef9Vt5/U21Ykee+Z3Iq?=
 =?us-ascii?Q?UW9SiqtWIVedhI1Z9tYbv8di6ySWefb7dq6JrXxzua1/L/SuhBoPrVU6G0tm?=
 =?us-ascii?Q?p0EfzSjhkJAJWEwwCx5F/KXPmErSb6Zm7ataw9MsdquA2BmcWhAymlPPO2o/?=
 =?us-ascii?Q?MVdSe4VCAxG7vaLA6zwVVdM69KJVgc0+IkKfXSkRDcRzOtHuGPdy1RVgAnDE?=
 =?us-ascii?Q?rKtD1wDqX1Ac1eIomAs8TT8YxhNvM6EP8u8qTU+lRB4rj897dgRlS54qRacs?=
 =?us-ascii?Q?5d6BEuVn5JpU/6QR0b93fGDYK/Sd6TjfiPV2DapZIjVuF8Xoj5sfcvyjxu8d?=
 =?us-ascii?Q?+RuLJqx4qM2/qgEgeoUE/wmmIznFl2gzlQ/xiXaTr7UOPogYNqXIUA+S8Cvv?=
 =?us-ascii?Q?KDAOZYAYbH7x1NOmww/aO47Q4i4IYOBcpwY0KiFQHD+DzeePR/YI3gmKjjlG?=
 =?us-ascii?Q?qIbCcohnL/s6wdGV5Cs6yaY34squgpC1BVjVPsLXWyD5soQDWz51p/i7Dg5J?=
 =?us-ascii?Q?yvMFUzFdnGiYK9WQ186abXaGEkBCQcsV/Sh1UbtnZOzDooklxX19iDWrjl0x?=
 =?us-ascii?Q?9NYMLL7yFuzm4wCp7Z7SazznjnXCPOFdXlsxsfHUDJVTZbSt0AY0SqwoxBXZ?=
 =?us-ascii?Q?6bqbKoQtWRN4dSaraGS1obyzybri4VfuVRio6zAr5pGDb0+lyH2F9qVXeCIX?=
 =?us-ascii?Q?U4nEA/A0Frtq4T82iybtgzsxL7pEshsKIuAIO4LJFBLCp+MWbxeW3UNkiok+?=
 =?us-ascii?Q?gz0xIq9Q1959DmpaoTqJXbnjAw3ScxR4u0O+beCRBNKqgqeA/rM73JxzsQl7?=
 =?us-ascii?Q?bouuhTswR9a9m9b5dA7wlieu9Qwc8V7/x2IMLmoZpvU73ZpWmJY5O8zkczee?=
 =?us-ascii?Q?NB/227WRFU/U0oKn/QECnACTYdXDJTlOx2dYfnqzF3HO7GO5VIr/coRs+7fx?=
 =?us-ascii?Q?19b2/mVnAcOQzJ+FgDUP2gbApdxY4t1nB4JlKncweNHUkUj/tJCOGCvNF6As?=
 =?us-ascii?Q?S/hxQPMlcsmINMYw7T91XhUZXn3KO+Jhk5Z3UVKYwgB7kfRrv9YxO407ZSGn?=
 =?us-ascii?Q?Ro5Bnw8lpmqRYnXXMGUkBTuyhYv0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?269cnB9UP8R+LNT9/vbeISKLR1GgFNDSrca67heBBQMaeQeifXculz/7NNSs?=
 =?us-ascii?Q?hswxx5tQugj4F6X9w1hODev5nVle2U6hhJYUXxGc0WKCFTs/jMdoL/r6eIhO?=
 =?us-ascii?Q?KHAk6/N6iY/aT/JABMjjUYmEqQFOha5Pfh4avi0iKyZ/l/oaZGqza6ll8X6B?=
 =?us-ascii?Q?EcthpzNYH74+BTX9ObqFN53M2FimhyMnr6jzPHdwFQArKMokRpRgpvV3vcuw?=
 =?us-ascii?Q?8cNkgbRFNZd3KVLSvxf9xsCcyYECY/Sm/08ksN0IEZej11jT2bji5FPRCNZu?=
 =?us-ascii?Q?SHyxpgFAAkZCOfYsJQyf1s8rnkFSsYZE5nCnl0+95mWGtw9Kgkt/9GCj8mYI?=
 =?us-ascii?Q?/e3GdOcareVnJ1WIPRrdJ0XL49sDBHS5b0wGFgZo0Lqx7Riy3xt2k+dgbgxw?=
 =?us-ascii?Q?IpoOVvupWupZEK9TeI4QxwRGJDw+FNgjEQsu3a3WnoM3QRmCmNzOA3oXmNoB?=
 =?us-ascii?Q?gE6wukzZmMuT6K00N9rOmdxJLSsKhKIhPPTh2f8yOR9IjCYiqeLlhAtqS9Ws?=
 =?us-ascii?Q?XRRn6bAEsE5IBcUhSkMfjeIWMAwKPg1vGdr/uFwwQ1sfyZYzXqrgQ4J5tVnT?=
 =?us-ascii?Q?dSAAD9kKQ9iDPuDIBeMlynjhK4ShOPwb7iiyVPc9dWuuahl4jPmTOAx4vqlZ?=
 =?us-ascii?Q?vKWcN9a9pnNLF27Mqa+fgwDZmelxMKWdVYngmomWSRd5mOM8X0qcJgizXD1p?=
 =?us-ascii?Q?Rau3ydLz6UtngUGvtUEimfH3kwYW35tJwxq6ojjeB8Tl1fJ4YO6L5kXGlf2Z?=
 =?us-ascii?Q?2T7ikS1L0zs/4noV4a0hd56ZMA+/abyE8CINEagMyVSHTyoa8SARXR+EPrR5?=
 =?us-ascii?Q?ehVEDbDW8CCWJpbaJyF4IwEZ9VaPdzNBR19F3Q1nI233VyUF+3VBjj1ERX8e?=
 =?us-ascii?Q?bpAs5e13pkoIy/uwd8QHas5+Kf8TDvryZELkBN1PD4hApYNWQXOtRLbIhdji?=
 =?us-ascii?Q?LmasJ9pePrAExDoFvaG1GcJWvlGkUAA5Dd6WruIerNr+h2atZ4nCQ27LkPIz?=
 =?us-ascii?Q?Q8V/fOphPqI6Ctx5QzPpqBlguByXTFS9vyeSKRoVPlI3uEqdtdr9mZNMOvt1?=
 =?us-ascii?Q?wY41LWaytQD5KmQAvszEqPMlZc2UhiGKLxyI7CZkCiIuz4tNFdWNxlKk+Q05?=
 =?us-ascii?Q?mv+R+gKLTQolxkESf0dO4zwzYJ441g0J+kpT+prFn8Zng1gsV5ur9QLODa3I?=
 =?us-ascii?Q?uAYJcvoqDSI5XOn8276hgKNLA62Ay2kVGFsqDA9kNfHKA/S6c7L+e+Fjoj2z?=
 =?us-ascii?Q?/w4SYG0RO5YfmkIVp495bxZCbOS8nw4YStvSLwy9B/e14+kOin+BnIWOMUCD?=
 =?us-ascii?Q?B/t0Ts3MmrttMr4hE4Oz1uQ1+9qiyfiOvRiajsGk2EzsBDFhZLK1oaC/4fgr?=
 =?us-ascii?Q?0hjLVMA/P2rost43wQeoP2EWVYqScPMpxfYltWAOVnJdzgvFyfHS19DbYWs0?=
 =?us-ascii?Q?y5eGo4Y1MWSn60wBcUxcbLkLOPg+9SkmmIZW5iTxgwBFTENeReSBExf1gLmC?=
 =?us-ascii?Q?A40mmJJqPmH329QgPLiDj0z+RXIm83iTjZjk1yX5cChWazUvfxPqD5tI6cUG?=
 =?us-ascii?Q?Lx4OiDGP9guGGnL07B3KD6liL5bTZXkFHVZWuuOM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc073aa9-cb70-4dcd-e401-08dd50491d2b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 18:21:51.0674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Www3h2BEzxjMGZDEmdta/li32tXKEedsFSjpZYb0x05qfltZn5IaPd5aSW3c24Ae
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4454

On Tue, Feb 11, 2025 at 04:43:55PM -0800, Jacob Pan wrote:
> > +static int viommu_send_attach_req(struct viommu_dev *viommu, struct
> > device *dev,
> > +				  struct virtio_iommu_req_attach
> > *req) +{
> > +	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
> > +	int ret;
> > +	int i;
> nit: coding style inconsistent within this patch. Inverted xmas tree
> here.

Ok

> > +	/* Reserve an ID to use as the bypass domain */
> > +	if (virtio_has_feature(viommu->vdev,
> > VIRTIO_IOMMU_F_BYPASS_CONFIG)) {
> > +		viommu->identity_domain_id = viommu->first_domain;
> > +		viommu->first_domain++;
> Could also use ida_alloc() instead of special treatment, it would be
> consistent with the paging identity domain ID.

Could do, but that would allocate memory and we already have
first_domain which is free

Thanks,
Jason

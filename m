Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2042.outbound.protection.outlook.com [40.107.244.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0F71876;
	Wed, 19 Jun 2024 18:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718822623; cv=fail; b=rWNMhDOAud6hbTRrAzVRRhN5Te3Xdyumi9uZvhDwWdH3T+YN8j317E6mfVWL5Iv/hSpFrz+Rea6dTmYIEza7OZi33BTPqravqQGNvICAMWNbG3+xsttSvtbwrwJiBz4TjVzwIfmG0d2/ceLIbp0G2qJE4Q1ZUqXeWNG1Pf5m650=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718822623; c=relaxed/simple;
	bh=4RHW6egtWJGj6Mfm5rWGNf5rLeWCwvamYT6pGKrs9Ac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PKyQIu0NmLtebvL/LTu5xvlCR7lGRdUWLPwZUKC4k83LqAZRLhQVoKnmkHVeTTLbzLMkr5NU6h3vvGxo1Tj4qVtxCZ3RK3czQrackIa+DzMsmCoqUuDWGfSyFtpjtsNUiWN6QIuXoYtK8vrK+g3JDRzO6plHA47Q5gqUO/Qwl+Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=esOGWfPC; arc=fail smtp.client-ip=40.107.244.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="esOGWfPC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NuwJC7W133QiS+DxyguTsJTmEbnCDPJs7NdAmTdn8wkcyD0e5rtElQBAJynPwkGYuNwDTai0XDVCRkr/KyZyD8EnJAJgNGt6DtvMJW5LBpjUvC6DsaGOSgKSzaoySEjkKP+F/EGW326iCPpdszMVjGTf3DXMf14XJGsj0VhOR/k4chOwFaJpsh1rbGgstHLMcB73sO2uCoOW3ZcxOqY1Q2d7BVC7+vgqHJhgC71wtdW3tzFLk+VsVHF8AEyk3jEWc3GDpxP2Bk2E2ZghB55ZLtNFxnLs560YNlCMj6ckgvLabPNpOrdI5WCBktVya52YI5x1bFQt7R9gLNz/AKaiMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZLimjPFa4Ah4xVENZXvfBj2aXXzESCgU9eRHdz9Jwo=;
 b=jaIuhyBIJaoQeAbbPXmoyxKkMhPWpADe9KgI7hBgdTZ1bfEzy5QltAZgi1IOkqQ2PvuxicVmtgpUmfh31GJQ/2VpbJRS62ARvpBSVpdiiMrqQKlWl/GizSpaqWgE6fvbhUzdpCAeIWynt7DkNMotJyH9ad75r4l6XSip+rcfXKxgwtj4duH/5TRTcaY5zzKtnrv8hrVuE5pxi84anraGNJ1gp4tYOBR4yde511KgFl8QESahcdWH1uHrqK1eREYzgdtcN2h8A1zEqs/pJV8KGD5D2GqzOIZtOf7zw809RcwiCtNV6J3HFbUjuq7IU1JenARUi0Vcq5n34NnJ5iYSpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZLimjPFa4Ah4xVENZXvfBj2aXXzESCgU9eRHdz9Jwo=;
 b=esOGWfPCs7oDbMDk3WkotUEPWWjnmOk5oaNhRAYCI5OlbyqmIT7a+4Lef6ZxhnNRGDZg6OxPQ1NqBKWKSytWJmQDJZrr3ikIxx9r4AnNm8TBtWeFBFy91KC9HeboUf9JHw+BRMWTqBb/APhD7SyiP0QR7AcluioHwzZfN46sTL75U/n7RZUlbx28rkSX8h7W7nBaJJ8rQWpTs/s2hj0lHyVvCZIpSYYVTmmayAj7OGfUnfsGe+0LCa44Dlthzr5P+HQ5xnW1wwaJhUWOrCfJw0dOPEcwGYcdn2qMTP5eY0Il65XwcvSJWCdiO7qOKPH++lCU3zgTW6QUi3Ekye++Pw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB8967.namprd12.prod.outlook.com (2603:10b6:806:38b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.30; Wed, 19 Jun
 2024 18:43:39 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%5]) with mapi id 15.20.7677.030; Wed, 19 Jun 2024
 18:43:38 +0000
Date: Wed, 19 Jun 2024 15:43:37 -0300
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
Subject: Re: [PATCH v8 04/14] iommu/arm-smmu-v3: Make changing domains be
 hitless for ATS
Message-ID: <20240619184337.GA1364936@nvidia.com>
References: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
 <4-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
 <CAKHBV24ANjwSF=YpzxdtOR32N2y8v+Phh5jbxxmw-tLopV2Lyw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKHBV24ANjwSF=YpzxdtOR32N2y8v+Phh5jbxxmw-tLopV2Lyw@mail.gmail.com>
X-ClientProxiedBy: MN2PR06CA0028.namprd06.prod.outlook.com
 (2603:10b6:208:23d::33) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB8967:EE_
X-MS-Office365-Filtering-Correlation-Id: 0db63219-bb88-468e-387a-08dc908fbba5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|7416011|376011|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?heSwpS0DA6nDwrJ75utyDKv2XaySsV4mdUfVKurrfeo58eFJRK3Qdwyy+lKz?=
 =?us-ascii?Q?Smb9bVTck6PmkBvtILuytbf/Tj615AyTXJkh3mHbkR+MML6JILn+W8EERoYG?=
 =?us-ascii?Q?dHxTB6YEulmbpE09RTFMtAnJL3uhQGr0yx+yUhgxBV5s+pRdEULp4//GK0/H?=
 =?us-ascii?Q?5Ve23lLk2iQ4ZR2woPld+RwxHr9PYPBLkyR64lR/DawkHC6g8WRhk7RlPdZ8?=
 =?us-ascii?Q?6bnjbYK6F87TPL6Jh9FushoQn/81uIaJ2C4MSf17VDTmTtcOdU8M/BguzyUa?=
 =?us-ascii?Q?Ev7clKH6gV9tQmzIUn4QeEY0UyJGlRJxZS+kwz0dRAY8ctG6WsJB9saJuzLD?=
 =?us-ascii?Q?oDaTQ/CjAZ49JDgYrcMeiqG7LrbHtj4K8+qb9M6rQX6OevyECF9RaShkPhuG?=
 =?us-ascii?Q?DUvLhLGva9pJg2gjarQFahyMoOkcg001A7UIxN9SY9IL8+iQ3tmhcJh/MQQT?=
 =?us-ascii?Q?Ay5PktS3jqtaiS8y+8cbU9+PkO/m5wx1BX+uWsfOVqZBsEh8NNq2SWmVY/c7?=
 =?us-ascii?Q?vjoWHiIJMcjp+X2moUr/pVrMhk4FCvqJF3KusEoD0O71OLnucPbWP3xUCBSv?=
 =?us-ascii?Q?Se5Ezn+TdmnaNO740Udys++BWxnzrqsIXqtCo6motcFkWBlac2NVDa+0E7S/?=
 =?us-ascii?Q?/D2TPIx7FNnuWF9Q/24CMHxSANH4zTNGQ22CObCqoqu0waAG7GogrdDB93Wv?=
 =?us-ascii?Q?3SEOrZcJEvbTroPNnSFCqT9EnLxkHA2NyRKlBzd+Sd68xuZXfszoDD6umQn/?=
 =?us-ascii?Q?pM8p/GsNaBAxx+Y7YKJbaMJTzOmxUUzWNGyX0xwVTD1kWztvf3OX2Z3SzOZp?=
 =?us-ascii?Q?1oSqy2+FT5C8e1DybEqIziqblFZVJBb+KJnU4dV/qq6xOIbErrPylT/Wz6c0?=
 =?us-ascii?Q?TBEuhSCfJIrvAoeprNSW/4iHDZyGaB/w5ituvrVHAxeqrBUwbsNIl8kCMa/B?=
 =?us-ascii?Q?0KMPnoCsUTZ8nBUM2NAfIuCD6dxAH3uUTdkJUZRjX62nyid9Tby8ac7zYdo+?=
 =?us-ascii?Q?gWcY/FTyy0Jj6LQo96tV0Ubb7KGHLxZ8OjPHZ9mvYx/HyAERijM2sGy0kb4a?=
 =?us-ascii?Q?VTRVuhwl23hNomP24HxApu9NJ/CMA7LbrN8oCnS3pZkVJEfGUCFwUGMMtaM1?=
 =?us-ascii?Q?QtbM9Va9Nq6o+rejpDTjAnjuB4IHI8qSmNjrQ1hZqr7EGJ32LtXf6URhLrfN?=
 =?us-ascii?Q?7klEg+sotFKeggKrO68W/B8vhMIQwykjNc27ZZnprcrCKO1jIwyPslY/y9qb?=
 =?us-ascii?Q?Ln31aRTbjg3pg29qHqHLjoiDCIFwi14SAD5ETfNZnPlgQA9bECnWhv9pqzaa?=
 =?us-ascii?Q?eKaXOeT3ynN4jq3OpdHetvgZ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(7416011)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pEqMb+Z/r1pbplcA6LPHn7/Sg8Y7410dC+jfLolVoeAvjwH9uYaM5fbVloE7?=
 =?us-ascii?Q?3LK53IKZ3nQnw2XviIJQl7Wykq5Syako4HZ9vIKlR/7QTFBGlrfJR3abxDQL?=
 =?us-ascii?Q?oOUlW0UgsqIg0zZxvvGz4926D1hYZ1l/QzpHUp40Mme2efVm6U7InywTGxgp?=
 =?us-ascii?Q?PH7AXNfCjZSY7w0RbDFYobtMe3zXdpG2sBQiEf1gJLSPh7oTn8Rjzv4xFAAd?=
 =?us-ascii?Q?7Ef333ZxBSG/e5G3/IOR0ojxQaEjK1nZ3pUBLWSOuB1v3GNcuuKxRQRNSlAE?=
 =?us-ascii?Q?448rKkNudN+9BgNAZZOWYBIozuHDuiE45cRcMqK5h1mOaebf8BbvyMX7aESP?=
 =?us-ascii?Q?Nt6fAkBcHGZQ4txw7Hp9Oh5uC4NmRkrme7WvJ2ex1nkZj4MouhbcoNC4k6vu?=
 =?us-ascii?Q?IbXvkw5UhA3Q0KX0/Rn6RZKXk4ZfsYoRe8sY6DcqfkunzXzOxSHlIfC3L+RA?=
 =?us-ascii?Q?cfBE8Hwe3Hhm+kDBeBo0xQcsLz1XWPadb1apNi4nlF/hqqkHH9qBTXdlx5oX?=
 =?us-ascii?Q?5mqOkPEzm0YzLnwPPcnFPgCPTd7CN/CHtwga+Ga15Y2BZY74lJWhaieKwd6S?=
 =?us-ascii?Q?GE+gyC1BZbWTsCxbsWwrEZBvhMfJMlRAG/I9MXM+QL8Fky6ORPBWPZ021+tP?=
 =?us-ascii?Q?zFzMsdIt6a7R4ATDeZlUUaYvEQm9Rl/rfmjOTCDz5uPjZxUly9XDgVG+9+Wc?=
 =?us-ascii?Q?J3ND4mwF/yPsaBk2iR3aHl4c/2/Q1pXo0Qb+1fcXzC6kDdBPQbtmf37RRGF1?=
 =?us-ascii?Q?HioZcBTfJOs85T6YPOor9fqS2pSDHIpcLtVYuSE+H26eI3gVbEeGTKKuwuiI?=
 =?us-ascii?Q?0EiPvlOHRG+ou5XVtT+yeNRwuAX1POeh5hBjUjPCH9YZ+9/p2LDv9EjH8a56?=
 =?us-ascii?Q?xO3+Ot4/JfANxBfXlsS8ZzsEtLQq9DyBzycIbbnMN8Ne43RWTJnFn6e2Jpjy?=
 =?us-ascii?Q?lbfgAy4SfnjQ2KZmxwDAm8TtcdbGXALsqkW6ifpFrAkPeVyO19YbZ2oRO4nF?=
 =?us-ascii?Q?tkgANSTTmiGshgjvdlsHdIP60tr3EYNwenGeLAWaf9RLCOopbVIEyIUDBNH3?=
 =?us-ascii?Q?XcHVMnPnDBT/lOCbiDtS9CKN7X7sgs3rCNW0YY0TlN5lLaxrlIZo70SAaUSI?=
 =?us-ascii?Q?1nT2WRMzt8qRD0xLzunpOBfpjc4DPkUIOY9m3CTn1qcy7tEbTHWcRXKo+eRz?=
 =?us-ascii?Q?I4rdLGdRzLfGM7PGWt+zGaT/0TKuaaLRDaoiazOYq7OVshpybsmOcm11t7dR?=
 =?us-ascii?Q?NxZgmzTF89MGjBc7cyP/Ud1ndFI0KLFao+iid7pnakrf8s74PfHy7mDHn/MX?=
 =?us-ascii?Q?9qGkEy7AoMcSdEGktCo6Fbgt9SQRzo6aTmbmjTnXL+OKLCl7TGRPbZDpSniI?=
 =?us-ascii?Q?S4WWBfs62kM4abSXtTlqqzg4Po3eVsA0bhBbbRmHDgOUWzFzZm9VN5e1O9dt?=
 =?us-ascii?Q?xOlGG6QgD5vKVS7c+wni7/UUJMH5n9mnSjqAYkVrbKH4lE1OT+CerJSZQJej?=
 =?us-ascii?Q?jaMvA27pe/In1LosN1BDCrsYsGXIlfp3A8uzEQJ+GzRMhaApMj42M+GpWcNU?=
 =?us-ascii?Q?vKLagyjVmlTzL0Cd7xa6FF34Ns+KzxM0Co6wav16?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0db63219-bb88-468e-387a-08dc908fbba5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2024 18:43:38.4513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ir9GFN768J/ePAEQrRVnHcUS8J7oE00Wb1R/W6ZZNuLBKip97JIAx4u2BL9VBju0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8967

On Wed, Jun 19, 2024 at 06:20:56PM +0800, Michael Shavit wrote:
> > +/*
> > + * Start the sequence to attach a domain to a master. The sequence contains three
> > + * steps:
> > + *  arm_smmu_attach_prepare()
> > + *  arm_smmu_install_ste_for_dev()
> > + *  arm_smmu_attach_commit()
> > + *
> > + * If prepare succeeds then the sequence must be completed. The STE installed
> > + * must set the STE.EATS field according to state.ats_enabled.
> > + *
> > + * ATS is automatically enabled if the underlying device supports it.
> > + * disable_ats can inhibit this to support STEs like bypass that don't allow
> > + * ATS.
> 
> This comment is out of date since disable_ats was removed between v7 and v8.
> A nit, but "automatically" is also a little imprecise IMO (almost
> sounds like the device is automatically enabling it). How about:
> 
> + * ATS is enabled after the STE is installed if the new domain and
> underlying device
> + * supports it. On the other hand, ATS is disabled before installing
> the STE if it doesn't
> + * support ATS like bypass domains.
> 
> Or something else if that's too redundant with the next paragraph :) .
> 
> > + *
> > + * The change of the EATS in the STE and the PCI ATS config space is managed by
> > + * this sequence to be in the right order such that if PCI ATS is enabled then
> > + * STE.ETAS is enabled.
> > + *
> > + * new_domain can be NULL if the domain being attached does not have a page
> > + * table and does not require invalidation tracking, and does not support ATS.
> > + */
> 
> This is also confusing, new_domain is never NULL. It's
> to_smmu_domain_devices(new_domain) that can be null.

Yes, the comment didn't survive some of the edits..

/*
 * Start the sequence to attach a domain to a master. The sequence contains three
 * steps:
 *  arm_smmu_attach_prepare()
 *  arm_smmu_install_ste_for_dev()
 *  arm_smmu_attach_commit()
 *
 * If prepare succeeds then the sequence must be completed. The STE installed
 * must set the STE.EATS field according to state.ats_enabled.
 *
 * If the device supports ATS then this determines if EATS should be enabled
 * in the STE, and starts sequencing EATS disable if required.
 *
 * The change of the EATS in the STE and the PCI ATS config space is managed by
 * this sequence to be in the right order so that if PCI ATS is enabled then
 * STE.ETAS is enabled.
 *
 * new_domain can be a non-paging domain. In this case ATS will not be enabled,
 * and invalidations won't be tracked.
 */

?

Thanks,
Jason

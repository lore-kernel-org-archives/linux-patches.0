Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011007.outbound.protection.outlook.com [52.101.52.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1ADB1624D5;
	Mon, 19 Jan 2026 23:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768865470; cv=fail; b=OcH12zqoI+CyDw6KkZ4NLh6JZKgfit0Y8JuvRrccRgLBevFeU623X2uNKteqyE/cpqQEp+SnApcX/UfZxwW+mQPcjqVB/RmSpguMV9THKrQRArgVkjA1rIehcY05JYxGAjhyppKYzx0+wdMKOr66gasNJPh/TORCpPHsZT2b5NA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768865470; c=relaxed/simple;
	bh=ch2xneGGBp/HfuxD47zv34RL8Ti1X3Ca5KR1RO7jy/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MnZwPHS+zE4QAEfm0/KnlVVjnxrvebaRGMYNOJWuAGuvBKGcgPKt7fnB+d0bO4kDH6Ej7QhHfTJTOZFR6ymkrB7KhODNNttbd2h5Tjlt8ckoXFZqpsa7NcEidIp4QXBWtpVmPleDvEu3/TAzUkaB6q4hUCmbTs5M8Y3fQtCkj1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=j+Ug0Q1c; arc=fail smtp.client-ip=52.101.52.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="j+Ug0Q1c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E2l0tG0gxB+Gb/N6fO4F9+Jdfr9uJ7Dr9+lMOFsXyrmMASXVbagm98h+XDo/s7BuRZEqT/NpNubbXsSXuixtYEDczJBZs2tBBzKcVRRfnRgSHs74NGB9CEGjqN7k2zSglnccX3LRpTuHKK+oSpzQyb/3n9yulZlt7ReSwutGxk5z0GGlCq36m7A8JXKbX06pryPcsRbZ5y+CaRu6Hzc8soSrKwoHdAbQ5qr6h8tP3uJXOgUCKw/6XaL2jETreYXGUY47zsj6ZiJI7KQP/pBheIQO6Fs2e3b+GqRaZcaIgsFh95UsJetzjZXQB1pL7Sh84L1gVhUgmbnWjAlrO6SesQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BzsvPdqzeaBBrprOqhdGvo5/uaF+YUU+becflatS9CA=;
 b=YUZrTJRcUSS8nd3/xzhw/A+0B2fKNvg7qhvvG9ivKlfYgZgM08P5o29rYJ4gvhLXbkqPJ6X7PC25oDmngDaNf2h8Zj0dgP4IGgCGzvIq5ElWLy3SP+CBXLrOcaUss8o5KWOo1fjgjwcUd5jhqFmKyZBTdbQ8M6IjiHvm86eDQ0quz+gpIDd+JLGekec3gH3ty77AiXljWisDvxX70GmVrKtqB3qgPXbRTRbOT2FT2AD2tsj/zYPiaaHWGrSRGXdcQEj1a3itg9Xk4fvIOOaJBr0hmyp9p75BisZlDxZz6qMiuk/0v1Va2ynYHn/9N62LXKEVCrtlcLwWI+xakgFMbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BzsvPdqzeaBBrprOqhdGvo5/uaF+YUU+becflatS9CA=;
 b=j+Ug0Q1cRZnduuBKpV5woWCftShQZuW8yTJdPJYN3Kh9uAYyLPYMKwzxTD4zEyAq9HSpQz3IdmUV8HMAfvnCL7N0hQj5nKFEmcga7EZt4aNLdqiCFoA0BH/XNkSoeZauMg7t739EAcJMz0KFAfAq/UWUuqSFtXxjz2FS6Fi6paMpDGRZVD/y/7sV0CkzsabuuBeriDX6dOY6jX5kwGE+yoLqcmp+NfUz5hYj2YxEwbk2TjreuYIGxADjmISo/tIxFYQyT3ppO/fQROp2HJsSJsjxb0hC8wICl7z+QavTKuIN5aYf9fjEfRIHvaS/W/HZsgTkoaANDLru9Wes1yYw3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA3PR12MB7975.namprd12.prod.outlook.com (2603:10b6:806:320::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 23:31:01 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9520.011; Mon, 19 Jan 2026
 23:31:01 +0000
Date: Mon, 19 Jan 2026 19:30:59 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <joerg.roedel@amd.com>, lkp <lkp@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH 3/3] iommupt: Avoid rewalking during map
Message-ID: <20260119233059.GV1134360@nvidia.com>
References: <0-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
 <3-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
 <BN9PR11MB5276F66B367DA84472817F8B8C8CA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276F66B367DA84472817F8B8C8CA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR03CA0152.namprd03.prod.outlook.com
 (2603:10b6:208:32f::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA3PR12MB7975:EE_
X-MS-Office365-Filtering-Correlation-Id: 2eaeeae5-c346-431b-c495-08de57b2ce25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aEFYT4FC+ADCFaoag3L8N1LUucNiKxG1VJqReRjAPokSDxDriOsl7HvcmtBq?=
 =?us-ascii?Q?05AmYRCyJFGX7W0I5ltpLFkdB6YTTtJvVgY5NjT5vf3DGYE3Nd77BxRzeUhp?=
 =?us-ascii?Q?sLtQ4ZXdbznMGWGM8cV2VV0s53nLea0zxsbO9PTFosc76S6htsOqGsqYOJzJ?=
 =?us-ascii?Q?JPBk39IW6msB6J1wWfYNISUejkBZg4DNVbvvg14lL1FNQPqAWtCVQ37sSl7c?=
 =?us-ascii?Q?XM5AzccHluG4SHx4HMq8X8H75PzHLY9pGqYValinmk6+aJnyT7L2jTHjvt7o?=
 =?us-ascii?Q?+geu04bH6AHvXrzwpFisdTry7QiwSJUcKcuV0vNMBJ4RslUXocmKlHRWRu7X?=
 =?us-ascii?Q?Q1aKEHi7rfvW38IQ3vmVzTs15kL3XGzWqlixXtUHDY6dxBJEsBNaFIqF2WcU?=
 =?us-ascii?Q?5NKt2eG40C8ZaTUz/eTV+DuFI0LrbxMApzVYX/Xil+q8VJ9ENS6Eo2/AysPA?=
 =?us-ascii?Q?NkZwJfIkM+3yV5egrWZs4ILC8VE8xeHJ1shj62var97hBBwDdV8Oy0RHtTzw?=
 =?us-ascii?Q?Ft7IoUFftSbcoCdLr4GMlv1zszOXvDJOdOFUrriQtzDZFOaAOEK+hL8RzO+l?=
 =?us-ascii?Q?Vb7Ms12fru/zglllm4GW1f3Rue88fAzAGaMVp/kOYmP5RmGvQ30EF2fQBMXC?=
 =?us-ascii?Q?WzYDyHNXjw+CBkwIOi6C+rqyqeY0EzGE/QvAqI8nM0RXlrV2y43/x8ngng6e?=
 =?us-ascii?Q?IhdMmn8oc8JLmze4YKsZbR455QML5+VR3VlbQwOz45P75jWCOgKRigrUYAoU?=
 =?us-ascii?Q?R0rhGrhVQAQ73t7Urt8GoFHCduUx6ouX3S8h1hpIAbHv6cxpEe4nL2l123Mr?=
 =?us-ascii?Q?m1EN8r+xSXQNTdDa970gPtProCizbWcvKFlzpJyYFFowRJlW69no6Fck4bb9?=
 =?us-ascii?Q?GCtHLYBeGppdAO3o+YJ4R1RUxegGFdiVtAnCdfpboxAG1IhlypfKkHSSMjUG?=
 =?us-ascii?Q?9yrGamOJJ4ODQSAx632efJIIN3j9rEmHuuOhFl54hnHRJlK4NiYgIZUVSMds?=
 =?us-ascii?Q?TVskpvrSz5rwVQu2J2LQvWP1wFFCUkG8VjjI3hPrV6nPd6XH08U82fHkVvji?=
 =?us-ascii?Q?nw6if0ihXdRj93RckSvt2Y8a0mv5fuK8OBvEuD9eRqnxlVPo+MFsVVMl6e+v?=
 =?us-ascii?Q?x5JEomABFfIDL9xSPhDv68yNzTZ6+DeeLIehXKAgCaGqw84jy6gpkVj1Ab0S?=
 =?us-ascii?Q?fiRfN4aNpM8KbIcrHH69Nu+BstX+CW4Zr0pVkKEWdbxl3xTCkLCJM8ORbaJb?=
 =?us-ascii?Q?HIzLXUnG+C1f5uRTGtkbz2US1VQmoWmSq/Yz84ZXX8rDu0upPtNsI02pNv+H?=
 =?us-ascii?Q?/2pLlczbxTZ9VGBD1Si3bllprfzlnvMu2wq+6g3yGvRoxSC0nDWna7H2Oag+?=
 =?us-ascii?Q?7eM/2BcsLNpsugyc/HDSKQk+ay7YCc1DX3Lvwr9sbqTKGgriMvmzZz3TJ7Lt?=
 =?us-ascii?Q?iDANvWChZxrUbSZ0/SewzDudKLWeCHEfBUzCejmmCqnccSAW4hfu7dxM7FY3?=
 =?us-ascii?Q?TQL1HOaRA5mcfS+hHx2sKJyx5MyXwLrbsLQPaNCQB+4j/Ry6zS+J8pRs26n9?=
 =?us-ascii?Q?vXpevTjmdpuOhbWRCkA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?20IUmt983oShQMDz2hH2JL1bOAaYlre2EPebdQfyhezQrPcYB62RuhYRlyFM?=
 =?us-ascii?Q?PUnVJXiqREkvpYKZSCZX90Es/B4FFs7MM1MwTTDHSLsoZJeVMw02vWr1Q3m6?=
 =?us-ascii?Q?XMhhtCr22IXGHIQJOD5TgsoF4EoMEwt1aeTe02LeytF1J0d9YowiyMcRBMkX?=
 =?us-ascii?Q?DieucG0fMX4noTzFTiogq9hsnGFYhcn8sva/5/QhYDyduSobAH3bkHW8om2u?=
 =?us-ascii?Q?u5D+JZZ2YTkMreObm5txEsPFRW0u2s46fhLPlWpJIVhNtF7/XZyKoSVEABzf?=
 =?us-ascii?Q?f1hklI2IniIBH7URLUD6JzdpwyPe+Gur0yfeAsRBnykGzgbdZ3y2DEHMd0kP?=
 =?us-ascii?Q?VzW6A7ZqSoA/erTxNhvDOlf2gFEyW1KvnKn/Iw2wCWsJzUdUhz3bb/tDHpwP?=
 =?us-ascii?Q?5jy4kYeY0xQt4+iFOWJaqXqsG633vxYmVQWIiTtoKPIS6hCQsCso31NR0e9T?=
 =?us-ascii?Q?Pv0tbeoYtzW4Hu12aSxZyOqULBe5YExPFkoWO+2Di2VhDsIspMMGoUlUKZVu?=
 =?us-ascii?Q?TMeeZs314AP7c9suhrxiwyAgDV4oKMzNMihyonI6N8zSMHGorlR4nw8qMq+s?=
 =?us-ascii?Q?SV8vJGRtDsVrwHxeES5GsO6GetHeSWN81XgsrIr8g4j4s1UWxDGIuovg429j?=
 =?us-ascii?Q?r6piPVs1tEo+bLdcg/09ThwYM3p+Ou+1BqMEuxJziXnnd+OLoIZBhVrtZdh7?=
 =?us-ascii?Q?MSjc7q91kMQGV+0arg+cjT36KfefaoGKFgVx1NObrgXk6FylGAlMoH0tHA3x?=
 =?us-ascii?Q?WTFr5o73nPPIdyKXqEjZoLPqHdbZ4FSoVmFbRWaV41WcyJ2ifO61SvLIUiJ7?=
 =?us-ascii?Q?1gUhLF34hYMUYK2VIUSeeSLtWdf9ItTE5GT1xahXrnQ1cnDTORMrdKocmtmq?=
 =?us-ascii?Q?mFSyl6qBfoKTQ+oY4T0yY0vd7hx4oFWGn1dUQ+n43zcU8eZlQatLCxwGOKe2?=
 =?us-ascii?Q?kEITRrko4/0xur+6zwQOvTr2cznKCjr5D3qXz+fbFdrOGVwN1xH5l8ZI4wS0?=
 =?us-ascii?Q?CaCQQbisUEUkuc1N2C0ZlD/eWg2b6WPSnzhOB2X4WNNGtZJK4SZJhfbVI3j7?=
 =?us-ascii?Q?cERrZjUlg+02ZRqgy0zvqyEzM6e08obD1oRR5QCvAu2ZvpkoYMpwetGE5zhG?=
 =?us-ascii?Q?sqdAQIGfeEP+n6cpPoOP9nJMja2786Fu5xBuxwesLWyQ8bzmI8dFniAVs+VZ?=
 =?us-ascii?Q?zK/36yxsYbylrdeaSD+XueplQnL5Q5p4IALfAP8i+rGehnhOnHnBIrwA5Taa?=
 =?us-ascii?Q?nfkQVb7NPyO7Xco1ZRAVV1scSFAvruwSLWelFuCPFQ0iz63TSwi/5U/c+OE2?=
 =?us-ascii?Q?vRSTLaBCQTd2eayS1jeXOCACWm56S/eiQTN7i8GxkyZCAjmBsiGJA255M5Xi?=
 =?us-ascii?Q?E7ocWH6mJQtFrNwgE5zP8bu/T8NTp9TIkBvU38TIZN04yBNgOIjjwYb30Ca/?=
 =?us-ascii?Q?Puz6oKckmAL21abPRG2kFZ2G7oqgDTp5qxos17AFOc9lt/2ZFQ7j/Eb53iJs?=
 =?us-ascii?Q?cagPbvwNNc9CGfp63SqxVWvO3GEDGA9eqpfo+4zGers1X/wYtf0Hi/C/uNos?=
 =?us-ascii?Q?dX3AhZL1AS0Y075nlw+grPqnCG8wYVGw+SffKIpkOdP/UeSJm6Q40G1OzWAo?=
 =?us-ascii?Q?b82FPaey/Jnmj47N5uy+2ZtijZ3+0+M39la4SwAG0N/5YlqZEOfBHZqKLVBA?=
 =?us-ascii?Q?y0YK9YonPf9y0OHdKc1+0107r60RJX8aqBSJnCF4FDgNcYkpptKxmMkIEMSV?=
 =?us-ascii?Q?8htQnWdklw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eaeeae5-c346-431b-c495-08de57b2ce25
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 23:31:00.9443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b7AK7iXPNimLepi8l5CTlhbJ+JM9zteWZ0oRwW3InP2HNr9VNEFQJIca2hmqFzbI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7975

On Thu, Jan 15, 2026 at 06:44:06AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Monday, January 12, 2026 10:49 PM
> >
> > +int iommu_map_nosync(struct iommu_domain *domain, unsigned long
> > iova,
> > +		phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
> > +{
> > +	struct pt_iommu *pt = iommupt_from_domain(domain);
> > +
> > +	if (pt) {
> > +		size_t mapped = 0;
> > +		int ret;
> > +
> > +		ret = pt->ops->map_range(pt, iova, paddr, size, prot, gfp,
> > +					 &mapped);
> > +		if (ret) {
> > +			iommu_unmap(domain, iova, mapped);
> > +			return ret;
> > +		}
> 
> lack of trace_map() here if succeeds

Ah unmap has the same miss too thanks

Jason

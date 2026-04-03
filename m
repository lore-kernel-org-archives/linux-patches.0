Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012015.outbound.protection.outlook.com [52.101.43.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543042EB87F;
	Fri,  3 Apr 2026 18:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775241369; cv=fail; b=FV1o1pPNe1E6g7FH0dLbcrpLz+fOeQDaBwqCzCWOE/U1k/pGlay4B1z/BuNLss29wE0Zse6LttD1zNCOTK7mDQqabUw5gv4q+x9xF3sR0PV+GPhG2fU5gNIwEyKAP7llepT9llM6kvMcI65HzxeydcLSA+dcji8DH+cQ4+x4BV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775241369; c=relaxed/simple;
	bh=rGnrTFXdwpUyBWXyUH87QobM+ylCcM8Z5PaIrZ9bMNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=js32CHyhgodEH1xiFCSHWlIWrowXBVV3VIBC1daTZHLzGRS1gF6mVo5yQ/Gu2vgioHKqHPyPJajlesGUVdtCmZt2gEYslc23dea33mNIMFR3ZxZHwQwKpf/+tSzt1JOU+q12wKo2zUxQpjT+qVqoz3PD54rw0wljI08m/KtKvuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=boCK2NQm; arc=fail smtp.client-ip=52.101.43.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="boCK2NQm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JdgvJMnua3rdK/pcNA+rxraTPc0/ziLV0ARSkx4T8WZGK3QlfLwZzJIaYa32/NPXqCXcw0ob66EhN3jrUazlOBBHtoH63Z9InlQnGnIvw88s0kjqH5mteMlMXSpBSXqJqGpfXQl5Z4UwLIhjpzkPh6oHpH6VQ4a+ou6oCQF8Ge+Jv2YUeFqvfVBk0oZ1k2GQQCXzWJuIh7g/a3maKpcoJKIXcuu0a+f7iz+7QwOhwtbIbb0xWI2x9lw2oxNvjIo8hNglFgdkGXAJLH7vSejJWdSuxKErzEj9N23O51mJTAQiz+0WT4oKE0a3kxyn5/tMATmsMpa3EMG+XDW+2zgYMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WEggsurnEsoMj1mr/5GFPX0+blnS5J0fG0xUxQCf5ko=;
 b=SQhYsydjz76NYRg/Zo9cz4Jdc+Lz7SkCU+R0DIB1Lmvw3g4SjIj1v2piojC+6MSJg2H3iqoebkjkWkcoi8Q5Jf7SAZLMR1+f0EZCvN26XvB+NdsafVZktcNXObfrtWHmXJLnpVWpeVSmxxvzebPcx2opsrZ5YepPjlFkgORdaNVy56zu2w1SOiapxwfGqDNTbYOysOPqGTtCNQljiEDXLHc8QUfLHZY/ZB3MN9hAHRfouE7Puej92RpiIZPSD0xCC7BcsCgJ+lmsuDqqpFpdKP35ILeUDTl+WP+zGyDuMN3fUP2jhvIjt1FzbZw+91I/8N/UZ7g3gQ4g7Xc1RfsSqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WEggsurnEsoMj1mr/5GFPX0+blnS5J0fG0xUxQCf5ko=;
 b=boCK2NQmPkw48zYDRMYG5Ih+PmDNkcq3yVCxl/G2ZklYRpPL9o1ljCQVsPHfUUDj6CwU8eXa663zb/OM0s3cz5xJ2IW2Deit40G2+EYLhf8dgV1BtIeryXGUE+DJUbMSdxmW4+SEn31XEpnfdga6FPE8i/ybmt49gDT6Ps+o8kdBvTe4QMx6uc81JD3o/Y/cIvlG3SuK2Wh4iotZldPFnZysE/M2OAIDNJCWHKgkPJMVUfhdQKMSrxmgRjRG2/MWeGZMvBo+wsf0rZgXfn+/LBFOzm63d1XsDT/Zktg1ZNZnHEDr4yArGP/B8CDM+gzFgtUdKfX0MGSiPInirqs9AQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by LV3PR12MB9402.namprd12.prod.outlook.com (2603:10b6:408:213::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Fri, 3 Apr
 2026 18:36:03 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%5]) with mapi id 15.20.9769.017; Fri, 3 Apr 2026
 18:36:03 +0000
Date: Fri, 3 Apr 2026 15:36:01 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>, patches@lists.linux.dev
Subject: Re: [PATCH] iommu/dma: Always allow DMA-FQ when iommupt provides the
 iommu_domain
Message-ID: <20260403183601.GK310919@nvidia.com>
References: <0-v1-9901ec033f96+3cc9-iommupt_fq_jgg@nvidia.com>
 <ce5c6be3-0a59-498b-ac0d-eb0dbc1530f6@arm.com>
 <20260401131349.GA310919@nvidia.com>
 <ac-FclRknG4bwipa@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac-FclRknG4bwipa@willie-the-truck>
X-ClientProxiedBy: MN0P221CA0025.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:52a::17) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|LV3PR12MB9402:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d10a91b-5240-458d-bd5d-08de91afdc26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	G/kS99kEf/bBM4puzC1hJbA2wGpqw539DwHiTKgw5zgYnGUci65BPfiDaesTseMzP0nRTvBn8FT2KNXBPBcq5yR6IaZFeQ2t5GQK5cYGmkWKkX/dlSXDMzWcq686d1WMhxd6OY1fsr82QJO3gEmcYH/2itvqgJmQmOak5deDS782eu9ufmZ4VugbdhiZ9rMz6pr23J+oqRiX/cw8WNZhipjUkeVDPRvCFv44hUTxJQGE3Aqa7K+bg8loD9p4XGZrD1R3axGgorOxirvUpHVp9RMASX6jSXTqs3EfR7ZmKsnKU+6H9IJ74CGmWYMm25c+egQuCWmkFwyN39fp0EPBTfkJiGnjEBjbnkw9S/Ja/00AnZJTczKpsLoQhSjqwcms/AeOPAfLb3bYEDHm0zDYcw0mteLccKzWMR0mYsMNeLshjI1y6Fy6Mb7T26flTdvc3KPZf5mv8ePZRfCAzq2qggy1QmPQ9V2acNEVrW6RN9k9fDazvuxdaywMQhf3/DPLkvx9xkyljckc99mYoZr7HRpjpD/eCoJeQZnpePXuVxuj6vMmy4E8Tn9mDHNEm+73YUyr8TLzZcWqvSPWVLn73BvA88GlXhwsHymF4qNnFPOsN9aWG28yZ95DzE5nuthJsm3BMPSNvANJco2llPc56QK5TzbLHTdn1uUJDiMVf7jqmozAmVaMhdWnCWaITBgWIWskq4pl/nOHGWqcp7Qe6bblPMlHI/kSXBPk+suVgVA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DIdDIejqvbdT24fLE0hNGGiN42AUiuLKiblpcEiyKULpUoKje6n+cGe4NOfr?=
 =?us-ascii?Q?f1BtdBbdHVIjtNFL4zevyAhj/Mx1CtSCDLS1MIXOC0PUk5iW7eSYlgnwTevP?=
 =?us-ascii?Q?2G8QaCaQpT1ftOTbUmQt5iXKjoZ7eqQHtToylHSacwQUERayWL+ZqTHDWJCv?=
 =?us-ascii?Q?4R+tl2dJW7zfRtpLUi1PYQOm/x6EKIeyF/HTtbN+hOoM2W2aHw2+ovhhmXgj?=
 =?us-ascii?Q?0BQLpIKiQHUQeIupx0p4Zfm4Nu1KZ8oiCJAqNjpq59wbj5DxAvYjAi5OBuDt?=
 =?us-ascii?Q?hGHiRCcjj8ARBQbsnvI3l7wYxYFXNpFVkNqmjJIW1xjUUalYvjpHNKahMuRn?=
 =?us-ascii?Q?2c5ur6hL+o4pADAZAKzNcEBB8gbRIMxsQVfsCGyCC/l6ZOgjkKol9MuswVBi?=
 =?us-ascii?Q?VUPBN4Z5t38w5+xW/mJMN92JtN9xuS38Zkdp8+I8YGonSDm9XabHCXTgpAP7?=
 =?us-ascii?Q?jSkqOD5MY5et8CYUV0W+ilBF1Z9jdtLtkRcCIAP1Xic3RHFpGplNDgrchB8B?=
 =?us-ascii?Q?pWiTXKgHeu+3m7vCbuh1KNY6odUgoHOP17cl3kAESKIlQDEzFNWcNo/F5y2s?=
 =?us-ascii?Q?3x4cB1AzUd2P6eLOEd6IBCAouIQI5X38LKWsWFi/NM5xEjYIzThNPB4mdOoC?=
 =?us-ascii?Q?2GPS5y/aOcvthLfN5CTD4CdfJr49xfVP4SecOAzi8oX8SdMHM2QtAAskKRJ3?=
 =?us-ascii?Q?e7ithVaAdTm5gISqLS73I7v7vY6qQ/USwpOHO8S1w6mU8XQBKGUKtUJV5OPj?=
 =?us-ascii?Q?cM933IqPlJR3bexjmXRI4DvTcptRaQm89xB/YMXAZ96Ww16ksDPDPqPGsi80?=
 =?us-ascii?Q?J1YgKCqMZhRFnOqtlEGFSpX4Q6PWrNUMP0lI7K96MDYRJ3M7KkXwvXjSOmu+?=
 =?us-ascii?Q?8Sk5T6cqN4zI8hy8MtkaH0RMojyD15+Ulrp/x5B8/q2+BHM1weoCADrAohTc?=
 =?us-ascii?Q?ygvbBaYxJZlahQPIY7gPMWJuzPsjdrujl3UNFO19KFmSw5gIfqgH686MZ1ID?=
 =?us-ascii?Q?z/8VCIlBBePms5UXMcRpd4DVdRyiOAL2lqbrqPKtSnrtj+kTbmqdRP/xmJxx?=
 =?us-ascii?Q?08ZUM8Lh/NOPk91MC5+82+FIu2VzjUQxv8ifzBoyN6m29SJ/vq7q2Xb8J0VW?=
 =?us-ascii?Q?LqGQijKK03Pyb0HVzywWodHF5z2rhXlEa+L0Ca07wAklXMnbhZJ7BHcIZJBv?=
 =?us-ascii?Q?qdnXR/FCRtrgJaYeCi6RCVd2yTCKqCqS30ep/+KojL9Ngel1vMyuHgG513/W?=
 =?us-ascii?Q?qlbB9gDeQLjRKsFXe8G0h6403HODHySeu/n6VpBJdUVdgU70hz1mKx6PCMzw?=
 =?us-ascii?Q?MQ3WoQYTTjdb/fxrzvyyfnd+pgwEDJokPheFcpwHMbtrGC56vOsft5Bq2cUT?=
 =?us-ascii?Q?hdpZLPTXh2YDWB69BXJuByUQeq36aO6UxH3gFeMTjsJwI7p5xb/TZ/Zs5pfe?=
 =?us-ascii?Q?Hq1szQp8IiIzzy4wRaxe7E/LX8dBpuHcxEMw9RkaSn/+3uXjZImZS7got7wU?=
 =?us-ascii?Q?AAbAmpPqiF2f1WOnextcVE6/xJqS5Ux2I2BHwtxO50eyyIpzgDL2zBEDMdc3?=
 =?us-ascii?Q?ZaqlVPE9dMJ7WUuXYY8JG6h+7o8b8Pmag9OOYtGZZtiGVFH4c2yKfvek5sUj?=
 =?us-ascii?Q?UrzuGZ7smLIpJn7a+4wsdOeDBymhYu1kDLFybVXbvXMQ0Sog3qLzqVSLNRUf?=
 =?us-ascii?Q?S2lZtyKnk9s2fOb3LvnwVvGFfimHsRYOGEmF0d0Gv0zUnYEt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d10a91b-5240-458d-bd5d-08de91afdc26
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 18:36:03.4412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NzX4iBD1wEJB2ece8+4INJ14d0SFMub+flKRmnBfV7RrCQDdkZP4zkWYeKMB7Ych
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9402

On Fri, Apr 03, 2026 at 10:16:34AM +0100, Will Deacon wrote:
> On Wed, Apr 01, 2026 at 10:13:49AM -0300, Jason Gunthorpe wrote:
> > On Wed, Apr 01, 2026 at 01:53:05PM +0100, Robin Murphy wrote:
> > > Note that IOMMU_CAP_CACHE_COHERENCY is also arguably a property of
> > > generic_pt, in as much as all its users are default-coherent with
> > > IOMMU_CACHE implied, but again RISC_V doesn't report that where AMD and
> > > Intel do.
> > 
> > Hmm.. Currently generic_pt doesn't have any idea if IOMMU_CACHE is
> > supported and working in HW. All the implemented formats ignore
> > IOMMU_CACHE entirely, they use IOMMU_MMIO to build any any non-caching
> > PTE.
> > 
> > SMMUv3 will be unlike the other three and needs
> > IOMMU_CAP_CACHE_COHERENCY.  IDK if ARM should be writing non-caching
> > PTEs for non-coherent DMA, it doesn't now..
> 
> Sorry, but I'm not sure I follow here. The driver just honours
> IOMMU_CACHE when writing the ptes and dma_info_to_prot() sets that
> according to whether or not the device is coherent. I'd prefer not to
> have the SMMU driver second-guess the DMA API around what is best for
> the endpoint.

The three drivers using iommupt right now only have two kinds of PTE,
cached and non-cached. IOMMU_MMIO selects the non-cached version
otherwise it is always cached. They don't have the idea of a '0'
value.

ARM does, so it has three kinds of PTE for each stage:
 - 0           -> ARM_LPAE_PTE_MEMATTR_NC or ARM_LPAE_MAIR_ATTR_IDX_NC
 - IOMMU_CACHE -> ARM_LPAE_PTE_MEMATTR_FWB_WB/OIWB or ARM_LPAE_MAIR_ATTR_IDX_CACHE
 - IOMMU_MMIO  -> ARM_LPAE_PTE_MEMATTR_DEV or ARM_LPAE_MAIR_ATTR_IDX_DEV

dma_info_to_prot() does make ARM do sensible things, but the other
arches ignore that and write a cachable IOPTE anyhow.

IOMMU_CAP_CACHE_COHERENCY is supposed to mean that IOMMU_CACHE works
fully in HW, so it should not be true if the iommu HW ignores the
cachable PTE.

Jason

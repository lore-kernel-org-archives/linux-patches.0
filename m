Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042CA28642F;
	Tue, 29 Jul 2025 23:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753832492; cv=fail; b=cBb6pzfxmC7B6DBFbpLmuTvpGXB0pRkiT7V5aJC6BWXYLPT3JYzO2XbUUHUoQMo7/4dTrqBS/YqHTTzYYRJOypcAc0kTmNKxyei1LRBR78mv5zB1YRkDewamoiCy0EYjkWUT53NxNWMyrLsVZEenuYYUaGD3m5EWxuFH4uhM9eA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753832492; c=relaxed/simple;
	bh=6SKtu/OZX+knfgJ2jGLdVwA70282u4WHFmmw6UQOJLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EgU7AMa+GF+a7adlPsUnuSbGLExju0NFdo2fmOPLchqTEMqxQ+D9ssRq9Ult5VQ6P/ivATagvj7txiwcM4NKQOmWXm+0XgbC6UKXLcsdo94ZRwXrsq3aFpyx2lenOG1u4dJJ/qfdRp0IWRev9quqCm/QQRf+VfodeWOw2w5JiVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gSNSHAGO; arc=fail smtp.client-ip=40.107.92.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gSNSHAGO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eQqomEXK+e5PI5PZrwijWEronIlZqf7/EYWoV3LFOAOjpr+v3pWdAztEM5CeBkiW9tLOrXkczZe9e5Qha4z/o+6QumTTbBnQ7v2k5PaGl9sj0YDpgzPLmZgcvvVM+8f7GasYFFraV1rEoBrHsIWZgI9gjspOzxKX+OfrqFG1YjQidQyVZxPUtUxpoeR554ikXGVKVFIq7IYiAlFSei4Rpshkcs/Kvy0HPApRD039kwKI8zdZ/rVvsvdPiBwBB77bzxXGr9WiufLcYUMTj8dA7lPeKs+URHX3sI/OKyRaE1AcYl3lyloXSaZiiZWyc0iQW/XMUTQAIhn91sXtQkUORQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fd0mYsa0VG0tqujd7CnntT2xJVKlgweKaEraBBDFu1Q=;
 b=ZCdUKpblc5Ye3G+H85hVnM7pQ3srdM+oqPL4vbqKjE5h4n1aaOKnbUVZ6TtELAmTH8fpiTTD0JhXmxvPzOVX1pe3F5Rm8PX3Ly+JPTQxC11Te6OY3czRfxBWmRB6YcwXtXYhuJDN32BC5pGLVpGpPoUqJzWy8drRbyxooWUts/z19mf2mPgCS4hKnj0xIYP3wELO4zAr+vU2j2XTxG9s8edddkAaeknNS2yyn/nMfpq5yo0M0dIH9aLoDYmOKMVNt+9RG15svMLrwx1/zIQSTzHmKVrvuwzhqs+07wbou+itSkBukpPSZfkO10HaU4yxSqQ5+zyIG/zxu8lPcs9r7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fd0mYsa0VG0tqujd7CnntT2xJVKlgweKaEraBBDFu1Q=;
 b=gSNSHAGOqdZUPt/JJEKaikOONqNfLa1skzT/tfvjvSrqEgcZrObKfcFQMjAbbsKSgivQgRJ7R2Ai6rmD5r6DRd8DRvn5cW/hdnmqikXPpL2XXe8CegjIGM02uIdTBsIa3w79WZy+H3cyveVSYg4GK/BJbfE71dRFl0O6tLCwznKwM1slof8B7rUBK22PFj1XoEefXLvFuBf1OmT6KevPFO/NtR9hS/wHU32Y5sk2Y2dwJDMiKe1ZuwJ6vQj+0mkqzNTmXTZxV3zuWWUIBOEcf9pqza+QRI9hq874XZkxOLJhz/W7661spaonb5NT/ZbFeavoL1kYHSxc75ioggP/7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by BL1PR12MB5972.namprd12.prod.outlook.com (2603:10b6:208:39b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Tue, 29 Jul
 2025 23:41:27 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%7]) with mapi id 15.20.8964.026; Tue, 29 Jul 2025
 23:41:27 +0000
Date: Tue, 29 Jul 2025 20:39:47 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH 8/9] iommu/vt-d: Use the generic iommu page table
Message-ID: <20250729233947.GF82395@nvidia.com>
References: <8-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <e46aeb10-b596-4bb7-8f52-638a07bdbc6f@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e46aeb10-b596-4bb7-8f52-638a07bdbc6f@linux.intel.com>
X-ClientProxiedBy: YT3PR01CA0049.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::30) To MW6PR12MB8663.namprd12.prod.outlook.com
 (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|BL1PR12MB5972:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ba70a62-1e52-4b94-f4fd-08ddcef96fb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bT/QQRZrtgdWxHaa/wcWrb3IQPP+l08KkH5TjcFX+JeXP7iVK7sefUZSGQsP?=
 =?us-ascii?Q?Yijxhz3Wv6uFVeDPyaJijIAexxAw1mco5FvMdf0tVV7ovHkd1XBA+0xXNy32?=
 =?us-ascii?Q?6OBIF8kimL553aRjies2s2tinWldFfjlqJ/+rSEW94GXZ7/hXLcRctioKEVy?=
 =?us-ascii?Q?oOYtVAyBtFtQAGwjZYBL04J/gIfAe8CoA1WgF83tdq9eKEpngMXVlp335srn?=
 =?us-ascii?Q?xa6GOYKj8ByWNhWt8qGZvoh0QtskowhaHTOyg5oWk0TyzTbj6sLv1RR/zJNp?=
 =?us-ascii?Q?TSBXDUEZlhUO18444o/LKMRzI7anRFGeMdQilcNT2YR6EWWrgj4ld9IGB0YY?=
 =?us-ascii?Q?ZdnOwriAcDjCRj72ruTDiziP6G1irVqcQKhQN19yEDmIhwEtVK37jo72pHx6?=
 =?us-ascii?Q?+pCPJnMD2gE3IcV+Maf16AmnqksAJhLcZAE33Wn6fUBH3gMlP7433hVN1DUA?=
 =?us-ascii?Q?n3D1Ka1SpaBtJDbqmKXughLPsyPlXm4htzIY+rgIKH3QsX4A4AavsSAqb2lc?=
 =?us-ascii?Q?5XbF/Nj2NhWC7DjkHqaET46wko0gwI0RuldY0V6l88E9GRrfCa6IvgHYEhSC?=
 =?us-ascii?Q?Q7InX9GXi4ghhERl7JsiHS1H41BVkWBrnj9HFasqkAq4hnP6uJIBN1lvW/73?=
 =?us-ascii?Q?w6h0CflyOq3LxbitY5UxCbpWWt0HkEJqGp4BoOOuNOx0/2Ux1zOxEwsbCI+T?=
 =?us-ascii?Q?6beLOcs1MKEqM/T+FZjAbII6O+ABEjU50/A5Vz1a8P73tsJLYXBRmN9OTBnj?=
 =?us-ascii?Q?FicWwCJ8iv1UTl9GIpPlnqJU/4pmAb5T0esnE9Pj3Z/9NIevqot7BIrWcgPG?=
 =?us-ascii?Q?M8IgvqXAmKlJKAT0XvvqoVvuqseFfBx980oJD/TrO7J8JActAFiPRmoE5rrt?=
 =?us-ascii?Q?/8+d2xj8SjbooXn7DnkwR6dlL9c+jmLBqAy973AnrR/zxrnck1M2Mh3fDa3X?=
 =?us-ascii?Q?RhZZsq1G+qRqbICe8gkDEc31uBNZk9eU9L1wPbKvutRLSHm5tPIJ4/oG8Xz5?=
 =?us-ascii?Q?EKpQn5sfte6maUxO40oI6+Zg96wMAZOuGMkvWg1a5cvDSKtkB0o0y2k38/U1?=
 =?us-ascii?Q?3q//rPcIh4XcNh2/+UCsnZMTVEPVvF8pKFs9BLtnreXw/uLNDr5Sol8TdLn8?=
 =?us-ascii?Q?rfgIdyWcd44zGO+Y3aiZ4saaDyG3U5pB8FD1WcsnZ7CPHapL2IVmrN/V/BP0?=
 =?us-ascii?Q?FV1QmMysks2Pazuvx2gjPoJ2EudSSzQY2Xie7PQvQbXz0zmqxy956b0mKLzm?=
 =?us-ascii?Q?SeOtTqxxGjdcR/yDdT5Vu7iVjK9GF9Z/QwZdfD/Vb5s7WETjMJl17a6xzCp8?=
 =?us-ascii?Q?101RIc3AOXZcR0wp8zf8je2LEE2VFiQpYE+28AJHoYlKhbZ+ZvzC604lzW12?=
 =?us-ascii?Q?rYqDtVmxMkoNldyfSPg4m2ozm+Fq1xFLRsTJC0OAcutW0QCxFMV1lKr9NKbD?=
 =?us-ascii?Q?cXfS+u2vpws=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zOkr56mA4yknW55CuRkg1kE3bf7eUMOwjq1zpzplb4JpNrF3NDjYhe5GUKyh?=
 =?us-ascii?Q?SIVrTcsd+bsCC1K9bZtVITK4Hg5faBg4K6eAVh1Whk+BgmhP1fNzKzzeNJ6t?=
 =?us-ascii?Q?MAqppwyqbjBLd5oiDcoUyO6JiLOUCJo54JewWINQj8fF3tHGe8ZHKcTigddk?=
 =?us-ascii?Q?1ZGJm0CZZuJT6YJtdVeqygjDuCNff8n3D2uXowwpNAKJwKFvXhRtYHBX9dLQ?=
 =?us-ascii?Q?0FFEn4Di185a8d7S+FXZ1b4qUY1gNThXMSb0EZ4EEe+PakxeAPlN9SvV7wUr?=
 =?us-ascii?Q?swAqZUf8+Hhe6+VpveIpQad7hsb3E6N3LOadXKMFjBTYYT2lppwkbg1NsLc0?=
 =?us-ascii?Q?SIWnIyv7vheWZo2FrKSPJvjLq/1OZYcJlwdzBu5RQ+AuNrQYvOg/sFF6XUVJ?=
 =?us-ascii?Q?vOJMeNurh3dwKo2XSMQD5WDZxQBPbBBeqzcKFyObQF8tFwPoHkBIik1C1Unj?=
 =?us-ascii?Q?NXk5fPLRsbVDgelFj5ctX/OXKH8k+PE0hcHh4CEzOBXHxihCP+kKHauwaJ1W?=
 =?us-ascii?Q?N0HikKkIIsGjIONI0IsYYFO6J2DlFul8RAPgjAYVRg7wg5UlFwgfdlBnfAuH?=
 =?us-ascii?Q?Nl/s53UUDFYPywrd4YMwivj1/9TAdq3w4vgfhusaLz8s4FX0B8v/vxzqahp8?=
 =?us-ascii?Q?P6BMZ8/XCPdwfNWWsiQTrcVwiHJpCaLPgCJ6rsAzLSB0g+NgmixW4KSVpeSb?=
 =?us-ascii?Q?ICudzo5Jyora6IkkA9RJYcaODU0MPpBrRKAkAqcOw8a/V5en1aYEShe/vcGP?=
 =?us-ascii?Q?feVd40dGCLzgb43UIkFp9pdziGoebi4Ak8OvHQoDYK5sK7grJMUYBf2Wpr1D?=
 =?us-ascii?Q?Sj5BQgHKYRD0H53PDFW4r5WKX3XZJNDDgrjVgTnWfstwmMqSebiFWY5CvrCl?=
 =?us-ascii?Q?JXspBPlfEwfsmoGp0jTTtpMMxRmL2yjpjyyvPijuYecY9vUPzXLZR1long7q?=
 =?us-ascii?Q?MzHyTL7G96ducGi/eLH7EPRT0k4erpVcxsVN5LDmAv/I3lXxbkp66Mil4bC5?=
 =?us-ascii?Q?yODYEQZeGLQo7UH8OVH/MwL1NaedtPR0Tylcso4+6JCibcGLiAQ0aQ+kp2oO?=
 =?us-ascii?Q?iVFvPX0UkhXrj0uQmyqkFeowPiFF/d1xT4RCWZ2O8q4iLifjwI8m8VsognhB?=
 =?us-ascii?Q?xwwPOpPQlMF7W94NMcTHaoTKClFwMMAwP5g7Tj1KXDontEOBxGBD3m8/+BSx?=
 =?us-ascii?Q?nZUemQGd8KdOTOzoBD4KrYrbew4HVLnckoErZDtUKGy3LxQZnTswMDuk53tT?=
 =?us-ascii?Q?r/FhU+7gOCTi8DNEWN0w9b4z/6paz/4EvFas319KDjTvb2ln8pA2GWeGAl6d?=
 =?us-ascii?Q?AESahUwIYPO3Yoxiw4gBzwUBzUwnC1U18Cvi/HYQ47gkZPTf3BaeQaAM6ZD3?=
 =?us-ascii?Q?LSeNOMblHa15iFVpOZumeTJJyGkgaSRuqG40HjikuH8sqVWidnMeNLMxdVh9?=
 =?us-ascii?Q?hLYB9faMairkLyoSyTrZpbz70hY5CwD1CNDjFuJOZvGAH/1SUOjmxNPByyJ9?=
 =?us-ascii?Q?euoyc+pdq5jvh8eQm7s0bQU8GkCgNN6biWcMiW1ytklPECJV6ohIsbTML6dR?=
 =?us-ascii?Q?82VWOPbwonZe8CmOQhE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ba70a62-1e52-4b94-f4fd-08ddcef96fb0
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 23:41:27.4079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dfjoRKumMNflucLKCAHmQkfauIRWVVm+h+7qRRSl7EOPpqaVyD6VpbePlps4KaDA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5972

On Tue, Jul 22, 2025 at 02:44:01PM +0800, Baolu Lu wrote:
> > +	/* First stage always uses scalable mode */
> > +	if (WARN_ON(!ecap_smpwc(iommu->ecap)))
> > +		return ERR_PTR(-EINVAL);
> 
> I don't follow here. Why WARN_ON and return failure when hardware
> doesn't support a feature?

Oh, that's a rebasing typo, it was supposed to be been replaced with this:

> > +	if (ecap_smpwc(iommu->ecap))
> > +		cfg.common.features |= BIT(PT_FEAT_DMA_INCOHERENT);
> 
> My understanding is that if hardware possibly walks the page table
> incoherently, we need to set up the PT_FEAT_DMA_INCOHERENT feature;
> otherwise, there is no need.

Yes

> If that's correct, perhaps what we need here is:
> 
> 	if (!ecap_smpwc(iommu->ecap))
> 		cfg.common.features |= BIT(PT_FEAT_DMA_INCOHERENT);

Yes, the ! is needed

> > +	if (WARN_ON(!iommu_paging_structure_coherency(iommu)))
> > +		return ERR_PTR(-EINVAL);
> > +	if (!iommu_paging_structure_coherency(iommu))
> > +		cfg.common.features |= BIT(PT_FEAT_DMA_INCOHERENT);
> 
> Similarly here.

Yes, same rebasing mistake

Thanks,
Jason

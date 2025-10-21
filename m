Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010043.outbound.protection.outlook.com [52.101.193.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F96025EFB6;
	Tue, 21 Oct 2025 13:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761055117; cv=fail; b=au0b5Nw/bcUYV2wPNoZaWlkOpDDj59XPrSyNpyBVj7RPNerxEKr1ty/AF4tDBmw1T6uo/agkJV6wnvyZhr0kdPhq3cK9Utc7mZ7Y1Tpv7ILsv/Px3C6aqUPl/QW7DH1fWxaJIs3VfOIlRnhwkwYjRGrY86gtBshP3hURW2rz5/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761055117; c=relaxed/simple;
	bh=GmoDfdNmLUuxBPub6VQxiIqfYrYqH60/NgjOoxp+HR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JWMPC7whD6VkqmpffXFfcLykKrCNXUmauYgNtuH9en/GV5FQXbWGT5JXP9d+PsS9eS6k8VU03qnUhnDq55wDzFP9YutWDAwsE1RVDsK4jOtRZ2q9sFJ0b9MC1LtPDj8d+/Zdie55GsWokiTU7oouOM+x1/yQgmWN6dkbYRkqlgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Oeczg6V0; arc=fail smtp.client-ip=52.101.193.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Oeczg6V0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cQppKlnS+j+IpqMqGGISEg3S6ayfIiqiuSJJHil8SZYC1vYZMrA3LMPTXY3jhSzOG2uBZQ15raapcI034VxnSope1sBJjaimlenlBP768LaImbQ3XqGtTuL3FwOTsL9M5Z4+p9IJKesweh8qrIXAi5NDDcWBboOZPIJEGs0oRmabzD2LgfcmRuiB6J8GqV8OyV0fhdojZrbrV3TVGzO4FX9herL4Sfad9k21GFsClKYWT0Cor5dWN0p3mpC6KLGHGKxTQpa1Hevr6QbTL/eNG+Hu/tzITG7u9clmxq13l+U0KDyr3JgZfrOInzG1ixRTtvX5xL+jcXP+hzgtzeBPiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p8MAl4t3BeTRez+EbVKw2j3SQ/1Q1Y5jgh5/oDuqfaY=;
 b=ylECb7st7OTEGqsPwTOaeqhKUueBsTD08QZpvHFYoQaaHyxy+5JFbTT2Pa1xhifn902IiAuoUSv4G+cQxQFwQ6fgpHe3bxt672t1pIvQNxBIQ2PBfPRXzSiU6pr9q1C49rYCb7iaaq/FJEItbvjCedtWAkkjCpgzui1cMtIKm6lMBrSwrgs7LOkugtiN/7qYBA48G2MJIdCA02Gu6WL4fgw1QtqEA4n25TebXKMu4cH3sLqo/24szo2aHvXu8DLknwzGCE7Z0Dhf4d5uQEKFSXuHNnfx9UvUuO9mdS1ESlbyMdRZr3DU4z2M7rYxEBkARAICzDXzlf1hSwP8w4cY6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p8MAl4t3BeTRez+EbVKw2j3SQ/1Q1Y5jgh5/oDuqfaY=;
 b=Oeczg6V0buKWS2CJrXzsBq88w/+YrBSlhFhmlGgB1RLQhoo3S4PFlyUracheijapkvaEbCvmm38X0PU7f1XjH7IY6mmeKqbrcY5Zd6rGUCBIEvRE6XB75pOvEejBYA5m9TMoqr/28cKIL3axepJcWYAtsEBmqP3Vb0Gta22HYBDn2bFBL4OdTvFniaDx10V5HkSDEK1BvW0KAEdfeerIxTEzJGchNMr7gWx8KMavEGp8elpEgQ1x37rVj3fUde7/kvC9B2eQxrRliRlUadZbDMGY0NwjIutR9xT7A5/64jqzHNKBogcAt4tACthVZofkWeN7IcQKDAOyGkpvKf2Ihg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BN8PR12MB3604.namprd12.prod.outlook.com (2603:10b6:408:45::31)
 by BN7PPF915F74166.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 13:58:31 +0000
Received: from BN8PR12MB3604.namprd12.prod.outlook.com
 ([fe80::9629:2c9f:f386:841f]) by BN8PR12MB3604.namprd12.prod.outlook.com
 ([fe80::9629:2c9f:f386:841f%5]) with mapi id 15.20.9228.015; Tue, 21 Oct 2025
 13:58:31 +0000
Date: Tue, 21 Oct 2025 10:58:30 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Tina Zhang <tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v2 05/10] iommupt: Add the Intel VT-D second stage page
 table format
Message-ID: <20251021135830.GD712833@nvidia.com>
References: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <5-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <BL1PR11MB527167C84F5D5904BD7B22B38CEBA@BL1PR11MB5271.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR11MB527167C84F5D5904BD7B22B38CEBA@BL1PR11MB5271.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR02CA0053.namprd02.prod.outlook.com
 (2603:10b6:207:3d::30) To BN8PR12MB3604.namprd12.prod.outlook.com
 (2603:10b6:408:45::31)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3604:EE_|BN7PPF915F74166:EE_
X-MS-Office365-Filtering-Correlation-Id: dba23b2e-2d56-4460-0b84-08de10a9eb3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q5qqah0RqezSDrVWlTJrr+yLSFm4M8Y3ITuvSz1w/Lnf1EP8jqGJg0EFvoqx?=
 =?us-ascii?Q?d6lnxramuG2TkduCqeO5WTzBrtUe5JOjAhlDdLnGfE1ScCP9otystwge6jpd?=
 =?us-ascii?Q?SNjjDsL9dVGNx7M/5/EHELue1VO8AfznJn/0OxwU/Rwnb4dkKXidWoAYfVmK?=
 =?us-ascii?Q?PTlt/jb8yOD4ohosrWPwBuaShb8ihWAaaqdVQ3XhXjy1KjuZu65c747hDhmI?=
 =?us-ascii?Q?+xwWzTvIgBJjTZ/sMk8jHE/3B2MHFP1Szs1lZX4oZi0NfLQw3T9upm2PU62l?=
 =?us-ascii?Q?jJuP7noyJOyOzmkyL9XIbHeobMkFSo+kIEhxztgqye0bwbH+CfFkHEHEEHWi?=
 =?us-ascii?Q?V5o9Z4F6xwG6L+9rwEfr8nQ/axRguSnlaUCfik7IOhYSIh9MIdFkJTgxuVdf?=
 =?us-ascii?Q?xiqRul4BwhDa/4DizLrYjdnfYajc2dGsvt5LFAB+pRw5aRLl6bXA0hNefynn?=
 =?us-ascii?Q?UZkdB2TwhSEaB9mVfk4FAzprqx6YcAEvJk5v2z9Dir6ZcxDkHg0/esc/46zz?=
 =?us-ascii?Q?GDlizxvxYXiwzsLuNgGsCbrQtwigcgiiiZ5m5lwrhLPMxnT6rlE51B+6yp9b?=
 =?us-ascii?Q?pWGvl2wzd+L75mV07m82xBZUT/ZM3nGiVADhN4oBRkTMnGfn7vd+LNmisfdi?=
 =?us-ascii?Q?PGUMZalur6NJRhqbtSgV+rnGWXuhoLGPWgd5K7C/bevoMUjUso+Ofn/sp+S0?=
 =?us-ascii?Q?wKdwBID4ctlv4CRqhPIL2FB56RDSWqGXbaAhGx4eT1srlIQJgDOEPoVWQ3Co?=
 =?us-ascii?Q?QdLhJtqu7+z+dXKf+hmIDW+hp17w3KmOgOQaSkTlIF0s4FoVIseUBgrMmtuy?=
 =?us-ascii?Q?MtR5VZYd5Afmll/MKoafzeYPGDMkCNRDtyNN3NIoJVN+4OldqlUvd9qYoZqX?=
 =?us-ascii?Q?RrT8LX7NBzJ4zqAmYgDR6xBIGHMUy6DCm13xrWrgd/MUWEliqchM+SGWtf3r?=
 =?us-ascii?Q?bGdixHzFMe6lWDwCmUU8Sufl9iJAW3KFNA/VEkOgPoFlUFTNc8FQI/nW0SjV?=
 =?us-ascii?Q?A3tPmGFIh00T83vqGOrmlbMYuyqm4GyLKtzD6ixJMog+ZMnq5M2kltTOVKak?=
 =?us-ascii?Q?pFqJK5VCyZs4EoUi2NXkX2752Me8lToFMGXZoLWek1ftih3kpt8CkK/97rEa?=
 =?us-ascii?Q?qTwJqHjXsxUIOtxI/xuAvZct+wLzHCdBMkyTkBQcc+heFr7rEkORv0wXvfgS?=
 =?us-ascii?Q?cYp69NLzMTK7ZXmTt/KiKmijbSc5EyzCRz1/vTwgmu0RAfPlhFj1GeN+/gd/?=
 =?us-ascii?Q?HD2KHeTRnwYvpetOqV66/vDiVmKIN5FX0gfY99W6BrA7R0IxavZ1ajbT1VmN?=
 =?us-ascii?Q?I4ChHCwLAO7L7tlX7KpnQvPpj6SULSw041ItfCoH9HpmlJ6uO0jbFSL+B9Vg?=
 =?us-ascii?Q?n2Ly7oeMVHoyIwHzSZFRNY3e9DomuCu00QpGWoeZNFZDSD2W0NTMaWEWmzFG?=
 =?us-ascii?Q?/cbPaBiJP59rxkXqLCYOiq5uryrjVIcf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3604.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gnAIINCkH3yAVEmjkFYmdazq2/NiraIX5gDHR2U0dFU5Y04pDFHMEh5D7A7z?=
 =?us-ascii?Q?913mgTjtiIrlF79fSsuBORmTtfwmABD4hfzHl8uzqhSnci5NBpQ/EfRVZkY0?=
 =?us-ascii?Q?qTD78Lk0elzqQmUVZNoRcg+O3sNiPIxYxb4mXOby28BDtL44YyRkk1/hn02u?=
 =?us-ascii?Q?0MCyLdP7AZlAxLGJkNdkL1qg8oxEVFbodGWnhb79qx+Pe8UBr0whyS55LxRG?=
 =?us-ascii?Q?jZTX8IvpII9NkNG19zXGgEwG1hCEwdgLY2hbxHtcOjDrtWVsqLYPnU40/eH4?=
 =?us-ascii?Q?//PxkBcNpzgyhDNxFDuXH98yMJY5WK5+nzfPJ7PSLsJLQbG1eB3yDTFyDgJ3?=
 =?us-ascii?Q?ymq0Oe0+Sp8S8HOicW1S6vd5ks+UUamuU/8nkfEqcVD43r45xazkAocJtZnc?=
 =?us-ascii?Q?tZ9xe8TBDCKhGUVI6SzoMtArl3wNk9iPrmt/qzuDrRx9doITDL5OAu0zmmro?=
 =?us-ascii?Q?0QgWEqIp5TUiXLs9MKglWd59SKjusbSiPBwALVxXlE71dsR29d2ri5nv0zCQ?=
 =?us-ascii?Q?m/2r+y/Pvm6+iBLMLb07KRXf7vpDydzyXYB5x5YWnc94beg8JwVC9xokHepH?=
 =?us-ascii?Q?n3w2VutBznC7VWZlFGEz2TSB/3p+j3pogHrnISXQ/aAlaFwDH6jBdDDcIPNP?=
 =?us-ascii?Q?dAT9JlhnObvq65DwKFqhHOrfMN6uvecBboEq1QgoPKEKOsA2BPR8WVhZU2eb?=
 =?us-ascii?Q?2D5th/27oZfgESfs3wYZMkSySi7s9IZ+aSgTqyd5fmFv3PsPC7LoVdZxxklq?=
 =?us-ascii?Q?13nrpmrjJZK0x7DJwUI5b2JJmIIiUegzQB8oUN0g2YaxgoY6EGYJY5MwpiLO?=
 =?us-ascii?Q?1Vb3EzPQCOzvjPHMXe20UwrIciE0iuv0PrI3rffG0yeHF3w+pNtZc+D7jU2i?=
 =?us-ascii?Q?BAtJ3CdWKRHwQ+Cal8+v+JGUgw5t6B/vRe8oRZUUvKi4KdpoV/lQY9P+mwdu?=
 =?us-ascii?Q?l6Y+1dQSmG9z6kf3bB5yL3v5KelyQIth1nFZsJDPiNQUs4WH2zkrjypdDkzV?=
 =?us-ascii?Q?FYS1ofigaRGHZR69rvUR9ZqjgRrisNf+hOUoeZ7xXYO0EpZeOqE/V0CoSHbl?=
 =?us-ascii?Q?aP0IOJXFHO+nj/swqv4ubcog9eV/50D3v8ekKr8UXoFxRQEhq4BMX1B9VOS3?=
 =?us-ascii?Q?D14R7moa0sksUnSVKcF5Ck/Dpvmmg1WApnRpWL7O/c9gni3W/cfhtUSylvBv?=
 =?us-ascii?Q?DPF4u+104daxQBF1h9GGZEAWnXhemhxAIhg5is5rWxOpOERZY4wbI0a6/PSW?=
 =?us-ascii?Q?10zk/uPoswGCMuXSV9kTdPGJWfYSsnrqZpIsqZuKNgULoc+Vs0Kg7Ijlvyis?=
 =?us-ascii?Q?mzTRQMu+Q5ZHeXpW492oLQwyCTiJhX+wmMFk+i5X/mSjdQGHcc3C1WhqF8y/?=
 =?us-ascii?Q?uQObiMbgThaRFAA2K0hLHhupWQTyG1NtbyT1YjFQ8t7rLK/Ma+4Uf/wTBQyi?=
 =?us-ascii?Q?/HDvE8dkYTtmHyVZMlVeS6ZzQNmRQ7Qe1Q22BS1j/Ep4tjAy7zckE03qRYWd?=
 =?us-ascii?Q?/DHgtdlr/7meYBxeh+YBCgCQ33XPW2NxiDR2oW5Cieba4ruo3mvKtLc3UPGk?=
 =?us-ascii?Q?Q0SzyoGtlZ/Jo+65ddavJWISTR8HIPXW/oBLrymp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dba23b2e-2d56-4460-0b84-08de10a9eb3d
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3604.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 13:58:31.7165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6mAEzbMMg2N5UzpEBSjU56I1BB5jj/CBtk326RML8iFj8qaGf83hVc7RSWZMJ12b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF915F74166

On Tue, Oct 14, 2025 at 07:54:38AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, August 27, 2025 1:26 AM
> > 
> > +config IOMMU_PT_VTDSS
> > +       tristate "IOMMU page table for Intel VT-D IOMMU Second Stage"
> > +	depends on !GENERIC_ATOMIC64 # for cmpxchg64
> > +	help
> > +	  iommu_domain implementation for the Intel VT-D IOMMU's 64 bit
> > 3/4/5
> 
> s/VT-D IOMMU/VT-d/

I fixed a bunch of cases like this

Thanks,
Jason

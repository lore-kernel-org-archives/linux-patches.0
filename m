Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36FE291C1F;
	Fri, 22 Aug 2025 14:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755874520; cv=fail; b=W5T+jVg4W53vThwWO7p1Cmilg1U1K9TXeEdRmRs43sYTcgOXlpiFnbfnTfriryTm48N2irN0cRcX6n+OM0q8Emjiqj/aemOMRQVby6Nvn0H7C2ngDnQXttSPhHRHylF8LAiUEC2WmQRpMDCmC+tCW6PUGrnQRi/UIfL15EY9Ho4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755874520; c=relaxed/simple;
	bh=Cn64/0j/hvjJodCmQRJSJc784ZViSzWoqKQEIm+8Cds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Jg6XDYJgL1Ea+m2wLMIZZvTK3rAddzzs0ar0quyZFRoje8f1uBy6U5xcBYJsr8g55u7PDD1um+qG4rKjKVQ2jOotSVpOqIDaydNXg8athkXFLzg80RcVeX72EvH7lwJDVv+hjM6BDvKbMwsJ0Ouezm7FedeLGReVg4UefY7IFdo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qUUzqPqV; arc=fail smtp.client-ip=40.107.237.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qUUzqPqV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CJN6JEr3Sz5rJlKUXuz5pCblxMNJYElq2cLhbDXrzgHLadrqo5oQY8LffP3GrDGSIK9hbF7idNXVIS16XFLFQpBzZ/F37TqhhrkOk2On8jYKzPZ5wClIRcp7pOAvQSGI8DOhi+XpwoSXwNs82PkT9LMcg4Yd3l3pxAgFymXWSla9eU/4M4wH01xXqIwd0iqM0vQGTMSs7KQS+K8KrOyvu+ssQNKnAE9x8yFjJGpqKe59Sah10ccrbdNr5XhhS8ACBPXXdiEoVSKiE9AuKs+GroLNT5eje0XUQ/LTn80TMQDR7+MiXDYuUSSC8U5smao/9vfsn3ofVNWt+uzpj6NBUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AO67CTM0QIs6AfSMHAPAEk+yxAcuJV8KYQEcXGIedCA=;
 b=U+kId8t0LV3Eub80pJO4xnqljZJPPqsRZoH136nHpDEm5WjrhARx5P7GB+byCdhQXx/nsEXqozYmxtmKpRm/pxkjXPzfYoTHaMSRcgtwXIhZzi0Uo8uWxwXr7FEz7XCwDhoNPGPzYz/frUQ5Lka7kTLOX0EVF0NwrvtJC2KjsrE6KK2kzsVTMYfBb0HfsGqfAINBgEZtu0upkUW2CJttXKyXkfLvX07KTjB868BzwAz/gaOQfkUSjpng8ylUKti7sCCEXYzoQoPdQ76bG8gBQmroKlNsK39dBO5w+wL+eDycfHH3rkSzCrXKn5xkQBvc6SLDy9yTgHzbin3ri/g+6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AO67CTM0QIs6AfSMHAPAEk+yxAcuJV8KYQEcXGIedCA=;
 b=qUUzqPqVYdWfCXII3tdMfs+gEwufU4dk/O9YK1axWLm3KtSjXhPgACyP8zs3fn2qLQUF4YBjzVcmZWO8p6Mr+bKGMmUOafm9SkuMSpc4xxcM76o79Do38zm5BvbT9KajJMyu3YyazKu5Pd020riRfEYckT+ILcuESm24X1UbeemwHek1QQFJsLhiVX67NIB22nJzitQkYhVCKKhCN1obzp0SkbuTLhGQSSORos8SHz+EK+278W4kfXiizUeRCM3hlDIBVJoJTzVJKue0cLRBiiXEg1HxNR6cvKRo0xp0GBwjQZuHnxvrMb3E4RxPfy6nKZ59OZqmJU3f9iVXS/M0kw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS5PPFDBFC954F7.namprd12.prod.outlook.com (2603:10b6:f:fc00::664) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Fri, 22 Aug
 2025 14:55:12 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 14:55:12 +0000
Date: Fri, 22 Aug 2025 11:55:10 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Tina Zhang <tina.zhang@intel.com>,
	"Wang, Wei W" <wei.w.wang@intel.com>
Subject: Re: [PATCH 7/9] iommupt/x86: Support SW bits and permit
 PT_FEAT_DMA_INCOHERENT
Message-ID: <20250822145510.GB1405994@nvidia.com>
References: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <7-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <BN9PR11MB5276C6E52E069F5E2D608CEE8C3DA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276C6E52E069F5E2D608CEE8C3DA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0214.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::9) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS5PPFDBFC954F7:EE_
X-MS-Office365-Filtering-Correlation-Id: fa64230d-48a8-462a-c14e-08dde18be552
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?623EZcQKfekkhGRjPkK6GzKYud73D80id35rBGPYmZdoM3z76u6S6tnPmoBB?=
 =?us-ascii?Q?HaZkoWMv6IJR+DGfoX+6EUY6d6WIQ9ZAFZrpm3Jp2zFHbxKqHZglkmqqAail?=
 =?us-ascii?Q?A6RDMXvLhgwIyPHK37RsvdFyhJX6IpBiuO1kJ0Ad4UGizZLoCTIpiRouD3+q?=
 =?us-ascii?Q?GGHlrU/Q9Sgu1CiMbU+mtji5UdeQYM79GTr/UX2Sr0LNxrZv49WXrTy37Gg9?=
 =?us-ascii?Q?QRxmV3PJUYjT+Y/bxCCpSZnE5rw8JrcnbUvusC/Y4BRwjTiJ9pxwlHSP2ZN6?=
 =?us-ascii?Q?aGsOwJy0Rb1a1SdZpbPNILQBN3HwBOI1TdNbcwN8zd/erC7v5jl47+0pU8Bk?=
 =?us-ascii?Q?Zu1l2Txg4Bu0M1HLTB076DSY9/FrIQ0rvD9mpT0WPEOWYuMwxHu7ypvnQgQZ?=
 =?us-ascii?Q?e490wyo4T9yJflUkQcOx8QRTcpRcMML9tIYgdhaviWR09Oks7Mi1mHymUC+L?=
 =?us-ascii?Q?zkVC3y6b/ia5/d6bI9QRY4fpI+1+t/FVX8bR9UZOTSeGFl/4KmPfmCVNV1ZU?=
 =?us-ascii?Q?R7BWHt1LXv9NFeSLGy3cc1C3LWJhXRa5lYairbgbZjyGJ5uEZphrKmDI4S7o?=
 =?us-ascii?Q?puFNSDdF9k+DTXZMWeuFsAiK74bS5S05PNDchDymCZgd9UGlG+oK9ipNIBPB?=
 =?us-ascii?Q?dQBietTBFrJadrt6E8eeJAQ3POt8acpU1IjvCpQEydxLLZyNlHcs+n8temEr?=
 =?us-ascii?Q?8BfBC8n8ahEW+INmlJnWBOugJQDyrocRFlVlPG6K5nkpAyVePRvhQtDmAdF4?=
 =?us-ascii?Q?DwIe1nNolk7JutFBJO255Owz6BR/VPgHBprdaP9tNJ7GcqXNxNBc75nCtcv3?=
 =?us-ascii?Q?BHHnaySjqVbnBRv2n9dWYRabhgoJmY83xbMcoKgj6koIaGgVClLikGMak2we?=
 =?us-ascii?Q?KeQDLwdhzJ6QkygkVIuS7U6aYG8pEwzubrRr5MvNxf2wBn8O17QB4QPeYynW?=
 =?us-ascii?Q?guEsiRcAoe7PAQXhS0V51y3k/BKzOuwizDjhrdZgS853j5c/B0vjaXB746ZJ?=
 =?us-ascii?Q?CncH14yajHbM+N3AoLFkfrwM/0KZZUHvosWRvCv7zsnUJeF+xZIPHVZ5g/4a?=
 =?us-ascii?Q?VH8jJu7k5gsv4eI5tE02LSNfU9VivKx5GCfyZLmmNT69i5LiqW56doppDaEx?=
 =?us-ascii?Q?OFXX8X3594/o1aHQttVCbrHs5goui+0/bxcjHFUpinbw/BJEa3w3/ECZ2A39?=
 =?us-ascii?Q?5dJ9VdUpQcDx/T0xIAQC63atlUCSW9jLcSmQH2Fssvl1PNGARc8wJzBCxipA?=
 =?us-ascii?Q?2JusoTls8Me6YZL+hRMRltHUn6SyQLyzqr+QFDyPEZnVdQsf6biOS7yFXkYh?=
 =?us-ascii?Q?AXsGmuYDyHrR1v83qEtU715olrTEzQjd2/XTbDecgqkdGJBAPO55yrdZivS5?=
 =?us-ascii?Q?LBvXyUuvgwZKo6yovZzeCrxcKSssyaJogMJRpRe8NslwOMO4JA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2DHpzPByLIzWRljOGXJDsc16iYOXpxISUHFHwIAubLtVImMuZwq24XuEtP2Y?=
 =?us-ascii?Q?AQeFNjbHZz1U0yut2EykKgaZS989uta8mSrJrx77Vo1W/F9mWvjOJ9hee2uX?=
 =?us-ascii?Q?HReWKPosvbftP1ZajhAngzHsxX3w6mhR9Uaii750c5p6GqjoKomn7OiSQWQR?=
 =?us-ascii?Q?2WeSW8uJiSr0wAsfy06TGG6lgQSakHhnaKO31GI5jHDMXd9VJ2LEKh4dlH+Q?=
 =?us-ascii?Q?1NHPJzMJrDvMH8HRX/sO5/v0AB4OCjVjFNgsva05YT3txe5dDQAncoceiSy0?=
 =?us-ascii?Q?OrCaVuH2H/P6cef9J6DqzY8qrxLHO2whYUk//EOWoNpt75p2oNINnYUJRs0P?=
 =?us-ascii?Q?DOj26bl8XlJfzU1rHi5Mj96CiQQyFFkJBDonydHxtqMJXlAxZ5E3sqXIMKTP?=
 =?us-ascii?Q?uy4aqheatygkiVYkQcnfClmQw51eX90JaA7moXT29SvcQIJSaxakwofaaSam?=
 =?us-ascii?Q?9oBEAx4V5fP/HBqmi6z5GvwxqDfRWnopGAN4m2hWPAtqA/I5CZwssBqKlM5Y?=
 =?us-ascii?Q?zWYU9ZAEkUoApVgGmlsG6GHsq0Tf/6ZjBP2XXT1DFSSWl3ZfqhrAKVi8oDjk?=
 =?us-ascii?Q?g+cQvlAVeogLMrkdkhWEVL9qMs1EeE6vQtDGIP6q32YVsmxCdAEN75CYE9dz?=
 =?us-ascii?Q?OCNjHNB1LUiB5gOlKeP8AeLLTFt5LyO/iJY9Cbx2H3RO9452J1ZDtd7um+Cp?=
 =?us-ascii?Q?TD8aCuwC/SKMgduUontUO5RCWNgFXIjR9M2nFghoI8l63QkzIVDjTiwXorr1?=
 =?us-ascii?Q?x8pIwQc0BZe/SMgUk94cCig8XKEBDnPfE423OOvbtdAufflzcgLAkTwx7x/y?=
 =?us-ascii?Q?GSK79BKU1EfxQnXTEyIBrI7Y8g8TpmzAKlaTR+jSjsAHkL/3gTlrec3ZXd7y?=
 =?us-ascii?Q?IMRzwbcG7EnYHBp6TY1Pru188s3X+94CH/tI1tq15ynX4iONQmOfsu0L2Dlz?=
 =?us-ascii?Q?DbdY2a3aU+hCAmxz4Q6cfh/9RZatC4cG7ZeA3/70Nm5/JMe5Xyd6nn4qN4nw?=
 =?us-ascii?Q?f1AXxL89yfzY5izTxbS2l85vRzb9FNDB4k+cw08uK397Z8Uy+7ZyXyI3ACK+?=
 =?us-ascii?Q?V8hi4GhcW+j9/V1D+5XpdugVIU2uNikbvASj6cg+BXtT7D23Wl1sbfaCwkQ/?=
 =?us-ascii?Q?qqGIrqX0n8sJKNCyqcBQVzGMxQX/7dq8zVirSzmwsQ4IXUjixlaAIpGjvvuI?=
 =?us-ascii?Q?nWZsxY4EAMet/PzpbPwclAlA99OjXhWRh2frhO0nWjR5N9oLpiLGCamJelph?=
 =?us-ascii?Q?cA3wu3XBoYTJXRVKB/xgSHcRgsAIz6A5o3huElr4D767SJWNnFd3cA2SaDtU?=
 =?us-ascii?Q?Vo5nUYE6FZEeFL8PSDLP3PmMmw7FXOQcC724Zk+GQ1OT3TX7Y7ugPw3Qrwps?=
 =?us-ascii?Q?2gBmuyrBb4kLwYZ8OWIImh4p7TnQfQ44bAbnO51QXrt21OFKO7zXv6lUeRX7?=
 =?us-ascii?Q?swMeAUdCm+UjCPo+t2BIycGDILigse5By1V27BWPYtUmozyQ8RG6w6/wLWGO?=
 =?us-ascii?Q?vfjCOynONLIHHA/sTUFYEVQEsis60ms5r3Tmg8eOgLqGGQRDzqr2gaoXt7br?=
 =?us-ascii?Q?QMjPLwfsKzytxMJDR1tiXV6SxdVZEEW/VOaxY9oy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa64230d-48a8-462a-c14e-08dde18be552
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 14:55:12.3282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7UxK472hpXpFJrP2jHPeU3xukhr5XVPPEfeTJVgeb0ejTTdEpFnoQIBwuQbNRvX7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFDBFC954F7

On Fri, Aug 22, 2025 at 09:17:32AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, July 17, 2025 3:58 AM
> > +static inline u64 x86_64_pt_sw_bit(unsigned int bitnr)
> > +{
> > +	/* Bits marked Ignored/AVL in the specification */
> > +	switch (bitnr) {
> > +	case 0:
> > +		return BIT(9);
> > +	case 1:
> > +		return BIT(11);
> > +	case 2 ... 12:
> > +		return BIT_ULL((bitnr - 2) + 52);
> > +	/* Remaing bits 9-8,6,4,3  are only available in some entries */
> 
> s/Remaing/Remaining/
> 
> bit9 is available bit in all entries. As commented in last patch, I'd probably
> just remove this line.

How about:

	/* Some bits in 8,6,4,3 are available in some entries */

Jason

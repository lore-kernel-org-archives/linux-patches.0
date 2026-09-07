Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010047.outbound.protection.outlook.com [52.101.56.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D896650AC04;
	Mon,  7 Sep 2026 15:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788795283; cv=fail; b=UdJym7r0W25LGXNKeBCSkquVXemF1EskWqqxLp8HT3ykq/YIDWTu50XWvbHm3GDoSuzxotZRbPM0aO0wHmwZk97V6wZoEK3c64f62Fm9AjVQ1aoulNYEwsfiUp7QyFHTUQGyENNgqhgqcwxwzIzzp2DS7LnBdQwfrQ2nzxNCyaY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788795283; c=relaxed/simple;
	bh=SoWMgChI5QA/y9axYBODiiAQdaRb2saRnlhVcApBCfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PmL50cbQhQT9k2a/gRQt7UI2F5SNmk9chGlUULPrQ3RI8ZCIUWsqnj7MMmfS+ug6vTsAhzML2sjKlqyhlHrUVWKB5SrHFNrSpnPjmQ+4GspND/cWKH9ht2MpWNmHxsrvYkomJ1bkYb1EOhQ74A7FWCP8g7kVKb1dKXeSV1CbIzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=U5EObEmd; arc=fail smtp.client-ip=52.101.56.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="U5EObEmd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vf3crgisImaa7co2rngKAp/ubVBQUhB9Ezn4s91dKkseUk9eNgjG8qPGwLVIpo7TqsL2JDCs1NodPetQHVXaPRCcySfqfLTwWuhSl4+wJmRz32HHjYdUJBldMT/qBnVQtgR98Qp6hhuhz1drWNFp7qdBumOAeQNBWJc3O9r/cSoFtRDkRdbPvxk5B/pGy4Iz8vfrWbl6OmX6G/KehCgHTHUf89rgk3iJrKl5bx2PKGKwAgh/ut/9IKrdHRk4TCn+2f05l4ictE9vhxGfNzBRd4KyU2BkakeKVHSasibGQWkpRqkeeDpe9cyG96bQtSJ5oAyboG2MdzFWWfo2357Zeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XqWXRpRi/Ejp14Z9GiU1Aecj0wkvkpZIwKL5GOg6ahs=;
 b=r1kdEDUOH6lZq+9OpVNJbPd8XoiTSKo6CbcU2aK+mxF9HO7jvAtrEo8/VQN/+uFbQoDnwmw2njjdF5JtbLIo4HCA02hxKFWJxzMolOM7Xe1fTAKhaAE3kP56oOuUR2s88JE8d7WZ3PM0t9bv6szi8Qp9NNbsk+GOLuvX74h+08Tn38sGO3zH7Y6xMnyDJKymn4vH3vd3qkvEsiDDPklH0MYRfuaVhEZD1ogvCY8jZLDtmSwLa9RqIl5XhFNLc9MbkaZTrUG88vBP77MeJeF/x6vGKwYiGxd0KZ8gBvmU0lY6igebPL3hZejGlAw5ZbdKLVLbIAAhcpD01GRST7MYLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XqWXRpRi/Ejp14Z9GiU1Aecj0wkvkpZIwKL5GOg6ahs=;
 b=U5EObEmdVP5xfO+hg0//3fNpa3ORm8X4Jjf5z16xnIM4cHZyQY12Isq0XFZik+cBpR/m3vV02VIjIYAyjNkCWfYrpdmgNRJAHwzAh9XUF7Lrhz3H1XyT3Zh0652JfVWuDZasKl4OHVTs+dseQp9hQ0hycdGy2fQYb6g1bPACyIHlx7H0fyQ74+1qgt8pub5/2NLsc2XMw3WbrgDB7hTL8SE6y+qXT74Z1I13K4I68ZDtzEDmpU8bwP/7mb+erP1CDV675a78MsaC3RNTXbDqoZGcaJCYY07nQxO07OyL+wTDZhug5Bjq+FqOjV9IjC5Y30KgBHSsNh5c8xYgz6zwQQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH2PR12MB4103.namprd12.prod.outlook.com (2603:10b6:610:7e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 7 Sep
 2026 15:34:31 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 15:34:30 +0000
Date: Mon, 7 Sep 2026 12:34:29 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v5 8/9] iommu/arm-smmu-v3: Change how the tlbi describes
 the invalidation
Message-ID: <20260907153429.GB4157646@nvidia.com>
References: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
 <8-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
 <ap7NcebXzWC38VVo@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap7NcebXzWC38VVo@google.com>
X-ClientProxiedBy: YT3PR01CA0138.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::25) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH2PR12MB4103:EE_
X-MS-Office365-Filtering-Correlation-Id: f727e61c-e1e5-45e8-e46a-08df0cf5827f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|6133799003|3023799007|4143699003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	F8pKmLbvzwQWYslfjr3ZDVtv+TAoNg4FN7HwrDDJP3sUdva0tesBt0v+6HqTPPHsOtMCDinuMMPMJomzPsGh8nyJsbbIkATQE6gHKUzlDZlKsSvNqgNftr6fFy3WbMbRYE0TQWqwC35g6AyUWl+wa+HjXDsdEK9usOvmV94xkIBn30NDsKjflFoPbVZqSQSg53nOPMPrgHZhur4A0rNTmNShrcHAZ2qwakUDtAffR+PB+JGsKhPrHh+8aqbUvD9mgs5DsemDeHA5A8tDTkqUweThtWfmrTo3f+ubRPbv5PWLIFNOsADAtbc97xyDSdydfrZjOEHwsrtp30BGn5fcbiZr3HM/3QExUrvelGDM99eNt8AhO/8WpjPjfiNT1/5NJ007QYNjfLKaf+gPM22uNspMIjKA7ZEiGWzM/OdrA5bhiNDAeT8kH5zZvZ2RmOeoBmXkjllnYsoJkk25zcMmCuQpya/lYGaCzK6pTpXkkjSfgo/OsgVOW5BxrY6+OPxatQw3MTWLNhkPs35CH4vHhRzRFA68Cy3N5L/vspGHf/l/8HV2LcYzHE7ugtrrwll8PhUmsZoVvFjj1d4y3LLW50Tabp9DuTknaSDocYubST9J2vub6xvr+p64nYA14fJ61p3HbysCwX0uBY9Hl8tHBQ2Cf08DGFT5v30AMtSQhHQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(6133799003)(3023799007)(4143699003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2XAFQVigC9xc1Qlc2qdFvFVdOZITHscW+8HWlnTloQyWfNHkFcMRq7PLTEss?=
 =?us-ascii?Q?ZYncekVXkyZ8GIirT+1AjO6AQbYkJhLb9zxjR/aHl5WdvnNc+eBaRYyPEa+U?=
 =?us-ascii?Q?viguJEmWu1jqQWqplZ4GDXchJkzmGcBi+E0o8tKs6pExLzbrQy9ehGhseFb5?=
 =?us-ascii?Q?WjUAHOis+TBR0VyUkCDaQ08o47AA3vSfUWfdoAYCkGO22iTpAfeCOPh5kCGL?=
 =?us-ascii?Q?l9wQVGGFEndDKvdpAhL13UReY3zCmlr29uelFEKUwpDkxKNozRwO7DNIj9gS?=
 =?us-ascii?Q?VwErc9KltW88eIEvDBvBMwSkwLz6owjWnbTHRPeAYBCwYMY9Y7Oye9WiEGYI?=
 =?us-ascii?Q?+oJGCynOxcPiGYXEF0BRQEIcBrquxJp9AunQ/F0cMPhMw5K1JwAte6n2p3oe?=
 =?us-ascii?Q?uHIHfHRt/XuEFXrwYdCkHCnSnKw3NX0rswkk3k1IKqMatYPT+4vhK6Uk9L2A?=
 =?us-ascii?Q?Fx4YQ4SnBGSOENPLvd5Yo1X6GofPDTuCnDUDKzZSKlZYM2HXVtKz/Lk1tc8H?=
 =?us-ascii?Q?+q/hASTpuV/r2OKh8qQt2qhQPesNk6HcvgW2r9QiCbF1FUSG+hvRWNZanyDL?=
 =?us-ascii?Q?/jnaNIYdK8lAPMrixiQLmCLJS1uT+TKIgrMByd/a0upqSyCuxtQQ5Y1JakDx?=
 =?us-ascii?Q?F46NN3UdDIxaSUIaOqbMfyYOlNp/PEPIVdr2ZWMwKQ2aZmkS84lfYtjdjjnI?=
 =?us-ascii?Q?S1PmIRe5bC8StEpmyV8DbVOWHpLrpYvsTKydaZDqGc7EP5bwF0iBFvFPrpRk?=
 =?us-ascii?Q?u7mLAY2CmPZhF3dEHVSVQLbKeF4Ek+hOxfsEXjAxMG7oGwfA0euGUbbsgCmF?=
 =?us-ascii?Q?SHSaeHjskm9Qi2l7idgpfzZaHz0mQzepWab1Dqiz1y+K5nG1qX+83SiMMrMy?=
 =?us-ascii?Q?Igf/Kv4hS7YQ90Jcbw6kOlEEwDJM5KwR1k7sjFtJ61Bc3/e2Jcyk0jX14S7Y?=
 =?us-ascii?Q?WB6j+Di1wmd0XujfufV6yIYJtqNR6Gy3A3b/0/ScYAfhiWj+KrcEf3sXc1pa?=
 =?us-ascii?Q?0PKA/qB1EGD91mVcfwiikOZec+uCznaR/HIIAoZ473Gow3Ju0abNFyQfS4nn?=
 =?us-ascii?Q?5k6i2B3SL4wRPVjEOzIJ9o6T6s8CWs+nJVM/hAFxIru7VaoEmIJlT+Tgyqks?=
 =?us-ascii?Q?SNbfASkxAkNplozQTAd7xVVCkrTBSPMvftQxFNXxiuuyHZInvIy+McUf81q8?=
 =?us-ascii?Q?Egj5YVozN8HYoFUG/UPBvgDm4Rn8mtcbqPsjun+kTz07W9F62nwzmm6onwcx?=
 =?us-ascii?Q?RfbrVDAioHYfgOXJ3WS+OE329zks+Ciltzk7R4NAB+UElGrZR7fQKnGilUK0?=
 =?us-ascii?Q?7ztckKYSKX+s1KTlYOtapxDVQgpGTBME3P08X0DjUM20CndiNiBJEKC7AdtM?=
 =?us-ascii?Q?ds2oehSEiGqehmo3vLhV0Je/3ExBJ3qKHgoU5uv3lb4u7o2dlmyFZBEEgxXG?=
 =?us-ascii?Q?8pIytBMurXeU4WlbLgw7kd6zGtD8vktKaDf6pKhvyt7T5yxzAObbJ6PmNH5d?=
 =?us-ascii?Q?nDtHo2JGOBSD3CWRIGLW36cdUfnjckUok9e0/SLFMwL3g5X/Z46ZIIknhxLi?=
 =?us-ascii?Q?MqhlFVV9hSe9n3aZGjFDzvWWNh6sOYwhap5d0S24/ma3e/YKEloN1jxo6lG+?=
 =?us-ascii?Q?xcONF7dgaZ/rcE4CU2eqiMBqTEybCHIaK3Gsc5zbT2QJwR9ETDX5TwKBOP+/?=
 =?us-ascii?Q?T4ASHeeVGy7sLxz6WoOv2xHc/GraPZaVB4t4spv6u5qpXZdD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f727e61c-e1e5-45e8-e46a-08df0cf5827f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 15:34:30.6781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /oPWxkrvNgPhxsvVedzuh8Y1jF90Wl0QYM6ap4uZDkD6FtQ5+nKYRXJHxoiiCuac
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4103

On Mon, Sep 07, 2026 at 02:42:57PM +0000, Mostafa Saleh wrote:
> On Tue, Sep 01, 2026 at 02:49:57PM -0300, Jason Gunthorpe wrote:
> > The RIL logic has long had a FIXME that there is not enough
> > information to properly compute the RIL. There is also subtly not
> > enough information to properly compute the single stride either.
> > 
> > Change tlbi to use the information format that iommupt is going to
> > use for ARM. This prepares the invalidation code to support iommupt
> > and fixes two small limitations with the current code.
> > 
> > iommupt is designed to accumulate all invalidation into a single
> > gather, then the iommu driver should issue a small number of commands
> > to execute the gather to control invalidation latency. This is in
> > contrast to io-pgtable-arm.c which generates many gather flushes and
> > direct walk cache flushes as it progresses.
> > 
> > To accommodate this the gather will accumulate "damage" in bitmaps,
> > one for leaf changes and one for table changes. This is enough
> > information for SMMUv3 to compute the proper stride for single
> > invalidation and to generate ideal hints for range invalidation.
> 
> I am not sure I understand that, in what situation the leaf_bitmap
> would be used instead of a single page size?=
> Would iommupt combine different page sizes in a single invalidation?

Yes

> And then I see in this patch it has:
> if (!is_power_of_2(leaf_bitmap))
> 	return 0;

Right, ARM doesn't support mixed leaves in a RIL so we can't use TTL
if iommupt has constructed something like that.

> Would that actually be better for performance than using 2 sets of
> RILs, one for each page size?
> As I'd imagine the HW will spend more effort on the TTL=0 case
> otherwise it wouldn't require it.

I have no idea, it is a hint. Since SW has no knowledge I think it
should just issue as few commands as possible. There is no way to know
what will work better on any particular HW.

> > @@ -140,17 +140,34 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
> >  {
> >  	struct arm_smmu_domain *smmu_domain =
> >  		container_of(mn, struct arm_smmu_domain, mmu_notifier);
> > +	u8 tgsz_lg2 = smmu_domain->tgsz_lg2;
> >  	struct arm_smmu_tlbi tlbi = {
> >  		.tgsz_lg2 = smmu_domain->tgsz_lg2,
> > -		.iova = start,
> > +		.start = start,
> > +		.last = end - 1,
> >  		/*
> > -		 * The mm_types defines vm_end as the first byte after the end
> > -		 * address, different from IOMMU subsystem using the last
> > -		 * address of an address range.
> > +		 * No information comes from the mm, assume the worst case that
> > +		 * it changed every table level. The way this is hooked into the
> > +		 * mm is tricky, the range won't be expanded to include an
> > +		 * entire table level if one was removed like the iommu gather
> > +		 * does. Thus even if this is a 4k invalidation it may be
> > +		 * including any table level too.
> >  		 */
> > -		.size = end - start,
> > -		.iopte_size = PAGE_SIZE,
> > +		.table_levels_bitmap = 0xfe,
> 
> What does that mean, won't arm have a max of 4 levels?

It is really ~1, the extra leading 1s don't matter. Just can't have
the leaf bit set.

> > +	/*
> > +	 * If the size is small then we can infer the invalidation is PTE only
> > +	 * and set the PTE level only. Otherwise it could be some other
> > +	 * combination so just set them all. This allows RIL to use TTL=3 in
> > +	 * cases of PTE only changes. The mm must not try to partially
> > +	 * invalidate pmd/etc.
> > +	 */
> 
> How does that work with splitting blocks?  I imagine that might be
> ossible with userspace.

If mm splits anything then the invalidation will not be PAGE_SIZE
big. A split requires invalidating the original larger size.

> > +static u8 arm_smmu_tlbi_calc_stride(struct arm_smmu_tlbi *tlbi)
> > +{
> > +	u8 combined = tlbi->table_levels_bitmap | tlbi->leaf_levels_bitmap;
> > +	u8 tg_szlg2 = tlbi->tgsz_lg2;
> > +
> > +	if (WARN_ON(!combined))
> > +		return U8_MAX;
> 
> When can that happen?

It can't, thats why it is a WARN_ON :)

> > @@ -4152,21 +4237,28 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
> >  		arm_smmu_tlb_inv_context(smmu_domain);
> >  }
> >  
> > +/*
> > + * Called by io-pgtable-arm.c for each run of same pgsize leaf only
> 
> I believe that it is called from dma-iommu.c, io-pgtable-arm.c will
> call the tlb_add_page which builds the gather though.

Sort of, for the purposes of this comment the important flush is
initiated by io-pgtable-arm.c under tlb_add_page() when it calls
arm_smmu_tlb_inv_page_nosync(), which calls
iommu_iotlb_gather_add_page(), which calls iommu_iotlb_sync()

That's done in a way that guarentees the same-pgsize property:

	if ((gather->pgsize && gather->pgsize != size) ||

Yes it is also called from dma-iommu.c, but only for the "trailing"
gather and that doesn't do anything to change what is in the gather..

I'll add a few more words here

> > + * invalidation. If it has to change to a different leaf level then it flushes
> > + * the gather and starts a fresh one. Thus this always targets only a single
> > + * leaf level.
> > + */
> >  static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
> >  				struct iommu_iotlb_gather *gather)
> >  {
> >  	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> > +	unsigned int tg = smmu_domain->tgsz_lg2;
> >  	struct arm_smmu_tlbi tlbi = {
> >  		.tgsz_lg2 = smmu_domain->tgsz_lg2,
> > -		.iova = gather->start,
> > -		.size = gather->end - gather->start + 1,
> > -		.iopte_size = gather->pgsize,
> > -		.leaf_only = true,
> > +		.start = gather->start,
> > +		.last = gather->end,
> >  	};
> >  
> > -	if (!gather->pgsize)
> > +	if (WARN_ON(gather->pgsize < BIT(tg)))
> >  		return;
> >  
> > +	tlbi.leaf_levels_bitmap = BIT((ilog2(gather->pgsize) - tg) / (tg - 3));
> 
> Having some page table macros would be helpful (and in other places in
> this patch)

At least this one gets deleted in the next series, so I left it like
this deliberately. Was there something else you saw that had
duplication?

Thanks,
Jason

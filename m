Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011035.outbound.protection.outlook.com [52.101.57.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464672744F;
	Wed,  8 Jul 2026 18:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783535241; cv=fail; b=SiPfbmNWYZhb9FVrOieIq778trPYljNWZMJgLg0ZF9k+Di3b+WD/nA3bkHehKccbVCDgUFqDCzG6990dH3MnRhkNK+a2r9lxUowigtmAw8mcviVuu3L92aUUw7uRNH5h3UrLPMR9XM9WN6JfN0vWYHQoB42cWRPhRzPbBNW3Zw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783535241; c=relaxed/simple;
	bh=W6riE/Hza8GIw9sbH0rnPqvARHrFM2eUOrH1DuXeYBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mdLSuyvsldYMG/jcho0IBLYx7cycDrlwhfK+JUpxQZ3m50GvXTj9+RRuwHCuhXGTRdOPC9Sj9WOw1DHEbQGNmiFheTWRHrRhhZ+Iv9ewso43CSWbGAH8g+dEqjiFew4oDddn7oMqxJzFBjqUbpJQtXl31PsddHIgRWZazDpTSBY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TNQdDTdN; arc=fail smtp.client-ip=52.101.57.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TNQdDTdN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CJQh5FXdp6AmUQO6KgwWap+EqkXJ7Or0VOzX5Yc4+OeiKDplu9or1qf4CfXSHOHHMRfiZpBQ2cZbBsNvncR/HpRuY34er+pTWTWhE0i4YCLUBfz8wz5RSbx7UXmuf3QkidzInoh7LL8DqpP/X30T5y7/EWRsZpEGbXL4WHQJHUi2hUQOuwmOPMdF5kmI1BdLvkwLHO+7rko5CsSTF5JzjuJh/l0QNvFYK2fFPjlCbI93rhrYjLQ2eFeS8VqnfvhjNMvgMMIlAaxf3Dm4DiG2aTXvxjX8ak9OmC32VwocnJ1a8nSdIYQSYkEsxffW5Hsh6TEw5R0a48NqzfoFhajpsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cSDkq9qdooKsdsNy5WRMMeP4TyqSiafYUieZMeRb5EU=;
 b=C6JqJBAA2zZ6SAFpbwpLarYR/Zt5slywfuMeaEtXl34i1Ne2LUYYJ/gvyBIATg69HzHvY1KJoEqGIjn/H/xRUEsEAqoS1KyeDtHRXkniC3XoMz4tVVhf9vSn5nztJzUy0wpYpU5lgHuK+noa7TxL3PtcFnSdNOxdmUQXaA4l3a9/8QZpKHhBFIzrn7Oh3z6gZxYUSwRIzjlePybrKVw3qg7ueuR9Vzydm+aWyY/pfSGCpR8iA8ZIeQCnJuZAQOvsigeyN3wcnI4qTw4MXyCSnyLRqPrgdzZX5BXF6YOMRJJFUjTzLmUic8US+KGdJGh+S75kSzPKA9ykIyCJ0Ixmpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cSDkq9qdooKsdsNy5WRMMeP4TyqSiafYUieZMeRb5EU=;
 b=TNQdDTdNkQaGJIHEcKfTsPyw0WXoql/a+Ti873uxbb87X+G+JFR+sHh9XgacO5d6QnPHZVI1VW7DN3WINBlEIS4xNVPg83He5eBsxyBxX9tPMcL0kZ7MqfJTI1ZFtMoq9h0J7Ot2f9gyOHKhTrHAjpkML1qLdjIchuLRENFLzEtTHkJz9ROg9OWtKFKE5G14dEMXNDqgmkA2hUULV3ogiNGR60PcM7LnUPdsfz+NATJr26tLZ6wJaZib8wpYNi+Nev3srxF+IxWoHlsQABtv+b2Vyq8sk8Fjgd90hz3qnTgTK6+dSoQ9+1WIwjN0pT58p15EysfS2t4qiHg2T6/1ag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH2PR12MB4213.namprd12.prod.outlook.com (2603:10b6:610:a4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.14; Wed, 8 Jul
 2026 18:27:12 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Wed, 8 Jul 2026
 18:27:12 +0000
Date: Wed, 8 Jul 2026 15:27:10 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 7/8] iommu/arm-smmu-v3: Change how the tlbi describes
 the invalidation
Message-ID: <20260708182710.GC422027@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <7-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <ak2qw/dFEixxY/Uj@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak2qw/dFEixxY/Uj@Asurada-Nvidia>
X-ClientProxiedBy: YT4PR01CA0068.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:111::28) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH2PR12MB4213:EE_
X-MS-Office365-Filtering-Correlation-Id: df15a02e-8947-4102-8545-08dedd1e8739
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|18002099003|22082099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	6dP+lCdW2eZvo92crOuEL7rNvjcAWoDh0igYXtz5R8CucaDxab23GOI2aK2ykPgsQSyYUb899/Q9f5oK+AB3iWFpZjXMIvi9gSLcHXBCMqfPHJfPn2puw28FiwQrpzHhSJns9fmELbu8szqMU/4ei5yyGYBTbmcRpNuAt28J/DRkzdMuIBetlRdN/4V89Rn3/RuQ7k13S8vHDa3dzaJQUq9MefLTy5IgPZzGGnBqM9N4wNDfhePIVb5rb00ehXTgVotzxJdkQpELj1UdT8zfiHOHbYPSNyEjCnm7GeX6mD72JHQ/6xamiEFPVG/4G6l6Hz8k34czzMkQ9a0NX5iQXzhLURKZ7DI0QRc65cP5BDFH1J7hAr00OYHXwr0mQTWJlYraUUAb7vLO23SSrTXwWKbFLxpFchZETjRe0Mneq8gzbUICDl048+M5y/Kcz/1zaLa/J4+w8rcRyTbHFy8kfprmhQMIZdjFvSyNz7qOW1BWu1hBOpVbYdvvgv/eypqXawUn92eaCu8OHd0Nd/AAXFOaA3mzXKz1yN00RTlO+e41Mrd5Xk6fxY1YFWZ+TwC6yGQUWruneFS7y3EUs+KV91vkOnyU30e7ixrXO0Zogz2RipM2Tw12hJiUl4NQGaLOSXkdjrJfz43HWOd1lWeU8IHO4q6u4tOw0EcLi6VI9mU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(18002099003)(22082099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?60kIE7GhS1a2JjOOQNoD5pda7637qVEivJLwcLV6adB2q/l6lYJwr3XKRQ1/?=
 =?us-ascii?Q?OFTFzkUxY2Gp1L8wLVG6TzCALup+SK9KaYInObCDPQ9Tm7utZWupgYrL6dJU?=
 =?us-ascii?Q?+lEPNPgd3ZrhEuDhX0f0GjD3TQSrz8sooa35MLTc9DAVrIcAE/rBYvR1RN60?=
 =?us-ascii?Q?xQO+14S22KiFadmeVg5lL2UaLyrkN/tga0GBmRdXeLUlUkNKaAf0IfH5bvAU?=
 =?us-ascii?Q?15O46TgbyK+Q7eZvGO4b61vWMg+qyAPKv0NhWj3D2+PNDd/11ZaNJxQCT0DG?=
 =?us-ascii?Q?yMfhqog/mFXqIx58ellRLF5Cydyn7WYPU+TgCyA1EFsDn5d/JXdckNc4lEN+?=
 =?us-ascii?Q?U7EoBR0RrmWTaYj/hvuyk5BOsuBsG5J1D0VsT3eEtuzYlhgzPP6WXr36ZkzS?=
 =?us-ascii?Q?o7THPnoYNj1t3UkYlOzgY5uYDq2VKEzelAJDyks6ySZKk11SwAkyTThZAOoe?=
 =?us-ascii?Q?2Sav3uuH2JXkEB08q85LX5lnSIgP3i+jlu1DwjEP3+SIJjOjNijNupK8sA7b?=
 =?us-ascii?Q?zVZAwqwZLRuiy5spkUibqGkNGXleQUkT5LQzOETMh8bbEakfZdvpBepPD7QH?=
 =?us-ascii?Q?h+4CmjhAoiLGr0GF7nEZ+iPtIAzmHHWaq2tF8+EQjAZJYg6t01UUqjhNVTPr?=
 =?us-ascii?Q?/4DGw/b1km/yohNLaAO+zwQjuus+gAj320u9r2pcZbWwfUvq+/G+ioYy+h0s?=
 =?us-ascii?Q?284lJw6XdpfYbPMHczWoYCWULho12Hbok9EdU8nlx08VcAGDEHSFXiSb9E/I?=
 =?us-ascii?Q?m5djMoLzuV1jak5RiB24wUS+VRg+nIWsVi9GlL5VzNbIySBB2h8FDi9EBWzs?=
 =?us-ascii?Q?6WVy/2CgH+fX/9bK/cYFfS71+DgrB9U3Pr6t1DcBaA4lnVnjghNe1ja/cF4J?=
 =?us-ascii?Q?GukX88XmtgpRtEeNkpVe8HA5u/Oj1H059NpmaQe/ND0mISfrqxeKZ8fe3KKV?=
 =?us-ascii?Q?Q+RlqC7FCrh3zN8az06lfKYFRiMY45xqIeR1jEBZUEV5WnpclBc+ZhSgVlnq?=
 =?us-ascii?Q?TmVSkhb7l1VfmTrknLUMZCTn2xkxVKgc8lfHYR4NCkCpC+PxqpkqNWB5e0yq?=
 =?us-ascii?Q?cYtRoraXxT51mtYGTfiezol3u4Wn4qUF8z3RBKbciN3LNiLvo0u7MttMMuvl?=
 =?us-ascii?Q?bPj99eJTrdoAzoeTZRjs9Om5/e6Tz6IMXBxMHm29IBES6Xiw/UNWtaClG8Bo?=
 =?us-ascii?Q?JSmnzmWEgGiYE6bY4AV0+rC7YJsaWu+VtuuIMvXGyQUSOuF/akOSkFx/V0gn?=
 =?us-ascii?Q?pQ9ArQxhS+7Zngfz8y0pU4CZTczZc4kOYrD/m6ZsILSeqPfQWIkiTgrr0iQ7?=
 =?us-ascii?Q?tcglj1rQGFaB90zO7xF9LqXIAIK3Bl8ZjfH2mdov+fkuDhqS8a/ScN419jsO?=
 =?us-ascii?Q?vRxkZnyy7NNaA7Xixr2LAwzPmNO8ENhjd4fKesDugQWYYiVlUWlWaWHLs5VU?=
 =?us-ascii?Q?Y1cPjoS2q5HfKXZ1DuUH8knMKs0TCr//e7NfhbO9MfNDrwBVzae4w7vXYbyL?=
 =?us-ascii?Q?Z8D/qq/vIrlLWrPL8+xAetYhu9Aw/QkCWlFt6FzUdM5XNl8fTgWffpFeyzDt?=
 =?us-ascii?Q?roArQI/ThNiV65QWQtCbWM+YVa+ALTuTt7461Th59cGoV7bjGtqfh0gqQEqW?=
 =?us-ascii?Q?kTK44N4euqzHJilSR+t2LIfz53lhDmVHVD6IIRtCxU/u+tkfY8MK7p3wVSbc?=
 =?us-ascii?Q?rzqxhChz0AILXbvaw8TY4ZGJWOTaAbvlQ+5GgGmdf+4Gb7W+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df15a02e-8947-4102-8545-08dedd1e8739
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 18:27:12.2096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kkn2Z96NobHvJIdTCMXQDO+9oAwQ3599oaNSVENh6xt3Fy4ofXL/b3Fz2zLnRUY4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4213

On Tue, Jul 07, 2026 at 06:41:23PM -0700, Nicolin Chen wrote:
> On Mon, Jul 06, 2026 at 01:26:44PM -0300, Jason Gunthorpe wrote:
> > @@ -2331,8 +2331,8 @@ static struct arm_smmu_cmd arm_smmu_atc_inv_to_cmd(u32 sid, int ssid,
> >  	 * This has the unpleasant side-effect of invalidating all PASID-tagged
> >  	 * ATC entries within the address range.
> >  	 */
> > -	page_start = tlbi->iova >> inval_grain_shift;
> > -	page_end = (tlbi->iova + tlbi->size - 1) >> inval_grain_shift;
> > +	page_start = tlbi->start >> inval_grain_shift;
> > +	page_end = tlbi->last >> inval_grain_shift;
> 
> arm_smmu_domain_inv() in the header passes in start=last=0, but
> it's supposed to flush the entire ATC, right?

Yeah, that's a mistake! The invalidate all needs to set last=ULONG_MAX

        /* Prefilled for invalidate all */
        struct arm_smmu_tlbi tlbi = {
+               .start = 0,
+               .last = ULONG_MAX,

> >  static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
> >  				struct iommu_iotlb_gather *gather)
> >  {
> > +	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> > +	unsigned int tg = smmu_domain->tgsz_lg2;
> >  	struct arm_smmu_tlbi tlbi = {
> > -		.smmu_domain = to_smmu_domain(domain),
> > -		.iova = gather->start,
> > -		.size = gather->end - gather->start + 1,
> > -		.iopte_granule = gather->pgsize,
> > -		.leaf_only = true,
> > +		.smmu_domain = smmu_domain,
> > +		.start = gather->start,
> > +		.last = gather->end,
> > +		.leaf_levels_bitmap =
> [...]
> > +			BIT((ilog2(gather->pgsize) - tg) / (tg - 3)),
> >  	};
> >  
> >  	if (!gather->pgsize)
> 
> pgsize=0 is checked after ilog2(0).

Yes, but gather->pgsize = 0 also can't happen.. But lets do better:

@@ -4096,13 +4096,13 @@ static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
                .tgsz_lg2 = smmu_domain->tgsz_lg2,
                .start = gather->start,
                .last = gather->end,
-               .leaf_levels_bitmap =
-                       BIT((ilog2(gather->pgsize) - tg) / (tg - 3)),
        };
 
-       if (!gather->pgsize)
+       if (WARN_ON(gather->pgsize < BIT(tg)))
                return;
 
+       tlbi.leaf_levels_bitmap = BIT((ilog2(gather->pgsize) - tg) / (tg - 3));
+
        arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }


Jason

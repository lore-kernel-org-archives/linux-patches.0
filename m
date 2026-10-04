Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012007.outbound.protection.outlook.com [40.107.209.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFC43CB54D;
	Sun,  4 Oct 2026 17:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791133229; cv=fail; b=qPnYzoolld50zH4bNc/Qz1zvAMvVmQP7qe+Qr8zfxZ0AS6h473l/pb6WWfpXPy3Mf2iG1Hjl5uHB7o8vfp6DymKsQwMPvNER0q8xqIRhzqBKWlXGX4/wiY8vd3Q3+PIUvsnOgbnHta6RVyheaDTx1f8a+5iz0MruiPRRZAXFL8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791133229; c=relaxed/simple;
	bh=lvKcpnJ1UpdA88mKG/4f/QcTS2tjoh64vP3gb6p1V7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hdiHpDttAD0+Dk0Vo6yDGe6j41KZ8AlPQ6+Wl39ISG3wFOcbJBxBxxt3vOsVZwnWKX16KcMEHZ4DRrEV53A6bTS8D93Jc0NT3ZrECXd3FDVfxMhrZzs19hhbqO2rIsuku8nIhkrduVB+Gjhq/DwMpfxONl4rk+Rk10fj7z9t2ko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=t2hfpkT0; arc=fail smtp.client-ip=40.107.209.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="t2hfpkT0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mUcCxuDhRsSoMWexpiNW63pAXqAj6KOSsl013y6vwVMUN/d5fAFlLQOAn2B+qnQ7Tb81XAm00jvupAzrLCcwE1UN4x7q10P0aihjnXKhpJRr5fuuDCSp0GcLpsZhwhRlE4iaepgqqXZ343GSgiX4ajbVI19SfOASEZ0nFGU8sQyWkfD5pesYr49i5hOayeKZH907M04160Wr4raDeb9i9iXWFmkw9BzPr5SGNEUOH3gyCbq7EGIVAgn3Bb+gavZrC1x+w/XpGAthagLCyVe2i4mmqcKJ1WkWMjHyh0PcPYRsLXXFybb25OqZn7MNa+I6GLLuIFYcuISDc31uE3XnQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8PVrlNHrUjTqftARQ8HgjuJ1rF4g7UDUElzCUp4WZZA=;
 b=DiTj829nHw8fsmorFmnuY2yCnzuSvpmV6k8RJLTRE9oB1Whew6csbojMdsb2nCDKB5xhBL+2ZjyOA+FohP+L1YctjhvyDqzATMUp7bsAorSOEhS1l9IkNP082P2mg0rTyBRH37zkzmhKe7BcY9Rs0cbVpx33gs/kYoUfn9Wt+OdwOjplGJoy3tt1G5MRAUPUUmX6CHcK24s+uAX/jkasvpdGLfHasW4TwYbo0IeeyV8jJaoBPDoMPYvHx3W8144ikzWAoDRgfW5V0qqeU0AcMTbR1ecJMalB+k1OjJEPD4hKZQtw8pwSQFkO661d9J8VUrA58S+Obh1rtuqBqHAEew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8PVrlNHrUjTqftARQ8HgjuJ1rF4g7UDUElzCUp4WZZA=;
 b=t2hfpkT0lQZUKbRPM0nQ5z6BlzWQ7A6RLW2TjppM2L1JSrAv8RhOtTh4HC8Cc6pVUqqam71XG2wRgxMDrXjehIVJYCimeZTZjmbHQgE5mTMGIn3XKB/5k5M9yMNotF+dLD1lt2YKzWEtdtBZ67A/Nr+gUqf+CV3kxDFHpDvvQGpU9qFxlvNCt49k3l2MG/F02txcVLYTkIyg6bLwvdOePkcvpcfibRLMUjUFjNhajNREpPeRDOI5ZWhfd5LH6WCg0qABM10whWUmfO97U6zVR01PTCfJT3wXJBcVJl+3p3N6BwPn8ikKrz7cWq05ZOPcoJQwFz2CM42hbqK4Fhu2tw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM6PR12MB4138.namprd12.prod.outlook.com
 (2603:10b6:5:220::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.20; Sun, 4 Oct
 2026 17:00:15 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0472.016; Sun, 4 Oct 2026
 17:00:15 +0000
Date: Sun, 4 Oct 2026 14:00:12 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <peaan@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v8 8/9] iommu/arm-smmu-v3: Change how the tlbi describes
 the invalidation
Message-ID: <20261004170012.GC4064@nvidia.com>
References: <0-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
 <8-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
 <asJYBfMe_qf5Nbn-@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asJYBfMe_qf5Nbn-@willie-the-truck>
X-ClientProxiedBy: VI6PEPF00000203.AUTP296.PROD.OUTLOOK.COM
 (2603:10a6:808:1::90d) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM6PR12MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bbf6d99-d93f-42fd-e58d-08df2238f60d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|11063799006|4143699003|6133799003|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	4/RpXsC3dkphTNaqFeeOCiD7BJZN3T6bJYHqMAzy3ZtHl78hg9i8r87zmGuufiBBirqvXwNVUx2KevylaD/jpuMI46l/ktRNocBa6PPfe+qxDV0zj6dRATG8/5OPYGFAh5Ly4+Jytz8CMLZ5Z4CFWs7CJxe1zDHPGlt4/NGy/4rgjud6OlyeQl3qPH7YHpyVxTGhl9GjYivk2+c2Rg61+af+SUo13BpRj5opltT5q5RSEmL30o7jQO+pKgtoc+nQTWdACF6QhkVU5cKNJt4DxHCk/7YrLGpP1AWuWm6Lb0hD6/q8QmX++KxU2r9ATpG31iBgMXVKz0VmPsiv0bIiWUgEmrumIbU/lp2gcYk9eqh41nqzpLn1IO5Dn6PRoOd7U/0ZdrrqMDBl+aF81Ia4d7JsY3t6aAmI8nF6frQJJ2u4qqI3nEHZ4q99L6hBnQgjs6NZ1ThlYhJMpBjtAzZ2pTRUIf73SG7nr1SKNMLW+krj8d5KDKeeD7B9UyG3FcP/2gioxvJipx7MCXzU30ShSzEhxtqfqX+9v3IWjB0GcmfD67/RkLVs5S2PKg53YkDkkm+iFk0l66mqsUHVZq/pX1YdU8gXFeFoSLAasrSpcI3FcSd7UzUYGcePuc9J2B20AnydMlXt5KNZg6aLY6+wNN69xtFSLAdjxScox7NYBns=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(11063799006)(4143699003)(6133799003)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+6RbDf9E9+GTNkW2e4QcU5p+3Y3HXq4hba7IpaFaEDMLqcrFksZnJQQfC1+u?=
 =?us-ascii?Q?o34+qs2YtuplS7Z8tOynT9oJ/uyOpzNG8mCBMt5uKzchrgjqBl4Fi/+lxdht?=
 =?us-ascii?Q?yMPeTrrJMlXdzO/Y1Q87r7erSTesQkFgRGenX1+QPSL8mW8QkbU6oQ6x5Iq8?=
 =?us-ascii?Q?u+cOtrt0t5FYLoYuL7Co36YlE0ZXMXRHElGuChA/e8VFFF8O5FmNLkKHeyPk?=
 =?us-ascii?Q?XaFn+B5pm8jGR5okDO7QDT3in6BxXpfCJC9luBH4q2oBIouhhzu+DJ2+/HS3?=
 =?us-ascii?Q?YHeX4/E3Ezv4PzgdrlS2ctb1JlESzQ0/OzhPxbDAqApRtM3+cfs5gY/OJZ6w?=
 =?us-ascii?Q?xmleeX4UJJXJPh0bp+7SaJahEn7bSy57c1a/kBPQXxyw6GDAkVQk7hDfxdBU?=
 =?us-ascii?Q?RthcWFwLN8ygZWkoE34/ul27FaY9kloJNJM68fjNMf65Nw4LSKaKTTrF95WO?=
 =?us-ascii?Q?qFImGln8M5fegngDEz01oa3VuR2PbZPEqXOdI8+PHiYn9arsInkytod6fYHC?=
 =?us-ascii?Q?WecuAAoLkuW+6TnhLoQv1j4B7/gSd13hsy43DA7NVI3FOIDG/F4exG7GSe1F?=
 =?us-ascii?Q?DuyRt4j4es8XzS1YA6uZX2Xl7IFZ8p4UtwYb5NBnPatmIxjx8x4RrANuQrvl?=
 =?us-ascii?Q?yyTwBokCCHm7pgx2k8SWMiyXCzs9iD5b7JAMilWGTIxS/SULtaGMIJkeH584?=
 =?us-ascii?Q?pKJj2640fZ5S2arT/yLGKEVqAI1hClJaXf95VhmAQtK8agKUrcl9Xsv00O+U?=
 =?us-ascii?Q?MESVSbS6/U6HUvc7xKKkw3QXFGxDpVQuleCGhBse+MVDnwDNkeUy+TDP/dS6?=
 =?us-ascii?Q?5MZByz83JseDd0nlT+5TXkJZY6GHKtGQ61nH0n466naPRmJMwn8wB3korYHz?=
 =?us-ascii?Q?4nnk3MWe8Ic1UHMeVHmJI+Kv61UGMn9mKaHvuJT8iy22CvXEc5cl+qBLHZTM?=
 =?us-ascii?Q?bR70LmjMw1XUNC8gBPxcFM7pXWdYLMHZiAiFr4ORxm4few+VRAV+2f+DFzI4?=
 =?us-ascii?Q?5xJPV864N42TjngMnTO0opcs7FTb8MoYAvxLvrknN7MPuXmwcDxcbYblYhkb?=
 =?us-ascii?Q?QU9mvVICTGCu1yq0xLO9qhHDTfaLdNdnOBFIfla0y3T3bGZ0vbsjfNyTeo8I?=
 =?us-ascii?Q?9N2adrl3SdNxxvlKfIwAS74bIaBavDZAxVapsrbkcwydB8gD3GOLwT1cPoPJ?=
 =?us-ascii?Q?VK4II2l13fA6oryBrSqPkFYY7im+GtPElYRnzBigYHIHNNo7GiYllKG2ABe8?=
 =?us-ascii?Q?ywbGMtjhRbJHvEJrPMzNaU11kQTWudZxU15oGvPWxxf1Cu5IQ+QiH6J6G5IE?=
 =?us-ascii?Q?HBH/7tLub/ACbPkpJlpmmn5gOdo7MkFL2BJH7Gepq5NWk0eggW8sK1UqQiaD?=
 =?us-ascii?Q?fY2shYf0uVA8JkiWRekVdwb2fyfQz0sbfZDPeOW1m1metIQLvFgGjN8Yj+20?=
 =?us-ascii?Q?lZOV7L+bA3etIQ75c4W9eaY6pWHtOHYHRB83hJbccsn8dqB+9+kEowF+rr+U?=
 =?us-ascii?Q?uyA1woXWEUfYPbxp+TPfkGqMg4pCE/O+NeFRGJDuMiRbzCMaoz0CkNenq4qv?=
 =?us-ascii?Q?BBLpZ3WClLtcmRZ34HTglXNxy2GZD1eB+vhfNWtbOkNd9thy285N1JjnDeJA?=
 =?us-ascii?Q?uzzM7AVXS4B4kCYiBTFPn1cFeWHJkO2QbC6Lwos5/RXKaEZDx/I/fkhZkTEg?=
 =?us-ascii?Q?q9H57gR12PZhWTObCwE1p3KjRQR69UJJrI+yg2GzyJ5XedNy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bbf6d99-d93f-42fd-e58d-08df2238f60d
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2026 17:00:15.2457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IA3+nRob53yx77xDR7SdoyKDb84T6WgPgFS/GBjniS8pwDm+E1iZ49vObdgd0jhP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4138

On Sun, Oct 04, 2026 at 02:43:33PM +0100, Will Deacon wrote:
> > +	/*
> > +	 * Assumes the page table is formed properly and does not trigger the
> > +	 * 16k TTL=1 condition for leaf-only unless DS is enabled.
> > +	 *
> > +	 * ARM level -1 never has a leaf so something has gone wrong. ARM Level
> > +	 * 0 cannot be hinted because ttl=0 means no-hint.
> > +	 */
> 
> nit: This isn't strictly true for the non-range invalidation operations, so
> I think it would be handy to have a big note saying that this function only
> works for range invalidation or even stick "range" in the function name
> somewhere.

I figured "ttl" was enough since ttl is only used as part of the range
invalidation command. I can change it to range ttl
 
> > @@ -2917,12 +2998,17 @@ static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
> >  				  size_t granule, void *cookie)
> >  {
> >  	struct arm_smmu_domain *smmu_domain = cookie;
> > +	u8 tgsz_lg2 = smmu_domain->tgsz_lg2;
> >  	struct arm_smmu_tlbi tlbi = {
> >  		.tgsz_lg2 = smmu_domain->tgsz_lg2,
> > -		.iova = iova,
> > -		.size = size,
> > -		.iopte_size = 1 << smmu_domain->tgsz_lg2,
> > +		.start = iova,
> > +		.last = iova + size - 1,
> >  	};
> > +	u8 table_levels =
> > +		BIT(arm_smmu_pt_lg2sz_to_level(tgsz_lg2, ilog2(size)));
> > +
> > +	tlbi.table_levels_bitmap = table_levels;
> > +	tlbi.leaf_levels_bitmap = table_levels - 1;
> 
> I'm having a tough time understanding this part. Specifically, I'm trying
> to work out what happens if we end up doing a non-leaf invalidation at the
> PGD (1GiB) level with leaves at the PTE (4KiB) level. In that case, don't
> we need to have table_levels describing both PGD and PMD levels so that
> the TTL describes the 4k leaf entries?

The comment you clipped off tried to explain it:

/*
 * Called by io-pgtable-arm.c for each single table level it wants to remove.
 * size is the size of the table level and granule is the tg in bytes. This must
 * clear the walk cache and any leaves within the range.
 */

But, I had AI double check this statement "each single table level"
and it agrees with you and gave the same example. It does look like I
understood it wrong, I thought the segmantion logic in the core code
would save things but it doesn't work quite like that.

This still works right as-is because the leaf_levels_bitmap disables TTL
and forces single to step at 4k, so it isn't a functional bug, but the
comment is wrong and the logic should be more like:

tlbi.table_levels_bitmap = (table_levels | (table_levels - 1)) & ~BIT(0);

Jason

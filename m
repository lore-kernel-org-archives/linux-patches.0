Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013034.outbound.protection.outlook.com [40.93.201.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79C222A4E8
	for <patches@lists.linux.dev>; Mon,  6 Jul 2026 19:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783367158; cv=fail; b=IfeNL8bPffm/NAn9woIudlga4RN8zsrGMev+Li7FZjM5L48W0bEPUYH+nUFVcBH3/NXklukdd5almiHBVLOGv+Jo8J73Pc6KIwa2Ee3WsBXDhKIL0pv1cjJl/DfrQimWvaD6tN8bIwUj52jVquqk+66fGp7pjyvxc45NKUdX8G0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783367158; c=relaxed/simple;
	bh=GWZ775BQbv5zd4hID20KFODKqVFimqjg7yIijjGwmrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Qp9GRp8RDgq7l1fqsEgXHkiBQvr2djI5ipSJIXyOo7HSioAE2UAar26j9b3lHDLofhkUuqaJuGNzBHGkf/3Fvg8bNtH3EYWKPb6WAmnDO5f+Df2nDf1szGPY3LcG+pM+4ML9KAIfb+HvZDftFIYTWNVJAiXw9i8I8DwP4Dplaos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h9WdVY9l; arc=fail smtp.client-ip=40.93.201.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h9WdVY9l"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ejI6NmuLUUMG+fV9obK/iQoRpvVdtZnLi9XHZEntDvB2mqjVMcdEGX4iVV7QOmaEPN4tsbNckz+K8QzzHdj6MbFIrDnImESHxvq+3/cveE53DlgtBZTxyr+tCuS8GcYf40BuF/LmjONO5481XycYyxGoPZCcGr1rJVuoVRNbecc/5n7stK64Vem8WLLdbt7v0wEEhtHurb5oVhBXVXAinCwkYTvQsq4vDi+sCIsRFXcioIDLDo+PHfH8X0qNmTFg5zmscpILS9wS0hnZf8iEYBlhkV0tndjCvotRr1Y2hgyzdTH5FwH5BXalJ7SFikVGbWQ12qsVGa+mcnQ3yEAaJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2oICNrQ1xwCDaEpKno9l01thkboCAbHyhE5Bxiua46I=;
 b=vrfRkQN2A2q1nNx1jVMKc78rtS/B9QBTiwNe5Kh5k1br4GNF5rGgAYmSocbcLpHrOIr7IPNepLHBPSfHIeOXDQ8+bebLF1FS6+e5lNvYkPWbjzq8U50SQh+U2FHKj+9oEk44xX1/2IVpgJgNrbEn6P27SZZo3lo/y4VR5y3BFCB6bfQ6StLAXI5aENO0pTmJVQ/IcxP06bUvHhPNZbGXpf5ZIzV3pXsq3hSOBk59rMTB2yrCvzpZvr3LDSghRkGqgjFUHXSBZJ3bVjelYuCda3ShQGjCyoemBccnkptFaAWJbo8I574iLyUsQBPs7Ft9ui4q6YLAfVIcOuXXPciv6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2oICNrQ1xwCDaEpKno9l01thkboCAbHyhE5Bxiua46I=;
 b=h9WdVY9lBOR3E5jQcBvXUeJWXqpfVejS1wt1+QEa0tzSEkMEFqncnd1f9i6LcXFYPE4Lua4hzShIz6qR9aTS2HxpD+gNrknrERpeIHZGhRv5fz92bCj9OSy3/BGyWs6t4vYBIOStTdagwjQIFA6O1LpLdd7xkknKBBfU5Agd5rUc6GAxpUXSqQu2etTriBr4JfjjuP96Uof5A/KJ25pgWSIzqowT5gMZAAvIPx5ag9sAPAcpDvvYL7h8EHr390Vbsj+Jkx4qZNxd202DeVWVxRGKfegMULg0btJbUluiYBz4zkOrc7JkM1TxbtpYwZ1jUpGI2jsblibF8YlCAycm6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS0PR12MB8248.namprd12.prod.outlook.com (2603:10b6:8:f3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 19:45:51 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 19:45:48 +0000
Date: Mon, 6 Jul 2026 16:45:47 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 7/8] iommu/arm-smmu-v3: Change how the tlbi describes
 the invalidation
Message-ID: <20260706194547.GC118313@nvidia.com>
References: <7-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <f351b3ce-6488-4b8c-a28a-a3cb0b827750@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f351b3ce-6488-4b8c-a28a-a3cb0b827750@arm.com>
X-ClientProxiedBy: MN2PR16CA0060.namprd16.prod.outlook.com
 (2603:10b6:208:234::29) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS0PR12MB8248:EE_
X-MS-Office365-Filtering-Correlation-Id: c3ad0891-c4d7-4fb1-edce-08dedb972dae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|18002099003|11063799006|22082099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	S+QyoIJ4b/2HokY1K7ztcJgBotxMPvIz9IPbR+HGCIS3u1ncP1lum15ff1kdHRryYfNhwxo8QlNYWTT/4cPwLP/rwacxpfSp3Zr5hMLWTqqsTFhuWm/jGxDS5PfeY8IArluTuIG1fTuXErhHPoobrczunty0djUpICinAFe4giVONQnc+wuVIkExbhDPSGHOr7OAkDvQ/ZE92Agi9QoqEkMx9G0Ldt5gFPy2lEaUZf1nv70NlOEox/K3RgVBv4sRpgDx4hDBOA6IaUb4SJb8SShaEKs2M1JD7P6QPg7OggniyI5677HR4RtGHnHtyXB8tmDhhdf0mwernvkzs9PtoFyqmO5yhmkh+lSZO6osutQwGsPj028P6R7qynrv2l+W3u/urzqZnlHcQRunj/GTvgFk+6tR0rjfxD8WyNOfiOYWSNafb9gpk3pZITCWpr5nYDz+ra+nQz1bOV5jWji6VR5ybVP/BYW9PukUyaTF4TlnO/lA1+5Y92u9FMOCrri3by0gbwHO34D56J06LG72P8Ik2ixUK3GsT74JzhBj2bF/8fgkYnvIqbSj8lxI0EADTgYtxCj8D+bLl3bnL1GR04Zik4iuimCe1N+gDXCA8uEjASnYyKJXdpP6yiWWr9u8DgvjZtgkbwGgQNZPvtWnAN2Rk4b9HTR4KeLwFtTL1TM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(18002099003)(11063799006)(22082099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7aOO6si4W96P0KdiKOC4vYsKbtmThGClwjqwapInOg9uL1VuG9Z83ZeVrXYs?=
 =?us-ascii?Q?j8JBfTlR863RAAIs3tk6j892rHhbOc6xPq6O9bbCisKi+GDnvACp0tmTR0Qq?=
 =?us-ascii?Q?y7/xW0NCIoDtvljRntnjy9/UXZsMrifEbFzh1AqmLW5jYvdzAdEsti+2+uS3?=
 =?us-ascii?Q?UcGY3+PUMFeXRmQG0z9aDApCeX0OaeIfD1V690LI3YVQp0OH3EdCkinJmR7a?=
 =?us-ascii?Q?4pmJrNCAF6UkissxCMR8sFGxdlTLUbm9iD4mHxEgEvkBBKe3H9cJJPzQ6Q3Z?=
 =?us-ascii?Q?v9a9QFeIbe73EmTiDleKsi01TjCtcdXqgb/ZHPLIDm5p9GYPiNyg3J+x/a3d?=
 =?us-ascii?Q?32QPIJmVvRAIcihhf0Eu4vbXgV/KDdz0Sis7nZ4f6X47vgaRq493S8hQoESx?=
 =?us-ascii?Q?X8BxklYiFyYiE23tpyZA5bKaD4ODa7cb2bBlynsNPrOPnjAVm3Dja9okSEkh?=
 =?us-ascii?Q?PpNA3FbId1oJGqkiJXLAVZEP1GBXxYw0pO8eQbK9ZqBw067eQvdqesQDkx0G?=
 =?us-ascii?Q?p/4dRmZxKpv3CAApDYBspBfY34n0KFjYYtPTTQELY7mTeYM7SLaN5UAgTcVI?=
 =?us-ascii?Q?eIXhqOK9StqNFcGBqv11/BSfHO+TA3CqgOcT+uH7PAvCp/w4ichifS+Wr3eF?=
 =?us-ascii?Q?Zigx4jqXP57S+/QPodjPvpaeyUZ76vOKx3Z0RKl1x19h4LLjt4taF9IHk6v9?=
 =?us-ascii?Q?Ow9iYuDu+2xKvSVh6f4UtlJYZuE9BIS3/Od6SGvfPGP5zAtNI79L3TclT8ZL?=
 =?us-ascii?Q?Im3q9DIipdBnFoR+1rEh+52G6N6ZJaDAouSe97WOF/GMHS7aZ8QKAKREC+6s?=
 =?us-ascii?Q?nx6EWPWWcJwL0o7M5fL6YJHz4adZ3zcan5LSC3I/jMh5fxUGV5QdHBK7AWpM?=
 =?us-ascii?Q?k+02Kowz4DNnVr2+27yNO7XSRUOUI0n5qpjSGYooowjrRWoRO9zje1NY8pQN?=
 =?us-ascii?Q?T/RHaKUtCa/Lw0jICELtgIn1yZvQfUDM4RKemGHEJncqSUyPG//uENAuxF+Q?=
 =?us-ascii?Q?P/kOPXJm+A8TvnQ64uPf5L08SauExJgNAX3RIsNahbm1CbYPPywX/4XG4Q+B?=
 =?us-ascii?Q?Q6+NtCzl+X/ETAipPgU4hSB/VLLZG0LMbxn0wasXHGGIEBYQi0NhpkW9Ceye?=
 =?us-ascii?Q?n+PtHJbC/Xt7CQiHu9CXvZC2Mh2dNhZQFgC3V+gv3lXYvEqKlxmZ940whlyD?=
 =?us-ascii?Q?D+n0OaZmcP/xaHIYfWskHwaY/NRrQDyiMbYu/+5yxUAneBjJ7P4gqE9fNtS+?=
 =?us-ascii?Q?nHc39v1TDw+G5deKWM7VK+KUZG9Zda76k8QzwXyKDXf9d/IPKbLc//CYSFgF?=
 =?us-ascii?Q?OCbwMoxCSPws6hBSM+n50vKrrF7KA5g/XKReZbmYrwt6fqWplVJfVU4qDlPt?=
 =?us-ascii?Q?0kyJLz/RXCuhQM0SPKwSLjPldp6yffz7odnoHsODlweClZLpVhQUwAm1sIDj?=
 =?us-ascii?Q?oo/vmO24dnnhMw+gQigPLRrR9QnwFTU3LLnXCnkmbaemasEwrIpc3dLZaqR0?=
 =?us-ascii?Q?C7k1uDiUHZyN3TicPLQssretTjurmL3smohiNtX9EH0iwDWVSZWGcPE0DlXH?=
 =?us-ascii?Q?N3/1d3IK5SL3/kyBenlBqPEaGHZvCHjLVNt4cBpY3yQYUWgyIX/s/QilhpkN?=
 =?us-ascii?Q?BsgXcgBoS8CdKIbJ/YSyjHLvA2n9NnvnjHFQRQ4ZYGCajLKLnVy3MkPzIlm9?=
 =?us-ascii?Q?8e9SLJ4M6h/Sk3XGvi/1ygRv6wcmrm//ar+i4g6MIbiCNcOx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3ad0891-c4d7-4fb1-edce-08dedb972dae
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 19:45:48.8237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e4R7o4v/C9EAx+Bj4O9845TgHlFZMh4doTYgLaOYoIpAuD8HQ/DraubDD7G9TljS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8248

On Mon, Jul 06, 2026 at 07:00:15PM +0100, Robin Murphy wrote:
> On 2026-07-06 5:26 pm, Jason Gunthorpe wrote:
> [...]
> >   /*
> > - * Generate a single range TLBI command covering [iova, iova+size). Sets
> > + * Compute the TTL hint from leaf/table level bitmaps. 0 ttlt means no hint
> > + * invalidate all levels.
> > + */
> > +static unsigned int arm_smmu_compute_ttl(u8 leaf_bitmap, u8 table_bitmap,
> > +					 unsigned int tg)
> > +{
> > +	int ttl;
> > +
> > +	if (leaf_bitmap) {
> > +		if (is_power_of_2(leaf_bitmap))
> > +			ttl = 3 - (int)__ffs(leaf_bitmap);
> > +		else
> > +			ttl = 0;
> > +
> > +		if (table_bitmap) {
> > +			int table_ttl = 3 - (int)__ffs(table_bitmap) + 1;
> > +
> > +			/*
> > +			 * A RIL invalidation with !leaf_only clears out all
> > +			 * table levels above the leaf level ttl only.
> > +			 */
> > +			if (table_ttl > ttl)
> > +				ttl = 0;
> > +		}
> > +	} else if (table_bitmap) {
> > +		ttl = 3 - (int)__ffs(table_bitmap) + 1;
> 
> Maybe I'm misunderstanding what table_bitmap represents, but whichever way:
> - if this case means purely changes to table (i.e. non-leaf) PTEs
> themselves, then calculating any leaf level is pretty pointless.

Yeah, it means this.

RIL doesn't have a table-only mode, it always includes leaf
invalidation. So my reasoning is the best RIL to form has a TTL which
hints the fewest leaves, meaning the leaf level below the target
tables.

I guess 0/no-hint is the only other choice, do you think it is better?

FWIW, a future feature I've talked about to remove unused tables would
generate table only gathers, but currently it should be impossible.

> > +	/* 16K granule, ARM TTL=1 is reserved (SMMUv3 F.b Section 4.4.1) */
> > +	if (tg == 14 && ttl == 1)
> > +		return 0;
> 
> It's reserved in the absence of LPA2, i.e. when DS=0 (side note, please
> refer to an up-to-date version of the architecture - F.b is pretty old by
> now) 

Oh, I see the note is ment to be read that TTL=0b01 is legal when DS=1
and works normally..

> VA. If between the caller and the code above we can calculate that a block
> entry exists where it cannot, then something is wrong and needs fixing
> properly.

Yes for leaves, but, the above is mixing tables into this as well, so
at this point there can be ttl's for any point in the tree except the
top most level, hence the check.

If table-only changes to use TTL=0 then this could be a WARN_ON to
detect malformed gathers.

> > +	/* ARM levels -1 and 0 cannot be hinted */
> > +	if (ttl <= 0 || ttl > 3)
> > +		return 0;
> 
> Similarly, no format allows blocks at level -1, so again if that check ever
> did anything we'd already have bigger problems. In the remaining case, 4KB
> with 52-bit VA *does* permit blocks at level 0, but it should hopefully be
> obvious why that doesn't need special treatment here either...

Yes, the -1 test can be WARN_ON as it is a malformed gather.
The 0 level is just a comment than it isn't actually a hint
anymore. I'll adjust them

Thanks,
Jason

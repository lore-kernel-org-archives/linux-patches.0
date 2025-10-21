Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011022.outbound.protection.outlook.com [52.101.52.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816F61A2392;
	Tue, 21 Oct 2025 13:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761052711; cv=fail; b=LSGEQNTwUX3Yl/1Bf8zPPvrdMGTfptUSM/bShgEQvBLfVZ+t8gmlee+bNhLLE+9OCLCTN5yXk/N2CIfT0Awin2qsq10BtzraX60bUSa1vuY5CHB/pD2/ZQAph8iRzVhuGgIefbIrF9bN8jmapcRdN0Fjh0dgihLOdH3XCZpBEUY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761052711; c=relaxed/simple;
	bh=6oNDdsI4FPrJUzOWlqzQfPhBFg/lbcSgjpq1p/bEku4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=llRt55MsGnDf4OQh80CbeZSleb/No/isAXHxzPYt95nqXE0jOVGUumbzSOEoYr1EyOOEUgw+x7aRQyBsG8EQxhz9i8CY6dHA+NgmdMGHNKDlyHJYnBrvhHQmEAKbnRublZbk1+pMUpsi6BI3KkzvqX+1QIKiq0lfmYv3giGHlBM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qXy+33Pk; arc=fail smtp.client-ip=52.101.52.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qXy+33Pk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y5nT0FH/8PVWMI9tUKC3jFtA183cKYvXl6olcGB4klTvdPqhfgAD5lvrjlqfs1IdumTUiH8nZEvjGjaCEukjNpHhTZBrB+TBya135mwdfSxWLLiLDWeWc/DP/nfkdacM6j8+u+87GSo8lQMdTkPnVOEKEjanhRJ2tW6xaZr/CtmwNWnyX5EXhz8WbppWovrCMMYx/hEL7KVIFVlkFg0seLBSK6ZAdHwlrXdBRc83kVs1H/TXFT5jBgd/r4GfAoklI4L26SnVhcVcQlC5y0SBKZbQvPnpkGmxaYIAyQvSg+CrC2eJgr64AXQhU+qiCt0effUhbVurxJVjAFbOss2xHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0IiIwWn8SN4heFw1OaxyXVgr6Q75Kb99s6z/5Fd8HTU=;
 b=QgaDZM6YGJkLrdCNreIaLlJ48S8a0lxgRA708QjMTTR3jaWWEWauEoHPw/Qqyw5sB6uGT1Wk+MQKYJwhSlu2p2w9zoOCzQ0Zq8Q5cuJztM6IXPZnY7iZFRaHRxKThf0Zd2TIE6ZA5t92WsCwc+TMoisUJyUDMBigqtLfFq/0+jWedrBCd0hzNyvY+d78qQ9A8zLqhtQokOaZmN9QchbqdDkvTjjSAoaUnFTJJ3Z/TwrnXd/soNEUMyi9D7t9qupsfdTDgB7UhhlTIJD7gFSmz/rEOS5WamsdP3F+uEskNUMzcHuaKeBd08sfHy9Uv3CsNIMnJ56UmZeS6NXcfocUZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IiIwWn8SN4heFw1OaxyXVgr6Q75Kb99s6z/5Fd8HTU=;
 b=qXy+33PkPn1tWJ44kkJTMOPF3nNa3wpzrsjuO9HLYz+/X+spFWaq2hsEeC24Y1sceeluppup1SV2ZPhWAxX/vnXlugVJ9KhsFmdRgz+m0fZHBs3+i2vjutHWdMvjxvgYstvF1rLzuGy9Qxhp2VshRSluPJFhbusVslAeHZ0+4MUSw4piH/6w4Q0NL1XzsJ8iEnv48AdC5ZO8RzrFtD9Fg4DA3xtpcUywtPy74HVt2pDoYDlJjO6LeUQgjWLjkPxziikegtBOS9oQHnRGdy5Ufw/8Xuh+F8iyVernIaimkTecE0MkcguoPKIx9yeU+ScuCDammToKj0ybm9TS1s+SmA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BN8PR12MB3604.namprd12.prod.outlook.com (2603:10b6:408:45::31)
 by IA1PR12MB7520.namprd12.prod.outlook.com (2603:10b6:208:42f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 13:18:22 +0000
Received: from BN8PR12MB3604.namprd12.prod.outlook.com
 ([fe80::9629:2c9f:f386:841f]) by BN8PR12MB3604.namprd12.prod.outlook.com
 ([fe80::9629:2c9f:f386:841f%5]) with mapi id 15.20.9228.015; Tue, 21 Oct 2025
 13:18:22 +0000
Date: Tue, 21 Oct 2025 10:18:17 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Tina Zhang <tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v2 02/10] iommupt: Add basic support for SW bits in the
 page table
Message-ID: <20251021131817.GA712833@nvidia.com>
References: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <2-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <BL1PR11MB5271784B896AE595272B56D98CEBA@BL1PR11MB5271.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR11MB5271784B896AE595272B56D98CEBA@BL1PR11MB5271.namprd11.prod.outlook.com>
X-ClientProxiedBy: SJ0PR13CA0203.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::28) To BN8PR12MB3604.namprd12.prod.outlook.com
 (2603:10b6:408:45::31)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3604:EE_|IA1PR12MB7520:EE_
X-MS-Office365-Filtering-Correlation-Id: 737e49a3-51ff-4078-cb42-08de10a44dae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Nf/GXcFjEmAXhGZPIdDfBvbLvHEtLL73nrQyn+DJi3bQS6ONwrWEZBqszl5x?=
 =?us-ascii?Q?YYZkDGiJhraBpZpgTQRl/W0ggeJpRzAadD4Y9qPf206VIiy7JrmVuSe+DmyS?=
 =?us-ascii?Q?5qDP1MgEGC711HXGU3BBcCRFev4/TO7DaCAwqgkwqAw7UD5rGUeePn1ICbsE?=
 =?us-ascii?Q?aXK6zljbB0fmdREP1vhDPYyReCq+5TvjbEIzE7zNIBn8X/J1p6C/i0LO0PGK?=
 =?us-ascii?Q?sg189mvAUdekCruWWrLX0Z+mciyQdRThdb5yrVhXj3Ftulyr8vos/RyrDNoI?=
 =?us-ascii?Q?Ee1xxrlLncubG2GKM0QsW9IqAWa+EuiGWQUqWTbQenSFjLRJWSbjvHgI+ZCQ?=
 =?us-ascii?Q?ZTdOBcID6M0Lw1ibtpnxsZoM3/LW4YsOXrcI9bwIIqcxLcWvE9y0pKd5fCuj?=
 =?us-ascii?Q?4uMspoqOuDX4McbXbBe0RC3N99xem8kC+enhNhs1wpJ23ayWrdjw+2NALHJZ?=
 =?us-ascii?Q?lSzc8Rcr20h25Sb7Nuj3tkOpJrtgIzhrDp2vu7hTSkZBl8dcHTqYyUy6SONr?=
 =?us-ascii?Q?8eMGAkGQf2KYcvKGvnSeeq3ev7UQ2vx0zhJnJ0Q295d1K87iTF7wCRX4XgOM?=
 =?us-ascii?Q?ZQj8NxvY+shKt+2ssxH1jt50L0LmJEwZ1IMnMQecP36Cdc2agc04r6TMUxiZ?=
 =?us-ascii?Q?39THzSmnn+o+F7LpAqhlWHZp1gG6caQeRvOecZYpgUpbo2fwt762zpuDvq6e?=
 =?us-ascii?Q?LwqBMuCClal2YSiIGSEgkfBqC4kPwFsopzB+LEMtjyuytzHoVTCohmCBX0uq?=
 =?us-ascii?Q?ipT7ioiEv0I43xsaK6f3BWpRZpX2VMAYmrZqdCBvFCGSZcd2zmcSC+e1zOPA?=
 =?us-ascii?Q?4H6OXEHh8k16/4ca3zVrX0dcOOSgTuJaMC/c+1zzeasIB9ttuWJLdasUnSbh?=
 =?us-ascii?Q?H4O3tHRijUwCS2oqRM2nH9DxTRYgCq9AIuFJpolmvOIv3+V93UyQrWAsa3BN?=
 =?us-ascii?Q?srPIyILg4CCv3y+6OXJJDOAM2BJPNteev2wKQDQHKBeIjgu6fT/6RSgfxUH1?=
 =?us-ascii?Q?Nx4173HnOoDbmkeM+yd4YV+fb7Q8jyN3dagkVGlIudjUbkv5yuYNzv9A5hhC?=
 =?us-ascii?Q?4DDy2p3XXY6LjSrRlYPIzdoWWaQe1aZ5rzzY7+gUhv/zxVJq5L2nAFbF/XJD?=
 =?us-ascii?Q?PC8sLWqBc257S1ylIJhxC56JVyxkyOBlUX82rXYW3gpBINJGT03Dv2HNVV1E?=
 =?us-ascii?Q?Xk7aV8MWyaOF7KWVGPybXhVwrQDS+YInRI8Y1djybDyVjSbp0TMFB0aGnhQj?=
 =?us-ascii?Q?mgJLtZHQAbOBec/VaOEgbjl2raMJh/9wrb3HtsxPcrYYpmef4o4Ore0tMNuq?=
 =?us-ascii?Q?V0fS0Qi/tiCNZezuI9m1mHQPEle+v6V2oGgDsVC5+5Rx6gk2OfUUSELKk3Ye?=
 =?us-ascii?Q?YqSj3mlL6+jbFoe1hw3Fn+LvBYZHVWF+WLZwnMgQK5ytmIA3VfXv3XEorfg4?=
 =?us-ascii?Q?M3OD8cp0McRJ4srBVaui2zGEEL98XAVH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3604.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+/OvH9dT55YEV1RKG3mD66CHb/pofuSYQU1w4lhsSRxaj/aqNPzmfhtFlW6z?=
 =?us-ascii?Q?dJtQqQFjAIV+7/HdPI+b3QStaTs+IZzxMXvhURhMzeM7VjFlfwcLsKn0erH4?=
 =?us-ascii?Q?fn4Zz9Lyp74zY2CUjaNCC6PSfC7h9yzWnZySfEVq80ECm2TwJyzOcjZao09S?=
 =?us-ascii?Q?G/e/NQy+ZbqufCyvzWdYu9sS/8AhcSEUYdO6+d+cuRrOVChBdd/ng4ZcD4AB?=
 =?us-ascii?Q?K3Vqas9LqtT2sE01xnQPvrgWN6ySxTt8mgK/niaScWU0464SQ+VC8s1dzFbB?=
 =?us-ascii?Q?RKzUfr2h6/4J3JJ1eY6ypI1huysyxaoFHSMi4ShSFPU8Z4FFnND/dq66I7K+?=
 =?us-ascii?Q?n8/teuNK0V4cFVYfDrOY1ybM3e+NZ+qEPgSlaEZ2Z6hLurLvvO835YNrbJ0b?=
 =?us-ascii?Q?DU/T591QO19mq3m75j642iQY8rfsj3r1Fp/SLX1twmaMM0HXkKnlAFB/05GV?=
 =?us-ascii?Q?pXSMrXsvKJMPLs/7Y/ZY+0obL1YUI3V9b786jEWeKSKR1MubhM0YCNS7v+Li?=
 =?us-ascii?Q?7L0mE9e6msrQHm56ymcLy0u/5tKmeT336OWG3HCc+uJB4SBDJhRi+wBmWgpY?=
 =?us-ascii?Q?hAcFBx02yX4QFogX/UJYEqd533rWDT4Vskj0NpHdPv0Y7gGe0ExweUZfJ8J5?=
 =?us-ascii?Q?Mu2nNjcvq5TqBhuSwwwb7t614TjVqrG8j0UQLOiK4wcuOQArYZWxrfZ2lmin?=
 =?us-ascii?Q?8IvcSSMt7rQXO2wacBHJYcW/6P5UrF7dK2Zs2De7J70TE/nxiLJuSl1k9FFx?=
 =?us-ascii?Q?0/4W6hORmQlgPeWpPkvhYw3JMLhTIkivTwc/02YicoO37qSxDIzBuo2p0j8G?=
 =?us-ascii?Q?JkvbVx/V4pMYDxnzsh3JtzdLIE0mJ3y1oTwaw1oXbeVk+i93FmE7FENLdQ0H?=
 =?us-ascii?Q?NRjV50Y9dLS9YPDSbdgYqc1JB3B9/vbtUVvHAWH7+NsKKpPSSeWT3A46X3R8?=
 =?us-ascii?Q?kQrFUC7hhBpVHFn5chmmmfKmLrOc2VkurODE/Yeb8QANVMqS6ZG37JIIcsxi?=
 =?us-ascii?Q?hQqq8gF0GMPSd4sJaioWxPoj40zzwTEvPHUbzA3yCBZNULO8POLD8DV7/L31?=
 =?us-ascii?Q?AwV92p1+jqfSWGBWDQ2pglAHfg4/PWW9qZlv4AE9XGgZr42BugSRgHU1dnAv?=
 =?us-ascii?Q?doyNZsgzPxqE6w7X/BEm/XzDg5ja6SzvHRDy8xGCNdHZaLCR41MOe62X8hI7?=
 =?us-ascii?Q?Y7nOgI1aInbum5h6tVAvCkCOfhE+1cI18RQ8FCU7Rcz26TI91SZqxnb4whne?=
 =?us-ascii?Q?JyQB2MlcEoRJa4e+RA3sWHHlf+PzQT2BuxDI5F/8zDgM2lV23KHRQfoINgTh?=
 =?us-ascii?Q?DF0gPCHjPssQDfrfneqzX7S7zDgECc1+Jx9YnIg2Ul57dC7EXw6Ma8hk3WZ1?=
 =?us-ascii?Q?vOXPCDiQxlgIclw+FAfwsYblxCL+cFetDtRA3Bxt/rm4psgdqBSMsvJiu6tP?=
 =?us-ascii?Q?KEXvsVUmrpEyAA/RTrG36fSMc7a6vBmr5XzvdFfoDqdKxJ5jtzoZ9kguMPBn?=
 =?us-ascii?Q?D12cPgdhoAdfwx9YcWLn7s9Be8R5O/FduvjWV45YsjPJutuGKf+/7E+9EtPi?=
 =?us-ascii?Q?30OsjREvrGfUluRufUrrXXuZ8nw2lovdCOzk+gQ4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 737e49a3-51ff-4078-cb42-08de10a44dae
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3604.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 13:18:22.1779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iwpaUT5G65vk9xUOOlLOVU37xeIU/2WJxJZ27DDh9ddP+6vw+bJoTDUPZf/2eNSQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7520

On Tue, Oct 14, 2025 at 07:45:50AM +0000, Tian, Kevin wrote:
> > +	if (PT_ITEM_WORD_SIZE == sizeof(u32)) {
> > +		u32 *entryp = pt_cur_table(pts, u32) + pts->index;
> > +		u32 old_entry = pts->entry;
> > +		u32 new_entry;
> > +
> > +		do {
> > +			new_entry = old_entry | pt_sw_bit(bitnr);
> > +		} while (!try_cmpxchg_release(entryp, &old_entry,
> > new_entry));
> > +		pts->entry = new_entry;
> > +	} else
> > +		BUILD_BUG();
> > +}
> 
> so if CONFIG_GENERIC_ATOMIC64 is enabled then only u32 item
> size is supported?

Yes, that matches the other cmpxchg operations. Fortunately all the
places that have 64 bit ptes also seem to have arches with 64 bit
cmpxchg

Jason


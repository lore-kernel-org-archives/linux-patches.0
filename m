Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011062.outbound.protection.outlook.com [52.101.57.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0598339702;
	Tue, 21 Oct 2025 13:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761054616; cv=fail; b=Pd4qafo519pRC93nKRTOMJ008r8Mhpx5oGRTLDyrZ03uYDcYITCqggRJ6stS4o0VIyx26O2/Femys8Z3Uf8gR+hKG3Iqn3s155JbNBxvaE21tRxr8mDa6cVljVuOQfJ1QQ+DBKZ2jNrzQzfy0t61rdTf1ojZakodkincifpHXBw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761054616; c=relaxed/simple;
	bh=8T8WHSQsRZQD2pLrOeqEhvAFjVQjaBw7W6dRi5TZKD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mgYVd7GOWLxvfTR9XiYM53PCVtXKmCz5zhw6/9b7GFTqvSX+OdsbyX+xMQ4pMg3QBo/lj0dzSJrKce3nPyZwriX+4jZf1/xs9/YyTyHjh52BicfMHlDwTzdmWkpYhzJtx4ReJV477SwUwAa/oLjG2/cvCakKQJAmKaKju7tdEKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LCqoIJ7Y; arc=fail smtp.client-ip=52.101.57.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LCqoIJ7Y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oyEZ/3Ay3h5chBLzpTqqlAfQCd0xKUrwVjfLYJe41Bm/e9uias40gK/Jh4jZj8+dIUgFxs2ReyqL2cxlwBh3N94TgFFO0vexN2DjSUVOUzzHAYGn9toE8xUOaripVDsTIyp8Edpcf6PNW+tN350w9v3jE0LVTvV+lk4lu9ki2OhApQe+1Otz8xNxiwaFL10W2bmNiqH2C1ewQwdkVhMsx33hLNDKAdQviSqv0vAAm2bWyF7q4KkIo4At7jMjCkxv6nsuD19bP3FiGMvxhbPLwxj0eW8oDdkBT/n01GRHbFktd1jVgOWilmo5IpVsuwBkDKwRfeuVtjkR7bNW36/pfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HeWtN9H4X9m1PGa0c7otUHYnmol/JyzDTmSjuc8C8To=;
 b=glBTu3Ou4nVsKNywdWXkY/DmTjshQmLqbBYJFGXDpA/HqJPk1NLx7UPV32o2mrzbTRkkuc/Q0eSAEr7AdBAUFtUnt5rF/Fvj3yxKWaClcSz/Pu+i19/5Fg+8ujGtsVRlmFJwjLRVyBHzoP5DsueNMOfpXuhJZHxd24t1F0kwT2pBgrkNI0jt5KtmrlzW2MRXeo7CklhocnygLDHusThlvyXOzXHm9YNWfIFs1QmeXpEqBka7z+pS6QDtrg1qcHrkEI1umjO/D5tNG8JkXinhNSr+iuEqR1fy8KUVAGvBTX9kJJGaz/cb/MX+cYRtL/KY4H2Roc1A1bzkNBC9GYx/wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HeWtN9H4X9m1PGa0c7otUHYnmol/JyzDTmSjuc8C8To=;
 b=LCqoIJ7YiNufivLJpXoWmS1mfwfYdApdnDeQUIRLLmdvILBwRXL0I2ZbbUJuVG+fZtWYsENXV3lw7lNM//XheHU8KLQHhbPXXI4HHj35dISH82fYIWVrJcKyIyRZjOehtI636f9OREyXQW7lWdUX11SWItlmWZyFkdqN5bewv6vpOyPXiOtBk9rVGry6DLnKcMTW2MbPsMtFEgxYZSqyIlHYCJvo2msLiRRcNGX+O/kuojdWDwJ3Gz0EqKKE4N07NjY2+phTjrn4n69K+hEJnAurnxw1pkfFZTLHJKdyzvvOQD3ZB0YlljPb6AZakDYLgCI6L2Ww9ewIt7YvxvrxdQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BN8PR12MB3604.namprd12.prod.outlook.com (2603:10b6:408:45::31)
 by SJ0PR12MB5635.namprd12.prod.outlook.com (2603:10b6:a03:42a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 13:50:09 +0000
Received: from BN8PR12MB3604.namprd12.prod.outlook.com
 ([fe80::9629:2c9f:f386:841f]) by BN8PR12MB3604.namprd12.prod.outlook.com
 ([fe80::9629:2c9f:f386:841f%5]) with mapi id 15.20.9228.015; Tue, 21 Oct 2025
 13:50:09 +0000
Date: Tue, 21 Oct 2025 10:50:07 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Tina Zhang <tina.zhang@intel.com>, Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v2 04/10] iommupt: Flush the CPU cache after any writes
 to the page table
Message-ID: <20251021135007.GC712833@nvidia.com>
References: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <4-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <BL1PR11MB527176E811B4B5C8DCACCAD18CEBA@BL1PR11MB5271.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR11MB527176E811B4B5C8DCACCAD18CEBA@BL1PR11MB5271.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0020.namprd13.prod.outlook.com
 (2603:10b6:208:256::25) To BN8PR12MB3604.namprd12.prod.outlook.com
 (2603:10b6:408:45::31)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3604:EE_|SJ0PR12MB5635:EE_
X-MS-Office365-Filtering-Correlation-Id: 165ba9da-a2f8-4442-921c-08de10a8bfbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zysAfAmPL9s7EfQtGki/6sf8+uPW5M0a4mGo596LsF6lL/VTCWaA6ATWZIjm?=
 =?us-ascii?Q?tvj5PWeCTx9Y5Us+kIsAyvgSo9kyBWT3MDCZuN69mA2fGgj2oOETZSkrBhIr?=
 =?us-ascii?Q?7gdGWHnvgw74Mung22HGdYRRfADVVyNAP7gaP+YdPhdya3yyI5H5aAXbRuAi?=
 =?us-ascii?Q?AuqB29K/zkFOaM+LXCYzPQwKjwTDneNZA00EVS2PcJCrNF6bdWG30lMOSl8J?=
 =?us-ascii?Q?x0jaPmsMfXdeSWgMYE3OATrOb/nChxPOIRmhtHQPSpUafYeTLV1OCOJIDpD7?=
 =?us-ascii?Q?kTfwsIMIbErkddT4qM3xmCQWhdmG6eX8HVpNABez3tXT20y7TG3LtNjAGQAn?=
 =?us-ascii?Q?DaWLXdAr4jBjT/3vS1aJnX4VIJPyJ+WpqA8RaDgMmemL2sjhkY4kd67Cb41j?=
 =?us-ascii?Q?9w1M0+gf86iWWcCP2lFJiJH2aA4V1uQfsTaO0ZCfAEea9x98RH7jh3QKSEyp?=
 =?us-ascii?Q?sit9RRNQObaE/qfq6yiRHWoLqc5sik4+S33qZqUieOSxNzWbck8w4w7qpFBK?=
 =?us-ascii?Q?m0r6s3OLIJS0VyUdsIOPgkprufHVDwij7tmCVuSoyjBmXa1yXG9DfKKTeg5t?=
 =?us-ascii?Q?VDcSJjxixmvEP1YQLV+9QWGOc+qR2PR74GZSczOTiFioadFoD8VZ+zfcaHpv?=
 =?us-ascii?Q?FSHp08pXWHuuhRyimetbfPS0eLDW+7c2kOE80mgPIJuvMUH9ra6Jx4fZ4r5K?=
 =?us-ascii?Q?kzlj8YqEzImd6z0TuZojFl9IAeesTWsDGCW3TmayXTRXmfgBAcTorck18aZG?=
 =?us-ascii?Q?vn91fJsqZhUgHXuzBtER2sQ0ShLvd7AEZ3eAshjsMAVRWhigKlmfTe4zMat0?=
 =?us-ascii?Q?dLGtkhQJ0MwV7+9wqZY/Fav+mWIAG6GEvc3OJ7PiPyEJ5ZFTCsimjKpHx+hm?=
 =?us-ascii?Q?AYrCsl+OT5HZvW9vm1Zb4hpGV4dPwsN+JaJEnRwgMISh+tTmJJvRI7WDNJY3?=
 =?us-ascii?Q?H2EMMweN33Zisf8OQvC/L+rfFJ8/C/AOR+IL02Pp6AgyJ8OBL8eLH8+oruOX?=
 =?us-ascii?Q?d+/EY1dsCXgBhzdb2CHPcnjz3HHggY+v3SWJb5ywISVJRjMYQskDGyb4JaZY?=
 =?us-ascii?Q?hWQaCftKt6URlrZUKObjjWHW2vjvMkDnS16N683AN2pfBEXrue2/qB2/FAOj?=
 =?us-ascii?Q?UUFxssBFcU8RBypXtjxfn8NDNxia9nyF7QllezvbIMh0mbUDHWZ2vTIOoAkw?=
 =?us-ascii?Q?UNclUFoNle4Tb4hJOBY+YMXzAVz/V9KjbMz+ze4kzpxDgyjQcJoD/g59sDGC?=
 =?us-ascii?Q?vYQSP97vplbt3J/GOpMpH/oESUrcNPA59Vsds06rzYkSPpXzYmqMUYmwSIR4?=
 =?us-ascii?Q?zgEc8Hf6mfl1vSOVbpbTpiBwqH701xc/umNpL1dwOE5jYOJllkfleOBa2fVQ?=
 =?us-ascii?Q?42EpdeURUxeO9MuxuW2qvB93VSjYiANW9quRtv0fA/+dZAeSsUE2OILqS2ON?=
 =?us-ascii?Q?TPRDmYOkvS3WVCYxp0dKFP7vaviKCW/y?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3604.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/3rxTM3jowPbU2vMulHwwhw96e5MmWQoT+bBLPoEoFVh3U4i9x5SJhstgcaa?=
 =?us-ascii?Q?Lqxgj5bSPdORyli/zA2BkQSNk03zUwexzx4Zm/i8wtXnb8l53NGSMMo8+Mds?=
 =?us-ascii?Q?LlprnL+tzw4X+mwRXQYFXrWgAjivfWdkaq8kFcYBZPTIp7aIY6T5aeywJot9?=
 =?us-ascii?Q?XNJRX9l/n1/YF4PjWgRIkBw+zC73ujm2tt3/BTv70SOoSfiA/nkVBGBBQ9HE?=
 =?us-ascii?Q?u0isBDWNDgH7dx8rCYzRc24qof4ps6HeaEbUggx4Zp+9PIBKkQHYmMEf3REF?=
 =?us-ascii?Q?qQ+AO/ispCZsbwAV+Ai2QYQ5m64dImNATMVSTo1HckBNmf1W9AB4dWE58dZz?=
 =?us-ascii?Q?wx4iB5oCXe0Gb1/vCFfZioQ/5yoMjGTpafyNqKLQf58Qwu085ACfa2UBCCzR?=
 =?us-ascii?Q?sGOV6vsIIj5TUlFBz+nqJzpW8bamOcocVcKMw3Q/PKf8iEtmBRX9S8jO6ZCY?=
 =?us-ascii?Q?fPkV30VVIh0i4PKBG536aS/URYAUb0cyzfMeO3A0+4N4jmvR0B71TdPSLjis?=
 =?us-ascii?Q?ggoTXkCmjgBZSC8aE0nMuPh0m2TZmU0btTNqDLavjshn29ibRWK0cxU02+pO?=
 =?us-ascii?Q?g1oMLQQt3VOJknkxh5bBzwrRVqSUgbD4Ms/ydobJeO1jh5nkfdknkAic5+Jk?=
 =?us-ascii?Q?AdvQhTZPiJuMzwLIyrMlav6lzHBpfOo3bd1tX6Ztw+r50aQhFHqdl6B3n0di?=
 =?us-ascii?Q?z6H8eknr7jJUpI6w5xZLAoIjo0IG+DyG91+fzpMO+qQAMyAewZfsgZaHVNSS?=
 =?us-ascii?Q?r1Q8CQ7SjqpH0rF7nWPQfEsI5MV95mzH1RZbk63mhUnxgbcmLiDB2lFhBQml?=
 =?us-ascii?Q?/QKTlKKFP7dkA5Sd+RoMTE62vW5fTaisVrkeIsrvqR60rVzdVfskUTpZwdRQ?=
 =?us-ascii?Q?90p2KlmpjUybsOSsJQWhkNoUopvJsyMVjjkHW1ihAJyB9/Cym8nEJbrEcIhB?=
 =?us-ascii?Q?582AeJHKNmNEDsOVxowEA60E854NMfEz8nmBtkVBvFGQYKKe3Ag9hLAI0XcU?=
 =?us-ascii?Q?djb/JFGCfJkF0BFDgW+15/A2klhD9A8z1q0xXVUpFUQmwMUdGNG6oUdifUCj?=
 =?us-ascii?Q?FnEG9z8K3oyhYLsOqgaCFSKsQHnkz+hsfzTcFoeJNJEJzqAWZH2mXGnw4e0A?=
 =?us-ascii?Q?Xy2nV/lCdNCQX8J/mZHl5flgrUXH/KXZ+FL6ztGkhxJQwlk8D07HYHco7dfx?=
 =?us-ascii?Q?7y2fJZeq4YokjL2wkeQ80qW73cpYBrHK/AZ3X4hguDglVUPZYc9JyGsP4a2k?=
 =?us-ascii?Q?1A8BxiL7MVaz17HlSfxoS7eQSQTsD/HkDZaM76qR6C65j11PwQob6Bh9MwQQ?=
 =?us-ascii?Q?7zJMmt5w5h49h8XO9nFLWYpPN5SA/qcvtQ+MykQfqQZnCmm0dxu53tIsu/j/?=
 =?us-ascii?Q?zmXieUpOJP7ba214txbg6vCR9/rkk4PaEk4nSfj1qpCgW6OpDY21Hlxh/mQO?=
 =?us-ascii?Q?Bz2n/cceRwkiCLBihidO2wlPY82dgsmFkgjoId6IPRtpKqsOBtbugfdUaU9Y?=
 =?us-ascii?Q?r6SuIYUbzDaaSCs6vbL3e93WlB0REo0TVbU1RGUsezQLoOUBcMKwxUzX4Wi8?=
 =?us-ascii?Q?D/3lA1Uj97bHPx4+HK+y+VuG3ohbU269K4F5KQEc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 165ba9da-a2f8-4442-921c-08de10a8bfbf
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3604.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 13:50:09.5175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3uFDuCKV0GPAU5EQeg68CcMCxU+pFaf1I5N4qSa2b04kkKcA6aAXCFocKgIl215A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5635

On Tue, Oct 14, 2025 at 07:53:23AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, August 27, 2025 1:26 AM
> > 
> >  	do {
> > -		if (single_page) {
> > +		if (single_page &&
> > +		    !pt_feature(common, PT_FEAT_DMA_INCOHERENT)) {
> >  			ret = pt_walk_range(&range, __map_single_page,
> > &map);
> 
> let's add a comment here for disabling this fastpath.

		/*
		 * The __map_single_page() fast path does not support
		 * DMA_INCOHERENT flushing to keep its .text small.
		 */

Thanks,
Jason

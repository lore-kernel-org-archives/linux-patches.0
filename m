Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010006.outbound.protection.outlook.com [40.93.198.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EFE38B7C8;
	Fri, 30 Jan 2026 23:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769816684; cv=fail; b=LzBzBnxmC8ZecYCC6qodiHqPbGMzPHPp2Iy5NpqqkxR6OyvU/Iziptm6epvjxMh728yDq1ZG0Lx+cHjPUqOKrrpZZVD7lj/jxhHcHCtWNSl9fsOeVyyQ3HkzWFH0TiSHdM1W3XYwjn9Am8hnvtzXv75H6mbCbDVcFGmg+PERZ6I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769816684; c=relaxed/simple;
	bh=krarprz7nyTyIhMiR98LvB3vR9Xb7cCeurt6Nmh8xV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HRe8YDkTn2zjWZq+yEpjM9UPu/NSk7wUE0AjU6JDww0HpkIUD/nnh6FQA4355NUoxiOLajp5UDlFWQUD80wkeaSBDLcWegCu1qKLJLXJ2AtfLoNwi61urg/KaWLZywNDPl34DUkX6MCFg9Qp5C4YWRdUMGd/Lo+y1StM3I4UloM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HzHmjpwL; arc=fail smtp.client-ip=40.93.198.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HzHmjpwL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UtSIUh1rui6ypJ3cM+ai/vd1SBvPHDYQPAYNNXSHaO/AdJbp+MJ7SqCijz3gF6A45w5LEY/tjo9RbacyamuSiStadS01mP1+B7rsgdnIDuZ2typVLrJOmw3ZBLpHI1WiAkyEVDqyHmxb8i2Z1aZPkCnzbZiZD2QThuH0gJY6UPIhxbtVIVVMr9905NETyLcJkOmjzi5dbaCiy/CGY4kC0Uq8Rlyd8tv8SK69jogly40rfGUpjD3PP3RxkN87avFDfPSdQf9lZuCGjptjuXabBqnEBvs1VqknIhotk9dY+BNtor0ZLM3MbvosREQiuyBTP7xjWQwbjsHq9ckjLGBYXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zt+Xh3O5hT3lqmi+EeDHacGZjCE1M9+1HfF9KHXkJhM=;
 b=y8BPtitJtxVsjw01xOEHeFBr/7cibR0YOAZIzm9HvKxcvi0OM8JAcoIf4P7Z/3rnv+DeezF2Sf6G5Znb6ADbD0chbIujKD4e78R2v//J4lvbd02jEijlCzXUDXdnl0NqkCEvDDxhexdP9goPyeSEI+IrfnUi67R9iFl102RDD9AHJBryjZcisREtc3iTcw9m7A8V0W9k/9xh7g/HKPnVbdBEXNrbVCE3Q5sIOPyDjc0tzpB8sQRK5LGFFCGHLSD51shFyV4APWZxQnJe8naoEzhQ+zc70BO42tYKgXwun4fhpxXKYauhsVDRS/ny30+MX0MPy1rP6peqlDk3bT/azg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zt+Xh3O5hT3lqmi+EeDHacGZjCE1M9+1HfF9KHXkJhM=;
 b=HzHmjpwLJHOoLAZ1JefFiFu5Ha48118Cesf/HTT4EJW5xlUQRbXmNe+t8TdeicxOlgNDEQDosUL4crDhZyoKIL9GOvI39dvjAJBSn0bvFYbYYXDiJiUqNyl3iNpuqUmbpW8hksuZC5SGW+YBJ41dazPBkL776twG07dZ/7TMFuRpjTuQlh9vjTCuVir+ACrz7YEdYoKBc59PRIk13grpBdjDQKzmYT92tBMKHJCaDao4uUcRBTehhylr3ccSZM1w/OmnJEw2xRnIdbX08kOp2IzPuHU1DDpkCanDdNwUA+HIbnHIsRFvPxbzQzEzVQWNNWcx/OIhtFcsozb1V+Qabg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MN0PR12MB5716.namprd12.prod.outlook.com (2603:10b6:208:373::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Fri, 30 Jan
 2026 23:44:35 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9564.010; Fri, 30 Jan 2026
 23:44:35 +0000
Date: Fri, 30 Jan 2026 19:44:34 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Andrew Jones <andrew.jones@oss.qualcomm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>, lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>, patches@lists.linux.dev,
	xieyongji@bytedance.com
Subject: Re: [PATCH v2 5/5] iommu/riscv: Allow RISC_VIOMMU to COMPILE_TEST
Message-ID: <20260130234434.GK2223369@nvidia.com>
References: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
 <5-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
 <dn7bsft2qvjod3sm6omneq37pwr2jtdzgobapy6obpgccg7soc@ctvs3c2w4vob>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dn7bsft2qvjod3sm6omneq37pwr2jtdzgobapy6obpgccg7soc@ctvs3c2w4vob>
X-ClientProxiedBy: BLAPR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:208:335::28) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MN0PR12MB5716:EE_
X-MS-Office365-Filtering-Correlation-Id: f413998d-452e-4281-9229-08de60598623
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1opgstu8I8HcvS8mQyzDnXib6oLgVV3nardfmTUKu46Sqv1U7u2DZqslPZ94?=
 =?us-ascii?Q?8cvsBtgn81TzWXwEYcsOmJ6Dp4faPkztuavlnLQ8gGnBxwx5x6SE4cY+2k2x?=
 =?us-ascii?Q?Jv86aHHdu3khCillNIvJQLoe9HdRu4N2fspBADzHrOvEP184Jv5MO1UwWKTY?=
 =?us-ascii?Q?8Xnh091rA64O5akGy99gVmLIINJDUpprCSItC0DzoJFy+50r9+QC3I2bhh7R?=
 =?us-ascii?Q?oEC5sySbZQI/UP2LzJ+CSzBR98JDLAMQCqJwZ8ZF6MEa2Y3GP655bBfj9mVL?=
 =?us-ascii?Q?zBs4dZNH9Qy0zfy5zyuAZwo3JS5SdaOGH1c5sXdWszQfSjbPshgHtzph/NRA?=
 =?us-ascii?Q?PERynVQ8HkKmsVyNP/9dNWNVfbAcPcHogHfNl9HAya3l6lkwwM3Fh+HUDwax?=
 =?us-ascii?Q?1YtFgLRsYZuEIG1eolqZU/3ZmAF5TzLAuS0S18LvO6BdjadjqTVN9zujEvM4?=
 =?us-ascii?Q?rYp0C6nS0BtSrN/3UFGAhJaHWtadq+JP5vLE7RE1XUdpejModNG0Y9aSRFAF?=
 =?us-ascii?Q?03TeO0YtXCsjTGeRCTYmQe5FQs1gl4zocbVjE4CZ7xwEGt0QsGgWwt2o7i7E?=
 =?us-ascii?Q?fI0xjsqI7/KUg4d/ys4nV5LbyJrIoZ4Dan8QhsAQbjfnjoQ1KQ4dprhgV1Y+?=
 =?us-ascii?Q?4mJocBWfo8m+YHAC3/IKWUhMxr0WPij6OxDjHaxwPZacRSC0ZIoPEsGAeHm7?=
 =?us-ascii?Q?yY2YtHHLgcg4s3ts+I6t0bkraXNqUPLpBFNqfADlv0MANI3wN/xLFUNYnugj?=
 =?us-ascii?Q?Lle16xSEXhFQzyh1l2pyULbTDGOhQJ1v1+Op9Larfvfc9SnDrDzHoSe7te3v?=
 =?us-ascii?Q?9kimn1T/sKXU+xUHG+/gsWJZvABRNEeK/ASh+UGNnIGHjYayHs6APW10AFa9?=
 =?us-ascii?Q?fde3HnRDlbON6EFX3fE89iK78n3nM97UdqbfJYlRJEDJ7XI9fA4KAJ8H7gQM?=
 =?us-ascii?Q?fOqKXc1eLYPoWE3CKGlwZ8Dfl7PtszMacFDQCd0SeVE5peTLDajF9/NSH7Ph?=
 =?us-ascii?Q?pAW5ay/6R1//zJRKcqStTioiJqqPNsLmcFoQ4SEF8DEcs3SKv5A5rKcpQznb?=
 =?us-ascii?Q?falDsM5UzhcmEv9DICU3AbXmbOf0owMQuAYUqJWRHyDEkHJPG5h0jXYUrGjN?=
 =?us-ascii?Q?NGUYv4wYl5YjJmiUkyaKgYgiZkbFhkMVIP8Mq3HN9O1MLfR0hwW3XRMzivE1?=
 =?us-ascii?Q?M1jE1lLivO3VXIxRx0LSZBBc98mwp6pVAvH4ylq/eCDJJZGuAL58CAGXmaTV?=
 =?us-ascii?Q?DuZhK6mTLOGRCSsF6E+g9bwJm3sv0RhPXBJ4CrJ9LPUKQmFpVhVVmh3DMr1W?=
 =?us-ascii?Q?WfOsJV3Ib7j2kMt7B5gCq1i+eCvXU9SUsXFPPzXPacdu/2qwZE6fpYmz9ejx?=
 =?us-ascii?Q?znQQdMdRfCYtYT48tfRPYGVgxp9fquU2gCfI4VSrN4zh5q0ZtsiBfR4gOKb0?=
 =?us-ascii?Q?30aOeWkPE1J698uGYq7Sz6t9Oax49pO0cRTxIN1jZ5m+ndSfBuKMRs7wVyOR?=
 =?us-ascii?Q?+EnDwzJu47YgBEqmqo5/62x78XcbO2b/nQZA5plvhExO5NH7orCPpOrSIkc6?=
 =?us-ascii?Q?ndhVHrMiRR6y8/xJzYk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L3tcgpZWmmXTR8IP3uay5cP5PZqSoi/dC5oaaGcQb6Dcuoe7lbfBVSrG1A0x?=
 =?us-ascii?Q?qj+YY9pYf32MGW+Euwmtz2hxeZiTcbX69i/fsVZ9N0cnRodw2qCRWWZI3qpe?=
 =?us-ascii?Q?py9V3guVU2zaLSPULuygL8R8jOFFBfiufT0KqWv8Jf71TV78GeZLK3Ippmnq?=
 =?us-ascii?Q?fk5QsZkYsxhDRGsxnDK9xcMjVBXxch2rj+Klb+CvIhBFHIUnaPI2CO6eTM6Q?=
 =?us-ascii?Q?9u0Wte5olNO/c8EM2CC2w6KhZ+/6CC4bbrCIUpx7kMPjiIf+qnZ1NpwezEt3?=
 =?us-ascii?Q?ur0Y9fRPhcMLPltsAaVNCuEnQfvOAvUHjZYm9rj/yPgHmdnYH6eQhD8VbW3M?=
 =?us-ascii?Q?ZUBQcYUjKU64CvrPRXEoZ8GZER5SwS6vpr2SOhF/ZCskp/YtGCGzOQl03XSV?=
 =?us-ascii?Q?6h5lEtWGs/AV6I1FWIbXwOPftkb56zgr73zuq1XkTvIwHOt36XDh/NWNDnGv?=
 =?us-ascii?Q?gOP5nzqYvPUAohnNa7cGacE93eTSRH+ycYTpYQpnvf5o7K2DY17UP3yvP2AH?=
 =?us-ascii?Q?rS4e/SuP5B0VFYbGcv11/lgtBHzhQPN5zSxGjy6OOvidRNPglHRqi8J2eWju?=
 =?us-ascii?Q?8I049T0k0Jt4vD3GpaWcfroEn87Sbk9ugBUprCG4lyGrnejQIgi9uVoUF9SC?=
 =?us-ascii?Q?5magGBiZ0DHur6ka9niQB13aNJSJ0UEZvdm3P+I3rw85i4QUJdj+Vbkb3RYR?=
 =?us-ascii?Q?u10gRyghhUBgOGimQ0I6GgWhsyhiWx17AFX3AkKoxpy0NzBAam3RZ+dPK+Cg?=
 =?us-ascii?Q?trZxlvGDqIcdMcc/9kCgOnG70Y6wxBcb7yrdshhyWkjMwRmH959RfY0PGROK?=
 =?us-ascii?Q?no8Q5g/tAIIpr5iFqGS1jnqhSdAHZ2FkMWdWar9D/+P/3j8mlE7kvXz/X1/S?=
 =?us-ascii?Q?JeOIpoRKHA2Db7FiSAAqnwRR2p08mMbjlmMxtZRwF5cpjiWBnzzoRiBtEAL6?=
 =?us-ascii?Q?8BeaSFqb+T+RS/bjPtTpWjdrzzT1UGVgVCWpRYOCc1JPwYl3ViCFE/7PlSNz?=
 =?us-ascii?Q?o4uClRYi8Qj7pOmcblddN19PLwYk7sh2bUdElH9Mvgewg14dSnreThh1N3U4?=
 =?us-ascii?Q?1zMqLKvCBHZp51qgO0OrwQl7dXkmb+xOb+NzU1Rf1Xarm0NnA+mSKvZhDh03?=
 =?us-ascii?Q?BhHlEh617lLlltJkuNlZsl2QVaw7G4jpplUnpoham8djjioMTsafqqz6xiEh?=
 =?us-ascii?Q?aDlF3mZKiXU6LtGpP4v1948UhDRC/GuOyyJ9mdWW1lnXMytTjFRVs4R/ap/x?=
 =?us-ascii?Q?oraJZHF+bRWPjI7w+nQe/UzEmjFd7fx8wLUVrc0/gznv2uWuaE6noOJUvj/g?=
 =?us-ascii?Q?E+oBskMPbYhlnjtWjGkIcqIq5x9toqew5HRtPde0Wiq6zJZ7pSvEpOLpk57T?=
 =?us-ascii?Q?CDs5z4Xf6AvjjoEvg+7kaxz4Q44d/Rc4h8OYyNYKYaL/ae1ZBZrTRAGHe9lS?=
 =?us-ascii?Q?q36hyl+ynBYb8YzfIMzQx9VzPgDAs3UIT6rvaVcAslD+IBTiBZoSpjM1oLEE?=
 =?us-ascii?Q?vCe3jMXn1b0LKdPTmAwkBkgzhR3ANPzW7gonrAjYTVIih5Yf8kqlpJmVSaTN?=
 =?us-ascii?Q?lZKroAXnqQQ2n0yipBqWKkh4LsxXKJ+2G8YrNCo1+TslK3Gu0c6hqmtSDGBI?=
 =?us-ascii?Q?K767OXq3VoEEKHGF69VpAywSwJV2HUYlgMDGlKIs53DL+LEuM3oxQAAOIFnu?=
 =?us-ascii?Q?vSzXVmbYP/pp6rM6XHl7V6lKaWVz88/SGTWd+valZevfKA8ix6U+nAZVTK2a?=
 =?us-ascii?Q?QvlJ1RUj4A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f413998d-452e-4281-9229-08de60598623
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 23:44:35.4148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0MKaFybygK/mvq5fh/sDl0uNyVj1PR/kjcGXaZgOFGQHfC0l7F41ObsaQ2zhFAhE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5716

On Fri, Jan 30, 2026 at 01:58:51PM -0600, Andrew Jones wrote:
> >  config RISCV_IOMMU
> >  	bool "RISC-V IOMMU Support"
> > -	depends on RISCV && 64BIT
> > -	default y
> > +	default RISCV
> > +	depends on (RISCV || COMPILE_TEST) && 64BIT
> > +	depends on GENERIC_MSI_IRQ
> 
> This new depends isn't called out in the commit message. Maybe it should
> even be its own patch with a fixes d5f88acdd6ff ("iommu/riscv: Add support
> for platform msi") tag, but, either way, thanks for the fix.

I think if riscv has a 32 bit configuration with iommu HW available
then you'd want a different fix to make it work.. Probably include one
of the high/low headers to get emulated writeq

This is just intended to make it work with COMPILE_TEST on eg ARM32.

> > @@ -436,7 +436,9 @@ static unsigned int riscv_iommu_queue_send(struct riscv_iommu_queue *queue,
> >  	 * 6. Make sure the doorbell write to the device has finished before updating
> >  	 *    the shadow tail index in normal memory. 'fence o, w'
> >  	 */
> > +#ifdef CONFIG_MMIOWB
> >  	mmiowb();
> > +#endif
> 
> Taking inspiration from powerpc we'd put the #ifdef CONFIG_MMIOWB in
> arch/riscv/include/asm/mmiowb.h

That won't help compile on x86 for example.

Thanks,
Jason

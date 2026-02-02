Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011026.outbound.protection.outlook.com [52.101.52.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE54C1FF1AE;
	Mon,  2 Feb 2026 14:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770043055; cv=fail; b=kufnIi8oDg8xzAdQRcyl5sG7Jf0WzlKlp8XpUyfzKvBqshaL4GWBvwtIvdKymbJxmmtLSb0FCH0BmwdfKocdWnnsiVm9sPIEpNn8ONM/zeLX/ag75ilqQooVLK6fMI9Agz8c/bfrdmwO1Dl9xbTB9SKlaSMnulwMUqXBrMj8MX8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770043055; c=relaxed/simple;
	bh=UzWgkC4YZk9LxJgd2GVl9Wtk6LXzWM4qkAJ8YuYTPyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SnJgCPbhP5LkERzjtEtnlAsl/uhR6bfFhmukfhN+Z3eGv3cwsbguhJAQq7p8qTPm+FONaFRF2ZwKgJTbGNDw7fVaOv5ihUp9YVAhywGOHqEivz2V0IbTn25wA3LS8ijgi9PL+BQFna9t2Im4Y6kSnx7BF/15CJF7dQGi6hd+JVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MrdYjx2D; arc=fail smtp.client-ip=52.101.52.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MrdYjx2D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ki1H/7D6CeTt/8BaTMA98t9p349O0edfQ2BdipjIN65te3pBJv0QF9dmFtkS3xTZJcvp+GSWlvtUNOhIgzzUs+XvmNQZ2bFSp/V/qwdh+lYMtz75nstvknomjbLV6Nn4uw3Nrtt1XmOPD/M00h+5gS4FRr/xm+a9tzT0BK8EEo7S5ZqmbXwaCaoqot0Q69ppAgsMTSM6bignKshLpBX7Y/G3QyCqzhcFFau+daZ4nsl263InWoTjS2620oGif7FsQ67/Z0ECsBcHV+G/Il0WjmXznlJlqjVEeZb+Ge1vjmkWmZmwTxVLvfgK7gsl6m/VsED9jFF+KTDoctEakGQVPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=60ggr5rgf7EUFRejUFM0WvgmIamQ6Uzi4r4RCYyvbd8=;
 b=mxwHQ4KwcI7HSqP3XcFCBW8UPuW+lt1rDhyrnq+CTzy8gK5qTuMVcgAX/uf4qmBC9mNt+9wcnvpZhyB+tuM/sJfTV8UxgJELBRKJt6h8YGKxjyyDrcPdLizN/j17OmzOcDVPuhk3otZAxTHxUtGjwwfJ6bzCspPZhfMXyJvWr8VTyqAtfdI4I44gfn1eVcufi/O9o/8ujFcd9otkNOvhNBblBlYWBTfQKpvx6PCF2qFu0xol6nnBAGBT4y6sQEg6P7McCaUSiIjySVH+BeLHV4+PnNeAPVl3GHD295g1xSnt64ROQsGz+1/3ezKvdl1Dj4jwFlfL1v88dJQp0XQLZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60ggr5rgf7EUFRejUFM0WvgmIamQ6Uzi4r4RCYyvbd8=;
 b=MrdYjx2DZvpF9xKiVvEzAVbvA9pdHgoXI6xAgCMSNkBZR7yDo5BwSfqvKpZDqx640arbl7KPMeTJK6xO9/GU5cHC5/BfUWRK/TJFb02W2qcvxAKyUVoR7cBVzwwSF/vIS2rcLUTZDLzJz+UOaZ6lZx1DMXp1c8xUpI1mcQiEVXy5LCwZReTMNXBNbxYlUz3iBxCdYUkDPuof6sBKUkzRkXPUs9NRgOkqWCta2ZtGbJH99JRfBO/Enl5LhviMBb57GOzom9RqWi9wOaeIhJNrm+240TXrWZ1eJGCiIDFRqGgnzavjlhERJ0dp7ieOqyz5vBT814dBZmXOPUh8VcjlnQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA0PR12MB8421.namprd12.prod.outlook.com (2603:10b6:208:40f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 14:37:21 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 14:37:21 +0000
Date: Mon, 2 Feb 2026 10:37:20 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Vincent Chen <vincent.chen@sifive.com>, Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>, lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>, patches@lists.linux.dev,
	xieyongji@bytedance.com
Subject: Re: [PATCH v2 0/5] Convert riscv to use the generic iommu page table
Message-ID: <20260202143720.GN2223369@nvidia.com>
References: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
 <CABvJ_xiUK9BqUJS9-Sk1sS4vhVhyXN8P8NooZ0t_Zp7ycG0bAw@mail.gmail.com>
 <20260122153134.GO1134360@nvidia.com>
 <CABvJ_xgSbK3omxT7XGJ0N7oEva6dQAJwZxRhsBqi44BRNZ3G5Q@mail.gmail.com>
 <CABvJ_xhY_4ADOsVVbjhkBm8U1mKVOSwzKMfBw5mUsJe=kkUiLg@mail.gmail.com>
 <20260123135234.GW1134360@nvidia.com>
 <b1b220be-fd5e-4f83-8f5e-7d5282be39f9@arm.com>
 <20260131002728.GM2223369@nvidia.com>
 <8c46864e-4625-49f4-90b3-a7467cec8b7b@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c46864e-4625-49f4-90b3-a7467cec8b7b@arm.com>
X-ClientProxiedBy: MN2PR18CA0005.namprd18.prod.outlook.com
 (2603:10b6:208:23c::10) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA0PR12MB8421:EE_
X-MS-Office365-Filtering-Correlation-Id: e258476a-376d-4574-6a96-08de626892bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l0jzgAuUjqj5FAUgqXmbR5VlL3teroHQc+Tl79YgHtRrKFNlS3wkNoYcmCDz?=
 =?us-ascii?Q?6eFEeuTYN+upW0EMHgQkFsVgchnoEbklSzJNSJ/2SEnWaFxIC621b4ktrGuO?=
 =?us-ascii?Q?Qurax03RhmN+dqlnPLo2Gcb4+xaXu1lL/aln741JwA0k3O54NLt2UG9L/ZoV?=
 =?us-ascii?Q?DvW0h4iRi9UEdfRGd0fJHo/vAONeVzwA0NwkQV1xbsF6nK8QMYqOJfLcBSOk?=
 =?us-ascii?Q?Uh1pEREWtp6xxJilvn/4j/BRzCrqlRhQcDKZpswgSnRLQAmoOm2m4lsL9oJb?=
 =?us-ascii?Q?out7z6zhRZ5zMJihoNAsMY5jVNR5PIbWNT0wjLPHuGxR+wrSIydKeo53Q1XH?=
 =?us-ascii?Q?tWhYCRECOmUsbtWdHwWRe1qUmrxApF3YhD/VpUN7R1NVOYuISPUYunDbSSZS?=
 =?us-ascii?Q?hSGLzXQaYBiQtA6toM0TqhYJ526qcCzSkBt+NNYkVSQNIT/JhAL1zVfyKOx0?=
 =?us-ascii?Q?7n8l7JPTvt4o/PErGET+4boAbjGlos9B1xqsTIBcxkzUn7iqDj2kCvCPZjHB?=
 =?us-ascii?Q?4CrojZKkEUSGJa//RRcf9pAQnLEIQzmVRpWDQfbZWi84UbeZdG4195r1/0XF?=
 =?us-ascii?Q?0GB9D0eiQHGKKsxnykc24x4rldCsQFsO5SMLFur8EkgRvGaeoWsraSBQbPYr?=
 =?us-ascii?Q?wubejv0piM1gQ06USelGvBuCFm2x4b41dzF6n8EcckSdhsv3ddJd+M+EajAe?=
 =?us-ascii?Q?UNRmf0jZNuIMfhNUbQkBadb7JLLBLzYtCrrBtcTZGQt6Ake71cqKXb4OKJwl?=
 =?us-ascii?Q?QvGKqOqRDHyUdO5mis9ZSjcOLEzrM6KHjTSZ8+CL9ifKpJg51lWTDH8r8yfn?=
 =?us-ascii?Q?RtdHUlH4oQ3zP2nWo7NYTUKV9ciPEIKcz9tHYF3TEESY0dvAuKhEmtq1K8MH?=
 =?us-ascii?Q?/x/MNugrzupjz9eSJoZ4DLF+5PBHWe3depUkswlxzGReEyO/r6y0226MHBTT?=
 =?us-ascii?Q?UfLwn6PsICIdvn6Si5MgaKkghIQNNQahxi5SU2WRku7k+H27cE667Z6OwruK?=
 =?us-ascii?Q?inHWEeOhaDNyKR3Gx/KXrd6Db3mLjdb2UBQorUicmx/HnIMuVN5HB5kweokq?=
 =?us-ascii?Q?ivHwbG7J7LROiYnLAQMmjQc15py4fjdkoVNGMOfS24d9eTMD7KD1fP0RkNNO?=
 =?us-ascii?Q?h5A0J9WslSNGn8jB/b5JpxLV2uCLKIowFZXwIPTJrlMoe1hQkuUMX85oDSjF?=
 =?us-ascii?Q?tqN/ltckMtDZQ3VVhhUuEeOOJ/VheYFB7z4RmgzBeAsCtZeOrhEQ+a7TAwmv?=
 =?us-ascii?Q?AkxpaqJDztPH/h1adn/dipHmyGNMGB6tzCICB7fhcrrPjnG3SykS2QKkJl/0?=
 =?us-ascii?Q?BaRaHhno1BdP+KdWfT0LoMJO02HlLQz3cCl8FrkVtLQePGpP1jp/y4EOWeDg?=
 =?us-ascii?Q?1UvudTr3C3GXy1R0G9rM/6SggxKepCF4xSG6J+/nR3xOsQYg/u4unJWqW7lu?=
 =?us-ascii?Q?cCDSsYwLdBRWH+Jonx3QlQMrysnUzhx/3iUnzi8uLUebHjHdJowr30gYxn0A?=
 =?us-ascii?Q?zyZBsmCVgbvvCFPKpuh6AqosJ1DLwI2j0Ne8a295wr0ewkx4uYg3kvJEFKuf?=
 =?us-ascii?Q?9HYQkJhQfIEWnEfZbbE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5zv3DnuOcbkYd7UbAyxsoTVddncWtkbxGLluTd/8c5PtT4JhtQ7xaxo5YGd/?=
 =?us-ascii?Q?LE/Mdm9n/fzRbIdXZkr6WJzRYLZC+8kLM5MzL/HKPSccW8G++9JZuQBjdzq5?=
 =?us-ascii?Q?caXQ6hxRD7IgK61aR0/OwM3zuiKouqfgPQ7ZLNeC0RYNa/yEf1szbrgxe9nR?=
 =?us-ascii?Q?u+PqO0GZEnq3sDv05udDd6Dz0hkiNRLKDh+BOLCKKrNupF3ATqyQC6JofQZG?=
 =?us-ascii?Q?yynmJQp64xq4SkuJv8n347v/zdSk6Dd4e3pd2qswsEL1TnfX6PgExG4FxPmJ?=
 =?us-ascii?Q?ZWmnbc92ytXF+0uNPCcDA1SU2kWWssulr3TV0dhCQogqaMxXf28KCVzRsTve?=
 =?us-ascii?Q?CxpG5mjYx8PFEpNOSSaEbZCZh2qpiWTglHheA3BcdzEVZDHNcVC5JPkBXMIa?=
 =?us-ascii?Q?Zs/tUHTkTeYLvO93Rb0brTKuHoMF17R2S0LyLIAVNtD4ydLcjnL/q+PPxZS/?=
 =?us-ascii?Q?TZYnD3Qi6WZDKCB5z08HIWdZkN7GZwZs/FRNULi4m7pn3VKNbzEWDrSp2jSC?=
 =?us-ascii?Q?caG7gT/otHt/xShcrYTOp8+JJbSevsCx1/chNEXXlTLFWTna1ihhXj3IWB8I?=
 =?us-ascii?Q?CY4ARfpnxYU0J850taZBh4BADvSmv72JXN4W8ZCrxVBes6lF5ZhancPo5wwq?=
 =?us-ascii?Q?Np1zt+Rp9497Sz0g8c9mbyUzS9AQx0c4CriQOgCb/0HK79e/4XZUBFHUwvVT?=
 =?us-ascii?Q?+VEdwcpo6ySuTFvrbBY8C982cZeHMnvNfTDkIKuSjcZhceZLdIGbOjvLke+i?=
 =?us-ascii?Q?IQTVkMVmTjEzLgDSW69iiXiyswyMPZb+ABvWwQopNVKt/LQPK4K4dwrZHkR/?=
 =?us-ascii?Q?I9ibQZtjqO7SmC9pZ8zDn+SiXKLx4HxuMcyT3ukEqxdPRUCI9VgYkJt8NY31?=
 =?us-ascii?Q?qcX/h2YYFpvPUpe2/U3JLkwmNIfq1N4XXmVr+LPZC+KTZNmTR1f5g0OSSqAM?=
 =?us-ascii?Q?WRhKYHsnCy9DPMCr0oEQNvQKZKOIv2hcNewr2BL0lcW1zIsy876uznAvRkYL?=
 =?us-ascii?Q?rTB+MbNGWEgOYW7IZ4j7EHgACFSH8TaE1DlDQPgRycR6rvsLtqzeCK7nQGMN?=
 =?us-ascii?Q?FjSl9LaG7kc+NzOrpdBkD/i8YPZmI+6P0gJZ0gS1pN0BjNDAw+TSohYW1nWK?=
 =?us-ascii?Q?YZ5rw4VntKlw+2+1ylmyldx6aDxWYXUpb0LmLu7875LpVLuVYdcL45W4uaxc?=
 =?us-ascii?Q?slrVClKdCSYA1IyHJetU3X53Bzc3/3GzkaHy+QsmtvpiuG7HDNC3/i+sI/og?=
 =?us-ascii?Q?1CTfq3jf75Zf2wC+yhWS5zXzcGvOw5NpdeJfAuRENSW5J3YzZMi3KRqZsgXy?=
 =?us-ascii?Q?ta+cQJ5Cfhqmt3uTgArNjNpX2Dhjq2iEpnsVKbf7CEw32rzY4W1Kxvzn3SQo?=
 =?us-ascii?Q?YeecJxpHVrLFISN7LYMQRsaf3tSM1dQBprCCJXwKhpZLHSC4irghA67yM0P5?=
 =?us-ascii?Q?Q6mVs5huZtgz3Oxzg3jYSw4P2d/eEnGcUQTmOcwtK9ylcIUwaV2N7+rC6JDC?=
 =?us-ascii?Q?rxOqabSIseHy34TzrAOv2niP87XmxEvxgPR6qWBLS8fYlr/gWsBCnzEb/sjn?=
 =?us-ascii?Q?+nrA+Dct7DAVRw+m0n9WpKCreG+cT6em+rQRy42rP50TbPCqmyMeM8w1n7gf?=
 =?us-ascii?Q?9p+ab7BLu6WFLuy2GGo/l/AuENEX+JPzLPkQHMQz+yAFZli925s2RnzPdm3q?=
 =?us-ascii?Q?JYYWh0qsXqm8r5pBQgvbKfL5gslxTVUcP4ymrHtHu503FhBZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e258476a-376d-4574-6a96-08de626892bb
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 14:37:21.3099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mfTeXgFE6R1aXs1atHSqLPqV8bv8wA6cdV2CqNE+nX+3KhqRxdQ8bu+o2tNEtV09
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8421

On Mon, Feb 02, 2026 at 02:00:07PM +0000, Robin Murphy wrote:

> > DMA-FQ requires two functionalites from the page table:
> > 1) use gather->freelist to avoid a HW UAF (iommupt always does this)
> 
> Nope, correct DMA API usage would almost never unmap an entire table, so
> synchronous non-leaf maintenance in that path still doesn't hurt DMA-FQ
> either (e.g. io-pgtable-arm).

Well, it certainly would hurt workloads like IB MR's which can have
quite alot of IOVA in a single dma_map_sg() and we do want to see the
table levels removed to avoid the waste that Pasha has talked
about. Doing single invalidations of potentially a lot of levels in a
DMA-FQ environment is unnecessary overhead.

But I get your point that simple, say storage, use of the DMA API
wouldn't be bothered by this and you could still get alot of benefit
without using the free list.

> If a pagetable implementation wanted to refcount and eagerly free empty
> tables upon leaf unmaps, then yes it would need deferred freeing, but
> frankly it would be better off just not doing that at all for DMA-FQ anyway
> (as IOVA caching would make it likely to need to repopulate the same level
> of table soon.)

Today it isn't done with refcounts, just if the iova range unmapped
fully contains a table level then the table level can go away too. It
does trim interior page tables for large IOVA allocations but small
ones are unlikely to free anything.

> > The one call to iommu_iotlb_sync() is only for the para-virtualization
> > optimization of narrowing invalidations. It would be nonsensical for a
> > driver to enable this optimization and offer IOMMU_CAP_DEFERRED_FLUSH.
> 
> Not necessarily - in the PV case it can be desirable to minimise
> over-invalidation *if* you're trapping for targeted invalidations in strict
> mode. However, depending on the usage pattern it may also be beneficial to
> have non-strict let the FQ mechanism batch up work to minimise the number of
> traps taken - e.g. s390 is in this situation, and is precisely why we added
> IOMMU_DMA_OPTS_SINGLE_QUEUE to help optimise for that.

Okay, so if I understand you right, it should check for
iommu_iotlb_gather_queued() and disable PT_FEAT_FLUSH_RANGE_NO_GAPS
mode entirely? ie there is no point in doing small invalidations if
the caller is going to do a flush all?

This way the user gets to pick using DMA-FQ or DMA-strict ?

Also Intel would probably benefit from .shadow_on_flush too?

Jason

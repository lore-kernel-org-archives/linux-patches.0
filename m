Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012024.outbound.protection.outlook.com [52.101.43.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015DC495539;
	Thu, 13 Aug 2026 17:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786640753; cv=fail; b=X6DN5BWNkQv7W95mOtkiRbVILUzV9jcTU9YGNUJeg6nLoGDNMBmxyAiGwIUrSqHzLiKw8Nh5CQ85kvXL2f4jtat58b3I4Qj9UP2ML5P+DhvCob6ASKvI5Nszi+Ose6sQiQVpOc2D3PRROBsqYnfOHk95hWcO4WvdSua1X59Qygg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786640753; c=relaxed/simple;
	bh=lmOJdKFm0idqUa1h9aAIJKeS6gp/geGEshMFVVRYRaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=C0yzFPHL+VCkj78VwoSIwIgoisfwvZ1Xr/hvYsKZXZ+OcsVFiC/ZIpSFiwX/LnOVDrVUBD2VezDthVlRseUTw0rOURaXe1DbPKYRzPWOlkAW1LgWITPgDkNLEXs89CNP/jz+Qg/tvGPxC+c7w53jDvsc0nK0lcKw+Y94eqd5ldQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I+FlqY76; arc=fail smtp.client-ip=52.101.43.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I+FlqY76"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PM1qhJYT00ueUDBPm7OjFxZEI4KL08LrntH3eVFTTdkswHwcBSLPRcayqFkO5cvP0DnTcr6PhxKcgqAOdp821+rmgnUUoDfPdj1cewO3SSU4RLqTlYVXGh8/YRdCMKKd8vlnPr8/TYgAgv12LAx3PGLy+LLrAk+QlCbSreGWStPh8yit7GPdZM2V6pK6rce/S8Ov/ulJKQvo5Enyx/6GLYe6JzO8rEz0xluhdHGmrp/FYdqt1PFxLy44vq7QmsY74O320eIDrJCixAWVzgOMU3SqJEF/aOXZMU1nYRsDRh994NQez5y+E7lM3csfFCtr77QbF60/p2wLhj4/W5uqTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KCrv/WbUXdclH0BMWl4GcnSxiIhby8t162RcpOl6xiI=;
 b=EVJdL5LHGa9SVxABHqPJSIG+9HZKYulfupKq/tOSbeAanNngRVlxYXGPVEmMploNtO8fw3AAjwZfTH6sih9lS+XN2UiqWgNjme6yJATEGUbvZOA/BHK66tpPCG5AyuMg2e9ks5xGH4kMxceJQrzk5Qn1lD4tTTMFT0wvzwtnk+WDwi1O4323/e2T2LDbu6wQ+vfkgQ8ZmBbkW++s86F9IU2IZrd/K/2h+ZmZHyTSPOEmnJ32dJlDfQ1bMGB6GsUOPf3bs/UM3Zzgs5hFbdfQfyyEsCt/rfskqMVLLHZMQKOQQ7c1uKBKp6jzb8ftmyMnzYOuJP8z25m3+XXXFLzo9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KCrv/WbUXdclH0BMWl4GcnSxiIhby8t162RcpOl6xiI=;
 b=I+FlqY76AfVaYDmlTJ1LN/2W+Dpm/silFBsE+wfGsacwztvCNSxsSIfCDJpn63tQWxpgu04HXlToUDSfMIyH/cVfu3TXfZPYtyetr+57xLziGn+SDxC3Qb6+TafA3EfXAhARu07bFpyqe4Syn8HCazy6ir6wDno/1Pp1s8h0dF483+eLcrRxHkFdk0n8YNrr9oDDy2tYPyg6t0DJk/JJABn6qlQDDYaOy3VUy+/vY2vKoqHGxfSqWs0wzykjvVfLBCzParNrl1XrASNaei81YJZUUir3rs2iN//fE7Sf2qygY+QnIJkTJ2WDW9xkVq61+2FBbg90hUkeJWFU63FaDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY5PR12MB6549.namprd12.prod.outlook.com (2603:10b6:930:43::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.15; Thu, 13 Aug
 2026 17:05:46 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.014; Thu, 13 Aug 2026
 17:05:46 +0000
Date: Thu, 13 Aug 2026 14:05:45 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v2 3/8] iommu/arm-smmu-v3: Optimize range invalidation
 for latency
Message-ID: <20260813170545.GG730363@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <3-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akzm5BoV0rToJ7ij@google.com>
 <20260708001058.GA422027@nvidia.com>
 <an3MSKEj7VhT4WkP@google.com>
 <20260813141320.GF730363@nvidia.com>
 <an3ew9xbnLe1dr5g@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an3ew9xbnLe1dr5g@google.com>
X-ClientProxiedBy: YT3PR01CA0050.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::24) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY5PR12MB6549:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b75558a-80c5-41ae-66bb-08def95d1dd1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|22082099003|18002099003|56012099006|11063799006|3023799007|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	gGItNfU+CR2WLxygU5DUEkFl8Hfa4u7cAMt20nMebCbGnktjiu52CwRIGVGb8ecYnYhXcRqKKqzMLuYMHRZWw5aVkEKqzaDXxydQRQoPpVNX9B6fV9C68MgSWaqV6pzJi32VMzaavYZWEM1PobO327BM3ihf9ahG/MM1DfPi9z4a3HSbY7Pd22JF3XtEg4F0X5nKspNdSLtKg3FGe4v5O8i1KqPPyoQQLsh8t0BI33YNihW/1tQoiKQCi1Bj7GS08KyiVWPwKkkL4WyBDQULaluuH5VNXTElGXDQtF03IceFFDzaoT3RXmzyO3XG5QEGgq3mfvlRx8MsO1KMgnT2SBZNmmS/JzBrzb8I/Lu1OB81gcVEHmo9zQt/61Tdtr3+mR3S4CQis4qGT+1kPGK9YEjBop1It440wrRu8wGQysYbL0/f18fL7+eUH/EF5HXT9exNCIG7fSQJAYnX73ZXS6mB3eKtyQp+dUdS0/nhxVMacWvGqQPl/2P6Gyh8pgg/EITCCZ4RPPZO7FmQjlWqJjz3nX/OSklMvvoVSYMvzLc4uqSPAQNnixJ0uIEHqEckd4VK7I0FtfrLxu4ZN4kRhwBpiKXwDHwdazp+CpwrYe2MY75mCvqZIWnMDWfCBifYYgS/O+Ebk+qB5CPs1v/jugCNxdGIxuleqg+wabUsl9o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(3023799007)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IfHMFFjPWn1HldZxNqfGEY3CsK3lCbEZxfCi7hPpR+vk9GuppGbZSzLB2VBS?=
 =?us-ascii?Q?rPrC1X2N5F83s1FvfsnSacKgZdLrBYt24VRjVc2kPJOHc9xtlDWEGxN3GZgI?=
 =?us-ascii?Q?3qlyHijrJmm7pelYiHn7pfNv6eYX0L2AZZkZfOYI2mBa5bbyP3rEU1s3JQG0?=
 =?us-ascii?Q?jhW4dFoN2/1v02almq8Q4+hNkJXcfaTB10HK9SmZ+HFwhS+NMTF3CdTw5KPk?=
 =?us-ascii?Q?UbzUf7eDXuqVyG+WO9XxHjT9ylS9XzsJyRT16Vju9jBkUB2v/XutuznrTgzz?=
 =?us-ascii?Q?C9LpcHEDjFIzfJIUyGe/b6wK9o5VNXp8SjhOneD85pdAokTjRU0FYj69eBZH?=
 =?us-ascii?Q?uv2pYEpWZ52vELE3swKsJS/Phk7YmLStYwwFTYupGuSwWuzKZWB1zbIu1rBq?=
 =?us-ascii?Q?x9K2KwypWx4DVVOti0itWrZtxgja1+X2gGQht1AivyO3HMW+uvyJN+hFI6/u?=
 =?us-ascii?Q?ofKXzzmizqte8mILZ7bWRKtUM70CP7ThZo5i9T5f8vWjPy2E7GKaLWYJSv2c?=
 =?us-ascii?Q?ZCIa736nfak5SukKekAkFjQXnMRoikOUNWsq17jOkgOB/o0mjig4TZjBMj2T?=
 =?us-ascii?Q?JnHrvdbgeV4tKYFWpl7ScDHmgderGS7jgdE/bWqQNQ/+9E4sK0nsLAQz4pgn?=
 =?us-ascii?Q?lUg5zIbc/FyVwpA/nESSwEesfpLkqH9ajIumGn+W1Hay1Kboezf0lThUt8TD?=
 =?us-ascii?Q?BZEgKRnnJ+vfKdFQ4BDIgbe+6Cfmoa5ZfiMZ1af9lzz2ftjw2W8f1L86qq1c?=
 =?us-ascii?Q?XNKICu15/Dh2VqijUrnJsx7BbH6CTUMdD827u2NP4sDkaLMs19l6HlWr4/4a?=
 =?us-ascii?Q?O6zhCkpC8KPVKSWNauCXcJe4EDRDMitCILjhHvr7SFgW0rrk5j9Zl/nPjqmP?=
 =?us-ascii?Q?2OQTCIxmsWRjnpOTIhJ5LSNe9GUWAXZ4p0nmBuSSAQabNlKwODTeNPWSS9IO?=
 =?us-ascii?Q?VO8QN/fKSH0XF0niQbxWiEKhAybZiy4Hpk0/s8fI9crvzSHy+XWnv1UwChWK?=
 =?us-ascii?Q?3cLOiHiUkXhr9NZHYXkq0zzYlTAv1y8oUtcqB9oUi96xI/ldTrZgCWzqiC/3?=
 =?us-ascii?Q?rJJWlTW/rT6srNQfN4bbXI9RBH/pMGZOE2+7gAmsoHq1D+9S7wBkd6lasyJ7?=
 =?us-ascii?Q?mRgDrXGjSho9OYeKawwpVWPgaLw4w8NV9apYL5Tw68fP2I59RmRyYWEWC4tQ?=
 =?us-ascii?Q?Gh349avIJN9+Z5abGha92H9gLMhHdr+hAmvDu8QB4WwxxlxipOiIv8hsBUeS?=
 =?us-ascii?Q?NkZC0x7r+5Esb1+h5A+Sy/NaqRua0GjMcWtrDeYLtSXvHue4jTVkItsHFBee?=
 =?us-ascii?Q?h2ZZplMvZUKT4EihT9Jweg6oLwVR9AIORouVgP4+9P1LklfK9SgfNp8rzuLJ?=
 =?us-ascii?Q?gtw318B9ca5uwU+hHD+jfteRUczwNSBK29VzlRUvynPMADx4sm7xzZage8nW?=
 =?us-ascii?Q?+5cCn+wyozvKR98NtNNjB60e+6GkzuP2c7oKS5vH8wujNJXQl+KJC7LbUlaZ?=
 =?us-ascii?Q?p4KC8dx0RYSryKewD/tirZt53ee/qndpTEWFfjWbK2JjHUfKRNTjgB6zTrcG?=
 =?us-ascii?Q?Gjgw5KaJkruaAyDc3RtowBCekCCryIwetwvNS+qx1YzztDmsZlB53/EsqBeF?=
 =?us-ascii?Q?WOpBidJT9yoebenSc3gYD83c4ddLcWcZeIrTi7gRodXZcUstzaLokyxYO6QP?=
 =?us-ascii?Q?xz4ofz4LqBox2FDE3tjN3sRTbJuwt7IWivdkxBsAtX5tpMjF1eJ94i1Zi5wg?=
 =?us-ascii?Q?7m0O9uOd0Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b75558a-80c5-41ae-66bb-08def95d1dd1
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 17:05:46.2537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tpceiTvUUwC1wcnVHI5l5UibXENFKi0GH8/WjF4xoJeU1hyb96BU7Bfx9zSO2cZT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6549

On Thu, Aug 13, 2026 at 03:12:03PM +0000, Mostafa Saleh wrote:
> > > There is a clear trade-off here as you mentioned with TLBI latency,
> > > would it be make sense to make that behviour configurable from a
> > > module param?
> > 
> > I think it makes sense for a driver to indicate to the core code that
> > it needs isochronous and we can do more global things like change how
> > single works as well. Having an isochronous flag on the domain, for
> > example, would be a good overall direction.
> 
> But according to what? It makes sense to optimize server chips,
> but that should not cause over-invalidation regressions on other
> hardware.

The driver operating the device should know if it is putting an
isochronous DMA on to the device. It can make a function call to tell
the kernel it is doing this. Then we can make changes to accomodate
it. Change the invalidation logic, disable FQ, etc.

> > I'm inclined to leave this as is and let someone come with a specific
> > problematic HW, rather that try to badly guess without much
> > information if it might popssibly be a problem.
> 
> It's not really a guess, I mentioned some examples above, that I
> have seen problems of translation latencies on them.

I agree translation latencies are a worry, but there are alot of "ifs"
before this specific issue would become a real problem.

So, when I mean "specific problematic HW", I mean an actual system
that actually hits all the necessary preconditions for this specific
RIL logic to breaking.

And if there is HW that is so incredible sensitive then I strongly
feel we should have a formal API to declare and take robust steps to
make it work, not rely on a fragile patch work of "happens to work"
and special tunings.

> And why not the other way around:
> - Which uses cases can't handle few RIL commands?

It is latency effecting, we are seeing more server workloads want to
run with iommu=strict for security so the latency is a negative.

> - Why those drivers does not unmap memory with a granule/IOVA fitting
>   to RIL?

This is governed by the IOVA allocator, so it applies equally to
both. If the IOVA allocator uses power of 2 for all requests then RIL
over sizing isn't a problem.

> - Why those systems does not use FQ domains in the first place?

Do these embedded systems disable FQ because they break if FQ is used?

Wouldn't it be better if the kernel automatically did that instead of
having to tune for it in sysfs?

Jason

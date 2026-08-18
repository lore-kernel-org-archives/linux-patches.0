Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012057.outbound.protection.outlook.com [40.107.209.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744C73EC2FF;
	Tue, 18 Aug 2026 18:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787078624; cv=fail; b=GK1Ko4dpGJ3Q6tM6ESvzIkaoGQb+NUmv3hBP3LMs1rod1WarYwuItaIoJ13atLsUr7qR0RMnzd8jNVpsbhbpgOj9+A+4AR5z+9ZHRPH/Z7dp6tUuApMSOq764evQtRaOkjtOS39z4AY9D88Wx6MjI5qYMVS3abyLK47kaVMAjhs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787078624; c=relaxed/simple;
	bh=UkEP1E4CQYT3TJugyXEyglXjkMYk+skXktarCY7rVJo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=D6w2Ji6IZkUqo+bVnwn63fodyBUIgOyKsjCz0oOpbRpW5tBzzqTaI0ipdRDmG9fFP/J6gAVAH70n0TpOtWPiQFLF7RGDxgZA9vsKVxfg7zrbIKTwn47ScZRmrzUuu+2N7sX6qhnoUz5GG+wsUhVrFTjnSXqlCKwH+jWZoVJi+oM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EzRq4B2b; arc=fail smtp.client-ip=40.107.209.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EzRq4B2b"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bPErkDZ3ut4wIMcl7Z8+VIRQ7jIGL+4+vLzKQlXS5f7gooZ1OlaI4kyBkI8E3g/p6L9CyWhFjmf6MWieepma1wGohArZmerckxwvVvEcZRvhJW9fyZKEFRaqL6EtYzckg8lBPj9hE11EeTI76CIzjja1njH9YlzJhOZGUjj4qSFr+rLiHeuDFOZGQ7tYB4dnBkUD4vubiY7R/4t2EgCiae0No0cNMsZnfA3yVj4tR6YIK0Bx6vFY+cFvj9L2jShx5fcrhglsd1Km9XRxwr+h0K0M4W6MrB8pJKYD4+pA1dO0GDTAujHX9KQHVvjYNEey9eRMtaJXL7aVY9SQUCntxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UkEP1E4CQYT3TJugyXEyglXjkMYk+skXktarCY7rVJo=;
 b=Z6WXm0i9Ls6vQ0RuFWUU9C2GvZenmSfwvSo+Aysl8jLJbmetCxesleYJuBdTqNcaOAkbJz+V6KPPiNBt+RYZp7iLAEdgmr3dT+4xkqB9r363fQ0UfxwEGzO/yrARJtglPVYh4cI9btD0gmMITeeiB6JWS70aoiR6eC0xUwz7NVQ8zDYNyVPi+Z8BMSQ5dmODRS5fTuOBm6Fbzne9wAs7wLG5fWYlD1+Kn212ttm/lIkFBaqVap+ziqDRqDE6PdH2zdozpUSQWAMDDjtrhjaj2tzqo6WJh0UdH2UuMl/yyl7GCLfsjtReXVYHSUtZqkOSIGySNBF0UeoVqXeBOrzGew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UkEP1E4CQYT3TJugyXEyglXjkMYk+skXktarCY7rVJo=;
 b=EzRq4B2boz1/ibU6w/mUMFPF8Tkl5aUn3QB7ey58MdB47Pz0/XyNP6AFhj7KdwtxmrmjRD5wfq8tAuhUGhSsWFQI0GZMZN81ZshUr65GWhNe+G1purwcyw2+6CPZsT5aB4xKkAA3+vVnKJr/WN8GfYj0WN1WActwlKLEd6Vy5XwdrcBOg7Kj7OlPbelYtqWXKy9ihFuZ8umONGPR9j1ZdifxssStSEUG+0wRGclnpqsZ+sVn/ADqJC2D/dOAtUdPvglG57XE3h5aBuQrnHyjviIzUFpeFQ4aQBAupWhpioVVMQzft5gPbxLDBBKhrriiyNDQd2v9O3ML9OTeQcm32A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB7284.namprd12.prod.outlook.com (2603:10b6:510:20b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 18:43:39 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0339.007; Tue, 18 Aug 2026
 18:43:39 +0000
Date: Tue, 18 Aug 2026 15:43:38 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>,
	Mostafa Saleh <smostafa@google.com>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v2 3/8] iommu/arm-smmu-v3: Optimize range invalidation
 for latency
Message-ID: <20260818184338.GF5432@nvidia.com>
References: <3-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akzm5BoV0rToJ7ij@google.com>
 <20260708001058.GA422027@nvidia.com>
 <an3MSKEj7VhT4WkP@google.com>
 <20260813141320.GF730363@nvidia.com>
 <an3ew9xbnLe1dr5g@google.com>
 <1791d7da-ecd9-4475-8f27-c8857477b442@arm.com>
 <20260813180102.GH730363@nvidia.com>
 <an7UNAA1WlEXG23-@willie-the-truck>
 <20260814123417.GB510472@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260814123417.GB510472@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0302.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::7) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB7284:EE_
X-MS-Office365-Filtering-Correlation-Id: a93ea652-87ae-4ec3-cc7a-08defd589e78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|18002099003|56012099006|22082099003|6133799003|11063799006|10067099003|4143699003|5023799004;
X-Microsoft-Antispam-Message-Info:
	NpDN8rIDIZHPLKVA6ZLjLCoYEjnDrRFIc4uOXeG5Hecnc13/sSleoP8TOM7RRQrjckEhB8YeaqcSqT58Jhw9ymZLJLWa2WgUStE8IG76yHSV1WMauPn56WIHi0AXnQu2jacggF0Ot+kXajumHkX8BMDPlhEfYkau3cxDpgV/FWup6JMwaouTDZMiXIY0UQL/EFJxcn5sNUuccjDiiUVc8kd2Rsl9r47gtfbzwAjW+SjHfVwOAGHp2aF2tXxjltShHsMda3Vw84cyeW9KGCOhzuU08YFceWYVNy8nSsqO/hjlOwW3C3KraFUxKUMSjbMdZif2cBmRIcFQGKzUFE7LXQIS17Gc/HJxjOInusDyYOWK5UGajn0rGigtUrjKht2VUSnjkoQ6o2LUMG5F9pXvpz/M+qoXxlXVF/2oEoGKZKKgXCpFU51Uumd7Mt79w2G7ZOcKMTW4/V1uNLY5wnv98qUMZWo/KLcEtay5aFDLrGfzZ2HTPFGc65uI6eOJa6efUs309mF5/9BeMMrx3qlG7a2gLxrgev7MRZCmWtmJL2418fiw71LZ6sSQl0SMd/vQdJPDWW77UtykLPLct1rnEVo+KayXRMiZisJQiHkYuSLzJBcnUNl5WOv5XjXYNtBCxG2UtPSo+GKJIDex8Do18mpmzCNOPfOi/xf6DwYxs8w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(18002099003)(56012099006)(22082099003)(6133799003)(11063799006)(10067099003)(4143699003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ODOfwziATv6+XDTFt+Dj9oJ/5Es/wdMT3jBYjyINDRuOeJs1OMceJmDimwso?=
 =?us-ascii?Q?FyvXBIMa+vbzxmHBHQln5P9Bp1vftX35RdurGPyuIHB+OvxPCSKhTfWWZgD3?=
 =?us-ascii?Q?YSYdhkWpAp0CfV1q/mN6/S/iW03TvTR4uWq3QNVbZ7rxIyxlV9amPz0ad8eH?=
 =?us-ascii?Q?/Nryc0774ZLICvp8J+bK3oCPIpBE4z6AiimymPlKIrna8JEZV6t74vkvsSsH?=
 =?us-ascii?Q?EmEuF3n8LkLu99CwvEx2Guyq6L/Ne4fI8BbGp/0EfnsHa1d+cPYSiK+Fg6P3?=
 =?us-ascii?Q?eP+i+J5eGNGt8c3+afSfwh3dD/fvSbf8Dpps5kpZrgTkiOBsw6XE2KkQ6WdZ?=
 =?us-ascii?Q?qXRfnxXwuUiHAYaLA96/Vx40NcfiOWrJvvyLqIbTj0j19CktPGm0YPrMLWOn?=
 =?us-ascii?Q?yfR8iutbSUViXzAuTSqIjh4jOSn63RPks/3XlWJ5GMowx/DIFaBZ/CWRbvGZ?=
 =?us-ascii?Q?Cs03M8QKNf/v7VSmgdz77BWhEEl0WfUy52U59Sjmzjtu/M39w+YLq51Yysg5?=
 =?us-ascii?Q?KVTnDr1gSmhtGriefax9iT07Yui9z8bFIAilWIEj9Y/Fp4LAknbJiGDquw0j?=
 =?us-ascii?Q?pL2nwoz4xwSPewNblU9v+fpjeSRHjhYgM6vxCQLPv/4OWEsMyQ5xdiRg7OsL?=
 =?us-ascii?Q?nPNx87YgfK4IfmO8AjolZPQ8k+XeQmQBsquTgm9vLmzpIt2pNlBNkgMjCROV?=
 =?us-ascii?Q?d0dd+nNr4BTdmuFkyLt/84v3NVyQ9OgeEFAWaRlatZJiBNCfQvsCmfKnirDj?=
 =?us-ascii?Q?L0un0/i7zjiRk38dcrAXmTdxMaFl+VQskvhQS912AAlMIIhIlwXh29zACcJQ?=
 =?us-ascii?Q?0Reoy7/mvktTrjh7/BgrBgilXvF8PQ2FtsPEpXnwJSEhxMIHonKd4fjFtGeM?=
 =?us-ascii?Q?nQAqJtlnsqqn9VcC+rphQMIJHpWx1O0b3ftWyuDPZKYJOTERM/TwflHZFCd8?=
 =?us-ascii?Q?GAQJxjh049ZAzoDY4wsGQxIPY9CUVXO8My07cRs761sX1I0JsDrX6cgDr6sy?=
 =?us-ascii?Q?3hH0hbpAnluXI+IOtpx9RqJeyCAFmVb3XYS+YdiFbSXJKldqePkMvNJzLZoY?=
 =?us-ascii?Q?jDZZr0I0DqeuAos0D5DCYczwoF4dGEDBpbS1GmJXk4n9duFcaV/2AY7GRoUF?=
 =?us-ascii?Q?3VM7SFIWOMB7buT6BYhaw88xiV8LkIlFVzOwQ/ahk05UWqzQjG9VdHk4Yryt?=
 =?us-ascii?Q?4kxeIBv8mRiwmem+Lz+lm7MRcfelXxwZ32VEx9sw+HUfNDJDtCny01FPQmPh?=
 =?us-ascii?Q?kgykX182v+oU/maSjmmGxW6q7Q+unCIQCuqDFhATjpju0OPa+G7K0sl3UvPN?=
 =?us-ascii?Q?D6jZVAbyVKOLqDjkk0eHCfSdmdPADg4mdK3kbJ/rba7o7dE0RX21RZQqMcVL?=
 =?us-ascii?Q?c2BT5pQtzoSHjtHl6KodgW4Ej7tlyNsDsG9D6kY3176uBYZ2Abk1ds7L3gR8?=
 =?us-ascii?Q?XYpBFSUQsYyo8EDsieKc6cuH8j0DmR5c1Tn343VQ2Cszr+JVGL7XlOIx6SWm?=
 =?us-ascii?Q?CVjyzIYrQJJ2oJr8TX0xKH5Iz8RMpbHlcNXvI+JHXvjpSBfgu8gG6P2wpLO1?=
 =?us-ascii?Q?uHj1w7FI6OkFRdTBGrmGZ4ctYx7Y3226C8WSWZ2ADAtN24eJGyO/zRt4mb4n?=
 =?us-ascii?Q?IxSgZRVpVyKAA6MP9bTG+DFyi6LEeoblL2fhLwKnxi0x5Sd3EZvSRAOebAH6?=
 =?us-ascii?Q?ZOAJM+Qw8g7gq9WV9zd8m7VZbMKuTxCaJRuZOQnZSSKLpVtI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a93ea652-87ae-4ec3-cc7a-08defd589e78
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 18:43:39.3741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0rEhDgaYZkS3/TeFl2EtT4CMldgWXVGMaJzrDp+IDNUouFPiCYoTlqaOnrA60faQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7284

On Fri, Aug 14, 2026 at 09:34:17AM -0300, Jason Gunthorpe wrote:

> I'm also wondering if we are even OK with this errata today? The
> current RIL algorithm also does not guarentee the split up RILs will
> cover every CONT. This will happen to be true if the input range has
> certain properties but I have no idea if the SVA path or even the
> proposed CONT iopgtable change guarentees that.

I've looked into this and it looks like the current RIL implementation
does not meet the requirement to solve the errata, and these days SVA
provides CONT entries from the mm.

The errata says the RIL command must cover the *entire* CONT group. I
read this text as meaning two contiguous RILs with a split that is
inside a CONT group is still vulnerable to this errata. Each CONT
group must be fully covered by at least one RIL.

So the algorithm we have today where we take the range and split it
into many RILs has nothing that prevents the RIL split from landing
inside a CONT. SVA is not guarenteed to produce ranges with an
alignment or size that make this algorithm happen to choose aligned
splits.

I've prepared an errata fix patch that detects the errata and triggers
a very simplified version of this single-RIL algorithm only for SVA
invalidations. That will fix today's kerenel, it is reasonably small
and can go to -stable.

I've adjusted this series on top of that to use the double-RIL version
with no over invalidation that Robin suggested for paging domains and
single-RIL with over invalidation for SVA domains. This also turned
out pretty good.

For the iommupt integration, and enabling CONT for the paging
domains.. Ugh.

It seems at least our Spark CPU has this errata and requires CONT
support to work in paging domains, or it runs into its own isochronous
HW problems. So the easy answer of disable CONT isn't desirable.

So.. what I've come up with is a little tweak that still allows the 4k
granule's 64K CONT to work without any over invalidation, so we can
turn it on by default. That is enough for spark to work. Everything
else stays with status quo of no CONT.

If someone has another smart idea now is the time..

Jason

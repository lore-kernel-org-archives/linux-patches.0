Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2072.outbound.protection.outlook.com [40.107.102.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F3A156F5E;
	Fri, 13 Jun 2025 13:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749821794; cv=fail; b=I8fBQqq6XOt4lQJIx6uk651egjPqAOLbZV/tVyYpcA+8DxuHJBDRylt/TsRbcq+fjAENH00jNfQ1ZO5J3yRtenvffn9JU1om5wJV0y8hyN5OgeY1wTadiEdxfO8uTwTR4oW+uazinG2i7oXZGx1a01ZR4D860UaS8Tko3gNQfe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749821794; c=relaxed/simple;
	bh=33pBkNjc2WB78G+dOalxuXtfD24c2MwVB5cECQ2K0Ho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=j6qh3MXmyuoIHPOt4MGy6aMus78mqc6F9m3/UkrUJpXVKurOXqISkjgO199/5QlI43IhQJtWun3rwSW6qHRUYU209Zn2e5tBtUlv7aLspA1QlHu/wMDdtLGugUTK+OLbbjlXo+tUJU3YrPGUSuQIA5CaaWsLFxPke5F/chl0dNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=F+ZkHK6Y; arc=fail smtp.client-ip=40.107.102.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="F+ZkHK6Y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VIfnh3urXjBE7Aq9lKOyTkdsHyJdRJLJq3nsFw0S4j3rqKR5LUIkeZEtLswZI63Djv40LpFDJTRaJDoPnQUh81mokS9KyMNZuNhMzD8oechnucP/wf3sOVSF89sng9LNniKQy3sDuCD0TBMYPX+2acVNCNvbRvx83zVrEFD0lGRBtlMjweEMqovhx7QZeIUNYLOPe4hedwhmw69vtnb0fFmS/c5wyGRpCEFscyHb38McM8vt8zDfZBo2hh2GLgblVMzK2xfUtuLYLHcHd4+iy99pGL0YZTFi3itbegEES0Cgk+oOhDXIgmVWCfsE1S3ujMwpjfnPyyqUviWtqheytg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=roYM1ayh/WlXyOMZO9HWQzN4wOBtYnodl5Vx6YwAyTM=;
 b=ZRoT1JtmwsitUNHCBIVpgBDA9rER8qYWn15OTEJiWA6A3LdPlmlljOrag7dipjeT01/qV5+49kiN/J+O/ND8UANzOBP3v6rIsWeUBHzvJlBzh3ijDZFU/hZhCxZDnXPpequDyMwCJ7VIM+w0efNrbnJRljv9yoz/MVMop4Ey0kUEef55N8kgG6ub9Pcd/yhKMC2Ver45cCrkr/NEN7HYU8K/J3GgyiOQjW/6lvXtibd0al4xZ2f1V5EFIdOlqsfne7tNTIKQ++jymy5Y/bybonnu08lVjgKvdL9qREnKFAonNb/VywNLly5TJLU9QJrn05kIZjZ4Vh/Jz18yGW0gRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=roYM1ayh/WlXyOMZO9HWQzN4wOBtYnodl5Vx6YwAyTM=;
 b=F+ZkHK6YLljQH3er04YadtWbXtMRtHikguHRD2ZUIXqKs+wYWIjJYz8jbGIWUIh4lM0Xxe6MhAsk2iEGEC8uwVjgwsGISQTy/bgttl7DTaEskA4gYKSseB31CreRVykSNQx+PnI/GEWvcKtzOa5Cg6RDOOm/En30XSAtQEkF6uUuZlDKg5l6dWnw/dIOX0e1jqpv7S93/PLz5ChwDqCJfH6fNX8vRWgP8dETjfItMTZEswTDzvdJ4qPht5OWeon5MKhQL3R+Sm3+dzRx3Yacajrlf+mzOXtxfIuhK9Pok9NCwe/9udwG9n84B21TuidnKDTDCwKwWbpUQYDoooMVFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB6701.namprd12.prod.outlook.com (2603:10b6:806:251::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Fri, 13 Jun
 2025 13:36:28 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Fri, 13 Jun 2025
 13:36:28 +0000
Date: Fri, 13 Jun 2025 10:36:27 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: kevin.tian@intel.com, will@kernel.org, robin.murphy@arm.com,
	joro@8bytes.org, ddutile@redhat.com, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com, praan@google.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v1 04/12] iommufd: Use enum iommu_veventq_type for type
 in struct iommufd_veventq
Message-ID: <20250613133627.GC1174925@nvidia.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <d60d21de0ea6bcb6e0bb1afe624a9045b38c8ee8.1749488870.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d60d21de0ea6bcb6e0bb1afe624a9045b38c8ee8.1749488870.git.nicolinc@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0210.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::13) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB6701:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d66ecde-27f8-46f2-e100-08ddaa7f4cbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3af3NlV/Xx2tEu2ZYbms56F86ea3PeY3LY8ooVD+R6sD+iJ5hmkfEj/Ip+IO?=
 =?us-ascii?Q?JeA6zG3WbJa+Dm9obTJyHr4wvwIqXeFwdGz0U1pGQJL2szRoJWLnyxZLsRy6?=
 =?us-ascii?Q?yapgIVEGma9UwXBEZdeLNrX7WKwA5jXuZd9Ight7DpkRWy/KA5fq3MIg9s3C?=
 =?us-ascii?Q?sjmlpC3iz1/20PjPx2TAiItV7QpWyTOlEIFAM0OcEbiVHrFm2iOQRs66V4UA?=
 =?us-ascii?Q?6ZQVnnyEou1G5Ju1akrnnZoVkQFDTEovGqBUPQ3Oh+9N/loSJLepXN3J/+tY?=
 =?us-ascii?Q?hEB1IhDZ+O/mo2eZdDQuvnarJOwwnxvQ2U1fpjk1Np3DZjzdW0Y78h9w23QJ?=
 =?us-ascii?Q?//53S23CnPIUIpSHGIpPHh4WWUBI5joNsVXa4ruyWcb5kFbCuGuXKS2ACoLx?=
 =?us-ascii?Q?jx/9w8JVBIWQSnj9unbXeZYMM+MXfjM3TH7g6gV0KizVdhkUnJuPskKI/Xx8?=
 =?us-ascii?Q?HBdm4jML5boslIWgDa0X6FFQUakbb9cRscdTQqNWite159SioBABN+aLIrmA?=
 =?us-ascii?Q?uRFVRGNpuWBX8MN5NkomlEYDYJa54QqJxCUacTq6AJNbc/wQqAM8uQ/Jupcc?=
 =?us-ascii?Q?vWYaICBUoXjxZDGbIyRjDWAiaSU3L6DSTmSbMy3bCoER8raAuEg0jO99hhm4?=
 =?us-ascii?Q?kj4cc/nJjG+OjNxxzSFZ+35MfR1F+sbmeKWuWxFU22KIJlbNmRaVx8Fa2NG/?=
 =?us-ascii?Q?heykp4gHvV8Bbq1Z4TRI8xSgF+sLtksyodCpPIrJE+3Ae8+8+mnXE7tn+1vo?=
 =?us-ascii?Q?YU2s39iiGhOTFB1TCbKL8rwWu76EmGEDwXn8jKGxArV90S8rxcffz/IoJjgc?=
 =?us-ascii?Q?+StTubo6BYPey0pgXv0z+FaZTvNptz00e0IYFRbYvcqQ9b2/vVN8L3eGt03b?=
 =?us-ascii?Q?MtYcPysHmu5JSNqWep+Yti15Q1tVl5Riqx6ts+c3Ps+Le/m5ddrd52L7moGR?=
 =?us-ascii?Q?lXAq18rBEvFG9LENFLoJc8jen2hDNJl5aA5NFgWSZtRCpPwLoCgmJH6RCWtK?=
 =?us-ascii?Q?3CiLlIov/La96IcqJmEOwUF6Z+carQQzp+p7XzNARrMi1Cyk0aFqZXv59roS?=
 =?us-ascii?Q?tBfoUc6MNqTcWX41bGPnx7dtstLVfbbSrOAOnPbZdDQS/mE9J2RLmk/ZKNf8?=
 =?us-ascii?Q?ebKlX8A+hi4EL+NkU8ghU6WBXmTJvYfx9/pBe4qwzohPTS/k5OzEt/IVB2Lz?=
 =?us-ascii?Q?Ff60wxWqVpZX52fBv5iZ0cnWuGQH7+RK9XnQefzrOcNamCCW0dSKmaztGhiu?=
 =?us-ascii?Q?ha6EHWN619Tmt/DS9Vok3yKDiU0b5b7vjVDv86PEuto/Po370/kMhjdhXV6Y?=
 =?us-ascii?Q?iukPrzn4dM7xLbrEZUR20hdO7mpUPW2Jc73WjMEYxB5g2YcrCRvDd2HcYfpY?=
 =?us-ascii?Q?o2uY+6K/TUGQrELsxT7xjj5brmEOWCGPaejaQ5D17BEBKa1gAx59EzCDrXqw?=
 =?us-ascii?Q?AsH1A0rUpR0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WVvlHS50/ZXO/7NKf4JVwk7yE/GkblkfU5APydrz+iQHFUwpMPYGIfa+3GsZ?=
 =?us-ascii?Q?2YGNEaLsVWJz1zCS1kGxoiZB2V+ME5Jdn3FgFvFKwXG2gDGxjK7fCYOxGOv/?=
 =?us-ascii?Q?LYfGXB0S+aHl/PEp5NJagR3sDXCxmTFLvrtvVkxp5+2yFoh7f0ivIVxq6Mqe?=
 =?us-ascii?Q?2HZuzT/AkEVlGoH6QqjYUOR1//83xPMG4Xkb9VPTkxFnZ2PVBaXH1XDIW62H?=
 =?us-ascii?Q?Q+KPWawWjOuUW98C0a4EanOqWGPG6zK/BltGbRkWXjudNRN3dD5ysx6snI4q?=
 =?us-ascii?Q?OOgHw1qUqlklU6gf3uuWBE3/QpDMRpDXDe7Ia5GyV4HSHo+cDP6Wj1M3HixD?=
 =?us-ascii?Q?4C0nZCOhSzQYPuVdp6Berwx3JTol6/TmyqQJfz8lJhGIv9onGpE4fca/Liv9?=
 =?us-ascii?Q?UU/txj1V54PnVZB348ksGD3PYDhAtglzigzeaH6T2ohteYj+nvh96Ew7ZuIf?=
 =?us-ascii?Q?Yy9aZgWedXJ2BWn93n/har/4lzELCrArXHpwqFuRdIZG1w8UizqkGuWAI1uG?=
 =?us-ascii?Q?+v5M1dMdSjuLzi9MpqJFUJEzVCo7TCTN9G4rNUycdTj0QMuDu4OxpOxtv/7q?=
 =?us-ascii?Q?FfA30YxZI6hxsI8uGgP71Q9h3Pfh7xo7U9EC9kUanPyySiMhMkEelO0GzpJh?=
 =?us-ascii?Q?vLG4o5dQFSTOcvHb6aJkrYu/sccQnMEjrxSBcV3A0vUh3DBKj85KnzDIaivR?=
 =?us-ascii?Q?7g+AnDXS/aMF13C/9VXKGxU1uQUQfd3XaRJVJ0mEWOGHM4BhQAYDNUckE9b4?=
 =?us-ascii?Q?PmvuZjboHx8NO2tvZRep0ZEgsSlxtbpK1Ufsu4cuKdZFpA2qVoRVvB9+W2NK?=
 =?us-ascii?Q?yEms2Uo+0zqTx87QoABJMOKevrqA5qYnBCAKd3CE4iOqNJ1Nc4biV7R9YIof?=
 =?us-ascii?Q?b+nZg7/KkwjUYwsOldGL2nVQ88vGzU7qnK89ZXywUs4+bP18e1eAmNjY2B2u?=
 =?us-ascii?Q?rytjBHh2Vc5vrOzupXtiEHFDdXi/XR93Btr5lNnKAo0pulERSLHVE94irPok?=
 =?us-ascii?Q?IsWqt37FbSDOaSynK6yvP9eUmRsKYvam6sOdeU4Ymzl9Zh0+vZ6WnIDu4mOl?=
 =?us-ascii?Q?GzemJyE5FP7GV9gGPNxTEkDz2Bi84pBZN9aXMEQ9fhfoqNp0Bez+MinkpyIg?=
 =?us-ascii?Q?jNcekRoWiSM1ba1ySdDTSOOywTme7D6fmHNH9booVSOnPHarBxZNVfQbqe4s?=
 =?us-ascii?Q?Eo4D/leCPkegE07TKLLyLvn4QfOAFKlXNKd8+k8yp7ZcJ8c8F5Z3a9RVy+hS?=
 =?us-ascii?Q?8RgPOXRmqWTaWo4nlGl0t8A4Wr2r9SRHpZ5Uh4E0LH/N5PJNe7CZjvQ7fWxB?=
 =?us-ascii?Q?1QiiPCQekRsJooLEPsXB1hgGoBW9Q/Ck9RacICZ4C4bdEZEJijcXdbKtuLYb?=
 =?us-ascii?Q?Xf9ZU2IVvXHpeBGtOJ9eCLcylyl8MdO/aEDoQ7lM8iMHJUiiz3Z+KxEcmjeI?=
 =?us-ascii?Q?JdnUrN1tUiU9snsMJX/jGppUmOIh8iP9oNL7Z25erjuPiMZ2PHTrlRE0Ag8Y?=
 =?us-ascii?Q?hsQy5OFdHsmJ9XcOqwkiGunuocUaSqI+SbiWmwQonm/PjFVKxnxNopbeTxht?=
 =?us-ascii?Q?tj/LO3PUdUtJl8lpET9qEftF/CXl+5rtKXwgVJzq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d66ecde-27f8-46f2-e100-08ddaa7f4cbd
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 13:36:28.5588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UFV4aU0dJsnM7ypyozPZiKLTV9HOUU9qWTsm/HZWTIHv5vM2/ZLztE79f/72up89
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6701

On Mon, Jun 09, 2025 at 10:13:27AM -0700, Nicolin Chen wrote:
> Replace unsigned init, to make it clear. No functional changes.
> 
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/iommufd/iommufd_private.h | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

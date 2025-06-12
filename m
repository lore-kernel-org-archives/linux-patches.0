Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70322F4322;
	Thu, 12 Jun 2025 12:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749731560; cv=fail; b=hgRYxcDnzHB4mcjuQ3QZAgOee9a/E15bgLTjwlmBWnLNnoXe9YeHVwrjynEKCthFOsQc95x3AQwjBeT4HdpAFZZXc7sc4MBgx5z+E16vS9AfrORIXp+X22dpW3dIT8c5HFYICHFNXwhhpguI7pwTNQo9V5Fl7oZjPcz/aFWIxOA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749731560; c=relaxed/simple;
	bh=1GkUQjLpfWhAIh9cYc5mmYwmRfyKM64B2zr9LMGLROg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oaGu6medq7mlaljcH27eNerFM7xhGe+BjRnvssIpUi2xUgPw7/keALs/0wjpQ18Zo8mQ//40jM9N+MNaZsWM2fceBfJ6L/eUQqSQkUxlwzjMIrpfbSpXgN2JObEFGADV+rGvOM5zMUMo8PMteUbnOyXI5eyLIXpmgrhZbDGd1To=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WqrwYlJ3; arc=fail smtp.client-ip=40.107.223.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WqrwYlJ3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FeWie+u5hCqcH4LqYDCRi+pvcSR9Jy/AC5+1jOfxjLhMDP0CM7/eeDakcXRuSvFKk3hmSa8VRz/lxBeqnD5upean1BD2pxH/0f+gBwU4SK2Wk7c1VP5uzm8B69xcqxLdOedfPzept5S0pUMmAAMrGoVyWE4Xt6NGLIaFZzgVFkHYH3mgjITcURcY0h05ywb1sBXKHYfNqGvEcJonAye4EXYy2DzSnWEaXDHjy3QgVK9hZjU8Trg2qvrfj3c3qN7LF88QW0Zb8QYN+KhVx9OgezwGBbsxE117GcehdoSQ5pth1gOJB90wMWGYQ7jtnQvj9tQPqnphd5xSNb7Ldxcq9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ws99A85UOMOrIlYH0Zvc3VvPIpfs3iU2ulFMGzrBlmk=;
 b=PndQlNHsPqjI97QA1t6RzASgWe0ZzsDgMD0ClodEeAvUHbTW76aibJPSCfcMfeSRBcGRvuFxplQK6O+w+F9AK5/DOWDz5NpFMsBHaFqpnzDpxwNgcrnda5wqQmOs4RLxwO9426MTmYPw8syfEOkq17L/xWbksnAhszsnnkWPqrlkdFB7gDbnYm8C6HSY9fjDVkjmX6+++RQBXAEQGXcnDa7acar1qIEQP4NHumFIMq029D7SpWuJdcFql9CacEbSxpGAc3Ru2/GdwcYhyGSRjM+HnlFoZNkGr3mTZWTn5duBXgfQqYbUJjZQnlOPhiCcoKlUg0oGrNJkYjDPrC0hUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ws99A85UOMOrIlYH0Zvc3VvPIpfs3iU2ulFMGzrBlmk=;
 b=WqrwYlJ3fgaiX5Xjwm7UbNlubb3RX7ro+hTESLM0A6hlTvJXqzgv0BZJ+4LL+a+sh/iD3FZOvYT5Gndv4ru3FsFPsqR5n5/2DqXFlJKeFguAg++JxhnhxKVbjN6n3ztx1/HlPjCDZAweVUCsmIXQbiAgM90QuWxWV0dGfUZv4DLp7MBvEqY7dkMNZ4N/BKgR5HynUEpXlD+N361wwM1bQhOp8t38fGIzsywbB692ovCk4IvF0TnNc2v50HJ4KlVBZ0dFqxy4mh8fJfqAlCY2f0/I+4LxuV2kiupLKWRQT4Fq5JaadcFX3+UiZBiIQbfwvSWaqgKhrd5gOvyEr0DJOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV5PR12MB9802.namprd12.prod.outlook.com (2603:10b6:408:2f8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 12:32:35 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8792.038; Thu, 12 Jun 2025
 12:32:35 +0000
Date: Thu, 12 Jun 2025 09:32:34 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Vasant Hegde <vasant.hegde@amd.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Joerg Roedel <jroedel@suse.de>,
	Jerry Snitselaar <jsnitsel@redhat.com>, patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH v2] iommu/amd: Fix geometry.aperture_end for V2 tables
Message-ID: <20250612123234.GS543171@nvidia.com>
References: <0-v2-0615cc99b88a+1ce-amdv2_geo_jgg@nvidia.com>
 <16da73bf-647d-4373-bc07-343bfc44da57@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16da73bf-647d-4373-bc07-343bfc44da57@amd.com>
X-ClientProxiedBy: YT3PR01CA0022.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::26) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV5PR12MB9802:EE_
X-MS-Office365-Filtering-Correlation-Id: 66b80b83-b5c7-48a7-f567-08dda9ad357f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8kZK39EX5RUS4KDYeudKk6xwT3WVu6KL8HNXzJIZXQxbV5y/r3flK9OLVlhw?=
 =?us-ascii?Q?TYOFsd+CRZUeqPOyY3AFBKuVDNLTw4ofVRpgpPhC3uXOwSYJCEeJ/hkBfz0o?=
 =?us-ascii?Q?WWky7wJN2tawlPqELlpJ7ebM5u3SZ4+vT0XmsHCnXVg54NNWD6hbwHTFrhz/?=
 =?us-ascii?Q?Uaq7GBEyYewf040DOzojoWMwo7b2lrZXz2vJX8UWCEFH8Q85w4rs+gEUwF0A?=
 =?us-ascii?Q?+ztgmjHmy74SGxuCSk2/CXflJyYhtreauVwHXPRVvtGg2lZphf0teUerXKBi?=
 =?us-ascii?Q?2OwdrunUb0naPXZEQFJL5B2Ry3+BFzJzofDjc5lZBDklweSjIvxaH0HR98SJ?=
 =?us-ascii?Q?TWPo+tECq43/Y5xJg3eCCHDczqQQ1QWiTemMG04RKPUH7iNfe6EvWKDVFOMH?=
 =?us-ascii?Q?Sqpd0LeNo2ul8aSN61bxT9nY53vtHUvkcDqF/BOrcPAA3eXyZuINfLHY2Idy?=
 =?us-ascii?Q?M4EJVMxqyz6XFImoTx/jMObfdwzIzAy+Q0fU6n1z8kSfZTJrVG+tG0mMzR60?=
 =?us-ascii?Q?NU/B3gcWyVakGdMKgFH9gDBy5th9ClocDUR5qzec90hd6t6K/qXLE5cpSSq1?=
 =?us-ascii?Q?ZmhkPPd5UKAfN390RHoPbKLvo4vK/MGY8s6UCM/8TWUqxzTO0hZ6lc5PMDHJ?=
 =?us-ascii?Q?ZpgFSrRAaE2tr0uGwuVP/TO06kZWLIxviazIF/brXQwYeNV6XXFb5d+CMlqJ?=
 =?us-ascii?Q?AMnVikjzEO1BCO9dwLgrqVYmYmd76gku+UuO+rXjhtFXnQ8dogGc4QFqHa6b?=
 =?us-ascii?Q?dO92B4rQZrvBn9YlGSjiPwLiJvwlRmvnFI8GGS1Tf1+V1HdW4J2WFfkNJdBx?=
 =?us-ascii?Q?U6YFOIi9wcUeU3qvLbH8cdUIdN9PKQqVLTNI3xOt5CfoPt/9OseLtlnaVXAR?=
 =?us-ascii?Q?MYd/Elv26Gy14ecVxddkoM44U8RGYCGri3JsV4JQki+jvmfQVRXljOBJnVHY?=
 =?us-ascii?Q?WIMGH1BlAPTb+Kza6CgRiY70KnEc9/thoTbBY2L1601tjdLa5I50FFWc0x9N?=
 =?us-ascii?Q?CRzxX945QPuoIPk5GMunuscmzFrZK7wownC14/ncV8uxxzsch8EtWCCP7r3/?=
 =?us-ascii?Q?t5c78x4m9UzLCROUb0KWzba1ZgyVYR+qMKf8MupQTnTeAG29sSVTEOfS7Kcy?=
 =?us-ascii?Q?6VIW7a0PZJqrhrhD4lwiUhEXgt/oqYX21RSR9GHJ95XjAhaSOXvRz69ahRov?=
 =?us-ascii?Q?9pcPSYdd5hYGucuulZH3sry319/BqNBJqpqZZBGZzQSwTxhBsr6o8Ib7AXYn?=
 =?us-ascii?Q?t7wENsKinkiZeVVA6KSORg1LbnqaXpXH9uGNtS/fI7rRrZVF1+sxjbMoLRTn?=
 =?us-ascii?Q?gZ66eC6OYCkdc4bcqXdwkbvMGTfFBLI9WZomFvvoeExWoAhweRXHo8UWklR7?=
 =?us-ascii?Q?Z0xV3Wee2Fyxjd3lFeOAj/pYPg6rC5u3BwiKurgpUV3Q8W4VCQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c0nPe+61AW5k0QmTrAQanFSOc95EnRKVuIrzckiokc2niZ0XYKpHCac69tfh?=
 =?us-ascii?Q?UOK+MNjkA2I9YtMLFIZQtOlEOsoCcgUqhC4HR6xOBgjNBoescv/RT06cC22l?=
 =?us-ascii?Q?JuomL9Q1bAp2+4Nh4lzWU+wC2IltlX6ahffZ/mh5bisxb3PuAf8bm5uCJedY?=
 =?us-ascii?Q?v09a5QXOQT9ZQ+TznTmdJEjRdRJ3Oirm31Sd01Cb8y+m/Hh/V8MDok1+4rHU?=
 =?us-ascii?Q?/z6I7A3D0bpC9MJLukBRthfgu+ZqKm4O26wUAo4If40rppFJUIVzIYIaq9hu?=
 =?us-ascii?Q?ahcQP2vskkH8fOnf7EUGifwiB75M2EBcYv/D51AUn4e6TYMAC46+ybL24N/E?=
 =?us-ascii?Q?Sa26n4jZZL46OpZ/CHoSl43gCq6ghkpLkAr9c9WpZ3EJCPmS0TnIFFgUQNYB?=
 =?us-ascii?Q?nLCReIzrfBO4K0KWKtiZ7wZJYkrYjgEJmcQMAE5GmwPE93OQFSOvFQcEmgu3?=
 =?us-ascii?Q?D0gPnERgvUa0P1aP9hSYrUm6lc4uEiVoB/GiDZfnByuNOo2yRG3gsg9oJFNQ?=
 =?us-ascii?Q?zObMpfoLFUSLyqW1Y70/tz2iAEynbj4qSZnpa50H31hsaChBh5dJ9IcEzwMH?=
 =?us-ascii?Q?5yBDgaWS+4aFBP1/6tQ0mMRvA9dfZi3MqWYKfOVgYbsujBQPSs6TKKyvtowI?=
 =?us-ascii?Q?O+xelVH9UHeLeVEFEcSoElUJ42LOYIKDjFQtNHv7C3zzu7Rqz0tEI7DHRkD7?=
 =?us-ascii?Q?PzQe9eaFpEtYM8FAdL2QjldZqAY1cAp1KpxhCKq1gc2q5s0pxVaYc6NmC5uC?=
 =?us-ascii?Q?V2OvTf8KNUcersQxMIjSK5dZWtxj4T1uCnI2j2ecovHqZ6lqJzwHG7nzrD2X?=
 =?us-ascii?Q?lOua10+5xPc7syH4Y38NDwNQYnohLjUn0M3ffyotzH6DeE9Zl4t9CI9GwllI?=
 =?us-ascii?Q?ESQvxw1mIwFW/77woKTrJ2QLsL5iC6eb+IXuYmWru79NXfXv64T7JdGxCLdS?=
 =?us-ascii?Q?r8DMEuWdr2Xaui2hLXLwOuoukZgfWh7cnZkm1UKiUeiZ2gMug0Y6adqFEtp/?=
 =?us-ascii?Q?e20vSxlyiiTy9vSbgm8+W6TxMiUY3b1tJEDCQ00LTekLj/sR1awxmnzv6OwQ?=
 =?us-ascii?Q?dOy8rArifoQt/0k3HFPTV4LYxjcRXkpkSCPz9GsfamX7ntQrClw1WJkT2po1?=
 =?us-ascii?Q?u8JAC82i770j8Vk5WubtHnqtK1xkRayvGvbLeJuTAyobwcQ3Q1irDIaTk++D?=
 =?us-ascii?Q?w2t99r+gdmVtQo1WcKbygpuQlORBjPil1DKIw3Oyum5f1zBSrmb1iiUIc7z8?=
 =?us-ascii?Q?PGPjRQ+jWZlG+TRsfC6grCbSeqnxIbVYGKOAWCiMjgWT2UlMjkL9MqV6WDIl?=
 =?us-ascii?Q?NiC+8D6aEBRPAsKvfCcSxNvsyDGvZan5RFi8BM74Bpi9wKA75gzfMDJg8hnZ?=
 =?us-ascii?Q?fZG6+XMelVlB2Swz8kSugUvTDtoKVMK06CYtFAtJoOS1JHrQN2DZIvvS/AVi?=
 =?us-ascii?Q?dQ0UOlC9uyLkTu/b52TOk9LTRuL1q8Ajum6+xRh8K4fWmG6ZNKRwlNFMBdkH?=
 =?us-ascii?Q?D9nPSeQUNeIImeR77TmAX3k32Xe935V6ILFQKl46iBV9Oh1u8gLPcw9oDNBr?=
 =?us-ascii?Q?HDSH0wheqVh20GiAyuf1BSEuH5djhEm33+YSQTQP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66b80b83-b5c7-48a7-f567-08dda9ad357f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 12:32:35.0847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W0oVaZqV9hy7B+xFF3s/U8g5fW8iWZC+RYdM3B8egdzmO222ty5L/CW2IjnjdOWB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR12MB9802

On Thu, Jun 12, 2025 at 10:54:00AM +0530, Vasant Hegde wrote:
> > This will also make the iommu_domain work consistently on all PASID 0 and
> > PASID != 1.
> 
> You meant PASID != 0 ?

Yes, thanks

Jason

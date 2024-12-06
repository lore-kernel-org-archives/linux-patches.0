Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2074.outbound.protection.outlook.com [40.107.236.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0814C96;
	Fri,  6 Dec 2024 00:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733444032; cv=fail; b=QK6ZmQDzVBtkdwFIC0vcvHrcW02VTRNKcP/d5UzDdui16VA2Vo5yfq4OhU3gPWZlpIHeYziJBPTTuIbhG7h10f1JBXxajbVv450sZXDksy5C+GQB1i7X1gNsZ6Ni4avMKs0K6cihbbE8G+4cSrAFfkG8ZG5rOU9VOzZSvSFxcTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733444032; c=relaxed/simple;
	bh=nEft6tJb/YSNDEdk0ItVMmitkcN9mXKp/TjVjdpoTWA=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Od5cBkQ8A20REkleyEzQCJptMTifPWtmZTUIKqip2tcwYF7Qkw3+19Hf+eBahkZAtA38RFAHA5T36CEfsOv9Ge9mgLIn42bzqxgpl2MEYSeTh1c4m/MLXCuXzm3hzxPKAzyMyDxB/V4n+JznSyChUshqbvmieWi6omHEgiZTZdE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DobusXD3; arc=fail smtp.client-ip=40.107.236.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DobusXD3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XaJV1FWjfbK6E34VdPO1VrjM4lsY/bhy4kP51hKAjznNj7Rn6b587bYmLQTdaXotdCRedxm5k/8cxFlL1jVU77q704UfG5oKn5T+dihHqyZrRZ2lnUNDIdadZrBiQcEAf/44M9Jfl/TIl9UQJnDi8sLqF6KqTw621jhAKDTsRTBE/coc13ZyC4SggVSoGQbkRfjAN4Eiyd8FdwV6ynHydPG0fI6PZHAnzVyRKd64yCWonPjhXkGq3+hk0Alj7AFHYDslNfnrAyLYXtcseMEeIQ6PFgd5yHQ4awyrFb7PHABdzoWrBvG3fnovFsbZk3fH/6pnTidQx8wzHei6dNauTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aNil1B8b27xgoGaci0dh9z5ByTj3exqKwOTeQHNOLlk=;
 b=sy4xYxbjm61pOWOY3RgwfBsWRFs1tlvms4M/OxpoMINNlsL+0CzRdpeol0qQfzqsfezPtR8Qy4YD898soPQlxuCpAUHdya0CwnDYu/NQZOGhr3itoJkEivld2tTkYryquNn0nZ22mLJaxtjzH/fRG7rPw1323o4/zvo43o2nqVqPfQswIZ2tIWuNfjMhg+KiW+uXeqRFXOSQuDs3kvMN6rbvW9I264jyhW+DDPTe6sNJIaiGMItXwBGoI+u4w5/X9XIQcyOKC1v1hS0usBP4TxUN+hhYNLAMGGOmgvh6hI96H7ra2IZGmsDtaBTmPCXYLtGskHLDjbD2qF4ygPLxDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNil1B8b27xgoGaci0dh9z5ByTj3exqKwOTeQHNOLlk=;
 b=DobusXD3Ba++oul0V2/i2KRofRFn6GRndUqKN+WW7U9jD/TPPowkfGV622FNw3m+ZNXAx0vT6lfwAVyiM3e+vrPgAk1rcj7xPY52Lw2M6fPLCsSv9/ezsnT2gh7AXnupWsp/ZgfYpupLvhNg3hIfKH1L34XaHKRsRb67MvvFg0DRr9qlzMv9pnCbnmPXphx9v902Fhz9nO2nJtpclYn9EqKP4n2fuaMRtoiB9sJ/9tDtR9jP8wZ1J0A/53WsyS/udLxcDslxjhC1o+2FprhWrmo2q+8U9R945SpwFZPBUbStayoKd4gUoq6HlRJ479VPWadG/tsPtJsJTWIgEePFzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB5805.namprd12.prod.outlook.com (2603:10b6:510:1d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Fri, 6 Dec
 2024 00:13:43 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Fri, 6 Dec 2024
 00:13:43 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Joerg Roedel <jroedel@suse.de>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: [PATCH rc 0/2] iommu/amd: Fix locking for domain->dev_list
Date: Thu,  5 Dec 2024 20:13:40 -0400
Message-ID: <0-v1-3b9edcf8067d+3975-amd_dev_list_locking_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0029.namprd13.prod.outlook.com
 (2603:10b6:208:256::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB5805:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d022787-3010-427b-9ca8-08dd158ad807
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3U2MpL7QEV+It1xRrZ0CsSEJBjCu0ykQW6prTv+G2VeFEihCsFK/8NhCyOPZ?=
 =?us-ascii?Q?cYANIW5A0DCGl73YXqerg/Cz2SXbfHYifGMZo1zAVABtmOF+mAcmJ/hwP5Ju?=
 =?us-ascii?Q?kKb5Fy5kphp1HHZnF80WQJIYkFj217DxEqG9hZEvB7wpT9PoiDEsMKXqdU3b?=
 =?us-ascii?Q?YOAsSli1DQyewshx1zd7xr8afIHl3cmFhJrF7NJ/crZ4/+splWIRMJihrMDy?=
 =?us-ascii?Q?BT6Mhgb+hQBXhUbqCyQOWl2dEWiFYEcoTT1PxKJushThQPdoeVSSRO6kBDSG?=
 =?us-ascii?Q?v2cbV/q3e3YZYazORc4PoUmUiaeZgdaUm+mQ5FKiGCyBzWatHKq171o9SFoH?=
 =?us-ascii?Q?qtRpQGBVVSxcuU0u73kcIa3loiv6T7TJUyctWLu8+kZHpiEm19Qf1NVcm2Se?=
 =?us-ascii?Q?DqVPSwoKjHwrf497e3FN6I8KJ64ZuZg385rAPh3u2xLxK3JBnli/KOGhdCwn?=
 =?us-ascii?Q?4T1quVby3yI2H05JcmFWESe0yV/BN1hFo09Acg8em+CPQrCsLmppULhLNprN?=
 =?us-ascii?Q?H65mznlZ9uUD35fRnp2IuWi1KWzfHW3+mCTArIoDzYpGMU+snDg/oMUBEOvu?=
 =?us-ascii?Q?IgNBHPwHb2aMwKZ0v9GyPK0VNfzHvS0UCiCYmKVYbsjktcazOniqQ1qZ/LD3?=
 =?us-ascii?Q?IkISw8vBLWSRz76A6ZxQZNmuOmq5zG9UWBfsyJ84IkbIHKQOg4loRh9I0i97?=
 =?us-ascii?Q?MUUnQlkKp/F7mKpzbDEzqWSxskEBpmo2GOK45bopvDPITItBmOPzGAQ14BrH?=
 =?us-ascii?Q?YqeQjCs+nSoQp1fkwyadDHuEQ6hF2pXjWqMJ5yVZXSeBU5dXWkxtT6hkIYln?=
 =?us-ascii?Q?KKuY9TxETpkgBvgvHot7Y14kBuf3xFJR42jUfcytcWWTVP0qwL9jTcPggxMr?=
 =?us-ascii?Q?OtmK2J+8ppwLNuqum1vqsG4dhyd4J3mtKEx78sRBKruD2iPIitIuCdR9VuZn?=
 =?us-ascii?Q?ojbXO5jAThcgDAW40WRSDIOWVFeVgqCEXQ98Bsdibn4kMuTAM2tFwVXZKKro?=
 =?us-ascii?Q?hz3G+ukIXOEUDtCn3D1Eq2WTMnsJWSAA9iuNBJjMFMbbZ0Xvh1+9+xEMQFL3?=
 =?us-ascii?Q?XLe5n6AIOSiX4HbiDJsQIVSxxreS1MUyWCczoUHmZEhzsV0bh1fKdlRWlvLP?=
 =?us-ascii?Q?7gFZnoLhDct6pwDSOygk7njQPO1BD4R9aEnZmDl5uQa5N6Rd6Rvl6kWzksgG?=
 =?us-ascii?Q?3aMLzoaHfMJdOUHxtff+z19JxxMXzciiaWr6xo3Vo7nCrphwxJ3sQurTctcP?=
 =?us-ascii?Q?EhJnZf8SbhkWLSgyypK8FnfSmebSwOPPMHbj+iZUbLqIKp5RHygmtoj7Lx+S?=
 =?us-ascii?Q?blpyHZgpQQ/dX9wqfR3g7aSLFjQqJLSvYqVP4cXprMKlRQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HxoiYcApYY05S8vpCSWxfeibXxJMUly4WoQPn5BMBg42VyZqzf5xskAJBAi3?=
 =?us-ascii?Q?uNWsrVEyp5oQKyBPeymhZgSoTLqeIjHbsYp3PkzeQD9VY7fjZ0mT9bBRMgZM?=
 =?us-ascii?Q?oJYWHgDCRawXI9zGhM3h5awsRuD7sBBqJWYhqJVQsNNdlHlqkZlhXHAE+lPh?=
 =?us-ascii?Q?uotczsTWRgP1qP2ePnz6o0hYUqMI+4cTQKJ22qm+eZwNznkaWIhPumaSAUaZ?=
 =?us-ascii?Q?5QKKpFvE0uKtZzor8UPVR0M8sDNNbX+BxjzptW60JHvXLzvuBpW2dYv05vR9?=
 =?us-ascii?Q?WMpEXFUWoSQnTkOz2Yv8+R98CKAaYp8iqlQXq7sQHJeAWOaiYOyHqOu/BNpq?=
 =?us-ascii?Q?Z4pQCuNf2gSEOV3GHXpyN5OzuhkFeehcIpt4MwfNZvRhlsaDfUYGkaRsyBH3?=
 =?us-ascii?Q?S5Cym4h5JVXr0kvRzIC3/FLHgBgeMI/fWjXnB9owZGFMmpurhg44W/7ayFXf?=
 =?us-ascii?Q?H4z4rSnezccj1tdNOhkEQKU8rE/i8RjQ+Gd69EIKJgUcd6TgaOaBMr85HOP0?=
 =?us-ascii?Q?ZD3nqCcbhAq8pAj2Oi1AJbTvP6wyrx2x+OOoAtdBtKyCDChflsM1w7Y3n23T?=
 =?us-ascii?Q?+qt5uEI7GAMNbwvbHzzUtro6X5l1ul8upYZSmVS7ozHEkd9kN2Y+BegIioZE?=
 =?us-ascii?Q?UWY9qvteklyP92lbyVOurki1wHxU27CFCqd6VKHBOmaJ8i0psOyw2zA/s812?=
 =?us-ascii?Q?YhgwMS9RhFhHjJHp3ib303JWeKTL3mmwyhlI9u71s8A1Dqtb8FiYi/fsiSGk?=
 =?us-ascii?Q?FzzlwGrEvxbM+SAUHbpXbvhmZbkX9cmgM3ZIQDXgaj1rakkfT4AKEFqevnIq?=
 =?us-ascii?Q?ICIXw+8Edojt/rCNUXjiIth1oAU9BL2qp8oYlHIg8bDqTB7jmQlQXW9J/lqO?=
 =?us-ascii?Q?8GCxvgSyafCTxegVd527deqq2DPi5wBREd9+51BawUAvwcqekbDjpIIeLLyU?=
 =?us-ascii?Q?dDr5ZBlaM+iiYFZef+VTAV9D/RH4yNFJQkxJQl9to077CZZrOAWnK3Tbkhw2?=
 =?us-ascii?Q?6LOIvg0TqrHjZXoBG9TUIwGXWWYA9nc8OxxYX0kgssKlncqhIXyYcezEMt38?=
 =?us-ascii?Q?PLrp7SQdsUDjQQbc5lgnca2MYRgvr3XbzJNDb0G2yku8lAQ5aRBQuAXc2q0T?=
 =?us-ascii?Q?sZ5eJYfs8sL12Mq+Ru1UcVM9yrZ7UnKxlkPYxrcgCKpzBqKXsgrpCg7ZaNCc?=
 =?us-ascii?Q?patC79n/FJ6PbgH4fgIihSF+k1d62HVk6yE9f7kbfcyL+0C95bGeEHR/TSkm?=
 =?us-ascii?Q?WtJWbWfv/2ZQ1RaifPXSrVHbOwloYAj6mDJLUH9TkXe+lW8+nHeLGo89qWXn?=
 =?us-ascii?Q?/Ct408s7b8N0UKHFIF6QJtxgzRYTwEZcCWVX4Y+p/9zMXCc27C38z6kEsYZS?=
 =?us-ascii?Q?qLetjmUkoeQzJg+/2/glC8um1phrOWvzRMWMKNY80NCg/ZyNEE6+szeKeAX7?=
 =?us-ascii?Q?HuRdl3G0Iy6mfq6lce9A9/xaOLKEcyoBdPeFoDAk6fMJLTaU9zQWhHFtmSBB?=
 =?us-ascii?Q?zdk6YbPTOLPM4g27x7Zw4J7dvpxQNbAUdRe9u21In6NJZqFad9so6xUkkSRS?=
 =?us-ascii?Q?xCSrhYovDxFuIGJqN/8JKwICJ6Xpt4Pbs6MgvsFc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d022787-3010-427b-9ca8-08dd158ad807
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 00:13:43.2079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7DrbixnHjVOstxHWPUqfyNRGYX8UMT4bTkev/E9FHfyioUEG7FaRu1vgY1p6SVi8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5805

Two small patches to fix locking regressions around this list. Found by
inspection.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (2):
  iommu/amd: Put list_add/del(dev_data) back under the domain->lock
  iommu/amd: Add lockdep asserts for domain->dev_list

 drivers/iommu/amd/iommu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)


base-commit: 457730bc1f55c2b29d374e10cc125506f2b3cde9
-- 
2.43.0


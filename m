Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2086.outbound.protection.outlook.com [40.107.223.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182951624FA;
	Tue, 25 Feb 2025 20:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740514731; cv=fail; b=FrO75X6Lz1ZmoUYmn+ohyOt2J8SbU3uFwtuOpYRQAgdp8upSn021Mvb63R/uXlP4bLPdihvDZ3BVl1tEJBEpN9MeqdNR0igj/K7ownELWvqFlCfOQC2le/Ti7q2g0kCouHwAZEZVLLqd/nmKVVtctMYEP2aYQITGO48bs3Cwbb4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740514731; c=relaxed/simple;
	bh=QAmk4TwmtSW3rkkzTP/k2Jg1zgmCkzLkkyJ2pkVNKHo=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mTW0Kxr8MixLtt0DyL5a6BHovpF488QgksbK7/23CqxeF7xTj5F617NDzMosO5tUGhy56Ue/6Scnqdy/ECtjZlAqhIn3lOoINUbicIWxvQojc9E0zfkKxTwoa9FOD7q0gTO16W7s/ANF9h3IoRkqxlZep3rCQmaXzRr6+VZy8AM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LtJZSq8d; arc=fail smtp.client-ip=40.107.223.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LtJZSq8d"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sCvEKhQrXhNa6Uis5T9Yvy9v0IfNrL6QDj2rg0OMeP4vTSQGX3oFREvh5xKYRuXbnpkOvCWDaSA5XyU0cjxxl5EHv7fjxPzJP5p+a+LjeSOYPkMNFZD6EibGoOOQJDodURNQZSC76mZFZtnzURcy4HK0Ai9AkDBwgLGZ7B3BwDszni3OylWwoZuTYHO6PZqkE4aZk/kn9nyUbxYt+CyfBr7qnT8S5WBtNazT1kiTQ/5g/pM34iTX/uhkY1Qfn5WPk0kTgia3ECRn/VyGC4CqfdW6OArp6ad7KdJ51pUzKBZSopakRmU64DZuGSz+eFnR2WWtH6A3DTxH+muqKzzdxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+Wfp47wFUZwxF8rr0oKUekbERNmPTH7Ydeb1PR1NtM=;
 b=g+tGamm7+aZ0aKe+MQ86VOZXL4dlwMnXZ9TrDw/7X7RW0D688qnXmEvCvAzPWL7tkfd4hI4/jGqO6OkToLH0llkAdhrncA+guxyVNtVO9HluVTfntL3+LNFDwfE01OnplAT+XyvbpG9SKFWl6BBhs2PW+Wj7UHWkgSW4mVA4J1gJb8pKD0YyqrgWB3JYkUj+dUv/t3KQF6leuPf76u7bHRUOdVlAZqGPfC2K6cEl1NTLanaa51aJPH6aBi9YqEpQCB2ABx9WIKw5VepBKIBQl7i/22F78bWuEr9neIQ0Fq49AnJE+0RbpdAIpxvOtMs10kf9cksbB/Qhocc0YvGMKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=dabbelt.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+Wfp47wFUZwxF8rr0oKUekbERNmPTH7Ydeb1PR1NtM=;
 b=LtJZSq8dzFeqn6E3sZzj+6QzQ+QLUYO6b+8Rnb8fCFJziFuGSoVrbl0nALelVn70LemrhksoFubaBlKWSVs7C7h1v682zv/MZBsxYxmA4rKqCU2x+N4wlTRNTowZMQMVkTgksIGQBErbT7aOt2FGMBKNw5Hs8H1ppxHmXJb5TDAYSvgC/KXrpx1MGofftrqfeVzRnPuEb1ub2xYV1ngrQ+LfLoVvPwZLF6K9ZzaCNWzTgwCMpD3m4nZ0pNQHTJdSLyyNb18FyoxMNS1cDUdcOccIcBJDPkBeRdY/NBRpbax7o1gCWh8cfA85xQufQxg3n43Y0mAd1TrSQdWuJUhlrQ==
Received: from SN7PR04CA0044.namprd04.prod.outlook.com (2603:10b6:806:120::19)
 by DM4PR12MB6446.namprd12.prod.outlook.com (2603:10b6:8:be::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.18; Tue, 25 Feb 2025 20:18:45 +0000
Received: from SA2PEPF000015CB.namprd03.prod.outlook.com
 (2603:10b6:806:120:cafe::39) by SN7PR04CA0044.outlook.office365.com
 (2603:10b6:806:120::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.21 via Frontend Transport; Tue,
 25 Feb 2025 20:18:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SA2PEPF000015CB.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Tue, 25 Feb 2025 20:18:44 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 25 Feb
 2025 12:18:17 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 25 Feb
 2025 12:18:17 -0800
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 25 Feb 2025 12:18:15 -0800
Date: Tue, 25 Feb 2025 12:18:13 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Alim Akhtar <alim.akhtar@samsung.com>, Alyssa Rosenzweig
	<alyssa@rosenzweig.io>, Albert Ou <aou@eecs.berkeley.edu>,
	<asahi@lists.linux.dev>, Lu Baolu <baolu.lu@linux.intel.com>, David Woodhouse
	<dwmw2@infradead.org>, Heiko Stuebner <heiko@sntech.de>,
	<iommu@lists.linux.dev>, Jernej Skrabec <jernej.skrabec@gmail.com>, "Jonathan
 Hunter" <jonathanh@nvidia.com>, Joerg Roedel <joro@8bytes.org>, "Krzysztof
 Kozlowski" <krzk@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-riscv@lists.infradead.org>, <linux-rockchip@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <linux-sunxi@lists.linux.dev>,
	<linux-tegra@vger.kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
	Hector Martin <marcan@marcan.st>, Palmer Dabbelt <palmer@dabbelt.com>, "Paul
 Walmsley" <paul.walmsley@sifive.com>, Robin Murphy <robin.murphy@arm.com>,
	Samuel Holland <samuel@sholland.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Sven Peter <sven@svenpeter.dev>, "Thierry
 Reding" <thierry.reding@gmail.com>, Tomasz Jeznach <tjeznach@rivosinc.com>,
	Krishna Reddy <vdumpa@nvidia.com>, Chen-Yu Tsai <wens@csie.org>, Will Deacon
	<will@kernel.org>, Bagas Sanjaya <bagasdotme@gmail.com>, Joerg Roedel
	<jroedel@suse.de>, Pasha Tatashin <pasha.tatashin@soleen.com>,
	<patches@lists.linux.dev>, David Rientjes <rientjes@google.com>, "Matthew
 Wilcox" <willy@infradead.org>
Subject: Re: [PATCH v3 00/23] iommu: Further abstract iommu-pages
Message-ID: <Z74lhX646QAgj+Pf@Asurada-Nvidia>
References: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CB:EE_|DM4PR12MB6446:EE_
X-MS-Office365-Filtering-Correlation-Id: fa378399-1df7-4112-295a-08dd55d99aa9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j4roXWx5zY3VU4LvfxWFtOAqd6Z/Oeq1JnT/4WUreGed0G7hao8Ocy5xqHSI?=
 =?us-ascii?Q?QkN3TFcJp1tQMmQeEzmGho495EHZ+zlZGygzLS46JE4/yRjNX6ET6Yo0tjk6?=
 =?us-ascii?Q?R+BHRsnqRKCsopqwSStq05v+oUPNsn75copRIgo6kJcR7uOZDNHYiV7NRp3g?=
 =?us-ascii?Q?t+JZS5Sx7zsvEmOwZLeOyIhERBKQIlsAb5URpMI7NU6Q0GxH89RZL271YHSN?=
 =?us-ascii?Q?58h9P9ZP2bRE21jFgsunFquZb74qpGIXTQKth3eHbd9JK/6WaAsQ4/NOrB+4?=
 =?us-ascii?Q?e3+GJd808e66wS6cbbmHQbYo/tmUmHejKBo9JcoMLkykHg9XuO9Un5cnTN2X?=
 =?us-ascii?Q?E+erxPgQD3ZlijY+5dlxsIEkY+mPvlel8M0NiFAO4806VLWzzsM/dM99rFOQ?=
 =?us-ascii?Q?nQnug+flz5iIuwW0oltZvXHISRtPDTce8yKZ7yfF97Dqsp6cL1aV+77+EBLd?=
 =?us-ascii?Q?46J8+KSLzxlQ8vrs/Wlw0i1faebufALPF8soaY9Bj8PUqNsO1SLL11BLI0y9?=
 =?us-ascii?Q?G3sLEd6uDZwmLzBWXK6rOEVfyjv4mK3V98iliWfEIqZSU/VzRv5MUB2hY4l5?=
 =?us-ascii?Q?UsVUACo5FJANE87Bm/k9yDba81uy/pRMfHiDlhQRBneOnxn040AJL7aK6xeN?=
 =?us-ascii?Q?9rKVP9Y/S5z4hUo5A6m1dUxQc+AVgTNHZiZSsIW9Df2/rOCWhanfLV2Shevp?=
 =?us-ascii?Q?SX0rjrNo+uACsKYkpX5bvkGT9YTJZDSNKXYmR8GWlZt9ZuL+5X1DZMd2SzLt?=
 =?us-ascii?Q?oY88KWLzcnm6EiU/bNxqEDQzFcbroIAAHFcjiPTGh1wI82yjZJlvX8Zb2AyL?=
 =?us-ascii?Q?VU/yfkdeF4/0BZpXGDipMoZSyVq+UQr/go/XfWmSzPzHvCRF5o9HDTsNR6uj?=
 =?us-ascii?Q?ZJKJT7KX0nQzXu/50hVzPHmGDUNdAhQo4r/y9wsbQu5Rtn4LtXkuNM6YVhg9?=
 =?us-ascii?Q?M6UxJuSjoDZb+wQPei2aMKyLu6fzR8xqk0ehlhJ5Jsf7w7R+othUbhT1eB0T?=
 =?us-ascii?Q?l0X1ADY+Ibr8HjEJleNeb6mCEh7Rnr7sXuZ/Cz4CZdX5egk0G0wLAmStq2YJ?=
 =?us-ascii?Q?0douXwPLTmC2J/55eJo03qY7hujtv/nodnBsW8wyX7RZe21I4Cl5LgL1u6F6?=
 =?us-ascii?Q?lTWz9mlvhNrEK4bawE8jN4IWYydDLzg/ukqYyO4MC4G+OQsJjf9ottTq63mP?=
 =?us-ascii?Q?VYeJoBqW8k5rHlWs/5Rzj0M8MTvWmNuGLhTshj4znUV93P0jPTKtI8fEZEcI?=
 =?us-ascii?Q?SnQWaql/bYoqZYCjnZiR+TGH2dw73SZ904avonehq6OIq+7oALiFqU8dDMJt?=
 =?us-ascii?Q?ACucnoqkOk+oRCsEV4WaDwxgXKUUMzgiB2abRxXxOWXr42941LQqd0HUTbHD?=
 =?us-ascii?Q?h+jtxJzVTjZDlzyf0uv7x26jIQ75rhXi2wqh0dzuqR0dgCz3f+ndtbbGW0dR?=
 =?us-ascii?Q?Yg8cMe//qyWWfzcTGbkxBiLty9r1ZRR8j8IJqc9VIkQTnDBIQfAcsy6e29+0?=
 =?us-ascii?Q?yKyBLnkn4g2ZxP0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 20:18:44.6270
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa378399-1df7-4112-295a-08dd55d99aa9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6446

On Tue, Feb 25, 2025 at 03:39:17PM -0400, Jason Gunthorpe wrote:
> This is on github: https://github.com/jgunthorpe/linux/commits/iommu_pages
> 
> v3:
>  - Fix comments
>  - Rename __iommu_free_page() to __iommu_free_desc()
>  - Retain the max IMR table size comment in vt-d

Ran some sanity in baremetal with some DMA/ATS flow on ARM64. Also
tested the kernel with a stage-2 setup via iommufd running a vSMMU
enabled VM, the guest kernel doesn't have these changes though.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>

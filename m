Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2084.outbound.protection.outlook.com [40.107.102.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D6D6116;
	Wed, 15 May 2024 00:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715733433; cv=fail; b=M051GsAvpNWpGmiJzvKnKcY7uNI67AYXY1c7kOXzGDXwJkANJfTX86ZRiemuooqvClMBydKpm+fkqBXCnF/9CJAqT3h2gWsUoHWm9oVfjlREoK3wsYI9lbv8+Q+mhQ9dH/fKub0yRJkhkY1vlhibwBDk8QeRPpS8USHcHQmAMjQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715733433; c=relaxed/simple;
	bh=nJkVGh2eDqxlAiKr0xIx1uO88odeHk3TI4MbNBCDFJY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qwFAzmgoMoVTAwxrJly2M5vPo8UyoGdCZSOKlKRz12tRxTug+7n8SmpM8S7E+FGOTUsojywG4hJti1ovGlcd3LSOzEnP7TCDzh9Yr8YqvDaCp65p0zvcRzZUhX1oyf4ceS/WCuIfNnV2ibwJLWcHXUF1v59R4q4WWtI2bFjy3PE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e7kxzY2Y; arc=fail smtp.client-ip=40.107.102.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e7kxzY2Y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1Rbl/1TTSkvoWI7LX4JbXNZQAvw7r4Cd8BegydvKSPybMMcTKYg8hOv4Op+6ZWXQFSiYEP3Ld2xxLyW3rpAqcn0UXXDHpVg5tH/k8EL4N1h0iUdcMQ5W+zTNzLd03b3saOBQrA2z9kBaF0iz2EQ/j4BKe2jH1OXAnobYJVL8hnWe+kM2uFoKwuJyBccCLpB8DacrRV9HszDL8Ubxc6kdsyScQHiuQvjMY3EvVqlLUNrAJ9TCjLoyVz9dlJDfuNcqw0d2mK89gFGx2vvym/EwgeI7Wgrr6FAyQbGaPB2t1hKAK/fLwkb7nqTT6YwWKuJ0LzPtnPfCQ+sc5d+U//ikw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FvR4MLhjxGQhSWAXbNtKqoqSYHoQ+4OR8aJxNh8jawE=;
 b=LzTEHr+4MfrnJj4oK6QVp+LzPHkSq2LD+/B2B0qPErUcipMjuNO7Y2RHSrcgfw/80LyGL7/fryXGRfYVMTeEwN0sksQlwXNv4XA8c0qf84aKvNrcSmKyCfHOSkf9KMYAAEkDGjIVFo/2m2CG6eqqgVJXhXf5LKbyMgAbyz7TvwCQhdjOXQTmEi47ZL1IJpLkxowMvv6fOfBaySVqm6ikAanUBVYepueNwEEbQTBfY5JrVHYNuWiaZtdmrtcamj2QCUwgwb36twkc+6CpsKh+rAgDQg7RrN7FQgdZvpAQh2tBOpKuE+dWuRHrEqhS+GxtyFES+YDSTkhZ1jPKWvCg2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FvR4MLhjxGQhSWAXbNtKqoqSYHoQ+4OR8aJxNh8jawE=;
 b=e7kxzY2YNz+T4cDg/hH8Q1JqHUhzB3XUtJs/uyyzMr/iNtP4QIRI0HK0fA3bh+OZcjYEk2gp+qfYrRshPuY80Lg4asHgJO7UZCo7DXYUnFLJfzlYOewiv1/dcKp1VbrsoLrK5AaQ4BsMOSde0B/v1XkuvxG7ElWsClPshNQx2bGbT6IojnrAgp002OFBwNWv5g/9h7D7a7TNJ6r++3CqpABkXa+PvyDEzFeLCI2SlTyDnpst4ALIKx3H3MtRuAFM44jk3wi0MRtK+VvPZtODZEEqOH13sG17+LrqCbdUL+vg6Sm7Lh2vqR4so2wBIA8vdzRzYJpaYXAzsrdAmoopVw==
Received: from SN7PR04CA0183.namprd04.prod.outlook.com (2603:10b6:806:126::8)
 by SN7PR12MB6931.namprd12.prod.outlook.com (2603:10b6:806:261::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 00:37:08 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10b6:806:126:cafe::db) by SN7PR04CA0183.outlook.office365.com
 (2603:10b6:806:126::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55 via Frontend
 Transport; Wed, 15 May 2024 00:37:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Wed, 15 May 2024 00:37:08 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 14 May
 2024 17:37:00 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 14 May 2024 17:36:59 -0700
Received: from nvidia.com (10.127.8.11) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 14 May 2024 17:36:56 -0700
Date: Tue, 14 May 2024 17:36:54 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 06/14] iommu/arm-smmu-v3: Do not use
 master->sva_enable to restrict attaches
Message-ID: <ZkQDpidgI8l1Vhc7@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <6-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|SN7PR12MB6931:EE_
X-MS-Office365-Filtering-Correlation-Id: 92a03fb9-84f3-4f99-a6cb-08dc7477270f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|376005|36860700004|1800799015|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wKuO93UU41QZlm89DpZZZ1DeSSIjKTdsONHc28qCtdoDgBFu0F1nwrj+7D+d?=
 =?us-ascii?Q?crIfFmZ4+vsxVhY6JxT2b1BEbDM5kN7RjR74QVUtqVINQ3q1d39wcFO6S8U8?=
 =?us-ascii?Q?SDOMRcpCMcNBuIt+SLGfnbMJso9r5USYpzULxRc7hzsbDHc6S5YpMNPCwDhW?=
 =?us-ascii?Q?yJ1ZqmIcio6tRy3gRw3JfMCzU/ljTBv7nlwWt92ySyEl+TRDRyOQ/bsTVbKX?=
 =?us-ascii?Q?DzLbZ/Es+kXevEwNp9AT3myb35F9bjBY/GDUGz0lOyfXsUVkvqjo4N0DPl+L?=
 =?us-ascii?Q?Yc0S2VUJMFJqczuO7hOgys8dMYQ8Gim67Az1Hhjuf5FmYDf2+zMfRQ5zhpCB?=
 =?us-ascii?Q?MBk3wVHyw4jTzcq75mLaTrOOI5yymQBqLwQ4beJIJvbtoASaaRxMb9Clchrt?=
 =?us-ascii?Q?FJoJsVIqElN7FaiGu92+6DCKObDlQFJJ3vByPwEM0rJ9c4kLq9WcAX67XnVY?=
 =?us-ascii?Q?Abk2SE0goenHIT8v+RAu0aqDBJUCYif9pr6VMw2/hdgt6kkMPdhUI3TtXB5X?=
 =?us-ascii?Q?XLrfcSMQssbC8JQi97TaWMxzthVy+5704lGwWaBlVJFyqn4EUXBEvG+RRebf?=
 =?us-ascii?Q?RKd39cei1RxyrCmua22zUw4piYHKX+owZeT/Ns5VIGtfvWUAe0F+qSb17XeJ?=
 =?us-ascii?Q?0QvIZp8gj6Lb0UKNWzD7sC1gR+91QiVz+ohOooXwUJWEW6SDAJnp6FlMZ7bL?=
 =?us-ascii?Q?RT1sa9tQSo43v0xz0basrJjyCvsisOCt3Oae5VTYSzt9YqL5kqDTM4ORM3XF?=
 =?us-ascii?Q?oow1w2jufKSqE9NvjuFtWbO4RBddOrvqZN3AcmDHBUkhm88agWxW6t+SOOVE?=
 =?us-ascii?Q?ySTWBlEWoi/eoLAfPcetkyWAC2cW4VKDRxUbHbUlwmh8sZSDU5jKRh1GAZWL?=
 =?us-ascii?Q?8ab6F3U9GzpXCQUtUtSQKBoWvloxKumDZVctO1HMJOvAOYwhga3vpEze4+vD?=
 =?us-ascii?Q?tN36nxUEj8P+SI6xorj1D8R19h6wfDD1qAxSfoviyZ5cR3BCcAhiN3xvs6RF?=
 =?us-ascii?Q?13I1CXFtDNpfFOYl3oGtqQR7MA+/W6YkEw9Eh5wnok2DbnmXAvt9iPvDRAf3?=
 =?us-ascii?Q?NhNRkXEQNaadF40zV8D/q90/9mhJFynDtzyJR4JRu3hZjrVKZqrYo50c0AlM?=
 =?us-ascii?Q?1sr6XS0chRiCSTI2nIqXkZhoddT82/owZko4LyRxmneCKtR9eVXqEGEPd3fJ?=
 =?us-ascii?Q?eVsP6lsPIgnOrAaWRAcBbucOdtAc5X/N+bvE3Qu6l4HCwcVJTXp6OvregJsF?=
 =?us-ascii?Q?eglU44jGq2R4ABD4IIPsEdr4MzfLnPVgRivrE/xSrj6jLrPEHX3GDPKKWHbF?=
 =?us-ascii?Q?gSEYhKyszbrWht1+A4AueGhfF3USAtIYVNFrMFwLkgU+eVelbg/HtZHPUNPq?=
 =?us-ascii?Q?bj2CUGtdTgkPRE+tZL8ocJu1naKH?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(82310400017)(376005)(36860700004)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2024 00:37:08.3941
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a03fb9-84f3-4f99-a6cb-08dc7477270f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6931

On Wed, May 08, 2024 at 03:57:14PM -0300, Jason Gunthorpe wrote:
> We no longer need a master->sva_enable to control what attaches are
> allowed. Instead we can tell if the attach is legal based on the current
> configuration of the master.
> 
> Keep track of the number of valid CD entries for SSID's in the cd_table
> and if the cd_table has been installed in the STE directly so we know what
> the configuration is.
> 
> The attach logic is then made into:
>  - SVA bind, check if the CD is installed
>  - RID attach of S2, block if SSIDs are used
>  - RID attach of IDENTITY/BLOCKING, block if SSIDs are used
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

With that in_ste check removed,

Reviewed-y: Nicolin Chen <nicolinc@nvidia.com>

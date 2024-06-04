Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2040.outbound.protection.outlook.com [40.107.212.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1454D4206C;
	Tue,  4 Jun 2024 03:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717472848; cv=fail; b=ScHqO1d0fUZKtHZzUHcDvUOzQqtxGuQMI7brCnZ0bEk7D0yrxbGboq0JmO2nKZDmbvttCUUyIHlZ6daekHWhSuQ2XWCsFULOmvYRz8kvc+ghgbQCgCbboJlV7C7gFw9+QOvRi33aRitnfMNVm7dImTbJ9msTcwveQRtLNXjD5kU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717472848; c=relaxed/simple;
	bh=zE98dN0lKO9gSpNT5y4BiGbxfMqSCXx7a/gcI/LduyU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LP7tcBBZ8xFhTRF+XhTWWm+rGlQlbM4vIU08aFVmQldimPxWms4rSgBf5y+b+qmtyjwe6Wx6v1iw5E31KvHYgljZ0rjUWohWSS2B21/R7P3l1EeBd7f+NH+3yr0knf0rPHSL2C4NKb1c/mPF3nc9l6w6z0Bh1kjf9NknTODWkDU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GISdp/he; arc=fail smtp.client-ip=40.107.212.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GISdp/he"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYRS8tF692qRm2EzlwtnStdq75QPb7HgA53yzSbIcIVWFS4IA4p/vvnwpKil+oDv0mZJS3CGHVBASQeaucYehtIXf2UJSvdOaMQVwC0Z24JqIPb4Ja8jXf0+jlZRwSbX9x4/9GCdYr6jft/SWcY8Z0B4Lf8D5qESIcY5fxLcCcgIW/F0x3OyE2Ut2jWXSivLdQ7C6uFbVhOjFSMAE9w/aIiX9fy0WmwpIQsi0epFffVWdeERr2TVjQkV/MJ/HvK7j8IU7CQ5fBzYRtCTOG+MVY/TWI3vXSMLuWrRgoRwY3wHl6ARkHMrk6y9gpRdQtW1PVEsGjzVJpIgc6jZaibBHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5x7AEzbU+9xYZpWXavU6GdJQo0HcU7krNPn4Qy5nMgU=;
 b=m3kc6YZao4/E2XoEEZYtTnV/j/LtkZANBWrwxouFOdPAHuofrLDObG5ctM6neq3R7i6lh6JOV5A9xIO+9NYsy6ut/m0gg0AZiYGQHGdPxEhS/l0amNBY8ENxIujEzTnBKxhJpVV4waLcBGHp+ni6RuTYutp/r2wsSPq1/Z67PIuPVmqI88QOGuHVSpsVb5M60UHjzAtmXzaniJdBc2/cZiw3oYt+Od3VkuIVIwg7bWtrzExS0UxJiryG8zLnfpiFFFJZmZ+hZfox2kH60t/s0pXQdwOTI5s28S47MOix87JCM0gguzXEFp1uqWtlfmtwLGWyiImSxJbVThXvJD2N9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5x7AEzbU+9xYZpWXavU6GdJQo0HcU7krNPn4Qy5nMgU=;
 b=GISdp/heN9wDN38+i8k7MMXYoro8VRi+OY1s8FT10GfcJj3fTGdkidTZFuCTotAT+Xrbc6LLlPVBhOa4JeHiz+SP4zLggCaVjmIZpoi4+pAyR5GfGjRbWS8jes2VxWauCfJY9VFY445Okim/yv89QO4HTt9z3YRJyaYmbuhkgNR8K37kXqgFk2DApd05M2TG/tIH6oLcR7n3Z9b/Wjm1ohzPv8l2gaRf/cJPcNSSG3gvuYe05eSllnQY630rh8/DFEXQG6ndN6OFWH8jokJwJyeWBBzT9WwuFlkesN1dpcwLeDp6spiJhsgQz5UNF2wQEWJe0T3rGM3tUOuXWk4+Iw==
Received: from CH5P220CA0010.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1ef::14)
 by LV8PR12MB9208.namprd12.prod.outlook.com (2603:10b6:408:182::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Tue, 4 Jun
 2024 03:47:23 +0000
Received: from CH3PEPF0000000B.namprd04.prod.outlook.com
 (2603:10b6:610:1ef:cafe::91) by CH5P220CA0010.outlook.office365.com
 (2603:10b6:610:1ef::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31 via Frontend
 Transport; Tue, 4 Jun 2024 03:47:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF0000000B.mail.protection.outlook.com (10.167.244.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.15 via Frontend Transport; Tue, 4 Jun 2024 03:47:23 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 3 Jun 2024
 20:47:15 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 3 Jun 2024
 20:47:15 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 3 Jun 2024 20:47:14 -0700
Date: Mon, 3 Jun 2024 20:47:13 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v8 01/14] iommu/arm-smmu-v3: Convert to domain_alloc_sva()
Message-ID: <Zl6OQT+/ewmxQGb0@Asurada-Nvidia>
References: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
 <1-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000B:EE_|LV8PR12MB9208:EE_
X-MS-Office365-Filtering-Correlation-Id: 63f23126-f353-45e4-86e5-08dc84490b0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|376005|7416005|82310400017|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Iu338MmBNL+Cm8JYjQIM/MDlNXSstFWQPJlp8FyD0KkQAx3VTxYYbBOR5qRr?=
 =?us-ascii?Q?8+VNGqgeNYAmpr2fCHYP7JL2Jyge42PjOBrgm8AO/PuQmlF7Th89zFOz+4vJ?=
 =?us-ascii?Q?Q8qMFwMBgBwVrflgQd5EL741zOcYh8Ljn8FXaStO+eex3YyRIxQVlL9oxV/q?=
 =?us-ascii?Q?upGSSvbdUeKmFJCCOfx0g/FlqDOdPtRd91xErqbjzu20q1dfjkmjTw3hIwyh?=
 =?us-ascii?Q?kA2ttwMI8J6idiM50f4D7UuntbQUnJLCg0PbsKbNedZTSrmRZMEMuDuFZuvf?=
 =?us-ascii?Q?Wn7Qlf5PbYmO2ux9oAVsUFJfBJ1W5uHsOAYNa8PjHXMGg6wq0H40tKRDiY9Z?=
 =?us-ascii?Q?mWY3ukiIzR/v+4dG94HuT+KATrcKZXbzZ0icSDouQspWTHBUdHYDoO8/VbvW?=
 =?us-ascii?Q?1oYE2k+GhZJU+VPxmoHDYNVKSuVJgBV///MZasKu2RAG7dfVw8iolvrSGsmH?=
 =?us-ascii?Q?wp85on/UCSgUDivgS2Od9fygYBzcVRi05RRp9DZjS9Iggn00OOmm6HoO3Y2k?=
 =?us-ascii?Q?76wMyy0nCe5k49jVohzb2fpgVBdgQA+tFFjr2M+3waV8qwbPDNW3rDrAWDG0?=
 =?us-ascii?Q?+53vUqAxLNv3BWG3VaUQ+RVJYU8VkoApoVW9zifGNhVEwY60agMZtk7sduVA?=
 =?us-ascii?Q?OUX/4A55YYgq4gxYQfuMkhFd/BnwWbohM7tq0/zPneIJLe6kiDnaDa1cKAZN?=
 =?us-ascii?Q?1TcWoBPSkzfy0gTsy6Nx9LRbRAIwCpo2MojiPrClJjxcqhEu6IGr2H6O4ZXI?=
 =?us-ascii?Q?lJ8nEb6y4j9zwY27pZT+8N++kzWBDeDp/By6UfHmc86twISSggpVxgEPDtTl?=
 =?us-ascii?Q?XoDbMGtZNN4GX8R69utXlobpJV3XWRIHlIWV6ztkdDq8jNwu09t0sCku+npt?=
 =?us-ascii?Q?tnZSYfQH8Da9pbXlYh6rlNsnzCrcDN7L8g+YZYckemMCEgyTFxSL7D0Pgk2L?=
 =?us-ascii?Q?DOfLveCPXcHaTVP8NShC2uqJQvQyZkO1/DO7W/jd8eZ4D7r4x1LV9wfPUsn0?=
 =?us-ascii?Q?Yr2HOJspP3YINGhI0Unt2B+MY0qT+uNecTGKuv/ANLBMXXvfawUEIqUJpOtA?=
 =?us-ascii?Q?v99Re34h7p44UZ2rLmFWAk+M5v0i12SQRql/oBrwLshfcP4nIuDdMRJz5VuH?=
 =?us-ascii?Q?QmSiozXjPKWideOUXjunX/5k3eGNRBfrm6e4Bzhwi/rOV/bUgvtB4lTw/aNV?=
 =?us-ascii?Q?R37kKcHwOXnnHS94jUI49s83f1GtdJB+qSafOL+lp60VNrOGMAbEr+ZzcPVA?=
 =?us-ascii?Q?R8jwO1PET2cLocJRxkTszTMFl6DBVbnR5JwiWi/ja5nFRp5/gBcPfXhvH8mQ?=
 =?us-ascii?Q?GixnEBF5w1XyAFouHwJByYHAn/CaiPx1ZGKrAPzVvwMvqSgHyN7FtWEWivOe?=
 =?us-ascii?Q?MdslunUYYms56hj0AFPN/GUPnVrA?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(376005)(7416005)(82310400017)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 03:47:23.1120
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63f23126-f353-45e4-86e5-08dc84490b0d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9208

On Mon, Jun 03, 2024 at 09:15:46PM -0300, Jason Gunthorpe wrote:
> This allows the driver the receive the mm and always a device during
> allocation. Later patches need this to properly setup the notifier when
> the domain is first allocated.
> 
> Remove ops->domain_alloc() as SVA was the only remaining purpose.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Reviewed-by: Michael Shavit <mshavit@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

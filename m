Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2046.outbound.protection.outlook.com [40.107.102.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB342367AF;
	Tue, 10 Jun 2025 18:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749580366; cv=fail; b=qFOULlUmNK430PRiPU+YVGuXW4/WlKC87Wdacf7aLrMlzBjloUp5qSk+McIGqaG5Lo6w2r0r10YieoR5a28jXbPf7gEszJKIPUQzhhr3xha6t1D8gGmNfr7/QVP9Bmn9SDrLr0GVVyg/PPMnsO5em85ywtj7CEgEG89ysTnU30w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749580366; c=relaxed/simple;
	bh=ShUP28h8KS1cCepgIA+DffwIUzROCf+XfVakMMehnSM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SNBrgUAXpFxWYidiDIlKM7OyDSaVtRp9jbPjSwptoMh5mYA2kOiJRonj1Ggbl9REoXaoolyIezPQHzgP6tSlAH+o5JzjlQ/q08n+pTo2EIXnYsyr+pJZgvpLqApuTDwmc9HZiyu4OoyHHvlpQZBSuSHkaHGr/0YkPAXTC1hHUB4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DGH9/8DV; arc=fail smtp.client-ip=40.107.102.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DGH9/8DV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZspFmFldlHaV2dBXODbLjKiDE7zNBqF1MgU2BS+ZZn8KZ7zYONEhBVZ9Ldf7OLIP3gVwBLtJZhBGN18Fu9SdDMamL4NcoSPfDYzm3GxIy5TELhVQQ1O/Q17pjJ3fYJFpWA0c8RIp966CI3tZtJzAXwHDZVsyA++uLvRcbzRbWmyDHhGRvl9FXF4dibs/HxK0mYmsG9X6W3Juwft8YX0X/WIrhcK8azsXgVnjwCZTNrFWZGCiWHCB9oxDIiaZUFqqXzd7UVeKlDrD4CK0zUN68ETvwya3TrCLJRh1G3rbIQI/2dGiHhK2orjC/4weRJ/2YqvpIro8DfZDrzbrSwkY2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hj4eIt+VHqO2LftBpI1JFvYK+i8DFAwq/017OGu24Bs=;
 b=boV4lghEu3j3K8yqOrqNqltFIC/PtKYbc5bsuFlsnKgPIqZw2BXZsFqEFxydKVHmI5c5wr27phT54MSNDH1eBMBgEQ19zxuWcKznd+9G+0BbNWvlzmFMrgBgjvLcKZG0iCye1nT/31AmCfFfUWugm0is9dWCcQAGKhM/zd4Aisem14gEeamdLlu2gyzH2of99l6OP5FGRZU6qvI2I3OUByS0OPyo3pJIs3RB9hWhsUGTNIDFFhhjkFwXkBy6qBbFLey58Y1/5cc5Ddo+prJc02uZJ18Wv+9QnT+IwsXdnPwGJQ6ie8u6AggYR7L9aEyZzn0TI1pAXmmIIq1BOBiLwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hj4eIt+VHqO2LftBpI1JFvYK+i8DFAwq/017OGu24Bs=;
 b=DGH9/8DVlm9k5Qt7xSmBSh49ed+YbOU0sw0qxMc13+cvq8PplPz4PlGdNNgY0Z9qZg90vSQVPeq+fu426YwTp3rGDgiRgqI9s994SQzpg48NwgbACWuuNQDSQThihk9kFEYlzvx6Bfgy5bLLA2UWbi7T1zZtlWUDm04XzVZqFSxLGM2cJl27k7HSowzjJZ3+UDyyxnlmRlBl/2/Mowu1xipkV2IzNCNr9HUEh0tMONd02KKwHWOh0eJHNRmNQ5hM7D8ckyGXdYcu8ldo7oKrfe53886Bivyf9e+ZmvdPPRK1jwrO0GXJZ0fn8b+axhpDfOnOK7F/FsLBcnIrUTYFaA==
Received: from CH5P221CA0005.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1f2::29)
 by DS2PR12MB9592.namprd12.prod.outlook.com (2603:10b6:8:27c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 10 Jun
 2025 18:32:40 +0000
Received: from CH3PEPF0000000E.namprd04.prod.outlook.com
 (2603:10b6:610:1f2:cafe::50) by CH5P221CA0005.outlook.office365.com
 (2603:10b6:610:1f2::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Tue,
 10 Jun 2025 18:32:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF0000000E.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 18:32:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 10 Jun
 2025 11:32:22 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 10 Jun
 2025 11:32:22 -0700
Received: from nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Tue, 10 Jun 2025 11:32:19 -0700
Date: Tue, 10 Jun 2025 11:32:17 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<ddutile@redhat.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<baolu.lu@linux.intel.com>
Subject: Re: [PATCH v1 00/12] iommufd: Repare for IOMMUFD_OBJ_HW_QUEUE
Message-ID: <aEh6Ma6hLrs78VMA@nvidia.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1749488870.git.nicolinc@nvidia.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000E:EE_|DS2PR12MB9592:EE_
X-MS-Office365-Filtering-Correlation-Id: d465d5ae-fd34-4da5-f61d-08dda84d2e56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u1iM7jmzI8EA7TJ1R5S0eLezyRD9SrrRPWghAUBLtwoGqnQxZpCvsuD/iOBe?=
 =?us-ascii?Q?sMgSpVB8fxPd1+Dmluxm+0rmngLA6snR2ou1XQOPxGKW5UsQDBMkEBdjwXUK?=
 =?us-ascii?Q?y3XMe+ugsT/xOqMjcnMrOH3a2cS7OskgIyd1GJZ4TyWk7ZriyGfjGZ/DQWRQ?=
 =?us-ascii?Q?tGlAThfPpgkeChBgkxNhK3yKrDokbX6FYsg9rae40M9A3BerV1Djb4xCCQi6?=
 =?us-ascii?Q?6z7AAvt2ejKYKghhzt+t3ZlSaauPb7fLYiunUl0bOwt2qngzBhy9zY/EUPMB?=
 =?us-ascii?Q?HUGTt6kciWtu6DNTvhiqGQYZi+NX3tvi+2DcnQO+ATepy/ivuX1wd244pw18?=
 =?us-ascii?Q?8sKvOwRf3/VOQJSZzHB7uayAvUAPOw8m9SpggSMznabaJ+V0oTkN2Hu+vUKF?=
 =?us-ascii?Q?+8urdkVfTmvuJG198Q7U0G2jokqFfQR3+VjyutAZnbAOi9q35qNY90U0V0Ix?=
 =?us-ascii?Q?KdKlSzYlPvR8smFIxbgVIbbhnFYza5cajFNtgwxitnUQNnoOGIsWP79wxNpd?=
 =?us-ascii?Q?l8QOoEPfJ8qZV92rENHemh73BTCS4WBA/1DM83GO3DvzBQGwNvR+ak21R5ic?=
 =?us-ascii?Q?F+xBYeUZnwzPgxTN6LoiFojjnSx7u8olB43intEWMxVIU4XHtZ8B38GTHEw9?=
 =?us-ascii?Q?dlNS8RD4yVOc7MStx8Gn9ld15PHSM2kvirevah8a49iwvRLEQj16Wlbx4oDg?=
 =?us-ascii?Q?Hn52pKiXnbQGTjwmZm5DeO1v0WuL1vkFC7aRBUekhddMKYFWdf/rBkYpGcpi?=
 =?us-ascii?Q?LYVVhbFHk6/gPTBs8W7IGaZKSXiHA8g/reCWRiO+L8TYrYTKXFMJd/ySLT+0?=
 =?us-ascii?Q?VlnVeoY+cv2wIWJuigKgCl8/48fbf9tRcLhOa3yq3Bt9mIUvjpX8nGgw8y56?=
 =?us-ascii?Q?K/1cUihUGaqVqHzAmXeG6T3VOeSL2fjE8c1ncuOISCTPtDK1Tf/P7sx7VKgR?=
 =?us-ascii?Q?BBv1MZ03hoB5ocbh2s91VcGmQQZ4fe93Hvd8tSF810SXVUDe33LgT9NDhuaY?=
 =?us-ascii?Q?vEDmy1V37lPoj6sV8yWipq8A525PXOxtRJCauugyID47ADWtlzAqNIhNYUfS?=
 =?us-ascii?Q?GRULlY2zwAcYaO7IhUbjYL1oIR44tA+vt5pN3guI6oCeVy/TWG6CIG8kn1tz?=
 =?us-ascii?Q?cR3rTrM/8jJ5fzvWMhY+3a4TVgJ7jT5FeEDg7wxZzO6laE9e37nqTlBs+cGV?=
 =?us-ascii?Q?jVagGNIdalOqjDQhy9vq1daTgGtvYIClIwKwVJrhkk3TQ1UFtPAnYJOBcZPb?=
 =?us-ascii?Q?KNsgtri5YhVCxjZCM6Rn12StaaZJpbCjhkTNz6GesDXwUJOnAX4p1Gf+gV2o?=
 =?us-ascii?Q?gh4dwlIzYLxBQDAwpiXJwBjt9bDEx4LB6jTyTCpPwrFysXJ8QW3syfIkW4UX?=
 =?us-ascii?Q?bB7C29uD5c45UJa6Pbzi2nUDEAs7+dydR6P9eyns6j6itMtFNdB0hvECwvG4?=
 =?us-ascii?Q?SdWL0VBOJ+NGT2XeADWJZswNvTbxsA30uzgwy0C0tMBjetcnZTI81gptJ4Ao?=
 =?us-ascii?Q?Cxowq9qaeFvGjYAXHVXR4uW1UVduDI555nCV?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 18:32:39.8518
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d465d5ae-fd34-4da5-f61d-08dda84d2e56
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9592

On Mon, Jun 09, 2025 at 10:13:23AM -0700, Nicolin Chen wrote:
> The new HW Queue object will require more interactions with IOMMU drivers,
> with a few more for-driver APIs. This will complicate the driver-allocated
> structure design like the viommu_alloc op: since the core structure is not
> initialized during the driver allocation stage, a new for-driver API can't
> reference any member in the core vIOMMU structure.
> 
> Make a preparatory series doing:

So, Don pointed out that "Repare" is a typo here. All this series
doing is to "Prepare", as IOMMUFD_OBJ_HW_QUEUE hasn't been merged
yet.

Also the main goal of this series is to replace viommu_alloc with
get_viommu_size + viommu_init. The patch that introduces the two
new ops has the full details (though I should have some narrative
clearly show the idea in the cover letter too):

--------------------------------------------------------------------------
So far, a vIOMMU object has been allocated by IOMMU driver and initialized
with the driver-level structure, before it returns to the iommufd core for
core-level structure initialization. It has been requiring iommufd core to
expose some core structure/helpers in its driver.c file, which result in a
size increase of this driver module.

Meanwhile, IOMMU drivers are now requiring more vIOMMU-base structures for
some advanced feature, such as the existing vDEVICE and a future HW_QUEUE.
Initializing a core-structure later than driver-structure gives for-driver
helpers some trouble, when they are used by IOMMU driver assuming that the
new structure (including core) are fully initialized, for example:
    // my_viommu is successfully allocated
    my_viommu = iommufd_viommu_alloc(...);
    // This may crash if it reads viommu->ictx
    new = iommufd_new_viommu_helper(my_viommu->core ...);

To ease such a condition, allow the IOMMU driver to report the size of its
vIOMMU structure, let the core allocate a vIOMMU object and initialize the
core-level structure first, and then hand it over the driver to initialize
its driver-level structure.

Thus, this requires two new iommu ops, get_viommu_size and viommu_init, so
iommufd core can communicate with drivers to replace the viommu_alloc op.

This also adds a VIOMMU_STRUCT_SIZE macro, for drivers to use, which would
statically sanitize the driver structure.
--------------------------------------------------------------------------

Thanks.

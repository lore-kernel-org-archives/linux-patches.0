Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4A314F98;
	Sun, 12 May 2024 09:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715504646; cv=fail; b=hf+DYfAH8Hy3pmg/u8g8n/nWc9q1KFoGt8zqQimrIDiB7OkH8+27jyuspR7QBmA/U+di+R5janF6im4z7Udn6l2p7IOPD+YqPb1ROJ/HnNjUkbz33MN7VHSyNNJkECvpTnKEYkm1cFZdhbm1+tZWFBxByveg2jMyeBnlxXGf1zs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715504646; c=relaxed/simple;
	bh=CCJ2gsJNXwXOpOQkuHLjss8ecvznjzqL5se49Z7kdLY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hJlGfvhG/qrNXTO7DDkRXbsGpdnwMJmVVSoTwIeUHWZKBKBaDqe9GoQ0OqwKRKNSOeKsgxHj0vxyj8bNJWoxNcdA49WIPS76bmctPooDOq1lKYLcQe0+PyouHvpZBnaYK6EJMq/rdrildOMAbKwl+Cm1g831R/f1F01EplPpljs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VaL53kiQ; arc=fail smtp.client-ip=40.107.237.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VaL53kiQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdiDRBFZuxSLMGXrQPa0R3frnoCjO3LDATLuWOx4BVvOLXTrk4Qw9kmjdhUGqsYAps3tLN2bhHSWZPFE0+lcVphiNpYkILYknP3gF17Oa3+HSfVwx5SD8xlL2syhPk25SzPnh3SwVnPp9+lg4Q0xb+/PeqOMVh6ocb6Bsu3/wTxzK0aaDCVBe1uPb++yEhN/+YANVwh0EV2fwOdcNCd9Ylsf47rs2If73wYxjzbjkPUGTQdqOdYlR7c9opDDUl1V4jKB5RmqxBRs4q8hpiKQTIpHT7RgppcNU7jYZN0wjgprwZM6QSb/c5Ff2L2TNuoSVzUcQaZOLeeLv+kTocuYHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oje535cg2NHtderqx4rI2PBB5+fYt5LAbA0WNNhnOJQ=;
 b=Lh8T3mnNBvO/fEc0N9LSic+LiDMeSVM+epwY0Z3w2p0L19Vn+7Q5xsjnDeF4+2blI+3e/JPa0jIlWUE+ticISXe7EdkqV89gZoHqWCpV28LN3ltHL+B6ChrJoKj7ESJtwxG54JuMFYmkKNpuKfIg7ktRdmsYR7aroCQeYVekTkhQpLgggreKqIsv3lXwVqIZt9cxvqYO8JoFUPrL71eb5G9wdwZDokkf7vjYI5gJsw0kNyyALNtbLbUvx4NJx3se7RNfgLbtXh6OGNNrZejbcsFhZ1/+RKxLf7HE2ZFlefIHxlMq420kAOZsU4gloheSGMlIjWn4HNfN3027UMHfQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oje535cg2NHtderqx4rI2PBB5+fYt5LAbA0WNNhnOJQ=;
 b=VaL53kiQYWoNaKIQXz+S9QZI0/iHulq2XBQCKEifeV1AXHq6TNFRMjVl5US3Y5K/rtZ5j7883n5x9d8IdXPtTbW73eAEPiLi8igZiobixkYBW96LSon/23V/hGf6LFSOIxjS5CbUs1gXaUGLk+Zbb+cL0byTW/SHHnd4fI3+amZEGnhFD8rDl9tWp0PK441m8waWiY7VweEQSnhV3ZXax4Hdg33YtQcYo3ApeKXB3YtKVzR3zCfZRSX5wB/GrboAm6cL3sxYC2CvZlqQQGe//jmYZAfOLkDjaqzeaUysyF2gyIvNM2mskIAuZTS9yzGGDAGApTUFwpF53hFumED0Qw==
Received: from SN6PR05CA0011.namprd05.prod.outlook.com (2603:10b6:805:de::24)
 by PH8PR12MB6889.namprd12.prod.outlook.com (2603:10b6:510:1c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.49; Sun, 12 May
 2024 09:04:00 +0000
Received: from SA2PEPF000015C7.namprd03.prod.outlook.com
 (2603:10b6:805:de:cafe::40) by SN6PR05CA0011.outlook.office365.com
 (2603:10b6:805:de::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.21 via Frontend
 Transport; Sun, 12 May 2024 09:04:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SA2PEPF000015C7.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Sun, 12 May 2024 09:04:00 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 12 May
 2024 02:03:52 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 12 May 2024 02:03:51 -0700
Received: from nvidia.com (10.127.8.14) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Sun, 12 May 2024 02:03:49 -0700
Date: Sun, 12 May 2024 02:03:46 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 05/14] iommu/arm-smmu-v3: Add ssid to struct
 arm_smmu_master_domain
Message-ID: <ZkCF8qPo0ky4HCD7@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <5-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015C7:EE_|PH8PR12MB6889:EE_
X-MS-Office365-Filtering-Correlation-Id: 38fb845c-a86f-48fd-1f7f-08dc726276d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|1800799015|376005|7416005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Y366reuCgVKdXhE2mLf5iaM7kxaa5cSxXUl8l2tdfZUB+2J65Fn+bqj9BRcn?=
 =?us-ascii?Q?437fpQVPpVtcA2fYzDJrZfbhWm7fl+Kqe/nwTVJaodxXTxF3SeZo6lyB8RQu?=
 =?us-ascii?Q?xLegCkoK0vAQB5fRRxKuDxa9/ULA1S4qUUVQeJnv/7vTyAYlO21OddyK7ZIj?=
 =?us-ascii?Q?HIQcOoSKQzqnbcTNb2LUx4suVCXLgiYHpdLNaHLt7JcKUiQXFNYNFjjBvUKj?=
 =?us-ascii?Q?IkxVK1xtMXhcC4vf+7xPlL8suwjouHCV2znheX5xoqx9SjYEKbFRjqMhkvp9?=
 =?us-ascii?Q?9NQMUx8MJOuloSL4YyTom8SQOxS30r4NV+bBhK7DfJBvaCEOzn2TSLoHJgk6?=
 =?us-ascii?Q?0B6UFs82OBsblHEfWLY1x57ECckuAy7L2w0uWfyNHBgwgb/a317lnTiUF19l?=
 =?us-ascii?Q?MeSpfTEkzdr8OHI0sio8wMNvCICiUaqle7lgqdATcMepjFgRZSHjNrB0ndVc?=
 =?us-ascii?Q?Bkq6N6A8ry1u+B0EMKb7IcOXjJfJiNpUzAvrFWfoAzXs+eytJaKHETUDcIp4?=
 =?us-ascii?Q?QNCEPO3YMn6KVwN6fggLFRlfK3GxQHRVXkGnrCkhlRotOjQOrUSad5n4V4Ve?=
 =?us-ascii?Q?n4dgSNa0/R+9bW1QCxNrvtRcBMd9uvxH+R1Ck7F9OUpWId49O8Wo9Oz/o0i7?=
 =?us-ascii?Q?kK1ilizgRc2KSOI09rBCtJ8oZ4UVkSzVr7FEe3MSAS9J2nZ+HXoXoDbHpfJx?=
 =?us-ascii?Q?ExI8L/JUM9idymI648uLq/VkstZYIdd9hFKfXfZ/fc4evTa8YfC8z13/k1mM?=
 =?us-ascii?Q?pKqvAIPyytPuEvzS2jFDcSAbd7YuAa5KpXL2Ao9NChRjsqMNMep78vPDgkYQ?=
 =?us-ascii?Q?1z0yXvpCDRGbF5G+fUBQKTuwljCIxfPmNlmav3HPV2B+AqdolpeIzpEjb/Oo?=
 =?us-ascii?Q?0P6HxSTwo6LEPzLlExkI+6OIWwk2zLcLt3kRIKw67ubZTt/a5o/EGvz4dJ9M?=
 =?us-ascii?Q?5sAJVxAsgvazuc6q4t4sqJ+z3j6Ft1nITjWXV3YnrLzNjifQLVA5zBkayDXD?=
 =?us-ascii?Q?J0Ylq+zpkeo8AkwDuIFUwz1AuzxnXq5BHUn28LsG4mtuzVRSocRIC2Mhvqkx?=
 =?us-ascii?Q?2WfbvfXKFrKzklmc2BjfvPbxWRXer2piE46/vG5lnpJTZfp2XXYUcqFaHGes?=
 =?us-ascii?Q?H5iWqq9bIrisj4vBEmg044gbQSqxk8/qH6cOD2ZOP4iAIPeeL6d630kJoaao?=
 =?us-ascii?Q?2v5cScZUE0KUYpPIw9XJKDPhQ9iIQQsvL6Sbmt9gbNZ6wVNiGvg9epfiR33Q?=
 =?us-ascii?Q?7hleoi0XMpa8RCXRW6qBFHhev79KwcvTbV0w0RNru9UBoFv0azMn4krYvAb5?=
 =?us-ascii?Q?BrOVsHBGnTJy9xD4vrwmqc9E455UbJ+KhJ3NaXWXF4fZcV9ufYN4j49jo/3Z?=
 =?us-ascii?Q?w22JW7wAWUZEbW6X4JMkAKCwsU3L?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(82310400017)(1800799015)(376005)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2024 09:04:00.4179
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38fb845c-a86f-48fd-1f7f-08dc726276d4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015C7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6889

On Wed, May 08, 2024 at 03:57:13PM -0300, Jason Gunthorpe wrote:
> Prepare to allow a S1 domain to be attached to a PASID as well. Keep track
> of the SSID the domain is using on each master in the
> arm_smmu_master_domain.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Reviewed-by: Michael Shavit <mshavit@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

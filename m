Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA79142900;
	Tue,  4 Jun 2024 08:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717490712; cv=fail; b=JL4EV/LePVxhYLZtSsHLdB2sEZGRjgJYtLzoPSdUDsT04HQh8JzgGBYFiRgc3WcwpfTA9+tHEBEVAUkIq/dvnM7sbEJGc5cJ878AkkCZn9UUvMoiZ0FlB13VzbtZEaWfJECB5tMWDEPctunZpeuDFMzThOUmlw+yVK7vB4aAHbI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717490712; c=relaxed/simple;
	bh=+QJXK8rOiO9LLQy0gEQnFnt2ugYx8jyuNMpYOU7uHP4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KL9OlDZBoXs+/NzQsmlfbr64lQGuu8W4XOr2QdX/N0tzU+/8y+6AsbqyoV+erH93wsN7ToUXv6eQ7nTlpP7q1KvL4T/0UgfAgwc5T9ChV6EEqfnagaE2UYxe7NY3/xlxpzSLRKHRwyMNlN+H/Cz498EPe/Ojmt9R6z1Qe/gOQKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rKf0bE9P; arc=fail smtp.client-ip=40.107.243.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rKf0bE9P"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8hejXWxNvbBz1hZ/DvKdKr3fp9aufv3wc8W4Yt1EhXfKSgQ0/kM0DzEuiCSFbx0BPv3vSGnEuXNARSBSnbP3oik2d0m5HFhpkdhETQ751haYpO5lUwE3gMHks96iUavtyeVj1qYgsfa6yTqFIAPEeljaZ0yEYjuowObDFUGlG6PVtdwrR1GsQ6ILra4QxL5lKZKnDvA9flyt9K26JiLhqcm0cMXqQtlKNkdnt7OF3NKlY9WzipbsNYuGjr6tZqBQ2p949oQs+NtDbUyYLNY2qBZPf44rteasbZQ1HTC8mvMj0B+7zwYDGsCuibSuJeE9Gztq8pfqyErq6u6jOG3ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vE0v0uJd3Z+OXd9Y25JBPOhQYh5RPm9E6gLm/efU8tU=;
 b=Y/cUObIMAXHxOFtbYuCD3+Ob/azI2YltqyRAM5nkycxjHC296DUevBLaPRHy39kuzwU9jjFUXHfs6FrROK9OpXEPCgUA1XPQz8zWpblPOs2fgrkAreHHGOFaF70qsnDzvmgFqjTL/m7XJmfd2b2aOuGHMKcQfmXzE4tUgQApS2w/qdVzm/L61sCbn2ER+B/ksOs/DQXOOKOmFyc70zk5/OIYotJboq2V/REvq1daKvkTj8iBbnONBIuLgiVRPY4F8Q8UhB7xzjQ5Kk8Sjl5QWwjT14AR0S2gGSi4+7Hl4vCLr0kP77HV14v/+U5gPrZJLCKn3APjvRh7booiuj2Z0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vE0v0uJd3Z+OXd9Y25JBPOhQYh5RPm9E6gLm/efU8tU=;
 b=rKf0bE9PTnASfUQIinyA5pfUeaH7RgaSHVp6cnefDGf9YjiEPRxeCKo6CjszMSdGx2V1EsSOF4Qbtwv70ilblol2UbZlWZzYyMGBy5ucsLsonUJjYRV7nmBmxnlpq8cppIgg+/48a9oOFfY84/Pwpeb2GFnRZ7/FJ3u6h81hFKLXkeLYwkKrfd4VzpTF2qFG8vkeAuJOywp9TEG6MB136AGLm+ymNixEv838igkUfu+wI/YKAO+Q530Xwo9p0sue95rCWGKFtyEB9RejLvc7IQAvZqYWEApkTNNnx0hLrMTknKjEd9rT4gGdXQ4dzeiHibZFX0jLEYaJaz4coo+gAQ==
Received: from DS7PR03CA0031.namprd03.prod.outlook.com (2603:10b6:5:3b5::6) by
 BL1PR12MB5970.namprd12.prod.outlook.com (2603:10b6:208:399::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Tue, 4 Jun
 2024 08:45:07 +0000
Received: from DS2PEPF00003439.namprd02.prod.outlook.com
 (2603:10b6:5:3b5:cafe::b3) by DS7PR03CA0031.outlook.office365.com
 (2603:10b6:5:3b5::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31 via Frontend
 Transport; Tue, 4 Jun 2024 08:45:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS2PEPF00003439.mail.protection.outlook.com (10.167.18.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.15 via Frontend Transport; Tue, 4 Jun 2024 08:45:06 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 4 Jun 2024
 01:45:03 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 4 Jun 2024 01:45:02 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 4 Jun 2024 01:45:02 -0700
Date: Tue, 4 Jun 2024 01:45:01 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v8 00/14] Update SMMUv3 to the modern iommu API (part
 2b/3)
Message-ID: <Zl7UDSdN5VXo/hRH@Asurada-Nvidia>
References: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003439:EE_|BL1PR12MB5970:EE_
X-MS-Office365-Filtering-Correlation-Id: 88e6a9f3-22e2-4ed6-5684-08dc8472a288
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|36860700004|1800799015|7416005|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7Br9MS6DNJ9X76ov/TeVQIoL95adXZIUYrVlWYjTsFQM1pxidxQqi+symdvB?=
 =?us-ascii?Q?hBm+rAPAhRWt0CF7KYm18/asRkwNFmW9XLwyCTktLL4XIqFjG2LJs1rWY5He?=
 =?us-ascii?Q?goItVX0j9mTLQbxb28P+2lSHCSt4+DFO5pE3rGYFgt3b7X8ZGQK3lx39gM/Q?=
 =?us-ascii?Q?As46+yghDIk3c5uHNNIYaOW8uIMAvnELnvMdpDqHVvmvvYjQKDp2HiEgpTuQ?=
 =?us-ascii?Q?sn0aayxPQ6t0bpwOezHhBQ8iZ9pReKwcwdV0v8PwhqO3i2RxLAPLrAfT4tz6?=
 =?us-ascii?Q?mwOWheE1jQ2JhpHZzQlHk3iwWSgd9OOL3nL6AUCd6Qp0g+cF/CAI2+UspBbP?=
 =?us-ascii?Q?8Lxaet59ynUlINpNZOjOUKr/XghZEyVnDgKvx7PQ7c8qZYNir1MfpXjRK3DU?=
 =?us-ascii?Q?A43E6zhSu8c/vpc17S1fFLvI/icui7RFJjxTEf1Xn3afdhEntyb4he3eQlZD?=
 =?us-ascii?Q?vCSUx/b1o0k+p8mO0vajnnz2pqJllaQFvUGH+5Om/K+hxbTaOje5LPA/Hu9B?=
 =?us-ascii?Q?QK8YRGi0tiq3oqWS8RNlWYgZXltMxVMchppMwm143cd3YgAknFlSomehEC4M?=
 =?us-ascii?Q?fcQoTbJ60bek7WKT8lc1MQ9IfqlacSrtj4jVNFgg1W91jS40C7A6EBFgd8aE?=
 =?us-ascii?Q?weXA09F+WdR8iuFurJ7XuXBKtmatGJI0nheQYsEXVvMJ8XWLgqDSBjxeEKwu?=
 =?us-ascii?Q?ATSsNUhcZprKqZd8ZuTue6k6Pg5WIUOLwAQ1akFSstrLKeELN8Dtnzw4/KrI?=
 =?us-ascii?Q?86igWf6DalZlmodF6v1hyFpwDCEdphr63abULdMXTc7ViGAN8pE/3bDUF0E0?=
 =?us-ascii?Q?5Qe5Cy4ox5Ai9ur3W5odJOphvAkEUqczRsQGNdFefiSvC71pRMkoqqQOISOo?=
 =?us-ascii?Q?2gGYJuvEJhyx5DvJUTOgkxXt1xE0NsuLjc5/kfceaz4xeAIWVT1nB9lW87oG?=
 =?us-ascii?Q?N2+jyuNC2iujzJZUwOgXHnK1ZAdyibXjXkXQbFkWO+HpmGzIqezhIcPEDwW1?=
 =?us-ascii?Q?pDpFNyTikU49AByCyOlwEqMLnQVlFXUewjudjwYCCZ0X3mSykudT2vWyoyWl?=
 =?us-ascii?Q?1gvtA0jSxZaFxQ8xE5IjUxndmIxrAQRqReBZvmnaMVED/IMFiXCYZhnxcb6I?=
 =?us-ascii?Q?sc1B9dVLCMeD2LtFqXtODzPQlt+yIcTtGhpjsvh1va8W7HpjZPL0qfB9/AgU?=
 =?us-ascii?Q?fupAUDBLxmrZGuuwjFGuVDlirm2DR1TpJZ8o6S2dikDTF4693RrV64/X9qKq?=
 =?us-ascii?Q?KFRnyy4FWk000Y8Ja0RO+/q1BUHckoEYIl4BYoxCeVW9LgJ9pjxdl6kAYggc?=
 =?us-ascii?Q?BrGKW4In+lOZ6iUbNHDVQNm6/Y2TFQUU3NNSOaNEwf82cx4vOUWUgJb430hl?=
 =?us-ascii?Q?UEPpSCNGf/ueVQEfTQMPRvUdAoeZ?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(36860700004)(1800799015)(7416005)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 08:45:06.6187
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88e6a9f3-22e2-4ed6-5684-08dc8472a288
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003439.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5970

On Mon, Jun 03, 2024 at 09:15:45PM -0300, Jason Gunthorpe wrote:

> This is on github:
> https://github.com/jgunthorpe/linux/commits/smmuv3_newapi
> 
> v8:
>  - Rebase on v6.10-rc2

It seems that the branch above isn't updated yet from 6.9-rc7 :)

FWIW, it's missing a patch from Robin fixing a regression:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v6.10-rc2&id=8b80549f1bc6

>  - Make arm_smmu_sva_domain_alloc NULL when SVA is disabled so the core
>    code sees a NULL function pointer
>  - Update comments around arm_smmu_attach_prepare()
>  - Rename struct attach_state -> arm_smmu_attach_state and document
>    better, include more common function paramters in state
>  - Consistently use ats_enabled everywhere, replacing disable_ats in state
>  - Move the note about ATS bypass/abort to arm_smmu_attach_prepare()
>  - Remove temporary cd_table.in_ste check in arm_smmu_sva_set_dev_pasid()
>  - Improve comments and clarity of logic in arm_smmu_attach_commit()
>  - Shorten arm_smmu_mmu_notifier_free()
>  - Fix domain -> sid_domain typo in arm_smmu_remove_dev_pasid()
 
> Cc: Nicolin Chen <nicolinc@nvidia.com>

With that, I retested with SVA sanity running on S1DSS.SSID0 and
S1DSS.BYPASS modes. Both work well. The kunit test passes also.

So, my previous Tested-by still stands.

Thanks
Nicolin

> Cc: Michael Shavit <mshavit@google.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Moritz Fischer <mdf@kernel.org>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>


Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644F715B0E2;
	Tue, 11 Jun 2024 02:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718073597; cv=fail; b=bpvMKjE0dTRqLNJX7+Jt06ZcLS2Z6yCbgYlb7eab6/XAFT7LFwXpD+9qdLfpV5jr3iRGcvtKWlZKkUYDcLkxsbTzkUJXBE5PvMpfsHeNSwRna9suITNWDnS56ZI5yFhe+gwBPAcArnUc8friQKNOqy633JHYo/tq5w45tnFvwn0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718073597; c=relaxed/simple;
	bh=vXvF/St3qGVpx11krI4lDEB9eatmEDlrCRYuHc7gEAE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u1TGpRv7mVx5xoeclyqMwK1E/ekVkcwvAlOwVt+RU3v+aOfaLNplkZMVd+uHPYV3vmNHQ8oCXOLgpgn1CIxvxOJQ1mwlfAwhrwp0DfY6fYlT+P8m0OKRdUjnf2GY4GCK/OF2ch2vc6f7uhqJqrX8EThCuh2yGaIpDnoZkdXPQ1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=My9owMLX; arc=fail smtp.client-ip=40.107.92.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="My9owMLX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lno1yjsBmv1ysj1+eaD4JzHhsgRAPGcNlL89beaIscdo6+LnjmZFw0aDbSCKbJn0sZndLjVpXZLdsEvCk42OshPfukhNsIvSqipJbFgOaqFi1Z1Rq+Qx4J9Xa7kXqW/R9t1QtwDoq5+0bwAGBgGFNHqTWSOow4JZAA4LVVEqD8dObDo2WDoLFqG6yZkfNW7j9K0/MwYLMbI45y8/3oezx8BaOR+HFWCuaxWtAekj0nSPFB2oNDAoLSkTN+vmcRRLmOtdbuB3CWg4Wxbki5pD72mmmuoHTWhotPoPR9cR/uDpOqiuwAeCeNwEEhFmF8u/9QI0+ztUjqUONUjAnV+XeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5dF/iQ6olv+k6Ttn9P7wSlmFbyKEBKe7f0haMToir1w=;
 b=X4BccJCjlGKGT633tsAGK6f2Xe0C+rFASn1kcT5f+MyC5XBIGWJ54JSKClvVp+78ZnbtUVw7tHBFiDbsjqfNIfkTqMLxAxMLfOoyxka7Zncypi4buD3Ts3gOZhwmyjMhKO5oXgaLCHhSp0NbyOJbRv0OtqhrGHaLpbDuLTf2CMRWxGPYEDiwf8MnpACQhnq3/0SGdYXpPYR/yxw9+6tvsOQHZNLdYScyEyiDRsBlQs8QaXHdHcM2owy5zWDPJ/0GUbnB69m9ixZ0cM8abUfY4QNgRS/naA3QJMlm/G7d4QPegeX2suyoM63dSskWID+vUCTGQnqgB0sHtA0FlTos+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5dF/iQ6olv+k6Ttn9P7wSlmFbyKEBKe7f0haMToir1w=;
 b=My9owMLX/Ir8QIYbu8rfmVoGkOIcWNRcBfFvy9KEZTzZOuVZQ5+ka/gVXrQ35XT69QyQqSH2WHVzTpyZrUEJF4RfqSYiLh0RojsUNDBtpv3SR+td/KFGGzfomfI78zausZpp69gPpqRaRa2aPVaOJZtQKmJxVap4pEStbJRyTHOfPnXYKZATI57gsQA3zOCqBSjhGsoyn0AsHD79xa4+G4euYY5cvJVX3dInmwPbgTkNcixOiWhwYXv1NXq/A2/OH461Xy2ynvldyCIdp+ezEzTmm/RJTnDEPYPtjjN9Amwntt9Tdx/pY4lIEDcmvyD0si+IWVRonof+L6qRzDNASg==
Received: from BLAPR03CA0058.namprd03.prod.outlook.com (2603:10b6:208:32d::33)
 by BL3PR12MB6426.namprd12.prod.outlook.com (2603:10b6:208:3b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 02:39:51 +0000
Received: from BL6PEPF00022574.namprd02.prod.outlook.com
 (2603:10b6:208:32d:cafe::86) by BLAPR03CA0058.outlook.office365.com
 (2603:10b6:208:32d::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.25 via Frontend
 Transport; Tue, 11 Jun 2024 02:39:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF00022574.mail.protection.outlook.com (10.167.249.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Tue, 11 Jun 2024 02:39:51 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 19:39:39 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 10 Jun
 2024 19:39:39 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 10 Jun 2024 19:39:38 -0700
Date: Mon, 10 Jun 2024 19:39:37 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v2 07/10] iommu/arm-smmu-v3: Do not use devm for the cd
 table allocations
Message-ID: <Zme46dvS9fl2Rdy0@Asurada-Nvidia>
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <7-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022574:EE_|BL3PR12MB6426:EE_
X-MS-Office365-Filtering-Correlation-Id: 54cbfa41-3337-4667-684f-08dc89bfc4ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|36860700004|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fpkrrS0akme0KZPxXmDZS/f697bTvp9ee9CcsuW7/V/5JnEm5nLAm14xShSx?=
 =?us-ascii?Q?57veCClM1165EfHlN4rd/gQPlk3Ln+V0G5rqyY6erI0TPObv5cYR7leDGjtH?=
 =?us-ascii?Q?oWUBc3ErvK4zKkr4/+7kT5ERIyURdH9RGKseF15cLtAdgFS50/SN+XK5tesk?=
 =?us-ascii?Q?tTbic9gt1NI63DG/iwrNS7cDHRo+rASAImY0nc7fnbhNplLBmhq1YSJMjIVd?=
 =?us-ascii?Q?MNSIQEaaFp0PNnCn8GaevB5ml67Vn75nbJBzumeMJkBEuE+xY8+nXAQUZ/uB?=
 =?us-ascii?Q?eWE3O8Gifk4tormoLJcWrAW1OGBmIKEsyScBZzjIxagk1UFpaDd3iX9YBimS?=
 =?us-ascii?Q?o6w3SzGJS90eRDU1w4ZjVUkrtMqWdEmNpxp8nfjBJUMK61suC49I273cxDiq?=
 =?us-ascii?Q?6EOSk/RIgIKxLs0NFxd0b3uMlp57wqedKrvkMV+DAbI1xkJatw5pHrmCu4cq?=
 =?us-ascii?Q?wx4j00hjz7FPwul05PC+mv1+cnzb+b3TCW1UqIj+nk+uWrxLhS5m9bUAVDoB?=
 =?us-ascii?Q?PLOxq33yg2Y05lobsGn0BnA7gcz21TlO3txcjWDg0I8nSzE48rr711j9LahG?=
 =?us-ascii?Q?FZ3jHDaKsS+Fr0EVU0pP0SZ9sdnoI5O3GecQbPOfuZpMD/fgR6bSICVWhwwK?=
 =?us-ascii?Q?dWbyhOfOL+fCBFFGHtW4pBr7z9JSUMYoOAR4p9ZUVQ+zU2bNXZWn81q5jrid?=
 =?us-ascii?Q?rTwa4kPfmYpnoK41w5C9cnS6Z8CAxkP2MJkN4YeDRtTHmcGfb+2qTsnBshAh?=
 =?us-ascii?Q?lNip01+iO6/qyEuuZJSEV9J5ESiS5YSVVu9VIgCuepy48LQA4B4Ro0Zm5ksG?=
 =?us-ascii?Q?Nx27MQMyBKb8RwYnT0sJjhOB8J3yAR6PPCT+RQPplbRGbRu2dz0sf0+Ds0CS?=
 =?us-ascii?Q?yfwTTNO45FGRQnlNGfW93lRoOL6de349qqalUm5gMJ/d3eh8wfuxfWhze3Sm?=
 =?us-ascii?Q?eWkA30ucz7WMPO3eWgBRU1z0ahizSnBFKZc5YwUtz3Ap18EengkwxPIq48n/?=
 =?us-ascii?Q?FpQwtrEtTHsA2LKp6fESAmeKrl5/ZG612BLl41QXl+jHA/bOGqvUHQsdWlJz?=
 =?us-ascii?Q?F4fvNdMqBZB2zIyGVdmaz4lBEvsA9ckdAqTgg7GyseJ6YAjtv0fLcVvA4WU+?=
 =?us-ascii?Q?6r2Gly3WmmJ3bUcgUNbPOUharz8JPLSfabqNdcxdNxOGagg8fIb5DN9Epr7c?=
 =?us-ascii?Q?dQZKEkyPO8ElrKPI3D0SA3MFu+/AZqrr/07V8p4nwTaTVjMTt8VfRd33wI7+?=
 =?us-ascii?Q?aHn5Xu8Wn2DkpRc82ZSHXA5lv9w/9wXOq+6nzRVcFYDUOei8BhzEugDHj0ls?=
 =?us-ascii?Q?Qxus/y2TxC9k4fmBHYGfi9Wg2YWODHGKDYSadXZOp+NINDG/wddNvT6xHiJQ?=
 =?us-ascii?Q?0pZ/pd47szJkKNUpy64plAo9P3WIMlH3/EMClMQ8VhvOk0Is/Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(36860700004)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 02:39:51.3479
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54cbfa41-3337-4667-684f-08dc89bfc4ec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022574.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6426

On Mon, Jun 10, 2024 at 09:31:16PM -0300, Jason Gunthorpe wrote:
> The master->cd_table is entirely contained within the struct
> arm_smmu_master which is guaranteed to be freed by the core code under
> arm_smmu_release_device().
> 
> There is no reason to use devm here, arm_smmu_free_cd_tables() is reliably
> called to free the CD related memory. Remove it and save some memory.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

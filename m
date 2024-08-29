Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA54B1B5309;
	Thu, 29 Aug 2024 16:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724948407; cv=fail; b=XVe3XNqNizJTqvhfAhOV3ZnsNzRthYdDc7C4wnKc8LPGSaJnUdKc7ZCPJoCQT11Q9P8ZOOkdPeCWVfXWO4fubLOS2Dz92e98wknpDW9rWao66Xm1ihMRN69gVAukjeiMC8ttI/m4OhzGWOA3384SW4ERy0G2kRZoy0R9LSGyySM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724948407; c=relaxed/simple;
	bh=L83KTmmCqpR8S8+5V23/OPMS9QbgnOuqoYauASZpEjU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E1qrYn6hiVMnxGJtSd09Ro171xlXmmoIHxJOKy7Sa0S8KSzZH0MefrH+9Rew/AqBapCbei76HolROM9Et0IYv+4hg3fiI8QyzOrTA0x8si0+2H2qGQ7M4h+LsF9s0lRbXEAEyTF2a5X144xbs/TGhXuTooexdVoldAVNtMOQx6s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XDrfVDMy; arc=fail smtp.client-ip=40.107.92.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XDrfVDMy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xou1s23kkzu1y/k0USwF5LTR5cEKrIEgJcE9mxT9vGooDIASbOtcVRYcTJcrC8ABYWQmtYu5RzDmCTxjHkf5z4ZdLDLIU5alzsc9nuf9oPnaAPI1uzI0dd+lJTI2p7VI85jXiDzfDbSHS6Z7qC+NmfhXMyvkDWPzLm7CbwBAUBWPUs2rFVN5QTfUpAQAnjO+s6eY3NyA+I9hjauhTWf7Sv+t0CUSM1f/+z2b3Ntkk5yhwUiOnqI/xigs3iIznmgkbVWjmGa5D7E/+t5DyssR9b5Fnyv0IYmGu78/53jzqdxnhI1xGVlJjylaOorHdqJfsiHYJGD5yaJrMkpVPSXsyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=18rBXhv7EASx+7NoYa55PDUsGpzo7FZQz6jthlcwb+w=;
 b=O7y9vxnUoviNciYbO3SGizfnEPNSZoKods6vXaHx8mAqkBrfc+/qVWesci7mvfwjtBfb1fpOMqExb4FuXyoHf42EqSGrDvKdqAJJSNxW0MtKMA/MRCz4VpzO6YNqn0/y5dkMhhNkSHmZI/CrbNL6PiARPGiEpmNf7fAuF3BB5o1bM5vUaiKIZyOJCDaxd3RIJtN7sJzUhD+V6jLFxGlO7yjyDHmdnIS9Xc2Pi9ZZ9QEe5jfm60EdJo9WPikhmMwjOt/NWeJUNaoQ/Qwzp/i8to1pfhIh7vGmLMz3/U8mGHDhBlPAW9UsLjubWtKiqFTRjK4iO438rxPxRN/pyM7uFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18rBXhv7EASx+7NoYa55PDUsGpzo7FZQz6jthlcwb+w=;
 b=XDrfVDMyjuQiDJtve5xzSUgKw6sjp2mwK+kclKCzM9kcGPjTve3JBIBg4q4G64ZmOexLsHh6sIOJn7JkYPZ70yQ8CRbktCSEX10q32bLcZT+XFs3gFjhIGceBbFYO3Y4tykK8C4jApmML7vvmsRDnGGVj4Qp2vddg+ga2YawZS76cgHrY90MszakdIJGXZ/LVWLNTD2fhPB+eNj0RfXaqUwRE5FP8fou+ZZOTvxHELILRSV2g+GTYhy4H+dY1jPerQmwxs89HCNbY/GCuANev7avlSj+sx9dgH7eS2kmya15cP8KLK9V6R1P2Pu3HTicCWCIPpOze2P40ewdzSVyAg==
Received: from CH0PR04CA0001.namprd04.prod.outlook.com (2603:10b6:610:76::6)
 by CH3PR12MB8726.namprd12.prod.outlook.com (2603:10b6:610:17b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Thu, 29 Aug
 2024 16:20:00 +0000
Received: from DS3PEPF000099E2.namprd04.prod.outlook.com
 (2603:10b6:610:76:cafe::82) by CH0PR04CA0001.outlook.office365.com
 (2603:10b6:610:76::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.27 via Frontend
 Transport; Thu, 29 Aug 2024 16:20:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS3PEPF000099E2.mail.protection.outlook.com (10.167.17.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Thu, 29 Aug 2024 16:20:00 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 29 Aug
 2024 09:19:45 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 29 Aug
 2024 09:19:45 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 29 Aug 2024 09:19:45 -0700
Date: Thu, 29 Aug 2024 09:19:43 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Kevin Tian <kevin.tian@intel.com>,
	<patches@lists.linux.dev>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH] iommufd: Check the domain owner of the parent before
 creating a nesting domain
Message-ID: <ZtCfnx/NKbrjRiJB@Asurada-Nvidia>
References: <0-v1-c8770519edde+1a-iommufd_nesting_ops_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v1-c8770519edde+1a-iommufd_nesting_ops_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E2:EE_|CH3PR12MB8726:EE_
X-MS-Office365-Filtering-Correlation-Id: 94c5a793-7d83-47df-ff33-08dcc8466e52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cq3rWmeZ4KFaW2suxyKTXKJmMhER1WGZNHYkyZffXnEZqezHkjxbDEzUb5Ph?=
 =?us-ascii?Q?aZUN2aKi/cw1tc10GV7pekitTK5NeTwUP71Gp5ncCn00eVTwN77j3CWKQkF6?=
 =?us-ascii?Q?MkX2qZJBiEN+FQF0oY+kBVtQd7mfPpb3VXK93lbXSDM3apGPQ1ZgbBdsg/t5?=
 =?us-ascii?Q?Hoh16FrlRzMBcc4+5l4xrklgEvhPVr0SvdmXPMSEwryYzWDnErbZi/VMe2Zu?=
 =?us-ascii?Q?oAowBKrXbFhxaUbRuaXrUoyhQNUk7DatIY6ut3fON2uRDNwv5CbSeBtD8f+5?=
 =?us-ascii?Q?En5w3kuKEb9VNZaA10zVqhY3fo96B/oiP00qy7M0aQL3yLkN1yZQ9fTCkhzv?=
 =?us-ascii?Q?eZSO+iZFkfKxIK0u9Ya1zPiPjDyvd9rBwl4spMGRAzz5qQ+A109FDHETWdNq?=
 =?us-ascii?Q?tfTL9FIRQtrMwQO4itlzCttXcdd9m5X9udQLG1wEYYlYiyMTsZf0wzsPfc0v?=
 =?us-ascii?Q?shpYz6sejWaW+aubu3TAI2NoOfu+mB6BdgEBnTZEXhSvnFkDdwzkppjebOD7?=
 =?us-ascii?Q?BTM9Qv1VAcIrTfhEOqxKFlOt4XmCbDNCD5vI+gaJvEBQ62JYz6jlJygL1qf4?=
 =?us-ascii?Q?x0j9RE42e/3MijUfhNpNUcTd//fMOz51ftHbT3S7qFHRbGybaXjmGcW3NOVW?=
 =?us-ascii?Q?s3VuHdEQK5gWtbto/0sgqGb8qAdnJbXS27sOePbqP1V/sE/GrVQy9RtG87KK?=
 =?us-ascii?Q?jwPaIk5Qk/aIoHQNboDvj+ZolwVaru0nVvFYMHGav067invEWokII7UcFvG+?=
 =?us-ascii?Q?5P/vWgw9iVygC1DxiBYehLS+7NLTvZ5LgDzk0oN3Uesnk8XRMpiQExnUccvB?=
 =?us-ascii?Q?+Qhy37KVCQlBOF56i0ChPIfkpwVbQLbciyq8tSaMzbosV1CqQ9Ppsk0FPkLC?=
 =?us-ascii?Q?7opE9ye+P6nAdI0xb07AsdukzKyU0agtVAZWc2YciusO0q2vgrQdeKLXn3q8?=
 =?us-ascii?Q?at8cC9YyFqzRwSN+Xi4w03T9Eqb2j0hX3AfRkBeJ7Mpiu+ScZq7PiMFQ/YfQ?=
 =?us-ascii?Q?pMZ6k02ZBT+dX9vn2kehPOiFllBKGVnm3H89/QQCg0p6WqGT6cpX9zKJWwz8?=
 =?us-ascii?Q?YzJ5puAVIiCw+7veZriCpkrapJ2tMwnSLhLpugn9dv6fGMAKDAqadMdJMW10?=
 =?us-ascii?Q?0ETGOjCmhzxmgBdiRI3CnNXUdfglS0z5DlaXzqCZd9XFop/DpJYKPPNw16rv?=
 =?us-ascii?Q?YxE134sBc9wQP2nQdMI4rS41x3v0fsMp6o72xSv499bRNM1X+cBuKolDKv9g?=
 =?us-ascii?Q?k8CiDctBVfaOKuyxfREGezxMzNChWWTBP/u/qRf4wZo8lRUanpghNZDcL3Fl?=
 =?us-ascii?Q?t2MfHh3xn0dyAYGU7OO/AnznQ3PV1jAH0mqBKJYWV3PEjjJJuU/Wc+J0ExAJ?=
 =?us-ascii?Q?319ChfiYSE+p7MSbYc4fZfv+VMPU76GgqJmHH0TZUjfaSe525Dnj1Y70hSJZ?=
 =?us-ascii?Q?Tk78iujMbA/voAvbDzaqtnERHADahD68?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 16:20:00.2404
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94c5a793-7d83-47df-ff33-08dcc8466e52
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS3PEPF000099E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8726

On Thu, Aug 29, 2024 at 10:19:59AM -0300, Jason Gunthorpe wrote:
> This check was missed, before we can pass a struct iommu_domain to a
> driver callback we need to validate that the domain was created by that
> driver.
> 
> Fixes: bd529dbb661d ("iommufd: Add a nested HW pagetable object")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012022.outbound.protection.outlook.com [52.101.48.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3C7192B75;
	Mon, 29 Sep 2025 21:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759179623; cv=fail; b=TrSBjXawA5FdIKpZmqFKZCPWOXdiyAqeF6zskBNgppHEvApn99rIwwMLKq8T0HP9iQDVx6RZqyhJR9InE/CDj1JiPMaBYBXJCzbTPHZGanjbZif24DMwrp303iK7YkKyCzS+eHfBa1ukbMINWrPLF9rAPoabePMom4TDswz7pRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759179623; c=relaxed/simple;
	bh=23rUuCNUb0tHbO60kwSlzrUN53fnexgbqhPWOTWrYLk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F69kat1aE2C12HXnSEXwUQhvTqZHCl9oBcSt4ZQ7y+IjWL4wKgxhIU4O8P7FjZRyhu8J5FpA4tDkzY7/VgpElARxjH8qYD6G3vk3r4nTXIyikLBRRNP8ym9a3KzVFbkG+fFPyIPerfae/uB8N9FQLd02CyMMDXnFyBsqL8nnd6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OgwJu1fT; arc=fail smtp.client-ip=52.101.48.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OgwJu1fT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uoU2YH3h5u2Xy7OwP9pwRy8bjgVyXwDs2Atw4ksYBKWIYJuFttGH8WUbQXf81xOpOYNx+FUwZvYPQPeg3jQPo36oLCAbU4qYRedavfHu49i+/nUQEzWZb+5ImF3K8ROsJp8lbxQjXJMdaLsSyZPxHo7ZtbnpbrDRGM99/+NYdGQj198Q3LXlBuuyr7SJ+yxbGKpt/nJpYR7AXX5PmpetY0Y87kA1WYOfOzhTR9WDt7CAmfVrQnZ5jQAgi/AZ3LV4IN9j7IXWjOKozYP63cMvZwfsRlfnQ1qiiS03hIRmAbCIm8l29BMkuJh+SmZO9cJZPo3Undt7c1XEhZC/I+XKWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n4HqOIo/O+Xc4FK8ysMCT+z/yoxToO9vwAG+mTGUEfU=;
 b=ea4vGwOdpr73K/Bb/7MDoacFL/VxhfhoMkl15fG8QqHysZaHbfGTxXt6Yiv52I8XiYwSrlMxpoWNT37NWEamwHWO97xr31fPQ07mP+HzsLiv8YJ0OOc8i5B9rwMZWrvtA5Bebv3m5vzhZEkEwrvIo9Xg++mkOdqlImgqhqF/9A+SjjYPMnp2uTh1rh1oLOzfk8D0eHuQF2ar5p8rcpeGOA2D1lCSseTgFQHA6Ebdlhc98yA0joa1VG41vxkp2FaOnka/qO8rbrK5gKk3MqlIEVa0JjI0Tyxr98pxQvGgkhHEyINIbe4ceDIh1f5X5lRw4Pl6aP0iToo+YxtRI/HT/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n4HqOIo/O+Xc4FK8ysMCT+z/yoxToO9vwAG+mTGUEfU=;
 b=OgwJu1fTadIfVvT7NSZcQAFsBMERMCLwFRu+A3ixlqHZBZGpcJUXVMjOGCB1OpCYl0sEn7NfEBsmMkTjEer2VjytimJaPymaG4NEvFZk22y498+nGc+NqcFzpVJP7ALIpaBuRYke407G5WRlouHU4E2MbKyLgU1TtGGRoNlPqMSDETMCTVKx3f/voYgxhr0PcVBxIgUnjCdpz7OaPkn/lVXUEqejiyoMhtxM3VxuEjjDgcV7j7cu/c9gB4ptIGXSgCGXOMEwFJWQHF2lJg7pUIvHTlWi3jSvDAuiYaX+OyNWtVrZgLF3IpVN954vfObb9uhAxwr6U7ECmQY2NduGJg==
Received: from BY3PR10CA0010.namprd10.prod.outlook.com (2603:10b6:a03:255::15)
 by LV2PR12MB5992.namprd12.prod.outlook.com (2603:10b6:408:14e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.16; Mon, 29 Sep
 2025 21:00:15 +0000
Received: from SJ1PEPF00002321.namprd03.prod.outlook.com
 (2603:10b6:a03:255:cafe::82) by BY3PR10CA0010.outlook.office365.com
 (2603:10b6:a03:255::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9160.17 via Frontend Transport; Mon,
 29 Sep 2025 21:00:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ1PEPF00002321.mail.protection.outlook.com (10.167.242.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9 via Frontend Transport; Mon, 29 Sep 2025 21:00:14 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 29 Sep
 2025 14:00:03 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Mon, 29 Sep 2025 14:00:03 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 29 Sep 2025 14:00:02 -0700
Date: Mon, 29 Sep 2025 14:00:01 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jean-philippe@linaro.org>, <miko.lenczewski@arm.com>, <balbirs@nvidia.com>,
	<peterz@infradead.org>, <smostafa@google.com>, <kevin.tian@intel.com>,
	<praan@google.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH rfcv2 7/8] iommu/arm-smmu-v3: Add arm_smmu_invs based
 arm_smmu_domain_inv_range()
Message-ID: <aNrzUZsgCjd/9S1+@Asurada-Nvidia>
References: <cover.1757373449.git.nicolinc@nvidia.com>
 <9ac8acbd289fa32378498f09f78e7924d3523200.1757373449.git.nicolinc@nvidia.com>
 <20250924215613.GS2617119@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250924215613.GS2617119@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002321:EE_|LV2PR12MB5992:EE_
X-MS-Office365-Filtering-Correlation-Id: ca32cfe0-8208-4d13-be6f-08ddff9b2fdd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nlqfwo7GCDckwmZLFK888kdjW8t0d9YI/fhdfOtb1KwuahHfL+5RFmF8KhUG?=
 =?us-ascii?Q?ZIXrdca5btBWIdkcVV6JHQ+DfdLsguPZO408DLbzJx4rOXBwPr8EKhs7R7t5?=
 =?us-ascii?Q?TQp1ESKXFaa+k7MSWBBD8lGzQO+5n+r+MlrtOGq0gGh9k+Wry6+DvEQFgYQb?=
 =?us-ascii?Q?KGSi9PwvOQbFfpJw6hNViVOcuSHhRpixgFf7HA5jvwktgkfwLZom9pQUagcQ?=
 =?us-ascii?Q?JfhAyQDzvghxF/d7uk0TqlcOsWKfxV87b7TvnDgrddhcwZ1MFKFlXc2xMDF9?=
 =?us-ascii?Q?qlt/q03VdtLJXvG2UpdcLi4aKPT3M8uiWwx3Lsf+BkAD5RnLWn/gJZm9QaSt?=
 =?us-ascii?Q?Pj642hDRbaBiz/OJG2EQ1ipPU3yGfeyGYvx1MMW6UqBPAf0PXv7FaIdypEpK?=
 =?us-ascii?Q?6qJp6AykwF/XSkEvDktLu6E5PsQfaAvkIjp0NEkDUaPhNyKbeGKdXgIgRvS4?=
 =?us-ascii?Q?AHAtjyXcljeSC1bxHzEvPkCyBHSybI0moavwx6A/EGmbUv7SeRbbRa51fI8X?=
 =?us-ascii?Q?1YT6hz6g4R4CL/y/65w/Ncu9n1v/dYr8BDTWcrxnrKKFax+ZaCoXmp9qVCrg?=
 =?us-ascii?Q?lLK3E6//CIDOUOdgSaWMdhNYwCgo8kl04T/y9kiMeNe9y5VNSL4BH1NTdk30?=
 =?us-ascii?Q?7iiuvq8s2B/P1RnZ4q7M2+EOIF+LpAiSHoRtbNgZEru3PbmlhyWLyOu/gNdl?=
 =?us-ascii?Q?N/Z5ysNCexJF4QmZIG35y1BfHzNOxxMImCpGCguLhMXHIUrH6+wlyOMeE010?=
 =?us-ascii?Q?yY6YraCUlDazOocPra2JoTwHfkzvmCfxWI4XDlD8nq4oG2BZGNBlYa02+qY9?=
 =?us-ascii?Q?V3H9e+iyRV9znUGcASCjMzfHGYEDhd127Ez7YURgyPyZ3ehUgq6KVvwM9b33?=
 =?us-ascii?Q?TcMvzMO20uJouAafz0Q8YMB8saWafEHjJc/RaD+zKHEkRSqmq1raDcR4oD7o?=
 =?us-ascii?Q?o2bwKMIgvNyzeNySz+1s1rREV29HHnDWqY3NILgd2gN144OEH944zi7TlExx?=
 =?us-ascii?Q?WT64GWQznbB5an49uHBanWGOT78AqU1WCCT6eG3Zdi+GsC3CEssV5c9Aqk0C?=
 =?us-ascii?Q?W/cpE2stgYYk7rfDlFFrq1504WCYCq0+kxUw8fXM8XQsUCSoRDGaeHEkr9uP?=
 =?us-ascii?Q?ZpSJJD+INRAlmRx1/eXYFfJ1fmoC/JdrzExtKES12cYy5iJ7R/gNsjMCA3g0?=
 =?us-ascii?Q?ijF7uBY1OvppWMcKgQDyW703fJIrXuJWSxtWbKft8mfJPRfeV3cdHy9noVzT?=
 =?us-ascii?Q?szgStiXgnQbYEd6tnLt5tKj9R2OOjP5NLeQdWJ+cdFp4P4gojgSz05XntQ5y?=
 =?us-ascii?Q?fN+6Mjij3Coch0RViRFl0ygJILjAAaCtcjXY391Q330epDcK9841QigAgFh4?=
 =?us-ascii?Q?qj/kxKUBUae4Dl1dSmgnF33F4MiiNHEOwRfvxsm7pGu3IN7DOaeuEFgZmSN8?=
 =?us-ascii?Q?b4x8LusGuv+nCL6dhL6Kc+PXt1rO6+D05KU9fmYVqCCwRE04Wa0hwwsGHD3w?=
 =?us-ascii?Q?02/ywGoD5vvlEc2Ncm84Ih1oWCbAtGRgI2RzzpzqeKcrbgXGEbTX7dzcK9N9?=
 =?us-ascii?Q?4GWFSJx83w8PM+/OzgJ9WoBJBd1sa92eVZJEq8Qp?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024)(3613699012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2025 21:00:14.4165
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca32cfe0-8208-4d13-be6f-08ddff9b2fdd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002321.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5992

On Wed, Sep 24, 2025 at 06:56:13PM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 08, 2025 at 04:27:01PM -0700, Nicolin Chen wrote:
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > index e4e0e066108cc..c73a94514c6d6 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > @@ -675,9 +675,15 @@ struct arm_smmu_inv {
> >  	refcount_t users; /* users=0 to mark as a trash to be purged */
> >  };
> >  
> > +static inline bool arm_smmu_inv_is_ats(struct arm_smmu_inv *inv)
> > +{
> > +	return inv->type == INV_TYPE_ATS || inv->type == INV_TYPE_ATS_FULL;
> > +}
> 
> I would put these has_ats related infrastructure hunks in the first
> patch adding arm_smmu_invs

OK. I was trying to move this (and the chunks in the other thread)
closer to where they are being used for a cleaner review.

Thanks
Nicolin

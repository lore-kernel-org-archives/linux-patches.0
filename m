Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B9AF4EE;
	Fri, 17 May 2024 20:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715978122; cv=fail; b=sV8olUUrz/kjslirwTTVSgrX+ztH8icqffNQNMneBF5/FnNT8iZynUZ+Qssulywlh3v/NBwzdZQl+ZT/Fc48VTTtbMaAqNJvGeYYtWxjXgW82yocdOtOQCyB7qGN8LwxPxY8uwQD3YWrmJHDMZHNRsXCEAg+gRQU+9fH4J1odqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715978122; c=relaxed/simple;
	bh=Vkt9m8BvhECOYPHPReLJwvdFU6aRVGCNDa1ZUirOw5I=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZGg0sYbdJhdAr3FNoQ7SdTxAPFK34bhUKWweYohzZlEDsJC8phDxWj37jRzrxKPfCNaJqGcETc6uHYjM65HJLsvw2i90hWx+MpRSEzuK4/1tBO5eO3wJPsYNnwIm6cDEfgZGm6O8/IeoP7q5LwU6ZFwYiW8oDONPHdorhbBOQi0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MNmwLD2v; arc=fail smtp.client-ip=40.107.243.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MNmwLD2v"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0Rvf4Cq1KJsxzrtzgb2xO68e836U1dGWZ+9oE8vL/s/t+pkov66Dy9tR7U8uzCmeKuZXmdXsSbm3EaYzIvRs0gDZs6E0kHrPCMBGlEBeN3IWO0IBtq9o7vm8NfiYDz+ktpLjFcYY4o5n19JqflLnVF2vWHSVrSdJ4elvAbEZbFyucyyuVU4Z1bgXBCaYpn4Fb7Ju1cjCuG8Lw4hICNa2YwVLJYZ4HzS1qGXoQjiRZyP+JTQGY1zQzmDgd4m/N0L5P+xjNZo3Zq1VsrHGBDpZCAprbcDTI1fikO/eCYfTu+HTt0eRhkGBoUivQMOdyxx1Hddvk3Y5CsKOuXmcClPLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VkrVYxTH5TlKxuf8HoCv127lopErl/K6bquocEBh23c=;
 b=TOwkN3SAkGhETVhWEd7uSMfVWhwSlYiU8rzkvZ+Q82M/tDZJEzbzBD8i5YttXQ7FHGonysTvuyW+QpUVyBPZt0LGY9CVWe1HQE0HGJjU6gKPdo2cZE9C38XloS2JHrjW9kpNVOa2+zbvoGY6C7Dt7WCjDLRZitRUpsFqpAwTK3D50s09sLZRlYW0+Dw/wzso92rJUQcEwpL1JmCcBwnBHcgGBU3zu00Dl1QIMroFnAwtk8f5DpnWcp+CZlFN+NrXOvoV8EIKyNcgrXbvnVHMxlQcavdza7CwX3/fArX+2y8QoT627gh6hVJQullALwh73vwS3nh0D945SxeQpnBfsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VkrVYxTH5TlKxuf8HoCv127lopErl/K6bquocEBh23c=;
 b=MNmwLD2vDnv8YNWdrvb6E/NpGTpZ2LnNw1kqtcLcuU+r5xuAiLZTKkdzkIQvfzaDca4EspfmH/ZSmWSCchEYuYi9UCuwWasnLSgYKJh4TWJKEUXN1oierp3583glMDWrmlnVeMTF6TBtSIQSjXockvmsQdHRMfsYqx7oAFBillc8yljR4WmLOl6/8lNU+7yFXQ4z+eOzVlTiYh/s0WNIVNW6L60a8//r56Uuh26o7q1HJqgkpgcmwybbCfAnDFCf+tAD67QwxR67c8ACPSyON3KqvFpubi0m+QbGRFG/rWwyNQXz6WHbkHYr3HZJl9YxySjfUeEtGAoyheWdUdMUxA==
Received: from BL1PR13CA0063.namprd13.prod.outlook.com (2603:10b6:208:2b8::8)
 by SJ0PR12MB7475.namprd12.prod.outlook.com (2603:10b6:a03:48d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Fri, 17 May
 2024 20:35:15 +0000
Received: from MN1PEPF0000ECD4.namprd02.prod.outlook.com
 (2603:10b6:208:2b8:cafe::d8) by BL1PR13CA0063.outlook.office365.com
 (2603:10b6:208:2b8::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.12 via Frontend
 Transport; Fri, 17 May 2024 20:35:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MN1PEPF0000ECD4.mail.protection.outlook.com (10.167.242.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Fri, 17 May 2024 20:35:14 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 17 May
 2024 13:35:03 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 17 May 2024 13:35:02 -0700
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 17 May 2024 13:34:58 -0700
Date: Fri, 17 May 2024 13:34:56 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 10/14] iommu/arm-smmu-v3: Put the SVA mmu notifier in
 the smmu_domain
Message-ID: <Zke/cO6xBejkSOf8@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <10-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <ZkKExvnPkHWjedAX@nvidia.com>
 <20240517194814.GA133219@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240517194814.GA133219@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECD4:EE_|SJ0PR12MB7475:EE_
X-MS-Office365-Filtering-Correlation-Id: 865172bf-23f9-4c54-9ad5-08dc76b0db54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|1800799015|36860700004|82310400017|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vd7NyqczUidrqwSJNNx+SP+LN3E6kSHTfY8WuLQ5osGAGMYIyVxkV7kpz150?=
 =?us-ascii?Q?Xd0gsUdd8Xo5SI5xoX9eKs2lAXvHBdIXZcjS+gliZsWn5+xtyql6NsSXiF+r?=
 =?us-ascii?Q?vSumNWlMnwfirR6eMOLSRIrP+uNcUFTFwKWjOf+cdMzqFEox5K5Qgsx4i90u?=
 =?us-ascii?Q?OR9QiJHOC79CuqlMIJ/EjCzoVrXugd3ScTonK9W6rhBfJOf6//VpBgGnsdKG?=
 =?us-ascii?Q?RV8gH5qJ8DddPDCbyzVhots63n9rnt/N3e0TxxEwLlCu2L81DGvz/b0I/C0d?=
 =?us-ascii?Q?lJmv2nU0iwYzzoEurXIynagigsQuRDUwCrT/YUPMEpZ6kKO2b6qqqa9HnmlY?=
 =?us-ascii?Q?lXW2192dABbXktVcV31Igblg0VzrdroV6WWqjrvxDzvT+Y4nHvpteCXGLHe/?=
 =?us-ascii?Q?JnMo0SxDBR67xeie2VaU5HXwnKdhH60b4C+/5L81QM4tu7yU8GHYVwS8mUVI?=
 =?us-ascii?Q?D7fYekgu3OlTXV93o5blp5+wTuWrsqmkCzTHw+UJvVFKXryfQ8EYhPieTtgs?=
 =?us-ascii?Q?Mcei3sZticINYGtLJMVFvERQ6UepJiVyTOpJdcXGbGRlKJL1vEOBSjNoqO5a?=
 =?us-ascii?Q?Wu+QaY2CMjIUIH0wIAR9UGBpSG1x9ZlxV3N1AX6NYil5eGiAv4EL02yk0vbK?=
 =?us-ascii?Q?CNEzrTH3oWr9DSSCvFAc2MAWxhXHhSzbNM+0mu/tovfl3Tiv72UhsH4o6a7x?=
 =?us-ascii?Q?q0GFRCRPdmFKmKpfztc3F1ZnsosvisSzEQGb4IB/TJ1meMVjn33WPy6J2RkQ?=
 =?us-ascii?Q?7y2Ett9MuGhHzQ3mG166w0Kptf9YfMJUj1gbaH0E8TFAqCpes9EoxWsgJtya?=
 =?us-ascii?Q?ZnA7cR/otXEQyBAuyQ+U/3DSCmqidnoUlrUl93TZdgR5OLI0QBVHVznoTNKQ?=
 =?us-ascii?Q?/hP/s4VjYdaxEQi7r8jKt06Zf7xe8uNbC1NMAKzlANLbwGMKf6e4VV2uijyO?=
 =?us-ascii?Q?olXlw6BxUdaKt3n7i2ckLvorSSOevXLTtHhCTaVlnJDNV7BwmPWbi6HMcsqi?=
 =?us-ascii?Q?hXIsFLfdEaTvth+PjzlEtu2O5L7Nnplh/bunlH1npY/IAbsawqNtEBAokBgU?=
 =?us-ascii?Q?p4Ur7qfPHEsArqpo7JtW7YRPoIoOooWBQ+iz4+WdsKt8Vk3PLFyUZjdlUllL?=
 =?us-ascii?Q?yHXJEOfnJfFEv4JA9X7Aklp40JnWb53b3mrJnb63Cba4NzRiSTisAFWtZ0qc?=
 =?us-ascii?Q?2c8U4QYhTgwjrNN+xgV8Vd7XIaMIFCgOQvAHSJf4r7pHoKFyqLUGPnd8LBs/?=
 =?us-ascii?Q?EHUwJ0MdVsJFS9crx9Nx/ZuevwGgRFc03xo4c47AWJ8KXdOv8aadYcfGdmjn?=
 =?us-ascii?Q?RcHPO1AJlGbgDm2Htpk0hccRotGqLxb/PcfjNgNnekBGsakwxghOnD7L3G08?=
 =?us-ascii?Q?1qhRNfHBjQcBa8e48M8A51kdB8Zr?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(1800799015)(36860700004)(82310400017)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 20:35:14.3500
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 865172bf-23f9-4c54-9ad5-08dc76b0db54
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECD4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7475

On Fri, May 17, 2024 at 04:48:14PM -0300, Jason Gunthorpe wrote:
> On Mon, May 13, 2024 at 02:23:18PM -0700, Nicolin Chen wrote:
> > >  static void arm_smmu_mmu_notifier_free(struct mmu_notifier *mn)
> > >  {
> > > -	kfree(mn_to_smmu(mn));
> > > +	struct arm_smmu_domain *smmu_domain =
> > > +		container_of(mn, struct arm_smmu_domain, mmu_notifier);
> > > +
> > > +	kfree(smmu_domain);
> > 
> > Would it be cleaner to refactor mn_to_smmu to mn_to_smmu_domain?
> 
> I usually like a few more usages before making macros..

Hmm, asking because I saw three of them in the end:
drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c:145:            container_of(mn, struct arm_smmu_domain, mmu_notifier);
drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c:166:            container_of(mn, struct arm_smmu_domain, mmu_notifier);
drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c:201:            container_of(mn, struct arm_smmu_domain, mmu_notifier);

How many more usages typically could be a good threshold?

It's a nit though. So, in either way it's fine.

Thanks
Nicolin

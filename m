Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2080.outbound.protection.outlook.com [40.107.212.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D0D178381;
	Tue,  2 Jul 2024 17:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719939828; cv=fail; b=t3NEsltwy9xbLaaV1ps4Mr/lmNr11mubT8PWaCBHucKFYCrkFe20E8NiGqluXYgdFoSo7D+yxq8kUM3aqBPR0NJanu8NiNLjH41Lb37uocWRKrjkqFLQKjQDt/VRJcrx5nydJQs3dcxIaqRMvadQGLFvDZ7msIUGQty+KOpVFj0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719939828; c=relaxed/simple;
	bh=1M6ZkstuF5HMgd/YmH8jo+CAjMD9TM8tKYSmkS0snIs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oDbldGkkeQW4eZeeK/6zlYUr4T/kE/0plqlr6aAh1BSShUXU2ouok7L5t1EpZCRsjA3CItbzYk2prtw5P9SRRtVnMw4H/stPAyUExZ2s2/w8bGGiyftQsBopmlDkFCXYZsIT73fgI8D32FdVnFt/0ek7eYe/86zJ3P8EhQ2hqvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RPdoBgqF; arc=fail smtp.client-ip=40.107.212.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RPdoBgqF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=neif2ugi/x7AxFb42AO/skQkpwNhmJ/XxgSCkqTWVVk0IeQAGNKDuBwTnsVZAgDiCZGlyoTu7iycRH8Yx0HWbT9SOVNPdRl9HuOFGTXqAA3ypFAeo6aM1ATWFlru2zRFkch187DG0wvaXseXJ82DsQsSj7CfgDefWqLIHgofsK2I7LHgVSdpoZnRfywOSwkIXuPRLGSJ4gB0fLuKyMnTfymXETCFU9asARevJAETAn3hRS12RCb82lJw+kyHHeXIoX21UfEGqYbxW5nMzEP6bLpN0HuhZ0jOVNGcwfNKgiCrvBbNydiJ6CeEJlPhbmJcDpqK9J1gH7au2V+DTTtdBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8uJwtqa7YMSeeRD3lTutVhFbOQJcZ0BAskGf6rw6SDY=;
 b=cX1F0lnjGpCAJymuoKgI4rWLVnKeOocW7w5a5wXiCyGw7sd/V4nypIu7/9MuRaxwMUl/oJSGMEoSinic8ZZDMushL3Z2odAtAvtjkggpTVB3+xsx0gSXnUppovTtYNDhiIv7bAClSXNbVOG7rIrtn3UPnzlEzXmVkAvQDVTGuVc/Jdm9s9lHl4au6R4jCZL8QGIJAAR1SGChRG+h6w498PTfk3QjiySCa3UjHDt4grjwfedYqBmwCrxBlOObyQTiL5OlIlPxkgtDMa/VI+qTMF4juJYskachbsoNHYFWeq7YFO1OYkA0x9CTZTjpamdzKwg2woQ2VaN8kHZcgflb3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8uJwtqa7YMSeeRD3lTutVhFbOQJcZ0BAskGf6rw6SDY=;
 b=RPdoBgqFeKlqHH0bu2J1WS+YR0WExI8d9NVDPJiBVfsKZDjIWszu1xlRgOCYw+gPOEMfB3U5PG3eACNqcFaOf8hnpUBiP2msM6i/P7n0PLCiKIbOdbBk6WidK+zk5fa1pqrZeKS7WlV+PgKXw5o9kLJlwE9p/tIVV2Pi30meTguHA6hv6yqd5yf4zZrmp0SdsaTsBpTyz+Tty8h0Wvzqhy9uDOQ1++diwr1alkhGr+FHbI/10evQEKNEhkmCmt9ostz7gbNwezTAiVamgXJj+INSLQsO2vb7nPwKjSSsYS0tO/hK9eebYy7N3yIeJJZoub2UpSxIkFUA0RK4ZH1Uwg==
Received: from SN7PR04CA0169.namprd04.prod.outlook.com (2603:10b6:806:125::24)
 by SA0PR12MB7073.namprd12.prod.outlook.com (2603:10b6:806:2d5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.32; Tue, 2 Jul
 2024 17:03:43 +0000
Received: from SN1PEPF000252A1.namprd05.prod.outlook.com
 (2603:10b6:806:125:cafe::9d) by SN7PR04CA0169.outlook.office365.com
 (2603:10b6:806:125::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.33 via Frontend
 Transport; Tue, 2 Jul 2024 17:03:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF000252A1.mail.protection.outlook.com (10.167.242.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.18 via Frontend Transport; Tue, 2 Jul 2024 17:03:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 2 Jul 2024
 10:03:11 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 2 Jul 2024
 10:03:10 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 2 Jul 2024 10:03:09 -0700
Date: Tue, 2 Jul 2024 10:03:08 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Will Deacon <will@kernel.org>
CC: Jason Gunthorpe <jgg@nvidia.com>, <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, <linux-arm-kernel@lists.infradead.org>, Robin Murphy
	<robin.murphy@arm.com>, Eric Auger <eric.auger@redhat.com>, "Jean-Philippe
 Brucker" <jean-philippe@linaro.org>, Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v9 02/14] iommu/arm-smmu-v3: Start building a generic
 PASID layer
Message-ID: <ZoQyzJTmJtG4WIy/@Asurada-Nvidia>
References: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
 <2-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
 <20240702145705.GA4135@willie-the-truck>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240702145705.GA4135@willie-the-truck>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A1:EE_|SA0PR12MB7073:EE_
X-MS-Office365-Filtering-Correlation-Id: ab45342b-0f45-4000-a25a-08dc9ab8eda0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lmKkwUsqBTDGLK86qEyXAehynqbF4aGaEU0XZ8mmklAdf1I26vW6EXpLXxly?=
 =?us-ascii?Q?1K67ahCTtyn3L2CsH5TRgjuUW2DeoNnQZM1niPsGLJm4mB99OYI0JS44SeeE?=
 =?us-ascii?Q?GQKg8y6WHIlJ12uZu16k17LH1wzh//4t3dJj7HjpsmfRmp2He340C+6cdKvN?=
 =?us-ascii?Q?PpIfcXPNjVsuqK7e9E9b+VAxNNx0QZ0dB2X8XKem4HPu+DuvX97r1N4SAigp?=
 =?us-ascii?Q?dfvznohN4CXlgbiykALBI9eT9kExcTTpiFfiaH+VIW67O5FxDb1JXt16bLma?=
 =?us-ascii?Q?aNLV2xIfqzo7LkAnHWD46dgNtJN7pDTqe4ZVb3l78iNNfCJMxkJX5HQcz81p?=
 =?us-ascii?Q?rFlPZx3NQ+G0nf6XPY56gWw9vCezte9ZlQb+0CZpMfK3Gw03AVd/fwB2fO7o?=
 =?us-ascii?Q?hNYi2zC/0Qheh9CZerIBsBaxHQuLrS9AacSYAJiaLddMRERtCjWFhFtI5dNP?=
 =?us-ascii?Q?+8/Hwenn8uZKy0qMbJu4sFF7M1UKhF/f+OcFOwxDSg/a/8qvS1WZtRpW4L0T?=
 =?us-ascii?Q?Cs+J338h0Vevjv7kLePZpqPbjYbVDArfKf8eDQ3I+ep8W8XDUVg8+InC9rN6?=
 =?us-ascii?Q?IKHqXei3ED30iZ545gLOnE1LZ+xpFT+SbK+dNhgSBWgc6cVpCJGYIC9egOdG?=
 =?us-ascii?Q?j+nrfR/i/EDayQI/IAbJwjoUivzra/FF7ZtcC8dp7PPVfMmZ39nWrPYCKIxH?=
 =?us-ascii?Q?PTO4VZA7CDXcUu1uO3GWJHH4hyB3vnYa7r56L5wEPEFKn9dTZd/owtFNfCpf?=
 =?us-ascii?Q?snYIF2kwPXJpwqkNknTMzlUOpJu7BRzEuq/iVWauQq5W0gjsWs+vSrdnmqU6?=
 =?us-ascii?Q?sJPgiNVioo20W2zZXAbWSegSfrzdgI5hUynd32ed1UukEPHuzGQkk2uVSS+p?=
 =?us-ascii?Q?e/QGTOeL3TUOARGFwYHsaASxjp5efHQkos+1KwqurNIH7qNmP1eixh0heZT+?=
 =?us-ascii?Q?6de1Ay9yY2hVrrzaMUGJJMyPzBQE6Pgifujye+Djo4W3KIfNq7w+MMLz51b8?=
 =?us-ascii?Q?AmOcYFdwREg2PS32xwRKDP2IZ+coZ4GPPugbkDn0qBnZb61MdSZ9uoq4o0xR?=
 =?us-ascii?Q?4Lnvuom+dwqKfeMzzjMrbsKWu5FPH5EdeUIEWq5kfrkHzQpJVKvACbgGs45+?=
 =?us-ascii?Q?dLzhqQdhdyjon17XWJkg9ZPu+JJ0IfZ/cVcCscUc743lErnRMqHE9oaa3MiO?=
 =?us-ascii?Q?lCABLhUq22zCX/21BwIMmpppG7YEvRp5n5GhN+rZm5vTdvZVz2/iQ5v+xKYv?=
 =?us-ascii?Q?Cc/qQn4dSuvcj7mi7BL3ITAN8hWkZuRDYWbwo7cQajMxdKORN9W2UULegZq6?=
 =?us-ascii?Q?aNtyZ4IQTTDJwDm7i1yV9LeQkejMf7ZInDprasq+Op8oQcFW3686jaOpTXCB?=
 =?us-ascii?Q?zl1vqZWap2wNATtKY3tUPrTf4GQjruug5+W+QHWgJqnga8Hoi1wg5IPn6rwi?=
 =?us-ascii?Q?AE6xfmIU0MYM8ARWG9d5B5f49w4HtOQy?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2024 17:03:42.9749
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab45342b-0f45-4000-a25a-08dc9ab8eda0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7073

On Tue, Jul 02, 2024 at 03:57:05PM +0100, Will Deacon wrote:
> > @@ -611,10 +599,9 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
> >       struct arm_smmu_bond *bond = NULL, *t;
> >       struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> >
> > +     arm_smmu_remove_pasid(master, to_smmu_domain(domain), id);
> > +
> >       mutex_lock(&sva_lock);
> > -
> > -     arm_smmu_clear_cd(master, id);
> 
> This looks a bit alarming, as you're effectively moving the CD
> modification outside of the critical section. I assume we're relying on
> the iommu group mutex to serialise this in the caller? I can't see any
> consistent locking in the driver for arm_smmu_clear_cd().

Hi Will, your assumption is correct. Jason had the same remark
during the v7 review:
https://lore.kernel.org/linux-iommu/ZkDAL+TX93QfTFMc@nvidia.com/

Thanks
Nicolin

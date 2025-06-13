Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2053.outbound.protection.outlook.com [40.107.236.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47899230BD2;
	Fri, 13 Jun 2025 20:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749846006; cv=fail; b=ElsoBFOIBPQMvgL4tnQK3QYJ/ehEPdc4iimOvuXNy4+d+fOi5W16slM2N+Q7ZOGO+GgS+5kjFDMKKEVRxiu5FXMzG82qOvMEag1L349aBR4lP4ovdhPIAs48fPu2sHSmm61gyNNfU41whYvJ+d/GNyQFAMZu5yQFlmW2UUYG5Aw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749846006; c=relaxed/simple;
	bh=v5B+I/8aLC3d/Y2Gtqmzwhj5kGkcgwATE3YkdlenvWI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SRvZuj1+a+ByDq7RGZs7bH/7JEeQrCptgE8w3KenTKOsv831oHYZpgp61tgWPxnF9xJSOGdjwcVaRndb2H5ZEYUMGKjO5vzLJ6C2XZVbufpKL/9a0u4tIubtAeHpS72flZBNkZ0R5roiGHFPhfJuDu8jDXaEZzHyihEhHT3oHU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eOLawdsW; arc=fail smtp.client-ip=40.107.236.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eOLawdsW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QNZEnV+rFX08gNxJKjVqc+DgtDzppZttMCi7b1PEd/l3n9f8n/Av6/27kaW8Rn86mJ9qu/k3dKhTJyXAPxNTFHo/gTCsV+K2MTzpkMoLzyY41g0vT1/iKHVSht0+UIn8a3CX63n/+v8iUR1S2mDmyX0D7kkrI24UcxYvFCNVMbFjTtPVE0/C/+BBMt2jAAM6FSEODURX034pwfc6lF1xfSaQVCz4MlcoeV6Vm0knDAQqLPe30ztKhHTtGdS/JJRaIygTwBQPy7gvlkp3Ow5xq2OWawum33LOPimoqbJu++UqoxNvCmTqG6bjzB9V+VS3PbAmTZApvT+Be/4Thlm1LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RlpT+aGhz0QSynRhEH9/V690P1gbo1+nB617epIM9kA=;
 b=SFzjpYhSs0RSYyq49K51DyEPMEJoY00jyOkQdHvLGoJvxY9CZuxmAvjklAAtLJSS543lJRa+AwCLi1JMkbfks7NlmF3Qcm3nKFNfo3xc77b2q0c+HPFKGtplS2b/xV/pSG5H0/DA9OwqM9SeydfDZ+WRCOjnsahksFYBXo68SeIV/gGCaA6JF7CW3xLOqK2ajZ1bSwrQXUWvj0x44vUDpDdU3fJQsP3Lrq2E6qYSJ+7U81BxuiGdQMZDyDQY+wxmnxucX9JDZj7RrjRkktL9hkn7pGHWdNK+5wsvQWZ6Eq7CrZNhRsfsixq5C9a0Ni1yhQ79FRk/pefpQZwO6acapg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RlpT+aGhz0QSynRhEH9/V690P1gbo1+nB617epIM9kA=;
 b=eOLawdsWNY0dkjZGwJiPEyMKGi9xIVNz70bREHzVcyeedzILzxAuJz2GnoH9TyRw+dlcFhHefOaifDXvwPcUvYU2y07S2+4lN7yGaI6AqEjuNksFfG/nh48uvy3+Rs9E39Bhh+pcAPuoiiBWXqNilAYWvQYCygajrOzgVggr//5NR3VQKSDV64CoX90uWgw0QQ17dHsQqaJWYV8DEExbQihf5f04iA5XdKTLzcFjmWT19KDln0wukeYFlPt17eSxYJQFf/Gx7UkAFHiidBkf7BTRJeX1fL0PG0bOdX0ToR77w6ywfYZNKn6S+7BnA0dJ9x+q5JQhqdgvXdn/aMl22Q==
Received: from SJ0PR13CA0041.namprd13.prod.outlook.com (2603:10b6:a03:2c2::16)
 by SJ2PR12MB8692.namprd12.prod.outlook.com (2603:10b6:a03:543::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.42; Fri, 13 Jun
 2025 20:19:58 +0000
Received: from CY4PEPF0000E9DA.namprd05.prod.outlook.com
 (2603:10b6:a03:2c2:cafe::94) by SJ0PR13CA0041.outlook.office365.com
 (2603:10b6:a03:2c2::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.19 via Frontend Transport; Fri,
 13 Jun 2025 20:19:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9DA.mail.protection.outlook.com (10.167.241.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Fri, 13 Jun 2025 20:19:57 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Jun
 2025 13:19:40 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 13 Jun
 2025 13:19:39 -0700
Received: from nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Fri, 13 Jun 2025 13:19:36 -0700
Date: Fri, 13 Jun 2025 13:19:33 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <kevin.tian@intel.com>, <will@kernel.org>, <robin.murphy@arm.com>,
	<joro@8bytes.org>, <ddutile@redhat.com>, <yi.l.liu@intel.com>,
	<peterz@infradead.org>, <jsnitsel@redhat.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<baolu.lu@linux.intel.com>
Subject: Re: [PATCH v1 06/12] iommufd/selftest: Implement
 mock_get_viommu_size and mock_viommu_init
Message-ID: <aEyH1YPkmW1gy2da@nvidia.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <5880f4d754b2b7a7c4bc8664a5b954821c73aab7.1749488870.git.nicolinc@nvidia.com>
 <20250613134522.GE1174925@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250613134522.GE1174925@nvidia.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DA:EE_|SJ2PR12MB8692:EE_
X-MS-Office365-Filtering-Correlation-Id: f7b5d20e-be7b-438a-3f35-08ddaab7aad2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zCgmHTLir+BPBhTaJK5soaybzdgc5IYTGj/ASU5xdrK3Eoa2eSam3ONKTOUu?=
 =?us-ascii?Q?8Pvu69Ep7NlNXCkke+7rrNoNZpYa2MLLIaCW5GQ11YWRZs7OzX7idHyBRGKo?=
 =?us-ascii?Q?Pfh52kuxEZTaeSaQwoYzfn//DCoAYZnCmgSdpc+Q9gXPYBUyFhu5i7Ja0zet?=
 =?us-ascii?Q?N4/yWJtaxU5/oX83y2NQej9LOwr9BfM5d0HE8DL5U1EyL/EMLPzWoTC59kxr?=
 =?us-ascii?Q?mMnfe1fpT2PT1BByGx+kyGWDI/FDXSK9t6aMa6ePf+2Om6PEb545P3lMYcAw?=
 =?us-ascii?Q?msSw/tdOaS48LpBqRQhrsrY3nc8NnIqqytLUHv51vyyLZMWCsgFiWv05/TpZ?=
 =?us-ascii?Q?7pO5pRQBCr+n/XCyJCTpXp6WOHOg4LPIOqi2VYWbz1RZA8czLj/IgHBmpOqL?=
 =?us-ascii?Q?SXCPAcw/chPP/5kHkI4Vqp5/HA55LypiW1SEk9Q6BqR6U81QJCozaDbAgIiU?=
 =?us-ascii?Q?xzHIDM/Z84jG0Z2JXH7VoMLV6FlqS3WK4q1pI5cE4Bk/YRCAgYyiqd62z/OO?=
 =?us-ascii?Q?X1YTQRv1qghjAPsTkQ3lD1Mk8twq0o+N2xHrUzsDovMZ0FntQ2EFHNjyI6DM?=
 =?us-ascii?Q?j7ILG0O3t20JLD0Hl5fY1HXlRnJBbfrH03dCjPw+jq3Lvu3Ouv87X02Oj+hD?=
 =?us-ascii?Q?DU0x+RTeLjGasYV7lHXx+OGtyEQl+QIgNwDF6iCfiHfwc+R9MBMoKgxbUedQ?=
 =?us-ascii?Q?//uKoJVgVqRu/JHPLEJoLyFecSzx6LegHISsZ4kZqw6Lhb4rljXI/lyMzGpk?=
 =?us-ascii?Q?zHJNmPeadqWbE9AVEZE48RtDoCHyz+/ifCSeO8tN6TKkmLLSidqfzs6hTVQ1?=
 =?us-ascii?Q?Rq0O0BF1Pis1tqdFdryFKUfeoQ4KoSMyb6qaGrYi2bwI68FdRbPUAP85V1nA?=
 =?us-ascii?Q?9mpl6DidttaDkgQqlaqeNyR9m9HmwHS0jXkFmbnfQP+6sUJHqDTbydIsvCEq?=
 =?us-ascii?Q?ofmbu+rM2b4zVpPk/kl8dj3c1Bv1DxoMAUCy2tmLRDZTBlCv7SoGk/8LR+B6?=
 =?us-ascii?Q?RaUcz4kzTfwF7wYGBSRAlE4hkWl6zqmMT3WhxhD2R7UK5unH2IHCm8omotGh?=
 =?us-ascii?Q?F4Fse7EERRBGFMDXB0cTPqriUq52vK8bIT6HxQL+VLInuks8NpapJWiNsvrY?=
 =?us-ascii?Q?n2Z0NlUihnZ2mcHc3wJYBGaD8srYQSZFzEyEqYG0g2255QXMUIV7T1icjzeC?=
 =?us-ascii?Q?yvjRb/Hm2zsQY6IhFHQhRJpvqG739KRNVPS3UVIqcDPzf6A8hVyps+WvHhPN?=
 =?us-ascii?Q?bNlqW9ZFdk4iqXYeVPerrlcG/ggpfKkHmKwX0g4BKzz0jErvkJMLYQO8+rAP?=
 =?us-ascii?Q?hXu7+LWHct/AjPighcAFgGVI21RlzDAhdPR6hR8uIbmNbWwuWyvYNVr4Yvos?=
 =?us-ascii?Q?t06CvNflgF0MiSGkuZ/2GvMkdAz17bWJUiwFBJEGAphx7sQ2oPtx/36oUzqJ?=
 =?us-ascii?Q?lP1higD91lOvyVaNkKQc7u1s0/UsSYKlaHGsQPEfXe6EWauOt9B3giNCByhe?=
 =?us-ascii?Q?FvnIVaY4sOiG90heYW6nMyRuymDLLNalZoFl?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 20:19:57.7018
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7b5d20e-be7b-438a-3f35-08ddaab7aad2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9DA.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8692

On Fri, Jun 13, 2025 at 10:45:22AM -0300, Jason Gunthorpe wrote:
> On Mon, Jun 09, 2025 at 10:13:29AM -0700, Nicolin Chen wrote:
> > Sanitize the inputs and report the size of struct mock_viommu on success,
> > in mock_get_viommu_size().
> > 
> > The core will ensure the viommu_type is set to the core vIOMMU object, so
> > simply init the driver part in mock_viommu_init().
> > 
> > The mock_viommu_alloc() will be cleaned up once the transition is done.
> 
> Note the addition of the missed s2_parent store

I am adding a new patch in prep-v2 dropping the unused s2_parent:

-------------------------------------------------------------------
iommufd/selftest: Drop parent domain from mock_iommu_domain_nested

This is no use of this parent domain. Delete the dead code.

Note that the s2_parent in struct mock_viommu will be a deadcode too. Yet,
keep it because it will be soon used by HW queue objects, i.e. no point in
adding it back and forth in such a short window. Besides, keeping it could
cover the majority of vIOMMU use cases where a driver-level structure will
be larger in size than the core structure.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
-------------------------------------------------------------------

In this case, we don't need to assign mock_viommu->s2_parent here
since it's a dead code. The HW queue series will assign it and add
a use case:

+/* Test iommufd_hw_queue_depend/undepend() */
+static int mock_hw_queue_init_phys(struct iommufd_hw_queue *hw_queue, u32 index,
+                                  phys_addr_t base_addr_pa)
...
+       /*
+        * Test to catch a kernel bug if the core converted the physical address
+        * incorrectly. Let mock_domain_iova_to_phys() WARN_ON if it fails.
+        */
+       if (base_addr_pa != iommu_iova_to_phys(&mock_viommu->s2_parent->domain,
+                                              hw_queue->base_addr)) {
+               rc = -EFAULT;
+               goto unlock;
+       }

> > +static int mock_viommu_init(struct iommufd_viommu *viommu,
> > +			    struct iommu_domain *parent_domain)
> > +{
> > +	struct mock_iommu_device *mock_iommu = container_of(
> > +		viommu->iommu_dev, struct mock_iommu_device, iommu_dev);
> > +	struct mock_viommu *mock_viommu = to_mock_viommu(viommu);
> > +
> > +	refcount_inc(&mock_iommu->users);
> > +	mock_viommu->s2_parent = to_mock_domain(parent_domain);
> > +
> > +	viommu->ops = &mock_viommu_ops;
> > +	return 0;
> > +}
> 
> The patches will read better if you add the call logic for init along
> side alloc based on init or alloc ops being non-NULL in the prior
> patch and then have these driver patches replace alloc with init.
> 
> Duplicating alloc into init and leaving both makes the patch harder to
> check.

I see. That will add an additional patch tentatively supporting
both ops.

Thanks
Nicolin

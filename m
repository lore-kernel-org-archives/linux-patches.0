Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74166FB8;
	Fri, 15 Mar 2024 02:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710469509; cv=fail; b=bSUwU9OEhWY2X5GZo9sCwe0DciiUONIt2keyzgYLRLEAGNYxB1Qu06TF73DWcZ1VuLriUrMdBLS50kQTg4C2NjW30MXMzK364SuHJQN6j/LllIPOQZY3htbeRJauG1G/1ex5hSr+O9RhmfXfcjvbrzW0ebSclwafH2EgfbtQ1HE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710469509; c=relaxed/simple;
	bh=Lu0C1dZlJM+12sb1HkPDu+UKk73+j8Jg2Obir+ef0vs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EDwtAuuiynT6GGXgQqTWW5cUw9QTk8iDr9h++VSBIWPtaNaGtTTeZ4ohXpla1DF+TYOWATa26SLS4sr4etEvSCLXZcFtOtGScs5rxK2xQFGrqGJj+XbIa/gZVT4kq4eKf9RV23DRebvcaxmQaS7kty1PdizQgU3fbyInoTaqTII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KjzuUNY5; arc=fail smtp.client-ip=40.107.244.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KjzuUNY5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XuEy9r/+FSAdc6WSeSYPglyic8zJj0KB9mJmu7ySpas+SxZ7U7nTg/nGsGZHv4x2NMENYHko39bu4acW2SoLtoy3uwqWde0aFpeTyiB6OgMvBpIgLZPGB15mGi0FTYfIbL/EX0s6YzttlWzeI4bNqbO1WgbIMvg4yVKBzCPBqvjD6xcIn+CIIEzJtZdAPWdTHwryK6ojowuwkCqWvRflgR+6CkzfN/OGt9EQ+LE1rsW9uQ8V0gjDRh9DCUdmWqH1HA/Boq3ypNY1qvbAgDAowDlwIV2N3i8OU/5sK29GvBmOODLTn4AdNEJcUe/gtCKUpgzwHNKGkkhKD4UPoQvVkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bhMP0IVF6JwXTKqioNF9krWbmsyp1OHLvPkSwe13PcY=;
 b=cDnVnEYE9f4OgSkIZDn/QGjsHsGFcx0KatsNPeqnqSoMXcwcypATt6XXxjZoGOkzM5R0S6wf0neMg4o996D+pbTMB3ENkoLZaZuteCE6fJ7keijwO9eNzSj9aCuulBMeOkABqCBJi3ElD0i8T3Ck7XpDc5rFMRxyW70cP4m6Wrj7LbYXvYTcwUXS0BhQeHtiCvs/aWEPNHH70A/APJapdHWuem2JSvYcC+Dhf2vddHr9m+6wvxdb0TorHZj0WbXxeRk8XolLJGyBQ3cgdsYt6mYRo+zU4l/ZBzrJ5vcIcVq1dvgcz+gq9qVGUUW+rgKQk8DfdzLeIihs63jL/lRPaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhMP0IVF6JwXTKqioNF9krWbmsyp1OHLvPkSwe13PcY=;
 b=KjzuUNY5nG7MaBs+S+uBsWCk1nF9fK6ZSKWyxVms5Gt+DJbCuoYl/8QB7OlmygzhlycMgHt1IxAT78xP2CjAbY3p9DvZq/pnqvbl8xqBJJMPmp/6H+VmzZ7vHalHLW8E7OA6Z13BjqnFXjnth9F8nf+t3bY7tMdlCrBk2AZhmf2KxE1/Z04xnlBPptttvhU4le8tabnW95Qdef1thMSsZwwwno+l6mvmycgQUSQf0aBfv99dEu1VDBqbMzoewY3V4q1KdrDmlHhzKYqlrDG5lVnb9YwzWU2QOScfzgiQTNpHB8g65KqPqNlwXdL2hCZonzyyk5XS+9QhU04/jVWP0w==
Received: from CH0PR03CA0238.namprd03.prod.outlook.com (2603:10b6:610:e7::33)
 by DS0PR12MB7777.namprd12.prod.outlook.com (2603:10b6:8:153::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.18; Fri, 15 Mar
 2024 02:25:05 +0000
Received: from CH1PEPF0000AD76.namprd04.prod.outlook.com
 (2603:10b6:610:e7:cafe::2b) by CH0PR03CA0238.outlook.office365.com
 (2603:10b6:610:e7::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.18 via Frontend
 Transport; Fri, 15 Mar 2024 02:25:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CH1PEPF0000AD76.mail.protection.outlook.com (10.167.244.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.12 via Frontend Transport; Fri, 15 Mar 2024 02:25:04 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Mar
 2024 19:24:57 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Thu, 14 Mar 2024 19:24:57 -0700
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Thu, 14 Mar 2024 19:24:55 -0700
Date: Thu, 14 Mar 2024 19:24:52 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 02/27] iommu/arm-smmu-v3: Do not ATC invalidate the
 entire domain
Message-ID: <ZfOxdJ9SpqMALU6s@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <2-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD76:EE_|DS0PR12MB7777:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ad2a283-a775-4f7a-58e5-08dc44972022
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Y1vb1y2GusN33AroV5pCkm1qsKyUMYdsrvrh1zr4/CDtGHoXkVV9kXhLBeSqvgP4TKj/fWKq4HYjpxbGBOPYeBammswkilJ1yfDY8YkbM1oaKUS0i6h7UGusnkObDXNmBPpAd05FUREp+wwx2y4Q2NJhnQvrVqijsIPgrQDwgu8z6vUFdz/YCcAXzWy16yhcjHxjdauayD/MRGl2irC01t9gajsX2/AlnzYg3cVfhCcqE18TQvc96b279TElXxhei/BSWjiAL0+SXl73nCOchgmUWpKzCQ4drh/djo9nHCOkCgtG1REahhKI6G2X1tPx06d+vX9QxqGh13VEl0DHCJ5f8++XBHm5IytAqvoTI5AtGPjX7rrGx37sgrHeZvFBczndzaWXg65f/pi/mhKgCIlLhvMB9swnj4i+p0Sv4iENIfchEgJQyIGYGULQXWGG1ZZyzpiGmu1YbDvPp2WEVTMW0ogig01wsRX3axA63Balsv4VkzhL9sWUVkdTs6ss5RM9AyB7lrYPW1zl2A86HVJiTut0MYqKq/DGQNCxAWbgD3wW7nwCf60v1VgnNtZv+d/BzIrIM/4OwwMBzEhWA8LznNVIEWLTj3EQaq6caYZAfWZzAziSzkiT4yTPjfwe1rz7vH0cDOiNL0L2d6rS/U9yPv0BYekftWyWXDw4HbrJWioB5ONFN2fK4HWWWnJV668TrrJtO938aaQxG43hsp/ZMMxqxJ65kSIu0OsH7eIIH5P7vQXQwKD24QdK3hIp
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2024 02:25:04.8233
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ad2a283-a775-4f7a-58e5-08dc44972022
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD76.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7777

On Mon, Mar 04, 2024 at 07:43:50PM -0400, Jason Gunthorpe wrote:
> At this point we know which master we are going to change the PCI config
> on, this is the only device we need to invalidate. Switch
> arm_smmu_atc_inv_domain() for arm_smmu_atc_inv_master().
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

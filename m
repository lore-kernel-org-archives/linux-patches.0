Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2084.outbound.protection.outlook.com [40.107.95.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678B0FC01;
	Fri, 15 Mar 2024 06:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710483477; cv=fail; b=WJVLTT1T18A1AfXyu6rXO8ru7pnflGy9V5RqUJuu44kf6hWdSSbgybd/52E19OLR0W0jldwZBmj3FLHlJDpHCpvh3L1MFoixQ14TTAVwd+m8HYEgTpHo1MIkR9cIlCJzKbh0QJwE+Szjy1AN8j+DyVl6V5U5Fb7wxbJI6Q1dMII=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710483477; c=relaxed/simple;
	bh=CCpp5jBP4rhgtRpst+KBuhV+1kv3vauKh105LtTKrIY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=brZON3xDLr1tW+WRJ9HoLgtRSQJsUBrsH7Gtln1gpKm1eS5PEENqxjVbazcVt3XLL4K5Ie78dyGGoX3cJGdUbCOieY1u8yQfK2MZGn6Dlz3Nnl+Eqfs1O+sV6ndldfd3tnhJ15JHN6EhjwpNB5ALbXeZXJav9kUaA08Daf/1e1c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LuUZKbHV; arc=fail smtp.client-ip=40.107.95.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LuUZKbHV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yb754G8yBurti8fFN8JVcOgZzHqz1rs7VWzLyUdPDlCS0tRYK+ezWFGaD2yhCQ6PKWP1dHVhbWdxDs8TYvGWZGWEHneX2OlVqbNyFjkjzxwF4rQHUG4z29CcYIQ/vIyZ8WAdwC5pBDqKLPf9N+9IQe7RK7mBo5zem38LROVusWATiUB6rRtnQBdkPFHYH6zpj72yU9UHrdncm6HdemsXZuh8KE6IY13IyZWonhAqnDwj2Od9kbCPcruMkjGcdaCvWaG15Z256PVcGWUPMY1hycl/aJcMzTBj+m1/3FSQ2Al9hg0c0wHSIOkrlNvyGAQXEjUddr3P1T+HIq+b7bVE/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AZEHBXQhLRnTO4PpCKwNe1etg2nC1GPYULmBbJqkIIU=;
 b=K9HSnOHde4SI8yrrtqbxhPjA/J/DwNPpDV4YMQ/jQettxPVmM2NQkFiqG+2LK+Cx7t84DD0Jtpv1LyVXtiV1fegVVt54HuMPxlDNt1HMZEs9WLYr5g0790w9wJ+a9UX2vXAdNc8H9OvpsetzdH7NWWESqURlNF8hkkFOZvqxE/XWD+Lo0uebRs9+YNLUEBQGwj8al38/jD4cR5E2pzbpTIUhBAS5dBUjrlzZQ0Qili0TRJA16cpD1L4kscgKsoSa3djaiDk+83a5U0cuvY4t2wcnA69QTbQve96SwuWZ57xYZ2giS6TIvFUHP0LepJOwiAIUvPZQdxVe1OS8oKSvhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AZEHBXQhLRnTO4PpCKwNe1etg2nC1GPYULmBbJqkIIU=;
 b=LuUZKbHV/dPooQq2/vIhNtm1DI/eDlmk6SJaaAUSZ7Qa5z79EHLAhNPEaDno7hssdx2EF2DqblgIJ0Ic2U6W2K3U8NWpkAcr/9jjg7pUsTykmjZkIrEnZOKfnXZgE6uJPqnGb4c0GGJoPNheGaGXr1jHJkGjM5ZGsd8fk6Jdk+duoEdQSWFGa0GVm0CdPWtikPYHsl5yklt8bnQrUxKfnaWoxA9dRIBPsxVUp0WrXePt45rVqEr09+F9T4i7WQEw/iWZT0o0N75+DMVCakS28f+dVlDOVkDTQDvzA9Xfv1L5RO0nIqyUY12NmdXYSmFQ/Yr3pca4ubLSojXQz1+WIw==
Received: from DM6PR02CA0037.namprd02.prod.outlook.com (2603:10b6:5:177::14)
 by BL3PR12MB6475.namprd12.prod.outlook.com (2603:10b6:208:3bb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.36; Fri, 15 Mar
 2024 06:17:49 +0000
Received: from CY4PEPF0000EE32.namprd05.prod.outlook.com
 (2603:10b6:5:177:cafe::fd) by DM6PR02CA0037.outlook.office365.com
 (2603:10b6:5:177::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.21 via Frontend
 Transport; Fri, 15 Mar 2024 06:17:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE32.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.12 via Frontend Transport; Fri, 15 Mar 2024 06:17:48 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Mar
 2024 23:17:38 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Thu, 14 Mar
 2024 23:17:37 -0700
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Thu, 14 Mar 2024 23:17:35 -0700
Date: Thu, 14 Mar 2024 23:17:32 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 06/27] iommu/arm-smmu-v3: Consolidate clearing a CD
 table entry
Message-ID: <ZfPn/KsaPeIpUUUj@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <6-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE32:EE_|BL3PR12MB6475:EE_
X-MS-Office365-Filtering-Correlation-Id: 617ce1c6-971e-436e-8dda-08dc44b7a363
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rbVCmVpZ49anWK7CRMYYKSkUgKPd8D6Q8rkRks9cFhmbvKbrdyPDTNV1AcEpA3fj6YU+XmRgkHhcUb00P1ln4iTc+rmdL4+NecB/TLp1tUKnmFloLrCxp5IHASwZvtEkOFPlkvJ3NT19LmxuYpSEAV5OlqcDYCBEfrhjapVauYw5O78xcnrRf23G5HTlexhrsILG3B+P9KQKnWuoXjtXH2zJnpkXBy+UN21Pn41MSUDACe6tWyTnx48lF80oL5HZ/UhuVz1qzD9Dn7dbfY65cmqwNTXBctYtYUm2G3z6bASyIv8TEDHlOhu4iKJIzMEH723hU2P/LJYPZzuDZcDkw/S7HRWiOhT0L/ShV/2l/swocXTSJDvYHDqXwArLAPaqrBC03EgD8PCrYFIomomRTlQg3zRWiqKQ2bs5pMznVZsmAwrSoQtVWSYv56bfIOU2BZTHx3D7e5fC6rss/soH1KNvlnW02xJT6PyUDY9e6FWchJ2OweP6heoUEqywNUmVt/EDye+w4UgXYRT0QORt34J9mfSLZkCANfeAs65OIJ45Rd6MU8FKv6217Im8NfnvBtr08bcDeJtMtCgoALHu09fYawSIha5f0UdIw4mR4iSDZVeN5nHMPZBR7/rCBsu8uSWE1ArVthHFfBl9iRA1jQw+AfQc6u2xn7EByPIArg3KRYBCPdLN3U6VsaUVhgXUHA5LF1oTcNcWstLAPpUs0ISUct3Kw5J9UvD/QQgE1+tS7F50zDlTvWUassYJ5pkb
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2024 06:17:48.9626
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 617ce1c6-971e-436e-8dda-08dc44b7a363
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE32.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6475

On Mon, Mar 04, 2024 at 07:43:54PM -0400, Jason Gunthorpe wrote:
> A cleared entry is all 0's. Make arm_smmu_clear_cd() do this sequence.
> 
> If we are clearing an entry and for some reason it is not already
> allocated in the CD table then something has gone wrong.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com> 

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

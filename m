Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8799ECA4E;
	Fri, 15 Mar 2024 03:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710472361; cv=fail; b=tnp8oyv+pJNxgkyfhGDaOwr5C7I9jMNtccziYYD5t77+gqG7MpWwtK+zERMw0LG/43dTGzKJSyOXgTTMpuRl5ECTu0v1BxCC4Ukc0NShiDMpSX05fLM+rVVKtEtYhMSOeA5xS2aTCAU+NZ/3zDZXD40lEt6KSYgcM3xkyqTNa2w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710472361; c=relaxed/simple;
	bh=JDilnABf5kF/owx39hSoai/X/qYrm/HbdrIQwsZ0WyM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AgYCWWyKfmwyHh1fG5faiIGeInN1mUxEk//TjimohWdZRTPPKkPXPVhWvGV+TxN/+265gjNs2YRnk2ZA4STh3IuFhce0umdAZrC13tKPDrQgFNzm0AXCNjG0YnpzEPNBG05OzqQ4YVHJWokh+2l2sOJxRXXhBzRqPN7FVREreCE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RMkyT80Q; arc=fail smtp.client-ip=40.107.94.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RMkyT80Q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iGF612AUbrvd3bRzs3T+04ZmWcGKBh/WEK1QGNHvtNbHYR79s7QXXFgwYZtg6PtQ/ZLYSTj6mQVim4l+5aQ0s24bV0uzkl3OSQAWM9vAZg9MT9XoDso4hSTQQ/vGVAKCBzb9qJRWALhRzD1B1f4p3N+gqWMbG8bb0Ytd1aOE3plJ8clh1NDsgkRTugpodOs50R92CPYv6DkNMTXh4K8gnGs9lw0Z3P0rgXcH9qBJzNm0VmqqZ42lWi8zM3ZN6jYrZxiG9/taI6FRWcPWLuykYUQZZVAsQfHPkSFA5mUr4pWJ+nwDwxqmojNhu4znVCkzW9xw68v/PBQUUcewX1aTfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ek7Me9bEJWCQS/G9PnCzBOL2PW/VikllvqZZZ4oVDRY=;
 b=bl5KlIVk3/qsYemoO35qBD8IkqBC/Id54BzvIqNHovnAokTR5KO82IopyE5bXvIsus0GWxM2gbhxQJ3/IfYAn0ymbDf6MZkmZonESJ+36ylL3bqk/6DBpFU4dO/J6y+nOzbxfkO5CEhuk6+L1wySI5uM1pw/DOwFZ6KQsx27L23rP+fyL1FQjFj9zVNX5ln8+6eYEOevDGDGfQ5rvPTB7KGYijWnMiQ0SMnBeapQ5QDZXhWJrw+liVqnDQCZ4NtPqqVZNBGrdHksH+jqXkYMm/z7e8NHS8jln5i0TmvFo/E8bDDSe8ZqLzlfOzzpT/F0HbPMyIJjLYb+90TpIxuCoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ek7Me9bEJWCQS/G9PnCzBOL2PW/VikllvqZZZ4oVDRY=;
 b=RMkyT80QAFozugmVasU7Vh5QYULReZuJHOgx+DqYyzjLz0RjJg8ndoBbmne7LAx4ctDeu0osqh+HeKZUhdHhIS7/3xqlR87Rl2BMlIv4XOdtNkL4X6dvDrwYZwYG9Q9EgL9PAh1tlFCRSk8spD25o3sg/pymaLdFygIhkXbm4/BKURVwNMSKDCk+oFKITVbqwaiKKSmbASvkj6CqRT+3EskDymfBZu6RVPdqTf1sI2X9fv1+D+LFHFx/z2fWUuFtyjjUWRxJZ9dFBcoazjGs9UxoJhJep05ldGN/jKgX6MeFXvxGsrnb7+oBVYrIS0+S1rXbhYudnQBVFWe0tUrErA==
Received: from BL6PEPF0001640C.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:13) by DS7PR12MB6358.namprd12.prod.outlook.com
 (2603:10b6:8:95::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.36; Fri, 15 Mar
 2024 03:12:36 +0000
Received: from BL02EPF0001A0FF.namprd03.prod.outlook.com
 (2a01:111:f403:c922::) by BL6PEPF0001640C.outlook.office365.com
 (2603:1036:903:4::a) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.20 via Frontend
 Transport; Fri, 15 Mar 2024 03:12:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A0FF.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.12 via Frontend Transport; Fri, 15 Mar 2024 03:12:35 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Mar
 2024 20:12:19 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Thu, 14 Mar
 2024 20:12:18 -0700
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Thu, 14 Mar 2024 20:12:15 -0700
Date: Thu, 14 Mar 2024 20:12:11 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 03/27] iommu/arm-smmu-v3: Add a type for the CD entry
Message-ID: <ZfO8i4KDoScBkTDc@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <3-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FF:EE_|DS7PR12MB6358:EE_
X-MS-Office365-Filtering-Correlation-Id: ef47c32e-c6a3-4894-dfde-08dc449dc398
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XgKLX8aTXNj2RfoiwxIFIWWFJjd9bICeKdzcMGOSNO79pMqnf1GzkW4eIeJa0YKmSPy5rbF8Dm9cOGUX3RBvI55pkcOHp0rzm7GxDHHAvi1uy2jPta5OLLC1k5GG+BUJCgr8IDcE0N0QJCCyAU8BdTTyoVg5TPStsabc4DOnt+xMowwAIlrFh46MHb5QBko7xn8NEUOQoos/2XAhkoFBcTY7at+vu3WbwxM8UTaY7VeXlnqq4pFuyxqoouXKGCg3g9tkg8oaQR4ZlFZ7bFhTbc34Xe3OYJqY1tCHK7FOdShwkvxDpvXQ/yKSGOfMTS0XaRjUX/jOzrMuBtiw4tlnV3kAOZPegCrkTQHLqFbhwNr/eAly4JDfCTS4/FsonT0siFidqVSKjQqi266SDrwdt2s6e3nwVp4eich1OWKXRulplAIyTfK5jVGRti+R5KkbIMhJUxj+cG8ug6D+LASV0OU9bwS+dO8k83AdGyhRD0vQ9AZ2DzWXxQk6qZPWAT2078YWgmWb/saYmI1TQCC6rSmw9Zx002ZdT3RKjom8HmXeBMnSDIeUHG1jT1gtj5JSKAixB5DQ2MpTPyjJHGWQKDzzXfbVR9DLVeFCZFai3oW+Ftaw4CC7dA8kCf/ggcwhKPmEJCthKt+UXifPRwc1C7BBMQkDjdo0Ow6oiyFDI9gygNTCZc7tdAkKm7bc9o3yCVg55xboU04KWSQbGcZDJOtwj2fsAlODIVDuilx3nU06iHYf6IpVMk+O/qqLOsWB
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2024 03:12:35.9866
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef47c32e-c6a3-4894-dfde-08dc449dc398
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6358

On Mon, Mar 04, 2024 at 07:43:51PM -0400, Jason Gunthorpe wrote:
> Instead of passing a naked __le16 * around to represent a CD table entry
> wrap it in a "struct arm_smmu_cd" with an array of the correct size. This
> makes it much clearer which functions will comprise the "CD API".
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

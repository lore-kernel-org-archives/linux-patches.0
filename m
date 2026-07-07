Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010016.outbound.protection.outlook.com [52.101.85.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10C02DECB2;
	Tue,  7 Jul 2026 21:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783458493; cv=fail; b=bOEWFWr/bFikh6V+1ilQ0inh6B+UXLeXvMnKlf5Ma1pJEDS72h3oS7NVo0tVSLXyMKO37EcQK2fe0AlILvG84d3kqJRpdn16TzieFkGr4KFJ+8z1paqJ7upl7sEcUQbBf+QBmv3zWCJWMGibF1RmtU+z/3IuDsaET43cmH5ub+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783458493; c=relaxed/simple;
	bh=uJGOkSoDy2p/cHzXD9GzdLn8wdbs2XeWY9ftjO0LWSM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cD4sF99RCW9SbjMlhp8s8vookIMG+2ksd36YQmd/2TAjjYl+6gJGpyTdkxMjjaitsGcKRp+Z/DGh9dh7k4WoZGqGECrG8EXjK+9vTuBynheuIcHP76VDIgToQl8tV9AuE1sdc5p/O3ZVxyNXhFKeHXJ1HL5MVQDNvTyxFlRZ86c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LOKINMY6; arc=fail smtp.client-ip=52.101.85.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LOKINMY6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xj6nuNAEhrxBXzw9kgEgWOsdjTu5zJ8W2jSvX+wO7O2hUgtKDHUl+hEVnJrs0QurGKFgzzPu+PAH5FZ3zyKXmOGELYKhmQ83Jc+QFo/FZLYxn73WwTl1xE5NMLC+YTszxVQZYmYVUFwsytt1P0uOvAzsg5NCCnYTpqfrS2gIyORW0a8llRQyQX/+vPNv2SyCOD7KRQWZ4g8Hgb9dzHDH76n7uSnRCtSOAIyhB24dj9AUuxIOjMD6MGHDFfEpzp22ZBJJpzvak23RS1eHp7NOQUoQzw6lAZ2GLcBab+TVtf53V/o/eVHYqCOVGpZSRJi3xVcD0sJ1WHTInsBDF4tUOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0nG7gmJkL0yGHZL8B0+yNNQi6iwQ51USIU/uuQVCr8E=;
 b=Q1WeOcpzE55EqhI2TINqgRh1ibhmtE3vF4S0XgQVT/lYWnwfN3XAtf473XWU1s700x8PKxjgFFPcetwgGmV/q9k+GekI3Pu7KXhvXqTZjbfyp0YN0jC12Z/yWuiBLWsWzETnvGr6xO2+6iM6V2Pu0cvT3xFGs2BOlDMMZ9Aygl9jKsrYL4qvHyst5C5pYByqWX4Xp1Xm8G0/SCVRyyP+otlKp8jwtBsG6x15tQng8s8/0KXgL1PPdiaEfJ0GIbkdIU5D4G3/0mQGE7I67WtDKNnAVB+8hDZ/SWDyEUSbqV3anEeviWQFQcI+2CCLQ2cODPjq9fV1Gri9bjU+RMIuYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0nG7gmJkL0yGHZL8B0+yNNQi6iwQ51USIU/uuQVCr8E=;
 b=LOKINMY6LeWdDkAJWy7MQfGr/cQYC6aRStrLxt3IZ5GFPPPThBn0lTeRA9V+jM0jDxeyp7lMU9Y24bp5ISdb5zoYp2wPjaZsmtZBBGBeWZ0LtZfbLfTbNxz85K/16P4lpb+uYBJhc3+ifsP+X5gZCwQYpjVTzmxiVcTFDpmBZOa6OWdsePuTByNNdZlMqNjDhwIO3phqy512BooIOTYLiY4wFqr+mLUpkC0YBnKUgzuiObqlS73JKzkFAw3DO773KzSf7fFLY2qVTxf0zUXqjKV37On3kEnKo3s7M0ce6stWy2GdbJ3cR71jj7dQHCFJ5c688PGw+LaKQjQYXrup4Q==
Received: from MW4PR04CA0120.namprd04.prod.outlook.com (2603:10b6:303:83::35)
 by MW6PR12MB7070.namprd12.prod.outlook.com (2603:10b6:303:238::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 7 Jul 2026
 21:08:03 +0000
Received: from CO1PEPF000066E7.namprd05.prod.outlook.com
 (2603:10b6:303:83:cafe::20) by MW4PR04CA0120.outlook.office365.com
 (2603:10b6:303:83::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.13 via Frontend Transport; Tue, 7
 Jul 2026 21:08:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000066E7.mail.protection.outlook.com (10.167.249.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 7 Jul 2026 21:08:02 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 7 Jul
 2026 14:07:44 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 7 Jul 2026 14:07:44 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 7 Jul 2026 14:07:43 -0700
Date: Tue, 7 Jul 2026 14:07:42 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, <patches@lists.linux.dev>, "Pranjal
 Shrivastava" <praan@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 3/8] iommu/arm-smmu-v3: Optimize range invalidation
 for latency
Message-ID: <ak1qniAsNGNu6ksR@Asurada-Nvidia>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <3-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akyqH7f5h42wru8a@nvidia.com>
 <20260707191329.GC226829@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260707191329.GC226829@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066E7:EE_|MW6PR12MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: af4042fd-7b8d-4c7c-d50e-08dedc6bd52c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|82310400026|36860700016|376014|7416014|1800799024|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	9J4lAj10c0RWOSvTu4GtaJ12chWeIPHTpcLuxTajdPWXCLMg7jV6QZZbNGIVui34WqXonfnluC+8EkkUshWdeIeUxrn4DCnAniU6aknxvgQKqE1C2PKy6TfnG+IT7OFTZLFEhFrYvGevGmzI2f9/k4ygqDuYZfH0hDd7pIsMt+RlqGNFBVuGVPah7+0RKnOYv6JM2902oA3bDoWEOv8ZPsDuqMsq3PkKGD8FcNDnDXsd1eEBaK+Vn7p9w1FAlN3dehHDCi3ol96Vor9il0dDPRI1JOdkdeLaoFx+a9U+SvJ6LYyw3c00Y/NLEyl2ixoS2vFoKdkU3LHUL5BCmQrCdyYjJdyaX+j6Jvr/IWtHoz1aIcENOhrRAgdT+j06Cryz807VdSmLdTGHNqMAcXX3dTFUxEpZ1qiO6oYBhd68DX9Lqn4q8WcJbu6+O1KCKYlHI2YLsy1ygNx5G7ziFJDItbNTWIA4wSJ+WLMLKrpJltulPqHuDpuAgiJXHZOZnHlYldy5KVEN9FvDsOZRpehlk76mIXyBFlQhWgItha20fY3bEodFRRC3pycd9mxgZ2VSgHz3qVunnlzn7qdGZyooCwuq1gykIvdXNY7KypzzMq0KcqMp9QAGrjkLk9enm+ZkJ7kCFrIb8PSVCh4KJTNh0uLZBaTB76FGjWwp0zUDaYpq3EOH8KL3DNsIVmp9/UOr
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(82310400026)(36860700016)(376014)(7416014)(1800799024)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	B1OZjVB9/xJtaDUqqdHbw81qyUwwMvrDVrs07ujm0IZmtBNYSGd+6CMjRV5+ytVxf3d+LTGqaUEy3mHjQYuvsqmqwjUHkgk98s9joEZ+sl+frrh2K3S9T8Xt+Eu+q+FZT+NJy8f6pNHaSlc4u7+h7TrZJ0NR4drqkiJrsCNVnF0zDHQv1WBwcbETEhXQmIOCq6QsJOkIVOUxP/KFx20cSY7h8baO8J5OhRCdDHCimsuvdEnxGb+10cRuzDMN9bVf5ZttIlIDiKAmPsUf/0HWDgn7O5DSQd1b6kY6IMMxKfweCwFvFCVCjPdX8M0BSP6gToUMmUX2UpPyEBPR9ygry5fxB+kOCMcTzDGfiVHtbcIQl0Hf+x3QvvrLPI5bi3IG81dD0mDm58jjSpEqRhmqFNSm0cPzmTSfvTl0HhSI+jPcXaNPWgUxh5dTCo3j6zha
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 21:08:02.8383
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af4042fd-7b8d-4c7c-d50e-08dedc6bd52c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066E7.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7070

On Tue, Jul 07, 2026 at 04:13:29PM -0300, Jason Gunthorpe wrote:
> On Tue, Jul 07, 2026 at 12:27:00AM -0700, Nicolin Chen wrote:
> > On Mon, Jul 06, 2026 at 01:26:40PM -0300, Jason Gunthorpe wrote:
> > > +	/*
> > > +	 * There are at most 5 possible values for NUM based on SCALE. The
> > 
> > Mind elaborating the "at most 5 possible values for NUM"?
> 
> Oh, I guess it is at most 6 since it is +1

Yea, that's what I thought.

log2(NUM + 1) could be 5, 4, 3, 2, 1, or 0. So, totally 6.

> How about:
> 
> 	/*
> 	 * The spec defines the invalidated range as:
> 	 *   Range = ((NUM+1) * 2^SCALE) * Translation_Granule_Size
> 	 * NUM is 5 bits, so (NUM+1) covers 1..32 granules and SCALE scales
> 	 * that by a power of two. We must pick NUM and SCALE so the range
> 	 * covers num_tg granules, i.e. (NUM+1) * 2^SCALE >= num_tg with
> 	 * NUM+1 <= 32. That constrains SCALE to:
> 	 *    ceil(num_tg / 2^SCALE) <= 32
> 	 *    SCALE >= ceil(log2(num_tg / 32))
> 	 * Choosing the smallest such SCALE gives the finest granularity and
> 	 * thus the tightest (least over-covering) range, and equivalently the
> 	 * largest NUM.
> 	 *
> 	 * Unlike other IOMMUs the spec has no alignment requirement on the
> 	 * address beyond alignment to tg (so long as TTL=0).
> 	 */

This reads good to me.

With that,

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

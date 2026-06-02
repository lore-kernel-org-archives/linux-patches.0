Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013059.outbound.protection.outlook.com [40.93.196.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB8430EF95;
	Tue,  2 Jun 2026 07:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780383986; cv=fail; b=D5zAuBySOTsa6204PCEq7Mwe+8YXK1lSiYz3u20olcyiFRDKdP/P8RqiVadXIsNs/IO4Ie7rrZQ1sPJ+DPsJC+7Fj0kjY1hMeAwSYQAMRHDsLDt1BK+fKKyorYRC0mCAJeHPW7kUFIzMfKdOCAG0oxwFRpeVfc8AVTmGgOMPths=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780383986; c=relaxed/simple;
	bh=DKB7XzYHXljFTj5oMBx89z8C6jWBwwz1UqvklzvGfe4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=cBv8nH5OzDpzN6u/MjKA+g9Kyj37WydyCFg4qJDg2djbfzKnyeI++eedq6k4VYtrmeKJwRNA9IH6dBQbKDGFmaN4vPGCJ0H/ln2FKgwwZBF1zFDk2TdTf0BiSCoG8UC2kjRd5+84ikhHxs+7nD+idUsNF/76YdILqzd/dmeNouk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Vt9pjTbt; arc=fail smtp.client-ip=40.93.196.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Vt9pjTbt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q8uWJPEVna2XebEtMGoxdxt4S4js9dekMVu0HomY0U/aI9fmF3vcqj4ep++Z1a5SeNCmVn+aEkBz1riqItGjXm4uZ7tCLvSUzT0pf+vEC5qgYmh7RiAI9Q+neoBvDLSM0z4culwCoJGjwyvxaPkF/xkoYJUInaXLqVIKTV1MBwtqebIy1UmzYpzXDAVVzrBObjXQm/EX4j6f41EJM5hg+NYGZ7ekyXta3BpTokm/mv7LB1vGuU4ffJEpx8d9cm+JCC6424mBxbDTQuVeyQKctZXCMfVKuuduIoyCdVP+1DxnZU+Y4H1N/zuBfCQxHLQLwXeObJjIe2M/SutfOLkHwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OeFKAAZNcV8EVICRTI2iw7nyr7QsUq5aTeHTTRiP0q4=;
 b=xPiNVRU9rTF5OsHoesbDUER/FNDEf0eARTx+Jlj5QRfZGNPvsMBKqupGKqIvCjzGhS6abR9mIwBZiU20ubBlOWtv+e3f1VoAe9zHz8Q1vP2J/bvidvfddWHQAi0I+jfVhNWz/9E6i8OIl3Asb+yp49nYGc6UWSL/bZrNQHqADQHpmvFZvgBp3qW962Q9FmD1AEjsi4k+YqleNOiqFzoo35b4ya5gcJu04mVL4OWkC93HjSM5223qsxvX/f9yEgFa7IFuWgi/xtmXTYz/Pk0/2vUFfyfRYIdJ8/DO/GAOLm2HFdyvnTdjU1aKD91Yxi+Xtwv8qlcvhkpGH7qKGaXWKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nvidia.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OeFKAAZNcV8EVICRTI2iw7nyr7QsUq5aTeHTTRiP0q4=;
 b=Vt9pjTbthEmluSAcf/JGkwY2MxzE25YlrWX5drMQ0pgEgMjxO/8oUOBg3nvc4x0QhjpoNCCgUpZqzGtFsfdR46PZvQsXSEBPwyndg7kFasnILLQv3h9WiO373YvfeXH4EhoReH/3vEd2aswCM1jRo3tLq8wdxUSbRwIshdrkBK0=
Received: from SJ0PR13CA0124.namprd13.prod.outlook.com (2603:10b6:a03:2c6::9)
 by IA1PR12MB6578.namprd12.prod.outlook.com (2603:10b6:208:3a2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 2 Jun 2026
 07:06:21 +0000
Received: from SJ5PEPF00000207.namprd05.prod.outlook.com
 (2603:10b6:a03:2c6:cafe::f0) by SJ0PR13CA0124.outlook.office365.com
 (2603:10b6:a03:2c6::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.6 via Frontend Transport; Tue, 2
 Jun 2026 07:06:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ5PEPF00000207.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.5 via Frontend Transport; Tue, 2 Jun 2026 07:06:21 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 2 Jun
 2026 02:06:21 -0500
Received: from [10.252.201.245] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41 via Frontend
 Transport; Tue, 2 Jun 2026 02:06:19 -0500
Message-ID: <83b8a0f3-2409-464d-a9e4-59b9eea926cd@amd.com>
Date: Tue, 2 Jun 2026 12:36:18 +0530
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] Improve the invalidation path in AMD
To: Jason Gunthorpe <jgg@nvidia.com>, <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Will Deacon <will@kernel.org>
CC: <patches@lists.linux.dev>
References: <0-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
Content-Language: en-US
From: "Srivastava, Dheeraj Kumar" <dhsrivas@amd.com>
In-Reply-To: <0-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000207:EE_|IA1PR12MB6578:EE_
X-MS-Office365-Filtering-Correlation-Id: d7cbf806-dd16-4b6a-535d-08dec0757397
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700016|376014|11063799006|3023799007|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	B1f8Cifq+U5o6MBeaiUAKWQ4xQN67ClHzFkqmwbjJvHl7CfGviG3PgoAFTz8+9L6GhyEggm78vkQFDRbCTFUVYWECcJM2QBoRa07LO429o3i3VrvA04RKVla762GkFguCrxz/t7iyykkB6HF+kR06YvFLhMvJBBnBZIhwMG9fE+hzWUNYloxykhMTJGZRg8F5EFxP/I4vZ5lULME9nX41btPe188cyYG/d7iNYMdqRKTt3YuGCGTQbR+itaaGad84zqeltWNEOVzdbd1pdbhAcqVn3qorSo+9hwyBRd80BiapbmVaiMkzlc8aEyWYWgXHjwVWTcG7ZYLakmNd31mmD3YtoaszAgfVBwqNHatDo2B4c2Qx2NP0eHhaJ1zYGpwvjDHml5ixQCdH6HiupXIG3t9l8HKfz/OIPBOJ7D0dYVTgP1eciVLXDCqkCp60yhAbV7hrPTuNwE6nZhPDshme8ny/IcPPHXu4IGR43d2785UBVmIvbh1LJ/NdjKbaCqiTuOb+89arhSCB1Y5KWMvAKf2kRo+AwKJPwryvLErFOzwx1qtN3GYMpcDk1a8AbFAHqOtng4HtTHYy4DHOdd90wFZ0hf6l5ZzpWlxon1Ry+gwXxuzVP0buglYNWOjG+kI+LUd+LgiELHTDrNCkiU4b6DVh+pjBBBGMM/usmp3oTnJTQDogpnbb4+Niu6nmrmukPoMH1cdPMqpRqJiPhXBDcS9GYtCjcB9RRuhB4zW+Cc=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700016)(376014)(11063799006)(3023799007)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	0GLNrSSf5o0z67EV7oY8TQY6NnjTaohzlmzBje3vA57EaojMFu94HeF8xDh6jJf4mZIp81resyMv9b9uUZ+f/Ud+6vfh5dmpiJoc2i92qAL9GxCoVY5WTmkXDzkx1B4wUu3uStdhXvtFgImC+WHwvIG2TgpguFz9ZFBhESX9/rvVuoK/5bdXMf5K6TnC4qpQ1B1ZZycGk2mozkNZ/38LMvgJRZmhOmSa0g51QFbd4ycVwCutNImomHWayqKUNrhtQ5G1QjkOar7Rh1n8H6Ly4tWyr3imJ9kSDTsbjf5t9mzmPzyElyJrpYO4mS26XXCqjQb4GheJsgQn6ZnPw2AiR+0F/0xxhnuHTo0uS5TFjGngewpwuadyz/wiN1Zlt2vS1daazNOkfwEwrSF1lVVdAHzfyPOCrL4m1CRwziBzUb1LdfmHm1VJWnEnabQIrs7B
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 07:06:21.5536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d7cbf806-dd16-4b6a-535d-08dec0757397
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000207.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6578

Hi Jason,

On 3/27/2026 8:53 PM, Jason Gunthorpe wrote:
> Auditing this path reveals some unnecessary complexity and some
> confusion around end/size/last and types that may cause issues at the
> ULONG_MAX limit.
> 
> First, fix up the call chains so that the gather start/last is
> retained faithfully throughout. This avoids converting to a
> start/size, and avoids various type conversions along this path. Fix
> everything so the theoretical cases like start=0 last=U64_MAX work
> correctly.
> 
> Simplify all the calculations for alignment/etc to use trivial bit
> maths instead of the complicated versions. These are all intended to
> be no functional change.
> 
> Finally, add support for PDE=0, deriving it from the gather. PDE=0
> allows the HW to avoid scanning the page directory cache and
> supporting it should improve performance.
> 
> Jason Gunthorpe (5):
>    iommu/amd: Simplify build_inv_address()
>    iommu/amd: Pass last in through to build_inv_address()
>    iommu/amd: Have amd_iommu_domain_flush_pages() use last
>    iommu/amd: Make CMD_INV_IOMMU_ALL_PAGES_ADDRESS match the spec
>    iommu/amd: Control INVALIDATE_IOMMU_PAGES PDE from the gather
> 
>   drivers/iommu/amd/amd_iommu.h       |   4 +-
>   drivers/iommu/amd/amd_iommu_types.h |   2 +-
>   drivers/iommu/amd/iommu.c           | 175 +++++++++++++---------------
>   drivers/iommu/amd/pasid.c           |   2 +-
>   4 files changed, 87 insertions(+), 96 deletions(-)
> 

Tested across multiple IOMMU modes; no regressions were detected for 
this series.

Tested-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>

Thanks
Dheeraj

> 
> base-commit: 6c8f61b36b7efec0f8bc284142f998d30f0a28ba


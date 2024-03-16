Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF02522A;
	Sat, 16 Mar 2024 04:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710562594; cv=fail; b=DwKIJsQdWFPXmAumKj4VR9tVeMjRRjhuMN6kF7GI+nHvFshltpiU3LVtuetQkEY//bdjxAd7HKNjT5VpKUQpDNJP50djujVtzKePr0jwAetaIyH3JPl1gGTjOAqaDqPDfu4LtLvA7Ildb7UIWH8vsGB+qVkfSk56FkWOvSvFzas=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710562594; c=relaxed/simple;
	bh=0x72z0PZgy4NyFOwgWKxfoiw5ZhmSq+0tWADkuGhkyc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MsueACsAE3O7d6UMaoOCosbsn8PuTKDQX/jBS+AmsMUbb747jvKvbawsW8InKsd3fRcVg/hlrpt1jop9zb/8/PjO7BJVAIoYguU2TbVJYJ7U91RV07KUByCc0dFhatOqVzcEg0gZceAEmZ7CFK9+K35Qs0s7Gd+k2/3XhZ1vAGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h7K94Q+M; arc=fail smtp.client-ip=40.107.93.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h7K94Q+M"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPwVIy5exuFX1u6rQxUVCaWZJkDedIRVcmC1Vj7C2/h9YlhD7oDtw7u4nIm9+lgVU8YVW9dYkgE8Gfiycwuseog8kA6Eo0F12La3i+me5Nx6cOz8XCxLVuO+eHd5mxLZcUUIGJWsWJgw0jAQ+dm7sNiScpcZM/auUuUH3xDE/8GA1MNaIVt5Kd+30ufxT55yyMA/UsmNjVpbhgRZ2gmTShMaes/vMF1O/sDswqhQK1wuClkX889FSgEfypDT/VF/jA62ng+B3ukeW5/5n0dEH1y57xtZIIGdzbWTTmDdRPtUSuLZW65v6NllGaQZrUrE6vMOMM/wKcqU6YAvj5yg3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BplsbOZUGF9FvN6Xl7Fg7vKbRf8Gmt69K3uPRkSV5rc=;
 b=iwxdYZQytxLBLAOFqLMGVyZZmtu/SWtYACOSEmhqe2eJu3hbB4brL6OhSyJ49TIXo8+CBsnpk4qGASrJKRUtyC+kALdSoU7fm7kEeUnepSSrcSMIYD+tGt0x4iKA2KM0g7A1SXF95DhKbuHcODxqdmS9M6XjCX4OOJz7B4gopZZ9XAIJct6MQXK9+x1VrXVYue0SqO0KZ+NV5CjCTXTC4il9Ibpr8TB1EpttSWFbBHhAjeRxAdi+WhYwz5ED+0cgYG4FK4aheRDykqjyUOKiH+j2YoTIv6dox+V+eDdpxiRMnsnN07gqfsPO7aOWfuvu6bUrsvzRA+AxBntVfKdMig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BplsbOZUGF9FvN6Xl7Fg7vKbRf8Gmt69K3uPRkSV5rc=;
 b=h7K94Q+MQjT4QTfBF+0dvZeA6+EK7synR2fi5kmpkzXheN6Fxr0xbxQCLtgAkmPNlT4rFKl2brZIiNP+QfM0UR/RH75OMQ5o4gH3pFSdqOjZTw/5XdVtzZCNtmWrOa6FPypnbjNnNqUqMbL6OVqj8RXl4A6Y/NoU5DP2TT5S/PHZVdNlLM45ZDsHV77IYQsl1F3O94ERR+DHZBTLl2y3gUGHs44VEuE80bllkqIMSDVywXAHvW/+AmxquEdGwtipfACLymql2NN0jZzm8UfCpdhw4Rng2Q83U9Y/DMA+PJKi0Zsu1NMa13udOzRsEzm1+5wtRu4mBWsf+nG9ASPujA==
Received: from CY8PR12CA0058.namprd12.prod.outlook.com (2603:10b6:930:4c::23)
 by PH7PR12MB7212.namprd12.prod.outlook.com (2603:10b6:510:207::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.19; Sat, 16 Mar
 2024 04:16:24 +0000
Received: from CY4PEPF0000EDD0.namprd03.prod.outlook.com
 (2603:10b6:930:4c:cafe::d2) by CY8PR12CA0058.outlook.office365.com
 (2603:10b6:930:4c::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.22 via Frontend
 Transport; Sat, 16 Mar 2024 04:16:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000EDD0.mail.protection.outlook.com (10.167.241.204) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.12 via Frontend Transport; Sat, 16 Mar 2024 04:16:24 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 15 Mar
 2024 21:16:20 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.12; Fri, 15 Mar 2024 21:16:20 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Fri, 15 Mar 2024 21:16:17 -0700
Date: Fri, 15 Mar 2024 21:16:14 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 09/27] iommu/arm-smmu-v3: Allocate the CD table entry
 in advance
Message-ID: <ZfUdDpwWYf1Ht4T0@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <9-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD0:EE_|PH7PR12MB7212:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b91e27c-823f-49ac-f4aa-08dc456fd7db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	76HX9uy8I9jtGwi5cUDtJRdfqawHR4+ekvZe11ZYGwL+Lb/y9EiBU0thVMAci/c/U9FhpOWBq/TCnZ5UjU60IlichDCoSPV4g1EDcjQFU9xf2t3nVXgGPBMT5YrF598EXFnP6L8MnI4NmZXmkXNJcC1/nYade4szj86DpeRiCJqHTiw3mBheYp54sCXs0n85TfbiNeugkeTRIXF9/Ka14JnMpEWRISiUxa9I2zu9pKdJaCR5Eriw98hDxNqiJGwS/eNtmtqHS1SPWapp1wwCuOqd71FAGz88vu9+VI1CHp/dVOVj5hs06kG2MDstuDrpMmkfDVA2ZX/dc8qUPOtHes/CFtZ+klq/WQ+a1YN2rYAxn3Vh6tIL2WR2aKFcSLMGvmJicqapljloMO30mwJ8rcSoPrScSWVhKQIxjXtvy1uGRDDT5aOSKM4C1SM7C8RDOiczIqsl6xFkbb+8Twbdpa7eK2JQkUK/aPawx0aI9gzCVMZ4Sevy9Gg44ZMPjAkBlTDROw/HHbzcl6mlY98Yat01w5/QXKvPIuWy4tV1PGajxsjzkvs4hnuYqOrLkEdBzr68/zn9dYH7vrcLHkOaWt0NvzplPoR/oXzcgq/s5OO5mlfLVHACehCHs2lY31WuXpqsumrAtvVrtB+jgErdBcdjvdl0me/6hCpteQST1GLH4vnSuVyzVG4Mg2UjS1y2POgiSylK1Ef8rxRk5Q5kF0ndb+ABeACgjuCqygOBq+LwSVCA9xR+apw+6kDis2EV
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(7416005)(376005)(1800799015)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2024 04:16:24.4033
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b91e27c-823f-49ac-f4aa-08dc456fd7db
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7212

On Mon, Mar 04, 2024 at 07:43:57PM -0400, Jason Gunthorpe wrote:
> Avoid arm_smmu_attach_dev() having to undo the changes to the
> smmu_domain->devices list, acquire the cdptr earlier so we don't need to
> handle that error.

I should probably mention this in the other patch, yet PATCH-14
adding arm_smmu_attach_prepare() to this function doesn't have a
rollback for CD table allocation. I assume we're fine with that?

> Now there is a clear break in arm_smmu_attach_dev() where all the
> prep-work has been done non-disruptively and we commit to making the HW
> change, which cannot fail.
> 
> This completes transforming arm_smmu_attach_dev() so that it does not
> disturb the HW if it fails.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
 
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E15C1465A7;
	Mon, 13 May 2024 06:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715582523; cv=fail; b=RJma9p2X4FFl48xwU53aew/X8mR8z8FRQsWtKgVKerLe+TuMNFUtk+aVR9sr/KPCO+BfIBENIbgY+19FvYsKFUtLlFHi3D9wxaPjQuThNJzUVfoUaGNp02af/BlYaGOrZ89Utdu6psBU6+nNJmnaawNSz0TkKdU/nbxbMggK+N4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715582523; c=relaxed/simple;
	bh=eHV3g320g/5YGPaAXerZXcu9XFG31MMX3ZYGabE+2X8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PdxtmrcBYavbxyIqy8qelndDMIafdKv68/jwvlknW8PmHtoqVo9JpfaV7n3IacsZHVe4cLsCgun1uuplJUGdAnQoWpVbGwSpYtZGMyYDFhwlHyd450pVHeSkVhEb++j0tyk4+TrMeoUHw9ZBHrAV65pdCJQV1Q24fNYTiKvSRcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e5m350mm; arc=fail smtp.client-ip=40.107.93.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e5m350mm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exV2n8KzJgtDxYKj3f9o/ksCA1aLqktQZ6v5cdL7/zHn+BLoglCN4Kb1oBwPQMVOmnw7jpaSRmg/65LKpBVJG2sl1P2n0gBq4TmZ4X+2c+JFRwpxN2eNsfIKG5nxKFYLRyNllxlzUPbd7QcNcpi1cV8lsRuEMtzANCaxa3y3NuzjiIc01YUSh7kik07w5u6T/MDk5zSMOYWFbezdkCt9b7kRjWDw9Y4eL4GBCF2zH7XQNNt6D/v60BCjaQtmKeayN7tOKxMQ59HZkyefQ0qY1I65k3LrDnhQw8HBRiNUHdH7hwjcMmrDRAhzVKkMaE3FCdrkOMGN8/7b8bxYxKskcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AobUCEGNV+KRv12/gkPOz4TG04wBvWsjDNEJ3lW7AOA=;
 b=QGU9p/2mo9jT+y9/TTHVdL+kEt3qY/wr+F7j6rowqHVF11dPYSq1vmfS3J6f2Ad/Gy9qILLsklN1TIzhXyYyM9qUheZQpPq+wkddyx1iAWkNlB38xLVGaHosFG25stHeQOsXVkOQhOftJM5EiKFcXWH/xxr38nihsCGJ8Gv4s4j+cSTcJdaghj8+snzRYLoHsUmBgqiinmMU1A8YAfQoanGRCGyCPnIPr/ULnw7+ehTiUeEqZ40fAu7QSkjIgLTuufMMmIgHZfPJsyAkyH+3rKtSuAyaiFdXEFueWaWCqN5BTJZ/FCT8R6xm3CBXo5HsLVe+UXKsbLlLUmdvaaYlpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AobUCEGNV+KRv12/gkPOz4TG04wBvWsjDNEJ3lW7AOA=;
 b=e5m350mmH+owzsVQTdth5R6QrIhHR2h11zE4UFambGVeNekQGmEYGXNRxr6bUv/sy1DLaDIzqohZ6jERUJRNfh4rwol2RsbZIbSq2ry0F8Un026zw7sYIk7SRT9D053FJ8LDWLWOzA/v7FWtXk/clYr+99V6yCovcC90g3RPD4dpES3OK52Qz+GUR8y0DmDk63EorQlGdxD9/eLKquJljUaWD2xbH8w+uDK8kK01vH4JrbL3ETW69pJNBH4/+u0R3MSCCbR61natcWt9XtucK7ACCiMq4X91aRSwsKPdB+YRFR/P0ZqeIVoYsdtkFIbSl1ugft4kOCT8TElljx1RNg==
Received: from PH0PR07CA0030.namprd07.prod.outlook.com (2603:10b6:510:5::35)
 by SJ2PR12MB8874.namprd12.prod.outlook.com (2603:10b6:a03:540::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 06:41:56 +0000
Received: from CY4PEPF0000E9D1.namprd03.prod.outlook.com
 (2603:10b6:510:5:cafe::5a) by PH0PR07CA0030.outlook.office365.com
 (2603:10b6:510:5::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55 via Frontend
 Transport; Mon, 13 May 2024 06:41:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CY4PEPF0000E9D1.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Mon, 13 May 2024 06:41:55 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 12 May
 2024 23:41:42 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Sun, 12 May 2024 23:41:41 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Sun, 12 May 2024 23:41:39 -0700
Date: Sun, 12 May 2024 23:41:37 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 09/14] iommu/arm-smmu-v3: Keep track of
 arm_smmu_master_domain for SVA
Message-ID: <ZkG2Ibyeg269rBIz@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <9-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D1:EE_|SJ2PR12MB8874:EE_
X-MS-Office365-Filtering-Correlation-Id: f6c6822e-0d67-469c-84aa-08dc7317c83c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|376005|7416005|82310400017|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BnlPfQulaSGWlO3JJoEVhEr3wyF7TpXm9Z9HaBTD0naSh115HwqEnAxpq1He?=
 =?us-ascii?Q?7ryqn2klRjb8WNy9O+aYJuuCymgzg/38Wz06ujm3wlbQHs4evzahZ/OBTeAf?=
 =?us-ascii?Q?jh4bmeND5NrZZBs6QFeyMcln4N7SJwSZ39wD2x5ZB1xwtpW7ykMi5wji/ENz?=
 =?us-ascii?Q?PmzrbCqvH9C3DVDZkM5TnvtFxJXvimHpkhXZUnWB0oK4HboF9IQqP1Wt6WeY?=
 =?us-ascii?Q?EXlthnDfNOdATUP32fpc+eFBPNB5PhyDKLS78pfiGCkBJDUPthr8eBoSfC5k?=
 =?us-ascii?Q?IKPIjYq4N59Q7e5+g1Hfdyew3ZxtuQt/qGPXlmCxd/lq+GXudNJvuRFim+1Z?=
 =?us-ascii?Q?sz8y7/77eWWqtKKr3dZEwK5yDJNZ2LafyaMPNhCO56OVpk9BLSWLn/iQuqnh?=
 =?us-ascii?Q?KblauzQZSLukThC7j4R4UgOnbRPg8zHqc187y3I6HzogAOotCEenKKn4GNGR?=
 =?us-ascii?Q?iR54YR7XdgZ+hp3oUFE0RlvA4N1MBmSq/YLBFlx+yE4JeuMLlNKsk+76oQsK?=
 =?us-ascii?Q?CfmikUYTv8b5KrBwUXe9pc5o9xuxo2TZflFRxBYW3KyPy+OBf7M4QqLza1Z2?=
 =?us-ascii?Q?NrUBtnsu/vQpYVpQz5iqgfMsH1fdIKhZK/3QJIalUZtYPmA2ITA63KisTPCd?=
 =?us-ascii?Q?ZbMvsxphNHgtGv5VGmoTHC5sHr3V+iMrr4Dv6GHtI8yHUCSwfEUOKPtDkml4?=
 =?us-ascii?Q?FlEBDIA4xa0eLWSMvGMWz1uVhVfnyXF7n3co3QfascxBfW/3eBG7fzq/IMje?=
 =?us-ascii?Q?KBQFOvTxttOgkW/bbCz43D8/loqbqMe/S8mS1SVzB7J8XmRB0r/JxoXC9bUn?=
 =?us-ascii?Q?XPagOY3n3IH4zE4G43c/OOZWkC26bHJzjXmtqvgoXIvKa4/Vo4+FuNayqw2e?=
 =?us-ascii?Q?ZIiYAcRSpYfrNHqWaiF3+2bhvuXunYMvfjErjoLuiUeq4LOBKZStZSFlfELN?=
 =?us-ascii?Q?ytRDWXpvkMplh2Igesi/25weVa+JDiBtwaRXKfZGPUQfGUsZawiOyVuqVjCq?=
 =?us-ascii?Q?dReGyZxQ1HW+AidYtcbOpdgz+picdSrVPSvrBHDBDjvirj+Z/KGSm28b40R2?=
 =?us-ascii?Q?f1X1EP3xAvHwtxIHI1yPJSyjsdYlxckOtwlmJiYkugXhdvx6RAj42Ak/BO5A?=
 =?us-ascii?Q?vWd4hS+PJQypHazAoZ4WGXcEWyFrBLMmNTn/JOuuJ/c2vc4hWV9RqeBfLVTH?=
 =?us-ascii?Q?3n0EU2Ahe/qHcFS2qkujRkFMcBnXE0TovE8cKKrUzHgKZRofbH9KQtlcSCIE?=
 =?us-ascii?Q?wGRMB7gKTj5vsTkSRIVVUiKRpx42rZgQg2O+pPjCYm2u9vFLbe+avkrhNtpT?=
 =?us-ascii?Q?iPVKqAoI/bWNNq6f3vazgpkBMfpxZEghbIjz/weRjPQU54ypqKzuF9AT1kt7?=
 =?us-ascii?Q?feCpBmo=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(376005)(7416005)(82310400017)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 06:41:55.9525
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c6822e-0d67-469c-84aa-08dc7317c83c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8874

On Wed, May 08, 2024 at 03:57:17PM -0300, Jason Gunthorpe wrote:
> Fill in the smmu_domain->devices list in the new struct arm_smmu_domain
> that SVA allocates. Keep track of every SSID and master that is using the
> domain reusing the logic for the RID attach.
> 
> This is the first step to making the SVA invalidation follow the same
> design as S1/S2 invalidation. At present nothing will read this list.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

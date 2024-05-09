Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDC7770E9;
	Thu,  9 May 2024 18:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715278965; cv=fail; b=ljJmIW3c+popqhdB5z5Ympnx2nLaw6CgYkywLrfTxRZYDdbNNcP0CyDyALhmdRD8rIWcn7rheBx7XujY8BHWEEdfGNMePnltxpMODRZKQnyBsQHVaf4OXsZrSdSxNiLPMR1UiDFjY5aZ48qkyMRokU0wB25/+NocW40piY44Uq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715278965; c=relaxed/simple;
	bh=Hnv5Yq1Zsnx9SDvCoYzqdXCK5lTcplevzjzdDdFWMAM=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pTlh9dztVqXINP/5kB6snJRPAIh12dYr6Ncr6ON7Q7zPPmB5hYLKoiy/XdAaWHoH8U2ywUx/ykYekNiU8aaXkPPkh13+DdcZuJ2kAFqvkjgeDjGLMQ1cZqx8AthCfUbv/rVrh3ix137V6xMaLMyYmZArcIwgPofZpHNpUAHswzw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HLDo67Vs; arc=fail smtp.client-ip=40.107.223.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HLDo67Vs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzoc1jPdaofZoN0bK1ZWO5W5nRoxjzNxZiOCPKfx54MLD77z/HeBq+ivVyG3TVcD97r7Z2GclTKamzuAAf64JuGIxbtR3nM+VjeK7P0tFlgCn2WQrWeUgmBv/bpBPvK/yldrbfyu5Tl8dAV8oa+WiLaXAxy42ngEAHbIz2+GndgWXnlbikO0QGpcr3NBS2BrVkbPszM5oZpHh0uJWILxxOHpOjZNA6nHvQF46SPv15R28QJDCVPIJEC/g7yFp7s48NLT1yXUgCuk0ApeNhOvdaO4dLsvBwoAchDBph2Y9/9Yc00wdSxP+nlGHFxSROLI4kFRtZCTR0r5H4E5VPl/og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P1diNq0xYl/ebqd78vM8y1xnpBLRozrF1Ya5nYrt044=;
 b=ShUuYIZRFESsmgCt6iA7wmyHHAaMTczESZuyctNmcG91ANl62lv+1GSmFYxdt387Jp7QThT8e65khIW2w/RnHUOWh7/L6OWZrXY/LGvLJnZRJ0Z2lyv+D82jO7NyFfLGpwmnd7Cm76YAU2OFZWKqn+VrytqBfx2Y1oZ8oXO2DPIggJOUwM7TLGSIL/AVFwsCBLWs2qLTUMMzmrh6kfeeyE1ufrO36tWfYU1sSHth3EmSZ44yZWfS2eubm4LFzZectqMAgdMtePob87wjfgmAFw5P1MrojQpmderpRtPSqTyR4iyEVskw7Nguy3Vhr/vYCAFxDK3tpoTuxJwz+m5HTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1diNq0xYl/ebqd78vM8y1xnpBLRozrF1Ya5nYrt044=;
 b=HLDo67Vs1i1hWu4H3see3b9ZFk9N0G+4NowGXiTZvHkmssN/ngEyQvc8u08j8BxX6N++nZFRVk6VjFZOOys2rN5OOHlZXDhAVR8YNTgYO2Iv+aaymSTRR+oK62RuhrTEyzIEi/YVvZF5B1iSomQATLIDir/Ao/gI3BQf/lIqeuP1pwqSY2cQd8BS/SA0asqlwjPXBrrRhZIxZgVqArsV/2pO9zMhw2LsjlWa9XUCqsyuL15WzK3NcnVcF2xCJJ//aMMMmfCw26IsQxNJPSY3okxhG36pBlF+daGWD5xJokhfGd3dwwCIZ/C4yafVe6dIU+NuAEWWYFuE4jl+/SZAiA==
Received: from PH0PR07CA0114.namprd07.prod.outlook.com (2603:10b6:510:4::29)
 by DS7PR12MB6287.namprd12.prod.outlook.com (2603:10b6:8:94::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43; Thu, 9 May
 2024 18:22:37 +0000
Received: from CY4PEPF0000E9DC.namprd05.prod.outlook.com
 (2603:10b6:510:4:cafe::de) by PH0PR07CA0114.outlook.office365.com
 (2603:10b6:510:4::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42 via Frontend
 Transport; Thu, 9 May 2024 18:22:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000E9DC.mail.protection.outlook.com (10.167.241.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.18 via Frontend Transport; Thu, 9 May 2024 18:22:37 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 9 May 2024
 11:22:23 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 9 May 2024 11:22:23 -0700
Received: from nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Thu, 9 May 2024 11:22:05 -0700
Date: Thu, 9 May 2024 11:21:59 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 01/14] iommu/arm-smmu-v3: Convert to domain_alloc_sva()
Message-ID: <Zj0UR0fFH0ruioWW@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <1-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9DC:EE_|DS7PR12MB6287:EE_
X-MS-Office365-Filtering-Correlation-Id: 13e60e45-3543-4478-9bde-08dc70550110
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|1800799015|7416005|82310400017|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q8UmQo/4a3gZMY9aMnKP+FAv4pE5ebbPdQFPDRlAmrJvikZ1nMgFLuww7dzW?=
 =?us-ascii?Q?laqDTMlvV5SjR4KLEXAG9MsOxUuKsYQqBfY5LNjqcECH95hWwOz/Hp/3IF/5?=
 =?us-ascii?Q?84aO9Ib1TX1EAFDbEXIhyAT6DvwUX1iywN5IajYs+QQBX1ZV4X0eYXFQa8Pk?=
 =?us-ascii?Q?uBCopINdO9HHZS23h3EVMui3/bOeSw8MmHlatcCPIcw/wAO7TfEqXuh3bHiD?=
 =?us-ascii?Q?ldRRVVeLVFBCWaXMsp6chSxMeHJOTELwAN0YwzBr28s34OodLOng5xKfjg/C?=
 =?us-ascii?Q?8OWoJf23RI7FeZWdCy1iUJZy2jCCsOGvhXfbcJO+k9BJgGgyu6gn3VqZM2Rt?=
 =?us-ascii?Q?/EpmcSAoll1VAQXRTuAPG4ylQqurrk1pZwdKBlhdfQxHz7H9M/FFLAlAiEkh?=
 =?us-ascii?Q?i8l4BiJouivEDdbrfbGo+grVyTlsCL3ZvjdhODNfyWGDd5lw2DiwjdTQXgY7?=
 =?us-ascii?Q?EY4bu7+FQkNzfSODOYhDvtOK/b0Bab6IBJ6gmEmQtWMktWXbrSYvhdt+t+q+?=
 =?us-ascii?Q?b/uTz4u1ILOtE1XDfF02cOnUKb8SjwZBj27Cc93kNEx+1NoNsFlE18p3HklQ?=
 =?us-ascii?Q?rWqO2ox4FtJ3/9G5SvxBXUuwipCXok7ubQQvRBUU07i2VoOdUWRBOu2ekTis?=
 =?us-ascii?Q?vvJutvWabKajC6zDoSf0AnbVo3hXcneP/L+ocrkaLp2nM/51Pz9iktMwXkwR?=
 =?us-ascii?Q?tiJIX7ur9BcNtu/3TKogRnfikjAhsnZupzWbxYYj2tf55IEilfGfWS5/fl1z?=
 =?us-ascii?Q?FBhz02YLZBig4TBqKgrmHvm/XmOdOyBVKaMfu5xwfE9aLwQ1iuuTsnuQQLSR?=
 =?us-ascii?Q?aK9KFMZgOHRDSAJvpIpg/TNT/6qUApIif4OnbrV3gXqXA+UM/hsyRZFcYcVA?=
 =?us-ascii?Q?+8MfRpc0O1fZ3s9TNCP9sX3gRob8AQZejPVFaYrNsw6801BcmOMvR0LfgTPA?=
 =?us-ascii?Q?D8v9QiylJLVCT+mmbW0I6VGNDanMn3mXk+lDIpDLOPr/pB/+5fuiUx7pgmSh?=
 =?us-ascii?Q?ZTZYdyUc0ljVmjb5dSonN9PJqHv6ArRukaHH0z68CHr9hzS1+E8lcBMHO9ji?=
 =?us-ascii?Q?O6A08vEl9e8TwTuQckz56zzconX7iQSVgaEVUGY43RbfYeOzmaXLNO6sNe8b?=
 =?us-ascii?Q?7oeAznZzHZOug9fpfLamb/dWJxmDCQ0XZcY1AFs3zKTysnUkbYFbQAIlyb44?=
 =?us-ascii?Q?8A1WpNG50kJc0boNzxqx/uVE9JNd/kZUZYdvs4v+1JfgACYlspD+asu9zD/p?=
 =?us-ascii?Q?YuaLjGk92M1zLiipEr5jInWqYrlyg+WvfGCvUBuq/oKTLulat1NY1ptEaYTt?=
 =?us-ascii?Q?KJXSGOOEXm8m8s8OrXR6tpEUyxKxNu3zqPKzFetql92xrcOKYvT5mRxTOX/4?=
 =?us-ascii?Q?oQDsYJw=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(1800799015)(7416005)(82310400017)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2024 18:22:37.1070
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13e60e45-3543-4478-9bde-08dc70550110
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9DC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6287

On Wed, May 08, 2024 at 03:57:09PM -0300, Jason Gunthorpe wrote:

> @@ -848,5 +849,8 @@ static inline void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
>  						 ioasid_t id)
>  {
>  }
> +
> +#define arm_smmu_sva_domain_alloc NULL
> +

Just a few lines above, there is still an inline define:
static inline struct iommu_domain *arm_smmu_sva_domain_alloc(void)
{
	return NULL;
}

Should we delete this too?

Nicolin

Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F504C81;
	Mon, 13 May 2024 06:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715580107; cv=fail; b=t2tqWmB6+2jx/KFVTxCrvfG3El63sAISxIkKKLjg5tjUo13vshWWB7D8wQu03Net7GblJ52cXU3/EEAVViV6THw2PZp0pMHijZ7w3seNjE6BOf+kWyYGu/sz5NsCqqOsX9F8Gx3MzNOsNJrYugTThWKf6oXBX8mr6qmflgYEVwk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715580107; c=relaxed/simple;
	bh=LxXq8xFcf+tVpqvpkVLsykkLN9FZrwsL41xaKa5BdjA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sZBRxtC/LCi0QjthMiMU5WIKwRLG1yDY5gjG/il+RyFhKd2Mc92Y1rWI49dGhUFqawSvgnEc4unVhuskMiCD5jMT0d7NBOyWkaMPgM9+T+coSExO4Wvxc12lk1Nu1ywSatAIncpTVg5k8xuytaXM1XNej9MCdR56qmLh7FqyZvc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P3Gh7Atb; arc=fail smtp.client-ip=40.107.92.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P3Gh7Atb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PB8Ah+2VLBXStGYGmzFKTD3etDdoqK49jf70D4JxqADq11k90+Jb+iOF6aaHV5/LDaGD6ku9ONzcIWZoz4Q4R/EvkvTNA+XD/ypq7E3QbVmEZE1XKi/W24tMUHb3/MsfOQC62BHDfnXV+TODwJE1SNKQ3zASlUGPcy0L7h+IkCTIg1UDPnCU7WC2Hjd1zV1WdwJsAruHA3OygtdZyIYVU0cDPWB8ZNWjRETLWA/CcTW4ZLnjV+aO8YT0PUu+eztqhfzR0VGthNJCpkQ/0D0iKCi4azO+jSkVMGs9IaBsnb9j5OIxf0nDxtpZXGdmPeA3Cpo576FDtLObY8uiuRhehg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CfbeokFmc+7ppTYgIER0m+XJEQDVI7p8/ep13L76RME=;
 b=ntAhUtyl2W2TbsBIPX0x8E+4xhuqqGY2vCFqGyiQhO40+PYDvMn/LNbSKtvaGqTaZbW6c/0jvZPJHiNr0wpEcNaxGX0TvAZrYRChsBhfCQ7lpdNfkrkewR6s4+Dgtl3+5VsW3CTEGCxVyhjePhVeuPg8vQoCzdNmQYaoxfQf0EkKWMjQgunx9SvzxhiC6VB1H0cCPlR6JVb9v8wS3QVAv4k8vH4Amb2pGCvmzamgZKD1B3lZ+7V5DbZjxYTRbk2a5yGEgHsW7cXKNvY0sZzmDOy1Uz25FDU/NuiN+GtR1LB/3XERmAQiEJ/TRHYKkHZKUVcwYrsayw8Xh21QWmGeEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CfbeokFmc+7ppTYgIER0m+XJEQDVI7p8/ep13L76RME=;
 b=P3Gh7Atb7MQzluzYL5+sRIx2CsC39ot2ls4LYKyeKw49Iw2U0oSMGrmoXfzsJcDK4QSWuGsEoCjxOhXnWVWaElwbqmdH7rWqZnocoRgmQL1zZGP+axINmgGFo3vx9mDSll5SpP9mipCORJkolB8a2h9J9E24DCugnnO3ZOjheEEc/Ap5Hddz76awI0YDNi/i+khIC7YufMM9LHzqBZBEbOT25U9ZtJkg7rUHFV43aJ3IuslXNjKBfaFMjVN++ugQ7jHufSCn8seSMC/1vBxg0rRotLjD5hNfJ1AmDj5cbIl8CeM4MBLn0eNp1EKLub6ZOSDL5i/0r5FPymdSOkUdwA==
Received: from DS7PR03CA0316.namprd03.prod.outlook.com (2603:10b6:8:2b::17) by
 DS0PR12MB8526.namprd12.prod.outlook.com (2603:10b6:8:163::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.55; Mon, 13 May 2024 06:01:41 +0000
Received: from DS3PEPF0000C37B.namprd04.prod.outlook.com
 (2603:10b6:8:2b:cafe::fc) by DS7PR03CA0316.outlook.office365.com
 (2603:10b6:8:2b::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55 via Frontend
 Transport; Mon, 13 May 2024 06:01:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF0000C37B.mail.protection.outlook.com (10.167.23.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Mon, 13 May 2024 06:01:41 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 12 May
 2024 23:01:25 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 12 May
 2024 23:01:24 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Sun, 12 May 2024 23:01:22 -0700
Date: Sun, 12 May 2024 23:01:19 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 06/14] iommu/arm-smmu-v3: Do not use
 master->sva_enable to restrict attaches
Message-ID: <ZkGsr80xDAyVvFMk@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <6-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37B:EE_|DS0PR12MB8526:EE_
X-MS-Office365-Filtering-Correlation-Id: 25e08a5a-7691-4da4-3d96-08dc73122942
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|36860700004|7416005|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?arGUN/uhSSTHnrqbv0KkJXmRFuWAr+x9cv6K3DHYhflPBazwHgUdlbTucIRv?=
 =?us-ascii?Q?hJaQVnLx3lHfyHRXmpFp2UH5l9Hp1TSSVHjm6OeWWs1fz0jR5qUejT9twBLo?=
 =?us-ascii?Q?4tKIYL+uibaHidhfZDADL/uwfUuBlPW2nP44fuODqv2rea3mTB8nyUHD4Bwz?=
 =?us-ascii?Q?J5GaY3gqLXJDT1tOP7/NjkRC9jW02DlYeikiWNXssccDpbCe59pkmOW2zn0X?=
 =?us-ascii?Q?nEmCynfGSvAkICQIz39mOQDgPYvxY9YGoKoE6SSNVAyaplloC2TQJxRi2TlR?=
 =?us-ascii?Q?ZkeWtSLb3do7my3faMAWDlDcW1FCNbfwIkyxS9h0vJ4alN8RhsL6cmWpDlK1?=
 =?us-ascii?Q?yVbsr/1S+L+g99anLlS6RZVGbGUya7kPG5beW6jGz+ZmW3Q8hMFIuBTFnpMM?=
 =?us-ascii?Q?LjcJ/l1dAC4pqulhbEN+4X7F+z6meLgVdZmSqwf7YVWiHRkpzwk+sLjrKgbS?=
 =?us-ascii?Q?7mT9HMDj2y+3NodrlCkG1EP6/sCZ1uWP7Vvs1KhXcC3qg/fwwBgmdi1kuOsr?=
 =?us-ascii?Q?0JNThyGF4gvOiwWZNgzQ5JSV3Ie4RjOaFvJ07Uh6w1Mxfb+v/E4BpfLFT0z5?=
 =?us-ascii?Q?/eZtCr6ND0QQ8x8R2RVoNVvO4+HTB9wdOvBWHgGB2tZPWrNpTa+KQ8pUBUhq?=
 =?us-ascii?Q?2gAxd/G9CQ7dlN7I7Z4VSXhPnFCLhG5GAh4mbWoNEpmfWYbwFVsvGudrCkcd?=
 =?us-ascii?Q?xtffg+hNGA7+0vy2iQb0ArF3Dc8wet8OXgbQSv3OlxXIthfaYDrWZICodYc2?=
 =?us-ascii?Q?xn6OEDcGiSzEe69xpUVfwGyrqtmO5dkHqCyTY+mJ0SH9+jvGEfk1SIW7bR8o?=
 =?us-ascii?Q?cOUxz0wF0SY3K1KM9g51G+ATvcgONHqt4pdsGbMG+oOFFEI5pUuiA+I30eeN?=
 =?us-ascii?Q?pqoNsV72urIF2qXpn7IBJfOzx6KM/8nuaApIqUcVFkB42Q9TUeB0FjG9Xgqc?=
 =?us-ascii?Q?j4WQanjQsVJg+cMVnkZomubHwwavye6l33jvqDG7EUv5tYh/FcfdRyMBbVrt?=
 =?us-ascii?Q?Fs6liJXlI+3huYPRdWB/scpUdNPmnIkij4GtOvNMRIjjXTCC0Lm99Ic4CMGW?=
 =?us-ascii?Q?4xcOj+BOvo9GdMX4iHK6MLMWY2Z/TFT19S+q+T+2++VknuX4JrSrz8kgjOty?=
 =?us-ascii?Q?zXjoPGIx4JT8X41rSEWZXZlqysiENKb7SpXdZ4lKyfYQkv0m4x4dEuZgsdRT?=
 =?us-ascii?Q?zJvybHNUGbzIbtmk4jFye9blSEXTSxNyqaDuKn1skmlAXdR9wU9f10Ak2zhT?=
 =?us-ascii?Q?hvfq889h8hiOveljxUMFAMiVAI+Ob83xZJywVhefiOhSEpq7Tq9868eR/UnP?=
 =?us-ascii?Q?5CaBMuM1r5jC2EBYFMlsrZSZS1isYshiGVtwvHja7GPvpFPPW+h/v+NcZR3X?=
 =?us-ascii?Q?j9PNjZs39cvK7xBHgUkwZe/AJbZx?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(82310400017)(36860700004)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 06:01:41.7017
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25e08a5a-7691-4da4-3d96-08dc73122942
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8526

On Wed, May 08, 2024 at 03:57:14PM -0300, Jason Gunthorpe wrote:
> We no longer need a master->sva_enable to control what attaches are
> allowed. Instead we can tell if the attach is legal based on the current
> configuration of the master.
> 
> Keep track of the number of valid CD entries for SSID's in the cd_table
> and if the cd_table has been installed in the STE directly so we know what
> the configuration is.
> 
> The attach logic is then made into:
>  - SVA bind, check if the CD is installed
>  - RID attach of S2, block if SSIDs are used
>  - RID attach of IDENTITY/BLOCKING, block if SSIDs are used
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  2 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 24 +++++++++----------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  7 ++++++
>  3 files changed, 20 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> index d31caceb584984..7627cb53da55b9 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> @@ -628,7 +628,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
>  	struct arm_smmu_cd target;
>  	int ret;
>  
> -	if (mm_get_enqcmd_pasid(mm) != id)
> +	if (mm_get_enqcmd_pasid(mm) != id || !master->cd_table.in_ste)
>  		return -EINVAL;

The in_ste is added in PATCH-2 and the new arm_smmu_set_pasid()
in the same patch is also guarded by the in_ste. So, it feels a
little more related by moving this check here into PATCH-2 too?

Thanks
Nicolin

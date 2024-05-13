Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9C98468;
	Mon, 13 May 2024 06:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715581997; cv=fail; b=RvUs7GHKaz8nF0WNxFozH3+2e05SbEadl41PLIDLQq4uz7FIo48DrISshvveI6SksPVeByadwbmJKZcKQVELxT48MNUuwYKSVJ/bD+5Fy3oSuxGc/XQ1GG5s+ciRqLyFGlhqwIHxwLpr02Sp+WjMvlVxCLZb4klzhpRyauz9wMg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715581997; c=relaxed/simple;
	bh=nLBoWCpsEKEAVgG0cy1rVrxhnVbdK0cVqRsvdHLyaZ4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u53yGFdtCWuIVULFu8uPQXpaNn9Lqemt4N1B8dExivzeiIVeCJt5FNu3OX1ng1g6rhi69H0BZ+bS0oyZJwUtMPBI0wbEFjCZ179HyaulspLciCxcndCtoONTMzugW1Eel8/rLomOq8aoU5yGFScQpEVabam6qkEOW0r0Dn786qY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XyBl1j92; arc=fail smtp.client-ip=40.107.220.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XyBl1j92"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C9sOrBFD0PX/AdTyQsmrfPh3wPKG9f73v94cUy4mYoV4WYUfYiE0WzY3Ghq1J6AORJNSaxH3MyoEcH/QfZ/2bJTtjXgOhBLLEPFwSeo8F6sWy2JqnJGQxbbEjLPGMKiD9eGeePWaT3OYLzq/Q0ELmk/nUmSTfV9PlLJ2UnxliQ+K2fSRRCWPvUuVA7qvRDpMuECwCi78nt8BIcZYOBgl4oz3AHj7olpQWXt9tWIhf54tO9vyvbv8XJT1MRWnoCBgSZGxKRRVlifdGXZGPVaNMjK5T4CwzUtQmNXYJc6t/2FWxe7Fj97wWYNcpTazS0wZNbh/T9HrpvaDl6OI/8/dAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aYREDe6DAfxEhVejUYQDmDlf2YmloTtyzRRwSzsAPrA=;
 b=Uqn5VNIFAgLDqtruavMuj7gxoVyu/Eop4SYSVAqxQg9vt52Qwzni6DnjQhV0Mgj52CS3AdfPJW87FuXLzN5P5dI5RQb7qmvhVNjSCm6+r+wjsly5iMt1ncSiysdt3xgDyASPa3xKx8kXApAdoPXabVLtzBI9oFawmUOwWaoziJ6NK5wTDXfRNZLmtR3fdXDIMDiIY/r//mA/SX/M4nyckOPeesArpABTXZClEVTW4LlXHY0STQG10e6swOP/qFqwGQ51HE654ZT9JegT6n20izuho6qpeJ6SnBQq+wHCYWIDZyH8dSnx/z1pbVuWCHIYIZD5wlItuClbf4h1C9ghUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aYREDe6DAfxEhVejUYQDmDlf2YmloTtyzRRwSzsAPrA=;
 b=XyBl1j92bMVEoNHqqqMfOaHorNi9cccrbjTJ1wHaGAGZEFrv+SFZqF+tBSucAtdGTjzZpohyOZbLPRGi1ZAJPIMBR5QsfTFP0iM3T9dxv69PWJ2+iTqb50u2uEeKMdup9c/HXnOT9VL070LBBzdvM6NvR61p6nGt6k+0eTrsWE0u+68Yt2pxCDPVDcc/bY5/9vdmiN0tfQJ5oxEjv9fmdzh5N6et9/p6PvEGKc35jibaJ2j+WLam+t+uG5XwaxuvywVLTcRVL7ivevRQKIZrYwxzY+vdmOLY7FiTDZzgAG3YV12IktRMseB+OzcYZJikCndJGOem1kUrqX24Yk8dcQ==
Received: from SA1P222CA0121.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c5::9)
 by DM4PR12MB9071.namprd12.prod.outlook.com (2603:10b6:8:bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 06:33:10 +0000
Received: from SN1PEPF0002636A.namprd02.prod.outlook.com
 (2603:10b6:806:3c5:cafe::d9) by SA1P222CA0121.outlook.office365.com
 (2603:10b6:806:3c5::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55 via Frontend
 Transport; Mon, 13 May 2024 06:33:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002636A.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Mon, 13 May 2024 06:33:10 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 12 May
 2024 23:32:58 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 12 May
 2024 23:32:58 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Sun, 12 May 2024 23:32:55 -0700
Date: Sun, 12 May 2024 23:32:53 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 07/14] iommu/arm-smmu-v3: Thread SSID through the
 arm_smmu_attach_*() interface
Message-ID: <ZkG0FYhhqSW7Zmt6@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <7-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636A:EE_|DM4PR12MB9071:EE_
X-MS-Office365-Filtering-Correlation-Id: be8db213-2204-49d5-2924-08dc73168ee2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|1800799015|7416005|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JLK+XbgwV3+5GBW8ttehUfEtA82scQYcvT8wKXd5vdjy6VEREKNIZLO3SV0R?=
 =?us-ascii?Q?UF2UbOGAZkYY5DohyCj0a93FXEEu27lkMoSjz2lHAytLZWPI5Or7j8hFdBO0?=
 =?us-ascii?Q?uxceS5ZXgdQwcah7c5numGIuVndQEZ5T72P8EeKcmODF6xgXufPgDXBi/7Ff?=
 =?us-ascii?Q?J8sxziE5AfJlg5Fa4R7q4Vq9Nm0X30+FSJP0zrOdwnjuCMf1oRUqSCa9dqyc?=
 =?us-ascii?Q?tqpdQdOgfHjx7XFPQtw6hKm+3sgs3wZ4zZd1g53WSIlmZQXXcaV6u/OvzhTk?=
 =?us-ascii?Q?NxCzUbfqykiPXZipxIQvdKLuWL32oDlifcS5za0ZMxAYWgb6ZTZpjR1x9IzZ?=
 =?us-ascii?Q?16fBCAyqap3a1EcIA92kKvPWsAebWPmEv6x63LIt6LpuYuSg4aagl2XO6FVs?=
 =?us-ascii?Q?u1dN73WbO6poQQrsqBmp96CtbsEopuxjYqVz51WbX4yaxsAPHrfcTHqUzOnF?=
 =?us-ascii?Q?uGingWIO5n26/Xfb7hhaKtQfmxHezqSfzF2tK17D0+sTGzwp3Ztt9nFrqSN0?=
 =?us-ascii?Q?cPuLHkNhz0sIyybOOf1VRwU86gtJRJ3LoN2WXIGYq7oYcxJ4XETj891a9iCV?=
 =?us-ascii?Q?ADvI1XkN0nc8fuI26oNytsB15qN8xbEyyYFrlcl8jUQLNQfakEplcQAvM/24?=
 =?us-ascii?Q?BfxKH/ZMmrs3hvmSieuzJyb/Zq6dt+2ldGz7IguSpBpxPbdgtKAFTMrwuKw9?=
 =?us-ascii?Q?QganWDm2lT+TtF6+mHN6FTouRpVYqek3dabACln+oLiRh8ToD/wHhvr0f/8X?=
 =?us-ascii?Q?lwEr4ewnoF4cAwp5vZjKZ0uQCNyaN9floFKmcwVKm4W+Q/M/MSGDLYTY0JOb?=
 =?us-ascii?Q?k0227nqfPZpu3QreTORA+DYFvBtKeDdUhWtCSyuoQHkE4ZMrxqszmt1Ci70t?=
 =?us-ascii?Q?pPu8h/qVl1PduYp9ax5IcqUG9NjfKk+QDtQLTfQJncqxya6QLHbK2u5h/lMU?=
 =?us-ascii?Q?4rSJx3HQoKTkS6uS3KBYwF3L2JkBFYxkNuRv+MbQhk4B0rycugB1VsMJBM4l?=
 =?us-ascii?Q?Isnwj0geLDyIBYtYGZNCwT/9GLGS9Agg0nH1j7JlrBb1EOk5ANbGTChLyPQX?=
 =?us-ascii?Q?gclJM0g5irSMuwy6ZcKszJxKK8PVOAjQ4nYftelo9BqpwcwoTW/q+YrBMOLu?=
 =?us-ascii?Q?sjIpaF5YFxwZGGUvXWIGf8msRJ/HoEBsRn/3xA2pORb/+1a25xi5DlnrgNTM?=
 =?us-ascii?Q?Iqg6oDqziaTj+lMTa/W929MKgXUyOusaLgC+q8B0cZatelSxnfnzmmglbfJN?=
 =?us-ascii?Q?LhPTV54jU1s83wP9M/S/ICbPN5kwVFguyPuHUlZCdKwgowAFr4qAJviq4JEW?=
 =?us-ascii?Q?YA0a+Wdv0LqGB3UOJx5TxnMRb7Gm49qq0p0POcdMAA4OCMMXB+0mhV5vyg90?=
 =?us-ascii?Q?HKYeobA=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 06:33:10.1866
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be8db213-2204-49d5-2924-08dc73168ee2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB9071

On Wed, May 08, 2024 at 03:57:15PM -0300, Jason Gunthorpe wrote:
> Allow creating and managing arm_smmu_mater_domain's with a non-zero SSID
> through the arm_smmu_attach_*() family of functions. This triggers ATC
> invalidation for the correct SSID in PASID cases and tracks the
> per-attachment SSID in the struct arm_smmu_master_domain.
> 
> Generalize arm_smmu_attach_remove() to be able to remove SSID's as well by
> ensuring the ATC for the PASID is flushed properly.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

> @@ -2689,11 +2692,14 @@ static void arm_smmu_attach_commit(struct arm_smmu_master *master,
>  		 * SMMU is translating for the new domain and both the old&new
>  		 * domain will issue invalidations.
>  		 */
> -		arm_smmu_atc_inv_master(master);
> +		if (state->want_ats)
> +			arm_smmu_atc_inv_master(master, state->ssid);

Just trying to confirm my understanding here:

In the arm_smmu_set_pasid pathway, ssid is a valid pasid. So,
here we invalidate both new and old master_domains using the
same ssid/pasid, if either of them occupies the same cd entry.

And...

> -	arm_smmu_remove_master_domain(master, state->old_domain);
> +	arm_smmu_remove_master_domain(master, state->old_domain, state->ssid);

then we remove the old one here.

Though the flow makes sense to me, yet I wonder if there can be
such a use case like this where an old master_domain is holding
the same cd entry as the one wanted by the new master_domain?

Thanks
Nicolin

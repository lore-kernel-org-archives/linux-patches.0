Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2053.outbound.protection.outlook.com [40.107.223.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4ACC65F;
	Tue,  4 Jun 2024 06:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717481876; cv=fail; b=raNO8JXDzHaZMdfk2wSVxY53PEl5QCLQkYaJ5ZHX5F/ggycwaUOq578xXR22if2PyKo4JbRxYSP9X7kCQ56+XQGD8GliGhxyoZdpGvcRRPvKa4IyPapE+jaGcoRWZZoj/B1umugU7EmswaWKXOfJPvmA8RcT8VwDIM02EiDnEuc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717481876; c=relaxed/simple;
	bh=nfTtqtFwQROvB4Djfym/eGxlhG0jfuAbaLiKMt1rO5E=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IsX1tVO5FuRtgfwoCule5oRk5n6HZHWrOL+bbtvkh17WH+dm4aMaU/FXGYNmJQFp3JhbKcNaYD3P4M1vAksmXTxgFOFEyEGoLzkHDUJwQQJS/x5vXFKw0JQnMbe/gj0hTvSg5Wyl4Tz68Gq9PtxtemSdqT3d0bG5lLHY+vzK0w4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XuDkx3o/; arc=fail smtp.client-ip=40.107.223.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XuDkx3o/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYe6cC0Zrc0D028MxQGKw9Lt65LePHnpiYotuT6y64LadIG/ML3uidxqJnl+5BUhoYbeCEl6mnq2PZNdMsl+DqGjQmirSEJeKNoSUWvf6/YcPc9sGDkPu9mU3tj3SImr8XsgEZzwWzpH/7Vq5RQiylKDcsKEml1SQdA3LNGcK8FNnHNsZwkyw0/iEf9Sx78Z64DMZXlnjhqc3t7imJ9u5ADW0LBAdQzREYo38hXlGYrUdhfXxYzcRiONwJk+vtuHrCPtO/wWT3grJPwy4hBX6M2JViaUxNlCzssc8qRIEpNNURjTDR9HSUeKgwY6WnZlccqnkW7hArMRbls1tTfXkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=civEJqp/NK8f5HN1hdUwUbptTWhXhd2WU0Il0ZCU8xg=;
 b=cv8tSUsoklAUriB8S4PFdPZ/CypbrK/4Li2VaAQ5/jiIv6KNhUJkNaYua3cbbH7A9DNOhIv6KRFa7LL9W95JM+FIMQG7MQk4sXvY2opoxQ7myFwf/csXwDuRm2Z2uJ5CTyDo7ZUl17wTwfWa5CllYo1qvj6LkxiUvYQEN0AMR21lXGpA7E5AAogP6fqijgA2z5mXdBCBqPbUB3XNxzztLsI7/bzPfaZTwAVpGhTJUU0tGyagiCHpyLwfT2GkkuZCdryn+Okevgoot0w18+uzuhP4R2LASiNuk//eGNoiS2tdh4FgRJfp3JNHtZrtjIvHPMGgKOMwXlv801ebu62AyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=civEJqp/NK8f5HN1hdUwUbptTWhXhd2WU0Il0ZCU8xg=;
 b=XuDkx3o/El/zESAbbpilr07SiFpnx48UseV+MDcvglIR92IDSKWd0e3Sunw8bAomHgppd8kMeYRXvfquJFSYk6a4wwBbKmq2VrazQpPFSMzZgrb+uHQ73vbhp0hQsvGWGoa/Ikq0LOrSTxzF9I3VjjYNcIPzitAYcmiGz036K41x/M1vyhQuc7VhY/ojuHntRVWr+Lg/dU2Iss4zjiF6M6ZITwNurZnh7aY959bVC1PfxObeKUhc9jP35iB9+Two0m/1yr5I6XKfolAybggYCVLZ7xrUIc4pqhSW8xJWGBQ1Qg6NPVs70m/WjxlFRCPcTDlx/rd8QXUAxhDE9wf/Rw==
Received: from SA0PR11CA0202.namprd11.prod.outlook.com (2603:10b6:806:1bc::27)
 by PH8PR12MB6988.namprd12.prod.outlook.com (2603:10b6:510:1bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Tue, 4 Jun
 2024 06:17:51 +0000
Received: from SN1PEPF00026369.namprd02.prod.outlook.com
 (2603:10b6:806:1bc:cafe::ad) by SA0PR11CA0202.outlook.office365.com
 (2603:10b6:806:1bc::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.30 via Frontend
 Transport; Tue, 4 Jun 2024 06:17:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SN1PEPF00026369.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.15 via Frontend Transport; Tue, 4 Jun 2024 06:17:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 3 Jun 2024
 23:17:40 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 3 Jun 2024
 23:17:39 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 3 Jun 2024 23:17:38 -0700
Date: Mon, 3 Jun 2024 23:17:37 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v8 04/14] iommu/arm-smmu-v3: Make changing domains be
 hitless for ATS
Message-ID: <Zl6xgafh1n19YFhB@Asurada-Nvidia>
References: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
 <4-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026369:EE_|PH8PR12MB6988:EE_
X-MS-Office365-Filtering-Correlation-Id: fc290bbf-6319-4e64-9fd8-08dc845e0fdc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|7416005|376005|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7Kn09x/PheBQ2kDucCT77+PlqwvknrJFR/VqedlwfST8KiF+NM0BHJq3Ba/5?=
 =?us-ascii?Q?oA2efptLQJht9fybCHTb3fw6npJqy7rjHz1Q/OfglWDn1hE6LGEabG7FkzTz?=
 =?us-ascii?Q?n8Nj9Wrn5lsE3vsI4qCHz5+rjH5qzDf1EyXCjim71edW8gDeSUlAXVnPCfgn?=
 =?us-ascii?Q?QK0IVSpfG2JtivXUyqg5V0DqGFg43a4LCQe3NAxKh9QvNJIT5o1AI24QLmS6?=
 =?us-ascii?Q?lfS5+9qx2FPLNvS4kGxsLjy8YR+4ou/b/HXZSWxOSi3Q59cAdNSBWRKGc4T2?=
 =?us-ascii?Q?XCJIpTm1kKxXfQOI+AcDtgSo9S2Ju19rF/orRsQjZZRJFMLFc96fF/o7haKc?=
 =?us-ascii?Q?QKUKPxfHoE8LFpkTbN6KolsyK6lAhclg9MxR1BFrBD+RfS4huxz74BuJL2f8?=
 =?us-ascii?Q?Fa/f5dex2g/xxQaYRGiMeP+BLstpTF75arb+CGk9fnBhJDKt+17KiyhW7tqG?=
 =?us-ascii?Q?obs9UMcR5Quo3+Y8vt6elUgvD5/Y/vl99fBqbeREEEg8nk9P+65tC3EdGbNr?=
 =?us-ascii?Q?8tEFfq5soJ6hZHG03l8RTRX+1k4AF8uAC93AgYmJ+vwZcg06eFbxrJ3lc1HF?=
 =?us-ascii?Q?vd3t/ttwGhKWwdMUlUjbr0g8xTC8f2fK9/VbllVRDp8oBO5Fl6C8zhnXcC+L?=
 =?us-ascii?Q?SH2rhr3+HG58WKPDWaOF/2H2Vsoc32DaB3dft45XeHW6qpsqbII3DsSqgbPV?=
 =?us-ascii?Q?yuHeVROFtT1ZpP30KiqWkvm+0OP+S4NYLnkQDZCtBNA7roVPXeLMHyHRxuu1?=
 =?us-ascii?Q?ANa9gQmVfAnkgW6uQZkVisWyJuBa+UfzTeBAeD/QlNPVPkA4f1fJmF9Z/liE?=
 =?us-ascii?Q?YBGG38t8P7wGLWbt/xQ9efzQQLCGvrbSgjT+lYtr6lSIupvzVp7sP+7w+XRI?=
 =?us-ascii?Q?mEogsKEJRMp9/FybeDWGUan7ejyd+chGRo1jUyBW2npRFxE15XWbICYuSnTN?=
 =?us-ascii?Q?mC+XtOkCPKV2DxvyJZEpIRNYpFBA94huX57m3qUAAGkFe9bUBMMWwhHgq+qb?=
 =?us-ascii?Q?gHi3pjuF+A/El3gihaRbJFfmeEPCUmydWDLLQ6+3BVhFiULmLkm7aueUqrC4?=
 =?us-ascii?Q?LiHO0RSkLMNJl5aYzKtBKWZB2yNDBPbK1fK+Nt6SZaLC0QRezYFgyIU0tYhA?=
 =?us-ascii?Q?h5mhvqLKFqtJ8AKStD1jjhGqMz5lX7VliKQ6AGOhkD2B4Q0WyLWYkfZOfBn5?=
 =?us-ascii?Q?MZEOyEN94xFKRJM2doyMyNX+zcujGoM8XKxQolMbxCSLWmRfcSRoGI1WWBdh?=
 =?us-ascii?Q?cuwxuqgG+t55TOagZPx7M/iZUkxIG+Le1HuPE2PuIiBZacaWNT1qmwuG1LP/?=
 =?us-ascii?Q?iJCxUuYb0KLa4g0S3M/zhtaLf1kASA9l7YEi9Ef0Fy6WjL4LZPJEsgLEgHpL?=
 =?us-ascii?Q?5yS63ck=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 06:17:50.6270
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc290bbf-6319-4e64-9fd8-08dc845e0fdc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026369.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6988

On Mon, Jun 03, 2024 at 09:15:49PM -0300, Jason Gunthorpe wrote:
> The core code allows the domain to be changed on the fly without a forced
> stop in BLOCKED/IDENTITY. In this flow the driver should just continually
> maintain the ATS with no change while the STE is updated.
> 
> ATS relies on a linked list smmu_domain->devices to keep track of which
> masters have the domain programmed, but this list is also used by
> arm_smmu_share_asid(), unrelated to ats.
> 
> Create two new functions to encapsulate this combined logic:
>  arm_smmu_attach_prepare()
>  <caller generates and sets the STE>
>  arm_smmu_attach_commit()
> 
> The two functions can sequence both enabling ATS and disabling across
> the STE store. Have every update of the STE use this sequence.
> 
> Installing a S1/S2 domain always enables the ATS if the PCIe device
> supports it.
> 
> The enable flow is now ordered differently to allow it to be hitless:
> 
>  1) Add the master to the new smmu_domain->devices list
>  2) Program the STE
>  3) Enable ATS at PCIe
>  4) Remove the master from the old smmu_domain
> 
> This flow ensures that invalidations to either domain will generate an ATC
> invalidation to the device while the STE is being switched. Thus we don't
> need to turn off the ATS anymore for correctness.
> 
> The disable flow is the reverse:
>  1) Disable ATS at PCIe
>  2) Program the STE
>  3) Invalidate the ATC
>  4) Remove the master from the old smmu_domain
> 
> Move the nr_ats_masters adjustments to be close to the list
> manipulations. It is a count of the number of ATS enabled masters
> currently in the list. This is stricly before and after the STE/CD are
> revised, and done under the list's spin_lock.
> 
> This is part of the bigger picture to allow changing the RID domain while
> a PASID is in use. If a SVA PASID is relying on ATS to function then
> changing the RID domain cannot just temporarily toggle ATS off without
> also wrecking the SVA PASID. The new infrastructure here is organized so
> that the PASID attach/detach flows will make use of it as well in
> following patches.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

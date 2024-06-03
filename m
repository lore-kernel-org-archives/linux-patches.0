Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2073.outbound.protection.outlook.com [40.107.102.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0433E13CF8A;
	Mon,  3 Jun 2024 22:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717454496; cv=fail; b=Woe8MZHxkVscXZPN6rpgLXe/MAyLS03B9jg4tnHih0hdhCqmhU2b35BoFJnIvUIgq5hQPYGgWUQqRG7VHgi9eno/yaurg0RM33NtJXFZ3QUxSNuzlZL34MehzuTGHXBZak9G0ko+bEhe9G6//QwYIo6LRn0oJgxx0GtenMjYOyE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717454496; c=relaxed/simple;
	bh=dGdNOSu8EvfAcqqd8nvSoAJ9+1T7mEN1sDuzjIgTAB4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NtcRe6Z8dus/HSGaM4oBjngtaxx4Wo+EK+9d1TdMGGjlLZB7RMRqvEvcwinbuyujzWYe7vAsO1C/i47FGkbt3KXyUNFqkFsXDgNbwYTUeXwfMlXKC2SSSMCHjz/+Fj1j8/eFZG3GFUQfE9rUwv+VYi+rHxVFip13UzIZcpKtg7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Wkc5stIi; arc=fail smtp.client-ip=40.107.102.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Wkc5stIi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vex1fwy85t51W6Br7QNMt4IKh+WL/3pLcft77M5B5injSnKYPsnrRkSGenYo+jE2uet6yuQ4KckXtIhVLD1h8snz+Mtrqp2ddJzBsm+J3Iksx5b+wpc1D7Lqf27DjRK+JAEGCthwzHpSqtS0ThcB3nWLx/FR2pNDcXbCoJwmwbhoVcu2HVOZg03LFTXzBVXxOZ00j1UZJhs+ad0jzYcB3FPfGcZCwAcEqWZxC/gZwFrUSd7KjtysS/ee0N6eJJjrB3/xGxeb+ppb7B/8eEEwGUjAXZaSpkDO/0efN7QbtzFuuuFnfw7YKGcHDg5k5NlrGKsva/jxzY4EwaF9m9ylvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iZP5X/hlCPLgN/7bdf/G/Td3XH76hoViTbakuPOeuOc=;
 b=a4xprbxtRFkSG8T79rjAK+T6f2Ny4N3KSOACl4Afc0V6iF+8ltpBQuM1vyMI/hWPJcUbT3tRO9WSZVz4TIUH8ME70/fvxL0CgA8cbKKqnPU9D1LHRwkHZwLP9WEW4KT+Ssjr8beQlHhOu0d3shMNP4NwUb3rKrc3tg8Nf+TCHdNoNoCOf3j+pERSJ5GQV5zlsLqk6WtkWPmt50tiHvfNrycQXl6F1kcummQX0WXxE5cT+yu1yWUljYzDMijE07/BC+3mDnor1LQv8NpnvAUawXDe5AZD2CcoAjLLIQvIR0tCE2IKNrg9nbz/WbiHiWd5cJqIBr0865Jlp5xQw7/5+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZP5X/hlCPLgN/7bdf/G/Td3XH76hoViTbakuPOeuOc=;
 b=Wkc5stIi73t35Jai/29riKLmA8/59lAvw7B0nzBZO3ArSKLZgSfPospCg+GCKv7XQXr3MA2i5RhAg0wgWfh7ROpMgCjfwQiQQIN5KfU8MlhosjhAiIweIzCaryFPJ6SH0fDzxMkJhW1PVZZclMrZP/xfdzRi6UIuj32pMWpqyhE2PWsPtcBCvMdLsUnSTlV/zfm4mS0QETTG9bE0xKkX/NFwIi9Zc8BK8rrBmr0fVbBbodpoMaX0ZjB9Lyx1TRh3FHHJWlJXCqcr+984vMZ6n7kMc3Jrd4MzPbmzrwrAaveMQxJ53hmUQhK8046ODYud9CvOKLguALamo9McnJQ7nw==
Received: from PH1PEPF000132F8.NAMP220.PROD.OUTLOOK.COM (2603:10b6:518:1::29)
 by CY5PR12MB6573.namprd12.prod.outlook.com (2603:10b6:930:43::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.17; Mon, 3 Jun
 2024 22:41:31 +0000
Received: from CY4PEPF0000EE32.namprd05.prod.outlook.com
 (2a01:111:f403:f913::1) by PH1PEPF000132F8.outlook.office365.com
 (2603:1036:903:47::3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.30 via Frontend
 Transport; Mon, 3 Jun 2024 22:41:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE32.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.15 via Frontend Transport; Mon, 3 Jun 2024 22:41:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 3 Jun 2024
 15:41:18 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 3 Jun 2024
 15:41:17 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 3 Jun 2024 15:41:16 -0700
Date: Mon, 3 Jun 2024 15:41:15 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH 0/7] Tidy some minor things in the stream table/cd table
 area
Message-ID: <Zl5Gi/dHIvlbPdA7@Asurada-Nvidia>
References: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE32:EE_|CY5PR12MB6573:EE_
X-MS-Office365-Filtering-Correlation-Id: 610eb43c-527a-4525-9d55-08dc841e5039
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|376005|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CQkgCfF4tsdmhUBv0jVS6cRPJPEUn79vaV/QJK5QB4OOZZA05O96xWagkiuC?=
 =?us-ascii?Q?LgH6/4zvqtvU9Dkec9A9z7XkCF9wW/fuVA4sPJ6ibHSJKtr+V9M3jFGMVtJM?=
 =?us-ascii?Q?NfyowE4HGAPY434SFDVCIEtg5apwBpexxRQlE6nRl0dGq1nPxukFV4DsWxmJ?=
 =?us-ascii?Q?sPeBdmaAsVVidbnI1MWhobpUed+Kap11kjOBkN3tnc1zr4Mf3c/JZ4GpVLe6?=
 =?us-ascii?Q?jHEy43tcmSls9jOpRUEFRqY7EYyNpYGMEm/DkX/GZ8To+cwiQJsZk0vdMK4/?=
 =?us-ascii?Q?d8QXSifkgrBX2phstIjPNjjSVNbb6p0fUasmk2EN7oSx7l//VQJ0eTBe87gy?=
 =?us-ascii?Q?emypu86EuI2V85KC5Ha5M1i/FjpCfuDajeFkrigY1NzIJBcIXusuduou9jru?=
 =?us-ascii?Q?hffewqqsvWkDbGKNET4c7ksq9r3tiJiIRk45I6m8bZkjOBAkDsqIHkQRBFUK?=
 =?us-ascii?Q?8O831dVRjOpA3dSEgIzcm6OGnbhdfkaAXjmcB9VCE9rlIzHKfZYLw+8kj40j?=
 =?us-ascii?Q?jO7hlmDKbH4TU1AwnAQhnEcQc8cIcPjhBsrGhMZfujtVvLIFLkemrj8mH4aS?=
 =?us-ascii?Q?TCVrKPBrxK/T79MXsNKslvMA8TM6rcTTdjbPTPp7POVViBEtQHErAhqgWbZO?=
 =?us-ascii?Q?e4ALH54cM3nzwB9Ps31dYF8Fefs8PyZvOmZau5/qgw5XiuM51hEZo7RukyWu?=
 =?us-ascii?Q?LQnifa8yuIzEWKZXjH0ZNRbSZffHL879DUAFtE3SDqVpS/ISN0Jw62q1pc1t?=
 =?us-ascii?Q?w8ePVabfrU4OvBiX8zZg2ptwwAw0lpxmndU1R6BpHL4tarEpPw6NXBYHpnHA?=
 =?us-ascii?Q?/s9eS4VyHR4bxJpanxBDjtQsMRqn+h4I9JFGIgx3FD7KRgsddRKO2wpsDKhg?=
 =?us-ascii?Q?tK6FaWPFZZmmonm1b/PUyWu34ROtynq5Dl5ZRKbLIjX2eXsUSX02LFVZbZe0?=
 =?us-ascii?Q?ceFSa+1XLC7PnF4El6pG/aJCHJzPYa2vCLW/H5AgZuRCd3sJOPVm3XCTHpZa?=
 =?us-ascii?Q?vfOZftwYs1a/gaY8jUP26lbFVIWGPzxvb9b35Tvk2YCQutLbxQIm+yIo4smx?=
 =?us-ascii?Q?FsTenfWeBj9DX/e6HvlIDTxn5jbCEZN78b5tucCmfr9FeWhEtYloRnc7AVTs?=
 =?us-ascii?Q?pBw/DwL7CbpYj8WEiq9OCLdh25SBRhK5Lk4mzk6ZrVYdXnsQpMiw+cJoMOrw?=
 =?us-ascii?Q?2VlbaIFLap1KMRvVklHcuR0Mh0tEfkidPIuun8VVuMw3ssAIm6UcEP1zAlOe?=
 =?us-ascii?Q?Ul1khbqAamqrGR0WCPHgdd4S+kF/LpsoKTevPA/JwnkfsnCxgv0icYEiJ4RY?=
 =?us-ascii?Q?zud53jsH1eCj8rRqJpZIv6GvHQu/7r2fHD61qyNAGOTvxKSgErMwPeMYoKdo?=
 =?us-ascii?Q?KxzGH22a6Zv0sbmfSwJc3U1iKP5So8roaZvFePFqaqvxh/zPUw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(376005)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2024 22:41:30.8199
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 610eb43c-527a-4525-9d55-08dc841e5039
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE32.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6573

On Mon, Jun 03, 2024 at 07:31:26PM -0300, Jason Gunthorpe wrote:
> Will pointed out that two places referring to the CD/STE struct did not
> get the new types. While auditing this code a few more oddities were
> noticed.
> 
> - Correct types for the linear stream/cd table pointers struct
> - Remove redundant dma_addr_t's and save some memory
> - Remove redundant devm usage
> - Use the modern rbtree API
> 
> Nothing is particularly profound here, I've been sitting on these for
> awhile, enough is merged now that they can be cleanly based and are
> seperate from my other series.
> 
> Jason Gunthorpe (7):
>   iommu/arm-smmu-v3: Split struct arm_smmu_strtab_cfg.strtab
>   iommu/arm-smmu-v3: Do not zero the strtab twice
>   iommu/arm-smmu-v3: Shrink the strtab l1_desc array
>   iommu/arm-smmu-v3: Split struct arm_smmu_ctx_desc_cfg.cdtab
>   iommu/arm-smmu-v3: Do not use devm for the cd table allocations
>   iommu/arm-smmu-v3: Shrink the cdtab l1_desc array
>   iommu/arm-smmu-v3: Use the new rb tree helpers
> 
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 234 +++++++++-----------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  30 +--
>  2 files changed, 119 insertions(+), 145 deletions(-)

Didn't try something too particular for the changes, yet boot
and sanity tests work fine with this series:

Tested-by: Nicolin Chen <nicolinc@nvidia.com>

Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27920154C17;
	Tue, 16 Apr 2024 21:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713302563; cv=fail; b=FPU6EP2F3O3q9A1WrzoZPmQWXOfvIX8/17uy5BqvquecxBEp5YxJsyRFCbUVG1JGUSZhKuj6Gya6gOHJqRbnmUzWYZyKxKB47RUvQYzflIoiWSNrOJ0++N9ct7+AxlWEaTzwDfHG01rnluPNb5AayL0T5yywzvOS1FUZ/dRpLBg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713302563; c=relaxed/simple;
	bh=faCVAMdjbnUi8TItHYu/HpgsnknDozXaRE5LGvmLBjA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DM/5LqHg2i/xCqcncXYTta4lSnNPfeGv+AsRTiEsEnKJADbulHACAzhjWw290iOjqIGDIBJV2yM4RpXYHUtSdajcLgmczyFdZOwsEOhvbnSX+XwhaPGB/RwAEcfg3/Z5GcQ9ZdVaHoQXTwUhoAWd0k03EqnvYz1cJfFjMGuO5KI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ng+WPBy3; arc=fail smtp.client-ip=40.107.223.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ng+WPBy3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cgRmuoUeuShTqYJ28pAliklkYJyYoToNUe+mkETmzskusX4E3P6wieA1p/epf8e3c3dB7Y6M+dvxkEhzpw3qW+RmlfTfkuAE6upfi/TcXDscmlKxVo4h8yGXpHeTXvwZogayQMSKcSalFA4SClqEAGFQcjxYqG/vpHaGvvD92qUwAfuJWbB/5Vj24YnkQwUh12CDYVU2VurRToi7MtJOu8p+9ncwTbAwLdXPheFyh91dHQiVaOxv4VId89Qe8+1zryN8unPBsb4ude8lVbMSfVN9gA76gZYyRrCAVjcZdsKIizfIIjZ8p2Ob++5MMKAFXYkhMEZiw1iYf5pIEzyb5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cl4UVcVNS5EFZ3WeiblZ+P9CAfSLqnBcrqbyurWCPeU=;
 b=NcP75Z9J148N/NHtUP484kkIarqGAVKiH5niGnlwEZEeKxbITAUt79pVxVHr20wpq0YwZ53ugqE9OOgICDxsqZLz8GQKkmacUh/KlApt4k17uXFAuh6mycr0tfkubM2lntobCPH0HhImILxacR7NeryoZbktrySVi1P7F9rEtp7W/iw89tSXnOjvmpaXYcgLzAuBTrULSrbDkdauzH8BLwEvwkd7chJs23yUWq0lZG+FkyfdDxyH/HZaxpzdA7cmtaJ7jmjzH8SSxpJECw9iO0XgdYMk6tJewA4ST6UAlz+hVAMW5HYRfuPyLMvpPzN85fIQ9F0Z5B2qjy1tklMxBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cl4UVcVNS5EFZ3WeiblZ+P9CAfSLqnBcrqbyurWCPeU=;
 b=Ng+WPBy3Hj8yJD4u27yoRrQ9Xaw4d4H4MZcaCgWHF/Hn3EaVv/shw6sBHkolys7kqCuQTbNov01LsIeI6Mz2RPGK1PWvabh31LHdOG+hhODl8pB+mWHKlBBPQdgRKkoKxIIfY7JNlj8VnNpTXZ/lMJpWcFXCvsmVAXDZWVkGvB6l2QFoCc+If5DlC5REdaXyIffr6p8DRY5d/oHY6eJniCByE1OMZoqxahp+IPH6qFs4g5Eznmgh6PaoFUIdq1YZbQPsYEJ8yX6/X6+0nVhs1YnZBYjrxCTdVJ6dY9A3Vk2ViBpv51bgPD+/QrHOMiQzP2H+jYMe5XV06y3QxKwtDA==
Received: from SA9PR13CA0001.namprd13.prod.outlook.com (2603:10b6:806:21::6)
 by MN0PR12MB6151.namprd12.prod.outlook.com (2603:10b6:208:3c5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 21:22:38 +0000
Received: from SA2PEPF00001505.namprd04.prod.outlook.com
 (2603:10b6:806:21:cafe::66) by SA9PR13CA0001.outlook.office365.com
 (2603:10b6:806:21::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.19 via Frontend
 Transport; Tue, 16 Apr 2024 21:22:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF00001505.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.22 via Frontend Transport; Tue, 16 Apr 2024 21:22:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 16 Apr
 2024 14:22:21 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Tue, 16 Apr
 2024 14:22:21 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Tue, 16 Apr 2024 14:22:20 -0700
Date: Tue, 16 Apr 2024 14:22:19 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, "Moritz
 Fischer" <mdf@kernel.org>, Moritz Fischer <moritzf@google.com>, Michael
 Shavit <mshavit@google.com>, <patches@lists.linux.dev>, Shameerali Kolothum
 Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v7 3/9] iommu/arm-smmu-v3: Move the CD generation for S1
 domains into a function
Message-ID: <Zh7sC0+xPDDgVbhm@Asurada-Nvidia>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <3-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001505:EE_|MN0PR12MB6151:EE_
X-MS-Office365-Filtering-Correlation-Id: 333dbf7a-89f4-49d3-9c04-08dc5e5b575d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vwmgT++Ehq/rgkoT/zUwgyA0N7iACYBb+4El+ZoDI4fqcM6WCVaCO9JuevzW2teq02hroTmlcYIqLi/FbFiniwCD/K/PPpGPY4JZ8WNSfvZcsf6mXt9x17hr6+zm5vruCiktTC1/w4aJ3LIDmk0VzqiF2vraaPCTh93P44aP2GgRdIhUUK+AgA7VqsxSGjCoit1CThgrl6XaHzYfDOPvIkZlf1q2690+uooiGxfl1AqO6gERxvek2X7GVNFxqW8QxBHPBjHdJYvneekERjbkuJygONdi+jMJhSpDDxJ3fjYyoRGtpT6EZHznoDnL/t7AbxdsEzHwzBxbvuKVY8gmvEEcmxuu9wfWFDYavVX4e/GVHQMx6NBR7gg+zJonS0k3hK81Jg+LfzfJlL8FOERtVW3aTpKkFPmDuT6W95VOMjLbp7/RBtpjHhPW/wPM6ZM/Q0H9FouDxF84R7KZEBaxjxvNasvI+2qIigMBC2v6SLnHl1VJy6d2w3ZBrqKQJ6mi/NsxLVQS+QHGUKcKCZmQCgwzOYFVh0wYcuUMoXEhcc0Lk+iWpH/tpr6ZBcjyu8k7DTgkCTBQxm4CCdPW+C5qKBBUT8qm/r7ZUqt9dQ/densv8RnxwocKHHwsbI6WyjEzhTyROeK2yJkhubgf2ftfGTHBX3WBywNQ7HvbT7PXLce9uk73YzbF6MPaPv1baQMDdSz3+tW02v77xahBDlq87QOgQ9uAGcp7z7aLpdMbB+NUH9DP89Y//TLPXP8VrF//
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 21:22:37.9149
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 333dbf7a-89f4-49d3-9c04-08dc5e5b575d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001505.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6151

On Tue, Apr 16, 2024 at 04:28:14PM -0300, Jason Gunthorpe wrote:
> Introduce arm_smmu_make_s1_cd() to build the CD from the paging S1 domain,
> and reorganize all the places programming S1 domain CD table entries to
> call it.
> 
> Split arm_smmu_update_s1_domain_cd_entry() from
> arm_smmu_update_ctx_desc_devices() so that the S1 path has its own call
> chain separate from the unrelated SVA path.
> 
> arm_smmu_update_s1_domain_cd_entry() only works on S1 domains
> attached to RIDs and refreshes all their CDs.
> 
> Remove the forced clear of the CD during S1 domain attach,
> arm_smmu_write_cd_entry() will do this automatically if necessary.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Reviewed-by: Michael Shavit <mshavit@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA6F1411E5;
	Wed, 17 Apr 2024 16:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713371185; cv=fail; b=rxyMZTCe5sUOPeZkoO5Hy1NhdUSWGyl/ZfCHgL8Almi3RDlp//19Bl4tXvaDWQBv/1O05T53d8Vi/1efPZGcacCot+puVUBAs+yOa0sFQeXo8XXT7/PvFESlY3PMG1gxFw5A8yioUq/iMDhbt3V3+PjcaHK9ZCbJFyjtId4CLcw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713371185; c=relaxed/simple;
	bh=TTBcoLtpTqXAPQcToTW+jv84EjtXlr4cWOQRUl8kOgE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cqEVOcnILNTWEGW4Ex3G3Sm9n50KpS7MtBTc5Sh2192egsa9CGlrGZ6rJEEW7nQzELFaLO+wXyvgOo4fNzLtWM42nRb0DqF4h8CV37MZpIoMH4eeAb1any9nrETmaG8rWI/LvNI3zt63kdhdBem+at0i/0ytKp14AzmGo6fmPSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UTFy3p07; arc=fail smtp.client-ip=40.107.220.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UTFy3p07"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GtV2zpgXZLzoC9/S9XYcc1pe8SKbjtaQoEhvEj3PJNRN/ij3wuJTt3jNXYexZ/Q5sfp7Td5WRUH4skU2bZf2afeu6RgAapJCggopRRMkGPjxuuPO5mymw0NaiTON/2mLo/ji932E3IzFr1Hudfaffso1mwaSNKlrShjnustIk7/2Vy9fLza3Eq91bSINJQuffk2VrHvvL3aFXiHOXIxXvZHDRqneX5P/8z20AFU1FglykB8PbxN/HSnttZCC4oizJibtNBwMyvW0tSQdYV/cxbQ+ZY/lEO8lCZydnPvdzEPiHM3ZDacOLtJeuLm/cc7pqNZ5AUiyzYhe6/axan2C4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0MMbshwmvSiW5yzLxep17pfY1PrEtow/E4ysGAV5Kgk=;
 b=VR6edqfh0L7XTNGrAnpVCYMUOj9u0xToFBT2mJ4yhc5D2Hpj94YA7TbwFpAvQcRuhuWngI/Dj9LysBbDoub+GefWsjG/Ul1vOZvMfaeyNRrepaeofC5saciaTlBlPMzqGapbaYfP67MfPcuvCz8Hjcco16wYVs8HYP6s20eKM66VkW7SdHlT6aIofjsfzPYtrI28owC04hdzxdYITIH+s96Jf84ECF6aT/TDH+SDd26nTzYCgMD6cy1emML3ILV4+ZqOU8vCLcttJpcZcLPLQxOyo1DoSzXT2SB+9HvForYhvjkvIeJe+kHTVfD56fwJllVIPZT7KFaZVJBHLApMVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0MMbshwmvSiW5yzLxep17pfY1PrEtow/E4ysGAV5Kgk=;
 b=UTFy3p070a+0ApMw9DlBfLlhgQUvvqVxsL30fDjqOXX/eElAPDYynPAL3h3sUYWD3NiqR4+xWgO6w4CCEDciLf36RxsqB+JsJDO5x5eQRqvkntCUHlICS4guZsWTk6Hly6RefTXderkawhwAcWK7XYe8hk3AAEBgPmd7dr/xZ/ctwKM2TZdfy0llFMXHczvECWVEjIzn5aUzZcPvhhZBkm7umndxDK/yJmWH986hu6PxMkh2/j7GqIbRVuU3xL3JVHwYVIPBJkdvJD9XgOByCkGQGzXA4NjL8s5hYA7clmxW5dnkV7uqJWEb/6VY5V8Ecg8D5Dn/dNetf2LkagbSZA==
Received: from SJ0PR03CA0386.namprd03.prod.outlook.com (2603:10b6:a03:3a1::31)
 by MN2PR12MB4143.namprd12.prod.outlook.com (2603:10b6:208:1d0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.39; Wed, 17 Apr
 2024 16:26:19 +0000
Received: from CO1PEPF000042A7.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::a1) by SJ0PR03CA0386.outlook.office365.com
 (2603:10b6:a03:3a1::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.23 via Frontend
 Transport; Wed, 17 Apr 2024 16:26:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000042A7.mail.protection.outlook.com (10.167.243.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.22 via Frontend Transport; Wed, 17 Apr 2024 16:26:19 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 17 Apr
 2024 09:26:04 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 17 Apr 2024 09:26:04 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 17 Apr 2024 09:26:03 -0700
Date: Wed, 17 Apr 2024 09:26:02 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, "Moritz
 Fischer" <mdf@kernel.org>, Moritz Fischer <moritzf@google.com>, Michael
 Shavit <mshavit@google.com>, <patches@lists.linux.dev>, Shameerali Kolothum
 Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v7 7/9] iommu/arm-smmu-v3: Move the CD generation for SVA
 into a function
Message-ID: <Zh/4GovSMKoN0Ugb@Asurada-Nvidia>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <7-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042A7:EE_|MN2PR12MB4143:EE_
X-MS-Office365-Filtering-Correlation-Id: 075f4bbd-dd59-4e67-b924-08dc5efb1cd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	rGSiz0bQD0Oe5fxCA/CPHjOf2MP+0hV5W0itlmPD6pRr43jQdg5HYRhAw3og2P36DqYyorAhUPUUv1NDvESv4eiFIMhAoBEYzAqHs50zG90AxlmD71PecGI+QsK6dogwgKcZBmKhfau9hK1bWvPG0LhPhxym/Qnom+JPnXaSFfGzHL4upi9RFk6VxFkzUwdhro8qgKfdkq8/05Ze+EPsrBlce9RgC/tXs7/lWz2OTtYiHvz+IPgZn0n1s/6m9IQGCM14+lr0wxEAIZ7tIyixIcC4kQY3OcXHNfimyKoHR/GabUMqoxop6hweTLJRi4VnOOpK2cfI2SZepBJPd2zRqn994x9JuIuyz1K3SApxXWyCRkDDdyYej7a375h6k9dz6o1hmnv/9H5Rfvsen4ffunBmLibMu76B4KSxsGL2WqeDpSIdTNcHEQjbqo6ktcL1TE5vsaF57WRF5OlXtwrxb4/+pW9nnJwT6MvgFfkch5dhNLkU0gs4nuhXt1gAP1NsvCgFW5eCS5XLDwqfYxMS9AJPDtbYZ30meOVIvp4ySHcqfUpm/JH7eHGM/q/USVagr/5cUG9m38IwH4aMh7yLlINv1/L2nnfXc0WXZGEzBGMZStYseSi9gsNXWish6H9V1/eF/Xol3ZGJUQSgJPl0MlqYuDaoQ2nl6UwqFKKz7oSvWjGvYQ8DXjNc07Z9dXPTWh+qyCSTqdV400QakVoTKpHH12VmfaTrKja9ekbQoyW4l76GtS9aMfTJBMEX5qT9
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(82310400014)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 16:26:19.2401
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 075f4bbd-dd59-4e67-b924-08dc5efb1cd5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042A7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4143

On Tue, Apr 16, 2024 at 04:28:18PM -0300, Jason Gunthorpe wrote:
> Pull all the calculations for building the CD table entry for a mmu_struct
> into arm_smmu_make_sva_cd().
> 
> Call it in the two places installing the SVA CD table entry.
> 
> Open code the last caller of arm_smmu_update_ctx_desc_devices() and remove
> the function.
> 
> Remove arm_smmu_write_ctx_desc() since all callers are gone. Add the
> locking assertions to arm_smmu_alloc_cd_ptr() since
> arm_smmu_update_ctx_desc_devices() was the last problematic caller.
> 
> Remove quiet_cd since all users are gone, arm_smmu_make_sva_cd() creates
> the same value.
> 
> The behavior of quiet_cd changes slightly, the old implementation edited
> the CD in place to set CTXDESC_CD_0_TCR_EPD0 assuming it was a SVA CD
> entry. This version generates a full CD entry with a 0 TTB0 and relies on
> arm_smmu_write_cd_entry() to install it hitlessly.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

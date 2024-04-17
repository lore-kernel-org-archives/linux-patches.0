Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99AC184D;
	Wed, 17 Apr 2024 07:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713339845; cv=fail; b=BIwWMVfPHrur8TsPE03kEGF5bShOpqpJSSYiLFsBWG/Fy1DR8EwGgx1H2bJMcm8AR8gyKnBNhhPHOK6gXz2fdLfRv9rIv4PWdujzHMdWdstktnubc1dx8pf4XeO6wG3+iHEj1/uaRpk6cf8qDJ6dxjAHKpjOkeG9hWCag5kVHDM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713339845; c=relaxed/simple;
	bh=Whtisp/da3abvVKIV9i+zMQhclFfqxc/o+txZ83Eq9s=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JYr4jYbYDnqacM/SAwv5o61z+W2uNoMqbrRNv98mx8+3+6UoELusFeKsiLUmNjnrB/6H04v9GDyTFEZkvJN5FGuilXd8cBOKjRSCKydo0hE8z/nqy1mYSs4cqNUM+/QvgVK+grH7tzm3CL4uf665kRAIu358/AnlBXMouO/qPKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=S3CFxZUe; arc=fail smtp.client-ip=40.107.93.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S3CFxZUe"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9CEdgOpNjSbGM13b6JM3FJ6L3K70+CiZvvAetrBv0sZxtER3DBxK9GhGBfOxsPEa9UIj3BGfw8VT2vxBshuoOBfuAE7jbuzyapknQjvhqcGvMqmq0APZxGAFB3G6HqsWmJcsmH8sLpMhG6sVaWzbu6r95kQwFB1YAfSQC99DgzYBYaeiMgnz9jT10LXbmOIuJHXbITLoRhsTB2QfRk1CXa/Vpo17RNym71VKgdxd5OqmJ1gMUrobf8vnPLbW1irxVZzDctzVceAkBvwoKOojO5uPsHWp9boDcYDhJ7UNbBQxXxkIhr6rbh+sjptcyaZlYV9g2YHReHP9WCSQyc6Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fajazb1lp2zHMdEObcQaHWIV/PlwxTl9dw+CJgcEXu4=;
 b=RlQbstwG3I/e7k16fBye/G1t+8VDAD0IAnJE1xotafg3xqxmimx4kS8cMrhkyFI2R4R7YWqdc+hN14fd7uwatA9UYniHOqDNDOsQ3mXDiSjY1vWbPvxWqiFZExMVD8vEIFq7tlEzikF72iM31QXjcikNolwBX1jy/F/VNgMpjgTBcp2v/t01RMJo4C9jTlj5R8d+a3yYG14StwAp2Vherq6U1JX2pxZvS/Lv1ehy3w2rtf+nP2HXekRKDz5+Q4JZNNT0PTx83Drkh2IhYR6zZWEh7pFvRNjsKm160uGtYLbDgFdyl1NCXSDgE4xCfpCgdJRXV/Fs0c/LdWcle6ayVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fajazb1lp2zHMdEObcQaHWIV/PlwxTl9dw+CJgcEXu4=;
 b=S3CFxZUeqbMXv1L2qFVun9usemW43f8elAoKPtbs1SVEP35HmcYgF1aLjdu6CkDFb6ISWjHS9B6lpUcWRRzO5/8fGpoSG4X0Pew2SszaHoBcBeFKTtL2W0L+RExLn7r334nlYWaeRXPFj0RBlTuFf+meTum4dKC6xVMvD73rH8rAFigd4VjGqn8bHgT5YVVFJ92jgcPrdle4ddrXBJsITSaW459+V1x3P9NRg3cq2TpADKHC4GDXkjsw/EgJbvT4BJbdKSm3WDx2Eip4vX++7szmM29d470RutdlP2bgsJqYkcKuTz6alKBK2EE22R+UE09zyw5iij6sflQZzf2C4Q==
Received: from BN7PR06CA0041.namprd06.prod.outlook.com (2603:10b6:408:34::18)
 by MN0PR12MB5787.namprd12.prod.outlook.com (2603:10b6:208:376::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Wed, 17 Apr
 2024 07:43:58 +0000
Received: from BN2PEPF0000449F.namprd02.prod.outlook.com
 (2603:10b6:408:34:cafe::aa) by BN7PR06CA0041.outlook.office365.com
 (2603:10b6:408:34::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.33 via Frontend
 Transport; Wed, 17 Apr 2024 07:43:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN2PEPF0000449F.mail.protection.outlook.com (10.167.243.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.22 via Frontend Transport; Wed, 17 Apr 2024 07:43:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 17 Apr
 2024 00:43:37 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Wed, 17 Apr
 2024 00:43:37 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Wed, 17 Apr 2024 00:43:36 -0700
Date: Wed, 17 Apr 2024 00:43:34 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, "Moritz
 Fischer" <mdf@kernel.org>, Moritz Fischer <moritzf@google.com>, Michael
 Shavit <mshavit@google.com>, <patches@lists.linux.dev>, Shameerali Kolothum
 Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v7 8/9] iommu/arm-smmu-v3: Build the whole CD in
 arm_smmu_make_s1_cd()
Message-ID: <Zh99pjIQpDUGl0KE@Asurada-Nvidia>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <8-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449F:EE_|MN0PR12MB5787:EE_
X-MS-Office365-Filtering-Correlation-Id: a808b3a8-3d9b-47d3-c7d5-08dc5eb22437
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	b3ASEhk0Fya8NDq5pjoroxUQFoxCgbsbMynaZmhlp1DC+J+ZQE7EpCXlJkCRjjPjabi0CyaYkMqE66M//k2ayl2NhasoNnQaG/QNrxus0YeSaoJRDoGcWD4q/t09lVXpIJXbcwkSfUvcJNv4l9U5XovjpEgfD1yDh9CKPoAvoNw1cXygFYOpJlutbygoqtuEjKklFoD5IQzDdJTcnx+NXPt+dfJYcamuq6iYao4VAcGK71VLlcRP/jBC8+tQ1tVc0kBonZJaArKLJh3RNaw9+zV1x9DlpKlMJ8HyLMYpetWcyqLMWt0XKCTYqVyL3y5V1RbGcYMW+1tVnfoyoEr0sZoCRXG4pjBieN9EvxQUOv8Zmq8FXq6vXy+G6EfIvCD5K84SElSvsRA6ff1clkX1yxoAXM9dLBZ5ViLxko4qhQvxMzuOQrTvvfyi2FKpJzqkyqWCBYoS0NR4V+ek2O1rgoSdQ7N6ziCSgMfysMwVJBnnZCFB/jlcnNB2AeDAdh169DQLuRTZpWI5w3nS0eXeBE6LTiHBYIQh0LTDuwzhFJAp9IxsVCzhID31Gvc3ILfcPGfQtlHoPmLYIsTIsparIN8uxWREEa2QFmxtzkwrS/rKs7ncCtdDHgD7UUz5VpX0BynttlVf2Sdtc+uQ6o3rc4QAsKxqspMEPT+DjGcvmNHYGfVex9JnAqZ1wO8MOgmc8lSaRVxltYLrd5g7HTvnvzvWJmkL/nnVbAVjn80PfSna3+GYjpvS/r0+Xsdlu57z
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(7416005)(376005)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 07:43:58.2561
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a808b3a8-3d9b-47d3-c7d5-08dc5eb22437
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5787

On Tue, Apr 16, 2024 at 04:28:19PM -0300, Jason Gunthorpe wrote:
> Half the code was living in arm_smmu_domain_finalise_s1(), just move it
> here and take the values directly from the pgtbl_ops instead of storing
> copies.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Reviewed-by: Michael Shavit <mshavit@google.com>
> Reviewed-by: Mostafa Saleh <smostafa@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

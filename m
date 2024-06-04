Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D5277A1E;
	Tue,  4 Jun 2024 05:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717477647; cv=fail; b=RUSPK2amQ2nHNX3C7A50+BH8BUNZC8bICc114fUP4TFeV+MsTuceAxRWimUyJ6LmqSbbPcE8UtXvg+TZzhHgV36Re4WgW4fP58/m+UQRfE3Fm0bl6VSwT3Yoa3q976pFIuRN1odDX/wey+CgOuDDZ243yZjlPrEdx2HaVHGaTbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717477647; c=relaxed/simple;
	bh=pmPDbYv6np3cSO4wxVzMUILcEr4/O+pCsmzvP5ua4rw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KMjGhZz0JcRYJh1Owt0TRdklAuNxWnBXRPy+szl/pjga9Jae0vNSBkg44KZvqkEIafQfsxDY6MSqXLn5Had6Zjo+5US1F2I98HFyxGkaAia+6WCI0GXbNA5qrbJ93wWdkEyzI+xWHJe1jjntNnv3/apuFAOLoS+iY9bKAtlSn7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Hb+h7M7s; arc=fail smtp.client-ip=40.107.243.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Hb+h7M7s"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXlBJGp9v+rirD3ZiYUnGCeHKhOOwpIWViY6s7jk3ja42YWNgHz4r4dKFWukd+e/B9z0n/5SWeybfUUAc+JdjNl+ajZ9+Ftikp724SDteA/HznoxUpb1S38pBtucJMkSnlqYGonMlF1P1IqXg32Z1a4TV4ldn6zw2pBjIlxxCPRCM2cqNUjf6iGzD6uLN+kYi37iYKfYYpEvUZsxChU5SqOBZ2i2/2s3WQPJaVhLZNKAnjrk+EzIoNg07EnAckNG4Hd/sacfqeB4ACfn2JaKvqYEUyphCGnJbVqXbUfxySLWZPwtlvoWbOU5kHlToGMWCOWH1jOxALetfEFwNtzyKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rSVS9v48QmrY/92QdqDiCa+3ISNoSFfPkDGjgByraDM=;
 b=SwfAr+pZk842QIjqPFgntedHPU85Dkw9od75WGEGgBnL0vFnnrxhFwd7ekXV/0/FXxW5tR0sKmIsCrTHTryxezcoFD39ZWNxjTu7DOK2yEZede0WDKqCbxs7ZFcwON9DR7oIFe2fbsLk/V7a8G8cYWikm9pgeMtDkkVM90gjnoyiQgCLBMxlYOHFCgNKh+NSny+D4mEhxQ4Zy7rzNOOb34cPhmdwbcYZIjFudOcjdPojRI7DV0e+4GyAFPsNxw4DYaOFhHf5LnBeAYR3ewee2Gg8+REWluSeCtbr0T/0wHiuhGiLJvnqZmc0GIbg/BKK1A7r5vHRgWZhtfGidyciVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSVS9v48QmrY/92QdqDiCa+3ISNoSFfPkDGjgByraDM=;
 b=Hb+h7M7swmBybWUWRZaHbCPqXtby6V7fWt5k+7rMxlcU2neUFumms/skt1MgSHWnMp0Lj05iDyrNqti5aCfRWvtVbQqo8iFnzwur/o6vyEFd+GKsx84rOgXDtoM74TSI+hVuOJvYONxoR4o9IjB7Qix/J/Egq3wYeeDVxkChoL2uaOvR548Hq8j3jrtQi8dCxBDYix5yRssizIRAccIKWAVs4w224Os+JHgKvb+5Wet63LEac42i5R1ssw0kxeSYict8S3vEALCiA4uqsZe7QAeCeU6wmNsr4zgWw9eJe39FlPFRE5o/vsiPDaK0/ynzBZNerRsYk1JAslufuPNyGQ==
Received: from SA9PR11CA0018.namprd11.prod.outlook.com (2603:10b6:806:6e::23)
 by MN2PR12MB4191.namprd12.prod.outlook.com (2603:10b6:208:1d3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Tue, 4 Jun
 2024 05:07:22 +0000
Received: from SN1PEPF000397AE.namprd05.prod.outlook.com
 (2603:10b6:806:6e:cafe::42) by SA9PR11CA0018.outlook.office365.com
 (2603:10b6:806:6e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.29 via Frontend
 Transport; Tue, 4 Jun 2024 05:07:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF000397AE.mail.protection.outlook.com (10.167.248.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.15 via Frontend Transport; Tue, 4 Jun 2024 05:07:22 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 3 Jun 2024
 22:07:14 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 3 Jun 2024 22:07:13 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 3 Jun 2024 22:07:13 -0700
Date: Mon, 3 Jun 2024 22:07:11 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v8 02/14] iommu/arm-smmu-v3: Start building a generic
 PASID layer
Message-ID: <Zl6g/6Dz4il+bpU8@Asurada-Nvidia>
References: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
 <2-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000397AE:EE_|MN2PR12MB4191:EE_
X-MS-Office365-Filtering-Correlation-Id: a50a641c-df81-4d94-dcc1-08dc84543779
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|1800799015|376005|36860700004|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CtXCPtfeNBZfXoubCt4s/qL2AriTE++jAyeOJ/fsNCSLaDxg6ms17gfFTOTI?=
 =?us-ascii?Q?x1F+fATDO+FrQe6Y8FReeo33JYsw5CR8CG/5GDt/o3b1cLeMESEkkcDWf3T4?=
 =?us-ascii?Q?ULoGvGAx1mO3aR9xzRv5ah3uqxKTZrNEu4PM45J1g+PskDv+1OeQQps4Re4C?=
 =?us-ascii?Q?yxOZ/Zq7FHhUpuvauh8ICSxtt4QClxmFDX3w8HLkuXHpLsI1i74w0yLMN3gT?=
 =?us-ascii?Q?7kNoXVhIFkOSiEXtoNbColIRZ5KSi4oYN2c2/Py0elF2OETQf8nj5P5ddVQv?=
 =?us-ascii?Q?31terT7C9zidv/Y0sHwqQmWdv4Og4sVmoapW1UhE4h3VAYrehwzAOCTzgEf2?=
 =?us-ascii?Q?Jbi09pJ+SjO68PqNBiactLRydkeft7JasP78LZXXrk6FlyfUGqQsy17L9LWp?=
 =?us-ascii?Q?uJgf421JyN7xj6mnsstqPdEIBgk3RtB/QDlKyudFNGmVdoyMw4NGN1qfPQzq?=
 =?us-ascii?Q?5kCrUbupfyUS3eYZGEU5CCOKn0o2OmrukDyUp+ckHJZm3QAX7Fej/W9bVxBF?=
 =?us-ascii?Q?ZSMPZr4f3XoZhQ1P00yqyVQ856k0KlK+qTDh8FfrLcgEfEvOA1o7l8E7RUlV?=
 =?us-ascii?Q?rgDNRi4lSw54EgsQbjQd+opGTbZ1xLqBIqTqlKYqN8LK0OiaE3nBKNArspu1?=
 =?us-ascii?Q?mecgHL4zUIzWC7D/VRDB/jrNKrAsDa4G4mqv1C1jixTHHQbCatzCjKK4Pbrb?=
 =?us-ascii?Q?FYM2yvl56dHuTDnwjDIWpWuT5vg7i3HIIj1eWiZ06FIYGl5VeAaCb5S3MavU?=
 =?us-ascii?Q?BctP+B+UqNmy3blKuVvBrBWash6fwRXyLfElVAJZ07jeYRVnfgPSNRKmwhmb?=
 =?us-ascii?Q?OHlqZ3sXtp7WBRZr8pqV/qxGAnv88OgbiKgeyje6xPuxf2xKwH6AfUWT+PPk?=
 =?us-ascii?Q?oCs13EMp90KOUt+Xeqratc09KqItUV1QlKBrSp8eiwxl98JRLyQug4umlB5a?=
 =?us-ascii?Q?QufxMEra0OKBlIk/fMPE5609Xe48UR0p2FmBEA/kSN5w9ZkGgEXRlOec+GIV?=
 =?us-ascii?Q?ycB4Q88sjKHLL/vEnv0MuZVlu6iQ914Zc7wdGWVInfLXecAk59xBRr6sMLxb?=
 =?us-ascii?Q?NVqxW/TTe+KufpJgBlzSIsM3+ahJeJXhiPqvaykmixdfQCo8xdmYY3r+6MR+?=
 =?us-ascii?Q?RfNzlz2o+zGx3RrRRX7Ld707IiVditauWR3nt1ihS1N9OjcMVAR1Oy+rfJUs?=
 =?us-ascii?Q?BV8VRZhDIAzT545qUD40mj8/XUMimeEe53YW1Gh7NjCm8l+eUPnlE/nnp0jq?=
 =?us-ascii?Q?fCc5nedGTKUplVC9yx930D9ndBmyFm1NAijtbKwaod8ZLvNn5+7VUWC4tMUd?=
 =?us-ascii?Q?lDDfo8eCQL1ROa1Ua6OcGK26MkFS2pYj86EHiaVnR7Ur12WSDbqbxN5mCj7q?=
 =?us-ascii?Q?BrUl3ioz2TRNt6BrnS5UHZa/8Dv6?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(82310400017)(1800799015)(376005)(36860700004)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 05:07:22.1370
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a50a641c-df81-4d94-dcc1-08dc84543779
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397AE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4191

On Mon, Jun 03, 2024 at 09:15:47PM -0300, Jason Gunthorpe wrote:
> Add arm_smmu_set_pasid()/arm_smmu_remove_pasid() which are to be used by
> callers that already constructed the arm_smmu_cd they wish to program.
> 
> These functions will encapsulate the shared logic to setup a CD entry that
> will be shared by SVA and S1 domain cases.
> 
> Prior fixes had already moved most of this logic up into
> __arm_smmu_sva_bind(), move it to it's final home.
> 
> Following patches will relieve some of the remaining SVA restrictions:
> 
>  - The RID domain is a S1 domain and has already setup the STE to point to
>    the CD table
>  - The programmed PASID is the mm_get_enqcmd_pasid()
>  - Nothing changes while SVA is running (sva_enable)
> 
> SVA invalidation will still iterate over the S1 domain's master list,
> later patches will resolve that.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

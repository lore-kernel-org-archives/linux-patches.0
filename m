Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F69A2579;
	Sat, 16 Mar 2024 03:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710559894; cv=fail; b=dSbvmCwHhOUMR0xITw3CfkjjFIqNfSFUWRa23hiNxckQQYqiVQt57uZBBKqiJr2LnyVX6ohPYZfmTnEVtPhRXb9Awvlyeau/VM7fXekLKZoHe+uqxTrub5NDxynjoOybaYq3DE921pFyBcLgAacHrYaZPwNqWei3So5MvhpjU0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710559894; c=relaxed/simple;
	bh=PDbcgl8LwC9dzCJ5FAX/aGPbR5nGADgrLxoF5RUX1fA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XA4kOkR3wtZM4qAhGo0wVL0lN1BZE6JczW5OUwbVTbqwOm4zG2Xky96slfYWkomJ1dnLxcH6qn40zO2w7lhvukUspIgw5ac5DBWUbAMWuT48OsK8ztgW114fqoI90ARD0LNGFflsW9ftbpW4jl9iifO8tg1oD2G+ve5Qz9aHn4c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=k4n7Aah8; arc=fail smtp.client-ip=40.107.94.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="k4n7Aah8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsdJ9aTYV+WpEH+x7vIhlGiLJFIZ8kQbf95AMh8waZWIH7ETA27JUIQ8ze5NzsvuYpXB4Mj08JppcCDIPl+iPPlqXfAW4Z9DmHLgNUHBo26Qg09eQqFh3WMw16DXb7u324rkg+2xfqUN+fIHvMzURVkhRqHESs6FcHkyNUwbVh5RUmadhdyfPGiKxV3DwHW+iilrLTe+icKI9BTsv2xm31Jejgex884+HL0hVs+IJzWRU7bdFgeT1OBD4q+/IyX7QUD6DFNxv7t2t9ZK7OzvC5HxozjiSH3gJdwmUAs4Q7V6mzsSDmY4oiTKifzO9+1YX6adJxvHcVRWS5dx/pp9UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eH/I8NezRbwSEn9sb+kDGTAtfHK96Zmwt3914vYht+g=;
 b=GX0MGfjBUgB0AX1HCA+T7AMsF7KKgmmfQSehUE1GTCYqGy0NaLGrbuyWHICAXyxLxMxjdtV/80MvPjKqkyyXKGUnXGsAPq0MUlWJ2gAqXB4PAVeQpALfirZOsMHvQ9UpxchjbBbVgwUWDzR/qurtS0CN8dGFgAcyuYjuRTtQEam5goeVQnMmYsIktR6HL6agADm8FNy7GkcVsY+9RCmWOMBBNtOJHaflKiGrDBHCqBLvMF77RmhxOZqaDFl6WTufcYSW5Pq53IpJGzbdYLFKmXA8y4cydjwRSMduFs5JWh9MEPq7dxzKQ5JdWU78v2aWx1my1IxWcrLj5WmXe5Inzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eH/I8NezRbwSEn9sb+kDGTAtfHK96Zmwt3914vYht+g=;
 b=k4n7Aah8a/FAMeyJ/ssmnFfCAkNUk/ps4x6a/CW5FNLJZOFqItNDgl+4QW+kEZc16w4OntX6tDKz/rjpKFd3sP6hV93H1acuGEuSNBHFiTYoo208hR/1nnG+/UcG9qKiL0hBT/YjxzZ7/y7GN1x64eNtUDn2324oZOn5QBvCguBXtzZXzu3VymTSMDc8mndO15K9R0j607o/4eBoHaul9VENKVZahZg8v6ulnRxvXQGTmH1pfueici3tQh/XL5SwYK/5w4lW5Ho+B9VdDeWBvq5VIKEvl8ABmNERdj1ctgTJWUbvV8wDR9dRtDatllfxz1AZvyYHZ+nbldaaYBQEUg==
Received: from DM6PR03CA0102.namprd03.prod.outlook.com (2603:10b6:5:333::35)
 by BL1PR12MB5707.namprd12.prod.outlook.com (2603:10b6:208:386::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.36; Sat, 16 Mar
 2024 03:31:29 +0000
Received: from DS1PEPF0001708F.namprd03.prod.outlook.com
 (2603:10b6:5:333:cafe::77) by DM6PR03CA0102.outlook.office365.com
 (2603:10b6:5:333::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.23 via Frontend
 Transport; Sat, 16 Mar 2024 03:31:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0001708F.mail.protection.outlook.com (10.167.17.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.12 via Frontend Transport; Sat, 16 Mar 2024 03:31:26 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Fri, 15 Mar
 2024 20:31:18 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Fri, 15 Mar
 2024 20:31:18 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Fri, 15 Mar 2024 20:31:15 -0700
Date: Fri, 15 Mar 2024 20:31:09 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 08/27] iommu/arm-smmu-v3: Move allocation of the
 cdtable into arm_smmu_get_cd_ptr()
Message-ID: <ZfUSfcQ41baj4brj@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <8-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708F:EE_|BL1PR12MB5707:EE_
X-MS-Office365-Filtering-Correlation-Id: 8956a11c-c1fd-4450-b9c3-08dc45698f90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8EpB4/j2VOfc5LW5ltz5NNzrrbv4uyCJ5Yzvdzo9NeBCXz9vELWk/9YpODdInqEgh7d3nWsgkBZ7qu2fHAn84Adct7Ulxex8zs5wkoNjFGePY/lJbFGwXcrewZYejS1A+jIoew78snoKPQKuwAGX5pOu6nLS6vIjlM7+vJQFG47/UUrNsqgeNAQaLJDFcAm8v2TNB8lYg4ZqNIQmEOBS2nZJMMqpYUAKG04eocbZHFJi8u9Q0OJTbvxCsPkdkaXH9UKTiRMxqHSMnKCwteHF8hfz1djmCat6WAbtdDeI/xI5Cl53YGOBlEi2kVtKgl3K5dTk+OsX6a1PJg+s/uEn62tPRg9ULVJksI9yyfjXUIDgHfzvfR9wT9EeLZD9Ss7b/xLeNGl3EIslOWWXJ7dgb0+yVO2kTvnXWkYCcFQ5dcmjFB5CMGh++KceMEoxtFX20OccK2aJyyMGeopepB36NoFnwaNnvrtjLmYU3n4l43wTrlMw7msJKDVB0JCMlp7Dn2/tO4wYk8KMIrFWZfYwnzp4HOVZ4u/8HYh6sdQjkNbLR7/xBOe9QNge3aVx7dO2rxM2uCMjju7kIqyYRM/bToYWsluh5Y/bofQ/9GscEn76iJk6m/ljgOFmkao2TJ1+IE28hnA+Tuxr/iwcqC5FU1Gg4+x9dYVuCF8YqzrRPmRozpKrn3bl26REtRb+dajo7pRxrpN9vbDAMsG+rjvJIYk3L0xRdAp54WXTCn+jI2wGTlcoj+qKPShG57sV/zNE
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(1800799015)(82310400014)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2024 03:31:26.0870
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8956a11c-c1fd-4450-b9c3-08dc45698f90
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001708F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5707

On Mon, Mar 04, 2024 at 07:43:56PM -0400, Jason Gunthorpe wrote:
> No reason to force callers to do two steps. Make arm_smmu_get_cd_ptr()
> able to return an entry in all cases except OOM.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
 
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

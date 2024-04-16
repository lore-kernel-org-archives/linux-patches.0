Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A909A11181;
	Tue, 16 Apr 2024 20:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713298717; cv=fail; b=EA1HZHHb8xca2mp1Fa9Wr9+KzZqU+UVUSoi+9hYEjRgowvNqzbSIUPSsZRv5HQMW7f5JZgnZT7/FMMVxwk7J3SaFbpgVrYaao/IgjmyoZS5mW/uErmGqGXceAnIgmgHi8q7AiI66RlIqxyVdt/HsXEwaz7ncX64F2iWXgx2Dikk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713298717; c=relaxed/simple;
	bh=qPr68BZZNJbOYFhiNyB0LEM4SQ9QiNF2AgMw+8FLLZc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VvZebQopB2Ff9IWexTQpXvc0vapzEJv9haaU+xwEs5CqCE7k+V4+WOgm0x+khDOhkG3SjiogvE+WLH/DHl3SXDwsoHPhJRyTuPGNyDjj8Ly4RwfyWTbYQ+915X96cBI5nqQL80nlrg0uwAtZxGkRxGNVJ1E+IJjJ2RSZKNTX6aU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=em2HJ/vP; arc=fail smtp.client-ip=40.107.243.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="em2HJ/vP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J7gdu9CUFi16YRbjdwt4VGd15Qycf45/Ac8j+y5oYMGmYD0Gj1ssm35tYL379b8pQpye4SfZLI1VcwXQkG/mG67kmulqQfPavhqC/Hamb/Ocq82lQ5VCTBNmYWbF3P11y9TK7qtJDF1rhfwvO+7d6yQFRRatE8miKn0PfuYTmCsYWt+3VKgNls/0YrMD7avYuxhHcTRH0/BO2QHR9amp+qW3A1Dgd9Z/UBXDIT84Fzqul94V8CV5Y5wU/S4lzEQn00tsSFmYfefK4tde7o5jA8O2Kzh6/wGBz1y1KahrHWgBjIeIxaOFjcAsv92W2KMRkMlsHOLjvSYcEckabQ+nrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zyz+QqJATUhvNkaewEFckcBktTw5v3gk4KjScsDjtHM=;
 b=iqAAIYrnqC+LQYH6SkOyNmZFwNJj+qsZzMuu3CO5/SsFuv1r7EqK53CQ9YTOhYwcHwB9+/feUvm6FbRYetIgeXcFkZhVHN8XCviNG/yt8t+8eSi35K9+MKBwgZ+d8EFZmusiCizqiLssWLh0IweePZFKijK0JkK+pRSNgQEiesbU7QurpYau4PBmAWvP59QvmxW6NdR14m5TFE91tExWydAUHto3++lyJM+n29aRRIH9gybvSclPjEG5Dq1ahbYf0sWwdoOAKkRrCZWpDaSB4CyUYVrdBTMvinUXXd2OWXoeZ6qdUhWsMwaPlEWLehmymkqk9ySMlKILHkLcf3vr2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zyz+QqJATUhvNkaewEFckcBktTw5v3gk4KjScsDjtHM=;
 b=em2HJ/vPLdSbknv9OakNtXYiRzrkZ9f+ZLEUOdRcHfTayxZNJ6lce4js+P37SS5DUhnoUVgqu2vikWCwDJSvYRqTEI6VBzkfRTB4fbzyD4N+kB27Kl/Bsqj//jt2uXdDT5jG3vHFqtu8Xeag9u/nWDELa7erGSicKzFx1Uk2s2k1j0nYcQif4Sc/fvOpgOvUHaaTC7q2T+LmQRC2W5FzKEpqRRMF9Ni/RzpmNlpWwaqeQopVhgelD9pREY5tKAKIL3gua6imIkwv55HD/HH05aYSD/m0EcJkgJMHy0IXeTssGbBsrPmuYrwGGkSm3tTNbN0x/TlnJy/KESZQV1VjkQ==
Received: from BL1PR13CA0265.namprd13.prod.outlook.com (2603:10b6:208:2ba::30)
 by BY5PR12MB4275.namprd12.prod.outlook.com (2603:10b6:a03:20a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 20:18:32 +0000
Received: from BL02EPF0001A101.namprd05.prod.outlook.com
 (2603:10b6:208:2ba:cafe::a) by BL1PR13CA0265.outlook.office365.com
 (2603:10b6:208:2ba::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.20 via Frontend
 Transport; Tue, 16 Apr 2024 20:18:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0001A101.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.22 via Frontend Transport; Tue, 16 Apr 2024 20:18:31 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Tue, 16 Apr
 2024 13:18:13 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Tue, 16 Apr
 2024 13:18:13 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 16 Apr 2024 13:18:12 -0700
Date: Tue, 16 Apr 2024 13:18:11 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, "Moritz
 Fischer" <mdf@kernel.org>, Moritz Fischer <moritzf@google.com>, Michael
 Shavit <mshavit@google.com>, <patches@lists.linux.dev>, Shameerali Kolothum
 Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v7 1/9] iommu/arm-smmu-v3: Add an ops indirection to the
 STE code
Message-ID: <Zh7dA/XAcVJSzCGJ@Asurada-Nvidia>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <1-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A101:EE_|BY5PR12MB4275:EE_
X-MS-Office365-Filtering-Correlation-Id: 5de642ff-28e8-47d0-71fc-08dc5e52629e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	K5ab8hJivQ4GdeWzCJmay3Pq1bxygtN9xapeG1BUn8mSe8tZNHHVKjRU7CA0IrWQmH7HSUPZ+NNbjB9fRtjnIv0IiKM6OIRsn6e3DE5QRTnYLTXqnJn+mrF6YmFXFvnZQMM7aDqjdQQYxOVk8vsTr5bUSmb2ND2j78nwrBaONslOjSIPRYJIbTwBbs9zy6WYDkCtBZJ4GDJHCxT16B+sFH9uAP6SUupUYfp1GB/3c3bGseAsJOPLzDDZacsDzH8qv8Z50++zbEhQo0/IT442tme0ijPjmlKFt9FfSYXTbGO84vqXBrJKukOOziikOE1lW31xFmT6rEGUK6eN0Eeuo6fI+1EYtn5NOyTAixQI64V+pHgitYtBqDTBANyyLlfX7MSRwLYiVy/IJ/tH0hY9dNbyGzsni1etGZR5S4jt4NHNgOueg7Q+uO5W4DTcu3Sm6o4jLOd0kUkA/3YQp0gBjEMTT7j1r+tIvJW4IJ8QwhHm52I8j33oGgOGMzMoJj3czoEfU0Ca3Jnp/xMcTrvvpRdQyM7bnk13ME41wC9kMXAjf4L/NfHRmZgPnUkWrjjHe1Hx79MaH9qovdycEquHA+x0dNO2/2mFQ4XRlIAMBH34BXBI2mkAt9fR/4f5PSqCf030WMx2GR4CGlgy8RVCJglqYPBaSrblr+O5A4riirkas+MyS+qgTsshWxREJRgSs1Hl1ELddMqVbcpwOU6WvdOwYfrM9KtVOvLrxDba1vLkBM+7tLIa927JIBs9YuPl
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(82310400014)(376005)(7416005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 20:18:31.2460
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5de642ff-28e8-47d0-71fc-08dc5e52629e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A101.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4275

On Tue, Apr 16, 2024 at 04:28:12PM -0300, Jason Gunthorpe wrote:
> Prepare to put the CD code into the same mechanism. Add an ops indirection
> around all the STE specific code and make the worker functions independent
> of the entry content being processed.
> 
> get_used and sync ops are provided to hook the correct code.
> 
> Signed-off-by: Michael Shavit <mshavit@google.com>
> Reviewed-by: Michael Shavit <mshavit@google.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

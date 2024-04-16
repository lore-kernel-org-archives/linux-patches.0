Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2067.outbound.protection.outlook.com [40.107.96.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48ECB1384AD;
	Tue, 16 Apr 2024 19:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713296476; cv=fail; b=VpJI85mYElnjfkqD9S9PwHq1Dnb+BNk1DwWm/Y81pqLeFZi8LMakU+zUgohePj3bogzZy9nSZlnxYIrRa2Lo1RI8CiJqiTlgCsiYDeO7f3zDqI78ysChTIRTtb8KHntYB2mzLdyS2rC32TTKDUN9nDuSJfviOvhGrDHiqpxJvDs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713296476; c=relaxed/simple;
	bh=4C6U0r7hlVPj8fMHoinj8sV189eo0AtvOj1rlDRWN6s=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VwkBVCy/8iFGNoH7J0+HmMmEp7EloeJF9AZpDMb89SNx/oAWxe4K1w9FQ0lc5i3tM9lEJBmiJu9Zhd5fuP8c/s6VFMkz4WnQuop7ndGxXZWOiKf0qFeqZxrJaOV8BQx5VZSNqCcwi2XNZrn+/3wz1ZhxmG4LuD/0XnVLOjptbqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nOTr4pUV; arc=fail smtp.client-ip=40.107.96.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nOTr4pUV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cc3XtXQajstawpEorUkqHjIhywokvizxDGbSri0+QUg8b6lJ8e4amEQm80jVl+5SVpnA1X4SoRKn/as8XHET1aw9XNTypgg+9aOpTKHTSfgLVT/rmSrwaDpu7fnjBv9e3+1tpN84CzsOT8W+2RIHbjceCFA7jRQcA0omsn3dAMCcwRKNuRhQEYJEqkz/J5sspluQbS0rT3hWJSXAPxvzyzJa/mitTApFZ6rY5rHuAC34s45oZgn2f6HApEer75FxpDNKDpSadqP3tRKfUYMqMAG2aEo+9hoXJjRfoXVIASW0UWQMepHHl4qRa4YwJnk431YpYSUO1Ky6CvPqx/2tOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nVPeP2KyQV2le9Rck56YhOEGrG7LsjldqUOUsCx8wec=;
 b=OvZDN92cr5ejBIwCR6OgXZ4F2nqbb9kcx8NOfXE+0XnsG0mHeQsNM8s7RxKzK7bFQ/4lf2hpYIyy42imfyyrLSC5caQkWglY2LaF9Xfryp+6MVUZW7TOE9ne4fiNVqS3A1ji0uk5c7k/aDPfIgx6GPFr8XBTVV9vFO7OPNMINwVzxJSMQhRTPh9r5bR8DTrrTPTBHQM+kgHtc30AIVJahBgjF506Ke3idRsFNJjbRhDHLHuI/Qatw4kXjurA/RaOC5p90bjS7XLiCIR5D/COWbpaXR1HDNXTODpLzhliT7REs50PchopchPfiqVgJgJKDJM8LWYcgXPMc0/4OUlwcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nVPeP2KyQV2le9Rck56YhOEGrG7LsjldqUOUsCx8wec=;
 b=nOTr4pUVtwNOW3b3X4DXnaW/Y+YS42NVfebG8kgUwUHvyFWlbnbW54qIUyoTI3iRXdNlvI+HW+gM8yst+vUGCYi/T3WDYJoRpXSp6BfHyfMKrwgvnMADKOFc/jvPRdbqq9QiSGcghwJmMqzGoPRHCAAX1VPx+t9DWXtym/eBRnYQ7hv59d9v+CbCAbabKf9H0dqc1l1ckAgLL1mjP3TjwBa52YKuFS+mYfs8lEJpyYShIJZoIDpABB8LDoa8MgGO+M9TboRAxEJvkOpw5XOH1MWVwhIrK+Wrty2a5imqFrqXlOVL0amNOPOGiY+a/pXhwCIv/VuHrgeAOyfQ8rAYMQ==
Received: from PH0PR07CA0099.namprd07.prod.outlook.com (2603:10b6:510:4::14)
 by PH7PR12MB7161.namprd12.prod.outlook.com (2603:10b6:510:200::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 19:41:09 +0000
Received: from CY4PEPF0000EDD7.namprd03.prod.outlook.com
 (2603:10b6:510:4:cafe::c0) by PH0PR07CA0099.outlook.office365.com
 (2603:10b6:510:4::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.40 via Frontend
 Transport; Tue, 16 Apr 2024 19:41:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000EDD7.mail.protection.outlook.com (10.167.241.211) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.22 via Frontend Transport; Tue, 16 Apr 2024 19:41:09 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 16 Apr
 2024 12:40:54 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 16 Apr 2024 12:40:54 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 16 Apr 2024 12:40:43 -0700
Date: Tue, 16 Apr 2024 12:40:28 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, "Moritz
 Fischer" <mdf@kernel.org>, Moritz Fischer <moritzf@google.com>, Michael
 Shavit <mshavit@google.com>, <patches@lists.linux.dev>, Shameerali Kolothum
 Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v7 0/9] Make the SMMUv3 CD logic match the new STE design
 (part 2a/3)
Message-ID: <Zh7ULJeTRJp6lRK8@Asurada-Nvidia>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD7:EE_|PH7PR12MB7161:EE_
X-MS-Office365-Filtering-Correlation-Id: a7de7e4f-ff8e-4e47-9325-08dc5e4d2a19
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2fzdvEn6bJBzNwR6/UiiPsMweloSua4BZxTLq0b2N4ubGobfuBvHCB02i7OtWsJxxVP6MxSr+4lBOLWIvWjCZljP29dYKGMdzBwVZiJLHNCJtvL9TZV/NwLQnB8+DZ9fApeQ6vzUFqLKLiKpDLL/LcBDj9q5IPmi0GwfaArhE2KshKAROuvtEMXlUoJj4Ey0oomY+J8kFrPsFgEiU+/kgY3WO3ZZ8lF3jL3XQ9gyVPiukgHgGgSSMgw/Th9rXPPy7FZ28wnpZnjDdBIetWiH3MACDOrCTzq2qV6YxEyAoOLVZwQOHBEg7Vl9y0EzIe5+H0o5lt93jJ3mbxujsUk3ULg6+7ZN+WQwNIHhrhFiF9Z3XxOV+HJRgcvyR/PJU+IhnyUlSgt3GlLWTHbwYPyNytVBFTuXyNa+h6HfOp4wQ/QYnKkcoxXvYnJX9aUoQZFm1TfO1NnWVhoDVpkJx2A9b232JVOF+MR4aOsNrHeanSDJXzsPK8Y9hKUtHsy+HWfl9CpTd0ap90K+RhqUIxHXcLJMddbSF/rnTgRiC9wTknn4tTQOfAE+CoONmr1rhZRCDK8A93Tg7maj4236gduuWkrjOVSQgs2TvBs8IKE755TJQ08lhLqQQooVF491gg9lLAYLndyrR5sMZh/hfdosCDjbHivzSe1EjR32R7VSHtTkOLC1pPvhOnsZbOnTFVkgFyHPey5l4peGXfoR78AX9t+Pxz9fXFWGQbYvUNwfnXJzd4aEuLF24acY8oXbG54X
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(36860700004)(82310400014)(7416005)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 19:41:09.0485
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7de7e4f-ff8e-4e47-9325-08dc5e4d2a19
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7161

On Tue, Apr 16, 2024 at 04:28:11PM -0300, Jason Gunthorpe wrote:
> This is split out from the larger part two which aimes to rework the PASID
> related code.

> v7:
>  - Rebase on Will's for-next & v6.9-rc2
>  - Split series in half
>  - Include the kunit test
>  - Update comments to refer to the STE & CD in the writer logic

Translate mode (S1DSS.SSID0) + SVA sanity passed with this series.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>

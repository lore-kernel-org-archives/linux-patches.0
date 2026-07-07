Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012045.outbound.protection.outlook.com [40.93.195.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556063AFD0D;
	Tue,  7 Jul 2026 07:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783409296; cv=fail; b=CYLe1/+hPONbbrhQw3nluPs9p5GAuFzielk0tOWpR/91ljzojPokIL4z18LlfILE5grFcaNQMqkEcZmOXRf5etp/1gmYvnYg8N75NytfCYuKNDCzRkZ3/MbGnnemMKsPXDpoYHVA+GN3VUqFPmDIpVg21hqTbv2ys5Qx1evVCoo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783409296; c=relaxed/simple;
	bh=3w51Qvq4O23tbWqRGe9h/l8dSRDgbNFhAie6Uc/QCs0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P3K1K1quQwR140rhd5vtGIHBESYULK4Ke3TQcaTbs1TnpBJ9yLvpKsLVJHjs0V+dEeilpCUKFPX7zVlZ/bUfsxuGox3+9fC3VQiuX+CVn37HWMeeSI3O5RQEEdI/4bmZVnySfGwIejM1EQd/XQbWVZKj11+B+zy/1jn144U4Pto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hhKHsWd6; arc=fail smtp.client-ip=40.93.195.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hhKHsWd6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EM2KSLMEby5gVCDEeZjuCNSiCDvx3BREAar6Q45Bfls8WxV94A7dNhkVBreWhMnC8+U5bDrlJfSXw01IzhgY3ZGNYwAAjHtqnxwkkegn0mqu8J3CYlphjZN+Ymu1h9tG4sUZVKndOYuvuXTZaLgcWKeX0tx7OZEniN69tMtyWVOIcR9HSuq+bquWfrJc0/YgKukd1/oNPWKS/0VwJou2HOKqBfV6e/XfGbLpe8b9dtO8tYfXGMPXUwV1b8k91lU2U94bVpzOlGC+aIMKF7KOlkBsANVcYYmWUzknFcVTp52Z1SeihWzHoNhal/pxOuHqpe6JT/hUyWKkO2rzbJUXVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4SxrvfRlwCx6yHmGWeuxkqo0BIqNB1AES3UjSBYTZ3A=;
 b=VZczLf0BliYWQzYzlX9fj9RjOSa9JGyWpQ5+Isn8CW8Z39cXLDZmTngFiIabtGnz1/5OEotzsSf/H/7HAFauoUUT9NUt3zZVZIDJchedAUkKdSIeXoL1L1TBM5ha5SAlVVkSOjJljhrZMV/4lqfg7no/uLr6X1znotYt13ClorR9tFrL9Q0XWZ3Tct8ltrJwN7xN1iE+g0MIjPDIcbffabCeFoKM+gveUMJu6/PhhnAojYsvL8m269fdW1Mq66m1+JB640FWltGYWPhudVMragK0pO6eGQoKfy6Yb+XWFwNkrCIoXo2iVfCLrOjkJc0ijlvgyPiKjtpyNL1Pd1bZPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4SxrvfRlwCx6yHmGWeuxkqo0BIqNB1AES3UjSBYTZ3A=;
 b=hhKHsWd6Tk8zG4oI8fxOrH9NB2pvWoYm/bWVztbuUcdOvO1LO+nlGGRG4uhXHqhdAalPgpqCzqxihAHnkpaxi5J9ZT4oOlCarjAxyTszcxSbWhE1wCsFXdqRW39VhO6bMqgMNXvQ36sqaAIWro+fAj6waEr9NxWdNI4JZATP0HsepNT7xPNqHBTJHPaeG/zxTMzhGNHARY3hVwmVM3JCicmNx1dg8ueLmvp+L6ZYZ8tLcF1PoFlalHkhOCt8i8+L2daS4K8EQJICh1UwxZlK8073IZ31ltIzvmPzdk3ncxcOOOiG2SwvVX3+A7Vc5wa8cv32rUhdvN0kYBTKjCGKZw==
Received: from MW4PR03CA0081.namprd03.prod.outlook.com (2603:10b6:303:b6::26)
 by SA1PR12MB6773.namprd12.prod.outlook.com (2603:10b6:806:258::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Tue, 7 Jul 2026
 07:28:04 +0000
Received: from SJ5PEPF000001F6.namprd05.prod.outlook.com
 (2603:10b6:303:b6:cafe::2c) by MW4PR03CA0081.outlook.office365.com
 (2603:10b6:303:b6::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.9 via Frontend Transport; Tue, 7
 Jul 2026 07:28:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001F6.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 7 Jul 2026 07:28:02 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 7 Jul
 2026 00:27:46 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 7 Jul
 2026 00:27:46 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 7 Jul 2026 00:27:44 -0700
Date: Tue, 7 Jul 2026 00:27:42 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, <patches@lists.linux.dev>, "Pranjal
 Shrivastava" <praan@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 4/8] iommu/arm-smmu-v3: Keep track in the
 arm_smmu_invs if RIL is used
Message-ID: <akyqblHrWAI+S3lH@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <4-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F6:EE_|SA1PR12MB6773:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d6f2920-c11a-4aff-80d6-08dedbf947c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|36860700016|7416014|82310400026|376014|4143699003|11063799006|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	KxIDAV/7gq3ojW4UpZPtW1o8j0emczvVC61eRRWq00542ArvbgCgKUVkjPAdiKBRO4kzJs5o60oVqP7RI7pAx0Xw4wTOrzHnWNT4gysDoWKU1AkACaiHsQESIYREkxcoRwOpgnXIfEQxuzuzRW6IKwlWQViqErCkAG08dzujGJUdMyhqluLhhSDwgsuRrS9ZlwvIWFGy6CkMLh0lrkABCp52nCnfVBNPbuc546h1QPOLpv5loQtEtoHVtWqs9PPPlG9Puqp+VW2iWJobRvyINMCiUG0ezB1VDhSdpYOvg9TaPzeDrPjzG+ZmCw8noUDyO+0O0bbhz8f2Se5h6c1zVQALiCKBpQDPFJRSo+R9g1G6dXIqNIlVj2kQMN0a6LLu/kAov3+3pCsRBvxBsWvmjhOCDUxYqo0GF6pkyw/qiIsPd5FWBU5uKm+YorrnwpRiiWPPyQmnY3iElU9yKC3Ke+ity35gsSQfHsBI5V2gTV2h44yPGgvobB9nwSlmND/Q69xbDcYFYodFvvEAabZGyPDN3KhdKBJqgDXBuX2VoAYztLNmfDnLd8MR1lCthcsAxGK+kv0YWMyzP4llZe1AKWY/eJKiNZeTi9QzeqMvWylf+MEiMkgGdJSVLd8EIW3+1XHG9Ub95MCSUs3bORampQdzOuUVEy1dG3M6BOy4cBxIPGkAK087WYx56xEiFYwjDEOk/G0FG5uykLRSFX8DwA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(36860700016)(7416014)(82310400026)(376014)(4143699003)(11063799006)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	X/3OhGczbzjSl6A2B5E5qNq6tNxQscsJXYLJSZudtDOJ942yaLED6dJnm2Yscv6Voq87rZzhU0FclOVtNwoVx67AMcWwqUqV8ElBRkDNoZ+CFv5eX3ZoIZFx68XIiCNoiiODtyqSDilVaULeYEeiXx079dDbQMJDPgLtzvgCK1Ca5PCjDGZk6m6Ff0mISf2NEYPnW9EmwWAGav6z0CyLKWuHFYOXK7oB8mTTO7ZMpk1wzjtlnTbLCWpH0G+BqVAL+BH0JaFrvDRkaIFsD3o3pemmdzQkGsejDTyiOd2JT0gPdAYPJJvCQqblB/Jo7b9YlFC3/O0moDQr+7uFoN1FzB2PkHZSw+AN4u54CQeVBdfDKptZNPqPiuFCy5pPi6DdVpt2b2TxA3VSUiDoKFTwoZxOrtHuCN7PoVUcyU+OIAz1l93v4J7Ecc7ALV4BJBG+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 07:28:02.9637
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d6f2920-c11a-4aff-80d6-08dedbf947c9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6773

On Mon, Jul 06, 2026 at 01:26:41PM -0300, Jason Gunthorpe wrote:
> Summarize if any of the inv entries will use RIL. The next patch will use
> this to avoid RIL pre-calculations unless RIL is being used by the
> invalidation.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
 
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

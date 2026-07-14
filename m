Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010017.outbound.protection.outlook.com [52.101.56.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53614429CFD;
	Tue, 14 Jul 2026 21:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784064601; cv=fail; b=gqlSjik7GpIVx6UudSX/B4RMFeU+qn3smi5cYa4WhgBDZJA20uDp8R3F/1Z/QxiMZ7xzw0rSQMBn4XqQ5J8LqIxuBljlI3Id3TYu7dKRUkZUn+trhcZhl1iYufivh5ph8NO1JoYz0rAqZl7EXe0r+GT2D0Nt9Y8KdVl+WaAM+RY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784064601; c=relaxed/simple;
	bh=Ezobov1f4x+bGfvy0qmFE99HHzzeegFoC17ctpExxF4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rdtlJg62PBWG7/AnAtA1hCrUCmUUE/Dn6Y2g+Gf8IiiOriGoOlTTDTSVPk8Az3taN9dr875KPI0nCg702oSI/xo1V5BOSJcQ2RjP7YSW+9pESxWx/IHGlBiqXK7Yprg8uOKpsdvVFKpxS4qtwWykO16x7K7jlFzX89S9HWrukqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hIEKwHpj; arc=fail smtp.client-ip=52.101.56.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hIEKwHpj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ifc+yFK95gzRpFryrtWuNQMd3xuwvA3j76EvC9EiCXWDj1Cw9Xe0X5Ok3o9Wfb63H+817VdA3aHG3Ip/V0QZKZfhFqOCYjCDo1ipQJKzrph4lCNAaL3stFL8sbN/XFGfa11hnDEoYRPipjrVmcwc4OnJG+l4Eed4Zhn+q98WRKNr2Kt0ZLeL1k4ufG93UYXRG7K8fZAlXKIZXx8v8FLLzcmFebJQshA8oXV1KYkAmt5juFeA9kvOgaioqprHmwj0pdaudkya/LOFtHRqAnM21ElnYJ4haTEMAJA0R8fHPTnqGyRbSHSs8kiPNwGIxdWlKlih6UTiW1dgzvmeFU60TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WQGKnQDpoUAnNeJZPeWSS/L1wzkDiofjjnlAHJDIz2s=;
 b=VPTzRkJR9pOKZ1Wx12BJQvTZILlgWEeiZtyvgIjNN8/mUraU7TtuHYcm3X+5W+Riy+q+imqt9JjvDw7Fuc7YC6ne6zx9/YUUqa9FCA9+4JFpK/cN6xz8pTNpjcEQHP/rZnXj/vsca/mMRM9h6N7OorfgtEfRkQs2lOgPjIKTzNY6DgBqIyCyIWsvhzUuiiwpO2yfpZuOBsBMJSI8SdpIDvt8kpi/i7C2BQCAa/UROEaJE7d5rCvbWNHIIBX8S6oKT13OiA4zax4CXR1jbRrq2Ji4QmgLExr8ab6HAUQkDXw5jMVVvi1/kaWGsnTtw84PyOU1Alop2zTyjkjPlJ8OBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WQGKnQDpoUAnNeJZPeWSS/L1wzkDiofjjnlAHJDIz2s=;
 b=hIEKwHpjYrwiJOcJJwKQQwbsQimkGtT90S7nM6/JwaVBj/G2PbrVRBg2q2s2H7ongz35mDAzQPAR7yFYovuJtrairRjS1whRYWtFn26eQ8b27L10CZbdRybWS9C/Xsz6cY+FcKRBxTpo0ryhxAY4vefniBuXmZtkMgQ8mfUOawn7zkbTfteA6W9J3WWFSj6oxaEqrTgL9nEBTLf3wD6QXaIcerrxYXs5at5aoOK9eUPM78t7ZBNeqs0XKKEaeKSenN4SyIxksqG0LsKl6n4O23M1auQxKSAZG/AnafaHGnF9bMFrGJP5/c5/ZhWstqLtBj/aATqa+RzVJwImOEN+lA==
Received: from MN2PR03CA0020.namprd03.prod.outlook.com (2603:10b6:208:23a::25)
 by CY8PR12MB7242.namprd12.prod.outlook.com (2603:10b6:930:59::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Tue, 14 Jul
 2026 21:29:52 +0000
Received: from BL02EPF00021F6B.namprd02.prod.outlook.com
 (2603:10b6:208:23a:cafe::3b) by MN2PR03CA0020.outlook.office365.com
 (2603:10b6:208:23a::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.10 via Frontend Transport; Tue,
 14 Jul 2026 21:29:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF00021F6B.mail.protection.outlook.com (10.167.249.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.9 via Frontend Transport; Tue, 14 Jul 2026 21:29:51 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 14 Jul
 2026 14:29:24 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 14 Jul
 2026 14:29:23 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 14 Jul 2026 14:29:21 -0700
Date: Tue, 14 Jul 2026 14:29:20 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, <patches@lists.linux.dev>, "Pranjal
 Shrivastava" <praan@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 6/8] iommu/arm-smmu-v3: Populate the tlbi at the top
 of the call chain
Message-ID: <alaqMJnkplAuT9kT@nvidia.com>
References: <0-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
 <6-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6B:EE_|CY8PR12MB7242:EE_
X-MS-Office365-Filtering-Correlation-Id: 71fc43de-4402-4e59-756c-08dee1ef09df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|36860700016|82310400026|23010399003|22082099003|18002099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	DJWTa4EauHzuO5aFtd+ZUtQG8Aq8RlK9P2MFvD4JxOTVXqZyoARLBn7JqCaU84A4DN4cr9EJv+F2aDzpdTguXlBF76LVPs8v6lTmSeuronyCT/EqJmLIUJv5tzLmJ7U/x8g224JD16d143hIqcGIi6tMJH/8DKNgQKLqWBhX7VGwR5lUjx5xk9xDoEYYRBV4ltQ7bDkFTT+ZEU1yfZdWUnuW4eES9LbT2OPrFcYId1gnAr/KCbwvVo38xEdQKKJgdZgoec5C5XUYR4569+z0JX7vapE5MGKiZCJP0nU6oSnZvn+M2OnqoL0jdGcg39SEEKBJi6P+lt3ARjeSIK7/0rjlRyOyPkTVvQtbV9uRuspWqbJL4GpcPb/jtsYAM1vt+EN5Z0jCiFtzp7W4w4QEOOTxmdb9biGILGqRfiKIUl+RCqmkcEXtIYZAw5gEqQTlbJvNmgakGq3MxEuB1NhhtcYcVg0sBeByHn5dXKalUuJKTZU5JCVzY32ex+K+SekXU2o+SDUVZm+wdtP0tsJPFkUSX+oEcKFYG4yRknqnNbiJkZDLXAl92xiDgaJyjEKMyBjgkW/hnUGi2MbqPwKaHzXn0fqQ85dVImw67jvG1fHRjzmLRQj7BVoTDdAYLVwBolrN5GMsMuWzyRO3Koru8cbhdV3QQUyQrfoCSkFOeUlpBhSsKqm8xItFk4YUqWEjKLs0oYiNJ+4vx+oSEreDxA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(36860700016)(82310400026)(23010399003)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	t6Oh+Oxu68nR626H7zkvIZOn4zwGE3jVRKlA7VZW61l1ypO66ASu8k25xOe+MPY/shJQY7q+3S1XbMtuGG5GIPY5NmtJ3PWC2HT0xD395XZMS0/lXMUYbAXh56FJ9qIM1/N+QGF6hXFxDbNUfjlUhbQza00tw/r+hQGPOD44ZHr/OxR2PO76ZU7Vht+7PWvfT6+vZLkZfMX1Hddz2w1Uq0sEgWPfImqoL6Op4Jgl7BB+hGdI7R18wRR+LiwCNX7taUT276CAEzFusHlXCTtPW/s6s447Gv7XkgtB8Df1JWS9sQyQzhzMm3VVAylFDHeb4eyPG/ffs+ny6tMJ123yXTAcw9Q6j2M4jHWqLWWiNGcmm1l/o7VlWBLOSXfVn5Aak6k+lmwlmoUIs4FELomCK1m6UJRHMKzjvfEIheqRiNdw/4hRIjKsAmgvsX6VNYWt
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 21:29:51.0403
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71fc43de-4402-4e59-756c-08dee1ef09df
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7242

On Tue, Jul 14, 2026 at 03:46:06PM -0300, Jason Gunthorpe wrote:
> +/*
> + * Called by io-pgtable-arm.c for each single table level it wants to remove.
> + * size is the size of the table level and granule is the tg in bytes. This must
> + * clear the walk cache and any leaves within the range.
> + */
>  static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
>  				  size_t granule, void *cookie)
>  {
>  	struct arm_smmu_domain *smmu_domain = cookie;
> +	struct arm_smmu_tlbi tlbi = {
> +		.tgsz_lg2 = smmu_domain->tgsz_lg2,
> +		.iova = iova,
> +		.size = size,
> +		.iopte_size = smmu_domain->tgsz_lg2,

Sashiko reported a typo here, though this gets fixed in patch-7.

Nicolin

Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010043.outbound.protection.outlook.com [52.101.46.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D881628CF49;
	Mon, 26 Jan 2026 21:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769462202; cv=fail; b=NseepwF7VLsZ3CkVsLeIIAAbhGJlIHXlQffguKW/851A2IkymIkplNo/NslMrc89qmwW7p0jAypNZQeDme2jkvgMbrvwwoWfeYhTa5jvB9jhk8IN+YC3/gyjbanuivX7phn8S3sJt9C2intMLpZMMebIJSLHYuGkOEVhsbY2enE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769462202; c=relaxed/simple;
	bh=n9CxL6AFny+Lu9JQQcqtVYOiQ1VBNavmZYWti/7J1ME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AEBk+XDwiZgUzVcpJ+mvi6pep/UVK3YN6ptdyFrcmhzjtmIe6lAXDFJyNg9xV5XJC+HCfS9TmLi47ToJi4x9ckFDoOUYvb9WkXDm0Br/xGotJEbMjaeOXbfiFCbAEFKJzlI2Hzc5Z06HNdi6gp6VPWN0j4pNvElE6k6zZQPbMNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PdzxyX9D; arc=fail smtp.client-ip=52.101.46.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PdzxyX9D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KznIoShwhVLQFyHepURXfSUoUKJrjxW2X7FiykMUv4nyyQleCmMVyeuflmM1+pddg/cabMVtGFjeoWAARKQ/K+9ICopfRzP3Fxga8kDnpFJHlTl6AU+jR1m3g0dBv6FEtQxGxNlhA1gGhyEyQXwoy3RCwUIjSBAaIMiNofAlIvZicSR8YAZiPActiqEh9djWvd7xu3SSEI7rbp5wgtrrUZcflHMiJDu7vnXDQMdfM4M+3wlzLrgXtJbNIqKD/BZL7Lwj8A9el9u0EufnzgMn2Qb39ROBMHDmUyUejl5FyvPRV+i0BKsdGZjIHu88tVHY6IpsvStlT1sDRslBayGrPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KsDJk7TmuEtiN34T9JcEmGQfEcqUKZmpripKUIiKDdI=;
 b=EsEHf3zPoha18sAgvLH1swa8DmpUccoFK8CsAHcOp6nHPtEVCwEaOrX1ihy/sxaBESAGh8RriOmp/A4Y3Ete7BUtOJdOdJbBkshyu3tCtdrpCdiBZwRhtV0cdm0Pa+Qn7gbHm6g3pmYU2SJNS8NpXRS0yiF34HFwj+jRnaK0iNpk5CSypvipoZjIMhMX8qJCQFYJqu+BVpviuOh5+vkGhoDIxzDNICxC0Kz5Ve82Aa4nO393Hrekcv/CO7u8ZZi8bV/vOIZ2MQOSfOe/Q0NLJDCuQI/ctizlgenxM/yI2SMfem7K3vazFbiTVfEcjDGUEL3DLaG173Vt7aDrJ4ppOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KsDJk7TmuEtiN34T9JcEmGQfEcqUKZmpripKUIiKDdI=;
 b=PdzxyX9DVlNk4xIsNLOpO5WqVZIwduVXQAWEo8W0p9sUDKHbuOU7TH/HxeJZ7Az4bIzsVe7j/TSr5PJccQ9WVUiVVvXCGDmKxKKoaq2pjFk4ZUDQmUxfhaivTHCtuJ1Y0uEWiTF0/Lxmmc77gYn1YYvjc3vMVmgXgWYVw3d3+ZjENGFbLW9MCjuuvsH8a0CK17hmdZmvD9IptwI3mgwrT1cDxZNUg/RSICNlP6xJLNpwdoLiysBCYu7XUEKfg2a8UAH7n6sMLL8388Y2MHq7StoiOL/M/GNGrtRY9BMJMpkY3yEmD8hV5FJ5LJvWGLl53orJULVZUN+Uzqv4S0KinA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CYYPR12MB8922.namprd12.prod.outlook.com (2603:10b6:930:b8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Mon, 26 Jan
 2026 21:16:37 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9542.015; Mon, 26 Jan 2026
 21:16:37 +0000
Date: Mon, 26 Jan 2026 17:16:36 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, jpb@kernel.org,
	praan@google.com, miko.lenczewski@arm.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 06/10] iommu/arm-smmu-v3: Allocate vmid in
 arm_vsmmu_init
Message-ID: <20260126211636.GB1134360@nvidia.com>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <3f7c5b84c4f8605688ac08fc2ea2dab08a3c5c0c.1769044718.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f7c5b84c4f8605688ac08fc2ea2dab08a3c5c0c.1769044718.git.nicolinc@nvidia.com>
X-ClientProxiedBy: BL1P221CA0031.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::10) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CYYPR12MB8922:EE_
X-MS-Office365-Filtering-Correlation-Id: a7e8a72d-2a6d-4ccd-3f5e-08de5d2030f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3NGBKfE4UxIc+Ss9IEPWqCZLHBztapGBrlcWWObY/XK4pFc0qTr4itN2g6RG?=
 =?us-ascii?Q?9Y2p2i4wZ4hewAXrVqZCMvUfGcZrLSor/5LZBiyD5c/SoJwEFRe2R+424nZ0?=
 =?us-ascii?Q?NSskfNJL3V/UpTy88SgnbseSuZBuwl9ojwcsfkszs0Zjz5Zkt+CYU+xlVzr0?=
 =?us-ascii?Q?vqFhc/lQZmJuk2uBN9eHMoBHrXqAl0q5oxJNF0FerfmFb1FHzs86Y5UZvV+0?=
 =?us-ascii?Q?qcGmcYYVmKxDVsfwLW8J9nY3LP4OHfuWqac23N0gLLVNWymM8TGlrMajR/fc?=
 =?us-ascii?Q?+vgPQSkSvGE4bZ43lIzZPAruCmRyv+SViaap6Ja2Y/gz4ZNnVuxyI5Vo7Skl?=
 =?us-ascii?Q?7w6efCaeehAfhfZORRJeJPRCVTYbH1koF/zyQ5ybD5aS4t75UThVrMsTyMZp?=
 =?us-ascii?Q?qKCVof0SQ3OX6xcCK3XTuKac2abfE1w1+L1WCoZdrLYPr4cNeEddSRZOKTrn?=
 =?us-ascii?Q?7NzbJXweLecaQz+cSnK2ZbVjCbn3tIbyIihJKLeUlQkHDwAARe5Un5X619vg?=
 =?us-ascii?Q?gWWMhRwpsmthVym/A9YElMKDJQNg6dmCrJrvSmBBeT4I63vuhMc4aU2IlsCB?=
 =?us-ascii?Q?yjzH8AL+Lbo+E6tYxdEJMjc9zXS/MXTbNivpgUFjX9Q6bNeTyRj8iYxtkDs1?=
 =?us-ascii?Q?vmq37vchOX7qV26iBTNmrqN4dMwuahZzlCPFiEZR9mccKtRNuM6lhBuFFn/7?=
 =?us-ascii?Q?c+A/n/SaUoNDWGzSverbeR1Un3KsuGqFAvyuyMULNU3xM8j3rbWaEVglhPl1?=
 =?us-ascii?Q?vipOj5IdDcNhrrmueUYrbAq8zxhbouMJkaybxZu+uHGWvpdU51EGqIStRY4Q?=
 =?us-ascii?Q?eticC7+ANv16Ecv725LHukjiQsrUBEZWgd5XZDR51hT72ZGzc0K9eqekZeRz?=
 =?us-ascii?Q?kEFffnnSF9G5u6NeXPfAZhLNAboUc34kT8SeK5+6bPmVlqjWieC4UfdpMTOg?=
 =?us-ascii?Q?Yg+sYud8hHkckPP/UUaTUtjzEeXRFjIXH/YkGdjAMVXnP0R8dQMKAFZwSALf?=
 =?us-ascii?Q?UyqnKWRp7n473AGF8NZH2HLSiHnSBPPmd7jbMWYc7A2OOezqJp0jxlZ5idlq?=
 =?us-ascii?Q?M4uL+tHjpJNizMNk/b+Ojl2E7/tv0GJE4IgHHAgyXnElx36dEwUx45jGxQVX?=
 =?us-ascii?Q?wgXfzFSSAyC5ScyisVWvsKgReud1iTgzTR9yzf9S6dv1nGplWsh8eTGGZw/x?=
 =?us-ascii?Q?NXoRzvl5k47ZB+R6l8vjEmvyrl9KwB20W9nQV7RE2haqauVSzOTATBoREOVB?=
 =?us-ascii?Q?1pRInlp5Kx4N29rr9P+3+ljXtWvb702UIqiiQysSYkDxctOc1Scnzx7DOgF2?=
 =?us-ascii?Q?nVAK907q07jAYkJzmxVgtmJPpllqWmk0R7AlmDEW0wzWqw29o0V65dl6tRh9?=
 =?us-ascii?Q?HaUfgD94BFiYDEArogINRz7PH4KTCiB5eaVpJE5yuWiwB9zjfZn+N2fKWORk?=
 =?us-ascii?Q?fcEsX2HbU3vVsuYHKz1FMRWKGPU4TEP57i31mVJMAT6NSK0sRiGRCCuhtIzj?=
 =?us-ascii?Q?cAeNRjuqNiBnX8le5DHckKrcx6P07LKD+X+r/Xb9GG6i5i0AFeqBiIe9J2Ao?=
 =?us-ascii?Q?2E7VTHdAOlaUlj7Sr6s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s6gOKKjvx7G8iZRRTIOF1uEqxm0NaURcUfO88mJ70tfcU4uaq0TIirmrN/Qs?=
 =?us-ascii?Q?JstAEG592i0FCv6Kx/Vl1NwDOGDAQbspfFuaabuZmvhRW5CAmdwGyB+bLvV8?=
 =?us-ascii?Q?KpTAMRj0odKKZhNIGN98qkWbykRBTB4Cx8Z1sgZhlIydR8y0pO2mOO1PRU0K?=
 =?us-ascii?Q?KW32yV5fWlh4PrNXDsDOE3D5+Isp6GzxgSGm9MSNahRo+auMGn0a8tE2eufn?=
 =?us-ascii?Q?YB/IzIUZS1rh83XtV4Dy86sbAmjwMFe25wmuY/woz14hI2vp+6eOUb7XRQ9g?=
 =?us-ascii?Q?0Ve7qHF4969BQo8t9wsj02f0rdqaOP83dG+soSi31w3p13QDFws3r/PNll1n?=
 =?us-ascii?Q?6kOCqYJ4OqEP+08ZKgcE1FYTGnDY+1GV2bkXiOsZYrV3pn0cRbrVjvVe9IR7?=
 =?us-ascii?Q?hUPtEmBZoxk6W7/9u3QPR/rcH0RU1sf3jh90JmXjYqAMPY0nAuWCzlHJUh6S?=
 =?us-ascii?Q?mVS98kVmMiFKsNCKxqpiVndPevJLo/5Ew65KWO2p2l5AghNs/aiHWmYLHjPt?=
 =?us-ascii?Q?1NDwb5IV+/0ZzHN118/BD8HX9M5oBd4SfZUEjDGA3/JAzeMkbM6t2WcjPCzi?=
 =?us-ascii?Q?9K/WrgekStcVjluHMCxAKAfEdGzUQPfhnSYi47ynayNMBnvwC85qhyM7kC2N?=
 =?us-ascii?Q?3gTmdkR9ynRdSPSnd+W1hvofys1rA5NEvdu27S2aD0aP5CAc3UdW3ipk4kAY?=
 =?us-ascii?Q?dYzocU4BJXB+ddO4ER/MXpYT+FnXXZV+kO4Iz2a9dIxqVe8fR7YE3ggEk2R8?=
 =?us-ascii?Q?gcGXhRro+Qp7WNG3illoAzm71dPe6u9PGsc4gJEXVv5HOIJpzsO4mo0ek+lg?=
 =?us-ascii?Q?nI+GIujf2IdQJ9Bpm+OVAc4XVD+8MrLJUnT3slrd0NBGxXdgzVuqLussQrqZ?=
 =?us-ascii?Q?RrWPeZzmP63zbqO3Sl9Fey6PnYDgra4HA2XzZuqbByqUx83dhhpN15lgJ65P?=
 =?us-ascii?Q?9oXCFKQbr7j1M3qt9nvmTRSj9/EivQX3yixSwVES4/nuRGgB3RB3D/seThRc?=
 =?us-ascii?Q?+nNDuvgfZKA94eius2sAnCsAEXdGp8oSpEcG6EpgUZFUBXniXGbv6V1rieui?=
 =?us-ascii?Q?CTIjkb5ay/lzAV5ADU1dA/JQ7NhBAxnRabnFKwClSZVOCwLj2sLKy94Ox8g3?=
 =?us-ascii?Q?D06ebRm4gMtXPMuqFcJyzhUXMvzk+UlWMS5ec850J2OlKC4tBJLy5w8PKal6?=
 =?us-ascii?Q?50Nq8XZROnsYEPAR8s0d3XL7SI0PsgzS2ILEYVso9dKa01w3vm6DLlSqThnz?=
 =?us-ascii?Q?YjcR3VN+XyWFp4PpSflSbOsDXJamBbMUmdkKjLcmRf/gD/vBHT5twDDuQIo5?=
 =?us-ascii?Q?OD2i/dlV45A4z7y3KTGv1iF18yV4hT9JMbjSYKYZPqMz+aEN36f7K08aZHB6?=
 =?us-ascii?Q?go029u6hVKqOepljjuqENmPcwsZYXsJ3NYTC4dw7r2BFFqZLVjWQOm4aZf3K?=
 =?us-ascii?Q?zkjXmYMX3GruzA5+zFEypkvpQJVgRZh6VGhHRwZSLub8oCZO0ryizbvdDri/?=
 =?us-ascii?Q?3kpo10OZGHgxJyqr2Fq+op+SUqGhjAcFKRb3K2hPQvHWoNBEvuX022pWUmyF?=
 =?us-ascii?Q?bcE7cd/no9LxnVpC4c8rVNd3dWeOMqA5MhRXEnwj7c5BKuT8Cgm2l+bSNTKR?=
 =?us-ascii?Q?tUZL4yQ8/ZxrXUgM5xDqfeMUs73Smwu9IylSqvqXqyhNmGviJInsttBH9H5Z?=
 =?us-ascii?Q?/6rsLGhWB6uMTJzqi/HS7+Wa9Rq4sR2N3KnsknCfehTuX42tz1aM9vMg+n38?=
 =?us-ascii?Q?0b89SYpIkA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7e8a72d-2a6d-4ccd-3f5e-08de5d2030f5
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 21:16:37.7435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CWJV7S7H34kXL/oT0o97TL+umB5iHeC8F8g25bdRff+bV64nBR9o37N5yzjdDcvF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8922

On Wed, Jan 21, 2026 at 05:24:24PM -0800, Nicolin Chen wrote:
> VMID owned by a vSMMU should be allocated in the viommu_init callback, as
> HW like tegra241-cmdqv needs to setup VINTF with the VMID.

Even the architected SMMU needs this, the VMS (not implemented in
Linux) should all share the same VMID for the same VM.

> +void arm_vsmmu_destroy(struct iommufd_viommu *viommu)
> +{
> +	struct arm_vsmmu *vsmmu = container_of(viommu, struct arm_vsmmu, core);
> +
> +	mutex_lock(&arm_smmu_asid_lock);
> +	ida_free(&vsmmu->smmu->vmid_map, vsmmu->vmid);
> +	mutex_unlock(&arm_smmu_asid_lock);

Need a comment explaining where the flush is.

It looks like arm_smmu_iotlb_tag_free() does the free in the case of
INV_TYPE_S2_VMID_VSMMU?

But this patch doesn't have that code yet. So maybe this should be
merged with the next patch..

Jason

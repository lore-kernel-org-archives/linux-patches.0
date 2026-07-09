Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010000.outbound.protection.outlook.com [52.101.56.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D0B37F725;
	Thu,  9 Jul 2026 19:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783624240; cv=fail; b=kOWYjpgnJ4c0MaKt9sxayc5Rw9pQA+P/2wKfTBW3Fg2uRxxqEIco6S3b/XH8Vo3KkXr32N4gboklG3PXzeLa5hhSKz6jcw0nKkKGPpQ+hVUk2ZiwvF/dVth+WjhiweK2zRW+ze2/U4kiW61YvFsuU2gPTRi65HQHaVHJjSu+7yE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783624240; c=relaxed/simple;
	bh=nkNeJUWDbLDMDRHN+TKhniDKOn81cqGOMd9TOC2B5i8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qsLr7s4fyp6KJlmsqBSyMgaZy/7ekU89kvSm3eb24uzsq6qADZ2gG05WzPtDCWMvW0usYoplzQnMKB98IacB/WpdAWMmPdj/TnWi/PTe9YtxiYvGZf1ZjL6AgKm/irPRucuyEyfbjtH6dWDS4DQ3/9RgI5tU8hvwkDlsZ0cGAX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XvaYT33d; arc=fail smtp.client-ip=52.101.56.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XvaYT33d"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bmPbgSVE32zytyEE5XFk8Qw0ivUHVv5lkCYiolzqgyLQfrFS9Pw3QIP2oMSQ6aiRDN11Q6QXycqQQFhDTD/EleC0jGJgB1q5tu2H7n2HWHeQEa+oknawBAKTgvFeJkfx87cukj7A7jGQqvDVCGTo1PHlr28MoMi9+lsdNmq5RZEJeIaCJvXlZoVQp8TKP0cfLVHubdrXeI11P47+9KeIzzmSOmic0aadA2iraU05ibJQXGYtrV1lynrJSHAfNThs0IBwYkjGD4J+ZFV81uPP+WsF0flnynrvL7KNzGsQNft4+uViLkWYNu9O2zU/IBK810j9uibFFdkbElnDd1JHgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QQftZt+v3sQ5XblbEila8btNC4ScPcFZn/SZpkuj1iY=;
 b=ejnOtvC4tIMkAjGqH3RFhUVnnIo3d65wHOwZM8Pn4qs2kRZjeH6NN/sdE81iG7TyrAkZcqKqMoQKVVbezuF9RDiDCenzGf3sddKZq1DFWfW/3CTKvHKZAxW5tEEHsE3cL7lt7ASGTWr6HEm/B9U4oamoIWO/luklplTo0Kz+spUNdFHwfZCqtcu3l9YR0i/7xiKYzkcJZVDfg9f0ZnULnZ+F/6HADKwxf/+VH82l9lr8vojXgwhjebBVpAAgGcDHh1w41+gGRxgWxrynUpPEyzy7R3eNgqIk5jlj4N6aXZH/NAq35WkPf2tc3EyYr/HkmhnGkTcHtk6fkgJPUD1KzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QQftZt+v3sQ5XblbEila8btNC4ScPcFZn/SZpkuj1iY=;
 b=XvaYT33djWZlNRlNODenIUowJMNaR+E5ccD2+xo/MIo7vGLcIytja+3j3QhYIXl9YAz74u8kET1gth97/ySdwnfRZHJev8StxOV0rS3aGn1jirv3JKLzj8gpHcpZg3kAT7lJ+98BcpAbmqxQvBPoxTvo2+DCmZerN8aWl4BYAlfs8kkWCEB7rsQU0a6H/LrdrvccYUJQRkj0lxab3bjR755aCY0XfOMGMwgDOGyon94NYF3PiyN04IGTa+mimXJW9bDiQKwpVMbBrmuN+idaAZ6UuU/Xiko+es5HuAFMyy4T/o/4Qap5Zr8j1DLIA/49lcqMMdSky50JgRorxEQnbQ==
Received: from PH8PR21CA0001.namprd21.prod.outlook.com (2603:10b6:510:2ce::25)
 by DM4PR12MB6254.namprd12.prod.outlook.com (2603:10b6:8:a5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Thu, 9 Jul
 2026 19:10:31 +0000
Received: from SN1PEPF0002529E.namprd05.prod.outlook.com
 (2603:10b6:510:2ce:cafe::8a) by PH8PR21CA0001.outlook.office365.com
 (2603:10b6:510:2ce::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.5 via Frontend Transport; Thu, 9
 Jul 2026 19:10:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF0002529E.mail.protection.outlook.com (10.167.242.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Thu, 9 Jul 2026 19:10:31 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Thu, 9 Jul
 2026 12:10:07 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Thu, 9 Jul 2026 12:10:07 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.126.190.180)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Thu, 9 Jul 2026 12:10:06 -0700
Date: Thu, 9 Jul 2026 12:10:05 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, <patches@lists.linux.dev>, "Pranjal
 Shrivastava" <praan@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 5/8] iommu/arm-smmu-v3: Precompute the invalidation
 commands
Message-ID: <ak/yDcoX5R7uWjrH@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <5-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <ak1iOWrvLv/6ACsP@Asurada-Nvidia>
 <20260709120744.GF422027@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260709120744.GF422027@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529E:EE_|DM4PR12MB6254:EE_
X-MS-Office365-Filtering-Correlation-Id: 405a7290-5f3c-4895-815c-08deddedbf02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|82310400026|36860700016|1800799024|18002099003|22082099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	KEn7TTBQjBfNlQAmSlIJpm4wqVg43Ak97Z+pH0UWtGzumc6wTBIb+VU0BG/d1H+Jpoc0eY24p1ko7/Hv7QBWkubQbi81gtOufabll2Ct9AHjnFJlhwnH+1dLC0HOXeyDa5R4yUccpfDoBpq0sxZxJzBl4itiX1tSHtremHsoOvsr972dC9/z5RVZSQMG5UikveUYdPtJ47fdDge04kFXj7XLKBmGuOsuFu5sfBDNkGL4RHfxKAl93FvL7yDxX0VI16LvQtIJn1QwECDoPwBGIySUbiZjc3jwDkE87lYHGcXv1wFCvAFdtz/mUCJPzTEyuLBYB51X78/Lns/ZmneHpOidmYORudBlV4OEC/bgVCXTGAZqJVZ8T7pem6v469AYGO4iE9zI65hlFsbFtkmLbjm9jUPT38V20E8Rgl6Y3hhDws+k7UFx25/HpLO+l8mJW8FvsvBwcyE0629OUb2zxto9lz7JfbVOPO51h+qcGIn+Excev4vz2kBOJZti0BuBOOITd4hmC3aikqek0mDjktCKJmDNbXp1tdlY2NQAIuKAEqVvd1JoH1IKTFpdKphLte4w8hfYHUW1wzzhVxBnGSqDwd8uclSqW6SWn2KjMNvk3IrIm499l5iZRNejeOTXpxY4EeAJlnXHx8YJL97e0dZnFR8OQyFuJh3UiSQT6rLsJRoP8ED+1ZsJ/ugZXsatwJPX5Z1LSNP5IltBj714dA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(82310400026)(36860700016)(1800799024)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/m/IlXKDkESwzLoreDvmLMiFehGmoW6DNGeaxftjpLTuEC3sQk9+mbmMDmKk4Jnuy5EYf0VkBjChg0kfSDpb7SzoEM/pTwk4scDA7RvIW/+Z5BRzFJHHI5q1YKdZVIm7OwNljCtDBNkJg6z5dn4lF7DIW3UyYiMuy+XeKmMNzBuqMQwe9x6FNmFVk78oOj98pT/NfbWDjAn/KGlumEfbBJSK5M/CEBbwCM3ex5ceqFYmv0kO2+Flc9JU/+6keiHFWg8a9oflpT7QRCgF+8vPAbRLIkrXD4b2arK4cS/QPSnsb94P7TJottRCwFPoIiHfzc7Mbkr9g3hyFkaJfVRA6euF1N5S1BBvONdWeBPrSO2hfS5nUXVHkpaZamU7EYstXdlHWU9/7pSVJRnVx84BsMIuYZJusV7oVK5zxKxn9rzxauq0FV2Ph7UdILBskoea
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 19:10:31.2945
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 405a7290-5f3c-4895-815c-08deddedbf02
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6254

On Thu, Jul 09, 2026 at 09:07:44AM -0300, Jason Gunthorpe wrote:
> I'm not keen on gotos outside error unwind, but how about
> 
> +       tlbi->range.data1 =
> +               FIELD_PREP(CMDQ_TLBI_1_LEAF, !tlbi->table_levels_bitmap) |
> +               FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | (cur_tg << tg_lg2);
> +
>         /*
>          * SMMUv3 H.a Section 4.4.1.1: TG!=0, NUM==0, SCALE==0, TTL==0 is
>          * Reserved and causes CERROR_ILL. Single page uses NUM=0, SCALE=0 with
> @@ -2472,11 +2476,7 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
>                 if (WARN_ON(!ttl))
>                         ttl = 3;
>                 tlbi->range.data0 = 0;
> -               tlbi->range.data1 = FIELD_PREP(CMDQ_TLBI_1_LEAF,
> -                                              !tlbi->table_levels_bitmap) |
> -                                   FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
> -                                   FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
> -                                   (cur_tg << tg_lg2);
> +               tlbi->range.data1 |= FIELD_PREP(CMDQ_TLBI_1_TTL, ttl);
>                 return;
>         }
>  
> @@ -2513,11 +2513,7 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
>                 FIELD_PREP(CMDQ_TLBI_0_NUM,
>                            DIV_ROUND_UP_ULL(num_tg, 1ULL << scale) - 1) |
>                 FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
> -       tlbi->range.data1 =
> -               FIELD_PREP(CMDQ_TLBI_1_LEAF, !tlbi->table_levels_bitmap) |
> -               FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
> -               FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
> -               (cur_tg << tg_lg2);
> +       tlbi->range.data1 |= FIELD_PREP(CMDQ_TLBI_1_TTL, ttl);
>  }
> 
> Which removes most of the duplication

Yea, that looks very clean.

Nicolin

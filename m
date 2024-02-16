Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375C3134CDF;
	Fri, 16 Feb 2024 17:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708103543; cv=fail; b=S/ayO/NS/gqNJSU7fvAUMQEE+kHs3jVtjkBvr0M6zMsnGY/tQEPpzgc8yqQIQjEFT+tN/tDvcgYgTOv/oIHOgCOHlVCJ7g/KFeMZSxhPz1AWEVU5chSnfyseyo6AF56OjDzWe02Rq0CBsnW1PRLnCr0WFY4Yp0YIJHEJ9QiDiFI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708103543; c=relaxed/simple;
	bh=wYp6oU5inBuZ2VTWuOhv7oo5eX6uKmXFbipcVb0lYyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=W4T6xJ+Qmxkof1pASPeE1oMAiFh2dYCo+duhTUslyZQ+TryGEgmA2y+i7nn/d4Xo5XYyRbWUouo6OANWb2GfuHZyzaNzJAlbwQdK1WyHmK5/KNA8lAaC9wAyi0XPBqTgTOFFoBN3zb6/nVwQRREJJoOV5yCMyxQoFuzzK7jJoNk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KVgcpHq5; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KVgcpHq5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iNs0p4qHwbW8ZxsQFoAlBRIJgYi+jkcD51ejOwATSxAjwAlScr0uutKuRH8fsPh8HS8ML9RcAqkAWjiGVjI7PTWjZwAdqCMx5F9zZdHBsc7YXtrVqM/4zpwVyY/6i8j7jo1maUqMomnyA18+ieIWGl6u97Ey69sonK948+nvKtcmk0ec9Sti9W4TRX7JwkbGgabUNxnW5+h+ahjnuaVCj34owoasbdzK22GkVcuQ/Qu3e9J7yHfsO6aIFnwNhNtkrBMr8T2JstiMqavSL6aD+WP/GdwKQSkANBFlQb3BGriUXs5YNjUZVo3trexNfLlTvrxbBQwMvoHL/5g8q6Si/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G+9dvBbc6jKFtUXGKbZPYAfiG38qiFpWRJ/GIoLcH9o=;
 b=Epmy994s571Dtyou/v/ZUSguV2IXyTDbjoP/tG08ZpQ6y45Tq2AGtURw/mRSLJk2QaBf9c2WdYAkd3NjvS7loBaUPQF7Dqo4knb86Ihwr2b/LmWvpi4SmkpBsz+XxkCcSLBwdIg7wcUU/R4ueQENGhipkjnxOTRO6qYf0iAeVI5dsc+S5NvT2ysD/3WDPQOKRkBNK36lsBLmXN0nSjzqTEM4deO7eztrwojUY54idmgZGDAVXhuMwhzUOvPpbx0N7N/PyKWfL5nfv+uzQFCnMuv2k4P45EiHGjKx1mjVfG8tbSH/uYCtQRkPm9cJQUVlZLWMt7eZibx49WhDBwLP9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+9dvBbc6jKFtUXGKbZPYAfiG38qiFpWRJ/GIoLcH9o=;
 b=KVgcpHq5J1PjxjfSSSa7W7wnoj/8wYnmZ5H0y2GkrUVgEjh3S9B4DfBCCQqJ/RSKEo2IjYV1BUwDdVWMQwtTPDZzNR3o2yC/7roduiRFq7Kpjy+VmAhq2uWqeN2UOPcDzUdQSUpz+0VrwT9X4Rq8dxK4eh31Rau48Y8Zq5rPaUamsMajkOp+goe/AZISrm7udVVvkhq61hl9tqilFbDafGwHEPm+sq0nRec0IAhShSuQhcmEGAKLsQgAWXQzcImLHTiJUjfncWhgPPGs0Ttb9aIWFuTNplL/sEdESEeQGODAea5Sgh3Tn+wmrDawgfvh99EtqhDHhKdZAZJK1QuICg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL3PR12MB6570.namprd12.prod.outlook.com (2603:10b6:208:38d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.31; Fri, 16 Feb
 2024 17:12:18 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.012; Fri, 16 Feb 2024
 17:12:18 +0000
Date: Fri, 16 Feb 2024 13:12:17 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 04/17] iommu/arm-smmu-v3: Move the STE generation for
 S1 and S2 domains into functions
Message-ID: <20240216171217.GA102281@nvidia.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <4-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
X-ClientProxiedBy: BL0PR0102CA0059.prod.exchangelabs.com
 (2603:10b6:208:25::36) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL3PR12MB6570:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ca26aec-abb0-4ebe-3b5f-08dc2f126e07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5yf6NubUqYuj6qMsljmxaO0vdioH2LB0Y8dymulpFQg7N1t9EyAX0SjR7RnLMKk7W++ttGUHlQ+mQhDZmtiog26LrACzO3EjeXtKO0fLV0S7R8gLXa+0ShIAh6s4E/bm+P9XyyFjJdLVvFC48IbjwpqTGtMlAHMm7Oh6uoxQaRPG/44dMaPa5AZ+Gbb+2TpbfbmKgoHZSCdsXVN1u2Ig/qnNZRjb0BVyZG+HIPD/cmAj5a1o9R0lV3q4dmzk8hSbrUk8R+8US0qzWwAZlyUNrDdCJmT14ebEgpYo0KGAT+ux16DjwBgv3GUFizb92ehJxV7rS2ICgKi9VxYhU+Z47aYo/syh9ehH3Gc4WmyNkPHUiZT0bc39x7ib2MtLxaw5IlMV5jc22Z57urWUW9yi/AhmF/0ILxLlmdGmVFGwSSqPUds2ynUlkrnSYE/ATHUcvm3WH3TzZv3KoZJDvk7Vz/9DH2v0AfNIrBruzvCfR6kcuD2ujMvx9tPnNe8JCrIIxZJjDeXHXZT3oBuDYWJpnNG7yjQ7yBn4TGewr6ozgFEzCEyDeal4TRRPfyC7XhVY
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(136003)(39860400002)(366004)(376002)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(2906002)(41300700001)(316002)(2616005)(6486002)(478600001)(6506007)(6512007)(4326008)(8936002)(110136005)(8676002)(5660300002)(7416002)(26005)(1076003)(66946007)(54906003)(66556008)(66476007)(33656002)(86362001)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F8Xh1432QMW2wPOCVpsigA7nVKPhMCo8uZ+sh248L7ZnL9XZnZ68gSCMFc9f?=
 =?us-ascii?Q?oKmv9sG8nGyGS0St/WZHjTFCITcCe3ZzAUKSFLn6QvjjI6TQ8n1CNS0IGO/6?=
 =?us-ascii?Q?jGhE/L9QLLRvuxpGRYhaEQpzRXHiHhezSCRgi92Yo6FuLl1xodE4MLkMkNly?=
 =?us-ascii?Q?GBGmM9i7M0oWUZ8UJsfdboIIBOD1ISjzD1kIqZVax5ukBamAYDCv656gdpI3?=
 =?us-ascii?Q?jOqlKzoWgc9yxSCWxsJa6ofP/VgkRPac72ZC/XiqINV/aSF4oM6YcbTrnJxZ?=
 =?us-ascii?Q?5AjWq11VoyaRhGb23Wm3KF0/OJVVFOUqvUvEr+iG40ZOesvLaPl2Ip43eaGA?=
 =?us-ascii?Q?XVcmgiLvaC6dIPqSIELYme9aEDV7sxxymEl/2GAuwQnG1NDpxiu9qArmPnuu?=
 =?us-ascii?Q?/49FQyje0xPfMnydIHTFIGAZi+z4xrl/G4FF9u9FcQuy/KuCSPWJxAtx25JZ?=
 =?us-ascii?Q?clFmf/B4sdUog5dPCzFwsTRM3Xuz5AemtVQZH6hgrS4QD2IwTAj3YhnBCA48?=
 =?us-ascii?Q?9L/eO0zJ3rG53tOaPdKQlWMl38bn2yoHZe00+aNC22mbLzf9O0Py0CZRA6fd?=
 =?us-ascii?Q?K8ymv2c0/qTDvRRNy+twUtAPVUkl+oN2T1opEnffHSiQJWo8Dond/p42daha?=
 =?us-ascii?Q?Hcad+uid55PcJsn9NhUGNjpyfBh6Plj+OlKw6A6Z/uwKUidCLJlyLSXbdRGp?=
 =?us-ascii?Q?sSLtULqBoZXOeTFBpSGaILqB6hQcKgblBUoV75qfxiLH9PAsr/Rrs0vCQs1I?=
 =?us-ascii?Q?7XuHJvD9MC9igIVvRRvccVfwWiKQzlPwhAlT0dWVP4NhxxwfxBmdLaJBK9LG?=
 =?us-ascii?Q?LNcG1zfANXtNhY2Gx4AuJB5ch0ulHdWWXEal3NcIOpIY46q3HKXr3GCA2wlt?=
 =?us-ascii?Q?1/tV+F35OcfZP+Zue51iJ7yXoBKFweqkt0TJ1BEmb/OxhJRUuXYlBs+Nzh7W?=
 =?us-ascii?Q?m3VWx/AhhVrZKy8A/5aYSu3WjQUh+daG1PNefBfK34AoQnW8dIJ4sazUzZvW?=
 =?us-ascii?Q?Rv12isa0Nm6Jwt3Qdh0hiqfzFM/KF9BOVTYWFyoyNLuuQLruHi7sC6ULyMFl?=
 =?us-ascii?Q?EKapGa6ABIzzDrHeGGT5xmgMucfrb16TRrbQ3V/yyN+4sbqExTUzvcKWx0Z5?=
 =?us-ascii?Q?E6KefhnIOhOVCuaQykrRwITE470r5fHMjhjq846JrErveCSi5hHCxaSnozIC?=
 =?us-ascii?Q?RKVTC6kRxHtmhc8qLzdsYgkgOiQ1QDHr1OXCa1L33Af5UAFhGI7bcBfYn5Uh?=
 =?us-ascii?Q?fWdf6hc+MhPjtzGbTU7ThbjN1AjQxERlVPpYT1a9i6QSG3e6UKQxwXxP12WX?=
 =?us-ascii?Q?xr22OdOrpS88DvE+Vt32A93CgBRUHtJyjkrfEEdvqkC6q5M//zs6NW6ud3Xu?=
 =?us-ascii?Q?BUt4F2m54dy964O3SyKH3SFbSGCqepA0YvNuresy3z6UCK/tQmxxHPckiDy1?=
 =?us-ascii?Q?TDkXFPgNA38hRnZI56EvL+0rVkvPHDO8MvwFemd8f1mCDBVee08e3Xbbs0pL?=
 =?us-ascii?Q?pfdO0nGw/qZos/GwOUeXkoHdJyDaiCTtZkx++uGaisTs6IGpDee/LtMjH2ky?=
 =?us-ascii?Q?O5qtflkOVgVmat2RSJKXvEcYDoZ2VdOC95OQz0Il?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ca26aec-abb0-4ebe-3b5f-08dc2f126e07
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2024 17:12:18.3254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /+peb2UnndMYh6nHJ9kASC916C+ErK+zdh4OOi/G4KsZkDkvEyNruN1Kh2SRwaPv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6570

On Tue, Feb 06, 2024 at 11:12:41AM -0400, Jason Gunthorpe wrote:
> +static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
> +					struct arm_smmu_master *master,
> +					struct arm_smmu_domain *smmu_domain)
> +{
> +	struct arm_smmu_s2_cfg *s2_cfg = &smmu_domain->s2_cfg;
> +
> +	memset(target, 0, sizeof(*target));
> +	target->data[0] = cpu_to_le64(
> +		STRTAB_STE_0_V |
> +		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS));
> +
> +	target->data[1] = cpu_to_le64(
> +		FIELD_PREP(STRTAB_STE_1_EATS,
> +			   master->ats_enabled ? STRTAB_STE_1_EATS_TRANS : 0) |
> +		FIELD_PREP(STRTAB_STE_1_SHCFG,
> +			   STRTAB_STE_1_SHCFG_NON_SHARABLE));

Just so we are on the same page.. The above NON_SHARABLE is a mistake
here since v1.

It is hard to follow arm_smmu_write_strtab_ent() so we all missed that
the S2 ends up re-using the qword[1] that was installed by the
bypass/abort STE that has to be in place prior to installing the S2.

Only the S1 path sets SHCFG to 0 because the HW doesn't use it due to
the current driver not using S1DSS.

Jason

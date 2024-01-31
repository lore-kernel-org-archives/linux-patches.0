Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807BC128386;
	Wed, 31 Jan 2024 15:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706713522; cv=fail; b=YXyi4ya59ja+YYmJ/VLIKanuJ2KOkcLrxrpI6EOYHnYUtivs+t++uI69JMKRQYSufaub9HLK94tGD4vuPX3ItPDrdBMNU8jr7sklKewZ3AVkd6790x9jH2+YPAVphe6kL0OopFRZIYpKgubQ383UHBECTy+R2ejwyXevxb8LsQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706713522; c=relaxed/simple;
	bh=Veokkkp0veb6NId/eO7RGLBI/IQsmuaErfAKyDolfgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PF0r64T8e6WTnjvwB1eaHguLbN81YY9I5+CFD+zQ5JrjD6FxaG9SbISm2uhhS/khpSRAVg/tIuEnZdSnwX7GW7MFf1ywbysGiJIuRYK95ElRXlqQRG9Dci5ULonFzx0yGKmHs0c/gEP0hFJ6SRRGz2BgWP0+YgyDe4UAEdHnyBM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ICJRT/js; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ICJRT/js"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OnH22zqrccrj9UrXjpHGydZhVdDkXfvPqHzM3ThwvJfGInJhWutKkxp42WsZMANOpir3q5SQ/iQ4GDyQ15Rp36av7bh4sNyo9M71EKbbx5xEymDwVnFfPpqDncqyo/j35TSqOKNRazZawL0Y3U969BM1yYwqtXLoLoAFQ3VDyVJXjWzqD7iWGgfETJbLSCHvLIb0KckkkJ0Sw32nSn9htIErijjzPkuX7LAQfyhFpoJX6vvKFsjjc4bmF8LpxsloEZwEyQWuVtjn9Ez1GkAle9cFWnPbxzBLOMR0mQvfyM64tOqvxiH3EMpBebG+zMWR0WWziIQUYImGpHS4FbQtMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HYzCtf2pOpmLzMN13R5n6k04VfCEhNcm9iqfu0WQp1o=;
 b=IKfMCBnXKcr/o83hU0HomlZ9TE8C+Ylxu/5a6VT189qn/Q+DFmaglt6TnwfRUxE7wWjIsoaEDaWD0V0ykT2UwfSQJwwIqEUudMLSDi7uv+J4zzc0tMNb+CkcrPPCSp4Ao990nsvc7IsWI3cG6gnGcdSyWkP48u//DejYZdN7AGch9kVW/PN12z7hR0nbf/X1mdAiE8H9/g8MReJHChkJf2xt0FhSwpNzw6M9+UJSlNqp6v6pIxo4ueSefqr8JbS/Mn3WSAnzhY42AuwKcgxjlIoNayq/m3gT5BPSkNHn3ia5hqwYs5FuocmJRJM2Dm9+jYCraHFiwOsFwc+hFfMkkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HYzCtf2pOpmLzMN13R5n6k04VfCEhNcm9iqfu0WQp1o=;
 b=ICJRT/jswyruEz9twCh5iBJMuit26WS9KuTTf/BzL19lm1w40x5bonC40zHq41Yx2t+ibTO24+J8RsZFeHt4fv1Gmi4+cgmReRZe222PAdlWsZmATE5KT+aYu8LjmebUqlwqul2WkK093hl/YMf5VmTqW4fcxxcEGerjAQnH4LdUAbR9fD0DjNDTEC2UaXKQusCcPM0mGvulh7BjZmJTVdBxaW9bfecB2u6JA5vhE/+YCISMKjljq9upUwr2BFeQ6uTDRMySogZl6PFuJE2nMLj7qkwwu2Srkg4qj9JfAmKy2yzUvoRC0TtpzFJDxdPQLseYPvBEFgTBIXesadIfeg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH3PR12MB7546.namprd12.prod.outlook.com (2603:10b6:610:149::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.34; Wed, 31 Jan
 2024 15:05:15 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 15:05:15 +0000
Date: Wed, 31 Jan 2024 11:05:14 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v4 04/16] iommu/arm-smmu-v3: Move the STE generation for
 S1 and S2 domains into functions
Message-ID: <20240131150514.GK1455070@nvidia.com>
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <4-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <ZbpeQt_nyCiFRrcv@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbpeQt_nyCiFRrcv@google.com>
X-ClientProxiedBy: MN2PR07CA0006.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH3PR12MB7546:EE_
X-MS-Office365-Filtering-Correlation-Id: a7ce927e-4efa-4484-3c0e-08dc226e07b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gA6b5E8kH+6TXRwu89RczudWVDPPOe57kiu8ykw1R46hGHnGcqa7p5Icxlsi+VQ5rypJKTq4aVDbvtPbaDxgf5LkaokL++EaU8hNTb1swGqKD62QTnmfgf8AK5XrjEZf4YxkWIbBDvjNi/Gcc0uMZ9r3tPtl05XjHqnNrBx9is4nPMrk2KLIcGMB7dVV13jfnsSPuuKr7mhmtou8hQhP5EVP706JZoRxLFjn+KV+VqL26Tlj01O7x8XmT6hmBQqHHq4DjLgirHrZ4gWSMfW5HRQvXSqcgMWDhYjDZPItwQsnOleBKFgJdGPYj823/uMZFq8SxQkmCiqJ7FphmPn7tzbUYXTMV4POcJ8connR0sRPkobIMP89TxdZczPEfNBvnVpRZdzquJlXADpHYvBwsyzGuKMyZEq/lQYu0GcOHOUso+Cn9CD2J+6tKjlbwOodBttP3KsbdqqaqbG5ndV1SAk2x7ZMsaqbygPiZwnwoLvN4K1fJCuyd38Jl9a8P2mkZy73pErMqp5ZI1uvxN9YQM4vwOlj5l1n5ItimkcHVu5ENsXX/+Zj7Zc86r9IVxPl
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(136003)(376002)(396003)(366004)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(41300700001)(83380400001)(6512007)(1076003)(26005)(2616005)(38100700002)(5660300002)(8676002)(4326008)(8936002)(7416002)(2906002)(478600001)(6506007)(6486002)(54906003)(66476007)(66556008)(6916009)(316002)(66946007)(36756003)(86362001)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HJAjc0Vb+vr819onGBi7mNYLdMt5wHSaFufpA+Hc95h+Ty77Jg6RFI/b28BC?=
 =?us-ascii?Q?J7finsyX+gwyrPJeyYHdKonmcMAef2yejg1UjX/uJaImKeV3SbFQA9GqjERD?=
 =?us-ascii?Q?WIVwbgbktxmRrf5Tp9hr5ojHpkVPma9N3+6RIUluZJQgkdYYIuiGyFm0gSyh?=
 =?us-ascii?Q?gaDHdVsXc/cXc/FUsiEnnOrePl/7GjCo3Nqghgx7sLGzVovvXKmw3PxGthXJ?=
 =?us-ascii?Q?Laaud2OPalrQ/naJSQzU496ldfywbNqJOjqQlkKE1AuqnVJV44C0B3f+eUhk?=
 =?us-ascii?Q?WJGGFG0E2QNl5O3bt8hTxmUKyAZYh6ambiXHIYdcBTxIHMQksLJ+LQ8jLbLz?=
 =?us-ascii?Q?yKwoTT3UzwYqtuTo8aMSGT6xqy/LXgypEOfOf19AH4awNLBggMgr0rHff+wJ?=
 =?us-ascii?Q?yMrmRoQMmmPoxq7fW1HAtQeUYUeAEENdo9rl5rX5CReYlJtYHsGcpg45aono?=
 =?us-ascii?Q?3TlInO8RM/+tGVtHFjjVb1bkk2NDFIHmHv1/ECW6tljS0kR88vyI91v87BJw?=
 =?us-ascii?Q?YMmTjgCYFH0emMFNyuHvRkpZQFXG3kGI9/+z2p3w6OrmFXlnXPpgrKcyFpPn?=
 =?us-ascii?Q?JkZIGhx2CV7qngYa36phIoRIcTiTK7PMYmn++TxyiBYsyvd4W+rQRrHM57R6?=
 =?us-ascii?Q?U/qqbvtNgQz4GDrej2fH48T7RhZ4Hs/PJR+pwHMUZIAGJuBVKSGAFkkTjOL5?=
 =?us-ascii?Q?Y47P10O8RnwGnxT3qc3erSDjEEPwCAENm6UPMkq2x5SogRavRZ7MkNbgBKyl?=
 =?us-ascii?Q?9OVzhpKbLCKS7+w7xTIBn7Fx+61J29Mm1WkDh84k1oB7rEIsKZL+Nl//fD03?=
 =?us-ascii?Q?ZuG+fJSYPYehhudZci64honFa4hNR3wcgySbzvqUvHCb4u7lE7U82C0euL8G?=
 =?us-ascii?Q?jmF5894HCEe6MHF/6JJR4mlO20jSxds9sampvDs2IryBKaPZhzAa3Hdyj+LY?=
 =?us-ascii?Q?S/kFLEP1JcZk0kQPcw93LSvIFLIxh4b/zLecl+vGnUFoVJKwNv1vle0Vg7ey?=
 =?us-ascii?Q?3TJTxwspVV68+o7zAT8134j74KmA1MlUUVmqYh7xPhETyYXaeS/0S/uGmJs5?=
 =?us-ascii?Q?LASF+D7IlYMIUck6RljQyHRT5Pk2GtRpUB5yEDMblaKxIdzOHprHmYJzeErg?=
 =?us-ascii?Q?vKDeB+Ff4ba3FVjWkME9eLRi9AYqqug3SzZqq9d78cal/C7GcvzHAp+1lwr6?=
 =?us-ascii?Q?bXpp6XstuTh5YCOLk8xsK+yl0bNgpzZ0RJlFxIgXey5z/SnTgiGK3whXRaf2?=
 =?us-ascii?Q?1N5kizHXwwHZSy36Cgwh+K57fo0oGAsjbwEooVGiGlpvW4oovudQemHERxCk?=
 =?us-ascii?Q?6P5xv4oOlwkn0APZZpBF4o4fyjSrz09L8M4k5rzrxCg4+/cREHa0cE9AMg83?=
 =?us-ascii?Q?W1gw6O+YpgFPVAxbVaW/LKGpNL+FuHLZkxmDE2rus2lIiUkn+h8SSdSMCaKu?=
 =?us-ascii?Q?YNrzlOM5r9p6oVW9FtgwhGYT4g6tCTrSQd32rmOWZQIeNq6bIeo72w/u9y9A?=
 =?us-ascii?Q?EKZ1ct0KROIsVKvmQCbU5nGXdrjeW6seGWH3aKhHR2B4udNLbgbpQgfmdgkV?=
 =?us-ascii?Q?KHzfXdGBA/wtV7KykhesncyfR676Wccg9ILvxSgw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7ce927e-4efa-4484-3c0e-08dc226e07b3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 15:05:15.1684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hz24akizgk8AZLHRiZ5MoFFsVgZN2RFcmV9Hug3yP8B7tDvJPuGN1RqwZubU9tyS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7546

On Wed, Jan 31, 2024 at 02:50:42PM +0000, Mostafa Saleh wrote:
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index df8fc7b87a7907..910156881423e0 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -1516,13 +1516,68 @@ static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
> >  		FIELD_PREP(STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
> >  }
> >  
> > +static void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
> > +				      struct arm_smmu_master *master,
> > +				      struct arm_smmu_ctx_desc_cfg *cd_table)
> master already include cd_table in "master->cd_table", why do we need to
> pass it separately?

Indeed, it could be like that, I will change it

> > +static void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
> > +					struct arm_smmu_master *master,
> > +					struct arm_smmu_domain *smmu_domain)
> Similary, master already has the domain in "master->domain".

A couple patches further on will delete master->domain.

Thanks,
Jason

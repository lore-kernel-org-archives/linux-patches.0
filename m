Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47D38821;
	Thu,  6 Jun 2024 23:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717718367; cv=fail; b=GUG72Zlb6u+kI5GTtu8/7Y+xwxFtZxppGJBTFhvNQTLapAUSyClS32p3R7HY5fyLoJeJkS2FXnAMEiH4uCleYp3loTqoJE6q9zjO8HMT/xjgSKD0q1c/Pt65YZ9qatAlPVnkuFf5cCHr+WJW9AkvTO8m8box2L0lFckyoej7OjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717718367; c=relaxed/simple;
	bh=j0QP9A6YD0OeELCyAI7vzANmr3y2mgGD29NHnrqE4a4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AgROUx4MqoWD2GeNE/t2ONs5lvf+SQNXMPnmVhxvUdhk2w8o1YZydAVQS+Bc7fZ0DiuHXxjPxUjeHTRP9QQCtSmKilF3aTQepCS/AFvLcLBKjSR+tDx1rw+IbXb1PoYJwsjrtTrce8U2SPZlLzA1OsPn7ibOpldiVIen0slCZNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bVpx5M0A; arc=fail smtp.client-ip=40.107.244.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bVpx5M0A"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SbYpbOXjV7rratfX3xO9aFXb8sCP+vzdLS8VM5r8gCDvxkcLRNlh6bGtkTg0GuDC9rUGgLp9SvtBV8ws14ATCMPMAKig97r/swj+5iyo+6wM48GoYxG1WrOD2YV/6KcxXBki63OkKMZlzNlAzod5Sk9wIulC6m8o2dalcUGQYdnfMDGZS74wdQQVY+fC54+dNVtfAJdYLq0hrpSZ0FsWo/MCkvTSmiPTTTcY/V6L0Rj5KJQYpGm8xVLZnXTp4QHdshlXSATBJaqw5uk2x4NegXikPqdLjBwLboTiZiPef4NGPYppjaj6LI7cWfByhhVDbN38pGzhiwi6L7xmCbNZjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aIh2KLLi3tui9k3e1EipnixACNouG/VBm31T8/NSh3w=;
 b=cGKa7g4/qIIQNHjY2dt8OZ4FLT1U8bNqdgiyUevuim+mgUo0Xxhqm1nW8l+eewJKH0uAuRT4enSUI28pcEvQBgGQkZ86ql2KbEJAI1bfA5ssgSaCOSBz1CQwPg8j6j7RO5eRfQU49W5YYCU496Svb2C156WFnEjuTcSZqNxsEb16QMzcKGOxxQJgvhQ3gktoqpJngPaIxlqMt3ZJ0N+GAuUkWQikheUweBSuOsEVcjoEEZ4NWoPV/eRmsu0MYNwWhPUEJZlPO719YWGyoz44nkeqjvjAJMZoumZ4tMOU7foYmYgq9Tla3H87Y4R+PFs//uJAHIoCMCpc1IR13k0N5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aIh2KLLi3tui9k3e1EipnixACNouG/VBm31T8/NSh3w=;
 b=bVpx5M0AyYHKAbcdO5HUPv/ij5P4Tmoh7gA0IGohC8jdRvBGJNxQvlHv90smdLFlP2y2ex6n16cg/cfH35mAKsSdWPViUW6VfcKQ9e5xTfWUXcQauCT7cStOnGYUYlBC+smOQme2ulGVy9NbMbD6koYdT3oxNZztPpajiUhYXbHZGaeXlzLsPd7jkHBmdrCK7iwV/tu68uORhei5iI2Aqupma9OrEPyVlGBYxrmhdRXH0KBN64RvWH1FXyDLaCVl50s1M4azVdb0taEVBkyc5XAMylIfVtoCeWFNWZkixpX2OqA4daG3tN99Is5QQJiev4Xb3sGmAejh7RtDp5BWfg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB7172.namprd12.prod.outlook.com (2603:10b6:930:5b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Thu, 6 Jun
 2024 23:59:21 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.033; Thu, 6 Jun 2024
 23:59:21 +0000
Date: Thu, 6 Jun 2024 20:59:20 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH 4/7] iommu/arm-smmu-v3: Split struct
 arm_smmu_ctx_desc_cfg.cdtab
Message-ID: <20240606235920.GG19897@nvidia.com>
References: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <4-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <Zl87uRwIJyfMW1xs@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zl87uRwIJyfMW1xs@google.com>
X-ClientProxiedBy: MN2PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:208:c0::29) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB7172:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b263a88-740f-4ec7-5fd2-08dc8684af32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X4Cg3EERsHee1nfOs3UuncrugN4p+0xzkEKtNecS+6tBRkewC+7dwafwBb5O?=
 =?us-ascii?Q?Bn7pm54OamfGQiR75gzfZaTlkepQEDtO/Qv096o9gZUEbdzEl8BAvGe2ItRJ?=
 =?us-ascii?Q?8I4i/JwuujhIhmaQPs8U0CmD8LYi4jMsmuYJFzEyQ5+ldfvUeQUZ65u7m1fg?=
 =?us-ascii?Q?U6lTD5KIGmBhnHznMKk9rCea16EJsdnTEyqlYgPhPXYoJLsWte+QR1r0koPv?=
 =?us-ascii?Q?v6BhABsn0AFJPLwq/trKdRm81CAsVzeagmxkDVtDyfb9i2Yh9PGjPao0XpBa?=
 =?us-ascii?Q?Ca1T+42ArEno9kR5fAPxta/JBUxK5XMqrMPK6nndaEY5ZFczZ0iIepRy1XBW?=
 =?us-ascii?Q?7lmKJ2MgqWoahEXtlL/fmXpPCwz7oT/vu4RsQ4zdDWLFpZuwD3soasFb1ybi?=
 =?us-ascii?Q?F3NYmhRmYOE/3Ry0kAGUXuDKLIe7VIK3rW/HPTulkFMAjYRAZNCj+yc2mbuy?=
 =?us-ascii?Q?ofyxGXNhxAewtCY+yPy18890JSwjGhqdqo63Pa9I8eZYPA8W8T+f/mQ8ZxSH?=
 =?us-ascii?Q?h9E7BtyY76kRc1Tb7aVNv5mobVf84sg1rGh3wkZuTUe+b2gFq+Khh3tHm2bS?=
 =?us-ascii?Q?DA0QsEFrn7z2VntxwYM84Uhi6rG8uTRZbnMkt430gzihFwKKyGZ3n8nKhRHz?=
 =?us-ascii?Q?i8qZkUb6H+ORkDKkRCrEpAy6gIH3nYwJhm3H1+PihuhlQR2Sbrh+ne3olF7i?=
 =?us-ascii?Q?N+RePuTS2Qn6MdgjyQX1q4zbxXkSrt6rOjltgbR2OCrQ89kQ6mqj/miCdq25?=
 =?us-ascii?Q?Jrl/IhxAO0boGERYhYHMrBwdCkgycEv/ZMqPNIUd0CelQtdevuFM8ncGDwKV?=
 =?us-ascii?Q?7CB+ase0rZjiQZNgMvPlgF3C7SfDkQH89byhwKBrScpD8cr6xcUEJ8kACLvw?=
 =?us-ascii?Q?f5AFx28Dm8A8CMWcEj/xFMwhdAVVqxatLKR/fGQXoek4tLYAVMaXbDhVvfBB?=
 =?us-ascii?Q?X/q0P3if9Fixacw4OSCr6nspHChpPsrimkOU1BckGShfhVkzHvMbxkzC27ur?=
 =?us-ascii?Q?EFs6XPOjqHCVXHozHX8xQSMlKwcImRefXRw65XVhrHMV1U39/+k0z0ZyTkfI?=
 =?us-ascii?Q?evg0Nt7uwU8sSonaEPHH3k6payeMyPJQ9hMGRhukTv+OpSnph63fIppFzZkz?=
 =?us-ascii?Q?e/tM9PxYjaZkCN+Lul13+u2yCbZmAc+u+wPLzaUgJ/CD0q27ypJsDbTAzQLn?=
 =?us-ascii?Q?MzHKWgUDdhGxRwVPYrKsbUCuEQ9vwjt0Hg+G3qyYt6wNmqRCHpsPAXcJnlC8?=
 =?us-ascii?Q?UhD1JF8XDnExAB4fU0PHJW4iV4tXx9qZJtvVl+PBXwqvEWFzu0I3pBmW1G9v?=
 =?us-ascii?Q?YXI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fv9QsGQPnBs1ZzusoDwmR49BRYLFZVoeoXuP84LKszs6wBRK3V1tpAuJv5LI?=
 =?us-ascii?Q?X1rfdHLKmKaizJHB9UiYwz1+UYHIpc2htp1vhjKp6rgvxXoOJXqgbGMtQm8f?=
 =?us-ascii?Q?yk2ArvZNBiL8vxMS9QYcpIhA/sPd7wzBGNgEaihYM0qLTvgAGD+G01a01op/?=
 =?us-ascii?Q?Sev9/s2h25PV4i+fb8SnJCmEVU+irFC2FpdezOoCEdR/1LNG12pyvvogg44U?=
 =?us-ascii?Q?YF5ikfl07++7rZCWLp2pZpiQ6c7IcON00X/wEE3xdqTbvSELhZ4n1YwhFpf/?=
 =?us-ascii?Q?fYIbysL4fHlwVg+HmEzJtANqSzR4z2oXDUtLn2Yt5peTaaQtrUu47F+oVvtx?=
 =?us-ascii?Q?bFzXFdJUMDekp/Hfjs2/y3iDtAfxTb1tZ3Rl6CNenEdgTEMoT6Ej0rCYsUkX?=
 =?us-ascii?Q?/Fz6w/QuF8gvu0xgbJ1kj9fa4j79gsgl3g/BVK6co5rZFlwFzvVXEqd2pxCk?=
 =?us-ascii?Q?FJLeCS4NUMFVP9ToJwz4oME3L4ukPWjQAJAAuGkHAEMHKQl5GAT1T9sNxI2C?=
 =?us-ascii?Q?om1DJwz6oGxQd+ItJRaKaSzWKbVoEUBDsz8PQ/spZtiE/pdJfxvk5gYldBCZ?=
 =?us-ascii?Q?TrLZPsYY4f8tkZQ2MuC2d12puyeb8mhddD+MJvvgkumD0P7RSnzplUWp2J7v?=
 =?us-ascii?Q?nZujiUJLJVmpmdXWvz5Y54B2dlZehEsSljHr4qAfVwFdK1aCM5PgfCp8sacH?=
 =?us-ascii?Q?Uezd88D/3jG6JOSbZ69v1wwVAdNT3d8wo4FKxw8hWwBxxbPVQ+FjSbyATYX5?=
 =?us-ascii?Q?gpJ5BznaNTctrVrc6d/H4kVAFnTHrXzsvaH4WHR1NdiaP1VUUxX42vwbg3vp?=
 =?us-ascii?Q?KV62BUxXI1q/vbgaFDqchE724X4G43pZ2pSS4p3wK4gbk6kk069/+8zIG1wY?=
 =?us-ascii?Q?UuuNngQQfs1xA35vICcNoPi64y63b3XVpJJNvc3Smix0SFX9B6ZlhSAxJmQy?=
 =?us-ascii?Q?o+eDSmmsr6u64UPR1HpRCYzJ6cGrqjxmSsyW0BkD7bO4ZATQHWRRmjueYp4L?=
 =?us-ascii?Q?zj4Ws7IZs3evj1k9H5CX+689HfVR+SFg21GjMuSaQXRrGGs5BsPAEGhPZy9E?=
 =?us-ascii?Q?izofY1o6Pc3nhk5owzHfiqSEyG339TybwriFbTwM2TlxYhtOPzU5+VldpWDn?=
 =?us-ascii?Q?Zbk1f2XmA/AaTxeEEqF5eyHjSV6iJZgFuFPiu+ylYI3LSG3+IqyLpD44cway?=
 =?us-ascii?Q?OESsnMJuNWKkXMaLfQgVCgtWCpZOM7tBs5iskX3/yK7RM7tmbMrSm9mwhv1G?=
 =?us-ascii?Q?cKsXozS+H8AEMDQapuR4AIIdDue54sXLtd5lxpv3Ld6eijFvfVny/67AX/Hw?=
 =?us-ascii?Q?Aesjt3uqZ/tR6kazXuGWzYefJlU255Qb9RawJqS1FE7wfIudrsfis2OozXcs?=
 =?us-ascii?Q?naf6mr7W7+GHltmBK8ZOEDmpIP/OaPCqX372PZbFjNo1mNlPJqhVZsXhZ3w7?=
 =?us-ascii?Q?xwrOERNKW2B1yjcnQ/DG3Y/aJ8PVJdKtaJnbgtS90vLjP2nKpNqc+Hal2zKI?=
 =?us-ascii?Q?rzZLGZ24vy7/u3kw1S2C3WLYoFQxlxLj/v1/mH+jrSOVrdcdwQpEuKJpnWfz?=
 =?us-ascii?Q?hfbarysuNEqsDkRI3w6F28SIHj5gtUqwbgvMP1OA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b263a88-740f-4ec7-5fd2-08dc8684af32
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2024 23:59:21.4631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vpaP3qzYPQ4skFcfv9TstjOY7zWCtwOFGxVxTJfLEcAEGzYp31zHLQyNLwLhgh0j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7172

On Tue, Jun 04, 2024 at 04:07:21PM +0000, Mostafa Saleh wrote:
> > @@ -1236,7 +1235,7 @@ struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
> >  			if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
> >  				return NULL;
> >  
> > -			l1ptr = cd_table->cdtab + idx * CTXDESC_L1_DESC_DWORDS;
> 
> Similarly to patch 1, I believe we can get rid of CTXDESC_L1_DESC_DWORDS entirely.

I gave CD the same treatment, it ends up like:

struct arm_smmu_cd {
	__le64 data[8];
};

struct arm_smmu_cdtab_l2 {
	struct arm_smmu_cd cds[CTXDESC_L2_ENTRIES];
};

struct arm_smmu_cdtab_l1 {
	__le64 l2ptr;
};

struct arm_smmu_ctx_desc_cfg {
	union {
		struct {
			struct arm_smmu_cd *table;
			unsigned int num_ents;
		} linear;
		struct {
			struct arm_smmu_cdtab_l1 *l1tab;
			struct arm_smmu_cdtab_l2 **l2ptrs;
			unsigned int num_l1_ents;
		} l2;
	};
	dma_addr_t			cdtab_dma;
	u8				s1fmt;
	/* log2 of the maximum number of CDs supported by this table */
	u8				s1cdmax;
};

And we can remove a bunch of the #defines in favour of sizeof()

> > -	dmam_free_coherent(smmu->dev, l1size, cd_table->cdtab, cd_table->cdtab_dma);
> >  	cd_table->cdtab_dma = 0;
> > -	cd_table->cdtab = NULL;
> > +	cd_table->cdtab.linear = NULL;
> 
> nit: AFAIU, arm_smmu_cdtab_allocated() was added to check the cd table existence
> regardless the config.
> So, I think we should be consistent, as here it is set as linear, while it can be 2lvl.

I deleted this code, the tables are allocated once and stay allocated
forever until release when the entire cd_table is deleted. No reason
to 0 memory we are about to kfree.

Thanks,
Jason

Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013014.outbound.protection.outlook.com [40.107.201.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839F4248176;
	Fri,  2 Jan 2026 15:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767369440; cv=fail; b=L0tHWLdEndGtcpp+4fgtMtCtGCwykXI5MZXkBpclbJT3RXWivN9kAPBgEyozUvjBIqDxHCXjUHRwC40xf2sMnJh2oyK7p4i+ZIGvbVJxj3BclC9hsEAzX/Qq3tzq9xEtPewwknkQu/7PEiut8mwFXCsQSsj2KUMjDHeKPuRJRpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767369440; c=relaxed/simple;
	bh=Hk3zFTbw4uGosKytO5eTKEQ/ZOTv7JnY9+mFwMdSfzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=e3vT9oWMrouT07R8D3JrvuDU2JMxWZPxRgiq80Qk/yEJyxs5ZqTMS5bmdy8HfE+z3PGvBxi06Gdq6ktScr5KNpHQbF0kK9GVspu36mJgb4J13HfOie0F97bwBfXIQ7xjcr+KG/VFzhEgJGjrU65+b8d/Iy0C+W9vQlaf4/hpzO0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DzZFt1Yu; arc=fail smtp.client-ip=40.107.201.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DzZFt1Yu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hz8opMYEJQZKQpQl8HoSgr1uI2a6RbJ7tSNDF1fSSardDqcwOTI694hdgC6/DplacUUEjbiR0u0pOFvxJjSc3QbdOwJZLiL6yTGQwUWMaAxSljsDDAc1t7oOSqTrJAHEx1XoPQYJTcZrzxmJfZlhCak8rAG2NeKGCXiz0iew189SJndVmFR0WjvPywdahF513S9sW8nrh5JWXWFqerQ2zx2/ji1pDb5wizHDlBsb3Y9NhP1UP93inNilv0ZDJx3HO8Tv7nwNBLNdMlaJ8iczaXToD5Gd9uxV8tpDf+qyeSSCU+7SqSKmrfjYvNMOUeaTZ4aUQlSjcN2LeHN4GeQXeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R/7TBN0s2zWzIT77/CMBCZL7C29fDukE8C7oBykbxmI=;
 b=TiGFxV9GiU0okxT4kU5wwHbxUPZals3njdD5md+VTF/6nnBD3M0LkYgu7Es9F/PpyYuZgOTek9bog4qxoXXCYntURHgfa+rCvZcW+shi4TcjW4VDZaQz/Nn+LYJ8cOlyMh4S6HMQ4s/y/uYDkL5hrzyvZukF/fE4itcPlkmkYHEK+z8wVcQyD3iT12LrSG6iHYYMk5Za8jMom8x6QQLDlKq1Ti71olr97Gb06Y2EIFOXfliqs/Z7LYnHvEbIdGSBghWO0IEyfEayXkGhElUZA+r8ZI3GNlcbaOW+zJzGEn/95Fsn8+wEosG7wuo1CRZXPKexbqo/Z0QXBKbcFsZ2ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R/7TBN0s2zWzIT77/CMBCZL7C29fDukE8C7oBykbxmI=;
 b=DzZFt1Yuxfl+HVJpjvMHZ6EZAegKH+WmhAgxIlVuaN/HICaY5882Ic7+Ps/n9tM3N3PcdtWjmhNIf5ZsAYa4MKkVH95lzHlbuzh6H+rSJ5YuEG9GCfmYD8zjsdsDjM/818mTPapVWMrCjQ5UJ1wunD2KJnRu1WxsQD8HszIVxipjBw3fkayDakQWHZuM8yGH+Wg3EBhAlqCfPGxuYLAkGkwlSWnPfejVCggTGy6lA2DP5Quc280BB6GjL4ieXAhRGeiYcrH8nkhP6vUNSlw/kJClWL9qdZz/2sr+VSRqWrG5ZRNl/lWsq5nt5fHmAnJHJGvXuIYILuN69B5DNE1cow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA0PR12MB7628.namprd12.prod.outlook.com (2603:10b6:208:436::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Fri, 2 Jan
 2026 15:57:16 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9478.004; Fri, 2 Jan 2026
 15:57:16 +0000
Date: Fri, 2 Jan 2026 11:57:15 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, jpb@kernel.org,
	praan@google.com, miko.lenczewski@arm.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 2/9] iommu/arm-smmu-v3: Add alloc_id/free_id functions
 to arm_smmu_invs
Message-ID: <20260102155715.GC125162@nvidia.com>
References: <cover.1766088962.git.nicolinc@nvidia.com>
 <1541ea4a9e9c935c2f907c0c5f13a4af2bdc2114.1766088962.git.nicolinc@nvidia.com>
 <20251219170551.GF254720@nvidia.com>
 <aVQfhaqfvfLFNZqe@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVQfhaqfvfLFNZqe@Asurada-Nvidia>
X-ClientProxiedBy: MN2PR01CA0040.prod.exchangelabs.com (2603:10b6:208:23f::9)
 To LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA0PR12MB7628:EE_
X-MS-Office365-Filtering-Correlation-Id: d3166b00-8d1a-41c6-91ba-08de4a179a48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yG20GPTUWeuR1yO+oPMFEo9R8cPZvlYbZTJ+rN+oOtxcId1DK+AY4DzOovEW?=
 =?us-ascii?Q?asWA1Uf0pA8CAdYm5BU0aKCHgKYMWQ0MVBgv3kDW0TccWWOt1JK+mKvqLGK0?=
 =?us-ascii?Q?5PGpTOZLX2nA6k3HFSZbCQPo31fZcvrgI5yWOtgQvko71TXjoKAkzMWY6fVf?=
 =?us-ascii?Q?IB5ai7vLwt51On2JeGDVi17CH/6oZieBhBTG+XYuyhZPedqAi8j8PUEVa3yM?=
 =?us-ascii?Q?liERIuhXZS/tcan6IQ1GwL3bo9lLmMKObrFS/aRQJYRTOVH95U0pLC14i8Wn?=
 =?us-ascii?Q?59e7mOPCXQFdjWINiDJbz7i03CODJ85ukvYRLho3ESs3Bfgpt5kgxH/xxdlP?=
 =?us-ascii?Q?XORm4D1eNWO7Yhh+F5eUn7673YJ7TVoT1dfFtVptc6Hf3s5fO6YkH2XZ/D4h?=
 =?us-ascii?Q?6adOtittJhuG02RZJj5nYpqFhMohEZHxjHTYJ83xsEzXS6P9g+srUnXMoCv+?=
 =?us-ascii?Q?jdNh06/NgZIQnElu4QOMWEmW/5zvlkMsDyGAD7GR4ltQdg46TTb3dVpuOwUD?=
 =?us-ascii?Q?IQ1OTlwi4IGuCf+4+Pba4l7Uh5ZMhLxLsIzf9lkdWy3eR9FkOXpdizZ+M+3f?=
 =?us-ascii?Q?NKj3+Rq0y1/RMpAOK5aPKw1+jhFbK+veJNxYdQ6KfvD1xtQ523LcdcM5Lacu?=
 =?us-ascii?Q?egcA2LrBS9WXmxUyRe06AdnbRLsJ58Pg0bZD41ZeK7/HJWlYuZhf1lOuZTZ8?=
 =?us-ascii?Q?FWg8tboCas8JSwIyzGjDgGyemgVtkRCnDw4/Hn5lVcfWylpdueNmrYhAQspf?=
 =?us-ascii?Q?AdJDk+palvYdEH/BCoXbd+ueMJVgY1seelgqcP1LO1qOadH04J4Kn0TVFTEA?=
 =?us-ascii?Q?VzFM1EPFFgUwyaYryby5AQDKfaYFfA/aoTRiATvhsofw4T/RKIPTFN8GFTjG?=
 =?us-ascii?Q?4WNl8VcQxezXiI1iKYkAr3m/u9pnxppS9aVpJ+RMEUedqa4HeB7Rg4WpW+mZ?=
 =?us-ascii?Q?4c1RorokaxOh7Y8akmoSRZGNolfUTDip1PKfZ4HmczX3KgfazL0zgW3c8sSL?=
 =?us-ascii?Q?rWRC4FqrvH+6WrXQCvh0SyoE75kGoFVJbmv63xC29Nk4bEudGhO5u+9kq8aa?=
 =?us-ascii?Q?tOM4gYnSD71VWEJmfSeA77qTNLuwXFvHSYT8Z2hBYeX6+cY8JKo585pkFF/9?=
 =?us-ascii?Q?D/GcGMj8JJqbTfu+X2l3GGwYCeu7hSMtDTgdzM9twj9UKso7csVo+fuspZEp?=
 =?us-ascii?Q?5ujhoTyHSw7gnDI9jrJIoEpgvb3pUyuMqVU2c+ixRPJUrlnRqRIee/AKGXl7?=
 =?us-ascii?Q?UOqt8ndHjksJxEu/wgjnyqfiu2eOa1yO01lR3w54RHvPX0CQqNSbwVR0Cdxd?=
 =?us-ascii?Q?h1yOmzJyyjC+SBqyVNMV9ovHfu+ju53MdGsgSi5gEqbBpB4ERiu/yq4HRvHS?=
 =?us-ascii?Q?OTt53iQxrwCR6LwibOmXecxwwvOJ3JcOQZlr5K1gK7aigciRvMg847rV/R60?=
 =?us-ascii?Q?A0BBmr5H6jl7w9sgifVdgWxBNnY/jD/K?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ewi03hsQhHglSNYjhFH9AcsN2SzTlw78k5zpKwSHKKD1mEXsCdshz+ImxvpY?=
 =?us-ascii?Q?0LGrXg0yTL2Yapvy/EpHwg5N9qBVVNBkUDpKwLUZc5P7wnHRu42SHbRWhaVG?=
 =?us-ascii?Q?H9gICYCVUYhZIcVdtOZl1wqRToaSCoFqhq4CWdlZLDyJil/6CA48/Ok6WL1c?=
 =?us-ascii?Q?m/4FnQS6qP+gGZedQifPSpuaGltk8Rijd17e/pqZihlngIsmCMzQACrsCxkm?=
 =?us-ascii?Q?2idATOLF+YHjB8SNbRrSafRRqLgrf2N82u82szSWnfCapHo3uID0Gz16SJgu?=
 =?us-ascii?Q?6ix7G27C1UxdoTKpWOD846bDOHPN3KptiVDsO2qlnnSrteKuNHu1imUeSGuW?=
 =?us-ascii?Q?sYSSjm+H0isqChvNz6I1VVFp5uLG2kthh0ueRFhdmZCAQ/aAB8cqbZXe1Cd0?=
 =?us-ascii?Q?5a6uol1aUyyFSjpZqA8C6bHh0+3X6vqWbRcuYPQo0TSwoHXAPVFLmSglDWE7?=
 =?us-ascii?Q?nZkf8XyL0yBaSD096F3uEjw9JD8FDeHhH6884TrgHZHp7E78d/m6RyETbrQL?=
 =?us-ascii?Q?GLhM8hAHparhNuWzcsUrBqi5dMJwrsg7/m0Rohit7Tzpcok5LzbDW6tHPCgL?=
 =?us-ascii?Q?3Ql4/dI10u+ZinVskv3/DY5Frt3sZ0+pAxyP1a2sFhEiGvQJPEnYdcNf5Q2y?=
 =?us-ascii?Q?M6AVyv5iVqXRXuylzk9StzlqSZXtRtFqysl/OtgH/OUz7yeHYm35QL+X/mlq?=
 =?us-ascii?Q?B3puumzuapDwk9n/bPf6q70TBfNmhxuxhFo0jI8sY4JPitLll4KWF8SiIxA/?=
 =?us-ascii?Q?AR5GuC9lvRPmksoJjOAEb4N9bEQ1//SMTuCCcnkAHdkeS4OLuTtLrucvxKLr?=
 =?us-ascii?Q?FY13DYTSIOcxQ26z59NksyHVS+OfD56qbuQHX0HYvRMEmwbTJ0MRE/hnx7Mo?=
 =?us-ascii?Q?jrSgM9d0MaCfchdwd6lgHlqbPuY3bH4Uct2lBsV8sX+agIVcvD8xNU95dQTc?=
 =?us-ascii?Q?z+ADxexsS+4+MkavhP74Nu5veiA9CC9yq+OysLRd7m/MrQdCHzycawHOoOYl?=
 =?us-ascii?Q?WFWRnOfnTs8N6EcSamMJIilopVQPseJOzTbCk4x2esYNSUYZSJXmNVA0Swxl?=
 =?us-ascii?Q?Bcf8ajPnaPsALSwy8YBaJUhRy5tXfvr6RngBKca7EbsPdDcKlj9pWtwa6Yd9?=
 =?us-ascii?Q?vsCnxW1frBWwQ3i5zeQSXHKzukhIOhx/fkhYkbyIRZvgfUTaaf0noKYoJ1YR?=
 =?us-ascii?Q?OrfPrIkhMEUdAh/F/L37v0Q82Z4xLe8udcazQmmGMPslmrlpt3zugWIP5Jh3?=
 =?us-ascii?Q?UflIRtnTwaEQ8zVIUnp/evw3n1nj39htjrl2Nfrw7SyGPdnIsQCcpfDm/e/V?=
 =?us-ascii?Q?12b+crwjslnjWKuUd3VzgK3xNRSfANkVf90MjBtrUlSLZH4TL6eyQk8dZGbx?=
 =?us-ascii?Q?D2bHZU659Lr8x/y+uNjUDk3UHsFmToMA2CTc6GiyuCt8ARyCqwygkKgsWBMt?=
 =?us-ascii?Q?ViTuSMidwDn/KVnhTbxq/30ik4igxIOFmHfb0JumlnF3Neq8Ul2wE/35TfyF?=
 =?us-ascii?Q?bkZ/WtCdjHwZ+RrO5Vsw31t6UNmDWzpFbnlMsGunHXq4cMjjMhISXq1LZPUI?=
 =?us-ascii?Q?0TboP0N1XDq0hxKxRBBJ7RBoTFXTDO5CYlbY+tlOek31rRoFmbesan/lAyEn?=
 =?us-ascii?Q?OpcQgCbInqVezJouio7JPcCS+hll4QSasfywnvzNjLlK2neoVMVclrdWpoUp?=
 =?us-ascii?Q?ujipkNKm8EtmINtryF5O0aXVkAVeuhdvri1nq3DV/kjLY2cZaO9JUx08xQ/S?=
 =?us-ascii?Q?8AI52FaNZg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3166b00-8d1a-41c6-91ba-08de4a179a48
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2026 15:57:16.7832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cSYEBQCdSKGaI83XuB0it3dD2dTDfo2h4SoWw3ly6rWDqCV15nWjWRDZlzJV+QYw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7628

On Tue, Dec 30, 2025 at 10:52:53AM -0800, Nicolin Chen wrote:
> Hi Jason,
> 
> On Fri, Dec 19, 2025 at 01:05:51PM -0400, Jason Gunthorpe wrote:
> > +static int arm_smmu_get_tag(struct arm_smmu_domain *smmu_domain,
> > +			    struct arm_smmu_master *master,
> > +			    struct arm_vsmmu *vsmmu,
> > +			    struct arm_smmu_iotlb_tag *tag, bool no_alloc)
> [...]
> > +	case ARM_SMMU_DOMAIN_S2:
> > +		if (smmu_domain->nest_parent) {
> > +			/* FIXME we can support attaching a nest_parent without
> > +			 * a vsmmu, but to do that we need to fix
> > +			 * arm_smmu_get_id_from_invs() to never return the vmid
> > +			 * of a vsmmu. Probably by making a
> > +			 * INV_TYPE_S2_VMID_VSMMU */
> > +			id = vsmmu->vmid;
> > +			return 0;
> > +		}
> 
> Would you mind elaborating why arm_smmu_get_id_from_invs() can't
> return vsmmu->vmid to share with a naked S2 STE?

A "naked" S2 domain doesn't have a pointer to the vsmmu, so it is
impossible to get vsmmu->vmid.

The only domains which have it are nested domains using a bypass vSTE.

So, if userspace attaches a bypass vSTE then it should use vsmmu->vmid

However if they attach a raw S2 HWPT without a vSTE then there is no
vsmmu and it should work like any other S2 attach and allocate a VMID
for this domain, ignoring any vSMMU that may exist.

In sort, the only case where we use the vsmmu->vmid is for vSTEs.

Jason

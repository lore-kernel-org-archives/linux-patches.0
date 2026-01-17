Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010053.outbound.protection.outlook.com [52.101.201.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FCC1D9A54;
	Sat, 17 Jan 2026 01:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768612274; cv=fail; b=Wkopzyrn5xSAcilmIke1/UM0Uu2o2VOJHWjfYi8HnXwnxKcXOGChHQngHLHfVR1Ei4Mj1R5TrupafSTXbr26EtqJws4mCSxL4Why2o+auYTvsTTZdaJ3eP00UfFJUpQEqEEFTxUwbhk33zzCiM2UY7aX90aL1kyF/wJsrzU7EJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768612274; c=relaxed/simple;
	bh=uDg3gyimIPL6gFMOL3girHPH76ZFzgRbm7U4sg1SlBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=noORm88l/do4rClybDREm283cbBqJO3+EoAAKNPtScXPrFJ3e99A9T67n7EYxwpiVfF5clkqSnC4Eh/JaIReANgzTkl43rQ0hS4fLDJZIEQe0sY4xpMEwLdc3XMt/4isB9PdqJMCdK7D362RcQBIYWL/EucdGLKC4MVK0b4cRYs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qgJaKKd5; arc=fail smtp.client-ip=52.101.201.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qgJaKKd5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YCOb10sEgTgkmbmBllNoz2dMp4Fa+m/LDaZBR/v1/gXXq/g2THIimzIlC9zSyJWo3hg6odPpf2dA11SC5Wk4R4D2k+lsJ445n1YRD1q/AgiEAxVYD52ZY34/rIykY4BPK1vHtWUMA8mFlZQvO+65ohOEN5ZvYULAvP8aRVWD5EYqCIXgVvAlLt6Lu5TxNV7oTSw0780A0wj0Pa3uiQeH6sGtVXlfqK2UqE6o79kUzi2I0abHwJIs5HiHXvH70R1yIdrxGXV6IA3SACwePkD3rq5dHMGnJG9L2i82K1YZGcu4mZBYXupEobNY9WC+4P9dK3V05raQ1MgWCuNxGAw/gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6PVYW1TEBqYTY5hmcl+QZWk59Aw3aVEuNdt4442W4MM=;
 b=aPrY4jFDXvNAJqef1Cr86UBZxYoVsMbH4mx1fk54bHHX/Crjo3kkzjwCoFZ9ByLWfPztiQw7+cw5e2muk1J/pv1OhrDH+H7c//l2OOk++n+VoN65VeZkGB/g2QzIaVIvTzB51mDVs/oIlrVGc8d2mCrNyUFQt4QnDIiv5OrO2GdQPEkDExqiMEJDVCZGnBQjsf0d7y/34E+i72zi/BGDVybN9GT0XuOFGy8N63F24YEypV416fMx28GGMSFzj6OtDDnCwdCBmllUt5TmIfpnei7f7wD0wAKm2l2RcP7ytXlfAjBCoEkjc4FS5Y6vYJaZvinO13jOalVIFP/1IjZ7oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6PVYW1TEBqYTY5hmcl+QZWk59Aw3aVEuNdt4442W4MM=;
 b=qgJaKKd57ZBCzMJQPBH6Tcejdan8KN3uGLIJ3O9V1lOAdUnvMKpS+enxBFmvRkgZRNZLFK5aBDDdTTCl3orkusx82hKcga7ZGpUZc1YTbFwS1szE7AcwWQILC56SEl6hDIPHm4toN1agBNT/gpzTXObVsL8Ne1nzXq5PIgmshLlrcyli1X1c23PRwB1eS25mADp8VtVapinFTrLgH0dgql0CeFYpU/tCjCAgv/va7ljX9Uz5OqvVX5sd02B0bYmbGL2Yo2nafyfddN2WPQvFKHYHKSBnnhWnDp1BbqV1CbEPxew08bwqjyh2zl3O19AaqGUX5ovTpiR2DBMfbL5tMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB8791.namprd12.prod.outlook.com (2603:10b6:806:32a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Sat, 17 Jan
 2026 01:11:09 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9520.005; Sat, 17 Jan 2026
 01:11:09 +0000
Date: Fri, 16 Jan 2026 21:11:08 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org, jpb@kernel.org,
	praan@google.com, miko.lenczewski@arm.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v1 2/9] iommu/arm-smmu-v3: Add alloc_id/free_id functions
 to arm_smmu_invs
Message-ID: <20260117011108.GE1134360@nvidia.com>
References: <cover.1766088962.git.nicolinc@nvidia.com>
 <1541ea4a9e9c935c2f907c0c5f13a4af2bdc2114.1766088962.git.nicolinc@nvidia.com>
 <20251219170551.GF254720@nvidia.com>
 <aVQfhaqfvfLFNZqe@Asurada-Nvidia>
 <20260102155715.GC125162@nvidia.com>
 <aWnI3Ii3KCFmJV3/@Asurada-Nvidia>
 <20260116144120.GM961588@nvidia.com>
 <aWpuGsnyZJWTmgrf@Asurada-Nvidia>
 <20260116171158.GQ961588@nvidia.com>
 <aWqDDRTz5mB1Iumf@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWqDDRTz5mB1Iumf@Asurada-Nvidia>
X-ClientProxiedBy: MN2PR18CA0009.namprd18.prod.outlook.com
 (2603:10b6:208:23c::14) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB8791:EE_
X-MS-Office365-Filtering-Correlation-Id: 6412d264-930c-494e-ec4c-08de55654c0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j8q9RodyXtqf8es9Rat9i/bgu3F5wyx0CSp+FfmFOFXOFzTwFiRAl5zDEYmp?=
 =?us-ascii?Q?bvGOJ/BQaRgsr0L3SPYUthp9Z2O8zT3h/alS4lFpvmiMZAb0sJHtEo/wxw8B?=
 =?us-ascii?Q?LXLdozzRb+2btBkX8U8nZK0onsfu+EakEVoTP/j96hMvLYj/bijK9uKvZ1jn?=
 =?us-ascii?Q?fuxUdugGoPnmamElM1u11zXx3ls/AIBvq4M+XP8KIOT3ZMjDJZZSstYRWFTq?=
 =?us-ascii?Q?UijUTBF/gg7A9p3+Z76SRgRSX1VUenPbcu/VovmqBDyId8BSHW/xn7gp9I+Y?=
 =?us-ascii?Q?8KC+IJ4557S99A23CqE0vin7fYMqfymenAnqjQhDGZLRSZJ+6YKJUnOBB2GB?=
 =?us-ascii?Q?RubM86hCD5tBdop6eCL+9sbDHU9yIT8twAZe9t04kE0T5z5BcCxha7957G4f?=
 =?us-ascii?Q?R5RbFp8VbG92DddUVO3pdebVKtKrZ8W5O146GeJeEGSEoKSEW9eNoS950G+z?=
 =?us-ascii?Q?86KmOFhdgBGtXrzRxnpV+d7/NhITOi4IZFZuFNySnpiUGbpYIIFoxPL9ThPm?=
 =?us-ascii?Q?z3ESEKhzwy7Db0maVsLjurN+YwkImgo4jquE6+MNNrh8hCUBZvg2uIRKVVi3?=
 =?us-ascii?Q?LN0YN+WOoG7fR3gpW+9c/J6p1mcH1J+QQHumGlybgpi0mxK/3VCd4f/DfWdZ?=
 =?us-ascii?Q?uGV6jw2k1Oiw4V6unZxuG0RLTrGQxjHH4tmKocKFiuRDOB8eHW+hdsNWl0mg?=
 =?us-ascii?Q?TVZoeoYp3nJZYx41DCQ5V2hcPpDI8oxNtEkuCt7H9FJ5NfYOoqgh041pN/g5?=
 =?us-ascii?Q?nBhy6r4lEq/RKAYEtI2o0gsQnmnQLGE5v1rYUIdqWVBYStq30ujntjvXjMdc?=
 =?us-ascii?Q?wPgdcPAoQjJ+aqm8MNxhQYBEGPUqjDvEJPfRCj4BfYukjipStyNI47ZV6EFR?=
 =?us-ascii?Q?tp7PaHP0EhLNVqMggU2XwBeRidON6fcevNuM/vkEh+MjuPxezD8D5KUGt+81?=
 =?us-ascii?Q?ZoQHj5stx5JphCAPXeMLsoLzKZ9HOnTBaNjvOPB9F8+0iaEWoTQcvC5MdUc/?=
 =?us-ascii?Q?jRiRkmz3QQdMV4IkrJL6y7/YPqS04fkSIEGIAnb7psLYGTmR53mMG6x/2KEN?=
 =?us-ascii?Q?q+05aCtAGi/r0yMKpErBVCrL4M+YDvjBheMX28WIPRDKvRYqDohKxt3AsE3H?=
 =?us-ascii?Q?Z2vUXzv94JA3825xtl3ucF8fmcS6lxjL4kIznHbB/2lvKG+ngp6n4IY14tPW?=
 =?us-ascii?Q?wilC5aaLaIh0f5NtPU9HzRq5Qnnv7tkR28RtpKZRfPrWqMhsPiV/DG/w05V/?=
 =?us-ascii?Q?V5b7CTTe6EfVQMgg+lcy8Jhq8UrPnsUraJmbLGEVkrwL0ldwobHX+SebRXmg?=
 =?us-ascii?Q?rM8pGzTVL4RnuEQp0rZtoPZA1094nH+DcD0krNIjgYdZqMXHdhX+lI1XkXgV?=
 =?us-ascii?Q?cavMSrhVlL9TBA4RxLXVBcGlG2AG7YD9n4Uw48RUV88gotwwmu0fUpRPjdbL?=
 =?us-ascii?Q?SpOwh+3NTD8Q+AGAB2qRnYV37HtXB0YNITjCt/4iPUjnlPNSm2/8Abs4B+Qb?=
 =?us-ascii?Q?8UBPVa95Bo9yQGUwH1f33fWzqm/VIxdTErDkHuaqeSXbelDMiItNw/80eKON?=
 =?us-ascii?Q?dAWijTtRGHA5ZacY8U0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e97khJ9L7oic06z+Jk/TGsVKrCwW4zvsRlaxCHoefrjCRFLDn6m4Bsofu7PG?=
 =?us-ascii?Q?14xtkXV1BkQEX6EO6q1WxxD4Ez8eHQuqcNCdRXFI5d6QWujLHwiqT8oe35mq?=
 =?us-ascii?Q?OqlckeZoD/VfAYwXjyUbLMppG1Ne3qHcXupTxZ1PFVDCRoyddV/WJ3E09eSR?=
 =?us-ascii?Q?HkH5U3jCiua5dUSl096sAYgGaozA3qsS+wBhdCCal0PT1mnDXFlg6W5rBddL?=
 =?us-ascii?Q?tLOK9iEwUbCkR6OTm7oA6jMAveX9V76gyOueMnht24lwDcuyAtyOxPeVI/Lc?=
 =?us-ascii?Q?5b6OHQyxFJcT1J34RTufGEnfvJm56pE9NEVOMCumis9JIkvg4H9PfMHi0u8B?=
 =?us-ascii?Q?7QvraffC0+4SblvS8w5kKi9DOsQ4ya7BHTQSsIUzL7G0Wv8C7i3x4Dp+9qfd?=
 =?us-ascii?Q?BRVbwAJCKurADpXR3idRBApcO9xGgvJgzBu2tR/Fb1KeEbEOb2/kcmb0A8I7?=
 =?us-ascii?Q?WQWS2BJZj2ZizT4nMjoBqNB6TNFsJyvlLvzGxxGaLsRogA2AajATu6oGFPJv?=
 =?us-ascii?Q?6XfailjBDQ6RadRBgknDAR/Ls49GC8WojXih5ULCQyyJ2QxZ2COWG776p5sy?=
 =?us-ascii?Q?sqn4b1CREYoGwVokSnI6Qkzvy0IqqbEcbuH8/Hw70w/fe6wkUNGMTMoknFUT?=
 =?us-ascii?Q?L0GjCfAWPk9JGs+6zHywsb8UwHAh+OLZKlXXNDj/nuO0OOB0Vy3lVK1e6JjK?=
 =?us-ascii?Q?+bkBxN7el+S/j3b9vLwFvfJNTiItqTYW20WAP+OJr9xPNPy9GM3ORoc7Y1u9?=
 =?us-ascii?Q?cRY5/S1nFb9vLwHusVknQlQrwAo0F47tdGBQUr+bawUSL0LjKS24RtGG6B2s?=
 =?us-ascii?Q?Vmz+MpxN8tUoN/iEWPj3kaqlvx5naSC9/nfVlyvdgwYJu+3SGvYdOma2bi3J?=
 =?us-ascii?Q?sfH64UMzK8UxaOAKMsl5V3L2bwnE/ldTkm5RZqN+V8Cxd0d+gqeBdH5xlLtf?=
 =?us-ascii?Q?YnIw6HiyLCZmJ6HYsbo6mmD1wDpsh6yO+JR4tEOqHB73sjMUIj56HZipIC7a?=
 =?us-ascii?Q?WGvqFK4tZRPPrA1ulimCb8vvxs81AicTJ1hBa/ZhT9BPHicP9z5AShbE4PGL?=
 =?us-ascii?Q?3UNbV4clAMbG9LqpllKky0w3+hFXOUO9vHO6qWBtFYCsBAJGBu4AgVQ3H6il?=
 =?us-ascii?Q?fHo+RKvH5Jn4VmqyNNmSJxD27NktQmkWACxnMN2GseSFuRxZ9xlYgizfp85a?=
 =?us-ascii?Q?Fd+p3h1/qbKpXP6fIRtzF0NPyukQR6iqbbJvgpAJhZ6WroY3TDSn3VnWnaRE?=
 =?us-ascii?Q?TVxBEmeLgJ6biMPddZLB7b31iLdD12JqV6KJ/WZMNcJQlvQV9rigwD+Ks97q?=
 =?us-ascii?Q?LGCZMn9UTO5Bgttp7Ec7wY24glKAhuZArLU0Z8T2pa+0Nb0L0brgrHfi3xl7?=
 =?us-ascii?Q?xOQmqwavmBU3ChhZylYI4UPYNg98YzbwysTYnpw+BHNYQ63KMQC82YkVRdjo?=
 =?us-ascii?Q?vU+x/ynIaIfTIqikTJx9Bt6J9baUXBq+Cnu31qBvW/n501rNH/dBNRuba3gE?=
 =?us-ascii?Q?CM8exepbx2ahp8nxy5Xlhb3cJjDW5UWWtH3kDXEn2YlDjwSWrsgV7vygdKH5?=
 =?us-ascii?Q?lFpfcLYwdo62GwxiQv9cUBB/GPf57U5cM87HaYJEqDZPQuT8QgWrIWLCtApe?=
 =?us-ascii?Q?fN+KI7zYisNXBTcriyReLq1AtDavk6Oj1BWOeY7CZH1s84VBrU2YKsVlM62a?=
 =?us-ascii?Q?3VxY27mR3jGnfjPvhdBAi6shZ4ufg+QGFZ1pgyHxGPO7Q6jGTc1ptDqlp6D0?=
 =?us-ascii?Q?+xiv6pqRQw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6412d264-930c-494e-ec4c-08de55654c0f
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2026 01:11:09.0901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hNUjYDH2AL+2mdQ+jxqhkEeqYat+G5OVM9LJL4dg3Sfx38ZEv03LSqqHyuKMiZBf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8791

On Fri, Jan 16, 2026 at 10:27:25AM -0800, Nicolin Chen wrote:
> On Fri, Jan 16, 2026 at 01:11:58PM -0400, Jason Gunthorpe wrote:
> > On Fri, Jan 16, 2026 at 08:58:02AM -0800, Nicolin Chen wrote:
> > > On Fri, Jan 16, 2026 at 10:41:20AM -0400, Jason Gunthorpe wrote:
> > > > On Thu, Jan 15, 2026 at 09:13:00PM -0800, Nicolin Chen wrote:
> > > > > On Fri, Jan 02, 2026 at 11:57:15AM -0400, Jason Gunthorpe wrote:
> > > > > > On Tue, Dec 30, 2025 at 10:52:53AM -0800, Nicolin Chen wrote:
> > > > > > > Hi Jason,
> > > > > > > 
> > > > > > > On Fri, Dec 19, 2025 at 01:05:51PM -0400, Jason Gunthorpe wrote:
> > > > > > > > +static int arm_smmu_get_tag(struct arm_smmu_domain *smmu_domain,
> > > > > > > > +			    struct arm_smmu_master *master,
> > > > > > > > +			    struct arm_vsmmu *vsmmu,
> > > > > > > > +			    struct arm_smmu_iotlb_tag *tag, bool no_alloc)
> > > > > > > [...]
> > > > > > > > +	case ARM_SMMU_DOMAIN_S2:
> > > > > > > > +		if (smmu_domain->nest_parent) {
> > > > > > > > +			/* FIXME we can support attaching a nest_parent without
> > > > > > > > +			 * a vsmmu, but to do that we need to fix
> > > > > > > > +			 * arm_smmu_get_id_from_invs() to never return the vmid
> > > > > > > > +			 * of a vsmmu. Probably by making a
> > > > > > > > +			 * INV_TYPE_S2_VMID_VSMMU */
> > > > > > > > +			id = vsmmu->vmid;
> > > > > > > > +			return 0;
> > > > > > > > +		}
> > > > > > > 
> > > > > > > Would you mind elaborating why arm_smmu_get_id_from_invs() can't
> > > > > > > return vsmmu->vmid to share with a naked S2 STE?
> > > > > > 
> > > > > > A "naked" S2 domain doesn't have a pointer to the vsmmu, so it is
> > > > > > impossible to get vsmmu->vmid.
> > > > > 
> > > > > An S2 parent domain should be per VM. And a vSMMU on top of an S2
> > > > > should be per SMMU. So, it could have stored a list of vSMMUs and
> > > > > device attaching to a naked S2 could match its master->smmu with
> > > > > vSMMU->smmu in the list?
> > > > 
> > > > That would cause lifecycle problems if the vSMMU is destroyed
> > > > while the nake S2 is still attached and trying to use the vSMMU's
> > > > VMID.
> > > 
> > > Well, if vSMMU code does the same get-build-merge in vsmmu_init()
> > > and build-unref in vsmmu_destroy(), VMID is basically managed by
> > > the invalidation array. Yes, a naked S2 attachment would still use
> > > the shared VMID, but I think that's fine for a nesting parent?
> > 
> > The VMID has to be managed by the vsmmu itself, it would be a big
> > confusing mess any other way. There are multiple invalidation lists,
> > so you can't rely on that to refcount things.
> 
> Hmm, in which case will we have multiple invalidation lists? And,
> why can't we rely on the refcount? (for learning purpose here)

Well, you could have multiple S2s floating around the system, you'd
need to have some way to figure out which S2 is which nesting parent
for which viommu.

> My view is that VM has one big beautiful invalidation list on the
> S2 parent domain, which manages all the VMIDs. So, basically VMIDs
> could be still tied to the S2 parent domain on attachments. And a
> VMID must be one per SMMU instance, whether initially allocated by
> a naked or a nested attachment. A second user would just increase
> the refcount.

I guess that could work but it makes it much more complicated IMHO.

It would be simpler if there is only ever one refcount on the VMID for
the vsmmu in the S2's list and that goes away when the VSMMU is
destroyed.

Jason

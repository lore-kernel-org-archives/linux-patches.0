Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA801D27B3;
	Fri,  6 Sep 2024 15:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725635617; cv=fail; b=Q3WCO4xIXerhddrUJJvBqKZU91Pw5vMQ0DGE5jLTygZqKjShkNDQX89L+c7GpYBnO9WCCmZczgchogPtY/dE4M5NT8Qe24/rDz4PTRWJvP6F2VEawYBwO5zStfdS6g8ebbhadux7n21xjrjVbH95YQCRcO9UPQTHQDOoP0xYuA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725635617; c=relaxed/simple;
	bh=rS75DRd3NTDEfig3rKWUX5t0VZnLpvgVY7WU/BbSOVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lyr+p1vD15LXbRkiqyTPppBvvGsQmkAr+7nOtQ4/+ASYnL1YWBBMWJBkBR/Ht9Iz8NPQeOtPqCZFWNKMmztC2jCJG6jqa4udOrE+/wUwhzGyQ/5mVk/hgABIZ/9pGkL2ZD3szoupKKRNGc9vixA95D4qlOua1BvnvjLuX6wCrSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=U5nVgUyD; arc=fail smtp.client-ip=40.107.243.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="U5nVgUyD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UG2dbhZCmgN4k8gtW/zEj9gBnqk3bSpKxWU7GgULb/yzKPmYpCHzY/BfyPwVD7YFriBwQWcVjlXMYCIfBKOjICA9iFG3VCiBgpRXWCGBLPjZA3s6B++8s0FwJ4vNIFVB2Y7lR2kReNk9CMJQLo0dm/pJUbCQMoe9q/0bnIPI/K0b66F1zpZvJcdN32WNcNAIqurUNaHvtd+sBpb/jk2kHChffXwVRtPbRBleO2cLPL9CqYY5Rh169o8RoyAcicn6T9ZU2RMFbShHOkiUq81vQyRJQgZPDRfvri5bOB0FiphMreeCHtZKWMAoR1k+iae5CM5i4UN/OTWEMgz9gVn51A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f/wbXy00g479V9sfuV+zgRYG3E6GCamiNf6tDMYRgYU=;
 b=R5Od+4CJbW/l5R5xIwYHDE4WwEkjLg17HovSWwVqnffPzqJmSAgEtS+XEG0qmKktzIsOJ1z2RKu2YgxurwggpsmcQGSHdSMXlrG0xyV3gLIB7nzAuNx8eK8ik4OZshz6h3ATKKvnn5yyFDsarDHyszbJ9XIbqIE3xUn0c6ayGYAtImcCOwS5qgdwyMuNhFz5v68PIi5+SlrnJGSgcyMaJVuUS3KeCFSLr4Gze/WDj7zf9NQ2NJAjprdEeje+MQlTVg5XhwwpbvlpxTAebwPtswJJSklo79ugg7jeV8BKY22J1dl43jolPEtgo9198IFTDaYO6or2poSYObpJ/tfExQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/wbXy00g479V9sfuV+zgRYG3E6GCamiNf6tDMYRgYU=;
 b=U5nVgUyDFtcHGgkA7+PlXYWRj24OAVOliEJrFEy28PdaroC3mtpwhtNs1tod42HWQGWi7OHC14jNabmldNYFPF3WL852ieCHrwZtUi9vkkXQiQyhGHMnbQzLicfS9ZIyGKVtZa1mVq7W+Bl4GXnQPtig8k1TwpWXzSDmb0+yvarV2YoWGXBxXVap6tSBrlAmBWrFt6q/WOLfIYV9qAkqNlFIlGKpm0tN/zvhlg5LDHZMsH0hULNwOROh/LIxb1Zg0ZZr+W7DR8cjF104rLJRCzbiMMReil9XgIAn9A9IkqmbDAjtVDEvEQR0li5GuFG5+J8b2DdbeyBN8R30GDbEqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by DS7PR12MB6069.namprd12.prod.outlook.com (2603:10b6:8:9f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Fri, 6 Sep
 2024 15:13:29 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 15:13:28 +0000
Date: Fri, 6 Sep 2024 12:13:27 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 9/9] iommu/arm-smmu-v3: Reorganize struct
 arm_smmu_ctx_desc_cfg
Message-ID: <20240906151327.GB987149@nvidia.com>
References: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
 <9-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
 <20240906132222.GD16959@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240906132222.GD16959@willie-the-truck>
X-ClientProxiedBy: MN2PR01CA0045.prod.exchangelabs.com (2603:10b6:208:23f::14)
 To CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|DS7PR12MB6069:EE_
X-MS-Office365-Filtering-Correlation-Id: ce6f2fdd-acc4-4dae-fdf9-08dcce86762d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WNgrYr3Rg0XP9/y7WPOguXe40VAPURZiRUdRLTZyhl85nNiDHsilE4Ht8Whx?=
 =?us-ascii?Q?jqE8wYnR6peJDyEPTlaXvu7kkVLPqr1FA0zcl7Zc8BMoVIjcArwyepMLiRPE?=
 =?us-ascii?Q?Ib89VmUDlqwRBkcpK0iId1Bu0FMvrb/GwieCFhSzRNcqdClKdHPtlnwuu9Om?=
 =?us-ascii?Q?NCRfsgUtrPnWF2f90JVTL6MV0WKYTmr1rtyTcHjUDtSVRqW6B5U+K65HUjty?=
 =?us-ascii?Q?aPyX/Hdn/4Wg3pDubauHbR93x74NtoohrG/qp5R6BCvW3YmpanAgL3jmJBpA?=
 =?us-ascii?Q?r6OtQa2BuDSWndDt2D7JcF5xFfqM89CWNKEZ85zLoBjECs5s+AX7b9GTO9E1?=
 =?us-ascii?Q?F8HOltGMJNpJSnGe9U5lhJ0SBScjtsrbiZzF5w6bJ3251u6P/GVlqhQkXJwZ?=
 =?us-ascii?Q?XL27wozgLAV2md48pKNKyHn7poP7d0iRIZXGVKp9Qc1c5ySKx5Q7FBvrt9M3?=
 =?us-ascii?Q?cUZHF3jg2zea0AGXnbqmr6/tPa4xxoOmMRqiyTzUrMpYxhBRbOsF3sk5elzX?=
 =?us-ascii?Q?q+/vz8hAK2QtJp/RrOHCFekeMRfuhNb9il284Y/lIDn8GwRXfbq2DmHf6RNF?=
 =?us-ascii?Q?y+Y5mcE0QuE5UPjd6jl2e3bNFEdw9xoYpo0N/c9dL78s8FEo58EjEEZiTVyL?=
 =?us-ascii?Q?Ad38kzdpJn7fUQt9ItMIKtPgmBFwzm+y/hUbI00p8qSWaWffzk8XqRNO7iaG?=
 =?us-ascii?Q?nlqTPuRXxwQiyte1oTa5uvH56A+7YowMuadtHupZXHYaC5XmEMQ5S2OWkRH0?=
 =?us-ascii?Q?QsALQJsXFe/a92KeVOGVGgE3j33ZxlktNn/S530GM+PHpjeDltS+t0OCPTqA?=
 =?us-ascii?Q?RUDf9OuhqAMnxagQh7TW6UJEUjeySHJUVMrKoPffunXGuVURU67EWbYYGE/Q?=
 =?us-ascii?Q?VAGQtDNgfu9oAbyRiOEjIOJPkgig1PpoZlk/jCjYZ7xeYqHFkGxiRRf6kNOm?=
 =?us-ascii?Q?2tvV+l2qbsHeL2GHTo5D9rcdz1NVdOQtbuYbN/HgtwL3fhISC/Ml54sDE+k8?=
 =?us-ascii?Q?2wwu/Yatpz2THdeBPkswpWX7iME4BOE3iffqa2bfDsUMOVMP+CbOexL3VqlV?=
 =?us-ascii?Q?89HpndQBvvHx76qMk47yJO7enofuekxtGsGO2tfD477Gx3zl/nhKL59gbrA5?=
 =?us-ascii?Q?3YFBlL0hNPvdw2NklsrOCShif2fiLcMTQn4e8jy2UIOTWx5Fq/rJshNHAla1?=
 =?us-ascii?Q?LRL+mKGMWvMBle65e6HedLbRPXWEUiNn3yVPks/lJ6mfZgiAlGWpqBHd8zKe?=
 =?us-ascii?Q?+qH62y0MbM1Xb4U3Tdr+GPRJ0CnmWgbVxZZ/WR1zJin1r4zXvDnT2S9UXwt4?=
 =?us-ascii?Q?SxcdCB1QNrhO7vKuZndZmfK/sYr+nREjI9BwAGSvzhwF4A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mKw/0Vo+gM5YmjFObTdp2A6Z7/nbD4HyjGtI/LbGQFKLNWQ5RVEfWqA0S+sv?=
 =?us-ascii?Q?a9gixWjggLfQghpS0No+BF6hTu6nzoq9Mo53CZ6HwJ0AmwZXLlDnTTWjti2v?=
 =?us-ascii?Q?nWEcLyM8cfAX9twoetqBxx+7JeVOJVWi0dSNAXYWzuMoNXmSWNEFLxwmbyBO?=
 =?us-ascii?Q?ZrlD+/DLtHktoVRpBL1JBAepLYZ4Pt3Gg9Tu5bAllntNjqQPJ99MjR3u4Y1Z?=
 =?us-ascii?Q?j0McNoof05wGJO8/ymAQX7oSIiASdqmDWKNk5lDPJZkys/iZF7RoK/SYpe3W?=
 =?us-ascii?Q?40TcNqkyohkYSRW+haX12q1h1aQFRhq2Jji0ItXDGIzK/SeeYSJv/tJjf12M?=
 =?us-ascii?Q?KYkn2PlBXBghf84DVoLp9vjyFmd5zV6obWHv/Z/9prBaTl8r5c+ftE6U4BD9?=
 =?us-ascii?Q?8/ln310+8fHzveZ9yFtKwgEpP2Je0ThSB2EE5xPXebhVX5mBmiCKUah+4c6V?=
 =?us-ascii?Q?UvSlBmUHM+2+b4POGbyztsKWw1c47/hws6LhBqhw+ZXB2NjoKuehcl7xqvKN?=
 =?us-ascii?Q?AIif6jy78KxDuFIUMv/i9uu+FuYFgCFx7dsF0pF0cgvUZxg8qs6V30++CTkk?=
 =?us-ascii?Q?qCKTqj5gcnAhX2pfQPJVBsxbqu+3x/m8THcqvXcgjbGoErh6T3rDZVmFKaFj?=
 =?us-ascii?Q?utDfYf3+GM3qd8gGrQaAvF0a2POnI/fgLc5R0YaZJiTC3V+/WQypLt3BeRPw?=
 =?us-ascii?Q?8Nb4g4rGc30V2Y/kf5GCi6CSQeh39VXnySzpaWFAEkYtj4CEB+i4ReKOORcJ?=
 =?us-ascii?Q?ffC5e4e7yfXz3nT6SqoKLr256DcDJzPvwn2aSHGqij/4l2PvmaLfTgnzo6mz?=
 =?us-ascii?Q?0ugpsk3ZKHPKtry/KESchwXCyXvmEW56jxr0ChIOf95RQEzQlvKF8/IlyTmx?=
 =?us-ascii?Q?VvgYvmhkkN9Xedmm1sAzrit5iVd7z585iqrCoFpXyqq2mEU7Ao9UU22Jwb7V?=
 =?us-ascii?Q?dW9Vrzfm4AgF/98G/7Zlf17AjJ8aAiVwyY1TqNjkrg4Omtgq0nG2ejUsqjGF?=
 =?us-ascii?Q?rStj8so+icPtIqxZFJvLv5u0x7clxXa1LKI4dwmDATwfe1dJUw5uRNpapsPx?=
 =?us-ascii?Q?wZpZK4u3qPr7XY02eZB2/vJt8+s9ih/yupczbEjuc7QnA6RXIiUjPJuhjR6y?=
 =?us-ascii?Q?viy2j9r0Xbkm/jePHcDx4xsuwBu9m9JhKXrpVPsF6rdQOWutVkDk82+PMvPi?=
 =?us-ascii?Q?Xr2Ic5rOtxfwcdOg2WBc78FxycoFE/2qFWln86MV06duoEAYaUKBHcoQJObm?=
 =?us-ascii?Q?nrdK8EtWZzEpzYZ9/WSOJiVIXnV6PN/EqxgyyAaX66YWy8fDbGxB/zuQ8wj5?=
 =?us-ascii?Q?PQov83hdaYXBiVDipOFrxPzM8UFLD2PoCBrcj//mVFjUd6l6o46FPY+Q7v/6?=
 =?us-ascii?Q?+AHnYGhwls9Th3QHUf9wlGC5fh3wV8YW8Re36L+ukiY96lvQoz9SijS6T+lu?=
 =?us-ascii?Q?8wUYacWYHf6Mx3BBFN5X8o9+RkjOwo23dEz90yEAyvpJsiJOwCUyaUUx0dU4?=
 =?us-ascii?Q?+gLardiKsW5RRLpjtC4614cxUXnGo8EzkTfTAdMmcNaeAswxGBkaqG0C2Zql?=
 =?us-ascii?Q?w9dtk59SvpUYNLqKOAGKRwcp58ixQHGQkYIKzlwg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce6f2fdd-acc4-4dae-fdf9-08dcce86762d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 15:13:28.4764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gxpaOoWxyrvgeYPFkmGBTgPAMiwxBRDXHTOZyABG05LYlVD9rjWIghCCcGETlYGS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6069

On Fri, Sep 06, 2024 at 02:22:22PM +0100, Will Deacon wrote:
> On Tue, Aug 06, 2024 at 08:31:23PM -0300, Jason Gunthorpe wrote:
> > @@ -1373,8 +1368,6 @@ void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
> >  
> >  static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
> >  {
> > -	int ret;
> > -	size_t l1size;
> >  	size_t max_contexts;
> >  	struct arm_smmu_device *smmu = master->smmu;
> >  	struct arm_smmu_ctx_desc_cfg *cd_table = &master->cd_table;
> > @@ -1385,71 +1378,67 @@ static int arm_smmu_alloc_cd_tables(struct arm_smmu_master *master)
> >  	if (!(smmu->features & ARM_SMMU_FEAT_2_LVL_CDTAB) ||
> >  	    max_contexts <= CTXDESC_L2_ENTRIES) {
> >  		cd_table->s1fmt = STRTAB_STE_0_S1FMT_LINEAR;
> > -		cd_table->num_l1_ents = max_contexts;
> > +		cd_table->linear.num_ents = max_contexts;
> >  
> > -		l1size = max_contexts * sizeof(struct arm_smmu_cd);
> > +		cd_table->linear.table = dma_alloc_coherent(
> > +			smmu->dev, max_contexts * sizeof(struct arm_smmu_cd),
> > +			&cd_table->cdtab_dma, GFP_KERNEL);
> > +		if (!cd_table->linear.table)
> > +			return -ENOMEM;
> >  	} else {
> >  		cd_table->s1fmt = STRTAB_STE_0_S1FMT_64K_L2;
> > -		cd_table->num_l1_ents = DIV_ROUND_UP(max_contexts,
> > -						  CTXDESC_L2_ENTRIES);
> > +		cd_table->l2.num_l1_ents =
> > +			DIV_ROUND_UP(max_contexts, CTXDESC_L2_ENTRIES);
> >  
> > -		cd_table->l1_desc = kcalloc(cd_table->num_l1_ents,
> > -					    sizeof(*cd_table->l1_desc),
> > -					    GFP_KERNEL);
> > -		if (!cd_table->l1_desc)
> > +		cd_table->l2.l2ptrs = kcalloc(cd_table->l2.num_l1_ents,
> > +					     sizeof(*cd_table->l2.l2ptrs),
> > +					     GFP_KERNEL);
> > +		if (!cd_table->l2.l2ptrs)
> >  			return -ENOMEM;
> >  
> > -		l1size = cd_table->num_l1_ents *
> > -			 sizeof(struct arm_smmu_cdtab_l1);
> > +		cd_table->l2.l1tab = dma_alloc_coherent(
> > +			smmu->dev,
> > +			cd_table->l2.num_l1_ents *
> > +				sizeof(struct arm_smmu_cdtab_l1),
> > +			&cd_table->cdtab_dma, GFP_KERNEL);
> > +		if (!cd_table->l2.l1tab) {
> > +			kfree(cd_table->l2.l2ptrs);
> > +			cd_table->l2.l2ptrs = NULL;
> > +			return -ENOMEM;
> > +		}
> >  	}
> > -
> > -	cd_table->cdtab = dma_alloc_coherent(smmu->dev, l1size,
> > -					     &cd_table->cdtab_dma, GFP_KERNEL);
> > -	if (!cd_table->cdtab) {
> > -		dev_warn(smmu->dev, "failed to allocate context descriptor\n");
> > -		ret = -ENOMEM;
> > -		goto err_free_l1;
> > -	}
> > -
> >  	return 0;
> > -
> > -err_free_l1:
> > -	if (cd_table->l1_desc) {
> > -		kfree(cd_table->l1_desc);
> > -		cd_table->l1_desc = NULL;
> > -	}
> > -	return ret;
> 
> Why inline the error path here? Sure, I get that it works both ways, but
> it seems a little gratuitous to me.

With the change there is only one goto.

But sure, can leave it:

[..]
		if (!cd_table->l2.l2ptrs) {
			ret = -ENOMEM;
			goto err_free_l2ptrs;
		}
	}
	return 0;

err_free_l2ptrs:
	kfree(cd_table->l2.l2ptrs);
	cd_table->l2.l2ptrs = NULL;
	return ret;
}

Jason

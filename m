Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2064.outbound.protection.outlook.com [40.107.236.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B258E14A633;
	Tue,  4 Jun 2024 19:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717527780; cv=fail; b=R6G4E0n/tUKDb2jLx9LbelweCtwKMX/BP6BtwmJQWiYILrXEGB5oykew4XvzZB6NLalLtkXyi9t2UP6SNj1wDjTR9c5mHOBuujVOFKXN3VLhm7YLSkYg1bIjpl0FwmqbMRauTnIxgWjlUiiVov+0mB3cwuq61VJ/4A+tTjJwkdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717527780; c=relaxed/simple;
	bh=4kICu/8I6NTaNZ53d0bOYi//5AjuwCuTolPYG0Q6DBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Doy8bikhzYmqk6lvbTiSFFfcYcAJgKPcvP+gMLoE66z5I9WkITAyvJ5m2CxcHAOlXEZIZOxxmmRBEJ2kOPE4mfuwS4Frv/GszzS2xsaxTLGTPVuUhisGu5erg2JewUuE1V5CscbCahnXnkRluMO9sXZIqlorvLsfYVhGhfaJMmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=j7iHjQDv; arc=fail smtp.client-ip=40.107.236.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="j7iHjQDv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nx8hByqaeAIMiSvcJs8bZGzYYO7E5rgujrjc0ZdEg4Y374QILS11ZtaagS6YdR83nul8EEgy5bWD6Y78gy0oeoYz1hNLB2moL+styljcy11FrHp02Pd4JWw1DzbvGeEBLnm/aC8VD7M2fPpBncnk/45l4+esLT64uAaIisSss3lr7AeLgmUak69+LUPTj5ywKIfGfbBtv8oyxM/f8Qxes/lllSSRpDWA1R1QMIqk7bm8ks5qagheJPHB6GCQSV6CLEZ+Y7uI0N1mGyy0qMywlhueWTcXs0j5HQyn+xnflowvUajbXFjDdUqUW61ERJqqJthhdD4MsRyVRb/GPWNCjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H+tLeeCS3zQd3kBY5aFzm7VWyj1oU04HzNH2lABCnqg=;
 b=UYH/o3WFaxrwiCsedZac0DHBO5mLMJU/B5+VqQ+mM1skL/dj8YJDPkN3Vb9H3h86taqZbV87FNgY0/vrPWfgFfu5UpZpQdfyLs01irb5PVxChF7zMZ10HeKC6/l4shZTE6iZxXdXd5oeMF+rL37tjr/f0bUPQDUmbIgdXHMzCPAJs+Iv0rqOP9r9F4dvKksJQ7q1RlLgoAJi1AxD1U4RHqYETolorQ2IdDEAGRGaFPQNaWyG0UAPaHUWTAWdev1njJm585yvcSmbVPF7Cuuvrf/L1gCZFHM806Ix+IqKFaMTp6FwZauvLdUygidPUpMvLInMjt6TqYM4Vhvwjoe9wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+tLeeCS3zQd3kBY5aFzm7VWyj1oU04HzNH2lABCnqg=;
 b=j7iHjQDvA3NkLrr01fsKoMX5EAnJLZ5XZFROeoEcp/LMdQc/Oaj+y2HyqnhwieAEShxnVl/AYyNAb6N6PB02p4L3618GJwwlcKy4OzInnyx6lnxxYbVXiaF7shhAw2d/ib2HivksKKul6iTygGR4l0NrMQf3wMuhYSQ3hqm0Ynq4zisnwnARGfv48l0HebrPqIYDLzTuCUMW1u2hsWOIFxHKuAK14qFzjnWfq/lXoRY2wX37FFzJOpNgs8tacBhvY/m+o53mGvGKwnaPIBEKkaLZu5ai6MENAPPIUyb02/hUV9s+6oqUTotq/6XdwtuO747X/bCF7HLTXKOuydSZ+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SJ2PR12MB8649.namprd12.prod.outlook.com (2603:10b6:a03:53c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Tue, 4 Jun
 2024 19:02:49 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 19:02:49 +0000
Date: Tue, 4 Jun 2024 16:02:47 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 1/7] iommu/arm-smmu-v3: Split struct
 arm_smmu_strtab_cfg.strtab
Message-ID: <20240604190247.GP19897@nvidia.com>
References: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <1-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <Zl7RFCZhAbI/DzwC@Asurada-Nvidia>
 <20240604125955.GH19897@nvidia.com>
 <Zl9ctWSM6m3gkH5T@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zl9ctWSM6m3gkH5T@Asurada-Nvidia>
X-ClientProxiedBy: BL1P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::18) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SJ2PR12MB8649:EE_
X-MS-Office365-Filtering-Correlation-Id: 35dd7670-2256-4903-72ce-08dc84c8ed45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sZpu3YE9Q8+1kVAtlS+uJ+ofqZHfMI7L4XZQLMZFfF2o5ZY1j3vLv5cJ+sWI?=
 =?us-ascii?Q?lOSdry+/zMAkUcg/RTvmTZh8xDklZJQzrsZcgDrM8I3yWZP9CcedFFG7BjsM?=
 =?us-ascii?Q?InoqJha2qDAPa6FPqxTuMMMy5Mecc6CNt7UHWoxuiofs3CCbVG8yJV5YdVBU?=
 =?us-ascii?Q?o0KQ2QXoFZfpSLCUh8bhsNsccS+eZySj6pUARpsZjvdfVGN4IB5IIsb/Sdxi?=
 =?us-ascii?Q?VF6UO4wGjS8wXM05eBZJC3vxOAKYQ26jmMb8U6NR6tUibIB95DPv09qu3U0X?=
 =?us-ascii?Q?nZA3HhtGvb4guZrSg8nuhImdBw7Tbt7FhZ16MScPrIaEbYSihm5FZYis0tvG?=
 =?us-ascii?Q?MxGG/+y5yyW6EZ2ntFD0zFLjfNbGTT37sKJeKkJsf6DA/HuOyYGz7MywCIA5?=
 =?us-ascii?Q?luMYy1BR9Tb0NYuvU0GiC1zQwh3+x6LqN+njTD+C2HBnqQgkrAGjRGLDrCIB?=
 =?us-ascii?Q?6qK5vyS4HCq/T9+wc1YYU4DS+kKCC/BfjxgW253GnLPhKoBsGObEd2+Nswwr?=
 =?us-ascii?Q?+tJJS0zxkMzZy1eaxSy0sy3JvKVZYXSzS0uBBr/DaWPNS/gNXq1rOWKo6Lbz?=
 =?us-ascii?Q?Olh5y7mJeuJXsgV+JcdH8dDQxeCn1ZeUc7D9Q+shTQ9/B2YxcFYsyxEUDrMS?=
 =?us-ascii?Q?Mk+Mp8enDtJZD0euK2YGTJ6jMTq7ojv0hab38N+esiC67qpE3KXw+1f8XuM3?=
 =?us-ascii?Q?hYJ7uH6D8KXOL7EBnLrhCX+3kE5nmwzI4kEOAKtG0ywV/F1zW1Ep3YsAv/Xr?=
 =?us-ascii?Q?wIaI+lYxdAcpgTv5XcHNg02Vy41TiTJCn/4ne6QvEU7c2FQ1H6p+zvsRYshr?=
 =?us-ascii?Q?Vj4KTJzcFGpjUAvrmSMMNEWa3EDy/5S4933BKq+2flluAOLeOsaPe/q5NkSO?=
 =?us-ascii?Q?bB3H7lvxjAZNz4X/3SgZ2+aHysYm1YPOr4Fw9zorfWImws01XzLNa+rDyq3g?=
 =?us-ascii?Q?/kPP1f85DYTLQn9VVNKBUIuSO/hr7S3VKJqK5Zo43j7fkrJ6TB/5EJwka+Xq?=
 =?us-ascii?Q?7zv3HzVBdS1FZZoul8LsEmrlqN7Empo0yEVfDYe2WjTNmrtn5B5Y+PWzS2fr?=
 =?us-ascii?Q?cAaO7ThaIXhtUeX9YuHEga0joHV6JuCB2AmO9evcUl7FiW8/yfzCuFQqz7hA?=
 =?us-ascii?Q?Ks+YiTOlzrpaHt042ZSjim4IWP1cScpNKRZ6rWx/+E5wKRUWkw1gALONAkza?=
 =?us-ascii?Q?RJWLgOaAmICDXxEwGIV3D72tCpWMDqCJGq1Ssb6+/8uU++gJKw8HgzJRHA00?=
 =?us-ascii?Q?Lgsc+BvJEK7mX++fBXDp5EzZuC4R3NEaYRUWgzxXEQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ScN14bmE1fHfxtnz1w9d8B5Pr7Tw9IXjPn/M/x6YNLUGwseoWHZnmK+HKW77?=
 =?us-ascii?Q?MH9K26MpFkjHvAH7P0ZtVfl/2cSznwcsisdtywLzZj4zyXPaNQgTrUH5WZBG?=
 =?us-ascii?Q?J0mIreJg9tvcQVhQHbYNHxsnehvCLr07mxCXUmTxUss9Ppcz/1pz+mgUyDc3?=
 =?us-ascii?Q?vYg9uHoVz3qizU2udWBfrCyPCf/TuZxSdbwMDYkeFZQ/pC0DNln33z1DjoOC?=
 =?us-ascii?Q?weKPuAS10nV/URTMX7a28pmxqqxZf4HoeScTTqwX4ovmdeFy0WZqbh1Khk/5?=
 =?us-ascii?Q?o3fERcIaHZEYUu5ZAj5xCvCCgxNm688EVEX5wsvSqq7nerJGE/8oRBiGVegM?=
 =?us-ascii?Q?jILoKlGcuJS4wX2dKZ3HYrDGZrMhkUX52iZzAHfN7hPWlVD4Cmlz0OYrm4yF?=
 =?us-ascii?Q?Vo0iTNpQPVcZH7VebFRgr7CHjvnrgW4rKs/WPVdiHRAG9l+HNmuLBfS8Vpla?=
 =?us-ascii?Q?jLwdLOh9ABXh9e2lPWWXtlC9PdcHPJ0mv1hH2ULXNHQD25N6zOXNT2m3Ae5w?=
 =?us-ascii?Q?+2a0zDadYlv1I1VAyBeTO8b4qWV/y73fsCcdksoYdJSA5pKpMq8YAIdhyQhs?=
 =?us-ascii?Q?nIPcr9oN/TKFJTfiEWWfpfXaY4vhN9+QCibvb1ENnYTR3grpXLQFjH36ZcvU?=
 =?us-ascii?Q?zNE/7N5TVOiz5pLLQw1WHlLvQrQrqSYrKas+lJJfGs0LLx1W8EvapObE45UH?=
 =?us-ascii?Q?GFYgpC1rXW4p05I0PlpYLkJy/DlO9Vv1hRUh/7I9ZKytlcH62ZMmIz/q3282?=
 =?us-ascii?Q?Ez1qrY/bHPBVV+LCj/KfB6JbULwBCri89zhWul+EgOLhZWmaw04RM+VZMz8n?=
 =?us-ascii?Q?I5OBbGzxJMMh2dPAYSWyGWZz1SvU0su11z8fBQyQZJmCig7PJCgODfpNU+Yt?=
 =?us-ascii?Q?8yzjIVBy5Uj6u2clc3dEozXpUTzbLIMPeg7VbbJVHXhvFSfuA2sg7wJAmtJk?=
 =?us-ascii?Q?MRexHjarU06VRahBcI4s4ru4BI/AlH5jhOaeiLHmgqlZ7wkeanEvqFW06ID9?=
 =?us-ascii?Q?HhEcY2R1HWhUFGTRHveBxW99IBa1tqI3NGcd755KWzxAqTD3qg0+V8PmCu5r?=
 =?us-ascii?Q?qKsA4RV2jLkXNZ18e9NFdJceMt3krGDK4XNjEMp0HRAu8PMAblxRwmL3Zi9Y?=
 =?us-ascii?Q?Mmam4GgR0wUPhfoImoPKIbiK05BopfQcBPwW5xhbrgkpnLtYdC/XfZqAiJOx?=
 =?us-ascii?Q?1awjVz59sUxq5W7go+ZN+GPmpz41s9YdUtKoBKHjtbk56sWSR9UTj3Ltkis/?=
 =?us-ascii?Q?mdSkOxtPgX9uDF4hAGjnEtoMFouLbdsKBvVU0Ss5z0LctLGQfk7NQTByv1W+?=
 =?us-ascii?Q?8986qhKh+s80XQyfqaxY7gvONFS3oC+pelRGZXqiN/ywlSpUG0MVEftKCO5r?=
 =?us-ascii?Q?uSQyIu3ELCK23coM/2kdldeTLGEKlk6lyWVu1n+C0yatGNGanejjyNEUjKlh?=
 =?us-ascii?Q?y6oNrBqBfh9UYBzGmuVSp6NzeiI9t+Rko4gkWU2ND7YB8gu4ZIZhYg/YM8AF?=
 =?us-ascii?Q?bKsx6xEkdHeo6DMiigtyBC+7jYdMFyh0b/1PWck/cNNN+DYT/2PaNUpC6SdH?=
 =?us-ascii?Q?TPhSXVkuCjeFUYcowsBMnWHEqAiLqvBD1LQNabBr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35dd7670-2256-4903-72ce-08dc84c8ed45
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 19:02:48.9702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7oMUS4HuDQzvoc7VWvOG03BB+HLbd8oQEyomckU5sblPPS97c12CquSQve+TANoP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8649

On Tue, Jun 04, 2024 at 11:28:05AM -0700, Nicolin Chen wrote:
> On Tue, Jun 04, 2024 at 09:59:55AM -0300, Jason Gunthorpe wrote:
> > On Tue, Jun 04, 2024 at 01:32:20AM -0700, Nicolin Chen wrote:
> > > On Mon, Jun 03, 2024 at 07:31:27PM -0300, Jason Gunthorpe wrote:
> > > 
> > > > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > > > index 1242a086c9f948..4769780259affc 100644
> > > > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > > > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > > > @@ -612,7 +610,10 @@ struct arm_smmu_s2_cfg {
> > > >  };
> > > >  
> > > >  struct arm_smmu_strtab_cfg {
> > > > -	__le64				*strtab;
> > > > +	union {
> > > > +		struct arm_smmu_ste *linear;
> > > > +		__le64 *l1_desc;
> > > > +	} strtab;
> > > >  	dma_addr_t			strtab_dma;
> > > >  	struct arm_smmu_strtab_l1_desc	*l1_desc;
> > > >  	unsigned int			num_l1_ents;
> > > 
> > > It looks like we have two "l1_desc" ptrs now in the same struct:
> > > 	strtab.l1_desc	// raw level-1 descriptor memory
> > > 	l1_desc		// SW array to store level-2 descriptor memory
> > > 
> > > And it gets a bit more confusing that they even use the same error
> > > prints in arm_smmu_init_strtab_2lvl()...
> > 
> > Yeah, I noticed that too, but failed to come with better names.. The
> > CD has the same issue
> > 
> > strtab.l1_desc is a pointer to the data structure that the HW fetches
> > that is the first level of a 2 level strtab, it stores an encoded
> > dma_addr_t.
> > 
> > cfg.l1_desc is an array of CPU information for each HW L1 entry,
> > eventually just being the CPU pointer to the L2 STE table.
> > 
> > So they are both the l1 array, just one is a CPU pointer and one is a
> > HW/DMA pointer.
> > 
> > Let's call strtab.l1_desc --> strtab.l1_table ?
> 
> Yea. This seems to be good.
> 
> > > The "struct arm_smmu_strtab_l1_desc" seems to be only used at one
> > > place in arm_smmu_init_l2_strtab(). So, how about:
> > 
> > I didn't do it but, it would make some of the maths more obvious 
> > if we encoded the table structure in the types:
> > 
> > struct arm_smmu_strtab_l2_stes {
> > 	struct arm_smmu_ste l2[256];
> > };
> 
> I personally prefer this one, though why 256?

#define STRTAB_SPLIT			8
 
> I was also thinking of an alternative by separating linear/2lvl:
> 
> struct arm_smmu_ste {
> 	__le64 data[8];
> };
> 
> struct arm_smmu_strtab_linear {
> 	struct arm_smmu_ste *ste;
> 	dma_addr_t ste_dma;
> };
> 
> struct arm_smmu_strtab_l1_desc { // so as to drop TRTAB_L1_DESC_DWORDS
> 	__le64 data;
> };
> 
> struct arm_smmu_strtab_l2_stes {
> 	struct arm_smmu_ste *ste;
> };
> 
> struct arm_smmu_strtab_l1 {
> 	struct arm_smmu_strtab_l1_desc *l1;

num_l1_ents too

> 	dma_addr_t l1_dma;
> 	struct arm_smmu_strtab_l2_stes *l2;
> };
> 
> struct arm_smmu_device {
> 	...
> 	union {
> 		struct arm_smmu_strtab_linear linear;
> 		struct arm_smmu_strtab_l1 l1;
> 	} strtab;
> 	...
> };

Yes! That is quite readable and understandable! I was relucant to do
much more than just the small change Will asked about, and even that
expanded.. Let me see if I can reasonably squeeze that into a small
number of patches.

> Only arm_smmu_device_reset() really needs strtab_base/_cfg values
> that we could compute them over there, given that there are quite
> amount of smmu->features checking already?

Certainly could do, but that seems to have less advantage..

Jason

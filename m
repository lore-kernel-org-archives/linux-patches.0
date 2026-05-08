Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013041.outbound.protection.outlook.com [40.107.201.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225FB309EF2;
	Fri,  8 May 2026 15:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778255397; cv=fail; b=FJAN7PZ05JdesuOprjCWxskYb1j6EWRpxlIJvXfR9wfp9yI3GZZldAWekulbCKt7W8031bYAn54BGIKQLszMvuGnfEsqBRU9+X7+yFxepoSnJfDnwPU7Vg4PoFm+2rYCWfPD/VBmcCmo9Bh+GJC2cKSESIMFrbpTY+82GjRbiL4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778255397; c=relaxed/simple;
	bh=/rhjHec6E2zldfI9g8Pt2Xg+JkpJH4QRR3CgbIXiYug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=p7d9nVgJnTJ+AFwk84KQK5cZfovnnFnJ4M/lMOb7VobeJisy8PuQ9TfDkK9kBz6uRyTZzH4GCO/NRda6qWTX3cnCCBBS86UdFjDeZ1jD+Bi5v7BTr9wCqqy69MvH2ngkrLj6hCghfFTIDLG17pcN2aZsCOBWIUVQWVvJQBhjzQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gmNFot7b; arc=fail smtp.client-ip=40.107.201.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gmNFot7b"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NGZIql8ldtmmJ2GFUu5SNx793OzhW3vkbcPYdkB3RsvNA/C4MX6TfSXrnkqL6+CFJ5qO6H3SfBwP+Zvv2MqGa5Z136Z9X8ulE7t3aVpyARBaBWg/a3N6++ukLJbJZqeMJMIg7br9aaJpXR5lnE8OTQsjZ2qzqORt15NrI2pkxusb99LeeXbhLKzvKukols5Xu8jv4ENBsFPW34SGBJZ60lnudsdT877RIINHEj6O8g5wQVgkVoFpfLcZrt++Ma6gPyzHaClOIljAKwW/aPmSYL1Fc0LSPKUslEz1bRWH1yRuFYUDbI1EqtA6oiZGeLawl1PZ3UnMGquZcFQOK4MLZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VE3Q8gnDsF/vESQVpdQAMyHbfIuMYYjbbOQy/pMP41g=;
 b=xeh2ANxKKceHa38dJuFiCAoNWdAEeQSv3vTTsDSgkE8zQD9vKVtG5uKjt/SQZIOULcnYeazpdUg6QaP0FiGIAS46FfLZkMX4e4GY1PDV28jKurOia3zcvHjhTF2wWJqQi2Y0HtfsFhP4TqWUFEEWiwd3+/QzlJ4IPliHvRyvX56/AcnF3GYBk6iiDqsj9HkmrAL+kJ6hwVssiPwo12BGJwLB32jzbpC1hyp3sxEMrCBqlLd/7HHtT6VZPHerw9HbKb+8WmhYxD80wzreCIIFaESuos94Sr0x1asuO+I+ZKQo7NGPavqCqmT9jW8VeXtSAFI7OizY/RhiBqE99Evs9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VE3Q8gnDsF/vESQVpdQAMyHbfIuMYYjbbOQy/pMP41g=;
 b=gmNFot7bRDT0aCcRlY+vPSvT1yY6HiDrZuvMBREADpxCwZgHaTT4I8NqQiBk8Toyz40hrS3Q4rm/kMgI8Xs1YcYKRV2Yb4OOshY+AFou9JVb+xe1Ler8G0jJ4UWshfmsTmWgLuhg9gyb21eS0L0nzSF5uj3ZM9d1pWR23Fnb8Od3ryzZsvqZ8ibJcS9nXqzQctDluNM0xmFrvRHgp9DIJRBtQ4aNjw1wjfA+t5dMP9o2vXsjgeEDTUUx85J53NXJBkHe+LB0FBZXiJ8QLLq94hEoxFGK0+DrRVQETWUO8JoC8ivEJl220eybLHyFsu9t+Fpvk4M6W9s9a74Op1+AMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.18; Fri, 8 May
 2026 15:49:51 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9891.017; Fri, 8 May 2026
 15:49:51 +0000
Date: Fri, 8 May 2026 12:49:50 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH 2/9] iommu/arm-smmu-v3: Use the HW arm_smmu_cmd in cmdq
 selection functions
Message-ID: <20260508154950.GD9254@nvidia.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <2-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <afxZmOP6m_Khatj8@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afxZmOP6m_Khatj8@google.com>
X-ClientProxiedBy: BN0PR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:408:142::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH2PR12MB4133:EE_
X-MS-Office365-Filtering-Correlation-Id: 21470d44-791d-476e-8b45-08dead1970c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	y2FuYUKNgMPqXU7ARnVKykJydnOfJ2/1b+wtGQax/Muywt0cpjZTHfrLL7l7WjUWCf//clrRY/gl5zflaeYGBGfCsR6zSbUW9Lbf+yyU696kojzl12bsczHbYYCVS9Q1OwCVL4I7yJB7m7AniPrehGLdDR0KlpvN8jzixNCmMua/g394zwG/Dve2PkdbULe69hXvkxfA3rZfQLRsKd9f40OBiUqvm+SjqufgwmEKUAkOOG4MgyYbq8jhi0WG/cewNNxq5+Pxmrxj+e7g1VjgRCv1d3vgLJurFMtjjrYu4h+O7kPaioy1VAj6/1s/9ydSGloqy+opuNALof4sSXseyLK1/R2F2L8JAq9MWlUr7SlZSEEiFHmBUImAmdHq63ky5Xhmj0STKnNMmmfgK/0StjsxG8WprNG9F1sJKHyTVfjgJd3Ft1KSfd07vP8XDPcWrxojAo9kaNQ+ommtBr+RQujiPXtMn+xSxtyR9nM1YEGX7Vq6xEAKPOH5daNY7Hh4K2x9bsABxRa2OMGmVdr0TtgJtb1FLtqLio53RCxVHp/GYuJ78RRIO9PzWY8ggz4VIy86DESCdci7uLFHbzJ4EWB+pYzz+givW1uQGFKqv9vFDIYqJFeXXZtNUjFoL1U6+IU/lcvVKU6DCWivwFeG9mKuWfW/2xLykoph1YSUejYI8JoJ/3yd6qZxyRdfAq1D
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4q5v2pD/sQdA1bK/NVXF2I3IyriEMCKFYqqEzRFWfjc5VrLp8MKz2fk35X1M?=
 =?us-ascii?Q?UNeduSbBxuv4XWNPVXLo/fSMt1MflzVAOLqUV90A57Dd0qS+pL0xPh2Qi4d1?=
 =?us-ascii?Q?BUKZ+IWX8UDUHiz7V52BUdpabgLlxnd1Vb4Lpm54t4FpYsHt87lPbb8MBLsx?=
 =?us-ascii?Q?gXCn1O7bfdN5IthQyaKt0I//0B6keaD0P4Fre+0SjfSoES6L/WJtDG3ygygc?=
 =?us-ascii?Q?Cv8Hkp3mfZPhm9HMcY47z37yGer9unAJ/T6C/CltCfyGHdODNEQ8BhhAkZF8?=
 =?us-ascii?Q?F7x3zeV6d+1jO6DFn03ABttLPq6PlNo6EARoMAtRc8OzJlARct/jmwJxUxxL?=
 =?us-ascii?Q?TuZ63Kj0ocNd9KQmSLqMs9KaFAWOXSGrCwHgaEd6eVX8GjN2gbVXmP+KUxUT?=
 =?us-ascii?Q?Gd53tNdmKcjFR9VaHRBv1kqTMc642jhk9e8C9CXUAbpND28ssY56dIGrdanL?=
 =?us-ascii?Q?iihOGaw8fMehfCsMf/m2CaqSuSIxkVqBr0ltKh646LqjA4m4QIU1XYacyxua?=
 =?us-ascii?Q?21LvV3V+FCXJROz0dM7Vh0Vgc0AhONJpm/iQr5pLJFWCC0e2u0H7k/lUw6LB?=
 =?us-ascii?Q?WsOb/lHmSHQlBcLYw5xubMuby/APuDbHIEHkFOgGjz06H3lfOroPFOvzqv7U?=
 =?us-ascii?Q?IcdqhzFBjUQJHdnFMjsMenvdO+aWFGGfTnVVaQH/AnSnMVDlczGKedcgw4Zj?=
 =?us-ascii?Q?argRsN+FN7tWNYYLgq5Lni8NJFNdIfwNfR2dJ05KpjXlly0D5P8PysVrmXyM?=
 =?us-ascii?Q?hYwoHNn2XlY0HgmkZzD0KmoFejm2lZVOkEo30ey49h8JVSrcQtlegkkK0VRL?=
 =?us-ascii?Q?a7mudHbfCpGMZt0pMRoctR51N6C7vK6tAQaDEtVnoALpsFuU/0CpXK+r7yPh?=
 =?us-ascii?Q?KRzpFHjG+Lk6O02MOo/gYsEQrDh/SdO1JjjNo1zpwWSxjime5Y1V9BKtOkNw?=
 =?us-ascii?Q?yv6VjfYlXVkvk9c63iFImrTPzxpKwfTCaQh8jcryGkou/oZGfBtbFQQ6PwbY?=
 =?us-ascii?Q?w0Fwaw6LFWsi/bFOf9uQe/CgGCJYhTT1E7f2nwdcqO9MEDWrM/RqLS8Mswkb?=
 =?us-ascii?Q?PWZKwzE2+MUHQBZEgiObfimHzvogYXVl8e9BADXXgkvG/vL/GOqaJsEXGMOV?=
 =?us-ascii?Q?qv5gFxB1lczdLR5/6Yd0g4qFwp6p6Xit09IqqdrlrHXIin/iHYoUaR6yi/Y4?=
 =?us-ascii?Q?4SVPbK2ZwpYpi8zQIkhXC/j245ll4TzONRSlzz/KriJ0S0tyF2hmT1yQcgfK?=
 =?us-ascii?Q?aifme1HFW8hMIKfUUzvoICu6KOaAeX1MFoL7c18yLTjAwzsczY4FHGzDTRiZ?=
 =?us-ascii?Q?PgGDS2ig5zo83K7yAEHh0cer/G04E84Az8Gskf7i3CGkrdz4zNhPBoUB7jT3?=
 =?us-ascii?Q?hNGUhvgUMYqXZmZghz3Mu8VVCIySJp5x2itfYzx+DxNcCWiUncf82gPOBkZg?=
 =?us-ascii?Q?uY/nXi8p6tgdKMrIvYJWXn+xhg+77dmP0fv/Ru1X4rO5OyYM6p2SQYk2d+F2?=
 =?us-ascii?Q?05ovPHQB+tKHm2cc5eEUivaw8u9OsXrcxbY1mOYQBspvLQoFaomAoHBoBZ/D?=
 =?us-ascii?Q?1VNjkCoxlbc2Ulh9kwteMWF7t9G+hEpqXI7xPiWZYMf/ZqNEEOgduZCJbp7w?=
 =?us-ascii?Q?Qzv2aoNnVM6owcImUsa5fy0SomiEq6/ZFYWjYX3BwQ8730ePwQWz06g0qFdq?=
 =?us-ascii?Q?siF4BC7Xk4Ow0XJK3PP7pbBoCDiOyfFtoNSIY+yKrid6l5Bi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21470d44-791d-476e-8b45-08dead1970c9
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 15:49:51.3150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LmNi8C8hqVVRh/K6wy0iXQk5+LcmgKQJjx3DizJ5s7+AJrBbRkBaBD4csSLHlfUE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4133

On Thu, May 07, 2026 at 09:21:28AM +0000, Mostafa Saleh wrote:
> >  static void arm_smmu_cmdq_batch_add(struct arm_smmu_device *smmu,
> >  				    struct arm_smmu_cmdq_batch *cmds,
> > -				    struct arm_smmu_cmdq_ent *cmd)
> > +				    struct arm_smmu_cmdq_ent *ent)
> >  {
> > -	bool unsupported_cmd = !arm_smmu_cmdq_supports_cmd(cmds->cmdq, cmd);
> >  	bool force_sync = (cmds->num == CMDQ_BATCH_ENTRIES - 1) &&
> >  			  (smmu->options & ARM_SMMU_OPT_CMDQ_FORCE_SYNC);
> > +	struct arm_smmu_cmd cmd;
> > +	bool unsupported_cmd;
> >  	int index;
> >  
> > +	if (unlikely(arm_smmu_cmdq_build_cmd(cmd.data, ent))) {
> > +		dev_warn(smmu->dev, "ignoring unknown CMDQ opcode 0x%x\n",
> > +			 ent->opcode);
> > +		return;
> > +	}
> > +
> > +	unsupported_cmd = !arm_smmu_cmdq_supports_cmd(cmds->cmdq, &cmd);
> >  	if (force_sync || unsupported_cmd) {
> >  		arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
> >  					    cmds->num, true);
> > -		arm_smmu_cmdq_batch_init(smmu, cmds, cmd);
> > +		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
> >  	}
> >  
> >  	if (cmds->num == CMDQ_BATCH_ENTRIES) {
> >  		arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmdq, cmds->cmds,
> >  					    cmds->num, false);
> > -		arm_smmu_cmdq_batch_init(smmu, cmds, cmd);
> > +		arm_smmu_cmdq_batch_init_cmd(smmu, cmds, &cmd);
> >  	}
> >  
> >  	index = cmds->num * CMDQ_ENT_DWORDS;
> > -	if (unlikely(arm_smmu_cmdq_build_cmd(&cmds->cmds[index], cmd))) {
> > -		dev_warn(smmu->dev, "ignoring unknown CMDQ opcode 0x%x\n",
> > -			 cmd->opcode);
> > -		return;
> > -	}
> > -
> > +	memcpy(&cmds->cmds[index], cmd.data, sizeof(cmd.data));
> 
> Maybe this would be better squashed with other arm_smmu_cmdq_batch
> patch to avoid this memcpy, but no strong opinion.

The memcpy has always been there, previously it was effectively inside
arm_smmu_cmdq_build_cmd(), now it is here. A later patch turns it into
a struct variable assignment which is still a memcpy.

The new thing to avoid is the arm_smmu_cmdq_build_cmd() at the top of
the function, which doesn't go away until the last patch.

This memcpy remains throughout the series since it doesn't try
directly initialize the batch in place.. Fixing that is problematic
because all the cmdq selection logic relies on an already formed
command, so we need to construct one before we even know what array
index it will land in.

Unwinding that would probably require restructing how the batch works,
which I think is probably more trouble than value. I hope to
micro-optimize the tlbi flow by removing the batch entirely
eventually. Then we'd be looking at writing the formed invalidation
command directly into the command queue (avoiding another copy on this
path), however I haven't written this and it may not work out.

Thanks,
Jason

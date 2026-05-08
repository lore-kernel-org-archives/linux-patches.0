Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010002.outbound.protection.outlook.com [40.93.198.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6237637BE6A;
	Fri,  8 May 2026 16:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778256050; cv=fail; b=KoKF8QXCnsVkrHup0gG2ES+onVb4yXwBLeSWH0dDDQ8/mg3cVuwG3zzNxqYqbOBuEvw6fRqDB7D4+0DdA7KKLv9K58m6J0LHViOJWcG5ZGIjwasR34rupyfqdYjODhV0ejlS7FrJphuIZI2c8GtBoP6IqSDCwT9b5/ePo6eMjAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778256050; c=relaxed/simple;
	bh=Hy9RNzCrNSeFz9hHX5v8qPz3eAcZQZCJBQeqmUQrU3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OcSG1pawZ1p1KCIuQp6yfKcJ6NwKz+NhwfoHTNuJ7wGFmEUsBk2qOuabfiFDJgQ7OloXrRmE1fSWR2OjBl52MxEOmD86slBcTdP435ZsXSfy4EHLP9RjNYDQ5DEotlLjPJRgYNhi4FXBW1QLtrOklPZZtDQ7XNfnvdJinDFBHAg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nz/ab0mf; arc=fail smtp.client-ip=40.93.198.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nz/ab0mf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fQQcul/UmSsyR0bibKyIhY8iekTPHOqcMGG4o+iYKs5sCVyJepaG3CZ7W3VrA/hWKF/KxZ50YkmtxixrKoa3OwEtWjFvEs37qAlUYDPF45f00VoS++vrYQDevxRpK0+PzpjFz7urg8UWwTltriPEWEeyNMbxcF/r7Q2O5ydNy42xbKYxYlVuaxaz1nd8hYhOXDAVhH23y+eMEE81YqoS1n0FcYo811fz16v41dlLJI/aYZ5YAFAifRQCh+90jbSbKoNHBlyR43V2C+y9BKgSgjQ7yW3wpmNa2zLp6vzT51rSkqM9QBZoy9IiOmAjZ3WxoorelanJOlAeTo3Q7aVNKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cp5ENtDhg+hoHs7dq/PEUzIIXjD2P+iS0HCl1mRsakc=;
 b=hvPcL1QNP+amfZYEAtF9SEshaaEAR3DKfMAHw9JO0y3RsAIKWN/jzMq8Oo4FitJi33CXmFDtH44NhQxa3ZWAJwwEhxAJEXSl63+WYOkGSEmulJesY+6SPCFxCPFzNXxxCfxD9KAk2sGUMF7SgKlgCKNzAZkQBO+dDTdfXYwkd4YG0c+hgqSatjfoNl/WBpzLd20p1Tnk53qAY0QMBvWqP9uvBCfGRymyaGgGhN3DKxZrR3hQWcaJzRfXrb2iDIkITSPLi8tA7OTKjvW5Bo+kPZJn3dUQ9JNxNAz+X7+bypm9egVbOxJ8E2/HMCZPLPmQz6QgthSPu+Fhc4FmFN8Kgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cp5ENtDhg+hoHs7dq/PEUzIIXjD2P+iS0HCl1mRsakc=;
 b=nz/ab0mfFLeB8w5DjnZQpVvds2J+ldY9FX7ZsDvem9R+3Rcm7A2M9S9s41QI0YHs8aLptw7UUjCbs6OaUg988ZKdYOXbuTlO9ium2vaBr2/rQUXPi24ZmuWoiNWVgyvBiUDhgMWF5VK7I87cOcduMO3a/3zScDzccS8pYJMFgsxsZLoTR6Go91ykmV6mq9em1mhQvKQDfUndlnJm+sy1Ipz8PGOVVtfZXUA82aHUxi+1PqbR9XbYthXKpS8tan0mqdj8yrsbtnwTZgs4+qRxkcWilhaqYqvNRuH13xIRfRHsvB7+/TY4U8GQP9ZMyUXr+JKp59jX5Z7K40o7ltYwQg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by BY5PR12MB4178.namprd12.prod.outlook.com (2603:10b6:a03:20e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.19; Fri, 8 May
 2026 16:00:42 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9891.017; Fri, 8 May 2026
 16:00:42 +0000
Date: Fri, 8 May 2026 13:00:41 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 3/9] iommu/arm-smmu-v3: Use the HW arm_smmu_cmd in cmdq
 submission functions
Message-ID: <20260508160041.GF9254@nvidia.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <3-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <af2ebtfgOPzJMXFK@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af2ebtfgOPzJMXFK@google.com>
X-ClientProxiedBy: YT4PR01CA0268.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::11) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|BY5PR12MB4178:EE_
X-MS-Office365-Filtering-Correlation-Id: ad2f7ce1-806d-424c-a08f-08dead1af4ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	0owXHQTLbMgg2EtbdGCl0+A8VdZa42V0vO3IgU829spjcnSvn/PMzpmHKXyLhz+2B0ZXZg3aEKe4brplDepbaxSq9rCCbkK62GdNPgmkWuGKdBu+B51zBgdfyDfyQMUVsvqXi1Rd4XuN2FI+O34G8WbyyFM0SzQ1pa0ROYIe977GJ5QqKXaQ3onv+MDWLf1vnCkqJp/YH03pxtFdGtIBStZCztccaAh50bTx+C0+bwdq42gnOPnsdBvUIjw5G6+8H+MEzMgkvkBS6JU8f5opmFB6OMQjh5OuzIaJ5yetjQ+ozWpOXLaYcrRNA8oMWhRQKaaTPo5C+Q7tMgV5cHl1TAgTd7ovZ6XK8/X0dSmCCd/HbET+sJihGzJ1bz9SH/2hyS2hYtmPds4oNgKVdd7Q9URTgr3jCacnRhpX1YmgW499b0Ui18tSNRsv/HSx0TcHBtrafIf4zmM67adTACGMochPoqsF8m4GCOoVKDQvoe30zVwXtXOD6kyxl79aSdvDTm0KCMggpxg3Kn6lBGd1wBDoINcnd/rvY0VXcfVVAyFkHMdz9gQY05k7qBDVLo7jCONHC7hrszbDFptbbFjFIB8xsGPzJfZUPdi/AjS9UDBkllKUV+IpN6/bQh09a+bjUBP1hsiPeHgdY9SDtNGpTDjj5AdjDSGmrj2OkZRp6e2Yr6GgmZULjmBT45ZtZH/J
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/K6ZlhTv4yXpv0yZGvjlCQAYD+bqWA0fVh0a5FHkhlihNrSBgPDfjOkjBFX2?=
 =?us-ascii?Q?hj0hrZtpNaQ+fVEsS1VkZ4L6WdAWuvuA2m7aAbPcWltrnN2gDTl6q194crO+?=
 =?us-ascii?Q?ZW3HYt50cPbc4uV9po87YHf7ZpJCA/GBHPohbHpoDcrLgGgGfkfkiASyRjKE?=
 =?us-ascii?Q?V1cEe+mtlnvuXZggmsVAEITEWbPVHTNSiXZSxoFpYuhjeuCa+88aUk1RfyHY?=
 =?us-ascii?Q?HlkE1+CtsSzhpucaKC4kzI/fBUnJCke1GxJQRA3VTGHPRl/6j3cBjzIym1kW?=
 =?us-ascii?Q?gum/Cu5yd7pUv1niF+CcL/XWo9BN9Y7RrxVbS2kStNekEWZezNRloW2DHX4B?=
 =?us-ascii?Q?sIL/mFsw8Na+262Esy8kIKUTkXnYcBrea/ejLiaPkNoRwBvpOzsryyC+wB5/?=
 =?us-ascii?Q?yjUeqDIvThIrPq7XD0BgjAhDlOx2TClH+ots7u9nNQCCWcCe8kfq31JU6Vnl?=
 =?us-ascii?Q?aS/0n8GiUUgDRHNbhQ8+1LM4DwEei1Wti9+qbIRRlk3HugUQlaSclifXvbiZ?=
 =?us-ascii?Q?Gh2qLKs6x7iW/5DW1LuOpF0tkje/M+fL5ySQVrROCuy4XZnp8uXbcfBR6GfS?=
 =?us-ascii?Q?2jDIqxGRCDQfrUsgA7FeljSjok0/yzSKhVaD+VS3HgeG3DEbqw/F8Fz1ZR1h?=
 =?us-ascii?Q?ikAO/onXt2vLJKvapOEqrPoS9t6Ivwpfy7D92Y8KD/nORoiZ9M0haxP7IB2U?=
 =?us-ascii?Q?PD1Me3d92f9kHttZaMtEZFEmlrqSl4kt81arVTAcLAg3XGFgtwNSvqO0eIcO?=
 =?us-ascii?Q?oS9kZOGlomDIq1OPrUp28uUoTMMMTLVEvwvy8Z2mVXL1yHUq2gQeJCL/ciC+?=
 =?us-ascii?Q?kEyn/3xOzfU4DMKQOi78Gvq2PC582qJ6ns0Hi/mx/uLc19lViUOKAFfdRU3o?=
 =?us-ascii?Q?bJX1gh8qbomz27utgsZHO3+O+Zj5Nbg3bRadCrdd8sMCZhvSNJHzhJhZfdFv?=
 =?us-ascii?Q?9GgNKbkdXoocUJfkWvKIooL3yyc4plxrtmGEXIfsGVDApkvLlXUyzTWaQbHa?=
 =?us-ascii?Q?/8nZ7+SqmK7049stb1DUnMkHYHEJmmM2S0ktCnOh71HGxffKLiC7/8ZCTLDC?=
 =?us-ascii?Q?EYsXu4JP7GfG7FwfOTwJnTdtmUNmEv4F4EH9Nu7ncFYFUxEsl2IYyilaLZtW?=
 =?us-ascii?Q?+jnYVHzL0TdxwkD4BNyWIcIEe2cSGi3t1lRUB/zBzNpcguWvznkCOvnQHrj0?=
 =?us-ascii?Q?gdoX/UAqLGc8W6e03/FNF9LM8wYH+rx2MRM6bwOAXiCc9ueNfo/+XTN9D6E7?=
 =?us-ascii?Q?yQZOPf2l3uaxalC55M2hjUdxwh/E1PXA5UPAUn2q1V3wi5c0smq5yFtnrK8j?=
 =?us-ascii?Q?mGQ6cIuC7EVP0fNm5Pghmb6iO0H3GvmOe+VIS9U/x3uwspsjaMCemDYVYLO7?=
 =?us-ascii?Q?poUGVItnWcTCcNx83ckf+JCfDXAZNjiOY896YaTI+JGpRNqwWVbxm5AzVEzV?=
 =?us-ascii?Q?/WYQtxZhBDCYWGNxYxh4894Y6OkhuwEAb1pskEybgSzumAxWt1Eymk1FVVVF?=
 =?us-ascii?Q?LvSKfVLeQVsraHIwBTgQj4iY1AsZ5OWhXPQy6/ibVxQMkd8xjdtBTiL8/PO3?=
 =?us-ascii?Q?3+msg59Hje0sTg2cFxBy2pUi+RhynDG0bXf5ycCYqketKce0mcyb6b1/8Qbw?=
 =?us-ascii?Q?2AjYi4ZxaFXWH2ZINwx06GoiyAlnP5a2nVYmIXyXPGH8T6445MQZAUlBCi+V?=
 =?us-ascii?Q?RUfrbQG1R2G9OZ3jk62eKX6X+CvtHUJ2yzyQN0ChuPMPLjIf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad2f7ce1-806d-424c-a08f-08dead1af4ad
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 16:00:42.0887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aeh4kkEgzKEjdt8NuWWHlgE5IGfya4ESWv2YMEw3HTO4gxRok0zcYVB/QAlFlpq6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4178

On Fri, May 08, 2026 at 08:27:26AM +0000, Pranjal Shrivastava wrote:
> >  /* Should be installed after arm_smmu_install_ste_for_dev() */
> > @@ -4823,7 +4826,8 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
> >  {
> >  	int ret;
> >  	u32 reg, enables;
> > -	struct arm_smmu_cmdq_ent cmd;
> > +	struct arm_smmu_cmdq_ent ent;
> 
> This shouldn't be uninitialized, we only seem to be setting ent.opcode
> later in the function. 

Yes, that's how the existing code is.

        struct arm_smmu_cmdq_ent cmd;

        cmd.opcode = CMDQ_OP_CFGI_ALL;
        arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);

                cmd.opcode = CMDQ_OP_TLBI_EL2_ALL;
                arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);

        cmd.opcode = CMDQ_OP_TLBI_NSNH_ALL;
        arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);

> Since arm_smmu_cmdq_build_cmd reads other fields
> of ent to build the cmd, we are potentially sending stack garbage in ent

Ah, it is tricky, it doesn't:

static int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
{
        memset(cmd, 0, 1 << CMDQ_ENT_SZ_SHIFT);
        cmd[0] |= FIELD_PREP(CMDQ_0_OP, ent->opcode);

        switch (ent->opcode) {
        case CMDQ_OP_TLBI_EL2_ALL:
        case CMDQ_OP_TLBI_NSNH_ALL:
                break;
[..]
        case CMDQ_OP_CFGI_ALL:
                /* Cover the entire SID range */
                cmd[1] |= FIELD_PREP(CMDQ_CFGI_1_RANGE, 31);
                break;

Only opcode is used, so it's "fine"

Later patches remove ent and this trickyness so let's just leave it:

	/* Invalidate any cached configuration */
	arm_smmu_cmdq_issue_cmd_with_sync(smmu, arm_smmu_make_cmd_cfgi_all());

	/* Invalidate any stale TLB entries */
	if (smmu->features & ARM_SMMU_FEAT_HYP) {
		arm_smmu_cmdq_issue_cmd_with_sync(
			smmu, arm_smmu_make_cmd_op(CMDQ_OP_TLBI_EL2_ALL));
	}

	arm_smmu_cmdq_issue_cmd_with_sync(
		smmu, arm_smmu_make_cmd_op(CMDQ_OP_TLBI_NSNH_ALL));

Jason

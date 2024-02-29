Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2083.outbound.protection.outlook.com [40.107.95.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378083D0BE;
	Thu, 29 Feb 2024 14:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709215666; cv=fail; b=lzOG7vqiZzYa8uSte3gattpNJtfpE965bLE1TDpFoJcYz5iSWQhYAB34KoWcvn5vtwCyrpEgagh2x51jBtVudKXCJxbuTE13aAcsj6t2d9rGkD+aFY1kXmVoGhFPxPOBh3XC8LpDwGWF2njAq99DcjzjGXOv0xxaiUpo4fyxCcs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709215666; c=relaxed/simple;
	bh=yzGwpSAuT0bJPCuh955vGBjNskN6tmbf/i/PBSp2MbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dEcjA+9O86qkpfk52W0VT3FIKAsqiwkVxCRS5M9DLPntzm0/VSt5Xhnu7knnPoNGCG9U6uNgNjfUzf86GeCR6FFLcT2lcHkt8Q5yF2fewkrGZu5+oWmCITCZR1ZPSVP4QCSxHbfxx2/jEVGCuIdJ65yA1MvfPzzV8dET/l9A+70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZttePFvO; arc=fail smtp.client-ip=40.107.95.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZttePFvO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFubeF5i3TbRF+dXhvWceK0NytgJDWZ5gZZhVtb2+1/BAIgdRXSxHrRfJXo1cbfb0PJEnfDkHKbpEJXfMv4QFTH30m1hYnWab+fCQklciWD2ehbCikGo56L2e2ZDWrbNVEMm75PfGLGuyOvoYoWs/w8RwUmXhqZzU/H3Y6FZF3yRhndU/g/n6m40N4oSarbB2eHqKOij70G6KNL6hmIAm1La7lCCWDDYgrZ7uy+kd/J8Qgt1H/TWJNEyASalgvvuhtF0Qlr4/j2Fg+LjVY0WPwCGGmCID0Ac70uCeSy8/oISwhmEQUCSlEnTwrVKFtrKYQqcAK5Wpwll2DcGIy8XQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bw0biKC9a3QQkPlpm4fM1lniZ1WryufucnKDVEVaCJk=;
 b=V1z6fbh0wxDkoDv+0Knk6/mKsRUotN0/AvFLqrsI3l3jClEf6AspuqiEBPzN7M3v1JicqyRgbtLT6uY9/sv2gdJxaoyu6/QwoNkgAsRZ0E4BE8QVYLAiDHNa8yrTiBz5ushl2Rno9S8/y9fmNY1w7fLqcsOOM+HmMCDxsMYXcHRzC6Th7e+gFBin3T1+ri/w1YaJLYyyP9eJWGHJxXZM9iU/SS8ND8kLUgf5w+OSp8YovRRDvE81dV3yaDgBIkfcEao6gzmB7cccyZWFiwIX32dCJs2fCxgI6tCgpipEImoFHasEATSgZsFNWcocXsm/kskvJvza7IxamGRdJZLPyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bw0biKC9a3QQkPlpm4fM1lniZ1WryufucnKDVEVaCJk=;
 b=ZttePFvOvX3ylBR6u4GPwFd/3KuPk8vw8AO2ToPy+mXKwaqpLnikpablRyqR/B2BRgLtYgugrHol00F/Cdu/OIwgP5bOMr+FWxUI1UDH6fNd1w84mkdlU+5XJrLxhtGQFIOOGd4eCtLz9CLA3ud6nQkWWIrnk8bckOjPqPx9+2I5+BQavMg/Rq17UbavrddOWPAjccAgXDCVpBxk64iX1DjEboY10NpkZHJhiIhCLiAEzVFqPnY0pQm52gzHE9e7wU6B5hiAssXkPF/PMrCuE8zpv5CzGizjacgieIokJg0omk/le8EjGamZcLazIhQTdMYCr7ojVawGZle0l4BkSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB8056.namprd12.prod.outlook.com (2603:10b6:510:269::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Thu, 29 Feb
 2024 14:07:42 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.037; Thu, 29 Feb 2024
 14:07:41 +0000
Date: Thu, 29 Feb 2024 10:07:40 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v6 01/16] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
Message-ID: <20240229140740.GE9179@nvidia.com>
References: <0-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
 <1-v6-96275f25c39d+2d4-smmuv3_newapi_p1_jgg@nvidia.com>
 <20240227124713.GB14089@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227124713.GB14089@willie-the-truck>
X-ClientProxiedBy: MN2PR20CA0051.namprd20.prod.outlook.com
 (2603:10b6:208:235::20) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB8056:EE_
X-MS-Office365-Filtering-Correlation-Id: f4488b82-47c6-4a27-00ee-08dc392fcb36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	az88qId12+6U0IFaVn3ba6O/KrRB3S7IMzuZQiBpHjS7dFh7qP/Pc/u4IgfboH5CMl/A9f3KTMkXEO9yAJFxfDO1o9OHAK07JFK2kWUPNxq2P+mNeszRiouvPCmqMc17pRboJnYpYFrYeKgrMqYZNH+OZQt6zq/8ZgZ718U2133jFgwg7wsO4T3GxoZ7QDYDT8hvMLCOuBF17Vd4xVToqvsiuwpzcspVNRmhp5g5XZezk23cGFYDmwIR9jIU4Vm3q5sZBhQzO5h35OYQTgl+9gw9f0EWEjvNmeBM0KgAxBaE4b8I9AXXIEMn+QNJRlOuvVeFt4A8ZE7D2X4kxuPsBF3TLFk+Q3zKROjqop//DQ3CLCsTfsqvyrVSG5DIowekTH+MFHqVOVta66J+VfWPfPCI5an/0l/F3Up2Ttoa7hntpvWHJkR5SaVJlyxmSDc281I9zxi2nDBBrHfqSs48yyR6vsaNBfSdn4dOW1AQhKohE9m63eK2cLWTsZ+SibH0fZPWs59DuHO3f83U0na82Z6gXRnaHd8NV/cZtPXl/+ZfKZYRS3MgYAHMq+Xnm9zLx29m/lNZpnDwoz3XqES6oxymTVgcgJd5cTQPvv6nqgzRfek1J/0BlJVsG0/1ob5St4oGT9cuIXykH47HdMEZKg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FCm7njY4qT6tQlzcxFxN9LUOU2vv9f4mj/gLjmImSrJ8O+ig87g4bc9rhFHJ?=
 =?us-ascii?Q?yTY4X+6nCKQUpbxKElhA6PLvA7scQoE4P4+uXpvcZykL0dhE6HcBCWcJpMF+?=
 =?us-ascii?Q?YVsxSvunH8NaxG6LVOdZlAgvrHqcP/2dVQGpozQChxpKGcMOA+anQw1MfH1p?=
 =?us-ascii?Q?578sZ187N4mul1JkzZSOqYAza3wWBqXjpBKco/HBa1PSQEuqvCxTJb9/lCCv?=
 =?us-ascii?Q?5/rN4nbhwRzQX7ic5MrU2+ZuD+esoQdXO4DYMpisO/GpgYq3/XQa1RJ3X2ta?=
 =?us-ascii?Q?ZZfEX7uAEDicZIxWJClqg5g//mMuMH+4LPDgtl1KFsef7q42R+pg2VV6hcim?=
 =?us-ascii?Q?4HuSmRrsdBO97CM2XR87WOyMZWtBPmLfaXBI+FMnmo9n/x3+Jpm6oR2c/6Ff?=
 =?us-ascii?Q?/o34cJuaG1FMLrG1+CCQAujexYRjyCCRcT/nfsc9bPhd3aXI4FWrDSpLm7lU?=
 =?us-ascii?Q?wKjOZnSjELM7+Ut23Eq0Hoxyby4Nv+bBFy5cYqbmTx23C00D4UJTheAGb3Zw?=
 =?us-ascii?Q?NWAzKeai9JzGeq9mXTe3n7UIm+vYHcfyXF4TMiy2VcPvYHtkfoYwIoCr0h/e?=
 =?us-ascii?Q?ZKkk1nsg98yGi31bcnJEZagZy1N00paFrY3ixmfF6XcdEzk7ywKrCV9hjzyS?=
 =?us-ascii?Q?wtqtNDtVtg6BCCawFCa9VQCQ8OcbjDn/FIwC3/YepCkKhV4HLSdTGtYFhhfR?=
 =?us-ascii?Q?dFu1zJ+uZn5fTI3hZeggOKkzs/ErZeKTjWaR7mG1y61Yp3C8ZcYxXc7X2Lon?=
 =?us-ascii?Q?Sw45RAWA4JmE+Ri4P/VMGTqjroZMRyEovA0ffbWV4pkM1sZGYn57jsy0SHhm?=
 =?us-ascii?Q?J8y9b7cIz8yp7sLt9qgfhhpsk2iuzkRLZcwj3RTqCULyrkXOIsTzQY7JvZsN?=
 =?us-ascii?Q?YVPTkUBeYZuh4zLFc16DRBrsSVwgkANT3F1Yi3gCz6QbL5actdn2+MPBGi5Y?=
 =?us-ascii?Q?65F9R8eXFFH2FdZon9qCsH9wDfUqylSle/nfEeX9RbBfZA7EPq6kIIFQ/SBB?=
 =?us-ascii?Q?Wyoe/xfdHTq6IiRz6VbU9nCfjEt27JJyFWebOIUETsEIVtw9XWUbCrhS8AkA?=
 =?us-ascii?Q?8fcIb5k69EVXiX7cRDDUaL3jd8q6wOeuzPE3LUFO2BwOQRxadKx57YDRSXyV?=
 =?us-ascii?Q?slj0lMN1ifpWfiJL4LiXJXmzaXCOFQ3sjwcKPoZaFm7MNDc3+Utoisx/wudq?=
 =?us-ascii?Q?I9D+rrvzDCvHT85e9YNoSwhYq97UbBHE8VT1PqJLlGuCKQqipNMjoY/7HhKd?=
 =?us-ascii?Q?uhVfRYXMpkH+TQite0Xkev0W9xdukqq6XmTmU1vYcbctVvStD+3RXvt9KbbF?=
 =?us-ascii?Q?U+6yqmdcSDoZ5W4z7sYP4ztHKDBANILXa5mr1/bFXyTVj9ZYa3UmG/UlSFG4?=
 =?us-ascii?Q?nJK6IocxebIj90g2LhHAELatFHrTtq+C8O5HEELj/EiH7U/qoK0Qo7zIzmqp?=
 =?us-ascii?Q?YBXojSrbeMxnYfQWtzTFfZ6erKKHjoykgmYZ32XlJxGDLuRt+JtzYiuJxmRz?=
 =?us-ascii?Q?ztHUhsC/vNH0Oa2GJQi/6qVtu63D9Rq8i27AfV6/+yP+tIobcdPo68J8wsh9?=
 =?us-ascii?Q?RMfOx27b/sAhEMrED9dQGfiOYnVWuNzbIQsYG+GS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4488b82-47c6-4a27-00ee-08dc392fcb36
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 14:07:41.7170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bR1v9/EMdm52ec/3cIcmc5yG9NHjx20yPQ6I3rCOY++cd0c7oaVbK8K8sqaFM1/8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8056

On Tue, Feb 27, 2024 at 12:47:13PM +0000, Will Deacon wrote:
> On Mon, Feb 26, 2024 at 01:07:12PM -0400, Jason Gunthorpe wrote:
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index 0ffb1cf17e0b2e..9805d989dafd79 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -48,6 +48,9 @@ enum arm_smmu_msi_index {
> >  	ARM_SMMU_MAX_MSIS,
> >  };
> >  
> > +static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu,
> > +				      ioasid_t sid);
> > +
> >  static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
> >  	[EVTQ_MSI_INDEX] = {
> >  		ARM_SMMU_EVTQ_IRQ_CFG0,
> > @@ -971,6 +974,199 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
> >  	arm_smmu_cmdq_issue_cmd_with_sync(smmu, &cmd);
> >  }
> >  
> > +/*
> > + * Based on the value of ent report which bits of the STE the HW will access. It
> > + * would be nice if this was complete according to the spec, but minimally it
> > + * has to capture the bits this driver uses.
> > + */
> > +static void arm_smmu_get_ste_used(const struct arm_smmu_ste *ent,
> > +				  struct arm_smmu_ste *used_bits)
> > +{
> > +	unsigned int cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent->data[0]));
> > +
> > +	used_bits->data[0] = cpu_to_le64(STRTAB_STE_0_V);
> > +	if (!(ent->data[0] & cpu_to_le64(STRTAB_STE_0_V)))
> > +		return;
> > +
> > +	used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
> > +
> > +	/* S1 translates */
> > +	if (cfg & BIT(0)) {
> > +		used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
> > +						  STRTAB_STE_0_S1CTXPTR_MASK |
> > +						  STRTAB_STE_0_S1CDMAX);
> > +		used_bits->data[1] |=
> > +			cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |
> > +				    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |
> > +				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW |
> > +				    STRTAB_STE_1_EATS);
> > +		used_bits->data[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
> > +	}
> > +
> > +	/* S2 translates */
> > +	if (cfg & BIT(1)) {
> > +		used_bits->data[1] |=
> > +			cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_SHCFG);
> > +		used_bits->data[2] |=
> > +			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
> > +				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
> > +				    STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2R);
> > +		used_bits->data[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
> > +	}
> > +
> > +	if (cfg == STRTAB_STE_0_CFG_BYPASS)
> > +		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
> > +}
> 
> I think this looks much nicer now that we've ironed out SHCFG, but I don't
> understand why you've dropped it from the used_bits array for the
> S1DSS=BYPASS case. It's still needed there, right?

Ultimately yes, however at this moment S1DSS is not used by the
driver, so it is not needed in this patch.

Previously I included it under the idea of making this logic complete
from the start, but due to the other requests to move stuff closer to
when it is first needed I shifted the S1DSS check into the patch in
part 2 that actually adds it to the driver.

It looks like this:

		used_bits[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);

		/*
		 * See 13.5 Summary of attribute/permission configuration fields
		 * for the SHCFG behavior.
		 */
		if (FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
		    STRTAB_STE_1_S1DSS_BYPASS)
			used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);

Let me know which way you prefer.

Jason

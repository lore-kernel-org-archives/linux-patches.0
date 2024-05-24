Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD21D38394;
	Fri, 24 May 2024 15:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716565599; cv=fail; b=kVSeV468PThAmuAIuH5JCyxueLmfUtrjrPbbJGISv5yyXWVVo6I+vTay/4D6fAMIJVHVHqCmZteGQVqc+D+Qj+hqhbf0bTCSdKgMWcR4k3w6Ukb2Pc5c7sUJPdd1zRRHPsoZM6hw4A2/Tlb5lUzkdXmlWZYL380pPW5puTTOclk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716565599; c=relaxed/simple;
	bh=0IPB0AFE4Tbtqyrfu2i65/4vHsYShY9yeeHmIYcPS7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oS1+AIgTFJmbibklLAXgL6dS1c20Wc8hWNjaVe/f4P8ftHLrbxhBNUdYXdPMLtpGJND60fR3GMyeEejxnSO81nuNnqlZOxd8JLlBM4qkqJ64cW2UcUJMrmJWZmOa8/kNhDf3g96VqugHKyh/gz+WnZHpDQY/vxgPHglfj+VLHbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ftysywXN; arc=fail smtp.client-ip=40.107.93.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ftysywXN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iBLHR7mZIsbBl0GvJ1WorNaNmiYH7AMJTLt7zyD09nBdofV8rSihNM/k0btlllSbgNOrrrHSh+tAWj/07CIBqu8OR2w+jP/4LE+zcTJuSUll0K8bbIOIWhmt+VoyUwNTSdtDullYL7R5sj1P3EOV/7lhXjMnLD5lnhNKFotxSqorzfpcSZY2hWXJeI+gFljZL5RYKrA/DxOcFsqX3zDUc+5Qw2T3GXk74wqY+PKjKqUuJiX9I0dLwthnXbHzdUhQjfK4HX38SmmOX+bWpCfpBwn4mbpKCc55x7Kq7uOgXPEsBRWAgAqje5/ZS7MUucGgQ3njskTKLaKhvqM8zTMEuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qKNbBygbzbHD9tAQi3EquAm3hCXEaYZSp52dOBkLye4=;
 b=XadGvhFLnSZi2pKXWPT4MTZ6l/cAdAzoliQKVNzyYw7JtvWn5lrTVgR6Tme19q6yOOy5EKJdelKRyw/RfZ2gkLbzwIF4qGDJ3I+T0eGjgNcOwmC4b81d3FmluYvB+TAErLy7MEsL27oG+11MfIyOXcTtIHiRY23olsjqiZT0EzhXY0ZicqBVy9U/2xLzn+UIOdhAYRfCKbRC2KphOoYnGi6AtNGf4IiRLsymIn962uvZhqjciezDqKtrZjCws+ER+ZWhcpzaubh8UFMNNPViG1pUlTtDtuBSGeXsMho0MSXu2EWhRrQwmtMlWpQG3PqcXGg2FulZiqRpWdFHffr5cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qKNbBygbzbHD9tAQi3EquAm3hCXEaYZSp52dOBkLye4=;
 b=ftysywXNMAdvW6/fzz+C208AfFET/eBZvyCqy9IdFyy4uSxtwHRMpLg3j9n6ne3GR1InSjxzpdJeFkAlfHcATFj1beo6j0vMJRo/0jeGyK9aARETygaK4ENtoyBincSsI94H3yX6l2Zv4hwHIGjQQ2ITFLFvRw8o7D5X9XtQjwRMnoGoHXSYrOhq+GGUpKJr+QHOErehX8wG35+cEaEuOcae8CT/uNfHbJJ7QaZvs27JVZOH45klDWPOQbu+O0rbDfmw8ddJZBG7lYokPvlZT7EnZwTp/XZPn7SDgUks4RiOHfrEOKDD1jzg4r6hj/5t0ONRZNSNaJxzV9/mCsrJFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS7PR12MB6285.namprd12.prod.outlook.com (2603:10b6:8:96::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.36; Fri, 24 May 2024 15:46:34 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7611.016; Fri, 24 May 2024
 15:46:34 +0000
Date: Fri, 24 May 2024 12:46:32 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 04/14] iommu/arm-smmu-v3: Make changing domains be
 hitless for ATS
Message-ID: <20240524154632.GD133219@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <4-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <Zj/pmRvkKYrT/h3L@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zj/pmRvkKYrT/h3L@nvidia.com>
X-ClientProxiedBy: YT1P288CA0015.CANP288.PROD.OUTLOOK.COM (2603:10b6:b01::28)
 To DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS7PR12MB6285:EE_
X-MS-Office365-Filtering-Correlation-Id: cc916b0e-4f68-443c-92b5-08dc7c08b069
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|376005|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?o2iZ+QLH+b3D1ijcys+1f4S3hbzTZeOngLGouyyjIzo3NkzMWhldiSCVx9E8?=
 =?us-ascii?Q?+eCsCcPuJDefRkJDowelHngfV57ks7Zu0AEtEWvAAU251WQamm1luH/RhknY?=
 =?us-ascii?Q?3mCeuhg3VmJK8JCdpTN2jMUwzZ+HNLbukNmDbz+xp9t/inl/Oe4Imp89j0mD?=
 =?us-ascii?Q?B+tMwmhzAHmDbcpvkNRX2H2hL9/B12wgSL41DxAm94ox6tx8ZeJ+hi9sm2rt?=
 =?us-ascii?Q?JqKvjOczluZKCGfntK8N5R2cJBKCHmrdmbd/3UqBBDmss3RbSqs9aATV1V3J?=
 =?us-ascii?Q?/rMUll426/1RN3ACCJPGZT0iYxfU1y05hzgb+sUstVjspKV7FC2nsYZ5k4i+?=
 =?us-ascii?Q?eQ/fnKVB9ddmm9UZzhNUCi3L7f3YICaTdd77reev4QYkZitFVrKhhyWXISGU?=
 =?us-ascii?Q?hPTNY+WC/XYQstO2lErCg4DKyLdqapSMZ12zH0nHzOmtFfWT864vzD5mwuny?=
 =?us-ascii?Q?QX4x3VZJ7VyzjR2JZmWu4pO7V+sNzmNXDYHjCxFk+ZQObBEIFM7pqWLLe2Vg?=
 =?us-ascii?Q?CNAxnN0mLvBbBwINKSC+x8G4VR2S9zH86uqHZ1s1NVx3QPc9tmfYaxxwGaSG?=
 =?us-ascii?Q?rXJsiKYioluk6oHUt3PQ9s1LWgFsWV3Txo0pHHK7oEoWqKSsyIb3ai1dVift?=
 =?us-ascii?Q?P1kaDQe0frxP6godYSvSA7hwa1eLEbvvic56QhHTa6+09yIZfWgYWLjOxgSW?=
 =?us-ascii?Q?Yz3GylSNRWeIfRDdD9AMy/aTqSTmFTA5vD+8yrEPCfxmF1Qi//+n2bjA1Gi0?=
 =?us-ascii?Q?yH4EnXGJ4v95O/s6zwLn13lJNa0vB63PTzDLZ5QlfRZcNDlljFmKO369OVfQ?=
 =?us-ascii?Q?aMROa9y53ax9QRjXgoC5ue1KOwNmqRJkWAeiyHmN2m5l+RJe06stkFE6pIN1?=
 =?us-ascii?Q?6QtT/E/Wi3d7jsKuHniWKm9KR0KI3/LGqy+K9IWIpaLu0eZKXRoQcCcFPEGg?=
 =?us-ascii?Q?xCW9Ig/upsyvC6CSLUzokWRqDVJb/ci1z4OiH3O+ZgZVh8vh0Lgq1PFTnuBj?=
 =?us-ascii?Q?NRqB+OXv3WdO4OGwi+OUzclqdlVsFmBlsvBTxRs+TVehHohKzq8VHOxwQYaa?=
 =?us-ascii?Q?MDe3kW1lcR0L03U5slxwCJrq5fwWNmQX7T7prFYyjb+0h/A2BJ4D0NpNvbp8?=
 =?us-ascii?Q?vowD2fEO+hmCWPiJYBBB/Beb54ncydGMATr4reyuYJ/ZMikCFqfL1kXmUFWv?=
 =?us-ascii?Q?92SZOIPCVPv3xoFbTrduSEyMNImOj5Mkfl9ZkHrbKDC5XHk60flwTDlmDmJA?=
 =?us-ascii?Q?gBMXjr69QLDCArthR8W7fVtf+rSzLneOAFbrGIZZeg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rAh/TskZ2wJeKByNQ3NfO1KkZ0aQoQ70Ve/nRTVwqQhDjHOKJp4NIjDaN0Yd?=
 =?us-ascii?Q?6F6d42rhYEJVv8NDJkXyis/OYnrvt0RpI8TGQ7jqKvQ1eg1PK1meqsEKy5Zl?=
 =?us-ascii?Q?bjnso5VT1afrSAjHmUKyQ/yVAhpQLFdAX9F9dhDbee6Dwaeh0Jvt6Oe2MyFg?=
 =?us-ascii?Q?He2REEfZeVZ+MbVOL8JhpXK9MI3PdKvl/Uk6YVIrLsPe6peH2rV8+fTO05On?=
 =?us-ascii?Q?S0ulBe7DTNq01IKTkYzmd8FDvCTL9DTRxA84FwFDe75Ha2kSDpE0qEVCTmAP?=
 =?us-ascii?Q?K2zKFzfWb1ydOWEaQE385sPZYHR9JI1zJbsdBCjSaqmFKihNoJjPS0+PcAvK?=
 =?us-ascii?Q?VUhc9EU/cH9yQ4xA2o1ZGX9nbAsA8Pj56cf+boRPBV/bIE5qeE9BkOm4tsi2?=
 =?us-ascii?Q?yb+trXmtxi6bree7IwlP4MG+0U3eeNMmTB2NVdvcvb5syr+a6udxyUASe7bE?=
 =?us-ascii?Q?e2Onz2EvJ0mnf1WoGTQhdiKuvsGgy6d6bmIP3zfnyyU303W2oGYrAay0MDYJ?=
 =?us-ascii?Q?LVUEubrJPsw6Ybn3F5uKgRQ3JIkhIz7yyi/WBih+RJJIyFAj3DKcQpLR9cQf?=
 =?us-ascii?Q?mZwsxbUMgQCAYCkmOxMab8Swo9mHRtIx9htu4/ogHICzbKOu8OtqV0bcBXlA?=
 =?us-ascii?Q?sQ0QHiO4rnqCg5Dhuxe7ZrH8t6lnf9xz8U3mPPdLlrJxWei7I3imiFDLpQbE?=
 =?us-ascii?Q?kIMBqWCYwaR06iezbMvB5BPdZN6I5yeI4xUP7VrClqjPmUHoKp5TKsuDG4/6?=
 =?us-ascii?Q?GxvyDmSEJMiLUI07dNKp+0176jRSnveiU/6+cGI00M9sL1d5KKny7Wupt1X6?=
 =?us-ascii?Q?vQE3Uz7YeTdMK6mrSXvyzp7R6LtKZpgR41zkbOa1b+5L4XqPAiQOCnLeg88c?=
 =?us-ascii?Q?qYE57gyn8X7bc5Vrq6ULRmxtLZpP1cD63qludjf0NiSzEDEvHKLolxRIBTOG?=
 =?us-ascii?Q?XjIqlWKs1b1ywHxvyQ59OE69FugISWkTCA0NoUZ7DkndhebMK+jUxKTsC7RQ?=
 =?us-ascii?Q?tyYfNMEymlyu+qdQhhPBQFlCtALgjqFVGPOjQZ6X84XDz33lXGn79QGjyIF9?=
 =?us-ascii?Q?Uk/iHLp2x9gm46eOgwSWeEplZJC4g35syrHITg6HMueoaLuPzBcf4fcKm3y4?=
 =?us-ascii?Q?d5jFRpyiJbxRfDFAy+1Va1/mq/EyqM16zc4wzSyo7Pscbee5NiG7Z9iv+YAR?=
 =?us-ascii?Q?YVAU6NTNNVLdsJL25h3wr1VvP/++NIXY5FCk6skKVE3NkDk7BtSOU1d4xOsp?=
 =?us-ascii?Q?UFqhMS6bbWUsuzkpSRCp2TBSNawlBlA1frFKgtuDE3wj+kYHwWX7zND8yULs?=
 =?us-ascii?Q?q4iQL69bg9GqE7a3rHt2sEGYL7FVqZRhN5uUrcfeYb6IpEpj+ydRaFgfkvv5?=
 =?us-ascii?Q?It/FZD7rOlNGOWbg72/mlEQcFRMIgNW+yVyS985t5lT4gfnDd2gv/bdWWZep?=
 =?us-ascii?Q?/mfvMIbhRxg24t08teCi5UczI9THEDWQUvG/V8GrGCqZHFFH2sjkxaXW8rrA?=
 =?us-ascii?Q?PBZQNzw88k0dGwE2sNfrYGIGUvdLMJ9UIQJf6nUqC8TF5z5r5gkFSP1Uy1dC?=
 =?us-ascii?Q?IA59gzxDl3KiNXOCwltpagJHJvd4jshe2LFDR1f5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc916b0e-4f68-443c-92b5-08dc7c08b069
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2024 15:46:34.2326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jn4tVzM2EdUGMfG3+5LtfslofW5WX9StgkVBm8SaUpKv7FcsmzfpDE6+G1yWLPvX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6285

On Sat, May 11, 2024 at 02:56:41PM -0700, Nicolin Chen wrote:
> >  static void arm_smmu_v3_write_ste_test_s2_to_abort(struct kunit *test)
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index 532fe17f28bfe5..01e970f6ee4363 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> 
> > -static void arm_smmu_disable_ats(struct arm_smmu_master *master,
> > -				 struct arm_smmu_domain *smmu_domain)
> > -{
> > -	if (!master->ats_enabled)
> > -		return;
> > -
> > -	pci_disable_ats(to_pci_dev(master->dev));
> > -	/*
> > -	 * Ensure ATS is disabled at the endpoint before we issue the
> > -	 * ATC invalidation via the SMMU.
> > -	 */
> > -	wmb();
> > -	arm_smmu_atc_inv_master(master);
> > -	atomic_dec(&smmu_domain->nr_ats_masters);
> > -}
> > -
> 
> Maybe we could keep the function for symmetry, since prepare()
> still calls pci_disable_ats() + wmb()?

I removed it mainly because it is not symmetrical. On the disable
side the work enable does is split up between prepare and commit.

> > +/*
> > + * Prepare to attach a domain to a master. If disable_ats is not set this will
> > + * turn on ATS if supported. smmu_domain can be NULL if the domain being
> 
> This function doesn't turn on ATS actually, but commit() does.

Lets write a nicer comment:

/*
 * Start the sequence to attach a domain to a master. The sequence contains three
 * steps:
 *  arm_smmu_attach_prepare()
 *  arm_smmu_install_ste_for_dev()
 *  arm_smmu_attach_commit()
 *
 * If prepare succeeds then the sequence must be completed. The STE installed
 * must set the STE.EATS field according to state.ats_enabled.
 *
 * ATS is automatically enabled if the underlying device supports it.
 * disable_ats can inhibit this to support STEs like bypass that don't allow
 * ATS.
 *
 * The change of the EATS in the STE and the PCI ATS config space is managed by
 * this sequence to be in the right order such that if PCI ATS is enabled then
 * STE.ETAS is enabled.
 *
 * new_domain can be NULL if the domain being attached does not have a page
 * table and does not require invalidation tracking, and does not support ATS.
 */

> Should it be more accurate "If disable_ats is set this will turn
> off ATS if enabled"?

After looking a bit I removed disable_ats. We can now tell that ATS is
not possible because smmu_domain = NULL.

> > + * attached does not have a page table and does not require invalidation
> > + * tracking.
> > + */
> > +static int arm_smmu_attach_prepare(struct arm_smmu_master *master,
> > +				   struct iommu_domain *domain,
> > +				   struct attach_state *state)
> > +{
> > +	struct arm_smmu_domain *smmu_domain =
> > +		to_smmu_domain_devices(domain);
> 
> This could fit into a single line.

Done

> > -static int arm_smmu_attach_dev_ste(struct device *dev,
> > -				   struct arm_smmu_ste *ste)
> > +static int arm_smmu_attach_dev_ste(struct iommu_domain *domain,
> > +				   struct device *dev, struct arm_smmu_ste *ste)
> 
> How about arm_smmu_domain_attach_dev_ste?

It is reflecting the ops name 'iommu_domain_ops attach_dev'

> >  void arm_smmu_make_cdtable_ste(struct arm_smmu_ste *target,
> > -			       struct arm_smmu_master *master);
> > +			       struct arm_smmu_master *master,
> > +			       bool ats_enabled);
> >  void arm_smmu_make_s2_domain_ste(struct arm_smmu_ste *target,
> >  				 struct arm_smmu_master *master,
> > -				 struct arm_smmu_domain *smmu_domain);
> > +				 struct arm_smmu_domain *smmu_domain,
> > +				 bool ats_enabled);
> 
> We seem to pass state.want_ats all the time. So maybe just name
> it "bool want_ats", given that "ats_enabled" is only true after
> commit() that always comes after these two functions?

Lets rename want_ats to ats_enabled to have a consistent name.

Jason

Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2053.outbound.protection.outlook.com [40.107.236.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7041128811;
	Wed, 17 Apr 2024 13:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713359854; cv=fail; b=tG7oRAxPnG4vtJ30kE1TjRX/BARcY+BSNDed6ExD4nHNxWRAfpYUgQSwQMMjfJy5tIH/V09uX490Ojd/V0UAcTZQoJrSvXDmOQTwAgdii57qa66vdQfCYThMjOrIpkDWoqS0Rm83ncy4AyVU6rkjA8pi3XREwDWquZIEX8gu2+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713359854; c=relaxed/simple;
	bh=GL5WxNyaLvTeqsssRuusLe1vMr/fQS7xX1iJW78zp4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZckXa3BTU4YtN8Zsprr4aGUOpi9N1HaMOtEiucEXd2HF5GaMu8vUDA4s1zg8JIgDRs+n+rGS7rfU2U8habP6ig2ovShe1lRrE5lsKykpqJ/3pmxhxFWbP0fYtD/kdugdRdiAgoWZLfbrAi8janfl6WDlzWugyZv1ePgueYTHmMQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RJ/RDEVw; arc=fail smtp.client-ip=40.107.236.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RJ/RDEVw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUs6cd+jn05DIe3LCk4yIhAvJmvaQx/2oMNATjU0ZruD7I/aSvJjPjJHrnUbAeebHEhj2rMEyAFZhARM3B0GkATZh7ZW4CEWcmUm85IIiP1l6Z1TFgJ4RyXrc/CEI3aG2jOBEe+vu1EQzL7Hed1I0WWR5fJdDTs0dE3872dKQg5dZvHnsupiiFuDFGxDPO90BdjGSgpmM6tChxh/WvvYcoRGxUANQaxG0e+T5HHeof1LHBl5ROCQ+PFI35uIZi03IJIzBFpzXo/14kE3vmMCC5S7prZB7u52fgwv4lvAqZHbARrw7iclU7NQITMeL6210sF3gMejq7OmQTEVsPeDXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kgw2K9D/DoDRI4MW9L3mnS7Ljd2U4L+WZzSY7lEBWqQ=;
 b=DIqYWNlIRSySwnrmL4ZzAfK6MLiFq15L925oJsH74gqHAbPJkhVCgiNOE2GgRyeWySkM4nPlYt8hSCpun6LoEraF2Q4EF69/BHKVhdYtZP8ectMrAS0BDTgncVQSaqnDmV9rAy8KFtn9E/c7vJgyu3mYYCFFU3Ki2BocFVo6XO4ge+E6bRF5+gmyWZo9UhDSVnkuKxfjfQ+Q8qrTCYs/DGh2KOrhZGiV52mwviBZk/uregiwjAYAPkpgBXOC6xnJDET8DxPzOlClWkiJ7bb7R0UXs+AvUjmoYk0Fbtk7mRYBJp0FXitXigFp6EktRAoY+noJ5tC9NQt8L5hlCTbe7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kgw2K9D/DoDRI4MW9L3mnS7Ljd2U4L+WZzSY7lEBWqQ=;
 b=RJ/RDEVwIZcqrCMnsPkLv9DiYrVvwzezNYv3vmC+WUAIyQpJJ/HQ/U/y+3l/AiWCdoBpYKQtMMP3/HT3VpMKWTHO0Rgvsd2uniuk+ezDQEs2cheDQKvE7VT630/DjaakhiLKJ76uFV27JB5Hz/iwJttK1nyAeT2ZbrjbTCGeuI4nYEoiz6b6hR6i+gZnO4zW1FqkMfN5uwqRKUmNdlIVUk4ny/bSoW/jcKz/iQyLqGd8OZPEBc2FS1B8iVOlKDACO6S5NW2e4R6hw6qF68bbyYotsQA1uk5mzyUAXsHB2TgmhEqj7XmHM4ZT0A2dvcifs2TK46apx0s+cJ/iYvOrww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM3PR12MB9351.namprd12.prod.outlook.com (2603:10b6:8:1ac::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.37; Wed, 17 Apr
 2024 13:17:29 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.037; Wed, 17 Apr 2024
 13:17:28 +0000
Date: Wed, 17 Apr 2024 10:17:27 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v7 7/9] iommu/arm-smmu-v3: Move the CD generation for SVA
 into a function
Message-ID: <20240417131727.GR3637727@nvidia.com>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <7-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zh98L/vNPugu6JbV@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh98L/vNPugu6JbV@Asurada-Nvidia>
X-ClientProxiedBy: DS7PR03CA0076.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::21) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM3PR12MB9351:EE_
X-MS-Office365-Filtering-Correlation-Id: c09ff4e2-de0c-4a99-d785-08dc5ee0bb48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jQvuK3YOXTp4I6jXz5K6Mnyn0KIhy3rTiLhtTfTS9Y8DgA0XsdOQLrAT/ZGJ9sKmOz7KWNRHRHkYCbZPU5EzH/4RyglgGXP8K8mTHuGczBFw5L6flxkTbiVPKIPYjz6NMbGDthgDdCpr308jlAPOq6aaLHoJBxx1oVFEeHOgdkMuOZBsJm2ngZBJg151hcvw166z9GdeazOvwOk/b+VCZ2Xz4zVrtlUtGeTZ42JNjrZ9kIgkybx/lb7mDBI0KlWgG+Z84vrsnNea1yZGOViKDlsLcQHNUgfxpfmsMXMEPfty7KBD3yh/xtrRegGM5To2tA4dWXKDZ0An49zJ/wpzEvBOSUFpRsK6/I1Gym+j0Vl6Aqcs7LYwMtFuXg5+oh39Yw1b2fv3rG4bjK5EcmBhap4K+D7d5RWcUYkpCAV8w7GHACMhWcslzYUpMpvup/JRPS5DAiLCrHgDIOR/mlJDRYpaAgLhlWg2rkD2wlXKIudpodepPSw9BZJteN+S0MqmpnVjWYrKh2k8J2acwqBsP6zeFO7Nv5nVe9UvfpQTAdRBPZ+fYDbc7gHqDAhvHtr6ZWqKvPE8XjKN/4bu/YtHabkkB61d/YnehXko08tHB9OKyGEUja879wsM6GV4KJ/UvLv5LFmsIfSzsb9IeZZpdZDmo1N45hs7Q1/5Jv3svR4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3GvV5khOOci7a8m0M+hJAlA8g2ZRUYCX3iPP7YvZDBUp/UmI9VOyCw4k/R18?=
 =?us-ascii?Q?YhWcQWZlI52/POthJgOIrcljPTmnzlyE1qfU0JM/4q43xO0LE7U0Kbp4tSsM?=
 =?us-ascii?Q?TDZG1UENMbHTarvCyFHLXcUijzX2IUF1ZhU/cicY8LDzL9lGcYdFygne4YwY?=
 =?us-ascii?Q?Yu+y8YfcramBNVauOb09NYJLtTTp/bXCGyzP8pYigUMakBurSHWnSWB+NFyO?=
 =?us-ascii?Q?LvGYK3pu+NLaSXrM02h3tX2+kihtV/xk/8D5cNAnvMzjvVF7a/E5J2/X7xaD?=
 =?us-ascii?Q?U7MGN/on+Phgv+nCmy9q4rez27+d/GcWtnXcrZoBWmO+V6WVdLk3xQus63ye?=
 =?us-ascii?Q?lmTBomTGw1+e5gLscgla42IkSRgR+YVpIoJaZsgd3oQxRhIQ8vQHE6vWZrfa?=
 =?us-ascii?Q?yYI0eD1WV+hUi2Ma5DesHnHwlwTxMn3jcPEx9lFc137vbEvQhONo2lBZkfOo?=
 =?us-ascii?Q?xZvltgDqFSqTO9q8DXz+1li6M1R33zaJdyGWgq39ITlFNdYbyneU3u2J7jZJ?=
 =?us-ascii?Q?LGs69/7EL7GfnMmI1RrD33lmP8uTBQQWLtPV/V8/O5ILn7ABkf/2mca8twFK?=
 =?us-ascii?Q?mlmfm6djA5OmizEf0Sp28uh0eq5VMgLKtL/QzkSq9YQkYzO+i8Iy31vt+ojB?=
 =?us-ascii?Q?92+sjtKNSU6yz8DOBYf06qjVU1NrZT08hNE1siFik+aJ+VivRwvzfSz0O99o?=
 =?us-ascii?Q?pp4LHX2qK2qmnbegxBXAOKlSGp8Pdimw6N6wz4Lc0XjkYcTeXQWuI0vnEjnb?=
 =?us-ascii?Q?AGCMmrQJ37MKVJuvcufZ0ehYOfLA1bZFoqtRRUgNeFkKTzLZvxd30knCtJ2z?=
 =?us-ascii?Q?epeczapGZj1bCGyoJ5AHJrADITyi1F9cuw26UlXnFSHiKlPqa3xSpAfIyK2F?=
 =?us-ascii?Q?SEOBTO6ZGWbn2XCIM1DcFCw2gTILbypJCWpMu+zlCMYr0f2RmT/1s9qspyAZ?=
 =?us-ascii?Q?poCIT8umStKSmT0P2SoqRku5ji5UehXpyGPoKOLVI+c5lcO7u8hB83GnM2Ex?=
 =?us-ascii?Q?HM5NlBrmIkryncPq9UO2Y4iCsOzljk7gXY8oRnkrrRheqWccv5tcDXJxab4b?=
 =?us-ascii?Q?yTlibYhjgPj/fZEqHZ7CpO/7KYXRLErszdg419zuVgKFrcLPet+1Mnb+e4UF?=
 =?us-ascii?Q?4PCL1gAdgwps90zuLWrLSZc7eS9Ilmhbj8+n4eK0oc+gDYTlyDPuqOHDe7RX?=
 =?us-ascii?Q?MVjkqLyjSoVz/0IKHF00Rk7Rl3J+R8/LS4I0DfrZbRYB8AqgZV4PDwYjpj2X?=
 =?us-ascii?Q?aQZs8EMc5hNaCISsOVXBz5fJCp5COkc9uAwUU1baW8SyT/UjD257gtzYM/U1?=
 =?us-ascii?Q?flBsyG2dlgDwtzqUUs8WLPXMv0TPh7b9cWubsVSXvOZZ2lQ3oz8GqRCRu5rG?=
 =?us-ascii?Q?H2PVcRMVsEoD9OCE6Vhu3vb0nJz3MDPmD8mx8mFzbEoK79wdRmJFyXPds0f0?=
 =?us-ascii?Q?xYrSxZm8iOUG5DuPmamOA85OuvP2ZLxOP+5a+a1Nj7nNPwN8IfZ4+01XSVe5?=
 =?us-ascii?Q?+Z3vfqcRirqgvaED3KNj6yQlyRBbIh7rzGEmwxnpavmyz7kd+c965cZwddr/?=
 =?us-ascii?Q?vt6aJ6EYb/lPev7TFqWkE2Tmx/7tn4dwtlJzriJB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c09ff4e2-de0c-4a99-d785-08dc5ee0bb48
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 13:17:28.8917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OOF8xVCwkb8cy7lRV9111rmqf+9VzeYLv/9AzEshx2i/lXJFesI1lajUl8UMJdnf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9351

On Wed, Apr 17, 2024 at 12:37:19AM -0700, Nicolin Chen wrote:
> On Tue, Apr 16, 2024 at 04:28:18PM -0300, Jason Gunthorpe wrote:
> > Pull all the calculations for building the CD table entry for a mmu_struct
> > into arm_smmu_make_sva_cd().
> > 
> > Call it in the two places installing the SVA CD table entry.
> > 
> > Open code the last caller of arm_smmu_update_ctx_desc_devices() and remove
> > the function.
> > 
> > Remove arm_smmu_write_ctx_desc() since all callers are gone. Add the
> > locking assertions to arm_smmu_alloc_cd_ptr() since
> > arm_smmu_update_ctx_desc_devices() was the last problematic caller.
> > 
> > Remove quiet_cd since all users are gone, arm_smmu_make_sva_cd() creates
> > the same value.
> > 
> > The behavior of quiet_cd changes slightly, the old implementation edited
> > the CD in place to set CTXDESC_CD_0_TCR_EPD0 assuming it was a SVA CD
> > entry. This version generates a full CD entry with a 0 TTB0 and relies on
> > arm_smmu_write_cd_entry() to install it hitlessly.
> > 
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> > +static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
> > +				 struct arm_smmu_master *master,
> > +				 struct mm_struct *mm, u16 asid)
> > +{
> > +	u64 par;
> > +
> > +	memset(target, 0, sizeof(*target));
> > +
> > +	par = cpuid_feature_extract_unsigned_field(
> > +		read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1),
> > +		ID_AA64MMFR0_EL1_PARANGE_SHIFT);
> > +
> > +	target->data[0] = cpu_to_le64(
> > +		CTXDESC_CD_0_TCR_EPD1 |
> > +#ifdef __BIG_ENDIAN
> > +		CTXDESC_CD_0_ENDI |
> > +#endif
> > +		CTXDESC_CD_0_V |
> > +		FIELD_PREP(CTXDESC_CD_0_TCR_IPS, par) |
> > +		CTXDESC_CD_0_AA64 |
> > +		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
> > +		CTXDESC_CD_0_R |
> > +		CTXDESC_CD_0_A |
> > +		CTXDESC_CD_0_ASET |
> > +		FIELD_PREP(CTXDESC_CD_0_ASID, asid));
> 
> This is set for the new "quiet_cd" case too. IIUIC, it is used to
> ease the switching back to a normal CD, i.e. mm != NULL case?

If ASID is used by HW (eg for negative caching) then this is correct.

If ASID is not used by HW then this could be 0'd and we could adjust
the used calculation. It is still functionally correct as-is, just
slightly confusing.

I didn't notice anything in the spec about ASID interaction with
EPD0. The spec was otherwise pretty clear about which fields become
IGNORED by EPD0/1.

So I'm assuming ASID can be used by HW and must be set.

AFAICT this is what the current code does, when it programs "quiet_cd"
it doesn't actually write the whole CD it just flips EPD0 to 1
in-place. Since this is only done from a CD already programmed to a
SVA the ASID remains set.

Jason

Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2055.outbound.protection.outlook.com [40.107.95.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD867D8AD;
	Tue, 12 Dec 2023 18:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FVUNZuR1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fqd5Qt7z5vWzZIqdfI6NOTPb7XtN0nHliCZT1F/76ygMvgW82AU8g9Zn0H/CEfnhoce8PQzaX+U6wwyV+ciCCddmDHUg7UZCOgBECxTMLhGlCjHscqF+BJCEgNZwR+gZmPW2QGij9lDvA9TrHCncP+G6Dr19jdtU3EOFY9ijtosHhBHLmvZkSfCm010fRUnLpxC36Ly8aNe2cu3OItBxX2a0s/Rhwo9cajtcKAeU6IebEJwSuLgcQK07k5H+LJHWgZRbDKX9D/PSQ/J7zGDeRWMRg1N3NOBeCAzwVfZh9S6RKZDBZZlO/WPLuDMhtGX7WKoht8BG+gxfHG2qcjT2Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Icz8h3TOK6uQrmJc+rd+YXAREL4mGBsYycE4/sdxiF0=;
 b=MxVyPBhUFEDMhi4ii7ZKwHuYvnXmDUWk6qEPg07Sg/z3VU0OkM4i/ldpjPlRIo+U6/qtHn+nN/pNIuqGz5xfqJ8lxcUEehBP1izKpPneZCJ0Gb+nCkHOz/NPi158WKd+I5z7EeWKbGhqVPQvfhr+mWQ+IfE6TETrPh8ujuq84NZRTl4qIa6CmAdIwETTnaMIfkm4oLiPfZlVMmo28lUWow6bC+88uKOSx8cwbVAlXtQkeAIAdFtAv8J0tofsNXlHmS8tpnuaYBjT+lZUtpJQ54kwUJBgVM+aZnFaJD0dOKrwN1F66Nr3IcCnZNKJ5GLreqRLVMr9A3Oulirte1EVEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Icz8h3TOK6uQrmJc+rd+YXAREL4mGBsYycE4/sdxiF0=;
 b=FVUNZuR1+Dk8GS8IsJxcgcCyaSvOMihrAOg+8cSmpYm+qTpClDTyURO1j0K6HFPwbDYrzwrj8aH2JMSTW7Vl/hG/FaV9Ob69hdD/94hOTZzXZNtlQIzq+fpUPkWFPT4I+u8oFEwFEU/77TtI/SOWBCLeAd7zWlgBnaFW7bImNMKwYVhWKACaOWoxHtR8x/62jMo5kCKEzdGqVTr4Y0kicz33KzQUOkFbMYMgVvlD1mOXZ6lmRZMVp8mj/ls9xyUsNPTR5zJugmwLtsgE2XsghPrKJFYV2++1EemOL3AT20sHEqNbsDredkTSx4ENMwai6jLDR2u9ff6X0AZJfGvXdw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4936.namprd12.prod.outlook.com (2603:10b6:a03:1d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.33; Tue, 12 Dec
 2023 18:04:27 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7091.022; Tue, 12 Dec 2023
 18:04:27 +0000
Date: Tue, 12 Dec 2023 14:04:26 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v3 04/19] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
Message-ID: <20231212180426.GN3014157@nvidia.com>
References: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
 <4-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
 <20231212162353.GA29871@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231212162353.GA29871@willie-the-truck>
X-ClientProxiedBy: BL0PR02CA0126.namprd02.prod.outlook.com
 (2603:10b6:208:35::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4936:EE_
X-MS-Office365-Filtering-Correlation-Id: 992a8249-8754-409f-de10-08dbfb3cc813
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8EzX/yLTGdI8qI9ZLc8FC7KtMrnyhMkUhkED8/pAra75TQNxqeVepgU3E6kqQwJoyAV3xwN9rDdNAlPZYHkFptqX15fd8OOFvDh0mATBDhzTYfS5dgpYv8R72dmzGFBr6OsMSD8rB6nIRPMgp9sL6qtUaiCjaFoPVB7mU81nNV6Ek4+YmjT7fdgCM7HPZdzf0pQ2rexcF3U2G7MnQJGTZiTJpNtYRjFBtFla+heTa0M659F4dCQ/npt2dBRs/MzE9ODYP6KGAedvgFhtb2KtYMrgkUpcMKiaHCVGgy0NVMvVSi6xJFxsAb7JHX8K444XIk6pNBBoDOa2q8uA7fVOl+GYaTA2sm+TXU+Tn0BNaFkSwnEJMSzIhbCOMS4KKo+M555/1INdJsYk7+JWveZGVU5SQQkYchNYYdQDH4hY2oS+qzUXHimw6HzGUIQR9gCBjBlnIvT7JKbOEcH3M0EAFJ93hUGuVa8hHSQLDub6Gq8tAqRyd8M9dFelSxtgdUFQRgmq5VEXoJIKyXAjCtX8aFMXYSoidItTV/Te+iXuZhkTr8uMnDJtavvyDl00VHMEIXUs4ceSqClEGwRZ5JHVlRSnFc4Ta4tdrESP3kS0VoY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(376002)(366004)(39860400002)(346002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(83380400001)(6506007)(1076003)(6512007)(2616005)(8676002)(4326008)(5660300002)(41300700001)(8936002)(7416002)(30864003)(478600001)(2906002)(966005)(6486002)(316002)(26005)(38100700002)(86362001)(54906003)(66476007)(6916009)(66556008)(33656002)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?upaB8VYkftBSI0KpgrlI/fQG5P89YswCfogT2i3rgTjKToOLgsgGq/GneuCT?=
 =?us-ascii?Q?AwayckLFLRVpflhisz/0QHz6D8hiKajkySt1LBo3vmiws3E1MdMYOdVNTHYY?=
 =?us-ascii?Q?nyDIEy29lDsRCBgCAdtjZRhkXh0bza0KVk9F7pmoJzogn5HsMlVWG1PvQSGF?=
 =?us-ascii?Q?IZ/w55gsBdfQK7J50Am1eQlDXiSGeNkNe4QOglisysR8GavyZLz0QMyiIXV0?=
 =?us-ascii?Q?CvMWOlFgUEuG5Z17T/QUNtH8Kn+IlVPa4t/zXN6x7b/VDNTfCc+HBRavOBXc?=
 =?us-ascii?Q?C8YB+DcC05StFjaXqfc+uaw514YZekCM8VNkaAaKR//JLo1XgR+S0Yu9v2FJ?=
 =?us-ascii?Q?VdiiMl27O2YUBj6r8EMI1F2IA8JEk7JUzrFmWnLPPMtaLy7tc4dSrPKI0kxV?=
 =?us-ascii?Q?FHO5ym5l4tjAM/yCVhtq+WNwKsNypkhW4Y7lDqKP5PUCg52BstC30BkTO/VG?=
 =?us-ascii?Q?flHPDt0frzKiiYzCLVFlA8f93Esrp8r6bnRX3o9L6oRjtGCPev9KIus0qoBz?=
 =?us-ascii?Q?qs/w3jajbdxHeMhmIDOxY83RIts9CJRuaT5ZWSwKUDZA4rZu5xc5MdRkDcMG?=
 =?us-ascii?Q?okPWBKrOncy2bnhqdTszxuMAURZairbTnxCiu/SttlyzNdKWfICAQOU2i7Gt?=
 =?us-ascii?Q?KOYcwaHVb913tSYndLd82LbMU1FEO3yc5n+AHC+uGUfp0siJNXLHTK1p+Gdg?=
 =?us-ascii?Q?gtqETPkZsyns6m5OjkPrM9hpiKoSZ5hiuakSyDGdxba44SKxJH4gCIzrPfqG?=
 =?us-ascii?Q?wE8AoRvpPHfZ+NbGNbvYOHgYZQaJd4tSl09Qm16naj9lUIKIE21jS/o6kzSl?=
 =?us-ascii?Q?DpHecdRXmen8k7AhgCkNGkE9izQH5xAaHrrV2f91BeV9OgP1THq8MvWwTy6D?=
 =?us-ascii?Q?7o6fe2++FiOqj4TWj6YsWVNDZ/pq1N3BlqRVDzDlK0pb5H3iD2oIzCHT6qCr?=
 =?us-ascii?Q?2s5H7mUJu8E8uFkEzVNTq12rUaaajvRHZcoGsILFaMsHknjtJzQk2B5hmwj3?=
 =?us-ascii?Q?KTfbrll4fi3yR1pavcOhf214KCyW9Ig8APEo3zwpSqHNsYaHqumoQxhGG1um?=
 =?us-ascii?Q?NJYpq9+lwjTbWBHtXxnSm5QiqzockSV+pJlNQeriqPIuUehV4l8SoB55NzkX?=
 =?us-ascii?Q?Lic2IwVn9aAgjSqUb3LVfU9ucx31Dyp0eZcvNr8b7UGuEHyU4p4s8P7aGWtF?=
 =?us-ascii?Q?cY0ndAm5wJ+6t1pebbdSp+t3DjUAA+dfHneem+shucHAYUBmsEQRYJIiaByO?=
 =?us-ascii?Q?8DcYX6P5CvweMi7xi5LiQLdQ33xWVzMzSqgw1JTsRjkaNsRMzKXNwSXmNg7r?=
 =?us-ascii?Q?TnOL/6XuVe8UGxi4q8S964V9U0wX0jIcoBb7RDpP2ZRH3VvmvdcPdE9LrjHN?=
 =?us-ascii?Q?tkzsdTNSlurzjWs8CyYV4V6wxK7+bHRlWmf96BSNEVNwdlHVr/XNGa7D92wV?=
 =?us-ascii?Q?M9VjLg/kRlm9yRlOZHrc/VcuCjWXZ/VUjCFm11SZyPw2ebQ1daXZnBdf5pHk?=
 =?us-ascii?Q?hyS+gtkoVz/frrjJV88UDMxfWBBtvF86lmCHOKmk8ArJHDGLsdPLZ8LGpvfP?=
 =?us-ascii?Q?g5Q4Lx3h2ZCI5r+de8mgfgbHjiHwUFFyijCek56F?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 992a8249-8754-409f-de10-08dbfb3cc813
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2023 18:04:27.8231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fGwlS9FMLTA08EVCGv5xcDWuMmuz+7Z91+xBSbre7nJtcPlRFuSwrf30Ledm1PjP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4936

On Tue, Dec 12, 2023 at 04:23:53PM +0000, Will Deacon wrote:
> > At this point it generates the same sequence of updates as the current
> > code, except that zeroing the VMID on entry to BYPASS/ABORT will do an
> > extra sync (this seems to be an existing bug).
> 
> This is certainly very clever, but at the same time I can't help but feel
> that it's slightly over-engineered to solve the general case, whereas I'm
> struggling to see why such a level of complexity is necessary.

I'm open to any alternative that accomplishes the same outcome of
decoupling the STE programming from the STE state and adding the API
required hitless transitions.

This is a really important part of all of this work.

IMHO this is inherently complex. The SMMU spec devotes several pages
to describing how to do tearless updates. However, that text does not
even consider the need for hitless updates. It only contemplates the
V=0 flow.

Here we are very much adding hitless and intending to do so.

> In the comment, you say:
> 
> > + * In the most general case we can make any update in three steps:
> > + *  - Disrupting the entry (V=0)
> > + *  - Fill now unused bits, all bits except V
> > + *  - Make valid (V=1), single 64 bit store
> > + *
> > + * However this disrupts the HW while it is happening. There are several
> > + * interesting cases where a STE/CD can be updated without disturbing the HW
> > + * because only a small number of bits are changing (S1DSS, CONFIG, etc) or
> > + * because the used bits don't intersect. We can detect this by calculating how
> > + * many 64 bit values need update after adjusting the unused bits and skip the
> > + * V=0 process.
> 
> Please can you spell out these "interesting cases"? For cases where we're
> changing CONFIG, I'd have thought it would be perfectly fine to go via an
> invalid STE. What am I missing?

The modern IOMMU driver API requires hitless transitions in a bunch of
cases. I think I explained it in an email to Michael:

https://lore.kernel.org/linux-iommu/20231012121616.GF3952@nvidia.com/

 - IDENTIY -> DMA -> IDENTITY hitless with RESV_DIRECT
 - STE -> S1DSS -> STE hitless (PASID upgrade)
 - S1 -> BLOCKING -> S1 with active PASID hitless (iommufd case)
 - NESTING -> NESTING (eg to change S1DSS, change CD table pointers, etc)
 - CD ASID change hitless (BTM S1 replacement)
 - CD quiet_cd hitless (SVA mm release)

I will add that list to the commit message, the cover letter talks
about it a bit too.

To properly implement the API the driver has to support this.
Rather than try to just target those few cases (and hope I even know
all the needed cases) I just did everything.

"Everything" was a reaction to the complexity, at the end of part 3 we
have 7 different categories of STEs:
 - IDENTITY
 - BLOCKING
 - S2 domain
 - IDENTITY w/ PASID
 - BLOCKING w/ PASID
 - S1 domain
 - S1 domain nested on S2 domain

(plus a bunch of those have ATS and !ATS variations, and the nesting
has its own sub types..)

Which is 42 different permutations of transitions (plus the CD
stuff). Even if we want to just special case the sequences above we
still have to identify them and open code the arcs. Then the next
person along has to understand why those specific arcs are special
which is a complex and subtle argument based on the spec saying the HW
does not read certain bits.

Finally, there is a VM emulation reason - we don't know what the VM
will do so it may be assuming hitless changes. To actually correctly
emulate this we do need this general approach. Otherwise we have a
weird emulation gap where STE sequences generated by a VM that should
be hitless on real HW (eg the ones above, perhaps) will not
work. Indeed a VM running kernels with all three parts of this will be
doing and expecting hitless STE updates!

While this is perhaps not a real world functional concern it falls
under the usual rubrik of accurate VM emulation.

So, to my mind ignoring the general case and just doing V=0 all the
time is not OK.

> Generally, I like where the later patches in the series take things, but
> I'd really like to reduce the complexity of the strtab updating code to
> what is absolutely required.

This is the sort of thing where the algorithm in
arm_smmu_write_entry_step() is perhaps complex, but the ongoing
support of it is not. Just update the used bits function when new STE
features are (rarely) introduced.

> I've left some minor comments on the code below, but I'd really like to
> see this whole thing simplified if possible.

I have no particularly goood ideas on this front, sorry. I did try
several other things. Many thoughts were so difficult I couldn't even
write them down correctly :(

> > + */
> > +static bool arm_smmu_write_entry_step(__le64 *cur, const __le64 *cur_used,
> > +				      const __le64 *target,
> > +				      const __le64 *target_used, __le64 *step,
> > +				      __le64 v_bit,
> > +				      unsigned int len)
> > +{
> > +	u8 step_used_diff = 0;
> > +	u8 step_change = 0;
> > +	unsigned int i;
> > +
> > +	/*
> > +	 * Compute a step that has all the bits currently unused by HW set to
> > +	 * their target values.
> > +	 */
> 
> Well, ok, I do have a cosmetic nit here: using 'step' for both "STE pointer"
> and "incremental change" is perhaps, err, a step too far ;)

Ok.. I'll call it arm_smmu_write_entry_next()

> > +	for (i = 0; i != len; i++) {
> > +		step[i] = (cur[i] & cur_used[i]) | (target[i] & ~cur_used[i]);
> 
> Isn't 'cur[i] & cur_used[i]' always cur[i]?

No. The routine is called iteratively as the comment explained. The
first iteration may set unused bits to their target values, so we have
to mask them away again here during the second iteration. Later
iterations may change, eg the config, which means again we will have
unused values set from the prior config.

> > +	} else if (!step_change) {
> > +		/* cur == target, so all done */
> > +		if (memcmp(cur, target, len * sizeof(*cur)) == 0)
> > +			return true;
> > +
> > +		/*
> > +		 * All the used HW bits match, but unused bits are different.
> > +		 * Set them as well. Technically this isn't necessary but it
> > +		 * brings the entry to the full target state, so if there are
> > +		 * bugs in the mask calculation this will obscure them.
> > +		 */
> > +		memcpy(step, target, len * sizeof(*step));
> 
> Bah, I'm not a huge fan of this sort of defensive programming. I'd prefer
> to propagate the error rather than quietly try to cover it up.

There is no error.

This is adjusting the unused bits that were left over from the prior
config to 0, it is a similar answer to the 'cur[i]' question above.

The defensiveness is only a decision that the installed STE should
fully match the given target STE.

In principle the HW doesn't read unused bits in the target STE so we
could leave them set to 1 instead of fully matching.

"bugs in the mask calculation" means everything from the "HW should
not look at bit X but does" to "the spec was misread and the HW does
look at bit X"

> > +/*
> > + * Based on the value of ent report which bits of the STE the HW will access. It
> > + * would be nice if this was complete according to the spec, but minimally it
> > + * has to capture the bits this driver uses.
> > + */
> > +static void arm_smmu_get_ste_used(const struct arm_smmu_ste *ent,
> > +				  struct arm_smmu_ste *used_bits)
> > +{
> > +	memset(used_bits, 0, sizeof(*used_bits));
> > +
> > +	used_bits->data[0] = cpu_to_le64(STRTAB_STE_0_V);
> > +	if (!(ent->data[0] & cpu_to_le64(STRTAB_STE_0_V)))
> > +		return;
> > +
> > +	/*
> > +	 * If S1 is enabled S1DSS is valid, see 13.5 Summary of
> > +	 * attribute/permission configuration fields for the SHCFG behavior.
> > +	 */
> > +	if (FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent->data[0])) & 1 &&
> > +	    FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent->data[1])) ==
> > +		    STRTAB_STE_1_S1DSS_BYPASS)
> > +		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
> > +
> > +	used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_CFG);
> > +	switch (FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ent->data[0]))) {
> > +	case STRTAB_STE_0_CFG_ABORT:
> > +		break;
> > +	case STRTAB_STE_0_CFG_BYPASS:
> > +		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);
> > +		break;
> > +	case STRTAB_STE_0_CFG_S1_TRANS:
> > +		used_bits->data[0] |= cpu_to_le64(STRTAB_STE_0_S1FMT |
> > +						  STRTAB_STE_0_S1CTXPTR_MASK |
> > +						  STRTAB_STE_0_S1CDMAX);
> > +		used_bits->data[1] |=
> > +			cpu_to_le64(STRTAB_STE_1_S1DSS | STRTAB_STE_1_S1CIR |
> > +				    STRTAB_STE_1_S1COR | STRTAB_STE_1_S1CSH |
> > +				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW);
> > +		used_bits->data[1] |= cpu_to_le64(STRTAB_STE_1_EATS);
> > +		break;
> > +	case STRTAB_STE_0_CFG_S2_TRANS:
> > +		used_bits->data[1] |=
> > +			cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_SHCFG);
> > +		used_bits->data[2] |=
> > +			cpu_to_le64(STRTAB_STE_2_S2VMID | STRTAB_STE_2_VTCR |
> > +				    STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2ENDI |
> > +				    STRTAB_STE_2_S2PTW | STRTAB_STE_2_S2R);
> > +		used_bits->data[3] |= cpu_to_le64(STRTAB_STE_3_S2TTB_MASK);
> > +		break;
> 
> I think this is going to be a pain to maintain :/

Ah, but not your pain :)

Some day someone adds a new STE bit, they don't understand this so
they just change one of the make functions.

They test and hit the WARN_ON, which brings them here. Then they
hopefully realize they need to read the spec and understand the new
bit so they do that and make a try at the right conditions.

Reviewer sees the new hunk in this function and double-checks that the
conditions for the new bit are correct. Reviewer needs to consider if
any hitless flows become broken (and I've considered adding an
explicit self test for this)

The hard work of reviewing the spec and deciding how a new STE bit is
processed cannot be skipped, but we can make it harder to notice that
it has been skipped. I think the current design makes skipping this
work too easy.

So you are calling it a "pain to maintain" I'm calling it an "enforced
rigor" going forward. Like type safety.

> > +static void arm_smmu_write_ste(struct arm_smmu_device *smmu, u32 sid,
> > +			       struct arm_smmu_ste *ste,
> > +			       const struct arm_smmu_ste *target)
> > +{
> > +	struct arm_smmu_ste target_used;
> > +	int i;
> > +
> > +	arm_smmu_get_ste_used(target, &target_used);
> > +	/* Masks in arm_smmu_get_ste_used() are up to date */
> > +	for (i = 0; i != ARRAY_SIZE(target->data); i++)
> > +		WARN_ON_ONCE(target->data[i] & ~target_used.data[i]);
> 
> That's a runtime cost on every single STE update for what would be a driver
> bug.

See above. STE programming is not critical path, and I think this
series makes it faster overall anyhow.

> > +	while (true) {
> > +		if (arm_smmu_write_ste_step(ste, target, &target_used))
> > +			break;
> > +		arm_smmu_sync_ste_for_sid(smmu, sid);
> > +	}
> 
> This really should be bounded...

Sure, I think the bound is 4 but I will check.

Thanks,
Jason

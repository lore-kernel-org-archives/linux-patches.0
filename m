Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80F31D5154;
	Tue, 29 Jul 2025 23:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753830626; cv=fail; b=logDRCJBbOzZ5m7n/A4fzcB4s1O09dDMD4tC8G0SuDehN4oKlxav/l77xL3wDat7Udpb5WtlI2NKqOcdgrZZP7y4md6MioeWjjjFc0wZoeAGhvXpQ5VnaqgiJNljgzymeZ/NRjseP17yDoDlUJvxMFM+mcFl64rC4sj3xeaE61A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753830626; c=relaxed/simple;
	bh=dAwfD/222hUjyVrH5pDbXwZs20zERBYvp/mycVX/DAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AAsm3+4mlqI5yjA8S+SG/TEmqaTRLQlzZPW1AvUJrW0I/HIDBbZMunVCNGVu4+TetKVYyrDO10IbiIcypfGPg1cEzoI8OwnGt1DVFlP26Tm8Wff0ri0sDiE3FY3Xdkp8cBJY8jWhY4lI4K8u4z/lOHS+OVRvOVgmqf6iT92D5oA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HAZE1HFh; arc=fail smtp.client-ip=40.107.223.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HAZE1HFh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wuo0908FvZEMcYuX4Me1xef2fRavNkeQK94/3VhD/uC8wPv8sUfU92Ff+xlB5Kred6VJC4xlYCwllJtBcVhmDI5Y0BUXVRJ8g09kyA1VHky2B9NQrlc8yiexXCRfeJnItPCfpd9kVbYZw4S5ylJ/udpNl8QVWil+oCcjIX+oOwWULG+ntUXqqXRe0iYQ8UI1HjiE0ZbnpZg6eLjKY5TKmlYVw33VHtYyFRi3cN16a50VY52z0kC6GHm2glcQLakMYLF/H8FmZBR9YLFjg8/qLpVU17lnjLU63vJszTkmIM7ouLNYlv3EEPdhYuXb7Go5gxy+Iw2LrP+/KzgoXUssVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y6x1nA2cc+GNrZ9wfZPvWd1/08kjJcjEX4FustG0a8w=;
 b=jN5NmPAgnr3yeGUyu298txI2uWFZrpQBygLhaleWt1Fg0SKCrZY0qWPXjXULJeH/H8P3JpPm3gfa+H6M3GfTiebvoXg+T5gqJAOmUomTQG3r7XxBIGF5T7BnrRsz2CbE+gLdSBEGLAD5gWtR4JqHhr2tNJkkpqNNlkTGI3JX+i/CQ6PcEn56WtBK7DwjwG5VmYu0d1jGLJLeg2+HyBt6sAqHQRpS4L+jhmu6eeC0aPzRu3h2+faVOVx7fdpi4NSwm/dE+8f1KNarnRweZNLzK2ufymp6FmpDAiQo9p44C7kBAR0waIw2wQsGaIvGqVVjiH7oQSxKWbkOkZ6i2yL8Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y6x1nA2cc+GNrZ9wfZPvWd1/08kjJcjEX4FustG0a8w=;
 b=HAZE1HFhZ7VezdoKlPs6xUBkuBcavGlnpZTF8azURxGP4QKPgkYNOu3kSUTNz1S9QCxh/WrHfZAawvc158MoR+g/TKJO4250bu4MOn+vBmHLrmJno9ylahQxxX0i5pTZi/maSIE6T8OmVqtU7qu5ES7lTrpgX87+qKmKmYmZHQZMblFW0jNfGYQVamseVaHphSG5dipUs5YaNrb+/U/OVFfPT7Rc0MyiroagEEGeOJ5XGWGYOvk20UsFetASVm9QPjnxNvHLSSHnyIYckkJx4jKdTzPL7kfeesVt+m+IwIADdeZX8zRHb0qujHWGbfwi+IHyISFzQNoHl3OicFKrQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by MN0PR12MB5978.namprd12.prod.outlook.com (2603:10b6:208:37d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Tue, 29 Jul
 2025 23:10:20 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%7]) with mapi id 15.20.8964.026; Tue, 29 Jul 2025
 23:10:20 +0000
Date: Tue, 29 Jul 2025 20:05:18 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH 5/9] iommupt: Add the Intel VT-D second stage page table
 format
Message-ID: <20250729230518.GD82395@nvidia.com>
References: <5-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <529ca56f-5bdc-47ad-8d0d-6b3b5c800c7a@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529ca56f-5bdc-47ad-8d0d-6b3b5c800c7a@linux.intel.com>
X-ClientProxiedBy: YT1PR01CA0149.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::28) To MW6PR12MB8663.namprd12.prod.outlook.com
 (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|MN0PR12MB5978:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cb0132f-fc0f-45bd-79a7-08ddcef5171d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0Yu+GR9L1Cqs0FwfWHIE1ay8nW6ubbTe9LxEFkQzWG9JaSsKtpdCovGRr9u2?=
 =?us-ascii?Q?wTI04PXk9uOoVzOnL6asz33tx5mwptiBV/qsYK3ECo4GHPM7BZhPez18XL/f?=
 =?us-ascii?Q?hTRiEhdefiWQNpD8LNzdN/wS2CyIX1IaPLw4Ul36AuzCvnLoRNMJOKC+bPNH?=
 =?us-ascii?Q?789EE2WErmeitQ5QD8btS068n5fobXEvbYFbCSUhD0zmhMRzvs74FzqRzajm?=
 =?us-ascii?Q?Bp6nH0Au9y+wPjSLEZ9SOR59VYoQWrIQ8e6pfO+eJgpqMXNDhYohjaOGL+7F?=
 =?us-ascii?Q?UOfbOkJboC03y6g4Q5kQn71AeaHF2qYHRG+s2grJKsrQL9Z0epIxITZ/paFs?=
 =?us-ascii?Q?YSgRCHwWF6eRxUaxaI8+2WqG+YrHpXQ+V57PeG/TWZ0ENz5D7h02fN3HVd9i?=
 =?us-ascii?Q?U23NQKHh+D/yNPTm4jdzou63qBycnZ4+nqPCqyleM5GOAaSsr68mKdIK00JX?=
 =?us-ascii?Q?n2Hgta8RCiO93rpVzBI4dkiWZh+UjYJIplGHlIwPfkeqzaT0GqAYgzEKynGj?=
 =?us-ascii?Q?s5eIuio5uP9i+lej4UOOefFrFCPcZhHkuIMut0oPMtJtVP0Ai0bviakoy28h?=
 =?us-ascii?Q?O5sKp7O8lCWI7hrXoxueflaGO24WEwRI/3kEwFncX5Nm/HI3ZW2vmM/9+UIY?=
 =?us-ascii?Q?DCZ0woprdUrjEIeXyZtFiqgECoftYPBzCcYA+bQc0qdZLqabdQBmKf7ZKGPC?=
 =?us-ascii?Q?uSD6zzyrriCfUXTwK37ZPjZnN1832LUyPWPvi1/yeDKUOuklLi/fwfSvm5S+?=
 =?us-ascii?Q?Tm6++FBNMjlVpD98k4dtHaNftLlApdR5kGS2n/MDHxrHTTDbQ6jq+cunE0Ui?=
 =?us-ascii?Q?TJJN9TUrqeZzB3b3pDo2orH99Vvq/aTzknqKoWXQ06NasA207Kj9eSKp/R/5?=
 =?us-ascii?Q?ZNU7bmQNhnqDHv4XxL4oQcNvuA5wjV1EojstKt6FtrFGW4JXFicuAdfH1yQw?=
 =?us-ascii?Q?ck2XAxLzEHryXZkQs1gfGb9ybh+1tBAmUbdHU1FZIQQsvOdI+QqLRDOvNwrg?=
 =?us-ascii?Q?4HDZhGsWhBTKW0JVqVFVQnacFx+cXX2LhUiSJUu8kNiLJngSZdJ9YaPyQeL0?=
 =?us-ascii?Q?IFzKuxlbk5nSFUOR/dD+u8+EWLuXDpEJwtA0EGAwjs3smNFuDCyEMLTbVWWS?=
 =?us-ascii?Q?OAya+te3EDb+YVQiZG6bWe0YTu3IFSDCiK4neWRlWLCaxImgn6QqSdvy5EAo?=
 =?us-ascii?Q?rcX4XDjZUk5tDB34gUL0poYw+cI3WicThy6+oJ0I6QE6sobbr8seSL1wijxu?=
 =?us-ascii?Q?tboZ9WQX2q2YsJ2lPrB0LLjt6ygBCB8YD34a0FQBO6/9pDn4g7B5ph9WwjvK?=
 =?us-ascii?Q?/9x6rYIQMYuUeT2s7DwDfnwQ0jvwF3yJQLlth7a0PTyYZWhxErbkw4rMwVEl?=
 =?us-ascii?Q?hT7ISuUJePFwRGqlNQdP0j/FeNQE7lOgWLpTl5k8g8XoZP8IQA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+CAcmTmqpG5ho40h8Ux7mTEOplNButv0Bcg2qwWL38am50V+qFSsypNa8uNs?=
 =?us-ascii?Q?eNY6ETkanqdeYL3MNVXi3BpR6dF9gIg0ITZx5/p81gNGpoq/ZgQf8eo3O1PW?=
 =?us-ascii?Q?abVUagkHwumFYVt5ZziA9TTkKgHbNOuTdJ1hVI5RG5kC/dTFpWxw95r49NpS?=
 =?us-ascii?Q?7XEg2doS/8g0R1fjUpxjG7SvywqPqwIziFECtaPt6gs5erbYY2RmtaLJoRyS?=
 =?us-ascii?Q?H9AgS6ytvNiDQqvqhqxbudrk7QNOjC4foB5ddVBajm43zF19gUxEP4gLIXU5?=
 =?us-ascii?Q?4m0f5oHLzzvcKDw1Ebue+L9LKmmsPy9K8c7FGpMM7gWmdgX08Wu1zB8od8hy?=
 =?us-ascii?Q?lvxT+OhYRX93HMGYEmWb/DZkQ81SPjyzrBZbpBnDz5bEOn9a3ShDNT6CxmRH?=
 =?us-ascii?Q?TXl7VlN1Y0Y3fP4oOoYUEkNorV8WT4lqdjCiydHylA71vUVEHXlL0JqfStJH?=
 =?us-ascii?Q?i4GOF84z9vhvEoPfX11AxZTInqK1N17DTRJB3p4vnQWUOMM4y62s9+Jf3YYC?=
 =?us-ascii?Q?VqBs8mVYxg9Mc5yE1clD4y8gdYTF695Y2UFxwKz+lKpgkpnZQiz42dDN8ouu?=
 =?us-ascii?Q?8tEcMZ4DKCVbtwHWSqKwAF+RliqM2pTvtkaUnkjGynSXWFQeSutO3dnmp62L?=
 =?us-ascii?Q?cYps/gIxfnuG6SVWGj1qL5rfJGIAXNa9YUELQ0rsSn93Z2YtGYY5BFZoM9kM?=
 =?us-ascii?Q?geIEFb2kuJRLlv870xtT5wZIMV9t8drY6iIOyC7tVVxGxNrnhjh2IF34ECbo?=
 =?us-ascii?Q?ZGLybaX4OGHJrd/F8YSj1hC0/AwI+6P0labWP9hGa+Lh8czAsPIJaEfbd2nE?=
 =?us-ascii?Q?v26q5HpAdErI2d2c0mNc1PtMb80r1gaZtjbueljpIa3c+5Y/fbYEhdZbV4AK?=
 =?us-ascii?Q?sbqnVE1gW8oMp02jp4652b3QZJAyIa/+SZY1Fzfv2y7lgkNua0ETaZKqNDzw?=
 =?us-ascii?Q?4Dg4ZteXm9pWPBX5az3zUSG8/7J/LhX4xxSUnEgcVwXVUogCrnO1bonjZqH1?=
 =?us-ascii?Q?IzDxKJ7ZXFjaBZVpFdy4IsNfH8hk0VtFwkN8kr6X09swzMfKGynuiLZDqmtu?=
 =?us-ascii?Q?a4TfooVxsW35hjHa3EzipixLMaIXqXB84lq4lwBQBIBYkRzG3FB4UoUyD8EN?=
 =?us-ascii?Q?2zVe0iEUJ17N3cPBHlQPKgvXDlspkFbkjA6GqW0AB6aUzXzPBD5v1anCEC5z?=
 =?us-ascii?Q?REJSuDZVNizq5jOOEVjAA0jEFQQNLnw0wBVkWJCNK4ckIzF7cuxBtvU5QdEP?=
 =?us-ascii?Q?8KRzJ6YLXErR/4yjdt3pih8XwkMtYJ9oPdEIz9lwKLWdzXekIDeTINt/PhbD?=
 =?us-ascii?Q?HttwtPmQ5vXH+KLEQKW4Aq1U+MQ7k47GHLv98fHKw6eDeo4306OWU/3KnE3c?=
 =?us-ascii?Q?KcFgbtjUJKQRvLi70VdQ3yoRJ9V7cIzicWpFTqSOQ09D2PYXaOrwWPPKlbew?=
 =?us-ascii?Q?iV+/KVwZWJZ4QkiXJ2X3kIFuloVzVokjXR813LdXjAbYhZl5AbfnF+JRqkWF?=
 =?us-ascii?Q?Rsw7uKwYe1Kt2enxrkNFq8VnYQgpozIgZ1eOFW/lqcfw7VWFRwqUslBANB3X?=
 =?us-ascii?Q?j4SZ8bXJpw+jqPb/iV4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb0132f-fc0f-45bd-79a7-08ddcef5171d
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 23:10:20.8774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mj7kwF8r/WLsBBT8RaJcbQB2SiPOsM/I7PseARgAizE1xJMLiBRpVLtodvUilNn/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5978

On Tue, Jul 22, 2025 at 11:11:02AM +0800, Baolu Lu wrote:
> > diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
> > index 953856e4b48369..b631cf00eba559 100644
> > --- a/drivers/iommu/generic_pt/Kconfig
> > +++ b/drivers/iommu/generic_pt/Kconfig
> > @@ -56,6 +56,17 @@ config IOMMU_PT_RISCV64
> >   	  Selected automatically by an IOMMU driver that uses this format.
> > +config IOMMU_PT_VTDSS
> > +       tristate "IOMMU page table for Intel VT-D IOMMU Second Stage"
> > +	depends on !GENERIC_ATOMIC64 # for cmpxchg64
> > +	default n
> 
> The default value is a "n". So what's the value of putting a "default n"
> here?

I do not know, I cargo culted this from somewhere else, lots of
examples. Do you think we should drop it?

> > @@ -72,6 +83,7 @@ config IOMMU_PT_KUNIT_TEST
> >   	depends on KUNIT
> >   	depends on IOMMU_PT_AMDV1 || !IOMMU_PT_AMDV1
> >   	depends on IOMMU_PT_RISCV64 || !IOMMU_PT_RISCV64
> > +	depends on IOMMU_PT_VTDSS || !IOMMU_PT_VTDSS
> 
> This line implies that the IOMMU_PT kunit test functions regardless of
> whether IOMMU_PT_VTDSS is enabled. But if IOMMU_PT_VTDSS is enabled,
> this kunit test will also cover it. Do I understand this correctly?

Yes.

The kunit test will build a unique:

kunit_test_suites(&NS(generic_pt_suite));

For VTDSS if it is compiled in and that macro eventually drops an ELF section:

	__used __section(".kunit_test_suites") = { __VA_ARGS__ }

And then the linker and some kunit magic will automatically run it
just be virtue of having compiled it.

The odd || expression is a kconfig trick that ensures that the kunit
and vtdss have compatible modularity. ie the kunit cannot be built in
while the vtdss is modular.

> > +static inline enum pt_entry_type vtdss_pt_load_entry_raw(struct pt_state *pts)
> > +{
> > +	const u64 *tablep = pt_cur_table(pts, u64);
> > +	u64 entry;
> > +
> > +	pts->entry = entry = READ_ONCE(tablep[pts->index]);
> > +	if (!entry)
> > +		return PT_ENTRY_EMPTY;
> 
> Would it be more reasonable to check the present bit of the entry
> here?

VTDSS has no present bit? Did I misunderstand that in the spec?

IIRC this design uses all bits as 0 to mean non-present.

> Otherwise, it implies that when a PTE is non-present, all fields must be
> cleared. I'm concerned about any potential corner cases.

Since this code makes all the PTEs it does do that correctly, and we
have a great test suite that looks for corner cases :)

> > +static inline int vtdss_pt_iommu_set_prot(struct pt_common *common,
> > +					  struct pt_write_attrs *attrs,
> > +					  unsigned int iommu_prot)
> > +{
> > +	u64 pte = 0;
> > +
> > +	/*
> > +	 * VTDSS does not have a present bit, so we tell if any entry is present
> > +	 * by checking for R or W.
> > +	 */
> > +	if (!(iommu_prot & (IOMMU_READ | IOMMU_WRITE)))
> > +		return -EINVAL;
> > +
> > +	if (iommu_prot & IOMMU_READ)
> > +		pte |= VTDSS_FMT_R;
> > +	if (iommu_prot & IOMMU_WRITE)
> > +		pte |= VTDSS_FMT_W;
> > +	if (pt_feature(common, PT_FEAT_VTDSS_FORCE_COHERENCE))
> > +		pte |= VTDSS_FMT_SNP;
> 
> The comment says:
> 
>  /*
>   * The PTEs are set to prevent cache incoherent traffic, such as PCI no
>   * snoop. This is set either at creation time or before the first map
>   * operation.
>   */
>   PT_FEAT_VTDSS_FORCE_COHERENCE = PT_FEAT_FMT_START,
> 
> It seems that you are okay with setting this feature after iommu_pt
> creation and before the first map operation? 

Yes it works as it is now.

> Do we still need to reform the enforce_cache_coherency callback
> mechanism?

I think that was motivated by the code in the driver, not so much this
code? I can't recall the detail right now but I didn't think it was a
very high priority.

Jason

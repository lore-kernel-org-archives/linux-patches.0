Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3736C15CD46;
	Thu, 18 Apr 2024 12:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713444539; cv=fail; b=lhBbk4/yFpGIey0CKy6CRJ5HwwXTO3P/WoY5u5S9vC9AUei2uqe9lIzblob5ZsvkiEdSdcouWsJ3PqmxJFj4uTZ30b9SoPP1ujR+UGJ8RggX8jJLycEB2roFuFPML/h603Gxz11u63YzelxvA4y5t7HezN7ChULiIJbFbmMdr20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713444539; c=relaxed/simple;
	bh=h/6trcMtAOyoczbQhGkowQWYMuPQkqTblyZBWTkA+TU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QSr6T8YTQ2aouG0rMVeDWSP1BujiR+37zh+RKdPhjIu7lz/DLhTnVqmw+iUIUQC1pJnJaRGopM8kxXLe/F0aAvDgpceqmciT+MqEC3+nZZZzmtrUYefolNMmbQpynL07W6E/3WNTZ7bkcJ9CsNqoO4SDXTrGC4O9yQKn9c/hvmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=R2nHEGBY; arc=fail smtp.client-ip=40.107.237.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="R2nHEGBY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lGFPMbypkRO69TgBzRtwHKQlnUGnfgmdfYYCxbdMahYHbThxDE6lAQ5ejFwYFmYRAQqB6JhbXrifwTI1u9RmJuDxp2xcCeCiASaFT8MGKs/NVu4WDQtCKttEBFI7B0sYlkIIYFRlB4TTDvppVvTh1UfWkapBReea31ZOcNX4KK9lImwtfK7bT9PJLzpoIeBTBq/r4uLOWwFTZ7ad55Q6n0pl8c4NtqSUDZvogUKmeKTpGVpzPgn+2QtnMScntkQimRNQuQrP0h2Oo5NSpGcwWIlQyO08JC9f5yILbUHXmlbkx0As0+DREXwI44+aHydJ+yS5bwKr8nF/J8n3jHVd/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wxSH6QMaLiv6eHEGvMqsH1VQjC/AgjE3HRlc97SHr7I=;
 b=gBFaqwpXlBtMKUY9v3DVclszkJRWm+KSTf+1OjBK1KP5S2p/FxCfmXmvfRKosCD0ixyQ5lmBrgVKLVAYpETGPz8nrH3egPAgGxXw8XL5HN2HP8dlNpnIWtSqhlqINLm5oWdvgscUvN54MZP2xKiff2dVYnaXgUmkOZF4ELKpygH00BEo/wzZOllcfmL8wkkLbdEYDoU9M/DBTtMYcaIIOfYTkC6A+kqT2/9pgnjeyGU7H1FHeUuCPO2SlHKSHOFupuFAHPxirXkA6hL7kRSmr6+G/KzBoFvfytmPPlgLNr0afBYHuLlm9YdAg/9VyS9N5dUfTGJewves/i3StgU3AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxSH6QMaLiv6eHEGvMqsH1VQjC/AgjE3HRlc97SHr7I=;
 b=R2nHEGBYb2GTeijy8YxII2GFIMWXyp7G0b23O3IaFMHO1AhFBX1nWNokSkUjD+v5raLa44Nw68DSA5ZwMQEF9xMgBCGxa4UJ+aHAbhbU1rFNjPYTt9ofcndDHIUc45gv7bK91mjxkLaxKzYuvQKkYWJb4kDsmyH871I3KXFn/VG6c7DuBOw+yqnzCCXeUI7XQ31dQ2HNHVtX0CnndtYV6StsNz2NJKHLZxwzlcN6SB0mF668A0Niarhuwd+IWmKkRYMUFwXa7RBbq6TjTffebg/ocLUKjI5YDk+G7xF07JaioFfWBorzO82AL+zsbiwDGtLV1h80mL6wcrievf0xuA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH3PR12MB7620.namprd12.prod.outlook.com (2603:10b6:610:150::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Thu, 18 Apr
 2024 12:48:54 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.037; Thu, 18 Apr 2024
 12:48:54 +0000
Date: Thu, 18 Apr 2024 09:48:52 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Shavit <mshavit@google.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v7 9/9] iommu/arm-smmu-v3: Add unit tests for
 arm_smmu_write_entry
Message-ID: <20240418124852.GA3050601@nvidia.com>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <9-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zh+DxJoAMIXy9O/R@Asurada-Nvidia>
 <20240417141618.GS3637727@nvidia.com>
 <CAKHBV275bzhRK6oSvDrH7h780qde53z_x8TLVtV3sHACL3gMHA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKHBV275bzhRK6oSvDrH7h780qde53z_x8TLVtV3sHACL3gMHA@mail.gmail.com>
X-ClientProxiedBy: SA9P223CA0021.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::26) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH3PR12MB7620:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d5cbe53-c736-4488-f2c7-08dc5fa5e78f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?L6KTYmSXww0i99n47KEIFGuqV+T3E/3ylc01441pIeiWCZ7WZyfM7YChWc45?=
 =?us-ascii?Q?qIHgEfnpMi9+rBJEokjICkaOrVgIQBF0C93ZkRFNCMhVo1hq2+9vDUE1eL4g?=
 =?us-ascii?Q?fMfd/FkQG6kJrPFoEuxcjk6h4L21eendbIiyS3Nia7hQajRejg9pp8u8JDsK?=
 =?us-ascii?Q?s7qSNseX4pB6r5YYC8FAIMaSwRLR59CyQCxyGsXwVdvHYmfon2UM+yfpRc1y?=
 =?us-ascii?Q?ft4V4CYoSRPwjKjBDx4VHMx50BUYyFXZ9Dwo/gCiSc71hegNYif+arQXpias?=
 =?us-ascii?Q?oJg6dINhebtEozlMSJrom0PxVr1N5Xca11QrXS8TAjHwB5m3qwY0xQJ09f87?=
 =?us-ascii?Q?oFgKyWmWuJgLZuV7zpCK29zSjJMWFJ5fneaeeODGxLZpfuOONLuF+pTqtl4A?=
 =?us-ascii?Q?qpdnxqj17lDKkDJoAnwjXRcSXRjoCFY22XfvYB0ZI+uEsVAOO+fZGnSbGWcA?=
 =?us-ascii?Q?tgzsz104mvr1+RSFUVDsg0sabJb613TEK71ekze8WhAo6RaVHKDcafBkaEzs?=
 =?us-ascii?Q?TwHOe0o7cX304ojk37/7zFIuQACOrNCzSis1E3V+jM46bumegsts5KG4LyPM?=
 =?us-ascii?Q?/4siaA475FPA2HLyMSqBe7K9hW0ggZ+44wNDM5eefy5VZyDayjai1d+6OtvE?=
 =?us-ascii?Q?lJ/4n3dYtv4OmhJN/kNzlidaqiCflLLZOPkLDWnqbbza+0IYV5DQsCoyshuK?=
 =?us-ascii?Q?PTbD/HZRATff7faIYx7Fl0J56y5U9QkhMR3tc5kh+lH6efqYWK6HrCwDCLsF?=
 =?us-ascii?Q?SQwz9zsndZnC+p/WvFTKPYuzSFVEibnKoSBM8MX818dHs3UV7foV18lgXT2s?=
 =?us-ascii?Q?wbCob8aY3AIlaZr44CFNDoOC1HLGfpUBDbcP8rLCXrPMmFNQrBKsWClkg6Yp?=
 =?us-ascii?Q?nn7rUcrvOunYc2dbw6tYmdjkEVIuRDyX6zQv66b9j342heDL2U9a7VrbYK2s?=
 =?us-ascii?Q?5V2kKkK+qTdjT0G9Ba3d8sBR2p0c2M0F80k0r58pH8ozHiOgcF1NxNmAcYGx?=
 =?us-ascii?Q?kOxFZHXqgMDZ7Tsg9zGFVPhbvTkaZr1Adp5/vLn7OsuwX3EvntsWJ4HCzb17?=
 =?us-ascii?Q?gTHklEUzGba2WVf/NWG5O48EM2uhmIyz84q3z0KaLK1tA1JypPbUXQnLxHsV?=
 =?us-ascii?Q?mB991OVtFCfuO2jkH2U/TuEE4KsEVzf8k2UMRRzApRGyE/HAh+S6m9EpjXRC?=
 =?us-ascii?Q?kiA/fDcZMhUB68xOqPgDCZmFLDeN2XO5fYsBjswoTa1XOkVzADlCe+f9lXde?=
 =?us-ascii?Q?YQ+f5dks3BY7mcbxmagyqoO7+JU75qk1T391Q064pQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cn9aUlGuq8UseTJChwGQ3qw104ZyRhORMYIygvNiAyR36ELLROCU7pO1rV5c?=
 =?us-ascii?Q?gcsJBTBK61mtP7tprO8yOgHTzKCDjPlQW8mQ9fxfKz8HlfaiGOXnYjLR3YDk?=
 =?us-ascii?Q?Ozp9p9BGE0PigqIg/MFgLvEMyZIZdz+m0fWKgNNqyMuF3iB5oWKPImbF75GZ?=
 =?us-ascii?Q?AsEMjQwgf09RCBTDGR5qgHi8y52fMSz4H5rBucHzG1fZEEj+r6GtgRFwCCvd?=
 =?us-ascii?Q?fc8+O88UOjVI6WnD+PLxjMST7XuHI0Nom4fv3pUNKRT+Lgr61WoqWoeKCXCJ?=
 =?us-ascii?Q?RbwgmmDeN+2sy/6ALqPymWfF7IAK/lJw3a6doAGxP6JGUrsgS68UV2Gn2OK+?=
 =?us-ascii?Q?xE8YhIDNxm48fwJysG11/Cxsx0NUR2ICDNN7du38ywxNQ8GqdP/YjA4/qKkl?=
 =?us-ascii?Q?4osAc7Z8tikAizEEgW0glAaaErd0RneTqgsszvxQJ8l3RwLBK4JYsYgRQ9O+?=
 =?us-ascii?Q?4JZwNwj4ET8S8ypc7ZLJeym/McESmncJ2udHzX2wkdnCvtWumEpm43m7SfPo?=
 =?us-ascii?Q?mTRwoB/Ew+ENtE6zzTBOD+A2bB2ZXinUZs76rs/ys6x4PeQVl2er21J2UaJ5?=
 =?us-ascii?Q?mLlu4NQE1FN90hhIbc+p+9p52krOkCagT8mxPo6MAxB7b/rstUUyqTMpIfeX?=
 =?us-ascii?Q?68Hm1AKxRmC811AqDOUqtxX35e5qujdv6NRvfWYobEiAASmPJNFBmDWydAAC?=
 =?us-ascii?Q?1UBnUxbd5exC0vYqoBegUft+bIwqpB2a0oSL69xoQ5/yBDhjFfVKaiHXAi4P?=
 =?us-ascii?Q?HG+qHcgVdPuzZPTGak96yp0LwbnYGLouHlu3i1X1bOtSim8LtMo+v+TVRdmT?=
 =?us-ascii?Q?MyT0Y/GuwHJ2z4lOqAFHjnP1Rby7iuQh2GxpW/d58FSvn0m6o5ixNAJ/wM37?=
 =?us-ascii?Q?W3XSo+nKxHk0Rga6jguPnwPw8CMwXJ6yWb1FqH7Cqw509wYNpWMETw6QNequ?=
 =?us-ascii?Q?qxoig2BJkwMa/8ASxI4tzIaN6astSH9SxcNy9jvCv+0eoXBJHsuXTpFjpRuS?=
 =?us-ascii?Q?s61xcEOHKH3lcLmeJglvaji/r21AR5FOvgbNPXBa0JGq3gebA/02k17W2pph?=
 =?us-ascii?Q?4csvcaiSjIuaLoY7XCi6Wjk64CyB55YtxFmrdGq7U/CtdKNq8Ohwd68PBV6x?=
 =?us-ascii?Q?HyymK9v/3IRPjY0S7G9kBdK+bYrOzMqP56p19qZgEI98/NEYuVB5nIGABFPv?=
 =?us-ascii?Q?nIyDRt9E5Bz2PKRIc7ZhrZ8cQFpryeb8zTwbjX1AvHYFnrZxi9ZYz6wXnTy1?=
 =?us-ascii?Q?piMZGxkUVESG8318Yj1HuU0IV67X8KtShsBz7iSLq7RIIbVZows5rn7YQfKY?=
 =?us-ascii?Q?nSFOXEpXAYdfG5wBHd+bTlcoMwOmMunRVxB7a7uLzguU3CkARMFU3tbO5324?=
 =?us-ascii?Q?dM/11T2JwCpW4mtPSsa+H0rcSuIFkd5ArahZ/6VaxBnTLkI5zB8Yp1DznLW8?=
 =?us-ascii?Q?36nx+sw8uJVhbkfy+VBGC9QOzBdqtPp5rFT2TTwYuYZwiRkDlanUK9MkwOV+?=
 =?us-ascii?Q?2zv1BewxWe3v3NtwETuKc4nDQiyRH2apVOA/UHcipO1iNh3POCQiH83/Zx8P?=
 =?us-ascii?Q?IIAQuoX2+ZAhY0HkmXc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d5cbe53-c736-4488-f2c7-08dc5fa5e78f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 12:48:54.0127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eA/6zZEHj1SG9aaO63/LUQ2wmayJLtkxHsjY5rzhq6J0+y7QI1ZTSXBWFDJzX2wW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7620

On Thu, Apr 18, 2024 at 12:39:29PM +0800, Michael Shavit wrote:
> > > Forgot that my SVA sanity doesn't cover this patch. And it looks
> > > like some problems here when building it with "=m":
> > >
> > > ERROR: modpost: missing MODULE_LICENSE() in drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.o
> > > ERROR: modpost: "arm_smmu_make_cdtable_ste" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
> > > ERROR: modpost: "arm_smmu_make_bypass_ste" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
> > > ERROR: modpost: "arm_smmu_make_abort_ste" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
> > > ERROR: modpost: "arm_smmu_make_s2_domain_ste" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
> > > ERROR: modpost: "arm_smmu_get_ste_used" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
> > > ERROR: modpost: "arm_smmu_write_entry" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
> > >
> > > Likely needs MODULE_LICENSE and some EXPORT_SYMBOLs.
> >
> > Oh! The kbuild never tested this kconfig combination...
> >
> > I think just this? Michael?
> 
> Urhh I'm not sure... Should this also depend on ARM_SMMU_V3? 

It does:

if ARM_SMMU_V3
config ARM_SMMU_V3_SVA
        bool "Shared Virtual Addressing support for the ARM SMMUv3"
        select IOMMU_SVA
        select IOMMU_IOPF
        select MMU_NOTIFIER
        help
          Support for sharing process address spaces with devices using the
          SMMUv3.

          Say Y here if your system supports SVA extensions such as PCIe PASID
          and PRI.

config ARM_SMMU_V3_KUNIT_TEST
        bool "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
        depends on KUNIT
        default KUNIT_ALL_TESTS
        help
          Enable this option to unit-test arm-smmu-v3 driver functions.

          If unsure, say N.
endif

The 'if' creates an automatic dependency and groups things into a
kconfig menu

> Also what
> happens if ARM_SMMU_V3=m and ARM_SMMU_V3_KUNIT_TEST=y ?

Works fine, the kunit symbols are exported and we still build one
module for smmu so we don't need to have internal cross-module stuff

Jason

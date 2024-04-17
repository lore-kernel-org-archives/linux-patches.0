Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317D7140397;
	Wed, 17 Apr 2024 14:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713363388; cv=fail; b=S6PV+0aszwFIPwEko477FlzOz2d3N0hsc2SgVFmKhd4yTrOVuaddZjJq4/EkHgv+Jrr8jRPcSvm6QLq8dcEOhDwQS/gXqtn7VyMC8E1rUrUY2e52eW5wZAKhxWpbKFw00Abt/R5eJcE+8lYB6MSTjauHSCT3L9UlzHQT3TZJhh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713363388; c=relaxed/simple;
	bh=N4OV8Xm9O7d52RvnL3RCnrrtfdhskWOp0I2mGVKkXSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=j4k12cuUNMRJ9qKAxVFdTx6xf7W8ciJA7flL3c90djX97gGfyBEnQTBS1dDFbubDQJkbzvRBuCEnw1U7n+aOfVVDK1u40LHEhZJCGDQ6UOmgpkMKux2BP7Mv4fvXh5poy680VPqY4gIqecUlumoqb+FzFvxIh2wKvLDxyT/+bOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hX3kxGCx; arc=fail smtp.client-ip=40.107.220.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hX3kxGCx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwKNfo8IWxiEupggqGo8cYOHUgd/51R9pPTMA6aGoL1wA4PDSvyR87BNjKa84zWs/y6mizkeoUhCq6RYz86gYwuc54/omVMNlU7k845a/7hHB9gNzPWIWm+EkJjvvjJBUUAPe5j4gBYYdQFPPctWdvQSLiRvnY9NyuLq3GMBiwgeJjn7ysFgagqxV4SHk9nH+x4uULOOXPx/T2zs8Wxou+ppCeQN1unMjewwTc5xL7gsYh/ckCurXHOQS23ayNRItdUnMxujgHax1MLBsQeBItxXqhyH/bRyqrT2gWiJ8z93tSxr7XbltzO2ACHgH3PZWHOMGc9MVpt2BFBhMmBV7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XSh5Ps0cp96mHGN3H439ZsVdgaal8gSt7dxlu41Z0NI=;
 b=Bb/TreklzWXAZy5uAj95c3tvrjtoVt3/vro8vKrQR1G/eRKz1t/DzFa2yKinj9iXzaejKTSl0O0W48V/N+kZOJw+XtF4/ZvI4wUEZ/Yj81kBsnOGpKPNTyI4dtgUVJCFZJ+PglpTcFvf/1uJ1e4AwNWFPMiBISoZgK2YoHbNQrrh7p0Aso3GNP+LgUy3RaZtzkCxjgYbYQtNxSoJLhR6ryRpqoXBdRs7vQFXI5sODYGLyEvdH4rOPDrHoktwyWvUiZTHiScmO8f1hVtpTFkV1Iqztf4nA3qahkJA+Ap8if+Bpibh+JLiiU6nzFULyE9EdMcCsaE2LyCuhI+XR2tTnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XSh5Ps0cp96mHGN3H439ZsVdgaal8gSt7dxlu41Z0NI=;
 b=hX3kxGCxqPZ4pHSQnitBwRl5rYKNs4q1Z0zy1kKXOKWuN9HXEhvrRhdaV4YTOzjoKrFDWZEfOxLgwYSjFLm8FraIXaqtl67a/lNmdRBQUYeO8TbD+6sK4j7c7ruT+PHndLedLEHkP5689+QhhefV7QK1R6e135rhxo9JpTvf/hxrtXrWJYiFXqz0doLwEMotHfBjKFKxgSMMcUGWWhieVG8cX55haHoZ1MaPebDDhbv+bhAYDuGd8nvOl5GNeWjo11Q44wuLm1vZcE1k7HVyOWYDwrlKLcxZrlSJo7izFyneUXDBICvtgru2jrsjdwfXYQgSCf6BTTsaccV30WaCWA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SA1PR12MB9246.namprd12.prod.outlook.com (2603:10b6:806:3ac::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Wed, 17 Apr
 2024 14:16:23 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.037; Wed, 17 Apr 2024
 14:16:19 +0000
Date: Wed, 17 Apr 2024 11:16:18 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>, Michael Shavit <mshavit@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v7 9/9] iommu/arm-smmu-v3: Add unit tests for
 arm_smmu_write_entry
Message-ID: <20240417141618.GS3637727@nvidia.com>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <9-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zh+DxJoAMIXy9O/R@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh+DxJoAMIXy9O/R@Asurada-Nvidia>
X-ClientProxiedBy: SN4PR0501CA0021.namprd05.prod.outlook.com
 (2603:10b6:803:40::34) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SA1PR12MB9246:EE_
X-MS-Office365-Filtering-Correlation-Id: c963f90c-52f9-428a-2dd1-08dc5ee8f3dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kNKM+t9NE0Pml2in/4lHZFU6YVKYqLe2RioKaWdR+Vf1/vhermZ1QJ6/tVTP?=
 =?us-ascii?Q?7EU80OYSEEXTmjxmBcQ77EIOcglPP1Lfbq0oNJ26B/d7ci19xJ36oB71hKbD?=
 =?us-ascii?Q?x7SEPrXMIDrYcqfMQpv/LIfOjJZeuCosV+dPdiPPNjPBLCg29SvJ/3xgwvIe?=
 =?us-ascii?Q?M1cbd/69EtAJAKzKnQFKAmVyKT56AVKvtD38B+e2wBWGvN8bI1mErQ1qOXVv?=
 =?us-ascii?Q?P5R+jnQ1szpRMha9kq3skaDZWsbwvrf8may7YSKLnDWRiZdEtSxQ8Fju1kOc?=
 =?us-ascii?Q?oHZ+gv6X+eOIlP42mevuLQukCc7Wt8sERGFEXwfoAYQW8qC8VV7/7odCUnD8?=
 =?us-ascii?Q?VWzw9X5YO+jAjWdc3NUdTCQ+euzhqURy6yWontdpydjxzxv9Yh1Yl2Kbn/GM?=
 =?us-ascii?Q?XTxRTuMOFKCriGCHoZT9G7y3J/y5zJf41j8Su2cQGJiuZD7RXtlqN9rjPdOd?=
 =?us-ascii?Q?8zKFonlyJJaOFGg39wI9xtr1dAc5KuxtX33PgQAoRdoj+Gi7sAWN2cJO5g+j?=
 =?us-ascii?Q?Pd0nT+nR1CtMcC+yCFhfiM776z2TKXLw/cvuhbfOH/8Cu6PiShYiCKF2keQF?=
 =?us-ascii?Q?Uo0j/G4+D98698vBX43GslJyYsg9ThQgNxjvEuykZiRrpNA+AmGlQ07EOAEZ?=
 =?us-ascii?Q?R6g1Qb9zBjo8Hv9+/dproEo1djUQVatEOjFz253t/9WRYqE4kmGcXv4CdZk5?=
 =?us-ascii?Q?FTEXmI+ByuJ+BYDZOR0QxnlKYpVaB5uT76XOdKVnf7Y9NFFPSUQm0sqF8Pah?=
 =?us-ascii?Q?u+Am0dD3ZUwBoIHxMMqlVSrmYTHxwp2KfhiKRlHZteut3anTFQbfmOQ0imfQ?=
 =?us-ascii?Q?Sp3D4zhJAJRsoWMGHXn4mvSxXqUheqiAXWT9e98xpsV58Lq+abWVxD15PBml?=
 =?us-ascii?Q?ZBBC1V5sXi65fEcL3k9XJK2dzBtDq95T+CWfLL18QWsI5DHSs2dX1n6LVwXl?=
 =?us-ascii?Q?RGCRBXwp2uu/wrkJMYyEPPBwZ9t+WbdgGgkWwUpPKBt41b7TctqQwHgFu4Lc?=
 =?us-ascii?Q?lGWbhR0DXFoWHj495W9ipz4szK91gKR+RBbPws+v4Z2TD3+dreihYl9hhpaU?=
 =?us-ascii?Q?8X4lrZxAjnKcByD4lxOCbUZsuKwra7J5fY8KUPOaH221L1e5CDCB/BJdE047?=
 =?us-ascii?Q?WvfpS46OcfHWB+dsU/rRz0ORI0ugraHDmqZoPjRQtycV8CKQ4125jfPCS0Is?=
 =?us-ascii?Q?GWWw+/yxteS3xEVZnV672fL3I06+n/W/qJCkKp0XxvRxUKywGqipRC5kigxq?=
 =?us-ascii?Q?ngKq6H3eHTZ1cfHY8uyvoJMjA958U54AJvor0tQLnA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?H2og/3lAhkNGSxcAt/JPRi8tNppnFiz+SFinxrKufjrcTWeAZfxgPsvTmYkq?=
 =?us-ascii?Q?iXUxZV66M3R/GAaLiJfeCJeCmSE96EyYYojri13T3j70a/hdmuohBkJsugD/?=
 =?us-ascii?Q?1Qht5X3IqPCe4pEeO0O5FTLj5rwQFOZT9J+SZHpHPkOyKZpCs55FBO0LVScm?=
 =?us-ascii?Q?fai2hqBFRbLDVEtMp/UUbqu54z44KZg12f2zET+Rl8izFT61t40nbrxZbSsN?=
 =?us-ascii?Q?IGJQW+3267UgI77BPs26NDwcVAqT+wxKea374QHpos7d0ivmJV5aY2LrDVba?=
 =?us-ascii?Q?lUXlhJri4fyJTYgi+Uv8fE9EUEqzBYzGZImfxj/JfIuJXz2SS8j0oPLa/n8v?=
 =?us-ascii?Q?SJT4RwSTJo7t2ngCaGT+YlCJZD3w2I8zHoHdTwpyr0LPvUrfftDFIRn11Xa/?=
 =?us-ascii?Q?mVctkJTYlWI5Bkc6zEVbqHLlL+wj6LRAL56Dyp+QevzOnn1MGKbr5E7aI/Kw?=
 =?us-ascii?Q?JKl8YqD6oDd6MnY2+lH6t4n4dcjeiP8wvjajRbDnepxobQ0tFI6P6B9p/9Ak?=
 =?us-ascii?Q?tIjwU9tXYS100kZyzDXKKGUQ2f33Xa1s9Ag+TxavUhIqHZKMA2+GBjZzmcOK?=
 =?us-ascii?Q?JPG4SqCN1K089H08ApfsPxxsqldQIwiVW2WXvN3xBM7p16EmSTbT1gNIADeT?=
 =?us-ascii?Q?FGCtXAUoMOYRc4RcHzceGvuwDRsvLMsXCAHuaHshXz98BLtlC0v9IxzW68kR?=
 =?us-ascii?Q?OeVv+ORiUpm9Eo5csnsNPb1DVRhGP6WSqtlgGlK775/T1mYheMwUSyrZgYd4?=
 =?us-ascii?Q?rIb1INb7JZ/qIm1a+1bRpNvfBWixb8zNDR/SImU++0rqYK42gnU3/UPHcAFH?=
 =?us-ascii?Q?8aurqGRUmIvL+sdWTPIh+Y8guFC+Xq0Jpc68bNHZ6tZPc1CbrmjVz2Zi1mfD?=
 =?us-ascii?Q?wbN59QfHIRiGbBz4nkPuE8zJSyqvuTwEAEsEJ1+k92hABmyq8rksH52hYAPY?=
 =?us-ascii?Q?/WwdIVFL1RXfEwqhKix85+ZoEF0QPX4mPhIW3tFY0QC8g3tX7efdyKmvp5+e?=
 =?us-ascii?Q?Tc69QHTCUDDKvH0bLUfm1GHGCBh8AID466eOUBjaR7/ROA700iZy7qUk89//?=
 =?us-ascii?Q?ucpChiBATsf38QqK5EudciHiQoQmB+ZJPcup4FBlUncuiaandpmxDaNdEEyO?=
 =?us-ascii?Q?jVB9xZQDo8I548uVm4B5wbPLT9PsAzMkMnasYMctlEarW/vzwhjiFktbqsqR?=
 =?us-ascii?Q?zvBVf512hqFNKETkLV34mT8kPy73OMr96fWOem8OND7OkRQOvyWC6PTo2HVW?=
 =?us-ascii?Q?PeRtTdn1k3x3gzCLKNKbE74d3rpo60q67xXNTu8a+/Cs0gcghn6LdZWal4GK?=
 =?us-ascii?Q?R61uhqRBjayYSe05klAjWbN3lhmrNreT5vAuc8dHFhvnKuEPURGH3/EeHEsf?=
 =?us-ascii?Q?EdcM4mrLya9FTU1BdIV9NFxcHa6w9hxl8imVKrAgSepLDVY4SzmyYaWGzgBm?=
 =?us-ascii?Q?nS604n4tftpmYmikk9qNirnPksivYalYBFm1nFPA5OXOC7G0Spo1F8LHsBKQ?=
 =?us-ascii?Q?3XWLbLXTW3LYrF1mdsmy9/Wkq2qzOtiWrwHZYGWt69Jm9xpk+BhjoJsmhSMM?=
 =?us-ascii?Q?3AYMaSzoOh+E5gDoZzqWkt6ETumVjosIDBUb+j4Q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c963f90c-52f9-428a-2dd1-08dc5ee8f3dd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 14:16:19.8659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3yQfnW76vQuS3uDioGLdZAYz7x1KLaOD4+H7D9RUsUa3DQV1fE8NCoelV0uHAlu6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9246

On Wed, Apr 17, 2024 at 01:09:40AM -0700, Nicolin Chen wrote:
> On Tue, Apr 16, 2024 at 04:28:20PM -0300, Jason Gunthorpe wrote:
> > Add tests for some of the more common STE update operations that we expect
> > to see, as well as some artificial STE updates to test the edges of
> > arm_smmu_write_entry. These also serve as a record of which common
> > operation is expected to be hitless, and how many syncs they require.
> > 
> > arm_smmu_write_entry implements a generic algorithm that updates an STE/CD
> > to any other abritrary STE/CD configuration. The update requires a
> > sequence of write+sync operations with some invariants that must be held
> > true after each sync. arm_smmu_write_entry lends itself well to
> > unit-testing since the function's interaction with the STE/CD is already
> > abstracted by input callbacks that we can hook to introspect into the
> > sequence of operations. We can use these hooks to guarantee that
> > invariants are held throughout the entire update operation.
> > 
> > Link: https://lore.kernel.org/r/20240106083617.1173871-3-mshavit@google.com
> > Signed-off-by: Michael Shavit <mshavit@google.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/Kconfig                         |  12 +-
> >  drivers/iommu/arm/arm-smmu-v3/Makefile        |   2 +
> >  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   6 +-
> >  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 467 ++++++++++++++++++
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  36 +-
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  30 ++
>  
> > +config ARM_SMMU_V3_KUNIT_TEST
> > +	tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
> > +	depends on KUNIT
> > +	default KUNIT_ALL_TESTS
> > +	help
> > +	  Enable this option to unit-test arm-smmu-v3 driver functions.
> > +
> > +	  If unsure, say N.
> 
> Forgot that my SVA sanity doesn't cover this patch. And it looks
> like some problems here when building it with "=m":
> 
> ERROR: modpost: missing MODULE_LICENSE() in drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.o
> ERROR: modpost: "arm_smmu_make_cdtable_ste" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
> ERROR: modpost: "arm_smmu_make_bypass_ste" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
> ERROR: modpost: "arm_smmu_make_abort_ste" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
> ERROR: modpost: "arm_smmu_make_s2_domain_ste" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
> ERROR: modpost: "arm_smmu_get_ste_used" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
> ERROR: modpost: "arm_smmu_write_entry" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
> 
> Likely needs MODULE_LICENSE and some EXPORT_SYMBOLs.

Oh! The kbuild never tested this kconfig combination...

I think just this? Michael?

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index d03c729c4142dc..7b6a4e244e99cf 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -411,7 +411,7 @@ config ARM_SMMU_V3_SVA
 	  and PRI.
 
 config ARM_SMMU_V3_KUNIT_TEST
-	tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
+	bool "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
 	help
diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index 014a997753a8a2..0b97054b3929b7 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -2,6 +2,5 @@
 obj-$(CONFIG_ARM_SMMU_V3) += arm_smmu_v3.o
 arm_smmu_v3-objs-y += arm-smmu-v3.o
 arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
+arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_KUNIT_TEST) += arm-smmu-v3-test.o
 arm_smmu_v3-objs := $(arm_smmu_v3-objs-y)
-
-obj-$(CONFIG_ARM_SMMU_V3_KUNIT_TEST) += arm-smmu-v3-test.o


Jason

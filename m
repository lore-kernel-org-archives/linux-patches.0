Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2047.outbound.protection.outlook.com [40.107.102.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212CE1487E2;
	Wed, 17 Apr 2024 16:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713370419; cv=fail; b=FcyEN01PdW/yeYFe6aayrc5uae9sJc6wlh1wJjGPjv5kDt2+QP0VQlYvH8DpAYfw/fSWZCu3Mw4XvP1s9O33W1IPufDqvgynWuGWQMtTNwVAeLANaagqHzBjvoGc/nPWhaCegSKvlOKKMUNsbHvEVLynXjIq5466hsONRwW32J4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713370419; c=relaxed/simple;
	bh=wdwfBPJr9tIQRvN4/2H1U1DsixbtKJtD4n8noJNJxLU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Icc0+0Fts9d3QF8V7eU5qQdNCGzmTLQDW/LrMfZh4jzziQuKTspJs40+TDv9D/hLAqJTCY40Tes/6qZKKW4S7bm4dTYIOhNvQNx0e27Wz9BGPZqYWtNA1e5s568PN4bRz50v4eQYR5nfXmmawQm1gpSM4PXMD0B0k1Dx7d+m2Gk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pbc0zjH8; arc=fail smtp.client-ip=40.107.102.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pbc0zjH8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jqE8ezAv7YsFeoeD9GwKzXUupLidwJW6GNi9GgFOZhQgk1WIvzHWr9lBe1EjtperPT1KWdN/dK0aEDxxhfrComUAcTvl7bu5AQpDiTDCTrckDjMVreQBXGq8g2yt00chTRoj9Sd0Od1Ctop0O6syQIp6jE41JJhPxt4bpNLNuQEflo9tWQsOHf5Qvlr06EYjEy1OModmGg2WdsC+U5J+7xXiX7bVppt/sT0FokFO579dLR+6oSfQW18bJuDM28uBjYF/pF9Rd215ss3dj+3GBdtqLl6GLndQfugQJNgCbH7gL8sQ6XxmzpN57GxusGEEY3UuSglZMiZCjGQgevfOTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=St/uvuWkDdnGfEVKIptWtYT1Gq1F4i9FPERF2mT54YM=;
 b=XHUGVyaMXsLBcIjY6eeyQGCpJ/HXdb2SdhJFSJM2sYhqTsLYWI6ZAjz8a49fxrIti1NWFFOWlRd6yDu15wq/e04FsiSwqDTwUwAndAXsljzruBKgH8L/bsimfFDeyCBs92tXuByDZ78InMVLui7MvdRh3UAoCEN0EN69TuJLvEwEqfq7Gby2lbzSBHfeHdk6CpDXUbiUwrW2pnYjG9N+QSL6U7CGrp2vbCnrXwGsUdIlO+4OdK5FXv41m5f9/AHGmwbc3H3MU6MDQ+7t8KrAljahzqzDLtMckC4860iAKkwk51LZdrFLMvQ4sVH9p8esRHVkqWndutMLdr9fUKkVGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=St/uvuWkDdnGfEVKIptWtYT1Gq1F4i9FPERF2mT54YM=;
 b=pbc0zjH8RnWgAk0CI0k1CyFD/EQfoC4dJMyN8LsTv73PwX3Y9RPqvfEP1L378b109i5+bX4jI8rhBYzlvWmtmlQxto2ag9xc+0UzTfDIc5sERYAYxiOiw3iDOImDMpeAVErWV7eSn++4Sc+U7S6nTDy81i83lBsVI5Cw9weSwFAe6JAq3TsoldfRGc4A73s0TFP6zr4Elhb6C/e18zuNAHIYkkFq453h9XDlDByNofz+gBwvmW/UaFFuMyhTSY46+kRFmmjOSKCNjF/MmTEYJGy7cGyLwiagJVa7/dPnlgx+/qFXYaNtDk0IrZkRlZYdAfSsU2EAi8gP3qPVjtSxjA==
Received: from BYAPR21CA0028.namprd21.prod.outlook.com (2603:10b6:a03:114::38)
 by SN7PR12MB6692.namprd12.prod.outlook.com (2603:10b6:806:270::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Wed, 17 Apr
 2024 16:13:32 +0000
Received: from MWH0EPF000989E7.namprd02.prod.outlook.com
 (2603:10b6:a03:114:cafe::35) by BYAPR21CA0028.outlook.office365.com
 (2603:10b6:a03:114::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.11 via Frontend
 Transport; Wed, 17 Apr 2024 16:13:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000989E7.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.22 via Frontend Transport; Wed, 17 Apr 2024 16:13:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 17 Apr
 2024 09:13:14 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 17 Apr
 2024 09:13:13 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 17 Apr 2024 09:13:13 -0700
Date: Wed, 17 Apr 2024 09:13:11 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Michael Shavit <mshavit@google.com>, <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, <linux-arm-kernel@lists.infradead.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>, Eric Auger
	<eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>, Moritz Fischer
	<moritzf@google.com>, <patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v7 9/9] iommu/arm-smmu-v3: Add unit tests for
 arm_smmu_write_entry
Message-ID: <Zh/1F6nqvDOEbSfi@Asurada-Nvidia>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <9-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zh+DxJoAMIXy9O/R@Asurada-Nvidia>
 <20240417141618.GS3637727@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240417141618.GS3637727@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E7:EE_|SN7PR12MB6692:EE_
X-MS-Office365-Filtering-Correlation-Id: cc1699bc-ff7f-4331-829c-08dc5ef953a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ezAvgT6nrn5Nng6UvBfqw9YYHB4frF1J8L277ulpmPauvJTDgD5JSao+QQbsV8sArbTDDc+QciROiYEDgUEf+s0oL4SEnckpeiM1qtsC7JutFsb+IAFQp5RQCmAMupoMM+5uc/AvjJY9QpZa5Pao+OS3eXZl9dghmFENpkDK2uKnMeqPTfcsprS2QuldNIUpBqa3L6fDLQkHD8BRsq7z0r4z7n+evZjXt61PqgouRuFHiBCPADO+mdFSeGS3fZn7eENcO5kI8yIbJoAApG1v6BSe0bqH2zgVUbwMIWkh0FV5WK20ayY4zXL+8owolYvJnCWGF624lo2vJ0VMjTDVSWUZmm5XYTKeFhxqc+a9ljGotHWLeQ102M0Z79HQChc6yfQdtlnREwd0ft6F5amnXzKATuTorgkeWrWDQjycdgc+UoGAuZVXKF2q2njdHWk/E+XcY/xwwarhlUbwRCzn+S1hAR6WJrwH/tTTy13lcR/2DEtI6O7+l24MRVcD31F/i19F8FXN6PnfrOlIFJ+xen175IMUN979QackRVhffHJUkX1adOyrIqR61qVA8eRs9ncqYmwp4RY+INWcYJFywdpbDhp2j4I/zu4HaZHheNGSu1AorsBj4LGL30oRUZc2zhtchJBzlwAu+WC4iAdGqkqerojw1I7/9MYfrqiCxG97TWSDYpyRoiWN8Q69ryeRACZ17yLwNEqu+VKJQoNSO9XjrvsRHjMJTwDq0JMFu6jtoL/MF2we+GUAxVTbqRT1
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(7416005)(376005)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 16:13:32.1831
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc1699bc-ff7f-4331-829c-08dc5ef953a4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6692

On Wed, Apr 17, 2024 at 11:16:18AM -0300, Jason Gunthorpe wrote:
> On Wed, Apr 17, 2024 at 01:09:40AM -0700, Nicolin Chen wrote:
> > On Tue, Apr 16, 2024 at 04:28:20PM -0300, Jason Gunthorpe wrote:
> > > Add tests for some of the more common STE update operations that we expect
> > > to see, as well as some artificial STE updates to test the edges of
> > > arm_smmu_write_entry. These also serve as a record of which common
> > > operation is expected to be hitless, and how many syncs they require.
> > > 
> > > arm_smmu_write_entry implements a generic algorithm that updates an STE/CD
> > > to any other abritrary STE/CD configuration. The update requires a
> > > sequence of write+sync operations with some invariants that must be held
> > > true after each sync. arm_smmu_write_entry lends itself well to
> > > unit-testing since the function's interaction with the STE/CD is already
> > > abstracted by input callbacks that we can hook to introspect into the
> > > sequence of operations. We can use these hooks to guarantee that
> > > invariants are held throughout the entire update operation.
> > > 
> > > Link: https://lore.kernel.org/r/20240106083617.1173871-3-mshavit@google.com
> > > Signed-off-by: Michael Shavit <mshavit@google.com>
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > ---
> > >  drivers/iommu/Kconfig                         |  12 +-
> > >  drivers/iommu/arm/arm-smmu-v3/Makefile        |   2 +
> > >  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   6 +-
> > >  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 467 ++++++++++++++++++
> > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  36 +-
> > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  30 ++
> >  
> > > +config ARM_SMMU_V3_KUNIT_TEST
> > > +	tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
> > > +	depends on KUNIT
> > > +	default KUNIT_ALL_TESTS
> > > +	help
> > > +	  Enable this option to unit-test arm-smmu-v3 driver functions.
> > > +
> > > +	  If unsure, say N.
> > 
> > Forgot that my SVA sanity doesn't cover this patch. And it looks
> > like some problems here when building it with "=m":
> > 
> > ERROR: modpost: missing MODULE_LICENSE() in drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.o
> > ERROR: modpost: "arm_smmu_make_cdtable_ste" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
> > ERROR: modpost: "arm_smmu_make_bypass_ste" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
> > ERROR: modpost: "arm_smmu_make_abort_ste" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
> > ERROR: modpost: "arm_smmu_make_s2_domain_ste" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
> > ERROR: modpost: "arm_smmu_get_ste_used" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
> > ERROR: modpost: "arm_smmu_write_entry" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
> > 
> > Likely needs MODULE_LICENSE and some EXPORT_SYMBOLs.
> 
> Oh! The kbuild never tested this kconfig combination...
> 
> I think just this? Michael?

Verified with the following change.

Thanks
Nicolin

> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index d03c729c4142dc..7b6a4e244e99cf 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -411,7 +411,7 @@ config ARM_SMMU_V3_SVA
>  	  and PRI.
>  
>  config ARM_SMMU_V3_KUNIT_TEST
> -	tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
> +	bool "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
>  	depends on KUNIT
>  	default KUNIT_ALL_TESTS
>  	help
> diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
> index 014a997753a8a2..0b97054b3929b7 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/Makefile
> +++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
> @@ -2,6 +2,5 @@
>  obj-$(CONFIG_ARM_SMMU_V3) += arm_smmu_v3.o
>  arm_smmu_v3-objs-y += arm-smmu-v3.o
>  arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
> +arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_KUNIT_TEST) += arm-smmu-v3-test.o
>  arm_smmu_v3-objs := $(arm_smmu_v3-objs-y)
> -
> -obj-$(CONFIG_ARM_SMMU_V3_KUNIT_TEST) += arm-smmu-v3-test.o
> 
> 
> Jason

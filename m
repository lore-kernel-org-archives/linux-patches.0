Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2046.outbound.protection.outlook.com [40.107.96.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBCB6A037;
	Wed, 17 Apr 2024 08:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713341404; cv=fail; b=loLnYa5CLQjzEuZDjZWshdczpMImXyxeVid3SP3ep+yluHGXnuQaVB6oNgl8olwZbqpYOPYk23je0+EHHpM26XEl8Vpf8XoEYG/veeGbltiMigoM5c7Haxg5WAT11MNOqbw3xQgbRONCQrd+BnohTuiBqju1w4WA7LC6zibEcu4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713341404; c=relaxed/simple;
	bh=cGYlcLu8N+FgrVP1RQ4s1Wg9kxcD3ZGYPD4ye0RuSIc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CFLLUIfJp5ExbRkcSf6y5YpEnxSpKDOBbaB7gygruo6fWCFUIahvP96KB506GNxwDr5sEdGFXUqh+7uRNdMXCGxRPovNwXsWO8bev/wwk9y269sjreikZ3KkOPzsydD35kZ5dnmg4BjGmzj3eRIdADUQiDSCbDFzAi9fXq8CLWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cEuXjWm5; arc=fail smtp.client-ip=40.107.96.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cEuXjWm5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yt3F0CY83IplAZI1iNxmw5bRSl1/VnVY5tqHtq3vOAn4IbxMMt7Gi6qpB4ytfE2mflzpEtc5QttzgpzAaX+GEGOzuNKn1KhhVHuROUGTlzNuSJclgAG26gS4TjzOgxHc/02gSLdCMDJdxnoF6HxhrLYRhlPenq8f7PUxSeyDWhg0nvL5zSn6znwIQXbR4BcoB613WSFr2NRaBHoNcN8xQ1v3R0cRjm6pSXMyD7nUkl+cHmlgEIccQDPY0jDRu9QGbxFDlGMSqdc+JfAo8zbNQrRhnSyzSdfldgq7jnl+D9gijI7qe8/gOAokWjE02pWeYkdzNoFB5ratOcjUakRJ1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Me38kvEDYmOXEfesgOSyaiIpG0CWRtXj83wIFwXJ2tw=;
 b=VBBso2y0avjHd428do03qIFbzhTL8BHMRpia29fz3BIuFBcsL/uD83mGAODTJlAORSuIG0sHStE1XheHex5vOcvPpTWmZJ8uA5f/82NWEVVY15T5sEGSil66q5i/z4JGYvv5RhPmMYz+yu4GtHcnIr0seG6Vn6K7h/Qpbg0x+SGnJMNQACgxN1Tdfw1I3oKdHyX6N0BjncCxFvEvrjbJoRdZgn/RFfP4ob5uVcOVqY+MFHeO+o4wajh8sSeN3K5kICa4TEOFpVS3eXwDr6WL2sho0T3vysvarsJWyiskkZVDFzPGnG/8eIZQ+gLr9LyVgeJBGMciM6n9gO1Rj5wnmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Me38kvEDYmOXEfesgOSyaiIpG0CWRtXj83wIFwXJ2tw=;
 b=cEuXjWm50xU+8/dPuVp58S4u2TseWm2FsMbjV6ldirQ6/VxMScip9cVGvRMnFYKA6XW03m8Js9vC76A7t5Bi1LDsDmlcM4qkQ1sF27ESy3LiGBwqn2MVSFbCRI1OMDH7van0qO0QxKrFW6Qyzu0AcalgomDBhz5YhtF3tSODu5iQxuFGinruepPLEjEZnC0pUZVYmFnDt0qESfMCF6cP2nW1k/GJ7WHSP+Wm4IiTEOqKHgTih5/ROD5GHUvtcrJwpDhhWLfNsaMitXllp/cpEbmW3cWaaaujAPdYudRmgGha0QV5XdNscS9hlcfD/C6exi9wIXGMmQEgJEVcIIRp9g==
Received: from MN2PR01CA0060.prod.exchangelabs.com (2603:10b6:208:23f::29) by
 CH3PR12MB8581.namprd12.prod.outlook.com (2603:10b6:610:15d::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.50; Wed, 17 Apr 2024 08:09:55 +0000
Received: from MN1PEPF0000F0DF.namprd04.prod.outlook.com
 (2603:10b6:208:23f:cafe::5c) by MN2PR01CA0060.outlook.office365.com
 (2603:10b6:208:23f::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.23 via Frontend
 Transport; Wed, 17 Apr 2024 08:09:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000F0DF.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.22 via Frontend Transport; Wed, 17 Apr 2024 08:09:55 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 17 Apr
 2024 01:09:42 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 17 Apr
 2024 01:09:42 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Wed, 17 Apr 2024 01:09:41 -0700
Date: Wed, 17 Apr 2024 01:09:40 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>, "Moritz
 Fischer" <mdf@kernel.org>, Moritz Fischer <moritzf@google.com>, Michael
 Shavit <mshavit@google.com>, <patches@lists.linux.dev>, Shameerali Kolothum
 Thodi <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH v7 9/9] iommu/arm-smmu-v3: Add unit tests for
 arm_smmu_write_entry
Message-ID: <Zh+DxJoAMIXy9O/R@Asurada-Nvidia>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <9-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0DF:EE_|CH3PR12MB8581:EE_
X-MS-Office365-Filtering-Correlation-Id: b295993a-5bff-41c6-fb79-08dc5eb5c469
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	m6wQoAxeOcXWb4kUUwZfxvWlfnCPvRmS10kDvcpq0hDuLQ7DCnMd4p42w/CQrgTZ9I5rJmWzwZg55oeTsbiHA/vbhewfoIrWcsNUxGiXADwyKrRBHyZuwWV40+klPYu152WNXxv3+5YW5niO663E0NajCh0V1bGTmEJSWmciGpXQoKeQ6DnMxUeuyRnZToLVSyPqyXknql8Bd2baiGGjKREqDB+GN2EhTe/aLm8Jxz7zCLX42iFoL3374HoySHeyFQ80BrTjnwkxoDyNfLRUsJ49HqwuKbWcZQNQ9i8cDTx01In68O6EUslC9NkcSsVN3Jk4Xc3LEv7GG9wJB4YLo5Wr+dRjbnsTEyipDZJNbfjhLc/ZOMEiJNKV81oMheOUVOS+hW5hdejWCDhq2O6w7m85RpFZdV6O2Mtgy7FHPinhX13xoyHB2SdAXdoAe0ym3Xe0oW6J7bx4//Wdk50wUHOa09Ma7i/dsnXJqhHYbpazw+ZEykfegQhaEVjOIEbVi8BRcPZgIetnQNNH9+n048KHeysm7akOZN7T4ZnyS1xVZLKPi8VDm+rSEEVtv12B720J0BJvCGsCmdX1F3tS3yeTrMtH/muzqmqyBQlioQdkK6EflNedYTDZO6H23xV9Cts3CC4luIsZmXmger0a7JM9gjSff4kDXbJ19/7xy00u874d5CgdlFakg44WAjCQtkcsLvcmgRBMhY6Z7NuROL1h0pa4i84aHqdqVFjVvdPmOMqm1PUM563ect34vss+
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(82310400014)(7416005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 08:09:55.4951
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b295993a-5bff-41c6-fb79-08dc5eb5c469
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0DF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8581

On Tue, Apr 16, 2024 at 04:28:20PM -0300, Jason Gunthorpe wrote:
> Add tests for some of the more common STE update operations that we expect
> to see, as well as some artificial STE updates to test the edges of
> arm_smmu_write_entry. These also serve as a record of which common
> operation is expected to be hitless, and how many syncs they require.
> 
> arm_smmu_write_entry implements a generic algorithm that updates an STE/CD
> to any other abritrary STE/CD configuration. The update requires a
> sequence of write+sync operations with some invariants that must be held
> true after each sync. arm_smmu_write_entry lends itself well to
> unit-testing since the function's interaction with the STE/CD is already
> abstracted by input callbacks that we can hook to introspect into the
> sequence of operations. We can use these hooks to guarantee that
> invariants are held throughout the entire update operation.
> 
> Link: https://lore.kernel.org/r/20240106083617.1173871-3-mshavit@google.com
> Signed-off-by: Michael Shavit <mshavit@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/Kconfig                         |  12 +-
>  drivers/iommu/arm/arm-smmu-v3/Makefile        |   2 +
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |   6 +-
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 467 ++++++++++++++++++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  36 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  30 ++
 
> +config ARM_SMMU_V3_KUNIT_TEST
> +	tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
> +	depends on KUNIT
> +	default KUNIT_ALL_TESTS
> +	help
> +	  Enable this option to unit-test arm-smmu-v3 driver functions.
> +
> +	  If unsure, say N.

Forgot that my SVA sanity doesn't cover this patch. And it looks
like some problems here when building it with "=m":

ERROR: modpost: missing MODULE_LICENSE() in drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.o
ERROR: modpost: "arm_smmu_make_cdtable_ste" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
ERROR: modpost: "arm_smmu_make_bypass_ste" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
ERROR: modpost: "arm_smmu_make_abort_ste" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
ERROR: modpost: "arm_smmu_make_s2_domain_ste" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
ERROR: modpost: "arm_smmu_get_ste_used" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!
ERROR: modpost: "arm_smmu_write_entry" [drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.ko] undefined!

Likely needs MODULE_LICENSE and some EXPORT_SYMBOLs.

With built-in '=y' and a MODULE_LICENSE, tests passed:
[   13.244780] KTAP version 1
[   13.247542] 1..1
[   13.249421]     KTAP version 1
[   13.252538]     # Subtest: arm-smmu-v3-kunit-test
[   13.257344]     1..16
[   13.259727]     ok 1 arm_smmu_v3_write_ste_test_bypass_to_abort
[   13.259789]     ok 2 arm_smmu_v3_write_ste_test_abort_to_bypass
[   13.265895]     ok 3 arm_smmu_v3_write_ste_test_cdtable_to_abort
[   13.271988]     ok 4 arm_smmu_v3_write_ste_test_abort_to_cdtable
[   13.278172]     ok 5 arm_smmu_v3_write_ste_test_cdtable_to_bypass
[   13.284353]     ok 6 arm_smmu_v3_write_ste_test_bypass_to_cdtable
[   13.290636]     ok 7 arm_smmu_v3_write_ste_test_cdtable_s1dss_change
[   13.296917]     ok 8 arm_smmu_v3_write_ste_test_s1dssbypass_to_stebypass
[   13.303464]     ok 9 arm_smmu_v3_write_ste_test_stebypass_to_s1dssbypass
[   13.310357]     ok 10 arm_smmu_v3_write_ste_test_s2_to_abort
[   13.317265]     ok 11 arm_smmu_v3_write_ste_test_abort_to_s2
[   13.323104]     ok 12 arm_smmu_v3_write_ste_test_s2_to_bypass
[   13.328937]     ok 13 arm_smmu_v3_write_ste_test_bypass_to_s2
[   13.334861]     ok 14 arm_smmu_v3_write_ste_test_s1_to_s2
[   13.340787]     ok 15 arm_smmu_v3_write_ste_test_s2_to_s1
[   13.346364]     ok 16 arm_smmu_v3_write_ste_test_non_hitless
[   13.351883] # arm-smmu-v3-kunit-test: pass:16 fail:0 skip:0 total:16
[   13.357667] # Totals: pass:16 fail:0 skip:0 total:16
[   13.364163] ok 1 arm-smmu-v3-kunit-test

Once those are fixed,
Tested-by: Nicolin Chen <nicolinc@nvidia.com>

Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DDD11C85;
	Fri, 15 Mar 2024 05:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710480023; cv=fail; b=XDmjdZRch9pdqoeUgDXUDmuwwOXoMvvJOOIqYD4Z1EZqKaftnoMfb8YjDGYYVemI7P5Vm8ceIkos2hY+WXGk/rxZIfnPzq5mzH1umCr/EUNUxJhiR+7xvaAth+O7ZIXUL6VqG4qSBqFVtJa2j//9C1T0uqXubra7mkIqCJaDLZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710480023; c=relaxed/simple;
	bh=B1jKHJKdxDP4RbTjOJj+pN+nA4lgakJnteH2JF9WYXw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZEfd2YRwQbzLwPyOgDXm/LkU8CXERHj7nPDXw9stZ+L0eaFI+6OwBgAsvUGDUGHhaoxEf3zYEY2ZuBJIomnGiqI/Xi/cFPlb/PQOVH2o+VpFsO9p7QfxSLD0NK8Wl8lBCmlR5HgQwF4O8seJm5sItIBlCM/hE4T4cuOvp3cY/BA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Qxi8c66+; arc=fail smtp.client-ip=40.107.244.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Qxi8c66+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QRFBeeQ6j5p/wp1CCxfdpeL9JvjpPwoONp3fpdW7yHj2blBGx8kjDVEl3zFSxW4Pg5QnDTmu/ZA+TqL+9NDIoVkxarmsUyxOmxL4qafCzxbV38SmJ9lt3/Mtl7xaEOgGFcvCGrVM/Fb5TV7FNbR60GzlQxI45V5J2oJ0MBSypfEBpwxAvRmIoX4qdHP1UMl1k4lIfA5a/xeUd9C+H8MP0plBTHBkwiODaFodyELuUFz663xdL9Y/+Sx8lIS4dPgTrlFe2EnOfjwGw3k1VY+J6xA33nJAJo3eKUDnj4JGxwK7URR8C2QRd6fQ+Ez4JXcYrCDkcJ7VaWwylF83L7yONA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bq1rD2iMlRvVpv1GKapRUKu8XwJRpMUDE/3NtCdLHDY=;
 b=EWXLwkvmOg8Gy7g1uQwitI2VK78GuF/F1XpMtlz/u+GfZgdLyplcBQhgA52i9tVJiLBaro37KOrNtwDYnVJrd5kdY2WCALKRKH45s0GXL1Vg9YUtxdr/80cSCndBWgM3hdexerbBEFFi1BAZFg+7DxU9VKfwnfpdOonV91YTPjxs93mucHBXH9a+08m6B+BNVaKuzlwjJOkPd1MGLSzHs37M+nfdTiMRK5RyGtF9nfPo9oBaFPjhG1bb6EwLEo00Va3/qWOmdnyIq8O7CecyB2RePrR930ERzIwZYMkCwka+D7LqhfbcCS/q7KFKGiYe1Pzgl6/97158i5wZs1KZZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bq1rD2iMlRvVpv1GKapRUKu8XwJRpMUDE/3NtCdLHDY=;
 b=Qxi8c66+rVMpMegOL2IlS2iKujXDCXziZQOlJ+d+9/PRumlww04XImEvwSfWtSJvZGMoqDPGDfxTuPegT1HCRqmfqTOaW64VrPMv9Ma0r/8MRaeHYdSvyTMB9SrbAVBicAumGLLolxLTk5ECx4xISD7FAaqzj0HqfpaE8DhnN5jxD7ehzvpxRwAF7hpI9AkVCkIogbXNQqkXkI+qi8WfdWXejwhG6f20+oeQjAMTc2uLzgKZtR7Mk5NCytQT3RhU+trFBrVMEHKP7YCMua/riLAtlQVQAjyqvq5J3S5NLyCt59Ljbau5LiTfahU8UICAGuLf7FObXOY/XEYazvPFAg==
Received: from MW4PR04CA0161.namprd04.prod.outlook.com (2603:10b6:303:85::16)
 by LV8PR12MB9261.namprd12.prod.outlook.com (2603:10b6:408:1ed::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.22; Fri, 15 Mar
 2024 05:20:18 +0000
Received: from MWH0EPF000A672E.namprd04.prod.outlook.com
 (2603:10b6:303:85:cafe::fa) by MW4PR04CA0161.outlook.office365.com
 (2603:10b6:303:85::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.20 via Frontend
 Transport; Fri, 15 Mar 2024 05:20:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MWH0EPF000A672E.mail.protection.outlook.com (10.167.249.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.12 via Frontend Transport; Fri, 15 Mar 2024 05:20:17 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Mar
 2024 22:20:05 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Thu, 14 Mar
 2024 22:20:04 -0700
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12 via Frontend
 Transport; Thu, 14 Mar 2024 22:20:02 -0700
Date: Thu, 14 Mar 2024 22:20:00 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Michael Shavit <mshavit@google.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, <patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 04/27] iommu/arm-smmu-v3: Add an ops indirection to
 the STE code
Message-ID: <ZfPagJTjb8OSdTde@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <4-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZfPNGPhdhcj6Mq3V@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZfPNGPhdhcj6Mq3V@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672E:EE_|LV8PR12MB9261:EE_
X-MS-Office365-Filtering-Correlation-Id: b1f0f7f6-897e-4411-e0ae-08dc44af9a40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RXaZhCuh/XrnxPLy3FBSDCklu/eTMPBoSj4XeEM2GYqw0bsnajSV2jMXOWY2rsd6wMgnpRrJ5GvZD/OUIabgdOa5FL7IaqEXUnlJzDAaOc/+/FmQSJXV0P7chJUpW+K1sttyEH8ZB6EnS6H2nzHnP4Uy4BSyYWamLcvAOGQCPcABbZsX7nMnS0oEbg8hTc1hrM7oG2EQMeJQXbjmZfcws6WdWLWLW/pVdo2Xm32cMjn8qpEaNteDNBftSKgxVyZyf7t0M11WE+Gv/7EGeY6E0goejCCnGoeIKHzUj6Xfi3A7CnbBgkqn0xLZugEmkHRft+HBOIG/pYDCj58apepSE0kwKtR7CJwlG11GOco5HXh6m1/NdrbHBGuspgJ4NGtqgapTwhNYuTt6e00rdRFV/FCheGOVcgspoig6kqXlZehgbKchl2TgozmvGV96jKhRFDFjMNhXzHz1wLCOhhfbo/+wS15gaHm5QcP9Z1s1Casfcv0JEu5Kd59GKRJmdpsEhe/xARjL1DbXPq0Yj2QV/oQ+gnSblLj+295R6E6CvFOPRcxX5d5Aeqgyb0BDjr/F+dGozzeF4vtJ9Yx9CHfVSmuAZ3ExmrwoFZqJGpb8XMSBXipxR26pBNB/+IT819aTe42pok7vSk6tD4stFL5XurSuBWH2zHKhZm/W/3eFs903flhlXN1Sdqlfdy6AePNGGd4JaG+w3faAW0TV3R3p8WS5IlqbIncDhP96oSGeVWKjXyoJeTcS/E2ZZaIC0uan
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(1800799015)(7416005)(82310400014)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2024 05:20:17.6270
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1f0f7f6-897e-4411-e0ae-08dc44af9a40
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9261

On Thu, Mar 14, 2024 at 09:23:00PM -0700, Nicolin Chen wrote:
> Hi Michael/Jason,
> 
> On Mon, Mar 04, 2024 at 07:43:52PM -0400, Jason Gunthorpe wrote:
> > Prepare to put the CD code into the same mechanism. Add an ops indirection
> > around all the STE specific code and make the worker functions independent
> > of the entry content being processed.
> > 
> > get_used and sync ops are provided to hook the correct code.
> > 
> > Signed-off-by: Michael Shavit <mshavit@google.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

With the following trivial comments being sent previously, I've
also retested this version with SVA cases covering two different
S1DSS configurations.

This seems to be the only patch not tagged with Tested-by. So,

Tested-by: Nicolin Chen <nicolinc@nvidia.com>

Thanks
Nicolin

> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 172 ++++++++++++--------
> >  1 file changed, 104 insertions(+), 68 deletions(-)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index c60b067c1f553e..b7f947e36f596f 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -48,8 +48,20 @@ enum arm_smmu_msi_index {
> >  	ARM_SMMU_MAX_MSIS,
> >  };
> >  
> > -static void arm_smmu_sync_ste_for_sid(struct arm_smmu_device *smmu,
> > -				      ioasid_t sid);
> > +struct arm_smmu_entry_writer_ops;
> > +struct arm_smmu_entry_writer {
> > +	const struct arm_smmu_entry_writer_ops *ops;
> > +	struct arm_smmu_master *master;
> > +};
> > +
> > +struct arm_smmu_entry_writer_ops {
> > +	unsigned int num_entry_qwords;
> 
> I vaguely remember some related discussion, yet can't find it
> out. So sorry for questioning this, if it's already discussed.
> Aren't CD and STE having the same num_entry_qwords in terms of
> their values? Feels like we can just use NUM_ENTRY_QWORDS?
> 
> > +	__le64 v_bit;
> > +	void (*get_used)(const __le64 *entry, __le64 *used);
> > +	void (*sync)(struct arm_smmu_entry_writer *writer);
> > +};
> > +
> > +#define NUM_ENTRY_QWORDS (sizeof(struct arm_smmu_ste) / sizeof(u64))
> 
> And this seems to be just a fixed "8"? Since both are defined
> straightforwardly:
> 
> struct arm_smmu_ste {
> 	__le64 data[8];
> };
> ...
> struct arm_smmu_cd {
> 	__le64 data[8];
> };
> 
> Might be a bit nitpicking, yet maybe the other way around?
> 
> #define NUM_ENTRY_QWORDS 8
> ...
> struct arm_smmu_ste {
> 	__le64 data[NUM_ENTRY_QWORDS];
> };
> ...
> struct arm_smmu_cd {
> 	__le64 data[NUM_ENTRY_QWORDS];
> };
> 
> Thanks
> Nicolin

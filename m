Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2058.outbound.protection.outlook.com [40.107.223.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31E5146A67;
	Mon, 13 May 2024 07:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715584309; cv=fail; b=YYe/O0ytyuci+ZCiPO3N6FYyzQ9FUSUG2sfXmFAOaLbi/7h0i87obIwC7CtFvo3i/RPxtvGbz769xQPVIesKZDHfVxDyCc2sXNG2pnxUJ9QpRvs2WpB2sF7cRdST7m3vB7JtISIZtiOpukfXUXqcySexozYbVk3USwutuUTCUdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715584309; c=relaxed/simple;
	bh=pPaxg1HaUWBfU9JWTn7jKuUo4XqefBsKww0sB859da8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t5ErYWWcVJv7ShHPoZuziyZaVMAQTeAEga2LUS0GOSDkas59x9FMZrRoc2wvK2jB8wcZcxqZ6qEpPI5G55ikgqmj0NHZoAxwJ7dF19zwu76KM1rM5EfsMHO4Cho89vj34C7bzKg0PIt6L8oRCRkiuFooWOk0IRjrUNO45m6Qfk8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PcAqOnD6; arc=fail smtp.client-ip=40.107.223.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PcAqOnD6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hh49cje+LP5P1mRn/tDjB/nI4X24g9fV3gwdC4IZqEi/xAfDEm7ZJFHazQRT1Ra0RF4zdJg3wvfe+tZ6PTPRP9NCClLzW/sT4LS418E4gaX0wkesxZQOfeQNM1bFVX6xyHi0iCb++CWpoBl6+uaDtec6c4OltQ16BJTT7hVgGekOf/OvdtNrBI5OEcSLF9iYfWesQ7W45NEcJyIkp4GaTcP9n8a4d+K8j8TXo6oLPpaUJbEbktfwOywd0enySUbkwtx3fTF/NPKG+sQwOSYAqKlUFod9KbKTn+hbz05f5QWKSokKpKtblaf+BRJxtPsVzsjKiP3DjJJwXxy7cDgSTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/mIBB5OnX4Ke6EhwlPHrZYzqVhbmPswdFr206cp+ktI=;
 b=IbzKmyb8fTTBFtKV2qfCfJo6Z4E2z4T+ODxQdInHhZLiqLZodAHC2f92njmxkFKgxaFfVq9gpdZIiOtqzmYHZA9srkvH95vUD/qQY4D115hK/6CxA1ijw5KVDVyOZ7hQbhKAZ2h2/qZf9l8hJiHvXwtysGwbKphQzeDhR/SHFkg4pJK5TQ91Wsj4vEEiCDm4ACwLojqjJyiXbCC9wqrciR+KTSbT0OFv3IIuzmzfTNli1ivJJj0YXrb7Me9+v9sl2PW67e1EwgxizNZAevQYj71oKSMgruutahQBmxfhr5aEkWzHrvz9JeQYJreVr8+LoFBmURzURI4ID95+ph1V+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/mIBB5OnX4Ke6EhwlPHrZYzqVhbmPswdFr206cp+ktI=;
 b=PcAqOnD6+TQAZ9kYoahgWGJSEsfWXPLvMukHxa72oxPHcltgynmxgZFUpEF9gb9cYG2ef9LBKZ5qfYX3SVNmiKFDbOZbNxJmAQRqkI7PgNgPEbXBEUIYW03/956WZnC2Xa3MurFvN7BkMWRQ14NsH1LudZNhkmM/elXPnINdXWE+qZDrzKdraqD9V8/HFFkconNC2aQcl/RokJC029qLfhpU0LbXCBVauDi6DhU5k9U4jIMJngjArkJWeWSTmlDxIOLm1QkmKXWsTOZlgOY4OrZpvi4xWgCTehx2fJqmfy1RXV9+Qc2c4XVAVoopqb4xq61enanQzKnlcu3b9PDkpQ==
Received: from BL1PR13CA0234.namprd13.prod.outlook.com (2603:10b6:208:2bf::29)
 by PH0PR12MB8127.namprd12.prod.outlook.com (2603:10b6:510:292::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 07:11:45 +0000
Received: from BL6PEPF00020E60.namprd04.prod.outlook.com
 (2603:10b6:208:2bf:cafe::79) by BL1PR13CA0234.outlook.office365.com
 (2603:10b6:208:2bf::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.22 via Frontend
 Transport; Mon, 13 May 2024 07:11:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BL6PEPF00020E60.mail.protection.outlook.com (10.167.249.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Mon, 13 May 2024 07:11:44 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 13 May
 2024 00:11:35 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 13 May 2024 00:11:34 -0700
Received: from nvidia.com (10.127.8.10) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 13 May 2024 00:11:32 -0700
Date: Mon, 13 May 2024 00:11:28 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 11/14] iommu/arm-smmu-v3: Allow IDENTITY/BLOCKED to be
 set while PASID is used
Message-ID: <ZkG9INGfwNcnubyI@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <11-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <11-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E60:EE_|PH0PR12MB8127:EE_
X-MS-Office365-Filtering-Correlation-Id: ecc9dd36-bcf5-4ff3-caa9-08dc731bf271
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|7416005|1800799015|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JnYDkChQ9FqCqqXXaVrfSHH3DSBTvUaQiqE5eMZ72IvwkOmoP24LKO4WR6JY?=
 =?us-ascii?Q?VqYzZq3Icur4df2Xb0U7gYbsPtxNV3bKwddI3x0NvZRecAMoQyh2YKiFGzzK?=
 =?us-ascii?Q?QEkIZvT7bxfI7qIVK07j3FMXZ7kljs0rHPBSEJ7RIIIjlXdpXuW2CnltCfex?=
 =?us-ascii?Q?+FXCTyfcIzYvJTEv2QuJEPB6V2mKl+uP8ZlrNAed0ztM9KOEWBu9t33oBqno?=
 =?us-ascii?Q?WB/GZQhyoBg/oPBNAf7hkuzGuRx+els2EsUFUVjIQb1PJpY8gMyXUYmus1ad?=
 =?us-ascii?Q?1AQ4LqbjOL51T5tN5y2N3RBglXOFS5tvV73tgiBd2RdJWUZzlI2jS8OIWac4?=
 =?us-ascii?Q?gPdGW6ew50Ze1XrUB1gubFQL7dC2WNHzIoPz5IkjhtlfGLVWjn+JXEtH8Ucp?=
 =?us-ascii?Q?+zG5aUm6iusRa/swq4FDwmVT6PEyViKpMxM1FKS0XGAITkww6nHiGSRmyOAO?=
 =?us-ascii?Q?K1jv1Q/nraqOpWQjg3RO0My9YXmh3u6PlOYvsa5t7K1FM+XrjBNn3Sgg9QuF?=
 =?us-ascii?Q?W/aSTCQxjnxTgVNu/svg1r/WEu80a1Yljg2RSyV0G+A6Uk1IGGXkxef/hpiP?=
 =?us-ascii?Q?AibEicqUs2ZYUhWdcnWoUPRmwwmCxAckkD/6OJ/TG8kNx/YL5T80Q+DPyVAp?=
 =?us-ascii?Q?b5GYxNIE7Z98BVH8zbBBaAydCIZai4eWg/S0GPrnMlD0LXpgSmmIbbmt+t2g?=
 =?us-ascii?Q?nuAjGUymMV3/NuFNhbhnvStvxSGcAhRpNiZfpeuMeraKMV0+ayChctX+TMH7?=
 =?us-ascii?Q?bVvbpVDZYmu90hHcA/0PKCmbjy/u9kzqKx7bkbQz9MtAvDwUyiuv+mj8PbwO?=
 =?us-ascii?Q?jDntmhjEHx1Kp+xYrKc4ReBceMf5HFGVcd/eLa54PoI6EyInFcEa3BELOYWK?=
 =?us-ascii?Q?3vshQUf62RU9GygXh+nwVv09E0apBThethZcksYl3Dcwr8vcIFjbXOyaItyr?=
 =?us-ascii?Q?+HmJWLb6ZhELC21GUsX9IrcSHj666dT5h0nTUu161vI56Jmx37oar717FRMF?=
 =?us-ascii?Q?kzJfQyXYqUFZ7Qtsp2n4IuKl+4LXtrO6u1T6SFNf9PQ8q73wd605/hX3NwxF?=
 =?us-ascii?Q?EqdmgNochj6vbjhbRbddlzh2oYhI8UfVRiGTwAbDp6OY9+HlL464ZVDcACfr?=
 =?us-ascii?Q?NtkzQkvLXMP3tYtKUTgwRcZzuMEqzRG8udKkX4SCriuV1E6AxK0n+EHuvR6P?=
 =?us-ascii?Q?MYVhosMmLKWbUpnDqDfD28nYTdrT9NUkTqj+6XpdI6vNVWO/faeOaaYSvn7k?=
 =?us-ascii?Q?HOPZd6nEqG8ehB2ykOnGzTC0xXB7NzjK2QF741dhKzySW/6KuBmDPDMhhMmz?=
 =?us-ascii?Q?JPWNZ4vhBz1U4aNCxlqd5htqjOOoOahD+j0Rfcpq8eLUfBbQMWfnrF4j99PA?=
 =?us-ascii?Q?PKn5uHlKHet3/SxvyYHPorKfRp2o?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230031)(82310400017)(7416005)(1800799015)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 07:11:44.6747
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ecc9dd36-bcf5-4ff3-caa9-08dc731bf271
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E60.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8127

On Wed, May 08, 2024 at 03:57:19PM -0300, Jason Gunthorpe wrote:
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> index 15378c131a5bc7..41d7a0664a445d 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> @@ -991,6 +991,14 @@ void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
>  				    STRTAB_STE_1_S1STALLD | STRTAB_STE_1_STRW |
>  				    STRTAB_STE_1_EATS);
>  		used_bits[2] |= cpu_to_le64(STRTAB_STE_2_S2VMID);
> +
> +		/*
> +		 * See 13.5 Summary of attribute/permission configuration fields
> +		 * for the SHCFG behavior.
> +		 */
> +		if (FIELD_GET(STRTAB_STE_1_S1DSS, le64_to_cpu(ent[1])) ==
> +		    STRTAB_STE_1_S1DSS_BYPASS)
> +			used_bits[1] |= cpu_to_le64(STRTAB_STE_1_SHCFG);

Should we check ARM_SMMU_FEAT_ATTR_TYPES_OVR here as well? 

The SHCFG is RES0 when !ARM_SMMU_FEAT_ATTR_TYPES_OVR. So, the
used_bits[1] doesn't need to include it in this case?

Otherwise,

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

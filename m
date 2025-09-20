Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013032.outbound.protection.outlook.com [40.93.201.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A962AD0D;
	Sat, 20 Sep 2025 00:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758328107; cv=fail; b=rQ7M6wR/tsAHIAjeLnHRwXszMZJ4ydCSIjGhBa3fjR8sCEVGTF74llEOWa+bU0UdsSOwKYEqh++McCZQNhZJVDm/D3M7IP/bBvpSbQvX8bE7YfHbU0IcCmEG5XoYEO2koefy9eevXu7RSY2X19hZ7Wb2n7QipWd761w3ibANKQw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758328107; c=relaxed/simple;
	bh=cMOar1GkmDg8yaqsLNnSJ+qTWSnO3BxMpZdnvkA5Se0=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mVBVd1Ro0IYOK69xdgT1T+7XDe7ch7quIgOfRxd5/RnUb+k3SjnobVsIRMskpjM2mSQWREPV+pmMpPtCw4HOCq12lulydm3RbpWKOl25+IpXsucuex3+5/HcmyJ4iNA4o8Ruxikw/CM/boyyiTd1tAnNB8ASBi9xmWHHQAChrN8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kbDHYvhh; arc=fail smtp.client-ip=40.93.201.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kbDHYvhh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K1d6mwCn+5ThN8LBXrYhOquVSiDNk/20QiUSfP2PT5E+iyuFUmlYhjBMw4V/gISjq7ZgfpsZJaboST6hkXy4GTXcYXHVXA/CMJKDmDDw54/j/VQPwujyo5s5uaPucLgiwHMxu21uq/GcU3JrMFxs4R2STIWdx2Ux/BEEyUsA/LPgPwyevAAYQcZWnweXLVakeRwyIUik7oOdMJRI42kL2kLeYOUkfiQ6yECzABvSgEtIhutWvC5QRUUyYKWKwwxH9EeFbwZAqTj6ith5zlfdiULnvcUxx6TcXM6DKHPN1HcmzmdD/PGP8wDv0S3K+9myK1MxZZdE/1tj2aLrcbV2LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4s1UXQ6erPj/tQ7KE05UerPqWnM6ZkQ+N8gjCHkcdfA=;
 b=tHeYMqNA/dml59yhaKHDv5kx2MHriDRl3Z42FLlSLqyYqbZ/6HzeisG45P/SzNrcoiwrs7If46jQ8F5lNoJ0CXP/SU0lTr42BVm9GkIhTnZREDoeXY2TV9iJ3ZKfamrl/8AWzxjdDT6akRa45wP4F5bgUWOiQ8SmwKeIlnNvOUUd1hUY1Qwq9SsKSNCPvBCEAIp9G+mCmaDss3F/O9bdIRZlnmDZpqMJ6yRk8n4QZLxyAVFVeZoSegNercOQk5rwdK9OmwQpJ/RSV1pLdgZINHHOBahQpb+rXSBPBlDhp42OPE9lhzFulFLKv02T1MXEFHK0gKpb6/R9E2b33NSpUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4s1UXQ6erPj/tQ7KE05UerPqWnM6ZkQ+N8gjCHkcdfA=;
 b=kbDHYvhhyXY7176O6TDkhTwba/R/lBsz/5WDIJqb7xczZvAvizDFDQSO7o1Ty7Gp1qk5W9tKxvwyFydoGd/eKbRKcUpB6FRjGMAQUfnTtqlDQ4n5IRxNp5pLgF9kl1PlGKhSjeMgMp9FRaoIF5vSRg1hKRTiKLUO6v+qCQlhRbNvXLBBTUV5pqlut8keFJkeqYgqz+t1WozDRzRBhy9EkOTo2T5T1SPdT7lTxFcgpivMHUTSUxqX7AwpOOixDWB9k9vTxOGdfRlI2DvdJ8CYoB3WhlhDypUd2vKFvZxaqSugI77B6bZGv2IFl2L7lhoPwV+10wO/1R9ztPATndL1zQ==
Received: from BN0PR04CA0159.namprd04.prod.outlook.com (2603:10b6:408:eb::14)
 by DM4PR12MB8560.namprd12.prod.outlook.com (2603:10b6:8:189::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.16; Sat, 20 Sep
 2025 00:28:21 +0000
Received: from BL6PEPF00020E63.namprd04.prod.outlook.com
 (2603:10b6:408:eb:cafe::ef) by BN0PR04CA0159.outlook.office365.com
 (2603:10b6:408:eb::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.22 via Frontend Transport; Sat,
 20 Sep 2025 00:28:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF00020E63.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Sat, 20 Sep 2025 00:28:10 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 19 Sep
 2025 17:26:17 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 19 Sep
 2025 17:26:16 -0700
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.34 via Frontend
 Transport; Fri, 19 Sep 2025 17:26:15 -0700
Date: Fri, 19 Sep 2025 17:26:14 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <will@kernel.org>, <robin.murphy@arm.com>
CC: <joro@8bytes.org>, <jean-philippe@linaro.org>, <miko.lenczewski@arm.com>,
	<balbirs@nvidia.com>, <peterz@infradead.org>, <smostafa@google.com>,
	<kevin.tian@intel.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH rfcv2 4/8] iommu/arm-smmu-v3: Introduce a per-domain
 arm_smmu_invs array
Message-ID: <aM30pgjLCvXtsW90@Asurada-Nvidia>
References: <cover.1757373449.git.nicolinc@nvidia.com>
 <80310b98efa4bd7e95d7b3ca302f40d4d69e59c5.1757373449.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <80310b98efa4bd7e95d7b3ca302f40d4d69e59c5.1757373449.git.nicolinc@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E63:EE_|DM4PR12MB8560:EE_
X-MS-Office365-Filtering-Correlation-Id: e7073a96-f25f-4675-3820-08ddf7dc9a64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Jli77tq2FP+Dz/H9w8GhELS9XKC/bDuG4oqAQ2VRCEjd5dY74L41h4qm8MA5?=
 =?us-ascii?Q?HSXikYS650r11GqhuLlCBnDzrHC6cGhx2ljGJusJUMNWVAU2FvNdm4Stg9nT?=
 =?us-ascii?Q?1OTigp0/dblZmuJOTv5/grCVf0VuBqpqf/PvUTtU9n4ApBOCtTnNzl2eAwjT?=
 =?us-ascii?Q?WEcy4PtM77Jl5CPHSF1Cfys6euSGk6xRtk0ph38BnNpkdWKOmebh80AD7M0e?=
 =?us-ascii?Q?4+Y23QtUOOisTt9uAsfahNe6piPjC7qqtxOg106UzX1z3be0SKwzBD+wl+UJ?=
 =?us-ascii?Q?ZBQPpbdZLVSclhdCh+5pS8dB27joEOFPiWS6vR3eDQwy6jIDab1S7gWPEAHw?=
 =?us-ascii?Q?Rzr3L3mxvEW+b7yeobx73fS1ut3lQnyl6MzCUP1yZkP9z75rgRtKGWpsssk0?=
 =?us-ascii?Q?/fnRiflhPrINQ4LrC569zv42eDhATfDV58atBcvmUoS612QUxylC4ZdRl5hY?=
 =?us-ascii?Q?i/LuDYGYSaHTHCyTW7/Cm+23S52zwB8cFtAgxEj71FpaFkF29k5yXIrpFlj+?=
 =?us-ascii?Q?LTos23ctp3VNnG63Be//jMfsoOuG+UASN5QnkHfxI/TP/RIFXSkKj4U341uq?=
 =?us-ascii?Q?66PZjubg2T5LSSePC2Odm4tj9Rpf0PCpWG/UKYCF4xiqwDbe7rD8UFPypnV0?=
 =?us-ascii?Q?Nucpp2nLhoxCs8zxXQaht9uLLSoAxdZxVrV5TqmW+3rl0t/+UUSioojgs6a3?=
 =?us-ascii?Q?Z87TfJAQfz0usNiLAAUAWzwH/OwsbUkSN50JseIz7utaeVPvGj53uJTBoJ6I?=
 =?us-ascii?Q?WfS8od0yjK6Mu2mItbPBIuRY0k+UAMk/XJLFM+DmQeAI9g2PCrqfpIj61Ff6?=
 =?us-ascii?Q?K5suPqwY0mJQ3HDgzaCLQZpQJ/e6VM2r8HWuC/iufkZV1nu5CmXnT7IiB/hY?=
 =?us-ascii?Q?dxcjLQNXP1QWbT5/rjTClyjWn2xC+2F4fVYiBfabEjsEPa5TC9Thf8R3rguh?=
 =?us-ascii?Q?igfavlhL82JnJlHaswToEcSL2Jg9m0/4qBFT4t69jO7H745JXg/4Vp0Bph7c?=
 =?us-ascii?Q?4IEz4etHQwjPYmpKbPOHnv2dixecZY6VyeWNi0u7BCM+4k0p7eDqsveKK9ZS?=
 =?us-ascii?Q?TXlR08/n8fQe+VGoIEAQhiVyKzJ1SkMC6ySx7KEP8Y8lFqBQuyATZ00O8fHn?=
 =?us-ascii?Q?vX6A4eyj4cuyOHu7K4D5izci/2lLknxcg/zAHM0DPfQLN2HsVOIJtmIew8HS?=
 =?us-ascii?Q?0LcwPc4CsqQwzY1gWxZXKj6uHpeUU8uTi5Juq4SOFp5vLmonokzcyWL3mNqW?=
 =?us-ascii?Q?VLas+U2R8AysjncHN29LpclK+g2EZrMkMQS93ma500Vgs24q4Idq8EGV1ERU?=
 =?us-ascii?Q?Ueh/oLxRbYstBHMF3P7Y34kiI30f0xMSSLILHUG1vWGXC+FAtxmCNhgc6Itp?=
 =?us-ascii?Q?0mJUdd13vQuBI8ZeeQxhz8cIOXx0esx08+2pSiwLC89y0pXe87axPygCQMxN?=
 =?us-ascii?Q?FPHbS1swgfLRm7ObCdM8BQtmrVOaxVbkL/yKDsC7y2TFELyQmdZ3JEUZ6CVx?=
 =?us-ascii?Q?3yWmBkcAvytfoTM65r2a8qMQNqWrD5NjrYjU?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2025 00:28:10.1503
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7073a96-f25f-4675-3820-08ddf7dc9a64
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E63.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8560

On Mon, Sep 08, 2025 at 04:26:58PM -0700, Nicolin Chen wrote:
> +/**
> + * arm_smmu_invs_unref() - Find in @invs for all entries in @to_unref, decrease
> + *                         the user counts without deletions
> + * @invs: the base invalidation array
> + * @to_unref: an array of invlidations to decrease their user counts
> + *
> + * Return: the number of trash entries in the array, for arm_smmu_invs_purge()
> + *
> + * This function will not fail. Any entry with users=0 will be marked as trash.
> + * All trash entries will remain in the @invs until being completely deleted by
> + * the next arm_smmu_invs_merge() or an arm_smmu_invs_purge() function call.
> + *
> + * This function must be locked and serialized with arm_smmu_invs_merge() and
> + * arm_smmu_invs_purge(), but do not lockdep on any lock for KUNIT test.
> + *
> + * Note that the @invs->num_invs will not be updated, even if the actual number
> + * of invalidations are decreased. Readers should take the read lock to iterate
> + * each entry and check its users counter until @inv->num_invs.
> + */
> +VISIBLE_IF_KUNIT
> +size_t arm_smmu_invs_unref(struct arm_smmu_invs *invs,
> +			   struct arm_smmu_invs *to_unref)
> +{
> +	size_t num_dels = 0;
> +	size_t i, j;
> +
> +	for (i = j = 0; i != invs->num_invs || j != to_unref->num_invs;) {
> +		int cmp;
> +
> +		if (!refcount_read(&invs->inv[i].users)) {
> +			num_dels++;
> +			i++;
> +			continue;
> +		}

Found that this should AND the condition "i < invs->num_invs".

Will fix in next version.

> +
> +		cmp = arm_smmu_invs_merge_cmp(invs, i, to_unref, j);
> +		if (cmp < 0) {
> +			/* not found in to_unref, leave alone */
> +			i++;
> +		} else if (cmp == 0) {
> +			/* same item */
> +			if (refcount_dec_and_test(&invs->inv[i].users))
> +				num_dels++;
> +			i++;
> +			j++;
> +		} else {
> +			/* item in to_unref is not in invs or already a trash */
> +			WARN_ON(true);
> +			j++;
> +		}
> +	}
> +	return num_dels;
> +}

Nicolin

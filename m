Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012013.outbound.protection.outlook.com [52.101.43.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1069286430;
	Wed, 24 Sep 2025 21:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758750984; cv=fail; b=lsfMflYx4aBSyhjIaFatC9PuCebtYfPoCDxOAhcOtOykD/0vuLJni8kLipp+q1HCS30G/10nIQrf39zeYom5jSVhEK2eRT37uFmfSGKQ6AhZ/2KFse7OT5ycWFWAyOdXPLpAs4xanC5UuRg5gV08MRQvwXYvXfvIh9ytyw6bg6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758750984; c=relaxed/simple;
	bh=zE3akqSUKFkVWoZSvLrra8fPf+FQ8JMBfYEXmKBb6VQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IdvrCcG4cDNv74lRDQMDD/pnfhns/fmuu0SUf+0iTExUptTtbXw0b+LEU45ZfvrSI4ludBbtu5X/QBF4DsPF38urFGiJFlRT3mfz/EODmuuR2WO7ZbwAhJY8TV+fYZ/czeA5HTX1hNRXvkhKnG37hEnvNsidFQ7kFkjze+ayEXs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SmU6xw8k; arc=fail smtp.client-ip=52.101.43.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SmU6xw8k"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cnIuOEqLBwqXF4LEpK8F+amq1Stlh0I8WO2mr4oEM408+eSVtAOr0yGTB4HoFMX+/W1Ll4F2klIrs8CG7/mGriLet82iwrIO8r/bwD6Ljz58Pp8woUfosUF1YQS3LeST5aByoAZAHSCwVV1iL2uHeS7qZO+sqhidxP2iRWQRFm0G966fgoLX2unPoTY9ZYajZNmuaa7TDidbsyFcPE39z65SnzgEQsF2s59YYCHmlcVEKu+J80+EriwaKjwaGlIx+lBwWuCPKAz6m+Yp6QQoFWiipBBW56TeSMeFFgC/3Xh66ho+QrV/OzcoRNtXtvK4uqH+i3f8VOPYGcaeQoUk7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2hzIsLcPDKeuLMFaoi5NndaA/acGiGPvFjy5OZYCHNg=;
 b=ftWrYNs2YqtCTujyNOV7ctvZQ/osiUw02hYNnE7aiJ2+y9Ks4joSgVAJzDcI9EF4SAaXFtqmoTDUKGdq9m31RVrxBBW8UV/QvA7KD8+AEno7nJFmpvYAVp/ZL3dKHNRYbWRjsXrckj2/oiq6nkQzI/i/eeKcoqUDq9I15vdfFvx45B6h22IaDAyfb+naBs8SYrVxQM5VRkDff5Wo1lOiDTaHfKF/MjM0p8PBApnX38bwE4nDEKgEQde0ClKeBXvEDtogdBI4B21KHLLeaW85IvTKOuAEwO7tVx4UUDB1ZVzNUKY9OUM8pUKjRw0LGw8W7ixJlVlh8hsptLBI1VE/cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2hzIsLcPDKeuLMFaoi5NndaA/acGiGPvFjy5OZYCHNg=;
 b=SmU6xw8ky0BSGni8k/O3nZyEZmgIbGz4JteB8ookPYezx4NZikdSWYHmMQ5jscbhiyr6jtp3w3KSkO+CLT94q4xFYn3xqAO8vIIq8FOHW3YB3GNRVaXVH/eAdX0lRJkD3mB0pYi2gxZiL2G2kK3XTnxmzMfKCnzjALh2eHaHoeH8ePEUSVboixkUnPwT0EUGwDRxvj5V4GCuhc/upqKM8J4g20Z3uf5THauHXR6sZkGSrcEq9601EF7QZRhdX3062m47maf9Tk00ptuSLL7d+kHbK5NAgA53t9B1i/cjk2k6m2h6aq//x7l87Dx2WgsvKFxP2ckmTzGsm2NuqzY8WQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by MN0PR12MB5715.namprd12.prod.outlook.com (2603:10b6:208:372::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Wed, 24 Sep
 2025 21:56:16 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.021; Wed, 24 Sep 2025
 21:56:15 +0000
Date: Wed, 24 Sep 2025 18:56:13 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
	jean-philippe@linaro.org, miko.lenczewski@arm.com,
	balbirs@nvidia.com, peterz@infradead.org, smostafa@google.com,
	kevin.tian@intel.com, praan@google.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH rfcv2 7/8] iommu/arm-smmu-v3: Add arm_smmu_invs based
 arm_smmu_domain_inv_range()
Message-ID: <20250924215613.GS2617119@nvidia.com>
References: <cover.1757373449.git.nicolinc@nvidia.com>
 <9ac8acbd289fa32378498f09f78e7924d3523200.1757373449.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ac8acbd289fa32378498f09f78e7924d3523200.1757373449.git.nicolinc@nvidia.com>
X-ClientProxiedBy: SA1P222CA0127.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::17) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|MN0PR12MB5715:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f3a106f-44a5-4016-91d4-08ddfbb52f3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aP9MEv8frbXMlRjdzG3BZCGpgqmZT+NK3MMz5Zqu0Y+3ZBy4F5jDW1f9yA0H?=
 =?us-ascii?Q?yr7QQzQZ++XvTNtgL2oDqkmocEkVexi+66TMhb7i1Gz8kGmgOqg4SAjl3Vhi?=
 =?us-ascii?Q?cGX6FTbZEFYPCeT7/e1rYFnQwvqQABTw5ibbMTAkduE4o8dsO5mRnfFVwKmJ?=
 =?us-ascii?Q?SROttsgXjGp5/Kc+qnTT4bL+ZhqEZUTTs9USGUN1iRRs7a/MdsDBpNyxbA1E?=
 =?us-ascii?Q?hsaeQCT9U2wDSWGPJHL1ZT9hAzb1bfjDSo/WZUIpA7voPtActMBPQ793/AWk?=
 =?us-ascii?Q?P0BBU0ifFR/cz56WXQBqQE1ve8gORv0RR6pOJPXS81eMsTIugX5W0LHbd1Lg?=
 =?us-ascii?Q?dZwmNd+FdcO44qv4b4vvyl3YPf0Kl+XAXa267Mcxd4vwMnWYqyoAIoArgAKd?=
 =?us-ascii?Q?hJ2S4p8lH6lYeud5wuyKVNuqf4owxBiT0nFji7tQPCgdmVDvz4sDO3Fcjm4C?=
 =?us-ascii?Q?6wlvrz0REby92IZyoipZ/s1BAskwLUHqRmlLpNDZVeNR7hz81SPQyWEfNBVt?=
 =?us-ascii?Q?vFi8aGVEp2N+FeHcRuQBx/ETbfaj+YVmZwC889uAn1wEzQAzXWOHnqpak0dB?=
 =?us-ascii?Q?+35NNjXlNJejAAehlDKHcZp9YW4huJxCdMFMJ5hZlKA0yS5dr/7K3+qPZwYS?=
 =?us-ascii?Q?trGrPijF3u1ojAEXhLXQ/+szYnVZWTO0QQbX2huJ7mnA1xTYjymd3lFK4HBx?=
 =?us-ascii?Q?jyPteVGbfVsHDo0QPGdT/WjlVf28K/IO4xpMW3N0hsKEJfu+3ysUkgqscSQ2?=
 =?us-ascii?Q?PgbRWFM5a5O7feTwoBVr0ns2Qhgj93du9xQuqC/wzP2KbgMPg8OszCubr6fH?=
 =?us-ascii?Q?eW3fYOptY3b5wlw7xoOF5ugmfXR+SFAyIGVURvywfVSWss3LcIWD3tkJ2zTw?=
 =?us-ascii?Q?M5pGO40UJ+yJqEWuNchfh4xUadUfwROAkmDPmq6bg9/5oDZXcK40o0988GK0?=
 =?us-ascii?Q?V9Q54wYM1K6bnzdZHIB6TZjIUVEmoXoHj/rByNNTh/PpWJE63POzQ/hR5TXX?=
 =?us-ascii?Q?ZjL+clHQUuJ4jB3k1InwoRvc6mg8n9I/+ZYY/v/qtyPo9sy8atYVxrXuRoPu?=
 =?us-ascii?Q?pt2PDxs717zccKk4B65vXs0QsDH0k/GEqv8u+9AAlhBoAbTXz/+3bO65G7Lx?=
 =?us-ascii?Q?ExknfBayyUSbaJEKZChb4F0DjddFlEaRAc0N+/2AJCufUkKBVFpHBCVYBqku?=
 =?us-ascii?Q?ndFx+igRBSIqQs4WY+99s6HDiX1nBV9zOUjF1rCtT97I6t9q/gTKcqH3V+/c?=
 =?us-ascii?Q?3l1jy4YFjoVW/TPT3qGQhFxFaGDzzgJO9O3wVPYmlI7DkmAKuovcqOd02eA9?=
 =?us-ascii?Q?6ZaUDWzfkLUL+yENVNOjQi9ziXIODSRcNSdAJBFf5/C31RSJS6t2Y8FSZXQY?=
 =?us-ascii?Q?GVdIw6aMRgH0Y0LMnl0vwUfBMpOREA+ykjnF/LQMhL/+tCf5YZiFpS0lYVgJ?=
 =?us-ascii?Q?WijjBNxpB2YtLCRT2T0wTEwcyx5mIaHXZl8pr1ulmv1X7IZLHrEpO9JH/OaQ?=
 =?us-ascii?Q?vXbIQ6+m+50ClTU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fcUJETIauGWdnWBJqJITKm58EczPGzLm+M/mAqO4ZoM4XQJjrSW0Jud8XuDW?=
 =?us-ascii?Q?pidMgoZD+5hjHUf+NHwWp8W7m88vADvTvyvnqjRYq8MXmRmbq1NWhy7SUxUR?=
 =?us-ascii?Q?OEL6FYuRC6LMGnjRfgRPzzZo21A6KT3CuDC3xNUTRjDg3rivjcyMLiY6v21f?=
 =?us-ascii?Q?8OZ2f+pVhYvUPh/aFsNPlI3/wt5h+641J75lfrvHIWGp4iSvM5I2YGOfRXEc?=
 =?us-ascii?Q?MbtNbXyJXGaspFLVXr0cPYl6BCACNZTBUkxqDI+9M1GbPQebvz9c6uE+G8ra?=
 =?us-ascii?Q?syGqzLR4WFOHTLwXUIoyArWb2Y+KC9+XtxqZ8nui+cCYNJqcZuuX3NCFsmWE?=
 =?us-ascii?Q?dQjsrgeRmzufKkoefKeB94lqdGGaJdX9zlIK835HosJKKENx4elO5hmEAKiu?=
 =?us-ascii?Q?Q5IYDTcuj3sT6lquYo7L/45XC+xpZwRDog6QcQqE8uo4ms/lzsFBhnc93wvT?=
 =?us-ascii?Q?pLEE5zbfleCosYzJC5isHyrw3jbhT+J2qaP9hlB50pdsBClgzUYqFASfDSSe?=
 =?us-ascii?Q?5Ftupj+D5M4tO9qv0Gqu2zdCA0mqcJmjPXp98KiEm4TlJysYoyNQkVGlwS37?=
 =?us-ascii?Q?O8uuqKC4MyOZQmIRJoVIYAUL/DSAPdrToymoiONbJst/YVTbYXeHXS35ePvI?=
 =?us-ascii?Q?TPwFSLVDufQVKRJU4+5wg6nMtxflGx6nUIIUJSzU3uY8fKhsp9/WuU3Osc40?=
 =?us-ascii?Q?x6tNtzH5q7OD/6xsI1bx8phtSio4Mzi57PYfvsiz1gRxVKFh0EvHfRfrfE4/?=
 =?us-ascii?Q?jyCUIIN28TQQMTMNp0LviInwNhtf3psgkmjBEJ2tjkatpCywLtQxtbnVcGnJ?=
 =?us-ascii?Q?3SE5w4ysHSoLC2ual6QI4Cg/r0DIu5GhBIASi3znvtnQ+x3LWb1Mxk8L7SIg?=
 =?us-ascii?Q?Ozj6D5UtICSr7UA4BrGZwtLQms8sb+SI9PD3cUQwUWBfrkg+ILXY51t2vuT+?=
 =?us-ascii?Q?A0I9O0+RoyXyD1OOTumtrABH0st2XLhy4fT/kztgy4+lF1I7DOfzWSqVjyK0?=
 =?us-ascii?Q?/pHZ7X36CyFAM0GkTWtzvGHKvSwgrqJafuCIDjhsHt2uoqUtDqGV07yNRaIT?=
 =?us-ascii?Q?gsIlwP14QEK5e6CiAgHZHjs+VE0AXJMgw/nySscvf452jovuQgO1pJ4zm2tg?=
 =?us-ascii?Q?pa+5ginfR9TyBCx/VRC07HftnhnA73dqvwFes8I7fNlSWR/DxDyz65Buko/K?=
 =?us-ascii?Q?JYwIIOLjJeWI2Sqmf1kikUlEB+MBF+IE/nglh1Un8OuDHRAbeP9P3CfK70Rr?=
 =?us-ascii?Q?eFDenNqoc5lY3P6DPiHkM+QgpTS7ePUixTKA3vYb5WNnHmfcErSBojRMNriy?=
 =?us-ascii?Q?i556sSzBPUHftIAHmPmTUyuhSKanPdDJqsePSUewohaofUZSLQtyW2ta7fAO?=
 =?us-ascii?Q?SAiEM1mP21ft9plVZzzhHdujYtjWhIKHGdAl904ffVNQ4umHWnce87BYS+lo?=
 =?us-ascii?Q?qCwQF1RspELDARBgoV/JzHpcZk1SUfV9ATYLUuxihnYrZ/2KXMmDGvkwoIFQ?=
 =?us-ascii?Q?Qj8rW4sMIwJNkhM+pS9LRFn0sNtORN71vNHWuOipC/ge6gahc9y++CpdFk1d?=
 =?us-ascii?Q?xkvKReRizdH/QxnZ6J5oO5b/4bfuUX81k5qaYQ2K?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f3a106f-44a5-4016-91d4-08ddfbb52f3b
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 21:56:15.8259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tqSrQDVL1dLLOXFfVUZ3t7mCwzx+F/F53jD5n8l6pb7UIKMfpvwyx5JqqKAA9sIf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5715

On Mon, Sep 08, 2025 at 04:27:01PM -0700, Nicolin Chen wrote:

Maybe:

Each smmu_domain now has an arm_smmu_invs that specifies the
invalidation steps to perform after any change the ioptes. This
includes basic ASID/VMID, the special case for nesting, and ATS.

Introduce a new arm_smmu_domain_inv helper iterating smmu_domain->invs,
to convert the invalidation array to commands. Any invalidation request
with no size specified means an entire flush over a range based one.

Take advantage of the sorted list to compatible batch same-SMMU
operations together. For instance ATS invaliations for multiple SIDs
can be pushed as a batch.

ATS invalidations must be completed before the driver disables ATS or
the device is permitted to ignore the racing invalidation and cause a
SMMU timeout. This sequencing is done with a rwlock where holding the
write side of the rwlock means there are no outstanding ATS
invalidations. If ATS is not used the rwlock is ignored, similar to
the existing code.

> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> index e4e0e066108cc..c73a94514c6d6 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> @@ -675,9 +675,15 @@ struct arm_smmu_inv {
>  	refcount_t users; /* users=0 to mark as a trash to be purged */
>  };
>  
> +static inline bool arm_smmu_inv_is_ats(struct arm_smmu_inv *inv)
> +{
> +	return inv->type == INV_TYPE_ATS || inv->type == INV_TYPE_ATS_FULL;
> +}

I would put these has_ats related infrastructure hunks in the first
patch adding arm_smmu_invs

Jason

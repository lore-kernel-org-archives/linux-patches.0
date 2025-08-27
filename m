Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EAF2D2388;
	Wed, 27 Aug 2025 18:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756320572; cv=fail; b=CGM5VXnbmyIAeQaZ57d6+7NIgB/EpQcPOzO5zxDwbcIOEzznnX1Zs0KRvx1gpGaZ9rPaKO39XpqdE7i6ES7amjI1jMLXjYFJcoszw7BZpU6evs6idlzaKrl2u57Tr//45gCpvVXb7z3fBB2Le6PXbl/xNYnxfqgmvatZu7HWqGY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756320572; c=relaxed/simple;
	bh=N0a0rZZnbmLf3FUvP2Ax7NtZtavoyFJh5JNZvQjnvR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Np7IIcMDGgwvxGum4whlO5mohanbmdux0xDtKhSiOHcRUtQnGST4vVE1Rdh/C8ktGPpIMZywM3mCqaK0NjBGZs6nIIbdL5VyMw6aUDtGEXFLNx8rlDNSGGABS2IIu+/wnVyVKM/36UgrMpmzlD0/mUrm3BAI0GIep21sxISMOjg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dqjOjAlQ; arc=fail smtp.client-ip=40.107.94.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dqjOjAlQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ySWGTFIZTdDfFTBITXLpm+5jrBfveInnf8mz2hkqxLbT2yUih8/X0IKShfrDEG+/Gh58d7zKqeD0ZqAorvt/U4m5glbxEMuriqSb+piWVJwJzJQWAO3eWmNFTPQZMEh+CJaNDEvkcUkl/Ngp7Y6J41tp9j75NNrhnsbzz85K+KRTVJBp+5xVoi7j686UUbSQFrxUwVN/FCM08bRUQyahOjwr+QFHCQBqtcEW8n4fsV+Qx7bJFpTiFL58gidlyE7mszAm9ekvrODF4oZbK+S1mHUrZoOVvIvPIBWMqFdgf9ozip7rIkFGY0imI/IsKdvq/Bl716uQkSmsfzqy+2k6uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P79x+HNtTVBzS8U9zR6Tlwi3NgWQ1/9L14iISA6o1yY=;
 b=fRbYrtt1b1TSvmQeW5GQgW9OAoY4kM2eenLn7KFfoU+LoDEYuWDQOccOLnlkRYDqPAIDbitsIMgjueSriEIS6r2wtZHJPQyMvxpHtTH6LC5CSHVdlh/uAjMV6uJG6yVTI2snuPam9vDU5XadsXZ2FvIjPwaB1cmvUMMQeuEgYXFWqW4QmOLliIZh/M3kIOiUX6kt1zxo39iDtzB8c7B3viUrepyH57DUu67sWIwrJWloUtuHGjaHPibrSmcSmJgruIKwGKfuQgmhQ/C176Olp3SI9YtmlEWoA7rLzB4kUHSTsZ5kNT0J3Y6hZLGqn9R45XQdklSJbztVnQTMMz17ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P79x+HNtTVBzS8U9zR6Tlwi3NgWQ1/9L14iISA6o1yY=;
 b=dqjOjAlQeYd/2GwWIJX9RK/nJdjSPJYZrs1bSfSfK3JlnLszjz70SQQ5Ule1g+u8fcMpDwf8yNav5b1TZJa01c4tQhr0tGVI0AhXuKaTcX4vQtY0wvwMAr7BdywBRQRvI7d6pdPYqryyn8Ia6xnbdwa9GHD/g9blQKU8jhc7XfSlgRb0JQ4qAIBkUcFB/CN2lzb8Uz9B4pQiC2jL0vlrzU8B9l7nMUrdZGQQjUPMarOsnELGwshuJksz7WjEZ4epymM19/YwJNL6boWxTGILb7KrbYEz5zrsOZGvCp7djX6O3hytdYWwC6cuOTWNO166R/nncnbRiilqnW2d0S/pbg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB6433.namprd12.prod.outlook.com (2603:10b6:208:3af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Wed, 27 Aug
 2025 18:49:25 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9052.019; Wed, 27 Aug 2025
 18:49:25 +0000
Date: Wed, 27 Aug 2025 15:49:23 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
	jean-philippe@linaro.org, miko.lenczewski@arm.com,
	balbirs@nvidia.com, peterz@infradead.org, smostafa@google.com,
	kevin.tian@intel.com, praan@google.com, zhangzekun11@huawei.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH rfcv1 7/8] iommu/arm-smmu-v3: Add arm_smmu_invs based
 arm_smmu_domain_inv_range()
Message-ID: <20250827184923.GC2206304@nvidia.com>
References: <cover.1755131672.git.nicolinc@nvidia.com>
 <8c4c5aec144f65cfd1fcef2eafb395876dac97ec.1755131672.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c4c5aec144f65cfd1fcef2eafb395876dac97ec.1755131672.git.nicolinc@nvidia.com>
X-ClientProxiedBy: BY3PR05CA0021.namprd05.prod.outlook.com
 (2603:10b6:a03:254::26) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB6433:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a35fdad-5e25-4273-8ee1-08dde59a7189
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|3613699012;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?byuxo3vdt2HcSKnA8DUxkgu9MEdKnamTvsQa/npY+PuVOCj5vFG+3Untlbql?=
 =?us-ascii?Q?j94KHpb28rBl+8GLfDuv3ypu2uCaqF2/Dqdr4dZGTmFwwA63rB+31Qx8DclY?=
 =?us-ascii?Q?PsxManMAPseys+hWiyYT8TGFj1NPjmdJ1FmwP4+TfT4JFB783YbggUXdTRND?=
 =?us-ascii?Q?WrdWFFTzhj/YSAaRNSY4VKXaOblM6Z+MXFb/kTV03Ypm70Lnxn8c+WmQpXnr?=
 =?us-ascii?Q?reOhmcQesVTwa6cnMkdM5x9S2kiw6AjL4+yDng2x0pvtNyxydTTelvAHJaWJ?=
 =?us-ascii?Q?SPaFBbg4gPy7J5FLPRYeKlCmQ6N1Fy85YPvbivqmKXVBRADn4XHKfx2ENZnG?=
 =?us-ascii?Q?NhH6YmA3SrJ/n7mJJkaBK4lzklzDy01yBvLXXMTrXWs+2FDEK6bi3vE9rC96?=
 =?us-ascii?Q?imvQJFkXmSwWaAfwBLpnsi+m3d87koMCeEwUFo8Cjrq9GdGlkPI+HD6PTUSY?=
 =?us-ascii?Q?rVc05nw3MtPb2nBib2hSWrUk0DCwVm3RGX7I1SdK8swI1Rhzcc5IcM5ZOrp/?=
 =?us-ascii?Q?clXh4oFM7lbs5GyPhNGpVp013FJefqoz+0zb15DdvUZKmvtl0gfTD9MAJtzG?=
 =?us-ascii?Q?gWdX0Pw2S8b5bY8QHUv3mzQIf9vA8cacEO8mCw7LMjZ/H3IbfVQ8y4fKz3M8?=
 =?us-ascii?Q?Ns1ay6IC+w9YaITuDkSccyMmphTWcACfQhKI8SFb1G7AoKDLwyEeWoUjtXr5?=
 =?us-ascii?Q?eufP29JKSGo8PkCLtrbvGDZo4LfmQ3uRCo6sWEUIEhkrkYI7Z2BktJ7x2kVt?=
 =?us-ascii?Q?YdHuDsf2fFrtjsYR9nX8MSdAAjZ7gYmp+tQmOOQqUgZ7Ix5WpeCfJTiSKbwY?=
 =?us-ascii?Q?wvOEre3SDdc6e1WmcFIK9iDwTsdhY7lf4mTAXcM+v+VxCQaJnPG6QseyJvjb?=
 =?us-ascii?Q?hwwQUNrgpr0LzW+9yWlK0Mpqh1qMvRbF6Ihnr44xGy8g685uHMo53+AToeNe?=
 =?us-ascii?Q?sDfUEGqosdFAXjGnDGuQnk7NKS0VrOyrvSNzzUzmCma3NctMrx+tZo6ZJ32k?=
 =?us-ascii?Q?XT/e73ZFRZ2Okc2JPOPAtP+9/7Afrlmm+ms644dAKD+CTkN5MqGlSrzm+IgD?=
 =?us-ascii?Q?NKddDLiR6Ef1BTWE57DR4cRN7bCQ1NrQyJJ07cNYmlPdl/Eit5iaQ0S3AGp3?=
 =?us-ascii?Q?zi1d75XlABgaYAn7a0zcqmU3cPWP1WVRNT8OT6AlqIaq8ELVTAZ/1hekZ9mW?=
 =?us-ascii?Q?bXDRvdaraeKues6dKFNqe5ZxGHH40U1nlc2RpXVkQPaniZR72ktW/0ns/aSO?=
 =?us-ascii?Q?WWobc//3qnf0/LDbirIjsrzA/v3dl7ONiSdUS8G4+mNUSLY1iruDGxFDP3W5?=
 =?us-ascii?Q?XLe7N1mWQTaQHMS5nS0YbpT9Jk4G6yfanCQzbLy0WqWfLkEJNOd+tlkgUzjp?=
 =?us-ascii?Q?mmdD8doS6cilJuTPwn/8ttUPkiaPv+zoQTdqF1WmomK6B7pDLUZkAifln8it?=
 =?us-ascii?Q?sDA8rNCx3UfbZekvrMCHr0eFObHx1eicsa/EXKPNfTpCuvKvN/hYCA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CqqAsVumDJtpK/WA8ORrAfJ4qvzNF7pW83ZJzzx/jao9aFF340wJ2BSkx35o?=
 =?us-ascii?Q?BMcOy/XVzda1GnltF6iVCfK10UDxfSiOge55JpQXAiM4MXQEszQo3MRpmml8?=
 =?us-ascii?Q?nhLWik8OHrvEj2XFMQfXwVRhqSxBqvfiZjRuCQ4wP8tkrylpqP2zhzrYflU4?=
 =?us-ascii?Q?A/wnvejrSml22t4x1m9KfbwyDykDXiTV6oDJW0BSA52srQXTq8/ZtbwEavdv?=
 =?us-ascii?Q?4Sgh+peZeCI6lSo3jlqU/CYrbcJFzprEBhDlsRD04INSfi9Iv7ZN+h2gAUew?=
 =?us-ascii?Q?8fBrKEvbNN1HeWPC2+R4CyTRamJXHbC7mVyxgsiG/KItnzmJrbTf2Ofrbe0f?=
 =?us-ascii?Q?5OezrJLVSRO0Ni6gqbQpLfI0AWRXt/AE867S2BQcV9DjZ46H2rEKacrK5fM1?=
 =?us-ascii?Q?/r38CtGBmC+4f4dXRirK70NQmkgsoA/WC+tbCXsXJo4Y8khDWfT0ioJeMwgE?=
 =?us-ascii?Q?7pgI9Pmp1spQkMe7sqiyvs2tDC1t+anCEt2buutEbLfnWTirFEb2b7Rq3e9K?=
 =?us-ascii?Q?zvSkSoaCWipw+lvbdLkFhbVPYUZrYjc8ku8VNPC+WvImyS3P1gGAmsi84vB5?=
 =?us-ascii?Q?bC1aOflPBb1NZ4iP2xhRfHUL0NUYJ75P9N3EhmCypbA5shXhMgWIvZHYGrE8?=
 =?us-ascii?Q?rY7QuuZR5WWNx0k6vLRPnT/fF7gwpLZw0Zcp0deKdNQVmM6mCF1BBRjGM2Lt?=
 =?us-ascii?Q?pjZMjkuRmtsTKcCn71yXNh2zoI3Fz76EFZUW+IW4H3ffSOKFyFzAuEZv18sq?=
 =?us-ascii?Q?iTP+N7JOtP7Iob2hUsPt2Xes6FZdZJMXnZKSBd7BAmNh21G5V8tOKxYiLOEm?=
 =?us-ascii?Q?1PTepX73UFM8qbYxWnuUvZw2KfLkbnxDWbKLrVrql7NOp0KsXlUHcRP/jPkk?=
 =?us-ascii?Q?dfl5aaIqerP6MoK4rEwrT6zaY3gU0fRdGo6NDdGKiVryNwxmHJIrEDV/0CVb?=
 =?us-ascii?Q?K+TS6vFZfwjbdKrFFlEyY3OKzVKCOYLQB1dchIJluqabX8r8K4MuLfEKoweY?=
 =?us-ascii?Q?Ab1vxE40PxzMZYGt3A4O7gercO/vkbja0Fsg3h3lkly7b5lrW24FIY5iVVc/?=
 =?us-ascii?Q?USJo/kQ2vq9OXKOQHU1IpefoAYyaBwl6LnYP1GcjPQdwhI1ZEOCfF082Zag2?=
 =?us-ascii?Q?kpp8eOM0Py2ss2+Nt3T/LA95u2UIusFhHt7cZnMMSYg1UhRtsOXQbMFGakfo?=
 =?us-ascii?Q?1DCelrNHDywT4n9Ivomqyy2j9RA4CT7O8rScGiIG3Xl1uSEaTfLN/3QVi79k?=
 =?us-ascii?Q?y0hjSJveZxDQkgcxi/dVKLH6FbYFIVmYSlbY6jsERU5u86sd4BffONJVmDsF?=
 =?us-ascii?Q?xxS88qvgW8y6f3nSydxluWbEHWMve8nh2CyWQwSgc20raDDH+Bn5X1qcRqfe?=
 =?us-ascii?Q?JtqGPiBHczm/Wg6lRGFF19Q0XLkeEp6D/HsomC3FKLw5smj7uE6D06L286f1?=
 =?us-ascii?Q?d8CT2N1yZsLNxbra2FHqxRMMlfQa0MUF+ISeTkzWs/hMAR6Gt9LFDqytewUp?=
 =?us-ascii?Q?q4Xs6EBF3/aaO1HmOZuUjblyrWe5Ont9ghbIOCoSx/jeLahDbUk15cJ92Fbl?=
 =?us-ascii?Q?i4ss9XUPeFnlxauebg9SChO6QIPwBN2ha41l0wHs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a35fdad-5e25-4273-8ee1-08dde59a7189
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 18:49:25.0803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: go7KJr0B5qQaWaLfczN+3VaetD8rYViNl/UCBc0vCuSX3tNILYFMfhUSfLiE+H1s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6433

On Wed, Aug 13, 2025 at 06:25:38PM -0700, Nicolin Chen wrote:
> +void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
> +			       unsigned long iova, size_t size,
> +			       unsigned int granule, bool leaf)
> +{
> +	struct arm_smmu_cmdq_batch cmds = {};
> +	struct arm_smmu_invs *invs;
> +	bool retried = false;
> +	size_t i;
> +
> +	/*
> +	 * An invalidation request must follow some IOPTE change and then load
> +	 * the invalidation array In the meantime, a domain attachment mutates
> +	 * the array and then stores an STE/CD asking SMMU HW to acquire those
> +	 * changed IOPTEs. In other word, these two are interdependent and can
> +	 * race.
> +	 *
> +	 * In a race, the RCU design (with its underlying memory barriers) can
> +	 * ensure the invalidations array to always get updated before loaded.
> +	 *
> +	 * smp_mb() is used here, paired with the smp_mb() following the array
> +	 * update in a concurrent attach, to ensure:
> +	 *  - HW sees the new IOPTEs if it walks after STE installation
> +	 *  - Invalidation thread sees the updated array with the new ASID.
> +	 *
> +	 *  [CPU0]                        | [CPU1]
> +	 *                                |
> +	 *  change IOPTEs and TLB flush:  |
> +	 *  arm_smmu_domain_inv_range() { | arm_smmu_install_new_domain_invs {
> +	 *    ...                         |   rcu_assign_pointer(new_invs);
> +	 *    smp_mb(); // ensure IOPTEs  |   smp_mb(); // ensure new_invs
> +	 *    ...                         |   kfree_rcu(old_invs, rcu);
> +	 *    // load invalidation array  | }
> +	 *    invs = rcu_dereference();   | arm_smmu_install_ste_for_dev {
> +	 *                                |   STE = TTB0 // read new IOPTEs
> +	 */
> +	smp_mb();
> +
> +	rcu_read_lock();
> +again:
> +	invs = rcu_dereference(smmu_domain->invs);
> +
> +	/* A concurrent attachment might have changed the array. Do a respin */
> +	if (unlikely(!read_trylock(&invs->rwlock)))
> +		goto again;
> +	/* Only one retry. Otherwise, it would soft lockup on an empty array */
> +	if (!retried && unlikely(!invs->num_invs)) {
> +		read_unlock(&invs->rwlock);
> +		retried = true;
> +		goto again;
> +	}

This has missed the point, it was to not get the unless we have
ATS. Something like this:


	rcu_read_lock();

	while (true) {
		invs = rcu_dereference(smmu_domain->invs);

		/*
		 * Avoid locking unless ATS is being used. No ATS invalidate can
		 * be going on after a domain is detached.
		 */
		locked = false;
		if (invs->has_ats || READ_ONCE(invs->old)) {
			read_lock(&invs->rwlock);
			if (invs->old) {
				read_unlock(&invs->rwlock);
				continue;
			}
			locked = true;
		}
		break;
	}

	num_invs = READ_ONCE(num_invs);
	for (i = 0; i != num_invs; i++) {

> +		case INV_TYPE_S2_VMID_S1_CLEAR:
> +			/* CMDQ_OP_TLBI_S12_VMALL already flushed S1 entries */
> +			if (arm_smmu_inv_size_too_big(cur->smmu, size, granule))
> +				continue;
> +			/* Just a single CMDQ_OP_TLBI_NH_ALL, no batching */
> +			cmd.tlbi.vmid = cur->id;
> +			arm_smmu_cmdq_issue_cmd_with_sync(cur->smmu, &cmd);

This should just stick it in the batch, the batch was already flushed:

	/* The batch for S2 TLBI must be done before nested S1 ASIDs */
	if (next->type == INV_TYPE_S2_VMID_S1_CLEAR)
		return true;

That needs a fixup too:

	/* The batch for S2 TLBI must be done before nested S1 ASIDs */
	if (cur->type != INV_TYPE_S2_VMID_S1_CLEAR &&
	    next->type == INV_TYPE_S2_VMID_S1_CLEAR)
		return true;

It makes sense to bundle all the NH_ALL into one batch if there is more
than one.

But this arm_smmu_invs_end_batch() no longer works right since the

		if (refcount_read(&cur->users) == 0)
			continue;

Was added..

Jason

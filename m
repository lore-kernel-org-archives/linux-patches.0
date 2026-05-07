Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280AE379EC6
	for <patches@lists.linux.dev>; Thu,  7 May 2026 23:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778197541; cv=fail; b=izTGvo8+aLAZHfjBZiMcHYeV6DcRQ6Gz/N0FKuT+Lh14PZdzOyOe/3pWfl6Q0JgEKGXk9rAfZZFSwKRzLno1WnnoiaZvYJe1UTExRYgJ3GUx9Am98ebCbmTP5ubSA6plWpAaUbObQKfJWS8loY9sDlS3UqEOKQvAbcp3XSW2Ico=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778197541; c=relaxed/simple;
	bh=m7eVZzOgS/zxcVU31/njWwRdJ1boaC3mbwKYKEcVwHQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BaevmteKgvkgZnvhwyEpQ5Sfb1ojdPTTAXltkrILyKogy4YXrBxVB1hVgDlZPAe+3LJb9yXiIVxd929+6orTADGPxTxDk96IszmHbktJ6t4lrJ6PsCkaVv9dHm/82iqzZPGsEaLsHJUMSMv/HUAUoOG8eIZViKeUQ6gIYVf0x6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dTXeeabB; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dTXeeabB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778197537; x=1809733537;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=m7eVZzOgS/zxcVU31/njWwRdJ1boaC3mbwKYKEcVwHQ=;
  b=dTXeeabBsXaCDOjxnoFu7uUdx32qMYXonXOhoO3/i2hq0/6PEuSckmzW
   wMdKLfAYjv+TzxLRXvZcCMgVbgc3Z/XvXhjhxY2yUf4bipxDCN7KUujaT
   g1D1SNcrbzPKFRYEaOBPxHsuBRXvS1uRo1KJRb6b4MOeDi4KlZYpGuFbM
   YKN6/zLivRzjkK7LobcvnmmQAZitzy5P8ELXW2rEFnCekIORQ+YTGcM+w
   cbGfSSr4SVGrE14pPiyejmHl/O4zj3Qe39Bz3X46i4r7nrW+q419CRQqQ
   VpdZOyyONLjwh149IIS1QafFe3Bo1iQXQ0F7uko0u0fzv+IB1fus8a56V
   w==;
X-CSE-ConnectionGUID: CFJkWUmdRUmCN3X6K4KzwA==
X-CSE-MsgGUID: 8XHswKedQNyrI51QPyqSWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11779"; a="101837113"
X-IronPort-AV: E=Sophos;i="6.23,222,1770624000"; 
   d="scan'208";a="101837113"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 16:45:37 -0700
X-CSE-ConnectionGUID: ySWR92dXT7ip2Bz4CciILw==
X-CSE-MsgGUID: iaToKcFTTUiv7cxhwJTMRg==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 16:45:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 7 May 2026 16:45:35 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 7 May 2026 16:45:35 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.28) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 7 May 2026 16:45:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sy+3TUBYGEW+oXAPb/PfzThS08JtwCQFiAzuc0Vx4Z0sMNw2cBLxXZ2+aekUMovnTyqacsU0dF+oNMim73n2XJcm0MfQyT3y7HpEObKOviKtEd+mZc3U7Q+rnEDeqGtwat0to67XUJmFXKSf8Na8ztxxfCeEeaNwC/VBofquYYY6QFNerlGDpET942Q/eLWQtgrBDnPURP/lSQznkMyrsfWdYAz0zEcufjKDCLIhk4XbrNC9uL+a2MZnGhRl1qcIxfF781rNrCEZRRphftKtviPfn/BnxYm694lzYeUCraCd6mlpcoK6nrukvosujdFS1bqfYO0zH3aPRledw1s3+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dloaUpxZhoPFht+kkZowaqFkSRU4O/0GOAeG772zDJs=;
 b=K+9ZSA87ZG5dricAgvM2l0Q68b1mqNyuxdDnCtjNX144IAUiEy8BS/RDVVf0XMDTmCzWEyuxdC06qvS2Jec74yQVJJgEznJwAoq1QjShi5wOKrFP/nmQXyw8xryjjK1omrz4RAmyLsmVG61nScq8Kr+voeSSTcsnCq2EbeaHiVds5WNOE2WHzUK1WjbNomieO9DVkx3N99kGk7vILgewzSQsPJI+EpyEn4TpiQSP/XH0dOyd9zU2IOAVEOKGI+tASDAbS2lRkQaNRugfjByRuPZ3JInmk0hY8JHPl+r4tpkQKoxf8adk7jQxfPqG8GD8FtMdZzNWjmii1xP9tCKMwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH0PR11MB5925.namprd11.prod.outlook.com (2603:10b6:510:143::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.18; Thu, 7 May
 2026 23:45:32 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 23:45:32 +0000
Date: Thu, 7 May 2026 16:45:28 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Fenghua Yu
	<fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v2] fs/resctrl: Fix deadlock for errors during mount
Message-ID: <af0kGMDXHBBjOyhU@agluck-desk3>
References: <20260504220149.157753-1-tony.luck@intel.com>
 <5d38c1fb-8f91-472b-8897-24b2f50c772b@intel.com>
 <afzQFkVPiNW8QR8J@agluck-desk3>
 <d3b1f1c1-266f-4d17-a049-0f12cf5a9360@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d3b1f1c1-266f-4d17-a049-0f12cf5a9360@intel.com>
X-ClientProxiedBy: BYAPR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:a03:74::24) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH0PR11MB5925:EE_
X-MS-Office365-Filtering-Correlation-Id: f1d69e3d-2596-4757-71f5-08deac92b94e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: tkrnzZa8hSCqgtpQB3gySONnRHkpU1uDpvQsjBkG8PEymOmfA7IcaSQW080fjjI7K6Qj2M1pYhtFFYMZliCpcgzhooUyeePulEYMMr8+XkzGGMgmaAxCoqwla1DwJEBXtbcqC+u6bxXXm0ithBQxhBFFs5ZxcvGnMtY/ayt+WBaEyUgXq0WXCvCJAEooYLUpZfkNdGsH4Pgq/cQyl1UbUt/fcsY09PaXZC5OI7356hCUkYSUXhm2CLJu2KyWG84Il2hKYAuRqXk97ffWAq48YTr5rMm/oJj2i9vuh5iA686Mwwtrki+qBvyx718KlLlj+Jr0oWQ3y7HRyMtNIJ36Jwc+t/KcK0F59sE8bv/spgXpqKsPgg000WAhOZb76cFdQlVjG2JIXsHCnHEzFNnYc1llNKn+RfmRIEUAv7lq0RdCRgA6T8f3Cd1t0FRJpyXcVIhwNvdTClpXV3HFTdExYzoWbBj5yqNrkZ2baX9TUG4VxHoHjlocDJDcuagdCxnsLPvpCN64WMWZpFKYDHvnH+160rwPvgilIBnlSsiP2JvPAweqR869b763h0Qqh9rGnbu7VEZQKBVs9CB4SyDxj2iAYJiWRvI2NydvknjFoYXmMLtjQkCn34GGIU0hlvB6iBEyZjGgj5LMk4Tx4MUvmRf0d/VeJqBstenQUNskWXD8+dE8EZg13k6WwP+7o592
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EzJ6dz/IvdHLV2m5Lj9Zv/dsXWVo4Ccwz2TtlpVRWRssfqNkFgSeDhH3vhrw?=
 =?us-ascii?Q?I7TIUL8/JK9rD92VGtibkspgRzXXiFURzCw5uxjg+9rvk6J+Pip/z6GjoBKh?=
 =?us-ascii?Q?ry4pzT/u6nnK8m4omHx/Bf3bEoBhgCz75HDfazCSYJKIDDCiefYB7VKEH2ce?=
 =?us-ascii?Q?7TnCVbKjH9Llb/Lj4AIFAYdM9fOH+0vDEzV2Jj8yIxNrYghKARasKvoL/aGL?=
 =?us-ascii?Q?y0a6BKZFYvd2oqpiZIct8r3haKp0yHn9Urf1Erq5Vn5d1hDsjBTTT6rsZNgC?=
 =?us-ascii?Q?Kr6uF6RL5S5QJtF/lOCRODMuIlGiSrC+K0WtmvcnBb9WhYWxkIFfMXwgresk?=
 =?us-ascii?Q?Hh+/X8fso0LdlOINEe9H3SLRTOBcboWI/oE7csm3w8zV2+SnkTMPEsh5SGNg?=
 =?us-ascii?Q?h3DG1tShSd+zz4OBfHKYKtb9+zVbFzN4KsI+fna6EcVBNWnGz7yBBycGMPl7?=
 =?us-ascii?Q?OsgtMtDWhPOZhIadmoAFyfsPVmLPZH48mwPwh0/jMEggkZKDKwHQQNYnV9Eq?=
 =?us-ascii?Q?L9Fs4/yYS02LHCL168mEPcG+v6kqCNwBZ4cRmrJ52jW2SgwGTlWsS3KToxLH?=
 =?us-ascii?Q?feEsSZoagc0Xi+rnL+vc6Yj+WHS5Vuvbz3PiTgEPN7ovSLv2g9NFtCYqhOEd?=
 =?us-ascii?Q?+hauh+GPvR1YQ6vuqVAYM7438cTRQLJYFvX41OuQ1Ek/bUOFNzbmnUMdjsjR?=
 =?us-ascii?Q?B71X3fj4p2aqzb3XDD23iB88BoLmk4aW1b4r8oCJlUY8TSo1waJamjEXSsCL?=
 =?us-ascii?Q?rtE+piEby9PcK4Rrv8XYhvsybWpUI7pmoq6N1QhGYjWSpCI3usNdEEAogWC2?=
 =?us-ascii?Q?/VtaePx96XgSd1EzEuv/pGGrsW/vCo0UP/WCKVUJFMtF+vMmOtIGkdaF3A1s?=
 =?us-ascii?Q?fNnBBa9rm5IJJ03BIY0EYwigfrbjz7KrMnKBRTu0PqI5H9sENZmKgC3gW1cH?=
 =?us-ascii?Q?02yTOCE5JH82eclHYhcqk5oyL1LxwaE6aCnx24zlt6kNzkFoXSFKFJtMUrkk?=
 =?us-ascii?Q?lnSEa4NaFF3+Bucx6t3X4VfsSL1mxppjculF+9lx/1gl9yBBrSqA0LEy1nzH?=
 =?us-ascii?Q?KEoOwls8QXDU1JsVXOsW/RKKL8MWBS9nzoiFzaVv0TBzZNRg2FTc8XB4rLLa?=
 =?us-ascii?Q?H5cim4gy0N4fBXgehWmlCNiD20mFXCk5OR20tXZkKHb4SeQK9deEo2fyGfKF?=
 =?us-ascii?Q?5+XLvmQUEBSw7i1gqWxpbLnXtcgPSM0UMik0DgJ35Unq28xD0r7ZYNPILyj3?=
 =?us-ascii?Q?OFNxzlN/LTvj45PfKfzfCY4dfvSTMt36rOc0YvFmXtgDJ0d3Uw8R3gZKpgX1?=
 =?us-ascii?Q?9BFXktoN38GBCNmZmoSCSZVcBkTny+syX5lUX7dmSjfMKHG1X2CfmpP9XTQc?=
 =?us-ascii?Q?A12kg7vLVTy2AiY9i/t1hWwii5SPmRQ1Oycth1K3ebswlszQJonFwiXix0pp?=
 =?us-ascii?Q?D8dR+HQIMvKA8vDA+IHXWq0oRxw9h2VF4gXQCqGT+7MBf7JTKybKnFVtmu2U?=
 =?us-ascii?Q?qygDUHyzQoYew/LSimIzeU3t+Pi8JHJHZZ4OnGmGj79qIVNYCK2NM+IxrH+x?=
 =?us-ascii?Q?Pe55Mp1WQIQrsIw9GzzYRtqg4mwhBIBjQVOZp8ojMvuV/PeK00AAz+QmKIbH?=
 =?us-ascii?Q?sqEEEaDaRpYh90qRLo0xLwa74SQnZHo3s7jmMBS42I97cirMWy2RB+QudEvR?=
 =?us-ascii?Q?ObpMejy1V2bxPfx20ceHpKrciTybY9mutO/hbFyO++D7qCT4Lc36peeVi+YU?=
 =?us-ascii?Q?HuipPJhyvg=3D=3D?=
X-Exchange-RoutingPolicyChecked: BrYfCJbwMLY0DipQBGQmofsThwdHtHXd5hFi/lckXMRajDRMZxbizbPPEZXTiXl23gxyJRfXJyIWIw67tc/5wbva2Ao5ZqYdoKvXTjNYJe4kqlknHVrknKnrTX2N9ZLS0nOZjM+ArFBU7SKPMtJxXxy9wfaYXveMXTBS6ZnynqBQWsF+ZhGYEZyyEKd5F/RHAlbxZPs5zPraHJwkAAfiaHCYnSE9AGy9KosBLg0Fk++itb5BUnUMdx5QpU4v3fBq8Zmw4ach4pymjRGQ/Udtn58QEM2GOmcrS/vSIzd1gCpgAOI82WC+WOC57D48QUOrn7p/57VrBYEgQu9F9v8AWQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: f1d69e3d-2596-4757-71f5-08deac92b94e
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 23:45:31.9466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q3HaUXN6CdRadvZ1dxnK8VNHvrhGiuxfn5ISFqZ+kcKkGvFyBZ7jcJ04PLlPIvQeqRQvNBvNCIPFTNmVPedAOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5925
X-OriginatorOrg: intel.com

On Thu, May 07, 2026 at 11:30:53AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/7/26 10:47 AM, Luck, Tony wrote:
> > Reinette,
> > 
> > This looks promising.
> > 
> > I'll split out the missing call to mon_put_kn_priv(); into its own
> > patch before the deadlock fix.
> > 
> > Going to re-run the tests I did before forcing kernfs_get_tree()
> > to fail early without setting new_sb_created, and also late.
> 
> Thank you very much.

Tests pass.

> > 
> >> +/*
> >> + * Temporary forward declaration for testing only. Move functions instead.
> >> + */
> >> +static void resctrl_unmount(void);
> >> +static void mon_put_kn_priv(void);
> > 
> > Question: How much are forward declarations hated? And how to handle
> > this?
> 
> I am not aware of forward declarations being hated and I am not aware of
> documented tip rules about this. Even so, I do find it cleaner if they
> can be avoided. To handle this a prep patch that just moves the code
> without any functional change should work?
> 
> > Moving the functions around in the same patch really obscures the
> > actual change. Is it OK to have a patch to make the functional
> > change including the forward declarations. Then a separate commit
> > that does the re-order (where it is obvious that functions are
> > being picked up and moved without any code changes)?
> 
> My preference would be a prep patch that does the move with new
> capability built on top. It seems unnecessary to me to add a forward
> declaration in one patch just to remove it in a following patch.
> I agree that moving code as part of functional change should be avoided.

OK. I have a three patch series:

1) Pure code move, no changes [while I picked up a block of functions
and moved them earlier, "git show" presents the move in terms of a
different set of functions moving]

2) Add missing mon_put_kn_priv()

3) Fix the mount error deadlock

Internal AI scans have only two complaints. Both appear spurious;

First it says that:

	if (!ctx->kfc.new_sb_created)
		resctrl_unmount();
should be:

	if (ret && !ctx->kfc.new_sb_created)
		resctrl_unmount();

It admits that current code can't return ret == 0 (success) while
failing to create a super block. But argues in some twisted future
that might be possible.

Second:

Code used to call rdt_last_cmd_clear() unconditionally on success or
failure of the mount. Now the call for the end-of-function error path
is gone.

This is true, but it doesn't matter. If the filesystem did not mount
then there is no /sys/fs/resctrl/info/last_cmd_status file to leak an
old error string.

> 
> Reinette

I just need to write up the cover letter.

-Tony

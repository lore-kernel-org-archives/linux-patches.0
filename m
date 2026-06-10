Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D6643D50C
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 15:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781106577; cv=fail; b=bwMbuUqtfgeVrSgQYtN6bLOO2YU1Rf5VJruH+9D/aKGzewLOqhhbAtoNd+HVcfVetLa9mg10OS4vJx48+sJY/RrUX3eBOqqcCHALexFZubEAA4uniN505q424gONocEPGQTX46imjo268HTlZ/pCzoOrGyOwQrmyXuspV4G/xjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781106577; c=relaxed/simple;
	bh=ZRgxW4C+ZXuZXbDPtztLKIfSBrnvqRxB1ovTFqV36wA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=InK498DUVcQN0SHXyPJOX/eypij4Y3jQRVSM7VzEh7b3sRVB4g/b5zccOtFY0Y4DN3I/vsLjycIBSwNpE20IW+zlLicIKmxX1x28eJoqanMgsTCMAa4E0Oj7GzYlpbWfXk5Jq7g7ytZFvp2bsBYYJagOPmXWlYojty0I+BfVYZY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O50GPbPN; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O50GPbPN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781106576; x=1812642576;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ZRgxW4C+ZXuZXbDPtztLKIfSBrnvqRxB1ovTFqV36wA=;
  b=O50GPbPNrIX4RumEYcOpOm361NvTfKrDGNdbDC6zErdmXA6tZQ0sxYe3
   99h2ExBQGODtiqRt/H761Ph+XUpMRmJ/MFUX1A1SFbWUDdfaY+Ur2304u
   LGrGhKrTxL0CmV7o0KGDJ2/y46VJwjQucVR0UagGyR4mjmIeXRH2IVyGq
   LuwnTVdx2qJqB9ZW832CneJkEp9TjPlmKxDXRepS/5YNlnFL3ghCiUCbg
   kDpaWwMW6WMjpxrZy7wb2xMayXq/sw2s9YGkPKwbx38d7ZU6bwTY7spqQ
   fddyfxHqCFB7SXtYyuSaDQqol971KXlNN89QSNLFYSFNK4b7hBPyUhv88
   g==;
X-CSE-ConnectionGUID: DDGbcQMFSMSw7PV81oidWQ==
X-CSE-MsgGUID: l8EOdLUaQW+kaNdIgo+7fA==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="81879624"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="81879624"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 08:49:36 -0700
X-CSE-ConnectionGUID: SxHWjfaCT8i7vEQrrK9Qhg==
X-CSE-MsgGUID: voztKIjqSEuolHc/COVukQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="276403692"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 08:49:35 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 08:49:35 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 10 Jun 2026 08:49:35 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.5) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 08:49:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mkx2B/edbhLGrPkMNsX67PQTCI4sg5mZ7gWJQx0W75i8YYKLazMRZlsGpGvinrZQPR4Pzl8tXBi5vnd/VXEpXYr5+flKUCfOrI2Ef4TqqwxX2qBAhsqtObEclms5eh8cohA5Wi4TmzlEngFYKhWMFAIMdSWFNmNwfu+8mp6i1CrBRdKwHb78Gw5h7LkVZ1ouHyKl92EAwjxwnUcHLYQOkMt4zOoRLlyu59VfL3GmUkVUw1H0c6j9ci8WfCW4jPb3yMyg7ci47fpBlpp0eLt34OmVybwTvEXj3EHCzZRnrZ0Y6ibniiyajzD0in1rwIp1yzkkXPLaxRyblQJwRRSqVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MZMgsWjFcBSOEb9TKYWxH5oK7dchFvzz21l3S0JLf1M=;
 b=iz8Wo5RBnS3jhVAwbtcxb/87Mfml2cT0Dq6suL5blgpAHLi0H8qdF+cAr7UIq2KYTiLXcg6D1s+3vJGHR84nixj7oCFNlWEQ5ufQz00LbnL5++wyii1y6zHUr7JOGM3Nx15RAwJzAHVe5BgqIX0PG2NUKw7+PDV3/BzG0tVR8CJ9eOl2aPwMPWsC8o5RTL0ag7wjnP9OEk2AwXIaeNpd4NqsE082M3hb9p8sWOhfYX78YmppXB1NSkvCSU8dPfV7XFMWiFTV4Sz3/TK9rlqr3JIWQ3X6Rz0KoNWF/zZnKHKB1n3cUgurRYkwXwl0akgAoS35cDbTEvuFeVv1JX7eKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB6545.namprd11.prod.outlook.com (2603:10b6:510:213::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.11; Wed, 10 Jun
 2026 15:49:30 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0092.007; Wed, 10 Jun 2026
 15:49:30 +0000
Date: Wed, 10 Jun 2026 08:49:29 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v7 11/14] mpam,x86/resctrl: Resolve INTEL_PMT_TELEMETRY
 symbols at runtime
Message-ID: <aimHif2ZC3PIjHw1@agluck-desk3>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-12-tony.luck@intel.com>
 <03d45c09-b392-420a-9b38-1c1f213a7dcc@intel.com>
 <aiiq55x6fs2ddS91@agluck-desk3>
 <387cc53d-7e55-4c1a-bf0d-635f4f7590f6@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <387cc53d-7e55-4c1a-bf0d-635f4f7590f6@intel.com>
X-ClientProxiedBy: SJ0PR13CA0021.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::26) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH7PR11MB6545:EE_
X-MS-Office365-Filtering-Correlation-Id: e1606b76-e8cd-4023-4e72-08dec707dc29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|22082099003|18002099003|6133799003|5023799004|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info: klFMgjftUqPLho0+3B/PT+tfM03xyTTnGxHopfknzPa3B11GZM/pgCgvaOwCgYx/M2qkw/NhDLI3w5XNq4tmoPoXjbgmKwxhjhu2ESM54CvhGwylQctpDoSqvB3/HXz36GyzaZ+8maE6PwfY12XnWG3D1UyAZU9LoVzpEsWJd9ANj2m1IacnnslnCZ+Fn2fjlbsrp8cYDJeRNAgrLqI6oZJigOeG9D8iHyk8FItyxmIFdUXY2B/2u/8IOuIG1xo++RySf5bGdxdGHc4jMVHuDQlqpQEv7RgdMWTVIXJcGaQABDXHI8fXAcbOP21+COdvEqXsaiNHL1Z9h3FYowdNUk6Ps1bFkfw4F6kyVjPfphXGcq8GLFbbHTmXSI3wokpXzO+fRbNhrpCe0zAXezHpHDJMB124KAc32K5/d3T+Wu4bCZ6OAGjc/SzmzWYOx3hqxldqrXBXm+PVxCLSgISfXTnkjhnp1hunq4vOdnZn9P9cCkC7VaJ5LFbXmLulqSaQXafLJM+UZs0vUBeVEnJVB1pVhLy3LEWltAxOs+Il76UPxcOH9qxVDS738jDgF3+DdMhoUwvNCApzaRsF7jKkZ/90Nqbbz0kGxpRxKPg1GbUwcuK/O8wue0DMNkdzAXQ1PS80Aohncg8LCRbt8onzEzWpCyMq+AcC3cqRKhIC7JafvsEgSa7PkuL1lxWE8ZuT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(22082099003)(18002099003)(6133799003)(5023799004)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g/JDz9zF50A5EQd9Lav0Fltb+vJZQ5DQiWAPCvEkGXLPouMAyohRiUungwzM?=
 =?us-ascii?Q?jDLhP9mdyR+Zgi2mQwYyQm+0FxyVKPUKeKM6ztlbtx+lKcclK+PQ7/lXtAAz?=
 =?us-ascii?Q?0JtlAyPyQKRy5x9a6gDOGu2nA+F7oJEjl1gpjESommgu4syW7WRa/34kNgy0?=
 =?us-ascii?Q?0x5KCGKocMQR4yPFv6BNHXss/5OKIKFCEXmfEiIZo/UlftrHuDLmbdzXM8Y5?=
 =?us-ascii?Q?1TLuUTYTbvgK1GLQ5e3nNTamz0AQSYhEttCuikTHiirhnsaNvJuHP0CbUxrg?=
 =?us-ascii?Q?4PtJItl8COCNNFKr+aqIi3m1cfMc+JyfdvAJHaQLllPgckKNhCKCX3fFQejh?=
 =?us-ascii?Q?1DrqaKuR+PytIpSYOHTByXKihUY4xT9stBmZvl175g0mZXFDC3ZiHktEh93x?=
 =?us-ascii?Q?DD1QlQRG2/4Y1GE9rLv9wioyTxiOrw2oQPYmEH6NannyDRKFnRFAarfji+eo?=
 =?us-ascii?Q?9+VTySbsZmxkUWNNBHieFh0xcZ7ukxJH9EVjS/8sxZ2GIdWhbxa0u2MPwXOj?=
 =?us-ascii?Q?naWMnhgPMFALxWxV9NQQygCFJvbuopgnJ86esVvqtf0uV10wKsepoodg5wRV?=
 =?us-ascii?Q?HI/Uh5lSsahFkupYA7AH5MgakQZqNCTA23/OMzgSviEe/J7bivFjAFnSR76A?=
 =?us-ascii?Q?p2PEx62UQrxvxw4rLIftEmHhyXFruNVMm2YBw6RNXNlpeGe22MyGHU5+8AbU?=
 =?us-ascii?Q?7kkvpGJVjwGDJG+X/3RDBgl2883lhGJ0Kn/zAcIArmZsP/mfNCTq+ciBLHHG?=
 =?us-ascii?Q?4Brz4hq/03PJ3w1txLJiPx1kWCEh7k6Wc7PPWct5jBvFHd30Rt2QuObddyra?=
 =?us-ascii?Q?WmP78eOtCQofyJo71zmAqAJ4OFq8xcAonVwaHwdpUpmPWeSgaptra/iCGHvv?=
 =?us-ascii?Q?nZAw7nd4qNQMAnbfyzBSfrJI6O+bCWhQe7+omZL2HitqUhoqWSbmjg9pEg+t?=
 =?us-ascii?Q?dY6FaKWSzYSZCof86WOLOEAQS3wYlgQ/GffH1xMxTx0P5kSW+o+wg0OJD9BZ?=
 =?us-ascii?Q?faFoMbUpjYodlV2KLGN1iaOynTpk5sUQu1jRZ2fykqnP6f+AbktQHtSM+Z7o?=
 =?us-ascii?Q?0s16Glo8TqlSquXlAosnh5T525Rmy8IblBDEwNOo4U21keGoaGWWH18Y0I0k?=
 =?us-ascii?Q?Afjazw/tkMTIwuXibBs7qIYwXeifpd9K9AT+z9u7utAPbHmiNF1KP0U1k/X+?=
 =?us-ascii?Q?HgDGWHySVsZvX2zQXiO/rEIY3nyrjZ8zC8tMslmhu2pmbj6AQQIzqXfM9mtB?=
 =?us-ascii?Q?yhESk4004Ur/KLyU+MGr3sRU5DEf/5LMR+TmghEFbHAF+emk9XQbtL9KhAYf?=
 =?us-ascii?Q?PaSHXrb919CzioEqKWoKRfamUm3yoMhd377wicWbg//yMiGKx6oUH3krMbBn?=
 =?us-ascii?Q?XmaNLveZrF31beztpjYu5qh377AR7qvP93Ch1NAy4jSnM3k+vkjjF95Kl30w?=
 =?us-ascii?Q?LNGJSpjmvryik+WvIlxIVZRzYsFXYyuUWSbs8qD8ad9R+YCtfK6CLFnzujfd?=
 =?us-ascii?Q?TZEd34hRt+NEtS2v0UUUiGr6DKGWlpBbImgPXmsdZUsDKWi796yWMLrlhYxq?=
 =?us-ascii?Q?OJpcVdfKJjAb/L1sytE+SzA5gUNhoZEbPypdxw044kuJ2DQel7TOLEtG8kwr?=
 =?us-ascii?Q?yeQGwE4uFJwlnUFCIQYsYRw1aX8LzPUPhKPx/sditAlKDnQLQV5dYvgByx9P?=
 =?us-ascii?Q?JLW58VekjQPECPDyd18VAZw6K3rIQqiY9rRzKzDzZ6iqk7zgAPV/S0BDwWvh?=
 =?us-ascii?Q?XNy5hGmiTQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: lG4SbvcKAzGy7TxZXtRj+4jVzUvSltLY5066VJk/O935g5V/HsHUrs8Vd0ufl4WnOFytFOqRGwEq/xyKBjWfTvqx6ERdPRmC9JlFrczRkvO3/4MD3ti0dRL6MAEQQ8Jf5S5frRnyqxWeo/GHiL1xDhVvPuh+OlTjxZipXYNw8D6h6MmG8zCgRcUksVfOGPP5HIWKQpF+rH4SPKkoTQh4OU+Cd7Pj/4VPej/+2Bwt4mB62joi1CzWK8U4L9j1GI/ngUR2TLv0sim4iDHiCxhK8RVj4ShE3Da7k/xEslS84Gbr2KpxNcx7NpU8XlwTs8rEKg2/Xi4awmEcJbZIUaQNCg==
X-MS-Exchange-CrossTenant-Network-Message-Id: e1606b76-e8cd-4023-4e72-08dec707dc29
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 15:49:30.6723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /w4uJGqraEPbr7aS77JycCcnEcVHFuzI4nnI8slyV5N0dDWCpjB7R1ZTtot2PoNxdPP3O5i6Q4eG+X5cxe/nNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6545
X-OriginatorOrg: intel.com

On Wed, Jun 10, 2026 at 08:27:15AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 6/9/26 5:08 PM, Luck, Tony wrote:
> > On Mon, Jun 08, 2026 at 04:25:51PM -0700, Reinette Chatre wrote:
> 
> 
> >>> instead of direct link-time references to PMT symbols.
> >>>
> >>> Prepare for the file system to call resctrl_arch_pre_mount() on every mount
> >>> by moving AET enumeration into resctrl_arch_pre_mount() and cleanup into
> >>> resctrl_arch_unmount(). This allows the PMT module to be unloaded whenever
> >>> the filesystem is not mounted.
> >>>
> >>> Remove intel_aet_exit because all cleanup now happens in the unmount path.
> >>>
> >>> Note that the Linux file system code does not serialize calls to
> >>> fs_context_operations::get_tree(), so there may be arbitrarily many
> >>> parallel calls if users invoke mount(2) multiple times.
> >>>
> >>> Add locking and state (resctrl_arch_mount_entries) to avoid repeated
> >>> enumeration on nested mount requests from file system code (which will be
> >>> failed with -EBUSY status).
> >>>
> >>> event_group::num_rmid may be reset (reduced) during enumeration. This is
> >>> not worth resetting on unmount because the same reduction would occur on
> >>> each subsequent mount.
> >>
> >> Even more important to ensure that PMT is done with its enumeration when
> >> AET enumeration starts?
> > 
> > Would be nice, but I still don't know a way to make that happen.
> 
> Could it help to have AET depends on PMT probe being complete?

I think I looked at this before, and it didn't help. IIRC the PMT probe
kicks off enumeration of the auxiliary bus, but doesn't wait. I'll check
again with David to see if there is anything that can be done here.

> ...
> 
> >>> +void intel_aet_unmount(void)
> >>>  {
> >>>  	struct event_group **peg;
> >>>  
> >>> +	guard(mutex)(&aet_register_lock);
> >>
> >> Could this get a short-circuit to make behavior on AMD obvious?
> > 
> > Like this?
> > 
> > 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> > 		return;
> > 
> > Same in intel_aet_pre_mount() for symmetry??
> 
> I do not see that this requires to be architecture specific. This capability
> introduces AET register()/unregister() and pre_mount()/unmount().
> pre_mount() already does no-op if (essentially) nothing is registered. Could
> unmount() similarly be a no-op if (essentially) nothing is registered?

Ah, I see. Maybe I just need a better name for my "have_pmt_hold" flag
so it can be used as the fast exit indicator in intel_aet_unmount().

Perhaps "pmt_in_use"?

Then:

	if (!pmt_in_use)
		return;
> 
> Reinette

-Tony

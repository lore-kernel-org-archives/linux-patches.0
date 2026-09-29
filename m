Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E9029BDB5
	for <patches@lists.linux.dev>; Tue, 29 Sep 2026 00:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790641766; cv=fail; b=jt4dEmX9wz9YxtHdLYHaIn0N4Sb5KlHyz8yjUo6SO96LnjSZSSzvx3t1YZtBgfW0dep0E3fc2oZlSfB8/tgg/QStz8ivbMMsjzQVbU0FOezWPZIF+zclAFabEFbLJu0Q3E4DVgwDGCMo16nW6P9zZ6Otftqv15I3uGJGmQVNOHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790641766; c=relaxed/simple;
	bh=QHFE7iq+WX/mrMIm7iN6gYyiamSsgWf8Il0eK7I+nHg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tm51plYES5FI6+Jgd/m0NJkuuULDwBZ0PHbAXyK2atYc1VUqN8FaydMx+9Lw+0ODBoVHiI7rr0RwtsP8ahMXL0h7eM3HvDY1OHzj1+Q2KYiFrjHDr1W+77kJ1D09s0D9XCiGC4P2SQ9WgaKuLA0JzTVcWUddGQDKPP0bp6rLDec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=erWhlvZx; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="erWhlvZx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790641765; x=1822177765;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QHFE7iq+WX/mrMIm7iN6gYyiamSsgWf8Il0eK7I+nHg=;
  b=erWhlvZxywpNSXGBjLO3FZE4GsEGfPW5id9JWNQiGMtsZYXr5a+oBe7y
   qxCmolCU01APdiVWjCw5VM6Dqc4Ci/O5OEgrA67WP0rVnSCo71ATH14dJ
   6ntwbuTO94yj/vRq/ynKE373GDNY/C/FwHXLulxKSXt18AS3SKTY87Ltp
   A9B2SQIxY8Mz9yH7Gh6pK4jYN8XQUmVegi8qBdKKy9grvCX5eCITJnaIm
   9S/zTkC2ZRCkdzFQU0rNGgjMKCz6hlLEdq+2U/PZHvoI+HIuMsGR5TYux
   5MxuUtdqiIr3sAncOVYVNi9oYrVMyv/SSfBvKm2Ea+vaCAlM9lUpXo0VI
   A==;
X-CSE-ConnectionGUID: vlRJHD8PS4Sf88BxmoOsug==
X-CSE-MsgGUID: uw3tCk/xSRmZ8jXRe5pTwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11919"; a="90571956"
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="90571956"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 17:29:24 -0700
X-CSE-ConnectionGUID: MGj8uRejQYCgFDMw4DCw3g==
X-CSE-MsgGUID: qBR+yq8pTvqfmlz7fgW/fA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,129,1787036400"; 
   d="scan'208";a="275234790"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2026 17:29:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 28 Sep 2026 17:29:23 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Mon, 28 Sep 2026 17:29:23 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.4) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 28 Sep 2026 17:29:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WBEEcmniNZNE90x89NF8Z+VTsCcHZfg+Q1LwQTzswVueFI8Fx0e9c9WeCVzqRXBVznhnlUo9hWUAeKSpdBxM7SpYPgofGQC8DQZUn7jGOmlMBQTvY5P9G6C7OH6HD3eKIqc64Y3Tuq6zFXPWGO5AatPMy0LmNvUcJNUu765JNyY2/xfPti/9dAvMzTPYPMAK/ORQTalTuaWl05RE6XQ4OyX1LflPoszF0STDloeBmKp1HZ3ef7crYPWJX3aEWgMmoUI5gzHrqZpa89+nay3+l8BrX6LSx2YilxeA6HFl+pFyO2LyQI4FCQE01eRRnRaA/4sAm6qmmnbmrTcPyygh5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d3XtZuXxNCGLGI6meUEu7oGouvnnslCScXcXZC5K4GA=;
 b=W+3Sk9wic2j+cpgK5J+axQv0EhhfxTwBt8AZtxbyNqD1SwDzPNs7GnCjBmDol27inU6gZ6B4JdS+V+kCLyzaG5qIvTyHxffVIvcSYeHepaG/IapVrCncWehY8PFlwALB7Bp46QEeUim+8+PHUMOxEJmE1cj61VrRgqthAk6Sj73eaumGmupH/dXFr8AdxMGapUz3eEodO/X5HhgOCFvFMyRnoDrK1IJVc5yQ5WC63pwmJqHgpUlPrzKKOc/xlG4Qsy5lD+6s2wCl2AQBXmQAW4iiBAicmcRgJdJpgg0aNOuU4IdHR1W0EiOTSJ13j9heyO7nRZkaSuaYCtSVGmD5kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CH3PR11MB7722.namprd11.prod.outlook.com (2603:10b6:610:122::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 00:29:19 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 00:29:19 +0000
Date: Mon, 28 Sep 2026 17:29:17 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v13 00/25] Allow AET to use PMT as loadable module
Message-ID: <arsGXbwHSwqmI3Q0@agluck-desk3>
References: <20260928221509.68002-1-tony.luck@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260928221509.68002-1-tony.luck@intel.com>
X-ClientProxiedBy: SJ0PR13CA0082.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::27) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|CH3PR11MB7722:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ec797c0-8086-47b5-bf51-08df1dc0b376
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|921020|56012099006|10067099003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 4zXhwt/XNc65ZpJQ0utH3oYh84OPnwmZDxdKUEtCEFmbXgcCfsCIzw02hjixq2oXAe25g3B3cuI4XW5F7efvo8H6gcugncfUz1GrWlhjD+ewBCrzYaBjFOgOagZp1TceFlTR+kqDUmN6mtEx5tNFTivfqOzs20TzJO2toVAF1YwfWt3IXa1xYBz82Ovsv72/hurmcV7TmWWyETwo6Qqwsb+yBN9OGm//3n3xmZnjvfqwOtXYF9yN3KoL1BDywgII6gi+Y1sNSyoY0yFUZViEfn63jAa95brlUWF7byhNG0MuyUzvZPtECG87CZgFPvC0tIOpoKBLzISgyJg5pRyc9s7LD5kztexVLqSGtPG5YF4SzktzteDPyuSEJ5vjJjZnpPq4amII0rK2asXEHnCPvNr61ofbY2KgvhpNWx3t+8FEsoWBVR9pB7zY/a/4SiIym6daj9V5SdEVeRu15EvqSdFDhD+p0fP6xaCsZkBXydb5/0X5TFIt+DBf/TD1zm1G8alHcqukesH9IzXMPukGvwBLhrh93uMRzSdH80XXhnTvrm6DErfKPae67LIWmjCaqpVt4lGKfPbqUEOhCi77d2CzAZ8x5Zk3VGUX+xeVgCJsho2WDVff0thDSZD5ITCpzhCCLZh2MnIzVLpgn4tKhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(921020)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7REikYZk9XuZxuSOLcTcKeZGzn1VPj6WB0uEdzUF+LD2bJ2uhq67vzlIF0Xs?=
 =?us-ascii?Q?+0RF1W0QoCoyh8ss2yWnKbYhnGLDkJYh3pP4JrZM0zZ9rgBYg5OnEQ/BNnGR?=
 =?us-ascii?Q?LySclWZwMErMfaNmnfzYX2o/EIdnvRBWJvHk5/TLTPGXi+5e/AbOMHs47jDS?=
 =?us-ascii?Q?9II1VPiA6kYYFayDnzR3XwH+oLpvoTCLkpp4qlV/Ofccit9M8eqEt2qRKO4h?=
 =?us-ascii?Q?41y+Az0pYACdzlWD+Cl+M/5SX97Zgmj5XE5a0+rwdqzcw9mBeQmVBNq+TgN2?=
 =?us-ascii?Q?InglQAtdGYqHoLNNAz5kF1cA3TjKi/xz+4yoaxdngcYi0pk5T+uf1Xxva9Hv?=
 =?us-ascii?Q?GnDFnPeChfaGlMTDTvyHrGn3i6NAO4PQnVzyK0NYZWgPoukITsmn/FIIBuCq?=
 =?us-ascii?Q?gFtscM/4nPxv9mBm4UwuBV+OvUGRPqrO6YuytR4p5eKYHUGeIPTBlfMRNwVI?=
 =?us-ascii?Q?gLu5pwufolTb7eizMF3xhsH2fR3cRRd2aWbg9W++WPpe1WCB23MrDRUgahfR?=
 =?us-ascii?Q?fDGEbidSPT1z5ASBcIeCUuRal+y3B4vZkiexK+9AgAtsN6NA2vKKuAYqFS1S?=
 =?us-ascii?Q?MtKJem8fk1T8aOBftx2Inwerf40k/SIFUWsAyG9XHSZXbrTMQQuEd9XLfk77?=
 =?us-ascii?Q?Lds+l+om3GD7MULIrD/sR8yJKP8j39DpzkmY8IPhxys5Wu7HJYZ/eQ7gNHzY?=
 =?us-ascii?Q?idxIhFCkfrYTkDSCCeAputU7Gqxf1z3/vQh9WK7l5AlWpmHCvfzJM0xMtbiz?=
 =?us-ascii?Q?jYIQVRVFORWfE65b9azQUJsICNvl9ASIsFkuHAMw6pQknX5lsLFLtVZBygjl?=
 =?us-ascii?Q?Vv4OD07unRYrGsl2lrfd/bK923v/tCyqVicBTNjlx74naWVymYI2o7zP7X99?=
 =?us-ascii?Q?4gSxYhK4xO3k2AZxUU9ui8jTWMO6q9KePM2cn1c0z6I765kn92GCXnonmAvs?=
 =?us-ascii?Q?0sKBpY9R3XZiPaVxoSIRRVUfE7TEzCxCIIMppi4Yi98lQvPV82spxxf6g0+o?=
 =?us-ascii?Q?TqhdmmwugKhYMsFAG4eNqTOwiW+D+sj27BFIpC3uWYelJRv9wvfX+A0qdua2?=
 =?us-ascii?Q?Y2cBn+5laiBZZLcegu5gCmN6/6NUvGvMhfDLMl26vEb4dez7HUa+tvFJn97K?=
 =?us-ascii?Q?A/6Y3I+xS1IUyHfE3pFrC5mfk3RIe1dWyI1VZFEw6Ebu9ovwBTGIdvhxJ6lH?=
 =?us-ascii?Q?YauCnfNUavwoBjBAoPB8IPppDuxtJ6sCVXBKEIz+YSOfiBtJZp1h+D+leAvI?=
 =?us-ascii?Q?TJLoLgSr4t8kgGpzfUSAHL13RbjI2cgkL/c4Mzv/hJ6WqRy0AkW563uSGCWw?=
 =?us-ascii?Q?LTOsdww0gHNsWNHuEiYlvA32oaSt+6e7MydKYpRevgT5r/1RH+dXont1AP7t?=
 =?us-ascii?Q?LEBV6wTjNWOhtLj3fh4Q5wbcwdVejw1+yh8sEde5lSMU5/xVDQmsKLXfGjVv?=
 =?us-ascii?Q?e2ENe+NdIoCWpSEgHgqU+02GkAmBl10FgI1EEUtJFPiY690tmwqeZ6K95+co?=
 =?us-ascii?Q?Ij9PIipI+u6MpulMpjWxj3fHARfgGkhdJ46CeqJ1zhkTI3bBMgs/OxO4T0+H?=
 =?us-ascii?Q?EfmSH/SeO1TOMbvK1S53a5Hb297Cy2+NYAON/gu1PIw/Q0mhHUmpMdlVKep7?=
 =?us-ascii?Q?rE97BuZQSz9HlRn4b3U02KqkUS1fsvz3w7489ZXJMpiIZrFGt/ieVzMwKsyc?=
 =?us-ascii?Q?tjBdjUjSUv8MW9wJ+mzKrIWqcP6peimFIQ4oG45MmOcYDvewrsPSnZ7gpIcN?=
 =?us-ascii?Q?r9NWrgN42w=3D=3D?=
X-Exchange-RoutingPolicyChecked: yV7926+2x4CTQhEoaLkluWQHONQjYGFX54FY47TAtfmahdeaJqlM/4rs5ksFjZLC2e80D0v7P8UKv01F2Ov0Z8nYd4M+WE3ESVpwmYslF6hzD9QFTcxStI8TFcLl9gp7bzcvApZDu21rjp9Sdh9XP5F905XzagmKTyE43feFQpMjoHq4zgw7T+qtOK6PIFaVP8xrJ/xJuD8AlfMIaz1lkgEtO1Ha93ez4dkj59MKqa7Ogk+Z257UmJ7M9D+5sgx/UAA+oSonM8CcOCNfyEYwXx14lZnReaUx3tnGkH3o40CsLnE03tXrIGMD24QFWiBRzjy40CbLRT9zlyeXlaDLkQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ec797c0-8086-47b5-bf51-08df1dc0b376
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 00:29:19.3831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2VGP3BXsp8kMmMv5SD++bS2i+lTdl4/NwrSf2PPs9FsxqzAOSU3LgJ+I1JDlyOgxDSRlceMJFtiiY4FNk4OmEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7722
X-OriginatorOrg: intel.com

Sashiko summary (full version: https://sashiko.dev/#/patchset/20260928221509.68002-1-tony.luck%40intel.com)

Patch 4: [PATCH v13 04/25] x86/resctrl: Centralize monitoring feature enumeration

	Sashiko thinks I broke AMD & Hygon by adding the dependency:

		{ X86_FEATURE_CQM_LLC,			X86_FEATURE_CQM       }

	and this code:

		> +	/* Any monitoring at all? */
	> +	if (!cpu_feature_enabled(X86_FEATURE_CQM))
	> +		return false;

	But Babu said he tested v12 which had this same change. So perhaps bogus?


Patch 21: [PATCH v13 21/25] x86/resctrl: Export interface to report telemetry unbind/remove

	Sashiko says my new locks still have races. This one looks real.  See below(*).

	But also a bogus warning that intel_aet_read_event() may be called from
	IPI handler on nohz CPUs. All AET events are read from MMIO, so can be
	accessed on any CPU, so there is never an smp_call_*() via IPI.

Patch 22: [PATCH v13 22/25] platform/x86/intel/pmt: Inform resctrl when MMIO maps are being removed

	Bogus concern about ACPI telemetry devices. They don't exist.

---

* I asked another AI if it could fix my locking issue. It's given me some
  slightly complicated code that has some scoped_guard() bits to hold and
  release locks. I'm staring at it now to see if I like it.

-Tony

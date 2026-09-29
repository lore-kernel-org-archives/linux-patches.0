Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740023D47AB
	for <patches@lists.linux.dev>; Tue, 29 Sep 2026 19:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790711040; cv=fail; b=O8JtCL3XVr5mb4/xGu26IZfO8wKtfNGEiLkHRp6rbeE3ck6zDZfLWRKTGEhrisnNeni9HPcSmx5oD77s6zwujtIXPYtO4zCuN0cqqJcgOifH78K6+NG2/eteE5ICAHjKq1uKa1Hi1v/4KcOmKyTSqr14BRD0jp4b3z4dJvrcqvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790711040; c=relaxed/simple;
	bh=riEC/lRFmyAuK/D32G+sFGkoSh9Hto3iKrDIOkPHRno=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=B6hFA3hXCrfoRJuQxBQgqslomqSeYZAfMUh660td0EyTwI+WsI3EWUx7xtaIygmr3cXood0sVNemLQ22TocCuTx3/a0j7QoIgcZ6DnWPYhRyPGOa0LK1iTSQ1z1AFdlcBL3zqukmk9bWil2lt4JPqcVKILQgyBUiG/lhKkd6KOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gUs02GNC; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gUs02GNC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790711038; x=1822247038;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=riEC/lRFmyAuK/D32G+sFGkoSh9Hto3iKrDIOkPHRno=;
  b=gUs02GNCR0mQMM73B0d1zpF1UHWfHdmBNTG0NcRuKKbVj68eptDijplT
   9JIThoxErIpcgfVKR+FKik945HJerqTkLNHdcXpZ/0EiWiO3HWZb670ZN
   bgTrfZw4oAPV1iEq2j2ifGUNNTo89AgVFaESMJM47Tmmq2Ev585AJUcSG
   zX9cm9vzVdNbYbi0dWscXZ9trbIBew+Q/xE6wpNGtbXV4xbqHtwI4SUz2
   BWijg77JpTx4/qJTA9pXB/FGRtxpgqP5c6VPzRloL5MvvVIIZvihyIYJ2
   zMpUBphaaocfPlSykKWs6ZtdArNKBdKYbcvWYt2C8VUbA1EOWMUEr80uT
   w==;
X-CSE-ConnectionGUID: 22uiWF4vRDGlzeiTOYaFBw==
X-CSE-MsgGUID: 0zFgLlixSgWQImHxRRW7gQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="90390503"
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="90390503"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2026 12:43:57 -0700
X-CSE-ConnectionGUID: L5yZvVi3RVK0sxN+55+Feg==
X-CSE-MsgGUID: W9PcimQVSf+sXz0Zn9f7+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,130,1787036400"; 
   d="scan'208";a="273572661"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2026 12:43:55 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 29 Sep 2026 12:43:55 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 29 Sep 2026 12:43:55 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.35) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 29 Sep 2026 12:43:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hDKy+sQWS4DZFDQ+k3/dz/mnfT1ChxFk2LtmU/FbhQ+0FEZJtDLJOndP8hnPaqk7gErDTLOMjHR7JSCBjjpg3zUVLByf8wHYyZs04WS3sueb+Rc65HVNSVzN7XO1r+3ISlrvSyYWLuSP5O2AuUYwP+OpG+o5No7NBFCkyd1WxOIqNtqiPlva99JAy+XvKFDfTpF2adaqOR5A7Sgt0mCLo7lZZYWniR+UzrYQmKfvhmWNQjanIYYEMXK8PKECVv7XwGMbW6mGjEO/rTEs7oJScsDiE11NSJJKwv5rU3fPnFpiOOXHtVuixrZXE2aC2txkR8S0RMpGdW9DEHFvxjEt1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KYjCzAYckoRypguN5cXE+4yx2tPuGS15hJ/3MZK65qY=;
 b=zQSOl+hAIh/oPf+ZtuYrNUAUfBnFiObqFh2te2ZcJun6HwhZHNPf4yxci3bvoj9qjqxh3IiS3qoJbV/OHsfVJuqZg5N+agrspyvIKApWXZqE5IOaZ61nszRV+dslM4U7uxHGiLaHB53xreB4adqXQXvQkCbJqMgBpMfWuTt2H9BnNiUL+0TpH+gWtxavp8+lHOYXyA+LVX9T9Ji5gUp7S2CKjj3q9a0qu5+kuiifrMX5enVa5oHVgSRNFReZCvKKDi/zMIEvWQmsnB/PZdWE66MunxCu9D9EIGsi5/b3S6b3yJIxSujtsPneTo+FI0exZbXLlkBjI7I5IjlWexJCuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by LV2PR11MB370525.namprd11.prod.outlook.com (2603:10b6:408:422::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Tue, 29 Sep
 2026 19:43:49 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 19:43:48 +0000
Date: Tue, 29 Sep 2026 12:43:46 -0700
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
Message-ID: <arwU8iggI6ugi1x8@agluck-desk3>
References: <20260928221509.68002-1-tony.luck@intel.com>
 <arsGXbwHSwqmI3Q0@agluck-desk3>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <arsGXbwHSwqmI3Q0@agluck-desk3>
X-ClientProxiedBy: BY3PR05CA0050.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::25) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|LV2PR11MB370525:EE_
X-MS-Office365-Filtering-Correlation-Id: 09486f96-1682-4065-5f0d-08df1e61fb4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|10067099003|4143699003|11063799006|56012099006|921020|3023799007|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 4x9ul/5mu07mN5ypDqoxvn6QJLsIEfz4xzn9dRxhaM33adaOQ0PH5GOmue9ajVuJgcs6U7BbXw5QFespjuRtCD/cOikCiVgAfrhPto0E0Wk2dp0sbA/VXnQkkwlO3hm6eJn7RFvjS0KL6CFAZt3zromXpcdsdzopMZsDVgJylAyKG6RvPWZqBuxfJyGBjhasG3/yPOMybgSjSan/DFZpoe4A/DgcHeMz9ylzvkNYU01T+KByPE6g0x4jYeLK8JPkjbnTCi4lojE+cZjLTf7lXBVcC3+t0LrUdjCcb+bc4FkH0vbJGCehlRttXQioc06a4NuyWYpWvIPNsS3EsvrTduUM4/luXejvV9SQENhT74NhEvffpVUGkUqraxzRvC418QtlBoX4I4AhJABaQZeug8yT3ZRpWaL5jKGfQT0Ou1qk03bIziZCxiiB8gyHFqoRDo50d3UujnR8HaSF4KcW85ST+klkvK/A1ool6Wp0Ds4L5o108AAbplW1MI3krIDCMM3STD48aVnLY1cNVK0AIMytsphpU1m8IbXEYAoRbjVh5ZPqlTskbTiG7BbI5WZ13nQn6Hq2yuSDdKzo5ramO8HN03AeztBkQF10NgvOcc0TP4FNsvnIEuBUH/Sp6zvNE8Gc93zsCUYl8ETsTT+OUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(10067099003)(4143699003)(11063799006)(56012099006)(921020)(3023799007)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JABI33Avl4gAeUt6Tv2LNaahe65r3MlYEgsWWQwdlivjLtPsZdn62dDjDaWl?=
 =?us-ascii?Q?toRCzBAPS7NYT8rasAiIYrOv6yPfp8lvNsJdrxCy0rkyCy5FvfEIV3USLmcY?=
 =?us-ascii?Q?sOObL4CjM+L7xYnkeJfDCuR7M9bjs5MZl80MwuX5g3rha3MNonpj6pOxsLme?=
 =?us-ascii?Q?vKMnv5XxcRp2Cf9pSeksTTKwY1wZeZhGYWpi4LFHMj9LpDNQt9QtruhcxRE5?=
 =?us-ascii?Q?a3H2vX/Mxl6n2B1saGOssB8mkswifxF/QMyrAHFX8SWgQ+kK4/DP6k9pOOZ7?=
 =?us-ascii?Q?5WhgE9mdJLeg8mx4/5/hm0RpNqgKc0iEnLFAHFLgxsX/JqixeOSoncEeP0MM?=
 =?us-ascii?Q?yQbURZwyMqJdK/nGCtP+9erWpMOVlKgITYPSArF1K6QlOhkXog+6Ob1G1LA9?=
 =?us-ascii?Q?MeOiJeI6JwWnRmCUTKL/s5vrNLziKRkG50wTF94WZ67FfWLHGPER7wSitM8c?=
 =?us-ascii?Q?UEk99h4ZMzhR0vZmqiU0TzBY6x/a9G+MFgC5FrFCs4GVFUtxefv06Q9/0laC?=
 =?us-ascii?Q?pfVL/MipIdNiojfGRGh/sr6flKCCXmnGDpASRGa/+jVJmZTyKvQTCcIk9N/I?=
 =?us-ascii?Q?pWgFjIVxiHJhHv2yeQQCcVNZ50PNzcApQYPpEUM9QYfmdKIetWfIe9JyluM1?=
 =?us-ascii?Q?Yowrsk/sjeGLuknYmSa6yRcZA5ELdzdT7bJbYG9x0RY17owINfRgLBxESaOd?=
 =?us-ascii?Q?CcIFMJZ/pdjkfI+Fq8fwLkJjEVrwQ25DKPi9zHpwF/F9UOXdEY+Ut+c08n1H?=
 =?us-ascii?Q?Oy5bQnNryyr1w8R2dfu65vZFuJkv+swq1Hr1xxaMS2CQz90/wajdWmhT4HpD?=
 =?us-ascii?Q?cPEMNa2pxKEy2kqTv8rix6f5+9LOgIMpSh14EOANRRjC1IAAbzK6Sn2Addov?=
 =?us-ascii?Q?gwudpe4qvX3xgkI1E1eDnwXuZCuFeo1gg/IWyIPvAkX45JRLeAZN8fr/7DLI?=
 =?us-ascii?Q?qPbRuyuOG6bTMlegJzQ6fqwTzxWFzgX7UFfQ/wpGTSQ6I5Z36OdopgQGGOLo?=
 =?us-ascii?Q?nqsk/BJ4+eaTEZ2vmpRvgTnxN7XuIEW6aBddbCnsFgNYxyjA7OYOeepjzQUv?=
 =?us-ascii?Q?gECp0ye3TCp5i3Y0CEkmiICZcwD+6h2yWjXm9yJirrURrIWhmp2zq9IEuP5S?=
 =?us-ascii?Q?0sMi072g8CQbKonlKb1IuSedhcwPQaqxe3gXeocymxAAfAAYFCtGG0+ur/4r?=
 =?us-ascii?Q?L5gcLv18+WiMRPx+E8zXJ4pO6SkNUrBe90gqcgy8GRjHwhZjrPRpx8Tc3I6p?=
 =?us-ascii?Q?sPUp0h9BMFmopp3UIMWFoFKglVXAP6DM99cYK2ONv/n5xPjyCrO7GzeRVoBU?=
 =?us-ascii?Q?eBDGPKDPON4hY4uDRjDt12R5f8GLNJQQQmP0CGFnKwyvBLaNJNrqxEnQ+wfi?=
 =?us-ascii?Q?py0DgHbIFbk83tBLBmQykAz3M2Q4PJFYaOcgCSnoyYbL9NQu3oAn/53d3OLd?=
 =?us-ascii?Q?/Asfk6Fe8x9yh17zqlDG5IpFnorjeQjjHdEhvtjcwTcnr0/rciiVfUX70CoA?=
 =?us-ascii?Q?c7ugKtY5a3PLr6a6fG4p2vW2jaS0eDt2F/EWWaxq4E8AgdSMX0suzuIogh4g?=
 =?us-ascii?Q?Ue0ZAdmmlN8E4jUe1qR5PrP70EenV7cdGcIdNl+HuR1iOOJ187s/QeoSvqZP?=
 =?us-ascii?Q?gZSAlCIdn30g5Yj4+NiiDeAta15IhuP6TI6R7Od70FTVbTbM1p2Gtf/HoSd+?=
 =?us-ascii?Q?exI0metqFJUJ37Jcev8t06qUawgAGsgas2VpDfyktx+siSz5wGBZ9EGsCqYH?=
 =?us-ascii?Q?nYEnpgNk5A=3D=3D?=
X-Exchange-RoutingPolicyChecked: Dbl/LLXptgjv/yBPm8DJe+/s3kUInJIicLbhVFpfhC5ODN3KJDI0UgcZXUgu1EiZ+X7dnAwtQhyeeMdwnXFG2X3nR4hvxrTD+aVqY0jj6AlW6bRO4OTV4V14dpR3xjekbINGruFuuUby8gnnDyD/zMGpCY5u1VxoQxM6DxZK8crd+eyuJXm6ApJ1ZDuzeikcNgmY4dYE6Ts6RNrDP0oLqz4nVN6O+HULixlhgOZmroKpQu+2rDkmzyFYWvU9zS+RN8oNAggrE6Ep2H/BRsYW6Ud6gLRlrE0mriXuS9mOSmFLv9tv5i0XimZBixmPMzn0/Ruwp/6fIF8Ac6RXy1aFWw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 09486f96-1682-4065-5f0d-08df1e61fb4d
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 19:43:48.8685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CPQcx0HetOXazvEkZ84646QjOc98POaRSz5ZpG2nHka4SXr2il7RGGzpK/b27A4jvPGO7zD3Xs/g+ife/WCK7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB370525
X-OriginatorOrg: intel.com

On Mon, Sep 28, 2026 at 05:29:17PM -0700, Luck, Tony wrote:
> Sashiko summary (full version: https://sashiko.dev/#/patchset/20260928221509.68002-1-tony.luck%40intel.com)
> 
> Patch 4: [PATCH v13 04/25] x86/resctrl: Centralize monitoring feature enumeration
> 
> 	Sashiko thinks I broke AMD & Hygon by adding the dependency:
> 
> 		{ X86_FEATURE_CQM_LLC,			X86_FEATURE_CQM       }
> 
> 	and this code:
> 
> 		> +	/* Any monitoring at all? */
> 	> +	if (!cpu_feature_enabled(X86_FEATURE_CQM))
> 	> +		return false;
> 
> 	But Babu said he tested v12 which had this same change. So perhaps bogus?

Sashiko is definitely confused about this. The specific detail from its
report says this:

	While Intel uses CPUID.(EAX=7, ECX=0):EDX[12] to indicate RDT-M capability,
	AMD and Hygon specifications mark this bit as strictly Reserved, and instead
	enumerate L3 QoS capabilities via CPUID leaf 0xF.

But the first part of this is wrong. Sashiko says Intel uses EDX[12],
but the actual bit is in EBX, not EDX. I confirmed that the AMD manual
defines the same CPUID(0x7,0x0)EBX[12] bit to enumerate monitoring.
> 
> 
> Patch 21: [PATCH v13 21/25] x86/resctrl: Export interface to report telemetry unbind/remove
> 
> 	Sashiko says my new locks still have races. This one looks real.  See below(*).
> 
> 	But also a bogus warning that intel_aet_read_event() may be called from
> 	IPI handler on nohz CPUs. All AET events are read from MMIO, so can be
> 	accessed on any CPU, so there is never an smp_call_*() via IPI.
> 
> Patch 22: [PATCH v13 22/25] platform/x86/intel/pmt: Inform resctrl when MMIO maps are being removed
> 
> 	Bogus concern about ACPI telemetry devices. They don't exist.
> 
> ---
> 
> * I asked another AI if it could fix my locking issue. It's given me some
>   slightly complicated code that has some scoped_guard() bits to hold and
>   release locks. I'm staring at it now to see if I like it.

The AI suggestion seems good. I updated patches 18..21 based on the
suggestion and posted as replies to parts 18..21 of this series. Change
log for those since v13 is:

[PATCH v14.1 18/25] x86/resctrl: Use registered function pointers for AET enumeration
	Updates to resolve locking problems reported by Sashiko in v13.

	AET is now going to use a single mutex for both registration
	and in a later patch for device removal. So change the name
	from aet_register_lock to just aet_lock.

	Reverse locking hierarchy between AET and pmt_telemetry.
	No longer OK to call into pmt_telemetry to enumerate
	features with the aet_lock held. Instead, make use of
	module pinning while holding aet_lock.

[PATCH v14.1 19/25] arm,x86,fs/resctrl: Enumerate AET on every resctrl mount
	aet_register_lock name changed to aet_lock.

[PATCH v14.1 20/25] x86/resctrl: Enforce system RMID limit on AET
	No change

[PATCH v14.1 21/25] x86/resctrl: Export interface to report telemetry unbind/remove
	Dropped aet_mmio_lock. Now safe to use aet_lock.

-Tony

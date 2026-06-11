Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828213C2761
	for <patches@lists.linux.dev>; Thu, 11 Jun 2026 22:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781216850; cv=fail; b=pGXWLLnq+w5e82wogrHQ2tX/Y/7LHoaJ5+oOcKNGU/sTVXAZrp5ZPdKhUtJwlkUhaTz4dqiEr4P1xOOf2U+SZ9XT6uYM1GB0JivsUQqCrr1V93qTFY1SHdUZObUFj0eyT7xl03CL7lLnlznz/gLcWmVTUI5UQWaGE8Sp2FXVdPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781216850; c=relaxed/simple;
	bh=lqigDcIWv9UPRAgkOLzqiPX5uqpL1xC8i9/d93Uw2iA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pLvEpR2SOgtCrTEErk6wdV0LsATvd898nOdlmJ4y7ltVuniOI/OnR/5eLgTWVzKcJaQXIpCaoFG6a9Sac3DcsacFqFf3p76xPDFyJsPix9htyhPANPEe1842Ew4+VRDgvylYEqmHsHp9jEc8xnaCFPKQkHlPmTsvGJ0S5SZ98hE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lAvO+lV6; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lAvO+lV6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781216848; x=1812752848;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=lqigDcIWv9UPRAgkOLzqiPX5uqpL1xC8i9/d93Uw2iA=;
  b=lAvO+lV6+G3KFf9aYCOQyikHM3uK3f+Yvq7ZHHAYxLb9QZM6aXXHnYPX
   KwFBKZ37thkZTMgIzfk5XWTkk1bybA2NS19iGo5if/JN0J2+9tQ/OtdU1
   QNmZ1gZzBnDH82qz4cQQgGLkI86SodWwcLn0XJqAlc7dYRWPhM1WU6LRv
   wC879lTgF678F79QIoj6o9X86185uTFhWDkhBSoZLIQC6OUnI+/5cqfT5
   XH8GSowA1NaaTQLEIMFuMn1gpZ4wPyJ3X9tT0Xt51K5gVxzjbWxV3Qq8q
   fc4stAkn/Ln8faJgx6qRD6gBWGFfL/AmzYDRflJMGwd11Uu1YhQKkR+Qk
   Q==;
X-CSE-ConnectionGUID: tVYu2D+wQG+uOlqof/Xlcw==
X-CSE-MsgGUID: IdboGYCRTd+bxkN3p42USQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="81060024"
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="81060024"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 15:27:27 -0700
X-CSE-ConnectionGUID: LKPw/8BrRlqAid1r3SnYDQ==
X-CSE-MsgGUID: QQa/oneTSnGnW17VB7Gldg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="246509468"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 15:27:27 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 11 Jun 2026 15:27:27 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 11 Jun 2026 15:27:27 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.48) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 11 Jun 2026 15:27:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lZJ5Iev5jT6XZ7H97JmE8FSIP7fbvQfhVqeEVmlHE1A/Gj2jxqgTbdqUsc9a2Qz5IO3UJG3QW0znzmYsZcTIesFTmGohufEcyF9wEKiXW9oOAFiHKKPcBi/k8DXtazzTKuDbu2Zv11k+Zy67eeDYaiRbs0PeVsET390OucJK9A8DhsTr5y9YISbHkW6Ba6qnarVBb9bJ+z37obvNJRHSWvAEAYeZLToavfhUccIAGh1jFjMI2gxx0FO4CCx4QJN72dz0jbWPClFs3OeTk17TO0sbrFwhP0podY90PDD1sSStsvUjf1sOWlrhRvWsJ7UgXLN9O++hCok3Ak3Ctrf3+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iNJ+C0wo9yBI1V04KLJXP2FqFOw8gTfgyGCsauUe51g=;
 b=sJTBhgLcjiM0F2OW90LBWNFVSrnoj0XZwf70jA9is1YXY4m3raevl07+YwNcfUup2VVU+0sHSgRpykmXynT1CM1CmnYVlRiVCAr+bVvabrGetW+XMgH9jcRbNx66iU6ziz3+AbtlSHn6BuhZXwQCAaupLYj45/z5SIN/y6aht8/mEI5u97Bek5tfwscr0MFaMADvwkAa6M0C3CqAFDi2y2/NzmTw5M5fcIBl2GD+GHGHpJDsFb/e3t9hsVfaMBrf6pcQcIEjD10LcsL0zycZ1QqAdZDQux40fBK2qBKa+mC9yIU+LjuwUUJnbp7tkGR+yIG7Li9cUG7wbnHv3BFtdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SN7PR11MB8027.namprd11.prod.outlook.com (2603:10b6:806:2de::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.17; Thu, 11 Jun
 2026 22:27:19 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0113.013; Thu, 11 Jun 2026
 22:27:18 +0000
Date: Thu, 11 Jun 2026 15:27:16 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "Box, David E" <david.e.box@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v7 11/14] mpam,x86/resctrl: Resolve INTEL_PMT_TELEMETRY
 symbols at runtime
Message-ID: <ais2ROlQe9JqsN3w@agluck-desk3>
References: <387cc53d-7e55-4c1a-bf0d-635f4f7590f6@intel.com>
 <aimHif2ZC3PIjHw1@agluck-desk3>
 <19f35a7b-711b-43e0-b938-3792ae723a59@intel.com>
 <aimR-7ld7-EE_YCb@agluck-desk3>
 <8ec6b46e-dd18-491e-97f9-04cbba827370@intel.com>
 <SJ1PR11MB60838C247727AE7CC324BB25FC1A2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <a1dd1858-a6d1-4760-9181-ca30de3a1510@intel.com>
 <aingld8Hoz-x5MTj@agluck-desk3>
 <air33e4js_onwUik@agluck-desk3>
 <84004bd5-db4d-4abc-a676-6565abf6320d@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <84004bd5-db4d-4abc-a676-6565abf6320d@intel.com>
X-ClientProxiedBy: SJ0PR05CA0032.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::7) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SN7PR11MB8027:EE_
X-MS-Office365-Filtering-Correlation-Id: f2604419-e520-4924-cee9-08dec808987c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|6133799003|56012099006|11063799006|18002099003|22082099003|4143699003;
X-Microsoft-Antispam-Message-Info: oKrPHTJSYTWdfbLz2YLy+nVuKuekJZty16cY8OFSXhCKIWjwKwIFMg1KBlL/xvXwPgnXp61Fj4vantsYCxahltTrBxoJvDFgWEl3Wvv9+mSzauRe46vf0MMk+S5Kj+2RLfoAm8W/nqsqc6TQeNUxO/L0YkCew7PJPk6zGZ2la/bupog6vyjwTUW4TpZaBh65AySlpPUBGXomnMI3n5S7EgL2rPXoRStc0rnMHE+7bxvWU9JYuvhn1jVODIYb1bUsjibV/MF0QVumxnOEpq2PNhFz2U84VHa0AuyPOH1r/9NsKa1puaJ64R1hZnijk87GVqe7taEGsDVS6z+16JkDHJopA6U2K49jbT2wq3op/8bEHFu/AAUn4n2XjMHQmnkrKuWGFUtbHMoc7b7UGsztjb7qeZlWAUcPc7xC2l9iMFPG0LgzZJHvLyfTz1D2ve+qC9gig/4N67ShdfnmBj/ChpU4iWvT6Zz12lR4qMIMHNW0u82BlECshmAN6saPzOIPP3kb320+wbKnydlbRMR2aS3IOBsNrgjxzp/SO2UjkYDGx+GmskwoMxbYOs7BNinIQqg9US56zPj860wJLVmTz8lmpzXAiSH24rzATjt3dDe1n/0vD32ZmRri73uAKqD3fpjPW8FPFpzolD30IJaANVKSnF2GC5bESAhuzo9E1abgiov6sVECl1S7xbz760OB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(6133799003)(56012099006)(11063799006)(18002099003)(22082099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bnHdBSuOf49opnPe/MMEJKuWisyf58VM0SQSre3sMh8w+IpYlI4UlFwedmlX?=
 =?us-ascii?Q?5559RxGfoDkAc6QU3EWKXSBr04XgohhUd0VXthoDeq+kX8bMbBwd1SG74UOk?=
 =?us-ascii?Q?wecBcQInwQBaGQS51HSYFJeC51VXW83sgGMCXoEjWnMqIraXVI8/v0lF/tTt?=
 =?us-ascii?Q?JI0D9/YU7y/hzx+XOAlMtElMkwa3iGeL2Ij6Y4AjgtxsCOKNO9LP8bYg7q9k?=
 =?us-ascii?Q?rLrW8K2bpM55jWug4+r4TJ47n+0mWIYxM0bfDDKCNicAq4JevzA7bRzfYVKY?=
 =?us-ascii?Q?uEKIBlTggir4Cda38AErkJ7hsGheXJP2b5SwEvauA592/aHexksFtXx01cEe?=
 =?us-ascii?Q?5nEGvVwCPj8f0AKDk/W/zxtReOcNvraORlE4TwF5zv2wXOvmWueccW3KFbBb?=
 =?us-ascii?Q?x1mx05uXJ0ap3ol9UB9cAyA5T8IpJuzjKMTp6JX/XMtt+QXICUuVDXCZDCu6?=
 =?us-ascii?Q?+S4HbveVBixWQdLHc78009nVHi3AJwYoPypbEzUlCyvLfORrvGxjdJ48w/IH?=
 =?us-ascii?Q?s4y7vZMoOryXupQ7UNyCbny7k+CgyybYcmuLunZrKMt2iPAjNXrieg0cJxQb?=
 =?us-ascii?Q?n+CfvYBQOMGUndHGRPjIWhNJGNtqACLPzXOMfTemIJP7uxZZGgZoAPrjjfbF?=
 =?us-ascii?Q?2xdxh7UJNzj/cCuYsRexayU61OaRUASAIsw+VcDUcd0/zRZeWFzCLrW1Em7w?=
 =?us-ascii?Q?NGpFpztl3L7Db4t3uTy/ToakNuLklz9Je1rwqAcVht4o7ZaUBGxBNt24g6OC?=
 =?us-ascii?Q?FIJJLz8WL8dVUAaz//aBRqPAeOW9vdwF3q+54kmwteNwsVxfBgdaIcl4A2vm?=
 =?us-ascii?Q?mQJkJ0jcdrn0UtsjyY/s396nbgMhIWBhpZAsAUmnTZe1tTzurN5PXHD559eS?=
 =?us-ascii?Q?fngwtmeSInGZ51jhmRVCBB10/QKMrjwzvhrG+jMzsg6BdR/nxj1UQEAPtpKw?=
 =?us-ascii?Q?m+AOWx7v+lz7hOQt2zYHty4V6wrl8mReN0DLdW0tdfOiQkdPXkPfxDpvv6lF?=
 =?us-ascii?Q?tZkmjKAc6eNu5a7IbaZTxhqNhZpFt5PSirMk9gLxctIoA/IPm8K3iFzwS9Qd?=
 =?us-ascii?Q?lmIqGJCIdO87OmV/FA3mG2oUkILojl0CJhKOwukC629v9hovP1Laoj5BWrJb?=
 =?us-ascii?Q?zXyuycmxZD6XH6VI2RcTRBOvwTgPzE4UTceYpXHd0aDAPCzqfnLMOIfk6lsF?=
 =?us-ascii?Q?5iSUf49IUr8+2l8DHefehXXzg6H0Fl27l04pz4kS8lSI/AE6y+DWeGI0MzZQ?=
 =?us-ascii?Q?2L0aottb+qCLDSkhEFQ0K8zJn32F5kmvACPv9KUNVXh4nAz+CACJwNqSca10?=
 =?us-ascii?Q?rQ7Wvfd0GYE8h2AhN015EH3otaI8VH1qo1gppcdPLW6BdZs0tyDzcgtBy8x7?=
 =?us-ascii?Q?00bqWxDhy1QWItBwCcHbWPrmtkcYPpUCHrTVYuXlOBn1EvxT924jSshmfySP?=
 =?us-ascii?Q?8rQoZYjq+xKdDfpkO2OJ1irq3/eF0tdAeFs/w4nvBngEgHkzYs/H5ZPEbc6A?=
 =?us-ascii?Q?Gv1d7gN21CyJPWHej1eO5sn7tYQhPETs708wnv7empAaz397rIvi1jfAMpXQ?=
 =?us-ascii?Q?eupyTsbYzwvg1l4WVFaLVrdZEO3CZH1xG44rkNPOIO7rcpQ6/bepzKBahHOw?=
 =?us-ascii?Q?A3Blqb3AtmJ7FNK9bOH0dRAGbyz3vEi7ye4sdpIIjMqD397Byw4YUEb+6DUM?=
 =?us-ascii?Q?HIpBM3u2XYQLTeMnQBbFtp+SK9TOtPbxIPvhJlS4QWmuym6AKMTgZMvKiuBg?=
 =?us-ascii?Q?ENMbLBVe2Q=3D=3D?=
X-Exchange-RoutingPolicyChecked: AQcEGBqcV3nUDfGgWU27heRp5+36ZRqZdx6tZvebI8OIQ5kjthMWd9EFXBC0O7kaJNip+vSChg9Cv9+4LiCiG6NMZ0Av26AvakSEkMgv15jbeq4JJHDA2Srh4DhZ5KNgmdsL5nEOlYDclugHQvz9RttYFhOeB5xfYUnZ8JgyqdFPXPOF0Fys/0ql7u7+bLr3+llA50F6zJsB9N+ZeB6dvnswgseqkN8jRgyKPPpZryyUkkqwIPVx7XO3STgQ0aut8HNG6tcv+SRwtECs8vl3KjwN2AvMca2n3wOOw9kmRENDUAgT2w80fIbf7Uq97190aA3Rn7430LCoOHTZnH94Xg==
X-MS-Exchange-CrossTenant-Network-Message-Id: f2604419-e520-4924-cee9-08dec808987c
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 22:27:18.1628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DAm6H/uxgE+OCdoz+8Gw58JLrI1YGC6fNmtEpVWxszwuklEZafWXFuBFesY4NPtX4FcYQ7E13FPEM8nUHaFnxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8027
X-OriginatorOrg: intel.com

On Thu, Jun 11, 2026 at 02:22:23PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 6/11/26 11:01 AM, Luck, Tony wrote:
> > With renamed variable, and comment. Is this clearer?
> > 
> > 
> > /*
> >  * intel_aet_register_enumeration() provides the value of "THIS_MODULE"
> >  * from the the pmt_telemetry module. Note that this is NULL when
> >  * CONFIG_INTEL_PMT_TELEMETRY=y so it serves as a flag to decide whether
> >  * try_module_get() and module_put() need to be called.
> >  */
> > static struct module *pmt_is_a_module;
> > 
> 
> Using a single variable to contain both data and state has caused problem in
> the past. Could it be helpful to create two utilities, for example get_pmt()
> and put_pmt() although naming is not at issue at the moment, that contains
> and makes obvious these "is INTEL_PMT_TELEMETRY a module or not" checks? These would
> then be no-op when INTEL_PMT_TELEMETRY=y. This would simplify the code in the
> callers by containing this logic and not rely on callers doing this check so
> many times.

I can code this up to see how it looks.

> Even so, it is not clear to me how the AET lifetime will look like since 
> INTEL_PMT_TELEMETRY's .remove() may be called at other times so resctrl
> may need other hooks that could replace this module handling.

Case 1: No races

Resctrl mount: intel_aet_pre_mount() gets a success return from
try_module_get() - so the hold on the pmt_module will block the
kernel from removing the module (-EBUSY).

Case 2: Race between resctrl mount and rmmod pmt_telemetry

Mount code gets into intel_aet_pre_mount() and rmmod gets to intel_aet_unregister_enumeration()
where both try to acquire aet_register_lock.

	If intel_aet_pre_mount() gets the mutex it calls try_module_get(), which
	fails because if the pmt_telemetry code is in the .remove() functions,
	then the module state is already in MODULE_STATE_GOING.

	If rmmod process wins the mutex it sets get_feature and put_feature to
	NULL and releases the mutex. intel_aet_pre_mount() runs and returns
	false because get_feature and put_feature are NULL.

Is there some other race condition to consider?

> Reinette

-Tony

P.S. David Box is OK with setting suppress_bind_attrs for the telemetry
driver. So that will make the unbind issue moot.
> 

Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F62425CDF
	for <patches@lists.linux.dev>; Tue, 31 Mar 2026 17:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774978125; cv=fail; b=hPhoQmS3ydd1z+yI2rJFxwR3GwRGw4c5OAxGAIV4M5T2kVId/390Dz91+GZ8fxlFpPuQULUr5L5azZLiBnsHCHsmWq+qhNwIaumSzbyG12J8GWD/djBvAdo0IkV+bSvJdtYkbpT+QY2WkLDQ8IKFGq93RDl1LHT9nBbP7IbCmKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774978125; c=relaxed/simple;
	bh=DtD1tj3bphYP0T5THvOapw/BW5RBRtH66dfkY70rsKE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=n9GKKFYjmPNpzeXeNgB1bAovMhjicOpvrAraa70lDrAvOYRQa7SKs/GgGIhootRD9RJ8JY7IGUJzEO0p8XUvu2eyqeAzO4p+b+dvyRCsnkPprPpHk4czVzeNoT7AcSZhTOwjNOFbkOghcAUVTgweP7M3o/RyUaZzoltYYo97bnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LcY3GkZc; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LcY3GkZc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774978123; x=1806514123;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DtD1tj3bphYP0T5THvOapw/BW5RBRtH66dfkY70rsKE=;
  b=LcY3GkZcx2Ob/SJxu8KOtG4lsNS66VUvZsddyc/z6mXk1AB/M4QKG5xo
   bcdDuTHfw3oqQmhOhYooeTpO4rEtF7/e6gGeUbQq276RKFuwpQRLj93CE
   qUAx/lYt1jfCrOsQ/DPNfRLhtrlUaiBlue/4+3NefEnWzh+8k1ILrUoE7
   rd6dfCnmZV+LKkZA6W+QH88yqKCaGT5rakK+fTN73PG91FebWzDD1rvHU
   lQBawGHtZVU/KVmXStm7G0NHeB+4rJkInQvzqdo0RcD3B9xVmPrm2uZxs
   wsDWm1KoMW70BuesXKkcFfAWg5webORn+ofJfMx5qeIDoxfLrHM3qPz7N
   A==;
X-CSE-ConnectionGUID: 6gJ4IwJdSnClBDaWVLwtpA==
X-CSE-MsgGUID: UqVMpbh2T5+4BMRo9FdI6w==
X-IronPort-AV: E=McAfee;i="6800,10657,11745"; a="101454389"
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="101454389"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 10:28:42 -0700
X-CSE-ConnectionGUID: LaQISuAKTGe2/HXFpXUydQ==
X-CSE-MsgGUID: E3SVHazdRfW1V4V+fD7ZxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="221569455"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 10:28:41 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 10:28:40 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 31 Mar 2026 10:28:40 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.66) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 10:28:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sw3eSHHwcG8TX6P7b10VkyoQzYguiTL40Hrlgr5ZyaKVdbr3TLqCsDdxwwHCqEtXQ0ylf3UYARBFh7NNT6rLVAAD4VxOISVYRblgyTqa+VboN4Pd8gycIqzF7DHprBmpZw6RNg26RUKXmiydMmLYCEndbar+5ghQhpZzbtl3Kl53kJFl8quqos23n57VaM0HfLQEfcDZWWmkaSVuNvxdhD1/yPLPUiwxCJ/MxkFbaaMT+w4nk0VDBOsb4OsqTEgZLdzH4xZwU5axX83Z19odPa6Cd07kA2BftEzH98SD9YSwsakO7Fsq8+GR2I5Q9BvBmUcqEhPDuyRGsINtt6onrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=br3SwUgtzsyyeJtfbOniumCsD1e9cE6Soqvv3b7Dya0=;
 b=QRBe2fV5TE4CKryrTVkhwHZ7PXqYgd6BPMg/CA348x62HQXAEwOTq2L07MYdY4CF7TVOtq3A8PZq4VcUqi9d5yPt8+iQP2QY3jYCNOvUAIScbkHK9/EVYPtri6JenNLMkBiK8f9uysVwZHncaAlJEEebnhag+tOlVfOYPY3LU9VR9AFp/gzjrdLEc7s16mw4MJVlcQCk9p71IFli4sXJZ0w0ETY3l4lwHOncB+mzk0d/sAJ9vSyRiHf0hrzUPzkoyUb8cUDU7QKU0dP6nTPtCHu8bO0yn7Fh29MXJrrU0Jv/uUHTdBeuUdV1lGBbAQx42lCJ76Gz7mcDVvZkMjOAuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by SJ0PR11MB4928.namprd11.prod.outlook.com
 (2603:10b6:a03:2d2::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 17:28:36 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0%8]) with mapi id 15.20.9723.018; Tue, 31 Mar 2026
 17:28:35 +0000
Date: Tue, 31 Mar 2026 12:32:28 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, <dave.jiang@intel.com>
CC: <patches@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<alison.schofield@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH 6/9] dax/hmem: Fix singleton confusion between
 dax_hmem_work and hmem devices
Message-ID: <69cc052cc601b_17924f1003f@iweiny-mobl.notmuch>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-7-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-7-dan.j.williams@intel.com>
X-ClientProxiedBy: MW4PR04CA0108.namprd04.prod.outlook.com
 (2603:10b6:303:83::23) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|SJ0PR11MB4928:EE_
X-MS-Office365-Filtering-Correlation-Id: 45b01a9b-194f-43d0-0069-08de8f4aeffd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: G8R+HKBqnbNYe1O8fSatnEttZAwUJqGhUVtNyLa4XQo2mzjGa862YB2VSYFQdKFTFsLovVagW+7AdSGmm68dlinPNmr2aiWibT2s1suEo2iQzvNKP88Nokz22ELf2S5jAGG7TyTcRQmldF9xS5iRbAlvO43hr6v86hM6xk1oMET0a8GCYnrq0W6HIQ+4orvXGStbR5owbPzsdxCMiDvqvyxdrF6+d6pMfoRmtgPK/HvNNml3v8fwLQ1LGCBV86ZV8wAbDQoWwhFFgTWyqB022+d8fAtFo/3lY6os4ccD1QsWcjZet69bXzuRLmgNwCbA8tGnrYBxwG0VnBlcr1Yhf/2reGIrGkeGe9YS5UI8RhH6EHZW6f+1EPTihq74h1YMvZr2YpyM3pLvDlXQn03ttJoikrnBpEqlOWY7+ZrVgQm/rVQxYy9dkTimSikEHFujfbzbkk44WENI9WSF4CZ+1AUJ1Rc53D+CQ6Fax7MGGXnxn7JkTIkglAL8v+wPwK3E/BwQW0ORKrU1HAI5f0zJkzXFt9mabwEBiPuMV0hh8wVX0XRtMaRz5MboaPcWw/Y1aL82Ed3VdZE9o8Y0FQJ/m/DCHndFG44hL8KMXOdTyA7NaM+p/Y2AvJ06PCMOvXRoxpf3ZDysIedcj9dzjM0sTtl3ShaZr2I+LkWBMFqDsssX7ZyED3wejDGWwZymkZ8Hv7qZJ6LPDlGKXlnhDqO7bi360EmY9bP4bd7AxrmyipU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vvva7vxEsIrN9C2kMlmZRqgbXx+mvvR6BZ8oA5gSchfF6kcEhb+1Dm16V0Cp?=
 =?us-ascii?Q?oGJu+UQyBrT7lkNZLatrxn8CRA9zD3Ndcj2tjZcZqvK91mE4cDLuGt7qcSqm?=
 =?us-ascii?Q?8rcHGLAgOcMOEX3pLax6Uk+iFNW5/492Mqhk7cfRA44AZoTjU1ypNZJXBAuA?=
 =?us-ascii?Q?n5dOy/2CzHLP9LDa4T5fZmtUP+rkdpoM3g0+eguo+7DiXQk0/wUEssoLIlwG?=
 =?us-ascii?Q?gDHLjFGgp1Uu7oa7h14j9C+ijaWWA1JhuFUPeKrssZ+3lau1d8D9V2ABgtj2?=
 =?us-ascii?Q?Hze2qtYNT/QLIiXIup2pkA5y1JUo71h7EP5Wfw+yiJb7p10s9p5m3n9LrBwQ?=
 =?us-ascii?Q?Evm/5LbO5n/Sh161fRWx8w2w+lGn2oWTSlDUKoFx2swd3tj5CNpW5S504H6t?=
 =?us-ascii?Q?7i3x1HmtjWd8DeTGSzmlV69bb317LaX2HN8voA4I6RR6wXYsi0IdCF+Rc7+Y?=
 =?us-ascii?Q?5tBUJtdJqvBHue39QX95xZhd4TB9xeI2F7V7ytLgPC0loyywvA229HStwyha?=
 =?us-ascii?Q?QMii0ccs2m11Rr8b4udfjrofVXA7TUgpkhPF4TzT6Iz9oouZSaa/y/CKmb9T?=
 =?us-ascii?Q?nYkvhzDpT01sd+HgcjEgRxvNALfzGN9iLjMNtupDTmFYy0CfTYkEKjh89KZa?=
 =?us-ascii?Q?mWkY3/DYa/73M7WhB8UJVCdpNUliREgAb+vItROZoJC8DscfU0u+2eyWZH5s?=
 =?us-ascii?Q?b9j7PT+l7ZgP7NXyVHii7pPmIxhTnKcE3bjiE5FqpYdevYgn47J2bFN5S0/5?=
 =?us-ascii?Q?Xs/q/VyHtNoPOj7TCS1Wzcmr7n7Y4sXV+UZN48uP6lV0QlSs3OsL5ICqF7NQ?=
 =?us-ascii?Q?3pfLj0pyIAmmTltmHRL+jJuBIxh2DKC8oSmlon2A9qpgCgR0vK30ItANta9P?=
 =?us-ascii?Q?tuAK2SimbYL5uVBF2HlmNtNvZ6fcXkCFKV4HSubOtLsd5/y5bataJImdC/cd?=
 =?us-ascii?Q?QGGWlxpFR6KseXJx/0eIioailhtoiSs8Surr8V9s34w2fRJKHC4cXs0GYaVx?=
 =?us-ascii?Q?P2V3e+J/xLpkMCxwVEw/sfnRRYch4i3Oqq8/KLFRhwLWqv7qD2zTDzcM8NNI?=
 =?us-ascii?Q?bAs6HTle7NQq096v9CmtdJBVCCk6jvf8HHQwe3Pojq1dPXPOjot1CkLbGUt/?=
 =?us-ascii?Q?wqcJqUBGNeZllyTp8FrmEJWYjdRRffP+nfcncdIxO8D1gcwipmnP9K1TddNW?=
 =?us-ascii?Q?rFn0o/AjOxkbvi38VLTN4RnOHSjkGJfs938wjngkRmAMq3EjePYXNq3JBlST?=
 =?us-ascii?Q?kgnpXWhG3ymT1TlAuZGSsgeSQPrvKiX56xSH2v6ue0K63z47H0cH7LgejQA1?=
 =?us-ascii?Q?iojfmKhIbT55nLDgqEoqv6TG2E9C7Uwpp1BxtZ/pmycBOEJbX6NLuqjlAD9Z?=
 =?us-ascii?Q?Ar5UHBsIATuJ+nabO/b3nP4X4IFOHh3F98k4GHUCTUAVEd2UcoNwlHdQ6n5T?=
 =?us-ascii?Q?J7JOiKFBe2IWGwbUga49GKvn6CNQzzoYWBS1pBAurUBKtoHtg9qWwyCdDqQN?=
 =?us-ascii?Q?aqM7tlZQpzMFPI0HqE21xMOPAp7/D3NW+4am1ICVYrs2wk2JH5XOcqCk+sD4?=
 =?us-ascii?Q?D3Z52Rov8CYTm6pvmMZbgCPzEqSL1MwwB02aITPZDYVICPU2JMl0fb+25C+Z?=
 =?us-ascii?Q?qpDGrIqSJXB2ngqIMSvxnwPSUXCxTIqIXLUbZIcl34lKyB1W2rKufwjorZgr?=
 =?us-ascii?Q?buwzQ+Bybj3nMY+rblQntvgupH2Y2duMQ1ZadF20r1+A/9QUXef91hpquq2T?=
 =?us-ascii?Q?3C1sdRT4bg=3D=3D?=
X-Exchange-RoutingPolicyChecked: dienlJP6LqixKNv9/vAvrWEXdRoWBXDfeabP1aQZMm34nUF1BITt/HtJTMtAdquzX+xWD0Sne+/XlgLsju7r0+JOeImL1twvQDkrceo1szKrKHgWSacwW6+3WFbi33oqGlMphXTEOceSjRqihCVNF1/3OL/PZXrMrT49YsfL8TqD+balZ2g/ZxpLY2Iiky1v3OiDMtR1xG16z3DACTLF2zByYRoADwEjWxlz+xwKWE92ezoonUbOqL5yVpvck3hdbaaduyCTn5O6KWKXp3hunZvuCfgDHEfM0ouY/oo8jFs21zRoGDnp/k/K662Tiu7oQCxdgnJTBDnZvUtEJQ0Hmg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 45b01a9b-194f-43d0-0069-08de8f4aeffd
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 17:28:35.5951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q4JWHINmmeY6wovAz7tf4Fp0mVNDKqtmfHg/bKpu3ZCMpaOiOWLsrNkj3uCwVrdQSNmbL3bgZnvXUv5tXERitg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4928
X-OriginatorOrg: intel.com

Dan Williams wrote:
> dax_hmem (ab)uses a platform device to allow for a module to autoload in
> the presence of "Soft Reserved" resources. The dax_hmem driver had no
> dependencies on the "hmem_platform" device being a singleton until the
> recent "dax_hmem vs dax_cxl" takeover solution.
> 
> Replace the layering violation of dax_hmem_work assuming that there will
> never be more than one "hmem_platform" device associated with a global work
> item with a dax_hmem local workqueue that can theoretically support any
> number of hmem_platform devices.
> 
> Fixup the reference counting to only pin the device while it is live in the
> queue.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]

Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288DD30FC19
	for <patches@lists.linux.dev>; Mon, 10 Nov 2025 16:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762793579; cv=fail; b=tfBcUeBJpfHSfSDJDdCZ9AmT+uR2ML22yfI4FFCUXzV35S2Z8GlDSVWjqEC2jv9GNJ912m+8nk/uZTNWaE7ON8NHkiADkb3I5Y2gKzjkp11OaxwXFxJ0B6fLnBoemNAUE4Yy9zKx+y057qWeIDP1Iv2unGXUaP4U//s93O2pDO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762793579; c=relaxed/simple;
	bh=9CiON6S2hmEazkxQQJILAXhLPTKAEAWNBOzHlaJI3U4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=k24iNuXgJBvPsmtkqj/sVSSVxhdYfiis+8j8tumInjscuOuxW1cdGPJYZYg35wqELIuZuzQ3+WK2q17Qzl4RGPEgB2CIwKFH3RokrjPOkPG1n0fF8SV39qRmeIoNlcpj+MVO9jhZBQZJ6V3uURot5AHrqTJOBsmrqoepyNj2jIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dFMja1z7; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dFMja1z7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762793578; x=1794329578;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9CiON6S2hmEazkxQQJILAXhLPTKAEAWNBOzHlaJI3U4=;
  b=dFMja1z7N/cgQ1Bak/nzsW43Yo4Rs8c6q5boj8Hzqp70cl6z6IqCiU9n
   EH/R/Xsk57IWQSAahB20STRBgDTepv2f18AMn59x1o6mmmeLRmtpHfBwO
   1Da374N+hJIIBCG/vLFX/c1sa09oDE88tWc6yzpNo6ry268MU+tII9f/K
   IrUG5f4pkUiaDWoB1N6CsiA3Uh9nWUOf512mOCWDOI5GhSm1XceqdaBn2
   bT4CDkxPpsRbwoPFJ7SXJlcn+L3G4BHXCTYl0zWRNxNc021/0K6BlJN4j
   Q3qlO67b0lJssOd+LEqu9EqquyI0V1H1Jp1OJ6uwNI8AHyFjvBAOQ/Yba
   A==;
X-CSE-ConnectionGUID: 8khKr7xARSmGR+03J1iadA==
X-CSE-MsgGUID: wsqQ0K8ESuqB2yhDxmHUtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76194538"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76194538"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 08:52:58 -0800
X-CSE-ConnectionGUID: Js4jHAXkTW6u51N/Sb4mvw==
X-CSE-MsgGUID: ShHapXcaQPqXDHUhHV+2Wg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="193099081"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 08:52:58 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 10 Nov 2025 08:52:56 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 10 Nov 2025 08:52:56 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.25) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 10 Nov 2025 08:52:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wk39yeCyyRze4Sex2p8u3HoljMi3kxf6tzDS6XcqXCpUlxf3RJRicFON5afnq2Ef7lILHPEyrphXzjXJicBaQJI4tHhJKzOVK6BmJu9aNmHjpW7JJbINMLBAXJi6aTfw//RUxae3oKxSSgKtWdoaReo7KnZxY1qxrwlaa5rSt2LJOIKNtgByOffGnUky4gLykqahm2PL5Nc8VjXQpe5ZXuJP5CeJXn6nKia5Ztei0staCBrGfPM17nHJLmNgXJB7/riJYLeSYgDyHnhvUN1zXlpszsvknYS3kqNkICzvPue6BVCAC5f9lo5pw/nnZtOq5zK4kz2O9Eu8+vPPmk1i6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6/h8jwaT0QD2/G0/vKUOXO1L35TrxMfhc41DZXFMUCE=;
 b=h4gp/yFBc2wi/7Jp3+mRblXcvryNYUnwwAYFgPe3iRdOS/GSt2zjEYpMioEm9d6/DMO6oZTbU7wcDwJer5JMtJ/SYTUk/O4kqRSB58Fbd+PdmjkUxVwWKnszbM6G4FQ+U6JVsbzhii43+FqCf9JEF5Sr2NfAapA+SiIxAlOkLU4BXaiVjW9qhP30wk9/IVXP2kodVM9RIaxiuu8LHiblKYwOskSJAUi0S3dGOh0n6mNqOK7AYGLAVtHgXqw4i55fmKrD8urZXcZIaFlddATzp1EkflTOwrClIuCMVAZkhkRffnyGOka/zKL+aWgVSpaVOrkj2zpS++0n/IqYby3AaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH3PPFEEDD586DA.namprd11.prod.outlook.com (2603:10b6:518:1::d5e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 16:52:54 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9298.010; Mon, 10 Nov 2025
 16:52:54 +0000
Date: Mon, 10 Nov 2025 08:52:52 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Dave Martin <Dave.Martin@arm.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Chen Yu <yu.c.chen@intel.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v13 12/32] x86,fs/resctrl: Support binary fixed point
 event counters
Message-ID: <aRIYZOm6ZtpQFr4m@agluck-desk3>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-13-tony.luck@intel.com>
 <aQtiSmZ14b+U/J4U@e133380.arm.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aQtiSmZ14b+U/J4U@e133380.arm.com>
X-ClientProxiedBy: BY3PR10CA0023.namprd10.prod.outlook.com
 (2603:10b6:a03:255::28) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH3PPFEEDD586DA:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f08e780-a8af-4308-2b8f-08de207997a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?seRS3QWUpHOxSzJ5MPE7vDgcp7uF2a+aLjNWtw8VOF21XE8pGFC5V97H4xtO?=
 =?us-ascii?Q?6WVpmcb6xhQiSHreb2j+bUHjYPB002BJxN7Q1FmgogHU8PW2KGSBSbqzYyP6?=
 =?us-ascii?Q?if2XMhK0wxurEhbfz/UEbWCPH/Swpnck7vv+Q3PFWcyexLxvBmUO7a7ims2T?=
 =?us-ascii?Q?XTlxz6SZ987CxF5SlmG/slJCQwFSCSyAyPKPy/q1gtcCX8JTbtHA+FflI6UU?=
 =?us-ascii?Q?oCnLBLrQqNG2zMy+qVRO9jY9t7NFoZFjrFCOtH3eT941+r0qVU6NC9LBJq+2?=
 =?us-ascii?Q?tbOCPgqc3LOyBGe00jeizsQDG5GvY8N/wtmVfjqw0QoZwm1076im5A+N88Dd?=
 =?us-ascii?Q?ifYhs5gmsGxCe9AUh1oJV3aLw4Q6/XFAstB0OnWyXpghRYgtSrQAiRCVOKbc?=
 =?us-ascii?Q?IPTh08xAxf6Tss60sBqM/WAcXRhLP3Jd2P5MqfTSBmsCn9DSDPDIYNsl5KQm?=
 =?us-ascii?Q?v4CKEX9fQ2aquJ6c2C5OC7A2qHtzJm8GjDsFSA6L6QBNXJ4RUXIZI6f8Oo3m?=
 =?us-ascii?Q?49c/Gf5okJ1nGRtxEW9zfUKnJD/4hre5vZEQrPBqiSh5ICi3iHD4ZssE30+Z?=
 =?us-ascii?Q?4UyY9m9KcXeHVSIjd+KcPe3x7czNP5Vq6ZOWVHgEobfP9p3u2FTT5CaWqsVU?=
 =?us-ascii?Q?OD0YL62HrNpsWvXzdwxyFSVii24kqJFetAsCpVYcdjMZfxDUyznzcnnc5qLH?=
 =?us-ascii?Q?vtfQ9cJZA8S8cLaNpkhMAzLMzejk97YkaWL3EJsgDYeSMJT+dBGaR4LA7k8P?=
 =?us-ascii?Q?Dyq0HCFGcbsFcCw238qvSXLjdqB0BLEZCuTD68W52JiXQdBl2+mntxBVStg6?=
 =?us-ascii?Q?kz5oDzFkVpOA3LyZRwguQHXxY/DLec5iR28LYFuNVvaeFRwhZUXyR/v3Z1rO?=
 =?us-ascii?Q?xViHm516kG78lsrGzjZeHtMTcYBXFJ9v2rl4wpR9RkBqNXgb31qbwpgXaBV+?=
 =?us-ascii?Q?ctty0CJDOWKWC3MDIeYZt7W7441HyExcDPUxyeJMBI3eevU98yqRDiHB76f3?=
 =?us-ascii?Q?Ft0m27vga6L+eDkzifmYu/KJzfg3LTHM5QEe2yJgPWbhHZTVt/4/w0g9bhnf?=
 =?us-ascii?Q?3wtLvd8opI7FVir7Py9BMn2Pg3tLBJIonVsH+3EarwtpHQ+rsfqHfsFaYYx3?=
 =?us-ascii?Q?R4cgY+ZdsbTB1gP5okUVKi6adqE10FYeGqUV6gWh55fBp0rjenuKoSmsvM59?=
 =?us-ascii?Q?rrduutXHU3fd5duD6pOZOfj3QYkO7pZQdOb2bQeLT8d+CNjHZvKlBirwNdLi?=
 =?us-ascii?Q?dLOJRR/VgWTFF5bPglz7N2vKutbhQ8FugnGQ9gitnjORMDRPb3NmyH+flT/A?=
 =?us-ascii?Q?2322BuagVvxECC0jJXaCeRRQdLNGB/1MflOg+inBKVGmNGK2nmI0exGtJ8Os?=
 =?us-ascii?Q?ZUN/waYvCbSiPSyCpWW3PxtRaG7B/ZWsDA6svAUBjXU55r4xqFCjQtpP0E2Y?=
 =?us-ascii?Q?n94A16CvxLEQWN170us6dGifs0Xuu8ur?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?afdc4shGoXBPlwT1hc5dyErIt2zC0Eel2+4sJt9f+Z+J5/j96EuI8W+nwMNh?=
 =?us-ascii?Q?3eXzn/reQF5ghtfrFQJShUwwtkzkob91kGf/WRJhrEhoHd1vED4ezVBvOm9o?=
 =?us-ascii?Q?wUUfujFvCNPn696AEkq8auPC1+lJiSH4dd+GPXQaWbO1sQa7snczYJcAEwcw?=
 =?us-ascii?Q?BQMB1a20BSL8neiXfY83R1GPNv4P4YnO7CBGu5bZcvVVIbfSbxSHlkC+uJAb?=
 =?us-ascii?Q?JCETE5kLwv0zN6S4yMthZAQS0vWEX0Fd+0wxRQhDyRr6lpC65rR4yjmsw8Lj?=
 =?us-ascii?Q?l7eBJGq78fyyqKBxbozt7hle4HcryJKb7oFTqO8PHaYdf7++D3IY9fD8hQPl?=
 =?us-ascii?Q?pMTX3W4gBEMkIFO0AFNVw9DkJ5CylzxO1COzUjsYM4dbdpYUJxBtNIw//Ilo?=
 =?us-ascii?Q?2GsBndqv5gIlj64NIYlVJ0ZOwvff597mZ9HmXWLctE5r9QDPk7IFVxCoOzWN?=
 =?us-ascii?Q?TUJyuUzNCa2AoZtoVqFTBKNwNFN4L9j9+kFkrxXbAaCqnaRYn/K4YxCShdld?=
 =?us-ascii?Q?xnUHeew23d5Z5SV+OmVRAYWW5/YbyA2IvZeEEAUDiy9WG/75P+ecY4aT4jA9?=
 =?us-ascii?Q?LEqNwqG/5EZb1wax2dNdm753yuZswQokzq+2ZTb6OSGxCvSimQAUb0P0sbuw?=
 =?us-ascii?Q?mIaCpLawVOL+Eya9Hk44Gn65ZzJHB3IebixiTtsHzHxDvu0nZwVAmYbenFka?=
 =?us-ascii?Q?LIskYaG+EMtt3mrmpHCx8jiXf1F7ARiasJZwsSXr44/ndRGGgYNVM4oan9GG?=
 =?us-ascii?Q?aCzt3egd21LttjgnARA3J53+m+9CrCzKUirAbn1JNRt8uLGCtD+AMBMMwRwP?=
 =?us-ascii?Q?qWgHbQUR/QwsBZsyM3vtje7pAwYmL2Qtr1pQjw0oC/PKzNYgQf/tK9LL0NNU?=
 =?us-ascii?Q?eSyeCh0HfGSpNPRhfFN2pSY04J9lP9U3tdTFxMx6MB1dDjIYK9D1iR1VUm3h?=
 =?us-ascii?Q?OFUGXeSGV7ID9KCHUajI0W21vZCo89Nf/RV2LhTkMSGmDGlWKmq4zxUII8nT?=
 =?us-ascii?Q?WK5b/M7Xcz0OeiTBcHiI3EGmp5JC1yBYPgKz9Q8et6bixEn17fPpVkI6jqtQ?=
 =?us-ascii?Q?s3rR47RAfzvIRHKhvIXaVmmaiVnbrefjmwgawyerW01tz51nQSrcKFYbyWAq?=
 =?us-ascii?Q?LCkvIqSgLw9nVMmoGCIdJn2qWdDL37oj63bIkjG7Lso5CQ3XnAlbUnU7p2j5?=
 =?us-ascii?Q?68H0uEefhPQM5w9viyz2qLffabSTE4Rqf6+t9bJi0m9HhVkBDNMNEoPlywjV?=
 =?us-ascii?Q?tK3Emhfu+CM52VFB+/gRSkkEbLQsOknCBaTqsY3bDFmCEyHjZ3KfigKGrex2?=
 =?us-ascii?Q?w7GbhgVHs1V2ayHx8P2aLxgTiy9n2LLt4I3FWt/8lllw8dEWbkskuJasiBA2?=
 =?us-ascii?Q?Hhe/Cv0/+DSZXHW6GVKsglatql01HfJDY27CC6Mp/2bSB0A65v86ixOaJtGQ?=
 =?us-ascii?Q?k+WqBtoCcpgq5cPneTBqM1IwJmZaGys2jO8s/b+Y8KOp8T4R67iZoiBSuR0m?=
 =?us-ascii?Q?kvrNKNmQit8M8HPsyJ59h1BKik/1d4g4vDXc1yaZmha3FC/NIgLzO2/Sgj/A?=
 =?us-ascii?Q?Ju+wP+isHchNKKdhvhjhAMtIy/4kRQJHgCjoD1tS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f08e780-a8af-4308-2b8f-08de207997a1
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 16:52:54.2584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nXw+twsPgN3KCYXI9+uaDdl2nGLJBwF11PjX7gTOPS6mf0eGVXDTCDFhqSt3w+TNgADkgH2/Lw4bLOtrPGdJgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFEEDD586DA
X-OriginatorOrg: intel.com

On Wed, Nov 05, 2025 at 02:42:18PM +0000, Dave Martin wrote:
> > +static void print_event_value(struct seq_file *m, unsigned int binary_bits, u64 val)
> > +{
> > +	unsigned long long frac;
> > +	char buf[10];
> 
> In place of the magic number 10, how about
> decplaces[MAX_BINARY_BITS] + 1 ?
> 
> (I think the compiler should accept that as an initialiser if the array
> is const.)

The compiler (gcc 15.2.1) accepts without any warnings. But generates
different code.

sparse complains:
fs/resctrl/ctrlmondata.c:640:45: warning: Variable length array is used.

I may change the hard coded constant to 21 (guaranteed to be big enough
for a "long long" plus terminating NUL byte.)

-Tony

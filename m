Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E80357A4E
	for <patches@lists.linux.dev>; Wed, 29 Oct 2025 18:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761764394; cv=fail; b=V4R4gYpI/3W+Bo5LLkwTT9eRLvEEdIwuDCBwIbu5ShjpPwC4XE58O8TyelmIY9kJ8exWKKPhx16pIce6Oj83PNnvSODjkJXJnsV9EFW8S0ZIjQFcYO6BkSDSl40cCvuji5eqNOoUeXyPEhNQN5ku3nY21xS78DsYgoFOV6wfSuY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761764394; c=relaxed/simple;
	bh=MF7+6BXgpxZg8s68V8kHC6JshGwfbb8tHl3PQNnbLGs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LwxrCQ+wYs9hRrCinMUC45MSUG+XDyp1Kce7nDWna/RuMU+OtAM/9hs7lOmiuY3nIyiVJzDCpOEGEUCyb7uAPaeqNyvoPpJ2wIOuSA4Ud1GHhVzw2vU0QHqSLpiBG6kZZs6J/yY5VI3Lhm5Nyl++C7MH2/4btDTbvzlKth37+zo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EewXO4Gg; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EewXO4Gg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761764393; x=1793300393;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=MF7+6BXgpxZg8s68V8kHC6JshGwfbb8tHl3PQNnbLGs=;
  b=EewXO4GgjL4vWyE+NyWicSJyTvDjeFp9A3f/Yq/MflVqTw2jb2eTG3jE
   RGjKHZ0ZCE5KawLBchWUyO/0x86bpjOQH/tPF0sjcmcAHC7VCkDxJvFRO
   6YXUkI9VtJpa5lcBfKd4CzEf4xu9Tmy4lhiJN7GX2/qn3ckZHjVlAiloJ
   AsxjgWEj3LxA8z1I4zfzer+FSucf+7xcC9bnjd05imsPLEbw0JNOgDQTX
   ORzBW5p1KbYXZCQYMxm+Pyo4f9Dx4UJaleUXFA7mKe+mPliI6DocBwC4V
   W19pnkxwJKvkAFFkSsuQ9O4sN6QZtp7aRh/JYmdF7Y2lC2Yz1HbqB6VVZ
   A==;
X-CSE-ConnectionGUID: bDxn6s0TSAmCs/rR2EbOMg==
X-CSE-MsgGUID: xGLVb2uUSyutP1I5ViBvsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63801276"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63801276"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 11:59:52 -0700
X-CSE-ConnectionGUID: 0YG2hcBNSLycN4NDsM5juw==
X-CSE-MsgGUID: JMGkiqwTRFWijVVZIP4pTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,264,1754982000"; 
   d="scan'208";a="185674992"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 11:59:52 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 29 Oct 2025 11:59:51 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 29 Oct 2025 11:59:51 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.21) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 29 Oct 2025 11:59:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yZLfIXY4WqAlE8vmEnXEb7Rj1piKsV+15beNAfJ/SKsxNMG1R5w42c29mXZhow1UDdAL/g1LNaZ1zGeJTPzh/hggb1T2Edzihu1vDb0YD/HTloFPAny/2ajD8AhcEl9toCrpifsUhakigTJkRxLAUOCdGKNoE30x3uliX8rc/ZEuC7EMJ9Z7X5gP+54rJ2GNxnQg1GhP64uE5UKQHY2fVk4MSHT1Y/5xagfCE+sw6TTu4CxsF+pN29YWdUsJOxaLtoORQ6LLujnDE+azzL30kK7QUy0Wwx9PhH9NPJHnBSsh3fDIY1ixE7zkiQGusPkfbe5mZhSjCUjhU8+VEegw2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MF7+6BXgpxZg8s68V8kHC6JshGwfbb8tHl3PQNnbLGs=;
 b=D3zSgkmTBrXqpfOOYi2qBPGgas3h8yRWavKllQYrfBqTzLj6rf7B77Hm/Jc9B4m6h5CvKQWcxGOlwRE2WVpd/havaz9lGsZmnhSpeI3B63fFVvRkqcpDdf4AKPD01G8ioTtVezI6pS9J1p79rreyqpnzKOkA5YKR+aIHDFmSbnxoqaOjydccq2t6bNSO7/7/1FaBT1AGFs9/300hAh2412GZm8LyzEdwsAY7IRf/Oo0FQextGogturvlDb4xisGm6ejqEDjEmELcZHeniX5dCttgrXTwksH+MopvwZ5+eqT8i0R0MjM/+7sjWCoN8eXChJo7BwaY004x7LAPTNIGyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA1PR11MB8247.namprd11.prod.outlook.com (2603:10b6:208:449::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Wed, 29 Oct
 2025 18:59:48 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9253.017; Wed, 29 Oct 2025
 18:59:48 +0000
Date: Wed, 29 Oct 2025 11:59:46 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v13 00/32] x86,fs/resctrl telemetry monitoring
Message-ID: <aQJkIqj--nHzUzUb@agluck-desk3>
References: <20251029162118.40604-1-tony.luck@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251029162118.40604-1-tony.luck@intel.com>
X-ClientProxiedBy: BYAPR06CA0031.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::44) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA1PR11MB8247:EE_
X-MS-Office365-Filtering-Correlation-Id: 338bfe90-763c-4cff-5be9-08de171d5529
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Oi8jFPu9o1gNWFV9JGU+bv863qqY4Me1ao8R2IsUQI2HlXqk/7qsl/xtOjfc?=
 =?us-ascii?Q?m9194b9JS8P4Ms9OSmXLyRuyCImdkCgxjJL2y4z6f/v/jfByT2096t1e7Qrl?=
 =?us-ascii?Q?Cv0fvLKzi4KIR7fGDQbQkxgLsjhkVV0ZPx9jdUkBFkpfl4yZVcavRDxKHjfj?=
 =?us-ascii?Q?15n7vO4gJQUmAx81nW4brnj3N68+TFr9BgTFc3JCQiXGnCahujXPFc20y0h6?=
 =?us-ascii?Q?OGJD87ZAotMlFwH4at4Ef5UirlbumyT0/CDW5jfTKge9zmnEy+CvX7KOjPRm?=
 =?us-ascii?Q?wuLm6n0DJ+1coV8UvNBsAjniCbn9IaVias2XEqcn/tk2cY+9iR7x4YacWIpt?=
 =?us-ascii?Q?2jeOX9Ie3UxB63fj4QJx8uv/awxLmbr+6WEzlaWr9RBrH2KV/uHBWAveTicv?=
 =?us-ascii?Q?nrRQFTMUgYNOR+IV/SqQ6wktCemQVGv4okCezWwkrW15G29XEXr0tXH6dFKs?=
 =?us-ascii?Q?TTiKeV3ngiAe8y6+UpVaeyGp669Bw5dvWq4mqrfWIZKMrZoc9Ypj1Ev1gnFP?=
 =?us-ascii?Q?WrcMDp0C6XzL8WVudo7wapSJNQw0ImboxC5tyIIkR9kNgzwI+AMXVrnh8e9a?=
 =?us-ascii?Q?9McGq8Et1b16AO5CI8h1AvNNrh4MJpzjKApwHweaE78CKi7GHDolulbtb7lJ?=
 =?us-ascii?Q?RVsUYEAFK+/N6apkD3WRTCQFFqSYZiB79QtWGkmIKS7FXzl2oNrhMi+I3HWA?=
 =?us-ascii?Q?gWIVR1YnChyApcEUrbZhJERBXifjI2ORWNYPL6vR/QZ5dRIyVgK/aMgqFqMI?=
 =?us-ascii?Q?vilW355bry+8pi6SiwwyES4ArkYycaVn8+mcgQRjJq5zlgSXxAUDVQZUqB9k?=
 =?us-ascii?Q?n46wuezLMU57s1eNstZUUnPoFpuBXasKmbXukCH+IpRJTm22L8C1pWpi7H3M?=
 =?us-ascii?Q?IsWehlPI0EHxd2iUNQD0Zt4ED6QFQyAZ+1AaLM7tY2JYFGcRMQIG5DYJtl95?=
 =?us-ascii?Q?PVZn5Oda2LEY8mBklX0sX+rNWWTaye6E3E3rD6tt1w2Z5isGjlF1u35NEPiF?=
 =?us-ascii?Q?FcbGJ7fv20CJP12EyqhJkB5mdXe1Cm/YidK3W/OLs6PniqmP6fbpQwe35UNI?=
 =?us-ascii?Q?T5YbRwgql1l9GdT+t4l+cK9/5VQ7IBNCgoNA9RocT64m1n8iL+VP6YIUxyrs?=
 =?us-ascii?Q?3gA0evqcM/vnUjYWMM7I0M3DnF7ykjA0voAb09UZ1Wu/2YQZxtR4/Haivm/B?=
 =?us-ascii?Q?P64WEaL+/7txqwmZmDYPOQLfvnZoQbEZmtQR2paR+wjGgmEXGhtS4jNJSedQ?=
 =?us-ascii?Q?HptX0SmPMEGDlhcc80KLR+k79JcIAlXyTKA4WJ/fKuQQ+kF0HOevqOQMrihy?=
 =?us-ascii?Q?27lbmfgC+DQvmlRAgRW0hIx8CruxrW31XO59gLkQ6e14NlHkDICItYWSaJzV?=
 =?us-ascii?Q?56W5js0LZKIXpnPlkhCRsGRH3I2TjIwwUysTYUwT0DuzRX/pfLlvUU9h+m+f?=
 =?us-ascii?Q?s8Nx/6srPMvJ1F/sKd8S7A+rzNjgtj+TLuTaL99sk64q313WL9T44Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xj+E2RAURG/fqfPtgscIhCTnR73Ef94q4rTsfPOpjkEERCVjwqCs1vCh48nr?=
 =?us-ascii?Q?VXW/x4N5/wbz65EYpoUSPdkAMncYCfWMUU3LD0NG67PIJW6T9hQrGyWTdYlU?=
 =?us-ascii?Q?oy1noT5tWvYPPoGoMD5nDH9NVpV2ptxpXO8mopNB7f/lx3aLvzO0+3fq3h8d?=
 =?us-ascii?Q?5XTeOpFMSkt38R3kveIJIs4zRXSrpYoOKzBdEb3dLq3p+BYKKJI5KithXMPK?=
 =?us-ascii?Q?WI5znY+MZN3BsPmWPuwpHq1Hu+M1jfZx98HyR/cK+wAYPOwyKSORIwxFMC6R?=
 =?us-ascii?Q?JkOqqpd5FhYhNXLoY2e0e85zUp6Jt4k9gb/6QICZaBB0/vZoBbMijU1xcjkC?=
 =?us-ascii?Q?LypJPnvqxEypzOQwluA4vWl6afa4Ps5BH8g25jGEXkTA7Lfe3YKNDwngKfPg?=
 =?us-ascii?Q?UqmsBSgeeT6GmXLpXjvlJJChCwfJ77U7ssOn5DTkMXdrLfoQRAnZ3hb5U3kc?=
 =?us-ascii?Q?26OAvDaIw3fd/m4eFiE1rt97yEVYU0D3fZE7gfpbg3iOcBUeLxXrH5CwJIWe?=
 =?us-ascii?Q?/BkebI8xBA03a9ZWsrbnqZTRRZ4wNGwLIfvRUbbhYBpPIYM5PGDCXiZZsk5x?=
 =?us-ascii?Q?+tZRE/FlczoT/fwNOEbl2RjVuQa6DrPPU+aWIZu48SySs/ZEYmONhgBiNJsO?=
 =?us-ascii?Q?u8jW9XWZ8GyCDgUnUMAoIFMOacFQXFwT3SOjmNFYPyZzQiQMZm0SdSzYSAYh?=
 =?us-ascii?Q?uqxxYs/3pNFTNB/3wae+PApAIrWpDqDtEnqWg50tWzLKfbTozWOBz+61SOZd?=
 =?us-ascii?Q?Jt5fyU4f5nd4eHZaG66v42YQlnRZu9thnn4anWi8euI1cXhfDWfKFruupt4M?=
 =?us-ascii?Q?CmFBzASW5PexH4Tq70SV4dKyZBJOiJqqL+okinTm1YX90CXIhIUy+y3HZ23L?=
 =?us-ascii?Q?2Gtj6z1O0+UPXpx3SMDiI1XcBSMzwkPoCX+++NHq7sYaZViiyqjzYW5xl76R?=
 =?us-ascii?Q?0X0SXE2/LYOCWh2rSDCN8ahjHELU4n1rD9dZSyu6WGk70upvoDktne7uakgl?=
 =?us-ascii?Q?l/E1570SYdda5srIwHbDyzBs0YpmijM1Tb0m/PB/ledlRoMXSD1ehRG7D6qD?=
 =?us-ascii?Q?DMqhmaOsCsVh6Wlvg/HJP1BEEv5dWZZoq0JX2k67iDUqudZasPjn3rj1vdSf?=
 =?us-ascii?Q?VB/BTFSejU3C+TjUWYelEXGxCuH/PmCXL7QRM51eX0i5JlmV6lF2g65V9WHo?=
 =?us-ascii?Q?VkeJZyQp0Jgx5/cg0sO59mk61ESEumqE3IPSlb3tzfMT6BmXYGfO8kn1ogy1?=
 =?us-ascii?Q?cstAZno1fPRWAnsnR7vjbponIeVvye5NGI7Y3hDwO349s+mqEiLKi9cYHQub?=
 =?us-ascii?Q?NbP+sZI3uvlvCxVu61BqLe1L1v2kprQFM4iDsjoANW76WjWSzObc5W8WpqDW?=
 =?us-ascii?Q?88Vb9VWLdVsdi6TxUF8BZ31WB47D45qaio20fRK37AiYF3fZ81QvjlU0jQdj?=
 =?us-ascii?Q?dlBNWDrFAE0yL+g7FyDCqjV7FWixLco/GQScGL+FhHChlDffvqWNa8/hII7p?=
 =?us-ascii?Q?qkWFEdHT5uk3pcq2uNYckGza2hrC6digwS38g4OZ/MScBrznfM/MJhyQ8WkI?=
 =?us-ascii?Q?U3KChjtkUo788fpkNm2bRrhizJVMjra61G5EB3Us?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 338bfe90-763c-4cff-5be9-08de171d5529
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 18:59:48.5166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3u5DvL30XCs9kIIwZ5m02+Lv/lcLJdjtrHfa2ZhipFCf/YrRaWH0uqRwzutsJbjdsHN92k91lD6VrlElPH4JGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8247
X-OriginatorOrg: intel.com

I took a stab at applying the AET patches on tob of Babu's v10
SDCIAE series https://lore.kernel.org/all/cover.1761090859.git.babu.moger@amd.com/

There are only a couple of easy to resolve conflicts.

I pushed a branch with v6.18-rc3 + SDCIAE + AET here:

git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git sdciae-aet

-Tony

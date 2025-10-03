Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CFA203710
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 22:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759532143; cv=fail; b=bKw917W3bzV1wTL/PBItFTZx/PUOIoUSlsliBfJkdbITz/0m6M/06gJZgo40EC2peKAg8vx3okSHBzNHAziLH8rHOp2yMUiHJ4RMK4+Ou9zdNUB/yFbY5qpN3uDFBAtvPqY2M4MkCDHuKh20Vxo/nKlk25BZwCBScyOdR56yvRY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759532143; c=relaxed/simple;
	bh=78dele103XnG+ToqcPG+Ma+xCXpZhd0TDiDwoVevhqs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=j5T7tabGV2eSaBjYWiE83IoD/fWPUgMLslKrVtiMh8X/gGxjbEsKZz14Jic1ln2gLnt4lCA59TJ5uNmJQ6l3n5P/3GQwZ+1uB9pszQ+leMXzrAiLvYj7v8r+e1FPTLgQzJn5DHQYz9UiZsXH2sF41FHVskk/oRSdoV/rzotCOoo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Upt8tKGq; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Upt8tKGq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759532140; x=1791068140;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=78dele103XnG+ToqcPG+Ma+xCXpZhd0TDiDwoVevhqs=;
  b=Upt8tKGqF/W/NSdZemWazxmUFJ5g7d4AGtFYOqKbho2Vih9KXYdIAnMQ
   88k58jR0RFaqW8z//x5Kk9Eh9QWfO6yCAdRMi7fG0BIp/Df9Qx77J0ant
   0wssRRf3RWRmnlWLbK6zP45oxukE45xddzby9T41MW6kndDwaBkKj4PS3
   r37oU6nCOKObzZXp8m1bhcAMjgKm4f4T04GjYTgWLC8MPHFQhcrduWahO
   9jgzG/zV2Pb/uDKIrFyH3iN7KRTxm0PIG3Qxe/DBomTCI1n87BNJplA/b
   N0h1VamNqOlvPxP12L6so2TfaYHm0LjaGDIA7vFT6s45GF59RakQxMbvb
   w==;
X-CSE-ConnectionGUID: xBWIVIAFSHq723nuOnJL1w==
X-CSE-MsgGUID: cw36qYLJTdGEG/QrTIV21Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="61920020"
X-IronPort-AV: E=Sophos;i="6.18,313,1751266800"; 
   d="scan'208";a="61920020"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 15:55:39 -0700
X-CSE-ConnectionGUID: uuJstxVrQzKnGSVM91AKCA==
X-CSE-MsgGUID: zx/QnTDrTtuwrCZiOuKmHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,313,1751266800"; 
   d="scan'208";a="216498366"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 15:55:39 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 15:55:38 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 15:55:38 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.48) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 15:55:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K9jCXUX2zi1bC81yU3kKJizrYb7R2BvoancNOt8EcVXYyafSrRweGrUPOVc+Yie5exlKW9qqzB2kwkmZvq8UY9oYWT3uzp53XIYSNDZNnGCB5wU0+FC9kh0k6P2S57X59LeElAIy6go+P1FBU84cywje6sGeBJvaI9T8CKZSIWkWXedyhR4zMM2gKqWqZ0D0sqboNtlr8h4GoFjXLeNGd/CtHpxCFSJve+0WlQco+7RL+JpH12c11Ns5gRFMGer3umlRELlsVGJuBJhQkdD+GS/llhwdUk2Um6tSDzfiGp/Ivqy92AZOrPkKXlKOHcknsLcMsDiJAeUtmoeHG+16yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/WVWd8uOIggMaNdwv9UNBzuuu1+I8M0Du6p5FoY+iYQ=;
 b=BhuaLDUcLXrZ6Qa1eb00Q/+7zaTQPzcbpa1itPev/r2pteFgavPSVm2PImjCjJ9s1mwkZxYaEldc/NSzTu4kniBEZypyuExIOt2m3ZPVzSYLuOXVOGe+ZnhtYhvjfwE/SvNvVsrt/8FVYN+XFPE19D87Lm73V5AFXrOsYmpCp/wioeZUvH8hiIHO57lMs/2i8lvj2Lhj6LNEJck/TWNxBXp3YZZX5TfAYPNg2pCkcjZiuiIdieNbfQCkmiTzgYw4JYX+52LBe1aJvuK8FnoVkPARoMnhDEg9Lo9FGPPmMgjA1Bn4nlL2Oi+t7ZzQD/ejvg0eCLOMQ2TuxyjSkdDmSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA1PR11MB7821.namprd11.prod.outlook.com (2603:10b6:208:3f0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.17; Fri, 3 Oct
 2025 22:55:27 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9160.017; Fri, 3 Oct 2025
 22:55:27 +0000
Date: Fri, 3 Oct 2025 15:55:23 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v11 05/31] x86,fs/resctrl: Refactor domain create/remove
 using struct rdt_domain_hdr
Message-ID: <aOBUW81rwl3P7zQE@agluck-desk3>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-6-tony.luck@intel.com>
 <a6bb4a29-e494-495b-b8c9-fd6b380c9ebc@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a6bb4a29-e494-495b-b8c9-fd6b380c9ebc@intel.com>
X-ClientProxiedBy: BYAPR07CA0002.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::15) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA1PR11MB7821:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e473cd1-b3f3-4abd-0412-08de02cff185
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?DIG95G4di+v5XLYxmReYcIPIEncLUAO0PJqZX4SVXr2MXXnAPwd+4RKQcWi2?=
 =?us-ascii?Q?KXGPaDPp6hSzpWHWNZjs3vLGfsajROZO85RePFD1Iy+GZKGOOQT1L+6OfdGQ?=
 =?us-ascii?Q?MDFBe2EbCSrBKfKdsdFjO7yBldGvZyLnyK0DEUaGIGvK6Oqb6/NPaKYpallJ?=
 =?us-ascii?Q?yza+dncI5iFDEefP0DYja2ajvWzohMhxbN5ZnLCd+3Ig+G+Leho89d6UmC/o?=
 =?us-ascii?Q?7ouaAKbz4oZfAqCIHTwX3Dp9r4f48/ne7poK7WvybFM2ni3GhK2za1PPezTy?=
 =?us-ascii?Q?apN2M6kgmBmFPDIqDUKfjx8fHDH6uZw/d7iNEUrbK1BOp1C5YfUjg0nJggkE?=
 =?us-ascii?Q?9SZQp7DpEkR7ZN8IVn/ly5UI25/MJxFu2zbuejZeWWimqI0GNevZZiO7i9MF?=
 =?us-ascii?Q?aANOErDqasbBb3EdN5zOec0vStOzJUWH5cmRbOP5FF9m8NmravUNc0p0O5vH?=
 =?us-ascii?Q?ZsC+enecJFTUSsJdrbGZmpCqN7PxytzR3Y9sCFvlEG1teX4qSL01ZIDy8A7i?=
 =?us-ascii?Q?VnPsEUSb4ylowjALh+iocK/oTm84o4QtEPwVbWOlZgKUDJESmQEAEsnrYwk8?=
 =?us-ascii?Q?QG3VCXZjFZR5kxlISUQvPeAhMim5c+Rwe6P0Q/5i5LeIkupQl15sjG5Lr2zS?=
 =?us-ascii?Q?5bFyfYEAEaEk8TJ0yLsRcEB3lqfaiUICMKKHLbyjmyU/lrLWc1EUCUNdCS+n?=
 =?us-ascii?Q?xwD1WEL/qxaNNdSdreCSadC/aiD/wQB8O1vnMPRWXNWcQLhDJ5rvKEUMWI13?=
 =?us-ascii?Q?lbIDg1u1WFd2+YzqahObVBanVDlqdcUiBxHch6bFIwNTIcY8sPbyTEo2slLg?=
 =?us-ascii?Q?3DTaMV/J2Pv4bzNyxxStzQ2AHEY7ASqJi6jrKTT/EQ3ciHgxAlchKI3fsAWc?=
 =?us-ascii?Q?3zQv8dDUA9aQadf5a7TJu9vq5jjixvvzPz/5GzWYyUKa9ucSBYM3Npq98vxQ?=
 =?us-ascii?Q?pCS/ZVmqwFpaUVveBmYiyIl7BLJa5gvZPTk0sfD9DFfVdxoepweZpJg3XN1e?=
 =?us-ascii?Q?L9pfi7jxhxLFX5c72L51vohpAl/8haxEP4WRQe/p6vfdLAN4P7t5Azo1R/YK?=
 =?us-ascii?Q?WDJQUs4pAUSUr+ualNQ08nOfEEHB2Qpqd/BOavnqPTHay7C4iaqPUwYCHVLV?=
 =?us-ascii?Q?BkQIF+wgoS9O6i8bCTwh2QlzhxaaKOSzzv/XbT43Zcya1b4U1ilk8BLNgA4J?=
 =?us-ascii?Q?v30RGSDU9gV/eoT9lVeo3RXLbWmU9J2yQTFvwSMHiO6MUodbDM4qMNeoc6P+?=
 =?us-ascii?Q?C6kog8t3SKDMVo/ckEQNJRyERxAx1vg6pZy1VraN6hSl2AWzMG1jwsmEoUl2?=
 =?us-ascii?Q?xmZgvTNsDfg+9YszjDdB0TCVm2r4DpBhe8x7PsWRqleJxp2Fptxf2RFdY9qf?=
 =?us-ascii?Q?J4zR7PIVE37w9ci6lI039UnRud4UF4myxVtjCoFLuPzWw6qsV12EgzenNntL?=
 =?us-ascii?Q?8sdnjAwyny3Uu9l0b79PTT15CgJKhZKd?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sbV5nTQipy9OVNNAfTPwDMRXeiQnjigxWROWQ42DVZXO/I0M0oDJi8Vqn+NR?=
 =?us-ascii?Q?Rl81Z3eCmUjHw3KijGlXRmuvq/1irj0F548j+6tkhQKrM/0bYyXJzy6Qhedo?=
 =?us-ascii?Q?X3vStbJfyG9lzln2OW7BuME6c/VTynvCqxB3BmYfxe2pHheuCsPFTDsEYBn/?=
 =?us-ascii?Q?DGSeRxlr6HhjV4IraIolp/IO5MJIVAPlE7vM9uusVB2kBnokS5qiVpY0aiC2?=
 =?us-ascii?Q?VqUYbVSJRnsL6vausvyCcszS4bzfrQlDek2005fGZKiB595+3jRgR1qdLB8m?=
 =?us-ascii?Q?BrWVjhPO06TxjnAwWsCXERLtJrH2EODUeaWrf/uZdQFjmmoZLGyGD780foMw?=
 =?us-ascii?Q?nYlZ4TxtvI2Lj13qC/nmaas5/wwIAxMIc40Rsij2aLiMf/t8+s9FbI4u1m+i?=
 =?us-ascii?Q?u7sSs96HirOoqqCxlIUX2NOHyds+h2jMdAkXUfaSzu8dxaCgKwoDcoJ1XJnW?=
 =?us-ascii?Q?rm4fm4y9e5gCBuEza/1EAbOabOlu8Q6YM0uxCRYvVBMd8nOAj3YbjgDKFENS?=
 =?us-ascii?Q?1rb3nC2j1FIiXrCyEOwj6L5JPgOzgUFtJhN8fPg0z+ppEXKnImnRtfCu48Ev?=
 =?us-ascii?Q?QkkhGFprT+W/DpYJO+BbHEvoIrFp5aiVacenIxhkmHOuNpliS+elTWpzbxV9?=
 =?us-ascii?Q?TjHaVAcW5neFLyLcsEiIvZAvvFWeVwxwRA+vw71r98IUamuErcu3Vd2M5bz9?=
 =?us-ascii?Q?24g26UPMTZ02fBHNGUthAiRw/xaBYU/2HSZ2cwhFRwht4IYmasoYdakMxcAg?=
 =?us-ascii?Q?q1PGBFMugvGjLu0E4qS8iShZoSXB09b3x+vxJRKKrESTWJr1rTl3G6TUnw3o?=
 =?us-ascii?Q?YzOhQRhEoVEKaPym7lDodnvNXzl7mUH6mmNbBCresLPmqtQBWoXNsoNINh/4?=
 =?us-ascii?Q?f+SQ+5iC4k4YsnlsFIYoaS0rK8rOZymrKRSS1DUZZ4sVNvTlYF4OyVCNFMAg?=
 =?us-ascii?Q?eswJUi4yKh+1HCHkFu50IUQKO9IWYNFFsH/TdBVFFtaBFCbtxBE9H4YhDBb+?=
 =?us-ascii?Q?tW4Z/FMfVuqHwwlv0XlzH20fiywFZ1liV7nurulOoArWHdoi9jwRwcNK7jRK?=
 =?us-ascii?Q?kfVaywdhYQ8QYca/NAs/wDlYM3CbQzY8g4jLaFdkIyT3VaA6KHZb65ulhyQl?=
 =?us-ascii?Q?LYVjc400ggbqESXAydcxTuMrNdiVBtQfgFQ78a8VuPszQ6UhRZ55t2AYxXUc?=
 =?us-ascii?Q?kA0B+kyT2bMyY0A5/K7ovzorpIyovds8aJteNGzNSucWpfAWNgxnKf1pIaq7?=
 =?us-ascii?Q?8NkCvC0dTVestKhkBg1hrhyRyqPuG0b2E+t+CTl/4YTa6aCfCltTBQk15B+q?=
 =?us-ascii?Q?/O7m5paW7uTOH4C6bhjcEOFNGGwgwGv+wjproTUxM9Cefeu51gEL8iuPoqZB?=
 =?us-ascii?Q?JWNsaPfbUhbs0zbaXgXDGbc1rUR19R29mTB57eZKbifbn3tL6qiw9g1X03JD?=
 =?us-ascii?Q?8AWDAZckSYrrKipl3C4h/ev1Hc8GbaqWyWflkv0LKKivCV8Zt0ABH0ZSKYYO?=
 =?us-ascii?Q?6xLSvJsMN97mlxyBKWDs1pvwqJqLWUt1FiBgDJloP3s+u9vabA9/pFlIewuA?=
 =?us-ascii?Q?s4IVRo125szyttJ92hWtt2FknOv8d2PtsAyc9MX/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e473cd1-b3f3-4abd-0412-08de02cff185
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 22:55:27.0150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iznpt29WfU4upZBXb/+kuVy9UaN51ZFEKFSS4bA38jswuQD2aZPd6DI4tJKkEwVGyc/oQ4iEXLv1xhBwYfYH5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7821
X-OriginatorOrg: intel.com

On Fri, Oct 03, 2025 at 08:33:00AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 9/25/25 1:02 PM, Tony Luck wrote:
> > Up until now, all monitoring events were associated with the L3 resource
> > and it made sense to use the L3 specific "struct rdt_mon_domain *"
> > arguments to functions manipulating domains.
> > 
> > To simplify enabling of enumeration of domains for events in other
> 
> What does "enabling of enumeration of domains" mean?

Is this better?

    To prepare for events in resources other than L3, change the calling convention
    to pass the generic struct rdt_domain_hdr and use that to find the domain specific
    structure where needed.

> 
> > resources change the calling convention to pass the generic struct
> > rdt_domain_hdr and use that to find the domain specific structure
> > where needed.
> 
> I think it will be helpful to highlight that this is a stepping stone
> that highlights what domain management code is L3 specific and thus in
> need of further refactoring to support new domain types vs. what is generic.

Above re-wording cover this.

> 
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> 
> ...
> 
> > diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> > index f248eaf50d3c..3ceef35208be 100644
> > --- a/fs/resctrl/ctrlmondata.c
> > +++ b/fs/resctrl/ctrlmondata.c
> > @@ -547,11 +547,16 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
> >  }
> >  
> >  void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
> > -		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
> > +		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
> >  		    cpumask_t *cpumask, int evtid, int first)
> >  {
> > +	struct rdt_mon_domain *d;
> >  	int cpu;
> >  
> > +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> 
> hdr can be NULL here so this is not safe. I understand this is removed in the next
> patch but it is difficult to reason about the code if the steps are not solid.

Will fix.

> 
> > +		return;
> > +	d = container_of(hdr, struct rdt_mon_domain, hdr);
> > +
> >  	/* When picking a CPU from cpu_mask, ensure it can't race with cpuhp */
> >  	lockdep_assert_cpus_held();
> >  
> > @@ -598,7 +603,6 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
> >  	enum resctrl_event_id evtid;
> >  	struct rdt_domain_hdr *hdr;
> >  	struct rmid_read rr = {0};
> > -	struct rdt_mon_domain *d;
> >  	struct rdtgroup *rdtgrp;
> >  	int domid, cpu, ret = 0;
> >  	struct rdt_resource *r;
> > @@ -623,6 +627,8 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
> >  	r = resctrl_arch_get_resource(resid);
> >  
> >  	if (md->sum) {
> > +		struct rdt_mon_domain *d;
> > +
> >  		/*
> >  		 * This file requires summing across all domains that share
> >  		 * the L3 cache id that was provided in the "domid" field of the
> > @@ -649,12 +655,11 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
> >  		 * the resource to find the domain with "domid".
> >  		 */
> >  		hdr = resctrl_find_domain(&r->mon_domains, domid, NULL);
> > -		if (!hdr || !domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, resid)) {
> > +		if (!hdr) {
> >  			ret = -ENOENT;
> >  			goto out;
> >  		}
> > -		d = container_of(hdr, struct rdt_mon_domain, hdr);
> > -		mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evtid, false);
> > +		mon_event_read(&rr, r, hdr, rdtgrp, &hdr->cpu_mask, evtid, false);
> >  	}
> >  
> >  checkresult:
> > diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> > index 0320360cd7a6..e3b83e48f2d9 100644
> > --- a/fs/resctrl/rdtgroup.c
> > +++ b/fs/resctrl/rdtgroup.c
> > @@ -3164,13 +3164,18 @@ static void mon_rmdir_one_subdir(struct kernfs_node *pkn, char *name, char *subn
> >   * when last domain being summed is removed.
> >   */
> >  static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> > -					   struct rdt_mon_domain *d)
> > +					   struct rdt_domain_hdr *hdr)
> >  {
> >  	struct rdtgroup *prgrp, *crgrp;
> > +	struct rdt_mon_domain *d;
> >  	char subname[32];
> >  	bool snc_mode;
> >  	char name[32];
> >  
> > +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> > +		return;
> > +
> > +	d = container_of(hdr, struct rdt_mon_domain, hdr);
> >  	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> >  	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
> >  	if (snc_mode)
> > @@ -3184,19 +3189,18 @@ static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> >  	}
> >  }
> >  
> > -static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
> > +static int mon_add_all_files(struct kernfs_node *kn, struct rdt_domain_hdr *hdr,
> >  			     struct rdt_resource *r, struct rdtgroup *prgrp,
> > -			     bool do_sum)
> > +			     int domid, bool do_sum)
> >  {
> >  	struct rmid_read rr = {0};
> >  	struct mon_data *priv;
> >  	struct mon_evt *mevt;
> > -	int ret, domid;
> > +	int ret;
> >  
> >  	for_each_mon_event(mevt) {
> >  		if (mevt->rid != r->rid || !mevt->enabled)
> >  			continue;
> > -		domid = do_sum ? d->ci_id : d->hdr.id;
> 
> Looks like an unrelated change. Would this not be more appropriate for "fs/resctrl: Refactor Sub-NUMA
> Cluster (SNC) in mkdir/rmdir code flow"?

Agreed. I'll cut this out and move to the later patch.

> 
> >  		priv = mon_get_kn_priv(r->rid, domid, mevt, do_sum);
> >  		if (WARN_ON_ONCE(!priv))
> >  			return -EINVAL;
> > @@ -3206,23 +3210,28 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
> >  			return ret;
> >  
> >  		if (!do_sum && resctrl_is_mbm_event(mevt->evtid))
> > -			mon_event_read(&rr, r, d, prgrp, &d->hdr.cpu_mask, mevt->evtid, true);
> > +			mon_event_read(&rr, r, hdr, prgrp, &hdr->cpu_mask, mevt->evtid, true);
> >  	}
> >  
> >  	return 0;
> >  }
> >  
> >  static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> > -				struct rdt_mon_domain *d,
> > +				struct rdt_domain_hdr *hdr,
> >  				struct rdt_resource *r, struct rdtgroup *prgrp)
> >  {
> >  	struct kernfs_node *kn, *ckn;
> > +	struct rdt_mon_domain *d;
> >  	char name[32];
> >  	bool snc_mode;
> >  	int ret = 0;
> >  
> >  	lockdep_assert_held(&rdtgroup_mutex);
> >  
> > +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> > +		return -EINVAL;
> > +
> > +	d = container_of(hdr, struct rdt_mon_domain, hdr);
> >  	snc_mode = r->mon_scope == RESCTRL_L3_NODE;
> >  	sprintf(name, "mon_%s_%02d", r->name, snc_mode ? d->ci_id : d->hdr.id);
> >  	kn = kernfs_find_and_get(parent_kn, name);
> > @@ -3240,13 +3249,13 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> >  		ret = rdtgroup_kn_set_ugid(kn);
> >  		if (ret)
> >  			goto out_destroy;
> > -		ret = mon_add_all_files(kn, d, r, prgrp, snc_mode);
> > +		ret = mon_add_all_files(kn, hdr, r, prgrp, hdr->id, snc_mode);
> 
> This does not seem right ... looks like this aims to do some of the SNC enabling but
> the domain id is always set to the domain of the node and does not distinguish between
> the L3 id and node id?

Also move to later patch (and get it right)

> 
> >  		if (ret)
> >  			goto out_destroy;
> >  	}
> >  
> >  	if (snc_mode) {
> > -		sprintf(name, "mon_sub_%s_%02d", r->name, d->hdr.id);
> > +		sprintf(name, "mon_sub_%s_%02d", r->name, hdr->id);
> >  		ckn = kernfs_create_dir(kn, name, parent_kn->mode, prgrp);
> >  		if (IS_ERR(ckn)) {
> >  			ret = -EINVAL;
> > @@ -3257,7 +3266,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> >  		if (ret)
> >  			goto out_destroy;
> >  
> > -		ret = mon_add_all_files(ckn, d, r, prgrp, false);
> > +		ret = mon_add_all_files(ckn, hdr, r, prgrp, hdr->id, false);
> >  		if (ret)
> >  			goto out_destroy;
> >  	}
> > @@ -3275,7 +3284,7 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
> >   * and "monitor" groups with given domain id.
> >   */
> >  static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> > -					   struct rdt_mon_domain *d)
> > +					   struct rdt_domain_hdr *hdr)
> >  {
> >  	struct kernfs_node *parent_kn;
> >  	struct rdtgroup *prgrp, *crgrp;
> > @@ -3283,12 +3292,12 @@ static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> >  
> >  	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
> >  		parent_kn = prgrp->mon.mon_data_kn;
> > -		mkdir_mondata_subdir(parent_kn, d, r, prgrp);
> > +		mkdir_mondata_subdir(parent_kn, hdr, r, prgrp);
> >  
> >  		head = &prgrp->mon.crdtgrp_list;
> >  		list_for_each_entry(crgrp, head, mon.crdtgrp_list) {
> >  			parent_kn = crgrp->mon.mon_data_kn;
> > -			mkdir_mondata_subdir(parent_kn, d, r, crgrp);
> > +			mkdir_mondata_subdir(parent_kn, hdr, r, crgrp);
> >  		}
> >  	}
> >  }
> > @@ -3297,14 +3306,14 @@ static int mkdir_mondata_subdir_alldom(struct kernfs_node *parent_kn,
> >  				       struct rdt_resource *r,
> >  				       struct rdtgroup *prgrp)
> >  {
> > -	struct rdt_mon_domain *dom;
> > +	struct rdt_domain_hdr *hdr;
> >  	int ret;
> >  
> >  	/* Walking r->domains, ensure it can't race with cpuhp */
> >  	lockdep_assert_cpus_held();
> >  
> > -	list_for_each_entry(dom, &r->mon_domains, hdr.list) {
> > -		ret = mkdir_mondata_subdir(parent_kn, dom, r, prgrp);
> > +	list_for_each_entry(hdr, &r->mon_domains, list) {
> > +		ret = mkdir_mondata_subdir(parent_kn, hdr, r, prgrp);
> >  		if (ret)
> >  			return ret;
> >  	}
> > @@ -4187,8 +4196,10 @@ void resctrl_offline_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain
> >  	mutex_unlock(&rdtgroup_mutex);
> >  }
> >  
> > -void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
> > +void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
> >  {
> > +	struct rdt_mon_domain *d;
> > +
> >  	mutex_lock(&rdtgroup_mutex);
> >  
> >  	/*
> > @@ -4196,8 +4207,12 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
> >  	 * per domain monitor data directories.
> >  	 */
> >  	if (resctrl_mounted && resctrl_arch_mon_capable())
> > -		rmdir_mondata_subdir_allrdtgrp(r, d);
> > +		rmdir_mondata_subdir_allrdtgrp(r, hdr);
> >  
> > +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> > +		goto out_unlock;
> > +
> 
> One logical change per patch please.
> 
> While all other L3 specific functions modified to receive hdr as parameter are changed to use
> container_of() at beginning of function to highlight that the functions are L3 specific ...
> resctrl_offline_mon_domain() is changed differently. Looks like this changes the flow to
> sneak in some PERF_PKG enabling for convenience and thus makes this patch harder to understand.
> Splitting resctrl_offline_mon_domain() to handle different domain types seems more appropriate
> for "x86/resctrl: Handle domain creation/deletion for RDT_RESOURCE_PERF_PKG" where it should be
> clear what changes are made to support PERF_PKG. In this patch, in this stage of series, the
> entire function can be L3 specific.

Will move to later patch and make the offline/online patches have same
style.

> 
> > +	d = container_of(hdr, struct rdt_mon_domain, hdr);
> >  	if (resctrl_is_mbm_enabled())
> >  		cancel_delayed_work(&d->mbm_over);
> >  	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) && has_busy_rmid(d)) {
> > @@ -4214,7 +4229,7 @@ void resctrl_offline_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d
> >  	}
> >  
> >  	domain_destroy_mon_state(d);
> > -
> > +out_unlock:
> >  	mutex_unlock(&rdtgroup_mutex);
> >  }
> >  
> > @@ -4287,12 +4302,17 @@ int resctrl_online_ctrl_domain(struct rdt_resource *r, struct rdt_ctrl_domain *d
> >  	return err;
> >  }
> >  
> > -int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
> > +int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_domain_hdr *hdr)
> >  {
> > -	int err;
> > +	struct rdt_mon_domain *d;
> > +	int err = -EINVAL;
> >  
> >  	mutex_lock(&rdtgroup_mutex);
> >  
> > +	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> > +		goto out_unlock;
> > +
> > +	d = container_of(hdr, struct rdt_mon_domain, hdr);
> >  	err = domain_setup_mon_state(r, d);
> >  	if (err)
> >  		goto out_unlock;
> > @@ -4306,6 +4326,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
> >  	if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID))
> >  		INIT_DELAYED_WORK(&d->cqm_limbo, cqm_handle_limbo);
> >  
> > +	err = 0;
> 
> Considering the earlier exit on "if (err)", err can be expected to be 0 here?

Yes. Dropped this superfluous assignment.

> 
> >  	/*
> >  	 * If the filesystem is not mounted then only the default resource group
> >  	 * exists. Creation of its directories is deferred until mount time
> > @@ -4313,7 +4334,7 @@ int resctrl_online_mon_domain(struct rdt_resource *r, struct rdt_mon_domain *d)
> >  	 * If resctrl is mounted, add per domain monitor data directories.
> >  	 */
> >  	if (resctrl_mounted && resctrl_arch_mon_capable())
> > -		mkdir_mondata_subdir_allrdtgrp(r, d);
> > +		mkdir_mondata_subdir_allrdtgrp(r, hdr);
> >  
> >  out_unlock:
> >  	mutex_unlock(&rdtgroup_mutex);
> 
> Reinette

-Tony

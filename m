Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1769A48424E
	for <patches@lists.linux.dev>; Fri, 25 Sep 2026 22:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790374499; cv=fail; b=dH8IgmmjEZ672ZzMwXnARNAq8BUqGqbvxRUSwViM3UKMsKvOIcM0MTZBt4ApQ/ei+7xiZGWJe1rPSPi8bcyFVcl2yKQT0x5xJT9Hu9Ze/viEI7pmOleDeEV86mW4da8sr7I3rhQdvvgMGnYFrw6gN/5Tj76icd5fwgUlcKxeqdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790374499; c=relaxed/simple;
	bh=ll3vIo5uuQwQdAjwgjHrGT1nCJc8N0qPelRvGlHtLrU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KHyrxrUlDIpTr0FgR+gnylAeRtBH0MGTmYBVf03KWaweCiVpe/7KXqgnHElk/fy6dL7hgOKZj3sk+h8y4twn9syeDKwGdLi9z0rKxNiglQi2As+8dax+RyKThtqGdRejFoTHm0VsqqMW9YiIDcbBGt89QvcFCFj8d58X+fcaFF8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GeBI40bP; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GeBI40bP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790374494; x=1821910494;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ll3vIo5uuQwQdAjwgjHrGT1nCJc8N0qPelRvGlHtLrU=;
  b=GeBI40bP4tra3pciQMrCbAVpGeTWbAktqrYh4n5vdchxupGviDFf54hg
   lFilkR02HBzwCUSn4bakIySBGiP7A+SFghrY6InvwOt2nt8TfGUU+/55f
   /yP8WRSPIFPfVzjp4sOcMxu/LaKSZxnSK4I5IqvPMH7snw5RLR4i2CCW6
   RzFGnoClhIIYhzyOsJyt6u5dk07oA+6rTAMEBdQP6CsBQ69oPILYs3pSu
   oVn9pT0nkw9o0fYm/6/X00Fm0f5iQqvWa1MoOdVi+0da/HIzAaRgPPpCV
   0EpGFfVbDQklvOPGmj/Ou/Jpl3OlqtUU7/VPoIE6rLJra3EcVv6vEYL9T
   w==;
X-CSE-ConnectionGUID: U9HWwKJlRomkV7LpE22dJw==
X-CSE-MsgGUID: shkYH6V3R5mYreeUCgnkRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11916"; a="91029539"
X-IronPort-AV: E=Sophos;i="6.27,123,1787036400"; 
   d="scan'208";a="91029539"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 15:14:49 -0700
X-CSE-ConnectionGUID: NwnSQQ/zQdKxLsWIsm+1yQ==
X-CSE-MsgGUID: k228cMj5T/2W1czhx/DG8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,123,1787036400"; 
   d="scan'208";a="272242855"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2026 15:14:50 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 25 Sep 2026 15:14:49 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Fri, 25 Sep 2026 15:14:49 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.6) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 25 Sep 2026 15:14:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xHvsIoCxaDM6E+XHXy6tRXIgx/74K5RxxWTNBnE/su0KtqSjdMwJptGaoHWMgk8A28jSNj0Peq1Yk69J7gdXuU1H72UrHcpx+zpLI+ERlQ6uMxgwBvEq3/sNcmUrG8nKEjqw4E6v3ExMrA6jhfSGHNPuKoo++xPnbS5pSH6A5Lk2/+52+9+OvRT++raUrHKocYKwSF3JGtAO29MLUbaV7GGO9Bn95+koxu7UEI8EfR2DEPuN95QsGMb7Iedtv2yEbfK/AOPozBSfGg0znCXQkp7kvIKgNPOayIEtdHY2zejSsduQ9gsZY2zXNfUdoLp5bkLiDD1Xagnc+QYB0Bm/Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sRYjjjvP5P/0jRqk3q1QyZkSYKKnAiw+KQF63VvtARs=;
 b=Ennn7DeXnQGxJGf31XNQ7cOmH6PGa/fjMdEbT+UqpLXiNsI5VgjuvRsaSZQNFafj/HSiNCvPjGgqs8M2auCaMe41M85tdW1JR362KFWGgHvJsYoob38Y6M8kc01eQLaiwgiE4QPD0fgmfu6KGlngKcS1ilU/vkOvdrZq81edOOB75G27UYDJCvfClML48hkO6c18Ib8MWPDbVGygUqe2ksUPMH2XC92ZD1HwzmuZ+UHytqYeNUHG9eWk5NFPCjp3SP67U2knzsv/L+aLpA89/am4xM9+beQe2BWkyvMBFqVy3GCDVoRg1WIaGtXoqhJyOiUQCFuMmLNZxObk4FAOeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by BL1PR11MB5222.namprd11.prod.outlook.com (2603:10b6:208:313::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.19; Fri, 25 Sep
 2026 22:14:46 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0451.014; Fri, 25 Sep 2026
 22:14:46 +0000
Date: Fri, 25 Sep 2026 15:14:44 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v12 06/25] arm,x86,fs/resctrl: Replace architecture
 resctrl_arch_{alloc,mon}_capable()
Message-ID: <arbyVMoQOeCq5F_m@agluck-desk3>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-7-tony.luck@intel.com>
 <d0e563ec-65c4-4a00-bd54-61c30d80890f@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d0e563ec-65c4-4a00-bd54-61c30d80890f@intel.com>
X-ClientProxiedBy: SJ0PR03CA0389.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::34) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|BL1PR11MB5222:EE_
X-MS-Office365-Filtering-Correlation-Id: 691f7fcb-4963-469d-2bdc-08df1b52681f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|6133799003|10067099003|11063799006|5023799004|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: v7CF9KwVUyl8S71HRfrmipu6LkUN+8pVH7nW7DM3bma4lKFrrS8mMkklkBTIJgpMgLB0ZKOHSm6VGLL6FfEaY5n7bZdNpiG58QlPkBjtsnSKcdkzvVFeRyC5Q928n8WdFbeSvymxJAmMF9RdnQF+ckGESpAyZ/if9UBBwZxzuNs01JskJXX+sHicqlwrQD8h4IjJaO2m3nQcIt2Qwn7i0kw6w1fOcQxET5Z6fEzGk+7ryF3AikwJV7f+uuybl+yJhQQbajmz8L+VyhG2KU9U6vnJizvwT/iXRVksidUlAhZ9E940YnjHinY6FWAnYFqIE4D1l7qnHgt4+4/uWW9a+9uHmfq+pcyJZWn0n6qwujbvLYtV6126B4w8y7+koH60ns5ZztyHc3EyU4AQI9gimZQimSjUl+CYR+anIboMN4AbKfsh5qA2kbBLUhSUeKQYtt19sdKER5kYt1EXAI4Yi6vCY/0618Mi3T347wUeF8tj6dPNM739KBoODcvCUeGJMjZavk3oDfpjVNALOQ2bvjFIiEL8RURU4ccFe91K3ZfYZXUmiDWQ9VOuODlih0e0yEDtEyCfxzu1RquD3t2UhSqJ6VJgyLYP50glD3RKVh0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(6133799003)(10067099003)(11063799006)(5023799004)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dlbyp7ebhh+s7wapKXQzkgYQIXiZzgCNOMx94UeETBo5Ru9j7DPJKtUBlNz5?=
 =?us-ascii?Q?agzJl5Ey9+5iSrL3FlwZxkghgzdkbfV4MPiRVMbxlygbAp5xTshukN7od9EN?=
 =?us-ascii?Q?pJrtZQFOtsT28ukSUj11xAesVpSgBwYcjzgm7fPrLGoGO4COdDAJSGcUeMSn?=
 =?us-ascii?Q?GQD657fW6b1jfVqx5EVybL/beyzNAhvAJJrvaHWm0JwF934EYfxAJgb6pxZs?=
 =?us-ascii?Q?HyqUlNZmgjRbCCdNX9G88u+ZFNAGN3u+rEHb8/rAYu4uDFUUdjj8FXxxUE2J?=
 =?us-ascii?Q?e7ihO4XWDIs0ZEg6xLxf4SZr9eXHevmRessAM1d7jlGO+lY1q24zeNa56PtV?=
 =?us-ascii?Q?3oOv1BvAHS0Fg7Zmnp71ct3/uW0Wxakw2MoakuBVR7oRZE4ErzQViZYmvdaK?=
 =?us-ascii?Q?PEz1t4dOQoaCG2THIDvPMHFjWdFL8sZ9k8+2WaF9f1OSVT1Upii+Du/s123w?=
 =?us-ascii?Q?dziDCvZeNvbn/6DkXuRnVK4WAAKGhqMIIt1ldHhJk3QRZVG6H+awrqpDsSzs?=
 =?us-ascii?Q?KRQmCwascLSz1BSgt4066IoMvuSSsUs2u+eLR2VqZVwOIiiG6y69elwaUtMT?=
 =?us-ascii?Q?tfeBOe5fBm/UIziq+Uf7RKbZ6RZB9eAyP5ipwKAY9+ScCvxFxxU4SKLXwTgu?=
 =?us-ascii?Q?rE7CdHHPFJ5A+T/S98ZHfbiIQiS22mIG/A6KawLSFkZtgRMW7blhj8Zc62cy?=
 =?us-ascii?Q?Dyiwq9oX5/CDU2DJp3MuZ1FFsH8gMLlwOFDZjDXyLPyo+T7suRxxRGXpC72l?=
 =?us-ascii?Q?s2gHGIYBPYowgTAawS/zh5W8PzhVcTZVRSbXL1D+i7UvptWH2yaDauRvciaT?=
 =?us-ascii?Q?Wr/LUbQOS4Rd7AUAeXEEtwMHyhByv0cZwsNcxUoH1CuEcH/MK6+SHmWSyHeH?=
 =?us-ascii?Q?4WYol5y+/smvL5y2pC68bLrJGR+ud0ohRxVQGL88oXRzWw96t0I6A4v9qg66?=
 =?us-ascii?Q?/Wo5sBVSEv3qgvJPaGJtSD/h99gd8dor1nfM5xgCPP4rKnf51RtR8aZ0Tqac?=
 =?us-ascii?Q?tscubHlSb72EQArIAUXo/arTv9EJbDDy7Dyeg+0oQCOo0RqXpApriqEtDVIP?=
 =?us-ascii?Q?N0vEqK7+UH60KEZTLfc6/EZqp30WS14M+Nb0tkyh7Jj98Nl6IJfCJzClGWp8?=
 =?us-ascii?Q?FYyRLrABJr9FF3nUdOOG5vTFodGM37QNXvgtQv/iUDG35VC2n8bjIEyNuDcy?=
 =?us-ascii?Q?NRZJVC1OKHYci+qA8r2iAYGEptLxXHT4xQixvv8fOZbgIN12FWOrvCw0+A1X?=
 =?us-ascii?Q?qXBHOJgyulH2X4kHtupIY02B8XxLyIZEcWgzyD/DeiuYPllpcq12wVegOBbC?=
 =?us-ascii?Q?7/QcLXWQobLIC5RZpqYt6tuPUnW7nf+rf6hMk/sNsQhk5YqQhd1r6A2EVBk9?=
 =?us-ascii?Q?ZdEC/w+K6160h67yAJ4HYnfp69VIP8nSs5PRvkHq2k4O4c9Edche7fbW9OOe?=
 =?us-ascii?Q?XZnVIi8uuKUKJ9aXhQW5TcN3DFgrg/nQ24Lc6gNJhkIH+8U9XDjywpRP1BWM?=
 =?us-ascii?Q?y4APbx6TMzFDFxnbXMfdxBDrBEnjk0jnAV8QHW9VfpqfwdqsIy8HcFHOZID7?=
 =?us-ascii?Q?LCwzrrs6fECy8iARrORPFF2lQwyVHFmOyyk3wXdmV+Mj6tIwzeGmccBQZrqZ?=
 =?us-ascii?Q?44P4kkopI/YJCjaoK4GhRN/1x3jn7a4ksN6TC15KJd+kKmiHk2i9wdEqzNrh?=
 =?us-ascii?Q?THF/vPJVcz/IHppUsw2oaXO/sC2QI8EaEAaRE/ZjaLh2xsYDaRcELujNzhhC?=
 =?us-ascii?Q?JcQZhNEsuA=3D=3D?=
X-Exchange-RoutingPolicyChecked: qWUW32NPZlcwRWMg3QFhzj8lF8P1aoQeQiXCaPvlA4vhkXymJ+n8fMY8+JNoyMfmJsJ6pHL0Vm28sCwDva6bB+vXQ3F5G4sHDRApRmq+oZdpS7E1kmjNdeqp54iM90pKJVgfGBIXjuY4wyCHNFKAkkY2Y5MeLQtxVgKM7KsrKKfgt6XOjzfpuQgO2y0JqMG+vyllDdx/X9UlpeKyxt/kTZIuAzlyjGpUTRPWihTy6qO79I0giU5nEGfAk/YSZLJq7ddmvd8+z/pagAVDZ3FQCMwRWERKYjjLG39GN7rWwrDrBaFy1Sh0Ga5Z290SfaQq73okHy1lmP9Oa0h30a+h+w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 691f7fcb-4963-469d-2bdc-08df1b52681f
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2026 22:14:45.9912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gtOQlOALALQb3Mkc/lmK4ytMwTD7pU2FpQqgQAl72pP+j9T8TDqpQ3KRJHkbV1vEZFryLF/wqKqNqTkQfwoUpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5222
X-OriginatorOrg: intel.com

Hi Reinette,

On Thu, Sep 24, 2026 at 08:22:47AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 9/16/26 4:13 PM, Tony Luck wrote:
> > All the information to determine whether a system is alloc, or mon,
> > capable is available to the file system. Architecture helpers are not
> 
> nit: "is alloc, or mon, capable" -> "is capable of allocation or monitoring"?
> 
> > needed.
> > 
> > Define generic resctrl_alloc_capable() and resctrl_mon_capable() and
> > replace all architecture versions.
> > 
> > Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> 
> Please note that the pending RISC-V enabling [1] is not compatible with this
> change but there is a change planned that will let resctrl_alloc_capable()
> introduced here work on RISC-V also. We need to coordinate these two
> series.

The first few patches in this series have relatively simple cleanups
suggested. Perhaps when I post v13 you could focus on getting these to
the finish line and have Boris consider them for inclusion.

That would get this change into TIP x86/cache and let the RISC-V
folks move forward.

Note there will be one new patch in the initial sequence. The bug
fix for is_closid_match() that you suggested I separate out from
patch 9.

Draft version of new patch below.

> 
> | Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
> 
> Reinette
> 
> [1] https://lore.kernel.org/lkml/20260917-dfustini-atl-sc-cbqri-dt-v8-2-7964e8d73fe8@kernel.org/

-Tony

commit 986bf1a4e789de917e955fe549bdd71e51dc2e48
Author: Tony Luck <tony.luck@intel.com>
Date:   Thu Sep 24 12:40:41 2026 -0700

    fs/resctrl: Ensure default group reports tasks on monitor-only systems
    
    Sashiko reported[1]:
    
      This is a pre-existing issue, but the resctrl_alloc_capable() check in
      is_closid_match() actively breaks the default group on systems that only
      support monitoring capabilities.
      When a user reads the root /sys/fs/resctrl/tasks file on a system with
      monitoring capabilities but no allocation capabilities, the following call
      chain occurs:
      rdtgroup_tasks_show()
        show_rdt_tasks()
          is_closid_match()
      Since resctrl_alloc_capable() evaluates to false on such systems,
      is_closid_match() unconditionally returns false for all tasks. Furthermore,
      because the default group has type RDTCTRL_GROUP, is_rmid_match() will also
      return false.
      This causes the root tasks file to appear completely empty, hiding all tasks
      on the system that have not been explicitly moved to a monitoring group.
    
    Remove the resctrl_alloc_capable() check from is_closid_match().
    
    Fixes: e6b2fac36fcc ("x86/resctrl: Use is_closid_match() in more places")
    Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
    Signed-off-by: Tony Luck <tony.luck@intel.com>
    Link: https://sashiko.dev/#/patchset/20260831174421.13921-1-tony.luck%40intel.com?part=9 # [1]
    ---
    v13:
            New patch (split from patch 9)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5dcbb0a964e8..6733ed174f51 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -685,7 +685,7 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
 
 static bool is_closid_match(struct task_struct *t, struct rdtgroup *r)
 {
-	return (resctrl_arch_alloc_capable() && (r->type == RDTCTRL_GROUP) &&
+	return (r->type == RDTCTRL_GROUP &&
 		resctrl_arch_match_closid(t, r->closid));
 }
 

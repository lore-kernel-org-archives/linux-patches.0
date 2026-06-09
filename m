Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797F54A13BC
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 18:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781030778; cv=fail; b=eLYr8CAjhy/c+1yYbfo+vWbLrY78w/R5P6y1R5xnavDm9QKyexppkeQrf6TO9cQ1XwRlIfKtUNsblaF/FnrytcqAqPc51Nv2A3ZIqGe1PLofDh0dBvHdsLOu5Z11Inzu1nGFF8HIEkMpvMaPD4ydQPOvaFoxZCstSwhhGHHrqjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781030778; c=relaxed/simple;
	bh=pftAnIydUKElkRT2mdpJqVLHugifPBgWG2JgnNhF27s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ixYV0Z5fsXpfQsbONxP80WwMJ1/AHftTpTA0MrzvGLmOxcHIyrQ3Id9pMlPsBqXG5x4k91yn7CSWGwxMJhjnbYQydd6YUHU1GTrYmW4N2t5y9SOUIku9UI5NxQZgXyAvicpgJYkl1dmkS4Isb0PxS74rYWvEigsfglQQoYRwVjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EJ++2gF1; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EJ++2gF1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781030778; x=1812566778;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=pftAnIydUKElkRT2mdpJqVLHugifPBgWG2JgnNhF27s=;
  b=EJ++2gF13jNLRj3hTwelfUj4mFECDKhZZIygqGWbGZ95I/DhrNXR8i/5
   VmTiQm6F+ZTRhgUyfJKIdDfe/hjFlb+7ou2b0+yEtPEn6l54s44xhnvL3
   Ek2bRuoJcVvT1n6HbCeWXukcLrhaCvDZ4IvWEjk08mp4+1CuIx91dtV02
   QV5Um8U8RGjjUsFXWm4X2+9i9zETqwiPkyE2+WZ9iJmzq/s2Y3oe60UDc
   Foa82ynrTZSOMGJZGnhl/3mKN8U4qA6gZ/BEnagfHA2BlQ1Id41JpBFtX
   1AW6jC5Tlxb7GbnkA9l3h5qdYYtRKR935InvrA/CuWd14vBrW874XYchw
   A==;
X-CSE-ConnectionGUID: MYd7BCjsSaiA+IWGBgGnTg==
X-CSE-MsgGUID: NUuFAMN+Sj6ZSiO/EbelzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11812"; a="92125654"
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="92125654"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 11:46:17 -0700
X-CSE-ConnectionGUID: KQOEkvPwSye3Cr0n6eAoiw==
X-CSE-MsgGUID: DSp1AJUlTRuoPgQDvoIUbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,196,1774335600"; 
   d="scan'208";a="276132602"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2026 11:46:16 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 9 Jun 2026 11:46:15 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 9 Jun 2026 11:46:15 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.14) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 9 Jun 2026 11:46:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qw3rCHF8eHIQnhAagF3fea8uqvzgMF3t89bHbV7IuXeFl6N26qAmjApK66P+aY5H3lZsvuHHXp/v+7/dCbC9YKm1/Bhh9Jy9t1VZVj9IiYJJneBGd3UYO81+fBkzjnQ7iJ+L8N+I0jvE+wwtRG0D2wjlwBdni0gM0Rom/ax0g3Pb4ulef8au6RGWbvCoYXbBfk1jXZ93fKnSkBw2jC7B8fB0TosWJZ4J1f/ievwjDEf3q29eNomuHOzaJVtbU6ItGnYHXx1UJ6b3TCyE1zqENujhc+DG4pKTHgGnVdb9HzXdO/ZVvU/s2AaYaFNVP95J4mgzLHxrBYObTmVbNZbW9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R3buBXL39UrrPSb20Duhdf5DAgCnpqq6Mw31bfdLo6E=;
 b=VCrvqerk4X21NAmaj3MmmeICutdEuq+xlGp9y4Ooe2taM0YFHWuO/218UmreBCKQaTTVOOCBkc+uXDs31SYvfODXEc2ECcE4wWa7nQ5ftO17c0MS4W1MI3pgXHXtCNZTPXNQBr/OAXS6ulGm7OvmRODNdsXrgQ+Nz0HPEPn3zfVI3RMoDiFmD9pijKAfgpCfkt7duu67ur0OdBKbKtr7bzvmFcStoNDa/u+aGpwrM0DmCnjdMnqik6wYvv5fiiw/w+SvFNm/vBIWKcuRD54SspWsWJQd5hxBtux2VlMQzq8dK9owCaX9f4PrL+vufoMPVU+4JcQdUtEHAoUEv1pwcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Tue, 9 Jun 2026
 18:46:11 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0092.007; Tue, 9 Jun 2026
 18:46:11 +0000
Date: Tue, 9 Jun 2026 11:46:09 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v7 07/14] x86/resctrl: Maintain a count of enabled
 monitor features
Message-ID: <aihfcS3T7M-hn5NV@agluck-desk3>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-8-tony.luck@intel.com>
 <ebb78841-8676-4383-a1b4-81ff4f1e782a@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ebb78841-8676-4383-a1b4-81ff4f1e782a@intel.com>
X-ClientProxiedBy: SJ0PR13CA0115.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::30) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|MW4PR11MB6936:EE_
X-MS-Office365-Filtering-Correlation-Id: 3004a955-edfd-4413-24de-08dec6576006
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|5023799004|4143699003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: me0SuPLjw/oJ0IQ6t1N+2yTBfROrsXDjtssQt6UHXvUFZFwo6k8TFh+hRN8v0/u94KvO3BOXv7cxaJa4tEy46h3hCyKIuBEPutHZD1TnAg/ovVw+Nk34uI2OtlYcXLxmUhIOZitg8GZ2w38goBR31+ALp79qxIMGIFlGqhIqsU/UNjX0RwqQqkOz43uOs8rYnwhpNwyPr/lyJaLBY/rhu5FoofN0LRLSJZ5LM4aokMrvQsQlYyt45B7tYVtriYM58+Aj4btHYo5PbHxZLOGGlqV9QnV0Ezvd6RV0NIygsKtlmxXFcXG+rJBAayX4g4siifiAS90AG/8KHyarFaFnDZwdpMg0YspU6ADgkLtZ9Xf5y/tOvcb5dD1MdMyv004WgdFjgQqIQrtv8MGCXJahpNXYgbEnRVH8o2kC+zxMaYb3gBS8u5EZIwF+kLEosNn0dmNxn89lqA+pqUgSqD8ayLHxkaPKIv1Z3HRdH+4skMWJlbO2IrdYOAqlEEPKlhgVyeDJMFWtTusSu5UbRhQhQvkf3SvjQNhmYu/e2bYMeDo9amSVdLjed0s3Cm0EzGDSTtmAws+4W+TwfZ2xXLsvU+cJbygdAf4I6hvG3NakNwc/mtCP1rhL9gOpENcJDYJJ7Qplu5KDh1Hp1xlPeGn/3rmIqaby2Qo5glAfGg/3rxPr8ymquE9Ch/TiqTqyEDSt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(5023799004)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1RRlA100Nks+k4dStnFUBvPpKzkHLE7z8MhcXMAmUljVqSHiWHYNXaR7iCDv?=
 =?us-ascii?Q?HNvITZNkFgtYe7N0mNsIFpsqyPL/UU6IntrEvneQZVV3Vis8f1friZs4flbF?=
 =?us-ascii?Q?Dru+q3oN0h6H7g0sjFY36ArqyVpyRZ10OoChk3z4sHcZSaEwC9Vf3eIscPgz?=
 =?us-ascii?Q?UPhBz/1GIwLP6fPEXAOICm/Dalz6rGJh/cBNoT5cg4kllg1Rfs+e9+9v0yYL?=
 =?us-ascii?Q?7S5ChIUO8UKAuLt5zDbm8/w//u2cMRI8xIUnAiT6moYUk8enoVIplUjQ2e7t?=
 =?us-ascii?Q?tLiyf1ZuLpiER+1Ik/0ctQU2s0bbEAfku7Hxo/Uy1MfSMgHGzRzkHv9XIGxx?=
 =?us-ascii?Q?nQZOxK74/hmAbHBwsVSHQNAAJ+2uP6bzNHf8AwIb20XNyBt9dN3wFc6J1K0n?=
 =?us-ascii?Q?JvBr+ulf7NO++Q1dDV4mEkk9XGGpnc5K30tH9M19LKGXW2UCmFzRj9gzP9Yq?=
 =?us-ascii?Q?dGmObPL/z3F7FSb/ew+MCABXgE04jIdxuXKmowonD5avBdVCGsAnd43tQn9b?=
 =?us-ascii?Q?64JDl0JEeZEkIcppFEvH3fSTsrFEP1vuaXwwR7qvY3g3RxCADRE9F2Xtgnyg?=
 =?us-ascii?Q?PsB/PmsRMks7lwugn3vTlBo0qwFqDVctutvCoC8c4XK1jna6qpwFyG2AFMFo?=
 =?us-ascii?Q?l2hj5Cut+8Wquc2zWQVjgMGTaMa99Cn0ZhQzibl+S69bfzAu/8tLCSRqI5oF?=
 =?us-ascii?Q?uiP5pEk/KoY7yV5IcDdFBX81iVt6P6tUkqET1ySVAPh5E7wCDWQh5CjjzdkK?=
 =?us-ascii?Q?E5bk6lsihTW0B8F5Zu1CWSSjjbzi89ot4oJFkc5lM5itzZ18zWdJ0j6RtOct?=
 =?us-ascii?Q?HqAPNz6zjnMLoVHlp8hW+znDau2I57fqll52PntNUlAK8LowYyO20iOMGQdp?=
 =?us-ascii?Q?v5CZggtL15pfg0clt4GKodZibKboq9Iu1inlI5nNlQpD4IyXBdZSMx2z+ylN?=
 =?us-ascii?Q?WeqgI7wyyp2ruRffwxlmmw8aRBXes3o3eaeMmM2jYtsg3geycdWDuftP+3YS?=
 =?us-ascii?Q?Nu8PcMfXF6Lu1ypAOHczQiB2UubA+J/5Nxbpdgzx37DuRttny31czYfODWHr?=
 =?us-ascii?Q?NoseioXE+dGLYD4UuoPJIYYinkmf9SBemSPUpN7vY8914KvNbJK0i29GvWLD?=
 =?us-ascii?Q?b2jCH+zn7t0DLbgGaGuGvKtjzn7EB4ZQ4B0LlLarjOQ6KqXNh3y5GMrGPFrU?=
 =?us-ascii?Q?ujHMQIiNtFT5bLc1cOM0KdfugvrBgKikKiH2AkvBu+XCimMlmdsJ6jmd4hse?=
 =?us-ascii?Q?YjZptch/GEGC5FnOQHjL2BTvOkS57dMA0E9yFzPPmYeh2AwDADhXRuGMzPag?=
 =?us-ascii?Q?FmrFpNbFozjTj42qwVb307BCBbTtyJ9kjxhvHhOfJo3xRdPMTxBhDjkLXluO?=
 =?us-ascii?Q?OVE71lEbqG5/7uHSrc5knLbfHFbpZskdPnxDdIsk9wd/T0N8JH3DgjPMPuvb?=
 =?us-ascii?Q?7LuJ4J7++ozjsu6MsYJitlUO7yz+TUuInlEZ5bMELoboD+NWA5LzfxI1C71j?=
 =?us-ascii?Q?eZnZdRlifLgOHZHJy4qhewYwJhx5n3SLTyN8Wzwym1hM11YS+GV9ey1Y6PQm?=
 =?us-ascii?Q?2dSYpKE8daA3ebakmyzaOBavFjqaut8Y9vnV7r9uVNsPV8bZBHFSvinOaeAE?=
 =?us-ascii?Q?NbQ9T3OZkLyleeApiNFhJALZoMW4trWBKCxzzVYXElutoxvffgq+53njdc33?=
 =?us-ascii?Q?4aEBCjySpG0Rx0G6bMCh95JTSSbXaB2lW8TcZ8b2sG5Gcp272OUoFdfr6s7q?=
 =?us-ascii?Q?Bx0B1xCCUg=3D=3D?=
X-Exchange-RoutingPolicyChecked: f7ZA6UJ43zSp8g/bLxLn6W53ual/AA62iqWPzwUN/1JVSD3/klDuA8L+Kt1cPSxHnrFBoVoyILLsyXVLENskoEDVOgyU5xgEjTkvMQsU79+0xr7h6mDfUTdc9x0CFl6P4gy8SocoiGtI+RgwdYuWzDRWxlbhOa7XKH9Mzalu9pltWFIahAIavbEquTluVNzYac1NWfKa14c650zvkT0MUn6pgcqcwh806h1k3Zkzmy3Uqah346nOwGN7USXibh001sYUvXHQ0YyOwwBRudH6G7zztYHxjxjEzb3E1KB57wjGumeJHx+YeYMLK27wXzKjVuBDD0DxoJ0xihkCl3lfhQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3004a955-edfd-4413-24de-08dec6576006
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 18:46:11.1065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ouFkG1BDHzzZCRA/MBT3f5nJxzJPC/ApZlLI6Ivv1Rg+8y1lfkx3f8/UNJKRG5phodzUGbQR9VNiT+YZu5oIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6936
X-OriginatorOrg: intel.com

On Mon, Jun 08, 2026 at 04:18:54PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 6/1/26 12:56 PM, Tony Luck wrote:
> > AET (Application Energy Telemetry) may be enabled/disabled from one mount
> > to the next depending on whether the pmt_telemetry module is loaded. If
> > AET is the only monitoring feature supported on a system and it is enabled
> > in one mount, but disabled in a subsequent mount this will result in empty
> > mon_data directories.
> > 
> > Change from a boolean to a count of enabled monitor features inside
> > architecture code. File system code only needs to know if any monitor
> 
> First sentence seems to be missing what is being changed.
> 
> > features are enabled so resctrl_arch_mon_capable() can still return
> > boolean.
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  arch/x86/include/asm/resctrl.h         |  4 ++--
> >  arch/x86/kernel/cpu/resctrl/internal.h |  2 +-
> >  arch/x86/kernel/cpu/resctrl/core.c     | 24 +++++++++++++-----------
> >  arch/x86/kernel/cpu/resctrl/monitor.c  | 11 +++--------
> >  4 files changed, 19 insertions(+), 22 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
> > index 575f8408a9e7..1e50c7dc3fe3 100644
> > --- a/arch/x86/include/asm/resctrl.h
> > +++ b/arch/x86/include/asm/resctrl.h
> > @@ -43,7 +43,7 @@ struct resctrl_pqr_state {
> >  DECLARE_PER_CPU(struct resctrl_pqr_state, pqr_state);
> >  
> >  extern bool rdt_alloc_capable;
> > -extern bool rdt_mon_capable;
> > +extern int rdt_mon_feature_count;
> >  
> >  DECLARE_STATIC_KEY_FALSE(rdt_enable_key);
> >  DECLARE_STATIC_KEY_FALSE(rdt_alloc_enable_key);
> > @@ -68,7 +68,7 @@ static inline void resctrl_arch_disable_alloc(void)
> >  
> >  static inline bool resctrl_arch_mon_capable(void)
> >  {
> > -	return rdt_mon_capable;
> > +	return !!rdt_mon_feature_count;
> >  }
> >  
> 
> This seem unnecessarily complicated to me. Can global "rdt_mon_capable" instead be dropped
> and let resctrl_arch_mon_capable() just return "true" if any of the resources are
> "mon_capable"?

Conceptually this is much simpler. But I have questions about the
implementation. The new function is trivial:

bool resctrl_arch_mon_capable(void)
{
        struct rdt_resource *r;

        for_each_mon_capable_rdt_resource(r)
                return true;

        return false;
}

But that led me to #include hell when I tried to keep it as an inline
function in <asm/resctrl.h> because for_each_mon_capable_rdt_resource()
is defined in <linux/resctrl.h> after the #include <asm/resctrl.h>

So I've moved it out-of-line into arch/x86/kernel/cpu/resctrl/core.c.

The MPAM implementation is also out-of-line.

But then I wondered about performance. This change on x86 goes from an
inline function that simply returns the value of a global variable to an
out-of-line function that scans the array of rdt resources. The common
case will be a hit on the first element, so not awful. But still worse
that before I touched it.

So I looked for places where resctrl_arch_mon_capable() is called in
"hot" code paths. There's a bunch in mount and mkdir, but those aren't
very hot.

My list (check to see if I missed any others):

1) Recurring call once per second in mbm_handle_overflow()

Seems redundant. There is a check to only start the overflow handler
on mon_capable systems (only with enabled MBM events!)

2) Call for potentially every task when reading tasks files in is_rmid_match()

Also seems redundant. Next part of that "if" looks at "r->type == RDTMON_GROUP"
which can only be true on mon_capable systems.

Should I clean these up in this series? As part of this patch which
exacerbates the performance impact, or as a separate cleanup patch?
> 
> Reinette
> 
-Tony

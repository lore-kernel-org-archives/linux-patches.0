Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D08002D3733
	for <patches@lists.linux.dev>; Mon, 17 Nov 2025 16:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763397449; cv=fail; b=f0rkg00LNsu1Tknoy88dX0AMizs90LIT+iA6jCL7LwH/NllcmRFgfPwVJA0DLIj01un0/7a/SdJhTH5vmSE+vRJ4Zq6cWEZ+OTTEHhgWJsAnI4yehMaqgohjmuKCpRYi6y8V0ZieYdq+PznBqy1ZboE2DVG0e8CixxnFGJT1FZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763397449; c=relaxed/simple;
	bh=UrUptIwIxvcP21qlBfjPenQbS7BOHOqMOEgEXXCvBsc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lmq05Lr/UFcl7NLY0oiygCPe1i+BsFXSj9rn6aeaPq3dJIOHyppPyA4MWN8P1P149bFBRDMQwHHYGSlWaCBts3EndjL/xs5W43tGYvGXvjzfmWUxOB17ua02YRucuGiO5aP5o5pjcytfFrDEYaCokBZfQgNeEfLrR5g2GDQ6ews=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NJn57ze5; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NJn57ze5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763397448; x=1794933448;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UrUptIwIxvcP21qlBfjPenQbS7BOHOqMOEgEXXCvBsc=;
  b=NJn57ze5I/PoyiU6zjyiglNamgGHgTWIo/QxhCdCh+XoM7/5avwEQ0sz
   GKnNtdvXqRTIY5dXxD+LScRkUhKc7gjFSclVfgFO5mfOJZ5iWvz7um1uJ
   sj9PEYBkX4Id6SpOBppql/dBl7y9OplisJjI9WW3dxoWWl+OEKgpIgeJW
   LAUdJ1YgnndUasa8EPoR/YLlI3yOvM0Ms6fo/e53yK9Kz6df78u1XA0/A
   9uaW3a53gDLxMK+OaVXbizetRzQo6Q8j8AvhI2YcQgUB/WXBBzq3CTpdG
   uoT5zTBL/jUK0h2LqvdvJGVt/bJ6JZegIZG6+CUqfOEKe0R3+xbJfn1bs
   A==;
X-CSE-ConnectionGUID: xyvJ//kwT/SFUDxlZDjIbA==
X-CSE-MsgGUID: 9TQVpjf2SGqOdB1UHvrmpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="76864422"
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="76864422"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP; 17 Nov 2025 08:37:10 -0800
X-CSE-ConnectionGUID: 43fD4kezQMyio5w+BJjUFg==
X-CSE-MsgGUID: 2p/vCNPYSe2BSi3UguLEXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="194602056"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 08:37:09 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 08:37:08 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 08:37:08 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.35) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 08:37:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i2/wcaadW5Jz5jFspZWiMpOkI3+HU9lmYRnAnMpz+zuIuJYtj9SMlnzXH1exCNdd2hp3V1v7lXnDE6NyXhNOjJYwkG+JVK0vx/yhIpDEZUMbNjCATqnGeu1sQq7dyLGnymA3dhU7XQwZppU5iJXvT02HP4UiegbZdwWigE5xgCJkqHEuk/sSZiBt8ZNORbZOmmt+5ZIkgPfERXf/A6K7m7QZGhiRkfisJbd1dNpykyOfMAGv4XaanGclYDg48eb9Ha02f0V5RzbLOywA8/avLo58sRAHiotAW7wGYFhB6yoGQUz08oHL+FvCjoVprl80YiJUzS4+BxrSAsYRc38KZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eAetN+O6C2nn+7ZAeLGbpWTvr09a3Sq+dR1B+KK9o3E=;
 b=YkSkM/4kJ09n2Zu4arZpX8DwbDU7fxkQQioPLPNiNJIlNm2LDAG/Hgm4MT+ArJIbc171QX92KJoTDdkCeR4guJ3PEPGyvFXzB9T8yuZQFJrLVTWiVrqz8LNpW28puHZ2lKPSeL8qREdMyWRdaWb/SeUXAUAHejMQb78uc7/COkjd06YRpFeF/R59GqYZb66nic/zLH3sG5SE9n/F0Z/gY/0+BhMIjts4BX6ZmPONMK4dUhXWhP+xb7FHzC3xOvAVS8uIxFcZ8+aPnAhLoTpSxmuA23EQH+KOg8jwpXBoLNq4e0J0lj1P8k4uWLd5G9dgYECuBdhLSroEuIehwCZ4Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB7431.namprd11.prod.outlook.com (2603:10b6:510:273::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Mon, 17 Nov
 2025 16:37:05 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9320.013; Mon, 17 Nov 2025
 16:37:05 +0000
Date: Mon, 17 Nov 2025 08:37:03 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v13 25/32] x86/resctrl: Handle number of RMIDs supported
 by RDT_RESOURCE_PERF_PKG
Message-ID: <aRtPL9IQXWiKfhEk@agluck-desk3>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-26-tony.luck@intel.com>
 <50149b02-d6ea-4fb2-806a-f16e80d3d52b@intel.com>
 <aRelbFgQ4-11Xwg2@agluck-desk3>
 <8ca676bf-7b50-4898-baf1-92241712f871@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8ca676bf-7b50-4898-baf1-92241712f871@intel.com>
X-ClientProxiedBy: BY1P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::11) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH7PR11MB7431:EE_
X-MS-Office365-Filtering-Correlation-Id: e49a763b-d66e-487b-a37d-08de25f78b25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/JaXdgHO+kwUPRXy7DwdlT5MTnvhBgJwbAdzalOXQbLmeySgUnbnrQKT3XFp?=
 =?us-ascii?Q?LkWPBGSXGop0ASHu9bjezXq5iOi3vQuAx4ONOfC9tP8TEF4hCK+1VN/G3T55?=
 =?us-ascii?Q?NFXFarBDk8GNp0qP+iHmM6T4TsE/BcgK52jyVs8jfOXZLkTRKJVPpQ7PJuwJ?=
 =?us-ascii?Q?HmYpZllpPFXFp2xSq1wkM1/ZWJnuyh2nxPXp0Q4ffWpcx7BV2iaPSLVcbb3B?=
 =?us-ascii?Q?vw+kKunz6XR82WERfl4hZgyZ90tXAO4dIXm+WuxA766IDdppU1ydvBiAktKG?=
 =?us-ascii?Q?6DBOzqPs9fE49fHXMdRK9HKkRIwDsVRHhXxtKqW7yiVyil8O6czPs+TEIrof?=
 =?us-ascii?Q?wLGeHzsUBSsClyHcqHfa9AXc6v78DTmXSUVqeW7PazgVtXzvsWwuGjrArH2v?=
 =?us-ascii?Q?/rnffpOkPlPlOtioNflY9PxIrs5yA4X+U7Vygl8Go1d4N0HE8CvcH8MzFQ6w?=
 =?us-ascii?Q?sGA0bvSrMPNlLjEBmQXZE7TvydS2oZGexR1VZwPZvt3qlg58F7tWELal0Ahf?=
 =?us-ascii?Q?S+WFj+I57sr4OI/eVZFx+5ok5v5QLAqAaiwNKTmjQ6MSL8t3b8KPrHRzsbo2?=
 =?us-ascii?Q?Yhe9jE4TM/quTlTUS8/GjlpJ54UcLANW8nePcaLaKO6g0rGG6Bux7AQyoLkU?=
 =?us-ascii?Q?GeEp1bTRw86m/V5Bw7xyhd+NJTqA6876J4f7xZqveXOuGH8iUTzwZrNWUPPW?=
 =?us-ascii?Q?CpiqlPsanu4jsqPfl6QAkiX+93wFteiORV/4hoxT3Xf1NZ/kaCx6pKjsmcT+?=
 =?us-ascii?Q?K4aXTs6RAUelTYM6KiUGArNa7okJzFwl6t5VuP8R5OJSk/ojh5eh8kl5dbzJ?=
 =?us-ascii?Q?PNxUBifKG6vmMjcpUda0v/+Y/xc3CyGUmyBUBeYrpdzV02m/22pCy37HcH5D?=
 =?us-ascii?Q?0rO94DpMjzGX9LyNoKsVhKAhcGwx2DbqeblzrtvJhkhFLmr+4BxXX2ZyPDE6?=
 =?us-ascii?Q?lmnfbUUkpPJoH3Yw47dLjyLlndouBwBkLTrtscSw/ShuUgazxHHXmbZtlcdY?=
 =?us-ascii?Q?LFD//Mk8NO0ifs+C0ZpoI/uCvv/EoXeYIPTTT13/BTn20LidwN4/i/C8LGf0?=
 =?us-ascii?Q?7pZDVznILrJoPc/OWmF5d/nxDEtL94+2+c5+sf+YLRKNZplMiQzVtk+4pHpY?=
 =?us-ascii?Q?nHP+Tus2WZR3SFnAyfFVbKBUQLrH6j/2r2nsssSiYl27PlRIAExSz9wVCTek?=
 =?us-ascii?Q?VdvlLRWKuqK4MAXRSm5ZFAMmxxecRYkrLduFxCVep19CAXelHxOiidFMIpdt?=
 =?us-ascii?Q?lLzwcSfT2X8q+yw1sCfZPWH7pwNwaI1LvNOZ/7rzobZsVN6FIw8aNZr7EQXT?=
 =?us-ascii?Q?hT0kWN1cC2yC+/PzUOON95Zc7Suz2+9LYmdH2K++6FYxxeGNJuNFCAJIYTmW?=
 =?us-ascii?Q?ifqgEqshYlbs7gn7MgDp2Y6MUAXbTqFkAx6Z96ijkaB6DhM6CO/h617Ew/ZS?=
 =?us-ascii?Q?UCqxn2k1R200D7SrL28Gju1r/OP92tzh?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l6SAjaZ9eH8P5RibzS2QsHBIR0KlkWCgVwqU4Zg7/HKNat2aidGwhUtwz9Cc?=
 =?us-ascii?Q?xeSZ53wjx/VHvAx0PG6eQBGEZyU2348xw6Gf4QWMO5N13wbpT2Q6DkCXc8K4?=
 =?us-ascii?Q?x60WNXa4f6u5dWJzb9oYh3pU2E2ZmLjzV4HimBcFCFcl0s5GOlGB11cjspvr?=
 =?us-ascii?Q?/SASJ25gzLNswziJlH7n33+vOymJvIkmZH2zM8m3yB1RuOB+eWpfNEX0JYwr?=
 =?us-ascii?Q?UTV6Ge1diBGSjuXPX/2GX84oE32DBoky7nrQ6smrvdl/etbktSOIUmPbDjqs?=
 =?us-ascii?Q?n/KOURze1+h+D4ftaUf5uaWU5gBcXQWzVzGrkUGujmupxcw47Ti1dvgALy9H?=
 =?us-ascii?Q?YADlauWyTGYo/X1aHFqgqGnYhucIj/PNt2874N1or8rR/0IqeyRlJJwrpWSP?=
 =?us-ascii?Q?fQjEsTw233cPoth22YMhvugLnt//abBxHtTelWyMcxj81wO7vN956PvLT/GB?=
 =?us-ascii?Q?gir9LL6Rq6Y7In7qj3FVebErdtIFvFmyscJgWwqWn44A60LGoMFvjJV53hlG?=
 =?us-ascii?Q?rzXepNBE6V8kh7ZqxDCBM8VvH4LOIzbhX5Dl8umFCHum9bvGOQ7gsy1fWIiw?=
 =?us-ascii?Q?bF8FqCXKhqWLTlAZUR5+j6rTsZ5sYNmVor6Q/0Eos7WDuzO955gXSvN9en4X?=
 =?us-ascii?Q?yj4Qb7m08F5ffjjFGEFIdMu94PRy5OH+6vqVBuKVAHVwdGIH7jm/GvomFlvb?=
 =?us-ascii?Q?Abik+FeCC0BMK3XPVIGTpr2F9cMcDCmfW14FwWChV3f+GMlgjsh4XyiSOO8F?=
 =?us-ascii?Q?wRASR0NfRW+wiqQ4jh5oQkeB+DxO6gtWWF2RSxsFdZcalmsFTY5YP2/eNbFP?=
 =?us-ascii?Q?+kgPE8e2E4v3T/T1aK313OC1vGRLeUQmkSel1OXbIBtumgEE9eB867IA8YGF?=
 =?us-ascii?Q?+rXpBSadO4+Zue4SPKCk4dDTgL64AyVLB3TGvbRg8dHmKFTT1NRnxRuECcyI?=
 =?us-ascii?Q?Hoj0xI8IFHu/S1UmHVF40Vvfh3l4E44S2Z5iiBDq1JRPGXN2Z24lsRevSiQ5?=
 =?us-ascii?Q?Izi2lmGpfB5RmeTSVMFE9M04jaJAMYDLqWE85mGSamB/c1Q4Z4dxhYzsRg9c?=
 =?us-ascii?Q?n6Y7csXEs+IRFChZK+G6YFBxUcAtY4F/EiuaR4JlsnRfr553/WXQswqa7+vM?=
 =?us-ascii?Q?aBVgVMnvvJa2g9KBdqbv2Ht0nQhQsyqNnGniZHaqUs4l9j83MkSjaRTqVZVm?=
 =?us-ascii?Q?/bBUBC+GdIzZtALQxBOsqAKNAFKA76wMD1K+Xg2TmV9cLCO/IOgQg1Sdwj/q?=
 =?us-ascii?Q?1kJaMfhz6vdGzfXc9TImXLYgHdxlq0fw8wbQHJAllvu9tdj+8NCKyYVH5xmT?=
 =?us-ascii?Q?c49txknTgVWBGg37xvvu6y0v8TtbzsMWq9qAHQEkMjfN+zKBhFJmuU2XmOfQ?=
 =?us-ascii?Q?202fiLlg5m776kZI0TskD086mTZw/5ot5i+NChGfCToY/AYjmbmeNf1QLkKo?=
 =?us-ascii?Q?nG/xAl9lvzbiOOaA4jBXOQD18A/T/66hoSJdKUePEPTJ35glIOk7v/xLx4oa?=
 =?us-ascii?Q?WfSFQIEx0MPMZty4mhIE4GG0Pd2cuf0qndfNWn3HoTUo2hWHss8A60ZgwJ40?=
 =?us-ascii?Q?OQj+KVlREV4ZX1wj9YTtiL70LC6Z/WCQpL5SbXAP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e49a763b-d66e-487b-a37d-08de25f78b25
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 16:37:05.6502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z5RpoYWwicflkH+sNoABqOH8cI/H77lgG+jVuEzzPhAHm0mzwoX8gI0EGn/ui/lZ6u+TS7ncYKhhM8XvN0LDFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7431
X-OriginatorOrg: intel.com

On Fri, Nov 14, 2025 at 03:26:42PM -0800, Reinette Chatre wrote:
> Hi Tony,
> 
> On 11/14/25 1:55 PM, Luck, Tony wrote:
> > 
> > resctrl: Feature energy guid=0x26696143 not enabled due to insufficient RMIDs
> > 
> > 
> > static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
> > {
> > 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> > 	bool warn_disable = false;
> > 
> > 	if (!group_has_usable_regions(e, p))
> > 		return false;
> > 
> > 	/* Disable feature if insufficient RMIDs */
> > 	if (!all_regions_have_sufficient_rmid(e, p)) {
> > 		warn_disable = true;
> > 		rdt_set_feature_disabled(e->name);
> > 	}
> > 
> > 	/* User can override above disable from kernel command line */
> > 	if (!rdt_is_feature_enabled(e->name)) {
> > 		if (warn_disable)
> > 			pr_info("Feature %s guid=0x%x not enabled due to insufficient RMIDs\n",
> > 				e->name, e->guid);
> > 		return false;
> > 	}
> > 	...
> > }
> 
> Thank you for considering. This looks good to me.
> 
> I now realize that if a system supports, for example, two energy guid and only one has insufficient
> RMID then one or both may be disabled by default depending on which resctrl attempts to enable
> first. This is arbitrary based on where the event group appears in the array.

intel_pmt_get_regions_by_feature() does return arrays of telemetry_region
with different guids today, but not currently for the "RMID" features.
So this could be a problem in the future.

I think I need to drop the "rdt=perf,!energy" command line control as
being too coarse. Instead add a new boot argument. E.g.

	rdtguid=0x26696143,!0x26557651

to give the user control per-guid instead of per-pmt_feature_id. Users
can discover which guids are supported on a system by looking in
/sys/bus/auxiliary/devices/intel_vsec.discovery.*/intel_pmt/features*/per_rmid*
where there are "guids" and "num_rmids" files.

> How a system with two guid of the same feature type would work is not clear to me though. Looks
> like they cannot share events at all since an event is uniquely associated with a struct pmt_event
> that can belong to only one event group. If they may share events then enable_events()->resctrl_enable_mon_event()
> will complain loudly but still proceed and allow the event group to be enabled.

I can't see a good reason why the same event would be enabled under
different guids present on the same system. We can revisit my assumption
if the "Duplicate enable for event" message shows up.

> I think the resctrl_enable_mon_event() warnings were added to support enabling of new features
> so that the WARNs can catch issues during development ... now it may encounter issues when a
> kernel with this implementation is run on a system that supports a single feature with
> multiple guid. Do you have more insight in how the "single feature with multiple guid" may look to
> better prepare resctrl to handle them?
> 
> Should "enable_events" be split so that a feature can be disabled for all its event groups if
> any of them cannot be enabled due to insufficient RMIDs?
> Perhaps resctrl_enable_mon_event() should also now return success/fail so that an event group
> cannot be enabled if its events cannot be enabled?
> Finally, a system with two guid of the same feature type will end up printing duplicate
> "<feature type> monitoring detected" that could be more descriptive?

I need to add the guid to that message.
> 
> Reinette

-Tony

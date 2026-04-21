Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23795388E6E
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 20:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776803117; cv=fail; b=Qv+0VbCby6LzDFwmOZtlfxOoVz6vSEilLuG1S/v+0eJDunx7pNtIpPFlQZtUCzKWjjX8Gq4YyC7R5SoMadDWgPr2ink7E+cg1WcQNqG4tgWz+96ACFjv3rMS/BOCllpAfeA7Kyd+10LctRu5u8yacQ6ANBc+GzoLers9oO2HBqM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776803117; c=relaxed/simple;
	bh=a9zkKyWA2QEwzmhPWiSWrkfcbFKpMl6SlWa1A7mYdgE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iOrwTzH60vVLKJpgmh/f8mLYAqyapaeTc/SOWMx8aiaqthekue6NrbSl2mkz5IgdTJFMCFpEORYNBzgnOw1r+ky+4aCo49587pCBKfxfQUDpbk8SKdmAsSsmu/vLhmPBMcywkMiOlDx9tCVU/BDCpze9YMuoCcO/Kzqv7TFWGxU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mJMy9T99; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mJMy9T99"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776803115; x=1808339115;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=a9zkKyWA2QEwzmhPWiSWrkfcbFKpMl6SlWa1A7mYdgE=;
  b=mJMy9T99noex+OeQzsPXsd+AO9+KEBoBW9NcLBtZfhePRqgbweCHo4mS
   zjSfwszGZhBArX73ud7bq/pd7RX35q6RO26X5++q0/i3c7QJqo3Y7KCsm
   ZYxDIqaScfGtbyun7U2PQ6LcfMVuB36hF95WMIgzcNKQQn3vGxBvAWSw0
   NavgTynftGdcFyFJjy0mtjwH5D95z2fFOD8xMawm9aMsO2iFXRr9B0/Dm
   prKwye3T4HXkWPaUsGSTJCRlIWEuVhe2sU7tjcqOn4ouL9U6ejzft7Glz
   9uRZjON9SYF/7G9kFz85YTdQieQ7jCCoKkR1k6gBhDVxpdNOvEhrXy2ik
   w==;
X-CSE-ConnectionGUID: JoobPmEjQji8iYccvY8QUw==
X-CSE-MsgGUID: YLR1veJXTKmu+u1c4+owpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11763"; a="89131184"
X-IronPort-AV: E=Sophos;i="6.23,192,1770624000"; 
   d="scan'208";a="89131184"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2026 13:25:14 -0700
X-CSE-ConnectionGUID: imAYG3a0RDm2ggOXg9zgQQ==
X-CSE-MsgGUID: tEAWOIiGSKWld3ihT9znjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,192,1770624000"; 
   d="scan'208";a="237168177"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2026 13:25:14 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 21 Apr 2026 13:25:13 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 21 Apr 2026 13:25:13 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.47) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 21 Apr 2026 13:25:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LAsDsGqVgO1/mlW0TueEYmj2+kEyD6hFXcDP44Aj1Th8CoeFDBRKR1VTyLrGDijca+obLJQ77psxm5UiFioVgHrjeQPpjXpuCJrAem538U+KyCIZe5hVzqbwOJXPaQ+xlB+PJcxhOqkYw8H4NgR7j8T5thPTW9KEpmMrHWeNPLSIg6ufyY2bgfVDlrYyRcM1lc4rJ3GnEH6waZh7v2wkwzSYmJGdxPGCdzH60q9MPTqpsOALiGQdhZDdt8OFIshFBPfatK6apDY982Fl68Z+0xJakqwZy1rYB3zoXrTiJEpC9xjieOr7O+ssz3Q/dp7koy8jaI4Pmwxoi5CjF53Tow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tXPZmb6hQrEg3YTAtoSPqGhhXwHtRXa+u/LBHiV/vFc=;
 b=iuT+3Y416/KMC82VGVR8SszEs9R7XoavGkxyLPNK01zCatW5XXyJ6oeC1D9vENyw12zBJfpJFKEpkjQ1g8TGNHDnQZcyAEfmaJiR4U4XOEZqRwQWFKtQt60MRV44+wk9p3G49+ucfpdZC7+6oVQgLWkRYWlzUbGgitDePKrj4X2huuK7sCRtlINLaKDeATYkwT2O2GhQqS/yONF5thwl/7ML4mRR9yeTOygpZSEzS8RW68dXbpOB3YfmMGRpk6a5w9fNkcGuiGpAyWGaj8lJ5h+BE6SFW98CoZqYdihNo1jTuQmpyTNwk4nh7rJWoDZsBEJrBb2I6mU+tWo7N2D8dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB6954.namprd11.prod.outlook.com (2603:10b6:510:205::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.15; Tue, 21 Apr
 2026 20:25:10 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9846.016; Tue, 21 Apr 2026
 20:25:10 +0000
Date: Tue, 21 Apr 2026 13:25:08 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v4 4/7] fs,x86/resctrl: Add architecture hooks for every
 mount/unmount
Message-ID: <aefdJG4y8JS_aTse@agluck-desk3>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-5-tony.luck@intel.com>
 <45436044-202b-4d77-b552-2156be47a52d@intel.com>
 <adQY_m8I2jUiR88k@agluck-desk3>
 <e85cd466-2202-4b40-82ed-91e421d8e073@intel.com>
 <adgNfJSeHVyBXumt@agluck-desk3>
 <c948c358-1dcb-4896-9c0d-239e99d89e72@intel.com>
 <adlIdusn61pKB3oq@agluck-desk3>
 <5a62a2b8-fef8-4808-bbcc-c268f9013651@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5a62a2b8-fef8-4808-bbcc-c268f9013651@intel.com>
X-ClientProxiedBy: SJ0PR05CA0125.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::10) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH7PR11MB6954:EE_
X-MS-Office365-Filtering-Correlation-Id: 73ffb6d5-150f-4ad8-32a6-08de9fe415b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: OflVju2Cr23nn0xVQQpVezExAFGv+e4m7Eqq4q5MR+mCJOCao7MHB1ooz5ahf4B7R0VUvrKoJZHKdcPo4qLsQ/Gdq6wiyQ7dy5uiBta5rdWcix3ZRvGQEyeO8bCkqy0woenTLPEGKEg02xOElbespCiQ1LbJgPKU3DfluWm4vKlipTEGdDdm7hi4f8WktnDBxF7juwAZ9hgGvya1zEzNODjCzIIpb3zZuaGEb1HqxrUYsuXKKw8gOhL6sAdA66xOVYyewuK6WAlFKV7NodQPZyP0hjg8Opi3DA37NNQjqpTPK/NpZclrtxxKtTBSnUsHD8ThkSEFrxZGhvZaXs8yrElGKCc1n778SaEpQ2Gki98NU+40A00BodhT2XeCmCtTIgdVCw1OMaCSS5Ex0M6VK3hAIodbSBi8JDFZWpkx2AqlcIkxyIbGr3kLLd3PyzPSqzq4OD1blwNjGHBbWvXVAtzLWyzQjXlz70pMsWWEUSAMZrkOzKx98Gl6uL5RVr2fN7xX+kJycg+AKoreF/xGo8fefySqO+YKBErEQ5zmjgejl3/AnGiYLtzxcR/SVJiJ9geclNpWLupJUSCcQwhnoosRXGTCOHYL9C3/R8++uXFZzrGwNKTY9KF7d6wnh09h2+nGuyt+Yxp91WXsitdJfWetNSOIAaPx97OJsS6uBRhtXX5+0v0mHEL8yRS3WHNANnMsHJCQV5G+jpBFWp5WDh7iM8kZdPQ4IJN2SHhoE3I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GvFJ3S8zLW2bg7EYMMc4CPjSgKpPu8FktPoyF3aHHOLaLVV0uOKftvee4qS/?=
 =?us-ascii?Q?r7jDgZd4LlhqA3nEhYwGhQI3S8cBzq3bME2vKWaA4RzOYe8UW73yoK3+/kOp?=
 =?us-ascii?Q?+DpevbZjeDLDmFKlWL4wm/KKjSmu2RivxY1luVn5x0+vNzan/Ufddd56Imma?=
 =?us-ascii?Q?s7qV3mz7FdOcyFObAl1Obv0LjqSW2UMcRX/cx1dw/W3xjGNUN3zkvIGy3oJ6?=
 =?us-ascii?Q?83lbeeHvfNiNQA8Y+XKk8q0pTGPybm8XgDg/L9lif8sj2vFqAhmwUFm3vDiP?=
 =?us-ascii?Q?mOFn2wjIX39uggafW/jdXmI6sm31zMHzaJecNL/erWJJMBopQhoZPcajUsjd?=
 =?us-ascii?Q?cFM7ojth7BcFsJDFEy2xyHxpXdwjCB8QFQpYGo6mCx9sA4UzHrcy/NEDigpn?=
 =?us-ascii?Q?NvXduDjcNvbb0WyeaGTNPN9zgDnmVuAVQQQO0Zc2A5JkNBmOL+FXZVJovDAe?=
 =?us-ascii?Q?6wb/GI/ZZEU8suqnMvSGVG/FW9wVBar4Qagx6ozsBe75u6PRXgVVP3EBIqBt?=
 =?us-ascii?Q?5afsH1Y4lqGx76rY8cbFUeCBdPjS8HaPWebp0GDiAcGVZNtwp8fdKhspX8+B?=
 =?us-ascii?Q?CpCBf9G8kTXivIkjH7grVBNnuPqnDkZ0fo3QJAvPLnOs972fkZHYjA9hOCIy?=
 =?us-ascii?Q?0hVf7Hhu8wqbYa4qJ7j+35uLq+13b9DbmmUsRjympkDYqCP06wR7UmnBTKIz?=
 =?us-ascii?Q?F0rZt8j9u114oKgthjiK2cCkgcFRZQ8oy1yRH4D1gkkyxv7aqFOXp990+3iJ?=
 =?us-ascii?Q?4sPScl3Oe0ftYwMniI0dpIS33kZt6TghtM0x/Nulhv4fYxaR4x1baA2qRwuP?=
 =?us-ascii?Q?e5C/HH7gkQkG8gzLrqtJ8RPPHTMINwf9Siuvbk5TwUooyMYXeLIO01vzpK6o?=
 =?us-ascii?Q?LZlO0AsGIuZYUVQlTQSzQq6yneyCbi68EOK4octEwc7NN1fjmyeAfZz1qVjV?=
 =?us-ascii?Q?sgskxGu6kRQPly99HyQ4I4damPUjALq0J5usiiXfNAJuQPL3a/upYZLnEU1G?=
 =?us-ascii?Q?dJdSPY6rYqk78EPIiln8Xb4C52WFq85bdODCbx6jH3ucM/pgfkc1kX5bEocq?=
 =?us-ascii?Q?yeUAS+XnuODZKgK5mySqGLmlydDG9pH1n5rugukAjsCShDv5lX7loc2vL7A1?=
 =?us-ascii?Q?T0L743XxKMFpiAMENvgYWSzDCsdCbUWeaRiwISH1hcmfaFHjuHBALeXdeT3a?=
 =?us-ascii?Q?a368mm0eCD1OX7nQZntN+GsqIeZ/zqq94QWI1tuCHxlAFoUB6xl6Ag7qmblH?=
 =?us-ascii?Q?NFLURq4JzfLfZT0aNBdaN+oDpMU7HnZX1p0+gDgDkLaQ7/bMgh4339diOdeH?=
 =?us-ascii?Q?xGh93M6ejmGfJ0VjGlldAnM97trsW1pZVkP8mR2f/tZj5ahX0lCTQCkj4/6i?=
 =?us-ascii?Q?ZKy4b9CKGo8KpQTIWlaWBmKvBfp1dLbE4wYO7+fT2CIVinnUSJogZ7bv78/W?=
 =?us-ascii?Q?UUOKhX7W+8sbTSO8cE5rmfGas0HT/KNTOPEDklFiV5+oSGhx6YHDwMY8491i?=
 =?us-ascii?Q?sFWwQOUadXmEX5f7NQydoGzMmlwTsMVTw2d6/tmjdj1mxw4gqgjdMrhy6gwh?=
 =?us-ascii?Q?bXFI2ux8EJSYWMqyrfWx0ByZW/cayKG704kr6873Cm37d6iTip3IHOSg1YHV?=
 =?us-ascii?Q?mpRKUFT8589fHN5jRbE7yQrGw7lH0MA/8KqS8uF321L0yFXVpaFOOoGyBWF3?=
 =?us-ascii?Q?8uccl2HD9lEe1VOFLzZ8zEzL2Mobtj34CCYGAAuBvWZH2bkditpDtiVSi11T?=
 =?us-ascii?Q?4FY6EElBqA=3D=3D?=
X-Exchange-RoutingPolicyChecked: uKPsfrVuCy8Th9FsNiwC9Q4bxOdbBetGHglqr3JpmTGpCJw59shSL2fYVBbzIaspnxBlGPRpn/SXpgrECJi6oO9stvoXy8SVT9lcemp5RzQV3q/uQ3/cDAPBqhmfG8NjVlNhUnBnNKf75qR6Ok39kYFonE8wdvfq9srVUrPHYau35P0CKvQHXi+HKOchlu3uQ3kt4zYBM8mvn9811qhj2BqLg776luCybTqrRYvED6B9KzbPW5/bUHwhEbh359GXo7Uo79SCPe97aLNerKdE9bTSksTDvRByDxbxPj5hbec5/U/NS4d6bCQX4tE+UdMGSQIkVEiRRrmM4hLbSRfJQg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 73ffb6d5-150f-4ad8-32a6-08de9fe415b9
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 20:25:10.1046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dWZnyBL2n2a5fsGDXVaordBv44F7oGDA4fCYfuKlOc76R2XkuYgquGFhcArX/nNrE2ZhkykDTx10pYmA7dQAwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6954
X-OriginatorOrg: intel.com

On Fri, Apr 10, 2026 at 02:21:35PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 4/10/26 11:59 AM, Luck, Tony wrote:
> > On Fri, Apr 10, 2026 at 08:16:50AM -0700, Reinette Chatre wrote:
> >> On 4/9/26 1:35 PM, Luck, Tony wrote:
> >>> On Mon, Apr 06, 2026 at 02:16:46PM -0700, Reinette Chatre wrote:
> >>>> On 4/6/26 1:35 PM, Luck, Tony wrote:
> >>>>> On Fri, Apr 03, 2026 at 05:52:30PM -0700, Reinette Chatre wrote:
> >>>>>> On 3/30/26 2:43 PM, Tony Luck wrote:
> >>
> >>>>>>> @@ -2900,6 +2893,30 @@ static int rdt_get_tree(struct fs_context *fc)
> >>>>>>>  	return ret;
> >>>>>>>  }
> >>>>>>>  
> >>>>>>> +static int rdt_get_tree_wrapper(struct fs_context *fc)
> >>>>>>> +{
> >>>>>>> +	int ret;
> >>>>>>> +
> >>>>>>> +	mutex_lock(&resctrl_mount_lock);
> >>>>>>> +
> >>>>>>> +	/*
> >>>>>>> +	 * resctrl file system can only be mounted once.
> >>>>>>> +	 */
> >>>>>>> +	if (resctrl_mounted) {
> >>>>>>> +		mutex_unlock(&resctrl_mount_lock);
> >>>>>>> +		return -EBUSY;
> >>>>>>> +	}
> >>>>>>> +
> >>>>>>
> >>>>>> This does not look right. Here too is resctrl_mounted accessed without rdtgroup_mutex
> >>>>>> held. This change implies that resctrl_mounted is now protected by resctrl_mount_lock
> >>>>>> but resctrl is not changed to respect this throughout resulting in unsafe access of
> >>>>>> resctrl_mounted.
> >>>>>>
> >>>>>> Does this new resctrl_mount_lock need to be in resctrl fs? It really seems as though the
> >>>>>> needed synchronization belongs in the architecture. Could this instead be accomplished
> >>>>>> with a private mutex within the AET code?
> >>>>>
> >>>>> If you dig in lore for the v3 of this patch, you'll see I had the mutex in the
> >>>>> AET code. But there were some complications.
> >>>>>
> >>>>> 1) Need to acquire in intel_aet_pre_mount() and release in intel_aet_mount_result()
> >>>>> which is legal, but makes code more complex when call chains need to be compared to
> >>>>> check that the mutex is being released correctly.
> >>>>
> >>>> Why was it needed to hold mutex for so long? I cannot find explanation here or in changelog
> >>>> of v3. I did not remember correctly and considered the AET code to be doing the domain
> >>>> addition. Even so, I do think a mutex internal to the arch code can be used to manage
> >>>> the synchronization. Could you please elaborate why this cannot be done?
> >>>
> >>> I tried to move the locks into architecture code. But main problem is still
> >>> handling when a user tries to mount an already mounted resctrl file system
> >>> and gets -EBUSY.
> >>>
> >>> In that case file system calls resctrl_arch_pre_mount() with the file system
> >>> mounted. You suggested that the AET code could detect and ignore a repeat
> >>> enumeration by noting that the event_group "(*peg)->pfg" is non-NULL, set by
> >>
> >> It would be great if resctrl only needs to enumerate once but I do not see how that
> >> is possible since there is no clear indication from PMT driver whether (all) its 
> >> data is ready or not.
> > 
> > That was the root problem. But allowing INTEL_PMT_TELEMETRY to be a
> > module adds the additional constraint that the module cannot be unloaded
> > while resctrl is mounted. If that happens, the mappings to the MMIO
> > space disappear. The existing intel_pmt_get_regions_by_feature() and
> > intel_pmt_put_feature_group() do not do module_{get,put}() to prevent
> > that. New series under development addresses this.
> 
> ack.
> 
> > 
> >>> the original enumeration. But that fails in this scenario:
> >>>
> >>> 	# rmmod pmt_telemetry
> >>> 	# mount -t resctrl resctrl /sys/fs/resctrl
> >>> 		... succeeds, but without AET present
> >>> 	# modprobe pmt_telemetry
> >>> 	# mount -t resctrl resctrl /sys/fs/resctrl
> >>> 		... enumeration success, but now calls resctrl_enable_mon_event()
> >>> 		... with the file system mounted
> >>
> >> Thank you for catching this.
> >>
> >>>
> >>> I think the bast solution for this is to change definition of resctrl_arch_pre_mount()
> >>> from "called on every mount attempt" to "called only when resctrl is NOT mounted".
> >>> This is because architecture code cannot tell whether the file system is mounted.
> >>
> >> Does this mean the addition of the extra locking in resctrl fs? I am not comfortable with
> >> that asymmetrical locking.
> > 
> > Conceptually the change here is from "architecture must do all
> > enumeration before file system code starts" to "architecture is allowed
> > to make changes when the file system is not mounted".
> 
> This does not seem to be something that resctrl should enforce in general. Architecture
> could theoretically make changes any time it wants and stage them for resctrl fs to
> consume when it is able to do so.
> 
> > There are currently several limits to what is safe to do because file
> > system only does a partial cleanup on unmount. But general development
> > direction has been to move initialization code into mount path. For AET
> > things need minimal tweaks today. For some future feature more
> > refactoring from "init" to "mount" might be needed.
> 
> Right ... and we need to consider how the architecture and filesystem boundaries are consistent
> so that this is managed well. Just adding a lock for convenience does not seem appropriate to me.

I think it is more than convenience. Allowing file system and
architecture to run asynchronously at all times means more race
conditions need to be considered and addressed.

> > 
> >> I think a problem here is that resctrl_enable_mon_event() gives the architecture code the
> >> capability of manipulating internal resctrl fs state directly. This is a consequence
> >> of the original design before the arch/fs split. I see the additional resctrl fs locking
> >> as an attempt to make it easier for the arch to manipulate fs state but I do not think we
> >> should go in that direction, instead I think it is better to improve the arch/fs boundaries
> >> here.
> >>
> >> To that end, what if resctrl uses its familiar "capable" vs "enable" separation here?
> >> That is, the architecture informs resctrl fs whether it is *capable* of a feature and
> >> resctrl fs, based on interactions with user space, determines whether the feature is
> >> *enabled*?
> > 
> > For the AET features user space could look at /sys/class/intel_pmt/*/guid to see
> > which events could be upgraded from "capable" to "enabled". But how can that
> > be conveyed to "resctrl fs"? Adding more mount options would seem to be
> 
> User space should not be involved here and I do not see any need to add new mount
> options. It is the architecture that marks events as capable if it supports the events.
> 
> > the only choice. Config files under "info/" are only available after
> > mount. But by then domains have been created and the top level mon_data
> > directory populated.
> 
> Why would this be needed? 
> 
> Here is how I understand the relationship:
> 
> - arch enumerates a new feature at any time and calls resctrl_capable_mon_event()
>   to mark any event discovered during enumeration as "capable".

This is possible.

> - arch is responsible for domain creation and is trusted to do so *after*
>   marking any events as "capable", any needed per-domain state is created for
>   the "capable" events.

This creates a new problem. Domains for monitor resources are created
for resources where rdt_resource::mon_capable is true. But this is
visible by file system code. Maybe the same "capable" -> "enabled"
trick can be used to separate architecture creation of domains from
file system use?

> - when resctrl fs is mounted, before creating any files, resctrl fs automatically
>   sets all "capable" events to "enabled". resctrl fs will create needed files only for
>   "enabled" events. 

This has a new race. Instead of a binary problem of AET either being
fully enabled or completely missing. User may see some subset of events
if architecture was in the middle of looping over events marking them
capable when file system is mounted.

> - if an arch discovers new events after resctrl is mounted then it can still
>   enumerate the events and mark them as "capable" - resctrl fs will pick that up
>   on remount.
> 
> - arch can only disable an event as part of the unmount handler, this will clear
>   "capable" as well as "enabled". This can be enforced with a check in the
>   callback where only rdtgroup_mutex should be needed to access resctrl_mounted.

Seems OK. But to make sure that events are accessible, architecture will
now have to "hold" the pmt_telemetry module regardless of whether
resctrl file system is mounted.

Since architecture doesn't have a reliable indication of when the file
system is mounted (or if it ever will be mounted) the hold prevents
pmt_telemtry from ever being unloaded.

> > 
> > This also runs into problems if INTEL_PMT_TELEMETRY is unloaded between
> > telling the file system that some set of events are "capable" and the
> > file system asking to enable them.
> 
> This is existing problem and sounds like you are solving this with the module_get()
> and module_put(). 

My solution only works if architecture is called in initial part of file
system mount, and trailing part of file system unmount. As detailed
before these calls must be without rdtgroup_mutex held because of the
need to hold cpus_read_lock() and domain_list_lock around domain
creation and removal.

> > 
> >> For a simpler addition resctrl could obtain a new helper, for example,
> >> resctrl_capable_mon_event() that only marks an event as "capable". resctrl_enable_mon_event()
> >> could remain as the "early" call that marks events as capable
> >> and enabled but may be deprecated. Both of these *have* to be called before any domains
> >> are created since per-domain state would now depend on whether the system is "capable"
> >> of an event or not. resctrl fs can assume that all "capable" events needs to be enabled
> >> and it can mark them so at the beginning of each mount, resctrl will only expose
> >> "enabled" events.
> >>
> >> There are likely some simplifications on top of current implementation to not make
> >> this too invasive.
> >>
> >> What do you think?
> > 
> > I think it opens a new can of worms. Maybe the most challenging is for
> > the file system to add a "hold" to the INTEL_PMT_TELEMETRY module when
> > enabling an event.
> 
> This is a different problem that needs to be solved also and it sounds as though you
> have a solution for that.
> 
> >>>>> 2) The "only mounted once" case meant extra state (AET_PRESENT, which you note
> >>>>> in next patch may be redundant) because intel_aet_pre_mount() is called, but
> >>>>> needs to do nothing.
> >>>>
> >>>> Right, I do not see need for extra state. In fact, since it is not clear to me that
> >>>> PMT enumeration will be complete when intel_pmt_get_regions_by_feature() is called it
> >>>> seemed worthwhile to only rely on event_group::pfg - if PMT enumeration was not complete
> >>>> during mount N it may be complete on mount N+1? This creates a poor user interface
> >>>> though since user would need an alternate way to know if AET is supported and then
> >>>> a "remount until it works" approach.
> >>>
> >>> The race remains, and is lost if resctrl is auto-mounted at boot from /etc/fstab.
> >>>
> >>> The user can tell if AET is supported with:
> >>>
> >>> 	$ grep ^ /sys/class/intel_pmt/*/guid
> >>>
> >>> and checking if any of the RMID based event guids are present on the system.
> >>>
> >>> Delta T for the race is small enough that delaying the mount to some other
> >>> startup script should be sufficient. Users are likely to have such a script
> >>> to create the CTRL_MON directories and configure schemata for their workload.
> >>> So annoying, but easily solved.
> >>
> >> I do not have a clear understanding of how the new implementation with registration
> >> function will look to understand the races involved.
> > 
> > I think I'm ready with v5 of the series. I can post (as "RFC") so you
> 
> You consider it ready without completing this discussion? I interpret this to mean that
> I am wasting my time trying to discuss. 

My apologies again for this.

> > can see, and comment, on the details.
> 
> ... and it is already posted ... before this discussion is complete ... unless you feel
> that the hour between your response here and the posting of the new version is sufficient
> grace for me to respond.
> The first four versions of this work were all sent within one week. I tried to
> collaborate with you on v4 but now you sent v5 without completing the discussion.
> I cannot collaborate with such rapid attempts at throwing stuff to see what sticks.
> 
> >>>>> Adding resctrl_mount_lock to the file system code made things simpler. The
> >>>>
> >>>> Adding complications to resctrl fs to make things simpler for x86?
> >>>
> >>> I believe it is necessary, since architecture cannot tell if the file system
> >>> is mounted.
> >>>
> >>>>> pre-mount code can't be called with rdtgroup_mutex held because it needs to
> >>>>> build the domains. That needs cpus_read_lock() + mutex_lock(&domain_list_lock);
> >>>>
> >>>> ack. Can an arch-specific mutex be used instead?
> >>>
> >>> See above.
> >>>
> >>>>> I need to add more comments on locking. resctrl_mounted is only modified when both
> >>>>> resctrl_mount_lock AND rdtgroup_mutex are held. I believe that makes it safe to
> >>>>> read the value of resctrl_mounted with just rdtgroup_mutex held.
> >>>>
> >>>> ...but not to read it with only resctrl_mount_lock held as in snippet above.
> >>>
> >>> Holding either of resctrl_mount_lock or rdtgroup_mutex makes it safe to
> >>> read the value of resctrl_mounted as it can only be modified when both
> >>> mutexes are held.
> >>
> >> I am concerned about this approach due to it not being symmetrical and how resctrl fs
> >> now adds additional locking to accommodate drivers.
> > 
> > I'm not sure I see the asymmetry. File system code already calls architecture
> > code with some set of locks held. This just adds a new lock (at the top of
> > the locking hierarchy) that is held across calls to resctrl_arch_pre_mount()
> > and resctrl_arch_unmount().
> 
> The asymmetry is in the inconsistency which locks are used to interact with
> resctrl_mounted ... in this version at least.

"Double/split locking" is used at various places in the Linux kernel for data
structures that need to be accessed read-only in separate contexts. Both
locks must be held when updating the data structure. AI (Gemini) listed
these high profile instances:

struct task_struct: protected by task->pi_lock and the rq->lock

VFS / dcache (Rename Operations): must hold i_rwsem for source and
target of the rename

Netfilter / Connection Tracking: Modifying connection state requires
a specific bucket lock and the status-change lock.

> 
> Reinette

-Tony

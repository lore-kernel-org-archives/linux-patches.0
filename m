Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DA32DA74C
	for <patches@lists.linux.dev>; Thu, 11 Jun 2026 18:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781200868; cv=fail; b=sZcE8Z0Pz0+0/aCYHBxUj3X0D00o78zFeUqIrCLwHrLnzktATlU8rvLSyKAKnB9gNogExcRZzV8/xZ7l+Hndjv20XUyKQ2mQ+5JK/vsxJ30qkkcjEIi+mI245e/4m+KnhNMj1chDTLBuRAHGRX+R5AWAYlivHgc2PaMgi7wNisU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781200868; c=relaxed/simple;
	bh=cSwYtn9lsadE5sbQzyWVlF4wp21caWIKqyO5qUj/8jA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SMJnepEd6JdY7zK3JE4ji8jItHJ6UAJemm19VP4CeLS1/816FgseSYAcGlM6+KsBjYT/mM8wN6fN7f16IT110LfcW11Jgitn9jDZ2RTMVaZHFRaixvDErUqRgmzirT3uYWukwuYafqU0pMeROlcWsR6QpaRKW3IIciyvyBD4Fzk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G1hr9L+e; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G1hr9L+e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781200867; x=1812736867;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=cSwYtn9lsadE5sbQzyWVlF4wp21caWIKqyO5qUj/8jA=;
  b=G1hr9L+eKZfaNCiQ53hpRz4dqn+hP4VpRlPwW+gB+KkyHbsZHglFWU13
   2vhsG2rF//vWpaGIE6hBnfAPHsWcTrrFMLqHQBayJALi4dSxankU+Rh4M
   2DqLjo8na5gzviND0pFhe/PcDZ7obYr3mvsuQFPIhAcgcP65E7xQriLwk
   tegq6PUu5YUrPiF8xPanLO5OLrVCgz8BMVs9tOJ6OmcsAIgxhNJYdkXuZ
   ddmtdXWDWRrDTFEchJ2RWFQK2rVIH5lCD6m/yqXr7ov0DKE9AHzIPjg51
   vH7aX1H9zfXkmvYdNTXHurDgspzeoNKw6WO2Z3NwQft4Z0EdQ6H+AgZoy
   g==;
X-CSE-ConnectionGUID: 7G3qsTKHSbaISv1SFDW4Og==
X-CSE-MsgGUID: aIumL6scQ8qNuWlxnfUmVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="107458917"
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="107458917"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 11:01:06 -0700
X-CSE-ConnectionGUID: kezFj2glSfS5PDUYNROtEQ==
X-CSE-MsgGUID: h50i8IvxSnWgJPIsTGgK8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,199,1774335600"; 
   d="scan'208";a="248446778"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 11:01:06 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 11 Jun 2026 11:01:05 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 11 Jun 2026 11:01:05 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.8) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 11 Jun 2026 11:01:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G9AktCfNRhLTrE6d/o4DentROknQvwby5mBUwnUnrQco2iWG/ztoiV4BrpxlHv+pirmwknARwU21hyFWYTfjk2ObqVerlYXO9wKau6Kh6p3oRZ/xsgYZJp5hK1wfr8D1pWAMHJlUFAvoEerwZ9Oo3DazO4pdLN3iRoYbT/sqOwY33LVMzfwgQOVHcbJOcrUNXe/MDu0mWl4l2db7z9i/5xtR2POAV4PMSJiF7KbIDbbtQSfDsNYGZTMo2lsG8F1fYQdHzqC1glTlm7IwAEPym3Ab02JMgmts2pEN6EJQUdJYHJ+xZeYECJD+lsXRHJ+tu0yj/JBjbaewNSeMmk7Vpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dqnKSjrHWV7nPc2TUyiCkQw4493Mv3qVt4QnAVTeObw=;
 b=WfqjjQAI0477Mo6aT3vIF/W/FXrJmREhQccNBxVXQgMz2cyUYtVz+zucSCk27j/1pI6hBg6aehDZz+GmOGKvWaHRTy1zd7Z2lLzSrme8wHIQFlbOnmS+HZNGnpFuRpErMd8FKsUPyMSSj7u7c6nkYYlHntze+n6lpjvepvn6o9wYeaoIdwG4Zl7WOQgNdiHpvJDW6v/v17IGq16xc/Oq3GEVmzy+5AnaafElEDM3QaTwYrm5IQWLRnBv5c7LGB2eGuU3exPiKfz2zO3hVE0Jgo7SXaHrYEfRX/JR8qVucoBhypnJWkcDmMY0KoLuWsXYjBBjflIXH/DlkRbfU6AKfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH0PR11MB9703.namprd11.prod.outlook.com (2603:10b6:510:399::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Thu, 11 Jun
 2026 18:01:02 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0113.013; Thu, 11 Jun 2026
 18:01:02 +0000
Date: Thu, 11 Jun 2026 11:01:01 -0700
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
Message-ID: <air33e4js_onwUik@agluck-desk3>
References: <03d45c09-b392-420a-9b38-1c1f213a7dcc@intel.com>
 <aiiq55x6fs2ddS91@agluck-desk3>
 <387cc53d-7e55-4c1a-bf0d-635f4f7590f6@intel.com>
 <aimHif2ZC3PIjHw1@agluck-desk3>
 <19f35a7b-711b-43e0-b938-3792ae723a59@intel.com>
 <aimR-7ld7-EE_YCb@agluck-desk3>
 <8ec6b46e-dd18-491e-97f9-04cbba827370@intel.com>
 <SJ1PR11MB60838C247727AE7CC324BB25FC1A2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <a1dd1858-a6d1-4760-9181-ca30de3a1510@intel.com>
 <aingld8Hoz-x5MTj@agluck-desk3>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aingld8Hoz-x5MTj@agluck-desk3>
X-ClientProxiedBy: SJ0PR03CA0247.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::12) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH0PR11MB9703:EE_
X-MS-Office365-Filtering-Correlation-Id: f42f737b-cfbb-4444-360c-08dec7e3665f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: EwoJleeJ41KEj2r/0WPvrNpDag7t7esIhd6PnR0RcUts8i3BYO5umrOHDQQzNQ1wkJ5j877WfFRbfsuFbQ1DSFaWcf+eodHcNHgqsgmgOjW+LL4emlMhUypgDETq6Ir/fNpgo7aMKVCUISRbL3so1Lswe0XZJp8aKrflXkUwSlBdNef6C5S4rGnaWu0PT2UqUQhrPR7kMEFfRqB+pzmBJMMI0HEtJPpmtNpZV+tqWH317Kt2Hkl+bkHZP6PrAvks89uEiCRVGi48H78hkl/TJuO1vgB+03NE9iOyU+xP+elt8WxhRNt4aQQWzmYx9bsI3nEnaIKLHH4oy3rk1WaDp2KMVXFbTKXyW+bxqCgbqVPtP2edS/mJxZxJzhAjHUh/NsT83ypK9GFopShTBnCdjKGw2Kse9NFHwnUyVB9kmYtOuS0Ct7z4AudkZp/RS7oqD6uAigal3muIrULxG010bzOdai9mMYym94A1qkEKZLnUy7ePCzDd/Tupn6HWxDTpb+mdLvuCnL+ECHfYuAR9Y+iLMEN66uvt0Kz7RJushv24fUFuLEjY+L0BEgeg5xdsNmB0rtFSB5om6mj0iJcuLsfc+fzHCW2b+dB4/XfXZFZH2rpQASrFURtsdVE+vJJFRreHFmts02YXv82oA/DgeValUwq6/c3f13X2FQVkM7AjNNW+2bKWLxQqvgRljifX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R3sZCZZVV1CEcFKahD72bAcGYKRVVddRaRYRR69Q/QRahLDJfZfhKaTzFnQK?=
 =?us-ascii?Q?73KykyErMtUj/CXrBIY4WSrNTXZbj1VY+ALW5z8TufSXVax5Hx9XwTWimdKW?=
 =?us-ascii?Q?4ebtFwDh98aavXDj75f7RlpHu6s4iBLG/Qq4X2rbkGvJh5SufNgtGw8+4vbH?=
 =?us-ascii?Q?Redprn6CI9ty2UhYNpxKAj7JLIWcKR98OuE+FO/l1kiCGYx44TwldITcUCQL?=
 =?us-ascii?Q?j4PxChVj3sS+0JK6OC1qUruJOe/oDnOMJ9GmYHvRogzSVJVS7SIkqT3TqjwE?=
 =?us-ascii?Q?NaD4uszy1P0Yz5MnSP8sDVwOVSVkBYhORmTQdritpHxxzkIRJG+E+j8/GdGN?=
 =?us-ascii?Q?hgSaQZ+qwVaINNLqkivkH0DbceJJTAWlAT8B+MDnpB9Izfmk+4MGAjFhRl3X?=
 =?us-ascii?Q?VFwCEfTpZ1spPXM4LZ7axGaYX66DSq41OwQMQFz5ntEU5vWp2OekJKu7UdPP?=
 =?us-ascii?Q?y0QDk78V+KTAGuGJOucPktkkb/RIOPBOXemqfcxZt2Lls3rC0arqChp12fyq?=
 =?us-ascii?Q?vdFlQtC3nxagsp8LbO3ek6nooURLVSz1IovXX0hpCWSE3ZMDzLZjjUQ2/M75?=
 =?us-ascii?Q?LF2k0KULxJaannORS2blimCkWETXPBhzGtt56Ed593e351IWm5RLpRoXIYif?=
 =?us-ascii?Q?G70DHK6xPHHdDZn3hX3cdSs/d1nMsakirjjCDJu2yHFqYjGxHt1R5AFhHYz4?=
 =?us-ascii?Q?YBo7gXO8aoKiVuFjYSywNcz7o0Ufc/Nhwff+biZNX37N72dF6bUg2f5oEyjK?=
 =?us-ascii?Q?uT2C0+1uxrNdxfoxDxY/0IdOclpIVHprEuiStMAsnSzaJ6DFCi35dhH5XvgY?=
 =?us-ascii?Q?LAAlRM8GHz0/pAErxRzUDD7u1RTud0YERSMuPHH1/IvcJVviwptLm3N8v1Dj?=
 =?us-ascii?Q?vy+up7jpfLUfU9eCzhmJwy3n+0YfwpEosD3QsdvaTCAtvEthj6/DA6V75VdN?=
 =?us-ascii?Q?aoYRcJwp8DeAATdQWSQmuws07pkQboPKr9bkwQG9yKH+9E9eCxzTJD0/E1fr?=
 =?us-ascii?Q?+BIlpMO5/UOZDnF/xj4HSB+yrYPo4cxiQI5MJ258vmMhQOPyj8sUoNviBqQm?=
 =?us-ascii?Q?3R8zPUZLvs1maOzTU0pRhQ9pBvEBbPsu+thRbxxYoKdy+iFz0RNMn9WgPRI6?=
 =?us-ascii?Q?vyIs2rAbVRuuqcl9iKFO9lAgaqkLs4lPlTlmDn9hjMTiFEgWLe7AP08gnoi5?=
 =?us-ascii?Q?EbOUqjzVN9gbsGd8L3qseL+AmRFPvt0uomfGakAU138Cx8IrUdyK8MrhkQ8s?=
 =?us-ascii?Q?mva7zOZ9SBfuIcimMtkYxHS2aEHN3jUtayz+QCyk6kYEWOb7Jxi4LcwrMNVR?=
 =?us-ascii?Q?Erfh2CYiTBy5EuP677CzSVWi7R4+YJG7RKmLXIW8OU/HycaDF3+H0YUNrl/w?=
 =?us-ascii?Q?C25zD0NEMnjGMqWN71S736UjpCqRJqkFPWQKy8nj/A2M6iAhHiI2MeOyU2Dm?=
 =?us-ascii?Q?LQTOrL7i+AinTWnf65/jHzEGjoQeipJTc1jYNAS6oPBETSiH9qZjD0yk3yW+?=
 =?us-ascii?Q?P9fJznFRbAtELjTZnm1Efh7EGk0bL2lfvg46DSo/4yOsT4tD7hBQXkYugaT7?=
 =?us-ascii?Q?g6dJHVSlf7q61xmHu9acPUn72FtWrTsvSB85OH8eKjoolAJonFW2Bgy7uARc?=
 =?us-ascii?Q?nt6kopTTG997jvCAexcL9/VL2NM+Hj6qot4+6UtBZue0Tad1qlBE3kacBaGp?=
 =?us-ascii?Q?HrvWN17zIoNXjxkUyUtOytuJlcc+O7qIRoyxiSZ0HbD0HnY26HqPN91P2xNr?=
 =?us-ascii?Q?4i0Vj4+Zsw=3D=3D?=
X-Exchange-RoutingPolicyChecked: X2e49IJvpBZ7LRysXqlkKspdWsBLKlq3MUhEvjSAMAg5BeuULKvMlB1/TyTtnRtHJwimldoMZukUOPh2ptfWrPanGQe5K9acCPNXuJKC7+Oc3I27buOogrif4N5yf795DDS9kDiJ9F/c5X5sKdKNNMo8c0AG79LzgGqGqgIzS2EzUVs5oZcBTMx0ih8okLqv2f0sU265sjSWWTiYxqXwiGeq650DnNq1J/PIdXk8SvWq/zLvTVsExJ75GqMrB9I7GMSERq2gc+4uudM0hf7afKZfgUNCbdtPLw0TX+aFhSCyCipr/ZZuMZ5TCYLkUfyVXcU7ha5szTDfDnuoibJnPQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: f42f737b-cfbb-4444-360c-08dec7e3665f
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 18:01:02.4933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uGsZLu4Gv+RcrRfseqynAuSv3m596TNXl2955GGQ8SsYBzpbr8Wa+Bhv7VYtZqENuAEiDCVol/v9ktgmBXm0/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB9703
X-OriginatorOrg: intel.com

With renamed variable, and comment. Is this clearer?


/*
 * intel_aet_register_enumeration() provides the value of "THIS_MODULE"
 * from the the pmt_telemetry module. Note that this is NULL when
 * CONFIG_INTEL_PMT_TELEMETRY=y so it serves as a flag to decide whether
 * try_module_get() and module_put() need to be called.
 */
static struct module *pmt_is_a_module;

...


/*
 * Track whether pmt_telemetry enumeration succeeded during mount for use
 * during unmount.
 */
static bool pmt_in_use;

bool intel_aet_pre_mount(void)
{
	bool ret;

	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
		return false;

	guard(mutex)(&aet_register_lock);
	if (!get_feature || !put_feature)
		return false;

	if (pmt_is_a_module) {
		if (!try_module_get(pmt_is_a_module))
			return false;
	}

	ret = aet_get_events();

	if (!ret) {
		if (pmt_is_a_module)
			module_put(pmt_is_a_module);
	} else {
		pmt_in_use = true;
	}

	return ret;
}

void intel_aet_unmount(void)
{
	struct event_group **peg;

	guard(mutex)(&aet_register_lock);
	if (!pmt_in_use)
		return;

	for_each_event_group(peg) {
		if ((*peg)->pfg) {
			struct event_group *e = *peg;

			for (int j = 0; j < e->num_events; j++)
				resctrl_disable_mon_event(e->evts[j].id);
			put_feature((*peg)->pfg);
			(*peg)->pfg = NULL;
		}
	}
	if (pmt_is_a_module)
		module_put(pmt_is_a_module);
	pmt_in_use = false;
}


-Tony

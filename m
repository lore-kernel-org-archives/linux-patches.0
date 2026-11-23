Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.9
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795406410;
	b=JNtgHMR6JJ1RdmRwWgggGf4Y8zA5EajacFpWgBm0dfpTbtPB1P0RAO/kRUxGqhHoGx8O
	 JP7e0qNu3AaZgMdTpuQPqzXzjo4oi2mJNzwcZBuZZpKuxhSV0ioWdNaL1YILcnFOWztQQ
	 lLmKqBNNT9gpwXr0+W4+QH+7ayA1uHYUFq6HML2ZeXDo5i41rJ8qt968RAfP2U1QwAxrn
	 n0SBhghjzBnMGO80HPHDelGwiirjO0b9HfVSqEF9XszFa6iilQpksaYFQ3d7aj14/6ngp
	 d3wHpydq57qk/APy12/oO2V5SMFm2Wh8k1Lh8MCTMK1ss8zhMxHcqxKd9CPrM0cJ5+A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795406410;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Date:From:To:CC:Subject:
	 Message-ID:References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=Avw8zqjFIIdPu25KeO6U/ae/z6H5PXtKCaAkwRn4Jys=;
	b=gucS5DkNwRNGEM1QudGwpklfIdZrcpxEJIpl0duysHvHZnSAcqOdPH0nFbkkSxSD64yT
	 loA4Lz04pIPFob++THBgR7cIYo/o0KsfXxg7aTCefGIddTzWPEcOnwCnf5YGRnIfUKog+
	 vkdI5zVVW9OsV7MJeGMmCxA+g4t91Q84MqXWU0HlfFRSWniM7nOK+D+Zw/vA4iVNaG1//
	 6s9sEOVuKynPSsONIds/UrsS/N7QR6d6vHzivBjQuRjh7nqqziwK7Jb8dldMY3I7lRRSC
	 qjK8tcgzlOCcUbAMyrJw/ai1wmBWFxkv0VAdH/HoZjv0fO35Xz05okUE8pnutngJGjg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Qz9VTzhc;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=NMJVvxAE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A89606A320
	for <patches@lists.linux.dev>; Mon, 23 Nov 2026 04:00:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36A89606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Qz9VTzhc;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=NMJVvxAE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795406409; x=1826942409;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=FhO2MJ71j9SsBWoi6AV7L4BXzxzjsC+sDelwQXHzjBQ=;
  b=Qz9VTzhcsThtmqk8EshPuoBJCHaluj5ZUrfIjrraf3jPMrfjr+PpuRnp
   oN94qkQyVVhfWiKPTmPM+B3VzYzMdtxkVf5Ukr7j2mTcgIjR5x/GOdTh4
   EJGgBF5jMaeizinFT46yzhazBGau3KL0rf+3p064x5llwpdAQ154XQnB7
   UrGBNUWwD4+g3Um9VpoDQPXemvSUM6phVtswawA05qlwy2eVFyJh1gMpU
   yNqmBluEYSCVc7hpDENcPqM4LIxtPBdt/mNNBSgyF5sKpAqQZO1x372IN
   m1SeEeDmTudX+CFYnhUhXpnLwmrHAYjeGopunNirMkI1sUcGIZ+4emGIl
   w==;
X-CSE-ConnectionGUID: 3yVQQl/BRvafS4A9jDEEeA==
X-CSE-MsgGUID: qlEp2Da8SdKr5AhuxeEUVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11974"; a="4050725"
X-IronPort-AV: E=Sophos;i="6.27,227,1787036400"; 
   d="scan'208";a="4050725"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2026 20:00:07 -0800
X-CSE-ConnectionGUID: LaE9MCySSX2IF9Ar0+m1YA==
X-CSE-MsgGUID: usSp2XPfRCOF59ZCHnKZZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,227,1787036400"; 
   d="scan'208";a="13181446"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa013.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2026 20:00:08 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Sun, 22 Nov 2026 20:00:06 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Sun, 22 Nov 2026 20:00:06 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.68) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Sun, 22 Nov 2026 20:00:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GcVX84U65ldWhkGHYFghVZkUwQPm54l86eledyXeYoqbsBqAXJzuzn7iEzXHTSS//OsAHHfzKnV8NCNa5NCSZGo4hNsTeWxyxtJ2+Co32y4wh+NKAV5f9ersab5uTGyVYXdUisAwEuIaVbo3G5jHWbYH+/UC5qm6qg6APAce4Ke1thFaChly0V7Dq1fPW5WpVcW6DzmfLvgQlvZK/KM6wZeapJoYSrs360pQuzYvOnkusqXhtgqJprUllU5yrh7G1ro+2Cw8RVIiCgJ4zC7YzjryAALrSrzXO/6Un9ZCgPcdgEO7ZhuXryMwkC7dUBBjA0Gz20niYlCzxnN440mE3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Avw8zqjFIIdPu25KeO6U/ae/z6H5PXtKCaAkwRn4Jys=;
 b=YYvRK4Pc70tvNYOaWzc2hSvKwQyFyLN4CgHChnjPoUOCsZoTKFMvww2fOy1rCBMcjZhhcrheeG0JdnG+/a2v2kT/sjK2k3b2w0w3Rbsn9/hIHMjruaMl7B6HYE+995yAVJ4T1YeIU7WyWpUGCbjhVuoZxtSvNvFmjKqhQF0Z/b9ARa5tj9O9nBqAUYt3NoKFRATADk+MAec85M9g0kF0gtwK3KvyQT5LQEpEvjBPPQOoI45j1Fsl53X7SD38/x0KCWR2c4x1qtCG/ZyU7HlxcSSV0Qd/3rGPrU/oZHtqKVrGspXKowTmGSfdakUmqwvR1d/RbGwixK48C+xnnph0kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Avw8zqjFIIdPu25KeO6U/ae/z6H5PXtKCaAkwRn4Jys=;
 b=NMJVvxAENdwSoccps9Gf0Bl+fcTZYGVr6CAU+tsuc+hhGi0bnfMtLfdNs417S+JUPKM0LMw+UiEv/bxurSxc5eMgxwJzD0ZjCMfPIu5K0cKl4dbARX8xLFtwslX23riDCtNt5o+SE4gjX97EadSW27s5IbJd5hGGO+bYceGpY5k=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 PH0PR11MB4901.namprd11.prod.outlook.com (2603:10b6:510:3a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.14; Mon, 23 Nov 2026 03:59:55 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%3]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 03:59:55 +0000
Date: Mon, 23 Nov 2026 11:48:45 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <kees@kernel.org>, <mingo@redhat.com>, <peterz@infradead.org>,
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <kprateek.nayak@amd.com>,
	<david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <tony.luck@intel.com>, <ben.horgan@arm.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <babu.moger@amd.com>,
	<fustini@kernel.org>, <jedrzej.wasiukiewicz@intel.com>,
	<fenghuay@nvidia.com>, <peternewman@google.com>, <x86@kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [RFC PATCH 1/3] fork,arm,x86,fs/resctrl: Fix stale resource
 group assignment vs copy_process()
Message-ID: <awO3nYazk97csbpO@chenyu-dev>
References: <cover.1795197419.git.reinette.chatre@intel.com>
 <b2e13da64ca3e41207b5d46fb060bccefaf9fecd.1795197419.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2e13da64ca3e41207b5d46fb060bccefaf9fecd.1795197419.git.reinette.chatre@intel.com>
X-ClientProxiedBy: SI2P153CA0015.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::21) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|PH0PR11MB4901:EE_
X-MS-Office365-Filtering-Correlation-Id: ba257448-ee21-4422-1887-08df49163b7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|18002099003|22082099003|261009223027099003|3023799007|260925021311599003|260925021911599003|4143699003|10067099003|5023799004|11063799006|56012099006|261102123227099003|261028144727099003|261026140227099003|261026121527099003|261021121427099003|261022075727099003|261022105027099003|260925022911599003;
X-Microsoft-Antispam-Message-Info: wYrLxelc0R66KPCwxljSMzbZqsiAYjYaS7WaubDN4XExmHrVftypYXjSRQFU2XyJyT6FF4jKIYlOe6gWk1+8fHMp4jIxm2wZki0EpqWpMlOz+Y1yicczigISSDQbGrrXsxi5OwhxhkZCP4vzfNKLgd1QYAlJknqU7H4jYxat5+1CDbRTDox4HZ4LXQ+hRFWmql7FyXV5iRseH2XWe/EE0kht7EdGxATDy65K9GQjahCTqTSpeYAXZ2WN1pe9lJqlat5blfzewE0E6+k0URYHWCWlhNBejJMGUTO7LFGo5axNq8QwybvuGozEGsnXuEcIeYf50jpXzRsx1yDcSj0xweZvlwabS7GDuhXW3tRWoEv7SQUhBf5BDaNG7sMYKxGKjz18T7dm1SOxxxA6l/KmIlJTEvFLHKebwQb4TeAkREEje32MtcF89GnhuCHkQEvmAIcBO3WW1vt9z9P6TOR8Rr2iOL0aCipQkt1u5ftQRfsFjj4IVHRbU5pWQXFS6B8c9bLQLHftf11tf5lKpU3UKwHdXxgx5yX3e/yaivIQaigmuQwJuLlZLUTEXb5GnAlc/BLsElungqhywx5YoYOpCL3gzemLmPhoe6EQE1A27IoRI/nyyEXC170tJfr1HjbwxatZBTtFeU8JIkea94RC0yMxyJKxVGFJrLwzLTeX7N4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(18002099003)(22082099003)(261009223027099003)(3023799007)(260925021311599003)(260925021911599003)(4143699003)(10067099003)(5023799004)(11063799006)(56012099006)(261102123227099003)(261028144727099003)(261026140227099003)(261026121527099003)(261021121427099003)(261022075727099003)(261022105027099003)(260925022911599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CdO+/ajaLnRvozCMbjedGjTVCCuo/5nRGkOaDt1uzV9jA6NHqDq/abU3kJfL?=
 =?us-ascii?Q?kvY125ltifdfGQxkeQdIkaAk5TvciYCIE23NHDaR8zCFvMLlNL8AUq3Ka9PN?=
 =?us-ascii?Q?jOqHSzKLh/N2DOpLSv5wX+MfE41m3G6XHwvmC7s5Bgd4Dq79izvekrn5CezP?=
 =?us-ascii?Q?CzM7fzRUo77pD72oLSOT+ipQsJhRc+U+l5YNGaUSjGQDETP0brUUMAFF6RZb?=
 =?us-ascii?Q?FLK2dDkMAcwc1mG+i81cIVO860CHSa0o7I3+H3G+gYj3s8iXtg4PPUhZ4zd3?=
 =?us-ascii?Q?js40OSKtkYx202+ucF8I5rd36ICQj1hS7j1wL26qeag3EiZmRpfh4rcvoHra?=
 =?us-ascii?Q?HVsoBsg5R4cQ9V37IypmxB1plr66Nc7LEyoebvqvfFlqK4X1yNTif1eqS5DG?=
 =?us-ascii?Q?TZ3RwX713cnGltCi/lrDcwQfR+Bj+Jppqubqz+nfZ7tMy8Mn/pBrfY6+6PsT?=
 =?us-ascii?Q?3f+z7wlfpMcwhkUIF07iG/whLjod/AX2SZ3xWg3FeTOUwwfy3UGi5kVYX2OL?=
 =?us-ascii?Q?ttVERBeLz5hhT9Iqp8xxADb6gltrg+X6SodFaqRQuGHXYe+K0D+IfsxiYDn5?=
 =?us-ascii?Q?b5GzmhQN/5hGpHvtMxnsGFkaCjvHL1fpe+n2bdTM72MyhY7XLpX12bv13p0p?=
 =?us-ascii?Q?suu3a3m65zVDWmJaa6SxoEQMtL5SXIBAohSkuZwvqrIuTmqoKsYN7lJLrHlO?=
 =?us-ascii?Q?wi7n/23Mm0VrJuFsbNtH7cjxx+KlL2wBcazWjGg/zPrbOzG/9qx6hGKgfyic?=
 =?us-ascii?Q?bwKSRaW5/hbbJsZdbcHGkCnhSkMQYBLTWubRLqEd0RkwjYqK0Xh6aJ5j8SKI?=
 =?us-ascii?Q?HMciYOb5O1uZifYmMIgfvbNQ4UubNhEeD3a4iC7aFo6CSLcdDH3LIcH2NHEq?=
 =?us-ascii?Q?WpRJi6lqrAF4pkXcYlrsEUqPCZnAWzxS2/CH7veJZ0DtbDsYQTboqmHkSiba?=
 =?us-ascii?Q?6CV51EdF3o0Omn3zeIVpA1jRuzWDT4Gl03xHf3Ss3otBJans7+mVKWRRbrev?=
 =?us-ascii?Q?N2erV/zlR9JzmCVaseWIlXTdUIcddPhw1vQVyf+iLE2XVRPX840r6SXQD49k?=
 =?us-ascii?Q?bx+c6a8VRPWHKizE+RbsyeEkUNfm2Z9ggiYQ0L1SRO7N1ImScgp7OhDurGhd?=
 =?us-ascii?Q?ylDiobgNgcpcGhZm0Q3DucjT2EyfsKZHDDNEztNefp9ZpI3pz4XFD7A89coS?=
 =?us-ascii?Q?qcz3pVaC/koXrvgWMsALfkiGgvb/jVnusevl8MN9gVPpCqa6C9loyHqjarj0?=
 =?us-ascii?Q?+HZ6Y/c+lfeWY3CNnyX3TO0ajrNgY8ar7iKXE+/cfGpJVi+Aj/Vs1wfDeu1u?=
 =?us-ascii?Q?Wy1ooF8LfFJXMENjgMt/4z05FuXrAscm2xwwmdZdOHZMKjJBPsUgQL7H7tLL?=
 =?us-ascii?Q?kSXy5B0ZhHnAsizEi+2XAozmkFKN12db7e5PpfI0PIaYSrltLj6rbD0S6a34?=
 =?us-ascii?Q?bO2OQy36Z3/clQWBVDGFaNlDgzlgu6JZ94x5EThGP/gatRh7B4mDtxIb0Nc3?=
 =?us-ascii?Q?1WZSJyW2NpIg1Qs7u4uzCRyaTra6BHbhYvTEbVtZ8kPD16Z/Vc4kqE9DxgSp?=
 =?us-ascii?Q?iVeJywrzdmUxpx3YfP8mD7kKFwiqZUXNymvt9Ixjp5cJosUdReCoOH6Rn8bG?=
 =?us-ascii?Q?sBwKYzv4zpVIubOW/2ISRTw/i3WE1GDmR3/LV2lu+t1jebjsn5eZVR+Ei/vr?=
 =?us-ascii?Q?wA4BgoNObhRMGZnIx2Q1ALy5iHNWJc1EtnxjXpf6HKoAdb+blZ7TweFKijIY?=
 =?us-ascii?Q?4d00sjYTxg=3D=3D?=
X-Exchange-RoutingPolicyChecked: dI0kc2Mp4rLl+OqKQddvQqkqMcf6HDnvg/f+N8BffhtMMXfJ9qi+NdRg3mgFK81Ev+Mhnx52HW0fdmUqb2d4/JmUutxW0q5XjHiOvjfWkg6JVrtUlLMWcte6qeIKJ5hPL6mioVE85LBeeWJgFYIGib1SQAjj2IrSZvHSFsf7rPIAmnM7dwzmljZWiGMM/Z9bS652TlBTQkAzZ7AqdvxJLIlbDplWX4/lVgf7UO0eiLrt54YfapvvbLJ9CzyYeAgY33Acc4kNDrobZlbd4TPrLLI8GpRtFXc0ka268DB0LlB7/jkMBJSSOyvCgdZsJEaTNuaOnAKdRimPDH9BqpMK+Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: ba257448-ee21-4422-1887-08df49163b7b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 03:59:54.9716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PG+zc8iN/n+MHn1jd5TD+ofgKzi0X1G9yJJvPSy3qrfrLf79sPbWCH3ypD0QPtG8Ao0+uuueGBCHKRMKXpyrgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4901
X-OriginatorOrg: intel.com

Hi Reinette,

On Fri, Nov 20, 2026 at 10:39:30AM -0800, Reinette Chatre wrote:
> During fork a task's CLOSID and RMID are copied into the new task by
> dup_task_struct(), early in copy_process() without holding tasklist_lock
> or any lock that resctrl takes. The new task becomes visible to a walk of
> the task list later in copy_process(), after it is linked onto the task
> list while the tasklist_lock is held for write.
> 
> Removing a resource group moves all of its tasks to another group by
> walking the task list while holding the tasklist_lock for read, and then
> frees the CLOSID and RMID of the removed group. A task that copies its
> parent's CLOSID and RMID before the walk reaches the parent is missed by
> the walk: it is not on the task list yet, and it cannot get there while
> the walk holds the tasklist_lock. By the time it is added to the task list
> the CLOSID and RMID it was initialized with have been freed.
> 
>     CPU0                                CPU1
>     ====                                ====
> 
>   fork()
>     copy_process()
>       dup_task_struct()
>         /*
>          * New task inherits the
>          * parent's CLOSID and RMID.
>          */
>                                     rdtgroup_rmdir_{ctrl,mon}()
>                                       rdt_move_group_tasks()
>                                         read_lock(&tasklist_lock)
>                                         for_each_process_thread()
>                                           /*
>                                            * Parent is moved out of
>                                            * the group. New task is
>                                            * not on the task list
>                                            * and is not moved.
>                                            */
>       write_lock_irq(&tasklist_lock)
>         /* Waits for the walk. */
>                                         read_unlock(&tasklist_lock)
>       /* Lock acquired. */
>       list_add_tail_rcu(&p->tasks, ...)
>       write_unlock_irq(&tasklist_lock)
>                                       free_rmid()
>                                       closid_free() /* ctrl only */
> 
>     New task and every task it creates use the freed CLOSID and RMID.
>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> The new task and every task it goes on to create keep using a CLOSID
> and RMID that resctrl believes are unused. Once those identifiers are
> handed to a resource group created later, the strays appear in that
> group's tasks file, their memory accesses are counted in its monitoring
> data, and they are subject to its allocation policy, while the group
> intended for them does not control or monitor them.
> 
> Introduce resctrl_copy_process() to copy the parent's CLOSID and RMID
> into the new task from copy_process(), while the tasklist_lock is held
> for write. The walk holds the same lock for read for its full duration,
> so the new task is either already on the task list and assigned by the
> walk, or the copy happens after the walk completed and observes the
> parent's new resource group.
> 
> resctrl_copy_process() reads two values that some architectures store
> separately. __rdtgroup_move_task() assigns them with two stores while
> holding only rdtgroup_mutex, which resctrl_copy_process() cannot take,
> so those reads can fall between the two stores and leave the new task
> with the CLOSID of one resource group and the RMID of another. Assign
> them from __rdtgroup_move_task() while holding tasklist_lock for read
> as well, so that resctrl_copy_process() observes both as intended.
> 
> Add an architecture call to perform the copy because CLOSID and RMID are
> stored per architecture and cannot be read and written as independent
> values on all of them.
> 
> Fixes: f3cbeacaa06e ("x86/intel_rdt/cqm: Add rmdir support")
> Reported-by: Jedrzej Wasiukiewicz <jedrzej.wasiukiewicz@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Note to MPAM maintainers:
> 
> resctrl_copy_process() runs on every fork(), so
> resctrl_arch_copy_closid_rmid() is a static inline on x86. Doing so is
> perhaps not required as fork() is already expensive.
> 
> Even so, I attempted doing same for MPAM but ended up with solutions
> that do not seem ideal:
> 
> - A static inline in arch/arm64/include/asm/mpam.h, next to the other
>   accessors of thread_info::mpam_partid_pmg. Nothing on the path from
>   include/linux/resctrl.h reaches that header, so the definition is not
>   visible to resctrl_copy_process(). Making it visible means
>   arch/arm64/include/asm/resctrl.h has to include asm/mpam.h, which
>   does not seem to match MPAM's intended design?
> 
> - A static inline in include/linux/arm_mpam.h, beside the
>   resctrl_arch_*() inlines already there. asm/mpam.h includes
>   linux/arm_mpam.h, so the reverse include would be circular and
>   mpam_get_regval() cannot be called. The copy would have to read and
>   write thread_info::mpam_partid_pmg directly, which no code outside
>   asm/mpam.h does today, and would need a CONFIG_ARM64_MPAM guard
>   because the field is only present when it is set.
> 
> The out-of-line definition this ended up with matches
> resctrl_arch_sched_in(). Please let me know (if this is a change you
> agree with) what kind of shape it needs to take for MPAM. We could also
> just make x86 and MPAM both be out-of-line - doing so may not be felt by
> the heavy copy_process().
> ---
>  arch/arm64/include/asm/mpam.h  |  6 ++++++
>  arch/x86/include/asm/resctrl.h |  7 +++++++
>  drivers/resctrl/mpam_resctrl.c |  6 ++++++
>  fs/resctrl/rdtgroup.c          | 21 +++++++++++++++++++++
>  include/linux/arm_mpam.h       |  1 +
>  include/linux/resctrl.h        | 28 ++++++++++++++++++++++++++++
>  kernel/fork.c                  |  3 +++
>  7 files changed, 72 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/mpam.h b/arch/arm64/include/asm/mpam.h
> index 70d396e7b6da..0746e5d7cc2d 100644
> --- a/arch/arm64/include/asm/mpam.h
> +++ b/arch/arm64/include/asm/mpam.h
> @@ -63,6 +63,12 @@ static inline void mpam_set_task_partid_pmg(struct task_struct *tsk,
>  	WRITE_ONCE(task_thread_info(tsk)->mpam_partid_pmg, regval);
>  }
>  
> +static inline void mpam_copy_task_partid_pmg(struct task_struct *dst,
> +					     struct task_struct *src)
> +{
> +	WRITE_ONCE(task_thread_info(dst)->mpam_partid_pmg, mpam_get_regval(src));
> +}
> +
>  static inline void mpam_thread_switch(struct task_struct *tsk)
>  {
>  	u64 oldregval;
> diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
> index 8f6edcdcfd87..199ca9af0089 100644
> --- a/arch/x86/include/asm/resctrl.h
> +++ b/arch/x86/include/asm/resctrl.h
> @@ -153,6 +153,13 @@ static inline void resctrl_arch_set_closid_rmid(struct task_struct *tsk,
>  	WRITE_ONCE(tsk->rmid, rmid);
>  }
>  
> +static inline void resctrl_arch_copy_closid_rmid(struct task_struct *dst,
> +						 struct task_struct *src)
> +{
> +	WRITE_ONCE(dst->closid, READ_ONCE(src->closid));
> +	WRITE_ONCE(dst->rmid, READ_ONCE(src->rmid));
> +}
> +
>  static inline bool resctrl_arch_match_closid(struct task_struct *tsk, u32 closid)
>  {
>  	return READ_ONCE(tsk->closid) == closid;
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 5468367776e2..7aea58fca85b 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -345,6 +345,12 @@ void resctrl_arch_set_closid_rmid(struct task_struct *tsk, u32 closid, u32 rmid)
>  	}
>  }
>  
> +void resctrl_arch_copy_closid_rmid(struct task_struct *dst,
> +				   struct task_struct *src)
> +{
> +	mpam_copy_task_partid_pmg(dst, src);
> +}
> +
>  bool resctrl_arch_match_closid(struct task_struct *tsk, u32 closid)
>  {
>  	u64 regval = mpam_get_regval(tsk);
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 57ab090072c2..ebf780fc5fe9 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -657,12 +657,28 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
>  		return -EINVAL;
>  	}
>  
> +	/*
> +	 * Hold tasklist_lock for read so that resctrl_copy_process(), which
> +	 * holds it for write, cannot read the CLOSID and the RMID of @tsk
> +	 * while only one of the two has been updated.
> +	 *
> +	 * Hold tasklist_lock just for the @tsk update. A CPU running @tsk
> +	 * keeps using the CLOSID and RMID that resctrl_arch_sched_in()
> +	 * applied when @tsk was last scheduled in, so
> +	 * update_task_closid_rmid() below has to interrupt that CPU for the
> +	 * new resource group to take effect. Leave that until after
> +	 * tasklist_lock has been dropped: a CPU waiting for tasklist_lock
> +	 * for write waits with interrupts disabled, and @tsk's CPU is the
> +	 * one that may be waiting, because @tsk may be forking.
> +	 */
> +	read_lock(&tasklist_lock);
>  	if (rdtgrp->type == RDTMON_GROUP)
>  		resctrl_arch_set_closid_rmid(tsk, rdtgrp->mon.parent->closid,
>  					     rdtgrp->mon.rmid);
>  	else
>  		resctrl_arch_set_closid_rmid(tsk, rdtgrp->closid,
>  					     rdtgrp->mon.rmid);
> +	read_unlock(&tasklist_lock);
> 

Is it possible to combine u32 closid and u32 rmid into u64 closid_rmid?
RDT will no longer support 32-bit kernels, so u64 is always atomic. Then
we don't need the above tasklist_lock in __rdtgroup_move_task(), and there
is no race with resctrl_arch_sched_in() - but we do need it during fork()
though.

I was thinking something like below:

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1362,8 +1362,7 @@ struct task_struct {
 #endif /* CONFIG_PREEMPT_RT */
 #endif /* CONFIG_CGROUPS */
 #ifdef CONFIG_X86_CPU_RESCTRL
-       u32                             closid;
-       u32                             rmid;
+       u64                             closid_rmid;
 #endif
 
        struct futex_sched_data         futex;

static inline u64 resctrl_clos_rmid_val(u32 closid, u32 rmid)
{
	return (u64)closid << 32 | rmid;
}

And we use resctrl_clos_rmid_val(), upper_32_bits(task->closid_rmid)
lower_32_bits(task->clisid_rmid) in the code.

thanks,
Chenyu
>  	/*
>  	 * Ensure the task's closid and rmid are written before determining if
> @@ -2959,6 +2975,11 @@ static void schemata_list_destroy(void)
>   * If @mask is not NULL the cpus on which moved tasks are running are set
>   * in that mask so the update smp function call is restricted to affected
>   * cpus.
> + *
> + * Tasks created while this walks the task list are handled by
> + * resctrl_copy_process(), which tasklist_lock serializes against this walk.
> + * A new task is either visible to the walk and moved with the others, or
> + * resctrl_copy_process() assigns it after the walk completes.
>   */
>  static void rdt_move_group_tasks(struct rdtgroup *from, struct rdtgroup *to,
>  				 struct cpumask *mask)
> diff --git a/include/linux/arm_mpam.h b/include/linux/arm_mpam.h
> index 002f56e15362..b605e9771c32 100644
> --- a/include/linux/arm_mpam.h
> +++ b/include/linux/arm_mpam.h
> @@ -56,6 +56,7 @@ bool resctrl_arch_mon_capable(void);
>  void resctrl_arch_set_cpu_default_closid(int cpu, u32 closid);
>  void resctrl_arch_set_closid_rmid(struct task_struct *tsk, u32 closid, u32 rmid);
>  void resctrl_arch_set_cpu_default_closid_rmid(int cpu, u32 closid, u32 rmid);
> +void resctrl_arch_copy_closid_rmid(struct task_struct *dst, struct task_struct *src);
>  void resctrl_arch_sched_in(struct task_struct *tsk);
>  bool resctrl_arch_match_closid(struct task_struct *tsk, u32 closid);
>  bool resctrl_arch_match_rmid(struct task_struct *tsk, u32 closid, u32 rmid);
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 10dfdca7f4bf..32d8bf9ca9ba 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -7,6 +7,8 @@
>  #include <linux/list.h>
>  #include <linux/pid.h>
>  #include <linux/resctrl_types.h>
> +#include <linux/sched.h>
> +#include <linux/sched/task.h>
>  
>  #ifdef CONFIG_ARCH_HAS_CPU_RESCTRL
>  #include <asm/resctrl.h>
> @@ -729,6 +731,32 @@ extern unsigned int resctrl_rmid_realloc_limit;
>  int resctrl_init(void);
>  void resctrl_exit(void);
>  
> +#ifdef CONFIG_RESCTRL_FS
> +/**
> + * resctrl_copy_process() - Give a new task the resource group of its parent.
> + * @child:	The new task, which is not yet on the task list.
> + *
> + * Call from copy_process() while tasklist_lock is held for write. Serialized
> + * against rdt_move_group_tasks() and __rdtgroup_move_task() that hold
> + * tasklist_lock for read.
> + *
> + * dup_task_struct() copies the parent's CLOSID and RMID into @child before
> + * @child is linked onto the task list. If the parent is moved out of a
> + * resource group that is being removed, that group's CLOSID and RMID are
> + * freed once the walk completes, leaving @child with stale assignments.
> + *
> + * Bring @child up to date with the parent.
> + */
> +static inline void resctrl_copy_process(struct task_struct *child)
> +{
> +	lockdep_assert_held_write(&tasklist_lock);
> +
> +	resctrl_arch_copy_closid_rmid(child, current);
> +}
> +#else
> +static inline void resctrl_copy_process(struct task_struct *child) { }
> +#endif
> +
>  #ifdef CONFIG_RESCTRL_FS_PSEUDO_LOCK
>  u64 resctrl_arch_get_prefetch_disable_bits(void);
>  int resctrl_arch_pseudo_lock_fn(void *_plr);
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 5efceb8d58a7..8344e0d27b78 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -105,6 +105,7 @@
>  #include <linux/stackprotector.h>
>  #include <linux/user_events.h>
>  #include <linux/iommu.h>
> +#include <linux/resctrl.h>
>  #include <linux/rseq.h>
>  #include <uapi/linux/pidfd.h>
>  #include <linux/pidfs.h>
> @@ -2491,6 +2492,8 @@ __latent_entropy struct task_struct *copy_process(
>  
>  	klp_copy_process(p);
>  
> +	resctrl_copy_process(p);
> +
>  	sched_core_fork(p);
>  
>  	spin_lock(&current->sighand->siglock);
> -- 
> 2.56.0
> 

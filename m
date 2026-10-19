Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792425253;
	b=FGZQR8CHvmqhsjo5p1b/zhyFJzEmBlYsqtDEfQ3jy58p90PY/MmSxAsRavqrzNF6asax
	 9ZbLA4283FZCI/Nt/2NQxzkFv9gTpsKJPKqlmzyC4YpHXXlBL7UDY+9Vce872JVJng107
	 lqJwjD4gA5QPG+Vdwe2hhs07N+3+B6IODqSeHZWzWoFlrHblm4JMvgpKxHvYRqE/eqYZh
	 mKwSbLvpi+L1DiPnmIBk1G/06MamzzR2ruUcWVnTcKtWFDsWGFd24GVd+mlJHukoB1Q2q
	 EefSnvGneD8J9Ve3VSVgE1oZPzsfypWm3VzdQ28TbgUn8tieBwdFJi9OnTFyFCMWvCw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792425253;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
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
	bh=XjiXm+4Xt0X3PWx+aj4ccqS4CC5oJ3F37LS/ZDbbT50=;
	b=KlVRBFQa9jruRWxwuQXjPr6a6lBf3jqyaxVlgEjtGQN+yBzEIBfxWEFKcgXm/PUMBTD5
	 Ek2fbgbET+ovy6SpoUQ8SWalxmUznt7yoMhH9broSNzu+fo6wo+f6gIU6bqvchU3rpZp/
	 w76AKdfo3omf3ocj8NUux3tpcUp0lsNiUE2qF/l690FzQC9Pi7PT1h1dZADyx2mEtNoKG
	 GfIEcW5LIFC7CD5znpfFcsNJHjmB7IjtZIOMkZnPyWTPUbt4SUTUTOh9MBu3mz9R3qdNX
	 pM76vZxZotIUDaYAkuieadhY1QCwbW5x+vDljOKA6kGi3D+5NIdkpgqDwdfh80e1RBw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jvhhxMFc;
	arc=fail smtp.remote-ip=198.175.65.11
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEA2606A32A
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 15:54:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DFEA2606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=jvhhxMFc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792425252; x=1823961252;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LMhJENrcE4QJJqLMFJWpTsPM3K17s3Bv11I+BaiZA0U=;
  b=jvhhxMFcqFLWEgM6y2N6V8/u05ghJze7HNNclR1WKC4uZeDSCJJ3ve63
   V1VA84SkUXpn0VEFLw/zz+NXg1Pnd6BiRBHnaX7Z6jM1F9n0OeqI10aOk
   LixEYuBexT2q+KZ8i99r7E59SCr+014k36C8vzNvmYqgVShAK/VKf9psk
   iq0rhQ7nlqfQDk2r9NSxYD2jcg22IYf98T0cyIsfvfqckkwogpsoXLq2M
   fePIwhW00ZxPzyqdMLIKZ8QPgAeNa1pL8k2VEwxovijdGc0zMvfC+Bf37
   JTyilE4zn4+BZlaX/bMVx4F3fKZP6//4EI2CT3ZLmJbAD1Dd5ZWwlI1Ly
   w==;
X-CSE-ConnectionGUID: p8gUZvTiTCWt+qa/3hUagw==
X-CSE-MsgGUID: yAGKprqhQWq86nZy3YRv3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="997665"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="997665"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:54:12 -0700
X-CSE-ConnectionGUID: iRIwieJ8SY63M76Vm+HUsw==
X-CSE-MsgGUID: rEO/9i2AQ4KpktSvFcxTpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="4352359"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa013.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 08:54:12 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 08:54:10 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 19 Oct 2026 08:54:10 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.41) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 08:54:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XLPhmCHXz4Y7iqptJ3NtUk5JZYzceZUaDqQjzr9qk2J2UASmA3KZ3b/ezk9dhztw2uCO9ibD71CHhs5hco0Suvykcs+6g0XRQIaF27mBrziLpFSTYAHhedeI2cnswspA26vbMRsZGWt45kaXSChthHn2rT+ZR9TKRA39ROwOfIoxvi/EHlLOPukE1DYAkCSzFA/uId3RO3zKNKbmmNvrwaP/h2d6XW0i7Bbdw8g/k/mYNfxh3LR/5hTetmNkEIroj+T02ZdkCFz1CLSivlayvAKfI5bVn0HUKc6hgdSexq7s2DuET8r3rEj0s61hBN/C05H81wMEavkPwyrijb6Zkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XjiXm+4Xt0X3PWx+aj4ccqS4CC5oJ3F37LS/ZDbbT50=;
 b=uVJaGsIttkkSS/Tb7+BXZUD60+CR8oBRdKme1DUnedc9t9cSI/XKZtSed3Stre7xuYfOPWlf5m6AdrjXmzZJxzMDB7yklmuMwASJwUIR8wMPuw47P5hXlGKbS6An08vbddkiuNK/s5Gy3Aho4X4m7juP5uq9XIvbHcArMuJok9JRiXWcTwoeWq632GU/kSoCEyCTcVt/jW5Lx5idkAAcN+qYcoOBMsTAwEaAYHZBBK1grnsvYFr5EUCGFjheYht8Tiobzocwgv5oJVzJ2PuyvRVxT36zdYAYmsO+Jfbfi/GYn18Ft9FtqhpdqRfrxUkz6YGD62AcU/xXbRWdFM5QpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 SJ2PR11MB7520.namprd11.prod.outlook.com (2603:10b6:a03:4c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Mon, 19 Oct
 2026 15:54:07 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%3]) with mapi id 15.21.0496.021; Mon, 19 Oct 2026
 15:54:06 +0000
Date: Mon, 19 Oct 2026 23:41:08 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "David E
 Box" <david.e.box@intel.com>, <x86@kernel.org>, Christoph Hellwig
	<hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v13 04/25] x86/resctrl: Centralize monitoring feature
 enumeration
Message-ID: <atY6FPFvbwlat8JG@chenyu-dev>
References: <20260928221509.68002-1-tony.luck@intel.com>
 <20260928221509.68002-5-tony.luck@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260928221509.68002-5-tony.luck@intel.com>
X-ClientProxiedBy: SI3PR01CA0010.apcprd01.prod.exchangelabs.com
 (2603:1096:4:296::16) To DM4PR11MB6020.namprd11.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|SJ2PR11MB7520:EE_
X-MS-Office365-Filtering-Correlation-Id: c666b953-a6ba-4814-8ffe-08df2df934ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|18002099003|10067099003|22082099003|3023799007|4143699003|261009223027099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: sac30eiX4gsi6lCn/x2fjwXt/H7ElYGh2UxkcNqtM6wHWskOvoKKGfIu7obY9NIKOD2rkHj3DwVClCbRH0hU+oPqfchOpyMvHjmfaD8d/EilvwHBPj1HlytdQ96sM9mVRh6z22mnnjrzeyFma+GRM0v81MQlBxuyJuvLZVwaJMJLUhcLYYayF14t5KR/wkmrwRMbrmvabGiJkSQLDDGHGkUTIayAGelC0X9gluEIhjdDzcR+3YCsF+q7GCI5VRqsZHXVRznMdEf7+w4VCz/COIEnjAIkhHV8yFmf5OGIrQZpypNMS+tP64VwQivZXc5HjZOcVCqDjUz5FVRo1lV7UOjM/SNWexWOd58jyxpOPWHqLrB+dUgUoQ0e+qlzT4AomH6aBd2OWDudT+IhCVbOrZ9tbguC0jJknDrs3au0wlRR3p+0TTi2UqWkPmNclANjywdpMfkqjvGiZYIbDmFocDlsY3+OvR86ap0/6Q3sjqBwIICEuNcCr1YVbSiNoYfbnqauLnhS/OFl2vnbTi8RiHYduEGKxShuTawEVflK6MFQI+f7Ot+hvEpQ6F+QanjJiL1vJ+xM2LigAb3bECDIyjsFIkgiLPaT5Z0GXr3blfIafGVqEC6JXwkfLn3sKaYGN+VBtVxmiU4rN+Wov5YG56bIxn92d81U5fVRtcRDzSQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(18002099003)(10067099003)(22082099003)(3023799007)(4143699003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wNCVu4k+4xJbX0m5GHorYoe/i/ly3Zhb7k19OSkENi+m+6rzFDFQH7jkIzrc?=
 =?us-ascii?Q?xSci/JtC+ctxjkr7Q+5ITj9OB57DpnpytgG8sv+eP2YeuS9UZiLHZk4H4hq+?=
 =?us-ascii?Q?GJpV+6fXcadh6vrDi0B3DY8frfxdlyK2MDJP6qxnnN666sgqpXoyVsHnzHW4?=
 =?us-ascii?Q?JXIFFl9zmTMChdKm5Y2N1HcGxCzcVTVE5mN7G1nsijDHc6o6nJVRTMamMm00?=
 =?us-ascii?Q?yl/NZOkmu4Zi9eMpKmGHKZKOG+uSchFvxCD/KzjMIheciFeLdFrdPeGP1+8S?=
 =?us-ascii?Q?gcnEIizKcHbuLZE4PCd4B5aEpD4MLcC2izJAac7Ar1uGg0nzo88khzVHu5DS?=
 =?us-ascii?Q?l7htR8lf0eWP2imEUpzwHNIIoh1GpxZ/FsKAK5fcTkWTGpfaxqCav5OsYcb4?=
 =?us-ascii?Q?m8paYm/EFTkX191ef6WAycvO8H67QMH7HAbHUmvyMpV/JGoJPoDAjxTWSCMX?=
 =?us-ascii?Q?wbYNQ1A3F8GMHCoM/8EVOOYFSo4yXTB9J0vRuzYUH5P2F9Hv66Uhdz5+6P1c?=
 =?us-ascii?Q?5XKBUbeDhKgsgutaY2FZZchDW73ZSLafRqFukAMH7v8JLZZiTdxtsaSsr1XD?=
 =?us-ascii?Q?9v9WoadHeH8kD28fCG9S2qjFrO6csVtizhvtAob4aDlXMNZGtFsmzLoYnFX4?=
 =?us-ascii?Q?Bh5qDoJF3PdTV7hK4JWAP0w3+Aaf+FXPN+oHZ/wJnRHQ/QouvBC0GiEnAqYQ?=
 =?us-ascii?Q?lLwzdWRQZjJxkGNrUd8NqgkTMzbNyBaJEFfTUCoLplET0NqpgjJR7BbOpDqy?=
 =?us-ascii?Q?0hRh4caZrUnlUVfNCA8fNB11KruT11J6jyGHliTqEW6kBV/N6ke8nknsakNj?=
 =?us-ascii?Q?YEyScXoyOTxbyyvkal3Zi2XvGznb/ZuioPiyCbsSjVhloBuG8vm9oQkwgQ7v?=
 =?us-ascii?Q?oXzT/ovp6IqMEl2pBdXaFCtfZIi2Msi9PE7ImkWctzvxNcVDhLEe16G3uuNk?=
 =?us-ascii?Q?n+DriLt0AKfv3tYH1n20tw7Q/LBtXxbz811ejpvci2VcPszspfeBCTRn8aYZ?=
 =?us-ascii?Q?0mC5CX3fGyq3hQPSpveefifGSHV8GcvmLQIH50HfJ0te4fNo9EYaXxPcxSNR?=
 =?us-ascii?Q?/U2g65//wCcDlyhDCKVsjOfmCmxHo0GgZ8rAToX1T+xMCAZJa05h8WhuvQ2Q?=
 =?us-ascii?Q?tjHzMQtfZBtvkW/hdqQMMklV8tGxRutj8O+982ZMWRSdpij8EgeH4XmDYHhh?=
 =?us-ascii?Q?yLz96lAo2F0OxKlpRvwZ6wrQLQ4ucqDtxb/LxzuqD6O+z6RFHBUf7Jrsomo4?=
 =?us-ascii?Q?ro/9KiBV6PVMBur5VnYIo1pJUg8amlBoNVPBlttML/V4VnsQkIGkTth9J3Hf?=
 =?us-ascii?Q?1RnmqZ0mvVZcPfLSRrjSv0iiS4i7WkWFYCNI0JqBs/YAR0l3HKEK4mWgGsce?=
 =?us-ascii?Q?TfSO76qfrY67iDIP6O/xxYD7rAaEad8nvwyroakb0c5eIeqhf0Lc+flJjHac?=
 =?us-ascii?Q?Unn+Tvy6GVEHvYO8oCB19CSnRCMIY5SL58VG71y9A6GZgZs9s7CRi0HgV4QK?=
 =?us-ascii?Q?xc5Fi7ZRczEkzkpOiHX1FvLYXj6qL5kOcH4+1zt9w338Iealzx0jbZ5Z4lSw?=
 =?us-ascii?Q?YTs4YF8lxLCGvUJX0hyX4cgP5hV68BYS93r5qqTcRpuAe7GpW/oZJ99Stipv?=
 =?us-ascii?Q?dTsZZDhf2WEIF+0m12vwfLXrID2GH8fmQWFXNSO7lmSfxuDLjL0gpy+S4QVi?=
 =?us-ascii?Q?6Pt9MH4b+SHY8ic0xmatVjNuo1ztJUcJvUwba7YVQU6o6py6IGqxqRq0VbzT?=
 =?us-ascii?Q?LcbNqDWetg=3D=3D?=
X-Exchange-RoutingPolicyChecked: C/OlcZ9hjvoY/e7ijy4JIzsAs66G2ZJ1oeyDjWmMkPSewiEp48f5MTaiOAhx7+04xrY81IT7SWkspoFs4T85z5SJw+KJhHear5+z0rSxsue0NU9c4jAx5MwE82zzG969Pkh3ZHZv+uPiv2JxJkyBtkBnQeMDHbuXrT2eOIboCRM+QBEHWsqKZ0rsvXjd+lCV9va59zdy+HG2XYGit3oFTYj1+s2fn/VW7sInq9rGWcbTea4m6wQIvnYhdfwn0A2Qc8JBuvEZO8CmFsZ18B/tctPHkswWOeFQmzAdRnZa9BGYoE9Yz+mEWDw31Tfcg4KM6TcThv+RbTEtsJg4eWLw9A==
X-MS-Exchange-CrossTenant-Network-Message-Id: c666b953-a6ba-4814-8ffe-08df2df934ab
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2026 15:54:06.5776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zTPkPEokj4VZoWleH7gCVjQCczEtfI/7wWVL7faSgoiXc510e7GWRNAQyAEkQyC6OOwV5BoUKFH2SLQGo+unFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7520
X-OriginatorOrg: intel.com

Hi Tony,

On Mon, Sep 28, 2026 at 03:14:48PM -0700, Tony Luck wrote:
> The original implementation of Intel Cache QoS Monitoring (CQM) planned
> to integrate with the "perf" and "cgroup" subsystems. With that plan it
> made sense for parameters from CPUID to be stored in fields of the
> cpuinfo_x86 structure. But that plan was abandoned and the resctrl file
> system user interface replaced it.
> 
> Centralize all L3 monitoring enumeration within resctrl in preparation for
> removal of resctrl fields from struct cpuinfo_x86.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

[ ... ]

> @@ -132,11 +133,9 @@ static inline void __resctrl_sched_in(struct task_struct *tsk)
>  
>  static inline unsigned int resctrl_arch_round_mon_val(unsigned int val)
>  {
> -	unsigned int scale = boot_cpu_data.x86_cache_occ_scale;
> -
> -	/* h/w works in units of "boot_cpu_data.x86_cache_occ_scale" */
> -	val /= scale;
> -	return val * scale;
> +	/* Round down to nearest h/w monitoring unit */
> +	val /= rdt_l3_mon_scale;

I wonder if we should take this chance to check if rdt_l3_mon_scale is
0 on broken hardware?

> +	return val * rdt_l3_mon_scale;
>  }
>  
> + */
> +unsigned int __ro_after_init rdt_l3_mon_scale;
> +
>  #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
>  
>  static int snc_nodes_per_l3_cache = 1;
> @@ -418,16 +423,37 @@ static __init int snc_get_config(void)
>  
>  int __init rdt_get_l3_mon_config(struct rdt_resource *r)
>  {
> -	unsigned int mbm_offset = boot_cpu_data.x86_cache_mbm_width_offset;
>  	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
> +	unsigned int mbm_offset;
>  	unsigned int threshold;
>  	u32 eax, ebx, ecx, edx;
> +	u32 num_rmid;
> +
> +	/* Resource monitoring leaf is 0xf. L3 monitoring details in subleaf 1 */
> +	cpuid_count(0xf, 1, &eax, &ebx, &ecx, &edx);
> +	mbm_offset = eax & GENMASK(7, 0);
> +	rdt_l3_mon_scale = ebx;
>

Sashiko warns me that ebx might be 0, would 
rdt_l3_mon_scale = max(ebx, 1);
be doable?

thanks,
Chenyu

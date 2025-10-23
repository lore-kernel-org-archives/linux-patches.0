Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD6E26E719
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 20:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761251283; cv=fail; b=Qay3q30bNq8tsoD5TYdWtn9vw2eM0S7id/Gsj+CQe/q8IJWgAtZhNkc8x9SiAy8iyo6Uq/6yylgmCEhtgm2Yi86rMWrreg05ZxK3c/GJh4PlJSnzabEcd78OztTn78ppZ1q8a2WiKg/pfTLRFnUEB9eQ7lGLPMkHZHJMbEO72Pc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761251283; c=relaxed/simple;
	bh=l24UZn0teBXLpSUslXnB1sgtXzRhcYJVeAfluRiArT0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MvrePWkcny1gY/DCjVEzOht7CkirFJlJEvu8Eh9QFgNePiASdAR5ECkSNl5ejHkEdnETVBYCJ82D/2ml2jUuEmG21bzkcf4h+jVLwitWnEfRz4mOY3C9IVde2bW+GIu9O6QDxi+CoG9/V7RDyXuLuWvj7aiAGr7pByqYt3TuRLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L0f2K7rq; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L0f2K7rq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761251282; x=1792787282;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=l24UZn0teBXLpSUslXnB1sgtXzRhcYJVeAfluRiArT0=;
  b=L0f2K7rqFq3NfaPpOJvUwgNSJEUkY/cQQeUySaiOoTYLjZkdNez7GHP3
   zU2h4PuOZqLwZOOGC9PVlHu2Bs88EIGxswmPr6BYGtfL558CY8lnkR0oo
   dvu6oConmkKkJuMhMOWsdN9d1mYAsnG1X9KhLkhdbKmbGwdBqoy5b9Bd/
   0BCOd6ginFA/NXgKBag7pWNA+vOgcKmhFAZcoCup7RL0VhIlyzdWXepgl
   3dDKF9BzZGlfDx0qTNzDvemsonoAG80FUSdZEekzp4YD4ldMwe7YZwIVm
   hCB8yUkArdRI4nJ7gLm7V7qLkCN9ngEIe9paBhDRCcvffo9BPq8MCjHjT
   g==;
X-CSE-ConnectionGUID: 7Cb5icMcQkmD820kzNqrZg==
X-CSE-MsgGUID: VvJ/FNa7SCy2oIXSJqXHXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74103144"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="74103144"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 13:28:01 -0700
X-CSE-ConnectionGUID: E/gDwrjwRq2jFaXr0mfmyw==
X-CSE-MsgGUID: bw/bYFfIS62A2qVo50N2ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="184732362"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 13:28:01 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 13:28:01 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 13:28:01 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.48) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 13:28:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d0ZSv1cLK0Rp8Sz7ZrlW+lVjM58oTo4d+AKRFryNcPjv88s6Swzyc3o4M5NTPUcd0kfoYQKAx7AjBgbnl5xx1of8+LdbmzbSzY0X7qKW+MlSzoU4IxJl0xAtYQzWpySb9fsIXd8/YMdVL9E65FhMaOsc92RVdWw8YIv7CSBAFEMzuh9gdusLna2cM436ak7+Zv9pX18Ry4riJQ1Gv199orPERBuJrV8ko5ZYL4wE3T+lNm4eWaarBoBYx20NlduZO8wb1UcaJMCKNHnuvsd4gQXVNImIDXXEqD/QjpMYzV1/S6ex/uRQcNa7VlnuDHhbsp1g1wCytb9O2wQg0dz2cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6KR3cYDb8mzWG4RGCs72W6TskdgPcOJYxVjsj+qF5EI=;
 b=p9Rgu8QzIVe/iJrlPld7LBcpfjKLz4AcK8feERDifPBQ/S2kvyYybn8sOpS9Wpg1D/no1ZctqYL8JkPADrsx2GxoTAYSaLC7vAhtgX4evc8OMEWz3Qq19d7nG5wZwUFxrg6S1Xm1tYBG1Pf8nGBFy6LKJlXUrJ5jlWrr9zy6JxT2KLrZMT1lEqmVvGDkOrJO1tfbEPmK3sc+h5bVrGt9xQ6wft3PJAUcCNjajdAcpkiTgUsofV+EMNCVIy3oJk9GeN9JB560+3DCCk0590gHlXhvIRK3ufP/oVyh6q8ChNQ09DsxyzprkxyJEo63kisFKUKlFmNzWGw7JYo0VED1rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ0PR11MB6671.namprd11.prod.outlook.com (2603:10b6:a03:44b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 20:27:59 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 20:27:58 +0000
Date: Thu, 23 Oct 2025 13:27:57 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v12 06/31] x86,fs/resctrl: Use struct rdt_domain_hdr when
 reading counters
Message-ID: <aPqPzUqwOZ9o3DBK@agluck-desk3>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-7-tony.luck@intel.com>
 <8f97f875-f032-4a87-9b37-9dbae2537b6a@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8f97f875-f032-4a87-9b37-9dbae2537b6a@intel.com>
X-ClientProxiedBy: SJ0PR03CA0383.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::28) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SJ0PR11MB6671:EE_
X-MS-Office365-Filtering-Correlation-Id: b5c7f1d0-e765-40df-13ba-08de1272a7f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?CLlB71ZDwEyA+1sqW7XyqbUN2amzOFgt+h5FyP1y75jCOKjssS+1yU8hEIKi?=
 =?us-ascii?Q?FLiK8BgT0hLijh3pPmTNozEn5ou1j1VBWbO0GDOs6qdpKrsdpzTfEtt3g44K?=
 =?us-ascii?Q?hgSlcOUe563ryt9rfGUx2HdGkYjJnci2yRxrCWiTqSxg8W5H4Qa08ORo+vT6?=
 =?us-ascii?Q?Hw4yXDq+cpDTaWie5QQXsYNwuPlwx9AqTnz3HcdQzfgxww2kZzqdnz4GtnaC?=
 =?us-ascii?Q?tIe7ET5+F9SG/XVjjKGLpIAWKeRs8XOJAan+yGGXMnHZdf6WIKL2lzMBgC5r?=
 =?us-ascii?Q?pZfl9/6QtWAy0aI1QW2w0UDjDuY/QJXfR3fb83WSrQbkCvONvOlf8BeqN4vI?=
 =?us-ascii?Q?vq94UK+LZvk9EG1WPQ3LGaOvEfKSs0yqJK/ids+ouWXU33G538Llu/XOTlC6?=
 =?us-ascii?Q?XMM3Ovmx53kdLwh3zX0n/DlZO3CtCyhXXmBniD8I9B945NnS+n2RCkWd5+S6?=
 =?us-ascii?Q?aTwuJ+HnQPyFlJ67Gbmikd2VUmjdkIIOwruCMXP/5h6HI73OiKy8J/5qXRPi?=
 =?us-ascii?Q?EpllDCysp8GM2dfPSJ8QmP2/hvn1FPWawHmX8gqef9l2NBLblSyGI9HTghtt?=
 =?us-ascii?Q?NT/Mdu4Qh9E9VZ1aQ6YjTCchOwqSJamNnhtqcmqKjv7fvdd7ZGZgWZzJqXdG?=
 =?us-ascii?Q?kM17e1SRMRr7PvSAAJeRfR8KqA8TQGBayQg5XlJjfVWzT4IXupF3OQRM8VLY?=
 =?us-ascii?Q?I55XXapQFJkzKrcpIXd2BZ/T6iY5qbidycDwMR4v78jQ1+Nhyl8vFQ2N3WMI?=
 =?us-ascii?Q?T+CXtdQyLbh+dSNrqInaC9pp0jncEjwfP0kbSlLEm4sxHqdPutc5jVmAwS2y?=
 =?us-ascii?Q?LYhaeEbzX67PEmN2VoTQwbC8SthiJ/poFhYrnWIkjmSGLuFeBEIc48FqUeQR?=
 =?us-ascii?Q?0Om3ITnLVvE7yc/VPNkJukGAQiOrArtjxEz/M55/MFP0b3ziPuyZbA3j3agl?=
 =?us-ascii?Q?cp68vAJpVAvHjw5OYhZSsq6QNh5lYUAC+puvH6HCyjiE+NjFuGTt9l/LmFtU?=
 =?us-ascii?Q?KQg9rn3TpvL77Z453XNBHo5PkAH7ectDh3SwPMCYtEAg3iE92Jn7gIbscWjG?=
 =?us-ascii?Q?18fzz6Sy/peo7DLOtMa6Rka9th2u6ZiFbrb4b1pltzmVrEIMH/2eH+BmxX4r?=
 =?us-ascii?Q?uIpq3r76vd1WzB/Va/WlTwBWwf41mftUFLLSrOrUPBHoabtZlQkV8oKgJYvt?=
 =?us-ascii?Q?QLvbSaSurDFNsdhPX/AlEWq/SdzK+nBcQiwOpsRI/38jkMBssrlEV7vBBnK+?=
 =?us-ascii?Q?zH7yTX0dDOOp/S8Wummuk/qU0YDdUZKgQClDyEpvEcqzG/bn1ouhmfX1CdZV?=
 =?us-ascii?Q?hk4mXrAejSASOO51b9UfHz7RVGKEDtPIT2ibWF5GaFHmrrYZxBwFiUEiBHP7?=
 =?us-ascii?Q?fgMRxjCh1OKX2q8npkCV58rgB0uva+eA77MGO68AFo+W89EAgIoLZH3z5p8Z?=
 =?us-ascii?Q?b9+FJt41lU++/baumqYeBLBGBapuYLtn?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CKOHguOdMwIBgnmGLfj5SJWar+c3f9s70DlNIIzW4lCyY+yCXGhyEUpRcttq?=
 =?us-ascii?Q?Ngu4VHXKS1m1y9hXjgGP8YuQvzqa4Jqy7N9Tnyv4ozAog6lEq3o+5xjWu/p/?=
 =?us-ascii?Q?ZVQksCngc+h1x2ZxHKvZF3L+yxXSUOF9UN9fNxf7veQc6zfEhmuwn++x6SAM?=
 =?us-ascii?Q?KlEodBvChJzCUvXSwDaD45m1q2DupkiojSp8dIy2tBQT59vjydz+29VF4Vaf?=
 =?us-ascii?Q?rhqu8efMoHuWZ2uVP6NTvl6UPawZKyxviLWQkFRHaqhu4XNMeMD5Ow0OLvvp?=
 =?us-ascii?Q?OILKdcFR9d99ZEJAbxNSkqID3gWJWAZaruYalp5oEzz1He3tx2OKBA/gI5Yi?=
 =?us-ascii?Q?VToe+WLVfVVyH8ji3OsXjPYV1H0twuWw5FdIC1/FXtwQujS6Ce/M1STMhTvZ?=
 =?us-ascii?Q?OuuLrZtF2LYQxN4uvubWDcAwsxRXMEy2NUG/Ns/UcvMf9EdbDp7xPfmjzIaW?=
 =?us-ascii?Q?31Iyu3VVCkfnn3FdOUiTmGOM7A8q78eNugqb2Ry1VwIUVFUZ+6lxqqrBFrc+?=
 =?us-ascii?Q?eOgNLyba8+YSJiJpy+kOHs8vAYLaQOM12NbbrQRMZbZWLWDFSwe4biHJXCfF?=
 =?us-ascii?Q?bK/Uw7fKLx2me/HlhZSDu+MsoZAIjsTkGuh14JLk9ZtN+1gPpCKoq1qNuX0x?=
 =?us-ascii?Q?HYo3rXz8LdGlxOkpbuToR7n7s7ceJ3pAWv0cMrIhdz5Q7sl07cbdc5HJuz6E?=
 =?us-ascii?Q?mNgSFmIiX5aiDTTl+ocKfVUzz9WzYz3/wwr+Rm32zsgHV+dVv9/wVD+P0ocv?=
 =?us-ascii?Q?jCHZKTeKQfkc4qlxMFHEd5O/cFKt2yqCrvb5/smL6gn3Oyb6NHd7OaG2PbWy?=
 =?us-ascii?Q?65ykSFhZdW1Mf8h2IxopRjamw7g8BU0qtTGQtoB5FTT1peuHtuL0T645WAN0?=
 =?us-ascii?Q?rM02ApT8LTOXxBVz5iKLr8DZp33iHy+eAbNmcAb5+tU+zwJpEDxpwmObW5gK?=
 =?us-ascii?Q?5M1DUbgBDg4SozzgyNIH126sMsnwN5VzjRt5bChQkycBfL0rAiSn+uRH2LAJ?=
 =?us-ascii?Q?c0zat0X0JPiyucPAxQnYb03oUZxACoX65uhQ6PPLRBCEaWlqDtx3v5cuMoFO?=
 =?us-ascii?Q?RKFp6lwe7MzejB7tUOwnXCpUwbRkSeStG7DrYmb4hNU6crWROWGyTHJWYjpB?=
 =?us-ascii?Q?Zyh5zokDP8fR5KBtxjgErVFDPOs3CtTzoX+VUwapoHqOwQmf7cTWNXuWbvlC?=
 =?us-ascii?Q?VK083p3D6/bF0sgHgVLbaZOSOFtwrx27FeAcrUZT0qCGaSfNmJlasyfA8mzC?=
 =?us-ascii?Q?tp4vKiTmwVclde4mUp7C1hCRpCpLEWG3YP48iIPuSiKhZorSvtCkw7zIb5MV?=
 =?us-ascii?Q?BzTr3hkrsTuJlAXXHL9QED6tfzxjHnsleRpPuqJCHJt1ZKeA3ELerOo1EKda?=
 =?us-ascii?Q?Uv7uSrABtNFgaV9p4akQBmG094bKZ5k5iljQ3C/2GLY3SblOZ1ruVou5wQ1J?=
 =?us-ascii?Q?1BRGgo8WAsDVhR9xElYTrJPQAxQRNMaCVspm3H2c4zjAW/dVux+aS2laMg5Q?=
 =?us-ascii?Q?FMWJgcIdnHbTJShLqgSWLo68vxoCAExjAdTVfPMFbZPMjAq5BMUj1p9biTRx?=
 =?us-ascii?Q?uyZXMJpj+nbOwJaJKujRlKdprc3PDH1BMe/Zg2bq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5c7f1d0-e765-40df-13ba-08de1272a7f6
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 20:27:58.8885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1VE9i72vK1cwnckUkLG+qqKtx2ErKxxcS9qNqRPkZYQo9k1Io8l99VECre9Sqn+AnE80NYTnEoF+OIb3+nfzQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6671
X-OriginatorOrg: intel.com

On Wed, Oct 22, 2025 at 09:17:54PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 10/13/25 3:33 PM, Tony Luck wrote:
> > struct rmid_read contains data passed around to read event counts. Use the
> > generic domain header struct rdt_domain_hdr in struct rmid_read in order to
> > support other telemetry events' domains besides an L3 one. Adjust the code
> 
> "telemetry events" -> "monitoring events"?
> 
> > interacting with it to the new struct layout.
> 
> How does this justify the changes to resctrl_arch_rmid_read() and 
> resctrl_arch_cntr_read()? If these functions really needed to be changed in
> support of the change to struct rmid_read then resctrl_arch_reset_cntr()
> and resctrl_arch_reset_rmid() would need to be changed also, no? All four of
> these functions are called in the same way before this change but this patch
> inconsistently changes the calling convention of only two of them without any motivation.
> Seems like the resctrl_arch_rmid_read() change is sneaked in to support later
> reading of telemetry events while the change to resctrl_arch_cntr_read() is a
> remnant of a previous version of code in support of telemetry events?

These functions got caught up in this change, but it probably isn't
needed as they are L3 specific. I'll see how things look if I pull
the refactor of __mon_event_count() earlier so they can avoid this
unneeded churn.

-Tony

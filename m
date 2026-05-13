Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669A33A758D
	for <patches@lists.linux.dev>; Wed, 13 May 2026 19:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778701920; cv=fail; b=dyIv4xD+ZxVIbELGI2jS5Sc4bTxORBOBDYdVvXjFekxeZHZbI6iFhoW4LEE4KSrmzJTzXUO0a1m9hvC8RebPP9kLveTJXKTocr3BYtOvo2LeyZ0CgenXWew5AQkddHCgvApFCaGfTp9+65kUh1I4jxZIUfUwt/rIr6JnKj/bocE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778701920; c=relaxed/simple;
	bh=fmgfOlB7+1EmcVMuNXG6lAlLE1aW5hRm7GgyZxeqzEA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dPlgMtKWpSyOi2orlWLqKzyk/xI4QXpsSwClq+0nZKsjotHPADNZ4oowH9o2ueBDsOQQm6QgpdsEAjoRXb2JBKqZwt6hBlO36o2+nAjaElT1O7XKnVM/ER6r9+Ll+Au75P+5ysu5NF5Pmss/vF60iJek2xHaawYewr4LC9to1yE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fQOFmbap; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fQOFmbap"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778701919; x=1810237919;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=fmgfOlB7+1EmcVMuNXG6lAlLE1aW5hRm7GgyZxeqzEA=;
  b=fQOFmbapvdss+O5p2n8pqXiptzssOuDQvAYSYO3MYwjLl4Nb+HI+bLo7
   bNmG8ktMdzXwhRCkEHpBrl1qFx2CCoDZu1fJ/vj67nx8ZcLLJLMlSubb+
   3hFQFYv0TDKCmyT4VZUnSUgOIlwN0KTFeB3DYp4O1/8CT8/9u/ErnbTrf
   N7YoC+HTFft1aSYIre/m1oKzx0t63B5EBoLnvGfIUBKsBF4QkHlQk72Ro
   2M4VU+BeULB7IkxPW/Q4pjMkaqNoXKAaO+xW2wp5Wt1019UkYibNi7aQm
   wR/8wwNeUSllX98rk3enAzIHqNu/Dj0On5/TUODkeGq1C2SAPtzySi1V5
   Q==;
X-CSE-ConnectionGUID: EYd69N4ESGyfaGZ0GcVjNg==
X-CSE-MsgGUID: Fa2zqKK1S6+9stqg/qNSvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="67170561"
X-IronPort-AV: E=Sophos;i="6.23,233,1770624000"; 
   d="scan'208";a="67170561"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 12:51:58 -0700
X-CSE-ConnectionGUID: YQaSXzJdQ46L0Ds+AipS9g==
X-CSE-MsgGUID: B5J6SJfHSkafT4ansJjQSw==
X-ExtLoop1: 1
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 12:51:58 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 13 May 2026 12:51:57 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 13 May 2026 12:51:57 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.65) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 13 May 2026 12:51:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WE1K9mwb/M49vJDI1dZ140j+28+0qlfMTBAfV2k+L64BdQDHE2DNlPsOQvCWh3DIL9UG+ud8fPxrlmrxavCJ0XECODev75m42GqRgq+qNS3ewvl0f/U6mJ13Epkcd6Ci5YUNPCs6K7WuFOhLpltym5NsHUqSpFetsEH8MWw6OM5SdoSFVFsXiDm+TKT7uh3CaqvKd/npTPDihLnu0SHBkI/HziLrlhccWt8479+kXJh40w4Y2RHG1I/M44OyAXmCEwf9oT2kd/84HyAemb/2kBj2uisG1/8uamNyq7XJrg5TjWOPyz+O0ng98iBJ2ayedi18ieQN1ljAVi0ohGeALQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HwpRHt0aw/lge89stqNP2KFtIBlxpyFZZ6aQmRF9m1A=;
 b=BXFGGULIyrZ4FV+Qzf6RKc4+lkHVbEp9uiXnAU/f4s/Kk8Ucegn2o8rnlYckpQCq/DaunH8MJtl7IoPfSCv0dPplo59O9ihzkAiphW6R3h1+ZV3PkeFn3vYEsf/MVR2yRzIl9oz/5JlMIJGY0SA78YNSsxWANNnL4o6k/OyszehfMobO130U+hM4UbRsTPlGSgk1lgpG0H3hEQ42aeERUCgrP06qcgh6SRbjQc8Gi/GeYJY7Z7hGJkObew6tJoij4kpFIf8aFi6Q6ed5cBifB+Vr479LR7LOuqVl6OjiLnVGMHI6DrjIwnk0ohsu8vTP8eCXeN+S6NfJ5w4enmzjWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by LV2PR11MB6021.namprd11.prod.outlook.com (2603:10b6:408:17e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 19:51:52 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 19:51:51 +0000
Date: Wed, 13 May 2026 12:51:49 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chen, Yu C" <yu.c.chen@intel.com>
CC: Reinette Chatre <reinette.chatre@intel.com>, Borislav Petkov
	<bp@alien8.de>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "James
 Morse" <james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>, Babu
 Moger <babu.moger@amd.com>, Peter Newman <peternewman@google.com>, Dave
 Martin <Dave.Martin@arm.com>
Subject: Re: [PATCH 3/4] fs/resctrl: Fix deadlock for errors during mount
Message-ID: <agTWVa1NYNhA5wUp@agluck-desk3>
References: <20260508182143.14592-1-tony.luck@intel.com>
 <20260508182143.14592-4-tony.luck@intel.com>
 <e0f70732-3ceb-4d4d-8ffd-4f2761922e3d@intel.com>
 <69874f4d-e64c-4d74-8ba9-eec30760751f@intel.com>
 <547e32fd-1d60-4c12-8ba5-5f8cebe5ab87@intel.com>
 <8ee967df-329d-441d-9635-47f48b5e7b8f@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8ee967df-329d-441d-9635-47f48b5e7b8f@intel.com>
X-ClientProxiedBy: BY3PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::20) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|LV2PR11MB6021:EE_
X-MS-Office365-Filtering-Correlation-Id: 9834b382-8cfe-4a2e-0dbe-08deb1291366
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|4143699003|56012099003|18002099003|22082099003|11063799003;
X-Microsoft-Antispam-Message-Info: 0w3qi5bdITkQX8btcBmUbhu3fUYZHKLhSN2nSRnk3V1WFbvy2wYhMA1GC1sMoyeC02O3LwRfkUBg9c7TLgZnwbj3E+ojm+si4PU98hkNwu9qp70dHknyWX/5r2fGs500oNqdS8dPN36DXtsOfkc+K0HGg1swhyr+KRR37rgw6kWJZz1ZDGkfVk51q7zCK/Kl1293O1aa8AIEqcL5o62OhMbsY7jw/atSaEXxjfU9pDWFHc/Y8p+G6LIi+sP5mYKKjM2JN1UryAKFRWoYVgnSmyG0sdY/pOYj0UNMC960O2SS3jjiq/sR6YyYUWis4nVTPCLAvvfTbEtHW0x8885OByraR5u6pYVru902IuXuMNfDdKj71+B7zoWUZ9znqixj2OM+RhF5vB1XwsAGl5Vp/eExm2oS1HDLuXWYWXxaWsA97zdq6LMOqQMGInqAd9TqbOEN+dJ9nfwFhnYUOQdTLKTZA72rKL2jbOJlprcdr7zarss1bE9dG4UJ9a3qgfZ37NIP2QmQEU2FTTL0+z7hPm9Um36hIBvPLwDcCUBLGmy7bP2Ld9qz3ZtMR4cL2i4gC3DTy/H+rjB4T4/OAdvoP/ecWDsXVMckYQDNpsnvzlmUbLg/rj4bANHvfH4KJkQCq7nsyNtnHI4Efc3vB1Q2V5H0EZPS7XpKMB0f1u8gMRv0CtpjnZ8zd+VPFFysuHnv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(4143699003)(56012099003)(18002099003)(22082099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?kD58aPo4MbCn//vA7LdI5WuBc5eUTOph1FEHlyv6K3zD4X8PywJNIqZBGO?=
 =?iso-8859-1?Q?okoeNW0g23U69CkyKZ+VWd2SPQ7krNCpTUHBzt6RNzmjckFRUjQ6Lg8mQB?=
 =?iso-8859-1?Q?2sgdfB4kTgFSEm9yuO3pMu/jJhhdtCtN2fIcHdkD2pwMhezHRuaL1KLytY?=
 =?iso-8859-1?Q?bYimAtbgfIxV3inKOFDnCjR1nPu1kaH7+LxOwiOcjsVCFPi5s+gS2dUGJb?=
 =?iso-8859-1?Q?aXMozZE8t3T2ypu2uK3GtRSaApE7Q3ysSGe4omPanN/FvfC3GJJ27YCAjG?=
 =?iso-8859-1?Q?FTuHteR7pDBdeU6ofKZEC8DxZPhACvtgrjkEcuQ7bjkoZImYyxZuo95nmm?=
 =?iso-8859-1?Q?EB9Wxv2TGRRRMFk2zswIOZSS0eMJ5sdP1A/RizpmKpws3WzvWU/hdP95oA?=
 =?iso-8859-1?Q?6KGXmp4aAzs6Pc3YT3brbt8qk+CF37n6wRUIp/3t6NOmx5Ek+bWN8u/gD3?=
 =?iso-8859-1?Q?TNSrvOVbUeAKVALMmP9N9jMMvkrEzI/wJEAbV0YypHonZQ87h3fJTVveY3?=
 =?iso-8859-1?Q?c3W2ls/DEY78SI4OzJZJnJI4B4NI7bdixNXAf/LmVfMFh63aN7ajmaABal?=
 =?iso-8859-1?Q?nAOTtXu4qilvd2ixi7B+G0tsYZ7YcfBZ9bmYEahnwduje0YxzXHAA6aPLs?=
 =?iso-8859-1?Q?Ljo9FL1sY3drIqZGv3cfYWdGCS7+zUdCJs4b+7hkpTgy7vVQMBJOlfsD/2?=
 =?iso-8859-1?Q?hb41v0YdWjh+s08An6bHFYWB9odlsVVs5POuynFVI8QdP0uU0Ee5nwGIkR?=
 =?iso-8859-1?Q?x6T9yLoITtQdCqWcOJtH4VVvP3eLrw+ggagLrZfRM6AXXPCGB/oGwUaD9H?=
 =?iso-8859-1?Q?hRgma5LJ9mfhyxGsHHNSrtU2e1sOkfvSaPQzST4GKJDMS32bN6an4l1r4l?=
 =?iso-8859-1?Q?O50D0WES0fj1MzEKMxvEf23fwS0yXjVjgLqBRC5RKTJHD7CprS3H3HJ3Ju?=
 =?iso-8859-1?Q?sgOxprLl5kuv5646TMw6R5AkCO9/koiVL6UVg9ksE4grWp4gBOIpOP89Wc?=
 =?iso-8859-1?Q?RfsJpBxjDftWEfCXZTn7NuRKx4q+ozkEWmZ2rEmx3dueUcQYgbjaO30o/g?=
 =?iso-8859-1?Q?+WhODXwOgZYJ5e0q5NS7/hRIs9lXLXCTGvVzYxJWJOVbwIo3qBJz3SEqiU?=
 =?iso-8859-1?Q?H3pl4I3Kggka/zCGWUQZJ6G7AnEqjOjjwaO+Ro2u1mz2qdpeHKoS+pW1Nc?=
 =?iso-8859-1?Q?AwzTBYgPuxp28Y0SAUeaww1om/9Hanzx/BQR4T8NhGsstDnD1ejbHOT/gr?=
 =?iso-8859-1?Q?phQtS349PvNZ62FsRP54STSe1yWoxoLMqXraAA41rY29Sei3fLMHDQr7XH?=
 =?iso-8859-1?Q?MAXWS97GjRgNIc/r5NHbRBosrQyKwYr/+61JaNU7ItvsbysRxWbuPUD3PM?=
 =?iso-8859-1?Q?gXZC5UjWD9DOA0kyS3zk2+pvFH0hkEOusATAUpQB6pvAf67hTr0Gd4Ph6z?=
 =?iso-8859-1?Q?2bpN+uKQSBF7SvVGydcZdGHysmObXxnZh1tc0FYQVDkoFkQde2lsJNjGiU?=
 =?iso-8859-1?Q?lU6zpjnZ6AFXEJRBcTTahUfi1LpnTSQZlWjfpebrpofBMAYZRgMUQLkijd?=
 =?iso-8859-1?Q?X05hZwt1Wz0w9YQX5m1WkI8vW4SRQuehYHtR7CTiQdCLK0mwVxCh61RbMk?=
 =?iso-8859-1?Q?3+9O0muiVMwalp5G+LHhT9JDf+sKIN3hxRnO0HVwrt8qmBnaemvdbTMESv?=
 =?iso-8859-1?Q?61/i5CWhHJ6AAGnkau8PVxlUODxlGR5xXzdwx25liwnypNlcxB7y3Vf+Iy?=
 =?iso-8859-1?Q?RIAYPsP0JvKJOwXXHtM4/tf+Vj7XnahFGJREs8V5PtL0xa9j73YjJZz5dP?=
 =?iso-8859-1?Q?hGcH77K/Rg=3D=3D?=
X-Exchange-RoutingPolicyChecked: iE4d4OYg70XwVHIqP1Xxt3dzEq64H1Fb1m8wMLqA2/0Di5v5Iw8TZleP2m9fVsu+UcGscGHOTzqoo6/BZv6xvtvhQsNYnt3zNLTzd2Ed+4JbWZApCgmGWKM191XuXilnqtnipJQw+T+r3lW2tODW18EKqmHnb6b/dA8vjUYnZHanzZmynikYMVs9QLVJSv8B3rX289Gbc4cDsOsSd/EuZ5dVzI3KojmruU4j3rZNcAepT/wgZEP+LSJsq4xeeBSRuSLMRQRkffg5ejQRXoNvii3L+UVSIF8lfLYKENV1WPUFtRZOwoDteKXzjh/nfOR2mtCj2J19ix/mc1SCaq4WPw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9834b382-8cfe-4a2e-0dbe-08deb1291366
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 19:51:51.3928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lS4Hk/9koKGtE/vXRbsB23Pc3uATJFSSQenD5LCBb99n4enFTN6M1xQLkTh0xVHXOYqT6IaMbbnP/iF6gcyzdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6021
X-OriginatorOrg: intel.com

On Wed, May 13, 2026 at 11:24:47AM +0800, Chen, Yu C wrote:
> Hi Reinette,
> On 5/12/2026 10:34 PM, Reinette Chatre wrote:
> > Hi Chenyu,
> > 
> > On 5/12/26 12:28 AM, Chen, Yu C wrote:
> > > On 5/12/2026 6:53 AM, Reinette Chatre wrote:
> > > > Hi Tony,
> > > > 
> > > > On 5/8/26 11:21 AM, Tony Luck wrote:
> > > 
> > > > +     * Obtain reference with locks held to protect against interference
> > > > +     * from resctrl_exit().
> > > > +    */
> > > > +    kernfs_get(rdt_root_kn);
> > > 
> > > [ ... ]
> > > 
> > > > @@ -3130,6 +3144,7 @@ static int rdt_get_tree(struct fs_context *fc)
> > > >         */
> > > >        if (!ctx->kfc.new_sb_created)
> > > >            resctrl_unmount();
> > > > +    kernfs_put(rdt_root_kn);
> > > 
> > > I wonder if above should be protected against
> > >      cpus_read_lock();
> > >      mutex_lock(&rdtgroup_mutex);
> > > like kernfs_get()?
> > 
> > It is not obvious to me what this protection would be needed for.
> > Do you have a troublesome scenario in mind?
> > 
> > rdt_root_kn is a local copy of rdtgroup_default.kn. The latter is indeed
> > protected by the mutex. The reason why the kernfs_get() is protected
> > by the mutex is to ensure what rdt_root_kn points to, rdtgroup_default.kn, remains
> > accessible after the mutex is dropped. Nothing else modifies rdt_root_kn. I
> > understand the appeal of symmetry but it is not clear to me what the extra
> > locking is needed for here?
> > 
> 
> Thanks for the detailed explanation. I now agree there is no need to
> protect kernfs_put() with a lock here only for symmetry reason. I
> previously thought racing conditions would occur if two code paths
> concurrently enter kernfs_put() and target the same data area.
> However, since kernfs_put() contains an atomic compare, only one
> code path can proceed, making the operation safe.
> 
> > Could it perhaps make this flow easier to understand if the kernfs_get() is
> > of the mutex protected rdtgroup_default.kn while the kernfs_put() is
> > of the local backup copy? For example:
> > 
> > 	/* Ensure root kn remains accessible after mutex is unlocked */
> > 	kernfs_get(rdtgroup_default.kn);
> > 	/*
> > 	 * Make backup of rdtgroup_default.kn just in case one of the
> > 	 * following flows (that sets rdtgroup_default.kn to NULL) run after
> > 	 * the mutex is unlocked:
> > 	 * resctrl_exit()->resctrl_fs_teardown()->rdtgroup_destroy_root()
> > 	 * kernfs_get_tree()->deactivate_locked_super()->rdt_kill_sb()->resctrl_unmount()->resctrl_fs_teardown()->rdtgroup_destroy_root()
> > 	 * These flows would not actually result in rdtgroup_default.kn
> > 	 * being removed thanks to the additional reference.
> > 	 /
> 
> Yes, this comment is very clear and helpful.
> 
> thanks,
> Chenyu

Are we out of the woods yet? Applying these suggestions I now have:

	/* Ensure root kn remains accessible after mutex is unlocked */
	kernfs_get(rdtgroup_default.kn);

	/*
	 * Make backup of rdtgroup_default.kn just in case one of the
	 * following flows (that sets rdtgroup_default.kn to NULL) run after
	 * the mutex is unlocked:
	 * resctrl_exit()->resctrl_fs_teardown()->rdtgroup_destroy_root()
	 * kernfs_get_tree()->deactivate_locked_super()->rdt_kill_sb()->
	 *	resctrl_unmount()->resctrl_fs_teardown()->rdtgroup_destroy_root()
	 * These flows would not actually result in rdtgroup_default.kn
	 * being removed thanks to the additional reference.
	 */
	rdt_root_kn = rdtgroup_default.kn;

	rdt_last_cmd_clear();
	mutex_unlock(&rdtgroup_mutex);
	cpus_read_unlock();

	ret = kernfs_get_tree(fc);
	/*
	 * resctrl can only be mounted once, new superblock only expected
	 * to be created once.
	 */
	if (!ctx->kfc.new_sb_created)
		resctrl_unmount();

resctrl_unmount() clears resctrl_mounted, so as soon locks are released
a new mount attempt (maybe started a while ago, but blocked waiting for
the mutex) can begin. I just want to confirm that won't stomp on
anything left over from this failed mount that was waiting for this
kernfs_put() to happen.  I think it is OK, because the new mount is
going to allocate all new structures. But there's been enough layers
to this onion that I'd like to confirm.

	kernfs_put(rdt_root_kn);
	return ret;

-Tony

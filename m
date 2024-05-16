Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EA1142E74
	for <patches@lists.linux.dev>; Thu, 16 May 2024 09:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715851732; cv=fail; b=ueH1pWSM7uy60Fofg6jcPQRFXqBPrBEOMCff6hd0tJZT/lrGSBTGDn3oICpmpgOOg33YrGJYMtbjbMpYAkIcIvaYlt5PLo+QaHhDHQ/sJ5+rxOfzDTAIqBJqBGvi3clMKenI9tGbfQbN4fVsX9x8QnRIeCB6kITAdwEPyfmiEms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715851732; c=relaxed/simple;
	bh=nLGAEu4wDkHTuRmmK+xaOXpZviypk/OfQ4tlYIyeQnE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=M+tRgw/jUj348CTqwwPVAsxptPVbgRwHKM6QOBJ5eIeJTF8zuFx/zxwL83wBcy6c/EahZJ9jlliT5BBrWwYYKXh/lpytIG98+rcNXaqAwd17KnQiB/bTKrpK4GTQvq8iX16gSQQv5Z3aosavVhjA/tuazn/OWP5kdGjVogovYrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fHgpW2hI; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fHgpW2hI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715851730; x=1747387730;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=nLGAEu4wDkHTuRmmK+xaOXpZviypk/OfQ4tlYIyeQnE=;
  b=fHgpW2hIPWBSvss0ESu/F0JTCmmtkeQJ47pk/dcJNALSw30lhIeG5ioi
   Ee/OAwvyIKMqXETreSC0jGuz5JtFJVLYzv3NyFP6HTOvKOWwZL9JFyQE/
   v9VMDvvCri4uWfc1Rm7Pc34+l/8W46w8j+j7v5ESDsoGt9vlTClDBK7vR
   ovhW46vIdzUPbZsQQJnOkGdc+ZTF+C3PJHtpIY2PfJZZXjQIYNnfSmNgn
   o6EIMzFRUz3Xt2H+zGoFbJj1oBIgOv7ydiqdzW5LwihGRRRYKIUeG+Kyj
   Fu7XckJF4Yo0K26XrGdiZ6YABB5ocWXwhqRJ9tVb2ktQ7GDrUleEwc4QC
   w==;
X-CSE-ConnectionGUID: FE2yKulvRhiAthXgOrUuvg==
X-CSE-MsgGUID: M6WViuZ/S4SfrffJ5GGHrQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="22622607"
X-IronPort-AV: E=Sophos;i="6.08,164,1712646000"; 
   d="scan'208";a="22622607"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 02:28:49 -0700
X-CSE-ConnectionGUID: +8ZRXVBzTsmwnUVEs+ZPVA==
X-CSE-MsgGUID: fc5GZpf4SmWVv7NzdWx6MA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,164,1712646000"; 
   d="scan'208";a="35923490"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 02:28:49 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 02:28:49 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 02:28:48 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 16 May 2024 02:28:48 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 02:28:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6zOcP0uEmBky1DW8MK1wKr/3lv2jxg3Rm3jVEp+r2v0sdRfc8kUETuDaBZHqbTi5CyIOaQJuVJe1fDd3PlRre8z/ScqawN4/Oohjpfk1Jugh6tBgnQtUyhSUf3NHtyFnoBlqK+8LpEi2LSEEEi1wLt8BwIUiYzHaWFp+l3BW1+2KIoxAhaxn0fd5YYejBDFhD04UWylCuMGvvUedJhTl+SkHir3uOwzFAQVTJONWqt8petRI0klbyKMiMSU0aZ1V+m4OkV77FWs7lj6J1jpgXwO5XY5gTQk9uEll/GWHXg832ezMT8c5lUhvD3bZctGXQqiNL9XGFq6LBHLge+JYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S9nw/YMAaajzY5xpQ3nkEQfJsNeyPOFLtTGIG2D/0NM=;
 b=biL4GEwBqMfZ+18qofYs9VV6e4P7p5cnnx5Unv4cJMnXfCeUnm7fCe42mvtC+lnHslgBqkOO/FyJdG6VuEA0YZuerL+Kcv+VQLpTJBstfQBcWPm6oFwlVFzYfVDnPWRZJFop4TOCRFsQ7ihWZPrEtPZuMhE+49135NmtnY89eC5leUwc9/5dMCE30tn4gUifTimgmyZHFWYZb6qX5Ggk/PhMt1ohDKb6nkloiHSTqZX51/q5FZiH7vhcFWYIBf2BVaw8oe7W2oXqfBOhJdW9veRzs40h9eZi6Tvnb/JBajjBCAoYWQNaG4dqvkD4wYXlJ9ovURpp3ZmlvBxxZH+70g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6231.namprd11.prod.outlook.com (2603:10b6:208:3c4::15)
 by MN6PR11MB8195.namprd11.prod.outlook.com (2603:10b6:208:47f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 09:28:40 +0000
Received: from MN0PR11MB6231.namprd11.prod.outlook.com
 ([fe80::a137:ffd0:97a3:1db4]) by MN0PR11MB6231.namprd11.prod.outlook.com
 ([fe80::a137:ffd0:97a3:1db4%3]) with mapi id 15.20.7544.052; Thu, 16 May 2024
 09:28:40 +0000
Date: Thu, 16 May 2024 11:28:27 +0200
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Peter Newman <peternewman@google.com>, "James
 Morse" <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, Drew Fustini
	<dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v18 00/17] Add support for Sub-NUMA cluster (SNC) systems
Message-ID: <6obc3orsktj4dcrl4nw3qo7o2dth3s5np6cyq6fllweq34iqlc@ku5cf7kigh4a>
References: <20240515222326.74166-1-tony.luck@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240515222326.74166-1-tony.luck@intel.com>
X-ClientProxiedBy: DU2PR04CA0332.eurprd04.prod.outlook.com
 (2603:10a6:10:2b4::20) To MN0PR11MB6231.namprd11.prod.outlook.com
 (2603:10b6:208:3c4::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6231:EE_|MN6PR11MB8195:EE_
X-MS-Office365-Filtering-Correlation-Id: ce0ef186-afaf-445e-dca6-08dc758a9299
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?02kFAX+4uY2DNiBlMqG5ZB55jfvDTkOahViZ5yCSTa9Uip9/Ni7RTQW7kE?=
 =?iso-8859-1?Q?L5esPnLlVaasUG9wLGW51vUURtB3Yzo23bty8BGehwY/BVnQrqC5tHz9/l?=
 =?iso-8859-1?Q?5Spw6ghad9ux9kA+vzzMqPXSMxKp29cucDBbzkw6M2IUM5Wt05t4MjVbt1?=
 =?iso-8859-1?Q?u7D8VBhZbAIQDUiK8wTkxm+FCc8ITBggm5TOdeqKRyfop+15siHm//ncqS?=
 =?iso-8859-1?Q?I7SV8dh4IZfnYoul4fAexLxY8neU742vcVNFQoxVyqiat6aPDCnPKZi/6U?=
 =?iso-8859-1?Q?TXVgCCTxeZfTFpvVYBLe/uJdGpfkYdaryWy52m8MYi6jHDyCiFAi5jREXS?=
 =?iso-8859-1?Q?9IKFpbtjy8gHLQd5fWfF3M0eeg51VIbl60Ed+FGQT2mRSha+IW5RYSveeq?=
 =?iso-8859-1?Q?+QYgP3Jh2ZP4LXY+2H3YYqmKRn8edC0bsOyGYTImWr1jKqDgMc/T7eDZ6j?=
 =?iso-8859-1?Q?7w1u5yrpwoF9ItyKUbZRGO79agC9WVuXbhVytKqeUxWM7GW4FcmEF5N0CP?=
 =?iso-8859-1?Q?1PnFbxjYpQSESmLmMxzVGwMjbtMoGEtb9mX9lL9nbI4OTc4wvUEJptoCgf?=
 =?iso-8859-1?Q?+hN0TA7x5i6FUz/mbKqDUGSvX4fk7qvwydAn8QiZ/rW/DnL4YEg3x/edz2?=
 =?iso-8859-1?Q?qHz+Lga2Ybpg9hNWv4BquQ8KoOZXsN0iP48WXCZ3rGT6huly2ZB+UVDzTf?=
 =?iso-8859-1?Q?VV921vaKCEdZX/+mxnCQmg7vFEk+e98xbtliF7bRg5ES5YIKobJe0PTbZr?=
 =?iso-8859-1?Q?53Ls/kg7L89TSdzniWDz78hF/cjgslGo8M8/sXbdt9E+pJHjvfEeaaQF1u?=
 =?iso-8859-1?Q?qRpZ2DlhcCYUjXHbVuFW4i2Uwij9ECGzNaYap5OvBS0HtZ8Uv481MjBm8/?=
 =?iso-8859-1?Q?VITmgm7vmaHis/PWXlkBiP0e2b3Wba8uyEn448d1ixm7lkULx9Mok7MQbE?=
 =?iso-8859-1?Q?g6HbHq4AXh4f1aLJAZnm/h36HI73OgYEIBiNRNAWqqKuba5l8TOi70gAYH?=
 =?iso-8859-1?Q?vU39KW1ttcHfpPHzSJAPAF0IHXpyk73JFP+qlm9058aI5OWQppDk8P67Pu?=
 =?iso-8859-1?Q?V8sLiuwQpXBYW9BaDhbfCDaL4doKKHxOHFU1ppa7QmcVgplbYxGwz1Pzyb?=
 =?iso-8859-1?Q?EO/tDyV/qg2s/UhP0NOytlA7xyd/1o8D/TMwzGksJEihGcUp1ydQy5kEm/?=
 =?iso-8859-1?Q?G2xGop+l+pKVnyEq3nEgyR6zYr/SWRfwaxEUJtdVAB5srT6rfinxwlcmj9?=
 =?iso-8859-1?Q?argQ9PsfPJocaCBGutYJwFo+hLn8m3TpwCr5JhCtA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6231.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?lg/VRaGfA+M8s1LuugdW9ZruEGMIiz8FBXG7XWaK7EtHfTIkqGuRjyy659?=
 =?iso-8859-1?Q?j+FPEV1oMwt5SUarVePbVpayn93++ge8sKYEHKO96xgXnGeV3QHdnxJu8Q?=
 =?iso-8859-1?Q?hSpFECYn0CVz/cR7kdKKCIKOa0kBXtcQpRtmA2ks8SrCoQNe2/jTZCHUCD?=
 =?iso-8859-1?Q?Za5csE2tmFcTq2EI32HqLcD7l5w56yN7AceNAfG7c+3Dug0lnnwi3QKlbX?=
 =?iso-8859-1?Q?Ae2/KimCeqYZBi4ufvV6nVhD7VokqrCLTDB19aQtlTeq6R1oXI3JIHjJ4X?=
 =?iso-8859-1?Q?kV8nQp4LDY0yvs76z9W1ZhNxmtucsZ5dlOU+/hj9mpVmWZGfkFJODjBizA?=
 =?iso-8859-1?Q?ZfESTz2UG9tG3/GdrPCpfAuXCnMF7ozguaylGfISUpa3GjNSD+u4PABwMM?=
 =?iso-8859-1?Q?BckSFposNGmzfnLN4eaBvAOiwzPjuKCmHDYR5gkyeA/q0EcmADDjRfcGeR?=
 =?iso-8859-1?Q?0vjwnQCCKYxI14S9yPWkE+CTspgxt0eRRx8Sp37C7h6i2VJkynEyYhuwwf?=
 =?iso-8859-1?Q?2fEm3KTb1r73N94bYczHmZgHhDrqO1zBBpTwKxUvRBEUgM2pQIOUv2wTzO?=
 =?iso-8859-1?Q?Q+4GWhOLp26XOcwIeOxvSHkUxbFaWzlOkMg4BScPE35gA7X6/F7p+lU0F7?=
 =?iso-8859-1?Q?HK6rMPPK666pt7sZxixErM0D7kN4/c4kr4h6b49o/BVqkU2YeKQ75uqXHt?=
 =?iso-8859-1?Q?XHjO1go35BXNZtuKBzPNTg2MhidwhTEIMpNjeHGAUqVmBtSc1Kx3LFr4sf?=
 =?iso-8859-1?Q?M326/2sW/Qjp7N71xgdQS8e1bIOY0SrL0h4MX8+M6mEjifnQo7hkdZDBY1?=
 =?iso-8859-1?Q?Av3PSfS3N8jS3yBAnN3NIGVYq6bksfCqXmBPHSypEhIxna5BSbfEEKJKMv?=
 =?iso-8859-1?Q?6tLOXjfBrvjcxTYx/Pzks/+hKvH6hPD+E8kyeIm4IQEY7JtQV7G9leO270?=
 =?iso-8859-1?Q?+4EDZbMdLOi9y/LpDX4MPp5PFcuOsPqr3yzN3M0tCc7x4DSLd/iPNbGtHr?=
 =?iso-8859-1?Q?Yxsk91ZCfDvMlpAZb4aV5x8DOBgkq/ijV5wbdYJC4l0gCKh0OKRaTki0uj?=
 =?iso-8859-1?Q?zn9F3nfoUCGjQ/H212+D1ZFTC/uJOfNUZBiSFNnxCJbEVFavvBIpMjsVuK?=
 =?iso-8859-1?Q?mcrz2ZjcH9vevZ3jgNOZuZ1QYxRO0hJFIzfPMp1+S5RSTm+bgGXW35nO+j?=
 =?iso-8859-1?Q?9LD0tViEmg3xbZTTqN/RYbMkjsDxaCTFxJD1z1HfowV/pntrUMh45bky8M?=
 =?iso-8859-1?Q?NN3xGEXw+/iSSwp5KBoWoxfnFRPUS84W1QAx3pSh6d/0vJV9zryCKJjO60?=
 =?iso-8859-1?Q?FBnnotn0T48GhpbET7A8vtsfHAmf+98TVmL6yKVlYv5NgGayjxcjtolmBT?=
 =?iso-8859-1?Q?YNCC8wqP2p2zHqC7HcRNAGZsxPb0MWIqynVeIeVWL7nA9YboubPAuxHbzV?=
 =?iso-8859-1?Q?vRqq+62RhKcuTaqj4ce9uEP3YRgiHa/Xu7Z3pYQ0oSNxy4H742lTGZzPlq?=
 =?iso-8859-1?Q?fQmNdrmYownzmgzGTq/f/AWPSJ7pbKWqkLAq9vOfigNbuae2f8Xu5qqMYH?=
 =?iso-8859-1?Q?iu4Ud5Ti/PjTbX0K1nKLhz/HgmWcuhQKueTMvKdsUT+EinXplc//KYMfQp?=
 =?iso-8859-1?Q?K6OikfvYHCj8GtfdVQSpud9QcaoMz4D61qfN7892fA6oioHo8WUOfJf4DA?=
 =?iso-8859-1?Q?AtcHRgIy538wm5Orbik=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ce0ef186-afaf-445e-dca6-08dc758a9299
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6231.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 09:28:40.7286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6h3W1TeUqMBkRCzdqt9FQXmqhyuZrk42gahhzZ5H95Ui/uEc0q0YMVOL45Mcu39j/xVE8C4HA4izEW6ITKvFBVAW2ORSniHlJWqfasvvI2U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8195
X-OriginatorOrg: intel.com

On 2024-05-15 at 15:23:08 -0700, Tony Luck wrote:
>This series based on top of Linus upstream commit 33e02dc69afb ("Merge
>tag 'sound-6.10-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound")
>
>The Sub-NUMA cluster feature on some Intel processors partitions the CPUs
>that share an L3 cache into two or more sets. This plays havoc with the
>Resource Director Technology (RDT) monitoring features.  Prior to this
>patch Intel has advised that SNC and RDT are incompatible.
>
>Some of these CPUs support an MSR that can partition the RMID counters
>in the same way. This allows monitoring features to be used. Legacy
>monitoring files provide the sum of counters from each SNC node for
>backwards compatibility. Additional  files per SNC node provide details
>per node.
>
>Cache and memory bandwidth allocation features continue to operate at
>the scope of the L3 cache.
>
>Signed-off-by: Tony Luck <tony.luck@intel.com>
>
>---
>Changes since v17: https://lore.kernel.org/all/20240503203325.21512-1-tony.luck@intel.com/
>
>Reinette: This is still using the per-domain display_id field as
>discussed. Would a better name make the intent clearer?
>
>Patch 7 in previous version included virtually all of the new changes.
>But that meant it was doing a lot of thinngs in a single patch
>(including reverting a dozen lines from patch 6!)
>
>So this series breaks patch 7 into nine pieces (0007..0015) for
>better documentation in commit comments of the changes, and hopefully
>easier review.
>
>Patches 0001 ... 0005:  Unchanged
>Patch 0006:             Dropped change that was reverted in v17.0007
>
>Next nine are the split of the original patch v17.0007
>Patch 0007:             Added bigger commit comment describing where
>                        this part of the series is heading and why.
>Patch 0008:             Added justification for new display_id field in struct rdt_mon_domain
>Patch 0009:             Split out a helper from mkdir_mondata_subdir()
>                        so real changes in patch 0011 are easier to see.
>Patch 0010:             Comment stealing a bit from union mon_data_bits.evtid
>Patch 0011:             Save display_id instead of a random d->id in
>                        meta data for monitor files that must sum SNC nodes
>                        Don't call mon_event_read() to initialize "sum" files
>Patch 0012:             Set domid for "sum" files to the display id, not
>			to whatever SNC domain ID is in use here. Don't
>			call mon_event_read() for "sum" files.
>Patch 0013:             No change (apart from being split out from old patch 7)
>Patch 0014:             Because of change in patch 0011 to save the
>                        display_id can no longer look up a domain using
>                        rdt_find_domain(). Instead search r->mon_domains
>                        for a match with d->display_id or d->hdr.id
>                        Drop extra arg to ___mon_event_count() also
>                        the "tmp" variable in __mon_event_count()
>Patch 0015:             Put #include <linux/cacheinfo.h> in alphabetical order
>			When SNC is disabled, keep the old check that
>			the current CPU is in the domain being read.
>			For the SNC case add comment about reading
>			monitor values from any CPU in the same L3 domain.
>
>Patch 0016:             Took alternate SNC detection algorithm from:
>                        https://lore.kernel.org/all/20240327200352.236835-11-tony.luck@intel.com/
>                        as it is simpler. But merged in the sanity
>                        checks that make sense.
>			Converted the X86_MATCH*() usage to new model
>			that supports Intel families other than "6".
>Patch 0017:             No change
>
>
>Tony Luck (17):
>  x86/resctrl: Prepare for new domain scope
>  x86/resctrl: Prepare to split rdt_domain structure
>  x86/resctrl: Prepare for different scope for control/monitor
>    operations
>  x86/resctrl: Split the rdt_domain and rdt_hw_domain structures
>  x86/resctrl: Add node-scope to the options for feature scope
>  x86/resctrl: Introduce snc_nodes_per_l3_cache
>  x86/resctrl: Prepare for new Sub-NUMA (SNC) cluster monitor files
>  x86/resctrl: Add and initialize display_id field to struct
>    rdt_mon_domain
>  x86/resctrl: Add new fields to struct rmid_read for summation of
>    domains
>  x86/resctrl: Refactor mkdir_mondata_subdir() with a helper function
>  x86/resctrl: Allocate a new bit in union mon_data_bits
>  x86/resctrl: Create Sub-NUMA (SNC) monitor files
>  x86/resctrl: Handle removing directories in Sub-NUMA (SNC) mode
>  x86/resctrl: Sum monitor data acrss Sub-NUMA (SNC) nodes when needed
>  x86/resctrl: Fix RMID reading sanity check for Sub-NUMA (SNC) mode
>  x86/resctrl: Sub NUMA Cluster detection and enable
>  x86/resctrl: Update documentation with Sub-NUMA cluster changes
>
> Documentation/arch/x86/resctrl.rst        |  17 +
> include/linux/resctrl.h                   |  89 +++--
> arch/x86/include/asm/msr-index.h          |   1 +
> arch/x86/kernel/cpu/resctrl/internal.h    |  78 ++--
> arch/x86/kernel/cpu/resctrl/core.c        | 422 ++++++++++++++++++----
> arch/x86/kernel/cpu/resctrl/ctrlmondata.c |  70 ++--
> arch/x86/kernel/cpu/resctrl/monitor.c     | 106 ++++--
> arch/x86/kernel/cpu/resctrl/pseudo_lock.c |  26 +-
> arch/x86/kernel/cpu/resctrl/rdtgroup.c    | 267 +++++++++-----
> 9 files changed, 779 insertions(+), 297 deletions(-)
>
>
>base-commit: 33e02dc69afbd8f1b85a51d74d72f139ba4ca623
>-- 
>2.44.0
>

Tested-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>

-- 
Kind regards
Maciej Wieczór-Retman

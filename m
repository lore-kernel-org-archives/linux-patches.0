Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078873F54AA
	for <patches@lists.linux.dev>; Fri,  4 Sep 2026 04:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788497514; cv=fail; b=afIUIZD5n7T66bioVJ5MIGqbTz0OYdKMnpw5b8Ufki2Gt+3UP1biaihWqsJvO+WFH0svZr6mSOfvxUHVfXqNUxxA5z4ZcuSLcOsfVieRwcLlv+Ra69fZypJbcn4LG+Id+4pHhJmPG0uNJDxNBOgfLx/v+WPW1WvxgZswM98VITc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788497514; c=relaxed/simple;
	bh=7+qvUU/C/Fwn8nV1TTALxEhzGC6ZTrxXzKUxrhnWt1Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WCd+YZ9Q2vISEnzO495dyQODSHeo8unM+ewNv2YUNlaLwI5LDX3MveK3XsAGmszz6Zc7vZsPi5lwxLd8bAdwrsXAPyCFJbeAa+4jQkJ/K2iKnNBXgetJfApuX5krOisnrJtlvJuGg2bcg4YnzJ+2iGmQsGp5SSkC0sQHzwLGL0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TNYeXfnL; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TNYeXfnL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788497512; x=1820033512;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7+qvUU/C/Fwn8nV1TTALxEhzGC6ZTrxXzKUxrhnWt1Q=;
  b=TNYeXfnLuk0G8dS4OmnG5Qj0zExXwXIl3EsUjM4PS7PstghfNGyGcoMx
   nfFBUi6tCJFHhtjlhbC3ZSBsDkxRBNIstdoND4TP66mE6T1wj5S+rmdMz
   qeTxP9fDNfSHE+R+njIVfiyKsaTXVmvv99HDyRLniAMmNJBX2eHap6lxQ
   5k/FT2iNZ2A8K7CG3laxi8kvnYijX428GnCvIaOPvgdy/a73KnfwE4HgL
   CIoc/EGduVc+hYrAgfkLDcKFvqm2Ihik5p+Sc/HmonU0NoGEAdkjKlYYU
   FYR4rFmYah7yuMVpoHE+6MvT0tYpTXhRwBLKvHr6KGDIp6N4Uzw00x4P4
   Q==;
X-CSE-ConnectionGUID: e4eJGKnlQBW84kpkfeJxVg==
X-CSE-MsgGUID: upGnasedS4259+hhYl1qHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="88920889"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="88920889"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 21:51:51 -0700
X-CSE-ConnectionGUID: A7Z2QouiTV6vmbLfVHTa2w==
X-CSE-MsgGUID: V4AqiVTPTZmGHjGp5ksjMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="271879162"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 21:51:51 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 3 Sep 2026 21:51:50 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 3 Sep 2026 21:51:50 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.22) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 3 Sep 2026 21:51:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VDid2sH6+sbN09SFub2IcdTWyqgbGyDK6XNaJOXXwo0rD+0iIeLIoq+3H1mz/7ilrBFE4472yKB+iLWuqrfc1UP492VxLgvBzbAGiyCoTcfcIaQ+0P0YgF6K0BSjbSQuoYfcERE5kq8ha6ghvX6RMwVIma80HyorDt14zb+YlScvquja424dBuROlhTPOODKGZ9cFLgB7vK+oFJiHV+Wq+ejTcgTKvwtlMcPMuTVrkz/o55COWWdIf7esSZUAd4BmyvuaVp1zqt1F3DEybTleL3GdFAq8waAARCYPLHOSqfQFWdt479jDE5SvTeyolxLqgQz0pfWNAzvLbbR4OgaPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vx53ucahdOoNTMrPntQBTB8+qZLLt2ubJn7q+Uo5WUY=;
 b=m30BtTgm60pbMuzG7WTuoGRJA4io92TrpGqARcF25OGPOCYAc7rmE8JjlKFJ7oAcqpVgmxTGAtFVb9b5ja1A7yscB1552AIKhEjUnTjmdcyWSTDvZYZdLD2gOFTNouqUfWqiHwvsdqIHzZXXS5b2Tg8n+aLvVIq0vRM0NjzkBZ+9oG7iGiNrH9KNT2FoJ4RNOVruOgq7Mh9IYSbpVGIedOvevm5Z2bUP9/CLmqhA6mxvNNfMnS3c8DXPFC3TC4nkM5zMxZ3kMVMz9iYSzpk7Wil63QzBGM1R9A1CBQQ3+AoyOpWkfzEK2cSKcyQXK3l/rO9a7lAK2DXqrV8IX+yrxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 CH3PR11MB8703.namprd11.prod.outlook.com (2603:10b6:610:1cd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 04:51:48 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 04:51:48 +0000
Date: Fri, 4 Sep 2026 12:38:18 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <tony.luck@intel.com>, <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <babu.moger@amd.com>, <bp@alien8.de>,
	<tglx@linutronix.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <fustini@kernel.org>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH 4/5] fs/resctrl: Drop unnecessary is_mba_linear() helper
Message-ID: <appLOliNv9E6-Ou6@fengwei-dev>
References: <cover.1788452481.git.reinette.chatre@intel.com>
 <b615f948cab09677813ae54e316e10ca96acccf3.1788452481.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b615f948cab09677813ae54e316e10ca96acccf3.1788452481.git.reinette.chatre@intel.com>
X-ClientProxiedBy: SG2PR01CA0182.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::20) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|CH3PR11MB8703:EE_
X-MS-Office365-Filtering-Correlation-Id: bb839045-f2ec-449b-cab2-08df0a403a7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|23010399003|366016|376014|1800799024|10067099003|11063799006|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 5C/r6f3Eb7ARJk7mN+DxfbqF/PDlgCpFRdxowVIxjhMWF6gc3Rd7zg5ICQNAe4TthZ4YzJplq2sKDUl2VOL3iHGPt/Vg1uBB7rurzt1lnCCsnzumP+AkGzzifgY/2HmN6xitkPKCwnB7c3aUA8j/ZqsngCjlmkAbFBUUH6Tt74snecvfWiAtQUQ1AikdnIPjneuWmyIot/tWiAhfqRk6xpLkgezYoG4WR3iJ6jPvAEc3Axgc8wfLi79ZyEOoao6kjjU6WJmTWvFIvTAoA55Tn1Ah0tecUnYCriTrp6VmnEfdGQR2b3gPGsyRprE0e0Qq9W+vF/nD0WwjObzI0OskdGZbDj6+V0w9aTe38wKheChsGKCf7yOMfkGORBiR1E/2wWL/oouADOlLOjInEH00zUoKHTRPbS0XKjP7dLCwqlTZCWtCWWkUlO+83rtEKaA0DPV3PLAxr3WX0JN9KGtWWLiigXHWitDxLRO1hvarwxbuuyLyq4Shfd7jNvZROxSxTexbJGPFSAby0G0bLpNZr0DTsTxHNl5wnf32LcCsP7NFRUymIg1REOtFpwj8Nzi/vIsukcXx9lqlPCRbMYPucrv8regfZkSYoS+/FnXhyH/8AcEvdOpDLriBaxDqLOr6xI9Qu7Xe/nmZzk9yz7uRdCYg303jL3kz6sGnrfUXvG0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(366016)(376014)(1800799024)(10067099003)(11063799006)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?REKMtJuIpHecq3FVFnqYqKc9Db2aAkJWf/046RibMBo5dyNTzeAp+z5lZ1iR?=
 =?us-ascii?Q?m5IvU09jpjm6pkR8yIddL2H/NHwxkDINSoosPiHAzT6+q38DpgtijMgG6u2R?=
 =?us-ascii?Q?AMDITJGuCMpdSyFz61l1a6763T8JPv/xEUpUGa56hXn+BZjLMLD98v8UiqSc?=
 =?us-ascii?Q?Y2KoyyVP95qUK5X9Q29grVw0F/auXvyBlxTrWCcx/nzqrrdScUO/FziRpSg/?=
 =?us-ascii?Q?xXIixmSdNPYL8cletlWbyvHXf1aLQV3tI8ymIWBhiso+n/ntqZ0hYrrSuDq4?=
 =?us-ascii?Q?WSaRv81faqO271k8iowU5l3Ypo1+VPt0y5Ox2vwAFJozyruz6Rb6kX0jK+YE?=
 =?us-ascii?Q?zHAuYlMdcBnfvpHKyxghgku5/dVshApRmQjjiwDOegyjlbZUvaiWxOCz1lgW?=
 =?us-ascii?Q?nz//4ZatEqgIFFaO5ifV1XTnaKuGrHxKSEIRQN3jswwuc3dpEEUKhNSNadHB?=
 =?us-ascii?Q?PpJRye9ftKxr7hOgjtZ/2CzukWCqebpRVdZS9qHXUdBU0iCJpw/pO5KwUh58?=
 =?us-ascii?Q?3irHTg+UooGBsZw+fmFOiG11j6tQsqE9M64FqAt0kMotNpxwqqMuK7O8GCXR?=
 =?us-ascii?Q?0h4ql1fEM7gfULvTyZTF7pcOTGkAfGlgJ9c590U/yq0j+qmEET6li4eSueNl?=
 =?us-ascii?Q?ryqh0Y+sbgbTOHjlAhpDX6Gx2iGLisfJT25Mq3+94FyKEDeiEavLTcynHcKa?=
 =?us-ascii?Q?X88yCS2N8GeC4fYskrRaXc+oshiJyMpsUOpXhv83t06quZ5/gm4D3Bh/8KQw?=
 =?us-ascii?Q?Jsshwj5DdqtwcD2IOxNAqATGX984ClpHKYoeqqHTtb0945Pg2IDpctU59kkY?=
 =?us-ascii?Q?VBtgtHWTo0snLNM8mrCy2VVaWY8YvvjoLEvGHsA8ZFDY4gJ3FNpv8jT4hVz7?=
 =?us-ascii?Q?dg1+S7VlBurwMWX4VAOVlK3yzZ1v/68QWSqovy0TsNC+gAsIcjg2HB4Mg/P5?=
 =?us-ascii?Q?WPZolznCGryGyBlU59jFJS4B/zJJjeSwXyq3Dr4hvEQ6TO2MKGNmqmatPL1u?=
 =?us-ascii?Q?/xM75WSVTKUSVUNjV4d0o3Uvz/Ax0CcyO1XpvK50/HlqCfyxg0wWxPbFJ1Np?=
 =?us-ascii?Q?5lnfu/yJIV2Zt3RwpaEmVC+EJa3Esf9ZNLdU9k5mWFI88BvywbXJdsAwPMsW?=
 =?us-ascii?Q?A21JND+p8v71jDWaGWFeBxfwRcFv1XhPilk12XR7zlkx+2s42jewgxuxRYfV?=
 =?us-ascii?Q?ubKhRt2tLAp5DRHUCGi2y9I3UsBvok1iGyNfoZPafUE1thWTP5ZB/0IS/Wpo?=
 =?us-ascii?Q?uvKwQFtdQC7Bi5olsdJnOyXzjESCPwqf0qCmdbgMnAWAAeDwUBGVE9hp+Axh?=
 =?us-ascii?Q?vx76Tq1cDERV3XeuWUhJW7+x6vUcMe54a+r4wkqBBSL7keftLYVbE9wlK8Wn?=
 =?us-ascii?Q?E18CTb06Q6GhcSuiiaIwbLKfuEhmJHjhDXINCsvQRKkKXY+m/gnxaJK0d8pC?=
 =?us-ascii?Q?OURQcGBrPrJKFfCiatU9wIT5e9TRn9nwFsYoutmlG91DaM3B3b0YmvPrMxqt?=
 =?us-ascii?Q?IEnzL7NizOBsSr0Y/q5CpreIr1z8NEPb7ZJEME5jASDcodAAloLIZAdUU190?=
 =?us-ascii?Q?6LAdprV8iFeonJow1lwK+HrObVTXYH3vRzj2D7ItjqyXGlEpJaqa91HJGOtD?=
 =?us-ascii?Q?HhIjhQ68wLq/Ze0G/MP8tWu7H931J5+FiUipC0P3JcBu4Yo7vUeCD6kXJ3ip?=
 =?us-ascii?Q?wAm6206OUCGp/ERc+EPv8i5JrKO1NiBWeoiZOhgttuAcJv4gtwiq6haRgzMX?=
 =?us-ascii?Q?wjdayXLxmA=3D=3D?=
X-Exchange-RoutingPolicyChecked: EoCEY/HApV21A78hUx2Jc4jYFRMeReCgtTWs/u6zAmXnPwTpXl4+Mc9rf8HLmO28bOi1h3AtoGQMIt2ENB4NMcbc+1cUE7SFdl2i7a1bda36k8ogBr7oMe3qE5k6P9RXoQ9V92soqUrlNLcXwH7TZhBIa1XG1LNPMgiy5GdjkxiHdgRkmcg3Xzxkhcyskcc5ttn+zP4BcBF4RuTaAbtHIVQR7/sOZflA/9Ygha9i/RFX3yrlZ2sOnNOw35wLfD37J0l3R2py/DVKE5M10Gg232PkDU9KITPB8wq5NV8sJAgAItEHVJirqp139y9Iryhh87q7Bi1iccyqes5lmpQ/Ag==
X-MS-Exchange-CrossTenant-Network-Message-Id: bb839045-f2ec-449b-cab2-08df0a403a7e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 04:51:48.7202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MKt9TLCIEWPa6qrfJ8MieecAz3n+qxahc5eD+9LPc6oJTEj+xGUdZtp2Y6CFS4ObvYLoQB8jGVLuMCXewaRX6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8703
X-OriginatorOrg: intel.com

On Thu, Sep 03, 2026 at 09:57:06AM -0700, Reinette Chatre wrote:
> is_mba_linear() assumes it operates on the MBA resource and returns whether
> the resource is linear. There is only one caller that separately makes the
> same assumption.
> 
> Avoid duplicating the resource assumptions and let the only caller access
> the needed property directly.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---

Reviewed-by: Chen Yu <yu.c.chen@intel.com>

thanks,
Chenyu

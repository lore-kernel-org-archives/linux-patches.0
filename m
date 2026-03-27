Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231A2332604
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774655048; cv=fail; b=METmaJ5vuZO5gaFnFKl4nsVoSY7hxIMVUv6Q5WYVnLVJ6IMiJCBtjFPt2PyERpm8onVU75kih2+0PWv7T0Vp1MbdtTYBZTmaSZlZPFGQ9mdXnSAI0Sg06JIgmwt54pQV3PdTG/nXNy3hHRp8tDFw+Ckg4jbGS273hqz6GXjlFNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774655048; c=relaxed/simple;
	bh=RStWxUHM6dWLH7y6EXAD8OniIZ4TG/6+rX9zjwS3Pvk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=q8YEUESVWGCzx+F9a04wmQxM3nw2vjtq1xpyW9IJzqwikLt5Me4fcWcG5rdjM2vKaaQqdy8nKM199D5pkE8iTc5ly4phHDb4Uix912a0PfTykXCM3JCEbSp4sEk9hgEvgYtwpnou13P7Mgxdb7WrQMS1QJKQr1a3WJcp2pdSyTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gqIRuaHz; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gqIRuaHz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774655047; x=1806191047;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RStWxUHM6dWLH7y6EXAD8OniIZ4TG/6+rX9zjwS3Pvk=;
  b=gqIRuaHzr2sLZz58Cm3quY7Lft35hegK2g3muYV0uYbSYMxBlR8WPD07
   9qBQPJQPbRYqHC3ausaeihrvR94UPKcuVI3fSrcMf8f5AgtVW/EFdxMIe
   fANVQNO8WjyOontXCVnCtZvaKMih0alwv0+Y/VqxBB6XRG9q+sozgHtmt
   oqMX88oPVUr3uHto5z2EK0emBIx38bovEbZyisvHrIyrUN2IkawxKXIzp
   usWZ84hwB5h+z9E9bUEFHvzk8+gIZnSq3LoNH14vCbWwUZYG/zvSLmFeB
   SKq9nvvEL6Dm3VmocUboUD47iSPr2UuGh2o5VIs5a361EVWFuF/ejQUx9
   w==;
X-CSE-ConnectionGUID: kynB8OtfROqsMEVEoVRi4w==
X-CSE-MsgGUID: +IpriupdTrOhUrjh/bMKPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="86353367"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="86353367"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:44:07 -0700
X-CSE-ConnectionGUID: KN6GePwJQWqNmWaVDHPYcQ==
X-CSE-MsgGUID: VLb5LKfwSm6gw1hiz2hC9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="263405215"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:44:07 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:44:06 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 16:44:06 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.61) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:43:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LAQ8HKhYmPwsZIMAT1KmfYdtBWIsgoQ1sQ7JAJ+OSYG5PYo5PX/kcahGtHeeUlZNsSi/JqQc2AAV3FuvJOtdYKm6XfkZ7lxx7meOzCn4hwy0m3uUJQ4copU1B8vF6hkd35Xkc8Vu7pBP/x2adVLq8tl2wgJzE6RWHcRiyskpAJmgxWAvo9rg3+nwabyk30PiqSuo+wh1YIaidRN6tpijIkw2+1b3wsCtyjyIKr512wsgZh4pzG/F5vvOVhmmBViHFKKYa+8MJomN//Hw7E9ffMwTLz7sJiXecTgmQYcVO/ymBHX8rP8Xt/amAz6gp3TDDqqB9pZHJMAXmtetWLNMuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BP3NI1gCHyjz4towZjiwvuf7pfUrl3dXg3QniQY2QyY=;
 b=BgKKuxq4XwopbvY4Q6VONk/4g6rsK/Txhl0PTB6g3trZSHpGJXv47gk3zU62aRzQkI3FjEeG9YhDlcMyFg1N6k2qpVeS1FaHxpPBX99kFME8OBqycAyRqelV5ZesS/ul3T8Y/0jiyjr+k4vzD6i3gqP52xYE5Fgl7q31PSb/JIIwQSmRE1kvbG7iYvCGStG5ZyC8yVjS+2DDy/7EmWTm/D1952u5LJBjoEaEwucxw4qIQ3v0k5czQumJYmVN8Q7MLy6IpWxR+sxyzjRtlE5WsQoNuTjULx/emBFdTOxRNbVdGk+4Ym1TW0FfoT4FXs4JpE/Yj5T9FnxO8rRq/sjtgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA1PR11MB8254.namprd11.prod.outlook.com (2603:10b6:806:251::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 23:43:53 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026%7]) with mapi id 15.20.9745.019; Fri, 27 Mar 2026
 23:43:53 +0000
Date: Fri, 27 Mar 2026 16:43:50 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <dave.jiang@intel.com>, <patches@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <Smita.KoralahalliChannabasappa@amd.com>,
	<stable@vger.kernel.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH 1/9] cxl/region: Fix use-after-free from auto assembly
 failure
Message-ID: <accWNqe9uABSGKUH@aschofie-mobl2.lan>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-2-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-2-dan.j.williams@intel.com>
X-ClientProxiedBy: SJ0PR13CA0088.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::33) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA1PR11MB8254:EE_
X-MS-Office365-Filtering-Correlation-Id: c8faa1fb-29b8-4831-7f66-08de8c5ab46f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: CGQkNH5amuHe6NyuPRWomQC2l7+bWhyAhjcNPnYT3B8cfibgnVsWhKZnWl3hddEdmBhTHNJ7zBPRA22OLAFzFV7BadNsBBpc9G2PprxU/W02NHQIUZ4OW37MgcUr0sRF48s6NmiX6EF5S7AvGziVgWcToC2SaJSo7fhaD8Nwnvul9KddFkIS3QJPMG053rlKfTCW94349TVQPWB8vd6k0EYeLPeQlIAF93+Fg9+cKQSEBE0gPcoQTZGm9wQpofDkvPoD360OXKjNsf7IxI5i1Cg5LvCxOk4t2HPLl142qG5hENVA61nww10QlJb67eXJ897XBjMRKaI8k43L02QURrEz3Xcn7/Vuj5JFi4bJ0Bml2hiFTHYOjh3InuGrOEWk5Y+F/C56SxMwM4gad3JaX0JRIuhuOBRdv9PkyTfe/oSQyEsIJPxy+W5kOfdlYcwq4WygqdxjowwCZnTU3wOANmlaFr1pwqYNOTIR80x5R1cfkwX5LQavm5jupWxwCegQE3SeAmmQkub+MiqpYt3eZ/ICmVn/dmaxoM4h5p0Bdu6pfTrnqCzEN5NneyJK9wfDqKlZOw5C769rA7hdme3GkXzlP+DMdgsonsw7rVOJFf9FlT18pENaR6TMTmoLcG0qAPONLnDKFXED8IZd4HX01xJqdnF1BBTbq8jpTdeH+5LJD2wGJ2LSFJPcpJq2LGg0H07IF5TMD/Wo3PiXrLSKqAWpIQDFdHwpWjIMgBaIyDc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JrTzDEOuAgWfTvN/fAsQCkfbfdx3wjk9Xt4t2GiGUSFK9gXfVqZHgtN9CD0J?=
 =?us-ascii?Q?+thXlfhmTVEtzq03U0vk2rjEzLQjMusIPMRrh53gIOxVfB4Rs7uwDZjylgTh?=
 =?us-ascii?Q?bxsxsLEnkHZC7wyZPhoPc1Ge1aDJprRsmYmu2XrnOExmMBlfY7TS0YqZvJyd?=
 =?us-ascii?Q?JKDRRI/n+SMcL8QHjBEv1J0QNt/lSwlXFJ12c9Fy5bv5g1CB2Ojvb3llOFMv?=
 =?us-ascii?Q?BeEZm961F8SLWUMqAehzYagH3U7DFUcYVWXrL/Vw3WspCsyjumU0SS2vXBRq?=
 =?us-ascii?Q?GcPTBC52YjPHgfXb8inlZFT73ppxl5XEMBrnqlCqa8MD/IcDOFle110rV423?=
 =?us-ascii?Q?XVs1tkc+qz9EfjaSb2SAbwFNB+gqqAbI7ouaj3yWZBc6LLXrlk+F2ck8d/Wa?=
 =?us-ascii?Q?5cQcUDLzSzxitugsUIuWApMEqPTh4PqCFiuSkF7Dv8hgYLM1u/EadNYObyI5?=
 =?us-ascii?Q?489roy5BBBzCItQ5hQxE3hBJoqW75hEVmSOfOqYwhx9fS2mXuMtDxf6N7cp/?=
 =?us-ascii?Q?1u6twx5O9zi+WVvmwtZGWvnuXY7VI+ghTC1RFvEGeh3jEziRxZ+FZQlpKjeK?=
 =?us-ascii?Q?8bnbZBImgBLqtxazqzlXQdt8I4oKbp25HpwLLKFwsGIn7zldBXT0Tad9R84/?=
 =?us-ascii?Q?eD1iOC5k6dZQoUMsVffm9vQaCOenpeLGsbGNnp78hHD0pKt+IEuKYnIoQchd?=
 =?us-ascii?Q?rsw9fV9EiHZHf6QdenxyO3Xi6K5Dh7y8isFWOS+yVNQhoBVSAMTdJsAFJgfd?=
 =?us-ascii?Q?hqhxnzmpZpDrMArr59jDxNSKnYOuzCFIgwmeQKQl7uUgoA4TjrUtKgiVUofi?=
 =?us-ascii?Q?NifTVMTvweaCXDDHaUYfB293eKuG/WOJ61YhmOpajkkdA9l2zl5ZzXavj95G?=
 =?us-ascii?Q?rIcRUbuSvj7hjcE0scV8AcqTCNZCNtG5uNABH0q7QqgipuIrhTcvoOuXz5dG?=
 =?us-ascii?Q?xjWfUAFJRk08o1YQ5xXn+Zihy0Yj2lIKEQeKrEr0cuCW8FuXePNJ1njhPB+H?=
 =?us-ascii?Q?3p1H43nM+Lb4f4gytMpLBgL/pbydFVMqnE+KMbylpymG0b9Iqjoy8gDfC/lV?=
 =?us-ascii?Q?Q3bsY1K/N7G9WBPTVcuRCw7XuKAhgW+1CmUJeY+m8MRg0gloGDJMSgzUE84L?=
 =?us-ascii?Q?2qmNkiOnCes8gYeOgqpo6FgGCNVoeTwmZI1eDHlmSJV7yKi7pqQPw5+w7tjM?=
 =?us-ascii?Q?CrUhycnKNkgoV29wM9PbXTN1V+fXzD/tL4FPi7Qfdvu4J9dYqbtUhdE/PPfc?=
 =?us-ascii?Q?cnZJY12wOZ1R/7Vr3ybBk1N+hQ41CfKeFo8hcPxGGVhl3RjsHD4WP+aSXDZi?=
 =?us-ascii?Q?eDpKFdMLwRs3lYSxlovMw37ARmLmn5xOFUYGdOXKlNMUMCtL6ri2wzPo7FSJ?=
 =?us-ascii?Q?sSvuYF/J7cgnmOUPYvisXAkpN3DcZBHX+OaY2PF6dwxtQl4/4VcGGMaPII7F?=
 =?us-ascii?Q?nlu5h5NUT9IcsRYOGb6GwvWUl7RjRTEpLEpcgqVQf3fIeERSHdrvrGhnDqGe?=
 =?us-ascii?Q?WsJ9SCKdWlccE17y+rF97dEVXvvQ4gFD55ScrvUzmSdf/iC8B2uAshOS3ntc?=
 =?us-ascii?Q?ec9YBZTO6QhR4l5NLEEIiZiyFrySiOAtd+X5K6X6/kBBCxDFVIlpKlj8ebmP?=
 =?us-ascii?Q?XC1NGRo3huqYQpzJw/q6+v36KGoSyeLwyLa/cz4QdowLW0z5zoV8czlZC3dF?=
 =?us-ascii?Q?1alrG/bx2Vm52f5BAZqjOOsvGF4Z5gws1KbuIbWHOarl4VA8k7ZWi9Zxw1g2?=
 =?us-ascii?Q?PIbJYo17APe2NXuCLOJod08As2CpGxg=3D?=
X-Exchange-RoutingPolicyChecked: VH3+h68Wme3BXdRNS/BlBUB9IOSpwzjkweZdQVFGqLcuY8iUW3IXaVY+VwDZCMv0og2N6MaW338bNU+AMJKqnDr5UQ7ZSmoBvlszEa5N92hMxLwkxlS3OcNXqDSfEo2rC5IJeRWlXSmSGBJwbx5pbB1YFCKEeXtLWYYM/7xJ8za7xvfo3oTeWK+yuJjHH/uAyBnOqffyLqwnp+XHe8aQphVLojtIuwSvI2dtyRPHXwOLikGfpWAmrEM9TZE+rNBJy24fxLcSPfNQlgVmDusnZ34hAyd+hEu5jh0cz/E2H5ZiyCJGytFvCqanCD3n0PQ1O2teuIB0zLEX24edpJZTdQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: c8faa1fb-29b8-4831-7f66-08de8c5ab46f
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 23:43:53.6321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /MhREm4k7WSyjB/7MBD+qvE6OZunEZNu+k0qu1/njNo7688iJbtnVYgdgKELkMitOBspkn7BBqmjGrHcA7Sa9lJ+N5Oz1dysi3vFb0iiTUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8254
X-OriginatorOrg: intel.com

On Thu, Mar 26, 2026 at 10:28:13PM -0700, Dan Williams wrote:
> The following crash signature results from region destruction while an
> endpoint decoder is staged, but not fully attached.
> 
> ---
>  BUG: KASAN: slab-use-after-free in __cxl_decoder_detach+0x724/0x830 [cxl_core]
>  Read of size 8 at addr ffff888265638840 by task modprobe/1287
> 
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0x68/0x90
>   print_report+0x170/0x4e2
>   kasan_report+0xc2/0x1a0
>   __cxl_decoder_detach+0x724/0x830 [cxl_core]
>   cxl_decoder_detach+0x6c/0x100 [cxl_core]
>   unregister_region+0x88/0x140 [cxl_core]
>   devres_release_all+0x172/0x230
> ---
> 
> The "staged" state is established by cxl_region_attach_auto() and finalized
> by cxl_region_attach_position(). When that is finalized a memdev removal
> event will destroy regions before endpoint decoders. However, in the
> interim the memdev removal will falsely assume that the endpoint decoder is
> unattached. Later, the eventual region removal finds the stale pointer to
> the now freed endpoint decoder.
> 
> Introduce CXL_DECODER_STATE_AUTO_STAGED and cxl_cancel_auto_attach() to
> cleanup this interim state.
> 
> Fixes: a32320b71f08 ("cxl/region: Add region autodiscovery")
> Cc: <stable@vger.kernel.org>
> Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Alison Schofield <alison.schofield@intel.com>



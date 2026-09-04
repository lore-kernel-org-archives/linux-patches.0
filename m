Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406433C8C52
	for <patches@lists.linux.dev>; Fri,  4 Sep 2026 03:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788493615; cv=fail; b=s5e6vdNCQcpYpVdr7F1i3h8oSKoo7ILwtK4jXjPgNvshk1HbSaC8iWN+Nb5NivRlPTvfIMX0ag0j2JAdS6KB6C0dZjOhqv/hG+VPkhCe7BZJ7VB3STIXVkpOElW1uG9Salk25gOvyOmInkapFjC6xlBvszfE+vjmejoN5iJXBPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788493615; c=relaxed/simple;
	bh=LqAxmo/uixcZ7yXmreC1kz3iGFfgNBcfk4NxNDoUS9s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fWmkcsYJh1QJNrmLbbTgG+ZsL2NjuxXO5ijCdCnKPOYkw3Uhwr/8B1qW4d8uvg3qIJel8upnclrvLYz8/2ScRJmT7JgT/2mnck6MZNlii4HQaC9PRJtJVG8aC33Dqey9YonN8hGT5DVtC2Nom0d/ktBiIdIm4FHJM24KOhW1kuc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AAeW3Tri; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AAeW3Tri"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788493613; x=1820029613;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=LqAxmo/uixcZ7yXmreC1kz3iGFfgNBcfk4NxNDoUS9s=;
  b=AAeW3TriT+9U0hbOhGaVXqCILtnapWPDX/rNm+LaDImUoRVWhg0S/aZQ
   tUXHWMnU3gs6poFmh9Nl/yalIVdbkNmBCjWiKw7ipcoB56Z6KiFpNnEyJ
   6+bKQLa2C965DV0I6mvA67aO98UTRG1vxJRoOEDopcZ3O0F14CUOmwjlK
   hCgEz0KKKtgjPcDg2KIW9kqznSQuinP0gIbaDTFozA5FiGRpCHQsOrYtA
   zGDYsc2tk4xd455uhiI2hqIBv6FBponyvAvGqifAGwlZi9yJrGeSZIMQJ
   8B9VzDzPpC6LtWGlwbHQXuBZQxCbpieneqIMuIBKKCFbejZB2tHlb0kBQ
   Q==;
X-CSE-ConnectionGUID: EJRZ8m/JSRaeCUi+n+WzPA==
X-CSE-MsgGUID: FXMsWG9yTzeitv1VlP6Hag==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="89113805"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="89113805"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 20:46:52 -0700
X-CSE-ConnectionGUID: CcKz5Ym4SrucWuuCcRjVyA==
X-CSE-MsgGUID: yrr27S/cSNydi7dMIgND3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="270446337"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 20:46:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 3 Sep 2026 20:46:52 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 3 Sep 2026 20:46:52 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.10) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 3 Sep 2026 20:46:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wzsmKBt8bC3IdeQ4AZ8UQaEzpsFDq9BRktPv+PewzKeFw7Ew2vtu7PG0Lf51HQi2Oj03x1t3Lb5CVxmDXPlWrfr6u6xFtrgQaybiMmIgYc7DwPc3s5R6eX4qYL55X8U8iX4Jj+7CCL8egIS3Gt5bQqtGyKFdSgxVm2oy8MUXCIIY0gFvM80rIZDmKeddN2FM5TVY2/AlLFF93+fwXcOhcLykBNkKWwx4eajn0fkloiPMClL76yHXS+MBbMLG7fVbgSVjI+EOQTkFgLBcw++o+Bxyyf52hG2zZvnn8ToxEqni9iwrRbh9ai3IURY15oYt2xwRkNIyFJNGVvtFVLrLIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xA1e6qz3cuLLsby1FhIfkVRtv5s3mmPl8HdTisuPyYY=;
 b=aMJidd0aSTJ2DcLjGhjDDwkD7BlQ707jyIsr1+SyyBPJREA315d7l2NhjYGO4WZaJFig/A5NkpYmTcl1gYC8rHgLIE0EFEAfIzUIdvv/+NUiVJ5iK2PjYuMEx4UHHXhX3oidkBom3Fi0jP1bsdAlrCWTUE0jQDSWeD7NAgfiMMXaeDSn/l1zknTsw9X5uzQ9RjLXJ+Lg6iGGCvFhvujpq16fNUND4LinZiICVX66uQAisBTdi0IiNeCKSc54ap+kDSZr34vvjm738owivjEHe0qJoSYDxwzrvMUfrd+yYYMfL/ser5oPCIML/JMtp2KNoOo9jubF7T2+CsYJGi0XAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 SA3PR11MB8023.namprd11.prod.outlook.com (2603:10b6:806:2ff::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 03:46:49 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 03:46:49 +0000
Date: Fri, 4 Sep 2026 11:33:20 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <tony.luck@intel.com>, <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <babu.moger@amd.com>, <bp@alien8.de>,
	<tglx@linutronix.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <fustini@kernel.org>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <chen.yu@linux.dev>
Subject: Re: [PATCH 1/5] fs/resctrl: Drop support for different bandwidth
 delay mappings
Message-ID: <apo8AKv5XVggDE3J@fengwei-dev>
References: <cover.1788452481.git.reinette.chatre@intel.com>
 <9d39435847fb26fa7b467c563cf8bc45c314b917.1788452481.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9d39435847fb26fa7b467c563cf8bc45c314b917.1788452481.git.reinette.chatre@intel.com>
X-ClientProxiedBy: TP0P295CA0045.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::16) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|SA3PR11MB8023:EE_
X-MS-Office365-Filtering-Correlation-Id: 8531ddc1-a1a2-49d9-2390-08df0a372608
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|10067099003|56012099006|11063799006|5023799004|4143699003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info: QR3Ij7GYel5eaYWyKq1okpOnqGq0+gokZbTDN8RBGKsYCQhGEF1kjHMogaBp28gHRM+c7JwDuEZqrdmeF+2xhrJpiNq9+Ai0M+q+ewXKeI4IGZ4gaDwOOEqJg6qneI+bbZnPX3KLU9F2QNRPFu4BLyWfAWqu7SAOWJ72XjkFtiNsOElu4tdGqBPJFwYyCJmVEjz6mQ1nBlF2YauCINwwdEophtPoPsQ1YDuoorDpfg8/MBfdRfX0h+5K83BBmL3Znz7Q+Jkp7hNnyGbXmVNznzTZgOgu4ba19QItHU+NGkozfhA/YEnpXqeXmvU90eMjmWc5hQPBk0GtKl+ussN0NDjK3TMhDTPsnvRlGwdo0aTYmF1o3kt9WvH+nd6WWcdHuOBvjiXl5GwgARh3c1woiABSpJJsS6iFTAJgyYvrdUyD2PHItTy23rLOhuxRBNgrlH1GjkvYNNzuqnc5wCGyV4H/cS4cLD7H6ZIew/YPDeo7IB+38C17HOjPSn599bnmYlH3iYBcElafxrcB+5RAV6Cs+5esOnv1S7nS88ANAbzZdc0Y6mPEWM1gqEKFnYlPpc4S8xYdVoVWs3xKAxtARBJ1HKcLsWm4frmXwGRHg8PzJqg2mmXurDB2CY9BA8bXXeZClrkp6ZDJcTvHJWfwad27AL04HietBHEywLfulrs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(10067099003)(56012099006)(11063799006)(5023799004)(4143699003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n41FQTuNl8VH5B74bfk5KoQwAHjbRh7OExEafcWbPOkgPykIc0SbnFa/ZWEt?=
 =?us-ascii?Q?bWJvpfGEnZpB4ph57HzjVhS1XKlfGzUHlsQL8FqJ7gA5XUVtXY+rMmvqYkZN?=
 =?us-ascii?Q?cK7XWRyxfjO6wEz2RiA9yOJMNb28V2KkcIKBp7XrY4CbDC5dbMTNgLXxaIdl?=
 =?us-ascii?Q?spDGlHO0Ta7PiInAd8UmTX5zIlc+wOesdvh/fDYjND1CN/cTOfTdYniVdhvu?=
 =?us-ascii?Q?tagLG3biyq2ZnS2TlGPiyU+cxDgpptOUOB/xhaK8/e3D6lgqCOG6rixEOGAQ?=
 =?us-ascii?Q?rV1xAi2z3czasr30y4DD7wUBIp7MGs+p+b+BfM73TAlHvg9AL2Y1TiRci5W6?=
 =?us-ascii?Q?0FjvY/nbb0Y4NGJVRUI+f1MseE5dpD+xYJEAi5q61vlAPvCmJGsUwLx8m8xz?=
 =?us-ascii?Q?5hnt2DXk6wYiZQCPoid3ttjFfvDPk/QghNMIR9QI9F9F9Vfkf/2XYw+Ul5rw?=
 =?us-ascii?Q?QXiqWifMeegpdX62PVtaXHm/hiA/pEn7N6DoaUEenGgcZimAXKWiqvtHvROy?=
 =?us-ascii?Q?kC88O76g6vNnEmfGuof+EZdDYOqrZgsxxxpE4LITsprNZmc6GC8wZoUoKhxw?=
 =?us-ascii?Q?U7Mf9cLfs4lNsh7OAKti/it0mI8JiNwcFXxPqJWS5qVMPOhJQqj6WSSeo6YE?=
 =?us-ascii?Q?yfbk48eknpAuvfbYAbM9wKcP5qJvtteB7N1BYnllqUGYYlXG2SFvLfyzxqgd?=
 =?us-ascii?Q?KiLR+CTI/urm5HgMrTVbIdqsAS2C7j5j+8OgXL7c/OF/hHR5ZUFrv9/R8X9s?=
 =?us-ascii?Q?w8IIcFLqM4ZiqGANYLbtxC0ZKQv/IPqbWMYuKxDYpYa/yFA1bSsgBHGD3RcG?=
 =?us-ascii?Q?lKZYQeyWlek6h4UNHi94jVCteZEgt1e4oNfNLkWvvua8WdbZKNxR8EIDTIle?=
 =?us-ascii?Q?BQ4RJ6VmRy01vBQy+RV3dFwbFLRym8sZjoob43xvi28uf2Y7dI8xuHb5nzPI?=
 =?us-ascii?Q?vKBe2Q4wNENRhxJIskeRtKAr9+hv0FC903FUd5ocyUah+REWJA18UEDKDjuR?=
 =?us-ascii?Q?l4sM+L8s9Gm+jq1T7YZ85trfGivdJDEf/izJGVHKoK9X+keroDt1jbm57GlP?=
 =?us-ascii?Q?1nuEr7e/42Sr/DOCNtHy0Uiz5o+JQQ7pPNnXLa/eyzj/lqIK/UpxfoXEBSNz?=
 =?us-ascii?Q?oC9kYNEIq/L4YPUYrP6f+L5FwgTROlJvSLF+dU+sqsNMP6+KGahK9iOVc76+?=
 =?us-ascii?Q?QzYDOeMMH/zqnhgVblP3IXQ99gWwX9gsg7qv5eFDRzj5ot5pDjpsEMs2oCDe?=
 =?us-ascii?Q?QlGYZKvdiAcQkPB0uhiIsaboJ/6QUmTubsDQVyHG0JBDkBjfmu0g9o1tcdxV?=
 =?us-ascii?Q?tEhPoCtdksBb8K3hzm/xTRL3C+TXGXrb31RB1l6p1YKuF0n/xuNisJno4H2g?=
 =?us-ascii?Q?tmVodhOnWw2MIm+IjY3vIndFgKaLCpVwboX5vSGUPjKlSNhoeDPOnUNC9R6M?=
 =?us-ascii?Q?R17yCApFQvKvpqhQ6gBjSpvFyAsyNw1U63/jHrkmovricfr/owuOUoyM6TsN?=
 =?us-ascii?Q?UNW8BvaXGVhSAozK6djxOTqqHjtiGz6svWafnVtGFSe9isu/Wym83taYqPOF?=
 =?us-ascii?Q?0l+m5D1uduXXQ62YSdKgT9YRzigYT4mqxNq6f8cyGLv0yKGruVQUv6RtrhO7?=
 =?us-ascii?Q?iXvIbQ68Xio7yh/7TXdParFdQhVdOLt+SRDoUnV3xe/eYLE0ui9I+XRePPaN?=
 =?us-ascii?Q?YHSOpELMhsLK+7K7hceKPUXr1PFMm4FBRGT90rV15xldMyHQ00ZjsDHl34wr?=
 =?us-ascii?Q?dkW4MtVejg=3D=3D?=
X-Exchange-RoutingPolicyChecked: VrkmkTw3KLqGJRqx5AzopcfiPzLqZMeOCubl0rm5h3/XlfaLX6YR8OnHNUuMRB3EA/yA2zd3bX0DyOdzvpe9tWbLCf13ilDjghWbY6KpWjqy75nxMlsvO+j1NKOB1nlVirtxnRkY8f3ZTvSKatU5TT2B6adDgDAKKm+6OEc7O/T/iWlpMuyLTty5hjWX83aN/v73p892V/QE9xtZV4YeiRGTPg2nki7ZcqpnmLiY9qWJNNj1NJHFhRafECnucXNpqRw43Ye5i1698GtQlTeXmOyCV000m3ZII46J/GIB75CSL0C6wHiYzcGydwMv/NqAqlbmzsjwmaalP2JooL4hzQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8531ddc1-a1a2-49d9-2390-08df0a372608
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 03:46:49.0687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iVld7QY4IizXbpBHiYODwbFT/OVVsUdP5vnduXuGsxZ8ObfpFRTPnSgVHM77KSf9PCJ0aLVAOlqY0UnUpNWElA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8023
X-OriginatorOrg: intel.com

Hi Reinette,

On Thu, Sep 03, 2026 at 09:57:03AM -0700, Reinette Chatre wrote:
>  
> -/*
> - * Map the memory b/w percentage value to delay values
> - * that can be written to QOS_MSRs.
> - * There are currently no SKUs which support non linear delay values.
> - */
> -static u32 delay_bw_map(unsigned long bw, struct rdt_resource *r)
> -{
> -	if (r->membw.delay_linear)
> -		return MAX_MBA_BW - bw;
> -
> -	pr_warn_once("Non Linear delay-bw map not supported but queried\n");
> -	return MAX_MBA_BW;
> -}
> -
>  static void mba_wrmsr_intel(struct msr_param *m)
>  {
>  	struct rdt_hw_ctrl_domain *hw_dom = resctrl_to_arch_ctrl_dom(m->dom);
>  	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(m->res);
>  	unsigned int i;
>  
> -	/*  Write the delay values for mba. */
> +	if (!m->res->membw.delay_linear) {
> +		pr_warn_once("Non-linear bandwidth delay not supported\n");
> +		return;

Previously if linear delay is not supported, we still write MAX_MBA_BW
to MSR, and here we return with MSR untouched, this should be the expected
behavior? Besides, in patch 2, __get_mem_config_intel() returns false for
non-linear-delay platform thus MB resource's alloc_capable is false,
do we still need to do the linear check in mba_wrmsr_intel() in patch 1
as the code path will not be triggered?

thanks,
Chenyu

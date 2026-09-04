Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024D03B71BB
	for <patches@lists.linux.dev>; Fri,  4 Sep 2026 03:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788492490; cv=fail; b=m6fTLFzcwDvsfYaptWTK3IwNFJ4jxAmrhrvKELlmhk/EH/kggKi1IUdOSqN6lqfG6Nk2GGFCIVyKziH2jckCU/Ov55bNAfdv61fI9YZ4yoO7RsUeEvogzPjdxMpCvCCv9KVlgXzXSAfeCwpKYlZSGJHslRXEC0C0sI6Fq4u8XHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788492490; c=relaxed/simple;
	bh=VMUbXm3vSZYQ1xYQQmqEwjsHQ0isY9GGMiH3FPpXoHQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aYs6ybD/J1l/Xs9VPSf4KyQ6dBmxUV4Nq8TOJ+1WtWSXZuunoVaXQHt0QyeGBcpBZndHFELsaRzNaH9VF19Ke0bVXxoYlFH6HRcY/uZhbJ1rHe2QTpDQea6WGlC2toMCX/9oEDiPbN4g9+r4OCUwf5t2QsOZkd5TOmiiMyoY6yc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Eudyu8cx; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Eudyu8cx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788492486; x=1820028486;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VMUbXm3vSZYQ1xYQQmqEwjsHQ0isY9GGMiH3FPpXoHQ=;
  b=Eudyu8cxKFs4A8Ctcxy0AbZiqwUlFuq15hhfWDT/YysFEh6Ntiz3WMtV
   oyJEsnRwbtn2ALNJKJCyYxLL1f5gw5xYwHPMDsPYbARD/mkdOj6aylt6z
   U7TUNo622K9iouUc5wlcbdVX9nIqELTTGFGnLDmaMUPUQoVZ4E4BC8nb2
   T+Fa9ZiSST3pRDl4foIn3mB5LGdXDBifWhuKD2NeMwB+0S04E8attboA3
   cUKvlH52ZHSZO3VqhfkGf2JRqoIhwW/9oItuLou2P+fVRl0Wux7mWyJd/
   dOl2qbeBaMRRfCpeT4Z5AObZCGekfXnxWprNtjNh0tDy6Qim/bV4JbKYP
   w==;
X-CSE-ConnectionGUID: lol+bG0KQw29S9/fA6WOgQ==
X-CSE-MsgGUID: n/FSV/FeRTiZElLoh3iZLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="92860291"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="92860291"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 20:28:03 -0700
X-CSE-ConnectionGUID: EIx9zL2wTG+cXajCpDFarQ==
X-CSE-MsgGUID: triLk+P8Sz2YIF2T8S9rWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="275196468"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 20:28:03 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 3 Sep 2026 20:28:03 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 3 Sep 2026 20:28:03 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.49) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 3 Sep 2026 20:28:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x9lEZJ/grPyVQ9ToG0Xklqkge38kyDq/b95CTUYI8uOXpGR7EsFN8SOpSsjZmTHKtVHpyJ6BfDlXPQzs2EqXvkJw+n7PgprrcQk7GLHVHdX3Qxfszt0nTtt6oFw4ZUq6/BYtbLHkuTOmk0I0cCF+8VkqqlaTaYdWaLMuiUFPbTbTS8RuUGAFI54HDPPTDZcu19kr3GsZF03x0kbQXOO/y00medhv2xshFK9UYM76KMVV3MIVgPefsayCeAi2Eiocf4NYnSbrJJIFa3VWYvubXS77oYfhUeV4VaT2Yg/gWdawMnkgG8dZw8dVRUfGTVdgzNEyOihc1LVvp3UssDwk7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nIBB4tlqLi7npDb15TDKQI6kTEmbz79CrmrXR5xXS9s=;
 b=GJnpFLMhwusZTsFIWP+tjBonKBTCxf5NOtIcV4Y7WY59khqypstSkJ8gie/H1D710OxSA9n7z4ctTzxZaK7nfHTezTLZ/mi1xZ/Dbjl0gR0sSagz4boWMsb1pS/bVmXQVC29Dd7svZkP8S7sTYwIqH207DwfSqweW3XJqAwHm1N0sEKMpmPI+76k84Wuq+ylhMkhq/ObkPkbIGiSOTOYFaGYAPnLh3KjnzVhQ789+nJcbc02kUjMl1f1m8lUGCJVwimRt7Q1Mkrz7XTVwDK+/aWOOQJIxihAgeUSFvOmjz/+4s4wtMVvQ0gKXrsBHUbTTq6Gp93ZRQReX1qeYnGJxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 IA4PR11MB9346.namprd11.prod.outlook.com (2603:10b6:208:55f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 03:27:59 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%4]) with mapi id 15.21.0382.007; Fri, 4 Sep 2026
 03:27:59 +0000
Date: Fri, 4 Sep 2026 11:14:29 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <tony.luck@intel.com>, <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <babu.moger@amd.com>, <bp@alien8.de>,
	<tglx@linutronix.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <fustini@kernel.org>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <chen.yu@linux.dev>
Subject: Re: [PATCH 2/5] x86,fs/resctrl: Remove "arch_needs_linear"
Message-ID: <apo3lSWAQRRK2W_r@fengwei-dev>
References: <cover.1788452481.git.reinette.chatre@intel.com>
 <62904217290f2cd3225d8608c19e284d6dde3aec.1788452481.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <62904217290f2cd3225d8608c19e284d6dde3aec.1788452481.git.reinette.chatre@intel.com>
X-ClientProxiedBy: KUZPR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:d10:33::12) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|IA4PR11MB9346:EE_
X-MS-Office365-Filtering-Correlation-Id: f37b5ce4-955c-441c-b82e-08df0a3484b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|10067099003|6133799003|22082099003|18002099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: oSL2tCl2dSso4tPK8rNicSQk2gGAq1jx0UpRY3uvTk7sfzAYQI3kdpuHNRMGXFuWzma9LeeIJEEIiXQ02cfvDC3CZNu5L6KexuR1Mh9bHoqgvPW1toVrhDmFmeb1hmpFvYpl6N+P8IT1QR/tM67gWVti3AsI73gfEyxVCII03bg2IBL/pf5/XUn3aGYs54kog/+jjZWtoE7Mr10oEC2okJgUJ5UF9Z6B3N5WYe5v5jl2U61NW1Tobyol7CbQKhg8M0NVHUQWhbVGTL338lEmf/Rmxt7CGBkIuIoVp+gTJNXctWyha/6VblT60374V3LX+VGK9RAt3axN5m83uHeVFKHgO/jDtWka7D9qGLiURPUUxoN2Cfe6+f2yqBZkDiBfDrLhk4Y9OFyq1FXwXVi7DkXaYnrq4lZG5pswXggR9zP8xOlDjZ6Ty0KBx/0VSvbpyqXPdhljOUn2N+49pWUTjv0IqBNm+F5ZjZaLZ4ObGgt2t+p8p/FMvpz8Hkp873arJ+5dLPsEA4AK88IyDVPPIAYyxI/t4YfNyOw74V+umZBE3RZ8w5afvO0awnIoFr10tVn0Vh353N1MA85lFh47YGSrTmf4UGhzCfvc5pvQm3HxR6dWow0E5LbU9np1WuPaiwr88qVX6hScS5ti/zijsq7u7poQyltF/x9gaxeG2Yw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(10067099003)(6133799003)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xc9sEkEijFYfXOLyJ8GATeshAFIOONF2PAy5hJFrK2Cv3iBaCaHQ3dJF8wcz?=
 =?us-ascii?Q?2bWwbp8NMyFA+Y+oeSLBp8TbHeNhJTaW60bj2K6dui0k+y/SK0AystSYgasM?=
 =?us-ascii?Q?asSyOOc8JjfzkCkm6U64/txemUWfyZpf4wA3bSAgFYHK7lYWnd3VnkdGbevp?=
 =?us-ascii?Q?zcrYkpb081kzSgGYD+3p5VhCTNr2QnTi6tscsNLBcQa4zNCCwTDSt0/Lgz5F?=
 =?us-ascii?Q?3qZ6XhwsCZeSVrZCxEWbKziKJPz47+PVnKTM+f5F6RRXQLhakBoOuP8yPXwe?=
 =?us-ascii?Q?CAsDH3XPSo/VoSX0loJuHovfpYCyZvZYI3Yret9p8Dm6TrAI/iyFJCok/Pup?=
 =?us-ascii?Q?MZM4Jr+e6B+HnN4xS2QXS2rQ8op1YtNtYTGsOuc2N+Fz0GuwSke6Qt6bejdD?=
 =?us-ascii?Q?jp7rJ1VjCbhfmP0U4X3o7wdYY1N2SggBwHv2wcNMBdDAxPERjiotLPMYlsGA?=
 =?us-ascii?Q?2+IZLhBmbWMJZjTOqrxqmTa/eb/JIf5NVIYcenR1op2JnG20kldNkGx5oOHN?=
 =?us-ascii?Q?2nrcSYC4nZ5e9Kddro2rbNn95Fwz8NLDR+XYd2JpmvzHvWUsDCZWQEAlDGZ4?=
 =?us-ascii?Q?As4h5gbxMgL2Q680OO87CUKP+Uuz6N7DCxpBkVtucIX8jM6DA5KFa1guQvaj?=
 =?us-ascii?Q?oBxAOC2Jt+eUAwfM82Nr29/Eipiim/MY1m20GqWdgPa41UwX4bKOdDy3Q5W+?=
 =?us-ascii?Q?BRRjrK5RGGRajW8vPAIe96L8CwXgdO0g1nn2lPtAFICQVMcXEGjjGWTkFgyG?=
 =?us-ascii?Q?YmWOX8m2DKZRObUk0rsXMdRA/QvLoVvMSjbX9PXdxJ76x+2ogew5QlXa1bWv?=
 =?us-ascii?Q?WLP2hfEWqweur4K/NoKaPZwTivH4Rv+UUZ6aEgYQN1mDhMOtRL5cgl6OzNmM?=
 =?us-ascii?Q?SRUOeNTL0BLFvZb1gb14BKOprW3T3clIsUup7w4uavNk0O1oGo/fDuy4RRdz?=
 =?us-ascii?Q?DNrSz7NIVLhg+zE8YNMhS19Cd8mPAvDS4ZbwzS173LZfiUP6AkAyQ/h+fJsn?=
 =?us-ascii?Q?ADuNvDmLmFz0ZgG5/AefrYbO90RMEChj9Tm9JCklYrz78Oxn+/N4nKe7lT8m?=
 =?us-ascii?Q?iM/gR4LjGDPNcXr5whxaDPJFpwVmWqE5zmQIHuA16fo7hg+HHHLSOwOL5b7K?=
 =?us-ascii?Q?b0Yie/DwFQUJ4OqVrE9hGTwJHEnGJ7vYZxbrZE2cgahjx+Kb2RC94+U+Emtx?=
 =?us-ascii?Q?Ux2t8+zSCzBChAAFfA3LoDroYBC6T3GVe8A0CNLIAmHH8p30tWXYipRFuAMr?=
 =?us-ascii?Q?MfntLzwKzRUYjvCV4ewzJYmzLD8k96qfANB4bFGbfgEDAU9aYg2Qbis7MbVx?=
 =?us-ascii?Q?cvFjuDtddR/KAtltsxOPa41aNpwKQWcqn+7A0RFF2RoWL+cCrN+eFHKZl4ms?=
 =?us-ascii?Q?YwM+fj2mJOh7j8hyoa0YOq/kkul5pWyz3tQX+/Yr/OFHLozBPbAGTlb2UBuj?=
 =?us-ascii?Q?wDadzxjjeOm0CwCIkULuCwOyoN7tXXlj0ng4r4mMkJa64e0QNnMCXKEdF26b?=
 =?us-ascii?Q?mfTtb3sRVOFza9CrP+EgZcLrGxCyg1YhWH9lB0rI7FhUhYpgdt6LCs28ord7?=
 =?us-ascii?Q?7jp2V1wJzWjf3aCmZ7NOs25gVciN7j++nstsSU72zrgmtkAZC+TDvM3jdQxJ?=
 =?us-ascii?Q?MNSkLmA/DrzvNghr4pr0CRjxz+UUS+c69R0S6qwh++aI9dRwwuYrIvco7yZ6?=
 =?us-ascii?Q?0NS9wSbZ5Vml/deGJZu2XMbN8DB2FSrrGhCpC1ArPNJuuA2uJVhTb55UA83A?=
 =?us-ascii?Q?pSpvJrdqkA=3D=3D?=
X-Exchange-RoutingPolicyChecked: zTKJe7nkjjm6XkO09y0BhxoNMVEgPiDWoaJJoKvw7cJWIydE1GlALjNBLzCQu76yzB/1LtY0btRQSQUGtXsgt/3dKgWs4QszhyOcSv9oPRfU8oNXu0pdVBa49ksvMTVy9AUq6wSch/RRIXrs6kw1e/uTvIeujyeLY3V1AXxOAPmS89TFGFGjEwlIU3kbgJ8kDW+LfKIvGbt5QKvQFfNKqXw4vADlAur2FESrep7k1RHIO9GszaqV9r4jS5cScRVxV9ay0g6eaWKscVOgsweWGN4vAltQRuCZqAqThsWfOUXe7PzxcnOb4JhaZb8uOFDFkGX0RRGrCsa4mWSNsZ0X/w==
X-MS-Exchange-CrossTenant-Network-Message-Id: f37b5ce4-955c-441c-b82e-08df0a3484b5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 03:27:59.2162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AqX6ECPElVMqKRv/qRZ7DHJFz4uKT/0TFxNcCXeTHMl7rBzSYkXY8J2Hcz/Sh54MoAj6/laoxzIo+NruMZlIcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9346
X-OriginatorOrg: intel.com

Hi Reinette,

On Thu, Sep 03, 2026 at 09:57:04AM -0700, Reinette Chatre wrote:

[ ... ]

>  static __init bool __get_mem_config_intel(struct rdt_resource *r)
>  {
>  	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
> @@ -213,16 +192,13 @@ static __init bool __get_mem_config_intel(struct rdt_resource *r)
>  	hw_res->num_closid = edx.split.cos_max + 1;
>  	max_delay = eax.split.max_delay + 1;
>  	r->membw.max_bw = MAX_MBA_BW;
> -	r->membw.arch_needs_linear = true;
> -	if (ecx & MBA_IS_LINEAR) {
> -		r->membw.delay_linear = true;
> -		r->membw.min_bw = MAX_MBA_BW - max_delay;
> -		r->membw.bw_gran = MAX_MBA_BW - max_delay;
> -	} else {
> -		if (!rdt_get_mb_table(r))
> -			return false;
> -		r->membw.arch_needs_linear = false;
> -	}
> +
> +	if (!(ecx & MBA_IS_LINEAR))

Maybe also print the following from rdt_get_mb_table()?
	pr_info("MBA b/w map not implemented for cpu:%d, model:%d",
		boot_cpu_data.x86, boot_cpu_data.x86_model);

In the previous patch, a "Non Linear delay-bw map" warning is triggered
during the actual write operation. Similarly, displaying such a message
during bootup in this patch might also be helpful.

Thanks,
Chenyu

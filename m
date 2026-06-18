Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A048E2E6CA8
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 21:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781817319; cv=fail; b=QhETHAdEIFCyFDAmwW19EZV75jAIdvNZmpOpWNOMrtRpXuQJq7IGmShqEuKAqMn7UczeaU+FsvVuLu1DZQ2PuvFgZ4BC9D5GqP8fnBlukUzLr15Qnwg2a3/KMc91ewSNjkObkbmu00UYhEpOMiHCqpGZC1Rkzk3+pua3TcyFtY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781817319; c=relaxed/simple;
	bh=ytXbl4NSynFl9WCmBd6C3Hvk+/REPubaM/yDBrQPGNs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RsFbtLize1ycn1R1Hq0Id2Q7nwwEIb7kTWG2JvnzuGwYe2kPQPCS8S+jgrbCNfYw4q6kcQI8S38z9Nzmwhb/O3GPQoZJC081aeeDIjUs9cSs3bXg7CaBvN0udVV0lxHNup5fIHGlEIFAgyFxDqXmuFFBbXzREcWOAgoKtbOruqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SBqZ6+k2; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SBqZ6+k2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781817317; x=1813353317;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ytXbl4NSynFl9WCmBd6C3Hvk+/REPubaM/yDBrQPGNs=;
  b=SBqZ6+k2rmi41A06RQG/sC57lDdzwMCgxfkpKad47UMD1Hhi7c5cMije
   M9OPO51roWCO0XZFXfXyEMaQQiJzsCLXoD6GZhk3G5z4+WCuvKE5DGV7+
   ed0219caFstpn8n789FWTWfvomVgixc3kcP0UchpiOhvZIDLbg1xMP6BC
   f1yD02jyhYPuT2HH9TrLj70fUcoZXgvnBivr3WlDt53BECgopu58Zc6nI
   tmFtUWJ1del7GxihKggquT/QRzSkeL2V0ZwM/mB3dQIVc3joYsr1QHIER
   QsdhE73DuWnZmvKtEU4/R7JXjZtBpRvFTaCs8rrcNMMHQzSRlSWvKQiZl
   g==;
X-CSE-ConnectionGUID: 8E+X55+uSKmqadNS9ggmGA==
X-CSE-MsgGUID: ZbDVbizxToqZ2zxph/g6xQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11821"; a="108217898"
X-IronPort-AV: E=Sophos;i="6.24,212,1774335600"; 
   d="scan'208";a="108217898"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 14:15:16 -0700
X-CSE-ConnectionGUID: 0nEqL1DVRzaB20gYMTGPCw==
X-CSE-MsgGUID: wtu87LrkQU2Suo4g5N85mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,212,1774335600"; 
   d="scan'208";a="246118068"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 14:15:16 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 18 Jun 2026 14:15:15 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 18 Jun 2026 14:15:15 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.40) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 18 Jun 2026 14:15:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lusuJ9BTNF/FKN1OsjUZlNw/Oh3lGgTnmAd/FA/uzai2dnU9cIc7Ac9hYMJzrT/BK1oDmagpSCT7NEgAniKqgx0fe8FCpIqdEGBfBtEd3Us4kAYIklX8i0UTty0du1LJzX1De40FD1A3pprL0reHsxkUxuJifIiwknP+68oLit00yjHma8IxySjQ4jvYrjxMB5SjFwIANX02I7reJVatjYk0j1awoaXEaD2KmbFoNN5Qi0Qpw7Jtf5iw+SNzzCJQb4NUr/+PxPnhKOAHCDhqci79negXede+0vTetb87Ki6x4sJ//ygkDFjpZRDX1uPZNPKeP13t05Pm5AQYTlt+oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BEe3g09pHJxNIWjltg3kgiVY42kTrASk/Wcm8EEBAng=;
 b=TCbTNsUFugAqI37CfnaZ8yhcK0qVialgj19vDBMCw12roHKkA13fdo4laZNARwTk7+VoFsGTgNSt66BdZr3ScQE5lPC/lRJbgTwNaR6TjSueuQ0hlQciHtAvgnAQKA9/RKvy2CxCB5Xkhn2fEHuurwpXBtEwPXqvITwREAjeZisxd9ZyBS0fROo8crimYD9tv1eZvZdG+O8ZLSinS5a+xIaQUQarGLa/CGO/pGPWnRPFTI42oT+WxGEK8F2l8tHF3mNN/vuhDUTmatxxizJ8Fz5XcBeLi9+dBXx19HDPrDsfmY58AZq11M9gw6+E5vRwJNR2baaUF8xKCpyjrRqiog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS7PR11MB9476.namprd11.prod.outlook.com (2603:10b6:8:266::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Thu, 18 Jun
 2026 21:15:07 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0113.015; Thu, 18 Jun 2026
 21:15:07 +0000
Date: Thu, 18 Jun 2026 14:15:04 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v7 10/14] platform/x86/intel/pmt: Register enumeration
 functions with resctrl
Message-ID: <ajRf2P2ChE7SExwO@agluck-desk3>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-11-tony.luck@intel.com>
 <cdb00b39-383f-4751-8e5a-3986fc92a889@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cdb00b39-383f-4751-8e5a-3986fc92a889@intel.com>
X-ClientProxiedBy: SJ0PR05CA0204.namprd05.prod.outlook.com
 (2603:10b6:a03:330::29) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DS7PR11MB9476:EE_
X-MS-Office365-Filtering-Correlation-Id: 70baeb26-a148-4112-fa46-08decd7eac10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|18002099003|22082099003|56012099006|4143699003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info: txAM2vn6XtQqBnn+1AnosvpferC1lnV0vU4xZxPQcGy26C6HA7gBBMcZ0Y2r5DTvr8BhQsmUhVvApzOXPXj6JiWhxudKDPG69VEMJ1mcGR2v1We1+fWPPQMpL19od7KzeoJAMiVaZhUrtyFQFIWbvo4RQRqJzEdhUzSY2eAz64EZZH18BrZg7L5iKmsRw6FwY/hYKMmn6AFPwpM6uqD38qZH8HvAO6eZCizwJnC16CdV8bbOXaNzTgl4e1oH4k3NKPtkP2bczlF8GV1IB5zshby7fHFs18I/HpUQmZ4YUG/I80MYpN5VVXwMcr6o0a/XQ0zDmyVOUPpvIE12idglN4g6e2nQqtzAVSnYgIlY8Y60CuM34SVz++/f1EBw2JGJwwJILkgyvLzXOTfaGOuLgV3DgMAM1iulCyNKkhIimg88Tj0evQ45jJ9eDciJhtYQQ5ciKg1xpXa5igvreiF7IYLx6fc5iR6PsG3gn3sOrddLzwxH8kimiTeMIlPr+Q46D6AkVq7dEaOa8uTgyOQrrVfbrL/uUQdJPjKG2NjSUoGNybriTTvs5voTCPhy56StbLf5wMwlKy67pr7GDrJinMQq+uMEBw/6PC22XD11QvgXa9qXzm/KS3f5wZEA6JdrBgQD8XGeiR1W7bWX9zvWlpyCsBtaMFPUO47mUkfax10=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I7X/n6Yuf8IScmtI3QftxDbTfpPbdgJn+gXTSqgXCrbVnnZ8MDyK63YTFrgj?=
 =?us-ascii?Q?MXCP1kF2gEM2r0I2j5hs6rSehtnaewTHx5SgjRo/133GAoMytlK04IMbNsLF?=
 =?us-ascii?Q?eWBdiIdYvtMtH9yPZxkZKdTbc90oUBM6+gW2gercrj02xoit9qmBV87sbDus?=
 =?us-ascii?Q?atspcabXJ6TmS5FSnhxYEXwTJhJnRUBkwunIDi6LAA0FvuDgXP0g0ARKja3/?=
 =?us-ascii?Q?A4AZ7Ra9Tissx1K29ZURJHyGaq7FDHDJiSGRiqu0mbgiK4zG1EuEHeWgnecm?=
 =?us-ascii?Q?CoYtu+yUoRXB/a5X+FHcN8rCJgj+4ba/r/GE3DbioyHakV2T1lTslrteYeK7?=
 =?us-ascii?Q?Rx/A2WP9w8XPdKGgSGsFqmQFJgM2r12DdExitUnf2zZWdjtFpklI6EjVKACM?=
 =?us-ascii?Q?qJCL8SgWwEPlTHVtqt8rlYrWVsDziZtZ/EivOOTNPAf9VfK3zXyEjCV6cwM3?=
 =?us-ascii?Q?nBXN8mdR15lQV1WIy0OUr2QfE+7S8jvYyQvraLpE0P4BL0OjuxALkqjfP5P/?=
 =?us-ascii?Q?Asp7TnWPZs4W6WHX3T/BQeZx4F3okaLERnkgDDii8Qehabf9fwt0cr7P+/R8?=
 =?us-ascii?Q?fF4CVYMX+E46IQfrg8+vN20lwDN5I3kpf1Q9WCvOGH9AG7t7DPSO0+ZQren9?=
 =?us-ascii?Q?Rd9me0DCjA2UAuWsVUXPaX5t80Z98R2XkoeAWftjZMKel7WkYASgS5fOYX5W?=
 =?us-ascii?Q?WPCczVxH3lz1ItYQF43Eczz4+cCG9nbjGz/xMHiLbA+6FgYu/8OOtNNg2d80?=
 =?us-ascii?Q?/x3cfQ4Q1GdTlv7gjhOPurSLNpbDfTcr0iwWapTxkUM/JUg+igFPYa5sjmOb?=
 =?us-ascii?Q?IjbtaHJMPVTEiZT9M/PceRQvnmhdqgMqi5fwO8tV3scPba6MskAcfAA4S3pc?=
 =?us-ascii?Q?7BQinKJciO6JqDbIScvxOtlB6TCQrUqWarLGsa/kwwzk71jImIY4S7Ed+toD?=
 =?us-ascii?Q?AdpO0wRJqIjoIek+sI2D/58xxV+re0AhOniuKsBGp5yCC1Aby/u9/ALzqezd?=
 =?us-ascii?Q?K8/CR9LYmgviVOznk9ru3d5CGGqi+knXEkxtgJILe75wedmyX1nn2wk41eD5?=
 =?us-ascii?Q?xdvy+23IBAUf2y7lid7Y2/g+b5TSnIFZRspN3fgytsbp20ul/t0dyL7h+lBT?=
 =?us-ascii?Q?E4rQ5UeR1jzWuoBkkG4mZr8Hab11Lzn9srxvnZlR9X5qZIiEDqEsxrRgiryI?=
 =?us-ascii?Q?MJV2EK1NMadWdvhzpa8QdfR+wXQjUZDQEdbWhT1HkwqMuMij/KvJkLvQsJtI?=
 =?us-ascii?Q?E8cDnzT+0gmsq4Au2DK/Rq1US/DstospXITkesMQUm+zh/ZpsWUMqbP+QKRm?=
 =?us-ascii?Q?yazERpQHSpQJIfrL+hMh9tKwTK1onrdqanLRB/2LjUis54hwJhYpl3sNEdQ3?=
 =?us-ascii?Q?N53pyf60qCQBul1edoLB9H+wttMsv8jKNkLmbc3Cpv5y6QQ9XwZzplvhpyRR?=
 =?us-ascii?Q?9Qd8EZ2KShoh7gJMTXaVUabuJqxlZZq9A1YCByUR1+agSR6uCLZ+H1a0WFvR?=
 =?us-ascii?Q?lykj/gFbEY0Lzuo8t/3l3Ib2KkVH+zvnHo9Rud9Zpvqhr8PWKx6AxQVSPEPr?=
 =?us-ascii?Q?tsXA8MEotOelt0u35b9CdMpRW1CPo3Y3aJhXLPLNL27DDmEVV1E4w31uk0vJ?=
 =?us-ascii?Q?X6/O8tjObwlsMNKuer4IgEKVHcH1QoZug9XK6yJYtvVQh1MnsHMex0cMbHnU?=
 =?us-ascii?Q?/NWXa2jfdhNvxBuIkXZYtWclnSosOsUHeWHDy3lufrtHanmjDCPgo4DHzvs4?=
 =?us-ascii?Q?P6TAE/u5aQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: H3Js9NYW0bqNZz7pRg9hKHGeFi7bndHOGwq9co7+CCBx80U7y95N1xHK2f12IFWg3GctcjbbVPdXrQ7r1Q8XGJar/ZHi/zVP8CwEjWmP/yAJlBpZZLaMop7jfYhe6IzbrPTp4gf0dH7cw9fCqvV6N1hYrA1+aNUOBojRfGYkV4m/YCBJxV0TNGx7TNAMVXoFZqJIbIING+eLwxXh/eGdm4u/+d8Xm/fQdTajd9lks4B/RgpG19AeC2D0ArWFv9rfMi1E1+auXkKNIrvPZyAIebLAhDebzwFE68v7sBckvpvT3gBabcQRrGDeBwkZlkkNjm2Uvs63E4DQQT1zaQM0fw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 70baeb26-a148-4112-fa46-08decd7eac10
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 21:15:07.1761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oU5d2D2a1X1CHCM2U8eAA2igfR7wxTxRuAtQgccoEdvCZNJ54o3x79pw2RusAk/yRUf/XakQajZDCPLVOCBXsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB9476
X-OriginatorOrg: intel.com

On Mon, Jun 08, 2026 at 04:22:27PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 6/1/26 12:56 PM, Tony Luck wrote:
> > INTEL_PMT_TELEMETRY is a loadable module, but resctrl is built-in and cannot
> > call PMT functions directly.  Register the telemetry enumeration function
> > pointers at pmt_telemetry module init, and unregister them at module exit.
> 
> To ensure intel_pmt_get_regions_by_feature() has access to complete data, could
> it be more accurate to register at the end of PMT's .probe() and similarly
> unregister during .remove()?

I agreed with this. But on further reflection I'm going to dissent.

There are multiple devices (at least one per socket). So .probe() is
called for each. Registering with resctrl at the end of .probe() sets
up for a race with a mount of the resctrl file system:

modprobe				mount
.init()
 auxiliary_driver_register()
  .probe() for socket 0 device		rdt_get_tree()
    intel_aet_register_enumeration()	  resctrl_arch_pre_mount()
      mutex_lock(aet_register_lock)	    intel_aet_pre_mount()
	get_feature = get;		      mutex_lock(aet_register_lock)
	...					... blocks ...
      mutex_unlock(aet_register_lock)
						... runs ...
   .probe() for socket 1 device			Does enumeration with socket 0 complete
						but races with socket 1 .probe()

I may keep the unregister call in the .remove() because as soon as the first
device goes away, resctrl can't usefully run. So it seems a good idea to
handle that right away.

I will provide details on the reason for the asymmetric .init() vs. .remove()
in the commit comment (and in code).

Ok?

-Tony

Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D771045349A
	for <patches@lists.linux.dev>; Thu,  7 May 2026 17:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778176039; cv=fail; b=DwyzloFMPFARdj6AFydfPyQ+0QOZNEoAuAovWRJsGR1jYoolaMXkI3AFMTfZsixpefxyRMR4gNxLLPnd9zAfcWCmc8/+MvfO40ZFtL2DWakPwoTcFF657NqWmjrxvm3/9uHWYi9rsF7IAiuhTcfz+KAWpCgitLRA8Bg+6Z4upTE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778176039; c=relaxed/simple;
	bh=KlNt+8eMmj78kmJF6I7UbUjoKhnBjkJIuQHqb4Vj080=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Q1tFxVGi9CegkWYsozskm0ISFp7b40Tm/+e/SYoCJv+IL1kGRMsdQta+MHwPeRcOL7iV37HYpgzs9bsO2DftNI7noMfsNk7UL864PNwPUP13bEyv35kD+cbe9XC8QA4vEk/GUYkIz4WqOyI+RPG4QunfjER98vbSLFSQd23USWM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y74iFjqu; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y74iFjqu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778176037; x=1809712037;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KlNt+8eMmj78kmJF6I7UbUjoKhnBjkJIuQHqb4Vj080=;
  b=Y74iFjquzE6cGw0Z3wEBCaq8MIjF/mIMR72TnYCFBWXnZYMZbPIMTtGr
   HYZJsgpfx3Rf3vJpI3oYo/PlDYbBaaD+/OD0X1UVrGAl6UErQPEtV2u9v
   L6yDcxjmysBbzsdMzM/sMJBIDp2Mxqo1+0IpDF36NrcrLowkdrpntiyy7
   kNqGlhjnSwQH0xF/rtFYHR5XQlHfWH+Q53IzoaqTG+8h+u5wlkLUuWikZ
   I7wM4c0bYdcLgj4NIM8bABSu/rTuAFDjiTs85K2DFhkkSRIBBCXzqPSE3
   W7X5qO67z1F+twqMLNd0OcC7sOT2ih/NPb2EbfdQzMaT3gLEDdWXnYmCP
   w==;
X-CSE-ConnectionGUID: rBQPfoHWTxmjmQWCC7FQIw==
X-CSE-MsgGUID: w4OX0mMjQEmCRXTZjOJQ2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11779"; a="79073850"
X-IronPort-AV: E=Sophos;i="6.23,221,1770624000"; 
   d="scan'208";a="79073850"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 10:47:09 -0700
X-CSE-ConnectionGUID: Z6AlzuMXSFuslXkI0g6gWQ==
X-CSE-MsgGUID: 5YTp8KS7QFax+ETVoB0bVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,221,1770624000"; 
   d="scan'208";a="241526282"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 10:47:10 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 7 May 2026 10:47:09 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 7 May 2026 10:47:09 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.7) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 7 May 2026 10:47:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LiiKg9HvL9aUYZwzNDwzIna9VFa3zSE2gmEKfRG/3JAw2V99vtxiKNe0e3jA5dvh9UHDkm0sewh9VBqnLoBdqR4OFdataGFWehwHJpuuzfDJd3JhE4Rv1awxJoba2d1z/EgeCxawFO4oyz5qUF+IvSDu3LrC8aqPKqbiQ/z8dEeRZaQGVdaZPUE2wp5a7SwtJhSvAC8/cd3C+P5JbArMPxZdJ3mNyfYpEWQpfAFee8VMAOMuoiSCmDLn6lzj6CfzI6t9r4qRSvxOgZATAwZcGwg1A9rn6Wc8T8ljTaq+cHWkyn5IWnbQVZ3HkN3aWZ4GQOTCSnVf4bF4mTi1dft94A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KlNt+8eMmj78kmJF6I7UbUjoKhnBjkJIuQHqb4Vj080=;
 b=HBQP68pLoMHhmBkqaW4Fs+ZHabt8rh1BvevqGZxiwiwGQJ6Cs2zcBZ2BmJoZmg/s66y+LNTDBlE8OmwRhoX1FtJYG3mEsH8vDZ7tOVYql6vmybTu+zx/Kon/88c62OGgbYnbZC503am/3s/x+UpXToUUevlIdRlKysh+WQbCy+6kfCPq2V+cl9zh3C3qLfSy0AV8Ap7ekW78k9+pH5Io7YGxP7wviIaiDAhySMw+Vd/OfKn1Q2T5ACwcpBjggNMtak1O2EcUBBGpg+cHit1VYuynr/Q8aRTzw3wP4XGLTz89sbHCBSn7cG+1WOw5FtGXnxLPiIHfmjVsYIvFdc+kWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA4PR11MB9059.namprd11.prod.outlook.com (2603:10b6:208:560::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Thu, 7 May
 2026 17:47:05 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 17:47:04 +0000
Date: Thu, 7 May 2026 10:47:02 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Fenghua Yu
	<fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v2] fs/resctrl: Fix deadlock for errors during mount
Message-ID: <afzQFkVPiNW8QR8J@agluck-desk3>
References: <20260504220149.157753-1-tony.luck@intel.com>
 <5d38c1fb-8f91-472b-8897-24b2f50c772b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5d38c1fb-8f91-472b-8897-24b2f50c772b@intel.com>
X-ClientProxiedBy: SJ0P220CA0022.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::33) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA4PR11MB9059:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e0dd5de-0ee4-42bc-1481-08deac60a6a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: YzZBPJnWl87M65HzDFlXPgR/q0ntwxwhuJAvIIx/bXpgUS2MCCLvk68Q8iAYzw4ak5zIHID8wHXRcBd+aje4Y3BPcJvXnccxSvqnK8qjX86pra8IuSXtC14XF8Um6ULflaFpACaidxetHYNWHIaKbLDfCzWc+gFBzH6EjR0alKS5c2DwUCiRfYh3G2/GlSUiDYhPZOUZhDisTfmnf3mdFY38zcyxcakvSO6j3FXqGhTVFaqOLpUCKKDxvrMuGXWGnMZgB5bOpEnNWM0/mQ09dJJkLWQgqSJX+fYHHJQTBHZ2x5HEljXgUxj2amFSgh3JAtlKAD3lzwKk++JcpOWiTcXHaGSxdyC6NuKmZ5/regv8UHq/q1cYFynFaJqwmydCCYLq2UV/K31AEggLRAZvjqiNw0aAFYRrEps0kpaTrG6oF2TqYYK3m/Z0rcITNyrk7YeYKaNI+J1nc8ybs1FVXdQo8GH5bJe16/Is2+t+hua6C1rT5MnjYuWJmICdYjcsluB7fHuqnfzD1GjeaeIdq7N3GB7euFa5pnNZIBO0wYOI5LXfdMmozWHKZ3PtZw1TQrfj0SH1jdGx/2Vc6mrbvbUN55RVXTphlqu1Bq4tvTdbUD5OcniEtDr3XmO1ziAUSd9cxAyE8pywR+AycVUPDl29ts9ELplsjqNS+oxscxFtcH+wYxaMxmHV5CWs0zWI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vdZwtln8DbO/qVM7sKapQSkOr/iq/CzQFZTKkbnQ2F+lbsDVzIy8tVOrFvYm?=
 =?us-ascii?Q?An0AKvb2xmLAazeMoxCjU63iCqqMH2w3lfeABy4W8Z7WGMz7Ez4ZHp0m3EXs?=
 =?us-ascii?Q?rRRYZxie7g+ndi03d/G0vvp7R4a38PVk/rITT5Vv4EZ4zVTzQTtOCKA8Ymvd?=
 =?us-ascii?Q?BYwHrTNPA1YwvjTi/4j33ukI1FnxuMREqHo1hnIXfSVoOwTyOYu48ecgogd2?=
 =?us-ascii?Q?OGOaH86RPXLovfJhRdBlYPz8/dPdJnzgvKzH08ROh76/X4IZsYEZpQEr2WcG?=
 =?us-ascii?Q?oC9Om+gno3Mrp71CF6dZ6AzEEdlRn6GteI9ZfsuL07WZfbHb3whhxQeEaozJ?=
 =?us-ascii?Q?P0kNqUiaTdCEtSLh7SAi1uTa4J31P3AdQuxjTFFItcKk64taH6ILZFYDuOHw?=
 =?us-ascii?Q?jCLdVfmlksEOogWEIY2tjs7mPUEUJJDq3DQFVBmrpT7FFImQB5F1k0Eowquf?=
 =?us-ascii?Q?e5OS8VJpo7fiO22aevkSx8wnURKqsq1hWpeM5YLkcNs/A87xL1MnW3zUWuSd?=
 =?us-ascii?Q?xpYlZG6ILIODztug6yLB7VxnzLBDXRUIgMZZ0cNAeu1J7lvBpe2yU9r5TqNE?=
 =?us-ascii?Q?3XB23kw3U3WjNcqPkU77HTf08JlC8lfuL4e2QfxqMLjNDrwWIhOkfpR9zQXe?=
 =?us-ascii?Q?92XJVk3DDz4S8C2ZvipIjef1C8jnl370ZZCuTKmwMT4aWc/UAVooWS8p3I9n?=
 =?us-ascii?Q?n2MDxccHOxpMGaN6pOnpboTHIyzhrWEwKvzhBkapmXDYrSgEtWkxBwkm5J67?=
 =?us-ascii?Q?nf1Sjto2zFoFr/9lNxliKh9P0es7ylaKMCrhcLb05yFYd79JpifJUAftp68p?=
 =?us-ascii?Q?OdN0Gd/jHUy4tbHR7V6V8Ag/3NBLmSkAhmdeLqRm5P0ne2ufLWIVel37eKYx?=
 =?us-ascii?Q?H8F60XFbYyIxbn4Qmv/LaWUFzQmrR9vxa2rxT0xd0nRCXJYYxin1KEaVwNx4?=
 =?us-ascii?Q?LSPsSm2NzTqmDAYJcz9TUgQJq1hLOdfRi5ezixG2hA77LXroBc7N42KWmlVy?=
 =?us-ascii?Q?SQdoIZqiDnYY2A2QrnQliSflA12QvQWQzbyIiA3a8lrLuDwZsrtwyLQ+xzzE?=
 =?us-ascii?Q?urHKt+7yvlM4YZD+sQeDGpy0/Ir0+3IO7N4k0ggeS5nlBmSmHFxbC4SqPdMC?=
 =?us-ascii?Q?lPi8STxZzu8X//JzLDIF4lZe6N8dW32kg7iQLO0KBlWGIv+18u5u3sbdPIGB?=
 =?us-ascii?Q?mTUSY5toaBNavTCnMVEiR6VUFxVkPO15bbvfzPFmU1DvOe+dNgqcvO8kTHXB?=
 =?us-ascii?Q?5qd9iWzSWukbJA17uK752eQJVAeFhpFX161X5Fhh6TXOZ5sOgFiCYo6nw+Mf?=
 =?us-ascii?Q?DXMSOGnN1tpTjkvuGsT0qKr3UqUQkIfPU5AUKB7+CoNuelTePYVkSoXpNVSo?=
 =?us-ascii?Q?YZ4IP92i8Jj7SskJgWqsWQfXe/Z0A+WW4iqpPWb04+1stThlGQmmNsLrZGNT?=
 =?us-ascii?Q?vVe4W1BH2Lqd4zGIMz4HB2LJgBAHvPiq9LlB3B5tLG0F9uIp4lZqeaLgxfxZ?=
 =?us-ascii?Q?bX2VaBJOwqAZ/AQUGxjXSA6W++Lda6I9+NAVkMgUKPRAY4xEKm01vT1y8qrO?=
 =?us-ascii?Q?WGXJFV0vGr7Yk5fJ0k4y3W4Z/zpFDAwztwhXw7x4HYvaTbH5qVcXME/6zeZA?=
 =?us-ascii?Q?HRmPCEfPYxuYmAQiwFwJwl73AIM1BknONG8TPctXX63OK+o4SFfhCJp9pPJD?=
 =?us-ascii?Q?GBa9Pt3UNAbKt3SxIYwaxdibB3k0WdB9aa+zkDrA+LZJWblH7fjZcVfA7Y/0?=
 =?us-ascii?Q?Kcg3MbMJmw=3D=3D?=
X-Exchange-RoutingPolicyChecked: Wq2tvGv6yshWvZPv8jUB6hmh4hBmfde663QTTZA93Dfwvhsxh6zUsMkEiUwvGgya+ROzxOFNJPn/tKTSDIYipJF+nFBByZ7LaHuTAmyAUYIV7vdKedWzihW19DMEKKwHr1sUdQPt1leEGnabwVEUeePFVdgHM0vFxByJmxC3czSKSkGLzoyCoTJ8k/wItSADb5c9FdQ2yp4SyAqW7hZfjnZ890dPZdw/OTjaJIOoAcDdyqm+wF1YZc8rULa7hnaw8tRCcu36HwimDerx28WYZtmIPfsqTepk3aiXzl/c9JYwusWdApi8QTgLMkUBoyQZSMb1hiIfIWC4bTQpbvJXaA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e0dd5de-0ee4-42bc-1481-08deac60a6a9
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 17:47:04.7899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: whguC1GpCw+LXV+dRM7EPe0rEC5U2NZQ7e4mhio4fSCtqQmMRf72sWq8Rx4FYdXyx2lZw92yp2x/7sAx1nmXvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9059
X-OriginatorOrg: intel.com

Reinette,

This looks promising.

I'll split out the missing call to mon_put_kn_priv(); into its own
patch before the deadlock fix.

Going to re-run the tests I did before forcing kernfs_get_tree()
to fail early without setting new_sb_created, and also late.

> +/*
> + * Temporary forward declaration for testing only. Move functions instead.
> + */
> +static void resctrl_unmount(void);
> +static void mon_put_kn_priv(void);

Question: How much are forward declarations hated? And how to handle
this?

Moving the functions around in the same patch really obscures the
actual change. Is it OK to have a patch to make the functional
change including the forward declarations. Then a separate commit
that does the re-order (where it is obvious that functions are
being picked up and moved without any code changes)?

-Tony

Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D489137142
	for <patches@lists.linux.dev>; Thu, 16 May 2024 08:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715849991; cv=fail; b=V4xh5EqiQsSdCnmzD96fl9pLoaaxqxCkvQ2x1zqSrDLKlNP8v4FpPMfTy8UFtF6nG7WWepUc2K/n7LPvmKmIrmI4meNW/GLBPbCcJd4oI6wELid5Y4nocvIMILqzKsZ4Rng7eEmnISKJzQ4cYIcsUf0Kbz5HE56e7MpD1bPOp2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715849991; c=relaxed/simple;
	bh=hRhlbEFt3Qa0hA6lSyszqENPbKSjYQ4knGDaG9oaoms=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GAcW3qPWTW0pDl0xf852qW3aQJSLB97jUM5oKm1+iHda5qVQBdn5vo+Y0RPCmM5jKJqoOQQ2wRBCvTNSPOq95xvd3idrQHWWs1xCP34fWWf4zZqPwAHEWz5byfkQqZItNla6HPWJeRnff5pY3cL7Cw5zAvTvz2L9UGUYEDCjBvI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ypa1U2sv; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ypa1U2sv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715849989; x=1747385989;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=hRhlbEFt3Qa0hA6lSyszqENPbKSjYQ4knGDaG9oaoms=;
  b=Ypa1U2svGURNzmc+Ti+52Cx5t8rqhKsoVfR0FPeJysJhgsqMJ/+rv3LK
   5ASMzERxKqs+Rz44LoZ6L9skpykhQfT4bh4cK1RQqJPF+1atb4aF2EGcu
   4uYEtiW3kTxi5kp2bhOq06hghJ3HHY+FX7BPbF2yzjZSe0gdf2zrJ1ZQy
   U/pwfjVYTkUqs+mRXDiPj2S9q7IrgqVWHejqm4Ji1Y1FY7VsbsNnBGELv
   xyGGT31DhfUHDA8UgEIPyIodXBJjvD5Cg4vPb4lvF8Qhqgu+lK9STvrxi
   KYeqdhvV0TwthS9F2CSxJex/GpzfLzRLf4q54ludBCqzHR5kz3pa9wIpo
   w==;
X-CSE-ConnectionGUID: /PBDcjvPSbG8w5KMPZ1sOg==
X-CSE-MsgGUID: JBn2sPzmR12n45IE0NUt4w==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="23084240"
X-IronPort-AV: E=Sophos;i="6.08,164,1712646000"; 
   d="scan'208";a="23084240"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 01:59:46 -0700
X-CSE-ConnectionGUID: 2QcASmxATa2llCajtPxJIg==
X-CSE-MsgGUID: 2rWfaDjXTGeEkX+TaPiNnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,164,1712646000"; 
   d="scan'208";a="31186869"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 01:59:47 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 01:59:45 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 16 May 2024 01:59:45 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 01:59:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iS4TFotkQOcMKz7EtGJoh3KUJVGtlhR8WWCZ+7JVMZxdeR9lK3XX4irsV6nFzWgib6GdAEI06B1NbB19gv5R/ACDs9q9Z0iwTyGkU3B14wjTVmGp3Y8sqCDkHzyqC1aJZdbTUZlQtX8tmj0rVsnOEbEk+/1+4UxV/M6frIH+qJvva8QeprGIbh8g/9MK2JFdjBySHI0tFVasI420bMUyay4eOUuF8KooUTeTsFJ1PKOClLU2S1jwQ0rJz0qA8x6jdjjbQn28ylrNXU1h/+MzB9npbaX3lmk0XC/c/Nb1UxeQJDjk3lx6fVRB2UVyYicwSKLVeun6NhuKatnLac0Lgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YvYTHiuMwWFveURn+YZOsVTUjEDTmYAdLm28jr36waY=;
 b=HYek0Ue8Rcuz8nnJ0nk8LzYA/3hUKtE1o9Tlm0jKsJTQrKEL2ng3OGR6CKUU3aQCUw0O1wjw9GgcWxQ2iucCBcODfjWn9wT1paB9bVbMTKpgMoH/2REzMZucf1RWU97qNOq21ozN906jH2scQL3I4NON6SQpnE25wojhM3PNHyF5m2y59QDuBpehMoRwJ/pxkPDFo5Hk63HiTcLpy1O4BJ16bRFkeA0BDx1BFA5kHTM2hw7fkEfg7Oxne8XCFJfvJJm0AgI4GZe/y6Ja8w0cz6scNdukkCw9SlvrBhkEphNl/y+4tZ/etdEsSyOrhOc3P/Gu0Vc8wHuxGnFw+liU1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6231.namprd11.prod.outlook.com (2603:10b6:208:3c4::15)
 by BL3PR11MB6337.namprd11.prod.outlook.com (2603:10b6:208:3b1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 08:59:42 +0000
Received: from MN0PR11MB6231.namprd11.prod.outlook.com
 ([fe80::a137:ffd0:97a3:1db4]) by MN0PR11MB6231.namprd11.prod.outlook.com
 ([fe80::a137:ffd0:97a3:1db4%3]) with mapi id 15.20.7544.052; Thu, 16 May 2024
 08:59:42 +0000
Date: Thu, 16 May 2024 10:59:29 +0200
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Peter Newman <peternewman@google.com>, "James
 Morse" <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, Drew Fustini
	<dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v18 15/17] x86/resctrl: Fix RMID reading sanity check for
 Sub-NUMA (SNC) mode
Message-ID: <erfy3evknfb4qiraahsx3jlenuduavduaaotmsvgvlxww6tdqb@jp2lquytvpzp>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-16-tony.luck@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240515222326.74166-16-tony.luck@intel.com>
X-ClientProxiedBy: DB7PR02CA0033.eurprd02.prod.outlook.com
 (2603:10a6:10:52::46) To MN0PR11MB6231.namprd11.prod.outlook.com
 (2603:10b6:208:3c4::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6231:EE_|BL3PR11MB6337:EE_
X-MS-Office365-Filtering-Correlation-Id: b933eb57-1b61-4aab-2184-08dc7586866a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?o1d685NCLsNDjIy4235hEzPCy7TCl/uZ7mhawjBcI3nDfUQh0yknKmkn5f?=
 =?iso-8859-1?Q?WQ4iEkZI0v4UjX+/4hA23YIcE9/p1EugmoE2AwPW+0JlaAbG9U4tkZWKxL?=
 =?iso-8859-1?Q?vlWMap4MPVIXpsS6AmTDHYVX81MfT9CawVRRWChCAhMyJtRMvbsnigwylJ?=
 =?iso-8859-1?Q?q/T02eacL0JJwNaz4N9IKzXjGVl0M5iiXEKqdXGfuY07GyB4SAhngF33YZ?=
 =?iso-8859-1?Q?LUIEXvxrw+YZsU+TWPAnTeUhLVwkowLh766Qm1roVzRh/mfhSSt/0v+MT8?=
 =?iso-8859-1?Q?yoUKb1G/+AdDS+B7inWpK9qyIXjjDeaN9w/irRZgWpSXsWcoHUtrSxz7lN?=
 =?iso-8859-1?Q?13zKcm9Vvc4H0e48C+JKu9I53yFph8HySCR6zbVVVEQPyZx81noEI9pPDw?=
 =?iso-8859-1?Q?C3OKI/B5ALKMQPbwIUcZLmX50kMiamjO0j3xgif+hCT/JYL+4wZV1f9w/7?=
 =?iso-8859-1?Q?YzekO32nPHuSoUnj/Wigh4RUN1/blUH+gxKoNofkUpTho21AvcWvAeSrDG?=
 =?iso-8859-1?Q?1cEwD/Ygbrn18Czzk7kaWAGtdqHudoH98lB+vgEEu8Jyig2BPYdB1ABHM7?=
 =?iso-8859-1?Q?H6E1lRpDzYfpIGCP4MJCm8SrdDVUMLo8hPaKtlc72tkS9Zj/Gqh+GvLm5B?=
 =?iso-8859-1?Q?R11uT6hj5XbWIz1YpGaX8eQllOBSjMGgiVdNtVUrOOGzF/KO7eWRaMqMnA?=
 =?iso-8859-1?Q?zDAPNDTOBTgNYkda0IfIgP6je3wLQuD/vCibElsZWRC9TsPrLQ+IJsrKO4?=
 =?iso-8859-1?Q?eLsFoBXt8oDnY3oevBpXDlsE0GVNm+eem8ixL/l07fL0FxZWTTgYFyvtDu?=
 =?iso-8859-1?Q?wWgP9cJLTZM9vvEJTCu0WzvRDHzjKibH9uplIgYS6Ik6i45scM/MKXT7aQ?=
 =?iso-8859-1?Q?YAGzdi8u0SocbHuN0JfCnN8Ax/LSFyPxBz6+tFRkg2BdVkbOoJ03ojXdrC?=
 =?iso-8859-1?Q?CyJXLeI/PnuryiQ65mSanLNT1rN+E0dn1lGGubHd+OKd5BO12rn8bIP6V1?=
 =?iso-8859-1?Q?LSknnSIshb71gaHdoaJQAJ27XKQBdZ4lzzkYih49Fr6WLXH5w3MIw1IQkS?=
 =?iso-8859-1?Q?Zk3R41k7Lmpls/a3+iX1MhAjkvhOzRViDno7MfcLINm8OYjHDu8e76mVOb?=
 =?iso-8859-1?Q?6F8So+TgW0BjstETHEGd+9j3+lELWR3PY3+3Ee+ASxBiGewlePWZaLvtLp?=
 =?iso-8859-1?Q?JCEmebdTStozehk4qsp1LXMU4blY7RBVn+MmU4CtjWhoT42n+XaB/vrM0A?=
 =?iso-8859-1?Q?hb55JKqdPbx/k8yyZ3r6/MV5f2raSjvHsZ28eyKkcMPNDwkHE0FSHmIAIP?=
 =?iso-8859-1?Q?wLVPHUmp2Z617lX3HBJnkAY/0A=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6231.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?eAIQFM6v/ROi/D5wcic/tIduqqjfgS7W/ompQHa4AcrMqzuN0AAt2lOpu2?=
 =?iso-8859-1?Q?kZVQiGzqMeXCiseiA5DFIzl4yxpArWjEF/ngV8Spgep3g2q/2zs1te64ir?=
 =?iso-8859-1?Q?XFzmZfYYeQrTWH76nP6t0tlsIFtSgog+Er5vnzKTuDCx23CxJGD0NYa5mO?=
 =?iso-8859-1?Q?eUjOPquyD62lDx555s2fjwG48IKgvL7BQxfLvcRKkBxJJ9YWM9mHoxVRAQ?=
 =?iso-8859-1?Q?WjsX+jnejJH+YnFepY1iikij4zr0RSkFHBby2T1tEfL4DkptVeWsqLITWL?=
 =?iso-8859-1?Q?wMkiY1G7srNUmrf+S8019zc8iwFZW1oLxUPeN7NLEL0w/T1UGogTffoD0b?=
 =?iso-8859-1?Q?Yw4KshxnJSk1AjJeWjckPVpVDADQgO/UB5JO/SSvt1z08qEBoA3yr0cDv5?=
 =?iso-8859-1?Q?ZsUR5cLrFPIAfOHv+RzqIy4WfF/gv4W86H1evZlId5j/0NFgxdM/+9r6Q6?=
 =?iso-8859-1?Q?VW1eTuPVpvLpU4dGX5n+d0zdHlSvgLDY2ya8hP+jOQmdgosOcqcIZKOJNj?=
 =?iso-8859-1?Q?e0voPcm+MXC4KWBDdh8hdhgyD2tMnMJ+uau6LMmoh/s8NIkSe/9SzhxVbU?=
 =?iso-8859-1?Q?dQQ4SRrY1AIjIld86XpNHHChyNMxJY6Q2qOqX1iEp7YwhxV34eooXEISJd?=
 =?iso-8859-1?Q?lry1BeTI6yM7IHH6Z4QEQL4ufE2U1om46hmWc8ldJihCHtYAfO8vLRmjhM?=
 =?iso-8859-1?Q?HlvNW2WYlh0u/+5pAGlhJfOu71yF3MuQo0MhM731GX6XTG48jRnPpJTmsc?=
 =?iso-8859-1?Q?KccRm/SOEHkUFGbwzgCTkwR1jKFQLnEnppuQymk9jCMBZcGECGWPgWSV65?=
 =?iso-8859-1?Q?sj5HU6XVowKY+oNPxFqU6U6y4JCR9Tk7ynMaGayvIiJ4C+HOt5gwwjPTwO?=
 =?iso-8859-1?Q?0uemAADngYhHuFPfUUV3LXf2fAUTKXCDuZ2D63G7erHMaMMvjZoVmSsWe9?=
 =?iso-8859-1?Q?n3yvvgTjhMgkmSPEdz3AZ5A+hEHvKm5GzXAgxfSo47qNm4KZduM4g3bQKT?=
 =?iso-8859-1?Q?mG2YrvYA/pum+PGliF/xzDBfStnAQU7fKnXmpQB+1kgkp1oA4Z0vOmfBG1?=
 =?iso-8859-1?Q?9gWwepVLFZptnbQrn4DXi4npyPUqa7nHAELKVWzCqiqyTc6Ih5nXYhqSEu?=
 =?iso-8859-1?Q?GXvEDuiftifHn8CEwzdNtjRYb4et/4GXiuUaGcBXL8OWedJ/yj3041sHHn?=
 =?iso-8859-1?Q?Qsx32mqmPjFugmeMd2HqjX6X3ku7qSwIen8sTgrYyBrHi6g6o4Vug8r0AK?=
 =?iso-8859-1?Q?fbKxbpLQSe4f3teG2gJyCTQHmLKWHqD1cKFjNOINGFVbX+zm22sI3DMKF/?=
 =?iso-8859-1?Q?mr0aGNTDuuSPsnaZgG0vvqPOBfyEDSjm3ujeMn8So6BdhlkrmxNRxX90ex?=
 =?iso-8859-1?Q?ATrYyRLXp9aA6fktEmuxQ1JgzJCGnHYs7bQ7tBvePOx6nAxH0SSa67yzjH?=
 =?iso-8859-1?Q?ywY4/RJ0F+4v5qH5uTslX7f9flumCSjqIGml0MmMBE/2SQtVZcjvQxXKsR?=
 =?iso-8859-1?Q?bCbQ6DT95XLLc/ViCHkOdDlCdx6/65z1xi331WXKU3rM8z7D6E4bLBCp97?=
 =?iso-8859-1?Q?nLrRQTrpsRdM0TtuUjrHOuNLFfO9P4wAH3KqbZQjbvV2kET2u6rQHKt9mN?=
 =?iso-8859-1?Q?IpUfD+zrSS5XnlpwP34020vsPyTgXKzdYfc0JnpGNBQnkwTUpuykuS+0vL?=
 =?iso-8859-1?Q?RXmFxfz7xDRPanmPnbo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b933eb57-1b61-4aab-2184-08dc7586866a
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6231.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 08:59:42.2614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pcngXLLQlyUQD3eAJvj+kz5vKGh5px0tm2nViEBpae1ir28+cgniXjf1VSGMRP3XWFW+64lFN7aJkM7Vu2AqKGXj54VfcuG5RbMKKc2vLfA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6337
X-OriginatorOrg: intel.com

On 2024-05-15 at 15:23:23 -0700, Tony Luck wrote:
>The sanity check that RMIDs are being read from a CPU listed in the
>the cpu_mask for the domain is incorrect when summing across multiple

the the cpu_mask -> the cpu_mask?

>SNC domains. It is safe to read the RMID from any CPU that shares the
>same L3 cache instance.
>
>Signed-off-by: Tony Luck <tony.luck@intel.com>
>---
> arch/x86/kernel/cpu/resctrl/monitor.c | 15 +++++++++++++--
> 1 file changed, 13 insertions(+), 2 deletions(-)
>
>diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
>index 668d2fdf58cd..e4b92c7af71d 100644
>--- a/arch/x86/kernel/cpu/resctrl/monitor.c
>+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
>@@ -15,6 +15,7 @@
>  * Software Developer Manual June 2016, volume 3, section 17.17.
>  */
> 
>+#include <linux/cacheinfo.h>
> #include <linux/cpu.h>
> #include <linux/module.h>
> #include <linux/sizes.h>
>@@ -281,8 +282,18 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
> 
> 	resctrl_arch_rmid_read_context_check();
> 
>-	if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
>-		return -EINVAL;
>+	if (r->mon_scope == r->mon_display_scope) {
>+		if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
>+			return -EINVAL;
>+	} else {
>+		/*
>+		 * SNC: OK to read events on any CPU sharing same L3
>+		 * cache instance.
>+		 */
>+		if (d->display_id != get_cpu_cacheinfo_id(smp_processor_id(),
>+							  r->mon_display_scope))
>+			return -EINVAL;
>+	}
> 
> 	ret = __rmid_read(rmid, eventid, &msr_val);
> 	if (ret)
>-- 
>2.44.0
>

-- 
Kind regards
Maciej Wieczór-Retman

Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CFB30E83D
	for <patches@lists.linux.dev>; Fri, 12 Sep 2025 17:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757697603; cv=fail; b=YlALMBZS6tdWMChlOrEE0B/AzXDv5Lt9UhWGQvKdO9IfahLJBRyAVsuwybyOvYMa8Jm7NvUHelN20EAPpWGMGhluN38JUmnE0IDV/mhsMhxbMuCbyY5jce9GlETu3XkQOGPvhm9Q6BCkCpI8oczNqyOSb6AWQwW/ipHA+uqGrjw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757697603; c=relaxed/simple;
	bh=dKcITJ94p7enFvTzW7qabK7hcoLLxQ4Pub6RBaveIZM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lqE3/48aBUi741A9Uvh1oNEtfzD4sH4ZcPvfqQ1rLjCoB5ETJ+bEOcQTcuicAXrYakNs5/L66Wrf6JAXlkT1UVxf684o7jYU8DoPQ0Re7HwS5tyhnGkoBm3ndxYIdRzKZvypvPRNCSW6qicWn1szBVJZRqMPao0hWDnM5dv+D8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UqawzAdl; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UqawzAdl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757697602; x=1789233602;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=dKcITJ94p7enFvTzW7qabK7hcoLLxQ4Pub6RBaveIZM=;
  b=UqawzAdllJzE/TdrPURBFhe5CItivrVQjTwxAxMgLBwbgrUAyLScgzvC
   TeBef7laBU6zujhBrkQZjEcxlLgX7bc+9JGCn3wz/9cske2RL47Fd9/8e
   Yuxh1MEYcMVlnfgKqUN0yFbVVKMWAclwnTug5CYeuY5BRZz774nYQ1/vP
   sTXP3fpNw1XAL0OwX0G4VqWusE15iEHf0zDDAjCfci0Nm5EA+4p9xVAdo
   qWqKz3z5Bt6j0LyzhQBQKeRYfjQC1v6IrjoHLZ3OVJdd84CjP+Xrk224Z
   jVA8CrdFSod1bFbriqPayw+SczVOqmFrUFJo8oaUmLFwXh1EtmgFfiTvD
   A==;
X-CSE-ConnectionGUID: aNvi9Q9uS+mN9fp+u9HDkA==
X-CSE-MsgGUID: lBx3Us1WSvqWCrpOxbrTVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11551"; a="63868635"
X-IronPort-AV: E=Sophos;i="6.18,259,1751266800"; 
   d="scan'208";a="63868635"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 10:20:02 -0700
X-CSE-ConnectionGUID: 67cWov88QnWbbXjhnzcFNA==
X-CSE-MsgGUID: eEPrdappRCKnLVZEztzgsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,259,1751266800"; 
   d="scan'208";a="173563087"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 10:20:01 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 12 Sep 2025 10:20:00 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 12 Sep 2025 10:20:00 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.81)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 12 Sep 2025 10:20:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vLNU413OlrWHmqUGFNEhjUJAkfi8lOskmeNuBwQpxSdCh0Dwur//2Ps1Uxk3iK+5Fi8W0FtWwv8+upUFUDMbVJ9y7eb+OTN/svAsm7sBfc8h5tASBUAivzgel0yCunWotYbK8+5p/GsiIkSpoCMm9hniiBKXht9iiGSswyXWXvzCriFLJbkD+Msnk97G7w0H4zFpQ1K5byNDEPhhKx+xJcz3z3Tv89O9evWDvmOzxz7M+u7YvVACwkxpFopmM6JpM4JKCWnnSaL+D/32dybWnpsq+MSmPTLz0eKLJOFd1OBNN0925O5tSNnvXWMdPThEqO/jqe1UpNhTCXWX7gsWBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qzAR5PZVKgoiEmx4pbCbkxx8msyQjkxZId3OeAI0Ik4=;
 b=oCGhB6gIUbEarB/URU08ZLSVL4V5E8fiumlY4jyDczagl76reJJaWlL+wz5/ra9ujlhNtmsIhylJ9AJF9qaaoz9lAhdF6pGmNNYiEwUvAxMBRrQvXWL3rKvcrN1fmzbJ3FjkiT48Q4bCk9JENILLbwGrBa5KZDGQxlyQjtx/oa/Me9mD3MkLedbWnrxVCmojCkngzdYijJV+6Z+hbJsRhndPEW3EzFEaLP/UCYwyHatYIQP52A/dUSAjTNuWDeCHFwreH+vpL3vKE0aykev7Ob8E7PoAv4kx+ojZ7g9ZuYOl1Hm4+6MKWMHWkRoJ1syvuGJi2mFX76Kyuf7J00Tjfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MW3PR11MB4523.namprd11.prod.outlook.com (2603:10b6:303:5b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 17:19:57 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 17:19:57 +0000
Date: Fri, 12 Sep 2025 10:19:55 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>, James Morse
	<james.morse@arm.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	Babu Moger <babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, "Dave
 Martin" <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v9 25/31] fs/resctrl: Move allocation/free of
 closid_num_dirty_rmid
Message-ID: <aMRWO0u7OKhX-g_6@agluck-desk3>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-26-tony.luck@intel.com>
 <3ecedad8-6283-4141-9f44-2ac126796ceb@intel.com>
 <aMNMpMns47RkJZg-@agluck-desk3>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aMNMpMns47RkJZg-@agluck-desk3>
X-ClientProxiedBy: BYAPR01CA0010.prod.exchangelabs.com (2603:10b6:a02:80::23)
 To SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|MW3PR11MB4523:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d703f3e-f4f0-46ff-5620-08ddf22098f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SKhjhO+p5RvNMqCZHMSyvEXV3Ugpp7G8eDBc+5Cd+tX+BMIzRkRTHr+8IJ0N?=
 =?us-ascii?Q?grKCElIu9dsqzaMpWp0ovgPhkLEfFO6eHQFUc9CJJns5pOW1swfwJZkOP1DD?=
 =?us-ascii?Q?nSNdeStupCwJeuyhNbXLOZqKD6N8LuGQ7DXsac1xzYNM/9NYu2bxhnHdFncw?=
 =?us-ascii?Q?TYcv5VVksG3jYdYxCZ/Wtvo4+DjhvfJb3mUNohTPZ+MLRgun2IfiIVkPBH59?=
 =?us-ascii?Q?yPlmKYvKmwEeNusr4WVo9zjV1n8fB/3cjxqO1Z+exJtW/d7cIkuy9Cohr/TR?=
 =?us-ascii?Q?7zncJBBsLgljP+MyFGJhj2bpMu42A8GP1qvNH1b73IOA9ToJzonLrXgueNyA?=
 =?us-ascii?Q?Yn2enLzS0jw4KFt+RS6ons0D4LthlG3LJ8Ld0JRA7cqORwZndNHlqJzpd1Vm?=
 =?us-ascii?Q?lM3463BUdUYAOOyzSsKKC0gVfxaWQRAK0jYw39JIbq+U+ZbXxDZ2qEARcnyv?=
 =?us-ascii?Q?sOYafyy+yT3Ym45JcT3bDXIDCnzY9u0lM+qiB3o6ODJ1tx+qsIoJ6B+RCDxf?=
 =?us-ascii?Q?+T00DjQ+VV+d/5HXSnhwFeGX83DUsj3rMZrZO+UyA0EKhLaEDGs5erXwUXG/?=
 =?us-ascii?Q?+eVE11o9E3iFerDOW5HtSir7TqwFs/RPuAk8vdY94W2RqwTYLs4pHR9lFSfv?=
 =?us-ascii?Q?VctT+ggOhwE77cRwKRnomT7dh4mRSVSvRZFlYi0dK735kDt4IuMSdb5F52Ag?=
 =?us-ascii?Q?v3iG3eDjGDLoy6uspgG60nUvH7mOvr1TVd8zNQX/zWOnASo1Lhevn9hBeCSE?=
 =?us-ascii?Q?lKV+CL7yat3QYqmn6yHxcRegPJ0DFADLWpEk6cSo+5qm/R3qA5wvSpm1hLo7?=
 =?us-ascii?Q?8YTAEj8Mnb0zpljUD/xc6oOXWm8ylwJSm6mDTS7hralYNqfXIKDJJ9CWskQ8?=
 =?us-ascii?Q?PJ5zLQn/rmLU5D4DXn4bKvSiVhZX0nH+UsW2lZJcRwsjqBUJgaQcB97+1gwu?=
 =?us-ascii?Q?xBtVqIzsUBGMymlXU8Ol19kj5BYXsvtYz3pUMgvpR3XHmQL9Zc6BQPLwZCy/?=
 =?us-ascii?Q?4p+7xFgqw6WWB+6+wCKuRsQEQMeat2nu4cq6J/zJW+dE8sPzUbfw8lZbw1Qk?=
 =?us-ascii?Q?89NeBL4GAsI1CkISreyPI7AiUhwa+9nLtb+GtkmKeo70NfaW00zf7M2LnR9x?=
 =?us-ascii?Q?N1OfJHqWo0u931aAjABnAhYbg3/5FYcTCcx2SeXx4moM2pW2mAKiiGvX3BtQ?=
 =?us-ascii?Q?DNe+jHrshYxiFvMX1bi3fp9JPxAPJIDga8lIduqys0DXOVkiH7Gw6OkO9JOS?=
 =?us-ascii?Q?LKDcEJEEB1flhsXe5nuLPtdD0AKBDeOvZjJUm3OJ6Ls9TRLGH0Ai2s0MIEwo?=
 =?us-ascii?Q?da9GT0UBVeOzxQBWe3Gkjgvu2FTqyRjMpdwtQ4LPnFflWUGmAKRyecUgJegt?=
 =?us-ascii?Q?R8MhtkhdYg9g/oDspbJWT5qqSWZ0ys3aGXRuXnXRX3NuIH6Nr93Z+mpeOAqv?=
 =?us-ascii?Q?c++f4AZ7Pjk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9+8oEioQsJwUg3Q9X7HkL71h6TBFpXowtXEeNwACCbx5mJuL8KgQuRgVa52p?=
 =?us-ascii?Q?A5c8M222BXovYf00zLhNSd6WuTyiOsiXm6BgMhjyMfXK0z/ZJRy1Uma1reN8?=
 =?us-ascii?Q?6A0GyGFNj4dm6HqoDl2CGi+hZEGKf+XphTDx/2Ws0+wzJAYVas1yaHYLkrJi?=
 =?us-ascii?Q?p7nNwHpTPQ7xBWY1bA8bfvTboFAp8hmkND+manSe9tGm7KHYItxbVSHnzXB0?=
 =?us-ascii?Q?ZxCqI1jzt8Dnhn++Kke3eN6L71uiJmR2GZVTzLS3Pk6/PNp78uJtxwMq0CV5?=
 =?us-ascii?Q?RHGhWXHmX6sWEqRUe5j/9iBmwwNyIaqc/Pc0B8aJ3axcfAtZWfDOgHRI+V7G?=
 =?us-ascii?Q?nBeyU5Nfbq1oXkneZXYS9YE7MnRnx6mBFaDv5N6GEmT9YpEVjUjdOIlK/A3D?=
 =?us-ascii?Q?rj7gZWTGC5rdgDdPCEzjitjbo7+y7eqbUzTYTvlsg9YZfOSqDPtmFkC7czFm?=
 =?us-ascii?Q?l3GaK9I/MxRhFDAiQHjQUSS9NVlqpxInlxI0RTMFUzyo9DPN5kUx0mzGtJOM?=
 =?us-ascii?Q?Z6kZBQrUGwn9m5jvi+LfurqfXLFrBn7qfVYxO5AA4Q8qqd4G2fxQdFbUYw9G?=
 =?us-ascii?Q?CKSO58Hhnv8qXz5lNPYuMzvY+gO5jtmuOZwNSM8f51/gljdVqeIS+oDOktOw?=
 =?us-ascii?Q?QErV+BxSby4PdvHyA9dQ65X2TKMGlFrdtT3CYmRTZot1xlEKOONdVxDd+q9g?=
 =?us-ascii?Q?Xv5YIk2HLhaVy9Svfu5Ck+HiVuV5HG4UQwG1/q2txZ+vDqVzDc4jq/1oJqRG?=
 =?us-ascii?Q?3rSM/rYjhCjxam2xuNIKSMXd+OA6u7N4q2p1oQ1WyUiehaoi9tkPO3Yf2SR+?=
 =?us-ascii?Q?bRa6i+zAQ2RMkkFFAzZBvwMlkuBSUX4X82YQCkBQTv9YlyNLTcVCBuWQuJC1?=
 =?us-ascii?Q?RPxN+jcqrW2/ZcEJvh5XxDTVGBop326yrCp3vZitfYvCeywDnrlzYkj0gkOq?=
 =?us-ascii?Q?HEic+EV2Uc9VJwlOQZiffbWD9QIjkUCeMGsDFeKINq6cVpT8Sg3SFwJlGyjA?=
 =?us-ascii?Q?OJOaz0e3Uzn13MqfiAhUrSNdIgl0XVBAIMP0b1ljJ2hDdBz0usqkI9DwX5Km?=
 =?us-ascii?Q?fVrPbOqIyzTqCbROlImdO8/kNixA9jOTwcRoFeuPQpFCHamcgxyd5DvJUUp0?=
 =?us-ascii?Q?uGGm+jkZFlr4zVmFxhwRYq7dRIMd8OAPXeJNom7YS/ji6lMzdI4X3bV01N5I?=
 =?us-ascii?Q?snXS2qkki1DFdmRaUppKGo/gBIUSozWhUMsn0gRrJEJRz26eskrrg58QQRhQ?=
 =?us-ascii?Q?Q2/C+2c+7hT4e/UA0MD1hMGmAPn6erJB1Q3du1d/sVoTMB8BNFVYWM7fh5fV?=
 =?us-ascii?Q?16ZXim/jT8jXWQAKsRZheabp8evXLkQXRecnxmf6Bo3L5nz8zJDscQCRAvMN?=
 =?us-ascii?Q?Dub/UrQyXyEEpI6xRDnwGHh/lBxY0Bd27K9RIFAzN/LFaAg2UaLtOID+Do91?=
 =?us-ascii?Q?EGncgFL54xeoTavsLVKrGhMk4M70PuNDqAQ8w/TXFOd+PgVCvELYqXr+HbpI?=
 =?us-ascii?Q?+eLuOvpGgDVsmcXGN3+w9QPhgR61SVlhqFVUp5lHkimo50a3Jnc04ia+OZkh?=
 =?us-ascii?Q?AOXi7pEm1iqWFGM/OAyW1PacFYf+60XYc/UCHsHx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d703f3e-f4f0-46ff-5620-08ddf22098f3
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 17:19:57.6968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TS2iSxbU7RkBiQbxCqHXWYYlRNQLjPrUwCfhYQo002CzQKlJ8ZvNVQhwniiXHGH8clj2x3C3lH5nADDRlDhXIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4523
X-OriginatorOrg: intel.com

On Thu, Sep 11, 2025 at 03:26:44PM -0700, Luck, Tony wrote:
> James,
> 
> While refactoring code, I missed moving the mutex_lock(&rdtgroup_mutex);
> that was protecting the allocation of "closid_num_dirty_rmid[]" ... and
> Reinette caught this change.
> 
> But looking at the code, I'm not at all sure what protection is needed
> for the allocation/free of this array. The current calling sequence for
> allocation is:
> 
> Linux late_init
>     resctrl_arch_late_init()
> 	resctrl_init()
> 	    resctrl_l3_mon_resource_init
> 		 dom_data_init()
> 
> which doesn't appear to provide any scope for other CPUs to come in and
> start using closid_num_dirty_rmid[]
> 
> The free path also seems safe too, as all resctrl functions should
> be shutdown before calling:
> 
> resctrl_arch_exit()
>     resctrl_exit()
> 	resctrl_l3_mon_resource_exit()
> 	    dom_data_exit()
> 
> and if they were not, holding the rdtgroup_mutex around:
> 
> 	kfree(closid_num_dirty_rmid);
> 	closid_num_dirty_rmid = NULL;
> 
> would do nothing to prevent some still active resctrl function
> from tripping over a NULL pointer.
> 
> 
> So, unless I'm missing something, I'm planning to address Reinette's
> find by documenting inmy commit message that holding rdtgroup_mutex
> has always been unnecessary, so it is dropped as part of this refactor.

James,

Cancel this request. Reinette pointed me at the discussions last year
about allocation[1] and free[2] where you descibed how memory ordering on
ARM might be a concern and the mutex makes it obvious that the access to
closid_num_dirty_rmid is safe.

-Tony

[1] https://lore.kernel.org/lkml/20b566d9-448b-5367-b4db-593466e7a2f8@arm.com/
[2] https://lore.kernel.org/lkml/52f81c45-efa7-42c7-86f4-fc1084b1d57a@redhat.com/

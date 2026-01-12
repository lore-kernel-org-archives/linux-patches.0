Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FA53806BB
	for <patches@lists.linux.dev>; Mon, 12 Jan 2026 18:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768241345; cv=fail; b=jSy9bhcmPPGKUhoc54x2TOtXu6T0DCr/QDrSVNPjlOUCVzi8gZZJyv0xsJoWY2V8c5dLObVRKrhaKBVCWmUecED9o8I/KixxecYwUfEPR7OllOfB1h+SqCftUFU9fHiJ+t1tLt9z7cimlYuFle+6K2NUlwU7tbCyx2OnpvUdJwM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768241345; c=relaxed/simple;
	bh=uE5VztOdIkl68hSBql+T8pB64nLtd22ON4o9ismeMcI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PL5EHIifUQv+tkJpAYT3xvxuhxlQn40EUTr1YRO2ttfrDctHxbx4K3QDh25mu4yxm2dCbYTljVNWKmMaUcURr3xlGXUjbwZzPhtPq+BvlHgtaH/DRkEfd/xGbZnfVenpDVNRy5nj7lSrDewFvs8ojIqzK5MPc0nrD6iBVvKrBKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PiQtBuEN; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PiQtBuEN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768241344; x=1799777344;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=uE5VztOdIkl68hSBql+T8pB64nLtd22ON4o9ismeMcI=;
  b=PiQtBuENNzsK/HEQl8A6hN2gcfXeDjOHl5Iqaw4QnO8mdaCIM1iazRtf
   WLv/pppXAC93A9lb7Pc2eEG3wl52I7AnOBFubDm8CZy4BJ1McnLhfuRSE
   edUhN7bnsp27fns9LGNEyilVC/ZkZhkh5HG8f5CUyPkr4IZ131p/C/Wjy
   /PotAynw7vfoohzywYcTRLb96+aZVyEVZ/wBE6uJeDUjetCWmcFaHrlL2
   Yx7vEM64YUzB+IrnobAvVG2DD476RArOxGkf0mgBK/nHVXgmHvmysZMRW
   xJC5VeHg+7MhmH6iswA5tnLwWJ9SpRjzKyiFB7FCMvRB2PEVB13xx9LIr
   g==;
X-CSE-ConnectionGUID: 8a6GX35OQoelCSfwW7b+xQ==
X-CSE-MsgGUID: zNMYfUvDSDux+X2LADD/3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="68727106"
X-IronPort-AV: E=Sophos;i="6.21,221,1763452800"; 
   d="scan'208";a="68727106"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 10:09:04 -0800
X-CSE-ConnectionGUID: Eg+hZ56QS5u67iTJ4CJF9A==
X-CSE-MsgGUID: fAq4m9qbTNekZFOdYF21rQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,221,1763452800"; 
   d="scan'208";a="203790637"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 10:09:04 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 10:09:03 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 12 Jan 2026 10:09:03 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.6) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 10:09:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pD1RnUlDwecGorlAbwpTegKnI1JJta4NOSK+sStczTXQ6XjAApPMDFfRmMPTgWR9DLy3FvBuPo1TiOGV9A7Z3mPyxG2qjwt09a2qbxDFCPbRiOPzca6WmCrDgTecOM833TybPVjEsrcuzj3zCLvEnnqvyhTyxYpkI/SS1bmeFST/Cw09mHMzUvlrUDc2shSBWPlTLJ2ZWcuuOT5c+CaZbGWCQvF73To0lhMD1MerMqmekaYI4RnxgyXkoheOlCusGRH8en9lpAtZ+6FOKZMMGX6AI0UxVI2F8JMDOXtn1kPDUiLXkRvfPKOawutYcMGTSCi3Q5/6fNx4PYdOJ0xSvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s4HhUoW15lDui70qAFe8vGPT0aFQbulUDYistTadrxc=;
 b=SxlfkbcUgpMfVIqS0bWU0dqxwe4JKeeVSEeNVG2zyZXJKOlISyffjAF7X0yZ+11mYuPi1A4M8FCgaCMjqtchi2FWPIVYQt0y4ZJByX/71IK8ucHzcrA+q5zUreNjNFvyKXz6Y2c4wWgMvyHhbz9qgRDNwmziN850TMaXLLJAIyTy3oXUjRLb2MfLEFOXXS6hvkdVh720PuiWXWdaKtP7qAHgDKRLe/Y6FvpS4sitSkfLIDcaZjXWHP6PZ5mpSukvLsqBmXc7FnhOdaCsvvqkxqrLrrpE109eF9WCZN2ZP5oQdq3N1W/ATK/ntUjiQmOYRKcTw8Xnv0Fcd6ZRbpGhNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SN7PR11MB6679.namprd11.prod.outlook.com (2603:10b6:806:269::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 18:08:56 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 18:08:55 +0000
Date: Mon, 12 Jan 2026 10:08:53 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Eric Dumazet <edumazet@google.com>, Reinette Chatre
	<reinette.chatre@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: [PATCH v2] once: Don't use a work queue to reset sleepable static key
Message-ID: <aWU4tfTju1l3oZCu@agluck-desk3>
References: <20260108232717.14411-1-tony.luck@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260108232717.14411-1-tony.luck@intel.com>
X-ClientProxiedBy: BYAPR06CA0045.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::22) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SN7PR11MB6679:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fcd89e4-f429-4921-54d3-08de5205a67c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?k3pPVA90hPW7kwEeSK89SNoGuL08qrH+/rbj8Rf3vMknuFlrB4oFmGIzVyk4?=
 =?us-ascii?Q?fkttPRSZT3X9tThoTZEY6TXHlwOCm41ScEch4oKGAGPjlSVRHCXbx41pDUqu?=
 =?us-ascii?Q?K6rcTLLt5atJ9wDjF6hUTxjCrk/cuUp7+Ieqxkug2Als6SjfjspPO5DMYegE?=
 =?us-ascii?Q?FcTeyEafEYO6jK0bme6+ja7iNswI+vSpmDJO/sYBG6enmgD7D0WionLh2N1R?=
 =?us-ascii?Q?bDoIVP0YcTnJSviWepfTBUFKhsySzvinMCRASimc0I2ibHr3sBbymaR8RMLa?=
 =?us-ascii?Q?KuHe04opyOPPZG0GB4OFw5MCiz5q9+Lyq7k2vdYQx1Bz0u43qFOdtJtb1kAz?=
 =?us-ascii?Q?MGjXzWD3paacAzVFxzheA7Bs0erGRKMO97239LwoMKvhjwbF+aZtkTCj3Qsf?=
 =?us-ascii?Q?9R8b5/uWQutyoMIIkGudzWhOrRDps3liC7t0m6E1pjoHzKqUaSTUBdDCeEoB?=
 =?us-ascii?Q?PXOZ2n3h0sxr01thoxwGrWZ0iSqFTG/D857S96OAoJz6qEa9Hfa7Ybp/9epG?=
 =?us-ascii?Q?8LzDHCPhB5JoGJVk/Ior00QaMRGegjyLyZmiJbSHVAxT0r85F+db1XUs/4mU?=
 =?us-ascii?Q?wV51BeTGkJma/dzOQu3vfiFTjIYgEnKJ9Ho4IQyUqi1Mv033VEP9LU/Hh83S?=
 =?us-ascii?Q?MNK/jE8P5XeFVlwMEDAl+Seuig5zgBxjYrwBdupwSaG9lHc8Ng+aQPmkkoiS?=
 =?us-ascii?Q?DU/irVTFcCLZNX81g+CteJ0HYBZXgNyPN2ZHQx0xesn4sodQ4KJZTS+FRlce?=
 =?us-ascii?Q?Nv+X+ziFGtuTIWQhYuV5M+pYv6MShvQftYs253dbErgQXv2G1Nb01ZiK/czB?=
 =?us-ascii?Q?fKzeoTLNs6dfSOXwPGfCZFEh2Zclldlz/50jSfoglt4PA7T+rYnwSSwP9LMi?=
 =?us-ascii?Q?czfu1PLNl0sWde0WKYwveLN3dPJfIfiFCjKH5Ew9+Si36Np8maZQhoWUgjb4?=
 =?us-ascii?Q?h/gDGOv2YezimjvN7CqJeKDGVOIxAkZdzvpFv7slvOBxbaUzb7ViA6g+khoy?=
 =?us-ascii?Q?0J76htKySHELHqqDWuOFf2Sp9zxGeNnkBeAQZWzHTNaa6JiPPBkwusK5dByR?=
 =?us-ascii?Q?eHsTSBtRDGSs2gMIPlhtshbQfPwlUfCXwqN1Q2bisZrmSGFMyzNdKDyjosFH?=
 =?us-ascii?Q?85Gzm4nnZDhyfE6IiArL+nJZIUaxkqKsxISzGtD04XCsEhi7rxRw4fsDYzE7?=
 =?us-ascii?Q?0H1aQIKMG08CjWxAdFkyYUdc2Nd7R+TZe6ovrS3pjOwmf5y8oQI+4a00HQnf?=
 =?us-ascii?Q?k/oKwSAKv+rdGW/239i9jKjvJNr8/3dnx0DgUz7zgeh/KoT0hYgJhmNeHeh5?=
 =?us-ascii?Q?/3jdHgwwYQKiM1oERwHUpn0nNaYznI2rWm9yRKf3RFJ5lvNYdZ4DWE53nic3?=
 =?us-ascii?Q?G5kaXhM1Q7uoFjw/ekiUk5EgN61+1MKZpsIiYZ8KsIBQeQTviPO2TgfZMmRK?=
 =?us-ascii?Q?Rein1R0JB9V/ekZN6B5A3/+BTB1Dv01v?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i1lPwu78j7iQsnQxbq8t6SAthQxx1HrzCgeSmnbLbAMbqeo9s5WiQ/vy+cEq?=
 =?us-ascii?Q?+thuekkJQ/0MMowX35QWsPyup3WRHXcKVFdYVh6rFs9GY8eV3AsFz4rZ/aTE?=
 =?us-ascii?Q?3UPQ1MyTdl8k91qcTtK3W3jaw3Kcss8grUktTer4N4gvK2wAVDNdmHVsi3bH?=
 =?us-ascii?Q?J9lmLZ34fwGECImiC7TmjzMiWj4udw5w/sE1PiXwCnIvxyNCeJdAS7vNgEz/?=
 =?us-ascii?Q?s31cyd24Ct9y7R3kLtN3Ow9u+uCs2BuHzW/SpBNs9uy6EtDHe4qaLhKC4OUS?=
 =?us-ascii?Q?Vw6bue5edA3XUQXnjdTWKzJEeQp4gUjyumszdW8wo4gd3/4vD7CN/ZlYbtgV?=
 =?us-ascii?Q?asoP764QkQknL3gUO8SQv7C2sYK6cX6IHW+7qdp7BljVOmHg8LXQ4N/qy+SE?=
 =?us-ascii?Q?BLZ9cPipBWcHPIvuy3DndLvPz7UKNrOKWs+ABpJE6jem25mD8IBnNAnlT1dh?=
 =?us-ascii?Q?0YyvLN+Xah5zJ7oiSOgOBnir5jp1RsY5vuajug9uEpuMUlTUoJEuaA37IRKG?=
 =?us-ascii?Q?vQml2doD1/pSRvoK3rzy3UUsrXSopehEKsKt0U5Xitr+JKfKhb+S2opy1Ad/?=
 =?us-ascii?Q?heVIdP5+CFrcco5OKku7C+Lyvl6htJW5DsK3dVK/ABeWXJJiUS1Z5d3MD7ns?=
 =?us-ascii?Q?GjF2DTrM1UXKR390CmFdFIRrK5cNRuYFIeV7/c4DpVRWjZ4rcVlGZcaaY+Ly?=
 =?us-ascii?Q?LhobYQ1UtFQxbFhFkSbBHw5oEmB/66uUJxSMWt/R1Kv5rcPmhEixQI0W8VTQ?=
 =?us-ascii?Q?iyBVHf9OwZ2k7sXnKzWKGaM4uCec8qfZBWY11RxbGyaImD2hCIt7IH4zHVAF?=
 =?us-ascii?Q?tJddjGsXVLbKkwOOKccAFmHPRLnNrypNC8jXm4B/+FgC4DxuhB/C8p7d10qk?=
 =?us-ascii?Q?kXDMgQ2AGYr5Abx7C++mf419HeTAUUWil9FYi61iB6EFnB+tIdUr/B3/ecOP?=
 =?us-ascii?Q?ekVUZo2jb5Cjs7RRhhRKp6GVUINcazaqg3J7+3yd1khdxYsOG4bEmzbRcSia?=
 =?us-ascii?Q?Nv24PlCpdeI2cKjgNnD1RtrQfNhV35/UtloVm8QJF6g+XXuYJcSP3ReG/d0f?=
 =?us-ascii?Q?lH00dxY6juIVKIV8pha+Azf29BXSeQOqkXzPgXP0gpLnBXXHdjihdUJsfghe?=
 =?us-ascii?Q?lM3DPB7nNMmBUHdUf8TLD/rDsFTh7Ar+n41X202sMRJ5jVPODNN6DixwF+HQ?=
 =?us-ascii?Q?Cd6YynaOv8ZFvVppyvuHeMwYEpQmQdoAXV+r9FixJ9ep2kruYNRS4BktR7pJ?=
 =?us-ascii?Q?sePk90LNdbv5QccIDVXfsnG0Drk2z1KU38vK4DRXuL5lByK0nSsczw1jl+9L?=
 =?us-ascii?Q?Dp4IeMtPFh3pbLqgWxxmIsIoCIo/AaYOuRGFJIG++4sdZ2nkXGOZTrIAdNDK?=
 =?us-ascii?Q?CrjeVHODgauaaJoNzk3svlFoC/TSVLYi8JxiKaLy6SYAObA4JfBD4V13Dmqe?=
 =?us-ascii?Q?W7BQhuJASiWPWPWm7/bD2VWEDcLPls5BeuyhIAnS0QqU+6Ue42IBQQspAXkP?=
 =?us-ascii?Q?SdgAz6NjI0wAiD/d/14yideG5jAfrb5vvB7i5PWU/2fFyo/mSp4/n0yd3/U5?=
 =?us-ascii?Q?MCM3uXcNQeMZqkMjW8Ln9wD/0WVmirOLGDmwaboJvtOxZKn3q09klynbA07X?=
 =?us-ascii?Q?PzdCp7mmr5LnqW+PQ/JE7KSWpuzRg0/3oJk05RPlimMIihDD9DBH4uSaLUTE?=
 =?us-ascii?Q?XV1N5LHYNAy6mvH+1miMnRI+x80rlioKKuNo7ThNVeyjIcSdYsDHXRVxYD+H?=
 =?us-ascii?Q?03AmU71PgA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fcd89e4-f429-4921-54d3-08de5205a67c
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 18:08:55.8207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kvTAjcwlbPCtSvYC5ONZ1m9jQFP9wCxjmHPoE/du+6OG7A0oI0PVEE8iugbr6Ejz2vwoZpSu/gkHYJNoDShv+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6679
X-OriginatorOrg: intel.com

Pointless overhead to use a work queue to reset the static key
for a DO_ONCE_SLEEPABLE() invocation.

Note that the previous code path included a BUG_ON() if the static key
was already disabled. Dropped that as part of this change because:
1) Use of BUG_ON() is highly discouraged.
2) There is a WARN_ON() in the static_branch_disable() code path
   that would provide adequate breadcrumbs to debug any issue.

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
Changes since v1:
Andrew Morton pointed out that adding a new BUG_ON() was ill-advised.
Drop it (but explain why it isn't needed in the commit message).

 lib/once.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/once.c b/lib/once.c
index 2c306f0e891e..8557eb489f34 100644
--- a/lib/once.c
+++ b/lib/once.c
@@ -93,6 +93,6 @@ void __do_once_sleepable_done(bool *done, struct static_key_true *once_key,
 {
 	*done = true;
 	mutex_unlock(&once_mutex);
-	once_disable_jump(once_key, mod);
+	static_branch_disable(once_key);
 }
 EXPORT_SYMBOL(__do_once_sleepable_done);
-- 
2.52.0


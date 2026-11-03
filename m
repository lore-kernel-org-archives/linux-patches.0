Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=192.198.163.16
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793720549;
	b=kVo5e754UZuLMJA0G9rLX3c0mQIrHGjkmMiFvC0OdbcqQUpnhswy+n3McIyMvKKEIf7n
	 NJhJK+oJ9+Y/bZZIZJBTeKUCv67MmkmeeMm3+lnWDNWGcYeePypDqbdX8XwOYFm5dPmVg
	 6t50KKMNt9eX2GBoPRaQDknYorFt2LQRolaTPpfvE+hk7iG9aMFeh7xQ+HfqpJyY1jWoS
	 yPGMAX+P10V1TdnNv5V2jZ0+NKWxKCKvixnnvSNN9Ob2/v/9NqHCXSvizQ701GNMv3XJA
	 Dfi7ZlF7eizE1saAeOhGhUNh33YmDNYM4mYtlPHGc//Q/nmNW4iaDN0q/xlRFY7cVxA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793720549;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=BDJXJeJImVYkxOS9iw/yCBNdrfhPZxejrmpZwNWA7O8=;
	b=2wN3UJ0bByIKpcN7Y6KHxMnZWnrxScDzpNuw70GuPpq68scxUjTe1vUhcdbvD/Mvs8N0
	 j0mMaZPBAFHKBrlZjqoJHvwK0Fxs+UljFvfFYaqveifSH+EaKyZshlZhPhEIpsmD0v3Ga
	 XKQkhE7VLGSxnZ5t/005VmrsmEt7rocnB09Evf59C3asQ3hBuXkPYGF3VoH/b19ek2vJi
	 q8xA3WP3EKAfFE/5dzlPo4cAGB7FYuCEZL8AvjeEChvlpQEG8HM+jET3VUl1fAvB56o6X
	 Vm+t1M6I1llIwVTdHIjpnC9GWc/ElDuOdIKZPwuXfTVSR+/hHWkDwlOb+xlYuJIlegA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=EP7qOeqP;
	arc=fail smtp.remote-ip=192.198.163.16
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F826083638
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 15:42:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37F826083638
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=EP7qOeqP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793720548; x=1825256548;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=lDeoCnmotAlR14KonN14WyhqYa2GhjH0hUelZvIQg84=;
  b=EP7qOeqPcfHtYtI/F+TDYU/o1eN217ubEPSsBNMzQl5vSPFG3yj4fBCd
   IYDs2flp/Cj54idC0eo0SRM7XzBpPqot4pbXiYOsoM/5VNGVKbRFEQr0Z
   52alzLXJruSt85LbE0mgzVlwpBNf+tXktZD+Gy4HLp7GgCgOYJmtDCuu3
   ZcobitOxlxdtuWVsQ7L8IbCODUK6y2/CyphThHbcEpyYRcB8xOH5syjBA
   e41EwO2RezlMmCKbV7H/38Jl0rZclS9WfmpLabCPuGKKs3TpLurdtvGEL
   AsBgFli8g5KKuoNW0NrraVtLh62B/qpEQKHo5Ns63jbQ+ypzxpALjKNiJ
   g==;
X-CSE-ConnectionGUID: l+WulT4TQq+qIxQ4I6fOLQ==
X-CSE-MsgGUID: 07q5Jsa9SMucliN9WL93oQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2462575"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2462575"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 07:42:27 -0800
X-CSE-ConnectionGUID: JNd/KnQgQUWdOPeSGO4U5g==
X-CSE-MsgGUID: H2Y4YA6HRUu64h2u9PaQ/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="6352212"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 07:42:26 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 07:42:25 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Tue, 3 Nov 2026 07:42:25 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.36) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 07:42:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aAWdIPi5JOV7SjB+PNIEa99o3pK15Atmxv3fkBWYDDJK+CXF4rfv2rzn64iNkZfSFi0pJe4sqDBdFe45WTBfnpTxuOkdWjJhCnVgYbdE84CjAyWrkpR44tzDC/g61dMjAkq5R+3mBrbnEA34BQ/HXOGas64f1MUDvUBo9aFRg20bpAO3FI53ra0WfQ9kaviwl4Fd7J3jdBCmIdKwg/D221/DN+HQ1Yfh6fkezXRK7Y8dVrfwzNhDeLhQk+ZYz9nxGdw4WsWdgzLqDfgNrjAzJ0s8ZfSUs1sHWiUxLg9Z6Usyscx00GjZeyEzhdH8erIRm5AoVPqwnxEIXqZbO9zbvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BDJXJeJImVYkxOS9iw/yCBNdrfhPZxejrmpZwNWA7O8=;
 b=bT1QwQ/XAyD7CV51QhBVSUbe3FS8tWu6JdwUwoBAy9My7C9wTmTk4I7uqDiTMM84T1tgFw8SBllZdpww7RrExIf7RznjqIITc7RSMVXXBo7lMuvUAYb/gQd/nI6yKsbMq/3UJJ5hzmkSu70shmGvwSwvZReQ4EqGnPMOkIja3gGs0DYnRtW5MEmQ4Cx+AJw6URPpwBogUB7WN1a1ws+QyMkBtZSAcK6oqCnB/r2nUbCeJAhuXm9E1HV1haAIor7iNjZfk7fYAzFTzvlJPsA1Bw6IyIsdWYyMwUpCVc08yt/cu3CSj7te6sDOQ/dyIz6DmzrSNBOeLS457NeWGeRE6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 SA0PR11MB4559.namprd11.prod.outlook.com (2603:10b6:806:9a::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.12; Tue, 3 Nov 2026 15:42:23 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%3]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 15:42:23 +0000
Date: Tue, 3 Nov 2026 23:31:14 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [RFC PATCH 6/8] arm,x86,fs/resctrl: Prepare for asymmetric caches
Message-ID: <aun+Qt5iTECdwogN@chenyu-dev>
References: <20261026215718.16810-1-tony.luck@intel.com>
 <20261026215718.16810-7-tony.luck@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261026215718.16810-7-tony.luck@intel.com>
X-ClientProxiedBy: SI1PR02CA0018.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::7) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|SA0PR11MB4559:EE_
X-MS-Office365-Filtering-Correlation-Id: dcfd44b7-1ce7-46b9-6538-08df39c10d9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|3023799007|10067099003|18002099003|22082099003|56012099006|4143699003|261022105027099003|11063799006|261026121527099003|261026140227099003|261028144727099003;
X-Microsoft-Antispam-Message-Info: Qfmdl9B9OpmfjQxmknwr/AU334J4UMh9uGJMiD0uBnyM2imjwHatIN6/ghJxeE0RJFzbDoUV74Urf6wr2VFxBQ/m+seuN7pmHk7+68fr1ad6cKyvsZI5NGISRqk1VG9sZyqsxNnZKmwNn1RYIyRAHVz2brr8SgrIhkT6VgQouKoR2JnqFkQosgQhNnMqLJ+A7pIpF8AmZj/RSMFPNgRRQpJJLYM3nkcacLGvo5p0DrrktQ25qGqEM051i+yyW2GA++eZS4QyaMbqu2NO2yN2uSQGW19SJVf4YXy1r2Z+z6kBqrwPTkpTI6aJeU1ElN8e8lrnyb6kMfsoowB0fBu2LgXKSyZej+um6Zv2azhU9sROhj6UXsUJhZGpmHQK0QD1Jt+wAvDKjYwClODjO62jeeNBzGii7VI/WLK2EYLc3qbWKfAT1dPbap47YFDDKuIR3wgEyajcC6MDDag5i9cAYYKdQL9PVLFr73ho0mcZu56zh0DeO/txx9v3N9nB+gp0lnvxmKwFY2QYGRzDcMGotNEvx5D0HBHlOlyBKSMlszEWriha2h91f89eqOZ/ROjfq2/ROaG419sLwcPkTvOVRzW5OW8ufH7QgW5jaKPGwGUHoPFdTfXVcL69i6LRWZnKy7cdE53zE61QHvc6V9kESvIBXQoVT7lRDPMkjNayen0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(3023799007)(10067099003)(18002099003)(22082099003)(56012099006)(4143699003)(261022105027099003)(11063799006)(261026121527099003)(261026140227099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VAEEMKHmnl4rU5HkxHY0Lh++IrcZxZhWVCumBYNy4rsWcX8PR9z70jW0idmX?=
 =?us-ascii?Q?quolKy9DcYGIA387GPeUdtkR5PpRXl8jWDyvrBlz8QVoJXbYLzqu902/xxfZ?=
 =?us-ascii?Q?NbHGwYUf/4eMW3BSS8jjXHVBMXjRYdEjU0h4PhVquVzsAg6QWWX0Z3HZYx+q?=
 =?us-ascii?Q?mIVhM0soRBk3oO/OHsUa85NK1GWajd+URUctxZfDNbGLVx4aw/mCiCToxUon?=
 =?us-ascii?Q?TvPVklx13qcFdc/jEIEUsHlLbimHKyF0/ywz3Rs9F/IHIn9Q1KYzOFqWXXkF?=
 =?us-ascii?Q?YmHFVdf373rMkOAtLdLY2T61ni9a0apZe2RAEJO6SABsscBQCGMJjNxEIsgB?=
 =?us-ascii?Q?y8LjfAf97KDjPmzQyL+Nv1CkctVMB2cRMiB88bn6p05W1JI/9+V9ooKEV4Nr?=
 =?us-ascii?Q?vL2Xrq0dmPoxcVPdau2OOcvg1c0f9lCCQ1PP95z2qEu6qTsu/gxtdwYMSfSX?=
 =?us-ascii?Q?XBT40zLaiN7mX8EE2Tb0EFXMUvdQAk4/1LtgvATklVROLOfOsRHE0OWF3FqI?=
 =?us-ascii?Q?A/EG27QLQV+ShNJheZ2e4JjRep/eMSkBQ8HH413iSfmTrsM5dlj/HNWiDr9e?=
 =?us-ascii?Q?LygzyQiUabj2GCGRATi34fBfoRtiFESZULKRkbfkOwxxr9pNjHlmA85RVpre?=
 =?us-ascii?Q?V6mN2M2d2F0R0N13NKKvAKTxG5PiK4+Q3mAh+Gpg9nTNgIvh7Pjjkcje4vB3?=
 =?us-ascii?Q?2Uc1LjRs9EX1rTZtkRSNW3BPs1wlj7jjrJk12QgM8Abb1eWh2S5Wv+NS6qC2?=
 =?us-ascii?Q?NICo3Qa0ABECEy1T8cE+ahCcrTZxcfc3vr/Ng1yQkss6kkdAKi3LZf8u2wqj?=
 =?us-ascii?Q?sRALNkneM3U7DI+wZz1Qne5tx8cRpOCO9k7ZK9DCYD78vMf9M2VpOquRzrwy?=
 =?us-ascii?Q?Jeyj8WibXdQFz0eOhbY49dJJ/Z5ajC7AgsWO1DOe3Lb/MwMEDop4MgcuHGGL?=
 =?us-ascii?Q?OKLZ468obtBy9ldqHfJO+E4tekADSTJm5bXlq+TuBeJu3wiwoUZgPJw3xSZA?=
 =?us-ascii?Q?rIqJJG0aUoJNN80XZt+OYCrY2hr/lMHxClaAKP3AJiFoEUa5AsRZtWkHxbNd?=
 =?us-ascii?Q?9ekxgIbDeRNxmIBkq04nXPeyVZplrtjnXBy8V1Gd+F03Ti93zVkwxXrwpQeM?=
 =?us-ascii?Q?yE9r3GRfaBL5vfAXIuJVylDms82v2fGcnhnoT3DPPfQ/pe/b/DRB2dgGdUQM?=
 =?us-ascii?Q?bMF/2BUHQmU0Ct0rcSSUUyP9X58NIifAzFOdnSCrzxWdoO4UdD49IqC3/e8u?=
 =?us-ascii?Q?9uNhSdTfr425w/46krI042leMTxuxCVBybfvxKlo/Wa4hLQcedZjYvBdKuC4?=
 =?us-ascii?Q?eRUKmB18lxYqrZmCSGUhUci7MlTe3AdSuARb6CQ5lEp3f23y7J0eERVPzhsm?=
 =?us-ascii?Q?7+BOnYXqV4hy2y8/o99AFK09mwCPXNOWj4h4SHhvmfomzGW6KFPIP9ad9LjP?=
 =?us-ascii?Q?j+5GKXa5tLC79cjYpGGX4VaHyxcXIzkvB1QEvB+EAFa1NI8ZcCcIp0sU/WSV?=
 =?us-ascii?Q?CUexZ9lNp0tw2NM2VbdS8CTPPnQZzOQvOlNVR317lBrnJOwPGQ9d9bVPdmmw?=
 =?us-ascii?Q?RtBGw/KsboyT/lfwUYen1DNfGHBRzyfJK1/2wpiO+AYNADLut6bcgAwwME6q?=
 =?us-ascii?Q?usEMf1gj3fURNBDpKF8JbCagYHK97LsEvkppZI9NWYmQ0odpSYDOkcn+G6wp?=
 =?us-ascii?Q?f921Jt3meaf1ELzE4siwfaZ6cXpbViuuPdZKnnq6HHwYy5/kKI5aIWKGoSSR?=
 =?us-ascii?Q?MgY57XPFIA=3D=3D?=
X-Exchange-RoutingPolicyChecked: wzNY31PyEegjJ6lxYVT851LcggrYK087JVsQDtF/52wIUKsrb+N9yBd0mYVzFeWOnHmXoRJBKbf27JlYndAp+N2feis8Z66WLmgbk+yGxAbTRbmD42jzLCq802OxujaUdUtaDx2DY14hAlstOyx3CyVZUjmCJV88S7cSm5uPWkcfRcWUFavi0qvw0s6OroyUCKOsx+RNZ6pl99YDDGo3s8/DBgUqMJv0EEwrG/ZOBw20R4gr969PwW+OneHuU3ZcWBXCO7cIkc1Pj86cm0qO3VQEK7dY3ePc1cLF7aWddZh6d6wyKrwT9tPWE6nEw1eNm7w5hNp+VHWGViwEh99Mww==
X-MS-Exchange-CrossTenant-Network-Message-Id: dcfd44b7-1ce7-46b9-6538-08df39c10d9d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 15:42:23.1450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jMG1yKD2qEHd9mAVktUj9LW/86TCyFKqlRZ9itx99vWVdeJXopfkV6KHHUTeVtPU7Ed1XZAonEy8QNL3VKlOZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4559
X-OriginatorOrg: intel.com

On Mon, Oct 26, 2026 at 02:57:16PM -0700, Tony Luck wrote:
> Each struct resctrl_ctrl carries a struct resctrl_ctrl_bitmap that describes
> properties (cbm_len, min_cbm_bits, shareable_bits, flags) shared by every
> control domain using that control. This assumes all domains of a control are
> symmetric. Future asymmetric systems may have control domains with differing
> bitmap properties, in particular a @cbm_len that varies by cache instance.
> 
> Add a field to the rdt_ctrl_domain structure to store per-domain cache
> bitmap lengths.
> 
> Update code that reads cbm_len to use the per-domain copy instead of the
> resctrl_ctrl copy, so that domain-specific values will be picked up when
> asymmetric domains are enumerated.
> 
> +static void rdt_sync_ctrl_bitmap(struct rdt_resource *r, struct rdt_ctrl_domain *d)
> +{
> +	struct resctrl_ctrl *ctrl;
> +
> +	for_each_resource_ctrl(ctrl, r) {

maybe we can let rdt_sync_ctrl_bitmap() receives the resctrl_ctrl from
domain_add_cpu_ctrl() then we don't need to iterate the controllers under
resource? 

rdt_sync_ctrl_bitmap(r, d, ctrl);

thanks,
Chenyu
> +		if (ctrl->type != RESCTRL_CTRL_BITMAP)
> +			continue;
> +		d->cbm_len = ctrl->bitmap.cbm_len;
> +		break;
> +	}
> +}

Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D6B3019D2
	for <patches@lists.linux.dev>; Mon, 15 Sep 2025 15:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757949730; cv=fail; b=bonrYB8VaCbNd6h+w/N2C9Tu1IOhgF/pReJeQ6z0EZ2K2cPWZ0QOl485x/3MVb0sko/o6MJ5FCb0OOr7Lgu8uhEabUVEDCmXiLwlBr2OwZ7wTIJx+UdUyaDM2mQyyNPHIdG5oGWKcpWIowY8XBxdMF6yfvwvnXCx7iWXQJRrccc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757949730; c=relaxed/simple;
	bh=/drORpBVTyvp2SjnSCp5e0Dl4tk0aWCrRetcOlqEWz4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XYNxWvbyr0Hj7WGGDAZFZwqWAnsOWvSyXE4Qli7UCxRHibYCPdWEwgeUmBqMVf6h65ur6E2dxD4KVOc0p7eSggQp+kihhxqnUNtH4eKxfTXgM0TPuRjYwn302Cw2SaXrAA2jZ4VHnXZpYMwvoKz09L8ko49g5Bj72l/irhtyMMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ecKJQHZs; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ecKJQHZs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757949729; x=1789485729;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/drORpBVTyvp2SjnSCp5e0Dl4tk0aWCrRetcOlqEWz4=;
  b=ecKJQHZs81755NO9maDc2wREDYZwqYWZ/wJKcbNXSpJjtfpA6aQXT01t
   r8DWLRu71aQYSTvX/QOSEoBb8xqPtNpWASPXGmozxn1y4fGG6bXoe6reU
   UTYMu05GGOdqt4M22iiGF1k9E2/CWr3Asg+LXL8pixG0mBj4PMh9fycT/
   ur6XovQfUysW0Ax+FhLykhVr+CJk3Vn5xBtPRN4W1KWQ0SPTMX5Ij4fFu
   WXhcCEQq1wH9bmhxEwjgXvtWjHJt9U6DcYZ2TEUgSeIG2fUHU2mrNqXzj
   AVwoP1yOu8+mLeu3XuanBM8KUXMSu+wIwdhXgVY3eK9AUDrdUfS3Prcx8
   A==;
X-CSE-ConnectionGUID: U2VUOOW0RJ2XqCZlxBo+9Q==
X-CSE-MsgGUID: cx6S1paGTpSXUm6qnJUvwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="71306508"
X-IronPort-AV: E=Sophos;i="6.18,266,1751266800"; 
   d="scan'208";a="71306508"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 08:22:01 -0700
X-CSE-ConnectionGUID: mJTeDOAoRMC5J6Q3wzp+nw==
X-CSE-MsgGUID: oI2qWinST+mtiQ4ro8Qt5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,266,1751266800"; 
   d="scan'208";a="179039027"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 08:22:00 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 15 Sep 2025 08:21:59 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 15 Sep 2025 08:21:59 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.33) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 15 Sep 2025 08:21:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wQSM+TjjROwgHgJXvgzX/aTDvbGLEFReVUz61JuU8UT3wxG2tUgzfUSwbGZHybSJ3zl/925yHD9zH3UeJsGmllw39T4v7agqkaEtoO9U+E0KDwW8YJyy+71vOTOHHdMVB/sJTvKX4aO0DfNol4hG+xD7hWKSA/TkBdbTkoSlFpSbHjXBhl4QJOgzj3Q8MRlLOaWGwSFhpAO9lew6VyhqlSIl+980I9QWm4/m/LrzUI+HuPBg7/7vNJ7sxMIJBAiB20S3Dw1roR086hvWfs6kGbBk8QrKL9KfNybaRuFlSVAxHUPTmmDD1lWqFdCTLgH1j2LM5FkMkJyIObWm3HA5ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vrxX5Eq3yqHhkCnnSJ9ncYnn6SEyDdHVzDH5FOblWIo=;
 b=Iaoi+P5cHG/gEId49AzSuWmAU3HrF3sMIZUco6rh7ViQaVpsBw9ZmPRnerYw65XLbdEI8bQaSa8/uDk7dW6/SMRudVJ2cRh9scT8hCVCWJ6Ja1ZV65ntfaHxF24atY7eAP5mUCbltB8S6dyDaFx9PgQsasVqtvvXGakaB9aZVx3QzZgzga7kaHp31HaamqsTn25ONgy3FOtbovKG4vZ2soKtx5G8SCZ1T7W/UM9NnvK2zsvjtaOYMTVBDq6M2KzxB+owSG1XbkXdAiCNA8QpIYUxsSfysdvUHVY98xckrbW2tr6LBEdDufc8RG+tZO1HdmMYNMXEhgoT5IXkx3SzDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 15:21:50 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 15:21:50 +0000
Date: Mon, 15 Sep 2025 08:21:48 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v10 28/28] x86,fs/resctrl: Update Documentation for
 package events
Message-ID: <aMgvDIdZ7dILeaS6@agluck-desk3>
References: <20250912221053.11349-1-tony.luck@intel.com>
 <20250912221053.11349-29-tony.luck@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250912221053.11349-29-tony.luck@intel.com>
X-ClientProxiedBy: SJ0PR13CA0190.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::15) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|LV2PR11MB5976:EE_
X-MS-Office365-Filtering-Correlation-Id: fe3877be-88cc-49d9-e6f2-08ddf46b97d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?xodu/CJ97UaerLzeK/8LKCE1/wrjzHW2lHVBKH9ErGroXvGqY8RWrLMwp3lc?=
 =?us-ascii?Q?B0xzd3S4b22F8/IG48sTgYncDJHyTin+m3Xk7ACZ8WB93vdik3oyP2/TtEQp?=
 =?us-ascii?Q?arTvubIfZM0/NDBRwwR3lz7/b86FXzNwpBqIgPpiBje4ZxZ+/Q25WpDu7bEU?=
 =?us-ascii?Q?eWdzBkF53ArMAy9+AH4+I9CTJPz2iKffwe6F7XGNov2njWcuL3HAyOIW0fAr?=
 =?us-ascii?Q?5CEEalAOhuZJLVLZdtF2Tv+6RTtGdPk2Ac8EjkKL5FuYZqJdVdqcSM3FNZY1?=
 =?us-ascii?Q?/gz1UuByNjiThSkJ84Nr/hMm3T6awxf+Ps4cR1BMGoMJOF+haq42E/sYqhBj?=
 =?us-ascii?Q?LeqlqsIhaOLZK4qXc44IFPA2Bq6g3RaEnwKusQ3EHZVZWnKHfiQuq5Fo3oDS?=
 =?us-ascii?Q?t4USFSOyo/it/2/H0rg0SNjmF5e68VG+APT94UuorQSLBwoqxGLuRDHtNhnY?=
 =?us-ascii?Q?FLYreVP7zICCZ/s1IcXV/0cLgFgmdSWRG2TqqaPqNCcuVSQNX8LT0xjr8wGS?=
 =?us-ascii?Q?Z8lZj3N2+FUHBSzI82ykrtRyzLvIc510do/S2PdGJchsR6kdyl8hoD12OHHy?=
 =?us-ascii?Q?TtYgFDPizQmWs+8BlFhPOG9cVse0JDsnj4ooXBrkyy9z56H+J1Yfk2d82bF3?=
 =?us-ascii?Q?CspB9uqqclNzW+E0QS9SBPdmbxDLdAjsyQY7L9WYvmTi7btGp+vZwGKZU1j9?=
 =?us-ascii?Q?H1p2I1+TQhfH3gyZKALOcqHw4QaJZjk9Ni+F1H7MLeDIGp2p6SWgKsBkDt7Z?=
 =?us-ascii?Q?Yzuy/Wn4FpNI7DellSJ7XbkE4crcsV6KQ4iYZbfpEfnJA5/1N2Wa9xk1y8qr?=
 =?us-ascii?Q?aXSGeipM2s8dmhb7YhOjlyWdLT8rV9gUMuW4AXv5xLPqGuXPblYQb8ZVu3Z3?=
 =?us-ascii?Q?E5dW3KDgKtl+xpFW+zUSsi5yLsPRvGLrfUVxh1u7W1TDRpesSw0BmwssjkEz?=
 =?us-ascii?Q?0HrRklbelAZq1FdINHneaPauiYwIFo2UDgAhLqdZXgDEfRWDcLZ7UhF1mY11?=
 =?us-ascii?Q?jBQBwA3P22zcTwa+/m+Cy/x2W593+qnnakibp68GWxO1nlXmPpy1nEk+ek3a?=
 =?us-ascii?Q?LhpwmNMSvyPIG/M9kkncr/kjskSxiq2thaHWDPG0IIHScN/9LuEL7CrQWZq5?=
 =?us-ascii?Q?+IMZf+c/1x5po+Kd47AbFJD0dZinzEgs7Hbphxxpx2qfRWzn2kmXEgrtMkYo?=
 =?us-ascii?Q?CUZp7hSNPsrYHFCKXNLKJmf6EX9Ex1qKrpHN8LPpYxammcsICk+3+k5eUxfn?=
 =?us-ascii?Q?wmFSjv8NqVD4fgeVR+5qlBYwwrqXdYhsaVlwM+FDDSJJ4R19r8k8q/eDTgyN?=
 =?us-ascii?Q?jwStQpbO4ZDDlJDu4rtU2TT8IKUWPwDfSffYIN1ZxPF7sZ7B5arOQp14oSmV?=
 =?us-ascii?Q?GYGC/xCddCMYbI+52W/5DHWVoZnI1e8dFrF1tZTDEIwNdmwKaTMt07oum0yU?=
 =?us-ascii?Q?bI2HksdaSxA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hftoOaCbpkntFKmFl3/qcvs6lHseCzPzxBlxMYsSW7+qHuDGRrhwbhEwal0P?=
 =?us-ascii?Q?jujoZ5pMHjFBYwAC8bgfpRNJTTZLprZEJqZ98cVt57spyI/wgaKEIXq9dWJa?=
 =?us-ascii?Q?ars3Zd/1mIsqvmxQD1UisQ29DlW7NRDB8LQeoZaHsGieWwe97RDxOIi4EqN7?=
 =?us-ascii?Q?i+wzWkk3eaLWsrRK083DA160rLDj7+md4DbT0TcAc+DQkMtCTWgFFnIzDar1?=
 =?us-ascii?Q?aFoaZebNk2x9S0NY23Wu9eNn5xDPKRhORHNFBfrqG6tDBn7RztIo3FvqXAEc?=
 =?us-ascii?Q?1Hgkdj//AYlZgqykjWNJ5GGtKEsM3V39IfYjt+B55csnd5tOtyDtaKBMH4yC?=
 =?us-ascii?Q?jVlZmMKsMwmOSkDwkLj/ntES1HlJtpXXCGhBfuEwiuf8mRsU6k6A+M0NKNYF?=
 =?us-ascii?Q?SSDdJUTNqbwPNGZ4UwlwziWieZaHZLSjVNW4uCf8PCAlWCU9KHgYYKCnzZBK?=
 =?us-ascii?Q?6gEEkqzksecjrQiTJaw8pxfqMRcBubIcAmmzfc93EFHU/ZSZjtI+z7V/gxKe?=
 =?us-ascii?Q?9VaQU220mQLWmFg4LvrcS+w13JVVk95TIFsKzo/8XuRTeZj/8DgSOYnTnxw7?=
 =?us-ascii?Q?yOGyGCg2NVFOv+Eysc9lOpXXOl1BCoXPOX+HS4REJqzex8DELtgoKjhULid1?=
 =?us-ascii?Q?0owGDlF/IXXdpMe2jjANN+yiIdTcXUUs9/c7Wigs9ZQACBrm0ZLgFSasTkEZ?=
 =?us-ascii?Q?LhGg4nOKjqyaztTHkH5R0oaGYRo0iNhr9VqPt5ZIECI+xUZMindxEiH+C2xn?=
 =?us-ascii?Q?pjyWWE1UkQ2gqcl9PyqFAXhd9a8FdN2KtbcKm04CPv1Mn8znePi78XrCAzXU?=
 =?us-ascii?Q?ZqfHI6TAstfoHkpK29+1ATOTW54kwhhIyW5Y0oxCKkcrvdfSTA/DZ+eVvvms?=
 =?us-ascii?Q?GclU0TUtCqhxCFRirjXVRnVi1eXQkya5ZuWzo7gWv6fabj5JJ1XqrhChBirR?=
 =?us-ascii?Q?svNX0NQLBEj/OCENLwhHS7+wPMKmlGKDRYqOfBp0BQI9CcIjHdZFTjGK4VZw?=
 =?us-ascii?Q?+38ORNwhVCVC2bm3MeJpR4QeWEaR+lCn6nluxzFbb3C1R5TQrqtDHX7lCB19?=
 =?us-ascii?Q?0kT2E+PXpw5eFpOlorRFYQIyKcML3s+K4US8HdBDYFPY82/uD+e/+pI7maeb?=
 =?us-ascii?Q?/NTrJBtyjAmD4iXRUSYVTtO39eILqBv8ztJfpgJBmKOa1Pt42xAR4ZywP5kZ?=
 =?us-ascii?Q?Q7IyCwjHmQIwAw8+IQSwU+CYwO9Jegi8ezy2F5hNbcE1CcRptjQ4cFKm5dEv?=
 =?us-ascii?Q?NGSlYbvEdTvMVvgfybYTp/DpFYar5t6fpE6YdZ6B5t9hIxRA1NKHzkCGF20R?=
 =?us-ascii?Q?jiOR/RRS8FrXKrmhkbGW7ejFiSNvEK75F/P2okSaRCcseiM2vmLmUbQ5BCDD?=
 =?us-ascii?Q?MXiwWWrk/Q1jJZdm1OULyRVPZCW4nK0zmLTSDyZRKqinuxcP0e8HWUKRqI1w?=
 =?us-ascii?Q?jn7I+eDAE1wz00jSyuZI5lG7zzntn3tRcaN/0yItZ0z3ooCa1U4GvOY66a8R?=
 =?us-ascii?Q?Y6Ul11fIeSP7pX6RF2zUrJXKZBpXEB9kwiyZSI5Q/LTMQdy7lhg9XMR4S8IU?=
 =?us-ascii?Q?megFgev8czE2bZFH/asSo6ch9yAd2fArplagtECe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fe3877be-88cc-49d9-e6f2-08ddf46b97d7
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 15:21:50.6058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WBW3z0jlIK7zrSlH4tuM7r0J7IMBp3UbF1bS4/rxHL5dpG6VbsB5NhtX/QHkYL6v2sU9FPqMj3uUns40rzP+Eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5976
X-OriginatorOrg: intel.com

> +	"activity", etc. The info/*/mon_features files provide the full

Need to escape that '*' to avoid:

Documentation/filesystems/resctrl.rst:526: WARNING: Inline emphasis start-string without end-string. [docutils]

Note that this had me scratching my head for a bit because the line
number in the warning points to this innocent line

526		Within each directory there is one file per event. For

two lines before the problem.

Updated patch below:

-Tony

From 13a738760802370fc69414749847e12dced03868 Mon Sep 17 00:00:00 2001
From: Tony Luck <tony.luck@intel.com>
Date: Fri, 12 Sep 2025 13:43:02 -0700
Subject: [PATCH] x86,fs/resctrl: Update Documentation for package events

Update resctrl filesystem documentation with the details about the
resctrl files that support telemetry events.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 Documentation/filesystems/resctrl.rst | 100 ++++++++++++++++++++++----
 1 file changed, 87 insertions(+), 13 deletions(-)

diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
index 006d23af66e1..cb6da9614f58 100644
--- a/Documentation/filesystems/resctrl.rst
+++ b/Documentation/filesystems/resctrl.rst
@@ -168,13 +168,12 @@ with respect to allocation:
 			bandwidth percentages are directly applied to
 			the threads running on the core
 
-If RDT monitoring is available there will be an "L3_MON" directory
+If L3 monitoring is available there will be an "L3_MON" directory
 with the following files:
 
 "num_rmids":
-		The number of RMIDs available. This is the
-		upper bound for how many "CTRL_MON" + "MON"
-		groups can be created.
+		The number of RMIDs supported by hardware for
+		L3 monitoring events.
 
 "mon_features":
 		Lists the monitoring events if
@@ -400,6 +399,19 @@ with the following files:
 		bytes) at which a previously used LLC_occupancy
 		counter can be considered for re-use.
 
+If telemetry monitoring is available there will be an "PERF_PKG_MON" directory
+with the following files:
+
+"num_rmids":
+		The number of RMIDs supported by hardware for
+		telemetry monitoring events.
+
+"mon_features":
+		Lists the telemetry monitoring events that are enabled on this system.
+
+The upper bound for how many "CTRL_MON" + "MON" can be created
+is the smaller of the L3_MON and PERF_PKG_MON "num_rmids" values.
+
 Finally, in the top level of the "info" directory there is a file
 named "last_cmd_status". This is reset with every "command" issued
 via the file system (making new directories or writing to any of the
@@ -505,15 +517,40 @@ When control is enabled all CTRL_MON groups will also contain:
 When monitoring is enabled all MON groups will also contain:
 
 "mon_data":
-	This contains a set of files organized by L3 domain and by
-	RDT event. E.g. on a system with two L3 domains there will
-	be subdirectories "mon_L3_00" and "mon_L3_01".	Each of these
-	directories have one file per event (e.g. "llc_occupancy",
-	"mbm_total_bytes", and "mbm_local_bytes"). In a MON group these
-	files provide a read out of the current value of the event for
-	all tasks in the group. In CTRL_MON groups these files provide
-	the sum for all tasks in the CTRL_MON group and all tasks in
-	MON groups. Please see example section for more details on usage.
+	This contains directories for each monitor domain. One set for
+	each instance of an L3 cache, another set for each processor
+	package. The L3 cache directories are named "mon_L3_00",
+	"mon_L3_01" etc. The package directories "mon_PERF_PKG_00",
+	"mon_PERF_PKG_01" etc.
+
+	Within each directory there is one file per event. For
+	example the L3 directories may contain "llc_occupancy", "mbm_total_bytes",
+	and "mbm_local_bytes". The PERF_PKG directories may contain "core_energy",
+	"activity", etc. The info/`*`/mon_features files provide the full
+	list of event/file names.
+
+	"core energy" reports a floating point number for the energy (in Joules)
+	consumed by cores (registers, arithmetic units, TLB and L1/L2 caches)
+	during execution of instructions summed across all logical CPUs on a
+	package for the current RMID.
+
+	"activity" also reports a floating point value (in Farads).
+	This provides an estimate of work done independent of the
+	frequency that the CPUs used for execution.
+
+	Note that these two counters only measure energy/activity
+	in the "core" of the CPU (arithmetic units, TLB, L1 and L2
+	caches, etc.). They do not include L3 cache, memory, I/O
+	devices etc.
+
+	All other events report decimal integer values.
+
+	In a MON group these files provide a read out of the current
+	value of the event for all tasks in the group. In CTRL_MON groups
+	these files provide the sum for all tasks in the CTRL_MON group
+	and all tasks in MON groups. Please see example section for more
+	details on usage.
+
 	On systems with Sub-NUMA Cluster (SNC) enabled there are extra
 	directories for each node (located within the "mon_L3_XX" directory
 	for the L3 cache they occupy). These are named "mon_sub_L3_YY"
@@ -1506,6 +1543,43 @@ Example with C::
     resctrl_release_lock(fd);
   }
 
+Debugfs
+=======
+In addition to the use of debugfs for tracing of pseudo-locking
+performance, architecture code may create debugfs directories
+associated with monitoring features for a specific resource.
+
+The full pathname for these is in the form:
+
+    /sys/kernel/debug/resctrl/info/{resource_name}_MON/{arch}/
+
+The presence, names, and format of these files may vary
+between architectures even if the same resource is present.
+
+PERF_PKG_MON/x86_64
+-------------------
+Three files are present per telemetry aggregator instance
+that show status.  The prefix of
+each file name describes the type ("energy" or "perf") which
+processor package it belongs to, and the instance number of
+the aggregator. For example: "energy_pkg1_agg2".
+
+The suffix describes which data is reported in the file and
+is one of:
+
+data_loss_count:
+	This counts the number of times that this aggregator
+	failed to accumulate a counter value supplied by a CPU.
+
+data_loss_timestamp:
+	This is a "timestamp" from a free running 25MHz uncore
+	timer indicating when the most recent data loss occurred.
+
+last_update_timestamp:
+	Another 25MHz timestamp indicating when the
+	most recent counter update was successfully applied.
+
+
 Examples for RDT Monitoring along with allocation usage
 =======================================================
 Reading monitored data
-- 
2.51.0


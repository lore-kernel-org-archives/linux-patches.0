Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792504304;
	b=KNN/3uNFjUKgx9H9cxxgMuIx/jLHjOQskrSZfkH5pdvQXxsWSzrHh9kZAqdvQobnzEJG
	 2QMPqg6H0RhWeTxfRacjYuKEeVQOcF8DZt3I+TIX60oxQrUaAnAgNr4LetU9deD4udbs0
	 jWQCt/RSLBkG5TVlVhLwfRsIyLRi4MG0khAmg2lBjVQkBZQHK62MmDyrqdJfhVHyI2ZZM
	 HmKFdCp7+Rz9EMnM7GM8K+0F+qXkF9Gy3/AWeeRaQHhiQmMzIrj3NFluy2M+6q2/7kIBb
	 BFvCqeVMG9usTaQCyYUJseH7Z5p81OcoelLyoEwHXRqH82bpP+Q9IyBghzQnFsN4PSQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792504304;
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
	bh=nb+X0LlyVAdsaTHCiAlSJqKSYid72TX1rGIJZmQeGIQ=;
	b=zyGsKcxvUHx8Sa0OXLFZl3wk3SxSaGaG361d77IsTOqZiXBu1Cy9JYU3dyr4yS4Ic87C
	 0DJzQTiyE54kXcswRunyi5tOfyF+6C+NUQTT+u8UHBPcWfE3+yxAvcbpGVarLTKs9Iay/
	 hMOF+12HDBO7PtBW9hoszl2/UARU2rh+6r/+w9kwyK4crG1mWBHqD7/jMVo7HPu2kH6Fp
	 d41R92G2NTExUzVF/HZo+aDOfBQwoXV/o8n9ViHQz+U6H7tBY7zN/BfaXFOM8S6g310U0
	 LpsWkcdlDbuS08nR4SEXdLXVl4o725YrqKyI28E+6xjqvXUFriGS6aNE80ZmLH3IE8A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=REFfgTN4;
	arc=fail smtp.remote-ip=198.175.65.20
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57996606A31D
	for <patches@lists.linux.dev>; Tue, 20 Oct 2026 13:51:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57996606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=REFfgTN4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792504303; x=1824040303;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VPl5/+zvCVTB4JZNbNgzSerRFUWbe+ai3izdTP4QZjE=;
  b=REFfgTN41gvijZnDO+cHKwy9bwaKx0eEM+bbzdOVBZI+2q0kLEZuyP+T
   T7aTdhtdrq1WRAIDN8Vlt+WIS2CD5Sb9AkhF1QohBplvpGtmgxEFTI4Xr
   TrIsOnM4GfIOinu34725pSlxwQgJA2VH4vzpOzR6Z7gWmRHEogV7wSH2S
   WEuHgXkkn56eV3eg+uaY86TW+thBr55tSCZEXZ5I5CRMdoErdQR8+bh93
   6HDLsVni97HsjsO+1A5MkpgBDICiCCMiBP+GV6+6DzixISzzbpZ/7VNtS
   UAWJ02FfcI8rIS03woFivc3eWkujMPF+xLuL9N169b/bpzV/R60a2oMN5
   Q==;
X-CSE-ConnectionGUID: x/FrNN+gSfyl7C/QHqU6AA==
X-CSE-MsgGUID: O+FqQDPHSx26g/bP52SY2w==
X-IronPort-AV: E=McAfee;i="6800,10657,11941"; a="1216676"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1216676"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 06:51:43 -0700
X-CSE-ConnectionGUID: LJvAKdbWQ2+2YrFkDqUjsg==
X-CSE-MsgGUID: RKwZIbGmSFC2jGYlDc9Nmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="2884183"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2026 06:51:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 06:51:42 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Tue, 20 Oct 2026 06:51:42 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.12) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 06:51:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o7b2IcBiXRRnYG+aWek6HDYiL7FaIkCr4AgtikJPzF9zwm190dNomCfnrzzP7ZBe9VTrAH6C8bCXCtMZFlzjMzrooWMVBGDOoDnvNfwzlfYuWvEceN96VZskjhkDrcw6/xw62UhEx+VNqGVhx1h6bKtIOJRLMoBY+h6sdP5yKHsCCSOi6T9DDGzTZ5KeMzsQjCYj0xy9lHiJiMFcy6UhT8LsIdCgtFyffzdF0wQa35oaCExCwBG8jhkryt/ey8IrtsouN1tDSh8UqWMxCzZdUxHHFq7mBeGUkT60zTHjMD4W+dCPPniah8yBeHrh/o0HPwTrjFvPd3XlsT6095wj5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nb+X0LlyVAdsaTHCiAlSJqKSYid72TX1rGIJZmQeGIQ=;
 b=WKgp3BxwRlIVKlOtWaB++VtgME3q8Q+xAW1mRm6bjfhznZ3WZaqNw1ysB91uzO0VzYMD+ArPxXfCLCZ4KDtwmPOkdwORh/YW0cui+wIAzCFd+IaWffu4jAyPVW5zVEuwDZKBiHv7vcAP8AR5Hk8UmY8q5CUgxGoL507DmcFsn6Vk/cVmIjIQ6LdjVRixf3Rui9jFXREr1F+MvaaeBHlRq2vzZ5hHG9gptjsksDlnJE1/RimZDUMUM5/orI1q5NHyz2FIQX9CGYe3LcCTTiTL+IdKssJgGmYz6p5o7Uvb3G18nLPXz0k6b/EaUFfbdPDtcWx+qX87F5GCdfU5RI2OSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH7PR11MB6005.namprd11.prod.outlook.com (2603:10b6:510:1e0::19)
 by MN0PR11MB6112.namprd11.prod.outlook.com (2603:10b6:208:3cc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Tue, 20 Oct
 2026 13:51:40 +0000
Received: from PH7PR11MB6005.namprd11.prod.outlook.com
 ([fe80::4f64:b0b5:4ed2:39ae]) by PH7PR11MB6005.namprd11.prod.outlook.com
 ([fe80::4f64:b0b5:4ed2:39ae%4]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 13:51:40 +0000
Date: Tue, 20 Oct 2026 21:38:41 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "David E
 Box" <david.e.box@intel.com>, <x86@kernel.org>, Christoph Hellwig
	<hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v14 09/24] fs/resctrl: Remove redundant calls to
 resctrl_mon_capable()
Message-ID: <atdu4Ws7iH_XNSsc@chenyu-dev>
References: <20261019205031.16977-1-tony.luck@intel.com>
 <20261019205031.16977-10-tony.luck@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261019205031.16977-10-tony.luck@intel.com>
X-ClientProxiedBy: SI2PR06CA0015.apcprd06.prod.outlook.com
 (2603:1096:4:186::7) To PH7PR11MB6005.namprd11.prod.outlook.com
 (2603:10b6:510:1e0::19)
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
X-MS-TrafficTypeDiagnostic: PH7PR11MB6005:EE_|MN0PR11MB6112:EE_
X-MS-Office365-Filtering-Correlation-Id: aa37e744-eb00-4522-0ab4-08df2eb1440a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|261009223027099003|10067099003|56012099006|6133799003|22082099003|18002099003|5023799004|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info: H3mHiBM05mYUCPuBawf1Uy3r6GfU8sEGPS9kBi97LhQouSTY5UN2Jg88DAvzJtqdqauUcLVZfU+7sI5s6JEgBQTz3Ci6jXhxkgErU5uweOEUs/317Zya2AU8reDnTEJd57uQ07h94yI53Sao5f38/kvQJQDaa8FRA2jDudJPvOJIXyuPmpm9GFfS/WLHX6jc5GEA8uv4OKdO8ADfSbgeheX13NpkI5+6TwgImJ9MYA+QSaeyePKNedkCKV/voj6Mq9UL+6FgKMKqPUAGIFoD3vjdjMfG4V1YEdw23THav6b0sepLUJhpKYTy5eol54zxpOfYBLQcO5pie0OJNJw7Va6yS7DLTVwiVKenpsfx709ikIu/rFJJoyVmtLVrxS6txyIeCTYQvfU3Wc1TB+mYrpWb1gb0O3rimTKKiiJweDK9Yt+UWElovglkbGKNW4Rcgzcna+8fjBmt6l/nrva8bCzg4ZUonwWMCQweaLGF555wuWeh7impVYVrfAmvzY+Lq0MB5shF9zKysTu37peqJHNxrNHHOpXN+dLRdps05FOE+CFkjq8yEBRj9Mjxs9Iw+pFhq9AXtaLFPv0FphKXl4Wyf4IYI32DEK7JYOXxsn5y77gh1Z79kLivHW0krgUtZorryiqENiZ3h+fwp/gwYVk8gJ/QorNuqrEXeW1Us3w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6005.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(261009223027099003)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003)(5023799004)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V9A8SiLROnIWffa0qE5lL/DyOxTxwXEWy5/X6bTvvEeUKI3nWQmOK/4ezocQ?=
 =?us-ascii?Q?d5tCwuyfR9U1U+SI6t3r1pR01FITGhfxtS9oLOCJRrkWyEch/wcxCz8ZNC58?=
 =?us-ascii?Q?9BbJa5eL2wkBdlodCRNapcZXoiNrKZul8SqJ3Sx+pMP8l2MzAb0Skt3/R9A/?=
 =?us-ascii?Q?bLX0SXtY4LiyZPtXxP5LykZwZ6jvUAgqljEj/9gvuvmcHwBMpeQyIPG34RQA?=
 =?us-ascii?Q?pBV4JNG8iwrQknkw/T19j0Wb1ewRMNeMP1mJfX5piXPkbEVfTog6mW1PBhBG?=
 =?us-ascii?Q?5NLq9bcEkmCH67UPDyemyASW4u3R1T+LpXeOB63GJjNnRNwP1iqyJEgr+esc?=
 =?us-ascii?Q?RoerJaGSR36uM3wraJG+nRo3IKxIzxEA2gCHzDhPkzCD9tw5AM6Cns5iJtTV?=
 =?us-ascii?Q?neg0n4Q9CjFFo6eeoU6a/rgHu7QuxkbAq741bBRXsAiOmzC5QvBjzFaXej6R?=
 =?us-ascii?Q?OGggTY88UFE9Zu1O/eV02v0/LobM3XkydQqmYhqDbNmX0NDu0aAua1Gxkg2H?=
 =?us-ascii?Q?3FuBw3LKdNXqIiaHPWrgppDxoSKdYvhE4MfI/s/1EEuWzbCrLxxXZxAownkM?=
 =?us-ascii?Q?nXYnYApyUv/TPnedtjff1PJCDC2k1sN03NBGI59S2xxyK2b1msqRnMBVZL5A?=
 =?us-ascii?Q?okcKlTAYAdgp04ruw3xxuW7jd1gWIixXt0kwBfZ/yGvMYWMP/aiI/talOg35?=
 =?us-ascii?Q?SZw58jKUyK9/uArYDgAYOUzLuS4O9CvqlqC0M5T6rEyPTKBb0B4eH11qxAiU?=
 =?us-ascii?Q?6UDOG8J+93dJDfP9CwacIpXu/AiWSAgTAiD/wBEg1VD7yfvpNYtpfkODm6nD?=
 =?us-ascii?Q?CPlCqSGftlKUDQDluZbw6TIsx8QwCCmCJxTYVoY1WpmOu4Nl0m57re1+3jXK?=
 =?us-ascii?Q?TkSH9Vr/XBnCzdyReJXsQMUSw0KIxGxtJti/Bja4/kUMlbwKw2eeykf2NH2x?=
 =?us-ascii?Q?nxQQNWCUwNebgMNrVo+HoTSV5djj7ONCdu4EtL1Irf3iBTYu56R5S2SIEVUI?=
 =?us-ascii?Q?DZVisLk03x9w4E1KyCRj/jCe9Dl0oeZcIMnitlns0o3r05LD/o5EqPZVs0oi?=
 =?us-ascii?Q?8vzVUPt/pbAY23DAg3qliRM9mn4EGnT9EpRQpZcwdt8J2qgkDF+LsKjMnQ6o?=
 =?us-ascii?Q?cLCWk5VWYo97ypseUEvsAMJwnRTN8KMRxBHoGq7uU/fJrnGEb9L9KMiLRaDw?=
 =?us-ascii?Q?x5SQ7/4dUQVlboifEu7rQ/KxO1NQ5IKZ93KB/clgzGPmf82yzFWq1pETnUjT?=
 =?us-ascii?Q?PTpi/aoHZi3hmxNJ/FOvZQBD8pk57Wr2CivMHp6v5poIwO9IdYU7sptubaMM?=
 =?us-ascii?Q?r2p6YDkjG4Wnlk3qOiaXLJtp6wOWSpgCiml0z69zes5bkLuwBMZK3Z+nRB+Q?=
 =?us-ascii?Q?mgCrumrSGOLEgDqGKJrlzjrF+lat88BV3S/2BOpoRwqv8/td3eno1Jy7JpTt?=
 =?us-ascii?Q?RcQqb+6PMhKjBKsyKyOkCKNoHkPvQPV337XbuZqqBeIzb2RSn0+gq0NyAkCq?=
 =?us-ascii?Q?GodFaZGxcZXCekPhEsz4+C+HfRD1DTbja9DfirVnvYsj2OrHGpHpT6rx94vC?=
 =?us-ascii?Q?dNkyDWAZbWilJ/N14HqFWKzew6sWWXRPs48i8bExMOmcn9hiKEzfWp/xVY3I?=
 =?us-ascii?Q?Jj16Vn8q/KGMgobpwjxBBq1ERNmkMs2F5qTaBUSFgPH8C6xH7fjX25C9nZoR?=
 =?us-ascii?Q?uEtG/ajqvA2i4bhtAGeDfwhvBfSZCoL9SOkkBoLlBpaJp/yUcgqj7E9+/ntP?=
 =?us-ascii?Q?+ET/0sth1A=3D=3D?=
X-Exchange-RoutingPolicyChecked: Zv+sIu779wbhXHVoPgBq+06Dk0gaJ1NjXH/wzgjvZCJ/oBye1q3t8YRzqbD+X5uJafEK4fEhBhxtUHIvhwarAbV1rBSXPYUUaObEGc8mVa+xOWHD4qcljYBD0iMpjL+ogypltCuMaQJajXvikPrAhcmxBK9jYHbvTikN/vsY8ZsxZkubsqocI9M0raEAWYjZ5kGo++ReiqMUqpIgIokcCRVXjLcd/yhqmA5lG/KGn5hTnOwFWF8r8EV0qU+N1YwQacb4CdiuN2auDTIlwfsRvOFfU7R4hWXMMEgFUurkrjXBqLYhu6iGL/rky/fijWWRmK5wXflIpbI+CTn94/4O5w==
X-MS-Exchange-CrossTenant-Network-Message-Id: aa37e744-eb00-4522-0ab4-08df2eb1440a
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6005.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 13:51:40.0771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xpm6BQWeS1eX2IRb7Jt7fT9kSR24s9jJwkl7u7Hb6CW2dyI91Y+ANFFBd9S+X1GMsopTMQJ//SxCWJCNMg61Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6112
X-OriginatorOrg: intel.com

Hi Tony,

On Mon, Oct 19, 2026 at 01:50:16PM -0700, Tony Luck wrote:
> resctrl_mon_capable() reports whether the system supports monitoring by
> scanning all resources. On x86 it used to read a single architecture-provided
> flag. Calls on paths that run repeatedly now pay for the scan.
> 
> Two such callers already know that monitoring is supported:
> 
> 1) mbm_handle_overflow()
> The MBM overflow handler runs once per second on each L3 monitoring
> domain. It is only set up when MBM events are enabled, which requires
> L3 monitoring support.
>

There is also a resctrl_mon_capable() check in mbm_setup_overflow_handler(),
do we need to remove it too?  But it is only called once in mbm_setup_overflow_handler(),
leave it as it is should be OK.

> 2) is_rmid_match()
> Called for every task in the system when walking the task list to read
> a tasks file, remove a group, or unmount. It only matches MON groups,
> which can only be created on a system that supports monitoring.
> 
> Remove the call to resctrl_mon_capable() from both functions.
>
> No functional change intended.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
>

Reviewed-by: Chen Yu <yu.c.chen@intel.com>

thanks,
Chenyu

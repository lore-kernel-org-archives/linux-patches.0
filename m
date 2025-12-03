Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE63830FC1E
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 18:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764785089; cv=fail; b=oaXxFKBvBt+mMh3hhu3aA+DydSV8furLog83V/hqUMouBQd0ibS/uT9a8sPiEPJfj3wuND5PgHxg/U+uWHWqRpIIhOY63LQyTvCgv8nQ+t9TC/mrJyDzuANrn7orIhRiSl3qjfB49YSLysAxjD+8AR75WT9TReLT0NBrNwrC49E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764785089; c=relaxed/simple;
	bh=mVximOI5xkDqU+KZXmWJpte3wRo9tSpYppsrank0Oxk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dTwdEHP/KIFh5qBaVS23DfBL3D+MobRNGcTiw6vTz5CX4axxB1wzQUgBwB9s+Y5qvdgFP/8AN2PIqaXgu9dHvxg03pBrU0Eqs+T2CQmuz81Z6aX20sJ2ZWejJSOx0tBo898Qsat702+9LQyC0brOJxF0mtUwuDIA2McWjKxlWug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TsYvUCGB; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TsYvUCGB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764785086; x=1796321086;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=mVximOI5xkDqU+KZXmWJpte3wRo9tSpYppsrank0Oxk=;
  b=TsYvUCGBpbp5g/uMroVVwRX2sFUXNbSvUv6UqVtquXW4RR2/jUTI64Gv
   7yEf4VIGMTbknW5cylbyxMb4GkJJZsrdhYXQknd4yPn+rrghYK/mQT+Hd
   nMvdeMkpwiXRybVp9JbVwf9gEeOUaPPX4BkGuJiosfKAHOXr89Os5eKdS
   N7/UIPm3KSOghZ8KwkMjkEvqPGL8j+0JF8Vb56fSgGOgA2Y0WQ+jeOSmS
   BDd8XrHOwJqtD/Cv0FuKkz3T0b0tRDN+ty67HHDyCt8IKcOMYPsfY+ILZ
   VQzHtDCO3S1EjYtc/b49EIQew9Xk251izkBpZl0QdrzQxa+GWRvCP6qso
   Q==;
X-CSE-ConnectionGUID: P4+cXOCbSw20AbL2FJwtOQ==
X-CSE-MsgGUID: vLD1buKHT7KvwRnJe6dPyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="77469885"
X-IronPort-AV: E=Sophos;i="6.20,246,1758610800"; 
   d="scan'208";a="77469885"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 10:04:38 -0800
X-CSE-ConnectionGUID: nV/VsTsHSRak4NtAoYm+fw==
X-CSE-MsgGUID: 6mwkbBYyQhiYz/w01OEBFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,246,1758610800"; 
   d="scan'208";a="195177773"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 10:04:36 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Dec 2025 10:04:35 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 3 Dec 2025 10:04:35 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.26)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Dec 2025 10:04:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TxvCz8++APQT/QwXMRtrVQP62w6ywmz40Oymlp3Q/8jdjjVd/Ch0Y5oHgfeSZOueSL8xKuu3Ap+fF0tvH1hdINR736DP44zwE1WEu/2qHcSguSEcK5jRn9of0XfgALxct7raEt+kZUtMmePpDD3f9pMnUmVirHgMFHbl+ZC81HAF8pje65diNMqYq0go0m/HxuoV+it3Y8NRB9d9By04dhxBt24W62k5AZPPNpLOFWtsjZRWWUTW42JBX302J3ij/L+4290GpnAvCi2PesfZNaHLkgqdxEBXxKWKiGEAUznCpl22/JYyV1NXmqG7JT746Q2wZwYrJS8/HTtpFtuBhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S6KxwWEJtQ9rZLlWjXkTJ/2dNOv3XoT5kfrdWHcyhW8=;
 b=sCi5oSNTHfkLxcBPe4pIbl/2l8L0/rpdygbtDeODnr3vnKuTWd9ze4HLORu5KDxYyXD2IRQgEI81IYxi0RA5Y/8CwO8tGkRVik8F0Ja/H0fgqmbsN/lyhgR3uchr9ICGFRLQ/CoAhjfaXSKTLteOCL/rHqy54bCo5gcto9T0SNvhhHnkAmXEVUOuzHKen65uBkPUA5r8mZD4En5B5iwC4BqqhmxNHJz+fh+pzAZTZqXxFs0+xNWkcqIQWYG6a1CaV3YCDFn3e/8vX4zc6WetoKEbRRvvlHm6Ha21B7hcWPRM1ei7B3Ezjd79QVlYrsuWcDqHh/T3u4aWcsvSn+PqgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA0PR11MB7158.namprd11.prod.outlook.com (2603:10b6:806:24b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.11; Wed, 3 Dec
 2025 18:04:34 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9366.012; Wed, 3 Dec 2025
 18:04:33 +0000
Date: Wed, 3 Dec 2025 10:04:30 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v14 24/32] x86/resctrl: Add energy/perf choices to rdt
 boot option
Message-ID: <aTB7rsMggy9nRgbR@agluck-desk3>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-25-tony.luck@intel.com>
 <ce70e96d-7960-4e00-bf26-8f61424e3171@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ce70e96d-7960-4e00-bf26-8f61424e3171@intel.com>
X-ClientProxiedBy: SJ0PR03CA0079.namprd03.prod.outlook.com
 (2603:10b6:a03:331::24) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SA0PR11MB7158:EE_
X-MS-Office365-Filtering-Correlation-Id: be783994-9cbd-4f4f-7014-08de329668fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?5nkpZ8kudD8Gkvz8b+lS3pWv0wHA/1S0z1Ps9xRF/CZuWcv4/wVQr0peNet9?=
 =?us-ascii?Q?Q2IEm+VffvI4vPEXN3yLf/zxfZzNX0nS202hcx2Cq8/O3tn8IxC2yWQXQl35?=
 =?us-ascii?Q?jljApTYgFAEIvtvzXQG4ZEYiKWmSkOzod/k6Qbd6lb1a83WEfNmNTt7bhwA3?=
 =?us-ascii?Q?uJ/3RZePQzNS2gaoNi8QbTiHQXJMef/DbJchKhh79KCTF5nsGaiWdlFBpPi6?=
 =?us-ascii?Q?e1BtO0cTCJeenJgVgFJxbfZUUqzUgecizr51D+NXTs6IH0p7nIA8Qx078Z7C?=
 =?us-ascii?Q?l+Spe1cvsCHtce5gs0mPujQU5PB0dl0UhJYL2C+baHm4MZgdlZ+28Cu0L9uf?=
 =?us-ascii?Q?Nb24WSXyw07N+sNt0F4axjX6R543VNWzVE1lUkBmNcguIzGfP8jsC1TR8hdl?=
 =?us-ascii?Q?sMYG+sSC47ncPyT3PbYiACqthFCG86RyzE2O0P037pTuSKmAP37uB/acXC9f?=
 =?us-ascii?Q?vATA4DDUrgc4SBgQ3WHgY7I+KB+mS/O2MLGcMp2hTRWGkahXFQLVOP1ESPZe?=
 =?us-ascii?Q?wvR0/f15sSdSfnsq3P5DbfD49oTGd9dS3NxdLp+SeK0aGB+vrdhA1BIPzdy8?=
 =?us-ascii?Q?U7Fpr6wXr5FaYiTmjTTtiWW+SFAD98wDtQbP47/OS1B0e5AfLQI3+eNpHRW4?=
 =?us-ascii?Q?Z9E2swDMm26lV3ZXjVlkaZUFANjnFBgd76eALCnuMkS+igIyLIROLmxYlwsQ?=
 =?us-ascii?Q?ehaKc5yIFl3aBKVa07zbobBpXY4e8+VVlJUtQk9JdqVlHqNmgGddWvatTCXu?=
 =?us-ascii?Q?Oawf/YPE8wIMAqXzQTmjP6Ll8xj0gsHNDkRmQC8Q7v9UGq+ypR5TOWZcdw3h?=
 =?us-ascii?Q?dtYKGr3vtLnJxKMasHkjZR4jGETQw5cyhricqWWf647xtXhvzr7zD9S6RRNu?=
 =?us-ascii?Q?guctNqmGG+INFVHn07IX5F0yH4yJn3VR7Hn04jXABanjsT95nE+LBzzDbYf8?=
 =?us-ascii?Q?CLZ92TbgKXBOJrdudB2X39FLt719N2VoXoYvNQfajBbT/5QZZczvfKc1ebbC?=
 =?us-ascii?Q?xAybuxfOXXzmhnCJ7QQBLAqWtpM8GhGsTfDcO8L6OkzK4gyOxyyb5d82SJPY?=
 =?us-ascii?Q?+dh7eBln0MPTBy1cGan84Oe17l0aIwv0QAlJd0iBRAJOc2+pzSrKi3y+uNQm?=
 =?us-ascii?Q?z5re0J3VPJL/PX79uMMml9AuLbjMUq3L19wRGdjw9/UnzA2pcFfOmXeAdLif?=
 =?us-ascii?Q?Ka65iloQUi+IdB0+g/NNrVPuXpZIiLlkMBnGHBUwPAMrroZZKByHhJ4hoJt+?=
 =?us-ascii?Q?+ka+kfPTAu3vSNLLwNiYMmpsmL3F/C47Vqz3ZGAQI7pjVixgwIgZ4NANygzA?=
 =?us-ascii?Q?NAgNe7zOy/Xmyxodz1jVCXLOhDr/m/rxRgr5aYGF3DzBGWkOIN7hVvDoH6m4?=
 =?us-ascii?Q?tEkYGZs9CPHyrN4Fq4pRs6nLFjEXAz28ixAy+IG1NA8T2zcXxAPq8RpHynL7?=
 =?us-ascii?Q?3iPbAjys5isu4b55T4Dlwj+cH72rjWlU?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NaOhopLnhfRfTGckoy6XFE8vMkmjhx1AvxxMmNidTC8QhfYXfASjyK4HGFp9?=
 =?us-ascii?Q?rrlW1TzpgxsfmZUZxrWx6sIAJMK3LG4f1omvFxS0V9A4x43pjk7yWluN3PEd?=
 =?us-ascii?Q?g0DVJ9jgpzf05bWBPi9bBusLmnwU/yMq+yA+fzmISsyS4KN36LSHIfdODdg/?=
 =?us-ascii?Q?5ujXOvYS7ojWolD/YvRXOurIA7oPXCu65X/sCm89lraavwQD7qEyr4sYQePt?=
 =?us-ascii?Q?jYjjJ8GYchOtcLjIpKsB42rGYi0fK3zVV6gX4xKpQrQUGFzHGo5i4kaE8amB?=
 =?us-ascii?Q?B/ABvsxUBulAihvaI9vB7ttf/DD8EQRmhGK600f3lSF5ZS2Z0eNq3mQIyri+?=
 =?us-ascii?Q?rwWPvBuwuhOgXqG/VIDSsLFjbtSWtSThiCL6zwuHN6lT6mG47hca6jK0ydGo?=
 =?us-ascii?Q?U6BArubPXPJ47ruQpRFv2QgGvE4rXV4GtRusetbNe2OlJOZ2TcX65E/hZwiF?=
 =?us-ascii?Q?nn1FfB6FromvONAsjH0rnF6K3EI68hgUmvXtCyAepDI/PceG/NJ661eV2aws?=
 =?us-ascii?Q?KRsJr2Z4zemUOdBP4KcHaX/FpbipCnB30P56TC/+jrw67znqwDiHVn+/bGv0?=
 =?us-ascii?Q?ZcTQu4z4C9smnYolJoXXqk2ONuv4P9xL/JA1n8DzfYrbDAEM5p9MaQlNnV6Z?=
 =?us-ascii?Q?7/2OX99Vcnt3ZHrC0MVnsrkDmAlVvWx2VCJIJYo9oNfbg1CEGPQ57tW8p52o?=
 =?us-ascii?Q?7/1uWKyv8LtfhO/LB5prqJpsYYX1ed0PvZJZzg5mY/kD7B6Dbl83GYgKEu99?=
 =?us-ascii?Q?CFrU7XrFdSkT1GbhnGEQ3eueFDl+AwpE2akHnBlzxikogb7A6C+5D1ooNIMv?=
 =?us-ascii?Q?GUmv6h7mob/QjIYoFUm62EBUqYRICcxK0vZ9mf9BojVcUjU4jKqMLT/CFcR0?=
 =?us-ascii?Q?w7Cgejfzb5zOI4tHBPmSf5nqPLUbqaRYCIdulAisnPADXBFt50wBjmWqSL6G?=
 =?us-ascii?Q?nB4wM+U5iU763+Jk+OSQvfi0Hdol6ClCmJbRaZrj0u+u8UVhhdPPBUb/hCgw?=
 =?us-ascii?Q?Yk6/LYxGpmiw42BpM2GUQqPTODT3IMjc+KdrNxxHACLG4rhli5Kjp9l428nm?=
 =?us-ascii?Q?g7eF0n6wZKmnSTqaNwFEgaLFdMWrZEP8ZQ49NM2/d6/vwD7xjfZpU8cvahLK?=
 =?us-ascii?Q?nFpkkn/mJRzlaa++C06yV2bAsSneqkj6m621USI2usD0q6kl0hCUWsptPfJS?=
 =?us-ascii?Q?ctBYa/cp0idPCIy84CbxSgTivAYBlqctbhGjbNPQ+dOm4b10Non9bqHQxSYG?=
 =?us-ascii?Q?+9UzSQqN5Qz7UiV8UitfZldNL8vd8pT5VJKlyh1uvbSYYHDitIZTv4Kwk0Wp?=
 =?us-ascii?Q?Cd+7W2dz4pZEfe96MacN/u291zPyCtc6Wh43ctewuRLvKUPmTFOU28/Q1RPs?=
 =?us-ascii?Q?1KvhZvPThizlCxUjmlaGN1vnEp8zcpadqqYpIM9Z7r02z+gutcP82LWPsA7f?=
 =?us-ascii?Q?2nKfLEOKBgcsoLBHE8OLvdFCBFQQitLGPbULI2OTeHnFefHi+XGPFc9aM6tH?=
 =?us-ascii?Q?aVUBgKjX4jUpeqx2dvIb5Mv3zUv1F+IjGTDzZ6+BomjGw9lkXE3J8+FprQ/s?=
 =?us-ascii?Q?d70OYxlJZHBYDiixjnGO6/S9MNl9s8P+z9dEx6BX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: be783994-9cbd-4f4f-7014-08de329668fc
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 18:04:33.3873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YQ1gG4xnaQVwlYzGXZGyBC6FsE9hOKrmc75GhevfLlPZHJq9k+7FRRoEq3u+hd7q+lgsODelbt2TckXhnCyRXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB7158
X-OriginatorOrg: intel.com

On Tue, Dec 02, 2025 at 08:28:56AM -0800, Reinette Chatre wrote:
> > diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > index 46c64419ec10..50c8b4c50790 100644
> > --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> > @@ -57,12 +57,16 @@ struct pmt_event {
> >   * struct event_group - Events with the same feature type ("energy" or "perf") and guid.
> >   * @feature:		Type of events, for example FEATURE_PER_RMID_PERF_TELEM or
> >   *			FEATURE_PER_RMID_ENERGY_TELEM, in this group.
> > + * @name:		Name for this group (used by boot rdt= option)
> 
> This needs a new definition since multiple groups can have the same name now.

How about this:

 * @type:               Type (energy or perf) of this group.

That covers how different instances have the same string where "name"
was confusing.

-Tony

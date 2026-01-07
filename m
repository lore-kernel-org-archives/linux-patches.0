Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C43F227BB5
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 22:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767824884; cv=fail; b=hwCWmeW9ZM/1LkMTCNe+6Ldj/Aku6JnI7lv4G27DpGAiBB5FVSxywMSXKZMsLUEwq06NbLVhNTts6xd1TkbKK7LSrHXPmTdcjwxtq4IyvA56DRJ/LMVCqjN4gVmV77wtv9qoq6PwhAOU5YrXab+FzlH/6PfFmyQVCqQVgBQKKkw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767824884; c=relaxed/simple;
	bh=Snd7nTtLcn3MeDCw+rBqNxwGGQXPMOaB1IAlbKoo8BQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jH1bBF7D9jVGudIwYPkiR0OwuCgZCzsNNtN5Nr9eyLy3xqFxm5vX0wAYh3J5xAOQAMU7UwelJ/pmrLxSt7OkV1biO4U12U/QwCxMEuhEtVX2cesF+ypWJHFw1oD9W54+5b5rYReUEh3Bh0LVdI4xfx4itWTIOg3aJ2ZYDv3ykl8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XoZ3mosO; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XoZ3mosO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767824883; x=1799360883;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Snd7nTtLcn3MeDCw+rBqNxwGGQXPMOaB1IAlbKoo8BQ=;
  b=XoZ3mosOInYrywmod4WElyj8bY8FNVaFE2bqxHC2JVHHpb+p9LJpcKQN
   UUyn7fY6rJ0p6hd7xzMJ3KYYFFLuUy8ZxRY4PrVPn12vkQjlZOna3sgDM
   BeVK3wOJYoQOAx0G3ul/k7n7ARfYwpn16IBDsuLMA/5APZdD9SNixaeSf
   VJlgdsQ/0QfqNfWMuagEBjLy16g2MyzittRTtfNAoxHDS4W4LKf/pm2RC
   zC1J0j2alo9ake4pBuRitaZJ2mrpIqXtgYVT8XdUqGkFO+J9TgcsSo20T
   UxndTXMwln672Qbn/gb1MXx4nvHUtJAVDilvCeXOgoSr5PLFC5jISEA+W
   Q==;
X-CSE-ConnectionGUID: SlKUxqPMTv2we512OELU/w==
X-CSE-MsgGUID: 0BTm46zARa+DuQyixh6YgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="80563226"
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="80563226"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 14:28:02 -0800
X-CSE-ConnectionGUID: VaJU1ibYTMy9PUwja0Zt8A==
X-CSE-MsgGUID: EyjLcexGRmu3ccwrJwuleA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,209,1763452800"; 
   d="scan'208";a="203090708"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 14:28:02 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 14:28:01 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 7 Jan 2026 14:28:01 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.38) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 14:28:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E1cB9o87bDbZTC1PTHahMTQlTjcCvQRB/MqM1JhbxYSaleq/6RfINTQPewjMvWqKI4TrqqcmDqCgHw826q9KnFi63AoLg4b4GAk4j/ZqEkeOqjxK0nXB7VPuJcaYSqVM6FEuxYoD7w+ILPtdB/7/MabTHdNwzMeTV8zsZ7K6LFUYEIPO8FpvS9cMRgZGpjzX0/3Fi+DcrTTiOgRrct69XwdW36rs0+pU2oWwBF9UxL8eGHdwJGKqtuKW1Cs+8ycwGBgOX+coNKhkH66AaWRNiSdIyHGlS0Y7rixCotuFsM+CiBG+vImttw1BDMLmkG8DhutiiF9djiy39vXGIhgdkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DiS0RnyvEju+HKYD8yf2SGeGkyW5dQZNje4BwCU3D9Q=;
 b=IocnkfLVqBdgvgMQmvqF9kWmJJWkqdAu2n4vaspi05JEMDUzcL5eLzc7vEbI3dT6ze0Mws/pohRdwYpYLC5hwwjAFzCYUMTXbnbkjtMtqkEIhl5e4jrEYZDPFp62E73Z+40krhYUAwzjS4Hb1TD+MrFHikqLsa4ivBlc3Ehv0jX3CBmxhe42MHSLB/OGGPBhr1LH5v0ZQAFKroxa883pnjn7lkPIzisnxhJ+0yvdp4CyTiKs3GDBrxGgA7USyOdVv+CT7bIm4u6yUjJxYe4xA9q6aobfxP70ZjZAHFysmSTbpsKalGm5VfHfrgljLsvPFcCnKN/bn+mIO9me785oVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by LV2PR11MB5975.namprd11.prod.outlook.com (2603:10b6:408:17d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 22:27:58 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 22:27:57 +0000
Date: Wed, 7 Jan 2026 14:27:56 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghuay@nvidia.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, "Chen, Yu C" <yu.c.chen@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: Re: [PATCH v17 13/32] x86,fs/resctrl: Add an architectural hook
 called for each mount
Message-ID: <aV7d7JTp_YX_4BRt@agluck-desk3>
References: <20251217172121.12030-14-tony.luck@intel.com>
 <20260105191711.GBaVwON5nZn-uO6Sqg@fat_crate.local>
 <aVwTcX7V_HN2j6SW@agluck-desk3>
 <20260105200435.GCaVwZU2gFV3LhJnMR@fat_crate.local>
 <SJ1PR11MB60837B0B18CA663282190AE8FC86A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <f3253bf3-6a3f-4cf4-b3fd-dc55e7bc71a9@intel.com>
 <aV6gU-lKrSjA2hDs@agluck-desk3>
 <4525e857-c52a-4e5d-bd74-120f66a707e3@intel.com>
 <aV7BIWu7cSSgCv1v@agluck-desk3>
 <cb41f4bf-7eb4-4a59-b46e-8bc4ae18e6c6@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cb41f4bf-7eb4-4a59-b46e-8bc4ae18e6c6@intel.com>
X-ClientProxiedBy: BYAPR21CA0019.namprd21.prod.outlook.com
 (2603:10b6:a03:114::29) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|LV2PR11MB5975:EE_
X-MS-Office365-Filtering-Correlation-Id: cd225abf-0117-41db-f28f-08de4e3c023f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Ibl57M8fPF3Lu4SV5WtcvpSW7EnIXmPEHHFL4blOAZIQXHASEDhMLU/bTE39?=
 =?us-ascii?Q?wgJU+usjL2ChJUMmLQjRhFAAu0zgjY6S8wxx/1WjkGHzCxU5e8NTE7rWgGJd?=
 =?us-ascii?Q?JIky5HqO1sTzJVwENW5M3CRS4VJF4BHx4V6Yuv15RfO66Cp5JysSswsTDjJM?=
 =?us-ascii?Q?hpv9dgFR+o+o/MV5k8Tu6p0s58ZXDgv77Wrr6JNgzlAnzl8Ed2skGdnr8kzJ?=
 =?us-ascii?Q?N/kYcB0P09UZLd7Mppi6J5mY2TnqOPsH2TdpLlngB1e0rabjC0kyxfY2HrXn?=
 =?us-ascii?Q?COodi4Ye4JZ+Ar9oMcy6OCS0pzGywbmnvcxy5QBOvtJmX8JVJ2WFV6HU58+v?=
 =?us-ascii?Q?gK5awuHq7Yib1RYNG+DWJwrmLqzk4sbizl4Dg4YjfbaRr6U8BS4bRqYn7KtN?=
 =?us-ascii?Q?YQsTqMdZNn7/tAEctAoGtWu/MkeuxaTj/F2g6p3Dl95Dkb4U09cuJ/2tuHns?=
 =?us-ascii?Q?H4YQbvtXU8ny0felVpel4dapJKzitdPmLP7FqcldDb6X6itk+yFDzLBhVk46?=
 =?us-ascii?Q?i11QRgoZHtMtTX+41jaTwKi/bE0DpmA+HD/fbgWdVWOGg2A1QoORS+Kzi6HW?=
 =?us-ascii?Q?uelgjWnN6xJSy0wTSKoGvl3XvKFrC/Cj/rBAtxJVF8rBE6amrXzyZt01mtbu?=
 =?us-ascii?Q?2P5HIbNlbdoL+Qd7qDN9NNXMC3snjMRkqpXpn7GSr3JgVgZGxGCR6VMnIsBn?=
 =?us-ascii?Q?al7Jwhkqy9lGCEtO/nH11eH7nZFgUVWN2Sz33Hh7Ezc4QVkir7Q+dDcU5xge?=
 =?us-ascii?Q?kjh0+m8ALM+BVvpv98rd0vvvvv8/U0l0StkngMJQHBZccRqE/PMozoi0YoXD?=
 =?us-ascii?Q?UTrKAcsKQEbaoLYehu3SiQ1jYGEw4vInrTrxuLJweIV9tG1XI65+lnqXVjBo?=
 =?us-ascii?Q?mRA8oJs66MPuo50hufJAuUItT1R0VTDybXjUyqAYopDK4V0Z8j5VGiwDWnvM?=
 =?us-ascii?Q?V2CZZpQEfZR/BxfSIgnXnMyOBi6T7FSuo4s9BeoYTjY0mxoKe0fofyrMmtYR?=
 =?us-ascii?Q?D49rxgnYkuNcdcnqHV5/gkG065U5Cps4gZkK3/u4k2lH6+v2POnCj+fdzIQb?=
 =?us-ascii?Q?u8jwlUyXdt9HTwoM2lQYWOjErmdxzQm8lIv7EPST74MHZ0X1gebwo8meK38G?=
 =?us-ascii?Q?rd2uQgSP2VkfTwT/FK0gPFhSxiHMKiGsbQZ7pL/jhigcOmVOls8dFqqt70iY?=
 =?us-ascii?Q?qKpqWeEZ6h7MBYnG473gRISNtf6RvjGlkz6wk6G9SRH5o/iKMV/wOlmpUa35?=
 =?us-ascii?Q?4+d5vFYp6GBzrMJFbbDwiIV+8e2MxUz72XpaXELJVgHCs1B50fykRn0uHivB?=
 =?us-ascii?Q?VAHa7kC2x8Vu3x1WHXN+d9Mtn+D5wjKSdDNZjERB4Dzw3ZqxP0bEL6fc4uUc?=
 =?us-ascii?Q?kuFthPBNoiu1YPfQ08jJVpWAQvd2b4iR7sf1R1fZxdiTZbZzkOPyEwHTkOI7?=
 =?us-ascii?Q?dyccigZ1ahExYbKVRvLIm0trpF57pKvg?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jd6Vrm8clJL94dCOr9K6ofD8404qUwIfTxhR0oPbWwh1kgD1+DO8j3qEPvKk?=
 =?us-ascii?Q?LZT20IJKbkQRxEGD6HdPorgveMO3lLBAwakoVV9VylORwdCtXjf3jDyFaa8O?=
 =?us-ascii?Q?0awxq4QZY6bwTeHckUuTHP0PMCk9l5hkCR/937vnw3cKJVEo/caOIEuguJTr?=
 =?us-ascii?Q?onqtmqQ0K3vXg19E/yKhH3No9RsYK8dxHxnRBZu0q0o64VvrJmeF1WBUvgUO?=
 =?us-ascii?Q?A0zhIOxqjUpyBz0zLvN+3uAqieaZmrASNPLCKihMaPJaZ3VM56e6xUOid7vT?=
 =?us-ascii?Q?qeWnIs3xkIs4JcqbAaqBtq27QDGy94yVaYPXtaEjASsaQuEhUDt2RRBUPUDL?=
 =?us-ascii?Q?0U4wMRH7prd7QV4QXKXtRyvYE395nE+Q39R6V7Iyt4xpuO4qLkZ35ddt4n39?=
 =?us-ascii?Q?sJ/l0/Y3TOkZYdmG1fUq6qHZnrVw9KJYaXN0OBAF2V9y6zmFVMU/ZRGZv7Yj?=
 =?us-ascii?Q?I9yGpfrJQD5KUXwRBDWeH9wxmmn2jBH317WFcrcILrIpLsgwqAsWNYmPukZe?=
 =?us-ascii?Q?OCaBGz4Bq40BYkL1+X9kjuZZG18o5sNhWa1ZdB5CgAvjr+ESjfby1s647lVB?=
 =?us-ascii?Q?rdiYBt6ONx57xg0d5FaRtkBbSx3iH/P/RUUmlkAk2YTZOgXr/E1J5TJKtPAm?=
 =?us-ascii?Q?p8LxKH9pr3wxb4+Re4YfKeEAmyaN+PEVP9BcjkvvtcZANU/6RAMJk+KjauxR?=
 =?us-ascii?Q?CicJwfYsLFtoppaYZHGCmi8mEZZLpIc8N7y/cFEeIX8Ml0Ku+4Xod3IGK9IM?=
 =?us-ascii?Q?7LXY3L/xQ0x7WrIRTRS5PE6QIpZc7Jl9CptYqH0ztN/ag9MzFEdk3HA2k6cj?=
 =?us-ascii?Q?XXc03p5Uo+/g/+99VYFm5BWmMoxiAVYSK4jrc1L9c8gVUzZnYDU0eVob7qgj?=
 =?us-ascii?Q?yN6z6DSeCFoQNT0aKYcAW56YuJ64u3hsK5vU0JmRi0fEAMsrXs5uulqEch06?=
 =?us-ascii?Q?uEXv8Z3WuXhtgMYXkc7SvoW+m2XWLBHtUfz1OmkpQ+j/8PS8kit+M3ln4hnp?=
 =?us-ascii?Q?ZZRf5iE4fF5xl21dpxiGf69WgdcGKCkJ9rS7yFHuwqrgCTisfIkECgWTP8jE?=
 =?us-ascii?Q?ETORUkCPRXHJAQ6AlHPSkZeB7Dj+JIGilCfmKAvoGBLSefT+G3QR/AWSqfSS?=
 =?us-ascii?Q?Qlgrdt6a+kyFXf08t18ORMVLLdhByuoCRKPux634a2QtUDITrttAq9lpCuNL?=
 =?us-ascii?Q?JPoWTk0kDhB76WuXfgmcvmjmRk5cOoLmLk4GzM09Yc4GVZ60YdKJCqKkzngV?=
 =?us-ascii?Q?1Ho/dElCxaL5U0fK0iflLwMcGV1CdWjhnWSq6klQbqScUI3Ib7Zxq6zxyYTf?=
 =?us-ascii?Q?QiIgTui8K4ev+Yd9zX3Dkjqh8uMgRUSioeXMqfoDgqhVf4jkfrfKonwfTCav?=
 =?us-ascii?Q?1pdGfBHrgk6dR7AvIo4pDgjysodhwLcgxWi3AWaDrKrhpAMGr5vmtk+1R+y/?=
 =?us-ascii?Q?C9d8Kv0+Rddt456MytUcjKQIEGdGdDBb4+Sxa659lyuxoWUhiyNcVFjMUfEz?=
 =?us-ascii?Q?VEp99b02eA1216xBZl70oZ1ZGpkC+C9vkHk5bvH/og6h+FmtJgkgIx3iMjv2?=
 =?us-ascii?Q?HAM7+BM+Ic1abHi3lFIomfWgz8wGfCAvvdDNkaxAKlBqnbatJxqha2t6C/0X?=
 =?us-ascii?Q?3Ysxr0MX9Z3jPQvEj7FAQ1XRbP779+noN/60iv2mqQBzVey4Rwb13lHVSDBu?=
 =?us-ascii?Q?78fYOVumnAjnfYb+0roYqMG/fBdRVFt450MKAyLuIys8yFHLofHTdH4mQGyN?=
 =?us-ascii?Q?dJOcJjW5BQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cd225abf-0117-41db-f28f-08de4e3c023f
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 22:27:57.7642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dxtYrs2nUzXDbYa+Zwqgnd7LHzYIECM7DcT6rYYaEuFQljRYpb7vlu0AvfMa0UyzTjw4CKbsmuPTu3V1BXqIbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5975
X-OriginatorOrg: intel.com

On Wed, Jan 07, 2026 at 02:09:35PM -0800, Reinette Chatre wrote:
> Hi Tony,
> > If these DO_ONCE macros are ever used heavily in run-time code, it might
> > be better for once_lock and once_mutex to be statically defined in each
> > invocation of the DO_ONCE() and DO_ONCE_SLEEPABLE() macros. But the fact
> > that the static key protects the spinlock/mutex from being called may
> > mean that it is practically hard to hit problems.
> 
> Which problems do you have in mind? One problem I see is that since these "once"
> functions are globally forced to be serialized this may cause unnecessary delays,
> for example during initialization. I do not think this impacts the resctrl intended
> usage since resctrl_arch_pre_mount() is not called during initialization and is
> already ok with delays (it is on a "slow" path).

Reinette

Yes. Unnecessary delays due to serialization. But that only happens if
the first call to a DO_ONCE*() instance overlaps with another first
call. It might be quite hard to hit that during boot unless there are
many uses of DO_ONCE*()

Looking at this some more, DO_ONCE() is overkill for mounting resctrl. The
static key part is there so that DO_ONCE*() can be safely used in some
hot code path without adding overhead of checking some "bool done" type
variable and branching around it.  I don't see anyone except validation
executing resctrl mounts at multiple times per second.

But it does make the code easier to read with a single line with obvious
meaning instead of multiple lines with declarations, initializations,
and if () conditions.

-Tony

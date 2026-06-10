Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27622DEA68
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 17:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781113698; cv=fail; b=MG6niU4cHGxH0FYwzRWSAGvFuReflOP3LsZvZu/iG0LPzUO/FVHumhMIvfFMzVHfokUGsmlnXcXLSnfsu79yT7e1BgItJLfzbdLMMyk5Pr0N0YggXYC+ItJMXiWCVWLSz6O4Hje5qewJBmMNi3mjDCKpAZUi1/U+QKeGJcdZCuQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781113698; c=relaxed/simple;
	bh=aM5WZ4eCmQmmKZSHx2MeS7Hg5bNIglm5jpMkpwyL1XQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C8OHZAAJHLXXAun6qAXEb92pkW+sK49x5fm0E9gT5CmL9YwMKmHnDc0AcWY7ia11afwezzyqmzADElaiRhk8kiJImzH1Y+xdA/RJw+kE1dHX8bk1GZog9O/XTE5oznBbwbkkTm+nYT5E7KE16kI/uwFPIQJ0dHMgSAuoc0hiSMA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KvbWCfLf; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KvbWCfLf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781113697; x=1812649697;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aM5WZ4eCmQmmKZSHx2MeS7Hg5bNIglm5jpMkpwyL1XQ=;
  b=KvbWCfLfbjtlp1+ig6LztHUWmLRbrUY6b/mJpwONcFqzN9krmMcKYeqQ
   szs8g1hKgCQuv845H6eQi5MCV0LBuHN/tWckaAaJkDbl7hZRFOHUenP9p
   GL2gp10Y1rFlgVawrG34faYLiaUO6YglneKHdxn7sdhLClYZdJO7bOhKy
   VNSWS6sqPiHledK0uItLeef14brcH7xqlNqiEy4n/rjSlcl2zmOtKX2x5
   7VpJ9ndarh1gMf2rsbnzH1ebEVk56HsQJK88wScQfoxdaSP476lfDOT7V
   jYwU7CN6i0nCM7Fj3xxhunVgbebAyfXrE4Oe+0O/WrfpayLEE5xJv2Dxa
   Q==;
X-CSE-ConnectionGUID: 073FOy5AQsydO9h6dHYeIA==
X-CSE-MsgGUID: Zr51sLxuQbiJn//4i2Gx2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="92234961"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="92234961"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 10:48:16 -0700
X-CSE-ConnectionGUID: 6ucOJ5kaSs+S8UeDhUCJzw==
X-CSE-MsgGUID: QaJyu6ZtTV+WFjq1096Czg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="270234838"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 10:48:16 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 10:48:15 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 10 Jun 2026 10:48:15 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.63)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 10:48:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rVh7QOPJW5DV5IFJilc4+4cHfpdC7twuryugIKuVTQEQCkHR7C0PeZ7Kt2aygsgNjUcdNgjkuqgF/Z++u18ZVZVhH1yarCABvCY2cUaNHFLXqF1ZTnBSQt1Co2MgnpIl0d/f3zVdZ5a33WoYDlySulmNUcs8mlfgufthE22mVhXRfWFKBG/4k9qTwZ+hkHDQzp+sH7L/kuPG3qXu5qg5JwhpShA+A+J5gz+nk9bvl3EsEcIUNUrLtwfszMOCohOkNhKp/SnC8eO61vJ3oubLMEGwac+eJhIi8AGD6Db+NbO1sfMbmCAhqmyzjP7nfWIBawtsWU5C/cnzeRthggQEwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o7PJRMnbayuHjYEQ64sBprJCssrMaAw0mQX0Q/Ea4lo=;
 b=tT1ny5iB1/0NyRGSld30diutapfSLAt7wbA4Yl9AVBk7cRujbuSVIDcWYI0nzpCrWQ510aqzFNjVo+XQVfaofZ0yNMy5hUEt/DWgT98PPBNW7bAIVE/h8PEOeAfUATnJZbEYIMpMAsv3imDQ+n29VSaME8Ic5si6K9A72hmMUseuUc9FBx1ybZuag8i5QWzP8eZbS+SjgD6agcxHoEzB6x+QB71kY89yCHPZlLy1VOEUQ0DMZqOZj7A/i654D/EODm/m7TEK7osFFo2vk9icrvrkjg3AR4rLzlQ5yo14FDQq85TMmmCMTxL6YK79SrsAItxX5c+qOojIkslqOFhqUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SJ2PR11MB7617.namprd11.prod.outlook.com (2603:10b6:a03:4cb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Wed, 10 Jun
 2026 17:48:08 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Wed, 10 Jun 2026
 17:48:08 +0000
Message-ID: <28449c4f-49e6-4342-938c-4a3699e3d682@intel.com>
Date: Wed, 10 Jun 2026 10:48:06 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/11] x86,fs/resctrl: Fix long-standing issues
To: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1781029125.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <cover.1781029125.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0323.namprd04.prod.outlook.com
 (2603:10b6:303:82::28) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SJ2PR11MB7617:EE_
X-MS-Office365-Filtering-Correlation-Id: c2a565f9-f691-4e39-d9a3-08dec7186ed3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|7416014|22082099003|18002099003|6133799003|5023799004|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: GcZ+aXaraM1E3NFZvPHi05leGO8Gv4PdbRPscFHrhCWO8LsadHNMhM+IU9tKnGyY5wWjVT2NbBt/9wcNyliv/RDdrpmaCQ5dC/OqtYBlOkmVDSGnHfpNwodV89pFBdjhI/3V0Y2Q0yhLd5i6xiVRAXgflXNFuOPQfuuTW4B5bDJ5XeSPEaoi2JamMhtwZ8bbK4J5+cWVZtNYdEbbnmnxhOs0cd0hfFUCZC66JbRkRmG5Y8tpxwJZ8SzuNgSLv2hzAPEbNMhFhOJRgU2oE97y/oAwf1BkNatPTmW/KxAkvlgc2syQ0m3on+l61Xx6LT5QOvDfj2F5ZKHR3V1HTQiStXH6kufwRCVF9dGR2/Nd2MYAU9XhfVcs5ksdwLQZV0J+aVCtwNQtEvLlIyFkHvQ02toMHYlxNYkZQo3Q/bOaCkAog7YN4maLh/Iw7QZLYhkbbxgQ/8GMQRB73oe/0i7WBp1LiBQIHLmsoIrg4Vz1/DdaWE7LQuBUJFvTykkp2mJJicu6ErlnwC1lBrLXFbIiOtH2Jp3sGNwEMsthzxDITDJH8ptRJroAoGXuNKX82vEBwtv5s9eB/maFFpyG7ak3friMj4whs3+jxz+uAqAX7MPXSpxTrpOXjhbJxvufRbVjeoPDAVMdT4iK1/uUAEgHyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(7416014)(22082099003)(18002099003)(6133799003)(5023799004)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1JsQjJFZU1CdXQxTmM2K040TXIrSGZkTlFReEVLUkxpeHJSRi9SVHA4bkRQ?=
 =?utf-8?B?SVp5MWp0ODJNYzNGd2w2bER2eVpnL0RITG1vQUNYcURZQ2JsaFVOMWJnL1pS?=
 =?utf-8?B?STRzTnpHanhjNnpsazFKN3pNQUdmQ0V4T2Y1UDlyUlFDT3pLeTZNVlpxMm9p?=
 =?utf-8?B?dU5uRHpZeG1Kc25yYk1mdkdsSXVTNHdOYkhjOHhUM3Q2VmpicDhpbmdqRGl5?=
 =?utf-8?B?UGcyR2Fib3ZieXFuQnV5bUwydmJldk1GZzRmK1FSTlhZZnZnWUN6dWhndlVt?=
 =?utf-8?B?UXFEcDZVd1g3NG5BbEpuUzFtZXRjdFNRZ2I3eURLbjhZbGp2Y2ZxL3I2VUxY?=
 =?utf-8?B?VDhYeHJzWDNqOVZKWkxaWHRBSlBzNVl4OWFKd1RWK1BqTlNBYUJqWXRXVi9x?=
 =?utf-8?B?T2RMVHVZU1o5SitSNDRoZWNBbzVSNTdrQkcwRlVyUmNmS3JaWm9UZGhpdEVP?=
 =?utf-8?B?WEdMRlgzcG81MGFyV25HRkgvT3dOQUpsek9acmtweGE0bk81QW9JZlhUZHpZ?=
 =?utf-8?B?dC9naGhTNzZrcXhmUHJHQ0xxUzYzRlozT3NYdi9TZERpOTRKbkVOb2U2QnBn?=
 =?utf-8?B?OEZwaVlKR2lHVUNHWGtxSjA5ZzZ6WFJKR2lvZDRmRTNQNTY4R1kzNlBIMlpn?=
 =?utf-8?B?cmtGZWhYVERKeWEvMk9TS3lrTk1hZ292SmZUSlEyS3d5K3o2ZlhXd1A3OHRW?=
 =?utf-8?B?cTBxTUZROXNxUWtJcUZ0T1N2REcxQ0hSNm9sdUJpVlBkb1JaV1o4UVlaSDZF?=
 =?utf-8?B?R2daTzJtZnFnTkt4aTIvYzJIc283c25WcU9iVGgyWUs5L0M2UXRld3JhSXFI?=
 =?utf-8?B?ZWphSENvTkdEUjVtbTlEaWo2NmVwbksyT1FTd3FyWkNoY0UzNlA3ZmhTMXRn?=
 =?utf-8?B?QUVJay8wbTdVcFJpczFWY3FMTXorSHgzNWh4YVh2WnhEcE1OcU55dGNxRnRH?=
 =?utf-8?B?L3l3L2E1MXAzaTh4ZHVWeWNXcm1GdCtxUXdKQVVYUi9XVU5LZFgwUlVNQU9V?=
 =?utf-8?B?Mnh0THUzcDA0cUhTQ0VKTzg0ODQxRzUyMjBoRXdaT0QvTE9iYmpsMjZ5MHRr?=
 =?utf-8?B?WDBmTEhiZ3gvd2Fib01UdEZSclp0YU9JYUpURjUxdlZLL2pKQ3ozYmNnUGdO?=
 =?utf-8?B?L1N0d2RzYWtwWWJpSnRQSzRkTDB6dEpFSHc3K25hdnl6TndmSDFjZTdPaW5M?=
 =?utf-8?B?L2trcFBGdFU4b1NFRmdqSElIMW1NOFAvb1hXTHRRem5GcC9NeXQ0K0lscnZF?=
 =?utf-8?B?TnhVbUtkS1d0dmVwZDZCRVo2TmUwQXRyS3IyRkE0d0t5TEl0Tmxkb0ZBVjlI?=
 =?utf-8?B?MTN2UWgrNFpoN1IzWENjZ2JVYVlRdTdxNHkvZm1IUTZHS0Y2WitHYkE5RWhN?=
 =?utf-8?B?NUl3MWh6M2xWSnJoTm00ZDJHL0xXVE1RbFhxMG9XSkFHYk9FOWRqK0RMbU0v?=
 =?utf-8?B?OGRKR3pzaTRXWGxvWGpHSlBuV05zSXRkWG03bkRuV21kVnJac3BucU4wMXJ1?=
 =?utf-8?B?NEYvR0tqRlNPNkIxTTRjeUlUclhYTlNVS1VMN3c5d2o3dzMxU2VWeFExYk82?=
 =?utf-8?B?dHJSa2t5M0hrbWRuYTg0YlZ5OE03eVAva29IT01FWFIrQ2lvWUhTaEVycWNH?=
 =?utf-8?B?aU9MMFM4aXNKY2ZFcDZpUnFLeHByZUNoUGtDOGNqZVdCZ3ZSL3hkREIyNlZp?=
 =?utf-8?B?SGRYdUNQbGc5b1JIUENQSW5uUUJJOXgxWDA5RzJDdE1RVVFPNzYzZ1hQZGh5?=
 =?utf-8?B?bkNwSVZVaFBtQTNpYzRnaDlUb1dsOTZDaGtQYXdTU1l3MHZXK1BQOUR0OWVk?=
 =?utf-8?B?UGcwbnJaZHZzMHJEK0RqWU9jRHV0cFdJSlkvd2VBMlVVcHJTaVV1aGpMenVy?=
 =?utf-8?B?aXNGOXBVYWpMeVJQdCt5c1pIMzNDK1g0SXNDUEFWeVJpNDk0TG9LOWNrbWkv?=
 =?utf-8?B?ZTdOb2J0QkRqSCt1NXNHaTcrMUxmWitzWXVUemlQVk1Ec3dkVC9zbjM0Z0Qw?=
 =?utf-8?B?QmppdVI4YXZma2VOWHhOMWdCMzJWMnh4ajQrcWtaSmFGQVdpVlZlZlRLMDBy?=
 =?utf-8?B?R2Yzbmx2T0NIMHRYdTV5NjhBdi9pVTNia0czVGtqUG5Gd2MxWll0amNiSmpQ?=
 =?utf-8?B?Y21PNXE5b01sMW44a0FJR1M3c1NBM2lxc2NwdHBpZHVHVXhkSlFaSGZydmZY?=
 =?utf-8?B?M055L1lkMy9WTjBHS2kzRTlDM3pndllvVlZTL1NrWCszcnZlbExSUWhXc0ZG?=
 =?utf-8?B?dVlPZ1RCQlQxVGFTT1JINnJDYVcxN2c1dkJOZnErVE9KUFVrUE41bUpyRE5m?=
 =?utf-8?B?UjdRTjRxSGdDdXNvRG1qcmxuTS9CTXFZdUJpUWJuMVpiUVR5dmFYak9QUUhE?=
 =?utf-8?Q?Q3TULfF2dqq1vPPo=3D?=
X-Exchange-RoutingPolicyChecked: aFO4SWW6X+0F/uXQVeePtVb/RgnVLgdpDRX2c0emHPlNsRJU5fo1JSsPMcSK32rsEpp0QiCDImfTEDbCQWTxAB8mzusAB2cUq8DiZxww2AAG5AVChN6oCUYFrPDn+69uLmchB2p12pyf8PejhOziPlIoWQQ3w1OEy1HiyJkFH1tm8ei+D4SUaNPGriuHEUhfm+aOox5t3SKb0aDxVTCXRJOBi5HPB9K9q2vNKibp0VJyTy9ut8j7Fr36K4jgrfdKuumhHqRav5EpTg/Bop6wj1zJwZJuVln6znxIIe0B+ZaG6yYs/dT+OKa4Otm+/HDMQtyOojWDcSUXzL7FGorgzw==
X-MS-Exchange-CrossTenant-Network-Message-Id: c2a565f9-f691-4e39-d9a3-08dec7186ed3
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 17:48:08.7394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0YPRZ/jR4y61q9TplDHCfwGbZjVZXMKkLh+31nHt2E4v93DNpXMoB/pAYHruozVLsHfcnD5lspURnCmcRY7MvscY+k1AAnC1pdVOxcO0t+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7617
X-OriginatorOrg: intel.com

Hi Everybody,

On 6/9/26 2:02 PM, Reinette Chatre wrote:
> v4: https://lore.kernel.org/lkml/cover.1780456704.git.reinette.chatre@intel.com/
> v3: https://lore.kernel.org/lkml/cover.1779476724.git.reinette.chatre@intel.com/
> v2: https://lore.kernel.org/lkml/20260515193944.15114-1-tony.luck@intel.com/
> v1: https://lore.kernel.org/all/20260508182143.14592-1-tony.luck@intel.com/
> 
> While reviewing the AET series [1] Sashiko reported a deadlock during mount,
> and a use-after-free when an L3 domain is removed during CPU offline. More issues
> were uncovered as fixes were developed and reviewed. While the goal is to
> fix all issues the races surrounding pseudo-locked regions are not yet
> solved and have been removed from this series (last appearance was in V3 of
> this series).
> 
> Applies against tip/master to ensure it considers pending x86/cache changes
> as well as the lockdep_is_cpus_held() stubs available in smp/core.
> 
> Changes since V4:
> - Add new fix to prevent out-of-bouds read when SNC is enabled and domain
>   with busy RMID goes offline.
> - Add substitute for "is domain going offline" check to workers to avoid
>   reading any event counters on soon-to-be-offline domain since its
>   cpu_mask is empty and reading an event counter on an SNC enabled system
>   depends on knowing a CPU associated with the domain.
> 
> Changes since V3:
> - Drop majority of pseudo-locking fixes, only keep the double free/double
>   list add fix.
> - Add patch to help document safe RCU list traversal.
> - See individual patches for detailed changes.
> 
> [1] https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com
> 
> Reinette Chatre (8):
>   x86,fs/resctrl: Prevent out-of-bounds access while offlining CPU when
>     SNC enabled
>   x86,fs/resctrl: Document safe RCU list traversal
>   fs/resctrl: Fix deadlock on errors during mount
>   fs/resctrl: Prevent use-after-free in rdtgroup_kn_put()
>   fs/resctrl: Fix double-add of pseudo-locked region's RMID to free list
>   fs/resctrl: Prevent deadlock and use-after-free in info file handlers
>   x86/resctrl: Ensure domain fully initialized before placed on RCU list
>   fs/resctrl: Fix UAF from worker threads when domains are removed
> 
> Tony Luck (3):
>   fs/resctrl: Move functions to avoid forward references in subsequent
>     fixes
>   fs/resctrl: Free mon_data structures on rdt_get_tree() failure
>   fs/resctrl: Fix use-after-free during unmount

Addressing Sashiko [2] review feedback here:

[PATCH v5 05/11] fs/resctrl: Fix use-after-free during unmount
  Sashiko encountered a "Tool error" during review of this patch. It was able to
  complete review of identical patch submitted as part of V4 [3].

  Even though Sashiko encountered the "Tool error" it did report a new issue. To help
  make progress with the existing fixes I would like to propose that adding new fixes
  to this series be stopped. I will start a new series of fixes to address any new
  reports.

[PATCH v5 07/11] fs/resctrl: Prevent use-after-free in rdtgroup_kn_put()
[PATCH v5 08/11] fs/resctrl: Fix double-add of pseudo-locked region's RMID to free list
 The existing pseudo-locking related issues are known and have been dropped from this series
 (last appearance was in V3) while trying to determine how to fix them.

[PATCH v5 11/11] fs/resctrl: Fix UAF from worker threads when domains are removed
 Sashiko again (previously reported in V3) reported that this would trigger a lockdep splat
 on MPAM. As described in response to previous report [4] this is a false positive since
 MPAM does not support the software controller.

 Sashiko also reports that "Does this exact ID matching and premature break miss multiple
 L3 monitor domains on Sub-NUMA Clustering (SNC) systems?"
 This is a false positive since the software controller cannot be used on SNC systems. For
 confirmation, see:
 commit ac20aa423052 ("x86/resctrl: Block use of mba_MBps mount option on Sub-NUMA Cluster (SNC) systems")

After considering the latest Sashiko feedback and deciding to stop adding new fixes
to this series, I do think this series can now be considered as "settled".
If there are no concerns with this series self then I would like to proceed for it
to be considered for inclusion.

Thank you very much.

Reinette

[2] https://sashiko.dev/#/patchset/cover.1781029125.git.reinette.chatre%40intel.com
[3] https://sashiko.dev/#/patchset/cover.1780456704.git.reinette.chatre%40intel.com?part=4
[4] https://lore.kernel.org/lkml/9ea1986a-a88f-4224-b530-252e0f5cbfd0@intel.com/


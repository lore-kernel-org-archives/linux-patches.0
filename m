Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361904E80C0
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 11:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789559490; cv=fail; b=oylsvwxT9SaLsMZ1GdeWlcCQhDGLv3xIQVCcnfxapUk4xxnj5L6oxKdrq7hDGDPx1zIANubkt1peDr3kSbJKHRHwdFXyxtVW7Qh/pzr+BV/UDhzUMw0Mq0i6CDtdoxV6MkdORtraUlskL28YreM4MJ9+IF3ULqLToXrpyZ4pUno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789559490; c=relaxed/simple;
	bh=NJI4dmzACdCDdbKKAHfD8HV2MprKTsdpXOkrKK+Z1Ks=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nXOZ9M1ldm0J+CjnBGpRtbm+IfieetNVo4NBIHu4+YMVHK7Tv82camIXFNrH/cKTgXfFd7/LjnzLuYyv/tJJF0TPWF1k9AdZHPK0e7tZzPoZZS9c6Nm848EhbOk2I+RDhAwMqhEwCY1AI0UXq5VIpdloejBeCKrFqmsyjlPaVD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ex3P8lJf; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ex3P8lJf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789559482; x=1821095482;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NJI4dmzACdCDdbKKAHfD8HV2MprKTsdpXOkrKK+Z1Ks=;
  b=ex3P8lJfIThkdKOP7GzIcfcdnzG0TW5jxybmr2j6MzcfwrGqkCmiNM+m
   BZeF5sDuDw9hH4Dq731vyl776EsTepXTO0ZcryYNJ6wUl3lUMk1ECRR+e
   pKnzAWtPoVVu//YnWzq1cJOsEaPHgI/QkrJg9jpNAOGLn/48YOtz6R3qU
   oklWNYB/J78JTuHfNZMpUbcmk+8O2iujbcLQ/nczLH8FUYGJfa46WrSLs
   bLaz2SpJURRZFTJgqtrW5E/yWOWHe7404rZZFSGZpHMvyXtNOAiQGITSZ
   fRstJOQuX9H1dnTkQg1pqmcTTWfg84LGdE+n/k/nJtZToAv05fT6Pr4DB
   Q==;
X-CSE-ConnectionGUID: Obebj9u/RJGGwpcX8qEL7g==
X-CSE-MsgGUID: tlVfOTUIS2qHcqcsVYyRSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="89803609"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="89803609"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 04:51:18 -0700
X-CSE-ConnectionGUID: Ghbaz9g6TPKwv5pr/+YrVQ==
X-CSE-MsgGUID: 53tYI/jQRO+yOSEk05vwcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="303204966"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 04:51:19 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 16 Sep 2026 04:51:18 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 16 Sep 2026 04:51:18 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.55) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 16 Sep 2026 04:51:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NtWMSqbl5uoZBQCJ0S7+WW85QNb/MgHc62mDkh2S/cHTBQRkX2UwRkwrNx6zdtDcFWUsaeiwweIt5Oj+qfbxVl6vEzFLqUFaYl3cCvJQckxT0vzFhvdXY8C1u4Ze44l3xJY4f4URYSmZl5H/CkJXRZyfXBKDrBhXgsWsJY0QIuEo2gd58vNYoOt1w8hU2+kOHFDLB9n8r3RiwQ9yevUIc63qMYjpHvCDAMLcB8TEF/bT5rizR4Cxc/CchCAjCZOmYBbZNvrl79SttEDyFihS+bDhx8CV/NvtgA65Q3pJDuI5347r4j78ET5rzJtGS96AAcMI3LUw33XLrdux7yWYcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9GZ5VPVavwpp1C6mGFYaHM58/86r1LPH6lenhNPJH+k=;
 b=RUk91DV2/A2z9Yt+xsFoA1i6FZh2g+ojggXnid+gVZsdqmj6+38f7EbRNpqdTUpTy4e2gAKRCSYHKtfcKV9ZVMA9/ASUvXOwadLopKT4cqsZDWOovo0CdRrw1+epOitWs0i4jtecyR1QsQPeZPatjJNuDYXgLzLi9uX1DIvBhlq+sZrATUEYFy6qwFNT1vXT/hkgBlR7S7KyLcjPeD94aoi99ohsvkJxVku+KxlObxolLBpVCasjHjSKUD03Ix8Ngpa3WoEGFDxG/7iHzlMgMJ0xX1kL48nW/yjHqLF1xl+IpTcNMCWQG1MrBZzRFs9Uf0OW3ciK93AXk9JFbqQzGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 CH3PR11MB733910.namprd11.prod.outlook.com (2603:10b6:610:363::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Wed, 16 Sep
 2026 11:51:16 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%4]) with mapi id 15.21.0406.007; Wed, 16 Sep 2026
 11:51:16 +0000
Message-ID: <7694bd55-da56-4864-a98f-e4ec33b85321@intel.com>
Date: Wed, 16 Sep 2026 19:51:07 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0344/1376] sched/fair: Fix overflow in
 update_tg_cfs_runnable()
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
CC: "Peter Zijlstra (Intel)" <peterz@infradead.org>,
	<patches@lists.linux.dev>, Sasha Levin <sashal@kernel.org>,
	<stable@vger.kernel.org>, Vegard Nossum <vegard.nossum@oracle.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065615.219183517@linuxfoundation.org>
 <dbf7ae11-e34a-42f0-a0b6-b95cf96a836b@oracle.com>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <dbf7ae11-e34a-42f0-a0b6-b95cf96a836b@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0187.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::12) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|CH3PR11MB733910:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a2b9e19-da6b-4034-727f-08df13e8d071
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|56012099006|5023799004|11063799006|10067099003|4143699003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: o5SoSzkqEzFeiG+WXN6BorkQwr45NDt69gXEUtHQdSuWOYDKT/mBLEdb6l3ll77bu+QbT5HfaBAXXPOW7jLleYn+FH5uGVsS0uM6D+wOo0clMF5ScLZrBaA493jqZ+fZeGuibZXk08EIpx7OluzoNVr3KrUR0+uLR40/pDkUk7zKy2xYY2vDysZBFhU3NLxghOaoxCgtXd8FlmuN6ixtIc2/Xcq0AiFdm6bQCBSJFlBq7mR1jwpCNO1ukkeQwP3q+zs8IwipBg9SQFV5uh3/skJtqvcdyHTqOG0tSnZD+WXvK3kgFbh7UGWdo2fg2DYqwQouJ0c926kHvy1wrCgilYXTvYSeRpOIfmGJmrlMh06As8bxG6RuJZs3FoFOOamkml7UlsQSaOnY9Q5nve5BESz0t1S1R7ZRDH4V9MBGx+k7m/1isHMDRoOT7XbG7CtQ3P4jNSArcNL5wuSvamXLfZ210uP40w5Gr0mk6xLpUoe54GEz3ODo4O/kLSKgsBgJfQ2+3OR7d2qdENZQy4YzyEw63MvBQwD7xS5GQYkES7pOsOjC7DuO3P+B0bEZ+4OM05cqtQYzeI8Fhuep6tB8u9MQrg8AmVFzWHscn8eFugjpo4rNPohSBItk5hzf+ynr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(56012099006)(5023799004)(11063799006)(10067099003)(4143699003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2ErOWh3NkR5KzJMbHgyTlUyOFpPRGNNMzJITGpRbHNpRjN1TmtVKzl6TkF2?=
 =?utf-8?B?MWFrM1hqemFsVkErL0N0SW1PUTI5YkVQWEt2MjFGSVhoVVpKQ3VZbDl2WWd5?=
 =?utf-8?B?djNQMmxqZW9QQVB0L2tiUkRmNGtBbnY2L2dwVWV2NEhZb2pZbjdWRW9Vb2U2?=
 =?utf-8?B?NUN4VE9xYzdweDNQU0ZFK2xneUtCUjVQVTFJam9pOC90d3YvekNGMFJ3RTNt?=
 =?utf-8?B?OXAxODkwcGZjbGVZcVp1aG9id2NIY3NWRXNBQkNpaXFuUldyUXdCci96YW9X?=
 =?utf-8?B?TkRrUUZaNWJ4Z3pSc0ZzSkg0ZnJmV25naWVxSkliZElOR0ZZQzhkMis0YkJl?=
 =?utf-8?B?ZlYwQ243NFhDMTdQd2VpRmdyZ1ljand2Tkc1Zm1vTm5MejdoM2k4WHNhVTlL?=
 =?utf-8?B?bGxBWW1iYmtQa1ZjQkNzU01tdytqYVdBVlZxZDMvbUNNREhxU2tOdVhEcm9C?=
 =?utf-8?B?ZGhpREUxcVFCcEJIWVpvOVFMOUlrTWJrUVFyU0ZkL2tpaFBvS29hU0tZcWRw?=
 =?utf-8?B?WGxnOHhINWRuSWdsb0VoOWt6SHMxeUtJamFmZCtxeE5vNFhiTmc0dkNnWmxn?=
 =?utf-8?B?R2xlOTRtN250dWIxR0V2Q0d0ZVlFbEdmWXpmTkNKbkI3cm03bmJTaXpLZUtV?=
 =?utf-8?B?YWwyTytXZ081dTBNMzdpekY1Q1FTZDRYUk1UNlZPM3JOMDAwbXFpTWluYy9H?=
 =?utf-8?B?czVIc0Q2UWhXQVExa084VXJ5UUp4dDZ4a2wwVzFGbjBsSWlsQVN4R29ac1pX?=
 =?utf-8?B?T3R0a0tRY0Nrb2ZLTjNOL2hZZzUwSlhub2F3a2FEZVQxZ1R2UDB6UVVtbWFV?=
 =?utf-8?B?MW5KSXROYU13ZGw5Y3gwQnN1Y3pzWGZnYkpCYlVNeG0vVjk1WHVCNW9BaHAx?=
 =?utf-8?B?bmRrOHgxQXdRRGFkNHdOUFdkazVmVHJERXBMM1I3REFRMG9qbFhjbUJ6dEIy?=
 =?utf-8?B?L3QwOS9kMmR6TVhtaG11cVJkZThnTTZMQlVoZW1qTzBoV3VjczIzbkR3VlNF?=
 =?utf-8?B?WWRzSUZWSGhVTWZFOWN2SGxoSThWQ1BISWdIdWFUNlhLTHozdloxUStFNGxz?=
 =?utf-8?B?QU5CMUVBVVdJblBRbnNhbnIzOTN2eEhyTVZmYkIzU0tzSUU1RUF1NFpZQTRl?=
 =?utf-8?B?c0lLNEJPME12THVBY01sL3FENHQzT2NGZmR1aUt2dUJTaXFqTjVSUkhqcHBk?=
 =?utf-8?B?dXRLc0R1cGU3RWtSSnM2ZGt0azdBVFAzdlhjcE5TMUp5OEE0bHlNOXM5L0hi?=
 =?utf-8?B?SzdpdHllZ0lHV2R0Z3pEeVduS01sVloyUEJadHVwV2lrdUIvcDBrSVBHUTJx?=
 =?utf-8?B?TzcyUWFLME51RWlZNUtCdlJsT2IzV2p3K1VsblFIaCs3VkxjVzBwTm4rUXpu?=
 =?utf-8?B?by9TSk5SWVhQa3NwaEt0d3pXdE4rRWpvT3RlNHhMdEw1eVU2SEhmV3MvUWc1?=
 =?utf-8?B?L3V1ZSt1OW14ODJxL1p2WnFxVStVOGxha28wUXJsU1dmWUN0SVptaTF0M1RZ?=
 =?utf-8?B?a2FVSEdHdkJGYlh4Q3NrSDcxWno3NHU1ajFRTC9LZzdmNnFQSytTNTNaNTRp?=
 =?utf-8?B?MlhBNlM4N2tlc3lSaGpEOXdyU2lzbEtKZmZ4M25oVDYrNjFnZ1MvR1pRUmdC?=
 =?utf-8?B?YkhSa3RGSmVkSk1Mck9rUm9veVRXVVFkaHl0OWlDVnFXcWhuQ0tpY2s1M0l4?=
 =?utf-8?B?WkJGNXFkK3B3YzYvMWg1V09ua1lHM0xvd2dRdUpid3FPUzdGVE1ITm9INTdT?=
 =?utf-8?B?Qm5pczFPZGZvY3lleHJSQSthNGxmL2JadFl6cHVReHp6MDk3cE9HVEQ4b2hV?=
 =?utf-8?B?UkRxdW1JWGtkT3JkRUpLMnJZekNNTlEwcS9HbG03aEZJeXovN3FidU52SkJC?=
 =?utf-8?B?SndzWEdvNk12a1RpK3h0ZkxzQnkzVHFkdVN4a1REeU90QXZCWkdWWHVHU3RF?=
 =?utf-8?B?bE9EWTZtSW9KeU9yNzRKUEVobzQ5elMwT3RhOGxIaE5pUmpwYi8wRGJMUHFZ?=
 =?utf-8?B?bWt3Q0xoVUFQT2ZmekYybnpndEFGeGNYZ3MwYVF5dEt6Rmk4SXJuZ0pPdU81?=
 =?utf-8?B?YW5xZ2pTaGVhNndnSkJnMWdXYzVNYWUzY2R6RnA5QlN5N0dtQTR1dHNnaEdY?=
 =?utf-8?B?aG9KRHVHOXJHeE45M3FEdlVZVk8xdHRBV0hhN0c5eEdicy8wbUZobHVOMkpj?=
 =?utf-8?B?OEw4VnVkVlNxVHBWVC9TUit2S2kzM0E3eTdOSGthc3FsQXpNZS9hdWlQNkcr?=
 =?utf-8?B?emJDNEhNRnlxamhMcURuZmYramoyTFRWQWgrVGs4TmRld3VEQzRaNDdoTkVZ?=
 =?utf-8?B?M3pJVHNNTmR1ZkpQYlF2aWhSeGc3RHJkY1BiN0pPcXMrK1dVRkFoZz09?=
X-Exchange-RoutingPolicyChecked: e9edru5Ce1Jv8Cgzia1A4Nh4OEF2clWMLbw8x+z0z6MCcO23xPYFnuAxb9o6BTPXy4EsabRKj+gWtvbM+ngVygtYigcVfExQXdR5M0fsTdAL0NvutzwgE5WYDx/0GwbkV0aE1B11Xme660RhrJ0UAYhGwZNDowcEgFdcASeXXZSwqhTF8TF2smbJWzTD7ejLgZJZiVP6T1LfaYLTrV+lkNMXrY5K9GXuVMjInpaXg3kEWAkTUza5+6SBu7kOuRfYaUosqqdxwFGlMlQZvPCu90AkNiLLcW9C5m81faq3KceookZq3toYtVbU8DFUBfWw9d6e0lk+aAKrV/V84sdTYA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a2b9e19-da6b-4034-727f-08df13e8d071
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 11:51:16.2214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hv1RA2FKgpD1etaDnApCH3Nlwn7emYlgWfw5G54OAqpM0VG3HZPq98vXiWUL+Fky4CFIWJmytfztOLRpTdJDYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB733910
X-OriginatorOrg: intel.com

Hi Harshit,

On 9/16/2026 3:07 PM, Harshit Mogalapalli wrote:
> Hi Greg/Sasha,
> 
> 
> On 12/09/26 12:16 pm, Greg Kroah-Hartman wrote:
>> 6.12-stable review patch.  If anyone has any objections, please let me 
>> know.
>>
>> ------------------
>>
>> From: Chen, Yu C <yu.c.chen@intel.com>
>>
>> [ Upstream commit 4f166adb5cb0525d9e32d45729fd8f28c80acbee ]
>>
>> A divide-by-zero crash is observed when running hackbench:
>>
>>     [14697.488452] CPU: 112 UID: 0 PID: 124791 Comm: hackbench Not 
>> tainted 7.1.0-rc2+
>>     [14697.492627] RIP: 0010:propagate_entity_load_avg+0x35f/0x3e0
>>     [14697.506799]  <TASK>
>>     [14697.507411]  __dequeue_task+0x2b4/0xc70
>>     [14697.508677]  dequeue_task_fair+0x36/0x370
>>     [14697.509047]  dequeue_task+0x101/0x2f0
>>     [14697.509426]  __schedule+0x1b1/0x1a00
>>     [14697.510868]  anon_pipe_read+0x3da/0x450
>>     [14697.511400]  vfs_read+0x361/0x390
>>     [14697.512053]  __x64_sys_read+0x19/0x30
>>
>> The divide-by-zero happens here:
>>
>>    if (scale_load_down(gcfs_rq->load.weight)) {
>>             load_sum = div_u64(gcfs_rq->avg.load_sum,
>>                                scale_load_down(gcfs_rq->load.weight));
>>    }
>>
>> gcfs_rq->load.weight is an insane large value and is truncated
>> to the lower 32 bits by div_u64, which happen to be 0.
>>
>> Using AI for investigation, the cause is a u32 overflow in
>> update_tg_cfs_runnable(), and flat pickup became a victim when using
>> tg_tasks():
>>
>>     u32 new_sum, divider;
>>     ...
>>     new_sum = se->avg.runnable_avg * divider; <-- boom
>>
>> The following sequence shows how this triggers the crash:
>>
>>     propagate_entity_load_avg()
>>       update_tg_cfs_runnable()     # u32 overflow corrupts runnable_sum
>>
>>     __update_load_avg_cfs_rq()
>>       ___update_load_avg()         # computes insane runnable_avg
>>     update_tg_load_avg()           # propagates to tg->runnable_avg
>>
>>     update_cfs_group()
>>       calc_concur_shares()
>>         tg_tasks()                 # long-to-int truncation, negative nr
>>       reweight_entity()            # corrupted se->load.weight
>>         update_load_add()          # corrupted cfs_rq->load.weight
>>
>>     propagate_entity_load_avg()
>>       update_tg_cfs_load()
>>         div_u64()                  # divide-by-zero
>>
>> Fix by widening new_sum from u32 to u64 (no need to force tg_tasks()
>> to return unsigned long after this fix)
>>
>> Fixes: 95246d1ec80b ("sched/pelt: Relax the sync of runnable_sum with 
>> runnable_avg")
>> Assisted-by: Claude:claude-opus-4.6
>> Signed-off-by: Chen Yu <yu.c.chen@intel.com>
>> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>> Link: https://patch.msgid.link/a22eea2b-4c4a-4623-9a44- 
>> d7b18c0c91c8@intel.com
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   kernel/sched/fair.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 5a09448e22c33..4be1df2b90df0 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -4416,7 +4416,8 @@ static inline void
>>   update_tg_cfs_runnable(struct cfs_rq *cfs_rq, struct sched_entity 
>> *se, struct cfs_rq *gcfs_rq)
>>   {
>>       long delta_sum, delta_avg = gcfs_rq->avg.runnable_avg - se- 
>> >avg.runnable_avg;
>> -    u32 new_sum, divider;
>> +    u64 new_sum;
>> +    u32 divider;
>>       /* Nothing to update */
>>       if (!delta_avg)
>> @@ -4430,7 +4431,7 @@ update_tg_cfs_runnable(struct cfs_rq *cfs_rq, 
>> struct sched_entity *se, struct cf
>>       /* Set new sched_entity's runnable */
>>       se->avg.runnable_avg = gcfs_rq->avg.runnable_avg;
>> -    new_sum = se->avg.runnable_avg * divider;
>> +    new_sum = (u64)se->avg.runnable_avg * divider;
> 
> 
> I ran an AI-assisted backport review, and I have verified the report. It
> looks valid to me.
> 
> The two posted hunks widen new_sum and the multiplication to u64. The
> 6.12 implementation then updates the parent runnable_sum through
> max_t(u32, ...), which explicitly recasts both operands to u32. The high
> bits fixed by this patch are therefore discarded during propagation to
> the parent cfs_rq.
> 
> Upstream code after 089d84203ad42:
> 
>      __update_sa(&cfs_rq->avg, runnable, delta_avg, delta_sum);
> 
> Downstream 6.12.y code:
> 
>      cfs_rq->avg.runnable_sum =
>              max_t(u32, cfs_rq->avg.runnable_sum,
>                    cfs_rq->avg.runnable_avg * PELT_MIN_DIVIDER);
> 
> The explicit downstream u32 conversion discards the widened high bits.
> 
> Upstream preserves the field type through __update_sa(), introduced by
> 089d84203ad42 . Maybe we need to be adding a minimal 6.12 adaptation 
> that clamps the parent runnable_sum as u64 before retaining this patch. 
> Thoughts?
> 

It seems that in 6.12 update_tg_cfs_load() also has the risk of cutting
u64 into u32, as load_sum is unbounded:
         cfs_rq->avg.load_sum = max_t(u32, cfs_rq->avg.load_sum,
                                           cfs_rq->avg.load_avg * 
PELT_MIN_DIVIDER);
either we could change the u32 into u64 for them, or maybe we can
backport 089d84203ad42?

thanks,
Chenyu


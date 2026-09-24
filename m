Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2A049DBB6
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 15:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790262782; cv=fail; b=KOJ9Ywc0KDQ05d6iajoVWtzKJBRSIE54RdeJ8tT8QPpyfqisieeKhQYRJ06xijI9JrHKIwD4aeq3u3fYQTX+mLAFIAzo82f4m8WQV9Wl5VdEB9+3oK0Uy6c9qdc0ncfWvW/inIUXZ5fL1J0qo5GpkrSOqHPyh+p/u63/UJIK8b8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790262782; c=relaxed/simple;
	bh=UKu2sZjwxa7Dn4k/vxttCR1qndlv0pIF7cgUOU4b58U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p4ioGnva4AQ/ExA4JKjWEvyb1G8TSEkQRv4nZQxZoXMG//sx9DMSThB2dtqUwq+keLqBx/uXYAuWz4ASAU7tZZ1xYbOYN2WCoTX+hOM3N+HB9D+Nw0aHEcLs4Z5DAxAi7R6/u2cPnf84uvgUFy03+87kG95fPleK0VtQ2QjzCJU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jycFj68+; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jycFj68+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790262779; x=1821798779;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UKu2sZjwxa7Dn4k/vxttCR1qndlv0pIF7cgUOU4b58U=;
  b=jycFj68+9zGDQUQT7khpdSOngZwrwJ+PGM3SWkTdhvW3NZLR/hfY+3FA
   KgL/s8GQchX4JkL8W0j8cxqeE0QmFZlPj4zGcUs+0j76fZ5qJZ1VTGzTo
   rPsrAfp8wFL70rUt16TMl1MiTnlHQ9OuIYCHb43APSJlNavUaA/mDi7D8
   TZRyw+3+n42Z0e3tJJZx/yw2gFLOU8ghpD6gk/r4zo+bBIr83bLy/GGuT
   BfAK7e6Zi2wTz/O/282aiqhr1RzqkHcM9yXBuL7W1a1jZ3GxDp+Gjy40W
   BVGEE1KzY4cGOzEUETrzY4By4iyMATrnIBqnohH2AAmjIOjLigo5lmw0d
   Q==;
X-CSE-ConnectionGUID: xf9h8GyrQN6u1ibtkA7UFw==
X-CSE-MsgGUID: jpaSFVmtQP2lvDMuXhRHFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="116562524"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="116562524"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:12:58 -0700
X-CSE-ConnectionGUID: w2ZqWxBPR0+YS1F+H8hs0w==
X-CSE-MsgGUID: t9fqQ+nxSeGn+HsTfbTSFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="271882475"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:12:58 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:12:57 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 08:12:57 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.16) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:12:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tYmxWIo532HBAFdPKXUqByv18b6ieYfJ5XeH+sFINkmQHWlVMMCHmmXz99pcbwP20TFMlKws4bvafQ5pDmCCNBTivW+B4iDYYld73BZupW/33p/iX9/ao02Z1EFG0V4ksce1Ou8crFt09b6GBZ6W/VGYNhn/uYK8ammIQi+ObnLLnGRj8dUTT4bwNsDXIqtiEuuAwyA9qlGsZTCpCBGvZwdT5SqlvaKzFxunLXZ7EupH5dnfy+CjMgRpDkFGcMVWSdw9wbfrjwjYZqL6IFF7vqBrpNa47T85kMRdThszNkhMrtCyxdOzmHiyWL/LjrVvTVnU3aQKkowyapo9oOiqLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oVhYXgpOIO7ogCPJ0VwLg0HXWjbCQ5HP3QsZCb1XO5g=;
 b=peZzKVI6Bpy51yGoHdNOJufOjXJX0OzmBEM3Am6mngVZwplzINjJDXbpDWTifmaqqZDuQTwIcTM3Jm6JrocMDLNq0el7zWvxJDI7gqfuSKVQiMOGurNts1plFFZDSAun7HIIu4eEtWVZg+IGLjJYwYyXtvEk8izi+SdUohGi4yJ33uSZBBU+TeNNk8CoIXy5TXLAEcDhHCYkEuCizm6qFYiTzEnpjhCTM4vayMS3JG3L6zMO1bcYfJNoD9M0O/W7iFlXVxHPMUVLG+V/rtZtJ2kTRJgik3wp2axEJq1nqXvx1b3EBOvT+gcWtolKEHgTo586GLsAzttMEiMK2V1qxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA3PR11MB891970.namprd11.prod.outlook.com (2603:10b6:806:531::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 15:12:54 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 15:12:54 +0000
Message-ID: <5afafcff-604f-42ea-b002-4030783f8865@intel.com>
Date: Thu, 24 Sep 2026 08:12:52 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 01/25] x86/cpufeatures: Add missing CQM feature
 dependency
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-2-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260916231320.14502-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0002.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::7) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA3PR11MB891970:EE_
X-MS-Office365-Filtering-Correlation-Id: 928f0033-a867-4cdb-b9a1-08df1a4e4ed9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|23010399003|10067099003|11063799006|56012099006|4143699003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info: wukm0nPSMVfdbZqEiFmljWL2YPx7HY2FVetly2BImbiSAmVq1K22m3RZuWpvdXrFWg5j3YHBITm5EJV7GcjadKBu+Fg5fTDX8Hj6SaMMGc6uh5N4C7FRwywQFkyTjvIwqsDoh9jXOohGGMWMWYRHF0HyUyr545BloIBamfu6EGGuhDQS8bP/4IA2rDno3dal+Cg/eOnTBvddPGe+KK7p7itnylH0uz+vYojcoSNmdeCAIcsIicQFCzCkey+42EK2psex3ddWWUHq1kJpX984JTlRITZDff6UYCFGmJRoee2stYfQlOEXjKM6ON9YeOkazcJn7Gp9FoD5BOuIGPQ4BMSGd2Z41ShD8SfTSIYO2vkcd4aMxLPjgujJLLlu5FjzkggfJlD7yz4uFV7IdK8H2EhEWaaRuHNRKV7/aKB5qkQ/FU6+7AmgPZmlO7NEaWF9utXBEHo2wmGfj3E1nA8dffyyRX5ymZnq2uwPxLEjIg1Er9akwPzJHtoN1sw14VlAKZWp56JJs5Ed5d+dwHnb14KoxBN7XafE4OAZWIpEAkmkv+SUBwOrKjz2lEXGKncm8xiUXwsAoxW7BIFoM7cPvDWCCUSPLnI3Hp8d4vQdDObY8+Z/DGpzGKR2kuvRI/Sk/7QBUC6GFazZHCzAhbpURm8RjHOl3qf8vMss5Z6G9npjnW+Bx6/t5GMtNtevNSKjdEvd1NFBLot1QTtcYYo7Vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(23010399003)(10067099003)(11063799006)(56012099006)(4143699003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2lwNkxQdnBHbmcvY05aajJSbTgwRDZIRmZlaTI5UDdtbnZUU3pETHhWcXR0?=
 =?utf-8?B?dlQ0bXIzdFhNMVdPeE04UkJXYVdtTmtRSCtDOTVPZk5jOHpUOUd3MERMSVFZ?=
 =?utf-8?B?L3ZzNW4vNklscmk0NVJJRGp0TkFrSFYrZDd0UDZ1bzVVWG5Cam1iNlhEbnQ3?=
 =?utf-8?B?WTl3d1YvZkxTbEtCMlZ2MjNrcWppUW5QSEJMQXdhdHFCVFJuMjFEeVJJazR4?=
 =?utf-8?B?UXZaNTF6LzNlaTNSKzEyM2xXemtsTGYveG5sVVBEUEprWlNYOEh2Rm5yem9C?=
 =?utf-8?B?VTAyRmNOdXluU3Y4N0VHa1VsYkl1SWNyUWZ2eE9LNktzL3NsL25vc0lKWXpT?=
 =?utf-8?B?Q2Y1U2FoOG1vZExmcE1nb2hSSmJFQ0dnK0dQNGs2WHltN2h1dERNcjNWSTFD?=
 =?utf-8?B?U2cyakt2cmlZQ0pjMmlDT0FFM1B1UW5IbXJqY242dWVpZFAxZGw0NXlZM0hP?=
 =?utf-8?B?U0gwSWV0aEtLZVdRZkxzS1o4NGV4VTZqL0pzRmZ0Mks1TFVCK3dLZWU2TEty?=
 =?utf-8?B?M28rc3NlbjlVb0JBT0t5NzVpN2RRY1M3bGJlaFpPaUFMMVRrb21aRjdIcktz?=
 =?utf-8?B?ODVac2JUYnVidkdhdE1FOXlvZldRTytTRnkxMEdsTXliZFdEbG9KNUI4ZmtN?=
 =?utf-8?B?SHlERXBoOWlTT0VCVFBiSGtWVnQ1V0VKaFV2T2c0YURydVozcXA1RmpVNWhv?=
 =?utf-8?B?QTJKRE9zQjN4eWtYWFZuS0pBM2dNSjdUN0ZxelhRc0VSMWEydHg1ZWtmLzcz?=
 =?utf-8?B?MzZXMWZNSnhLeTRmUlhxUS9Wem8vMFNRT3NDa3RkUjdHdE5NS2I2d3FLZ2p6?=
 =?utf-8?B?N3JyQm9tWS9FaWwvR1lPeFA3THNTU21MWHluKy9JUmxPZDVuK1BmenFhcHZ6?=
 =?utf-8?B?UjlUQXNWd0J5b1lYR1R5QjZpblQrL3M5ZHl4Nk9NRmlFTnlaZmZvSnBHd0lN?=
 =?utf-8?B?czZFMXhWblRkaVNUQ2IvMnZZLzNaNTdDUlc0OXBpM015RXhGYzZPMkxjQVlw?=
 =?utf-8?B?ejFIc3lxbXZyV3R2RHlKbjFWSFR2akRoQmk5WjRkbFZIek1pZjBRYkxLdVdN?=
 =?utf-8?B?dXFQK3h0V0lSSGZvNTFWSElzRUpzeW9wWmUyK252NFNka05kZ3d4QitiODVp?=
 =?utf-8?B?bThIZFU1UDltQVV5Sm9RbTlZL1BNTXBJZ0lYKzNGS1FUa2NjTWVJckdpK0wx?=
 =?utf-8?B?UHJtSDBXaEtrT1JJdStiMmJXVFVEV2lPK2Q3TUNFekIrNGdibkVvMzBOKzIx?=
 =?utf-8?B?TVdCV1VhSURYRGFLR2l3ZHlrQkFjUnlZWHduZk5pK3ZJVjVRaytIcDNSQ1J2?=
 =?utf-8?B?bFJYMTVDZGZhZXh6dHhxQStGWEtWNmJxV3EyODQ0SlAzSURGV0tDWHZNY3R6?=
 =?utf-8?B?QUFmSEhwR29DbVhKaUhWNXNPSFUvaTZPTE5aekxrZ1B1d2NVdHczSnM1UkQ2?=
 =?utf-8?B?OTIwUWxZb0F6U1RCZTFkM0t6dzlaN0RrbHBhY2Q5WkZrMHB2RDJjMExVbVdp?=
 =?utf-8?B?U3lYSWxCZG11RkhLd3VKaE5ud2ptZG0yWW8rZGhpQ3B0VnRVckZJdWI1U3JM?=
 =?utf-8?B?Z1VYK1BrTTE0SzY4OUdxY21pczRMTS9JWnlTcmpud001ajAvcUZyNVFiSk10?=
 =?utf-8?B?aXNoMm1CTDE0M1dKc3dqbEdHUE9OTzVRcDVTZXA2U2RpaVRVQ204bzZiL0l5?=
 =?utf-8?B?UTVtbzY5d3UyZ3VoQytqUGZoVlhaN3lleUp2QnlWSkdKWEUyb2t4N1N2blh0?=
 =?utf-8?B?ZVpVRk5jQjEvVHR6OEtFMHRQbklZaEd1NTRuaHFJL2xvdjJZTVpwUHQyT3ky?=
 =?utf-8?B?ZUZrMlIyMGlLUFFRa0wzVEIvWWg1RzNHMklwRmYwOEVMb2xGOW1UUzYzNUlH?=
 =?utf-8?B?Nmdaclhpa1dIbFRtVm9IbXFtaVM4M0hFSy9zN0VHRitHWlQwSml3UFhNb05S?=
 =?utf-8?B?b3lKV2ZKemE3K0h5bDh1MlF2aXpSOHlQRnFrYnZyME5wS3BIa1hCblJxK2pv?=
 =?utf-8?B?TjdsaGZTYmFFSldwbWQyTTJqM0ZSdUY4WVpIQldlcDVyL0R5eDFXVll0K29S?=
 =?utf-8?B?Qk15YnQ2RVdWdTFVdXY1RGdrTE51NVdmMy9lTTMvS1JGN3VtZWNxTndFY0xs?=
 =?utf-8?B?NkhCQndFK0EwZGp5VVdpbk5sc1VtZy9PUkp5V1dLY1ZXa3BIL3dqNTZ4TzBD?=
 =?utf-8?B?RFd5VVFkQzhkaHMrZmpvUXJ6bE41OGpRQ0VMWlpJVE9NTHh3aUE5cXE3cm5J?=
 =?utf-8?B?T0ZuWHFrQVlXQUhBeUdBUGUzYjgrV2hiSFlsNmhNZlFnV044b0JWM1U5eVU4?=
 =?utf-8?B?QVpMY2xPQmxZTXA3Z1B5bFVPTWNTaE1JeEN0VllLRHg4MVYvbDBMcXZoWXpI?=
 =?utf-8?Q?r00gNPqCCZbpQRn0=3D?=
X-Exchange-RoutingPolicyChecked: GxwPbNJSnfli2/VIXl7sXQ9STCuXtN6VTApemuRgNhZuuGWgmQZ7Ni7klTrSJBgoO6Ypn9jOOEL/DakeMSJdTUXX0O7oREldymjbKMiRsF1n0u07oJmMzQIq7DDnJwRFVwNWUEXOVmdDovwR85UTAai5WwvOBMwThcTgv/kSCO0jsa7xduOa1NPNqGHg3s+d1gtYRSNhZnYWM66Y1SIDwegeBc3DiRa476IVLyQ+/Qxsza153/PDndrEI2ZUfqM0ZXRXCfpVJpmZDOJre5U6hYgTe2rEYCklwqJqAsZ9BDmOhyB9gY3SQupfglc6pDhdRkWzn0DnpXob0+ZBG22bOw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 928f0033-a867-4cdb-b9a1-08df1a4e4ed9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 15:12:54.4335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pDLhTugSK4qDn/BEtfQjwQ5jN7D2Iaf+YAQN3nqXoo+MeRrZnhjghIuiQupV67pciGdeT1j9TFtRLJLnU54h0pIsSoyv/i0oeR+Ht5x3KkU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB891970
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 4:12 PM, Tony Luck wrote:
> The Intel Software Developer's Manual says that software must check that
> CPUID(0x7,0x0).EBX[12] (Linux X86_FEATURE_CQM) is set before checking
> for monitoring features in CPUID leaf 0xF.
> 
> Add the missing dependency of X86_FEATURE_CQM_LLC on X86_FEATURE_CQM.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDB4261B70
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 01:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787014809; cv=fail; b=dhWEAbYtFeFkFEMtHz79TN7JzZvOGj7T0Cz6R6pJ5H3zUfV25vq7fOU+ME0jwaxylDAa8wPt8Wt+4IbcmmH2/cqsbYJXh9JKKteZpLAm1oHldUzRi/gV3/13HlXoPziwJInN/iRfhdyn9claGnb2IA+aGXiHr3qRCgrH7s4NQ3o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787014809; c=relaxed/simple;
	bh=nJzIx/NPANVuM3xiJfOPwSmQ4ZULcdlBQq536aqwkXA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YuFZBOqWWWmUtj8Aq4SmTjVOBd0tWlIrCARNuMJMaKzcajgrBefjVgByLGi3CndE/TRQRkYrx5O4ufOrKFRqsBIiSWDIY6bpkH3aYudy3QsELxbkEepPuLxD5PW9EohQ+80kLXuNYmuQoyVipmgvc6lJ+JEIpT8/99a+ML8DCQs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MoOtvzIu; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MoOtvzIu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787014807; x=1818550807;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nJzIx/NPANVuM3xiJfOPwSmQ4ZULcdlBQq536aqwkXA=;
  b=MoOtvzIuuLryDJdEaeZLN37kcYnv+2jbJN977Ta14ipEN+PJOQu07+Yz
   H4f/OlhEAzdkrc5PQ/8wmah0j8Epp3BdiVg8ODdbMjOPvjUjrzLoCpds7
   t9k6nPRo1kskqhyDQ9tMJMyr8FOU6+Cr4Vkq565qbUX9jJjoLGGWe1MUa
   QJud915HqEkpaCFQ4u3sC1G2UfUcF5tJ8Qfa5iuQbKvnkK+Fk0qYS0cgP
   g5dInAs7369vynq5I8nvFTmqi3MEt1/szl0RXQO6hi7tKdrsABem73nBO
   y6fUaqmp62ppzwrNhyZ1N4mtZjirI3GPBGyNQVEbAgkvbZIG/yopXZhni
   g==;
X-CSE-ConnectionGUID: ucfqY1Z4SCSE+tz/IRvZkw==
X-CSE-MsgGUID: /x9wuPNPRQ6eLwY3JtMKnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="98650006"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="98650006"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 18:00:06 -0700
X-CSE-ConnectionGUID: i4oUs7u7RkKLD/D8haBPsQ==
X-CSE-MsgGUID: QDcSs0eQSFm6abs0pwK7OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="261329900"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 18:00:05 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 18:00:05 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 17 Aug 2026 18:00:05 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.19)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 18:00:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZHY8b2ub8kHaFvrINAdGjclyX/Bj0FQmt7k5CcGUFd9ejZ1QrpG6YuCEuQLk4LJKoJ4IvspbP4GTKv0wrCrqoJ5W/QFMkdf9zwmw5B14ADriurU5F3azocrrC4RFSOm7JQAprREGpl/Mb86Y6bDwW8u7yi21aa2/3TftH0oFCBCMPKERhGpNrUznkRVLe4HeZ9pEqo2ji1MqC7SJqVmKE+yKafgqVKimSmvP+nwGE4uwGV84Gmuhtw7tUBMofvwNfahycOoQjUWppbCbcc8MGE1ya2JywNNnjTWXVZ6torZhoAm7W77K7fSmFbqYKbixh4iGfhIhZnVWjKLK1GiuaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=36pYfwRoJFkO4eSXpV8glsTEk+WkiR60PsyUX8epf/s=;
 b=r6wssu4J8IWSK9fCXwT9WAVBpc+uCCn1JV+pJmXS0KDm12C+VOITuShjORjSnTVHvYLxJabzWbpmiQpIMW+I7a1dhl4Wjaq8c+jZuCqiGftanynh8ZWl/wIROO5WtijTj2OqAaMHQ2XbcCoWWyPSVksu+yPON4oOE16NIAr6/JYw52U7XBVhcpmPV+9UZ278L8FdpkYS9irG4ZmwZDdQNJ/wU9KLB9U+bZqw080dRCIR8V1sYkTu9SrdjAPziVXPEom9gbLU0llbHPp1YdAloTdCOlEy5AQ9JUf0vQaVc3iwVJf9MlKFOifEmsyMtu0KrzSXATKlwmhLQqq3OrMTlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SJ2PR11MB8345.namprd11.prod.outlook.com (2603:10b6:a03:53c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 00:59:56 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 00:59:56 +0000
Message-ID: <2acc3e45-f9d8-4ae4-92bc-b803fda1013c@intel.com>
Date: Mon, 17 Aug 2026 17:59:53 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 11/17] arm,x86/resctrl: Resolve INTEL_PMT_TELEMETRY
 symbols at runtime
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-12-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260729172752.11561-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0117.namprd04.prod.outlook.com
 (2603:10b6:303:83::32) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SJ2PR11MB8345:EE_
X-MS-Office365-Filtering-Correlation-Id: 823e63d5-1be9-47d0-09fb-08defcc404e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|22082099003|18002099003|56012099006|6133799003|5023799004|4143699003|11063799006|10067099003|921020;
X-Microsoft-Antispam-Message-Info: /LHXmd0QtJvLOdkItpnVUVttHHzDxGGUh8bc2TBIOIEds+Mln8v/c/J8w5jshJkQ0MDQCxNtJU5ZJwG685oMSiPPIPhMgrR2z5l0pq/ySmwAgZVnunV4NVpnrzAQUnB9BPCDQM0f74ErOfe1B+5dEIOM5srV7JgfjZz2bKp0gxlzgNilVCiesZv/1oP6yxXSKZxFNwVCOmrW7oh3E9oegpgrX6+EJ9Gih8F9/3PYzMPZTDKqq7CUS0Xkw52s38emPikOBf7bw9HNfzYF8vrWRolKXc54mx8siAAvyK0DFkWfqZeWSE8ZCfEN3mK9JgvFhOkVPE+hLTQdkFJecAnCvA4DX88zd6I1TUEqT8YllxbTdMeNg3qDYCC3xJd8n/5mPZfR5Di/DUbyxo2jf+DFxBqeuU8EHY0POdHPAAVOydaokZ85FMK8sgtejZcewQydNHqIFdl1o3xwdY8SL9aADzczGarnKUxXO56aLGCuSA7DgMA9W1IvgkVS4Cza9GeJZmn1Z4meIcbfgQCLb3FirHA2sLmdZHmjvZJJsNB64k3fLdqX8l47daE+4bR8R1h6WkZ+m2G73K8TXX0WsyT94U9iyn+u0kM7/SrbPj0ELpC0jsf7lr4Ynff3P2l+btTk/Gzi07wdOWTuvYgkYI+68TIdCiiLN6CcQV3ZeCBE0wKQY3w1J+d7qhTJg8tPjNsg7qPyvmDzbSJ56pFvvSHq7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(22082099003)(18002099003)(56012099006)(6133799003)(5023799004)(4143699003)(11063799006)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enlzK1Y0d2dyZmhwQ0c4YzJCbHl1c3krRS9KcE1VaC9OdndMUXJDVllYWTU5?=
 =?utf-8?B?VGFZaDJWcEJNRUhYZlV2QVFmcjNJdmpxL3VKaFZjcmNOUjRBWFp4QW9hTkFD?=
 =?utf-8?B?cnNDbFBJQXF4Z3BUbTl0RjV5Si9sQWl1Mk90bTFzTDdLTzFTc0I4RmgycnB6?=
 =?utf-8?B?dDRDQWhndWY3cVJjUERyTW9iT3dGMVBXcWpqTldMK0M2NmUvR0R3TXV3Y1gz?=
 =?utf-8?B?QS80c1VBakYxaFlNU3BnY0QrTTlDRE5LMWVQejkxVmZDblFKRWVUMU1ONWRt?=
 =?utf-8?B?SHl0bkN2azlVWWZDN0dOanViQ2Z0MlFRZ1kwSE5GTDB2V05sbDJPOW1UcGtM?=
 =?utf-8?B?d0VSZFluVzdHZkdTL0EwaTFJSWYyK2RWTWlTaFZoUm53UWVFR21PMnlsNWl6?=
 =?utf-8?B?OEZkT1FSRGNIakNyYjlGdXhlc3dZVHVYeDZPNUY5UDZWRVFnQmpaeHVjcVkx?=
 =?utf-8?B?Ym1QTEFBUFREM2FjTGdXNXBCa0dDTHBSdmIyQ3BxWThFOTlSM1JwVk5MMXlW?=
 =?utf-8?B?SHN6YkN4Q25PNlhNbXlzNUV6MDdNajRuT3RYN2Q5R0dpaXMwMzc2Vjh5Rkla?=
 =?utf-8?B?TWppeFFkNU5QMTloejRTbWlEa3pINWNXLzZROEFYSms3RDQxMzNrbnc1SGp1?=
 =?utf-8?B?ZDRSSkplOXhaZHE1elhHeEdKZkFvVEFKa2RUbmtpenpBdnp6dUxOblUrQ2N2?=
 =?utf-8?B?Yy9takFEUlRGbWtPZmU4cUlvVE5kU3JnQ3lhSi8vQ3pJNUQzVDRIR1B4MStF?=
 =?utf-8?B?cHVldEt5SytxRFpaQVNvWjlhRUtiWEkwUFBlMk9INEM2V0N1Z1BWR09CSS9Z?=
 =?utf-8?B?a25FcFgwdEVueHNIM1dlMVc5ZEsyVG9NZ1BtclB0SWlremdXSjFwRFljRTYr?=
 =?utf-8?B?VnFGcmpybDFrRGljRzlOT3lyd1c2RnFrSzNPUDFWc1B3RTZsTFFCSVNqMGF4?=
 =?utf-8?B?NXNiRG9sUkVqeS82dXE0aFUzZlBveDkxck9MR1Z4YjkrR3pDT3RSbm5yaXcz?=
 =?utf-8?B?TDFqYVE5a2loWFlSc0lVb2dNQ3BkazZtMXNvdE5neThJdURZWVV3V1ZERHNE?=
 =?utf-8?B?YlVtNnhZV09MUHI0Y1lyeU92cEc4eXVGcUlkYUpkclBHRWtyajRZOHhybGh6?=
 =?utf-8?B?NjNCZjR5TUd1dnRzUDV2TnZCelA4RjRUMWZwZWNZRnkzQ2NkcHN0NlR4cVAz?=
 =?utf-8?B?b3pkWTJ0M0pKTG0zNWpoZEQrOVAzTXFGeStIUm4rNnRSdG51bDYvbDVoUjJZ?=
 =?utf-8?B?bk11Z0U1cmx0dGNpWXpEVFk0WkVlcG03VXpUVURtaVMzQ1kzNS9RNWNLNldh?=
 =?utf-8?B?cDFONlBGRlk2S29SZG1kazk3TSsyRDZXTEdmVTJJQ2Y1M0EwRlNjWmFva0RL?=
 =?utf-8?B?NmdVbm1UdzdSb2ViOHUyVGFaNi95WTd5RXN6d1ZIRFp1Vk5JQ3dpK3pSaXo0?=
 =?utf-8?B?TjVDWTBmWThMamxTalcxQ3o1MEc0VU9aKzdrZkVNc2R1NURrVkxFNisxRTBP?=
 =?utf-8?B?OW41Ly9OaGppaXJRQU1rYVR2QXhxQVdpamYrdTJGMElBeGpJRlQzb0JEOFo5?=
 =?utf-8?B?MkwvSjNBSzEzOXczVTFlT2g2eG1LejF6WDFxYitaRVpGWUJHa1ZudklOdkFy?=
 =?utf-8?B?OVhBK2RnMlRyWWdPbkxDZkN6aGN3c21MS0EvY25MWFNORUZxMlo1Z2kwRGk3?=
 =?utf-8?B?QlJSYmRUaU4weitCQzZjTEN0UXlWZ0l6ZXRNbXZMdWh6VGxjQUtIY3VsL0Qw?=
 =?utf-8?B?a3JNaTlzZnVjcSt1eklVa0VkcnhLWi9UZWxIWFhKMk9qY2s0dUJhNEZqYXJX?=
 =?utf-8?B?bXJhdzBZYTZCeWplVjdEbTBoRVRicU1NQmtKWVVYY0tqRGZTWkZpbTJLeWFT?=
 =?utf-8?B?UWZVVC9UVU11OXYyd0dXNlAzY0ZNcVZsRVFBc2ZjcERONzNLSkxtTFVuVWYy?=
 =?utf-8?B?MVdLeSt2MHlib0pJOFFpV0Y5bW02T3l1d1gvUUlFRHdQeE15ejdYZnRnOW9Z?=
 =?utf-8?B?bW82aTJsRzU2ZmdLUHBmZzI4ZFRURmoxSUNPOFAxMVB0QnFUdXlBeEZUQUVG?=
 =?utf-8?B?b1JPNmR2UkNlSU8wV2NzWUNRZHpFV25SN0NoMU02M3I1ck52cGZKT3J2U2hY?=
 =?utf-8?B?M2hqOXVFb003bitVa1Q1S3JVUkhCTnZpZjdLWGFkenRzT0VwTDdRdDh6Zk55?=
 =?utf-8?B?RzBqQmxVd3grSmRmNWVNY1pTYk9aUTdjcXJCcThpaUs1T20xSmJHeG9qK2Rs?=
 =?utf-8?B?ZERFaVZZU1l4bmZvdkR3NkMxVlV2YWpFSVFFMEdNa3oxOUkvcXczTFltblMw?=
 =?utf-8?B?L2hHNWhzUEhiWTgvRWJOWDJuMHB3ck9hYTlyRGZwckRBVUNuZ09yYWlENnc0?=
 =?utf-8?Q?OO29rSpgx4bNUaks=3D?=
X-Exchange-RoutingPolicyChecked: AiCMe4ka5AAP1M5r6pN7oq2tmV/cr86xBLJ47b64F1jqdb3bMB6KPlbtd+oYZZPQpIHxgs/aXlUmsaY3Wrw4e9/NJelaE61NUsrxkCrU6ee/uvJ27qPhamJJSvK072udtIsmg1gSRDdiCruiozkWhhrkRIlgfGm9NShF48KCVjpZKhTckZWX9feyuvUL0HZB+V6tNabTFrWdujNawqX6NEheBvj4jh1yKbGBLiXQzugGAdnSF4kDB2jheHT+osat2vKFTS0NwMUX+GVa2NLc31q2OrWWvR6NOT3g0pHbnkO6OxOy17qAK6clWjH2fZ7nYVmWwlcSd9qzoAE3FxjR4A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 823e63d5-1be9-47d0-09fb-08defcc404e1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 00:59:56.0656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U3rjCMvyCxZzEmDonJfX8OwSCW6mLQCtQhOHbV4yPrgAITuTWTkTJHVQaL5ECFXddPZ5fB9eWVddlr2Xa5gMS/2JE5/eQ7rirTvSD+wYaZ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8345
X-OriginatorOrg: intel.com

Hi Tony,

On 7/29/26 10:27 AM, Tony Luck wrote:
> resctrl is always built-in, but INTEL_PMT_TELEMETRY and INTEL_TPMI are
> logically independent and should be loadable modules.  Switch AET to use the
> function-pointer registration API instead of direct link-time references to
> PMT symbols.
> 
> Prepare for the file system to call resctrl_arch_pre_mount() on every mount
> by moving AET enumeration into resctrl_arch_pre_mount() and cleanup into
> resctrl_arch_unmount(). This allows the PMT module to be unloaded whenever
> the filesystem is not mounted.
> 
> intel_aet_exit() was never called because resctrl is built into the kernel. All
> cleanup is now handled in the unmount path. Remove intel_aet_exit().
> 
> Note that the Linux file system code does not serialize calls to
> fs_context_operations::get_tree(), so there may be arbitrarily many parallel
> calls if users invoke mount(2) multiple times.
> 
> Zero rdt_resource::resctrl_mon::num_rmid for RDT_RESOURCE_PERF_PKG so
> that it will be re-computed next mount.
> 
> event_group::num_rmid may be reset (reduced) during enumeration. This is
> not worth resetting on unmount because the same reduction would occur on
> each subsequent mount.

I think it will be helpful to reviewers (including sashiko) to add description why
the unbalanced module reference counting is safe here.

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 2c938b97b147..e335a143f3e5 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -16,10 +16,12 @@
>  
>  #define pr_fmt(fmt)	"resctrl: " fmt
>  
> +#include <linux/cleanup.h>

Following patch removing this could just be squashed here?

>  #include <linux/cpu.h>
>  #include <linux/slab.h>
>  #include <linux/err.h>
>  #include <linux/cpuhotplug.h>
> +#include <linux/mutex.h>
>  
>  #include <asm/cpu_device_id.h>
>  #include <asm/cpuid/api.h>

...

> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 407c9aba5eea..65b70cc8d0a5 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c

...

> @@ -340,10 +342,22 @@ void __init intel_aet_init(void)
>  		(*peg)->num_rmid = min(max_rmid, (*peg)->num_rmid);
>  }
>  
> +/*
> + * Defend against races between module load/unload of the pmt_telemetry
> + * module and mount/unmount of the resctrl file system.

Please add to this comment what data is protected by this mutex.

> + */
> +static DEFINE_MUTEX(aet_register_lock);
> +
> +/*
> + * Track whether pmt_telemetry enumeration succeeded during mount for use during unmount.
> + */
> +static bool pmt_in_use;
Reinette


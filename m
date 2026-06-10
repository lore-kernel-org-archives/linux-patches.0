Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0025932D43C
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 17:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781114321; cv=fail; b=dJ0RVjezewND4xB0O1FiYThuYnzTHPf86Llf9wdzqTSoNVOEvMOBRpDZ49atQjGp5+wu3qc7oqY4Q0jdnYaFOJbRLrJE81l3C+6DlU91nqDIR9dQzxgZj7CkWgOAc8DksG7d2PKfFeu6wpH85/LezDmI2uB+g4YdqlvjAm26Rzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781114321; c=relaxed/simple;
	bh=d9FHpDB+HmWnAsh6lhsbop83oVRdY6YTWJaOfl39/OQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iJZ7eUN+/ENfjuumT0/j+17JNhZsREkmwjacvsQLI62gEuPR6ZSu5EHZL57OVEeWTjx8Ku7r+qZQYTCqUzJwMmgVjlEi58+ykrRWDOeK2ij/C0AExKiVIIqBxciGJgOmDEiNm2QSxjDAoi6isT2e7T5yjLvuwCbCTMCqLgB4yBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f8C1Q8xR; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f8C1Q8xR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781114320; x=1812650320;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d9FHpDB+HmWnAsh6lhsbop83oVRdY6YTWJaOfl39/OQ=;
  b=f8C1Q8xR89bByi66aSotnCLtJq591J8Bl5QUjFErdJBXdkR+YrpZATfV
   04lFTDdcAMncdYh2K2l05QEpZAnXP3+hiPYwQP0wBKLohBCO6byVbcQXi
   va7FqKLrLGbPxPh0qJjxJ5eHLo35YTCj6rBGRaZyVk9l0AK5KJefKuHcb
   jTMA6DaXwsuEMRgDq0LdZlJbD5mY5L4tRI0mj2ZqUy3z7lV0lgsVou1Zk
   3R5+917CkqpictblBwyGbwrWiKA6cugp6Kw8IfJdN0IUAUJ1Lr1+iZ6Lm
   90thw4WWGUJEOdZk+QPjBMrFqQenZKZjj7N172kvC0HS5LRa4vDPm9CBa
   g==;
X-CSE-ConnectionGUID: PZhLbamuQ9Cw+VyZlKfexQ==
X-CSE-MsgGUID: 1xckoLMaTMaitBQlZagTNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="81918318"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="81918318"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 10:58:39 -0700
X-CSE-ConnectionGUID: qqkNjLb0Tn+/H4H4UU8oPA==
X-CSE-MsgGUID: Y9F+vwtNRPydg/4LLlnbkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="246101033"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 10:58:35 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 10:58:34 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 10 Jun 2026 10:58:34 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.49) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 10:58:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BLVFDr0HIDDKl19yrshaTLyDeyZFUNw6UhnAZTBFo/KgFrROqPzKNpKxz9xX7y096nGSC9WDjimqxhvfDXUJIZ2oJQ5vBLWY6dk0kemkTaEpIZiMCPuyRPXpljjUVrh1+fCW/PXZXo+wQkVkUepd0LQsh+2ykqQNFtyNQ/TtQ8hwOWua0ezZGZPcCgChHd1nOH1ICNKaYRu1e1k3FNqgg2GAmpIqNULhnnJNseYZw9SczW74/hV3jjSkxOH/Wy9hpnqhH+TB7nFUkl7qoWc1StD9MbUOePGg7IhsPfzSDVl29CbVF5Y3SRlgH6AoV+FdyfnXMM/b5ZJfalyjjN+Pjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/sgJQxf09niv3C/TEj9m493rb3jzmQFQzSiljPjBfO8=;
 b=OA6bjZ8eEP2Q26GpBH3FW2MhNko0B9P9haOBxSY37T3GzFzWGhAtTjzdCExvELYW300KrkW9K3yRX4pUlvPa6ti/BFexuRInWnyU4aGK2eP0T6iI9aOrumzIHBuay++qta5dda3ohsZ8dWrxHHMzLuGwoGVdNKe5pJQAfapTLr5uz0+qeZNuBWjD7Liw4qr7Jx/iWiwOTgTKvgzCkiNqw11Y1hzq/MI8luzuZaEZlQIreqDM0Bb83BlUgNDK8mVxi6F/g4CKKpnaX77THUN1lJNSBoj2/isW5QHtAk8Dj45oYGtPfuFiuwmhENvSiGja2ekDtJrvgcQpVYLUeIongQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SJ2PR11MB7647.namprd11.prod.outlook.com (2603:10b6:a03:4c3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.11; Wed, 10 Jun
 2026 17:58:29 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Wed, 10 Jun 2026
 17:58:29 +0000
Message-ID: <a1dd1858-a6d1-4760-9181-ca30de3a1510@intel.com>
Date: Wed, 10 Jun 2026 10:58:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/14] mpam,x86/resctrl: Resolve INTEL_PMT_TELEMETRY
 symbols at runtime
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "Box, David E" <david.e.box@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-12-tony.luck@intel.com>
 <03d45c09-b392-420a-9b38-1c1f213a7dcc@intel.com>
 <aiiq55x6fs2ddS91@agluck-desk3>
 <387cc53d-7e55-4c1a-bf0d-635f4f7590f6@intel.com>
 <aimHif2ZC3PIjHw1@agluck-desk3>
 <19f35a7b-711b-43e0-b938-3792ae723a59@intel.com>
 <aimR-7ld7-EE_YCb@agluck-desk3>
 <8ec6b46e-dd18-491e-97f9-04cbba827370@intel.com>
 <SJ1PR11MB60838C247727AE7CC324BB25FC1A2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <SJ1PR11MB60838C247727AE7CC324BB25FC1A2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0327.namprd04.prod.outlook.com
 (2603:10b6:303:82::32) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SJ2PR11MB7647:EE_
X-MS-Office365-Filtering-Correlation-Id: 368bb9e1-ebb9-4b7f-29c0-08dec719e0a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: u81mCTRFwJ9/hyObH5J/CcasIKpBc1TuHyLvy4zUHUvXajIVt8P/y/V6aM15AfrG++up4Ou2FyI7007zmJMcGFiT9qlg5HJyvxXPrR6XMq/4i8aOrlwP7LpufLQr+LabJYqZn8ep4BS5oB49KuYGqwfIgX5V/GJP/1SuCJdEyKSafelOgHn/ih516+6S41AfimIG8okOGZ03f3RJdk2gxXGkXXzPl6lCDSjTZp8zrnorOMhHU/+2d8ESUWPcgcB5MM8crA7gNCo19PdLwcM+sD8XSnDEpyAqRzqM18MO3rXoAgfbC4Xmvcvn95sKfHClBCLfoOYqb2Ige7GFlKcVyDUemzWLUtT2E3aO+HTw1R9nqbaxJYHNncxFYaC4gYHC7SyouXRgX6hKXha+JRnuuvFqOeCkwhSgmXqSdbzIHb4VXAdG022dvsCk4hQp8afNJt2jNoUHlWC02l/vUUUabmBpF7hgY1ztTdEsspPtZgdioo1sPeDH9/Ap8q13jIaZolVxj0V2ndY8wSQuQ5aglqYPKmfqACAWkJmgUT6UVi486+C39NEa0je7HA1k8ehdE1RUALTUemLZCGOTl/1q4R9oSVe/H9P+E8EuJsQ/l0rzVJiSFSoSsG34RaXjdvoT2SjjqmBkssmlKUiirxQZF1GoKo6buS+L/4pMaUmpXzmQRTRpgMux6alkzn5SuXxL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qmd4NngzZ0JnS0huM0lzY28yMjZOeDlTWXJJZjNzUUpyWFF6RHpLdElvMFh4?=
 =?utf-8?B?eXM3UE1GYldzKzE1OEk5WnRKMndDOGcyMjJ0Zm1CcWozQWd5T3pmbnNRSHJB?=
 =?utf-8?B?UkxLVGZkNUVDQ1JIcGxCUStsZ1VJTGV4d1dndjlvV2pXSkJTVG1kYVpPN0Z0?=
 =?utf-8?B?Y28xL0FEaGdhS1RQL0VuYmNRUWFxVWpoeTR2bnY1QzlVMjFDTHE2VzJ4N0RS?=
 =?utf-8?B?cTd3WWx0Y01GRnptc0lNVjZ1MHUxdHpuVW9jME9PdEI3Z2wzZnIxRE9OS0Jq?=
 =?utf-8?B?TDVGUHJZekgrSmNld3RCODk1Rlh1UEk1d3dBZjM5ZjJBb2s1aFBXZWZHYTkz?=
 =?utf-8?B?LzNFSGlBVUd5WkdSVFRQRFBNcE03TlJ2eGQrM0ZqZTdqeXl3VThDb0RTVTlF?=
 =?utf-8?B?MHVwNzlOWEI4eUZwbW5ndUlkaDRuaVg1SU51aTdDcFNPdGlmTGhYcHlidU15?=
 =?utf-8?B?U01pcFZMTjVicTAxUVg2bFRmL2Z4R05uUmVkMS8ydDBRSGtqR1RKNDNiVFRa?=
 =?utf-8?B?YkFmbVN0QnQvY3MyQXo1ajJxUXc4STFLYzlRWVRTQVlyS0J4d3owSWY3Z1Uw?=
 =?utf-8?B?U2V6TEpNdU0vejVmdXNiZzh0UVRobjFsS3RLSTQ1UGNBVlN2Tm01RndoQmV1?=
 =?utf-8?B?dURJUlExU3JxN0RyckVWWmhTTlM2K1BTajNvMU9RMU1Va0V2YnhyWGpFcWRo?=
 =?utf-8?B?bHQ1OHd3cW1seU4zMnZYc0FoMmNXMnNJK0QyNzJtWWltN3pxUDF1OWQ0b0hF?=
 =?utf-8?B?dXdUMy9xSFpNNnVNNFlWR2xQUVBZUU1UV0JrZ3VnTWw5RHRUNTA2dGNFT1RO?=
 =?utf-8?B?Y1dzenIxa25IT3dIbE9wWktwWjJMKzgreFVVcGRlYWVocGRpdjdUeEJXaWV1?=
 =?utf-8?B?WTdXTkllNE9Gc09PQXo3dFcwN3ByTXlRZm1ZNExwL0czbkJhdmUwOVdDVU1Z?=
 =?utf-8?B?TURZSWdnclhBWU5MYUI1alJ0QTZTMW9aUTlENVhEQlF2NlBROXdzS3k5dVFu?=
 =?utf-8?B?M09jUEtpSFRqVGFCUDFHMHBFNnNuNGhIY0M2OUN6ZU5namQzdTZxSzh1M2dw?=
 =?utf-8?B?NXY2V3NjbGFVbHJKT29LT2p4QTB3Z0ZiYUFOU0JONVpSS0cxS0Y4SGltT1F5?=
 =?utf-8?B?dlVTaGhSdVNQeDZOY1lEOVkvNFFML20zMG53OHBvd28vR0M5QXMzWWJPc0VK?=
 =?utf-8?B?bFZIMloxMVprK1N2bWFKcWgxYy82R0RoZlhwNmk2cmlMa1p6NnYrOGdURnlt?=
 =?utf-8?B?SjdKY2tKQTE5MVFBWlQ0S200ZHRqdkRvWDV6ZFRnTlhpWkFJMVhjSlhmVlpx?=
 =?utf-8?B?ck5LQWdsWWlMZWtCa1hYVUttMHJGMTQ1RkpLZlRQMlJlWGlJL3kxN3J6RkpJ?=
 =?utf-8?B?T1FQMXhNWlRWdlY3cUxEc2w5YnNPb1o1T3NrcXM0ZDhsWW1pZnoyeGppZnFr?=
 =?utf-8?B?ZGQrTzB2VVVCM3QyZDJRaEoxWnBhVCtHSXVBOU83ZlBOUXZ3eG5Udk5TQVNk?=
 =?utf-8?B?dVBiMGxGWitZVmhpcFg0TE9Pd3V5ZnN2QUd0dXVLYkRYTFltZXFDY0t5Ly93?=
 =?utf-8?B?d1BEcWJJZXg1NGZKZ083NXhKS3pPeEc0MXlyUTRLa21rVGRVd2w5b2Z4R3U0?=
 =?utf-8?B?VjBHNmNDZ0tRQ1c2Rk0xazY2bkM4VW9NOFVIWE9Bc0dhU3JHa3ZWZzRzUVZy?=
 =?utf-8?B?NkUvWXVDMXFLYnkvc3M4L0tTQ3lqSk5YQUhsTG0zSGRlMmlaVkpQaTN6bTha?=
 =?utf-8?B?b2FJUDBselR2a2IzNFJaZ0pmQlY2ZDZYNXNHZFcva3JBa1U1VmwwZ3ZsYjBO?=
 =?utf-8?B?SXMyUHdjQlpJOXJxWmNSQlpPT3hXVzBPR09pYjkrWWtURDhyV1daOHRSNVJi?=
 =?utf-8?B?RWlYQWhoMUR6QTUrSVBqRU1DNHhmejBRR0oxdVRtMEI4ZWtiWlNjNmlmU0x6?=
 =?utf-8?B?R0FGd0w3ellMWjdSUXZLRXN2Z3lGSnV5c1BPNktJWmRuU3U1MmtTL2s4YWpO?=
 =?utf-8?B?anF4QXJKRHZrTHVsZEpJS2dqcjAyd3BhTmpMQlN0SFFieFI5YnhaT0FZaFhP?=
 =?utf-8?B?RWZPSlRMVDBXcFRWOUhNRXVNMlYxM1RKbDlabTNmWlNTOGFhV21TZFhSUGhZ?=
 =?utf-8?B?QW0xNkxTNkxNb0g1aUFjd1pWNWZiY0JyL000YW42QkNRZ050bHc2c1lhZ2ho?=
 =?utf-8?B?ZWFKUTlwNTZaRDJzYldjVmdDMUZFL0ZQOFlYcDRSTWpEeFQzSjIxVFkrQzRC?=
 =?utf-8?B?c1djcGNsYlhaN2t0cThEQVEzK0hMSmdhdEdvR0pTekNLbXZRNFRjaW1ZOEZG?=
 =?utf-8?B?Y09NMTVsT1Yzb1cvWno4emZiRmt6SGtmbExEaktTWHhUYWNIZ2R6NkE4SHlL?=
 =?utf-8?Q?BrDlbySGkVIuv/wE=3D?=
X-Exchange-RoutingPolicyChecked: Awg3/Wti+oo2uQAGDcEwvVC7c/9kv5vI5/yuawe7ilZPFQc31z5eKikuIzwSN7khiDLAQapBH5Ot9+Kdnz5JuTVqd/JaxVDnxN+Xh0nzPiofhdpuDONL6eC7dTAidP3GAyAxJ49VpykJ6OAmgARewzjRMdVzEX28pb6nE+gwqMEuB8uh7DmsN8s+EO66sAubAxojpuETaCxoQ8RfrR18WNcLSJx7Y/1a4CotZyOmXLuMsG3WVxFsPHL5AbCSsQdWZLt9OSmuyGq1ivjFJu+LciggkLgdNd8D57ySv0J6ieUWzzREfyIY/0DIaUP9A80YQw/MnRm50CBYgDj8+6315A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 368bb9e1-ebb9-4b7f-29c0-08dec719e0a5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 17:58:29.1754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GRaXGR/RTTAP8Drc4S5u1xFdEHc49tNbn+oDOOKu8D6L6671a0ulZ0GIT5CydxijfRVuYtoiqAhjOsL2fYw+qZd5tqwsbeLLjJbce5CNCS0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7647
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/26 10:24 AM, Luck, Tony wrote:
>> I see many "if (pmt_module)" checks ... intel_aet_pre_mount() even calls it twice. Are they all necessary?
>> It creates the impression that the PMT module can be yanked from AET at any time, something which
>> intel_aet_unregister_enumeration() seems to allow. I was hoping that there can be some guarantee
>> that if PMT is available during pre_mount() it will continue to be available at least until
>> unmount() completes.
> 
> pmt_module is NULL if CONFIG_INTEL_PMT_TELEMETRY=y ... i.e. built-in to the kernel.
> 
> In that case it obviously can't go away, and doesn't need module_get()/module_put().
> There's no special case for this. try_module_get() takes a fault on NULL dereference.
> 
> When CONFIG_INTEL_PMT_TELEMETRY=m then the get/put should stop it going away
> (I tried rmmod while resctrl mounted and it fails to remove as expected).

Have you tried "unbind" via sysfs?

Even so, my comment was in response to the code you shared. Let me paste it
back and highlight what I meant with the "many pmt_module checks":

> /*
>  * Track whether pmt_telemetry enumeration succeeded during mount for use
>  * during unmount.
>  */
> static bool pmt_in_use;
> 
> bool intel_aet_pre_mount(void)
> {
> 	bool ret;
> 
> 	guard(mutex)(&aet_register_lock);
> 	if (!get_feature || !put_feature)
> 		return false;
> 
> 	if (pmt_module) {

Here is an "if (pmt_module)" check ... can it ever be false? If so
then the rest of this function becomes very confusing (more below ...)

> 		if (!try_module_get(pmt_module))
> 			return false;
> 	}
> 
> 	ret = aet_get_events();

aet_get_events() can thus seemingly be called when pmt_module is unset?

> 
> 	if (!ret) {
> 		if (pmt_module)

Can pmt_module be unset here?

> 			module_put(pmt_module);
> 	} else {
> 		pmt_in_use = true;

So pmt_in_use could be true if pmt_module is unset? Confusing, no?

> 	}
> 
> 	return ret;
> }
> 
> void intel_aet_unmount(void)
> {
> 	struct event_group **peg;
> 
> 	guard(mutex)(&aet_register_lock);
> 	if (!pmt_in_use)
> 		return;
> 
> 	for_each_event_group(peg) {
> 		if ((*peg)->pfg) {
> 			struct event_group *e = *peg;
> 
> 			for (int j = 0; j < e->num_events; j++)
> 				resctrl_disable_mon_event(e->evts[j].id);
> 			put_feature((*peg)->pfg);
> 			(*peg)->pfg = NULL;
> 		}
> 	}
> 	if (pmt_module)

So this implies that pmt_module could be unset here ... if that is the
case then that means that the PMT module disappeared while resctrl was
mounted which is exactly what this work aims to prevent, no?

> 		module_put(pmt_module);
> 	pmt_in_use = false;

... if pmt_module was unset then how could pmt_in_use ever be true?

> }

Reinette

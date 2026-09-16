Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4F64A7CBF
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 17:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789579330; cv=fail; b=S0QhNXEkeOBTQn3yV/mHS9SENdp4S7RhxzzH1UhLMjMqAGiXZh4aV8WWsJjJSRzAn+M0L76gW11FIQ1UzvanNKrF75Sg6alai0qScx5fZl4bM8rtLTvr4OQI32K52kw1irU4pV7qQ4slfqC2qfXpc85mO7UMV0P25VgvwbbeyTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789579330; c=relaxed/simple;
	bh=OMemCFb6pfiaQS82vhKdHH2u/gTbivbubAZfUsGaUEg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hrixTbIcPTJFqmEFgB5hIZmLf3vn8GYoLzX8pSZSWyNM126aSuqpTlkQ8EvQWnM814SOqVVFdPNKe8Tl5Ac5aUbPibROYCsOqRpasETHDluEr5Z/nDTKx8xRA0IrWDYvzsqcLh/Z0a5LwsCCNEOa2smAl7yj4FA/pRdoyunLQIM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S00ZTZbg; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S00ZTZbg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789579328; x=1821115328;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OMemCFb6pfiaQS82vhKdHH2u/gTbivbubAZfUsGaUEg=;
  b=S00ZTZbgpBjK7mFHJCu0jMxPXOKIb5BtsWM25QniotogOD0R6uXu+UF1
   +kpH2i0tPKBYKe2JLuiTZZpbEjiy2LpCVWpZuslKmM9e+kC/75NQ6eC/N
   1939nMnAVPpCL/6zzItsAqt5LSJTqNzm8wSI0dPJR9ha2ii+MMSB6VOt0
   iMGfh1gayv1qmkeZnVV/nDx7xNx2JKmL/u7MUEPCQ4CuLvZHpKZRWgF9D
   +B5Km7Wwa5sVhHGWn9auPK8q+Nxc96EUYOSovfuhQwKBxJJ9bG5gBQOPU
   BVKiTF4IRROj1XHOjBQ2yiDHjwq5O49pakwW0IfGXqKXPty07G075kBSQ
   Q==;
X-CSE-ConnectionGUID: zBKtlFG8S9eM/fO/ATUGWw==
X-CSE-MsgGUID: NYNL7HAUSY+3zet7+ljDBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="89830821"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="89830821"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 10:22:07 -0700
X-CSE-ConnectionGUID: M/+nazw5RDusnqzcXeTPGA==
X-CSE-MsgGUID: Hl/T6gO7R9igXXJLYIQYLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="272928978"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 10:22:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 16 Sep 2026 10:22:06 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 16 Sep 2026 10:22:06 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.24) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 16 Sep 2026 10:22:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bhOjWo5Gn5d3xPMjWtBnEA8QqCA5316CoB0JAuxOZvS7d4U8l2GHtqSnnYgtEXZ1hapomrLaXTrCLlIYIhl5HDdTItIcKTruQrb9+XmC12ESrtumT/wz0uE1b1CjS+uDlX55qwrXBdxesmMYoZdsFunVztvnwQgYEIxw5e536N935Oj2XYjRYFZSktCW65e888rz0TbAVeWrEwVlk/0se9qlmhktGA2GSLhLODysc3dTYPYc6sQ9EpEnATCdGxcx7Tqg+H2KNYY9VCCwfKTCigkdyu4pQPySdwVXt85ZUPmdRo4erWlCKTYIN54ichP1fZOYoWjQUOJw1Qx2s8oIfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N0EayaP7r9CEpieGqtHf5Kv1EpVpdQ+3wB5LrS2pUzM=;
 b=zAF+0OxzJZRsz3bJaLwEVHAGAOS82XVJg16dXBYW3Mta9KvoMLr71eMOLJiatmG9I5YKnWoPxNhgemQ4mHGZ/NcOrODpoX0qIDffI7jo3cnId1+LVQY+/lpsk5yL0J3A52Z+1tl0Yww1OiMq+h/kLU4UOnmahQ+O7S8UUzaNMeu0SZlgqWnCiCYBJJdFWmdmCbKu1xSbPQKaFYRISHNgnfWQIMDagDEWw6MikHVjEeeXya6MCelMOsPXCed0g1mnTKxGu8p6HP2prj9Q31lzU2i2RGMe/DUYUuC3NP7ddHG3Fd4Wmf3t+21btJ47iJ0xvxVjF/wJLkzYKuT8w5Pvvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DM6PR11MB4691.namprd11.prod.outlook.com (2603:10b6:5:2a6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 17:22:01 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0428.008; Wed, 16 Sep 2026
 17:22:01 +0000
Message-ID: <483724fd-2e00-49e7-86fc-a2b120eae482@intel.com>
Date: Wed, 16 Sep 2026 10:21:58 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 19/23] x86/resctrl: Export interface to report
 telemetry unbind/remove
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-20-tony.luck@intel.com>
 <1a418996-fe0a-4553-bd21-9881ab182e51@intel.com>
 <aqrDObHc99BX1Gmf@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aqrDObHc99BX1Gmf@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0065.namprd04.prod.outlook.com
 (2603:10b6:303:6b::10) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DM6PR11MB4691:EE_
X-MS-Office365-Filtering-Correlation-Id: 26f01d75-7c45-4fed-d754-08df141704c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|4143699003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: AyvMLsfNH56J5DtZDk8Bsjx0sbzPC22mJYfIH1HGxz0HIwD+sAdk0ToLwXhOWqyXL/dzC41UTyawFzHh6xNTSRZXif2tlSGys5U0XRn4mRow0midj49wQ2I6Iuu0uEwvV/6RVPvT7Y8Tdd785vvTfdHpEOf+cnEK18DpIK8R5bt/pJm7aVGk8ThgIAaXFazt/Lmd9BiRiFpA35hvA7PqlzXVaLWVumpIQgBa5fwlDTMj3PVIf32kU5jbJMEEVYl69rXPVNPEAAAnaMFej4lKHdYgAr82xrC5COse9X5XOsITQdWXs86tJmnme5sOw0wP4gJFV1pAOel0LwvxrohRiRGSACpVoJPe8RbLV6rwD3VqKhE5h0Py9KZwabbmNnPYsw2TmAqgIrbDEselE4vknKMBddFxdxUf830498odgvaY4q6kSAnbCaX73jHE3APpn8ZaKXZKBrMfU7VYzica7XBkP7PaDvkrjS5+YiVcnWBSxaR5cLz7+h40ZV1XUxUB4VUEPpV73b2ep3PF4FP7UaqoTG1kvZHshdyQ9wnU9DRsAfKAJzHJf2aj3Gd8x1qW2VdAHmzig/laLMDp9W30l2gmn4fkGOPYMSeEa1c7KgmSXbd2bHFKu6rhan6D6Sxbu19NGvFIjfUmVXqVodR8WkfwdaScYRQ+RAuRr8La+eE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(4143699003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0pvQzRUdERyZlFRbERJdGhEN01hUDRkMitaK2pKOHZtTmNvRnFrMWFIRFpN?=
 =?utf-8?B?dlY1WkJTZWtwSkE1NlZodmpxMEpmVHl0bnpmZGhFdW1GaEsrUTl0ZHI4ZE82?=
 =?utf-8?B?MXNUa0RrWHdQVkxqWkl5N3NVRDEzeG1MbmhMZkJrWk1vME1LQ3JrcHBSV2Fh?=
 =?utf-8?B?REJ1YTRBZmxQTzIwN2ppTERRWGJUUkdMV3VRek5nWW9VMGVTbElhRW5rV1V3?=
 =?utf-8?B?Y0VRN1ZTMXpRMmloOG5qUW9zU2lOUFNFVmRpSmR6Y21ueDcxWWMrU3E0UVI3?=
 =?utf-8?B?NHdYN2xPdGR6czhrdmpRZWc2U1NkVTZRekIvWDU0TFFXdzhJT3lralJpNWt3?=
 =?utf-8?B?Q29TSUt2a1ZibVZHL2VMenI1WEVoM3JuQUVyZnJoc292ZnZpMEtZT2M1am15?=
 =?utf-8?B?QTFldEFEbVZmb0gzRGk0dDBkdDJ0SEpyWFQ1aVRaSSs3bTZCUng2aXZxZkl4?=
 =?utf-8?B?U2xmVjdHMGQzWkZORU5qUFF0Qytha2haWHBSb3VSUTl5THZCbGZhQWxLclZY?=
 =?utf-8?B?TlZKdnhuRWp5NytscGVZUTM0OHNKRGZNcysvYmozYUcySWRFZFN1RC9PZTZR?=
 =?utf-8?B?Wm96NGtTM1pkQ0QrVDFyQ3dpd1RLVDREMmlxam9IUE9yaGVzcGRuck0rcitG?=
 =?utf-8?B?ZjZsYVZrOWovVWREVmpZdVlmM1gxd2twMzA4L21teE5YeVdQMWNQWTJzdnRT?=
 =?utf-8?B?dnlVMkI5Sy9RM3NtZnRJTjlWcXArSmR3dXlzWXY3WUVleERjblg2WnFMUFNl?=
 =?utf-8?B?ek0vTy8rb1Jwck1nMWZlU0RiZktuaGc1b0pjR1l1aG1iY3UrY2dLZTZINk00?=
 =?utf-8?B?eGJpMmxyZjhoVnRiSjlYVWpGK1haYStpN1diOUd6d2tBbmxtd2FMSGZtK0Yy?=
 =?utf-8?B?NEhoQzBHVnJJQ1hRaS9KM3IvTG5OaWxPbDVRSVM1c1FSOGx0R2xwaUJYekNz?=
 =?utf-8?B?bkMxNXBEdml3YjRGNnA5OWdBRk5oOW5WLzQvYU12cXpLZUpHQzI4dmV5anhN?=
 =?utf-8?B?RGdFdmdJTUViZmhuVW8xTGpHcXRpdU5WZTE3UHFqK2FXYzFmYjFiVFJKaXk3?=
 =?utf-8?B?cjBKak8vQ2FDQlVWcWo1dHdjczNTcGtCL3Z5R1M5RXFVVkg0SXlvbVRyc2RY?=
 =?utf-8?B?TVlMYXZPMXp4a3VmMmZJQ1VyT3ZxWTJXankzNkNmc0oyS1p3RlpRaHdXWGQ0?=
 =?utf-8?B?SXRpOHU2UVVickdWUHpyNk8vNEJKRS91SjhJOW1kajFTekIrM0Y0a0NXMmRH?=
 =?utf-8?B?U3hPeVJmR0ZNY0hpT1VJdVVvZmk5MmVGNEtqZVp5cnMwUlI4dEIxYjRCVERi?=
 =?utf-8?B?NFZCbjliM254SHB6RHB0NUtqOVJaOVJxaXVGVENCSDl1dkFOQ21vcWxPTW9J?=
 =?utf-8?B?cVA2ekticUpCSEhEdTQ5Y0puVHd5ak9ENGowaTcvU0svOVlES2RvTmlyVU4y?=
 =?utf-8?B?V085YUxDT1RML29pYkNZSzdpWlVNaFNiems2WEVRYjNmSVVlejJVeVhQTWZT?=
 =?utf-8?B?RVNucDdGWWdWSXQ1azc1MG9sNUlYTGg0QWg1N0N6MTNnc2piNXNOcytTM0Zz?=
 =?utf-8?B?czU4aTF3dXBUbGd3RWRHbTJNWFhCbHErZHduWFl3ZTFkUEtjMnpHMVpRcGpG?=
 =?utf-8?B?VlpJYnJSOUxqd0VLU25qaXA2Y3FVeWVoaHFNU09UVlJKNWtCWU9sanhzdGNl?=
 =?utf-8?B?Ky9NZldMYmVTdDcydkhXQ1NBSzN3dVlMMmhRbHJzeE1CZmpROXByVjlIR1lN?=
 =?utf-8?B?SjlPb3VjbXJQTmFBMnhBMENGb2kzNFdKem5ONXdQaGZkRUkzaDN4ZWZiV3gy?=
 =?utf-8?B?VUY2OGFlQUJtWVRjMnhxM21SVGVISWdwM3hLZHkzOTNyK2lpWmJTOGFwazE1?=
 =?utf-8?B?R2NsSUgrVnZYMGVVSGMwdmpRd2QwOTBsRDZranhoYktaOWpJVndha3BydmJ0?=
 =?utf-8?B?d05yNUlJaUQyaXVEQm4rOHlKVDU0Vk1TRUxNVWlrdC9HWWJvQk9yQW1ObXRF?=
 =?utf-8?B?anJjM2RuODA4ZWowajdzTG9QUmdsQ1FNd1lTS2VpRlRrWFhRRlhLVmdYOUFJ?=
 =?utf-8?B?Mk9oWlNCOGs2b2k4Q3VNNzB6dGhWQzJyamc0SDJ4eEVIMXphdmEySzlBQzBp?=
 =?utf-8?B?eml0YmlLVkhzdWlXUERNM013RU1pRVB2WUpwRytwUnlrc29xVXlicFZKWnFq?=
 =?utf-8?B?NlJGdFlRd3ZOVENWd29VeFJYeG4zZk9HazRjUURCc0hOREhEYjRicExDWVht?=
 =?utf-8?B?V3lwOVpvRnV0SHBkWEJMT215ajIvaSt1NS9KT0lBRTNLb2dIaEVmN2IvWDNM?=
 =?utf-8?B?NzIyYS9HMHVrZFo3WDVKaUkwKzhHb3FTQjVhMHdIYlR1eXRTaThUQlFGbFNP?=
 =?utf-8?Q?CS8SMUsu/qhCOcC8=3D?=
X-Exchange-RoutingPolicyChecked: vt4Zf8W33lkRWFii5ITzjnN9cImfxjXtRqwTQQc+mRRW7lU4pqWOMMu1XM3wGyGrO/VaQP7gi78LNPEXdv+uJxdCPvRuksX1jWKTzg/z5tiNBcJSS+CQsUscBIXrTdHcYNYwKaTMXp/k2lLKHi3LU2UapBcLP2j6fEYCsJ7IXWcNOFLtdJuFR1kD+JzEiBO+A1i2Ig2jj4OoKuQ5wCMw3LOilcJm9r/emukuO/UG8Ce6m3cLue1TCpVkPuEj7cslHx1LaB1TUZvsGmrFqz5wbi1ae3P2ADZmlJH8BQqzEiJ0G2WTCxhHYPyC73PJiqY2KZ3rFs6/tyKs1DjgReaIBQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 26f01d75-7c45-4fed-d754-08df141704c8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 17:22:00.8254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /cHN89Nv08H+ixctSvQ39fRcW7fOe3fUoVoDBMdZed3wThcl+Hq4LlnDWnPFwSLk/6on6cNLiG0hZNOVqT2YoulhjxydTkBq/TLrTwELMsc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4691
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 9:26 AM, Luck, Tony wrote:
> On Wed, Sep 09, 2026 at 09:08:29PM -0700, Reinette Chatre wrote:
>> On 8/31/26 10:44 AM, Tony Luck wrote:
>>
>> ...
>>
>>> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
>>> index c3bd3536c514..5cd2711d00e7 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
>>> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
>>
>> ..
>>
>>> @@ -439,6 +462,8 @@ int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
>>>  	void *pevt0;
>>>  	u32 idx;
>>>  
>>> +	guard(mutex)(&aet_register_lock);
>>> +
>>
>> hmmm ... this means that reading an event can sleep now ... but it is still
>> possible to call this via IPI (smp_call_function_any()) if the CPU is part
>> of the nohz_full subset?
> 
> All AET events are implemented with counters in MMIO space and can be
> read from any CPU. So this check in mon_event_read() bypasses the
> check for nohz CPUs:
> 
> 	if (evt->any_cpu) {
> 		mon_event_count(rr);
> 		goto out_ctx_free;
> 	}

Thank you for the reminder.

> But even if it didn't, is there some prohibition for nohz CPUs to
> sleep? I can see possible issues with a timed delay that might rely on a
> clock tick to wake. But it would seem that any read(2) system call
> from a regular file might sleep waiting for I/O completion.

resctrl reads RMIDs that use MSR_IA32_QM_EVTSEL/MSR_IA32_QM_CTR by scheduling the
MSR reading work to run on a CPU that belongs to the domain via smp_call_on_cpu().
On a nohz CPU this scheduling may never complete since the nohz CPU just stays in
user space running its workload. The nohz CPU instead needs to be interrupted via
IPI using smp_call_function_any() and it is that work that is run via IPI that cannot
sleep.

Reinette

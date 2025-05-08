Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5212C433AC
	for <patches@lists.linux.dev>; Thu,  8 May 2025 03:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746675126; cv=fail; b=nx0VdZZW6PFRQPinogXWuSb/+kWBUiWNk6wEU3OHaBqy7a3u2IQJfnn5zwtTFi/sKCTbFyrGB/sbMj6E9oizPd6xZeZRVthAKAoKTCaowvSEtAysgkL5zisuIimv1sPNN2oiIt02uJ5Pa2Iy1Q3Dtk2ZVtoM/snA/Y0ArPP8hf4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746675126; c=relaxed/simple;
	bh=1nhi7oqiPYDDB0R9vPe6JT+Y4Np7bgIVDZJ1iG3kFH4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VWBdDIB++y/vcdzSpCG8x2ky3o5dv7ShWxYQM6Jan0de07jcELqn+WrQWMRa3xlrF3ly1Y7BFpFUyY8OvfcPiPM+orY8KaaTRibLIHl6spEJg/8APXTGS8B6nhsSPEPMWJJCUSbHbxZvt10wlmbAVGm1WhfHifP0IbXjXOy3/r0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YFRcI38I; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YFRcI38I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746675126; x=1778211126;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1nhi7oqiPYDDB0R9vPe6JT+Y4Np7bgIVDZJ1iG3kFH4=;
  b=YFRcI38InpOY7EktKu6rpCKd6SFXwmV+yWI0fASYiIwRxUSsLgGRqKWF
   /v/ZizmpqclE6O458f/4GdA3xOZtKtBlvBSSxtJm926sTj3PyfLf6uFQo
   tt2JWqj3yGV+N9l1Wxb4ZrXEHydDJm6gc3TKKhTqSZqOBoQmKz7eQ/1YT
   mqA2dU743VN5TWxfKlF6IeXELTHyUY7iQm70Py9RxN88N2aVjiCrahRDY
   Sn/p13SsClUMjiZZiOhfTJvANhEox9dLT3A3K8A1GZU0xtE/XZMozqy5f
   waQACzFq+orSkw7wdNHC+TTz0INUrfa69FxsvTK3e0W6P1mykDTOPdMov
   w==;
X-CSE-ConnectionGUID: CrpBmShtTC6Ke/KS05kp6A==
X-CSE-MsgGUID: Iq9pfoNOTkWMese4Mp2pIg==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="48344424"
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="48344424"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:32:05 -0700
X-CSE-ConnectionGUID: cUoOuD6/RCuEEOYmF9Y5kg==
X-CSE-MsgGUID: dd+ouGsfTxyD1IVDfWBAZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="141364844"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:32:04 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 20:32:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 20:32:04 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 20:32:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dqwJUQvHKklO6v+NfBRPrYXaln9ttgnFFDMqx0QPGw13xM/hDyJ98tYKvQvG1kmsiXXdUBn7A5UBcv8GpxcQrb/jyOdnt7VIK6YLO0DHsUJ3xOt31GKT37VrEFTyONI/itV749ozHh5Tg4NQ0DD+Xsj0patNXRHXU9lZCWZJ7U7AFlrhsizEc216KVQYbqN7fSI7biLstqjBX7xvFf/kKv8vMa/YmaYGWXRn7JktEgfBE7u/2W9VUpdEbZmLkRHvlWZFgcNSfis4A+IVJjjKKl3B2VEwmsf6pxoiI35nc8S5pz0Rv30ulT9x3kH2LpHW9W+Ck+zEHpc7qSL/lM281A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FMjpbuUNogXJB9+wJlmgLQWFcKC+MR69MiMdtcV1JPE=;
 b=KObu7sda+XvpOT3fp4f33tEIcgIwPH4OvHcNlLb0D5AtFlAG/mfNQjgL96RLOR+1Vxv1uSXWw21ze9OIUEujP5KoacMg8kpjcFBgQjal/bJ7otSAdpnsq6dLfIi51RHZpf7coYVP0PQdTZphKICr3XFrPv3oS+OAjkbLcCEpkdHk7h8JdrRgsNHxEoc0HRzZ78GixdQ2XV80BOfU+vGYDj1+lPeFjqMVG8MbVPwQhrbRYMwosjl8Al5MXEnEbogQ5Mqqq3YmwR0VvVPV5JExi5zSYrEnqBnyOn8thjksLejsXHRS9jU3nvqSTxUoEu/d0ils0O6vje7yEPIPBg1pTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB8513.namprd11.prod.outlook.com (2603:10b6:a03:56e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 03:31:32 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8699.022; Thu, 8 May 2025
 03:31:32 +0000
Message-ID: <b2813723-e6df-4949-abcd-a624ad301c7e@intel.com>
Date: Wed, 7 May 2025 20:31:31 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/31] fs/resctrl: Change how and when events are
 initialized
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-5-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250429003359.375508-5-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0292.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB8513:EE_
X-MS-Office365-Filtering-Correlation-Id: a5146111-3950-4c7a-3e07-08dd8de0d3cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eXpwMjNzT3VVNnhhY292bHRsUUw2SEtpU1NhQVA1R2h1R3BsSDRyZGFLZ3dp?=
 =?utf-8?B?RnFQajVBVm9xclJLMEs1NmhYQVJiV0N6K3JGNVJXNDl6NVFYaEFtY2pNc3ph?=
 =?utf-8?B?S3JjSWo1enBaWVUvWlo5TVdwVVhVdHJ3OU1ZanVlR0dkbE92UDAzVHI1ZVpk?=
 =?utf-8?B?UGtmSkNOOG1DMEdDMU1FQUZHamF6QzhIRmNIb2pnSkJKckx4RTdlWGV6K3pF?=
 =?utf-8?B?OXg5aGJya1JOUkJZU0pFQVdDUlpmVGdQY2FubGJjc3ZXZEMwZFVoTGtkdjdt?=
 =?utf-8?B?a3huVmYyaTZkMUQzeFJnM3FzTitucFFTZ3VUaXRxNHVaUFpBaFM2Q0tQSDhw?=
 =?utf-8?B?OVpiMkRSU3VZSGxIVnM1ZnRuRlZ2OWFXcXgvL2dwK2ZrcFl1aVg0QVdQUDV1?=
 =?utf-8?B?YzlkcUpRNmZQeTdvSng4S3UvRStNaEs1ZlR6Z3dMYWFZQ2ROY2RqK1FRMnNo?=
 =?utf-8?B?UU1EaW42QWdHcnlrSlZBOU9kaG9DUUwrZEdUdFFGZEgxM0t3ZzMySTVRbEd1?=
 =?utf-8?B?dnlGTTF1bzhITVBvWmZtTDl5d0NHRDlVRkhGMVVFVXQ4Z3dVUE1kdGEweVk5?=
 =?utf-8?B?YVV4QTF0QTUyd3A1SmpVcG1QS0Z3NW5ZZVlURTVXbEQra21NUlJFZWRPcVd6?=
 =?utf-8?B?dHpmNkV2MXZZU2xNb3JDYTM3RWtVdXBzdFhYdmJPSHZ5a0pmM3RDa0RNREFI?=
 =?utf-8?B?QnlXM2xvZWF0TVVQZjExdDROZkE2aEpTa0dsdUdiOXNEQ2x3cUZxWXBvU2hj?=
 =?utf-8?B?dmtIVmhybzQ0QVZZYjR3N0QzOWUzSENoUndaM0NNeUxUREhTUTFXb0NTVDN3?=
 =?utf-8?B?bmxrQkVaY1RtZDdVSWVobnhtQXpPVXBCa01pTUZ4ekRrancraEUzRW5yd01j?=
 =?utf-8?B?V0xZY3phVnZFK3VFc0VPSmRocUI0eW11MEF3S3VZbUFtZktRUUZPTVlRV1hV?=
 =?utf-8?B?d1FNK2hITEhsZjM4U1dSaURTSzRmMXZYbG1lTEVXZTdqdUplZEdXdEZTai91?=
 =?utf-8?B?bWpWZDVlVzloSmFMaEpBaUM0cGQ5SUxPQUlIV1BGQmJLS1IrZjVnT2ZpbG9p?=
 =?utf-8?B?VXorRitRdmY4dWlaNkF0Y1lxTXV3WFNmTGx1ZktnaUdzSWM3VnE4RmJNZVlI?=
 =?utf-8?B?K1FYRldxSUtqWWk0aTZraWpsd3BYTklxM2lIb3dYdkovQUp4WlJza0JTUVpY?=
 =?utf-8?B?M2RIUHpOZ1czQnJZcElXYitIc0xnc3hVVlpkWUNnR0NjY0VKWkRnekhXMkw0?=
 =?utf-8?B?NUozVm9UTXpiVEhWdlRJTWIyZ0Q3SjZIVVRRc2dFUVlwRzZKbnUzY05jZzA4?=
 =?utf-8?B?NU50RkxZQUFvaStHdW5xblBtLzRsa01VaHBod0hSUXAwQUIrV2ZpR2pkZGhn?=
 =?utf-8?B?WE1ic2FHSzVVcGM5MldjNDFVRHpKZTBFSFV4OFZRazZKejJVZTM5L1VBdUFz?=
 =?utf-8?B?N3BQR09hV0I3dDJlVHMvWDV1VUVrR2VHdzFMYTlNa1BmemlFdldxM0lOQ2l5?=
 =?utf-8?B?L0piakdNSWRVM3d1bWpDeG9TWWpBRVJDVGtlbnRYZmJzNUowSXdoNGt2dU13?=
 =?utf-8?B?TUVRWXAyK3B4OFpHUHV2Wmw0eHBQSURZSTRSQWZMYjhEOGRINzhQK0J3ZUI5?=
 =?utf-8?B?MnYxajlDb0tTL3JiamMyL2ZUblp5TVhPUjduSUUwbnRFejB5UkFQMWF6Zm5J?=
 =?utf-8?B?eWdxWkl1ZUY1WkZvQjZodnpTeFV0NEM2Rk8zb3U0R2pvUlU4ZitnNjA3Rk9Z?=
 =?utf-8?B?cHYxMVRnd0psbFpaSHVJeWUvSmRDQ2ZZQUtvN0xnbXhNYitJdXp6WHpXSDFp?=
 =?utf-8?B?MGpLdWtKU1hQQm10U2dNZkNSVkZnZitxeUFLWXU2RXE2MjNRbDJOSERnbWx5?=
 =?utf-8?B?STRwMGwrVSswWnRaQkJSbjhSU1hRRGNnaWxORHdYM1ZVcENXV0xPalFPb2lO?=
 =?utf-8?B?UFR0SURVV0ZFQWhDNy94VVl5dm84cVJQeVJsMlV3a1BYR05iOE1nbUJhczVZ?=
 =?utf-8?B?alhuS1RKL21nPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZDBETGJhL1UwUVFmNW9MU2UzZ3lXME50NmFOQk9mZG5oU29PaFAzMThqWStQ?=
 =?utf-8?B?N3pGVGh1K0loYkRFdWlBMkVlbXdUSjNmbHZvR2UxQ2xIZ1BGaTBmeUtKUzRz?=
 =?utf-8?B?dytSM283alNRYSt1OEhERXlMSWFCQkF3MDhJUHVkVDd4Qkd5Y0hWd0dPbHo3?=
 =?utf-8?B?OU9URytvUnFpa2VFLzhRVUpzYVkzUE1MMTJaVnplVGo2ZlRrQVd2ekN2dm1k?=
 =?utf-8?B?amZsL2R1Mi9DTURacVRHM2g1VlVrMXFRWnBkbWlrT2t6VHFjaDdPODI2Umph?=
 =?utf-8?B?RS95eUpMMU1vRjBNb2wvclcxMVFqZzB0YTluak5Zb1M2TnEzQW9oY0J2bDVX?=
 =?utf-8?B?TmhwYmxnUFczWXRsRUk2MkVVN0gxQ0lDT3M4blhPdmZQN1gyTG94MDF1UDlS?=
 =?utf-8?B?akpDWjFlaTZKRUh5SFhlUXdqRWpYTmUveDhkWFlVZGpnM2FGS09VWjFNbDRy?=
 =?utf-8?B?SXozYVY2bEFTNUF1NXQ5cVRtK3ZFTmxMQXEvYU5VR0NFekRsS0Q2WkhST2pC?=
 =?utf-8?B?R2NTZ3lUVzhDK3BvT2wxKzE0ZzYwWVBncnJINmtFZFoxdWtDRnhNTkJLeXk4?=
 =?utf-8?B?SWVPUVR0VUY4eW1yckRmaEVyWDVPWW5UdHdzU0lVeXY0UHdIQUZpUWYrWFd3?=
 =?utf-8?B?Q2JlditUNWplQ0JlQVdoTURqcUVXRDBUMmNhTk5PWWJqbjhaM1hmTGNRd3dr?=
 =?utf-8?B?bldtTjBiR0R6SWZnamtaTGlTbU1henNHTTB5TDIrT0FYeFFuRVJiMkJOd1dq?=
 =?utf-8?B?bW0zM3g0TmlZdkVEWVB6ZFN6SWRZcENZNm80Q3VIemhkb1VjLzg2NGM0cEhJ?=
 =?utf-8?B?djgrcS9DSzRuNkE4aHhVeEVQanVUR1pzQUM3QVFQWS9wNmhtbEJUNE5LZ3JR?=
 =?utf-8?B?TUZaSUwyNHFMWElzdjVzcjhZQmljVkc4c3lqNTlVajFLTERhUWUrUDdPaGxX?=
 =?utf-8?B?SEdBNEFMdmV3SXduZlR3TjYwVHV4ZldzWWRxV0xjbzRZV3ZmUWpzblRMNGp5?=
 =?utf-8?B?OEVvNVROSC9Pb00xV2NLUEdDYWIwa0xXNjhVbng5VHJwUWpuV05maFlSMXlP?=
 =?utf-8?B?Ri9PSzR0bUF0REJyZW00OFZLV2h6QmpmMWhhVWNTcTZzUGsyanpqRitodk54?=
 =?utf-8?B?TlZaL1RTMTlQM2tqRm9JK3orK0tkUmJ2VHJ6MzIxbHVobjdNQlRWc20yMG5T?=
 =?utf-8?B?ZnBIRUJlUUFOYnZGSGVkQ1ZvNmFPU1liM2V5Zm5JZFFOM01GZWlZc2dLOUdn?=
 =?utf-8?B?ZDBsSmtsYkJpeE80NlUxZUpJcmdjVEhMUE9hQTRDNmtRWkhOOGFMZlBQL1hq?=
 =?utf-8?B?dWhlOHZaeTJyaGhjUkNVdUQwVDJsMy9oWFlQTlpWemZTQnJ3TU9IWWVBZm16?=
 =?utf-8?B?UE15KzlSSDA3bEg5cnBmQWFGUFpjOXdydy95UWdjS0lzSTZ4WkRMMEdTL1ZY?=
 =?utf-8?B?aTdleVQ4U3BwR1hxcVhNMVR5cUNhRE83SGVwS2k2ay9yZ2tJbEJPcTFWdmxE?=
 =?utf-8?B?c0ZENXg2Sk53NXdabVRoQVhyK3pSdjVyRVpWN3dsZGhMM3ovN3RzWTlIblJX?=
 =?utf-8?B?c2RyUUdycVQzTUxrZXEvcXpZejNOQ0ZQRFYxWGErdisxQi9aOGlQVC9zbWQy?=
 =?utf-8?B?NDBHcnA0ZmZmM1d0eHJFQmJkdUZoVlh0WGRoUS9OUk04S0Fpa1djelBTZ2tH?=
 =?utf-8?B?S1l4azRBWmVsNDVQVEFSelIvUk1ydS8rbnpFd2JZaGpWRHZCUjBDcHJYNy9x?=
 =?utf-8?B?dmU3b21CTS9Za3JtOVFlM0ZBRzMza2hES1E4TEp3cURKOFlUSCtYeEZOMnRM?=
 =?utf-8?B?K0prMFA5T1pxUldlcFZaY1BZUW4wQThOdUgvL0h6RWxDWUNMSnpyUjlscjNo?=
 =?utf-8?B?RVRqeWhqb01Da3JvWE4wbTNsaFIyYlBGUDNIZEl0b2pXdFdRRWJ6WTFOa1ho?=
 =?utf-8?B?TGRVTXlNT3FBY1FEaE91Qm5YaVU1NzdQUjV1WHo1dXZEVjlSRW1xM1lldkEx?=
 =?utf-8?B?NFhqaGhBV1E2RFp6TDBUNGN1NGpvc2YvZ3JUNkdHemk3WlVQaGtJMkZ6NWdH?=
 =?utf-8?B?TjEzMG5icThOSFBDalpMUmhkUnF4Z2IybU1QaDcxZ3VUVFc5bjk2YlZydkxq?=
 =?utf-8?B?RjUxQWZLSlV0TkdiVzNUYnBjRFlvYWZvbXFWUHhvQ3dEUWJESXJzV256UUtQ?=
 =?utf-8?B?dWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a5146111-3950-4c7a-3e07-08dd8de0d3cf
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 03:31:32.3329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0D/XQoVHIfmC2lTq6uRThMdCgDbAdSukHDtdCzbSZU48daOl/qfFQlkSR3A2rPjVLR2zlwcGHhiIn8nVWUJObg6fAQW6tk9VY0aPr6oc36Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8513
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
> Existing code assumes that all monitor events are associated with
> the RDT_RESOURCE_L3 resource. Also that all event enumeration is
> complete during early resctrl initialization. Neither of these
> assumptions remain true for new events.
> 
> Each resource must include a list of enabled events that is used
> to add appropriately named files when creating mon_data directories
> and to for the contents of "info/{resource}_MON/mon_features" file.
> 
> Move the building of enabled event lists for each resource from
> resctrl_mon_resource_init() to rdt_get_tree() to delay it until
> mount of the resctrl file system.
> 
> Add a new field to struct mon_evt to record which resource each
> event is associated with so that events are added to the correct
> resource event list.
> 

As mentioned in comments to patch #1 I think the array it introduces
can be used instead of rdt_resource::evt_list, simplifying this significantly.

Reinette

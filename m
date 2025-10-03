Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067B21DF965
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 23:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759533870; cv=fail; b=RAo59rqSd35Ka3cpHyPI6Zas2qB8Le7vkm1uVkZOyaVWLwcNMxBzXHpGibLMhNrDZmcA7dtpctuhDnKEIbwous2p61QbJf7VP17+gQg5Prg72gXJhAkjntA3jFFXXWCpvUcGHh0iNQq9Txw31R/WJ0n5I6iZ1/XlgV6sjYSObv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759533870; c=relaxed/simple;
	bh=W1pftYG5baDyGLKYcxZ31jSZrI280lWMCzRDr8UGlhs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NrjutJeLiey2qaYB0V1BfY5dPsnqkPOrVWa1fSEM1bkl4/93N7q+WY2PUOqCKhDmEC+GqldlLCOuF1xL2dSLgGriZiCvNyTPdJo92ZZEsUVwrTnU6K0zun8JB3D3tLFPm3H5VYz3/Ice8rJor3Hrtz106/JGgfI4a2R5m/yXT+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hmrRBPyO; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hmrRBPyO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759533869; x=1791069869;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W1pftYG5baDyGLKYcxZ31jSZrI280lWMCzRDr8UGlhs=;
  b=hmrRBPyOo3YkKIcU276OjChGd71cHtJFQP2BzPAwMOg7YpuUI2MhPj5+
   GAar3/FR4M/0RnfGu+q5Mbwt6fk4fWxod/OjlprReBYyhyHMP9YWm5fLB
   iXyppuOb7TqPRyJNgFWIZEp1KhACOqS5MEw/NSD3DWCaGki00or+jEBkV
   Xz0ESMjlejId7g+vvbyAfSiOLaSEBe66TlG73VX9vowqv27cuHmXrH6EB
   rgPXEvxs5bZZqtBkZi+ptphybUgtwfTcpI+ZxWB7rNzVSxIpTo1EWQVKC
   mnwjNh64tDEl1xvHMMtyfcT8Hw1vj6hYyLmhqvxQQywQoitiK6c30AtTR
   Q==;
X-CSE-ConnectionGUID: fxhHIAzUQbCwegWi2v+2nA==
X-CSE-MsgGUID: zio6sD36SX+ACXgVRXEbqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="79245610"
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="79245610"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 16:24:28 -0700
X-CSE-ConnectionGUID: FARtfze3T1uFOhaLAqwiBg==
X-CSE-MsgGUID: OGvMb/EfRQC040Y47t5o/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="183682166"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 16:24:27 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 16:24:27 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 16:24:26 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.29) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 16:24:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WO1K+yf+WJ2YZZvV+2lLmxai/XyWbSOlJGKN9imjVB2RUySB/T0Fc5JBb37Y2B7Yn8x80of68KKSwTU2e4O1aSdX+/1x+qPmDr3OezVMJnp0E57g3D8zw4Tu+kReza16lSE5cuAkwKGQ2iW6wo14S9W9yTL9jREI+pcPi4OOTV1FUsLLgZyR7g0mR2SB0PNyqe+Eqla+p22LMhxLBmQfKK1cBpCBEt+kIi1njda8WZiDXqMzwERVSUgaO6+/xvLtG/drq3NnKq8iCoycBLBOcMBUNdPp17p4E22PgftFCVleIXyl6196vRUsKamJhOhTtiM7N8XMhTshzOi46NCExQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yPnOZQ2jen7PyyRZPpahOL39SYyKSWeDDuF79UuugA4=;
 b=azAkHZ6OlH+/ak7A/tjabCZtZbc/UUgKzKzwoDxr35mU0iNdPx0peyAekElo0gOGfFRyH5ZAkwuWFUSgmjeNc2m8HIes+3zXtlrbB8wA6IpLWH3sDUcsBwa+tgEs7hiEwEmYrnf+1buVwJApE4PFQp1p1oBVsHvt/76+s7tMvncPPkb44do5p8U8wzKH0vkMsh98KctA9p1UlLuWiE1FBLf+BRPAcDDY6QzBNoqxA9klZLy8nrfKp4frxn9rysmkiM1KQIS5pCHqHUn3eLZB0ulY+Mg4KMpUMRRZp9iJ6hbGpsvfaZp62LMKN7K+gjwwkD0Oig0elf4VSnsiPNQWXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB5028.namprd11.prod.outlook.com (2603:10b6:303:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Fri, 3 Oct
 2025 23:24:14 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.015; Fri, 3 Oct 2025
 23:24:13 +0000
Message-ID: <e7b3a003-1e7e-4640-b36c-3ab11e5c0d27@intel.com>
Date: Fri, 3 Oct 2025 16:24:12 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 07/31] x86,fs/resctrl: Rename struct rdt_mon_domain
 and rdt_hw_mon_domain
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-8-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250925200328.64155-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0264.namprd04.prod.outlook.com
 (2603:10b6:303:88::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB5028:EE_
X-MS-Office365-Filtering-Correlation-Id: 411b31cb-3c6e-45a8-afd8-08de02d3f6ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N0wwMEQxcGxoWWx2VUZwUFZnb3RhQW93ZVgwVHVHVFd2OE5OK21HQjBZWnps?=
 =?utf-8?B?RlJNZ21OT2hWTEdmSDlITFBGcGlIMjRCbHE0bmFxUzBtemVnRmdUaHZ3MVRv?=
 =?utf-8?B?RzJYazBZSG9HaHhpWU0zeFF0dnEzS0hKZzU2ZkUwdFNLelhyMGFFa2hiRDcv?=
 =?utf-8?B?TG1ydjNBQS9kVVZQaWhyaWR6aVE3M1gwODZvWTI3SDVWNnduTDgrL2llZ0pu?=
 =?utf-8?B?RDNMMC9nams3NDR2b2lIU3RFdzJPcnBxU1J2blUwRzJvQldkN204TityRlM4?=
 =?utf-8?B?TFJLYjFVWVpnZ2FnS2VVbXd5a3RZY1BHcW5Uc0Ywb1pxNC83MmxjOTlnOVZq?=
 =?utf-8?B?K3FzcFF5VThLL08xM003OHdCRUdaNUk1T3daMU9zT3NRUVRETWw4MmRONEZt?=
 =?utf-8?B?NVpmZnF4QVA2eFdKSlZHRVR0SzJUdGI0bU15WG1CcTNrRmpVVWJOM2FaLzJO?=
 =?utf-8?B?Vld1RVVVTlRxNlE3V1lBSHdacXE1enVSaXlBZWN5c0x2MlhvWlJ1bEVDbEFt?=
 =?utf-8?B?emNMNmVpTStpQVFhVktnVy9aK3U5Ump3RktNd1Q0cWJUbmFwVVRBc0dNdERx?=
 =?utf-8?B?K2VuZmZXT3NGd0pMcFpDWXhNc3NyWmFHKzVxSmM2aEozRXJDWGZEQmpxdWtJ?=
 =?utf-8?B?dVdIQUt3VUpnTHJWUmpJN1RKNkx6ejBuRG4vM1BpWCs0dUFpV1pKalcxdURi?=
 =?utf-8?B?VTNXak8xTFFZQ002c3gyN1NkNmk3VW9QU0NaUUpHVEdXMGovbFExdUlWdHhj?=
 =?utf-8?B?SGRHV2g4Um5SYlJvVDJSV3E1bmJ2S2kySytZUGZzOXJLVk9SakwrNzZiWC8z?=
 =?utf-8?B?OFU2R3BDbU5IK1BINFoxdnNRbHF1UWdaRmJRQ0s3c1VtWXAyNDRuUnMyT3pX?=
 =?utf-8?B?STdHbHd1U0E2Q1IwOFprVWs1YWYxTGROREhqVGlNNUpIMklEbTBQYy9VcFBG?=
 =?utf-8?B?Vm5FRVNIOStNN0lNbXo5RGtPRFFtS0VOT3lUbWZCRmFXR1BFbUdKclI0L0xo?=
 =?utf-8?B?UEtvVGkyNzg4V2M3RmRpZXlSOXhHSHRxNlBmb3BiMXZHVHZnZFA3Tm5MU0Q1?=
 =?utf-8?B?TWJTN29FYmRFM1pHZEtPdzBnWUZ1Wk9OeXBZZUdHWXBITjRiZWFjdGVyd09G?=
 =?utf-8?B?TWMwMTFDTFdQc0lyUm11UVdNOGlVaCtpT0w5NVVtNXg4bnJYYnkySkdQZWtk?=
 =?utf-8?B?UnQwVXgwSklxY296b2J2ZnR4N0dYWlJUaDJ3Vi9LZ0Z5cCs3RCs0R25QaDhm?=
 =?utf-8?B?aFRkV3ZFakZrT3N3WEdvRjkrckUzT1VlUFUvRE9JdmtMTGF6Ulprb29GMjN3?=
 =?utf-8?B?Wmt5RXp1N0NvRk12U01VMzA1NHNCelZjb3hJVjk2KzNMMDdvYkZRV0JGVVlT?=
 =?utf-8?B?MVg0MkNJaXdPS0xMQnBoejNnVEdTemRnV3JBTEJMQXlDS3FPQ3MvR3g4QTdJ?=
 =?utf-8?B?NDA5MGtxRjg1M0JaMkxEdzlFMHNMVGlKaDBDdHB5Rk9EeWJiSmEvWTBsVHJ0?=
 =?utf-8?B?cFFGNzFhWDZBQVhVTGZGTEZyTWp0d1RlQkdLdTQzMXlBK08zQTVvcmtDTzc5?=
 =?utf-8?B?aFIxbjA4K1FGSXJpTWF6dDdEZ3lGMm43dkljRFV5dEc4YU5Kb1YvUEs3a1Js?=
 =?utf-8?B?N2VnckhXUC96T0V1WVNlNjcvYzNlUW15bmhtY0NKM2JZcnBsUys0eWhPeVVF?=
 =?utf-8?B?aUNVakxwVmFuZ2thYS9aMTdwUXZuRVlDTUFTN3A4Q01Jd3FLVEhPRFMzK1Y0?=
 =?utf-8?B?WnlqcWV0elN0clBBSk44N1dvQkJlV0xCcGZJTzBPUnhGNVlSYkdiWXoyekZ5?=
 =?utf-8?B?VGhPYjZUZTlRMGNFeGNsV1hkUHBHZXJqdHhaWW9uYWQwZGU5ZDE5SnowUTFu?=
 =?utf-8?B?dFFpKzFqdWVmZnlHdmtRR2RpWkVENFAvRDBia1U2TXNsVUJnVnUwZm05SkNq?=
 =?utf-8?Q?qCCjeSi5SFC/eK2jZDT8qZtkANiTu0vK?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VE9jc0ZkcVZKNVdVNTJRWnNGdlVVMHR3aXpJb1VETmxrYkFnSjhMdldOOUFl?=
 =?utf-8?B?TlBUSXEzakZUNTFEV0xxY3pJcEZURExtbDhhOHR5ZGVSdUIyZkNFdXBVUk1R?=
 =?utf-8?B?UEJBSG1NaVpiN1NXcjhmc0dYcVBBYWhRbUlBUWoydWYySHZmTHlLZklBbk83?=
 =?utf-8?B?RHBEYk1PM1RpWEhxYktnSnIzNzF4Ym9paXVrNHlja3lDeWJLbE54YjU5U2h1?=
 =?utf-8?B?SlkyU3ppZUI5eGYrTmRUblBwRk9NRFkrMnVONWR2bHU1Nmw5K01ZRnRqNjJV?=
 =?utf-8?B?UjFoTHBYNUlocGVrSUljODhGdWsrREtyL1RRQjFGUVk5VklyTVc0bW9QM0Vq?=
 =?utf-8?B?TG01ejlOc2JvcGlxZHU2c0lNOEt1dU93YW15aEtrNHFOTXhiU1Ywa2ZXUkxY?=
 =?utf-8?B?TThHTk9NelZiazF5WjFubkpKVDUwSGJ0amlFTXBuQ1FaUGQ0dkhvZUJkYU0z?=
 =?utf-8?B?TlAvdytqb3dtTS9BdGhGdGorSk05UitiZnVhcDhrT3pTeW5oWDFpTFVqMVgv?=
 =?utf-8?B?U0FlY0hGamVhbWFsSVhuVzl1Z2dEYVpQTTNBMTFDbTVFMDFoNk5xaWtRS3ZU?=
 =?utf-8?B?QjNucmFLTW1ZNjEwZ2JpSmdtS3FNNnBwK2dNcUJOa3gycUhyS0QrOWpXRXps?=
 =?utf-8?B?TzFLZktWL3NLcDErbkZEbENacG41Ykt2YXFkaGJUaHd6NHhKWHgzMVpnSjVq?=
 =?utf-8?B?RE1tNjJYMEZ2YmsxN0ZQT3ZFbHVMUWlrYm42Ny9ZR3pESkg3UE5qLzRaSVNy?=
 =?utf-8?B?ckpZN1VYL0hqc1VjUVdDL0lrekZpYmpBQWNVdWhEWE9RekYxaHlBR1dOTkNl?=
 =?utf-8?B?cTBZYmZXSklINjQwcDlyV294ZVBMMWlzTkhIVkpBNXpmYWEwNzNta29NYzZm?=
 =?utf-8?B?NHI2R0xsMC8yL3FzZStkNVVwa29mM1J1ME5qMVdtdVo2Yi9uNFgvOXEyQkRE?=
 =?utf-8?B?YXFCREsyM3dHRGhJdEdLZmhmRThPdmIwQzdlenZOVXdmMURwZlNVd2xOQkhT?=
 =?utf-8?B?NG9ncFBKc254VFc0bWxxR0thL3daM25BUldaeDhaRit5WHBVR3lNNE9sVUg1?=
 =?utf-8?B?WkI5UHJxSGZ3M2VGVXorVkEzc3FwWE9sTWxxejJhOFRFSU5vb0s5aXVXeDNw?=
 =?utf-8?B?dDJwdTVJNDZnQmxPdGJyLzAwejVHNVUxd05mNHZQaFlSaHFtRk14aXlqNnIx?=
 =?utf-8?B?RGw0SnJiY0g3UnpwWFJCUUE4U3ZDTXduYU4vQktFZ2tndUI0U2xDbHNIZ2Nh?=
 =?utf-8?B?Q1duYXlGMmthcUFlNk1UQmhYREVjd2lUOC8yc0hMaGk0MGpBVUxqbGM0OW50?=
 =?utf-8?B?TDRXWWVaV2x2SXZkUkNkSWRkRGRqZXRqeFdCV1B5OEozcW5NWGVzS0ZXaUdu?=
 =?utf-8?B?V1Q4Mlc1ZnAyVU1hU2xjelVvektiR2JJdGdHVm9SWksra2RPTkhEalMzVGU1?=
 =?utf-8?B?L2NRcEJSNW5LWFl0MDNUZ2JRVzlPVVZLL1FwQmNYTkdlcVNwYWlVZHU5MG5D?=
 =?utf-8?B?SEZINXY2YVVCSmJES2pqZHlEYjJadlp3R2dzWmtNb3JlSU42Lzh3MSsxazhn?=
 =?utf-8?B?d29OK1FYL3MxL1NiWGg2L3dsd1VDb3laR1RnOWZxSGtHZ2QzS3FPSVhhd0xl?=
 =?utf-8?B?MmNZUzgza2liM3B0MDFVMGNhMmxMYTB3S01VNlB3MUtRbnM4amV5UXdrTGU5?=
 =?utf-8?B?MUc4bEtDTDBEK2gvdk96MCtERVNpTW5mVFJaajFmT2h4ZTFXclpGNHIwWkUv?=
 =?utf-8?B?bnNhMEQ5cDN1Q2VtRWRWYVZCRHExZExKVUxnUHhDM2xTN2tta2JNU3JmZU90?=
 =?utf-8?B?QWdpazVCcTRsamhLTGE4NUFIOE9pbFJSbmREMTJ2WUlFdmo0SDgvczBtVXBh?=
 =?utf-8?B?ZG1wQWErNmIzbGFnY3dDK2o4c3ovdnorRkxOSHFNSzE3OTl4QlVDM2ZjR2s1?=
 =?utf-8?B?U2cwRjlUZURxR1pML2s0VytRbmxES1BBVHJtcXhJd1B4MVpma0R5RUIzRS9x?=
 =?utf-8?B?S3MxS2ZkQ3pkVDh0N2JWSkRLcFpGblEzWmtvOVZvTXBXMTMxdW55cFhZbE9i?=
 =?utf-8?B?Qm8vVkhXVGVPRHQ5amdmdUp3VTlTdGJzbWRidVZ1bk01NTNkQXNtVWhlR3hl?=
 =?utf-8?B?WUR5VDBYais4MTRBOFFmQnpxMTBBQnc4UFY5SHNsQzlUUmhtcmVDSDJBdXRC?=
 =?utf-8?B?bHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 411b31cb-3c6e-45a8-afd8-08de02d3f6ed
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 23:24:13.8786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s7jgIOqd2HHI6aJvW+uMlqCRTki4W/b5jtM4KwHFaFx4XLeDOyoeSenCKd44mHSPQ1W31QQ8CJrZqWLmDDvv9iPzlCiFH1NTH1Rr0LmDaZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5028
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/25 1:03 PM, Tony Luck wrote:
> The upcoming telemetry event monitoring are not tied to the L3
> resource and will have a new domain structures.
> 
> Rename the L3 resource specific domain data structures to include
> "l3_" in their names to avoid confusion between the different
> resource specific domain structures:
> rdt_mon_domain		-> rdt_l3_mon_domain
> rdt_hw_mon_domain	-> rdt_hw_l3_mon_domain
> 
> No functional change.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

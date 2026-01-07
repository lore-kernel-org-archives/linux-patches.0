Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296F73081AD
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 19:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767814414; cv=fail; b=IfrjL/QuT4alkCXt5vipJD8MFCQVk7PDgEZfyP21+R/CGSfvWSE+fMbnaU6rbE04WKiABQ8UZe1Cxk7DJiJWbm7sYjU8Z5A5Zkk7TbfHUH3MtjDtkNNhVlClEwvVAumm6VK/Ruwi0y41kBph4jKUjrN31G26tG2K3OStDNzUD8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767814414; c=relaxed/simple;
	bh=qMa6AYMgmsc/pvhr7xszYrIcctYAq7JO/gvfSrmSVGE=;
	h=Message-ID:Date:From:Subject:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HFMQJpAfAHIzJjXTW4ZI2Fsvykfee1GKrofdN5wwKzoyDgpU2rxi6oB+muvegWfPE8snMi+PZ7C2W+xYc6yEhBydblH5R/vBaJxrwDjOpQB3+hCxBk1SWYpF5RFEP0/ZPOLBW8qctwt5jVzH6+8JvEy67CA6E1Z0/1y3kWDK7KU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dQOiHG+Q; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dQOiHG+Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767814413; x=1799350413;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qMa6AYMgmsc/pvhr7xszYrIcctYAq7JO/gvfSrmSVGE=;
  b=dQOiHG+QMhRD3ogQrQ3PvoH2mbnrG6tQnSc9+nftZHRMIJf5cj5/V9ab
   g9yhePzEK1jmGfEhhehjq6K4Uj6hjHmhzP3vqqLccWgpUk6Au/epHBf9+
   9N9tvdPaVgVAHAtv7MK7tcNFvze+3y/VlYdBxxYWhfR/X07wTEA/zVIRx
   3IJ5SBmb042I5LPfGNI/etuVlbd1rHKT0aShzMJwQMx3iTKSFW2MHoVj5
   jKwHmEzqyrxoOYnHENVTUCZt1a8lgzPrIbRtorUpFCOzM6Drh9NRN2msl
   5OPHKS9PVOBHNlnB6VghdW/e76PTlRFAQnMVRRkQAdxIgVvsWTvQHAeot
   A==;
X-CSE-ConnectionGUID: KGWm9ouNQMqTxDc4yNQ/0Q==
X-CSE-MsgGUID: afGsPXkaQFaOJQMpRQrpJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="91850335"
X-IronPort-AV: E=Sophos;i="6.21,208,1763452800"; 
   d="scan'208";a="91850335"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 11:33:33 -0800
X-CSE-ConnectionGUID: pIWUqTVfSwmHvTHpvHPyEA==
X-CSE-MsgGUID: /UZ4QrbcRMWeFQmseUzpHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,208,1763452800"; 
   d="scan'208";a="226478308"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 11:33:32 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 11:33:31 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 7 Jan 2026 11:33:31 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.36) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 11:33:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d7gvlKlOKozyl8OEAmjfETyvuqJD/V76eYHkr//njrpK/DQYcskf48/RzGXoKbgXOJi8HtRqG6mkAnaMHy0rENfxw8CELWZwjaRH9e9qI81Yxj024EyOuv1oK9F9GqaKrHDHhYcIQ+gCUlE521sVpTY6vn/7GpXa3P9VfvHW+ZMLcIAMGn2d/4ZEJy2FvAtsvc+KrynXhsoNSPB5jTbPZoWzU6TXNYF552fcbjhooex6X6RW1xzJgJHaS7HQpvTxIwCCzz5xQHgTJrWdnHelP5N1qNEyLqXHI3XjbY1KmQ3Zo39rEp1f+8aooV3eXisG/3yI2BcjR1BNy8ZLVKV20A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sEU4QdWtOEMEeIgrd05NeYkQU51v4G+TdcIX1hJoJck=;
 b=RcJ0eoEq+IJQ025aZQ+gXEwAV2Iwfv/0Wyx2gskrK7DKYho8tpgB/i5QG+UTQFL8KC2Ljgzy33VTKpeIZ27oH1uQQUj79MfEHn8xyQsAeyjyUjfOhX8eIuH/QzYOzWNc1Mvy/92nXPErDeqNSjdk2EOlvk4v/yIC4FBIPAJqwqq6PvGp4KtDaVIw2Otpgz3dZlomjb6hVmkiO2EWkU6wfHKXeT3oyqb/Vp2FeAA3O1YmGd3KASoMa5jU09AAnsxj+Tdo8E/teEdP9LdrNCPrLZLRnn/y9Bv4UtUdG+ZpJZkTHIOSwOCi7l9HNl4FPHnH55pihcImET52wH0EFUytmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB5921.namprd11.prod.outlook.com (2603:10b6:806:22a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 19:33:28 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 19:33:28 +0000
Message-ID: <4525e857-c52a-4e5d-bd74-120f66a707e3@intel.com>
Date: Wed, 7 Jan 2026 11:33:26 -0800
User-Agent: Mozilla Thunderbird
From: Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH v17 13/32] x86,fs/resctrl: Add an architectural hook
 called for each mount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghuay@nvidia.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, "Chen, Yu C" <yu.c.chen@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20251217172121.12030-1-tony.luck@intel.com>
 <20251217172121.12030-14-tony.luck@intel.com>
 <20260105191711.GBaVwON5nZn-uO6Sqg@fat_crate.local>
 <aVwTcX7V_HN2j6SW@agluck-desk3>
 <20260105200435.GCaVwZU2gFV3LhJnMR@fat_crate.local>
 <SJ1PR11MB60837B0B18CA663282190AE8FC86A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <f3253bf3-6a3f-4cf4-b3fd-dc55e7bc71a9@intel.com>
 <aV6gU-lKrSjA2hDs@agluck-desk3>
Content-Language: en-US
In-Reply-To: <aV6gU-lKrSjA2hDs@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0307.namprd04.prod.outlook.com
 (2603:10b6:303:82::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB5921:EE_
X-MS-Office365-Filtering-Correlation-Id: a7d96b20-e4a5-4e30-b125-08de4e23a234
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TnVVekVJN0thUGV6ZmJJWU4wVWtaNTJkb2ZEOElTS0NMWkk0ZlMwOGlISTNz?=
 =?utf-8?B?QlNrRHFFMmZsbVpBOUIweE14dVl3T0NxVzlrQlZMdW1OWjRtcFdLcENzeTR6?=
 =?utf-8?B?MEhFaGo0Zi9nVFlHRUQrbVhLa2c2cllrQ0pnTi9kOW5tRjk1L1pweEExNTRP?=
 =?utf-8?B?SWphZDFtRUdEOWsrMVIzMUpLRWZDNTBoblBCZ2s4eTYxM2tXZmJiSm54ZUNv?=
 =?utf-8?B?QzNNckZxQW1RVmpYQk1jZFJJVGl4bmhJQlJEallmWlM1SEMrTURJNFZRNDFZ?=
 =?utf-8?B?R3NGMEZOK2twT3Q2V3RUNTE2eFduNVR2Q0xVMUt6RDJrL0Jkdll4MnBTdXdp?=
 =?utf-8?B?UlFmc2dDTTR5M05tUzRNb0dUZncyTzdUMDJid1MwOWcxK1BJeWk2QUpSYXpy?=
 =?utf-8?B?VGd4R1M4MElZRi9zT1lWK2FYTUZYU0E0bHk0aVZNbkVqeXZYYmxpNktwNlQx?=
 =?utf-8?B?Q09QOE4waktzbmdFdlVUVWtYeVlISy9DRTJJazQ5d1hsM2hrZVdKNWVOZEdW?=
 =?utf-8?B?STdhZHdUdkdBaFRpS3grYTZHeWVyODhxT05Yc2QvOERzbjd1UDlOL0lCM2RM?=
 =?utf-8?B?d2hqK0N3YVFpOE1qdndkRkdMSkx3N1NiRXg3NjZEby9OWlpjTE0vR3ZMSkhZ?=
 =?utf-8?B?bUM1SVU5eDdsNS9GN2gxSTRrWWZ2UVMxVFFvdzY1RXBib1owRjdSNXJLMkMy?=
 =?utf-8?B?UzdiU01wUXA3T3MzelZ6YWlSTHBkek90NGJNZzc2SzRmVFQybTlZQjFFZ3lZ?=
 =?utf-8?B?UGhtQ2ZRUENKaThPTnRYN3VMR0JWVmhHSVZOWm5kZ08rRUUyZ0FDcDBwaXJt?=
 =?utf-8?B?Y3YrZDllMEhPVEp1dWN4WG1IU005UjZHOFlpczNjOG1IY2N5TG1pcXZpTFhZ?=
 =?utf-8?B?SGJGQUQraG5OSFpjZG16SDJwaC8zTk1BVjRtQm43eFZ6NjFTaFB6MGN6ajZq?=
 =?utf-8?B?bW9GRmw2NEExdGxUYnVlQkl0VkUrTDVRWnB1L3FLRTAwbUJoT1pUUFN3Uloy?=
 =?utf-8?B?QTFadFlRZlJ0aHRQNHBkTFg1WjBZSmNoaTFodHZRMVlLa1VaTmxFUXZVdVVW?=
 =?utf-8?B?czZYbDlVQXV6cm5RRjdENWhKRFc1RmxZYTc0MWFKWnBoR1lsUURQZWNRYXFS?=
 =?utf-8?B?ODNKODBYaStydVRxMU5Ib1FJZmpnVXZnTkppVXFOZFJCVEFOblo4SGV3N3Zo?=
 =?utf-8?B?UVZDQzRGRzJDUVRodTZpY04zRUVxOHZBT2xPUkxBVFZmRzl5YWVMVFN5eVJ5?=
 =?utf-8?B?eXNiei9MTHdwNHgyLzdNMUp6WXlGK2x4Rkc2OUNQb3l1VW9GOTUxd0M1T1g1?=
 =?utf-8?B?RTNhWThYUEJ5M3ZFbys3RFZOb0l1ODJ3ZjM2b21UbkZmdDRLZWdmUTN6UXVL?=
 =?utf-8?B?VnR4V2JLR1Z6SDNQbmxzUitheTJqRjBrOURVN3JBSDMzS2FuenFURGtXTmFV?=
 =?utf-8?B?bUFjTWhEdWN3NmJhdmdNNVk0ckZFc2RKUENwWmpEenJXYlczZllwTEQzblhF?=
 =?utf-8?B?UXVmWDBVU05nbksydElzd3A4aGNIQSs2TDRaKzJFMkRjVzNoNnMzZkQ5aVRT?=
 =?utf-8?B?Z0tUenYvd0JOcCtlZEREMmw0SU0zb2tORU42MzNMTlNoU2JaSnlUQm5udytw?=
 =?utf-8?B?SlJIMkNJc3BSMWdVRXFad2pvSWIrV0wzSUJhWWhSdTZaZVpQRExUcnJQbDQ4?=
 =?utf-8?B?UnFmSE9YZnR0aEZ3QW9JZEZHYzVJZzVXUFR0c2piRFJCeTR1NjNWM0hhSW9q?=
 =?utf-8?B?UGtVRHZyNUV3UWRLOHd6S0Zwc3BLRHoxc3REOS9ZbkZoRXZramhLL0d1eHZC?=
 =?utf-8?B?Qzk0c0NybGIyZDFFeHR1emxQdmtBMzhubWJnSHV2MHdNejV6WURINERTR3V2?=
 =?utf-8?B?VGZ6aUNvaWhTR1N2TGZsajRKK2haZjZqRm9DNWVwWjVBS3lLZXFQaU9kWjBJ?=
 =?utf-8?Q?u1g+/g/w945IrVIfJaA2NKL5MxEiUdo+?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXA3TWp0WDdDVWtQOGpldXY2WkIxOS9TNFp1NEQraEkvT0MwNjVWbFNHYWx6?=
 =?utf-8?B?RjhzanVJbEJ3V1NFT2ZNVVArZ0RoTTg3QXk0cFVuaUc1VERVSmN4WFBjSU1W?=
 =?utf-8?B?L215em9yRisxeTJEUi9weXUrRnpVc20ySURyT0t6TmlrNDBpY3FpY3RrUFZ6?=
 =?utf-8?B?RE84R3VHeiswSm1kaVFBTVRQZlBlMUw3TS93MkNRa1ZtbEs1T255M21MN0Zm?=
 =?utf-8?B?bHBWazROOFJNdFBmZENVTDljTEsxbmMxT3BWMU5nbUtwMWJ6dW5yRndTNUJH?=
 =?utf-8?B?RjI1MVVZRVRweVpVdVZkd0g3K29zYmtpUlA5TFNKOUxCTkVhZmVBNmFyYTZO?=
 =?utf-8?B?RGswT283UVJCWm4zM2UxQVoyWnl0ck5zMW9RbHFJWkNldURaalpseG9pdGJ1?=
 =?utf-8?B?Q0djaXBxcEtwdmdvdWpCdThJOEphUURpdlhzc0U3TU9IWXdOMzFXUnF2cXU2?=
 =?utf-8?B?MFBQTW9NUlJ1M2c2NnBNd25Lb2g5SUx0VXlEMC9zQWs0N3VsaWQ4dWpQTUZJ?=
 =?utf-8?B?ZUFKL0MrREd5R3N4Z1BBU3VzRlFwNGkzbzI1azB5TlA2RkFvT2tJMy82NVhs?=
 =?utf-8?B?eVhuSDNvcjZNSU0rNXgweDN4QmVIMVpVd3NLWUhKZ1h2Uk1YNVFremlBZWxn?=
 =?utf-8?B?QnYxVkZkNTNuWWx5YUduRFY3K2NIQllXOW9CNE50U0FUNk1QOTAyVXJmcjg0?=
 =?utf-8?B?eVlzVi9NTFl3UzdLRnVRN0NNbDBUQnNDV2MvcS8yYUJwYW9oeVBBWUJyTm42?=
 =?utf-8?B?eGxsellTb1lUTVZYWUpkVWwwS2RHbjEyZ0dyMzByZHRQbkdnSm5hNlNYQVVv?=
 =?utf-8?B?cUVLemRqY2JrblhlNGo0b1J1Y0VyczRQcHh0d1lSL1hHQzJEQnRFVGhBMHhm?=
 =?utf-8?B?YXNXaGI2SW1zQTRpQkozVEtwc2JjMW1ORmlKaVhkYTZvUm9TU3pBc09INGc5?=
 =?utf-8?B?VndlNXdkTUgvMjN4ZXpGcHBOa1VEVnFTV0NqSE91Nm9aTDBzblNEK2p0SmZw?=
 =?utf-8?B?a3RhQU5mcDZTQW56NFFVelRRT2FhaW1vVkNjazl5UDIzSVQxdjRsMWZRZzdl?=
 =?utf-8?B?TUxVOURiTGxIUjZsSEkwT0RCL3FVNTBIZGJlaUNzaFFQajUyYW1ITGRKbGNa?=
 =?utf-8?B?ODVUQ0YzbFEvNlZHN3g3VjRnUFZMR1cyMGlNUFI4UEgwTFJvdU1CY2tKVGF2?=
 =?utf-8?B?YXV4TVF6VmdTYU1wSDYybjlaMWNjdU9SU2pRdG5QTzRiM1RTSzllNmlXYUI0?=
 =?utf-8?B?VlE0UERjNXd4Mmg2WU9mbGZ4Q0dFdmJpZkRpd0dpa1V4ZCswRjJ4bVhEWkFT?=
 =?utf-8?B?VXhlbmt6QW03bTF6Wm1qd3ZFcmZoUDNXL1E2RE1uZ2MrOEFpTGZPNXJqa0tl?=
 =?utf-8?B?bTRmV1c4NTIrSGw0ZUxWUmpDT3hjb0NQYW16NC92REdjYjZQMnZWUVlJQTFO?=
 =?utf-8?B?M2xEL0NjQzI2c00ydEgvOFRSQlBUeUFqLzJQQmFvMStqc0dCYlF0VDdVdWMw?=
 =?utf-8?B?NGh1RFViZmVrRkE4dHhrRlAxN3hYM2JVTEVzdjBVWFVTNW9WMFh5eXg1aVBX?=
 =?utf-8?B?a253ZjBlRjNpaVdCcFhia2t0ZW5tN0xhbXdFNXVKVlVZeVZrSG94SU13T3lU?=
 =?utf-8?B?eHN5bmxndVp3SyttSEtjNDVVQmc2YUwwQTd0YkNCVE5oMVlRTDdiODJCaHRO?=
 =?utf-8?B?Q2FibEh5V1RUem1rTWlhcUFYTEtnK0loZG1PREx3NzY4S1pmRWN4TXgrVWV0?=
 =?utf-8?B?b1JxQno3UUVXOXpRMmxGTmIwWldSdUFWanVJN2VGaTBLT1FuL0pKMFFoYVJS?=
 =?utf-8?B?L3ZxUk5BUHpFcnhhWloxUThxVVZaK3RURXQyemI3M0wzVFJXWGN1NG1mMFdl?=
 =?utf-8?B?MmNVUnZmci8rem1ZOG83M1hMYWJ6Sm53SmY4aWphTlg0SnZnbXp6NzF1ZGVV?=
 =?utf-8?B?NlpSbkdFVDhuaU1SYUNJUFNsS1UycXdwUmxjUU9TajBrTmhVOGp4cm1uYUYx?=
 =?utf-8?B?b0FvbTdOZys1VkNzczE0VGJPNTFrWmtLUVNVRllKV0Jwb0pUaS9xTXdKUmdK?=
 =?utf-8?B?c2I3YktYYnQ2MjliTmRka000eWZIcHNDSGVSaUpKWWQwc0VmQkhKeUI3N2pt?=
 =?utf-8?B?ZFlnVjE1SE1ha2ZOTXFwMm9DK1QvcWxTTlI4U3o2NU1MSWFuZWZTcUpWdEFJ?=
 =?utf-8?B?TUJNR0pWV0xsaGpmdFJvTlp2ajYvczdSaXJ1Y212QUZVaUcrbS9UTDljbTcy?=
 =?utf-8?B?VVIzY3Y0UUMxT0NtejRPUlIraWIyZHU1VnUvcHZDejNJYVJnaExNVE00YkY4?=
 =?utf-8?B?MXV1QVhxOGZ1ak1iOHNMNzIzaHRkNFZaU2VHclZqNXVrOEtmMXdoK2ZjQWo2?=
 =?utf-8?Q?pSvpEVe9Wu6DS8eM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a7d96b20-e4a5-4e30-b125-08de4e23a234
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 19:33:28.7664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8KHSjMB3GyzXQzLuCOsGi7X7NxYU5+OE05CdY+f6hEWaCaUrOPXlFvf2py4qQbLmRvrXJjXeT+eCr8TmEPkbL7fRmhrl6vta6+gct1yOYfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5921
X-OriginatorOrg: intel.com

Hi Tony,

On 1/7/26 10:05 AM, Luck, Tony wrote:
> On Wed, Jan 07, 2026 at 09:29:27AM -0800, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 1/5/26 12:15 PM, Luck, Tony wrote:
>>>> Ok, if it works and passes testing, I could wait for you to send me an updated
>>>> patch and drop this one.
>>>
>>> Building and testing now.
>>>
>>> Reinette: When originally developing this you suggested that rdt_get_tree()
>>> should call resctrl_arch_pre_mount() on *every* mount (to make it generally
>>> useful should future changes need something to be done in architecture code
>>> on each mount).
>>
>> I'm digging through the history just to refresh on why I made that comment. From what I can
>> tell this work always called the AET init on every mount attempt. One difference is that during
>> v2 it did so by taking some extra locks before doing so, but still did the AET init before
>> resctrl's "resctrl_mounted" check. The move to current spot (before extra locks) was made in v3,
>> and looking at v2 comments I could just find a request to use a generic resctrl_arch_* helper in
>> fs code instead of the arch specific rdt_get_intel_aet_mount() called from fs code.
> 
> I should stop relying on my memory and check the actual history. You are
> right. The call from rdt_get_tree() has moved, and changed name, but all
> versions called it every time.
> 
>>>
>>> That flexibility isn't needed for enumerating telemetry events. Boris' suggestion
>>> to use DO_ONCE_SLEEPABLE() would revert to what I had in some earlier
>>> version where rdt_get_tree() only calls this hook on first mount.
>>
>> I think I am missing something here - even the original RFC calls the AET init on
>> every mount. Which version are you referring to? I am also missing why DO_ONCE_SLEEPABLE()
>> requires a flow change.
>>
>>>
>>> Are you OK with this? Or do you still think that the hook should be called on
>>> every mount?
>>
>> To be specific, the current implementation calls the resctrl_arch_pre_mount() hook on
>> every mount *attempt*. For the hook to be called on every mount it should be after the
>> resctrl_mounted check. This would change resctrl_arch_pre_mount() to be called with
>> rdtgroup_mutex held though but that seems trouble since resctrl_arch_pre_mount() currently
>> follows lock ordering of domain_list_lock then rdtgroup_mutex to match lock ordering
>> during resctrl init.
> 
> Yes, the call was moved before any locks obtained because of lock
> ordering issues with domain_list_lock.
> 
> A better summary of the change is that the "only once" logic is being
> moved from open-coded using atomic operations in resctrl_arch_pre_mount()
> to using DO_ONCE_SLEEPABLE() in rdt_get_tree().

One thing about DO_ONCE_SLEEPABLE() that is unexpected to me is that it disables the static
key in a workqueue that seems unnecessary. Original motivation for the workqueue on which DO_ONCE()
is based (per commit a48e42920ff3 ("net: introduce new macro net_get_random_once")) was to support
calling code from atomic sections. Looks like DO_ONCE_SLEEPABLE() copied this implementation. It switched
the spinlock to mutex but the changelog (62c07983bef9 ("once: add DO_ONCE_SLOW() for sleepable contexts")) does
not mention revisiting the workqueue. Looks like deferring it to workqueue does make it easier to not have
to worry whether helper is called with hotplug lock held or not though.

Do you see any issue with deferring the disable of the static key in the resctrl usage? Since
resctrl_arch_pre_mount() is called without any locks in resctrl control it now relies on fs code
to not have rdt_get_tree() called concurrently and thus risk resctrl_arch_pre_mount() called before
static key is disabled? I just want to make sure here since from what I can tell this makes resctrl the
first user of this helper apart from code for which this helper was created and there may be implicit
assumptions that resctrl does not adhere to.

Reinette

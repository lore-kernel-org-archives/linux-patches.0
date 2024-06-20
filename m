Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8022942AA0
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718918397; cv=fail; b=bB4MRnW1DuwPjZjEyjcEnjNxKLg86pptV19NUhLVuV7dxDmi9qpKNVVQ9+ZTiMwg77RYkwXRqQ2wbNo1jnv6Wko8tyoWJfwfr9/SyNbvCwNF29YwD37R4PzNnVFWDOcLpDIO4LpKyFIpwiBFPllS4IjxOM6ukVOEkDdYzKZsJNs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718918397; c=relaxed/simple;
	bh=rYKx6R1Ii3k4jhyQF4ABfvWbVnwlviGDm/zv5hqAAP4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ae1sjifLuGcx8hcwFrR0AyS78eBVTuhc/DRphAgVpUN4WxJW4aF4cIyfyI3GAAb7SZJJRXOEF8N5t9cxJhnqjX6Ayd/ybyXCunHaH95JC+ZvM1377mHinmQib9AIDFg9rWSKXtK+cwYMNRySywmPmKM5YllWO3QYwEG4am3opEE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ispxu9fc; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ispxu9fc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718918396; x=1750454396;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rYKx6R1Ii3k4jhyQF4ABfvWbVnwlviGDm/zv5hqAAP4=;
  b=ispxu9fcSRvSLGQ/IYGwpk3tNr5lf21heDgGyNpeMP2d6OspGwjTkLBW
   OJ/bfiZMnnOZM761YrPScS/tMnlaXeR9hcRja235BCE7+EGjCZa6n6EDz
   u6Y2UXy1MnSD4UVLbpaEuhrImu0jOY9RreT0lzH32AuaRtvm49DfXxDB7
   dLzeSCANAmQte+MdsrF8JpcC8BzvkEUol/TPsgRNHUTJsmyJ3ofVn+78F
   HFANBlgJ/etdnfRTHk6mpqdPxDRDYKgF1rZRXZPUx/6daB4skbCakGwMx
   7ipc/qxIHS4sWl+EhQUspdHSt7JAgMD9UhTxfIp9FkwF8JtebogOKNecg
   w==;
X-CSE-ConnectionGUID: obrUfYCZSTmKRcI0YirRzQ==
X-CSE-MsgGUID: +c6ZUvSjR4iUw4wsmSeuAQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="16043936"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="16043936"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 14:19:56 -0700
X-CSE-ConnectionGUID: k8FDVwfzScSRPHkQq7kFDA==
X-CSE-MsgGUID: paDjQ4TJTPqPYedRsSLcMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="43056443"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 14:19:55 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:19:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:19:54 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 14:19:54 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 14:19:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h71REtqRDcWsjkfgjUa32zG381WhewfuQMyqY6WX+PBTCU/KrPlu8eHbRjVyI6pdsYO+XYV0XHz31mB7JdMW5vqjDgg8pMpfeGdKoli4HnUHoPFV+3BWSnzsgnzqTnG5AMrg1tZJ/BYpwjTfauiienGl4+g7JISpWqiWDjhivXHOZ9GiUURd+lQutdq2hsMv2XTCAU2Z6rzMQMM9lAHlGBN/4kzTrHS+VYW3cZNcfUfPWjaMKnR6TXP3T2BPVvN8XVnwo3QlOtB9U8QbO8vcWCLcJd3AuSg2MVVHl+euBcvHNjb6eM2eZhSVU9xFLzMrgTkRH5OW6KunuScx55qKtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IfYjuWZpSEGKAT0njhJn1e2Hu+kdtgIt4EqS4oNZ89w=;
 b=PgMWAiLVk2GAe9PONtujOXbCSrvpznBd9c/xQAhrSd4WTjF5OdfqReAz5umcExaJUcFUorimBl7W1UL9HyTPb6mwRvzEeBwMAm6vPEsvK1CJ1UcUENzLwXDA0XnS4UnG//xC319Xl8pPN9KioE+qy4lkcJLT1/Z7EQWv5fwhSEKm7odljKiuRH1oAeoke3XdGe1BBnlY+e5bpeY2EWNE3jOQAlCzHAPASGQll2c94DJs+bh4ECTjb0/fsBPK/kEFL0OTR7H8bdY7TyWcHJdO3tN4434zOnxRzYBLeS65OOldtCTz/SneT3kjehO0SrVWyLQvh0lz3x7YJysTCSG+pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB7924.namprd11.prod.outlook.com (2603:10b6:930:7a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Thu, 20 Jun
 2024 21:19:50 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 21:19:49 +0000
Message-ID: <d261c249-177f-44a5-9715-26ec647b1ae8@intel.com>
Date: Thu, 20 Jun 2024 14:19:46 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 06/18] x86/resctrl: Introduce snc_nodes_per_l3_cache
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-7-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240610183528.349198-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0025.namprd03.prod.outlook.com
 (2603:10b6:303:8f::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB7924:EE_
X-MS-Office365-Filtering-Correlation-Id: d41de05c-8adc-48cc-d0cd-08dc916eb7c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|366013|376011;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dUFyblhMSlhSNkZzV2xjZ2g3Mmpyb01YVFM3UjM5V3ZUL1R1SU5BQm1GVW1s?=
 =?utf-8?B?eGVHQWlSUlYvTWFzaTVOOGZPTm53cTFQKytTeUtLOTdVN1lxUHRwNVA4dWJi?=
 =?utf-8?B?QjdPRG1yMU81ZksyRC8zbkhmb2xwbjlpMUtnLzN0RDNrazJacW5GRGpOSGt2?=
 =?utf-8?B?bGp0TkdxUmFTeEN1SVV2UkZnOVdQUFpNeUw0NDQranhOclBPV2hNNzEvSGtm?=
 =?utf-8?B?MlB4VnJDQUFjbHVsZU9sTjZ3U1h6U0RRTFVxOEZvdFFUQWZ4UUtzOEpFc1pa?=
 =?utf-8?B?eHVlcnltc0I3QXdpczZiaFVLN29KellXTzBycUVSWThvcTh0SEVwZUpkdlI4?=
 =?utf-8?B?ZVdFeVVNYzNzUFdkMGpnUzdXYzJhTXNmRmRVRnpQWXh2RUtyTmh3MXJmYlcz?=
 =?utf-8?B?KzJDNXQ2aGVMdGZlWU1BWDJ6TGZEbGpIdVBaVkxCaklSRFNrWXV1bHBOMnVy?=
 =?utf-8?B?bmFlTmlDT2pIZEJYclRCaGkyUDd6M3k3NWlQb0p4bERkUkxnS2M3OWhxVHBq?=
 =?utf-8?B?K0ZEalk0NTIxOURBM1o4NE1tS09PTjhRY2JIa2JwaGQ4WEozNVJEeDJ1VjJw?=
 =?utf-8?B?MW4vY1RFTDZBR0xoTFVSQ28yVnN1OUtBUVNORHRHRHl1SHprYmxrWFJNRC82?=
 =?utf-8?B?Ymc2TGMvampzOENiWGFUNU9UVWRLc3NHYWNkdXZOWC85ZTc3bVNhTHhGSklM?=
 =?utf-8?B?NnV0UEZKRHRmWnA4S0NWRmtRYUpsaGtERkU2RlVWY2pZUTFqdkwrdDBwT3V4?=
 =?utf-8?B?dWkvd0k5SmcrazBWMk9Rd0hQeGhqdmpLU1RhK2dBQ1VJZ013ZHZhejk3V2dS?=
 =?utf-8?B?VjRlcmtxTWczNTI2N1h5RWE4b0FBSjZnOHIrTFVVNHBmYzg3Z2xGTlhiRDFR?=
 =?utf-8?B?YUsyQ2FkeTVjS1dZcFpsd3cwcHgwcnRxSnhodEFwNk1sSmJ6cDZDcWRvV0tQ?=
 =?utf-8?B?czdmTjNvT3Z4cE13cktLeTZYdjQ5WnliZHdNNkY1UDhSa3Vzd3BFSkdsRWhr?=
 =?utf-8?B?TnJ2aEZaWGRPeDNUdUVOWG83cnN0MjdUWXV6WHdzVzZFVGE0M0dvbEpyZEJO?=
 =?utf-8?B?VTI3ZWVWeWpCeEpDU2pIMjhHR01HNXErbTNyMzA2ci8rcWpVOWtJREErZ1Q3?=
 =?utf-8?B?dWtWTnJET1NtV0hJSFdJUkNDY0wwR0p1eE1wcUtPOHgyTHZ4N0xOU2hhbjdr?=
 =?utf-8?B?SklwNjNkU3ZZRlYvYk1FS3dtRC9Bcnd5Y08wa0ZjTE9ob1NESGcybm5YM1ND?=
 =?utf-8?B?aDU3Q2FUOE5HTUZBTVIrWmFJdmd1NkhpOVB4TFNvNVcrUnVCQTN3NWkrTzBl?=
 =?utf-8?B?Tk15V09qQy9LNUkxZFgybjdnTnNOYjlVUjJYbmhtTGI3enAyeWdrRGpxM3Bm?=
 =?utf-8?B?ejFIWFB0QlBUUjZadUFERStMUWtaYXI2RVlxaUs0UmNOemFONDlDTEtweEVa?=
 =?utf-8?B?cEJ0L0JyMVN2ZFVvOElaVU44MkhadS9DWWxyS3lra0NISzdPZkFPL21kNmtH?=
 =?utf-8?B?cVVSbWJydFdFSEZDTFdIWEg1M1ZVeG4rWEQwTUd1dEhzTmlWdUwrWEhvajRR?=
 =?utf-8?B?SjJUQlQrQm44U3l4VUQvVnM2c1RnNW5Ic0V3eDhCUXQyaFZWVkRHcU91YW9m?=
 =?utf-8?B?aXhkRWQyRnh4MlNEb3V0bUJ6NTJHa1J3bTRiUTlmckpORFUvMGd2RGRSMDJK?=
 =?utf-8?B?bnlLaU9YQ1JVUzM0Y2xhK29VSnlvYitiQW53QVFKTGNkeTlCVEVNQlN5UlV4?=
 =?utf-8?Q?zeIADUA8C5HlyofmrqyEGJG90szw+jZLY97mV7W?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REZ2VGNPMC9reUZwZ1ZvMjNteVVsM2ZVQjlLM29kdHZETHFMRjRaWFQ1VnN1?=
 =?utf-8?B?TFp4bmNGTkxVbkt2K0FwaVRtcTIyaUxlQXNrNlRWR1FsbDYrZ1N4YWY1c2Vj?=
 =?utf-8?B?M0ViNFlYeWQ0aGwvOWpTOGprbFRpYzhDWXAxWUtweStUNVZmK0RPYW1DdE9I?=
 =?utf-8?B?ZXVrRnJ4SzFzb0hlOExGY0tGcEhBL1hXRVk2Z1VCRjk5SktleEVXSE1zUEtr?=
 =?utf-8?B?aDZlRElyQkxZNDlndkdSWDZ6NkhZcmZETk9meFFUV2p2T0RUV3IrclVZckF1?=
 =?utf-8?B?L2RneGFJMWVIZ0c5UU53Si9EbEs0U2hHeEZyT0JPTGpBUzNwdVhzTXRZMzVm?=
 =?utf-8?B?RUdKLzg1MmczT2FvdTBHTGlvSFd3UEhvMXQ2TXh1Ri96eTcyOXVkRHA1SVI3?=
 =?utf-8?B?NkZ2NG1ESXhwWVJwak1HSlVSREVJVCtuSHJDTkdxRStOL0JLNmNPRE9LUDls?=
 =?utf-8?B?UXhFKzdtejJIUWl5YUFobEZpMnI4T0d5ZXY3WXdIUktBVzNlelBWd1FzQ1Vw?=
 =?utf-8?B?dk0yUXgwRWpiV3E5MFZOZEdja3l4YWZqdUlvTktLV0FMUEFNWU8xVE1Eb1dz?=
 =?utf-8?B?UjBaUUdmWHhzMDdINmJaY2ZzQmNlMWZZL1hsSjYyKzl6bzRJaHhWVHk5bWlC?=
 =?utf-8?B?dnJQMlgyWkVLTXN4Wm1KQUFqaXdtRkVXN1RoejBvMW9oWHpFTjlZODFaVTZI?=
 =?utf-8?B?ZG1DekgxTlV4dENBcEs4VEhaWE9ieWhEdXdSUFNMSW92bDU2V2Q3czRxbnk1?=
 =?utf-8?B?UENGeXRsZCsyTUxnMDBVWmpxUUZXMUF5Z1pNbGFpbDdUOHg3MElYbXhzeTZH?=
 =?utf-8?B?SmRmY2pOcHNOYllPcWxReEs0SlpyUlM0MzNkT1JWUTBpam1XSG5nRjU0NkQy?=
 =?utf-8?B?Unp2NXpFZklRT21oRFhKK2g5dk1UQkJFanIzSHpVbDM5QXlCTXY1cUtEM2x3?=
 =?utf-8?B?ZFdHaHUrYytpallqd3RSNjZBdHRIRXFkSTRHVTB2QjFLVTJYSCsvdmNCWmVF?=
 =?utf-8?B?cVIzcTcwbDY4dEJYcGNGRGhxNWtNQjZOVURqTGh5TmhGWHNpUkdHbEoxN2VQ?=
 =?utf-8?B?Q293b2R2eXJhby95b3BkWmphbjI2MzgzdWRMZmNTLyt1ZWJLN2dwQU9qTitX?=
 =?utf-8?B?RFU0cWp3ODZNVFJZV3E1bnlsVy82UmVZSTN5dU02U3BsdUxHYUhOWVF5VWk0?=
 =?utf-8?B?NWxaQkE4YktMRnI2c2xpK2NRakpVRlRRNUZHVjBWbTZFdHpNWW5CVldLVWxC?=
 =?utf-8?B?azM1Z3VzbmN4VHlicVhZc2ZUVUs1SnB3ZFYvUDdGc0tJakpwWlVOQjcyTTBx?=
 =?utf-8?B?V1NMRzJkQ2xHZktRVnQzOGYwOUovNngvMjJyZGJ4WnpuOTZ5VUgzUzViV0Za?=
 =?utf-8?B?L1lDa2xub1lKT0s4KzR4UlljNlB2akdwVnk5Y3N3ay82NnYyS3ovTXBxSUNx?=
 =?utf-8?B?ejhiSWxvQXo4ZWNSMDdFVmd6QUxJZzNKVTYxTXNFSHNpMEFSRmY4S2pyMHBx?=
 =?utf-8?B?UllRd2ZhbGhCRFFmTGhycXE0SWZ4QVBSb0hPMDlDRFRvcDRjbnhoWWVuZERT?=
 =?utf-8?B?UWs2RDF5bG1tQ0h5WllTQUpyTVVDUEZvVGdnSzZYUVVabDlRdEFCK0VGcXRk?=
 =?utf-8?B?WUtiSERQMmRLQ05yNnlEWnZtMEcyNmNVQ3hnNjBTYTVOdGVJS044bHhGQXBK?=
 =?utf-8?B?NnowMjg0ZjZqWlRqZDBNNzVOZXlmVURQK2txcXhNbTV2dTAwUkJLRldGQkZD?=
 =?utf-8?B?bmowVTdFRGsxNXlVbERKRU1xSFZibUhjTXNKRCt4MWtIcENZWlJSMUZFSHp0?=
 =?utf-8?B?RmtvN04xcXd1NnVXbWh5UXFWTEV1T0krdWpybDk1QXpIcUxZWHllRmo2SG5N?=
 =?utf-8?B?UE5KcWlHaXQwM1I2ZUJWcU94bzJRb1NoQkgzMnhPTm5LUFI2T2dRK3NiSFN4?=
 =?utf-8?B?Nkp5UDBSOWo0dlZDSCt0S0JZRUQrMlV2eFJtbVRVWjJEK2tyRzQ0QTcwbTZJ?=
 =?utf-8?B?UWd5Situd3VoQ2JSbmhwa2ZUakNRbWtxTTJ1d1dKM2grNTA0MkFGOUdrVDhP?=
 =?utf-8?B?TEg4eWdvL2pKeWtwNHE0ekxiTmpVcjRIQ0FYMWRIaHFhZmUvaFZwNEhxMU1Z?=
 =?utf-8?B?Ri81S29nWURhY0FTSjZyeFFjOW9VMXBvN2JQUGE5V3dpNjVwK0owMXNHOEs4?=
 =?utf-8?B?cmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d41de05c-8adc-48cc-d0cd-08dc916eb7c5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 21:19:49.6706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eyunviu/x6CSGVFmy3asgAu5kg2UnSMi/O43FHXPBviHaCy1J39bFm00NfSJkLrJb3HyLMGh6VSM/qUAdbjluR/C50r0h0ld4EppRIQbg/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7924
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/24 11:35 AM, Tony Luck wrote:
> Intel Sub-NUMA Cluster (SNC) is a feature that subdivides the CPU cores
> and memory controllers on a socket into two or more groups. These are
> presented to the operating system as NUMA nodes.
> 
> This may enable some workloads to have slightly lower latency to memory
> as the memory controller(s) in an SNC node are electrically closer to the
> CPU cores on that SNC node. This cost may be offset by lower bandwidth
> since the memory accesses for each core can only be interleaved between
> the memory controllers on the same SNC node.
> 
> Resctrl monitoring on an Intel system depends upon attaching RMIDs to tasks
> to track L3 cache occupancy and memory bandwidth. There is an MSR that
> controls how the RMIDs are shared between SNC nodes.
> 
> The default mode divides them numerically. E.g. when there are two SNC
> nodes on a socket the lower number half of the RMIDs are given to the
> first node, the remainder to the second node. This would be difficult
> to use with the Linux resctrl interface as specific RMID values assigned
> to resctrl groups are not visible to users.
> 
> RMID sharing mode divides the physical RMIDs evenly between SNC nodes
> but uses a logical RMID in the IA32_PQR_ASSOC MSR. For example a system
> with 200 physical RMIDs (as enumerated by CPUID leaf 0xF) that has two
> SNC nodes per L3 cache instance would have 100 logical RMIDs available
> for Linux to use. A task running on SNC node 0 with RMID 5 would
> accumulate LLC occupancy and MBM bandwidth data in physical RMID 5.
> Another task using RMID 5, but running on SNC node 1 would accumulate
> data in physical RMID 105.
> 
> Even with this renumbering SNC mode requires several changes in resctrl
> behavior for correct operation.
> 
> Add a static global to arch/x86/kernel/cpu/resctrl/monitor.c to indicate
> how many SNC domains share an L3 cache instance.  Initialize this to
> "1". Runtime detection of SNC mode will adjust this value.
> 
> Update all places to take appropriate action when SNC mode is enabled:
> 1) The number of logical RMIDs per L3 cache available for use is the
>     number of physical RMIDs divided by the number of SNC nodes.
> 2) Likewise the "mon_scale" value must be divided by the number of SNC
>     nodes.
> 3) Add a function to convert from logical RMID values (assigned to
>     tasks and loaded into the IA32_PQR_ASSOC MSR on context switch)
>     to physical RMID values to load into IA32_QM_EVTSEL MSR when
>     reading counters on each SNC node.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/monitor.c | 56 ++++++++++++++++++++++++---
>   1 file changed, 50 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 89d7e6fcbaa1..f2fd35d294f2 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -97,6 +97,8 @@ unsigned int resctrl_rmid_realloc_limit;
>   
>   #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
>   
> +static int snc_nodes_per_l3_cache = 1;
> +
>   /*
>    * The correction factor table is documented in Documentation/arch/x86/resctrl.rst.
>    * If rmid > rmid threshold, MBM total and local values should be multiplied
> @@ -185,7 +187,43 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
>   	return entry;
>   }
>   
> -static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
> +/*
> + * When Sub-NUMA Cluster (SNC) mode is not enabled (as indicated by
> + * "snc_nodes_per_l3_cache  == 1") no translation of the RMID value is

(nit: same unnecessary space as in code)

> + * needed. The physical RMID is the same as the logical RMID.
> + *
> + * On a platform with SNC mode enabled, Linux enables RMID sharing mode
> + * via MSR 0xCA0 (see the "RMID Sharing Mode" section in the "Intel
> + * Resource Director Technology Architecture Specification" for a full
> + * description of RMID sharing mode).
> + *
> + * In RMID sharing mode there are fewer "logical RMID" values available
> + * to accumulate data ("physical RMIDs" are divided evenly between SNC
> + * nodes that share an L3 cache). Linux creates an rdt_mon_domain for
> + * each SNC node.
> + *
> + * The value loaded into IA32_PQR_ASSOC is the "logical RMID".
> + *
> + * Data is collected independently on each SNC node and can be retrieved
> + * using the "physical RMID" value computed by this function and loaded
> + * into IA32_QM_EVTSEL. @cpu can be any CPU in the SNC node.
> + *
> + * The scope of the IA32_QM_EVTSEL and IA32_QM_CTR MSRs is at the L3
> + * cache.  So a "physical RMID" may be read from any CPU that shares
> + * the L3 cache with the desired SNC node, not just from a CPU in
> + * the specific SNC node.
> + */
> +static int logical_rmid_to_physical_rmid(int cpu, int lrmid)

It is not clear to me where we are in the discussion about the naming. If
the "logical" vs "physical" becomes an issue then perhaps the "logical" can
just be dropped? Resulting in just "rmid_to_phys_rmid()" (to match with
__rmid_read_phys()) ? I'm ok with what you have here also.

> +{
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> +
> +	if (snc_nodes_per_l3_cache  == 1)

(nit: extra space here)

> +		return lrmid;
> +
> +	return lrmid + (cpu_to_node(cpu) % snc_nodes_per_l3_cache) * r->num_rmid;
> +}
> +
> +static int __rmid_read_phys(u32 prmid, enum resctrl_event_id eventid, u64 *val)
>   {
>   	u64 msr_val;
>   
> @@ -197,7 +235,7 @@ static int __rmid_read(u32 rmid, enum resctrl_event_id eventid, u64 *val)
>   	 * IA32_QM_CTR.Error (bit 63) and IA32_QM_CTR.Unavailable (bit 62)
>   	 * are error bits.
>   	 */
> -	wrmsr(MSR_IA32_QM_EVTSEL, eventid, rmid);
> +	wrmsr(MSR_IA32_QM_EVTSEL, eventid, prmid);
>   	rdmsrl(MSR_IA32_QM_CTR, msr_val);
>   
>   	if (msr_val & RMID_VAL_ERROR)
> @@ -233,14 +271,17 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
>   			     enum resctrl_event_id eventid)
>   {
>   	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
> +	int cpu = cpumask_any(&d->hdr.cpu_mask);
>   	struct arch_mbm_state *am;
> +	u32 prmid;
>   
>   	am = get_arch_mbm_state(hw_dom, rmid, eventid);
>   	if (am) {
>   		memset(am, 0, sizeof(*am));
>   
> +		prmid = logical_rmid_to_physical_rmid(cpu, rmid);
>   		/* Record any initial, non-zero count value. */
> -		__rmid_read(rmid, eventid, &am->prev_msr);
> +		__rmid_read_phys(prmid, eventid, &am->prev_msr);
>   	}
>   }
>   
> @@ -275,8 +316,10 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
>   {
>   	struct rdt_hw_mon_domain *hw_dom = resctrl_to_arch_mon_dom(d);
>   	struct rdt_hw_resource *hw_res = resctrl_to_arch_res(r);
> +	int cpu = cpumask_any(&d->hdr.cpu_mask);
>   	struct arch_mbm_state *am;
>   	u64 msr_val, chunks;
> +	u32 prmid;
>   	int ret;
>   
>   	resctrl_arch_rmid_read_context_check();
> @@ -284,7 +327,8 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
>   	if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
>   		return -EINVAL;
>   
> -	ret = __rmid_read(rmid, eventid, &msr_val);
> +	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
> +	ret = __rmid_read_phys(prmid, eventid, &msr_val);
>   	if (ret)
>   		return ret;
>   
> @@ -1022,8 +1066,8 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
>   	int ret;
>   
>   	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
> -	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale;
> -	r->num_rmid = boot_cpu_data.x86_cache_max_rmid + 1;
> +	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
> +	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
>   	hw_res->mbm_width = MBM_CNTR_WIDTH_BASE;
>   
>   	if (mbm_offset > 0 && mbm_offset <= MBM_CNTR_WIDTH_OFFSET_MAX)

Apart from the two spacing related nits this looks good to me.

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

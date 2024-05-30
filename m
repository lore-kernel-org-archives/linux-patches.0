Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E3E8480
	for <patches@lists.linux.dev>; Thu, 30 May 2024 02:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717037194; cv=fail; b=P4bdA9CLE1vcLm/f4qBJh1GYrkfBbHHfORgme7pUVPCPdL3CoLhCRYvdHiCguJ5pfsUrFQML5GzzO6MhKW8Qv95dLrv9IunH5u3baT/VGSUijuReoVj9nFubcnfYUzwTC4XCKCDP4n1xVOXiB68/YQhSwYGI13HqIY8tXHweya4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717037194; c=relaxed/simple;
	bh=z/2w3VbFp7zneUdkizQOYtSqwIO8i3drLekLQXNSBxI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JkyEC8pBhStk0GbdHHUZxN17J3jZuI9NqgKTYpMAsJqfzrIDX2UH3YnBJe612wmdLHgxVNMlKWrxCrg10+DLpk13+mceMrzeOe6tDzZHcqrsXPft2ZaBhsDGQsXMlOiGltSQPGl2Sg55NG/tIbYx00byIInw0BvUJP3UCzYBXPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=STwzVoQR; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="STwzVoQR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717037193; x=1748573193;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z/2w3VbFp7zneUdkizQOYtSqwIO8i3drLekLQXNSBxI=;
  b=STwzVoQRuE1LxVtC93halKw3XwRABk/pwjqcVZz0VooLe5TC6fdjG+5/
   0GapzDsC0DiNjs2576zBbqjoQu39uKhSB/FCfnw+9/jeQHnppilwGFnvA
   vm4fDBG/1B827+hu0QH08RuTnYz41A9+Mfysyc2S1UgIQ3drQawqhwbGv
   wZsDPa6diBCpxe2dUzeaqaqCDM0BYEaJq5J6BW+b7I9j6lUwBTC3H28Y6
   yMv0QTqoA2DGywLg+mllB7pbMsNd+qhcr7d8gzDWyT46+A/9X6+dDT9Er
   +cv5Tpf0iZvfIbzXLcMEysZPBKW65D/ZYO0Dnr78kq/brKCS/L+ixWnIF
   g==;
X-CSE-ConnectionGUID: knzx+k7NRJiQZxnroAd6Cg==
X-CSE-MsgGUID: +PJ0t7nEQ7CQVwoepK6a8g==
X-IronPort-AV: E=McAfee;i="6600,9927,11087"; a="13434790"
X-IronPort-AV: E=Sophos;i="6.08,199,1712646000"; 
   d="scan'208";a="13434790"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2024 19:46:32 -0700
X-CSE-ConnectionGUID: g8hIZ9I9T9u23LnbiBBgEA==
X-CSE-MsgGUID: 2EWJA3crTVO1JL2FtcBe8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,199,1712646000"; 
   d="scan'208";a="35634440"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 May 2024 19:46:32 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 29 May 2024 19:46:31 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 29 May 2024 19:46:31 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 29 May 2024 19:46:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATNeApqPTE3uh163VPF5FKqK05qUknL7c1dfsjghhsnQWTwJJEc/H8/Lw1vfdfwZf+tG5Fuz3yo6wgr75TusxP7/MQemWQBmAsvu0HnqlbqSW/bxTJGi2AThFoAIAIVDEDjjnLLKgppYrD0ay75FzTmvF/YtJcPZMOXCQkBWIU5j8Hcgo1goqAwe7/9DqNZbjFGfrtKI3dp63xOV24h9Yuc827m2oBDWlrro2iHOwKTGVg1FAtzrjDd89EC3XheaoEP+AGMTlkSHrKw4OIKSJmBos6zpX4R+N6j3AA1fxDWoFaa/HWdGjEEtmkbQ8BRH3JgcoSatfPWCL7qCkpwUzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OxxkNJ9a3tinPrqloyOT7hBYEv3Zti1iy2CzjTiaick=;
 b=gX+NUQpZ2Hv1D76B03zxeYqHl3s9WkHJUZGOPW/yVr6/5+/XBN6OUyryGrFr0zViUvEWLCEO33DdQdlDwaeJ/Q7yR0I4Hz6wPfWKoD7rW0ImlMzk/asDAxMsRndvrM57lRNBoM3DQlSFXE5fhQJl3g3CFkdZDFMf/UK+JbUE8o7rWZSxnytdsXHK5UNXwsQ9e+Bbu+B2hJZIZy9LQ2vr/QO9SdqC70Y+VYge85O1bE/70Dcr5XevVjnoP55XUb24jwL//P4fy7PwbjWGZQ9hPrWihpOlsxuGru4xVCrIEw+Ofs7ovlJqJYiHu58JDOTuTDI88qmhNk8/qGZiwURMJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB8492.namprd11.prod.outlook.com (2603:10b6:806:3a3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.17; Thu, 30 May
 2024 02:46:29 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Thu, 30 May 2024
 02:46:29 +0000
Message-ID: <a4d37f57-328f-4456-92bc-5e6469d092c8@intel.com>
Date: Wed, 29 May 2024 19:46:27 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 00/20] Add support for Sub-NUMA cluster (SNC) systems
To: Tony Luck <tony.luck@intel.com>
CC: Fenghua Yu <fenghua.yu@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	<x86@kernel.org>, <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <08ca8fe7-9da6-41da-aad2-0081b789326c@intel.com>
 <ZleODtL_6D-Q_OMX@agluck-desk3.sc.intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ZleODtL_6D-Q_OMX@agluck-desk3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0320.namprd04.prod.outlook.com
 (2603:10b6:303:82::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB8492:EE_
X-MS-Office365-Filtering-Correlation-Id: b3e438b6-674c-492e-76d3-08dc8052b529
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Zyt1UkNtV2NLS3owb3ZGNHZTR0Z0Y1VvTUlnZDlCYk1HL1I1YzFpN1RzOHNr?=
 =?utf-8?B?VkpqL0J2T053bTBxWXIycjF0cFRvZlBwSzdrbk1CakJOOXh0T3BJV3c5cXZE?=
 =?utf-8?B?TStDTzRLaytja0NCMUZNbkEvUU15UDNCQTk4bXdieGRmQWFSQVdib0hibFBn?=
 =?utf-8?B?Y3JCcmhNU2Q1cnFId21kZ2R2MVdYS05zaVlwK1ZBcnBDZFRzV1RMb1dabmNo?=
 =?utf-8?B?VXhxZjU1MWg4RXV1STBScFMvczhhN01wQUUyUUN2VHRCRHp0WWhiNHk1MWRl?=
 =?utf-8?B?eW5jUzJaOFBvQm9CUkFvV1NlLzRzS1VyU1k3L2J2STBEWkFGWm0zaW9BakxJ?=
 =?utf-8?B?Z2x0L3dsWmNrOWJiYm5KczVwV3ZrWTdWV3pCTW90QXhHYmpLSnNWdVN4UzhZ?=
 =?utf-8?B?RVlzQVBZU1l1dWdsL3Z3Tnh0NjdoS1ZpSGhHdE51cWhtQ3FSNmpSNjVNMFU4?=
 =?utf-8?B?ZVJ3USthQXF4dXNyVTVyZmxGcHVuOWtrNndxTVdHN3pWcXlTbFpMWmxJejFO?=
 =?utf-8?B?V21Ob2ZGWHlxWUVMYjdnTklSb3VtUVRubGRrckVnRVRrZStvRWloN2ZnRGRZ?=
 =?utf-8?B?WmViZERJVTB6WE1hWG9DS2ZUN0NyUVNkVEdtUE1OaTk4Z05HSDE5TDdXZDRl?=
 =?utf-8?B?dmFvR0NFd21kRWs4azk0OVFrQklTTWQ2ZzhiUEIrckxwQW9RWHBmQlc5OWFr?=
 =?utf-8?B?bEF0dXlMMGhmU2RzVERNZHRnWjJ0Mm1GQnJOem9QOVo1OXpSMGdJa0M1QVQv?=
 =?utf-8?B?Ryt2OTUraXZSSG5GUis4QndKako3OThGVTJZV0lWK292SU42clpiSTZUYkRq?=
 =?utf-8?B?MGU2dUJha3hDZXZJTEFibWIwUlFXWjVOZnlMcHNkdlE2TitMbUVsSnFDQi90?=
 =?utf-8?B?K1hmZWdNRm00cHJCUGpYZnR6NnBCb2kydnN1ZzloV3VLQSsvSFREZzNXeWtt?=
 =?utf-8?B?YkttU3V4bkFIZmFyWTUzNlhObUNrUGlmTDdxNEZ3RnNYZkJweHBSdzVtQlAw?=
 =?utf-8?B?YVNrbWFtVllDM3J5UEo2UENFTEZpWDFzYVlzcjFPcmxoSHp1eVZueEU2Sm04?=
 =?utf-8?B?aXVockk3OFk2MjVycXpSSTc2MlJUdkorUVkxTy9ZRW9TOXJqVmlobU0zWjlj?=
 =?utf-8?B?VloycWwyVGQrbWtSR2ROU3FiQ1dSTzZ5MjlhYjYwUXFmUWplYzNRa1AvQ252?=
 =?utf-8?B?T2txR1hrTTBsRzZsVzhTcDhtSnNKZXdyc1pSeVZOaXZjbkl0NEx0OW9CZjh5?=
 =?utf-8?B?SSswd2trQWtabTRZanBjL0o4SkZEbkRTaVMyMWpGbW1TbjNvTUdYRUhObm93?=
 =?utf-8?B?RUw2cnNQSmpNMzdTMk9hdGZIdm5KeC9MNENnYkZKbUswSCsyQmpPV2Ztbk9C?=
 =?utf-8?B?a0tnNVVKbHdGc1oxZEhXSnNNTStpRzc0V3JpTWpZSVM1bGVnanFwclRROUpT?=
 =?utf-8?B?NEliT2dyeWFOYW9ZZEQreWRKNTl2WVVjTXMrbDRaU25ySHNhc0c5MXQ4MlFE?=
 =?utf-8?B?TjBkWFBqaUVCcTNwWDJva2dpRmNKM09FR2Q1SWNmWTltZ0dqblZCdEpTNVNr?=
 =?utf-8?B?enNrMWFFY1phNis3TU5ZdU5aNWZHbU16Y0NwcVh1eHRuUWx6Qk55WDEzM2Rr?=
 =?utf-8?B?UHFuM0w1MmR6YzVCa3BiQ093S1BXdXRFdjdFQ1p6Y1VVMFJDb1JwenNyQk5s?=
 =?utf-8?B?V2U2R3N4cVFJQ3pnRStFUUZxcnFwYTVseFVMV1ZTK0g3Rmk4R2NUVzZnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clRjUTh6eDRZbklpd1ZRMWdvN0JGNEZNYXYvdnRJMC9ZN0h5MVNkbHIwR1Y3?=
 =?utf-8?B?Z1pKblpwNFd6Q3VvQmNISTdhTnIxZEZaVlpXbGJvOUJNbFVJYm1XUGtJbi8z?=
 =?utf-8?B?MlNVMmk2WkpmcXFxbjJxL1U2TFcvb0c3Rk8waHBoSXFNZFh4UEVpcUxSZzJz?=
 =?utf-8?B?SWtQYTYrTDFoZE03bmxINVlpZGxpMUJobFJtUUczWjcyYXdkU0REK1pMYzkr?=
 =?utf-8?B?RmdwSzdqTkFIdVRzOERzaWY4cU4zOW9pM2dUZ1NDeStaUXNFSHdnRktwWDUv?=
 =?utf-8?B?cEY5ZnlhbWdKbU0zYnNsSFdRWGZ4MTFTYnh1SStxeElNNENiRzNRUWFyV0d0?=
 =?utf-8?B?SlBJL3RuZkF2Mjlhb1habmNDMFVxckNxc0hyaTQrV3lWb2NsYXNtZVVEeWFn?=
 =?utf-8?B?L0pYZmJHU2d2MFhYQ0ZNYXcyUUhnYXVFcWw1SWtqcXVKMW9BTHJRYXRqNTRE?=
 =?utf-8?B?Nm1sVFJPd3Nkb1ZMZGNjS2NOakIvd0dXY3JOcm5WQ09vSVN1OHM5ZlNqNzdz?=
 =?utf-8?B?MWxGckozYXJwQmd2WXQ4NGs2UDhVbWNMaXl4M0tiLy9RRXVDMDlzd1dVbFEv?=
 =?utf-8?B?aE9wbzZkUUUvZzhialN4ZWkxVkZHZW5VU2s4NkdUcERUTTlPQWJYRXpDYjJY?=
 =?utf-8?B?aWlLSTl3ZXdiU00rNGhpZWVSWFpSWDVSUlJhRmdtNkY5Ry92SWFEdVdTUERa?=
 =?utf-8?B?NG0ybU5sU0VDd2VTSCt5Q1JKdjVwL05SWTliNzFSM2pCUytadStreEZlTWJV?=
 =?utf-8?B?My8wakpDY1QrSjhJbVJIODlZSis1T2FwWk02U2V5Y1NKZXdmSVFwZXM3djVM?=
 =?utf-8?B?dzhpcS9xcC91eDJ1d2FzTU9hNjJaY2JST0RNUWdQYXNHcWt5SG96U2F4V3RF?=
 =?utf-8?B?b2NaaVBZTXMwZHJueCtPajdkTmF0T3RCOTFCdkxZVlVzcDhsTzJlU0Uza3ZS?=
 =?utf-8?B?dHRTdEFpY2NRWk0rdkpmR3FlRkwyTjRYVHp4RDV2WW5KWXRMc2FsZTJ0UDRl?=
 =?utf-8?B?NXdrVldZTWNLWlh1RC92aUtuZHpHYk5yeHBNNllleXZxWUpoOUcxQTVEbmJq?=
 =?utf-8?B?NEVvYkNRTkNweTRCOE96YTdTZmRPQ1lxeklkSGVaR1BFa3pqTXBPa3k5QzAy?=
 =?utf-8?B?Vm84T2xIcFU1U21Xelp3cjlzZkFaZjYzRkJSeW9GNXBtc2ZKcmsvUjFYNkRw?=
 =?utf-8?B?VGovVHBJYTVsWWlYdmUwazAyWFAyd3RCcjMreVlwY2xhblRSclBIWXRhU0w0?=
 =?utf-8?B?RXk0Rk1GYUFGTDR1MWNQcHVYKzBmeDJTUU1teWdCMk4zSDFQdGsvSmtkUW5y?=
 =?utf-8?B?bkdYYnRybXJFV2ZvMDBFTGxpTFJCNW1zM3dtMXlpNlIzVXNTS3VFcFpNU1oz?=
 =?utf-8?B?Q2NmYlhYbWlROEI1TmUyeldLMC8rYXNtcjluZXF2OXlwMEVMeTQyZ2JyTU9v?=
 =?utf-8?B?VGVTd3dRc2RBd1VJS3FzNzBkVU54TklQTkF0TXRmRTlRV1NjdnpJNU1QdDJQ?=
 =?utf-8?B?ZjRsQW5tMlBjNTc0emZGY2l3Mk1MS1FiRlpVaXFSOFVRWjczRlAyaGdINksx?=
 =?utf-8?B?MDQrd1d3a3MyUkhjekRZSWVPVnV4RDNOYisyRXN6T3lsQnoweTlhVUZxbEpI?=
 =?utf-8?B?VVBDNEMzWlFRYVc0V3orZ1VvQjhWWURDc2ZlVzQyaVVjMTFBNHVRbDRWZkli?=
 =?utf-8?B?MFlaVEtOQTQ3TXFldjNRZk1xV2VwOGQ4eFdHL2xtdFRraGxQOHhYMGMyTVZD?=
 =?utf-8?B?VmwwK3l5Tk9aMnZORkM5c0RURGJhYngrTzhaK3N6Y2U1alhKRWNFNEM0Sys4?=
 =?utf-8?B?cUx6WGdiemhkZGlYaFRsc1M0MVV5Sk9xcjJUMFg3bWhWbURDdlc0Q0t3YkVE?=
 =?utf-8?B?RWd0bEtaUlAxQzlheU1YNitMcTBkd1FMMkVvK2drL2JFVWFKaGJGcGc4WWw5?=
 =?utf-8?B?bzF1K3FrMDNwdmxmcHZnR1ltb2pvbDlreUxvQmp3bTFkeXpKT2UrVHhHUzVq?=
 =?utf-8?B?Ym81WDE0NllFK3Q4MkdDYUJwTm1TSEhXUWllNnZvSHU0d1dzalVkWEtTZmIr?=
 =?utf-8?B?ZTZrR3RsRW5zNmtsQkVzU1N6cHQ0OXJ4cmkzdDdhazkrWGZRQU1SSy9EVHdt?=
 =?utf-8?B?bGQ0N0JUUjdyV0FSM2NUTjFMaWtEV29kYm1hNFl5NzNZSFdYQXF0K1ZwakZO?=
 =?utf-8?B?ckE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b3e438b6-674c-492e-76d3-08dc8052b529
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 02:46:29.5827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ln/5Ua9cbcP7rUIPTXiIOmqmzs5x2xxBm4LiPig/nRZnNgHu1iw0dhE3LrgRqYET70j2vtbNOlUxBURU+prkecJ3WUpn8YOc182d0Khwy8g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8492
X-OriginatorOrg: intel.com

Hi Tony,

On 5/29/24 1:20 PM, Tony Luck wrote:
> On Tue, May 28, 2024 at 03:55:29PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>> 13:	Wordsmith commit into imperative.
>>> 	I looked at using kobject_has_children() to check for empty
>>> 	directory, but it needs a "struct kobject *" and all I have
>>> 	is "struct kernfs_node *". I'm now checking how many CPUs
>>
>> Consider how kobject_has_children() uses that struct kobject *.
>> Specifically:
>> 	return kobj->sd && kobj->sd->dir.subdirs
>>
>> It operates on kobj->sd, which is exactly what you have: struct kernfs_node.
> 
> So right. My turn to grumble about other peoples choice of names. If
> that field was named "kn" instead of "sd" I would have spotted this
> too.
> 
>>> 	remain in ci->shared_cpu_map to detect whether this is the
>>> 	last SNC node.
>>
>> hmmm, ok, will take a look ... but please finalize discussion of a patch series
>> before submitting a new series that rejects feedback without discussion and
>> does something completely different in new version.
> 
> Reinette,
> 
> So here's what rmdir_mondata_subdir_allrdtgrp() looks like using the
> subdirs check. It might need an update/better header comment.
> 
> -Tony
> 
> ---
> 
> /*
>   * Remove all subdirectories of mon_data of ctrl_mon groups
>   * and monitor groups with given domain id.

(note comment still considers that domain id is parameter)

>   */
> static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> 					   struct rdt_mon_domain *d)
> {
> 	struct rdtgroup *prgrp, *crgrp;
> 	struct kernfs_node *kn;
> 	char subname[32];

I wonder if static checkers will know that this cannot be used
uninitialized?

> 	char name[32];
> 
> 	sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
> 	if (r->mon_scope != RESCTRL_L3_CACHE) {
> 		/*
> 		 * SNC mode: Unless the last domain is being removed must
> 		 * just remove the SNC subdomain.
> 		 */
> 		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
> 	}
> 
> 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
> 		kn = kernfs_find_and_get(prgrp->mon.mon_data_kn, name);
> 		if (!kn)
> 			continue;
> 
> 		if (kn->dir.subdirs <= 1)
> 			kernfs_remove(kn);
> 		else
> 			kernfs_remove_by_name(kn, subname);
> 
> 		list_for_each_entry(crgrp, &prgrp->mon.crdtgrp_list, mon.crdtgrp_list) {
> 			kn = kernfs_find_and_get(crgrp->mon.mon_data_kn, name);
> 			if (!kn)
> 				continue;
> 
> 			if (kn->dir.subdirs <= 1)
> 				kernfs_remove(kn);
> 			else
> 				kernfs_remove_by_name(kn, subname);
> 		}
> 	}
> }

This solution looks more intuitive to me. I do think that it may be
missing some kernfs_put()'s?

Reinette

ps. Please do give me a couple of days more with this series before you
     submit a new version.

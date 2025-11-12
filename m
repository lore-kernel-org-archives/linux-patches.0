Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD31F33DEDD
	for <patches@lists.linux.dev>; Wed, 12 Nov 2025 19:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762975166; cv=fail; b=ug4NiY5wbxthw2wtgi1/d40/k/ARYojReEeEcs6im5a/VDnCNuE3RL7cNueATPwbV8WxdThqwHu3t0DGG2o4PzVTdSUORloJmsiT92eIZQXVGjHisy7hlBOB1zqsEF4f5MUNdh631DN3UuCvD5r/yfA8G4hy8QpuZEUeDSNTOig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762975166; c=relaxed/simple;
	bh=QW/s+jlutLaPXyrbpDSvSm21gzVampdRAykisp0b8Zg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MmJoHtVtbBMRihIxh7+u4b4mHlObqoW8flMkGzVC5Dl2JVEXF2nzxP1seV+ZJxPaRstIvKg+9HIO0IVUhURKTwzuz5yGzmaZW0Xa/dLociG32FPk9rc2aOwEenh8Kx4heEebU3u+Qqme+w6q/U0XU7fcEd0uus32HFdo4D4F1oU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mk/06O3u; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mk/06O3u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762975165; x=1794511165;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QW/s+jlutLaPXyrbpDSvSm21gzVampdRAykisp0b8Zg=;
  b=Mk/06O3uLHIVFH/aHZbN2kchQR1pVh4OiwzcTjUJqGmwx8SQ3qxhdpvp
   6LJ98D3XrnhJ1cv1JkM9Ck38RdBgX1MGEDGldc5HPcXaH7Opph8lP1jr8
   aICZIBcx0tltr10YCn5WgXFZaX3Ky3s3yFadgxwBdlxgH4DBr2Uw1/9UP
   wqJnqradM3wAAzjV8f+o61/cyyYmixqdRE+9/ZXvdjqP+e8oxB/XkFWa5
   FV3sZziDwHbqKRrW9MEo77RBAguLRu9oUHWceW+S1LEH3oJ1CSCp7yd5g
   YflIP1eQ384DplVyrHScv5dAYwwGfntkO+wWtQWazj+vPyzKkmJIaAkhY
   A==;
X-CSE-ConnectionGUID: s5Z94xUpRaWSpotDS8Q5Cg==
X-CSE-MsgGUID: Xk3t7VBkSsGK2vB6A53rDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="68911314"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="68911314"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 11:19:24 -0800
X-CSE-ConnectionGUID: mKBBRBBsQhyv63Twl+TakA==
X-CSE-MsgGUID: xwWVVuCjRs2kT9GWQlnP0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="194284815"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 11:19:24 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 11:19:23 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 11:19:23 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.71) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 11:19:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bz1C4Hb0WErN3LYVwYs9zLlHyuhZoDto0bCRh3c1Vn+gwLe+0BNPCO0uv4BL1E6otJKrPmcFgiJ00UyMT3ehgomD61RAFPpoRc+qUPVUwm1Gdv/Sir8kt4GnsaqWF9W0+TQHr6Yy9vbs2kVmY1muVI4UJ+4RxwbeE3mBiDXw/GxFlirbY2+iwO7Q8vvPA4CZqrMr/W31ydIT1jBJ6pRPUcH9FZ6sxhzzlOpsQfWoUwf8Jq2Vhl/bosVbY71cGRC7Lpx1Sl+9bkKh+RxazBpQRgaL3ldmhT2XGTSPdi2OHcbwblw0Ts0TbySh3E8Zs21HNmppCG4OTcOhM9iil1iutw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v2YB/8ISh9cm0njL5EcWwdBbjKEPOSEYeA4OqBE3wV8=;
 b=eXdTDuArUZcVctSjU1/HotBChLXkLCNvaCteZ6UvkrU7Xi8T6/rIEPhJcS2AVTtZCeuDJWLjrcD+tZd6bTvpL4+gU2spgMMRnjgrZMVIYLbR1ODKnU5d2UfWyHXgeuGvqSzFeF6x9oQSz24XMYOyCGuf5LXDAY7CC4LVDnWu4uKuTpaOsniFRUQnNahlptk7+4cw/I1wX0ZsFeATYyuBbo6jkO1Vba5f9qvMmeyeNk+dTRiMNth0RYC5GpHM9YUxehxX1VQWwDYpCl8dDUGsVJJxpQL+mzOYSM5vJYA62wbHvhr8mbvmcn3fhXLQHPKTH3r3aT9z7DXnxBgggHuE9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH0PR11MB5283.namprd11.prod.outlook.com (2603:10b6:610:be::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Wed, 12 Nov
 2025 19:19:16 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 19:19:15 +0000
Message-ID: <b31bf54f-9b67-4d25-af6b-c297b6e888a3@intel.com>
Date: Wed, 12 Nov 2025 11:19:13 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 07/32] x86,fs/resctrl: Use struct rdt_domain_hdr when
 reading counters
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-8-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251029162118.40604-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0008.namprd06.prod.outlook.com
 (2603:10b6:303:2a::13) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH0PR11MB5283:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e98c52a-6463-43f9-0cf4-08de22205ea6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?T0xMTjQ4MHRJYUlRNm1TTDcxQktvaWwvZEdsN3VrNks1dGJmWlZpSDJTZjQ0?=
 =?utf-8?B?SWhiVEZvOTNBNzFjd0EwZGRCT2poWEJzeXV1WUtyRjFIYkhTWkQxS0puL1JO?=
 =?utf-8?B?N0puL3AycHpLZUNtQUdpTER5bTBZQi8za05xbzhBWDJBdXUraE51YUFlMnBR?=
 =?utf-8?B?UWhJcnJNcmJLMVBwMFRwdWFPbjdtOERpU05Lc01JRGtrMUpxMTgvMEVUemRZ?=
 =?utf-8?B?ckxIYUppNlNSQll2a3Zvem12S2FWSmhBRkZYV01KdXBLTEtUeXJWZkFJNnFS?=
 =?utf-8?B?cEdQZWw2UG1KTW1VZUpsdjFFeDAvcTQ5MWppZ0ZTTlZnL3V6ZUd0M1dTWUE3?=
 =?utf-8?B?RUp4dUk3WTJGQWNaSFZRckRDWVR3eCtIdHBjazlYTXBCcFZ1SG44b0dGTmIr?=
 =?utf-8?B?Tm5sYXhhNVY1RTRlQXBvcW5pUUx0M0s0TUhKeVJZdVQrL0VjQ2d4Wnc1Smg2?=
 =?utf-8?B?RHMvbzVEbTN5YnowdUdyd3VQUVVTQWIyOWJqeTFjbE9FUkgxWmxHUy8zRnRj?=
 =?utf-8?B?ejNPQzc5THlSaWg0UU9jWXdVRVFjOHRiUGxIUVNlNHVYVGhHMEhHd2hXWXdU?=
 =?utf-8?B?bHR4WW80Nm9LMDkzelp5YWhPamxVNFpwVTExeitpQ1hRelVjT0NmTkVqZ2lm?=
 =?utf-8?B?TUl5UzMxUXVkeFIyRzhIb0dVQ3VpR3FzUGtwWDZjd25HanVJd1hFalh3emh4?=
 =?utf-8?B?bkpCaW10UVNIckxMUEIrZmJZRUJzYXl4Y1pDSDBQaEtVVXUzcWNsNlpUSDlR?=
 =?utf-8?B?RW50dFpMczFBN1cwQ0tWYk84ejY0THh0dlI4WFBYbThmSEkrSTBFVmNGb3VL?=
 =?utf-8?B?ZWFuVmFsNzczNWhTLzJuN3JYWXQ4dzQzTDFCcjl0YWp1cnJGOEUzeGRUb3BP?=
 =?utf-8?B?MVg0dCszVUVjcU9qejJ2ZVovTG5VOEo2TUpMaWRhZ3l4R3lVckZwb0RqRHp5?=
 =?utf-8?B?VlpjSnBJeXRKVXErNERKVGM3T2tJd1J3dTdXSXhjL1VaTVZZU3ZHeWZPdnpk?=
 =?utf-8?B?a0FLbkdHQWp5QmZ6Z0lMVEZJc3ZwWk9FWnY5dSszeUs3QUVXamZlNEVqQ2da?=
 =?utf-8?B?Rkd4aUlpcnlabGlHVC8zVmd4R0wyNlRkTzB6N3liL2s5QzgzL3g1eEtMWmg0?=
 =?utf-8?B?QU5vei80emFONjdhUlg4dFd2VGxvRW9rTzZqN29meHgrSnVLek5YTUJqZk9C?=
 =?utf-8?B?REtYUDAxRFJaL2F6M3hNTUlGRTJZRTZQazNuZE5DRWV6eUVjLzY1Zi9UVHBG?=
 =?utf-8?B?bXdqSHBwRXlPa0Z0dWRjNWdZVHJuMlFzazNLSUlKakZUcGw4bkF1RUJtV3Iz?=
 =?utf-8?B?SGNFTk9YazIweUdsKzBaT0RXbDUvcEpWSnhUZVlFVk4wSlRUd1QyVXhwS01B?=
 =?utf-8?B?VGM5alhlQlZ0ZmM3Zzc2SGdzTlBYVzA1ZzR1Tm9pRTZoSlFieFk3RzROSnNz?=
 =?utf-8?B?RExVVzd6VlpEcHhVVGFaMWFZSjV2TURvZ045QnZVRC9jbHRjazZKanM5OG1T?=
 =?utf-8?B?RDJqTlRuVVoyYzdKVENZc0FJRCsxN2lWUkl3K28vS3R6anQxMXlaQ2lVdVFQ?=
 =?utf-8?B?RjZhcm9YOG9yd2tmVzhPRStxMHViaGN1aU1sdnF0WnRFSk50VkcxREhJcjk5?=
 =?utf-8?B?NXRvVmZsY2FIdFMyQ2d3Q1paSmFva1AxUDJzNmVXcFRXdlpqWHBZV01CMFlr?=
 =?utf-8?B?dU50YkgxTzlQZnlUVkFoU1lreURCZFd3ZjkrMjBrb1NON29DYzRHSm0xblNx?=
 =?utf-8?B?OWNaS0diNTdleWpmMGVoTjl2REt5UE1pK09yVjJSY1NHMGorTkZMbUhtSzA0?=
 =?utf-8?B?VEZRZjFMR1d4dFQ2Kzc3RmV2ak81N1JqWHd4UDMrRzFuTnExc2FaYi82cm1I?=
 =?utf-8?B?aVpPa3BvRy9YVVpNaXZjbnNaaERVQjdoNjVYdlpUU1ZtRUt5ZEY3NGRQT2ti?=
 =?utf-8?Q?lcVjfdPB7QfehrgCm8sWzjkM+WoSj42B?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0VpOWJicUdCUUNsOUtJZWNPM2NrYVRObmE3VE56b1dvdFJiMVBXdXBLMG51?=
 =?utf-8?B?b1RNZW92RmVRSmlMbVdUdk1sdnJ5c1NsMXFocDdpRW1zbGRPWlJIQzk1aFZR?=
 =?utf-8?B?WnNTRlJlNXN4WlAvemFKTmswOW1GY2NnRGh4QlNONzZlbHc5WXFIRUllLzFz?=
 =?utf-8?B?RDh1N0JPSlBQeGJpM0x5UVBHQUtPYUJOTU5aUmxvQ2VRaFNZaVduRGFwaG5x?=
 =?utf-8?B?V3lCclN0MmlvVnZuUmhGVUcwWjBFNjZHTjkxU1U3bnNpUFRWZG5hWnJhRWZV?=
 =?utf-8?B?VmJIT2pvc1VRUG81VXBybnFkajJuWGJjNmJNcjNFWUpwUGZnaEppUEQ5a3Nn?=
 =?utf-8?B?enlHNzVvaDZ5WmNXVFh1YmYvQ05oTmNRWTZlQjNHajRsSEJteUtWdEJhWWJL?=
 =?utf-8?B?ZEt4cEsvYlo4U1pIbjRTRTcrRFBPNUlGdk5menAyaE5DVEpZSnA1bmtMdG83?=
 =?utf-8?B?VDlWZVdzTlVON01HZkJ4L2hjQmhYRVBUb3pQTlJTcExEUm9uOS82R2ZLQ0hS?=
 =?utf-8?B?UVFXZy9WcVhkTGEvaTF2YlFzQ002eUJpWWJJRDRFUjZNU1BZUi9mQ3dzaFEv?=
 =?utf-8?B?RzVYckN4ZDRIcC9LdEE5OEl3UUFaVzA2WWpjRTRpNVN0aVdRYmh6aDJ4OG5S?=
 =?utf-8?B?UEo4bnhsZllsVno3NElMTXhxTzBOY0d1WEcrcUZoUlB2R2hRdHMzdHA1RW5L?=
 =?utf-8?B?R0pzcXlQajNXcHRVUDNNVUNTald0a3JZZVRkckpEZllSM3g4S3l5bGVJNWx5?=
 =?utf-8?B?L1JaL2d2bCt5RU4veldmRm5WclBYKzZpY2VzaDNzZE1ma3lvNUZDMGxEQWlS?=
 =?utf-8?B?YnhtT3pGWEdZa1I1SVllVmFaLzBaVjVvb01ublV1c3pyRGxzTklnUlVsSHlQ?=
 =?utf-8?B?R3FNZnh4YlNScm52Vm9jOVBlV1AvcHJnMEhULzNaTGtZVzRCMnN2Q0ZHZm5E?=
 =?utf-8?B?S1ZaVThKQ3RCM2xRVloyekJJWG5TWUxIeXhCVk9LVXA5aUI0T1RSODVEcVU0?=
 =?utf-8?B?OVkxMHdCOVE2c01sanlYQUhIL01hTGI0WXQrVzBOandnSTNNUVgraEg2YTM5?=
 =?utf-8?B?OSs5aXNBTzFaa3FiTnMxSU5ac09KUzlEVnB2QmVXcy9udXZXK1k0SnJBWXUr?=
 =?utf-8?B?VklEU25zZ1UrSW9aVW1pUlc1ZERKK2JkVDY1cnVka256c1RZVzR1a0E3eDJK?=
 =?utf-8?B?ZVl2ZEZkclRKSTdyQlFvZlNVazlybzJvcmFNVFhsU2NhZG1TS3NaQ0ZLbXQx?=
 =?utf-8?B?Q3hmbVM2K1g0S2JrVjljaU1pc0FhdDd5cmQ1cGtjVi9qQjkydWtDR1IyUWFz?=
 =?utf-8?B?SUJnVXRDVjhMQlVaVjJLUk9ublVhcEtscDJFOWg4RVBJbkFJcnk5bHJGM1lZ?=
 =?utf-8?B?aTNTVUZFZVhWWHE3Q1VIV084V2N4M21sUHdLd1YyZHZxSEV4Z296Q3lNZ2R0?=
 =?utf-8?B?UmxHT2xaVDN5QXo3SWhZY3krQmhEazJ6RTdjT3Z2ck85bGVWeHBxOEdQNFFu?=
 =?utf-8?B?ZlN4d3FnSGZ2dkFnd0Q5bFlnendXUW9wM3hYNjVoWDZqZ3Foakd5Ym1tN2RI?=
 =?utf-8?B?Ui9aRStFYXN5K2FZd1pEeTlRZkxYMUJJL09LcytZQXlnamVEbUVvbGJSOGFX?=
 =?utf-8?B?WlJkQS9OYTM5Y29KODQrS0VzVHNtT1FrcE9odGExeldXc0w1bXBXUWpHcGpI?=
 =?utf-8?B?ZVNsK0dsMkJsVjBmRUJsaFlocFZBeldJbnI4Z0J6Y3p0aGU3VDZhZldEckZt?=
 =?utf-8?B?bnhqZ0xqWm4xU3lmZnh4U29LRkxlbWxEN1F3cDVnUDZWbFFzM2ZLVUR5Y0VB?=
 =?utf-8?B?S0ZQN2oxOWRmQlFXc2tLenovN0JtaDBTeUw5WklFWjFXQy9ZTkRmM0FsaWdB?=
 =?utf-8?B?ZnArVEQ1aHgzbEtoT2tXTVA5dkV4bXJsRUM3UGppVCs1aUJMUjQ4U1dTVEox?=
 =?utf-8?B?cW81WGZWSXZDNkx4NVF5MEpIUkxIU1lyRTVkbVFXU3BETG14bmQ0SzV5djZk?=
 =?utf-8?B?U05sOTVwRmRoSXUwcmlQWlVMMkVLa1VqSEgrdVp1dE5QMkhoVmpVUU9FMGpt?=
 =?utf-8?B?SlNOeDFnS3Jhd0R2WGQwTEF3b0pvYjh3YXllbjZUUlQzWHFIYTV0ejZBNmZQ?=
 =?utf-8?B?dWlPQVYrVzI4YlZnQ0ZEZCtzOUdYQXhwY2pOT1hnWnVWN2F6cnl4NVZpOWhZ?=
 =?utf-8?B?d1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e98c52a-6463-43f9-0cf4-08de22205ea6
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 19:19:15.7772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4R9d1uomcds3PNp7QDBnApco7daj5S5ucAMGMByBRCss/9eD7N52Mv07kZnwpYG9Z6hSsvBOQnB9MJ19s5tP4vmTMNgR6h9+obYt0lxoLW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5283
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/25 9:20 AM, Tony Luck wrote:
> @@ -497,8 +497,18 @@ static int __l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>  static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>  {
>  	switch (rr->r->rid) {
> -	case RDT_RESOURCE_L3:
> -		return __l3_mon_event_count(rdtgrp, rr);
> +	case RDT_RESOURCE_L3: {
> +		struct rdt_mon_domain *d = NULL;
> +
> +		if (rr->hdr) {
> +			if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3)) {
> +				rr->err = -EIO;
> +				return -EINVAL;
> +			}
> +			d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
> +		}
> +		return __l3_mon_event_count(rdtgrp, rr, d);
> +	}

I tried running this series through a static checker and it flagged a few issues related to
this flow. The issues appear to be false positives but it demonstrates that this code is
becoming very hard to understand. Consider, for example, how __l3_mon_event_count() is
structured while thinking about d==NULL:


	__l3_mon_event_count()
	{
		...
		if (rr->is_mbm_cntr) {
			/* dereferences d */
		}

		if (rr->first) {
			/* dereferences d */
			return 0;
		}

		if (d) {
			/* dereferences d */
			return 0;
		}

		/* sum code */
	}

I believe it will be difficult for somebody to trace that rr->is_mbm_cntr and rr->first cannot
be true of d==NULL (the static checker issues supports this). The "if (d)" test that follows
these checks just adds to difficulty by implying that d could indeed be NULL before then.

I see two options to address this. I tried both and the static checker was ok with either. I find the
second option easier to understand than the first, but I share both for context:
option 1:

To make it obvious when the domain can be NULL:

	__l3_mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
	{
		...
		if (rr->hdr) {
			if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3)) {
				rr->err = -EIO;
				return -EINVAL;
			}
			d = container_of(rr->hdr, struct rdt_mon_domain, hdr);

			if (rr->is_mbm_cntr) {
				/* dereferences d */
			}

			if (rr->first) {
				/* dereferences d */
				return 0;
			}

			/* dereferences d */
			return 0;
		}
		
		/* sum code */
	}
	
While easier to understand the above does not make the code easier to read. The function is already quite long
and this adds an additional indentation level. This does not seem necessary since the rr->hdr!=NULL
scenario really just looks like a "function within a function" since it does a "return".
	
This brings to:
option 2:
Split __l3_mon_event_count() into, for example, __l3_mon_event_count() that handles the rr->hdr!=NULL
flow and __l3_mon_event_count_sum() that handles the rr->hdr==NULL flow.
This can be called from __mon_event_count():

	if (rr->hdr)
		return __l3_mon_event_count(rdtgrp, rr);
	else
		return __l3_mon_event_count_sum(rdtgrp, rr);

Option 2 looks like the better option to me. What do you think?

Reinette
